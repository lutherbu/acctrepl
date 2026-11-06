options errorabend nonumber nodate;

libname comp '/storage/sas/base/comp/d_na' access=readonly;
libname sec  '/storage/sas/base/comp/d_na/security' access=readonly;
libname fx   '/storage/sas/base/comp/d_global/currency' access=readonly;
libname ccm  '/storage/sas/base/crsp/a_ccm' access=readonly;
libname crsp '/storage/sas/base/crsp/a_stock' access=readonly;
libname out 'data';

%macro failif_positive(value,message);
  %if &value > 0 %then %do;
    %put ERROR: &message;
    %abort cancel;
  %end;
%mend;

/* INDL is Compustat's standardized North America format, including financial firms;
   FS is supplemental and can disagree materially on a repeated firm-year. */
data raw_all;
  set comp.funda(keep=gvkey datadate fyear indfmt datafmt consol popsrc curcd
       sich au auop at act che lct dlc dp revt rect ppegt ceq csho prcc_f dltt ib hiid
       where=(fyear >= 1971 and fyear <= 1997 and indfmt='INDL' and datafmt='STD' and
              consol='C' and popsrc='D'));
  length sic2 big6 8 sic2_source $24;
  if sich >= 100 and sich <= 9999 then do;
    sic2=floor(sich/100);
    sic2_source='FUNDA_SICH';
  end;
  else do;
    sic2=.;
    sic2_source='UNAVAILABLE';
  end;
  if not missing(strip(au)) and strip(au) ne '0' then do;
    if strip(au) in ('1','2','3','4','5','6','7','8') then big6=1;
    else big6=0;
  end;
  else big6=.;
run;

proc sql;
  create table dup_fyear as
  select gvkey, fyear, count(*) as n
  from raw_all
  group by gvkey, fyear
  having calculated n > 1;
  select count(*) into :dup_fyear_count trimmed from dup_fyear;
  select count(*) as ambiguous_gvkey_fyear_keys from dup_fyear;
  select count(*) as excluded_ambiguous_source_rows
  from raw_all as a inner join dup_fyear as d
    on a.gvkey=d.gvkey and a.fyear=d.fyear;
  create table raw as
  select a.* from raw_all as a
  where not exists
    (select 1 from dup_fyear as d where a.gvkey=d.gvkey and a.fyear=d.fyear);
quit;
proc sort data=raw;
  by gvkey fyear datadate;
run;
proc sql;
  create table duplicate_retained_fyear as
  select gvkey, fyear, count(*) as n
  from raw group by gvkey, fyear having calculated n > 1;
  select count(*) into :duplicate_retained_count trimmed from duplicate_retained_fyear;
  select count(*) as retained_dup_keys from duplicate_retained_fyear;
quit;
%failif_positive(&duplicate_retained_count,INDL source remains nonunique after ambiguous firm-years were excluded.)

/* Fill missing historical SICH only from date-valid CRSP SICs attached through
   active primary CCM links. Prefer an exact FUNDA.HIID issue; allow a unique
   company SIC only when the exact issue SIC is unavailable. Keep SICH present. */
data crsp_names;
  set crsp.dsenames(keep=permno namedt nameendt siccd
       where=(namedt <= '31DEC1998'd));
run;
proc sql;
  create table crsp_sic_source as
  select a.gvkey, a.fyear,
         count(distinct case when not missing(a.hiid) and strip(a.hiid)=strip(l.liid) and
                                  not missing(n.permno) and not missing(n.siccd) and
                                  n.siccd>=100 and n.siccd<10000
                             then floor(n.siccd/100) else . end) as exact_sic2_n,
         max(case when not missing(a.hiid) and strip(a.hiid)=strip(l.liid) and
                       not missing(n.permno) and not missing(n.siccd) and
                       n.siccd>=100 and n.siccd<10000
                  then floor(n.siccd/100) else . end) as exact_sic2,
         count(distinct case when not missing(n.permno) and not missing(n.siccd) and
                                  n.siccd>=100 and n.siccd<10000
                             then floor(n.siccd/100) else . end) as company_sic2_n,
         max(case when not missing(n.permno) and not missing(n.siccd) and
                       n.siccd>=100 and n.siccd<10000
                  then floor(n.siccd/100) else . end) as company_sic2
  from raw as a
  left join ccm.ccmxpf_linktable as l
    on a.gvkey=l.gvkey and l.linkprim in ('P','C') and l.linktype in ('LC','LU','LS') and
       l.lpermno>0 and l.linkdt<=a.datadate and (l.linkenddt>=a.datadate or l.linkenddt=.E)
  left join crsp_names as n
    on l.lpermno=n.permno and n.namedt<=a.datadate and
       (n.nameendt>=a.datadate or n.nameendt=99999999 or n.nameendt=.E)
  group by a.gvkey,a.fyear;
quit;
proc sort data=crsp_sic_source;
  by gvkey fyear;
run;
data raw;
  merge raw(in=in_raw) crsp_sic_source;
  by gvkey fyear;
  if in_raw;
  if sic2_source ne 'FUNDA_SICH' then do;
    sic2=.;
    if exact_sic2_n=1 then do;
      sic2=exact_sic2;
      sic2_source='CRSP_DATED_HIID';
    end;
    else if exact_sic2_n=0 and company_sic2_n=1 then do;
      sic2=company_sic2;
      sic2_source='CRSP_DATED_COMPANY';
    end;
    else if exact_sic2_n>1 or (exact_sic2_n=0 and company_sic2_n>1) then
      sic2_source='AMBIGUOUS_CRSP';
    else sic2_source='UNAVAILABLE';
  end;
  if exact_sic2_n=1 then crsp_chosen_sic2=exact_sic2;
  else if exact_sic2_n=0 and company_sic2_n=1 then crsp_chosen_sic2=company_sic2;
  else crsp_chosen_sic2=.;
