options errorabend nodate nonumber center linesize=150 pagesize=60;

libname cp '/storage/sas/base/comp/d_na' access=readonly;
libname sec '/storage/sas/base/comp/d_na/security' access=readonly;
libname fx '/storage/sas/base/comp/d_global/currency' access=readonly;
libname crsp '/storage/sas/base/crsp/a_stock' access=readonly;
libname ccm '/storage/sas/base/crsp/a_ccm' access=readonly;
libname handoff 'data';

%let raw_begin='01JUL1963'd;
%let raw_end='31DEC2002'd;
%let fit_begin='01JUL1966'd;
%let fit_end='31DEC2002'd;
%let month_zero='01JAN1960'd;
%let first_m=intck('month',&month_zero,&raw_begin);
%let last_m=intck('month',&month_zero,&fit_end);

/* Financial firms remain in the sample. Prefer INDL across the universe; use
   FS only when an INDL GVKEY/FYEAR record is absent, and audit both formats. */
data funda_raw;
  set cp.funda(keep=gvkey datadate fyear indfmt consol popsrc datafmt curcd fyr sich
                    at che dlc dltt mib pstk ceq act lct txp dp prcc_f csho hiid fdate);
  where datadate >= '01JAN1959'd and datadate <= '31DEC2002'd
    and datafmt='STD' and consol='C' and popsrc='D'
    and indfmt in ('INDL','FS');
  fmtpref=(indfmt='INDL');
run;

proc sql;
  title 'Annual fundamentals source coverage and alternate-format duplicates';
  select count(*) as rows_read,
         min(datadate) format=date9. as first_fye,
         max(datadate) format=date9. as last_fye,
         min(fyear) as first_fyear,
         max(fyear) as last_fyear
  from funda_raw;
  select indfmt, count(*) as rows
  from funda_raw group by indfmt;
  select count(*) as alt_fmt_groups
  from (select gvkey,fyear,count(*) as n from funda_raw group by gvkey,fyear having calculated n>1);
quit;

proc sort data=funda_raw out=funda_sort;
  by gvkey fyear indfmt descending fdate descending datadate;
run;
data funda_byfmt;
  set funda_sort;
  by gvkey fyear indfmt;
  if first.indfmt;
run;

proc sql;
  create table funda_indl as select * from funda_byfmt where indfmt='INDL';
  create table funda_fs as select * from funda_byfmt where indfmt='FS';
  create table funda_fmt_pair as
  select i.gvkey,i.fyear,i.datadate as indl_date,f.datadate as fs_date,
         i.sich as indl_sich,
         i.at as indl_at,f.at as fs_at,
         i.che as indl_che,f.che as fs_che,
         i.ceq as indl_ceq,f.ceq as fs_ceq,
         i.act as indl_act,f.act as fs_act,
         i.lct as indl_lct,f.lct as fs_lct,
         i.dp as indl_dp,f.dp as fs_dp,
         i.prcc_f as indl_prccf,f.prcc_f as fs_prccf,
         i.csho as indl_csho,f.csho as fs_csho
  from funda_indl as i inner join funda_fs as f
    on i.gvkey=f.gvkey and i.fyear=f.fyear;
  title 'INDL and supplemental FS overlap and required-field completeness';
  select count(*) as overlap_groups,
         sum(indl_sich>=6000 and indl_sich<=6999) as fin_overlap,
         sum(indl_date=fs_date) as same_fye_date,
         sum(nmiss(indl_at,indl_che,indl_ceq,indl_act,indl_lct,indl_dp)=0) as indl_core,
         sum(nmiss(fs_at,fs_che,fs_ceq,fs_act,fs_lct,fs_dp)=0) as fs_core,
         sum(nmiss(indl_prccf,indl_csho)=0) as indl_price,
         sum(nmiss(fs_prccf,fs_csho)=0) as fs_price,
         sum(nmiss(indl_at,indl_che,indl_ceq,indl_act,indl_lct,indl_dp)=0
             and nmiss(fs_at,fs_che,fs_ceq,fs_act,fs_lct,fs_dp)>0) as indl_only_core,
         sum(nmiss(fs_at,fs_che,fs_ceq,fs_act,fs_lct,fs_dp)=0
             and nmiss(indl_at,indl_che,indl_ceq,indl_act,indl_lct,indl_dp)>0) as fs_only_core,
         sum(nmiss(indl_prccf,indl_csho)=0 and nmiss(fs_prccf,fs_csho)>0) as indl_only_price,
         sum(nmiss(fs_prccf,fs_csho)=0 and nmiss(indl_prccf,indl_csho)>0) as fs_only_price
  from funda_fmt_pair;
  select count(*) as fs_only_groups from funda_fs as f
  left join funda_indl as i on f.gvkey=i.gvkey and f.fyear=i.fyear
  where missing(i.gvkey);
quit;

proc sort data=funda_byfmt out=funda_selected_sort;
  by gvkey fyear descending fmtpref descending fdate descending datadate;
run;
data funda_year;
  set funda_selected_sort;
  by gvkey fyear;
  if first.fyear;
  drop fmtpref;
  fymonth=intck('month','01JAN1960'd,datadate);
