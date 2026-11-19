# Patch proposal: jar-744b72a877d2

The Effect of Client Industry Agglomerations on Auditor Industry Specialization

DOI: 10.1111/1475-679X.12503

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied monolithic SAS raw-data preparation and final Stata-format export workflow. The datasheet mentions later Stata tests, but no executable Stata program is supplied; this scope assesses the actual SAS target only.

Entry points: `Agglom_JAR_Final_JUL2023.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 5/12503 - The-Effect-of-Client-Industry-Agglomerations-on-Auditor-Industry-Specialization/kw-datasheet-code-and-identifiers.zip",
      "sha256": "df65329d23a39824c51c0481fb4574c95bb056037cd921e910d5b268762123cc"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "eeca88eb73ebdf62097475225cfc481fd63c4de173b35bbb4bfc241feaa9c972"
}
```

## Proposed actions

### A_AA_INPUTS: Confirm the exact Audit Analytics extracts and vintage needed by the supplied `oc` tables.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_AA_FEES, R_AA_OPINIONS, R_AA_CHANGES, R_AA_BANKRUPT, R_AA_AUDITCBLOCK
Evidence: E_SRC_AA_FEES, E_SRC_AA_CHANGES, E_SRC_BANKRUPT, E_SRC_AUDITCBLOCK, E_CAT_AA_FEES, E_CAT_AA_OPINIONS, E_CAT_AA_CHANGES, E_CAT_AA_BANKRUPT, E_PROBE_AA_FEES_CORE, E_PROBE_AA_OPINIONS_CORE, E_PROBE_AA_CHANGES, E_PROBE_AA_BANKRUPT_CORE, E_PROBE_AA_BANKRUPT_EXACT, E_CAT_AA_CBLOCK

Preparation / proposed procedure:

1. Retain FEED03 audit-fee, FEED34 opinion, FEED02 auditor-change and FEED21 bankruptcy candidates as local discovery leads only; their identifiers and dated history need confirmation against the author’s 2019 downloads.
2. Obtain the required auditcblock source or its exact product/table, and confirm the code-used NAME/COMPANY_FKEY fields.
3. Map every code-required field and date interval to the chosen product before configuring the `oc` tables; do not infer aliases from product names or one-row matches.
4. Keep the unavailable/uncertain feeds separate from derived C_AA_Combined and Audit_fees_all outputs.

Validation to perform later:

- Use bounded one-row field checks for each confirmed local file, with the exact code-required fields.
- Verify the exact source product, identity keys, date types and needed history from the provider or author documentation.
- After all inputs and paths are configured, review the ordered producer/consumer joins without dropping filters or variables.

### A_COMP_INPUTS: Confirm the local FUNDA, WRDS_SEGmerged and issuer-link candidates match the supplied source schema and required period history; COMP.COMPANY’s required fields are verified in the local route.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_COMP_FUNDA, R_COMP_SEGMENT, R_COMP_LINK_GVKEY, R_COMP_LINK_CUSIP
Evidence: E_SRC_COMP_FUNDA, E_SRC_SEGMENT, E_SRC_SEGMENT_HISTORY, E_SRC_GVKEY_LINK, E_SRC_CUSIP_LINK, E_CAT_FUNDA, E_CAT_SEGMENT, E_CAT_LINK_GVKEY, E_CAT_LINK_CUSIP, E_PROBE_COMP_FUNDA, E_PROBE_SEGMENT, E_PROBE_LINK_GVKEY, E_PROBE_LINK_CUSIP_EXACT

Preparation / proposed procedure:

1. Use COMP.FUNDA and WRDS_SEGmerged only as current catalog candidates; verify required fields and periods on the exact selected products.
2. COMP.COMPANY is verified for the source’s GVKEY/SIC/GIND/FYRC contract; population matching to FUNDA remains a later join/output validation, not an extra author-attestation prerequisite.
3. Resolve WCIKLINK_GVKEY’s DATADATE1/DATADATE2 field names and link coverage rather than substituting guessed aliases.
4. The WCIKLINK_CUSIP candidate has a one-row match for CIK, CIKDATE1/2 and CUSIP_FULL; verify the full historical interval needed for joins.
5. Preserve the source filters and the 1998/2002+ history requirements when staging the remaining inputs in the `oc` library.

