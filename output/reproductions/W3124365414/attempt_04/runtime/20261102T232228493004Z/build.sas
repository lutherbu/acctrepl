options errorabend nodate nonumber;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname fx "/storage/sas/base/comp/d_global/currency" access=readonly;
libname sec "/storage/sas/base/comp/d_na/security" access=readonly;
libname crspstk "/storage/sas/base/crsp/a_stock" access=readonly;
libname out "data";

/* Annual Compustat inputs. The first two years are construction history only. */
data work.raw_comp;
    set comp.funda(keep=gvkey iid hiid datadate fyear indfmt consol popsrc datafmt
                   sich curcd at oancf sale cogs invt ib prcc_f csho ceq xrd xad xsga
                   rect ppent lct dlc dltt
                   where=(fyear >= 1985 and fyear <= 2001 and indfmt='INDL' and
                          consol='C' and popsrc='D' and datafmt='STD'));
    if not missing(gvkey) and not missing(fyear);
run;

/* Resolve fiscal-year key duplicates explicitly, retaining the latest date. */
proc sql noprint;
    select count(*) into :dupkeys trimmed
    from (select gvkey, fyear, count(*) as n
          from work.raw_comp group by gvkey, fyear having calculated n > 1);
    select count(*) into :dupties trimmed
    from (select gvkey, fyear, datadate, count(*) as n
          from work.raw_comp group by gvkey, fyear, datadate having calculated n > 1);
    select count(*) into :nraw trimmed from work.raw_comp;
    select intnx('month', min(datadate), 0, 'b'),
           intnx('month', max(datadate), 0, 'e')
      into :price_start trimmed, :price_end trimmed
      from work.raw_comp;
quit;
%put NOTE: Compustat filtered rows=&nraw duplicate GVKEY-fiscal-year keys=&dupkeys same-date duplicate groups=&dupties.;
%if &dupties > 0 %then %do;
    data _null_;
        put "ERROR: Same-date GVKEY/fiscal-year duplicates require a source-specific selection rule.";
        abort cancel;
    run;
%end;

proc sort data=work.raw_comp out=work.raw_sorted;
    by gvkey fyear datadate;
run;
data work.raw_unique;
    set work.raw_sorted;
    by gvkey fyear datadate;
    if last.fyear;
run;

/* Xpressfeed cross-rate factors: annual flows use EXRAT12M. */
data work.fx_month_raw;
    set fx.g_exrt_mth(keep=datadate fromcurm tocurm exrat12m);
    if fromcurm='GBP';
run;
proc sql noprint;
    select count(*) into :fxmdups trimmed
    from (select datadate, tocurm, count(*) as n
          from work.fx_month_raw group by datadate, tocurm having calculated n > 1);
quit;
%if &fxmdups > 0 %then %do;
    data _null_;
        put "ERROR: Duplicate Xpressfeed monthly FX date/currency keys require review.";
        abort cancel;
    run;
%end;
proc sql;
    create table work.fx_month as
    select c.datadate, c.tocurm as fxcurr,
           c.exrat12m as rate12m_cur, u.exrat12m as rate12m_usd,
           case when c.tocurm='USD' then 1
                when c.exrat12m > 0 and u.exrat12m > 0 then u.exrat12m/c.exrat12m end as flowfac
    from work.fx_month_raw as c
    left join work.fx_month_raw as u
      on c.datadate=u.datadate and c.fromcurm=u.fromcurm and u.tocurm='USD';
quit;

/* Pair positive GBP-to-reporting and GBP-to-USD daily quotes on the exact
   source date. Preserve each EXRATTPD value as provenance; the code can be
   blank or differ across legs even when both dated currency quotes exist. */
data work.fx_day_raw;
    set fx.g_exrt_dly(keep=datadate fromcurd tocurd exratd exrattpd);
    if fromcurd='GBP' and tocurd in ('USD','CAD') and exratd > 0;
run;
proc sql noprint;
    select count(*) into :fxddups trimmed
    from (select datadate, tocurd, count(*) as n
          from work.fx_day_raw group by datadate, tocurd having calculated n > 1);
quit;
%if &fxddups > 0 %then %do;
    data _null_;
        put "ERROR: Duplicate Xpressfeed daily FX date/currency keys require review.";
        abort cancel;
    run;
%end;
proc sql;
    create table work.fx_day_pair as
    select c.datadate, c.tocurd as fxcurr,
           c.exrattpd as exrattpd_cur, u.exrattpd as exrattpd_usd,
           c.exratd as rate_cur, u.exratd as rate_usd,
           case when c.tocurd='USD' then 1
                when c.exratd > 0 and u.exratd > 0 then u.exratd/c.exratd end as bsfac,
           (not missing(c.exratd) and not missing(u.exratd)) as has_both_rates
    from work.fx_day_raw as c
    left join work.fx_day_raw as u
      on c.datadate=u.datadate and u.tocurd='USD';
quit;
data work.fx_day_best; set work.fx_day_pair; run;

/* Price route sources are retained at their documented issue/date grains.
   IID is kept below only to reproduce A3's route for route-impact checks. */
data work.month_desc;
    set sec.sec_mth(keep=gvkey iid datadate primiss
                    where=(datadate >= &price_start and datadate <= &price_end));
run;
data work.month_price;
    set sec.sec_mthprc(keep=gvkey iid datadate curcdm prccm
                       where=(datadate >= &price_start and datadate <= &price_end));
run;

/* Bounded preflight on actual non-header HIID rows and the exact catalog
   columns used below. Daily extraction is limited to one sampled GVKEY here;
   the full short-gap join follows after these fields/cardinalities pass. */
data work.price_pf_keys;
    set work.raw_unique;
    if fyear < 1986 or fyear > 2000 or missing(hiid) or strip(hiid)=strip(iid) then delete;
    pf_n+1;
    if pf_n > 100 then stop;
    monthdate=intnx('month',datadate,0,'e');
    keep gvkey iid hiid datadate fyear monthdate prcc_f;
run;
proc sql noprint;
    select max(gvkey) into :pfgvkey trimmed from work.price_pf_keys;
quit;
proc sql;
    create table work.price_pf_month as
    select k.gvkey,k.fyear,k.datadate,k.hiid,k.iid,k.prcc_f,
           hm.primiss as hiid_primiss,hp.prccm as hiid_prccm,hp.curcdm as hiid_curcdm
    from work.price_pf_keys as k
    left join work.month_desc as hm
      on k.gvkey=hm.gvkey and k.datadate=hm.datadate and strip(k.hiid)=strip(hm.iid)
    left join work.month_price as hp
      on k.gvkey=hp.gvkey and k.datadate=hp.datadate and strip(k.hiid)=strip(hp.iid);
    select count(*) as sampled_historical_keys,
           sum(not missing(hiid_primiss)) as sampled_dated_marker_matches,
           sum(not missing(hiid_prccm)) as sampled_same_issue_month_prices,
           sum(not missing(hiid_curcdm)) as sampled_month_currencies
    from work.price_pf_month;
