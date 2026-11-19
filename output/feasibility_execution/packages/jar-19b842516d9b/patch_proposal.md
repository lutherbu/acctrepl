# Patch proposal: jar-19b842516d9b

What Happens to Partners Who Issue Adverse Internal Control Opinions?

DOI: 10.1111/1475-679X.12597

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied Stata driver and SAS supplement, including the initial 2015+ construction, later 2022 updates and SAS ownership/segment supplement. The two packaged DTA files are identifier lists, not author-prepared analysis data. All supplied branches are retained; mandatory source, runtime and cross-language producer contracts remain incomplete.

Entry points: `BCRW JAR Full Output 2024 11 29.do`, `Institutional_Ownership_Segments_Code.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 2/12597 - What-Happens-to-Partners-Who-Issue-Adverse-Internal-Control-Opinions/bcrw-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "2862dde04e2213fd1c11c8cc496c3857ce46906ac98154410ee9e068be20d633"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "a49efb7ba509e05cfeeeb43d5d73530b4b76f2efdeb9cccc3441fc52c341976f"
}
```

## Proposed actions

### A_FORM_AP: Acquire the documented public Form AP CSV and prepare the fields used by the Stata partner panel. The public product and field mapping are supported; early-year coverage and amendment handling remain preparation checks.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_FORM_AP
Evidence: E_PCAOB_AUDITORSEARCH, E_PCAOB_DICTIONARY, E_PCAOB_EFFECTIVE_DATE, E_STATA_FORM_AP, E_STATA_FORM_AP_CUTOFF, E_STATA_PARTNER_LAG_WINDOW, E_STATA_PARTNER_SAMPLE_WINDOW

Preparation / proposed procedure:

1. Obtain the current PCAOB AuditorSearch CSV and retain its dictionary/version with the downloaded data.
2. Map the documented columns to the source fields and preserve the issuer/US filters, fiscal-year shift and CIK/engagement-partner keys.
3. The source retains FY2015 onward and uses lagged partner measures in regressions after 2015; the later branch adds FY2022. Check coverage of FY2015–2016 against the January 31, 2017 report-issue effective date and record any actual gap without presuming absence.
4. Preserve the source duplicate/amendment handling and the initial/update branch order.

Validation to perform later:

- Check header mapping and partner-ID/CIK types against the supplied import.
- Check observed coverage for the source-required FY2015–FY2022 window, especially early periods whose report dates may precede the effective date.
- Check that amendments and duplicates follow the source’s retain/drop behavior before a separately authorized run.

### A_AA_FEES: Prepare the initial and 2022-update fee branches against the readable FEED03 candidate. The core source fields, restatement flag and currency are confirmed; the six company-class filters remain an exact field-mapping gap.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_AA_FEES_2023
Evidence: E_PROBE_FEED03_UNION, E_COMPONENT_FIELD_COMPARE, E_STATA_FEES23, E_STATA_UPDATE_FEES, E_CATALOG_INPUT_PRODUCTS

Preparation / proposed procedure:

1. Use the FEED03 candidate for COMPANY_FKEY, AUDITOR_FKEY, FISCAL_YEAR_ENDED, AUDIT_FEES, RESTATEMENT and CURRENCY_CODE_FKEY, which the bounded union read confirms.
2. Resolve the six source CO_IS_* class flags against the author input/schema before treating the fee contract as complete; their exact names are not in the frozen catalog, which does not prove absence from a delivered extract.
3. Preserve the original-observation/USD/company filters, fiscal-year rule, company-year deduplication and separate 2022 update append.

Validation to perform later:

- Check exact mappings for the six company-class fields before preparing the filtered source.
- Check the source fee/year/auditor keys and preserve the initial and update transformations.
- Check update-year alignment and the source’s existing 2021–2022 growth stage during ordinary data preparation.

### A_AA_OPINIONS: Prepare both opinion aliases from the readable FEED34 candidate. Its six source-consumed fields match the supplied roles; the “revised” product label alone is not a mismatch.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_AA_OPINIONS_2023
Evidence: E_PROBE_FEED34, E_COMPONENT_FIELD_COMPARE, E_STATA_OPINIONS23, E_STATA_UPDATE_OPINIONS, E_CATALOG_INPUT_PRODUCTS

Preparation / proposed procedure:

1. Map both author aliases to the same FEED34 opinion role by company, auditor, fiscal-year-end, going-concern, auditor-country and auditor-city fields.
2. Preserve the source USA/city filters, May-31 fiscal-year shift, company/auditor/year deduplication and separate FY2022 append.
3. Keep the original fee/opinion merge keys and the source branch order.

