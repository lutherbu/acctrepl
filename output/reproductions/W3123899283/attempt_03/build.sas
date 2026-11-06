options errorabend nodate nonumber nocenter;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname fx "/storage/sas/base/comp/d_global/currency" access=readonly;
libname out "data";

/* Provider source: COMP.FUNDA. Use only catalog-listed fields and preserve GVKEY. */
proc freq data=comp.funda;
    where fyear between 1983 and 2004 and fyr=12;
    tables indfmt datafmt consol popsrc curcd curncd / missing;
    title "COMP.FUNDA code and currency distribution, fiscal year-end month 12";
run;

data raw;
    set comp.funda(keep=gvkey datadate fyear fyr indfmt datafmt consol popsrc at ib ibc oancf curcd curncd currtr);
    where fyear between 1983 and 2004
      and fyr=12
      and upcase(indfmt)='INDL'
      and upcase(datafmt)='STD'
      and upcase(consol)='C'
      and upcase(popsrc)='D';
run;

proc sort data=raw out=annual;
    by gvkey fyear;
run;

/* Fail on duplicate firm-year keys rather than selecting an arbitrary report. */
data duplicate_keys;
    set annual;
    by gvkey fyear;
    if first.fyear and last.fyear then delete;
run;
proc sql noprint;
    select count(*) into :duplicate_rows trimmed from duplicate_keys;
quit;
%put NOTE: Duplicate GVKEY-FYEAR rows after Compustat format filters = &duplicate_rows.;
%if %sysevalf(&duplicate_rows > 0) %then %do;
    %put ERROR: COMP.FUNDA is not unique on the selected annual firm-year key.;
    %abort cancel;
%end;

/* Balance-sheet amounts use the daily balance-sheet FX quote at their own
   DATADATE. Xpressfeed uses GBP as the primary currency: source currency
   amounts are divided by GBP-to-source and multiplied by GBP-to-USD. */
data fx_raw;
    set fx.g_exrt_dly(keep=datadate fromcurd tocurd exratd exrattpd);
    where datadate >= '01JAN1983'd and datadate <= '31DEC2004'd
      and upcase(strip(fromcurd))='GBP';
    length fx_curcd $3;
    fx_curcd=upcase(strip(tocurd));
    if missing(fx_curcd) then delete;
run;

proc sql;
    create table fx_agg as
    select datadate, fx_curcd,
           count(*) as quote_count,
           sum(case when not missing(exratd) and exratd>0 then 1 else 0 end) as positive_count,
           max(exratd) as rate_max,
           max(exrattpd) as type_max
    from fx_raw
    group by datadate,fx_curcd;
quit;

data fx_one;
    set fx_agg;
    length fx_type $2;
    fx_rate=.;
    fx_type=' ';
    if quote_count=1 and positive_count=1 then do;
        fx_rate=rate_max;
        fx_type=type_max;
    end;
    label fx_rate='Positive unique GBP-to-currency daily quote'
          fx_type='Unaltered EXRATTPD provenance descriptor';
    keep datadate fx_curcd quote_count positive_count fx_rate fx_type;
run;

proc sql;
    select count(*) as date_currency_groups,
           sum(quote_count=1 and positive_count=1) as positive_unique_quotes,
           sum(quote_count ne 1) as ambiguous_duplicate_groups,
           sum(quote_count=1 and positive_count ne 1) as unique_nonpositive_or_missing
    from fx_one;
    title 'Daily GBP quote uniqueness and positivity audit';
quit;

/* Mixed or blank EXRATTPD is provenance, not a currency incompatibility.
   The 31-Dec-1999 fixture has a blank CAD descriptor and AR USD descriptor. */
proc sql;
    create table fx_fixture0 as
    select '31DEC1999'd as datadate format=date9.,
           max(case when fx_curcd='CAD' then fx_rate else . end) as gbp_cad,
           max(case when fx_curcd='CAD' then quote_count else . end) as cad_quote_n,
           max(case when fx_curcd='CAD' then positive_count else . end) as cad_positive_n,
           max(case when fx_curcd='CAD' then fx_type else ' ' end) as cad_type,
           max(case when fx_curcd='USD' then fx_rate else . end) as gbp_usd,
           max(case when fx_curcd='USD' then quote_count else . end) as usd_quote_n,
           max(case when fx_curcd='USD' then positive_count else . end) as usd_positive_n,
           max(case when fx_curcd='USD' then fx_type else ' ' end) as usd_type
    from fx_one
    where datadate='31DEC1999'd;