quit;
proc sql;
    create table work.price_pf_p as
    select k.gvkey,k.fyear,k.datadate,k.monthdate,k.hiid,
           count(m.iid) as p_count,max(m.iid) as p_iid
    from work.price_pf_keys as k
    left join work.month_desc as m
      on k.gvkey=m.gvkey and k.datadate=m.datadate and m.primiss='P'
    group by k.gvkey,k.fyear,k.datadate,k.monthdate,k.hiid;
    create table work.price_pf_p_price as
    select p.*,m.prccm,m.curcdm
    from work.price_pf_p as p
    left join work.month_price as m
      on p.gvkey=m.gvkey and p.datadate=m.datadate and strip(p.p_iid)=strip(m.iid)
    where p.p_count=1;
    select count(*) as sampled_primary_key_groups,
           sum(p_count=1) as sampled_unique_primary_markers,
           sum(p_count>1) as sampled_multiple_primary_markers,
           sum(not missing(prccm)) as sampled_unique_primary_prices,
           sum(not missing(curcdm)) as sampled_unique_primary_curcd
    from work.price_pf_p_price;
quit;
%if %length(&pfgvkey) > 0 %then %do;
    data work.price_pf_daily_source;
        set sec.sec_dprc(keep=gvkey iid datadate curcdd prccd
                         where=(gvkey="&pfgvkey" and datadate >= &price_start-3 and
                                datadate <= &price_end));
    run;
    proc sql;
        create table work.price_pf_daily as
        select k.gvkey,k.fyear,k.datadate,k.hiid,d.datadate as quote_date,
               d.curcdd,d.prccd
        from work.price_pf_keys as k
        left join work.price_pf_daily_source as d
          on k.gvkey=d.gvkey and strip(k.hiid)=strip(d.iid)
         and d.datadate <= k.datadate and d.datadate >= k.datadate-3
        where k.gvkey="&pfgvkey";
        select count(distinct fyear) as sampled_daily_keys,
               sum(not missing(curcdd)) as sampled_daily_currency_matches,
               sum(not missing(prccd)) as sampled_daily_price_matches
        from work.price_pf_daily;
    quit;
%end;

proc sql noprint;
    select count(*) into :monthdescdups trimmed
    from (select gvkey,iid,datadate,count(*) as n from work.month_desc
          group by gvkey,iid,datadate having calculated n > 1);
    select count(*) into :monthpricedups trimmed
    from (select gvkey,iid,datadate,count(*) as n from work.month_price
          group by gvkey,iid,datadate having calculated n > 1);
quit;
%if &monthdescdups > 0 or &monthpricedups > 0 %then %do;
    data _null_;
        put "ERROR: Duplicate security monthly issue/date keys require review.";
        abort cancel;
    run;
%end;

/* Resolve each annual PRCC_F endpoint against its historical issue ID. A
   monthly price is same-date evidence only at fiscal month-end; exact daily
   price evidence is checked at the actual Funda DATADATE. */
data work.price_keys;
    set work.raw_unique(keep=gvkey iid hiid fyear datadate prcc_f);
    monthdate=intnx('month',datadate,0,'e');
run;
proc sql;
    create table work.price_p_count as
    select gvkey,datadate,count(*) as p_count,max(iid) as p_iid
    from work.month_desc
    where primiss='P'
    group by gvkey,datadate;
    create table work.price_p_unique as
    select * from work.price_p_count where p_count=1;
quit;

/* Distinct candidate lookups make one daily source join cover HIID, legacy
   IID, and a unique dated P issue when HIID is absent. Identifiers remain
   intact; the daily match allows only the nearest prior quote within 3 days. */
proc sql;
    create table work.daily_ids as
    select distinct gvkey,datadate,strip(iid) as price_iid length=21
    from work.price_keys where not missing(iid)
    union
    select distinct gvkey,datadate,strip(hiid) as price_iid length=21
    from work.price_keys where not missing(hiid)
    union
    select distinct k.gvkey,k.datadate,strip(p.p_iid) as price_iid length=21
    from work.price_keys as k inner join work.price_p_unique as p
      on k.gvkey=p.gvkey and k.datadate=p.datadate;
    create table work.daily_price_candidates as
    select k.gvkey,k.price_iid,k.datadate,d.datadate as quote_date,
           d.curcdd,d.prccd
    from work.daily_ids as k
    inner join sec.sec_dprc as d
      on k.gvkey=d.gvkey and strip(k.price_iid)=strip(d.iid)
     and d.datadate <= k.datadate and d.datadate >= k.datadate-3
    where d.datadate >= &price_start-3 and d.datadate <= &price_end;
quit;
proc sql noprint;
    select count(*) into :dailypricedups trimmed
    from (select gvkey,price_iid,quote_date,count(*) as n from work.daily_price_candidates
          group by gvkey,price_iid,quote_date having calculated n > 1);
quit;
%if &dailypricedups > 0 %then %do;
    data _null_;
        put "ERROR: Duplicate security daily issue/date keys require review.";
        abort cancel;
    run;
%end;
proc sort data=work.daily_price_candidates;
    by gvkey price_iid datadate descending quote_date;
run;
data work.daily_price_target;
    set work.daily_price_candidates;
    by gvkey price_iid datadate;
    if first.datadate;
    quote_gap=datadate-quote_date;
run;

/* A short daily quote lag is supported only when CRSP's observed market
   calendar has no session between the quote and the annual endpoint. */
data work.market_days;
    set crspstk.dsi(keep=date);
    where date >= &price_start-3 and date <= &price_end;
run;
data work.daily_price_checked;
    if _n_=1 then do;
        declare hash md(dataset:"work.market_days");
        md.defineKey("date");
        md.defineData("date");
        md.defineDone();
    end;
    set work.daily_price_target;
    market_sessions_gap=0;
    if not missing(quote_date) then do calendar_date=quote_date+1 to datadate;
        date=calendar_date;
        if md.find()=0 then market_sessions_gap+1;
    end;
    drop date calendar_date;
run;

proc sql;
    create table work.price_evidence as
    select k.gvkey,k.fyear,k.datadate,k.monthdate,k.iid,k.hiid,k.prcc_f,
           hm.primiss as hiid_primiss,
           hp.prccm as hiid_prccm,hp.curcdm as hiid_curcdm,
           hd.prccd as hiid_prccd,hd.curcdd as hiid_curcdd,
           hd.quote_date as hiid_quote_date,hd.quote_gap as hiid_quote_gap,
           hd.market_sessions_gap as hiid_market_sessions_gap,
           ps.p_count,pu.p_iid,pp.prccm as p_prccm,pp.curcdm as p_curcdm,
           pd.prccd as p_prccd,pd.curcdd as p_curcdd,
           pd.quote_date as p_quote_date,pd.quote_gap as p_quote_gap,
           pd.market_sessions_gap as p_market_sessions_gap,
           om.curcdm as old_month_curcd,od.curcdd as old_day_curcd,
           od.quote_gap as old_day_quote_gap
    from work.price_keys as k
    left join work.month_desc as hm
      on k.gvkey=hm.gvkey and k.datadate=hm.datadate and strip(k.hiid)=strip(hm.iid)
    left join work.month_price as hp
      on k.gvkey=hp.gvkey and k.datadate=hp.datadate and strip(k.hiid)=strip(hp.iid)
    left join work.daily_price_checked as hd
      on k.gvkey=hd.gvkey and k.datadate=hd.datadate and strip(k.hiid)=strip(hd.price_iid)
    left join work.price_p_count as ps
      on k.gvkey=ps.gvkey and k.datadate=ps.datadate
    left join work.price_p_unique as pu
      on k.gvkey=pu.gvkey and k.datadate=pu.datadate
    left join work.month_price as pp
      on pu.gvkey=pp.gvkey and pu.datadate=pp.datadate and strip(pu.p_iid)=strip(pp.iid)
    left join work.daily_price_checked as pd
      on pu.gvkey=pd.gvkey and k.datadate=pd.datadate and strip(pu.p_iid)=strip(pd.price_iid)
    left join work.month_price as om
      on k.gvkey=om.gvkey and k.monthdate=om.datadate and strip(k.iid)=strip(om.iid)
    left join work.daily_price_checked as od
      on k.gvkey=od.gvkey and k.datadate=od.datadate and strip(k.iid)=strip(od.price_iid);