run;
proc sql;
  select count(*) as sic_source_rows,
         sum(sic2_source='FUNDA_SICH') as funda_sich_rows,
         sum(sic2_source='CRSP_DATED_HIID') as crsp_hiid_fallback_rows,
         sum(sic2_source='CRSP_DATED_COMPANY') as crsp_company_fallback_rows,
         sum(sic2_source='UNAVAILABLE') as rows_without_classification,
         sum(sic2_source='AMBIGUOUS_CRSP') as ambiguous_crsp_sic_rows,
         sum(sic2_source='FUNDA_SICH' and not missing(crsp_chosen_sic2) and sic2=crsp_chosen_sic2) as overlap_same_sic2,
         sum(sic2_source='FUNDA_SICH' and not missing(crsp_chosen_sic2) and sic2 ne crsp_chosen_sic2) as overlap_different_sic2
  from raw;
quit;

proc means data=raw n nmiss min max;
  class fyear;
  var at act che lct dlc dp revt rect ppegt ceq csho prcc_f dltt ib sich;
  title 'Annual Compustat source coverage by fiscal year';
run;
proc freq data=raw;
  tables indfmt*curcd / missing;
  title 'Included Compustat formats and reporting currencies';
run;

/* Actual fiscal-year joins: no row-order lags and no use of later periods. */
proc sql;
  create table panel_lag as
  select a.*,
         b.fyear as lagyear,
         b.datadate as lagdate,
         b.curcd as lagcurcd,
         b.at as at_lag,
         b.act as act_lag,
         b.che as che_lag,
         b.lct as lct_lag,
         b.dlc as dlc_lag,
         b.revt as revt_lag,
         b.rect as rect_lag,
         b.ib as ib_lag
  from raw as a
  left join raw as b
    on a.gvkey=b.gvkey and b.fyear=a.fyear-1;
quit;

data metrics;
  set panel_lag;
  length ta ta_s inv_at rev_s rec_s ppe_s rev_delta rec_delta perform de 8;
  ta=.; ta_s=.; inv_at=.; rev_s=.; rec_s=.; ppe_s=.;
  rev_delta=.; rec_delta=.; perform=.; de=.;
  if not missing(at) and at>0 and not missing(dltt) then de=dltt/at;
  if lagyear=fyear-1 and not missing(curcd) and curcd=lagcurcd then do;
    if not missing(at_lag) and at_lag>0 then inv_at=1/at_lag;
    if nmiss(act,act_lag,che,che_lag,lct,lct_lag,dlc,dlc_lag,dp)=0 and
       not missing(at_lag) and at_lag>0 then do;
      ta=(act-act_lag)-(che-che_lag)-(lct-lct_lag)+(dlc-dlc_lag)-dp;
      ta_s=ta/at_lag;
    end;
    if nmiss(revt,revt_lag)=0 then do;
      rev_delta=revt-revt_lag;
      if not missing(at_lag) and at_lag>0 then rev_s=rev_delta/at_lag;
    end;
    if nmiss(rect,rect_lag)=0 then do;
      rec_delta=rect-rect_lag;
      if not missing(at_lag) and at_lag>0 then rec_s=rec_delta/at_lag;
    end;
    if not missing(ppegt) and not missing(at_lag) and at_lag>0 then ppe_s=ppegt/at_lag;
    if nmiss(ib,ib_lag,at_lag)=0 and at_lag>0 then perform=abs(ib-ib_lag)/at_lag;
  end;
run;

/* A historical primary issue ID is matched directly by GVKEY, HIID and date.
   Retain the marker as a diagnostic; its absence is not treated as a conflict. */
data secissue;
  set sec.sec_mth(keep=gvkey iid datadate primiss
       where=(datadate >= '01JAN1980'd and datadate <= '31DEC1997'd));
run;
data secprice;
  set sec.sec_mthprc(keep=gvkey iid datadate curcdm prccm
       where=(datadate >= '01JAN1980'd and datadate <= '31DEC1997'd));
run;
proc sql;
  create table dup_secissue as
  select gvkey, iid, datadate, count(*) as n
  from secissue group by gvkey, iid, datadate having calculated n>1;
  create table dup_secprice as
  select gvkey, iid, datadate, count(*) as n
  from secprice group by gvkey, iid, datadate having calculated n>1;
  select count(*) into :dup_secissue_count trimmed from dup_secissue;
  select count(*) into :dup_secprice_count trimmed from dup_secprice;
quit;
%failif_positive(&dup_secissue_count,Dated security issue keys are not unique. No issue row is chosen arbitrarily.)
%failif_positive(&dup_secprice_count,Dated security price keys are not unique. No issue row is chosen arbitrarily.)

proc sql;
  create table price_audit as
  select a.gvkey, a.fyear, a.datadate, a.curcd, a.hiid, a.au, a.auop,
         a.sich, a.sic2, a.sic2_source, a.big6, a.at, a.ceq, a.csho, a.prcc_f, a.dltt,
         a.perform, a.ta, a.ta_s, a.inv_at, a.rev_s, a.rec_s, a.ppe_s,
         b.iid as primary_iid, b.primiss, c.curcdm, c.prccm
  from metrics as a
  left join secissue as b
    on a.gvkey=b.gvkey and a.datadate=b.datadate and
       not missing(a.hiid) and strip(a.hiid)=strip(b.iid)
  left join secprice as c
    on b.gvkey=c.gvkey and b.iid=c.iid and b.datadate=c.datadate
  where a.fyear between 1980 and 1997;
