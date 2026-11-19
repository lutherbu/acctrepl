# Patch proposal: jar-648dfc21b67d

The effect of credit ratings on disclosure: Evidence from the recalibration of Moody’s municipal ratings

DOI: 10.1111/1475-679X.12307

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied preparation and companion-analysis workflow: SDC issuer/bond/underwriter preparation; MSRB disclosures; SAS main sample and retail/yield/Amihud analyses; independent Single Audit link; four page-length stages; and the supplied 11_gsz.do analysis ending in xtreg. Identifier.dta is only a cusip-year list, not analysis data. No analysis-only bypass is supported.

Entry points: `01_sdc_bond.R`, `01_sdc_issuer.R`, `02_sdc_processing.do`, `03_disclosures.do`, `04_main_sample.sas`, `05_retail_trades.sas`, `06_underwriters_2.R`, `07_bond_yield.sas`, `08_info_asym.sas`, `09_SingleAudit.sas`, `10_page_length_step1.do`, `10_page_length_step2.R`, `10_page_length_step3.R`, `10_page_length_step4.R`, `11_gsz.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 3/12307 - The-effect-of-credit-ratings-on-disclosure-Evidence-from-the-recalibration-of-Moodys-municipal-ratings/gsz-datasheet-and-code.zip",
      "sha256": "89fae98e99b46fcf7a7dd17361ff134811f08367032cf8efc0da4484d231b92e"
    },
    {
      "path": "JAR-Volume 58/Issue 3/12307 - The-effect-of-credit-ratings-on-disclosure-Evidence-from-the-recalibration-of-Moodys-municipal-ratings/gsz-online-appendix.pdf",
      "sha256": "6945cbb412e9e609a2108120913f6f31afb6b07fd48cae8a4d151c67c352bdc6"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "82304c1f979dcf401aaa150004584dd7a57ea5cc026e14491496990bc9fe7dce"
}
```

## Proposed actions

### A_SDC_FORMAT_STAGE: Stage the two R CSV products into the DTA formats named by the Stata consumers after choosing the project root.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_SDC_FORMAT_HANDOFF
Evidence: E_01_ISSUER_OUTPUT, E_01_BOND_OUTPUT, E_02_SDC_INPUT, E_11_SDC_BOND

Preparation / proposed procedure:

1. Run the supplied issuer and bond R exporters only in a later authorized execution step after the raw SDC source and path configuration are established.
2. Import SDC_IssuerSaleDate_19902014.csv and SDC_BondSaleDate_19902014.csv using a deterministic CSV reader and save DTA files with the names expected by 02_sdc_processing.do and 11_gsz.do.
3. Compare output headers and field types with the actual variables used in each consumer; do not infer compatibility from filenames.

Validation to perform later:

- Check both DTA files open with Stata and contain the required issuer/bond IDs, sale dates, ratings, issue amount and maturity fields.
- Check row counts and key uniqueness against the R CSV products before running downstream source.

### A_ALIGN_ROOTS: Map every source path onto one job-local relative project root for a working copy.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_STAGE_PATH_ORDER
Evidence: E_03_ROOT_OVERRIDE, E_03_DUP_READ_PATH, E_03_EVENT_READ, E_04_MAIN_OUTPUT, E_10_STEP1_SAMPLE, E_10_STEP1_TEMPMACRO, E_11_PATH, E_WORKFLOW_TRACE, E_09_PATH_MACRO

Preparation / proposed procedure:

1. Use the current job-local working directory as the root (relative path "."), compatible with the documented wrapper use of relative or [redacted-path-d4d794b1a029] paths; create the expected tree there only in a later authorized preparation step.
2. Map Rawdata/data_comp1990..data_comp2014 for the SDC R inputs; Rawdata/SDC for SDC CSV/DTA intermediates; Rawdata/Timeliness for disclosure DTA, XML links and page-length files; Rawdata/Economic_Characteristics for the four macro sources; Analysis/Round 2 new and Analysis/Round 3; Data_JG; Rawdata/SingleAuditRelated/SingleAudit; and Single Audit UROP.
3. In a separate working copy, replace the Dropbox, [redacted-path-7894ed24d312] and [redacted-path-b2f494cdd820] roots in the supplied programs with paths under that tree. Set Stata current directories explicitly; give SAS inputs/outputs explicit relative paths and a stage-local root.
4. Make 03 financial and event branches read/write cd files under the same Timeliness root. Point 04 output and all 05/07/08/10/11 sample consumers to Analysis/Round 2 new.
5. Point 11 reads to Round 2 new outputs, Rawdata/SDC and Rawdata/Timeliness while retaining its Round 3 cwd for relative temporaries. Point 10 step1 explicitly to Round 2 sample, Round 3 tempmacro/tempunderwriter, and Rawdata/Timeliness.
6. Replace both 09 Single Audit path macro definitions with the same job-local relative root and host-compatible separators.