quit;

data fx_fixture;
    set fx_fixture0;
    fixture_assets_cad=100;
    if cad_quote_n=1 and cad_positive_n=1 and usd_quote_n=1 and usd_positive_n=1
       and gbp_cad>0 and gbp_usd>0 then do;
        fixture_gbp=fixture_assets_cad/gbp_cad;
        fixture_assets_usd=fixture_gbp*gbp_usd;
        fixture_direct=fixture_assets_cad*(gbp_usd/gbp_cad);
        wrong_direction=fixture_assets_cad*gbp_cad/gbp_usd;
    end;
    fixture_ok=(cad_quote_n=1 and cad_positive_n=1 and usd_quote_n=1 and usd_positive_n=1
                and gbp_cad>0 and gbp_usd>0 and cad_type ne usd_type
                and abs(fixture_assets_usd-fixture_direct)<1e-12
                and abs(fixture_assets_usd-wrong_direction)>1e-6);
run;
proc print data=fx_fixture noobs;
    var datadate fixture_assets_cad gbp_cad cad_type gbp_usd usd_type
        fixture_assets_usd wrong_direction fixture_ok;
    title 'Bounded FX arithmetic fixture with unequal rates and mixed provenance';
run;
proc sql noprint;
    select sum(fixture_ok) into :fx_fixture_pass trimmed from fx_fixture;
quit;
%if %sysevalf(&fx_fixture_pass ne 1) %then %do;
    %put ERROR: The dated unequal-rate FX fixture failed.;
    %abort cancel;
%end;

/* Join own-date source and target legs. A2's CURRTR conversion is retained
   only as a comparison diagnostic; it does not determine the size screen. */
proc sql;
    create table annual_fx0 as
    select a.*,
           s.quote_count as src_quote_n, s.positive_count as src_positive_n,
           s.fx_rate as gbp_to_src, s.fx_type as src_fx_type,
           u.quote_count as usd_quote_n, u.positive_count as usd_positive_n,
           u.fx_rate as gbp_to_usd, u.fx_type as usd_fx_type
    from annual as a
    left join fx_one as s
      on a.datadate=s.datadate and upcase(strip(a.curcd))=s.fx_curcd
    left join fx_one as u
      on a.datadate=u.datadate and u.fx_curcd='USD'
    order by a.gvkey,a.fyear;
quit;

proc sql;
    select curcd, count(*) as annual_rows,
           sum(upcase(strip(curcd))='USD') as usd_identity_rows,
           sum(upcase(strip(curcd)) not in ('USD','GBP')
               and src_quote_n=1 and src_positive_n=1 and gbp_to_src>0) as source_leg_positive_unique,
           sum(upcase(strip(curcd)) ne 'USD'
               and usd_quote_n=1 and usd_positive_n=1 and gbp_to_usd>0) as usd_target_positive_unique,
           sum(upcase(strip(curcd)) not in ('USD','GBP')
               and src_quote_n=1 and src_positive_n=1 and gbp_to_src>0
               and usd_quote_n=1 and usd_positive_n=1 and gbp_to_usd>0) as crossrate_positive_unique
    from annual_fx0
    where fyear between 1984 and 2004
    group by curcd;
    title 'Own-DATADATE positive unique source and USD target legs by CURCD';
quit;

