options errorabend nodate nonumber mprint mlogic symbolgen;

/* Read-only sources; these aliases point to the exact catalog files. */
libname sdc "/storage/sas/base/tfn/sdc_ma" access=readonly;
libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname compsec "/storage/sas/base/comp/d_na/security" access=readonly;
libname compfx "/storage/sas/base/comp/d_global/currency" access=readonly;
libname crsp "/storage/sas/base/crsp/a_stock" access=readonly;
libname ccm "/storage/sas/base/crsp/a_ccm" access=readonly;
libname tfn "/storage/sas/base/tfn/s34" access=readonly;
libname out "data";

%let annstart='01JAN1983'd;
%let annend='31DEC2009'd;
%let rawstart='01JAN1975'd;
%let rawend='31DEC2012'd;

/* Inspect the actual local SDC categories before applying the paper screens. */
data work.sdc_audit;
    set sdc.wrds_ma_details(keep=master_deal_no dateann dateeff form statuscode
        repurch anationcode tnationcode apublic tpublic acusip master_cusip rankval
        pct_cash pct_stk tender attitude
        where=(dateann >= &annstart and dateann <= &annend));
run;

title "Local SDC categories in the paper announcement window";
proc freq data=work.sdc_audit;
    tables form statuscode repurch anationcode tnationcode apublic tpublic tender attitude / missing;
run;
title;

title "Local SDC transaction-value and consideration fields";
proc means data=work.sdc_audit n nmiss min p1 p25 median p75 p99 max;
    var rankval pct_cash pct_stk;
run;
title;

/* Count the source acquisition screen before the $1m value and linking gates,
   so differences from the published Table 1 attrition can be located. */
data work.sdc_base_screen;
    set work.sdc_audit;
    form_u=upcase(strip(form));
    if form_u not in ('M','MERGER','AM','ACQ. MAJ. INT.','AA','ACQ. OF ASSETS') and
       index(form_u,'MAJORITY')=0 then delete;
    if upcase(strip(statuscode)) ne 'C' then delete;
    if upcase(strip(anationcode)) ne 'US' or upcase(strip(tnationcode)) ne 'US' then delete;
    if upcase(strip(apublic)) ne 'PUBLIC' or upcase(strip(tpublic)) ne 'PUBLIC' then delete;
    if upcase(strip(repurch)) not in ('N','NO') then delete;
    if missing(master_deal_no) then delete;
run;
title "Local completed public U.S. SDC sample before transaction-value/link screens";
proc sql;
    select count(*) as sdc_base_rows,
           count(distinct master_deal_no) as sdc_base_deals,
           sum(not missing(rankval) and rankval<1) as rankval_below_1m,
           sum(missing(rankval)) as rankval_missing,
           sum(not missing(rankval) and rankval>=1) as rankval_at_least_1m,
           sum(missing(acusip)) as bidder_cusip_missing,
           sum(missing(master_cusip)) as target_cusip_missing
    from work.sdc_base_screen;
quit;
title;



/* The source says completed M/AM/AA, public U.S. bidder and target,
   and no repurchases. WRDS exposes descriptive FORM and public-status fields. */
data work.events0;
    set work.sdc_audit;
    length dealid $10 form_code $2 attitude_u $9;
    dealid=strip(master_deal_no);
    form_u=upcase(strip(form));
    if form_u in ('M','MERGER') then form_code='M';
    else if form_u in ('AM','ACQ. MAJ. INT.') or index(form_u,'MAJORITY')>0 then form_code='AM';
    else if form_u in ('AA','ACQ. OF ASSETS') then form_code='AA';
    else delete;
    if upcase(strip(statuscode)) ne 'C' then delete;
    if upcase(strip(anationcode)) ne 'US' or upcase(strip(tnationcode)) ne 'US' then delete;
    if upcase(strip(apublic)) ne 'PUBLIC' or upcase(strip(tpublic)) ne 'PUBLIC' then delete;
    if upcase(strip(repurch)) in ('Y','YES') then delete;
    if upcase(strip(repurch)) not in ('N','NO') then delete;
    if missing(dealid) or missing(acusip) or missing(master_cusip) then delete;
    cusip_a=upcase(strip(acusip));
    cusip_t=upcase(strip(master_cusip));
    attitude_u=upcase(strip(attitude));
    if rankval < 1 or missing(rankval) then delete;
    dealvalue_m=rankval;
    format dateann dateeff yymmdd10.;
    keep dealid dateann dateeff form_code rankval dealvalue_m cusip_a cusip_t
         pct_cash pct_stk tender attitude_u;
run;

/* MASTER_DEAL_NO is the SDC deal key. Ambiguous duplicate rows are retained in
   the count report and excluded rather than arbitrarily collapsed. */
proc sql;
    create table work.event_key_counts as
    select dealid, count(*) as n_rows
    from work.events0
    group by dealid;
    select count(*) as sdc_candidate_rows,
           count(distinct dealid) as sdc_candidate_deals,
           sum(n_rows>1) as duplicate_deal_keys,
           sum(case when n_rows>1 then n_rows else 0 end) as rows_in_duplicate_keys
    from work.event_key_counts;
    create table work.events1 as
    select e.*
    from work.events0 as e inner join work.event_key_counts as k
      on e.dealid=k.dealid
    where k.n_rows=1;
quit;

/* Effective-dated Compustat security history, rather than FUNDA header CUSIP. */
data work.cusip_hist0;
    set compsec.sec_idhist(keep=gvkey iid item itemvalue efffrom effthru);
    if upcase(strip(item)) in ('CUSIP','NCUSIP');
    if missing(itemvalue) then delete;
    length cusip6 $6 cusip8 $8;
    cusip6=substr(compress(upcase(strip(itemvalue))),1,6);
    cusip8=substr(compress(upcase(strip(itemvalue))),1,8);
    if lengthn(cusip6) ne 6 then delete;
    if missing(efffrom) then efffrom='01JAN1900'd;
    if missing(effthru) then effthru='31DEC9999'd;
    keep gvkey iid cusip6 cusip8 efffrom effthru item;
run;
proc sql;
    create table work.cusip_hist_unique as
    select distinct gvkey,cusip6,cusip8,efffrom,effthru
    from work.cusip_hist0;
quit;

data work.event_party_cusip;
    set work.events1(in=a) work.events1(in=t);
    length role $1 cusip6 $6;
    if a then do; role='A'; cusip6=cusip_a; end;
    else do; role='T'; cusip6=cusip_t; end;
    keep dealid role cusip6 dateann dateeff;
run;

proc sql;
    create table work.party_gvkey_candidates as
    select distinct p.dealid,p.role,p.cusip6,p.dateann,p.dateeff,h.gvkey
    from work.event_party_cusip as p inner join work.cusip_hist0 as h
      on p.cusip6=h.cusip6 and p.dateann>=h.efffrom and p.dateann<=h.effthru;
    create table work.party_gvkey_counts as
    select dealid,role,count(distinct gvkey) as n_gvkey,max(gvkey) as gvkey length=6
    from work.party_gvkey_candidates group by dealid,role;
    create table work.party_gvkey as
    select p.dealid,p.role,p.cusip6,p.dateann,p.dateeff,c.gvkey
    from work.event_party_cusip as p inner join work.party_gvkey_counts as c
      on p.dealid=c.dealid and p.role=c.role
    where c.n_gvkey=1;
    select role, count(*) as matched_participant_rows,
           sum(n_gvkey=0) as no_historical_cusip_match,
           sum(n_gvkey>1) as ambiguous_historical_cusip_match
    from work.party_gvkey_counts group by role;
quit;

/* Dated CCM links. P/C markers and LC/LU link types are retained; .B/.E open
   endpoints are accepted, and no equality to FUNDA header IID is imposed. */
data work.ccm_links0;
    set ccm.ccmxpf_linktable(keep=gvkey linkprim liid linktype lpermno lpermco
        linkdt linkenddt
        where=(linktype in ('LC','LU') and linkprim in ('P','C') and lpermno>0));
    if missing(linkdt) then linkdt='01JAN1900'd;
    if missing(linkenddt) then linkenddt='31DEC9999'd;
    prim_rank=(linkprim='P');
    type_rank=(linktype='LC');
    permno=lpermno;
    keep gvkey liid linkprim linktype lpermco permno linkdt linkenddt prim_rank type_rank;
run;

proc sql;
    create table work.party_link_candidates0 as
    select p.*,l.permno,l.lpermco,l.liid,l.linkprim,l.linktype,
           l.prim_rank,l.type_rank
    from work.party_gvkey as p inner join work.ccm_links0 as l
      on p.gvkey=l.gvkey and p.dateann>=l.linkdt and p.dateann<=l.linkenddt;
    create table work.party_link_best as
    select dealid,role,min(prim_rank*2+type_rank) as best_rank
    from work.party_link_candidates0 group by dealid,role;
    create table work.party_link_counts as
    select c.dealid,c.role,b.best_rank,count(distinct c.permno) as n_permno,
           max(c.gvkey) as gvkey length=6,max(c.cusip6) as cusip6 length=6,
           max(c.dateann) as dateann,max(c.dateeff) as dateeff,max(c.permno) as permno
    from work.party_link_candidates0 as c inner join work.party_link_best as b
      on c.dealid=b.dealid and c.role=b.role
    where c.prim_rank*2+c.type_rank=b.best_rank
    group by c.dealid,c.role,b.best_rank;
    create table work.party_link as
    select * from work.party_link_counts where n_permno=1;
quit;

/* Require an effective common-share name on the event date. */
data work.crsp_names0;
    set crsp.stocknames(keep=permno permco namedt nameenddt shrcd ncusip cusip);
    if shrcd in (10,11);
    if missing(namedt) then namedt='01JAN1900'd;
    if missing(nameenddt) then nameenddt='31DEC9999'd;
run;
proc sql;
    create table work.party_name_candidates as
    select p.*,n.permco,n.shrcd
    from work.party_link as p inner join work.crsp_names0 as n
      on p.permno=n.permno and p.dateann>=n.namedt and p.dateann<=n.nameenddt;
    create table work.party_name_counts as
    select dealid,role,count(distinct permno) as n_permno,
           max(gvkey) as gvkey length=6,max(cusip6) as cusip6 length=6,
           max(dateann) as dateann,max(dateeff) as dateeff,max(permno) as permno,
           max(permco) as permco
    from work.party_name_candidates group by dealid,role;
    create table work.party as
    select * from work.party_name_counts where n_permno=1;
    select role,count(*) as dated_common_share_participants
    from work.party group by role;
quit;



/* Daily cross-rates use the documented FROM currency to USD direction. Keep
   only unique positive observations; a missing/ambiguous quote stays missing. */
