options errorabend nocenter nodate nonumber;

libname sdc '/storage/sas/base/tfn/sdc_ni' access=readonly;
libname ibes '/storage/sas/base/ibes' access=readonly;
libname comp ('/storage/sas/base/comp/d_na'
              '/storage/sas/base/comp/d_na/security') access=readonly;
libname crsp '/storage/sas/base/crsp/a_stock' access=readonly;
libname ccm '/storage/sas/base/crsp/a_ccm' access=readonly;
libname handoff './data/equity_offerings';

title 'W3125018794 Table 7 all-deals preparation';

/* SDC master-deal number is unique in the full 1981-1990 date window. */
data offer_pool;
    length offer_id $10 cusip6 $6 cusip_clean $20;
    set sdc.wrds_ni_details(
        keep=master_deal_no master_deal_date cusip cusip9 security market
             bfo ipo regrights main_tranche
        where=(master_deal_date >= '01jan1981'd and
               master_deal_date <= '31dec1990'd)
    );
    if security ne 'Common Shares' or market ne 'U.S. Public' then delete;
    offer_id = strip(master_deal_no);
    cusip_clean = compress(upcase(cusip),,'kad');
    if lengthn(cusip_clean) < 6 then
        cusip_clean = compress(upcase(cusip9),,'kad');
    if lengthn(cusip_clean) < 6 then delete;
    cusip6 = substr(cusip_clean,1,6);
    issue_date = master_deal_date;
    offer_year = year(issue_date);
    if missing(offer_id) or missing(cusip6) then delete;
    format issue_date yymmdd10.;
    keep offer_id issue_date offer_year cusip6 ipo bfo regrights main_tranche;
run;

proc sql;
    title2 'SDC selected source pool and uniqueness';
    select count(*) as selected_rows,
           count(distinct offer_id) as distinct_offers,
           sum(missing(bfo)) as bfo_missing,
           sum(upcase(strip(ipo))='YES') as ipo_rows,
           sum(upcase(strip(ipo))='NO') as seasoned_rows
    from offer_pool;
quit;

/* Dated CUSIP-to-GVKEY mapping. Do not use the timeless Funda header CUSIP. */
data sec_cusip;
    length cusip6 $6;
    set comp.sec_idhist(
        keep=gvkey iid item itemvalue efffrom effthru
        where=(upcase(item)='CUSIP')
    );
    cusip6 = substr(compress(upcase(itemvalue),,'kad'),1,6);
    if lengthn(cusip6) < 6 then delete;
run;

proc sql;
    title2 'Offer CUSIP matched to Compustat history at the issue date';
    create table cusip_matches as
    select distinct o.offer_id, o.issue_date, o.offer_year, o.cusip6,
                    h.gvkey
    from offer_pool as o
    inner join sec_cusip as h
      on o.cusip6=h.cusip6
     and (missing(h.efffrom) or h.efffrom <= o.issue_date)
     and (missing(h.effthru) or h.effthru >= o.issue_date);
    create table gvkey_counts as
    select o.offer_id, count(distinct m.gvkey) as n_gvkey
    from offer_pool as o
    left join cusip_matches as m on o.offer_id=m.offer_id
    group by o.offer_id;
    create table event_gvkey as
    select m.offer_id, m.issue_date, m.offer_year, m.cusip6, m.gvkey
    from cusip_matches as m
    inner join gvkey_counts as c on m.offer_id=c.offer_id
    where c.n_gvkey=1;
quit;

proc sql;
    title2 'Dated Compustat identifier mapping counts';
    select count(*) as sdc_offers,
           sum(n_gvkey=0) as no_cusip_match,
           sum(n_gvkey=1) as one_gvkey,
           sum(n_gvkey>1) as ambiguous_gvkey
    from gvkey_counts;
quit;

