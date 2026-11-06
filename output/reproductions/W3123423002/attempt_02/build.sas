options errorabend;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname ccm "/storage/sas/base/crsp/a_ccm" access=readonly;
libname crsp "/storage/sas/base/crsp/a_stock" access=readonly;
libname out "data";

/* Read only the annual Compustat fields needed for the current, lagged, and lead periods. */
proc sql;
    create table work.funda0 as
    select substr(strip(gvkey),1,6) as gvkey length=6,
           datadate, fyear, indfmt, consol, popsrc, datafmt, scf, pddur,
           curcd, at, ceq, ibc, oancf, ivncf, fincf, spi, sich
    from comp.funda
    where fyear between 1987 and 2003
      and indfmt='INDL'
      and consol='C'
      and popsrc='D'
      and datafmt='STD';
quit;

data work.current0;
    set work.funda0;
    if fyear < 1988 or fyear > 2002 then delete;
    if scf ne 7 then delete;
run;

/* Audit annual source keys before temporal joins. */
proc sql;
    create table work.funda_dup_fy as
    select gvkey, fyear, count(*) as n_rows
    from work.funda0
    group by gvkey, fyear
    having calculated n_rows > 1;

    create table work.funda_dup_date as
    select gvkey, datadate, count(*) as n_rows
    from work.funda0
    group by gvkey, datadate
    having calculated n_rows > 1;

    select fyear, count(*) as duplicate_firmyears,
           sum(n_rows-1) as extra_rows
    from work.funda_dup_fy
    group by fyear
    order by fyear;

    select count(*) as duplicate_gvkey_datadates,
           sum(n_rows-1) as extra_rows
    from work.funda_dup_date;

    select fyear, count(*) as source_rows,
           sum(case when missing(datadate) then 1 else 0 end) as missing_datadate,
           sum(case when missing(curcd) then 1 else 0 end) as missing_curcd,
           sum(case when missing(sich) or sich=0 then 1 else 0 end) as missing_historical_sic,
           sum(case when missing(at) or at<=0 then 1 else 0 end) as missing_or_nonpositive_at
    from work.current0
    group by fyear
    order by fyear;
quit;

/* Keep dated primary CCM links. LINKENDDT=.E is an open end, not a recent date. */
data work.link0;
    set ccm.ccmxpf_lnkhist(keep=gvkey linkprim linktype lpermno linkdt linkenddt);
    if linkprim not in ('P','C') then delete;
    if linktype not in ('LC','LU') then delete;
    if missing(lpermno) or lpermno<=0 then delete;
    gvkey=substr(strip(gvkey),1,6);
run;

proc sql;
    select count(*) as retained_link_rows,
           sum(case when linkdt=.B then 1 else 0 end) as open_start_b,
           sum(case when linkdt=. then 1 else 0 end) as open_start_dot,
           sum(case when missing(linkdt) and linkdt ne .B and linkdt ne . then 1 else 0 end) as other_start_special,
           sum(case when linkenddt=.E then 1 else 0 end) as open_end_e,
           sum(case when linkenddt=. then 1 else 0 end) as open_end_dot,
           sum(case when missing(linkenddt) and linkenddt ne .E and linkenddt ne . then 1 else 0 end) as other_end_special
    from work.link0;

    create table work.linkcand as
    select f.gvkey, f.fyear, f.datadate,
           l.lpermno as permno, l.linkprim, l.linktype,
           l.linkdt, l.linkenddt,
           case when l.linkprim='P' then 1 else 2 end as lrank
    from work.current0 as f inner join work.link0 as l
      on f.gvkey=l.gvkey
     and (l.linkdt=.B or l.linkdt=. or l.linkdt<=f.datadate)
     and (l.linkenddt=.E or l.linkenddt=. or l.linkenddt>=f.datadate);

    create table work.linkcand1 as
    select gvkey, fyear, datadate, permno, lrank,
           count(*) as same_permno_link_rows
    from work.linkcand
    group by gvkey, fyear, datadate, permno, lrank;

    create table work.linkstats as
    select gvkey, fyear, datadate,
           sum(case when lrank=1 then 1 else 0 end) as n_p,
           sum(case when lrank=2 then 1 else 0 end) as n_c
    from work.linkcand1
    group by gvkey, fyear, datadate;

    create table work.link_audit_year as
    select c.fyear, count(*) as current_rows,
           sum(case when missing(s.n_p) then 1 else 0 end) as no_valid_link,
           sum(case when s.n_p>1 then 1 else 0 end) as ambiguous_p_links,
           sum(case when coalesce(s.n_p,0)=0 and s.n_c>1 then 1 else 0 end) as ambiguous_c_links,
           sum(case when coalesce(s.n_p,0)=0 and s.n_c=1 then 1 else 0 end) as c_only_links,
           sum(case when s.n_p=1 then 1 else 0 end) as unique_p_links
    from work.current0 as c left join work.linkstats as s
      on c.gvkey=s.gvkey and c.fyear=s.fyear and c.datadate=s.datadate
    group by c.fyear
    order by c.fyear;

    create table work.linkselected as
    select a.gvkey, a.fyear, a.datadate, a.permno, a.lrank,
           a.same_permno_link_rows
    from work.linkcand1 as a inner join work.linkstats as s
      on a.gvkey=s.gvkey and a.fyear=s.fyear and a.datadate=s.datadate
    where (a.lrank=1 and s.n_p=1)
       or (s.n_p=0 and s.n_c=1 and a.lrank=2);
