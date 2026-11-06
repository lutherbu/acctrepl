options errorabend msglevel=i mprint mlogic symbolgen;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname compfx "/storage/sas/base/comp/d_global/currency" access=readonly;
libname crsp "/storage/sas/base/crsp/a_stock" access=readonly;
libname ccm "/storage/sas/base/crsp/a_ccm" access=readonly;
libname out "data";

/* Read only the source years and fields needed for Eq. (1) and its controls. */
data work.comp_raw;
    set comp.funda(keep=gvkey datadate fyear fyr pddur indfmt datafmt consol
                        popsrc curcd sich xrd at sale ib dvc ceq txditc pstk
                        che ivao dlc dltt mib);
    if fyear < 1974 or fyear > 1999 then delete;
    if indfmt ne "INDL" or datafmt ne "STD" or consol ne "C" or popsrc ne "D" then delete;
    if missing(gvkey) or missing(datadate) or missing(fyear) then delete;
    xrd_use=xrd;
    xrd_missing=missing(xrd);
    if missing(xrd) then xrd_use=0;
    keep gvkey datadate fyear fyr pddur indfmt curcd sich xrd xrd_use xrd_missing
         at sale ib dvc ceq txditc pstk che ivao dlc dltt mib;
run;

proc sql;
    title "Compustat source coverage and XRD missingness";
    select count(*) as rows,
           count(distinct gvkey) as companies,
           min(fyear) as first_fyear,
           max(fyear) as last_fyear,
           sum(xrd_missing) as present_rows_with_missing_xrd
    from work.comp_raw;
    create table work.comp_dups as
    select gvkey, fyear, count(*) as row_count,
           count(distinct datadate) as distinct_report_dates
    from work.comp_raw
    group by gvkey, fyear
    having calculated row_count > 1;
    select count(*) as duplicate_gvkey_year_groups,
           sum(row_count) as rows_in_duplicate_groups,
           sum(distinct_report_dates > 1) as groups_with_multiple_dates
    from work.comp_dups;
quit;

/* Retain one annual statement per GVKEY/fiscal year. Prefer the full-year
   record, then the latest report date; duplicate counts above remain visible. */
data work.comp_sort0;
    set work.comp_raw;
    full_priority=(pddur=12);
run;

proc sort data=work.comp_sort0 out=work.comp_sort;
    by gvkey fyear descending full_priority descending datadate;
run;

data work.comp_one;
    set work.comp_sort;
    by gvkey fyear;
    if first.fyear;
run;

/* Translate annual flows with the provider's rolling 12-month rates and
   balance-sheet items with same-date daily rates. Xpressfeed's primary
   currency is GBP, so USD-per-reporting-unit is (GBP->USD)/(GBP->CURCD).
   Monthly rates begin in 1982; unsupported nonzero observations stay missing.
   Daily rates use the latest same-date pair no more than seven days before
   DATADATE, never a future quote. Daily quote types are retained per leg. */
data work.fx_mth_src;
    set compfx.g_exrt_mth(keep=datadate fromcurm tocurm exrat12m);
    if datadate < "01JAN1974"d or datadate > "31DEC2000"d then delete;
    if upcase(strip(fromcurm)) ne "GBP" then delete;
    if missing(tocurm) then delete;
    fx_month=intnx("month",datadate,0,"beginning");
    currency=upcase(strip(tocurm));
    fx_value=exrat12m;
    keep fx_month currency fx_value;
    format fx_month date9.;
run;

proc sql;
    create table work.fx_mth_group as
    select fx_month, currency, count(*) as source_rows,
           count(distinct fx_value) as distinct_rates,
           min(fx_value) as min_rate, max(fx_value) as max_rate
    from work.fx_mth_src
    group by fx_month, currency;
quit;

data work.fx_mth_base;
    set work.fx_mth_group;
    fx_rate=.;
    if distinct_rates=1 and min_rate>0 then fx_rate=min_rate;
run;

proc sql;
    create table work.fx_mth_pair0 as
    select r.fx_month, r.currency,
           r.fx_rate as gbp_to_report,
           u.fx_rate as gbp_to_usd,
           case when r.currency="GBP" then u.fx_rate
                else u.fx_rate/r.fx_rate end as usd_factor
    from work.fx_mth_base as r
    inner join work.fx_mth_base as u
      on r.fx_month=u.fx_month and u.currency="USD"
    where r.currency not in ("USD","GBP") and
          not missing(r.fx_rate) and not missing(u.fx_rate) and
          r.fx_rate>0 and u.fx_rate>0;
quit;

data work.fx_mth_gbp;
    set work.fx_mth_base(where=(currency="USD" and not missing(fx_rate)));
    currency="GBP";
    gbp_to_report=1;
    gbp_to_usd=fx_rate;
    usd_factor=fx_rate;
    keep fx_month currency gbp_to_report gbp_to_usd usd_factor;
run;

data work.fx_mth_pair;
    set work.fx_mth_pair0 work.fx_mth_gbp;
run;

data work.fx_dly_src;
    set compfx.g_exrt_dly(keep=datadate fromcurd tocurd exratd exrattpd);
    if datadate < "01JAN1974"d or datadate > "31DEC2000"d then delete;
    if upcase(strip(fromcurd)) ne "GBP" then delete;
    if missing(tocurd) then delete;
    quote_date=datadate;
    currency=upcase(strip(tocurd));
    fx_value=exratd;
    keep quote_date currency fx_value exrattpd;
    format quote_date date9.;
run;

proc sql;
    create table work.fx_dly_group as
    select quote_date, currency, count(*) as source_rows,
           count(distinct fx_value) as distinct_rates,
           min(fx_value) as min_rate, max(fx_value) as max_rate,
           count(distinct exrattpd) as type_count,
           min(exrattpd) as type_min,
           max(exrattpd) as type_max
    from work.fx_dly_src
    group by quote_date, currency;
quit;

data work.fx_dly_base;
    set work.fx_dly_group;
    fx_rate=.;
    if distinct_rates=1 and min_rate>0 then fx_rate=min_rate;
run;

proc sql;
    create table work.fx_dly_pair0 as
    select r.quote_date, r.currency,
           r.fx_rate as gbp_to_report,
           u.fx_rate as gbp_to_usd,
           u.fx_rate/r.fx_rate as usd_factor,
           r.type_min as report_type_min,
           r.type_max as report_type_max,
           r.type_count as report_type_count,
           u.type_min as usd_type_min,
           u.type_max as usd_type_max,
           u.type_count as usd_type_count
    from work.fx_dly_base as r
    inner join work.fx_dly_base as u
      on r.quote_date=u.quote_date and u.currency="USD"
    where r.currency not in ("USD","GBP") and
          not missing(r.fx_rate) and not missing(u.fx_rate) and
          r.fx_rate>0 and u.fx_rate>0;
quit;

data work.fx_dly_gbp;
    set work.fx_dly_base(where=(currency="USD" and not missing(fx_rate)));
    currency="GBP";
    gbp_to_report=1;
    gbp_to_usd=fx_rate;
    usd_factor=fx_rate;
    report_type_min="ID";
    report_type_max="ID";
    report_type_count=0;
    usd_type_min=type_min;
    usd_type_max=type_max;
    usd_type_count=type_count;
    keep quote_date currency gbp_to_report gbp_to_usd usd_factor
         report_type_min report_type_max report_type_count
         usd_type_min usd_type_max usd_type_count;
run;

data work.fx_dly_pair;
    set work.fx_dly_pair0 work.fx_dly_gbp;
run;

/* A BY-group as-of merge keeps the latest same-date pair for each reporting
   currency without a many-to-many date-range join. */
data work.fx_dly_rate_in;
    set work.fx_dly_pair;
    length fx_currency $4;
    fx_currency=currency;
    fx_keydate=quote_date;
    is_rate=1;
    keep fx_currency fx_keydate is_rate usd_factor gbp_to_report gbp_to_usd
         report_type_min report_type_max report_type_count
         usd_type_min usd_type_max usd_type_count;
run;

data work.comp_fx_in;
    set work.comp_one;
    length fx_currency $4;
    fx_currency=upcase(strip(curcd));
    fx_keydate=datadate;
    is_comp=1;
    keep gvkey datadate fyear fyr pddur indfmt curcd sich xrd xrd_use xrd_missing
         at sale ib dvc ceq txditc pstk che ivao dlc dltt mib
         fx_currency fx_keydate is_comp;
run;

proc sort data=work.fx_dly_rate_in; by fx_currency fx_keydate; run;
proc sort data=work.comp_fx_in; by fx_currency fx_keydate; run;

