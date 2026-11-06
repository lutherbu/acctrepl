options errorabend nodate nonumber nocenter;

/* Source data are read-only; writable SAS data stay in this assigned attempt. */
libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname ccm  "/storage/sas/base/crsp/a_ccm" access=readonly;
libname crsp "/storage/sas/base/crsp/a_stock" access=readonly;
libname fxsrc "/storage/sas/base/comp/d_global/currency" access=readonly;
libname out "data";

proc freq data=comp.funda;
    where fyear between 1984 and 2006;
    tables indfmt*consol*datafmt*popsrc / list missing;
    title "COMP.FUNDA annual format filters, construction years 1984-2006";
run;

proc freq data=ccm.ccmxpf_linktable;
    tables linktype linkprim usedflag / missing;
    title "CCM link-type, primary-marker, and used-flag distributions";
run;

/* Current annual fields were checked against the catalog. Provider-guide
   item crosswalks are documented in design.md. The raw 1984-2006 range gives
   five A&R years through t-4, the t-5 sales-growth input, lagged profitability,
   and the t+1 outcome through fiscal 2006. */
data annual_raw;
    set comp.funda(keep=gvkey datadate fyear fyr indfmt consol popsrc datafmt
        curcd currtr final fdate pdate sich fic
        sale ni ceq che ivao dlc dltt pstk tstkp dvpa mib
        xint dvp idit msa recta
        oancf ivncf fincf
        dvc capx csho prcc_f);
    where fyear between 1984 and 2006
      and upcase(indfmt)='INDL'
      and upcase(consol)='C'
      and upcase(popsrc)='D'
      and upcase(datafmt)='STD';
    format datadate yymmdd10. fdate yymmdd10. pdate yymmdd10.;
    curcd_up=upcase(strip(curcd));
    label curcd_up="Uppercase reporting currency code";
run;

proc freq data=annual_raw;
    tables curcd_up fyr sich fic / missing;
    title "Compustat currencies, fiscal year-end months, and historical SIC";
run;

proc means data=annual_raw n nmiss;
    var sale ni ceq che ivao dlc dltt pstk tstkp dvpa mib xint dvp idit
        msa recta oancf ivncf fincf dvc capx csho prcc_f currtr;
    title "Raw-input missingness before component construction";
run;

/* The chosen standard Compustat filters should yield one report per GVKEY and
   fiscal year. Stop instead of silently choosing a vintage if they do not. */
proc sql noprint;
    create table annual_duplicate_keys as
    select gvkey, fyear, count(*) as n_records
    from annual_raw
    group by gvkey, fyear
    having calculated n_records>1;
    select count(*) into :annual_duplicate_key_count trimmed
    from annual_duplicate_keys;
quit;
%put NOTE: Duplicate COMP.FUNDA GVKEY-FYEAR keys after standard filters = &annual_duplicate_key_count.;
data _null_;
    if &annual_duplicate_key_count > 0 then do;
        put "ERROR: Duplicate annual keys need a documented report-vintage rule before construction.";
        abort cancel;
    end;
run;

/* The analysis window stays FY1989-2005 and accounting support stays
   FY1984-2006. Only FX input coverage extends to the last non-USD FY2006
   record that can be a one-year lead for a FY2005 firm. This uses its actual
   fiscal date, not a calendar-year cap or a broader CRSP/accounting window. */
proc sql noprint;
    select max(f.datadate) into :fx_source_end trimmed
    from annual_raw as f
    inner join (select distinct gvkey from annual_raw where fyear=2005) as t
      on f.gvkey=t.gvkey
    where f.fyear=2006 and not missing(f.curcd_up)
      and f.curcd_up ne 'USD';
    select put(max(f.datadate),date9.) into :fx_source_end_label trimmed
    from annual_raw as f
    inner join (select distinct gvkey from annual_raw where fyear=2005) as t
      on f.gvkey=t.gvkey
    where f.fyear=2006 and not missing(f.curcd_up)
      and f.curcd_up ne 'USD';
quit;
%put NOTE: Required non-USD FY2006 lead FX source boundary=&fx_source_end_label.;

/* Compustat's Xpressfeed currency procedure quotes daily and monthly
   exchanges from GBP to each target currency. A reported-currency amount in
   USD is amount * (GBP->USD rate / GBP->reported-currency rate). The provider
   specifies daily rates for balance-sheet and price data, and EXRAT12M for
   income-statement and cash-flow data. Daily cross-rate legs must use a
   coherent shared quote date no later than the actual fiscal date. Each leg's
   EXRATTPD and date are retained as provenance; type differences do not imply
   different currency units. CURRTR is kept for a direction/coverage audit. */
data fx_daily_source_all;
    set fxsrc.g_exrt_dly(keep=datadate exratd exrattpd fromcurd tocurd
        where=(upcase(fromcurd)='GBP'
               and datadate>='01JAN1980'd
               and datadate<=&fx_source_end));
    currency=upcase(strip(tocurd));
    if not missing(currency);
    format datadate yymmdd10.;
    label currency="Target currency"
          exratd="GBP-to-target daily exchange rate"
          exrattpd="Provider daily exchange-rate type";
run;

/* EXRATTPD describes whether a daily quote is actual or carried forward.
   Keep every positive quote with known GBP/target currency and date, including
   blank or differing descriptors. The source does not authorize treating
   only 'AR' rows as valid currency observations. */
data fx_daily_source;
    set fx_daily_source_all;
    if not missing(exratd) and exratd>0;
run;

data fx_monthly_source;
    set fxsrc.g_exrt_mth(keep=datadate exrat12m fromcurm tocurm
        where=(upcase(fromcurm)='GBP'
               and datadate>='01JAN1980'd
               and datadate<=&fx_source_end));
    currency=upcase(strip(tocurm));
    if not missing(currency) and not missing(exrat12m) and exrat12m>0;
    format datadate yymmdd10.;
    label currency="Target currency"
          exrat12m="GBP-to-target trailing 12-month average rate";
run;

proc sql;
    create table fx_daily_duplicates as
    select datadate, currency, count(*) as n_records
    from fx_daily_source
    group by datadate, currency
    having calculated n_records>1;
    create table fx_monthly_duplicates as
    select datadate, currency, count(*) as n_records
    from fx_monthly_source
    group by datadate, currency
    having calculated n_records>1;
    select count(*) into :fx_daily_duplicate_keys trimmed from fx_daily_duplicates;
    select count(*) into :fx_monthly_duplicate_keys trimmed from fx_monthly_duplicates;
quit;
%put NOTE: GBP-to-currency positive daily rate duplicate keys=&fx_daily_duplicate_keys.;
%put NOTE: GBP-to-currency monthly rate duplicate keys=&fx_monthly_duplicate_keys.;
data _null_;
    if &fx_daily_duplicate_keys>0 or &fx_monthly_duplicate_keys>0 then do;
        put "ERROR: Positive GBP-to-currency exchange-rate key is not unique.";
        abort cancel;
    end;
run;

proc freq data=fx_daily_source_all;
    tables exrattpd / missing;
    title "Xpressfeed daily rate-type provenance, including missing descriptors";
run;
proc sql;
    create table fx_daily_type_counts as
    select exrattpd, count(*) as n_rates
    from fx_daily_source_all
    group by exrattpd;
quit;
data _null_;
    set fx_daily_type_counts;
    put "AUDIT FX_DAILY_TYPE " exrattpd= n_rates=;
run;

proc sql;
    create table annual_currency_dates as
    select distinct datadate, curcd_up as currency length=3
    from annual_raw
    where not missing(curcd_up);

    create table daily_pair_map as
    select a.datadate, a.currency,
           max(l.datadate) as rate_date format=yymmdd10.
    from annual_currency_dates as a
    inner join fx_daily_source as l
      on a.currency=l.currency and l.datadate<=a.datadate
     and l.datadate>=a.datadate-7
    inner join fx_daily_source as u
      on u.currency='USD' and u.datadate=l.datadate
    where a.currency ne 'USD'
    group by a.datadate, a.currency;

    create table daily_pair as
    select m.datadate, m.currency,
           l.datadate as fx_daily_date format=yymmdd10.,
           u.datadate as fx_usd_daily_date format=yymmdd10.,
           l.exratd as gbp_to_reported_daily,
           u.exratd as gbp_to_usd_daily,
           l.exrattpd as reported_rate_type,
           u.exrattpd as usd_rate_type
    from daily_pair_map as m
    left join fx_daily_source as l
      on m.currency=l.currency and m.rate_date=l.datadate
    left join fx_daily_source as u
      on u.currency='USD' and m.rate_date=u.datadate;

    create table monthly_local_map as
    select a.datadate, a.currency,
           max(r.datadate) as rate_date format=yymmdd10.
    from annual_currency_dates as a
    left join fx_monthly_source as r
      on a.currency=r.currency and r.datadate<=a.datadate
     and r.datadate>=intnx('month',a.datadate,-1,'end')
    group by a.datadate, a.currency;

    create table monthly_usd_map as
    select a.datadate,
           max(r.datadate) as rate_date format=yymmdd10.
    from (select distinct datadate from annual_raw) as a
    left join fx_monthly_source as r
      on r.currency='USD' and r.datadate<=a.datadate
     and r.datadate>=intnx('month',a.datadate,-1,'end')
    group by a.datadate;

    create table monthly_local as
    select m.datadate, m.currency, m.rate_date,
           r.exrat12m as gbp_to_reported_12m
    from monthly_local_map as m
    left join fx_monthly_source as r
      on m.currency=r.currency and m.rate_date=r.datadate;

    create table monthly_usd as
    select m.datadate, m.rate_date,
           r.exrat12m as gbp_to_usd_12m
    from monthly_usd_map as m
    left join fx_monthly_source as r
      on r.currency='USD' and m.rate_date=r.datadate;

    create table annual_fx as
    select a.*, dp.fx_daily_date,
           dp.fx_usd_daily_date,
           ml.rate_date as fx_12m_date format=yymmdd10.,
           mu.rate_date as fx_usd_12m_date format=yymmdd10.,
           dp.gbp_to_reported_daily, dp.gbp_to_usd_daily,
           ml.gbp_to_reported_12m, mu.gbp_to_usd_12m,
           dp.reported_rate_type, dp.usd_rate_type
    from annual_raw as a
    left join daily_pair as dp
      on a.datadate=dp.datadate and a.curcd_up=dp.currency
    left join monthly_local as ml
      on a.datadate=ml.datadate and a.curcd_up=ml.currency
    left join monthly_usd as mu
      on a.datadate=mu.datadate;