data work.fx_dly_raw;
    set compfx.g_exrt_dly(keep=datadate tocurd fromcurd exratd exrattpd
        where=(datadate >= &rawstart and datadate <= &rawend and tocurd='USD'));
    if exratd>0 and not missing(fromcurd);
    fromcur=upcase(strip(fromcurd));
    keep datadate fromcur exratd exrattpd;
run;
proc sql;
    create table work.fx_dly_key as
    select datadate,fromcur,count(*) as n_rate,max(exratd) as rate,
           max(exrattpd) as rate_type
    from work.fx_dly_raw group by datadate,fromcur;
    create table work.fx_dly as
    select datadate,fromcur,case when n_rate=1 then rate else . end as rate,
           n_rate,rate_type
    from work.fx_dly_key;
    select count(*) as fx_date_currency_keys,
           sum(n_rate>1) as ambiguous_fx_keys
    from work.fx_dly;
quit;

/* Quarterly accounting rows. FQTR/FYEARQ identify fiscal quarters. A calendar
   quarter key is retained only for event anchors and calendar-peer controls;
   duplicate dated rows in that key are diagnosed, then the latest is kept. */
data work.fq_raw;
    set comp.fundq(keep=gvkey datadate fdateq fyearq fqtr indfmt consol popsrc datafmt
        curcdq ibq mkvaltq cshoq prccq atq ceqq
        where=(datadate >= &rawstart and datadate <= &rawend and
               indfmt='INDL' and consol='C' and popsrc='D' and datafmt='STD'));
    if not missing(gvkey) and not missing(datadate);
    qidx=year(datadate)*4+qtr(datadate);
    if not missing(fyearq) and fqtr>=1 and fqtr<=4 then fqidx=fyearq*4+fqtr;
    else fqidx=.;
    noncalendar_q=(month(datadate) ne 3*qtr(datadate));
    calyear=year(datadate);
run;
proc sql;
    create table work.fq_dups as
    select gvkey,qidx,count(*) as n_rows
    from work.fq_raw group by gvkey,qidx having count(*)>1;
    select count(*) as quarterly_duplicate_keys,
           sum(n_rows) as rows_in_quarterly_duplicate_keys
    from work.fq_dups;
quit;
proc sort data=work.fq_raw out=work.fq_sort;
    by gvkey qidx datadate fdateq;
run;
data work.fq_one;
    set work.fq_sort;
    by gvkey qidx;
    if last.qidx;
run;
proc sort data=work.fq_one out=work.fq_fiscal_sort;
    by gvkey fqidx datadate fdateq;
run;
data work.fq_fiscal_one;
    set work.fq_fiscal_sort;
    by gvkey fqidx;
    if not missing(fqidx) and last.fqidx;
run;
proc sql;
    create table work.fq_fiscal_dups as
    select gvkey,fqidx,count(*) as n_rows
    from work.fq_one where not missing(fqidx)
    group by gvkey,fqidx having count(*)>1;
    select count(*) as duplicated_fiscal_quarter_keys,
           sum(n_rows) as dup_fiscal_rows
    from work.fq_fiscal_dups;
    select count(*) as calendar_quarter_rows,
           sum(missing(fqidx)) as rows_missing_fiscal_quarter_key,
           sum(noncalendar_q=1) as noncalendar_fiscal_quarter_rows,
           sum(noncalendar_q=0) as calendar_end_fiscal_quarter_rows
    from work.fq_one;
quit;

/* Prior fiscal-quarter market equity for earnings. Translate point-in-time
   company MVE to USD using the latest unique direct daily rate in [date-5,date]. */
proc sql;
    create table work.q_pair as
    select a.*,b.mkvaltq as mve_lag,b.curcdq as curcd_lag,
           b.datadate as prev_qdate format=yymmdd10.
    from work.fq_one as a left join work.fq_fiscal_one as b
      on a.gvkey=b.gvkey and not missing(a.fqidx) and b.fqidx=a.fqidx-1;
    create table work.q_fx_candidates as
    select q.gvkey,q.qidx,q.datadate,q.curcdq,
           x.datadate as fxdate,x.rate as usd_rate,x.n_rate as n_fx_rate,
           x.rate_type as fx_type
    from work.fq_one as q left join work.fx_dly as x
      on upcase(strip(q.curcdq))=x.fromcur and x.datadate<=q.datadate
     and x.datadate>=q.datadate-5;
    create table work.q_fx_date as
    select gvkey,qidx,max(fxdate) as fxdate format=yymmdd10.
    from work.q_fx_candidates group by gvkey,qidx;
    create table work.q_fx as
    select c.gvkey,c.qidx,c.datadate,c.curcdq,c.usd_rate,c.n_fx_rate,c.fx_type
    from work.q_fx_candidates as c inner join work.q_fx_date as d
      on c.gvkey=d.gvkey and c.qidx=d.qidx and c.fxdate=d.fxdate;
quit;
proc sql;
    create table work.q_fx_one as
    select gvkey,qidx,count(*) as n_quote,max(n_fx_rate) as n_fx_rate,
           max(usd_rate) as usd_rate,max(curcdq) as curcdq,max(fx_type) as fx_type
    from work.q_fx group by gvkey,qidx;
quit;
proc sort data=work.q_pair; by gvkey qidx; run;
proc sort data=work.q_fx_one; by gvkey qidx; run;
data work.fq_base;
    merge work.q_pair(in=a) work.q_fx_one(in=b);
    by gvkey qidx;
    if a;
    if upcase(strip(curcdq))='USD' then usd_factor=1;
    else if b and n_quote=1 and n_fx_rate=1 and usd_rate>0 then usd_factor=usd_rate;
    if not missing(mkvaltq) and not missing(usd_factor) then mve_usd=mkvaltq*usd_factor;
    if not missing(ibq) and not missing(mve_lag) and mve_lag>0 and
       upcase(strip(curcdq))=upcase(strip(curcd_lag)) then earnings=ibq/mve_lag;
    if not missing(mkvaltq) and not missing(prccq) and not missing(cshoq)
       and cshoq ne 0 then mve_audit=prccq*cshoq;
    if not missing(mkvaltq) and not missing(mve_audit) and mve_audit ne 0
       then mve_audit_ratio=mkvaltq/mve_audit;
    label mve_usd='Company market equity, USD millions at reported quarter-end'
          earnings='IBQ divided by prior-quarter company market equity';
run;

title "Quarterly company market-value audit and USD conversion coverage";
proc means data=work.fq_base n nmiss min p1 p50 p99 max;
    var mkvaltq mve_audit mve_usd usd_factor earnings;
run;
title;
proc sql;
    select count(*) as quarterly_rows,
           sum(not missing(mve_usd)) as usd_market_value_rows,
           sum(not missing(mkvaltq) and missing(mve_usd)) as missing_fx_rows,
           sum(not missing(mve_audit) and not missing(mkvaltq)) as mve_audit_rows
    from work.fq_base;
    select calyear,curcdq,count(*) as firm_quarters,
           sum(not missing(mkvaltq)) as comp_mveq_observed,
           sum(not missing(mve_usd)) as comp_mveq_usd_converted,
           sum(not missing(mve_audit_ratio)) as priced_share_audit,
           median(mve_audit_ratio) as median_comp_to_price_share_ratio
    from work.fq_base group by calyear,curcdq order by calyear,curcdq;
quit;

/* CRSP security links for each Compustat quarter. Validity is checked at the
   actual Compustat period end; ambiguous company links remain out. */
proc sql;
    create table work.fq_link_candidates as
    select q.gvkey,q.qidx,q.fqidx,q.datadate,l.permno,l.prim_rank,l.type_rank
    from work.fq_one as q inner join work.ccm_links0 as l
      on q.gvkey=l.gvkey and q.datadate>=l.linkdt and q.datadate<=l.linkenddt
    inner join work.crsp_names0 as n
      on l.permno=n.permno and q.datadate>=n.namedt
     and q.datadate<=n.nameenddt and n.shrcd in (10,11);
    create table work.fq_link_best as
    select gvkey,qidx,min(prim_rank*2+type_rank) as best_rank
    from work.fq_link_candidates group by gvkey,qidx;
    create table work.fq_link_counts as
    select c.gvkey,c.qidx,c.fqidx,c.datadate,b.best_rank,count(distinct c.permno) as n_permno,
           max(c.permno) as permno
    from work.fq_link_candidates as c inner join work.fq_link_best as b
      on c.gvkey=b.gvkey and c.qidx=b.qidx
    where c.prim_rank*2+c.type_rank=b.best_rank
    group by c.gvkey,c.qidx,c.fqidx,c.datadate,b.best_rank;
    create table work.fq_link as
    select * from work.fq_link_counts where n_permno=1;
quit;

data work.msf_raw;
    set crsp.msf(keep=permno permco date ret prc shrout cfacshr
        where=(date >= &rawstart and date <= &rawend));
    if not missing(permno) and not missing(date);
    qidx=year(date)*4+qtr(date);
    mkey=year(date)*12+month(date);
run;
/* Legacy CRSP.MSF does not store DLRET. Merge the unique monthly CRSP.MSEDELIST
   delisting return by normalized month and combine it with RET. */
data work.mse_raw;
    set crsp.msedelist(keep=permno dlstdt dlret
        where=(dlstdt >= &rawstart and dlstdt <= &rawend));
    date=dlstdt;
    if not missing(permno) and not missing(date);
    mkey=year(date)*12+month(date);
run;
proc sql;
    create table work.mse_month0 as
    select permno,mkey,count(*) as n_mse_rows,
           sum(not missing(dlret)) as n_dlret,max(dlret) as dlret
    from work.mse_raw group by permno,mkey;
    create table work.mse_month as
    select permno,mkey,n_mse_rows,n_dlret,
           case when n_dlret=1 then dlret else . end as dlret
    from work.mse_month0;
    select count(*) as permno_months_with_delisting,
           sum(n_dlret=1) as unique_monthly_dlret,
           sum(n_dlret>1) as ambiguous_monthly_dlret
    from work.mse_month;
    create table work.msf_month_return0 as
    select m.*,d.dlret,d.n_mse_rows,d.n_dlret
    from work.msf_raw as m left join work.mse_month as d
      on m.permno=d.permno and m.mkey=d.mkey;
quit;
data work.msf_raw;
    set work.msf_month_return0;
    if not missing(ret) and not missing(dlret) then ret_use=(1+ret)*(1+dlret)-1;
    else if missing(ret) and not missing(dlret) then ret_use=dlret;
    else ret_use=ret;