data annual_fx;
    set annual_fx0;
    length fx_route $24;
    at_usd=.;
    at_usd_a2=.;
    if missing(strip(curcd)) then do;
        fx_route='Unknown currency';
        src_quote_n=.; src_positive_n=.; gbp_to_src=.; src_fx_type=' ';
        usd_quote_n=.; usd_positive_n=.; gbp_to_usd=.; usd_fx_type=' ';
    end;
    else if missing(at) then do;
        fx_route='No total assets';
        src_quote_n=.; src_positive_n=.; gbp_to_src=.; src_fx_type=' ';
        usd_quote_n=.; usd_positive_n=.; gbp_to_usd=.; usd_fx_type=' ';
    end;
    else if at<=0 then do;
        fx_route='Nonpositive assets';
        src_quote_n=.; src_positive_n=.; gbp_to_src=.; src_fx_type=' ';
        usd_quote_n=.; usd_positive_n=.; gbp_to_usd=.; usd_fx_type=' ';
    end;
    else if upcase(strip(curcd))='USD' then do;
        at_usd=at;
        fx_route='USD identity';
        src_quote_n=.;
        src_positive_n=.;
        gbp_to_src=.;
        src_fx_type=' ';
        usd_quote_n=.;
        usd_positive_n=.;
        gbp_to_usd=.;
        usd_fx_type=' ';
    end;
    else if upcase(strip(curcd))='GBP' and at>0
        and usd_quote_n=1 and usd_positive_n=1 and gbp_to_usd>0 then do;
        at_usd=at*gbp_to_usd;
        fx_route='GBP target leg';
        src_quote_n=.;
        src_positive_n=.;
        gbp_to_src=1;
        src_fx_type=' ';
    end;
    else if not missing(strip(curcd)) and upcase(strip(curcd)) not in ('USD','GBP') and at>0
        and src_quote_n=1 and src_positive_n=1 and gbp_to_src>0
        and usd_quote_n=1 and usd_positive_n=1 and gbp_to_usd>0 then do;
        at_usd=(at/gbp_to_src)*gbp_to_usd;
        fx_route='Cross-rate via GBP';
    end;
    else fx_route='FX quote unavailable';

    if upcase(strip(curcd))='USD' then at_usd_a2=at;
    else if not missing(currtr) then at_usd_a2=at*currtr;
    label at_usd='Total assets converted to USD by dated Xpressfeed FX'
          at_usd_a2='A2 CURRTR threshold value for comparison only'
          gbp_to_src='Daily GBP-to-source quote at own DATADATE'
          gbp_to_usd='Daily GBP-to-USD target quote at own DATADATE'
          src_fx_type='Source-leg EXRATTPD provenance'
          usd_fx_type='USD-leg EXRATTPD provenance';
run;

/* Average assets and scaled flows need known compatible currencies on their
   own current and exact prior-year rows. */
proc sql;
    create table yearly as
    select a.gvkey, a.fyear, a.datadate, a.fyr, a.indfmt, a.datafmt, a.consol,
           a.popsrc, a.at, a.ib, a.ibc, a.oancf, a.curcd, a.curncd, a.currtr,
           a.at_usd, a.at_usd_a2, a.fx_route, a.gbp_to_src, a.gbp_to_usd,
           a.src_fx_type, a.usd_fx_type, a.src_quote_n, a.src_positive_n,
           a.usd_quote_n, a.usd_positive_n,
           b.at as at_lag1, b.curcd as curcd_lag1, b.curncd as curncd_lag1,
           case when a.at>0 and b.at>0
                     and not missing(strip(a.curcd)) and not missing(strip(b.curcd))
                     and upcase(strip(a.curcd))=upcase(strip(b.curcd))
                then (a.at+b.at)/2 else . end as avg_at,
           case when a.at>0 and b.at>0
                     and not missing(strip(a.curcd)) and not missing(strip(b.curcd))
                     and upcase(strip(a.curcd))=upcase(strip(b.curcd))
                then a.ibc/((a.at+b.at)/2) else . end as earn,
           case when a.at>0 and b.at>0
                     and not missing(strip(a.curcd)) and not missing(strip(b.curcd))
                     and upcase(strip(a.curcd))=upcase(strip(b.curcd))
                then a.oancf/((a.at+b.at)/2) else . end as cfo,
           case when missing(b.gvkey) then 'No prior row'
                when missing(strip(a.curcd)) or missing(strip(b.curcd)) then 'Unknown currency'
                when upcase(strip(a.curcd))=upcase(strip(b.curcd)) then 'Compatible'
                else 'Currency change' end as ratio_currency_status length=16,
           (not missing(strip(a.curcd)) and not missing(strip(b.curcd))
                and upcase(strip(a.curcd)) ne upcase(strip(b.curcd))) as currency_mismatch
    from annual_fx as a
    left join annual_fx as b
      on a.gvkey=b.gvkey and a.fyear=b.fyear+1
    order by a.gvkey,a.fyear;
quit;

