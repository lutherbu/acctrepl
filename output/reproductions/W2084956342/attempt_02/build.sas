options errorabend msglevel=i;

libname comp '/storage/sas/base/comp/d_na' access=readonly;
libname compco '/storage/sas/base/comp/d_na/company' access=readonly;
libname ccm '/storage/sas/base/crsp/a_ccm' access=readonly;
libname crsp '/storage/sas/base/crsp/a_stock' access=readonly;
libname out 'data/compustat_108617';

/* Bounded formula check with unequal balances and adjacent-year asset scales. */
data work.formula_check;
    che_p=16; che_t=20;
    act_p=60; act_t=70;
    lct_p=35; lct_t=40;
    dlc_p=5; dlc_t=8;
    at_p=120; at_t=150; at_n=180;
    ivao_p=10; ivao_t=12;
    lt_p=65; lt_t=80;
    dltt_p=12; dltt_t=15;
    pstk_p=3; pstk_t=4;
    ivst_p=20; ivst_t=25;
    oiadp_t=30; oiadp_n=33;

    avg_at_t=(at_p+at_t)/2;
    avg_at_n=(at_t+at_n)/2;
    coa_p=act_p-che_p; coa_t=act_t-che_t;
    col_p=lct_p-dlc_p; col_t=lct_t-dlc_t;
    ncoa_p=at_p-act_p-ivao_p; ncoa_t=at_t-act_t-ivao_t;
    ncol_p=lt_p-lct_p-dltt_p; ncol_t=lt_t-lct_t-dltt_t;
    finl_p=dltt_p+dlc_p+pstk_p; finl_t=dltt_t+dlc_t+pstk_t;
    roa_t=oiadp_t/avg_at_t;
    roa_n=oiadp_n/avg_at_n;
    dcoa=(coa_t-coa_p)/avg_at_t;
    ndcol=-(col_t-col_p)/avg_at_t;
    dncoa=(ncoa_t-ncoa_p)/avg_at_t;
    ndncol=-(ncol_t-ncol_p)/avg_at_t;
    dsti=(ivst_t-ivst_p)/avg_at_t;
    dlti=(ivao_t-ivao_p)/avg_at_t;
    ndfinl=-(finl_t-finl_p)/avg_at_t;

    if abs(roa_t-30/135)>1e-12 or abs(roa_n-33/165)>1e-12 or
       abs(dcoa-6/135)>1e-12 or abs(ndcol-(-2/135))>1e-12 or
       abs(dncoa-18/135)>1e-12 or abs(ndncol-(-7/135))>1e-12 or
       abs(dsti-5/135)>1e-12 or abs(dlti-2/135)>1e-12 or
       abs(ndfinl-(-7/135))>1e-12 then do;
        put 'ERROR: bounded source-equation check failed';
        abort cancel;
    end;
    put 'Bounded source-equation check passed through adjacent-year ROA and all seven signed accrual variables.';
run;

/* Local SIC source audit: the alternate company table is not a 1960s/1970s route. */
proc sql;
    create table work.coind_audit as
    select year,
           count(*) as rows,
           sum(case when sich>=100 and sich<=9999 then 1 else 0 end) as valid_sic,
           min(datadate) as min_date format=yymmdd10.,
           max(datadate) as max_date format=yymmdd10.
    from compco.co_industry
    group by year;

    select count(*) as rows,
           min(year) as first_year,
           max(year) as last_year,
           min(datadate) as first_date format=yymmdd10.,
           max(datadate) as last_date format=yymmdd10.
    from compco.co_industry;
quit;
proc print data=work.coind_audit noobs;
    where year>=1960 and year<=1990;
    title 'COMP.CO_INDUSTRY historical SIC coverage audit';
run;
title;

/* Keep only the documented Compustat annual fields and necessary descriptors. */
data work.funda_raw;
    set comp.funda(keep=gvkey datadate fyear indfmt consol popsrc datafmt curcd
                        che act lct at lt oiadp dltt ivao dlc pstk ivst sale sich
                   where=(fyear>=1961 and fyear<=2002 and indfmt='INDL'
                          and consol='C' and popsrc='D' and datafmt='STD'));
    if missing(gvkey) or missing(datadate) or missing(fyear) then delete;
