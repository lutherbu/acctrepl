options errorabend;

libname rep "./data/order_backlog_firm_years" access=readonly;
libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname crspstk "/storage/sas/base/crsp/a_stock" access=readonly;
libname ccm "/storage/sas/base/crsp/a_ccm" access=readonly;

/* Audit only the final handoff and the exact source rows needed to check its
   fiscal-year support, historical links, and fallback capitalization date. */
data final_events;
    set rep.order_backlog_firm_years;
    start_month=intnx('month',datadate,4,'b');
    window_end=intnx('month',start_month,11,'e');
    format start_month window_end date9.;
run;

proc sql;
    select count(*) as final_rows,
           min(datadate) as current_datadate_min format=date9.,
           max(datadate) as current_datadate_max format=date9.,
           min(start_month) as holding_start_min format=date9.,
           max(window_end) as holding_end_max format=date9.,
           sum(case when window_end<='31DEC2001'd then 1 else 0 end)
               as windows_covered_through_2001
    from final_events;
quit;

/* Reapply the production annual-record filters and sort priority to verify
   the actual t+1 reporting dates carried by the final sample. */
data funda_raw;
    set comp.funda(keep=gvkey datadate fyear indfmt consol popsrc datafmt
                        ib at ob curcd final fdate pdate
                   where=(fyear>=1980 and fyear<=2000 and indfmt='INDL' and
                          consol='C' and popsrc='D' and datafmt='STD'));
    curcd=upcase(strip(curcd));
    final_priority=(upcase(strip(final)) in ('Y','F'));
    if missing(gvkey) or missing(datadate) or missing(fyear) then delete;
run;

proc sort data=funda_raw out=funda_sort;
    by gvkey fyear descending final_priority descending fdate
       descending pdate descending datadate;
run;

data funda;
    set funda_sort;
    by gvkey fyear;
    if first.fyear;
    keep gvkey datadate fyear;
run;

proc sql;
    select e.fyear, count(*) as final_rows,
           count(n.datadate) as tplus1_date_matches,
           min(n.datadate) as tplus1_datadate_min format=date9.,
           max(n.datadate) as tplus1_datadate_max format=date9.,
           max(year(n.datadate)) as tplus1_latest_calendar_year
    from final_events as e left join funda as n
      on e.gvkey=n.gvkey and n.fyear=e.fyear+1
    group by e.fyear;

    select count(*) as fy1999_final_rows,
           count(n.datadate) as fy1999_tplus1_matches,
           min(n.datadate) as fy1999_tplus1_min format=date9.,
           max(n.datadate) as fy1999_tplus1_max format=date9.,
           sum(case when year(n.datadate)=2001 then 1 else 0 end)
               as fy1999_tplus1_dates_in_2001
    from final_events as e left join funda as n
      on e.gvkey=n.gvkey and n.fyear=e.fyear+1
    where e.fyear=1999;
quit;

/* Recreate the production P-before-C, LC-before-LU, date-valid formation
   link choice and compare it with the FYE security used for event returns. */
data ccm_links;
    set ccm.ccmxpf_linktable(keep=gvkey linkprim linktype lpermno lpermco
                                  linkdt linkenddt
                             where=(linktype in ('LC','LU') and
                                    linkprim in ('P','C')));
    permno=lpermno;
    permco=lpermco;
    linkrank=(ifn(linkprim='P',0,10)+ifn(linktype='LC',0,1));
    if missing(permno) then delete;
    keep gvkey permno permco linkrank linkdt linkenddt;
run;

