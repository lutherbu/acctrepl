options errorabend msglevel=i pagesize=200 linesize=120 nodate nonumber;

libname comp '/storage/sas/base/comp/d_na' access=readonly;
libname ccm '/storage/sas/base/crsp/a_ccm' access=readonly;
libname crsp '/storage/sas/base/crsp/a_stock' access=readonly;
libname out 'data/compustat_108617' access=readonly;

/* Reconstruct audit inputs only for the inherited final sample keys. */
data work.sample;
    set out.reg(keep=gvkey year date_p date_t date_n curcd_t siccode sic_source
                     sic_disagree roa_tp1 roa_t dcoa ndcol dncoa ndncol dsti dlti ndfinl);
run;

data work.funda_raw;
    set comp.funda(keep=gvkey datadate fyear indfmt consol popsrc datafmt curcd sich
                        che act lct at lt oiadp sale dltt ivao dlc pstk ivst
                   where=(fyear>=1961 and fyear<=2002 and indfmt='INDL'
                          and consol='C' and popsrc='D' and datafmt='STD'));
    if missing(gvkey) or missing(datadate) or missing(fyear) then delete;
run;

proc sort data=work.funda_raw out=work.funda_sort;
    by gvkey fyear datadate;
run;
data work.annual;
    set work.funda_sort;
    by gvkey fyear;
    if last.fyear;
run;

proc sql;
    create table work.inputs as
    select s.gvkey,s.year,s.date_p,s.date_t,s.date_n,s.curcd_t as hand_curcd,
           s.siccode,s.sic_source,s.sic_disagree,
           s.roa_tp1 as hand_roa_tp1,s.roa_t as hand_roa_t,
           s.dcoa as hand_dcoa,s.ndcol as hand_ndcol,s.dncoa as hand_dncoa,
           s.ndncol as hand_ndncol,s.dsti as hand_dsti,s.dlti as hand_dlti,
           s.ndfinl as hand_ndfinl,
           p.curcd as curcd_p,t.curcd as curcd_t,n.curcd as curcd_n,
           p.che as che_p,t.che as che_t,p.act as act_p,t.act as act_t,
           p.lct as lct_p,t.lct as lct_t,p.at as at_p,t.at as at_t,n.at as at_n,
           p.lt as lt_p,t.lt as lt_t,p.sale as sale_p,t.sale as sale_t,
           t.oiadp as oiadp_t,n.oiadp as oiadp_n,
           p.dltt as dltt_p,t.dltt as dltt_t,
           p.ivao as ivao_p,t.ivao as ivao_t,
           p.dlc as dlc_p,t.dlc as dlc_t,
           p.pstk as pstk_p,t.pstk as pstk_t,
           p.ivst as ivst_p,t.ivst as ivst_t
    from work.sample as s
    left join work.annual as p
      on s.gvkey=p.gvkey and p.fyear=s.year-1 and p.datadate=s.date_p
    left join work.annual as t
      on s.gvkey=t.gvkey and t.fyear=s.year and t.datadate=s.date_t
    left join work.annual as n
      on s.gvkey=n.gvkey and n.fyear=s.year+1 and n.datadate=s.date_n;
quit;

