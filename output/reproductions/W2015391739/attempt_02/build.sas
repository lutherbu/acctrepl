options errorabend;

/* Read only the catalog-listed input tables needed for the 1963-1990 baseline. */
libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname crsp "/storage/sas/base/crsp/a_stock" access=readonly;
libname ccm "/storage/sas/base/crsp/a_ccm" access=readonly;
libname fxsrc "/storage/sas/base/comp/d_global/currency" access=readonly;
libname out "data";

/* One annual industrial-format observation per Compustat company-year.
   If a fiscal-year label has multiple end dates in the current vintage, retain
   its latest annual period end; ties at the same date use the latest FDATE. */
data funda_candidate;
  set comp.funda(keep=gvkey datadate fyear fdate indfmt consol popsrc datafmt
                      curcd pddur ib);
  where fyear>=1963 and fyear<=1990
    and indfmt='INDL' and consol='C' and popsrc='D' and datafmt='STD';
  if not missing(gvkey) and not missing(datadate);
  curcd=upcase(strip(curcd));
  format datadate date9.;
run;
proc sql;
  title 'Compustat candidate field completeness before annual-row selection';
  select count(*) as candidate_rows,
         sum(missing(ib)) as missing_ib,
         sum(missing(curcd)) as missing_curcd
  from funda_candidate;
  title 'GVKEY 006557 duplicate-year completeness audit';
  select fyear,count(*) as candidate_rows,
         sum(not missing(ib)) as populated_ib,
         sum(not missing(curcd)) as populated_curcd,
         sum(not missing(ib) and not missing(curcd)) as complete_model_rows,
         sum(curcd='CAD') as cad_rows,sum(curcd='USD') as usd_rows,
         min(datadate) as earliest_date format=date9.,
         max(datadate) as latest_date format=date9.
  from funda_candidate
  where gvkey='006557'
  group by fyear order by fyear;
quit;
data funda_raw;
  set funda_candidate;
  if not missing(ib) and not missing(curcd);
run;
proc sort data=funda_raw out=funda_sort;
  by gvkey fyear datadate fdate;
run;
data funda_latest_date;
  set funda_sort;
  by gvkey fyear datadate;
  if last.datadate;
run;
proc sql;
  create table funda_year_counts as
  select gvkey,fyear,count(*) as n_dates
  from funda_latest_date
  group by gvkey,fyear;
  title 'Repeated complete annual rows before fiscal-year selection';
  select count(*) as company_year_groups,
         sum(n_dates>1) as repeated_company_year_groups,
         sum(n_dates) as complete_annual_rows
  from funda_year_counts;
quit;
proc sort data=funda_latest_date out=funda_yearsort;
  by gvkey fyear datadate;
run;
data funda_annual;
  set funda_yearsort;
  by gvkey fyear;
  if last.fyear;
  obsid=_n_;
  anchor_mth=intnx('month',datadate,-9,'b');
  ret_first=intnx('month',datadate,-8,'b');
  ret_last=intnx('month',datadate,3,'b');
  fx_first=intnx('month',datadate,-11,'b');
  fx_last=intnx('month',datadate,0,'b');
  format datadate anchor_mth ret_first ret_last fx_first fx_last date9.;
run;

/* Translate annual income with provider EXRAT12M legs at the statement's own
   reporting month. GBP is the intermediate currency. USD is an identity
   conversion; CURNCD is not substituted for the record's own CURCD. */
data fx_raw;
  set fxsrc.g_exrt_mth(keep=datadate fromcurm tocurm exrat12m);
  if upcase(strip(fromcurm))='GBP' and not missing(tocurm)
     and not missing(exrat12m) and exrat12m>0;
  report_month=intnx('month',datadate,0,'b');
  curcd=upcase(strip(tocurm));
  rate=exrat12m;
  keep datadate report_month curcd rate;
  format datadate report_month date9.;
