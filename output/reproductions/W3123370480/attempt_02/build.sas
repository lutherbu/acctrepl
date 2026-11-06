options errorabend msglevel=i fullstimer;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname fx "/storage/sas/base/comp/d_global/currency" access=readonly;
libname crsp ("/storage/sas/base/crsp/a_ccm" "/storage/sas/base/crsp/a_stock") access=readonly;
libname out "./data";

/* Keep the source-period accounting history needed for each current and prior
   fiscal-year balance. The file is filtered before any cross-table joins. */
proc sql;
    create table work.fraw0 as
    select gvkey, datadate, fyear, curcd, indfmt, consol, popsrc, datafmt,
           at, ib, dvc, act, che, lct, dlc, txp, dp, oancf, sich
    from comp.funda
    where datadate between '01JAN1957'd and '31MAR2008'd
      and not missing(gvkey)
      and not missing(datadate)
      and not missing(fyear)
      and indfmt = 'INDL'
      and consol = 'C'
      and popsrc = 'D'
      and datafmt = 'STD';
quit;

data work.fraw1;
    set work.fraw0;
    formyr = year(datadate) + (month(datadate) >= 4);
    if 1958 <= formyr and formyr <= 2008;
run;

proc sql;
    create table work.fraw as select distinct * from work.fraw1;

    create table work.fymax as
    select gvkey, fyear, max(datadate) as maxdate format=date9.
    from work.fraw
    group by gvkey, fyear;

    create table work.fytop as
    select a.*
    from work.fraw as a inner join work.fymax as b
      on a.gvkey = b.gvkey and a.fyear = b.fyear and a.datadate = b.maxdate;

    create table work.fytopcnt as
    select gvkey, fyear, count(*) as ntop
    from work.fytop
    group by gvkey, fyear;

    create table work.fyearone as
    select a.*
    from work.fytop as a inner join work.fytopcnt as b
      on a.gvkey = b.gvkey and a.fyear = b.fyear
    where b.ntop = 1;

    select count(*) as tied_latest_fyear_groups
    from work.fytopcnt where ntop > 1;
quit;

/* The provider's cross-rate formula uses GBP as its primary currency:
   reported amount / GBP-to-reporting rate * GBP-to-target rate. Keep all
   quote-type descriptors; rate type is provenance, not an eligibility rule. */
data work.fxday0;
    set fx.g_exrt_dly(keep=datadate fromcurd tocurd exratd exrattpd);
    where datadate >= '01JAN1957'd and datadate <= '31MAR2008'd
      and fromcurd = 'GBP';
run;

data work.fxmon0;
    set fx.g_exrt_mth(keep=datadate fromcurm tocurm exrat12m);
    where datadate >= '01JAN1957'd and datadate <= '31MAR2008'd
      and fromcurm = 'GBP';
run;

proc sql;
    create table work.fxdayg as
    select datadate, tocurd, min(exratd) as fxmin, max(exratd) as fxmax,
           count(distinct exratd) as nrates,
           count(distinct exrattpd) as ntypes,
           min(exrattpd) as typemin, max(exrattpd) as typemax
    from work.fxday0
    where not missing(tocurd)
    group by datadate, tocurd;

    create table work.fxmong as
    select datadate, tocurm, min(exrat12m) as fxmin,
           max(exrat12m) as fxmax, count(distinct exrat12m) as nrates
    from work.fxmon0
    where not missing(tocurm)
    group by datadate, tocurm;
quit;

data work.fxday;
    set work.fxdayg;
    fxrate = .;
    if nrates = 1 and fxmin > 0 and fxmin = fxmax then fxrate = fxmin;
run;

data work.fxmon;
    set work.fxmong;
    fxrate = .;
    if nrates = 1 and fxmin > 0 and fxmin = fxmax then fxrate = fxmin;
run;

