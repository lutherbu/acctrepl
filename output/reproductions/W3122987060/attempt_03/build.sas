options errorabend nodate nonumber;

libname comp '/storage/sas/base/comp/d_na' access=readonly;
libname sec '/storage/sas/base/comp/d_na/security' access=readonly;
libname fx '/storage/sas/base/comp/d_global/currency' access=readonly;
libname out 'data/main';

/* Exact current fields checked against the catalog and the paper's item numbers. */
data raw;
    set comp.funda(
        keep=gvkey datadate fyear indfmt consol popsrc datafmt
             curcd
             at ib oancf xidoc recch invch apalch rect invt ap xacc
             xdp am dp xdepl sale prcc_f sich
        where=(fyear between 1980 and 1997
               and indfmt='INDL' and consol='C' and datafmt='STD' and popsrc='D')
    );
run;

proc sql;
    title 'COMP.FUNDA filtered source coverage';
    select count(*) as source_rows, min(fyear) as first_fyear,
           max(fyear) as last_fyear, min(datadate) as first_datadate format=yymmdd10.,
           max(datadate) as last_datadate format=yymmdd10.
    from raw;

    title 'Source rows by fiscal year';
    select fyear, count(*) as source_rows
    from raw
    group by fyear
    order by fyear;

    create table duplicate_keys as
    select gvkey, fyear, count(*) as rows_per_key
    from raw
    group by gvkey, fyear
    having calculated rows_per_key > 1;

    create table duplicate_diagnostics as
    select d.gvkey, d.fyear, d.rows_per_key,
           count(distinct r.datadate) as distinct_dates,
           min(r.datadate) as first_date format=yymmdd10.,
           max(r.datadate) as last_date format=yymmdd10.,
           count(distinct r.at) as distinct_at, sum(missing(r.at)) as miss_at,
           count(distinct r.ib) as distinct_ib, sum(missing(r.ib)) as miss_ib,
           count(distinct r.oancf) as distinct_oancf, sum(missing(r.oancf)) as miss_oancf,
           count(distinct r.xidoc) as distinct_xidoc, sum(missing(r.xidoc)) as miss_xidoc,
           count(distinct r.recch) as distinct_recch, sum(missing(r.recch)) as miss_recch,
           count(distinct r.invch) as distinct_invch, sum(missing(r.invch)) as miss_invch,
           count(distinct r.apalch) as distinct_apalch, sum(missing(r.apalch)) as miss_apalch,
           count(distinct r.rect) as distinct_rect, sum(missing(r.rect)) as miss_rect,
           count(distinct r.invt) as distinct_invt, sum(missing(r.invt)) as miss_invt,
           count(distinct r.ap) as distinct_ap, sum(missing(r.ap)) as miss_ap,
           count(distinct r.xacc) as distinct_xacc, sum(missing(r.xacc)) as miss_xacc,
           count(distinct r.xdp) as distinct_xdp, sum(missing(r.xdp)) as miss_xdp,
           count(distinct r.am) as distinct_am, sum(missing(r.am)) as miss_am,
           count(distinct r.dp) as distinct_dp, sum(missing(r.dp)) as miss_dp,
           count(distinct r.xdepl) as distinct_xdepl, sum(missing(r.xdepl)) as miss_xdepl,
           count(distinct r.sale) as distinct_sale, sum(missing(r.sale)) as miss_sale,
           count(distinct r.prcc_f) as distinct_prcc_f, sum(missing(r.prcc_f)) as miss_prcc_f,
           count(distinct r.sich) as distinct_sich, sum(missing(r.sich)) as miss_sich,
           count(distinct r.curcd) as distinct_curcd, sum(missing(r.curcd)) as miss_curcd
    from duplicate_keys as d
    inner join raw as r on d.gvkey=r.gvkey and d.fyear=r.fyear
    group by d.gvkey, d.fyear, d.rows_per_key;
quit;

data duplicate_diagnostics;
    set duplicate_diagnostics;
    array ndist[19] distinct_at distinct_ib distinct_oancf distinct_xidoc
        distinct_recch distinct_invch distinct_apalch distinct_rect distinct_invt
        distinct_ap distinct_xacc distinct_xdp distinct_am distinct_dp distinct_xdepl
        distinct_sale distinct_prcc_f distinct_sich distinct_curcd;
    array nmissing[19] miss_at miss_ib miss_oancf miss_xidoc miss_recch miss_invch
        miss_apalch miss_rect miss_invt miss_ap miss_xacc miss_xdp miss_am miss_dp
        miss_xdepl miss_sale miss_prcc_f miss_sich miss_curcd;
    mismatch=0;
    do i=1 to dim(ndist);
        if ndist[i] + (nmissing[i] > 0) > 1 then do;
            mismatch=1;
            put 'DUPLICATE_FIELD_CONFLICT ' gvkey= fyear= i= ndist[i]= nmissing[i]=;
        end;
    end;
    put 'DUPLICATE_KEY_DIAGNOSTIC ' gvkey= fyear= rows_per_key=
        distinct_dates= first_date= last_date= mismatch=;
