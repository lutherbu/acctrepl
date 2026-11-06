options errorabend nocenter nonumber;

/* Source libraries are read-only. All output is relative to this attempt. */
libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname crsp "/storage/sas/base/crsp/a_stock" access=readonly;
libname ccm "/storage/sas/base/crsp/a_ccm" access=readonly;
libname out "data";

/* Exact annual item mappings checked against the 2004 provider guide:
   A123=IBC, A308=OANCF, A6=AT, A12=SALE, A7=PPEGT. */
proc sql;
  create table work.funda_candidates as
  select gvkey, datadate, fyear, indfmt, consol, popsrc, datafmt, scf,
         aqc, at, ibc, oancf, sale, ppegt, sich, curcd
  from comp.funda
  /* Fiscal-year support includes FY2004 period ends in calendar 2005. */
  where datadate between '01jan1985'd and '31dec2005'd
    and fyear between 1985 and 2004
    and indfmt='INDL' and consol='C' and popsrc='D' and datafmt='STD';

  create table work.funda_duplicate_years as
  select gvkey, fyear, count(*) as records, count(distinct datadate) as period_ends
  from work.funda_candidates
  group by gvkey, fyear
  having count(*) > 1;

  create table work.funda_exact_duplicates as
  select gvkey, fyear, datadate, count(*) as records
  from work.funda_candidates
  group by gvkey, fyear, datadate
  having count(*) > 1;

  select count(*) into :n_funda_exact trimmed
  from work.funda_exact_duplicates;
  select count(*) as annual_rows,
         (select count(*) from work.funda_duplicate_years) as duplicate_gvkey_fyears
  from work.funda_candidates;
quit;

data _null_;
  if &n_funda_exact > 0 then do;
    put 'ERROR: exact duplicate Compustat GVKEY/FYEAR/DATADATE keys remain after annual descriptor filters.';
    abort cancel;
  end;
run;

/* Keep the latest period end for a GVKEY/fiscal-year with distinct dates. */
proc sort data=work.funda_candidates out=work.funda_candidates_s;
  by gvkey fyear datadate;
run;
data work.funda_annual;
  set work.funda_candidates_s;
  by gvkey fyear datadate;
  if last.fyear;
run;

proc sql;
  create table work.funda_postcheck as
  select gvkey, fyear, count(*) as records
  from work.funda_annual
  group by gvkey, fyear
  having count(*) > 1;
  select count(*) as annual_rows_after_selection,
         (select count(*) from work.funda_postcheck) as duplicate_keys_after_selection
  from work.funda_annual;

  /* Exact fiscal-year joins preserve gaps rather than shifting later records. */
  create table work.annual_panel as
  select a.gvkey, a.datadate, a.fyear, a.sich, a.aqc, a.at, a.ibc,
         a.oancf, a.sale, a.ppegt, a.curcd,
         p.datadate as prev_date, p.at as at_prev, p.curcd as curcd_prev,
         p.oancf as oancf_prev, p.sale as sale_prev,
         n.oancf as oancf_next, n.curcd as curcd_next
  from work.funda_annual as a
  left join work.funda_annual as p
    on a.gvkey=p.gvkey and p.fyear=a.fyear-1
  left join work.funda_annual as n
    on a.gvkey=n.gvkey and n.fyear=a.fyear+1;
  select count(*) as annual_panel_rows from work.annual_panel;
quit;

