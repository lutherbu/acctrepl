options errorabend;

libname fund "/storage/sas/base/comp/d_na" access=readonly;
libname fxsrc "/storage/sas/base/comp/d_global/currency" access=readonly;
libname secsrc "/storage/sas/base/comp/d_na/security" access=readonly;
libname segsrc "/storage/sas/base/comp/d_seghist" access=readonly;
libname ccm "/storage/sas/base/crsp/a_ccm" access=readonly;
libname crspst "/storage/sas/base/crsp/a_stock" access=readonly;
libname outdat "data";

title "W2105094056 A1 source and sample diagnostics";

proc sql;
  create table work.funda_raw as
  select gvkey, datadate, fyear, fyr, curcd, indfmt, consol, popsrc, datafmt,
         gdwl, gdwlip, spi, at, oiadp, ceq, prcc_f, csho, iid, hiid
  from fund.funda
  where fyear between 1994 and 2011
    and indfmt="INDL" and datafmt="STD" and consol="C" and popsrc="D";

  select count(*) as raw_funda_rows,
         count(distinct gvkey) as raw_funda_firms,
         min(fyear) as min_fyear, max(fyear) as max_fyear,
         min(datadate) format=date9. as min_date,
         max(datadate) format=date9. as max_date,
         sum(year(datadate) ne fyear) as calendar_label_differences
  from work.funda_raw;

  create table work.dup_fy as
  select gvkey, fyear, count(*) as n_rows,
         count(distinct datadate) as n_dates
  from work.funda_raw
  group by gvkey, fyear
  having calculated n_rows>1;
  select count(*) as duplicate_fy_keys,
         sum(n_rows) as rows_in_duplicate_keys,
         sum(n_dates>1) as keys_with_multiple_dates
  from work.dup_fy;

  create table work.dup_date as
  select gvkey, fyear, datadate, count(*) as n_rows
  from work.funda_raw
  group by gvkey, fyear, datadate
  having calculated n_rows>1;
  select count(*) as duplicate_same_date_keys
  from work.dup_date;
quit;

proc sort data=work.funda_raw out=work.funda_sorted;
  by gvkey fyear datadate;
run;

data work.funda;
  set work.funda_sorted;
  by gvkey fyear;
  if last.fyear;
run;

proc sql;
  select count(*) as selected_funda_rows,
         count(distinct gvkey) as selected_firms,
         min(datadate) format=date9. as min_date,
         max(datadate) format=date9. as max_date
  from work.funda;
quit;

/* Aggregate GBP-intermediary quotes without selecting by quote provenance. */
proc sql;
  create table work.fx_dly0 as
  select datadate, upcase(strip(tocurd)) as tocur length=3,
         min(exratd) as min_rate, max(exratd) as max_rate,
         count(*) as n_quotes, count(distinct exratd) as n_rates,
         count(distinct exrattpd) as n_types
  from fxsrc.g_exrt_dly
  where datadate between "01JAN1993"d and "31DEC2013"d
    and upcase(strip(fromcurd))="GBP"
  group by datadate, calculated tocur;

  create table work.fx_dly as
  select datadate, tocur,
         case when n_rates=1 and min_rate>0 then min_rate else . end as rate,
         n_quotes, n_rates, n_types
  from work.fx_dly0;

  select sum(n_rates>1) as conflicting_daily_pairs,
         sum(n_rates=1 and n_quotes>1) as repeated_same_daily_pairs,
         sum(n_types>1) as daily_pairs_with_multiple_types
  from work.fx_dly0;

  create table work.fx_mth0 as
  select year(datadate)*100+month(datadate) as ym,
         upcase(strip(tocurm)) as tocur length=3,
         min(exrat12m) as min12, max(exrat12m) as max12,
         count(distinct exrat12m) as n12,
         min(exrat1m) as min1, max(exrat1m) as max1,
         count(distinct exrat1m) as n1,
         count(*) as n_quotes
  from fxsrc.g_exrt_mth
  where datadate between "01JAN1993"d and "31DEC2013"d
    and upcase(strip(fromcurm))="GBP"
  group by calculated ym, calculated tocur;

  create table work.fx_mth as
  select ym, tocur,
         case when n12=1 and min12>0 then min12 else . end as rate12,
         case when n1=1 and min1>0 then min1 else . end as rate1,
         n12, n1, n_quotes
  from work.fx_mth0;

  select sum(n12>1) as conflicting_12m_pairs,
         sum(n1>1) as conflicting_1m_pairs,
         sum(n12=1 and n_quotes>1) as repeated_12m_pairs,
         sum(n1=1 and n_quotes>1) as repeated_1m_pairs
  from work.fx_mth0;
