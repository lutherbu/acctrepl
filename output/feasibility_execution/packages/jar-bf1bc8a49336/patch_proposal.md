# Patch proposal: jar-bf1bc8a49336

Intangible Investments, Scaling, and the Trend in the Accruals-Cash Flows Association

DOI: 10.1111/1475-679X.12414

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author workflow: SAS raw-data construction, MISP/CRSP/factor branches, SAS Figures 1A–1D and 2, and Stata main plus appendix tables.

Entry points: `GLS Datasheet-Codes-Identifiers/Replication Code/Main_Code.sas`, `GLS Datasheet-Codes-Identifiers/Replication Code/Tables.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 4/12414 - Intangible-Investments-Scaling-and-the-Trend-in-the-Accruals-Cash-Flows-Association/gls-datasheet-code-and-identifiers.zip",
      "sha256": "1871ece1e05345f661237ee5c5f1f16d88f89277aceb644b5975a4b2dab9863a"
    },
    {
      "path": "JAR-Volume 60/Issue 4/12414 - Intangible-Investments-Scaling-and-the-Trend-in-the-Accruals-Cash-Flows-Association/gls-online-appendix.pdf",
      "sha256": "b752c7b73552960f02370f56c4f26bda9861102d53cc430811e8b367a171cd8f"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "0c2d36a456011864c4940019005b4c301c0179e95e466988390a008934341c49"
}
```

## Proposed actions

### A_COMPANY_LOOKUP: Use the author-named Compustat company lookup through the WRDS route or the verified local COMP.COMPANY entity-lookup route, separate from annual Funda history.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_COMPUSTAT_COMPANY
Evidence: E_DATA_SOURCES, E_STEP1, E_SAS_COMPUSTAT, E_SAS_SIC_FILTER, E_CATALOG_COMPANY, E_COMPANY_LOOKUP_PROBE

Preparation / proposed procedure:

1. Use the author-named Compustat company product through the platform WRDS route or the verified local COMP.COMPANY candidate at ${ACCTREPL_SAS_ROOT}/comp/d_na/company/company.sas7bdat; the bounded probe confirms readable GVKEY/SIC columns.
2. Stage any local route at the supplied relative Data/Comp/company.sas7bdat destination or configure the same local library mapping; the company lookup itself has no annual history window.
3. Keep the GVKEY entity-key lookup separate from Funda. Use company SIC for the unqualified SIC in the current catalog schema; do not use annual Funda SICH as a substitute.

Validation to perform later:

- Before a future run, retain the successful bounded readability/schema result and verify the staged company file remains at the expected local library path.
- After a future full run, compare joined and unmatched GVKEYs as sample-fidelity QA; the one-row probe's generic coverage_verified=false remains a probe limit and is not a separate route-availability prerequisite.
- Confirm the SIC field remains the company lookup's current SIC value for financial-firm exclusion and FF48 grouping; no annual SIC history is required by the supplied code.

### A_FUNDA_PANEL: Provide Compustat Funda annual records for the code-selected fields, filters and source-relative lag/current/lead CFO construction.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_COMPUSTAT_FUNDA
Evidence: E_DATA_SOURCES, E_SAS_COMPUSTAT, E_SAS_SAMPLE, E_SAS_ZERO_LAGS, E_SAS_LEAD_LAG, E_CATALOG_FUNDA

Preparation / proposed procedure:

1. During authorized preparation, use the author-named Funda product through WRDS or the catalog-listed local COMP.FUNDA candidate at ${ACCTREPL_SAS_ROOT}/comp/d_na/funda.sas7bdat; product access and full source history remain unverified.
2. Provide the code-selected fields and source fyear history spanning 1963–2020. The final sample remains 1964–2019; 1963 supports the earliest one-year lag/balance-sheet averages and 2020 supplies the pre-cut lead CFO for 2019 Table A8 rows.
3. Preserve the INDFMT/DATAFMT/POPSRC/CONSOL filters and the explicit zero terms in R&D, advertising and Investment SG&A sums; do not require older years solely to fill missing R&D/advertising lag terms.