quit;

data work.price_routes;
    set work.price_evidence;
    length price_curcd old_price_curcd p_iid $4 price_source old_price_source $1
           price_route $12 price_issue $21 price_selected_marker $2;
    price_quote_gap=.;
    price_date=.;
    price_abs_diff=.;
    format price_date yymmdd10.;
    price_market_sessions_gap=.;
    price_dated_p_count=p_count;
    hiid_month_ok=0; hiid_day_ok=0; p_month_ok=0; p_day_ok=0;
    if not missing(prcc_f) and not missing(hiid_prccm) then
        hiid_month_ok=(datadate=monthdate and abs(prcc_f-hiid_prccm) <= 0.00005);
    if not missing(prcc_f) and not missing(hiid_prccd) then
        hiid_day_ok=(abs(prcc_f-hiid_prccd) <= 0.000000005 and
                     (hiid_quote_gap=0 or
                      (hiid_quote_gap>=1 and hiid_quote_gap<=3 and
                       hiid_market_sessions_gap=0)));
    if not missing(prcc_f) and not missing(p_prccm) then
        p_month_ok=(datadate=monthdate and abs(prcc_f-p_prccm) <= 0.00005);
    if not missing(prcc_f) and not missing(p_prccd) then
        p_day_ok=(abs(prcc_f-p_prccd) <= 0.000000005 and
                  (p_quote_gap=0 or
                   (p_quote_gap>=1 and p_quote_gap<=3 and
                    p_market_sessions_gap=0)));
    price_currency_conflict=0;
    if datadate=monthdate and not missing(hiid_curcdm) and not missing(hiid_curcdd) and
       hiid_curcdm ne hiid_curcdd then price_currency_conflict=1;
    if datadate=monthdate and not missing(p_curcdm) and not missing(p_curcdd) and
       p_curcdm ne p_curcdd then price_currency_conflict=1;
    marker_conflict=0;
    if not missing(hiid) then do;
        if hiid_primiss='J' or (not missing(hiid_primiss) and hiid_primiss ne 'P') then marker_conflict=1;
    end;
    else if p_count > 1 then marker_conflict=1;
    route_conflict=(marker_conflict or price_currency_conflict);

    /* Reproduce A3's header-IID currency route solely for impact comparison. */
    if old_day_quote_gap=0 and not missing(old_day_curcd) then do;
        old_price_curcd=old_day_curcd;
        old_price_source='D';
    end;
    else if not missing(old_month_curcd) then do;
        old_price_curcd=old_month_curcd;
        old_price_source='M';
    end;

    if route_conflict=0 and not missing(hiid) then do;
        if hiid_primiss='P' then do;
            if hiid_month_ok and not missing(hiid_curcdm) then do;
                price_curcd=hiid_curcdm; price_source='M'; price_route='HIID_P_M'; price_issue=hiid;
                price_date=datadate;
                price_abs_diff=abs(prcc_f-hiid_prccm);
            end;
            else if hiid_day_ok and not missing(hiid_curcdd) then do;
                price_curcd=hiid_curcdd; price_source='D'; price_route='HIID_P_D';
                price_issue=hiid; price_quote_gap=hiid_quote_gap;
                price_market_sessions_gap=hiid_market_sessions_gap;
                price_date=hiid_quote_date;
                price_abs_diff=abs(prcc_f-hiid_prccd);
            end;
        end;
        else if missing(hiid_primiss) then do;
            if hiid_month_ok and not missing(hiid_curcdm) then do;
                price_curcd=hiid_curcdm; price_source='M'; price_route='HIID_N_M'; price_issue=hiid;
                price_date=datadate;
                price_abs_diff=abs(prcc_f-hiid_prccm);
            end;
            else if hiid_day_ok and not missing(hiid_curcdd) then do;
                price_curcd=hiid_curcdd; price_source='D'; price_route='HIID_N_D';
                price_issue=hiid; price_quote_gap=hiid_quote_gap;
                price_market_sessions_gap=hiid_market_sessions_gap;
                price_date=hiid_quote_date;
                price_abs_diff=abs(prcc_f-hiid_prccd);
            end;
        end;
    end;
    else if route_conflict=0 and missing(hiid) and p_count=1 then do;
        if p_month_ok and not missing(p_curcdm) then do;
            price_curcd=p_curcdm; price_source='M'; price_route='DATEDP_M'; price_issue=p_iid;
            price_date=datadate;
            price_abs_diff=abs(prcc_f-p_prccm);
        end;
        else if p_day_ok and not missing(p_curcdd) then do;
            price_curcd=p_curcdd; price_source='D'; price_route='DATEDP_D';
            price_issue=p_iid; price_quote_gap=p_quote_gap;
            price_market_sessions_gap=p_market_sessions_gap;
            price_date=p_quote_date;
            price_abs_diff=abs(prcc_f-p_prccd);
        end;
    end;
    if substr(price_route,1,6)='DATEDP' then price_selected_marker='P';
    else price_selected_marker=hiid_primiss;
run;

/* Record the observed quote-to-annual-price precision before applying the
   source-format tolerances used by the eligibility route. */
data work.price_precision;
    set work.price_evidence;
    hiid_mth_absdiff=.; hiid_day_absdiff=.; p_mth_absdiff=.; p_day_absdiff=.;
    if not missing(prcc_f) and not missing(hiid_prccm) then hiid_mth_absdiff=abs(prcc_f-hiid_prccm);
    if not missing(prcc_f) and not missing(hiid_prccd) then hiid_day_absdiff=abs(prcc_f-hiid_prccd);
    if not missing(prcc_f) and not missing(p_prccm) then p_mth_absdiff=abs(prcc_f-p_prccm);
    if not missing(prcc_f) and not missing(p_prccd) then p_day_absdiff=abs(prcc_f-p_prccd);
    format hiid_mth_absdiff hiid_day_absdiff p_mth_absdiff p_day_absdiff e32.16;
run;
proc means data=work.price_precision n min mean median p95 max;
    var hiid_mth_absdiff hiid_day_absdiff p_mth_absdiff p_day_absdiff;
