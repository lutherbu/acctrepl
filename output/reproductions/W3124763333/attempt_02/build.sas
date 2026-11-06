options errorabend;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname compfx "/storage/sas/base/comp/d_global/currency" access=readonly;
libname crspstk "/storage/sas/base/crsp/a_stock" access=readonly;
libname crspidx "/storage/sas/base/crsp/a_indexes" access=readonly;
libname ccm "/storage/sas/base/crsp/a_ccm" access=readonly;
libname rep "./data/order_backlog_firm_years";

/* Cross-rates use the documented GBP intermediary.  Daily point-date rates
   convert balance-sheet assets; the provider's 12-month monthly rate at the
   reporting month converts income-statement flows.  USD values need no rate. */
proc sql;
    create table fx_daily_usd as
    select datadate, exratd as gbp_usd, exrattpd as usd_type
    from compfx.g_exrt_dly
    where upcase(strip(fromcurd))='GBP' and upcase(strip(tocurd))='USD'
          and exratd>0;
    create table fx_daily_local0 as
    select r.datadate, upcase(strip(r.tocurd)) as curcd length=4,
           r.exratd as gbp_local, r.exrattpd as local_type,
           u.gbp_usd, u.usd_type
    from compfx.g_exrt_dly as r left join fx_daily_usd as u
      on r.datadate=u.datadate
    where upcase(strip(r.fromcurd))='GBP' and upcase(strip(r.tocurd)) ne 'GBP'
          and exratd>0;
    create table fx_daily_local as
    select datadate, curcd,
           case when curcd='USD' then 1
                when curcd='GBP' and gbp_usd>0 then gbp_usd
                when gbp_usd>0 and gbp_local>0 then gbp_usd/gbp_local
                else . end as fx_to_usd,
           local_type, usd_type
    from fx_daily_local0;
    create table fx_daily_with_gbp as
    select * from fx_daily_local
    union all
    select datadate, 'GBP' as curcd length=4, gbp_usd as fx_to_usd,
           'GBP' as local_type length=3, usd_type
    from fx_daily_usd;
    create table fx_daily_n as
    select datadate, curcd, count(*) as n_rate
    from fx_daily_with_gbp
    group by datadate, curcd;
    create table fx_daily_unique as
    select r.*
    from fx_daily_with_gbp as r inner join fx_daily_n as n
      on r.datadate=n.datadate and r.curcd=n.curcd
    where n.n_rate=1 and r.fx_to_usd>0;

    create table fx_month_usd as
    select datadate, exrat12m as gbp_usd
    from compfx.g_exrt_mth
    where upcase(strip(fromcurm))='GBP' and upcase(strip(tocurm))='USD'
          and exrat12m>0;
    create table fx_month_local0 as
    select r.datadate, upcase(strip(r.tocurm)) as curcd length=4,
           r.exrat12m as gbp_local, u.gbp_usd
    from compfx.g_exrt_mth as r left join fx_month_usd as u
      on r.datadate=u.datadate
    where upcase(strip(r.fromcurm))='GBP' and upcase(strip(r.tocurm)) ne 'GBP'
          and exrat12m>0;
    create table fx_month_local as
    select datadate, curcd,
           case when curcd='USD' then 1
                when curcd='GBP' and gbp_usd>0 then gbp_usd
                when gbp_usd>0 and gbp_local>0 then gbp_usd/gbp_local
                else . end as fx_to_usd
    from fx_month_local0;
    create table fx_month_with_gbp as
    select * from fx_month_local
    union all
    select datadate, 'GBP' as curcd length=4, gbp_usd as fx_to_usd
    from fx_month_usd;
    create table fx_month_n as
    select datadate, curcd, count(*) as n_rate
    from fx_month_with_gbp
    group by datadate, curcd;
    create table fx_month_unique as
    select r.*
    from fx_month_with_gbp as r inner join fx_month_n as n
      on r.datadate=n.datadate and r.curcd=n.curcd
    where n.n_rate=1 and r.fx_to_usd>0;

    select count(*) as dup_fxday_keys
    from fx_daily_n where n_rate ne 1;
    select count(*) as dup_fxmonth_keys
    from fx_month_n where n_rate ne 1;
quit;