run;

/* Dated security-month primary markers and prices validate the exact annual
   historical primary issue (HIID) used to source PRCC_F's price currency. */
data sec_price;
  set sec.sec_mthprc(keep=gvkey iid datadate prccm curcdm);
  where datadate >= '01JAN1959'd and datadate <= '31DEC2002'd;
  mdate=intck('month','01JAN1960'd,datadate);
run;
data sec_desc;
  set sec.sec_mth(keep=gvkey iid datadate primiss);
  where datadate >= '01JAN1959'd and datadate <= '31DEC2002'd;
  mdate=intck('month','01JAN1960'd,datadate);
run;
proc freq data=sec_desc;
  title 'Compustat security-month primary/joiner marker values in source history';
  tables primiss / missing;
run;

proc sql;
  create table primary_price_map as
  select d.gvkey,d.mdate,count(p.datadate) as n_primary_price_rows,
         max(p.iid) as primary_iid length=3,
         max(p.curcdm) as primary_curcd length=3,
         max(p.prccm) as primary_prccm
  from sec_desc as d inner join sec_price as p
    on d.gvkey=p.gvkey and d.iid=p.iid and d.mdate=p.mdate
  where d.primiss='P'
  group by d.gvkey,d.mdate;
  create table hiid_price_map as
  select gvkey,iid,mdate,count(datadate) as n_hiid_price_rows,
         max(curcdm) as hiid_curcd length=3,max(prccm) as hiid_prccm
  from sec_price group by gvkey,iid,mdate;
  create table hiid_primary_price_map as
  select d.gvkey,d.iid,d.mdate,count(p.datadate) as n_hiid_primary_prices,
         max(p.curcdm) as hiid_primary_curcd length=3,
         max(p.prccm) as hiid_primary_prccm
  from sec_desc as d inner join sec_price as p
    on d.gvkey=p.gvkey and d.iid=p.iid and d.mdate=p.mdate
  where d.primiss='P'
  group by d.gvkey,d.iid,d.mdate;
  create table price_audit as
  select a.gvkey,a.fyear,a.datadate,a.hiid,a.curcd,
         coalesce(p.n_primary_price_rows,0) as n_primary_price_rows,
         p.primary_iid,p.primary_curcd,p.primary_prccm,
         coalesce(h.n_hiid_price_rows,0) as n_hiid_price_rows,
         h.hiid_curcd,h.hiid_prccm,
         coalesce(hp.n_hiid_primary_prices,0) as n_hiid_primary_prices,
         hp.hiid_primary_curcd,hp.hiid_primary_prccm,
         case when coalesce(hp.n_hiid_primary_prices,0)=1 then hp.hiid_primary_curcd
              else '' end as pricecurcd length=3,
         case when coalesce(hp.n_hiid_primary_prices,0)=1 then hp.hiid_primary_prccm
              else . end as sec_prccm,
         case when coalesce(hp.n_hiid_primary_prices,0)=1 then 'I'
              else 'M' end as price_route length=1,
         coalesce(hp.n_hiid_primary_prices,0) as n_price_rows
  from funda_year as a
  left join primary_price_map as p on a.gvkey=p.gvkey and a.fymonth=p.mdate
   left join hiid_price_map as h on a.gvkey=h.gvkey and a.hiid=h.iid and a.fymonth=h.mdate
   left join hiid_primary_price_map as hp on a.gvkey=hp.gvkey and a.hiid=hp.iid and a.fymonth=hp.mdate;
  create table primary_audit as
  select a.gvkey,a.fyear,a.datadate,a.hiid,
         count(d.datadate) as n_desc_rows,
         sum(case when d.primiss='P' then 1 else 0 end) as hiid_p_rows,
         sum(case when d.primiss='J' then 1 else 0 end) as hiid_j_rows
  from funda_year as a left join sec_desc as d
    on a.gvkey=d.gvkey and a.hiid=d.iid and a.fymonth=d.mdate
  group by a.gvkey,a.fyear,a.datadate,a.hiid;
  title 'Annual primary-price currency, issue match, and price comparison coverage';
  select count(*) as annual_rows,
         sum(n_primary_price_rows=1) as unique_primary_price_matches,
         sum(n_primary_price_rows=0) as no_primary_price_match,
         sum(n_primary_price_rows>1) as multiple_primary_price_matches,
         sum(n_hiid_price_rows=1) as unique_hiid_price_matches,
         sum(n_hiid_price_rows=0) as no_hiid_price_match,
         sum(n_hiid_price_rows>1) as multiple_hiid_price_matches,
          sum(price_route='I' and not missing(sec_prccm) and not missing(prcc_f)) as hiid_primary_comparable,
          sum(price_route='I' and not missing(pricecurcd)) as hiid_primary_currency,
         sum(price_route='M') as missing_dated_price_currency
  from price_audit a inner join funda_year f
    on a.gvkey=f.gvkey and a.fyear=f.fyear and a.datadate=f.datadate;
  select price_route,pricecurcd,count(*) as annual_rows
  from price_audit group by price_route,pricecurcd;
  select sum(n_desc_rows>0) as dated_hiid_descriptor_matches,
         sum(hiid_p_rows>0) as hiid_marked_primary,
         sum(hiid_j_rows>0) as hiid_marked_joiner
  from primary_audit;
  select count(*) as comparable_price_rows,
         sum(abs(f.prcc_f-p.sec_prccm)<=0.011) as close_within_one_cent,
         sum(f.curcd=p.pricecurcd) as same_price_curcd,
         sum(missing(f.csho)) as missing_company_shares,
         sum(not missing(f.csho) and f.csho=0) as zero_company_shares,
         sum(f.csho>0) as positive_company_share_rows,
         min(f.csho) as min_csho_millions,
         median(f.csho) as median_csho_millions,
         max(f.csho) as max_csho_millions
  from funda_year as f inner join price_audit as p
    on f.gvkey=p.gvkey and f.fyear=p.fyear and f.datadate=p.datadate
   where p.n_price_rows=1 and not missing(f.prcc_f) and not missing(p.sec_prccm);