proc freq data=yearly;
    where fyear between 1984 and 2004;
    tables curcd curcd_lag1 ratio_currency_status currency_mismatch
           fx_route src_fx_type usd_fx_type / missing;
    title 'Selected Compustat currencies, ratio eligibility, FX routes, and quote provenance';
run;
proc means data=yearly n mean min max maxdec=4;
    class curcd;
    var currtr at_usd at_usd_a2 gbp_to_src gbp_to_usd;
    title 'Current and A2 comparison USD assets and dated FX legs by reporting currency';
run;
proc sql;
    select curcd, count(*) as annual_rows,
           sum(at_usd_a2>=100) as a2_assets_ge_100,
           sum(at_usd>=100) as dated_fx_assets_ge_100,
           sum(at_usd_a2>=100 and (missing(at_usd) or at_usd<100)) as a2_only_ge_100,
           sum(at_usd>=100 and (missing(at_usd_a2) or at_usd_a2<100)) as dated_fx_only_ge_100
    from yearly
    where fyear between 1984 and 2004
    group by curcd;
    title 'A2 versus dated-FX $100 million threshold movements by current CURCD';
quit;
proc sql;
    select curcd, count(*) as annual_rows,
           sum(not missing(earn) and not missing(cfo)) as ratio_complete_rows,
           sum(not missing(earn) and not missing(cfo) and at_usd_a2>=100) as a2_ratio_complete_ge_100,
           sum(not missing(earn) and not missing(cfo) and at_usd>=100) as dated_fx_ratio_complete_ge_100,
           sum(not missing(earn) and not missing(cfo) and at_usd_a2>=100
               and (missing(at_usd) or at_usd<100)) as a2_only_ratio_complete_ge_100,
           sum(not missing(earn) and not missing(cfo) and at_usd>=100
               and (missing(at_usd_a2) or at_usd_a2<100)) as fx_only_comp_ge_100
    from yearly
    where fyear between 1984 and 2004
    group by curcd;
    title 'Threshold movements among rows with valid same-currency ratios';
quit;
proc sql;
    select fyear, curcd, count(*) as annual_rows,
           sum(at_usd_a2>=100 and at_usd>=100) as both_ge_100,
           sum(at_usd_a2>=100 and (missing(at_usd) or at_usd<100)) as a2_only_ge_100,
           sum(at_usd>=100 and (missing(at_usd_a2) or at_usd_a2<100)) as dated_fx_only_ge_100,
           sum(missing(at_usd)) as dated_fx_unavailable
    from yearly
    where fyear between 1988 and 2004 and upcase(strip(curcd))='CAD'
    group by fyear,curcd
    order by fyear,curcd;
    title 'CAD threshold movements by fiscal year';
quit;

/* Table 1 stage checks on the 1984-2004 annual population. */
proc sql;
    select count(*) as rows_after_compustat_filters,
           sum(not missing(at) and not missing(ib) and not missing(oancf)) as complete_ib_and_cfo_items,
           sum(not missing(at) and not missing(ibc) and not missing(oancf)) as complete_ibc_and_cfo_items,
           sum(not missing(earn) and not missing(cfo)) as complete_scaled_items,
           sum(not missing(earn) and not missing(cfo) and at_usd>=100) as complete_scaled_and_usd_size
    from yearly
    where fyear between 1984 and 2004;
    title "Sample attrition checkpoints compared with Table 1";
quit;

/* Exact annual fiscal-year joins keep gaps as missing. The four prior scaled
   earnings and CFO values are construction history, not row-position lags. */
