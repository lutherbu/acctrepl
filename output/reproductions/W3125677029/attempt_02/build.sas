options errorabend nodate nonumber;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname out "data";

/* Profile the exact annual source and its categorical selection fields. */
data work.period_source;
  set comp.funda(
    keep=gvkey datadate fyear fyr indfmt consol popsrc datafmt sich curcd fic
         at cogs ibc oancf xidoc invt ppegt rect sale xad xrd xsga
    where=(fyear ge 1985 and fyear le 2005)
  );
run;

proc freq data=work.period_source;
  tables indfmt consol popsrc datafmt / missing;
run;

proc contents data=work.period_source varnum;
run;

/* The paper's annual industrial/research sample, with two years of lag history. */
data work.annual;
  set work.period_source;
  if indfmt ne 'INDL' then delete;
  if datafmt ne 'STD' then delete;
  if popsrc ne 'D' then delete;
  if consol ne 'C' then delete;
  if missing(gvkey) or missing(fyear) then delete;
run;

proc sql;
  create table work.duplicate_keys as
  select gvkey, fyear, count(*) as key_n
  from work.annual
  group by gvkey, fyear
  having calculated key_n gt 1;
quit;

proc sql noprint;
  select count(*), coalesce(sum(key_n - 1), 0)
    into :duplicate_key_count trimmed, :duplicate_extra_rows trimmed
  from work.duplicate_keys;
  select count(*) into :annual_row_count trimmed from work.annual;
quit;

%put NOTE: FILTERED_ANNUAL_ROWS=&annual_row_count.;
%put NOTE: DUPLICATE_GVKEY_FYEAR_KEYS=&duplicate_key_count.;
%put NOTE: DUPLICATE_EXTRA_ROWS=&duplicate_extra_rows.;

%if %sysevalf(&duplicate_key_count. gt 0) %then %do;
  %put ERROR: Filtered COMP.FUNDA is not unique by GVKEY and FYEAR. No row is silently selected.;
  %abort cancel;
%end;

proc sort data=work.annual;
  by gvkey fyear;
run;

/* Exact fiscal-year joins preserve gaps and retain complete t-1/t-2 history. */
proc sql;
  create table work.lagged as
  select a.*,
         b.fyear as fyear_lag1,
         b.datadate as datadate_lag1,
         b.curcd as curcd_lag1,
         b.at as at_lag1,
         b.sale as sale_lag1,
         b.invt as invt_lag1,
         b.rect as rect_lag1,
         c.fyear as fyear_lag2,
         c.datadate as datadate_lag2,
         c.curcd as curcd_lag2,
         c.sale as sale_lag2
  from work.annual as a
  left join work.annual as b
    on a.gvkey=b.gvkey and b.fyear=a.fyear-1
  left join work.annual as c
    on a.gvkey=c.gvkey and c.fyear=a.fyear-2;
quit;

proc sql;
  select count(*) as AnnualRowsBeforeLagJoin from work.annual;
  select count(*) as AnnualRowsAfterLagJoin from work.lagged;
  select count(*) as CurrentRowsWithPriorFY
    from work.lagged where fyear ge 1987 and fyear le 2005 and not missing(fyear_lag1);
  select count(*) as CurrentRowsWithTwoPriorFY
    from work.lagged where fyear ge 1987 and fyear le 2005 and not missing(fyear_lag2);
quit;