/* Current annual Compustat history.  OB is the provider's annual item A98. */
data funda_raw;
    set comp.funda(keep=gvkey datadate fyear indfmt consol popsrc datafmt
                        ib at ob curcd final fdate pdate
                   where=(fyear>=1980 and fyear<=2000 and indfmt='INDL' and
                          consol='C' and popsrc='D' and datafmt='STD'));
    curcd=upcase(strip(curcd));
    final_priority=(upcase(strip(final)) in ('Y','F'));
    if missing(gvkey) or missing(datadate) or missing(fyear) then delete;
run;

proc freq data=funda_raw;
    tables final / missing;
run;

proc sql;
    create table funda_dups as
    select gvkey, fyear, count(*) as n
    from funda_raw
    group by gvkey, fyear
    having calculated n>1;
    select count(*) as duplicate_gvkey_fyear_groups,
           coalesce(sum(n-1),0) as extra_duplicate_rows
    from funda_dups;
quit;

/* Prefer a final record, then the latest final/preliminary source dates. */
proc sort data=funda_raw out=funda_sort;
    by gvkey fyear descending final_priority descending fdate
       descending pdate descending datadate;
run;

data funda;
    set funda_sort;
    by gvkey fyear;
    if first.fyear;
    keep gvkey datadate fyear ib at ob curcd;
run;

/* Fiscal-year t earnings and backlog use the t-1/t asset average;
   EARN(t+1) uses its own t/t+1 average. */
proc sql;
    create table acct_join as
    select t.gvkey, t.datadate, t.fyear, t.ib, t.at, t.ob, t.curcd,
           p.datadate as datadate_prev, p.at as at_prev, p.curcd as curcd_prev,
           n.datadate as datadate_next, n.ib as ib_next, n.at as at_next,
           n.curcd as curcd_next
    from funda as t
    left join funda as p
      on t.gvkey=p.gvkey and p.fyear=t.fyear-1
    left join funda as n
      on t.gvkey=n.gvkey and n.fyear=t.fyear+1
    where t.fyear>=1981 and t.fyear<=1999;
quit;

data acct_dates;
    set acct_join;
    flow_date_t=intnx('month',datadate,0,'end');
    if not missing(datadate_next) then
        flow_date_next=intnx('month',datadate_next,0,'end');
    else flow_date_next=.;
    format flow_date_t flow_date_next date9.;
run;

proc sql;
    create table acct_fx as
    select a.*,
           case when a.curcd_prev='USD' then 1 else fp.fx_to_usd end as fx_at_prev,
           case when a.curcd='USD' then 1 else fc.fx_to_usd end as fx_at_t,
           case when a.curcd_next='USD' then 1 else fn.fx_to_usd end as fx_at_next,
           case when a.curcd='USD' then 1 else ft.fx_to_usd end as fx_flow_t,
           case when a.curcd_next='USD' then 1 else fnext.fx_to_usd end as fx_flow_next,
           fp.local_type as fx_prev_at_type,
           fc.local_type as fx_t_at_type,
           fn.local_type as fx_next_at_type,
           fp.usd_type as fx_prev_usd_type,
           fc.usd_type as fx_t_usd_type,
           fn.usd_type as fx_next_usd_type
    from acct_dates as a
    left join fx_daily_unique as fp
      on fp.datadate=a.datadate_prev and fp.curcd=a.curcd_prev
    left join fx_daily_unique as fc
      on fc.datadate=a.datadate and fc.curcd=a.curcd
    left join fx_daily_unique as fn
      on fn.datadate=a.datadate_next and fn.curcd=a.curcd_next
    left join fx_month_unique as ft
      on ft.datadate=a.flow_date_t and ft.curcd=a.curcd
    left join fx_month_unique as fnext
      on fnext.datadate=a.flow_date_next and
         fnext.curcd=a.curcd_next;
quit;