quit;

/* Currency conversion follows the provider's GBP-primary cross-rate formula.
   Rate legs are paired on the same date; actual/carried provenance is preserved. */
data fx_raw;
  set fx.g_exrt_dly(keep=fromcurd tocurd exratd exrattpd datadate);
  where datadate >= '01JAN1959'd and datadate <= '31DEC2002'd
    and fromcurd='GBP' and not missing(tocurd);
run;
proc sql;
  title 'Daily FX duplicate date/currency keys';
  select count(*) as duplicate_pair_dates
  from (select fromcurd,tocurd,datadate,count(*) as n
        from fx_raw group by fromcurd,tocurd,datadate having calculated n>1);
  create table fx_bridge0 as
  select a.tocurd as curr length=3,
         a.datadate as fxdate format=date9.,
         a.exratd as r_cur,a.exrattpd as type_cur length=2,
         b.exratd as r_usd,b.exrattpd as type_usd length=2
  from fx_raw as a inner join fx_raw as b
    on a.datadate=b.datadate and a.fromcurd=b.fromcurd
  where a.tocurd not in ('USD','GBP') and b.tocurd='USD'
    and a.exratd>0 and b.exratd>0;
quit;
data fx_gbp;
  set fx_raw;
  where tocurd='USD' and exratd>0;
  length curr $3 type_cur type_usd $2;
  curr='GBP'; fxdate=datadate; r_cur=1; type_cur='ID';
  r_usd=exratd; type_usd=exrattpd;
  keep curr fxdate r_cur type_cur r_usd type_usd;
run;
data fx_usd;
  set fx_raw;
  where tocurd='USD' and exratd>0;
  length curr $3 type_cur type_usd $2;
  curr='USD'; fxdate=datadate; r_cur=1; type_cur='ID'; r_usd=1; type_usd='ID';
  keep curr fxdate r_cur type_cur r_usd type_usd;
run;
data fx_bridge;
  set fx_bridge0 fx_gbp fx_usd;
run;
proc sql;
  title 'FX bridge paired-date coverage and provenance';
  select curr,count(*) as paired_dates,
         min(fxdate) format=date9. as first_date,
         max(fxdate) format=date9. as last_date,
         sum(type_cur ne type_usd) as different_provenance_legs
  from fx_bridge group by curr;
  select count(*) as duplicate_bridge_keys
  from (select curr,fxdate,count(*) as n from fx_bridge group by curr,fxdate having calculated n>1);
quit;

proc sql;
  create table report_fx_date as
  select a.gvkey,a.fyear,a.datadate,a.curcd as curr length=3,
         max(f.fxdate) as fxdate format=date9.
  from price_audit as a left join fx_bridge as f
    on a.curcd=f.curr and f.fxdate<=a.datadate and f.fxdate>=a.datadate-7
  group by a.gvkey,a.fyear,a.datadate,a.curcd;
  create table price_fx_date as
  select a.gvkey,a.fyear,a.datadate,a.pricecurcd as curr length=3,
         max(f.fxdate) as fxdate format=date9.
  from price_audit as a left join fx_bridge as f
    on a.pricecurcd=f.curr and f.fxdate<=a.datadate and f.fxdate>=a.datadate-7
  group by a.gvkey,a.fyear,a.datadate,a.pricecurcd;
  create table report_fx as
  select d.gvkey,d.fyear,d.datadate,d.curr,d.fxdate,
         f.r_cur,f.r_usd,f.type_cur,f.type_usd
  from report_fx_date as d left join fx_bridge as f
    on d.curr=f.curr and d.fxdate=f.fxdate;
  create table price_fx as
  select d.gvkey,d.fyear,d.datadate,d.curr,d.fxdate,
         f.r_cur,f.r_usd,f.type_cur,f.type_usd
  from price_fx_date as d left join fx_bridge as f
    on d.curr=f.curr and d.fxdate=f.fxdate;
quit;

/* Form annual NOA/Accruals only on a consecutive fiscal-year join with consistent
   reporting currency and an observed prior-year asset denominator. */
