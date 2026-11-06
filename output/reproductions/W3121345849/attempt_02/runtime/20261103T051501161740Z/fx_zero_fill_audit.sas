options errorabend;

libname compna "/storage/sas/base/comp/d_na" access=readonly;
libname fxsrc "/storage/sas/base/comp/d_global/currency" access=readonly;

/* Bounded Table 1 support: exact Funda filters, dates, duplicate policy,
   own-period currency conversion and one-year prior / one-to-three-year lead. */
data f0;
    set compna.funda
        (keep=gvkey datadate indfmt consol popsrc datafmt curcd fdate
              ib spi at dvc csho act che lct dlc txp dp ceq lt ivst pstk);
    if upcase(indfmt) ne "INDL" then delete;
    if upcase(consol) ne "C" then delete;
    if upcase(popsrc) ne "D" then delete;
    if upcase(datafmt) ne "STD" then delete;
    if missing(gvkey) or missing(datadate) then delete;
    if datadate < '01APR1955'd or datadate > '31MAR2012'd then delete;
    if month(datadate) >= 4 then avyear=year(datadate)+1;
    else avyear=year(datadate);
    if avyear < 1956 or avyear > 2012 then delete;
    mthkey=intnx('month',datadate,0,'b');
run;

proc sort data=f0 out=f0sort;
    by gvkey avyear descending datadate descending fdate;
run;

data f1;
    set f0sort;
    by gvkey avyear;
    if first.avyear;
run;

data dly0;
    set fxsrc.g_exrt_dly
        (keep=datadate fromcurd tocurd exratd);
    if upcase(fromcurd) ne "GBP" then delete;
    if datadate < '01APR1955'd or datadate > '31MAR2012'd then delete;
    tocur=upcase(tocurd);
    if tocur not in ("USD","CAD") then delete;
    if missing(exratd) or exratd <= 0 then delete;
run;

proc sql;
    create table dly as
    select datadate, tocur, min(exratd) as rate
    from dly0
    group by datadate, tocur
    having min(exratd)=max(exratd);
quit;

data mth0;
    set fxsrc.g_exrt_mth
        (keep=datadate fromcurm tocurm exrat12m);
    if upcase(fromcurm) ne "GBP" then delete;
    if datadate < '01APR1955'd or datadate > '31MAR2012'd then delete;
    tocur=upcase(tocurm);
    if tocur not in ("USD","CAD") then delete;
    if missing(exrat12m) or exrat12m <= 0 then delete;
    monthkey=intnx('month',datadate,0,'b');
run;

proc sql;
    create table mth as
    select monthkey, tocur, min(exrat12m) as rate
    from mth0
    group by monthkey, tocur
    having min(exrat12m)=max(exrat12m);

    create table fx0 as
    select a.*,
           du.rate as usd_d_rate,
           dc.rate as cur_d_rate,
           mu.rate as usd_m_rate,
           mc.rate as cur_m_rate
    from f1 as a
    left join dly as dc
      on a.datadate=dc.datadate and upcase(a.curcd)=dc.tocur
    left join dly as du
      on a.datadate=du.datadate and du.tocur="USD"
    left join mth as mc
      on a.mthkey=mc.monthkey and upcase(a.curcd)=mc.tocur
    left join mth as mu
      on a.mthkey=mu.monthkey and mu.tocur="USD";
quit;

data fx1;
    set fx0;
    if upcase(curcd)="USD" then do;
        fxbs=1;
        fxflow=1;
    end;
    else do;
        fxbs=.;
        fxflow=.;
        if cur_d_rate>0 and usd_d_rate>0 then fxbs=usd_d_rate/cur_d_rate;
        if cur_m_rate>0 and usd_m_rate>0 then fxflow=usd_m_rate/cur_m_rate;
    end;
run;

proc freq data=fx1;
    tables curcd / missing;
run;

proc sql;
    create table ffeat as
    select a.gvkey, a.avyear, a.curcd, a.fxbs, a.fxflow,
           a.ib, a.spi, a.at, a.dvc, a.csho, a.act, a.che, a.lct,
           a.dlc, a.txp, a.dp, a.ceq, a.lt, a.ivst, a.pstk,
           p.curcd as curcd_l, p.fxbs as fxbs_l,
           p.act as act_l, p.che as che_l, p.lct as lct_l,
           p.dlc as dlc_l, p.txp as txp_l,
           p.at as at_l, p.lt as lt_l, p.ivst as ivst_l,
           p.pstk as pstk_l,
           b1.ib as ib1, b1.spi as spi1, b1.fxflow as fxflow1,
           b2.ib as ib2, b2.spi as spi2, b2.fxflow as fxflow2,
           b3.ib as ib3, b3.spi as spi3, b3.fxflow as fxflow3
    from fx1 as a
    left join fx1 as p
      on a.gvkey=p.gvkey and p.avyear=a.avyear-1
    left join fx1 as b1
      on a.gvkey=b1.gvkey and b1.avyear=a.avyear+1
    left join fx1 as b2
      on a.gvkey=b2.gvkey and b2.avyear=a.avyear+2
    left join fx1 as b3
      on a.gvkey=b3.gvkey and b3.avyear=a.avyear+3
    where a.avyear>=1957 and a.avyear<=2011;
