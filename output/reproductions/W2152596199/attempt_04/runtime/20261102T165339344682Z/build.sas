options errorabend nocenter nodate nonumber;

libname comp "/storage/sas/base/comp/d_na" access=readonly;
libname fx "/storage/sas/base/comp/d_global/currency" access=readonly;
libname out "data";

/* Read the catalog-listed annual source read-only. Full observed history is
   retained for age, auditor spells, and the five-year relationship screen. */
data work.source;
    set comp.funda(keep=gvkey datadate fyear indfmt consol popsrc datafmt
                        at act che lct dlc oiadp oancf sale ppent sich au curcd
                        aqc aqa aqd aqp aqs aqi
                   where=(indfmt='INDL' and consol='C' and popsrc='D'
                          and datafmt='STD' and fyear ne .));
run;

proc sql noprint;
    select count(*) into :duplicate_keys trimmed
    from (select gvkey, fyear from work.source
          group by gvkey, fyear having count(*) > 1);
    select count(*) into :duplicate_dates trimmed
    from (select gvkey, fyear, datadate from work.source
          group by gvkey, fyear, datadate having count(*) > 1);
quit;
%put NOTE: Source firm-year keys with duplicates before selection=&duplicate_keys.;
%put NOTE: Source exact firm-year-date keys with duplicates=&duplicate_dates.;

/* Where a company has more than one standard annual record for a fiscal year,
   retain the record with the latest reporting date. */
proc sort data=work.source out=work.source_sorted;
    by gvkey fyear datadate;
run;

data work.annual;
    set work.source_sorted;
    by gvkey fyear;
    if last.fyear;
    length auditor_raw $8;
    retain age previous_fyear previous_auditor previous_tenure rel_sequence;
    if first.gvkey then do;
        age=0;
        previous_fyear=.;
        previous_auditor=.;
        previous_tenure=.;
        rel_sequence=0;
    end;
    if fyear >= 1980 and not missing(at) then age+1;

    sic_ind=sich;
    if not missing(sic_ind) then sic2=floor(sic_ind/100);
    calyear=year(datadate);
    auditor_raw=strip(au);
    auditor_code=input(auditor_raw,?? best32.);
    auditor_norm=auditor_code;
    if auditor_code=2 and datadate >= '01OCT1989'd then auditor_norm=4;
    if auditor_code=8 and datadate >= '04DEC1989'd then auditor_norm=5;
    if auditor_code=3 and datadate >= '01JUL1998'd then auditor_norm=7;
    /* Codes 0 (unaudited) and 9 (other) do not identify an auditor spell. */
    if auditor_code in (0,9) then auditor_norm=.;
    auditor_type=.;
    if not missing(auditor_code) then do;
        auditor_type=0;
        if auditor_code in (1,2,3,4,5,6,7,8) then auditor_type=1;
    end;

    ma_flag=(max(abs(aqc),abs(aqa),abs(aqd),abs(aqp),abs(aqs),abs(aqi)) > 0);

    if missing(auditor_norm) then do;
        tenure=.;
        rel_id=.;
        previous_auditor=.;
        previous_tenure=.;
    end;
    else do;
        if missing(previous_auditor) or fyear ne previous_fyear+1
         or auditor_norm ne previous_auditor then do;
            tenure=1;
            rel_sequence+1;
        end;
        else tenure=previous_tenure+1;
        rel_id=rel_sequence;
        previous_auditor=auditor_norm;
        previous_tenure=tenure;
    end;
    previous_fyear=fyear;
    label age='Years with total assets reported since 1980'
          tenure='Consecutive years with auditor'
          auditor_type='Big N auditor indicator'
          sic2='Two-digit historical SIC';
run;

/* Provider currency groups are used only after validating the exact source
   keys, date match, common GBP primary currency, positive rates, and unique
   currency-date keys. The paper's model population needs fiscal years
   1988-2000 plus the 1987 lag, whose annual dates run through 2001. */
