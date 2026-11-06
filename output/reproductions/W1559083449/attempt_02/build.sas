options errorabend;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname ccm "/storage/sas/base/crsp/a_ccm" access=readonly;
libname crsp "/storage/sas/base/crsp/a_stock" access=readonly;
libname out "data/main";

/* Compustat Industrial Annual: standard, consolidated domestic-source rows. */
data work.annual;
    set comp.funda(keep=gvkey datadate fyear fyr indfmt datafmt popsrc consol
                         at che lt dltt dlc oiadp sale sich curcd curncd);
    where indfmt = 'INDL' and datafmt = 'STD' and popsrc = 'D' and consol = 'C'
          and fyear >= 1976 and fyear <= 1987;
    completeness_score = 12 - cmiss(datadate,fyr,at,che,lt,dltt,dlc,oiadp,sale,sich,curcd,curncd);
    format datadate yymmdd10.;
run;

/* Two canonical keys can contain companion rows. Inspect their bounded source
   profiles and select a unique most-complete row; ties stop the construction. */
proc sql;
    create table work.duplicate_keys as
    select gvkey, fyear, count(*) as n_rows
    from work.annual
    group by gvkey, fyear
    having calculated n_rows > 1;
    create table work.duplicate_max as
    select a.gvkey, a.fyear, max(a.completeness_score) as max_score
    from work.annual as a inner join work.duplicate_keys as d
      on a.gvkey=d.gvkey and a.fyear=d.fyear
    group by a.gvkey, a.fyear;
    create table work.duplicate_ties as
    select a.gvkey, a.fyear, count(*) as rows_at_max
    from work.annual as a inner join work.duplicate_max as d
      on a.gvkey=d.gvkey and a.fyear=d.fyear and a.completeness_score=d.max_score
    group by a.gvkey, a.fyear
    having calculated rows_at_max > 1;
    create table work.duplicate_profile as
    select a.gvkey, a.fyear, a.datadate, a.fyr, a.curcd, a.curncd, a.sich,
           a.completeness_score,
           case when missing(a.at) then 0 else 1 end as at_present,
           case when missing(a.che) then 0 else 1 end as che_present,
           case when missing(a.lt) then 0 else 1 end as lt_present,
           case when missing(a.dltt) then 0 else 1 end as dltt_present,
           case when missing(a.dlc) then 0 else 1 end as dlc_present,
           case when missing(a.oiadp) then 0 else 1 end as oiadp_present,
           case when missing(a.sale) then 0 else 1 end as sale_present
    from work.annual as a inner join work.duplicate_keys as d
      on a.gvkey=d.gvkey and a.fyear=d.fyear
    order by a.gvkey, a.fyear, a.datadate;
    select count(*) into :duplicate_key_count trimmed from work.duplicate_keys;
    select coalesce(sum(n_rows-1),0) into :duplicate_extra_rows trimmed from work.duplicate_keys;
    select count(*) into :duplicate_tie_count trimmed from work.duplicate_ties;
quit;
%put NOTE: Canonical duplicate GVKEY-FYEAR keys=&duplicate_key_count extra rows=&duplicate_extra_rows.;
proc print data=work.duplicate_profile noobs;
run;
data _null_;
    if &duplicate_tie_count > 0 then do;
        put 'ERROR: A duplicate GVKEY-FYEAR key has a tied maximum source-field completeness score.';
        abort abend 5;
    end;
run;
proc sql;
    create table work.annual_selected as
    select a.*
    from work.annual as a
    left join work.duplicate_max as d
      on a.gvkey=d.gvkey and a.fyear=d.fyear
    where missing(d.gvkey) or a.completeness_score=d.max_score;
    create table work.selected_duplicate_keys as
    select gvkey, fyear, count(*) as n_rows
    from work.annual_selected
    group by gvkey, fyear
    having calculated n_rows > 1;
    select count(*) into :selected_duplicate_keys trimmed
    from work.selected_duplicate_keys;
quit;
%put NOTE: Selected annual rows still having duplicate firm-years=&selected_duplicate_keys.;
data _null_;
    if &selected_duplicate_keys > 0 then do;
        put 'ERROR: Annual source selection did not resolve duplicate GVKEY-FYEAR keys.';
        abort abend 5;
    end;