quit;

data annual_fx;
    set annual_fx;
    length fx_daily_match_status $8;
    if curcd_up='USD' then do;
        fx_bs_usd=1;
        fx_flow_usd=1;
        fx_daily_match_status='USD';
    end;
    else do;
        if not missing(gbp_to_reported_daily) and gbp_to_reported_daily>0
           and not missing(gbp_to_usd_daily) and gbp_to_usd_daily>0
           and not missing(fx_daily_date) and fx_daily_date=fx_usd_daily_date
           and fx_daily_date<=datadate and datadate-fx_daily_date<=7 then do;
            fx_bs_usd=gbp_to_usd_daily/gbp_to_reported_daily;
            if fx_daily_date=datadate then fx_daily_match_status='EXACT';
            else fx_daily_match_status='FALLBACK';
        end;
        else do;
            fx_bs_usd=.;
            fx_daily_match_status='MISSING';
        end;
        if not missing(gbp_to_reported_12m) and gbp_to_reported_12m>0
           and not missing(gbp_to_usd_12m) and gbp_to_usd_12m>0
            then fx_flow_usd=gbp_to_usd_12m/gbp_to_reported_12m;
        else fx_flow_usd=.;
    end;
    if curcd_up ne 'USD' and not missing(currtr) and currtr>0
       and not missing(fx_bs_usd) and fx_bs_usd>0 then do;
        currtr_direct_ratio=currtr/fx_bs_usd;
        currtr_reciprocal_product=currtr*fx_bs_usd;
        if abs(log(currtr_direct_ratio))<=0.01 then currtr_matches_direct=1;
        else currtr_matches_direct=0;
        if abs(log(currtr_reciprocal_product))<=0.01 then currtr_matches_reciprocal=1;
        else currtr_matches_reciprocal=0;
    end;
    label fx_bs_usd="USD per reported-currency unit, daily point-in-time rate"
          fx_flow_usd="USD per reported-currency unit, trailing 12-month average rate"
          currtr_direct_ratio="CURRTR divided by provider USD/reporting cross-rate"
          currtr_reciprocal_product="CURRTR times provider USD/reporting cross-rate"
          fx_daily_match_status="Same-date daily-pair status relative to fiscal date";
run;

proc sql;
    create table fx_coverage_by_currency as
    select curcd_up, count(*) as n_annual_rows,
           sum(curcd_up ne 'USD' and missing(fx_bs_usd)) as n_daily_missing,
           sum(curcd_up ne 'USD' and missing(fx_flow_usd)) as n_12m_missing,
           sum(curcd_up ne 'USD' and fx_daily_match_status='EXACT') as n_daily_exact,
           sum(curcd_up ne 'USD' and fx_daily_match_status='FALLBACK') as n_daily_fallback,
           sum(not missing(fx_daily_date) and fx_daily_date<datadate) as n_daily_carried,
           sum(not missing(fx_12m_date) and fx_12m_date<datadate) as n_12m_prior_month
    from annual_fx
    group by curcd_up;
    create table fx_coverage_by_fyear as
    select fyear, curcd_up, count(*) as n_annual_rows,
           min(datadate) as first_datadate format=yymmdd10.,
           max(datadate) as last_datadate format=yymmdd10.,
           sum(curcd_up ne 'USD' and missing(fx_bs_usd)) as n_daily_missing,
           sum(curcd_up ne 'USD' and missing(fx_flow_usd)) as n_12m_missing,
           sum(curcd_up ne 'USD' and not missing(fx_daily_date)
               and fx_daily_date=datadate) as n_daily_exact,
           sum(curcd_up ne 'USD' and not missing(fx_daily_date)
               and fx_daily_date<datadate) as n_daily_prior,
           sum(curcd_up ne 'USD' and fx_daily_match_status='FALLBACK')
               as n_daily_fallback,
           max(datadate-fx_daily_date) as max_daily_age_days,
           sum(curcd_up ne 'USD' and not missing(fx_12m_date)
               and fx_12m_date=datadate) as n_12m_exact,
           sum(curcd_up ne 'USD' and not missing(fx_12m_date)
               and fx_12m_date<datadate) as n_12m_prior,
           max(datadate-fx_12m_date) as max_12m_age_days
    from annual_fx
    where fyear=2006
    group by fyear, curcd_up;

    create table fx_coverage_post2006 as
    select curcd_up, count(*) as n_annual_rows,
           min(datadate) as first_datadate format=yymmdd10.,
           max(datadate) as last_datadate format=yymmdd10.,
           sum(missing(fx_bs_usd)) as n_daily_missing,
           sum(missing(fx_flow_usd)) as n_12m_missing,
           sum(not missing(fx_daily_date) and fx_daily_date=datadate)
               as n_daily_exact,
           sum(not missing(fx_daily_date) and fx_daily_date<datadate)
               as n_daily_prior,
           max(datadate-fx_daily_date) as max_daily_age_days,
           sum(not missing(fx_12m_date) and fx_12m_date=datadate)
               as n_12m_exact,
           sum(not missing(fx_12m_date) and fx_12m_date<datadate)
               as n_12m_prior,
           max(datadate-fx_12m_date) as max_12m_age_days
    from annual_fx
    where fyear=2006 and datadate>'31DEC2006'd
    group by curcd_up;

    create table currtr_audit_by_currency as
    select curcd_up, count(*) as n_compared,
           sum(currtr_matches_direct) as n_currtr_direct,
           sum(currtr_matches_reciprocal) as n_currtr_reciprocal,
           mean(currtr_direct_ratio) as mean_direct_ratio,
           mean(currtr_reciprocal_product) as mean_reciprocal_product
    from annual_fx
    where curcd_up ne 'USD' and not missing(currtr_direct_ratio)
    group by curcd_up;
quit;

/* Reconstruct the previous A4 daily selection only as an audit benchmark:
   it required AR and chose each currency leg independently. Compare every
   former A4 daily miss with the repaired shared-date pair, and identify any
   observations where the old method had a factor that the coherent pair no
   longer supports. This does not feed accounting values or the analysis. */
data fx_daily_a4_source;
    set fx_daily_source_all;
    if upcase(strip(exrattpd))='AR'
       and not missing(exratd) and exratd>0;
run;
proc sql;
    create table fx_daily_a4_local_map as
    select a.datadate, a.currency,
           max(r.datadate) as rate_date format=yymmdd10.
    from annual_currency_dates as a
    left join fx_daily_a4_source as r
      on a.currency=r.currency and r.datadate<=a.datadate
     and r.datadate>=a.datadate-7
    group by a.datadate, a.currency;

    create table fx_daily_a4_usd_map as
    select a.datadate,
           max(r.datadate) as rate_date format=yymmdd10.
    from (select distinct datadate from annual_raw) as a
    left join fx_daily_a4_source as r
      on r.currency='USD' and r.datadate<=a.datadate
     and r.datadate>=a.datadate-7
    group by a.datadate;

    create table fx_daily_a4_local as
    select m.datadate, m.currency, m.rate_date,
           r.exratd as gbp_to_reported_a4
    from fx_daily_a4_local_map as m
    left join fx_daily_a4_source as r
      on m.currency=r.currency and m.rate_date=r.datadate;

    create table fx_daily_a4_usd as
    select m.datadate, m.rate_date,
           r.exratd as gbp_to_usd_a4
    from fx_daily_a4_usd_map as m
    left join fx_daily_a4_source as r
      on r.currency='USD' and m.rate_date=r.datadate;

    create table fx_daily_a4_by_currency as
    select a.datadate, a.currency,
           l.rate_date as a4_fx_daily_date format=yymmdd10.,
           u.rate_date as a4_fx_usd_daily_date format=yymmdd10.,
           l.gbp_to_reported_a4, u.gbp_to_usd_a4
    from annual_currency_dates as a
    left join fx_daily_a4_local as l
      on a.datadate=l.datadate and a.currency=l.currency
    left join fx_daily_a4_usd as u
      on a.datadate=u.datadate;

    create table fx_daily_repair_audit as
    select a.datadate, a.fyear, a.gvkey, a.curcd_up,
           a.fx_daily_match_status, a.fx_daily_date,
           a.fx_usd_daily_date, a.reported_rate_type, a.usd_rate_type,
           old.a4_fx_daily_date, old.a4_fx_usd_daily_date,
           old.gbp_to_reported_a4, old.gbp_to_usd_a4
    from annual_fx as a
    left join fx_daily_a4_by_currency as old
      on a.datadate=old.datadate and a.curcd_up=old.currency;
quit;

data fx_daily_repair_audit;
    set fx_daily_repair_audit;
    if curcd_up='USD' then a4_fx_bs_usd=1;
    else if not missing(gbp_to_reported_a4) and gbp_to_reported_a4>0
         and not missing(gbp_to_usd_a4) and gbp_to_usd_a4>0
        then a4_fx_bs_usd=gbp_to_usd_a4/gbp_to_reported_a4;
    else a4_fx_bs_usd=.;
run;

