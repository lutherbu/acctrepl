options errorabend;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname compg "/storage/sas/base/comp/d_global/currency" access=readonly;
libname cstock "/storage/sas/base/crsp/a_stock" access=readonly;
libname ccm "/storage/sas/base/crsp/a_ccm" access=readonly;
libname outdata "data";

/* Source product filters and the complete support/lead history. */
proc sql;
  create table work.funda_raw as
  select gvkey, datadate, fyear, fyr, indfmt, consol, popsrc, datafmt,
         curcd, sich, epspx, ib, oancf, at, sale, ppegt, ajex, csho,
         prcc_f, mkvalt, fdate, apdedate
  from comp.funda
  where fyear between 1987 and 2003
    and upcase(strip(indfmt))='INDL'
    and upcase(strip(consol))='C'
    and upcase(strip(popsrc))='D'
    and upcase(strip(datafmt))='STD'
    and not missing(gvkey)
    and not missing(datadate)
    and not missing(fyear)
    and not missing(sich)
    and not (sich between 4000 and 4999)
    and not (sich between 6000 and 6999)
  order by gvkey, fyear, datadate, fdate;
quit;

proc sql noprint;
  select count(*) into :n_funda trimmed from work.funda_raw;
  select count(*) into :n_fdup trimmed
  from (select gvkey, fyear from work.funda_raw
        group by gvkey, fyear having count(*) > 1);
quit;
%put NOTE: Selected COMP.FUNDA rows=&n_funda, duplicate GVKEY-fyear groups after product/sector screens=&n_fdup;

/* The 2004 provider guide maps annual flow items to the 12-month average rate,
   and balance-sheet items to the daily rate. Both transformations use the
   provider's GBP-primary cross-rate formula and exact reporting dates. */
data work.fx_mth_src;
  set compg.g_exrt_mth(keep=datadate fromcurm tocurm exrat12m);
  where datadate between '01jan1987'd and '31dec2004'd
    and upcase(strip(fromcurm))='GBP'
    and not missing(tocurm)
    and not missing(exrat12m)
    and exrat12m > 0;
  tocurm=upcase(strip(tocurm));
  rate=exrat12m;
run;
proc sql;
  create table work.fx_mth_u as
  select datadate, tocurm, min(rate) as rate
  from work.fx_mth_src
  group by datadate, tocurm
  having count(*)=1;
  create table work.fx_mth_usd as
  select datadate, rate as rate_usd
  from work.fx_mth_u
  where tocurm='USD';
quit;

/* Rate key duplicates remain unavailable instead of selecting a rate type or row. */
proc sql noprint;
  select count(*) into :n_mdup trimmed from
    (select datadate,tocurm from work.fx_mth_src
     group by datadate,tocurm having count(*)>1);
quit;
%put NOTE: Monthly GBP cross-rate duplicate date-currency keys=&n_mdup;

data work.fx_dly_src;
  set compg.g_exrt_dly(keep=datadate fromcurd tocurd exratd exrattpd);
  where datadate between '01jan1987'd and '31dec2004'd
    and upcase(strip(fromcurd))='GBP'
    and not missing(tocurd)
    and not missing(exratd)
    and exratd > 0;
  tocurd=upcase(strip(tocurd));
  rate=exratd;
run;
proc sql;
  create table work.fx_dly_u as
  select datadate, tocurd, min(rate) as rate
  from work.fx_dly_src
  group by datadate, tocurd
  having count(*)=1;
  create table work.fx_dly_usd as
  select datadate, rate as rate_usd
  from work.fx_dly_u
  where tocurd='USD';
quit;
proc sql noprint;
  select count(*) into :n_ddup trimmed from
    (select datadate,tocurd from work.fx_dly_src
     group by datadate,tocurd having count(*)>1);
quit;
%put NOTE: Daily GBP cross-rate duplicate date-currency keys=&n_ddup;

proc sql;
  create table work.funda_rate as
  select a.*,
         case
           when upcase(strip(a.curcd))='USD' then 1
           when upcase(strip(a.curcd))='GBP' then u.rate_usd
           when not missing(c.rate) and c.rate>0 and not missing(u.rate_usd) and u.rate_usd>0
             then u.rate_usd/c.rate
           else . end as fx_flow,
         case
           when upcase(strip(a.curcd))='USD' then 1
           when upcase(strip(a.curcd))='GBP' then v.rate_usd
           when not missing(d.rate) and d.rate>0 and not missing(v.rate_usd) and v.rate_usd>0
             then v.rate_usd/d.rate
           else . end as fx_bs
  from work.funda_raw as a
  left join work.fx_mth_u as c
    on a.datadate=c.datadate and upcase(strip(a.curcd))=c.tocurm
  left join work.fx_mth_usd as u
    on a.datadate=u.datadate
  left join work.fx_dly_u as d
    on a.datadate=d.datadate and upcase(strip(a.curcd))=d.tocurd
  left join work.fx_dly_usd as v
    on a.datadate=v.datadate;
quit;

data work.funda_usd;
  set work.funda_rate;
  sic2=floor(sich/100);
  ib_usd=ib*fx_flow;
  cfo_usd=oancf*fx_flow;
  sale_usd=sale*fx_flow;
  eps_usd=epspx*fx_flow;
  at_usd=at*fx_bs;
  ppe_usd=ppegt*fx_bs;
  length flow_stat bs_stat $12;
  if missing(curcd) then do; flow_stat='NO_CURCD'; bs_stat='NO_CURCD'; end;
  else if upcase(strip(curcd)) in ('USD') then do; flow_stat='USD_DIRECT'; bs_stat='USD_DIRECT'; end;
  else if upcase(strip(curcd))='GBP' then do;
    if not missing(fx_flow) then flow_stat='GBP_USD'; else flow_stat='NO_RATE';
    if not missing(fx_bs) then bs_stat='GBP_USD'; else bs_stat='NO_RATE';
  end;
  else do;
    if not missing(fx_flow) then flow_stat='FX_MATCH'; else flow_stat='NO_RATE';
    if not missing(fx_bs) then bs_stat='FX_MATCH'; else bs_stat='NO_RATE';
  end;