data work.check;
    set work.inputs;
    miss9_p=missing(dltt_p); miss9_t=missing(dltt_t);
    miss32_p=missing(ivao_p); miss32_t=missing(ivao_t);
    miss34_p=missing(dlc_p); miss34_t=missing(dlc_t);
    miss130_p=missing(pstk_p); miss130_t=missing(pstk_t);
    miss193_p=missing(ivst_p); miss193_t=missing(ivst_t);
    dltt_p0=coalesce(dltt_p,0); dltt_t0=coalesce(dltt_t,0);
    ivao_p0=coalesce(ivao_p,0); ivao_t0=coalesce(ivao_t,0);
    dlc_p0=coalesce(dlc_p,0); dlc_t0=coalesce(dlc_t,0);
    pstk_p0=coalesce(pstk_p,0); pstk_t0=coalesce(pstk_t,0);
    ivst_p0=coalesce(ivst_p,0); ivst_t0=coalesce(ivst_t,0);

    required_missing=(nmiss(che_p,che_t,act_p,act_t,lct_p,lct_t,
                            at_p,at_t,lt_p,lt_t,sale_p,sale_t,oiadp_t,oiadp_n)>0);
    date_order=(not missing(date_p) and not missing(date_t) and not missing(date_n)
                and date_p<date_t and date_t<date_n);
    currency_ok=(not missing(curcd_p) and not missing(curcd_t) and not missing(curcd_n)
                 and strip(curcd_p)=strip(curcd_t) and strip(curcd_t)=strip(curcd_n)
                 and strip(curcd_t)=strip(hand_curcd));
    avg_at_t=(at_p+at_t)/2;
    avg_at_n=(at_t+at_n)/2;
    denom_t_zero=(avg_at_t=0);
    denom_n_zero=(avg_at_n=0);
    denom_t_nonpositive=(avg_at_t<=0);
    denom_n_nonpositive=(avg_at_n<=0);
    if not missing(avg_at_t) and not missing(avg_at_n)
       and avg_at_t ne 0 and avg_at_n ne 0 then do;
        coa_p=act_p-che_p; coa_t=act_t-che_t;
        col_p=lct_p-dlc_p0; col_t=lct_t-dlc_t0;
        ncoa_p=at_p-act_p-ivao_p0; ncoa_t=at_t-act_t-ivao_t0;
        ncol_p=lt_p-lct_p-dltt_p0; ncol_t=lt_t-lct_t-dltt_t0;
        finl_p=dltt_p0+dlc_p0+pstk_p0; finl_t=dltt_t0+dlc_t0+pstk_t0;
        roa_t_raw=oiadp_t/avg_at_t;
        roa_tp1_raw=oiadp_n/avg_at_n;
        dcoa_raw=(coa_t-coa_p)/avg_at_t;
        ndcol_raw=-(col_t-col_p)/avg_at_t;
        dncoa_raw=(ncoa_t-ncoa_p)/avg_at_t;
        ndncol_raw=-(ncol_t-ncol_p)/avg_at_t;
        dsti_raw=(ivst_t0-ivst_p0)/avg_at_t;
        dlti_raw=(ivao_t0-ivao_p0)/avg_at_t;
        ndfinl_raw=-(finl_t-finl_p)/avg_at_t;
    end;

    mismatch_roa_tp1=(not missing(roa_tp1_raw) and
                      abs(hand_roa_tp1-max(-1,min(1,roa_tp1_raw)))>1e-12);
    mismatch_roa_t=(not missing(roa_t_raw) and
                    abs(hand_roa_t-max(-1,min(1,roa_t_raw)))>1e-12);
    mismatch_dcoa=(not missing(dcoa_raw) and abs(hand_dcoa-max(-1,min(1,dcoa_raw)))>1e-12);
    mismatch_ndcol=(not missing(ndcol_raw) and abs(hand_ndcol-max(-1,min(1,ndcol_raw)))>1e-12);
    mismatch_dncoa=(not missing(dncoa_raw) and abs(hand_dncoa-max(-1,min(1,dncoa_raw)))>1e-12);
    mismatch_ndncol=(not missing(ndncol_raw) and abs(hand_ndncol-max(-1,min(1,ndncol_raw)))>1e-12);
    mismatch_dsti=(not missing(dsti_raw) and abs(hand_dsti-max(-1,min(1,dsti_raw)))>1e-12);
    mismatch_dlti=(not missing(dlti_raw) and abs(hand_dlti-max(-1,min(1,dlti_raw)))>1e-12);
    mismatch_ndfinl=(not missing(ndfinl_raw) and abs(hand_ndfinl-max(-1,min(1,ndfinl_raw)))>1e-12);
run;