run;

/* Inspect year labels, actual DATADATE limits, SIC coverage and raw item missingness. */
proc sql;
    create table work.funda_audit as
    select fyear,
           count(*) as rows,
           count(distinct gvkey) as gvkeys,
           min(datadate) as min_date format=yymmdd10.,
           max(datadate) as max_date format=yymmdd10.,
           sum(case when sich>=100 and sich<=9999 then 1 else 0 end) as valid_sic,
           sum(case when missing(sich) or sich<100 or sich>9999 then 1 else 0 end) as unavailable_sic,
           sum(case when missing(curcd) then 1 else 0 end) as missing_currency,
           sum(case when missing(sale) then 1 else 0 end) as missing_item12,
           sum(case when missing(che) then 1 else 0 end) as missing_item1,
           sum(case when missing(act) then 1 else 0 end) as missing_item4,
           sum(case when missing(lct) then 1 else 0 end) as missing_item5,
           sum(case when missing(at) then 1 else 0 end) as missing_item6,
           sum(case when missing(lt) then 1 else 0 end) as missing_item181,
           sum(case when missing(oiadp) then 1 else 0 end) as missing_item178,
           sum(case when missing(dltt) then 1 else 0 end) as zero_item9,
           sum(case when missing(ivao) then 1 else 0 end) as zero_item32,
           sum(case when missing(dlc) then 1 else 0 end) as zero_item34,
           sum(case when missing(pstk) then 1 else 0 end) as zero_item130,
           sum(case when missing(ivst) then 1 else 0 end) as zero_item193
    from work.funda_raw
    group by fyear;

    create table work.dup_fyear as
    select gvkey,fyear,count(*) as n_records,count(distinct datadate) as n_dates
    from work.funda_raw
    group by gvkey,fyear
    having count(*)>1;

    create table work.dup_same_date as
    select gvkey,fyear,datadate,count(*) as n_records
    from work.funda_raw
    group by gvkey,fyear,datadate
    having count(*)>1;

    select count(*) as duplicate_gvkey_fyear_groups
    from work.dup_fyear;
    select count(*) as same_date_duplicate_groups
    from work.dup_same_date;

    create table work.dup_by_year as
    select fyear,count(*) as duplicate_groups,
           min(n_dates) as min_distinct_dates,
           max(n_dates) as max_distinct_dates
    from work.dup_fyear
    group by fyear;
quit;
proc print data=work.funda_audit noobs;
    title 'COMP.FUNDA selected-record audit by fiscal year';
run;
title;
proc print data=work.dup_by_year noobs;
    title 'Annual counts of distinct-date GVKEY/FYEAR duplicates';
run;
title;

data _null_;
    if 0 then set work.dup_same_date nobs=n_same;
    if n_same>0 then do;
        put 'ERROR: duplicate COMP.FUNDA GVKEY/FYEAR/DATADATE records require an explicit source-row review.';
        abort cancel;
    end;
    stop;
run;

/* If the chosen selector set has multiple dates for one GVKEY/FYEAR, keep its latest dated annual row. */
proc sort data=work.funda_raw out=work.funda_sort;
    by gvkey fyear datadate;
run;
data work.funda;
    set work.funda_sort;
    by gvkey fyear;
    if last.fyear;
run;

/* Preserve raw missingness for audit; apply only footnote 8's five explicit zero rules. */
data work.annual;
    set work.funda;
    miss9=missing(dltt);
    miss32=missing(ivao);
    miss34=missing(dlc);
    miss130=missing(pstk);
    miss193=missing(ivst);
    dltt0=coalesce(dltt,0);
    ivao0=coalesce(ivao,0);
    dlc0=coalesce(dlc,0);
    pstk0=coalesce(pstk,0);
    ivst0=coalesce(ivst,0);
run;

