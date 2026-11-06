options errorabend;

libname comp ("/storage/sas/base/comp/d_na"
              "/storage/sas/base/comp/d_global/currency") access=readonly;
libname crspstk "/storage/sas/base/crsp/a_stock" access=readonly;
libname crspidx "/storage/sas/base/crsp/a_indexes" access=readonly;
libname ccm "/storage/sas/base/crsp/a_ccm" access=readonly;
libname rep "./data";

/* Xpressfeed annual amounts use CURCD, with GBP as the documented primary. */
/* Income/cash-flow values use EXRAT12M; balance-sheet values use EXRATD. */
proc sql;
    create table fxm0 as
    select datadate, upcase(strip(tocurm)) as curcd length=3,
           exrat12m as rate_cur
    from comp.g_exrt_mth
    where upcase(strip(fromcurm))='GBP';

    create table fxmdup as
    select datadate, curcd, count(*) as n
    from fxm0
    group by datadate, curcd
    having calculated n ne 1;

    create table fxm1 as
    select f.datadate, f.curcd, f.rate_cur
    from fxm0 as f left join fxmdup as d
      on f.datadate=d.datadate and f.curcd=d.curcd
    where missing(d.n);

    create table fxm as
    select c.datadate, c.curcd, c.rate_cur,
           u.rate_cur as rate_usd
    from fxm1 as c left join fxm1 as u
      on c.datadate=u.datadate and u.curcd='USD';

    create table fxd0 as
    select datadate, upcase(strip(tocurd)) as curcd length=3,
           exratd as rate_cur, exrattpd as type_cur
    from comp.g_exrt_dly
    where upcase(strip(fromcurd))='GBP';

    create table fxdups as
    select datadate, curcd, count(*) as n
    from fxd0
    group by datadate, curcd
    having calculated n ne 1;

    create table fxd1 as
    select f.datadate, f.curcd, f.rate_cur, f.type_cur
    from fxd0 as f left join fxdups as d
      on f.datadate=d.datadate and f.curcd=d.curcd
    where missing(d.n);

    create table fxd as
    select c.datadate, c.curcd, c.rate_cur, c.type_cur,
           u.rate_cur as rate_usd, u.type_cur as type_usd
    from fxd1 as c left join fxd1 as u
      on c.datadate=u.datadate and u.curcd='USD';

    select count(*) as dup_mth_fx_keys from fxmdup;
    select count(*) as dup_dly_fx_keys from fxdups;
    select min(datadate) as first_monthly_fx_date format=date9.,
           max(datadate) as last_monthly_fx_date format=date9.,
           count(*) as gbp_monthly_quote_rows
    from fxm1;
    select min(datadate) as first_daily_fx_date format=date9.,
           max(datadate) as last_daily_fx_date format=date9.,
           count(*) as gbp_daily_quote_rows
    from fxd1;
quit;

/* Compustat annual accounting history: retain selected-row currency and FX. */
data funda_raw;
    set comp.funda(keep=gvkey datadate fyear pdate indfmt consol popsrc datafmt
                        ib at sale ppegt fopt act che lct dlc oancf sich curcd
                   where=(fyear>=1970 and fyear<=1993 and indfmt='INDL' and
                          datafmt='STD' and consol='C' and popsrc='D'));
    curcd=upcase(strip(curcd));
run;

proc sql;
    create table funda_dups as
    select gvkey, fyear, count(*) as n
    from funda_raw
    group by gvkey, fyear
    having calculated n > 1;
    select count(*) as duplicate_gvkey_fyear_groups,
           coalesce(sum(n-1),0) as duplicate_rows
    from funda_dups;
quit;

proc sort data=funda_raw out=funda_sort;
    by gvkey fyear datadate pdate;
run;

data funda;
    set funda_sort;
    by gvkey fyear;
    if last.fyear;
run;

/* Convert each selected annual record using its own currency and fiscal date. */
proc sql;
    create table funda_fx0 as
    select t.*, m.rate_cur as fx_flow_cur, m.rate_usd as fx_flow_usd,
           d.rate_cur as fx_stock_cur, d.rate_usd as fx_stock_usd,
           d.type_cur as fx_dly_type_cur, d.type_usd as fx_dly_type_usd
    from funda as t
    left join fxm as m
      on t.datadate=m.datadate and t.curcd=m.curcd
    left join fxd as d
      on t.datadate=d.datadate and t.curcd=d.curcd;
quit;