data acct_panel;
    set acct_fx;
    length basis_current basis_lead $6;
    format datadate datadate_prev datadate_next date9.;
    has_nonzero_ob=(not missing(ob) and ob ne 0);
    adjacent_dates_ok=(not missing(datadate_prev) and not missing(datadate_next)
                       and datadate_prev<datadate and datadate<datadate_next);
    current_codes_known=(not missing(curcd_prev) and not missing(curcd));
    lead_codes_known=(not missing(curcd) and not missing(curcd_next));
    same_current_currency=(current_codes_known and curcd_prev=curcd);
    same_lead_currency=(lead_codes_known and curcd=curcd_next);
    mixed_current_currency=(current_codes_known and not same_current_currency);
    mixed_lead_currency=(lead_codes_known and not same_lead_currency);
    current_inputs_complete=(has_nonzero_ob and adjacent_dates_ok and
                             nmiss(at_prev,at,ib,ob)=0);
    lead_inputs_complete=(adjacent_dates_ok and nmiss(at,at_next,ib_next)=0);
    fx_current_complete=(nmiss(fx_at_prev,fx_at_t,fx_flow_t)=0);
    fx_lead_complete=(nmiss(fx_at_t,fx_at_next,fx_flow_next)=0);
    avg_at_t=.; avg_at_next=.; earn_t=.; earn_lead=.; bklg=.;
    basis_current=''; basis_lead='';
    if current_inputs_complete and same_current_currency then do;
        avg_at_t=(at_prev+at)/2;
        if avg_at_t ne 0 then do;
            earn_t=ib/avg_at_t;
            bklg=ob/avg_at_t;
        end;
        basis_current='native';
    end;
    else if current_inputs_complete and mixed_current_currency and fx_current_complete then do;
        at_prev_usd=at_prev*fx_at_prev;
        at_t_usd=at*fx_at_t;
        ib_t_usd=ib*fx_flow_t;
        ob_t_usd=ob*fx_at_t;
        avg_at_t=(at_prev_usd+at_t_usd)/2;
        if avg_at_t ne 0 then do;
            earn_t=ib_t_usd/avg_at_t;
            bklg=ob_t_usd/avg_at_t;
        end;
        basis_current='USD FX';
    end;
    if lead_inputs_complete and same_lead_currency then do;
        avg_at_next=(at+at_next)/2;
        if avg_at_next ne 0 then earn_lead=ib_next/avg_at_next;
        basis_lead='native';
    end;
    else if lead_inputs_complete and mixed_lead_currency and fx_lead_complete then do;
        at_t_usd=at*fx_at_t;
        at_next_usd=at_next*fx_at_next;
        ib_next_usd=ib_next*fx_flow_next;
        avg_at_next=(at_t_usd+at_next_usd)/2;
        if avg_at_next ne 0 then earn_lead=ib_next_usd/avg_at_next;
        basis_lead='USD FX';
    end;
    acct_complete=(current_inputs_complete and lead_inputs_complete and
                   current_codes_known and lead_codes_known and
                   not missing(earn_t) and not missing(earn_lead) and
                   not missing(bklg));
    start_month=intnx('month',datadate,4,'b');
    return_year=year(start_month);
    form_year=return_year-1;
    form_date=mdy(12,31,form_year);
    format start_month form_date date9.;
run;

proc sql;
    select count(*) as compustat_firm_years_1981_1999,
           sum(has_nonzero_ob=1) as nonzero_ob_rows,
           sum(adjacent_dates_ok=0) as bad_adjacent_dates,
           sum(current_inputs_complete and mixed_current_currency) as mixed_current_inputs,
           sum(current_inputs_complete and mixed_current_currency and
               fx_current_complete) as current_fx_supported,
           sum(current_inputs_complete and mixed_current_currency and
               not fx_current_complete) as current_fx_unavailable,
           sum(lead_inputs_complete and mixed_lead_currency) as mixed_lead_inputs,
           sum(lead_inputs_complete and mixed_lead_currency and
               fx_lead_complete) as lead_fx_supported,
           sum(lead_inputs_complete and mixed_lead_currency and
               not fx_lead_complete) as lead_fx_unavailable,
           sum(current_inputs_complete and not current_codes_known) as current_currency_missing,
           sum(lead_inputs_complete and not lead_codes_known) as lead_currency_missing,
           sum(current_inputs_complete and same_current_currency) as current_native_inputs,
           sum(lead_inputs_complete and same_lead_currency) as lead_native_inputs,
           sum(acct_complete=1) as complete_accounting_rows
    from acct_panel;
    select fyear, count(*) as compustat_rows,
           sum(has_nonzero_ob=1) as nonzero_ob_rows,
           sum(acct_complete=1) as complete_accounting_rows
    from acct_panel
    group by fyear;
quit;

/* Date-valid CCM links at fiscal year-end and at the prior-year-end CRSP
   formation date.  Open SAS missing-date codes are treated as open bounds. */
data ccm_links;
    set ccm.ccmxpf_linktable(keep=gvkey linkprim linktype lpermno lpermco
                                  linkdt linkenddt
                             where=(linktype in ('LC','LU') and
                                    linkprim in ('P','C')));
    permno=lpermno;
    permco=lpermco;
    linkrank=(ifn(linkprim='P',0,10)+ifn(linktype='LC',0,1));
    if missing(permno) then delete;
    keep gvkey permno permco linkrank linkdt linkenddt linkprim linktype;