run;

/* Catalog-backed currency and historical-industry coverage checks. */
proc freq data=work.annual_selected;
    tables fyear*curcd fyear*curncd / list missing;
run;
proc sql;
    select fyear,
           count(*) as annual_rows,
           sum(missing(curcd)) as missing_reported_currency,
           sum(missing(curncd)) as missing_native_currency,
           sum(missing(sich) or sich=0) as missing_or_zero_historical_sic,
           sum(case when sich >= 6000 and sich <= 6999 then 1 else 0 end) as financial_sic_rows
    from work.annual_selected
    group by fyear
    order by fyear;
quit;

/* Keyed fiscal-year joins preserve FY1976 balances and FY1987 actual dates. */
proc sql;
    create table work.periods as
    select t.gvkey,
           t.fyear as t_year,
           l2.datadate as datadate_l2 format=yymmdd10.,
           l1.datadate as datadate_l1 format=yymmdd10.,
           t.datadate as datadate_t format=yymmdd10.,
           f1.datadate as datadate_f1 format=yymmdd10.,
           l2.curcd as curcd_l2,
           l1.curcd as curcd_l1,
           t.curcd as curcd_t,
           f1.curcd as curcd_f1,
           t.sich as sic_t,
           l2.at as at_l2, l2.che as che_l2, l2.lt as lt_l2,
           l2.dltt as dltt_l2, l2.dlc as dlc_l2,
           l1.at as at_l1, l1.che as che_l1, l1.lt as lt_l1,
           l1.dltt as dltt_l1, l1.dlc as dlc_l1,
           l1.oiadp as oiadp_l1, l1.sale as sale_l1,
           t.at as at_t, t.che as che_t, t.lt as lt_t,
           t.dltt as dltt_t, t.dlc as dlc_t,
           t.oiadp as oiadp_t, t.sale as sale_t,
           f1.at as at_f1, f1.che as che_f1, f1.lt as lt_f1,
           f1.dltt as dltt_f1, f1.dlc as dlc_f1,
           f1.oiadp as oiadp_f1, f1.sale as sale_f1
    from work.annual_selected as t
    inner join work.annual_selected as l1
        on t.gvkey=l1.gvkey and l1.fyear=t.fyear-1
    inner join work.annual_selected as l2
        on t.gvkey=l2.gvkey and l2.fyear=t.fyear-2
    inner join work.annual_selected as f1
        on t.gvkey=f1.gvkey and f1.fyear=t.fyear+1
    where t.fyear >= 1978 and t.fyear <= 1986;
quit;

/* Date-matched CRSP SIC fallback for missing/zero Compustat historical SIC.
   CCM .E/missing LINKENDDT values are treated as open-ended intervals. */
proc sql;
    create table work.sic_link_matches as
    select distinct p.gvkey, p.t_year, p.datadate_t, l.lpermno as permno
    from work.periods as p
    inner join ccm.ccmxpf_linktable as l
      on strip(p.gvkey)=strip(l.gvkey)
     and l.linktype in ('LC','LU') and l.linkprim in ('P','C') and l.lpermno > 0
     and not missing(l.linkdt) and l.linkdt <= p.datadate_t
     and (missing(l.linkenddt) or p.datadate_t <= l.linkenddt);
    create table work.sic_name_matches as
    select distinct l.gvkey, l.t_year, l.datadate_t, l.permno, m.siccd
    from work.sic_link_matches as l
    inner join crsp.msenames as m
      on l.permno=m.permno
     and not missing(m.namedt) and m.namedt <= l.datadate_t
     and (missing(m.nameendt) or l.datadate_t <= m.nameendt);
    create table work.sic_candidates as
    select distinct gvkey, t_year, datadate_t, permno, siccd
    from work.sic_name_matches
    where siccd > 0;
    create table work.sic_link_counts as
    select gvkey, t_year, count(distinct permno) as n_link_permnos
    from work.sic_link_matches
    group by gvkey, t_year;
    create table work.sic_name_counts as
    select gvkey, t_year, count(distinct permno) as n_name_permnos,
           count(*) as n_name_rows
    from work.sic_name_matches
    group by gvkey, t_year;
    create table work.sic_fallback as
    select gvkey, t_year,
           count(distinct siccd) as n_sic_codes,
           count(distinct permno) as n_sic_permnos,
           count(*) as candidate_rows,
           min(siccd) as fallback_sic
    from work.sic_candidates
    group by gvkey, t_year;
    create table work.periods_sic as
    select p.*, l.n_link_permnos, n.n_name_permnos, n.n_name_rows,
           f.n_sic_codes, f.n_sic_permnos, f.candidate_rows, f.fallback_sic
    from work.periods as p
    left join work.sic_link_counts as l
      on p.gvkey=l.gvkey and p.t_year=l.t_year
    left join work.sic_name_counts as n
      on p.gvkey=n.gvkey and p.t_year=n.t_year
    left join work.sic_fallback as f
      on p.gvkey=f.gvkey and p.t_year=f.t_year;