quit;

proc sql;
  create table work.funda_fx as
  select a.*,
         d1.rate as fx_d_cur, d2.rate as fx_d_usd,
         m1.rate12 as fx_m_cur12, m2.rate12 as fx_m_usd12,
         m1.rate1 as fx_m_cur1, m2.rate1 as fx_m_usd1
  from work.funda as a
  left join work.fx_dly as d1
    on a.datadate=d1.datadate and upcase(strip(a.curcd))=d1.tocur
  left join work.fx_dly as d2
    on a.datadate=d2.datadate and d2.tocur="USD"
  left join work.fx_mth as m1
    on year(a.datadate)*100+month(a.datadate)=m1.ym
   and upcase(strip(a.curcd))=m1.tocur
  left join work.fx_mth as m2
    on year(a.datadate)*100+month(a.datadate)=m2.ym
   and m2.tocur="USD";
quit;

data work.funda_usd;
  set work.funda_fx;
  length fx_status $12;
  fx_stock=.;
  fx_flow=.;
  fx_price=.;
  if upcase(strip(curcd))="USD" then do;
    fx_stock=1;
    fx_flow=1;
    fx_price=1;
    fx_status="USD";
  end;
  else if upcase(strip(curcd))="GBP" then do;
    if not missing(fx_d_usd) and fx_d_usd>0 then fx_stock=fx_d_usd;
    if not missing(fx_m_usd12) and fx_m_usd12>0 then fx_flow=fx_m_usd12;
    if not missing(fx_m_usd1) and fx_m_usd1>0 then fx_price=fx_m_usd1;
    fx_status="GBP_SOURCE";
  end;
  else do;
    if not missing(fx_d_cur) and not missing(fx_d_usd)
       and fx_d_cur>0 and fx_d_usd>0 then fx_stock=fx_d_usd/fx_d_cur;
    if not missing(fx_m_cur12) and not missing(fx_m_usd12)
       and fx_m_cur12>0 and fx_m_usd12>0 then fx_flow=fx_m_usd12/fx_m_cur12;
    if not missing(fx_m_cur1) and not missing(fx_m_usd1)
       and fx_m_cur1>0 and fx_m_usd1>0 then fx_price=fx_m_usd1/fx_m_cur1;
    if missing(curcd) then fx_status="NO_CURCD";
    else fx_status="CROSS_RATE";
  end;
  gdwl_usd=.;
  at_usd=.;
  ceq_usd=.;
  spi_usd=.;
  oiadp_usd=.;
  if not missing(gdwl) and not missing(fx_stock) then gdwl_usd=gdwl*fx_stock;
  if not missing(at) and not missing(fx_stock) then at_usd=at*fx_stock;
  if not missing(ceq) and not missing(fx_stock) then ceq_usd=ceq*fx_stock;
  if not missing(spi) and not missing(fx_flow) then spi_usd=spi*fx_flow;
  if not missing(oiadp) and not missing(fx_flow) then oiadp_usd=oiadp*fx_flow;
run;