run;

proc sql;
    create table link_fye_cand as
    select distinct a.gvkey, a.datadate, a.fyear, l.permno, l.permco,
           l.linkrank
    from acct_panel as a inner join ccm_links as l
      on a.gvkey=l.gvkey
    where a.acct_complete=1 and
          (missing(l.linkdt) or l.linkdt<=a.datadate) and
          (missing(l.linkenddt) or a.datadate<=l.linkenddt);

    create table link_fye_min as
    select gvkey, datadate, min(linkrank) as minrank
    from link_fye_cand
    group by gvkey, datadate;
    create table link_fye_best as
    select c.*
    from link_fye_cand as c inner join link_fye_min as m
      on c.gvkey=m.gvkey and c.datadate=m.datadate and c.linkrank=m.minrank;
    create table link_fye_n as
    select gvkey, datadate, count(distinct permno) as n_permno,
           count(distinct permco) as n_permco
    from link_fye_best
    group by gvkey, datadate;
    create table link_fye as
    select b.gvkey, b.datadate, b.fyear, min(b.permno) as permno,
           min(b.permco) as permco
    from link_fye_best as b inner join link_fye_n as n
      on b.gvkey=n.gvkey and b.datadate=n.datadate
    where n.n_permno=1 and n.n_permco=1
    group by b.gvkey, b.datadate, b.fyear;

    create table link_form_cand as
    select distinct a.gvkey, a.datadate, a.fyear, a.form_date, l.permno,
           l.permco, l.linkrank
    from acct_panel as a inner join ccm_links as l
      on a.gvkey=l.gvkey
    where a.acct_complete=1 and
          (missing(l.linkdt) or l.linkdt<=a.form_date) and
          (missing(l.linkenddt) or a.form_date<=l.linkenddt);

    create table link_form_min as
    select gvkey, form_date, min(linkrank) as minrank
    from link_form_cand
    group by gvkey, form_date;
    create table link_form_best as
    select c.*
    from link_form_cand as c inner join link_form_min as m
      on c.gvkey=m.gvkey and c.form_date=m.form_date and c.linkrank=m.minrank;
    create table link_form_n as
    select gvkey, form_date, count(distinct permno) as n_permno,
           count(distinct permco) as n_permco
    from link_form_best
    group by gvkey, form_date;
    create table link_form as
    select b.gvkey, b.form_date, min(b.permno) as permno,
           min(b.permco) as permco
    from link_form_best as b inner join link_form_n as n
      on b.gvkey=n.gvkey and b.form_date=n.form_date
    where n.n_permno=1 and n.n_permco=1
    group by b.gvkey, b.form_date;

    select count(*) as fiscal_date_best_link_groups,
           sum(n_permno ne 1 or n_permco ne 1) as fiscal_date_ambiguous_best_links
    from link_fye_n;
    select count(*) as formation_date_best_link_groups,
           sum(n_permno ne 1 or n_permco ne 1) as form_ambig_links
    from link_form_n;
    select count(*) as unique_fiscal_date_links from link_fye;
    select count(*) as unique_formation_date_links from link_form;
quit;

/* CRSP monthly issue capitalization is absolute price x period shares.
   Match dated names, use the NYSE/AMEX/NASDAQ index universe, and exclude ADRs. */
data msf_all;
    set crspstk.msf(keep=permno permco date ret prc shrout
                    where=(date>='01JAN1980'd and date<='31DEC2001'd));
    ret_ym=year(date)*100+month(date);
    mcap=.;
    if not missing(prc) and not missing(shrout) and shrout>0 then
        mcap=abs(prc)*shrout;
    if mcap<=0 then mcap=.;
run;

data mcap_obs;
    set msf_all(keep=permno date mcap);
    if date<='31DEC2000'd and not missing(mcap);
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
    from name_match_raw
    group by permno, date;
    select count(*) as multi_name_permno_months
    from name_match_n where n_names ne 1;

    create table size_obs as
    select r.permno, r.date, r.calyr, r.mcap, r.shrcd, r.exchcd
    from name_match_raw as r inner join name_match_n as n
      on r.permno=n.permno and r.date=n.date
    where n.n_names=1 and r.exchcd in (1,2,3) and not missing(r.shrcd)
          and floor(r.shrcd/10) ne 3;
quit;

