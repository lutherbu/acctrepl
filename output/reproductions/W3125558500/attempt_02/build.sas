options errorabend nodate nonumber linesize=150 pagesize=60;

libname comp   "/storage/sas/base/comp/d_na" access=readonly;
libname compsec "/storage/sas/base/comp/d_na/security" access=readonly;
libname compfx "/storage/sas/base/comp/d_global/currency" access=readonly;
libname ccm    "/storage/sas/base/crsp/a_ccm" access=readonly;
libname crsp   "/storage/sas/base/crsp/a_stock" access=readonly;
libname out "data";

/* Current North America annual records used as the local proxy for the
   paper's Annual Industrial and Research Compustat files. */
data funda;
    set comp.funda(keep=gvkey datadate fyear indfmt consol popsrc datafmt
                       sich ni pi spi curcd curncd currtr csho prcc_f iid hiid
                   where=(fyear >= 1975 and fyear <= 2001
                          and indfmt='INDL' and consol='C'
                          and popsrc='D' and datafmt='STD'));
    if missing(gvkey) then delete;
    flow_month_key = year(datadate)*100 + month(datadate);
    format datadate yymmdd10.;
run;

proc sql;
    create table funda_key_audit as
    select fyear,
           count(*) as annual_rows,
           sum(missing(sich)) as missing_historical_sic,
           sum(missing(ni)) as missing_ni,
           sum(missing(pi)) as missing_pi,
           sum(missing(spi)) as missing_spi
    from funda
    group by fyear;
    create table funda_fyear_duplicates as
    select gvkey, fyear, count(*) as n
    from funda
    group by gvkey, fyear
    having calculated n > 1;
    create table funda_period_duplicates as
    select gvkey, datadate, count(*) as n
    from funda
    group by gvkey, datadate
    having calculated n > 1;
    select min(datadate) as source_min_date format=yymmdd10.,
           max(datadate) as source_max_date format=yymmdd10.
    from funda;
quit;
proc print data=funda_key_audit noobs;
    title "FUNDA coverage, missing historical SIC, and source fields by fiscal year";
run;
proc sql;
    select count(*) as gvkey_fyear_duplicate_keys,
           coalesce(sum(n-1),0) as gvkey_fyear_extra_rows
    from funda_fyear_duplicates;
    select count(*) as gvkey_datadate_duplicate_keys,
           coalesce(sum(n-1),0) as gvkey_datadate_extra_rows
    from funda_period_duplicates;
quit;
proc freq data=funda;
    tables curcd*curncd fyear / missing;
    title "Selected annual Compustat records: reporting and native currencies, fiscal-year support";
run;
proc means data=funda n nmiss min p1 p50 p99 max;
    var ni pi spi csho prcc_f;
    title "Source field coverage and units before constructing the denominator";
run;

/* For each firm-year, take the nearest actual prior-period date with FYEAR-1.
   If a firm has duplicate prior-year records, the latest one before the current
   date is the beginning-of-period candidate; no later year fills a gap. */
proc sql;
    create table prior_dates as
    select a.gvkey, a.datadate as current_datadate, a.fyear as current_fyear,
           max(p.datadate) as beg_datadate format=yymmdd10.
    from funda as a left join funda as p
      on a.gvkey=p.gvkey and p.fyear=a.fyear-1 and p.datadate<a.datadate
    where a.fyear >= 1976 and a.fyear <= 2001
    group by a.gvkey, a.datadate, a.fyear;
    create table annual_panel as
    select a.*, p.fyear as beg_fyear, p.datadate as beg_datadate,
           p.csho as beg_csho, p.prcc_f as beg_prcc_f,
           p.curcd as beg_statement_currency,
           p.iid as beg_header_iid, p.hiid as beg_historical_iid,
           (a.datadate-p.datadate) as fiscal_gap_days,
           . as beg_month_key
    from funda as a
    left join prior_dates as d
      on a.gvkey=d.gvkey and a.datadate=d.current_datadate and a.fyear=d.current_fyear
    left join funda as p
      on a.gvkey=p.gvkey and p.fyear=a.fyear-1 and p.datadate=d.beg_datadate
    where a.fyear >= 1976 and a.fyear <= 2001;
quit;
data annual_panel;
    set annual_panel;
    if not missing(beg_datadate) then
        beg_month_key=year(beg_datadate)*100+month(beg_datadate);
run;

/* Build the dated issue keys and verify the prior annual HIID against primary
   issue history; a same-HIID monthly P marker is a fallback, not a uniqueness
   rule over every issue attached to the company-month. */
proc sql noprint;
    select min(datadate), max(datadate) into :source_min_date, :source_max_date
    from funda where fyear >= 1976 and fyear <= 2001;
quit;
%let reference_min_date=%eval(&source_min_date-550);
%put NOTE: Actual annual source date range &source_min_date through &source_max_date.;
%put NOTE: Bounded price and FX support begins &reference_min_date and ends &source_max_date.;

/* Fill missing current SICH only from a dated CRSP name-history SIC reached
   through an effective CCM GVKEY-to-PERMNO link. CRSP header SIC is not used;
   zero represents unavailable CRSP SIC. Unmatched firms remain in the pool. */
data ccm_sic_links;
    set ccm.ccmxpf_linktable(keep=gvkey lpermno linkdt linkenddt linkprim linktype usedflag);
    if usedflag ne 1 then delete;
    if linkprim not in ('P','C') then delete;
    if linktype not in ('LC','LU') then delete;
    if missing(lpermno) or lpermno <= 0 then delete;
    if missing(linkdt) and linkdt ne .B then delete;
    if missing(linkenddt) and linkenddt ne .E then delete;
    if linkdt > &source_max_date then delete;
    if linkenddt ne .E and linkenddt < &reference_min_date then delete;
run;
data crsp_sic_history;
    set crsp.stocknames(keep=permno namedt nameenddt siccd);
    if missing(namedt) then delete;
    if missing(nameenddt) and nameenddt ne .E then delete;
    if namedt > &source_max_date then delete;
    if nameenddt ne .E and nameenddt < &reference_min_date then delete;
    siccd_valid = .;
    if siccd >= 100 and siccd <= 9999 then siccd_valid=siccd;