data work.daily_rate_candidates;
    set fx.g_exrt_dly(keep=tocurd exratd exrattpd fromcurd datadate
                        where=(tocurd in ('USD','CAD')
                          and datadate between '01JAN1987'd and '31DEC2001'd));
run;

data work.monthly_rate_candidates;
    set fx.g_exrt_mth(keep=tocurm exrat12m fromcurm datadate
                        where=(tocurm in ('USD','CAD')
                          and datadate between '01JAN1987'd and '31DEC2001'd));
run;

proc sql noprint;
    select count(*) into :n_daily_candidates trimmed
      from work.daily_rate_candidates;
    select count(*) into :n_daily_non_gbp trimmed
      from work.daily_rate_candidates where fromcurd ne 'GBP';
    select count(*) into :n_daily_invalid trimmed
      from work.daily_rate_candidates
      where missing(exratd) or exratd <= 0;
    select count(*) into :n_daily_dups trimmed
      from (select tocurd, datadate from work.daily_rate_candidates
            where fromcurd='GBP'
            group by tocurd, datadate having count(*) > 1);
    select put(min(datadate),date9.), put(max(datadate),date9.)
      into :daily_min_date, :daily_max_date
      from work.daily_rate_candidates where fromcurd='GBP';
    select count(*) into :n_monthly_candidates trimmed
      from work.monthly_rate_candidates;
    select count(*) into :n_monthly_non_gbp trimmed
      from work.monthly_rate_candidates where fromcurm ne 'GBP';
    select count(*) into :n_monthly_invalid trimmed
      from work.monthly_rate_candidates
      where missing(exrat12m) or exrat12m <= 0;
    select count(*) into :n_monthly_dups trimmed
      from (select tocurm, datadate from work.monthly_rate_candidates
            where fromcurm='GBP'
            group by tocurm, datadate having count(*) > 1);
    select put(min(datadate),date9.), put(max(datadate),date9.)
      into :monthly_min_date, :monthly_max_date
      from work.monthly_rate_candidates where fromcurm='GBP';
quit;
%put NOTE: Daily FX source rows for USD/CAD=&n_daily_candidates, non-GBP primary=&n_daily_non_gbp, missing/nonpositive rates=&n_daily_invalid, duplicate GBP currency-date keys=&n_daily_dups, required-date span=&daily_min_date.-&daily_max_date.;
%put NOTE: Monthly FX source rows for USD/CAD=&n_monthly_candidates, non-GBP primary=&n_monthly_non_gbp, missing/nonpositive 12-month average rates=&n_monthly_invalid, duplicate GBP currency-date keys=&n_monthly_dups, required-date span=&monthly_min_date.-&monthly_max_date.;

data _null_;
    if &n_daily_dups > 0 or &n_monthly_dups > 0 then do;
        put 'ERROR: Exchange-rate currency-date keys are not unique.';
        abort cancel;
    end;
run;

data work.daily_rates;
    set work.daily_rate_candidates;
    where fromcurd='GBP';
    length curcd $3 rate_type $2;
    curcd=strip(tocurd);
    spot_gbp_to_currency=exratd;
    rate_type=strip(exrattpd);
    keep curcd datadate spot_gbp_to_currency rate_type;
run;

data work.monthly_rates;
    set work.monthly_rate_candidates;
    where fromcurm='GBP';
    length curcd $3;
    curcd=strip(tocurm);
    average_gbp_to_currency=exrat12m;
    keep curcd datadate average_gbp_to_currency;
run;

/* Convert source-period amounts by the Xpressfeed primary-currency cross
   rate. EXRATD is the balance-sheet-date rate; EXRAT12M is for income and
   cash-flow amounts. CURCD is the period-specific reporting currency. */