Validation to perform later:

- Before a future run, check the exact raw field names, GVKEY/fiscal-year/date keys and source coverage through fyear 1963–2020 by bounded metadata; the local catalog candidate has the selected fields but has not been probed for history.
- After a separately authorized run, confirm the final sample remains 1964–2019 and that the authored pre-cut comp9/comp10 construction supplies the 2020 lead CFO for Table A8 without changing missing-value sums or sample rules.

### A_CCM_LINKS: Provide CRSP/Compustat CCM link history under the authored conditions, through either WRDS or the catalog-listed local product.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_CRSP_CCM
Evidence: E_DATA_SOURCES, E_SAS_CCM, E_CATALOG_CCM

Preparation / proposed procedure:

1. During authorized preparation, use the author-named ccmxpf_linktable product or the exact local candidate ${ACCTREPL_SAS_ROOT}/crsp/a_ccm/ccmxpf_linktable.sas7bdat; current file readability, history and access remain unverified.
2. Preserve GVKEY-to-LPERMNO mapping, LU/LC link types, P/C primary-link values, nonmissing LPERMNO, dated LINKDT/LINKENDDT conditions and the accepted open-ended .E value.
3. For local staging, place the file at the supplied relative Data/CRSP/ccmxpf_linktable.sas7bdat destination; preserve the existing dated link rules and do not replace the link table.

Validation to perform later:

- Before a future run, confirm the required source columns, date types, link values and local library path with a bounded metadata check.
- After a separately authorized run, verify the resulting PERMNO join keys and date restrictions from the generated sample.

### A_CRSP_MONTHLY: Provide the author-named CRSP MSF and MSEDELIST inputs through WRDS or the catalog-listed local same-product candidates for the risk and alpha branches.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_CRSP_MSF, R_CRSP_MSEDELIST
Evidence: E_DATA_SOURCES, E_SAS_REMOTE, E_SAS_RISK, E_SAS_ALPHA, E_CATALOG_MSF, E_CATALOG_MSEDELIST

Preparation / proposed procedure:

1. During authorized preparation, use the author-named CRSP products or local candidates ${ACCTREPL_SAS_ROOT}/crsp/a_stock/msf.sas7bdat and ${ACCTREPL_SAS_ROOT}/crsp/a_stock/msedelist.sas7bdat; only the named products/fields are catalogued and current readability/history remain unverified.
2. For local staging, place MSF and MSEDELIST at the supplied relative Data/CRSP/msf.sas7bdat and Data/CRSP/msedelist.sas7bdat destinations; retain the authored PERMNO/month matching, missing-RET filters and delisting-return adjustment.
3. Preserve the pre-fiscal-year-end 12-month return-risk branch and following 12-month factor-alpha branch, including the authored _EDF_ eligibility thresholds.

Validation to perform later:

- Before a future run, check the source fields, date types and local paths: MSF PERMNO/DATE/RET and MSEDELIST PERMNO/DLSTDT/DLRET.
- After a separately authorized run, verify the adjusted monthly return joins and the authored risk and alpha windows without changing the sample rules.

### A_FF_FACTORS: Provide the monthly Fama-French factor product through the author WRDS route or the catalog-listed local same-product candidate.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_FF_MONTHLY
Evidence: E_DATA_SOURCES, E_SAS_REMOTE, E_SAS_ALPHA, E_CATALOG_FF

Preparation / proposed procedure:

1. During authorized preparation, use the author-named factors_monthly product or the local candidate ${ACCTREPL_SAS_ROOT}/ff/factors_monthly.sas7bdat; source readability and post-year-end coverage remain unverified.
2. For local staging, place the monthly factor file at the supplied relative Data/Fama_French/factors_monthly.sas7bdat destination, preserving the supplied calendar-month date join and three-/four-factor regressions.