run;
proc sql;
    create table work.msf_month_counts as
    select permno,date,count(*) as n_rows
    from work.msf_raw group by permno,date;
    create table work.msf_month_unique as
    select m.* from work.msf_raw as m inner join work.msf_month_counts as c
      on m.permno=c.permno and m.date=c.date where c.n_rows=1;
    create table work.crsp_mve_issue as
    select m.permno,m.permco,m.date,m.qidx,m.prc,m.shrout,
           abs(m.prc)*m.shrout/1000 as mve_usd
    from work.msf_month_unique as m inner join work.crsp_names0 as n
      on m.permno=n.permno and m.date>=n.namedt and m.date<=n.nameenddt
    where n.shrcd in (10,11) and not missing(m.permco) and
          not missing(m.prc) and m.prc ne 0 and m.shrout>0;
    create table work.crsp_mve_co as
    select permco,date,qidx,sum(mve_usd) as crsp_mve_usd,
           count(distinct permno) as n_common_issues
    from work.crsp_mve_issue group by permco,date,qidx;

    create table work.fq_permco_candidates as
    select q.gvkey,q.qidx,l.lpermco as permco,l.prim_rank,l.type_rank
    from work.fq_one as q inner join work.ccm_links0 as l
      on q.gvkey=l.gvkey and l.lpermco>0 and q.datadate>=l.linkdt and q.datadate<=l.linkenddt;
    create table work.fq_permco_best as
    select gvkey,qidx,min(prim_rank*2+type_rank) as best_rank
    from work.fq_permco_candidates group by gvkey,qidx;
    create table work.fq_permco_counts as
    select c.gvkey,c.qidx,b.best_rank,count(distinct c.permco) as n_permco,
           max(c.permco) as permco
    from work.fq_permco_candidates as c inner join work.fq_permco_best as b
      on c.gvkey=b.gvkey and c.qidx=b.qidx
    where c.prim_rank*2+c.type_rank=b.best_rank
    group by c.gvkey,c.qidx,b.best_rank;
    create table work.fq_permco as
    select * from work.fq_permco_counts where n_permco=1;
    create table work.fq_crsp_mve_dates as
    select p.gvkey,p.qidx,max(m.date) as mve_date format=yymmdd10.
    from work.fq_permco as p inner join work.fq_one as q
      on p.gvkey=q.gvkey and p.qidx=q.qidx
    inner join work.crsp_mve_co as m
      on p.permco=m.permco and m.date<=q.datadate and m.date>=q.datadate-45
    group by p.gvkey,p.qidx;
    create table work.fq_crsp_mve as
    select p.gvkey,p.qidx,p.permco,d.mve_date,m.crsp_mve_usd,m.n_common_issues
    from work.fq_permco as p inner join work.fq_crsp_mve_dates as d
      on p.gvkey=d.gvkey and p.qidx=d.qidx
    inner join work.crsp_mve_co as m
      on p.permco=m.permco and d.mve_date=m.date;
    create table work.fq_market0 as
    select a.*,c.permco as crsp_permco,c.mve_date as crsp_mve_date,
           c.crsp_mve_usd,c.n_common_issues,
           case when not missing(a.mve_usd) and a.mve_usd>0 then a.mve_usd
                when not missing(c.crsp_mve_usd) and c.crsp_mve_usd>0 then c.crsp_mve_usd
                else . end as mve_usd_final,
           case when not missing(a.mve_usd) and a.mve_usd>0 then 'COMP'
                when not missing(c.crsp_mve_usd) and c.crsp_mve_usd>0 then 'CRSP_PERMCO'
                else 'MISSING' end as mve_source length=12
    from work.fq_base as a left join work.fq_crsp_mve as c
      on a.gvkey=c.gvkey and a.qidx=c.qidx;
    select calyear,mve_source,count(*) as firm_quarters,
           sum(not missing(mve_usd_final)) as mve_usd_final_rows,
           mean(n_common_issues) as mean_crsp_common_issues
    from work.fq_market0 group by calyear,mve_source order by calyear,mve_source;
    create table work.fq_market_fiscal0 as
    select * from work.fq_market0 where not missing(fqidx);
quit;
proc sort data=work.fq_market_fiscal0 out=work.fq_market_fiscal_sort;
    by gvkey fqidx datadate fdateq;
run;
data work.fq_market_fiscal;
    set work.fq_market_fiscal_sort;
    by gvkey fqidx;
    if last.fqidx;
run;
proc sql;
    create table work.fq_market as
    select a.*,p.mve_usd_final as prev_mve_usd_final,
           case when not missing(a.mve_lag) and a.mve_lag>0 and
                     upcase(strip(a.curcdq))=upcase(strip(a.curcd_lag)) and
                     not missing(a.ibq) then a.ibq/a.mve_lag
                when not missing(p.mve_usd_final) and p.mve_usd_final>0 and
                     not missing(a.ibq) and not missing(a.usd_factor) then
                     (a.ibq*a.usd_factor)/p.mve_usd_final
                else . end as earnings_final
    from work.fq_market0 as a left join work.fq_market_fiscal as p
      on a.gvkey=p.gvkey and not missing(a.fqidx) and a.fqidx=p.fqidx+1;

    /* Common calendar-quarter BHR is retained for aligned peer correlations. */
    create table work.fq_msf as
    select l.gvkey,l.qidx,l.permno,m.date,m.ret_use as ret
    from work.fq_link as l inner join work.msf_raw as m
      on l.permno=m.permno and l.qidx=m.qidx;

    /* Fiscal-quarter BHR uses the CRSP monthly observations ending in the
       Compustat DATADATE month and the preceding two months. */
    create table work.fq_msf_fiscal as
    select l.gvkey,l.qidx,l.fqidx,l.datadate,l.permno,m.date,m.mkey,m.ret_use as ret
    from work.fq_link as l inner join work.msf_raw as m
      on l.permno=m.permno
     and m.mkey between (year(l.datadate)*12+month(l.datadate)-2)
                    and (year(l.datadate)*12+month(l.datadate));
quit;
proc sort data=work.fq_msf; by gvkey qidx date; run;
data work.q_bhr;
    set work.fq_msf;
    by gvkey qidx;
    retain grossret nmonth nret perm_hold nperm;
    if first.qidx then do;
        grossret=1; nmonth=0; nret=0; perm_hold=permno; nperm=0;
    end;
    nmonth+1;
    if permno ne perm_hold then nperm+1;
    if not missing(ret) and ret>-1 then do; grossret=grossret*(1+ret); nret+1; end;
    else nret=-1000;
    if last.qidx then do;
        bhr=.;
        if nmonth=3 and nret=3 and nperm=0 then bhr=grossret-1;
        output;
    end;
    keep gvkey qidx permno bhr nmonth nret nperm;
run;
proc sort data=work.fq_msf_fiscal; by gvkey qidx date; run;
data work.q_bhr_fiscal;
    set work.fq_msf_fiscal;
    by gvkey qidx;
    retain grossretf nmonthf nretf perm_holdf npermf;
    if first.qidx then do;
        grossretf=1; nmonthf=0; nretf=0; perm_holdf=permno; npermf=0;
    end;
    nmonthf+1;
    if permno ne perm_holdf then npermf+1;
    if not missing(ret) and ret>-1 then do;
        grossretf=grossretf*(1+ret); nretf+1;
    end;
    else nretf=-1000;
    if last.qidx then do;
        bhr_fiscal=.;
        if nmonthf=3 and nretf=3 and npermf=0 then bhr_fiscal=grossretf-1;
        output;
    end;
    keep gvkey qidx fqidx datadate permno bhr_fiscal nmonthf nretf npermf;
run;
proc sql;
    create table work.fq_final0 as
    select a.*,r.bhr,r.nmonth,r.nret,r.nperm,
           f.bhr_fiscal,f.nmonthf,f.nretf,f.npermf
    from work.fq_market as a left join work.q_bhr as r
      on a.gvkey=r.gvkey and a.qidx=r.qidx
    left join work.q_bhr_fiscal as f
      on a.gvkey=f.gvkey and a.qidx=f.qidx;
quit;
data work.fq_final;
    set work.fq_final0;
    earnings=earnings_final;
    drop earnings_final;
run;
proc sql;
    select count(*) as quarterly_firm_observations,
           sum(not missing(earnings)) as valid_earnings,
           sum(not missing(bhr)) as complete_three_month_returns,
           sum(not missing(bhr_fiscal)) as complete_fiscal_month_returns,
           sum(noncalendar_q=1) as noncalendar_fiscal_quarter_rows,
           sum(noncalendar_q=1 and not missing(bhr) and not missing(bhr_fiscal)
               and abs(bhr-bhr_fiscal)>1e-12) as offcal_changed_ret,
           sum(not missing(earnings) and not missing(bhr)) as valid_regression_rows
    from work.fq_final;
quit;

/* Annual Compustat inputs and aligned prior-year assets. */
data work.fa_raw;
    set comp.funda(keep=gvkey datadate fdate fyear indfmt consol popsrc datafmt curcd sich
        at ceq dltt dlc oibdp xint txt dv mkvalt csho prcc_f
        where=(datadate >= &rawstart and datadate <= &rawend and
               indfmt='INDL' and consol='C' and popsrc='D' and datafmt='STD'));
    if not missing(gvkey) and not missing(datadate);
    calyear=year(datadate);
    sic2=floor(sich/100);
run;
proc sql;
    create table work.fa_dups as
    select gvkey,fyear,count(*) as n_rows
    from work.fa_raw group by gvkey,fyear having count(*)>1;
    select count(*) as annual_duplicate_keys,
           sum(n_rows) as rows_in_annual_duplicate_keys from work.fa_dups;
quit;
proc sort data=work.fa_raw out=work.fa_sort;
    by gvkey fyear datadate fdate;
run;
data work.fa_one;
    set work.fa_sort;
    by gvkey fyear;
    if last.fyear;
run;
proc sql;
    create table work.fa_pair as
    select a.*,p.at as at_lag,p.curcd as curcd_lag
    from work.fa_one as a left join work.fa_one as p
      on a.gvkey=p.gvkey and a.fyear=p.fyear+1;
quit;
data work.fa_roa;
    set work.fa_pair;
    avgat=.; roa=.; lev=.; tobin=.; fcf=.;
    if not missing(at) and not missing(at_lag) and at>0 and at_lag>0 and
       upcase(strip(curcd))=upcase(strip(curcd_lag)) then do;
        avgat=(at+at_lag)/2;
        if not missing(oibdp) then roa=oibdp/avgat;
    end;
    if not missing(dltt) and not missing(dlc) and not missing(at) and at>0
       then lev=(dltt+dlc)/at;
    if not missing(mkvalt) and not missing(at) and not missing(ceq) and at>0
       then tobin=(mkvalt+at-ceq)/at;
    if not missing(prcc_f) and not missing(csho) and csho ne 0 then
       annual_mve_audit=prcc_f*csho;
    if not missing(mkvalt) and not missing(annual_mve_audit) and annual_mve_audit ne 0
       then annual_mve_audit_ratio=mkvalt/annual_mve_audit;
    if not missing(oibdp) and not missing(xint) and not missing(txt) and
       not missing(dv) and not missing(at) and at>0 then fcf=(oibdp-xint-txt-dv)/at;