Validation to perform later:

- Check the prepared columns and CIK/auditor/fiscal-year merge keys against the supplied source.
- Check the FY2022 append preserves prior rows and applies the same field transformations.
- Retain a definition concern only if a concrete unsupported source field or meaning is identified; do not gate on the table label alone.

### A_AA_404: Prepare both SOX 404 branches using the FEED11 candidate’s confirmed core fields while resolving the six source company-class filters that do not appear as exact frozen-catalog variables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_AA_404_2023
Evidence: E_PROBE_FEED11, E_COMPONENT_FIELD_COMPARE, E_STATA_40423, E_STATA_UPDATE_404, E_CATALOG_INPUT_PRODUCTS

Preparation / proposed procedure:

1. Use the confirmed company, opinion type, original/restatement indicator, fiscal-year-end and weakness-count fields.
2. Resolve mappings for the six source CO_IS_* company-class filters; catalog nonmatches are a specific schema gap, not evidence of product or license absence.
3. Preserve the auditor-opinion/original-observation filters, fiscal-year shift, deduplication and later FY2022 update.

Validation to perform later:

- Check the six company-class mappings against the actual delivered source before applying those filters.
- Check the field/date transformations and CIK/FYEAR alignment for both branches.
- Preserve the original panel and append order in a future authorized preparation.

### A_AA_RESTATE_MAIN: Prepare the main announcement/outcome restatement role from the readable FEED39 candidate. Its nine required fields are confirmed; keep this role distinct from the later date-window input.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_AA_RESTATEMENTS_MAIN
Evidence: E_PROBE_FEED39_UNION, E_COMPONENT_FIELD_COMPARE, E_STATA_RESTATE23, E_CATALOG_INPUT_PRODUCTS, E_CATALOG_INPUT_FIELDS

Preparation / proposed procedure:

1. Map the main source fields for company/form, file date, accounting/fraud, adverse/improves and begin/end dates to FEED39.
2. Preserve the supplied filing-date announcement join, 8-K big-R rule, and outcome fields.
3. Treat old-alias/vintage and observed-period reconciliation as preparation, not as a second unavailable raw product.

Validation to perform later:

- Check source keys and date types against the supplied Compustat announcement-window join.
- Check that the main role retains its announcement/outcome fields and remains separate from the updated correctness-test panel.

### A_AA_RESTATE_UPDATED: Prepare the later correctness-test role from the readable FEED39 candidate using its distinct begin/end-date transformation.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_AA_RESTATEMENTS_UPDATED
Evidence: E_PROBE_FEED39_UNION, E_COMPONENT_FIELD_COMPARE, E_STATA_RESTATE24, E_CATALOG_INPUT_PRODUCTS, E_CATALOG_INPUT_FIELDS

Preparation / proposed procedure:

1. Map company/form, accounting/fraud and begin/end-date fields to the FEED39 candidate confirmed by the bounded union read.
2. Preserve the later branch’s 8-K indicator and 1–3 year windows.
3. Keep this date-window input separate from the initial announcement/outcome role even though the raw product and fields overlap.

Validation to perform later:

- Check begin/end-date types and keys against the supplied correctness-test branch.
- Confirm the update preparation does not overwrite the initial announcement panel.

### A_AUDCHANGES: Resolve the specific FEED02 mapping for CURR_AUDSNC_DATE, which the Stata source uses but the exact frozen catalog does not list. The previous bounded read failure is preserved and is not retried.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_AA_AUDCHANGES_2024
Evidence: E_CATALOG_INPUT_PRODUCTS, E_CATALOG_INPUT_FIELDS, E_COMPONENT_FIELD_COMPARE, E_STATA_AUDCHANGES

Preparation / proposed procedure:

1. Use the existing catalog candidate/field mapping for the other source company, event, name and date fields.
2. Resolve CURR_AUDSNC_DATE against the delivered schema or an exact documented field mapping; do not infer product absence from the catalog miss or prior read failure.
3. Preserve the source benefit-plan/merger filters and both rangejoin branches once the specific field mapping is established.

Validation to perform later:

- Check exact field name/meaning and date type for CURR_AUDSNC_DATE before a future Stata run.
- Check the source keys and ±365-day join logic in a later authorized preparation.
- Do not retry the failed bounded FEED02 read.

