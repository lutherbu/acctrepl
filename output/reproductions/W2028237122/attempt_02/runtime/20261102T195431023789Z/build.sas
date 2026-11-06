options errorabend mprint msglevel=i;
libname ibes '/storage/sas/base/ibes' access=readonly;
libname crsp '/storage/sas/base/crsp/a_stock' access=readonly;
libname out 'data';
libname aud 'scratch';

title 'W2028237122: quarterly threshold time trends';

/* Retain the full t-4 actual history before restricting the trend sample. */
data work.actraw;
    set ibes.actu_epsus(keep=ticker cusip pends measure pdicity anndats anntims actdats acttims value curr_act usfirm
        where=(pends >= '01JAN1984'd and pends < '01JAN2003'd));
run;

title 'IBES actual field and code audit';
proc freq data=work.actraw;
    tables measure pdicity usfirm curr_act / missing;
run;

data work.actusd;
    set work.actraw;
    if measure ne 'EPS' or pdicity ne 'QTR' or usfirm ne 1 or curr_act ne 'USD' then delete;
run;

proc sql;
    create table work.actdatecheck as
    select year(pends) as period_year,
           count(*) as n_actual_rows,
           sum(missing(anndats)) as n_missing_announce_date,
           sum(missing(actdats)) as n_missing_activation_date,
           sum(not missing(anndats) and not missing(actdats) and anndats ne actdats)
               as n_act_anndate_diff,
           min(anndats) as first_announce_date format=date9.,
           max(anndats) as last_announce_date format=date9.
    from work.actusd
    group by calculated period_year;
quit;
title 'Actual announcement and activation date coverage by fiscal-period year';
proc print data=work.actdatecheck noobs; run;

proc sql;
    create table work.actmiss as
    select count(*) as n_period_rows,
           sum(missing(value)) as n_missing_value,
           sum(value=0) as n_zero_value,
           sum(missing(anndats)) as n_missing_announce,
           sum(missing(cusip)) as n_missing_cusip
    from work.actusd;
    create table work.actdup as
    select ticker, pends, count(*) as nrows,
           count(distinct value) as nvalues,
           count(distinct anndats) as nann
    from work.actusd
    where not missing(value) and not missing(anndats) and not missing(cusip)
    group by ticker, pends
    having count(*) > 1;
    create table work.actdupsum as
    select count(*) as duplicate_ticker_periods,
           sum(nrows-1) as extra_rows,
           sum(nvalues>1) as periods_with_value_conflicts,
           sum(nann>1) as periods_event_date_conflicts
    from work.actdup;
quit;

title 'IBES actual rows and duplicate diagnostics';
proc print data=work.actmiss noobs; run;
proc print data=work.actdupsum noobs; run;

data work.actgood;
    set work.actusd;
    if missing(value) or missing(anndats) or missing(cusip) then delete;
run;
proc sort data=work.actgood;
    by ticker pends anndats actdats acttims;
run;
data work.actuni;
    set work.actgood;
    by ticker pends;
    if first.pends;
run;

data work.qcurr;
    set work.actuni;
    if year(pends) < 1985 or year(pends) > 2002 then delete;
    qyear=year(pends);
    qbegin=intnx('month',pends,-3,'end')+1;
    lagtarget=intnx('year',pends,-1,'same');
    rowid=_n_;
    format pends anndats actdats qbegin lagtarget date9.;
run;

/* Exact TICKER period matching is not assumed: use the closest t-4 period
   within one week of the same fiscal-quarter date, requiring a unique nearest row. */
proc sql;
    create table work.lagcand as
    select a.rowid, b.pends as lagpends, b.anndats as lagdate,
           b.value as lagraw, abs(b.pends-a.lagtarget) as daygap
    from work.qcurr as a inner join work.actuni as b
      on a.ticker=b.ticker
     and b.pends >= a.lagtarget-7
     and b.pends <= a.lagtarget+7;
    create table work.lagmind as
    select rowid, min(daygap) as minday
    from work.lagcand group by rowid;
    create table work.lagbest as
    select a.rowid, a.lagpends, a.lagdate, a.lagraw, a.daygap
    from work.lagcand as a inner join work.lagmind as b
      on a.rowid=b.rowid and a.daygap=b.minday;
    create table work.lagagg as
    select rowid, count(*) as nlagbest,
           max(lagpends) as lagpends,
           max(lagdate) as lagdate,
           max(lagraw) as lagraw,
           max(daygap) as laggap
    from work.lagbest group by rowid;