/* Fiscal-year joins use exact GVKEY/FYEAR offsets; no row-position shifts or gap filling. */
proc sql;
    create table work.anchors as
    select t.gvkey,
           t.fyear as year,
           t.datadate as date_t format=yymmdd10.,
           p.datadate as date_p format=yymmdd10.,
           n.datadate as date_n format=yymmdd10.,
           p.curcd as curcd_p,
           t.curcd as curcd_t,
           n.curcd as curcd_n,
           t.sich as sich_t,
           p.che as che_p, t.che as che_t,
           p.act as act_p, t.act as act_t,
           p.lct as lct_p, t.lct as lct_t,
           p.at as at_p, t.at as at_t, n.at as at_n,
           p.lt as lt_p, t.lt as lt_t,
           t.oiadp as oiadp_t, n.oiadp as oiadp_n,
           p.sale as sale_p, t.sale as sale_t,
           p.dltt0 as dltt_p, t.dltt0 as dltt_t,
           p.ivao0 as ivao_p, t.ivao0 as ivao_t,
           p.dlc0 as dlc_p, t.dlc0 as dlc_t,
           p.pstk0 as pstk_p, t.pstk0 as pstk_t,
           p.ivst0 as ivst_p, t.ivst0 as ivst_t,
           t.miss9 as miss9_t, p.miss9 as miss9_p,
           t.miss32 as miss32_t, p.miss32 as miss32_p,
           t.miss34 as miss34_t, p.miss34 as miss34_p,
           t.miss130 as miss130_t, p.miss130 as miss130_p,
           t.miss193 as miss193_t, p.miss193 as miss193_p
    from work.annual as t
    left join work.annual as p
      on t.gvkey=p.gvkey and p.fyear=t.fyear-1
    left join work.annual as n
      on t.gvkey=n.gvkey and n.fyear=t.fyear+1
    where t.fyear>=1962 and t.fyear<=2001;
quit;

/* Date-valid CCM links and CRSP dated SIC are used only where FUNDA SICH is unavailable. */
proc sql;
    create table work.sic_candidate as
    select distinct a.gvkey,a.year,l.linkprim,
           case when s.siccd>=100 and s.siccd<=9999 then s.siccd else . end as siccd
    from work.anchors as a
    left join ccm.ccmxpf_linktable as l
      on a.gvkey=l.gvkey
     and (l.linkdt<=a.date_t or l.linkdt=.B)
     and (l.linkenddt>=a.date_t or l.linkenddt=.E)
     and l.linktype in ('LC','LU')
     and l.linkprim in ('P','C')
    left join crsp.dsenames as s
      on l.lpermno=s.permno
     and (s.namedt<=a.date_t or missing(s.namedt))
     and (s.nameendt>=a.date_t or missing(s.nameendt));

    create table work.sic_agg as
    select gvkey,year,
           count(distinct case when linkprim='P' then siccd else . end) as n_sic_p,
           min(case when linkprim='P' then siccd else . end) as min_sic_p,
           max(case when linkprim='P' then siccd else . end) as max_sic_p,
           count(distinct case when linkprim='C' then siccd else . end) as n_sic_c,
           min(case when linkprim='C' then siccd else . end) as min_sic_c,
           max(case when linkprim='C' then siccd else . end) as max_sic_c
    from work.sic_candidate
    group by gvkey,year;
quit;