/* Dated CCM links and CRSP names validate a common issue at the offer date. */
proc sql;
    create table ccm_candidates as
    select distinct g.offer_id, g.issue_date, g.offer_year, g.cusip6,
           g.gvkey, l.lpermno as permno, upcase(l.linkprim) as linkprim,
           upcase(l.linktype) as linktype
    from event_gvkey as g
    inner join ccm.ccmxpf_linktable as l on g.gvkey=l.gvkey
    where upcase(l.linktype) in ('LC','LU')
      and upcase(l.linkprim) in ('P','C')
      and not missing(l.lpermno)
      and (missing(l.linkdt) or l.linkdt <= g.issue_date)
      and (missing(l.linkenddt) or l.linkenddt >= g.issue_date);

    create table crsp_name_matches as
    select distinct c.offer_id, c.issue_date, c.offer_year, c.cusip6,
           c.gvkey, c.permno, c.linkprim, c.linktype,
           n.shrcd, n.ncusip
    from ccm_candidates as c
    inner join crsp.msenames as n on c.permno=n.permno
    where n.shrcd in (10,11)
      and n.namedt <= c.issue_date
      and (missing(n.nameendt) or n.nameendt >= c.issue_date)
      and substr(upcase(n.ncusip),1,6)=c.cusip6;
quit;

proc sql;
    create table link_counts0 as
    select offer_id, linkprim, count(distinct permno) as n_permno
    from crsp_name_matches
    group by offer_id, linkprim;
quit;

proc sort data=link_counts0 out=link_counts;
    by offer_id;
run;

data link_stats;
    set link_counts;
    by offer_id;
    retain n_primary n_compustat;
    if first.offer_id then do;
        n_primary=0;
        n_compustat=0;
    end;
    if linkprim='P' then n_primary=n_permno;
    else if linkprim='C' then n_compustat=n_permno;
    if last.offer_id then output;
    keep offer_id n_primary n_compustat;
run;

proc sql;
    create table link_stats_all as
    select g.offer_id,
           coalesce(s.n_primary,0) as n_primary,
           coalesce(s.n_compustat,0) as n_compustat
    from event_gvkey as g
    left join link_stats as s on g.offer_id=s.offer_id;

    create table crsp_link as
    select distinct c.offer_id, c.issue_date, c.offer_year, c.cusip6,
           c.gvkey, c.permno, c.linkprim
    from crsp_name_matches as c
    inner join link_stats as s on c.offer_id=s.offer_id
    where (s.n_primary=1 and c.linkprim='P') or
          (s.n_primary=0 and s.n_compustat=1 and c.linkprim='C');
quit;

proc sql;
    title2 'Dated CCM and CRSP name-link counts';
    select count(*) as offers_with_unique_gvkey,
           sum(n_primary=0 and n_compustat=0) as no_primary_or_comp_link,
           sum(n_primary>1 or (n_primary=0 and n_compustat>1)) as ambiguous_links
    from link_stats_all;
    select count(*) as one_permno_links,
           count(distinct offer_id) as unique_linked_offers
    from crsp_link;
quit;

/* Annual Compustat IB observations: INDL / consolidated / domestic / standard. */
data funda_hist;
    set comp.funda(
        keep=gvkey datadate fyear indfmt consol popsrc datafmt fdate pdate
             ib curcd
        where=(fyear >= 1981 and fyear <= 1995 and indfmt='INDL' and
               consol='C' and popsrc='D' and datafmt='STD')
    );
run;

proc sql;
    title2 'Compustat selected annual source and remaining duplicate keys';
    select count(*) as source_rows,
           count(distinct gvkey) as distinct_gvkeys,
           sum(missing(ib)) as missing_ib
    from funda_hist;
    select count(*) as duplicate_keys,
           sum(n-1) as excess_rows
    from (select gvkey, fyear, count(*) as n
          from funda_hist
          group by gvkey, fyear
          having calculated n > 1);
quit;

proc sort data=funda_hist out=funda_sorted;
    by gvkey fyear descending fdate descending pdate descending datadate;
run;

data funda_annual;
    set funda_sorted;
    by gvkey fyear;
    if first.fyear;
run;

/* Six offer-year through offer-year+5 annual positions per uniquely linked GVKEY. */
data earn_grid;
    set event_gvkey(keep=offer_id gvkey issue_date offer_year);
    do position=0 to 5;
        fyear=offer_year+position;
        trend=position;
        output;
    end;
    keep offer_id gvkey issue_date offer_year fyear position trend;