data funda_fx;
    set funda_fx0;
    fx_flow_ok=0;
    fx_stock_ok=0;
    if curcd='USD' then do;
        fx_flow_ok=1;
        fx_stock_ok=1;
    end;
    else if not missing(curcd) then do;
        if not missing(fx_flow_cur) and fx_flow_cur>0 and
           not missing(fx_flow_usd) and fx_flow_usd>0 then fx_flow_ok=1;
        if not missing(fx_stock_cur) and fx_stock_cur>0 and
           not missing(fx_stock_usd) and fx_stock_usd>0 then fx_stock_ok=1;
    end;

    if not missing(ib) and fx_flow_ok then do;
        if curcd='USD' then ib_usd=ib;
        else ib_usd=ib/fx_flow_cur*fx_flow_usd;
    end;
    if not missing(oancf) and fx_flow_ok then do;
        if curcd='USD' then oancf_usd=oancf;
        else oancf_usd=oancf/fx_flow_cur*fx_flow_usd;
    end;
    if not missing(fopt) and fx_flow_ok then do;
        if curcd='USD' then fopt_usd=fopt;
        else fopt_usd=fopt/fx_flow_cur*fx_flow_usd;
    end;
    if not missing(sale) and fx_flow_ok then do;
        if curcd='USD' then sale_usd=sale;
        else sale_usd=sale/fx_flow_cur*fx_flow_usd;
    end;

    if not missing(at) and fx_stock_ok then do;
        if curcd='USD' then at_usd=at;
        else at_usd=at/fx_stock_cur*fx_stock_usd;
    end;
    if not missing(ppegt) and fx_stock_ok then do;
        if curcd='USD' then ppegt_usd=ppegt;
        else ppegt_usd=ppegt/fx_stock_cur*fx_stock_usd;
    end;
    if not missing(act) and fx_stock_ok then do;
        if curcd='USD' then act_usd=act;
        else act_usd=act/fx_stock_cur*fx_stock_usd;
    end;
    if not missing(che) and fx_stock_ok then do;
        if curcd='USD' then che_usd=che;
        else che_usd=che/fx_stock_cur*fx_stock_usd;
    end;
    if not missing(lct) and fx_stock_ok then do;
        if curcd='USD' then lct_usd=lct;
        else lct_usd=lct/fx_stock_cur*fx_stock_usd;
    end;
    if not missing(dlc) and fx_stock_ok then do;
        if curcd='USD' then dlc_usd=dlc;
        else dlc_usd=dlc/fx_stock_cur*fx_stock_usd;
    end;
run;

/* Join prior fiscal year by firm and fiscal-year key, not row position. */
proc sql;
    create table acct0 as
    select t.gvkey, t.datadate, t.fyear, t.sich, t.curcd,
           t.ib, t.at, t.sale, t.ppegt, t.fopt, t.act, t.che, t.lct, t.dlc, t.oancf,
           t.ib_usd, t.at_usd, t.sale_usd, t.ppegt_usd, t.fopt_usd,
           t.act_usd, t.che_usd, t.lct_usd, t.dlc_usd, t.oancf_usd,
           t.fx_flow_ok, t.fx_stock_ok,
           t.fx_dly_type_cur, t.fx_dly_type_usd,
           p.datadate as datadate_prev, p.curcd as curcd_prev,
           q.curcd as curcd_prev2,
           p.at as at_prev, p.sale as sale_prev, p.act as act_prev,
           p.che as che_prev, p.lct as lct_prev, p.dlc as dlc_prev,
           p.at_usd as at_usd_prev, p.sale_usd as sale_usd_prev,
           p.act_usd as act_usd_prev, p.che_usd as che_usd_prev,
           p.lct_usd as lct_usd_prev, p.dlc_usd as dlc_usd_prev,
           p.fx_flow_ok as fx_flow_ok_prev, p.fx_stock_ok as fx_stock_ok_prev,
           p.fx_dly_type_cur as fx_dly_type_cur_prev,
           p.fx_dly_type_usd as fx_dly_type_usd_prev
    from funda_fx as t
    left join funda_fx as p
      on t.gvkey=p.gvkey and p.fyear=t.fyear-1
    left join funda_fx as q
      on t.gvkey=q.gvkey and q.fyear=t.fyear-2
    where t.fyear>=1971 and t.fyear<=1993;
quit;