run;
proc sql noprint;
    select count(*) into :inconsistent_duplicate_groups trimmed
    from duplicate_diagnostics where mismatch=1;
quit;
%put NOTE: Duplicate (gvkey,fyear) groups with differing inputs = &inconsistent_duplicate_groups.;

/* Choose the most complete record; use the latest date only to break ties. */
data raw_ranked;
    set raw;
    nmiss_inputs=cmiss(at, ib, oancf, xidoc, recch, invch, apalch,
                       rect, invt, ap, xacc, xdp, am, dp, xdepl,
                       sale, prcc_f, sich, curcd);
run;
proc sort data=raw_ranked out=raw_sorted;
    by gvkey fyear nmiss_inputs descending datadate;
run;
data raw_unique;
    set raw_sorted;
    by gvkey fyear;
    if first.fyear;
run;

proc sql noprint;
    select count(*) into :unique_source_rows trimmed from raw_unique;
quit;
%put NOTE: Source rows after coherent annual-key selection = &unique_source_rows.;

proc sql;
    title 'Observed OANCF rows with missing XIDOC; CF remains unavailable';
    select count(*) as n_oancf_observed,
           sum(missing(xidoc)) as n_missing_xidoc
    from raw_unique
    where not missing(oancf);
quit;

proc sql noprint;
    select min(datadate), max(datadate)
      into :raw_date_min trimmed, :raw_date_max trimmed
    from raw_unique;
quit;
%put NOTE: Actual DATADATE source horizon = &raw_date_min. to &raw_date_max.;

/* Annual sales are flows: use positive, unique GBP cross-rates with EXRAT12M. */
data fx_mth_raw;
    set fx.g_exrt_mth(keep=datadate fromcurm tocurm exrat12m);
    if fromcurm='GBP' and not missing(tocurm) and exrat12m > 0;
run;
proc sql;
    create table fx_mth_rate as
    select datadate, tocurm, count(*) as n_quote,
           max(exrat12m) as fxrate
    from fx_mth_raw
    group by datadate, tocurm;

    create table sale_fx_candidates as
    select c.gvkey, c.fyear, c.datadate, c.curcd, c.sale,
           s.datadate as fxdate, s.fxrate as source_rate,
           u.fxrate as usd_rate
    from raw_unique as c
    inner join fx_mth_rate as s
      on c.curcd=s.tocurm and s.datadate <= c.datadate
     and s.datadate >= c.datadate-31 and s.n_quote=1 and s.fxrate > 0
    inner join fx_mth_rate as u
      on s.datadate=u.datadate and u.tocurm='USD'
     and u.n_quote=1 and u.fxrate > 0
    where c.curcd not in ('USD','GBP');

    create table sale_fx_dates as
    select gvkey, fyear, datadate, curcd, max(fxdate) as fxdate
    from sale_fx_candidates
    group by gvkey, fyear, datadate, curcd;

    create table sale_fx_non_gbp as
    select c.gvkey, c.fyear, c.datadate, c.curcd, c.sale, c.fxdate,
           c.source_rate, c.usd_rate
    from sale_fx_candidates as c
    inner join sale_fx_dates as d
      on c.gvkey=d.gvkey and c.fyear=d.fyear and c.datadate=d.datadate
     and c.curcd=d.curcd and c.fxdate=d.fxdate;

    create table sale_fx_gbp_candidates as
    select c.gvkey, c.fyear, c.datadate, c.curcd, c.sale,
           u.datadate as fxdate, 1 as source_rate,
           u.fxrate as usd_rate
    from raw_unique as c
    inner join fx_mth_rate as u
      on u.tocurm='USD' and u.datadate <= c.datadate
     and u.datadate >= c.datadate-31 and u.n_quote=1 and u.fxrate > 0
    where c.curcd='GBP';

    create table sale_fx_gbp_dates as
    select gvkey, fyear, datadate, curcd, max(fxdate) as fxdate
    from sale_fx_gbp_candidates
    group by gvkey, fyear, datadate, curcd;

    create table sale_fx_gbp as
    select c.gvkey, c.fyear, c.datadate, c.curcd, c.sale, c.fxdate,
           c.source_rate, c.usd_rate
    from sale_fx_gbp_candidates as c
    inner join sale_fx_gbp_dates as d
      on c.gvkey=d.gvkey and c.fyear=d.fyear and c.datadate=d.datadate
     and c.curcd=d.curcd and c.fxdate=d.fxdate;