proc sort data=work.anchors; by gvkey year; run;
proc sort data=work.sic_agg; by gvkey year; run;
data work.anchors_sic;
    length sic_source $12;
    merge work.anchors(in=a) work.sic_agg;
    by gvkey year;
    if not a then delete;

    crsp_sic=.;
    if n_sic_p=1 then crsp_sic=min_sic_p;
    else if n_sic_p=0 and n_sic_c=1 then crsp_sic=min_sic_c;

    sic_disagree=0;
    if sich_t>=100 and sich_t<=9999 then do;
        siccode=sich_t;
        sic_source='FUNDA';
        if crsp_sic>=100 and crsp_sic<=9999 and crsp_sic ne sich_t then sic_disagree=1;
    end;
    else if crsp_sic>=100 and crsp_sic<=9999 then do;
        siccode=crsp_sic;
        sic_source='CRSP_DATED';
    end;
    else do;
        siccode=.;
        sic_source='MISSING';
    end;

    sic_valid=(siccode>=100 and siccode<=9999);
    nonfinancial=(sic_valid and (siccode<6000 or siccode>6999));
    footnote_ok=(nmiss(che_p,che_t,act_p,act_t,lct_p,lct_t,
                       at_p,at_t,lt_p,lt_t,sale_p,sale_t,oiadp_t)=0);
    date_order=(not missing(date_p) and not missing(date_t) and not missing(date_n)
                and date_p<date_t and date_t<date_n);
    currency_ok=(not missing(curcd_p) and not missing(curcd_t) and not missing(curcd_n)
                 and strip(curcd_p)=strip(curcd_t) and strip(curcd_t)=strip(curcd_n));

    avg_at_t=(at_p+at_t)/2;
    avg_at_n=(at_t+at_n)/2;
    denom_ok=(not missing(avg_at_t) and not missing(avg_at_n)
              and avg_at_t ne 0 and avg_at_n ne 0);
    model_inputs_ok=(footnote_ok and date_order and currency_ok and sic_valid and nonfinancial
                     and denom_ok and not missing(oiadp_n));

    if denom_ok and footnote_ok and currency_ok and not missing(oiadp_n) then do;
        coa_p=act_p-che_p; coa_t=act_t-che_t;
        col_p=lct_p-dlc_p; col_t=lct_t-dlc_t;
        ncoa_p=at_p-act_p-ivao_p; ncoa_t=at_t-act_t-ivao_t;
        ncol_p=lt_p-lct_p-dltt_p; ncol_t=lt_t-lct_t-dltt_t;
        finl_p=dltt_p+dlc_p+pstk_p; finl_t=dltt_t+dlc_t+pstk_t;

        roa_t_raw=oiadp_t/avg_at_t;
        roa_tp1_raw=oiadp_n/avg_at_n;
        dcoa_raw=(coa_t-coa_p)/avg_at_t;
        ndcol_raw=-(col_t-col_p)/avg_at_t;
        dncoa_raw=(ncoa_t-ncoa_p)/avg_at_t;
        ndncol_raw=-(ncol_t-ncol_p)/avg_at_t;
        dsti_raw=(ivst_t-ivst_p)/avg_at_t;
        dlti_raw=(ivao_t-ivao_p)/avg_at_t;
        ndfinl_raw=-(finl_t-finl_p)/avg_at_t;
    end;

    start_dt=intnx('month',date_t,4,'same');
    end_dt=intnx('month',start_dt,12,'same');
    format start_dt end_dt yymmdd10.;
    label siccode='Historical SIC used for sample exclusion'
          sic_source='Historical SIC source'
          sic_disagree='FUNDA and dated CRSP SIC disagree'
          footnote_ok='Paper footnote financial item screen'
          date_order='Prior/current/next DATADATE order valid'
          currency_ok='Currency stable across t-1, t and t+1'
          model_inputs_ok='Financial, SIC, currency and denominator screen';
run;

/* Verify the local CCM link-code and open-boundary values used by date-valid joins. */
proc sql;
    create table work.ccm_audit as
    select linktype,linkprim,usedflag,
           count(*) as links,
           sum(case when linkdt=.B then 1 else 0 end) as open_start_b,
           sum(case when linkenddt=.E then 1 else 0 end) as open_end_e
    from ccm.ccmxpf_linktable
    group by linktype,linkprim,usedflag;
quit;
proc print data=work.ccm_audit noobs;
    title 'CCM link types, primary markers and open date boundaries';
run;
title;

/* Retain one or more valid security candidates; a company-year passes if any is complete. */
proc sql;
    create table work.delist_dups as
    select permno,dlstdt,count(*) as n_records
    from crsp.dsedelist
    group by permno,dlstdt
    having count(*)>1;
    select count(*) as duplicate_delisting_keys from work.delist_dups;

    create table work.delist as
    select permno,dlstdt,dlret,dlstcd
    from crsp.dsedelist;
quit;
data _null_;
    if 0 then set work.delist_dups nobs=n_dup;
    if n_dup>0 then do;
        put 'ERROR: CRSP DSEDELIST has duplicate PERMNO/delisting-date keys requiring review.';
        abort cancel;
    end;
    stop;
run;