proc sql;
    select min(datadate) as dly_first format=date9.,
           max(datadate) as dly_last format=date9., count(*) as dly_gbp_rows
    from work.fxday0;
    select min(datadate) as mth_first format=date9.,
           max(datadate) as mth_last format=date9., count(*) as mth_gbp_rows
    from work.fxmon0;
    select min(datadate) as dly_usd_first format=date9.,
           max(datadate) as dly_usd_last format=date9.,
           count(*) as dly_usd_quote_dates
    from work.fxday where tocurd = 'USD' and not missing(fxrate);
    select min(datadate) as mth_usd_first format=date9.,
           max(datadate) as mth_usd_last format=date9.,
           count(*) as mth_usd_quote_dates
    from work.fxmon where tocurm = 'USD' and not missing(fxrate);
quit;

/* Exact-date joins keep the balance sheet at its report-date rate and flow
   items at the 12-month average for that same reported period. */
proc sql;
    create table work.fxstat as
    select a.*,
           dr.fxrate as drep, dr.nrates as drep_nrate,
           dr.ntypes as drep_ntype, dr.typemin as drep_typemin,
           dr.typemax as drep_typemax,
           du.fxrate as dusd, du.nrates as dusd_nrate,
           du.ntypes as dusd_ntype, du.typemin as dusd_typemin,
           du.typemax as dusd_typemax,
           mr.fxrate as mrep, mr.nrates as mrep_nrate,
           mu.fxrate as musd, mu.nrates as musd_nrate
    from work.fyearone as a
    left join work.fxday as dr
      on a.datadate = dr.datadate and a.curcd = dr.tocurd
    left join work.fxday as du
      on a.datadate = du.datadate and du.tocurd = 'USD'
    left join work.fxmon as mr
      on a.datadate = mr.datadate and a.curcd = mr.tocurm
    left join work.fxmon as mu
      on a.datadate = mu.datadate and mu.tocurm = 'USD';
quit;

data work.fxstat1;
    set work.fxstat;
    d_factor = .;
    m_factor = .;
    if curcd = 'USD' then do;
        d_factor = 1;
        m_factor = 1;
    end;
    else if curcd = 'GBP' then do;
        if not missing(dusd) and dusd > 0 then d_factor = dusd;
        if not missing(musd) and musd > 0 then m_factor = musd;
    end;
    else if not missing(curcd) then do;
        if not missing(drep) and not missing(dusd) and drep > 0 and dusd > 0 then
            d_factor = dusd / drep;
        if not missing(mrep) and not missing(musd) and mrep > 0 and musd > 0 then
            m_factor = musd / mrep;
    end;

    at_usd = .; act_usd = .; che_usd = .; lct_usd = .;
    dlc_usd = .; txp_usd = .;
    ib_usd = .; dvc_usd = .; dp_usd = .; ocf_usd = .;
    if not missing(at) and not missing(d_factor) then at_usd = at * d_factor;
    if not missing(act) and not missing(d_factor) then act_usd = act * d_factor;
    if not missing(che) and not missing(d_factor) then che_usd = che * d_factor;
    if not missing(lct) and not missing(d_factor) then lct_usd = lct * d_factor;
    if not missing(dlc) and not missing(d_factor) then dlc_usd = dlc * d_factor;
    if not missing(txp) and not missing(d_factor) then txp_usd = txp * d_factor;
    if not missing(ib) and not missing(m_factor) then ib_usd = ib * m_factor;
    if not missing(dvc) and not missing(m_factor) then dvc_usd = dvc * m_factor;
    if not missing(dp) and not missing(m_factor) then dp_usd = dp * m_factor;
    if not missing(oancf) and not missing(m_factor) then ocf_usd = oancf * m_factor;
run;

/* Prior balance-sheet amounts are already translated at their own dates. */
proc sql;
    create table work.accr0 as
    select a.*,
           b.datadate as pdate format=date9., b.curcd as pcurcd,
           b.act_usd as pact_usd, b.che_usd as pche_usd,
           b.lct_usd as plct_usd, b.dlc_usd as pdlc_usd,
           b.txp_usd as ptxp_usd
    from work.fxstat1 as a
    left join work.fxstat1 as b
      on a.gvkey = b.gvkey and b.fyear = a.fyear - 1
    where 1962 <= a.formyr and a.formyr <= 2008;
quit;

