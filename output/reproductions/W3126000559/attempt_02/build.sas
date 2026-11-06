options errorabend;
ods noproctitle;
title "W3126000559 source validation and analysis-sample construction";

libname audit '/storage/sas/base/audit/audit_comp' access=readonly;
libname deals '/storage/sas/base/tfn/dealscan' access=readonly;
libname comp '/storage/sas/base/comp/d_na' access=readonly;
libname compir '/storage/sas/base/comp/d_na/rating' access=readonly;
libname crspstk '/storage/sas/base/crsp/a_stock_v2' access=readonly;
libname crspccm '/storage/sas/base/crsp/a_ccm' access=readonly;
libname revelio '/storage/sas/base/revelio/common' access=readonly;
libname fisd '/storage/sas/base/mergent/fisd' access=readonly;
libname wrdsapps '/storage/sas/base/wrdsapps/linking/bclink' access=readonly;
libname out 'data';

%let fac_lo='01SEP1999'd;
%let fac_hi='31DEC2008'd;
%let mw_lo='01SEP2002'd;
%let mw_hi='31JUL2008'd;
%let source_hi='31DEC2008'd;

data work.audit_i;
  length cik $11 formkey $20;
  set audit.feed10_sox_302_disclosure_contro
      (keep=IC_DC_KEY COMPANY_FKEY FORM_FKEY FILE_DATE PERIOD_END_DATE_NUM
            IS_EFFECTIVE MATERIAL_WEAKNESS);
  if FILE_DATE >= &mw_lo and FILE_DATE <= &source_hi;
  cik=strip(COMPANY_FKEY);
  formkey=strip(FORM_FKEY);
  keep cik formkey FILE_DATE PERIOD_END_DATE_NUM IS_EFFECTIVE MATERIAL_WEAKNESS;
run;

proc freq data=work.audit_i;
  tables IS_EFFECTIVE MATERIAL_WEAKNESS IS_EFFECTIVE*MATERIAL_WEAKNESS / missing;
run;

proc sql noprint;
  select count(*) into :bad_mw trimmed
  from work.audit_i
  where not missing(MATERIAL_WEAKNESS) and MATERIAL_WEAKNESS not in (0,1);
quit;
%macro validate_mw_code;
  %if &bad_mw > 0 %then %do;
    %put BUILD_GUARD: MATERIAL_WEAKNESS has nonmissing values outside 0/1. Inspect its frequency and verify the local encoding before construction.;
    %abort cancel;
  %end;
%mend;
%validate_mw_code;

proc sql;
  create table work.audit_forms as
  select cik, formkey, FILE_DATE, PERIOD_END_DATE_NUM,
         max(case when MATERIAL_WEAKNESS=1 then 1 else 0 end) as mw_yes,
         max(case when MATERIAL_WEAKNESS=0 then 1 else 0 end) as mw_zero,
         max(case when not missing(MATERIAL_WEAKNESS)
                       and MATERIAL_WEAKNESS not in (0,1) then 1 else 0 end) as mw_bad,
         max(case when IS_EFFECTIVE=1 then 1 else 0 end) as eff_yes,
         max(case when IS_EFFECTIVE=0 then 1 else 0 end) as eff_no,
         count(*) as issue_rows
  from work.audit_i
  group by cik, formkey, FILE_DATE, PERIOD_END_DATE_NUM;
quit;

data work.audit_forms;
  set work.audit_forms;
  report_mw=(mw_yes=1);
  report_clean=(mw_yes=0 and mw_zero=1 and mw_bad=0);
run;

proc sql;
  create table work.mw_first_cik as
  select cik, min(FILE_DATE) as first_mw format=yymmdd10.
  from work.audit_forms
  where report_mw=1 and FILE_DATE >= &mw_lo and FILE_DATE <= &mw_hi
  group by cik;

  create table work.events_cik as
  select f.cik, f.first_mw,
         min(a.FILE_DATE) as clean_date format=yymmdd10.
  from work.mw_first_cik as f
  left join work.audit_forms as a
    on f.cik=a.cik and a.report_clean=1
       and a.FILE_DATE>f.first_mw and a.FILE_DATE<=&source_hi
  group by f.cik, f.first_mw;
quit;

data work.comp_names;
  length cik $11;
  set comp.names(keep=CIK GVKEY YEAR1 YEAR2);
  cik=strip(CIK);
  gvkey=strip(GVKEY);
  if not missing(cik) and not missing(gvkey);
  if not missing(YEAR1) and not missing(YEAR2);
  keep cik gvkey YEAR1 YEAR2;
run;

proc sql;
  create table work.events_gv0 as
  select e.cik, e.first_mw, e.clean_date,
         count(distinct n.gvkey) as n_gvkey,
         min(n.gvkey) as gvkey length=6
  from work.events_cik as e
  left join work.comp_names as n
    on e.cik=n.cik and year(e.first_mw)>=n.YEAR1 and year(e.first_mw)<=n.YEAR2
  group by e.cik, e.first_mw, e.clean_date;

  create table work.events_gv as
  select * from work.events_gv0 where n_gvkey=1;
quit;

proc sort data=work.events_gv out=work.events_gv_s;
  by gvkey first_mw;
run;
data work.events;
  set work.events_gv_s;
  by gvkey first_mw;
  if first.gvkey;
  mw_year=year(first_mw);
  label first_mw='First material weakness filing date'
        clean_date='First later explicit clean filing date';
run;

proc sql;
  select count(*) as unique_cik_events,
         count(distinct gvkey) as mapped_gvkeys,
         sum(n_gvkey=0) as unmapped_cik_events,
         sum(n_gvkey>1) as ambiguous_cik_events
  from work.events_gv0;
quit;
proc freq data=work.events;
  tables mw_year / missing;
run;

data work.fac_core;
  length ticker $10 company_name $75 loan_type $50 loan_type_norm $50 secured_raw $3;
  set deals.facility
      (keep=FacilityID PackageID BorrowerCompanyID Ticker Company FacilityStartDate
            FacilityEndDate LoanType FacilityAmt Currency ExchangeRate Maturity Secured
       rename=(FacilityID=src_facility_id Maturity=src_maturity));
  if FacilityStartDate < &fac_lo or FacilityStartDate > &fac_hi then delete;
  facilityid=src_facility_id;
  packageid=PackageID;
  facdate=FacilityStartDate;
  loan_year=year(facdate);
  ticker=strip(Ticker);
  company_name=strip(Company);
  loan_type=strip(LoanType);
  loan_type_norm=compress(upcase(loan_type),'- /');
  secured_raw=upcase(strip(Secured));
  maturity=src_maturity;
  if index(loan_type_norm,'TERMLOANB')>0 or
     index(loan_type_norm,'TERMLOANC')>0 or
     index(loan_type_norm,'TERMLOAND')>0 then inst_investor=1;
  else if not missing(loan_type) then inst_investor=0;
  if index(loan_type_norm,'REVOLVER')>0 then revolver=1;
  else if not missing(loan_type) then revolver=0;
  if secured_raw in ('YES','Y','1') then secured_value=1;
  else if secured_raw in ('NO','N','0') then secured_value=0;
  else secured_value=.;
  if maturity>0 then ln_maturity=log(maturity);
  else ln_maturity=.;
  keep facilityid packageid BorrowerCompanyID ticker company_name facdate loan_year
       FacilityEndDate loan_type Currency ExchangeRate FacilityAmt
       secured_raw secured_value maturity ln_maturity inst_investor revolver;
  rename BorrowerCompanyID=borrowerid FacilityEndDate=facend
         Currency=facility_currency ExchangeRate=facility_exrate
         secured_value=secured;