proc sql;
    create table fx_daily_repair_by_year as
    select curcd_up, fyear, count(*) as n_annual_rows,
           sum(curcd_up ne 'USD' and missing(a4_fx_bs_usd))
               as n_a4_daily_missing,
           sum(curcd_up ne 'USD' and missing(a4_fx_bs_usd)
               and fx_daily_match_status='EXACT') as n_a4_miss_restored_exact,
           sum(curcd_up ne 'USD' and missing(a4_fx_bs_usd)
               and fx_daily_match_status='FALLBACK') as n_a4_miss_restored_fallback,
           sum(curcd_up ne 'USD' and missing(a4_fx_bs_usd)
               and fx_daily_match_status='MISSING') as n_a4_miss_still_missing,
           sum(curcd_up ne 'USD' and not missing(a4_fx_bs_usd)
               and fx_daily_match_status='MISSING') as n_a4_rate_lost_coherence
    from fx_daily_repair_audit
    group by curcd_up, fyear;
    create table fx_daily_repair_by_currency as
    select curcd_up, count(*) as n_annual_rows,
           sum(curcd_up ne 'USD' and missing(a4_fx_bs_usd))
               as n_a4_daily_missing,
           sum(curcd_up ne 'USD' and missing(a4_fx_bs_usd)
               and fx_daily_match_status='EXACT') as n_a4_miss_restored_exact,
           sum(curcd_up ne 'USD' and missing(a4_fx_bs_usd)
               and fx_daily_match_status='FALLBACK') as n_a4_miss_restored_fallback,
           sum(curcd_up ne 'USD' and missing(a4_fx_bs_usd)
               and fx_daily_match_status='MISSING') as n_a4_miss_still_missing,
           sum(curcd_up ne 'USD' and not missing(a4_fx_bs_usd)
               and fx_daily_match_status='MISSING') as n_a4_rate_lost_coherence
    from fx_daily_repair_audit
    group by curcd_up;
    create table fx_daily_pair_provenance as
    select curcd_up, fx_daily_match_status,
           reported_rate_type, usd_rate_type, count(*) as n_rows
    from annual_fx
    where curcd_up ne 'USD' and not missing(fx_bs_usd)
    group by curcd_up, fx_daily_match_status,
             reported_rate_type, usd_rate_type;
quit;

proc print data=fx_coverage_by_currency noobs;
    title "Currency-rate coverage by annual reporting currency";
run;
proc print data=fx_daily_repair_by_currency noobs;
    title "Daily FX comparison with A4 AR-only independent-leg selection";
run;
proc print data=fx_daily_pair_provenance noobs;
    title "Selected same-date daily FX pairs with each leg's type provenance";
run;
proc print data=currtr_audit_by_currency noobs;
    title "CURRTR direction check against provider daily USD cross-rates";
run;
data _null_;
    set fx_coverage_by_currency;
    put "AUDIT FX_COVERAGE " curcd_up= n_annual_rows= n_daily_missing=
        n_12m_missing= n_daily_exact= n_daily_fallback= n_daily_carried=
        n_12m_prior_month=;
run;
data _null_;
    set fx_daily_repair_by_currency;
    put "AUDIT FX_A4_DAILY_REPAIR " curcd_up= n_annual_rows=
        n_a4_daily_missing= n_a4_miss_restored_exact=
        n_a4_miss_restored_fallback= n_a4_miss_still_missing=
        n_a4_rate_lost_coherence=;
run;
data _null_;
    set fx_daily_repair_by_year;
    if curcd_up='CAD';
    put "AUDIT FX_A4_DAILY_REPAIR_YEAR " curcd_up= fyear=
        n_annual_rows= n_a4_daily_missing= n_a4_miss_restored_exact=
        n_a4_miss_restored_fallback= n_a4_miss_still_missing=
        n_a4_rate_lost_coherence=;
run;
data _null_;
    set fx_daily_pair_provenance;
    put "AUDIT FX_DAILY_PAIR_TYPES " curcd_up= fx_daily_match_status=
        reported_rate_type= usd_rate_type= n_rows=;
run;
data _null_;
    set currtr_audit_by_currency;
    put "AUDIT CURRTR_DIRECTION " curcd_up= n_compared= n_currtr_direct=
        n_currtr_reciprocal= mean_direct_ratio= mean_reciprocal_product=;
run;
data _null_;
    set fx_coverage_by_fyear;
    put "AUDIT FX_FY2006_COVERAGE " curcd_up= n_annual_rows=
        first_datadate= last_datadate= n_daily_missing= n_12m_missing=
        n_daily_exact= n_daily_prior= max_daily_age_days= n_12m_exact=
        n_12m_prior= max_12m_age_days=;
run;
data _null_;
    set fx_coverage_post2006;
    put "AUDIT FX_POST2006_COVERAGE " curcd_up= n_annual_rows=
        first_datadate= last_datadate= n_daily_missing= n_12m_missing=
        n_daily_exact= n_daily_prior= max_daily_age_days= n_12m_exact=
        n_12m_prior= max_12m_age_days=;
run;

data annual;
    set annual_fx;

    /* Missing source components remain missing; a named Appendix A input is
       not silently replaced by an invented zero. */
    sale_usd=sale*fx_flow_usd;
    ni_usd=ni*fx_flow_usd;
    oancf_usd=oancf*fx_flow_usd;
    ivncf_usd=ivncf*fx_flow_usd;
    fincf_usd=fincf*fx_flow_usd;
    xint_usd=xint*fx_flow_usd;
    dvp_usd=dvp*fx_flow_usd;
    idit_usd=idit*fx_flow_usd;
    dvc_usd=dvc*fx_flow_usd;
    capx_usd=capx*fx_flow_usd;

    ceq_usd=ceq*fx_bs_usd;
    che_usd=che*fx_bs_usd;
    ivao_usd=ivao*fx_bs_usd;
    dlc_usd=dlc*fx_bs_usd;
    dltt_usd=dltt*fx_bs_usd;
    pstk_usd=pstk*fx_bs_usd;
    tstkp_usd=tstkp*fx_bs_usd;
    dvpa_usd=dvpa*fx_bs_usd;
    mib_usd=mib*fx_bs_usd;
    msa_usd=msa*fx_bs_usd;
    recta_usd=recta*fx_bs_usd;
    mve_compustat_raw=prcc_f*csho;
    mve_compustat_usd=mve_compustat_raw*fx_bs_usd;

    if n(dlc_usd,dltt_usd,pstk_usd,tstkp_usd,dvpa_usd)=5
        then fo_usd=dlc_usd+dltt_usd+pstk_usd-tstkp_usd+dvpa_usd;
    else fo_usd=.;
    if n(che_usd,ivao_usd)=2 then fa_usd=che_usd+ivao_usd;
    else fa_usd=.;
    if n(ceq_usd,tstkp_usd,dvpa_usd)=3 then cse_usd=ceq_usd+tstkp_usd-dvpa_usd;
    else cse_usd=.;
    if n(fo_usd,fa_usd)=2 then nfo_usd=fo_usd-fa_usd;
    else nfo_usd=.;
    if n(nfo_usd,cse_usd,mib_usd)=3 then noa_usd=nfo_usd+cse_usd+mib_usd;
    else noa_usd=.;
    /* Retain the Appendix A intermediate-based construction as a strict
       comparator.  For the final NOA, substitute FO/FA/CSE and cancel the
       shared TSTKP and DVPA terms before applying input completeness. */
    noa_strict_usd=noa_usd;
    if n(dlc_usd,dltt_usd,pstk_usd,che_usd,ivao_usd,ceq_usd,mib_usd)=7
       then noa_usd=dlc_usd+dltt_usd+pstk_usd-che_usd-ivao_usd+ceq_usd+mib_usd;
    else noa_usd=.;
    label fo_usd="Financial obligations, USD millions"
          fa_usd="Financial assets, USD millions"
          cse_usd="Common equity, USD millions"
          nfo_usd="Net financial obligation, USD millions"
          noa_strict_usd="Strict Appendix A intermediate-based NOA, USD millions"
          noa_usd="Net operating assets, USD millions";
run;

/* Primary CRSP links are matched at each actual Compustat fiscal date.
   LINKPRIM P/C and LINKTYPE LC/LU are provider-defined direct primary links;
   USEDFLAG=1 selects links used for the CRSP composite history. */
proc sql;
    create table comp_dates as
    select gvkey, fyear, datadate
    from annual
    where fyear between 1984 and 2006;

    create table link_candidates as
    select a.gvkey, a.fyear, a.datadate,
           b.lpermno as permno, b.lpermco as permco,
           b.liid, b.linkprim, b.linktype, b.usedflag,
           b.linkdt, b.linkenddt
    from comp_dates as a
    inner join ccm.ccmxpf_linktable as b
      on a.gvkey=b.gvkey
     and b.linkdt<=a.datadate
     and (missing(b.linkenddt) or a.datadate<=b.linkenddt)
    where b.lpermno>0
      and b.usedflag=1
      and b.linkprim in ('P','C')
      and b.linktype in ('LC','LU');

    create table dated_name_links as
    select a.*, n.shrcd, n.exchcd, n.namedt, n.nameendt
    from link_candidates as a
    inner join crsp.msenames as n
      on a.permno=n.permno
     and n.namedt<=a.datadate
     and (missing(n.nameendt) or a.datadate<=n.nameendt)
    where n.exchcd in (1,2,3)
      and n.shrcd in (10,11,12);

    create table link_candidate_counts as
    select gvkey, fyear, datadate, count(*) as n_valid_links
    from dated_name_links
    group by gvkey, fyear, datadate;
quit;

proc sql noprint;
    select count(*) into :linked_periods trimmed from link_candidate_counts;
    select sum(n_valid_links>1) into :multiple_link_periods trimmed
    from link_candidate_counts;
quit;
%put NOTE: Firm-years with a date-valid CCM link and CRSP ordinary-common listing = &linked_periods.;
%put NOTE: Firm-years with multiple qualifying CRSP links before selection = &multiple_link_periods.;

proc sort data=dated_name_links; by gvkey fyear datadate; run;
proc sort data=link_candidate_counts; by gvkey fyear datadate; run;
data ranked_links;
    merge dated_name_links link_candidate_counts;
    by gvkey fyear datadate;
    if linkprim='P' then prim_rank=1; else prim_rank=2;
    if linktype='LC' then type_rank=1; else type_rank=2;
run;
proc sort data=ranked_links;
    by gvkey fyear datadate prim_rank type_rank descending linkdt liid permno;
run;
data link_best;
    set ranked_links;
    by gvkey fyear datadate;
    if first.datadate;
run;