run;
proc sql;
    create table dated_crsp_sic_candidates as
    select a.gvkey, a.datadate, a.fyear, l.lpermno, n.siccd_valid
    from annual_panel as a
    inner join ccm_sic_links as l
      on a.gvkey=l.gvkey and l.linkdt <= a.datadate
         and (l.linkenddt >= a.datadate or l.linkenddt=.E)
    inner join crsp_sic_history as n
      on l.lpermno=n.permno and n.namedt <= a.datadate
         and (n.nameenddt >= a.datadate or n.nameenddt=.E);
    create table dated_crsp_sic_classified as
    select *,
           case when siccd_valid >= 6000 and siccd_valid <= 6500 then 1
                when siccd_valid >= 4400 and siccd_valid <= 5000 then 1
                when siccd_valid >= 100 and siccd_valid <= 9999 then 0
                else . end as crsp_sic_excluded
    from dated_crsp_sic_candidates;
    create table dated_crsp_sic_counts as
    select gvkey, datadate, fyear, count(*) as dated_link_name_rows,
           count(distinct lpermno) as dated_permnos,
           count(distinct siccd_valid) as distinct_valid_sics,
           min(siccd_valid) as unique_crsp_sic,
           min(crsp_sic_excluded) as min_crsp_exclusion,
           max(crsp_sic_excluded) as max_crsp_exclusion
    from dated_crsp_sic_classified
    group by gvkey, datadate, fyear;
    create table annual_industry0 as
    select a.*, c.dated_link_name_rows, c.dated_permnos,
           c.distinct_valid_sics, c.unique_crsp_sic,
           c.min_crsp_exclusion, c.max_crsp_exclusion
    from annual_panel as a
    left join dated_crsp_sic_counts as c
      on a.gvkey=c.gvkey and a.datadate=c.datadate and a.fyear=c.fyear;
quit;
data annual_industry;
    set annual_industry0;
    length industry_source industry_screen_basis $24;
    industry_sic=.;
    funda_sich_valid=(not missing(sich) and sich >= 100 and sich <= 9999);
    funda_sich_invalid=(not missing(sich) and funda_sich_valid=0);
    funda_sich_zero=(not missing(sich) and sich=0);
    funda_sich_invalid_nonzero=(not missing(sich) and sich ne 0 and funda_sich_valid=0);
    if funda_sich_valid then do;
        industry_sic=sich;
        industry_source='FUNDA_SICH_VALID';
        industry_screen_excluded=((sich >= 6000 and sich <= 6500) or
                                  (sich >= 4400 and sich <= 5000));
        industry_screen_basis='FUNDA_SICH';
    end;
    else if distinct_valid_sics=1 then do;
        industry_sic=unique_crsp_sic;
        industry_source='CRSP_CCM_DATED';
        industry_screen_excluded=(min_crsp_exclusion=1);
        industry_screen_basis='CRSP_UNIQUE_SIC';
    end;
    else if distinct_valid_sics > 1 then do;
        industry_source='CRSP_CONFLICT';
        if min_crsp_exclusion=max_crsp_exclusion then do;
            industry_screen_excluded=min_crsp_exclusion;
            industry_screen_basis='CRSP_SCREEN_CONSENSUS';
        end;
        else do;
            industry_screen_excluded=.;
            industry_screen_basis='UNRESOLVED_CONFLICT';
        end;
    end;
    else do;
        industry_source='UNRESOLVED_MISSING';
        industry_screen_excluded=.;
        industry_screen_basis='UNRESOLVED_MISSING';
    end;
    funda_industry_excluded=((funda_sich_valid and sich >= 6000 and sich <= 6500) or
                             (funda_sich_valid and sich >= 4400 and sich <= 5000));
    crsp_industry_excluded=((not missing(unique_crsp_sic) and unique_crsp_sic >= 6000 and unique_crsp_sic <= 6500) or
                            (not missing(unique_crsp_sic) and unique_crsp_sic >= 4400 and unique_crsp_sic <= 5000));
    industry_unresolved=missing(industry_sic);
    industry_crsp_conflict=(not funda_sich_valid and distinct_valid_sics > 1);
    industry_crsp_exclusion_conflict=(not funda_sich_valid and distinct_valid_sics > 1 and
                                      min_crsp_exclusion ne max_crsp_exclusion);
    crsp_mult_same_screen=(not funda_sich_valid and distinct_valid_sics > 1 and
                                          min_crsp_exclusion=max_crsp_exclusion);
    industry_overlap_disagreement=(funda_sich_valid and distinct_valid_sics=1 and
                                   sich ne unique_crsp_sic);
    industry_exclusion_disagreement=(funda_sich_valid and distinct_valid_sics=1 and
                                     funda_industry_excluded ne crsp_industry_excluded);
run;
proc sql;
    select fyear, count(*) as source_rows,
           sum(funda_sich_valid) as funda_sich_valid_rows,
           sum(funda_sich_zero) as zero_sich_rows,
           sum(funda_sich_invalid_nonzero) as other_invalid_sich_rows,
           sum(funda_sich_invalid) as funda_sich_invalid_rows,
           sum(industry_source='CRSP_CCM_DATED') as dated_crsp_fallback_rows,
           sum(industry_crsp_conflict) as dated_crsp_conflicts,
           sum(industry_crsp_exclusion_conflict) as crsp_conflicts_crossing_screen,
           sum(crsp_mult_same_screen) as crsp_conflicts_same_screen,
           sum(industry_overlap_disagreement) as exact_sic_disagreements,
           sum(industry_exclusion_disagreement) as exclusion_decision_disagreements,
           sum(industry_unresolved) as still_unclassified,
           sum(missing(industry_screen_excluded)) as screen_status_unresolved
    from annual_industry
    where fyear >= 1976 and fyear <= 2001
    group by fyear
    order by fyear;
quit;