data work.annual_measures;
  set work.annual_panel;
  length sic3 8;
  curcd=upcase(strip(curcd));
  curcd_prev=upcase(strip(curcd_prev));
  curcd_next=upcase(strip(curcd_next));
  currency_t_known=(not missing(curcd) and lengthn(strip(curcd))=3
                    and verify(strip(curcd),'ABCDEFGHIJKLMNOPQRSTUVWXYZ')=0);
  currency_prev_known=(not missing(curcd_prev) and lengthn(strip(curcd_prev))=3
                       and verify(strip(curcd_prev),'ABCDEFGHIJKLMNOPQRSTUVWXYZ')=0);
  currency_next_known=(not missing(curcd_next) and lengthn(strip(curcd_next))=3
                       and verify(strip(curcd_next),'ABCDEFGHIJKLMNOPQRSTUVWXYZ')=0);
  currency_tp_known=(currency_t_known=1 and currency_prev_known=1);
  currency_tn_known=(currency_t_known=1 and currency_next_known=1);
  currency_tp_match=(currency_tp_known=1 and curcd=curcd_prev);
  currency_tn_match=(currency_tn_known=1 and curcd=curcd_next);
  if not missing(sich) then sic3=floor(sich/10);
  /* A ratio using AT_t and AT_(t-1) is defined only when their reported
     currencies are both known and match. Never add unlike or unknown units. */
  if currency_tp_match=1 and not missing(at) and not missing(at_prev) then avgat=(at+at_prev)/2;
  if avgat>0 then do;
    if not missing(ibc) and not missing(oancf) then acc=(ibc-oancf)/avgat;
    if not missing(oancf) then cf=oancf/avgat;
    if currency_tp_match=1 and not missing(oancf) and not missing(oancf_prev) then delta_cf=(oancf-oancf_prev)/avgat;
    if currency_tp_match=1 and not missing(sale) and not missing(sale_prev) then drev=(sale-sale_prev)/avgat;
    if not missing(ppegt) then gppe=ppegt/avgat;
    /* Table 2 and Table 9 scale all cash-flow variables for observation t
       by average assets in t, including the DD lead and lag predictors. */
    if currency_tp_match=1 and not missing(oancf_prev) then cf_lag=oancf_prev/avgat;
    if currency_tn_match=1 and not missing(oancf_next) then cf_lead=oancf_next/avgat;
  end;
run;

/* Currency audit covers the full supporting population, before screen,
   industry median, trimming, and fit eligibility. */
proc sql;
  select count(*) as supporting_annual_rows,
         sum(currency_t_known=0) as current_currency_unknown,
         sum(currency_prev_known=0) as prior_currency_unknown,
         sum(currency_next_known=0) as following_currency_unknown,
         sum(currency_tp_known=0) as current_prior_pair_unknown,
         sum(currency_tp_known=1 and currency_tp_match=0) as current_prior_changes,
         sum(currency_tn_known=0) as current_following_pair_unknown,
         sum(currency_tn_known=1 and currency_tn_match=0) as current_following_changes,
         sum(currency_tp_match=1) as current_prior_matches,
         sum(currency_tn_match=1) as current_following_matches
  from work.annual_measures;
quit;

/* Current-year baseline screens; previous and following values were built first. */
data work.base_accounting;
  set work.annual_measures;
  if fyear>=1987 and fyear<=2003;
  /* A missing SIC cannot establish nonfinancial status. */
  if missing(sich) then delete;
  if sich>=6000 and sich<=6999 then delete;
  if missing(aqc) or aqc=0;
run;

proc sql;
  select count(*) as screen_rows,
         sum(missing(sich)) as missing_historical_sic,
         sum(missing(aqc)) as missing_acquisition_amount,
         sum(currency_t_known=0) as screen_t_unk,
         sum(currency_tp_known=0) as screen_tp_unk,
         sum(currency_tp_known=1 and currency_tp_match=0) as screen_tp_chg,
         sum(currency_tn_known=0) as screen_tn_unk,
         sum(currency_tn_known=1 and currency_tn_match=0) as screen_tn_chg
  from work.base_accounting;
quit;

/* Industry-adjusted CF is measured relative to the same SIC3-year median. */
proc summary data=work.base_accounting nway;
  where not missing(sic3) and not missing(cf);
  class fyear sic3;
  var cf;
  output out=work.median_cf(drop=_type_ _freq_) median=median_cf;
run;
proc sql;
  create table work.base_with_median as
  select a.*, m.median_cf,
         (a.cf-m.median_cf) as indadj_cf
  from work.base_accounting as a
  left join work.median_cf as m
    on a.fyear=m.fyear and a.sic3=m.sic3;
quit;

/* Within-fiscal-year rank groups implement approximately one-percent tails. */
proc sort data=work.base_with_median out=work.base_with_median_s;
  by fyear;
run;
proc rank data=work.base_with_median_s out=work.ranked groups=100 ties=mean;
  by fyear;
  var acc cf cf_lag cf_lead delta_cf drev gppe indadj_cf;
  ranks r_acc r_cf r_cf_lag r_cf_lead r_delta_cf r_drev r_gppe r_indadj_cf;
run;

