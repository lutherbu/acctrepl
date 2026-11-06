options errorabend msglevel=i;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname compsec "/storage/sas/base/comp/d_na/security" access=readonly;
libname compg "/storage/sas/base/comp/d_global/currency" access=readonly;
libname crsp "/storage/sas/base/crsp/a_stock" access=readonly;
libname ccm "/storage/sas/base/crsp/a_ccm" access=readonly;
libname out "data/basu_mtb";

%let mindate='01jan1967'd;
%let maxdate='31dec2003'd;

data funda_src;
  set comp.funda(keep=gvkey datadate fyear pdate indfmt consol popsrc datafmt
                     curcd ib ceq hiid iid);
  where fyear between 1967 and 2002
    and indfmt='INDL' and consol='C' and popsrc='D' and datafmt='STD';
  if missing(gvkey) or missing(datadate) or missing(fyear) then delete;
  me_date=intnx('month',datadate,0,'end');
  if me_date>datadate then me_date=intnx('month',datadate,-1,'end');
  format datadate me_date date9.;
run;

proc sql;
  create table funda_dups as
  select gvkey,fyear,count(*) as n_rows
  from funda_src group by gvkey,fyear having calculated n_rows>1;
  select count(*) as duplicate_firm_year_keys,
         coalesce(sum(n_rows-1),0) as excess_rows,
         coalesce(max(n_rows),0) as max_rows
  from funda_dups;
  select min(fyear) as min_fyear,max(fyear) as max_fyear,
         min(datadate) format=date9. as min_datadate,
         max(datadate) format=date9. as max_datadate,
         count(*) as standard_annual_rows
  from funda_src;
quit;

proc sort data=funda_src;
  by gvkey fyear pdate datadate;
run;

data funda;
  set funda_src;
  by gvkey fyear;
  if last.fyear;
run;

data fxm_src;
  set compg.g_exrt_mth(keep=fromcurm tocurm datadate exrat12m);
  where datadate between &mindate and &maxdate and fromcurm='GBP';
  fxdate=datadate;
  format fxdate date9.;
run;

proc sql;
  create table fxm_key as
  select fxdate,tocurm,count(*) as n_fx,max(exrat12m) as rate12m
  from fxm_src group by fxdate,tocurm;
  select count(*) as gbp_month_currency_keys,
         sum(n_fx>1) as duplicate_gbp_month_keys,
         sum(n_fx=1 and rate12m>0) as positive_gbp_month_keys,
         sum(tocurm='USD' and n_fx=1 and rate12m>0) as positive_gbp_usd_months
  from fxm_key;
quit;

data fxm;
  set fxm_key;
  if n_fx=1 and rate12m>0;
run;

data fxd_src;
  set compg.g_exrt_dly(keep=fromcurd tocurd datadate exratd exrattpd);
  where datadate between &mindate and &maxdate and fromcurd='GBP';
  fxdate=datadate;
  format fxdate date9.;
run;

proc sql;
  create table fxd_key as
  select fxdate,tocurd,count(*) as n_fx,max(exratd) as rate_dly,
         max(exrattpd) as rate_type
  from fxd_src group by fxdate,tocurd;
  select count(*) as gbp_day_currency_keys,
         sum(n_fx>1) as duplicate_gbp_day_keys,
         sum(n_fx=1 and rate_dly>0) as positive_gbp_day_keys,
         sum(tocurd='USD' and n_fx=1 and rate_dly>0) as positive_gbp_usd_days
  from fxd_key;
quit;

data fxd;
  set fxd_key;
  if n_fx=1 and rate_dly>0;
run;