quit;

proc print data=work.link_audit_year noobs label;
    title "Dated CCM link coverage and ambiguity by fiscal year";
run;

/* CRSP dated name/price-history intervals establish coverage and provide dated SIC only if SICH is absent. */
proc sql;
    create table work.namecand as
    select l.gvkey, l.fyear, l.datadate, l.permno,
           n.namedt, n.nameenddt, n.siccd as sic_crsp,
           n.st_date, n.end_date
    from work.linkselected as l inner join crsp.stocknames as n
      on l.permno=n.permno
     and (n.namedt=.B or n.namedt=. or n.namedt<=l.datadate)
     and (n.nameenddt=.E or n.nameenddt=. or n.nameenddt>=l.datadate)
     and (n.st_date=.B or n.st_date=. or n.st_date<=l.datadate)
     and (n.end_date=.E or n.end_date=. or n.end_date>=l.datadate);

    create table work.namecnt as
    select gvkey, fyear, datadate, permno, count(*) as n_name_rows
    from work.namecand
    group by gvkey, fyear, datadate, permno;

    create table work.name_audit_year as
    select l.fyear, count(*) as unique_link_rows,
           sum(case when missing(n.n_name_rows) then 1 else 0 end) as no_crsp_name_price_coverage,
           sum(case when n.n_name_rows>1 then 1 else 0 end) as ambiguous_name_intervals
    from work.linkselected as l left join work.namecnt as n
      on l.gvkey=n.gvkey and l.fyear=n.fyear and l.datadate=n.datadate and l.permno=n.permno
    group by l.fyear
    order by l.fyear;

    create table work.nameselected as
    select a.*
    from work.namecand as a inner join work.namecnt as n
      on a.gvkey=n.gvkey and a.fyear=n.fyear and a.datadate=n.datadate and a.permno=n.permno
    where n.n_name_rows=1;

    create table work.current_linked as
    select c.gvkey, c.fyear, c.datadate, c.curcd,
           c.at, c.ceq, c.ibc, c.oancf, c.ivncf, c.fincf, c.spi,
           c.sich, c.scf, c.pddur, n.permno, n.sic_crsp
    from work.current0 as c inner join work.nameselected as n
      on c.gvkey=n.gvkey and c.fyear=n.fyear and c.datadate=n.datadate;
quit;

proc print data=work.name_audit_year noobs label;
    title "CRSP name and price-history coverage by fiscal year";
run;

proc sql;
    create table work.sic_audit_year as
    select fyear, count(*) as crsp_linked_current_rows,
           sum(case when missing(sich) or sich=0 then 1 else 0 end) as missing_compustat_sich,
           sum(case when not missing(sic_crsp) and sic_crsp ne 0 then 1 else 0 end) as dated_crsp_sic_available,
           sum(case when (missing(sich) or sich=0) and (missing(sic_crsp) or sic_crsp=0) then 1 else 0 end) as missing_both_sic_sources
    from work.current_linked
    group by fyear
    order by fyear;
quit;