Validation to perform later:

- Repeat bounded one-row checks only for the remaining FUNDA, WRDS segment and issuer-link inputs whose routes are still unverified.
- Confirm the 1998 link start, Compustat FYEAR>2002 subset and segment date coverage from source metadata/provider records.
- After future authorization, validate downstream join/output coverage for the verified COMPANY fields together with its FUNDA consumer.

### A_ICW_PREPARED_INPUT: Obtain the exact prepared A_ICW_302_404 input specification or file.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_ICW_302_404
Evidence: E_SRC_ICW_INPUT, E_CAT_AA_OPINIONS, E_CAT_AA_ICW_PERIOD, E_PROBE_AA_ICW

Preparation / proposed procedure:

1. Ask for the author-prepared combined input or its exact source feeds, field mappings, filters and period.
2. Confirm COMPANY_FKEY, PERIOD_END_DATE_NUM and the 302/404 components used to derive ICW.
3. Treat the local FEED10 and FEED11 catalog hits as distinct product candidates; do not assume either feed alone equals the combined prepared input.

Validation to perform later:

- Check the exact prepared input with a bounded one-row field/readability probe.
- Compare the documented construction history and 302/404 definitions with the source consumer before marking this route compatible.

### A_HEADER_LOCATION_INPUT: Obtain the exact author-prepared 10-K header/location table or its extraction specification.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_HEADER_10K
Evidence: E_SRC_HEADER_INPUT, E_CAT_SEC, E_PROBE_SEC_RAW, E_PROBE_SEC_PARSED

Preparation / proposed procedure:

1. Request the Client_10K_header_location_info_OCT_2021 input with its CIK/date/city/state/ZIP/SIC fields and historical coverage.
2. The local raw and parsed SEC roots are source-document leads only; they do not establish the prepared author table or its header extraction, cleaning or population.
3. If the authors intend a local-document preparation route, obtain its exact parsing/header-selection and date-match specification before proposing any data construction.

Validation to perform later:

- Use a bounded metadata check on the exact supplied prepared table and confirm required fields/types.
- Verify that CIK and fiscal-year dates support the source’s ±15-day merge across all required years.

### A_FORM_AP_INPUT: Acquire or confirm the dated Form AP input compatible with the supplied import and joins.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_FORM_AP
Evidence: E_PUBLIC_PCAOB, E_SRC_FORM_AP, E_SRC_FORM_AP_JOIN, E_SRC_DATASHEET_SOURCES

Preparation / proposed procedure:

1. Prefer the author’s October 2022 Form_AP_data workbook if available; otherwise compare the official PCAOB public dataset and data dictionary with the code’s expected fields before using it.
2. If using the public CSV product, perform only schema-preserving format preparation and map the raw field names to the author code’s expected input names after checking exact field semantics.
3. Retain the source’s CIK and ±15-day fiscal-date join; do not replace or omit partner, audit-firm or report fields.

Validation to perform later:

- Check the chosen input’s readable format, expected fields and date types with a bounded metadata reader.
- Confirm historical coverage and the meaning of each mapped Form AP field before later authorized execution.

### A_CENSUS_CITY_LOOKUPS: Obtain both 2013 city-to-CBSA input tables or an exact author-approved preparation specification.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_CENSUS_MSA_CITY, R_CENSUS_CITY_FIPS_CBSA
Evidence: E_SRC_DATASHEET_SOURCES, E_SRC_MSA_INPUTS, E_SRC_MSA_OUTPUT, E_PUBLIC_CENSUS

Preparation / proposed procedure:

1. Request both `M_MSA_2013` and `city_fips_cbsa`, including the city/county/state/CBSA field definitions and the vintage used.
2. Use the Census historical page’s February 2013 CBSA listing as a public lead only; it does not establish city-level field or coverage compatibility.
3. Preserve the two-table append, city/state key and 2013 vintage when staging the inputs.

Validation to perform later:

- Check each exact table’s fields, identifier formats and 2013 coverage with a bounded metadata probe.
- Confirm that the prepared combined lookup covers the firm and auditor city/state keys used by later joins.

### A_ZIP_LOOKUP: Obtain the exact zip_code2 source and field contract required by the distance branch.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_ZIP_CODE2
Evidence: E_SRC_ZIP_INPUT, E_SRC_ZIP_LOCAL_CITIES, E_SRC_REMOTE_CALC, E_SRC_ZIP_OUTPUT

Preparation / proposed procedure:

1. Request the original zip_code2 dataset or reproducible author source, exact file format/hash, and field definitions for ZIP, X, Y, city and statecode.
2. The author comment’s third-party URL was not accessible in the bounded static check; the page title does not verify the coordinate fields used by this code.
3. Preserve the embedded city corrections and ZIP-pair/SAS ZIPCITYDISTANCE construction; do not substitute a similarly named current ZIP file without matching the required fields and semantics.

Validation to perform later:

- Use a bounded field/readability probe on the exact input and confirm ZIP/city/state formats plus X/Y coordinate semantics.
- Confirm that the input supports all ZIP pairs used by the author source before the remote branch is considered closed.

### A_DRIVE_TIMES_INPUT: Obtain the author-collected drive_times.csv and its collection/schema details.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_DRIVE_TIMES
Evidence: E_SRC_DATASHEET_SOURCES, E_SRC_DRIVE_INPUT, E_SRC_DRIVE_FIELDS, E_PUBLIC_MAPS

Preparation / proposed procedure:

1. Request the exact CSV and field definitions/units for city, state, CBSA, destination, total minutes and miles.
2. Confirm the author’s March 21, 2019 overnight collection protocol, route choices and any time settings; Google Maps Help establishes that estimated route times are date/time-sensitive, not that a current replacement matches the file.
3. Do not generate new routes or substitute current Google Maps output for the author’s collected measurements.

Validation to perform later:

- Use a bounded CSV metadata/readability check and verify the required source columns and units.
- Confirm city/CBSA coverage and that later ranks are built from the same supplied drive-time records.

### A_T100_FILES: Stage the annual domestic T-100 CSVs required by the code and resolve the 2018 year/path mismatch.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_T100_DOMESTIC, I_T100_2018
Evidence: E_SRC_DATASHEET_SOURCES, E_SRC_T100_IMPORT, E_SRC_T100_2017_2018, E_SRC_FLIGHT_LOOP, E_PUBLIC_BTS

Preparation / proposed procedure:

1. Acquire or confirm the author’s annual domestic T-100 CSV inputs and check the code-required city-market, passenger, departure and airtime columns.
2. Preserve the code’s 2000-2017 imports and 2000-2018 macro sequence while asking the authors to confirm which 2018 file was intended; do not invent a filename or silently treat 2017 as 2018.
3. Compare the source’s 2000-2003 construction history with the datasheet’s stated 2004-2018 download years before deciding which vintage files are needed.

Validation to perform later:

- Inspect each chosen annual CSV header/field layout with a bounded metadata reader.
- Verify the 2018 file-year mapping and required 2000 onward macro inputs against the author’s source records.

### A_WINSOR_MACRO: Obtain the exact external winsor.sas include and macro contract.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I_WINSOR
Evidence: E_SRC_WINSOR

Preparation / proposed procedure:

1. Request the included macro source (or an author-supplied replacement that preserves the same winsorization semantics) and its `$vars` definition.
2. Keep the call’s input/output tables, byvar=fyear and 1/99 percentiles unchanged until the exact macro body and variable list are available.

Validation to perform later:

- Statically inspect the provided helper and confirm it defines the called macro and input/output contract.
- After all data/software prerequisites are resolved and execution is separately authorized, confirm the expected H_compu2 variables before later joins.

### A_SAS_RUNTIME: Verify the target SAS runtime and required PC Files support through the local administrator/environment record.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_SAS, SW_SAS_PCFILES, I_SAS_RUNTIME, I_PCFILES
Evidence: E_ENV, E_SRC_FORM_AP, E_SRC_FINAL_OUTPUT, E_PUBLIC_SAS_DTA, E_PUBLIC_SAS_PCFILES

