options nodate nonumber errorabend;
libname cp "/storage/sas/base/comp/d_na" access=readonly;
libname fx "/storage/sas/base/comp/d_global/currency" access=readonly;
libname ccm "/storage/sas/base/crsp/a_ccm" access=readonly;
libname crsp "/storage/sas/base/crsp/a_stock" access=readonly;
libname out "./data";

title "Verify annual source fields used in the modern item-62 mapping";
proc sql;
  select name, type, length, label
  from dictionary.columns
  where libname='CP' and memname='FUNDA'
    and upcase(name) in ('IB','XINT','IDIT','IINT','IDIT_DC','NOPI_DC',
                         'NOPIO_DC','AT','DVC','FIC','SICH','CURCD',
                         'FYEAR','DATADATE')
  order by name;
quit;

title "Annual Compustat source coverage: fiscal years 1973-2007";
proc sql;
  create table out.raw_annual as
  select gvkey, datadate, fyear, indfmt, consol, popsrc, datafmt,
         curcd, fic, sich, at, ib, xint, idit, dvc
  from cp.funda
  where indfmt='INDL' and consol='C' and popsrc='D' and datafmt='STD'
    and fyear>=1973 and fyear<=2007
  order by gvkey, fyear, datadate;
  select count(*) as raw_rows,
         count(distinct gvkey) as distinct_firms,
         min(fyear) as first_fyear,
         max(fyear) as last_fyear,
         min(datadate) format=date9. as first_actual_date,
         max(datadate) format=date9. as last_actual_date
  from out.raw_annual;
  create table out.fy_counts as
  select gvkey, fyear, count(*) as n_source_rows
  from out.raw_annual
  group by gvkey, fyear;
  create table out.dup_fy as
  select gvkey, fyear, n_source_rows as n_rows
  from out.fy_counts
  where n_source_rows>1;
  select count(*) as duplicate_firm_year_groups,
         coalesce(sum(n_rows-1),0) as excess_rows,
         coalesce(sum(n_rows),0) as ambig_fy_source_rows
  from out.dup_fy;
quit;

title "Raw annual field and FX coverage by fiscal year";
data out.fx_mth;
  set fx.g_exrt_mth(keep=datadate fromcurm tocurm exrat12m);
  where fromcurm='GBP' and datadate>='01JAN1973'd and datadate<='31DEC2008'd;
run;
data out.fx_dly;
  set fx.g_exrt_dly(keep=datadate fromcurd tocurd exratd exrattpd);
  where fromcurd='GBP' and datadate>='01JAN1973'd and datadate<='31DEC2008'd;