run;
proc freq data=work.funda_usd;
  tables curcd*flow_stat curcd*bs_stat / missing;
run;
proc sql noprint;
  select count(*) into :n_curmiss trimmed from work.funda_usd where missing(curcd);
  select count(*) into :n_flowmiss trimmed from work.funda_usd where not missing(ib) and missing(fx_flow);
  select count(*) into :n_bsmiss trimmed from work.funda_usd where not missing(at) and missing(fx_bs);
quit;
%put NOTE: Missing reporting currency rows=&n_curmiss, observed income without unique FX=&n_flowmiss, observed assets without unique FX=&n_bsmiss;

/* The source filters should yield a single current report row per GVKEY-year.
   Do not conceal a surviving revision or frequency conflict. */
proc sql noprint;
  select count(*) into :n_fdup2 trimmed
  from (select gvkey, fyear from work.funda_usd
        group by gvkey, fyear having count(*) > 1);
quit;
%put NOTE: Final translated Compustat duplicate GVKEY-fyear groups=&n_fdup2;
data _null_;
  if &n_fdup2 > 0 then do;
    put "ERROR: Resolve current Compustat GVKEY-fyear report-vintage ambiguity before construction.";
    abort cancel;
  end;
run;

/* Exact fiscal-year joins preserve genuine gaps and use converted amounts. */
proc sql;
  create table work.hist as
  select a.gvkey, a.datadate, a.fyear, a.fyr, a.sic2, a.curcd, a.ajex,
         a.epspx, a.eps_usd, a.ib_usd, a.cfo_usd, a.sale_usd,
         a.at_usd, a.ppe_usd, a.fx_flow, a.fx_bs,
         b.datadate as date_l1,
         b.at_usd as at_l1_usd,
         b.sale_usd as sale_l1_usd
  from work.funda_usd as a
  left join work.funda_usd as b
    on a.gvkey=b.gvkey and b.fyear=a.fyear-1
  order by a.gvkey, a.fyear;
quit;

/* Supporting modified Jones/Kothari fits: annual 3-SD winsorization, then
   separate no-intercept cross-sections by historical two-digit SIC and year. */
data work.fit_raw;
  set work.hist;
  if fyear < 1988 or fyear > 2000 then delete;
  if missing(at_l1_usd) or at_l1_usd <= 0 then delete;
  if nmiss(ib_usd,cfo_usd,sale_usd,sale_l1_usd,ppe_usd)=0 then do;
    tacc=(ib_usd-cfo_usd)/at_l1_usd;
    inv_at=1/at_l1_usd;
    dsale=(sale_usd-sale_l1_usd)/at_l1_usd;
    ppe=ppe_usd/at_l1_usd;
    roa=ib_usd/at_l1_usd;
  end;
  else delete;
run;
proc means data=work.fit_raw noprint;
  class fyear;
  var tacc inv_at dsale ppe roa;
  output out=work.fit_stats mean=mtacc minvat mdsale mppe mroa
                           std=stacc sinvat sdsale sppe sroa;
run;
data work.fit_stats;
  set work.fit_stats;
  if not missing(fyear);
  drop _type_ _freq_;
run;
proc sort data=work.fit_raw; by fyear; run;
proc sort data=work.fit_stats; by fyear; run;
data work.fit_win;
  merge work.fit_raw(in=ina) work.fit_stats(in=inb);
  by fyear;
  if ina and inb;
  if tacc < mtacc-3*stacc then tacc_w=mtacc-3*stacc;
  else if tacc > mtacc+3*stacc then tacc_w=mtacc+3*stacc;
  else tacc_w=tacc;
  if inv_at < minvat-3*sinvat then invat_w=minvat-3*sinvat;
  else if inv_at > minvat+3*sinvat then invat_w=minvat+3*sinvat;
  else invat_w=inv_at;
  if dsale < mdsale-3*sdsale then dsale_w=mdsale-3*sdsale;
  else if dsale > mdsale+3*sdsale then dsale_w=mdsale+3*sdsale;
  else dsale_w=dsale;
  if ppe < mppe-3*sppe then ppe_w=mppe-3*sppe;
  else if ppe > mppe+3*sppe then ppe_w=mppe+3*sppe;
  else ppe_w=ppe;
  if roa < mroa-3*sroa then roa_w=mroa-3*sroa;
  else if roa > mroa+3*sroa then roa_w=mroa+3*sroa;
  else roa_w=roa;
  keep gvkey datadate fyear sic2 tacc inv_at dsale ppe roa
       tacc_w invat_w dsale_w ppe_w roa_w;
run;
proc sql;
  create table work.fit_n as
  select sic2,fyear,count(*) as nfit
  from work.fit_win
  group by sic2,fyear;
  create table work.fit_reg as
  select a.*,b.nfit
  from work.fit_win as a inner join work.fit_n as b
    on a.sic2=b.sic2 and a.fyear=b.fyear
  where b.nfit >= 10
  order by sic2,fyear,gvkey;