/* Sample years, historical industry, nonfinancial screen, and scaled inputs. */
data work.target;
  set work.lagged;
  if fyear lt 1987 or fyear gt 2005 then delete;
  if missing(sich) or sich lt 1000 or sich gt 9999 then delete;
  if sich ge 6000 and sich le 6999 then delete;
  sich2=floor(sich/100);

  time=fyear-1987;
  sca=(fyear ge 2000 and fyear le 2001);
  sox=(fyear ge 2002 and fyear le 2005);

  currency_t_lag1_match=0;
  if not missing(curcd) and not missing(curcd_lag1) and curcd=curcd_lag1 then
    currency_t_lag1_match=1;
  currency_lag1_lag2_match=0;
  if not missing(curcd_lag1) and not missing(curcd_lag2) and curcd_lag1=curcd_lag2 then
    currency_lag1_lag2_match=1;

  /* Raw completeness flags support exact counts before applying currency validity. */
  raw_jones_support=(nmiss(ibc,oancf,xidoc,at_lag1,sale,sale_lag1,
                           rect,rect_lag1,ppegt)=0 and at_lag1 gt 0);
  raw_cfo_support=(nmiss(oancf,xidoc,at_lag1,sale,sale_lag1)=0 and at_lag1 gt 0);
  raw_prod_support=(nmiss(cogs,invt,invt_lag1,at_lag1,sale,sale_lag1,sale_lag2)=0
                    and at_lag1 gt 0);
  raw_disx_support=(nmiss(xsga,at_lag1,sale_lag1)=0 and at_lag1 gt 0);
  raw_common_support=(raw_jones_support and raw_cfo_support and
                      raw_prod_support and raw_disx_support);

  /* Only subtract monetary values when both periods use the same CURCD. */
  if currency_t_lag1_match and not missing(sale) and not missing(sale_lag1) then
    delta_sale=sale-sale_lag1;
  if currency_lag1_lag2_match and not missing(sale_lag1) and not missing(sale_lag2) then
    delta_sale_lag=sale_lag1-sale_lag2;
  if currency_t_lag1_match and not missing(rect) and not missing(rect_lag1) then
    delta_ar=rect-rect_lag1;

  if not missing(at_lag1) and at_lag1 gt 0 then do;
    inv_atlag=1/at_lag1;
    if currency_t_lag1_match and not missing(sale) then sale_scaled=sale/at_lag1;
    if not missing(delta_sale) then delta_sale_scaled=delta_sale/at_lag1;
    if not missing(delta_sale_lag) then delta_sale_lag_scaled=delta_sale_lag/at_lag1;
    if not missing(delta_sale) and not missing(delta_ar) then
      delta_sale_ar_scaled=(delta_sale-delta_ar)/at_lag1;
    if currency_t_lag1_match and not missing(ppegt) then ppe_scaled=ppegt/at_lag1;
    if not missing(sale_lag1) then lag_sale_scaled=sale_lag1/at_lag1;
    if currency_t_lag1_match and not missing(ibc) and not missing(oancf) and not missing(xidoc) then do;
      cfo=oancf-xidoc;
      total_accrual=ibc-cfo;
      cfo_scaled=cfo/at_lag1;
      total_accrual_scaled=total_accrual/at_lag1;
    end;
    if currency_t_lag1_match and not missing(cogs) and not missing(invt) and not missing(invt_lag1) then do;
      production_cost=cogs+invt-invt_lag1;
      production_scaled=production_cost/at_lag1;
    end;
    if currency_t_lag1_match and not missing(xsga) then do;
      discretionary_expense=xsga+coalesce(xad,0)+coalesce(xrd,0);
      discretionary_scaled=discretionary_expense/at_lag1;
    end;
  end;
run;

