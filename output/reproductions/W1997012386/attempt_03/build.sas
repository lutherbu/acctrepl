options errorabend;

libname comp  "/storage/sas/base/comp/d_na" access=readonly;
libname comprate "/storage/sas/base/comp/d_na/rating" access=readonly;
libname gcomp "/storage/sas/base/comp/d_global/currency" access=readonly;
libname crsp  "/storage/sas/base/crsp/a_stock" access=readonly;
libname ccm   "/storage/sas/base/crsp/a_ccm" access=readonly;
libname out "data";

%let d86 = '01JAN1986'd;
%let d87 = '01JAN1987'd;
%let d93 = '01JAN1993'd;
%let d98 = '31DEC1998'd;
/* d98 remains the stated calendar market-model and rating cutoff.  FY1998
   Compustat rows can end in calendar 1999, so source-history inputs extend
   through the observed maximum FY1998 DATADATE of 31MAY1999. */
%let dend = '31MAY1999'd;

/* Annual Industrial Compustat, canonical current-format extraction keys. */
data work.funda_raw;
    set comp.funda(keep=gvkey datadate fyear indfmt consol popsrc datafmt curcd
                        at ceq ib dvc dltt sale xrd xad dp xdp oancf
                   where=(fyear >= 1986 and fyear <= 1998 and
                          indfmt='INDL' and consol='C' and popsrc='D' and datafmt='STD'));
run;

proc sql;
    create table work.funda_key_counts as
    select gvkey, fyear, count(*) as n_rows
    from work.funda_raw
    group by gvkey, fyear;

    create table work.funda_unique as
    select f.*
    from work.funda_raw as f
    inner join work.funda_key_counts as k
        on f.gvkey=k.gvkey and f.fyear=k.fyear
    where k.n_rows=1;

    select count(*) as selected_funda_rows,
           count(distinct gvkey) as selected_gvkeys,
           sum(case when n_rows>1 then 1 else 0 end) as duplicate_gvkey_fyear_keys,
           sum(case when n_rows>1 then n_rows else 0 end) as rows_in_duplicate_keys
    from work.funda_key_counts;
quit;

title "Compustat reporting currency by fiscal-year row, after source filters";
proc freq data=work.funda_unique;
    tables curcd / missing;
run;
title;

/* Currency cross-rates: only unique GBP-to-reporting and GBP-to-USD rates. */
data work.fx_dly_raw;
    set gcomp.g_exrt_dly(keep=datadate tocurd fromcurd exratd exrattpd
                         where=(datadate >= &d86 and datadate <= &dend and fromcurd='GBP'));
    curr=upcase(strip(tocurd));
    rate=exratd;
    keep datadate curr rate exrattpd;
run;

proc sql;
    create table work.fx_dly_summary as
    select datadate, curr, count(*) as n_rates, max(rate) as rate
    from work.fx_dly_raw
    group by datadate, curr;
quit;

data work.fx_mth_raw;
    set gcomp.g_exrt_mth(keep=datadate tocurm fromcurm exrat12m
                         where=(datadate >= &d86 and datadate <= &dend and fromcurm='GBP'));
    curr=upcase(strip(tocurm));
    rate=exrat12m;
    keep datadate curr rate;
run;

proc sql;
    create table work.fx_mth_summary as
    select datadate, curr, count(*) as n_rates, max(rate) as rate
    from work.fx_mth_raw
    group by datadate, curr;

    create table work.funda_rates as
    select a.*,
           dcur.n_rates as nd_report,
           dcur.rate as d_report,
           dusd.n_rates as nd_usd,
           dusd.rate as d_usd,
           mcur.n_rates as nm_report,
           mcur.rate as m_report,
           musd.n_rates as nm_usd,
           musd.rate as m_usd
    from work.funda_unique as a
    left join work.fx_dly_summary as dcur
        on a.datadate=dcur.datadate and upcase(strip(a.curcd))=dcur.curr
    left join work.fx_dly_summary as dusd
        on a.datadate=dusd.datadate and dusd.curr='USD'
    left join work.fx_mth_summary as mcur
        on a.datadate=mcur.datadate and upcase(strip(a.curcd))=mcur.curr
    left join work.fx_mth_summary as musd
        on a.datadate=musd.datadate and musd.curr='USD';
quit;

data work.annual_usd;
    set work.funda_rates;
    length reporting_currency $3;
    reporting_currency=upcase(strip(curcd));
    bs_usd_factor=.;
    flow_usd_factor=.;

    if reporting_currency='USD' then do;
        bs_usd_factor=1;
        flow_usd_factor=1;
    end;
    else do;
        if reporting_currency='GBP' then do;
            d_report=1;
            m_report=1;
            nd_report=1;
            nm_report=1;
        end;
        if nd_report=1 and nd_usd=1 and d_report ne 0 and not missing(d_report) and not missing(d_usd) then
            bs_usd_factor=d_usd/d_report;
        if nm_report=1 and nm_usd=1 and m_report ne 0 and not missing(m_report) and not missing(m_usd) then
            flow_usd_factor=m_usd/m_report;
    end;

    if not missing(at) and not missing(bs_usd_factor) then at_usd=at*bs_usd_factor;
    if not missing(ceq) and not missing(bs_usd_factor) then ceq_usd=ceq*bs_usd_factor;
    if not missing(dltt) and not missing(bs_usd_factor) then dltt_usd=dltt*bs_usd_factor;

    if not missing(ib) and not missing(flow_usd_factor) then ib_usd=ib*flow_usd_factor;
    if not missing(dvc) and not missing(flow_usd_factor) then dvc_usd=dvc*flow_usd_factor;
    if not missing(sale) and not missing(flow_usd_factor) then sale_usd=sale*flow_usd_factor;
    if not missing(xrd) and not missing(flow_usd_factor) then xrd_usd=xrd*flow_usd_factor;
    if not missing(xad) and not missing(flow_usd_factor) then xad_usd=xad*flow_usd_factor;
    if not missing(dp) and not missing(flow_usd_factor) then dp_usd=dp*flow_usd_factor;
    if not missing(xdp) and not missing(flow_usd_factor) then xdp_usd=xdp*flow_usd_factor;
    if not missing(oancf) and not missing(flow_usd_factor) then oancf_usd=oancf*flow_usd_factor;
