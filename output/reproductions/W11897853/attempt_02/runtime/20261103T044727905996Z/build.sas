options errorabend;
options validvarname=any;

libname comp ("/storage/sas/base/comp/d_na"
              "/storage/sas/base/comp/d_na/security"
              "/storage/sas/base/comp/d_global/currency") access=readonly;
libname out "data";

%let first_fy=1968;
%let last_fy=1997;

data work.core_all;
    set comp.funda(where=(fyear >= &first_fy and fyear <= &last_fy and
                         indfmt='INDL' and datafmt='STD' and
                         consol='C' and popsrc='D'));
    keep gvkey datadate fyear fyr pddur indfmt datafmt consol popsrc
         conm tic fic
         curcd curncd iid hiid ajex cshpri csho prcc_f
         act lct at re ebit sale lt pstk
         capx xrd xad dp seq ppent dltt dlc epspx;
run;

proc sql;
    create table work.dup_funda as
    select gvkey, fyear, count(*) as n_rows
    from work.core_all
    group by gvkey, fyear
    having count(*) > 1;
    select count(*) into :n_dup_funda trimmed from work.dup_funda;
quit;

%put NOTE: FUNDA duplicate GVKEY/FYEAR keys under source filters = &n_dup_funda.;
proc sql;
    create table work.duplicate_funda_rows as
    select a.gvkey, a.fyear, a.datadate, a.fyr, a.pddur, a.conm, a.tic,
           a.fic, a.iid, a.hiid, a.curcd, a.curncd, a.ajex, a.cshpri, a.csho,
           a.prcc_f, a.at, a.seq, a.ppent, a.dltt, a.dlc, a.capx, a.xrd, a.xad
    from work.core_all as a inner join work.dup_funda as b
      on a.gvkey=b.gvkey and a.fyear=b.fyear
    order by a.gvkey, a.fyear, a.datadate;
quit;
proc print data=work.duplicate_funda_rows noobs;
    format datadate yymmdd10.;
run;

data work.core_rank;
    set work.core_all;
    core_quality=n(of act lct at re ebit sale lt capx xrd xad dp seq ppent
                     dltt dlc epspx cshpri csho);
run;

proc sql;
    create table work.duplicate_best as
    select a.gvkey, a.fyear, a.core_quality
    from work.core_rank as a
    inner join
        (select gvkey, fyear, max(core_quality) as max_quality
         from work.core_rank group by gvkey, fyear) as b
      on a.gvkey=b.gvkey and a.fyear=b.fyear and a.core_quality=b.max_quality
    inner join work.dup_funda as d
      on a.gvkey=d.gvkey and a.fyear=d.fyear;
    create table work.duplicate_quality_ties as
    select gvkey, fyear, count(*) as n_best
    from work.duplicate_best
    group by gvkey, fyear
    having count(*) > 1;
    select count(*) into :n_duplicate_quality_ties trimmed
    from work.duplicate_quality_ties;
quit;

%put NOTE: Duplicate keys with tied maximum financial completeness = &n_duplicate_quality_ties.;
%macro stop_quality_ties;
    %if %sysevalf(&n_duplicate_quality_ties > 0) %then %do;
        %put ERROR: Duplicate Compustat keys have tied financial-record completeness.;
        %abort cancel;
    %end;
%mend;
%stop_quality_ties;

proc sort data=work.core_rank out=work.core_rank_sort;
    by gvkey fyear descending core_quality descending datadate;
run;
data work.core_unique;
    set work.core_rank_sort;
    by gvkey fyear;
    if first.fyear;
run;
proc sql;
    select count(*) as selected_annual_rows,
           count(distinct gvkey) as selected_firms,
           count(*)-count(distinct cats(gvkey,'|',put(fyear,4.))) as duplicate_selected_keys
    from work.core_unique;
quit;

proc sql;
    select count(*) as core_rows,
           count(distinct gvkey) as core_firms,
           min(fyear) as first_fyear,
           max(fyear) as last_fyear,
           min(datadate) format=yymmdd10. as first_datadate,
           max(datadate) format=yymmdd10. as last_datadate
    from work.core_unique;
quit;

proc freq data=work.core_unique;
    tables curcd*curncd / missing;
run;

data work.fx_dly_sum;
    set comp.g_exrt_dly(where=(datadate >= '01JAN1968'd and
                                datadate <= '31MAY1998'd));
    keep fromcurd tocurd datadate exratd exrattpd;
run;

proc sql;
    create table work.fx_dly_a as
    select fromcurd, tocurd, datadate,
           count(*) as n_rows,
           count(exratd) as n_rate,
           min(exratd) as rate_min,
           max(exratd) as rate_max,
           min(exrattpd) as type_min length=3,
           max(exrattpd) as type_max length=3
    from work.fx_dly_sum
    group by fromcurd, tocurd, datadate;
quit;

data work.fx_dly;
    set work.fx_dly_a;
    length rate_type $3;
    fx_rate=.;
    if n_rate > 0 and rate_min > 0 and rate_min=rate_max then fx_rate=rate_min;
    if type_min=type_max then rate_type=type_min;
    else rate_type='MX';
    keep fromcurd tocurd datadate fx_rate rate_type n_rows n_rate;
run;

data work.fx_mth_raw;
    set comp.g_exrt_mth(where=(datadate >= '01JAN1968'd and
                                datadate <= '31MAY1998'd));
    keep fromcurm tocurm datadate exrat12m;
run;

proc sql;
    create table work.fx_mth_a as
    select fromcurm, tocurm, datadate,
           count(*) as n_rows,
           count(exrat12m) as n_rate,
           min(exrat12m) as rate_min,
           max(exrat12m) as rate_max
    from work.fx_mth_raw
    group by fromcurm, tocurm, datadate;
quit;

data work.fx_mth;
    set work.fx_mth_a;
    fx_rate=.;
    if n_rate > 0 and rate_min > 0 and rate_min=rate_max then fx_rate=rate_min;
    keep fromcurm tocurm datadate fx_rate n_rows n_rate;
run;

data work.sec_desc_raw;
    set comp.sec_mth(where=(datadate >= '01JAN1968'd and
                            datadate <= '31MAY1998'd));
    keep gvkey iid datadate primiss;
run;

data work.sec_px_raw;
    set comp.sec_mthprc(where=(datadate >= '01JAN1968'd and
                               datadate <= '31MAY1998'd));
    keep gvkey iid datadate curcdm prccm;
run;

proc sql noprint;
    select count(*) into :n_sec_desc_dups trimmed
    from (select gvkey,iid,datadate,count(*) as n
          from work.sec_desc_raw group by gvkey,iid,datadate
          having calculated n > 1);
    select count(*) into :n_sec_px_dups trimmed
    from (select gvkey,iid,datadate,count(*) as n
          from work.sec_px_raw group by gvkey,iid,datadate
          having calculated n > 1);
quit;
%put NOTE: Duplicate COMP.SEC_MTH issue-date keys = &n_sec_desc_dups.;
%put NOTE: Duplicate COMP.SEC_MTHPRC issue-date keys = &n_sec_px_dups.;
%macro stop_sec_dups;
    %if %sysevalf((&n_sec_desc_dups > 0) or (&n_sec_px_dups > 0)) %then %do;
        %put ERROR: Duplicate Compustat security issue-date keys require review.;
        %abort cancel;
    %end;
%mend;
%stop_sec_dups;

proc sql;
    create table work.sec_issue_price as
    select p.gvkey, p.iid, p.datadate, d.primiss, p.curcdm, p.prccm
    from work.sec_px_raw as p
    left join work.sec_desc_raw as d
      on p.gvkey=d.gvkey and p.iid=d.iid and p.datadate=d.datadate;

    create table work.sec_primary_count as
    select gvkey, datadate, count(*) as p_count, min(iid) as p_iid length=4
    from work.sec_desc_raw
    where strip(upcase(primiss))='P'
    group by gvkey, datadate;
quit;

/* Match each annual price to its full historic issue at the exact fiscal
   date. A unique dated primary issue is a fallback only when HIID is absent. */