proc sql;
  create table funda_fx as
  select f.*,
         case when f.curcd='USD' then 1
              when f.curcd='GBP' then 1 else fm.rate12m end as flow_rep_rate,
         case when f.curcd='USD' then 1 else fu.rate12m end as flow_usd_rate,
         case when f.curcd='USD' then 1
              when f.curcd='GBP' then 1 else fd.rate_dly end as point_rep_rate,
         case when f.curcd='USD' then 1 else fdu.rate_dly end as point_usd_rate,
         fd.rate_type as point_rep_type,
         fdu.rate_type as point_usd_type,
         case when f.curcd='USD' then f.ib
              when f.curcd='GBP' and fu.rate12m>0 then f.ib*fu.rate12m
              when fm.rate12m>0 and fu.rate12m>0 then f.ib/fm.rate12m*fu.rate12m
              else . end as ib_usd,
         case when f.curcd='USD' then f.ceq
              when f.curcd='GBP' and fdu.rate_dly>0 then f.ceq*fdu.rate_dly
              when fd.rate_dly>0 and fdu.rate_dly>0 then f.ceq/fd.rate_dly*fdu.rate_dly
              else . end as ceq_usd,
         case when not missing(f.hiid)
                and upcase(substrn(strip(f.hiid),lengthn(strip(f.hiid)),1))='X'
              then 1 else 0 end as hiid_dummy
  from funda as f
  left join fxm as fm on f.curcd=fm.tocurm and f.me_date=fm.fxdate
  left join fxm as fu on fu.tocurm='USD' and f.me_date=fu.fxdate
  left join fxd as fd on f.curcd=fd.tocurd and f.datadate=fd.fxdate
  left join fxd as fdu on fdu.tocurd='USD' and f.datadate=fdu.fxdate;
  select count(*) as selected_annual_rows,
         sum(curcd='USD') as usd_rows,
         sum(not missing(curcd) and curcd='GBP') as gbp_rows,
         sum(not missing(curcd) and curcd not in ('USD','GBP')) as other_currency_rows,
         sum(not missing(ib) and missing(ib_usd)) as ib_without_valid_usd_conversion,
         sum(not missing(ceq) and missing(ceq_usd)) as ceq_without_valid_usd_conversion,
         sum(not missing(ceq_usd) and not missing(point_rep_type)) as point_rep_with_type,
         sum(not missing(ceq_usd) and not missing(point_usd_type)) as point_usd_with_type
  from funda_fx;
  select curcd,count(*) as annual_records,
         sum(not missing(ib_usd)) as annual_ib_in_usd,
         sum(not missing(ceq_usd)) as annual_ceq_in_usd
  from funda_fx group by curcd order by curcd;
quit;

proc freq data=funda_fx;
  tables curcd*point_rep_type curcd*point_usd_type / missing;
run;

data secmth_src;
  set compsec.sec_mth(keep=gvkey iid datadate primiss);
  where datadate between &mindate and &maxdate;
  if not missing(gvkey) and not missing(iid);
run;

proc sql;
  create table hiid_dated as
  select f.gvkey,f.fyear,f.datadate,f.hiid,
         count(s.iid) as own_issue_rows,
         sum(s.primiss='P') as own_issue_primary_rows,
         sum(s.primiss='C') as own_issue_co_primary_rows
  from funda_fx as f
  left join secmth_src as s
    on f.hiid_dummy=0 and f.gvkey=s.gvkey and strip(f.hiid)=strip(s.iid)
       and f.me_date=s.datadate
  group by f.gvkey,f.fyear,f.datadate,f.hiid;
  select sum(not missing(hiid)) as known_hiid_rows,
         sum(not missing(hiid) and own_issue_rows>0) as dated_hiid_matches,
         sum(not missing(hiid) and own_issue_rows=0) as dated_hiid_absence,
         sum(own_issue_primary_rows>0) as own_issue_primary_marker_rows,
         sum(own_issue_co_primary_rows>0) as own_issue_co_primary_marker_rows
  from hiid_dated;
quit;

data ccm_all;
  set ccm.ccmxpf_linktable(keep=gvkey linkprim liid linktype lpermno lpermco
                                   linkdt linkenddt);
  where linkdt<=&maxdate
    and (linkenddt=.E or missing(linkenddt) or linkenddt>=&mindate);
run;

data ccm_src;
  set ccm_all;
  where upcase(linktype) in ('LC','LU');
run;

proc sql;
  select count(*) as candidate_ccm_links,
         sum(linkenddt=.E) as open_e_linkends,
         sum(missing(linkdt)) as missing_or_special_linkstarts,
         sum(linkprim='P') as primary_links,
         sum(linkprim='C') as co_primary_links,
         sum(linkprim='J') as joiner_links
  from ccm_src;
  select count(*) as active_ccm_history_rows,
         sum(upcase(substrn(strip(liid),lengthn(strip(liid)),1))='X') as x_dummy_rows,
         sum(upcase(linktype)='NR'
             and upcase(substrn(strip(liid),lengthn(strip(liid)),1))='X'
             and lpermno=0) as nr_x_dummy_without_permno
  from ccm_all;
