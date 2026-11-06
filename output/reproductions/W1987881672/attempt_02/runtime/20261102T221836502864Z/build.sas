options errorabend mprint notes;
libname ibes "/storage/sas/base/ibes" access=readonly;
libname out "data/ibes_surprises";

/* Restrict by catalog-listed measure, region, quarter indicators, and period. */
data work.cand;
    set ibes.det_epsus(keep=TICKER CUSIP FPEDATS USFIRM MEASURE FPI PDF VALUE ACTUAL CURR CURR_ACT CURRFL report_curr ANNDATS ANNTIMS REVDATS REVTIMS ACTDATS ACTDATS_ACT ANNDATS_ACT ANNTIMS_ACT ESTIMATOR ANALYS);
    if USFIRM=1 and MEASURE='EPS' and FPI in ('6','7','8','9','N','O','P','Q','Y')
       and FPEDATS >= '01JAN1984'd and FPEDATS < '01JAN2000'd;
    fiscal_year=year(FPEDATS);
run;

/* Field availability, event-date bounds, same-day and post-report forecasts. */
proc sql;
    title 'Candidate-detail coverage and date diagnostics';
    select count(*) as candidate_rows,
           sum(not missing(TICKER)) as rows_with_ticker,
           sum(not missing(FPEDATS)) as rows_with_fpedats,
           sum(not missing(ACTUAL)) as rows_with_actual,
           sum(not missing(ANNDATS_ACT)) as rows_with_report_date,
           sum(not missing(VALUE)) as rows_with_forecast_value,
           sum(not missing(ANNDATS)) as rows_with_forecast_date,
           sum(ANNDATS < ANNDATS_ACT) as strict_pre_report_rows,
           sum(ANNDATS = ANNDATS_ACT) as same_date_rows,
           sum(ANNDATS > ANNDATS_ACT) as after_report_rows,
           min(FPEDATS) as min_fpedats format=date9.,
           max(FPEDATS) as max_fpedats format=date9.,
           min(ANNDATS_ACT) as min_report_date format=date9.,
           max(ANNDATS_ACT) as max_report_date format=date9.
      from work.cand;
quit;

proc freq data=work.cand;
    tables FPI CURRFL CURR CURR_ACT report_curr / missing;
    title 'Quarter indicators and currency fields in candidate rows';
run;

/* Keep rows meeting Brown's stated date and availability requirements. */
data work.eligible;
    set work.cand;
    if not missing(TICKER) and not missing(FPEDATS) and not missing(ACTUAL)
       and not missing(ANNDATS_ACT) and not missing(VALUE) and not missing(ANNDATS)
       and ANNDATS < ANNDATS_ACT;
    if missing(ANNTIMS) then forecast_time=0;
    else forecast_time=ANNTIMS;
    format forecast_time time8.;
    if not missing(REVDATS) then review_after_announce_days=REVDATS-ANNDATS;
    if not missing(REVDATS) then review_to_report_days=REVDATS-ANNDATS_ACT;
    surprise_cents=(ACTUAL-VALUE)*100;
run;

/* Verify event key stability before selecting one estimate per firm-quarter. */
proc sql;
    create table work.keyaudit as
    select TICKER, FPEDATS,
           count(distinct ANNDATS_ACT) as report_dates,
           count(distinct ACTUAL) as actual_values,
           count(distinct report_curr) as report_currencies,
           count(*) as eligible_rows
      from work.eligible
     group by TICKER, FPEDATS;
    title 'Eligible observation key diagnostics';
    select count(*) as eligible_firm_quarters,
           sum(report_dates>1) as multi_report_quarters,
           sum(actual_values>1) as multi_actual_quarters,
           sum(report_currencies>1) as multi_currency_quarters,
           sum(eligible_rows>1) as quarters_with_multiple_forecasts
      from work.keyaudit;
quit;

