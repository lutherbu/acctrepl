options errorabend;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname cglob "/storage/sas/base/comp/d_global" access=readonly;
libname ccy "/storage/sas/base/comp/d_global/currency" access=readonly;
libname secmth "/storage/sas/base/comp/d_na/security" access=readonly;
libname ibes "/storage/sas/base/ibes" access=readonly;
libname wrdsapps "/storage/sas/base/wrdsapps/linking/iclink" access=readonly;
libname crsp "/storage/sas/base/crsp/a_ccm" access=readonly;
libname crspstk "/storage/sas/base/crsp/a_stock" access=readonly;
libname outdata "data";

/* Current-vintage annual Compustat input. The fiscal-year envelope retains
   t-2 and t+1 history for the assigned forward-looking model. */
proc sql;
  create table work.comp_src as
  select gvkey, iid, hiid, datadate, fyear, fic, curcd, sich, indfmt, consol, popsrc, datafmt,
         at, sale, ppegt, oancf, xidoc, txdi, ibc, ni, recch, prcc_f, csho
  from comp.funda
  where fyear between 1992 and 2001
    and fic = 'USA'
    and indfmt = 'INDL'
    and consol = 'C'
    and popsrc = 'D'
    and datafmt = 'STD'
    and not missing(sich)
    and not (sich between 4900 and 4999)
    and not (sich between 6000 and 6099)
    and sich not in (6726, 6792, 6795, 6798, 6799)
  order by gvkey, fyear, datadate;
quit;

proc sql noprint;
  select count(*) into :comp_dup trimmed
  from (select gvkey, fyear from work.comp_src
        group by gvkey, fyear having count(*) > 1);
  select count(*) into :comp_n trimmed from work.comp_src;
quit;
%put NOTE: Compustat rows after annual/U.S./industry screens=&comp_n duplicate GVKEY-year groups=&comp_dup;
data _null_;
  if &comp_dup > 0 then do;
    put "ERROR: Compustat has duplicate GVKEY-fiscal-year keys after the stated source screens.";
    abort cancel;
  end;
run;

data work.compbase;
  set work.comp_src;
  sic2 = floor(sich/100);
  curcd = upcase(strip(curcd));
  iid = upcase(strip(iid));
  hiid = upcase(strip(hiid));
run;

/* PRCC_F is a historical primary-issue price. FUNDA.HIID is the historical
   primary issue identifier; FUNDA.IID is only the current header identifier.
   A same-month HIID monthly quote with matching PRCC_F and known currency is
   corroborated by a dated P marker when present. Missing markers are not
   treated as contradictions. Unresolved routes may use a same-HIID daily
   quote only on the annual date or across a documented market closure of at
   most seven calendar days, with a matching PRCCD and unique known currency. */
data work.price_key;
  set work.compbase(keep=gvkey iid hiid datadate fyear prcc_f curcd);
  where fyear between 1993 and 1999;
  pyear=year(datadate);
  pmon=month(datadate);
  if not missing(prcc_f) then price_tol=max(1e-8,abs(prcc_f)*1e-6);
run;
data work.sec_marker;
  set secmth.sec_mth(keep=gvkey iid datadate primiss);
  where datadate between '01JAN1992'd and '31DEC2000'd;
  iid=upcase(strip(iid));
  primiss=upcase(strip(primiss));
run;
data work.sec_mthprice;
  set secmth.sec_mthprc(keep=gvkey iid datadate prccm curcdm);
  where datadate between '01JAN1992'd and '31DEC2000'd;
  curcdm=upcase(strip(curcdm));
  iid=upcase(strip(iid));
run;
data work.sec_month_marker;
  set work.sec_marker;
  marker_year=year(datadate);
  marker_month=month(datadate);
run;
proc sql;
  create table work.price_month0 as
  select a.gvkey, a.iid as header_iid length=3, a.hiid, a.datadate,
         a.fyear, a.pyear, a.pmon, a.prcc_f, a.price_tol, a.curcd,
         count(p.datadate) as mth_rows,
         count(distinct p.datadate) as mth_dates,
         count(distinct p.curcdm) as mth_ccy_n,
         min(upcase(strip(p.curcdm))) as mth_cur length=3,
         min(p.datadate) as mth_date format=date9.,
         min(case when not missing(p.datadate) and not missing(p.prccm)
                       and not missing(a.prcc_f)
                  then abs(p.prccm-a.prcc_f) else . end) as mth_gap
  from work.price_key as a
  left join work.sec_mthprice as p
    on not missing(a.hiid) and a.gvkey=p.gvkey and a.hiid=p.iid
   and a.pyear=year(p.datadate) and a.pmon=month(p.datadate)
   and p.datadate<=a.datadate
  group by a.gvkey, a.iid, a.hiid, a.datadate, a.fyear, a.pyear, a.pmon,
           a.prcc_f, a.price_tol, a.curcd;
  create table work.price_month_marker as
  select a.*,coalesce(m.marker_rows,0) as marker_rows,
         coalesce(m.marker_code_n,0) as marker_code_n,m.marker_code
  from work.price_month0 as a
  left join
    (select gvkey,iid,datadate,count(*) as marker_rows,
            count(distinct primiss) as marker_code_n,
            min(primiss) as marker_code length=3
     from work.sec_marker group by gvkey,iid,datadate) as m
    on a.gvkey=m.gvkey and a.hiid=m.iid and a.mth_date=m.datadate;
  create table work.price_month as
  select *,
         case when not missing(hiid) and mth_rows=1 and mth_dates=1
                   and mth_ccy_n=1 and not missing(mth_cur)
                   and not missing(mth_date) and not missing(price_tol)
                   and not missing(mth_gap) and mth_gap<=price_tol
                   and marker_rows<=1
                   and (marker_code_n=0 or marker_code='P')
              then 1 else 0 end as month_price_ok,
         case when marker_rows>1 or marker_code_n>1
                   or (marker_code_n=1 and marker_code ne 'P')
              then 1 else 0 end as month_marker_conflict
  from work.price_month_marker;
quit;

/* Read daily records only for unresolved historical-issue keys. The catalog
   confirms the GVKEY index; CRSP.DSI supplies actual exchange-session dates
   for testing a short closure lag. */
data work.price_unres;
  set work.price_month;
  if month_price_ok ne 1 and not missing(hiid);
  gv_bucket=substr(strip(gvkey),1,1);
run;
proc sql noprint;
  select count(distinct gvkey) into :price_gv_n trimmed from work.price_unres;
  %let price_gv0=;
  %let price_gv1=;
  %let price_gv2=;
  %let price_gv3=;
  %let price_gv4=;
  %let price_gv5=;
  %let price_gv6=;
  %let price_gv7=;
  %let price_gv8=;
  %let price_gv9=;
%macro price_lists;
  %do j=0 %to 9;
    select distinct quote(strip(gvkey)) into :price_gv&j separated by ','
    from work.price_unres where gv_bucket="&j";
  %end;