data work.accr1;
    set work.accr0;
    accr = .;
    if fyear < 1988 then do;
        if nmiss(act_usd, che_usd, lct_usd, dlc_usd, txp_usd, dp_usd,
                 pact_usd, pche_usd, plct_usd, pdlc_usd, ptxp_usd) = 0 then
            accr = (act_usd - che_usd) - (pact_usd - pche_usd)
                   - ((lct_usd - dlc_usd - txp_usd)
                      - (plct_usd - pdlc_usd - ptxp_usd)) - dp_usd;
    end;
    else if fyear >= 1988 and nmiss(ib_usd, ocf_usd) = 0 then
        accr = ib_usd - ocf_usd;
    if fyear >= 1963 and 1963 <= formyr and formyr <= 2008;
run;

proc sql;
    create table work.formmax as
    select gvkey, formyr, max(datadate) as maxdate format=date9.
    from work.accr1
    group by gvkey, formyr;

    create table work.formtop as
    select a.*
    from work.accr1 as a inner join work.formmax as b
      on a.gvkey = b.gvkey and a.formyr = b.formyr and a.datadate = b.maxdate;

    create table work.formcnt as
    select gvkey, formyr, count(*) as ntop
    from work.formtop
    group by gvkey, formyr;

    create table work.ann as
    select a.*
    from work.formtop as a inner join work.formcnt as b
      on a.gvkey = b.gvkey and a.formyr = b.formyr
    where b.ntop = 1;

    select count(*) as tied_latest_formation_groups
    from work.formcnt where ntop > 1;

    select formyr, min(datadate) as first_statement format=date9.,
           max(datadate) as last_statement format=date9., count(*) as funda_rows
    from work.ann group by formyr order by formyr;

    select curcd, count(*) as annual_rows,
           sum(not missing(d_factor)) as daily_factor_rows,
           sum(not missing(m_factor)) as monthly_factor_rows,
           sum(not missing(at_usd)) as at_usd_rows,
           sum(not missing(ib_usd)) as ib_usd_rows,
           sum(not missing(dvc_usd)) as dvc_usd_rows,
           sum(not missing(accr)) as accr_rows
    from work.ann group by curcd order by curcd;

    select formyr, curcd, count(*) as annual_rows,
           sum(not missing(d_factor)) as daily_factor_rows,
           sum(not missing(m_factor)) as monthly_factor_rows,
           sum(not missing(at_usd)) as at_usd_rows,
           sum(not missing(ib_usd)) as ib_usd_rows,
           sum(not missing(dvc_usd)) as dvc_usd_rows,
           sum(not missing(accr)) as accr_rows
    from work.ann group by formyr, curcd order by formyr, curcd;

    /* For non-USD currencies, separate an absent dated leg from a date with
       an empty, nonpositive, or conflicting quote pair. */
    select formyr, curcd, count(*) as annual_rows,
           sum(missing(drep_nrate)) as drep_absent,
           sum(drep_nrate = 0) as drep_no_numeric_quote,
           sum(drep_nrate > 1) as drep_ambiguous,
           sum(drep_nrate = 1 and missing(drep)) as drep_nonpositive,
           sum(not missing(drep)) as drep_unique_positive,
           sum(missing(dusd_nrate)) as dusd_absent,
           sum(dusd_nrate = 0) as dusd_no_numeric_quote,
           sum(dusd_nrate > 1) as dusd_ambiguous,
           sum(dusd_nrate = 1 and missing(dusd)) as dusd_nonpositive,
           sum(not missing(dusd)) as dusd_unique_positive,
           sum(missing(mrep_nrate)) as mrep_absent,
           sum(mrep_nrate = 0) as mrep_no_numeric_quote,
           sum(mrep_nrate > 1) as mrep_ambiguous,
           sum(mrep_nrate = 1 and missing(mrep)) as mrep_nonpositive,
           sum(not missing(mrep)) as mrep_unique_positive,
           sum(missing(musd_nrate)) as musd_absent,
           sum(musd_nrate = 0) as musd_no_numeric_quote,
           sum(musd_nrate > 1) as musd_ambiguous,
           sum(musd_nrate = 1 and missing(musd)) as musd_nonpositive,
           sum(not missing(musd)) as musd_unique_positive,
           sum(not missing(d_factor)) as daily_conversion_rows,
           sum(not missing(m_factor)) as monthly_conversion_rows
    from work.ann
    where not missing(curcd) and curcd not in ('USD', 'GBP')
    group by formyr, curcd order by formyr, curcd;