run;
proc sql;
  create table fx_agg as
  select report_month,curcd,min(datadate) as first_quote,
         max(datadate) as last_quote,min(rate) as rate,
         max(rate) as rate_max,count(*) as nquote
  from fx_raw
  group by report_month,curcd;
  create table fx_valid as
  select report_month,curcd,first_quote,last_quote,rate,nquote
  from fx_agg
  where rate=rate_max;
  create table fx_factor as
  select a.report_month,a.curcd,a.rate as gbp_to_reporting,
         b.rate as gbp_to_usd,b.rate/a.rate as usd_factor,
         a.nquote as quote_reporting,b.nquote as quote_usd
  from fx_valid as a inner join fx_valid as b
    on a.report_month=b.report_month
  where b.curcd='USD' and a.curcd not in ('USD','GBP')
    and a.rate>0 and b.rate>0
  union all
  select report_month,'GBP' as curcd,1 as gbp_to_reporting,
         rate as gbp_to_usd,rate as usd_factor,
         0 as quote_reporting,nquote as quote_usd
  from fx_valid where curcd='USD' and rate>0;
  create table fx_for_year as
  select a.obsid,count(b.report_month) as fx_obs,
         min(b.report_month) as fx_report_month,
         min(b.gbp_to_reporting) as fx_gbp_to_reporting,
         min(b.gbp_to_usd) as fx_gbp_to_usd,
         min(b.usd_factor) as usd_factor,
         min(b.quote_reporting) as fx_quote_reporting,
         min(b.quote_usd) as fx_quote_usd
  from funda_annual as a left join fx_factor as b
    on a.curcd=b.curcd
   and b.report_month=intnx('month',a.datadate,0,'b')
  where a.curcd ne 'USD'
  group by a.obsid;
quit;
proc sort data=funda_annual; by obsid; run;
proc sort data=fx_for_year; by obsid; run;
data funda_usd;
  merge funda_annual(in=a) fx_for_year;
  by obsid;
  if a;
  if curcd='USD' then do;
    usd_factor=1;
    fx_obs=1;
    fx_report_month=intnx('month',datadate,0,'b');
    fx_quote_reporting=0;
    fx_quote_usd=0;
  end;
  if fx_obs=1 and usd_factor>0 then ib_usd_th=ib*1000*usd_factor;
  else ib_usd_th=.;
  format fx_report_month date9.;
  label ib_usd_th='Item 18 proxy in USD thousands';
run;
proc sql;
  title 'EXRAT12M quote uniqueness and leg coverage';
  select count(*) as report_month_currency_pairs,
         sum(nquote>1) as pairs_with_duplicate_rows,
         sum(rate ne rate_max) as pairs_with_conflicting_rates,
         min(nquote) as minimum_quote_rows,max(nquote) as maximum_quote_rows
  from fx_agg;
  title 'Provider period-rate conversion coverage by own-period CURCD';
  select curcd,count(*) as annual_rows,
         sum(fx_obs=1 and not missing(ib_usd_th)) as converted_rows,
         sum(fx_obs=0) as no_period_rate_rows
  from funda_usd group by curcd order by curcd;
  title 'GVKEY 006557 selected statement-month EXRAT12M legs';
  select gvkey,fyear,datadate,curcd,ib,fx_obs,fx_report_month,
         fx_gbp_to_reporting,fx_gbp_to_usd,usd_factor,ib_usd_th,
         fx_quote_reporting,fx_quote_usd
  from funda_usd
  where gvkey='006557' and fyear in (1982,1983)
  order by fyear;
quit;

/* Audit-only reconstruction of A1's 12 monthly EXRAT1M cross-rate averages.
   These values do not feed the handoff. They quantify coverage and rate
   differences against the documented statement-month EXRAT12M construction. */
data fx1m_raw;
  set fxsrc.g_exrt_mth(keep=datadate fromcurm tocurm exrat1m
      where=(datadate>='01jan1962'd and datadate<='31dec1991'd));
  if upcase(strip(fromcurm))='GBP' and not missing(tocurm)
     and not missing(exrat1m) and exrat1m>0;
  month=intnx('month',datadate,0,'b');
  curcd=upcase(strip(tocurm));
  rate=exrat1m;
  keep month curcd rate;
  format month date9.;