data secm_bounded;
    set comp.secm(keep=gvkey iid datadate primiss curcdm prccm ajexm
                  where=(datadate >= &reference_min_date and datadate <= &source_max_date));
    month_key = year(datadate)*100 + month(datadate);
    primiss_value = upcase(strip(primiss));
    iid_normalized=compress(upcase(strip(iid)),'-_ /');
    gvkey_normalized=compress(upcase(strip(gvkey)),'-_ /');
    format datadate yymmdd10.;
run;
proc freq data=secm_bounded;
    tables primiss_value / missing;
    title "Observed Compustat monthly primary/joiner markers in source-derived dates";
run;
data secm_primary;
    set secm_bounded;
    if primiss_value='P';
run;
proc sql;
    create table secm_primary_counts as
    select gvkey, month_key, count(*) as primary_count
    from secm_primary
    group by gvkey, month_key;
    create table secm_primary_duplicate_months as
    select count(*) as duplicate_company_months,
           coalesce(sum(primary_count-1),0) as extra_primary_rows
    from secm_primary_counts where primary_count > 1;
    create table annual_panel_norm as
    select a.*, compress(upcase(strip(a.beg_historical_iid)),'-_ /')
               as hiid_normalized length=24,
           compress(upcase(strip(a.gvkey)),'-_ /') as gvkey_normalized length=24
    from annual_industry as a;
    create table secm_hiid_candidates0 as
    select a.gvkey, a.datadate as current_datadate, a.fyear as current_fyear,
           a.beg_datadate, a.hiid_normalized, a.gvkey_normalized,
           s.iid, s.iid_normalized, s.datadate as monthly_issue_date,
           s.curcdm as monthly_issue_currency, s.prccm as monthly_issue_price,
           s.ajexm as monthly_adj_factor, s.primiss_value
    from annual_panel_norm as a inner join secm_bounded as s
      on a.gvkey=s.gvkey and a.beg_month_key=s.month_key
         and s.datadate <= a.beg_datadate;
    create table sec_history_bounded as
    select gvkey, iid, item, itemvalue, effdate, thrudate,
           compress(upcase(strip(iid)),'-_ /') as iid_normalized length=24,
           compress(upcase(strip(itemvalue)),'-_ /') as primary_value_normalized length=24
    from compsec.sec_history
    where item in ('PRIHISTUSA','PRIHISTCAN')
      and effdate <= &source_max_date
      and (thrudate >= &reference_min_date or missing(thrudate));
    create table history_hiid_candidates0 as
    select a.gvkey, a.datadate as current_datadate, a.fyear as current_fyear,
           a.beg_datadate, a.hiid_normalized, a.gvkey_normalized,
           h.iid, h.iid_normalized, h.item, h.itemvalue,
           h.primary_value_normalized, h.effdate, h.thrudate,
           (h.iid_normalized=h.primary_value_normalized) as iid_value_agrees
    from annual_panel_norm as a inner join sec_history_bounded as h
      on a.gvkey=h.gvkey and not missing(h.effdate) and h.effdate <= a.beg_datadate
         and (missing(h.thrudate) or h.thrudate >= a.beg_datadate);
quit;
proc sql;
    select count(*) as sec_history_rows,
           sum(missing(effdate)) as missing_from_dates,
           sum(effdate=.B) as dotb_from_dates,
           sum(effdate=.E) as dote_from_dates,
           sum(missing(thrudate)) as missing_thru_dates,
           sum(thrudate=.) as dot_thru_dates,
           sum(thrudate=.B) as dotb_thru_dates,
           sum(thrudate=.E) as dote_thru_dates
    from compsec.sec_history;
    select item, count(*) as primary_history_rows,
           sum(compress(upcase(strip(iid)),'-_ /') ne
               compress(upcase(strip(itemvalue)),'-_ /')) as iid_itemvalue_disagreements
    from compsec.sec_history
    where item in ('PRIHISTUSA','PRIHISTCAN')
    group by item;
quit;
data secm_hiid_candidates;
    set secm_hiid_candidates0;
    if missing(hiid_normalized) or missing(iid_normalized) then delete;
    hiid_match=0;
    if hiid_normalized=iid_normalized then hiid_match=1;
    else if lengthn(iid_normalized)>0 and lengthn(gvkey_normalized)>0 and
            lengthn(hiid_normalized)>=lengthn(iid_normalized) and
            lengthn(hiid_normalized)>=lengthn(gvkey_normalized) then do;
        if substr(hiid_normalized,1,lengthn(gvkey_normalized))=gvkey_normalized and
           substr(hiid_normalized,lengthn(hiid_normalized)-lengthn(iid_normalized)+1,
                  lengthn(iid_normalized))=iid_normalized then hiid_match=1;
    end;
    if not hiid_match then delete;
run;
data history_hiid_candidates;
    set history_hiid_candidates0;
    if missing(hiid_normalized) or missing(primary_value_normalized) then delete;
    hiid_match=0;
    if hiid_normalized=primary_value_normalized then hiid_match=1;
    else if lengthn(primary_value_normalized)>0 and lengthn(gvkey_normalized)>0 and
            lengthn(hiid_normalized)>=lengthn(primary_value_normalized) and
            lengthn(hiid_normalized)>=lengthn(gvkey_normalized) then do;
        if substr(hiid_normalized,1,lengthn(gvkey_normalized))=gvkey_normalized and
           substr(hiid_normalized,lengthn(hiid_normalized)-lengthn(primary_value_normalized)+1,
                  lengthn(primary_value_normalized))=primary_value_normalized then hiid_match=1;
    end;
    if not hiid_match then delete;
run;
proc freq data=history_hiid_candidates;
    tables item / missing;
    title "SEC_HISTORY historical primary-item evidence on HIID-matched dates";