data acct0;
    set acct0;
    length sicnum 8 sic2 8;
    sicnum=sich;
    if not missing(sicnum) then sic2=floor(sicnum/100);
    earn_raw=ib_usd;
    cfo_raw=.;
    cfo_source=0;
    if not missing(oancf) then do;
        cfo_raw=oancf_usd;
        cfo_source=1;
    end;
    else if fyear < 1988 and
            nmiss(fopt_usd,act_usd,act_usd_prev,che_usd,che_usd_prev,
                  lct_usd,lct_usd_prev,dlc_usd,dlc_usd_prev)=0 then do;
        cfo_raw=fopt_usd-(act_usd-act_usd_prev)+(che_usd-che_usd_prev)+
                (lct_usd-lct_usd_prev)-(dlc_usd-dlc_usd_prev);
        cfo_source=2;
    end;
    accr_raw=earn_raw-cfo_raw;
    if not missing(at_usd_prev) and at_usd_prev ne 0 then do;
        earn_sc=earn_raw/at_usd_prev;
        cfo_sc=cfo_raw/at_usd_prev;
        accr_sc=accr_raw/at_usd_prev;
        oneata=1/at_usd_prev;
        if not missing(sale_usd) and not missing(sale_usd_prev) then
            drev_sc=(sale_usd-sale_usd_prev)/at_usd_prev;
        if not missing(ppegt_usd) then ppe_sc=ppegt_usd/at_usd_prev;
    end;
run;

/* Date-valid CCM linking; prefer primary, then LC over LU. */
proc sql;
    create table linkcand0 as
    select distinct a.gvkey, a.datadate, a.fyear, l.lpermno as permno,
           (case when l.linkprim='P' then 10 else 20 end +
            case when l.linktype='LC' then 1 else 2 end) as linkrank
    from acct0 as a
    inner join ccm.ccmxpf_linktable as l
      on a.gvkey=l.gvkey
    where a.fyear>=1971 and a.fyear<=1993 and
          l.linktype in ('LC','LU') and l.linkprim in ('P','C') and
          (missing(l.linkdt) or l.linkdt<=a.datadate) and
          (missing(l.linkenddt) or a.datadate<=l.linkenddt);

    create table linkmin as
    select gvkey, datadate, min(linkrank) as minrank
    from linkcand0
    group by gvkey, datadate;

    create table linkbest as
    select c.*
    from linkcand0 as c inner join linkmin as m
      on c.gvkey=m.gvkey and c.datadate=m.datadate and c.linkrank=m.minrank;

    create table linkbest_n as
    select gvkey, datadate, count(*) as nbest
    from linkbest
    group by gvkey, datadate;

    select count(*) as link_ambig_excluded
    from linkbest_n where nbest ne 1;

    create table linkunique as
    select b.gvkey, b.datadate, b.fyear, b.permno
    from linkbest as b inner join linkbest_n as n
      on b.gvkey=n.gvkey and b.datadate=n.datadate
    where n.nbest=1;

    /* Historical common-share/exchange classification at fiscal year end. */
    create table namecand0 as
    select distinct l.gvkey, l.datadate, l.fyear, l.permno, n.exchcd, n.siccd
    from linkunique as l inner join crspstk.dsenames as n
      on l.permno=n.permno and
         (missing(n.namedt) or n.namedt<=l.datadate) and
         (missing(n.nameendt) or l.datadate<=n.nameendt)
    where n.shrcd in (10,11) and n.exchcd in (1,2,3);

    create table namecand_n as
    select gvkey, datadate, count(*) as nname
    from namecand0
    group by gvkey, datadate;

    select count(*) as ambiguous_name_rows_excluded
    from namecand_n where nname ne 1;

    create table acctlinked0 as
    select a.*, n.permno, n.exchcd, n.siccd,
           case when n.exchcd in (1,2) then 1 else 2 end as exchgrp
    from acct0 as a inner join namecand0 as n
      on a.gvkey=n.gvkey and a.datadate=n.datadate
    inner join namecand_n as nn
      on n.gvkey=nn.gvkey and n.datadate=nn.datadate
    where a.fyear>=1971 and a.fyear<=1993 and nn.nname=1;
quit;

data acctlinked;
    set acctlinked0;
    if missing(sic2) and not missing(siccd) then sic2=floor(siccd/100);
run;

/* Sample-linked monthly stock returns, delisting returns, and market returns. */
proc sql;
    create table linked_permnos as
    select distinct permno from acctlinked;

    create table selected_months as
    select m.permno, intnx('month',m.date,0,'end') as mdate format=date9.,
           m.ret, m.prc, m.shrout
    from crspstk.msf as m inner join linked_permnos as p
      on m.permno=p.permno
    where m.date>='01JAN1970'd and m.date<='31DEC1995'd;

    create table delists_raw as
    select permno, dlstdt, intnx('month',dlstdt,0,'end') as mdate format=date9., dlret
    from crspstk.msedelist
    where not missing(dlstdt) and dlstdt>='01JAN1970'd and dlstdt<='31DEC1995'd;

    create table delists_dups as
    select permno, mdate, count(*) as n
    from delists_raw
    group by permno, mdate
    having calculated n>1;
    select count(*) as permno_delist_month_duplicates,
           coalesce(sum(n-1),0) as extra_delist_records
    from delists_dups;

    create table permdelist as
    select permno, min(mdate) as first_dlmonth format=date9.
    from delists_raw
    group by permno;