proc sql;
    create table work.annual_fx as
    select annual.*,
           daily_report.spot_gbp_to_currency as stock_gbp_to_report,
           daily_usd.spot_gbp_to_currency as stock_gbp_to_usd,
           daily_report.rate_type as stock_rate_type,
           monthly_report.average_gbp_to_currency as flow_gbp_to_report,
           monthly_usd.average_gbp_to_currency as flow_gbp_to_usd,
           case when daily_report.spot_gbp_to_currency > 0
                  and daily_usd.spot_gbp_to_currency > 0
                then daily_usd.spot_gbp_to_currency /
                     daily_report.spot_gbp_to_currency
                else . end as stock_to_usd,
           case when monthly_report.average_gbp_to_currency > 0
                  and monthly_usd.average_gbp_to_currency > 0
                then monthly_usd.average_gbp_to_currency /
                     monthly_report.average_gbp_to_currency
                else . end as flow_to_usd,
           case when daily_report.spot_gbp_to_currency > 0
                  and daily_usd.spot_gbp_to_currency > 0
                then at * daily_usd.spot_gbp_to_currency /
                     daily_report.spot_gbp_to_currency
                else . end as at_usd,
           case when daily_report.spot_gbp_to_currency > 0
                  and daily_usd.spot_gbp_to_currency > 0
                then act * daily_usd.spot_gbp_to_currency /
                     daily_report.spot_gbp_to_currency
                else . end as act_usd,
           case when daily_report.spot_gbp_to_currency > 0
                  and daily_usd.spot_gbp_to_currency > 0
                then che * daily_usd.spot_gbp_to_currency /
                     daily_report.spot_gbp_to_currency
                else . end as che_usd,
           case when daily_report.spot_gbp_to_currency > 0
                  and daily_usd.spot_gbp_to_currency > 0
                then lct * daily_usd.spot_gbp_to_currency /
                     daily_report.spot_gbp_to_currency
                else . end as lct_usd,
           case when daily_report.spot_gbp_to_currency > 0
                  and daily_usd.spot_gbp_to_currency > 0
                then dlc * daily_usd.spot_gbp_to_currency /
                     daily_report.spot_gbp_to_currency
                else . end as dlc_usd,
           case when daily_report.spot_gbp_to_currency > 0
                  and daily_usd.spot_gbp_to_currency > 0
                then ppent * daily_usd.spot_gbp_to_currency /
                     daily_report.spot_gbp_to_currency
                else . end as ppent_usd,
           case when monthly_report.average_gbp_to_currency > 0
                  and monthly_usd.average_gbp_to_currency > 0
                then oiadp * monthly_usd.average_gbp_to_currency /
                     monthly_report.average_gbp_to_currency
                else . end as oiadp_usd,
           case when monthly_report.average_gbp_to_currency > 0
                  and monthly_usd.average_gbp_to_currency > 0
                then oancf * monthly_usd.average_gbp_to_currency /
                     monthly_report.average_gbp_to_currency
                else . end as oancf_usd,
           case when monthly_report.average_gbp_to_currency > 0
                  and monthly_usd.average_gbp_to_currency > 0
                then sale * monthly_usd.average_gbp_to_currency /
                     monthly_report.average_gbp_to_currency
                else . end as sale_usd
    from work.annual as annual
    left join work.daily_rates as daily_report
      on annual.datadate=daily_report.datadate
     and strip(annual.curcd)=daily_report.curcd
    left join work.daily_rates as daily_usd
      on annual.datadate=daily_usd.datadate and daily_usd.curcd='USD'
    left join work.monthly_rates as monthly_report
      on annual.datadate=monthly_report.datadate
     and strip(annual.curcd)=monthly_report.curcd
    left join work.monthly_rates as monthly_usd
      on annual.datadate=monthly_usd.datadate and monthly_usd.curcd='USD'
    where annual.fyear between 1987 and 2000;
quit;