proc sql;
  create table annual_pair as
  select a.gvkey,a.fyear,a.datadate,a.fymonth,a.hiid,a.curcd,a.sich,a.indfmt,
         a.at as at_current,
         a.che as che,a.dlc as dlc,a.dltt as dltt,a.mib as mib,a.pstk as pstk,
         a.ceq as ceq,a.act as act,a.lct as lct,a.txp as txp,a.dp as dp,
         a.prcc_f as prcc_f,a.csho as csho,
         b.datadate as prior_date format=date9.,b.curcd as prior_curcd,
         b.at as at_lag,b.che as che_lag,b.dlc as dlc_lag,b.dltt as dltt_lag,
         b.mib as mib_lag,b.pstk as pstk_lag,b.ceq as ceq_lag,
         b.act as act_lag,b.lct as lct_lag,b.txp as txp_lag,b.dp as dp_lag,
         p.pricecurcd,p.sec_prccm,p.n_price_rows,
         r.fxdate as report_fxdate format=date9.,r.r_cur as report_r_cur,
         r.r_usd as report_r_usd,r.type_cur as report_type_cur,
         r.type_usd as report_type_usd,
         q.fxdate as price_fxdate format=date9.,q.r_cur as price_r_cur,
         q.r_usd as price_r_usd,q.type_cur as price_type_cur,
         q.type_usd as price_type_usd
  from funda_year as a
  left join funda_year as b
    on a.gvkey=b.gvkey and a.fyear=b.fyear+1
       and intck('month',b.datadate,a.datadate) between 10 and 14
  left join price_audit as p
    on a.gvkey=p.gvkey and a.fyear=p.fyear and a.datadate=p.datadate
  left join report_fx as r
    on a.gvkey=r.gvkey and a.fyear=r.fyear and a.datadate=r.datadate
  left join price_fx as q
    on a.gvkey=q.gvkey and a.fyear=q.fyear and a.datadate=q.datadate;
quit;

data annual_vars;
  set annual_pair;
  length report_usd price_usd mv_local mv_usd ceq_usd noa accrual lnsize lnbm 8;
  report_usd=.; price_usd=.; mv_local=.; mv_usd=.; ceq_usd=.;
  noa=.; accrual=.; lnsize=.; lnbm=.;
  if curcd='USD' then report_usd=1;
  else if not missing(report_r_cur) and not missing(report_r_usd)
          and report_r_cur>0 and report_r_usd>0 then report_usd=report_r_usd/report_r_cur;
  if pricecurcd='USD' then price_usd=1;
  else if not missing(price_r_cur) and not missing(price_r_usd)
          and price_r_cur>0 and price_r_usd>0 then price_usd=price_r_usd/price_r_cur;
  if not missing(prcc_f) and not missing(csho) then mv_local=prcc_f*csho;
  if not missing(mv_local) and not missing(price_usd) then mv_usd=mv_local*price_usd;
  if not missing(ceq) and not missing(report_usd) then ceq_usd=ceq*report_usd;
  if not missing(at_lag) and at_lag>0 and not missing(prior_date)
     and not missing(curcd) and curcd=prior_curcd then do;
    noa_dlc=coalesce(dlc,0);
    noa_dltt=coalesce(dltt,0);
    noa_mib=coalesce(mib,0);
    noa_pstk=coalesce(pstk,0);
    if nmiss(che,ceq)=0 then noa=(noa_dlc+noa_dltt+noa_mib+noa_pstk+ceq-che)/at_lag;
    acc_dlc=coalesce(dlc,0); acc_dlc_lag=coalesce(dlc_lag,0);
    acc_txp=coalesce(txp,0); acc_txp_lag=coalesce(txp_lag,0);
    if nmiss(act,che,lct,dp,act_lag,che_lag,lct_lag)=0 then
      accrual=((act-act_lag)-(che-che_lag)-(lct-lct_lag)
               +(acc_dlc-acc_dlc_lag)+(acc_txp-acc_txp_lag)-dp)/at_lag;
  end;
  if not missing(mv_usd) and mv_usd>0 then lnsize=log(mv_usd);
  if not missing(ceq_usd) and ceq_usd>0 and not missing(mv_usd) and mv_usd>0
    then lnbm=log(ceq_usd/mv_usd);
  label noa='Net operating assets / prior assets'
        accrual='Operating accruals / prior assets'
        lnsize='Log market value, USD millions'
        lnbm='Log book-to-market';
  drop noa_dlc noa_dltt noa_mib noa_pstk acc_dlc acc_dlc_lag acc_txp acc_txp_lag;
run;