data work.comp_fx_daily;
    merge work.fx_dly_rate_in(in=rate_row) work.comp_fx_in(in=comp_row);
    by fx_currency fx_keydate;
    length last_report_type_min last_report_type_max
           last_usd_type_min last_usd_type_max $3
           fx_daily_report_type_min fx_daily_report_type_max
           fx_daily_usd_type_min fx_daily_usd_type_max $3;
    retain last_fx_date last_fx_factor last_gbp_to_report last_gbp_to_usd
           last_report_type_min last_report_type_max last_report_type_count
           last_usd_type_min last_usd_type_max last_usd_type_count;
    if first.fx_currency then
        call missing(last_fx_date,last_fx_factor,last_gbp_to_report,last_gbp_to_usd,
                     last_report_type_min,last_report_type_max,last_report_type_count,
                     last_usd_type_min,last_usd_type_max,last_usd_type_count);
    if rate_row then do;
        last_fx_date=fx_keydate;
        last_fx_factor=usd_factor;
        last_gbp_to_report=gbp_to_report;
        last_gbp_to_usd=gbp_to_usd;
        last_report_type_min=report_type_min;
        last_report_type_max=report_type_max;
        last_report_type_count=report_type_count;
        last_usd_type_min=usd_type_min;
        last_usd_type_max=usd_type_max;
        last_usd_type_count=usd_type_count;
    end;
    if comp_row then do;
        fx_daily_factor=.;
        fx_daily_quote_date=.;
        fx_daily_age=.;
        call missing(fx_daily_report_rate,fx_daily_usd_rate,
                     fx_daily_report_type_min,fx_daily_report_type_max,
                     fx_daily_report_type_count,fx_daily_usd_type_min,
                     fx_daily_usd_type_max,fx_daily_usd_type_count);
        if fx_currency="USD" then do;
            fx_daily_factor=1;
            fx_daily_report_rate=1;
            fx_daily_usd_rate=1;
            fx_daily_report_type_min="ID";
            fx_daily_report_type_max="ID";
            fx_daily_usd_type_min="ID";
            fx_daily_usd_type_max="ID";
            fx_daily_report_type_count=0;
            fx_daily_usd_type_count=0;
        end;
        else if not missing(last_fx_date) and
                datadate>=last_fx_date and datadate-last_fx_date<=7 then do;
            fx_daily_factor=last_fx_factor;
            fx_daily_quote_date=last_fx_date;
            fx_daily_age=datadate-last_fx_date;
            fx_daily_report_rate=last_gbp_to_report;
            fx_daily_usd_rate=last_gbp_to_usd;
            fx_daily_report_type_min=last_report_type_min;
            fx_daily_report_type_max=last_report_type_max;
            fx_daily_report_type_count=last_report_type_count;
            fx_daily_usd_type_min=last_usd_type_min;
            fx_daily_usd_type_max=last_usd_type_max;
            fx_daily_usd_type_count=last_usd_type_count;
        end;
        output;
    end;
    drop is_rate is_comp fx_currency fx_keydate rate_row comp_row
         usd_factor gbp_to_report gbp_to_usd report_type_min report_type_max
         report_type_count usd_type_min usd_type_max usd_type_count
         last_fx_date last_fx_factor last_gbp_to_report last_gbp_to_usd
         last_report_type_min last_report_type_max last_report_type_count
         last_usd_type_min last_usd_type_max last_usd_type_count;
run;

proc sql;
    create table work.comp_fx0 as
    select a.*, intnx("month",a.datadate,0,"beginning") as fx_flow_month format=date9.,
           case when upcase(strip(a.curcd))="USD" then 1
                else m.usd_factor end as fx_flow_factor,
           m.gbp_to_report as fx_flow_gbp_to_report,
           m.gbp_to_usd as fx_flow_gbp_to_usd
    from work.comp_fx_daily as a
    left join work.fx_mth_pair as m
      on intnx("month",a.datadate,0,"beginning")=m.fx_month
     and upcase(strip(a.curcd))=m.currency;
quit;

data work.comp_usd;
    set work.comp_fx0;
    xrd_usd=.; ib_usd=.;
    if missing(xrd) or xrd=0 then xrd_usd=0;
    else if not missing(fx_flow_factor) and fx_flow_factor>0 then xrd_usd=xrd*fx_flow_factor;
    if not missing(ib) then do;
        if ib=0 then ib_usd=0;
        else if not missing(fx_flow_factor) and fx_flow_factor>0 then ib_usd=ib*fx_flow_factor;
    end;
    ceq_usd=.; txditc_usd=.; pstk_usd=.; che_usd=.; ivao_usd=.;
    dlc_usd=.; dltt_usd=.; mib_usd=.;
    if not missing(ceq) then do;
        if ceq=0 then ceq_usd=0;
        else if not missing(fx_daily_factor) then ceq_usd=ceq*fx_daily_factor;
    end;
    if not missing(txditc) then do;
        if txditc=0 then txditc_usd=0;
        else if not missing(fx_daily_factor) then txditc_usd=txditc*fx_daily_factor;
    end;
    if not missing(pstk) then do;
        if pstk=0 then pstk_usd=0;
        else if not missing(fx_daily_factor) then pstk_usd=pstk*fx_daily_factor;
    end;
    if not missing(che) then do;
        if che=0 then che_usd=0;
        else if not missing(fx_daily_factor) then che_usd=che*fx_daily_factor;
    end;
    if not missing(ivao) then do;
        if ivao=0 then ivao_usd=0;
        else if not missing(fx_daily_factor) then ivao_usd=ivao*fx_daily_factor;
    end;
    if not missing(dlc) then do;
        if dlc=0 then dlc_usd=0;
        else if not missing(fx_daily_factor) then dlc_usd=dlc*fx_daily_factor;
    end;
    if not missing(dltt) then do;
        if dltt=0 then dltt_usd=0;
        else if not missing(fx_daily_factor) then dltt_usd=dltt*fx_daily_factor;
    end;
    if not missing(mib) then do;
        if mib=0 then mib_usd=0;
        else if not missing(fx_daily_factor) then mib_usd=mib*fx_daily_factor;
    end;
    keep gvkey datadate fyear fyr pddur indfmt curcd sich xrd xrd_use xrd_missing
         xrd_usd at sale ib ib_usd dvc ceq txditc pstk che ivao dlc dltt mib
         ceq_usd txditc_usd pstk_usd che_usd ivao_usd dlc_usd dltt_usd mib_usd
         fx_flow_month fx_flow_factor fx_flow_gbp_to_report fx_flow_gbp_to_usd
         fx_daily_factor fx_daily_quote_date fx_daily_age
         fx_daily_report_rate fx_daily_usd_rate
         fx_daily_report_type_min fx_daily_report_type_max fx_daily_report_type_count
         fx_daily_usd_type_min fx_daily_usd_type_max fx_daily_usd_type_count;
run;

proc sort data=work.comp_usd out=work.comp_usd_sort;
    by gvkey fyear;
run;

proc sql;
    title "Currency conversion coverage by reported currency";
    select curcd, count(*) as annual_rows,
           sum(not missing(fx_flow_factor)) as flow_rate_available,
           sum(not missing(xrd_usd)) as xrd_usd_available,
           sum(not missing(fx_daily_factor)) as stock_rate_available,
           sum(not missing(ceq_usd)) as ceq_usd_available,
           sum(fx_daily_age=0) as exact_daily_quotes,
           sum(fx_daily_age between 1 and 7) as prior_daily_quotes,
           sum(fx_daily_report_type_min="AR") as report_leg_AR,
           sum(fx_daily_report_type_min="CF") as report_leg_CF,
           sum(fx_daily_usd_type_min="AR") as usd_leg_AR,
           sum(fx_daily_usd_type_min="CF") as usd_leg_CF
    from work.comp_usd
    group by curcd
    order by curcd;
    select count(*) as fx_month_currency_groups,
           sum(distinct_rates>1) as conflicting_monthly_rate_groups
    from work.fx_mth_group;
    select count(*) as fx_day_currency_groups,
           sum(distinct_rates>1) as conflicting_daily_rate_groups,
           sum(type_count>1) as mixed_daily_type_groups
    from work.fx_dly_group;
quit;

/* Build source-weighted R&D assets/amortization using only observed annual
   rows. The BY-group history uses explicit fiscal-year continuity checks. */