### A_COMPUSTAT_FUNDA: Prepare the annual FUNDA input using the 31 source-consumed fields confirmed by the bounded union read; keep four exact control-field mappings unresolved.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMPUSTAT_FUNDAMENTALS
Evidence: E_PROBE_FUNDA_UNION, E_COMPONENT_FIELD_COMPARE, E_STATA_COMPUSTAT23, E_STATA_COMPUSTAT_FIELDS, E_CATALOG_INPUT_PRODUCTS, E_CATALOG_INPUT_FIELDS

Preparation / proposed procedure:

1. Use the accessible FUNDA columns for CIK/GVKEY/DATADATE/FYEAR, accounting, market and cash-flow controls as confirmed by the one-row union read.
2. Resolve IPODATE, SIC, IS_ACCEL_FILER and ACCEL_FILER_LARGE against the delivered schema or a documented source mapping; the exact frozen-catalog comparison does not list these names and does not prove they are absent.
3. Preserve the source duplicate keys and lead/lag transformations; keep the separately derived firm-age route independent.

Validation to perform later:

- Check exact names/meanings for the four unmapped fields before constructing all controls.
- Check CIK/GVKEY/date alignment and the source’s existing duplicate/lag behavior during ordinary preparation.
- Do not require an independent full-data reconstruction or author-file row identity.

### A_COMPUSTAT_AGE: Construct the separately consumed age input from the compatible FUNDA CIK/FYEAR fields using the supplied minimum-FYEAR-by-CIK rule.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_COMPUSTAT_AGE
Evidence: E_PROBE_FUNDA_UNION, E_STATA_COMPUSTAT_AGE

Preparation / proposed procedure:

1. Use the bounded FUNDA read, which confirms CIK and FYEAR, as the field-compatible raw route.
2. Apply the source’s minimum FYEAR by CIK construction and existing age/log-age formulas.
3. Preserve the source merge/retention order; do not require author-vintage or full-row identity against the separately named age file.

Validation to perform later:

- Check that the prepared age output uses the supplied minimum-year formula and CIK key.
- Check the existing merge/retention behavior when preparing the prediction branch.

### A_SOX302: Prepare the FEED10 SOX 302 candidate using its confirmed company, period-end and effectiveness fields; retain the specific unmapped fiscal-year-end field.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_AA_SOX302
Evidence: E_PROBE_FEED10_PARTIAL, E_COMPONENT_FIELD_COMPARE, E_STATA_SOX302_FIELDS, E_CATALOG_INPUT_PRODUCTS, E_CATALOG_INPUT_FIELDS

Preparation / proposed procedure:

1. Use the exact FEED10 candidate row read to confirm COMPANY_FKEY, PERIOD_END_DATE_NUM and IS_EFFECTIVE.
2. Resolve the source FISCAL_YE field against the delivered schema or an exact documented mapping; its name is not in the frozen catalog variables.
3. Preserve ineffective-only, Q4 removal and May-31 alignment logic after the field contract is resolved.

Validation to perform later:

- Check FISCAL_YE field meaning and date type before source transformation.
- Check the Q4 and fiscal-year rules during future authorized data preparation.
- Do not infer product or license absence from the catalog nonmatch.

### A_MSA: Obtain or identify the author MSA crosswalk used by the supplied city_state merge; do not invent city mappings.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_MSA
Evidence: E_STATA_MSA

Preparation / proposed procedure:

1. Identify the source, schema and version of MSA.dta and retain its city_state-to-MSA mapping.
2. Preserve the code's manual missing-MSA additions as author-supplied mapping instructions.
3. Stage the crosswalk in the correct working directory for the relevant Stata branch.

Validation to perform later:

- Check the city_state key and mapped MSA fields against the code's merge contract.
- Check that required unmatched cities have an author-supported mapping before a separately authorized run.

### A_PREAICO: Resolve the mandatory pre_aicohistorytest input and its producer/schema before attempting the final prediction branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_PRE_AICO_HISTORY
Evidence: E_STATA_PREAICO

Preparation / proposed procedure:

1. Identify the producer or supplied location for pre_aicohistorytest.dta and the required CIK/FYEAR, auditor-switching, IC-audit and historical variables.
2. Confirm the panel period and two-prior-year restatement/history requirement referenced by the downstream code.
3. Retain the supplied prediction_model1 and following model stages once the input contract is established.

Validation to perform later:

- Check the input field/key/date contract against its downstream consumers without reconstructing undocumented variables.
- Confirm the producer stage precedes the existing prediction-model saves.