run;
proc sql;
  create table fx1m_agg as
  select month,curcd,min(rate) as rate,max(rate) as rate_max,count(*) as nquote
  from fx1m_raw group by month,curcd;
  create table fx1m_valid as
  select month,curcd,rate
  from fx1m_agg where rate=rate_max;
  create table fx1m_factor as
  select a.month,a.curcd,b.rate/a.rate as usd_factor
  from fx1m_valid as a inner join fx1m_valid as b
    on a.month=b.month
  where b.curcd='USD' and a.curcd not in ('USD','GBP') and a.rate>0
  union all
  select month,'GBP' as curcd,rate as usd_factor
  from fx1m_valid where curcd='USD';
  create table fx1m_for_year as
  select a.obsid,avg(b.usd_factor) as old_avg_usd_factor,
         count(distinct b.month) as old_fx_months
  from funda_annual as a left join fx1m_factor as b
    on a.curcd=b.curcd and b.month between a.fx_first and a.fx_last
  where a.curcd ne 'USD'
  group by a.obsid;
  create table fx_comparison as
  select a.obsid,a.gvkey,a.fyear,a.datadate,a.curcd,a.ib,a.fx_obs,
         a.usd_factor,a.ib_usd_th,
         case when a.curcd='USD' then 1 else b.old_avg_usd_factor end
           as old_avg_usd_factor,
         case when a.curcd='USD' then 12 else coalesce(b.old_fx_months,0) end
           as old_fx_months
  from funda_usd as a left join fx1m_for_year as b on a.obsid=b.obsid;
  title 'Provider-period versus A1 monthly-average conversion impact';
  select curcd,count(*) as annual_rows,
         sum(fx_obs=1) as provider_converted,
         sum(old_fx_months=12 and old_avg_usd_factor>0)
           as a1_twelve_month_converted,
         sum(fx_obs=1 and old_fx_months<12)
           as provider_only_after_monthly_gate,
         sum(fx_obs=0 and old_fx_months=12 and old_avg_usd_factor>0)
           as a1_only_after_provider_rule,
         sum(fx_obs=1 and old_fx_months=12 and old_avg_usd_factor>0
             and abs(usd_factor-old_avg_usd_factor)>1e-12)
           as different_complete_rate_factors
  from fx_comparison group by curcd order by curcd;
  title 'GVKEY 006557 old monthly-average audit versus provider period rate';
  select a.gvkey,a.fyear,a.datadate,a.curcd,a.fx_obs,a.fx_report_month,
         a.fx_gbp_to_reporting,a.fx_gbp_to_usd,a.usd_factor,a.ib_usd_th,
         b.old_fx_months,b.old_avg_usd_factor,
         case when b.old_fx_months=12 and b.old_avg_usd_factor>0
              then a.ib*1000*b.old_avg_usd_factor else . end
           as a1_eligible_ib_usd_th
  from funda_usd as a left join fx_comparison as b on a.obsid=b.obsid
  where a.gvkey='006557' and a.fyear in (1982,1983)
  order by a.fyear;
quit;

/* CCM links are retained only for standard CUSIP/unverified links with a
   primary or secondary primary marker. Special open-ended .E is handled at
   each dated CRSP observation; no current/header identifier is used. */
data linkbase;
  set ccm.ccmxpf_linktable(keep=gvkey linkprim linktype lpermno lpermco
                                 linkdt linkenddt);
  if linkprim in ('P','C') and linktype in ('LC','LU')
     and not missing(lpermno) and not missing(lpermco);
run;

/* Exact FYE-9 month anchor: use the CRSP monthly observation in that period.
   CCM supplies the return security and PERMCO. */
