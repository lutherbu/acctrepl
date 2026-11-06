options errorabend nocenter pagesize=80 linesize=160 msglevel=i;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname compco "/storage/sas/base/comp/d_na/company" access=readonly;
libname secr "/storage/sas/base/comp/d_na/security" access=readonly;
libname fxsrc "/storage/sas/base/comp/d_global/currency" access=readonly;
libname out "data/main";

/* Standardized annual Compustat rows; one prior year is retained for lags. */
data work.annual;
    set comp.funda(keep=gvkey datadate fyear indfmt consol popsrc datafmt
        txpd txr pi at csho seq txfed txfo txt txdi txs txo curcd curncd
        fic sich conm cusip prcc_f pddur hiid iid
        where=(fyear >= 1987 and fyear <= 2014 and indfmt='INDL'
            and consol='C' and popsrc='D' and datafmt='STD'));
    format datadate date9.;
run;

/* Standardized quarter price rows; exact prior annual DATADATE is used. */
data work.qprice;
    set comp.fundq(keep=gvkey datadate indfmt consol popsrc datafmt
        prccq curcdq hiid iid
        where=(datadate >= '01JAN1986'd and datadate <= '31DEC2014'd
            and indfmt='INDL' and consol='C' and popsrc='D' and datafmt='STD'));
    format datadate date9.;
run;

/* Dated security prices identify the currency of the historical primary issue. */
data work.secm;
    set secr.sec_mthprc(keep=gvkey iid datadate curcdm prccm
        where=(datadate >= '01JAN1986'd and datadate <= '31DEC2014'd));
    format datadate date9.;
run;

data work.compstatus;
    set compco.company(keep=gvkey stko);
run;

/* Effective-dated identifiers support a historical CUSIP screen by HIID. */
data work.idhist;
    set secr.sec_idhist(keep=gvkey iid item itemvalue efffrom effthru);
    if upcase(strip(item))='CUSIP';
    if efffrom <= '31DEC2015'd and (missing(effthru) or effthru >= '01JAN1986'd);
    format efffrom effthru date9.;
run;

/* Exact local Xpressfeed cross-rate rows; actual/carried provenance is retained. */
data work.fxd_raw;
    set fxsrc.g_exrt_dly(keep=datadate fromcurd tocurd exratd exrattpd
        where=(datadate >= '01JAN1986'd and datadate <= '31DEC2015'd));
    if upcase(strip(fromcurd))='GBP';
    curr=upcase(strip(tocurd));
    format datadate date9.;
run;

data work.fxm_raw;
    set fxsrc.g_exrt_mth(keep=datadate fromcurm tocurm exrat12m
        where=(datadate >= '01JAN1986'd and datadate <= '31DEC2015'd));
    if upcase(strip(fromcurm))='GBP';
    curr=upcase(strip(tocurm));
    format datadate date9.;
run;

proc sql;
    title "Source coverage and Compustat product filters";
    select count(*) as annual_rows,
           count(distinct gvkey) as annual_firms,
           min(fyear) as min_fyear,
           max(fyear) as max_fyear,
           min(datadate) format=date9. as min_datadate,
           max(datadate) format=date9. as max_datadate,
           sum(case when year(datadate) ne fyear then 1 else 0 end) as date_fyear_mismatch
    from work.annual;
    select fyear, count(*) as rows,
           sum(case when missing(curcd) then 1 else 0 end) as curcd_missing,
           sum(case when upcase(strip(fic))='USA' then 1 else 0 end) as fic_usa,
           sum(case when missing(txr) then 1 else 0 end) as txr_missing,
           sum(case when missing(txpd) then 1 else 0 end) as txpd_missing,
           sum(case when missing(pi) then 1 else 0 end) as pi_missing
    from work.annual
    group by fyear
    order by fyear;
    select count(*) as duplicate_funda_fy_keys,
           coalesce(sum(n-1),0) as extra_funda_rows
    from (select gvkey, fyear, count(*) as n
          from work.annual group by gvkey, fyear having count(*) > 1) as d;
    select count(*) as duplicate_funda_date_keys,
           coalesce(sum(n-1),0) as extra_funda_date_rows
    from (select gvkey, datadate, count(*) as n
          from work.annual group by gvkey, datadate having count(*) > 1) as d;
    select count(*) as duplicate_fundq_date_keys,
           coalesce(sum(n-1),0) as extra_fundq_rows
    from (select gvkey, datadate, count(*) as n
          from work.qprice group by gvkey, datadate having count(*) > 1) as d;
    select count(*) as duplicate_company_keys,
           coalesce(sum(n-1),0) as extra_company_rows
    from (select gvkey, count(*) as n
          from work.compstatus group by gvkey having count(*) > 1) as d;
    select count(*) as duplicate_security_month_keys,
           coalesce(sum(n-1),0) as extra_security_month_rows
    from (select gvkey, iid, datadate, count(*) as n
          from work.secm group by gvkey, iid, datadate having count(*) > 1) as d;
    select count(*) as duplicate_cusip_range_keys,
           coalesce(sum(n-1),0) as extra_cusip_range_rows
    from (select gvkey, iid, efffrom, effthru, count(*) as n
          from work.idhist group by gvkey, iid, efffrom, effthru having count(*) > 1) as d;