proc sql;
    select count(*) as final_rows,
           count(distinct gvkey) as distinct_firms,
           count(*)-count(distinct catx('|',gvkey,put(year,4.))) as duplicate_keys,
           sum(required_missing) as rows_missing_required_input,
           sum(not date_order) as rows_with_bad_date_order,
           sum(not currency_ok) as currency_change_n,
           sum(denom_t_zero) as zero_current_average_assets,
           sum(denom_n_zero) as zero_lead_average_assets,
           sum(denom_t_nonpositive) as at_t_nonpos,
           sum(denom_n_nonpositive) as at_n_nonpos,
           min(avg_at_t) as min_at_t,
           min(avg_at_n) as min_at_n
    from work.check;

    select sum(miss9_p) as item9_missing_tminus1,
           sum(miss9_t) as item9_missing_t,
           sum(miss32_p) as item32_missing_tminus1,
           sum(miss32_t) as item32_missing_t,
           sum(miss34_p) as item34_missing_tminus1,
           sum(miss34_t) as item34_missing_t,
           sum(miss130_p) as item130_missing_tminus1,
           sum(miss130_t) as item130_missing_t,
           sum(miss193_p) as item193_missing_tminus1,
           sum(miss193_t) as item193_missing_t,
           sum(miss9_p or miss9_t or miss32_p or miss32_t or miss34_p or miss34_t or
               miss130_p or miss130_t or miss193_p or miss193_t) as rows_using_zero_imputation
    from work.check;

    select sum(mismatch_roa_tp1) as mismatch_roa_tp1,
           sum(mismatch_roa_t) as mismatch_roa_t,
           sum(mismatch_dcoa) as mismatch_dcoa,
           sum(mismatch_ndcol) as mismatch_ndcol,
           sum(mismatch_dncoa) as mismatch_dncoa,
           sum(mismatch_ndncol) as mismatch_ndncol,
           sum(mismatch_dsti) as mismatch_dsti,
           sum(mismatch_dlti) as mismatch_dlti,
           sum(mismatch_ndfinl) as mismatch_ndfinl
    from work.check;

    select curcd_t as currency, count(*) as sample_rows,
           sum(not currency_ok) as three_year_currency_mismatches
    from work.check
    group by curcd_t;
quit;

proc means data=work.check n mean std p25 median p75 min max maxdec=6;
    var roa_tp1_raw roa_t_raw dcoa_raw ndcol_raw dncoa_raw ndncol_raw
        dsti_raw dlti_raw ndfinl_raw;
    title 'Pre-winsorized regression variables in inherited final sample';
run;
title;

proc sort data=work.check out=work.currency_sorted;
    by year curcd_t gvkey;
run;
data work.currency_examples;
    set work.currency_sorted;
    by year curcd_t;
    if first.curcd_t and ((year=1962 and curcd_t='USD') or
                          (year=1987 and curcd_t='CAD') or
                          (year=2001 and curcd_t='USD'));
    length example $20;
    if year=1962 then example='early USD';
    else if year=1987 then example='CAD';
    else if year=2001 then example='late USD';
    keep example year date_p date_t date_n curcd_p curcd_t curcd_n avg_at_t avg_at_n;
run;
proc print data=work.currency_examples noobs;
    title 'Three anonymous source-currency checks';
run;
title;

/* Reapply the dated CCM and DSENAMES SIC join on all selected annual anchors. */
proc sql;
    create table work.anchors_full as
    select t.gvkey,t.fyear as year,t.datadate as date_t,t.sich as funda_sic,
           case when not missing(s.year) then 1 else 0 end as final_sample,
           s.siccode,s.sic_source,s.sic_disagree
    from work.annual as t
    left join work.sample as s
      on t.gvkey=s.gvkey and t.fyear=s.year and t.datadate=s.date_t
    where t.fyear>=1962 and t.fyear<=2001;

    create table work.sic_candidate as
    select distinct a.gvkey,a.year,l.linkprim,l.lpermno as permno,
           case when n.siccd>=100 and n.siccd<=9999 then n.siccd else . end as siccd
    from work.anchors_full as a
    left join ccm.ccmxpf_linktable as l
      on a.gvkey=l.gvkey
     and (l.linkdt<=a.date_t or l.linkdt=.B)
     and (l.linkenddt>=a.date_t or l.linkenddt=.E)
     and l.linktype in ('LC','LU')
     and l.linkprim in ('P','C')
    left join crsp.dsenames as n
      on l.lpermno=n.permno
     and (n.namedt<=a.date_t or missing(n.namedt))
     and (n.nameendt>=a.date_t or missing(n.nameendt));

    create table work.sic_agg as
    select gvkey,year,
           count(distinct case when linkprim='P' then permno else . end) as n_perm_p,
           count(distinct case when linkprim='C' then permno else . end) as n_perm_c,
           count(distinct case when linkprim='P' then siccd else . end) as n_sic_p,
           min(case when linkprim='P' then siccd else . end) as min_sic_p,
           max(case when linkprim='P' then siccd else . end) as max_sic_p,
           count(distinct case when linkprim='C' then siccd else . end) as n_sic_c,
           min(case when linkprim='C' then siccd else . end) as min_sic_c,
           max(case when linkprim='C' then siccd else . end) as max_sic_c
    from work.sic_candidate
    group by gvkey,year;

    create table work.sic_join as
    select a.*,g.n_perm_p,g.n_perm_c,
           g.n_sic_p,g.min_sic_p,g.max_sic_p,g.n_sic_c,g.min_sic_c,g.max_sic_c
    from work.anchors_full as a
    left join work.sic_agg as g
      on a.gvkey=g.gvkey and a.year=g.year;