quit;

data work.classified;
    set work.periods_sic;
    if missing(n_link_permnos) then n_link_permnos=0;
    if missing(n_name_permnos) then n_name_permnos=0;
    if missing(n_name_rows) then n_name_rows=0;
    if missing(n_sic_codes) then n_sic_codes=0;
    if missing(n_sic_permnos) then n_sic_permnos=0;
    if missing(candidate_rows) then candidate_rows=0;
    sic_effective=sic_t;
    fallback_used=0;
    if missing(sic_effective) or sic_effective=0 then do;
        if n_sic_codes=1 then do;
            sic_effective=fallback_sic;
            fallback_used=1;
        end;
    end;
    industry_known=(not missing(sic_effective) and sic_effective>0);
    financial=(industry_known and sic_effective>=6000 and sic_effective<=6999);
    industry_ok=(industry_known and not financial);
    crsp_multicode=(n_sic_codes>1);
    comp_crsp_conflict=(not missing(sic_t) and sic_t>0 and n_sic_codes=1 and sic_t ne fallback_sic);
    length sic_source $1;
    if not missing(sic_t) and sic_t>0 then sic_source='C';
    else if fallback_used=1 then sic_source='R';
    else sic_source='U';
run;

proc sql;
    select t_year,
           count(*) as joined_periods,
           sum(not missing(sic_t) and sic_t>0) as known_compustat_sich,
           sum(missing(sic_t) or sic_t=0) as missing_or_zero_compustat_sich,
           sum(n_link_permnos>0) as dated_ccm_link_coverage,
           sum(n_link_permnos>0 and n_name_permnos>0) as dated_crsp_name_coverage,
           sum(n_name_permnos>0 and n_sic_codes>0) as positive_sic_coverage,
           sum((missing(sic_t) or sic_t=0) and n_link_permnos=0) as missing_ccm_link,
           sum((missing(sic_t) or sic_t=0) and n_link_permnos>0 and n_name_permnos=0) as missing_crsp_name,
           sum((missing(sic_t) or sic_t=0) and n_name_permnos>0 and n_sic_codes=0) as names_without_valid_sic,
           sum(fallback_used) as unique_crsp_fallbacks,
           sum((missing(sic_t) or sic_t=0) and n_sic_codes>1) as unresolved_multicode_fallbacks,
           sum((missing(sic_t) or sic_t=0) and n_sic_codes=0) as unresolved_no_fallback,
           sum(crsp_multicode) as multicode_conflicts,
           sum(comp_crsp_conflict) as sich_crsp_disagree,
           sum(industry_known) as dated_industry_resolved,
           sum(financial) as financial_industry_rows,
           sum(not industry_known) as dated_industry_unresolved
    from work.classified
    group by t_year
    order by t_year;
quit;