run;

title "Currency conversion availability for the selected Compustat rows";
proc means data=work.annual_usd n nmiss;
    var at_usd ceq_usd dltt_usd ib_usd dvc_usd sale_usd xrd_usd xad_usd dp_usd xdp_usd oancf_usd;
run;
title;

title "Actual required fiscal reporting dates and exact-date FX coverage";
proc sql;
    select fyear, reporting_currency, count(*) as report_rows,
           min(datadate) as first_datadate format=yymmdd10.,
           max(datadate) as last_datadate format=yymmdd10.,
           sum(datadate>&d98) as rows_after_1998_calendar_end,
           sum(not missing(ceq)) as ceq_source_rows,
           sum(not missing(ceq_usd)) as ceq_usd_rows,
           sum(not missing(ceq) and missing(ceq_usd)) as ceq_unconverted_rows,
           sum(not missing(at) and not missing(at_usd)) as at_usd_rows,
           sum(not missing(at) and missing(at_usd)) as at_unconverted_rows,
           sum(not missing(sale) and not missing(sale_usd)) as sale_usd_rows,
           sum(not missing(sale) and missing(sale_usd)) as sale_unconverted_rows,
           sum(not missing(ceq) and not missing(bs_usd_factor)) as ceq_with_balance_rate,
           sum(not missing(sale) and not missing(flow_usd_factor)) as sale_with_flow_rate
    from work.annual_usd
    where fyear>=1992 and fyear<=1998
    group by fyear, reporting_currency
    order by fyear, reporting_currency;
quit;
title;

title "Annual fiscal-date bounds for the return anchor and selected 1998 endpoint";
proc sql;
    select fyear, count(*) as firm_year_rows,
           min(datadate) as first_datadate format=yymmdd10.,
           max(datadate) as last_datadate format=yymmdd10.
    from work.annual_usd
    where fyear in (1986,1987,1998)
    group by fyear
    order by fyear;
quit;
title;

title "USD conversion coverage among annual CAD reports";
proc sql;
    select count(*) as cad_annual_rows,
           sum(not missing(at)) as cad_balance_inputs,
           sum(not missing(at_usd)) as cad_balance_usd,
           sum(not missing(at) and missing(bs_usd_factor)) as cad_balance_missing_rate,
           sum(not missing(sale)) as cad_flow_inputs,
           sum(not missing(sale_usd)) as cad_flow_usd,
           sum(not missing(sale) and missing(flow_usd_factor)) as cad_flow_missing_rate
    from work.annual_usd
    where reporting_currency='CAD';
quit;
title;

/* CRSP source rows: monthly stock, historical security names, and CCM links. */
data work.msf_raw;
    set crsp.msf(keep=permno permco date ret prc shrout
                 where=(date >= &d86 and date <= &dend));
run;

proc sql;
    create table work.msf_key_counts as
    select permno, date, count(*) as n_rows
    from work.msf_raw
    group by permno, date;

    create table work.msf_unique as
    select m.*
    from work.msf_raw as m
    inner join work.msf_key_counts as k
        on m.permno=k.permno and m.date=k.date
    where k.n_rows=1;

    select count(*) as crsp_monthly_keys,
           sum(case when n_rows>1 then 1 else 0 end) as duplicate_permno_month_keys,
           sum(case when n_rows>1 then n_rows else 0 end) as rows_in_duplicate_permno_months
    from work.msf_key_counts;
quit;

data work.names_common;
    set crsp.dsenames(keep=permno namedt nameendt shrcd
                      where=(nameendt >= &d86 and namedt <= &dend));
    if floor(shrcd/10)=1;
run;

data work.links_lc_lu_raw;
    set ccm.ccmxpf_linktable(keep=gvkey linkprim linktype usedflag lpermno linkdt linkenddt
                             where=(usedflag=1 and linktype in ('LC','LU') and
                                    linkprim in ('P','C') and lpermno>0 and
                                    (linkenddt >= &d86 or missing(linkenddt)) and
                                    (linkdt <= &dend or missing(linkdt))));
    permno=lpermno;
    keep gvkey permno linkdt linkenddt linkprim linktype usedflag;
run;

/* Separate audit of every used common-class link, including secondary markers
   and LS security-only links; the main primary-link selection stays unchanged. */
data work.links_company_audit;
    set ccm.ccmxpf_linktable(keep=gvkey linkprim linktype usedflag lpermno linkdt linkenddt
                             where=(usedflag=1 and linktype in ('LC','LU','LS') and
                                    lpermno>0 and
                                    (linkenddt >= &d86 or missing(linkenddt)) and
                                    (linkdt <= &dend or missing(linkdt))));
    permno=lpermno;
    keep gvkey permno linkdt linkenddt linkprim linktype usedflag;
run;

title "Source-supported primary LC and unresearched LU links overlapping the construction window";
proc freq data=work.links_lc_lu_raw;
    tables linktype*linkprim / missing;
run;
title;

proc sql;
    create table work.link_key_counts as
    select gvkey, permno, linkdt, linkenddt, count(*) as n_rows
    from work.links_lc_lu_raw
    group by gvkey, permno, linkdt, linkenddt;

    create table work.links_lc_lu_unique as
    select distinct gvkey, permno, linkdt, linkenddt, linkprim, linktype
    from work.links_lc_lu_raw;

    create table work.links_unique as
    select distinct gvkey, permno, linkdt, linkenddt
    from work.links_lc_lu_raw
    where linktype='LC';

    create table work.link_type_counts as
    select linktype, count(*) as source_link_rows,
           count(distinct gvkey) as source_gvkeys,
           count(distinct permno) as source_permnos
    from work.links_lc_lu_raw
    group by linktype;

    select count(*) as eligible_link_rows,
           sum(case when n_rows>1 then 1 else 0 end) as duplicate_link_keys,
           sum(case when n_rows>1 then n_rows else 0 end) as rows_in_duplicate_link_keys
    from work.link_key_counts;

    select * from work.link_type_counts;