proc sql;
    create table permno_pool as
    select distinct permno
    from link_best;

    /* First CRSP monthly record for each selected PERMNO. This is the paper's
       stated CRSP first-appearance age proxy; no later date fills a gap. */
    create table permno_first as
    select s.permno, min(s.date) as first_crsp_date format=yymmdd10.
    from crsp.msf as s
    inner join permno_pool as p
      on s.permno=p.permno
    where s.date<='31DEC2006'd
    group by s.permno;

    /* The paper defines firm age by the first CRSP appearance. When a firm
       has more than one valid PERMNO during the study period, use its earliest
       observed date across all of its selected, date-valid PERMNOs. */
    create table gvkey_first as
    select l.gvkey, min(p.first_crsp_date) as first_crsp_date format=yymmdd10.
    from (select distinct gvkey, permno from link_best) as l
    inner join permno_first as p
      on l.permno=p.permno
    group by l.gvkey;
quit;

/* Market value must be in USD. CURCD describes annual fundamentals; the
   provider warns that security-price currency can differ. Use CRSP's US
   monthly prices and shares for a USD firm market value, aggregating ordinary
   common classes under the selected PERMCO at the latest month-end no later
   than DATADATE. Keep the Compustat product for a source comparison only. */
proc sql;
    create table annual_permco as
    select a.*, l.permno, l.permco, l.shrcd as linked_shrcd,
           l.exchcd as linked_exchcd, gf.first_crsp_date
    from annual as a
    left join link_best as l
      on a.gvkey=l.gvkey and a.fyear=l.fyear and a.datadate=l.datadate
    left join gvkey_first as gf
      on a.gvkey=gf.gvkey;

    create table crsp_common_monthly0 as
    select s.permno, s.permco, s.date, s.prc, s.shrout
    from crsp.msf as s
    inner join crsp.msenames as n
      on s.permno=n.permno
     and n.namedt<=s.date
     and (missing(n.nameendt) or s.date<=n.nameendt)
     and n.shrcd in (10,11,12)
    where s.date between '01JAN1983'd and '31DEC2006'd;

    create table crsp_common_monthly_duplicates as
    select permno, date, count(*) as n_records
    from crsp_common_monthly0
    group by permno, date
    having calculated n_records>1;
    select count(*) into :crsp_msf_duplicate_keys trimmed
    from crsp_common_monthly_duplicates;
quit;
%put NOTE: CRSP common monthly duplicate PERMNO-DATE keys=&crsp_msf_duplicate_keys.;
data _null_;
    if &crsp_msf_duplicate_keys>0 then do;
        put "ERROR: Overlapping CRSP name-history rows duplicate monthly security observations.";
        abort cancel;
    end;
run;

proc sql;
    create table annual_market_date as
    select a.gvkey, a.fyear, a.datadate, a.permno, a.permco,
           max(s.date) as market_date format=yymmdd10.
    from annual_permco as a
    left join crsp_common_monthly0 as s
      on a.permno=s.permno
     and s.date<=a.datadate
     and s.date>=intnx('month',a.datadate,-1,'end')
    group by a.gvkey, a.fyear, a.datadate, a.permno, a.permco;

    /* Audit each common PERMNO under the selected PERMCO on the market date.
       Include active used primary and secondary mappings; CCM documents that
       an LS security can share a PERMCO with securities mapped to other
       GVKEYs. Do not silently blend those cases into a company MVE. */
    create table annual_mve_class_status as
    select a.gvkey, a.fyear, a.datadate, a.permco, d.market_date,
           s.permno as class_permno, s.prc, s.shrout,
           max(case when not missing(b.gvkey) and b.gvkey=a.gvkey then 1 else 0 end)
               as has_same_gvkey_link,
           max(case when not missing(b.gvkey) and b.gvkey ne a.gvkey then 1 else 0 end)
               as has_other_gvkey_link,
           max(case when not missing(b.gvkey) and b.linkprim in ('J','N') then 1 else 0 end)
               as has_jn_link,
           max(case when not missing(b.gvkey) and b.gvkey=a.gvkey
                         and b.linkprim in ('J','N') then 1 else 0 end)
               as has_same_gvkey_jn_link,
           max(case when not missing(b.gvkey) and b.gvkey ne a.gvkey
                         and b.linkprim in ('J','N') then 1 else 0 end)
               as has_other_gvkey_jn_link,
           max(case when not missing(b.gvkey) and b.linktype='LS' then 1 else 0 end)
               as has_ls_link,
           max(case when not missing(b.gvkey) and b.gvkey ne a.gvkey
                         and b.linktype='LS' then 1 else 0 end)
               as has_other_gvkey_ls_link,
           max(case when not missing(b.gvkey) then 1 else 0 end) as has_used_link,
           count(distinct case when not missing(b.gvkey) and b.gvkey ne a.gvkey
                               then b.gvkey else '' end) as n_other_gvkeys
    from annual_permco as a
    left join annual_market_date as d
      on a.gvkey=d.gvkey and a.fyear=d.fyear and a.datadate=d.datadate
     and a.permno=d.permno and a.permco=d.permco
    inner join crsp_common_monthly0 as s
      on a.permco=s.permco and d.market_date=s.date
    left join ccm.ccmxpf_linktable as b
      on s.permno=b.lpermno and s.permco=b.lpermco
     and b.linkdt<=d.market_date
     and (missing(b.linkenddt) or d.market_date<=b.linkenddt)
     and b.usedflag=1
     and b.linkprim in ('P','C','J','N')
     and b.linktype in ('LC','LU','LS')
    group by a.gvkey, a.fyear, a.datadate, a.permco, d.market_date,
             s.permno, s.prc, s.shrout;

    create table annual_mve_class_duplicates as
    select gvkey, fyear, datadate, permco, market_date, class_permno,
           count(*) as n_records
    from annual_mve_class_status
    group by gvkey, fyear, datadate, permco, market_date, class_permno
    having calculated n_records>1;
    select count(*) into :annual_mve_class_duplicate_keys trimmed
    from annual_mve_class_duplicates;

    create table annual_market_values as
    select a.gvkey, a.fyear, a.datadate, a.permno, a.permco, d.market_date,
           sum(abs(c.prc)*c.shrout/1000) as mve_crsp_usd,
           count(c.class_permno) as n_crsp_common_classes,
           sum(case when not missing(c.class_permno)
                         and (missing(c.prc) or missing(c.shrout))
                    then 1 else 0 end) as n_crsp_unpriced_classes,
           sum(case when c.has_same_gvkey_link=1 then 1 else 0 end)
               as n_crsp_same_gvkey_classes,
           sum(case when c.has_other_gvkey_link=1 then 1 else 0 end)
               as n_crsp_other_gvkey_classes,
           sum(case when c.has_other_gvkey_link=1 and c.has_same_gvkey_link=1
                    then 1 else 0 end) as n_crsp_multi_gvkey_classes,
           sum(case when c.has_other_gvkey_link=1 then c.n_other_gvkeys else 0 end)
               as n_crsp_other_gvkey_mappings,
           sum(case when c.has_jn_link=1 then 1 else 0 end) as n_crsp_jn_classes,
           sum(case when c.has_same_gvkey_jn_link=1 then 1 else 0 end)
               as n_crsp_same_gvkey_jn_classes,
           sum(case when c.has_other_gvkey_jn_link=1 then 1 else 0 end)
               as n_crsp_other_gvkey_jn_classes,
           sum(case when c.has_ls_link=1 then 1 else 0 end) as n_crsp_ls_classes,
           sum(case when c.has_other_gvkey_ls_link=1 then 1 else 0 end)
               as n_crsp_other_gvkey_ls_classes,
           sum(case when not missing(c.class_permno) and c.has_used_link=0
                    then 1 else 0 end) as n_crsp_unlinked_classes
    from annual_permco as a
    left join annual_market_date as d
      on a.gvkey=d.gvkey and a.fyear=d.fyear and a.datadate=d.datadate
     and a.permno=d.permno and a.permco=d.permco
    left join annual_mve_class_status as c
      on a.gvkey=c.gvkey and a.fyear=c.fyear and a.datadate=c.datadate
     and a.permco=c.permco and d.market_date=c.market_date
    group by a.gvkey, a.fyear, a.datadate, a.permno, a.permco, d.market_date;

    create table annual_market as
    select a.*, m.market_date, m.mve_crsp_usd,
           m.n_crsp_common_classes, m.n_crsp_unpriced_classes,
           m.n_crsp_same_gvkey_classes, m.n_crsp_other_gvkey_classes,
           m.n_crsp_multi_gvkey_classes, m.n_crsp_other_gvkey_mappings,
           m.n_crsp_jn_classes, m.n_crsp_same_gvkey_jn_classes,
           m.n_crsp_other_gvkey_jn_classes, m.n_crsp_ls_classes,
           m.n_crsp_other_gvkey_ls_classes, m.n_crsp_unlinked_classes
    from annual_permco as a
    left join annual_market_values as m
      on a.gvkey=m.gvkey and a.fyear=m.fyear and a.datadate=m.datadate;
quit;

%put NOTE: CRSP company-date common-class duplicate keys=&annual_mve_class_duplicate_keys.;
data _null_;
    if &annual_mve_class_duplicate_keys>0 then do;
        put "ERROR: Repeated CRSP class/link rows make company-date market equity ambiguous.";
        abort cancel;
    end;
run;

data annual_market;
    set annual_market;
    if n_crsp_common_classes>0 and n_crsp_unpriced_classes=0
       and n_crsp_other_gvkey_classes=0
       then mve_usd=mve_crsp_usd;
    else mve_usd=.;
    if not missing(mve_usd) and mve_usd>0
       then compustat_crsp_mve_ratio=mve_compustat_usd/mve_usd;
    else compustat_crsp_mve_ratio=.;
    label mve_crsp_usd="All CRSP PERMCO common classes, USD millions, including link conflicts"
          mve_compustat_usd="Compustat fiscal price times shares converted using annual fundamentals CURCD"
          mve_usd="Conflict-free CRSP PERMCO equity market value used for size screen and CAPX ratio"
          compustat_crsp_mve_ratio="Compustat market equity divided by CRSP PERMCO market equity";
run;