proc sql;
    create table form_cand as
    select distinct e.gvkey, e.form_date, l.permno, l.permco, l.linkrank
    from final_events as e inner join ccm_links as l
      on e.gvkey=l.gvkey
    where e.rank_source=1 and
          (missing(l.linkdt) or l.linkdt<=e.form_date) and
          (missing(l.linkenddt) or e.form_date<=l.linkenddt);

    create table form_min as
    select gvkey, form_date, min(linkrank) as minrank
    from form_cand group by gvkey, form_date;

    create table form_best as
    select c.*
    from form_cand as c inner join form_min as m
      on c.gvkey=m.gvkey and c.form_date=m.form_date and c.linkrank=m.minrank;

    create table form_n as
    select gvkey, form_date, count(distinct permno) as n_permno,
           count(distinct permco) as n_permco
    from form_best group by gvkey, form_date;

    create table form_unique as
    select b.gvkey, b.form_date, min(b.permno) as permno,
           min(b.permco) as permco
    from form_best as b inner join form_n as n
      on b.gvkey=n.gvkey and b.form_date=n.form_date
    where n.n_permno=1 and n.n_permco=1
    group by b.gvkey, b.form_date;

    create table rank_assignment as
    select e.*,
           case when e.rank_source=1 then f.permno
                when e.rank_source=2 then e.permno_fye else . end as rank_permno,
           case when e.rank_source=1 then f.permco
                when e.rank_source=2 then e.permco_fye else . end as rank_permco
    from final_events as e left join form_unique as f
      on e.gvkey=f.gvkey and e.form_date=f.form_date;

    create table fye_valid_start as
    select distinct e.gvkey, e.fyear
    from rank_assignment as e inner join ccm_links as l
      on e.gvkey=l.gvkey and e.permno_fye=l.permno
    where (missing(l.linkdt) or l.linkdt<=e.start_month) and
          (missing(l.linkenddt) or e.start_month<=l.linkenddt);

    create table links_active_start as
    select e.gvkey, e.fyear, count(distinct l.permno) as n_active_permno,
           max(case when l.permno=e.permno_fye then 1 else 0 end) as fye_active,
           max(case when not missing(l.permno) and
                         l.permno ne e.permno_fye then 1 else 0 end) as other_active,
           max(case when not missing(l.permno) and
                         l.permno ne e.permno_fye and
                         l.permco=e.permco_fye then 1 else 0 end) as other_same_co,
           max(case when not missing(l.permno) and
                         l.permno ne e.permno_fye and
                         l.permco ne e.permco_fye then 1 else 0 end) as other_diff_co
    from rank_assignment as e left join ccm_links as l
      on e.gvkey=l.gvkey and
         (missing(l.linkdt) or l.linkdt<=e.start_month) and
         (missing(l.linkenddt) or e.start_month<=l.linkenddt)
    group by e.gvkey, e.fyear;

    select count(*) as final_rows,
           sum(case when rank_source=1 then 1 else 0 end)
               as formation_link_rank_rows,
           sum(case when rank_source=2 then 1 else 0 end)
               as fye_link_fallback_rows,
           sum(case when rank_source=1 and missing(rank_permno) then 1 else 0 end)
               as missing_formation_rank_link,
           sum(case when not missing(rank_permno) and
                         rank_permno=permno_fye then 1 else 0 end)
               as formation_and_event_permno_same,
           sum(case when not missing(rank_permno) and
                         rank_permno ne permno_fye then 1 else 0 end)
               as permno_rank_event_diff,
           sum(case when rank_permno ne permno_fye and
                         rank_permco=permco_fye then 1 else 0 end)
               as permno_diff_same_permco,
           sum(case when rank_permno ne permno_fye and
                         rank_permco ne permco_fye then 1 else 0 end)
               as permno_diff_other_permco,
           sum(case when v.gvkey is not missing then 1 else 0 end)
               as fye_link_valid_start
    from rank_assignment as e left join fye_valid_start as v
      on e.gvkey=v.gvkey and e.fyear=v.fyear;

    select count(*) as final_rows,
           sum(case when fye_active=1 then 1 else 0 end) as fye_active_rows,
           sum(case when fye_active=0 and n_active_permno>0 then 1 else 0 end)
               as expired_with_other_link,
           sum(case when fye_active=0 and n_active_permno=0 then 1 else 0 end)
               as no_active_link,
           sum(case when fye_active=0 and other_same_co=1 then 1 else 0 end)
               as expired_same_company_issue,
           sum(case when fye_active=0 and other_diff_co=1 then 1 else 0 end)
               as expired_other_company_link
    from links_active_start;

    select count(*) as final_best_formation_link_groups,
           sum(case when n_permno ne 1 or n_permco ne 1 then 1 else 0 end)
               as ambig_form_links
    from form_n;
quit;

/* Check whether an annual first-cap fallback is observed before the first
   event-return month.  The source guide explicitly uses first-year cap for
   midyear entrants; this audit measures its timing relative to these events. */