run;
proc sort data=work.fa_roa out=work.fa_cal_sort;
    by gvkey calyear datadate fdate;
run;
data work.fa_cal;
    set work.fa_cal_sort;
    by gvkey calyear;
    if last.calyear;
run;

/* FUNDQ in this local Compustat vintage has no SIC column. Carry the latest
   nonmissing annual historical SIC (FUNDA.SICH) to each quarterly record. */
data work.fa_sic;
    set work.fa_cal(keep=gvkey datadate sic2);
    period_date=datadate;
    annual_sic2=sic2;
    keep gvkey period_date annual_sic2;
run;
data work.q_sic_stack;
    set work.fa_sic(in=is_annual) work.fq_final(in=is_quarter);
    if is_annual then rowtype=0;
    else do;
        rowtype=1;
        period_date=datadate;
    end;
run;
proc sort data=work.q_sic_stack;
    by gvkey period_date rowtype;
run;
data work.fq_final_sic;
    set work.q_sic_stack;
    by gvkey period_date rowtype;
    retain active_sic2;
    if first.gvkey then active_sic2=.;
    if rowtype=0 then do;
        if not missing(annual_sic2) then active_sic2=annual_sic2;
    end;
    else if rowtype=1 then do;
        sic2=active_sic2;
        output;
    end;
    drop rowtype annual_sic2 active_sic2 period_date;
run;
data work.fq_final;
    set work.fq_final_sic;
run;
title "Annual company market-value currency and price-share audit";
proc sql;
    select calyear,curcd,count(*) as annual_firm_rows,
           sum(not missing(mkvalt)) as comp_mve_observed,
           sum(not missing(annual_mve_audit_ratio)) as priced_share_audit,
           median(annual_mve_audit_ratio) as median_comp_to_price_share_ratio
    from work.fa_cal group by calyear,curcd order by calyear,curcd;
quit;
title;

/* Annual Tobin-Q fallback uses the same date-valid CCM PERMCO aggregation
   when Compustat MKVALT is absent. Reporting-currency AT/CEQ are converted
   with a direct positive daily quote at the annual report date. */
proc sql;
    create table work.fa_fx_candidates as
    select a.gvkey,a.calyear,a.datadate,a.curcd,x.datadate as fxdate,
           x.rate,x.n_rate,x.rate_type
    from work.fa_cal as a left join work.fx_dly as x
      on upcase(strip(a.curcd))=x.fromcur and x.datadate<=a.datadate
     and x.datadate>=a.datadate-5;
    create table work.fa_fx_dates as
    select gvkey,calyear,max(fxdate) as fxdate format=yymmdd10.
    from work.fa_fx_candidates group by gvkey,calyear;
    create table work.fa_fx as
    select c.gvkey,c.calyear,c.curcd,c.datadate,c.rate,c.n_rate,c.rate_type
    from work.fa_fx_candidates as c inner join work.fa_fx_dates as d
      on c.gvkey=d.gvkey and c.calyear=d.calyear and c.fxdate=d.fxdate;
    create table work.fa_fx_one as
    select gvkey,calyear,count(*) as n_quote,max(n_rate) as n_fx_rate,
           max(rate) as usd_rate,max(curcd) as curcd,max(rate_type) as fx_type
    from work.fa_fx group by gvkey,calyear;

    create table work.fa_permco_candidates as
    select a.gvkey,a.calyear,l.lpermco as permco,l.prim_rank,l.type_rank
    from work.fa_cal as a inner join work.ccm_links0 as l
      on a.gvkey=l.gvkey and l.lpermco>0 and
         a.datadate>=l.linkdt and a.datadate<=l.linkenddt;
    create table work.fa_permco_best as
    select gvkey,calyear,min(prim_rank*2+type_rank) as best_rank
    from work.fa_permco_candidates group by gvkey,calyear;
    create table work.fa_permco_counts as
    select c.gvkey,c.calyear,b.best_rank,count(distinct c.permco) as n_permco,
           max(c.permco) as permco
    from work.fa_permco_candidates as c inner join work.fa_permco_best as b
      on c.gvkey=b.gvkey and c.calyear=b.calyear
    where c.prim_rank*2+c.type_rank=b.best_rank
    group by c.gvkey,c.calyear,b.best_rank;
    create table work.fa_permco as
    select * from work.fa_permco_counts where n_permco=1;
    create table work.fa_mve_dates as
    select p.gvkey,p.calyear,max(m.date) as mve_date format=yymmdd10.
    from work.fa_permco as p inner join work.fa_cal as a
      on p.gvkey=a.gvkey and p.calyear=a.calyear
    inner join work.crsp_mve_co as m
      on p.permco=m.permco and m.date<=a.datadate and m.date>=a.datadate-45
    group by p.gvkey,p.calyear;
    create table work.fa_crsp_mve as
    select p.gvkey,p.calyear,p.permco,d.mve_date,m.crsp_mve_usd,m.n_common_issues
    from work.fa_permco as p inner join work.fa_mve_dates as d
      on p.gvkey=d.gvkey and p.calyear=d.calyear
    inner join work.crsp_mve_co as m
      on p.permco=m.permco and d.mve_date=m.date;
    create table work.fa_final0 as
    select a.*,f.n_quote,f.n_fx_rate,f.usd_rate,f.fx_type,
           c.crsp_mve_usd,c.n_common_issues,c.mve_date as crsp_mve_date,
           case when upcase(strip(a.curcd))='USD' then 1
                when f.n_quote=1 and f.n_fx_rate=1 and f.usd_rate>0 then f.usd_rate
                else . end as annual_usd_factor
    from work.fa_cal as a
    left join work.fa_fx_one as f on a.gvkey=f.gvkey and a.calyear=f.calyear
    left join work.fa_crsp_mve as c on a.gvkey=c.gvkey and a.calyear=c.calyear;
quit;
data work.fa_final;
    set work.fa_final0;
    annual_mve_usd=.;
    if not missing(mkvalt) and not missing(annual_usd_factor) then
       annual_mve_usd=mkvalt*annual_usd_factor;
    if missing(tobin) and not missing(crsp_mve_usd) and crsp_mve_usd>0 and
       not missing(at) and at>0 and not missing(ceq) and
       not missing(annual_usd_factor) then
       tobin=(crsp_mve_usd+(at-ceq)*annual_usd_factor)/(at*annual_usd_factor);
    if not missing(annual_mve_usd) then annual_mve_source='COMP';
    else if not missing(crsp_mve_usd) then annual_mve_source='CRSP_PERMCO';
    else annual_mve_source='MISSING';
    label annual_mve_usd='Fiscal-year company market equity, USD millions';
run;
title "Annual Compustat and CRSP PERMCO market-value coverage by calendar year";
proc sql;
    select calyear,annual_mve_source,count(*) as annual_firm_rows,
           sum(not missing(annual_mve_usd)) as market_value_available,
           sum(not missing(tobin)) as tobin_q_available,
           mean(n_common_issues) as mean_crsp_common_issues
    from work.fa_final group by calyear,annual_mve_source order by calyear,annual_mve_source;
quit;
title;

/* Deal-specific accounting records at the calendar-quarter and prior fiscal
   year used by the Table 3 control definitions. */
proc sql;
    create table work.party_wide as
    select dealid,
      max(case when role='A' then gvkey end) as acqgvkey length=6,
      max(case when role='A' then permno end) as acqpermno,
      max(case when role='A' then permco end) as acqpermco,
      max(case when role='T' then gvkey end) as trggvkey length=6,
      max(case when role='T' then permno end) as trgpermno,
      max(case when role='T' then permco end) as trgpermco,
      max(case when role='A' then cusip6 end) as acqcusip length=6,
      max(case when role='T' then cusip6 end) as trgcusip length=6
    from work.party group by dealid;

    create table work.event_pre as
    select e.*,p.acqgvkey,p.acqpermno,p.acqpermco,p.trggvkey,p.trgpermno,p.trgpermco,
           p.acqcusip,p.trgcusip,
           qa.mve_usd_final as acq_mve_usd,qa.mkvaltq as acq_mve_local,
           qa.curcdq as acq_curcdq,qa.sic2 as acq_sic2,
           qt.mve_usd_final as trg_mve_usd,qt.mkvaltq as trg_mve_local,
           qt.curcdq as trg_curcdq,qt.sic2 as trg_sic2,
           aa.lev as acq_lev,aa.tobin as acq_tobin,aa.roa as acq_roa,aa.fcf as acq_fcf,
           aa.sic2 as acq_sic2a,aa.calyear as acq_calyear,
           ta.lev as trg_lev,ta.tobin as trg_tobin,ta.roa as trg_roa,
           ta.sic2 as trg_sic2a,ta.calyear as trg_calyear,
           (year(e.dateann)*4+qtr(e.dateann)-1) as anchorq,
           year(e.dateann)-1 as baseyear
    from work.events1 as e
    left join work.party_wide as p on e.dealid=p.dealid
    left join work.fq_final as qa
      on p.acqgvkey=qa.gvkey and qa.qidx=year(e.dateann)*4+qtr(e.dateann)-1
    left join work.fq_final as qt
      on p.trggvkey=qt.gvkey and qt.qidx=year(e.dateann)*4+qtr(e.dateann)-1
    left join work.fa_final as aa
      on p.acqgvkey=aa.gvkey and aa.calyear=year(e.dateann)-1
    left join work.fa_final as ta
      on p.trggvkey=ta.gvkey and ta.calyear=year(e.dateann)-1;

    create table work.events2 as
    select *,
      case when acq_mve_usd>0 then log(acq_mve_usd) else . end as acq_size,
      case when trg_mve_usd>0 then log(trg_mve_usd) else . end as trg_size,
      case when not missing(acq_mve_usd) and acq_mve_usd>0
           then dealvalue_m/acq_mve_usd else . end as rel_size,
      case when (not missing(pct_cash) and (pct_cash<0 or pct_cash>100)) or
                     (not missing(pct_stk) and (pct_stk<0 or pct_stk>100)) or
                     (not missing(pct_cash) and not missing(pct_stk) and
                      pct_cash+pct_stk>100) then .
           when not missing(pct_cash) and pct_cash>=90 then 1
           when not missing(pct_cash) and pct_cash<90 then 0
           when missing(pct_cash) and not missing(pct_stk) and pct_stk>10 then 0
           else . end as all_cash,
      case when (not missing(pct_cash) and (pct_cash<0 or pct_cash>100)) or
                     (not missing(pct_stk) and (pct_stk<0 or pct_stk>100)) or
                     (not missing(pct_cash) and not missing(pct_stk) and
                      pct_cash+pct_stk>100) then .
           when not missing(pct_stk) and pct_stk>=90 then 1
           when not missing(pct_stk) and pct_stk<90 then 0
           when missing(pct_stk) and not missing(pct_cash) and pct_cash>10 then 0
           else . end as all_stock,
      case when upcase(strip(tender)) in ('Y','YES') then 1
           when upcase(strip(tender)) in ('N','NO') then 0 else . end as tender_d,
      case when attitude_u='HOSTILE' then 1
           when attitude_u in ('FRIENDLY','NEUTRAL','UNSOLICITED','UNSOLIC.','NOT APPLICABLE','NOT APPL.','N/A') then 0
           else . end as hostile,
      case when not missing(acq_sic2a) and not missing(trg_sic2a)
           then (acq_sic2a ne trg_sic2a) else . end as diffind
    from work.event_pre
    where acq_mve_usd>0 and dealvalue_m/acq_mve_usd>=0.01;

    select count(*) as rows_after_value_screen,
           sum(missing(acq_mve_usd) or acq_mve_usd<=0) as missing_or_nonpositive_acq_mve,
           sum(acq_mve_usd>0 and dealvalue_m/acq_mve_usd<0.01)
               as below_one_percent_relative_size,
           sum(acq_mve_usd>0 and dealvalue_m/acq_mve_usd>=0.01)
               as rows_after_relative_size_screen
    from work.event_pre;
    select count(*) as public_completed_us_deals,
           sum(rankval>=1) as deal_value_at_least_1m,
           sum(not missing(acq_mve_usd)) as with_acquirer_prequarter_mve,
           sum(rel_size>=0.01) as after_relative_value_screen,
           sum(not missing(acqgvkey)) as acquirer_gvkey_mapped,
           sum(not missing(trggvkey)) as target_gvkey_mapped
    from work.events2;