proc sql;
    create table work.price_evidence as
    select a.gvkey, a.fyear, a.datadate, a.iid as header_iid,
           a.hiid, a.prcc_f,
           h.primiss as hiid_primiss,
           h.curcdm as hiid_quote_cur,
           h.prccm as hiid_quote_px,
           c.p_count, c.p_iid,
           p.primiss as p_primiss,
           p.curcdm as p_quote_cur,
           p.prccm as p_quote_px
    from work.core_unique as a
    left join work.sec_issue_price as h
      on not missing(a.hiid) and a.gvkey=h.gvkey and a.datadate=h.datadate and
         strip(a.hiid)=strip(h.iid)
    left join work.sec_primary_count as c
      on a.gvkey=c.gvkey and a.datadate=c.datadate
    left join work.sec_issue_price as p
      on c.p_count=1 and a.gvkey=p.gvkey and a.datadate=p.datadate and
         c.p_iid=p.iid
    where a.fyear between &first_fy and &last_fy;
quit;

data work.price_routes;
    set work.price_evidence;
    length quote_cur $4 price_route $32 price_issue $21
           hiid_marker $2;
    quote_cur=''; price_route='NO_SUPPORTED_ROUTE'; price_issue='';
    quote_px=.; price_abs_diff=.; hiid_marker=strip(upcase(hiid_primiss));
    annual_price_ok=0; hiid_p_count=.;
    if not missing(p_count) then hiid_p_count=p_count;

    /* SEC_MTHPRC stores four decimals. Do not test both AJEX directions. */
    if not missing(hiid) then do;
        if hiid_marker='J' or (hiid_marker ne '' and hiid_marker ne 'P') then
            price_route='HIID_EXPLICIT_NONP';
        else if not missing(hiid_quote_px) and hiid_quote_px>0 and
                hiid_quote_cur ne '' then do;
            price_abs_diff=abs(prcc_f-hiid_quote_px);
            if not missing(prcc_f) and prcc_f>0 and
               price_abs_diff <= 0.00005 then do;
                quote_cur=hiid_quote_cur;
                quote_px=hiid_quote_px;
                price_issue=strip(hiid);
                annual_price_ok=1;
                if hiid_marker='P' then price_route='HIID_DATED_P';
                else price_route='HIID_NO_MARKER';
            end;
            else price_route='HIID_PRICE_MISMATCH';
        end;
        else price_route='HIID_NO_DATED_QUOTE';
    end;
    else if p_count=1 then do;
        if strip(upcase(p_primiss))='P' and p_quote_cur ne '' and
           not missing(p_quote_px) and p_quote_px>0 then do;
            price_abs_diff=abs(prcc_f-p_quote_px);
            if not missing(prcc_f) and prcc_f>0 and
               price_abs_diff <= 0.00005 then do;
                quote_cur=p_quote_cur;
                quote_px=p_quote_px;
                price_issue=strip(p_iid);
                annual_price_ok=1;
                price_route='UNIQUE_DATED_P';
            end;
            else price_route='UNIQUE_P_PRICE_MISMATCH';
        end;
        else price_route='UNIQUE_P_NO_QUOTE';
    end;
    else if p_count > 1 then price_route='MULTIPLE_DATED_P';
    else if missing(hiid) then price_route='NO_HIID_NO_DATED_P';
run;

proc freq data=work.price_routes;
    tables price_route*annual_price_ok / missing;
run;

proc sql;
    create table work.annual_join as
    select a.*, s.annual_price_ok, s.price_route, s.price_issue,
           s.quote_cur, s.quote_px, s.price_abs_diff, s.hiid_p_count,
           s.hiid_primiss,
           d1.fx_rate as gbp_cur_spot,
           d1.rate_type as gbp_cur_spot_type,
           d2.fx_rate as gbp_usd_spot,
           d2.rate_type as gbp_usd_spot_type,
           m1.fx_rate as gbp_cur_flow,
           m2.fx_rate as gbp_usd_flow,
           d3.fx_rate as gbp_price_cur_spot,
           d3.rate_type as gbp_price_cur_spot_type,
           d4.fx_rate as gbp_price_usd_spot,
           d4.rate_type as gbp_price_usd_spot_type
    from work.core_unique as a
    left join work.price_routes as s
      on a.gvkey=s.gvkey and a.fyear=s.fyear
    left join work.fx_dly as d1
      on d1.fromcurd='GBP' and a.curcd=d1.tocurd and a.datadate=d1.datadate
    left join work.fx_dly as d2
      on d2.fromcurd='GBP' and d2.tocurd='USD' and a.datadate=d2.datadate
    left join work.fx_mth as m1
      on m1.fromcurm='GBP' and a.curcd=m1.tocurm and
         intnx('month', a.datadate, 0, 'end')=m1.datadate
    left join work.fx_mth as m2
      on m2.fromcurm='GBP' and m2.tocurm='USD' and
         intnx('month', a.datadate, 0, 'end')=m2.datadate
    left join work.fx_dly as d3
      on d3.fromcurd='GBP' and s.quote_cur=d3.tocurd and a.datadate=d3.datadate
    left join work.fx_dly as d4
      on d4.fromcurd='GBP' and d4.tocurd='USD' and a.datadate=d4.datadate
    where a.fyear between &first_fy and &last_fy;
quit;

data work.annual;
    set work.annual_join;
    length source_cv_stock source_cv_flow price_cv_usd 8;
    source_cv_stock=.;
    source_cv_flow=.;
    price_cv_usd=.;

    /* Xpressfeed's primary/intermediate currency is GBP. CURNCD is not the
       FROM currency. Apply the provider's amount/rate formula using CURCD. */
    if curcd='USD' then do;
        source_cv_stock=1;
        source_cv_flow=1;
    end;
    else if curcd='GBP' then do;
        source_cv_stock=gbp_usd_spot;
        source_cv_flow=gbp_usd_flow;
    end;
    else if not missing(curcd) then do;
        if gbp_cur_spot>0 and gbp_usd_spot>0 then
            source_cv_stock=gbp_usd_spot/gbp_cur_spot;
        if gbp_cur_flow>0 and gbp_usd_flow>0 then
            source_cv_flow=gbp_usd_flow/gbp_cur_flow;
    end;

    if annual_price_ok=1 then do;
        if quote_cur='USD' then price_cv_usd=1;
        else if quote_cur='GBP' then price_cv_usd=gbp_price_usd_spot;
        else if quote_cur ne '' and gbp_price_cur_spot>0 and
                gbp_price_usd_spot>0 then do;
            price_cv_usd=gbp_price_usd_spot/gbp_price_cur_spot;
        end;
    end;

    if not missing(act) then do;
        if act=0 then act_usd=0;
        else if source_cv_stock>0 then act_usd=act*source_cv_stock;
    end;
    if not missing(lct) then do;
        if lct=0 then lct_usd=0;
        else if source_cv_stock>0 then lct_usd=lct*source_cv_stock;
    end;
    if not missing(at) then do;
        if at=0 then at_usd=0;
        else if source_cv_stock>0 then at_usd=at*source_cv_stock;
    end;
    if not missing(re) then do;
        if re=0 then re_usd=0;
        else if source_cv_stock>0 then re_usd=re*source_cv_stock;
    end;
    if not missing(lt) then do;
        if lt=0 then lt_usd=0;
        else if source_cv_stock>0 then lt_usd=lt*source_cv_stock;
    end;
    if not missing(seq) then do;
        if seq=0 then seq_usd=0;
        else if source_cv_stock>0 then seq_usd=seq*source_cv_stock;
    end;
    if not missing(ppent) then do;
        if ppent=0 then ppent_usd=0;
        else if source_cv_stock>0 then ppent_usd=ppent*source_cv_stock;
    end;
    if not missing(dltt) then do;
        if dltt=0 then dltt_usd=0;
        else if source_cv_stock>0 then dltt_usd=dltt*source_cv_stock;
    end;
    if not missing(dlc) then do;
        if dlc=0 then dlc_usd=0;
        else if source_cv_stock>0 then dlc_usd=dlc*source_cv_stock;
    end;

    if not missing(ebit) then do;
        if ebit=0 then ebit_usd=0;
        else if source_cv_flow>0 then ebit_usd=ebit*source_cv_flow;
    end;
    if not missing(sale) then do;
        if sale=0 then sale_usd=0;
        else if source_cv_flow>0 then sale_usd=sale*source_cv_flow;
    end;
    if not missing(capx) then do;
        if capx=0 then capx_usd=0;
        else if source_cv_flow>0 then capx_usd=capx*source_cv_flow;
    end;
    if not missing(xrd) then do;
        if xrd=0 then xrd_usd=0;
        else if source_cv_flow>0 then xrd_usd=xrd*source_cv_flow;
    end;
    if not missing(xad) then do;
        if xad=0 then xad_usd=0;
        else if source_cv_flow>0 then xad_usd=xad*source_cv_flow;
    end;
    if not missing(dp) then do;
        if dp=0 then dp_usd=0;
        else if source_cv_flow>0 then dp_usd=dp*source_cv_flow;
    end;
    if not missing(epspx) then do;
        if epspx=0 then epspx_usd=0;
        else if source_cv_flow>0 then epspx_usd=epspx*source_cv_flow;
    end;
    if annual_price_ok=1 and not missing(prcc_f) then do;
        if prcc_f=0 then prccf_usd=0;
        else if price_cv_usd>0 then prccf_usd=prcc_f*price_cv_usd;
    end;

    if nmiss(act_usd,lct_usd,at_usd,re_usd,ebit_usd,sale_usd,lt_usd,
             prccf_usd,csho)=0 and at_usd>0 and lt_usd>0 and
             csho>0 and prccf_usd>0 then do;
        mve_z_usd=prccf_usd*csho;
        zscore=1.2*((act_usd-lct_usd)/at_usd) +
               1.4*(re_usd/at_usd) +
               3.3*(ebit_usd/at_usd) +
               0.6*(mve_z_usd/lt_usd) +
               0.999*(sale_usd/at_usd);
    end;