proc sql noprint;
    select count(*) into :n_annual_fx trimmed from work.annual_fx;
    select count(*) into :n_missing_stock_fx trimmed
      from work.annual_fx
      where missing(stock_to_usd);
    select count(*) into :n_missing_flow_fx trimmed
      from work.annual_fx
      where missing(flow_to_usd);
    select count(*) into :n_non_usd_cad trimmed
      from work.annual_fx where curcd not in ('USD','CAD') or missing(curcd);
quit;
%put NOTE: Full annual rows with currency fields for FY1987-2000=&n_annual_fx.;
%put NOTE: Nonmissing total-assets rows without a validated daily USD cross-rate=&n_missing_stock_fx.;
%put NOTE: Nonmissing flow rows without a validated monthly USD cross-rate=&n_missing_flow_fx.;
%put NOTE: Unsupported or missing reporting currencies in the required source periods=&n_non_usd_cad.;
proc freq data=work.annual_fx;
    tables curcd / missing;
run;
proc freq data=work.annual_fx;
    tables stock_rate_type / missing;
run;


proc sql noprint;
    create table work.relationship_length as
    select gvkey, rel_id, count(*) as relationship_years
    from work.annual
    where not missing(rel_id)
    group by gvkey, rel_id;

    create table work.prior_history as
    select current.gvkey, current.fyear, count(prior.at) as prior_at_years
    from work.annual as current
    left join work.annual as prior
      on current.gvkey=prior.gvkey
     and prior.fyear between current.fyear-6 and current.fyear-1
    where current.fyear between 1988 and 2000
    group by current.gvkey, current.fyear;

    create table work.annual_lag_base as
    select current.*,
           prior.at as previous_at,
           prior.act as previous_act,
           prior.che as previous_che,
           prior.lct as previous_lct,
           prior.dlc as previous_dlc,
           prior.sale as previous_sale,
           prior.curcd as previous_curcd,
           prior.datadate as previous_datadate,
           prior.stock_to_usd as previous_stock_to_usd,
           prior.flow_to_usd as previous_flow_to_usd,
           prior.at_usd as previous_at_usd,
           prior.act_usd as previous_act_usd,
           prior.che_usd as previous_che_usd,
           prior.lct_usd as previous_lct_usd,
           prior.dlc_usd as previous_dlc_usd,
           prior.sale_usd as previous_sale_usd
    from work.annual_fx as current
    left join work.annual_fx as prior
      on current.gvkey=prior.gvkey
     and prior.fyear=current.fyear-1;
    create table work.currency_prior2 as
    select current.gvkey, current.fyear, prior2.curcd as prior2_curcd
    from work.annual_fx as current
    left join work.annual as prior2
      on current.gvkey=prior2.gvkey
     and prior2.fyear=current.fyear-2;

    create table work.annual_lag as
    select lagged.*, prior2.prior2_curcd
    from work.annual_lag_base as lagged
    left join work.currency_prior2 as prior2
      on lagged.gvkey=prior2.gvkey and lagged.fyear=prior2.fyear;

    create table work.industry_sales as
    select sic2, fyear, sum(sale_usd) as industry_sales,
           sum(case when not missing(sale) and missing(sale_usd)
                    then 1 else 0 end) as unconverted_sales,
           sum(case when not missing(sale) then 1 else 0 end) as sales_rows,
           sum(case when curcd='USD' and not missing(sale) then 1 else 0 end)
               as usd_sales_rows,
           sum(case when curcd='CAD' and not missing(sale) then 1 else 0 end)
               as cad_sales_rows
    from work.annual_fx
    where not missing(sic2) and not missing(sale)
    group by sic2, fyear;

    create table work.industry_growth as
    select current.sic2, current.fyear,
           case when current.unconverted_sales=0
                  and prior.unconverted_sales=0
                  and prior.industry_sales ne 0
                then current.industry_sales/prior.industry_sales
                else . end as industry_growth
    from work.industry_sales as current
    left join work.industry_sales as prior
      on current.sic2=prior.sic2
     and prior.fyear=current.fyear-1;

    create table work.candidate0 as
    select current.*, history.prior_at_years,
           rel.relationship_years, growth.industry_growth
    from work.annual_lag as current
    left join work.prior_history as history
      on current.gvkey=history.gvkey and current.fyear=history.fyear
    left join work.relationship_length as rel
      on current.gvkey=rel.gvkey and current.rel_id=rel.rel_id
    left join work.industry_growth as growth
      on current.sic2=growth.sic2 and current.fyear=growth.fyear
    where current.fyear between 1988 and 2000
      and history.prior_at_years >= 6
      and current.ma_flag=0;
