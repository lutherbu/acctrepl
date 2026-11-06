options errorabend;

libname src "/storage/sas/base/comp/d_na" access=readonly;
libname out "data";

data work.candidate;
    set src.funda(keep=gvkey datadate fyear indfmt consol popsrc datafmt sich xsga sale curcd currtr
        where=(fyear >= 1978 and fyear <= 1998 and upcase(strip(indfmt)) = "INDL"));
run;

title "COMP.FUNDA candidate population: industrial annual rows, 1978-1998";
proc freq data=work.candidate;
    tables datafmt*consol*popsrc / list missing;
run;

data work.annual;
    set work.candidate;
    where upcase(strip(consol)) = "C" and upcase(strip(datafmt)) = "STD"
        and upcase(strip(popsrc)) = "D";
    curcd = upcase(strip(curcd));
run;

title "Filtered COMP.FUNDA coverage and key checks";
proc means data=work.annual n mean min max;
    class curcd;
    var currtr;
run;
proc sql;
    select count(*) as SourceRows, count(distinct gvkey) as Firms,
           min(fyear) as FirstFiscalYear, max(fyear) as LastFiscalYear,
           sum(missing(xsga)) as MissingSGA, sum(missing(sale)) as MissingSales,
           sum(missing(curcd)) as MissingCurrency, sum(missing(currtr)) as MissingCURRTR
    from work.annual;
    select fyear, count(*) as Rows
    from work.annual
    group by fyear
    order by fyear;
    create table work.duplicate_detail as
    select gvkey, fyear, count(*) as n, count(distinct datadate) as distinct_dates
    from work.annual
    group by gvkey, fyear;
    select count(*) as DuplicateGVKEYFiscalYearKeys,
           sum(n - 1) as ExcessRowsFromDuplicates,
           sum(distinct_dates = 1) as KeysDuplicatedAtTheSameDate,
           sum(distinct_dates > 1) as MultipleDateKeys
    from work.duplicate_detail
    where n > 1;
quit;

proc sql noprint;
    select count(*) into :same_date_duplicates trimmed
    from work.duplicate_detail
    where n > 1 and distinct_dates = 1;
quit;
data _null_;
    if &same_date_duplicates > 0 then do;
        put "ERROR: Duplicate gvkey-fyear-datadate keys remain after the selected population filters.";
        abort abend;
    end;
run;

proc sort data=work.annual out=work.annual_sorted;
    by gvkey fyear datadate;
run;
data work.annual_selected;
    set work.annual_sorted;
    by gvkey fyear;
    if last.fyear;
run;

title "Unique firm-fiscal-year rows after latest-datadate rule";
proc sql;
    select count(*) as SelectedRows, count(distinct gvkey) as Firms,
           min(fyear) as FirstFiscalYear, max(fyear) as LastFiscalYear,
           sum(missing(curcd)) as MissingCurrency, sum(missing(currtr)) as MissingCURRTR
    from work.annual_selected;
quit;

proc sql;
    create table work.pairs as
    select a.gvkey, a.fyear, a.datadate, a.sich,
           a.xsga as sga_t, a.sale as sales_t, a.curcd as curcd_t, a.currtr as currtr_t,
           b.xsga as sga_lag, b.sale as sales_lag,
           b.curcd as curcd_lag, b.currtr as currtr_lag
    from work.annual_selected as a
    left join work.annual_selected as b
      on a.gvkey = b.gvkey and b.fyear = a.fyear - 1
    where a.fyear between 1979 and 1998;
quit;

title "Currency alignment checks across all adjacent-year source pairs";
proc sql;
    select count(*) as CurrentRows,
           sum(case when missing(curcd_t) or missing(curcd_lag) then 1 else 0 end) as MissingCodePair,
           sum(case when not missing(curcd_t) and not missing(curcd_lag) and curcd_t ne curcd_lag
                    then 1 else 0 end) as DifferentCodePair,
           sum(case when not missing(curcd_t) and not missing(curcd_lag) and curcd_t ne curcd_lag
                         and (missing(currtr_t) or currtr_t <= 0 or missing(currtr_lag) or currtr_lag <= 0)
                    then 1 else 0 end) as DifferentCodeNoRate
    from work.pairs;
quit;

title "One-year firm-year source-screen attrition";
proc sql;
    select count(*) as CurrentRows,
           sum(case when missing(sga_t) or missing(sales_t) or
                         missing(sga_lag) or missing(sales_lag)
                    then 1 else 0 end) as AnyMissingCurrentOrPrior,
           sum(case when not missing(sga_t) and not missing(sales_t) and
                         not missing(sga_lag) and not missing(sales_lag) and
                         sga_t > sales_t
                    then 1 else 0 end) as CurrentSGAExceedsSales,
           sum(case when not missing(sga_t) and not missing(sales_t) and
                         not missing(sga_lag) and not missing(sales_lag) and
                         sga_t <= sales_t and
                         (sga_t <= 0 or sales_t <= 0 or sga_lag <= 0 or sales_lag <= 0)
                    then 1 else 0 end) as NonposLogInputs
    from work.pairs;
