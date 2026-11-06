options errorabend;
options validvarname=v7;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname out "data";

/* Read only the fields and fiscal years needed for 1987-1999 outcomes and
   the 1985-2000 denominator/CFO history. CURCD is retained to ensure that
   each average-assets denominator is formed within one reporting currency.
   CURRTR is summarized for diagnosis only; no arithmetic direction is
   inferred from its provider definition. */
data work.raw;
    set comp.funda
        (keep=gvkey datadate fyear indfmt datafmt consol popsrc fyr at oancf
              recch invch apalch txach aoloch ibc sich curcd currtr
         where=(fyear >= 1985 and fyear <= 2000 and indfmt="INDL" and datafmt="STD"
                and consol="C" and popsrc="D"));
run;

proc sql noprint;
    select count(*) into :raw_rows trimmed from work.raw;
    select count(*) into :duplicate_pairs trimmed
    from (select gvkey, fyear
          from work.raw
          group by gvkey, fyear
          having count(*) > 1) as d;
quit;
%put NOTE: Filtered annual source rows=&raw_rows.;
%put NOTE: Duplicate gvkey-fyear keys=&duplicate_pairs.;

proc freq data=work.raw;
    tables curcd / missing;
    title "W3122547505 reporting-currency codes in raw auxiliary population";
run;

proc means data=work.raw n nmiss min mean max;
    class curcd;
    var currtr;
    title "W3122547505 provider translation-rate diagnostics (not used for conversion)";
run;

/* A firm-year must be unique before date-keyed lead/lag construction. Do not
   hide duplicates with NODUPKEY or select a vintage without evidence. */
%if &duplicate_pairs > 0 %then %do;
    %put ERROR: Resolve the reported duplicate gvkey-fyear keys before estimation.;
    %abort cancel;
%end;

proc sort data=work.raw;
    by gvkey fyear;
run;

/* Shift by fiscal year so gaps remain gaps. Retain adjacent earnings inputs
   as well as CFO because the prose sample rule mentions both. */
data work.lag1(keep=gvkey fyear at_lag1 curcd_lag1
                    cfo_lag_raw ibc_lag_raw d_wc_lag_raw);
    set work.raw(keep=gvkey fyear at oancf ibc recch invch apalch txach aoloch curcd);
    fyear = fyear + 1;
    at_lag1 = at;
    curcd_lag1 = curcd;
    cfo_lag_raw = oancf;
    ibc_lag_raw = ibc;
    if nmiss(recch, invch, apalch, txach, aoloch)=0 then
        d_wc_lag_raw = -(recch + invch + apalch + txach + aoloch);
    else d_wc_lag_raw = .;
run;

data work.lag2(keep=gvkey fyear at_lag2 curcd_lag2);
    set work.raw(keep=gvkey fyear at curcd);
    fyear = fyear + 2;
    at_lag2 = at;
    curcd_lag2 = curcd;
run;

data work.lead1(keep=gvkey fyear at_lead1 curcd_lead1
                     cfo_lead_raw ibc_lead_raw d_wc_lead_raw);
    set work.raw(keep=gvkey fyear at oancf ibc recch invch apalch txach aoloch curcd);
    fyear = fyear - 1;
    at_lead1 = at;
    curcd_lead1 = curcd;
    cfo_lead_raw = oancf;
    ibc_lead_raw = ibc;
    if nmiss(recch, invch, apalch, txach, aoloch)=0 then
        d_wc_lead_raw = -(recch + invch + apalch + txach + aoloch);
    else d_wc_lead_raw = .;
run;

proc sort data=work.lag1; by gvkey fyear; run;
proc sort data=work.lag2; by gvkey fyear; run;
proc sort data=work.lead1; by gvkey fyear; run;

/* Check the same-period average-assets denominator for every raw year used
   by current, past, and future variables: 1986-2000. This includes 1986
   history for 1987 outcomes and 2000 history for 1999 outcomes. */
data work.prior_period(keep=gvkey fyear at_prior curcd_prior);
    set work.raw(keep=gvkey fyear at curcd);
    fyear = fyear + 1;
    at_prior = at;
    curcd_prior = curcd;