quit;

title "Added raw source support beyond the calendar 1998 analysis cutoff";
proc sql;
    select count(*) as msf_rows_through_dend,
           sum(date>&d98) as msf_rows_after_d98,
           min(date) as msf_first_date format=yymmdd10.,
           max(date) as msf_last_date format=yymmdd10.
    from work.msf_raw;

    select count(*) as daily_fx_rows_through_dend,
           sum(datadate>&d98) as daily_fx_rows_after_d98,
           max(datadate) as daily_fx_last_date format=yymmdd10.
    from work.fx_dly_raw;

    select count(*) as monthly_fx_rows_through_dend,
           sum(datadate>&d98) as monthly_fx_rows_after_d98,
           max(datadate) as monthly_fx_last_date format=yymmdd10.
    from work.fx_mth_raw;

    select sum(nameendt>&d98 or namedt>&d98) as common_name_rows_touching_1999
    from work.names_common;

    select sum(linkenddt>&d98 or linkdt>&d98) as primary_link_rows_touching_1999
    from work.links_lc_lu_raw;
quit;
title;

/* Join by valid history. Ambiguous GVKEY-months are retained as missing downstream. */
proc sql;
    create table work.month_candidates as
    select distinct l.gvkey, m.permno, m.permco, m.date, m.ret, m.prc, m.shrout
    from work.links_unique as l
    inner join work.msf_unique as m
        on l.permno=m.permno
       and (missing(l.linkdt) or l.linkdt<=m.date)
       and (missing(l.linkenddt) or l.linkenddt>=m.date)
    inner join work.names_common as n
        on m.permno=n.permno
       and (missing(n.namedt) or n.namedt<=m.date)
       and (missing(n.nameendt) or n.nameendt>=m.date);

    create table work.month_link_counts as
    select gvkey, date, count(distinct permno) as n_permno
    from work.month_candidates
    group by gvkey, date;

    create table work.firm_month_lc as
    select distinct c.gvkey, c.permno, c.permco, c.date, c.ret, c.prc, c.shrout
    from work.month_candidates as c
    inner join work.month_link_counts as n
        on c.gvkey=n.gvkey and c.date=n.date
    where n.n_permno=1;

    create table work.month_candidates_lc_lu as
    select distinct l.gvkey, m.permno, m.permco, m.date, m.ret, m.prc, m.shrout
    from work.links_lc_lu_unique as l
    inner join work.msf_unique as m
        on l.permno=m.permno
       and (missing(l.linkdt) or l.linkdt<=m.date)
       and (missing(l.linkenddt) or l.linkenddt>=m.date)
    inner join work.names_common as n
        on m.permno=n.permno
       and (missing(n.namedt) or n.namedt<=m.date)
       and (missing(n.nameendt) or n.nameendt>=m.date);

    create table work.month_link_counts_lc_lu as
    select gvkey, date, count(distinct permno) as n_permno
    from work.month_candidates_lc_lu
    group by gvkey, date;

    create table work.firm_month_lc_lu as
    select distinct c.gvkey, c.permno, c.permco, c.date, c.ret, c.prc, c.shrout
    from work.month_candidates_lc_lu as c
    inner join work.month_link_counts_lc_lu as n
        on c.gvkey=n.gvkey and c.date=n.date
    where n.n_permno=1;

    select count(*) as candidate_gvkey_months,
           sum(case when n_permno>1 then 1 else 0 end) as ambiguous_gvkey_months
    from work.month_link_counts;

    select count(*) as lc_only_unique_gvkey_months,
           count(distinct gvkey) as lc_only_firms
    from work.firm_month_lc;

    select count(*) as lc_or_lu_unique_gvkey_months,
           count(distinct gvkey) as lc_or_lu_firms
    from work.firm_month_lc_lu;

    select count(*) as lc_or_lu_ambiguous_months
    from work.month_link_counts_lc_lu
    where n_permno>1;
quit;

/* Both source-documented primary LC and unresearched LU links enter the main build. */
data work.firm_month;
    set work.firm_month_lc_lu;
run;

/* Market model used for the stated minimum-24-month additional sample screen. */
data work.msi_raw;
    set crsp.msi(keep=date vwretd where=(date >= &d93 and date <= &d98));
run;

proc sql;
    create table work.msi_key_counts as
    select date, count(*) as n_rows
    from work.msi_raw
    group by date;

    create table work.msi_unique as
    select m.*
    from work.msi_raw as m
    inner join work.msi_key_counts as k
        on m.date=k.date
    where k.n_rows=1;

    create table work.market_pairs as
    select f.gvkey, f.date, f.ret, i.vwretd
    from work.firm_month as f
    inner join work.msi_unique as i
        on f.date=i.date
    where f.date >= &d93 and f.date <= &d98
      and not missing(f.ret) and not missing(i.vwretd);

    create table work.market_n as
    select gvkey, count(*) as n_pairs
    from work.market_pairs
    group by gvkey;

    create table work.market_pairs24 as
    select p.*
    from work.market_pairs as p
    inner join work.market_n as n on p.gvkey=n.gvkey
    where n.n_pairs>=24;
quit;

proc sort data=work.market_pairs24;
    by gvkey date;
run;

proc reg data=work.market_pairs24 outest=work.market_est noprint;
    by gvkey;
    model ret=vwretd;
    output out=work.market_residuals r=mm_resid;
run;
quit;

data work.market_beta;
    set work.market_est;
    if _TYPE_='PARMS';
    beta=vwretd;
    keep gvkey beta;
run;

data work.market_residuals;
    set work.market_residuals;
    mm_resid2=mm_resid*mm_resid;
run;