proc sql;
    create table candidate0 as
    select c.gvkey, c.fyear, c.datadate, c.fyr, c.at, c.at_usd,
           c.curcd, c.curcd_lag1, c.curncd, c.ratio_currency_status,
           c.fx_route, c.gbp_to_src, c.gbp_to_usd,
           c.src_quote_n, c.src_positive_n, c.usd_quote_n, c.usd_positive_n,
           c.src_fx_type, c.usd_fx_type,
           c.avg_at, c.ibc, c.oancf, c.earn, c.cfo,
           c.earn-c.cfo as accrual,
           abs(c.earn-c.cfo) as abs_accrual,
           l1.earn as earn_l1, l2.earn as earn_l2, l3.earn as earn_l3, l4.earn as earn_l4,
           l1.cfo as cfo_l1, l2.cfo as cfo_l2, l3.cfo as cfo_l3, l4.cfo as cfo_l4
    from yearly as c
    left join yearly as l1 on c.gvkey=l1.gvkey and c.fyear=l1.fyear+1
    left join yearly as l2 on c.gvkey=l2.gvkey and c.fyear=l2.fyear+2
    left join yearly as l3 on c.gvkey=l3.gvkey and c.fyear=l3.fyear+3
    left join yearly as l4 on c.gvkey=l4.gvkey and c.fyear=l4.fyear+4
    where c.fyear between 1988 and 2004
      and c.fyr=12
      and c.at_usd>=100
      and not missing(c.earn) and not missing(c.cfo)
      and not missing(l1.earn) and not missing(l1.cfo)
      and not missing(l2.earn) and not missing(l2.cfo)
      and not missing(l3.earn) and not missing(l3.cfo)
      and not missing(l4.earn) and not missing(l4.cfo)
    order by c.gvkey,c.fyear;
quit;

data candidates;
    set candidate0;
    vol_earn=std(of earn earn_l1 earn_l2 earn_l3 earn_l4);
    vol_cfo=std(of cfo cfo_l1 cfo_l2 cfo_l3 cfo_l4);
    label earn="Earnings_t" cfo="CFO_t" accrual="Accruals_t"
          abs_accrual="Absolute accruals_t" vol_earn="Vol(Earnings)"
          vol_cfo="Vol(CFO)" avg_at="Average total assets_t";
run;

proc sql noprint;
    select count(*) into :eligible_n trimmed from candidates;
quit;
%put NOTE: Eligible firm-years with the complete current and prior-four-year construction = &eligible_n.;
proc sql;
    select fyear, count(*) as pretrim_candidates
    from candidates
    group by fyear
    order by fyear;
    title 'Pretrim candidate counts by analysis year';
quit;

/* Pooled, two-sided trimming at the paper's 1st and 99th percentile bounds. */
proc univariate data=candidates noprint;
    var earn accrual cfo;
    output out=cutoffs pctlpts=1 99
        pctlpre=earn_ accrual_ cfo_
        pctlname=p1 p99;
run;

data trimmed;
    if _n_=1 then set cutoffs;
    set candidates;
    if earn<earn_p1 or earn>earn_p99
       or accrual<accrual_p1 or accrual>accrual_p99
       or cfo<cfo_p1 or cfo>cfo_p99 then delete;
    label earn="Earnings_t" cfo="CFO_t" accrual="Accruals_t"
          abs_accrual="Absolute accruals_t" vol_earn="Vol(Earnings)"
          vol_cfo="Vol(CFO)";
run;

proc sql noprint;
    select count(*) into :final_n trimmed from trimmed;
quit;
%put NOTE: Final full sample after pooled 1st/99th percentile trimming = &final_n.;
proc sql;
    select fyear, count(*) as trimmed_rows
    from trimmed
    group by fyear
    order by fyear;
    title 'Final trimmed counts by analysis year';
quit;

proc means data=trimmed n mean std min max maxdec=3;
    var earn accrual abs_accrual cfo vol_earn vol_cfo;
    title "Table 1 comparison: full final sample descriptive statistics";
run;

/* The paper randomizes firms, then reports the resulting row counts. Sample
   half of distinct GVKEYs and retain every eligible year for those firms. */
proc sort data=trimmed out=trimmed_sorted;
    by gvkey fyear;
run;
proc sql noprint;
    create table firm_ids as select distinct gvkey from trimmed_sorted order by gvkey;
    select count(*) into :firm_count trimmed from firm_ids;
quit;
%let sampled_firm_count=%sysfunc(floor(%sysevalf(&firm_count/2)));
%put NOTE: Firm-level random split frame has &firm_count firms, first split samples &sampled_firm_count firms.;
proc surveyselect data=firm_ids out=selected_firms method=srs
    sampsize=&sampled_firm_count seed=20261102;
run;
proc sql;
    create table exploratory as
    select t.* from trimmed_sorted as t
    inner join selected_firms as s on t.gvkey=s.gvkey
    order by t.gvkey,t.fyear;
quit;
proc sort data=exploratory;
    by gvkey fyear;