Preparation / proposed procedure:

1. Confirm an operational SAS 9.4 runtime for this target environment without treating the frozen unverified status as a missing-license finding.
2. Confirm SAS/ACCESS Interface for PC Files support for the XLSX imports and DTA export; request setup or licensing only if the administrator confirms it is absent.
3. Do not rerun SAS startup or launch the author program during this static assessment.

Validation to perform later:

- Record the confirmed SAS version and PC Files feature/entitlement using administrator or installation metadata.
- After separate authorization and input staging, verify that the intended DTA export format is supported.

### A_SAS_CONNECT_RUNTIME: Confirm the SAS/CONNECT capability and remote-side setup required by the ZIP-distance branch.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_SAS_CONNECT, I_REMOTE
Evidence: E_SRC_REMOTE_CALC, E_SRC_REMOTE_DOWNLOAD, E_PUBLIC_SAS_CONNECT

Preparation / proposed procedure:

1. Have the SAS administrator confirm a compatible SAS/CONNECT client/server setup and the required remote workspace/data-transfer semantics.
2. Use the already supplied and masked connection configuration only after it is reviewed by the authorized SAS administrator; this assessment makes no connection attempt.
3. Keep the remote ZIPCITYDISTANCE calculation and returned zip_temp_f stage in the workflow.

Validation to perform later:

- Verify the local SAS/CONNECT feature and server-side prerequisites from authorized environment documentation.
- Only after separate authorization and all inputs are staged, verify the transfer path and output schema with a minimal non-study-controlled check.

### A_PATH_CONFIGURATION: Map the author’s input/output roots and library name to the staged same-data paths for the execution environment.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_PATH_CONFIGURATION
Evidence: E_SRC_LIBRARY, E_SRC_HEADER_INPUT, E_SRC_FORM_AP, E_SRC_ZIP_INPUT, E_SRC_DRIVE_INPUT, E_SRC_T100_IMPORT, E_SRC_FINAL_OUTPUT

Preparation / proposed procedure:

1. Create a documented local path map for each supplied [redacted-path-5c746c94cde2]: input, the winsor include, the configured `oc` source library and the output library.
2. Preserve the exact source file identity, table order and data transformations; path/root changes are setup only.
3. Keep the final output path writable in the target SAS environment without changing dataset names or analysis fields.

Validation to perform later:

- Statically confirm every input, include, library and output path resolves to its intended same-data target before an authorized run.
- Recheck that all required source and generated-table order remains as shown in the 89-edge trace.

### A_EXPORT_DTA: Make the final Stata-format export explicit with the documented DTA identifier.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_EXPORT_FORMAT
Evidence: E_SRC_FINAL_OUTPUT, E_PUBLIC_SAS_DTA

**Proposed edit:** `Agglom_JAR_Final_JUL2023.sas:3192–3193`
Source SHA-256: `a6253c7525d64138e07c98e6a59b34ac782610239d0b08e659b26eb48967191a`

The supplied code names a .dta export path, and the official SAS/ACCESS reference identifies DBMS=DTA as the Stata .dta output format.

Current text:
```
 proc export data=&library..J2_flights_drive_zip_rd4 replace
                       outfile= "[redacted-path-ddb25bd99978]";
```

Proposed replacement:
```
 proc export data=&library..J2_flights_drive_zip_rd4 dbms=DTA replace
                       outfile= "[redacted-path-ddb25bd99978]";
```

Preparation / proposed procedure:

1. Apply only the anchored edit below in a working copy after confirming the author intended the named .dta output.
2. Keep the SAS dataset name, output path and replace behavior unchanged.

Validation to perform later:

- Review the resulting PROC EXPORT statement statically against the target SAS release documentation.
- After data/software prerequisites are satisfied and execution is separately authorized, confirm the output opens as a Stata .dta dataset.