/* CRSP annual stock-file deciles use prior-year-end capitalization.  For a
   security with no eligible prior-December capitalization, use its first
   eligible capitalization in the return year as the provider guide permits. */
proc sort data=size_obs out=size_obs_sort;
    by permno calyr date;
run;

data size_december;
    set size_obs_sort;
    if month(date)=12 and calyr>=1980 and calyr<=1999;
    return_year=calyr+1;
    cap_source=1;
    keep permno return_year date mcap cap_source;
run;

data size_firstyear;
    set size_obs_sort;
    by permno calyr;
    if first.calyr and calyr>=1981 and calyr<=2000;
    return_year=calyr;
    cap_source=2;
    keep permno return_year date mcap cap_source;
run;

proc sql;
    create table size_rank_base0 as
    select d.permno, d.return_year, d.date, d.mcap, d.cap_source
    from size_december as d
    union all
    select f.permno, f.return_year, f.date, f.mcap, f.cap_source
    from size_firstyear as f left join size_december as d
      on f.permno=d.permno and f.return_year=d.return_year
    where missing(d.permno);

    create table size_rank_dups as
    select permno, return_year, count(*) as n
    from size_rank_base0
    group by permno, return_year
    having calculated n>1;
    select count(*) as duplicate_size_ranks
    from size_rank_dups;
    create table size_rank_base as
    select b.*
    from size_rank_base0 as b left join size_rank_dups as d
      on b.permno=d.permno and b.return_year=d.return_year
    where missing(d.n);
quit;

proc sort data=size_rank_base;
    by return_year;
run;

proc rank data=size_rank_base out=size_rank groups=10;
    by return_year;
    var mcap;
    ranks decile_group;
run;

data size_rank;
    set size_rank;
    decile=decile_group+1;
    label decile='CRSP annual size decile (1 smallest, 10 largest)';
run;

proc sql;
    select return_year, decile, count(*) as securities
    from size_rank
    group by return_year, decile;
quit;

/* Assign each linked firm-year to the benchmark decile active for the first
   holding month.  Use the date-valid formation link where unique; when there
   is no formation-date link, fall back to the date-valid fiscal-year link. */
proc sql;
    create table event_base0 as
    select a.*, f.permno as permno_fye, f.permco as permco_fye
    from acct_panel as a inner join link_fye as f
      on a.gvkey=f.gvkey and a.datadate=f.datadate
    where a.acct_complete=1;

    create table event_base as
    select e.*, l.permno as permno_form,
           coalesce(n.n_permno,0) as form_link_count,
           f.date as rank_cap_date, f.cap_source,
           case when f.cap_source=1 then 1
                when f.cap_source=2 and
                     (f.date<e.start_month or
                      (year(f.date)=year(e.start_month) and
                       month(f.date)=month(e.start_month))) then 1
                else 0 end as cap_date_usable,
           case when f.cap_source=1 then 'prior-dec'
                when f.cap_source=2 and f.date<e.start_month then 'before-start'
                when f.cap_source=2 and year(f.date)=year(e.start_month) and
                     month(f.date)=month(e.start_month) then 'same-month'
                when f.cap_source=2 then 'after-start'
                else 'no-rank' end as cap_date_class length=16,
           case when f.cap_source=1 or
                     (f.cap_source=2 and
                      (f.date<e.start_month or
                       (year(f.date)=year(e.start_month) and
                        month(f.date)=month(e.start_month))))
                then f.decile else . end as decile,
           case when coalesce(n.n_permno,0)>1 or
                          (coalesce(n.n_permno,0)=1 and n.n_permco ne 1)
                then .
                when coalesce(n.n_permno,0)=1 then l.permno
                else e.permno_fye end as rank_permno,
           case when coalesce(n.n_permno,0)>1 or
                          (coalesce(n.n_permno,0)=1 and n.n_permco ne 1)
                then 3
                when coalesce(n.n_permno,0)=1 then 1
                else 2 end as rank_source
    from event_base0 as e
    left join link_form_n as n
      on e.gvkey=n.gvkey and e.form_date=n.form_date
    left join link_form as l
      on e.gvkey=l.gvkey and e.form_date=l.form_date
    left join size_rank as f
      on f.permno=case when coalesce(n.n_permno,0)=1 and n.n_permco=1
                       then l.permno
                       when coalesce(n.n_permno,0)=0 then e.permno_fye
                       else . end
     and f.return_year=e.return_year;

    create table linked_permnos as
    select distinct permno_fye as permno from event_base0;
    select count(*) as unique_fye_rows
    from event_base0;
    select count(*) as rows_using_prior_december_link
    from event_base where rank_source=1;
    select count(*) as rows_using_fye_link_fallback
    from event_base where rank_source=2;
    select count(*) as rows_ranked_on_prior_dec_cap
    from event_base where cap_source=1;
    select count(*) as rows_ranked_on_first_year_cap
    from event_base where cap_source=2;
    select count(*) as form_ambig_rows
    from event_base where rank_source=3;
    select count(*) as rows_without_size_decile
    from event_base where missing(decile);
    select cap_date_class, count(*) as event_rows,
           sum(cap_date_usable=1) as cap_date_usable_rows,
           sum(cap_date_usable=0) as cap_date_unavailable_rows
    from event_base
    group by cap_date_class;