quit;

/* The historical CRSP name row is selected using its effective CUSIP date range. */
proc sql;
    create table work.linkraw as
    select a.rowid, b.permno, b.siccd, b.shrcd
    from work.qcurr as a left join crsp.dsenames as b
      on strip(a.cusip)=strip(b.ncusip)
     and b.namedt <= a.anndats
     and (missing(b.nameendt) or b.nameendt >= a.anndats);
    create table work.linkagg as
    select rowid, count(distinct permno) as nperm,
           count(distinct siccd) as nsic,
           min(permno) as permno,
           min(siccd) as siccd,
           min(shrcd) as shrcd
    from work.linkraw group by rowid;
    create table work.lagcheck as
    select count(*) as nbase,
           sum(missing(b.rowid)) as n_no_lag,
           sum(b.nlagbest=1) as n_unique_lag,
           sum(b.nlagbest>1) as n_ambiguous_lag
    from work.qcurr as a left join work.lagagg as b on a.rowid=b.rowid;
    create table work.linkcheck as
    select count(*) as nbase,
           sum(missing(b.nperm) or b.nperm=0) as n_no_permno_match,
           sum(b.nperm=1 and b.nsic=0) as n_missing_sic,
           sum(b.nperm=1 and b.nsic=1) as n_unique_effective_links,
           sum(b.nperm>1 or b.nsic>1) as n_ambiguous_effective_links
    from work.qcurr as a left join work.linkagg as b on a.rowid=b.rowid;
quit;

title 'Lag and effective-dated IBES–CRSP link diagnostics';
proc print data=work.lagcheck noobs; run;
proc print data=work.linkcheck noobs; run;
title 'Date gaps for unique t-4 actual matches';
proc freq data=work.lagagg;
    where nlagbest=1;
    tables laggap;
run;

/* Keep every candidate row for staged attrition; ambiguous matches stay missing. */
proc sql;
    create table work.core0 as
    select a.*, b.lagpends, b.lagdate, b.lagraw, b.nlagbest,
           c.permno, c.siccd, c.shrcd, c.nperm, c.nsic
    from work.qcurr as a
    left join work.lagagg as b on a.rowid=b.rowid
    left join work.linkagg as c on a.rowid=c.rowid;
quit;
data work.core;
    set work.core0;
    if nlagbest ne 1 then do; lagpends=.; lagdate=.; lagraw=.; end;
    if nperm ne 1 or nsic ne 1 then do; permno=.; siccd=.; end;
    format lagpends lagdate date9.;
run;

/* Validate the quarterly EPS detail mapping before screening forecast currencies. */
data work.fcraw;
    set ibes.detu_epsus(keep=ticker cusip fpedats fpi measure usfirm analys estimator
        anndats anntims actdats acttims revdats revtims value curr currfl report_curr
        where=(fpedats >= '01JAN1985'd and fpedats < '01JAN2003'd));
run;
title 'IBES detailed estimate field and currency audit';
proc freq data=work.fcraw;
    tables measure usfirm fpi curr*currfl*report_curr / missing;
run;
proc freq data=work.fcraw noprint;
    tables curr*currfl*report_curr / missing out=aud.forecast_currency;
run;
title 'Raw estimate-level and company-level currency cross-tab';
proc print data=aud.forecast_currency noobs; run;

data work.fcusd;
    set work.fcraw;
    if measure ne 'EPS' or usfirm ne 1 then delete;
    if fpi not in ('6','7','8','9','N','O','P','Q','R','S','T','L','Y') then delete;
    /* DETU values are split-unadjusted but already on the report-currency basis.
       CURR/CURRFL retain the estimate-level received-currency provenance. */
    if report_curr ne 'USD' then delete;
    if missing(value) or missing(anndats) or missing(analys) then delete;