proc sql;
  create table anchor_candidates as
  select distinct f.obsid,f.gvkey,f.fyear,f.datadate,f.anchor_mth,
         l.lpermno as permno,l.lpermco as permco,
         l.linkprim,l.linktype,
         case when l.linkprim='P' then 1 else 2 end as prim_rank,
         case when l.linktype='LC' then 1 else 2 end as type_rank,
         m.date as anchor_date,abs(m.prc)*m.shrout as primary_mve
  from funda_usd as f
  inner join linkbase as l on f.gvkey=l.gvkey
  inner join crsp.msf as m on m.permno=l.lpermno and m.permco=l.lpermco
  where intnx('month',m.date,0,'b')=f.anchor_mth
    and (l.linkdt=.B or l.linkdt<=m.date)
    and (l.linkenddt=.E or l.linkenddt>=m.date)
    and m.date between '01jan1962'd and '31dec1991'd;
quit;
proc sql;
  create table anchor_by_issue as
  select obsid,gvkey,fyear,datadate,anchor_mth,permno,permco,
         min(prim_rank) as prim_rank,min(type_rank) as type_rank,
         max(anchor_date) as anchor_date,max(primary_mve) as primary_mve,
         count(distinct anchor_date) as anchor_dates
  from anchor_candidates
  group by obsid,gvkey,fyear,datadate,anchor_mth,permno,permco;
  create table anchor_best_prim as
  select obsid,min(prim_rank) as prim_rank
  from anchor_by_issue group by obsid;
  create table anchor_prim as
  select a.* from anchor_by_issue as a inner join anchor_best_prim as b
    on a.obsid=b.obsid and a.prim_rank=b.prim_rank;
  create table anchor_best_type as
  select obsid,min(type_rank) as type_rank
  from anchor_prim group by obsid;
  create table anchor_top as
  select a.* from anchor_prim as a inner join anchor_best_type as b
    on a.obsid=b.obsid and a.type_rank=b.type_rank;
  create table anchor_rank_count as
  select obsid,count(distinct permno) as n_top_permno,
         count(distinct permco) as n_top_permco
  from anchor_top group by obsid;
  create table ret_choice as
  select a.obsid,a.gvkey,a.fyear,a.datadate,a.anchor_mth,a.permno,a.permco,
         a.prim_rank,a.type_rank,a.anchor_date,a.primary_mve,
         b.n_top_permno,b.n_top_permco
  from anchor_top as a inner join anchor_rank_count as b
    on a.obsid=b.obsid
  where b.n_top_permno=1 and b.n_top_permco=1;
quit;

/* For company MVE, identify the company through the date-valid CCM PERMCO,
   then aggregate distinct CRSP PERMNOs on that PERMCO at the same anchor
   month. This includes eligible secondary issues even when CCM has no separate
   primary route for each class. */
proc sql;
  create table company_anchor_issues as
  select distinct c.obsid,c.gvkey,c.fyear,c.datadate,c.anchor_mth,
         c.permno as primary_permno,c.permco,c.anchor_date,
         m.permno,m.date,abs(m.prc)*m.shrout as issue_mve
  from ret_choice as c
  inner join crsp.msf as m on m.permco=c.permco
  where intnx('month',m.date,0,'b')=c.anchor_mth
    and m.date between '01jan1962'd and '31dec1991'd;
  create table company_anchor_unique as
  select obsid,gvkey,fyear,datadate,anchor_mth,anchor_date,primary_permno,permco,
         permno,max(date) as quote_date,max(issue_mve) as issue_mve
  from company_anchor_issues
  group by obsid,gvkey,fyear,datadate,anchor_mth,anchor_date,primary_permno,permco,permno;
  create table mve_stats as
  select obsid,gvkey,fyear,datadate,anchor_mth,anchor_date,primary_permno,permco,
         count(*) as n_issues,
         sum(case when issue_mve>0 then 1 else 0 end) as n_valid_issues,
         sum(issue_mve) as company_mve_th,
         max(case when permno=primary_permno then issue_mve else . end) as primary_mve_th
  from company_anchor_unique
  group by obsid,gvkey,fyear,datadate,anchor_mth,anchor_date,primary_permno,permco;
quit;