Validation to perform later:

- Statically confirm every producer and consumer resolves to the same normalized relative path before running.
- After a later authorized run, verify each named intermediate exists at its agreed location and has the consumer-required format/schema.

### A_PAGE_LENGTH_PATH: Align the two supplied page-length PDF roots under the same relative project tree.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_PAGE_LENGTH_HANDOFF
Evidence: E_10_STEP3_OUTPUT, E_10_STEP4_INPUT, E_10_STEP4_OUTPUT, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Set the shared PDF destination to Rawdata/Timeliness/Financial Statement Files under the job-local root.
2. Point 10_page_length_step3.R copy output and 10_page_length_step4.R setwd to that same folder; preserve fileidentifier.pdf names.
3. Point the link DTA, annual disclosure DTA and outputs to the same Rawdata/Timeliness root.

Validation to perform later:

- For one bounded identifier, confirm step 3 target and step 4 lookup resolve to the same file before a full authorized run.
- After execution, confirm every matched fileidentifier has a page-count result or an explicit missing-PDF value.

### A_ALT_RETAIL_INPUT: Resolve the distinct alternative-control trade input required by 11_gsz.do.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_MISSING_ALTCONTROL_PRODUCER, R_ALT_RETAIL_TRADES
Evidence: E_05_OUTPUT, E_11_TRADES, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Locate an already-authorized author-prepared RetailTradesAltControl20190530.dta or obtain its exact construction and variable/selection contract.
2. Keep the alternate file distinct from RetailTrades20190530.dta unless source documentation proves identical populations and construction.
3. If the intended branch has been removed from the author design, obtain that specification before changing the source.

Validation to perform later:

- Verify the table is municipal secondary-trade data and contains every field referenced by the alternative-control code.
- Compare the control population and key grain to the author specification before use.

### A_SDC_DATA_SOURCE: Confirm an authorized SDC municipal issue extract matching the author preprocessing contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SDC_PLATINUM
Evidence: E_DS_SCOPE, E_01_ISSUER_INPUT, E_06_SDC_INPUT, E_CATALOG_SHORT_ALIASES

Preparation / proposed procedure:

1. Identify the authorized author-prepared SDC municipal extract or licensed SDC route already available to the project.
2. Confirm annual data_comp1990..data_comp2014 coverage and all fields used by issuer, bond and underwriter source branches.
3. Do not substitute the frozen catalog SDC M&A/JV families.

Validation to perform later:

- Check the extract contains the selected SDC fields and date range before running the supplied R preparation stages.

### A_DISCLOSURE_DATA: Prepare the annual financial and event disclosure input series used by 03_disclosures.do.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_MSRB_DISCLOSURES
Evidence: E_PUBLIC_EMMA_DISCLOSURE, E_03_DISCLOSURES_INPUT, E_03_EVENTS_OUTPUT

Preparation / proposed procedure:

1. Use an already-authorized author-prepared cd2009.dta through cd2014.dta series, or establish a permitted source route to the corresponding municipal financial/event disclosure records.
2. Confirm annual file schema for CUSIP, submission ID, categories, submission timestamp, ending date and period type.
3. Do not assume the public EMMA page establishes bulk historical XML or DTA availability.

Validation to perform later:

- After path staging, verify 2009–2014 file coverage and fields for both financial and event branches.

### A_MERGENT_CIS_DATA: Confirm the author Mergent Municipals recalibration/CIS table and field contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_MERGENT_CIS
Evidence: E_DS_MERGES, E_04_MERGENT_INPUT, E_CATALOG_SHORT_ALIASES