quit;

title "Annual Compustat values and reporting currencies";
proc freq data=work.annual;
    tables indfmt consol popsrc datafmt fic curcd / missing;
run;
proc means data=work.annual n nmiss min p1 p50 p99 max;
    var txpd txr pi at csho seq txfed txfo txt txdi txs txo prcc_f;
run;

proc sql;
    title "Daily Xpressfeed rate keys and observed values";
    select count(*) as daily_rate_rows,
           sum(case when missing(exratd) then 1 else 0 end) as missing_rate,
           sum(case when not missing(exratd) and exratd <= 0 then 1 else 0 end) as nonpositive_rate,
           sum(case when upcase(strip(tocurd))='USD' then 1 else 0 end) as usd_leg_rows
    from work.fxd_raw;
    select count(*) as duplicate_daily_currency_keys,
           coalesce(sum(n-1),0) as extra_daily_rate_rows
    from (select datadate, curr, count(*) as n
          from work.fxd_raw group by datadate, curr having count(*) > 1) as d;
    select count(*) as monthly_rate_rows,
           sum(case when missing(exrat12m) then 1 else 0 end) as missing_rate,
           sum(case when not missing(exrat12m) and exrat12m <= 0 then 1 else 0 end) as nonpositive_rate,
           sum(case when upcase(strip(tocurm))='USD' then 1 else 0 end) as usd_leg_rows
    from work.fxm_raw;
    select count(*) as duplicate_monthly_currency_keys,
           coalesce(sum(n-1),0) as extra_monthly_rate_rows
    from (select datadate, curr, count(*) as n
          from work.fxm_raw group by datadate, curr having count(*) > 1) as d;
quit;
title "Daily rate currencies and actual/carried-forward provenance";
proc freq data=work.fxd_raw;
    tables fromcurd tocurd exrattpd / missing;
run;
title "Monthly rate currencies";
proc freq data=work.fxm_raw;
    tables fromcurm tocurm / missing;
run;
title "Historical security identifier item codes";
proc freq data=secr.sec_idhist;
    tables item / missing;
run;

/* Use only unique, positive, exact-date rates. No rate-type equality screen. */
data work.fxd_pos;
    set work.fxd_raw;
    if not missing(exratd) and exratd > 0;
run;
data work.fxm_pos;
    set work.fxm_raw;
    if not missing(exrat12m) and exrat12m > 0;