/* A stable CAD balance should not look impaired only because FX moved. */
data work.stable_goodwill_fx_check;
  length curcd $3 check_status $4;
  curcd="CAD";
  gdwl_tm1=100;
  gdwl_t=100;
  fx_tm1_usd=0.80;
  fx_t_usd=0.75;
  raw_decrease=gdwl_tm1-gdwl_t;
  naive_usd_decrease=gdwl_tm1*fx_tm1_usd-gdwl_t*fx_t_usd;
  if raw_decrease=0 and abs(naive_usd_decrease-5)<1e-10 then check_status="PASS";
  else check_status="FAIL";
  label raw_decrease="Same-currency decrease used by the impairment rule"
        naive_usd_decrease="Apparent USD decrease from FX movement"
        check_status="Bounded stable-goodwill FX check";
run;
proc print data=work.stable_goodwill_fx_check noobs label;
  var curcd gdwl_tm1 gdwl_t fx_tm1_usd fx_t_usd raw_decrease naive_usd_decrease check_status;
run;

/* The date-specific primary monthly price is only a currency check for PRCC_F. */
proc sql;
  create table work.secprim0 as
  select p.gvkey, p.iid, p.datadate,
         count(*) as n_rows,
         count(distinct upcase(strip(p.curcdm))) as n_cur,
         count(distinct p.prccm) as n_price,
         max(upcase(strip(p.curcdm))) as curcdm length=3,
         max(p.prccm) as prccm
  from secsrc.sec_mthprc as p
  inner join secsrc.sec_mth as d
    on p.gvkey=d.gvkey and p.iid=d.iid and p.datadate=d.datadate
  where d.primiss="P"
    and p.datadate between "01JAN1993"d and "31DEC2013"d
  group by p.gvkey, p.iid, p.datadate;

  create table work.price_join as
  select a.*,
         p.iid as price_iid, p.curcdm, p.prccm,
         p.n_rows as price_rows, p.n_cur, p.n_price,
         s.rate1 as fx_pricecur1
  from work.funda_usd as a
  left join work.secprim0 as p
    on a.gvkey=p.gvkey
   and year(a.datadate)=year(p.datadate)
   and month(a.datadate)=month(p.datadate)
   and strip(a.hiid)=strip(p.iid)
  left join work.fx_mth as s
    on year(a.datadate)*100+month(a.datadate)=s.ym
   and p.curcdm=s.tocur;
quit;

data work.funda_price;
  set work.price_join;
  length price_curcd $3;
  price_verified=0;
  price_curcd="";
  prcc_f_usd=.;
  mve_usd=.;
  fx_sec1=.;
  fx_rep1=.;
  if not missing(price_iid) and n_cur=1 and n_price=1
     and not missing(curcdm) and not missing(prccm)
     and not missing(prcc_f) then do;
    if curcdm=upcase(strip(curcd)) then do;
      if abs(prcc_f-prccm)<=0.005 then do;
        price_verified=1;
        price_curcd=curcdm;
      end;
    end;
    else do;
      if curcdm="GBP" then fx_sec1=1;
      else if not missing(fx_pricecur1) and fx_pricecur1>0 then fx_sec1=fx_pricecur1;
      if upcase(strip(curcd))="GBP" then fx_rep1=1;
      else if not missing(fx_m_cur1) and fx_m_cur1>0 then fx_rep1=fx_m_cur1;
      if not missing(fx_sec1) and not missing(fx_rep1) then do;
        if abs(prcc_f-prccm*fx_rep1/fx_sec1)<=0.005 then do;
          price_verified=1;
          price_curcd=upcase(strip(curcd));
        end;
        else if abs(prcc_f-prccm)<=0.005 then do;
          price_verified=1;
          price_curcd=curcdm;
        end;
      end;
    end;
  end;
  if price_verified=1 and not missing(csho) and csho>0 and prcc_f>0 then do;
    if price_curcd="USD" then prcc_f_usd=prcc_f;
    else if price_curcd="GBP" then do;
      if not missing(fx_m_usd1) and fx_m_usd1>0 then prcc_f_usd=prcc_f*fx_m_usd1;
    end;
    else if price_curcd=upcase(strip(curcd)) then do;
      if not missing(fx_price) and fx_price>0 then prcc_f_usd=prcc_f*fx_price;
    end;
    else if price_curcd=curcdm then do;
      if curcdm="GBP" then do;
        if not missing(fx_m_usd1) and fx_m_usd1>0 then prcc_f_usd=prcc_f*fx_m_usd1;
      end;
      else if not missing(fx_pricecur1) and not missing(fx_m_usd1)
           and fx_pricecur1>0 and fx_m_usd1>0 then
        prcc_f_usd=prcc_f*fx_m_usd1/fx_pricecur1;
    end;
    if not missing(prcc_f_usd) then mve_usd=prcc_f_usd*csho;
  end;
  btm=.;
  btmg1=.;
  if not missing(ceq) and not missing(csho) and csho>0
     and not missing(prcc_f) and prcc_f>0 and price_verified=1 then do;
    if upcase(strip(price_curcd))=upcase(strip(curcd)) then
      btm=ceq/(prcc_f*csho);
    else if not missing(ceq_usd) and not missing(mve_usd) and mve_usd>0 then
      btm=ceq_usd/mve_usd;
  end;
  if not missing(btm) then do;
    btmg1=(btm>1);
  end;
