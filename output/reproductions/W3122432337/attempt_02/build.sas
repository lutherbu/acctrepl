options errorabend mprint mlogic symbolgen;
libname comp '/storage/sas/base/comp/d_na' access=readonly;
libname ibes '/storage/sas/base/ibes' access=readonly;
libname sec '/storage/sas/base/comp/d_na/security' access=readonly;
libname fxsrc '/storage/sas/base/comp/d_global/currency' access=readonly;
libname crspstk '/storage/sas/base/crsp/a_stock' access=readonly;
libname crspccm '/storage/sas/base/crsp/a_ccm' access=readonly;
libname outval 'data/table2_valuation';
libname outinfo 'data/table3_information';

/* Restrict the Compustat population first; reject duplicate firm-quarter keys. */
data work.q_raw;
  set comp.fundq(keep=gvkey datadate fyearq fqtr fyr indfmt consol popsrc datafmt curcdq
    ceqq cshprq epspiq epspxq opepsq rdq iid hiid ajexq
    where=(datadate ge '01JAN1989'd and datadate le '31DEC1997'd
      and indfmt='INDL' and consol='C' and popsrc='D' and datafmt='STD'));
  if missing(gvkey) or missing(datadate) then delete;
run;
proc sql;
  create table work.q_counts as
  select gvkey, datadate, count(*) as n_source_rows
  from work.q_raw group by gvkey, datadate;
  create table work.q_unique as
  select a.* from work.q_raw as a inner join work.q_counts as b
    on a.gvkey=b.gvkey and a.datadate=b.datadate
  where b.n_source_rows=1;
  select count(*) as rows_after_descriptor_screens,
    sum(n_source_rows ne 1) as duplicate_firm_quarter_keys
    from work.q_counts;
quit;

/* GBP-primary exchange factors. No provider rate-type filter is applied. Each horizon
   is validated separately so an unused missing/ambiguous leg does not remove a usable one. */
data work.fx_d0;
  set fxsrc.g_exrt_dly(keep=datadate fromcurd tocurd exratd
    where=(datadate ge '01JAN1988'd and datadate le '31DEC1999'd
      and upcase(strip(fromcurd))='GBP' and exratd>0));
  length currency $4;
  currency=upcase(strip(tocurd));
  keep datadate currency exratd;
run;
proc sql;
  create table work.fx_dly_pair as
  select a.datadate,a.currency,a.exratd as source_rate,b.exratd as usd_rate
  from work.fx_d0 as a inner join work.fx_d0 as b
    on a.datadate=b.datadate and b.currency='USD';
  create table work.fx_dly_unique as
  select datadate,currency,count(distinct source_rate) as n_source_rates,
    count(distinct usd_rate) as n_usd_rates,min(source_rate) as source_rate,
    min(usd_rate) as usd_rate
  from work.fx_dly_pair group by datadate,currency;
  create table work.fx_dly as
  select datadate,currency,
    case when currency='USD' then 1 else usd_rate/source_rate end as usd_factor
  from work.fx_dly_unique
  where currency not in ('GBP','USD') and n_source_rates=1 and n_usd_rates=1
    and source_rate>0 and usd_rate>0
  union all
  select datadate,'USD' as currency length=4,1 as usd_factor
  from work.fx_dly_unique where currency='USD' and n_usd_rates=1 and usd_rate>0
  union all
  select datadate,'GBP' as currency length=4,usd_rate as usd_factor
  from work.fx_dly_unique where currency='USD' and n_usd_rates=1 and usd_rate>0;
quit;
data work.fx_m0;
  set fxsrc.g_exrt_mth(keep=datadate fromcurm tocurm exrat1m exrat3m exrat12m
    where=(datadate ge '01JAN1988'd and datadate le '31DEC1999'd
      and upcase(strip(fromcurm))='GBP'));
  length currency $4;
  currency=upcase(strip(tocurm));
  keep datadate currency exrat1m exrat3m exrat12m;
run;
proc sql;
  create table work.fx_m_pair as
  select a.datadate,a.currency,a.exrat1m as source1,b.exrat1m as usd1,
    a.exrat3m as source3,b.exrat3m as usd3,a.exrat12m as source12,b.exrat12m as usd12
  from work.fx_m0 as a inner join work.fx_m0 as b
    on a.datadate=b.datadate and b.currency='USD';
  create table work.fx_m_unique as
  select datadate,currency,count(distinct source1) as n_source1,
    count(distinct usd1) as n_usd1,min(source1) as source1,min(usd1) as usd1,
    count(distinct source3) as n_source3,count(distinct usd3) as n_usd3,
    min(source3) as source3,min(usd3) as usd3,
    count(distinct source12) as n_source12,count(distinct usd12) as n_usd12,
    min(source12) as source12,min(usd12) as usd12
  from work.fx_m_pair group by datadate,currency;
  create table work.fx_mth as
  select datadate,currency,
    case when currency='USD' then 1
      when n_source1=1 and n_usd1=1 and source1>0 and usd1>0 then usd1/source1 else . end as usd_factor_1m,
    case when currency='USD' then 1
      when n_source3=1 and n_usd3=1 and source3>0 and usd3>0 then usd3/source3 else . end as usd_factor_3m,
    case when currency='USD' then 1
      when n_source12=1 and n_usd12=1 and source12>0 and usd12>0 then usd12/source12 else . end as usd_factor_12m
  from work.fx_m_unique where currency not in ('GBP','USD')
  union all
  select datadate,'USD' as currency length=4,1 as usd_factor_1m,1 as usd_factor_3m,1 as usd_factor_12m
  from work.fx_m_unique where currency='USD'
  union all
  select datadate,'GBP' as currency length=4,
    case when n_usd1=1 and usd1>0 then usd1 else . end as usd_factor_1m,
    case when n_usd3=1 and usd3>0 then usd3 else . end as usd_factor_3m,
    case when n_usd12=1 and usd12>0 then usd12 else . end as usd_factor_12m
  from work.fx_m_unique where currency='USD';