/* Count ties at the latest forecast announce date/time before deterministic tie-breaks. */
proc sql;
    create table work.latestdt as
    select TICKER, FPEDATS, ANNDATS_ACT,
           max(ANNDATS) as latest_date
      from work.eligible
     group by TICKER, FPEDATS, ANNDATS_ACT;
    create table work.latesttm as
    select l.TICKER, l.FPEDATS, l.ANNDATS_ACT, l.latest_date,
           max(e.forecast_time) as latest_time
      from work.latestdt as l inner join work.eligible as e
        on l.TICKER=e.TICKER and l.FPEDATS=e.FPEDATS
       and l.ANNDATS_ACT=e.ANNDATS_ACT and l.latest_date=e.ANNDATS
     group by l.TICKER, l.FPEDATS, l.ANNDATS_ACT, l.latest_date;
    create table work.tiesaudit as
    select e.TICKER, e.FPEDATS, e.ANNDATS_ACT, count(*) as tied_latest_rows
      from work.latesttm as l inner join work.eligible as e
        on l.TICKER=e.TICKER and l.FPEDATS=e.FPEDATS
       and l.ANNDATS_ACT=e.ANNDATS_ACT and l.latest_date=e.ANNDATS
       and l.latest_time=e.forecast_time
     group by e.TICKER, e.FPEDATS, e.ANNDATS_ACT;
    title 'Latest forecast tie diagnostics';
    select count(*) as report_events,
           sum(tied_latest_rows>1) as events_tied_at_latest_datetime,
           max(tied_latest_rows) as largest_latest_tie
      from work.tiesaudit;
quit;

/* One individual forecast per actual event; ties use ascending analyst, estimator, value. */
proc sort data=work.eligible out=work.sorted;
    by TICKER FPEDATS ANNDATS_ACT descending ANNDATS descending forecast_time ANALYS ESTIMATOR VALUE;
run;
data work.selected;
    set work.sorted;
    by TICKER FPEDATS ANNDATS_ACT;
    if first.ANNDATS_ACT;
    fiscal_year=year(FPEDATS);
    label surprise_cents='Earnings surprise (cents/share)'
          fiscal_year='Fiscal year from FPEDATS';
run;

/* Check the actuals-file denomination against the report-currency denomination. */
proc sql;
    title 'Selected-row currency and unit compatibility';
    select count(*) as selected_events,
           sum(upcase(strip(report_curr))='USD') as stored_usd_events,
           sum(upcase(strip(report_curr))='CAD') as stored_cad_events,
           sum(missing(report_curr)) as missing_stored_currency,
           sum(upcase(strip(report_curr))='USD' and upcase(strip(CURR_ACT))='USD') as usd_actual_usd_report,
           sum(upcase(strip(report_curr))='USD' and upcase(strip(CURR_ACT))='CAD') as usd_actual_cad_report,
           sum(not missing(report_curr) and upcase(strip(report_curr)) not in ('USD','CAD')) as other_stored_currency
      from work.selected;
quit;
data work.usd_selected;
    set work.selected;
    /* CURRFL identifies the currency received by the analyst, not stored VALUE.
       Require both stored VALUE/report currency and actual-file currency to be USD. */
    if upcase(strip(report_curr))='USD' and upcase(strip(CURR_ACT))='USD';
    forecast_age_days=ANNDATS_ACT-ANNDATS;
    report_period_gap_days=ANNDATS_ACT-FPEDATS;
    if not missing(ACTDATS_ACT) then report_activation_gap=ANNDATS_ACT-ACTDATS_ACT;
run;
proc freq data=work.selected;
    tables CURRFL*report_curr CURR_ACT*report_curr / missing;
    title 'Stored report currency versus received currency fields at selected rows';
run;
proc freq data=work.selected;
    tables PDF / missing;
    title 'Estimate-level primary/diluted flag (descriptive only)';
run;
proc freq data=work.selected;
    tables CURRFL*CURR_ACT / missing;
    title 'Received estimate flag versus actual-file currency';
run;
proc freq data=work.usd_selected;
    tables FPI CURRFL CURR_ACT report_curr / missing;
    title 'Currency and quarterly-period fields in common-USD sample';