run;
proc sql;
    create table work.fxd_uk as
        select datadate, curr, count(*) as n
        from work.fxd_pos group by datadate, curr having count(*)=1;
    create table work.fxm_uk as
        select datadate, curr, count(*) as n
        from work.fxm_pos group by datadate, curr having count(*)=1;
    create table work.fxd_unique as
        select a.datadate, a.curr, a.exratd, a.exrattpd
        from work.fxd_pos as a inner join work.fxd_uk as b
          on a.datadate=b.datadate and a.curr=b.curr;
    create table work.fxm_unique as
        select a.datadate, a.curr, a.exrat12m
        from work.fxm_pos as a inner join work.fxm_uk as b
          on a.datadate=b.datadate and a.curr=b.curr;
    /* Ambiguous source keys are diagnosed above and excluded from joins. */
    create table work.annual_fy_uk as
        select gvkey, fyear, count(*) as n
        from work.annual group by gvkey, fyear having count(*)=1;
    create table work.annual_dt_uk as
        select gvkey, datadate, count(*) as n
        from work.annual group by gvkey, datadate having count(*)=1;
    create table work.annual_keyed as
        select a.* from work.annual as a
        inner join work.annual_fy_uk as f on a.gvkey=f.gvkey and a.fyear=f.fyear
        inner join work.annual_dt_uk as d on a.gvkey=d.gvkey and a.datadate=d.datadate;
    create table work.qprice_uk as
        select gvkey, datadate, count(*) as n
        from work.qprice group by gvkey, datadate having count(*)=1;
    create table work.qprice_keyed as
        select q.* from work.qprice as q
        inner join work.qprice_uk as k on q.gvkey=k.gvkey and q.datadate=k.datadate;
    create table work.secm_uk as
        select gvkey, iid, datadate, count(*) as n
        from work.secm group by gvkey, iid, datadate having count(*)=1;
    create table work.secm_keyed as
        select s.* from work.secm as s
        inner join work.secm_uk as k
          on s.gvkey=k.gvkey and s.iid=k.iid and s.datadate=k.datadate;
    create table work.company_uk as
        select gvkey, count(*) as n
        from work.compstatus group by gvkey having count(*)=1;
    create table work.compstatus_keyed as
        select c.* from work.compstatus as c
        inner join work.company_uk as k on c.gvkey=k.gvkey;
    create table work.hcusip_hit as
        select a.gvkey, a.fyear, a.datadate, a.hiid,
               h.itemvalue as hist_cusip, h.efffrom, h.effthru
        from work.annual_keyed as a
        inner join work.idhist as h
          on a.gvkey=h.gvkey and a.hiid=h.iid
         and not missing(h.efffrom) and h.efffrom <= a.datadate
         and (missing(h.effthru) or h.effthru >= a.datadate);
    create table work.hcusip_uk as
        select gvkey, datadate, count(*) as n
        from work.hcusip_hit group by gvkey, datadate having count(*)=1;
    create table work.hcusip_unique as
        select h.* from work.hcusip_hit as h
        inner join work.hcusip_uk as u on h.gvkey=u.gvkey and h.datadate=u.datadate;
    create table work.fxd_usd as
        select datadate, exratd as usd_rate, exrattpd as usd_type
        from work.fxd_unique where curr='USD';
    create table work.fxm_usd as
        select datadate, exrat12m as usd_rate
        from work.fxm_unique where curr='USD';
quit;

