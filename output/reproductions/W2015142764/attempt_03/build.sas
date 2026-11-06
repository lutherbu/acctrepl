options errorabend nodate nonumber mprint mlogic symbolgen;

/* Read-only sources listed in the assigned catalog. */
libname comp ("/storage/sas/base/comp/d_na"
              "/storage/sas/base/comp/d_global/currency") access=readonly;
libname crsp "/storage/sas/base/crsp/a_stock" access=readonly;
libname ccm "/storage/sas/base/crsp/a_ccm" access=readonly;
libname ff "/storage/sas/base/ff" access=readonly;
libname ibes "/storage/sas/base/ibes" access=readonly;
libname iclink "/storage/sas/base/wrdsapps/linking/iclink" access=readonly;
libname ratio "/storage/sas/base/wrdsapps/finratio/fr" access=readonly;
libname tfn "/storage/sas/base/tfn/s34" access=readonly;
libname ddout "data/dd_firm_years";
libname about "data/abacc_firm_years";

/* Annual North America industrial Compustat. The output is one firm-year;
   if a fiscal year has duplicate records, retain its latest DATADATE/FDATE. */
data comp0;
  set comp.funda(keep=gvkey datadate fyear fdate curcd indfmt consol popsrc datafmt
                      act lct che dlc ib dp sale rect ppegt at dltt lt);
  where indfmt='INDL' and consol='C' and popsrc='D' and datafmt='STD';
  if 1956 <= fyear <= 2002 and not missing(gvkey) and not missing(datadate);
run;

proc sql;
  create table comp_dups as
  select gvkey, fyear, count(*) as n
  from comp0
  group by gvkey, fyear
  having count(*) > 1;
  select count(*) as duplicate_gvkey_fyear_groups from comp_dups;
quit;

proc sort data=comp0;
  by gvkey fyear datadate fdate;
run;
data comp_one;
  set comp0;
  by gvkey fyear;
  if last.fyear;
run;

/* Translate each selected annual row to USD with same-date Xpressfeed GBP
   cross-rates. EXRATTPD is retained as provenance, not a validity screen. */
data fx_mth_pos;
  set comp.g_exrt_mth(keep=datadate tocurm fromcurm exrat12m);
  where datadate between '01JAN1956'd and '31DEC2002'd and fromcurm='GBP';
  if not missing(tocurm) and exrat12m > 0;
run;
proc sort data=fx_mth_pos; by datadate tocurm; run;
data fx_mth;
  set fx_mth_pos;
  by datadate tocurm;
  retain npositive rate;
  if first.tocurm then do; npositive=0; rate=.; end;
  npositive+1;
  rate=exrat12m;
  if last.tocurm then do;
    exrat12m_unique=.;
    if npositive=1 then exrat12m_unique=rate;
    output;
  end;
  keep datadate tocurm exrat12m_unique npositive;
run;

data fx_dly_pos;
  set comp.g_exrt_dly(keep=datadate tocurd fromcurd exratd exrattpd);
  where datadate between '01JAN1956'd and '31DEC2002'd and fromcurd='GBP';
  if not missing(tocurd) and exratd > 0;
run;
proc sort data=fx_dly_pos; by datadate tocurd; run;
data fx_dly;
  length exrattpd_unique typehold $3;
  set fx_dly_pos;
  by datadate tocurd;
  retain npositive rate typehold;
  if first.tocurd then do;
    npositive=0;
    rate=.;
    call missing(typehold);
  end;
  npositive+1;
  rate=exratd;
  typehold=exrattpd;
  if last.tocurd then do;
    exratd_unique=.;
    call missing(exrattpd_unique);
    if npositive=1 then do;
      exratd_unique=rate;
      exrattpd_unique=typehold;
    end;
    output;
  end;
  keep datadate tocurd exratd_unique exrattpd_unique npositive;
run;

proc sql;
  select count(*) as positive_monthly_fx_keys,
         sum(npositive > 1) as dup_mth_fx_keys
  from fx_mth;
  select count(*) as positive_daily_fx_keys,
         sum(npositive > 1) as dup_day_fx_keys
  from fx_dly;
  create table comp_fx as
  select a.*,
         mcur.exrat12m_unique as rate_flow_cur,
         musd.exrat12m_unique as rate_flow_usd,
         dcur.exratd_unique as rate_stock_cur,
         dcur.exrattpd_unique as type_stock_cur,
         dcur.npositive as stock_cur_npositive,
         dusd.exratd_unique as rate_stock_usd,
         dusd.exrattpd_unique as type_stock_usd,
         dusd.npositive as stock_usd_npositive
  from comp_one as a
  left join fx_mth as mcur
    on a.datadate=mcur.datadate and upcase(a.curcd)=mcur.tocurm
  left join fx_mth as musd
    on a.datadate=musd.datadate and musd.tocurm='USD'
  left join fx_dly as dcur
    on a.datadate=dcur.datadate and upcase(a.curcd)=dcur.tocurd
  left join fx_dly as dusd
    on a.datadate=dusd.datadate and dusd.tocurd='USD';