quit;

proc sql;
    select count(*) as ccm_link_rows,
           sum(missing(linkdt)) as open_or_missing_link_starts,
           sum(missing(linkenddt)) as open_or_missing_link_ends,
           sum(linkenddt = .E) as ccm_end_e_rows
    from crsp.ccmxpf_linktable;
quit;

proc sql;
    create table work.linkcand as
    select distinct a.gvkey, a.formyr, a.datadate, a.fyear, a.curcd,
           l.lpermno as permno
    from work.ann as a
    inner join crsp.ccmxpf_linktable as l
      on a.gvkey = l.gvkey
     and l.linktype in ('LC', 'LU')
     and l.linkprim in ('P', 'C')
     and (missing(l.linkdt) or l.linkdt <= mdy(6, 30, a.formyr))
     and (missing(l.linkenddt) or l.linkenddt >= mdy(6, 30, a.formyr))
    where not missing(l.lpermno) and l.lpermno ne 0;

    create table work.linkcnt as
    select gvkey, formyr, count(*) as nperm
    from work.linkcand group by gvkey, formyr;

    create table work.linkone as
    select a.*
    from work.linkcand as a inner join work.linkcnt as b
      on a.gvkey = b.gvkey and a.formyr = b.formyr
    where b.nperm = 1;

    create table work.permgv as
    select distinct permno, formyr, gvkey from work.linkone;

    create table work.permcnt as
    select permno, formyr, count(*) as ngv
    from work.permgv group by permno, formyr;

    create table work.linkuniq as
    select a.*
    from work.linkone as a inner join work.permcnt as b
      on a.permno = b.permno and a.formyr = b.formyr
    where b.ngv = 1;

    select count(*) as gvkeyyr_multi_permno from work.linkcnt where nperm > 1;
    select count(*) as permyr_multi_gvkey from work.permcnt where ngv > 1;
quit;

proc sql;
    create table work.namecand as
    select distinct l.permno, l.formyr, n.shrcd, n.exchcd
    from work.linkuniq as l inner join crsp.dsenames as n
      on l.permno = n.permno
     and (missing(n.namedt) or n.namedt <= mdy(6, 30, l.formyr))
     and (missing(n.nameendt) or n.nameendt >= mdy(6, 30, l.formyr));

    create table work.namecnt as
    select permno, formyr, count(*) as ncode
    from work.namecand group by permno, formyr;

    create table work.nameone as
    select a.*
    from work.namecand as a inner join work.namecnt as b
      on a.permno = b.permno and a.formyr = b.formyr
    where b.ncode = 1 and a.shrcd in (10, 11) and a.exchcd in (1, 2, 3);

    select count(*) as permyr_ambig_name from work.namecnt where ncode > 1;
quit;

proc sql;
    select min(date) as first_msf_date format=date9.,
           max(date) as last_msf_date format=date9.,
           count(*) as msf_rows
    from crsp.msf;
quit;

data work.junemsf;
    set crsp.msf(keep=permno date);
    where date >= '01JUN1963'd and date <= '30JUN2008'd;
    if month(date) = 6;
    formyr = year(date);
    keep permno formyr date;
run;

proc sql;
    create table work.junesec as
    select distinct permno, formyr from work.junemsf;

    select formyr, count(*) as june_securities
    from work.junesec group by formyr order by formyr;
quit;