quit;
proc sql noprint;
  select count(*) into :n_fit_groups trimmed from work.fit_n where nfit >= 10;
  select count(*) into :n_small_groups trimmed from work.fit_n where nfit < 10;
  select count(*) into :n_all_groups trimmed from work.fit_n;
quit;
%put NOTE: Accrual-fit SIC-year groups=&n_all_groups, fits N>=10=&n_fit_groups, groups below 10=&n_small_groups;
proc reg data=work.fit_reg outest=work.fit_coef noprint;
  by sic2 fyear;
  model tacc_w=invat_w dsale_w ppe_w roa_w / noint;
quit;
data work.fit_coef;
  set work.fit_coef;
  where upcase(_type_)='PARMS';
  keep sic2 fyear invat_w dsale_w ppe_w roa_w;
  rename invat_w=b_invat dsale_w=b_dsale ppe_w=b_ppe roa_w=b_roa;
run;
proc sql;
  create table work.dap_calc as
  select a.*,
         n.nfit,
         c.b_invat,c.b_dsale,c.b_ppe,c.b_roa,
         (c.b_invat*a.inv_at + c.b_dsale*a.dsale +
          c.b_ppe*a.ppe + c.b_roa*a.roa) as ndap,
         (a.tacc - (c.b_invat*a.inv_at + c.b_dsale*a.dsale +
          c.b_ppe*a.ppe + c.b_roa*a.roa)) as dap
  from work.fit_raw as a
  left join work.fit_n as n
    on a.sic2=n.sic2 and a.fyear=n.fyear
  left join work.fit_coef as c
    on a.sic2=c.sic2 and a.fyear=c.fyear
  order by a.gvkey,a.fyear;
quit;
proc sql noprint;
  select count(*) into :n_dapmiss trimmed from work.dap_calc where missing(dap);
  select count(*) into :n_daprows trimmed from work.dap_calc;
quit;
%put NOTE: Support complete-case fit rows=&n_daprows, rows without fitted DAP after minimum-size/singularity=&n_dapmiss;

/* The smoothing correlation uses exactly five consecutive annual changes,
   which require six consecutive DAP and PDI levels. */
proc sql;
  create table work.dap as
  select a.gvkey,a.fyear,a.datadate,a.sic2,a.ib_usd,a.cfo_usd,
         a.at_l1_usd,a.tacc,a.ndap,a.dap,
         case when not missing(a.dap) and a.at_l1_usd>0
              then a.ib_usd/a.at_l1_usd-a.dap else . end as pdi
  from work.dap_calc as a;
  create table work.changes as
  select a.gvkey,a.fyear,a.datadate,
         a.dap-b.dap as d_dap,
         a.pdi-b.pdi as d_pdi
  from work.dap as a inner join work.dap as b
    on a.gvkey=b.gvkey and b.fyear=a.fyear-1
  where not missing(a.dap) and not missing(b.dap)
    and not missing(a.pdi) and not missing(b.pdi)
    and a.datadate>b.datadate;
  create table work.corr_long as
  select a.gvkey,a.fyear as targetyr,a.sic2,
         c.fyear as changeyr,c.d_dap,c.d_pdi
  from work.dap as a inner join work.changes as c
    on a.gvkey=c.gvkey and c.fyear between a.fyear-4 and a.fyear
  where a.fyear between 1993 and 2000;
  create table work.corr_n as
  select gvkey,targetyr,count(*) as nchange
  from work.corr_long
  group by gvkey,targetyr;
  create table work.corr5 as
  select a.*
  from work.corr_long as a inner join work.corr_n as b
    on a.gvkey=b.gvkey and a.targetyr=b.targetyr
  where b.nchange=5
  order by gvkey,targetyr,changeyr;
quit;
proc corr data=work.corr5 noprint outp=work.corr_mat;
  by gvkey targetyr;
  var d_dap d_pdi;
run;
proc sql;
  create table work.corr_raw as
  select a.gvkey,a.targetyr,b.sic2,a.d_pdi as smooth_corr
  from work.corr_mat as a inner join work.dap as b
    on a.gvkey=b.gvkey and a.targetyr=b.fyear
  where upcase(a._type_)='CORR' and upcase(a._name_)='D_DAP';
quit;
proc sort data=work.corr_raw; by sic2 targetyr; run;
proc rank data=work.corr_raw out=work.corr_rank descending ties=mean;
  by sic2 targetyr;
  var smooth_corr;
  ranks smooth_rank;
run;
proc sql;
  create table work.corr_gn as
  select sic2,targetyr,count(*) as group_n
  from work.corr_rank
  group by sic2,targetyr;
  create table work.smooth as
  select a.gvkey,a.targetyr,a.sic2,a.smooth_corr,a.smooth_rank,b.group_n,
         a.smooth_rank/b.group_n as iscore
  from work.corr_rank as a inner join work.corr_gn as b
    on a.sic2=b.sic2 and a.targetyr=b.targetyr;
quit;
proc sql noprint;
  select count(*) into :n_corr trimmed from work.smooth;
  select count(*) into :n_corr_miss trimmed from work.dap as d
    where d.fyear between 1993 and 2000 and not exists
      (select * from work.smooth as s where s.gvkey=d.gvkey and s.targetyr=d.fyear);
quit;
%put NOTE: Nonmissing five-change smoothing correlations and ranks=&n_corr, baseline DAP rows without a five-change score=&n_corr_miss;