data work.trimmed;
  set work.ranked;
  trim_acc=(not missing(acc) and r_acc>0 and r_acc<99);
  trim_cf=(not missing(cf) and r_cf>0 and r_cf<99);
  trim_cf_lag=(not missing(cf_lag) and r_cf_lag>0 and r_cf_lag<99);
  trim_cf_lead=(not missing(cf_lead) and r_cf_lead>0 and r_cf_lead<99);
  trim_delta_cf=(not missing(delta_cf) and r_delta_cf>0 and r_delta_cf<99);
  trim_drev=(not missing(drev) and r_drev>0 and r_drev<99);
  trim_gppe=(not missing(gppe) and r_gppe>0 and r_gppe<99);
  trim_indadj_cf=(not missing(indadj_cf) and r_indadj_cf>0 and r_indadj_cf<99);
  if not missing(cf) then dcf=(cf<0); else dcf=.;
  if not missing(delta_cf) then ddelta_cf=(delta_cf<0); else ddelta_cf=.;
  if not missing(indadj_cf) then dind=(indadj_cf<0); else dind=.;
run;

/* Fiscal-year return intervals and historical CCM links for the market proxy. */
data work.return_intervals;
  set work.annual_measures;
  if fyear>=1987 and fyear<=2003 and not missing(prev_date) and datadate>prev_date;
  start_date=prev_date;
  end_date=datadate;
  keep gvkey fyear start_date end_date;
run;

proc sql;
  create table work.dsi_duplicate_dates as
  select date, count(*) as records
  from crsp.dsi
  where date between '01jan1986'd and '31dec2004'd
  group by date
  having count(*) > 1;
  select count(*) as duplicate_dsi_dates from work.dsi_duplicate_dates;

  create table work.valid_links as
  select i.gvkey, i.fyear, i.start_date, i.end_date,
         l.lpermno as permno, l.linkdt, l.linkenddt,
         l.linkprim, l.linktype
  from work.return_intervals as i
  inner join ccm.ccmxpf_linktable as l
    on i.gvkey=l.gvkey
  where l.linkprim in ('P','C') and l.linktype in ('LC','LU')
    and l.linkdt<=i.end_date
    and (missing(l.linkenddt) or l.linkenddt>i.start_date)
    and not missing(l.lpermno);

  create table work.permnos as
  select distinct permno from work.valid_links;
  select count(*) as interval_link_rows,
         (select count(*) from work.permnos) as candidate_permnos
  from work.valid_links;

  /* PERMNO is indexed in DSF; keep only the selected securities and dates. */
  create table work.dsf_selected as
  select d.permno, d.date, d.ret
  from work.permnos as p
  inner join crsp.dsf as d on p.permno=d.permno
  where d.date between '01jan1986'd and '31dec2004'd;

  create table work.stock_days as
  select l.gvkey, l.fyear, d.date,
         count(distinct l.permno) as n_links,
         count(d.ret) as n_returns,
         max(d.ret) as ret
  from work.valid_links as l
  inner join work.dsf_selected as d
    on l.permno=d.permno
  where d.date>l.start_date and d.date<=l.end_date
    and d.date>=l.linkdt
    and (missing(l.linkenddt) or d.date<=l.linkenddt)
  group by l.gvkey, l.fyear, d.date;

  create table work.market_days as
  select i.gvkey, i.fyear, d.date, d.ewretd
  from work.return_intervals as i
  inner join crsp.dsi as d
    on d.date>i.start_date and d.date<=i.end_date
  where d.date between '01jan1986'd and '31dec2004'd;
  select count(*) as stock_fiscal_days from work.stock_days;
  select count(*) as market_fiscal_days from work.market_days;
quit;

proc sort data=work.stock_days out=work.stock_days_s;
  by gvkey fyear date;
run;
data work.stock_annual;
  set work.stock_days_s;
  by gvkey fyear date;
  retain stock_product stock_days stock_bad;
  if first.fyear then do;
    stock_product=1;
    stock_days=0;
    stock_bad=0;
  end;
  if n_links=1 and n_returns=1 and not missing(ret) then do;
    stock_product=stock_product*(1+ret);
    stock_days+1;
  end;
  else stock_bad=1;
  if last.fyear then do;
    stock_return=.;
    if stock_bad=0 then stock_return=stock_product-1;
    output;
  end;
  keep gvkey fyear stock_product stock_days stock_bad stock_return;
run;

proc sort data=work.market_days out=work.market_days_s;
  by gvkey fyear date;
run;
data work.market_annual;
  set work.market_days_s;
  by gvkey fyear date;
  retain market_product market_days market_bad;
  if first.fyear then do;
    market_product=1;
    market_days=0;
    market_bad=0;
  end;
  market_days+1;
  if not missing(ewretd) then do;
    market_product=market_product*(1+ewretd);
  end;
  else market_bad=1;
  if last.fyear then do;
    mktret=.;
    if market_bad=0 then mktret=market_product-1;
    output;
  end;
  keep gvkey fyear market_product market_days market_bad mktret;