### A_STATA_SEGMENTS: Keep the verified raw WRDS_SEGMERGED component separate from the unresolved Stata Comp_seg20240321 producer/schema handoff.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_STATA_COMP_SEGMENTS, I_SEGMENT_HANDOFF
Evidence: E_PROBE_COMPSEG, E_STATA_SEGMENT_HANDOFF, E_SAS_SEGMENT_CHAIN, E_SAS_SEGMENT_A2, E_SAS_SEGMENT_EXPORT

Preparation / proposed procedure:

1. The SAS raw segment input and its five fields have a successful bounded read; use it in the supplied SAS stage as written.
2. Separately identify the producer for the Stata Comp_seg file and map its CIK, GVKEY, DATADATE, SRCDATE and STYPE contract.
3. Do not treat the SAS aggregate export as the Stata file without matching identifiers and construction.

Validation to perform later:

- Check the Stata Comp_seg producer and CIK/date mapping against its count logic.
- Preserve the native SAS and Stata stage order until the separate handoff is supported.

### A_STATA_IO: Resolve the producer and field/date mapping for ior_gvkeys_03282024.sas7bdat; the SAS InstOwn_03022023 output is not presumed equivalent.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_STATA_INST_OWNERSHIP, I_IO_HANDOFF
Evidence: E_STATA_IO_HANDOFF, E_SAS_OUTPUTS, E_SAS_IO_CONSTRUCTION

Preparation / proposed procedure:

1. Identify the producer for the exact Stata import file and confirm its ior, gvkey and datadate columns.
2. Map the source ownership measure and Compustat/security keys to the SAS IO_TimeSeries output only if definitions and date alignment match.
3. Keep the Stata import and SAS output as separate products until the producer relationship is evidenced.

Validation to perform later:

- Check schema, date mapping, gvkey construction and required coverage before the Stata merge.
- Preserve the existing IO construction and downstream merge without substituting a proxy.

### A_TFN_S34: Confirm whether the consolidated TFN.S34 candidate supplies the two distinct SAS type-1 metadata and type-3 holding roles.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_TFN_S34TYPE1, R_TFN_S34TYPE3
Evidence: E_CATALOG_TFN, E_CATALOG_TFN_FIELDS, E_SAS_TFN_TYPE1, E_SAS_TFN_TYPE3

Preparation / proposed procedure:

1. Confirm type partition, report-date/filing-date keys, manager identifiers, CUSIP/share fields and available history for both roles.
2. Preserve the first-filing-vintage selection and type-3 join/filter as written.
3. Use the current catalog candidate only if both complete source contracts are supported; otherwise identify the specific missing table/fields.

Validation to perform later:

- Check manager/report-vintage uniqueness and type-specific field mappings before preparing the SAS inputs.
- Check required historical periods without retrying the timed-out table probe or treating it as a data-absence result.

### A_CRSP_MSF: Prepare the readable CRSP.MSF source for the seven monthly fields selected by SAS. Period coverage is a future data-preparation check; macro construction remains a separate issue.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_CRSP_MSF
Evidence: E_PROBE_CRSP_MSF, E_SAS_CRSP_FIELDS

Preparation / proposed procedure:

1. Use the exact CRSP.MSF candidate and preserve PERMNO, DATE, PRC, RET, SHROUT, CFACPR and CFACSHR.
2. Check the required January 2015–December 2022 month range and quarter-end extraction during later data preparation.
3. Resolve the %crspmerge macro and MSE event product under their separate issue/requirement; do not hold the raw MSF source route on macro proof.

Validation to perform later:

- Check selected columns and required period coverage before a future run.
- Check quarter-end keys and price/share-factor alignment after the author macro context is available.

### A_CRSP_MSE: Identify the actual CRSP.MSE event-record product and the missing %crspmerge definition; the readable MSF and MSENAMES components remain independently credited.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CRSP_MSE, I_SAS_CRSPMERGE
Evidence: E_SAS_CRSP_FIELDS, E_PROBE_CRSP_MSF, E_PROBE_CRSP_MSENAMES, E_CATALOG_CRSP_FAMILIES

Preparation / proposed procedure:

1. Confirm the exact MSE event dataset and date/key contract expected by the supplied macro call.
2. Locate the macro definition through the supplied authorized SAS include/library context if present; the protected setup header remains opaque.
3. Keep MSENAMES name history and MSEDELIST delisting records separate unless the source field and product roles match.

Validation to perform later:

- Check MSE event fields against the macro output schema when the exact source and definition are available.
- Check monthly date alignment in future authorized preparation without retrying TFN or FEED02 candidates.