run;
proc sort data=work.prior_period; by gvkey fyear; run;

data work.currency_periods;
    merge work.raw(in=current_row)
          work.prior_period(in=prior_row);
    by gvkey fyear;
    if current_row and fyear >= 1986 and fyear <= 2000;
    has_prior_row = prior_row;
    curcd_same_as_prior = 0;
    if has_prior_row and not missing(curcd) and not missing(curcd_prior)
       and curcd = curcd_prior then curcd_same_as_prior = 1;
    avg_at_period = .;
    if curcd_same_as_prior and has_prior_row and nmiss(at, at_prior)=0 then do;
        avg_at_period = (at + at_prior) / 2;
        if avg_at_period <= 0 then avg_at_period = .;
    end;
    if not missing(avg_at_period) then do;
        cfo_scaled_period = oancf / avg_at_period;
        if nmiss(recch, invch, apalch, txach, aoloch)=0 then do;
            d_wc_period = -(recch + invch + apalch + txach + aoloch);
            earn_scaled_period = (oancf + d_wc_period) / avg_at_period;
        end;
        else do;
            d_wc_period = .;
            earn_scaled_period = .;
        end;
    end;
    else do;
        cfo_scaled_period = .;
        d_wc_period = .;
        earn_scaled_period = .;
    end;
run;

proc sql;
    title "W3122547505 CURCD and own-period denominator checks over raw auxiliary years";
    select fyear as scaled_fyear,
           count(*) as raw_firm_years,
           sum(has_prior_row=0) as no_prior_year_record,
           sum(has_prior_row=1 and (missing(curcd) or missing(curcd_prior))) as missing_currency_pair,
           sum(has_prior_row=1 and not missing(curcd) and not missing(curcd_prior)
               and curcd=curcd_prior) as same_currency_pair,
           sum(has_prior_row=1 and not missing(curcd) and not missing(curcd_prior)
               and curcd ne curcd_prior) as different_currency_pair,
           sum(has_prior_row=1 and nmiss(at,at_prior)=0) as assets_pair_fields_present,
           sum(not missing(avg_at_period)) as currency_valid_average_assets,
           sum(not missing(cfo_scaled_period)) as currency_valid_cfo,
           sum(not missing(earn_scaled_period)) as currency_valid_earn
    from work.currency_periods
    group by fyear
    order by fyear;
quit;