%mend;
%price_lists;
quit;
%put NOTE: Historical-issue daily fallback scans &price_gv_n unresolved GVKEYs.;
options msglevel=i;
%let first_price_bucket=1;
%macro read_price_index;
  %do j=0 %to 9;
    %let keylist=&&price_gv&j;
    %if %length(%superq(keylist)) > 0 %then %do;
      data work.sec_part;
        set secmth.sec_dprc(keep=gvkey iid datadate curcdd prccd
            where=(gvkey in (&keylist)
              and datadate between '01JAN1992'd and '31DEC2000'd)
            idxname=gvkey);
      run;
      %if &first_price_bucket=1 %then %do;
        data work.sec_prc; set work.sec_part; run;
        %let first_price_bucket=0;
      %end;
      %else %do;
        proc append base=work.sec_prc data=work.sec_part force; run;
      %end;
    %end;
  %end;
%mend;
%read_price_index;
options msglevel=n;
data work.sec_prc;
  set work.sec_prc;
  iid=upcase(strip(iid));
  curcdd=upcase(strip(curcdd));
run;
data work.market_days;
  set crspstk.dsi(keep=date);
  where date between '01JAN1992'd and '31DEC2000'd;
run;
proc sql;
  create table work.daily_date as
  select a.gvkey,a.header_iid,a.hiid,a.datadate,a.fyear,a.pyear,a.pmon,
         a.prcc_f,a.price_tol,max(b.datadate) as daily_date format=date9.
  from work.price_unres as a
  left join work.sec_prc as b
    on a.gvkey=b.gvkey and a.hiid=b.iid and b.datadate<=a.datadate
  group by a.gvkey,a.header_iid,a.hiid,a.datadate,a.fyear,a.pyear,a.pmon,
           a.prcc_f,a.price_tol;
  create table work.daily_quote as
  select a.*,count(b.datadate) as daily_rows,
         count(distinct b.curcdd) as daily_ccy_n,
         min(b.curcdd) as daily_cur length=3,
         min(case when not missing(b.datadate) and not missing(b.prccd)
                       and not missing(a.prcc_f)
                  then abs(b.prccd-a.prcc_f) else . end) as daily_gap,
         a.datadate-a.daily_date as daily_age,
         coalesce(mm.month_marker_rows,0) as month_marker_rows,
         coalesce(mm.month_marker_code_n,0) as month_marker_code_n,
         mm.month_marker_code
  from work.daily_date as a
  left join work.sec_prc as b
    on a.gvkey=b.gvkey and a.hiid=b.iid and a.daily_date=b.datadate
  left join
    (select gvkey,iid,marker_year,marker_month,
            count(*) as month_marker_rows,
            count(distinct primiss) as month_marker_code_n,
            min(primiss) as month_marker_code length=3
     from work.sec_month_marker
     group by gvkey,iid,marker_year,marker_month) as mm
    on a.gvkey=mm.gvkey and a.hiid=mm.iid
   and a.pyear=mm.marker_year and a.pmon=mm.marker_month
  group by a.gvkey,a.header_iid,a.hiid,a.datadate,a.fyear,a.pyear,a.pmon,
           a.prcc_f,a.price_tol,a.daily_date,
           mm.month_marker_rows,mm.month_marker_code_n,mm.month_marker_code;
  create table work.daily_calendar as
  select a.*,count(b.date) as market_days_gap
  from work.daily_quote as a
  left join work.market_days as b
    on b.date>a.daily_date and b.date<=a.datadate
  group by a.gvkey,a.header_iid,a.hiid,a.datadate,a.fyear,a.pyear,a.pmon,
           a.prcc_f,a.price_tol,a.daily_date,a.daily_rows,a.daily_ccy_n,
           a.daily_cur,a.daily_gap,a.daily_age,a.month_marker_rows,
           a.month_marker_code_n,a.month_marker_code;
  create table work.daily_checked as
  select *,
         case when not missing(daily_date) and not missing(daily_age)
                   and not missing(price_tol) and not missing(daily_gap)
                   and daily_rows=1 and daily_ccy_n=1 and not missing(daily_cur)
                   and daily_gap<=price_tol and daily_age>=0 and daily_age<=7
                   and market_days_gap=0
                   and month_marker_rows<=1
                   and (month_marker_code_n=0 or month_marker_code='P')
              then 1 else 0 end as daily_price_ok
  from work.daily_calendar;
  create table work.price_final as
  select a.*,
         coalesce(d.daily_rows,0) as daily_rows,
         coalesce(d.daily_ccy_n,0) as daily_ccy_n,
         d.daily_cur,d.daily_date,d.daily_age,d.daily_gap,d.market_days_gap,
         coalesce(d.month_marker_rows,0) as daily_month_marker_rows,
         coalesce(d.month_marker_code_n,0) as daily_month_marker_code_n,
         d.month_marker_code as daily_month_marker_code,
         coalesce(d.daily_price_ok,0) as daily_price_ok,
         case when a.month_price_ok=1 then a.mth_cur
              when d.daily_price_ok=1 then d.daily_cur else '' end
              as price_cur_final length=3,
         case when a.month_price_ok=1 then a.mth_date
              when d.daily_price_ok=1 then d.daily_date else . end
              as price_date format=date9.,
         case when a.month_price_ok=1 or d.daily_price_ok=1 then 1 else 0 end
              as price_cur_verified,
         case when a.month_price_ok=1 then 'HIID_MONTH'
              when d.daily_price_ok=1 and d.daily_age=0 then 'HIID_D0'
              when d.daily_price_ok=1 then 'HIID_CLOSURE'
              else '' end as price_cur_src length=12,
         case when missing(a.hiid) then 'NO_HIID'
              when a.month_price_ok=1 then 'HIID_MONTH'
              when a.month_marker_conflict=1 then 'MONTH_MARKER_CONFLICT'
              when a.mth_rows>0 and a.mth_ccy_n>1 then 'MONTH_AMBIG_CCY'
              when a.mth_rows>1 then 'MONTH_AMBIG_ROWS'
              when a.mth_rows=1 and missing(a.mth_gap) then 'MONTH_PRICE_MISSING'
              when a.mth_rows=1 and not missing(a.mth_gap)
                   and not missing(a.price_tol) and a.mth_gap>a.price_tol then 'MONTH_PRICE_DIFF'
              when d.daily_price_ok=1 and d.daily_age=0 then 'HIID_DAILY_EXACT'
              when d.daily_price_ok=1 then 'HIID_DAILY_CLOSURE'
              when d.daily_rows=1 and d.daily_ccy_n=1 and not missing(d.daily_gap)
                   and not missing(a.price_tol) and d.daily_gap>a.price_tol then 'DAILY_PRICE_DIFF'
              when d.daily_rows=1 and d.daily_ccy_n=1 and not missing(d.daily_gap)
                   and not missing(a.price_tol) and d.daily_gap<=a.price_tol
                   and not missing(d.daily_age) and d.daily_age>7 then 'DAILY_STALE'
              when d.month_marker_rows>1 or d.month_marker_code_n>1
                   or (d.month_marker_code_n=1 and d.month_marker_code ne 'P')
                   then 'DAILY_MARKER_CONFLICT'
              when d.daily_rows=1 and d.daily_ccy_n=1 and not missing(d.daily_age)
                   and d.daily_age between 1 and 7 and d.market_days_gap>0 then 'DAILY_MARKET_GAP'
              when d.daily_rows>1 or d.daily_ccy_n>1 then 'DAILY_AMBIGUOUS'
              else 'UNSUPPORTED' end as price_status length=24,
         case when a.month_price_ok=1 then 'MONTHLY'
              when d.daily_price_ok=1 and d.daily_age=0 then 'DAILY_EXACT'
              when d.daily_price_ok=1 then 'DAILY_CLOSURE'
              when d.daily_rows=1 and d.daily_ccy_n=1 and not missing(d.daily_gap)
                   and not missing(a.price_tol) and d.daily_gap<=a.price_tol
                   and not missing(d.daily_age) and d.daily_age>7 then 'DAILY_STALE'
              else 'UNRESOLVED' end as price_status_group length=16
  from work.price_month as a
  left join work.daily_checked as d
    on a.gvkey=d.gvkey and a.header_iid=d.header_iid
   and a.hiid=d.hiid and a.datadate=d.datadate;
  create table work.comp as
  select a.*, b.price_cur_final as price_cur,
         b.price_date,b.price_cur_verified,
         b.price_cur_src,b.price_status,b.price_status_group,
         b.daily_age,b.market_days_gap
  from work.compbase as a
  left join work.price_final as b
    on a.gvkey=b.gvkey and a.iid=b.header_iid and a.hiid=b.hiid
   and a.datadate=b.datadate;