data mcap_obs;
    set crspstk.msf(keep=permno date prc shrout
                    where=(date>='01JAN1980'd and date<='31DEC2000'd));
    if not missing(prc) and not missing(shrout) and shrout>0 then
        mcap=abs(prc)*shrout;
    else mcap=.;
    if mcap<=0 then mcap=.;
    if missing(mcap) then delete;
    calyr=year(date);
run;

proc sql;
    create table name_match_raw as
    select s.permno, s.date, s.calyr, s.mcap, n.shrcd, n.exchcd
    from mcap_obs as s inner join crspstk.msenames as n
      on s.permno=n.permno and
         (missing(n.namedt) or n.namedt<=s.date) and
         (missing(n.nameendt) or s.date<=n.nameendt);

    create table name_match_n as
    select permno, date, count(*) as n_names
    from name_match_raw group by permno, date;

    create table size_obs as
    select r.permno, r.date, r.calyr
    from name_match_raw as r inner join name_match_n as n
      on r.permno=n.permno and r.date=n.date
    where n.n_names=1 and r.exchcd in (1,2,3) and not missing(r.shrcd)
          and floor(r.shrcd/10) ne 3;

    create table cap_keys as
    select distinct gvkey, fyear, rank_permno, return_year, start_month
    from rank_assignment where cap_source=2 and not missing(rank_permno);

    create table cap_obs as
    select k.gvkey, k.fyear, k.rank_permno, k.return_year, k.start_month,
           s.date as cap_date
    from cap_keys as k inner join size_obs as s
      on k.rank_permno=s.permno and k.return_year=s.calyr;
quit;

proc sort data=cap_obs out=cap_obs_sort;
    by gvkey fyear cap_date;
run;

data first_cap;
    set cap_obs_sort;
    by gvkey fyear;
    if first.fyear;
    keep gvkey fyear cap_date;
    rename cap_date=first_cap_date;
    format cap_date date9.;
run;

proc sql;
    create table cap_audit as
    select e.*, c.first_cap_date
    from rank_assignment as e left join first_cap as c
      on e.gvkey=c.gvkey and e.fyear=c.fyear;

    select count(*) as final_rows,
           sum(case when cap_source=2 then 1 else 0 end) as first_cap_rows,
           sum(case when cap_source=2 and missing(first_cap_date)
                    then 1 else 0 end) as first_cap_date_missing,
           sum(case when cap_source=2 and first_cap_date<start_month
                    then 1 else 0 end) as first_cap_known_before_start,
           sum(case when cap_source=2 and first_cap_date>=start_month
                    then 1 else 0 end) as first_cap_at_or_after_start,
           sum(case when cap_source=2 and
                         year(first_cap_date)=year(start_month) and
                         month(first_cap_date)=month(start_month)
                    then 1 else 0 end) as first_cap_same_start_month
    from cap_audit;
quit;

/* Inspect the bounded first-cap edge cases.  Report only aggregate evidence:
   prior-December and entry-month prices, shares, returns, and name eligibility,
   plus CRSP returns observed before the reconstructed first-cap date. */
proc sql;
    create table edge_cases as
    select *
    from cap_audit
    where cap_source=2 and first_cap_date>=start_month;
quit;

data edge_months;
    set edge_cases;
    length role $8;
    step=.;
    role='PRIORDEC';
    month_begin=mdy(12,1,return_year-1);
    output;
    do step=0 to intck('month',mdy(1,1,return_year),start_month)-1;
        role='PRESTART';
        month_begin=intnx('month',mdy(1,1,return_year),step,'b');
        output;
    end;
    do step=0 to 11;
        role='WINDOW';
        month_begin=intnx('month',start_month,step,'b');
        output;
    end;
    format month_begin date9.;
    keep gvkey fyear rank_permno return_year start_month first_cap_date
         role step month_begin;
run;