data work.anchored;
    merge work.raw(in=anchor)
          work.lag1
          work.lag2
          work.lead1;
    by gvkey fyear;
    if anchor and fyear >= 1987 and fyear <= 1999;

    /* Paper item 302+303+304+305+307 are signed cash-flow changes. */
    if nmiss(recch, invch, apalch, txach, aoloch)=0 then
        d_wc = -(recch + invch + apalch + txach + aoloch);
    else d_wc = .;

    /* Make a denominator available only when both source assets share CURCD.
       No average is formed across unlike-currency amounts. */
    curcd_ok_current = (not missing(curcd) and not missing(curcd_lag1)
                        and curcd = curcd_lag1);
    curcd_ok_lag = (not missing(curcd_lag1) and not missing(curcd_lag2)
                    and curcd_lag1 = curcd_lag2);
    curcd_ok_lead = (not missing(curcd) and not missing(curcd_lead1)
                     and curcd = curcd_lead1);

    avg_at = .;
    avg_at_lag = .;
    avg_at_lead = .;
    if curcd_ok_current and nmiss(at, at_lag1)=0 then do;
        avg_at = (at + at_lag1) / 2;
        if avg_at <= 0 then avg_at = .;
    end;
    if curcd_ok_lag and nmiss(at_lag1, at_lag2)=0 then do;
        avg_at_lag = (at_lag1 + at_lag2) / 2;
        if avg_at_lag <= 0 then avg_at_lag = .;
    end;
    if curcd_ok_lead and nmiss(at, at_lead1)=0 then do;
        avg_at_lead = (at + at_lead1) / 2;
        if avg_at_lead <= 0 then avg_at_lead = .;
    end;

    if avg_at > 0 then do;
        cfo_scaled = oancf / avg_at;
        prof_scaled = ibc / avg_at;
        d_wc_scaled = d_wc / avg_at;
        earn_scaled = cfo_scaled + d_wc_scaled;
    end;
    else do;
        cfo_scaled = .;
        prof_scaled = .;
        d_wc_scaled = .;
    end;

    if avg_at_lag > 0 and not missing(cfo_lag_raw) then
        cfo_lag = cfo_lag_raw / avg_at_lag;
    else cfo_lag = .;
    if avg_at_lag > 0 and not missing(ibc_lag_raw) then
        prof_lag = ibc_lag_raw / avg_at_lag;
    else prof_lag = .;
    if avg_at_lag > 0 and not missing(cfo_lag_raw) and not missing(d_wc_lag_raw) then
        earn_lag = (cfo_lag_raw + d_wc_lag_raw) / avg_at_lag;
    else earn_lag = .;

    if avg_at_lead > 0 and not missing(cfo_lead_raw) then
        cfo_lead = cfo_lead_raw / avg_at_lead;
    else cfo_lead = .;
    if avg_at_lead > 0 and not missing(ibc_lead_raw) then
        prof_lead = ibc_lead_raw / avg_at_lead;
    else prof_lead = .;
    if avg_at_lead > 0 and not missing(cfo_lead_raw) and not missing(d_wc_lead_raw) then
        earn_lead = (cfo_lead_raw + d_wc_lead_raw) / avg_at_lead;
    else earn_lead = .;

    /* Availability indicators count complete source fields, not fabricated
       scaled values, for the pre-currency audit comparison. */
    cfo_lag_source_available = (not missing(cfo_lag_raw)
                                and nmiss(at_lag1, at_lag2)=0);
    earn_lag_source_available = (not missing(cfo_lag_raw)
                                 and not missing(d_wc_lag_raw)
                                 and nmiss(at_lag1, at_lag2)=0);
    cfo_lead_source_available = (not missing(cfo_lead_raw)
                                 and nmiss(at, at_lead1)=0);
    earn_lead_source_available = (not missing(cfo_lead_raw)
                                  and not missing(d_wc_lead_raw)
                                  and nmiss(at, at_lead1)=0);

    complete_reported_fields = (nmiss(at, ibc, oancf, recch, invch)=0);
    source_inputs_precur = (nmiss(at, at_lag1, ibc, oancf,
                                  recch, invch, apalch, txach,
                                  aoloch)=0);
    complete_model_inputs = (nmiss(at, ibc, oancf, recch, invch,
                                   apalch, txach, aoloch,
                                   avg_at, d_wc_scaled,
                                   cfo_scaled, prof_scaled)=0);
run;

proc sql;
    title "W3122547505 source coverage and pre-trim sample counts";
    select count(*) as outcome_year_rows,
           sum(complete_reported_fields) as reported_fields_complete,
           sum(source_inputs_precur) as source_inputs_precur,
           sum(complete_model_inputs) as all_model_inputs_complete,
           count(distinct gvkey) as firms_in_outcome_window
    from work.anchored;
quit;

proc sql;
    title "W3122547505 currency status for each model denominator window";
    select count(*) as outcome_year_rows,
           sum(curcd_ok_current) as current_t_and_tminus1_same,
           sum(not missing(curcd) and not missing(curcd_lag1)
               and curcd ne curcd_lag1) as current_t_and_tminus1_different,
           sum(curcd_ok_lag) as past_tminus1_and_tminus2_same,
           sum(not missing(curcd_lag1) and not missing(curcd_lag2)
               and curcd_lag1 ne curcd_lag2) as past_tm1_tm2_different,
           sum(curcd_ok_lead) as future_tplus1_and_t_same,
           sum(not missing(curcd) and not missing(curcd_lead1)
               and curcd ne curcd_lead1) as future_tplus1_and_t_different
    from work.anchored;
quit;