Preparation / proposed procedure:

1. Identify the author Mergent Municipals table already authorized for the project and its vintage and units.
2. Confirm CUSIP, recalibration date, rating and upgrade fields expected by 04_main_sample.sas.
3. Do not substitute FISD corporate issue/issuer/rating tables.

Validation to perform later:

- Check the table fields and issuer-year merge keys against the SAS joins before running the sample stage.

### A_TREATMENT_INFO_DATA: Identify and validate the author treatment_info SAS table consumed by 04_main_sample.sas.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_TREATMENT_INFO
Evidence: E_04_TREATMENT_INPUT, E_DS_MERGES

Preparation / proposed procedure:

1. Locate the project-prepared treatment_info.sas7bdat or obtain its exact construction/field mapping and period.
2. Confirm issuer CUSIP, considered/treated indicators, treatment timing and rating fields used by the SAS merge.

Validation to perform later:

- Check key uniqueness and issuer-year coverage before the main SAS merge.

### A_MSRB_TRADE_DATA: Confirm a municipal secondary-market trade source for the retail, yield and information-asymmetry branches.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_MSRB_TRADES
Evidence: E_PUBLIC_MSRB_TRADES, E_05_TRADE, E_07_YIELD, E_08_AMIHUD, E_CATALOG_SHORT_ALIASES

Preparation / proposed procedure:

1. Use the already-authorized author MSRB trade file or confirm institutional academic access to the exact MSRB/WRDS municipal trade product.
2. Preserve 2006-06 through 2014-06 history and the trade, price, size, coupon, yield, maturity, dated-date and time fields used by the three SAS branches.
3. Do not substitute corporate TRACE or non-municipal transaction tables.

Validation to perform later:

- Verify trade table fields, date coverage, municipal security identifiers and yearly keys before the SAS companion branches.

### A_SINGLE_AUDIT_DATA: Resolve the prepared SingleAuditTemp.dta input and its upstream producer; assess the readable local FEED28 candidate as a possible compatible route.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_SINGLE_AUDIT, I_SINGLEAUDIT_INPUT_PRODUCER
Evidence: E_PROBE_AUDIT_FEED28, E_09_SINGLEAUDIT, E_APP_SINGLEAUDIT, E_09_PATH_MACRO, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Use the source comment’s stated input construction (SingleAudit20052016) to locate the author-prepared SingleAuditTemp.dta or exact producer/specification; none of the 15 supplied programs produces it.
2. Compare the local FEED28 candidate product, source population and annual history with that author definition.
3. Map AUDITEE_NAME, STATE and FY_END_DATE to the expected fields; retain the code report-year filter and effective date range.
4. Use the local candidate only if the product/coverage contract is established; otherwise the prepared author input remains required.

Validation to perform later:

- Verify required fields, date types, state/name population and report-year coverage before producing the issuer-year link.

### A_AUDIT_CROSSWALK_DATA: Prepare the manual SingleAuditMatch issuer-name/state crosswalk used by the standalone link branch.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_AUDIT_CROSSWALK
Evidence: E_09_SINGLEAUDIT, E_APP_SINGLEAUDIT

Preparation / proposed procedure:

1. Locate the already hand-verified author crosswalk or its documented review procedure.
2. Preserve the paired SDC issuer and audit auditee names plus state key fields.

Validation to perform later:

- Check crosswalk key fields and duplicate issuer/state matches before the SAS merge.

### A_XML_LINK_ARCHIVE: Establish a permitted route to the author monthly municipal continuing-disclosure XML files and yearly links.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_MSRB_XML_LINKS
Evidence: E_PUBLIC_EMMA_DISCLOSURE, E_10_STEP2_XML, E_10_STEP2_OUTPUT

Preparation / proposed procedure:

1. Identify an already-authorized monthly XML archive or documented EMMA data delivery route for 2009–2015.
2. Confirm the parser’s submission identifier, transaction timestamp, fileidentifier, year and month fields.
3. Do not infer bulk historical rights or retrieve documents during this assessment.

Validation to perform later:

- Check the XML layout and monthly archive coverage, including the source skip of January–May 2009.