proc sql;
    create table work.retlink as
    select distinct a.gvkey,a.year,a.start_dt,a.end_dt,l.lpermno as permno
    from work.anchors_sic as a
    inner join ccm.ccmxpf_linktable as l
      on a.gvkey=l.gvkey
     and (l.linkdt<=a.start_dt or l.linkdt=.B)
     and (l.linkenddt>=a.start_dt or l.linkenddt=.E)
    where a.model_inputs_ok=1
      and l.linktype in ('LC','LU')
      and l.linkprim in ('P','C')
      and not missing(l.lpermno);

    create table work.retterm as
    select r.gvkey,r.year,r.start_dt,r.end_dt,r.permno,
           min(d.dlstdt) as dlstdt format=yymmdd10.
    from work.retlink as r
    left join work.delist as d
      on r.permno=d.permno and d.dlstdt>=r.start_dt and d.dlstdt<r.end_dt
    group by r.gvkey,r.year,r.start_dt,r.end_dt,r.permno;

    create table work.retterm2 as
    select r.*,
           d.dlret,d.dlstcd,
           case when missing(r.dlstdt) then 1
                when not missing(d.dlret) then 1
                when missing(d.dlret) and (d.dlstcd=500 or (d.dlstcd>=520 and d.dlstcd<=584)) then 1
                else 0 end as delist_ok
    from work.retterm as r
    left join work.delist as d
      on r.permno=d.permno and r.dlstdt=d.dlstdt and not missing(r.dlstdt);
quit;

proc sql;
    select min(start_dt) format=best32.,max(end_dt) format=best32.
      into :min_ret trimmed,:max_ret trimmed
    from work.retlink;

    create table work.expected as
    select r.gvkey,r.year,r.start_dt,r.end_dt,r.permno,r.dlstdt,r.dlret,r.dlstcd,r.delist_ok,
           d.date as daydt format=yymmdd10.,d.vwretd
    from work.retterm2 as r
    inner join crsp.dsi as d
      on d.date>=r.start_dt and d.date<r.end_dt;

    create table work.ret_perm as
    select distinct permno from work.retlink;
quit;

/* Read the bounded CRSP daily period once, keeping only PERMNOs with a valid CCM candidate. */
data work.dsf_subset;
    length permno 8 date 8 ret 8;
    if _n_=1 then do;
        declare hash hperm(dataset:'work.ret_perm');
        hperm.defineKey('permno');
        hperm.defineDone();
    end;
    set crsp.dsf(keep=permno date ret where=(date>=&min_ret and date<&max_ret));
    if hperm.find()=0;
run;
proc sort data=work.dsf_subset out=work.dsf_sorted;
    by permno date;
run;
data work.expected_wide;
    length daydt 8;
    set work.expected;
run;
proc sort data=work.expected_wide out=work.expected_sorted;
    by permno daydt;
run;

/* Match expected market days to daily RET; keep duplicate windows correctly within each key group. */
data work.retday;
    merge work.expected_sorted(in=exp)
          work.dsf_sorted(in=hasret rename=(date=daydt ret=dsfret));
    by permno daydt;
    retain group_hasret group_ret;
    if first.daydt then do;
        group_hasret=0;
        group_ret=.;
    end;
    if hasret then do;
        group_hasret=1;
        group_ret=dsfret;
    end;
    if exp then do;
        if group_hasret then dsfret=group_ret;
        else dsfret=.;
        output;
    end;
    drop group_hasret group_ret;
run;

proc sql;
    create table work.retcheck as
    select gvkey,year,permno,
           count(*) as n_market_days,
           sum(case when (missing(dlstdt) or daydt<dlstdt) and missing(dsfret) then 1 else 0 end) as miss_stock_days,
           sum(case when not missing(dlstdt) and daydt>dlstdt and missing(vwretd) then 1 else 0 end) as miss_index_days,
           max(delist_ok) as delist_ok,
           case when count(*)>0
                     and calculated miss_stock_days=0
                     and calculated miss_index_days=0
                     and calculated delist_ok=1
                then 1 else 0 end as ret_complete
    from work.retday
    group by gvkey,year,permno;

    create table work.ret_by_fy as
    select gvkey,year,
           max(ret_complete) as crsp_ok,
           count(*) as linked_permnos,
           max(n_market_days) as market_days
    from work.retcheck
    group by gvkey,year;
quit;