quit;

proc sort data=delists_raw out=delists_sorted;
    by permno mdate dlstdt;
run;

/* One final delisting record per PERMNO-month; retain the latest event date. */
data delists;
    set delists_sorted;
    by permno mdate;
    if last.mdate;
run;

/* Best-effort local market-cap decile ranks using the prior December CRSP universe. */
proc sql;
    create table capcand0 as
    select distinct m.permno, year(intnx('month',m.date,0,'end'))+1 as startyear,
           abs(m.prc)*m.shrout as mcap
    from crspstk.msf as m inner join crspstk.dsenames as n
      on m.permno=n.permno and
         (missing(n.namedt) or n.namedt<=m.date) and
         (missing(n.nameendt) or m.date<=n.nameendt)
    where m.date>='31DEC1969'd and m.date<='31DEC1992'd and month(m.date)=12 and
          n.shrcd in (10,11) and n.exchcd in (1,2,3) and
          not missing(m.prc) and not missing(m.shrout);

    create table capcand_n as
    select permno, startyear, count(*) as ncap
    from capcand0
    group by permno, startyear;

    select count(*) as cap_ambig_excluded
    from capcand_n where ncap ne 1;

    create table capcand as
    select c.* from capcand0 as c inner join capcand_n as n
      on c.permno=n.permno and c.startyear=n.startyear
    where n.ncap=1;
quit;

proc sort data=capcand out=capcand_s;
    by startyear;
run;

proc rank data=capcand_s out=caprank0 groups=10;
    by startyear;
    var mcap;
    ranks decile0;
run;

data caprank;
    set caprank0(keep=permno startyear decile0);
    decile=decile0+1;
    keep permno startyear decile;
run;

/* Build full annual return windows before the baseline sample screens. */
proc sort data=acctlinked out=acctlinked_s;
    by gvkey fyear;
run;

data windows;
    set acctlinked_s;
    if fyear>=1971 and fyear<=1993;
    window_id=_n_;
    end_month=intnx('month',datadate,3,'end');
    first_month=intnx('month',end_month,-11,'end');
    startyear=year(first_month);
    format end_month first_month date9.;
    do month_index=0 to 11;
        retmonth=intnx('month',first_month,month_index,'end');
        output;
    end;
    keep window_id gvkey fyear datadate permno end_month first_month startyear retmonth;
    format retmonth date9.;
run;

proc sql;
    create table window_long0 as
    select w.*, r.ret as crsp_ret, d.dlret, d.mdate as dlmonth format=date9.,
           p.first_dlmonth, i.vwretd as market_ret, c.decile,
           i.decret1, i.decret2, i.decret3, i.decret4, i.decret5,
           i.decret6, i.decret7, i.decret8, i.decret9, i.decret10
    from windows as w
    left join selected_months as r
      on w.permno=r.permno and w.retmonth=r.mdate
    left join delists as d
      on w.permno=d.permno and w.retmonth=d.mdate
    left join permdelist as p
      on w.permno=p.permno
    left join caprank as c
      on w.permno=c.permno and w.startyear=c.startyear
    left join crspidx.msix as i
      on w.retmonth=intnx('month',i.caldt,0,'end');
quit;

data window_long;
    set window_long0;
    array dcr[10] decret1-decret10;
    decile_ret=.;
    if decile>=1 and decile<=10 then decile_ret=dcr[decile];
    firm_ret=.;
    if not missing(first_dlmonth) and retmonth>first_dlmonth then firm_ret=market_ret;
    else if retmonth=dlmonth then do;
        if not missing(crsp_ret) and not missing(dlret) then firm_ret=(1+crsp_ret)*(1+dlret)-1;
        else if not missing(crsp_ret) then firm_ret=crsp_ret;
        else if not missing(dlret) then firm_ret=dlret;
    end;
    else firm_ret=crsp_ret;
    prior_delisted=0;
    if not missing(first_dlmonth) and first_dlmonth<first_month then prior_delisted=1;
run;

proc sort data=window_long;
    by window_id retmonth;
run;