quit;
data comp_fx;
  set comp_fx;
  if upcase(curcd)='USD' then do;
    flow_fx=1;
    stock_fx=1;
  end;
  else if upcase(curcd)='GBP' then do;
    if rate_flow_usd > 0 then flow_fx=rate_flow_usd;
    else flow_fx=.;
    if rate_stock_usd > 0 then stock_fx=rate_stock_usd;
    else stock_fx=.;
  end;
  else do;
    if rate_flow_cur > 0 and rate_flow_usd > 0 then
      flow_fx=rate_flow_usd/rate_flow_cur;
    else flow_fx=.;
    if rate_stock_cur > 0 and rate_stock_usd > 0 then
      stock_fx=rate_stock_usd/rate_stock_cur;
    else stock_fx=.;
  end;
  array stock[9] act lct che dlc rect ppegt at dltt lt;
  array stockusd[9] act_usd lct_usd che_usd dlc_usd rect_usd
                    ppegt_usd at_usd dltt_usd lt_usd;
  array flow[3] ib dp sale;
  array flowusd[3] ib_usd dp_usd sale_usd;
  do j=1 to dim(stock);
    if not missing(stock[j]) and not missing(stock_fx) then
      stockusd[j]=stock[j]*stock_fx;
    else stockusd[j]=.;
  end;
  do j=1 to dim(flow);
    if not missing(flow[j]) and not missing(flow_fx) then
      flowusd[j]=flow[j]*flow_fx;
    else flowusd[j]=.;
  end;
  drop j;
  label flow_fx="USD per source currency, same-date 12-month rate"
        stock_fx="USD per source currency, same-date daily rate"
        act_usd="Current assets, USD millions"
        lct_usd="Current liabilities, USD millions"
        che_usd="Cash, USD millions"
        dlc_usd="Current debt, USD millions"
        ib_usd="Income before extraordinary items, USD millions"
        dp_usd="Depreciation and amortization, USD millions"
        sale_usd="Sales, USD millions"
        rect_usd="Receivables, USD millions"
        ppegt_usd="Gross PPE, USD millions"
        at_usd="Assets, USD millions"
        dltt_usd="Long-term debt, USD millions"
        lt_usd="Total liabilities, USD millions";
run;
proc sql;
  select year(datadate) as datayear, curcd, count(*) as selected_firm_years,
         sum(missing(flow_fx)) as missing_flow_conversions,
         sum(missing(stock_fx)) as missing_stock_conversions,
         sum(not missing(type_stock_cur)) as source_daily_type_recorded,
         sum(not missing(type_stock_usd)) as usd_daily_type_recorded
  from comp_fx group by calculated datayear, curcd
  order by calculated datayear, curcd;
  select sum(fyear < 1982 and upcase(curcd) ne 'USD'
             and missing(flow_fx)) as fx_flow_miss_pre82,
         sum(fyear < 1982 and upcase(curcd) ne 'USD'
             and missing(stock_fx)) as fx_stock_miss_pre82,
         sum(fyear >= 1982 and upcase(curcd) ne 'USD'
             and missing(flow_fx)) as fx_flow_miss_post82,
         sum(fyear >= 1982 and upcase(curcd) ne 'USD'
             and missing(stock_fx)) as fx_stock_miss_post82
  from comp_fx;
quit;

/* FFI49 is a documented catalog field on the WRDS financial-ratio table.
   For repeated security records at one GVKEY/date, lowest PERMNO wins. */
data ff49raw;
  set ratio.firm_ratio(keep=gvkey permno adate ffi49);
  if 1956 <= year(adate) <= 2002 and not missing(ffi49);
run;
proc sort data=ff49raw;
  by gvkey adate permno;
run;
data ff49one;
  set ff49raw;
  by gvkey adate;
  if first.adate;
  fyear=year(adate);
  keep gvkey adate fyear ffi49;
run;

/* Keyed adjacent-year join keeps missing years as gaps. */
proc sql;
  create table comp_pair as
  select a.gvkey, a.fyear, a.datadate, a.fdate, a.curcd,
         a.flow_fx, a.stock_fx, a.type_stock_cur, a.type_stock_usd,
         b.datadate as prevdate,
         a.act_usd, b.act_usd as act_usd_lag,
         a.lct_usd, b.lct_usd as lct_usd_lag,
         a.che_usd, b.che_usd as che_usd_lag,
         a.dlc_usd, b.dlc_usd as dlc_usd_lag,
         a.ib_usd, a.dp_usd, a.sale_usd, b.sale_usd as sale_usd_lag,
         a.rect_usd, b.rect_usd as rect_usd_lag,
         a.ppegt_usd, a.at_usd, b.at_usd as at_usd_lag,
         a.dltt_usd, a.lt_usd
  from comp_fx as a
  left join comp_fx as b
    on a.gvkey=b.gvkey and a.fyear=b.fyear+1;
quit;

data comp_core0;
  set comp_pair;
  if nmiss(act_usd,act_usd_lag,lct_usd,lct_usd_lag,che_usd,che_usd_lag,
            dlc_usd,dlc_usd_lag)=0 then
    tca=(act_usd-act_usd_lag)-(lct_usd-lct_usd_lag)
        -(che_usd-che_usd_lag)+(dlc_usd-dlc_usd_lag);
  else tca=.;
  if nmiss(at_usd,at_usd_lag)=0 then avgasset=(at_usd+at_usd_lag)/2;
  else avgasset=.;
  if nmiss(ib_usd,tca,dp_usd)=0 then cfo=ib_usd-tca+dp_usd;
  else cfo=.;
  if nmiss(tca,dp_usd)=0 then ta=tca-dp_usd;
  else ta=.;
  if nmiss(sale_usd,sale_usd_lag)=0 then drev=sale_usd-sale_usd_lag;
  else drev=.;
  if nmiss(rect_usd,rect_usd_lag)=0 then dar=rect_usd-rect_usd_lag;
  else dar=.;
  if avgasset ne 0 and not missing(avgasset) then do;
    tca_scaled=tca/avgasset;
    ta_scaled=ta/avgasset;
    invasset=1/avgasset;
    cfo_scaled=cfo/avgasset;
    if at_usd ne 0 and not missing(at_usd) then cfo_at=cfo/at_usd;
    else cfo_at=.;
    drev_scaled=drev/avgasset;
    dar_scaled=dar/avgasset;
    ppe_scaled=ppegt_usd/avgasset;
    roa=ib_usd/avgasset;
  end;
  else call missing(tca_scaled,ta_scaled,invasset,cfo_scaled,cfo_at,
                    drev_scaled,dar_scaled,ppe_scaled,roa);
  if at_usd ne 0 and not missing(at_usd) then lev=(dltt_usd+dlc_usd)/at_usd;
  else lev=.;
  label tca_scaled="TCA / average assets"
        ta_scaled="TA / average assets"
        invasset="1 / average assets"
        cfo_scaled="CFO / average assets"
        cfo_at="CFO / total assets"
        drev_scaled="Change in sales / average assets"
        dar_scaled="Change in receivables / average assets"
        ppe_scaled="Gross PPE / average assets"
        roa="IB / average assets"
        lev="Long-term plus current debt / assets";
