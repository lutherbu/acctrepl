options errorabend;

libname compna "/storage/sas/base/comp/d_na" access=readonly;
libname fxsrc "/storage/sas/base/comp/d_global/currency" access=readonly;
libname out "data";

data funda_raw;
    set compna.funda
        (keep=gvkey datadate fyear indfmt consol popsrc datafmt curcd curncd fdate
              ib spi at dvc csho act che lct dlc txp dp ceq ivst ivao lt dltt pstk);
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
    format datadate mthkey date9.;
run;

title "W3121345849 source panel endpoints and availability years";
proc sql;
    select count(*) as source_rows,
           count(distinct gvkey) as companies,
           min(datadate) format=date9. as first_datadate,
           max(datadate) format=date9. as last_datadate,
           min(avyear) as first_avyear,
           max(avyear) as last_avyear
    from funda_raw;
quit;

proc sql;
    create table dup_year as
    select gvkey, avyear, count(*) as nrows
    from funda_raw
    group by gvkey, avyear
    having calculated nrows > 1;
    select count(*) as duplicate_gvkey_avyear_groups,
           sum(nrows-1) as duplicate_rows_to_resolve
    from dup_year;
quit;

proc sort data=funda_raw out=funda_sort;
    by gvkey avyear descending datadate descending fdate;
run;

data funda_unique;
    set funda_sort;
    by gvkey avyear;
    if first.avyear;
run;

title "W3121345849 GBP-primary daily exchange-rate source coverage";
data fx_dly0;
    set fxsrc.g_exrt_dly
        (keep=datadate fromcurd tocurd exratd exrattpd);
    if upcase(fromcurd) ne "GBP" then delete;
    if datadate < '01APR1955'd or datadate > '31MAR2012'd then delete;
    if missing(tocurd) or missing(exratd) or exratd <= 0 then delete;
    tocur=upcase(tocurd);
    format datadate date9.;
run;

proc freq data=fx_dly0;
    tables exrattpd / missing;
run;

proc sql;
    create table fx_dly_bad as
    select datadate, tocur, min(exratd) as minrate, max(exratd) as maxrate
    from fx_dly0
    group by datadate, tocur
    having calculated minrate ne calculated maxrate;
    select count(*) as conflicting_daily_pair_dates from fx_dly_bad;

    create table fx_dly as
    select datadate, tocur, min(exratd) as rate,
           count(*) as source_rows,
           count(distinct exrattpd) as type_codes,
           sum(missing(exrattpd)) as missing_type_rows
    from fx_dly0
    group by datadate, tocur
    having min(exratd)=max(exratd);

    select tocur, count(*) as quote_days,
           min(datadate) format=date9. as first_quote,
           max(datadate) format=date9. as last_quote,
           sum(type_codes>1) as days_with_multiple_type_codes,
           sum(missing_type_rows>0) as days_with_missing_type_code
    from fx_dly
    group by tocur
    order by tocur;
quit;

title "W3121345849 GBP-primary monthly exchange-rate source coverage";
data fx_mth0;
    set fxsrc.g_exrt_mth
        (keep=datadate fromcurm tocurm exrat12m);
    if upcase(fromcurm) ne "GBP" then delete;
    if datadate < '01APR1955'd or datadate > '31MAR2012'd then delete;
    if missing(tocurm) or missing(exrat12m) or exrat12m <= 0 then delete;
    tocur=upcase(tocurm);
    monthkey=intnx('month',datadate,0,'b');
    format datadate monthkey date9.;
run;

proc sql;
    create table fx_mth_bad as
    select monthkey, tocur, min(exrat12m) as minrate, max(exrat12m) as maxrate
    from fx_mth0
    group by monthkey, tocur
    having calculated minrate ne calculated maxrate;
    select count(*) as conflicting_month_currency_pairs from fx_mth_bad;

    create table fx_mth as
    select monthkey, tocur, min(exrat12m) as rate,
           count(*) as source_rows,
           count(distinct datadate) as source_dates
    from fx_mth0
    group by monthkey, tocur
    having min(exrat12m)=max(exrat12m);

    select tocur, count(*) as quote_months,
           min(monthkey) format=date9. as first_quote_month,
           max(monthkey) format=date9. as last_quote_month,
           sum(source_dates>1) as months_with_multiple_dates
    from fx_mth
    group by tocur
    order by tocur;
quit;