proc print data=work.sic_audit_year noobs label;
    title "Historical SIC gaps and dated CRSP fallback availability by fiscal year";
run;

/* Add actual adjacent fiscal-year records; no row-position lead/lag or future-asset filling is used. */
proc sql;
    create table work.paired as
    select c.gvkey, c.fyear, c.datadate, c.permno, c.curcd as curcd_t,
           c.at as at_t, c.ceq as ceq_t, c.ibc as ibc_t,
           c.oancf as oancf_t, c.ivncf as ivncf_t, c.fincf as fincf_t,
           c.spi as spi_t, c.sich as sic_comp, c.sic_crsp,
           p.datadate as datadate_prev, p.at as at_prev, p.curcd as curcd_prev,
           n.datadate as datadate_next, n.ibc as ibc_next, n.at as at_next,
           n.ceq as ceq_next, n.curcd as curcd_next
    from work.current_linked as c
    left join work.funda0 as p
      on c.gvkey=p.gvkey and p.fyear=c.fyear-1
    left join work.funda0 as n
      on c.gvkey=n.gvkey and n.fyear=c.fyear+1;
quit;

proc sql;
    create table work.currency_audit_year as
    select fyear, count(*) as linked_rows,
           sum(case when missing(curcd_t) or missing(curcd_prev) then 1 else 0 end) as missing_current_or_prior_curcd,
           sum(case when not missing(curcd_t) and not missing(curcd_prev) and curcd_t ne curcd_prev then 1 else 0 end) as current_prior_currency_mismatch,
           sum(case when not missing(curcd_t) and not missing(curcd_prev) and curcd_t=curcd_prev then 1 else 0 end) as current_prior_same_currency,
           sum(case when not missing(ibc_next) and (missing(curcd_next) or curcd_next ne curcd_t) then 1 else 0 end) as lead_cur_mismatch,
           sum(case when not missing(ibc_next) and (missing(at_next) or at_next<=0) then 1 else 0 end) as lead_badassets
    from work.paired
    group by fyear
    order by fyear;
quit;

proc print data=work.currency_audit_year noobs label;
    title "Own-period reporting currencies and actual lead denominator coverage by fiscal year";
run;

data work.metrics;
    set work.paired;
    length sic_source 8;
    sic_final=sic_comp;
    sic_source=1;
    if missing(sic_final) or sic_final=0 then do;
        sic_final=sic_crsp;
        sic_source=2;
    end;
    if missing(sic_final) or sic_final=0 then delete;
    if sic_final>=6000 and sic_final<=6999 then delete;
    if missing(curcd_t) or missing(curcd_prev) then delete;
    if curcd_t ne curcd_prev then delete;
    if missing(at_t) or missing(at_prev) then delete;
    if at_t<=0 or at_prev<=0 then delete;
    if missing(ibc_t) or missing(oancf_t) or missing(ivncf_t) then delete;

    avg_at_t=(at_t+at_prev)/2;
    if missing(avg_at_t) or avg_at_t<=0 then delete;
    earnings_t=ibc_t/avg_at_t;
    cfo_t=oancf_t/avg_at_t;
    cfi_t=ivncf_t/avg_at_t;
    if missing(fincf_t) then cff_t=.;
    else cff_t=fincf_t/avg_at_t;
    fcf_t=(oancf_t+ivncf_t)/avg_at_t;
    opacc_t=(ibc_t-oancf_t)/avg_at_t;
    tacc_t=(ibc_t-(oancf_t+ivncf_t))/avg_at_t;

    spi_missing=missing(spi_t);
    if spi_missing then spi0=0;
    else spi0=spi_t;
    spi_ratio=spi0/avg_at_t;
    si=(spi_ratio<=-0.02);
    format datadate datadate_prev datadate_next yymmdd10.;
run;

proc sql;
    create table work.current_screen_year as
    select fyear, count(*) as eligible_current_rows,
           sum(case when sic_source=2 then 1 else 0 end) as dated_crsp_sic_fallback,
           sum(case when spi_missing=1 then 1 else 0 end) as spi_zero_replacements,
           sum(case when missing(cff_t) then 1 else 0 end) as missing_financing_flow,
           sum(case when missing(datadate_prev) then 1 else 0 end) as no_fyear_lag_row,
           sum(case when missing(datadate_next) then 1 else 0 end) as no_fyear_lead_row
    from work.metrics
    group by fyear
    order by fyear;
