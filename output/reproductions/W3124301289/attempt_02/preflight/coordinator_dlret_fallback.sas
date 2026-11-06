options errorabend msglevel=i;
libname crsp "/storage/sas/base/crsp/a_stock" access=readonly;

/* Bounded audit of delist-month keys absent from the filtered common-stock
   monthly file. Summaries only; no source observations are exported. */
data work.msf0;
    set crsp.msf(keep=permno permco date ret);
    if date < "01DEC1977"d or date > "30JUN2001"d then delete;
    monthkey=intnx("month",date,0,"beginning");
    format date monthkey date9.;
run;

data work.names_range;
    set crsp.msenames(keep=permno permco namedt nameendt shrcd);
    if nameendt=.E then name_end="30JUN2001"d;
    else if not missing(nameendt) then name_end=nameendt;
    else delete;
    if namedt=.B then name_start="01DEC1977"d;
    else if not missing(namedt) then name_start=namedt;
    else delete;
    if name_end < "01DEC1977"d or name_start > "30JUN2001"d then delete;
    name_start=max(name_start,"01DEC1977"d);
    name_end=min(name_end,"30JUN2001"d);
    keep permno permco name_start name_end shrcd;
    format name_start name_end date9.;
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
    create table work.filtered_candidates as
    select m.permno, m.permco as msf_permco, n.permco as name_permco,
           m.date, m.monthkey, m.ret, n.name_start, n.shrcd
    from work.msf0 as m
    left join work.names_range as n
      on m.permno=n.permno and m.date>=n.name_start and m.date<=n.name_end;
quit;

proc sort data=work.filtered_candidates out=work.filtered_candidates_sort;
    by permno monthkey descending name_start;
run;

data work.stock_month;
    set work.filtered_candidates_sort;
    by permno monthkey;
    if first.monthkey;
    if shrcd not in (10,11) then delete;
run;