quit;
proc sql;
  select count(*) as daily_currency_date_rows,count(distinct currency) as daily_currencies,
    sum(n_source_rates ne 1 or n_usd_rates ne 1) as daily_rate_ambiguities
    from work.fx_dly_unique;
  select count(*) as monthly_currency_date_rows,count(distinct currency) as monthly_currencies,
    sum(n_source1 ne 1 or n_usd1 ne 1) as monthly_1m_ambiguities,
    sum(n_source3 ne 1 or n_usd3 ne 1) as monthly_3m_ambiguities,
    sum(n_source12 ne 1 or n_usd12 ne 1) as monthly_12m_ambiguities
    from work.fx_m_unique;
quit;

/* Dated security-price inputs; retain the month-end quote date and currency. */
data work.sec_mth0;
  set sec.sec_mth(keep=gvkey iid datadate primiss
    where=(datadate ge '01JAN1988'd and datadate le '31DEC1999'd));
  length marker $2;
  monthkey=intnx('month',datadate,0,'end');
  marker=upcase(strip(primiss));
  keep gvkey iid datadate monthkey marker;
run;
proc sql;
  create table work.sec_price_raw as
  select a.gvkey, a.iid, a.monthkey, b.datadate as quote_date,
    a.marker, b.prccm, upcase(strip(b.curcdm)) as curcdm length=4
  from work.sec_mth0 as a inner join sec.sec_mthprc as b
    on a.gvkey=b.gvkey and a.iid=b.iid and a.datadate=b.datadate
  where b.datadate ge '01JAN1988'd and b.datadate le '31DEC1999'd
    and b.prccm>0 and not missing(b.curcdm);
  create table work.sec_price_counts as
  select gvkey, iid, monthkey, count(*) as n_quotes,
    count(distinct quote_date) as n_dates, count(distinct prccm) as n_prices,
    count(distinct curcdm) as n_currencies
  from work.sec_price_raw group by gvkey, iid, monthkey;
  create table work.sec_price as
  select a.* from work.sec_price_raw as a inner join work.sec_price_counts as b
    on a.gvkey=b.gvkey and a.iid=b.iid and a.monthkey=b.monthkey
  where b.n_quotes=1;
  create table work.primary_marker as
  select distinct gvkey, iid, monthkey from work.sec_mth0 where marker='P';
  select count(*) as issue_month_keys, sum(n_quotes ne 1) as ambiguous_issue_month_prices
    from work.sec_price_counts;
quit;

/* Select each price role at its own target month. A unique contemporaneous P wins.
   With an absent marker only, continuity is accepted if the same issue is P in both
   immediately adjacent months. Quarter HIID is audit evidence only, never a role-date key. */
%macro build_price_role(role=,offset=,out=);
  proc sql;
    create table work.&role._cand as
    select q.gvkey, q.datadate, q.hiid, intnx('month',q.datadate,&offset,'end') as target_month,
      p.iid, p.quote_date, p.curcdm, p.prccm, p.marker,
      case when p.iid ne '' and prev.iid ne '' and next.iid ne '' then 1 else 0 end as continuity_support
    from work.q_unique as q left join work.sec_price as p
      on q.gvkey=p.gvkey and intnx('month',q.datadate,&offset,'end')=p.monthkey
    left join work.primary_marker as prev
      on p.gvkey=prev.gvkey and p.iid=prev.iid
      and prev.monthkey=intnx('month',p.monthkey,-1,'end')
    left join work.primary_marker as next
      on p.gvkey=next.gvkey and p.iid=next.iid
      and next.monthkey=intnx('month',p.monthkey,1,'end');
    create table work.&role._count as
    select gvkey, datadate, sum(marker='P') as n_primary,
      sum(missing(strip(marker)) and continuity_support=1) as n_supported_blank,
      count(iid) as n_quoted_issues
    from work.&role._cand group by gvkey, datadate;
    create table work.&role._eligible as
    select c.* from work.&role._cand as c inner join work.&role._count as n
      on c.gvkey=n.gvkey and c.datadate=n.datadate
    where (n.n_primary=1 and c.marker='P')
       or (n.n_primary=0 and n.n_supported_blank=1 and missing(strip(c.marker))
            and c.continuity_support=1);
    create table work.&role._selected as
    select c.*, n.n_primary, n.n_supported_blank, n.n_quoted_issues,
      case when c.marker='P' then 'DATE_P' else 'ADJACENT_P_CONTINUITY' end as price_route length=28,
      (not missing(c.hiid) and c.iid ne c.hiid) as differs_from_quarter_hiid
    from work.&role._eligible as c inner join work.&role._count as n
      on c.gvkey=n.gvkey and c.datadate=n.datadate;
    create table work.&role._unique as
    select gvkey, datadate, count(*) as n_selected from work.&role._selected
      group by gvkey, datadate;
    create table work.&role as
    select a.gvkey, a.datadate, a.iid as &role._iid, a.quote_date as &role._date,
      a.curcdm as &role._currency, a.prccm as &role._price,
      a.price_route as &role._route, a.differs_from_quarter_hiid as &role._hiid_diff,
      a.n_primary as &role._n_primary, a.n_quoted_issues as &role._n_issues
    from work.&role._selected as a inner join work.&role._unique as b
      on a.gvkey=b.gvkey and a.datadate=b.datadate
    where b.n_selected=1;
    select count(*) as &role._selected_rows,
      sum(&role._hiid_diff=1) as &role._hiid_diff_count
      from work.&role;
  quit;
%mend;
%build_price_role(role=price3,offset=3,out=work.price3);
%build_price_role(role=price0,offset=-3,out=work.price0);

/* Effective-dated CUSIP-to-issue links for I/B/E/S company-level rows. */
data work.cusip_hist0;
  set sec.sec_idhist(keep=gvkey iid item itemvalue efffrom effthru
    where=(upcase(strip(item))='CUSIP'));
  length cusip8 $8;
  if missing(itemvalue) then delete;
  cusip8=substr(strip(itemvalue),1,8);
  if missing(cusip8) then delete;
  if missing(efffrom) then efffrom='01JAN1900'd;
  if missing(effthru) then effthru='31DEC9999'd;
  keep gvkey iid cusip8 efffrom effthru;
run;