run;

/* Latest public forecast date strictly before the actual announcement; same-day
   estimates are averaged after retaining one time-stamped row per analyst. */
proc sql;
    create table work.fccand as
    select a.rowid, f.ticker, f.fpedats, f.analys, f.estimator,
           f.fpi, f.anndats, f.anntims, f.actdats, f.acttims,
           f.revdats, f.revtims, f.value, f.curr, f.currfl, f.report_curr
    from work.core as a inner join work.fcusd as f
      on a.ticker=f.ticker and a.pends=f.fpedats
     and f.anndats < a.anndats;
    create table work.fccandcheck as
    select count(*) as forecast_candidates,
           count(distinct rowid) as firm_quarters_with_a_forecast,
           sum(missing(value)) as missing_candidate_values
    from work.fccand;
quit;

proc sort data=work.fccand;
    by rowid descending anndats descending anntims;
run;
data work.fdate;
    set work.fccand;
    by rowid;
    if first.rowid;
    fdate=anndats;
    keep rowid fdate;
    format fdate date9.;
run;
proc sql;
    create table work.fclatest0 as
    select a.*
    from work.fccand as a inner join work.fdate as b
      on a.rowid=b.rowid and a.anndats=b.fdate;
    create table work.fcdup as
    select rowid, analys, count(*) as nrows,
           count(distinct value) as nvalues,
           count(distinct anntims) as ntimes
    from work.fclatest0
    group by rowid, analys
    having count(*) > 1;
    create table work.fcdupsum as
    select count(*) as analyst_date_groups_with_repeats,
           sum(nrows-1) as extra_rows,
           sum(nvalues>1) as groups_with_value_conflicts,
           sum(ntimes>1) as groups_with_time_conflicts
    from work.fcdup;
quit;
proc sort data=work.fclatest0;
    by rowid analys descending anntims descending actdats descending acttims
       descending revdats descending revtims;
run;
data work.fcperanal;
    set work.fclatest0;
    by rowid analys;
    if first.analys;
run;
data aud.forecast_selected;
    set work.fcperanal;
run;
proc sql;
    create table work.fcast as
    select rowid, mean(value) as forecast,
           count(distinct analys) as analyst_n,
           max(anndats) as fdate
    from work.fcperanal group by rowid;
    create table work.fcsummary as
    select count(*) as n_final_forecast_rows,
           mean(analyst_n) as mean_analysts_on_selected_day,
           min(fdate) as earliest_selected_forecast,
           max(fdate) as latest_selected_forecast
    from work.fcast;
quit;
title 'Forecast date, duplicate, and selected-forecast diagnostics';
proc print data=work.fccandcheck noobs; run;
proc print data=work.fcdupsum noobs; run;
proc print data=work.fcsummary noobs; run;

/* CRSP market calendar for event dates; fiscal 2002 observations may announce in 2003. */
data work.cal;
    set crsp.dsi(keep=date vwretd where=(date >= '01JAN1983'd and date < '01JAN2004'd));
    if missing(vwretd) then delete;
run;
proc sort data=work.cal; by date; run;
data work.cal;
    set work.cal;
    tradeidx=_n_;
run;

proc sql;
    create table work.eventdate0 as
    select a.rowid, min(c.date) as evdate
    from work.core as a left join work.cal as c
      on c.date >= a.anndats and c.date <= a.anndats+7
    group by a.rowid;
    create table work.eventdate as
    select a.rowid, c.tradeidx as eidx, c.date as evtrade
    from work.eventdate0 as a left join work.cal as c on a.evdate=c.date;
    create table work.pdate0 as
    select a.rowid, min(d.date) as pdate
    from work.core as a left join crsp.dsf as d
      on a.permno=d.permno
     and d.date >= a.qbegin and d.date <= a.qbegin+10
     and abs(d.prc) > 0
    group by a.rowid;
    create table work.pdata as
    select a.rowid, a.pdate, abs(d.prc) as price,
           d.cfacshr as cfac_p
    from work.pdate0 as a inner join work.core as c on a.rowid=c.rowid
    left join crsp.dsf as d
      on c.permno=d.permno and a.pdate=d.date;