run;

proc sql;
  select count(*) as annual_price_rows,
         sum(price_verified=1) as verified_price_rows,
         sum(price_verified=0) as unverified_price_rows,
         sum(price_verified=1 and missing(prcc_f_usd)) as verified_price_fx_missing,
         sum(not missing(btmg1)) as observed_btmg1_rows
  from work.funda_price;
  select curcd, price_curcd,
         count(*) as observations,
         sum(price_verified=1) as verified,
         sum(price_verified=1 and not missing(btmg1)) as btm_observed
  from work.funda_price
  group by curcd, price_curcd order by curcd, price_curcd;
quit;

/* One segment type and one latest source-date vintage per GVKEY/DATADATE. */
proc sql;
  create table work.seg_raw as
  select s.gvkey, s.datadate, s.srcdate, upcase(strip(s.stype)) as stype length=9,
         s.sid
  from segsrc.wrds_segmerged as s
  inner join work.funda as f
    on s.gvkey=f.gvkey and s.datadate=f.datadate
  where upcase(strip(s.stype)) in ("BUSSEG","OPSEG");

  create table work.seg_vintage as
  select gvkey, datadate, stype, max(srcdate) as chosen_srcdate format=date9.,
         count(distinct srcdate) as n_vintages
  from work.seg_raw
  group by gvkey, datadate, stype;

  create table work.seg_count as
  select v.gvkey, v.datadate, v.stype, v.chosen_srcdate, v.n_vintages,
         count(distinct s.sid) as n_segments,
         sum(missing(s.sid)) as n_missing_sid
  from work.seg_vintage as v
  left join work.seg_raw as s
    on v.gvkey=s.gvkey and v.datadate=s.datadate and v.stype=s.stype
   and ((v.chosen_srcdate=s.srcdate)
        or (missing(v.chosen_srcdate) and missing(s.srcdate)))
  group by v.gvkey, v.datadate, v.stype, v.chosen_srcdate, v.n_vintages;
quit;

data work.seg_count;
  set work.seg_count;
  if missing(chosen_srcdate) or n_missing_sid>0 or n_segments=0 then n_segments=.;
run;