proc sql;
  title 'Annual accounting construction and currency audit';
  select count(*) as annual_rows,
         sum(not missing(at_lag) and at_lag>0) as prior_asset_denominators,
         sum(not missing(noa)) as noa_rows,
         sum(not missing(accrual)) as accrual_rows,
         sum(not missing(lnsize)) as usd_logsize_rows,
         sum(not missing(lnbm)) as positive_bm_rows,
         sum(curcd ne 'USD' and missing(report_usd)) as missing_report_fx,
         sum(pricecurcd ne 'USD' and not missing(pricecurcd) and missing(price_usd)) as missing_price_fx,
         sum(missing(pricecurcd)) as missing_price_currency,
          sum(n_price_rows>1) as multiple_hiid_primary_rows
  from annual_vars;
  select year(datadate) as year,count(*) as annual_rows,
         sum(not missing(noa)) as noa_rows,sum(not missing(accrual)) as accrual_rows,
         sum(not missing(lnsize)) as size_rows,sum(not missing(lnbm)) as bm_rows
  from annual_vars group by calculated year order by calculated year;
  select curcd,pricecurcd,count(*) as rows
  from annual_vars group by curcd,pricecurcd;
quit;

/* Lagged annual predictors: horizons are fiscal-year labels, not row positions.
   Missing years and distant dates stay missing. */
proc sql;
  create table annual_horizons as
  select a.gvkey,a.fyear,a.datadate,a.fymonth+4 as avail_m,a.hiid,a.curcd,
         a.lnsize,a.lnbm,a.noa as noa1,a.accrual as accr1,
         b.noa as noa2,b.accrual as accr2,c.noa as noa3,c.accrual as accr3
  from annual_vars as a
  left join annual_vars as b
    on a.gvkey=b.gvkey and a.fyear=b.fyear+1
       and a.datadate-b.datadate between 330 and 400
  left join annual_vars as c
    on a.gvkey=c.gvkey and a.fyear=c.fyear+2
       and a.datadate-c.datadate between 690 and 780;
quit;
proc sql;
  title 'Annual horizon field coverage before monthly availability expansion';
  select year(datadate) as year,count(*) as rows,
         sum(not missing(noa1)) as noa1_rows,sum(not missing(accr1)) as accr1_rows,
         sum(not missing(noa2)) as noa2_rows,sum(not missing(accr2)) as accr2_rows,
         sum(not missing(noa3)) as noa3_rows,sum(not missing(accr3)) as accr3_rows
  from annual_horizons group by calculated year order by calculated year;
  title 'Same-month annual availability records';
  select count(*) as repeated_annual_refresh_months
  from (select gvkey,avail_m,count(*) as n from annual_horizons
        group by gvkey,avail_m having calculated n>1);
quit;
proc sort data=annual_horizons out=annual_refresh_sort;
  by gvkey avail_m descending datadate;
run;
data annual_refresh;
  set annual_refresh_sort;
  by gvkey avail_m;
  if first.avail_m;
run;

/* Expand each annual snapshot from its own input row. The reversed sort plus LAG
   identifies the next refresh date without carrying accounting values across rows. */
proc sort data=annual_refresh out=annual_refresh_reverse;
  by gvkey descending avail_m;
run;
data annual_segments_reverse;
  set annual_refresh_reverse;
  by gvkey;
  next_avail_m=lag(avail_m);
  if first.gvkey then next_avail_m=.;
run;
proc sort data=annual_segments_reverse out=annual_segments;
  by gvkey avail_m;
run;
data annual_months;
  set annual_segments;
  h_end=min(avail_m+11,&last_m);
  if not missing(next_avail_m) then h_end=min(h_end,next_avail_m-1);
  do mdate=max(avail_m,&first_m) to h_end;
    fyear_asof=fyear; curcd_asof=curcd;
    output;
  end;
  keep gvkey mdate fyear_asof hiid curcd_asof lnsize lnbm noa1 accr1 noa2 accr2 noa3 accr3;
run;

proc sql;
  title 'Selected annual refresh rows before monthly expansion';
  select fyear,count(*) as refresh_rows,
         sum(not missing(noa1)) as noa1_rows,sum(not missing(accr1)) as accr1_rows,
         sum(not missing(noa2)) as noa2_rows,sum(not missing(accr2)) as accr2_rows,
         sum(not missing(noa3)) as noa3_rows,sum(not missing(accr3)) as accr3_rows
  from annual_refresh group by fyear order by fyear;
quit;

proc sql;
  title 'Expanded annual refresh coverage by accounting year';
  select fyear_asof,count(*) as firm_months,
         sum(not missing(noa1)) as noa1_months,sum(not missing(accr1)) as accr1_months,
         sum(not missing(noa2)) as noa2_months,sum(not missing(accr2)) as accr2_months,
         sum(not missing(noa3)) as noa3_months,sum(not missing(accr3)) as accr3_months
  from annual_months group by fyear_asof order by fyear_asof;
quit;

/* Raw monthly CRSP returns plus observed delisting returns. */
data msf_raw;
  set crsp.msf(keep=permno date ret retx);
  where date >= &raw_begin and date <= &raw_end;
  mdate=intck('month','01JAN1960'd,date);
run;
proc sql;
  title 'CRSP monthly return rows and duplicate source keys';
  select count(*) as msf_rows,min(date) format=date9. as first_date,
         max(date) format=date9. as last_date from msf_raw;
  select count(*) as duplicate_permno_months
  from (select permno,mdate,count(*) as n from msf_raw
        group by permno,mdate having calculated n>1);