run;

proc freq data=work.fac_core;
  tables loan_type secured_raw facility_currency / missing;
run;
proc means data=work.fac_core n nmiss min p1 median p99 max;
  var maturity facend;
run;
proc sql;
  select count(*) as facility_rows,
         count(distinct facilityid) as unique_facilities,
         sum(missing(ticker)) as missing_tickers,
         sum(missing(inst_investor)) as unclassified_institutional,
         sum(missing(revolver)) as unclassified_revolver,
         sum(missing(secured)) as unclassified_secured
  from work.fac_core;
quit;

proc freq data=deals.package;
  tables AssetSalesSweep DebtIssuanceSweep EquityIssuanceSweep
         InsuranceProceedsSweep DividendRestrictions / missing;
run;

data work.package_raw;
  set deals.package
      (keep=PackageID AssetSalesSweep DebtIssuanceSweep EquityIssuanceSweep
            InsuranceProceedsSweep DividendRestrictions);
  packageid=PackageID;
  if not missing(AssetSalesSweep) and AssetSalesSweep>=0 then asset_flag=(AssetSalesSweep>0);
  else asset_flag=.;
  if not missing(DebtIssuanceSweep) and DebtIssuanceSweep>=0 then debt_flag=(DebtIssuanceSweep>0);
  else debt_flag=.;
  if not missing(EquityIssuanceSweep) and EquityIssuanceSweep>=0 then equity_flag=(EquityIssuanceSweep>0);
  else equity_flag=.;
  if not missing(InsuranceProceedsSweep) and InsuranceProceedsSweep>=0 then insurance_flag=(InsuranceProceedsSweep>0);
  else insurance_flag=.;
  length div_text $3;
  div_text=upcase(strip(DividendRestrictions));
  if div_text in ('YES','Y','1') then dividend_flag=1;
  else if div_text in ('NO','N','0') then dividend_flag=0;
  else dividend_flag=.;
  if nmiss(asset_flag,debt_flag,equity_flag,insurance_flag,dividend_flag)=0 then
    general_covenants=sum(asset_flag,debt_flag,equity_flag,insurance_flag,dividend_flag);
  else general_covenants=.;
  keep packageid asset_flag debt_flag equity_flag insurance_flag dividend_flag general_covenants;
run;

proc sql;
  create table work.pkg_dups as
  select packageid, count(*) as nrows
  from work.package_raw
  group by packageid
  having count(*)>1;

  create table work.pkg_terms as
  select packageid, count(*) as pkg_rows,
         case when count(asset_flag)=count(*) and min(asset_flag)=max(asset_flag)
              then min(asset_flag) else . end as asset_flag,
         case when count(debt_flag)=count(*) and min(debt_flag)=max(debt_flag)
              then min(debt_flag) else . end as debt_flag,
         case when count(equity_flag)=count(*) and min(equity_flag)=max(equity_flag)
              then min(equity_flag) else . end as equity_flag,
         case when count(insurance_flag)=count(*) and min(insurance_flag)=max(insurance_flag)
              then min(insurance_flag) else . end as insurance_flag,
         case when count(dividend_flag)=count(*) and min(dividend_flag)=max(dividend_flag)
              then min(dividend_flag) else . end as dividend_flag,
         case when count(general_covenants)=count(*) and min(general_covenants)=max(general_covenants)
              then min(general_covenants) else . end as general_covenants
  from work.package_raw
  where packageid in (select packageid from work.fac_core)
  group by packageid;
quit;
proc sql;
  select count(*) as package_rows,
         count(distinct packageid) as unique_packages,
         sum(missing(general_covenants)) as missing_general_count
  from work.pkg_terms;
  select count(*) as duplicated_package_keys from work.pkg_dups;
quit;
proc means data=work.pkg_terms n nmiss min p50 max;
  var asset_flag debt_flag equity_flag insurance_flag dividend_flag general_covenants;
run;

proc sql;
  create table work.fin_cov as
  select PackageID as packageid, count(CovenantType) as financial_covenants,
         count(*) as covenant_rows, count(distinct CovenantType) as distinct_types
  from deals.financialcovenant
  group by PackageID;
quit;
proc sql;
  select sum(covenant_rows-distinct_types) as repeated_type_rows,
         count(*) as packages_with_rows
  from work.fin_cov;
quit;

proc freq data=deals.currfacpricing;
  tables BaseRate / missing;
run;
proc sql;
  create table work.pricing_libor as
  select FacilityID as facilityid,
         count(*) as libor_rows,
         count(distinct AllInDrawn) as spread_values,
         min(AllInDrawn) as spread_candidate
  from deals.currfacpricing
  where not missing(AllInDrawn)
    and index(upcase(compress(BaseRate,' -')),'LIBOR')>0
  group by FacilityID;
quit;
data work.pricing;
  set work.pricing_libor;
  if spread_values=1 then interest_rate=spread_candidate;
  else interest_rate=.;
  label interest_rate='All-in-drawn spread over LIBOR, basis points';
  keep facilityid interest_rate libor_rows spread_values;
run;

proc freq data=deals.performancepricing;
  tables PerformancePricingType / missing;
run;
data work.pp_rows;
  set deals.performancepricing(keep=FacilityID PerformancePricingType);
  facilityid=FacilityID;
  length pp_raw $120 pp_norm $120;
  pp_raw=strip(PerformancePricingType);
  pp_norm=upcase(compbl(pp_raw));
  if pp_norm in ('CURRENT RATIO','DEBT SERVICE COVERAGE','DEBT TO EQUITY',
                 'DEBT TO TANG. NET WORTH','DEBT TO BORROWING BASE RATIO',
                 'EBITDA','FIXED CHARGE COVERAGE','INTEREST COVERAGE',
                 'LEVERAGE','LIQUIDITY','NET INCOME','QUICK RATIO',
                 'SENIOR DEBT TO CASH FLOW','SENIOR LEVERAGE',
                 'TOTAL DEBT TO CASH FLOW') then pp_class=1;
  else if index(pp_norm,'RATING')>0 then pp_class=0;
  else pp_class=.;
  keep facilityid pp_raw pp_norm pp_class;
run;
proc freq data=work.pp_rows;
  tables pp_norm pp_class / missing;
run;
proc sql;
  create table work.pp_fac as
  select facilityid, count(*) as pp_rows,
         max(case when pp_class=1 then 1 else 0 end) as has_ratio,
         max(case when pp_class=0 then 1 else 0 end) as has_rating,
         max(case when missing(pp_class) then 1 else 0 end) as has_other
  from work.pp_rows
  group by facilityid;
quit;
data work.pp_fac;
  set work.pp_fac;
  pp_indicator=1;
  if has_ratio=1 and has_rating=0 and has_other=0 then pp_ratio=1;
  else if has_ratio=0 and has_rating=1 and has_other=0 then pp_ratio=0;
  else pp_ratio=.;
  label pp_indicator='Performance-pricing contract indicator'
        pp_ratio='One for accounting-ratio grid; zero for rating grid';
run;

proc sql;
  create table work.lenders as
  select FacilityID as facilityid, count(distinct CompanyID) as num_lenders,
         count(*) as lender_rows
  from deals.lendershares
  where not missing(CompanyID)
  group by FacilityID;
quit;