quit;

data sale_fx_quoted;
    set sale_fx_non_gbp sale_fx_gbp;
    sale_fx_factor=usd_rate/source_rate;
run;

/* Primary issue markers are monthly; identify the latest dated marker before each actual period end. */
data sec_mth_window;
    set sec.sec_mth(keep=gvkey iid datadate primiss
                    where=(datadate between &raw_date_min.-31 and &raw_date_max.));
run;
proc freq data=sec_mth_window;
    title 'Compustat SEC_MTH primary/joiner markers in the actual source horizon';
    tables primiss / missing;
run;

proc sql;
    create table primary_month as
    select r.gvkey, r.fyear, r.datadate, max(s.datadate) as marker_date
    from raw_unique as r
    left join sec_mth_window as s
      on r.gvkey=s.gvkey and s.datadate <= r.datadate
     and s.datadate >= r.datadate-31
    group by r.gvkey, r.fyear, r.datadate;

    create table primary_candidates as
    select m.gvkey, m.fyear, m.datadate, m.marker_date, s.iid,
           count(*) as marker_rows
    from primary_month as m
    inner join sec_mth_window as s
      on m.gvkey=s.gvkey and m.marker_date=s.datadate
    where s.primiss='P'
    group by m.gvkey, m.fyear, m.datadate, m.marker_date, s.iid;

    create table primary_counts as
    select gvkey, fyear, datadate, count(*) as n_primary_iid,
           sum(marker_rows) as n_primary_rows
    from primary_candidates
    group by gvkey, fyear, datadate;

    create table primary_iid as
    select p.gvkey, p.fyear, p.datadate, p.marker_date, p.iid
    from primary_candidates as p
    inner join primary_counts as c
      on p.gvkey=c.gvkey and p.fyear=c.fyear and p.datadate=c.datadate
    where c.n_primary_iid=1 and c.n_primary_rows=1 and p.marker_rows=1;
quit;

/* Daily security price identifies the primary issue's currency at the fiscal close. */
data sec_dprc_window;
    set sec.sec_dprc(keep=gvkey iid datadate curcdd prccd
                     where=(datadate between &raw_date_min.-7 and &raw_date_max.));
    if not missing(prccd) and prccd > 0;
run;
proc sql;
    create table price_dates as
    select p.gvkey, p.fyear, p.datadate, p.iid, p.marker_date,
           max(d.datadate) as price_date
    from primary_iid as p
    inner join sec_dprc_window as d
      on p.gvkey=d.gvkey and p.iid=d.iid
     and d.datadate <= p.datadate and d.datadate >= p.datadate-7
    group by p.gvkey, p.fyear, p.datadate, p.iid, p.marker_date;

    create table price_rows as
    select p.gvkey, p.fyear, p.datadate, p.iid, p.marker_date, p.price_date,
           max(d.curcdd) as price_curcd, max(d.prccd) as daily_close,
           count(*) as n_price_rows
    from price_dates as p
    inner join sec_dprc_window as d
      on p.gvkey=d.gvkey and p.iid=d.iid and p.price_date=d.datadate
    group by p.gvkey, p.fyear, p.datadate, p.iid, p.marker_date, p.price_date;
quit;

/* Daily EXRATD is the point-date quote for a fiscal-close security price. */
data fx_dly_raw;
    set fx.g_exrt_dly(keep=datadate fromcurd tocurd exratd exrattpd);
    if fromcurd='GBP' and not missing(tocurd) and exratd > 0;
run;
proc sql;
    create table fx_dly_rate as
    select datadate, tocurd, count(*) as n_quote,
           max(exratd) as fxrate, max(exrattpd) as rate_type
    from fx_dly_raw
    group by datadate, tocurd;

    create table price_route as
    select r.gvkey, r.fyear, r.datadate, r.prcc_f,
           pc.n_primary_iid, pc.n_primary_rows, pi.iid,
           pr.price_date, pr.price_curcd, pr.daily_close, pr.n_price_rows,
           s.fxrate as source_rate, s.n_quote as source_n,
           s.rate_type as source_type,
           u.fxrate as usd_rate, u.n_quote as usd_n,
           u.rate_type as usd_type
    from raw_unique as r
    left join primary_counts as pc
      on r.gvkey=pc.gvkey and r.fyear=pc.fyear and r.datadate=pc.datadate
    left join primary_iid as pi
      on r.gvkey=pi.gvkey and r.fyear=pi.fyear and r.datadate=pi.datadate
    left join price_rows as pr
      on pi.gvkey=pr.gvkey and pi.fyear=pr.fyear and pi.datadate=pr.datadate
     and pi.iid=pr.iid
    left join fx_dly_rate as s
      on pr.price_date=s.datadate and pr.price_curcd=s.tocurd
    left join fx_dly_rate as u
      on pr.price_date=u.datadate and u.tocurd='USD';