### A_CRSP_MSENAMES: Use the verified CRSP.MSENAMES product for the supplied distinct NCUSIP/PERMNO name mapping; historical population coverage is a preparation check, not a raw-source availability gate.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_CRSP_MSENAMES
Evidence: E_PROBE_CRSP_MSENAMES, E_SAS_MSENAMES

Preparation / proposed procedure:

1. Use the verified NCUSIP and PERMNO keys from the exact candidate product.
2. Preserve the source distinct-pair construction and its lack of an effective-date filter.
3. Check observed mapping coverage during later 13F preparation; do not substitute this name-history table for the separate MSE event role.

Validation to perform later:

- Check output key types and the supplied distinct-pair construction.
- Record observed 13F CUSIP mapping coverage as a preparation result, separately from MSE event-table identification.

### A_COMPSEG_SAS: Prepare the WRDS_SEGMERGED source for the SAS segment counts after confirming the source's date and population coverage.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMPUSTAT_SEG
Evidence: E_PROBE_COMPSEG, E_SAS_SEGMENTS, E_SAS_SEGMENT_CHAIN

Preparation / proposed procedure:

1. Use the readable Compustat segment candidate with gvkey, stype, sid, datadate and srcdate fields.
2. Preserve the source's year>=2015 and BUSSEG/GEOSEG filters and its source-date ordering/deduplication.
3. Keep the separate Stata Comp_seg handoff unresolved until CIK and schema equivalence are established.

Validation to perform later:

- Check the selected fields and year range against the SAS source requirements.
- Check CCM link keys/date filters before using the segment counts downstream.

### A_CRSP_CCM: Use the verified CCM linktable raw fields with the source LU/LC, P/C and effective-date filters; date matching is future output preparation.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_CRSP_CCM
Evidence: E_PROBE_CRSP_CCM, E_SAS_CCM

Preparation / proposed procedure:

1. Use GVKEY, LINKPRIM, LINKTYPE, LPERMNO/LPERMCO, LINKDT and LINKENDDT from the exact candidate.
2. Preserve the supplied link-type, primary-link and DATADATE interval filters.
3. Check which rows match the prepared segment observations during a future authorized step; do not gate raw table availability on unsampled history.

Validation to perform later:

- Check exact field types and preserved source filters.
- Record matched-link coverage for the segment output as a preparation check before a future SAS run.

### A_SAS_RUNTIME: Confirm the intended SAS/CONNECT environment, remote submission support and the supplied macro/library definitions before any separately authorized execution.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_SAS, I_SAS_CRSPMERGE
Evidence: E_ENV_REGISTERED, E_SAS_CRSP_FIELDS, E_SAS_SEGMENTS

Preparation / proposed procedure:

1. Confirm an authorized SAS runtime and the SAS/CONNECT remote-submit context required by the source.
2. Locate the matching %crspmerge macro definition and required libraries under the approved execution environment.
3. Keep credentials/configuration outside source/evidence and preserve the existing SAS stage order.

Validation to perform later:

- Confirm macro input/output schema and library visibility from static documentation or an authorized future execution plan.
- No SAS executable, startup file or author program is run during this assessment.

### A_STATA_WINSOR2: Add the missing winsor2 command to the future Stata environment before running the supplied transformations.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_WINSOR2
Evidence: E_ENV_REGISTERED, E_STATA_SOFTWARE_WINSOR2

Preparation / proposed procedure:

1. Install/configure winsor2 through the project's approved Stata add-on setup process before an authorized run.
2. Keep the supplied winsorization calls and variable lists unchanged.

Validation to perform later:

- Confirm Stata resolves winsor2 in the intended runtime environment.
- Do not run author statistics during setup verification.

### A_STATA_ASDOC: Add the missing asdoc command needed by the supplied descriptive-summary stages.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_ASDOC
Evidence: E_SOFT_ASDOC, E_STATA_SOFTWARE_ASDOC

Preparation / proposed procedure:

1. Install/configure asdoc through the approved Stata add-on setup process before a future authorized run.
2. Retain the supplied summary commands and output sequence.

Validation to perform later:

- Confirm Stata resolves asdoc in the intended runtime environment.
- Do not run any descriptive/statistical command for this assessment.

### A_STATA_RANGEJOIN: Add the missing rangejoin command required by the supplied auditor-change event-window joins.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_RANGEJOIN
Evidence: E_SOFT_RANGEJOIN, E_STATA_SOFTWARE_RANGEJOIN