quit;

proc sql;
  create table hiid_link_audit as
  select f.gvkey,f.fyear,f.hiid,f.hiid_dummy,
         h.own_issue_rows,h.own_issue_primary_rows,h.own_issue_co_primary_rows,
         count(distinct case when upcase(l.linktype) in ('LC','LU')
                                   and l.linkprim in ('P','C') and l.lpermno>0
                              then l.lpermno else . end) as n_pc_permnos,
         count(distinct case when upcase(l.linktype) in ('LC','LU')
                                   and l.lpermno>0 and f.hiid_dummy=0
                                   and not missing(f.hiid) and strip(f.hiid)=strip(l.liid)
                              then l.lpermno else . end) as n_exact_permnos,
         count(distinct case when upcase(l.linktype) in ('LC','LU')
                                   and l.linkprim in ('P','C') and l.lpermno>0
                                   and upcase(substrn(strip(l.liid),lengthn(strip(l.liid)),1))='X'
                              then l.lpermno else . end) as n_dummy_permnos,
         count(distinct case when upcase(l.linktype) in ('LC','LU')
                                   and l.linkprim in ('P','C') and l.lpermno>0
                                   and f.hiid_dummy=0 and not missing(f.hiid)
                                   and upcase(substrn(strip(l.liid),lengthn(strip(l.liid)),1)) ne 'X'
                                   and strip(f.hiid) ne strip(l.liid)
                              then l.lpermno else . end) as n_other_actual_pc
  from funda_fx as f
  left join hiid_dated as h on f.gvkey=h.gvkey and f.fyear=h.fyear
  left join ccm_all as l
    on f.gvkey=l.gvkey and l.linkdt<=f.datadate
       and (l.linkenddt=.E or missing(l.linkenddt) or l.linkenddt>=f.datadate)
  group by f.gvkey,f.fyear,f.hiid,f.hiid_dummy,h.own_issue_rows,
           h.own_issue_primary_rows,h.own_issue_co_primary_rows;
quit;

data hiid_link_audit;
  set hiid_link_audit;
  length link_class $28;
  if not missing(hiid) and hiid_dummy=0 and n_exact_permnos>0 then link_class='exact actual HIID';
  else if missing(hiid) or hiid_dummy=1 then do;
    if n_pc_permnos=1 then link_class='unique P/C fallback';
    else if n_dummy_permnos>0 then link_class='documented dummy history';
    else if n_pc_permnos=0 then link_class='no P/C candidate';
    else link_class='ambiguous P/C candidates';
  end;
  else if n_other_actual_pc>0
       and (own_issue_primary_rows>0 or own_issue_co_primary_rows>0)
    then link_class='observed identifier conflict';
  else if n_dummy_permnos>0 then link_class='dummy CCM history';
  else if n_pc_permnos=0 then link_class='no dated P/C candidate';
  else link_class='no exact HIID issue evidence';
run;

proc freq data=hiid_link_audit;
  tables link_class / missing;
run;

proc sql;
  select fyear,link_class,count(*) as firm_years
  from hiid_link_audit where fyear between 1972 and 1999
  group by fyear,link_class order by fyear,link_class;
quit;