proc sql;
    create table market_value_currency_audit as
    select curcd_up, fic, count(*) as n_firm_years,
           sum(not missing(mve_usd) and not missing(mve_compustat_usd)) as n_both,
           mean(compustat_crsp_mve_ratio) as mean_compustat_crsp_ratio,
           sum(missing(mve_usd)) as n_crsp_mve_missing,
           sum(n_crsp_common_classes>1) as n_multi_class,
           sum(n_crsp_other_gvkey_classes>0) as n_conflicting_gvkey_firm_years,
           sum(n_crsp_multi_gvkey_classes>0) as n_multi_gvkey_class_firm_years,
           sum(n_crsp_other_gvkey_mappings) as n_other_gvkey_mappings,
           sum(n_crsp_jn_classes>0) as n_jn_class_firm_years,
           sum(n_crsp_same_gvkey_jn_classes>0) as n_same_gvkey_jn_firm_years,
           sum(n_crsp_other_gvkey_jn_classes>0) as n_other_gvkey_jn_firm_years,
           sum(n_crsp_ls_classes>0) as n_ls_class_firm_years,
           sum(n_crsp_other_gvkey_ls_classes>0) as n_other_gvkey_ls_firm_years,
           sum(n_crsp_unlinked_classes) as n_unlinked_classes,
           sum(n_crsp_unpriced_classes>0) as n_unpriced_class_sets,
           sum(not missing(market_date) and market_date<datadate) as n_prior_month_end,
           max(datadate-market_date) as max_market_date_age_days,
           sum(mve_usd>=1) as n_crsp_mve_ge_1m,
           sum(mve_compustat_usd>=1) as n_compustat_mve_ge_1m
    from annual_market
    where fyear between 1984 and 2006
    group by curcd_up, fic;
quit;
proc print data=market_value_currency_audit noobs;
    title "USD market-value screen diagnostic: Compustat product vs CRSP";
run;
data _null_;
    set market_value_currency_audit;
    put "AUDIT USD_MARKET_VALUE " curcd_up= fic= n_firm_years= n_both=
        mean_compustat_crsp_ratio= n_crsp_mve_missing= n_multi_class=
        n_conflicting_gvkey_firm_years= n_multi_gvkey_class_firm_years=
        n_other_gvkey_mappings= n_jn_class_firm_years=
        n_same_gvkey_jn_firm_years= n_other_gvkey_jn_firm_years=
        n_ls_class_firm_years= n_other_gvkey_ls_firm_years=
        n_unlinked_classes=
        n_unpriced_class_sets= n_prior_month_end= max_market_date_age_days=
        n_crsp_mve_ge_1m= n_compustat_mve_ge_1m=;
run;

/* Exact GVKEY/FYEAR joins keep missing fiscal years as gaps. */
proc sql;
    create table ratios0 as
    select a.*,
           l1.datadate as lag_datadate,
           l1.noa_usd as noa_l1_usd,
           l1.noa_strict_usd as noa_strict_l1_usd,
           l1.msa_usd as msa_l1_usd,
           l1.recta_usd as recta_l1_usd,
           l1.sale_usd as sale_l1_usd
    from annual_market as a
    left join annual_market as l1
      on a.gvkey=l1.gvkey and a.fyear=l1.fyear+1;
quit;

data annual_metrics;
    set ratios0;
    if fyear>=1988 and fyear<=1992 then mtr=0.36;
    else if fyear>=1993 and fyear<=2006 then mtr=0.37;
    else mtr=.;

    if n(noa_usd,noa_l1_usd)=2 then avg_noa_usd=(noa_usd+noa_l1_usd)/2;
    else avg_noa_usd=.;
    if n(noa_strict_usd,noa_strict_l1_usd)=2
       then avg_noa_strict_usd=(noa_strict_usd+noa_strict_l1_usd)/2;
    else avg_noa_strict_usd=.;

    /* Preserve the original strict intermediates, including missing values
       caused by DVP/MSA, while building reduced OI directly from the
       uncancelled Appendix A inputs.  Missing fields are never zero-filled. */
    if n(ni_usd,dvp_usd,msa_usd,msa_l1_usd,recta_usd,recta_l1_usd)=6 then
        cni_usd=ni_usd-dvp_usd+(msa_usd-msa_l1_usd)+(recta_usd-recta_l1_usd);
    else cni_usd=.;
    if n(xint_usd,dvp_usd,idit_usd,msa_l1_usd,msa_usd)=5 and not missing(mtr)
       then nfe_usd=xint_usd*(1-mtr)+dvp_usd-idit_usd*(1-mtr)+msa_l1_usd-msa_usd;
    else nfe_usd=.;
    if n(cni_usd,nfe_usd)=2 then oi_strict_usd=cni_usd+nfe_usd;
    else oi_strict_usd=.;
    if n(ni_usd,xint_usd,idit_usd,recta_usd,recta_l1_usd,mtr)=6
       then oi_usd=ni_usd+(xint_usd-idit_usd)*(1-mtr)+recta_usd-recta_l1_usd;
    else oi_usd=.;

    if not missing(oi_usd) and not missing(avg_noa_usd) and avg_noa_usd ne 0
       then rnoa=oi_usd/avg_noa_usd;
    else rnoa=.;
    if not missing(sale_usd) and not missing(avg_noa_usd) and avg_noa_usd ne 0
       then ato=sale_usd/avg_noa_usd;
    else ato=.;
    if not missing(oi_usd) and not missing(sale_usd) and sale_usd ne 0
       then pm=oi_usd/sale_usd;
    else pm=.;
    if not missing(noa_usd) and not missing(noa_l1_usd) and noa_l1_usd ne 0
       then grnoa=noa_usd/noa_l1_usd-1;
    else grnoa=.;
    if not missing(oi_strict_usd) and not missing(avg_noa_strict_usd)
       and avg_noa_strict_usd ne 0 then rnoa_strict=oi_strict_usd/avg_noa_strict_usd;
    else rnoa_strict=.;
    if not missing(sale_usd) and not missing(avg_noa_strict_usd)
       and avg_noa_strict_usd ne 0 then ato_strict=sale_usd/avg_noa_strict_usd;
    else ato_strict=.;
    if not missing(oi_strict_usd) and not missing(sale_usd) and sale_usd ne 0
       then pm_strict=oi_strict_usd/sale_usd;
    else pm_strict=.;
    if not missing(noa_strict_usd) and not missing(noa_strict_l1_usd)
       and noa_strict_l1_usd ne 0 then grnoa_strict=noa_strict_usd/noa_strict_l1_usd-1;
    else grnoa_strict=.;
    if not missing(sale_usd) and not missing(sale_l1_usd) and sale_l1_usd ne 0
       then sales_growth=sale_usd/sale_l1_usd-1;
    else sales_growth=.;
    if not missing(dvc_usd) and not missing(ni_usd) and ni_usd ne 0
       then div_payout=dvc_usd/ni_usd;
    else div_payout=.;
    if not missing(capx_usd) and not missing(mve_usd) and mve_usd>0
       then capex_mve=capx_usd/mve_usd;
    else capex_mve=.;

    label mtr="Marginal tax rate including 2% state approximation"
          cni_usd="Comprehensive net income, USD millions"
          nfe_usd="Net financial expense, USD millions"
          oi_strict_usd="Strict Appendix A intermediate-based OI, USD millions"
          oi_usd="Operating income, USD millions"
          avg_noa_usd="Arithmetic mean of current and lagged NOA, USD millions"
          avg_noa_strict_usd="Strict intermediate-based average NOA, USD millions"
          rnoa="Return on net operating assets"
          ato="Asset turnover"
          pm="Profit margin"
          grnoa="Growth in net operating assets"
          rnoa_strict="Strict intermediate-based RNOA"
          ato_strict="Strict intermediate-based asset turnover"
          pm_strict="Strict intermediate-based profit margin"
          grnoa_strict="Strict intermediate-based growth in NOA"
          sales_growth="Annual sales growth"
          div_payout="Common dividends divided by net income"
          capex_mve="Capital expenditures divided by market value of equity";
run;

/* Algebraic checks use ordinary construct aggregates.  The strict versions
   above require every original Appendix A intermediate input; the reduced
   versions require exactly the uncancelled inputs.  Any complete-case
   mismatch stops the build. */
proc sql;
    create table algebraic_construct_audit as
    select sum(not missing(noa_strict_usd) and not missing(noa_usd)) as n_noa_complete,
           sum(not missing(noa_strict_usd) and not missing(noa_usd)
               and abs(noa_strict_usd-noa_usd)>1e-8) as n_noa_different,
           max(abs(noa_strict_usd-noa_usd)) as max_noa_absolute_difference,
           sum(missing(noa_strict_usd) and not missing(noa_usd)) as n_noa_recovered,
           sum(fyear between 1989 and 2005 and missing(noa_strict_usd)
               and not missing(noa_usd)) as n_noa_recovered_1989_2005,
           sum(not missing(oi_strict_usd) and not missing(oi_usd)) as n_oi_complete,
           sum(not missing(oi_strict_usd) and not missing(oi_usd)
               and abs(oi_strict_usd-oi_usd)>1e-8) as n_oi_different,
           max(abs(oi_strict_usd-oi_usd)) as max_oi_absolute_difference,
           sum(missing(oi_strict_usd) and not missing(oi_usd)) as n_oi_recovered,
           sum(fyear between 1989 and 2005 and missing(oi_strict_usd)
               and not missing(oi_usd)) as n_oi_recovered_1989_2005
    from annual_metrics;
quit;
data _null_;
    set algebraic_construct_audit;
    put "AUDIT REDUCED_NOA_OI_EQUALITY " n_noa_complete= n_noa_different=
        max_noa_absolute_difference= n_oi_complete= n_oi_different=
        max_oi_absolute_difference=;
    put "AUDIT CANCELLED_INPUT_CONSTRUCT_RECOVERY " n_noa_recovered=
        n_noa_recovered_1989_2005= n_oi_recovered= n_oi_recovered_1989_2005=;
    if n_noa_different>0 or n_oi_different>0 then do;
        put "ERROR: Reduced Appendix A constructs differ on strict complete cases.";
        abort cancel;
    end;