/* Translate one source currency to USD as USD-per-source using the GBP legs. */
proc sql;
    create table work.annual_fx as
        select a.*,
               d.exratd as dly_src_rate,
               d.exrattpd as dly_src_type,
               du.usd_rate as dly_usd_rate,
               du.usd_type as dly_usd_type,
               case when upcase(strip(a.curcd))='USD' then 1
                    when upcase(strip(a.curcd))='GBP' then du.usd_rate
                    when d.exratd > 0 and du.usd_rate > 0 then du.usd_rate/d.exratd
                    else . end as fx_d_usd,
               m.exrat12m as mth_src_rate,
               mu.usd_rate as mth_usd_rate,
               case when upcase(strip(a.curcd))='USD' then 1
                    when upcase(strip(a.curcd))='GBP' then mu.usd_rate
                    when m.exrat12m > 0 and mu.usd_rate > 0 then mu.usd_rate/m.exrat12m
                    else . end as fx_m_usd
        from work.annual_keyed as a
        left join work.fxd_unique as d
          on a.datadate=d.datadate and upcase(strip(a.curcd))=d.curr
        left join work.fxd_usd as du
          on a.datadate=du.datadate
        left join work.fxm_unique as m
          on a.datadate=m.datadate and upcase(strip(a.curcd))=m.curr
        left join work.fxm_usd as mu
          on a.datadate=mu.datadate;

    create table work.qpriced as
        select q.gvkey, q.datadate, q.prccq, q.curcdq, q.hiid,
               s.curcdm as price_curcd_raw,
               s.prccm as issue_prccm,
               s.iid as sec_iid
        from work.qprice_keyed as q
        left join work.secm_keyed as s
          on q.gvkey=s.gvkey and q.hiid=s.iid and q.datadate=s.datadate;

    create table work.qpriced2 as
        select q.*,
               case when not missing(q.prccq) and not missing(q.issue_prccm)
                         and abs(q.prccq-q.issue_prccm) <= 0.01 then 1
                    else 0 end as price_agree,
               abs(q.prccq-q.issue_prccm) as price_absdiff,
               case when abs(q.prccq) >= abs(q.issue_prccm) and abs(q.prccq) > 0
                         then abs(q.prccq-q.issue_prccm)/abs(q.prccq)
                    when abs(q.issue_prccm) > 0
                         then abs(q.prccq-q.issue_prccm)/abs(q.issue_prccm)
                    else . end as price_reldiff,
               case when not missing(q.prccq) and not missing(q.issue_prccm)
                         and abs(q.prccq-q.issue_prccm) <= 0.01 then q.price_curcd_raw
                    else '' end as price_curcd length=3
        from work.qpriced as q;

    create table work.qprice_fx as
        select q.*,
               d.exratd as price_rate,
               d.exrattpd as price_type,
               du.usd_rate as price_usd_rate,
               du.usd_type as price_usd_type,
               case when upcase(strip(q.price_curcd))='USD' then 1
                    when upcase(strip(q.price_curcd))='GBP' then du.usd_rate
                    when d.exratd > 0 and du.usd_rate > 0 then du.usd_rate/d.exratd
                    else . end as fx_price_usd
        from work.qpriced2 as q
        left join work.fxd_unique as d
          on q.datadate=d.datadate and upcase(strip(q.price_curcd))=d.curr
        left join work.fxd_usd as du
          on q.datadate=du.datadate;

    create table work.assembled as
        select c.gvkey, c.datadate, c.fyear,
               c.txpd, c.txr, c.pi, c.at, c.csho, c.seq,
               c.txfed, c.txfo, c.txt, c.txdi, c.txs, c.txo,
               c.curcd, c.curncd, c.fic, c.sich, c.conm, c.cusip, c.prcc_f,
               h.hist_cusip,
               case when not missing(h.hist_cusip) then 'DATED' else 'HEADER' end as cusip_route length=8,
               c.fx_d_usd as fxcur_d,
               c.fx_m_usd as fxcur_m,
               c.dly_src_type as cur_d_type,
               c.dly_usd_type as cur_usd_type,
               p.datadate as prev_date format=date9.,
               p.fyear as prev_fyear,
               p.txr as txr_prev,
               p.at as at_prev,
               p.csho as csho_prev,
               p.seq as seq_prev,
               p.curcd as curcd_prev,
               p.fx_d_usd as fxprev_d,
               p.fx_m_usd as fxprev_m,
               p.dly_src_type as prev_d_type,
               p.dly_usd_type as prev_usd_type,
               q.prccq as prccq_prev,
               q.curcdq as curcdq_prev,
               q.hiid as hiid_prev,
               q.price_curcd as price_curcd,
               q.issue_prccm as issue_prccm,
               q.price_agree as price_agree,
               q.price_absdiff as price_absdiff,
               q.price_reldiff as price_reldiff,
               q.fx_price_usd as fxprice_d,
               q.price_type as price_d_type,
               q.price_usd_type as price_usd_type,
               s.stko as stko_hdr
        from work.annual_fx as c
        left join work.annual_fx as p
          on c.gvkey=p.gvkey and p.fyear=c.fyear-1
        left join work.qprice_fx as q
          on p.gvkey=q.gvkey and p.datadate=q.datadate
        left join work.compstatus_keyed as s
          on c.gvkey=s.gvkey
        left join work.hcusip_unique as h
          on c.gvkey=h.gvkey and c.datadate=h.datadate
        where c.fyear >= 1988 and c.fyear <= 2014;
quit;