quit;

data price_audit;
  set price_audit;
  length issue_match marker_primary price_agree 8 price_curcd $3 price_curcd_basis $20;
  issue_match=0; marker_primary=0; price_agree=0;
  price_curcd=''; price_curcd_basis='UNAVAILABLE';
  if not missing(primary_iid) and not missing(strip(hiid)) and
     strip(hiid)=strip(primary_iid) then do;
    issue_match=1;
    if primiss='P' then marker_primary=1;
  end;
  if not missing(prcc_f) and not missing(prccm) and abs(prcc_f-prccm)<=0.005 then price_agree=1;
  if issue_match=1 and price_agree=1 and (primiss='P' or missing(primiss)) and
     not missing(strip(curcdm)) then do;
    price_curcd=curcdm;
    price_curcd_basis='HIID_CURCDM';
  end;
  else if not missing(strip(curcd)) then do;
    price_curcd=curcd;
    price_curcd_basis='CURCD_INFERRED';
  end;
  if not missing(csho) and csho>0 and not missing(prcc_f) and prcc_f>0
     then mve_local=csho*prcc_f;
  else mve_local=.;
run;
proc sql;
  select count(*) as event_rows,
         sum(issue_match=1) as exact_hiid_issue_rows,
         sum(marker_primary=1) as exact_hiid_issue_marker_p,
         sum(issue_match=1 and missing(primiss)) as exact_hiid_issue_marker_absent,
         sum(issue_match=1 and not missing(primiss) and primiss ne 'P') as exact_hiid_issue_marker_conflict,
         sum(price_agree=1 and price_curcd_basis='HIID_CURCDM') as direct_price_currency_rows,
         sum(price_curcd_basis='CURCD_INFERRED') as inferred_price_currency_rows,
         sum(price_curcd_basis='UNAVAILABLE') as unavailable_price_currency_rows,
         sum(not missing(mve_local)) as source_price_mve_rows
  from price_audit;
quit;
proc freq data=price_audit;
  tables primiss*curcdm price_curcd_basis*curcdm / missing;
  title 'Dated HIID issue price agreement and annual/security currency evidence';
run;

/* Xpressfeed GBP-bridge formula: local amount * GBP/USD rate / GBP/local rate.
   Keep both rate-type fields for the two legs; do not screen by provenance type. */
data fxraw;
  set fx.g_exrt_dly(keep=datadate fromcurd tocurd exratd exrattpd
       where=(fromcurd='GBP' and datadate >= '01JAN1980'd and datadate <= '31DEC1997'd));
run;
proc sql;
  create table dup_fx as
  select datadate, tocurd, count(*) as n
  from fxraw group by datadate, tocurd having calculated n>1;
  select count(*) into :dup_fx_count trimmed from dup_fx;
quit;
%failif_positive(&dup_fx_count,Xpressfeed GBP cross-rate keys are not unique. No rate row is chosen arbitrarily.)
proc sql;
  create table fx_bridge as
  select a.datadate, a.tocurd as curcd,
         a.exratd as gbp_to_cur, a.exrattpd as type_cur,
         b.exratd as gbp_to_usd, b.exrattpd as type_usd
  from fxraw as a
  left join fxraw as b
    on a.datadate=b.datadate and b.tocurd='USD';
quit;
proc sql;
  select count(*) as gbp_rate_rows,
         sum(not missing(exratd) and exratd>0) as positive_rate_rows,
         sum(missing(exratd)) as missing_rate_rows,
         sum(missing(exrattpd)) as missing_provenance_rows
  from fxraw;
quit;
data fx_usd_regular;
  set fx_bridge;
  length fx_mult 8;
  fx_mult=.;
  if curcd in ('GBP','USD') then delete;
  if not missing(gbp_to_cur) and gbp_to_cur>0 and
     not missing(gbp_to_usd) and gbp_to_usd>0 then fx_mult=gbp_to_usd/gbp_to_cur;
run;
data fx_usd_gbp;
  set fxraw(where=(tocurd='USD'));
  length curcd $3 type_cur $2 type_usd $2 gbp_to_cur fx_mult 8;
  curcd='GBP'; gbp_to_cur=1; type_cur='ID';
  gbp_to_usd=exratd; type_usd=exrattpd; fx_mult=exratd;
  keep datadate curcd gbp_to_cur gbp_to_usd type_cur type_usd fx_mult;
run;
/* USD needs no exchange quote; create explicit identity conversions on event dates. */
proc sql;
  create table event_dates as
  select distinct datadate from price_audit where not missing(datadate);
quit;
data fx_usd_usd;
  set event_dates;
  length curcd $3 type_cur $2 type_usd $2 gbp_to_cur gbp_to_usd fx_mult 8;
  curcd='USD'; type_cur='ID'; type_usd='ID'; fx_mult=1;
  gbp_to_cur=.; gbp_to_usd=.;
  keep datadate curcd gbp_to_cur gbp_to_usd type_cur type_usd fx_mult;
run;
data fx_usd;
  set fx_usd_regular fx_usd_gbp fx_usd_usd;
run;
proc sql;
  create table dup_fxusd as
  select datadate, curcd, count(*) as n
  from fx_usd group by datadate, curcd having calculated n>1;
  select count(*) into :dup_fxusd_count trimmed from dup_fxusd;
quit;
%failif_positive(&dup_fxusd_count,Derived daily USD conversion keys are not unique.)