run;

proc freq data=work.annual;
    tables annual_price_ok*curcd*quote_cur / missing;
run;

proc sql;
    select fyear,
           count(*) as source_rows,
           sum(annual_price_ok=1) as supported_issue_prices,
           sum(price_route='HIID_DATED_P') as hiid_dated_p,
           sum(price_route='HIID_NO_MARKER') as hiid_no_marker,
           sum(price_route='UNIQUE_DATED_P') as unique_p_fallback,
           sum(price_route='MULTIPLE_DATED_P') as multiple_dated_p,
           sum(price_route='HIID_EXPLICIT_NONP') as explicit_hiid_nonp,
           sum(not missing(source_cv_stock)) as usd_stock_conversion,
           sum(not missing(source_cv_flow)) as usd_flow_conversion,
           sum(not missing(prccf_usd)) as usd_annual_price,
           sum(curcd='USD' and curncd ne 'USD') as usd_report_curncd_diff
    from work.annual
    group by fyear
    order by fyear;

    select fromcurd,tocurd,count(*) as n_rows,
           sum(not missing(fx_rate)) as n_positive_unique_rate
    from work.fx_dly
    where fromcurd='GBP'
    group by fromcurd,tocurd
    order by tocurd;

    select fromcurm,tocurm,count(*) as n_rows,
           sum(not missing(fx_rate)) as n_positive_unique_rate
    from work.fx_mth
    where fromcurm='GBP'
    group by fromcurm,tocurm
    order by tocurm;
quit;

proc sort data=work.annual(where=(fyear >= 1972 and fyear <= 1992 and
                                  not missing(zscore))) out=work.zpop;
    by fyear;
run;

proc rank data=work.zpop out=work.zrank groups=10 ties=mean;
    by fyear;
    var zscore;
    ranks zdec;
run;

proc sql;
    select fyear, zdec, count(*) as z_population
    from work.zrank
    group by fyear, zdec
    order by fyear, zdec;
quit;

proc sql;
    create table work.wide as
    select a.gvkey, a.fyear, a.datadate as dat_t, a.curcd as cur_t,
           a.curncd as nat_t, a.pddur as dur_t, a.fyr as fyr_t,
           a.xrd_usd as xrd_t, a.capx_usd as capx_t, a.xad_usd as xad_t,
           a.ppent_usd as ppent_t, a.seq_usd as seq_t,
           a.dltt_usd as dltt_t, a.dlc_usd as dlc_t,
           a.cshpri as shares_t, a.csho as sh_out_t, a.ajex as ajex_t,
           a.prccf_usd as price_t_usd, a.epspx as eps_t_raw,
           a.mve_z_usd as mve_z_t, a.zscore,
           p.datadate as dat_p, p.curcd as cur_p, p.curncd as nat_p,
           p.seq_usd as seq_p, p.csho as sh_out_p, p.ajex as ajex_p,
           p.prccf_usd as price_p_usd, p.annual_price_ok as price_p_ok,
           p.quote_cur as price_cur_p,
           m1.xrd_usd as xrd_m1, m1.cshpri as shares_m1, m1.csho as sh_out_m1, m1.ajex as ajex_m1,
           m2.xrd_usd as xrd_m2, m2.cshpri as shares_m2, m2.csho as sh_out_m2, m2.ajex as ajex_m2,
           m3.xrd_usd as xrd_m3, m3.cshpri as shares_m3, m3.csho as sh_out_m3, m3.ajex as ajex_m3,
           m4.xrd_usd as xrd_m4, m4.cshpri as shares_m4, m4.csho as sh_out_m4, m4.ajex as ajex_m4,
           f1.datadate as dat_f1, f1.curcd as cur_f1, f1.curncd as nat_f1,
           f1.epspx as eps_f1_raw, f1.epspx_usd as eps_f1, f1.ajex as ajex_f1,
           f1.xrd as xrd_f1_raw, f1.dp as dp_f1_raw,
           f1.xrd_usd as xrd_f1, f1.dp_usd as dp_f1, f1.cshpri as shares_f1,
           f2.datadate as dat_f2, f2.curcd as cur_f2, f2.curncd as nat_f2,
           f2.epspx as eps_f2_raw, f2.epspx_usd as eps_f2, f2.ajex as ajex_f2,
           f2.xrd as xrd_f2_raw, f2.dp as dp_f2_raw,
           f2.xrd_usd as xrd_f2, f2.dp_usd as dp_f2, f2.cshpri as shares_f2,
           f3.datadate as dat_f3, f3.curcd as cur_f3, f3.curncd as nat_f3,
           f3.epspx as eps_f3_raw, f3.epspx_usd as eps_f3, f3.ajex as ajex_f3,
           f3.xrd as xrd_f3_raw, f3.dp as dp_f3_raw,
           f3.xrd_usd as xrd_f3, f3.dp_usd as dp_f3, f3.cshpri as shares_f3,
           f4.datadate as dat_f4, f4.curcd as cur_f4, f4.curncd as nat_f4,
           f4.epspx as eps_f4_raw, f4.epspx_usd as eps_f4, f4.ajex as ajex_f4,
           f4.xrd as xrd_f4_raw, f4.dp as dp_f4_raw,
           f4.xrd_usd as xrd_f4, f4.dp_usd as dp_f4, f4.cshpri as shares_f4,
           f5.datadate as dat_f5, f5.curcd as cur_f5, f5.curncd as nat_f5,
           f5.epspx as eps_f5_raw, f5.epspx_usd as eps_f5, f5.ajex as ajex_f5,
           f5.xrd as xrd_f5_raw, f5.dp as dp_f5_raw,
           f5.xrd_usd as xrd_f5, f5.dp_usd as dp_f5, f5.cshpri as shares_f5
    from work.annual as a
    left join work.annual as p
      on a.gvkey=p.gvkey and p.fyear=a.fyear-1
    left join work.annual as m1
      on a.gvkey=m1.gvkey and m1.fyear=a.fyear-1
    left join work.annual as m2
      on a.gvkey=m2.gvkey and m2.fyear=a.fyear-2
    left join work.annual as m3
      on a.gvkey=m3.gvkey and m3.fyear=a.fyear-3
    left join work.annual as m4
      on a.gvkey=m4.gvkey and m4.fyear=a.fyear-4
    left join work.annual as f1
      on a.gvkey=f1.gvkey and f1.fyear=a.fyear+1
    left join work.annual as f2
      on a.gvkey=f2.gvkey and f2.fyear=a.fyear+2
    left join work.annual as f3
      on a.gvkey=f3.gvkey and f3.fyear=a.fyear+3
    left join work.annual as f4
      on a.gvkey=f4.gvkey and f4.fyear=a.fyear+4
    left join work.annual as f5
      on a.gvkey=f5.gvkey and f5.fyear=a.fyear+5
    where a.fyear between 1972 and 1992;