quit;

data price_route;
    set price_route;
    length price_fx_status 3 price_fx_factor 8 price_usd 8;
    if n_primary_iid ne 1 or n_primary_rows ne 1 then price_fx_status=1;
    else if missing(price_date) or n_price_rows ne 1 then price_fx_status=2;
    else if missing(price_curcd) then price_fx_status=3;
    else if missing(prcc_f) then price_fx_status=4;
    else if price_curcd='USD' then do;
        price_fx_factor=1;
        price_usd=prcc_f;
        price_fx_status=0;
    end;
    else if price_curcd='GBP' then do;
        if usd_n=1 and usd_rate>0 then do;
            price_fx_factor=usd_rate;
            price_usd=prcc_f*price_fx_factor;
            price_fx_status=0;
        end;
        else price_fx_status=5;
    end;
    else if source_n=1 and usd_n=1 and source_rate>0 and usd_rate>0 then do;
        price_fx_factor=usd_rate/source_rate;
        price_usd=prcc_f*price_fx_factor;
        price_fx_status=0;
    end;
    else price_fx_status=5;
run;

data sale_fx_usd;
    set raw_unique(keep=gvkey fyear datadate curcd sale);
    if curcd='USD';
    fxdate=.;
    source_rate=1;
    usd_rate=1;
    sale_fx_factor=1;
    sale_usd=sale;
    sale_fx_status=0;
run;

data sale_fx_quoted;
    set sale_fx_quoted;
    sale_usd=.;
    if source_rate>0 and usd_rate>0 then sale_usd=sale*sale_fx_factor;
    sale_fx_status=0;
run;

data sale_fx_all;
    set sale_fx_usd sale_fx_quoted;
run;

proc sql;
    create table source_fx_audit as
    select r.fyear, r.curcd, p.price_curcd,
           count(*) as n_rows,
           sum(not missing(r.sale)) as n_sale,
           sum(not missing(s.sale_usd)) as n_sale_usd,
           sum(p.price_fx_status=0) as n_price_usd,
           sum(p.price_fx_status=1) as n_primary_ambiguous,
           sum(p.price_fx_status=2) as n_no_daily_price,
           sum(p.price_fx_status=3) as n_missing_price_curcd,
           sum(p.price_fx_status=4) as n_missing_prccf,
           sum(p.price_fx_status=5) as n_no_price_fx
    from raw_unique as r
    left join sale_fx_all as s
      on r.gvkey=s.gvkey and r.fyear=s.fyear and r.datadate=s.datadate
    left join price_route as p
      on r.gvkey=p.gvkey and r.fyear=p.fyear and r.datadate=p.datadate
    where r.fyear between 1987 and 1997
    group by r.fyear, r.curcd, p.price_curcd
    order by r.fyear, r.curcd, p.price_curcd;
quit;
data _null_;
    set source_fx_audit;
    put 'ROW_CURRENCY_AND_USD_SCREEN_AUDIT ' fyear= curcd= price_curcd= n_rows=
        n_sale= n_sale_usd= n_price_usd= n_primary_ambiguous= n_no_daily_price=
        n_missing_price_curcd= n_missing_prccf= n_no_price_fx=;
run;
proc freq data=price_route;
    title 'Per-leg daily EXRATTPD provenance for verified price routes';
    where price_fx_status=0;
    tables source_type*usd_type / missing;
run;

proc sql;
    create table raw_screen as
    select c.*,
           s.sale_usd, s.fxdate as sale_fx_date,
           s.sale_fx_factor,
           case when missing(c.curcd) then 1
                when missing(c.sale) then 2
                when not missing(s.sale_usd) then 0
                else 3 end as sale_fx_status,
           p.price_usd, p.price_fx_factor, p.price_fx_status,
           p.iid as price_iid, p.price_date, p.price_curcd,
           p.source_type as price_fx_source_type,
           p.usd_type as price_fx_usd_type
    from raw_unique as c
    left join sale_fx_all as s
      on c.gvkey=s.gvkey and c.fyear=s.fyear and c.datadate=s.datadate
    left join price_route as p
      on c.gvkey=p.gvkey and c.fyear=p.fyear and c.datadate=p.datadate;