run;

proc sql;
  create table comp_core as
  select a.*, b.ffi49
  from comp_core0 as a
  left join ff49one as b
    on a.gvkey=b.gvkey and a.datadate=b.adate;
  select count(*) as compustat_firm_years,
         sum(missing(ffi49)) as missing_ffi49
  from comp_core;
quit;

/* Eq. (1a) support population, with CFO at t-1/t/t+1 scaled by the
   same average assets for t, as in the displayed equation. */
proc sql;
  create table dd_fit0 as
  select a.gvkey, a.fyear, a.ffi49, a.tca_scaled, a.invasset,
         b.cfo/a.avgasset as cfom1,
         a.cfo/a.avgasset as cfo0,
         c.cfo/a.avgasset as cfop1,
         a.drev_scaled as drev, a.ppe_scaled as ppe
  from comp_core as a
  inner join comp_core as b
    on a.gvkey=b.gvkey and b.fyear=a.fyear-1
  inner join comp_core as c
    on a.gvkey=c.gvkey and c.fyear=a.fyear+1
  where 1957 <= a.fyear <= 2001 and not missing(a.ffi49)
    and a.avgasset ne 0
    and nmiss(a.tca_scaled,a.invasset,a.avgasset,b.cfo,c.cfo,
              a.cfo,a.drev_scaled,a.ppe_scaled)=0;
quit;
proc sql;
  create table dd_groups as
  select fyear, ffi49, count(*) as n
  from dd_fit0 group by fyear, ffi49
  having count(*) >= 20;
  select count(*) as eligible_dd_industry_year_fits,
         sum(n) as dd_support_rows
  from dd_groups;
quit;
proc sort data=dd_fit0; by fyear ffi49; run;
proc sort data=dd_groups; by fyear ffi49; run;
data dd_fit_eligible;
  merge dd_fit0(in=a) dd_groups(in=b);
  by fyear ffi49;
  if a and b;
run;
proc univariate data=dd_fit_eligible noprint;
  by fyear ffi49;
  var tca_scaled invasset cfom1 cfo0 cfop1 drev ppe;
  output out=dd_cuts pctlpts=1 99
         pctlpre=TCA_ INV_ CFOM1_ CFO0_ CFOP1_ DREV_ PPE_
         pctlname=LO HI;
run;
proc sort data=dd_fit_eligible; by fyear ffi49; run;
proc sort data=dd_cuts; by fyear ffi49; run;
data dd_fit_winsor;
  merge dd_fit_eligible(in=a) dd_cuts;
  by fyear ffi49;
  if a;
  array x[7] tca_scaled invasset cfom1 cfo0 cfop1 drev ppe;
  array lo[7] TCA_LO INV_LO CFOM1_LO CFO0_LO CFOP1_LO DREV_LO PPE_LO;
  array hi[7] TCA_HI INV_HI CFOM1_HI CFO0_HI CFOP1_HI DREV_HI PPE_HI;
  do j=1 to dim(x);
    if not missing(x[j]) then do;
      if x[j] < lo[j] then x[j]=lo[j];
      if x[j] > hi[j] then x[j]=hi[j];
    end;
  end;
  drop j TCA_LO TCA_HI INV_LO INV_HI CFOM1_LO CFOM1_HI
         CFO0_LO CFO0_HI CFOP1_LO CFOP1_HI DREV_LO DREV_HI PPE_LO PPE_HI;
run;
proc sort data=dd_fit_winsor; by fyear ffi49 gvkey; run;
proc sql;
  create table dd_fit_n as
  select fyear, ffi49, count(*) as nobs
  from dd_fit_winsor group by fyear, ffi49;
quit;
proc reg data=dd_fit_winsor outest=dd_fit_est edf noprint;
  by fyear ffi49;
  model tca_scaled = invasset cfom1 cfo0 cfop1 drev ppe / noint;
  output out=dd_resid r=ddresid;
run;
quit;
proc sql;
  create table dd_fit_rank as
  select n.fyear, n.ffi49, n.nobs, e._edf_ as residual_df,
         n.nobs-e._edf_ as model_rank,
         (n.nobs-e._edf_=6) as full_rank
  from dd_fit_n as n left join dd_fit_est as e
    on n.fyear=e.fyear and n.ffi49=e.ffi49 and e._type_='PARMS';
  select count(*) as eligible_dd_fits,
         sum(full_rank=1) as full_rank_dd_fits,
         sum(full_rank ne 1) as unavailable_dd_fits,
         sum(missing(model_rank)) as dd_fits_without_rank_output
  from dd_fit_rank;
  select fyear, count(*) as eligible_dd_fits,
         sum(full_rank=1) as full_rank_dd_fits,
         sum(full_rank ne 1) as unavailable_dd_fits
  from dd_fit_rank group by fyear order by fyear;
quit;
proc sort data=dd_resid; by fyear ffi49; run;
proc sort data=dd_fit_rank; by fyear ffi49; run;
data dd_resid;
  merge dd_resid(in=a) dd_fit_rank(keep=fyear ffi49 full_rank);
  by fyear ffi49;
  if a;
  if full_rank ne 1 then ddresid=.;
  drop full_rank;