quit;

proc sql;
    create table work.widez as
    select w.*, z.zdec
    from work.wide as w
    left join work.zrank as z
      on w.gvkey=z.gvkey and w.fyear=z.fyear;
quit;

data work.base0;
    set work.widez;
    length date_order 3;
    array fdate[5] dat_f1 dat_f2 dat_f3 dat_f4 dat_f5;
    prev_date=dat_t;
    date_order=1;
    if missing(dat_t) then date_order=0;
    if not missing(dat_p) and dat_p >= dat_t then date_order=0;
    do j=1 to 5;
        if not missing(fdate[j]) then do;
            if fdate[j] <= prev_date then date_order=0;
            prev_date=fdate[j];
        end;
    end;
    drop j prev_date;

    future_source_missing=0;
    future_construct_missing=0;
    gross_source_missing=0;
    gross_construct_missing=0;
    array epsraw[5] eps_f1_raw eps_f2_raw eps_f3_raw eps_f4_raw eps_f5_raw;
    array epsusd[5] eps_f1 eps_f2 eps_f3 eps_f4 eps_f5;
    array xrdraw[5] xrd_f1_raw xrd_f2_raw xrd_f3_raw xrd_f4_raw xrd_f5_raw;
    array dpraw[5] dp_f1_raw dp_f2_raw dp_f3_raw dp_f4_raw dp_f5_raw;
    array xrddol[5] xrd_f1 xrd_f2 xrd_f3 xrd_f4 xrd_f5;
    array dpdol[5] dp_f1 dp_f2 dp_f3 dp_f4 dp_f5;
    if date_order=1 then do j=1 to 5;
        if missing(epsraw[j]) then future_source_missing=1;
        else if missing(epsusd[j]) then future_construct_missing=1;
        if nmiss(epsraw[j],xrdraw[j],dpraw[j]) > 0 then gross_source_missing=1;
        else if nmiss(epsusd[j],xrddol[j],dpdol[j]) > 0 then gross_construct_missing=1;
    end;
    drop j;

    mve_usd=.;
    if not missing(price_t_usd) and not missing(shares_t) and shares_t>0 then
        mve_usd=price_t_usd*shares_t;
    mve_bil=.;
    size=.;
    if mve_usd>0 then do;
        mve_bil=mve_usd/1000;
        size=log(mve_bil);
    end;
    lev=.;
    if nmiss(dltt_t,dlc_t,mve_usd)=0 and dltt_t+mve_usd ne 0 then
        lev=(dltt_t+dlc_t)/(dltt_t+mve_usd);

    bve_ps_p=.;
    if nmiss(seq_p,sh_out_p,ajex_t,ajex_p)=0 and
       seq_p>0 and sh_out_p>0 and ajex_t>0 and ajex_p>0 then
        bve_ps_p=(seq_p/sh_out_p)*(ajex_t/ajex_p);
    price_ps_p=.;
    if nmiss(price_p_usd,ajex_t,ajex_p)=0 and
       price_p_ok=1 and price_p_usd>0 and ajex_t>0 and ajex_p>0 then
        price_ps_p=price_p_usd*(ajex_t/ajex_p);

    xrd_ps=.; capx_ps=.; xad_ps=.;
    if not missing(xrd_t) and not missing(shares_t) and shares_t>0 then xrd_ps=xrd_t/shares_t;
    if not missing(capx_t) and not missing(shares_t) and shares_t>0 then capx_ps=capx_t/shares_t;
    if not missing(xad_t) and not missing(shares_t) and shares_t>0 then xad_ps=xad_t/shares_t;
    xrd_bve=.; capx_bve=.; xad_bve=.;
    if bve_ps_p>0 then do;
        if not missing(xrd_ps) then xrd_bve=xrd_ps/bve_ps_p;
        if not missing(capx_ps) then capx_bve=capx_ps/bve_ps_p;
        if not missing(xad_ps) then xad_bve=xad_ps/bve_ps_p;
    end;
    xrd_price=.; capx_price=.; xad_price=.;
    if price_ps_p>0 then do;
        if not missing(xrd_ps) then xrd_price=xrd_ps/price_ps_p;
        if not missing(capx_ps) then capx_price=capx_ps/price_ps_p;
        if not missing(xad_ps) then xad_price=xad_ps/price_ps_p;
    end;

    caprd_usd=.; caprd_ps=.; caprd_ps_epsden=.; caprd_bve=.; caprd_old_ps=.;
    ppent_ps=.; ppent_bve=.;
    if nmiss(xrd_t,xrd_m1,xrd_m2,xrd_m3,xrd_m4,sh_out_t)=0 and sh_out_t>0 then do;
        caprd_usd=xrd_t + 0.8*xrd_m1 + 0.6*xrd_m2 + 0.4*xrd_m3 + 0.2*xrd_m4;
        caprd_ps=caprd_usd/sh_out_t;
        if bve_ps_p>0 then caprd_bve=caprd_ps/bve_ps_p;
        if shares_t>0 then caprd_ps_epsden=caprd_usd/shares_t;
    end;
    if nmiss(xrd_t,xrd_m1,xrd_m2,xrd_m3,xrd_m4,
             shares_t,shares_m1,shares_m2,shares_m3,shares_m4,
             ajex_t,ajex_m1,ajex_m2,ajex_m3,ajex_m4)=0 and
       min(shares_t,shares_m1,shares_m2,shares_m3,shares_m4,
           ajex_t,ajex_m1,ajex_m2,ajex_m3,ajex_m4)>0 then do;
        caprd_old_ps=xrd_t/shares_t +
                     0.8*(xrd_m1/shares_m1)*(ajex_t/ajex_m1) +
                     0.6*(xrd_m2/shares_m2)*(ajex_t/ajex_m2) +
                     0.4*(xrd_m3/shares_m3)*(ajex_t/ajex_m3) +
                     0.2*(xrd_m4/shares_m4)*(ajex_t/ajex_m4);
    end;
    caprd_shares_vary=.; caprd_split_vary=.; caprd_old_diff=.;
    caprd_old_epsden_diff=.; caprd_denominator_diff=.;
    if nmiss(sh_out_t,sh_out_m1,sh_out_m2,sh_out_m3,sh_out_m4)=0 then
        caprd_shares_vary=(max(of sh_out_t sh_out_m1-sh_out_m4) ne
                           min(of sh_out_t sh_out_m1-sh_out_m4));
    if nmiss(ajex_t,ajex_m1,ajex_m2,ajex_m3,ajex_m4)=0 then
        caprd_split_vary=(max(of ajex_t ajex_m1-ajex_m4) ne
                          min(of ajex_t ajex_m1-ajex_m4));
    if nmiss(caprd_ps,caprd_old_ps)=0 then caprd_old_diff=caprd_ps-caprd_old_ps;
    if nmiss(caprd_ps_epsden,caprd_old_ps)=0 then
        caprd_old_epsden_diff=caprd_ps_epsden-caprd_old_ps;
    if nmiss(caprd_ps,caprd_ps_epsden)=0 then
        caprd_denominator_diff=caprd_ps-caprd_ps_epsden;
    if not missing(ppent_t) and not missing(sh_out_t) and sh_out_t>0 then do;
        ppent_ps=ppent_t/sh_out_t;
        if bve_ps_p>0 then ppent_bve=ppent_ps/bve_ps_p;
    end;
    xad_cap=.;
    if not missing(xad_ps) and bve_ps_p>0 then xad_cap=xad_ps/bve_ps_p;

    eps_b1=.; eps_b2=.; eps_b3=.; eps_b4=.; eps_b5=.;
    eps_p1=.; eps_p2=.; eps_p3=.; eps_p4=.; eps_p5=.;
    eps_g1=.; eps_g2=.; eps_g3=.; eps_g4=.; eps_g5=.;
    if date_order=1 and bve_ps_p>0 and ajex_t>0 then do;
        if not missing(eps_f1) and ajex_f1>0 then eps_b1=(eps_f1*ajex_t/ajex_f1)/bve_ps_p;
        if not missing(eps_f2) and ajex_f2>0 then eps_b2=(eps_f2*ajex_t/ajex_f2)/bve_ps_p;
        if not missing(eps_f3) and ajex_f3>0 then eps_b3=(eps_f3*ajex_t/ajex_f3)/bve_ps_p;
        if not missing(eps_f4) and ajex_f4>0 then eps_b4=(eps_f4*ajex_t/ajex_f4)/bve_ps_p;
        if not missing(eps_f5) and ajex_f5>0 then eps_b5=(eps_f5*ajex_t/ajex_f5)/bve_ps_p;
        if not missing(eps_f1) and ajex_f1>0 then eps_g1=(eps_f1*ajex_t/ajex_f1);
        if not missing(eps_f2) and ajex_f2>0 then eps_g2=(eps_f2*ajex_t/ajex_f2);
        if not missing(eps_f3) and ajex_f3>0 then eps_g3=(eps_f3*ajex_t/ajex_f3);
        if not missing(eps_f4) and ajex_f4>0 then eps_g4=(eps_f4*ajex_t/ajex_f4);
        if not missing(eps_f5) and ajex_f5>0 then eps_g5=(eps_f5*ajex_t/ajex_f5);
    end;
    if date_order=1 and price_ps_p>0 and ajex_t>0 then do;
        if not missing(eps_f1) and ajex_f1>0 then eps_p1=(eps_f1*ajex_t/ajex_f1)/price_ps_p;
        if not missing(eps_f2) and ajex_f2>0 then eps_p2=(eps_f2*ajex_t/ajex_f2)/price_ps_p;
        if not missing(eps_f3) and ajex_f3>0 then eps_p3=(eps_f3*ajex_t/ajex_f3)/price_ps_p;
        if not missing(eps_f4) and ajex_f4>0 then eps_p4=(eps_f4*ajex_t/ajex_f4)/price_ps_p;
        if not missing(eps_f5) and ajex_f5>0 then eps_p5=(eps_f5*ajex_t/ajex_f5)/price_ps_p;
    end;
    if date_order=1 and bve_ps_p>0 and ajex_t>0 then do;
        if nmiss(eps_f1,xrd_f1,dp_f1,shares_f1,ajex_f1)=0 and shares_f1>0 and ajex_f1>0 then
            eps_g1=((eps_f1+(xrd_f1+dp_f1)/shares_f1)*ajex_t/ajex_f1)/bve_ps_p;
        else eps_g1=.;
        if nmiss(eps_f2,xrd_f2,dp_f2,shares_f2,ajex_f2)=0 and shares_f2>0 and ajex_f2>0 then
            eps_g2=((eps_f2+(xrd_f2+dp_f2)/shares_f2)*ajex_t/ajex_f2)/bve_ps_p;
        else eps_g2=.;
        if nmiss(eps_f3,xrd_f3,dp_f3,shares_f3,ajex_f3)=0 and shares_f3>0 and ajex_f3>0 then
            eps_g3=((eps_f3+(xrd_f3+dp_f3)/shares_f3)*ajex_t/ajex_f3)/bve_ps_p;
        else eps_g3=.;
        if nmiss(eps_f4,xrd_f4,dp_f4,shares_f4,ajex_f4)=0 and shares_f4>0 and ajex_f4>0 then
            eps_g4=((eps_f4+(xrd_f4+dp_f4)/shares_f4)*ajex_t/ajex_f4)/bve_ps_p;
        else eps_g4=.;
        if nmiss(eps_f5,xrd_f5,dp_f5,shares_f5,ajex_f5)=0 and shares_f5>0 and ajex_f5>0 then
            eps_g5=((eps_f5+(xrd_f5+dp_f5)/shares_f5)*ajex_t/ajex_f5)/bve_ps_p;
        else eps_g5=.;
    end;

    array epscaps[15] eps_b1-eps_b5 eps_p1-eps_p5 eps_g1-eps_g5;
    do k=1 to 15;
        if not missing(epscaps[k]) then do;
            if epscaps[k] < -1 then epscaps[k]=-1;
            else if epscaps[k] > 1 then epscaps[k]=1;
        end;
    end;
    drop k;