proc sql;
    create table funda_rates as
    select a.*,
           dcur.rate as dcur_rate,
           dusd.rate as dusd_rate,
           dcur.type_codes as dcur_type_codes,
           dusd.type_codes as dusd_type_codes,
           dcur.missing_type_rows as dcur_missing_types,
           dusd.missing_type_rows as dusd_missing_types,
           mcur.rate as mcur_rate,
           musd.rate as musd_rate
    from funda_unique as a
    left join fx_dly as dcur
      on a.datadate=dcur.datadate and upcase(a.curcd)=dcur.tocur
    left join fx_dly as dusd
      on a.datadate=dusd.datadate and dusd.tocur="USD"
    left join fx_mth as mcur
      on a.mthkey=mcur.monthkey and upcase(a.curcd)=mcur.tocur
    left join fx_mth as musd
      on a.mthkey=musd.monthkey and musd.tocur="USD";
quit;

data funda_usd;
    set funda_rates;
    if upcase(curcd)="USD" then do;
        fxbs=1;
        fxflow=1;
    end;
    else do;
        fxbs=.;
        fxflow=.;
        if dcur_rate>0 and dusd_rate>0 then fxbs=dusd_rate/dcur_rate;
        if mcur_rate>0 and musd_rate>0 then fxflow=musd_rate/mcur_rate;
    end;

    if not missing(at) and fxbs>0 then at_usd=at*fxbs;
    if not missing(ceq) and fxbs>0 then ceq_usd=ceq*fxbs;
    if not missing(act) and fxbs>0 then act_usd=act*fxbs;
    if not missing(che) and fxbs>0 then che_usd=che*fxbs;
    if not missing(lct) and fxbs>0 then lct_usd=lct*fxbs;
    if not missing(dlc) and fxbs>0 then dlc_usd=dlc*fxbs;
    if not missing(txp) and fxbs>0 then txp_usd=txp*fxbs;
    if not missing(ivst) and fxbs>0 then ivst_usd=ivst*fxbs;
    if not missing(ivao) and fxbs>0 then ivao_usd=ivao*fxbs;
    if not missing(lt) and fxbs>0 then lt_usd=lt*fxbs;
    if not missing(dltt) and fxbs>0 then dltt_usd=dltt*fxbs;
    if not missing(pstk) and fxbs>0 then pstk_usd=pstk*fxbs;

    if not missing(ib) and not missing(spi) and fxflow>0 then e_usd=(ib-spi)*fxflow;
    if not missing(dvc) and fxflow>0 then dvc_usd=dvc*fxflow;
    if not missing(dp) and fxflow>0 then dp_usd=dp*fxflow;

    dd=.;
    if not missing(dvc) then dd=(dvc>0);
    nege=.;
    if not missing(e_usd) then nege=(e_usd<0);
    if not missing(e_usd) and csho>0 then eps=e_usd/csho;
    if not missing(eps) and not missing(nege) then epnegx=eps*nege;
    if not missing(ceq_usd) and csho>0 then bps=ceq_usd/csho;
    format datadate mthkey date9.;
run;

title "W3121345849 currency conversion coverage by reporting currency";
proc sql;
    select curcd, count(*) as source_rows,
           sum(upcase(curcd) ne "USD" and missing(fxbs)) as no_daily_conversion,
           sum(upcase(curcd) ne "USD" and missing(fxflow)) as no_flow_conversion,
           sum(dcur_type_codes>1) as report_legs_multi_type,
           sum(dusd_type_codes>1) as usd_legs_multi_type,
           sum(dcur_missing_types>0) as report_leg_missing_type,
           sum(dusd_missing_types>0) as usd_leg_missing_type,
           sum(not missing(fxbs)) as daily_factor_available,
           sum(not missing(fxflow)) as flow_factor_available
    from funda_usd
    group by curcd
    order by curcd;
quit;

proc sql;
    create table feat0 as
    select a.gvkey, a.avyear, a.datadate, a.curcd, a.csho,
           a.at_usd, a.ceq_usd, a.act_usd, a.che_usd, a.lct_usd,
           a.dlc_usd, a.txp_usd, a.ivst_usd, a.ivao_usd, a.lt_usd,
           a.dltt_usd, a.pstk_usd, a.dvc_usd, a.dp_usd, a.e_usd,
           a.dd, a.nege, a.eps, a.epnegx, a.bps,
           p.at_usd as at_l, p.che_usd as che_l, p.act_usd as act_l,
           p.lct_usd as lct_l, p.dlc_usd as dlc_l, p.txp_usd as txp_l,
           p.ivst_usd as ivst_l, p.ivao_usd as ivao_l, p.lt_usd as lt_l,
           p.dltt_usd as dltt_l, p.pstk_usd as pstk_l,
           b1.e_usd as lead1, b1.csho as csho1,
           b2.e_usd as lead2, b2.csho as csho2,
           b3.e_usd as lead3, b3.csho as csho3
    from funda_usd as a
    left join funda_usd as p
      on a.gvkey=p.gvkey and p.avyear=a.avyear-1
    left join funda_usd as b1
      on a.gvkey=b1.gvkey and b1.avyear=a.avyear+1
    left join funda_usd as b2
      on a.gvkey=b2.gvkey and b2.avyear=a.avyear+2
    left join funda_usd as b3
      on a.gvkey=b3.gvkey and b3.avyear=a.avyear+3
    where a.avyear>=1957 and a.avyear<=2011;