quit;
data delist_raw;
  set crsp.msedelist(keep=permno dlstdt dlret);
  where dlstdt >= &raw_begin and dlstdt <= &raw_end;
  mdate=intck('month','01JAN1960'd,dlstdt);
run;
proc sql;
  create table delist_month as
  select permno,mdate,count(*) as n_delist,max(dlret) as dlret
  from delist_raw group by permno,mdate;
  title 'CRSP delisting return rows and duplicate event months';
  select count(*) as delist_months,sum(n_delist>1) as multi_event_months
  from delist_month;
quit;
proc sql;
  create table return_join as
  select coalesce(m.permno,d.permno) as permno,
         coalesce(m.mdate,d.mdate) as mdate,
         m.date,m.ret as msf_ret,m.retx,
         d.dlret,d.n_delist
  from msf_raw as m full join delist_month as d
    on m.permno=d.permno and m.mdate=d.mdate;
quit;
data return_clean;
  set return_join;
  if not missing(msf_ret) and msf_ret < -1 then msf_ret=.;
  if n_delist=1 and not missing(dlret) and dlret < -1 then dlret=.;
  if n_delist>1 then dlret=.;
  if n_delist=1 and not missing(dlret) then do;
    if not missing(msf_ret) then ret=(1+msf_ret)*(1+dlret)-1;
    else ret=dlret;
  end;
  else ret=msf_ret;
  if missing(date) then date=intnx('month','01JAN1960'd,mdate,'end');
  format date date9.;
run;
proc sort data=return_clean out=return_sort;
  by permno mdate;
run;

/* A ring of the preceding 36 calendar-month returns supplies the Table 5 windows.
   Any gap resets the history; a missing month return invalidates every window
   that contains it. */
data return_windows;
  set return_sort;
  by permno mdate;
  array rbuf[37] _temporary_;
  retain idx ncon prev_m;
  if first.permno then do;
    call missing(of rbuf[*]); idx=0; ncon=0; prev_m=.;
  end;
  else if mdate-prev_m ne 1 then do;
    call missing(of rbuf[*]); idx=0; ncon=0;
  end;
    idx=mod(idx,37)+1;
  rbuf[idx]=ret;
  ncon=ncon+1;
  prev_m=mdate;
  retm1=.; ret12_2=.; ret36_13=.;
  if ncon>=2 then do;
    slot=mod(idx-2+37,37)+1;
    if not missing(rbuf[slot]) then retm1=rbuf[slot];
  end;
  if ncon>=13 then do;
    product=1; good=1;
    do k=2 to 12;
      slot=mod(idx-k-1+37,37)+1;
      if missing(rbuf[slot]) then good=0;
      else product=product*(1+rbuf[slot]);
    end;
    if good then ret12_2=product-1;
  end;
  if ncon>=37 then do;
    product=1; good=1;
    do k=13 to 36;
      slot=mod(idx-k-1+37,37)+1;
      if missing(rbuf[slot]) then good=0;
      else product=product*(1+rbuf[slot]);
    end;
    if good then ret36_13=product-1;
  end;
  keep permno date mdate ret retx retm1 ret12_2 ret36_13;
run;

/* Expand historical CRSP names and dated CCM links into monthly candidates, but
   check their original daily boundaries against the actual CRSP monthly date. */
data name_months;
  set crsp.msenames(keep=permno namedt nameendt shrcd exchcd siccd);
  if (missing(nameendt) or nameendt >= &raw_begin) and namedt <= &raw_end;
  if missing(namedt) then name_start=&first_m;
  else name_start=max(&first_m,intck('month','01JAN1960'd,namedt));
  if missing(nameendt) then name_stop=&last_m;
  else name_stop=min(&last_m,intck('month','01JAN1960'd,nameendt));
  do mdate=name_start to name_stop;
    output;
  end;
  keep permno mdate namedt nameendt shrcd exchcd siccd;
run;
proc sql;
  create table dated_name_map as
  select r.permno,r.date,r.mdate,count(n.permno) as n_name,
         min(n.shrcd) as shrcd,max(n.shrcd) as shrcd_hi,
         min(n.exchcd) as exchcd,max(n.exchcd) as exchcd_hi,
         min(n.siccd) as siccd,max(n.siccd) as siccd_hi
  from return_windows as r left join name_months as n
    on r.permno=n.permno and r.mdate=n.mdate
   and (missing(n.namedt) or n.namedt<=r.date)
   and (missing(n.nameendt) or n.nameendt>=r.date)
  where r.date >= &fit_begin and r.date <= &fit_end
  group by r.permno,r.date,r.mdate;
  title 'Historical name-month matches, duplicates, and target exchange coverage';
  select count(*) as return_months,
         sum(n_name=0) as no_name_match,
         sum(n_name>1) as multiple_name_matches,
         sum(n_name=1 and shrcd in (10,11) and exchcd in (1,2,3)) as target_common_months
  from dated_name_map;
quit;
data name_map;
  set dated_name_map;
  if n_name=1 and shrcd=shrcd_hi and exchcd=exchcd_hi and siccd=siccd_hi;
  keep permno date mdate shrcd exchcd siccd;