quit;

/* The CRSP index product has dividend-inclusive annual decile returns. */
data msix_wide;
    set crspidx.msix(keep=caldt decret1-decret10
                     where=(caldt>='01JAN1981'd and caldt<='31DEC2001'd));
    ret_ym=year(caldt)*100+month(caldt);
run;

data msix_long;
    set msix_wide;
    array d[10] decret1-decret10;
    do decile=1 to 10;
        ret_bench=d[decile];
        if missing(ret_bench) or ret_bench < -1 then ret_bench=.;
        bench_valid=not missing(ret_bench);
        bench_zero=(bench_valid and ret_bench=-1);
        if bench_valid and ret_bench>-1 then bench_log=log(1+ret_bench);
        else bench_log=.;
        output;
    end;
    keep ret_ym decile ret_bench bench_valid bench_zero bench_log;
run;

proc sql;
    create table msix_dups as
    select ret_ym, decile, count(*) as n
    from msix_long
    group by ret_ym, decile
    having calculated n>1;
    select count(*) as duplicate_msix_month_deciles from msix_dups;
    create table msix_unique as
    select m.*
    from msix_long as m left join msix_dups as d
      on m.ret_ym=d.ret_ym and m.decile=d.decile
    where missing(d.n);
quit;

/* Add CRSP delisting returns to ordinary monthly holding-period returns. */
data delist_raw;
    set crspstk.msedelist(keep=permno dlstdt dlret
                          where=(dlstdt>='01JAN1981'd and dlstdt<='31DEC2001'd));
    ret_ym=year(dlstdt)*100+month(dlstdt);
    if not missing(dlret) and dlret < -1 then dlret=.;
    keep permno dlstdt ret_ym dlret;
run;

proc sql;
    create table delist_n as
    select permno, ret_ym, count(*) as n_delist_rows
    from delist_raw
    group by permno, ret_ym;
    select count(*) as duplicate_permno_delist_months
    from delist_n where n_delist_rows ne 1;
    create table delist_unique as
    select d.permno, d.ret_ym, d.dlret
    from delist_raw as d inner join delist_n as n
      on d.permno=n.permno and d.ret_ym=n.ret_ym
    where n.n_delist_rows=1;
    create table delist_term_n as
    select permno, count(*) as n_delist_months
    from delist_n
    group by permno;
    create table delist_term as
    select d.permno, d.ret_ym as terminal_delist_ym, d.dlret
    from delist_unique as d inner join delist_term_n as n
      on d.permno=n.permno
    inner join delist_n as dn
      on d.permno=dn.permno and d.ret_ym=dn.ret_ym
    where n.n_delist_months=1 and dn.n_delist_rows=1;

    create table msf_permno_month as
    select distinct m.permno, m.ret_ym
    from msf_all as m inner join linked_permnos as p
      on m.permno=p.permno
    where m.date>='01JAN1981'd and m.date<='31DEC2001'd;
    create table linked_delist_only as
    select n.permno, n.ret_ym, d.dlret, n.n_delist_rows
    from delist_n as n inner join linked_permnos as p
      on n.permno=p.permno
    left join msf_permno_month as m
      on n.permno=m.permno and n.ret_ym=m.ret_ym
    left join delist_unique as d
      on n.permno=d.permno and n.ret_ym=d.ret_ym
    where missing(m.permno) and n.ret_ym>=198101 and n.ret_ym<=200112;
    select count(*) as delist_no_msf,
           coalesce(sum(n_delist_rows ne 1),0) as ambiguous_delisting_only_months,
           coalesce(sum(n_delist_rows=1 and not missing(dlret)),0) as delist_only_with_dlret,
           coalesce(sum(n_delist_rows=1 and missing(dlret)),0) as delist_only_missing_dlret
    from linked_delist_only;

    create table target_month_raw as
    select m.permno, m.ret_ym, m.ret as ret_raw,
           d.dlret, coalesce(n.n_delist_rows,0) as n_delist_rows
    from msf_all as m inner join linked_permnos as p
      on m.permno=p.permno
    left join delist_unique as d
      on m.permno=d.permno and m.ret_ym=d.ret_ym
    left join delist_n as n
      on m.permno=n.permno and m.ret_ym=n.ret_ym
    where m.date>='01JAN1981'd and m.date<='31DEC2001'd
    union all
    select d.permno, d.ret_ym, . as ret_raw, d.dlret, d.n_delist_rows
    from linked_delist_only as d
    where d.n_delist_rows=1;