quit;

proc sql;
    create table source_year_fields as
    select fyear, count(*) as n_records,
           sum(not missing(at)) as n_at,
           sum(not missing(ib)) as n_ib,
           sum(not missing(oancf)) as n_oancf,
           sum(not missing(sale)) as n_sale,
           sum(not missing(prcc_f)) as n_price,
           sum(not missing(sich)) as n_sic,
           sum(not missing(curcd)) as n_curcd
    from raw_unique
    group by fyear
    order by fyear;
quit;
data _null_;
    set source_year_fields;
    put 'SOURCE_YEAR_FIELDS ' fyear= n_records= n_at= n_ib= n_oancf= n_sale= n_price= n_sic= n_curcd=;
run;

/* Currency audit for every adjacent fiscal-year pair used by the lag/lead ratios. */
proc sql;
    create table currency_pair_fields as
    select c.fyear, count(*) as n_firmyears,
           sum(case when missing(p.gvkey) then 1 else 0 end) as n_no_prior_record,
           sum(case when not missing(p.gvkey) and (missing(c.curcd) or missing(p.curcd))
                    then 1 else 0 end) as n_currency_code_missing,
           sum(case when not missing(p.gvkey) and not missing(c.curcd)
                         and not missing(p.curcd) and c.curcd ne p.curcd
                    then 1 else 0 end) as n_currency_changed,
           sum(case when not missing(p.gvkey) and not missing(c.curcd)
                         and not missing(p.curcd) and c.curcd=p.curcd
                    then 1 else 0 end) as n_currency_same
    from raw_unique as c
    left join raw_unique as p
      on c.gvkey=p.gvkey and p.fyear=c.fyear-1
    where c.fyear between 1981 and 1997
    group by c.fyear
    order by c.fyear;
quit;
data _null_;
    set currency_pair_fields;
    put 'CURRENCY_ADJACENT_PAIR ' fyear= n_firmyears= n_no_prior_record=
        n_currency_code_missing= n_currency_changed= n_currency_same=;
run;

proc means data=raw n nmiss;
    title 'Required-source-field coverage in filtered COMP.FUNDA rows';
    var at ib oancf xidoc recch invch apalch rect invt ap xacc
        xdp am dp xdepl sale prcc_f sich;
run;

/* One row per firm/fiscal year. Balance-sheet fallbacks use the exact t-1 fiscal year. */
proc sql;
    create table annual_base as
    select c.gvkey, c.datadate, c.fyear, c.curcd, c.sich, c.sale, c.prcc_f,
           c.sale_usd, c.sale_fx_status, c.price_usd, c.price_fx_status,
           c.price_iid, c.price_date, c.price_curcd,
           c.at, p.at as at_prev,
           case when not missing(p.gvkey) and not missing(c.curcd)
                     and not missing(p.curcd) and c.curcd=p.curcd
                then (c.at + p.at) / 2 else . end as avg_at,
           case when missing(p.gvkey) then 3
                when missing(c.curcd) or missing(p.curcd) then 2
                when c.curcd ne p.curcd then 1
                else 0 end as currency_status,
           c.ib as earn_raw,
            case when not missing(c.oancf) and not missing(c.xidoc)
                 then c.oancf - c.xidoc
                else . end as cf_raw,
            case when not missing(c.oancf) and missing(c.xidoc)
                 then 1 else 0 end as xidoc_missing_cf,
           case when not missing(c.recch) then -c.recch
                when not missing(c.rect) and not missing(p.rect)
                     and not missing(c.curcd) and not missing(p.curcd)
                     and c.curcd=p.curcd
                then c.rect - p.rect
                else . end as dar_raw,
           case when not missing(c.invch) then -c.invch
                when not missing(c.invt) and not missing(p.invt)
                     and not missing(c.curcd) and not missing(p.curcd)
                     and c.curcd=p.curcd
                then c.invt - p.invt
                else . end as dinv_raw,
           case when not missing(c.apalch) then c.apalch
                when not missing(c.ap) and not missing(c.xacc)
                     and not missing(p.ap) and not missing(p.xacc)
                     and not missing(c.curcd) and not missing(p.curcd)
                     and c.curcd=p.curcd
                then (c.ap + c.xacc) - (p.ap + p.xacc)
                else . end as dap_raw,
           c.xdp as depr_raw,
           case when not missing(c.am) then c.am
                when not missing(c.dp) and not missing(c.xdp) and not missing(c.xdepl)
                then c.dp - c.xdp - c.xdepl
                when not missing(c.dp) and not missing(c.xdp) and missing(c.xdepl)
                     and not missing(c.sich)
                     and (c.sich < 1000 or c.sich > 1499)
                     and (c.sich < 2900 or c.sich > 2999)
                     and (c.sich < 4600 or c.sich > 4699)
                then c.dp - c.xdp
                else . end as amort_raw
    from raw_screen as c
    left join raw_screen as p
      on c.gvkey=p.gvkey and c.fyear=p.fyear+1
    order by c.gvkey, c.fyear;