quit;

/* The median dummy follows the research-design text (below median=1); the
   appendix gives the opposite direction. Ties are coded zero. */
proc univariate data=work.events2 noprint;
    var acq_tobin;
    output out=work.q_median median=acq_q_median;
run;
data work.events3;
    if _n_=1 then set work.q_median;
    set work.events2;
    if not missing(acq_tobin) then acq_tobin_dum=(acq_tobin<acq_q_median);
    else acq_tobin_dum=.;
    if not missing(acq_tobin_dum) and not missing(acq_fcf) then
       acq_q_fcf=acq_tobin_dum*acq_fcf;
    else acq_q_fcf=.;
    label acq_tobin_dum='1 if acquirer Tobin Q is below median'
          acq_q_fcf='Acquirer Tobin Q dummy times free cash flow'
          all_cash='At least 90 percent cash consideration'
          all_stock='At least 90 percent stock consideration'
          rel_size='SDC RANKVAL / prior-quarter acquirer market value';
run;

/* Inspect transaction percentage units, primary event screens, and accounting
   coverage before interpreting any fitted outcomes. */
title "Material U.S. public acquisitions and source event-control coding";
proc means data=work.events3 n nmiss mean p1 p25 median p75 p99 max;
    var rankval dealvalue_m acq_mve_usd trg_mve_usd rel_size pct_cash pct_stk;
run;
proc freq data=work.events3;
    tables form_code all_cash all_stock all_cash*all_stock tender_d hostile diffind / missing;
run;
title;
proc sql;
    select count(*) as material_deals,
           sum(not missing(acq_lev)) as acquirer_leverage,
           sum(not missing(acq_tobin)) as acquirer_q,
           sum(not missing(acq_roa)) as acquirer_roa,
           sum(not missing(acq_fcf)) as acquirer_fcf,
           sum(not missing(trg_lev)) as target_leverage,
           sum(not missing(trg_tobin)) as target_q,
           sum(not missing(trg_roa)) as target_roa,
           sum(not missing(all_cash)) as cash_classified,
           sum(not missing(all_stock)) as stock_classified,
           sum(not missing(tender_d)) as tender_classified,
           sum(not missing(hostile)) as attitude_classified
    from work.events3;
    select count(*) as payment_rows,
           sum(not missing(all_cash)) as cash_dummy_classified,
           sum(not missing(all_stock)) as stock_dummy_classified,
           sum((not missing(pct_cash) and (pct_cash<0 or pct_cash>100)) or
               (not missing(pct_stk) and (pct_stk<0 or pct_stk>100)) or
               (not missing(pct_cash) and not missing(pct_stk) and
                pct_cash+pct_stk>100)) as inconsistent_percentage_rows,
           sum(missing(pct_cash) and not missing(pct_stk) and
               pct_stk>10 and pct_stk<=100) as cash_dummy_zero_from_stock_share,
           sum(missing(pct_stk) and not missing(pct_cash) and
               pct_cash>10 and pct_cash<=100) as stock_dummy_zero_from_cash_share
    from work.events3;
quit;

/* CRSP market sessions assign event day zero to the first actual session on or
   after announcement. This retains the specified trading-day estimation span. */
data work.dsi_raw;
    set crsp.dsi(keep=date vwretd where=(date >= &rawstart and date <= &rawend));
run;
proc sort data=work.dsi_raw out=work.dsi_sort; by date; run;
data work.dsi_sessions;
    set work.dsi_sort;
    session_num+1;
run;

data work.event_parties;
    set work.party(keep=dealid role dateann permno gvkey cusip6);
run;
data work.event_session_dates;
    set work.event_parties;
    do candidate_date=dateann to dateann+7;
        output;
    end;
run;
proc sql;
    create table work.event_session0 as
    select p.dealid,p.role,p.dateann,p.permno,p.gvkey,p.cusip6,
           min(s.session_num) as session0
    from work.event_session_dates as p inner join work.dsi_sessions as s
      on p.candidate_date=s.date
    group by p.dealid,p.role,p.dateann,p.permno,p.gvkey,p.cusip6;
quit;

data work.dsf_raw;
    set crsp.dsf(keep=permno date ret
        where=(date >= &rawstart and date <= &rawend));
    if not missing(permno) and not missing(date);
run;
proc sql;
    create table work.dsf_dup as
    select permno,date,count(*) as n_rows from work.dsf_raw
    group by permno,date having count(*)>1;
    select count(*) as duplicate_daily_security_dates,
           sum(n_rows) as rows_in_duplicate_daily_dates from work.dsf_dup;
    create table work.dsf_key_counts as
    select permno,date,count(*) as n_rows from work.dsf_raw group by permno,date;
    create table work.dsf_unique as
    select d.* from work.dsf_raw as d inner join work.dsf_key_counts as k
      on d.permno=k.permno and d.date=k.date where k.n_rows=1;
quit;
data work.event_session_window;
    set work.event_session0;
    if not missing(session0) then do eventday=-205 to 3;
        session_num=session0+eventday;
        output;
    end;
run;
proc sql;
    create table work.event_daily0 as
    select p.dealid,p.role,p.permno,p.gvkey,p.session0,s.date,s.session_num,
           s.vwretd,d.ret,p.eventday
    from work.event_session_window as p inner join work.dsi_sessions as s
      on s.session_num=p.session_num
    inner join work.dsf_unique as d on d.permno=p.permno and d.date=s.date;
quit;

proc sql;
    create table work.mm_coverage as
    select dealid,role,count(*) as n_window,
           sum(not missing(ret) and not missing(vwretd)) as n_complete,
           std(vwretd) as sd_market
    from work.event_daily0 where eventday>=-205 and eventday<=-6
    group by dealid,role;
    create table work.mm_est as
    select * from work.event_daily0
    where eventday>=-205 and eventday<=-6 and not missing(ret) and not missing(vwretd);
quit;
proc sort data=work.mm_est; by dealid role eventday; run;
ods listing close;
ods output ANOVA=work.mm_anova;
proc reg data=work.mm_est outest=work.mm_out;
    by dealid role;
    model ret=vwretd;
quit;
ods output close;
ods listing;
data work.mm_parms;
    set work.mm_out;
    if _TYPE_='PARMS' and not missing(Intercept) and not missing(vwretd);
    alpha=Intercept;
    beta=vwretd;
    keep dealid role alpha beta;
run;
proc sql;
    create table work.mm_rank as
    select dealid,role,
           max(case when upcase(Source)='MODEL' then DF end) as model_df,
           max(case when upcase(Source)='ERROR' then DF end) as error_df
    from work.mm_anova group by dealid,role;
    create table work.mm_valid as
    select p.*,c.n_window,c.n_complete,c.sd_market,r.model_df,r.error_df
    from work.mm_parms as p inner join work.mm_coverage as c
      on p.dealid=c.dealid and p.role=c.role
    inner join work.mm_rank as r on p.dealid=r.dealid and p.role=r.role
    where c.n_complete>=3 and c.sd_market>0 and r.model_df=1 and r.error_df>=1;
    create table work.car_day as
    select d.dealid,d.role,d.eventday,d.ret,d.vwretd,
           d.ret-(m.alpha+m.beta*d.vwretd) as abret
    from work.event_daily0 as d inner join work.mm_valid as m
      on d.dealid=m.dealid and d.role=m.role
    where d.eventday in (-1,0,1) and not missing(d.ret) and not missing(d.vwretd);
    create table work.car_by_role as
    select dealid,role,count(abret) as n_eventdays,sum(abret) as car
    from work.car_day group by dealid,role;
    create table work.car_wide as
    select dealid,
      max(case when role='A' and n_eventdays=3 then car end) as acq_car,
      max(case when role='T' and n_eventdays=3 then car end) as trg_car,
      max(case when role='A' and n_eventdays=3 then n_eventdays end) as n_acq_eventdays,
      max(case when role='T' and n_eventdays=3 then n_eventdays end) as n_trg_eventdays
    from work.car_by_role group by dealid;
    create table work.car_diagnostics as
    select c.role,count(*) as estimable_market_models,
           mean(c.n_complete) as mean_estimation_days,
           min(c.n_complete) as min_estimation_days,
           max(c.n_complete) as max_estimation_days,
           sum(c.sd_market<=0) as zero_market_variance_groups
    from work.mm_valid as c group by c.role;
    select role,count(*) as linked_event_participants,
           sum(not missing(session0)) as participants_with_day0
    from work.event_session0 group by role;
quit;
title "Market-model parameter window coverage and native PROC REG fits";
proc print data=work.car_diagnostics noobs; run;
title;
title "Daily return coverage over the specified market-model window";
proc means data=work.mm_coverage n mean median min p25 p75 max;
    class role;
    var n_window n_complete sd_market;
run;
title;




/* Full same-industry quarterly accounting-system maps. Requests are unique by
   target, pre-announcement calendar quarter, and target SIC2, so repeated deals
   reuse the same map. All firms reporting in that SIC2 at the anchor quarter
   enter; each map then uses the firm's 16 preceding fiscal quarters. */