proc sql;
  create table return_link_candidates as
  select distinct f.gvkey,f.fyear,l.lpermno,l.linkprim,
         case when f.hiid_dummy=0 and not missing(f.hiid)
                         and strip(f.hiid)=strip(l.liid)
              then 'H' when (missing(f.hiid) or f.hiid_dummy=1)
                          and l.linkprim in ('P','C')
              then 'P' when f.hiid_dummy=0 and not missing(f.hiid)
                          and l.linkprim in ('P','C')
                          and upcase(substrn(strip(l.liid),lengthn(strip(l.liid)),1))='X'
                          and h.n_exact_permnos=0 and h.own_issue_rows=0
                          and h.n_pc_permnos=1 and h.n_dummy_permnos=1
                          and h.n_other_actual_pc=0
              then 'D' else ' ' end as link_basis length=1
  from funda_fx as f inner join ccm_src as l
    on f.gvkey=l.gvkey and l.linkdt<=f.datadate
       and (l.linkenddt=.E or missing(l.linkenddt) or l.linkenddt>=f.datadate)
  left join hiid_link_audit as h on f.gvkey=h.gvkey and f.fyear=h.fyear
  where l.lpermno>0
    and ((f.hiid_dummy=0 and not missing(f.hiid) and strip(f.hiid)=strip(l.liid))
         or ((missing(f.hiid) or f.hiid_dummy=1) and l.linkprim in ('P','C'))
         or (f.hiid_dummy=0 and not missing(f.hiid) and l.linkprim in ('P','C')
             and upcase(substrn(strip(l.liid),lengthn(strip(l.liid)),1))='X'
             and h.n_exact_permnos=0 and h.own_issue_rows=0
             and h.n_pc_permnos=1 and h.n_dummy_permnos=1
             and h.n_other_actual_pc=0));
  create table return_link_counts as
  select gvkey,fyear,count(distinct lpermno) as n_permno,
         max(link_basis='H') as exact_hiid_link,
         max(link_basis='P') as absent_hiid_pc_fallback,
         max(link_basis='D') as documented_dummy_fallback
  from return_link_candidates group by gvkey,fyear;
  create table return_link as
  select f.gvkey,f.fyear,
         case when c.n_permno=1 then max(l.lpermno) else . end as ret_permno,
         coalesce(c.n_permno,0) as n_ret_permno,
         coalesce(c.exact_hiid_link,0) as exact_hiid_link,
         coalesce(c.absent_hiid_pc_fallback,0) as absent_hiid_pc_fallback,
         coalesce(c.documented_dummy_fallback,0) as documented_dummy_fallback
  from funda_fx as f
  left join return_link_counts as c on f.gvkey=c.gvkey and f.fyear=c.fyear
  left join return_link_candidates as l on f.gvkey=l.gvkey and f.fyear=l.fyear
  group by f.gvkey,f.fyear,c.n_permno,c.exact_hiid_link,
           c.absent_hiid_pc_fallback,c.documented_dummy_fallback;
  select sum(not missing(f.hiid) and f.hiid_dummy=0) as actual_hiid_years,
         sum(not missing(f.hiid) and f.hiid_dummy=0
             and coalesce(c.exact_hiid_link,0)=1) as actual_hiid_exact_links,
         sum(not missing(f.hiid) and f.hiid_dummy=0
             and coalesce(c.documented_dummy_fallback,0)=1) as actual_hiid_dummy_fallback,
         sum(not missing(f.hiid) and f.hiid_dummy=0
             and coalesce(c.exact_hiid_link,0)=0
             and coalesce(c.documented_dummy_fallback,0)=0) as actual_hiid_unmatched,
         sum(f.hiid_dummy=1) as dummy_hiid_years,
         sum((missing(f.hiid) or f.hiid_dummy=1)
             and coalesce(c.absent_hiid_pc_fallback,0)=1) as absent_hiid_unique_pc,
         sum(coalesce(c.n_permno,0)>1) as ambiguous_return_links
  from funda_fx as f left join return_link_counts as c
    on f.gvkey=c.gvkey and f.fyear=c.fyear;
quit;

data ccm_me_link;
  set ccm_src;
  where linkprim in ('P','C') and lpermco>0;
  keep gvkey linkprim lpermco linkdt linkenddt;
run;

data msf_src;
  set crsp.msf(keep=permno permco date prc shrout ret);
  where date between &mindate and &maxdate;
  mdate=intnx('month',date,0,'end');
  me_mm=abs(prc)*shrout/1000;
  format mdate date9.;
run;

data msenames_src;
  set crsp.msenames(keep=permno permco namedt nameendt shrcd);
  if namedt<=&maxdate and (nameendt=.E or missing(nameendt) or nameendt>=&mindate);
run;