run;

data ccm_source;
  set ccm.ccmxpf_linktable(keep=gvkey liid linkprim linktype lpermno linkdt linkenddt);
  where not missing(lpermno) and linktype in ('LC','LU') and linkprim in ('P','C')
    and (missing(linkenddt) or linkenddt >= &raw_begin)
    and (missing(linkdt) or linkdt <= &raw_end);
run;
data link_months;
  set ccm_source;
  if missing(linkdt) then link_start=&first_m;
  else link_start=max(&first_m,intck('month','01JAN1960'd,linkdt));
  if missing(linkenddt) then link_stop=&last_m;
  else link_stop=min(&last_m,intck('month','01JAN1960'd,linkenddt));
  do mdate=link_start to link_stop;
    output;
  end;
  keep gvkey liid linkprim linktype lpermno linkdt linkenddt mdate;
run;
proc sql;
  title 'Dated primary CCM link month counts';
  select count(*) as link_month_rows,
         count(distinct gvkey) as linked_gvkeys,
         min(linkdt) format=date9. as earliest_finite_link,
         max(linkenddt) format=date9. as latest_finite_link
  from link_months;
  select count(*) as dup_gvkey_permno_links
  from (select gvkey,lpermno,mdate,count(*) as n
        from link_months group by gvkey,lpermno,mdate having calculated n>1);
quit;

proc sql;
  create table common_months as
  select r.permno,r.date,r.mdate,r.ret,r.retx,r.retm1,r.ret12_2,r.ret36_13,
         n.shrcd,n.exchcd,n.siccd
  from return_windows as r inner join name_map as n
    on r.permno=n.permno and r.mdate=n.mdate and r.date=n.date
  where r.date >= &fit_begin and r.date <= &fit_end
    and n.shrcd in (10,11) and n.exchcd in (1,2,3);
  create table link_candidates as
  select l.gvkey,l.liid,l.linkprim,l.linktype,l.lpermno as permno,
         r.date,r.mdate,r.ret,r.retx,r.retm1,r.ret12_2,r.ret36_13,
         r.shrcd,r.exchcd,r.siccd
  from common_months as r inner join link_months as l
    on r.permno=l.lpermno and r.mdate=l.mdate
   and (missing(l.linkdt) or l.linkdt<=r.date)
   and (missing(l.linkenddt) or l.linkenddt>=r.date);
quit;

proc sql;
  create table scored_candidates as
  select c.*,a.hiid as annual_hiid,
         case when not missing(a.hiid) and c.liid=a.hiid then 1 else 0 end as hiid_match,
         case when c.linkprim='P' then 2 else 1 end as prim_score
  from link_candidates as c left join annual_months as a
    on c.gvkey=a.gvkey and c.mdate=a.mdate;
  create table perm_best as
  select gvkey,mdate,permno,max(prim_score) as prim_score,max(hiid_match) as hiid_match,
         count(*) as link_rows
  from scored_candidates group by gvkey,mdate,permno;
  create table candidate_bestscore as
  select gvkey,mdate,max(prim_score) as best_score
  from perm_best group by gvkey,mdate;
  create table candidate_top as
  select p.*
  from perm_best as p inner join candidate_bestscore as b
    on p.gvkey=b.gvkey and p.mdate=b.mdate and p.prim_score=b.best_score;
  create table candidate_besthiid as
  select gvkey,mdate,max(hiid_match) as best_hiid
  from candidate_top group by gvkey,mdate;
  create table candidate_final as
  select p.*
  from candidate_top as p inner join candidate_besthiid as b
    on p.gvkey=b.gvkey and p.mdate=b.mdate and p.hiid_match=b.best_hiid;
  create table candidate_counts as
  select gvkey,mdate,count(distinct permno) as n_permno
  from candidate_final group by gvkey,mdate;
  create table unique_candidates as
  select c.gvkey,c.mdate,c.permno,c.prim_score,c.hiid_match
  from candidate_final as c inner join candidate_counts as n
    on c.gvkey=n.gvkey and c.mdate=n.mdate and n.n_permno=1;
  title 'Primary link selection and ambiguity audit';
  select count(*) as candidate_gvkey_months,
         sum(n_permno=1) as uniquely_linked_months,
         sum(n_permno>1) as ambiguous_primary_months
  from candidate_counts;
quit;

proc sql;
  create table firm_month_raw as
  select u.gvkey,u.permno,u.mdate,r.date,r.ret,r.retx,r.retm1,r.ret12_2,r.ret36_13,
         r.shrcd,r.exchcd,r.siccd,
         a.fyear_asof,a.curcd_asof,a.lnsize,a.lnbm,
         a.noa1,a.accr1,a.noa2,a.accr2,a.noa3,a.accr3
  from unique_candidates as u inner join common_months as r
    on u.permno=r.permno and u.mdate=r.mdate
  left join annual_months as a
    on u.gvkey=a.gvkey and u.mdate=a.mdate;
quit;