/* Date-valid CRSP link/name history and daily source rows. */
proc sql;
  create table work.ccm_link as
  select gvkey,lpermno as permno,lpermco as permco,
         linktype,linkprim,usedflag,linkdt,linkenddt
  from ccm.ccmxpf_linktable
  where lpermno>0
    and usedflag=1
    and upcase(strip(linktype)) in ('LC','LU')
    and upcase(strip(linkprim)) in ('P','C')
    and (missing(linkenddt) or linkenddt >= '01jan1989'd)
    and (missing(linkdt) or linkdt <= '31dec2004'd);
quit;
proc freq data=ccm.ccmxpf_linktable;
  tables usedflag*linktype*linkprim / missing;
  where (missing(linkenddt) or linkenddt >= '01jan1989'd)
    and (missing(linkdt) or linkdt <= '31dec2004'd);
run;

/* The raw CRSP sign convention is retained for diagnostics. */
data work.dsf_range;
  set cstock.dsf(keep=permno permco date retx prc cfacpr shrout);
  where date between '01jan1989'd and '31dec2004'd;
  if retx in (-66,-77,-88,-99) then retx=.;
run;
data work.name_common;
  set cstock.dsenames(keep=permno namedt nameendt shrcd);
  where shrcd in (10,11)
    and (missing(nameendt) or nameendt >= '01jan1989'd)
    and (missing(namedt) or namedt <= '31dec2004'd);
run;
proc sql;
  create table work.dsf_names as
  select distinct a.permno,a.permco,a.date,a.retx,a.prc,a.cfacpr,a.shrout
  from work.dsf_range as a inner join work.name_common as b
    on a.permno=b.permno
   and (missing(b.namedt) or a.date>=b.namedt)
   and (missing(b.nameendt) or a.date<=b.nameendt);
  create table work.dsf_cand as
  select distinct c.gvkey,d.permno,d.permco,d.date,d.retx,d.prc,d.cfacpr,d.shrout
  from work.dsf_names as d inner join work.ccm_link as c
    on d.permno=c.permno
   and (missing(c.linkdt) or d.date>=c.linkdt)
   and (missing(c.linkenddt) or d.date<=c.linkenddt);
  create table work.gkey_ok as
  select gvkey,date from work.dsf_cand
  group by gvkey,date having count(distinct permno)=1;
  create table work.pkey_ok as
  select permno,date from work.dsf_cand
  group by permno,date having count(distinct gvkey)=1;
  create table work.dsf_map as
  select distinct a.gvkey,a.permno,a.permco,a.date,a.retx,a.prc,a.cfacpr,a.shrout
  from work.dsf_cand as a
  inner join work.gkey_ok as g on a.gvkey=g.gvkey and a.date=g.date
  inner join work.pkey_ok as p on a.permno=p.permno and a.date=p.date
  order by gvkey,date;
quit;
proc sql noprint;
  select count(*) into :n_daily_candidates trimmed from work.dsf_cand;
  select count(*) into :n_daily_map trimmed from work.dsf_map;
  select count(*) into :n_gambig trimmed from
    (select gvkey,date from work.dsf_cand group by gvkey,date
     having count(distinct permno)>1);
  select count(*) into :n_pambig trimmed from
    (select permno,date from work.dsf_cand group by permno,date
     having count(distinct gvkey)>1);
quit;
%put NOTE: Linked CRSP daily candidate rows=&n_daily_candidates, unique company-security-date rows=&n_daily_map, ambiguous GVKEY-date=&n_gambig, ambiguous PERMNO-date=&n_pambig;

proc sql;
  create table work.crsp_calendar as
  select distinct date from work.dsf_range;
quit;

/* Fiscal-year dates use Compustat's actual period ends; return periods run
   from the prior period end exclusive through the current end inclusive. */
proc sql;
  create table work.periods as
  select a.gvkey,a.fyear,a.datadate as enddt,b.datadate as begdt
  from work.funda_usd as a left join work.funda_usd as b
    on a.gvkey=b.gvkey and b.fyear=a.fyear-1
  where a.fyear between 1990 and 2003;
  create table work.year_sessions as
  select p.gvkey,p.fyear,count(c.date) as n_sessions
  from work.periods as p inner join work.crsp_calendar as c
    on c.date>p.begdt and c.date<=p.enddt
  where not missing(p.begdt) and p.enddt>p.begdt
  group by p.gvkey,p.fyear;
  create table work.ret_long as
  select a.gvkey,a.fyear,d.date,d.retx
  from work.periods as a inner join work.dsf_map as d
    on a.gvkey=d.gvkey and d.date>a.begdt and d.date<=a.enddt
  where not missing(a.begdt) and a.enddt>a.begdt
  order by a.gvkey,a.fyear,d.date;
quit;
data work.ret_year;
  set work.ret_long;
  by gvkey fyear;
  retain gross nret nmiss nobs firstdate lastdate;
  if first.fyear then do;
    gross=1; nret=0; nmiss=0; nobs=0; firstdate=.; lastdate=.;
  end;
  nobs+1;
  if nobs=1 then firstdate=date;
  lastdate=date;
  if missing(retx) then nmiss+1;
  else do; gross=gross*(1+retx); nret+1; end;
  if last.fyear then do;
    if nret>0 and nmiss=0 then ret_year=gross-1;
    else ret_year=.;
    output;
  end;
  keep gvkey fyear ret_year nret nmiss nobs firstdate lastdate;
run;
proc sort data=work.ret_year; by gvkey fyear; run;
proc sort data=work.year_sessions; by gvkey fyear; run;
data work.ret_year_full;
  merge work.ret_year(in=inr) work.year_sessions(in=ins);
  by gvkey fyear;
  if inr;
  if not ins or missing(n_sessions) or nobs ne n_sessions or nmiss>0 then ret_year=.;