/* Fetch exactly the twelve CRSP months FYE-8 through FYE+3 and require the
   chosen CCM link to be effective on every actual monthly CRSP date. */
proc sql;
  create table return_months as
  select distinct c.obsid,c.gvkey,c.fyear,c.datadate,c.permno,c.permco,
         intnx('month',m.date,0,'b') as mth format=date9.,m.date,m.ret
  from ret_choice as c
  inner join crsp.msf as m on m.permno=c.permno and m.permco=c.permco
  inner join linkbase as l on l.gvkey=c.gvkey and l.lpermno=c.permno
                           and l.lpermco=c.permco
  where intnx('month',m.date,0,'b') between
          intnx('month',c.datadate,-8,'b') and intnx('month',c.datadate,3,'b')
    and (l.linkdt=.B or l.linkdt<=m.date)
    and (l.linkenddt=.E or l.linkenddt>=m.date)
    and m.date between '01jan1962'd and '31dec1991'd;
  create table return_counts as
  select obsid,gvkey,fyear,datadate,count(*) as n_rows,
         count(distinct mth) as n_months,count(ret) as n_returns,
         min(mth) as first_month,max(mth) as last_month
  from return_months
  group by obsid,gvkey,fyear,datadate;
quit;
proc sort data=return_months out=return_months_sort;
  by obsid mth;
run;
data return_products;
  set return_months_sort;
  by obsid;
  retain grossret;
  if first.obsid then grossret=1;
  if not missing(ret) then grossret=grossret*(1+ret);
  if last.obsid then do;
    actual_ret=grossret-1;
    output;
  end;
  keep obsid gvkey fyear datadate actual_ret;
run;
proc sql;
  create table return_valid as
  select p.obsid,p.gvkey,p.fyear,p.datadate,p.actual_ret
  from return_products as p inner join return_counts as c
    on p.obsid=c.obsid
  where c.n_rows=12 and c.n_months=12 and c.n_returns=12
    and c.first_month=intnx('month',p.datadate,-8,'b')
    and c.last_month=intnx('month',p.datadate,3,'b');
quit;

/* Join construction components and retain complete earnings, currency,
   company market equity and actual-return observations. */
proc sort data=funda_usd; by obsid; run;
proc sort data=mve_stats; by obsid; run;
proc sort data=return_valid; by obsid; run;
data analysis_raw;
  merge funda_usd(in=a) mve_stats(in=b) return_valid(in=c);
  by obsid;
  if a and b and c and fx_obs=1 and not missing(ib_usd_th)
     and n_issues>0 and n_valid_issues=n_issues and company_mve_th>0
     and primary_mve_th>0 and not missing(actual_ret);
  permno=primary_permno;
  x=ib_usd_th/company_mve_th;
  r_actual=actual_ret;
  company_to_primary=company_mve_th/primary_mve_th;
  format datadate anchor_mth anchor_date date9.;
  label x='X: item 18 proxy / company MVE at FYE-9'
        r_actual='Actual 12-month CRSP return'
        company_mve_th='Company MVE in USD thousands'
        primary_mve_th='Primary linked issue MVE in USD thousands'
        company_to_primary='Company MVE / primary issue MVE';
run;
proc sort data=analysis_raw out=analysis_key;
  by gvkey fyear datadate;
run;
data analysis_key;
  set analysis_key;
  by gvkey fyear;
  if first.fyear and last.fyear;
  obsid=_n_;
run;

/* Within-year tail exclusion is applied to the full actual-return sample and
   to each source variable before news partitions. */
proc means data=analysis_key nway noprint;
  class fyear;
  var r_actual;
  output out=ret_cut(drop=_type_ _freq_) p1=r_p1 p99=r_p99;
run;
proc means data=analysis_key nway noprint;
  class fyear;
  var x;
  output out=x_cut(drop=_type_ _freq_) p1=x_p1 p99=x_p99;
run;
proc sort data=analysis_key; by fyear; run;
proc sort data=ret_cut; by fyear; run;
proc sort data=x_cut; by fyear; run;
data trim_cut;
  merge ret_cut x_cut;
  by fyear;