data analysis;
  set firm_month_raw;
  firmid=input(gvkey,12.);
  fit_a=(not missing(ret) and not missing(lnsize) and not missing(lnbm)
         and not missing(retm1) and not missing(ret12_2) and not missing(ret36_13)
         and not missing(accr1) and not missing(noa1));
  fit_b=(not missing(ret) and not missing(lnsize) and not missing(lnbm)
         and not missing(retm1) and not missing(ret12_2) and not missing(ret36_13)
         and not missing(accr2) and not missing(noa2));
  fit_c=(not missing(ret) and not missing(lnsize) and not missing(lnbm)
         and not missing(retm1) and not missing(ret12_2) and not missing(ret36_13)
         and not missing(accr3) and not missing(noa3));
  label ret='Raw monthly stock return'
        retm1='Ret(-1:-1)'
        ret12_2='Ret(-12:-2)'
        ret36_13='Ret(-36:-13)'
        noa1='NOA, one fiscal year lag'
        accr1='Accruals, one fiscal year lag'
        noa2='NOA, two fiscal years lag'
        accr2='Accruals, two fiscal years lag'
        noa3='NOA, three fiscal years lag'
        accr3='Accruals, three fiscal years lag';
run;

proc sql;
  title 'Baseline firm-month sample coverage and complete-case attrition';
  select count(*) as linked_firm_months,
         sum(not missing(noa1)) as noa1_rows,sum(not missing(accr1)) as accr1_rows,
         sum(not missing(noa2)) as noa2_rows,sum(not missing(accr2)) as accr2_rows,
         sum(not missing(noa3)) as noa3_rows,sum(not missing(accr3)) as accr3_rows,
         sum(fit_a) as complete_panel_a,
         sum(fit_b) as complete_panel_b,
         sum(fit_c) as complete_panel_c,
         min(date) format=date9. as first_return_month,
         max(date) format=date9. as last_return_month
  from analysis;
  select year(date) as year,count(*) as linked_firm_months,
         sum(fit_a) as complete_a,sum(fit_b) as complete_b,sum(fit_c) as complete_c
  from analysis group by calculated year order by calculated year;
  select mdate,count(*) as linked_rows,
         sum(fit_a) as complete_a,sum(fit_b) as complete_b,sum(fit_c) as complete_c
  from analysis group by mdate order by mdate;
  select count(*) as duplicate_gvkey_months
  from (select gvkey,mdate,count(*) as n from analysis
        group by gvkey,mdate having calculated n>1);
quit;

/* Standard PROC REG OUTEST records monthly N and error degrees of freedom.
   Only aggregate full-rank evidence is printed; the OUTEST rows remain in WORK. */
%macro rankcheck(fit=,acc=,noa=,tag=);
  proc sql;
    create table rank_&tag._n as
    select mdate,count(*) as nobs
    from analysis where &fit=1 group by mdate;
  quit;
  proc sort data=analysis(where=(&fit=1)) out=rank_in;
    by mdate;
  run;
  proc reg data=rank_in outest=rank_&tag edf noprint;
    by mdate;
    model ret=lnsize lnbm retm1 ret12_2 ret36_13 &acc &noa;
  run;
  quit;
  proc sql;
    create table rank_&tag._sum as
    select n.mdate,n.nobs,e._edf_ as residual_df,
           n.nobs-e._edf_ as model_rank,
           (calculated model_rank=8) as full_rank
    from rank_&tag._n as n left join rank_&tag as e
      on n.mdate=e.mdate and upcase(e._type_)='PARMS';
    title "Monthly OLS full-rank audit &tag";
    select count(*) as fitted_months,
           sum(full_rank) as full_rank_months,
           sum(missing(model_rank)) as missing_rank_rows,
           min(nobs) as minimum_month_n,
           max(nobs) as maximum_month_n,
           min(model_rank) as minimum_model_rank,
           max(model_rank) as maximum_model_rank
    from rank_&tag._sum;
  quit;
%mend;
%rankcheck(fit=fit_a,acc=accr1,noa=noa1,tag=a);
%rankcheck(fit=fit_b,acc=accr2,noa=noa2,tag=b);
%rankcheck(fit=fit_c,acc=accr3,noa=noa3,tag=c);

proc sort data=analysis out=analysis_final;
  by gvkey mdate;
run;
data handoff.noa_firm_month;
  set analysis_final;
  keep gvkey firmid mdate permno ret retm1 ret12_2 ret36_13 lnsize lnbm
       accr1 noa1 accr2 noa2 accr3 noa3 fit_a fit_b fit_c fyear_asof;
run;
proc sql;
  title 'Final SAS handoff integrity';
  select count(*) as rows,count(distinct gvkey) as firms,
         min(mdate) as first_mdate,max(mdate) as last_mdate,
         sum(fit_a) as panel_a_rows,sum(fit_b) as panel_b_rows,sum(fit_c) as panel_c_rows
  from handoff.noa_firm_month;
  select count(*) as duplicate_final_keys
  from (select gvkey,mdate,count(*) as n from handoff.noa_firm_month
        group by gvkey,mdate having calculated n>1);
quit;