quit;

/* Xpressfeed currency rate candidates: exact reporting-period dates only.
   The guide directs daily rates for balance-sheet/price items and the
   12-month average rate for income-statement/cash-flow items. */
data work.dly_src;
  set ccy.g_exrt_dly(keep=datadate tocurd exrattpd fromcurd exratd);
  where datadate between '01JAN1992'd and '31DEC2001'd;
  tocurd=upcase(strip(tocurd));
  fromcurd=upcase(strip(fromcurd));
  exrattpd=upcase(strip(exrattpd));
run;
data work.mth_src;
  set ccy.g_exrt_mth(keep=datadate tocurm fromcurm exrat12m);
  where datadate between '01JAN1992'd and '31DEC2001'd;
  tocurm=upcase(strip(tocurm));
  fromcurm=upcase(strip(fromcurm));
run;
proc sql;
  create table work.dly_dup as
  select datadate, tocurd, fromcurd, count(*) as n
  from work.dly_src
  group by datadate, tocurd, fromcurd
  having count(*)>1;
  create table work.mth_dup as
  select datadate, tocurm, fromcurm, count(*) as n
  from work.mth_src
  group by datadate, tocurm, fromcurm
  having count(*)>1;
  create table work.ccy_need as
  select distinct curcd as ccy length=3 from work.comp
  where not missing(curcd)
  union
  select distinct price_cur_final as ccy length=3 from work.price_final
  where price_cur_verified=1 and not missing(price_cur_final);
  create table work.dly_used as
  select a.* from work.dly_src as a
  inner join work.ccy_need as b on a.tocurd=b.ccy
  where a.fromcurd='GBP' and a.exratd>0 and not missing(a.exratd)
    and not exists (select 1 from work.dly_dup as d
       where d.datadate=a.datadate and d.tocurd=a.tocurd
         and d.fromcurd=a.fromcurd);
  create table work.mth_used as
  select a.* from work.mth_src as a
  inner join work.ccy_need as b on a.tocurm=b.ccy
  where a.fromcurm='GBP' and a.exrat12m>0 and not missing(a.exrat12m)
    and not exists (select 1 from work.mth_dup as d
       where d.datadate=a.datadate and d.tocurm=a.tocurm
         and d.fromcurm=a.fromcurm);
  create table work.dly_pair0 as
  select s.datadate, s.tocurd as src length=3, t.tocurd as tgt length=3,
         s.exrattpd as src_type length=3, t.exrattpd as tgt_type length=3,
         s.exratd as rate_src, t.exratd as rate_tgt
  from work.dly_used as s inner join work.dly_used as t
    on s.datadate=t.datadate and s.fromcurd=t.fromcurd
   and s.tocurd ne t.tocurd;
  create table work.dly_pairn as
  select datadate, src, tgt, count(*) as quote_n,
         min(src_type) as src_type length=3,
         min(tgt_type) as tgt_type length=3,
         min(rate_tgt/rate_src) as fx
  from work.dly_pair0
  group by datadate, src, tgt;
  create table work.dly_fx as
  select datadate, src, tgt, src_type, tgt_type, fx
  from work.dly_pairn where quote_n=1 and not missing(fx) and fx>0;
  create table work.mth_pair0 as
  select s.datadate, s.tocurm as src length=3, t.tocurm as tgt length=3,
         s.exrat12m as rate_src, t.exrat12m as rate_tgt
  from work.mth_used as s inner join work.mth_used as t
    on s.datadate=t.datadate and s.tocurm ne t.tocurm
   and s.fromcurm=t.fromcurm;
  create table work.mth_fx as
  select datadate, src, tgt, min(rate_tgt/rate_src) as fx
  from work.mth_pair0
  group by datadate, src, tgt
  having count(*)=1 and not missing(calculated fx) and calculated fx>0;
quit;

/* Aggregate-only provider and coverage diagnostics; no source records print. */
proc freq data=work.dly_src;
  tables fromcurd exrattpd / missing;
run;
proc freq data=work.mth_src;
  tables fromcurm / missing;
run;
proc sql;
  title 'Currency source and rate validation';
  select count(*) as daily_rate_rows,
         sum(missing(exratd) or exratd<=0) as daily_missing_or_nonpositive,
         count(distinct datadate) as daily_dates,
         count(*)-count(distinct cats(put(datadate,best32.),'|',tocurd,'|',exrattpd,'|',fromcurd)) as daily_duplicate_rows
  from work.dly_src;
  select count(*) as monthly_rate_rows,
         sum(missing(exrat12m) or exrat12m<=0) as monthly_missing_or_nonpositive,
         count(distinct datadate) as monthly_dates,
         count(*)-count(distinct cats(put(datadate,best32.),'|',tocurm,'|',fromcurm)) as monthly_duplicate_rows
  from work.mth_src;
  select count(*) as annual_security_price_keys,
         sum(missing(hiid)) as missing_historical_iid,
         sum(not missing(header_iid) and not missing(hiid) and header_iid ne hiid) as header_hiid_differences,
         sum(month_price_ok=1) as verified_hiid_monthly_prices,
         sum(price_status='HIID_DAILY_EXACT') as recovered_hiid_exact_daily,
         sum(price_status='HIID_DAILY_CLOSURE') as recovered_hiid_closure_daily,
         sum(mth_rows=1 and mth_ccy_n=1 and not missing(mth_gap)
             and not missing(price_tol) and mth_gap>price_tol) as monthly_price_contradictions,
         sum(daily_rows=1 and daily_ccy_n=1 and not missing(daily_gap)
             and not missing(price_tol) and daily_gap>price_tol) as daily_price_contradictions,
         sum(price_status='DAILY_STALE') as unsupported_stale_daily_quotes,
         sum(price_status='DAILY_MARKER_CONFLICT') as daily_marker_conflicts,
         sum(month_marker_conflict=1) as monthly_marker_conflicts,
         sum(price_cur_verified ne 1) as unresolved_price_currency,
         sum(price_cur_verified=1 and price_cur_final ne curcd) as price_vs_report_currency
  from work.price_final;
  title 'Historical-primary price verification outcomes by route';
  select price_status_group, count(*) as price_keys
  from work.price_final group by price_status_group order by price_status_group;
  select price_status, count(*) as price_keys
  from work.price_final group by price_status order by price_status;
  title 'Currency pair availability';
  select count(*) as needed_currency_codes from work.ccy_need;
  select count(*) as daily_pair_date_candidates,
         sum(quote_n>1) as nonunique_daily_currency_quotes,
         sum(missing(src_type) or missing(tgt_type)) as pairs_with_blank_leg_provenance,
         sum(src_type ne tgt_type) as pairs_with_mixed_leg_provenance
  from work.dly_pairn;
  select count(*) as daily_fx_pairs from work.dly_fx;
  select count(*) as monthly_fx_pairs from work.mth_fx;
  select count(*) as dec1999_cross_rates,
         min(fx) as dec1999_fx_minimum format=12.8,
         max(fx) as dec1999_fx_maximum format=12.8,
         sum(missing(src_type) or missing(tgt_type)) as dec1999_blank_leg_provenance,
         sum(src_type ne tgt_type) as dec1999_mixed_leg_provenance
  from work.dly_fx where datadate='31DEC1999'd;
  title;