quit;

data annual;
    set annual_base;
    other_raw = earn_raw - (cf_raw + dar_raw + dinv_raw - dap_raw
                            - depr_raw - amort_raw);
run;

/* Fiscal-year keyed lead and lag joins preserve gaps and the t/t+1 distinction. */
proc sql;
    create table panel as
    select c.gvkey, c.datadate, c.fyear, c.sich, c.sale, c.prcc_f,
           c.curcd, c.sale_usd, c.sale_fx_status,
           c.price_usd, c.price_fx_status, c.price_iid, c.price_date, c.price_curcd,
           c.xidoc_missing_cf as xidoc_missing_cf0,
           case when missing(l.gvkey) then 0 else l.xidoc_missing_cf end as xidoc_missing_cf_lead,
           c.currency_status as currency_status0,
           case when missing(l.gvkey) then 3 else l.currency_status end as currency_status_lead,
           case when missing(e1.gvkey) then 3 else e1.currency_status end as currency_status1,
           case when missing(e2.gvkey) then 3 else e2.currency_status end as currency_status2,
           case when missing(e3.gvkey) then 3 else e3.currency_status end as currency_status3,
           case when missing(e4.gvkey) then 3 else e4.currency_status end as currency_status4,
           case when missing(e5.gvkey) then 3 else e5.currency_status end as currency_status5,
           case when missing(e6.gvkey) then 3 else e6.currency_status end as currency_status6,
           case when c.avg_at > 0 then c.earn_raw/c.avg_at else . end as earn0,
           case when c.avg_at > 0 then c.cf_raw/c.avg_at else . end as cf0,
           case when l.avg_at > 0 then l.cf_raw/l.avg_at else . end as cf_lead,
           case when c.avg_at > 0 then c.dar_raw/c.avg_at else . end as d_ar,
           case when c.avg_at > 0 then c.dinv_raw/c.avg_at else . end as d_inv,
           case when c.avg_at > 0 then c.dap_raw/c.avg_at else . end as d_ap,
           case when c.avg_at > 0 then c.depr_raw/c.avg_at else . end as depr,
           case when c.avg_at > 0 then c.amort_raw/c.avg_at else . end as amort,
           case when c.avg_at > 0 then c.other_raw/c.avg_at else . end as other,
           case when e1.avg_at > 0 then e1.earn_raw/e1.avg_at else . end as earn1,
           case when e2.avg_at > 0 then e2.earn_raw/e2.avg_at else . end as earn2,
           case when e3.avg_at > 0 then e3.earn_raw/e3.avg_at else . end as earn3,
           case when e4.avg_at > 0 then e4.earn_raw/e4.avg_at else . end as earn4,
           case when e5.avg_at > 0 then e5.earn_raw/e5.avg_at else . end as earn5,
           case when e6.avg_at > 0 then e6.earn_raw/e6.avg_at else . end as earn6
    from annual as c
    left join annual as l
      on c.gvkey=l.gvkey and l.fyear=c.fyear+1
    left join annual as e1
      on c.gvkey=e1.gvkey and e1.fyear=c.fyear-1
    left join annual as e2
      on c.gvkey=e2.gvkey and e2.fyear=c.fyear-2
    left join annual as e3
      on c.gvkey=e3.gvkey and e3.fyear=c.fyear-3
    left join annual as e4
      on c.gvkey=e4.gvkey and e4.fyear=c.fyear-4
    left join annual as e5
      on c.gvkey=e5.gvkey and e5.fyear=c.fyear-5
    left join annual as e6
      on c.gvkey=e6.gvkey and e6.fyear=c.fyear-6
    where c.fyear between 1987 and 1996
    order by c.gvkey, c.fyear;
quit;