data window_returns;
    set window_long;
    by window_id;
    retain raw_prod bench_prod n_month raw_missing bench_missing invalid_window;
    if first.window_id then do;
        raw_prod=1;
        bench_prod=1;
        n_month=0;
        raw_missing=0;
        bench_missing=0;
        invalid_window=0;
    end;
    n_month+1;
    if missing(firm_ret) then raw_missing=1;
    else raw_prod=raw_prod*(1+firm_ret);
    if missing(decile_ret) then bench_missing=1;
    else bench_prod=bench_prod*(1+decile_ret);
    if prior_delisted then invalid_window=1;
    if last.window_id then do;
        stock_bhr=.; size_bhr=.; sizeajr=.;
        if n_month=12 and raw_missing=0 and bench_missing=0 and invalid_window=0 then do;
            stock_bhr=raw_prod-1;
            size_bhr=bench_prod-1;
            sizeajr=stock_bhr-size_bhr;
        end;
        output;
    end;
    keep window_id gvkey fyear permno stock_bhr size_bhr sizeajr n_month;
run;

/* Attach same-year return for screening and one-year-ahead earnings/return outcomes. */
proc sql;
    create table annual as
    select a.*, r.stock_bhr, r.size_bhr, r.sizeajr
    from acctlinked as a left join window_returns as r
      on a.gvkey=r.gvkey and a.fyear=r.fyear;

    create table panel_lead as
    select t.*, f.earn_sc as earn_lead, f.sizeajr as sizeajr_lead,
           f.curcd as curcd_lead, f.curcd_prev as curcd_lead_prev,
           f.fx_flow_ok as fx_flow_ok_lead,
           f.fx_stock_ok as fx_stock_ok_lead,
           f.fx_dly_type_cur as fx_dly_type_cur_lead,
           f.fx_dly_type_usd as fx_dly_type_usd_lead
    from annual as t left join annual as f
      on t.gvkey=f.gvkey and f.fyear=t.fyear+1
    where t.fyear>=1971 and t.fyear<=1992;
quit;