proc sql;
  select stype, count(*) as firm_dates,
         sum(n_vintages>1) as multiple_vintages,
         sum(missing(n_segments)) as unknown_counts,
         max(n_vintages) as max_vintages
  from work.seg_count group by stype order by stype;
  create table work.seg_pair as
  select t.gvkey, t.fyear,
         case when not missing(bt.n_segments) and not missing(bp.n_segments) then "BUSSEG"
              when not missing(ot.n_segments) and not missing(op.n_segments) then "OPSEG"
              else "" end as segtype length=9,
         case when not missing(bt.n_segments) and not missing(bp.n_segments) then bt.n_segments
              when not missing(ot.n_segments) and not missing(op.n_segments) then ot.n_segments
              else . end as seg_t,
         case when not missing(bt.n_segments) and not missing(bp.n_segments) then bp.n_segments
              when not missing(ot.n_segments) and not missing(op.n_segments) then op.n_segments
              else . end as seg_tm1
  from work.funda as t
  left join work.funda as p
    on t.gvkey=p.gvkey and p.fyear=t.fyear-1
  left join work.seg_count as bt
    on t.gvkey=bt.gvkey and t.datadate=bt.datadate and bt.stype="BUSSEG"
  left join work.seg_count as bp
    on p.gvkey=bp.gvkey and p.datadate=bp.datadate and bp.stype="BUSSEG"
  left join work.seg_count as ot
    on t.gvkey=ot.gvkey and t.datadate=ot.datadate and ot.stype="OPSEG"
  left join work.seg_count as op
    on p.gvkey=op.gvkey and p.datadate=op.datadate and op.stype="OPSEG"
  where t.fyear between 1996 and 2011;
quit;

/* Effective common-stock link at the fiscal date, then a CRSP return row by that date. */
proc sql;
  create table work.crsp_link as
  select distinct f.gvkey, f.fyear, f.datadate, c.lpermno,
         c.linkprim, c.linktype, n.shrcd, n.exchcd
  from work.funda as f
  inner join ccm.ccmxpf_linktable as c
    on f.gvkey=c.gvkey
   and (c.linkdt=.B or (not missing(c.linkdt) and c.linkdt<=f.datadate))
   and (c.linkenddt=.E or (not missing(c.linkenddt) and c.linkenddt>=f.datadate))
   and c.linkprim in ("P","C") and c.linktype in ("LC","LU")
  inner join crspst.msenames as n
    on c.lpermno=n.permno
   and (n.namedt=.B or (not missing(n.namedt) and n.namedt<=f.datadate))
   and (n.nameendt=.E or (not missing(n.nameendt) and n.nameendt>=f.datadate))
   and n.shrcd in (10,11);

  select count(*) as effective_common_link_rows,
         count(distinct gvkey) as linked_firms
  from work.crsp_link;

  create table work.crsp_present as
  select distinct a.gvkey, a.fyear
  from work.crsp_link as a
  inner join crspst.msf as m
    on a.lpermno=m.permno
   and m.date<=a.datadate
   and m.date>=intnx("month",a.datadate,-12,"same")
   and not missing(m.ret);

  select fyear, count(*) as firm_years
  from work.crsp_present group by fyear order by fyear;
quit;

/* Attach exact t-1/t-2 annual rows and same-type segment counts. */
proc sql;
  create table work.panel_hist as
  select t.gvkey, t.fyear, t.datadate,
         t.gdwl as gdwl_t, t.gdwl_usd as gdwl_t_usd, t.gdwlip as gdwlip_t,
         t.spi as spi_t, t.spi_usd as spi_t_usd, t.curcd as curcd_t,
         p.datadate as date_tm1 format=date9.,
         p.gdwl as gdwl_tm1, p.gdwl_usd as gdwl_tm1_usd,
         p.at as at_tm1, p.at_usd as at_tm1_usd,
         p.oiadp as oiadp_tm1, p.oiadp_usd as oiadp_tm1_usd,
         p.curcd as curcd_tm1,
         p.ceq_usd as ceq_tm1_usd, p.csho as csho_tm1,
         p.prcc_f_usd as prccf_tm1_usd, p.btm as btm_tm1,
         p.btmg1 as btmg1_tm1, p.price_verified as price_ok_tm1,
         p.price_curcd as price_curcd,
         q.datadate as date_tm2 format=date9.,
         q.at as at_tm2, q.at_usd as at_tm2_usd, q.curcd as curcd_tm2,
         s.segtype, s.seg_t, s.seg_tm1
  from work.funda_usd as t
  left join work.funda_price as p
    on t.gvkey=p.gvkey and p.fyear=t.fyear-1
  left join work.funda_usd as q
    on t.gvkey=q.gvkey and q.fyear=t.fyear-2
  left join work.seg_pair as s
    on t.gvkey=s.gvkey and t.fyear=s.fyear;