quit;

data work.candidate0;
    set work.candidate0;
    length ratio_unit $16;
    if missing(curcd) or missing(previous_curcd) then ratio_unit='missing_currency';
    else if curcd=previous_curcd then ratio_unit='native_same_code';
    else if stock_to_usd>0 and previous_stock_to_usd>0
         and flow_to_usd>0 and previous_flow_to_usd>0
         then ratio_unit='usd_cross_rate';
    else ratio_unit='unavailable_fx';
run;

proc sql;
    create table work.industry_currency_summary as
    select count(*) as industry_years,
           sum(case when usd_sales_rows>0 and cad_sales_rows>0
                    then 1 else 0 end) as mixed_currency_industry_years,
           sum(case when unconverted_sales>0 then 1 else 0 end)
                    as unconverted_industry_years,
           sum(sales_rows) as source_sales_rows,
           sum(usd_sales_rows) as usd_source_sales_rows,
           sum(cad_sales_rows) as cad_source_sales_rows
    from work.industry_sales;
quit;

proc print data=work.industry_currency_summary noobs;
run;

/* Jones and Current Accrual inputs use the fiscal-year t and t-1 row; the
   six-year history screen is separate from this one-year variable alignment. */
data work.support_population;
    set work.candidate0;
    if ratio_unit='native_same_code' then do;
        /* Currency-homogeneous ratios are unit invariant; keep the original
           native amounts to avoid introducing FX movements. */
        at_ratio=at;
        previous_at_ratio=previous_at;
        act_ratio=act;
        previous_act_ratio=previous_act;
        che_ratio=che;
        previous_che_ratio=previous_che;
        lct_ratio=lct;
        previous_lct_ratio=previous_lct;
        dlc_ratio=dlc;
        previous_dlc_ratio=previous_dlc;
        oiadp_ratio=oiadp;
        oancf_ratio=oancf;
        sale_ratio=sale;
        previous_sale_ratio=previous_sale;
        ppent_ratio=ppent;
    end;
    else if ratio_unit='usd_cross_rate' then do;
        /* A reporting-currency switch requires date-specific translation
           before taking cross-period differences or average assets. */
        at_ratio=at_usd;
        previous_at_ratio=previous_at_usd;
        act_ratio=act_usd;
        previous_act_ratio=previous_act_usd;
        che_ratio=che_usd;
        previous_che_ratio=previous_che_usd;
        lct_ratio=lct_usd;
        previous_lct_ratio=previous_lct_usd;
        dlc_ratio=dlc_usd;
        previous_dlc_ratio=previous_dlc_usd;
        oiadp_ratio=oiadp_usd;
        oancf_ratio=oancf_usd;
        sale_ratio=sale_usd;
        previous_sale_ratio=previous_sale_usd;
        ppent_ratio=ppent_usd;
    end;
    size=.;
    if at_usd > 0 then size=log(at_usd);
    if nmiss(at_ratio,previous_at_ratio,act_ratio,previous_act_ratio,
             che_ratio,previous_che_ratio,lct_ratio,previous_lct_ratio,
             dlc_ratio,previous_dlc_ratio,oiadp_ratio,oancf_ratio,
             sale_ratio,previous_sale_ratio,ppent_ratio)=0;
    average_assets=(at_ratio+previous_at_ratio)/2;
    if average_assets <= 0 then delete;
    current_accrual=((act_ratio-previous_act_ratio)
                    -(che_ratio-previous_che_ratio)
                    -(lct_ratio-previous_lct_ratio)
                    +(dlc_ratio-previous_dlc_ratio))/average_assets;
    cash_flow=oancf_ratio/average_assets;
    total_accrual=(oiadp_ratio-oancf_ratio)/average_assets;
    revenue_change=(sale_ratio-previous_sale_ratio)/average_assets;
    ppe_scaled=ppent_ratio/average_assets;
    if missing(sic2) or missing(calyear) then delete;
    label current_accrual='Current Accruals / average assets'
          cash_flow='Operating cash flow / average assets'
          total_accrual='Operating income after depreciation less operating cash flow / average assets'
          revenue_change='Change in sales / average assets'
          ppe_scaled='Net PP&E / average assets'
          size='Log total assets translated to USD'
          industry_growth='Current-year / prior-year industry sales';