proc sql;
  select count(*) as NonfinancialTargetRows,
         count(distinct gvkey) as NonfinancialTargetFirms,
         min(fyear) as FirstFiscalYear,
         max(fyear) as LastFiscalYear
    from work.target;
  create table work.raw_common_groups as
  select sich2, fyear, count(*) as group_n
  from work.target
  where raw_common_support=1
  group by sich2, fyear
  having calculated group_n ge 8;
  create table work.raw_common_sample as
  select a.* from work.target as a inner join work.raw_common_groups as b
    on a.sich2=b.sich2 and a.fyear=b.fyear
  where a.raw_common_support=1;
  select count(*) as PreCurrencyCommonCandidateRows,
         count(distinct gvkey) as PreCurrencyCommonCandidateFirms,
         sum(currency_t_lag1_match=0) as CurrentLag1CurrencyMismatchRows,
         sum(currency_lag1_lag2_match=0) as Lag1Lag2CurrencyMismatchRows,
         sum(currency_t_lag1_match=0 or currency_lag1_lag2_match=0) as AnyRequiredCurrencyMismatchRows
    from work.raw_common_sample;
  select sum(raw_jones_support) as raw_jones_n,
         sum(raw_jones_support and currency_t_lag1_match=0) as jones_cur01_mis_n,
         sum(raw_cfo_support) as raw_cfo_n,
         sum(raw_cfo_support and currency_t_lag1_match=0) as cfo_cur01_mis_n,
         sum(raw_prod_support) as raw_prod_n,
         sum(raw_prod_support and currency_t_lag1_match=0) as prod_cur01_mis_n,
         sum(raw_prod_support and currency_t_lag1_match=1 and currency_lag1_lag2_match=0) as prod_cur12_mis_n,
         sum(raw_disx_support) as raw_disx_n,
         sum(raw_disx_support and currency_t_lag1_match=0) as disx_cur01_mis_n
    from work.target;
quit;

proc freq data=work.raw_common_sample;
  tables currency_t_lag1_match currency_lag1_lag2_match /
         missing;
run;

proc means data=work.target n nmiss;
  var at_lag1 sale sale_lag1 sale_lag2 rect rect_lag1 ibc oancf xidoc
      cogs invt invt_lag1 ppegt xad xrd xsga total_accrual_scaled
      cfo_scaled production_scaled discretionary_scaled;
run;

/* Modified Jones Equation (1); apply the receivables adjustment in Equation (2). */
data work.jones_complete;
  set work.target;
  if nmiss(total_accrual_scaled,inv_atlag,delta_sale_scaled,ppe_scaled)=0;
run;

proc sql;
  create table work.jones_groups as
  select sich2, fyear, count(*) as group_n
  from work.jones_complete
  group by sich2, fyear
  having calculated group_n ge 8;
  create table work.jones_fitpop as
  select a.*
  from work.jones_complete as a inner join work.jones_groups as b
    on a.sich2=b.sich2 and a.fyear=b.fyear;
quit;

proc sort data=work.jones_fitpop;
  by sich2 fyear;
run;

proc reg data=work.jones_fitpop outest=work.jones_est noprint;
  by sich2 fyear;
  model total_accrual_scaled=inv_atlag delta_sale_scaled ppe_scaled / noint;
quit;

data work.jones_coeff;
  set work.jones_est;
  if upcase(_type_)='PARMS';
  keep sich2 fyear inv_atlag delta_sale_scaled ppe_scaled;
  rename inv_atlag=bj_inv
         delta_sale_scaled=bj_sale
         ppe_scaled=bj_ppe;
run;

proc sort data=work.target out=work.target_s;
  by sich2 fyear;
run;
proc sort data=work.jones_coeff;
  by sich2 fyear;
run;

data work.jones_result;
  merge work.target_s(in=in_target) work.jones_coeff;
  by sich2 fyear;
  if in_target;
  if nmiss(bj_inv,bj_sale,bj_ppe,inv_atlag,delta_sale_ar_scaled,ppe_scaled,
           total_accrual_scaled)=0 then do;
    normal_accrual=bj_inv*inv_atlag+bj_sale*delta_sale_ar_scaled+bj_ppe*ppe_scaled;
    da=total_accrual_scaled-normal_accrual;
    abs_da=abs(da);
    if da gt 0 then positive_da=da;
    else positive_da=.;
    if da lt 0 then negative_da=da;
    else negative_da=.;
  end;
run;

/* Normal CFO Equation (4). */
data work.cfo_complete;
  set work.target;
  if nmiss(cfo_scaled,inv_atlag,sale_scaled,delta_sale_scaled)=0;
run;
proc sql;
  create table work.cfo_groups as
  select sich2, fyear, count(*) as group_n
  from work.cfo_complete
  group by sich2, fyear
  having calculated group_n ge 8;
  create table work.cfo_fitpop as
  select a.* from work.cfo_complete as a inner join work.cfo_groups as b
    on a.sich2=b.sich2 and a.fyear=b.fyear;