run;
proc sql;
    select sum(not missing(hiid_mth_absdiff)) as hiid_monthly_price_pairs,
           sum(hiid_mth_absdiff=0) as hiid_monthly_exact_numeric,
           sum(not missing(hiid_mth_absdiff) and hiid_mth_absdiff>0 and hiid_mth_absdiff<=0.00005) as hiid_monthly_within_precision,
           sum(not missing(hiid_mth_absdiff) and hiid_mth_absdiff>0.00005) as hiid_monthly_over_precision,
           sum(not missing(hiid_day_absdiff)) as hiid_daily_price_pairs,
           sum(hiid_day_absdiff=0) as hiid_daily_exact_numeric,
           sum(not missing(hiid_day_absdiff) and hiid_day_absdiff>0 and hiid_day_absdiff<=0.000000005) as hiid_daily_within_precision,
           sum(not missing(hiid_day_absdiff) and hiid_day_absdiff>0.000000005) as hiid_daily_over_precision
    from work.price_precision
    where 1986 <= fyear and fyear <= 2000 and not missing(prcc_f);
    select hiid_quote_gap as quote_gap,
           hiid_market_sessions_gap as market_sessions_gap,
           weekday(datadate) as endpoint_weekday,
           count(*) as hiid_candidate_keys,
           sum(not missing(prcc_f) and not missing(hiid_prccd) and
               abs(prcc_f-hiid_prccd)<=0.000000005) as price_agreeing_keys
    from work.price_evidence
    where 1986 <= fyear and fyear <= 2000 and not missing(hiid_quote_gap)
    group by hiid_quote_gap,hiid_market_sessions_gap,weekday(datadate)
    order by hiid_quote_gap,hiid_market_sessions_gap,weekday(datadate);
quit;
data work.weekend_session_conflicts;
    set work.price_evidence;
    if fyear>=1986 and fyear<=2000 and weekday(datadate) in (1,7) and
       hiid_quote_gap in (1,2) and hiid_market_sessions_gap > 0 then do;
        if not missing(prcc_f) and not missing(hiid_prccd) then do;
            if abs(prcc_f-hiid_prccd)<=0.000000005 then output;
        end;
    end;
run;
proc print data=work.weekend_session_conflicts noobs;
    var gvkey fyear datadate hiid hiid_primiss hiid_quote_date hiid_quote_gap
        hiid_market_sessions_gap prcc_f hiid_prccd hiid_curcdd;
    format datadate hiid_quote_date yymmdd10.;
    title "Price-agreeing weekend candidate blocked by an intervening CRSP session";
run;
title;
proc sql;
    select r.price_route,r.price_source,count(*) as weekend_candidates,
           sum(not missing(r.price_curcd)) as supported_via_route
    from work.weekend_session_conflicts as c
    inner join work.price_routes as r
      on c.gvkey=r.gvkey and c.datadate=r.datadate and c.fyear=r.fyear
    group by r.price_route,r.price_source
    order by r.price_route,r.price_source;
quit;

proc sql;
    select count(*) as annual_price_keys,
           sum(not missing(prcc_f)) as observed_prccf,
           sum(not missing(hiid) and strip(hiid) ne strip(iid)) as hiid_header_differences,
           sum(not missing(hiid_primiss) and hiid_primiss='P') as hiid_dated_primary,
           sum(not missing(hiid_primiss) and hiid_primiss='J') as hiid_explicit_secondary,
           sum(p_count > 1) as multiple_dated_primary_markers,
           sum(marker_conflict) as explicit_or_ambiguous_conflicts,
           sum(price_currency_conflict) as same_date_currency_conflicts,
           sum(not missing(price_curcd)) as supported_price_currency,
           sum(price_source='D' and price_quote_gap=0) as exact_daily_price_support,
           sum(price_source='D' and price_quote_gap between 1 and 3) as closure_price_support,
           sum(not missing(old_price_curcd) and missing(price_curcd)) as old_route_lost,
           sum(missing(old_price_curcd) and not missing(price_curcd)) as new_route_recovered,
           sum(not missing(old_price_curcd) and not missing(price_curcd) and
               old_price_curcd ne price_curcd) as currency_changed
    from work.price_routes
    where 1986 <= fyear and fyear <= 2000 and not missing(prcc_f);
    select price_route,price_source,price_quote_gap,price_market_sessions_gap,
           price_dated_p_count,hiid_primiss,price_curcd,count(*) as source_keys
    from work.price_routes
    where 1986 <= fyear and fyear <= 2000 and not missing(prcc_f)
    group by price_route,price_source,price_quote_gap,price_market_sessions_gap,
             price_dated_p_count,hiid_primiss,price_curcd
    order by price_route,price_source,price_quote_gap,price_market_sessions_gap,
             price_dated_p_count,hiid_primiss,price_curcd;
    select fyear as endpoint_fyear,count(*) as source_keys,
           sum(not missing(price_curcd)) as supported_keys,
           sum(price_source='D' and price_quote_gap=0) as exact_daily_keys,
           sum(price_source='D' and price_quote_gap between 1 and 3) as closure_close_keys,
           sum(marker_conflict) as conflict_keys,
           sum(price_currency_conflict) as price_currency_conflicts,
           sum(not missing(old_price_curcd) and not missing(price_curcd) and
               old_price_curcd ne price_curcd) as currency_changed
    from work.price_routes
    where 1986 <= fyear and fyear <= 2000 and not missing(prcc_f)
    group by fyear order by fyear;
quit;

/* Keyed fiscal-year joins preserve gaps. Exchange rates are joined at each
   source row's reporting period; currency is never carried across years. */
proc sql;
    create table work.panel as
    select t.gvkey, t.iid, t.hiid, t.datadate, t.fyear, t.sich, t.curcd,
           t.at, t.oancf, t.sale, t.cogs, t.invt, t.ib, t.prcc_f, t.csho,
           t.ceq, t.xrd, t.xad, t.xsga, t.rect, t.ppent, t.lct, t.dlc, t.dltt,
           t1.iid as iid_lag1, t1.hiid as hiid_lag1,
           t1.datadate as datadate_lag1, t1.curcd as curcd_lag1,
           t1.at as at_lag1, t1.sale as sale_lag1, t1.invt as invt_lag1,
           t1.rect as rect_lag1, t1.prcc_f as prcc_f_lag1,
           t1.csho as csho_lag1, t1.ceq as ceq_lag1,
           t1.ppent as ppent_lag1, t1.lct as lct_lag1,
           t1.dlc as dlc_lag1, t1.dltt as dltt_lag1,
           t2.datadate as datadate_lag2, t2.curcd as curcd_lag2,
           t2.sale as sale_lag2,
           m0.flowfac as flowfac_t, m1.flowfac as flowfac_lag1,
           m2.flowfac as flowfac_lag2,
           d0.bsfac as bsfac_t, d1.bsfac as bsfac_lag1,
           d0.exrattpd_cur as bstype_cur_t, d0.exrattpd_usd as bstype_usd_t,
           d1.exrattpd_cur as bstype_cur_lag1, d1.exrattpd_usd as bstype_usd_lag1,
           pr0.price_curcd, pr1.price_curcd as price_curcd_lag1,
           pr0.price_source as price_currency_source length=1,
           pr1.price_source as price_currency_source_lag1 length=1,
           pr0.price_route, pr1.price_route as price_route_lag1,
           pr0.price_issue, pr1.price_issue as price_issue_lag1,
           pr0.price_date, pr1.price_date as price_date_lag1,
           pr0.price_quote_gap, pr1.price_quote_gap as price_quote_gap_lag1,
           pr0.price_market_sessions_gap,
           pr1.price_market_sessions_gap as price_market_sessions_gap_lag1,
           pr0.price_dated_p_count,
           pr1.price_dated_p_count as price_dated_p_count_lag1,
           pr0.hiid_primiss as price_marker,
           pr1.hiid_primiss as price_marker_lag1,
           pr0.price_selected_marker,
           pr1.price_selected_marker as price_selected_marker_lag1,
           pr0.marker_conflict, pr1.marker_conflict as marker_conflict_lag1,
           pr0.old_price_curcd, pr1.old_price_curcd as old_price_curcd_lag1,
           pr0.old_price_source, pr1.old_price_source as old_price_source_lag1,
           pf0.bsfac as pricefac_t, pf1.bsfac as pricefac_lag1,
           pf0.exrattpd_cur as price_type_cur_t, pf0.exrattpd_usd as price_type_usd_t,
           pf1.exrattpd_cur as price_type_cur_lag1, pf1.exrattpd_usd as price_type_usd_lag1
    from work.raw_unique as t
    left join work.raw_unique as t1
      on t.gvkey=t1.gvkey and t1.fyear=t.fyear-1
    left join work.raw_unique as t2
      on t.gvkey=t2.gvkey and t2.fyear=t.fyear-2
    left join work.fx_month as m0
      on intnx('month',t.datadate,0,'e')=m0.datadate and t.curcd=m0.fxcurr
    left join work.fx_month as m1
      on intnx('month',t1.datadate,0,'e')=m1.datadate and t1.curcd=m1.fxcurr
    left join work.fx_month as m2
      on intnx('month',t2.datadate,0,'e')=m2.datadate and t2.curcd=m2.fxcurr
    left join work.fx_day_best as d0
      on t.datadate=d0.datadate and t.curcd=d0.fxcurr
    left join work.fx_day_best as d1
      on t1.datadate=d1.datadate and t1.curcd=d1.fxcurr
    left join work.price_routes as pr0
      on t.gvkey=pr0.gvkey and t.fyear=pr0.fyear
    left join work.price_routes as pr1
      on t1.gvkey=pr1.gvkey and t1.fyear=pr1.fyear
    left join work.fx_day_best as pf0
      on pr0.price_date=pf0.datadate and pr0.price_curcd=pf0.fxcurr
    left join work.fx_day_best as pf1
      on pr1.price_date=pf1.datadate and pr1.price_curcd=pf1.fxcurr;