run;

proc sql;
  create table work.annual_abnret as
  select i.gvkey, i.fyear,
         s.stock_days, s.stock_bad, m.market_days, m.market_bad,
         case when s.stock_bad=0 and m.market_bad=0
                    and s.stock_days=m.market_days
                    and not missing(s.stock_return) and not missing(m.mktret)
              then s.stock_return-m.mktret else . end as abnret
  from work.return_intervals as i
  left join work.stock_annual as s
    on i.gvkey=s.gvkey and i.fyear=s.fyear
  left join work.market_annual as m
    on i.gvkey=m.gvkey and i.fyear=m.fyear;

  select count(*) as return_intervals,
         sum(not missing(abnret)) as complete_abnormal_returns,
         sum(missing(abnret)) as missing_abnormal_returns
  from work.annual_abnret;

  create table work.trimmed_with_return as
  select t.*, r.abnret
  from work.trimmed as t
  left join work.annual_abnret as r
    on t.gvkey=r.gvkey and t.fyear=r.fyear;
quit;

/* Fit-specific samples. The loss dummy remains required when its continuous
   proxy main effect is omitted from a printed regression column. */
data work.fit_samples;
  set work.trimmed_with_return;
  if not missing(abnret) then dabnret=(abnret<0); else dabnret=.;
  sample_a_cf=(trim_acc=1 and trim_cf=1);
  sample_a_dd=(trim_acc=1 and trim_cf=1 and trim_cf_lag=1 and trim_cf_lead=1);
  sample_a_jones=(trim_acc=1 and trim_cf=1 and trim_drev=1 and trim_gppe=1);
  sample_b_cf=(trim_acc=1 and trim_cf=1 and trim_delta_cf=1);
  sample_b_dd=(trim_acc=1 and trim_cf=1 and trim_cf_lag=1 and trim_cf_lead=1 and trim_delta_cf=1);
  sample_b_jones=(trim_acc=1 and trim_drev=1 and trim_gppe=1 and trim_delta_cf=1);
  sample_c_cf=(trim_acc=1 and trim_cf=1 and trim_indadj_cf=1);
  sample_c_dd=(trim_acc=1 and trim_cf=1 and trim_cf_lag=1 and trim_cf_lead=1 and trim_indadj_cf=1);
  sample_c_jones=(trim_acc=1 and trim_drev=1 and trim_gppe=1 and trim_indadj_cf=1);
  sample_m_cf=(trim_acc=1 and trim_cf=1 and not missing(abnret));
  sample_m_dd=(trim_acc=1 and trim_cf=1 and trim_cf_lag=1 and trim_cf_lead=1 and not missing(abnret));
  sample_m_jones=(trim_acc=1 and trim_drev=1 and trim_gppe=1 and not missing(abnret));
  sample_t5a_cf=(trim_acc=1 and trim_cf=1 and not missing(abnret));
  sample_t5a_dd=(trim_acc=1 and trim_cf=1 and trim_cf_lag=1 and trim_cf_lead=1 and not missing(abnret));
  sample_t5a_jones=(trim_acc=1 and trim_cf=1 and trim_drev=1 and trim_gppe=1 and not missing(abnret));
  sample_t5b_cf=(trim_acc=1 and trim_cf=1 and trim_delta_cf=1 and not missing(abnret));
  sample_t5b_dd=(trim_acc=1 and trim_cf=1 and trim_cf_lag=1 and trim_cf_lead=1 and trim_delta_cf=1 and not missing(abnret));
  sample_t5b_jones=(trim_acc=1 and trim_drev=1 and trim_gppe=1 and trim_delta_cf=1 and not missing(abnret));
  sample_t5c_cf=(trim_acc=1 and trim_cf=1 and trim_indadj_cf=1 and not missing(abnret));
  sample_t5c_dd=(trim_acc=1 and trim_cf=1 and trim_cf_lag=1 and trim_cf_lead=1 and trim_indadj_cf=1 and not missing(abnret));
  sample_t5c_jones=(trim_acc=1 and trim_drev=1 and trim_gppe=1 and trim_indadj_cf=1 and not missing(abnret));
  sample_t5d_cf=(trim_acc=1 and trim_cf=1 and trim_delta_cf=1 and trim_indadj_cf=1 and not missing(abnret));
  sample_t5d_dd=(trim_acc=1 and trim_cf=1 and trim_cf_lag=1 and trim_cf_lead=1 and trim_delta_cf=1 and trim_indadj_cf=1 and not missing(abnret));
  sample_t5d_jones=(trim_acc=1 and trim_drev=1 and trim_gppe=1 and trim_delta_cf=1 and trim_indadj_cf=1 and not missing(abnret));
  if not missing(dcf) and not missing(cf) then dcf_cf=dcf*cf; else dcf_cf=.;
  if not missing(ddelta_cf) and not missing(delta_cf) then ddelta_cf_x_delta_cf=ddelta_cf*delta_cf; else ddelta_cf_x_delta_cf=.;
  if not missing(dind) and not missing(indadj_cf) then dind_indadj_cf=dind*indadj_cf; else dind_indadj_cf=.;
  if not missing(dabnret) and not missing(abnret) then dabnret_abnret=dabnret*abnret; else dabnret_abnret=.;