quit;
proc sort data=work.cfo_fitpop;
  by sich2 fyear;
run;
proc reg data=work.cfo_fitpop outest=work.cfo_est noprint;
  by sich2 fyear;
  model cfo_scaled=inv_atlag sale_scaled delta_sale_scaled / noint;
quit;
data work.cfo_coeff;
  set work.cfo_est;
  if upcase(_type_)='PARMS';
  keep sich2 fyear inv_atlag sale_scaled delta_sale_scaled;
  rename inv_atlag=bcfo_inv sale_scaled=bcfo_sale delta_sale_scaled=bcfo_delta;
run;
proc sort data=work.cfo_coeff;
  by sich2 fyear;
run;
data work.cfo_result;
  merge work.target_s(in=in_target) work.cfo_coeff;
  by sich2 fyear;
  if in_target;
  if nmiss(bcfo_inv,bcfo_sale,bcfo_delta,inv_atlag,sale_scaled,
           delta_sale_scaled,cfo_scaled)=0 then
    r_cfo=cfo_scaled-(bcfo_inv*inv_atlag+bcfo_sale*sale_scaled+
                      bcfo_delta*delta_sale_scaled);
run;

/* Normal production costs Equation (7). */
data work.prod_complete;
  set work.target;
  if nmiss(production_scaled,inv_atlag,sale_scaled,delta_sale_scaled,
           delta_sale_lag_scaled)=0;
run;
proc sql;
  create table work.prod_groups as
  select sich2, fyear, count(*) as group_n
  from work.prod_complete
  group by sich2, fyear
  having calculated group_n ge 8;
  create table work.prod_fitpop as
  select a.* from work.prod_complete as a inner join work.prod_groups as b
    on a.sich2=b.sich2 and a.fyear=b.fyear;
quit;
proc sort data=work.prod_fitpop;
  by sich2 fyear;
run;
proc reg data=work.prod_fitpop outest=work.prod_est noprint;
  by sich2 fyear;
  model production_scaled=inv_atlag sale_scaled delta_sale_scaled
                          delta_sale_lag_scaled / noint;
quit;
data work.prod_coeff;
  set work.prod_est;
  if upcase(_type_)='PARMS';
  keep sich2 fyear inv_atlag sale_scaled delta_sale_scaled delta_sale_lag_scaled;
  rename inv_atlag=bprod_inv sale_scaled=bprod_sale
         delta_sale_scaled=bprod_delta delta_sale_lag_scaled=bprod_lagdelta;
run;
proc sort data=work.prod_coeff;
  by sich2 fyear;
run;
data work.prod_result;
  merge work.target_s(in=in_target) work.prod_coeff;
  by sich2 fyear;
  if in_target;
  if nmiss(bprod_inv,bprod_sale,bprod_delta,bprod_lagdelta,
           inv_atlag,sale_scaled,delta_sale_scaled,
           delta_sale_lag_scaled,production_scaled)=0 then
    r_prod=production_scaled-(bprod_inv*inv_atlag+bprod_sale*sale_scaled+
                              bprod_delta*delta_sale_scaled+
                              bprod_lagdelta*delta_sale_lag_scaled);
run;

/* Normal discretionary expenses Equation (9), using lagged sales. */
data work.disx_complete;
  set work.target;
  if nmiss(discretionary_scaled,inv_atlag,lag_sale_scaled)=0;
run;
proc sql;
  create table work.disx_groups as
  select sich2, fyear, count(*) as group_n
  from work.disx_complete
  group by sich2, fyear
  having calculated group_n ge 8;
  create table work.disx_fitpop as
  select a.* from work.disx_complete as a inner join work.disx_groups as b
    on a.sich2=b.sich2 and a.fyear=b.fyear;
quit;
proc sort data=work.disx_fitpop;
  by sich2 fyear;