quit;

/* Convert amount inputs to USD at their own source rows. The provider formula
   is (reported amount / GBP-to-reported rate) * GBP-to-USD rate. Ratios can be
   computed natively where exact source currencies cancel. */
data work.constructed;
    set work.panel;
    length analysis_period excluded_sic appx_complete 8;
    if missing(sich) then sic2=.;
    else sic2=floor(sich/100);
    analysis_period=(1987 <= fyear and fyear <= 2001);
    excluded_sic=(not missing(sich) and
                  ((4400 <= sich and sich <= 5000) or
                   (6000 <= sich and sich <= 6500)));

    if curcd='USD' then do; flowfac_t=1; bsfac_t=1; end;
    if curcd_lag1='USD' then do; flowfac_lag1=1; bsfac_lag1=1; end;
    if curcd_lag2='USD' then flowfac_lag2=1;
    if price_curcd='USD' then pricefac_t=1;
    if price_curcd_lag1='USD' then pricefac_lag1=1;

    if not missing(at) and not missing(bsfac_t) then at_usd=at*bsfac_t;
    if not missing(at_lag1) and not missing(bsfac_lag1) then at_lag1_usd=at_lag1*bsfac_lag1;
    if not missing(ib) and not missing(flowfac_t) then ib_usd=ib*flowfac_t;
    if not missing(oancf) and not missing(flowfac_t) then oancf_usd=oancf*flowfac_t;
    if not missing(sale) and not missing(flowfac_t) then sale_usd=sale*flowfac_t;
    if not missing(sale_lag1) and not missing(flowfac_lag1) then sale_lag1_usd=sale_lag1*flowfac_lag1;
    if not missing(sale_lag2) and not missing(flowfac_lag2) then sale_lag2_usd=sale_lag2*flowfac_lag2;
    if not missing(cogs) and not missing(flowfac_t) then cogs_usd=cogs*flowfac_t;
    if not missing(invt) and not missing(bsfac_t) then invt_usd=invt*bsfac_t;
    if not missing(invt_lag1) and not missing(bsfac_lag1) then invt_lag1_usd=invt_lag1*bsfac_lag1;
    if not missing(xrd) and not missing(flowfac_t) then xrd_usd=xrd*flowfac_t;
    if not missing(xad) and not missing(flowfac_t) then xad_usd=xad*flowfac_t;
    if not missing(xsga) and not missing(flowfac_t) then xsga_usd=xsga*flowfac_t;
    if not missing(rect) and not missing(bsfac_t) then rect_usd=rect*bsfac_t;
    if not missing(rect_lag1) and not missing(bsfac_lag1) then rect_lag1_usd=rect_lag1*bsfac_lag1;
    if not missing(ppent_lag1) and not missing(bsfac_lag1) then ppent_lag1_usd=ppent_lag1*bsfac_lag1;
    if not missing(lct_lag1) and not missing(bsfac_lag1) then lct_lag1_usd=lct_lag1*bsfac_lag1;
    if not missing(dlc_lag1) and not missing(bsfac_lag1) then dlc_lag1_usd=dlc_lag1*bsfac_lag1;
    if not missing(dltt_lag1) and not missing(bsfac_lag1) then dltt_lag1_usd=dltt_lag1*bsfac_lag1;
    if not missing(dlc) and not missing(bsfac_t) then dlc_usd=dlc*bsfac_t;
    if not missing(dltt) and not missing(bsfac_t) then dltt_usd=dltt*bsfac_t;
    if not missing(ceq) and not missing(bsfac_t) then ceq_usd=ceq*bsfac_t;
    if not missing(ceq_lag1) and not missing(bsfac_lag1) then ceq_lag1_usd=ceq_lag1*bsfac_lag1;

    if not missing(prcc_f) and not missing(csho) and not missing(price_curcd) then
        mve_current_native=prcc_f*csho;
    if not missing(mve_current_native) and not missing(pricefac_t) then
        mve_current_usd=mve_current_native*pricefac_t;
    if not missing(prcc_f_lag1) and not missing(csho_lag1) and not missing(price_curcd_lag1) then
        mve_lag_native=prcc_f_lag1*csho_lag1;
    if not missing(mve_lag_native) and not missing(pricefac_lag1) then
        mve_lag_usd=mve_lag_native*pricefac_lag1;
    if mve_lag_usd > 0 then size_raw=log(mve_lag_usd);
    if not missing(mve_lag_native) and not missing(ceq_lag1) and ceq_lag1 ne 0 and
       not missing(price_curcd_lag1) and not missing(curcd_lag1) and price_curcd_lag1=curcd_lag1 then
        mtb_raw=mve_lag_native/ceq_lag1;
    else if mve_lag_usd > 0 and not missing(ceq_lag1_usd) and not missing(ceq_lag1) and ceq_lag1 ne 0 then
        mtb_raw=mve_lag_usd/ceq_lag1_usd;
    if not missing(mve_current_usd) and not missing(ceq) and ceq ne 0 and
       not missing(price_curcd) and not missing(curcd) and price_curcd=curcd then
        mtb_current=mve_current_native/ceq;
    else if mve_current_usd > 0 and not missing(ceq_usd) and not missing(ceq) and ceq ne 0 then
        mtb_current=mve_current_usd/ceq_usd;

    if at_lag1_usd > 0 then inv_at=1/at_lag1_usd;
    if at_lag1 > 0 and not missing(sale) and not missing(curcd) and not missing(curcd_lag1) and curcd=curcd_lag1 then sale_at=sale/at_lag1;
    else if at_lag1_usd > 0 and not missing(sale_usd) then sale_at=sale_usd/at_lag1_usd;
    if at_lag1 > 0 and not missing(sale_lag1) and not missing(curcd_lag1) then sale_lag_at=sale_lag1/at_lag1;
    if not missing(sale) and not missing(sale_lag1) then do;
        if at_lag1 > 0 and not missing(curcd) and not missing(curcd_lag1) and curcd=curcd_lag1 then
            dsale_at=(sale-sale_lag1)/at_lag1;
        else if not missing(sale_usd) and not missing(sale_lag1_usd) and at_lag1_usd > 0 then
            dsale_at=(sale_usd-sale_lag1_usd)/at_lag1_usd;
    end;
    if not missing(sale_lag1) and not missing(sale_lag2) then do;
        if not missing(curcd_lag1) and not missing(curcd_lag2) and curcd_lag1=curcd_lag2 and at_lag1 > 0 then
            dsale_lag1_at=(sale_lag1-sale_lag2)/at_lag1;
        else if not missing(sale_lag1_usd) and not missing(sale_lag2_usd) and at_lag1_usd > 0 then
            dsale_lag1_at=(sale_lag1_usd-sale_lag2_usd)/at_lag1_usd;
    end;
    if at_lag1 > 0 and not missing(oancf) and not missing(curcd) and not missing(curcd_lag1) and curcd=curcd_lag1 then cfo_at=oancf/at_lag1;
    else if at_lag1_usd > 0 and not missing(oancf_usd) then cfo_at=oancf_usd/at_lag1_usd;
    if at_lag1 > 0 and not missing(ib) and not missing(curcd) and not missing(curcd_lag1) and curcd=curcd_lag1 then ni_raw=ib/at_lag1;
    else if at_lag1_usd > 0 and not missing(ib_usd) then ni_raw=ib_usd/at_lag1_usd;
    if not missing(ib_usd) and not missing(oancf_usd) then accruals_usd=ib_usd-oancf_usd;
    if at_lag1 > 0 and not missing(ib) and not missing(oancf) and not missing(curcd) and not missing(curcd_lag1) and curcd=curcd_lag1 then
        accruals_at=(ib-oancf)/at_lag1;
    else if at_lag1_usd > 0 and not missing(accruals_usd) then accruals_at=accruals_usd/at_lag1_usd;

    if cmiss(cogs,invt,invt_lag1)=0 then do;
        if at_lag1 > 0 and not missing(curcd) and not missing(curcd_lag1) and curcd=curcd_lag1 then
            prod_at=(cogs+invt-invt_lag1)/at_lag1;
        else if not missing(cogs_usd) and not missing(invt_usd) and
                not missing(invt_lag1_usd) and at_lag1_usd > 0 then
            prod_at=(cogs_usd+invt_usd-invt_lag1_usd)/at_lag1_usd;
    end;
    if not missing(xsga) then do;
        disexp_raw=xsga+coalesce(xrd,0)+coalesce(xad,0);
        if not missing(curcd) and not missing(curcd_lag1) and curcd=curcd_lag1 and at_lag1 > 0 then disexp_at=disexp_raw/at_lag1;
        else if not missing(xsga_usd) and at_lag1_usd > 0 and
                (missing(xrd) or not missing(xrd_usd)) and
                (missing(xad) or not missing(xad_usd)) then do;
            disexp_usd=xsga_usd;
            if not missing(xrd) then disexp_usd=disexp_usd+xrd_usd;
            if not missing(xad) then disexp_usd=disexp_usd+xad_usd;
            disexp_at=disexp_usd/at_lag1_usd;
        end;
    end;

    if not missing(ib) and at_lag1 > 0 and not missing(ni_raw) then
        suspect_ni=(0 <= ni_raw and ni_raw < 0.005);

    /* Appendix A ratios use exact same-period currency where it cancels. */
    if at_lag1 > 0 and not missing(curcd_lag1) and cmiss(lct_lag1,dlc_lag1)=0 then cl_begin=(lct_lag1-dlc_lag1)/at_lag1;
    if at_lag1 > 0 and not missing(curcd_lag1) and cmiss(invt_lag1,rect_lag1)=0 then invrec_begin=(invt_lag1+rect_lag1)/at_lag1;
    if not missing(cogs) and not missing(invt) and not missing(invt_lag1) then do;
        if not missing(curcd) and not missing(curcd_lag1) and curcd=curcd_lag1 then do;
            if (invt+invt_lag1)/2 ne 0 then invturn=cogs/((invt+invt_lag1)/2);
        end;
        else if not missing(cogs_usd) and not missing(invt_usd) and not missing(invt_lag1_usd) then do;
            if (invt_usd+invt_lag1_usd)/2 ne 0 then invturn=cogs_usd/((invt_usd+invt_lag1_usd)/2);
        end;
    end;
    if not missing(sale) and not missing(rect) and not missing(rect_lag1) then do;
        if not missing(curcd) and not missing(curcd_lag1) and curcd=curcd_lag1 then do;
            if (rect+rect_lag1)/2 ne 0 then rectturn=sale/((rect+rect_lag1)/2);
        end;
        else if not missing(sale_usd) and not missing(rect_usd) and not missing(rect_lag1_usd) then do;
            if (rect_usd+rect_lag1_usd)/2 ne 0 then rectturn=sale_usd/((rect_usd+rect_lag1_usd)/2);
        end;
    end;
    if cmiss(dltt,dlc,dltt_lag1,dlc_lag1)=0 then
        hasdebt=(dltt>0 or dlc>0 or dltt_lag1>0 or dlc_lag1>0);

    appx_complete=0;
    if analysis_period and not missing(sic2) and not excluded_sic and
       cmiss(gvkey,at,at_lag1,ib,oancf,cogs,invt,invt_lag1,xsga,sale,
             sale_lag1,sale_lag2,rect,rect_lag1,ppent_lag1,lct_lag1,
             dlc,dlc_lag1,dltt,dltt_lag1,cfo_at,inv_at,accruals_at,prod_at,
             disexp_at,ni_raw,suspect_ni,size_raw,mtb_raw,cl_begin,
             invrec_begin,invturn,rectturn,hasdebt)=0 and
       at > 0 and at_lag1_usd > 0 and mve_lag_usd > 0 and ceq_lag1 ne 0 then appx_complete=1;

    /* Diagnostic only: isolate the CFO-related fields and Eq. (4) t-2 window. */
    appx_complete_no_cfo=0;
    if analysis_period and not missing(sic2) and not excluded_sic and
       cmiss(gvkey,at,at_lag1,ib,cogs,invt,invt_lag1,xsga,sale,
             sale_lag1,sale_lag2,rect,rect_lag1,ppent_lag1,lct_lag1,
             dlc,dlc_lag1,dltt,dltt_lag1,inv_at,prod_at,disexp_at,ni_raw,
             suspect_ni,size_raw,mtb_raw,cl_begin,invrec_begin,invturn,
             rectturn,hasdebt)=0 and
       at > 0 and at_lag1_usd > 0 and mve_lag_usd > 0 and ceq_lag1 ne 0 then appx_complete_no_cfo=1;

    appx_complete_no_t2=0;
    if analysis_period and not missing(sic2) and not excluded_sic and
       cmiss(gvkey,at,at_lag1,ib,oancf,cogs,invt,invt_lag1,xsga,sale,
             sale_lag1,rect,rect_lag1,ppent_lag1,lct_lag1,
             dlc,dlc_lag1,dltt,dltt_lag1,cfo_at,inv_at,accruals_at,prod_at,
             disexp_at,ni_raw,suspect_ni,size_raw,mtb_raw,cl_begin,
             invrec_begin,invturn,rectturn,hasdebt)=0 and
       at > 0 and at_lag1_usd > 0 and mve_lag_usd > 0 and ceq_lag1 ne 0 then appx_complete_no_t2=1;