proc sql;
  create table event_data0 as
  select p.*, f.fx_mult as funda_fx,
         f.type_cur as funda_fx_type, f.type_usd as funda_usd_type,
         q.fx_mult as price_fx,
         q.type_cur as price_fx_type, q.type_usd as price_usd_type
  from price_audit as p
  left join fx_usd as f
    on p.datadate=f.datadate and p.curcd=f.curcd
  left join fx_usd as q
    on p.datadate=q.datadate and p.price_curcd=q.curcd;
quit;
data event_data;
  set event_data0;
  length at_usd ceq_usd mve_usd bp mktcap de 8;
  at_usd=.; ceq_usd=.; mve_usd=.; bp=.; mktcap=.; de=.;
  if not missing(at) and at>0 and not missing(funda_fx) and funda_fx>0 then at_usd=at*funda_fx;
  if not missing(ceq) and not missing(funda_fx) and funda_fx>0 then ceq_usd=ceq*funda_fx;
  if not missing(mve_local) and not missing(price_fx) and price_fx>0 then mve_usd=mve_local*price_fx;
  if not missing(mve_usd) and mve_usd>0 then mktcap=log10(mve_usd);
  if not missing(ceq_usd) and ceq_usd>=0 and not missing(mve_usd) and mve_usd>0 then bp=ceq_usd/mve_usd;
  if not missing(dltt) and not missing(at) and at>0 then de=dltt/at;
run;
proc freq data=event_data;
  tables funda_fx_type*funda_usd_type price_fx_type*price_usd_type
         price_curcd_basis*curcdm / missing;
  title 'Daily exchange-rate leg and price-currency provenance';
run;
proc means data=event_data n nmiss min p1 median p99 max;
  var bp mktcap de perform at_usd;
  title 'Event-year variable coverage and scale before matching';
run;

/* First qualified opinion by GVKEY in 1980-1997, before completeness screens. */
proc sort data=event_data(where=(strip(auop)='2')) out=qualified_order;
  by gvkey fyear datadate;
run;
data qualified_first;
  set qualified_order;
  by gvkey;
  if first.gvkey;
run;
proc sql;
  select count(*) as first_qualified_events,
         min(fyear) as first_event_year,
         max(fyear) as last_event_year
  from qualified_first;
quit;

/* Time-series Jones support: exactly the eight consecutive years before the event. */
proc sql;
  create table ts_case_train0 as
  select e.gvkey, e.fyear as evyr, h.fyear as fit_year,
         h.ta_s, h.inv_at, h.rev_s, h.ppe_s
  from qualified_first as e
  inner join metrics as h
    on e.gvkey=h.gvkey and h.fyear between e.fyear-8 and e.fyear-1;
quit;
data ts_case_train;
  set ts_case_train0;
  if nmiss(ta_s,inv_at,rev_s,ppe_s)=0;
run;
proc sort data=ts_case_train;
  by gvkey evyr fit_year;
run;
ods select none;
ods output NObs=ts_case_nobs;
proc reg data=ts_case_train outest=ts_case_out edf;
  by gvkey evyr;
  model ta_s=inv_at rev_s ppe_s / noint;
quit;
ods output close;
ods select all;
proc sql;
  create table ts_case_ok as
  select o.gvkey, o.evyr, o.inv_at as bts_inv, o.rev_s as bts_rev,
         o.ppe_s as bts_ppe, o._P_ as fit_rank, o._IN_ as input_regressors,
         o._EDF_ as error_df, n.NObsUsed as n_used
  from ts_case_out as o
  inner join ts_case_nobs as n
    on o.gvkey=n.gvkey and o.evyr=n.evyr
  where o._TYPE_='PARMS' and o._P_=3 and o._IN_=3 and
        n.Label='Number of Observations Used' and n.NObsUsed=8;
  select count(*) as full_rank_eight_year_case_fits from ts_case_ok;
quit;

/* Cross-sectional original Jones support uses all firms in each fiscal year/SIC2. */
data cs_train;
  set metrics;
  if fyear >= 1980 and fyear <= 1997 and not missing(sic2) and sic2 ne 99 and
     nmiss(ta_s,inv_at,rev_s,ppe_s)=0;
run;
proc sort data=cs_train;
  by fyear sic2 gvkey;
run;
ods select none;
ods output NObs=cs_nobs;
proc reg data=cs_train outest=cs_out edf;
  by fyear sic2;
  model ta_s=inv_at rev_s ppe_s / noint;
quit;
ods output close;
ods select all;
proc sql;
  create table cs_ok as
  select o.fyear, o.sic2, o.inv_at as bcs_inv, o.rev_s as bcs_rev,
         o.ppe_s as bcs_ppe, o._P_ as fit_rank, o._IN_ as input_regressors,
         o._EDF_ as error_df, n.NObsUsed as n_used
  from cs_out as o
  inner join cs_nobs as n
    on o.fyear=n.fyear and o.sic2=n.sic2
  where o._TYPE_='PARMS' and o._P_=3 and o._IN_=3 and
        n.Label='Number of Observations Used';
  select fyear, count(*) as full_rank_year_sic_cells,
         min(n_used) as min_cell_n, median(n_used) as median_cell_n,
         max(n_used) as max_cell_n
  from cs_ok group by fyear order by fyear;
  select count(*) as full_rank_cs_cells,
         sum(error_df=0) as cs_cells_zero_residual_df,
         sum(error_df>0) as cs_cells_positive_residual_df,
         min(error_df) as minimum_cs_residual_df
  from cs_ok;
quit;

proc sql;
  create table case_stage0 as
  select e.*, t.bts_inv, t.bts_rev, t.bts_ppe,
         c.bcs_inv, c.bcs_rev, c.bcs_ppe
  from qualified_first as e
  left join ts_case_ok as t
    on e.gvkey=t.gvkey and e.fyear=t.evyr
  left join cs_ok as c
    on e.fyear=c.fyear and e.sic2=c.sic2;