run;
proc reg data=work.disx_fitpop outest=work.disx_est noprint;
  by sich2 fyear;
  model discretionary_scaled=inv_atlag lag_sale_scaled / noint;
quit;
data work.disx_coeff;
  set work.disx_est;
  if upcase(_type_)='PARMS';
  keep sich2 fyear inv_atlag lag_sale_scaled;
  rename inv_atlag=bdisx_inv lag_sale_scaled=bdisx_sales;
run;
proc sort data=work.disx_coeff;
  by sich2 fyear;
run;
data work.disx_result;
  merge work.target_s(in=in_target) work.disx_coeff;
  by sich2 fyear;
  if in_target;
  if nmiss(bdisx_inv,bdisx_sales,inv_atlag,lag_sale_scaled,
           discretionary_scaled)=0 then
    r_disx=discretionary_scaled-(bdisx_inv*inv_atlag+bdisx_sales*lag_sale_scaled);
run;

proc sql;
  select sum(group_n) as JonesSupportRows, count(*) as JonesSupportGroups,
         min(group_n) as JonesGroupNMin, max(group_n) as JonesGroupNMax
    from work.jones_groups;
  select sum(group_n) as CFOSupportRows, count(*) as CFOSupportGroups,
         min(group_n) as CFOGroupNMin, max(group_n) as CFOGroupNMax
    from work.cfo_groups;
  select sum(group_n) as ProductionSupportRows, count(*) as ProductionSupportGroups,
         min(group_n) as ProductionGroupNMin, max(group_n) as ProductionGroupNMax
    from work.prod_groups;
  select sum(group_n) as DiscretionaryExpenseSupportRows,
         count(*) as DisxSupportGroups,
         min(group_n) as DiscretionaryExpenseGroupNMin,
         max(group_n) as DiscretionaryExpenseGroupNMax
    from work.disx_groups;
  select count(*) as JonesFitGroups,
         sum(missing(bj_inv) or missing(bj_sale) or missing(bj_ppe)) as JonesIncompleteCoefficientGroups
    from work.jones_coeff;
  select count(*) as CFOFitGroups,
         sum(missing(bcfo_inv) or missing(bcfo_sale) or missing(bcfo_delta)) as CFOIncompleteCoefficientGroups
    from work.cfo_coeff;
  select count(*) as ProductionFitGroups,
         sum(missing(bprod_inv) or missing(bprod_sale) or missing(bprod_delta) or
             missing(bprod_lagdelta)) as ProdIncompleteCoeffGroups
    from work.prod_coeff;
  select count(*) as DiscretionaryExpenseFitGroups,
         sum(missing(bdisx_inv) or missing(bdisx_sales)) as DisxIncompleteCoeffGroups
    from work.disx_coeff;
quit;

/* Combine all outcomes on one common full-sample support. */
proc sort data=work.jones_result(keep=gvkey fyear sich2 time sca sox da abs_da positive_da negative_da
                                      at_lag1 curcd curcd_lag1 curcd_lag2 fic
                                      currency_t_lag1_match currency_lag1_lag2_match)
          out=work.jones_results;
  by gvkey fyear;
run;
proc sort data=work.cfo_result(keep=gvkey fyear r_cfo) out=work.cfo_results;
  by gvkey fyear;
run;
proc sort data=work.prod_result(keep=gvkey fyear r_prod) out=work.prod_results;
  by gvkey fyear;
run;
proc sort data=work.disx_result(keep=gvkey fyear r_disx) out=work.disx_results;
  by gvkey fyear;
run;

data work.all_metrics;
  merge work.jones_results(in=has_jones)
        work.cfo_results(in=has_cfo)
        work.prod_results(in=has_prod)
        work.disx_results(in=has_disx);
  by gvkey fyear;
  if has_jones and has_cfo and has_prod and has_disx;
run;

proc means data=work.all_metrics n nmiss;
  var da abs_da positive_da negative_da r_cfo r_prod r_disx;
run;

data work.metrics_complete;
  set work.all_metrics;
  if nmiss(da,abs_da,r_cfo,r_prod,r_disx)=0;