run;
proc sql;
  select count(*) as dd_residual_rows,
         sum(missing(ddresid)) as missing_dd_residuals
  from dd_resid;
quit;

/* Eq. (2) support population and abnormal-accrual residual. */
proc sql;
  create table ab_fit0 as
  select gvkey, fyear, ffi49, ta_scaled, invasset,
         (drev_scaled-dar_scaled) as drevar_scaled,
         ppe_scaled, roa
  from comp_core
  where 1957 <= fyear <= 2001 and not missing(ffi49) and avgasset ne 0
    and nmiss(ta_scaled,invasset,drev_scaled,dar_scaled,ppe_scaled,roa)=0;
quit;
proc sql;
  create table ab_groups as
  select fyear, ffi49, count(*) as n
  from ab_fit0 group by fyear, ffi49
  having count(*) >= 20;
  select count(*) as eligible_abacc_fits,
         sum(n) as abacc_support_rows
  from ab_groups;
quit;
proc sort data=ab_fit0; by fyear ffi49; run;
proc sort data=ab_groups; by fyear ffi49; run;
data ab_fit_eligible;
  merge ab_fit0(in=a) ab_groups(in=b);
  by fyear ffi49;
  if a and b;
run;
proc univariate data=ab_fit_eligible noprint;
  by fyear ffi49;
  var ta_scaled invasset drevar_scaled ppe_scaled roa;
  output out=ab_cuts pctlpts=1 99
         pctlpre=TA_ INV_ DREV_ PPE_ ROA_
         pctlname=LO HI;
run;
proc sort data=ab_fit_eligible; by fyear ffi49; run;
proc sort data=ab_cuts; by fyear ffi49; run;
data ab_fit_winsor;
  merge ab_fit_eligible(in=a) ab_cuts;
  by fyear ffi49;
  if a;
  array x[5] ta_scaled invasset drevar_scaled ppe_scaled roa;
  array lo[5] TA_LO INV_LO DREV_LO PPE_LO ROA_LO;
  array hi[5] TA_HI INV_HI DREV_HI PPE_HI ROA_HI;
  do j=1 to dim(x);
    if not missing(x[j]) then do;
      if x[j] < lo[j] then x[j]=lo[j];
      if x[j] > hi[j] then x[j]=hi[j];
    end;
  end;
  drop j TA_LO TA_HI INV_LO INV_HI DREV_LO DREV_HI
         PPE_LO PPE_HI ROA_LO ROA_HI;
run;
proc sort data=ab_fit_winsor; by fyear ffi49 gvkey; run;
proc sql;
  create table ab_fit_n as
  select fyear, ffi49, count(*) as nobs
  from ab_fit_winsor group by fyear, ffi49;
quit;
proc reg data=ab_fit_winsor outest=ab_fit_est edf noprint;
  by fyear ffi49;
  model ta_scaled = invasset drevar_scaled ppe_scaled roa / noint;
  output out=ab_resid r=abresid;
run;
quit;
proc sql;
  create table ab_fit_rank as
  select n.fyear, n.ffi49, n.nobs, e._edf_ as residual_df,
         n.nobs-e._edf_ as model_rank,
         (n.nobs-e._edf_=4) as full_rank
  from ab_fit_n as n left join ab_fit_est as e
    on n.fyear=e.fyear and n.ffi49=e.ffi49 and e._type_='PARMS';
  select count(*) as eligible_abacc_fits,
         sum(full_rank=1) as full_rank_abacc_fits,
         sum(full_rank ne 1) as unavailable_abacc_fits,
         sum(missing(model_rank)) as abacc_fits_without_rank_output
  from ab_fit_rank;
  select fyear, count(*) as eligible_abacc_fits,
         sum(full_rank=1) as full_rank_abacc_fits,
         sum(full_rank ne 1) as unavailable_abacc_fits
  from ab_fit_rank group by fyear order by fyear;
quit;
proc sort data=ab_resid; by fyear ffi49; run;
proc sort data=ab_fit_rank; by fyear ffi49; run;
data ab_resid;
  merge ab_resid(in=a) ab_fit_rank(keep=fyear ffi49 full_rank);
  by fyear ffi49;
  if a;
  if full_rank ne 1 then abresid=.;
  drop full_rank;
run;
proc sql;
  select count(*) as abacc_residual_rows,
         sum(missing(abresid)) as missing_abacc_residuals
  from ab_resid;
quit;

/* Effective-dated Compustat/CRSP links. Prefer primary LC links, then
   deterministic PERMNO order where the source does not report a tie-break. */
proc sql;
  create table link_candidates as
  select a.*, b.lpermno as permno, b.linkprim, b.linktype,
         (b.linkprim='P') as prim_rank,
         (b.linktype='LC') as type_rank
  from comp_core as a
  inner join ccm.ccmxpf_linktable as b
    on a.gvkey=b.gvkey
   and b.linkdt <= a.datadate
   and (missing(b.linkenddt) or b.linkenddt >= a.datadate)
  where b.linkprim in ('P','C') and b.linktype in ('LC','LU')
    and not missing(b.lpermno);
quit;
proc sort data=link_candidates;
  by gvkey fyear descending prim_rank descending type_rank permno;
run;
data perm_year;
  set link_candidates;
  by gvkey fyear;
  if first.fyear;
  drop prim_rank type_rank;
run;
proc sql;
  select count(*) as linked_firm_years,
         count(distinct gvkey) as linked_firms
  from perm_year;
quit;

/* Common-stock daily CRSP returns matched to the three daily FF factors. */
data crsp_names;
  set crsp.dsenames(keep=permno permco namedt nameendt shrcd exchcd ncusip);