quit;

proc print data=work.current_screen_year noobs label;
    title "Current-year accounting eligibility and support counts";
run;

/* The future outcome may be replaced only when raw IBC is absent and a dated performance delist is verified. */
data work.metrics_window;
    set work.metrics;
    if not missing(datadate_next) then event_end=datadate_next;
    else event_end=intnx('year',datadate,1,'same');
    format event_end yymmdd10.;
run;

data work.performance_delists;
    set crsp.dsedelist(keep=permno dlstdt dlstcd);
    if missing(dlstdt) then delete;
    if not (dlstcd=500 or (dlstcd>=520 and dlstcd<=584)) then delete;
run;

proc sql;
    create table work.eventcand as
    select m.gvkey, m.fyear, m.datadate, d.dlstdt, d.dlstcd
    from work.metrics_window as m inner join work.performance_delists as d
      on m.permno=d.permno
     and d.dlstdt>m.datadate
     and d.dlstdt<=m.event_end;

    create table work.eventagg as
    select gvkey, fyear, datadate, count(*) as n_perf_events,
           min(dlstdt) as perf_dlstdt format=yymmdd10.
    from work.eventcand
    group by gvkey, fyear, datadate;

    create table work.perf_event as
    select a.gvkey, a.fyear, a.datadate, a.perf_dlstdt,
           a.n_perf_events, min(e.dlstcd) as perf_dlstcd
    from work.eventagg as a inner join work.eventcand as e
      on a.gvkey=e.gvkey and a.fyear=e.fyear and a.datadate=e.datadate
     and a.perf_dlstdt=e.dlstdt
    group by a.gvkey, a.fyear, a.datadate, a.perf_dlstdt, a.n_perf_events;

    create table work.outcome_join as
    select m.*, e.perf_dlstdt, e.perf_dlstcd,
           coalesce(e.n_perf_events,0) as n_perf_events
    from work.metrics_window as m left join work.perf_event as e
      on m.gvkey=e.gvkey and m.fyear=e.fyear and m.datadate=e.datadate;
quit;

data work.outcomes;
    set work.outcome_join;
    length outcome_source 8 book_source 8 deflator_source 8;
    length event_state 8;
    earnings_next=.;
    book_used=.;
    book_date=.;
    avg_at_next=.;
    deflator_date=.;
    outcome_source=0;
    book_source=0;
    deflator_source=0;
    event_state=0;
    raw_lead_missing=missing(ibc_next);
    no_lead_statement=missing(datadate_next);
    observed_lead_unscaled=0;
    book_negative=.;
    book_nonnegative=.;

    if not missing(ibc_next) then do;
        event_state=1;
        if not missing(at_next) and at_next>0
           and not missing(curcd_next) and curcd_next=curcd_t then do;
            avg_at_next=(at_t+at_next)/2;
            if avg_at_next>0 then do;
                earnings_next=ibc_next/avg_at_next;
                outcome_source=1;
                deflator_source=1;
                deflator_date=datadate_next;
            end;
        end;
        if missing(earnings_next) then observed_lead_unscaled=1;
    end;
    else if not missing(perf_dlstdt) then do;
        event_state=2;
        /* A delisting replacement can use only book equity dated by the event. */
        if not missing(ceq_next) and not missing(curcd_next)
           and not missing(datadate_next) and datadate_next<=perf_dlstdt
           and curcd_next=curcd_t then do;
            book_used=ceq_next;
            book_date=datadate_next;
            book_source=1;
        end;
        else if not missing(ceq_t) then do;
            book_used=ceq_t;
            book_date=datadate;
            book_source=2;
        end;

        if not missing(book_used) then do;
            if book_used<0 then do;
                earnings_num=0;
                book_negative=1;
            end;
            else do;
                earnings_num=-book_used;
                book_nonnegative=1;
            end;

            /* Keep the deflator within the event information date as well. */
            if not missing(at_next) and at_next>0
               and not missing(datadate_next) and datadate_next<=perf_dlstdt
               and not missing(curcd_next) and curcd_next=curcd_t then do;
                avg_at_next=(at_t+at_next)/2;
                deflator_source=1;
                deflator_date=datadate_next;
            end;
            else do;
                avg_at_next=avg_at_t;
                deflator_source=2;
                deflator_date=datadate;
            end;
            if avg_at_next>0 then do;
                earnings_next=earnings_num/avg_at_next;
                outcome_source=2;
            end;
        end;
    end;
    else event_state=3;

    format datadate datadate_prev datadate_next event_end perf_dlstdt book_date deflator_date yymmdd10.;