proc sql;
  create table work.fac_tran as
  select f.facilityid,
         strip(w.LoanConnector_Tranche_ID) as tranche_id length=24,
         w.WRDS_facility_id as wrds_facid
  from work.fac_core as f
  inner join deals.wrds_loanconnector_ids as w
    on f.facilityid=w.WRDS_facility_id
  where not missing(w.LoanConnector_Tranche_ID);

  create table work.target_tran as
  select distinct tranche_id from work.fac_tran
  where not missing(tranche_id);
quit;
proc sql;
  select count(*) as facility_tranche_rows,
         count(distinct facilityid) as facilities_with_tranche,
         count(distinct tranche_id) as distinct_tranche_ids
  from work.fac_tran;
quit;

data work.modern_target;
  length tranche_id $24 lei $25 borrower_name $400;
  if _n_=1 then do;
    declare hash ht(dataset:'work.target_tran');
    ht.defineKey('tranche_id');
    ht.defineDone();
  end;
  set deals.dealscan
      (keep=LPC_Tranche_ID Legal_Entity_ID_LEI Tranche_Amount_Converted Borrower_Name);
  tranche_id=strip(LPC_Tranche_ID);
  if not missing(tranche_id) and ht.check()=0;
  lei=upcase(strip(Legal_Entity_ID_LEI));
  borrower_name=strip(Borrower_Name);
  amount_usd_m=Tranche_Amount_Converted;
  keep tranche_id lei amount_usd_m borrower_name;
run;

proc sql;
  create table work.deal_tran as
  select f.facilityid, f.tranche_id, m.lei, m.amount_usd_m, m.borrower_name
  from work.fac_tran as f
  left join work.modern_target as m
    on f.tranche_id=m.tranche_id;

  create table work.deal_fac as
  select facilityid,
         count(distinct lei) as n_lei,
         min(lei) as lei length=25,
         count(distinct amount_usd_m) as n_amount,
         min(amount_usd_m) as amount_usd_m,
         count(distinct borrower_name) as n_borrower_name,
         min(borrower_name) as borrower_name length=400,
         count(distinct tranche_id) as n_tranche
  from work.deal_tran
  group by facilityid;
quit;
data work.deal_fac;
  set work.deal_fac;
  if n_lei ne 1 then lei='';
  if n_amount ne 1 or amount_usd_m<=0 then amount_usd_m=.;
  if n_borrower_name ne 1 then borrower_name='';
  label amount_usd_m='Modern DealScan tranche amount converted to USD millions';
run;
proc freq data=work.deal_fac;
  tables n_lei n_amount n_tranche / missing;
run;
proc means data=work.deal_fac n nmiss min p50 max;
  var amount_usd_m;
run;

data work.target_lei;
  length lei $25;
  set work.deal_fac(keep=lei);
  lei=upcase(strip(lei));
  if not missing(lei);
run;
proc sort data=work.target_lei nodupkey;
  by lei;
run;

data work.revelio_target;
  length lei $25 gvkey $6 company_name $400 cik $11 parent_company_name $400;
  if _n_=1 then do;
    declare hash hlei(dataset:'work.target_lei');
    hlei.defineKey('lei');
    hlei.defineDone();
  end;
  set revelio.company_mapping
      (keep=lei gvkey company cik rcid ultimate_parent_rcid ultimate_parent_company_name);
  lei=upcase(strip(lei));
  gvkey=strip(gvkey);
  company_name=strip(company);
  cik=strip(cik);
  parent_company_name=strip(ultimate_parent_company_name);
  if not missing(lei) and hlei.check()=0 and not missing(gvkey);
  keep lei gvkey company_name cik rcid ultimate_parent_rcid parent_company_name;
run;
proc sql;
  create table work.lei_gv as
  select lei, count(distinct gvkey) as n_gvkey,
         min(gvkey) as lei_gvkey length=6,
         count(distinct rcid) as n_rcid,
         count(distinct company_name) as n_company_name,
         min(company_name) as lei_company length=400,
         count(distinct cik) as n_cik,
         min(cik) as lei_cik length=11,
         count(distinct ultimate_parent_rcid) as n_parent_rcid,
         min(ultimate_parent_rcid) as ultimate_parent_rcid,
         min(parent_company_name) as ultimate_parent_company length=400
  from work.revelio_target
  group by lei;
quit;
proc freq data=work.lei_gv;
  tables n_gvkey n_rcid n_company_name n_cik n_parent_rcid / missing;
run;

proc sql;
  create table work.crsp_candidates as
  select f.facilityid, c.gvkey, c.linkprim, c.linktype, c.lpermno,
         case when compress(upcase(strip(f.company_name)),,'kan')=
                        compress(upcase(strip(s.IssuerNm)),,'kan')
              then 1 else 0 end as exact_name
  from work.fac_core as f
  inner join crspstk.stocknames_v2 as s
    on upcase(strip(f.ticker))=upcase(strip(s.Ticker))
       and not missing(s.NameDt) and s.NameDt<=f.facdate
       and (s.NameEndDt>=f.facdate or s.NameEndDt=. or s.NameEndDt=.E)
  inner join crspccm.ccmxpf_linktable as c
    on s.PERMNO=c.LPERMNO
       and ((not missing(c.LINKDT) and c.LINKDT<=f.facdate) or c.LINKDT=.B)
       and ((not missing(c.LINKENDDT) and c.LINKENDDT>=f.facdate) or c.LINKENDDT=.E)
  where c.LINKTYPE in ('LC','LU') and c.LINKPRIM in ('P','C');

  create table work.crsp_ticker_stats as
  select facilityid, count(distinct gvkey) as n_ticker_gvkey
  from work.crsp_candidates
  group by facilityid;

  create table work.crsp_name_stats as
  select facilityid, count(distinct gvkey) as n_name_gvkey
  from work.crsp_candidates
  where exact_name=1
  group by facilityid;

  create table work.crsp_p as
  select facilityid, count(distinct gvkey) as n_p,
         min(gvkey) as p_gvkey length=6
  from work.crsp_candidates
  where linkprim='P' and exact_name=1
  group by facilityid;

  create table work.crsp_c as
  select facilityid, count(distinct gvkey) as n_c,
         min(gvkey) as c_gvkey length=6
  from work.crsp_candidates
  where linkprim='C' and exact_name=1
  group by facilityid;

  create table work.crsp_fac as
  select f.facilityid,
         coalesce(p.n_p,0) as n_p,
         coalesce(c.n_c,0) as n_c,
         coalesce(t.n_ticker_gvkey,0) as n_ticker_gvkey,
         coalesce(n.n_name_gvkey,0) as n_name_gvkey,
         case when coalesce(n.n_name_gvkey,0)=1 and p.n_p=1 then p.p_gvkey
              when coalesce(n.n_name_gvkey,0)=1 and coalesce(p.n_p,0)=0 and c.n_c=1
                   then c.c_gvkey
              else '' end as crsp_gvkey length=6
  from work.fac_core as f
  left join work.crsp_p as p on f.facilityid=p.facilityid
  left join work.crsp_c as c on f.facilityid=c.facilityid
  left join work.crsp_ticker_stats as t on f.facilityid=t.facilityid
  left join work.crsp_name_stats as n on f.facilityid=n.facilityid;
quit;
proc freq data=work.crsp_fac;
  tables n_p n_c n_ticker_gvkey n_name_gvkey / missing;
run;