run;
proc sort data=trim_cut; by fyear; run;
data trimmed0;
  merge analysis_key(in=a) trim_cut;
  by fyear;
  if a;
  keep_r=(r_actual>=r_p1 and r_actual<=r_p99);
  keep_x=(x>=x_p1 and x<=x_p99);
  keep_both=(keep_r and keep_x);
run;
data trimmed;
  set trimmed0;
  if keep_both;
run;

/* Supporting generator: one pooled OLS of actual R on X over the full trimmed
   actual sample. The observed firm-year residual is retained only in WORK. */
proc reg data=trimmed outest=gen_est;
  model r_actual=x;
  output out=gen_pred p=fitted r=eps;
run;
quit;
data _null_;
  set gen_est;
  if _TYPE_='PARMS' then do;
    call symputx('gen_b0',Intercept);
    call symputx('gen_b1',x);
  end;
run;

/* Seeded within-year cyclic rotation of a random ordering is a one-to-one
   residual permutation and a derangement whenever the year has >=2 firms. */
data gen_shuffle;
  set gen_pred;
  if _n_=1 then call streaminit(20261103);
  shuffle_u=rand('uniform');
run;
proc sort data=gen_shuffle out=gen_order;
  by fyear shuffle_u gvkey;
run;
data sim_assignment0;
  set gen_order;
  by fyear;
  retain first_obs prev_eps prev_gvkey n_year;
  length sim_source_gvkey $16;
  if first.fyear then do;
    first_obs=obsid;
    n_year=0;
  end;
  n_year+1;
  if not first.fyear then do;
    target_obs=obsid;
    sim_eps=prev_eps;
    sim_source_gvkey=prev_gvkey;
    output;
  end;
  prev_eps=eps;
  prev_gvkey=gvkey;
  if last.fyear and n_year>=2 then do;
    target_obs=first_obs;
    sim_eps=eps;
    sim_source_gvkey=gvkey;
    output;
  end;
  keep target_obs fyear sim_eps sim_source_gvkey;
run;
proc sql;
  create table sim_assignment as
  select a.target_obs,a.fyear,a.sim_eps,a.sim_source_gvkey,
         g.gvkey as target_gvkey
  from sim_assignment0 as a inner join gen_pred as g
    on a.target_obs=g.obsid;
  create table permutation_audit as
  select fyear,count(*) as n_assignments,
         count(distinct target_obs) as n_unique_targets,
         count(distinct sim_source_gvkey) as n_unique_sources,
         sum(case when target_gvkey=sim_source_gvkey then 1 else 0 end) as n_self
  from sim_assignment group by fyear;
  create table simulation as
  select g.*,a.sim_eps,a.sim_source_gvkey,
         &gen_b0 + (&gen_b1*g.x) + a.sim_eps as r_sim
  from gen_pred as g left join sim_assignment as a
    on g.obsid=a.target_obs;
quit;

/* Construction and sample audit totals; published counts are comparison
   results and are never used as selection rules. */