/* Use unadjusted ACTU; its share basis is the announcement/report date. */
data work.act_scope;
  set ibes.actu_epsus(keep=ticker cusip pends measure pdicity anndats actdats value curr_act usfirm);
  where upcase(strip(measure))='EPS' and upcase(strip(pdicity))='QTR' and usfirm=1
    and pends ge '01JAN1989'd and pends le '31DEC1997'd and not missing(value);
  length cusip8 $8;
  if missing(cusip) or missing(curr_act) then delete;
  cusip8=substr(cusip,1,8); mapdate=coalesce(anndats,actdats,pends);
  keep ticker cusip8 pends anndats actdats mapdate value curr_act;
run;
proc sql;
  create table work.act_mapped0 as
  select distinct q.gvkey,q.datadate,q.rdq,q.hiid,a.ticker,a.anndats,a.actdats,
    a.value as street_raw,upcase(strip(a.curr_act)) as street_currency length=3,
    h.iid as actual_iid length=4
  from work.act_scope as a inner join work.cusip_hist0 as h
    on a.cusip8=h.cusip8 and a.mapdate ge h.efffrom and a.mapdate le h.effthru
  inner join work.q_unique as q on q.gvkey=h.gvkey and q.datadate=a.pends;
  create table work.act_first_ann as
  select gvkey,datadate,ticker,min(anndats) as first_ann
  from work.act_mapped0 group by gvkey,datadate,ticker;
  create table work.act_at_first_ann as
  select a.* from work.act_mapped0 as a inner join work.act_first_ann as b
    on a.gvkey=b.gvkey and a.datadate=b.datadate and a.ticker=b.ticker and a.anndats=b.first_ann;
  create table work.act_first_actdats as
  select gvkey,datadate,ticker,anndats,min(actdats) as first_actdats
  from work.act_at_first_ann group by gvkey,datadate,ticker,anndats;
  create table work.act_record_stats as
  select a.gvkey,a.datadate,a.ticker,a.anndats,a.actdats,
    count(distinct a.street_raw) as n_values,count(distinct a.street_currency) as n_currencies,
    count(distinct a.actual_iid) as n_issues,min(a.street_raw) as street_raw,
    min(a.street_currency) as street_currency,min(a.actual_iid) as actual_iid
  from work.act_at_first_ann as a inner join work.act_first_actdats as b
    on a.gvkey=b.gvkey and a.datadate=b.datadate and a.ticker=b.ticker
      and a.anndats=b.anndats and a.actdats=b.first_actdats
  group by a.gvkey,a.datadate,a.ticker,a.anndats,a.actdats;
  create table work.act_candidates as select * from work.act_record_stats
    where n_values=1 and n_currencies=1 and n_issues=1;
  create table work.act_key_counts as
  select gvkey,datadate,count(distinct ticker) as n_tickers,
    count(distinct actual_iid) as n_issues from work.act_candidates group by gvkey,datadate;
  create table work.actual as
  select a.* from work.act_candidates as a inner join work.act_key_counts as c
    on a.gvkey=c.gvkey and a.datadate=c.datadate where c.n_tickers=1 and c.n_issues=1;
  select count(*) as unique_actual_firm_quarters,
    sum(n_tickers ne 1 or n_issues ne 1) as ambiguous_actual_firm_quarters
  from work.act_key_counts;
quit;

/* Exact adjusted/unadjusted ACT pairs audit product scale and currencies only. */
data work.act_adj_scope;
  set ibes.act_epsus(keep=ticker pends measure pdicity anndats actdats value curr_act usfirm);
  where upcase(strip(measure))='EPS' and upcase(strip(pdicity))='QTR' and usfirm=1
    and pends ge '01JAN1989'd and pends le '31DEC1997'd and not missing(value);
  curr_act=upcase(strip(curr_act)); keep ticker pends anndats actdats value curr_act;
run;
proc sql;
  create table work.act_adj_exact as
  select ticker,pends,anndats,actdats,curr_act,count(distinct value) as n_values,
    min(value) as adjusted_value from work.act_adj_scope
  group by ticker,pends,anndats,actdats,curr_act;
  create table work.actual_product_check as
  select a.gvkey,a.datadate,a.ticker,a.anndats,a.actdats,a.street_raw,a.street_currency,
    b.adjusted_value,b.n_values as n_adjusted
  from work.actual as a left join work.act_adj_exact as b
    on a.ticker=b.ticker and a.datadate=b.pends and a.anndats=b.anndats
      and a.actdats=b.actdats and a.street_currency=b.curr_act;
  select count(*) as raw_actual_rows,sum(n_adjusted=1) as exact_adjusted_pairs,
    sum(n_adjusted>1) as ambiguous_adjusted_pairs from work.actual_product_check;
  select sum(n_adjusted=1 and adjusted_value ne street_raw) as nonunit_adjustment_pairs
    from work.actual_product_check;
quit;
data work.actual_product_ratio;
  set work.actual_product_check;
  if n_adjusted=1 and abs(street_raw)>.001 then product_ratio=adjusted_value/street_raw;
run;
proc means data=work.actual_product_ratio n mean median p25 p75; var product_ratio; run;

/* Latest unadjusted mean primary consensus strictly before RDQ; its basis is STATPERS. */
data work.sum_scope;
  set ibes.statsumu_epsus(keep=ticker cusip statpers measure fiscalp estflag curcode meanest usfirm fpedats);
  where upcase(strip(measure))='EPS' and upcase(strip(fiscalp))='QTR'
    and upcase(strip(estflag))='P' and usfirm=1 and fpedats ge '01JAN1989'd
    and fpedats le '31DEC1997'd and not missing(meanest) and not missing(statpers);
  length cusip8 $8;
  if missing(cusip) or missing(curcode) then delete;
  cusip8=substr(cusip,1,8); curcode=upcase(strip(curcode));
  keep ticker cusip8 statpers fpedats meanest curcode;