quit;
data case_stage;
  set case_stage0;
  length da_ts_j da_ts_mj da_cs_j da_cs_mj abs_ts_j abs_ts_mj abs_cs_j abs_cs_mj 8;
  da_ts_j=.; da_ts_mj=.; da_cs_j=.; da_cs_mj=.;
  if nmiss(ta_s,inv_at,rev_s,ppe_s,bts_inv,bts_rev,bts_ppe)=0 then do;
    da_ts_j=ta_s-(bts_inv*inv_at+bts_rev*rev_s+bts_ppe*ppe_s);
    if not missing(rec_s) then da_ts_mj=ta_s-(bts_inv*inv_at+bts_rev*(rev_s-rec_s)+bts_ppe*ppe_s);
  end;
  if nmiss(ta_s,inv_at,rev_s,ppe_s,bcs_inv,bcs_rev,bcs_ppe)=0 then do;
    da_cs_j=ta_s-(bcs_inv*inv_at+bcs_rev*rev_s+bcs_ppe*ppe_s);
    if not missing(rec_s) then da_cs_mj=ta_s-(bcs_inv*inv_at+bcs_rev*(rev_s-rec_s)+bcs_ppe*ppe_s);
  end;
  abs_ts_j=abs(da_ts_j);
  abs_ts_mj=abs(da_ts_mj);
  abs_cs_j=abs(da_cs_j);
  abs_cs_mj=abs(da_cs_mj);
run;
proc sql;
  select count(*) as first_qualified_events,
         sum(not missing(abs_ts_j)) as qualified_with_ts_jones,
         sum(not missing(abs_ts_mj)) as qualified_with_ts_modified,
         sum(not missing(abs_cs_j)) as qualified_with_cs_jones,
         sum(not missing(abs_cs_mj)) as qualified_with_cs_modified,
         sum(missing(abs_ts_j)) as qualified_without_ts_jones,
         sum(missing(bp)) as qualified_missing_bp,
         sum(missing(mktcap)) as qualified_missing_mktcap,
         sum(missing(de)) as qualified_missing_de,
         sum(missing(perform)) as qualified_missing_perform,
         sum(missing(at_usd)) as qualified_missing_assets,
         sum(missing(big6)) as qualified_missing_auditor_type,
         sum(missing(sic2) or sic2=99) as qualified_missing_class,
         sum(missing(bp) or missing(mktcap) or missing(de) or missing(perform) or
             missing(at_usd)) as qualified_missing_control_inputs,
         sum(nmiss(abs_ts_j,abs_ts_mj,abs_cs_j,abs_cs_mj)=0) as qualified_with_all_da
  from case_stage;
quit;

/* The source declares one Table 7 sample for all four models. Screen complete
   DA/control cases before matching; retain financial SICs and exclude SIC99. */
data cases_matchable;
  set case_stage;
  if nmiss(bp,mktcap,de,perform,at_usd,abs_ts_j,abs_ts_mj,abs_cs_j,abs_cs_mj)=0 and
     at_usd>0 and
     not missing(big6) and not missing(sic2) and sic2 ne 99;
run;
proc sort data=cases_matchable;
  by fyear sic2 big6 gvkey;
run;
data cases_matchable;
  set cases_matchable;
  caseid=_n_;
run;
proc sql;
  select count(*) as complete_classifiable_cases from cases_matchable;
quit;

/* Candidate controls must meet the same Table 7 common-data screen before
   nearest-assets matching, so an incomplete nearest control cannot displace
   an eligible complete control. */
proc sql;
  create table case_strata as
  select distinct fyear, sic2, big6 from cases_matchable;
  create table control_pool0 as
  select c.*
  from event_data as c
  inner join case_strata as s
    on c.fyear=s.fyear and c.sic2=s.sic2 and c.big6=s.big6
  where strip(c.auop)='1' and not missing(c.bp) and not missing(c.mktcap) and
        not missing(c.de) and not missing(c.perform) and
        not missing(c.at_usd) and c.at_usd>0 and
        not missing(c.big6) and not missing(c.sic2) and c.sic2 ne 99;
  select count(*) as controls_with_common_controls from control_pool0;
quit;

/* Estimate control-firm Jones coefficients before matching, on the same full
   eight-year history and full-rank rule used for case eligibility. */
proc sql;
  create table ts_ctrl_train0 as
  select c.gvkey, c.fyear as evyr, h.fyear as fit_year,
         h.ta_s, h.inv_at, h.rev_s, h.ppe_s
  from control_pool0 as c
  inner join metrics as h
    on c.gvkey=h.gvkey and h.fyear between c.fyear-8 and c.fyear-1;
quit;
data ts_ctrl_train;
  set ts_ctrl_train0;
  if nmiss(ta_s,inv_at,rev_s,ppe_s)=0;
run;
proc sort data=ts_ctrl_train;
  by gvkey evyr fit_year;
run;
ods select none;
ods output NObs=ts_ctrl_nobs;
proc reg data=ts_ctrl_train outest=ts_ctrl_out edf;
  by gvkey evyr;
  model ta_s=inv_at rev_s ppe_s / noint;
quit;
ods output close;
ods select all;
proc sql;
  create table ts_ctrl_ok as
  select o.gvkey, o.evyr, o.inv_at as bts_inv, o.rev_s as bts_rev,
         o.ppe_s as bts_ppe, o._P_ as fit_rank, o._IN_ as input_regressors,
         o._EDF_ as error_df, n.NObsUsed as n_used
  from ts_ctrl_out as o
  inner join ts_ctrl_nobs as n
    on o.gvkey=n.gvkey and o.evyr=n.evyr
  where o._TYPE_='PARMS' and o._P_=3 and o._IN_=3 and
        n.Label='Number of Observations Used' and n.NObsUsed=8;