/* Build source-defined ratios only with stable reporting currency and ordered dates. */
data work.constructed;
    set work.classified;
    length same_currency date_order prior_pm_ok current_tails_ok future_tail_ok complete_case sample_ok 8;
    same_currency = (not missing(curcd_t) and curcd_l2=curcd_t and curcd_l1=curcd_t and curcd_f1=curcd_t);
    date_order = (nmiss(datadate_l2,datadate_l1,datadate_t,datadate_f1)=0
                  and datadate_l2 < datadate_l1 and datadate_l1 < datadate_t
                  and datadate_t < datadate_f1);

    if same_currency and date_order then do;
        if nmiss(at_l2,che_l2,lt_l2,dltt_l2,dlc_l2)=0 then
            noa_l2 = (at_l2-che_l2) - (lt_l2-dltt_l2-dlc_l2);
        if nmiss(at_l1,che_l1,lt_l1,dltt_l1,dlc_l1)=0 then
            noa_l1 = (at_l1-che_l1) - (lt_l1-dltt_l1-dlc_l1);
        if nmiss(at_t,che_t,lt_t,dltt_t,dlc_t)=0 then
            noa_t = (at_t-che_t) - (lt_t-dltt_t-dlc_t);
        if nmiss(at_f1,che_f1,lt_f1,dltt_f1,dlc_f1)=0 then
            noa_f1 = (at_f1-che_f1) - (lt_f1-dltt_f1-dlc_f1);

        if nmiss(noa_t,noa_l1)=0 then avgnoa_t=(noa_t+noa_l1)/2;
        if nmiss(noa_l1,noa_l2)=0 then avgnoa_l1=(noa_l1+noa_l2)/2;
        if nmiss(noa_t,noa_f1)=0 then avgnoa_f1=(noa_t+noa_f1)/2;

        if not missing(avgnoa_t) and avgnoa_t ne 0 then do;
            rnoa_t=oiadp_t/avgnoa_t;
            ato_t=sale_t/avgnoa_t;
        end;
        if not missing(avgnoa_l1) and avgnoa_l1 ne 0 then do;
            rnoa_l1=oiadp_l1/avgnoa_l1;
            ato_l1=sale_l1/avgnoa_l1;
        end;
        if not missing(avgnoa_f1) and avgnoa_f1 ne 0 then
            rnoa_f1=oiadp_f1/avgnoa_f1;
        if not missing(sale_t) and sale_t ne 0 then pm_t=oiadp_t/sale_t;
        if not missing(sale_l1) and sale_l1 ne 0 then pm_l1=oiadp_l1/sale_l1;
        if not missing(noa_t) and not missing(noa_l1) and noa_l1 ne 0 then
            dnoa_t=(noa_t-noa_l1)/noa_l1;

        if nmiss(rnoa_t,rnoa_l1)=0 then drnoa_t=rnoa_t-rnoa_l1;
        if nmiss(rnoa_f1,rnoa_t)=0 then drnoa_f1=rnoa_f1-rnoa_t;
        if nmiss(ato_t,ato_l1)=0 then raw_delta_ato=ato_t-ato_l1;
        if nmiss(pm_t,pm_l1)=0 then raw_delta_pm=pm_t-pm_l1;
        if nmiss(raw_delta_ato,pm_l1)=0 then wdelta_ato=raw_delta_ato*pm_l1;
        if nmiss(raw_delta_pm,ato_l1)=0 then wdelta_pm=raw_delta_pm*ato_l1;
        if nmiss(raw_delta_ato,raw_delta_pm)=0 then int_raw=raw_delta_ato*raw_delta_pm;
        if nmiss(drnoa_t,wdelta_ato,wdelta_pm,int_raw)=0 then do;
            identity_error=drnoa_t-(wdelta_ato+wdelta_pm+int_raw);
            identity_scale=max(1,abs(drnoa_t),abs(wdelta_ato),abs(wdelta_pm),abs(int_raw));
            identity_rel_error=abs(identity_error)/identity_scale;
        end;
    end;

    prior_pm_ok=1;
    if not missing(pm_l1) and pm_l1 < 0 then prior_pm_ok=0;
    current_tails_ok=1;
    if not missing(rnoa_t) and abs(rnoa_t)>1 then current_tails_ok=0;
    if not missing(drnoa_t) and abs(drnoa_t)>0.5 then current_tails_ok=0;
    if not missing(wdelta_ato) and abs(wdelta_ato)>0.5 then current_tails_ok=0;
    if not missing(wdelta_pm) and abs(wdelta_pm)>0.5 then current_tails_ok=0;
    future_tail_ok=1;
    if not missing(drnoa_f1) and abs(drnoa_f1)>0.5 then future_tail_ok=0;
    complete_case=(nmiss(drnoa_f1,rnoa_t,dnoa_t,wdelta_ato,wdelta_pm,int_raw)=0);
    sample_ok=(date_order and same_currency and industry_ok and prior_pm_ok
               and current_tails_ok and future_tail_ok and complete_case);

    label t_year="Fiscal year t"
          datadate_t="Actual Compustat date for fiscal year t"
          sic_t="Compustat historical SIC at fiscal year t"
          sic_effective="Dated SIC from Compustat or CRSP fallback"
          curcd_t="Reported data currency at fiscal year t"
          drnoa_f1="Change in RNOA from t to t+1"
          rnoa_t="RNOA at t"
          dnoa_t="Growth in NOA at t"
          drnoa_t="Change in RNOA from t-1 to t"
          wdelta_ato="Weighted change in ATO at t"
          wdelta_pm="Weighted change in PM at t"
          int_raw="Raw change in ATO times raw change in PM"
          identity_error="Current change in RNOA less decomposition terms";