run;
proc sql;
  create table work.sum_mapped0 as
  select q.gvkey,q.datadate,q.rdq,a.ticker,s.statpers,s.meanest as forecast_raw,
    s.curcode as forecast_currency length=3,h.iid as forecast_iid length=4
  from work.sum_scope as s inner join work.cusip_hist0 as h
    on s.cusip8=h.cusip8 and s.statpers ge h.efffrom and s.statpers le h.effthru
  inner join work.actual as a on a.gvkey=h.gvkey and a.datadate=s.fpedats and a.ticker=s.ticker
  inner join work.q_unique as q on q.gvkey=a.gvkey and q.datadate=a.datadate
  where s.statpers<q.rdq;
  create table work.sum_period as
  select gvkey,datadate,ticker,statpers,count(distinct forecast_raw) as n_means,
    count(distinct forecast_currency) as n_currencies,count(distinct forecast_iid) as n_issues,
    min(forecast_raw) as forecast_raw,min(forecast_currency) as forecast_currency,
    min(forecast_iid) as forecast_iid
  from work.sum_mapped0 group by gvkey,datadate,ticker,statpers;
quit;
/* Select the latest mapped ticker-period STATPERS first. If that date is ambiguous,
   it stays unsupported; do not fall back to an earlier consensus date. */
proc sort data=work.sum_period out=work.sum_period_sorted;
  by gvkey datadate descending statpers;
run;
data work.forecast_latest;
  set work.sum_period_sorted;
  by gvkey datadate;
  if first.datadate;
run;
proc sql;
  select count(*) as quarters_with_pre_rdq_consensus,
    sum(n_means=1 and n_currencies=1 and n_issues=1) as unambiguous_latest_consensus,
    sum(n_means ne 1) as latest_mean_ambiguity,
    sum(n_currencies ne 1) as latest_currency_ambiguity,
    sum(n_issues ne 1) as latest_issue_ambiguity
  from work.forecast_latest;
quit;
data work.forecast;
  set work.forecast_latest;
  if n_means=1 and n_currencies=1 and n_issues=1;
run;

/* Exact adjusted/unadjusted Summary matches audit split products and currencies. */
data work.sum_adj_scope;
  set ibes.statsum_epsus(keep=ticker statpers measure fiscalp estflag curcode meanest usfirm fpedats);
  where upcase(strip(measure))='EPS' and upcase(strip(fiscalp))='QTR'
    and upcase(strip(estflag))='P' and usfirm=1 and not missing(meanest);
  curcode=upcase(strip(curcode)); keep ticker statpers fpedats curcode meanest;
run;
proc sql;
  create table work.sum_adj_exact as
  select ticker,fpedats,statpers,curcode,count(distinct meanest) as n_means,
    min(meanest) as adjusted_mean from work.sum_adj_scope
  group by ticker,fpedats,statpers,curcode;
  create table work.forecast_product_check as
  select f.gvkey,f.datadate,f.ticker,f.statpers,f.forecast_raw,f.forecast_currency,
    a.adjusted_mean,a.n_means from work.forecast as f left join work.sum_adj_exact as a
  on f.ticker=a.ticker and f.datadate=a.fpedats and f.statpers=a.statpers and f.forecast_currency=a.curcode;
  select count(*) as raw_forecast_rows,sum(n_means=1) as exact_adjusted_pairs,
    sum(n_means>1) as ambiguous_adjusted_pairs from work.forecast_product_check;
  select sum(n_means=1 and adjusted_mean ne forecast_raw) as nonunit_adjustment_pairs
    from work.forecast_product_check;
quit;
data work.forecast_product_ratio;
  set work.forecast_product_check;
  if n_means=1 and abs(forecast_raw)>.001 then product_ratio=adjusted_mean/forecast_raw;
run;
proc means data=work.forecast_product_ratio n mean median p25 p75; var product_ratio; run;

/* Bounded source-date AJEXDI requests; missing source dates remain unsupported. */
data work.req_anchor;
  set work.q_unique(keep=gvkey datadate hiid);
  length req_role $8 issue_iid $4; req_role='ANCHOR';issue_iid=hiid;obsdate=datadate;
  keep gvkey datadate req_role issue_iid obsdate;
run;
data work.req_street;
  set work.actual(keep=gvkey datadate actual_iid anndats);
  length req_role $8 issue_iid $4;req_role='STREET';issue_iid=actual_iid;obsdate=anndats;
  keep gvkey datadate req_role issue_iid obsdate;
run;
data work.req_forecast;
  set work.forecast(keep=gvkey datadate forecast_iid statpers);
  length req_role $8 issue_iid $4;req_role='FORECAST';issue_iid=forecast_iid;obsdate=statpers;
  keep gvkey datadate req_role issue_iid obsdate;
run;
data work.req_price3;
  set work.price3(keep=gvkey datadate price3_iid price3_date);
  length req_role $8 issue_iid $4;req_role='PRICE3';issue_iid=price3_iid;obsdate=price3_date;
  keep gvkey datadate req_role issue_iid obsdate;
run;
data work.req_price0;
  set work.price0(keep=gvkey datadate price0_iid price0_date);
  length req_role $8 issue_iid $4;req_role='PRICE0';issue_iid=price0_iid;obsdate=price0_date;
  keep gvkey datadate req_role issue_iid obsdate;
run;
data work.factor_req;
  set work.req_anchor work.req_street work.req_forecast work.req_price3 work.req_price0;
  if missing(gvkey) or missing(issue_iid) or missing(obsdate) then delete;
run;
proc sql;
  create table work.factor_candidates as
  select r.gvkey,r.datadate,r.req_role,r.issue_iid,r.obsdate,
    d.datadate as factor_date format=date9.,d.ajexdi as share_factor
  from work.factor_req as r left join sec.sec_dprc as d
    on r.gvkey=d.gvkey and r.issue_iid=d.iid and d.datadate le r.obsdate
      and d.datadate ge r.obsdate-7 and d.datadate ge '01JAN1988'd
      and d.datadate le '31DEC1999'd and d.ajexdi>0;
  create table work.factor_latest as
  select gvkey,datadate,req_role,issue_iid,obsdate,max(factor_date) as factor_date format=date9.
  from work.factor_candidates group by gvkey,datadate,req_role,issue_iid,obsdate;
  create table work.factor_values as
  select a.gvkey,a.datadate,a.req_role,a.issue_iid,a.obsdate,a.factor_date,
    count(distinct b.share_factor) as n_factors,min(b.share_factor) as share_factor
  from work.factor_latest as a left join work.factor_candidates as b
    on a.gvkey=b.gvkey and a.datadate=b.datadate and a.req_role=b.req_role
      and a.issue_iid=b.issue_iid and a.obsdate=b.obsdate and a.factor_date=b.factor_date
  group by a.gvkey,a.datadate,a.req_role,a.issue_iid,a.obsdate,a.factor_date;
  select req_role,count(*) as role_rows,sum(n_factors=1) as unique_factor_rows,
    sum(n_factors=1 and share_factor ne 1) as nonunit_factor_rows,
    min(share_factor) as minimum_factor,max(share_factor) as maximum_factor
  from work.factor_values group by req_role;