run;
proc sql noprint;
    select count(*) into :exploratory_n trimmed from exploratory;
quit;
%put NOTE: Firm-level exploratory split contains &exploratory_n firm-years (paper benchmark: 11061).;
proc sql;
    select fyear, count(*) as exploratory_rows
    from exploratory
    group by fyear
    order by fyear;
    title 'Exploratory firm-year counts by analysis year';
quit;
proc rank data=exploratory out=ranked groups=5;
    var vol_earn;
    ranks vol_q0;
run;
data ranked;
    set ranked;
    vol_q=vol_q0+1;
    label vol_q="Earnings-volatility quintile (1=low, 5=high)";
run;

proc freq data=ranked;
    tables vol_q / missing;
    title "Pooled volatility quintiles in the exploratory subsample";
run;
proc means data=ranked n mean std min max maxdec=3;
    var earn accrual abs_accrual cfo vol_earn vol_cfo;
    title "Exploratory sample descriptive statistics";
run;

/* Each outcome is attached by GVKEY and FYEAR+h. Future rows need earnings
   and average assets, not the current-year CFO/history sample screens. */
proc sql;
    create table reg0 as
    select c.gvkey, c.fyear, c.datadate, c.at_usd,
           c.curcd, c.curcd_lag1, c.curncd, c.ratio_currency_status,
           c.fx_route, c.gbp_to_src, c.gbp_to_usd,
           c.src_quote_n, c.src_positive_n, c.usd_quote_n, c.usd_positive_n,
           c.src_fx_type, c.usd_fx_type,
           c.earn as earn_t, c.cfo as cfo_t, c.accrual as accrual_t,
           c.abs_accrual as abs_accrual_t, c.vol_earn, c.vol_cfo, c.vol_q,
           f1.earn as future_earn1, f1.curcd as future_curcd1,
           f1.ratio_currency_status as future_ratio_status1,
           f2.earn as future_earn2,
           f3.earn as future_earn3, f4.earn as future_earn4,
           f5.earn as future_earn5
    from ranked as c
    left join yearly as f1 on c.gvkey=f1.gvkey and c.fyear=f1.fyear-1
    left join yearly as f2 on c.gvkey=f2.gvkey and c.fyear=f2.fyear-2
    left join yearly as f3 on c.gvkey=f3.gvkey and c.fyear=f3.fyear-3
    left join yearly as f4 on c.gvkey=f4.gvkey and c.fyear=f4.fyear-4
    left join yearly as f5 on c.gvkey=f5.gvkey and c.fyear=f5.fyear-5
    order by c.gvkey,c.fyear;
quit;

proc sql;
    select count(*) as exploratory_rows,
           sum(not missing(future_earn1) and future_ratio_status1 ne 'Compatible') as invalid_h1_lead_ratio,
           sum(not missing(future_earn1) and curcd ne future_curcd1) as valid_h1_currency_changes
    from reg0;
    title 'Lead ratio validity and currency changes across separate dimensionless ratios';
quit;

data out.volatility_panel;
    set reg0;
    drop future_curcd1 future_ratio_status1;
    if n(of future_earn1-future_earn5)=5 then sum_earn5=sum(of future_earn1-future_earn5);
    else sum_earn5=.;
    label earn_t="Earnings_t" cfo_t="CFO_t" accrual_t="Accruals_t"
          abs_accrual_t="Absolute accruals_t" vol_earn="Vol(Earnings)"
          vol_cfo="Vol(CFO)" sum_earn5="Sum Earnings_{t+1:t+5}"
          future_earn1="Earnings_{t+1}" future_earn2="Earnings_{t+2}"
          future_earn3="Earnings_{t+3}" future_earn4="Earnings_{t+4}"
          future_earn5="Earnings_{t+5}";
run;

proc sql;
    select count(*) as exploratory_rows,
           sum(not missing(future_earn1)) as h1_complete,
           sum(not missing(future_earn2)) as h2_complete,
           sum(not missing(future_earn3)) as h3_complete,
           sum(not missing(future_earn4)) as h4_complete,
           sum(not missing(future_earn5)) as h5_complete,
           sum(not missing(sum_earn5)) as five_year_sum_complete
    from out.volatility_panel;
    title "Horizon-specific outcome availability in the exploratory sample";