proc sql;
  create table msf_name_counts as
  select m.permno,m.date,count(*) as n_name_rows
  from msf_src as m inner join msenames_src as n
    on m.permno=n.permno and n.namedt<=m.date
       and (n.nameendt=.E or missing(n.nameendt) or n.nameendt>=m.date)
  where n.shrcd in (10,11)
  group by m.permno,m.date;
  create table msf_common_raw as
  select m.permno,m.date as source_date,m.mdate as date format=date9.,
         n.permco,m.ret,m.me_mm,
         case when missing(m.me_mm) or m.me_mm<=0 then 1 else 0 end as missing_me
  from msf_src as m inner join msf_name_counts as c
    on m.permno=c.permno and m.date=c.date and c.n_name_rows=1
  inner join msenames_src as n
    on m.permno=n.permno and n.namedt<=m.date
       and (n.nameendt=.E or missing(n.nameendt) or n.nameendt>=m.date)
       and n.shrcd in (10,11);
  create table msf_common_keycounts as
  select permno,date,count(*) as n_rows
  from msf_common_raw group by permno,date;
  select count(*) as common_security_month_rows,
         sum(missing_me) as common_sec_months_no_me,
         sum(source_date ne date) as last_trade_dates_normalized
  from msf_common_raw;
  select sum(n_rows>1) as duplicate_permno_month_keys,
         coalesce(sum(case when n_rows>1 then n_rows-1 else 0 end),0) as excess_permno_month_rows
  from msf_common_keycounts;
  create table msf_common as
  select a.permno,a.source_date,a.date,a.permco,a.ret,a.me_mm,a.missing_me
  from msf_common_raw as a inner join msf_common_keycounts as k
    on a.permno=k.permno and a.date=k.date and k.n_rows=1;
quit;

proc sql;
  create table me_by_permco as
  select permco,date,sum(me_mm) as me_usd_m,
         count(distinct permno) as n_common_issues,
         sum(missing_me) as n_missing_issue_me
  from msf_common
  where not missing(permco)
  group by permco,date;
  create table cap_links as
  select distinct f.gvkey,f.fyear,f.datadate,f.me_date,l.lpermco as permco
  from funda_fx as f inner join ccm_me_link as l
    on f.gvkey=l.gvkey and l.linkdt<=f.datadate
       and (l.linkenddt=.E or missing(l.linkenddt) or l.linkenddt>=f.datadate)
  where not missing(l.lpermco);
  create table mve_rows as
  select a.gvkey,a.fyear,a.datadate,a.me_date,a.permco,
         b.me_usd_m,b.n_missing_issue_me
  from cap_links as a left join me_by_permco as b
    on a.permco=b.permco and a.me_date=b.date;
  create table mve_pre as
  select gvkey,fyear,datadate,me_date,count(distinct permco) as n_permco,
         sum(me_usd_m) as mve_sum,
         sum(case when missing(me_usd_m) or n_missing_issue_me>0 then 1 else 0 end) as n_incomplete_permco
  from mve_rows group by gvkey,fyear,datadate,me_date;
quit;

data mve;
  set mve_pre;
  if n_permco>0 and n_incomplete_permco=0 and mve_sum>0 then mve=mve_sum;
  else mve=.;
  keep gvkey fyear mve n_permco;
run;

data delist_src;
  set crsp.msedelist(keep=permno dlstdt dlstcd dlret);
  where dlstdt between &mindate and &maxdate;
  dmonth=intnx('month',dlstdt,0,'end');
  format dmonth date9.;
run;

proc sql;
  create table delist_by_month as
  select permno,dmonth,count(*) as n_delist_rows,min(dlstdt) as dlstdt,
         max(dlret) as dlret,max(dlstcd) as dlstcd
  from delist_src group by permno,dmonth;
  select sum(n_delist_rows>1) as duplicate_delist_security_months,
         count(*) as delist_security_months
  from delist_by_month;
quit;

data delist_unique;
  set delist_by_month;
  if n_delist_rows=1;
run;

proc sql;
  create table delist_name_counts as
  select d.permno,d.dmonth,count(*) as n_name_rows
  from delist_unique as d inner join msenames_src as n
    on d.permno=n.permno and n.namedt<=d.dlstdt
       and (n.nameendt=.E or missing(n.nameendt) or n.nameendt>=d.dlstdt)
  where n.shrcd in (10,11)
  group by d.permno,d.dmonth;
  create table delist_common as
  select d.permno,d.dmonth,d.dlret
  from delist_unique as d inner join delist_name_counts as c
    on d.permno=c.permno and d.dmonth=c.dmonth and c.n_name_rows=1;
  create table ret_month_raw as
  select coalesce(m.permno,d.permno) as permno,
         coalesce(m.date,d.dmonth) as date format=date9.,
         m.ret,d.dlret
  from msf_common as m full join delist_common as d
    on m.permno=d.permno and m.date=d.dmonth;
  create table ret_month_keycounts as
  select permno,date,count(*) as n_rows
  from ret_month_raw group by permno,date;
  select sum(n_rows>1) as duplicate_return_permno_months,
         coalesce(sum(case when n_rows>1 then n_rows-1 else 0 end),0) as excess_return_month_rows
  from ret_month_keycounts;
  create table ret_month_unique as
  select r.*
  from ret_month_raw as r inner join ret_month_keycounts as k
    on r.permno=k.permno and r.date=k.date and k.n_rows=1;