run;

proc sql;
    select count(*) as source_unique_rows,
           min(datadate) as first_actual_report_date format=yymmdd10.,
           max(datadate) as last_actual_report_date format=yymmdd10.,
           count(at_lag1) as rows_with_lag1_assets,
           count(sale_lag2) as rows_with_lag2_sales
    from work.constructed;
    select sum(analysis_period) as main_period_rows,
           sum(analysis_period and not missing(sic2) and not excluded_sic) as after_sic_screen,
           sum(appx_complete) as complete_appendix_rows,
           sum(analysis_period and curcd='CAD') as current_cad_rows,
           sum(analysis_period and not missing(curcd) and not missing(curcd_lag1) and curcd_lag1 ne curcd) as curcd_diff_t_t1,
           sum(analysis_period and not missing(curcd_lag1) and not missing(curcd_lag2) and curcd_lag1 ne curcd_lag2) as curcd_diff_t1_t2,
           sum(analysis_period and missing(price_curcd_lag1) and prcc_f_lag1>0) as missing_lag1_price_currency,
           sum(analysis_period and not missing(price_curcd_lag1) and prcc_f_lag1>0) as supported_lag1_price_currency,
           sum(analysis_period and not missing(old_price_curcd_lag1) and prcc_f_lag1>0) as old_lag1_price_currency,
           sum(analysis_period and not missing(price_curcd_lag1) and not missing(old_price_curcd_lag1) and
               price_curcd_lag1 ne old_price_curcd_lag1) as lag1_currency_changed,
           sum(analysis_period and marker_conflict_lag1) as lag1_price_marker_conflicts,
           sum(analysis_period and price_currency_source_lag1='D') as lag1_daily_price_currency,
           sum(analysis_period and price_currency_source_lag1='M') as lag1_mth_price_fb,
           sum(analysis_period and not missing(price_curcd_lag1) and not missing(curcd_lag1) and price_curcd_lag1 ne curcd_lag1) as pricecurcd_diff_t1,
           sum(analysis_period and curcd='CAD' and missing(bsfac_t)) as cad_no_day_t,
           sum(analysis_period and curcd_lag1='CAD' and missing(bsfac_lag1)) as cad_no_day_t1
    from work.constructed;
    select fyear as fiscal_year,
           count(*) as format_screen_rows,
           sum(not missing(sic2) and not excluded_sic) as after_sic_rows,
           sum(appx_complete_no_cfo) as complete_no_cfo,
           sum(appx_complete_no_t2) as complete_no_t2,
           sum(appx_complete) as complete_with_t2,
           sum(analysis_period and curcd='CAD') as current_cad_rows,
           sum(analysis_period and curcd='CAD' and missing(flowfac_t)) as current_cad_missing_flow_rate,
           sum(analysis_period and curcd='CAD' and missing(bsfac_t)) as cad_no_day_t,
           sum(analysis_period and missing(price_curcd_lag1) and prcc_f_lag1>0) as missing_lag1_price_currency,
           sum(analysis_period and not missing(price_curcd_lag1) and prcc_f_lag1>0) as supported_lag1_price_currency,
           sum(analysis_period and not missing(old_price_curcd_lag1) and prcc_f_lag1>0) as old_lag1_price_currency,
           sum(analysis_period and not missing(price_curcd_lag1) and not missing(old_price_curcd_lag1) and
               price_curcd_lag1 ne old_price_curcd_lag1) as lag1_currency_changed
    from work.constructed
    where analysis_period=1
    group by fyear
    order by fyear;
    select price_route_lag1,price_currency_source_lag1,price_marker_lag1,
           old_price_curcd_lag1,price_curcd_lag1,count(*) as rows
    from work.constructed
    where analysis_period=1 and prcc_f_lag1>0
    group by price_route_lag1,price_currency_source_lag1,price_marker_lag1,
             old_price_curcd_lag1,price_curcd_lag1
    order by price_route_lag1,price_currency_source_lag1,price_marker_lag1,
             old_price_curcd_lag1,price_curcd_lag1;
    select curcd,curcd_lag1,curcd_lag2,count(*) as rows
    from work.constructed
    where analysis_period=1 and not missing(curcd) and not missing(curcd_lag1) and not missing(curcd_lag2)
    group by curcd,curcd_lag1,curcd_lag2
    order by curcd,curcd_lag1,curcd_lag2;