Validation to perform later:

- Before a future run, check DATE, RF, MKTRF, SMB, HML and UMD fields, date types, local path and coverage of the following-year alpha windows.
- After a separately authorized run, verify factor matches and alpha outputs under the author code's _EDF_ cutoffs.

### A_MISP_FILE_SCHEMA: Obtain the named Stambaugh MISP score input and confirm the exact import columns and join keys used by the supplied MISP branch.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_MISP, I_MISP_SCHEMA
Evidence: E_DATA_SOURCES, E_SAS_MISP, E_APPENDIX_MISP, E_STATA_APP_A7

Preparation / proposed procedure:

1. During authorized preparation, obtain the Misp_Score.txt file from the author-named Stambaugh source recorded in the datasheet; current availability, schema and coverage are unverified.
2. Preserve the supplied SAS import and mapping of _, var3 and var5 to PERMNO, YYYYMM and MISP after checking the source's actual header and import semantics.
3. Keep the MISP branch and its fyear<=2016 Table A7 restriction; do not substitute another score or alter the separate alpha and return-risk analyses.

Validation to perform later:

- Before a future run, confirm the file format/header, identifier and month types, and coverage through the documented 2016 endpoint against the supplied join.
- After a separately authorized run, verify MISP merges by PERMNO and calendar year/month and retain the Table A7 cutoff.

### A_SAS_MACROS: Resolve the two absent macro include contracts using the exact author-intended winsor and FF48 definitions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_MISSING_MACROS
Evidence: E_SAS_INCLUDES, E_SAS_INVEST_SGA, E_SAS_SAMPLE

Preparation / proposed procedure:

1. Obtain the author-intended macros/winsor.sas and macros/ind_ff48.sas definitions or equivalent exact project setup details; the frozen package does not contain these includes.
2. Place the confirmed files at the relative Replication Code/macros paths named by Main_Code.sas, preserving the authored winsorization and SIC-to-FF48 investment SG&A branch.
3. Do not replace either definition with an independently chosen macro or inferred industry mapping.

Validation to perform later:

- Before a future run, inspect that both include targets resolve and the macro definitions provide the variables, classification and year-grouped 1/99 winsorization consumed downstream.
- After a separately authorized run, check the investment-SG&A and final sample outputs against the authored formulas and filters.

### A_SOURCE_ROUTE_CONFIG: Select and configure either the author WRDS transfer route or local same-product staging without changing the scientific data construction.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_WRDS_MAPPING
Evidence: E_SAS_REMOTE, E_SAS_INCLUDES, E_CATALOG_COMPANY, E_CATALOG_FUNDA, E_CATALOG_CCM, E_CATALOG_MSF, E_CATALOG_MSEDELIST, E_CATALOG_FF

Preparation / proposed procedure:

1. For the author route, rely on the execution host's existing SAS/CONNECT setup for remote=WRDS and the platform-configured session librefs consumed by the authored PROC DOWNLOAD statements; the source package does not name additional remote library assignments, and no author-specific account requirement is inferred.
2. For the local alternative, stage catalog-listed same-product files at the supplied relative sibling paths: Data/Comp/company.sas7bdat and funda.sas7bdat; Data/CRSP/ccmxpf_linktable.sas7bdat, msf.sas7bdat and msedelist.sas7bdat; Data/Fama_French/factors_monthly.sas7bdat.
3. When selecting local staging, configure the working-copy run path to bypass only the remote signon/PROC DOWNLOAD transfer block at Main_Code.sas lines 25–39; keep the relative local librefs, downstream reads, sample, variables, transformations and output branches intact. If the host has no configuration mechanism for this route, retain that operational setup gap rather than inventing remote librefs.

Validation to perform later:

- Before a future run, confirm the unprobed Data subdirectories and remaining local product fields/date/history contracts; the COMP.COMPANY local route has verified readability and GVKEY/SIC schema.
- If the remote route is selected, confirm SAS/CONNECT is available and the host's configured session librefs map to the author-named products without inferring missing entitlement.
- Confirm the local mode omits only data transfer statements and feeds the same local library names used later by Main_Code.sas; compare Funda GVKEY joins as later output-fidelity QA.

### A_SAS_RUNTIME: Verify the base SAS Foundation runtime after the supplied environment probe's TKELS initialization failure.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_SAS
Evidence: E_ENVIRONMENT, E_SAS_REMOTE, E_SAS_FIGURE1, E_SAS_FIGURE2

Preparation / proposed procedure:

1. Use the host's bounded software inventory or component metadata to determine whether the SAS Foundation runtime is available in the intended execution environment; do not start SAS or run Main_Code.sas during this assessment.
2. If TKELS initialization still fails, resolve the host environment setup with its maintainer; the supplied probe does not establish a missing license or access barrier.
3. SAS/CONNECT is conditional on selecting the WRDS remote-transfer route; a local staged route does not require SAS/CONNECT.

Validation to perform later:

- Record bounded host software metadata for the SAS runtime before any separately authorized replication run; retain uncertainty if the host cannot confirm it.
- Do not infer component or license absence from the current TKELS probe failure.

### A_OUTREG2_SETUP: Make the author-required outreg2 Stata command available in a permitted add-on path for workbook exports.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_OUTREG2
Evidence: E_ENVIRONMENT, E_STATA_MAIN_TABLES

Preparation / proposed procedure:

1. Follow the machine's permitted Stata add-on setup process to expose outreg2 on the Stata adopath; the supplied metadata probe did not find it in the checked default/shared paths.
2. Preserve the supplied outreg2 calls and requested main/appendix workbook outputs; do not execute Tables.do during this assessment.

Validation to perform later:

- Before a future run, verify the outreg2 command path with bounded Stata metadata/which inspection.
- After a separately authorized run, check that each author-specified workbook export is produced in the Tables directory.

### A_ORDERED_FULL_WORKFLOW: After required inputs, macros and software are prepared, run the complete supplied SAS-to-Stata workflow with the author WRDS route or a compatible local staging route.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: E_AUTHOR_WORKFLOW, E_STEP1, E_STEP2, E_SAS_FIGURE1, E_SAS_FIGURE2, E_STATA_MAIN_TABLES, E_STATA_APP_A1_A2, E_STATA_APP_A3_A6, E_STATA_APP_A7, E_STATA_APP_A8, E_WORKFLOW_TRACE_FINAL, E_SAS_LEAD_LAG, E_CATALOG_COMPANY, E_CATALOG_FUNDA, E_CATALOG_CCM, E_CATALOG_MSF, E_CATALOG_MSEDELIST, E_CATALOG_FF, E_SAS_ANNUAL_EXPORT, E_SAS_STATA_EXPORTS

Preparation / proposed procedure:

1. Stage the supplied relative project tree under an approved execution location, keeping Replication Code beside Data and Tables and macros beneath Replication Code; do not place Dropbox absolute paths in executable configuration.
2. Select either the platform-configured SAS/CONNECT WRDS route or the local same-product files staged in Data/Comp, Data/CRSP and Data/Fama_French. In local mode, bypass only the remote transfer block and keep all downstream code paths and data logic intact.
3. With the working directory at Replication Code, run Main_Code.sas through the documented SAS host wrapper; it constructs the source-relative lag/current/lead CFO before the 1964–2019 cut, writes ACC_CFO/Annual_ACC_CFO Stata handoffs, and creates the separate SAS Figure 1A–1D and Figure 2 outputs.
4. Then run Tables.do from the same Replication Code working directory; it first consumes Annual_ACC_CFO.dta for T3A/T4A and then ACC_CFO.dta for the main and online-appendix tables, including Table A8's 2019 lead CFO sourced from the pre-cut fyear 2020 row.
5. Retain the authored sample, filters, sum(...,0) missing-value treatment, variables, estimators, appendix alternatives and all figure/table branches.