run;

proc sql;
    select count(*) as caprd_new_per_share_n,
           sum(not missing(caprd_old_ps)) as comparable_old_n,
           sum(caprd_shares_vary=1) as unequal_share_history_n,
           sum(caprd_split_vary=1) as nontrivial_ajex_history_n,
           max(abs(caprd_old_diff)) as max_abs_stock_vs_a1,
           mean(abs(caprd_old_diff)) as mean_abs_stock_vs_a1,
           max(abs(caprd_old_epsden_diff)) as max_abs_epsden_vs_a1,
           mean(abs(caprd_old_epsden_diff)) as mean_abs_epsden_vs_a1,
           max(abs(caprd_denominator_diff)) as max_abs_csho_cshpri_diff,
           mean(abs(caprd_denominator_diff)) as mean_abs_csho_cshpri_diff
    from work.base0
    where fyear between 1972 and 1992;
quit;

proc sql;
    create table work.zrank_all as
    select gvkey, fyear, zdec
    from work.zrank;

    create table work.bve_donors0 as
    select gvkey, fyear, zdec, std(eps_b1,eps_b2,eps_b3,eps_b4,eps_b5) as y_bve_obs
    from work.base0
    where zdec ne . and nmiss(eps_b1,eps_b2,eps_b3,eps_b4,eps_b5)=0;
    create table work.bve_donors as
    select fyear, zdec, mean(y_bve_obs) as donor_bve
    from work.bve_donors0
    group by fyear, zdec;

    create table work.price_donors0 as
    select gvkey, fyear, zdec, std(eps_p1,eps_p2,eps_p3,eps_p4,eps_p5) as y_price_obs
    from work.base0
    where zdec ne . and nmiss(eps_p1,eps_p2,eps_p3,eps_p4,eps_p5)=0;
    create table work.price_donors as
    select fyear, zdec, mean(y_price_obs) as donor_price
    from work.price_donors0
    group by fyear, zdec;

    create table work.cap_donors0 as
    select gvkey, fyear, zdec, std(eps_g1,eps_g2,eps_g3,eps_g4,eps_g5) as y_cap_obs
    from work.base0
    where zdec ne . and nmiss(eps_g1,eps_g2,eps_g3,eps_g4,eps_g5)=0;
    create table work.cap_donors as
    select fyear, zdec, mean(y_cap_obs) as donor_cap
    from work.cap_donors0
    group by fyear, zdec;

    create table work.with_donors as
    select b.*, z.zdec as zscore_decile,
           db.donor_bve, dp.donor_price, dc.donor_cap
    from work.base0 as b
    left join work.zrank_all as z
      on b.gvkey=z.gvkey and b.fyear=z.fyear
    left join work.bve_donors as db
      on b.fyear=db.fyear and z.zdec=db.zdec
    left join work.price_donors as dp
      on b.fyear=dp.fyear and z.zdec=dp.zdec
    left join work.cap_donors as dc
      on b.fyear=dc.fyear and z.zdec=dc.zdec;
quit;

proc sql;
    select fyear,zdec,count(*) as bve_observed_donors
    from work.bve_donors0
    group by fyear,zdec
    order by fyear,zdec;
    select fyear,zdec,count(*) as price_observed_donors
    from work.price_donors0
    group by fyear,zdec
    order by fyear,zdec;
    select fyear,zdec,count(*) as gross_observed_donors
    from work.cap_donors0
    group by fyear,zdec
    order by fyear,zdec;