data panel;
    set panel;
    currency_bad_k0=(currency_status0 ne 0)+(currency_status_lead ne 0);
    currency_bad_k1=currency_bad_k0+(currency_status1 ne 0);
    currency_bad_k2=currency_bad_k1+(currency_status2 ne 0);
    currency_bad_k3=currency_bad_k2+(currency_status3 ne 0);
    currency_bad_k4=currency_bad_k3+(currency_status4 ne 0);
    currency_bad_k5=currency_bad_k4+(currency_status5 ne 0);
    currency_bad_k6=currency_bad_k5+(currency_status6 ne 0);
run;

proc sql;
    create table panel_year_fields as
    select fyear, count(*) as n_origins,
           sum(not missing(cf_lead)) as n_cf_lead,
           sum(not missing(cf0)) as n_cf0,
           sum(not missing(sale_usd)) as n_sale_usd,
           sum(not missing(price_usd)) as n_price_usd,
           sum(sale_fx_status > 0) as n_sale_fx_unavailable,
           sum(price_fx_status > 0) as n_price_fx_unavailable,
           sum(xidoc_missing_cf0 > 0) as n_xidoc_missing_current,
           sum(xidoc_missing_cf_lead > 0) as n_xidoc_missing_lead,
           sum(not missing(earn0)) as n_earn0,
           sum(not missing(earn1)) as n_earn1,
           sum(not missing(earn2)) as n_earn2,
           sum(not missing(d_ar)) as n_dar,
           sum(not missing(d_inv)) as n_dinv,
           sum(not missing(d_ap)) as n_dap,
           sum(not missing(depr)) as n_depr,
           sum(not missing(amort)) as n_amort,
           sum(not missing(other)) as n_other,
           sum(currency_bad_k0 > 0) as n_currency_bad_k0,
           sum(currency_bad_k1 > 0) as n_currency_bad_k1,
           sum(currency_bad_k2 > 0) as n_currency_bad_k2,
           sum(currency_bad_k3 > 0) as n_currency_bad_k3,
           sum(currency_bad_k4 > 0) as n_currency_bad_k4,
           sum(currency_bad_k5 > 0) as n_currency_bad_k5,
           sum(currency_bad_k6 > 0) as n_currency_bad_k6,
           sum(not missing(sich)) as n_sic,
           sum(not missing(sale)) as n_sale,
           sum(not missing(prcc_f)) as n_price
    from panel
    group by fyear
    order by fyear;
quit;
data _null_;
    set panel_year_fields;
    put 'PANEL_YEAR_FIELDS ' fyear= n_origins= n_cf_lead= n_cf0= n_sale_usd=
        n_price_usd= n_sale_fx_unavailable= n_price_fx_unavailable=
        n_xidoc_missing_current= n_xidoc_missing_lead= n_earn0=
        n_earn1= n_earn2= n_dar= n_dinv= n_dap= n_depr= n_amort= n_other=
        n_currency_bad_k0= n_currency_bad_k1= n_currency_bad_k2=
        n_currency_bad_k3= n_currency_bad_k4= n_currency_bad_k5=
        n_currency_bad_k6= n_sic= n_sale= n_price=;
run;

/* Count the pre-tail observations otherwise complete except for missing XIDOC-derived CF. */
data xidoc_impact;
    set panel;
    if missing(sich) then delete;
    if sich >= 6000 and sich <= 6999 then delete;
    if missing(sale_usd) or sale_usd < 10 then delete;
    if missing(price_usd) or price_usd < 1 then delete;
    if currency_bad_k0 > 0 then delete;
    if nmiss(earn0, earn1, earn2, d_ar, d_inv, d_ap, depr, amort) > 0 then delete;
    if xidoc_missing_cf0=0 and xidoc_missing_cf_lead=0 then delete;
run;
proc sql;
    title 'Pre-tail complete-case candidates unavailable only through missing #124/XIDOC';
    select fyear, count(*) as n_rows,
           sum(xidoc_missing_cf0 > 0) as n_current_cf,
           sum(xidoc_missing_cf_lead > 0) as n_lead_cf
    from xidoc_impact
    group by fyear
    order by fyear;
    select count(*) as total_xidoc_affected_pre_tail from xidoc_impact;
quit;

data core;
    set panel;
    if missing(sich) then delete;
    if sich >= 6000 and sich <= 6999 then delete;
    if missing(sale_usd) or sale_usd < 10 then delete;
    if missing(price_usd) or price_usd < 1 then delete;
    /* Primary sample must support Eq. (11) k=2 and all of Eq. (12). */
    if nmiss(cf_lead, cf0, earn0, earn1, earn2,
             d_ar, d_inv, d_ap, depr, amort, other) > 0 then delete;
run;