data work.fund_hist;
    set work.comp_usd_sort;
    by gvkey fyear;
    retain xrd_usd_l1-xrd_usd_l5 fy_l1-fy_l5
           fx_flow_month_l1-fx_flow_month_l5
           fx_flow_factor_l1-fx_flow_factor_l5
           cur_l1-cur_l5;
    length cur_l1-cur_l5 $4 cur_used_l1-cur_used_l5 $4;
    if first.gvkey then call missing(xrd_usd_l1,xrd_usd_l2,xrd_usd_l3,
                                     xrd_usd_l4,xrd_usd_l5,
                                     fy_l1,fy_l2,fy_l3,fy_l4,fy_l5,
                                     fx_flow_month_l1,fx_flow_month_l2,fx_flow_month_l3,
                                     fx_flow_month_l4,fx_flow_month_l5,
                                     fx_flow_factor_l1,fx_flow_factor_l2,fx_flow_factor_l3,
                                     fx_flow_factor_l4,fx_flow_factor_l5,
                                     cur_l1,cur_l2,cur_l3,cur_l4,cur_l5,
                                     xrd_usd_l1,xrd_usd_l2,xrd_usd_l3,xrd_usd_l4,xrd_usd_l5);

    rdasset=.;
    rdamort=.;
    if fyear=fy_l1+1 and fy_l1=fyear-1 and
       fy_l2=fyear-2 and fy_l3=fyear-3 and fy_l4=fyear-4 and
       nmiss(xrd_usd,xrd_usd_l1,xrd_usd_l2,xrd_usd_l3,xrd_usd_l4)=0 then
        rdasset=xrd_usd+0.8*xrd_usd_l1+0.6*xrd_usd_l2+0.4*xrd_usd_l3+0.2*xrd_usd_l4;
    if fy_l1=fyear-1 and fy_l2=fyear-2 and fy_l3=fyear-3 and
       fy_l4=fyear-4 and fy_l5=fyear-5 and
       nmiss(xrd_usd_l1,xrd_usd_l2,xrd_usd_l3,xrd_usd_l4,xrd_usd_l5)=0 then
        rdamort=0.2*(xrd_usd_l1+xrd_usd_l2+xrd_usd_l3+xrd_usd_l4+xrd_usd_l5);

    noa=.;
    if nmiss(dlc_usd,dltt_usd,pstk_usd,che_usd,ivao_usd,ceq_usd,mib_usd)=0 then
        noa=dlc_usd+dltt_usd+pstk_usd-che_usd-ivao_usd+ceq_usd+mib_usd;
    adj_noa=.;
    if not missing(noa) and not missing(rdasset) then adj_noa=noa+rdasset;
    adj_earn=.;
    if not missing(ib_usd) and not missing(rdamort) and not missing(xrd_usd) then
        adj_earn=ib_usd+xrd_usd-rdamort;
    arnoa=.;
    if not missing(adj_earn) and not missing(adj_noa) and adj_noa ne 0 then
        arnoa=adj_earn/adj_noa;

    /* Preserve the actual pre-shift history terms used by this row's
       capitalization/amortization formulas for the final handoff. */
    fy_used_l1=fy_l1; fy_used_l2=fy_l2; fy_used_l3=fy_l3;
    fy_used_l4=fy_l4; fy_used_l5=fy_l5;
    xrd_usd_used_l1=xrd_usd_l1; xrd_usd_used_l2=xrd_usd_l2;
    xrd_usd_used_l3=xrd_usd_l3; xrd_usd_used_l4=xrd_usd_l4;
    xrd_usd_used_l5=xrd_usd_l5;
    fx_flow_month_used_l1=fx_flow_month_l1; fx_flow_month_used_l2=fx_flow_month_l2;
    fx_flow_month_used_l3=fx_flow_month_l3; fx_flow_month_used_l4=fx_flow_month_l4;
    fx_flow_month_used_l5=fx_flow_month_l5;
    fx_flow_factor_used_l1=fx_flow_factor_l1; fx_flow_factor_used_l2=fx_flow_factor_l2;
    fx_flow_factor_used_l3=fx_flow_factor_l3; fx_flow_factor_used_l4=fx_flow_factor_l4;
    fx_flow_factor_used_l5=fx_flow_factor_l5;
    cur_used_l1=cur_l1; cur_used_l2=cur_l2; cur_used_l3=cur_l3;
    cur_used_l4=cur_l4; cur_used_l5=cur_l5;

    fy_l5=fy_l4; fy_l4=fy_l3; fy_l3=fy_l2; fy_l2=fy_l1; fy_l1=fyear;
    xrd_usd_l5=xrd_usd_l4; xrd_usd_l4=xrd_usd_l3; xrd_usd_l3=xrd_usd_l2;
    xrd_usd_l2=xrd_usd_l1; xrd_usd_l1=xrd_usd;
    fx_flow_month_l5=fx_flow_month_l4; fx_flow_month_l4=fx_flow_month_l3;
    fx_flow_month_l3=fx_flow_month_l2; fx_flow_month_l2=fx_flow_month_l1;
    fx_flow_month_l1=fx_flow_month;
    fx_flow_factor_l5=fx_flow_factor_l4; fx_flow_factor_l4=fx_flow_factor_l3;
    fx_flow_factor_l3=fx_flow_factor_l2; fx_flow_factor_l2=fx_flow_factor_l1;
    fx_flow_factor_l1=fx_flow_factor;
    cur_l5=cur_l4; cur_l4=cur_l3; cur_l3=cur_l2; cur_l2=cur_l1;
    cur_l1=upcase(strip(curcd));
run;

/* Full-year eligibility is checked from adjacent fiscal-year statement dates.
   A present PDDUR that is not 12 overrides the date-based full-year flag. */
proc sql;
    create table work.fund_prev as
    select a.*, b.datadate as prev_date, b.fyr as prev_fyr
    from work.fund_hist as a
    left join work.fund_hist as b
      on a.gvkey=b.gvkey and b.fyear=a.fyear-1;
quit;

data work.fund_hist;
    set work.fund_prev;
    full_year=0;
    if not missing(prev_date) and intck("month",prev_date,datadate)=12 and
       month(prev_date)=month(datadate) and fyr=prev_fyr then full_year=1;
    if not missing(pddur) and pddur ne 12 then full_year=0;
    drop prev_date prev_fyr;
run;

/* For portfolio formation year y, select one coherent annual statement whose
   actual DATADATE falls in calendar year y-1. Prefer a full-year statement,
   then the latest date within that calendar year. */
proc sql;
    create table work.port_calendar_dups as
    select gvkey, year(datadate) as account_calyear,
           count(*) as statement_rows,
           count(distinct fyear) as fiscal_labels
    from work.fund_hist
    where year(datadate) between 1978 and 1999
    group by gvkey, calculated account_calyear
    having calculated statement_rows>1;
    title "Portfolio prior-calendar-year statement duplicates";
    select count(*) as gvkey_calendar_year_duplicates,
           sum(statement_rows) as rows_in_duplicate_groups,
           sum(fiscal_labels>1) as dup_groups_multi_fyear
    from work.port_calendar_dups;
quit;

data work.port_calendar0;
    set work.fund_hist;
    account_calyear=year(datadate);
    if account_calyear<1978 or account_calyear>1999 then delete;
    full_priority=(full_year=1);
    formyear=account_calyear+1;
run;

proc sort data=work.port_calendar0 out=work.port_calendar_sort;
    by gvkey account_calyear descending full_priority descending datadate descending fyear;
run;

data work.port_calendar;
    set work.port_calendar_sort;
    by gvkey account_calyear;
    if first.account_calyear;
run;

/* Read and screen CCM links. LINKENDDT=.E is an open end; LINKDT=.B is an
   open start. The provider used-link flag and primary/secondary types remain
   explicit rather than being replaced by identifier-only joins. */
data work.links;
    set ccm.ccmxpf_linktable(keep=gvkey linkprim liid linktype lpermno lpermco
                                  linkdt linkenddt usedflag);
    if usedflag ne 1 then delete;
    if upcase(strip(linktype)) not in ("LC","LU") then delete;
    if upcase(strip(linkprim)) not in ("P","C") then delete;
    if missing(lpermno) or lpermno<=0 or missing(lpermco) or lpermco<=0 then delete;
    if not missing(linkenddt) and linkenddt ne .E and linkenddt < "01JAN1978"d then delete;
    if not missing(linkdt) and linkdt ne .B and linkdt > "30JUN2000"d then delete;
run;

/* Main-sample links use each statement's exact date and month-four date.
   Portfolio links use the selected prior-calendar-year statement date and
   June 30 of its formation year. */
data work.link_ref_main;
    set work.fund_hist(keep=gvkey fyear datadate);
    length refkind $4;
    refdate=datadate; refkind="FYE"; output;
    refdate=intnx("month",datadate,4,"end"); refkind="MVE4"; output;
    format refdate date9.;
    keep gvkey fyear refkind refdate;
run;

data work.link_ref_port;
    set work.port_calendar(keep=gvkey formyear datadate);
    length refkind $4;
    fyear=formyear;
    refdate=datadate; refkind="PFYE"; output;
    refdate=mdy(6,30,formyear); refkind="PJUN"; output;
    format refdate date9.;
    keep gvkey fyear refkind refdate;
run;

data work.link_ref;
    set work.link_ref_main work.link_ref_port;
run;

proc sql;
    create table work.link_match0 as
    select r.gvkey, r.fyear, r.refkind,
           count(distinct l.lpermco) as n_permco,
           count(distinct case when l.linkprim="P" then l.lpermno end) as n_permno_p,
           count(distinct case when l.linkprim="C" then l.lpermno end) as n_permno_c,
           min(l.lpermco) as candidate_permco,
           min(case when l.linkprim="P" then l.lpermno end) as primary_permno,
           min(case when l.linkprim="C" then l.lpermno end) as compustat_permno
    from work.link_ref as r
    left join work.links as l
      on r.gvkey=l.gvkey
     and (l.linkdt=.B or (not missing(l.linkdt) and l.linkdt<=r.refdate))
     and (l.linkenddt=.E or (not missing(l.linkenddt) and l.linkenddt>=r.refdate))
    group by r.gvkey, r.fyear, r.refkind;
quit;

data work.link_match;
    set work.link_match0;
    permco=.; permno=.;
    if n_permco=1 then permco=candidate_permco;
    if n_permno_p=1 then permno=primary_permno;
    else if n_permno_p=0 and n_permno_c=1 then permno=compustat_permno;
run;

proc sql;
    title "Dated CCM link cardinality";
    select refkind, count(*) as reference_rows,
           sum(n_permco=1) as unique_company_links,
           sum(n_permco>1) as conflicting_company_links,
           sum(n_permno_p>1) as multiple_primary_issue_links,
           sum(n_permno_p=0 and n_permno_c=1) as secondary_fallback_links
    from work.link_match
    group by refkind;
quit;

/* CRSP monthly records, effective-dated security type/exchange and delisting
   returns. Monthly periods are keyed separately from actual CRSP trade dates. */
data work.msf0;
    set crsp.msf(keep=permno permco date ret prc shrout);
    if date < "01DEC1977"d or date > "30JUN2001"d then delete;
    monthkey=intnx("month",date,0,"beginning");
    me_sec=.;
    if not missing(prc) and not missing(shrout) and shrout>0 then
        me_sec=abs(prc)*shrout/1000;
    format date monthkey date9.;