run;

/* Document how the AQC-missing convention affects the Table 3A CF sample. */
proc sql;
  select sum(sample_a_cf) as table3a_cf_n,
         sum(case when sample_a_cf=1 and missing(aqc) then 1 else 0 end)
           as table3a_cf_aqc_missing,
         sum(case when sample_a_cf=1 and aqc=0 then 1 else 0 end)
           as table3a_cf_aqc_zero
  from work.fit_samples;
quit;

/* Industry eligibility uses the fit-specific complete-case population and
   requires five losses for each dummy included in that fit. */
proc sql;
  create table work.industry_counts as
  select sic3,
    sum(sample_a_cf) as n_a_cf,
    sum(case when sample_a_cf=1 and dcf=1 then 1 else 0 end) as l_a_cf,
    sum(sample_a_dd) as n_a_dd,
    sum(case when sample_a_dd=1 and dcf=1 then 1 else 0 end) as l_a_dd,
    sum(sample_a_jones) as n_a_jones,
    sum(case when sample_a_jones=1 and dcf=1 then 1 else 0 end) as l_a_jones,
    sum(sample_b_cf) as n_b_cf,
    sum(case when sample_b_cf=1 and ddelta_cf=1 then 1 else 0 end) as l_b_cf,
    sum(sample_b_dd) as n_b_dd,
    sum(case when sample_b_dd=1 and ddelta_cf=1 then 1 else 0 end) as l_b_dd,
    sum(sample_b_jones) as n_b_jones,
    sum(case when sample_b_jones=1 and ddelta_cf=1 then 1 else 0 end) as l_b_jones,
    sum(sample_c_cf) as n_c_cf,
    sum(case when sample_c_cf=1 and dind=1 then 1 else 0 end) as l_c_cf,
    sum(sample_c_dd) as n_c_dd,
    sum(case when sample_c_dd=1 and dind=1 then 1 else 0 end) as l_c_dd,
    sum(sample_c_jones) as n_c_jones,
    sum(case when sample_c_jones=1 and dind=1 then 1 else 0 end) as l_c_jones,
    sum(sample_m_cf) as n_m_cf,
    sum(case when sample_m_cf=1 and dabnret=1 then 1 else 0 end) as l_m_cf,
    sum(sample_m_dd) as n_m_dd,
    sum(case when sample_m_dd=1 and dabnret=1 then 1 else 0 end) as l_m_dd,
    sum(sample_m_jones) as n_m_jones,
    sum(case when sample_m_jones=1 and dabnret=1 then 1 else 0 end) as l_m_jones,
    sum(sample_t5a_cf) as n_t5a_cf,
    sum(case when sample_t5a_cf=1 and dcf=1 then 1 else 0 end) as cf_t5a_cf,
    sum(case when sample_t5a_cf=1 and dabnret=1 then 1 else 0 end) as ret_t5a_cf,
    sum(sample_t5a_dd) as n_t5a_dd,
    sum(case when sample_t5a_dd=1 and dcf=1 then 1 else 0 end) as cf_t5a_dd,
    sum(case when sample_t5a_dd=1 and dabnret=1 then 1 else 0 end) as ret_t5a_dd,
    sum(sample_t5a_jones) as n_t5a_jones,
    sum(case when sample_t5a_jones=1 and dcf=1 then 1 else 0 end) as cf_t5a_jones,
    sum(case when sample_t5a_jones=1 and dabnret=1 then 1 else 0 end) as ret_t5a_jones,
    sum(sample_t5b_cf) as n_t5b_cf,
    sum(case when sample_t5b_cf=1 and ddelta_cf=1 then 1 else 0 end) as cfchg_t5b_cf,
    sum(case when sample_t5b_cf=1 and dabnret=1 then 1 else 0 end) as ret_t5b_cf,
    sum(sample_t5b_dd) as n_t5b_dd,
    sum(case when sample_t5b_dd=1 and ddelta_cf=1 then 1 else 0 end) as cfchg_t5b_dd,
    sum(case when sample_t5b_dd=1 and dabnret=1 then 1 else 0 end) as ret_t5b_dd,
    sum(sample_t5b_jones) as n_t5b_jones,
    sum(case when sample_t5b_jones=1 and ddelta_cf=1 then 1 else 0 end) as cfchg_t5b_jones,
    sum(case when sample_t5b_jones=1 and dabnret=1 then 1 else 0 end) as ret_t5b_jones,
    sum(sample_t5c_cf) as n_t5c_cf,
    sum(case when sample_t5c_cf=1 and dind=1 then 1 else 0 end) as ind_t5c_cf,
    sum(case when sample_t5c_cf=1 and dabnret=1 then 1 else 0 end) as ret_t5c_cf,
    sum(sample_t5c_dd) as n_t5c_dd,
    sum(case when sample_t5c_dd=1 and dind=1 then 1 else 0 end) as ind_t5c_dd,
    sum(case when sample_t5c_dd=1 and dabnret=1 then 1 else 0 end) as ret_t5c_dd,
    sum(sample_t5c_jones) as n_t5c_jones,
    sum(case when sample_t5c_jones=1 and dind=1 then 1 else 0 end) as ind_t5c_jones,
    sum(case when sample_t5c_jones=1 and dabnret=1 then 1 else 0 end) as ret_t5c_jones,
    sum(sample_t5d_cf) as n_t5d_cf,
    sum(case when sample_t5d_cf=1 and dcf=1 then 1 else 0 end) as cf_t5d_cf,
    sum(case when sample_t5d_cf=1 and ddelta_cf=1 then 1 else 0 end) as cfchg_t5d_cf,
    sum(case when sample_t5d_cf=1 and dind=1 then 1 else 0 end) as ind_t5d_cf,
    sum(case when sample_t5d_cf=1 and dabnret=1 then 1 else 0 end) as ret_t5d_cf,
    sum(sample_t5d_dd) as n_t5d_dd,
    sum(case when sample_t5d_dd=1 and dcf=1 then 1 else 0 end) as cf_t5d_dd,
    sum(case when sample_t5d_dd=1 and ddelta_cf=1 then 1 else 0 end) as cfchg_t5d_dd,
    sum(case when sample_t5d_dd=1 and dind=1 then 1 else 0 end) as ind_t5d_dd,
    sum(case when sample_t5d_dd=1 and dabnret=1 then 1 else 0 end) as ret_t5d_dd,
    sum(sample_t5d_jones) as n_t5d_jones,
    sum(case when sample_t5d_jones=1 and dcf=1 then 1 else 0 end) as cf_t5d_jones,
    sum(case when sample_t5d_jones=1 and ddelta_cf=1 then 1 else 0 end) as cfchg_t5d_jones,
    sum(case when sample_t5d_jones=1 and dind=1 then 1 else 0 end) as ind_t5d_jones,
    sum(case when sample_t5d_jones=1 and dabnret=1 then 1 else 0 end) as ret_t5d_jones
  from work.fit_samples
  where not missing(sic3)
  group by sic3;