proc sql;
    create table work.pop0 as
    select distinct a.gvkey, l.permno, a.formyr, a.datadate, a.fyear,
           a.curcd, a.sich, a.d_factor, a.m_factor,
           a.drep, a.drep_ntype, a.drep_typemin, a.drep_typemax,
           a.dusd, a.dusd_ntype, a.dusd_typemin, a.dusd_typemax,
           a.mrep, a.musd, a.ib_usd, a.at_usd, a.dvc_usd, a.accr,
           n.shrcd, n.exchcd
    from work.ann as a
    inner join work.linkuniq as l
      on a.gvkey = l.gvkey and a.formyr = l.formyr
    inner join work.nameone as n
      on l.permno = n.permno and l.formyr = n.formyr
    inner join work.junesec as j
      on n.permno = j.permno and n.formyr = j.formyr
    where n.shrcd in (10, 11) and n.exchcd in (1, 2, 3);

    select formyr, count(*) as primary_share_n,
           count(distinct gvkey) as gvkeys,
           sum(curcd = 'USD') as usd_rows,
           sum(curcd ne 'USD' and not missing(curcd)) as nonusd_rows,
           sum(missing(curcd)) as missing_currency_rows,
           sum(not missing(at_usd)) as n_at_usd,
           sum(not missing(ib_usd)) as n_ib_usd,
           sum(not missing(dvc_usd)) as n_dvc_usd,
           sum(not missing(accr)) as n_accr,
           sum(sich = 6798) as historical_sic_6798_rows
    from work.pop0 group by formyr order by formyr;

    select curcd, count(*) as eligible_rows,
           sum(not missing(d_factor)) as daily_factor_rows,
           sum(not missing(m_factor)) as monthly_factor_rows,
           sum(not missing(at_usd)) as n_at_usd,
           sum(not missing(ib_usd)) as n_ib_usd,
           sum(not missing(dvc_usd)) as n_dvc_usd,
           sum(not missing(accr)) as n_accr
    from work.pop0 group by curcd order by curcd;

    select sum(sich = 6798) as kept_sic_6798_rows from work.pop0;

    select formyr, sum(missing(dvc_usd)) as dvc_usd_missing,
           sum(dvc_usd = 0) as dvc_observed_zero,
           sum(dvc_usd > 0) as dvc_positive,
           sum(dvc_usd < 0) as dvc_negative
    from work.pop0 group by formyr order by formyr;
quit;

proc sort data=work.pop0 out=work.pop0s;
    by formyr;
run;

proc univariate data=work.pop0s noprint;
    by formyr;
    var ib_usd at_usd dvc_usd accr;
    output out=work.cuts
        pctlpts=1 99
        pctlpre=ib_ at_ dvc_ ac_
        pctlname=p1 p99;
run;

proc sql;
    create table work.anncut as
    select a.*, c.ib_p1, c.ib_p99, c.at_p1, c.at_p99,
           c.dvc_p1, c.dvc_p99, c.ac_p1, c.ac_p99
    from work.ann as a left join work.cuts as c
      on a.formyr = c.formyr;
quit;

data work.annw;
    set work.anncut;
    ibw = .; atw = .; dvw = .; acw = .;
    dd = .; negib = .;
    if not missing(ib) then negib = (ib < 0);
    if not missing(dvc) then dd = (dvc > 0);
    if not missing(ib_usd) and not missing(ib_p1) and not missing(ib_p99) then
        ibw = min(max(ib_usd, ib_p1), ib_p99);
    if not missing(at_usd) and not missing(at_p1) and not missing(at_p99) then
        atw = min(max(at_usd, at_p1), at_p99);
    if not missing(dvc_usd) and not missing(dvc_p1) and not missing(dvc_p99) then
        dvw = min(max(dvc_usd, dvc_p1), dvc_p99);
    if not missing(accr) and not missing(ac_p1) and not missing(ac_p99) then
        acw = min(max(accr, ac_p1), ac_p99);
    keep gvkey datadate fyear formyr curcd sich
         ibw atw dvw dd negib acw d_factor m_factor
         drep drep_ntype drep_typemin drep_typemax
         dusd dusd_ntype dusd_typemin dusd_typemax mrep musd;
run;