### A_FULL_ORDERED_RUN: After all named prerequisites are resolved, follow the supplied SAS source in its recorded order and validate each handoff.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_CLOSURE
Evidence: E_WORKFLOW_TRACE, E_SRC_SCOPE, E_SRC_FINAL_OUTPUT

Preparation / proposed procedure:

1. Do not start this procedure until required data, exact winsor include, path configuration, SAS/CONNECT and PC Files checks are complete.
2. Use the supplied SAS file as the only executable entry point for this target; retain its complete branches and order.
3. Confirm each stage output before its downstream consumer and produce the named J2_flights_drive_zip_rd4 dataset and explicit .dta export.
4. Treat downstream Stata model tests as outside the supplied executable target; do not infer their code or run a model from the commented source excerpt.

Validation to perform later:

- Check final assessment closure against every D0001-D0089 item and the producer/consumer trace.
- In a separately authorized run, retain logs and verify the final exported dataset schema and required observations before any downstream analysis.


## Remaining issues and prerequisites

- I_CLOSURE [unresolved; full_pipeline]: The full SAS source still depends on unverified commercial tables, missing author-prepared inputs, the external winsor macro, historical public-source files and remote SAS capability.
- I_WINSOR [unresolved; full_pipeline]: The active %INCLUDE references an external winsor.sas macro that is not in the package inventory; its macro body and variable contract cannot be reconstructed from the call alone.
- I_SAS_RUNTIME [unresolved; full_pipeline]: The frozen environment snapshot records SAS as unverified; it is not evidence of missing entitlement, and no SAS runtime attempt was made in this assignment.
- I_REMOTE [unresolved; full_pipeline]: The source includes a remote ZIP-distance transfer branch; SAS/CONNECT session/configuration and target-side semantics are not verified. The connection statement block is masked in the safe review, and no connection attempt occurred.
- I_PCFILES [unresolved; full_pipeline]: SAS/ACCESS PC Files support/licensing for the XLSX imports and DTA export is unverified; no license conclusion is drawn.
- I_PATH_CONFIGURATION [preparation; full_pipeline]: The source names Windows drive-letter input/output paths and an output-library macro; the target execution roots must be mapped to the supplied same-data files before a future run.
- I_T100_2018 [unresolved; full_pipeline]: The 2018 z table import points to the same 2017 CSV path, while the datasheet reports a 2018 annual download; correct file/year intent requires author confirmation.
- I_EXPORT_FORMAT [preparation; full_pipeline]: The final PROC EXPORT names a .dta output but omits an explicit DBMS identifier; SAS documentation lists DBMS=DTA for Stata files, so the intended export option should be explicit and PC Files support verified.
- R_AA_FEES [undetermined]: Audit Analytics audit-fee observations consumed as oc.AUDITFEES, including auditor/company/year keys and positive audit fees; full downstream field/history requirements follow the complete SAS source.
- R_AA_OPINIONS [undetermined]: Audit Analytics audit-opinion observations consumed as oc.AUDITOPIN; besides key/year fields the code uses opinion date, going-concern, auditor city/state, PCAOB and issuer matching fields.
- R_AA_CHANGES [undetermined]: Audit Analytics auditor-change observations consumed as oc.AUDITCHANGE with engagement/dismissal dates, auditor keys/names and company key.
- R_COMP_FUNDA [undetermined]: Compustat FUNDA source rows and fields used to construct the firm-year panel, with the code’s domestic industrial/standard/consolidated filters.
- R_COMP_SEGMENT [undetermined]: WRDS segment rows used to compute business/geographic segment counts by GVKEY and date.
- R_COMP_LINK_GVKEY [undetermined]: Historical CIK-to-GVKEY link observations used with CONM, GVKEY, CIK and DATADATE1/DATADATE2 intervals; the code fills/extends link dates and uses them for issuer joins.
- R_ICW_302_404 [undetermined]: Prepared A_ICW_302_404 input, consumed without an in-file producer; code uses company/period fields and the 302/404 weakness components to form ICW.
- R_HEADER_10K [undetermined]: Prepared Client_10K_header_location_info input used to provide CIK-linked headquarters city/state/ZIP, fiscal year end and 10-K SIC fields, matched to Compustat dates within 15 days.
- R_AA_BANKRUPT [undetermined]: Audit Analytics bankruptcy records consumed through oc.bankrupt, including company key, begin/end dates, bankruptcy type and the code-selected ticker field.
- R_COMP_LINK_CUSIP [undetermined]: Historical CIK/CUSIP linking rows with CIKDATE1/CIKDATE2 and CUSIP_FULL for the code’s CIK-to-CUSIP-to-GVKEY fallback join.
- R_AA_AUDITCBLOCK [undetermined]: Audit Analytics auditcblock input joined on COMPANY_FKEY to supply NAME for unmatched-issuer name matching.
- R_FORM_AP [undetermined]: Form AP workbook used for engagement-partner/auditor firm fields joined to CIK and Compustat dates within 15 days.
- R_CENSUS_MSA_CITY [undetermined]: Census M_MSA_2013 city/county/state/CBSA table used as one source of the combined 2013 city lookup.
- R_CENSUS_CITY_FIPS_CBSA [undetermined]: Second city_fips_cbsa source table appended to M_MSA_2013; code renames CBSACODE to CBSA.
- R_ZIP_CODE2 [undetermined]: zip_code2 input used to map auditor city/state to ZIP and coordinate fields and construct ZIP-pair distances; the code expects ZIP, X/Y, city and statecode.
- R_DRIVE_TIMES [undetermined]: Author-collected drive_times.csv; code consumes auditor/destination city, state and CBSA fields plus total_mins and miles, then ranks travel-time destinations.
- R_T100_DOMESTIC [undetermined]: Annual BTS T-100 domestic segment CSVs consumed for flight route, passenger, departure and airtime connectivity; source imports 2000-2017 and loops 2000-2018.
- SW_SAS [unverified]: Required to run the supplied SAS source; the frozen environment snapshot marks SAS unverified, and no SAS process was started in this assignment.
- SW_SAS_CONNECT [unverified]: The ZIP-distance section uses a remote submit and PROC DOWNLOAD transfer; SAS/CONNECT service/configuration is not verified.
- SW_SAS_PCFILES [unverified]: The source imports XLSX inputs and proposes a Stata .dta export; the required SAS/ACCESS PC Files support/license is not verified.