quit;

data work.industry_flags;
  set work.industry_counts;
  industry_a_cf=(n_a_cf>=30 and l_a_cf>=5);
  industry_a_dd=(n_a_dd>=30 and l_a_dd>=5);
  industry_a_jones=(n_a_jones>=30 and l_a_jones>=5);
  industry_b_cf=(n_b_cf>=30 and l_b_cf>=5);
  industry_b_dd=(n_b_dd>=30 and l_b_dd>=5);
  industry_b_jones=(n_b_jones>=30 and l_b_jones>=5);
  industry_c_cf=(n_c_cf>=30 and l_c_cf>=5);
  industry_c_dd=(n_c_dd>=30 and l_c_dd>=5);
  industry_c_jones=(n_c_jones>=30 and l_c_jones>=5);
  industry_m_cf=(n_m_cf>=30 and l_m_cf>=5);
  industry_m_dd=(n_m_dd>=30 and l_m_dd>=5);
  industry_m_jones=(n_m_jones>=30 and l_m_jones>=5);
  industry_t5a_cf=(n_t5a_cf>=30 and cf_t5a_cf>=5 and ret_t5a_cf>=5);
  industry_t5a_dd=(n_t5a_dd>=30 and cf_t5a_dd>=5 and ret_t5a_dd>=5);
  industry_t5a_jones=(n_t5a_jones>=30 and cf_t5a_jones>=5 and ret_t5a_jones>=5);
  industry_t5b_cf=(n_t5b_cf>=30 and cfchg_t5b_cf>=5 and ret_t5b_cf>=5);
  industry_t5b_dd=(n_t5b_dd>=30 and cfchg_t5b_dd>=5 and ret_t5b_dd>=5);
  industry_t5b_jones=(n_t5b_jones>=30 and cfchg_t5b_jones>=5 and ret_t5b_jones>=5);
  industry_t5c_cf=(n_t5c_cf>=30 and ind_t5c_cf>=5 and ret_t5c_cf>=5);
  industry_t5c_dd=(n_t5c_dd>=30 and ind_t5c_dd>=5 and ret_t5c_dd>=5);
  industry_t5c_jones=(n_t5c_jones>=30 and ind_t5c_jones>=5 and ret_t5c_jones>=5);
  industry_t5d_cf=(n_t5d_cf>=30 and cf_t5d_cf>=5 and cfchg_t5d_cf>=5 and ind_t5d_cf>=5 and ret_t5d_cf>=5);
  industry_t5d_dd=(n_t5d_dd>=30 and cf_t5d_dd>=5 and cfchg_t5d_dd>=5 and ind_t5d_dd>=5 and ret_t5d_dd>=5);
  industry_t5d_jones=(n_t5d_jones>=30 and cf_t5d_jones>=5 and cfchg_t5d_jones>=5 and ind_t5d_jones>=5 and ret_t5d_jones>=5);