proc sql;
  create table work.fac_lei_cik as
  select f.facilityid,
         count(distinct n.gvkey) as n_cik_gvkey,
         min(n.gvkey) as cik_gvkey length=6
  from work.fac_core as f
  left join work.deal_fac as d on f.facilityid=d.facilityid
  left join work.lei_gv as l on d.lei=l.lei
  left join work.comp_names as n
    on l.lei_cik=n.cik and f.loan_year>=n.YEAR1 and f.loan_year<=n.YEAR2
  group by f.facilityid;

  create table work.fac_gv as
  select f.*, c.crsp_gvkey, c.n_p, c.n_c,
         c.n_ticker_gvkey, c.n_name_gvkey,
         case when l.n_gvkey=1 then l.lei_gvkey else '' end as lei_gvkey length=6,
         coalesce(l.n_gvkey,0) as n_lei_gv,
         coalesce(x.n_cik_gvkey,0) as n_cik_gvkey,
         x.cik_gvkey,
         d.lei, d.n_lei, d.n_amount, d.amount_usd_m, d.n_tranche,
         d.n_borrower_name, d.borrower_name,
         coalesce(l.n_rcid,0) as n_lei_rcid,
         coalesce(l.n_company_name,0) as n_lei_company_name,
         coalesce(l.n_cik,0) as n_lei_cik,
         l.lei_company, l.ultimate_parent_rcid
  from work.fac_core as f
  left join work.crsp_fac as c on f.facilityid=c.facilityid
  left join work.deal_fac as d on f.facilityid=d.facilityid
  left join work.lei_gv as l on d.lei=l.lei
  left join work.fac_lei_cik as x on f.facilityid=x.facilityid;
quit;

data work.fac_gv;
  set work.fac_gv;
  length gvkey $6 map_route $18;
  facility_name_norm=compress(upcase(strip(company_name)),,'kan');
  lei_company_norm=compress(upcase(strip(lei_company)),,'kan');
  tranche_name_norm=compress(upcase(strip(borrower_name)),,'kan');
  lei_name_confirm=(n_lei_gv=1 and n_lei_rcid=1 and n_lei_company_name=1
                    and n_lei_cik=1 and n_cik_gvkey=1
                    and lei_gvkey=cik_gvkey
                    and not missing(tranche_name_norm)
                    and tranche_name_norm=lei_company_norm);
  if not missing(crsp_gvkey) and n_lei_gv=1 then do;
    if crsp_gvkey=lei_gvkey then do; gvkey=crsp_gvkey; map_route='both_agree'; end;
    else do; gvkey=''; map_route='route_conflict'; end;
  end;
  else if not missing(crsp_gvkey) then do; gvkey=crsp_gvkey; map_route='dated_name'; end;
  else if lei_name_confirm then do; gvkey=lei_gvkey; map_route='lei_cik_name'; end;
  else do; gvkey=''; map_route='unmatched'; end;
  if not missing(amount_usd_m) then loan_size=log(amount_usd_m);
  else loan_size=.;
  label loan_size='Natural log of USD facility amount in millions';
run;
proc freq data=work.fac_gv;
  tables map_route n_ticker_gvkey n_name_gvkey n_lei_gv n_cik_gvkey / missing;
run;
proc sql;
  select map_route, count(*) as facilities
  from work.fac_gv
  group by map_route;
quit;

data work.funda_src;
  set comp.funda
      (keep=GVKEY DATADATE FYEAR INDFMT DATAFMT CONSOL POPSRC CURCD AT EBITDA DLTT PPENT INVT
       where=(INDFMT='INDL' and DATAFMT='STD' and CONSOL='C' and POPSRC='D'
              and DATADATE>='01JAN1998'd and DATADATE<='31DEC2007'd));
  gvkey=strip(GVKEY);
  calyear=year(DATADATE);
  if calyear>=1998 and calyear<=2007;
  if CURCD='USD' and AT>0;
  firm_size=log(AT);
  profitability=EBITDA/AT;
  leverage=DLTT/AT;
  if not missing(PPENT) and not missing(INVT) then tangibility=(PPENT+INVT)/AT;
  else tangibility=.;
  keep gvkey datadate fyear calyear curcd at ebitda dltt ppent invt
       firm_size profitability leverage tangibility;
run;
proc sql;
  create table work.funda_dup as
  select gvkey, calyear, datadate, count(*) as nrows
  from work.funda_src
  group by gvkey, calyear, datadate
  having count(*)>1;
quit;
proc sql;
  select count(*) as duplicate_gvkey_date_keys,
         sum(nrows) as rows_in_duplicate_keys
  from work.funda_dup;
quit;
proc sql;
  create table work.funda_unique as
  select f.*
  from work.funda_src as f
  inner join
    (select gvkey, calyear, datadate
     from work.funda_src
     group by gvkey, calyear, datadate
     having count(*)=1) as u
    on f.gvkey=u.gvkey and f.calyear=u.calyear and f.datadate=u.datadate;
quit;
proc sort data=work.funda_unique out=work.funda_sort;
  by gvkey calyear datadate;
run;
data work.funda_year;
  set work.funda_sort;
  by gvkey calyear;
  if last.calyear;
run;

/* FISD provides issue ratings, so retain only senior and senior-secured issues. */
data work.senior_issue;
  set fisd.fisd_mergedissue
      (keep=ISSUE_ID SECURITY_LEVEL COMPLETE_CUSIP ISSUER_CUSIP DATED_DATE MATURITY);
  if SECURITY_LEVEL in ('SEN','SS') and not missing(COMPLETE_CUSIP)
     and not missing(DATED_DATE);
  issue_id=ISSUE_ID;
  complete_cusip=strip(COMPLETE_CUSIP);
  issuer_cusip=strip(ISSUER_CUSIP);
  issue_level=strip(SECURITY_LEVEL);
  issue_start=DATED_DATE;
  issue_maturity=MATURITY;
  keep issue_id complete_cusip issuer_cusip issue_level issue_start issue_maturity;
run;
proc freq data=work.senior_issue;
  tables issue_level / missing;
run;

/* Intersect the bond-to-stock and stock-to-Compustat date intervals. */
proc sql;
  create table work.fisd_issue_link0 as
  select m.issue_id, m.complete_cusip, m.issuer_cusip, m.issue_level,
         m.issue_start, m.issue_maturity,
         l.PERMNO, l.trace_startdt, l.trace_enddt,
         l.crsp_startdt, l.crsp_enddt, l.link_startdt, l.link_enddt,
         c.GVKEY, c.LINKPRIM, c.LINKTYPE, c.LINKDT, c.LINKENDDT
  from work.senior_issue as m
  inner join wrdsapps.bondcrsp_link as l
    on m.complete_cusip=l.CUSIP
  inner join crspccm.ccmxpf_linktable as c
    on l.PERMNO=c.LPERMNO
  where c.LINKTYPE in ('LC','LU') and c.LINKPRIM in ('P','C')
    and ((c.LINKDT<='31DEC2008'd) or c.LINKDT=.B)
    and ((c.LINKENDDT>='01JAN2002'd) or c.LINKENDDT=.E);
quit;
data work.fisd_issue_link;
  set work.fisd_issue_link0;
  map_start=max(trace_startdt,crsp_startdt,link_startdt,LINKDT);
  map_end=min(trace_enddt,crsp_enddt,link_enddt,LINKENDDT);
  if map_start<=map_end and map_start<='31DEC2008'd and map_end>='01JAN2002'd;
  gvkey=strip(GVKEY);
  keep issue_id complete_cusip issuer_cusip issue_level issue_start issue_maturity
       PERMNO gvkey LINKPRIM LINKTYPE map_start map_end;