quit;

data ret_month;
  set ret_month_unique;
  if not missing(ret) and not missing(dlret) then ret_total=(1+ret)*(1+dlret)-1;
  else if not missing(dlret) then ret_total=dlret;
  else ret_total=ret;
run;

proc sql;
  create table ret_windows0 as
  select f.gvkey,f.fyear,f.datadate,p.datadate as prev_fye,
         l.ret_permno as permno
  from funda_fx as f
  left join funda_fx as p on f.gvkey=p.gvkey and p.fyear=f.fyear-1
  left join return_link as l on f.gvkey=l.gvkey and f.fyear=l.fyear
  where f.fyear between 1968 and 2002;
quit;

data ret_windows;
  set ret_windows0;
  start_m=intnx('month',prev_fye,4,'end');
  end_m=intnx('month',datadate,3,'end');
  expected_months=intck('month',start_m,end_m)+1;
  if not missing(start_m) and not missing(end_m) and expected_months=12 then valid_window=1;
  else valid_window=0;
  format start_m end_m date9.;
run;

proc sql;
  create table ret_window_rows as
  select w.gvkey,w.fyear,w.permno,w.start_m,w.end_m,w.valid_window,
         r.date,r.ret_total
  from ret_windows as w left join ret_month as r
    on w.permno=r.permno and r.date between w.start_m and w.end_m;
quit;

proc sort data=ret_window_rows;
  by gvkey fyear date;
run;

data ret_annual;
  set ret_window_rows;
  by gvkey fyear;
  retain prod_ret n_months n_missing_ret n_month_gaps prev_month;
  if first.fyear then do;
    prod_ret=1; n_months=0; n_missing_ret=0; n_month_gaps=0; prev_month=.;
  end;
  if not missing(date) then do;
    n_months+1;
    if missing(ret_total) then n_missing_ret+1;
    else prod_ret=prod_ret*(1+ret_total);
    if n_months=1 and date ne start_m then n_month_gaps+1;
    if n_months>1 and intck('month',prev_month,date) ne 1 then n_month_gaps+1;
    prev_month=date;
  end;
  if last.fyear then do;
    ret_ann=.;
    if valid_window=1 and n_months=12 and n_missing_ret=0 and n_month_gaps=0
       and date=end_m then ret_ann=prod_ret-1;
    output;
  end;
  keep gvkey fyear ret_ann n_months n_missing_ret n_month_gaps valid_window;
run;

proc sql;
  create table annual0 as
  select f.gvkey,f.fyear,f.datadate,f.curcd,f.hiid,f.ib_usd,f.ceq_usd,
         f.flow_rep_rate as fx_flow_reporting,
         f.flow_usd_rate as fx_flow_usd,
         f.point_rep_rate as fx_stock_reporting,
         f.point_usd_rate as fx_stock_usd,
         f.point_rep_type as fx_stock_reporting_type,
         f.point_usd_type as fx_stock_usd_type,
         m.mve,m.n_permco,r.ret_ann,
         r.n_months,r.n_missing_ret,r.n_month_gaps,r.valid_window
  from funda_fx as f
  left join mve as m on f.gvkey=m.gvkey and f.fyear=m.fyear
  left join ret_annual as r on f.gvkey=r.gvkey and f.fyear=r.fyear;
  create table annual1 as
  select a.*,p.mve as mve_prev,
         case when p.mve>0 and not missing(a.ib_usd) then a.ib_usd/p.mve else . end as ep_ann,
         case when a.mve>0 and a.ceq_usd>0 then a.mve/a.ceq_usd else . end as mtb
  from annual0 as a left join annual0 as p
    on a.gvkey=p.gvkey and p.fyear=a.fyear-1;
  select fyear,count(*) as annual_rows,
         sum(not missing(ib_usd)) as with_usd_ib,
         sum(not missing(mve)) as with_company_mve,
         sum(not missing(ret_ann)) as with_complete_annual_return
  from annual1 group by fyear order by fyear;
quit;