run;

/* Percentiles are pooled across fiscal years and use the eligible observations before trimming. */
proc means data=work.metrics noprint;
    var earnings_t cfo_t cfi_t cff_t fcf_t opacc_t tacc_t;
    output out=work.currentcuts
        p1=earn_p1 cfo_p1 cfi_p1 cff_p1 fcf_p1 opacc_p1 tacc_p1
        p99=earn_p99 cfo_p99 cfi_p99 cff_p99 fcf_p99 opacc_p99 tacc_p99;
run;

proc means data=work.outcomes noprint;
    var earnings_next;
    output out=work.futurecuts p1=lead_p1 p99=lead_p99;
run;

/* Unequal dates/amounts and signed CFI expose denominator and sign mistakes. */
data work.formula_probe;
    at_prev=80; at_t=120; at_next=180;
    ibc_t=24; oancf_t=15; ivncf_t=-21; fincf_t=8;
    spi_t=.; ibc_next=30; ceq_t=12; ceq_negative=-6;
    avg_at_t=(at_t+at_prev)/2;
    earnings_t=ibc_t/avg_at_t;
    cfo_t=oancf_t/avg_at_t;
    cfi_t=ivncf_t/avg_at_t;
    cff_t=fincf_t/avg_at_t;
    fcf_t=(oancf_t+ivncf_t)/avg_at_t;
    opacc_t=(ibc_t-oancf_t)/avg_at_t;
    tacc_t=(ibc_t-(oancf_t+ivncf_t))/avg_at_t;
    if missing(spi_t) then spi0=0;
    spi_ratio=spi0/avg_at_t;
    si=(spi_ratio<=-0.02);
    avg_at_next=(at_t+at_next)/2;
    earnings_next=ibc_next/avg_at_next;
    delist_pos_book=-ceq_t/avg_at_next;
    delist_neg_book=0/avg_at_next;
    formula_probe_errors=0;
    if abs(avg_at_t-100)>1e-12 then formula_probe_errors+1;
    if abs(earnings_t-0.24)>1e-12 then formula_probe_errors+1;
    if abs(cfo_t-0.15)>1e-12 then formula_probe_errors+1;
    if abs(cfi_t-(-0.21))>1e-12 then formula_probe_errors+1;
    if abs(cff_t-0.08)>1e-12 then formula_probe_errors+1;
    if abs(fcf_t-(-0.06))>1e-12 then formula_probe_errors+1;
    if abs(opacc_t-0.09)>1e-12 then formula_probe_errors+1;
    if abs(tacc_t-0.30)>1e-12 then formula_probe_errors+1;
    if spi_ratio ne 0 or si ne 0 then formula_probe_errors+1;
    if abs(avg_at_next-150)>1e-12 then formula_probe_errors+1;
    if abs(earnings_next-0.20)>1e-12 then formula_probe_errors+1;
    if abs(delist_pos_book-(-0.08))>1e-12 then formula_probe_errors+1;
    if delist_neg_book ne 0 then formula_probe_errors+1;
run;

proc sql;
    select max(formula_probe_errors) as formula_probe_errors
    from work.formula_probe;
quit;

data work.trimmed;
    if _n_=1 then do;
        set work.currentcuts;
        set work.futurecuts;
    end;
    set work.outcomes;

    bad_current=0;
    if earnings_t<earn_p1 or earnings_t>earn_p99 then bad_current=1;
    if cfo_t<cfo_p1 or cfo_t>cfo_p99 then bad_current=1;
    if cfi_t<cfi_p1 or cfi_t>cfi_p99 then bad_current=1;
    if not missing(cff_t) and (cff_t<cff_p1 or cff_t>cff_p99) then bad_current=1;
    if fcf_t<fcf_p1 or fcf_t>fcf_p99 then bad_current=1;
    if opacc_t<opacc_p1 or opacc_t>opacc_p99 then bad_current=1;
    if tacc_t<tacc_p1 or tacc_t>tacc_p99 then bad_current=1;

    bad_lead=0;
    if not missing(earnings_next) then do;
        if earnings_next<lead_p1 or earnings_next>lead_p99 then bad_lead=1;
    end;

    table1_sample=(bad_current=0);
    table2_pre=(table1_sample=1 and not missing(earnings_next) and bad_lead=0);
    format datadate datadate_prev datadate_next event_end perf_dlstdt book_date yymmdd10.;