run;

proc sql;
    create table work.jones_cells as
    select fyear, sic2, count(*) as cell_n
    from work.support_population
    group by fyear, sic2;

    create table work.jones_input as
    select population.*
    from work.support_population as population
    inner join work.jones_cells as cells
      on population.fyear=cells.fyear and population.sic2=cells.sic2
    where cells.cell_n >= 8;
quit;

proc sort data=work.jones_input;
    by fyear sic2;
run;

/* The paper labels this outcome a Jones-model residual; residual direction is
   interpreted as observed scaled accrual minus the contemporaneous fitted value. */
proc reg data=work.jones_input noprint;
    by fyear sic2;
    model total_accrual=revenue_change ppe_scaled;
    output out=work.jones_residual residual=discretionary_accrual;
quit;

proc sql;
    create table work.support as
    select population.*, residual.discretionary_accrual
    from work.support_population as population
    left join work.jones_residual as residual
      on population.gvkey=residual.gvkey and population.fyear=residual.fyear;
quit;

proc sort data=work.support;
    by fyear;
run;

/* Annual cutoffs are computed on the broad eligible construction population,
   before the five-year relationship and first-year regression screens. */
proc univariate data=work.support noprint;
    by fyear;
    var cash_flow current_accrual discretionary_accrual;
    output out=work.annual_cutoffs
        pctlpts=0.5 99.5 pctlpre=cfo_ ca_ da_ pctlname=p05 p995;
run;

data work.trimmed;
    merge work.support(in=in_support) work.annual_cutoffs;
    by fyear;
    if in_support;
    outlier=0;
    if cash_flow < cfo_p05 or cash_flow > cfo_p995 then outlier=1;
    if current_accrual < ca_p05 or current_accrual > ca_p995 then outlier=1;
    if discretionary_accrual < da_p05 or discretionary_accrual > da_p995 then outlier=1;
run;

data work.analysis_sample;
    set work.trimmed;
    if relationship_years < 5 then delete;
    if missing(tenure) or tenure=1 then delete;
    if outlier then delete;
    if nmiss(discretionary_accrual,current_accrual,tenure,age,size,
             industry_growth,cash_flow,auditor_type)=0;
    if missing(sic2) or missing(calyear) then delete;
    abs_da=abs(discretionary_accrual);
    abs_ca=abs(current_accrual);
    keep gvkey fyear calyear sic2 curcd previous_curcd prior2_curcd ratio_unit
         discretionary_accrual current_accrual abs_da abs_ca tenure age size
         industry_growth cash_flow auditor_type;
    label discretionary_accrual='Raw Jones-model residual'
          current_accrual='Raw Current Accruals'
          abs_da='Absolute Discretionary Accruals'
          abs_ca='Absolute Current Accruals'
          tenure='Auditor tenure in consecutive years'
          age='Years with total assets reported since 1980'
          size='Log total assets'
          industry_growth='Industry sales ratio'
          cash_flow='Cash flow from operations / average assets'
          auditor_type='Big N auditor indicator'
          calyear='Calendar year';