Validation to perform later:

- For a future authorized run, verify the two SAS-produced Stata datasets exist with expected fields before Tables.do consumes them and that the SAS figure outputs are produced.
- After Tables.do, verify the nine main and nine appendix workbook outputs and compare their names/locations with the supplied code and paper table map.
- Record actual commands, working directories, exit status, separate output streams and generated-file hashes for the future execution record; execution remains unverified in this assessment.

### A_SAS_STAT_SETUP: Confirm SAS/STAT capability for the supplied PROC REG annual regressions.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_SAS_STAT
Evidence: E_SAS_ANNUAL_EXPORT, E_ENVIRONMENT

Preparation / proposed procedure:

1. Check the intended host's installed SAS software inventory or entitlement metadata for SAS/STAT; do not start a SAS process, run a PROC REG example, or install anything during this assessment.
2. Keep the five supplied PROC REG specifications unchanged.

Validation to perform later:

- Record positive component availability from bounded host metadata before a separately authorized complete run; otherwise keep status unverified without inferring a license barrier.

### A_SAS_ACCESS_PCFILES_SETUP: Confirm SAS/ACCESS Interface to PC Files capability for the supplied Stata-format exports.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_SAS_ACCESS_PCFILES
Evidence: E_SAS_STATA_EXPORTS, E_ENVIRONMENT

Preparation / proposed procedure:

1. Check the intended host's installed SAS software inventory or entitlement metadata for SAS/ACCESS Interface to PC Files; do not start SAS, try DBMS=STATA, or install anything during this assessment.
2. Retain both author-specified PROC EXPORT DBMS=STATA handoffs and their output locations.

Validation to perform later:

- Record positive component availability from bounded host metadata before a separately authorized complete run; otherwise keep status unverified without inferring a license barrier.


## Remaining issues and prerequisites

- I_MISSING_MACROS [unresolved; full_pipeline]: Main_Code.sas includes macros/winsor.sas and macros/ind_ff48.sas, neither of which is in the frozen package inventory. These definitions are required to preserve the winsorization and FF48 industry assignment used by the investment-SG&A and final dataset branches.
- I_WRDS_MAPPING [preparation; full_pipeline]: Routine choice/configuration between the author WRDS SAS/CONNECT transfer route (using host-platform configured session librefs, not guessed names) and local same-product files staged into the code's relative Data/Comp, Data/CRSP and Data/Fama_French libraries. The local path requires bypassing only the remote signon/PROC DOWNLOAD block; input fields/history remain separately assessed. This is not a missing scientific definition, and no WRDS account barrier is inferred.
- I_MISP_SCHEMA [unresolved; full_pipeline]: The MISP import maps the imported fields _, var3 and var5 to permno, yyyymm and misp. The supplied text does not establish the source header/column contract or date/identifier compatibility; retain the published score branch without substituting another measure.
- R_COMPUSTAT_FUNDA [undetermined]: Compustat annual Funda panel for the selected accounting fields and the source-relative 1963 lag / 2020 lead CFO records used before the final 1964–2019 sample cut.
- R_CRSP_CCM [undetermined]: CRSP/Compustat CCM linktable required to map GVKEY firm-years to LPERMNO under the authored link-type, primary-link and link-date restrictions.
- R_CRSP_MSF [undetermined]: CRSP MSF monthly stock-return records required to construct delisting-adjusted returns, annual standard-deviation risk and forward factor-model alpha for the mispricing/risk branch.
- R_CRSP_MSEDELIST [undetermined]: CRSP MSEDELIST delisting returns are jointly needed with MSF returns for the authored adjusted-return construction.
- R_FF_MONTHLY [undetermined]: Fama-French monthly factors are required for the three- and four-factor alpha branch feeding Table A7.
- R_MISP [undetermined]: Stambaugh, Yu, and Yuan MISP ranking file required by the Table A7 MISP branch; preserve the separate alpha and return-risk branches as well.
- S_SAS [unverified]: Main_Code.sas requires the SAS Foundation runtime and procedures including SQL, SORT, IMPORT, EXPORT, RANK, MEANS and SGPLOT. The supplied environment probe could not initialize TKELS, so SAS runtime/component availability remains unverified; this does not establish a missing license or entitlement. PROC REG requires the separately recorded SAS/STAT capability; DBMS=STATA export requires SAS/ACCESS Interface to PC Files. SAS/CONNECT is required only if selecting the author WRDS remote-transfer route; local staged inputs do not require SAS/CONNECT.
- S_OUTREG2 [preparation_required]: Tables.do invokes outreg2 for the summary and regression workbook exports. The supplied software probe did not find outreg2 in the checked default or shared Stata adopaths; enable the author command in a permitted Stata add-on path before attempting the full table program.
- S_SAS_STAT [unverified]: Main_Code.sas uses PROC REG for the by-year CFO regressions that produce annual_sample and Annual_ACC_CFO.dta. SAS/STAT is required for this supplied full workflow; its installed capability is unverified, with no license-absence inference.
- S_SAS_ACCESS_PCFILES [unverified]: Main_Code.sas exports ACC_CFO.dta and Annual_ACC_CFO.dta using PROC EXPORT DBMS=STATA, requiring SAS/ACCESS Interface to PC Files. Installed capability is unverified; no license-absence inference is made.