run;
proc means data=work.usd_selected n nmiss min p1 p25 median p75 p99 max maxdec=5;
    var ACTUAL VALUE surprise_cents forecast_age_days report_period_gap_days report_activation_gap
        review_after_announce_days review_to_report_days;
    title 'Common-USD units, report/period alignment, forecast age, and review-date diagnostics';
run;
proc means data=work.usd_selected n min p25 median p75 p99 max maxdec=2;
    class FPI;
    var forecast_age_days report_period_gap_days;
    title 'Forecast age and report-to-period alignment by quarterly FPI';
run;
proc sql;
    title 'Date-alignment counts (diagnostic only; no date cutoff applied)';
    select count(*) as common_usd_events,
           sum(report_period_gap_days<0) as report_before_period_end,
           sum(report_period_gap_days>365) as report_over_1y_after_period_end,
           sum(report_period_gap_days>1825) as report_over_5y_after_period_end,
           sum(forecast_age_days>365) as forecast_over_1y_old,
           sum(forecast_age_days>1825) as forecast_over_5y_old,
           sum(missing(ACTDATS_ACT)) as missing_activation_date,
           sum(ANNDATS_ACT<ACTDATS_ACT) as announce_before_activation,
           sum(ANNDATS_ACT=ACTDATS_ACT) as announce_equals_activation,
           sum(missing(REVDATS)) as missing_review_date,
           sum(REVDATS>ANNDATS) as review_after_announce,
           sum(REVDATS>ANNDATS_ACT) as review_date_after_actual_report
      from work.usd_selected;
    select fiscal_year,
           count(*) as n_events,
           sum(report_period_gap_days<0) as report_before_period_end,
           sum(report_period_gap_days>365) as report_over_1y_after_period_end,
           sum(forecast_age_days>365) as forecast_over_1y_old,
           max(report_period_gap_days) as max_report_period_gap,
           max(forecast_age_days) as max_forecast_age
      from work.usd_selected
     group by fiscal_year
     order by fiscal_year;
quit;
proc sql;
    title 'Common-USD selected observations by FPEDATS calendar year';
    select fiscal_year, count(*) as n_events,
           sum(ACTUAL>0) as n_profit,
           sum(ACTUAL<0) as n_loss,
           sum(ACTUAL=0) as n_zero_actual,
           min(report_period_gap_days) as min_report_period_gap,
           max(report_period_gap_days) as max_report_period_gap,
           max(forecast_age_days) as max_forecast_age
      from work.usd_selected
     group by fiscal_year
     order by fiscal_year;
quit;

/* Boundary audit: tolerance handles only double representation, not EPS rounding. */
data work.boundary;
    input actual value exp_small exp_extreme exp_zero;
    surprise_cents=(actual-value)*100;
    small_boundary=(surprise_cents>0 and surprise_cents<=3+1e-10);
    extreme_boundary=(surprise_cents<0 and surprise_cents<=-25+1e-10);
    exact_zero=(surprise_cents=0);
    if small_boundary ne exp_small or extreme_boundary ne exp_extreme or exact_zero ne exp_zero then boundary_fail=1;
    else boundary_fail=0;
    datalines;
    0.13 0.10 1 0 0
   -0.10 0.15 0 1 0
    0.1301 0.10 0 0 0
   -0.10 0.1499 0 0 0
    0.15 0.15 0 0 1
    ;
run;
proc sql;
    title 'Exact-boundary arithmetic check';
    select count(*) as boundary_cases,
           sum(boundary_fail) as failed_boundary_cases
      from work.boundary;
quit;

/* Three annual medians, formed on each outcome's source-defined population. */
proc means data=work.usd_selected nway median noprint;
    class fiscal_year;
    var surprise_cents;
    output out=work.med_all(drop=_TYPE_ _FREQ_) median=med_all;