run;

proc sql;
  create table work.common_groups as
  select sich2, fyear, count(*) as group_n
  from work.metrics_complete
  group by sich2, fyear
  having calculated group_n ge 8;
  create table work.common_sample as
  select a.* from work.metrics_complete as a inner join work.common_groups as b
    on a.sich2=b.sich2 and a.fyear=b.fyear;
quit;

/* Aggregate diagnostics for currency continuity, denominator support and tail influence.
   These summarize the untrimmed common sample and do not change eligibility. */
proc means data=work.common_sample noprint;
  var r_cfo r_prod r_disx;
  output out=work.rm_standardization
    mean=mean_cfo mean_prod mean_disx
    std=sd_cfo sd_prod sd_disx;
run;

data work.common_diagnostics;
  if _n_=1 then set work.rm_standardization;
  set work.common_sample;
  currency_transition=(currency_t_lag1_match=0);
  currency_lag1_lag2_transition=(currency_lag1_lag2_match=0);
  small_asset=(at_lag1 lt 1);
  abs_r_cfo=abs(r_cfo);
  abs_r_prod=abs(r_prod);
  abs_r_disx=abs(r_disx);
  z_cfo=(r_cfo-mean_cfo)/sd_cfo;
  z_prod=(r_prod-mean_prod)/sd_prod;
  z_disx=(r_disx-mean_disx)/sd_disx;
  rm_proxy=z_cfo+z_prod+z_disx;
  abs_rm=abs(rm_proxy);
run;

proc freq data=work.common_diagnostics;
  tables curcd curcd_lag1 curcd_lag2 fic currency_transition currency_lag1_lag2_transition
         curcd*curcd_lag1 curcd_lag1*curcd_lag2 / missing;
run;

proc means data=work.common_diagnostics n nmiss mean std min p1 p25 median p75 p90 p95 p99 max maxdec=5;
  var at_lag1 abs_da r_cfo r_prod r_disx rm_proxy;
run;

proc means data=work.common_diagnostics n mean std min p50 p90 p99 max maxdec=5;
  class fyear;
  var abs_da r_cfo r_prod r_disx rm_proxy;
run;

proc means data=work.common_diagnostics n mean std min p50 p90 p99 max maxdec=5;
  class currency_transition;
  var at_lag1 abs_da r_cfo r_prod r_disx rm_proxy;
run;

proc means data=work.common_diagnostics n mean std min p50 p90 p99 max maxdec=5;
  class small_asset;
  var at_lag1 abs_da r_cfo r_prod r_disx rm_proxy;
run;

proc sql;
  select count(*) as CommonSampleN,
         sum(missing(at_lag1)) as MissingPriorAssets,
         sum(at_lag1 le 0) as NonpositivePriorAssets,
         sum(at_lag1 gt 0 and at_lag1 lt 1) as PriorAssetsBelowOneUnit,
         sum(at_lag1 ge 1 and at_lag1 lt 10) as PriorAssetsOneToTenUnits,
         sum(currency_transition=1) as CurrencyTransitions
    from work.common_diagnostics;
quit;

proc rank data=work.common_diagnostics out=work.tail_rank groups=100;
  var abs_da abs_r_cfo abs_r_prod abs_r_disx abs_rm;
  ranks q_abs_da q_abs_cfo q_abs_prod q_abs_disx q_abs_rm;
run;

