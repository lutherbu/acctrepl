options errorabend;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname compsec "/storage/sas/base/comp/d_na/security" access=readonly;
libname sdc "/storage/sas/base/tfn/sdc_ni" access=readonly;

/* Bounded 1987-89 audit; emits only grouped counts and date distributions. */
data sdc_early;
    set sdc.wrds_ni_details(
        where=(master_deal_date >= '01JAN1987'd and master_deal_date <= '31DEC1989'd)
        keep=master_deal_no master_deal_date filingdate postponed_date withdrawn_date
             withdrawn_date2 security ipo nation currency listmain offerpric description
             businesss spinninames spinafter spinbefore simoffcus cusip cusip9
    );
    length offer_price_num 8 issue_year 8 offer_cusip $20 sdc_cusip6 $6 sdc_cusip9 $9;
    offer_price_num = input(compress(strip(offerpric), '$, '), ?? best32.);
    issue_year = year(master_deal_date);
    offer_cusip = compress(strip(cusip), ' -');
    if lengthn(offer_cusip) >= 6 then sdc_cusip6 = substr(offer_cusip, 1, 6);
    else call missing(sdc_cusip6);
    offer_cusip = compress(strip(cusip9), ' -');
    if lengthn(offer_cusip) = 9 then sdc_cusip9 = offer_cusip;
    else call missing(sdc_cusip9);
    issue_status = (not missing(master_deal_date)
                    and missing(postponed_date)
                    and missing(withdrawn_date)
                    and missing(withdrawn_date2));
    has_spin = (not missing(spinninames) or not missing(spinafter)
                or not missing(spinbefore));
    has_simul = not missing(simoffcus);
    has_rights = (index(upcase(description), 'RIGHT') > 0
                  or index(upcase(description), 'STANDBY') > 0
                  or index(upcase(description), 'UNIT') > 0);
    has_reverse_lbo = (index(upcase(description), 'REVERSE LBO') > 0
                       or index(upcase(description), 'REVERSE LEVERAGED') > 0
                       or index(upcase(businesss), 'REVERSE LBO') > 0);
    is_fund_text = (index(upcase(description), 'CLOSED-END') > 0
                    or index(upcase(description), 'CLOSED END') > 0
                    or index(upcase(description), 'UNIT TRUST') > 0
                    or index(upcase(description), 'LIMITED PARTNERSHIP') > 0
                    or index(upcase(description), 'REIT') > 0
                    or index(upcase(businesss), 'UNIT TRUST') > 0
                    or index(upcase(businesss), 'LIMITED PARTNERSHIP') > 0
                    or index(upcase(businesss), 'REAL ESTATE INVESTMENT TRUST') > 0);
    target_base = (security = 'Common Shares'
                   and ipo = 'No'
                   and nation = 'United States');
    target_market = (currency = 'US'
                     and listmain in ('NYSE','NASDQ','AMEX'));
    target_price = (offer_price_num >= 5);
    target_event = (target_base and target_market and target_price
                    and issue_status and not has_spin and not has_simul
                    and not has_rights and not has_reverse_lbo and not is_fund_text
                    and not missing(filingdate) and not missing(sdc_cusip6));
    issue_age_days = master_deal_date - filingdate;
    format master_deal_date filingdate postponed_date withdrawn_date withdrawn_date2 date9.;
run;

proc sql;
    title "1987-1989 U.S. common-share exchange candidates: filing-date checks";
    select issue_year,
           count(*) as base_candidates,
           sum(missing(filingdate)) as missing_filingdate,
           sum(filingdate=.B) as filingdate_B,
           sum(filingdate=.E) as filingdate_E,
           sum(filingdate > master_deal_date) as filing_after_issue,
           sum(filingdate = master_deal_date) as same_day_filing_issue,
           sum(filingdate < '01JAN1982'd) as filing_before_1982,
           min(filingdate) format=date9. as min_filingdate,
           max(filingdate) format=date9. as max_filingdate
    from sdc_early
    where target_base and target_market
    group by issue_year
    order by issue_year;

    title "1987-1989 current target screen and dated links";
    create table target as select * from sdc_early where target_event;
    select issue_year, count(*) as target_events,
           min(filingdate) format=date9. as min_filingdate,
           max(filingdate) format=date9. as max_filingdate,
           sum(issue_age_days < 0) as negative_issue_age,
           sum(issue_age_days = 0) as zero_issue_age
    from target group by issue_year order by issue_year;
quit;

proc sort data=target; by issue_year; run;
proc means data=target n mean min p1 p25 median p75 p99 max;
    by issue_year;
    var issue_age_days;
run;

/* Recreate only the source-date CUSIP links for these target events. */
data secid_early;
    set compsec.sec_idhist(keep=gvkey iid item itemvalue efffrom effthru);
    if strip(upcase(item)) = 'CUSIP'
       and (missing(efffrom) or efffrom <= '31DEC1989'd)
       and (missing(effthru) or effthru >= '01JAN1987'd);
    length hist_cusip $20 hist_cusip6 $6;
    hist_cusip = compress(strip(itemvalue), ' -');
    if lengthn(hist_cusip) >= 6 then hist_cusip6 = substr(hist_cusip, 1, 6);
    else call missing(hist_cusip6);