quit;

data work.panel_inputs;
  set work.panel_hist;
  length spi_unknown 3 divest 3;
  length goodwill_basis $9;
  gdwl_drop_basis=.;
  gdwl_begin_basis=.;
  spi_basis=.;
  goodwill_basis="";
  same_gw_currency=(not missing(curcd_t) and not missing(curcd_tm1)
                    and upcase(strip(curcd_t))=upcase(strip(curcd_tm1)));
  if same_gw_currency=1 and not missing(gdwl_tm1) and not missing(gdwl_t) then do;
    gdwl_begin_basis=gdwl_tm1;
    gdwl_drop_basis=gdwl_tm1-gdwl_t;
    spi_basis=spi_t;
    goodwill_basis="REPORTING";
  end;
  else if not missing(curcd_t) and not missing(curcd_tm1)
       and not missing(gdwl_tm1_usd) and not missing(gdwl_t_usd) then do;
    gdwl_begin_basis=gdwl_tm1_usd;
    gdwl_drop_basis=gdwl_tm1_usd-gdwl_t_usd;
    spi_basis=spi_t_usd;
    goodwill_basis="USD_MIXED";
  end;
  divest=.;
  spi_unknown=0;
  if not missing(seg_t) and not missing(seg_tm1)
     and not missing(gdwl_drop_basis) then do;
    divest=(seg_t<seg_tm1 and gdwl_drop_basis>0);
  end;

  gta_tm1=.;
  if not missing(gdwl_tm1) and not missing(at_tm1) and at_tm1>0 then
    gta_tm1=gdwl_tm1/at_tm1;
  avg_at_tm1=.;
  if not missing(curcd_tm1) and not missing(curcd_tm2)
     and upcase(strip(curcd_tm1))=upcase(strip(curcd_tm2))
     and not missing(at_tm1) and not missing(at_tm2) then
    avg_at_tm1=(at_tm1+at_tm2)/2;
  else if not missing(curcd_tm1) and not missing(curcd_tm2)
     and not missing(at_tm1_usd) and not missing(at_tm2_usd) then
    avg_at_tm1=(at_tm1_usd+at_tm2_usd)/2;
  roa_tm1=.;
  if not missing(curcd_tm1) and not missing(curcd_tm2)
     and upcase(strip(curcd_tm1))=upcase(strip(curcd_tm2))
     and not missing(oiadp_tm1) and not missing(avg_at_tm1) and avg_at_tm1>0 then
    roa_tm1=oiadp_tm1/avg_at_tm1;
  else if not missing(curcd_tm1) and not missing(curcd_tm2)
     and not missing(oiadp_tm1_usd) and not missing(avg_at_tm1) and avg_at_tm1>0 then
    roa_tm1=oiadp_tm1_usd/avg_at_tm1;
  imppi=.;
  if not missing(gta_tm1) and not missing(roa_tm1) then do;
    if gta_tm1>0.10 and roa_tm1<0 then imppi=1;
    else if gta_tm1<0.05 and roa_tm1>0.05 then imppi=-1;
    else imppi=0;
  end;
  btmg1=btmg1_tm1;

  e_impdum=.;
  if not missing(gdwl_t) and not missing(gdwl_tm1) and not missing(gdwl_drop_basis) then do;
    if fyear<=2000 then threshold=0.05;
    else threshold=0;
    if gdwl_drop_basis<=threshold*gdwl_begin_basis then e_impdum=0;
    else if missing(spi_basis) then do;
      e_impdum=.;
      spi_unknown=1;
    end;
    else do;
      spi_unknown=0;
      e_impdum=(spi_basis<0 and -spi_basis>=gdwl_drop_basis);
    end;
  end;
  else spi_unknown=.;

  comp_impdum=.;
  if fyear>=2004 and not missing(gdwl_tm1) and gdwl_tm1>0 then do;
    if missing(gdwlip_t) then comp_impdum=0;
    else comp_impdum=(gdwlip_t ne 0);
  end;