### A_PDF_ARCHIVE: Establish the municipal disclosure PDF archive keyed by fileidentifier for the page-length branch.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_MSRB_PDFS
Evidence: E_PUBLIC_EMMA_DISCLOSURE, E_10_STEP3_PDF, E_10_STEP4_INPUT

Preparation / proposed procedure:

1. Use an already-authorized author PDF archive or confirm the permitted EMMA route for the linked fileidentifier documents.
2. Preserve the regression-sample PDF population and fileidentifier.pdf naming.

Validation to perform later:

- Check linked identifiers resolve to the expected municipal financial disclosure PDFs before page counting.

### A_MACRO_SERIES: Map the four official state macro series to the author files before calculating lagged macro controls.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_MACRO_GSP, R_MACRO_PCI, R_MACRO_HPI, R_MACRO_UNEMP
Evidence: E_PUBLIC_BEA_STATE_GDP, E_PUBLIC_BEA_STATE_PCI, E_PUBLIC_FHFA_HPI, E_PUBLIC_BLS_LAUS, E_11_MACRO

Preparation / proposed procedure:

1. Confirm the exact author file vintages and units for GSP and per-capita personal income; map the BEA state tables only after matching the intended measures.
2. Confirm the FHFA state purchase-only seasonally-adjusted quarterly index and BLS state unemployment measure/period against index_sa and unemploy fields.
3. Preserve the full source rows the code merges; average HPI and unemployment by state-year, shift source year by +1 and apply winsor2 cuts(1 99) as written.

Validation to perform later:

- Verify each source contains state/year plus required measure fields and overlapping coverage before merge.
- Check the transformed lag-year alignment and full-input winsorization against author file definitions; do not silently restrict inputs to 2009–2014.

### A_R_PACKAGES: Prepare missing R packages required by the explicitly loaded page-length scripts.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_R_XML, S_R_PLYR, S_R_RESHAKE2, S_R_PDFTOOLS
Evidence: E_R_PACKAGES, E_10_STEP2_XML, E_10_STEP4_INPUT

Preparation / proposed procedure:

1. Before an authorized run, add XML, plyr, reshape2 and pdftools to the selected R environment through the approved package-management path.
2. Keep foreign 0.8.90 as currently available.

Validation to perform later:

- Run requireNamespace/packageVersion for each explicit package in the same R runtime used for the scripts.

### A_WINSOR2: Provide the Stata winsor2 command invoked by 11_gsz.do.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_WINSOR2
Evidence: E_STATA_WINSOR2, E_11_MACRO

Preparation / proposed procedure:

1. Install or expose an authorized winsor2.ado in the Stata adopath before execution; no installation was made during assessment.

Validation to perform later:

- Run Stata which winsor2 and a bounded syntax check before running the author do-file.

### A_SAS_RUNTIME: Resolve the bounded SAS startup failure and confirm the SAS components used by the SAS branches.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_SAS
Evidence: E_ENVIRONMENT, E_04_SDC_INPUT, E_04_MAIN_OUTPUT

Preparation / proposed procedure:

1. Confirm SAS 9.4 starts with the documented no-DMS/work/autoexec options using the approved machine configuration.
2. Check that the runtime supports the author PROC IMPORT/EXPORT DTA, XLS/XLSX and SAS dataset paths; do not infer entitlement failure from TKELS diagnostics.

Validation to perform later:

- Record SAS runtime version and one-row format capability checks before any author program run.

### A_ORDERED_RUN: Run the repaired graph in producer order, retaining independent branches and actual cross-language handoffs.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_STAGE_PATH_ORDER, I_PAGE_LENGTH_HANDOFF
Evidence: E_WORKFLOW_TRACE, E_README_FLOW, E_README_COMPANIONS

Preparation / proposed procedure:

1. After all route, runtime and path prerequisites are resolved, execute 01_sdc_issuer.R and 01_sdc_bond.R; stage their CSV outputs to named DTA inputs.
2. Run 02_sdc_processing.do, then 03_disclosures.do, then 04_main_sample.sas after its SDC/disclosure/treatment/Mergent inputs exist.
3. Run 06_underwriters_2.R and 05_retail_trades.sas; run 07_bond_yield.sas and 08_info_asym.sas as separate companion analyses. Run 09_SingleAudit.sas independently after its macro/input context is established.
4. Run 10_page_length_step2.R before 10_page_length_step1.do. Run 11_gsz.do after its macro, trade, underwriter, disclosure, SDC and sample inputs exist; its tempunderwriter output is needed by 10 step1.
5. Run 10_page_length_step1.do, then 10_page_length_step3.R, then 10_page_length_step4.R after their link tables and one shared PDF root are confirmed.
6. Preserve the visible terminal xtreg output. Do not infer or fabricate paper-wide models or table exports absent from the 15 supplied programs.