quit;

data work.outcomes;
    set work.with_donors;
    y_bve=.; y_price=.; y_cap=.;
    imp_bve=.; imp_price=.; imp_cap=.;
    if date_order=1 and bve_ps_p>0 then do;
        if nmiss(eps_b1,eps_b2,eps_b3,eps_b4,eps_b5)=0 then do;
            y_bve=std(eps_b1,eps_b2,eps_b3,eps_b4,eps_b5);
            imp_bve=0;
        end;
        else if future_source_missing=1 and not missing(donor_bve) then do;
            y_bve=donor_bve;
            imp_bve=1;
        end;
    end;
    if date_order=1 and price_ps_p>0 then do;
        if nmiss(eps_p1,eps_p2,eps_p3,eps_p4,eps_p5)=0 then do;
            y_price=std(eps_p1,eps_p2,eps_p3,eps_p4,eps_p5);
            imp_price=0;
        end;
        else if future_source_missing=1 and not missing(donor_price) then do;
            y_price=donor_price;
            imp_price=1;
        end;
    end;
    if date_order=1 and bve_ps_p>0 then do;
        if nmiss(eps_g1,eps_g2,eps_g3,eps_g4,eps_g5)=0 then do;
            y_cap=std(eps_g1,eps_g2,eps_g3,eps_g4,eps_g5);
            imp_cap=0;
        end;
        else if gross_source_missing=1 and not missing(donor_cap) then do;
            y_cap=donor_cap;
            imp_cap=1;
        end;
    end;

    candidate_bve=0; candidate_price=0; candidate_cap=0;
    base_bve=0; base_price=0; fit_bve=0; fit_price=0; fit_cap=0;
    if nmiss(xrd_bve,capx_bve,size,lev)=0 and bve_ps_p>0 and
       not missing(eps_t_raw) then candidate_bve=1;
    if nmiss(xrd_price,capx_price,size,lev)=0 and price_ps_p>0 and
       not missing(eps_t_raw) then candidate_price=1;
    if candidate_bve=1 and not missing(y_bve) then base_bve=1;
    if candidate_price=1 and not missing(y_price) then base_price=1;
    if base_bve=1 and not missing(xad_bve) then fit_bve=1;
    if base_price=1 and not missing(xad_price) then fit_price=1;
    if candidate_bve=1 and not missing(xad_cap) and not missing(caprd_bve) and
       not missing(ppent_bve) then candidate_cap=1;
    if candidate_cap=1 and not missing(y_cap) then fit_cap=1;
run;

%macro cutvar(flag=,var=,prefix=,out=);
    proc univariate data=work.outcomes(where=(&flag=1)) noprint pctldef=5;
        by fyear;
        var &var;
        output out=&out pctlpts=1 2 99 pctlpre=&prefix._ pctlname=p1 p2 p99;
    run;
%mend;

proc sort data=work.outcomes; by fyear; run;
%cutvar(flag=fit_bve,var=xrd_bve,prefix=xrb,out=work.c_xrb);
%cutvar(flag=fit_bve,var=capx_bve,prefix=xcb,out=work.c_xcb);
%cutvar(flag=fit_bve,var=xad_bve,prefix=xab,out=work.c_xab);
%cutvar(flag=fit_bve,var=size,prefix=sizb,out=work.c_sizb);
%cutvar(flag=fit_bve,var=lev,prefix=levb,out=work.c_levb);
%cutvar(flag=fit_price,var=xrd_price,prefix=xrp,out=work.c_xrp);
%cutvar(flag=fit_price,var=capx_price,prefix=xcp,out=work.c_xcp);
%cutvar(flag=fit_price,var=xad_price,prefix=xap,out=work.c_xap);
%cutvar(flag=fit_price,var=size,prefix=sizp,out=work.c_sizp);
%cutvar(flag=fit_price,var=lev,prefix=levp,out=work.c_levp);
%cutvar(flag=fit_cap,var=caprd_bve,prefix=crd,out=work.c_crd);
%cutvar(flag=fit_cap,var=ppent_bve,prefix=ppe,out=work.c_ppe);
%cutvar(flag=fit_cap,var=xad_cap,prefix=xac,out=work.c_xac);
%cutvar(flag=fit_cap,var=size,prefix=sizc,out=work.c_sizc);
%cutvar(flag=fit_cap,var=lev,prefix=levc,out=work.c_levc);

proc sql;
    create table work.cuts_bve as
    select a.fyear, a.xrb_p1, a.xrb_p2, a.xrb_p99,
           b.xcb_p1, b.xcb_p2, b.xcb_p99,
           c.xab_p1, c.xab_p2, c.xab_p99,
           d.sizb_p1, d.sizb_p2, d.sizb_p99,
           e.levb_p1, e.levb_p2, e.levb_p99
    from work.c_xrb as a
    left join work.c_xcb as b on a.fyear=b.fyear
    left join work.c_xab as c on a.fyear=c.fyear
    left join work.c_sizb as d on a.fyear=d.fyear
    left join work.c_levb as e on a.fyear=e.fyear;

    create table work.cuts_price as
    select a.fyear, a.xrp_p1, a.xrp_p2, a.xrp_p99,
           b.xcp_p1, b.xcp_p2, b.xcp_p99,
           c.xap_p1, c.xap_p2, c.xap_p99,
           d.sizp_p1, d.sizp_p2, d.sizp_p99,
           e.levp_p1, e.levp_p2, e.levp_p99
    from work.c_xrp as a
    left join work.c_xcp as b on a.fyear=b.fyear
    left join work.c_xap as c on a.fyear=c.fyear
    left join work.c_sizp as d on a.fyear=d.fyear
    left join work.c_levp as e on a.fyear=e.fyear;

    create table work.cuts_cap as
    select a.fyear, a.crd_p1, a.crd_p2, a.crd_p99,
           b.ppe_p1, b.ppe_p2, b.ppe_p99,
           c.xac_p1, c.xac_p2, c.xac_p99,
           d.sizc_p1, d.sizc_p2, d.sizc_p99,
           e.levc_p1, e.levc_p2, e.levc_p99
    from work.c_crd as a
    left join work.c_ppe as b on a.fyear=b.fyear
    left join work.c_xac as c on a.fyear=c.fyear
    left join work.c_sizc as d on a.fyear=d.fyear
    left join work.c_levc as e on a.fyear=e.fyear;

    create table work.final_join as
    select o.*, b.xrb_p1,b.xrb_p2,b.xrb_p99,b.xcb_p1,b.xcb_p2,b.xcb_p99,
           b.xab_p1,b.xab_p2,b.xab_p99,b.sizb_p1,b.sizb_p2,b.sizb_p99,
           b.levb_p1,b.levb_p2,b.levb_p99,
           p.xrp_p1,p.xrp_p2,p.xrp_p99,p.xcp_p1,p.xcp_p2,p.xcp_p99,
           p.xap_p1,p.xap_p2,p.xap_p99,p.sizp_p1,p.sizp_p2,p.sizp_p99,
           p.levp_p1,p.levp_p2,p.levp_p99,
           c.crd_p1,c.crd_p2,c.crd_p99,c.ppe_p1,c.ppe_p2,c.ppe_p99,
           c.xac_p1,c.xac_p2,c.xac_p99,c.sizc_p1,c.sizc_p2,c.sizc_p99,
           c.levc_p1,c.levc_p2,c.levc_p99
    from work.outcomes as o
    left join work.cuts_bve as b on o.fyear=b.fyear
    left join work.cuts_price as p on o.fyear=p.fyear
    left join work.cuts_cap as c on o.fyear=c.fyear;
quit;