run;

/* Table 5 uses current profitability changes, future change in RNOA, and the
   A&R trailing t..t-4 medians. The annual t-4 sales-growth observation itself
   uses t-5 sales, so the raw panel began in 1984. */
proc sql;
    create table model0 as
    select a.*,
           l1.curcd as curcd_l1,
           l2.curcd as curcd_l2,
           l3.curcd as curcd_l3,
           l4.curcd as curcd_l4,
           f1.curcd as curcd_f1,
           f1.curcd_up as curcd_up_f1,
           f1.datadate as datadate_f1,
           f1.fx_daily_date as fx_daily_date_f1,
           f1.fx_12m_date as fx_12m_date_f1,
           f1.fx_bs_usd as fx_bs_usd_f1,
           f1.fx_flow_usd as fx_flow_usd_f1,
           l1.rnoa as rnoa_l1, l1.ato as ato_l1, l1.pm as pm_l1,
           f1.rnoa as rnoa_f1,
           l1.rnoa_strict as rnoa_strict_l1,
           l1.ato_strict as ato_strict_l1,
           l1.pm_strict as pm_strict_l1,
           l1.grnoa_strict as grnoa_strict_l1,
           f1.rnoa_strict as rnoa_strict_f1,
           l1.div_payout as divpay_l1, l2.div_payout as divpay_l2,
           l3.div_payout as divpay_l3, l4.div_payout as divpay_l4,
           l1.sales_growth as salesgr_l1, l2.sales_growth as salesgr_l2,
           l3.sales_growth as salesgr_l3, l4.sales_growth as salesgr_l4,
           l1.capex_mve as capexmve_l1, l2.capex_mve as capexmve_l2,
           l3.capex_mve as capexmve_l3, l4.capex_mve as capexmve_l4
    from annual_metrics as a
    left join annual_metrics as l1
      on a.gvkey=l1.gvkey and a.fyear=l1.fyear+1
    left join annual_metrics as l2
      on a.gvkey=l2.gvkey and a.fyear=l2.fyear+2
    left join annual_metrics as l3
      on a.gvkey=l3.gvkey and a.fyear=l3.fyear+3
    left join annual_metrics as l4
      on a.gvkey=l4.gvkey and a.fyear=l4.fyear+4
    left join annual_metrics as f1
      on a.gvkey=f1.gvkey and a.fyear+1=f1.fyear
    where a.fyear between 1989 and 2005;

    create table model_linked as
    select a.*, l.shrcd, l.exchcd,
           l.linkprim, l.linktype, l.usedflag, l.n_valid_links
    from model0 as a
    inner join link_best as l
      on a.gvkey=l.gvkey and a.fyear=l.fyear and a.datadate=l.datadate
    ;
quit;

data model_base;
    set model_linked;
    if not missing(first_crsp_date) and first_crsp_date<=datadate then do;
        age_years=year(datadate)-year(first_crsp_date)+1;
        if age_years>0 then log_age=log(age_years);
    end;
    else do; age_years=.; log_age=.; end;

    /* The source says signs only, but does not define zero. Zero is assigned
       to the nonpositive side; missing cash-flow items remain unclassified. */
    if missing(oancf_usd) or missing(ivncf_usd) or missing(fincf_usd) then cf_stage=.;
    else do;
        op_positive=(oancf_usd>0);
        inv_positive=(ivncf_usd>0);
        fin_positive=(fincf_usd>0);
        if op_positive=0 and inv_positive=0 and fin_positive=1 then cf_stage=1;
        else if op_positive=1 and inv_positive=0 and fin_positive=1 then cf_stage=2;
        else if op_positive=1 and inv_positive=0 and fin_positive=0 then cf_stage=3;
        else if op_positive=0 and inv_positive=1 then cf_stage=5;
        else cf_stage=4;
    end;

    drnoa_f=rnoa_f1-rnoa;
    drnoa_t=rnoa-rnoa_l1;
    dato_t=ato-ato_l1;
    dpm_t=pm-pm_l1;
    drnoa_f_strict=rnoa_strict_f1-rnoa_strict;
    drnoa_t_strict=rnoa_strict-rnoa_strict_l1;
    dato_t_strict=ato_strict-ato_strict_l1;
    dpm_t_strict=pm_strict-pm_strict_l1;

    label age_years="Years since first CRSP monthly record, inclusive"
          log_age="Log CRSP age"
          cf_stage="Cash-flow-pattern stage: 1 intro, 2 growth, 3 mature, 4 shake-out, 5 decline"
          drnoa_f="One-year-ahead change in RNOA"
          drnoa_t="Current change in RNOA"
          dato_t="Current change in asset turnover"
          dpm_t="Current change in profit margin";
run;

/* Apply the paper's dated NYSE/AMEX/NASDAQ ordinary-common and ADR screens,
   nonfinancial SIC screen, and $1m denominator screens.  The table's sample
   is a firm-year; three separate eligibility flags retain proxy-specific
   missingness instead of forcing a common complete-case regression sample. */
data sample_screen;
    set model_base;
    if missing(sich) then pass_nonfinancial=0;
    else if sich>=6000 and sich<=6999 then pass_nonfinancial=0;
    else pass_nonfinancial=1;

    if not missing(avg_noa_usd) and avg_noa_usd>=1
       and not missing(sale_usd) and sale_usd>=1
       and not missing(ceq_usd) and abs(ceq_usd)>=1
       and not missing(mve_usd) and mve_usd>=1 then pass_size=1;
    else pass_size=0;
    if not missing(avg_noa_strict_usd) and avg_noa_strict_usd>=1
       and not missing(sale_usd) and sale_usd>=1
       and not missing(ceq_usd) and abs(ceq_usd)>=1
       and not missing(mve_usd) and mve_usd>=1 then pass_size_strict=1;
    else pass_size_strict=0;

run;

proc sql noprint;
    select sum(pass_nonfinancial and pass_size) into :screen_rows trimmed from sample_screen;
    select sum(pass_nonfinancial and pass_size_strict)
        into :screen_strict_rows trimmed from sample_screen;
    select sum(pass_nonfinancial and pass_size and not pass_size_strict)
        into :screen_recovered_cancel trimmed from sample_screen;
    select sum(pass_nonfinancial=0) into :financial_or_unknown trimmed from sample_screen;
    select sum(pass_size=0) into :size_screen_failures trimmed from sample_screen
    where pass_nonfinancial=1;
quit;
%put NOTE: Rows after date-valid exchange/share, industry, and $1m screens = &screen_rows.;
%put NOTE: Same-screen count under original strict NOA input requirements = &screen_strict_rows.;
%put NOTE: Current-screen rows recovered through cancelled NOA inputs = &screen_recovered_cancel.;
%put NOTE: Financial or unknown historical SIC exclusions = &financial_or_unknown.;
%put NOTE: Additional denominator/size exclusions = &size_screen_failures.;

data sample_pass;
    set sample_screen;
    if pass_nonfinancial and pass_size;
run;

/* Trailing A&R medians require the complete five annual values t..t-4. */
data ar_inputs;
    set sample_pass;
    if n(div_payout,divpay_l1,divpay_l2,divpay_l3,divpay_l4)=5
       then ar_div_med=median(of div_payout divpay_l1 divpay_l2 divpay_l3 divpay_l4);
    else ar_div_med=.;
    if n(sales_growth,salesgr_l1,salesgr_l2,salesgr_l3,salesgr_l4)=5
       then ar_salesgr_med=median(of sales_growth salesgr_l1 salesgr_l2 salesgr_l3 salesgr_l4);
    else ar_salesgr_med=.;
    if n(capex_mve,capexmve_l1,capexmve_l2,capexmve_l3,capexmve_l4)=5
       then ar_capex_med=median(of capex_mve capexmve_l1 capexmve_l2 capexmve_l3 capexmve_l4);
    else ar_capex_med=.;
    label ar_div_med="Median payout ratio, fiscal years t through t-4"
          ar_salesgr_med="Median sales growth, fiscal years t through t-4"
          ar_capex_med="Median capital expenditures/market equity, t through t-4";
run;

/* Rank within fiscal year. Ties are split deterministically by GVKEY so the
   requested terciles/quintiles are as even as possible; the paper does not
   specify a tie-breaking rule. */
%macro group_score(input=, value=, out=, score=, groups=, descending=0);
    data _rank_input;
        set &input;
        if not missing(&value);
    run;
    proc sql;
        create table _rank_counts as
        select fyear, count(*) as _n_rank
        from _rank_input
        group by fyear;
    quit;
    proc sort data=_rank_input;
        %if &descending=1 %then %do;
            by fyear descending &value gvkey;
        %end;
        %else %do;
            by fyear &value gvkey;
        %end;
    run;
    proc sort data=_rank_counts; by fyear; run;
    data &out;
        merge _rank_input(in=_in_rank) _rank_counts;
        by fyear;
        if _in_rank;
        if first.fyear then _seq=0;
        _seq+1;
        &score=floor((_seq-1)*&groups/_n_rank);
        keep gvkey fyear datadate &score;
    run;
%mend;

%group_score(input=ar_inputs,value=ar_div_med,out=div_scores,score=div_score,groups=3);
%group_score(input=ar_inputs,value=ar_salesgr_med,out=salesgr_scores,score=salesgr_rank,groups=3,descending=1);
%group_score(input=ar_inputs,value=ar_capex_med,out=capex_scores,score=capex_rank,groups=3,descending=1);
%group_score(input=ar_inputs,value=age_years,out=age_scores,score=age_score,groups=3);

proc sort data=ar_inputs; by gvkey fyear datadate; run;
proc sort data=div_scores; by gvkey fyear datadate; run;
proc sort data=salesgr_scores; by gvkey fyear datadate; run;
proc sort data=capex_scores; by gvkey fyear datadate; run;
proc sort data=age_scores; by gvkey fyear datadate; run;
data ar_score_inputs;
    merge ar_inputs(in=_base) div_scores salesgr_scores capex_scores age_scores;
    by gvkey fyear datadate;
    if _base;
    if n(div_score,salesgr_rank,capex_rank,age_score)=4 then do;
        div_score=div_score+1;                 /* low to high payout */
        salesgr_score=salesgr_rank+1;           /* high to low sales growth */
        capex_score=capex_rank+1;               /* high to low capital expenditures */
        age_score=age_score+1;                  /* young to old */
        ar_score=sum(div_score,salesgr_score,capex_score,age_score);
    end;
    else ar_score=.;