proc sql;
  title 'Provider-period currency conversion counts by own-period CURCD';
  select curcd,count(*) as annual_rows,
         sum(fx_obs=1 and not missing(ib_usd_th)) as converted_rows,
         sum(fx_obs=0) as no_period_rate_rows
  from funda_usd group by curcd order by curcd;
  title 'Construction attrition counts';
  select 'funda_annual' as stage length=24,count(*) as n
    from funda_annual
  union all select 'funda_usd_complete',count(*) from funda_usd
    where fx_obs=1 and not missing(ib_usd_th)
  union all select 'anchor_candidates',count(distinct obsid) from anchor_candidates
  union all select 'unique_return_link',count(distinct obsid) from ret_choice
  union all select 'company_mve_complete',count(*) from mve_stats
    where n_issues>0 and n_valid_issues=n_issues and company_mve_th>0
  union all select 'complete_actual_window',count(*) from return_valid
  union all select 'actual_complete_join',count(*) from analysis_raw
  union all select 'after_within_year_trim',count(*) from trimmed
  ;
  title 'Source sample counts by fiscal year';
  select fyear,count(*) as n
  from analysis_raw group by fyear order by fyear;
  title 'Ambiguous top-ranked anchor links';
  select count(*) as ambiguous_firm_years
  from anchor_rank_count where n_top_permno ne 1 or n_top_permco ne 1;
  title 'Trim counts and retained rows by fiscal year';
  select fyear,count(*) as before_n,sum(keep_r=0) as excluded_return,
         sum(keep_x=0) as excluded_x,sum(keep_both=0) as excluded_union,
         sum(keep_both=1) as retained
  from trimmed0 group by fyear order by fyear;
  title 'Actual and simulated sign partitions';
  select fyear,
         sum(r_actual<0) as actual_bad,
         sum(r_actual>=0) as actual_good,
         sum(r_sim<0) as simulated_bad,
         sum(r_sim>=0) as simulated_good,
         sum(missing(r_sim)) as missing_sim
  from simulation group by fyear order by fyear;
  title 'Residual assignment audit by year';
  select * from permutation_audit order by fyear;
  title 'Company versus primary issue market equity audit';
  select count(*) as n,
         sum(abs(company_mve_th-primary_mve_th)>
             1e-8*max(abs(company_mve_th),abs(primary_mve_th))) as n_different,
         mean(company_to_primary) as mean_company_to_primary,
         min(company_to_primary) as min_company_to_primary,
         max(company_to_primary) as max_company_to_primary
  from analysis_raw;
quit;
data _null_;
  set permutation_audit;
  if n_assignments ne n_unique_targets or
     n_assignments ne n_unique_sources or n_self ne 0 then do;
    put 'ERROR: residual assignment is not a one-to-one within-year derangement';
    abort cancel;
  end;
run;
title 'Final analysis-input distributions';
proc means data=simulation n mean std var median min max;
  var r_actual r_sim x company_mve_th ib_usd_th company_to_primary;
run;
title;

/* Export one unique firm-year row with both partition variables. */
data out.basu_replication_1963_1990(label='Basu 1963-1990 actual and simulated returns');
  set simulation;
  keep gvkey fyear datadate permno permco curcd ib ib_usd_th fx_obs
       fx_report_month fx_gbp_to_reporting fx_gbp_to_usd
       fx_quote_reporting fx_quote_usd
       anchor_mth anchor_date ret_first ret_last primary_mve_th company_mve_th
       company_to_primary x r_actual r_sim sim_source_gvkey;
  label gvkey='Compustat global company key'
        fyear='Compustat fiscal year'
        datadate='Actual fiscal period end'
        permno='Date-valid CCM primary return security'
        permco='Date-valid CRSP company identifier'
        curcd='Own-period Compustat reporting currency'
        ib='Compustat income before extraordinary items (item 18 proxy)'
        ib_usd_th='Item 18 proxy in USD thousands'
        fx_obs='USD identity or provider EXRAT12M rate available'
        fx_report_month='Statement reporting month for EXRAT12M'
        fx_gbp_to_reporting='GBP to reporting-currency EXRAT12M leg'
        fx_gbp_to_usd='GBP to USD EXRAT12M leg'
        fx_quote_reporting='Rows in reporting-currency quote group'
        fx_quote_usd='Rows in USD quote group'
        anchor_mth='FYE-9 anchor month'
        anchor_date='Actual CRSP anchor quote date'
        ret_first='First required monthly return period'
        ret_last='Last required monthly return period'
        primary_mve_th='Primary linked issue MVE in USD thousands'
        company_mve_th='Company MVE in USD thousands'
        company_to_primary='Company MVE / primary issue MVE'
        x='Scaled earnings X'
        r_actual='Actual CRSP 12-month return'
        r_sim='One-draw simulated return'
        sim_source_gvkey='Same-year source firm for simulated residual';
  format datadate fx_report_month anchor_mth anchor_date ret_first ret_last date9.;
run;