quit;

data audit_base;
    set ffeat;
    ac_raw_ok=(n(act,che,lct,dlc,txp,dp,
                 act_l,che_l,lct_l,dlc_l,txp_l)=11);
    ac_fx_ok=0;
    if ac_raw_ok then
        ac_fx_ok=(not missing(fxbs) and fxbs>0 and
                  not missing(fxbs_l) and fxbs_l>0 and
                  not missing(fxflow) and fxflow>0);

    tacc_raw_ok=(n(at,che,lt,ivst,pstk,
                   at_l,che_l,lt_l,ivst_l,pstk_l,csho)=11 and csho>0);
    tacc_fx_ok=0;
    if tacc_raw_ok then
        tacc_fx_ok=(not missing(fxbs) and fxbs>0 and
                    not missing(fxbs_l) and fxbs_l>0);

    hvz_base_ok=(not missing(at) and not missing(fxbs) and fxbs>0 and
                 not missing(dvc) and not missing(fxflow) and fxflow>0 and
                 not missing(ib) and not missing(spi));
    ep_base_ok=(not missing(ib) and not missing(spi) and
                not missing(csho) and csho>0 and
                not missing(fxflow) and fxflow>0);
    ri_base_ok=(ep_base_ok and not missing(ceq) and
                not missing(fxbs) and fxbs>0);

    array iblead[3] ib1 ib2 ib3;
    array spilead[3] spi1 spi2 spi3;
    array fxlead[3] fxflow1 fxflow2 fxflow3;
    do h=1 to 3;
        if h=1 then do;
            min_av=1959; max_av=2011;
        end;
        else if h=2 then do;
            min_av=1958; max_av=2010;
        end;
        else do;
            min_av=1957; max_av=2009;
        end;
        lead_ok=(not missing(iblead[h]) and not missing(spilead[h]) and
                 not missing(fxlead[h]) and fxlead[h]>0);
        if avyear>=min_av and avyear<=max_av and lead_ok then do;
            length model $3 cause $16;

            if hvz_base_ok then do;
                model="HVZ";
                if not ac_raw_ok then cause="RAW_MISSING_ZERO";
                else if not ac_fx_ok then cause="FX_ONLY_ZERO";
                else cause="AC_CONVERTED";
                output;
            end;

            if ep_base_ok then do;
                model="EP";
                cause="EP_ELIGIBLE";
                output;
            end;

            if ri_base_ok and (h<3 or avyear>=1958) then do;
                model="RI";
                if not tacc_raw_ok then cause="RAW_MISSING_ZERO";
                else if not tacc_fx_ok then cause="FX_ONLY_ZERO";
                else cause="TACC_CONVERTED";
                output;
            end;
        end;
    end;

    keep gvkey avyear curcd_l h model cause ac_raw_ok ac_fx_ok tacc_raw_ok tacc_fx_ok;
run;

title "W3121345849 bounded missing-construct attribution by Table 1 horizon";
proc sql;
    select model, h as horizon, count(*) as otherwise_eligible_union_rows,
           sum(cause="RAW_MISSING_ZERO") as explicit_raw_missing_zeros,
           sum(cause="FX_ONLY_ZERO") as fx_only_zero_fills,
           sum(cause in ("AC_CONVERTED","TACC_CONVERTED")) as construct_converted
    from audit_base
    group by model, h
    order by model, h;
quit;

data audit_fitrows;
    set audit_base;
    do fityear=1969 to 2012;
        if avyear>=fityear-9-h and avyear<=fityear-h then output;
    end;
    keep gvkey avyear fityear h model cause curcd_l;
run;

title "W3121345849 FX-only zero-fill frequency across rolling fit uses";
proc sql;
    select model, h as horizon, count(*) as eligible_fit_observations,
           sum(cause="RAW_MISSING_ZERO") as raw_missing_zero_uses,
           sum(cause="FX_ONLY_ZERO") as fx_only_zero_uses
    from audit_fitrows
    group by model, h
    order by model, h;

    select model, h as horizon, curcd_l as prior_currency,
           count(*) as unique_fx_only_union_rows
    from audit_base
    where cause="FX_ONLY_ZERO"
    group by model, h, curcd_l
    order by model, h, curcd_l;
quit;

libname compna clear;
libname fxsrc clear;