run;
proc sql;
    create table secm_hiid_counts as
    select gvkey, current_datadate, current_fyear,
           count(*) as hiid_month_rows, count(distinct iid) as hiid_month_iids,
           sum(primiss_value='P') as hiid_month_p_rows,
           sum(primiss_value='J') as hiid_month_j_rows
    from secm_hiid_candidates
    group by gvkey, current_datadate, current_fyear;
    create table secm_hiid_unique as
    select a.*
    from secm_hiid_candidates as a inner join secm_hiid_counts as b
      on a.gvkey=b.gvkey and a.current_datadate=b.current_datadate
         and a.current_fyear=b.current_fyear
    where b.hiid_month_rows=1 and b.hiid_month_iids=1;
    create table history_hiid_counts as
    select gvkey, current_datadate, current_fyear,
           count(*) as sec_history_rows, count(distinct itemvalue) as sec_history_iids,
           count(distinct item) as sec_history_item_types,
           sum(iid_value_agrees=0) as sec_hist_iid_disagree
    from history_hiid_candidates
    group by gvkey, current_datadate, current_fyear;
    create table history_hiid_unique as
    select gvkey, current_datadate, current_fyear,
           min(itemvalue) as history_issue_iid length=4
    from history_hiid_candidates
    group by gvkey, current_datadate, current_fyear
    having count(distinct itemvalue)=1;
    create table annual_issue0 as
    select a.*, s.iid as monthly_hiid_iid,
           s.monthly_issue_currency, s.monthly_issue_price, s.monthly_issue_date,
           s.monthly_adj_factor, s.primiss_value as hiid_month_primiss,
           coalesce(sc.hiid_month_rows,0) as hiid_month_rows,
           coalesce(sc.hiid_month_iids,0) as hiid_month_iids,
           coalesce(sc.hiid_month_p_rows,0) as hiid_month_p_rows,
           coalesce(sc.hiid_month_j_rows,0) as hiid_month_j_rows,
           coalesce(hc.sec_history_rows,0) as sec_history_rows,
           coalesce(hc.sec_history_iids,0) as sec_history_iids,
           coalesce(hc.sec_history_item_types,0) as sec_history_item_types,
           coalesce(hc.sec_hist_iid_disagree,0) as sec_hist_iid_disagree,
           hu.history_issue_iid,
           coalesce(pc.primary_count,0) as company_month_p_count
    from annual_panel_norm as a
    left join secm_hiid_unique as s
      on a.gvkey=s.gvkey and a.datadate=s.current_datadate and a.fyear=s.current_fyear
    left join secm_hiid_counts as sc
      on a.gvkey=sc.gvkey and a.datadate=sc.current_datadate and a.fyear=sc.current_fyear
    left join history_hiid_counts as hc
      on a.gvkey=hc.gvkey and a.datadate=hc.current_datadate and a.fyear=hc.current_fyear
    left join history_hiid_unique as hu
      on a.gvkey=hu.gvkey and a.datadate=hu.current_datadate and a.fyear=hu.current_fyear
    left join secm_primary_counts as pc
      on a.gvkey=pc.gvkey and a.beg_month_key=pc.month_key;
quit;
data annual_primary;
    set annual_issue0;
    length beg_primary_iid $4 price_currency $3 price_currency_source $24;
    length historical_issue_status $28;
    length primary_iid_normalized $24;
    beg_primary_iid='';
    historical_iid_available=(not missing(beg_historical_iid));
    historical_issue_verified=0;
    hiid_month_marker_conflict=(hiid_month_primiss='J');
    if sec_history_iids=1 and not missing(history_issue_iid) then do;
        if not missing(monthly_hiid_iid) and history_issue_iid ne monthly_hiid_iid then do;
            historical_issue_status='SEC_HISTORY/SECM conflict';
        end;
        else if hiid_month_marker_conflict then do;
            historical_issue_status='HIID marked joiner';
        end;
        else do;
            beg_primary_iid=history_issue_iid;
            historical_issue_verified=1;
            if not missing(monthly_hiid_iid) then historical_issue_status='SEC_HISTORY and SECM agree';
            else historical_issue_status='SEC_HISTORY dated HIID';
        end;
    end;
    else if sec_history_iids=0 and hiid_month_iids=1 and
            hiid_month_rows=1 and hiid_month_primiss='P' then do;
        beg_primary_iid=monthly_hiid_iid;
        historical_issue_verified=1;
        historical_issue_status='dated HIID SECM P';
    end;
    else if sec_history_iids > 1 or hiid_month_iids > 1 then
        historical_issue_status='dated HIID conflict';
    else historical_issue_status='no dated HIID evidence';
    primary_iid_normalized=compress(upcase(strip(beg_primary_iid)),'-_ /');
    hiid_exact_match=0;
    hiid_global_match=0;
    if not missing(primary_iid_normalized) then do;
        if hiid_normalized=primary_iid_normalized then hiid_exact_match=1;
        if lengthn(primary_iid_normalized)>0 and lengthn(gvkey_normalized)>0 and
           lengthn(hiid_normalized)>=lengthn(primary_iid_normalized) and
           lengthn(hiid_normalized)>=lengthn(gvkey_normalized) then do;
            if substr(hiid_normalized,1,lengthn(gvkey_normalized))=gvkey_normalized and
               substr(hiid_normalized,lengthn(hiid_normalized)-lengthn(primary_iid_normalized)+1,
                      lengthn(primary_iid_normalized))=primary_iid_normalized then
                hiid_global_match=1;
        end;
    end;
    if historical_issue_verified=1 and hiid_month_marker_conflict=0 and
       not missing(monthly_issue_currency) then do;
        monthly_price_currency=upcase(strip(monthly_issue_currency));
        monthly_primary_price=monthly_issue_price;
        monthly_primary_date=monthly_issue_date;
        monthly_adjustment_factor=monthly_adj_factor;
    end;
    else do;
        monthly_price_currency='';
        monthly_primary_price=.;
        monthly_primary_date=.;
        monthly_adjustment_factor=.;
    end;
run;

/* Compare local annual FUNDA.PRCC_F with dated security daily/monthly values on
   the verified HIID. These are product/date/factor diagnostics only. */
data dprc_bounded;
    set compsec.sec_dprc(keep=gvkey iid datadate curcdd prccd ajexdi
                      where=(datadate >= &reference_min_date and datadate <= &source_max_date));
    month_key = year(datadate)*100 + month(datadate);
    format datadate yymmdd10.;