run;

proc sort data=work.fit_samples; by sic3; run;
proc sort data=work.industry_flags; by sic3; run;
data out.main;
  merge work.fit_samples(in=in_sample)
        work.industry_flags(keep=sic3 industry_a_cf industry_a_dd industry_a_jones
          industry_b_cf industry_b_dd industry_b_jones
          industry_c_cf industry_c_dd industry_c_jones
          industry_m_cf industry_m_dd industry_m_jones
          industry_t5a_cf industry_t5a_dd industry_t5a_jones
          industry_t5b_cf industry_t5b_dd industry_t5b_jones
          industry_t5c_cf industry_t5c_dd industry_t5c_jones
          industry_t5d_cf industry_t5d_dd industry_t5d_jones);
  by sic3;
  if in_sample;
  array indflags {*} industry_a_cf industry_a_dd industry_a_jones
          industry_b_cf industry_b_dd industry_b_jones
          industry_c_cf industry_c_dd industry_c_jones
          industry_m_cf industry_m_dd industry_m_jones
          industry_t5a_cf industry_t5a_dd industry_t5a_jones
          industry_t5b_cf industry_t5b_dd industry_t5b_jones
          industry_t5c_cf industry_t5c_dd industry_t5c_jones
          industry_t5d_cf industry_t5d_dd industry_t5d_jones;
  do _i=1 to dim(indflags); if missing(indflags[_i]) then indflags[_i]=0; end;
  keep gvkey datadate fyear sic3 curcd curcd_prev curcd_next
       currency_t_known currency_prev_known currency_next_known
       currency_tp_known currency_tn_known currency_tp_match currency_tn_match
       acc cf cf_lag cf_lead delta_cf drev gppe
       indadj_cf dcf ddelta_cf dind abnret dabnret dcf_cf
       ddelta_cf_x_delta_cf dind_indadj_cf dabnret_abnret
       sample_a_cf sample_a_dd sample_a_jones
       sample_b_cf sample_b_dd sample_b_jones
       sample_c_cf sample_c_dd sample_c_jones
       sample_m_cf sample_m_dd sample_m_jones
       sample_t5a_cf sample_t5a_dd sample_t5a_jones
       sample_t5b_cf sample_t5b_dd sample_t5b_jones
       sample_t5c_cf sample_t5c_dd sample_t5c_jones
       sample_t5d_cf sample_t5d_dd sample_t5d_jones
       industry_a_cf industry_a_dd industry_a_jones
       industry_b_cf industry_b_dd industry_b_jones
       industry_c_cf industry_c_dd industry_c_jones
       industry_m_cf industry_m_dd industry_m_jones
       industry_t5a_cf industry_t5a_dd industry_t5a_jones
       industry_t5b_cf industry_t5b_dd industry_t5b_jones
       industry_t5c_cf industry_t5c_dd industry_t5c_jones
       industry_t5d_cf industry_t5d_dd industry_t5d_jones;
  label acc='Accruals / average assets'
        cf='Operating cash flow / average assets'
        cf_lag='Prior-year CFO / current-year average assets'
        cf_lead='Following-year CFO / current-year average assets'
        delta_cf='Change in CFO / current-year average assets'
        drev='Change in net sales / average assets'
        gppe='Gross PPE / average assets'
        indadj_cf='CF less SIC3-year median CF'
        abnret='Fiscal-year stock return less CRSP equal-weighted return'
        dcf='Indicator: CF < 0'
        ddelta_cf='Indicator: change in CF < 0'
        dind='Indicator: industry-adjusted CF < 0'
        dabnret='Indicator: abnormal return < 0'
        dcf_cf='CF loss indicator x CF'
        ddelta_cf_x_delta_cf='Change-CF loss indicator x change in CF'
        dind_indadj_cf='Industry loss indicator x industry-adjusted CF'
        dabnret_abnret='Abnormal-return loss indicator x abnormal return';