quit;

/* Supporting industry-year OLS fits use the paper's >=15-observation rule. */
data work.support;
    set work.constructed;
    if appx_complete;
run;

proc sql;
    create table work.cfo_groups as
    select sic2, fyear, count(*) as fit_n
    from work.support
    where cmiss(cfo_at,inv_at,sale_at,dsale_at)=0
    group by sic2,fyear
    having calculated fit_n >= 15;
    create table work.disexp_groups as
    select sic2, fyear, count(*) as fit_n
    from work.support
    where cmiss(disexp_at,inv_at,sale_lag_at)=0
    group by sic2,fyear
    having calculated fit_n >= 15;
    create table work.prod_groups as
    select sic2, fyear, count(*) as fit_n
    from work.support
    where cmiss(prod_at,inv_at,sale_at,dsale_at,dsale_lag1_at)=0
    group by sic2,fyear
    having calculated fit_n >= 15;
    select 'CFO' as model, count(*) as industry_year_groups, sum(fit_n) as fitted_rows from work.cfo_groups;
    select 'DISEXP' as model, count(*) as industry_year_groups, sum(fit_n) as fitted_rows from work.disexp_groups;
    select 'PROD' as model, count(*) as industry_year_groups, sum(fit_n) as fitted_rows from work.prod_groups;
    select fyear as fiscal_year, count(*) as retained_groups, sum(fit_n) as retained_rows
    from work.cfo_groups group by fyear order by fyear;
quit;
proc means data=work.price_routes n min mean median max;
    class price_route;
    var price_abs_diff;
    where fyear>=1986 and fyear<=2000 and not missing(prcc_f) and
          not missing(price_curcd);
run;
proc sql;
    select price_route,price_source,count(*) as accepted_routes,
           sum(price_abs_diff=0) as numeric_exact,
           sum(not missing(price_abs_diff) and price_abs_diff>0) as nonzero_difference,
           sum(not missing(price_abs_diff) and price_abs_diff>0 and
               ((price_source='M' and price_abs_diff<=0.00005) or
                (price_source='D' and price_abs_diff<=0.000000005))) as nonzero_within_source_precision,
           sum(not missing(price_abs_diff) and
               ((price_source='M' and price_abs_diff>0.00005) or
                (price_source='D' and price_abs_diff>0.000000005))) as over_source_precision
    from work.price_routes
    where fyear>=1986 and fyear<=2000 and not missing(prcc_f) and
          not missing(price_curcd)
    group by price_route,price_source
    order by price_route,price_source;