run;
data crsp_dsf;
  set crsp.dsf(keep=permno permco date ret prc shrout);
  if '01JAN1961'd <= date <= '31DEC2002'd;
run;
proc sql;
  create table crsp_all as
  select d.permno, n.permco, d.permco as dsf_permco,
         d.date, d.ret, d.prc, d.shrout,
         n.shrcd, n.exchcd, n.ncusip,
         f.mktrf, f.smb, f.hml
  from crsp_dsf as d
  inner join crsp_names as n
    on d.permno=n.permno and n.namedt <= d.date
   and (missing(n.nameendt) or n.nameendt >= d.date)
  inner join ff.factors_daily as f
    on d.date=f.date
  where n.shrcd in (10,11) and n.exchcd in (1,2,3);
quit;
proc sql;
  create table crsp_daily_dups as
  select permno, date, count(*) as n
  from crsp_all group by permno, date having count(*) > 1;
  select count(*) as duplicate_permno_date_groups from crsp_daily_dups;
  select sum(not missing(permco) and not missing(dsf_permco)
             and permco ne dsf_permco) as name_dsf_permco_mismatches
  from crsp_all;
quit;
data crsp_fit;
  set crsp_all;
  if nmiss(ret,mktrf,smb,hml)=0;
  monend=intnx('month',date,0,'end');
run;
proc sort data=crsp_fit; by permno date; run;
proc sql;
  create table crsp_fit_n as
  select permno, count(*) as nobs
  from crsp_fit group by permno;
quit;
proc reg data=crsp_fit outest=crsp_fit_est edf noprint;
  by permno;
  model ret = mktrf smb hml;
  output out=crsp_resid r=ffresid;
run;
quit;
proc sql;
  create table crsp_fit_rank as
  select n.permno, n.nobs, e._edf_ as residual_df,
         n.nobs-e._edf_ as model_rank,
         (n.nobs-e._edf_=4) as full_rank
  from crsp_fit_n as n left join crsp_fit_est as e
    on n.permno=e.permno and e._type_='PARMS';
  select count(*) as daily_factor_firms,
         sum(full_rank=1) as full_rank_daily_factor_firms,
         sum(full_rank ne 1) as unavailable_daily_factor_firms,
         sum(missing(model_rank)) as daily_fits_without_rank_output
  from crsp_fit_rank;
quit;
proc sort data=crsp_resid; by permno; run;
proc sort data=crsp_fit_rank; by permno; run;
data crsp_resid;
  merge crsp_resid(in=a) crsp_fit_rank(keep=permno full_rank);
  by permno;
  if a;
  if full_rank ne 1 then ffresid=.;
  drop full_rank;
run;
data crsp_resid;
  set crsp_resid;
  monend=intnx('month',date,0,'end');
run;
proc sort data=crsp_resid; by permno monend date; run;
proc means data=crsp_resid noprint;
  by permno monend;
  var ffresid;
  output out=month_var(drop=_type_ _freq_) n=ndays var=month_var;
run;
data month_var;
  set month_var;
  if ndays >= 2 and not missing(month_var);
  annualized_month_var=month_var*ndays;
run;

/* Fiscal-year volatility: average of monthly sample variances times the
   observed daily trading count, requiring at least nine valid months. */
proc sql;
  create table fiscal_months as
  select p.gvkey, p.fyear, v.monend, v.annualized_month_var
  from perm_year as p
  inner join month_var as v
    on p.permno=v.permno
   and v.monend > intnx('month',p.prevdate,0,'end')
   and v.monend <= intnx('month',p.datadate,0,'end');
quit;
proc sort data=fiscal_months; by gvkey fyear; run;
proc means data=fiscal_months noprint;
  by gvkey fyear;
  var annualized_month_var;
  output out=var_annual(drop=_type_ _freq_) n=nmonths mean=var_ffadj;
run;
data var_annual;
  set var_annual;
  if nmonths >= 9;
  label var_ffadj="Average fiscal-year monthly variance of FF3-adjusted returns";
run;

/* Fiscal-year buy-and-hold return: daily CRSP RET compounds between the
   preceding and current DATADATE. */
proc sql;
  create table ret_daily as
  select p.gvkey, p.fyear, d.date, d.ret
  from perm_year as p
  inner join crsp_all as d
    on p.permno=d.permno and d.date > p.prevdate
   and d.date <= p.datadate and not missing(d.ret);
quit;
proc sort data=ret_daily; by gvkey fyear date; run;
data ret_annual;
  set ret_daily;
  by gvkey fyear;
  retain retprod nret;
  if first.fyear then do; retprod=1; nret=0; end;
  retprod=retprod*(1+ret);
  nret+1;
  if last.fyear then do;
    ret=retprod-1;
    output;
  end;
  keep gvkey fyear ret nret;
  label ret="Annual buy-and-hold return";
run;

/* Company market equity: use an effective CCM PERMCO mapping three months
   after fiscal year end, then sum all mapped common issues on one quote date. */