quit;
proc sql;
    select fyear, count(*) as exploratory_rows,
           sum(not missing(future_earn1)) as h1_complete,
           sum(not missing(future_earn2)) as h2_complete,
           sum(not missing(future_earn3)) as h3_complete,
           sum(not missing(future_earn4)) as h4_complete,
           sum(not missing(future_earn5)) as h5_complete,
           sum(not missing(sum_earn5)) as five_year_sum_complete
    from out.volatility_panel
    group by fyear
    order by fyear;
    title 'Horizon-specific complete cases by analysis year';
quit;

/* Supporting pseudo-quintile simulations randomize firm-year rows, matching
   the paper's pseudo-quintile unit. The observed exploratory sample size is
   reported above and is not forced to the paper's reported 11,061.
   In one-regressor OLS with an intercept, R2 is corr(x,y)^2 and
   adjusted-R2 = 1-(1-R2)(N-1)/(N-2). */
data sim_long;
    if _n_=1 then call streaminit(20261102);
    set out.volatility_panel(keep=earn_t future_earn1 sum_earn5);
    do repetition=1 to 1000;
        pseudo_rand=rand("uniform");
        output;
    end;
    keep repetition pseudo_rand earn_t future_earn1 sum_earn5;
run;
proc sort data=sim_long out=sim_long_sorted;
    by repetition;
run;
proc rank data=sim_long_sorted out=sim_ranked groups=5;
    by repetition;
    var pseudo_rand;
    ranks pseudo_q;
run;
data sim_extremes;
    set sim_ranked(keep=repetition pseudo_q earn_t future_earn1 sum_earn5);
    where pseudo_q in (0,4);
run;
proc sort data=sim_extremes;
    by repetition pseudo_q;
run;

proc corr data=sim_extremes noprint outp=sim_corr_h1;
    by repetition pseudo_q;
    var earn_t future_earn1;
run;
proc sql;
    create table sim_h1_stats as
    select repetition, pseudo_q,
           max(case when upcase(_type_)='CORR' and upcase(_name_)='EARN_T'
                    then future_earn1 else . end) as corr,
           max(case when upcase(_type_)='N' then future_earn1 else . end) as n
    from sim_corr_h1
    where upcase(_type_) in ('CORR','N')
    group by repetition,pseudo_q;
quit;
data sim_h1_stats;
    set sim_h1_stats;
    if n>2 then adjr2=1-(1-corr*corr)*(n-1)/(n-2);
run;
proc sql;
    create table sim_h1_diff as
    select q1.repetition, q1.adjr2-q5.adjr2 as diff
    from sim_h1_stats as q1 inner join sim_h1_stats as q5
      on q1.repetition=q5.repetition
    where q1.pseudo_q=0 and q5.pseudo_q=4;
quit;

proc sort data=out.volatility_panel(where=(vol_q in (1,5))) out=obs_t2;
    by vol_q;
run;
proc corr data=obs_t2 noprint outp=obs_corr_t2;
    by vol_q;
    var earn_t future_earn1;
run;
proc print data=obs_corr_t2 noobs;
    var vol_q _type_ _name_ earn_t future_earn1;
    title "Supporting OLS correlation matrix rows for Table 2 R-squared check";
run;
proc sql;
    create table obs_h1_stats as
    select vol_q,
           max(case when upcase(_type_)='CORR' and upcase(_name_)='EARN_T'
                    then future_earn1 else . end) as corr,
           max(case when upcase(_type_)='N' then future_earn1 else . end) as n
    from obs_corr_t2
    where upcase(_type_) in ('CORR','N')
    group by vol_q;
    select max(case when vol_q=1 then 1-(1-corr*corr)*(n-1)/(n-2) else . end),
           max(case when vol_q=5 then 1-(1-corr*corr)*(n-1)/(n-2) else . end)
      into :t2_adj_q1 trimmed, :t2_adj_q5 trimmed
    from obs_h1_stats;
quit;
%let t2_adj_diff=%sysevalf(&t2_adj_q1-&t2_adj_q5);
proc sql noprint;
    select sum(diff >= &t2_adj_diff), sum(abs(diff) >= abs(&t2_adj_diff)), count(*)
      into :t2_tail1 trimmed, :t2_tail2 trimmed, :t2_reps trimmed
    from sim_h1_diff
    where not missing(diff);