run;
data work.ret_year;
  set work.ret_year_full;
run;
proc sql noprint;
  select count(*) into :n_ret_partial trimmed
  from work.ret_year where nobs>0 and nobs<n_sessions;
  select count(*) into :n_ret_incomplete trimmed
  from work.ret_year where missing(ret_year);
quit;
%put NOTE: Annual return support requires every CRSP session in the fiscal period, and partial or missing daily coverage is left blank. Partial linked periods=&n_ret_partial, return periods unavailable after coverage check=&n_ret_incomplete;

/* Market equity sums raw linked ordinary common shares at PERMCO/date.
   The beginning price remains in its raw CRSP share basis. Compustat EPS is
   later rescaled to the AJEX value at this same beginning-date anchor. */
proc sql;
  create table work.me_sec as
  select distinct permco,date,permno,prc,shrout
  from work.dsf_names
  where permco>0;
  create table work.me_permco as
  select permco,date,
         count(*) as nsec,
         sum(missing(prc) or missing(shrout)) as nmiss,
         sum(case when not missing(prc) and not missing(shrout) then abs(prc)*shrout/1000 else 0 end) as me_usd
  from work.me_sec
  group by permco,date;
  create table work.price_dates as
  select p.gvkey,p.fyear,p.begdt,max(c.date) as pdate
  from work.periods as p inner join work.crsp_calendar as c
    on c.date<=p.begdt
  where p.fyear between 1990 and 2003
  group by p.gvkey,p.fyear,p.begdt;
  create table work.price_primary as
  select p.gvkey,p.fyear,p.begdt,p.pdate,d.permno,d.permco,
         case when not missing(d.prc) then abs(d.prc) else . end as p0_usd,
         d.prc,d.cfacpr,d.shrout
  from work.price_dates as p inner join work.dsf_map as d
    on p.gvkey=d.gvkey and p.pdate=d.date;
  create table work.price_base as
  select a.gvkey,a.fyear,a.begdt,a.pdate,a.permno,a.permco,a.p0_usd,
         case when m.nmiss=0 then m.me_usd else . end as me_usd,
         m.nsec as me_nsec
  from work.price_primary as a left join work.me_permco as m
    on a.permco=m.permco and a.pdate=m.date;
quit;
proc sql noprint;
  select count(*) into :n_ret_period trimmed from work.ret_year where not missing(ret_year);
  select count(*) into :n_price_period trimmed from work.price_base where not missing(p0_usd);
  select count(*) into :n_me_period trimmed from work.price_base where not missing(me_usd);
quit;
%put NOTE: Fiscal return years with complete daily RETX=&n_ret_period, beginning-price periods=&n_price_period, complete PERMCO market-equity dates=&n_me_period;

/* Join all stated lead/lag windows and split factors by exact GVKEY/fiscal-year offsets. */
proc sql;
  create table work.annual as
  select h.*,d.dap,d.ndap,d.pdi,
         (h.ib_usd-h.cfo_usd) as acc_usd,
         p.p0_usd,p.me_usd,
         r.ret_year
  from work.hist as h
  left join work.dap as d on h.gvkey=d.gvkey and h.fyear=d.fyear
  left join work.price_base as p on h.gvkey=p.gvkey and h.fyear=p.fyear
  left join work.ret_year as r on h.gvkey=r.gvkey and h.fyear=r.fyear;
quit;
proc sql;
  create table work.primary_wide as
  select a.gvkey,a.fyear,a.datadate,a.sic2,
         a.eps_usd as eps_0,l1.eps_usd as eps_m1,
         f1.eps_usd as eps_p1,f2.eps_usd as eps_p2,f3.eps_usd as eps_p3,
         l1.ajex as ajex_anchor,l1.ajex as ajex_m1,
         a.ajex as ajex_0,f1.ajex as ajex_p1,
         f2.ajex as ajex_p2,f3.ajex as ajex_p3,
         a.p0_usd,a.me_usd,
         a.ret_year as ret_0,r1.ret_year as ret_p1,
         r2.ret_year as ret_p2,r3.ret_year as ret_p3,
         a.dap as dap_0,s.smooth_corr,s.iscore,
         m3.ib_usd as ib_m3,m2.ib_usd as ib_m2,m1.ib_usd as ib_m1,
         a.ib_usd as ib_0,p1.ib_usd as ib_p1,p2.ib_usd as ib_p2,p3.ib_usd as ib_p3,
         m3.cfo_usd as cfo_m3,m2.cfo_usd as cfo_m2,m1.cfo_usd as cfo_m1,
         a.cfo_usd as cfo_0,p1.cfo_usd as cfo_p1,p2.cfo_usd as cfo_p2,p3.cfo_usd as cfo_p3,
         m3.acc_usd as acc_m3,m2.acc_usd as acc_m2,m1.acc_usd as acc_m1,
         a.acc_usd as acc_0,p1.acc_usd as acc_p1,p2.acc_usd as acc_p2,p3.acc_usd as acc_p3,
         m3.me_usd as me_m3,m2.me_usd as me_m2,m1.me_usd as me_m1,
         a.me_usd as me_0,p1.me_usd as me_p1,p2.me_usd as me_p2,p3.me_usd as me_p3
  from work.annual as a
  left join work.annual as l1 on a.gvkey=l1.gvkey and l1.fyear=a.fyear-1
  left join work.annual as f1 on a.gvkey=f1.gvkey and f1.fyear=a.fyear+1
  left join work.annual as f2 on a.gvkey=f2.gvkey and f2.fyear=a.fyear+2
  left join work.annual as f3 on a.gvkey=f3.gvkey and f3.fyear=a.fyear+3
  left join work.annual as m3 on a.gvkey=m3.gvkey and m3.fyear=a.fyear-3
  left join work.annual as m2 on a.gvkey=m2.gvkey and m2.fyear=a.fyear-2
  left join work.annual as m1 on a.gvkey=m1.gvkey and m1.fyear=a.fyear-1
  left join work.annual as p1 on a.gvkey=p1.gvkey and p1.fyear=a.fyear+1
  left join work.annual as p2 on a.gvkey=p2.gvkey and p2.fyear=a.fyear+2
  left join work.annual as p3 on a.gvkey=p3.gvkey and p3.fyear=a.fyear+3
  left join work.annual as r1 on a.gvkey=r1.gvkey and r1.fyear=a.fyear+1
  left join work.annual as r2 on a.gvkey=r2.gvkey and r2.fyear=a.fyear+2
  left join work.annual as r3 on a.gvkey=r3.gvkey and r3.fyear=a.fyear+3
  left join work.smooth as s on a.gvkey=s.gvkey and a.fyear=s.targetyr
  where a.fyear between 1993 and 2000
  order by a.gvkey,a.fyear;