proc means data=work.market_residuals nway noprint;
    class gvkey;
    var mm_resid2;
    output out=work.market_mse(drop=_TYPE_ _FREQ_) n=n_resid mean=mse;
run;

proc sql;
    create table work.market_model as
    select n.gvkey, n.n_pairs, b.beta, e.mse
    from work.market_n as n
    left join work.market_beta as b on n.gvkey=b.gvkey
    left join work.market_mse as e on n.gvkey=e.gvkey;
quit;

/* Fiscal-year total return: compound 12 CRSP total-return observations in each actual fiscal interval. */
proc sql;
    create table work.fy_bounds as
    select c.gvkey, c.fyear, c.datadate, p.datadate as prevdate
    from work.annual_usd as c
    left join work.annual_usd as p
        on c.gvkey=p.gvkey and p.fyear=c.fyear-1
    where c.fyear>=1987 and c.fyear<=1998;

    create table work.fy_month_returns as
    select b.gvkey, b.fyear, b.prevdate, b.datadate, m.date, m.ret
    from work.fy_bounds as b
    inner join work.firm_month as m
        on b.gvkey=m.gvkey and m.date>b.prevdate and m.date<=b.datadate
    where not missing(b.prevdate);

    create table work.fy_return_sums as
    select gvkey, fyear,
           count(date) as n_months,
           sum(case when not missing(ret) and ret>-1 then 1
                    when ret=-1 then 1 else 0 end) as n_valid_returns,
           sum(case when not missing(ret) and ret>-1 then log(1+ret) else 0 end) as log_sum,
           sum(case when ret=-1 then 1 else 0 end) as n_total_losses
    from work.fy_month_returns
    group by gvkey, fyear;

    /* Exact source-horizon counterfactual: retain only months available under
       the predecessor's Dec-1998 raw CRSP cutoff. */
    create table work.fy_return_sums_old as
    select gvkey, fyear, count(date) as n_months_old,
           sum(case when not missing(ret) and ret>-1 then 1
                    when ret=-1 then 1 else 0 end) as n_valid_returns_old
    from work.fy_month_returns
    where date<=&d98
    group by gvkey, fyear;
quit;

data work.fy_returns;
    set work.fy_return_sums;
    if n_months=12 and n_valid_returns=12 then do;
        if n_total_losses>0 then ret_fy=-1;
        else ret_fy=exp(log_sum)-1;
    end;
run;

/* BTM uses common equity (USD) over CRSP common-stock market equity (USD). */
proc sql;
    create table work.btm_dates as
    select a.gvkey, a.fyear, a.datadate,
           max(m.date) as market_date format=yymmddn8.
    from work.annual_usd as a
    inner join work.firm_month as m
        on a.gvkey=m.gvkey
       and m.date<=a.datadate
       and m.date>=intnx('month',a.datadate,-1,'end')
    where a.fyear>=1993 and a.fyear<=1998
      and not missing(a.ceq_usd)
      and not missing(m.prc) and abs(m.prc)>0
      and not missing(m.shrout) and m.shrout>0
    group by a.gvkey, a.fyear, a.datadate;

    create table work.btm_annual as
    select a.gvkey, a.fyear, a.datadate, a.ceq_usd,
           m.permno, m.permco, d.market_date, a.datadate-d.market_date as price_age_days,
           m.prc, m.shrout,
           abs(m.prc)*m.shrout/1000 as market_equity_usd,
           a.ceq_usd/(abs(m.prc)*m.shrout/1000) as btm
    from work.btm_dates as d
    inner join work.annual_usd as a
        on d.gvkey=a.gvkey and d.fyear=a.fyear and d.datadate=a.datadate
    inner join work.firm_month as m
        on d.gvkey=m.gvkey and d.market_date=m.date
    where not missing(m.prc) and abs(m.prc)>0
      and not missing(m.shrout) and m.shrout>0;

    create table work.fe_panel_raw as
    select b.gvkey, b.fyear, b.btm,
           r0.ret_fy as ret0,
           r1.ret_fy as ret1,
           r2.ret_fy as ret2,
           r3.ret_fy as ret3,
           r4.ret_fy as ret4,
           r5.ret_fy as ret5,
           r6.ret_fy as ret6
    from work.btm_annual as b
    left join work.fy_returns as r0 on b.gvkey=r0.gvkey and b.fyear=r0.fyear
    left join work.fy_returns as r1 on b.gvkey=r1.gvkey and b.fyear-1=r1.fyear
    left join work.fy_returns as r2 on b.gvkey=r2.gvkey and b.fyear-2=r2.fyear
    left join work.fy_returns as r3 on b.gvkey=r3.gvkey and b.fyear-3=r3.fyear
    left join work.fy_returns as r4 on b.gvkey=r4.gvkey and b.fyear-4=r4.fyear
    left join work.fy_returns as r5 on b.gvkey=r5.gvkey and b.fyear-5=r5.fyear
    left join work.fy_returns as r6 on b.gvkey=r6.gvkey and b.fyear-6=r6.fyear
    where b.fyear>=1993 and b.fyear<=1998;
quit;

title "Actual fiscal-date BTM and CRSP price-date coverage";
proc sql;
    select a.fyear, count(*) as funda_firm_year_rows,
           sum(not missing(a.ceq_usd)) as ceq_usd_rows,
           sum(not missing(b.market_date)) as matched_btm_rows,
           sum(a.datadate>&d98) as fiscal_dates_after_calendar_1998,
           sum(b.market_date>&d98) as btm_prices_post98,
           sum(a.datadate>&d98 and a.reporting_currency ne 'USD' and
               not missing(a.ceq)) as late_nonusd_book_equity_rows,
           min(a.datadate) as first_fiscal_date format=yymmdd10.,
           max(a.datadate) as last_fiscal_date format=yymmdd10.,
           min(b.market_date) as first_price_date format=yymmdd10.,
           max(b.market_date) as last_price_date format=yymmdd10.,
           max(b.price_age_days) as max_price_age_days
    from work.annual_usd as a
    left join work.btm_annual as b
      on a.gvkey=b.gvkey and a.fyear=b.fyear and a.datadate=b.datadate
    where a.fyear>=1993 and a.fyear<=1998
    group by a.fyear
    order by a.fyear;