proc sql;
    create table work.target_req as
    select distinct e.trggvkey as targetgvkey length=6,e.anchorq,e.trg_sic2 as sic2,
           e.trgpermno,q.fqidx as target_fqidx,
           intnx('qtr',min(e.dateann),-16,'b') as win_start format=yymmdd10.,
           intnx('qtr',min(e.dateann),-1,'e') as win_end format=yymmdd10.
    from work.events3 as e inner join work.fq_final as q
      on q.gvkey=e.trggvkey and q.qidx=e.anchorq
    where not missing(e.trggvkey) and not missing(e.trg_sic2) and not missing(e.trgpermno)
      and not missing(q.fqidx)
    group by e.trggvkey,e.anchorq,e.trg_sic2,e.trgpermno,q.fqidx;

    create table work.event_industry as
    select distinct anchorq,sic2 from work.target_req;
    create table work.industry_members as
    select i.anchorq,i.sic2,q.gvkey as peer_gvkey length=6,
           q.fqidx as anchor_fqidx
    from work.event_industry as i inner join work.fq_final as q
      on q.qidx=i.anchorq and q.sic2=i.sic2
    where not missing(q.gvkey) and not missing(q.fqidx);
    create table work.comp_hist0 as
    select m.anchorq,m.sic2,m.peer_gvkey as gvkey length=6,m.anchor_fqidx,
           q.qidx,q.fqidx,q.datadate,q.fdateq,q.earnings,q.bhr_fiscal,q.noncalendar_q
    from work.industry_members as m inner join work.fq_final as q
      on q.gvkey=m.peer_gvkey and q.qidx<=m.anchorq
     and q.fqidx between m.anchor_fqidx-15 and m.anchor_fqidx;
    create table work.comp_hist_dups as
    select anchorq,sic2,gvkey,fqidx,count(*) as n_rows
    from work.comp_hist0 group by anchorq,sic2,gvkey,fqidx having count(*)>1;
    select count(*) as duplicate_window_keys,
           sum(n_rows) as duplicate_window_rows
    from work.comp_hist_dups;
quit;
proc sort data=work.comp_hist0; by anchorq sic2 gvkey fqidx datadate fdateq; run;
data work.comp_hist;
    set work.comp_hist0;
    by anchorq sic2 gvkey fqidx;
    if last.fqidx;
run;
proc sql;
    create table work.comp_fiscal_dups as
    select anchorq,sic2,gvkey,fqidx,count(*) as n_rows
    from work.comp_hist group by anchorq,sic2,gvkey,fqidx having count(*)>1;
    select count(*) as postdedup_fiscal_rows,
           sum(qidx>anchorq) as post_anchor_rows,
           sum(fqidx<anchor_fqidx-15 or fqidx>anchor_fqidx) as out_window_rows
    from work.comp_hist;
    create table work.comp_window_check as
    select anchorq,sic2,gvkey,min(fqidx) as min_fqidx,max(fqidx) as max_fqidx,
           count(distinct fqidx) as n_fiscal_keys,
           max(anchor_fqidx) as anchor_fqidx
    from work.comp_hist group by anchorq,sic2,gvkey;
    select count(*) as fiscal_windows,
           max(n_fiscal_keys) as max_window_keys,
           sum(n_fiscal_keys>16) as windows_over_16_keys,
           sum(max_fqidx-min_fqidx+1>16) as windows_over_16_span
    from work.comp_window_check;
quit;
data work.comp_roll;
    set work.comp_hist;
    if not missing(earnings) and not missing(bhr_fiscal);
run;
proc sort data=work.comp_roll; by anchorq sic2 gvkey fqidx; run;
/* Center and scale within the exact regression group before PROC REG. The
   common factor 1000 is applied to both centered variables, so the slope is
   unchanged; adding the saved group means back reconstructs the original
   intercept. This addresses PROC REG's small-range warnings without changing
   the intercept OLS estimand or its residual degrees of freedom. */
proc means data=work.comp_roll noprint;
    by anchorq sic2 gvkey;
    var earnings bhr_fiscal;
    output out=work.comp_means(drop=_TYPE_ _FREQ_)
        mean=mean_earn mean_bhr;
run;
data work.comp_roll_fit;
    merge work.comp_roll(in=in_roll) work.comp_means;
    by anchorq sic2 gvkey;
    if in_roll;
    earn_c=(earnings-mean_earn)*1000;
    bhr_c=(bhr_fiscal-mean_bhr)*1000;
run;
ods listing close;
ods output ANOVA=work.comp_anova;
proc reg data=work.comp_roll_fit outest=work.comp_out;
    by anchorq sic2 gvkey;
    model earn_c=bhr_c;
quit;
ods output close;
ods listing;
proc sql;
    create table work.comp_n as
    select anchorq,sic2,gvkey,count(*) as n_obs,std(bhr_fiscal) as sd_bhr
    from work.comp_roll group by anchorq,sic2,gvkey;
    select count(*) as peer_firm_windows,
           sum(n_obs>=14) as windows_with_14_quarters,
           sum(n_obs>=14 and not missing(sd_bhr) and sd_bhr>0)
               as eligible_positive_bhr_variance,
           sum(n_obs>=14 and not missing(sd_bhr) and sd_bhr=0)
               as eligible_zero_bhr_variance,
           sum(n_obs<14) as windows_below_14_quarters
    from work.comp_n;
    select count(*) as valid_firm_window_rows,
           sum(noncalendar_q=1) as offcal_comp_rows
    from work.comp_roll;
quit;
proc sql;
    create table work.comp_parms0 as
    select p.anchorq,p.sic2,p.gvkey,
           (m.mean_earn+p.Intercept/1000-p.bhr_c*m.mean_bhr) as alpha,
           p.bhr_c as beta
    from work.comp_out as p inner join work.comp_means as m
      on p.anchorq=m.anchorq and p.sic2=m.sic2 and p.gvkey=m.gvkey
    where p._TYPE_='PARMS' and not missing(p.Intercept) and not missing(p.bhr_c);

    create table work.comp_rank as
    select anchorq,sic2,gvkey,
           max(case when upcase(Source)='MODEL' then DF end) as model_df,
           max(case when upcase(Source)='ERROR' then DF end) as error_df
    from work.comp_anova group by anchorq,sic2,gvkey;
    select count(*) as native_anova_groups,
           sum(model_df=1 and error_df>=12) as full_rank_n,
           sum(missing(model_df) or missing(error_df) or model_df ne 1 or error_df<12)
               as rank_df_fail_n
    from work.comp_rank;
    select count(*) as coef_complete_n from work.comp_parms0;
    create table work.comp_parms as
    select p.*,n.n_obs,n.sd_bhr,r.model_df,r.error_df
    from work.comp_parms0 as p inner join work.comp_n as n
      on p.anchorq=n.anchorq and p.sic2=n.sic2 and p.gvkey=n.gvkey
    inner join work.comp_rank as r
      on p.anchorq=r.anchorq and p.sic2=r.sic2 and p.gvkey=r.gvkey
    where n.n_obs>=14 and n.sd_bhr>0 and r.model_df=1 and r.error_df>=12;
    select count(*) as accepted_map_n from work.comp_parms;

    create table work.comp_pairs_q as
    select t.targetgvkey,t.anchorq,t.sic2,cj.gvkey as peergvkey length=6,
           q.qidx,q.fqidx,(ci.alpha+ci.beta*q.bhr_fiscal) as pred_i,
           (cj.alpha+cj.beta*q.bhr_fiscal) as pred_j
    from work.target_req as t
    inner join work.comp_parms as ci
      on ci.anchorq=t.anchorq and ci.sic2=t.sic2 and ci.gvkey=t.targetgvkey
    inner join work.comp_parms as cj
      on cj.anchorq=t.anchorq and cj.sic2=t.sic2 and cj.gvkey ne t.targetgvkey
    inner join work.comp_hist as q
      on q.anchorq=t.anchorq and q.sic2=t.sic2 and q.gvkey=t.targetgvkey
    where not missing(q.bhr_fiscal);

    create table work.comp_pair as
    select targetgvkey,anchorq,sic2,peergvkey,count(*) as n_overlap,
           mean(abs(pred_i-pred_j)) as pair_absdiff
    from work.comp_pairs_q
    group by targetgvkey,anchorq,sic2,peergvkey
    having calculated n_overlap>=14;
    create table work.target_comp as
    select targetgvkey,anchorq,sic2,-mean(pair_absdiff) as trg_comp,
           count(*) as n_comp_peers,mean(n_overlap) as mean_comp_overlap
    from work.comp_pair group by targetgvkey,anchorq,sic2;
    select count(*) as target_event_firm_windows,
           sum(not missing(trg_comp)) as targets_with_comparability,
           mean(n_comp_peers) as mean_valid_peer_maps,
           min(n_comp_peers) as min_valid_peer_maps,
           max(n_comp_peers) as max_valid_peer_maps
    from work.target_comp;
quit;

/* Rank at the eligible acquisition level, so repeated deals count as separate
   Table 3 observations even when the target score is reused within a quarter. */
proc sql;
    create table work.target_scores0 as
    select e.dealid,e.trggvkey as targetgvkey length=6,e.anchorq,e.trg_sic2 as sic2,
           c.trg_comp,c.n_comp_peers,c.mean_comp_overlap
    from work.events3 as e left join work.target_comp as c
      on e.trggvkey=c.targetgvkey and e.anchorq=c.anchorq and e.trg_sic2=c.sic2;
quit;
proc rank data=work.target_scores0 out=work.target_comp_rank groups=10;
    var trg_comp;
    ranks trg_decile;
run;
data work.target_comp_rank;
    set work.target_comp_rank;
    if not missing(trg_decile) then trg_comprnk=trg_decile/9;
    label trg_comp='Raw target financial-statement comparability'
          trg_comprnk='Decile rank of target comparability divided by nine';
run;

/* Standard PROC CORR computes pairwise raw quarterly return correlations
   against all other firms in the target SIC2 over the same 16 quarters. */
proc sql;
    create table work.corr_pairs0 as
    select t.targetgvkey,t.anchorq,t.sic2,m.peer_gvkey as peergvkey length=6,
           qt.qidx,qt.bhr as target_bhr,qp.bhr as peer_bhr
    from work.target_req as t
    inner join work.industry_members as m
      on m.anchorq=t.anchorq and m.sic2=t.sic2 and m.peer_gvkey ne t.targetgvkey
    inner join work.fq_final as qt
      on qt.gvkey=t.targetgvkey and qt.qidx between t.anchorq-15 and t.anchorq
    inner join work.fq_final as qp
      on qp.gvkey=m.peer_gvkey and qp.qidx=qt.qidx
    where not missing(qt.bhr) and not missing(qp.bhr);
    create table work.corr_n as
    select targetgvkey,anchorq,sic2,peergvkey,count(*) as n_overlap
    from work.corr_pairs0 group by targetgvkey,anchorq,sic2,peergvkey
    having calculated n_overlap>=14;
    create table work.corr_pairs as
    select p.* from work.corr_pairs0 as p inner join work.corr_n as n
      on p.targetgvkey=n.targetgvkey and p.anchorq=n.anchorq and
         p.sic2=n.sic2 and p.peergvkey=n.peergvkey;