run;

proc sql;
    create table link_pairs as
    select t.master_deal_no, t.issue_year, t.master_deal_date, t.filingdate,
           t.issue_age_days, t.sdc_cusip6, t.sdc_cusip9,
           c.gvkey, c.iid, c.efffrom, c.effthru,
           (not missing(t.sdc_cusip9)
            and t.sdc_cusip9=substr(c.hist_cusip,1,9)) as exact9
    from target as t inner join secid_early as c
      on c.hist_cusip6=t.sdc_cusip6
     and (c.efffrom <= t.master_deal_date or c.efffrom=.B or c.efffrom=.)
     and (c.effthru >= t.master_deal_date or c.effthru=.E or c.effthru=.);
    create table link_exact as
    select master_deal_no, max(exact9) as has_exact9
    from link_pairs group by master_deal_no;
    create table issue_link as
    select p.master_deal_no,
           count(distinct p.gvkey) as n_gvkeys,
           min(p.gvkey) as gvkey,
           max(p.exact9) as exact9
    from link_pairs as p inner join link_exact as q
      on p.master_deal_no=q.master_deal_no
     and (q.has_exact9=0 or p.exact9=1)
    group by p.master_deal_no;
    create table target_link as
    select t.*, l.gvkey, l.n_gvkeys, l.exact9
    from target as t left join issue_link as l
      on t.master_deal_no=l.master_deal_no;
    create table selected_gvkeys as
    select distinct issue_year, gvkey
    from target_link where n_gvkeys=1;
    title "1987-1989 target link coverage";
    select issue_year, count(*) as target_events,
           sum(n_gvkeys=1) as unique_gvkey,
           sum(n_gvkeys>1) as ambiguous_gvkey,
           sum(missing(n_gvkeys)) as no_dated_gvkey
    from target_link group by issue_year order by issue_year;
quit;

/* Bound raw history through FY1989 for only the date-linked target GVKEYs. */
data comp_raw_pre90;
    set comp.funda(keep=gvkey fyear datadate where=(fyear <= 1989));
    if not missing(gvkey) and not missing(fyear) and not missing(datadate);
    format datadate date9.;
run;
proc sql;
    create table raw_bounds as
    select s.issue_year, s.gvkey,
           count(r.fyear) as raw_rows_through_1989,
           min(r.fyear) as raw_first_fyear,
           max(r.fyear) as raw_last_fyear,
           min(r.datadate) format=date9. as raw_first_datadate,
           max(r.datadate) format=date9. as raw_last_datadate
    from selected_gvkeys as s left join comp_raw_pre90 as r
      on s.gvkey=r.gvkey
    group by s.issue_year, s.gvkey;
    create table raw_pre_counts as
    select t.master_deal_no, t.issue_year, t.gvkey, t.filingdate,
           count(distinct r.fyear) as raw_pre_years
    from target_link as t left join comp_raw_pre90 as r
      on t.gvkey=r.gvkey and r.datadate < t.filingdate
    where t.n_gvkeys=1
    group by t.master_deal_no, t.issue_year, t.gvkey, t.filingdate;
quit;
proc sort data=raw_bounds; by issue_year; run;
title "Linked GVKEY raw Compustat history bounds through FY1989";
proc means data=raw_bounds n mean min p25 median p75 max;
    by issue_year;
    var raw_rows_through_1989 raw_first_fyear raw_last_fyear;
run;

/* Filter waterfall on the production 1982-1989 horizon, by linked GVKEY. */
data comp_pre82_89;
    set comp.funda(
        keep=gvkey datadate fyear indfmt consol datafmt popsrc fic sich
        where=(fyear >= 1982 and fyear <= 1989)
    );
    if not missing(gvkey) and not missing(datadate) and not missing(fyear);
run;
proc sql;
    create table stage_pre_counts as
    select t.master_deal_no, t.issue_year, t.gvkey, t.filingdate,
      count(distinct case when r.datadate < t.filingdate then r.fyear else . end) as n_raw82,
      count(distinct case when r.datadate < t.filingdate
                            and strip(upcase(r.indfmt))='INDL' then r.fyear else . end) as n_indl,
      count(distinct case when r.datadate < t.filingdate
                            and strip(upcase(r.indfmt))='INDL'
                            and strip(upcase(r.consol))='C' then r.fyear else . end) as n_consol,
      count(distinct case when r.datadate < t.filingdate
                            and strip(upcase(r.indfmt))='INDL'
                            and strip(upcase(r.consol))='C'
                            and strip(upcase(r.datafmt))='STD' then r.fyear else . end) as n_std,
      count(distinct case when r.datadate < t.filingdate
                            and strip(upcase(r.indfmt))='INDL'
                            and strip(upcase(r.consol))='C'
                            and strip(upcase(r.datafmt))='STD'
                            and strip(upcase(r.popsrc))='D' then r.fyear else . end) as n_dom,
      count(distinct case when r.datadate < t.filingdate
                            and strip(upcase(r.indfmt))='INDL'
                            and strip(upcase(r.consol))='C'
                            and strip(upcase(r.datafmt))='STD'
                            and strip(upcase(r.popsrc))='D'
                            and strip(upcase(r.fic))='USA' then r.fyear else . end) as n_fic,
      count(distinct case when r.datadate < t.filingdate
                            and strip(upcase(r.indfmt))='INDL'
                            and strip(upcase(r.consol))='C'
                            and strip(upcase(r.datafmt))='STD'
                            and strip(upcase(r.popsrc))='D'
                            and strip(upcase(r.fic))='USA'
                            and not missing(r.sich) and r.sich >= 100 and r.sich <= 9999
                            and not (r.sich >= 6000 and r.sich <= 6999)
                           then r.fyear else . end) as n_sich_any
    from target_link as t left join comp_pre82_89 as r
      on t.gvkey=r.gvkey
    where t.n_gvkeys=1
    group by t.master_deal_no, t.issue_year, t.gvkey, t.filingdate;