run;

proc sql;
    select * from work.currentcuts;
    select * from work.futurecuts;

    create table work.trim_attrition as
    select fyear, count(*) as eligible_before_trim,
           sum(case when table1_sample=1 then 1 else 0 end) as table1_after_current_trim,
           sum(case when table2_pre=1 then 1 else 0 end) as table2_before_deciles,
           sum(case when table1_sample=1 and not missing(earnings_next) then 1 else 0 end) as t1_with_usable_lead_before_trim,
           sum(case when table1_sample=1 and missing(earnings_next) then 1 else 0 end) as t1_without_usable_lead,
           sum(case when table1_sample=1 and bad_lead=1 then 1 else 0 end) as lead_tail_drops,
           sum(case when table1_sample=0 then 1 else 0 end) as current_tail_drops
    from work.trimmed
    group by fyear
    order by fyear;
quit;

proc print data=work.trim_attrition noobs label;
    title "Pooled 1% tail-trim attrition by fiscal year";
run;

proc sort data=work.trimmed out=work.trimmed_rank_s;
    by fyear gvkey datadate;
run;

data work.t2_rankbase;
    set work.trimmed_rank_s;
    if table2_pre=1;
run;

proc sort data=work.t2_rankbase;
    by fyear;
run;

proc rank data=work.t2_rankbase out=work.ranked groups=10 ties=mean;
    by fyear;
    var opacc_t tacc_t;
    ranks op_rank tacc_rank;
run;

proc sort data=work.ranked out=work.ranked_s;
    by gvkey fyear datadate;
run;

proc sort data=work.trimmed out=work.trimmed_key;
    by gvkey fyear datadate;
run;