run;

/* Fit-specific firm-year N and qualifying-industry counts are ordinary summaries. */
proc sql;
  select count(*) as retained_main_firm_years,
    sum(sample_a_cf) as N_a_cf, sum(sample_a_dd) as N_a_dd, sum(sample_a_jones) as N_a_jones,
    sum(sample_b_cf) as N_b_cf, sum(sample_b_dd) as N_b_dd, sum(sample_b_jones) as N_b_jones,
    sum(sample_c_cf) as N_c_cf, sum(sample_c_dd) as N_c_dd, sum(sample_c_jones) as N_c_jones,
    sum(sample_m_cf) as N_m_cf, sum(sample_m_dd) as N_m_dd, sum(sample_m_jones) as N_m_jones,
    sum(sample_t5a_cf) as N_t5a_cf, sum(sample_t5a_dd) as N_t5a_dd, sum(sample_t5a_jones) as N_t5a_jones,
    sum(sample_t5b_cf) as N_t5b_cf, sum(sample_t5b_dd) as N_t5b_dd, sum(sample_t5b_jones) as N_t5b_jones,
    sum(sample_t5c_cf) as N_t5c_cf, sum(sample_t5c_dd) as N_t5c_dd, sum(sample_t5c_jones) as N_t5c_jones,
    sum(sample_t5d_cf) as N_t5d_cf, sum(sample_t5d_dd) as N_t5d_dd, sum(sample_t5d_jones) as N_t5d_jones
  from out.main;
  select sum(industry_a_cf) as industries_a_cf, sum(industry_a_dd) as industries_a_dd,
    sum(industry_a_jones) as industries_a_jones,
    sum(industry_b_cf) as industries_b_cf, sum(industry_b_dd) as industries_b_dd,
    sum(industry_b_jones) as industries_b_jones,
    sum(industry_c_cf) as industries_c_cf, sum(industry_c_dd) as industries_c_dd,
    sum(industry_c_jones) as industries_c_jones,
    sum(industry_m_cf) as industries_m_cf, sum(industry_m_dd) as industries_m_dd,
    sum(industry_m_jones) as industries_m_jones,
    sum(industry_t5a_cf) as industries_t5a_cf, sum(industry_t5a_dd) as industries_t5a_dd,
    sum(industry_t5a_jones) as industries_t5a_jones,
    sum(industry_t5b_cf) as industries_t5b_cf, sum(industry_t5b_dd) as industries_t5b_dd,
    sum(industry_t5b_jones) as industries_t5b_jones,
    sum(industry_t5c_cf) as industries_t5c_cf, sum(industry_t5c_dd) as industries_t5c_dd,
    sum(industry_t5c_jones) as industries_t5c_jones,
    sum(industry_t5d_cf) as industries_t5d_cf, sum(industry_t5d_dd) as industries_t5d_dd,
    sum(industry_t5d_jones) as industries_t5d_jones
  from work.industry_flags;
quit;

proc contents data=out.main; run;

/* Ordinary summaries of the actual analysis samples for unit and scale review. */
title 'Table 3 Panel A CF sample: scaled accounting variables';
proc means data=out.main n nmiss mean std p25 median p75;
  where sample_a_cf=1;
  var acc cf;
run;
title 'Table 4 CF sample: scaled accounting variables and abnormal return';
proc means data=out.main n nmiss mean std p25 median p75;
  where sample_m_cf=1;
  var acc cf abnret;
run;
title;