quit;
%macro split_factor_role(role=,out=,prefix=);
  data &out;
    set work.factor_values(where=(req_role="&role"));
    &prefix._factor=share_factor;&prefix._date=factor_date;&prefix._n=n_factors;&prefix._iid=issue_iid;
    keep gvkey datadate &prefix._factor &prefix._date &prefix._n &prefix._iid;
  run;
%mend;
%split_factor_role(role=ANCHOR,out=work.factor_anchor,prefix=anchor);
%split_factor_role(role=STREET,out=work.factor_street,prefix=street);
%split_factor_role(role=FORECAST,out=work.factor_forecast,prefix=forecast);
%split_factor_role(role=PRICE3,out=work.factor_price3,prefix=price3);
%split_factor_role(role=PRICE0,out=work.factor_price0,prefix=price0);
proc sql;
  create table work.share_basis as
  select q.gvkey,q.datadate,q.hiid,q.ajexq,a.anchor_factor,a.anchor_date,a.anchor_n,a.anchor_iid
  from work.q_unique as q left join work.factor_anchor as a
    on q.gvkey=a.gvkey and q.datadate=a.datadate;
quit;
data work.share_basis;
  set work.share_basis;
  anchor_iid_match=(not missing(hiid) and anchor_iid=hiid);
  ajexq_difference=abs(anchor_factor-ajexq);
  anchor_ok=(anchor_n=1 and anchor_iid_match=1 and anchor_factor>0 and ajexq>0
    and ajexq_difference le 1e-6*max(1,abs(anchor_factor)));
run;
proc sql;
  select count(*) as quarter_keys,sum(anchor_n=1) as unique_daily_anchor_factors,
    sum(anchor_ok=1) as anchor_factor_matches_ajexq,
    sum(not missing(anchor_factor) and not missing(ajexq) and anchor_ok=0) as ajexq_disagreements,
    sum(anchor_n=1 and anchor_factor ne 1) as nonunit_quarter_anchor_factors
  from work.share_basis;
quit;

proc sql;
  create table work.share_factor_wide as
  select a.*,s.street_factor,s.street_date,s.street_n,s.street_iid,
    f.forecast_factor,f.forecast_date,f.forecast_n,f.forecast_iid,
    p3.price3_factor,p3.price3_date as price3_factor_date,p3.price3_n,p3.price3_iid,
    p0.price0_factor,p0.price0_date as price0_factor_date,p0.price0_n,p0.price0_iid
  from work.share_basis as a
  left join work.factor_street as s on a.gvkey=s.gvkey and a.datadate=s.datadate
  left join work.factor_forecast as f on a.gvkey=f.gvkey and a.datadate=f.datadate
  left join work.factor_price3 as p3 on a.gvkey=p3.gvkey and a.datadate=p3.datadate
  left join work.factor_price0 as p0 on a.gvkey=p0.gvkey and a.datadate=p0.datadate;
quit;
data work.share_factor_wide;
  set work.share_factor_wide;
  street_iid_match=(not missing(hiid) and street_iid=hiid);
  forecast_iid_match=(not missing(hiid) and forecast_iid=hiid);
  price3_iid_match=(not missing(hiid) and price3_iid=hiid);
  price0_iid_match=(not missing(hiid) and price0_iid=hiid);
  street_basis_ok=(anchor_ok and street_n=1 and street_iid_match and street_factor>0);
  forecast_basis_ok=(anchor_ok and forecast_n=1 and forecast_iid_match and forecast_factor>0);
  price3_basis_ok=(anchor_ok and price3_n=1 and price3_iid_match and price3_factor>0);
  price0_basis_ok=(anchor_ok and price0_n=1 and price0_iid_match and price0_factor>0);
run;
proc sql;
  select count(*) as quarter_keys,sum(street_iid_match=1) as same_issue_actuals,
    sum(street_basis_ok=1) as supported_actual_bases,
    sum(forecast_iid_match=1) as same_issue_forecasts,
    sum(forecast_basis_ok=1) as supported_forecast_bases,
    sum(price3_iid_match=1) as same_issue_price3,
    sum(price3_basis_ok=1) as supported_price3_bases,
    sum(price0_iid_match=1) as same_issue_price0,
    sum(price0_basis_ok=1) as supported_price0_bases
  from work.share_factor_wide;
quit;

/* Fund currency: quarter-end EXRATD for equity and documented EXRAT12M for quarterly EPS. */
proc sql;
  create table work.eq_fx_date as
  select q.gvkey, q.datadate, upcase(strip(q.curcdq)) as currency length=4,
    max(x.datadate) as fxdate format=date9.
  from work.q_unique as q left join work.fx_dly as x
    on x.currency=upcase(strip(q.curcdq)) and x.datadate le q.datadate
      and x.datadate ge q.datadate-7
  group by q.gvkey, q.datadate, upcase(strip(q.curcdq));
  create table work.fq_currency as
  select q.*,b.anchor_factor,b.anchor_date,b.anchor_n,b.anchor_ok,b.ajexq_difference,
    coalesce(m.usd_factor_12m,case when upcase(strip(q.curcdq))='USD' then 1 else . end) as eps_usd_factor,
    coalesce(d.usd_factor,case when upcase(strip(q.curcdq))='USD' then 1 else . end) as equity_usd_factor
  from work.q_unique as q
  left join work.share_factor_wide as b on q.gvkey=b.gvkey and q.datadate=b.datadate
  left join work.fx_mth as m
    on intnx('month',q.datadate,0,'end')=m.datadate and upcase(strip(q.curcdq))=m.currency
  left join work.eq_fx_date as e on q.gvkey=e.gvkey and q.datadate=e.datadate
  left join work.fx_dly as d on e.fxdate=d.datadate and e.currency=d.currency;