quit;
title;

title "Fiscal-year CRSP return-month coverage for RET_t through RET_t-6";
proc sql;
    select b.fyear, count(*) as annual_intervals,
           sum(not missing(s.n_months)) as intervals_with_month_rows,
           sum(s.n_months=12) as intervals_with_12_months,
           sum(s.n_months=12 and s.n_valid_returns=12) as complete_12_return_intervals,
           sum(o.n_months_old=12 and o.n_valid_returns_old=12) as complete_d98,
           sum(s.n_months=12 and s.n_valid_returns=12 and
               coalesce(o.n_months_old,0)<12) as full12_d98cut,
           sum(s.n_months>coalesce(o.n_months_old,0)) as intervals_with_late_months_added,
           min(b.prevdate) as earliest_previous_fiscal_date format=yymmdd10.,
           max(b.datadate) as latest_fiscal_date format=yymmdd10.
    from work.fy_bounds as b
    left join work.fy_return_sums as s
      on b.gvkey=s.gvkey and b.fyear=s.fyear
    left join work.fy_return_sums_old as o
      on b.gvkey=o.gvkey and b.fyear=o.fyear
    group by b.fyear
    order by b.fyear;
quit;
title;

data work.fe_panel_complete;
    set work.fe_panel_raw;
    if nmiss(btm,ret0,ret1,ret2,ret3,ret4,ret5,ret6)=0;
run;

proc sql;
    create table work.fe_firm_counts as
    select gvkey, count(*) as n_rows, min(fyear) as first_year, max(fyear) as last_year
    from work.fe_panel_complete
    group by gvkey;

    create table work.fe_panel_balanced as
    select p.*
    from work.fe_panel_complete as p
    inner join work.fe_firm_counts as c on p.gvkey=c.gvkey
    where c.n_rows=6 and c.first_year=1993 and c.last_year=1998;

    select count(*) as balanced_btm_return_rows,
           count(distinct gvkey) as balanced_btm_return_firms
    from work.fe_panel_balanced;
quit;

/* S&P SPLTICRM is the local long-term issuer field; use only its pre-1998-09 senior-debt period. */
data work.rating_raw;
    set comprate.adsprate(keep=gvkey datadate splticrm
                          where=(datadate >= &d93 and datadate <= '31AUG1998'd));
    if not missing(splticrm);
run;