quit;

/* Exact fiscal-year self-joins preserve gaps instead of using row-position lags. */
proc sql;
  create table work.panel as
  select a.*,
         b.datadate as datadate_l1, b.curcd as curcd_l1,
         b.at as at_l1, b.sale as sale_l1, b.ni as ni_l1,
         b.ibc as ibc_l1, b.oancf as oancf_l1, b.xidoc as xidoc_l1,
         b.prcc_f as prcc_f_l1, b.csho as csho_l1,
         b.price_cur as price_cur_l1, b.price_cur_verified as price_cur_ok,
         b.price_cur_src as price_cur_src_l1,
         b.price_status as price_status_l1,
         b.price_status_group as price_status_group_l1,
         c.datadate as datadate_l2, c.curcd as curcd_l2, c.at as at_l2,
         d.datadate as datadate_f1, d.curcd as curcd_f1, d.sale as sale_f1,
         f1.fx as fx_dly_l1, f2.fx as fx_dly_l2,
         f1.src_type as fx_dly_l1_src_type,
         f1.tgt_type as fx_dly_l1_tgt_type,
         f2.src_type as fx_dly_l2_src_type,
         f2.tgt_type as fx_dly_l2_tgt_type,
         f3.fx as fx_dly_px, f4.fx as fx_mth_l1,
         f3.src_type as fx_dly_px_src_type,
         f3.tgt_type as fx_dly_px_tgt_type,
         f5.fx as fx_mth_f1
  from work.comp as a
  left join work.comp as b
    on a.gvkey=b.gvkey and b.fyear=a.fyear-1
  left join work.comp as c
    on a.gvkey=c.gvkey and c.fyear=a.fyear-2
  left join work.comp as d
    on a.gvkey=d.gvkey and d.fyear=a.fyear+1
  left join work.dly_fx as f1
    on b.datadate=f1.datadate and b.curcd=f1.src and a.curcd=f1.tgt
  left join work.dly_fx as f2
    on c.datadate=f2.datadate and c.curcd=f2.src and b.curcd=f2.tgt
  left join work.dly_fx as f3
    on b.price_date=f3.datadate and b.price_cur=f3.src and a.curcd=f3.tgt
  left join work.mth_fx as f4
    on b.datadate=f4.datadate and b.curcd=f4.src and a.curcd=f4.tgt
  left join work.mth_fx as f5
    on d.datadate=f5.datadate and d.curcd=f5.src and a.curcd=f5.tgt
  order by a.gvkey, a.fyear;
quit;

data work.measures;
  set work.panel;
  at_l1_cur=.; sale_l1_cur=.; ni_l1_cur=.;
  cfo_l1_cur=.; at_l2_cur=.; sale_f1_cur=.;
  prcc_f_l1_cur=.; mve_l1=.;
  if not missing(curcd) and not missing(curcd_l1) then do;
    if curcd=curcd_l1 then do;
      at_l1_cur=at_l1; sale_l1_cur=sale_l1; ni_l1_cur=ni_l1;
      cfo_l1_cur=oancf_l1-xidoc_l1;
    end;
    else do;
      if not missing(fx_dly_l1) then at_l1_cur=at_l1*fx_dly_l1;
      if not missing(fx_mth_l1) then do;
        sale_l1_cur=sale_l1*fx_mth_l1;
        ni_l1_cur=ni_l1*fx_mth_l1;
        cfo_l1_cur=(oancf_l1-xidoc_l1)*fx_mth_l1;
      end;
    end;
  end;
  if not missing(curcd_l1) and not missing(curcd_l2) then do;
    if curcd_l1=curcd_l2 then at_l2_cur=at_l2;
    else if not missing(fx_dly_l2) then at_l2_cur=at_l2*fx_dly_l2;
  end;
  if not missing(curcd) and not missing(curcd_f1) then do;
    if curcd=curcd_f1 then sale_f1_cur=sale_f1;
    else if not missing(fx_mth_f1) then sale_f1_cur=sale_f1*fx_mth_f1;
  end;
  if not missing(curcd) and not missing(price_cur_l1) and price_cur_ok=1 then do;
    if curcd=price_cur_l1 then prcc_f_l1_cur=prcc_f_l1;
    else if not missing(fx_dly_px) then prcc_f_l1_cur=prcc_f_l1*fx_dly_px;
  end;
  if not missing(prcc_f_l1_cur) then mve_l1=csho_l1*prcc_f_l1_cur;
  if at_l1_cur > 0 then do;
    dte = txdi / at_l1_cur;
    tacc = (ibc - (oancf - xidoc)) / at_l1_cur;
    cfo = (oancf - xidoc) / at_l1_cur;
    dcfo = ((oancf - xidoc) - cfo_l1_cur) / at_l1_cur;
    dsales = (sale - sale_l1_cur) / at_l1_cur;
    ppe = ppegt / at_l1_cur;
    /* RECCH is cash-flow-signed: reverse its decrease/(increase) sign. */
    delta_ar = -recch / at_l1_cur;
  end;
  if at_l2_cur > 0 and nmiss(ibc_l1, oancf_l1, xidoc_l1) = 0 then
    lag_tacc = (ibc_l1 - (oancf_l1 - xidoc_l1)) / at_l2_cur;
  if sale > 0 and not missing(sale_f1_cur) then
    grsales = (sale_f1_cur-sale) / sale;
  /* A25 is CSHO and A199 PRCC_F; align the security-price currency with
     current NI using the matched provider price date before forming market value. */
  if mve_l1 > 0 and not missing(ni) then scaled_level = ni / mve_l1;
  if mve_l1 > 0 and not missing(ni) and not missing(ni_l1_cur) then
    scaled_change = (ni-ni_l1_cur) / mve_l1;
run;

/* Source-wide currency transitions cover the complete current/lag/lead
   support. Counts are by year and do not print firm-year records. */