run;

data work.month_last0;
    set crsp.dsi(keep=date);
    if date < "01DEC1977"d or date > "30JUN2001"d then delete;
    monthkey=intnx("month",date,0,"beginning");
    format date monthkey date9.;
run;

proc sql;
    create table work.month_last as
    select monthkey, max(date) as last_trade_date format=date9.
    from work.month_last0
    group by monthkey;
quit;

data work.names_range;
    set crsp.msenames(keep=permno permco namedt nameendt shrcd exchcd);
    if nameendt=.E then name_end="30JUN2001"d;
    else if not missing(nameendt) then name_end=nameendt;
    else delete;
    if namedt=.B then name_start="01DEC1977"d;
    else if not missing(namedt) then name_start=namedt;
    else delete;
    if name_end < "01DEC1977"d or name_start > "30JUN2001"d then delete;
    name_start=max(name_start,"01DEC1977"d);
    name_end=min(name_end,"30JUN2001"d);
    keep permno permco name_start name_end shrcd exchcd;
    format name_start name_end date9.;
run;

data work.names_m;
    set work.names_range;
    monthkey=intnx("month",name_start,0,"beginning");
    end_month=intnx("month",name_end,0,"beginning");
    do while(monthkey<=end_month);
        output;
        monthkey=intnx("month",monthkey,1,"beginning");
    end;
    keep permno permco monthkey name_start name_end shrcd exchcd;
    format monthkey name_start name_end date9.;
run;

proc sql;
    create table work.stock_name0 as
    select m.permno, m.permco as msf_permco, n.permco as name_permco,
           m.date, m.monthkey, m.ret, m.prc, m.shrout, m.me_sec,
           n.name_start, n.shrcd, n.exchcd
    from work.msf0 as m
    left join work.names_m as n
      on m.permno=n.permno and m.monthkey=n.monthkey
     and m.date>=n.name_start and m.date<=n.name_end;
quit;

proc sql;
    title "CRSP monthly key and effective-name diagnostics";
    select count(*) as stock_month_rows,
           count(distinct cats(permno,"/",put(monthkey,yymmn6.))) as permno_months,
           sum(missing(shrcd)) as missing_name_matches
    from work.stock_name0;
    create table work.stock_name_dups as
    select permno, monthkey, count(*) as rows
    from work.stock_name0
    group by permno, monthkey
    having calculated rows>1;
    select count(*) as duplicate_permno_months,
           sum(rows) as rows_in_duplicate_permno_months
    from work.stock_name_dups;
quit;

/* Overlapping name ranges are resolved to the latest effective start date;
   the prior duplicate diagnostic records the affected key count. */
proc sort data=work.stock_name0 out=work.stock_name_sort;
    by permno monthkey descending name_start;
run;

data work.stock_month;
    set work.stock_name_sort;
    by permno monthkey;
    if first.monthkey;
    if shrcd not in (10,11) then delete;
    permco=.;
    company_name_match=(not missing(name_permco) and name_permco>0 and
                        not missing(msf_permco) and msf_permco=name_permco);
    if company_name_match then permco=name_permco;
    ret_adj=ret;
run;

/* Company market equity is a complete sum over common issues active at the
   final CRSP trading date of each month (CRSP.DSI). A missing issue row, price,
   shares, or PERMCO agreement makes that company's total unavailable. */
proc sql;
    create table work.msf_month as
    select permno, monthkey, count(*) as msf_rows,
           count(distinct permco) as msf_permco_options,
           min(permco) as msf_permco,
           sum(not missing(me_sec)) as me_rows,
           sum(me_sec) as issue_me
    from work.msf0
    group by permno, monthkey;
    create table work.common_active0 as
    select m.monthkey, m.last_trade_date, n.permno, n.permco,
           n.shrcd, n.exchcd
    from work.month_last as m
    inner join work.names_m as n
      on m.monthkey=n.monthkey and
         m.last_trade_date>=n.name_start and m.last_trade_date<=n.name_end
    where n.shrcd in (10,11);
    create table work.common_active_group as
    select monthkey, last_trade_date, permno,
           count(*) as active_name_rows,
           count(distinct permco) as permco_options,
           sum(missing(permco)) as missing_permco_rows,
           min(permco) as active_permco,
           count(distinct shrcd) as sharecode_options,
           min(shrcd) as active_shrcd,
           count(distinct exchcd) as exchange_options,
           sum(missing(exchcd)) as missing_exchange_rows,
           max(exchcd=1) as nyse_any
    from work.common_active0
    group by monthkey, last_trade_date, permno;
quit;

data work.common_active;
    set work.common_active_group;
    name_conflict=(permco_options ne 1 or missing_permco_rows>0);
    exchange_conflict=(exchange_options ne 1 or missing_exchange_rows>0);
    permco=.;
    if permco_options=1 then permco=active_permco;
run;

proc sql;
    /* If one active PERMNO has conflicting PERMCO name-history records,
       mark each possible company incomplete rather than invalidating every
       company for that month. */
    create table work.common_active_ambig0 as
    select c.monthkey, c.last_trade_date, c.permno, c.permco as active_permco,
           max(c.exchcd=1) as nyse_any,
           count(distinct c.exchcd) as exchange_options,
           sum(missing(c.exchcd)) as missing_exchange_rows
    from work.common_active0 as c
    inner join work.common_active_group as g
      on c.monthkey=g.monthkey and c.last_trade_date=g.last_trade_date
     and c.permno=g.permno
    where g.permco_options>1 and not missing(c.permco) and c.permco>0
    group by c.monthkey, c.last_trade_date, c.permno, c.permco;
quit;

data work.common_active_ambig;
    set work.common_active_ambig0;
    permco=active_permco;
    name_conflict=1;
    exchange_conflict=(exchange_options ne 1 or missing_exchange_rows>0);
    keep monthkey last_trade_date permno permco name_conflict exchange_conflict nyse_any;
run;

data work.common_active_all;
    set work.common_active(keep=monthkey last_trade_date permno permco
                               name_conflict exchange_conflict nyse_any)
        work.common_active_ambig;
run;

proc sql;
    create table work.expected_issue0 as
    select a.monthkey, a.last_trade_date, a.permno, a.permco,
           a.name_conflict, a.exchange_conflict, a.nyse_any,
           coalesce(m.msf_rows,0) as msf_rows,
           coalesce(m.msf_permco_options,0) as msf_permco_options,
           m.msf_permco, m.me_rows, m.issue_me
    from work.common_active_all as a
    left join work.msf_month as m
      on a.permno=m.permno and a.monthkey=m.monthkey
    ;
    create table work.unattributed_issue_month as
    select monthkey, sum(permco_options=0) as common_issues_without_permco,
           sum(permco_options>1) as issues_with_conflicting_permcos
    from work.common_active_group
    group by monthkey;
    create table work.company_me_status as
    select permco, monthkey,
           count(*) as expected_issues,
           sum(msf_rows ne 1) as msf_row_gaps,
           sum(me_rows ne 1) as issues_without_market_equity,
           sum(msf_permco_options ne 1 or missing(msf_permco) or
               msf_permco ne permco) as permco_disagreements,
           sum(name_conflict=1) as name_conflicts,
           sum(issue_me) as candidate_me,
           max(last_trade_date) as last_trade_date format=date9.
    from work.expected_issue0
    where not missing(permco) and permco>0
    group by permco, monthkey;
    create table work.company_me0 as
    select *
    from work.company_me_status;
    title "Complete company market equity diagnostics";
    select count(*) as company_months,
           sum(msf_row_gaps>0) as months_with_missing_issue_rows,
           sum(issues_without_market_equity>0) as months_with_missing_issue_me,
           sum(permco_disagreements>0) as months_with_permco_disagreement,
           sum(name_conflicts>0) as co_month_name_conflict
    from work.company_me0;
    select expected_issues, count(*) as company_months,
           sum(msf_row_gaps>0) as incomplete_msf_months,
           sum(issues_without_market_equity>0) as incomplete_me_months
    from work.company_me0
    group by expected_issues
    order by expected_issues;
    select sum(common_issues_without_permco) as issues_no_permco,
           sum(issues_with_conflicting_permcos) as issues_conflicting_permco
    from work.unattributed_issue_month;
quit;

data work.company_me;
    set work.company_me0;
    me_co=.;
    if msf_row_gaps=0 and issues_without_market_equity=0 and
       permco_disagreements=0 and name_conflicts=0 then me_co=candidate_me;
run;

data work.delist0;
    set crsp.msedelist(keep=permno dlstdt dlret);
    if missing(dlstdt) or dlstdt < "01DEC1977"d or dlstdt > "30JUN2001"d then delete;
    dlmonth=intnx("month",dlstdt,0,"beginning");
    format dlstdt dlmonth date9.;
run;

proc sql;
    create table work.delist_month as
    select permno, dlmonth, min(dlstdt) as dlstdt format=date9.,
           count(*) as event_rows,
           count(distinct dlret) as distinct_dlret,
           min(dlret) as dlret
    from work.delist0
    group by permno, dlmonth;
    title "Delisting return key diagnostics";
    select count(*) as delist_months,
           sum(event_rows>1) as duplicate_delist_months,
           sum(distinct_dlret>1) as conflicting_delist_returns
    from work.delist_month;
    create table work.stock_del0 as
    select s.*, d.dlmonth, d.event_rows, d.distinct_dlret, d.dlret
    from work.stock_month as s
    left join work.delist_month as d
      on s.permno=d.permno and s.monthkey=d.dlmonth;