quit;

proc sql;
    create table work.cfo_reg as
    select s.* from work.support as s inner join work.cfo_groups as g
      on s.sic2=g.sic2 and s.fyear=g.fyear
    where cmiss(s.cfo_at,s.inv_at,s.sale_at,s.dsale_at)=0;
    create table work.disexp_reg as
    select s.* from work.support as s inner join work.disexp_groups as g
      on s.sic2=g.sic2 and s.fyear=g.fyear
    where cmiss(s.disexp_at,s.inv_at,s.sale_lag_at)=0;
    create table work.prod_reg as
    select s.* from work.support as s inner join work.prod_groups as g
      on s.sic2=g.sic2 and s.fyear=g.fyear
    where cmiss(s.prod_at,s.inv_at,s.sale_at,s.dsale_at,s.dsale_lag1_at)=0;
quit;

proc sort data=work.cfo_reg; by sic2 fyear; run;
proc reg data=work.cfo_reg noprint;
    by sic2 fyear;
    model cfo_at=inv_at sale_at dsale_at;
    output out=work.cfo_pred p=pred_cfo;
quit;

proc sort data=work.disexp_reg; by sic2 fyear; run;
proc reg data=work.disexp_reg noprint;
    by sic2 fyear;
    model disexp_at=inv_at sale_lag_at;
    output out=work.disexp_pred p=pred_disexp;
quit;

proc sort data=work.prod_reg; by sic2 fyear; run;
proc reg data=work.prod_reg noprint;
    by sic2 fyear;
    model prod_at=inv_at sale_at dsale_at dsale_lag1_at;
    output out=work.prod_pred p=pred_prod;
quit;

proc sort data=work.support; by gvkey fyear; run;
proc sort data=work.cfo_pred(keep=gvkey fyear pred_cfo); by gvkey fyear; run;
proc sort data=work.disexp_pred(keep=gvkey fyear pred_disexp); by gvkey fyear; run;
proc sort data=work.prod_pred(keep=gvkey fyear pred_prod); by gvkey fyear; run;

data work.final_premean;
    merge work.support(in=in_support)
          work.cfo_pred(keep=gvkey fyear pred_cfo)
          work.disexp_pred(keep=gvkey fyear pred_disexp)
          work.prod_pred(keep=gvkey fyear pred_prod);
    by gvkey fyear;
    if in_support;
    if not missing(pred_cfo) then ab_cfo=cfo_at-pred_cfo;
    if not missing(pred_disexp) then ab_disexp=disexp_at-pred_disexp;
    if not missing(pred_prod) then ab_prod=prod_at-pred_prod;
    if missing(ab_cfo) or missing(ab_disexp) or missing(ab_prod) then delete;
    if at_lag1_usd > 0 then accruals_at=accruals_usd/at_lag1_usd;
run;

/* Table 1-style descriptive checks on the actual common Table 4 analysis sample. */
proc means data=work.final_premean n mean median maxdec=4;
    class suspect_ni;
    var mve_current_usd mtb_current at_usd sale_usd ib_usd oancf_usd accruals_usd
        sale_at ni_raw cfo_at accruals_at prod_at disexp_at invturn rectturn;
run;

/* Appendix A defines these three explanatory variables as industry-year deviations. */
proc summary data=work.final_premean nway;
    class sic2 fyear;
    var size_raw mtb_raw ni_raw;
    output out=work.iy_means(drop=_type_ _freq_)
           mean=size_mean mtb_mean ni_mean;
run;
proc sort data=work.final_premean; by sic2 fyear; run;
proc sort data=work.iy_means; by sic2 fyear; run;
data out.ram_main_firm_years(label="Roychowdhury (2006) Table 4 baseline sample");
    merge work.final_premean(in=eligible) work.iy_means;
    by sic2 fyear;
    if eligible;
    size=size_raw-size_mean;
    mtb=mtb_raw-mtb_mean;
    netincome=ni_raw-ni_mean;
    label ab_cfo="Abnormal CFO"
          ab_disexp="Abnormal discretionary expenses"
          ab_prod="Abnormal production costs"
          size="SIZE"
          mtb="MTB"
          netincome="Net income"
          suspect_ni="SUSPECT_NI"
          curcd="Source currency at t"
          curcd_lag1="Source currency at t-1"
          curcd_lag2="Source currency at t-2"
          iid_lag1="Header primary issue at t-1"
          hiid_lag1="Historic primary issue at t-1"
          price_curcd_lag1="Verified PRCC_F currency at t-1"
          price_route_lag1="Price route at t-1"
          price_issue_lag1="Selected price issue at t-1"
          price_date_lag1="Date of matched historical price currency quote at t-1"
          price_marker_lag1="HIID dated primary marker at t-1"
          price_selected_marker_lag1="Selected dated marker at t-1"
          price_quote_gap_lag1="Days from supporting daily quote to t-1 date"
          price_market_sessions_gap_lag1="Intervening CRSP sessions after daily quote"
          price_dated_p_count_lag1="Dated primary issue count at t-1"
          old_price_curcd_lag1="A3 header-IID price currency at t-1";
    keep gvkey fyear sic2 ab_cfo ab_disexp ab_prod size mtb netincome suspect_ni
         curcd curcd_lag1 curcd_lag2 iid_lag1 hiid_lag1
         price_curcd_lag1 price_currency_source_lag1 price_route_lag1 price_issue_lag1
         price_date_lag1 price_marker_lag1 price_selected_marker_lag1 price_quote_gap_lag1 old_price_curcd_lag1
         price_market_sessions_gap_lag1 price_dated_p_count_lag1
         bstype_cur_lag1 bstype_usd_lag1 price_type_cur_lag1 price_type_usd_lag1;
run;

proc sql;
    select count(*) as final_firm_years,
           count(distinct gvkey) as final_firms,
           count(distinct sic2) as final_two_digit_industries,
           min(fyear) as first_year,
           max(fyear) as last_year,
           min(datadate) as first_report_date format=yymmdd10.,
           max(datadate) as last_report_date format=yymmdd10.,
           sum(not missing(curcd) and not missing(curcd_lag1) and curcd ne curcd_lag1) as final_t_t1_currency_changes,
           sum(not missing(curcd_lag1) and not missing(curcd_lag2) and curcd_lag1 ne curcd_lag2) as final_t1_t2_currency_changes
    from work.final_premean;
    select price_route_lag1,price_currency_source_lag1,price_marker_lag1,
           price_quote_gap_lag1,price_market_sessions_gap_lag1,
           price_dated_p_count_lag1,old_price_curcd_lag1,price_curcd_lag1,
           count(*) as final_analysis_rows
    from out.ram_main_firm_years
    group by price_route_lag1,price_currency_source_lag1,price_marker_lag1,
             price_quote_gap_lag1,price_market_sessions_gap_lag1,
             price_dated_p_count_lag1,old_price_curcd_lag1,price_curcd_lag1
    order by price_route_lag1,price_quote_gap_lag1,price_market_sessions_gap_lag1,
             price_dated_p_count_lag1,price_marker_lag1,old_price_curcd_lag1,price_curcd_lag1;
quit;
proc freq data=out.ram_main_firm_years;
    tables fyear curcd*curcd_lag1 curcd_lag1*curcd_lag2 / nocum nopercent missing;
run;