quit;

data work.eligible;
    length currency_status $20;
    set work.pairs;
    if missing(sga_t) or missing(sales_t) or missing(sga_lag) or missing(sales_lag) then delete;
    if sga_t > sales_t then delete;
    if sga_t <= 0 or sales_t <= 0 or sga_lag <= 0 or sales_lag <= 0 then delete;

    legacy_dy = log(sga_t / sga_lag);
    legacy_dx = log(sales_t / sales_lag);
    legacy_decrease = (sales_t < sales_lag);
    legacy_interaction = legacy_decrease * legacy_dx;

    same_currency = .;
    cross_currency = .;
    currency_status = "NO-CURCD";
    sga_t_fitunit = .;
    sales_t_fitunit = .;
    sga_lag_fitunit = .;
    sales_lag_fitunit = .;

    if not missing(curcd_t) and not missing(curcd_lag) then do;
        same_currency = (curcd_t = curcd_lag);
        cross_currency = (curcd_t ne curcd_lag);
        if same_currency then do;
            currency_status = "SAME-CURRENCY";
            sga_t_fitunit = sga_t;
            sales_t_fitunit = sales_t;
            sga_lag_fitunit = sga_lag;
            sales_lag_fitunit = sales_lag;
        end;
        else if currtr_t > 0 and currtr_lag > 0 then currency_status = "CROSS-UNAVAILABLE";
        else currency_status = "CROSS-NO-RATE";
    end;

    dy = .;
    dx = .;
    decrease = .;
    interaction = .;
    if not missing(sga_t_fitunit) and not missing(sales_t_fitunit) and
       not missing(sga_lag_fitunit) and not missing(sales_lag_fitunit) then do;
        dy = log(sga_t_fitunit / sga_lag_fitunit);
        dx = log(sales_t_fitunit / sales_lag_fitunit);
        decrease = (sales_t_fitunit < sales_lag_fitunit);
        interaction = decrease * dx;
    end;
    changed_formula = .;
    decrease_changed = .;
    if not missing(dx) and not missing(dy) then do;
        changed_formula = (abs(dy - legacy_dy) > 1e-12 or abs(dx - legacy_dx) > 1e-12);
        decrease_changed = (decrease ne legacy_decrease);
    end;
run;

title "Currency-code transitions and CURRTR summaries";
proc freq data=work.eligible;
    where cross_currency = 1;
    tables curcd_lag*curcd_t / list missing;
run;
proc means data=work.eligible n mean min max;
    where cross_currency = 1;
    class curcd_lag curcd_t;
    var currtr_lag currtr_t;
run;

title "Legacy and unit-consistent pooled percentile cutoffs";
proc univariate data=work.eligible noprint;
    var legacy_dy;
    output out=work.cut_old_dy pctlpts=0.5 99.5 pctlpre=dy_ pctlname=lo hi;
run;
proc univariate data=work.eligible noprint;
    var legacy_dx;
    output out=work.cut_old_dx pctlpts=0.5 99.5 pctlpre=dx_ pctlname=lo hi;
run;
proc univariate data=work.eligible noprint;
    var legacy_interaction;
    output out=work.cut_old_int pctlpts=0.5 99.5 pctlpre=int_ pctlname=lo hi;
run;
proc univariate data=work.eligible noprint;
    var dy;
    output out=work.cut_new_dy pctlpts=0.5 99.5 pctlpre=dy_ pctlname=lo hi;
run;
proc univariate data=work.eligible noprint;
    var dx;
    output out=work.cut_new_dx pctlpts=0.5 99.5 pctlpre=dx_ pctlname=lo hi;
run;
proc univariate data=work.eligible noprint;
    var interaction;
    output out=work.cut_new_int pctlpts=0.5 99.5 pctlpre=int_ pctlname=lo hi;
run;

data _null_;
    set work.cut_old_dy;
    call symputx("old_dy_lo", dy_lo, "G");
    call symputx("old_dy_hi", dy_hi, "G");
run;
data _null_;
    set work.cut_old_dx;
    call symputx("old_dx_lo", dx_lo, "G");
    call symputx("old_dx_hi", dx_hi, "G");
run;
data _null_;
    set work.cut_old_int;
    call symputx("old_int_lo", int_lo, "G");
    call symputx("old_int_hi", int_hi, "G");