quit;

data work.stock_del;
    set work.stock_del0;
    if event_rows>1 and distinct_dlret>1 then ret_adj=.;
    else if not missing(dlmonth) then do;
        if not missing(ret) and not missing(dlret) then ret_adj=(1+ret)*(1+dlret)-1;
        else if missing(ret) and not missing(dlret) then ret_adj=dlret;
        else ret_adj=ret;
    end;
    else ret_adj=ret;
run;

/* Preserve an observed delisting return when CRSP has no MSF row for the
   event month. Map the event-date common issue to PERMCO, with the immediately
   prior month as a documented fallback; unresolved mappings remain unweighted. */
proc sql;
    create table work.delist_map0 as
    select d.permno, d.dlmonth,
           count(n.permno) as name_rows,
           count(distinct n.permco) as permco_options,
           min(n.permco) as name_permco,
           count(distinct n.shrcd) as sharecode_options,
           min(n.shrcd) as event_shrcd
    from work.delist_month as d
    left join work.names_range as n
      on d.permno=n.permno and d.dlstdt>=n.name_start and d.dlstdt<=n.name_end
    group by d.permno, d.dlmonth;
    create table work.delist_only0 as
    select d.permno, d.dlmonth as monthkey, d.dlret, d.event_rows,
           d.distinct_dlret, d.dlstdt,
           m.name_rows, m.permco_options, m.name_permco,
           m.sharecode_options, m.event_shrcd,
           p.permco as prior_permco, p.me_sec as me_lag,
           s.permno as stock_row_permno
    from work.delist_month as d
    left join work.stock_del as s
      on d.permno=s.permno and d.dlmonth=s.monthkey
    left join work.delist_map0 as m
      on d.permno=m.permno and d.dlmonth=m.dlmonth
    left join work.stock_del as p
      on d.permno=p.permno and p.monthkey=intnx("month",d.dlmonth,-1,"beginning")
    where missing(s.permno) and d.distinct_dlret=1 and
          not missing(d.dlret);
    title "Delisting-only monthly return support";
    select count(*) as dlret_no_common_row,
           sum(not missing(name_permco) and permco_options=1 and
               sharecode_options=1 and event_shrcd in (10,11)) as event_permco_mapped,
           sum(not missing(prior_permco)) as prior_month_permco_available,
           sum(not missing(me_lag)) as prior_month_me_available
    from work.delist_only0;
quit;

data work.delist_only;
    set work.delist_only0;
    length ret_adj 8 permco 8 me_sec 8;
    ret=.; me_sec=.; ret_adj=dlret; dlmonth=monthkey;
    permco=.;
    map_ok=(not missing(name_permco) and permco_options=1 and
            sharecode_options=1 and event_shrcd in (10,11));
    if map_ok then permco=name_permco;
    if not missing(prior_permco) then do;
        if not map_ok then permco=prior_permco;
        else if prior_permco ne name_permco then permco=.;
    end;
    event_only=1;
    format monthkey dlmonth dlstdt date9.;
    keep permno permco monthkey ret ret_adj me_sec me_lag dlmonth dlstdt
         event_rows distinct_dlret dlret map_ok event_only;
run;

data work.stock_full;
    set work.stock_del(keep=permno monthkey ret_adj me_sec)
        work.delist_only(keep=permno monthkey ret_adj me_sec);
run;

/* Main sample candidates: source page 4 / note 3 screens are anchored at t. */
proc sql;
    create table work.sample_link0 as
    select a.*, f.permco as permco_fye, f.permno as ret_permno,
           f.n_permco as nco_fye, f.n_permno_p as np_fye,
           m.permco as permco_mve4, m.n_permco as nco_mve4,
           e.me_co as mve_fye, e.last_trade_date as mve_fye_date,
           q.me_co as mve4, q.last_trade_date as mve4_date
    from work.fund_hist as a
    left join work.link_match as f
      on a.gvkey=f.gvkey and a.fyear=f.fyear and f.refkind="FYE"
    left join work.link_match as m
      on a.gvkey=m.gvkey and a.fyear=m.fyear and m.refkind="MVE4"
    left join work.company_me as e
      on f.permco=e.permco and intnx("month",a.datadate,0,"beginning")=e.monthkey
    left join work.company_me as q
      on m.permco=q.permco and intnx("month",a.datadate,4,"beginning")=q.monthkey
    where a.fyear>=1979 and a.fyear<=1998;
quit;

data work.sample_flags;
    set work.sample_link0;
    fields_ok=(not missing(fyr) and not missing(at) and not missing(sale) and
               not missing(ib) and not missing(dvc) and not missing(ceq));
    book_ok=(not missing(ceq) and ceq>0);
    mve_ok=(not missing(mve_fye) and mve_fye>0 and not missing(mve4) and mve4>0);
    link_ok=(not missing(ret_permno) and not missing(permco_fye));
    rd_ok=(not missing(rdasset) and rdasset>0);
run;

proc sql;
    title "Source-sample attrition and converted-variable coverage";
    select count(*) as annual_rows,
           sum(full_year=1) as full_year_rows,
           sum(fields_ok=1) as required_fields,
           sum(full_year=1 and fields_ok=1 and book_ok=1) as plus_positive_book,
           sum(full_year=1 and fields_ok=1 and book_ok=1 and mve_ok=1) as plus_both_mve,
           sum(full_year=1 and fields_ok=1 and book_ok=1 and mve_ok=1 and link_ok=1) as plus_dated_link,
           sum(full_year=1 and fields_ok=1 and book_ok=1 and mve_ok=1 and link_ok=1 and rd_ok=1) as plus_rd_firm,
           sum(rd_ok=1) as rd_firm_all,
           sum(rd_ok=1 and full_year=1) as rd_plus_full_year,
           sum(rd_ok=1 and full_year=1 and fields_ok=1) as rd_plus_fields,
           sum(rd_ok=1 and full_year=1 and fields_ok=1 and book_ok=1) as rd_plus_book,
           sum(rd_ok=1 and full_year=1 and fields_ok=1 and book_ok=1 and mve_ok=1) as rd_plus_mve,
           sum(rd_ok=1 and full_year=1 and fields_ok=1 and book_ok=1 and mve_ok=1 and link_ok=1) as rd_plus_link,
           sum(rd_ok=1 and not missing(xrd_usd)) as rd_with_converted_xrd,
           sum(rd_ok=1 and not missing(noa)) as rd_with_converted_noa,
           sum(rd_ok=1 and not missing(adj_earn)) as rd_adjearn_avail
    from work.sample_flags;
quit;

data work.sample_pre;
    set work.sample_flags;
    if fields_ok ne 1 or book_ok ne 1 or full_year ne 1 then delete;
    if mve_ok ne 1 or link_ok ne 1 or rd_ok ne 1 then delete;
    rda=rdasset/mve4;
    fyear_next=fyear+1;
    startmonth=intnx("month",datadate,5,"beginning");
    endmonth=intnx("month",datadate,16,"beginning");
    mve4month=intnx("month",datadate,4,"beginning");
    format startmonth endmonth mve4month date9.;
run;

/* Fiscal-year t+1 variables and denominator timing choices are applied here. */
proc sql;
    create table work.sample_vars0 as
    select a.*, b.rdasset as rdasset_next, b.noa as noa_next,
           b.adj_noa as adj_noa_next, b.adj_earn as adj_earn_next,
           b.arnoa as arnoa_next, b.xrd_usd as xrd_usd_next,
           b.ib_usd as ib_usd_next,
           b.fx_flow_month as fx_flow_month_next,
           b.fx_flow_factor as fx_flow_factor_next,
           b.fx_flow_gbp_to_report as fx_flow_gbp_to_report_next,
           b.fx_flow_gbp_to_usd as fx_flow_gbp_to_usd_next,
           b.fx_daily_quote_date as fx_daily_quote_date_next,
           b.fx_daily_age as fx_daily_age_next,
           b.fx_daily_factor as fx_daily_factor_next,
           b.fx_daily_report_rate as fx_daily_report_rate_next,
           b.fx_daily_usd_rate as fx_daily_usd_rate_next,
           b.fx_daily_report_type_min as fx_daily_report_type_min_next,
           b.fx_daily_report_type_max as fx_daily_report_type_max_next,
           b.fx_daily_report_type_count as fx_daily_report_type_count_next,
           b.fx_daily_usd_type_min as fx_daily_usd_type_min_next,
           b.fx_daily_usd_type_max as fx_daily_usd_type_max_next,
           b.fx_daily_usd_type_count as fx_daily_usd_type_count_next
    from work.sample_pre as a
    left join work.fund_hist as b
      on a.gvkey=b.gvkey and b.fyear=a.fyear_next;
quit;

data work.sample_vars;
    set work.sample_vars0;
    delta_rda=.; arnoa=.;
    if not missing(rdasset_next) and not missing(rdasset) and
       not missing(noa_next) and noa_next ne 0 then
        delta_rda=(rdasset_next-rdasset)/noa_next;
    if not missing(adj_earn_next) and not missing(adj_noa_next) and
       adj_noa_next ne 0 then arnoa=adj_earn_next/adj_noa_next;
run;

/* Exact calendar-month security market equity, using all common issues for
   company-level denominators. */
proc sort data=work.stock_del out=work.stock_sort;
    by permno monthkey;
run;