/* Construct CTE, delta and the beginning denominator while preserving missingness. */
data work.candidate;
    set work.assembled;
    length delta_route $10 denom_route $4;
    length name_route $6 cusip_value $32 cusip6 $6;
    length yyear 8 tau 8 cte 8 delta_native 8 delta_usd 8 delta 8;
    length price_to_beg 8 mva_calc 8 mva_native 8 mva_usd 8 dmva_raw 8;
    length flag_fic flag_sic flag_lp flag_trust flag_cusip flag_stko 8;
    length flag_cte flag_tx flag_at flag_currency flag_measure 8;
    yyear=fyear;
    tau=.35;
    if fyear >= 1988 and fyear <= 1992 then tau=.34;

    if not missing(txfed) and not missing(txfo) then cte=txfed+txfo;
    else if missing(txt) then cte=.;
    else cte=txt-sum(coalesce(txdi,0),coalesce(txs,0),coalesce(txo,0));

    flag_fic=(upcase(strip(fic))='USA');
    flag_sic=(sich ne 6798);
    flag_lp=1;
    flag_trust=1;
    flag_cusip=1;
    nm_up=upcase(strip(conm));
    name_route='HEADER';
    if lengthn(nm_up) >= 3 and substr(nm_up,lengthn(nm_up)-2,3)='-LP' then flag_lp=0;
    if index(nm_up,'TRUST') > 0 then flag_trust=0;
    if not missing(hist_cusip) then cusip_value=strip(hist_cusip);
    else cusip_value=strip(cusip);
    cusip6=substr(cusip_value,1,6);
    if substr(cusip6,6,1) in ('Y','Z') then flag_cusip=0;
    flag_stko=1;
    if stko_hdr in (1,2) then flag_stko=0;
    if stko_hdr=0 and missing(prcc_f) then flag_stko=0;
    flag_cte=(not missing(cte));
    flag_tx=(not missing(txpd) and not missing(txr) and not missing(txr_prev) and not missing(pi));
    flag_at=(not missing(at) and not missing(at_prev));

    /* Cross-year currency conversions; stable reporting currency stays native. */
    delta_native=.;
    delta_usd=.;
    delta=.;
    delta_route='MISSING';
    if not missing(curcd) and not missing(curcd_prev)
       and lengthn(strip(curcd))=3 and lengthn(strip(curcd_prev))=3
       and upcase(strip(curcd)) ne 'XXX' and upcase(strip(curcd_prev)) ne 'XXX'
       and flag_tx then do;
        delta_native=txpd-(txr-txr_prev)-tau*pi;
        if upcase(strip(curcd))=upcase(strip(curcd_prev)) then do;
            delta=delta_native;
            delta_route='NATIVE';
        end;
        else if not missing(fxcur_m) and not missing(fxcur_d)
             and not missing(fxprev_d) then do;
            delta_usd=txpd*fxcur_m-(txr*fxcur_d-txr_prev*fxprev_d)-tau*pi*fxcur_m;
            if not missing(delta_usd) then do;
                delta=delta_usd;
                delta_route='USD_CROSS';
            end;
        end;
    end;

    /* Price-to-statement conversion uses the exact beginning-date daily rates. */
    price_to_beg=.;
    if not missing(price_curcd) and not missing(curcd_prev) then do;
        if upcase(strip(price_curcd))=upcase(strip(curcd_prev)) then price_to_beg=1;
        else if not missing(fxprice_d) and not missing(fxprev_d) and fxprev_d>0 then
            price_to_beg=fxprice_d/fxprev_d;
    end;

    /* MVA is beginning AT plus beginning market equity less beginning SEQ. */
    mva_calc=.;
    if not missing(at_prev) and not missing(csho_prev) and not missing(seq_prev)
       and not missing(prccq_prev) and not missing(price_to_beg) then
        mva_calc=at_prev+(prccq_prev*price_to_beg*csho_prev-seq_prev);

    denom_route='MVA';
    if missing(mva_calc) then do;
        mva_native=at_prev;
        denom_route='BVA';
    end;
    else mva_native=mva_calc;

    /* If report currencies differ, translate all numerator/denominator amounts to USD. */
    mva_usd=.;
    if upcase(strip(curcd)) ne upcase(strip(curcd_prev)) then do;
        if denom_route='MVA' and not missing(fxprev_d) and not missing(fxprice_d)
            and not missing(at_prev) and not missing(csho_prev) and not missing(seq_prev)
            and not missing(prccq_prev) then
            mva_usd=at_prev*fxprev_d+(prccq_prev*fxprice_d*csho_prev-seq_prev*fxprev_d);
        else if denom_route='BVA' and not missing(at_prev) and not missing(fxprev_d) then
            mva_usd=at_prev*fxprev_d;
    end;
    else mva_usd=mva_native;

    if not missing(delta) and not missing(mva_native) and mva_native ne 0 then do;
        if delta_route='USD_CROSS' then do;
            if not missing(mva_usd) and mva_usd ne 0 then dmva_raw=delta/mva_usd;
        end;
        else dmva_raw=delta/mva_native;
    end;

    flag_currency=(not missing(delta) and not missing(mva_native)
        and not missing(dmva_raw));
    flag_measure=(flag_fic and flag_sic and flag_lp and flag_trust and flag_cusip
        and flag_stko and flag_cte and flag_tx and flag_at and flag_currency
        and not missing(dmva_raw) and not missing(mva_native) and mva_native ne 0);