run;
data _null_;
    set work.cut_new_dy;
    call symputx("new_dy_lo", dy_lo, "G");
    call symputx("new_dy_hi", dy_hi, "G");
run;
data _null_;
    set work.cut_new_dx;
    call symputx("new_dx_lo", dx_lo, "G");
    call symputx("new_dx_hi", dx_hi, "G");
run;
data _null_;
    set work.cut_new_int;
    call symputx("new_int_lo", int_lo, "G");
    call symputx("new_int_hi", int_hi, "G");
run;

%put NOTE: Legacy pooled 0.5th/99.5th cutoffs: dy=&old_dy_lo to &old_dy_hi.;
%put NOTE: Legacy pooled 0.5th/99.5th cutoffs: dx=&old_dx_lo to &old_dx_hi.;
%put NOTE: Legacy pooled 0.5th/99.5th cutoffs: interaction=&old_int_lo to &old_int_hi.;
%put NOTE: Currency-aligned pooled 0.5th/99.5th cutoffs: dy=&new_dy_lo to &new_dy_hi.;
%put NOTE: Currency-aligned pooled 0.5th/99.5th cutoffs: dx=&new_dx_lo to &new_dx_hi.;
%put NOTE: Currency-aligned pooled 0.5th/99.5th cutoffs: interaction=&new_int_lo to &new_int_hi.;

data work.final;
    set work.eligible;
    legacy_trimflag = (legacy_dy >= &old_dy_lo and legacy_dy <= &old_dy_hi and
                       legacy_dx >= &old_dx_lo and legacy_dx <= &old_dx_hi and
                       legacy_interaction >= &old_int_lo and legacy_interaction <= &old_int_hi);
    trimflag = 0;
    if not missing(dy) and not missing(dx) and not missing(interaction) then
        trimflag = (dy >= &new_dy_lo and dy <= &new_dy_hi and
                    dx >= &new_dx_lo and dx <= &new_dx_hi and
                    interaction >= &new_int_lo and interaction <= &new_int_hi);
    label dy = "Currency-consistent log change in SGA"
          dx = "Currency-consistent log change in net sales"
          decrease = "Currency-consistent sales decrease indicator"
          interaction = "Sales decrease x currency-consistent log sales change"
          trimflag = "Within currency-consistent pooled 0.5/99.5 cutoffs"
          curcd_t = "Current-period source currency"
          curcd_lag = "Prior-period source currency"
          currtr_t = "Current-period USD currency translation rate"
          currtr_lag = "Prior-period USD currency translation rate"
          currency_status = "Currency alignment for adjacent-year ratios"
          sga_t_fitunit = "Current-period SGA in ratio-comparable unit"
          sales_t_fitunit = "Current-period sales in ratio-comparable unit"
          sga_lag_fitunit = "Prior-period SGA in ratio-comparable unit"
          sales_lag_fitunit = "Prior-period sales in ratio-comparable unit";
run;

title "Source-screened population and actual currency-repair impact";
proc sql;
    select count(*) as ScreenedRows,
           count(distinct gvkey) as Firms,
           sum(same_currency = 1) as SameCurrencyPairs,
           sum(cross_currency = 1) as CrossCurrencyPairs,
           sum(currency_status = "NO-CURCD") as MissingCurrencyPairs,
           sum(currency_status = "CROSS-UNAVAILABLE") as UnlikeCurrencyRatiosUnavailable,
           sum(currency_status = "CROSS-NO-RATE") as UnlikeCurrencyPairsNoRate,
           sum(decrease_changed = 1) as DecreaseClassificationsChanged,
           sum(legacy_trimflag = 1) as LegacyFitN,
           sum(trimflag = 1) as CurrencyAlignedFitN,
           sum(cross_currency = 1 and legacy_trimflag = 1) as CrossCurrencyRowsInLegacyFit,
           sum(cross_currency = 1 and trimflag = 1) as CrossCurrencyRowsInAlignedFit,
           sum(legacy_trimflag = 1 and trimflag = 0) as LegacyFitRowsNotAlignedFit,
           sum(legacy_trimflag = 0 and trimflag = 1) as AlignedFitRowsNotLegacyFit,
           sum(same_currency = 1 and decrease_changed = 1) as SameCurrencyDecreaseErrors
    from work.final;
quit;

proc means data=work.final n mean min max;
    class currency_status;
    var dy dx interaction legacy_dy legacy_dx legacy_interaction;
run;

data out.main_sample;
    set work.final;
    keep gvkey fyear datadate sich sga_t sales_t sga_lag sales_lag
         curcd_t curcd_lag currtr_t currtr_lag currency_status
         sga_t_fitunit sales_t_fitunit sga_lag_fitunit sales_lag_fitunit
         dy dx decrease interaction trimflag;
run;

title;