proc freq data=work.comp;
  tables curcd / missing;
run;
proc sql;
  title 'Currency transitions over model support window';
  select fyear, count(*) as source_rows,
    sum(case when not missing(curcd) and not missing(curcd_l1) then 1 else 0 end) as cp_known,
    sum(case when not missing(curcd) and not missing(curcd_l1) and curcd ne curcd_l1 then 1 else 0 end) as cp_switch,
    sum(case when not missing(curcd_l1) and not missing(curcd_l2) then 1 else 0 end) as pp2_known,
    sum(case when not missing(curcd_l1) and not missing(curcd_l2) and curcd_l1 ne curcd_l2 then 1 else 0 end) as pp2_switch,
    sum(case when not missing(curcd) and not missing(curcd_f1) then 1 else 0 end) as cf_known,
    sum(case when not missing(curcd) and not missing(curcd_f1) and curcd ne curcd_f1 then 1 else 0 end) as cf_switch,
    sum(case when not missing(curcd) and not missing(curcd_l1) and curcd ne curcd_l1 and missing(fx_dly_l1) then 1 else 0 end) as at_fx_missing,
    sum(case when not missing(curcd) and not missing(curcd_l1) and curcd ne curcd_l1 and missing(fx_mth_l1) then 1 else 0 end) as flow_fx_missing,
    sum(case when not missing(curcd_l1) and not missing(curcd_l2) and curcd_l1 ne curcd_l2 and missing(fx_dly_l2) then 1 else 0 end) as lagat_fx_missing,
    sum(case when not missing(curcd) and not missing(curcd_f1) and curcd ne curcd_f1 and missing(fx_mth_f1) then 1 else 0 end) as lead_fx_missing,
    sum(case when not missing(curcd) and not missing(price_cur_l1) then 1 else 0 end) as price_ccy_known,
    sum(case when not missing(curcd) and not missing(price_cur_l1) and curcd ne price_cur_l1 then 1 else 0 end) as price_ccy_switch,
    sum(case when not missing(curcd) and not missing(price_cur_l1) and curcd ne price_cur_l1 and missing(fx_dly_px) then 1 else 0 end) as price_fx_missing
  from work.panel
  where fyear between 1994 and 2000
  group by fyear order by fyear;
  title;
quit;

/* IBES: the last annual EPS summary mean strictly before the actual announcement. */
data work.ibes_pre;
  set ibes.statsum_epsus(keep=ticker statpers measure fpi estflag usfirm
       curcode curr_act fpedats meanest actual anndats_act);
  where usfirm=1 and upcase(strip(measure))='EPS' and strip(fpi)='1'
    and upcase(strip(estflag))='P'
    and upcase(strip(curcode))='USD'
    and upcase(strip(curr_act))='USD'
    and not missing(fpedats) and not missing(statpers)
    and not missing(anndats_act) and statpers < anndats_act
    and not missing(meanest) and not missing(actual)
    and year(fpedats) between 1992 and 2001;
  afe = actual - meanest;
run;
proc sql;
  create table work.ibes_lastdate as
  select ticker, fpedats, anndats_act, max(statpers) as statpers
  from work.ibes_pre
  group by ticker, fpedats, anndats_act;
  create table work.ibes_last as
  select a.*
  from work.ibes_pre as a
  inner join work.ibes_lastdate as b
    on a.ticker=b.ticker and a.fpedats=b.fpedats
   and a.anndats_act=b.anndats_act and a.statpers=b.statpers;
quit;

/* IBES ticker-to-PERMNO links are valid at the forecast summary date. */
proc sql;
  create table work.ticker_link_candidates as
  select a.ticker, a.statpers, a.fpedats, a.anndats_act,
         b.permno, b.score
  from work.ibes_last as a
  inner join wrdsapps.ibcrsphist as b
    on upcase(strip(a.ticker))=upcase(strip(b.ticker))
   and (missing(b.sdate) or a.statpers >= b.sdate)
   and (missing(b.edate) or a.statpers <= b.edate);
  create table work.ticker_link_bestscore as
  select ticker, statpers, fpedats, anndats_act, min(score) as bestscore
  from work.ticker_link_candidates
  group by ticker, statpers, fpedats, anndats_act;
  create table work.ticker_link_best as
  select a.*
  from work.ticker_link_candidates as a
  inner join work.ticker_link_bestscore as b
    on a.ticker=b.ticker and a.statpers=b.statpers
   and a.fpedats=b.fpedats and a.anndats_act=b.anndats_act
   and a.score=b.bestscore;
  create table work.ticker_link_unique as
  select ticker, statpers, fpedats, anndats_act,
         min(permno) as permno_out, min(score) as score
  from work.ticker_link_best
  group by ticker, statpers, fpedats, anndats_act
  having count(distinct permno)=1;
  create table work.ibes_permno as
  select a.*, b.permno_out as permno
  from work.ibes_last as a
  inner join work.ticker_link_unique as b
    on a.ticker=b.ticker and a.statpers=b.statpers
   and a.fpedats=b.fpedats and a.anndats_act=b.anndats_act;
quit;

/* PERMNO-to-GVKEY links are required to be valid at the IBES fiscal-period end. */
proc sql;
  create table work.ccm_candidates as
  select a.ticker, a.statpers, a.fpedats, a.anndats_act,
         a.meanest, a.actual, a.afe, a.permno, c.gvkey
  from work.ibes_permno as a
  inner join crsp.ccmxpf_linktable as c
    on a.permno=c.lpermno
   and (missing(c.linkdt) or a.fpedats >= c.linkdt)
   and (missing(c.linkenddt) or a.fpedats <= c.linkenddt)
   and c.linktype in ('LC','LU')
   and c.linkprim in ('P','C');
  create table work.ccm_unique as
  select ticker, statpers, fpedats, anndats_act,
         min(gvkey) as gvkey_out length=6
  from work.ccm_candidates
  group by ticker, statpers, fpedats, anndats_act
  having count(distinct gvkey)=1;
  create table work.ibes_gvkey as
  select a.*, b.gvkey_out as gvkey
  from work.ibes_permno as a
  inner join work.ccm_unique as b
    on a.ticker=b.ticker and a.statpers=b.statpers
   and a.fpedats=b.fpedats and a.anndats_act=b.anndats_act;
  create table work.ibes_comp_candidates as
  select a.*, c.fyear, c.datadate,
         abs(a.fpedats-c.datadate) as date_gap
  from work.ibes_gvkey as a
  inner join work.comp as c
    on a.gvkey=c.gvkey and abs(a.fpedats-c.datadate) <= 62;
  create table work.ibes_comp_mindate as
  select ticker, statpers, fpedats, anndats_act,
         min(date_gap) as min_gap
  from work.ibes_comp_candidates
  group by ticker, statpers, fpedats, anndats_act;
  create table work.ibes_comp_nearest as
  select a.*
  from work.ibes_comp_candidates as a
  inner join work.ibes_comp_mindate as b
    on a.ticker=b.ticker and a.statpers=b.statpers
   and a.fpedats=b.fpedats and a.anndats_act=b.anndats_act
   and a.date_gap=b.min_gap;
  create table work.ibes_comp_unique as
  select ticker, statpers, fpedats, anndats_act,
         min(gvkey) as gvkey_out length=6,
         min(fyear) as fyear_out,
         min(datadate) as datadate_out
  from work.ibes_comp_nearest
  group by ticker, statpers, fpedats, anndats_act
  having count(distinct gvkey)=1 and count(distinct fyear)=1;
  create table work.forecast_candidates as
  select b.gvkey_out as gvkey, b.fyear_out as fyear,
         a.ticker, a.statpers, a.fpedats,
         a.anndats_act, a.meanest, a.actual, a.afe
  from work.ibes_last as a
  inner join work.ibes_comp_unique as b
    on a.ticker=b.ticker and a.statpers=b.statpers
   and a.fpedats=b.fpedats and a.anndats_act=b.anndats_act;
  create table work.forecast_unique_key as
  select gvkey, fyear
  from work.forecast_candidates
  group by gvkey, fyear
  having count(*)=1;
  create table work.forecast as
  select a.gvkey, a.fyear, a.ticker, a.statpers, a.fpedats,
         a.anndats_act, a.meanest, a.actual, a.afe
  from work.forecast_candidates as a
  inner join work.forecast_unique_key as b
    on a.gvkey=b.gvkey and a.fyear=b.fyear;