quit;

/* Resolve source share factors at the last security trading day on/before the
   actual, t-4 actual, and selected analyst forecast dates. */
data work.facreqa;
    set work.core;
    length role $1;
    if not missing(permno) and not missing(anndats) then do;
        role='A'; reqdate=anndats; output;
    end;
    if not missing(permno) and nlagbest=1 and not missing(lagdate) then do;
        role='L'; reqdate=lagdate; output;
    end;
    format reqdate date9.;
    keep rowid permno role reqdate;
run;
proc sql;
    create table work.facreqf as
    select a.rowid, a.permno, 'F' as role length=1,
           b.fdate as reqdate
    from work.core as a inner join work.fcast as b on a.rowid=b.rowid
    where not missing(a.permno) and not missing(b.fdate);
quit;
data work.facreq2;
    set work.facreqa work.facreqf;
    if missing(permno) then delete;
    format reqdate date9.;
run;

proc sql;
    create table work.facdate as
    select r.rowid, r.role, max(d.date) as fdate
    from work.facreq2 as r left join crsp.dsf as d
      on r.permno=d.permno
     and d.date <= r.reqdate and d.date >= r.reqdate-7
    group by r.rowid, r.role;
    create table work.factors0 as
    select a.rowid, a.role, a.fdate, d.cfacshr as cfac
    from work.facdate as a inner join work.core as c on a.rowid=c.rowid
    left join crsp.dsf as d
      on c.permno=d.permno and d.date=a.fdate;
    create table work.factors as
    select rowid,
           max(case when role='A' then cfac else . end) as cfac_a,
           max(case when role='L' then cfac else . end) as cfac_l,
           max(case when role='F' then cfac else . end) as cfac_f,
           max(case when role='A' then fdate else . end) as fdate_a,
           max(case when role='L' then fdate else . end) as fdate_l,
           max(case when role='F' then fdate else . end) as fdate_f
    from work.factors0 group by rowid;
quit;

/* Build the three-day market-adjusted CAR from trading days -1, 0, +1. */
proc sort data=work.core; by rowid; run;
proc sort data=work.eventdate; by rowid; run;
data work.evtreq;
    merge work.core(in=a keep=rowid permno) work.eventdate(in=b keep=rowid eidx);
    by rowid;
    if a and not missing(permno) and not missing(eidx) then do;
        offset=-1; wanted=eidx-1; output;
        offset=0; wanted=eidx; output;
        offset=1; wanted=eidx+1; output;
    end;
    keep rowid permno offset wanted;
run;
proc sql;
    create table work.evtdays0 as
    select a.rowid, a.permno, a.offset, b.date, b.vwretd
    from work.evtreq as a inner join work.cal as b on a.wanted=b.tradeidx;
    create table work.evtdays as
    select a.rowid, a.offset, a.date, a.vwretd, d.ret
    from work.evtdays0 as a left join crsp.dsf as d
      on a.permno=d.permno and a.date=d.date;
    create table work.car as
    select rowid, count(ret) as nret,
           sum(case when not missing(ret) and not missing(vwretd)
                    then ret-vwretd else . end) as car
    from work.evtdays group by rowid;
quit;

proc sql;
    create table work.base0 as
    select a.*, b.lagraw, b.lagdate, b.lagpends, b.laggap, b.nlagbest,
           c.permno, c.siccd, c.shrcd, c.nperm, c.nsic,
           p.pdate, p.price, p.cfac_p,
           e.eidx, e.evtrade,
           f.forecast, f.fdate, f.analyst_n,
           g.cfac_a, g.cfac_l, g.cfac_f,
           g.fdate_a, g.fdate_l, g.fdate_f,
           h.nret, h.car
    from work.qcurr as a
    left join work.lagagg as b on a.rowid=b.rowid
    left join work.linkagg as c on a.rowid=c.rowid
    left join work.pdata as p on a.rowid=p.rowid
    left join work.eventdate as e on a.rowid=e.rowid
    left join work.fcast as f on a.rowid=f.rowid
    left join work.factors as g on a.rowid=g.rowid
    left join work.car as h on a.rowid=h.rowid;