run;

data out.main;
    set work.analysis_sample;
run;

proc sql noprint;
    select count(*) into :n_annual trimmed from work.annual;
    select count(*) into :n_candidate trimmed from work.candidate0;
    select count(*) into :n_support trimmed from work.support_population;
    select count(*) into :n_jones trimmed from work.jones_input;
    select count(*) into :n_missing_da trimmed
      from work.support where missing(discretionary_accrual);
    select count(*) into :n_analysis trimmed from out.main;
    select count(*) into :n_final_dups trimmed
      from (select gvkey, fyear from out.main
            group by gvkey, fyear having count(*) > 1);
    select count(*) into :n_ma_proxy_all_missing trimmed
      from work.annual
      where fyear between 1988 and 2000
        and nmiss(aqc,aqa,aqd,aqp,aqs,aqi)=6;
quit;
%put NOTE: Deduplicated full annual firm-year rows=&n_annual.;
%put NOTE: Eligible 1988-2000 rows after six-year history and MNA proxy=&n_candidate.;
%put NOTE: Broad complete Jones/current-accrual support rows=&n_support.;
%put NOTE: Jones-fit rows in cells with at least eight firms=&n_jones.;
%put NOTE: Rows with unavailable Jones residual after the broad screen=&n_missing_da.;
%put NOTE: Final Table 2 common analysis sample=&n_analysis.;
%put NOTE: Duplicate final gvkey-fyear keys=&n_final_dups.;
%put NOTE: 1988-2000 annual rows with all six best-effort MNA financial-item fields missing=&n_ma_proxy_all_missing.;