proc sql;
    create table work.popw as
    select a.gvkey, a.permno, a.formyr, a.datadate, a.fyear,
           a.curcd, a.sich, a.shrcd, a.exchcd,
           a.d_factor, a.m_factor,
           a.drep, a.drep_ntype, a.drep_typemin, a.drep_typemax,
           a.dusd, a.dusd_ntype, a.dusd_typemin, a.dusd_typemax,
           a.mrep, a.musd,
           b.ibw, b.atw, b.dvw, b.dd, b.negib, b.acw
    from work.pop0 as a inner join work.annw as b
      on a.gvkey = b.gvkey and a.formyr = b.formyr;

    select formyr, count(*) as eligible_security_rows,
           sum(curcd = 'USD') as usd_rows,
           sum(curcd ne 'USD' and not missing(curcd)) as nonusd_rows,
           sum(not missing(ibw)) as n_ibw,
           sum(not missing(atw)) as n_atw,
           sum(not missing(dvw)) as n_dvw,
           sum(not missing(dd)) as n_dd,
           sum(not missing(negib)) as n_negib,
           sum(not missing(acw)) as n_acw
    from work.popw group by formyr order by formyr;
quit;

proc sort data=work.popw out=work.popws;
    by formyr;
run;

proc means data=work.popws noprint;
    by formyr;
    var ibw atw dvw dd negib acw;
    output out=work.annstats(drop=_type_ _freq_)
        n=n_ib n_at n_dv n_dd n_nege n_ac
        mean=m_ib m_at m_dv m_dd m_nege m_ac
        p1=p1_ib p1_at p1_dv p1_dd p1_nege p1_ac
        p25=p25_ib p25_at p25_dv p25_dd p25_nege p25_ac
        median=med_ib med_at med_dv med_dd med_nege med_ac
        p75=p75_ib p75_at p75_dv p75_dd p75_nege p75_ac
        p99=p99_ib p99_at p99_dv p99_dd p99_nege p99_ac
        std=sd_ib sd_at sd_dv sd_dd sd_nege sd_ac;
run;

title "Annual-average cross-sectional summaries after USD translation and winsorization";
proc means data=work.annstats mean;
    var m_ib p1_ib p25_ib med_ib p75_ib p99_ib sd_ib
        m_at p1_at p25_at med_at p75_at p99_at sd_at
        m_dv p1_dv p25_dv med_dv p75_dv p99_dv sd_dv
        m_dd p1_dd p25_dd med_dd p75_dd p99_dd sd_dd
        m_nege p1_nege p25_nege med_nege p75_nege p99_nege sd_nege
        m_ac p1_ac p25_ac med_ac p75_ac p99_ac sd_ac;
run;
title;

/* For each historical predictor year, retain the realized Compustat earnings
   outcome at exactly tau years ahead. X is screened at the predictor year's
   CRSP/Compustat intersection; outcome earnings need not retain a future
   listing after delisting. Both amounts have their own annual USD cutoffs. */
proc sql;
    create table work.pairs0 as
    select x.gvkey, x.permno, x.formyr as xyear, x.datadate as xdate format=date9.,
           x.fyear as xfyear, x.curcd as xcur, x.shrcd, x.exchcd,
           x.d_factor as xd_factor, x.m_factor as xm_factor,
           x.drep as xdrep, x.drep_ntype as xdrep_ntype,
           x.drep_typemin as xdrep_typemin, x.drep_typemax as xdrep_typemax,
           x.dusd as xdusd, x.dusd_ntype as xdusd_ntype,
           x.dusd_typemin as xdusd_typemin, x.dusd_typemax as xdusd_typemax,
           x.mrep as xmrep, x.musd as xmusd,
           y.formyr as outyr, y.datadate as ydate format=date9.,
           y.fyear as yfyear, y.curcd as ycur, y.m_factor as ym_factor,
           y.mrep as ymrep, y.musd as ymusd, y.ibw as yib,
           x.atw, x.dvw, x.dd, x.ibw, x.negib, x.acw,
           y.formyr - x.formyr as tau
    from work.popw as x inner join work.annw as y
      on x.gvkey = y.gvkey
     and y.formyr between x.formyr + 1 and x.formyr + 3
    where 1963 <= x.formyr and x.formyr <= 2007
      and 1964 <= y.formyr and y.formyr <= 2007
      and not missing(x.atw)
      and not missing(x.dvw)
      and not missing(x.dd)
      and not missing(x.ibw)
      and not missing(x.negib)
      and not missing(x.acw)
      and not missing(y.ibw);