run;

proc sql;
    title "Population, component availability, currency paths and measure construction";
    select count(*) as annual_candidate_rows from work.annual;
    select count(*) as unique_annual_rows from work.annual_keyed;
    select count(*) as quarterly_price_rows from work.qprice;
    select count(*) as unique_quarterly_price_rows from work.qprice_keyed;
    select count(*) as security_month_rows from work.secm;
    select count(*) as unique_security_month_rows from work.secm_keyed;
    select count(*) as company_status_rows from work.compstatus;
    select count(*) as unique_company_rows from work.compstatus_keyed;
    select count(*) as dated_cusip_hits from work.hcusip_hit;
    select count(*) as unique_dated_cusip_rows from work.hcusip_unique;
    select year(datadate) as quote_year, count(*) as qprice_rows,
           sum(price_agree) as price_agree_within_one_cent,
           sum(case when not missing(price_curcd) then 1 else 0 end) as verified_price_currencies,
           mean(price_absdiff) as mean_abs_price_diff,
           max(price_absdiff) as max_abs_price_diff,
           max(price_reldiff) as max_rel_price_diff
    from work.qpriced2
    group by calculated quote_year
    order by calculated quote_year;
    select year(datadate) as observation_date_year, count(*) as rows,
           sum(case when not missing(hist_cusip) then 1 else 0 end) as dated_cusip,
           sum(case when missing(hist_cusip) then 1 else 0 end) as header_cusip_fallback
    from work.assembled
    group by calculated observation_date_year
    order by calculated observation_date_year;
    select fyear,
           count(*) as rows,
           sum(flag_fic) as fic_usa,
           sum(flag_sic) as not_reit,
           sum(flag_lp) as not_lp,
           sum(flag_trust) as not_trust,
           sum(flag_cusip) as cusip_ok,
           sum(flag_stko) as stko_ok,
           sum(flag_cte) as cte_available,
           sum(flag_tx) as delta_inputs,
           sum(flag_at) as current_and_begin_at,
           sum(case when upcase(strip(curcd)) ne upcase(strip(curcd_prev))
                    and not missing(curcd) and not missing(curcd_prev) then 1 else 0 end) as mixed_history,
           sum(case when not missing(price_curcd) and not missing(curcd_prev)
                    and upcase(strip(price_curcd)) ne upcase(strip(curcd_prev)) then 1 else 0 end) as price_ccy_mismatch,
           sum(case when denom_route='MVA' then 1 else 0 end) as market_mva_available,
           sum(case when denom_route='BVA' then 1 else 0 end) as bva_fallback,
           sum(flag_measure) as common_eligible
    from work.candidate
    group by fyear order by fyear;
    select count(*) as source_candidate_rows,
           sum(flag_fic=1) as fic_usa,
           sum(flag_sic=1) as not_reit,
           sum(flag_lp=1) as not_lp,
           sum(flag_trust=1) as not_trust,
           sum(flag_cusip=1) as cusip_ok,
           sum(flag_stko=1) as stko_ok,
           sum(flag_cte=1) as cte_available,
           sum(flag_tx=1) as delta_inputs,
           sum(flag_at=1) as current_and_begin_at,
           sum(case when upcase(strip(curcd)) ne upcase(strip(curcd_prev))
                    and not missing(curcd) and not missing(curcd_prev) then 1 else 0 end) as mixed_history,
           sum(case when upcase(strip(curcd)) ne upcase(strip(curcd_prev))
                    and not missing(delta_route) and delta_route='USD_CROSS' then 1 else 0 end) as mixed_history_usd,
           sum(case when not missing(price_curcd) and not missing(curcd_prev)
                    and upcase(strip(price_curcd)) ne upcase(strip(curcd_prev)) then 1 else 0 end) as price_ccy_mismatch,
           sum(case when not missing(price_curcd) and not missing(curcd_prev)
                    and upcase(strip(price_curcd)) ne upcase(strip(curcd_prev))
                    and not missing(price_to_beg) then 1 else 0 end) as price_conversions,
           sum(case when denom_route='MVA' then 1 else 0 end) as market_mva_available,
           sum(case when denom_route='BVA' then 1 else 0 end) as bva_fallback,
           sum(case when flag_measure=1 then 1 else 0 end) as common_eligible,
           sum(case when flag_measure=1 and pi<0 then 1 else 0 end) as negative_pi,
           sum(case when flag_measure=1 and pi>0 then 1 else 0 end) as positive_pi,
           sum(case when flag_measure=1 and cte<0 then 1 else 0 end) as negative_cte,
           sum(case when flag_measure=1 and cte>0 then 1 else 0 end) as positive_cte
    from work.candidate;
    select curcd, curcd_prev, price_curcd, delta_route, denom_route,
           count(*) as rows, sum(flag_measure) as eligible
    from work.candidate
    group by curcd, curcd_prev, price_curcd, delta_route, denom_route
    order by curcd, curcd_prev, price_curcd;