quit;
proc sql;
  create table control_score0 as
  select c.*, t.bts_inv, t.bts_rev, t.bts_ppe,
         s.bcs_inv, s.bcs_rev, s.bcs_ppe
  from control_pool0 as c
  left join ts_ctrl_ok as t
    on c.gvkey=t.gvkey and c.fyear=t.evyr
  left join cs_ok as s
    on c.fyear=s.fyear and c.sic2=s.sic2;
quit;
data control_pool;
  set control_score0;
  length da_ts_j da_ts_mj da_cs_j da_cs_mj 8;
  da_ts_j=.; da_ts_mj=.; da_cs_j=.; da_cs_mj=.;
  if nmiss(ta_s,inv_at,rev_s,ppe_s,bts_inv,bts_rev,bts_ppe)=0 then do;
    da_ts_j=ta_s-(bts_inv*inv_at+bts_rev*rev_s+bts_ppe*ppe_s);
    if not missing(rec_s) then da_ts_mj=ta_s-(bts_inv*inv_at+bts_rev*(rev_s-rec_s)+bts_ppe*ppe_s);
  end;
  if nmiss(ta_s,inv_at,rev_s,ppe_s,bcs_inv,bcs_rev,bcs_ppe)=0 then do;
    da_cs_j=ta_s-(bcs_inv*inv_at+bcs_rev*rev_s+bcs_ppe*ppe_s);
    if not missing(rec_s) then da_cs_mj=ta_s-(bcs_inv*inv_at+bcs_rev*(rev_s-rec_s)+bcs_ppe*ppe_s);
  end;
  if nmiss(da_ts_j,da_ts_mj,da_cs_j,da_cs_mj)=0;
run;
proc sql;
  select count(*) as controls_with_all_da from control_pool;
  create table candidate_pairs as
  select a.caseid, a.fyear, a.gvkey as casegvkey,
         c.gvkey as ctrlgvkey, a.sic2, a.big6,
         a.at_usd as case_at_usd, c.at_usd as ctrl_at_usd,
         abs(a.at_usd-c.at_usd) as asset_dist
  from cases_matchable as a
  inner join control_pool as c
    on a.fyear=c.fyear and a.sic2=c.sic2 and a.big6=c.big6;
  select count(*) as eligible_common_control_rows from control_pool;
  select count(*) as candidate_control_pairs,
         count(distinct caseid) as cases_with_candidates
  from candidate_pairs;
quit;
proc sort data=candidate_pairs;
  by fyear caseid asset_dist ctrlgvkey;
run;

/* Greedy nearest-asset matching in case order; a control firm-year is used once.
   Ties use the lowest character GVKEY. A firm may appear in another event year. */
data matches;
  if _n_=1 then do;
    declare hash used();
    used.defineKey('fyear','ctrlgvkey');
    used.defineDone();
  end;
  set candidate_pairs;
  by fyear caseid;
  retain chosen;
  if first.caseid then chosen=0;
  if chosen=0 and used.check() ne 0 then do;
    rc=used.add();
    chosen=1;
    pairid=caseid;
    output;
  end;
  keep pairid caseid fyear casegvkey ctrlgvkey sic2 big6 case_at_usd ctrl_at_usd asset_dist;
run;
proc sql;
  select count(*) as matched_pairs,
         count(distinct caseid) as matched_cases,
         sum(asset_dist=0) as exact_asset_matches
  from matches;
quit;

/* Retain both case and control rows; supporting accrual models use full populations. */
proc sql;
  create table selected_case as
  select m.pairid, m.caseid, m.fyear, e.gvkey, 1 as audit,
         e.sic2, e.sic2_source, e.big6, e.curcd, e.curcdm,
         e.price_curcd, e.price_curcd_basis, e.funda_fx_type, e.funda_usd_type,
         e.price_fx_type, e.price_usd_type,
         e.bp, e.mktcap, e.de, e.perform, e.at_usd,
         e.ta_s, e.inv_at, e.rev_s, e.rec_s, e.ppe_s
  from matches as m
  inner join cases_matchable as e
    on m.caseid=e.caseid;
  create table selected_control as
  select m.pairid, m.caseid, m.fyear, e.gvkey, 0 as audit,
         e.sic2, e.sic2_source, e.big6, e.curcd, e.curcdm,
         e.price_curcd, e.price_curcd_basis, e.funda_fx_type, e.funda_usd_type,
         e.price_fx_type, e.price_usd_type,
         e.bp, e.mktcap, e.de, e.perform, e.at_usd,
         e.ta_s, e.inv_at, e.rev_s, e.rec_s, e.ppe_s
  from matches as m
  inner join control_pool as e
    on m.ctrlgvkey=e.gvkey and m.fyear=e.fyear;
quit;
data selected_events;
  set selected_case selected_control;
run;

/* Time-series Jones support for all selected analysis firms, still using eight prior years. */
proc sql;
  create table ts_final_train0 as
  select e.gvkey, e.fyear as evyr, h.fyear as fit_year,
         h.ta_s, h.inv_at, h.rev_s, h.ppe_s
  from selected_events as e
  inner join metrics as h
    on e.gvkey=h.gvkey and h.fyear between e.fyear-8 and e.fyear-1;
quit;
data ts_final_train;
  set ts_final_train0;
  if nmiss(ta_s,inv_at,rev_s,ppe_s)=0;