quit;

/* Establish the joint required-data population before calculating the paper's
   percentile screens. */
data work.primary_base;
  set work.primary_wide;
  length complete smooth_ok eps_ok return_ok fin_ok me_ok 8;
  array ibv[7] ib_m3 ib_m2 ib_m1 ib_0 ib_p1 ib_p2 ib_p3;
  array cfv[7] cfo_m3 cfo_m2 cfo_m1 cfo_0 cfo_p1 cfo_p2 cfo_p3;
  array acv[7] acc_m3 acc_m2 acc_m1 acc_0 acc_p1 acc_p2 acc_p3;
  smooth_ok=(nmiss(iscore,smooth_corr)=0);
  eps_ok=(nmiss(eps_m1,eps_0,eps_p1,eps_p2,eps_p3,p0_usd,
                ajex_anchor,ajex_m1,ajex_0,ajex_p1,ajex_p2,ajex_p3)=0
          and p0_usd>0 and ajex_anchor>0 and ajex_m1>0 and ajex_0>0
          and ajex_p1>0 and ajex_p2>0 and ajex_p3>0);
  return_ok=(nmiss(ret_0,ret_p1,ret_p2,ret_p3)=0);
  me_ok=(not missing(me_0) and me_0>0);
  fin_ok=1;
  do i=1 to 7;
    if nmiss(ibv[i],cfv[i],acv[i])>0 then fin_ok=0;
  end;
  complete=(smooth_ok=1 and eps_ok=1 and return_ok=1 and fin_ok=1 and me_ok=1);
  if p0_usd>0 then do;
    xm1=(eps_m1*ajex_anchor/ajex_m1)/p0_usd;
    xt=(eps_0*ajex_anchor/ajex_0)/p0_usd;
    xt3=((eps_p1*ajex_anchor/ajex_p1) +
         (eps_p2*ajex_anchor/ajex_p2) +
         (eps_p3*ajex_anchor/ajex_p3))/p0_usd;
  end;
  else do; xm1=.; xt=.; xt3=.; end;
  if nmiss(ret_p1,ret_p2,ret_p3)=0 then rt3=(1+ret_p1)*(1+ret_p2)*(1+ret_p3)-1;
  else rt3=.;
  if missing(rt3) then do; return_ok=0; complete=0; end;
run;

/* Section IV p. 259 removes observations missing required data before its
   pooled top/bottom 1% screens. The monetary earnings, CFO, and total-accrual
   inputs are scaled by baseline-year market equity; the paper does not state
   separate percentile screens for EPS/price regressors. */
data work.screen_long;
  set work.primary_base;
  array ibv[7] ib_m3 ib_m2 ib_m1 ib_0 ib_p1 ib_p2 ib_p3;
  array cfv[7] cfo_m3 cfo_m2 cfo_m1 cfo_0 cfo_p1 cfo_p2 cfo_p3;
  array acv[7] acc_m3 acc_m2 acc_m1 acc_0 acc_p1 acc_p2 acc_p3;
  if complete=1 and me_0>0 then do i=1 to 7;
    ib_me=ibv[i]/me_0;
    cfo_me=cfv[i]/me_0;
    acc_me=acv[i]/me_0;
    output;
  end;
  keep ib_me cfo_me acc_me;
run;
data work.retwin_long;
  set work.primary_base;
  array rv[4] ret_0 ret_p1 ret_p2 ret_p3;
  if complete=1 then do i=1 to 4;
    ret_win=rv[i];
    output;
  end;
  keep ret_win;
run;
proc univariate data=work.screen_long noprint;
  var ib_me;
  output out=work.cut_ib pctlpts=1 99 pctlpre=ib_ pctlname=p1 p99;
run;
proc univariate data=work.screen_long noprint;
  var cfo_me;
  output out=work.cut_cfo pctlpts=1 99 pctlpre=cfo_ pctlname=p1 p99;
run;
proc univariate data=work.screen_long noprint;
  var acc_me;
  output out=work.cut_acc pctlpts=1 99 pctlpre=acc_ pctlname=p1 p99;
run;
proc univariate data=work.retwin_long noprint;
  var ret_win;
  output out=work.cut_ret pctlpts=1 99 pctlpre=ret_ pctlname=p1 p99;