proc sql;
  create table wide0 as
  select t.gvkey,t.fyear,t.datadate,t.mtb,t.ceq_usd,
         m5.ib_usd as ib_m5,m4.ib_usd as ib_m4,m3.ib_usd as ib_m3,
         m2.ib_usd as ib_m2,m1.ib_usd as ib_m1,t.ib_usd as ib0,
         p1.ib_usd as ib_p1,p2.ib_usd as ib_p2,p3.ib_usd as ib_p3,
         m4.ret_ann as ret_m4,m3.ret_ann as ret_m3,m2.ret_ann as ret_m2,
         m1.ret_ann as ret_m1,t.ret_ann as ret0,p1.ret_ann as ret_p1,
         p2.ret_ann as ret_p2,p3.ret_ann as ret_p3,
         m4.ep_ann as ep_m4,m3.ep_ann as ep_m3,m2.ep_ann as ep_m2,
         m1.ep_ann as ep_m1,t.ep_ann as ep0,p1.ep_ann as ep_p1,
         p2.ep_ann as ep_p2,p3.ep_ann as ep_p3,
         m5.mve as mve_m5,m4.mve as mve_m4,m3.mve as mve_m3,
         m2.mve as mve_m2,m1.mve as mve_m1,t.mve as mve0,
         p1.mve as mve_p1,p2.mve as mve_p2
  from annual1 as t
  left join annual1 as m5 on t.gvkey=m5.gvkey and m5.fyear=t.fyear-5
  left join annual1 as m4 on t.gvkey=m4.gvkey and m4.fyear=t.fyear-4
  left join annual1 as m3 on t.gvkey=m3.gvkey and m3.fyear=t.fyear-3
  left join annual1 as m2 on t.gvkey=m2.gvkey and m2.fyear=t.fyear-2
  left join annual1 as m1 on t.gvkey=m1.gvkey and m1.fyear=t.fyear-1
  left join annual1 as p1 on t.gvkey=p1.gvkey and p1.fyear=t.fyear+1
  left join annual1 as p2 on t.gvkey=p2.gvkey and p2.fyear=t.fyear+2
  left join annual1 as p3 on t.gvkey=p3.gvkey and p3.fyear=t.fyear+3
  where t.fyear between 1972 and 1999;
quit;

data wide1;
  set wide0;
  e_f1=ib_p1; e_f2=ib_p1+ib_p2; e_f3=ib_p1+ib_p2+ib_p3;
  r_f1=ret_p1; r_f2=(1+ret_p1)*(1+ret_p2)-1;
  r_f3=(1+ret_p1)*(1+ret_p2)*(1+ret_p3)-1;
  e_b0=ib0; e_b1=ib_m1+ib0; e_b2=ib_m2+ib_m1+ib0;
  e_b3=ib_m3+ib_m2+ib_m1+ib0;
  e_b4=ib_m4+ib_m3+ib_m2+ib_m1+ib0;
  r_b0=ret0; r_b1=(1+ret_m1)*(1+ret0)-1;
  r_b2=(1+ret_m2)*(1+ret_m1)*(1+ret0)-1;
  r_b3=(1+ret_m3)*(1+ret_m2)*(1+ret_m1)*(1+ret0)-1;
  r_b4=(1+ret_m4)*(1+ret_m3)*(1+ret_m2)*(1+ret_m1)*(1+ret0)-1;
  y_f1=e_f1/mve0; y_f2=e_f2/mve0; y_f3=e_f3/mve0;
  y_b0=e_b0/mve_m1; y_b1=e_b1/mve_m2; y_b2=e_b2/mve_m3;
  y_b3=e_b3/mve_m4; y_b4=e_b4/mve_m5;
  d_f1=(r_f1<0); d_f2=(r_f2<0); d_f3=(r_f3<0);
  d_b0=(r_b0<0); d_b1=(r_b1<0); d_b2=(r_b2<0);
  d_b3=(r_b3<0); d_b4=(r_b4<0);
  if missing(ceq_usd) or ceq_usd<=0 or mve0<=0 then delete;
  if nmiss(of ib_m4 ib_m3 ib_m2 ib_m1 ib0 ib_p1 ib_p2 ib_p3
              ret_m4 ret_m3 ret_m2 ret_m1 ret0 ret_p1 ret_p2 ret_p3
              ep_m4 ep_m3 ep_m2 ep_m1 ep0 ep_p1 ep_p2 ep_p3
              mve_m5 mve_m4 mve_m3 mve_m2 mve_m1 mve0 mtb
              y_f1 y_f2 y_f3 r_f1 r_f2 r_f3
              y_b0 y_b1 y_b2 y_b3 y_b4 r_b0 r_b1 r_b2 r_b3 r_b4)=0;