proc sql;
  create table work.tail_influence as
  select 'ABS DA' as outcome length=12, count(*) as sample_n,
         sum(q_abs_da=99) as upper_bucket_n,
         sum(case when q_abs_da=99 then abs_da else 0 end)/sum(abs_da) as upper_bucket_abs_share,
         sum(case when q_abs_da=99 then abs_da*abs_da else 0 end)/sum(abs_da*abs_da) as upper_bucket_sq_share
    from work.tail_rank
  union all
  select 'R CFO', count(*), sum(q_abs_cfo=99),
         sum(case when q_abs_cfo=99 then abs_r_cfo else 0 end)/sum(abs_r_cfo),
         sum(case when q_abs_cfo=99 then abs_r_cfo*abs_r_cfo else 0 end)/sum(abs_r_cfo*abs_r_cfo)
    from work.tail_rank
  union all
  select 'R PROD', count(*), sum(q_abs_prod=99),
         sum(case when q_abs_prod=99 then abs_r_prod else 0 end)/sum(abs_r_prod),
         sum(case when q_abs_prod=99 then abs_r_prod*abs_r_prod else 0 end)/sum(abs_r_prod*abs_r_prod)
    from work.tail_rank
  union all
  select 'R DISX', count(*), sum(q_abs_disx=99),
         sum(case when q_abs_disx=99 then abs_r_disx else 0 end)/sum(abs_r_disx),
         sum(case when q_abs_disx=99 then abs_r_disx*abs_r_disx else 0 end)/sum(abs_r_disx*abs_r_disx)
    from work.tail_rank
  union all
  select 'RM PROXY', count(*), sum(q_abs_rm=99),
         sum(case when q_abs_rm=99 then abs_rm else 0 end)/sum(abs_rm),
         sum(case when q_abs_rm=99 then abs_rm*abs_rm else 0 end)/sum(abs_rm*abs_rm)
    from work.tail_rank;
  select * from work.tail_influence;
quit;

proc sql;
  create table work.final_key_duplicates as
  select gvkey, fyear, count(*) as key_n
  from work.common_sample
  group by gvkey, fyear
  having calculated key_n gt 1;
  select count(*) as FinalDuplicateKeyCount from work.final_key_duplicates;
quit;

data out.compustat_earnings_mgmt_panel;
  if _n_=1 then set work.rm_standardization;
  set work.common_sample;
  if nmiss(sd_cfo,sd_prod,sd_disx)=0 and sd_cfo gt 0 and sd_prod gt 0 and sd_disx gt 0;
  z_cfo=(r_cfo-mean_cfo)/sd_cfo;
  z_prod=(r_prod-mean_prod)/sd_prod;
  z_disx=(r_disx-mean_disx)/sd_disx;
  rm_proxy=z_cfo+z_prod+z_disx;
  label gvkey='Global Company Key'
        fyear='Fiscal Year'
        time='Time (Fiscal Year minus 1987)'
        sca='Scandal Period (2000-2001)'
        sox='Post-SOX Period (2002-2005)'
        da='Discretionary Accruals'
        abs_da='Absolute Discretionary Accruals'
        positive_da='Positive Discretionary Accruals'
        negative_da='Negative Discretionary Accruals'
        r_prod='Abnormal Production Costs'
        r_cfo='Abnormal Cash Flow from Operations'
        r_disx='Abnormal Discretionary Expenses'
        rm_proxy='Combined Standardized Real Earnings Management Proxy';
  keep gvkey fyear sich2 time sca sox da abs_da positive_da negative_da
       r_prod r_cfo r_disx rm_proxy;
run;

proc sql;
  select count(*) as FinalFirmYears,
         count(distinct gvkey) as FinalFirms,
         min(fyear) as FirstFiscalYear,
         max(fyear) as LastFiscalYear
    from out.compustat_earnings_mgmt_panel;
  select count(*) as FinalSICYearCells,
         min(group_n) as MinFinalSICYearN,
         max(group_n) as MaxFinalSICYearN
    from work.common_groups;
  select count(*) as JonesGroups from work.jones_coeff;
  select count(*) as CFOGroups from work.cfo_coeff;
  select count(*) as ProductionGroups from work.prod_coeff;
  select count(*) as DiscretionaryExpenseGroups from work.disx_coeff;
quit;

proc means data=out.compustat_earnings_mgmt_panel n nmiss mean std p25 median p75;
  var da abs_da positive_da negative_da r_cfo r_prod r_disx rm_proxy;
run;

proc contents data=out.compustat_earnings_mgmt_panel varnum;
run;