quit;

/* Match the production pre-filing statement population exactly, without item completeness. */
data comp_prod_raw;
    set comp.funda(
        keep=gvkey datadate fyear indfmt consol datafmt popsrc fic sich
        where=(fyear >= 1982 and fyear <= 1989)
    );
    if strip(upcase(indfmt)) ne 'INDL'
       or strip(upcase(consol)) ne 'C'
       or strip(upcase(datafmt)) ne 'STD'
       or strip(upcase(popsrc)) ne 'D'
       or strip(upcase(fic)) ne 'USA' then delete;
    format datadate date9.;
run;
proc sort data=comp_prod_raw out=comp_prod_sorted;
    by gvkey fyear datadate;
run;
data comp_prod_annual;
    set comp_prod_sorted;
    by gvkey fyear datadate;
    if last.fyear;
    if not missing(sich) and sich >= 100 and sich <= 9999
       and not (sich >= 6000 and sich <= 6999);
run;
proc sql;
    create table prod_pre_counts as
    select t.master_deal_no, t.issue_year, t.gvkey, t.filingdate,
           count(distinct c.fyear) as build_pre_years
    from target_link as t left join comp_prod_annual as c
      on t.gvkey=c.gvkey and c.datadate < t.filingdate
    where t.n_gvkeys=1
    group by t.master_deal_no, t.issue_year, t.gvkey, t.filingdate;
    create table event_history as
    select r.issue_year, r.master_deal_no, r.gvkey, r.filingdate,
           r.raw_pre_years, p.build_pre_years
    from raw_pre_counts as r left join prod_pre_counts as p
      on r.master_deal_no=p.master_deal_no;
    create table stage_results as
    select s.*, p.build_pre_years
    from stage_pre_counts as s left join prod_pre_counts as p
      on s.master_deal_no=p.master_deal_no;
    title "Unique-linked early target offers: raw versus production pre-filing histories";
    select issue_year, count(*) as unique_linked_events,
           sum(raw_pre_years >= 4) as raw_events_with_4_prior_fy,
           sum(build_pre_years >= 4) as build_events_with_4_prior_fy,
           sum(raw_pre_years >= 4 and build_pre_years < 4) as raw4_but_build_lt4,
           sum(raw_pre_years < 4 and build_pre_years < 4) as raw_lt4_and_build_lt4,
           min(raw_pre_years) as raw_min_pre_fy,
           max(raw_pre_years) as raw_max_pre_fy,
           min(build_pre_years) as build_min_pre_fy,
           max(build_pre_years) as build_max_pre_fy
    from event_history group by issue_year order by issue_year;
    title "Pre-filing history waterfall by source filters";
    select issue_year, count(*) as unique_linked_events,
           sum(n_raw82 >= 4) as raw82_4,
           sum(n_indl >= 4) as indl_4,
           sum(n_consol >= 4) as consol_4,
           sum(n_std >= 4) as std_4,
           sum(n_dom >= 4) as dom_4,
           sum(n_fic >= 4) as fic_4,
           sum(n_sich_any >= 4) as sich_any_4,
           sum(build_pre_years >= 4) as production_4,
           max(n_raw82) as raw82_max,
           max(n_indl) as indl_max,
           max(n_consol) as consol_max,
           max(n_std) as std_max,
           max(n_dom) as dom_max,
           max(n_fic) as fic_max,
           max(n_sich_any) as sich_any_max,
           max(build_pre_years) as production_max
    from stage_results group by issue_year order by issue_year;
quit;
proc sort data=stage_results; by issue_year; run;
title "Annual pre-filing year counts after cumulative Compustat filters";
proc means data=stage_results n mean min p25 median p75 max;
    by issue_year;
    var n_raw82 n_indl n_consol n_std n_dom n_fic n_sich_any build_pre_years;
run;
proc sort data=event_history; by issue_year; run;
title "Pre-filing annual-history count distributions by issue cohort";
proc means data=event_history n mean min p25 median p75 max;
    by issue_year;
    var raw_pre_years build_pre_years;
run;