run;

proc sql;
  select count(*) as complete_eight_year_candidates,
         count(distinct gvkey) as distinct_companies,
         min(fyear) as first_formation_year,max(fyear) as last_formation_year
  from wide1;
  select fyear,count(*) as complete_candidates
  from wide1 group by fyear order by fyear;
quit;

proc sort data=wide1;
  by fyear;
run;

proc rank data=wide1 out=tail_rank groups=200;
  by fyear;
  var ep_m4 ep_m3 ep_m2 ep_m1 ep0 ep_p1 ep_p2 ep_p3
      ret_m4 ret_m3 ret_m2 ret_m1 ret0 ret_p1 ret_p2 ret_p3
      y_f1 y_f2 y_f3 r_f1 r_f2 r_f3
      y_b0 y_b1 y_b2 y_b3 y_b4 r_b0 r_b1 r_b2 r_b3 r_b4;
  ranks q_epm4 q_epm3 q_epm2 q_epm1 q_ep0 q_epp1 q_epp2 q_epp3
        q_rm4 q_rm3 q_rm2 q_rm1 q_r0 q_rp1 q_rp2 q_rp3
        q_yf1 q_yf2 q_yf3 q_rf1 q_rf2 q_rf3
        q_yb0 q_yb1 q_yb2 q_yb3 q_yb4 q_rb0 q_rb1 q_rb2 q_rb3 q_rb4;
run;

data tail_trim;
  set tail_rank;
  array tailq[32] q_epm4 q_epm3 q_epm2 q_epm1 q_ep0 q_epp1 q_epp2 q_epp3
                    q_rm4 q_rm3 q_rm2 q_rm1 q_r0 q_rp1 q_rp2 q_rp3
                    q_yf1 q_yf2 q_yf3 q_rf1 q_rf2 q_rf3
                    q_yb0 q_yb1 q_yb2 q_yb3 q_yb4 q_rb0 q_rb1 q_rb2 q_rb3 q_rb4;
  do i=1 to dim(tailq);
    if tailq[i]=0 or tailq[i]=199 then delete;
  end;
  drop i;
run;

proc sort data=tail_trim;
  by fyear;
run;

proc rank data=tail_trim out=mtb_ranked groups=5;
  by fyear;
  var mtb;
  ranks mtb_group;
run;

data out.reg;
  set mtb_ranked;
  mtbrank=mtb_group+1;
  keep gvkey fyear mtb mtbrank y_f1 y_f2 y_f3 r_f1 r_f2 r_f3
       d_f1 d_f2 d_f3 y_b0 y_b1 y_b2 y_b3 y_b4
       r_b0 r_b1 r_b2 r_b3 r_b4 d_b0 d_b1 d_b2 d_b3 d_b4;
run;

proc sql;
  select count(*) as final_common_firm_years,
         count(distinct gvkey) as final_distinct_companies,
         min(fyear) as first_formation_year,max(fyear) as last_formation_year
  from out.reg;
  select fyear,count(*) as n_firm_years,
         sum(mtb_group=0) as quintile_1,sum(mtb_group=1) as quintile_2,
         sum(mtb_group=2) as quintile_3,sum(mtb_group=3) as quintile_4,
         sum(mtb_group=4) as quintile_5
  from mtb_ranked group by fyear order by fyear;
quit;

proc means data=out.reg n mean std p1 p99 min max;
  var mtb mtbrank y_f1 y_f2 y_f3 r_f1 r_f2 r_f3
      d_f1 d_f2 d_f3 y_b0 y_b1 y_b2 y_b3 y_b4
      r_b0 r_b1 r_b2 r_b3 r_b4 d_b0 d_b1 d_b2 d_b3 d_b4;
run;

proc means data=out.reg n mean std p1 p99 min max;
  by fyear;
  var mtb mtbrank y_f1 y_f2 y_f3 r_f1 r_f2 r_f3
      y_b0 y_b1 y_b2 y_b3 y_b4 r_b0 r_b1 r_b2 r_b3 r_b4;
run;

proc contents data=out.reg varnum;
run;