run;
data work.cuts;
  merge work.cut_ib(rename=(ib_p1=cut_iblo ib_p99=cut_ibhi))
        work.cut_cfo(rename=(cfo_p1=cut_cfolo cfo_p99=cut_cfohi))
        work.cut_acc(rename=(acc_p1=cut_acclo acc_p99=cut_acchi))
        work.cut_ret(rename=(ret_p1=cut_retlo ret_p99=cut_rethi));
  keep cut_iblo cut_ibhi cut_cfolo cut_cfohi cut_acclo cut_acchi
       cut_retlo cut_rethi;
run;

/* Apply pooled cutoffs only within the joint complete-case population. */
data work.primary_flags;
  if _n_=1 then set work.cuts;
  set work.primary_base;
  length trim_flag extreme_flag 8;
  array ibv[7] ib_m3 ib_m2 ib_m1 ib_0 ib_p1 ib_p2 ib_p3;
  array cfv[7] cfo_m3 cfo_m2 cfo_m1 cfo_0 cfo_p1 cfo_p2 cfo_p3;
  array acv[7] acc_m3 acc_m2 acc_m1 acc_0 acc_p1 acc_p2 acc_p3;
  array rv[4] ret_0 ret_p1 ret_p2 ret_p3;
  trim_flag=0;
  extreme_flag=0;
  if complete=1 then do;
    do i=1 to 7;
      if ibv[i]/me_0 < cut_iblo or ibv[i]/me_0 > cut_ibhi then trim_flag=1;
      if cfv[i]/me_0 < cut_cfolo or cfv[i]/me_0 > cut_cfohi then trim_flag=1;
      if acv[i]/me_0 < cut_acclo or acv[i]/me_0 > cut_acchi then trim_flag=1;
    end;
    /* The separate +/-10 market-equity rule is stated for current and future
       accounting years; the top/bottom-1% screen above covers t-3 through t+3. */
    do i=4 to 7;
      if ibv[i]/me_0 < -10 or ibv[i]/me_0 > 10 then extreme_flag=1;
      if cfv[i]/me_0 < -10 or cfv[i]/me_0 > 10 then extreme_flag=1;
      if acv[i]/me_0 < -10 or acv[i]/me_0 > 10 then extreme_flag=1;
    end;
    do i=1 to 4;
      if rv[i] < cut_retlo or rv[i] > cut_rethi then trim_flag=1;
    end;
  end;
  if rt3 < -10 or rt3 > 10 then extreme_flag=1;
  drop i;
run;
proc sql noprint;
  select count(*) into :n_primary0 trimmed from work.primary_wide;
  select count(*) into :n_smooth trimmed from work.primary_flags where smooth_ok=1;
  select count(*) into :n_eps trimmed from work.primary_flags where eps_ok=1;
  select count(*) into :n_returns trimmed from work.primary_flags where return_ok=1;
  select count(*) into :n_finwin trimmed from work.primary_flags where fin_ok=1;
  select count(*) into :n_me trimmed from work.primary_flags where me_ok=1;
  select count(*) into :n_complete trimmed from work.primary_flags where complete=1;
  select count(*) into :n_trimmed trimmed from work.primary_flags where complete=1 and trim_flag=1;
  select count(*) into :n_extreme trimmed from work.primary_flags where complete=1 and trim_flag=0 and extreme_flag=1;
quit;
%put NOTE: Primary candidates=&n_primary0, with smoothing=&n_smooth, EPS/price=&n_eps, current/future returns=&n_returns, financial windows=&n_finwin, baseline ME=&n_me, joint complete=&n_complete, 1/99 trims=&n_trimmed, stated extremes=&n_extreme;
data work.primary_final;
  set work.primary_flags;
  if complete ne 1 or trim_flag=1 or extreme_flag=1 then delete;
  rt=ret_0;
  is=iscore;
  isxm1=is* xm1;
  isxt=is*xt;
  isxt3=is*xt3;
  isrt3=is*rt3;
  acct=acc_0/me_0;
  cfot=cfo_0/me_0;
  dapt=dap_0;
  corr=smooth_corr;
  keep gvkey fyear sic2 rt xm1 xt xt3 rt3 is isxm1 isxt isxt3 isrt3 acct cfot corr dapt;
  label rt='R_t ex-dividend return'
        xm1='X_t-1 EPS/price'
        xt='X_t EPS/price'
        xt3='X_t3 future EPS/price'
        rt3='R_t3 future compounded return'
        is='IS smoothing score'
        isxm1='IS x X_t-1'
        isxt='IS x X_t'
        isxt3='IS x X_t3'
        isrt3='IS x R_t3'
        acct='ACC_t / beginning market equity'
        cfot='CFO_t / beginning market equity'
        corr='Five-change smoothing correlation'
        dapt='Asset-scaled DAP_t';
run;
proc sort data=work.primary_final; by gvkey fyear; run;
proc sql noprint;
  select count(*) into :n_final trimmed from work.primary_final;
  select count(*) into :n_keydup trimmed from
   (select gvkey,fyear from work.primary_final group by gvkey,fyear having count(*)>1);
quit;
%put NOTE: Final primary observations=&n_final, duplicate GVKEY-fyear keys=&n_keydup, paper reports 17019;
proc freq data=work.primary_final;
  tables fyear / missing;
run;
proc means data=work.primary_final n mean std median min max;
  var rt xm1 xt xt3 rt3 acct cfot corr dapt;
run;

/* Audit the annual-return support actually used by the final rows. A daily
   return on some observed dates is not sufficient evidence of full-period
   coverage. Compare observed rows with the CRSP session calendar and with
   date-valid linked common-share intervals; do not impose a day-count screen. */