run;
proc sql;
    create table dprc_key_counts as
    select gvkey, iid, datadate, count(*) as quote_rows
    from dprc_bounded
    group by gvkey, iid, datadate;
    create table dprc_unique as
    select a.*
    from dprc_bounded as a inner join dprc_key_counts as b
      on a.gvkey=b.gvkey and a.iid=b.iid and a.datadate=b.datadate
    where b.quote_rows=1;
    create table quote_dates as
    select a.gvkey, a.datadate as current_datadate, a.fyear as current_fyear,
           max(d.datadate) as beg_price_quote_date format=yymmdd10.
    from annual_primary as a inner join dprc_unique as d
      on a.gvkey=d.gvkey and a.beg_primary_iid=d.iid
         and a.beg_month_key=d.month_key and d.datadate <= a.beg_datadate
    where a.historical_issue_verified=1 and a.hiid_month_marker_conflict=0
    group by a.gvkey, a.datadate, a.fyear;
    create table annual_price_check0 as
    select a.*, q.beg_price_quote_date,
           d.curcdd as beg_price_currency, d.prccd as dated_daily_close,
           d.ajexdi as dated_daily_adj_factor,
           case when not missing(a.monthly_price_currency) and not missing(d.curcdd)
                     and upcase(strip(a.monthly_price_currency))=upcase(strip(d.curcdd))
                then 1 else 0 end as daily_monthly_currency_agrees
    from annual_primary as a
    left join quote_dates as q
      on a.gvkey=q.gvkey and a.datadate=q.current_datadate and a.fyear=q.current_fyear
    left join dprc_unique as d
      on a.gvkey=d.gvkey and a.beg_primary_iid=d.iid
         and q.beg_price_quote_date=d.datadate;
    create table dprc_duplicate_keys as
    select count(*) as duplicate_issue_dates,
           coalesce(sum(quote_rows-1),0) as extra_daily_quote_rows
    from dprc_key_counts where quote_rows > 1;
quit;
data annual_price_check;
    set annual_price_check0;
    quote_age_days=beg_datadate-beg_price_quote_date;
    daily_close_adjusted=.;
    monthly_price_adjusted=.;
    if not missing(dated_daily_close) and not missing(dated_daily_adj_factor) and
       dated_daily_adj_factor > 0 then
        daily_close_adjusted=dated_daily_close/dated_daily_adj_factor;
    if not missing(monthly_primary_price) and not missing(monthly_adjustment_factor) and
       monthly_adjustment_factor > 0 then
        monthly_price_adjusted=monthly_primary_price/monthly_adjustment_factor;
    daily_adj_rel_diff=.; month_rel_diff=.; month_adj_rel_diff=.;
    match_daily_adj=0; match_monthly=0; match_monthly_adj=0;
    if not missing(beg_prcc_f) and not missing(daily_close_adjusted) and daily_close_adjusted ne 0 then do;
        daily_adj_rel_diff=abs(beg_prcc_f-daily_close_adjusted)/abs(daily_close_adjusted);
        if abs(beg_prcc_f-daily_close_adjusted) <= max(0.0001,abs(daily_close_adjusted)*0.0005)
            then match_daily_adj=1;
    end;
    if not missing(beg_prcc_f) and not missing(monthly_primary_price) and monthly_primary_price ne 0 then do;
        month_rel_diff=abs(beg_prcc_f-monthly_primary_price)/abs(monthly_primary_price);
        if abs(beg_prcc_f-monthly_primary_price) <= max(0.0001,abs(monthly_primary_price)*0.0005)
            then match_monthly=1;
    end;
    if not missing(beg_prcc_f) and not missing(monthly_price_adjusted) and monthly_price_adjusted ne 0 then do;
        month_adj_rel_diff=abs(beg_prcc_f-monthly_price_adjusted)/abs(monthly_price_adjusted);
        if abs(beg_prcc_f-monthly_price_adjusted) <= max(0.0001,abs(monthly_price_adjusted)*0.0005)
            then match_monthly_adj=1;
    end;
    dated_price_currency_available=
        (historical_issue_verified=1 and not missing(beg_price_quote_date) and
         not missing(beg_price_currency));
    length price_currency $3 price_currency_source $24;
    if dated_price_currency_available then do;
        price_currency=upcase(strip(beg_price_currency));
        price_currency_source='HIID_daily_CURCDD';
        price_fx_date=beg_price_quote_date;
    end;
    else if historical_issue_verified=1 and hiid_month_marker_conflict=0 and
            not missing(monthly_price_currency) then do;
        price_currency=upcase(strip(monthly_price_currency));
        price_currency_source='HIID_monthly_CURCDM';
        /* Monthly CURCDM establishes the denomination only. The annual
           FUNDA.PRCC_F is converted at the annual fiscal-close point date. */
        price_fx_date=beg_datadate;
    end;
    else do;
        price_currency='';
        price_currency_source='unavailable';
        price_fx_date=.;
    end;
    annual_price_matches_daily=0;
    annual_price_relative_difference=.;
    annual_daily_price_comparable=0;
    annual_monthly_price_comparable=0;
    daily_monthly_price_comparable=0;
    annual_daily_price_mismatch=0;
    ann_dly_mismatch_mth_match=0;
    annual_price_matches_monthly=0;
    daily_monthly_price_matches=0;
    if not missing(beg_prcc_f) and not missing(dated_daily_close) and dated_daily_close ne 0 then do;
        annual_daily_price_comparable=1;
        annual_price_relative_difference=abs(beg_prcc_f-dated_daily_close)/abs(dated_daily_close);
        if abs(beg_prcc_f-dated_daily_close) <= 0.0001
            then annual_price_matches_daily=1;
        else annual_daily_price_mismatch=1;
    end;
    if not missing(beg_prcc_f) and not missing(monthly_primary_price) then do;
        annual_monthly_price_comparable=1;
        if abs(beg_prcc_f-monthly_primary_price) <= 0.0001
            then annual_price_matches_monthly=1;
    end;
    if not missing(dated_daily_close) and not missing(monthly_primary_price) then do;
        daily_monthly_price_comparable=1;
        if abs(dated_daily_close-monthly_primary_price) <= 0.0001
            then daily_monthly_price_matches=1;
    end;
    if annual_daily_price_mismatch=1 and annual_price_matches_monthly=1 then
        ann_dly_mismatch_mth_match=1;