proc sql;
    create table edge_msf as
    select w.*, m.date as msf_date, m.ret, m.prc, m.shrout
    from edge_months as w left join crspstk.msf as m
      on w.rank_permno=m.permno and
         year(m.date)=year(w.month_begin) and
         month(m.date)=month(w.month_begin);

    create table edge_name_raw as
    select m.*, n.permno as name_permno, n.namedt, n.nameendt,
           n.shrcd, n.exchcd
    from edge_msf as m left join crspstk.msenames as n
      on m.rank_permno=n.permno and not missing(m.msf_date) and
         (missing(n.namedt) or n.namedt<=m.msf_date) and
         (missing(n.nameendt) or m.msf_date<=n.nameendt);

    create table edge_month_summary as
    select gvkey, fyear, role, month_begin, start_month, first_cap_date,
           max(msf_date) as msf_date, max(ret) as ret, max(prc) as prc,
           max(shrout) as shrout, count(name_permno) as n_names,
           sum(case when name_permno is not missing and exchcd in (1,2,3) and
                         not missing(shrcd) and floor(shrcd/10) ne 3
                    then 1 else 0 end) as eligible_names,
           sum(case when name_permno is not missing and missing(exchcd)
                    then 1 else 0 end) as missing_exch,
           sum(case when name_permno is not missing and not missing(exchcd) and
                         exchcd not in (1,2,3) then 1 else 0 end) as other_exch,
           sum(case when name_permno is not missing and missing(shrcd)
                    then 1 else 0 end) as missing_shrcd,
           sum(case when name_permno is not missing and not missing(shrcd) and
                         floor(shrcd/10)=3 then 1 else 0 end) as adr_shrcd,
           max(namedt) as name_start
    from edge_name_raw
    group by gvkey, fyear, role, month_begin, start_month, first_cap_date;

    create table edge_summary as
    select gvkey, fyear,
           max(case when role='PRIORDEC' and not missing(msf_date)
                    then 1 else 0 end) as pdec_row,
           max(case when role='PRIORDEC' and not missing(ret)
                    then 1 else 0 end) as pdec_ret,
           max(case when role='PRIORDEC' and not missing(prc)
                    then 1 else 0 end) as pdec_price,
           max(case when role='PRIORDEC' and not missing(shrout)
                    then 1 else 0 end) as pdec_shares,
           max(case when role='PRIORDEC' and n_names=1 and eligible_names=1
                    then 1 else 0 end) as pdec_name_eligible,
           max(case when role='PRIORDEC' and n_names=0
                    then 1 else 0 end) as pdec_no_name,
           max(case when role='PRIORDEC' and n_names>1
                    then 1 else 0 end) as pdec_multi_name,
           max(case when role='PRIORDEC' and other_exch>0
                    then 1 else 0 end) as pdec_other_exchange,
           max(case when role='PRIORDEC' and missing_exch>0
                    then 1 else 0 end) as pdec_missing_exchange,
           max(case when role='PRIORDEC' and missing_shrcd>0
                    then 1 else 0 end) as pdec_missing_share,
           max(case when role='PRIORDEC' and adr_shrcd>0
                    then 1 else 0 end) as pdec_adr,
           max(case when role='WINDOW' and month_begin=start_month and
                         not missing(msf_date) then 1 else 0 end) as entry_row,
           max(case when role='WINDOW' and month_begin=start_month and
                         not missing(ret) then 1 else 0 end) as entry_ret,
           max(case when role='WINDOW' and month_begin=start_month and
                         not missing(prc) then 1 else 0 end) as entry_price,
           max(case when role='WINDOW' and month_begin=start_month and
                         not missing(shrout) then 1 else 0 end) as entry_shares,
           max(case when role='WINDOW' and month_begin=start_month and
                         n_names=1 and eligible_names=1 then 1 else 0 end)
               as entry_name_eligible,
           max(case when role='WINDOW' and month_begin=start_month and
                         n_names=0 then 1 else 0 end) as entry_no_name,
           max(case when role='WINDOW' and month_begin=start_month and
                         n_names>1 then 1 else 0 end) as entry_multi_name,
           max(case when role='WINDOW' and month_begin=start_month and
                         other_exch>0 then 1 else 0 end) as entry_other_exchange,
           max(case when role='WINDOW' and month_begin=start_month and
                         missing_exch>0 then 1 else 0 end) as entry_missing_exchange,
           max(case when role='WINDOW' and month_begin=start_month and
                         missing_shrcd>0 then 1 else 0 end) as entry_missing_share,
           max(case when role='WINDOW' and month_begin=start_month and
                         adr_shrcd>0 then 1 else 0 end) as entry_adr,
           sum(case when role='PRESTART' and not missing(msf_date)
                    then 1 else 0 end) as prestart_msf_months,
           sum(case when role='PRESTART' and not missing(ret)
                    then 1 else 0 end) as prestart_return_months,
           sum(case when role='PRESTART' and not missing(prc)
                    then 1 else 0 end) as prestart_price_months,
           sum(case when role='PRESTART' and not missing(shrout)
                    then 1 else 0 end) as prestart_share_months,
           sum(case when role='PRESTART' and n_names=1 and eligible_names=1
                    then 1 else 0 end) as prestart_eligible_names,
           sum(case when role='WINDOW' and
                         month_begin<intnx('month',first_cap_date,0,'b') and
                         not missing(ret) then 1 else 0 end)
               as returns_before_cap,
           sum(case when role='WINDOW' and
                         month_begin<intnx('month',first_cap_date,0,'b') and
                         not missing(ret) and
                         (missing(prc) or missing(shrout))
                    then 1 else 0 end) as return_before_cap_no_size,
           sum(case when role='WINDOW' and
                         month_begin<intnx('month',first_cap_date,0,'b') and
                         not missing(ret) and
                         (n_names ne 1 or eligible_names ne 1)
                    then 1 else 0 end) as return_before_cap_no_name,
           sum(case when role='PRESTART' and not missing(ret) and
                         (missing(prc) or missing(shrout))
                    then 1 else 0 end) as prestart_return_no_size,
           sum(case when role='PRESTART' and not missing(ret) and
                         (n_names ne 1 or eligible_names ne 1)
                    then 1 else 0 end) as prestart_return_no_name,
           max(case when role='WINDOW' and
                         month_begin=intnx('month',first_cap_date,0,'b')
                    then name_start else . end) as cap_name_start
    from edge_month_summary
    group by gvkey, fyear;

    create table edge_summary_timed as
    select e.*, c.start_month, c.first_cap_date,
           case when year(c.first_cap_date)=year(c.start_month) and
                           month(c.first_cap_date)=month(c.start_month)
                     then 'same-month' else 'after-month' end as timing length=12
    from edge_summary as e inner join edge_cases as c
      on e.gvkey=c.gvkey and e.fyear=c.fyear;

    select timing, count(*) as cases,
           sum(pdec_row) as prior_dec_msf_row,
           sum(pdec_ret) as prior_dec_return,
           sum(pdec_price) as prior_dec_price,
           sum(pdec_shares) as prior_dec_shares,
           sum(pdec_name_eligible) as prior_dec_name_eligible,
           sum(pdec_no_name) as prior_dec_no_name,
           sum(pdec_multi_name) as prior_dec_multi_name,
           sum(pdec_other_exchange) as prior_dec_other_exchange,
           sum(pdec_missing_exchange) as prior_dec_missing_exchange,
           sum(pdec_missing_share) as prior_dec_missing_share,
           sum(pdec_adr) as prior_dec_adr,
           sum(entry_row) as entry_month_msf_row,
           sum(entry_ret) as entry_month_return,
           sum(entry_price) as entry_month_price,
           sum(entry_shares) as entry_month_shares,
           sum(entry_name_eligible) as entry_name_eligible,
           sum(entry_no_name) as entry_no_name,
           sum(entry_multi_name) as entry_multi_name,
           sum(entry_other_exchange) as entry_other_exchange,
           sum(entry_missing_exchange) as entry_missing_exchange,
           sum(entry_missing_share) as entry_missing_share,
           sum(entry_adr) as entry_adr,
           sum(prestart_msf_months) as prestart_msf_months,
           sum(prestart_return_months) as prestart_return_months,
           sum(prestart_price_months) as prestart_price_months,
           sum(prestart_share_months) as prestart_share_months,
           sum(prestart_eligible_names) as prestart_eligible_names,
           sum(prestart_return_no_size) as prestart_return_no_size,
           sum(prestart_return_no_name) as prestart_return_no_name,
           sum(returns_before_cap) as return_months_before_cap,
           sum(return_before_cap_no_size) as returns_before_cap_no_size,
           sum(return_before_cap_no_name) as returns_before_cap_no_name,
           sum(case when cap_name_start>start_month then 1 else 0 end)
               as cap_name_begins_after_start,
           min(first_cap_date-start_month) as first_cap_min_gap_days,
           max(first_cap_date-start_month) as first_cap_max_gap_days,
           min(cap_name_start-start_month) as name_start_min_gap_days,
           max(cap_name_start-start_month) as name_start_max_gap_days
    from edge_summary_timed group by timing;
quit;