/* Aggregate coverage and return-window checks before sample screens. */
proc sql;
    select count(*) as linked_annual_rows,
           sum((exchgrp ne 2 or fyear>=1982) and not missing(sic2)) as after_exchange,
           sum((exchgrp ne 2 or fyear>=1982) and not missing(sic2) and
               not missing(at_usd_prev) and at_usd_prev ne 0) as after_assets_usd,
           sum((exchgrp ne 2 or fyear>=1982) and not missing(sic2) and
               not missing(at_usd_prev) and at_usd_prev ne 0 and not missing(earn_sc) and
               not missing(cfo_sc) and not missing(accr_sc)) as after_earnings_cfo,
           sum((exchgrp ne 2 or fyear>=1982) and not missing(sic2) and
               not missing(at_usd_prev) and at_usd_prev ne 0 and not missing(earn_sc) and
               not missing(cfo_sc) and not missing(accr_sc) and not missing(oneata) and
               not missing(drev_sc) and not missing(ppe_sc)) as after_jones_variables,
           sum((exchgrp ne 2 or fyear>=1982) and not missing(sic2) and
               not missing(at_usd_prev) and at_usd_prev ne 0 and not missing(earn_sc) and
               not missing(cfo_sc) and not missing(accr_sc) and not missing(oneata) and
               not missing(drev_sc) and not missing(ppe_sc) and not missing(sizeajr)) as after_return,
           sum(missing(at_prev) or at_prev=0) as bad_begin_assets,
           sum(missing(at_usd_prev) or at_usd_prev=0) as bad_begin_assets_usd,
           sum(missing(earn_sc)) as missing_scaled_earn,
           sum(missing(cfo_sc)) as missing_scaled_cfo,
           sum(cfo_source=1) as cfo_item308_used,
           sum(cfo_source=2) as cfo_legacy_formula_used,
           sum(missing(accr_sc)) as missing_scaled_accr,
           sum(missing(oneata)) as missing_oneata,
           sum(missing(drev_sc)) as missing_drev,
           sum(missing(ppe_sc)) as missing_ppe,
           sum(missing(sich)) as missing_compustat_sich,
           sum(missing(siccd)) as missing_crsp_siccd,
           sum(missing(sic2)) as missing_sic2,
           sum(missing(sizeajr)) as missing_same_year_return
    from panel_lead where fyear>=1971 and fyear<=1992;
    select fyear, count(*) as annual_rows,
           sum(missing(fopt)) as missing_fopt,
           sum(cfo_source=1) as cfo_item308_used,
           sum(cfo_source=2) as cfo_legacy_formula_used,
           sum(missing(act)) as missing_act,
           sum(missing(che)) as missing_che,
           sum(missing(lct)) as missing_lct,
           sum(missing(dlc)) as missing_dlc,
           sum(missing(oancf)) as missing_oancf,
           sum(missing(at_prev) or at_prev=0) as bad_begin_assets_raw,
           sum(missing(at_usd_prev) or at_usd_prev=0) as bad_begin_assets_usd,
           sum(missing(cfo_sc)) as missing_scaled_cfo,
           sum(missing(drev_sc)) as missing_drev,
           sum(missing(ppe_sc)) as missing_ppe,
           sum(missing(sich)) as missing_compustat_sich,
           sum(missing(siccd)) as missing_crsp_siccd,
           sum(missing(sic2)) as missing_sic2,
           sum(missing(sizeajr)) as missing_same_year_return
    from panel_lead where fyear>=1971 and fyear<=1992
    group by fyear;
    select count(*) as return_windows,
           sum(missing(sizeajr)) as missing_sizeadjusted_returns
    from window_returns;
    select curcd, count(*) as panel_rows,
           sum(fx_flow_ok=0) as current_flow_fx_unavailable,
           sum(fx_stock_ok=0) as current_stock_fx_unavailable,
           sum(not missing(ib) and fx_flow_ok=0) as ib_fx_unavailable,
           sum(not missing(oancf) and fx_flow_ok=0) as oancf_fx_unavailable,
           sum(not missing(fopt) and fx_flow_ok=0) as fopt_fx_unavailable,
           sum(not missing(sale) and fx_flow_ok=0) as sale_fx_unavailable,
           sum(not missing(at) and fx_stock_ok=0) as at_fx_unavailable,
           sum(not missing(ppegt) and fx_stock_ok=0) as ppegt_fx_unavailable,
           sum(not missing(act) and fx_stock_ok=0) as act_fx_unavailable,
           sum(not missing(che) and fx_stock_ok=0) as che_fx_unavailable,
           sum(not missing(lct) and fx_stock_ok=0) as lct_fx_unavailable,
           sum(not missing(dlc) and fx_stock_ok=0) as dlc_fx_unavailable
    from panel_lead where fyear>=1971 and fyear<=1992
    group by curcd;
    select fyear, curcd, count(*) as panel_rows,
           sum(fx_flow_ok=0) as current_flow_fx_unavailable,
           sum(fx_stock_ok=0) as current_stock_fx_unavailable,
           sum(not missing(at_prev) and fx_stock_ok_prev=0) as prior_at_fx_unavailable,
           sum(not missing(sale_prev) and fx_flow_ok_prev=0) as prior_sale_fx_unavailable,
           sum(not missing(act_prev) and fx_stock_ok_prev=0) as prior_act_fx_unavailable,
           sum(not missing(che_prev) and fx_stock_ok_prev=0) as prior_che_fx_unavailable,
           sum(not missing(lct_prev) and fx_stock_ok_prev=0) as prior_lct_fx_unavailable,
           sum(not missing(dlc_prev) and fx_stock_ok_prev=0) as prior_dlc_fx_unavailable
    from panel_lead where fyear>=1971 and fyear<=1992
    group by fyear, curcd;
    select count(*) as known_cur_prior_n,
           sum(curcd ne curcd_prev) as cur_prior_mismatch,
           sum(not missing(curcd_prev) and not missing(curcd_prev2) and
               curcd_prev ne curcd_prev2) as prior_pair_mismatch,
           sum(not missing(curcd_lead) and curcd ne curcd_lead) as cur_next_mismatch
    from panel_lead where fyear>=1971 and fyear<=1992 and
         not missing(curcd) and not missing(curcd_prev);
    select curcd, fx_dly_type_cur, fx_dly_type_usd, count(*) as rows
    from panel_lead
    where fyear>=1971 and fyear<=1992 and curcd ne 'USD'
    group by curcd, fx_dly_type_cur, fx_dly_type_usd;
quit;

/* Baseline eligibility before Jones estimation. */
data candidates;
    set panel_lead;
    if exchgrp=2 and fyear<1982 then delete;
    if missing(sic2) or missing(at_usd_prev) or at_usd_prev=0 then delete;
    if missing(earn_sc) or missing(cfo_sc) or missing(accr_sc) then delete;
    if missing(oneata) or missing(drev_sc) or missing(ppe_sc) then delete;
    if missing(sizeajr) then delete;
run;

proc means data=candidates nway noprint;
    class sic2 fyear exchgrp;
    var accr_sc oneata drev_sc ppe_sc;
    output out=cellstats(drop=_type_ _freq_)
        mean=mean_accr mean_oneata mean_drev mean_ppe
        std=sd_accr sd_oneata sd_drev sd_ppe
        n=n_accr n_oneata n_drev n_ppe;
run;

proc sort data=candidates; by sic2 fyear exchgrp; run;
proc sort data=cellstats; by sic2 fyear exchgrp; run;