quit;

data work.base;
    set work.base0;
    if nlagbest ne 1 then lagraw=.;
    if nperm ne 1 or nsic ne 1 then do; permno=.; siccd=.; end;
    if not missing(cfac_p) and cfac_p>0 and not missing(cfac_a) and cfac_a>0 then
        eps_t= value * cfac_p / cfac_a;
    if not missing(cfac_p) and cfac_p>0 and not missing(cfac_l) and cfac_l>0 then
        eps_lag= lagraw * cfac_p / cfac_l;
    if not missing(cfac_p) and cfac_p>0 and not missing(cfac_f) and cfac_f>0 then
        eps_forecast= forecast * cfac_p / cfac_f;
    if not missing(price) and price>0 then do;
        loss=eps_t/price;
        earnchange=(eps_t-eps_lag)/price;
        surprise=(eps_t-eps_forecast)/price;
    end;
    if not missing(pdate) and not missing(qbegin) then price_age_days=pdate-qbegin;
    loss_ok=not missing(loss);
    change_ok=not missing(earnchange);
    surprise_ok=not missing(surprise);
    price_ok=not missing(price) and price>0 and not missing(cfac_p) and cfac_p>0;
    lag_ok=nlagbest=1 and not missing(lagraw);
    forecast_ok=not missing(forecast) and not missing(fdate) and not missing(cfac_f);
    link_ok=nperm=1 and nsic=1 and not missing(permno) and not missing(siccd);
    car_ok=nret=3 and not missing(car);
    industry_excluded=(siccd>=4400 and siccd<=5000) or (siccd>=6000 and siccd<=6500);
    format qbegin lagtarget pends anndats lagpends lagdate fdate pdate evtrade fdate_a fdate_l fdate_f date9.;
run;

/* Diagnostic only: do not screen observations on the elapsed price age. */
title 'First available CRSP price age from fiscal-quarter start, all current actuals';
proc freq data=work.base;
    tables price_age_days / missing;
run;
proc means data=work.base n nmiss mean p50 p90 p95 p99 max maxdec=2;
    var price_age_days;
run;

/* Staged construction and missing-versus-zero diagnostics. */
proc sql;
    create table work.attrition as
    select count(*) as n_current_actuals,
           sum(lag_ok) as n_with_t4_actual,
           sum(forecast_ok) as n_with_timely_forecast,
           sum(price_ok) as n_with_begin_price,
           sum(link_ok) as n_with_unique_link_sic,
           sum(car_ok) as n_with_complete_car,
           sum(loss_ok and change_ok and surprise_ok) as n_with_all_threshold_inputs,
           sum(not missing(value) and value=0) as n_zero_current_eps,
           sum(missing(value)) as n_missing_current_eps,
           sum(not missing(forecast) and forecast=0) as n_zero_forecast,
           sum(missing(forecast)) as n_missing_forecast,
           sum(missing(car)) as n_missing_car
    from work.base;
    create table work.sicstage as
    select count(*) as n_pre_sic,
           sum(missing(siccd)) as n_missing_sic,
           sum(industry_excluded) as n_sic_excluded
    from work.base;
quit;
title 'Full 1985–2002 firm-quarter construction attrition';
proc print data=work.attrition noobs; run;
proc print data=work.sicstage noobs; run;

data work.precar;
    set work.base;
    if not lag_ok or not forecast_ok or not price_ok or not link_ok or not car_ok then delete;
    if not loss_ok or not change_ok or not surprise_ok then delete;
    if industry_excluded then delete;
run;
proc univariate data=work.precar noprint;
    var car;
    output out=work.carpct pctlpts=1 99 pctlpre=carp_;
run;
data _null_;
    set work.carpct;
    call symputx('carp1',carp_1);
    call symputx('carp99',carp_99);