quit;

/* Winsorize pooled one-year common sample before the firm-history rule. */
data work.base;
    set work.candidate;
    if flag_measure=1;
run;
proc univariate data=work.base noprint;
    var dmva_raw;
    output out=work.wcut pctlpts=1 99 pctlpre=cut_;
run;
title "Pooled percentile cutoffs before the five-observation firm rule";
proc print data=work.wcut noobs;
run;
data work.winsor;
    if _n_=1 then set work.wcut;
    set work.base;
    cut_low=cut_1;
    cut_high=cut_99;
    dmva1=dmva_raw;
    if dmva1 < cut_low then dmva1=cut_low;
    if dmva1 > cut_high then dmva1=cut_high;
    label dmva1='Winsorized delta/MVA1' dmva_raw='Unwinsorized delta/MVA1';
run;

proc sql;
    create table work.firm_n as
        select gvkey, count(*) as n_firm_obs
        from work.winsor group by gvkey;
    create table work.fitdata as
        select a.*, b.n_firm_obs
        from work.winsor as a inner join work.firm_n as b
          on a.gvkey=b.gvkey
        where b.n_firm_obs >= 5;
    title "Final analysis N by year and firm-history counts";
    select fyear, count(*) as n_firm_years,
           sum(case when pi<0 then 1 else 0 end) as negative_pi,
           sum(case when pi>0 then 1 else 0 end) as positive_pi,
           sum(case when cte<0 then 1 else 0 end) as negative_cte,
           sum(case when cte>0 then 1 else 0 end) as positive_cte,
           sum(case when delta_route='USD_CROSS' then 1 else 0 end) as usd_cross,
           sum(case when denom_route='BVA' then 1 else 0 end) as bva_fallback
    from work.fitdata group by fyear order by fyear;
    select count(*) as pooled_base_n,
           count(distinct gvkey) as pooled_base_firms,
           min(dmva1) as min_winsor_dmva,
           max(dmva1) as max_winsor_dmva,
           mean(dmva1) as mean_winsor_dmva,
           std(dmva1) as sd_winsor_dmva
    from work.fitdata;
quit;

/* Native analysis handoff; original character GVKEY is preserved. */
data out.analysis;
    set work.fitdata;
    gvkey_id=input(strip(gvkey),best32.);
    year=fyear;
    time=year-1988;
    label gvkey_id='Numeric Compustat firm identifier'
          year='Fiscal observation year'
          time='TIME: fiscal year minus 1988'
          dmva1='Winsorized delta/MVA1'
          cte='Current tax expense (availability/sign only)'
          pi='Pretax income (sign retained)';
    keep gvkey gvkey_id year time datadate prev_date dmva1 dmva_raw
         pi cte curcd curcd_prev price_curcd delta_route denom_route
         price_to_beg mva_native n_firm_obs cut_low cut_high;
    format datadate prev_date date9.;
run;

proc sql;
    title "Final handoff checks";
    select count(*) as handoff_rows,
           count(distinct gvkey) as handoff_firms,
           sum(case when missing(gvkey_id) then 1 else 0 end) as missing_numeric_id,
           min(year) as min_year,
           max(year) as max_year,
           min(time) as min_time,
           max(time) as max_time,
           sum(case when missing(dmva1) then 1 else 0 end) as missing_dv,
           sum(case when missing(time) then 1 else 0 end) as missing_time
    from out.analysis;
quit;
proc sort data=out.analysis out=work.checkkey;
    by gvkey_id year;
run;
proc sql;
    select count(*) as duplicate_handoff_keys,
           coalesce(sum(n-1),0) as extra_handoff_rows
    from (select gvkey_id, year, count(*) as n
          from work.checkkey group by gvkey_id, year having count(*) > 1) as d;
quit;
title;