proc sql;
  create table mve_links as
  select distinct a.gvkey, a.fyear, a.datadate,
         intnx('month',a.datadate,3,'same') as mvedate format=date9.,
         b.lpermco as permco
  from comp_core as a
  inner join ccm.ccmxpf_linktable as b
    on a.gvkey=b.gvkey
   and b.linkdt <= intnx('month',a.datadate,3,'same')
   and (missing(b.linkenddt)
        or b.linkenddt >= intnx('month',a.datadate,3,'same'))
  where b.linkprim in ('P','C') and b.linktype in ('LC','LU')
    and not missing(b.lpermco);
  create table mve_link_stats0 as
  select a.gvkey, a.fyear, a.datadate,
         intnx('month',a.datadate,3,'same') as mvedate format=date9.,
         count(distinct b.permco) as npermco,
         min(b.permco) as permco
  from comp_core as a
  left join mve_links as b
    on a.gvkey=b.gvkey and a.fyear=b.fyear and a.datadate=b.datadate
  group by a.gvkey, a.fyear, a.datadate;
  create table mve_permco_gvkeys as
  select mvedate, permco, count(distinct gvkey) as ngvkey
  from mve_links group by mvedate, permco;
  create table mve_link_stats as
  select a.*, b.ngvkey
  from mve_link_stats0 as a
  left join mve_permco_gvkeys as b
    on a.mvedate=b.mvedate and a.permco=b.permco;
  select count(*) as company_mapping_firm_years,
         sum(npermco=0) as no_effective_permco,
         sum(npermco>1) as multiple_effective_permcos,
         sum(npermco=1 and ngvkey>1) as permco_maps_to_multiple_gvkeys,
         sum(npermco=1 and ngvkey=1) as unique_company_mappings
  from mve_link_stats;
  create table mve_issues as
  select distinct a.gvkey, a.fyear, a.mvedate, a.permco, n.permno
  from mve_link_stats as a
  inner join crsp_names as n
    on a.permco=n.permco and n.namedt <= a.mvedate
   and (missing(n.nameendt) or n.nameendt >= a.mvedate)
  where a.npermco=1 and a.ngvkey=1
    and n.shrcd in (10,11) and n.exchcd in (1,2,3);
  create table mve_issue_n as
  select gvkey, fyear, count(distinct permno) as nissues
  from mve_issues group by gvkey, fyear;
  create table mve_quote_candidates as
  select i.gvkey, i.fyear, i.mvedate, i.permco, i.permno,
         d.date, d.prc, d.shrout
  from mve_issues as i
  inner join crsp_all as d
    on i.permno=d.permno and i.permco=d.permco
   and d.date <= i.mvedate and d.date >= i.mvedate-30
  where not missing(d.prc) and d.shrout > 0;
  create table mve_company_daily as
  select q.gvkey, q.fyear, q.permco, q.date,
         count(distinct q.permno) as nquoted,
         n.nissues,
         sum(abs(q.prc)*q.shrout/1000) as mve
  from mve_quote_candidates as q
  inner join mve_issue_n as n
    on q.gvkey=n.gvkey and q.fyear=n.fyear
  group by q.gvkey, q.fyear, q.permco, q.date, n.nissues
  having count(distinct q.permno)=n.nissues;
  select count(*) as common_quote_company_dates,
         sum(nissues>1) as multi_issue_company_dates
  from mve_company_daily;
quit;
proc sort data=mve_company_daily;
  by gvkey fyear descending date;
run;
data mve_annual;
  set mve_company_daily;
  by gvkey fyear;
  if first.fyear;
  keep gvkey fyear mve date nissues permco;
  label mve="Company market capitalization in USD millions, three months after FYE";
run;
proc sql;
  select count(*) as company_market_values,
         sum(nissues>1) as mve_multiissue
  from mve_annual;
quit;

/* IBES annual EPS forecasts. Use score <= 2 links valid on STATPERS,
   and the earliest consensus date 3-15 months after each fiscal year end. */
data ibes_raw;
  set ibes.statsum_epsus(keep=ticker statpers measure fiscalp fpi numest
                              medest usfirm fpedats curcode);
  where measure='EPS' and fiscalp='ANN' and fpi in ('1','2')
    and usfirm=1 and '01JAN1960'd <= statpers <= '31DEC2002'd;
run;
data ibes_links;
  set iclink.ibcrsphist(keep=ticker permno sdate edate score);
  if score <= 2;
run;
proc sql;
  create table ibes_linked0 as
  select s.ticker, s.fpi, s.statpers, s.fpedats, s.medest, s.numest, s.curcode,
         l.permno, l.score
  from ibes_raw as s
  inner join ibes_links as l
    on s.ticker=l.ticker and l.sdate <= s.statpers
   and (missing(l.edate) or l.edate >= s.statpers)
  where not missing(s.fpedats) and not missing(s.medest);
quit;
proc sort data=ibes_linked0;
  by ticker permno statpers fpi fpedats score;
run;
data ibes_linked;
  set ibes_linked0;
  by ticker permno statpers fpi fpedats;
  if first.fpedats;
run;
proc sql;
  create table ibes_candidates as
  select p.gvkey, p.fyear, p.datadate, p.permno,
         s.fpi, s.statpers, s.fpedats, s.medest, s.numest, s.curcode, s.score
  from perm_year as p
  inner join ibes_linked as s
    on p.permno=s.permno
   and s.statpers >= intnx('month',p.datadate,3,'same')
   and s.statpers <= intnx('month',p.datadate,15,'same');
quit;
proc sort data=ibes_candidates;
  by gvkey fyear fpi statpers fpedats score;
run;
data ibes_first;
  set ibes_candidates;
  by gvkey fyear fpi;
  if first.fpi;
run;
proc sql;
  create table ibes_metrics as
  select p.gvkey, p.fyear,
         case when p.fyear < 1978 then 0
              when not missing(f1.curcode) and f1.curcode=f2.curcode
              then (f1.medest-f2.medest)**2 end as frev2a,
         f1.numest as nanal
  from perm_year as p
  left join ibes_first as f1
    on p.gvkey=f1.gvkey and p.fyear=f1.fyear and f1.fpi='1'
  left join ibes_first as f2
    on p.gvkey=f2.gvkey and p.fyear=f2.fyear+1 and f2.fpi='2'
   and f1.fpedats=f2.fpedats;
quit;