run;
proc sql;
  create table work.fisd_target_issues as
  select distinct i.issue_id
  from work.fisd_issue_link as i
  inner join work.events as e on i.gvkey=e.gvkey;
  select count(*) as senior_issue_link_rows,
         count(distinct issue_id) as linked_senior_issues,
         count(distinct gvkey) as linked_gvkeys
  from work.fisd_issue_link;
quit;
proc freq data=work.fisd_issue_link;
  tables LINKPRIM LINKTYPE / missing;
run;

/* Preserve each rating event, including withdrawals, NR, and SUSP, until as-of selection. */
data work.fisd_rating_raw;
  if _n_=1 then do;
    declare hash hi(dataset:'work.fisd_target_issues');
    hi.defineKey('issue_id');
    hi.defineDone();
  end;
  set fisd.fisd_ratings
      (keep=ISSUE_ID RATING_TYPE RATING_DATE RATING RATING_STATUS REASON
       where=(RATING_DATE<='31DEC2008'd
              and RATING_TYPE in ('SPR','MR','FR','DPR')));
  issue_id=ISSUE_ID;
  if hi.check() ne 0 then delete;
  agency=strip(RATING_TYPE);
  rating_date=RATING_DATE;
  rating_norm=upcase(compbl(strip(RATING)));
  rating_status_raw=strip(RATING_STATUS);
  reason_raw=strip(REASON);
  rating_score=.;
  if agency='MR' then do;
    select (rating_norm);
      when ('AAA') rating_score=1;
      when ('AA1') rating_score=2;
      when ('AA2') rating_score=3;
      when ('AA3') rating_score=4;
      when ('A1') rating_score=5;
      when ('A2') rating_score=6;
      when ('A3') rating_score=7;
      when ('BAA1') rating_score=8;
      when ('BAA2') rating_score=9;
      when ('BAA3') rating_score=10;
      when ('BA1') rating_score=11;
      when ('BA2') rating_score=12;
      when ('BA3') rating_score=13;
      when ('B1') rating_score=14;
      when ('B2') rating_score=15;
      when ('B3') rating_score=16;
      when ('CAA1') rating_score=17;
      when ('CAA2') rating_score=18;
      when ('CAA3') rating_score=19;
      when ('CA') rating_score=20;
      when ('C') rating_score=21;
      when ('A') rating_score=6;
      when ('AA') rating_score=3;
      when ('B') rating_score=15;
      when ('BAA') rating_score=9;
      when ('BA') rating_score=12;
      when ('CAA') rating_score=18;
      otherwise;
    end;
  end;
  else do;
    select (rating_norm);
      when ('AAA') rating_score=1;
      when ('AA+') rating_score=2;
      when ('AA') rating_score=3;
      when ('AA-') rating_score=4;
      when ('A+') rating_score=5;
      when ('A') rating_score=6;
      when ('A-') rating_score=7;
      when ('BBB+') rating_score=8;
      when ('BBB') rating_score=9;
      when ('BBB-') rating_score=10;
      when ('BB+') rating_score=11;
      when ('BB') rating_score=12;
      when ('BB-') rating_score=13;
      when ('B+') rating_score=14;
      when ('B') rating_score=15;
      when ('B-') rating_score=16;
      when ('CCC+') rating_score=17;
      when ('CCC') rating_score=18;
      when ('CCC-') rating_score=19;
      when ('CC') rating_score=20;
      when ('C') rating_score=21;
      when ('DDD') rating_score=23;
      when ('DD') rating_score=24;
      when ('D') rating_score=25;
      otherwise;
    end;
  end;
  if reason_raw='WITH' or rating_norm in ('NR','SUSP') then event_row_state='N';
  else if not missing(rating_score) then event_row_state='G';
  else event_row_state='U';
  keep issue_id agency rating_date rating_norm rating_score rating_status_raw
       reason_raw event_row_state;
run;
proc freq data=work.fisd_rating_raw;
  tables agency rating_norm event_row_state / missing;
run;

proc sql;
  create table work.fisd_rating_map0 as
  select r.*, i.gvkey, i.LINKPRIM
  from work.fisd_rating_raw as r
  inner join work.fisd_issue_link as i
    on r.issue_id=i.issue_id
       and r.rating_date>=i.map_start and r.rating_date<=i.map_end;

  create table work.fisd_event_summary as
  select issue_id, agency, rating_date,
         count(distinct gvkey) as n_event_gvkey,
         count(distinct case when event_row_state='G' then rating_score else . end) as n_event_score,
         min(case when event_row_state='G' then rating_score else . end) as event_score,
         sum(event_row_state='N') as n_nonrating_rows,
         sum(event_row_state='U') as n_unparsed_rows,
         sum(reason_raw='WITH') as n_withdrawal_rows,
         sum(reason_raw ne 'WITH') as n_nonwithdrawal_rows
  from work.fisd_rating_map0
  group by issue_id, agency, rating_date;

  create table work.fisd_event_gv as
  select distinct issue_id, agency, rating_date, gvkey
  from work.fisd_rating_map0;

  create table work.fisd_rating_event0 as
  select g.issue_id, g.agency, g.rating_date, g.gvkey,
         s.n_event_gvkey, s.n_event_score, s.event_score,
         s.n_nonrating_rows, s.n_unparsed_rows, s.n_withdrawal_rows,
         s.n_nonwithdrawal_rows
  from work.fisd_event_gv as g
  inner join work.fisd_event_summary as s
    on g.issue_id=s.issue_id and g.agency=s.agency and g.rating_date=s.rating_date;
quit;
data work.fisd_rating_event;
  set work.fisd_rating_event0;
  length event_state $12;
  if n_event_gvkey ne 1 then event_state='MAP_CONFLICT';
  else if n_withdrawal_rows>0 and n_nonwithdrawal_rows=0 then event_state='NO_RATING';
  else if n_withdrawal_rows>0 or n_unparsed_rows>0 then event_state='AMBIGUOUS';
  else if n_event_score=1 and n_nonrating_rows=0 then do;
    event_state='RATED';
    rating_score=event_score;
  end;
  else if n_event_score=0 and n_nonrating_rows>0 then event_state='NO_RATING';
  else event_state='AMBIGUOUS';
  keep issue_id agency rating_date gvkey event_state rating_score;
run;