quit;

data work.sic_check;
    set work.sic_join;
    crsp_sic=.;
    if n_sic_p=1 then crsp_sic=min_sic_p;
    else if n_sic_p=0 and n_sic_c=1 then crsp_sic=min_sic_c;
    funda_valid=(funda_sic>=100 and funda_sic<=9999);
    crsp_valid=(crsp_sic>=100 and crsp_sic<=9999);
    both_valid=(funda_valid and crsp_valid);
    exact_disagree=(both_valid and funda_sic ne crsp_sic);
    same_2digit=(both_valid and floor(funda_sic/100)=floor(crsp_sic/100));
    diff_4_same_2=(exact_disagree and same_2digit);
    diff_2=(exact_disagree and not same_2digit);
    funda_fin=(funda_valid and funda_sic>=6000 and funda_sic<=6999);
    crsp_fin=(crsp_valid and crsp_sic>=6000 and crsp_sic<=6999);
    financial_disagree=(both_valid and funda_fin ne crsp_fin);
    if final_sample then
        source_match=((sic_source='FUNDA' and funda_valid and siccode=funda_sic) or
                      (sic_source='CRSP_DATED' and crsp_valid and siccode=crsp_sic));
    else source_match=.;
    funda_fin_crsp_nonfin=(both_valid and funda_fin and not crsp_fin);
    funda_nonfin_crsp_fin=(both_valid and not funda_fin and crsp_fin);
run;

proc sql;
    select final_sample,
           count(*) as anchor_rows,
           sum(funda_valid) as funda_valid_sic,
           sum(crsp_valid) as dated_crsp_valid_sic,
           sum(both_valid) as both_valid_sic,
           sum(exact_disagree) as exact_sic_disagreement,
           sum(diff_4_same_2) as four_digit_only_disagreement,
           sum(diff_2) as two_digit_disagreement,
           sum(funda_fin) as funda_financial,
           sum(crsp_fin) as crsp_financial,
           sum(funda_fin_crsp_nonfin) as funda_fin_crsp_nonfin,
           sum(funda_nonfin_crsp_fin) as funda_nonfin_crsp_fin,
           sum(financial_disagree) as fin_class_disagree,
           sum(final_sample and not source_match) as output_source_code_mismatches,
           sum(sic_disagree) as stored_disagreement_flag
    from work.sic_check
    group by final_sample;

    select final_sample,
           sum(n_perm_p>1) as multi_primary_permno,
           sum(n_perm_c>1) as multi_secondary_permno,
           sum(n_sic_p>1) as multi_primary_sic,
           sum(n_sic_c>1) as multi_secondary_sic,
           sum(n_sic_p=0 and n_sic_c=1) as secondary_sic_fallbacks,
           sum(n_sic_p=1) as unique_primary_sic_rows
    from work.sic_check
    group by final_sample;
quit;

data work.window_example;
    fye='31DEC1962'd;
    start_dt=intnx('month',fye,4,'same');
    end_dt=intnx('month',start_dt,12,'same');
    last_included=end_dt-1;
    format fye start_dt end_dt last_included yymmdd10.;
run;
proc print data=work.window_example noobs;
    var fye start_dt last_included end_dt;
    title 'SAS [start,end) boundary interpretation';
run;
title;