proc sort data=work.anchors_sic; by gvkey year; run;
proc sort data=work.ret_by_fy; by gvkey year; run;
data work.analysis;
    merge work.anchors_sic(in=a) work.ret_by_fy(in=r);
    by gvkey year;
    if not a then delete;
    if missing(crsp_ok) then crsp_ok=0;
    if missing(linked_permnos) then linked_permnos=0;
    final_ok=(model_inputs_ok and crsp_ok=1);
run;

/* Summarize source filters, return availability and final sample sizes by regression year. */
proc sql;
    create table work.attrition as
    select year,
           count(*) as funda_anchors,
           sum(not missing(date_p)) as prior_fyear_found,
           sum(not missing(date_n)) as next_fyear_found,
           sum(footnote_ok) as item_screen_pass,
           sum(date_order) as date_order_pass,
           sum(currency_ok) as currency_pass,
           sum(sic_valid) as valid_sic,
           sum(nonfinancial) as nonfinancial,
           sum(model_inputs_ok) as financial_model_inputs,
           sum(crsp_ok=1) as complete_crsp_return,
           sum(final_ok) as final_n,
           sum(sic_disagree) as sic_source_disagreements
    from work.analysis
    group by year;
quit;
proc print data=work.attrition noobs;
    title 'Annual sample construction and CRSP return availability';
run;
title;

proc sql;
    select count(*) as final_firm_years,
           count(distinct gvkey) as firms,
           min(year) as first_year,
           max(year) as last_year,
           min(date_t) as first_fye format=yymmdd10.,
           max(date_t) as last_fye format=yymmdd10.,
           min(date_n) as first_lead_fye format=yymmdd10.,
           max(date_n) as last_lead_fye format=yymmdd10.
    from work.analysis
    where final_ok=1;

    create table work.dup_final as
    select gvkey,year,count(*) as n
    from work.analysis
    where final_ok=1
    group by gvkey,year
    having count(*)>1;
    select count(*) as duplicate_final_keys from work.dup_final;
quit;

data _null_;
    if 0 then set work.dup_final nobs=n_dup;
    if n_dup>0 then do;
        put 'ERROR: final GVKEY/year handoff is not unique.';
        abort cancel;
    end;
    stop;
run;

/* Final fixed-bound winsorization, model input diagnostics and native handoff. */
data out.reg;
    set work.analysis;
    where final_ok=1;
    array rawv[9] roa_tp1_raw roa_t_raw dcoa_raw ndcol_raw dncoa_raw ndncol_raw dsti_raw dlti_raw ndfinl_raw;
    array winv[9] roa_tp1 roa_t dcoa ndcol dncoa ndncol dsti dlti ndfinl;
    do i=1 to 9;
        if not missing(rawv[i]) then winv[i]=max(-1,min(1,rawv[i]));
    end;
    drop i;
    label gvkey='Compustat Global Company Key'
          year='Fiscal year t'
          date_t='Current fiscal year end'
          roa_tp1='ROA t+1'
          roa_t='ROA t'
          dcoa='Change in current operating assets'
          ndcol='Negative change in current operating liabilities'
          dncoa='Change in noncurrent operating assets'
          ndncol='Negative change in noncurrent operating liabilities'
          dsti='Change in short-term investments'
          dlti='Change in long-term investments'
          ndfinl='Negative change in financial liabilities'
          siccode='Historical SIC used for sample exclusion'
          sic_source='Historical SIC source'
          curcd_t='Compustat currency code at t';
    keep gvkey year date_t date_p date_n curcd_t siccode sic_source sic_disagree
         roa_tp1 roa_t dcoa ndcol dncoa ndncol dsti dlti ndfinl;
run;

proc means data=out.reg n mean std min p1 p50 p99 max maxdec=6;
    var roa_tp1 roa_t dcoa ndcol dncoa ndncol dsti dlti ndfinl;
    title 'Final regression-input distributions';
run;
title;
proc means data=out.reg n mean min max maxdec=6;
    class year;
    var roa_tp1 roa_t dcoa ndcol dncoa ndncol dsti dlti ndfinl;
    title 'Final regression-input distributions by year';
run;
title;

proc contents data=out.reg;
    title 'Final native Stata handoff';
run;
title;