proc sql;
    create table work.event_only as
    select d.*
    from work.delist_month as d
    left join work.stock_month as s
      on d.permno=s.permno and d.dlmonth=s.monthkey
    where missing(s.permno) and d.distinct_dlret=1 and not missing(d.dlret);

    create table work.raw_month_summary as
    select d.permno, d.dlmonth,
           count(m.permno) as raw_msf_rows,
           sum(not missing(m.ret)) as raw_ret_rows,
           count(distinct m.permco) as raw_permco_options,
           min(m.permco) as raw_permco,
           max(m.date) as raw_date format=date9.
    from work.event_only as d
    left join work.msf0 as m
      on d.permno=m.permno and d.dlmonth=m.monthkey
    group by d.permno, d.dlmonth;

    create table work.event_name_summary as
    select d.permno, d.dlmonth,
           count(n.permno) as event_name_rows,
           count(distinct n.permco) as event_permco_options,
           min(n.permco) as event_permco,
           count(distinct n.shrcd) as event_shrcd_options,
           min(n.shrcd) as event_shrcd,
           max(case when n.shrcd in (10,11) and not missing(n.permco)
                    then n.name_end else . end) as event_common_name_end format=date9.
    from work.event_only as d
    left join work.names_range as n
      on d.permno=n.permno and d.dlstdt>=n.name_start and d.dlstdt<=n.name_end
    group by d.permno, d.dlmonth;

    create table work.raw_name_interval as
    select d.permno, d.dlmonth,
           sum(case when m.permno is not null and n.permno is not null then 1 else 0 end) as raw_rows_in_any_name,
           sum(case when m.permno is not null and n.permno is null then 1 else 0 end) as raw_rows_outside_all_names,
           sum(case when m.permno is not null and not missing(e.event_common_name_end) and
                         m.date>e.event_common_name_end then 1 else 0 end) as raw_after_end
    from work.event_only as d
    left join work.msf0 as m
      on d.permno=m.permno and d.dlmonth=m.monthkey
    left join work.names_range as n
      on m.permno=n.permno and m.date>=n.name_start and m.date<=n.name_end
    left join work.event_name_summary as e
      on d.permno=e.permno and d.dlmonth=e.dlmonth
    group by d.permno, d.dlmonth;

    create table work.audit as
    select d.*, r.raw_msf_rows, r.raw_ret_rows, r.raw_permco_options,
           r.raw_permco, r.raw_date,
           e.event_name_rows, e.event_permco_options, e.event_permco,
           e.event_shrcd_options, e.event_shrcd, e.event_common_name_end,
           i.raw_rows_in_any_name, i.raw_rows_outside_all_names,
           i.raw_after_end
    from work.event_only as d
    left join work.raw_month_summary as r
      on d.permno=r.permno and d.dlmonth=r.dlmonth
    left join work.event_name_summary as e
      on d.permno=e.permno and d.dlmonth=e.dlmonth
    left join work.raw_name_interval as i
      on d.permno=i.permno and d.dlmonth=i.dlmonth;

    title "Bounded raw-MSF audit of filtered DLRET-only events";
    select count(*) as filtered_dlret_only_events,
           sum(raw_msf_rows>0) as with_raw_msf,
           sum(raw_ret_rows>0) as with_nonmissing_raw_ret,
           sum(event_name_rows>0 and event_permco_options=1 and
               event_shrcd_options=1 and event_shrcd in (10,11)) as with_unique_dated_common_link,
           sum(raw_ret_rows>0 and event_name_rows>0 and event_permco_options=1 and
               event_shrcd_options=1 and event_shrcd in (10,11)) as ret_common_link,
           sum(raw_ret_rows=1 and raw_msf_rows=1 and raw_permco_options=1 and
               raw_permco=event_permco and event_name_rows>0 and
               event_permco_options=1 and event_shrcd_options=1 and
               event_shrcd in (10,11)) as ret_match_link,
           sum(raw_rows_outside_all_names>0) as raw_outside_names,
           sum(raw_after_end>0) as raw_after_common_end,
           sum(raw_ret_rows>0 and raw_rows_outside_all_names>0) as ret_outside_names,
           sum(raw_ret_rows>0 and raw_after_end>0) as ret_after_common_end
    from work.audit;
quit;


proc sql;
 title 'Coordinator check: raw returns under the production prior-month fallback';
 select count(*) as raw_ret_events,
        sum(not missing(p.permno)) as prior_common_rows,
        sum(not missing(p.permno) and p.msf_permco>0 and
            p.msf_permco=p.name_permco) as supported_prior_permco,
        sum(not missing(p.permno) and p.msf_permco>0 and
            p.msf_permco=p.name_permco and a.raw_permco=p.msf_permco)
            as raw_and_prior_permco_agree
 from work.audit as a left join work.stock_month as p
   on a.permno=p.permno and p.monthkey=intnx('month',a.dlmonth,-1,'beginning')
 where a.raw_ret_rows>0;
quit;

libname ccm '/storage/sas/base/crsp/a_ccm' access=readonly;
libname finals '../data' access=readonly;
proc sql;
 title 'Coordinator check: nonmissing raw returns versus possible final target windows';
 select count(*) as possible_target_event_links
 from work.audit as a inner join ccm.ccmxpf_linktable as l
   on a.permno=l.lpermno and l.linktype in ('LC','LU') and l.linkprim in ('P','C')
 inner join finals.rd_main as f on l.gvkey=f.gvkey
 where a.raw_ret_rows>0
   and (l.linkdt=.B or l.linkdt<=intnx('month',f.datadate,4,'end'))
   and (l.linkenddt=.E or l.linkenddt>=intnx('month',f.datadate,4,'end'))
   and a.dlmonth>=intnx('month',f.datadate,5,'beginning')
   and a.dlmonth<=intnx('month',f.datadate,16,'beginning');
quit;