quit;
%let t2_p1=.;
%let t2_p2=.;
%if %sysevalf(&t2_reps > 0) %then %do;
    %let t2_p1=%sysevalf(&t2_tail1/&t2_reps);
    %let t2_p2=%sysevalf(&t2_tail2/&t2_reps);
%end;
%put NOTE: Table 2 observed adjusted-R2 Q1=&t2_adj_q1 Q5=&t2_adj_q5 difference=&t2_adj_diff.;
%put NOTE: Table 2 adjusted-R2 pseudo-quintile bootstrap valid repetitions=&t2_reps one-sided tail=&t2_tail1 two-sided tail=&t2_tail2 one-sided empirical p=&t2_p1 two-sided empirical p=&t2_p2.;

proc corr data=sim_extremes noprint outp=sim_corr_t4;
    by repetition pseudo_q;
    var earn_t sum_earn5;
run;
proc sql;
    create table sim_t4_stats as
    select repetition, pseudo_q,
           max(case when upcase(_type_)='CORR' and upcase(_name_)='EARN_T'
                    then sum_earn5 else . end) as corr,
           max(case when upcase(_type_)='N' then sum_earn5 else . end) as n
    from sim_corr_t4
    where upcase(_type_) in ('CORR','N')
    group by repetition,pseudo_q;
quit;
data sim_t4_stats;
    set sim_t4_stats;
    if n>2 then adjr2=1-(1-corr*corr)*(n-1)/(n-2);
run;
proc sql;
    create table sim_t4_diff as
    select q1.repetition, q1.adjr2-q5.adjr2 as diff
    from sim_t4_stats as q1 inner join sim_t4_stats as q5
      on q1.repetition=q5.repetition
    where q1.pseudo_q=0 and q5.pseudo_q=4;
quit;

proc sort data=out.volatility_panel(where=(vol_q in (1,5))) out=obs_t4;
    by vol_q;
run;
proc corr data=obs_t4 noprint outp=obs_corr_t4;
    by vol_q;
    var earn_t sum_earn5;
run;
proc print data=obs_corr_t4 noobs;
    var vol_q _type_ _name_ earn_t sum_earn5;
    title "Supporting OLS correlation matrix rows for Table 4 R-squared check";
run;
proc sql;
    create table obs_t4_stats as
    select vol_q,
           max(case when upcase(_type_)='CORR' and upcase(_name_)='EARN_T'
                    then sum_earn5 else . end) as corr,
           max(case when upcase(_type_)='N' then sum_earn5 else . end) as n
    from obs_corr_t4
    where upcase(_type_) in ('CORR','N')
    group by vol_q;
    select max(case when vol_q=1 then 1-(1-corr*corr)*(n-1)/(n-2) else . end),
           max(case when vol_q=5 then 1-(1-corr*corr)*(n-1)/(n-2) else . end)
      into :t4_adj_q1 trimmed, :t4_adj_q5 trimmed
    from obs_t4_stats;
quit;
%let t4_adj_diff=%sysevalf(&t4_adj_q1-&t4_adj_q5);
proc sql noprint;
    select sum(diff >= &t4_adj_diff), sum(abs(diff) >= abs(&t4_adj_diff)), count(*)
      into :t4_tail1 trimmed, :t4_tail2 trimmed, :t4_reps trimmed
    from sim_t4_diff
    where not missing(diff);
quit;
%let t4_p1=.;
%let t4_p2=.;
%if %sysevalf(&t4_reps > 0) %then %do;
    %let t4_p1=%sysevalf(&t4_tail1/&t4_reps);
    %let t4_p2=%sysevalf(&t4_tail2/&t4_reps);
%end;
%put NOTE: Table 4 observed adjusted-R2 Q1=&t4_adj_q1 Q5=&t4_adj_q5 difference=&t4_adj_diff.;
%put NOTE: Table 4 adjusted-R2 pseudo-quintile bootstrap valid repetitions=&t4_reps one-sided tail=&t4_tail1 two-sided tail=&t4_tail2 one-sided empirical p=&t4_p1 two-sided empirical p=&t4_p2.;

title;
libname comp clear;
libname fx clear;
libname out clear;