quit;
data work.fundq_usd;
  set work.fq_currency;
  if not missing(ceqq) and not missing(equity_usd_factor) then equity_usd=ceqq*equity_usd_factor;
  if not missing(epspiq) and not missing(eps_usd_factor) then ni_usd=epspiq*eps_usd_factor;
  if not missing(epspxq) and not missing(eps_usd_factor) then gaap_usd=epspxq*eps_usd_factor;
  if not missing(opepsq) and not missing(eps_usd_factor) then epsop_usd=opepsq*eps_usd_factor;
  if not missing(cshprq) and cshprq>0 then bvps_usd=equity_usd/cshprq;
run;

/* Source-price FX uses the actual quote date/currency; monthly EXRAT1M is fallback. */
%macro add_price_usd(input=,output=,price=,date=,currency=,name=);
  proc sql;
    create table &output as
    select a.*, coalesce(d.usd_factor, m.usd_factor_1m,
      case when upcase(strip(a.&currency))='USD' then 1 else . end) as &name._fx
    from &input as a
    left join work.fx_dly as d
      on d.datadate=a.&date and d.currency=upcase(strip(a.&currency))
    left join work.fx_mth as m
      on m.datadate=intnx('month',a.&date,0,'end') and m.currency=upcase(strip(a.&currency));
  quit;
  data &output;
    set &output;
    if not missing(&price) and not missing(&name._fx) then &name._usd=&price*&name._fx;
  run;
%mend;
%add_price_usd(input=work.price3,output=work.price3_usd,price=price3_price,date=price3_date,
  currency=price3_currency,name=price3);
%add_price_usd(input=work.price0,output=work.price0_usd,price=price0_price,date=price0_date,
  currency=price0_currency,name=price0);

/* Unadjust ACTU/STATSUMU only by a same-IID factor ratio to quarter-end basis,
   then convert each value from its own IBES currency with EXRAT12M. */
proc sql;
  create table work.ibes_basis0 as
  select a.gvkey,a.datadate,q.hiid,a.ticker,a.anndats,a.actdats,a.actual_iid,
    a.street_raw,a.street_currency,s.forecast_raw,s.forecast_currency,s.forecast_iid,s.statpers,
    b.anchor_factor,b.anchor_date,b.anchor_n,b.anchor_ok,b.ajexq_difference,
    b.street_factor,b.street_date,b.street_n,b.street_iid,
    b.forecast_factor,b.forecast_date,b.forecast_n,b.forecast_iid as factor_forecast_iid
  from work.actual as a inner join work.q_unique as q on a.gvkey=q.gvkey and a.datadate=q.datadate
  left join work.forecast as s on a.gvkey=s.gvkey and a.datadate=s.datadate
  left join work.share_factor_wide as b on a.gvkey=b.gvkey and a.datadate=b.datadate;
quit;
data work.ibes_basis;
  set work.ibes_basis0;
  street_iid_match=(not missing(hiid) and actual_iid=hiid and street_iid=hiid);
  forecast_iid_match=(not missing(hiid) and forecast_iid=hiid and factor_forecast_iid=hiid);
  street_basis_ok=(anchor_ok and street_n=1 and street_iid_match and street_factor>0);
  forecast_basis_ok=(anchor_ok and forecast_n=1 and forecast_iid_match and forecast_factor>0);
  if street_basis_ok then street_basis_raw=street_raw*anchor_factor/street_factor;
  if forecast_basis_ok then forecast_basis_raw=forecast_raw*anchor_factor/forecast_factor;
run;
proc sql;
  select count(*) as actual_keys,sum(street_iid_match=1) as same_issue_actuals,
    sum(street_basis_ok=1) as rebased_actuals,
    sum(forecast_iid_match=1) as same_issue_forecasts,
    sum(forecast_basis_ok=1) as rebased_forecasts
  from work.ibes_basis;
  create table work.ibes_currency as
  select a.*,coalesce(fa.usd_factor_12m,case when a.street_currency='USD' then 1 else . end) as street_fx,
    coalesce(ff.usd_factor_12m,case when a.forecast_currency='USD' then 1 else . end) as forecast_fx
  from work.ibes_basis as a
  left join work.fx_mth as fa
    on intnx('month',a.datadate,0,'end')=fa.datadate and a.street_currency=fa.currency
  left join work.fx_mth as ff
    on intnx('month',a.datadate,0,'end')=ff.datadate and a.forecast_currency=ff.currency;
quit;
data work.ibes_usd;
  set work.ibes_currency;
  if street_basis_ok and not missing(street_basis_raw) and not missing(street_fx)
    then street_usd=street_basis_raw*street_fx;
  if forecast_basis_ok and not missing(forecast_basis_raw) and not missing(forecast_fx)
    then forecast_usd=forecast_basis_raw*forecast_fx;
run;

/* Price quotes keep their selected role-date issue. Only same-IID quotes receive a
   quarter-end share-basis ratio; different primary issues remain audited but unresolved. */
proc sql;
  create table work.price3_basis0 as
  select p.*,b.hiid,b.anchor_factor,b.anchor_date,b.anchor_n,b.anchor_ok,
    f.price3_factor,f.price3_date as price3_factor_date,f.price3_n,f.price3_iid as price3_factor_iid
  from work.price3_usd as p left join work.share_factor_wide as b
    on p.gvkey=b.gvkey and p.datadate=b.datadate
  left join work.factor_price3 as f on p.gvkey=f.gvkey and p.datadate=f.datadate;
  create table work.price0_basis0 as
  select p.*,b.hiid,b.anchor_factor,b.anchor_date,b.anchor_n,b.anchor_ok,
    f.price0_factor,f.price0_date as price0_factor_date,f.price0_n,f.price0_iid as price0_factor_iid
  from work.price0_usd as p left join work.share_factor_wide as b
    on p.gvkey=b.gvkey and p.datadate=b.datadate
  left join work.factor_price0 as f on p.gvkey=f.gvkey and p.datadate=f.datadate;