proc sql;
    select 'Table3A_BVE' as model length=16,
           sum(fit_bve=1 and xrd_bve<xrb_p1) +
           sum(fit_bve=1 and capx_bve<xcb_p1) +
           sum(fit_bve=1 and xad_bve<xab_p1) +
           sum(fit_bve=1 and size<sizb_p1) +
           sum(fit_bve=1 and lev<levb_p1) as p1_lower_variable_clamps,
           sum(fit_bve=1 and xrd_bve>=xrb_p1 and xrd_bve<xrb_p2) +
           sum(fit_bve=1 and capx_bve>=xcb_p1 and capx_bve<xcb_p2) +
           sum(fit_bve=1 and xad_bve>=xab_p1 and xad_bve<xab_p2) +
           sum(fit_bve=1 and size>=sizb_p1 and size<sizb_p2) +
           sum(fit_bve=1 and lev>=levb_p1 and lev<levb_p2) as extra_if_p2,
           sum(fit_bve=1 and xrd_bve>xrb_p99) +
           sum(fit_bve=1 and capx_bve>xcb_p99) +
           sum(fit_bve=1 and xad_bve>xab_p99) +
           sum(fit_bve=1 and size>sizb_p99) +
           sum(fit_bve=1 and lev>levb_p99) as p99_upper_variable_clamps
    from work.final_join;
    select 'Table3B_PRICE' as model length=16,
           sum(fit_price=1 and xrd_price<xrp_p1) +
           sum(fit_price=1 and capx_price<xcp_p1) +
           sum(fit_price=1 and xad_price<xap_p1) +
           sum(fit_price=1 and size<sizp_p1) +
           sum(fit_price=1 and lev<levp_p1) as p1_lower_variable_clamps,
           sum(fit_price=1 and xrd_price>=xrp_p1 and xrd_price<xrp_p2) +
           sum(fit_price=1 and capx_price>=xcp_p1 and capx_price<xcp_p2) +
           sum(fit_price=1 and xad_price>=xap_p1 and xad_price<xap_p2) +
           sum(fit_price=1 and size>=sizp_p1 and size<sizp_p2) +
           sum(fit_price=1 and lev>=levp_p1 and lev<levp_p2) as extra_if_p2,
           sum(fit_price=1 and xrd_price>xrp_p99) +
           sum(fit_price=1 and capx_price>xcp_p99) +
           sum(fit_price=1 and xad_price>xap_p99) +
           sum(fit_price=1 and size>sizp_p99) +
           sum(fit_price=1 and lev>levp_p99) as p99_upper_variable_clamps
    from work.final_join;
    select 'Table4B_CAP' as model length=16,
           sum(fit_cap=1 and caprd_bve<crd_p1) +
           sum(fit_cap=1 and ppent_bve<ppe_p1) +
           sum(fit_cap=1 and xad_cap<xac_p1) +
           sum(fit_cap=1 and size<sizc_p1) +
           sum(fit_cap=1 and lev<levc_p1) as p1_lower_variable_clamps,
           sum(fit_cap=1 and caprd_bve>=crd_p1 and caprd_bve<crd_p2) +
           sum(fit_cap=1 and ppent_bve>=ppe_p1 and ppent_bve<ppe_p2) +
           sum(fit_cap=1 and xad_cap>=xac_p1 and xad_cap<xac_p2) +
           sum(fit_cap=1 and size>=sizc_p1 and size<sizc_p2) +
           sum(fit_cap=1 and lev>=levc_p1 and lev<levc_p2) as extra_if_p2,
           sum(fit_cap=1 and caprd_bve>crd_p99) +
           sum(fit_cap=1 and ppent_bve>ppe_p99) +
           sum(fit_cap=1 and xad_cap>xac_p99) +
           sum(fit_cap=1 and size>sizc_p99) +
           sum(fit_cap=1 and lev>levc_p99) as p99_upper_variable_clamps
    from work.final_join;
quit;

data work.final;
    set work.final_join;
    if candidate_bve=0 and candidate_price=0 and candidate_cap=0 then delete;
    length xrd_bve_w capx_bve_w xad_bve_w size_bve_w lev_bve_w 8;
    length xrd_price_w capx_price_w xad_price_w size_price_w lev_price_w 8;
    length caprd_bve_w ppent_bve_w xad_cap_w size_cap_w lev_cap_w 8;

    xrd_bve_w=.; capx_bve_w=.; xad_bve_w=.; size_bve_w=.; lev_bve_w=.;
    if fit_bve=1 then do;
        xrd_bve_w=xrd_bve; capx_bve_w=capx_bve; xad_bve_w=xad_bve;
        size_bve_w=size; lev_bve_w=lev;
        if not missing(xrb_p1) and xrd_bve < xrb_p1 then xrd_bve_w=xrb_p1;
        else if not missing(xrb_p99) and xrd_bve > xrb_p99 then xrd_bve_w=xrb_p99;
        if not missing(xcb_p1) and capx_bve < xcb_p1 then capx_bve_w=xcb_p1;
        else if not missing(xcb_p99) and capx_bve > xcb_p99 then capx_bve_w=xcb_p99;
        if not missing(xab_p1) and xad_bve < xab_p1 then xad_bve_w=xab_p1;
        else if not missing(xab_p99) and xad_bve > xab_p99 then xad_bve_w=xab_p99;
        if not missing(sizb_p1) and size < sizb_p1 then size_bve_w=sizb_p1;
        else if not missing(sizb_p99) and size > sizb_p99 then size_bve_w=sizb_p99;
        if not missing(levb_p1) and lev < levb_p1 then lev_bve_w=levb_p1;
        else if not missing(levb_p99) and lev > levb_p99 then lev_bve_w=levb_p99;
    end;

    xrd_price_w=.; capx_price_w=.; xad_price_w=.; size_price_w=.; lev_price_w=.;
    if fit_price=1 then do;
        xrd_price_w=xrd_price; capx_price_w=capx_price; xad_price_w=xad_price;
        size_price_w=size; lev_price_w=lev;
        if not missing(xrp_p1) and xrd_price < xrp_p1 then xrd_price_w=xrp_p1;
        else if not missing(xrp_p99) and xrd_price > xrp_p99 then xrd_price_w=xrp_p99;
        if not missing(xcp_p1) and capx_price < xcp_p1 then capx_price_w=xcp_p1;
        else if not missing(xcp_p99) and capx_price > xcp_p99 then capx_price_w=xcp_p99;
        if not missing(xap_p1) and xad_price < xap_p1 then xad_price_w=xap_p1;
        else if not missing(xap_p99) and xad_price > xap_p99 then xad_price_w=xap_p99;
        if not missing(sizp_p1) and size < sizp_p1 then size_price_w=sizp_p1;
        else if not missing(sizp_p99) and size > sizp_p99 then size_price_w=sizp_p99;
        if not missing(levp_p1) and lev < levp_p1 then lev_price_w=levp_p1;
        else if not missing(levp_p99) and lev > levp_p99 then lev_price_w=levp_p99;
    end;

    caprd_bve_w=.; ppent_bve_w=.; xad_cap_w=.; size_cap_w=.; lev_cap_w=.;
    if fit_cap=1 then do;
        caprd_bve_w=caprd_bve; ppent_bve_w=ppent_bve; xad_cap_w=xad_cap;
        size_cap_w=size; lev_cap_w=lev;
        if not missing(crd_p1) and caprd_bve < crd_p1 then caprd_bve_w=crd_p1;
        else if not missing(crd_p99) and caprd_bve > crd_p99 then caprd_bve_w=crd_p99;
        if not missing(ppe_p1) and ppent_bve < ppe_p1 then ppent_bve_w=ppe_p1;
        else if not missing(ppe_p99) and ppent_bve > ppe_p99 then ppent_bve_w=ppe_p99;
        if not missing(xac_p1) and xad_cap < xac_p1 then xad_cap_w=xac_p1;
        else if not missing(xac_p99) and xad_cap > xac_p99 then xad_cap_w=xac_p99;
        if not missing(sizc_p1) and size < sizc_p1 then size_cap_w=sizc_p1;
        else if not missing(sizc_p99) and size > sizc_p99 then size_cap_w=sizc_p99;
        if not missing(levc_p1) and lev < levc_p1 then lev_cap_w=levc_p1;
        else if not missing(levc_p99) and lev > levc_p99 then lev_cap_w=levc_p99;
    end;

    keep gvkey fyear zscore_decile
         base_bve base_price fit_bve fit_price fit_cap
         imp_bve imp_price imp_cap
         y_bve y_price y_cap
         xrd_bve_w capx_bve_w xad_bve_w size_bve_w lev_bve_w
         xrd_price_w capx_price_w xad_price_w size_price_w lev_price_w
         caprd_bve_w ppent_bve_w xad_cap_w size_cap_w lev_cap_w;