run;

%group_score(input=ar_score_inputs,value=ar_score,out=ar_portfolio_ranks,score=ar_q,groups=5);
%group_score(input=ar_score_inputs,value=age_years,out=age_portfolio_ranks,score=age_q,groups=5);
proc sort data=ar_score_inputs; by gvkey fyear datadate; run;
proc sort data=ar_portfolio_ranks; by gvkey fyear datadate; run;
data ar_portfolios;
    merge ar_score_inputs(in=_base) ar_portfolio_ranks;
    by gvkey fyear datadate;
    if _base;
run;
proc sort data=ar_portfolios; by gvkey fyear datadate; run;
proc sort data=age_portfolio_ranks; by gvkey fyear datadate; run;
data age_portfolios;
    merge ar_portfolios(in=_base) age_portfolio_ranks;
    by gvkey fyear datadate;
    if _base;
run;

/* Require the regression outcome and all five profitability controls, while
   keeping proxy-specific sample flags separate. */
data model_eligible;
    set age_portfolios;
    eligible_cont=(n(drnoa_f,rnoa,drnoa_t,grnoa,dato_t,dpm_t)=6);
    eligible_cf=(eligible_cont and not missing(cf_stage));
    eligible_ar=(eligible_cont and not missing(ar_q));
    eligible_age=(eligible_cont and not missing(age_q));
    eligible_cont_strict=(n(drnoa_f_strict,rnoa_strict,drnoa_t_strict,
                             grnoa_strict,dato_t_strict,dpm_t_strict)=6
                          and pass_size_strict);
    eligible_cf_strict=(eligible_cont_strict and not missing(cf_stage));
    eligible_ar_strict=(eligible_cont_strict and not missing(ar_q));
    eligible_age_strict=(eligible_cont_strict and not missing(age_q));
    eligible_cf_recovered=(eligible_cf and not eligible_cf_strict);
    eligible_ar_recovered=(eligible_ar and not eligible_ar_strict);
    eligible_age_recovered=(eligible_age and not eligible_age_strict);
    if not missing(ar_q) then ar_stage=ar_q+1; else ar_stage=.;
    if not missing(age_q) then age_stage=age_q+1; else age_stage=.;
    if not missing(curcd) and not missing(curcd_l1) then currency_change_lag=(curcd ne curcd_l1);
    else currency_change_lag=.;
    if not missing(curcd) and not missing(curcd_f1) then currency_change_forward=(curcd ne curcd_f1);
    else currency_change_forward=.;
    if not missing(curcd) and not missing(curcd_l1) and not missing(curcd_l2)
       and not missing(curcd_l3) and not missing(curcd_l4) then
        currency_change_ar=(curcd ne curcd_l1 or curcd_l1 ne curcd_l2
                            or curcd_l2 ne curcd_l3 or curcd_l3 ne curcd_l4);
    else currency_change_ar=.;
    label ar_score="Four-input Anthony-Ramesh composite score, range 4-12 by construction"
          ar_stage="Anthony-Ramesh stage: 1 growth, 2 growth/mature, 3 mature, 4 mature/stagnant, 5 stagnant"
          age_stage="Age stage: 1 young, 2 mid-young, 3 middle, 4 mid-old, 5 old"
          eligible_cont="Complete future-change and profitability-control sample"
          eligible_cf="CF-pattern Model 1 eligible"
          eligible_ar="Anthony-Ramesh Model 1 eligible"
          eligible_age="Age-quintile Model 1 eligible"
          eligible_cont_strict="Complete sample under original strict Appendix A inputs and NOA screen"
          eligible_cf_strict="CF-pattern eligible under original strict inputs"
          eligible_ar_strict="Anthony-Ramesh eligible under original strict inputs"
          eligible_age_strict="Age-quintile eligible under original strict inputs"
          eligible_cf_recovered="CF-pattern eligibility recovered through cancelled Appendix A inputs"
          eligible_ar_recovered="Anthony-Ramesh eligibility recovered through cancelled Appendix A inputs"
          eligible_age_recovered="Age-quintile eligibility recovered through cancelled Appendix A inputs";
run;

/* Audit the observations where FY2006 is actually used as the FY2005
   one-year-ahead RNOA lead, after the current-year listing and size screens. */
proc sql;
    create table fy2005_lead_fx_audit as
    select curcd_up_f1 as lead_currency length=3,
           count(*) as n_screened_fy2005_rows,
           sum(not missing(datadate_f1)) as n_matched_fy2006_leads,
           sum(not missing(datadate_f1) and curcd_up_f1 ne 'USD')
               as n_nonusd_fy2006_leads,
           min(datadate_f1) as first_lead_datadate format=yymmdd10.,
           max(datadate_f1) as last_lead_datadate format=yymmdd10.,
           sum(not missing(datadate_f1) and curcd_up_f1 ne 'USD'
               and missing(fx_bs_usd_f1)) as n_daily_fx_missing,
           sum(not missing(datadate_f1) and curcd_up_f1 ne 'USD'
               and missing(fx_flow_usd_f1)) as n_12m_fx_missing,
           sum(not missing(datadate_f1) and curcd_up_f1 ne 'USD'
               and fx_daily_date_f1=datadate_f1) as n_daily_exact,
           sum(not missing(datadate_f1) and curcd_up_f1 ne 'USD'
               and not missing(fx_daily_date_f1)
               and fx_daily_date_f1<datadate_f1) as n_daily_prior,
           max(datadate_f1-fx_daily_date_f1) as max_daily_age_days,
           sum(not missing(datadate_f1) and curcd_up_f1 ne 'USD'
               and fx_12m_date_f1=datadate_f1) as n_12m_exact,
           sum(not missing(datadate_f1) and curcd_up_f1 ne 'USD'
               and not missing(fx_12m_date_f1)
               and fx_12m_date_f1<datadate_f1) as n_12m_prior,
           max(datadate_f1-fx_12m_date_f1) as max_12m_age_days,
           sum(not missing(datadate_f1) and datadate_f1>'31DEC2006'd)
               as n_post2006_leads,
           sum(not missing(datadate_f1) and datadate_f1>'31DEC2006'd
               and curcd_up_f1 ne 'USD' and missing(fx_bs_usd_f1))
               as n_post2006_daily_missing,
           sum(not missing(datadate_f1) and datadate_f1>'31DEC2006'd
               and curcd_up_f1 ne 'USD' and missing(fx_flow_usd_f1))
               as n_post2006_12m_missing,
           sum(not missing(datadate_f1) and datadate_f1>'31DEC2006'd
               and curcd_up_f1 ne 'USD'
               and fx_daily_date_f1=datadate_f1) as n_post2006_daily_exact,
           sum(not missing(datadate_f1) and datadate_f1>'31DEC2006'd
               and curcd_up_f1 ne 'USD'
               and not missing(fx_daily_date_f1)
               and fx_daily_date_f1<datadate_f1) as n_post2006_daily_prior,
           sum(not missing(datadate_f1) and datadate_f1>'31DEC2006'd
               and curcd_up_f1 ne 'USD'
               and fx_12m_date_f1=datadate_f1) as n_post2006_12m_exact,
           sum(not missing(datadate_f1) and datadate_f1>'31DEC2006'd
               and curcd_up_f1 ne 'USD'
               and not missing(fx_12m_date_f1)
               and fx_12m_date_f1<datadate_f1) as n_post2006_12m_prior,
           sum(not missing(datadate_f1) and datadate_f1>'31DEC2006'd
               and not missing(drnoa_f)) as n_post2006_outcome_available,
           sum(not missing(datadate_f1) and datadate_f1>'31DEC2006'd
               and missing(drnoa_f)) as n_post2006_outcome_missing,
           sum(not missing(datadate_f1) and datadate_f1>'31DEC2006'd
               and eligible_cf) as n_post2006_cf_eligible,
           sum(not missing(datadate_f1) and datadate_f1>'31DEC2006'd
               and eligible_ar) as n_post2006_ar_eligible,
           sum(not missing(datadate_f1) and datadate_f1>'31DEC2006'd
               and eligible_age) as n_post2006_age_eligible,
           sum(missing(rnoa_f1)) as n_lead_rnoa_missing,
           sum(not missing(rnoa_f1)) as n_lead_rnoa_available,
           sum(eligible_cf) as n_cf_eligible,
           sum(eligible_ar) as n_ar_eligible,
           sum(eligible_age) as n_age_eligible
    from model_eligible
    where fyear=2005
    group by curcd_up_f1;
quit;
data _null_;
    set fy2005_lead_fx_audit;
    put "AUDIT FY2005_REQUIRED_LEADS " lead_currency= n_screened_fy2005_rows=
        n_matched_fy2006_leads= n_nonusd_fy2006_leads= first_lead_datadate=
        last_lead_datadate= n_daily_fx_missing= n_12m_fx_missing=
        n_daily_exact= n_daily_prior= max_daily_age_days= n_12m_exact=
        n_12m_prior= max_12m_age_days= n_post2006_leads=
        n_post2006_daily_missing= n_post2006_12m_missing=
        n_post2006_daily_exact= n_post2006_daily_prior=
        n_post2006_12m_exact= n_post2006_12m_prior=
        n_post2006_outcome_available= n_post2006_outcome_missing=
        n_post2006_cf_eligible= n_post2006_ar_eligible=
        n_post2006_age_eligible= n_lead_rnoa_missing=
        n_lead_rnoa_available= n_cf_eligible= n_ar_eligible= n_age_eligible=;
run;