/* S34 contains multiple vendor vintages for some manager/report dates.
   Retain the first available manager/report-date vintage, as in the WRDS
   guide, then align its FDATE split-adjusted shares back to the CRSP month
   matched to RDATE before aggregating managers by security. */
data s34_raw;
  set tfn.s34(keep=rdate fdate mgrno cusip shares
              where=(rdate >= '31DEC1960'd and rdate <= '31DEC2001'd));
  if not missing(shares);
  cusip8=substr(compress(cusip),1,8);
  if not missing(cusip8);
run;
proc sql;
  create table s34_first_fdate as
  select rdate, mgrno, min(fdate) as fdate format=date9.
  from s34_raw
  where not missing(fdate)
  group by rdate, mgrno;
  create table s34_first as
  select a.rdate, b.fdate, a.mgrno, a.cusip8, a.shares
  from s34_raw as a
  inner join s34_first_fdate as b
    on a.rdate=b.rdate and a.mgrno=b.mgrno and a.fdate=b.fdate;
  create table s34_linked as
  select h.rdate, n.permno, h.shares,
         h.shares*(f.cfacshr/r.cfacshr) as shares_on_rdate_basis,
         r.shrout as rdate_shrout
  from s34_first as h
  inner join crsp_names as n
    on h.cusip8=n.ncusip and n.namedt <= h.rdate
   and (missing(n.nameendt) or n.nameendt >= h.rdate)
  inner join crsp.msf as r
    on n.permno=r.permno and year(h.rdate)=year(r.date)
   and month(h.rdate)=month(r.date)
  inner join crsp.msf as f
    on n.permno=f.permno and year(h.fdate)=year(f.date)
   and month(h.fdate)=month(f.date)
  where n.shrcd in (10,11) and r.shrout > 0
    and r.cfacshr > 0 and f.cfacshr > 0;
  create table s34_security as
  select rdate, permno, sum(shares_on_rdate_basis) as held_shares,
         max(rdate_shrout) as shrout
  from s34_linked group by rdate, permno;
quit;
proc sql;
  create table inst_quarter as
  select rdate, permno, held_shares, shrout,
         held_shares/(shrout*1000) as inst
  from s34_security;
  select count(*) as linked_security_quarters,
         sum(inst > 1) as institutional_fraction_over_one,
         max(inst) as maximum_institutional_fraction
  from inst_quarter;
quit;
proc sql;
  create table inst_annual as
  select p.gvkey, p.fyear, mean(q.inst) as inst, count(q.inst) as n_instq
  from perm_year as p
  left join inst_quarter as q
    on p.permno=q.permno and q.rdate > p.prevdate
   and q.rdate <= p.datadate
  group by p.gvkey, p.fyear;
quit;

/* Auxiliary earnings-quality series. */
proc sql;
  create table dd_window as
  select a.gvkey, a.fyear, std(b.ddresid) as dd_value,
         count(b.ddresid) as n_ddyears
  from comp_core as a
  inner join dd_resid as b
    on a.gvkey=b.gvkey and b.fyear between a.fyear-4 and a.fyear
  group by a.gvkey, a.fyear
  having count(b.ddresid)=5;
  create table abacc_value as
  select gvkey, fyear, abresid*abresid as abacc2
  from ab_resid;
  create table vcfo_value as
  select a.gvkey, a.fyear, var(b.cfo_at) as vcfo,
         count(b.cfo_at) as n_cfoyears
  from comp_core as a
  inner join comp_core as b
    on a.gvkey=b.gvkey and b.fyear between a.fyear-4 and a.fyear
  group by a.gvkey, a.fyear
  having count(b.cfo_at)=5;
quit;

/* Compose the current firm-year variables and their required lags/leads. */
proc sql;
  create table model_raw as
  select a.gvkey, a.fyear, a.datadate,
         v.var_ffadj, v.nmonths, d.dd_value, q.abacc2,
         fr.frev2a, fr.nanal, inst.inst,
         r.ret as ret_now, r0.ret as ret_lag,
         c1.cfo_scaled as cfo_lag,
         c2.cfo_scaled as cfo_lead,
         vc.vcfo as vcfo_lag,
         c1.at_usd as at_lag, c1.lt_usd as lt_lag,
         m1.mve as mve_lag, c1.lev as lev_lag,
         c1.fyear as source_lag_year,
         case when m1.mve > 0 then log(m1.mve) else . end as size_lag,
         case when not missing(c1.at_usd) and c1.at_usd ne 0
                   and not missing(c1.lt_usd) and not missing(m1.mve)
              then (c1.at_usd-c1.lt_usd)/m1.mve else . end as bm_lag
  from comp_core as a
  left join var_annual as v on a.gvkey=v.gvkey and a.fyear=v.fyear
  left join dd_window as d on a.gvkey=d.gvkey and d.fyear=a.fyear-1
  left join abacc_value as q on a.gvkey=q.gvkey and a.fyear=q.fyear+1
  left join ibes_metrics as fr on a.gvkey=fr.gvkey and a.fyear=fr.fyear+1
  left join inst_annual as inst on a.gvkey=inst.gvkey and a.fyear=inst.fyear+1
  left join ret_annual as r on a.gvkey=r.gvkey and a.fyear=r.fyear
  left join ret_annual as r0 on a.gvkey=r0.gvkey and a.fyear=r0.fyear+1
  left join comp_core as c1 on a.gvkey=c1.gvkey and a.fyear=c1.fyear+1
  left join comp_core as c2 on a.gvkey=c2.gvkey and a.fyear=c2.fyear-1
  left join vcfo_value as vc on a.gvkey=vc.gvkey and a.fyear=vc.fyear+1
  left join mve_annual as m1 on a.gvkey=m1.gvkey and a.fyear=m1.fyear+1
  where 1962 <= a.fyear <= 2001;
quit;