Preparation / proposed procedure:

1. Install/configure rangejoin and its required helper dependencies through the approved Stata add-on process.
2. Keep both engagement-date and dismissal-date range joins and their current windows.

Validation to perform later:

- Confirm Stata resolves rangejoin in the intended runtime environment.
- Do not execute either author join during setup verification.

### A_STATA_PATH_SETUP: Stage the two author roots under one coherent future execution tree and map all existing inputs/outputs without changing the supplied branch order.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_STATA_PATH_SETUP
Evidence: E_STATA_PATH_ROOTS, E_STATA_UPDATE_ROOT, E_STATA_AAFEES_READ, E_STATA_SAVE_2092

Preparation / proposed procedure:

1. Keep BCRW1 inputs and generated intermediates separate from BCRW2_Additional update files under relative paths or approved [redacted-path-9ca40abdf2f8] paths.
2. Replace absolute Windows-root assumptions consistently in the future working copy, including the second branch's reads of first-branch outputs.
3. Use the documented batch-mode host wrapper and a relative execution root; do not insert absolute Dropbox workspace paths into runtime configuration.

Validation to perform later:

- Check path visibility/writability and filename case under the intended host before a separately authorized run.
- Confirm every required intermediate is produced before its existing consumer and preserve both initial and update branches.
- Check that the later AAfees read resolves to the updated AAFees output on the target filesystem; retain the author panel if a case-only path adjustment is required.

### A_IO_HANDOFF: Resolve the exact producer and schema relationship between the SAS IO product and the Stata 2024 SAS7BDAT import.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_STATA_INST_OWNERSHIP, I_IO_HANDOFF
Evidence: E_STATA_IO_HANDOFF, E_SAS_OUTPUTS, E_SAS_IO_CONSTRUCTION

Preparation / proposed procedure:

1. Obtain the producer or field mapping for ior_gvkeys_03282024.sas7bdat and confirm ior, gvkey and datadate.
2. Compare ownership measure, identifiers, date construction and history with SAS IO_TimeSeries and InstOwn_03022023.
3. Use shared root/library/format staging only after the same logical product and consumed fields are established.

Validation to perform later:

- Check the exact merge keys/date semantics and output schema before the Stata merge.
- Preserve both products if their producer/schema contracts differ.

### A_SEGMENT_HANDOFF: Resolve the exact producer and schema relationship between the SAS segment export and the separately consumed Stata Comp_seg file.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_STATA_COMP_SEGMENTS, I_SEGMENT_HANDOFF
Evidence: E_STATA_SEGMENT_HANDOFF, E_SAS_SEGMENT_CHAIN, E_SAS_SEGMENT_A2, E_SAS_SEGMENT_EXPORT

Preparation / proposed procedure:

1. Obtain the producer for Comp_seg20240321.dta and map CIK, GVKEY, DATADATE, SRCDATE and STYPE.
2. Compare the Stata category-count construction with the SAS output fields and aggregation.
3. Treat same-root/library/format copying as preparation only if exact product, keys and schema match; otherwise retain both product requirements.

Validation to perform later:

- Check date and CIK mapping and verify the source's stype/segment-count contract before a future run.
- Preserve the original Stata and SAS stage order.

### A_DEPENDENCY_CLOSURE: Resolve the remaining specifically identified inputs and handoffs before a full-pipeline attempt while preserving the independently verified raw components.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_DEPENDENCY_CLOSURE
Evidence: E_COMPONENT_FIELD_COMPARE, E_PROBE_FEED03_UNION, E_PROBE_FUNDA_UNION, E_PROBE_FEED39_UNION, E_PROBE_FEED10_PARTIAL, E_STATA_FORM_AP_CUTOFF, E_STATA_PARTNER_LAG_WINDOW, E_STATA_PARTNER_SAMPLE_WINDOW, E_STATA_MSA, E_STATA_PREAICO, E_SAS_CRSP_FIELDS, E_STATA_IO_HANDOFF, E_STATA_SEGMENT_HANDOFF

Preparation / proposed procedure:

1. Resolve MSA.dta and pre_aicohistorytest.dta producer/schema inputs.
2. Identify CRSP.MSE event records and the unprovided %crspmerge definition; keep the successful raw MSF/MSENAMES routes separate.
3. Resolve FEED03/FEED11 company-class flags, FUNDA IPO/SIC/filer fields, FEED02 CURR_AUDSNC_DATE and FEED10 FISCAL_YE mappings.
4. Identify the independent Stata Comp_seg and SAS7BDAT ownership producers/field handoffs, and complete required software/path preparation.
5. Acquire and prepare the public Form AP product, checking the actual FY2015–2016 early-period coverage required by the source.