proc sql;
    create table work.rating_flags as
    select gvkey, count(*) as n_rating_records,
           min(datadate) as first_rating_date format=yymmddn8.,
           max(datadate) as last_rating_date format=yymmddn8.
    from work.rating_raw
    group by gvkey;

    create table work.support_panel_primary as
    select p.*
    from work.fe_panel_balanced as p
    inner join work.rating_flags as r on p.gvkey=r.gvkey;

    /* Bounded company audit: compare each primary PERMNO with every active
       ordinary-common PERMNO in its PERMCO/month, then inspect all used
       CCM links for those common classes, including secondary markers. */
    create table work.support_primary_months as
    select distinct s.gvkey, m.date, m.permco,
           m.permno as primary_permno, m.prc as primary_prc,
           m.shrout as primary_shrout
    from (select distinct gvkey from work.support_panel_primary) as s
    inner join work.firm_month as m
      on s.gvkey=m.gvkey and m.date>=&d93 and m.date<=&dend;

    create table work.support_common_class_rows as
    select distinct p.gvkey, p.date, p.permco,
           p.primary_permno, p.primary_prc, p.primary_shrout,
           m.permno, m.prc, m.shrout
    from work.support_primary_months as p
    inner join work.msf_unique as m
      on p.permco=m.permco and p.date=m.date
    inner join work.names_common as n
      on m.permno=n.permno
     and (missing(n.namedt) or n.namedt<=m.date)
     and (missing(n.nameendt) or n.nameendt>=m.date)
    where not missing(p.permco) and p.permco>0;

    create table work.support_common_link_rows as
    select distinct p.permco, p.date, m.permno,
           l.gvkey as mapped_gvkey
    from (select distinct permco, date from work.support_primary_months
          where not missing(permco) and permco>0) as p
    inner join work.msf_unique as m
      on p.permco=m.permco and p.date=m.date
    inner join work.names_common as n
      on m.permno=n.permno
     and (missing(n.namedt) or n.namedt<=m.date)
     and (missing(n.nameendt) or n.nameendt>=m.date)
    left join work.links_company_audit as l
      on m.permno=l.permno
     and (missing(l.linkdt) or l.linkdt<=m.date)
     and (missing(l.linkenddt) or l.linkenddt>=m.date);

    create table work.support_permco_map as
    select permco, date,
           count(distinct mapped_gvkey) as n_mapped_gvkeys,
           min(mapped_gvkey) as only_mapped_gvkey,
           count(distinct case when missing(mapped_gvkey)
                               then permno else . end) as n_unmapped_common_permnos
    from work.support_common_link_rows
    group by permco, date;

    title "Unique PERMCO-month link map audit across ordinary-common issues";
    select count(*) as audited_permco_months,
           sum(n_mapped_gvkeys>1) as permco_months_multi_gvkey,
           sum(n_unmapped_common_permnos>0) as permco_months_unmapped_common
    from work.support_permco_map;
    title;

    create table work.support_class_counts as
    select c.*, p.n_mapped_gvkeys, p.only_mapped_gvkey,
           p.n_unmapped_common_permnos
    from (
        select gvkey, date, permco,
           count(distinct permno) as n_ordinary_common_permnos,
           count(distinct case when not missing(prc) and abs(prc)>0 and
                                      not missing(shrout) and shrout>0
                                then permno else . end) as n_priced_common_permnos,
           sum(case when not missing(prc) and abs(prc)>0 and
                         not missing(shrout) and shrout>0
                    then abs(prc)*shrout/1000 else . end) as partial_common_me,
           min(case when permno=primary_permno and not missing(primary_prc) and
                         abs(primary_prc)>0 and not missing(primary_shrout) and
                         primary_shrout>0
                    then abs(primary_prc)*primary_shrout/1000 else . end) as primary_me
        from work.support_common_class_rows
        group by gvkey, date, permco
    ) as c
    left join work.support_permco_map as p
      on c.permco=p.permco and c.date=p.date;

    create table work.support_class_me as
    select *,
           case when n_ordinary_common_permnos=n_priced_common_permnos
                then partial_common_me else . end as company_common_me,
           case when n_mapped_gvkeys=1 and only_mapped_gvkey=gvkey and
                     n_ordinary_common_permnos=n_priced_common_permnos and
                     not missing(partial_common_me) and partial_common_me>0
                then 1 else 0 end as company_map_ok
    from work.support_class_counts;

    select count(*) as support_gvkey_permco_month_rows,
           count(distinct gvkey) as support_firms_with_permco_audit,
           sum(n_ordinary_common_permnos>1) as firm_months_multi_common,
           sum(n_ordinary_common_permnos>1 and not missing(company_common_me)) as multi_share_complete,
           sum(n_ordinary_common_permnos>1 and missing(company_common_me)) as multi_share_incomplete,
           sum(n_mapped_gvkeys>1) as firm_months_multi_gvkey,
           sum(n_unmapped_common_permnos>0) as firm_months_unmapped_common,
           sum(n_ordinary_common_permnos>1 and n_unmapped_common_permnos>0) as multi_unmapped_firm_months,
           sum(company_map_ok=1) as unambiguous_firm_months,
           max(case when n_ordinary_common_permnos>1 and not missing(company_common_me) and
                         not missing(primary_me)
                    then abs(company_common_me-primary_me) else . end) as max_multiclass_me_diff,
           max(case when n_ordinary_common_permnos>1 and not missing(company_common_me) and
                         not missing(primary_me) and primary_me>0
                    then company_common_me/primary_me else . end) as max_multiclass_to_primary_me
    from work.support_class_me;

    select count(*) as support_primary_months,
           sum(missing(permco) or permco<=0) as months_without_valid_permco
    from work.support_primary_months;

    create table work.support_btm_candidates as
    select distinct p.gvkey, p.fyear, b.datadate, b.market_date,
           p.btm as btm_primary, b.ceq_usd,
           c.n_ordinary_common_permnos, c.n_priced_common_permnos,
           c.n_mapped_gvkeys, c.n_unmapped_common_permnos,
           c.primary_me, c.company_common_me, c.company_map_ok,
           case when c.company_map_ok=1
                then b.ceq_usd/c.company_common_me else . end as btm_company
    from work.support_panel_primary as p
    inner join work.btm_annual as b
      on p.gvkey=b.gvkey and p.fyear=b.fyear
    left join work.support_class_me as c
      on p.gvkey=c.gvkey and b.market_date=c.date;

    select fyear, count(*) as rated_primary_btm_rows,
           sum(n_ordinary_common_permnos>1) as btm_multi_cls,
           sum(n_ordinary_common_permnos>1 and not missing(company_common_me)) as btm_multi_full,
           sum(n_mapped_gvkeys>1) as btm_map_multi,
           sum(n_unmapped_common_permnos>0) as btm_unmapped_class,
           sum(company_map_ok=1) as company_btm_ready,
           sum(missing(btm_company)) as btm_company_unavailable,
           max(case when n_ordinary_common_permnos>1 and not missing(company_common_me) and
                         not missing(primary_me)
                    then abs(company_common_me-primary_me) else . end) as max_comp_primary_diff
    from work.support_btm_candidates
    group by fyear
    order by fyear;

    create table work.support_company_panel_complete as
    select p.gvkey, p.fyear, b.btm_company as btm,
           p.ret0, p.ret1, p.ret2, p.ret3, p.ret4, p.ret5, p.ret6
    from work.support_panel_primary as p
    inner join work.support_btm_candidates as b
      on p.gvkey=b.gvkey and p.fyear=b.fyear
    where not missing(b.btm_company) and
          nmiss(p.ret0,p.ret1,p.ret2,p.ret3,p.ret4,p.ret5,p.ret6)=0;

    create table work.support_company_counts as
    select gvkey, count(*) as n_rows,
           min(fyear) as first_year, max(fyear) as last_year
    from work.support_company_panel_complete
    group by gvkey;

    create table work.support_panel as
    select p.*
    from work.support_company_panel_complete as p
    inner join work.support_company_counts as c
      on p.gvkey=c.gvkey
    where c.n_rows=6 and c.first_year=1993 and c.last_year=1998;

    create table work.support_counts as
    select gvkey, count(*) as n_panel_rows
    from work.support_panel
    group by gvkey;

    create table work.support_btm_resolution as
    select gvkey,
           sum(missing(btm_company)) as n_unresolved_btm,
           sum(n_mapped_gvkeys>1) as n_multi_gvkey_btm,
           sum(n_unmapped_common_permnos>0) as n_unmapped_class_btm,
           sum(n_ordinary_common_permnos>1) as n_multiclass_btm
    from work.support_btm_candidates
    group by gvkey;

    select count(*) as primary_rated_support_firms,
           sum(n_unresolved_btm>0) as firms_unresolved_btm,
           sum(n_multi_gvkey_btm>0) as firms_gvkey_conflict,
           sum(n_unmapped_class_btm>0) as firms_with_unmapped_common_issue,
           sum(n_multiclass_btm>0) as firms_with_multiclass_btm
    from work.support_btm_resolution;

    select count(*) as company_support_panel_rows,
           count(distinct gvkey) as company_support_firms
    from work.support_panel;

    create table work.support_btm_class as
    select distinct gvkey, fyear, datadate, market_date,
           n_ordinary_common_permnos, n_priced_common_permnos,
           n_mapped_gvkeys, n_unmapped_common_permnos,
           primary_me, company_common_me, company_map_ok
    from work.support_btm_candidates
    where gvkey in (select distinct gvkey from work.support_panel);

    select fyear, count(*) as company_support_btm_rows,
           sum(n_ordinary_common_permnos>1) as company_btm_multiclass,
           sum(n_mapped_gvkeys>1) as company_btm_map_conflicts,
           sum(n_unmapped_common_permnos>0) as company_btm_unmapped_share,
           sum(company_map_ok=1) as company_btm_used
    from work.support_btm_class
    group by fyear
    order by fyear;

    create table work.support_lc_coverage as
    select s.gvkey, count(distinct m.date) as lc_months_9398
    from (select distinct gvkey from work.support_panel) as s
    left join work.firm_month_lc as m
        on s.gvkey=m.gvkey and m.date>=&d93 and m.date<=&d98
    group by s.gvkey;

    select count(*) as lc_lu_support_firms,
           sum(lc_months_9398>0) as support_firms_with_lc_months,
           sum(lc_months_9398) as lc_lu_support_months
    from work.support_lc_coverage;