proc sql;
    create table work.currency_stage_audit as
    select 'annual_lag_source' as stage length=24,
           count(*) as rows,
           sum(case when not missing(curcd) and not missing(previous_curcd)
                    then 1 else 0 end) as current_prior_known,
           sum(case when not missing(curcd) and not missing(previous_curcd)
                     and curcd ne previous_curcd then 1 else 0 end)
               as current_prior_different,
           sum(case when not missing(previous_curcd) and not missing(prior2_curcd)
                    then 1 else 0 end) as prior_prior2_known,
           sum(case when not missing(previous_curcd) and not missing(prior2_curcd)
                     and previous_curcd ne prior2_curcd then 1 else 0 end)
               as prior_prior2_different,
           sum(case when curcd='CAD' then 1 else 0 end) as current_cad_rows,
           sum(case when not missing(curcd) and not missing(previous_curcd)
                     and curcd ne previous_curcd
                     and stock_to_usd>0 and previous_stock_to_usd>0
                     and flow_to_usd>0 and previous_flow_to_usd>0
                    then 1 else 0 end) as fx_cross_rate_rows
    from work.annual_lag where fyear between 1988 and 2000
    union all
    select 'candidate0', count(*),
           sum(case when not missing(curcd) and not missing(previous_curcd)
                    then 1 else 0 end),
           sum(case when not missing(curcd) and not missing(previous_curcd)
                     and curcd ne previous_curcd then 1 else 0 end),
           sum(case when not missing(previous_curcd) and not missing(prior2_curcd)
                    then 1 else 0 end),
           sum(case when not missing(previous_curcd) and not missing(prior2_curcd)
                     and previous_curcd ne prior2_curcd then 1 else 0 end),
           sum(case when curcd='CAD' then 1 else 0 end),
           sum(case when ratio_unit='usd_cross_rate' then 1 else 0 end)
    from work.candidate0
    union all
    select 'support_population', count(*),
           sum(case when not missing(curcd) and not missing(previous_curcd)
                    then 1 else 0 end),
           sum(case when not missing(curcd) and not missing(previous_curcd)
                     and curcd ne previous_curcd then 1 else 0 end),
           sum(case when not missing(previous_curcd) and not missing(prior2_curcd)
                    then 1 else 0 end),
           sum(case when not missing(previous_curcd) and not missing(prior2_curcd)
                     and previous_curcd ne prior2_curcd then 1 else 0 end),
           sum(case when curcd='CAD' then 1 else 0 end),
           sum(case when ratio_unit='usd_cross_rate' then 1 else 0 end)
    from work.support_population
    union all
    select 'jones_input', count(*),
           sum(case when not missing(curcd) and not missing(previous_curcd)
                    then 1 else 0 end),
           sum(case when not missing(curcd) and not missing(previous_curcd)
                     and curcd ne previous_curcd then 1 else 0 end),
           sum(case when not missing(previous_curcd) and not missing(prior2_curcd)
                    then 1 else 0 end),
           sum(case when not missing(previous_curcd) and not missing(prior2_curcd)
                     and previous_curcd ne prior2_curcd then 1 else 0 end),
           sum(case when curcd='CAD' then 1 else 0 end),
           sum(case when ratio_unit='usd_cross_rate' then 1 else 0 end)
    from work.jones_input
    union all
    select 'trimmed_support', count(*),
           sum(case when not missing(curcd) and not missing(previous_curcd)
                    then 1 else 0 end),
           sum(case when not missing(curcd) and not missing(previous_curcd)
                     and curcd ne previous_curcd then 1 else 0 end),
           sum(case when not missing(previous_curcd) and not missing(prior2_curcd)
                    then 1 else 0 end),
           sum(case when not missing(previous_curcd) and not missing(prior2_curcd)
                     and previous_curcd ne prior2_curcd then 1 else 0 end),
           sum(case when curcd='CAD' then 1 else 0 end),
           sum(case when ratio_unit='usd_cross_rate' then 1 else 0 end)
    from work.trimmed
    union all
    select 'final_analysis', count(*),
           sum(case when not missing(curcd) and not missing(previous_curcd)
                    then 1 else 0 end),
           sum(case when not missing(curcd) and not missing(previous_curcd)
                     and curcd ne previous_curcd then 1 else 0 end),
           sum(case when not missing(previous_curcd) and not missing(prior2_curcd)
                    then 1 else 0 end),
           sum(case when not missing(previous_curcd) and not missing(prior2_curcd)
                     and previous_curcd ne prior2_curcd then 1 else 0 end),
           sum(case when curcd='CAD' then 1 else 0 end),
           sum(case when ratio_unit='usd_cross_rate' then 1 else 0 end)
    from work.analysis_sample;
quit;

proc print data=work.currency_stage_audit noobs;
run;

proc freq data=work.annual;
    tables au / missing;
    where fyear between 1988 and 2000;
run;

proc sql;
    create table work.au_year_counts as
    select fyear, au, count(*) as observations
    from work.annual
    where fyear in (1988,1989,1997,1998,1999,2000)
    group by fyear, au;

    create table work.au_merger_transitions as
    select current.fyear as transition_year,
           prior.au as prior_au,
           current.au as current_au,
           count(*) as transitions
    from work.annual as current
    inner join work.annual as prior
      on current.gvkey=prior.gvkey and current.fyear=prior.fyear+1
    where current.fyear in (1989,1998)
      and not missing(prior.au) and not missing(current.au)
    group by current.fyear, prior.au, current.au;
quit;

proc print data=work.au_year_counts noobs;
run;

proc print data=work.au_merger_transitions noobs;
    where transitions >= 10;
run;

proc freq data=out.main;
    tables fyear calyear sic2 auditor_type / missing;
run;

proc means data=out.main n mean std min p25 median p75 max;
    var discretionary_accrual current_accrual tenure age size
        industry_growth cash_flow auditor_type;
run;

