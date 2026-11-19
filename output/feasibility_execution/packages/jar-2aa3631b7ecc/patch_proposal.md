# Patch proposal: jar-2aa3631b7ecc

Occupational Licensing and Minority Participation in Professional Labor Markets

DOI: 10.1111/1475-679X.12518

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied R Markdown CPA-sample construction workflow, including its required preparation and location, gender, race and disciplinary-action branches; this release does not include the paper's later estimation programs.

Entry points: `LicensingSampleCode/create_sample.Rmd`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 2/12518 - Occupational-Licensing-and-Minority-Participation-in-Professional-Labor-Markets/suv-datasheet-code-and-identifiers.zip",
      "sha256": "c779cdbf4f4a533458dff4b55c1a8448aff9cfc144d070b22804785cdea8e22c"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "91b8f2ee75369aa5173df9f1d11b9de1a29acff8bce09d4774eb43104f650e25"
}
```

## Proposed actions

### ACT_STAGE_HELPER: Prepare a separate working copy rooted at LicensingSampleCode and place the supplied functions.R at the relative 1_code/functions.R path expected by the notebook, retaining the original files unchanged.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISSUE_HELPER_PATH
Evidence: E_MAIN_ENTRY, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Use LicensingSampleCode as the relative project root so the notebook's 0_data and 2_output paths remain coherent.
2. Copy the supplied LicensingSampleCode/functions.R file into 1_code/functions.R in the working copy.

Validation to perform later:

- In a later authorized run, verify the working directory and that the source call resolves to the staged helper before starting the notebook.

### ACT_REQUEST_RAW_INPUTS: Obtain the historical author-prepared RDS/HTML input collection or a complete compatible set of author-generated .fst cache outputs for the wrapped stages; do not require both routes.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_RAW_RDS, R_RAW_HTML, ISSUE_RAW_INPUTS, ISSUE_LICENSE_HISTORY
Evidence: E_MAIN_RAW_PATHS, E_PACKAGE_INVENTORY, E_IDENTIFIER_PROBE, E_DOC_SOURCE_AND_PERIOD, E_PUBLIC_NASBA_HISTORY, E_CACHE_POLICY

Preparation / proposed procedure:

1. Request the author-prepared tables and HTML snapshots for the documented paths, or locate the exact compatible author-generated .fst caches for the stages they replace.
2. Reconcile the 2020_12_19 folder name with the datasheet's January-March 2021 collection window and record file-level field/history coverage.
3. Retain the identifier list only as a sample identifier file; it is not a replacement for full tables or snapshots.

Validation to perform later:

- After authorized acquisition, use bounded metadata to check actual fields, file format, cache provenance and historical/population coverage before a later authorized workflow run.

### ACT_CLARIFY_ADDRESS_HANDOFF: Clarify the producer and intended scope of the country-lookup address object before running the location branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_ADDRESS_TEMP_HANDOFF
Evidence: E_MAIN_ADDRESS_COUNTRY, E_WORKFLOW_TRACE, E_CACHE_POLICY

Preparation / proposed procedure:

1. First check whether a compatible lookup_country.fst stage cache is part of the author's prepared outputs.
2. If no compatible cache exists, ask for the author-defined input object or corrected source mapping; do not substitute tab_address0 or another object without confirmation.

Validation to perform later:

- In a later authorized run, verify that the documented object exists and contains the expected address field before evaluating the lookup.

### ACT_OBTAIN_LOCATION_INPUTS: Locate the author-compatible HUD and DOL workbooks at their expected paths or obtain prepared equivalents with matching historical vintages, geographies and row layouts.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_HUD_CROSSWALKS, R_DOL_CROSSWALK, ISSUE_LOCATION_INPUTS
Evidence: E_MAIN_HUD_DOL_PATHS, E_HELPER_HUD_DOL_CONTRACTS, E_PUBLIC_HUD, E_PUBLIC_DOL_INSTRUCTIONS, E_PUBLIC_DOL_FILE, E_CATALOG_MATCHES, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Confirm the HUD quarter and exact ZIP-to-CBSA/county/tract workbook subset; use the documented residential-ratio fields and do not substitute an unrelated crosswalk.
2. Obtain the author-compatible 2011 DOL OWCP GPCI-by-ZIP input. Confirm the exact historical workbook, row-11 layout and required conversion to the local .xlsx path.
3. Do not substitute the CMS ZIP-to-carrier locality file for the required DOL MSA/county fields without author confirmation.

Validation to perform later:

- Use bounded workbook metadata to verify sheet, field, row-offset, ZIP/geography and historical coverage before the later authorized workflow run.

### ACT_REQUEST_RACE_INPUTS: Request each author-prepared race DTA file separately, with its named path argument, required fields, method mapping, provenance and coverage.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_RACE_DTA_CENSUS, R_RACE_DTA_FLOTER, ISSUE_RACE_INPUTS
Evidence: E_HELPER_RACE_FILE_CONTRACT, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Request the DTA supplied through .path_race_census and the DTA supplied through .path_race_floter as separate inputs; clarify each path-to-method mapping, field definitions, provenance and historical coverage.
2. Preserve the documented race workflow and its inputs; do not recreate person-level estimates independently.

Validation to perform later:

- After authorized receipt, use bounded metadata separately for each file to confirm DTA format and required fields, then verify its method mapping and coverage before any later authorized execution.

### ACT_CLARIFY_RACE_HANDOFFS: Clarify the supplied race-branch object names, prediction-field mapping and census-key access contract before attempting this branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_RACE_METHOD_HANDOFFS, ISSUE_RACE_ACCESS_CONTRACT
Evidence: E_MAIN_RACE_SURNAME_HANDOFF, E_MAIN_RACE_METHOD_HANDOFF, E_SAFE_INTERFACE_SUMMARY, E_HELPER_RACE_FILE_CONTRACT, E_CACHE_POLICY, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Request author documentation for tab_surname, tab_prr_surname and the expected fields consumed by race_get_table_by_method.
2. Obtain the authorized key/configuration procedure from its owner without exposing or testing any key value.
3. Check for author-generated cached race-method outputs that may bypass the missing tab_surname expression; they do not replace the two direct DTA imports.

Validation to perform later:

- Once documented and authorized, inspect the local configuration and method output schemas without making a service request.

### ACT_CLARIFY_LOOKUP_CACHES: Clarify the authored USPS and gender lookup/cache contracts, expected fields, runtime and historical coverage, and establish a compatible source or prepared cache for the required ZIP results. The official public USPS page is a current manual lead; the registered API is not treated as a replacement.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_USPS_LOOKUP_CONTRACT, ISSUE_GENDER_LOOKUP_CONTRACT, ISSUE_BROWSER_SETUP, R_USPS_ZIP_MAPPING
Evidence: E_SAFE_INTERFACE_SUMMARY, E_MAIN_GENDER_METHODS, E_WORKFLOW_TRACE, E_PUBLIC_USPS_LOOKUP, E_PUBLIC_USPS_API

Preparation / proposed procedure:

1. Document the ZIP lookup input/output binding, browser requirements and cache path configuration.
2. Document the gender method-result fields and cache coverage; confirm whether prepared caches avoid external lookups.
3. Do not query people or invoke either external method during this assessment.

Validation to perform later:

- Before any later authorized run, verify the local cache/configuration formats against documented fields and establish an author-compatible permitted historical route.

### ACT_OBTAIN_DICTIONARY_INPUTS: Locate the separate HTML snapshot collection and the dictionary adjustment/edit workbooks required by the disciplinary-action dictionary branch.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_DICTIONARY_HTML, R_ADDITIONAL_DICTIONARY, R_DICTIONARY_EDIT, ISSUE_SECOND_HTML_EQUIVALENCE, ISSUE_DICTIONARY_WORKBOOKS
Evidence: E_MAIN_DICTIONARY_PATHS, E_MAIN_STATUS_DICTIONARY, E_MAIN_RAW_PATHS, E_PACKAGE_INVENTORY, E_CACHE_POLICY

Preparation / proposed procedure:

1. Confirm whether the separate HTML directory is a distinct historical snapshot, an equivalent copy of the main HTML collection, or can be replaced by a compatible raw_dict_entries.fst author cache.
2. Obtain the additional action dictionary and license-status edit workbook with the expected state/status fields.

Validation to perform later:

- Use bounded file and workbook metadata to verify the separate input collections, sheet names, fields and historical coverage.

### ACT_OBTAIN_ACTION_WORKBOOK: Locate the author-compatible dated disciplinary-action workbook and confirm the source fields used to produce the joined action indicator.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_DISCIPLINARY_ACTION, ISSUE_ACTION_WORKBOOK
Evidence: E_MAIN_DISCIPLINARY_ACTION, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Obtain the workbook for the documented date and preserve its state, license-status, description and update fields.

Validation to perform later:

- Inspect bounded workbook metadata and verify matching state/status coverage before the later authorized run.

### ACT_SETUP_R_PACKAGES: Prepare an R library with the author's compatible package versions and obtain documented sources for missing Rlookup and RFsel packages.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_R_PACKAGES, ISSUE_R_PACKAGE_AVAILABILITY
Evidence: E_R_PACKAGE_NAMES, E_R_PACKAGE_METADATA

Preparation / proposed procedure:

1. Confirm the author-intended versions or repository sources for the 29 direct package references, especially Rlookup and RFsel.
2. Prepare a project-local R library through the permitted software setup process; retain package versions for reproducibility.

Validation to perform later:

- Use installed-package metadata to confirm package names and versions before any later authorized workflow run.

### ACT_LOCATE_PREPARED_CACHES: Locate author-generated .fst cache outputs as supported alternatives for the exact cache-wrapped stages, and verify their provenance and coverage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_RAW_RDS, R_RAW_HTML, R_DICTIONARY_HTML
Evidence: E_CACHE_POLICY, E_MAIN_RAW_CACHE_CALLS, E_MAIN_HTML_CACHE_CALLS, E_MAIN_DICTIONARY_PATHS, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Ask whether the author maintains the 2_output cache files for the raw/normalized license tables, HTML parser, or dictionary extraction.
2. Use a compatible prepared cache for its wrapped stage when available; otherwise obtain that stage's documented author inputs.

Validation to perform later:

- Confirm cache format, required columns, source period, stage name and provenance with bounded metadata; a cache must not be assumed current merely because the code reads it.

### ACT_CONFIRM_BROWSER_RUNTIME: Confirm the browser package, driver and runtime required by the authored USPS lookup helper and whether a prepared author cache replaces that branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: SW_BROWSER_RUNTIME, ISSUE_BROWSER_SETUP
Evidence: E_SAFE_INTERFACE_SUMMARY, E_PUBLIC_USPS_LOOKUP, E_PUBLIC_USPS_API

Preparation / proposed procedure:

1. Request the supported browser/runtime version and local cache configuration from the package author.
2. Keep the current public/manual lookup and the separately documented API distinct from the authored browser method.

Validation to perform later:

- Check local runtime version and cache metadata only before a later authorized run; make no test request.


## Remaining issues and prerequisites

- ISSUE_RAW_INPUTS [unresolved; full_pipeline]: No full author-prepared RDS/HTML collection or compatible .fst stage cache is listed in the package. The one-row Identifiers.csv probe is not an analysis input; datasheet collection dates and the folder date need reconciliation, and current public lookup pages do not establish the historical population.
- ISSUE_HELPER_PATH [preparation; full_pipeline]: The notebook sources 1_code/functions.R, but the registered package supplies LicensingSampleCode/functions.R and a separate functions.Rmd; the expected helper path is not listed in the package inventory.
- ISSUE_ADDRESS_TEMP_HANDOFF [unresolved; full_pipeline]: The country lookup reads .tmp$address_adj, but no producer for .tmp appears in the supplied source set. The intended address source cannot be inferred safely; clarify the intended object or author-prepared value before attempting this branch. A compatible cached lookup_country.fst could bypass the lazy expression, but no cache directory is included; the no-cache path remains unresolved.
- ISSUE_RACE_METHOD_HANDOFFS [unresolved; full_pipeline]: The notebook defines tab_race_surname but uses tab_surname in prediction calls, and it constructs tab_prr_surname without passing it to the list consumed by race_get_table_by_method. Required object names and prediction-field compatibility remain unresolved; do not infer or alter the intended method handoff. Compatible cached method outputs might bypass the unresolved tab_surname expression, but none are included; the tab_prr_surname field handoff remains unverified.
- ISSUE_RACE_ACCESS_CONTRACT [unresolved; full_pipeline]: The authored race helpers expose wru::predict_race interfaces with a named census.key parameter; its required configuration/access route and output compatibility are not verified. In the resumed post-release static pass, the census.key value remained opaque and was not read or tested. No validity, use or connection was established.
- ISSUE_USPS_LOOKUP_CONTRACT [unresolved; full_pipeline]: The safe structural metadata confirms a browser/web interface and write/cache interface for the authored ZIP lookup branch, but the entry-to-helper request/result binding and cache configuration are unresolved. Confirm the authored interface and historical lookup requirements before using a public/manual alternative. The official current USPS lookup is only an unverified manual alternative; no historical/bulk match is established, and the separately documented USPS API is not proposed as a replacement.
- ISSUE_GENDER_LOOKUP_CONTRACT [unresolved; full_pipeline]: The gender branch includes a genderize helper plus name/year lookup and cache interfaces; the external request/response mapping, cache contents and historical coverage are not established by the safe available evidence. Compatible method-result caches may bypass some lookups, but no author cache files or provenance are supplied.
- ISSUE_SECOND_HTML_EQUIVALENCE [unresolved; full_pipeline]: The dictionary branch reads a second HTML directory distinct from the main raw HTML path; no producer or equivalence mapping establishes that the first directory can supply it. The raw_dict_entries.fst cache could bypass this read if compatible and present; it is not included in the package.
- ISSUE_LICENSE_HISTORY [unresolved; full_pipeline]: The datasheet describes CPA license data collected January-March 2021, while the input path is dated 2020_12_19. NASBA's current public lookup is not a verified source of the complete historical HTML/RDS snapshot population or its capture dates.
- ISSUE_LOCATION_INPUTS [unresolved; full_pipeline]: The required HUD and DOL workbooks are not listed in the package. Official series exist, but the HUD quarter/file set and the exact DOL .xlsx conversion/row-11 layout remain unverified.
- ISSUE_RACE_INPUTS [unresolved; full_pipeline]: The race helper directly imports two separate author-local DTA inputs through .path_race_census and .path_race_floter. Both expect ind_id, race, probability, guessdiff and predictionmethod; the package inventory does not establish either local path, method mapping, provenance or historical coverage.
- ISSUE_DICTIONARY_WORKBOOKS [unresolved; full_pipeline]: The additional dictionary and license_status edit workbooks are direct reads and are absent from the package inventory; their expected fields need bounded metadata confirmation.
- ISSUE_ACTION_WORKBOOK [unresolved; full_pipeline]: The dated disciplinary-action workbook is a direct input to tab_action and is absent from the package inventory; field and historical coverage are unverified.
- ISSUE_R_PACKAGE_AVAILABILITY [preparation; full_pipeline]: Twenty-eight of the 29 direct package references are absent from the checked R libraries, including the data-processing, cache, workbook, gender and race packages. Author version constraints and sources for Rlookup/RFsel are unspecified.
- ISSUE_BROWSER_SETUP [unresolved; full_pipeline]: The ZIP lookup branch has a browser/web interface, but its required browser package/driver and runtime setup are not established by the safe available interface metadata.
- R_RAW_RDS [undetermined]: Author-prepared individual CPA tables. When the raw tables are read, the helper requires ind_id, license_num, jurisdiction, license_status, last_name, middle_name, first_name and action. A compatible author-generated .fst cache can bypass the raw RDS read for its wrapped stage; exact population and history remain to be confirmed.
- R_RAW_HTML [undetermined]: Author-prepared individual CPA license HTML snapshots in the dated folder. The parser expects state-board .xdata_block pages with four child divisions and license, address and record fields. Compatible author-generated .fst cache outputs can bypass the corresponding HTML read; snapshot population and dates remain to be confirmed.
- R_HUD_CROSSWALKS [undetermined]: HUD ZIP crosswalk workbook(s) read from the location-data folder. The helper expects ZIP, residential-ratio and total-ratio fields, chooses the maximum residential-ratio row per ZIP, and preserves HUD geography outputs; exact source vintages, file set and coverage are not established.
- R_DOL_CROSSWALK [undetermined]: Dated DOL ZIP-to-MSA workbook. The helper reads starting at row 11, expects zip_code, and exports MSA/county columns used downstream; exact source vintage, field inventory and coverage remain unverified.
- R_DICTIONARY_HTML [undetermined]: HTML snapshots read from the separate 0_data/00_ind_data/2020_12_19_ind/htmls folder for dictionary extraction. No producer or equivalence to the main RawData HTML folder is supplied.
- R_ADDITIONAL_DICTIONARY [undetermined]: Workbook appended to the HTML-derived license-status dictionary; expected state and dictionary fields must be confirmed from the prepared workbook.
- R_DICTIONARY_EDIT [undetermined]: Workbook sheet license_status, filtered to adjusted license-status rows and joined by state and license_status; required values include active, status and reason.
- R_DISCIPLINARY_ACTION [undetermined]: Dated workbook grouped by state, license_status and description to produce the action value joined to individual license records; source field names, vintage and coverage require confirmation.
- R_USPS_ZIP_MAPPING [undetermined]: ZIP results for city/state pairs produced by the authored USPS lookup branch and then combined with DOL/HUD crosswalks. Current USPS lookup pages do not establish the authors' historical coverage or browser/cache protocol.
- R_RACE_DTA_CENSUS [undetermined]: Separate author-prepared DTA input passed through .path_race_census in race_get_table_by_method; the helper expects ind_id, race, probability, guessdiff, predictionmethod. The local path, census-named method mapping, provenance and historical coverage remain unverified.
- R_RACE_DTA_FLOTER [undetermined]: Separate author-prepared DTA input passed through .path_race_floter in race_get_table_by_method; the helper expects ind_id, race, probability, guessdiff, predictionmethod. The local path, floter-named method mapping, provenance and historical coverage remain unverified.
- SW_R_PACKAGES [preparation_required]: Of 29 direct namespace/library references in the sanitized source views, only tools is installed in the checked R libraries; 28 are missing. Package versions and installation sources are not specified. Some requirements inside opaque helpers remain unknown.
- SW_BROWSER_RUNTIME [unverified]: Safe static interface metadata confirms a browser/web method and write/cache interface, but the exact browser package, driver, runtime version and local cache configuration are unresolved.

## Review notes

- The supplied cache_obj helper reads existing .fst outputs when rerun is false; compatible author caches are credited as stage-specific alternatives, but no such caches are included in the package inventory.
- The datasheet reports collection between January and March 2021; the CPA input directory is named 2020_12_19. The exact target snapshot and population need clarification.
- Official public sources document NASBA current CPA lookup, quarterly HUD-USPS crosswalks, the DOL 2011 GPCI-by-ZIP product, and current USPS lookup. Their exact historical/format match remains unresolved where noted.
- R 4.5.0 is installed, while 28 of 29 direct R package references are absent from the checked libraries. Exact package version constraints and sources for Rlookup/RFsel are unknown.
- Only the entry create_sample.Rmd is a workflow entry point. functions.Rmd is a duplicate helper/document copy, not an independent launch target. No analysis_only route is supplied.
- Post-release method note: after the sanitized root disposition, this assessment used the new fail-closed source views; opaque helper bodies remained masked in that resumed pass. This describes resumed work only.
- Process disclosure (separate from scientific evidence): the sanitized root disposition at historical artifact jar-2aa3631b7ecc_root_disposition_20261111.json (SHA-256 0a4df8a8a8f7f9fe85a08adb6d2228d236e8e6a111c327c5c48258994229d8c9) records that an API-key-style candidate argument appeared in the initial tool output. No validity test, use, or connection was reported or established. The original display argv/streams/body were not independently recovered, and no pre-release draft/trace or saved in-memory reasoning is claimed. The disposition records hash-only in-place custody of 20 originals and eight registered source references, not byte-copy checkpoint preservation. The root release authorizes static continuation only; it does not retroactively authorize the earlier display.