run;
proc sql;
    select count(*) as hiid_monthly_unique_rows from secm_hiid_unique;
    select * from secm_primary_duplicate_months;
    select * from dprc_duplicate_keys;
quit;
proc means data=annual_price_check n nmiss mean sum min p50 p99 max;
    var historical_iid_available hiid_exact_match hiid_global_match
        historical_issue_verified sec_history_rows sec_history_iids sec_history_item_types
        hiid_month_rows hiid_month_p_rows hiid_month_j_rows company_month_p_count
        hiid_month_marker_conflict quote_age_days dated_price_currency_available
        annual_daily_price_comparable annual_daily_price_mismatch
        ann_dly_mismatch_mth_match annual_monthly_price_comparable
        annual_price_matches_monthly daily_monthly_price_comparable
        daily_monthly_price_matches annual_price_matches_daily
        match_daily_adj match_monthly match_monthly_adj daily_monthly_currency_agrees;
    title "HIID dated-history, marker, quote-date, price-factor and currency evidence";
run;
proc means data=annual_price_check n nmiss mean p50 p99 max;
    var annual_price_relative_difference daily_adj_rel_diff month_rel_diff month_adj_rel_diff
        dated_daily_adj_factor monthly_adjustment_factor;
    title "Annual FUNDA PRCC_F versus security price products; factor adjustment is diagnostic only";
run;

/* The documented GBP-based cross-rates are made unique without choosing a
   maximum: conflicting rates for a date/currency are made unavailable. */
data fx_month_source;
    set compfx.g_exrt_mth(keep=datadate fromcurm tocurm exrat12m);
    if upcase(strip(fromcurm)) ne 'GBP' then delete;
    if datadate < &reference_min_date or datadate > &source_max_date then delete;
    fx_month_key = year(datadate)*100 + month(datadate);
    currency = upcase(strip(tocurm));
    format datadate yymmdd10.;
run;
proc sql;
    create table fx_month_summary as
    select fx_month_key, currency, count(*) as row_count,
           count(exrat12m) as n12, min(exrat12m) as min12, max(exrat12m) as max12
    from fx_month_source
    group by fx_month_key, currency;
quit;
data fx_month_rates;
    set fx_month_summary;
    if n12 > 0 and min12=max12 then gbp_to_currency_12m=min12;
    else gbp_to_currency_12m=.;
    conflict12=(n12>1 and min12 ne max12);
run;
proc sql;
    create table fx_daily_source as
    select datadate, fromcurd, tocurd, exratd, exrattpd
    from compfx.g_exrt_dly
    where upcase(strip(fromcurd))='GBP'
      and datadate >= &reference_min_date and datadate <= &source_max_date;
    create table fx_daily_summary as
    select datadate, upcase(strip(tocurd)) as currency length=3,
           count(*) as row_count, count(exratd) as nrate,
           min(exratd) as minrate, max(exratd) as maxrate
    from fx_daily_source
    group by datadate, calculated currency;
quit;
data fx_daily_rates;
    set fx_daily_summary;
    if nrate > 0 and minrate=maxrate then gbp_to_currency_daily=minrate;
    else gbp_to_currency_daily=.;
    rate_conflict=(nrate>1 and minrate ne maxrate);
run;
proc freq data=fx_daily_source;
    tables exrattpd / missing;
    title "Daily FX provenance retained for audit; no type-based exclusion";
run;
proc sql;
    select sum(conflict12) as nconflict12_months
    from fx_month_rates;
    select sum(row_count>1) as duplicate_currency_month_keys,
           sum(row_count-1) as extra_currency_month_rows
    from fx_month_rates;
    select sum(rate_conflict) as conflicting_daily_currency_dates
    from fx_daily_rates;
    select sum(row_count>1) as duplicate_daily_currency_dates,
           sum(row_count-1) as extra_daily_currency_rows
    from fx_daily_rates;
quit;

/* Flow values use EXRAT12M at the statement month. Annual PRCC_F uses point-date
   EXRATD: the historical issue's daily quote date when available, otherwise
   the annual fiscal-close date. USD is an identity map. */
proc sql;
    create table annual_with_rates as
    select a.*, fr.gbp_to_currency_12m as gbp_to_flow_currency_12m,
           fu.gbp_to_currency_12m as gbp_to_usd_flow_12m,
           pr.gbp_to_currency_daily as gbp_to_price_currency_daily,
           pu.gbp_to_currency_daily as gbp_to_usd_price_daily,
           fr.conflict12 as flow_rate_conflict,
           pr.rate_conflict as price_rate_conflict
    from annual_price_check as a
    left join fx_month_rates as fr
      on a.flow_month_key=fr.fx_month_key
         and upcase(strip(a.curcd))=fr.currency
    left join fx_month_rates as fu
      on a.flow_month_key=fu.fx_month_key and fu.currency='USD'
    left join fx_daily_rates as pr
      on a.price_fx_date=pr.datadate
         and upcase(strip(a.price_currency))=pr.currency
    left join fx_daily_rates as pu
      on a.price_fx_date=pu.datadate and pu.currency='USD';