run;
proc sort data=ts_final_train;
  by gvkey evyr fit_year;
run;
ods select none;
ods output NObs=ts_final_nobs;
proc reg data=ts_final_train outest=ts_final_out edf;
  by gvkey evyr;
  model ta_s=inv_at rev_s ppe_s / noint;
quit;
ods output close;
ods select all;
proc sql;
  create table ts_final_ok as
  select o.gvkey, o.evyr, o.inv_at as bts_inv, o.rev_s as bts_rev,
         o.ppe_s as bts_ppe, o._P_ as fit_rank, o._IN_ as input_regressors,
         o._EDF_ as error_df, n.NObsUsed as n_used
  from ts_final_out as o
  inner join ts_final_nobs as n
    on o.gvkey=n.gvkey and o.evyr=n.evyr
  where o._TYPE_='PARMS' and o._P_=3 and o._IN_=3 and
        n.Label='Number of Observations Used' and n.NObsUsed=8;
quit;

proc sql;
  create table score0 as
  select e.*, t.bts_inv, t.bts_rev, t.bts_ppe,
         c.bcs_inv, c.bcs_rev, c.bcs_ppe
  from selected_events as e
  left join ts_final_ok as t
    on e.gvkey=t.gvkey and e.fyear=t.evyr
  left join cs_ok as c
    on e.fyear=c.fyear and e.sic2=c.sic2;
quit;
data score;
  set score0;
  length da_tsj da_tsmj da_csj da_csmj abs_tsj abs_tsmj abs_csj abs_csmj 8;
  da_tsj=.; da_tsmj=.; da_csj=.; da_csmj=.;
  if nmiss(ta_s,inv_at,rev_s,ppe_s,bts_inv,bts_rev,bts_ppe)=0 then do;
    da_tsj=ta_s-(bts_inv*inv_at+bts_rev*rev_s+bts_ppe*ppe_s);
    if not missing(rec_s) then da_tsmj=ta_s-(bts_inv*inv_at+bts_rev*(rev_s-rec_s)+bts_ppe*ppe_s);
  end;
  if nmiss(ta_s,inv_at,rev_s,ppe_s,bcs_inv,bcs_rev,bcs_ppe)=0 then do;
    da_csj=ta_s-(bcs_inv*inv_at+bcs_rev*rev_s+bcs_ppe*ppe_s);
    if not missing(rec_s) then da_csmj=ta_s-(bcs_inv*inv_at+bcs_rev*(rev_s-rec_s)+bcs_ppe*ppe_s);
  end;
  abs_tsj=abs(da_tsj);
  abs_tsmj=abs(da_tsmj);
  abs_csj=abs(da_csj);
  abs_csmj=abs(da_csmj);
run;

/* Winsorize each continuous explanatory variable at pooled mean +/- 3 SD. */
proc means data=score noprint;
  var bp mktcap de perform abs_tsj abs_tsmj abs_csj abs_csmj;
  output out=win_stats
    n=n_bp n_mktcap n_de n_perform n_tsj n_tsmj n_csj n_csmj
    mean=mu_bp mu_mktcap mu_de mu_perform mu_tsj mu_tsmj mu_csj mu_csmj
    std=sd_bp sd_mktcap sd_de sd_perform sd_tsj sd_tsmj sd_csj sd_csmj;
run;
data reg;
  if _n_=1 then set win_stats;
  set score;
  if not missing(bp) and not missing(mu_bp) and not missing(sd_bp) then
    bp=min(max(bp,mu_bp-3*sd_bp),mu_bp+3*sd_bp);
  if not missing(mktcap) and not missing(mu_mktcap) and not missing(sd_mktcap) then
    mktcap=min(max(mktcap,mu_mktcap-3*sd_mktcap),mu_mktcap+3*sd_mktcap);
  if not missing(de) and not missing(mu_de) and not missing(sd_de) then
    de=min(max(de,mu_de-3*sd_de),mu_de+3*sd_de);
  if not missing(perform) and not missing(mu_perform) and not missing(sd_perform) then
    perform=min(max(perform,mu_perform-3*sd_perform),mu_perform+3*sd_perform);
  if not missing(abs_tsj) and not missing(mu_tsj) and not missing(sd_tsj) then
    abs_tsj=min(max(abs_tsj,mu_tsj-3*sd_tsj),mu_tsj+3*sd_tsj);
  if not missing(abs_tsmj) and not missing(mu_tsmj) and not missing(sd_tsmj) then
    abs_tsmj=min(max(abs_tsmj,mu_tsmj-3*sd_tsmj),mu_tsmj+3*sd_tsmj);
  if not missing(abs_csj) and not missing(mu_csj) and not missing(sd_csj) then
    abs_csj=min(max(abs_csj,mu_csj-3*sd_csj),mu_csj+3*sd_csj);
  if not missing(abs_csmj) and not missing(mu_csmj) and not missing(sd_csmj) then
    abs_csmj=min(max(abs_csmj,mu_csmj-3*sd_csmj),mu_csmj+3*sd_csmj);
run;