run;
proc sql;
  create table out.dup_fx_mth as
  select datadate, tocurm, count(*) as n_rows
  from out.fx_mth
  group by datadate, tocurm
  having calculated n_rows>1;
  create table out.dup_fx_dly as
  select datadate, tocurd, count(*) as n_rows
  from out.fx_dly
  group by datadate, tocurd
  having calculated n_rows>1;
  select count(*) as duplicate_monthly_fx_keys from out.dup_fx_mth;
  select count(*) as duplicate_daily_fx_keys from out.dup_fx_dly;
  create table out.annual_rates as
  select a.*,
         case
           when upcase(a.curcd)='USD' then 1
           when fm.exrat12m>0 and fu.exrat12m>0
             then fu.exrat12m/fm.exrat12m
           else .
         end as flow_to_usd,
         case
           when upcase(a.curcd)='USD' then 1
           when ds.exratd>0 and du.exratd>0
             then du.exratd/ds.exratd
           else .
         end as stock_to_usd,
         (a.ib+0.6*a.xint-0.6*a.idit) *
           (case
              when upcase(a.curcd)='USD' then 1
              when fm.exrat12m>0 and fu.exrat12m>0
                then fu.exrat12m/fm.exrat12m
              else .
            end) as earn_usd,
         a.at *
           (case
              when upcase(a.curcd)='USD' then 1
              when ds.exratd>0 and du.exratd>0
                then du.exratd/ds.exratd
              else .
            end) as at_usd
  from out.raw_annual as a
  left join out.fx_mth as fm
    on a.datadate=fm.datadate and upcase(a.curcd)=upcase(fm.tocurm)
  left join out.fx_mth as fu
    on a.datadate=fu.datadate and upcase(fu.tocurm)='USD'
  left join out.fx_dly as ds
    on a.datadate=ds.datadate and upcase(a.curcd)=upcase(ds.tocurd)
  left join out.fx_dly as du
    on a.datadate=du.datadate and upcase(du.tocurd)='USD';
  select fyear,
         count(*) as raw_rows,
         sum(not missing(ib)) as n_ib,
         sum(not missing(xint)) as n_xint,
         sum(not missing(idit)) as n_idit,
         sum(missing(idit)) as n_idit_missing,
         sum(not missing(dvc)) as n_dvc,
         sum(upcase(curcd)='USD') as n_reported_usd,
         sum(missing(curcd)) as n_missing_curcd,
         sum(not missing(flow_to_usd)) as n_flow_fx,
         sum(missing(flow_to_usd)) as n_flow_fx_missing,
         sum(not missing(earn_usd)) as n_adjusted_earnings_usd,
         sum(not missing(at_usd) and at_usd>0) as n_positive_assets_usd,
         min(datadate) format=date9. as first_actual_date,
         max(datadate) format=date9. as last_actual_date
  from out.annual_rates
  group by fyear
  order by fyear;
  create table out.fic_by_firm as
  select gvkey, count(distinct fic) as n_fic_values
  from out.raw_annual
  where not missing(fic)
  group by gvkey;
  select count(*) as firms_with_fic,
         sum(n_fic_values>1) as firms_with_row_fic_changes
  from out.fic_by_firm;
  create table out.annual_unique as
  select a.*
  from out.annual_rates as a
  inner join out.fy_counts as c
    on a.gvkey=c.gvkey and a.fyear=c.fyear
  where c.n_source_rows=1
  order by a.gvkey, a.fyear, a.datadate;
  select count(*) as unique_annual_period_rows,
         count(distinct gvkey) as firms_with_unique_annual_periods,
         min(fyear) as first_unique_fyear,
         max(fyear) as last_unique_fyear
  from out.annual_unique;
  /* Earnings rows remain restricted to unique GVKEY/FYEAR keys. For the
     role-specific lagged-asset input, retain a duplicate key only when the
     source contains exactly one nonmissing AT and it converts to positive
     USD at that row's own DATADATE. This recovers a unique field value without
     choosing among competing annual statements. */
  create table out.asset_key_counts as
  select gvkey, fyear,
         count(*) as n_source_rows,
         sum(not missing(at)) as n_observed_at,
         sum(not missing(at) and at>0 and not missing(at_usd) and at_usd>0)
           as n_positive_usd_at
  from out.annual_rates
  group by gvkey, fyear;
  create table out.lag_asset_support as
  select a.gvkey, a.fyear, a.datadate, a.curcd, a.at,
         a.stock_to_usd, a.at_usd
  from out.annual_rates as a
  inner join out.asset_key_counts as c
    on a.gvkey=c.gvkey and a.fyear=c.fyear
  where c.n_observed_at=1 and c.n_positive_usd_at=1
    and not missing(a.at) and a.at>0
    and not missing(a.at_usd) and a.at_usd>0;
  select count(*) as lag_asset_support_keys,
         sum(n_source_rows>1 and n_observed_at=1 and n_positive_usd_at=1)
           as dup_keys_unique_lag_at
  from out.asset_key_counts;
  select p.gvkey, p.fyear, p.datadate format=date9. as asset_date,
         p.curcd as asset_currency, p.at as source_at,
         p.stock_to_usd, p.at_usd as converted_assets_usd,
         c.n_source_rows
  from out.lag_asset_support as p
  inner join out.asset_key_counts as c
    on p.gvkey=c.gvkey and p.fyear=c.fyear
  where c.n_source_rows>1
  order by p.gvkey, p.fyear;
quit;

title "Date-valid historical CCM and CRSP name records for current-year screens";
data out.cur_rows;
  set out.annual_unique;
  if fyear>=1974 and fyear<=2005;