quit;

/* Sorted merge requires unique keys; report and exclude any duplicate month. */
proc sql;
    create table target_month_dups as
    select permno, ret_ym, count(*) as n
    from target_month_raw
    group by permno, ret_ym
    having calculated n>1;
    select count(*) as duplicate_permno_monthly_returns from target_month_dups;
    create table target_month_unique as
    select t.*
    from target_month_raw as t left join target_month_dups as d
      on t.permno=d.permno and t.ret_ym=d.ret_ym
    where missing(d.n);
quit;

/* Complete each 12-month holding window; do not fill missing pre-delisting
   returns or a missing delisting return. */
data event_months;
    set event_base;
    do step=0 to 11;
        month_begin=intnx('month',start_month,step,'b');
        ret_ym=year(month_begin)*100+month(month_begin);
        output;
    end;
    format month_begin date9.;
    keep gvkey fyear datadate permno_fye permco_fye permno_form rank_permno
         rank_source return_year form_year form_date start_month decile step ret_ym
         earn_t earn_lead bklg curcd;
run;

proc sql;
    create table window_returns0 as
    select w.*, t.ret_raw, t.dlret, t.n_delist_rows,
           d.terminal_delist_ym, d.dlret as terminal_dlret,
           b.ret_bench, b.bench_valid, b.bench_zero, b.bench_log
    from event_months as w
    left join target_month_unique as t
      on w.permno_fye=t.permno and w.ret_ym=t.ret_ym
    left join delist_term as d
      on w.permno_fye=d.permno
    left join msix_unique as b
      on w.ret_ym=b.ret_ym and w.decile=b.decile;
quit;

/* Return the monthly CRSP security series, include delisting proceeds, and
   hold valid delisting proceeds as zero-return cash for remaining months. */
data window_returns;
    set window_returns0;
    ret_total=.;
    entry_ym=year(start_month)*100+month(start_month);
    if not missing(terminal_delist_ym) and terminal_delist_ym<entry_ym then ret_total=.;
    else if n_delist_rows>1 then ret_total=.;
    else if n_delist_rows=1 then do;
        if not missing(dlret) and dlret>=-1 then do;
            if not missing(ret_raw) and ret_raw>=-1 then
                ret_total=(1+ret_raw)*(1+dlret)-1;
            else ret_total=dlret;
        end;
    end;
    else if ret_ym=terminal_delist_ym then do;
        if not missing(terminal_dlret) and terminal_dlret>=-1 then do;
            if not missing(ret_raw) and ret_raw>=-1 then
                ret_total=(1+ret_raw)*(1+terminal_dlret)-1;
            else ret_total=terminal_dlret;
        end;
    end;
    else if not missing(ret_raw) and ret_raw>=-1 then ret_total=ret_raw;
    else if not missing(terminal_delist_ym) and
            terminal_delist_ym<ret_ym and not missing(terminal_dlret) and
            terminal_dlret>=-1
        then ret_total=0;
    stock_valid=not missing(ret_total) and ret_total>=-1;
    stock_zero=(stock_valid and ret_total=-1);
    if stock_valid and ret_total>-1 then stock_log=log(1+ret_total);
    else stock_log=.;
run;