/* Find the last mapped issue-level event for every outstanding senior issue at each loan date. */
proc sql;
  create table work.fac_rating_target as
  select f.facilityid, f.gvkey, f.facdate
  from work.fac_gv as f
  inner join work.events as e on f.gvkey=e.gvkey;

  create table work.fac_issue_seed as
  select distinct f.facilityid, f.gvkey, f.facdate, i.issue_id
  from work.fac_rating_target as f
  inner join work.fisd_issue_link as i
    on f.gvkey=i.gvkey and f.facdate>=i.map_start and f.facdate<=i.map_end
  where i.issue_start<=f.facdate
    and (missing(i.issue_maturity) or i.issue_maturity>=f.facdate);

  create table work.fac_issue_map_stats as
  select s.facilityid, s.issue_id, count(distinct i.gvkey) as n_issue_gvkey
  from work.fac_issue_seed as s
  inner join work.fisd_issue_link as i
    on s.issue_id=i.issue_id
       and s.facdate>=i.map_start and s.facdate<=i.map_end
       and i.issue_start<=s.facdate
       and (missing(i.issue_maturity) or i.issue_maturity>=s.facdate)
  group by s.facilityid, s.issue_id;

  create table work.fac_issue_latest as
  select s.facilityid, s.gvkey, s.facdate, s.issue_id, e.agency,
         max(e.rating_date) as rating_date format=yymmdd10.
  from work.fac_issue_seed as s
  inner join work.fisd_rating_event as e
    on s.issue_id=e.issue_id and s.gvkey=e.gvkey and e.rating_date<=s.facdate
  group by s.facilityid, s.gvkey, s.facdate, s.issue_id, e.agency;

  create table work.fac_issue_raw_latest as
  select s.facilityid, s.gvkey, s.facdate, s.issue_id, r.agency,
         max(r.rating_date) as raw_latest_date format=yymmdd10.
  from work.fac_issue_seed as s
  inner join work.fisd_rating_raw as r
    on s.issue_id=r.issue_id and r.rating_date<=s.facdate
  group by s.facilityid, s.gvkey, s.facdate, s.issue_id, r.agency;

  create table work.fac_issue_states as
  select r.facilityid, r.gvkey, r.facdate, r.issue_id, r.agency,
         r.raw_latest_date as rating_date format=yymmdd10.,
         case when missing(l.rating_date) or r.raw_latest_date>l.rating_date
              then 'HISTORY_UNAVAILABLE' else e.event_state end as event_state length=24,
         e.rating_score
  from work.fac_issue_raw_latest as r
  left join work.fac_issue_latest as l
    on r.facilityid=l.facilityid and r.issue_id=l.issue_id and r.agency=l.agency
  left join work.fisd_rating_event as e
    on l.issue_id=e.issue_id and l.gvkey=e.gvkey and l.agency=e.agency
       and l.rating_date=e.rating_date;

  create table work.fac_issue_coverage0 as
  select s.facilityid, count(distinct s.issue_id) as n_senior_issues,
         sum(m.n_issue_gvkey>1) as n_issue_map_conflicts
  from work.fac_issue_seed as s
  left join work.fac_issue_map_stats as m
    on s.facilityid=m.facilityid and s.issue_id=m.issue_id
  group by s.facilityid;

  create table work.fac_history0 as
  select facilityid, count(*) as n_rating_history_events,
         count(distinct issue_id) as n_issues_with_history
  from work.fac_issue_raw_latest
  group by facilityid;

  create table work.fisd_agency0 as
  select facilityid, agency,
         sum(event_state='RATED') as n_active_issues,
         count(distinct case when event_state='RATED' then rating_score else . end) as n_active_scores,
         min(case when event_state='RATED' then rating_score else . end) as agency_score,
         sum(event_state in ('AMBIGUOUS','MAP_CONFLICT','HISTORY_UNAVAILABLE')) as n_unresolved_events,
         max(rating_date) as latest_event_date format=yymmdd10.
  from work.fac_issue_states
  group by facilityid, agency;
quit;
data work.fisd_agency;
  set work.fisd_agency0;
  length agency_state $14;
  if n_unresolved_events>0 then agency_state='UNAVAILABLE';
  else if n_active_scores>1 then agency_state='CONFLICT';
  else if n_active_scores=1 then agency_state='RATED';
  else agency_state='NO_RATING';
run;
proc sql;
  create table work.fisd_agency_pivot as
  select facilityid,
         max(case when agency='SPR' then agency_state else '' end) as fisd_sp_state length=14,
         max(case when agency='MR' then agency_state else '' end) as moodys_state length=14,
         max(case when agency='FR' then agency_state else '' end) as fitch_state length=14,
         max(case when agency='DPR' then agency_state else '' end) as dpr_state length=14,
         max(case when agency='SPR' then agency_score else . end) as fisd_sp_score,
         max(case when agency='MR' then agency_score else . end) as moodys_score,
         max(case when agency='FR' then agency_score else . end) as fitch_score,
         max(case when agency='DPR' then agency_score else . end) as dpr_score,
         max(case when agency='SPR' then latest_event_date else . end) as fisd_sp_date format=yymmdd10.,
         max(case when agency='MR' then latest_event_date else . end) as moodys_date format=yymmdd10.,
         max(case when agency='FR' then latest_event_date else . end) as fitch_date format=yymmdd10.,
         max(case when agency='DPR' then latest_event_date else . end) as dpr_date format=yymmdd10.
  from work.fisd_agency
  group by facilityid;

  create table work.fisd_coverage as
  select f.facilityid,
         coalesce(c.n_senior_issues,0) as n_senior_issues,
         coalesce(c.n_issue_map_conflicts,0) as n_issue_map_conflicts,
         coalesce(h.n_rating_history_events,0) as n_rating_history_events,
         coalesce(h.n_issues_with_history,0) as n_issues_with_history,
         p.fisd_sp_state, p.moodys_state, p.fitch_state, p.dpr_state,
         p.fisd_sp_score, p.moodys_score, p.fitch_score, p.dpr_score,
         p.fisd_sp_date, p.moodys_date, p.fitch_date, p.dpr_date
  from work.fac_rating_target as f
  left join work.fac_issue_coverage0 as c on f.facilityid=c.facilityid
  left join work.fac_history0 as h on f.facilityid=h.facilityid
  left join work.fisd_agency_pivot as p on f.facilityid=p.facilityid;
quit;
proc freq data=work.fisd_coverage;
  tables n_senior_issues n_issue_map_conflicts n_rating_history_events
         fisd_sp_state moodys_state fitch_state dpr_state / missing;
run;

/* The appendix describes a 1-27 common scale but does not print its crosswalk.
   This raw-grade notch conversion is best-effort; NR and SUSP are states. */
proc freq data=compir.adsprate;
  tables SPLTICRM / missing;
run;
data work.rating_raw;
  set compir.adsprate(keep=GVKEY DATADATE SPLTICRM
                      where=(DATADATE<='31DEC2008'd));
  if not missing(DATADATE);
  gvkey=strip(GVKEY);
  length rating_raw $10 rating_norm $10 row_state $1;
  rating_raw=upcase(strip(SPLTICRM));
  rating_norm=compress(rating_raw,' ');
  rating_score=.;
  select (rating_norm);
    when ('AAA') rating_score=1;
    when ('AA+') rating_score=2;
    when ('AA') rating_score=3;
    when ('AA-') rating_score=4;
    when ('A+') rating_score=5;
    when ('A') rating_score=6;
    when ('A-') rating_score=7;
    when ('BBB+') rating_score=8;
    when ('BBB') rating_score=9;
    when ('BBB-') rating_score=10;
    when ('BB+') rating_score=11;
    when ('BB') rating_score=12;
    when ('BB-') rating_score=13;
    when ('B+') rating_score=14;
    when ('B') rating_score=15;
    when ('B-') rating_score=16;
    when ('CCC+') rating_score=17;
    when ('CCC') rating_score=18;
    when ('CCC-') rating_score=19;
    when ('CC') rating_score=20;
    when ('C') rating_score=21;
    when ('D') rating_score=25;
    otherwise;
  end;
  if rating_norm in ('NR','SUSP') then row_state='N';
  else if not missing(rating_score) then row_state='G';
  else row_state='U';
  keep gvkey DATADATE rating_raw rating_norm rating_score row_state;
run;
proc sql;
  create table work.rating_day0 as
  select gvkey, DATADATE,
         count(distinct case when row_state='G' then rating_score else . end) as n_score,
         sum(row_state='N') as n_nonrating,
         sum(row_state='U') as n_unparsed,
         min(case when row_state='G' then rating_score else . end) as credit_rating
  from work.rating_raw
  group by gvkey, DATADATE;