run;
proc sql;
  create table out.stock_rows as
  select c.gvkey, c.fyear, c.datadate,
         l.lpermno as permno_link, l.linkprim, l.linktype,
         n.permno, n.namedt, n.nameendt, n.exchcd, n.shrcd, n.siccd
  from out.cur_rows as c
  inner join ccm.ccmxpf_linktable as l
    on c.gvkey=l.gvkey
   and l.linkprim in ('P','C')
   and l.linktype in ('LC','LU')
   and not missing(l.lpermno)
   and (missing(l.linkdt) or l.linkdt<=c.datadate)
   and (missing(l.linkenddt) or l.linkenddt>=c.datadate)
  inner join crsp.msenames as n
    on l.lpermno=n.permno
   and not missing(n.namedt)
   and n.namedt<=c.datadate
   and (missing(n.nameendt) or n.nameendt>=c.datadate);
  create table out.stock_agg as
  select gvkey, fyear, datadate,
         count(distinct permno_link) as n_linked_permnos,
         count(*) as n_historical_name_rows,
         max(case when exchcd in (1,2,3) and shrcd in (10,11)
                  then 1 else 0 end) as exchange_ok,
         sum(case when exchcd in (1,2,3) and shrcd in (10,11)
                  then 1 else 0 end) as n_common_market_rows,
         count(distinct case
           when siccd>=100 and siccd<=9999 then siccd else .
         end) as n_valid_siccd,
         min(case when siccd>=100 and siccd<=9999 then siccd else . end)
           as min_siccd,
         max(case when siccd>=100 and siccd<=9999 then siccd else . end)
           as max_siccd
  from out.stock_rows
  group by gvkey, fyear, datadate;
quit;
proc sort data=out.cur_rows;
  by gvkey fyear datadate;
run;
proc sort data=out.stock_agg;
  by gvkey fyear datadate;
run;
data out.current_info;
  merge out.cur_rows(in=in_cur) out.stock_agg;
  by gvkey fyear datadate;
  if in_cur;
  if missing(exchange_ok) then exchange_ok=0;
  if missing(n_linked_permnos) then n_linked_permnos=0;
  if missing(n_historical_name_rows) then n_historical_name_rows=0;
  sich_valid=(not missing(sich) and sich>=100 and sich<=9999);
  if sich_valid then do;
    sic_used=sich;
    sic_source=1;
  end;
  else if n_valid_siccd=1 then do;
    sic_used=min_siccd;
    sic_source=2;
  end;
  else do;
    sic_used=.;
    sic_source=0;
  end;
  sic_disagree=(sich_valid and n_valid_siccd>0 and (min_siccd ne sich or max_siccd ne sich));
  if not missing(sic_used) then do;
    if (sic_used>=4900 and sic_used<=4999) or
       (sic_used>=6000 and sic_used<=6999) then industry_ok=0;
    else industry_ok=1;
  end;
  else industry_ok=0;
  country_ok=(upcase(strip(fic))='USA');
  exchange_ok=(exchange_ok=1);
run;
proc sort data=out.current_info;
  by gvkey fyear datadate;
run;
title "Annual historical classification and exchange coverage at current fiscal dates";
proc sql;
  select fyear,
         count(*) as current_year_rows,
         sum(country_ok) as fic_usa,
         sum(missing(fic)) as fic_missing,
         sum(sich_valid) as valid_historical_sich,
         sum(n_valid_siccd=1) as unambiguous_dated_crsp_siccd,
         sum(sic_source=2) as crsp_sic_fallback_rows,
         sum(sic_source=0) as unresolved_industry_rows,
         sum(sic_disagree) as sich_siccd_disagreements,
         sum(n_valid_siccd>1) as multiple_crsp_siccd_rows,
         sum(exchange_ok) as common_nyse_amex_nasdaq_rows,
         sum(n_linked_permnos=0) as no_dated_ccm_name_match
  from out.current_info
  group by fyear
  order by fyear;
  select count(*) as current_screen_rows,
         sum(country_ok) as fic_usa,
         sum(exchange_ok) as historical_exchange_pass,
         sum(industry_ok) as n_industry_ok,
         sum(sic_source=1) as sourced_from_funda_sich,
         sum(sic_source=2) as sourced_from_crsp_siccd_fallback,
         sum(sic_disagree) as overlapping_code_disagreements,
         sum(n_valid_siccd>1 and not sich_valid) as ambiguous_fallback_rows,
         sum(not missing(dvc)) as observed_common_dividends,
         sum(not missing(idit)) as observed_idit,
         sum(missing(idit)) as missing_idit,
         sum(not missing(earn_usd)) as n_earn_adj
  from out.current_info;
quit;