quit;

proc sql noprint;
  select count(*) into :ibes_n trimmed from work.ibes_last;
  select count(*) into :ibes_link_n trimmed from work.ibes_permno;
  select count(*) into :ibes_gvkey_n trimmed from work.ibes_gvkey;
  select count(*) into :ibes_match_n trimmed from work.forecast;
  select count(*) into :ibes_dup trimmed
  from (select gvkey, fyear from work.forecast_candidates
        group by gvkey, fyear having count(*) > 1);
quit;
%put NOTE: IBES last-summary rows=&ibes_n ticker-PERMNO linked=&ibes_link_n GVKEY linked=&ibes_gvkey_n Compustat unique matches=&ibes_match_n ambiguous GVKEY-year keys excluded=&ibes_dup;

proc sql;
  create table work.measures_ibes as
  select a.*, b.afe, b.actual as ibes_actual,
         b.meanest as ibes_meanest, b.statpers as ibes_statpers,
         b.anndats_act as ibes_anndats_act
  from work.measures as a
  left join work.forecast as b
    on a.gvkey=b.gvkey and a.fyear=b.fyear;
quit;

/* Long target rows preserve separate no-EM calibration populations. A target
   row is EM=1/0 only in its stated narrow band; nonem=1 is outside the meet band. */
data work.target_rows;
  set work.measures_ibes;
  if fyear < 1994 or fyear > 2000 then delete;
  length target 8 em 8 nonem 8;

  target=1; em=.; nonem=.;
  if not missing(scaled_change) then do;
    if scaled_change >= 0 and scaled_change < .01 then do; em=1; nonem=0; end;
    else do;
      nonem=1;
      if scaled_change >= -.01 and scaled_change < 0 then em=0;
    end;
  end;
  output;

  target=2; em=.; nonem=.;
  if not missing(scaled_level) then do;
    if scaled_level >= 0 and scaled_level < .02 then do; em=1; nonem=0; end;
    else do;
      nonem=1;
      if scaled_level >= -.02 and scaled_level < 0 then em=0;
    end;
  end;
  output;

  target=3; em=.; nonem=.;
  if not missing(afe) then do;
    if afe >= 0 and afe <= .01 then do; em=1; nonem=0; end;
    else do;
      nonem=1;
      if afe >= -.01 and afe < 0 then em=0;
    end;
  end;
  output;
run;

/* Aggregate diagnostics show which target classifications and estimation
   support rows depend on prior-price coverage or currency conversion. */
proc sql;
  title 'Currency-sensitive target classification support';
  select target, count(*) as support_rows,
         sum(not missing(em)) as classified_rows,
         sum(target in (1,2) and missing(em) and missing(mve_l1)) as unclass_mve_missing,
         sum(target=1 and not missing(mve_l1) and not missing(ni)
             and missing(ni_l1_cur)) as t1_lagni_missing,
         sum(target=2 and not missing(scaled_level) and missing(ni_l1_cur)) as t2_level_lagni_missing,
         sum(target in (1,2) and missing(em) and missing(price_cur_l1)) as unclass_priceccy_missing,
         sum(target=1 and not missing(ni) and not missing(ni_l1) and not missing(csho_l1)
             and not missing(prcc_f_l1) and not missing(curcd) and missing(price_cur_l1)) as t1_priceccy_missing,
         sum(target=2 and not missing(ni) and not missing(csho_l1) and not missing(prcc_f_l1)
             and not missing(curcd) and missing(price_cur_l1)) as t2_priceccy_missing,
         sum(target=1 and not missing(ni) and not missing(ni_l1) and not missing(csho_l1)
             and not missing(prcc_f_l1) and not missing(curcd) and not missing(price_cur_l1)
             and curcd ne price_cur_l1 and missing(fx_dly_px)) as t1_pricefx_missing,
         sum(target=2 and not missing(ni) and not missing(csho_l1) and not missing(prcc_f_l1)
             and not missing(curcd) and not missing(price_cur_l1)
             and curcd ne price_cur_l1 and missing(fx_dly_px)) as t2_pricefx_missing,
         sum(target in (1,2) and not missing(curcd)
             and not missing(price_cur_l1) and curcd ne price_cur_l1) as market_price_currency_switch
  from work.target_rows group by target order by target;
  title;
quit;

/* Modified-Jones calibrations: OLS by target x SIC2 x year; Delta AR is left
   out of coefficient estimation and restored only in the prediction. */
proc sql;
  create table work.mj_train as
  select * from work.target_rows
  where fyear between 1994 and 2000 and nonem=1
    and nmiss(tacc, dsales, ppe)=0;
  create table work.mj_groups as
  select target, sic2, fyear, count(*) as n
  from work.mj_train
  group by target, sic2, fyear
  having count(*) >= 10;
  create table work.mj_train10 as
  select a.* from work.mj_train as a
  inner join work.mj_groups as b
    on a.target=b.target and a.sic2=b.sic2 and a.fyear=b.fyear;
quit;
proc sort data=work.mj_train10; by target sic2 fyear; run;
proc reg data=work.mj_train10 outest=work.mj_out noprint;
  by target sic2 fyear;
  model tacc = dsales ppe;
quit;
data work.mj_est;
  set work.mj_out;
  where _type_='PARMS';
  mj_alpha=Intercept;
  mj_bsales=dsales;
  mj_bppe=ppe;
  keep target sic2 fyear mj_alpha mj_bsales mj_bppe;
run;
proc sql;
  create table work.mj_scored as
  select a.*, b.mj_alpha, b.mj_bsales, b.mj_bppe,
    case when nmiss(a.tacc,a.dsales,a.delta_ar,a.ppe,
                    b.mj_alpha,b.mj_bsales,b.mj_bppe)=0
         then a.tacc-(b.mj_alpha+b.mj_bsales*(a.dsales-a.delta_ar)
                      +b.mj_bppe*a.ppe)
         else . end as abaccmj
  from work.target_rows as a
  left join work.mj_est as b
    on a.target=b.target and a.sic2=b.sic2 and a.fyear=b.fyear;