proc sql;
    title "W3122547505 field missingness in outcome-year population";
    select count(*) as outcome_year_rows,
           sum(missing(at)) as missing_assets,
           sum(missing(ibc)) as missing_item123_earnings,
           sum(missing(oancf)) as missing_item308_cfo,
           sum(missing(recch)) as missing_item302,
           sum(missing(invch)) as missing_item303,
           sum(missing(apalch)) as missing_item304,
           sum(missing(txach)) as missing_item305,
           sum(missing(aoloch)) as missing_item307,
           sum(missing(avg_at)) as missing_current_avg_assets,
           sum(missing(d_wc_scaled)) as missing_scaled_delta_wc
    from work.anchored;
quit;

data work.complete;
    set work.anchored;
    if complete_model_inputs;
run;

/* The paper does not state whether percentiles are year-specific. Use pooled
   SAS 1st/99th percentile cutoffs for the scaled current-year variables. */
proc univariate data=work.complete noprint;
    var cfo_scaled prof_scaled d_wc_scaled;
    output out=work.cutoffs
        pctlpts=1 99
        pctlpre=cfo_ prof_ dwc_;
run;

data work.trimmed;
    if _n_=1 then set work.cutoffs;
    set work.complete;
    if cfo_scaled >= cfo_1 and cfo_scaled <= cfo_99
       and prof_scaled >= prof_1 and prof_scaled <= prof_99
       and d_wc_scaled >= dwc_1 and d_wc_scaled <= dwc_99;
run;

proc sql;
    title "W3122547505 sample attrition by Table 1 screen";
    select "Complete variables before trimming" as stage length=40,
           count(*) as firm_years,
           count(distinct gvkey) as firms
    from work.complete
    union all
    select "After pooled 1/99 percentile trimming" as stage length=40,
           count(*) as firm_years,
           count(distinct gvkey) as firms
    from work.trimmed;
quit;

proc sql;
    title "W3122547505 lead/lag availability after current-row trimming";
    select count(*) as trimmed_firm_years,
           sum(cfo_lag_source_available) as lag_cfo_inputs_present,
           sum(not missing(cfo_lag)) as lag_cfo_currency_valid,
           sum(earn_lag_source_available) as lag_earn_inputs_present,
           sum(not missing(earn_lag)) as lag_earn_currency_valid,
           sum(cfo_lead_source_available) as lead_cfo_inputs_present,
           sum(not missing(cfo_lead)) as lead_cfo_currency_valid,
           sum(earn_lead_source_available) as lead_earn_inputs_present,
           sum(not missing(earn_lead)) as lead_earn_currency_valid,
           sum(cfo_lag_source_available and not missing(cfo_scaled)
               and cfo_lead_source_available and earn_lag_source_available
               and not missing(earn_scaled) and earn_lead_source_available)
               as all_cfo_earn_inputs_precur,
           sum(nmiss(cfo_lag,cfo_scaled,cfo_lead,
                     earn_lag,earn_scaled,earn_lead)=0) as all_cfo_earn_currency_valid,
           sum(missing(cfo_lag)) as missing_scaled_lag_cfo,
           sum(missing(cfo_lead)) as missing_scaled_lead_cfo,
           sum(missing(earn_lag)) as missing_scaled_lag_earn,
           sum(missing(earn_lead)) as missing_scaled_lead_earn,
           sum(missing(prof_lag)) as missing_scaled_lag_prof,
           sum(missing(prof_lead)) as missing_scaled_lead_prof
    from work.trimmed;
quit;

/* Compare Table 1's explicit CFO lead/lag row with the surrounding prose
   requiring past/future cash flows and earnings. Earn is CFO + delta WC. */