data work.stock_lag;
    set work.stock_sort;
    by permno;
    retain prev_me prev_month;
    if first.permno then call missing(prev_me,prev_month);
    me_lag=.;
    if not missing(prev_month) and intck("month",prev_month,monthkey)=1 then me_lag=prev_me;
    prev_me=me_sec;
    prev_month=monthkey;
run;

data work.stock_lag_plus;
    set work.stock_lag
        work.delist_only(keep=permno permco monthkey ret_adj me_sec me_lag);
run;

/* Annual size/book-to-market portfolios. Formation year y uses the selected
   annual statement dated in calendar year y-1, December market equity from
   y-1, and CCM links valid at the statement date and June 30 of y. */
proc sql;
    create table work.port_input0 as
    select a.gvkey, a.formyear, a.datadate, a.fyear as source_fyear,
           j.permco as permco_june, f.permco as permco_fye,
           a.ceq_usd, a.txditc_usd, a.rdasset,
           e.me_co as me_fye, d.me_co as me_dec,
           j.n_permco as nco_june, f.n_permco as nco_fye
    from work.port_calendar as a
    left join work.link_match as j
      on a.gvkey=j.gvkey and a.formyear=j.fyear and j.refkind="PJUN"
    left join work.link_match as f
      on a.gvkey=f.gvkey and a.formyear=f.fyear and f.refkind="PFYE"
    left join work.company_me as e
      on f.permco=e.permco and intnx("month",a.datadate,0,"beginning")=e.monthkey
    left join work.company_me as d
      on j.permco=d.permco and mdy(12,1,a.formyear-1)=d.monthkey
    where a.formyear>=1979 and a.formyear<=2000;
quit;

data work.port_input;
    set work.port_input0;
    adjbook=.; bm=.;
    if nco_june=1 and nco_fye=1 and permco_june=permco_fye and
       not missing(ceq_usd) and not missing(txditc_usd) and
       not missing(rdasset) then adjbook=ceq_usd+txditc_usd+rdasset;
    if not missing(adjbook) and adjbook>0 and not missing(me_fye) and me_fye>0
       then bm=adjbook/me_fye;
    dec_me=me_dec;
    if formyear<1979 or formyear>2000 then delete;
    if missing(permco_june) or missing(dec_me) or dec_me<=0 or missing(bm) then delete;
run;

/* A PERMCO with more than one eligible GVKEY is ambiguous for one-company
   weighting, so it is not counted twice in the benchmark universe. */
proc sql;
    create table work.permco_dups as
    select formyear, permco_june, count(distinct gvkey) as gvkeys
    from work.port_input
    group by formyear, permco_june
    having calculated gvkeys>1;
    title "Portfolio company mapping diagnostics";
    select count(*) as duplicate_permco_years,
           sum(gvkeys) as gvkeys_in_ambiguous_permco_years
    from work.permco_dups;
quit;

proc sort data=work.port_input out=work.port_input_sort0;
    by formyear permco_june;
run;

proc sort data=work.permco_dups out=work.permco_dups_sort;
    by formyear permco_june;
run;

data work.port_input_u;
    merge work.port_input_sort0(in=a) work.permco_dups_sort(in=d);
    by formyear permco_june;
    if a and not d;
run;

proc sql;
    create table work.nyse_permco as
    select permco, year(monthkey) as formyear,
           max(nyse_any) as nyse
    from work.common_active
    where month(monthkey)=6 and not missing(permco) and
          name_conflict=0 and exchange_conflict=0
    group by permco, calculated formyear;
    create table work.port_input2 as
    select a.*, coalesce(n.nyse,0) as nyse
    from work.port_input_u as a
    left join work.nyse_permco as n
      on a.permco_june=n.permco and a.formyear=n.formyear;
quit;

proc sort data=work.port_input2(where=(nyse=1)) out=work.nyse_sort;
    by formyear;
run;

proc univariate data=work.nyse_sort noprint;
    by formyear;
    var dec_me;
    output out=work.size_cut
        pctlpts=20 40 60 80 pctlpre=sz_ pctlname=q20 q40 q60 q80;
run;

proc univariate data=work.nyse_sort noprint;
    by formyear;
    var bm;
    output out=work.bm_cut
        pctlpts=20 40 60 80 pctlpre=bm_ pctlname=q20 q40 q60 q80;
run;

data work.cutoffs;
    merge work.size_cut work.bm_cut;
    by formyear;
run;

proc sort data=work.port_input2 out=work.port_input_sort;
    by formyear;
run;

data work.port_assign0;
    merge work.port_input_sort(in=a) work.cutoffs(in=b);
    by formyear;
    if a and b;
    if dec_me<=sz_q20 then sizegrp=1;
    else if dec_me<=sz_q40 then sizegrp=2;
    else if dec_me<=sz_q60 then sizegrp=3;
    else if dec_me<=sz_q80 then sizegrp=4;
    else sizegrp=5;
    if bm<=bm_q20 then bmgrp=1;
    else if bm<=bm_q40 then bmgrp=2;
    else if bm<=bm_q60 then bmgrp=3;
    else if bm<=bm_q80 then bmgrp=4;
    else bmgrp=5;
run;

proc sort data=work.port_assign0 out=work.port_assign;
    by permco_june formyear;
run;

/* Value-weighted July–June monthly portfolio returns. A missing live return
   is not converted to zero; it contributes no observed return/weight. */
proc sql;
    create table work.port_ret0 as
    select p.formyear, p.sizegrp, p.bmgrp, s.monthkey,
           sum(s.me_lag*s.ret_adj)/sum(s.me_lag) as portret,
           count(distinct s.permno) as issues
    from work.port_assign as p
    inner join work.stock_lag_plus as s
      on p.permco_june=s.permco
     and ((month(s.monthkey)>=7 and year(s.monthkey)=p.formyear) or
          (month(s.monthkey)<=6 and year(s.monthkey)=p.formyear+1))
    where s.monthkey>="01JUL1979"d and s.monthkey<="01JUN2001"d
      and not missing(s.ret_adj) and not missing(s.me_lag) and s.me_lag>0
    group by p.formyear, p.sizegrp, p.bmgrp, s.monthkey;
quit;

proc sql;
    title "Annual benchmark portfolio support";
    select formyear, count(distinct permco_june) as formed_companies,
           count(distinct cats(put(sizegrp,best.),put(bmgrp,best.))) as formed_portfolios
    from work.port_assign
    group by formyear
    order by formyear;
    select formyear, count(distinct cats(put(sizegrp,best.),put(bmgrp,best.))) as active_portfolios,
           count(*) as portfolio_months, min(issues) as min_issues, max(issues) as max_issues
    from work.port_ret0
    group by formyear
    order by formyear;
quit;

/* Expand each R&D sample firm-year into the 12 monthly return observations.
   formyear identifies the June 30 cutoff set whose July–June portfolio
   returns apply; it is also the preceding-June cutoff year for each month. */
data work.window0;
    set work.sample_vars;
    if month(startmonth)>=7 then initial_formyear=year(startmonth);
    else initial_formyear=year(startmonth)-1;
    do month_offset=5 to 16;
        monthkey=intnx("month",datadate,month_offset,"beginning");
        if month(monthkey)>=7 then formyear=year(monthkey);
        else formyear=year(monthkey)-1;
        output;
    end;
    format monthkey date9.;
run;

/* Match targets separately from the benchmark constituents. At the initial
   investment date, use current MVE4 and the sample-year adjusted book value
   against the preceding June cutoffs. If the return window extends beyond a
   subsequent June 30, refresh the target match with June market equity and
   the latest annual statement whose assumed four-month availability date has
   arrived by June 30. */
proc sql;
    create table work.target_initial_key as
    select distinct gvkey, fyear, initial_formyear
    from work.window0;
    create table work.target_update_candidate0 as
    select w.gvkey, w.fyear, w.formyear, d.dlstdt
    from work.window0 as w
    inner join work.sample_vars as s
      on w.gvkey=s.gvkey and w.fyear=s.fyear
    left join work.delist_month as d
      on s.ret_permno=d.permno and d.dlmonth>=s.startmonth and d.dlmonth<=s.endmonth
    where w.formyear>initial_formyear;
    create table work.target_update_candidate as
    select gvkey, fyear, formyear,
           min(dlstdt) as first_dl_date format=date9.
    from work.target_update_candidate0
    group by gvkey, fyear, formyear;
    create table work.target_update_key0 as
    select gvkey, fyear, formyear, first_dl_date
    from work.target_update_candidate
    where missing(first_dl_date) or first_dl_date>mdy(6,30,formyear);
quit;

data work.target_update_key;
    set work.target_update_key0;
    update_date=mdy(6,30,formyear);
    update_month=intnx("month",update_date,0,"beginning");
    format update_date update_month date9.;
run;