quit;
data annual_screen;
    set annual_with_rates;
    length flow_currency $3 classifier_currency_basis $24;
    flow_currency = upcase(strip(curcd));
    /* Price currency is supported only by the verified HIID's dated daily or
       monthly security record; annual accounting CURCD is not a price proxy. */
    if flow_currency='USD' then fx_flow_usd=1;
    else if gbp_to_flow_currency_12m > 0 and gbp_to_usd_flow_12m > 0 and
            flow_rate_conflict ne 1
        then fx_flow_usd=gbp_to_usd_flow_12m / gbp_to_flow_currency_12m;
    else fx_flow_usd=.;
    if price_currency='USD' then fx_price_usd=1;
    else if price_currency_source='HIID_daily_CURCDD' and
            gbp_to_price_currency_daily > 0 and gbp_to_usd_price_daily > 0 and
            price_rate_conflict ne 1
        then fx_price_usd=gbp_to_usd_price_daily / gbp_to_price_currency_daily;
    else fx_price_usd=.;

    prespc = pi - spi;
    source_industry_excluded = (industry_screen_excluded=1);
    industry_screen_unres = missing(industry_screen_excluded);
    source_earnings_complete = (nmiss(ni,pi,spi)=0);
    beginning_mve_available = (not missing(beg_csho) and beg_csho > 0 and
                               not missing(beg_prcc_f) and beg_prcc_f > 0 and
                               historical_issue_verified=1 and
                               not missing(price_currency));
    annual_flow_currency_available = (not missing(flow_currency) and
                                      not missing(fx_flow_usd));
    flow_price_currency_mismatch =
        (not missing(flow_currency) and not missing(price_currency) and
         flow_currency ne price_currency);
    classifier_currency_available = (not missing(price_currency) and
        (flow_currency=price_currency or not missing(fx_price_usd)));
    source_population = (source_industry_excluded=0);
    source_fields_available = (source_earnings_complete=1 and
                               beginning_mve_available=1 and
                               annual_flow_currency_available=1 and
                               classifier_currency_available=1);
    if source_fields_available then do;
        ni_usd = ni * fx_flow_usd;
        pretax_usd = pi * fx_flow_usd;
        special_usd = spi * fx_flow_usd;
        prespc_usd = pretax_usd - special_usd;
        mve0_local = beg_csho * beg_prcc_f;
        if not missing(fx_price_usd) then mve0_usd=mve0_local*fx_price_usd;
        else mve0_usd=.;
        if mve0_local > 0 then do;
            if flow_currency=price_currency then do;
                classifier_currency_basis='native_same_currency';
                ni_scaled=ni/mve0_local;
                pretax_scaled=pi/mve0_local;
                prespc_scaled=prespc/mve0_local;
            end;
            else if mve0_usd > 0 then do;
                classifier_currency_basis='usd_mixed_currency';
                ni_scaled=ni_usd/mve0_usd;
                pretax_scaled=pretax_usd/mve0_usd;
                prespc_scaled=prespc_usd/mve0_usd;
            end;
        end;
        else source_fields_available=0;
    end;
    else do;
        ni_usd=.; pretax_usd=.; special_usd=.; prespc_usd=.;
        mve0_local=.; mve0_usd=.; ni_scaled=.; pretax_scaled=.;
        prespc_scaled=.;
    end;
    format datadate beg_datadate beg_price_quote_date monthly_primary_date yymmdd10.;
run;

proc freq data=annual_screen;
    tables fyear*curcd fyear*price_currency curcd*price_currency
           flow_price_currency_mismatch classifier_currency_basis / missing;
    title "Currency coverage, same-currency ratios, and mixed-currency classifier basis";
run;
proc means data=annual_screen n nmiss mean p1 p50 p99 max;
    var fiscal_gap_days historical_iid_available hiid_exact_match hiid_global_match
        industry_unresolved industry_screen_unres
        annual_price_matches_daily
        dated_price_currency_available daily_monthly_currency_agrees;
    title "Beginning-year timing, historical issue, industry, and price validation";
run;
proc means data=annual_screen n nmiss min p1 p50 p99 max;
    var fx_flow_usd fx_price_usd mve0_local mve0_usd;
    title "Annual flow and exact-price-date conversion factors and market values";
run;
proc freq data=annual_screen;
    tables flow_currency*fx_flow_usd price_currency*fx_price_usd
           price_currency_source / missing;
    title "Observed reporting/price currencies and supported USD conversion";
run;
proc sql;
    select count(*) as n_quote_currency_pairs,
           sum(upcase(strip(beg_statement_currency))=upcase(strip(beg_price_currency)))
               as n_prior_curcd_agree,
           sum(upcase(strip(curcd))=upcase(strip(beg_price_currency)))
               as n_curr_curcd_agree
    from annual_price_check
    where dated_price_currency_available=1 and historical_issue_verified=1;
quit;

/* Apply the source-defined common screens. PCTLDEF=5 and strict tail deletion
   are source-silent conventions; exact zeros follow the annual tail deletion. */
data valid_for_tails;
    set annual_screen;
    if fyear >= 1976 and fyear <= 2001;
    if source_population and source_fields_available;
    if nmiss(ni_scaled,pretax_scaled,prespc_scaled)=0;
run;
proc sort data=valid_for_tails;
    by fyear;
run;
proc means data=valid_for_tails noprint pctlDEF=5;
    by fyear;
    var ni_scaled pretax_scaled prespc_scaled;
    output out=annual_cutoffs(drop=_type_ _freq_)
        p1=ni_p1 pretax_p1 prespc_p1
        p99=ni_p99 pretax_p99 prespc_p99;
run;
data tail_all;
    merge valid_for_tails(in=in_sample) annual_cutoffs;
    by fyear;
    if in_sample;
    outlier_tail = (ni_scaled < ni_p1 or ni_scaled > ni_p99 or
                    pretax_scaled < pretax_p1 or pretax_scaled > pretax_p99 or
                    prespc_scaled < prespc_p1 or prespc_scaled > prespc_p99);
    exact_zero = (ni=0 or pi=0 or prespc=0);
    common_sample = (outlier_tail=0 and exact_zero=0);