quit;

proc sort data=work.support_panel;
    by gvkey fyear;
run;

title "Unit checks for the completed company-market-equity BTM support panel";
proc means data=work.support_panel n nmiss mean std min p25 median p75 max;
    var btm ret0 ret1 ret2 ret3 ret4 ret5 ret6;
run;
title;

/* Least-squares means provide each firm's relative fixed effect in the balanced panel. */
ods output LSMeans=work.conmkt_lsmeans;
proc glm data=work.support_panel;
    class gvkey fyear;
    model btm=gvkey fyear ret0 ret1 ret2 ret3 ret4 ret5 ret6;
    lsmeans gvkey;
run;
quit;
ods output close;

proc contents data=work.conmkt_lsmeans;
run;

data work.conmkt_lsmeans2;
    set work.conmkt_lsmeans(rename=(btmLSMean=LSMean));
run;

proc means data=work.conmkt_lsmeans2 nway noprint;
    var LSMean;
    output out=work.conmkt_lsmean_center(drop=_TYPE_ _FREQ_) mean=mean_lsmean;
run;

data work.conmkt_byfirm;
    if _n_=1 then set work.conmkt_lsmean_center;
    set work.conmkt_lsmeans2;
    if not missing(gvkey) and not missing(LSMean);
    conmkt=-(LSMean-mean_lsmean);
    keep gvkey conmkt;
run;

title "CONMKT centering check on the rated company-BTM support cohort";
proc means data=work.conmkt_byfirm n nmiss mean std min p25 median p75 max;
    var conmkt;
run;
title;

proc sql;
    create table work.controls_annual as
    select a.gvkey, a.fyear, a.datadate,
           case when not missing(a.ib_usd) and not missing(a.at_usd) and a.at_usd ne 0
                then a.ib_usd/a.at_usd else . end as roa,
           case when not missing(a.dvc_usd) and not missing(a.at_usd) and a.at_usd ne 0
                then a.dvc_usd/a.at_usd else . end as div,
           /* The same-date balance-sheet conversion factor cancels in DLTT/AT. */
           case when not missing(a.dltt) and not missing(a.at) and a.at ne 0
                then a.dltt/a.at else . end as lev,
           case when not missing(a.dltt_usd) and not missing(a.at_usd) and a.at_usd ne 0
                then a.dltt_usd/a.at_usd else . end as lev_fx,
           case when not missing(a.at_usd) and a.at_usd>0 then log(a.at_usd) else . end as size,
           case when not missing(a.sale_usd) and not missing(p.sale_usd) and p.sale_usd ne 0
                then a.sale_usd/p.sale_usd-1 else . end as salesgro,
           /* All three same-date flow items share one FX factor, which cancels. */
           case when not missing(a.xrd) and not missing(a.xad) and
                         not missing(a.sale) and a.sale ne 0
                then (a.xrd+a.xad)/a.sale else . end as rndadv,
           case when not missing(a.xrd_usd) and not missing(a.xad_usd) and
                         not missing(a.sale_usd) and a.sale_usd ne 0
                then (a.xrd_usd+a.xad_usd)/a.sale_usd else . end as rndadv_fx
    from work.annual_usd as a
    left join work.annual_usd as p
        on a.gvkey=p.gvkey and a.fyear=p.fyear+1
    where a.fyear>=1993 and a.fyear<=1998;

    create table work.conacc_annual as
    select gvkey, fyear,
           case when not missing(ib_usd) and not missing(dp_usd) and
                         not missing(oancf_usd) and not missing(at_usd) and at_usd ne 0
                then (ib_usd+dp_usd-oancf_usd)/at_usd else . end as acc_raw,
           case when not missing(ib_usd) and not missing(xdp_usd) and
                         not missing(oancf_usd) and not missing(at_usd) and at_usd ne 0
                then (ib_usd+xdp_usd-oancf_usd)/at_usd else . end as acc_xdp
    from work.annual_usd
    where fyear>=1993 and fyear<=1998;
quit;

title "Same-date cancellation checks for LEV and RNDADV";
proc sql;
    select sum(not missing(lev) and not missing(lev_fx)) as lev_overlap_years,
           max(case when not missing(lev) and not missing(lev_fx)
                    then abs(lev-lev_fx) else . end) as lev_max_abs_diff,
           sum(not missing(lev_fx) and missing(lev)) as lev_fx_only_years,
           sum(not missing(rndadv) and not missing(rndadv_fx)) as rnd_overlap_years,
           max(case when not missing(rndadv) and not missing(rndadv_fx)
                    then abs(rndadv-rndadv_fx) else . end) as rnd_max_abs_diff,
           sum(not missing(rndadv) and missing(rndadv_fx)) as rnd_raw_only_years,
           sum(not missing(rndadv_fx) and missing(rndadv)) as rnd_fx_only_years
    from work.controls_annual;
quit;
title;