quit;

/* Forward-looking k and abnormal-accrual fits use the full adjacent-year
   history, target-specific non-EM rows, and a documented N>=10 choice. */
proc sql;
  create table work.k_train as
  select * from work.target_rows
  where fyear between 1994 and 1999 and nonem=1
    and nmiss(delta_ar, dsales)=0;
  create table work.k_groups as
  select target, sic2, fyear, count(*) as n
  from work.k_train
  group by target, sic2, fyear
  having count(*) >= 10;
  create table work.k_train10 as
  select a.* from work.k_train as a
  inner join work.k_groups as b
    on a.target=b.target and a.sic2=b.sic2 and a.fyear=b.fyear;
quit;
proc sort data=work.k_train10; by target sic2 fyear; run;
proc reg data=work.k_train10 outest=work.k_out noprint;
  by target sic2 fyear;
  model delta_ar = dsales;
quit;
data work.k_est;
  set work.k_out;
  where _type_='PARMS';
  k_raw=dsales;
  if missing(k_raw) then k=.;
  else if k_raw < 0 then k=0;
  else if k_raw > 1 then k=1;
  else k=k_raw;
  keep target sic2 fyear k k_raw;
run;

proc sql;
  create table work.fl_train as
  select * from work.target_rows
  where fyear between 1994 and 1999 and nonem=1
    and nmiss(tacc, dsales, ppe, lag_tacc, grsales)=0;
  create table work.fl_groups as
  select target, sic2, fyear, count(*) as n
  from work.fl_train
  group by target, sic2, fyear
  having count(*) >= 10;
  create table work.fl_train10 as
  select a.* from work.fl_train as a
  inner join work.fl_groups as b
    on a.target=b.target and a.sic2=b.sic2 and a.fyear=b.fyear;
quit;
proc sort data=work.fl_train10; by target sic2 fyear; run;
proc reg data=work.fl_train10 outest=work.fl_out noprint;
  by target sic2 fyear;
  model tacc = dsales ppe lag_tacc grsales;
quit;
data work.fl_est;
  set work.fl_out;
  where _type_='PARMS';
  fl_alpha=Intercept;
  fl_bsales=dsales;
  fl_bppe=ppe;
  fl_blag=lag_tacc;
  fl_bgrowth=grsales;
  keep target sic2 fyear fl_alpha fl_bsales fl_bppe fl_blag fl_bgrowth;
run;
proc sql;
  create table work.fl_scored as
  select a.*, b.k, b.k_raw,
         c.fl_alpha, c.fl_bsales, c.fl_bppe, c.fl_blag, c.fl_bgrowth,
    case when nmiss(a.tacc,a.dsales,a.delta_ar,a.ppe,a.lag_tacc,a.grsales,
                    b.k,c.fl_alpha,c.fl_bsales,c.fl_bppe,c.fl_blag,c.fl_bgrowth)=0
         then a.tacc-(c.fl_alpha+c.fl_bsales*(a.dsales-(1-b.k)*a.delta_ar)
                      +c.fl_bppe*a.ppe+c.fl_blag*a.lag_tacc
                      +c.fl_bgrowth*a.grsales)
         else . end as abaccfl
  from work.target_rows as a
  left join work.k_est as b
    on a.target=b.target and a.sic2=b.sic2 and a.fyear=b.fyear
  left join work.fl_est as c
    on a.target=c.target and a.sic2=c.sic2 and a.fyear=c.fyear;
quit;

/* Follow the explicit p. 504 narrative: candidate complete cases define the
   DTE percentile population, then |scaled accrual|<=1 is applied. Table 1's
   footnote instead describes percentile trimming by accrual measures too;
   see design.md for this unresolved source conflict. */
proc sql;
  create table work.mj_candidates as
  select * from work.mj_scored
  where fyear between 1994 and 2000
    and not missing(em) and not missing(dte) and not missing(tacc)
    and not missing(abaccmj) and not missing(sic2)
    and ((target=2 and not missing(cfo)) or (target ne 2 and not missing(dcfo)));
  create table work.fl_candidates as
  select * from work.fl_scored
  where fyear between 1994 and 1999
    and not missing(em) and not missing(dte) and not missing(tacc)
    and not missing(abaccfl) and not missing(sic2)
    and ((target=2 and not missing(cfo)) or (target ne 2 and not missing(dcfo)));
quit;
proc sql;
  title 'Currency transitions in model complete-case support';
  select 'Table2-3' as scope length=8, target, count(*) as complete_case_rows,
         sum(not missing(curcd) and not missing(curcd_l1) and curcd ne curcd_l1) as cp_switch,
         sum(not missing(curcd_l1) and not missing(curcd_l2) and curcd_l1 ne curcd_l2) as pp2_switch,
         sum(not missing(curcd) and not missing(curcd_f1) and curcd ne curcd_f1) as cf_switch,
         sum(not missing(curcd) and not missing(price_cur_l1) and curcd ne price_cur_l1) as price_switch,
         sum(not missing(curcd) and not missing(curcd_l1) and curcd ne curcd_l1
             and missing(fx_dly_l1)) as at_fx_unavailable,
         sum(not missing(curcd) and not missing(curcd_l1) and curcd ne curcd_l1
             and missing(fx_mth_l1)) as flow_fx_unavailable,
         sum(not missing(curcd_l1) and not missing(curcd_l2) and curcd_l1 ne curcd_l2
             and missing(fx_dly_l2)) as lagat_fx_unavailable,
         sum(not missing(curcd) and not missing(curcd_f1) and curcd ne curcd_f1
             and missing(fx_mth_f1)) as lead_fx_unavailable,
         sum(not missing(curcd) and not missing(price_cur_l1) and curcd ne price_cur_l1
             and missing(fx_dly_px)) as price_fx_unavailable
  from work.mj_candidates group by target order by target;
  select 'Table4' as scope length=8, target, count(*) as complete_case_rows,
         sum(not missing(curcd) and not missing(curcd_l1) and curcd ne curcd_l1) as cp_switch,
         sum(not missing(curcd_l1) and not missing(curcd_l2) and curcd_l1 ne curcd_l2) as pp2_switch,
         sum(not missing(curcd) and not missing(curcd_f1) and curcd ne curcd_f1) as cf_switch,
         sum(not missing(curcd) and not missing(price_cur_l1) and curcd ne price_cur_l1) as price_switch,
         sum(not missing(curcd) and not missing(curcd_l1) and curcd ne curcd_l1
             and missing(fx_dly_l1)) as at_fx_unavailable,
         sum(not missing(curcd) and not missing(curcd_l1) and curcd ne curcd_l1
             and missing(fx_mth_l1)) as flow_fx_unavailable,
         sum(not missing(curcd_l1) and not missing(curcd_l2) and curcd_l1 ne curcd_l2
             and missing(fx_dly_l2)) as lagat_fx_unavailable,
         sum(not missing(curcd) and not missing(curcd_f1) and curcd ne curcd_f1
             and missing(fx_mth_f1)) as lead_fx_unavailable,
         sum(not missing(curcd) and not missing(price_cur_l1) and curcd ne price_cur_l1
             and missing(fx_dly_px)) as price_fx_unavailable
  from work.fl_candidates group by target order by target;
  title;