## Review notes

- The frozen registered title and DOI were retained from output_header. The datasheet title matches the registered title and does not state the DOI.
- The XLS Identifiers file is described as company identifiers, years and variables of interest; it is not established as the full analysis panel. No analysis_only scope is added.
- The target is the supplied monolithic SAS preparation/export workflow. Stata analyses are described by the datasheet and appear only as a commented command; the package inventory contains no executable Stata program, so Stata is not added as a required runtime for this target.
- All 89 frozen dependency checklist IDs are covered by the ordered trace and will be linked in dependency_review. Generated intermediates are classified only when an earlier in-file producer was located.
- Local route credit requires an exact product match, a readable bounded probe with all source-required fields, and a satisfied source period/identity contract. The COMP.COMPANY route meets its GVKEY/SIC/GIND/FYRC contract because the code requests those descriptive fields and joins by GVKEY without a dated company-history condition; the one-row probe still has coverage_verified=false, so full join coverage remains future output validation. Other catalog hits/probes with unresolved product, field, period or history requirements remain unverified; probe failures do not establish absence or licensing.
- The source scanner’s first capture attempt returned rc=1 and the trace writer wrote JSON to the scanner source destination. The original first scanner source is lost/not verifiably recoverable; two retained files are JSON copies, not that original source. The actual failure artifacts and both copies remain preserved under probes/.
- A later V2 safe view exposed a non-secret remote setup line; the V3 reader masks lines 1835-1840 conservatively before display. No credential value was displayed and no remote connection was attempted. The masked block is not quoted as source evidence.
- Local SEC corpus checks were exact root metadata probes only. They establish directory-root existence, not a prepared Client_10K_header_location_info table, SEC coverage, field extraction or equivalence.
- No author code, data-processing/model/estimator/statistics, SAS startup, remote session, download, install or Stata analysis was executed in this assignment.