run;

proc sql;
    create table earn_long as
    select g.offer_id, g.gvkey, g.issue_date, g.offer_year,
           g.fyear, g.position, g.trend, f.ib, f.curcd
    from earn_grid as g
    left join funda_annual as f
      on g.gvkey=f.gvkey and g.fyear=f.fyear;
quit;

data earn_long;
    set earn_long;
    log_ib=.;
    if not missing(ib) and ib>0 then log_ib=log(ib);
run;

proc sql;
    create table growth_meta as
    select offer_id,
           sum(case when not missing(log_ib) then 1 else 0 end) as n_positive,
           sum(case when not missing(log_ib) and missing(curcd) then 1 else 0 end) as n_missing_currency,
           count(distinct case when not missing(log_ib) and not missing(curcd)
                               then curcd end) as n_currencies,
           max(case when position=0 and not missing(log_ib) then 1 else 0 end) as first_ok,
           max(case when position=5 and not missing(log_ib) then 1 else 0 end) as last_ok
    from earn_long
    group by offer_id;
quit;

proc sort data=earn_long;
    by offer_id;
run;
proc sort data=growth_meta;
    by offer_id;
run;

data earn_fit;
    merge earn_long(in=in_earn) growth_meta(in=in_meta);
    by offer_id;
    if in_earn and in_meta and first_ok=1 and last_ok=1 and
       n_positive>=2 and n_currencies=1 and n_missing_currency=0 and
       not missing(log_ib);
run;

proc sort data=earn_fit;
    by offer_id;
run;

proc reg data=earn_fit outest=gr_est noprint;
    by offer_id;
    model log_ib=trend;
run;
quit;

proc sort data=growth_meta;
    by offer_id;
run;
proc sort data=gr_est;
    by offer_id;
run;

data growth_offer;
    merge growth_meta(in=in_meta) gr_est(in=in_est);
    by offer_id;
    if in_meta;
    realized_growth=.;
    if in_est and not missing(trend) then realized_growth=exp(trend)-1;
    label realized_growth='Five-year annualized growth from fitted log earnings slope';
run;

proc sql;
    title2 'Per-offer realized-growth support-fit eligibility and rank inputs';
    select count(*) as offers_with_gvkey,
           sum(first_ok=1 and last_ok=1) as endpoints_present,
           sum(first_ok=1 and last_ok=1 and n_currencies=1 and
               n_missing_currency=0 and n_positive>=2) as fit_eligible,
           sum(not missing(realized_growth)) as estimates_returned,
           sum(missing(realized_growth)) as estimates_unavailable
    from growth_offer;
quit;

proc means data=growth_meta n mean min p25 p50 p75 max;
    title2 'Number of positive annual earnings observations per offer growth fit';
    var n_positive;
run;

/* Average every nonmissing detail LTG forecast per offer in the exact date window. */
data ibes_ltg;
    length cusip6 $6 cusip_clean $20;
    set ibes.det_epsus(
        keep=ticker cusip analys fpi measure value anndats
        where=(anndats >= '01jan1980'd and anndats <= '31dec1991'd and
               fpi='0' and measure='EPS')
    );
    cusip_clean=compress(upcase(cusip),,'kad');
    if lengthn(cusip_clean) < 6 then delete;
    cusip6=substr(cusip_clean,1,6);
run;

proc sql;
    create table forecast_matches as
    select o.offer_id, o.issue_date, o.offer_year, f.ticker, f.analys,
           f.anndats, f.value
    from offer_pool as o
    inner join ibes_ltg as f on o.cusip6=f.cusip6
    where f.anndats >= intnx('month',o.issue_date,-9,'same')
      and f.anndats <= intnx('month',o.issue_date,3,'same');

    create table offer_forecast as
    select o.offer_id,
           sum(case when not missing(f.value) then 1 else 0 end)
               as n_forecasts,
           mean(f.value)/100 as forecast_growth,
           sum(case when not missing(f.value) and
                         (f.value < -100 or f.value > 100)
                    then 1 else 0 end)
               as n_outside_table3_range
    from offer_pool as o
    left join forecast_matches as f on o.offer_id=f.offer_id
    group by o.offer_id;