data model_base;
  set model_raw;
  time=fyear-1961;
  dd_lag=dd_value;
  abacc2_lag=abacc2;
  frev2a_lag=frev2a;
  ret2_lag=ret_lag*ret_lag;
  nanal_lag=nanal;
  inst_lag=inst;
  cfo_tm1=cfo_lag;
  cfo_tp1=cfo_lead;
  vcfo_lag=vcfo_lag;
  bm=bm_lag;
  size=size_lag;
  lev=lev_lag;
  ret=ret_now;
  if not missing(time) then do;
    t_dd=time*dd_lag;
    t_frev2a=time*frev2a_lag;
    t_ret2=time*ret2_lag;
    t_nanal=time*nanal_lag;
    t_inst=time*inst_lag;
    t_cfo_tp1=time*cfo_tp1;
    t_cfo_tm1=time*cfo_tm1;
    t_vcfo=time*vcfo_lag;
    t_abacc2=time*abacc2_lag;
  end;
  label time="TIME"
        dd_lag="DD, lagged one year"
        abacc2_lag="ABACC squared, lagged one year"
        t_dd="TIME x earnings quality"
        frev2a_lag="Squared analyst forecast revision, lagged"
        t_frev2a="TIME x FREV2A"
        ret2_lag="Squared annual return, lagged"
        t_ret2="TIME x RET squared"
        nanal_lag="Number of analysts, lagged"
        t_nanal="TIME x NANAL"
        inst_lag="Institutional ownership, lagged"
        t_inst="TIME x INST"
        cfo_tp1="CFO at t+1"
        t_cfo_tp1="TIME x CFO at t+1"
        cfo_tm1="CFO at t-1"
        t_cfo_tm1="TIME x CFO at t-1"
        vcfo_lag="CFO variance, lagged"
        t_vcfo="TIME x VCFO"
        bm="Book-to-market, lagged"
        size="Log market capitalization, lagged"
        lev="Leverage, lagged"
        ret="Annual buy-and-hold return";
run;

/* The paper winsorizes financial-statement variables, not volatility/RET. */
proc univariate data=model_base noprint;
  var dd_lag abacc2_lag cfo_tp1 cfo_tm1 vcfo_lag bm size lev;
  output out=main_cuts pctlpts=1 99
         pctlpre=DD_ AB_ CFO1_ CFO0_ VCFO_ BM_ SIZE_ LEV_
         pctlname=LO HI;
run;
data model_winsor;
  if _n_=1 then set main_cuts;
  set model_base;
  array x[8] dd_lag abacc2_lag cfo_tp1 cfo_tm1 vcfo_lag bm size lev;
  array lo[8] DD_LO AB_LO CFO1_LO CFO0_LO VCFO_LO BM_LO SIZE_LO LEV_LO;
  array hi[8] DD_HI AB_HI CFO1_HI CFO0_HI VCFO_HI BM_HI SIZE_HI LEV_HI;
  do j=1 to dim(x);
    if not missing(x[j]) then do;
      if x[j] < lo[j] then x[j]=lo[j];
      if x[j] > hi[j] then x[j]=hi[j];
    end;
  end;
  t_dd=time*dd_lag;
  t_abacc2=time*abacc2_lag;
  t_cfo_tp1=time*cfo_tp1;
  t_cfo_tm1=time*cfo_tm1;
  t_vcfo=time*vcfo_lag;
  drop j DD_LO DD_HI AB_LO AB_HI CFO1_LO CFO1_HI CFO0_LO CFO0_HI
         VCFO_LO VCFO_HI BM_LO BM_HI SIZE_LO SIZE_HI LEV_LO LEV_HI;
run;

/* Each handoff file is the paper-defined construction sample. The runner
   checks that GVKEY/FYEAR is unique and writes one reg.dta per sample. */
data ddout.reg;
  set model_winsor;
  if not missing(var_ffadj) and not missing(dd_lag);
  eq_lag=dd_lag;
  t_eq=t_dd;
  label eq_lag="DD, lagged one year" t_eq="TIME x DD";
  keep gvkey fyear time var_ffadj eq_lag t_eq frev2a_lag t_frev2a
       ret2_lag t_ret2 nanal_lag t_nanal inst_lag t_inst
       cfo_tp1 t_cfo_tp1 cfo_tm1 t_cfo_tm1 vcfo_lag t_vcfo
       bm size lev ret;
run;
data about.reg;
  set model_winsor;
  if not missing(var_ffadj) and not missing(abacc2_lag);
  eq_lag=abacc2_lag;
  t_eq=t_abacc2;
  label eq_lag="ABACC squared, lagged one year" t_eq="TIME x ABACC squared";
  keep gvkey fyear time var_ffadj eq_lag t_eq frev2a_lag t_frev2a
       ret2_lag t_ret2 nanal_lag t_nanal inst_lag t_inst
       cfo_tp1 t_cfo_tp1 cfo_tm1 t_cfo_tm1 vcfo_lag t_vcfo
       bm size lev ret;
run;
proc sort data=ddout.reg; by gvkey fyear; run;
proc sort data=about.reg; by gvkey fyear; run;
proc sql;
  select count(*) as dd_sample_n, min(fyear) as dd_first_year,
         max(fyear) as dd_last_year from ddout.reg;
  select count(*) as abacc2_sample_n, min(fyear) as abacc2_first_year,
         max(fyear) as abacc2_last_year from about.reg;
  select sum(missing(nanal_lag)) as missing_lagged_nanal,
         sum(missing(inst_lag)) as missing_lagged_inst,
         sum(missing(frev2a_lag)) as missing_lagged_frev
  from model_winsor;
quit;
proc freq data=ddout.reg;
  tables fyear / nopercent nocum;
run;
proc freq data=about.reg;
  tables fyear / nopercent nocum;
run;