Validation to perform later:

- Check each identified field/product or producer contract against its source evidence before a separately authorized run.
- Preserve all 88 frozen dependencies and the supplied Stata/SAS source order.
- Do not infer data absence, license status, or full-history incompatibility from catalog nonmatches or one-row sampling.


## Remaining issues and prerequisites

- I_STATA_PATH_SETUP [preparation; full_pipeline]: The Stata driver uses absolute Windows paths and switches from a BCRW1 root to a separate BCRW2_Additional root while reusing earlier files. A future host run needs a coherent relative execution root that preserves both directories and the existing branch order; this is setup work, not evidence that any data are inaccessible. The later branch reads AAfees while saving the updated panel as AAFees, so case-sensitive filename resolution must be checked.
- I_SAS_CRSPMERGE [unresolved; full_pipeline]: The raw CRSP.MSF component and its seven source-selected fields are independently readable. The supplied SAS workflow still calls %crspmerge to create sas:work.crsp_m, but its macro definition is not packaged; the separate MSE monthly event-record product/date contract is also unresolved. The connected setup context remains a method limit; no credential, access barrier or SAS execution failure is inferred.
- I_IO_HANDOFF [unresolved; full_pipeline]: The SAS supplement downloads box.InstOwn_03022023 from IO_TimeSeries, while Stata separately imports ior_gvkeys_03282024.sas7bdat and requires ior, gvkey and datadate. The supplied SAS output's relationship, date alignment and schema mapping to the Stata product are not established.
- I_SEGMENT_HANDOFF [unresolved; full_pipeline]: The SAS raw WRDS_SEGMERGED component and its selected fields are independently readable. Stata separately consumes Comp_seg20240321.dta and derives CIK/GVKEY/date/type-based counts; its producer, CIK mapping and relationship to the SAS aggregate export are not established.
- I_DEPENDENCY_CLOSURE [unresolved; full_pipeline]: Remaining unresolved inputs and handoffs are specific: MSA.dta, pre_aicohistorytest.dta, the CRSP.MSE event table and %crspmerge definition, six FEED03/FEED11 company-class fields, four FUNDA IPO/SIC/filer fields, FEED02 CURR_AUDSNC_DATE, FEED10 FISCAL_YE, and the independent Stata Comp_seg/ownership-file producers. Form AP is a documented public route with a required FY2015–2016 coverage check. Raw MSF, MSENAMES, WRDS_SEGMERGED, CCM, FEED34, FEED39 and the FUNDA age construction retain their independently supported routes.
- R_TFN_S34TYPE1 [undetermined]: SAS role for Thomson Reuters 13F type-1 manager/reporting metadata. Source selects rdate, fdate, mgrno and mgrname, then chooses the first filing vintage by manager and report date. The catalog has a consolidated TFN.S34 candidate with some needed fields; equivalence to the type-specific input, history and filing-vintage semantics remain unverified.
- R_TFN_S34TYPE3 [undetermined]: SAS role for Thomson Reuters 13F type-3 holdings. The source joins by fdate and mgrno, retains shares>0, and consumes CUSIP and share counts. TFN.S34 is a consolidated catalog candidate whose type partition, report-vintage join and history are not established as equivalent to the two source aliases.
- R_CRSP_MSE [undetermined]: CRSP monthly event records selected for NCUSIP, EXCHCD and SHRCD, including the common-share filter. A catalog match for the exact event table was not established. CRSP.MSENAMES has overlapping fields but is a name-history table, and does not establish the event-record role or event-date construction.
- R_FORM_AP [public_acquisition_required]: PCAOB Form AP CSV imported by both Stata branches. Source shifts fiscal year from Fiscal Period End Date, screens issuer audits in the United States, retains CIK and Engagement Partner ID, and uses FY2015 onward partner history plus the FY2022 update. Official partner-reporting begins for reports issued on/after January 31, 2017; coverage of required FY2015–2016 periods needs checking, not an assumption that records are absent.
- R_AA_FEES_2023 [undetermined]: Audit Analytics audit-fee input shared by the initial auditfeesraw20230612.dta branch and the later AuditFees20240610.dta update branch. Source derives fiscal year, selects original USD observations, screens issuer classes, deduplicates company-years and appends the 2022 update for 2021–2022 growth. Date aliases are preparation details; the actual filter fields, periods and feed mapping still need verification.
- R_AA_404_2023 [undetermined]: Audit Analytics SOX 404 internal-control opinion input shared by 404raw20230612.dta and 404Raw20240610.dta. Both branches retain auditor opinions and original observations, screen issuer classes, then derive IC-audit/weakness variables; the later branch supplies the 2022 update. The additional company-screening fields and history are not established by the candidate probe.
- R_AA_AUDCHANGES_2024 [undetermined]: Audit Analytics auditor-change file AudChanges20240815.dta used for alternative mandatory-rotation and tenure calculations. Code excludes benefit-plan and merger events, then uses auditor/event names, keys and dates in two range joins against Compustat. The exact event-date fields and history remain unresolved.
- R_COMPUSTAT_FUNDAMENTALS [undetermined]: Compustat annual fundamentals input compustatraw20230612.dta used for controls and fiscal-year/date joins in multiple supplied branches. Source consumes CIK, GVKEY, DATADATE/FYEAR and annual accounting, market, filer and IPO fields. The separately consumed firm-age table remains a distinct requirement because its file-specific history and correspondence are not established by the fundamentals probe.
- R_AA_SOX302 [undetermined]: Audit Analytics SOX 302 disclosure file sox302raw20231111.dta consumed for quarterly management-weakness disclosures. Source uses company key, numeric fiscal-period-end date, ineffectiveness flag and fiscal-year-end month/day to drop Q4 observations and align periods; exact field mapping and history remain unverified.
- R_MSA [undetermined]: MSA.dta city_state-to-MSA crosswalk consumed when adding auditor metropolitan-area mappings. The supplied Stata program does not create this crosswalk; its source/version and coverage are unknown.
- R_PRE_AICO_HISTORY [undetermined]: pre_aicohistorytest.dta consumed by the supplied final conservatism/prediction branch. No producer or input schema is established in the supplied Stata entry script, so its identifier, field, period and construction contract remain unknown.
- R_STATA_COMP_SEGMENTS [undetermined]: Separately consumed Stata segment file Comp_seg20240321.dta. The source requires gvkey, cik, datadate and srcdate, retains datadate==srcdate and counts BUSSEG/GEOSEG/OPSEG categories. The SAS supplement's box.segments_03022023 output is a distinct aggregate and does not establish this Stata file's schema or producer.
- R_STATA_INST_OWNERSHIP [undetermined]: Separately consumed Stata import ior_gvkeys_03282024.sas7bdat, reduced to ior, gvkey and datadate before merging into the final panel. The supplied SAS file produces box.InstOwn_03022023 from IO_TimeSeries, a different named product/date; its schema, keys and producer relationship to the Stata import are not established.
- S_SAS [unverified]: The registered environment viewer reports SAS availability/status as unverified with a failed return code. SAS was not started, and no executable/startup test was performed.
- S_WINSOR2 [preparation_required]: The registered environment metadata reports winsor2 unavailable; the supplied Stata source invokes it for winsorization. Install/configure this user-written command before an authorized run.
- S_ASDOC [preparation_required]: A bounded Stata 18 metadata probe reports asdoc unavailable; the author source invokes it for descriptive summaries.
- S_RANGEJOIN [preparation_required]: A bounded Stata 18 metadata probe reports rangejoin unavailable; the source uses it twice for auditor-change event windows.

## Review notes

- Static assessment covers the supplied Stata driver and SAS supplement; no author program, statistical command, dataset payload, model, SAS executable or network data route was run or downloaded. The two packaged DTA files contain identifier lists only and do not support a separate analysis-only scope.
- Named one-row metadata reads support the raw CRSP.MSF, CRSP.MSENAMES, WRDS_SEGMERGED, CCM and FUNDA CIK/FYEAR components independently. Exact field comparison preserves specific unmapped FEED03/FEED11 company-class, FUNDA IPO/SIC/filer, FEED02 auditor-since and FEED10 fiscal-year-end fields; catalog nonmatches do not prove data or license absence. FEED02 failure and the TFN timeout remain preserved and were not retried.
- The initial SAS screening view and faulty reader/capture remain opaque in place. Stata path quotes were narrowed to safe literal source ranges or source-bound metadata descriptors; no literal author-root values were displayed or inserted as redaction placeholders. No credential or access barrier is inferred.
- No author execution or model output is verified. The target remains the complete supplied workflow, with unresolved source inputs, software/path preparation and independent cross-language handoffs recorded in their routes and actions.