quit;
data work.rating_day;
  set work.rating_day0;
  length comp_state $14;
  if n_unparsed>0 or (n_score>0 and n_nonrating>0) then comp_state='UNAVAILABLE';
  else if n_score>1 then comp_state='CONFLICT';
  else if n_score=1 then comp_state='RATED';
  else if n_nonrating>0 then comp_state='NO_RATING';
  else comp_state='UNAVAILABLE';
run;
proc sql;
  create table work.rate_date as
  select f.facilityid, max(r.DATADATE) as rating_date format=yymmdd10.
  from work.fac_rating_target as f
  left join work.rating_day as r
    on f.gvkey=r.gvkey and r.DATADATE<=f.facdate
  group by f.facilityid;

  create table work.rate_comp_fac as
  select f.facilityid, f.gvkey, f.facdate,
         d.rating_date as comp_rating_date format=yymmdd10.,
         r.comp_state, r.credit_rating as comp_rating
  from work.fac_rating_target as f
  left join work.rate_date as d on f.facilityid=d.facilityid
  left join work.rating_day as r
    on f.gvkey=r.gvkey and d.rating_date=r.DATADATE;

  create table work.rating_join as
  select c.*, coalesce(v.n_senior_issues,0) as n_senior_issues,
         coalesce(v.n_issue_map_conflicts,0) as n_issue_map_conflicts,
         coalesce(v.n_rating_history_events,0) as n_rating_history_events,
         v.fisd_sp_state, v.moodys_state, v.fitch_state, v.dpr_state,
         v.fisd_sp_score, v.moodys_score, v.fitch_score, v.dpr_score,
         v.fisd_sp_date, v.moodys_date, v.fitch_date, v.dpr_date
  from work.rate_comp_fac as c
  left join work.fisd_coverage as v on c.facilityid=v.facilityid;
quit;
data work.rate_gv_fac;
  set work.rating_join;
  length rating_source $16 rating_status $32;
  rating_unparsed=0;
  rating_date=.;
  credit_rating=.;
  rating_source='';
  rating_status='MAPPING_OR_HISTORY_UNAVAILABLE';
  fisd_usable=(n_senior_issues>0 and n_issue_map_conflicts=0
               and n_rating_history_events>0);
  if comp_state='RATED' then do;
    credit_rating=comp_rating;
    rating_source='SP_ISSUER';
    rating_status='RATED';
    rating_date=comp_rating_date;
  end;
  else if comp_state in ('UNAVAILABLE','CONFLICT') then do;
    if fisd_usable and fisd_sp_state='RATED' then do;
      credit_rating=fisd_sp_score; rating_source='FISD_SP';
      rating_date=fisd_sp_date; rating_status='RATED';
    end;
    else do;
      rating_unparsed=1;
      if comp_state='CONFLICT' then rating_status='AGENCY_CONFLICT';
    end;
  end;
  else do;
    if fisd_usable then do;
      if fisd_sp_state='RATED' then do;
        credit_rating=fisd_sp_score; rating_source='FISD_SP';
        rating_date=fisd_sp_date; rating_status='RATED';
      end;
      else if fisd_sp_state in ('UNAVAILABLE','CONFLICT') then do;
        rating_unparsed=1; rating_status='AGENCY_CONFLICT';
      end;
      else if moodys_state='RATED' then do;
        credit_rating=moodys_score; rating_source='MOODYS';
        rating_date=moodys_date; rating_status='RATED';
      end;
      else if moodys_state in ('UNAVAILABLE','CONFLICT') then do;
        rating_unparsed=1; rating_status='AGENCY_CONFLICT';
      end;
      else if fitch_state='RATED' then do;
        credit_rating=fitch_score; rating_source='FITCH';
        rating_date=fitch_date; rating_status='RATED';
      end;
      else if fitch_state in ('UNAVAILABLE','CONFLICT') then do;
        rating_unparsed=1; rating_status='AGENCY_CONFLICT';
      end;
      else if dpr_state='RATED' then do;
        credit_rating=dpr_score; rating_source='DPR';
        rating_date=dpr_date; rating_status='RATED';
      end;
      else if dpr_state in ('UNAVAILABLE','CONFLICT') then do;
        rating_unparsed=1; rating_status='AGENCY_CONFLICT';
      end;
      else do;
        credit_rating=28; rating_source='NO_AGENCY';
        rating_status='NO_AGENCY_RATING_OBSERVED';
      end;
    end;
    else do;
      rating_unparsed=1;
      rating_status='MAPPING_OR_HISTORY_UNAVAILABLE';
    end;
  end;
  if rating_status='RATED' then rating_observed=1;
  else rating_observed=0;
  credit_rating_sq=credit_rating*credit_rating;
  label credit_rating='S&P, Moody, Fitch, or DPR senior-debt rating; 28 only when no agency rating was observed'
        rating_observed='At least one mapped senior-debt agency rating is available'
        rating_unparsed='Agency conflict or rating-mapping/history unavailable'
        rating_source='Agency source selected by the paper fallback order'
        rating_status='Rating availability and mapping state';
run;
proc freq data=work.rate_gv_fac;
  tables comp_state fisd_sp_state moodys_state fitch_state dpr_state
         rating_source rating_status rating_observed / missing;
run;

proc sql;
  create table work.fac_terms as
  select f.*, m.financial_covenants,
         p.general_covenants,
         s.interest_rate, s.libor_rows, s.spread_values,
         pp.pp_indicator, pp.pp_ratio, pp.pp_rows,
         l.num_lenders, l.lender_rows,
         a.rating_date, a.credit_rating, a.credit_rating_sq,
         a.rating_observed, a.rating_unparsed,
         a.rating_source, a.rating_status, a.n_senior_issues,
         a.n_issue_map_conflicts, a.n_rating_history_events,
         fu.firm_size, fu.profitability, fu.leverage, fu.tangibility
  from work.fac_gv as f
  left join work.fin_cov as m on f.packageid=m.packageid
  left join work.pkg_terms as p on f.packageid=p.packageid
  left join work.pricing as s on f.facilityid=s.facilityid
  left join work.pp_fac as pp on f.facilityid=pp.facilityid
  left join work.lenders as l on f.facilityid=l.facilityid
  left join work.rate_gv_fac as a on f.facilityid=a.facilityid
  left join work.funda_year as fu
    on f.gvkey=fu.gvkey and fu.calyear=f.loan_year-1;
quit;

data work.fac_terms;
  set work.fac_terms;
  if missing(financial_covenants) then financial_covenants=0;
  if missing(pp_indicator) then pp_indicator=0;
  if missing(pp_ratio) and pp_indicator=0 then pp_ratio=.;
  if not missing(loan_year) then prior_year=loan_year-1;
  label financial_covenants='Number of financial covenant rows in loan package'
        general_covenants='Count of the five general-covenant components'
        num_lenders='Number of unique lender participant IDs';
run;

proc sql;
  create table work.fac_events as
  select f.*, e.first_mw, e.clean_date
  from work.fac_terms as f
  inner join work.events as e on f.gvkey=e.gvkey;
quit;