quit;

proc sql;
    title2 'I/B/E/S window and Table 3 range diagnostics';
    select count(*) as matched_detail_rows,
           count(distinct offer_id) as offers_with_any_fpi0,
           sum(value < -100 or value > 100) as out_of_range_detail_rows
    from forecast_matches;
    select sum(n_forecasts>0) as offers_with_valid_growth,
           sum(n_outside_table3_range) as out_of_range_by_offer
    from offer_forecast;
quit;

/* Return grid spans 60 monthly intervals from t+3 month-end to t+63 month-end. */
data ret_grid;
    set crsp_link(keep=offer_id gvkey permno issue_date offer_year);
    event_month=intnx('month',issue_date,0,'b');
    do month_offset=4 to 63;
        month_key=intnx('month',event_month,month_offset,'b');
        output;
    end;
    format event_month month_key yymmdd10.;
    keep offer_id gvkey permno issue_date offer_year event_month
         month_offset month_key;
run;

data stock_month;
    set crsp.msf(
        keep=permno date ret
        where=(date >= '01may1981'd and date <= '31mar1996'd)
    );
    month_key=intnx('month',date,0,'b');
    stock_date=date;
    stock_ret=ret;
    format month_key stock_date yymmdd10.;
    keep permno month_key stock_date stock_ret;
run;

data market_month;
    set crsp.msi(
        keep=date vwretd
        where=(date >= '01may1981'd and date <= '31mar1996'd)
    );
    month_key=intnx('month',date,0,'b');
    market_date=date;
    market_ret=vwretd;
    format month_key market_date yymmdd10.;
    keep month_key market_date market_ret;
run;

proc sql;
    create table ret_panel as
    select g.offer_id, g.gvkey, g.permno, g.issue_date, g.offer_year,
           g.month_offset, g.month_key,
           s.stock_date, s.stock_ret, m.market_date, m.market_ret
    from ret_grid as g
    left join stock_month as s
      on g.permno=s.permno and g.month_key=s.month_key
    left join market_month as m on g.month_key=m.month_key
    order by g.offer_id, g.month_key;
quit;

proc sort data=ret_panel;
    by offer_id month_key;
run;

data return_summary;
    set ret_panel;
    by offer_id;
    retain n_months n_stock n_market miss_stock miss_market
           stock_product market_product stock_date_start stock_date_end;
    if first.offer_id then do;
        n_months=0;
        n_stock=0;
        n_market=0;
        miss_stock=0;
        miss_market=0;
        stock_product=1;
        market_product=1;
        stock_date_start=.;
        stock_date_end=.;
    end;
    n_months+1;
    if not missing(stock_date) then do;
        if missing(stock_date_start) then stock_date_start=stock_date;
        stock_date_end=stock_date;
    end;
    if missing(stock_ret) then miss_stock+1;
    else do;
        n_stock+1;
        stock_product=stock_product*(1+stock_ret);
    end;
    if missing(market_ret) then miss_market+1;
    else do;
        n_market+1;
        market_product=market_product*(1+market_ret);
    end;
    if last.offer_id then do;
        n_return_months=n_months;
        stock_buyhold=stock_product-1;
        market_buyhold=market_product-1;
        abnormal_return=.;
        if n_months=60 and n_stock=60 and n_market=60 and
           miss_stock=0 and miss_market=0 then
            abnormal_return=stock_buyhold-market_buyhold;
        output;
    end;
    format stock_date_start stock_date_end yymmdd10.;
    keep offer_id n_return_months n_stock n_market miss_stock miss_market
         stock_buyhold market_buyhold abnormal_return stock_date_start stock_date_end;
run;