data candidates_with_stats;
    merge candidates(in=a) cellstats;
    by sic2 fyear exchgrp;
    if a;
    outlier=0;
    if abs(accr_sc-mean_accr)>3*sd_accr or
       abs(oneata-mean_oneata)>3*sd_oneata or
       abs(drev_sc-mean_drev)>3*sd_drev or
       abs(ppe_sc-mean_ppe)>3*sd_ppe then outlier=1;
run;

data candidates_trimmed;
    set candidates_with_stats;
    if outlier=0;
run;

proc sql;
    create table celln as
    /* Sample eligibility is SIC-year; the Jones fits below remain exchange-specific. */
    select sic2, fyear, count(*) as n_cell
    from candidates_trimmed
    group by sic2, fyear;
    select count(*) as preliminary_baseline_candidates from candidates;
    select count(*) as three_sd_outliers from candidates_with_stats where outlier=1;
    select count(*) as sic_year_cells_below_six from celln where n_cell<6;
    create table jones_sample as
    select a.* from candidates_trimmed as a inner join celln as c
      on a.sic2=c.sic2 and a.fyear=c.fyear
    where c.n_cell>=6;
quit;

proc sql;
    create table jones_group_sizes as
    select sic2, fyear, exchgrp, count(*) as n_group
    from jones_sample
    group by sic2, fyear, exchgrp;
    select count(*) as exchange_jones_groups,
           min(n_group) as minimum_exchange_group_size
    from jones_group_sizes;
    select count(*) as exchange_groups_below_six,
           sum(n_group) as obs_below_six
    from jones_group_sizes where n_group<6;
    select count(*) as underidentified_groups,
           sum(n_group) as underidentified_rows
    from jones_group_sizes where n_group<3;
    select count(*) as exact_fit_groups,
           sum(n_group) as exact_fit_rows
    from jones_group_sizes where n_group=3;
    create table jones_fit_sample as
    select a.* from jones_sample as a inner join jones_group_sizes as c
      on a.sic2=c.sic2 and a.fyear=c.fyear and a.exchgrp=c.exchgrp
    where c.n_group>=3;
quit;

/* Jones cross sections; the scaled constant is a regressor, not an intercept. */
proc sort data=jones_fit_sample;
    by sic2 fyear exchgrp;
run;

proc reg data=jones_fit_sample outest=jones_est edf noprint;
    by sic2 fyear exchgrp;
    model accr_sc=oneata drev_sc ppe_sc / noint;
    output out=jones_fit_raw p=nac r=abnac;
run;
quit;

/* Keep only estimable three-regressor fits, including when n_group>=3. */
data jones_parms;
    set jones_est;
    if upcase(_type_)='PARMS';
    keep sic2 fyear exchgrp _edf_;
run;

proc sql;
    create table jones_fit_status as
    select g.sic2, g.fyear, g.exchgrp, g.n_group,
           p._edf_ as residual_df,
           g.n_group-p._edf_ as model_rank,
           case when not missing(p._edf_) and
                     g.n_group-p._edf_=3 then 1 else 0 end as full_rank
    from jones_group_sizes as g left join jones_parms as p
      on g.sic2=p.sic2 and g.fyear=p.fyear and g.exchgrp=p.exchgrp;

    select count(*) as groups_rank_audited,
           sum(full_rank=0) as groups_not_full_rank,
           sum(case when full_rank=0 then n_group else 0 end)
               as rows_not_full_rank,
           sum(missing(residual_df)) as groups_missing_model_df,
           sum(case when not missing(model_rank) and model_rank<3 then 1 else 0 end)
               as groups_rank_deficient,
           sum(case when not missing(model_rank) and model_rank<3
                    then n_group else 0 end) as rows_rank_deficient
    from jones_fit_status;

    create table jones_fit0 as
    select f.*, s.model_rank, s.residual_df, s.full_rank
    from jones_fit_raw as f inner join jones_fit_status as s
      on f.sic2=s.sic2 and f.fyear=s.fyear and f.exchgrp=s.exchgrp;
quit;

data jones_fit;
    set jones_fit0;
    if full_rank ne 1 then do;
        nac=.;
        abnac=.;
    end;
run;

proc sql;
    select count(*) as jones_sample_rows from jones_sample;
    select count(*) as jones_fit_sample_rows from jones_fit_sample;
    select sum(missing(nac) or missing(abnac)) as missing_jones_fit_rows
    from jones_fit;
    select sum(full_rank=1) as full_rank_fit_rows,
           sum(full_rank=0) as excluded_rank_fit_rows
    from jones_fit;
quit;