run;
data work.mainfq;
    set work.precar;
    if car < &carp1 or car > &carp99 then delete;
run;

title 'Final main firm-quarter sample and input distributions';
proc sql;
    select count(*) as final_firm_quarters,
           min(pends) as first_period_end format=date9.,
           max(pends) as last_period_end format=date9.,
           min(anndats) as first_announcement format=date9.,
           max(anndats) as last_announcement format=date9.,
           min(pdate) as first_price_date format=date9.,
           max(pdate) as last_price_date format=date9.
    from work.mainfq;
    select count(*) as main_rows_before_car_trim,
           sum(car < &carp1) as low_car_removed,
           sum(car > &carp99) as high_car_removed,
           &carp1 as car_p1, &carp99 as car_p99
    from work.precar;
quit;
proc means data=work.mainfq n nmiss mean std min p1 p50 p99 max maxdec=6;
    var price price_age_days eps_t eps_lag eps_forecast loss earnchange surprise car;
run;
proc freq data=work.mainfq;
    tables qyear price_age_days / missing;
run;

/* Preserve the constructed common firm-quarter sample under scratch for audit. */
data aud.main_firmquarter;
    set work.mainfq(keep=rowid ticker cusip permno pends qyear qbegin pdate
        anndats evtrade lagpends lagdate laggap fdate siccd price price_age_days cfac_p cfac_a cfac_l cfac_f
        value lagraw forecast eps_t eps_lag eps_forecast loss earnchange surprise car analyst_n);
run;

/* Common-sample threshold distributions; zero maps to bin 0, right of zero. */
data work.binned;
    set work.mainfq;
    loss_bin=floor(loss/0.0025);
    change_bin=floor(earnchange/0.0025);
    surprise_bin=floor(surprise/0.0025);
run;
proc sql;
    create table work.annual0 as
    select qyear as year, count(*) as n_firmquarter,
       sum(loss_bin=-2) as loss_m2,
       sum(loss_bin=-1) as loss_m1,
       sum(loss_bin=0) as loss_0,
       sum(change_bin=-2) as change_m2,
       sum(change_bin=-1) as change_m1,
       sum(change_bin=0) as change_0,
       sum(surprise_bin=-2) as surprise_m2,
       sum(surprise_bin=-1) as surprise_m1,
       sum(surprise_bin=0) as surprise_0
    from work.binned group by qyear;
quit;
data work.annual;
    set work.annual0;
    nstd=1000;
    pl2=loss_m2/n_firmquarter; pl1=loss_m1/n_firmquarter; p0=loss_0/n_firmquarter;
    loss_var=1000*pl1*(1-pl1)+250*(pl2+p0)*(1-pl2-p0);
    z_loss=(1000*pl1-500*(pl2+p0))/sqrt(loss_var);
    pl2=change_m2/n_firmquarter; pl1=change_m1/n_firmquarter; p0=change_0/n_firmquarter;
    change_var=1000*pl1*(1-pl1)+250*(pl2+p0)*(1-pl2-p0);
    z_decrease=(1000*pl1-500*(pl2+p0))/sqrt(change_var);
    pl2=surprise_m2/n_firmquarter; pl1=surprise_m1/n_firmquarter; p0=surprise_0/n_firmquarter;
    surprise_var=1000*pl1*(1-pl1)+250*(pl2+p0)*(1-pl2-p0);
    z_surprise=(1000*pl1-500*(pl2+p0))/sqrt(surprise_var);
    keep year n_firmquarter z_loss z_decrease z_surprise;
run;
proc sort data=work.annual; by year; run;
title 'Annual standardized differences for assigned trend fits';
proc means data=work.annual n nmiss mean std min max maxdec=6;
    var n_firmquarter z_loss z_decrease z_surprise;
run;
proc sql;
    select count(*) as annual_observations,
           min(year) as first_year, max(year) as last_year,
           sum(n_firmquarter) as total_firm_quarters
    from work.annual;
quit;

data out.main;
    set work.annual;
run;