proc sql;
    title "W3122547505 lead/lag eligibility alternatives and period boundaries";
    select "CFO only, outcome 1987-1999" as screen length=48,
           count(*) as firm_years, count(distinct gvkey) as firms
    from work.trimmed
    where nmiss(cfo_lag, cfo_scaled, cfo_lead)=0
    union all
    select "CFO plus Earn, outcome 1987-1999" as screen length=48,
           count(*) as firm_years, count(distinct gvkey) as firms
    from work.trimmed
    where nmiss(cfo_lag, cfo_scaled, cfo_lead, earn_lag, earn_scaled, earn_lead)=0
    union all
    select "CFO plus Prof, outcome 1987-1999" as screen length=48,
           count(*) as firm_years, count(distinct gvkey) as firms
    from work.trimmed
    where nmiss(cfo_lag, cfo_scaled, cfo_lead, prof_lag, prof_scaled, prof_lead)=0
    union all
    select "CFO plus Earn, all years inside 1987-1999" as screen length=48,
           count(*) as firm_years, count(distinct gvkey) as firms
    from work.trimmed
    where fyear >= 1988 and fyear <= 1998
      and nmiss(cfo_lag, cfo_scaled, cfo_lead, earn_lag, earn_scaled, earn_lead)=0;
quit;

/* Preserve the observed outcome-year window and adjacent raw-year inputs.
   Follow the p. 8 sample prose by requiring lead/lag Earn in addition to CFO.
   Neighbor years need not independently pass the current-year trimming rule. */
data work.with_leads;
    set work.trimmed;
    if nmiss(cfo_lag, cfo_scaled, cfo_lead,
             earn_lag, earn_scaled, earn_lead)=0;
run;

proc sql;
    title "W3122547505 post lead/lag CFO and Earn screen";
    select count(*) as firm_years,
           count(distinct gvkey) as firms
    from work.with_leads;
quit;

proc sql;
    create table work.firm_counts as
    select gvkey, count(*) as n_firm_years
    from work.with_leads
    group by gvkey;

    create table work.fit_sample as
    select a.gvkey, a.fyear, a.curcd,
           a.curcd_lag1, a.curcd_lag2, a.curcd_lead1, a.d_wc_scaled,
           a.cfo_lag, a.cfo_scaled as cfo_cur, a.cfo_lead,
           b.n_firm_years
    from work.with_leads as a
    inner join work.firm_counts as b
      on a.gvkey=b.gvkey
    where b.n_firm_years >= 8
    order by a.gvkey, a.fyear;
quit;

proc sql;
    title "W3122547505 firm-specific regression sample";
    select count(*) as firm_years,
           count(distinct gvkey) as firms,
           min(n_firm_years) as min_years_per_firm,
           max(n_firm_years) as max_years_per_firm
    from work.fit_sample;
quit;

proc sql;
    title "W3122547505 firm-specific sample observation-count distribution";
    select n_firm_years, count(distinct gvkey) as firms
    from work.fit_sample
    group by n_firm_years
    order by n_firm_years;
quit;

proc sql;
    title "W3122547505 outcome-year boundary observations";
    select fyear, count(*) as firm_years, count(distinct gvkey) as firms
    from work.fit_sample
    group by fyear
    order by fyear;
quit;

data out.firm_specific;
    set work.fit_sample;
    label d_wc_scaled="Change in working capital / average assets"
          cfo_lag="CFO(t-1) / average assets(t-1)"
          cfo_cur="CFO(t) / average assets(t)"
          cfo_lead="CFO(t+1) / average assets(t+1)"
          curcd="CURCD at outcome year"
          curcd_lag1="CURCD at outcome year minus one"
          curcd_lag2="CURCD at outcome year minus two"
          curcd_lead1="CURCD at outcome year plus one"
          n_firm_years="Eligible annual observations for firm";
run;

proc sql;
    title "W3122547505 retained sample currency check (same-currency records stay eligible)";
    select curcd,
           count(*) as firm_years,
           count(distinct gvkey) as firms,
           sum(curcd=curcd_lag1) as current_and_prior_same,
           sum(curcd_lag1=curcd_lag2) as prior_and_two_prior_same,
           sum(curcd=curcd_lead1) as current_and_following_same
    from out.firm_specific
    group by curcd
    order by curcd;
quit;

proc sql;
    title "W3122547505 final sample key check";
    select count(*) as firm_years,
           count(distinct gvkey) as firms,
           count(distinct cats(gvkey, "-", put(fyear, 4.))) as firm_year_keys
    from out.firm_specific;
quit;

title;