quit;
proc sort data=work.corr_pairs; by targetgvkey anchorq sic2 peergvkey qidx; run;
proc corr data=work.corr_pairs outp=work.corr_out noprint;
    by targetgvkey anchorq sic2 peergvkey;
    var target_bhr peer_bhr;
run;
data work.corr_pair;
    set work.corr_out;
    if _TYPE_='CORR' and _NAME_='target_bhr';
    paircorr=peer_bhr;
    keep targetgvkey anchorq sic2 peergvkey paircorr;
run;
proc sql;
    create table work.target_corr as
    select targetgvkey,anchorq,sic2,mean(paircorr) as stock_corr,
           count(paircorr) as n_corr_peers
    from work.corr_pair group by targetgvkey,anchorq,sic2;
    select count(*) as valid_target_peer_pairs,mean(n_overlap) as mean_corr_overlap
    from work.corr_n;
quit;

/* Daily target-return synchronicity: standard PROC REG adjusted R-squared,
   left on its native [0,1] scale. */
proc sql;
    create table work.sync_daily0 as
    select distinct t.targetgvkey,t.anchorq,t.sic2,t.trgpermno,
           d.date,d.ret,s.vwretd
    from work.target_req as t
    inner join work.dsf_unique as d
      on d.permno=t.trgpermno and d.date between t.win_start and t.win_end
    inner join work.dsi_sessions as s on s.date=d.date;
    create table work.sync_n as
    select targetgvkey,anchorq,sic2,count(*) as n_obs,
           sum(not missing(ret) and not missing(vwretd)) as n_complete,
           std(vwretd) as sd_market
    from work.sync_daily0 group by targetgvkey,anchorq,sic2;
    create table work.sync_fit_data as
    select * from work.sync_daily0 where not missing(ret) and not missing(vwretd);
quit;
proc sort data=work.sync_fit_data; by targetgvkey anchorq sic2 date; run;
ods listing close;
ods output ANOVA=work.sync_anova FitStatistics=work.sync_fitstats;
proc reg data=work.sync_fit_data outest=work.sync_out;
    by targetgvkey anchorq sic2;
    model ret=vwretd;
quit;
ods output close;
ods listing;
data work.sync_adj;
    set work.sync_fitstats;
    if upcase(strip(label2))='ADJ R-SQ';
    sync_adj=nvalue2;
    keep targetgvkey anchorq sic2 sync_adj;
run;
proc sql;
    create table work.sync_rank as
    select targetgvkey,anchorq,sic2,
           max(case when upcase(Source)='MODEL' then DF end) as model_df,
           max(case when upcase(Source)='ERROR' then DF end) as error_df
    from work.sync_anova group by targetgvkey,anchorq,sic2;
    create table work.target_sync as
    select p.targetgvkey,p.anchorq,p.sic2,
           p.sync_adj as sync,n.n_complete as sync_days,
           r.model_df,r.error_df
    from work.sync_adj as p inner join work.sync_n as n
      on p.targetgvkey=n.targetgvkey and p.anchorq=n.anchorq and p.sic2=n.sic2
    inner join work.sync_rank as r
      on p.targetgvkey=r.targetgvkey and p.anchorq=r.anchorq and p.sic2=r.sic2
    where n.n_complete>=3 and n.sd_market>0 and r.model_df=1 and r.error_df>=1;
    select count(*) as target_sync_fits,
           mean(sync_days) as mean_daily_sessions,
           min(sync_days) as min_daily_sessions,
           max(sync_days) as max_daily_sessions,
           min(sync) as min_adjusted_r2,max(sync) as max_adjusted_r2
    from work.target_sync;
quit;

/* S34 BLOCK construction. The WRDS guide says RDATE is holdings-effective,
   FDATE is the vendor vintage, SHARES is split-adjusted from RDATE to FDATE,
   and SHROUT2 is a thousands-of-shares FDATE field. Select the first vintage
   per manager/report date, map the eight-character holding CUSIP to dated
   CRSP NCUSIP, and translate SHARES back to the RDATE CRSP share basis. */
data work.s34_raw;
    set tfn.s34(keep=fdate rdate mgrno cusip shares shrout2
        where=(rdate >= '01JAN1982'd and rdate <= &annend and
               fdate >= '01JAN1982'd and fdate <= &annend));
    if not missing(mgrno) and not missing(cusip) and not missing(shares);
    s34cusip8=substr(compress(upcase(strip(cusip))),1,8);
    if lengthn(s34cusip8)=8;
    rdate_mkey=year(rdate)*12+month(rdate);
    fdate_mkey=year(fdate)*12+month(fdate);
run;
proc sql;
    create table work.s34_firstdate as
    select mgrno,rdate,min(fdate) as fdate format=yymmdd10.
    from work.s34_raw group by mgrno,rdate;
    create table work.block_target_cusips as
    select distinct e.dealid,e.dateann,e.trggvkey,e.trgpermno,
           sh.cusip8,sh.efffrom,sh.effthru
    from work.events3 as e inner join work.cusip_hist_unique as sh
      on e.trggvkey=sh.gvkey and sh.effthru>=e.dateann-183
     and sh.efffrom<=e.dateann
    where not missing(e.trggvkey) and not missing(e.trgpermno);
    select count(*) as s34_first_keys,
           sum(fdate<rdate) as vintage_before_report_date
    from work.s34_firstdate;
quit;
data work.block_target_months;
    set work.block_target_cusips;
    first_mkey=year(dateann-183)*12+month(dateann-183);
    last_mkey=year(dateann)*12+month(dateann);
    do rdate_mkey=first_mkey to last_mkey;
        output;
    end;
    keep dealid dateann trggvkey trgpermno cusip8 efffrom effthru rdate_mkey;
run;
proc sql;
    create table work.s34_target_first as
    select t.dealid,t.dateann,t.trggvkey,t.trgpermno,
           h.s34cusip8,h.mgrno,h.rdate,h.fdate,h.shares,h.shrout2,
           h.rdate_mkey,h.fdate_mkey
    from work.block_target_months as t inner join work.s34_raw as h
      on t.cusip8=h.s34cusip8 and t.rdate_mkey=h.rdate_mkey
     and h.rdate>=t.efffrom and h.rdate<=t.effthru
     and h.rdate>=t.dateann-183 and h.rdate<=t.dateann
    inner join work.s34_firstdate as v
      on h.mgrno=v.mgrno and h.rdate=v.rdate and h.fdate=v.fdate
    where h.fdate<=t.dateann and h.shares>=0;

    create table work.block_candidates as
    select h.dealid,h.dateann,h.trggvkey,h.trgpermno,h.s34cusip8,
           h.mgrno,h.rdate,h.fdate,h.shares,h.shrout2,
           r.shrout as rdate_shrout,r.cfacshr as rdate_cfacshr,
           f.cfacshr as fdate_cfacshr,
           f.shrout as fdate_crsp_shrout,
           f.cfacshr/r.cfacshr as cfac_ratio,
           case when h.shrout2>0 then h.shares/(h.shrout2*1000) else . end as s34_fdate_fraction,
           h.shares*(f.cfacshr/r.cfacshr) as shares_rdate,
           h.shares*(f.cfacshr/r.cfacshr)/(r.shrout*1000) as ownerfrac,
           case when h.shrout2>0 and r.shrout>0 then
             h.shares/(h.shrout2*1000)-h.shares*(f.cfacshr/r.cfacshr)/(r.shrout*1000)
             else . end as frac_basis_diff
    from work.s34_target_first as h inner join work.crsp_names0 as n
      on n.permno=h.trgpermno and n.ncusip=h.s34cusip8
     and h.rdate>=n.namedt and h.rdate<=n.nameenddt
    inner join work.msf_raw as r
      on r.permno=h.trgpermno and r.mkey=h.rdate_mkey
    inner join work.msf_raw as f
      on f.permno=h.trgpermno and f.mkey=h.fdate_mkey
    where r.shrout>0 and
          r.cfacshr>0 and f.cfacshr>0;

    create table work.block_mgrdate_counts as
    select dealid,mgrno,rdate,count(*) as n_rows
    from work.block_candidates group by dealid,mgrno,rdate;
    create table work.block_unique0 as
    select b.* from work.block_candidates as b
    inner join work.block_mgrdate_counts as c
      on b.dealid=c.dealid and b.mgrno=c.mgrno and b.rdate=c.rdate
    where c.n_rows=1 and not missing(b.ownerfrac);
    create table work.block_mgr_best as
    select dealid,mgrno,max(rdate) as rdate format=yymmdd10.
    from work.block_unique0 group by dealid,mgrno;
    create table work.block_mgr as
    select b.* from work.block_unique0 as b inner join work.block_mgr_best as m
      on b.dealid=m.dealid and b.mgrno=m.mgrno and b.rdate=m.rdate;
    create table work.block_event as
    select dealid,max(ownerfrac>0.05) as block,
           count(*) as n_observed_managers,max(rdate) as latest_holdings_rdate format=yymmdd10.,
           max(fdate) as max_fdate format=yymmdd10.
    from work.block_mgr group by dealid;
    select count(*) as target_first_vintage_holdings
    from work.s34_target_first;
    select count(*) as target_with_holdings,
           sum(block=1) as target_events_with_gt5_manager,
           sum(block=0) as target_events_no_gt5_manager
    from work.block_event;
    select count(*) as matched_manager_reports,
           min(ownerfrac) as min_fraction,
           median(ownerfrac) as median_fraction,
           max(ownerfrac) as max_fraction,
           sum(ownerfrac>1) as fractions_over_one,
           sum(cfac_ratio ne 1) as nontrivial_split_ratios,
           median(cfac_ratio) as median_split_ratio,
           median(s34_fdate_fraction) as median_fdate_fraction,
           median(frac_basis_diff) as med_basis_diff
    from work.block_mgr;
quit;
title "S34 manager ownership fraction tails";
proc means data=work.block_mgr n nmiss min p1 median p99 max;
    var ownerfrac cfac_ratio s34_fdate_fraction frac_basis_diff;
run;
title;

/* Annual performance match. Match peers in the acquisition year before
   announcement using the ordered 80%–120% ROA band, including negative ROA. */