quit;

data work.train0;
    set work.pairs0;
    if tau not in (1, 2, 3) then delete;
    if xyear ne outyr - tau then delete;
    if ydate > mdy(3, 31, outyr) then delete;
    if xdate > mdy(3, 31, xyear) then delete;
    firstfit = max(1968, outyr + 1);
    lastfit = min(2008, outyr + 10);
    do fit_year = firstfit to lastfit;
        if fit_year - 10 <= outyr and outyr <= fit_year - 1 then output;
    end;
    drop firstfit lastfit;
run;

proc sort data=work.train0 out=work.trains;
    by tau gvkey permno outyr fit_year;
run;

data work.train;
    set work.trains;
    by tau gvkey permno outyr fit_year;
    retain panelid 0;
    if first.outyr then panelid + 1;
    keep fit_year tau gvkey permno outyr xyear xfyear yfyear xdate ydate
         xcur ycur shrcd exchcd panelid yib atw dvw dd ibw negib acw
         xd_factor xm_factor xdrep xdrep_ntype xdrep_typemin xdrep_typemax
         xdusd xdusd_ntype xdusd_typemin xdusd_typemax xmrep xmusd
         ym_factor ymrep ymusd;
run;

/* PROC REG is used only for annual fit diagnostics. ODS retains ANOVA model
   degrees of freedom and fit statistics; no parameter-estimate table is
   captured, printed, or retained. Stata xtfmb estimates average coefficients
   and HAC inference. */
proc sort data=work.train out=work.regin;
    by tau fit_year;
run;

ods select none;
ods output ANOVA=work.ods_anova FitStatistics=work.ods_fit;
proc reg data=work.regin;
    by tau fit_year;
    model yib = atw dvw dd ibw negib acw;
run;
quit;
ods output close;
ods select all;

proc sql;
    create table work.poolcounts as
    select tau, fit_year, count(*) as fit_n
    from work.train group by tau, fit_year;

    create table work.regrank as
    select tau, fit_year, max(df) as slope_rank
    from work.ods_anova
    where upcase(source) = 'MODEL'
    group by tau, fit_year;

    create table work.regfit as
    select tau, fit_year,
           max(case when label2 = 'R-Square' then nvalue2 else . end) as rsq,
           max(case when label2 = 'Adj R-Sq' then nvalue2 else . end) as ar2
    from work.ods_fit group by tau, fit_year;

    create table work.regstat as
    select a.tau, a.fit_year, a.fit_n, b.slope_rank, c.rsq, c.ar2
    from work.poolcounts as a
    left join work.regrank as b
      on a.tau = b.tau and a.fit_year = b.fit_year
    left join work.regfit as c
      on a.tau = c.tau and a.fit_year = c.fit_year;
quit;

proc datasets library=work nolist;
    delete regin ods_anova ods_fit;
quit;

data work.expected;
    do tau = 1 to 3;
        do fit_year = 1968 to 2008;
            output;
        end;
    end;
run;

proc sql;
    create table work.fitcheck as
    select e.tau, e.fit_year, coalesce(r.fit_n, 0) as fit_n,
           r.slope_rank, r.rsq, r.ar2,
           (not missing(r.slope_rank) and r.slope_rank = 6 and r.fit_n > 7) as fitok
    from work.expected as e left join work.regstat as r
      on e.tau = r.tau and e.fit_year = r.fit_year;

    select tau, fit_year, fit_n, slope_rank, rsq, ar2, fitok
    from work.fitcheck order by tau, fit_year;

    select tau, sum(fitok) as full_rank_origins,
           mean(case when fitok = 1 then ar2 else . end) as mean_adjusted_r2
    from work.fitcheck group by tau order by tau;

    create table work.fitmeans as
    select tau, sum(fitok) as full_rank_origins,
           mean(case when fitok = 1 then ar2 else . end) as mean_ar2
    from work.fitcheck group by tau;

    create table work.train2 as
    select a.*, b.fitok, c.full_rank_origins, c.mean_ar2 as ar2mean
    from work.train as a
    left join work.fitcheck as b
      on a.tau = b.tau and a.fit_year = b.fit_year
    left join work.fitmeans as c
      on a.tau = c.tau;

    select a.tau, a.fit_year, count(*) as complete_pool_n,
           max(a.fitok) as fitok, max(a.full_rank_origins) as full_rank_origins,
           max(a.ar2mean) as mean_adjusted_r2
    from work.train2 as a group by a.tau, a.fit_year order by a.tau, a.fit_year;