data work.final;
    merge work.trimmed_key(in=in_table1)
          work.ranked_s(keep=gvkey fyear datadate op_rank tacc_rank in=in_table2);
    by gvkey fyear datadate;
    if in_table1 and table1_sample=1;
    table2_sample=in_table2;

    if table2_sample then do;
        low_op=(op_rank=0);
        low_tacc=(tacc_rank=0);
        earn_low_op=earnings_t*low_op;
        earn_low_op_si=earnings_t*low_op*si;
        earn_low_tacc=earnings_t*low_tacc;
        earn_low_tacc_si=earnings_t*low_tacc*si;
    end;
    else do;
        low_op=.;
        low_tacc=.;
        earn_low_op=.;
        earn_low_op_si=.;
        earn_low_tacc=.;
        earn_low_tacc_si=.;
    end;

    formula_bad=0;
    if abs(earnings_t-(ibc_t/avg_at_t))>1e-12 then formula_bad=1;
    if abs(cfo_t-(oancf_t/avg_at_t))>1e-12 then formula_bad=1;
    if abs(cfi_t-(ivncf_t/avg_at_t))>1e-12 then formula_bad=1;
    if not missing(cff_t) and abs(cff_t-(fincf_t/avg_at_t))>1e-12 then formula_bad=1;
    if abs(fcf_t-((oancf_t+ivncf_t)/avg_at_t))>1e-12 then formula_bad=1;
    if abs(opacc_t-((ibc_t-oancf_t)/avg_at_t))>1e-12 then formula_bad=1;
    if abs(tacc_t-((ibc_t-(oancf_t+ivncf_t))/avg_at_t))>1e-12 then formula_bad=1;
    if abs(spi_ratio-(spi0/avg_at_t))>1e-12 then formula_bad=1;
    if table2_sample then do;
        if abs(earn_low_op-(earnings_t*low_op))>1e-12 then formula_bad=1;
        if abs(earn_low_op_si-(earnings_t*low_op*si))>1e-12 then formula_bad=1;
        if abs(earn_low_tacc-(earnings_t*low_tacc))>1e-12 then formula_bad=1;
        if abs(earn_low_tacc_si-(earnings_t*low_tacc*si))>1e-12 then formula_bad=1;
        if outcome_source=1 and
           abs(earnings_next-(ibc_next/((at_t+at_next)/2)))>1e-12 then formula_bad=1;
        if outcome_source=2 and
           abs(earnings_next-(earnings_num/avg_at_next))>1e-12 then formula_bad=1;
        if outcome_source=2 and
           (book_date>perf_dlstdt or deflator_date>perf_dlstdt) then formula_bad=1;
    end;

    label gvkey="Compustat GVKEY"
          fyear="Fiscal year"
          datadate="Current Compustat data date"
          permno="Matched CRSP PERMNO"
          sic_final="Historical SIC used for the financial-firm screen"
          curcd_t="Reporting currency at t"
          earnings_t="Earnings before extraordinary items (IBC) / average assets"
          earnings_next="One-year-ahead earnings or eligible delisting substitute / deflator"
          cfo_t="Cash flow from operations (OANCF) / average assets"
          cfi_t="Cash flow from investing (IVNCF) / average assets"
          cff_t="Cash flow from financing (FINCF) / average assets"
          fcf_t="Free cash flow (OANCF + IVNCF) / average assets"
          opacc_t="Operating accruals (IBC - OANCF) / average assets"
          tacc_t="Total accruals (IBC - FCF) / average assets"
          spi_ratio="Special items (SPI; missing set to zero) / average assets"
          si="Negative special items at least 2% of average assets"
          low_op="Annual bottom OPACC decile"
          low_tacc="Annual bottom TACC decile"
          earn_low_op="Earnings x Low OPACC"
          earn_low_op_si="Earnings x Low OPACC x SI"
          earn_low_tacc="Earnings x Low TACC"
          earn_low_tacc_si="Earnings x Low TACC x SI"
          table1_sample="Eligible trimmed Table 1 current-year pool"
          table2_sample="Common eligible Table 2 equation (6) sample"
          outcome_source="1=reported future IBC; 2=verified delisting substitution"
          book_source="1=event-date-supported next-year CEQ; 2=current-year CEQ"
          book_date="Date of book-equity observation used for delisting replacement"
          deflator_source="1=event-supported next-year average assets; 2=current average assets"
          deflator_date="Date of latest assets observation used for delisting replacement"
          perf_dlstcd="Performance-related CRSP delisting code";
    format datadate datadate_prev datadate_next event_end perf_dlstdt book_date deflator_date yymmdd10.;
run;

proc sort data=work.final out=out.accrual_persistence_main;
    by gvkey fyear;
run;