proc sql;
    create table work.target_initial0 as
    select k.gvkey, k.fyear, k.initial_formyear as formyear,
           "INITIAL" as assignment_type length=7,
           s.startmonth as assignment_date format=date9.,
           s.datadate as target_acct_date format=date9.,
           s.startmonth as available_date format=date9.,
           s.fyear as target_acct_fyear,
           s.full_year as target_acct_full,
           s.mve4month as target_me_month format=date9.,
           s.mve4_date as target_me_date format=date9.,
           s.permco_mve4 as target_permco,
           s.nco_mve4 as target_link_count,
           s.mve4 as target_size,
           s.ceq_usd+s.txditc_usd+s.rdasset as target_book,
           (s.ceq_usd+s.txditc_usd+s.rdasset)/s.mve4 as target_bm,
           c.formyear as cutoff_formyear,
           c.sz_q20, c.sz_q40, c.sz_q60, c.sz_q80,
           c.bm_q20, c.bm_q40, c.bm_q60, c.bm_q80
    from work.target_initial_key as k
    inner join work.sample_vars as s
      on k.gvkey=s.gvkey and k.fyear=s.fyear
    left join work.cutoffs as c
      on k.initial_formyear=c.formyear;

    create table work.target_update_link0 as
    select k.gvkey, k.fyear, k.formyear, k.update_date, k.update_month,
           count(distinct l.lpermco) as target_link_count,
           min(l.lpermco) as target_permco
    from work.target_update_key as k
    left join work.links as l
      on k.gvkey=l.gvkey
     and (l.linkdt=.B or (not missing(l.linkdt) and l.linkdt<=k.update_date))
     and (l.linkenddt=.E or (not missing(l.linkenddt) and l.linkenddt>=k.update_date))
    group by k.gvkey, k.fyear, k.formyear, k.update_date, k.update_month;

    create table work.target_update_acct0 as
    select k.gvkey, k.fyear, k.formyear, k.update_date,
           h.datadate as target_acct_date format=date9.,
           intnx("month",h.datadate,5,"beginning") as available_date format=date9.,
           h.fyear as target_acct_fyear,
           h.full_year as target_acct_full,
           h.ceq_usd, h.txditc_usd, h.rdasset
    from work.target_update_key as k
    inner join work.fund_hist as h
      on k.gvkey=h.gvkey
    where calculated available_date<=k.update_date;
quit;

proc sort data=work.target_update_acct0 out=work.target_update_acct_sort;
    by gvkey fyear formyear descending available_date descending target_acct_date
       descending target_acct_full descending target_acct_fyear;
run;

data work.target_update_acct;
    set work.target_update_acct_sort;
    by gvkey fyear formyear;
    if first.formyear;
    target_book=ceq_usd+txditc_usd+rdasset;
run;

proc sql;
    create table work.target_update0 as
    select k.gvkey, k.fyear, k.formyear,
           "JUNE" as assignment_type length=7,
           k.update_date as assignment_date format=date9.,
           a.target_acct_date,
           a.available_date,
           a.target_acct_fyear,
           a.target_acct_full,
           k.update_month as target_me_month format=date9.,
           m.last_trade_date as target_me_date format=date9.,
           l.target_permco,
           l.target_link_count,
           m.me_co as target_size,
           a.target_book,
           a.target_book/m.me_co as target_bm,
           c.formyear as cutoff_formyear,
           c.sz_q20, c.sz_q40, c.sz_q60, c.sz_q80,
           c.bm_q20, c.bm_q40, c.bm_q60, c.bm_q80
    from work.target_update_key as k
    left join work.target_update_link0 as l
      on k.gvkey=l.gvkey and k.fyear=l.fyear and k.formyear=l.formyear
    left join work.target_update_acct as a
      on k.gvkey=a.gvkey and k.fyear=a.fyear and k.formyear=a.formyear
    left join work.company_me as m
      on l.target_permco=m.permco and k.update_month=m.monthkey
    left join work.cutoffs as c
      on k.formyear=c.formyear;

quit;

data work.target_assignment0;
    set work.target_initial0 work.target_update0;
    length reason $34;
    sizegrp=.; bmgrp=.;
    if missing(cutoff_formyear) then reason="NO_JUNE_CUTOFFS";
    else if nmiss(sz_q20,sz_q40,sz_q60,sz_q80,
                  bm_q20,bm_q40,bm_q60,bm_q80)>0 then reason="INCOMPLETE_JUNE_CUTOFFS";
    else if target_link_count ne 1 then reason="NO_UNIQUE_TARGET_LINK";
    else if missing(target_acct_date) or missing(target_book) then reason="NO_ASOF_ADJUSTED_BOOK";
    else if missing(target_size) or target_size<=0 then reason="NO_CURRENT_MARKET_EQUITY";
    else if missing(target_bm) then reason="NO_CURRENT_BOOK_MARKET";
    else do;
        if target_size<=sz_q20 then sizegrp=1;
        else if target_size<=sz_q40 then sizegrp=2;
        else if target_size<=sz_q60 then sizegrp=3;
        else if target_size<=sz_q80 then sizegrp=4;
        else sizegrp=5;
        if target_bm<=bm_q20 then bmgrp=1;
        else if target_bm<=bm_q40 then bmgrp=2;
        else if target_bm<=bm_q60 then bmgrp=3;
        else if target_bm<=bm_q80 then bmgrp=4;
        else bmgrp=5;
        if missing(sizegrp) or missing(bmgrp) then reason="INCOMPLETE_TARGET_GROUP";
        else reason="ASSIGNED";
    end;
    drop sz_q20 sz_q40 sz_q60 sz_q80 bm_q20 bm_q40 bm_q60 bm_q80;
run;

proc sort data=work.target_assignment0 out=work.target_assignment;
    by gvkey fyear formyear;
run;

proc sql;
    create table work.target_assignment_summary as
    select i.gvkey, i.fyear,
           i.formyear as target_init_cutoff,
           i.assignment_date as target_init_date format=date9.,
           i.target_acct_date as target_init_acct_date format=date9.,
           i.available_date as target_init_avail_date format=date9.,
           i.target_me_date as target_init_me_date format=date9.,
           i.target_size as target_init_size,
           i.target_book as target_init_book,
           i.target_bm as target_init_bm,
           i.sizegrp as target_init_sizegrp,
           i.bmgrp as target_init_bmgrp,
           i.reason as target_init_reason,
           u.formyear as target_update_formyear,
           u.assignment_date as target_update_date format=date9.,
           u.target_acct_date as target_update_acct_date format=date9.,
           u.available_date as target_update_avail_date format=date9.,
           u.target_me_date as target_update_me_date format=date9.,
           u.target_size as target_update_size,
           u.target_book as target_update_book,
           u.target_bm as target_update_bm,
           u.sizegrp as target_update_sizegrp,
           u.bmgrp as target_update_bmgrp,
           u.reason as target_update_reason
    from work.target_assignment as i
    left join work.target_assignment as u
      on i.gvkey=u.gvkey and i.fyear=u.fyear and u.assignment_type="JUNE"
    where i.assignment_type="INITIAL";
    title "Target investment-date and June reassignment support";
    select assignment_type, formyear, count(*) as assignments,
           sum(reason="ASSIGNED") as assigned,
           min(target_acct_date) as first_account_date format=date9.,
           max(target_acct_date) as last_account_date format=date9.,
           min(available_date) as first_assumed_available format=date9.,
           max(available_date) as last_assumed_available format=date9.,
           min(target_me_date) as first_market_date format=date9.,
           max(target_me_date) as last_market_date format=date9.,
           min(cutoff_formyear) as first_cutoff_year,
           max(cutoff_formyear) as last_cutoff_year
    from work.target_assignment
    group by assignment_type, formyear
    order by assignment_type, formyear;
    select assignment_type, reason, count(*) as assignments
    from work.target_assignment
    where reason ne "ASSIGNED"
    group by assignment_type, reason
    order by assignment_type, reason;
    title "Target June updates suppressed after delisting";
    select formyear, count(*) as candidate_updates,
           sum(not missing(first_dl_date) and first_dl_date<=mdy(6,30,formyear)) as delisted_by_update,
           sum(missing(first_dl_date) or first_dl_date>mdy(6,30,formyear)) as active_at_update
    from work.target_update_candidate
    group by formyear
    order by formyear;
quit;

proc sql;
    create table work.dl_window0 as
    select a.gvkey, a.fyear, count(distinct d.dlmonth) as dl_months,
           min(d.dlmonth) as candidate_dlmonth format=date9.
    from work.sample_vars as a
    left join work.delist_month as d
      on a.ret_permno=d.permno and d.dlmonth>=a.startmonth and d.dlmonth<=a.endmonth
    group by a.gvkey, a.fyear;
quit;

data work.dl_window;
    set work.dl_window0;
    dlmonth=.;
    if dl_months=1 then dlmonth=candidate_dlmonth;
    dl_ambiguous=(dl_months>1);
    dl_formyear=.;
    if dl_ambiguous=0 and not missing(dlmonth) then do;
        if month(dlmonth)>=7 then dl_formyear=year(dlmonth);
        else dl_formyear=year(dlmonth)-1;
    end;
    keep gvkey fyear dlmonth dl_ambiguous dl_formyear;
run;