proc sql noprint;
    select count(*) into :base_n trimmed from model_eligible;
    select sum(eligible_cont) into :continuous_n trimmed from model_eligible;
    select sum(eligible_cf) into :cf_n trimmed from model_eligible;
    select sum(eligible_ar) into :ar_n trimmed from model_eligible;
    select sum(eligible_age) into :age_n trimmed from model_eligible;
    select sum(eligible_cf_strict) into :cf_strict_n trimmed from model_eligible;
    select sum(eligible_ar_strict) into :ar_strict_n trimmed from model_eligible;
    select sum(eligible_age_strict) into :age_strict_n trimmed from model_eligible;
    select sum(eligible_cf_recovered) into :cf_recovered_n trimmed from model_eligible;
    select sum(eligible_ar_recovered) into :ar_recovered_n trimmed from model_eligible;
    select sum(eligible_age_recovered) into :age_recovered_n trimmed from model_eligible;
    select sum(missing(ar_q)) into :ar_missing trimmed from model_eligible;
    select sum(missing(age_q)) into :age_missing trimmed from model_eligible;
    select sum(missing(idit)) into :idit_missing_screen trimmed from model_eligible;
    select sum(missing(idit) and missing(oi_usd)) into :idit_missing_oi trimmed from model_eligible;
    select sum(missing(idit)
               and n(xint_usd,dvp_usd,ni_usd,msa_usd,msa_l1_usd,
                     recta_usd,recta_l1_usd)=7
               and not missing(mtr)) into :idit_only_oi_input_gap trimmed
    from model_eligible;
    select sum(missing(dvp)) into :dvp_missing_screen trimmed from model_eligible;
    select sum(missing(xint)) into :xint_missing_screen trimmed from model_eligible;
    select sum(missing(ni)) into :ni_missing_screen trimmed from model_eligible;
    select sum(missing(msa) or missing(recta)) into :msa_recta_missing_screen trimmed from model_eligible;
    select sum(missing(mve_usd)) into :mve_missing_screen trimmed from model_eligible;
    select sum(eligible_cont and currency_change_lag=1) into :currency_lag_changes trimmed from model_eligible;
    select sum(eligible_cont and currency_change_forward=1) into :currency_forward_changes trimmed from model_eligible;
    select sum(eligible_ar and currency_change_ar=1) into :currency_ar_changes trimmed from model_eligible;
quit;
%put NOTE: Final screened firm-years = &base_n.;
%put NOTE: Complete continuous-variable sample before proxy-specific missingness = &continuous_n.;
%put NOTE: Table 5 proxy eligible counts: CF=&cf_n. AR=&ar_n. AGE=&age_n.;
%put NOTE: Same-scope strict-input proxy counts before algebraic repair: CF=&cf_strict_n. AR=&ar_strict_n. AGE=&age_strict_n.;
%put NOTE: Model eligibility recovered through cancelled inputs: CF=&cf_recovered_n. AR=&ar_recovered_n. AGE=&age_recovered_n.;
%put NOTE: Missing Anthony-Ramesh portfolios=&ar_missing. and age quintiles=&age_missing.;
%put NOTE: Missing raw IDIT rows in screened sample=&idit_missing_screen.;
%put NOTE: Missing IDIT rows among screened observations with missing OI=&idit_missing_oi.;
%put NOTE: Screened firm-years where IDIT is the only missing current OI input=&idit_only_oi_input_gap.;
%put NOTE: Other formula-input missing counts (DVP, XINT, NI, MSA/RECTA, USD market equity)=&dvp_missing_screen. / &xint_missing_screen. / &ni_missing_screen. / &msa_recta_missing_screen. / &mve_missing_screen.;
%put NOTE: Complete Model 1 rows with CURCD different at t and t-1=&currency_lag_changes.;
%put NOTE: Complete Model 1 rows with CURCD different at t and t+1=&currency_forward_changes.;
%put NOTE: Anthony-Ramesh-complete rows with any CURCD change across t-4 through t=&currency_ar_changes.;

proc sql;
    create table final_sample_audit as
    select curcd_up, count(*) as n_screened,
           sum(eligible_cont) as n_continuous,
           sum(eligible_cf) as n_cf,
           sum(eligible_ar) as n_ar,
           sum(eligible_age) as n_age,
           sum(eligible_cf_strict) as n_cf_strict,
           sum(eligible_ar_strict) as n_ar_strict,
           sum(eligible_age_strict) as n_age_strict,
           sum(eligible_cf_recovered) as n_cf_recovered,
           sum(eligible_ar_recovered) as n_ar_recovered,
           sum(eligible_age_recovered) as n_age_recovered,
           sum(missing(fx_bs_usd)) as n_bs_fx_missing,
           sum(missing(fx_flow_usd)) as n_flow_fx_missing,
           sum(missing(idit)) as n_idit_missing,
           sum(missing(mve_usd)) as n_crsp_mve_missing,
           sum(n_crsp_other_gvkey_classes>0) as n_market_value_gvkey_conflicts,
           sum(n_crsp_multi_gvkey_classes>0) as n_mve_multi_gvkey
    from model_eligible
    group by curcd_up;
quit;
data _null_;
    set final_sample_audit;
    put "AUDIT FINAL_SAMPLE_CURRENCY " curcd_up= n_screened= n_continuous=
        n_cf= n_ar= n_age= n_cf_strict= n_ar_strict= n_age_strict=
        n_cf_recovered= n_ar_recovered= n_age_recovered=
        n_bs_fx_missing= n_flow_fx_missing=
        n_idit_missing= n_crsp_mve_missing= n_market_value_gvkey_conflicts=
        n_mve_multi_gvkey=;
run;

/* The source does not specify the percentile pool. Use pooled 1st/99th
   cutoffs over continuous-complete screened firm-years; indicators are not
   winsorized. */
proc univariate data=model_eligible(where=(eligible_cont=1)) noprint;
    var drnoa_f rnoa drnoa_t grnoa dato_t dpm_t;
    output out=pooled_cutoffs pctlpts=1 99
        pctlpre=drnoaf_ rnoat_ drnoat_ grnoat_ datot_ dpmt_
        pctlname=p1 p99;
run;
proc print data=pooled_cutoffs noobs;
    title "Pooled 1st and 99th percentile cutoffs for Table 5 continuous variables";
run;

data out.reg;
    if _n_=1 then set pooled_cutoffs;
    set model_eligible;
    if eligible_cont then do;
        drnoa_w=max(drnoaf_p1,min(drnoa_f,drnoaf_p99));
        rnoa_w=max(rnoat_p1,min(rnoa,rnoat_p99));
        drnoa_t_w=max(drnoat_p1,min(drnoa_t,drnoat_p99));
        grnoa_w=max(grnoat_p1,min(grnoa,grnoat_p99));
        dato_w=max(datot_p1,min(dato_t,datot_p99));
        dpm_w=max(dpmt_p1,min(dpm_t,dpmt_p99));
    end;
    label drnoa_w="Future change in RNOA, winsorized"
          rnoa_w="Current RNOA, winsorized"
          drnoa_t_w="Current change in RNOA, winsorized"
          grnoa_w="Growth in NOA, winsorized"
          dato_w="Current change in ATO, winsorized"
          dpm_w="Current change in PM, winsorized";
    keep gvkey fyear datadate permno permco exchcd shrcd linkprim linktype usedflag
            curcd curcd_up curcd_l1 curcd_l2 curcd_l3 curcd_l4 curcd_f1
            fx_daily_date fx_usd_daily_date gbp_to_reported_daily
            gbp_to_usd_daily reported_rate_type usd_rate_type
            fx_daily_match_status
         currency_change_lag currency_change_forward currency_change_ar
         fx_bs_usd fx_flow_usd sich fic age_years log_age first_crsp_date
         market_date mve_usd mve_crsp_usd mve_compustat_raw mve_compustat_usd
         compustat_crsp_mve_ratio n_crsp_common_classes n_crsp_unpriced_classes
         n_crsp_same_gvkey_classes n_crsp_other_gvkey_classes
         n_crsp_multi_gvkey_classes n_crsp_other_gvkey_mappings
         n_crsp_jn_classes n_crsp_same_gvkey_jn_classes
         n_crsp_other_gvkey_jn_classes n_crsp_ls_classes
         n_crsp_other_gvkey_ls_classes n_crsp_unlinked_classes
         oancf_usd ivncf_usd fincf_usd cf_stage ar_score ar_q ar_stage age_q age_stage
         noa_usd avg_noa_usd sale_usd ceq_usd mve_usd oi_usd cni_usd nfe_usd
         noa_strict_usd avg_noa_strict_usd oi_strict_usd
         rnoa ato pm grnoa drnoa_t drnoa_f dato_t dpm_t
         ar_div_med ar_salesgr_med ar_capex_med
         eligible_cont eligible_cf eligible_ar eligible_age
         eligible_cont_strict eligible_cf_strict eligible_ar_strict eligible_age_strict
         eligible_cf_recovered eligible_ar_recovered eligible_age_recovered
         drnoa_w rnoa_w drnoa_t_w grnoa_w dato_w dpm_w;
run;

proc freq data=out.reg;
    tables cf_stage ar_q age_q eligible_cf eligible_ar eligible_age / missing;
    title "Final stage assignments and proxy-specific eligibility";
run;
proc means data=out.reg n mean std min max maxdec=4;
    where eligible_cf=1;
    var drnoa_w rnoa_w drnoa_t_w grnoa_w dato_w dpm_w;
    title "CF Pattern Model 1 actual analysis-sample descriptives";
run;
proc means data=out.reg n mean std min max maxdec=4;
    where eligible_ar=1;
    var drnoa_w rnoa_w drnoa_t_w grnoa_w dato_w dpm_w;
    title "Anthony-Ramesh Model 1 actual analysis-sample descriptives";
run;
proc means data=out.reg n mean std min max maxdec=4;
    where eligible_age=1;
    var drnoa_w rnoa_w drnoa_t_w grnoa_w dato_w dpm_w;
    title "Age-quintile Model 1 actual analysis-sample descriptives";
run;

proc sql noprint;
    select count(*) into :export_n trimmed from out.reg;
quit;
%put NOTE: Exported SAS sample data/reg.sas7bdat contains &export_n. screened firm-years before model-specific complete-case flags.;