data work.analysis_all;
  set work.fac_events;
  prior_start=intnx('year',first_mw,-3,'same');
  corrected_end=.;
  prior=0; uncorrected=0; corrected=0;
  if facdate>=prior_start and facdate<first_mw then prior=1;
  else if facdate>=first_mw and
          (missing(clean_date) or facdate<=clean_date) then uncorrected=1;
  else if not missing(clean_date) and facdate>clean_date then do;
    corrected_end=intnx('year',clean_date,3,'same');
    if facdate<=corrected_end then corrected=1;
  end;
  if prior or uncorrected or corrected;
  if maturity>0 then ln_maturity=log(maturity);
  else ln_maturity=.;
  if nmiss(financial_covenants,interest_rate,secured,
           loan_size,maturity,ln_maturity,credit_rating,credit_rating_sq,
           num_lenders,pp_indicator,firm_size,profitability,leverage,tangibility,
           inst_investor,revolver)=0 then complete_case=1;
  else complete_case=0;
  complete_general=(not missing(general_covenants));
  label prior='Facility in three years before first material report'
        uncorrected='Facility before first explicit clean report'
        corrected='Facility in three years after first explicit clean report'
        firm_size='Natural log of prior-year USD total assets'
        profitability='Prior-year EBITDA divided by assets'
        leverage='Prior-year long-term debt divided by assets'
        tangibility='Prior-year net PPE plus inventory divided by assets'
        credit_rating='Four-agency senior debt ordinal rating; 28 only when no agency rating was observed'
        credit_rating_sq='Square of four-agency senior debt ordinal rating'
        ln_maturity='Natural log of facility maturity in months';
run;

proc sql;
  create table work.main_firm_elig as
  select gvkey,
         max(case when complete_case=1 and prior=1 then 1 else 0 end) as has_prior,
         max(case when complete_case=1 and (uncorrected=1 or corrected=1) then 1 else 0 end) as has_post
  from work.analysis_all
  group by gvkey;

  create table work.main_pre as
  select a.*
  from work.analysis_all as a
  inner join work.main_firm_elig as e on a.gvkey=e.gvkey
  where a.complete_case=1 and e.has_prior=1 and e.has_post=1;

  create table work.pp_firm_elig as
  select gvkey,
         max(case when prior=1 and pp_indicator=1 and rating_observed=1 then 1 else 0 end) as pp_prior,
         max(case when (uncorrected=1 or corrected=1) and pp_indicator=1
                       and rating_observed=1 then 1 else 0 end) as pp_post
  from work.main_pre
  group by gvkey;

  create table work.pp_pre as
  select a.*
  from work.main_pre as a
  inner join work.pp_firm_elig as p on a.gvkey=p.gvkey
  where p.pp_prior=1 and p.pp_post=1 and a.pp_indicator=1
    and a.pp_ratio in (0,1) and a.rating_observed=1;
quit;

proc sql;
  select count(*) as complete_facilities,
         count(distinct gvkey) as complete_firms,
         sum(prior=1) as prior_facilities,
         sum(uncorrected=1) as uncorrected_facilities,
         sum(corrected=1) as corrected_facilities
  from work.analysis_all
  where complete_case=1;
  select count(*) as main_facilities,
         count(distinct gvkey) as main_firms
  from work.main_pre;
  select count(*) as pp_facilities,
         count(distinct gvkey) as pp_firms
  from work.pp_pre;
quit;

proc freq data=work.analysis_all;
  tables loan_year prior uncorrected corrected complete_case / missing;
run;
proc means data=work.analysis_all n nmiss min p1 median p99 max;
  var financial_covenants general_covenants interest_rate secured loan_size
      maturity credit_rating credit_rating_sq num_lenders pp_indicator
      pp_ratio firm_size profitability leverage tangibility;
run;

proc sql;
  create table work.firmids as
  select distinct gvkey
  from work.main_pre
  order by gvkey;
quit;
data work.firmids;
  set work.firmids;
  firmid=_n_;
run;

proc sql;
  create table work.final_main as
  select a.*, f.firmid
  from work.main_pre as a
  left join work.firmids as f on a.gvkey=f.gvkey;

  create table work.final_pp as
  select a.*, f.firmid
  from work.pp_pre as a
  left join work.firmids as f on a.gvkey=f.gvkey;
quit;

proc sql noprint;
  select count(*), count(distinct facilityid)
    into :nmain trimmed, :kmain trimmed
  from work.final_main;
  select count(*), count(distinct facilityid)
    into :npp trimmed, :kpp trimmed
  from work.final_pp;
quit;
%macro check_final_keys;
  %if &nmain ne &kmain or &npp ne &kpp %then %do;
          %put BUILD_GUARD: Final sample contains duplicated facility identifiers. Resolve source cardinality before export.;
    %abort cancel;
  %end;
%mend;
%check_final_keys;

data out.icw_loan_facilities;
  set work.final_main;
  keep facilityid gvkey firmid loan_year first_mw clean_date
       map_route n_ticker_gvkey n_name_gvkey n_lei_gv n_cik_gvkey
       prior uncorrected corrected inst_investor revolver
       interest_rate financial_covenants general_covenants secured
       loan_size maturity ln_maturity credit_rating credit_rating_sq
       num_lenders pp_indicator pp_ratio rating_observed rating_unparsed
       rating_source rating_status n_senior_issues n_issue_map_conflicts
       n_rating_history_events complete_general
       firm_size profitability leverage tangibility;
  label facilityid='DealScan facility identifier'
        gvkey='Compustat company identifier'
        firmid='Numeric borrower cluster identifier'
        loan_year='Calendar year facility began'
        uncorrected='One for uncorrected ICW period'
        corrected='One for three years after explicit correction'
        inst_investor='Term loan B, C, or D'
        revolver='Revolving loan facility'
        interest_rate='All-in-drawn spread in basis points over LIBOR'
        loan_size='Log of DealScan amount converted to USD millions'
        maturity='Facility maturity in months'
        num_lenders='Distinct lender participant IDs'
        pp_indicator='Performance-pricing contract indicator'
        pp_ratio='One accounting-ratio grid; zero credit-rating grid'
        rating_observed='At least one mapped senior-debt agency rating is available'
        complete_general='General-covenant dependent variable is observed';
run;

data out.icw_pp_ratio_eligible;
  set work.final_pp;
  keep facilityid gvkey firmid loan_year first_mw clean_date
       map_route n_ticker_gvkey n_name_gvkey n_lei_gv n_cik_gvkey
       prior uncorrected corrected inst_investor revolver
       secured loan_size maturity credit_rating credit_rating_sq
       num_lenders pp_indicator pp_ratio rating_observed rating_source rating_status
       n_senior_issues n_issue_map_conflicts n_rating_history_events
       firm_size profitability leverage tangibility;
  label facilityid='DealScan facility identifier'
        gvkey='Compustat company identifier'
        firmid='Numeric borrower cluster identifier'
        loan_year='Calendar year facility began'
        pp_ratio='One accounting-ratio grid; zero credit-rating grid'
        rating_observed='At least one mapped senior-debt agency rating is available';
run;

proc sql;
  select count(*) as rows, count(distinct facilityid) as unique_facilities
  from out.icw_loan_facilities;
  select count(*) as rows, count(distinct facilityid) as unique_facilities
  from out.icw_pp_ratio_eligible;
quit;
proc freq data=out.icw_loan_facilities;
  tables loan_year prior uncorrected corrected complete_general map_route
         rating_source rating_status / missing;
run;
proc freq data=out.icw_pp_ratio_eligible;
  tables loan_year prior uncorrected corrected pp_ratio / missing;
run;
proc means data=out.icw_loan_facilities n nmiss mean std min p50 max;
  var financial_covenants general_covenants interest_rate secured loan_size
      maturity credit_rating num_lenders pp_indicator firm_size profitability
      leverage tangibility;
run;
proc means data=out.icw_pp_ratio_eligible n nmiss mean std min p50 max;
  var pp_ratio credit_rating maturity loan_size firm_size profitability
      leverage tangibility;
run;

title;