run;
proc means data=work.usd_selected(where=(ACTUAL>0)) nway median noprint;
    class fiscal_year;
    var surprise_cents;
    output out=work.med_profit(drop=_TYPE_ _FREQ_) median=med_profit;
run;
proc means data=work.usd_selected(where=(ACTUAL<0)) nway median noprint;
    class fiscal_year;
    var surprise_cents;
    output out=work.med_loss(drop=_TYPE_ _FREQ_) median=med_loss;
run;

/* Frequencies use the source-defined sign populations and conditional denominators. */
proc sql;
    create table work.annual_freq as
    select fiscal_year,
           count(*) as n_all,
           sum(ACTUAL>0) as n_profit,
           sum(ACTUAL<0) as n_loss,
           sum(ACTUAL=0) as n_zero_actual,
           case when sum(ACTUAL>0)>0 then 100*sum(ACTUAL>0 and surprise_cents=0)/sum(ACTUAL>0) else . end as pct_zero_profit,
           case when sum(ACTUAL<0)>0 then 100*sum(ACTUAL<0 and surprise_cents=0)/sum(ACTUAL<0) else . end as pct_zero_loss,
           case when sum(ACTUAL>0)>0 then 100*sum(ACTUAL>0 and surprise_cents>0)/sum(ACTUAL>0) else . end as pct_positive_profit,
           case when sum(ACTUAL<0)>0 then 100*sum(ACTUAL<0 and surprise_cents>0)/sum(ACTUAL<0) else . end as pct_positive_loss,
           case when sum(ACTUAL>0 and surprise_cents>0)>0 then 100*sum(ACTUAL>0 and surprise_cents>0 and surprise_cents<=3+1e-10)/sum(ACTUAL>0 and surprise_cents>0) else . end as pct_small_positive_profit,
           case when sum(ACTUAL<0 and surprise_cents<0)>0 then 100*sum(ACTUAL<0 and surprise_cents<0 and surprise_cents<=-25+1e-10)/sum(ACTUAL<0 and surprise_cents<0) else . end as pct_extreme_negative_loss
      from work.usd_selected
     group by fiscal_year;
quit;

data work.yeargrid;
    do fiscal_year=1984 to 1999;
        output;
    end;
run;
proc sort data=work.yeargrid; by fiscal_year; run;
proc sort data=work.med_all; by fiscal_year; run;
proc sort data=work.med_profit; by fiscal_year; run;
proc sort data=work.med_loss; by fiscal_year; run;
proc sort data=work.annual_freq; by fiscal_year; run;
data out.ibes_surprises;
    merge work.yeargrid(in=yearrow) work.annual_freq work.med_all work.med_profit work.med_loss;
    by fiscal_year;
    if yearrow;
    label fiscal_year='Fiscal year'
          n_all='Quarterly firm observations'
          med_all='Median earnings surprise (cents/share)'
          med_profit='Median profit surprise (cents/share)'
          med_loss='Median loss surprise (cents/share)'
          pct_zero_profit='Zero surprise among profits (percent)'
          pct_zero_loss='Zero surprise among losses (percent)'
          pct_positive_profit='Positive surprise among profits (percent)'
          pct_positive_loss='Positive surprise among losses (percent)'
          pct_small_positive_profit='Small positive profit surprise | positive surprise (percent)'
          pct_extreme_negative_loss='Extreme negative loss surprise | negative surprise (percent)';
run;

proc means data=out.ibes_surprises n nmiss min median max maxdec=4;
    var n_all med_all med_profit med_loss pct_zero_profit pct_zero_loss
        pct_positive_profit pct_positive_loss pct_small_positive_profit pct_extreme_negative_loss;
    title 'Final 16-year annual handoff checks';
run;
proc print data=out.ibes_surprises noobs;
    var fiscal_year n_all n_profit n_loss n_zero_actual med_all med_profit med_loss
        pct_zero_profit pct_zero_loss pct_positive_profit pct_positive_loss
        pct_small_positive_profit pct_extreme_negative_loss;
    title 'Annual analysis sample summary';
run;