proc means data=work.controls_annual nway noprint;
    class gvkey;
    var roa div lev lev_fx size salesgro rndadv rndadv_fx;
    output out=work.controls_summary(drop=_TYPE_ _FREQ_)
        n(roa)=n_roa n(div)=n_div n(lev)=n_lev n(lev_fx)=n_lev_fx n(size)=n_size
        n(salesgro)=n_salesgro n(rndadv)=n_rndadv n(rndadv_fx)=n_rndadv_fx
        mean(roa)=roa std(roa)=stdroa mean(div)=div mean(lev)=lev mean(lev_fx)=lev_fx
        mean(size)=size mean(salesgro)=salesgro mean(rndadv)=rndadv mean(rndadv_fx)=rndadv_fx;
run;

proc means data=work.conacc_annual nway noprint;
    class gvkey;
    var acc_raw acc_xdp;
    output out=work.conacc_summary(drop=_TYPE_ _FREQ_)
        n(acc_raw)=n_conacc mean(acc_raw)=mean_acc_raw
        n(acc_xdp)=n_conacc_xdp mean(acc_xdp)=mean_acc_xdp;
run;

data work.conacc_summary;
    set work.conacc_summary;
    if n_conacc>=1 then conacc=-mean_acc_raw;
    if n_conacc_xdp>=1 then conacc_xdp=-mean_acc_xdp;
run;

proc sql;
    create table work.main_pre as
    select c.gvkey, c.conmkt,
           x.n_roa, x.n_div, x.n_lev, x.n_lev_fx, x.n_size, x.n_salesgro,
           x.n_rndadv, x.n_rndadv_fx,
           x.roa, x.stdroa, x.div, x.lev, x.lev_fx, x.size, x.salesgro,
           x.rndadv, x.rndadv_fx,
           a.n_conacc, a.conacc, a.n_conacc_xdp, a.conacc_xdp,
           m.n_pairs as n_market_pairs, m.beta, m.mse
    from work.conmkt_byfirm as c
    left join work.controls_summary as x on c.gvkey=x.gvkey
    left join work.conacc_summary as a on c.gvkey=a.gvkey
    left join work.market_model as m on c.gvkey=m.gvkey;
quit;

title "Available-period and market-model screen diagnostics among rated CONMKT support firms";
proc sql;
    select count(*) as rated_support_firms,
           sum(n_roa>=2) as firms_with_roa_sd,
           sum(n_div>=1) as firms_with_div,
           sum(n_lev>=1) as firms_with_lev,
           sum(n_size>=1) as firms_with_size,
           sum(n_salesgro>=1) as firms_with_sales_growth,
           sum(n_rndadv>=1) as firms_with_rndadv,
           sum(n_rndadv_fx>=1) as firms_with_fx_based_rndadv,
           sum(n_rndadv>n_rndadv_fx) as firms_more_rndadv_years,
           sum(n_rndadv_fx>n_rndadv) as firms_more_fx_years,
           sum(n_rndadv=n_rndadv_fx) as firms_equal_rndadv_years,
           sum(n_rndadv>=1 and n_rndadv_fx=0) as firms_rndadv_fx_gain,
           sum(n_rndadv) as native_rndadv_years,
           sum(n_rndadv_fx) as fx_based_rndadv_years,
           sum(n_lev>=1) as firms_with_native_lev,
           sum(n_lev_fx>=1) as firms_with_fx_based_lev,
           sum(n_market_pairs>=24) as firms_with_24_months,
           sum(not missing(beta)) as firms_with_beta,
           sum(not missing(mse)) as firms_with_mse,
           sum(n_conacc>=1) as firms_with_conacc_dp,
           sum(n_conacc_xdp>=1) as firms_with_conacc_xdp
    from work.main_pre;
quit;
title;

data out.main;
    set work.main_pre;
    if n_roa>=2 and n_div>=1 and n_lev>=1 and n_size>=1 and
       n_salesgro>=1 and n_rndadv>=1 and n_market_pairs>=24 and
       not missing(conmkt) and not missing(beta) and not missing(mse);
    elig_mkt=1;
    elig_acc=(n_conacc>=1 and not missing(conacc));

    label conmkt="CONMKT: negative relative firm effect"
          conacc="CONACC: negative mean accrual ratio"
          stdroa="STDROA: available-year sample SD of ROA"
          div="DIV: mean common dividends / assets"
          lev="LEV: mean long-term debt / assets"
          roa="ROA: mean income before extraordinary items / assets"
          size="SIZE: mean log total assets (USD millions)"
          salesgro="SALESGRO: mean annual sales growth"
          rndadv="RNDADV: mean research and advertising / sales"
          rndadv_fx="Audit: RNDADV after USD rate conversion"
          lev_fx="Audit: LEV after USD rate conversion"
          beta="Market-model beta"
          mse="Market-model mean squared residual"
          elig_mkt="Table 3 Panel A eligibility"
          elig_acc="Table 3 Panel B eligibility";
run;

title "Final Table 3 analysis sample counts";
proc sql;
    select count(*) as conmkt_firm_rows,
           sum(elig_mkt=1) as conmkt_eligible,
           sum(elig_acc=1) as conacc_eligible,
           sum(n_market_pairs>=24) as market_model_screened,
           sum(n_conacc>=1) as conacc_dp_available,
           sum(n_conacc_xdp>=1) as conacc_xdp_available
    from out.main;

    select count(*) as table3_conmkt_firms,
           sum(l.lc_months_9398>0) as table3_firms_with_lc_months,
           sum(l.lc_months_9398=0) as table3_firms_without_lc_months,
           sum(l.lc_months_9398) as table3_lc_months
    from out.main as m
    left join work.support_lc_coverage as l on m.gvkey=l.gvkey;
quit;
title;

title "Descriptive statistics for the actual Table 3 sample";
proc means data=out.main n nmiss mean std p25 median p75;
    var conmkt conacc stdroa div lev roa size salesgro rndadv beta mse;
run;
title;

proc contents data=out.main;
run;