run;

proc sql;
  select fyear, count(*) as history_firm_years,
         sum(missing(gdwl_tm1_usd)) as missing_begin_gdwl,
         sum(missing(gdwl_t_usd)) as missing_current_gdwl,
         sum(missing(spi_t_usd)) as missing_spi,
         sum(missing(seg_t) or missing(seg_tm1)) as unknown_segment_pair,
         sum(divest=1) as both_decline_exclusions
  from work.panel_inputs
  where fyear between 1996 and 2011
  group by fyear order by fyear;
quit;

proc sql;
  create table work.analysis as
  select a.*
  from work.panel_inputs as a
  inner join work.crsp_present as c
    on a.gvkey=c.gvkey and a.fyear=c.fyear
  where (a.fyear between 1996 and 2000 or a.fyear between 2004 and 2011)
    and a.gdwl_tm1>0
    and coalesce(a.divest,0) ne 1;
quit;

data outdat.goodwill_panel_19290;
  set work.analysis;
  length pre_period post_period 3;
  pre_period=(fyear>=1996 and fyear<=2000);
  post_period=(fyear>=2004 and fyear<=2011);
  label gvkey="Compustat GVKEY"
        fyear="Fiscal year"
        e_impdum="Estimated goodwill impairment indicator"
        comp_impdum="Compustat goodwill impairment indicator"
        imppi="Financial impairment indicator at t-1"
        btmg1="Book-to-market greater than one at t-1"
        gta_tm1="Goodwill to assets at t-1"
        roa_tm1="Operating income after depreciation / average assets at t-1"
        btm_tm1="Book-to-market at t-1"
        gdwl_drop_basis="Goodwill decrease in a common currency basis"
        goodwill_basis="Currency basis for goodwill/SPI comparison"
        segtype="Comparable segment count type"
        seg_t="Segment count at t"
        seg_tm1="Segment count at t-1"
        divest="Segment and goodwill decline screen"
        spi_unknown="SPI missing when thresholded goodwill drop is present"
        price_ok_tm1="Fiscal close price currency and primary issue verified";
  keep gvkey fyear datadate pre_period post_period e_impdum comp_impdum imppi btmg1
       gta_tm1 roa_tm1 btm_tm1 gdwl_drop_basis goodwill_basis segtype seg_t seg_tm1 divest
       spi_unknown price_ok_tm1 price_curcd;
run;

proc sql;
  select fyear, count(*) as positive_beginning_gw_crsp,
         sum(divest=1) as divest_excluded,
         sum(not missing(e_impdum)) as estimated_outcome_observed,
         sum(e_impdum=1) as estimated_impairments,
         sum(missing(e_impdum)) as estimated_outcome_unknown,
         sum(not missing(comp_impdum)) as reported_outcome_observed,
         sum(comp_impdum=1) as reported_impairments,
         sum(not missing(imppi)) as imppi_observed,
         sum(not missing(btmg1)) as btmg1_observed
  from outdat.goodwill_panel_19290
  group by fyear order by fyear;

  select pre_period, post_period, count(*) as sample_rows,
         sum(missing(e_impdum)) as missing_estimated_outcome,
         sum(missing(comp_impdum)) as missing_reported_outcome,
         sum(missing(imppi)) as missing_imppi,
         sum(missing(btmg1)) as missing_btmg1,
         sum(price_ok_tm1=1) as verified_lag_prices
  from outdat.goodwill_panel_19290
  group by pre_period, post_period order by pre_period, post_period;
quit;

proc contents data=outdat.goodwill_panel_19290 varnum;
run;

title;