proc sql;
    create table work.final_counts as
    select fyear, count(*) as table1_n,
           sum(table2_sample) as table2_n,
           sum(case when outcome_source=1 then 1 else 0 end) as reported_future_outcomes,
           sum(case when outcome_source=2 then 1 else 0 end) as delist_replacements,
           sum(case when outcome_source=2 and book_negative=1 then 1 else 0 end) as negative_book_to_zero,
           sum(case when outcome_source=2 and book_nonnegative=1 then 1 else 0 end) as nonnegative_book_to_negative,
           sum(case when outcome_source=2 and book_source=1 then 1 else 0 end) as next_year_book_used,
           sum(case when outcome_source=2 and book_source=2 then 1 else 0 end) as current_book_used,
           sum(case when outcome_source=2 and book_date>perf_dlstdt then 1 else 0 end) as book_date_after_event,
           sum(case when outcome_source=2 and deflator_source=1 then 1 else 0 end) as actual_future_deflator_used,
           sum(case when outcome_source=2 and deflator_source=2 then 1 else 0 end) as current_deflator_used,
           sum(case when outcome_source=2 and deflator_date>perf_dlstdt then 1 else 0 end) as deflator_date_after_event,
           sum(case when raw_lead_missing=1 and missing(perf_dlstdt) then 1 else 0 end) as leadmiss_noperf,
           sum(observed_lead_unscaled) as lead_unscaled,
           sum(no_lead_statement) as absent_next_statement,
           sum(case when table2_sample=1 and outcome_source=1 then 1 else 0 end) as t2_reported_future,
           sum(case when table2_sample=1 and outcome_source=2 then 1 else 0 end) as t2_delist_replacements,
           sum(case when table2_sample=1 and outcome_source=2 and book_negative=1 then 1 else 0 end) as t2_negative_book_to_zero,
           sum(case when table2_sample=1 and outcome_source=2 and book_nonnegative=1 then 1 else 0 end) as t2_nonnegative_book_to_negative,
           sum(case when table2_sample=1 and outcome_source=2 and book_source=1 then 1 else 0 end) as t2_next_year_book_used,
           sum(case when table2_sample=1 and outcome_source=2 and book_source=2 then 1 else 0 end) as t2_current_book_used,
           sum(case when table2_sample=1 and outcome_source=2 and book_date>perf_dlstdt then 1 else 0 end) as t2_book_date_after_event,
           sum(case when table2_sample=1 and outcome_source=2 and deflator_date>perf_dlstdt then 1 else 0 end) as t2_deflator_date_after_event,
           sum(case when table2_sample=1 and raw_lead_missing=1 and not missing(perf_dlstdt) then 1 else 0 end) as t2_missing_ibc_with_perf,
           sum(case when table2_sample=1 and raw_lead_missing=1 and missing(perf_dlstdt) then 1 else 0 end) as t2_missing_ibc_without_perf,
           sum(case when table2_sample=1 and observed_lead_unscaled=1 then 1 else 0 end) as t2_observed_ibc_unscaled
    from out.accrual_persistence_main
    group by fyear
    order by fyear;

    create table work.event_code_counts as
    select fyear, dlstcd, count(*) as event_matches
    from work.eventcand
    group by fyear, dlstcd
    order by fyear, dlstcd;

    select count(*) as output_rows,
           count(distinct gvkey) as output_gvkeys,
           sum(table1_sample) as table1_rows,
           sum(table2_sample) as table2_rows,
           sum(formula_bad) as handoff_formula_errors
    from out.accrual_persistence_main;
quit;

proc print data=work.final_counts noobs label;
    title "Table 1/Table 2 and delisting construction counts by fiscal year";
run;

proc print data=work.event_code_counts noobs label;
    title "Performance-related CRSP event codes in the t-to-t+1 chronology window";
run;

proc sql;
    create table work.delist_date_audit as
    select gvkey, fyear, datadate, event_end, datadate_next,
           perf_dlstdt, perf_dlstcd, no_lead_statement,
           book_date, book_source, deflator_date, deflator_source, book_used,
           earnings_next
    from out.accrual_persistence_main
    where table2_sample=1 and outcome_source=2
    order by perf_dlstdt, gvkey;

    select count(*) as delist_date_cases,
           sum(case when perf_dlstdt>datadate and perf_dlstdt<=event_end then 1 else 0 end) as inside_actual_window,
           sum(case when not missing(datadate_next) and perf_dlstdt<datadate_next then 1 else 0 end) as before_observed_lead_statement,
           sum(case when missing(datadate_next) and event_end=intnx('year',datadate,1,'same') then 1 else 0 end) as anniversary_window_cases
    from work.delist_date_audit;
quit;

proc print data=work.delist_date_audit noobs label;
    title "All Table 2 delisting replacements with event-dated book and deflator sources";
run;

proc freq data=out.accrual_persistence_main;
    tables fyear*table2_sample / norow nocol nopercent;
    tables fyear*low_op fyear*low_tacc / norow nocol nopercent;
    title "Final sample and annual bottom-decile group counts";
run;

proc means data=out.accrual_persistence_main n mean std min p25 median p75 max;
    var earnings_t cfo_t cfi_t cff_t fcf_t opacc_t tacc_t spi_ratio earnings_next;
    title "Final handoff distribution checks, all retained current-year rows";
run;

proc means data=out.accrual_persistence_main n mean std min p25 median p75 max;
    where table2_sample=1;
    var earnings_next cfo_t opacc_t fcf_t tacc_t earn_low_op earn_low_op_si earn_low_tacc earn_low_tacc_si;
    title "Final handoff distribution checks, common Table 2 sample";
run;

proc contents data=out.accrual_persistence_main varnum;
    title "Declared SAS handoff fields";
run;

title;