quit;

data feat1;
    set feat0;
    if n(act_usd,che_usd,lct_usd,dlc_usd,txp_usd,
         act_l,che_l,lct_l,dlc_l,txp_l,dp_usd)=11 then
        ac_raw=(act_usd-che_usd-act_l+che_l)
              -(lct_usd-dlc_usd-txp_usd-lct_l+dlc_l+txp_l)
              -dp_usd;
    else ac_raw=.;
    ac=ac_raw;
    if missing(ac) then ac=0;

    if n(at_usd,che_usd,lt_usd,ivst_usd,pstk_usd,
         at_l,che_l,lt_l,ivst_l,pstk_l,csho)=11 and csho>0 then
        tacc_raw=((at_usd-che_usd-lt_usd+ivst_usd-pstk_usd)
                 -(at_l-che_l-lt_l+ivst_l-pstk_l))/csho;
    else tacc_raw=.;
    tacc=tacc_raw;
    if missing(tacc) then tacc=0;

    if not missing(lead1) and csho>0 then eppy1_raw=lead1/csho;
    if not missing(lead2) and csho>0 then eppy2_raw=lead2/csho;
    if not missing(lead3) and csho>0 then eppy3_raw=lead3/csho;
    riy1_raw=eppy1_raw;
    riy2_raw=eppy2_raw;
    riy3_raw=eppy3_raw;
    rix_raw=eps;
    rinegx_raw=epnegx;
    ritacc_raw=tacc;
    hvzy1=lead1;
    hvzy2=lead2;
    hvzy3=lead3;
    hvzat=at_usd;
    hvzdvc=dvc_usd;
    hvze=e_usd;
    hvzac=ac;
    eppy1=eppy1_raw;
    eppy2=eppy2_raw;
    eppy3=eppy3_raw;
    epx=eps;
    epnegx=epnegx;
    riy1=riy1_raw;
    riy2=riy2_raw;
    riy3=riy3_raw;
    rix=rix_raw;
    rinegx=rinegx_raw;
    rib=bps;
    ritacc=tacc;
run;

title "W3121345849 bounded per-share denominator and TACC algebra checks";
proc sql;
    select sum(not missing(eppy1_raw) and not missing(csho1) and csho ne csho1) as h1_unequal_future_shares,
           sum(not missing(eppy2_raw) and not missing(csho2) and csho ne csho2) as h2_unequal_future_shares,
           sum(not missing(eppy3_raw) and not missing(csho3) and csho ne csho3) as h3_unequal_future_shares,
           sum(not missing(eppy1_raw) and abs(eppy1_raw-lead1/csho)>1e-10) as h1_base_share_formula_errors,
           sum(not missing(eppy2_raw) and abs(eppy2_raw-lead2/csho)>1e-10) as h2_base_share_formula_errors,
           sum(not missing(eppy3_raw) and abs(eppy3_raw-lead3/csho)>1e-10) as h3_base_share_formula_errors
    from feat1;
quit;

data tacc_check;
    set feat0;
    if n(act_usd,che_usd,lct_usd,dlc_usd,at_usd,ivao_usd,lt_usd,
         dltt_usd,ivst_usd,pstk_usd,act_l,che_l,lct_l,dlc_l,at_l,
         ivao_l,lt_l,dltt_l,ivst_l,pstk_l)=20 then do;
        wc0=(act_usd-che_usd)-(lct_usd-dlc_usd);
        nco0=(at_usd-act_usd-ivao_usd)-(lt_usd-lct_usd-dltt_usd);
        fin0=(ivst_usd+ivao_usd)-(dltt_usd+dlc_usd+pstk_usd);
        wc1=(act_l-che_l)-(lct_l-dlc_l);
        nco1=(at_l-act_l-ivao_l)-(lt_l-lct_l-dltt_l);
        fin1=(ivst_l+ivao_l)-(dltt_l+dlc_l+pstk_l);
        full_num=(wc0+nco0+fin0)-(wc1+nco1+fin1);
        simple_num=(at_usd-che_usd-lt_usd+ivst_usd-pstk_usd)
                  -(at_l-che_l-lt_l+ivst_l-pstk_l);
        absdiff=abs(full_num-simple_num);
    end;