run;

proc sql;
    select sum(candidate_bve) as bve_candidates,
           sum(nmiss(xrd_bve,capx_bve,size,lev)=0 and bve_ps_p>0 and
               missing(eps_t_raw)) as bve_missing_current_eps,
           sum(base_bve) as broad_bve_n,
           sum(base_bve=1 and imp_bve=0) as broad_bve_observed,
           sum(base_bve=1 and imp_bve=1) as broad_bve_imputed,
           sum(candidate_bve=1 and missing(y_bve)) as bve_no_outcome,
           sum(candidate_bve=1 and date_order ne 1) as bve_bad_date_order,
           sum(candidate_bve=1 and future_source_missing=1) as bve_source_future_missing,
           sum(candidate_bve=1 and future_construct_missing=1) as bve_future_conv_miss,
           sum(candidate_bve=1 and future_source_missing=0 and
               future_construct_missing=1 and missing(y_bve)) as bve_unimputed_construct_missing,
           sum(candidate_bve=1 and future_source_missing=1 and
               missing(zscore_decile)) as bve_missing_score_recipients,
           sum(candidate_bve=1 and not missing(xad_bve)) as bve_full_candidates,
           sum(fit_bve) as full_bve_n,
           sum(fit_bve=1 and imp_bve=0) as full_bve_observed,
           sum(fit_bve=1 and imp_bve=1) as full_bve_imputed,
           sum(candidate_bve=1 and not missing(xad_bve) and missing(y_bve)) as bve_full_no_outcome,
           sum(candidate_price) as price_candidates,
           sum(nmiss(xrd_price,capx_price,size,lev)=0 and price_ps_p>0 and
               missing(eps_t_raw)) as price_missing_current_eps,
           sum(base_price) as broad_price_n,
           sum(base_price=1 and imp_price=0) as broad_price_observed,
           sum(base_price=1 and imp_price=1) as broad_price_imputed,
           sum(candidate_price=1 and missing(y_price)) as price_no_outcome,
           sum(candidate_price=1 and date_order ne 1) as price_bad_date_order,
           sum(candidate_price=1 and future_source_missing=1) as price_source_future_missing,
           sum(candidate_price=1 and future_construct_missing=1) as price_future_conv_miss,
           sum(candidate_price=1 and future_source_missing=0 and
               future_construct_missing=1 and missing(y_price)) as price_no_impute_construct,
           sum(candidate_price=1 and future_source_missing=1 and
               missing(zscore_decile)) as price_missing_score_recipients,
           sum(candidate_price=1 and not missing(xad_price)) as price_full_candidates,
           sum(fit_price) as full_price_n,
           sum(fit_price=1 and imp_price=0) as full_price_observed,
           sum(fit_price=1 and imp_price=1) as full_price_imputed,
           sum(candidate_price=1 and not missing(xad_price) and missing(y_price)) as price_full_no_outcome,
           sum(candidate_cap) as cap_full_candidates,
           sum(candidate_cap=1 and gross_source_missing=1) as cap_source_future_missing,
           sum(candidate_cap=1 and gross_construct_missing=1) as cap_future_conv_miss,
           sum(candidate_cap=1 and gross_source_missing=0 and
               gross_construct_missing=1 and missing(y_cap)) as cap_unimputed_construct_missing,
           sum(candidate_cap=1 and gross_source_missing=1 and
               missing(zscore_decile)) as cap_missing_score_recipients,
           sum(fit_cap) as full_cap_n,
           sum(fit_cap=1 and imp_cap=0) as full_cap_observed,
           sum(fit_cap=1 and imp_cap=1) as full_cap_imputed,
           sum(candidate_cap=1 and missing(y_cap)) as cap_no_outcome
    from work.outcomes;

    select fyear, count(*) as union_n,
           sum(candidate_bve) as bve_candidates,
           sum(nmiss(xrd_bve,capx_bve,size,lev)=0 and bve_ps_p>0 and
               missing(eps_t_raw)) as bve_missing_current_eps,
           sum(base_bve) as broad_bve_n,
           sum(base_bve=1 and imp_bve=0) as broad_bve_observed,
           sum(base_bve=1 and imp_bve=1) as broad_bve_imputed,
           sum(candidate_bve=1 and missing(y_bve)) as bve_no_outcome,
           sum(candidate_bve=1 and date_order ne 1) as bve_bad_date_order,
           sum(candidate_bve=1 and future_source_missing=1) as bve_source_future_missing,
           sum(candidate_bve=1 and future_construct_missing=1) as bve_future_conv_miss,
           sum(candidate_bve=1 and not missing(xad_bve)) as bve_full_candidates,
           sum(fit_bve) as full_bve_n,
           sum(fit_bve=1 and imp_bve=0) as full_bve_observed,
           sum(fit_bve=1 and imp_bve=1) as full_bve_imputed,
           sum(candidate_price) as price_candidates,
           sum(nmiss(xrd_price,capx_price,size,lev)=0 and price_ps_p>0 and
               missing(eps_t_raw)) as price_missing_current_eps,
           sum(base_price) as broad_price_n,
           sum(base_price=1 and imp_price=0) as broad_price_observed,
           sum(base_price=1 and imp_price=1) as broad_price_imputed,
           sum(candidate_price=1 and missing(y_price)) as price_no_outcome,
           sum(candidate_price=1 and date_order ne 1) as price_bad_date_order,
           sum(candidate_price=1 and future_source_missing=1) as price_source_future_missing,
           sum(candidate_price=1 and future_construct_missing=1) as price_future_conv_miss,
           sum(candidate_price=1 and not missing(xad_price)) as price_full_candidates,
           sum(fit_price) as full_price_n,
           sum(fit_price=1 and imp_price=0) as full_price_observed,
           sum(fit_price=1 and imp_price=1) as full_price_imputed,
           sum(candidate_cap) as cap_full_candidates,
           sum(candidate_cap=1 and gross_source_missing=1) as cap_source_future_missing,
           sum(candidate_cap=1 and gross_construct_missing=1) as cap_future_conv_miss,
           sum(fit_cap) as full_cap_n,
           sum(fit_cap=1 and imp_cap=0) as full_cap_observed,
           sum(fit_cap=1 and imp_cap=1) as full_cap_imputed,
           sum(candidate_cap=1 and missing(y_cap)) as cap_no_outcome
    from work.outcomes
    group by fyear
    order by fyear;
quit;

proc means data=work.outcomes n mean std min p25 p50 p75 max;
    where fit_bve=1;
    class fyear;
    var y_bve xrd_bve capx_bve xad_bve size lev caprd_bve ppent_bve;
run;

proc means data=work.outcomes n mean std min p25 p50 p75 max;
    where fit_price=1;
    class fyear;
    var y_price xrd_price capx_price xad_price size lev;
run;

proc means data=work.outcomes n mean std min p25 p50 p75 max;
    where fit_cap=1;
    class fyear;
    var y_cap caprd_bve ppent_bve xad_cap size lev;
run;

data out.main;
    set work.final;
run;

proc sql;
    select count(*) as final_rows,
           count(distinct gvkey) as final_firms,
           min(fyear) as first_fit_year,
           max(fyear) as last_fit_year
    from out.main;
quit;

proc sort data=out.main out=work.key_check;
    by gvkey fyear;
run;

proc sql;
    create table work.final_dups as
    select gvkey, fyear, count(*) as n_rows
    from work.key_check
    group by gvkey, fyear
    having count(*) > 1;
    select count(*) as duplicate_final_keys from work.final_dups;
quit;