/* Merge all offering-level constructions and retain only the common baseline sample. */
proc sql;
    create table analysis_all0 as
    select o.offer_id, o.issue_date, o.offer_year, o.cusip6, o.ipo,
           g.gvkey, r.permno,
           f.n_forecasts, f.forecast_growth, f.n_outside_table3_range,
           gr.n_positive as n_growth_points,
           gr.n_currencies, gr.first_ok, gr.last_ok,
           gr.trend as realized_growth_slope,
           gr.realized_growth,
           ret.n_return_months, ret.n_stock, ret.n_market,
           ret.stock_buyhold, ret.market_buyhold, ret.abnormal_return,
           ret.stock_date_start, ret.stock_date_end
    from offer_pool as o
    left join event_gvkey as g on o.offer_id=g.offer_id
    left join crsp_link as r on o.offer_id=r.offer_id
    left join offer_forecast as f on o.offer_id=f.offer_id
    left join growth_offer as gr on o.offer_id=gr.offer_id
    left join return_summary as ret on o.offer_id=ret.offer_id;
quit;

data analysis_all;
    set analysis_all0;
    if missing(n_forecasts) then n_forecasts=0;
    if missing(n_growth_points) then n_growth_points=0;
    if missing(n_return_months) then n_return_months=0;
    comp_linked=not missing(gvkey);
    crsp_linked=not missing(permno);
    forecast_ok=(n_forecasts>0 and not missing(forecast_growth));
    growth_ok=not missing(realized_growth);
    return_ok=(n_return_months=60 and not missing(abnormal_return));
    complete_sample=(comp_linked and crsp_linked and forecast_ok and
                     growth_ok and return_ok);
    forecast_error=realized_growth-forecast_growth;
run;

proc sql;
    title2 'Offer-level sample construction and retained Table 7 sample';
    select count(*) as sdc_offers,
           sum(comp_linked) as compustat_linked,
           sum(crsp_linked) as crsp_linked,
           sum(comp_linked and crsp_linked) as linked_both,
           sum(forecast_ok) as forecast_window_usable,
           sum(growth_ok) as realized_growth_fit,
           sum(return_ok) as complete_60_month_return,
           sum(complete_sample) as final_complete_offers
    from analysis_all;
    select offer_year, count(*) as sdc_offers,
           sum(complete_sample) as final_complete_offers,
           sum(forecast_ok) as forecast_window_usable,
           sum(growth_ok) as realized_growth_fit,
           sum(return_ok) as complete_60_month_return
    from analysis_all
    group by offer_year
    order by offer_year;
quit;

data handoff.equity_offerings;
    set analysis_all;
    where complete_sample=1;
    label offer_id='SDC master deal identifier'
          issue_date='SDC issue date'
          offer_year='Calendar year of issue'
          forecast_growth='Mean I/B/E/S long-term forecast growth (decimal)'
          realized_growth='Five-year annualized realized earnings growth (decimal)'
          forecast_error='Realized growth minus forecast growth'
          abnormal_return='Five-year compounded stock minus market return'
          stock_buyhold='Five-year compounded CRSP stock return'
          market_buyhold='Five-year compounded CRSP value-weighted market return'
          n_forecasts='Qualifying I/B/E/S detail forecasts in offer window'
          n_return_months='Observed CRSP monthly return periods';
    keep offer_id issue_date offer_year cusip6 gvkey permno forecast_growth
         realized_growth forecast_error abnormal_return stock_buyhold
         market_buyhold n_forecasts n_return_months;
run;

proc sql;
    title2 'Final handoff row count and key uniqueness';
    select count(*) as final_rows,
           count(distinct offer_id) as distinct_offer_ids,
           sum(missing(forecast_growth)) as missing_forecast_growth,
           sum(missing(realized_growth)) as missing_realized_growth,
           sum(missing(forecast_error)) as missing_forecast_error,
           sum(missing(abnormal_return)) as missing_abnormal_return
    from handoff.equity_offerings;
quit;

proc means data=handoff.equity_offerings n nmiss mean std min p25 p50 p75 max;
    title2 'Final per-offer regression-input distributions';
    var abnormal_return realized_growth forecast_growth forecast_error
        n_forecasts n_return_months;
run;