/* Preserve original main rows and flag the Table 2 common complete-case system. */
data rep.mispricing_panel;
    set jones_fit;
    if missing(nac) or missing(abnac) then delete;
    table2=not missing(earn_lead) and not missing(sizeajr_lead);
    label earn_lead='EARN_{t+1}'
          sizeajr_lead='SIZEAJR_{t+1}'
          cfo_sc='CFO_t'
          nac='NAC_t'
          abnac='ABNAC_t'
          sizeajr='SIZEAJR_t'
          table2='Complete Table 2 system sample';
    keep gvkey fyear datadate permno exchcd exchgrp sic2
         curcd curcd_prev curcd_prev2 curcd_lead curcd_lead_prev
         fx_flow_ok fx_stock_ok fx_flow_ok_prev fx_stock_ok_prev
         fx_flow_ok_lead fx_stock_ok_lead
         fx_dly_type_cur fx_dly_type_usd fx_dly_type_cur_prev
         fx_dly_type_usd_prev fx_dly_type_cur_lead fx_dly_type_usd_lead
         earn_sc cfo_sc accr_sc oneata drev_sc ppe_sc nac abnac
         model_rank residual_df full_rank
         stock_bhr size_bhr sizeajr earn_lead sizeajr_lead table2;
run;

proc sql;
    create table final_dups as
    select gvkey, fyear, count(*) as n
    from rep.mispricing_panel
    group by gvkey, fyear
    having calculated n>1;
    select count(*) as duplicate_final_firm_years from final_dups;
    select count(*) as original_sample_rows, sum(table2) as complete_table2_rows,
           count(distinct gvkey) as original_sample_firms
    from rep.mispricing_panel;
    select curcd, count(*) as original_sample_rows,
           sum(table2=1) as complete_table2_rows,
           sum(fx_flow_ok=0) as current_flow_fx_unavailable,
           sum(fx_stock_ok=0) as current_stock_fx_unavailable,
           sum(fx_flow_ok_prev=0) as prior_flow_fx_unavailable,
           sum(fx_stock_ok_prev=0) as prior_stock_fx_unavailable,
           sum(table2=0 and fx_flow_ok_lead=0) as lead_flow_fx_unavailable
    from rep.mispricing_panel group by curcd;
    select count(*) as known_cur_prior_n,
           sum(not missing(curcd) and not missing(curcd_prev) and curcd ne curcd_prev)
               as cur_prior_mismatch,
           sum(not missing(curcd_prev) and not missing(curcd_prev2) and
               curcd_prev ne curcd_prev2) as prior_pair_mismatch,
           sum(not missing(curcd_lead) and curcd ne curcd_lead) as cur_next_mismatch
    from rep.mispricing_panel;
    select fyear, count(*) as original_sample_rows,
           sum(table2=1) as complete_table2_rows
    from rep.mispricing_panel group by fyear;
    select sum(missing(earn_sc)) as missing_earn,
           sum(missing(cfo_sc)) as missing_cfo,
           sum(missing(nac)) as missing_nac,
           sum(missing(abnac)) as missing_abnac,
           sum(missing(earn_lead)) as missing_earn_lead,
           sum(missing(sizeajr_lead)) as missing_sizeajr_lead
    from rep.mispricing_panel;
quit;

/* Final-path identity checks: every scaled accounting input uses USD amounts. */
proc sql;
    select count(*) as unit_check_rows,
           max(abs(earn_sc*at_usd_prev-ib_usd)) as max_earn_num_error,
           max(abs(cfo_sc*at_usd_prev-cfo_raw)) as max_cfo_num_error,
           max(abs(accr_sc*at_usd_prev-(ib_usd-cfo_raw))) as max_accr_num_error,
           max(abs(oneata*at_usd_prev-1)) as max_oneata_error,
           max(abs(drev_sc*at_usd_prev-(sale_usd-sale_usd_prev))) as max_drev_num_error,
           max(abs(ppe_sc*at_usd_prev-ppegt_usd)) as max_ppe_num_error
    from jones_fit
    where not missing(earn_sc) and not missing(cfo_sc) and not missing(accr_sc) and
          not missing(oneata) and not missing(drev_sc) and not missing(ppe_sc) and
          not missing(at_usd_prev) and at_usd_prev ne 0 and
          not missing(ib_usd) and not missing(cfo_raw) and
          not missing(sale_usd) and not missing(sale_usd_prev) and
          full_rank=1 and
          not missing(ppegt_usd);
quit;

proc means data=rep.mispricing_panel n mean std median min max;
    where table2=1;
    var earn_sc cfo_sc nac abnac earn_lead sizeajr_lead;
run;