data work.final_ret_key;
  set work.primary_final(keep=gvkey fyear);
  do ret_offset=0 to 3;
    ret_fyear=fyear+ret_offset;
    output;
  end;
  keep gvkey fyear ret_offset ret_fyear;
run;
proc sql;
  create table work.final_market_days as
  select k.gvkey,k.fyear as base_year,k.ret_offset,k.ret_fyear,c.date
  from work.final_ret_key as k
  inner join work.periods as p
    on k.gvkey=p.gvkey and k.ret_fyear=p.fyear
  inner join work.crsp_calendar as c
    on c.date>p.begdt and c.date<=p.enddt;
  create table work.market_counts as
  select gvkey,base_year,ret_offset,ret_fyear,
         count(*) as n_market,min(date) as first_market,
         max(date) as last_market
  from work.final_market_days
  group by gvkey,base_year,ret_offset,ret_fyear;
  create table work.final_active_days as
  select distinct m.gvkey,m.base_year,m.ret_offset,m.ret_fyear,m.date
  from work.final_market_days as m
  inner join work.ccm_link as l
    on m.gvkey=l.gvkey
   and (missing(l.linkdt) or m.date>=l.linkdt)
   and (missing(l.linkenddt) or m.date<=l.linkenddt)
  inner join work.name_common as n
    on l.permno=n.permno
   and (missing(n.namedt) or m.date>=n.namedt)
   and (missing(n.nameendt) or m.date<=n.nameendt);
  create table work.active_counts as
  select gvkey,base_year,ret_offset,ret_fyear,
         count(*) as n_active,min(date) as first_active,
         max(date) as last_active
  from work.final_active_days
  group by gvkey,base_year,ret_offset,ret_fyear;
  create table work.observed_counts as
  select k.gvkey,k.fyear as base_year,k.ret_offset,k.ret_fyear,
         sum(case when not missing(r.date) then 1 else 0 end) as n_observed,
         sum(case when not missing(r.date) and missing(r.retx) then 1 else 0 end) as n_retx_missing,
         min(r.date) as first_observed,max(r.date) as last_observed
  from work.final_ret_key as k
  left join work.ret_long as r
    on k.gvkey=r.gvkey and k.ret_fyear=r.fyear
  group by k.gvkey,k.fyear,k.ret_offset,k.ret_fyear;
  create table work.ret_audit as
  select k.gvkey,k.fyear as base_year,k.ret_offset,k.ret_fyear,
         m.n_market,m.first_market,m.last_market,
         a.n_active,a.first_active,a.last_active,
         o.n_observed,o.n_retx_missing,o.first_observed,o.last_observed,
         y.nret,y.nmiss,y.ret_year
  from work.final_ret_key as k
  left join work.market_counts as m
    on k.gvkey=m.gvkey and k.fyear=m.base_year
   and k.ret_offset=m.ret_offset and k.ret_fyear=m.ret_fyear
  left join work.active_counts as a
    on k.gvkey=a.gvkey and k.fyear=a.base_year
   and k.ret_offset=a.ret_offset and k.ret_fyear=a.ret_fyear
  left join work.observed_counts as o
    on k.gvkey=o.gvkey and k.fyear=o.base_year
   and k.ret_offset=o.ret_offset and k.ret_fyear=o.ret_fyear
  left join work.ret_year as y
    on k.gvkey=y.gvkey and k.ret_fyear=y.fyear;
quit;
data work.ret_audit;
  set work.ret_audit;
  length coverage $24;
  if missing(n_market) then n_market=0;
  if missing(n_active) then n_active=0;
  if missing(n_observed) then n_observed=0;
  if missing(n_retx_missing) then n_retx_missing=0;
  if n_retx_missing>0 then coverage='EXPLICIT_RETX_MISSING';
  else if n_active=0 then coverage='NO_ACTIVE_LINK';
  else if n_active<n_market then coverage='PARTIAL_PERIOD_LINK';
  else if n_observed<n_active then coverage='ACTIVE_DATE_ROW_GAP';
  else if n_observed=n_market and n_retx_missing=0 then coverage='FULL_PERIOD';
  else coverage='OTHER';
  format first_market last_market first_active last_active
         first_observed last_observed date9.;
run;
%put NOTE: Annual-return coverage audit expands final rows to t through t+3, separating linked intervals, observed rows, and explicit missing RETX;
proc freq data=work.ret_audit;
  tables ret_offset*coverage / missing;
run;
proc means data=work.ret_audit n mean median min max;
  class ret_offset;
  var nret nmiss n_market n_active n_observed n_retx_missing
      first_market last_market first_active last_active first_observed last_observed;
run;

/* Price-age diagnostics use the beginning-date anchors on the same final rows. */
proc sql;
  create table work.price_age_audit as
  select f.gvkey,f.fyear,p.begdt,p.pdate,
         p.begdt-p.pdate as price_age_days
  from work.primary_final as f
  left join work.price_base as p
    on f.gvkey=p.gvkey and f.fyear=p.fyear;
quit;
data work.price_age_audit;
  set work.price_age_audit;
  length age_band $12;
  if missing(price_age_days) then age_band='MISSING';
  else if price_age_days=0 then age_band='0 days';
  else if price_age_days<=3 then age_band='1-3 days';
  else if price_age_days<=7 then age_band='4-7 days';
  else if price_age_days<=30 then age_band='8-30 days';
  else age_band='over 30 days';
run;
proc means data=work.price_age_audit n mean median p95 min max;
  var price_age_days;
run;
proc freq data=work.price_age_audit;
  tables age_band / missing;
run;

data outdata.primary_ferc;
  set work.primary_final;
run;