quit;
data work.price3_final;
  set work.price3_basis0;
  price3_basis_ok=(anchor_ok and price3_n=1 and price3_iid=hiid and price3_factor_iid=hiid and price3_factor>0);
  if price3_basis_ok then do;
    price3_share_ratio=anchor_factor/price3_factor;
    price3_usd=price3_usd*price3_share_ratio;
  end;
  else price3_usd=.;
run;
data work.price0_final;
  set work.price0_basis0;
  price0_basis_ok=(anchor_ok and price0_n=1 and price0_iid=hiid and price0_factor_iid=hiid and price0_factor>0);
  if price0_basis_ok then do;
    price0_share_ratio=anchor_factor/price0_factor;
    price0_usd=price0_usd*price0_share_ratio;
  end;
  else price0_usd=.;
run;
proc sql;
  select count(*) as role_price3_rows,sum(price3_basis_ok=1) as supported_price3_rows,
    sum(not missing(price3_iid) and price3_iid ne hiid) as selected_price3_different_issue
    from work.price3_final;
  select count(*) as role_price0_rows,sum(price0_basis_ok=1) as supported_price0_rows,
    sum(not missing(price0_iid) and price0_iid ne hiid) as selected_price0_different_issue
    from work.price0_final;
quit;

/* Apply common source groups in compatible USD EPS units at cent precision. */
proc sql;
  create table work.combined as
  select f.*,i.ticker,i.street_raw,i.street_currency,i.actual_iid,i.anndats,
    i.street_factor,i.street_date,i.street_basis_raw,i.street_basis_ok,i.street_usd,
    i.forecast_raw,i.forecast_currency,i.forecast_iid,i.statpers,
    i.forecast_factor,i.forecast_date,i.forecast_basis_raw,i.forecast_basis_ok,i.forecast_usd,
    p3.price3_iid, p3.price3_date, p3.price3_currency, p3.price3_price,
    p3.price3_route,p3.price3_hiid_diff,p3.price3_fx,p3.price3_usd,
    p3.price3_factor,p3.price3_factor_date,p3.price3_share_ratio,p3.price3_basis_ok,
    p0.price0_iid,p0.price0_date,p0.price0_currency,p0.price0_price,
    p0.price0_route,p0.price0_hiid_diff,p0.price0_fx,p0.price0_usd,
    p0.price0_factor,p0.price0_factor_date,p0.price0_share_ratio,p0.price0_basis_ok
  from work.fundq_usd as f
  left join work.ibes_usd as i on f.gvkey=i.gvkey and f.datadate=i.datadate
  left join work.price3_final as p3 on f.gvkey=p3.gvkey and f.datadate=p3.datadate
  left join work.price0_final as p0 on f.gvkey=p0.gvkey and f.datadate=p0.datadate;
quit;
data work.classified;
  set work.combined;
  if not missing(street_usd) and not missing(epsop_usd) and not missing(gaap_usd) then do;
    street_cent=round(street_usd,.01);
    epsop_cent=round(epsop_usd,.01);
    gaap_cent=round(gaap_usd,.01);
    if street_cent=epsop_cent then agreement_group=0;
    else if epsop_cent=gaap_cent and street_cent ne gaap_cent then agreement_group=1;
    else if street_cent ne gaap_cent and epsop_cent ne gaap_cent then agreement_group=2;
    else if street_cent=gaap_cent and epsop_cent ne gaap_cent then agreement_group=3;
  end;
  other_street_usd=ni_usd-street_usd;
  other_epsop_usd=ni_usd-epsop_usd;
  uop_street=(street_usd-forecast_usd)/price0_usd;
  uop_epsop=(epsop_usd-forecast_usd)/price0_usd;
  car=.;
run;
proc freq data=work.classified;
  tables agreement_group / missing;
run;

/* Table 2 has no CRSP or t-4 screen and uses Q11 NI per share. */
data outval.valuation;
  set work.classified;
  if agreement_group in (1,2,3);
  if nmiss(price3_usd,bvps_usd,street_usd,other_street_usd,epsop_usd,other_epsop_usd,
      ni_usd,equity_usd,cshprq)=0;
  keep gvkey datadate fyearq fqtr rdq hiid iid agreement_group
    price3_iid price3_date price3_currency price3_route price3_hiid_diff price3_price price3_fx price3_usd
    price3_factor price3_factor_date price3_share_ratio price3_basis_ok anchor_factor anchor_date anchor_ok ajexq_difference
    street_raw street_currency actual_iid anndats street_factor street_date street_basis_raw street_basis_ok street_usd
    forecast_raw forecast_currency forecast_iid statpers forecast_factor forecast_date forecast_basis_raw forecast_basis_ok
    epsop_usd ni_usd other_street_usd other_epsop_usd equity_usd cshprq bvps_usd
    epspiq epspxq opepsq curcdq eps_usd_factor equity_usd_factor;
run;

/* CRSP link valid at RDQ. Preserve .E/open endpoints and rank P before C. */
data work.link_scope;
  set crspccm.ccmxpf_linktable(keep=gvkey linkprim linktype lpermno linkdt linkenddt);
  where upcase(strip(linktype)) in ('LC','LU') and upcase(strip(linkprim)) in ('P','C')
    and not missing(lpermno);
run;
proc sql;
  create table work.link_candidates as
  select distinct q.gvkey, q.datadate, q.rdq, l.lpermno as permno, l.linkprim,
    case when upcase(strip(l.linkprim))='P' then 1 else 2 end as link_rank
  from work.q_unique as q inner join work.link_scope as l on q.gvkey=l.gvkey
  where (missing(l.linkdt) or l.linkdt le q.rdq)
    and (missing(l.linkenddt) or l.linkenddt ge q.rdq);
  create table work.link_best_rank as
  select gvkey, datadate, min(link_rank) as link_rank
  from work.link_candidates group by gvkey, datadate;
  create table work.link_best as
  select a.* from work.link_candidates as a inner join work.link_best_rank as b
    on a.gvkey=b.gvkey and a.datadate=b.datadate and a.link_rank=b.link_rank;
  create table work.link_counts as
  select gvkey, datadate, count(distinct permno) as n_permno, min(permno) as permno
  from work.link_best group by gvkey, datadate;
  create table work.link_unique as
  select distinct a.gvkey,a.datadate,a.rdq,a.permno from work.link_best as a
  inner join work.link_counts as b on a.gvkey=b.gvkey and a.datadate=b.datadate
  where b.n_permno=1;
  select count(*) as event_link_rows, sum(n_permno ne 1) as ambiguous_event_links
    from work.link_counts;