proc sql;
    create table work.dl_group_year as
    select d.gvkey, d.fyear, max(a.formyear) as last_formyear
    from work.dl_window as d
    left join work.target_assignment as a
      on d.gvkey=a.gvkey and a.formyear<=d.dl_formyear
     and a.fyear=d.fyear and a.reason="ASSIGNED"
    where d.dl_ambiguous=0 and not missing(d.dlmonth)
    group by d.gvkey, d.fyear;
    create table work.dl_group as
    select y.gvkey, y.fyear, y.last_formyear,
           a.sizegrp, a.bmgrp
    from work.dl_group_year as y
    left join work.target_assignment as a
      on y.gvkey=a.gvkey and y.fyear=a.fyear and y.last_formyear=a.formyear
     and a.reason="ASSIGNED";
    create table work.window1 as
    select w.*, s.ret_adj, s.me_sec,
           d.dlmonth, d.dl_ambiguous,
           case when d.dl_ambiguous=0 and not missing(d.dlmonth) and
                          w.monthkey>d.dlmonth then g.sizegrp
                else a.sizegrp end as sizegrp,
           case when d.dl_ambiguous=0 and not missing(d.dlmonth) and
                          w.monthkey>d.dlmonth then g.bmgrp
                else a.bmgrp end as bmgrp,
           case when d.dl_ambiguous=0 and not missing(d.dlmonth) and
                          w.monthkey>d.dlmonth then pg.portret
                else p.portret end as portret
    from work.window0 as w
    left join work.stock_full as s
      on w.ret_permno=s.permno and w.monthkey=s.monthkey
    left join work.dl_window as d
      on w.gvkey=d.gvkey and w.fyear=d.fyear
    left join work.target_assignment as a
      on w.gvkey=a.gvkey and w.fyear=a.fyear and w.formyear=a.formyear
    left join work.port_ret0 as p
      on a.formyear=p.formyear and a.sizegrp=p.sizegrp and a.bmgrp=p.bmgrp
     and w.monthkey=p.monthkey
    left join work.dl_group as g
      on w.gvkey=g.gvkey and w.fyear=g.fyear
    left join work.port_ret0 as pg
      on w.formyear=pg.formyear and g.sizegrp=pg.sizegrp and g.bmgrp=pg.bmgrp
     and w.monthkey=pg.monthkey;
quit;

data work.window3;
    set work.window1;
    use_ret=.;
    if dl_ambiguous=0 and not missing(dlmonth) and monthkey>dlmonth then use_ret=portret;
    else use_ret=ret_adj;
    actual_return=(not missing(ret_adj));
    post_delist=(dl_ambiguous=0 and not missing(dlmonth) and monthkey>dlmonth);
    group_missing=(missing(sizegrp) or missing(bmgrp));
    benchmark_missing=missing(portret);
run;

proc sql;
    title "Monthly return support by formation year after date and delist repairs";
    select formyear,
           count(*) as window_months,
           sum(group_missing=1) as months_without_group,
           sum(benchmark_missing=1) as months_without_portfolio_return,
           sum(post_delist=1) as post_delist_months,
           sum(post_delist=1 and group_missing=1) as post_delist_months_without_group,
           sum(post_delist=1 and benchmark_missing=1) as postdl_no_portret
    from work.window3
    group by formyear
    order by formyear;
quit;

proc sort data=work.window3 out=work.window_sort;
    by gvkey fyear monthkey;
run;

data work.xret;
    set work.window_sort;
    by gvkey fyear;
    retain gross_firm gross_port n_months n_actual n_groupmiss n_benchmiss
           missing_firm missing_port;
    if first.fyear then do;
        gross_firm=1; gross_port=1; n_months=0; n_actual=0;
        n_groupmiss=0; n_benchmiss=0; missing_firm=0; missing_port=0;
    end;
    n_months+1;
    if actual_return then n_actual+1;
    if group_missing then n_groupmiss+1;
    if benchmark_missing then n_benchmiss+1;
    if not missing(use_ret) then gross_firm=gross_firm*(1+use_ret);
    else missing_firm=1;
    if not missing(portret) then gross_port=gross_port*(1+portret);
    else missing_port=1;
    if last.fyear then do;
        xret=.;
        if n_months=12 and missing_firm=0 and missing_port=0 then xret=gross_firm-gross_port;
        output;
    end;
    keep gvkey fyear xret n_months n_actual n_groupmiss n_benchmiss
         missing_firm missing_port dlmonth dl_ambiguous;
run;

proc sql;
    title "Sample and actual model support";
    select count(*) as RND_years_with_some_returns,
           sum(not missing(xret)) as complete_XRET_windows,
           sum(dl_ambiguous=1) as ambiguous_delist_windows,
           sum(missing_port=1) as winmissbm,
           sum(n_groupmiss>0) as win_no_assign,
           sum(n_benchmiss>0) as win_no_portret
    from work.xret;
quit;

/* Apply source main-sample eligibility before annual independent ranks. */
proc sql;
    create table work.sample0 as
    select a.*, x.xret, x.n_months, x.n_actual, x.n_groupmiss, x.n_benchmiss,
           x.missing_firm, x.missing_port, x.dlmonth, x.dl_ambiguous,
           t.target_init_cutoff, t.target_init_date, t.target_init_acct_date,
           t.target_init_avail_date, t.target_init_me_date, t.target_init_size,
           t.target_init_book, t.target_init_bm, t.target_init_sizegrp,
           t.target_init_bmgrp, t.target_init_reason,
           t.target_update_formyear, t.target_update_date,
           t.target_update_acct_date, t.target_update_avail_date,
           t.target_update_me_date, t.target_update_size, t.target_update_book,
           t.target_update_bm, t.target_update_sizegrp, t.target_update_bmgrp,
           t.target_update_reason
    from work.sample_vars as a
    inner join work.xret as x
      on a.gvkey=x.gvkey and a.fyear=x.fyear
    left join work.target_assignment_summary as t
      on a.gvkey=t.gvkey and a.fyear=t.fyear
    where x.n_actual>=1;
quit;

proc sql;
    title 'R&D sample counts by fiscal year';
    select fyear, count(*) as rd_firm_years,
           sum(not missing(delta_rda)) as delta_rda_available,
           sum(not missing(rda)) as rda_available,
           sum(not missing(arnoa)) as arnoa_available,
           sum(not missing(xret)) as xret_available
    from work.sample0
    group by fyear
    order by fyear;
quit;

/* The three ranks are estimated independently within year before imposing
   Eq. (1)'s joint complete-case regression sample. */
data work.rank_in;
    set work.sample0;
    neg_delta=-delta_rda;
run;

proc sort data=work.rank_in out=work.rank_sort;
    by fyear;
run;

proc rank data=work.rank_sort out=work.rank_out groups=5 ties=low;
    by fyear;
    var neg_delta rda arnoa;
    ranks r_delta r_rda r_arnoa;
run;

data out.rd_main;
    set work.rank_out;
    gdelta=r_delta/4;
    grda=r_rda/4;
    garnoa=r_arnoa/4;
    label xret="First-year excess return"
          gdelta='Descending annual rank of change in R&D assets'
          grda='Ascending annual rank of R&D assets'
          garnoa="Ascending annual rank of adjusted return on net operating assets"
          delta_rda='Change in R&D assets scaled by NOA at t+1'
          rda='R&D assets divided by market equity at end of month four'
          arnoa="Adjusted earnings divided by adjusted NOA at t+1";
    keep gvkey fyear datadate curcd cur_used_l1 cur_used_l2 cur_used_l3
         cur_used_l4 cur_used_l5 xrd_missing
         xrd_usd xrd_usd_next
         fy_used_l1 fy_used_l2 fy_used_l3 fy_used_l4 fy_used_l5
         xrd_usd_used_l1 xrd_usd_used_l2 xrd_usd_used_l3
         xrd_usd_used_l4 xrd_usd_used_l5
         ib_usd ib_usd_next
         fx_flow_month fx_flow_factor fx_flow_gbp_to_report fx_flow_gbp_to_usd
         fx_flow_month_next fx_flow_factor_next
         fx_flow_gbp_to_report_next fx_flow_gbp_to_usd_next
         fx_flow_month_used_l1 fx_flow_month_used_l2 fx_flow_month_used_l3
         fx_flow_month_used_l4 fx_flow_month_used_l5
         fx_flow_factor_used_l1 fx_flow_factor_used_l2 fx_flow_factor_used_l3
         fx_flow_factor_used_l4 fx_flow_factor_used_l5
         fx_daily_quote_date fx_daily_age fx_daily_factor fx_daily_report_rate fx_daily_usd_rate
         fx_daily_report_type_min fx_daily_report_type_max fx_daily_report_type_count
         fx_daily_usd_type_min fx_daily_usd_type_max fx_daily_usd_type_count
         fx_daily_quote_date_next fx_daily_age_next fx_daily_factor_next
         fx_daily_report_rate_next fx_daily_usd_rate_next
         fx_daily_report_type_min_next fx_daily_report_type_max_next fx_daily_report_type_count_next
         fx_daily_usd_type_min_next fx_daily_usd_type_max_next fx_daily_usd_type_count_next
         rdasset rdasset_next rdamort
         noa noa_next adj_noa adj_noa_next adj_earn adj_earn_next
         delta_rda rda arnoa xret gdelta grda garnoa
         n_months n_actual n_groupmiss n_benchmiss
         missing_firm missing_port dlmonth dl_ambiguous
         mve_fye mve4 mve4_date
         target_init_cutoff target_init_date target_init_acct_date
         target_init_avail_date target_init_me_date target_init_size
         target_init_book target_init_bm target_init_sizegrp target_init_bmgrp
         target_init_reason target_update_formyear target_update_date
         target_update_acct_date target_update_avail_date target_update_me_date
         target_update_size target_update_book target_update_bm
         target_update_sizegrp target_update_bmgrp target_update_reason;
run;

proc sql;
    title "Final SAS handoff";
    select count(*) as handed_rows,
           count(distinct gvkey) as firms,
           sum(not missing(xret) and not missing(gdelta) and
               not missing(grda) and not missing(garnoa)) as Eq1_complete_cases,
           min(fyear) as first_fyear,
           max(fyear) as last_fyear
    from out.rd_main;
quit;

proc means data=out.rd_main n mean std p25 median p75 min max;
    var xret delta_rda rda arnoa gdelta grda garnoa;
run;

title;