proc sql;
    create table stock_window_stats as
    select gvkey, fyear, count(*) as stock_window_months,
           sum(stock_valid) as stock_valid_months,
           sum(stock_zero) as stock_zero_months,
           sum(stock_log) as stock_logsum
    from window_returns
    group by gvkey, fyear;
    create table bench_window_stats as
    select gvkey, fyear, count(*) as bench_window_months,
           sum(bench_valid) as bench_valid_months,
           sum(bench_zero) as bench_zero_months,
           sum(bench_log) as bench_logsum
    from window_returns
    group by gvkey, fyear;
    create table return_stats as
    select s.gvkey, s.fyear, s.stock_window_months,
           s.stock_valid_months, s.stock_zero_months, s.stock_logsum,
           b.bench_window_months, b.bench_valid_months,
           b.bench_zero_months, b.bench_logsum
    from stock_window_stats as s inner join bench_window_stats as b
      on s.gvkey=b.gvkey and s.fyear=b.fyear;
quit;

proc sort data=event_base out=event_base_sort;
    by gvkey fyear;
run;
proc sort data=return_stats out=return_stats_sort;
    by gvkey fyear;
run;

data event_return;
    merge event_base_sort(in=a) return_stats_sort;
    by gvkey fyear;
    if a;
    stock_bhr=.; size_bhr=.; sar=.;
    if stock_window_months=12 and stock_valid_months=12 then do;
        if stock_zero_months>0 then stock_bhr=-1;
        else stock_bhr=exp(stock_logsum)-1;
    end;
    if bench_window_months=12 and bench_valid_months=12 then do;
        if bench_zero_months>0 then size_bhr=-1;
        else size_bhr=exp(bench_logsum)-1;
    end;
    if not missing(stock_bhr) and not missing(size_bhr) then sar=stock_bhr-size_bhr;
    return_complete=not missing(sar);
run;

proc sql;
    select count(*) as linked_complete_rows,
           sum(missing(decile)) as missing_size_decile,
           sum(stock_valid_months ne 12) as target_windows_missing_months,
           sum(bench_valid_months ne 12) as benchmark_windows_missing_months,
           sum(return_complete=1) as full_return_rows
    from event_return;
    select fyear, count(*) as linked_account_rows,
           sum(not missing(decile)) as size_decile_assigned,
           sum(return_complete=1) as full_return_rows
    from event_return
    group by fyear;
quit;

/* The source trims the extreme lower and upper 1% of the backlog distribution.
   Use pooled cutoffs on the scaled annual BKLG input among complete Table 2 rows. */
data fitpool;
    set event_return;
    if acct_complete=1 and return_complete=1 and not missing(earn_t) and
       not missing(earn_lead) and not missing(bklg) and not missing(sar);
run;

proc univariate data=fitpool noprint;
    var bklg;
    output out=tail_cut pctlpts=1 99 pctlpre=bklg_;
run;

data fitpool_trim;
    if _n_=1 then set tail_cut;
    set fitpool;
    tail_out=(bklg<bklg_1 or bklg>bklg_99);
run;

proc sql;
    select count(*) as complete_pretrim_rows,
           sum(tail_out=1) as lower_upper_tail_rows_removed,
           sum(tail_out=0) as posttrim_rows,
           min(bklg_1) as pooled_bklg_p1,
           min(bklg_99) as pooled_bklg_p99
    from fitpool_trim;
quit;

/* One common Table 2 data file, retaining only complete system observations. */
data rep.order_backlog_firm_years;
    set fitpool_trim;
    if tail_out=0;
    label earn_t='EARN_t'
          earn_lead='EARN_t+1'
          bklg='BKLG_t (OB / average total assets)'
          sar='SAR_t+1'
          decile='CRSP annual size decile (1 smallest, 10 largest)';
    keep gvkey fyear datadate permno_fye permco_fye form_date return_year
         rank_source decile cap_source rank_cap_date cap_date_usable
         cap_date_class curcd basis_current basis_lead
         earn_t earn_lead bklg sar
         stock_bhr size_bhr fx_prev_at_type fx_prev_usd_type fx_t_at_type
         fx_t_usd_type fx_next_at_type fx_next_usd_type;
run;

proc sql;
    create table final_dups as
    select gvkey, fyear, count(*) as n
    from rep.order_backlog_firm_years
    group by gvkey, fyear
    having calculated n>1;
    select count(*) as duplicate_final_firm_years
    from final_dups;
    select count(*) as final_table2_sample_n,
           count(distinct gvkey) as unique_firms
    from rep.order_backlog_firm_years;
    select fyear, count(*) as table2_sample_n
    from rep.order_backlog_firm_years
    group by fyear;
quit;

proc means data=rep.order_backlog_firm_years n mean std median p25 p75 min max;
    var earn_t earn_lead bklg sar;
run;