run;

proc sql;
    select count(*) into :identity_bad_count trimmed
    from work.constructed
    where not missing(identity_rel_error) and identity_rel_error>1e-10;
    select count(identity_error) as identity_checked_rows,
           max(abs(identity_error)) as maximum_absolute_identity_error format=best16.8,
           max(identity_rel_error) as maximum_relative_identity_error format=best16.12,
           sum(case when identity_rel_error>1e-10 then 1 else 0 end) as failed_relative_rows,
           sum(case when identity_rel_error>1e-10 and current_tails_ok=1 and future_tail_ok=1
                    then 1 else 0 end) as failures_within_tail_screens
    from work.constructed
    where not missing(identity_error);
quit;
%put NOTE: Relative row-level DeltaRNOA identity failures=&identity_bad_count.;
proc print data=work.constructed noobs;
    where not missing(identity_error) and abs(identity_error)>1e-10;
    var gvkey t_year datadate_t curcd_t sic_t sic_effective rnoa_t rnoa_l1 ato_t ato_l1 pm_t pm_l1
        drnoa_t wdelta_ato wdelta_pm int_raw identity_error identity_rel_error current_tails_ok future_tail_ok;
run;
data _null_;
    if &identity_bad_count > 0 then do;
        put 'ERROR: The relative weighted-change identity check failed.';
        abort abend 5;
    end;
run;

proc sql;
    select t_year,
           count(*) as joined_periods,
           sum(date_order) as increasing_actual_dates,
           sum(same_currency) as same_reported_currency,
           sum(date_order and same_currency) as constructible_unit_date_rows,
           sum(date_order and same_currency and industry_known and not financial) as nonfinancial_classified_rows,
           sum(date_order and same_currency and industry_known and not financial and prior_pm_ok) as prior_margin_rows,
           sum(date_order and same_currency and industry_known and not financial and prior_pm_ok and current_tails_ok) as after_current_screens,
           sum(date_order and same_currency and industry_known and not financial and prior_pm_ok and current_tails_ok and future_tail_ok) as after_future_screen,
           sum(sample_ok) as final_complete_cases
    from work.constructed
    group by t_year
    order by t_year;
quit;

proc means data=work.constructed n mean std median min p25 p75 max maxdec=8;
    where sample_ok=1;
    class t_year;
    var drnoa_f1 rnoa_t dnoa_t drnoa_t wdelta_ato wdelta_pm int_raw;
run;
proc means data=work.constructed n mean std median min p25 p75 max maxdec=8;
    where sample_ok=1;
    var drnoa_f1 rnoa_t dnoa_t drnoa_t wdelta_ato wdelta_pm int_raw;
run;

/* One handoff dataset for the retained Table 2 Model 3 pooled regression. */
data out.reg;
    set work.constructed;
    where sample_ok=1;
    keep gvkey t_year datadate_t curcd_t sic_t sic_effective sic_source fallback_used
         drnoa_f1 rnoa_t dnoa_t drnoa_t wdelta_ato wdelta_pm int_raw ato_t pm_t identity_error;
run;

proc sql;
    select count(*) as handoff_observations,
           count(distinct gvkey) as distinct_firms,
           count(distinct t_year) as analysis_years
    from out.reg;
    select t_year, count(*) as observations
    from out.reg
    group by t_year
    order by t_year;
quit;