quit;
proc means data=work.mj_candidates nway noprint;
  class target;
  var dte;
  output out=work.mj_dtecut p1(dte)=dte_p1 p99(dte)=dte_p99;
run;
proc means data=work.fl_candidates nway noprint;
  class target;
  var dte;
  output out=work.fl_dtecut p1(dte)=dte_p1 p99(dte)=dte_p99;
run;
proc sql;
  create table work.mj_final as
  select a.* from work.mj_candidates as a
  inner join work.mj_dtecut as b on a.target=b.target
  where a.dte >= b.dte_p1 and a.dte <= b.dte_p99
    and abs(a.tacc) <= 1 and abs(a.abaccmj) <= 1;
  create table work.fl_final as
  select a.* from work.fl_candidates as a
  inner join work.fl_dtecut as b on a.target=b.target
  where a.dte >= b.dte_p1 and a.dte <= b.dte_p99
    and abs(a.tacc) <= 1 and abs(a.abaccfl) <= 1;
quit;

/* Means and group Ns are retained as aggregate review diagnostics for the
   actual pre-Stata estimation samples; no firm-year rows are printed. */
proc means data=work.mj_final nway n mean std;
  class target em;
  var dte tacc abaccmj;
  title 'Descriptive statistics: Tables 2 and 3 handoff samples';
run;
proc means data=work.fl_final nway n mean std;
  class target em;
  var dte tacc abaccfl;
  title 'Descriptive statistics: Table 4 handoff samples';
run;
title;

proc sql;
  title 'Currency switches in final target handoffs';
  select 'Table2-3' as scope length=8, target, count(*) as handoff_n,
    sum(case when not missing(curcd) and not missing(curcd_l1) and curcd ne curcd_l1 then 1 else 0 end) as cp_switch,
    sum(case when not missing(curcd_l1) and not missing(curcd_l2) and curcd_l1 ne curcd_l2 then 1 else 0 end) as pp2_switch,
    sum(case when not missing(curcd) and not missing(curcd_f1) and curcd ne curcd_f1 then 1 else 0 end) as cf_switch,
    sum(case when not missing(curcd) and not missing(price_cur_l1) and curcd ne price_cur_l1 then 1 else 0 end) as price_ccy_switch
  from work.mj_final group by target order by target;
  select 'Table4' as scope length=8, target, count(*) as handoff_n,
    sum(case when not missing(curcd) and not missing(curcd_l1) and curcd ne curcd_l1 then 1 else 0 end) as cp_switch,
    sum(case when not missing(curcd_l1) and not missing(curcd_l2) and curcd_l1 ne curcd_l2 then 1 else 0 end) as pp2_switch,
    sum(case when not missing(curcd) and not missing(curcd_f1) and curcd ne curcd_f1 then 1 else 0 end) as cf_switch,
    sum(case when not missing(curcd) and not missing(price_cur_l1) and curcd ne price_cur_l1 then 1 else 0 end) as price_ccy_switch
  from work.fl_final group by target order by target;
  title 'Historical price route provenance at final handoff grain';
  select 'Table2-3' as scope length=8, target, price_status_group_l1,
         count(*) as handoff_n
  from work.mj_final
  group by target, price_status_group_l1 order by target, price_status_group_l1;
  select 'Table4' as scope length=8, target, price_status_group_l1,
         count(*) as handoff_n
  from work.fl_final
  group by target, price_status_group_l1 order by target, price_status_group_l1;
  title;
quit;

/* Final per-sample SAS handoffs; each firm-year key is checked by the runner. */
data outdata.table23_t1;
  set work.mj_final;
  where target=1;
  keep gvkey fyear target em dte tacc abaccmj dcfo cfo sic2;
  label em='EM1' dte='DTE' tacc='TAcc' abaccmj='Modified-Jones abnormal accruals'
        dcfo='Change in cash flows from operations' cfo='Cash flows from operations'
        sic2='Two-digit SIC';
run;
data outdata.table23_t2;
  set work.mj_final;
  where target=2;
  keep gvkey fyear target em dte tacc abaccmj dcfo cfo sic2;
  label em='EM2' dte='DTE' tacc='TAcc' abaccmj='Modified-Jones abnormal accruals'
        dcfo='Change in cash flows from operations' cfo='Cash flows from operations'
        sic2='Two-digit SIC';
run;
data outdata.table23_t3;
  set work.mj_final;
  where target=3;
  keep gvkey fyear target em dte tacc abaccmj dcfo cfo sic2;
  label em='EM3' dte='DTE' tacc='TAcc' abaccmj='Modified-Jones abnormal accruals'
        dcfo='Change in cash flows from operations' cfo='Cash flows from operations'
        sic2='Two-digit SIC';
run;
data outdata.table4_t1;
  set work.fl_final;
  where target=1;
  keep gvkey fyear target em dte tacc abaccfl dcfo cfo sic2;
  label em='EM1' dte='DTE' tacc='TAcc' abaccfl='Forward-looking abnormal accruals'
        dcfo='Change in cash flows from operations' cfo='Cash flows from operations'
        sic2='Two-digit SIC';
run;
data outdata.table4_t2;
  set work.fl_final;
  where target=2;
  keep gvkey fyear target em dte tacc abaccfl dcfo cfo sic2;
  label em='EM2' dte='DTE' tacc='TAcc' abaccfl='Forward-looking abnormal accruals'
        dcfo='Change in cash flows from operations' cfo='Cash flows from operations'
        sic2='Two-digit SIC';
run;
data outdata.table4_t3;
  set work.fl_final;
  where target=3;
  keep gvkey fyear target em dte tacc abaccfl dcfo cfo sic2;
  label em='EM3' dte='DTE' tacc='TAcc' abaccfl='Forward-looking abnormal accruals'
        dcfo='Change in cash flows from operations' cfo='Cash flows from operations'
        sic2='Two-digit SIC';
run;

proc sql;
  title 'Compustat source and row-key checks';
  select count(*) as comp_rows from work.comp;
  select count(*) as duplicate_firm_year_keys from
    (select gvkey, fyear from work.comp group by gvkey, fyear having count(*) > 1);
  title 'IBES linking attrition';
  select count(*) as ibes_last_summary_rows from work.ibes_last;
  select count(*) as ticker_permno_rows from work.ibes_permno;
  select count(*) as gvkey_linked_rows from work.ibes_gvkey;
  select count(*) as unique_compustat_forecasts from work.forecast;
  select count(*) as ambiguous_forecast_company_years from
    (select gvkey, fyear from work.forecast_candidates
     group by gvkey, fyear having count(*) > 1);
  title 'Auxiliary calibration groups';
  select count(*) as modified_jones_groups from work.mj_groups;
  select count(*) as forward_k_groups from work.k_groups;
  select count(*) as forward_accrual_groups from work.fl_groups;
  title 'Final sample sizes before Stata handoff';
  select target, count(*) as n from work.mj_final group by target order by target;
  select target, count(*) as n from work.fl_final group by target order by target;
quit;
title;