Validation to perform later:

- Check each producer output’s existence, exact path, format, required fields, keys and target period before advancing to its consumer.
- Keep the Single Audit and page-length branches as standalone outputs unless a supplied downstream consumer is later identified.

### A_CAFR_LOOKUP_DATA: Provide or confirm the workbook read unconditionally by 03_disclosures.do.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_DISCLOSURE_LOOKUP
Evidence: E_03_CAFR_LOOKUP

Preparation / proposed procedure:

1. Stage OtherVoluntaryFinancialDisclosures.xlsx under the mapped Rawdata/Timeliness path expected by 03_disclosures.do.
2. Confirm it contains Sheet1 with othervoluntarydisclosure and CAFR fields and the expected CAFR coding.
3. Retain the workbook as an execution prerequisite even though tempCAFR.dta has no downstream reader in the supplied scripts.

Validation to perform later:

- Check the workbook sheet, column names, field types and distinct disclosure labels before running the Stata preparation program.


## Remaining issues and prerequisites

- I_SDC_FORMAT_HANDOFF [preparation; full_pipeline]: 01_sdc_issuer.R and 01_sdc_bond.R write CSV files, while 02_sdc_processing.do opens the issuer output with Stata use and 11_gsz.do expects the bond output as DTA. This is a known CSV-to-DTA staging task; the supplied code does not perform it. Confirm the converted headers/types against the consumers and keep the agreed source root consistent.
- I_STAGE_PATH_ORDER [preparation; full_pipeline]: The producer-consumer graph spans R, Stata and SAS. The supplied code uses multiple machine roots and inconsistent working directories: 03 switches from Timeliness to Documents/Temp and then reads Windows paths; 04 writes sample data to Round 2 new; 10 step1 reads sample from Analysis and inherits cwd for tempunderwriter; 11 starts in Round 3 while reading products written to Round 2 new. The root layout and order are known and can be staged coherently in a job-local relative tree.
- I_MISSING_ALTCONTROL_PRODUCER [unresolved; full_pipeline]: 11_gsz.do actively reads RetailTradesAltControl20190530.dta as a distinct alternative-control table. The supplied 05_retail_trades.sas exports RetailTrades20190530.dta only; no producer for the alternative-control table or its field/selection contract is supplied.
- I_PAGE_LENGTH_HANDOFF [preparation; full_pipeline]: 10_step3 copies fileidentifier PDFs to Dropbox Rawdata/Timeliness/Financial Statement Files, while 10_step4 counts PDFs from a separate removable-volume Financial Statement Files directory. The exact same matched PDF names can be placed under one job-local relative folder and used by both stages.
- I_SINGLEAUDIT_INPUT_PRODUCER [unresolved; full_pipeline]: 09_SingleAudit.sas comments that SingleAuditTemp.dta is created in the main do file using SingleAudit20052016, but no program among the 15 supplied entry points creates SingleAuditTemp.dta. The prepared input or an exact compatible producer/source contract is still required for this standalone branch.
- R_SDC_PLATINUM [undetermined]: Thomson Reuters SDC Platinum municipal issuance records loaded as data_comp1990 through data_comp2014; the bond and issuer preparation branches and underwriter branch require the product fields used in their code.
- R_MSRB_DISCLOSURES [undetermined]: Annual MSRB financial and event disclosure datasets cd2009.dta through cd2014.dta, including the consumed CUSIP, submission, category, date, period, and ending-date fields.
- R_DISCLOSURE_LOOKUP [undetermined]: OtherVoluntaryFinancialDisclosures.xlsx on Sheet1 with othervoluntarydisclosure and CAFR columns, read by 03_disclosures.do to create tempCAFR.dta. The supplied program does not consume tempCAFR later, but the workbook import is unconditional and is a prerequisite for executing 03 as written.
- R_MERGENT_CIS [undetermined]: Mergent Municipals scale-change product loaded as gsz.mergent_cis_data, with rating, upgrade amount, CUSIP and recalibration-date fields consumed in 04_main_sample.sas.
- R_TREATMENT_INFO [undetermined]: Prepared treatment_info SAS table with CUSIP and treatment-period/rating fields consumed by 04_main_sample.sas.
- R_MSRB_TRADES [undetermined]: MSRB municipal secondary-market trades table msrb_20060630to20140603_20180319, with the CUSIP, trade type, trade size, trade/date/time, maturity, yield, price, coupon and dated-date fields used in 05, 07 and 08.
- R_SINGLE_AUDIT [undetermined]: Author-prepared SingleAuditTemp.dta read by the standalone 09_SingleAudit.sas branch; its upstream file definition and source-population equivalence need confirmation.
- R_AUDIT_CROSSWALK [undetermined]: Manual SingleAuditMatch.dta issuer-name/state crosswalk used by 09_SingleAudit.sas; requires the hand-verified issuer and state mapping.
- R_MSRB_XML_LINKS [undetermined]: MSRB continuing-disclosure monthly XML submissions and their yearly link exports, for 2009–2015, used by the four-stage page-length branch.
- R_MSRB_PDFS [undetermined]: MSRB municipal financial-statement PDF files indexed by fileidentifier for the page-length branch.
- R_MACRO_GSP [undetermined]: BEA state Gross State Product source with state, year and gsp fields; the main do-file shifts source years forward and applies full-input winsorization.
- R_MACRO_PCI [undetermined]: BEA state per-capita income source with state, year and percapitaincome fields; the main do-file shifts source years forward and applies full-input winsorization.
- R_MACRO_HPI [undetermined]: FHFA state HPI workbook with state, yr, qtr and index_sa fields, averaged by state-year before the year shift and winsorization.
- R_MACRO_UNEMP [undetermined]: BLS state unemployment source with state, year and unemploy fields, averaged by state-year before the year shift and winsorization.
- R_ALT_RETAIL_TRADES [undetermined]: Distinct RetailTradesAltControl20190530.dta read by 11_gsz.do; no supplied producer or construction/field contract is identified.
- S_SAS [unverified]: The documented SAS runtime path is present in machine instructions, but a bounded startup probe failed with a TKELS Launch Service Load Failure; this does not prove a missing license.
- S_WINSOR2 [preparation_required]: 11_gsz.do invokes winsor2 for four macro variables; helper lookup did not find it in checked Stata adopaths.
- S_R_XML [preparation_required]: Explicitly loaded by 10_page_length_step2.R and unavailable in the package check.
- S_R_PLYR [preparation_required]: Explicitly loaded by 10_page_length_step2.R and unavailable in the package check.
- S_R_RESHAKE2 [preparation_required]: Explicitly loaded by 10_page_length_step2.R and unavailable in the package check.
- S_R_PDFTOOLS [preparation_required]: 10_page_length_step4.R explicitly loads pdftools; it is unavailable in the package check.

## Review notes

- The 15 supplied programs, README, 130-line datasheet and 1,521-line appendix text were reviewed. The frozen source-notes file was used only as a lead, not assessment evidence.
- The source graph has 47 frozen dependency IDs and every ID is reviewed below. workflow_trace.json records the cross-language order, current directories, exact named intermediates and path gaps.
- A self-written Stata 18 command accepts both the visually open and explicitly closed fitch label forms and returns the same stored label; no label syntax issue or repair is proposed.
- The Single Audit producer is a standalone supplied branch with required raw input and manual crosswalk. There is no supplied main-do-file consumer, so no missing merge hook is asserted.
- 11_gsz.do contains an actual terminal xtreg call with log output. The assessment does not infer paper-wide estimator/table code absent from the supplied package.
- Identifier.dta is a one-row-readable CUSIP/year identifier file, not an analysis dataset; no program reads it. The local FEED28 candidate is readable at one row but its author product/population/history match remains unverified.
- The OtherVoluntaryFinancialDisclosures.xlsx workbook remains a mandatory input for executing 03_disclosures.do as written; its tempCAFR.dta output has no later reader in the 15 supplied programs.