proc sql;
    title 'Primary complete-case population before percentile and residual screens';
    select fyear, count(*) as rows
    from core
    group by fyear
    order by fyear;
    select count(*) as primary_complete_cases from core;
quit;

/* Pooled current-period deflated EARN/CF cutoffs within the primary pre-screen sample. */
proc means data=core noprint;
    var earn0 cf0;
    output out=percentile_cutoffs p1=earn_p1 cf_p1 p99=earn_p99 cf_p99;
run;

data _null_;
    set percentile_cutoffs;
    call symputx('earn_p1', earn_p1, 'G');
    call symputx('earn_p99', earn_p99, 'G');
    call symputx('cf_p1', cf_p1, 'G');
    call symputx('cf_p99', cf_p99, 'G');
run;
%put NOTE: Current EARN pooled 1st/99th percentiles = &earn_p1. / &earn_p99.;
%put NOTE: Current CF pooled 1st/99th percentiles = &cf_p1. / &cf_p99.;

data percentilescreen;
    set core;
    if earn0 < &earn_p1. or earn0 > &earn_p99. then delete;
    if cf0 < &cf_p1. or cf0 > &cf_p99. then delete;
run;

/* Residual regression is not named in the paper; pooled Eq. (11), k=2 is the documented proxy. */
proc reg data=percentilescreen;
    model cf_lead = earn0 earn1 earn2;
    output out=studentized rstudent=studentized_resid;
run;
quit;

proc means data=studentized n nmiss min p1 median p99 max;
    title 'Eq. (11) k=2 external studentized residual diagnostic';
    var studentized_resid;
run;

data screened;
    set studentized;
    if missing(studentized_resid) or abs(studentized_resid) <= 3;
    accruals = earn0 - cf0;
run;

proc sql;
    title 'Retained sample by predictor fiscal year after paper screens';
    select fyear, count(*) as rows
    from screened
    group by fyear
    order by fyear;
    select count(*) as final_primary_n from screened;
    select count(*) as retained_missing_studentized
    from screened where missing(studentized_resid);
quit;

proc sql noprint;
    select count(*) into :n_k0 trimmed from screened where not missing(earn0);
    select count(*) into :n_k1 trimmed from screened where not missing(earn0) and not missing(earn1);
    select count(*) into :n_k2 trimmed from screened where not missing(earn0) and not missing(earn1) and not missing(earn2);
    select count(*) into :n_k3 trimmed from screened where not missing(earn0) and not missing(earn1) and not missing(earn2) and not missing(earn3);
    select count(*) into :n_k4 trimmed from screened where not missing(earn0) and not missing(earn1) and not missing(earn2) and not missing(earn3) and not missing(earn4);
    select count(*) into :n_k5 trimmed from screened where not missing(earn0) and not missing(earn1) and not missing(earn2) and not missing(earn3) and not missing(earn4) and not missing(earn5);
    select count(*) into :n_k6 trimmed from screened where not missing(earn0) and not missing(earn1) and not missing(earn2) and not missing(earn3) and not missing(earn4) and not missing(earn5) and not missing(earn6);
quit;
%put NOTE: FIT_SAMPLE_N k0=&n_k0. k1=&n_k1. k2=&n_k2. k3=&n_k3. k4=&n_k4. k5=&n_k5. k6=&n_k6.;

data out.reg;
    set screened;
    keep gvkey datadate fyear earn0 earn1 earn2 earn3 earn4 earn5 earn6
         cf_lead cf0 d_ar d_inv d_ap depr amort other accruals;
    label
        gvkey='Compustat GVKEY'
        datadate='Fiscal year end date'
        fyear='Fiscal year'
        cf_lead='One-year-ahead operating cash flow'
        cf0='Current operating cash flow'
        earn0='Current earnings'
        earn1='One-year lagged earnings'
        earn2='Two-year lagged earnings'
        earn3='Three-year lagged earnings'
        earn4='Four-year lagged earnings'
        earn5='Five-year lagged earnings'
        earn6='Six-year lagged earnings'
        d_ar='Change in accounts receivable'
        d_inv='Change in inventory'
        d_ap='Change in accounts payable and accrued liabilities'
        depr='Depreciation expense'
        amort='Amortization expense'
        other='Other accruals'
        accruals='Aggregate operating accruals';
    format datadate yymmdd10.;
run;

proc means data=out.reg n nmiss mean median std min max;
    title 'Final analysis sample descriptive diagnostics';
    var earn0 cf0 accruals d_ar d_inv d_ap depr amort other cf_lead;
run;

proc contents data=out.reg;
    title 'Native Stata handoff schema';
run;