proc sql;
    create table work.delta_peer_candidates as
    select e.dealid,e.acqgvkey,e.acq_sic2a as sic2,e.baseyear,
           e.acq_roa as match_roa,p.gvkey as peergvkey length=6,p.roa as peer_base_roa
    from work.events3 as e inner join work.fa_cal as p
      on p.calyear=e.baseyear and p.sic2=e.acq_sic2a
    where not missing(e.acqgvkey) and not missing(e.acq_roa) and
          not missing(e.acq_sic2a) and p.gvkey ne e.acqgvkey and not missing(p.roa)
      and p.roa>=min(0.8*e.acq_roa,1.2*e.acq_roa)
      and p.roa<=max(0.8*e.acq_roa,1.2*e.acq_roa);
    create table work.delta_peer_n as
    select dealid,count(distinct peergvkey) as n_match_peers
    from work.delta_peer_candidates group by dealid;

    create table work.peer_roa_year as
    select m.dealid,y.calyear,median(y.roa) as peer_median_roa,
           count(y.roa) as n_peer_roa
    from work.delta_peer_candidates as m inner join work.events3 as e
      on m.dealid=e.dealid
    inner join work.fa_cal as y on y.gvkey=m.peergvkey
      and y.calyear between year(e.dateeff)-3 and year(e.dateeff)+3
      and y.calyear ne year(e.dateeff)
    where not missing(e.dateeff)
    group by m.dealid,y.calyear;

    create table work.acq_roa_year as
    select e.dealid,year(e.dateeff) as compyear,y.calyear,
           y.roa as acq_roa_year,p.peer_median_roa,p.n_peer_roa,
           y.roa-p.peer_median_roa as adj_roa
    from work.events3 as e inner join work.fa_cal as y
      on y.gvkey=e.acqgvkey and
         y.calyear between year(e.dateeff)-3 and year(e.dateeff)+3
         and y.calyear ne year(e.dateeff)
    left join work.peer_roa_year as p
      on e.dealid=p.dealid and y.calyear=p.calyear
    where not missing(e.dateeff);
quit;
proc sort data=work.acq_roa_year; by dealid calyear; run;
data work.delta_out;
    set work.acq_roa_year;
    by dealid;
    retain pre_sum post_sum pre_n post_n;
    if first.dealid then do; pre_sum=0; post_sum=0; pre_n=0; post_n=0; end;
    if not missing(adj_roa) then do;
        if calyear>=compyear-3 and calyear<=compyear-1 then do;
            pre_sum+adj_roa; pre_n+1;
        end;
        else if calyear>=compyear+1 and calyear<=compyear+3 then do;
            post_sum+adj_roa; post_n+1;
        end;
    end;
    if last.dealid then do;
        delta_roa=.;
        if pre_n=3 and post_n=3 then delta_roa=post_sum/3-pre_sum/3;
        output;
    end;
    keep dealid compyear pre_n post_n delta_roa;
    label delta_roa='Post-completion mean benchmark-adjusted ROA less pre-completion mean';
run;
proc sql;
    select count(*) as events_with_dateeff,
           count(distinct dealid) as delta_peer_matched,
           mean(n_match_peers) as mean_match_peers,
           min(n_match_peers) as min_match_peers,
           max(n_match_peers) as max_match_peers
    from work.delta_peer_n;
    select count(*) as delta_year_rows,
           sum(pre_n=3 and post_n=3) as complete_six_year_delta_roa,
           sum(missing(delta_roa)) as missing_delta_roa
    from work.delta_out;
quit;

/* Merge the separately constructed outcomes and controls without allowing
   Delta ROA's longer window to restrict either CAR regression. */
proc sql;
    create table work.analysis0 as
    select e.*,c.acq_car,c.trg_car,c.n_acq_eventdays,c.n_trg_eventdays,
           r.trg_comprnk,r.trg_comp,r.n_comp_peers,
           x.stock_corr,x.n_corr_peers,
           s.sync,s.sync_days,
           b.block,b.n_observed_managers,b.latest_holdings_rdate,b.max_fdate,
           d.delta_roa,d.compyear,d.pre_n,d.post_n,
           case when e.acq_mve_usd>0 and e.trg_mve_usd>0 and
                     not missing(c.acq_car) and not missing(c.trg_car)
                then (e.acq_mve_usd/(e.acq_mve_usd+e.trg_mve_usd))*c.acq_car+
                     (e.trg_mve_usd/(e.acq_mve_usd+e.trg_mve_usd))*c.trg_car
                else . end as synergy
    from work.events3 as e
    left join work.car_wide as c on e.dealid=c.dealid
    left join work.target_comp_rank as r on e.dealid=r.dealid
    left join work.target_corr as x
      on e.trggvkey=x.targetgvkey and e.anchorq=x.anchorq and e.trg_sic2=x.sic2
    left join work.target_sync as s
      on e.trggvkey=s.targetgvkey and e.anchorq=s.anchorq and e.trg_sic2=s.sic2
    left join work.block_event as b on e.dealid=b.dealid
    left join work.delta_out as d on e.dealid=d.dealid;
quit;

data work.analysis;
    set work.analysis0;
    acq_complete=(not missing(acq_car) and not missing(trg_comprnk) and
       not missing(acq_size) and not missing(acq_lev) and not missing(acq_tobin_dum) and
       not missing(acq_roa) and not missing(acq_fcf) and not missing(acq_q_fcf) and
       not missing(trg_size) and not missing(trg_lev) and not missing(trg_tobin) and
       not missing(trg_roa) and not missing(stock_corr) and not missing(sync) and
       not missing(block) and not missing(all_cash) and not missing(all_stock) and
       not missing(tender_d) and not missing(hostile) and not missing(diffind) and
       not missing(rel_size));
    synergy_complete=(acq_complete and not missing(synergy));
    delta_complete=(not missing(delta_roa) and not missing(trg_comprnk) and
       not missing(acq_size) and not missing(acq_lev) and not missing(acq_tobin_dum) and
       not missing(acq_roa) and not missing(acq_fcf) and not missing(acq_q_fcf) and
       not missing(trg_size) and not missing(trg_lev) and not missing(trg_tobin) and
       not missing(trg_roa) and not missing(stock_corr) and not missing(sync) and
       not missing(block) and not missing(all_cash) and not missing(all_stock) and
       not missing(tender_d) and not missing(hostile) and not missing(diffind) and
       not missing(rel_size));
run;

title "Outcome, main-regressor and complete-control coverage in the handoff";
proc sql;
    select count(*) as material_deal_rows,
           sum(not missing(acq_car)) as available_acquirer_car,
           sum(not missing(synergy)) as available_synergy,
           sum(not missing(delta_roa)) as available_delta_roa,
           sum(not missing(trg_comprnk)) as avail_comprank,
           sum(not missing(stock_corr)) as available_stock_corr,
           sum(not missing(sync)) as available_sync,
           sum(not missing(block)) as observed_block,
           sum(acq_complete) as acq_car_full_controls,
           sum(synergy_complete) as synergy_full_controls,
           sum(delta_complete) as delta_roa_full_controls
    from work.analysis;
quit;
title;
title "Final deal-level outcome and control distributions";
proc means data=work.analysis n nmiss mean std p1 p25 median p75 p99 min max;
    var acq_car synergy delta_roa trg_comprnk acq_size acq_lev acq_tobin_dum
        acq_roa acq_fcf acq_q_fcf trg_size trg_lev trg_tobin trg_roa
        stock_corr sync block all_cash all_stock tender_d hostile diffind rel_size;
run;
title;
title "Table 2 comparison: acquisition CAR complete-control sample";
proc means data=work.analysis n mean std p25 median p75;
    where acq_complete=1;
    var acq_car trg_car synergy delta_roa trg_comp acq_mve_usd acq_lev acq_tobin
        acq_roa acq_fcf trg_mve_usd trg_lev trg_tobin trg_roa all_cash all_stock
        tender_d hostile diffind rel_size block stock_corr sync;
run;
title "Table 2 comparison: synergy complete-control sample";
proc means data=work.analysis n mean std p25 median p75;
    where synergy_complete=1;
    var acq_car trg_car synergy delta_roa trg_comp acq_mve_usd acq_lev acq_tobin
        acq_roa acq_fcf trg_mve_usd trg_lev trg_tobin trg_roa all_cash all_stock
        tender_d hostile diffind rel_size block stock_corr sync;
run;
title "Table 2 comparison: delta ROA complete-control sample";
proc means data=work.analysis n mean std p25 median p75;
    where delta_complete=1;
    var acq_car trg_car synergy delta_roa trg_comp acq_mve_usd acq_lev acq_tobin
        acq_roa acq_fcf trg_mve_usd trg_lev trg_tobin trg_roa all_cash all_stock
        tender_d hostile diffind rel_size block stock_corr sync;
run;
title;
proc sql;
    create table work.final_dup as
    select dealid,count(*) as n_rows from work.analysis group by dealid having count(*)>1;
    select count(*) as duplicate_final_deal_keys from work.final_dup;
quit;

data out.us_acquisitions_1307;
    set work.analysis;
    keep dealid acq_car synergy delta_roa trg_comprnk acq_size acq_lev acq_tobin_dum
         acq_roa acq_fcf acq_q_fcf trg_size trg_lev trg_tobin trg_roa
         stock_corr sync block all_cash all_stock tender_d hostile diffind rel_size
         acq_mve_usd trg_mve_usd n_comp_peers n_corr_peers sync_days
         n_observed_managers latest_holdings_rdate max_fdate
         acq_complete synergy_complete delta_complete;
    label acq_car='Acquirer three-day market-model cumulative abnormal return'
          synergy='Acquirer and target CAR weighted by prior-quarter company market value'
          delta_roa='Post-completion less pre-completion benchmark-adjusted ROA'
          trg_comprnk='Target comparability decile rank divided by nine'
          acq_size='Log prior-quarter acquirer company market value in USD millions'
          trg_size='Log prior-quarter target company market value in USD millions'
          acq_lev='Acquirer long-term and short-term debt over total assets'
          trg_lev='Target long-term and short-term debt over total assets'
          acq_tobin_dum='One if acquirer Tobin Q is below sample median'
          acq_roa='Acquirer operating income before depreciation over average assets'
          trg_roa='Target operating income before depreciation over average assets'
          acq_fcf='Acquirer free cash flow over total assets'
          acq_q_fcf='Acquirer Q dummy times free cash flow'
          trg_tobin='Target market value of assets over book assets'
          stock_corr='Mean target-to-industry quarterly return correlation'
          sync='Target daily stock-return adjusted R-squared on market return'
          block='Any observed institution manager holds more than five percent'
          all_cash='At least ninety percent of consideration paid in cash'
          all_stock='At least ninety percent of consideration paid in stock'
          tender_d='SDC tender-offer indicator'
          hostile='SDC hostile-attitude indicator'
          diffind='Acquirer and target have different two-digit SIC'
          rel_size='SDC ranking deal value divided by prior-quarter acquirer MVE';
run;