quit;

/* Event day zero is RDQ if CRSP trades, otherwise the first following session within 7 days. */
data work.dsi_window_raw;
  set crspstk.dsi(keep=date vwretd where=(date ge '01JAN1988'd and date le '31DEC1999'd));
run;
proc sql;
  create table work.dsi_day_count as select date,count(*) as n_rows,count(distinct vwretd) as n_market_values,
    min(vwretd) as vwretd from work.dsi_window_raw group by date;
  create table work.dsi_window as select date,vwretd from work.dsi_day_count where n_rows=1;
  select sum(n_rows ne 1 or n_market_values ne 1) as ambiguous_market_days from work.dsi_day_count;
quit;
proc sort data=work.dsi_window out=work.dsi_sorted;
  by date;
run;
data work.dsi_seq;
  set work.dsi_sorted;
  session=_n_;
run;
proc sql;
  create table work.event_day0 as
  select q.gvkey,q.datadate,q.rdq,min(d.date) as day0 format=date9.
  from work.q_unique as q left join work.dsi_seq as d
    on d.date ge q.rdq and d.date le q.rdq+7
  group by q.gvkey,q.datadate,q.rdq;
  create table work.event_day0_seq as
  select a.*, d.session as day0_session
  from work.event_day0 as a left join work.dsi_seq as d on a.day0=d.date;
  create table work.event_window as
  select e.gvkey,e.datadate,e.rdq,e.day0,e.day0_session,l.permno,
    d.date,d.session-e.day0_session as eventday,s.ret,d.vwretd
  from work.event_day0_seq as e inner join work.link_unique as l
    on e.gvkey=l.gvkey and e.datadate=l.datadate
  inner join work.dsi_seq as d on d.session between e.day0_session-1 and e.day0_session+1
  inner join crspstk.dsf as s on s.permno=l.permno and s.date=d.date
  where not missing(e.day0_session);
  create table work.event_stats as
  select gvkey,datadate,count(*) as n_rows,count(distinct eventday) as n_days,
    sum(ret-vwretd) as car
  from work.event_window
  where eventday in (-1,0,1) and not missing(ret) and not missing(vwretd)
  group by gvkey,datadate;
  select count(*) as event_windows, sum(n_days ne 3) as incomplete_event_windows
    from work.event_stats;
quit;

/* Table 3 requires event returns and beginning-quarter price, not Table 2 inputs. */
proc sql;
  create table work.info0 as
  select c.gvkey,c.datadate,c.fyearq,c.fqtr,c.rdq,c.hiid,c.iid,c.agreement_group,
    c.ticker,c.street_raw,c.street_currency,c.actual_iid,c.anndats,c.forecast_raw,c.forecast_currency,c.forecast_iid,c.statpers,
    c.street_usd,c.epsop_usd,c.forecast_usd,c.price0_iid,c.price0_date,c.price0_currency,
    c.price0_route,c.price0_hiid_diff,c.price0_price,c.price0_fx,c.price0_usd,
    c.price0_factor,c.price0_factor_date,c.price0_share_ratio,c.price0_basis_ok,
    c.anchor_factor,c.anchor_date,c.anchor_ok,c.ajexq_difference,
    c.street_factor,c.street_date,c.street_basis_raw,c.street_basis_ok,
    c.forecast_factor,c.forecast_date,c.forecast_basis_raw,c.forecast_basis_ok,
    e.car,e.n_days,e.n_rows
  from work.classified as c left join work.event_stats as e
    on c.gvkey=e.gvkey and c.datadate=e.datadate
  where c.agreement_group in (1,2,3);
quit;
data outinfo.information;
  set work.info0;
  if n_days=3 and n_rows=3 and nmiss(street_usd,epsop_usd,forecast_usd,price0_usd,car)=0;
  uop_street=(street_usd-forecast_usd)/price0_usd;
  uop_epsop=(epsop_usd-forecast_usd)/price0_usd;
  keep gvkey datadate fyearq fqtr rdq hiid iid agreement_group n_days car
    ticker street_raw street_currency actual_iid anndats forecast_raw forecast_currency forecast_iid statpers
    street_usd epsop_usd forecast_usd uop_street uop_epsop
    price0_iid price0_date price0_currency price0_route price0_hiid_diff price0_price price0_fx price0_usd
    price0_factor price0_factor_date price0_share_ratio price0_basis_ok anchor_factor anchor_date anchor_ok ajexq_difference
    street_factor street_date street_basis_raw street_basis_ok forecast_factor forecast_date forecast_basis_raw forecast_basis_ok;
run;

/* Final key/cardinality and actual-sample diagnostics; regression handoffs are direct. */
proc sql;
  select count(*) as table2_n, count(distinct cats(gvkey,'_',put(datadate,yymmddn8.))) as table2_keys
    from outval.valuation;
  select count(*) as table3_n, count(distinct cats(gvkey,'_',put(datadate,yymmddn8.))) as table3_keys
    from outinfo.information;
  select mean(price3_hiid_diff) as t2_role_hiid_mismatch_rate
    from outval.valuation;
  select mean(price0_hiid_diff) as t3_role_hiid_mismatch_rate
    from outinfo.information;
quit;
proc means data=outval.valuation n mean std p25 median p75;
  var price3_usd bvps_usd street_usd epsop_usd ni_usd other_street_usd other_epsop_usd;
run;
proc means data=outinfo.information n mean std p25 median p75;
  var car uop_street uop_epsop street_usd epsop_usd forecast_usd price0_usd;
run;