run;

proc sql;
    select count(absdiff) as complete_identity_observations,
           sum(absdiff>1e-8) as identity_diff_count,
           max(absdiff) as max_abs_num_diff
    from tacc_check;
quit;

proc sort data=feat1;
    by avyear;
run;

proc univariate data=feat1 noprint;
    by avyear;
    var hvzy1 hvzy2 hvzy3 hvzat hvzdvc hvze hvzac
        eppy1 eppy2 eppy3 epx epnegx
        riy1 riy2 riy3 rix rinegx rib ritacc;
    output out=wincut
        pctlpts=1 99
        pctlpre=hy1_ hy2_ hy3_ hat_ hdvc_ he_ hac_
                ey1_ ey2_ ey3_ epx_ enx_
                ry1_ ry2_ ry3_ rix_ rnx_ rib_ rta_
        pctlname=lo hi;
run;

data winpanel;
    merge feat1(in=ina) wincut;
    by avyear;
    if ina;
    array x[19] hvzy1 hvzy2 hvzy3 hvzat hvzdvc hvze hvzac
                eppy1 eppy2 eppy3 epx epnegx
                riy1 riy2 riy3 rix rinegx rib ritacc;
    array lo[19] hy1_lo hy2_lo hy3_lo hat_lo hdvc_lo he_lo hac_lo
                 ey1_lo ey2_lo ey3_lo epx_lo enx_lo
                 ry1_lo ry2_lo ry3_lo rix_lo rnx_lo rib_lo rta_lo;
    array hi[19] hy1_hi hy2_hi hy3_hi hat_hi hdvc_hi he_hi hac_hi
                 ey1_hi ey2_hi ey3_hi epx_hi enx_hi
                 ry1_hi ry2_hi ry3_hi rix_hi rnx_hi rib_hi rta_hi;
    do j=1 to dim(x);
        if not missing(x[j]) then do;
            if not missing(lo[j]) and x[j]<lo[j] then x[j]=lo[j];
            if not missing(hi[j]) and x[j]>hi[j] then x[j]=hi[j];
        end;
    end;
    drop j;
    label hvzy1="Future earnings, h=1, USD millions"
          hvzy2="Future earnings, h=2, USD millions"
          hvzy3="Future earnings, h=3, USD millions"
          hvzat="Total assets, USD millions"
          hvzdvc="Common dividends, USD millions"
          hvze="Current earnings, USD millions"
          hvzac="Working capital accruals, USD millions"
          dd="Dividend payer indicator"
          nege="Negative earnings indicator"
          eppy1="Future earnings per share, h=1, USD"
          eppy2="Future earnings per share, h=2, USD"
          eppy3="Future earnings per share, h=3, USD"
          epx="Current earnings per share, USD"
          epnegx="Negative earnings times current EPS"
          riy1="Future earnings per share, h=1, USD"
          riy2="Future earnings per share, h=2, USD"
          riy3="Future earnings per share, h=3, USD"
          rix="Current earnings per share, USD"
          rinegx="Negative earnings times current EPS"
          rib="Book value per share, USD"
          ritacc="Total accruals per share, USD";
run;

data out.rolling_fit_panel;
    set winpanel;
    keep gvkey avyear datadate curcd csho csho1 csho2 csho3
         hvzy1 hvzy2 hvzy3 hvzat hvzdvc hvze hvzac dd nege
         eppy1 eppy2 eppy3 epx epnegx
         riy1 riy2 riy3 rix rinegx rib ritacc;
run;

title "W3121345849 final handoff counts and input distributions";
proc sql;
    select count(*) as handoff_rows,
           count(distinct gvkey) as firms,
           min(avyear) as min_base_avyear,
           max(avyear) as max_base_avyear,
           min(datadate) format=date9. as min_actual_datadate,
           max(datadate) format=date9. as max_actual_datadate
    from out.rolling_fit_panel;

    select count(*) as duplicate_handoff_keys
    from (select gvkey, avyear, count(*) as n
          from out.rolling_fit_panel
          group by gvkey, avyear
          having calculated n>1);
quit;

proc means data=out.rolling_fit_panel n nmiss mean std p1 p99;
    class avyear;
    var hvzy1 hvzy2 hvzy3 hvzat hvzdvc hvze hvzac
        eppy1 eppy2 eppy3 epx epnegx
        riy1 riy2 riy3 rix rinegx rib ritacc;
run;

libname compna clear;
libname fxsrc clear;
libname out clear;