title "Construct lagged assets and forward earnings without future-year classification screens";
proc sql;
  create table out.model_rows as
  select c.gvkey, c.fyear, c.datadate,
         c.fic, c.curcd, c.sich, c.sic_used, c.sic_source,
         c.sic_disagree, c.n_valid_siccd, c.n_linked_permnos,
         c.country_ok, c.exchange_ok, c.industry_ok,
         c.dvc, c.ib, c.xint, c.idit,
         c.flow_to_usd, c.stock_to_usd, c.earn_usd,
         p.datadate as lag_datadate,
         p.at_usd as assets_lag_usd,
         h1.datadate as lead1_datadate,
         h1.earn_usd as earnings_h1_usd,
         h2.datadate as lead2_datadate,
         h2.earn_usd as earnings_h2_usd
  from out.current_info as c
  left join out.lag_asset_support as p
    on c.gvkey=p.gvkey and p.fyear=c.fyear-1
   and p.datadate<c.datadate
  left join out.annual_unique as h1
    on c.gvkey=h1.gvkey and h1.fyear=c.fyear+1
   and h1.datadate>c.datadate
  left join out.annual_unique as h2
    on c.gvkey=h2.gvkey and h2.fyear=c.fyear+2
   and h2.datadate>c.datadate
  order by c.gvkey, c.fyear, c.datadate;
quit;
data out.main;
  set out.model_rows;
  if dvc>0 then dp=1;
  else if dvc=0 then dp=0;
  else dp=.;
  current_ok=(country_ok=1 and exchange_ok=1 and industry_ok=1
              and not missing(dp) and not missing(earn_usd));
  rate_ok=(current_ok=1 and not missing(assets_lag_usd)
           and assets_lag_usd>0);
  if rate_ok then e_rate=max(-1,min(1,earn_usd/assets_lag_usd));
  else e_rate=.;
  use_h1=(rate_ok=1 and not missing(earnings_h1_usd));
  use_h2=(rate_ok=1 and not missing(earnings_h2_usd));
  if use_h1 then y_h1=max(-1,min(1,earnings_h1_usd/assets_lag_usd));
  else y_h1=.;
  if use_h2 then y_h2=max(-1,min(1,earnings_h2_usd/assets_lag_usd));
  else y_h2=.;
  label gvkey="Compustat global company key"
        fyear="Compustat fiscal year"
        datadate="Actual fiscal period end"
        dvc="Cash dividends common, Compustat item 21"
        dp="Regular common dividend indicator"
        e_rate="Current adjusted earnings / lagged total assets"
        y_h1="One-year-ahead adjusted earnings / lagged total assets"
        y_h2="Two-year-ahead adjusted earnings / lagged total assets"
        assets_lag_usd="Total assets at fiscal year t-1, USD"
        sic_used="Historical SIC used for current-year screen"
        sic_source="1=FUNDA SICH; 2=dated CRSP SICCD fallback"
        use_h1="Eligible Table 4 Panel A fit row"
        use_h2="Eligible Table 4 Panel B fit row";
run;
title "Current-year field availability and estimation-sample counts";
proc sql;
  select fyear,
         count(*) as current_year_rows,
         sum(current_ok) as current_source_screen_pass,
         sum(rate_ok) as current_and_lag_asset_pass,
         sum(missing(idit)) as missing_current_idit,
         sum(use_h1) as h1_fit_rows,
         sum(use_h2) as h2_fit_rows
  from out.main
  group by fyear
  order by fyear;
  select 'Panel A h=1 1974-1983' as fit length=32, count(*) as N
    from out.main where use_h1=1 and fyear>=1974 and fyear<=1983
  union all
  select 'Panel A h=1 1984-1993', count(*)
    from out.main where use_h1=1 and fyear>=1984 and fyear<=1993
  union all
  select 'Panel A h=1 1994-2005', count(*)
    from out.main where use_h1=1 and fyear>=1994 and fyear<=2005
  union all
  select 'Panel B h=2 1974-1983', count(*)
    from out.main where use_h2=1 and fyear>=1974 and fyear<=1983
  union all
  select 'Panel B h=2 1984-1993', count(*)
    from out.main where use_h2=1 and fyear>=1984 and fyear<=1993
  union all
  select 'Panel B h=2 1994-2005', count(*)
    from out.main where use_h2=1 and fyear>=1994 and fyear<=2005;
quit;
data out.main;
  set out.main;
  keep gvkey fyear datadate fic curcd dvc dp e_rate y_h1 y_h2
       use_h1 use_h2 current_ok rate_ok assets_lag_usd
       sic_used sic_source sic_disagree n_valid_siccd n_linked_permnos
       flow_to_usd stock_to_usd;
run;
proc datasets library=out nolist;
  delete raw_annual dup_fy fy_counts fx_mth fx_dly dup_fx_mth dup_fx_dly
         annual_rates annual_unique asset_key_counts lag_asset_support
         fic_by_firm cur_rows stock_rows
         stock_agg current_info model_rows;
quit;
title;