## Review notes

- The supplied full workflow consists of SAS Main_Code.sas followed by the independent Stata Tables.do program. SAS also produces Figures 1A–1D and Figure 2; Stata produces nine main and nine online-appendix workbooks. No analysis_only scope is supported because the identifier workbook is a GVKEY list, not an analysis panel.
- All 18 frozen dependency IDs remain reviewed. Remote/local company and annual history roles are separate; local Data/Comp/company.sas7bdat is a downloaded/staged handoff from the company source requirement. ACC_CFO.sas7bdat, ACC_CFO.dta, Annual_ACC_CFO.dta and annual_sample.sas7bdat are generated workflow handoffs.
- The frozen catalog lists exact COMP.COMPANY, COMP.FUNDA, CRSP.CCMXPF_LINKTABLE, CRSP.MSF, CRSP.MSEDELIST and FF.FACTORS_MONTHLY candidates with selected fields. A bounded COMP.COMPANY probe verifies the local entity lookup is readable with GVKEY/SIC; its original generic coverage_verified=false is retained as a one-row probe limit, not an annual history or access/schema barrier. Full Funda-key/sample-fidelity comparison is contextual output QA.
- The catalog schema assigns SIC to COMP.COMPANY (GVKEY/SIC) and shows SICH, not SIC, in COMP.FUNDA. This supports the supplied unqualified SIC as company.SIC; no annual SICH source or historical SIC series is substituted or required.
- The final sample remains fyear 1964–2019. The supplied pre-cut comp9/comp10 joins need 1963 for the earliest lag and 2020 for lead CFO on 2019 Table A8 rows. Explicit sum(...,0) terms permit missing R&D/advertising lag terms, so no extra earlier years are needed solely to fill them.
- Source acquisition may use the host-configured WRDS transfer route or local same-product candidates staged under relative Data/Comp, Data/CRSP and Data/Fama_French paths; only the remote route needs SAS/CONNECT. Local file readability/history and most population/period compatibility remain unverified; no access barrier is inferred.
- SAS Foundation, SAS/STAT and SAS/ACCESS Interface to PC Files are unverified; SAS/CONNECT is conditional on remote transfer. Stata 18, reghdfe 6.12.3 and ftools 2.49.1 are available, while outreg2 requires setup. The exact macros, MISP source header/field mapping and other specified data/coverage limits remain unresolved. No author code or statistical workflow was executed and execution remains unverified.