quit;

proc sql;
    create table work.keydups as
    select fit_year, tau, gvkey, permno, outyr, count(*) as nrows
    from work.train2
    group by fit_year, tau, gvkey, permno, outyr
    having calculated nrows > 1;

    select count(*) as duplicate_key_groups from work.keydups;

    select tau, fit_year, count(*) as complete_pool_n,
           min(xdate) as min_predictor_date format=date9.,
           max(xdate) as max_predictor_date format=date9.,
           min(ydate) as min_outcome_date format=date9.,
           max(ydate) as max_outcome_date format=date9.
    from work.train2 group by tau, fit_year order by tau, fit_year;

    select tau, fit_year,
           min(xyear) as first_predictor_formation,
           max(xyear) as last_predictor_formation,
           min(xfyear) as first_predictor_fyear,
           max(xfyear) as last_predictor_fyear,
           min(xdate) as first_predictor_date format=date9.,
           max(xdate) as last_predictor_date format=date9.,
           min(outyr) as first_outcome_formation,
           max(outyr) as last_outcome_formation,
           min(yfyear) as first_outcome_fyear,
           max(yfyear) as last_outcome_fyear,
           min(ydate) as first_outcome_date format=date9.,
           max(ydate) as last_outcome_date format=date9.
    from work.train2
    where fit_year in (1968, 2008) and tau in (1, 3)
    group by tau, fit_year order by tau, fit_year;

    select xcur as predictor_currency, count(*) as training_rows
    from work.train2 group by xcur order by xcur;

    select count(*) as future_outcome_date_violations
    from work.train2
    where outyr > fit_year - 1
       or ydate > mdy(3, 31, fit_year - 1)
       or xyear ne outyr - tau;
quit;

data _null_;
    if 0 then set work.keydups nobs=ndup;
    if ndup > 0 then do;
        put 'ERROR: Duplicate training-sample keys remain after source and link audits.';
        abort cancel;
    end;
    stop;
run;

data out.icc_firm_year;
    set work.train2;
    label fit_year = 'June forecast-origin year for rolling coefficient fit'
          tau = 'Earnings forecast horizon'
          outyr = 'Formation year of realized training earnings'
          xyear = 'Formation year of predictor record'
          yib = 'Winsorized future income before extraordinary items, USD millions'
          atw = 'Winsorized total assets, USD millions'
          dvw = 'Winsorized common dividends DVC, USD millions'
          dd = 'Indicator for observed common dividends greater than zero'
          ibw = 'Winsorized current income before extraordinary items, USD millions'
          negib = 'Indicator for negative current earnings'
          acw = 'Winsorized accruals, USD millions'
          fitok = 'Indicator that annual pooled OLS is full rank'
          ar2mean = 'Mean adjusted R-squared across full-rank annual fits'
          xcur = 'Predictor statement reporting currency'
          ycur = 'Outcome statement reporting currency'
          xd_factor = 'Daily conversion factor from reporting currency to USD'
          xm_factor = 'Monthly conversion factor from reporting currency to USD'
          ym_factor = 'Outcome monthly conversion factor from reporting currency to USD';
    format xdate ydate date9.;
run;

proc contents data=out.icc_firm_year;
run;

proc means data=work.train2 n nmiss mean p1 p50 p99;
    class tau;
    var yib atw dvw dd ibw negib acw;
run;