/* Audit each pair's model flags and one common Table 7 sample flag. */
proc sql;
  create table pair_fit as
  select pairid,
    sum(case when audit=1 and nmiss(bp,mktcap,de,perform,abs_tsj)=0 then 1 else 0 end) as n_case_tsj,
    sum(case when audit=0 and nmiss(bp,mktcap,de,perform,abs_tsj)=0 then 1 else 0 end) as n_ctrl_tsj,
    sum(case when audit=1 and nmiss(bp,mktcap,de,perform,abs_tsmj)=0 then 1 else 0 end) as n_case_tsmj,
    sum(case when audit=0 and nmiss(bp,mktcap,de,perform,abs_tsmj)=0 then 1 else 0 end) as n_ctrl_tsmj,
    sum(case when audit=1 and nmiss(bp,mktcap,de,perform,abs_csj)=0 then 1 else 0 end) as n_case_csj,
    sum(case when audit=0 and nmiss(bp,mktcap,de,perform,abs_csj)=0 then 1 else 0 end) as n_ctrl_csj,
    sum(case when audit=1 and nmiss(bp,mktcap,de,perform,abs_csmj)=0 then 1 else 0 end) as n_case_csmj,
    sum(case when audit=0 and nmiss(bp,mktcap,de,perform,abs_csmj)=0 then 1 else 0 end) as n_ctrl_csmj
  from reg group by pairid;
  create table pair_fit_flags as
  select pairid,
    (n_case_tsj=1 and n_ctrl_tsj=1) as fit_tsj,
    (n_case_tsmj=1 and n_ctrl_tsmj=1) as fit_tsmj,
    (n_case_csj=1 and n_ctrl_csj=1) as fit_csj,
    (n_case_csmj=1 and n_ctrl_csmj=1) as fit_csmj,
    (n_case_tsj=1 and n_ctrl_tsj=1 and
     n_case_tsmj=1 and n_ctrl_tsmj=1 and
     n_case_csj=1 and n_ctrl_csj=1 and
     n_case_csmj=1 and n_ctrl_csmj=1) as fit_common
  from pair_fit;
quit;
proc sql;
  create table reg_final0 as
  select r.*, f.fit_tsj, f.fit_tsmj, f.fit_csj, f.fit_csmj, f.fit_common
  from reg as r left join pair_fit_flags as f
    on r.pairid=f.pairid;
quit;
proc sort data=reg_final0;
  by pairid audit;
run;
data reg_final;
  set reg_final0;
  label audit='Audit Opinion (1=qualified)'
        bp='BP' mktcap='MKTCAP' de='DE' perform='PERFORM'
        abs_tsj='abs(DA), Time-Series Jones'
        abs_tsmj='abs(DA), Time-Series Modified Jones'
        abs_csj='abs(DA), Cross-Sectional Jones'
        abs_csmj='abs(DA), Cross-Sectional Modified Jones';
  keep pairid gvkey fyear audit sic2_source price_curcd_basis bp mktcap de perform
       abs_tsj abs_tsmj abs_csj abs_csmj fit_tsj fit_tsmj fit_csj fit_csmj fit_common;
run;

proc sql;
  create table dup_final as
  select pairid, audit, count(*) as n
  from reg_final group by pairid, audit having calculated n>1;
  select count(*) into :dup_final_count trimmed from dup_final;
  select count(*) as rows_in_handoff,
         count(distinct pairid) as matched_pairs,
         sum(fit_common=1 and audit=1) as common_cases,
         sum(fit_common=1 and audit=0) as common_controls,
         sum(audit=1) as qualified_rows,
         sum(audit=0) as clean_control_rows,
         sum(fit_tsj=1 and audit=1) as ts_jones_cases,
         sum(fit_tsj=1 and audit=0) as ts_jones_controls,
         sum(fit_tsmj=1 and audit=1) as ts_modified_cases,
         sum(fit_tsmj=1 and audit=0) as ts_modified_controls,
         sum(fit_csj=1 and audit=1) as cs_jones_cases,
         sum(fit_csj=1 and audit=0) as cs_jones_controls,
         sum(fit_csmj=1 and audit=1) as cs_modified_cases,
         sum(fit_csmj=1 and audit=0) as cs_modified_controls,
         sum(price_curcd_basis='HIID_CURCDM') as direct_price_currency_rows,
         sum(price_curcd_basis='CURCD_INFERRED') as inferred_price_currency_rows,
         sum(price_curcd_basis='UNAVAILABLE') as unavailable_price_currency_rows,
         sum(sic2_source='CRSP_DATED_HIID') as exact_hiid_sic_fallback_rows,
         sum(sic2_source='CRSP_DATED_COMPANY') as company_link_sic_fallback_rows,
         sum(sic2_source='FUNDA_SICH') as funda_sich_rows,
         sum(fit_tsj=1 and price_curcd_basis='CURCD_INFERRED') as ts_jones_inferred_currency_rows,
         sum(fit_tsmj=1 and price_curcd_basis='CURCD_INFERRED') as tsmod_inf_cur_rows,
         sum(fit_csj=1 and price_curcd_basis='CURCD_INFERRED') as cs_jones_inferred_currency_rows,
         sum(fit_csmj=1 and price_curcd_basis='CURCD_INFERRED') as csmod_inf_cur_rows
  from reg_final;
quit;
%failif_positive(&dup_final_count,Matched analysis handoff key pairid-audit is not unique.)
proc freq data=reg_final;
  tables fyear*audit fit_tsj fit_tsmj fit_csj fit_csmj fit_common
         price_curcd_basis*audit sic2_source*audit / missing;
  title 'Matched sample support and currency/SIC-source provenance';
run;
proc means data=reg_final n mean std median min max;
  class audit;
  var bp mktcap de perform abs_tsj abs_tsmj abs_csj abs_csmj;
  title 'Matched sample descriptive statistics after pooled three-SD winsorization';
run;

/* Final bounded scale check reaches the handoff variables after all assignments. */
proc means data=reg_final n mean std min max;
  var bp mktcap de perform abs_tsj abs_tsmj abs_csj abs_csmj;
  title 'Final regression input scale check';
run;

data out.reg;
  set reg_final;
run;