run;
data out.earnings_distribution;
    set tail_all;
    if common_sample;

    /* Lower-inclusive, upper-exclusive boundaries implement six 0.005-wide
       intervals on either side of zero. */
    pretax_l=0; pretax_sl=0; pretax_sp=0; pretax_p=0;
    prespc_l=0; prespc_sl=0; prespc_sp=0; prespc_p=0;
    if pretax_scaled < -0.03 then pretax_l=pretax_usd;
    else if pretax_scaled < 0 then pretax_sl=pretax_usd;
    else if pretax_scaled < 0.03 then pretax_sp=pretax_usd;
    else pretax_p=pretax_usd;
    if prespc_scaled < -0.03 then prespc_l=prespc_usd;
    else if prespc_scaled < 0 then prespc_sl=prespc_usd;
    else if prespc_scaled < 0.03 then prespc_sp=prespc_usd;
    else prespc_p=prespc_usd;
    sample_common=1;
    label
        ni_usd='Net income (USD millions)'
        pretax_usd='Pretax income (USD millions)'
        special_usd='Special items (USD millions)'
        prespc_usd='Income before special items (USD millions)'
        mve0_usd='Beginning market value (USD millions)'
        ni_scaled='Net income / beginning market value'
        pretax_scaled='Pretax income / beginning market value'
        prespc_scaled='Income before special items / beginning market value'
        pretax_l='Pretax income in loss region (USD millions)'
        pretax_sl='Pretax income in small-loss region (USD millions)'
        pretax_sp='Pretax income in small-profit region (USD millions)'
        pretax_p='Pretax income in profit region (USD millions)'
        prespc_l='Income before special items in loss region (USD millions)'
        prespc_sl='Income before special items in small-loss region (USD millions)'
        prespc_sp='Income before special items in small-profit region (USD millions)'
        prespc_p='Income before special items in profit region (USD millions)';
    format datadate beg_datadate beg_price_quote_date monthly_primary_date yymmdd10.;
run;

proc sql;
    create table annual_attrition as
    select fyear, count(*) as selected_funda_rows,
           sum(missing(sich)) as missing_sich_rows,
           sum(funda_sich_zero) as zero_sich_rows,
           sum(funda_sich_invalid_nonzero) as other_invalid_sich_rows,
           sum(funda_sich_valid) as valid_sich_rows,
           sum(industry_source='CRSP_CCM_DATED') as dated_crsp_unique_fallback_rows,
           sum(industry_crsp_conflict) as dated_crsp_exact_code_conflicts,
           sum(industry_crsp_exclusion_conflict) as dated_crsp_screen_conflicts,
           sum(crsp_mult_same_screen) as dated_crsp_same_screen_conflicts,
           sum(industry_overlap_disagreement) as valid_sich_crsp_exact_diff,
           sum(industry_exclusion_disagreement) as valid_sich_crsp_screen_diff,
           sum(industry_unresolved) as exact_industry_unresolved,
           sum(industry_screen_unres) as screen_status_unresolved,
           sum(source_industry_excluded) as excluded_source_sic,
           sum(source_earnings_complete) as earnings_complete,
           sum(historical_issue_verified) as historical_issue_verified,
           sum(price_currency_source='HIID_daily_CURCDD') as price_currency_daily_source,
           sum(price_currency_source='HIID_monthly_CURCDM') as price_currency_monthly_source,
           sum(price_currency_source='unavailable') as price_currency_unavailable,
           sum(annual_daily_price_comparable) as annual_daily_price_comparable,
           sum(annual_daily_price_mismatch) as annual_daily_price_mismatches,
           sum(ann_dly_mismatch_mth_match) as ann_dly_mismatch_mth_match,
           sum(annual_monthly_price_comparable) as annual_monthly_price_comparable,
           sum(annual_price_matches_monthly) as annual_monthly_exact_matches,
           sum(daily_monthly_price_comparable) as daily_monthly_price_comparable,
           sum(daily_monthly_price_matches) as daily_monthly_exact_matches,
           sum(dated_price_currency_available) as dated_price_currency_available,
           sum(beginning_mve_available) as beginning_mve_available,
           sum(annual_flow_currency_available) as flow_usd_conversion_available,
           sum(classifier_currency_available) as classifier_currency_available,
           sum(source_fields_available) as source_inputs_complete
    from annual_screen
    where fyear >= 1976 and fyear <= 2001
    group by fyear;
    create table tail_zero_attrition as
    select fyear, count(*) as eligible_before_tail,
           sum(outlier_tail) as removed_annual_tails,
           sum(case when outlier_tail=0 and exact_zero=1 then 1 else 0 end)
               as exact_zero_after_tails,
           sum(common_sample) as retained_common_sample
    from tail_all
    group by fyear;
    create table output_key_duplicates as
    select gvkey, datadate, count(*) as duplicate_count
    from out.earnings_distribution
    group by gvkey, datadate
    having calculated duplicate_count > 1;
quit;
proc print data=annual_attrition noobs;
    title "Annual source sample and field/issue/currency-availability attrition";
run;
proc print data=tail_zero_attrition noobs;
    title "Annual trimming followed by exact-zero exclusion";
run;
proc means data=out.earnings_distribution n nmiss mean stddev min p1 p50 p99 max;
    var ni_usd pretax_usd prespc_usd pretax_l pretax_sl pretax_sp pretax_p
        prespc_l prespc_sl prespc_sp prespc_p ni_scaled pretax_scaled
        prespc_scaled mve0_usd;
    title "Final handoff distribution of raw regression values and scaled classifiers";
run;
proc means data=out.earnings_distribution n nmiss min p1 p50 p99 max;
    var fiscal_gap_days fx_flow_usd fx_price_usd;
    title "Final handoff denominator timing and conversion factor checks";
run;
proc freq data=out.earnings_distribution;
    tables fyear*flow_currency fyear*price_currency classifier_currency_basis / missing;
    title "Final handoff support by fiscal year, flow currency, price currency, and classifier basis";
run;
proc sql;
    select count(*) as output_rows,
           count(distinct gvkey) as companies,
           count(distinct fyear) as fiscal_years,
           sum(abs(pretax_usd-(pretax_l+pretax_sl+pretax_sp+pretax_p)) > 1e-8)
               as bad_panel_a_partition,
           sum(abs(prespc_usd-(prespc_l+prespc_sl+prespc_sp+prespc_p)) > 1e-8)
               as bad_panel_b_partition
    from out.earnings_distribution;
    select count(*) as duplicate_keys from output_key_duplicates;
quit;
proc contents data=out.earnings_distribution;
    title "Native SAS handoff schema";
run;
