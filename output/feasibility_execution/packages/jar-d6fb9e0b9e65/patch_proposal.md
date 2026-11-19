# Patch proposal: jar-d6fb9e0b9e65

The Impact of Information Frictions Within Regulators: Evidence from Workplace Violations

DOI: 10.1111/1475-679X.12541

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied Stata preprocessing workflow for constructing the author dataset, limited to the documented package workflow and not unprovided paper-wide estimators.

Entry points: `data_preprocessing_FSY.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 3/12541 - The-Impact-of-Information-Frictions-Within-Regulators-Evidence-from-Workplace-Violations/rr-datasheet-code-and-identifiers.zip",
      "sha256": "da0373703543f1cc074dfe11cbee4d972d97f1b8d23714e6eaebc1f14c3ea5f9"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "5e4349d2427929ff9fb3c47997dca48fba75908e9629d89d7880992d339d2991"
}
```

## Proposed actions

### ACT_RESOLVE_OSHA_KEY_CONTRACT: Confirm the intended key definition for the packaged OSHA crosswalk before changing its merge contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_OSHA_LINKTABLE, ISSUE_OSHA_KEY_CONTRACT, ISSUE_INPUT_ROUTES
Evidence: E_LINKTABLE_PROBE, E_LINK_MERGE

Preparation / proposed procedure:

1. Confirm whether the crosswalk's year and the inspection open_year represent distinct keys or a documented mapping, and supply the table specification or author-approved mapping.
2. If the current package table is not compatible, obtain the author-supported crosswalk or its documented preparation inputs.

Validation to perform later:

- Check the source schema for company_OSHA, year, zipcode_OSHA, open_year and gvkey before a separately authorized run; retain the issue if the intended key relation is not documented.

### ACT_CONFIRM_STATA_ABBREVIATION_CONTEXT: Confirm the intended Stata variable-abbreviation setting and namespace at the two count-use blocks; do not infer a repair from lexical prefixes alone.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_STATA_ABBREVIATION_CONTEXT
Evidence: E_AGG_OUTPUT, E_MAIN_VAR_USE, E_BOARD_COUNT_NAMES, E_STATA_ENV

Preparation / proposed procedure:

1. Confirm the author-session varabbrev setting and the variables in scope after the violation and BoardEx producer blocks.
2. If each shortened form resolves uniquely with abbreviation enabled, preserve the supplied names; otherwise request author-approved explicit references before proposing an edit.

Validation to perform later:

- Use source/session evidence to establish the exact resolution before changing any count reference; no name-resolution probe was run in this assessment.

### ACT_ALIGN_INTERMEDIATE_PATHS: Prepare a separate working copy with the helper and generated files at paths that match the supplied driver's relative reads.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISSUE_INTERMEDIATE_PATHS
Evidence: E_MAIN_ENTRY, E_DOC_CODE, E_OSHA_OUTPUT_SAVE, E_OSHA_OUTPUT_READ, E_NONOSHA_OUTPUT_READ, E_NONOSHA_OUTPUT_SAVE, E_NATIVE_SOURCE_TRACE, E_MAIN_FINAL_SAVE

**Proposed edit:** `data_preprocessing_FSY.do:130–130`
Source SHA-256: `32774e6bd3b80adc5f847db1773bec740fe47c13d41acd706dfb375f50a0ca9f`

The following supplied line 138 reads the same-named intermediate from OSHA/; this supported path alignment writes the identified producer output at that consumer path, provided the directory exists in the working copy.

Current text:
```
save osha_inspections_violations_merged, replace
```

Proposed replacement:
```
save OSHA/osha_inspections_violations_merged, replace
```

**Proposed edit:** `data_preprocessing_FSY.do:401–401`
Source SHA-256: `32774e6bd3b80adc5f847db1773bec740fe47c13d41acd706dfb375f50a0ca9f`

With the supplied top-level cd Data still in force, this producer writes the same basename that line 318 reads from the current Data directory; the edit aligns the producer path with that consumer.

Current text:
```
save Data/CultureVariables/non_OSHA_violations, replace
```

Proposed replacement:
```
save non_OSHA_violations, replace
```

Preparation / proposed procedure:

1. Keep the original package unchanged and use a working copy with the declared Data directory; place a complete copy of aggregate_osha_violation_v2.do at the helper path resolved from that directory.
2. Ensure the working-copy OSHA subdirectory exists before the generated inspection/violation intermediate is written there.
3. Apply the two path edits below only in the working copy, preserving the source logic and output names.
4. Apply the line 401 non-OSHA output-path alignment before relocating the original 357–431 producer blocks; launch the eventual full reordered file from the parent of Data so line 1 cd Data executes once.

Validation to perform later:

- Statically compare every producer path with its consumer path from the same Data working directory; verify the two edited paths match lines 138 and 318.
- After relocation, verify the aligned non-OSHA producer path remains the path consumed from Data, without a second cd Data or nested Data/Data root.

### ACT_STAGE_PRODUCERS_FIRST: In a separate working copy, relocate the complete supplied producer blocks before the main consumer stream and run the reordered full driver once from the parent of Data, allowing its authored cd Data to occur exactly once.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: ISSUE_PRODUCER_ORDER
Evidence: E_IBES_ORDER, E_IBES_PRODUCER, E_VT_PRODUCER, E_BOARDEX_PRODUCER, E_NONOSHA_OUTPUT_READ, E_NONOSHA_OUTPUT_SAVE, E_MAIN_ENTRY, E_MAIN_FINAL_SAVE, E_IBES_FYEAR_MAPPING, E_NONOSHA_3YEAR_USE, E_NATIVE_SOURCE_TRACE

Preparation / proposed procedure:

1. Set the full driver's launch working directory to the directory containing Data; preserve line 1 cd Data so it runs once before any producer or main-stream code.
2. In the working copy, first apply the existing line 401 non-OSHA output-path alignment under ACT_ALIGN_INTERMEDIATE_PATHS, then move the complete original lines 357–431 (IBES, non-OSHA and BoardEx producer blocks) immediately after setup lines 1–2 and before original main line 3.
3. Preserve every producer-block body, input, filter, merge, generated variable and output. Keep the main stream from original lines 3–344 intact, including its final save of OSHA_compustat_firmstate.
4. Run the reordered full file once from the parent of Data after all prerequisite routes and paths are resolved; do not restart the full driver from inside Data after staging producers, which would execute cd Data a second time.
5. Resolve the I/B/E/S raw fyear field under ACT_VERIFY_CUSIP_MAP and the non-OSHA three-year field origin under ACT_CLARIFY_NONOSHA_3YEAR_ORIGIN before treating the generated intermediates as complete.

Validation to perform later:

- Statically verify that the complete original 357–431 blocks occur after setup 1–2 and before main 3–344, with all block bodies unchanged except the separate supported line 401 path alignment.
- Confirm the full-file launch directory is the parent of Data and the authored cd Data is encountered once; retain original line 344 as the final OSHA_compustat_firmstate save.
- Before a separately authorized run, compare producer paths and fields with the consumers at lines 296, 310 and 318, including the open fiscal-year, non-OSHA three-year and Stata namespace contracts.

### ACT_VERIFY_OSHA_CHUNK_ROUTES: Verify and acquire each distinct OSHA violation and inspection chunk through an authorized official route.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_OSHA_VIOLATION_12, REQ_OSHA_VIOLATION_11, REQ_OSHA_VIOLATION_10, REQ_OSHA_VIOLATION_9, REQ_OSHA_VIOLATION_8, REQ_OSHA_VIOLATION_7, REQ_OSHA_VIOLATION_6, REQ_OSHA_INSPECTION_4, REQ_OSHA_INSPECTION_3, REQ_OSHA_INSPECTION_2, REQ_OSHA_INSPECTION_1, REQ_OSHA_INSPECTION_0, ISSUE_INPUT_ROUTES
Evidence: E_OSHA_PUBLIC, E_OSHA_DOWNLOAD_PERIOD, E_VIOLATION_12_READ, E_VIOLATION_11_READ, E_VIOLATION_10_READ, E_VIOLATION_9_READ, E_VIOLATION_8_READ, E_VIOLATION_7_READ, E_VIOLATION_6_READ, E_INSPECTION_4_READ, E_INSPECTION_3_READ, E_INSPECTION_2_READ, E_INSPECTION_1_READ, E_INSPECTION_0_READ

Preparation / proposed procedure:

1. Confirm that the official OSHA interface supplies the complete author-required April 2020 violation and inspection chunk sets with the fields used by the supplied code.
2. Acquire the seven named violation CSVs and five named inspection CSVs as separate inputs, preserving their original chunk identities and the coverage needed by the authored filters.
3. Place the verified files under the Data working directory using the exact filenames read by the driver.

Validation to perform later:

- Check each file's format, required columns, download period and completeness before a separately authorized author-code run; the current public page snippet alone does not verify these properties.

### ACT_VERIFY_COMPUSTAT_PATHS: Verify the two separately referenced Compustat inputs and their mappings to the supplied driver's fiscal-date and financial-control fields.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_COMP_FISCAL_MATCH, REQ_COMP_FIRMYEAR_CONTROLS, ISSUE_INPUT_ROUTES
Evidence: E_COMP_FISCAL_INPUT, E_COMP_CONTROLS_INPUT, E_COMP_CONTROL_FIELDS, E_CATALOG_NARROW, E_COMP_FUNDA_PROBE

Preparation / proposed procedure:

1. Confirm whether the two Compustat_all_1995_2019 references are intended to resolve to one or two prepared tables and document each relative path.
2. For each input, verify gvkey/year mapping and the required date/control fields; compare the cataloged Funda candidate's datadate/fyear with the author-prepared datadate_statafmt/year fields.
3. Verify the 1995–2019 coverage and the historical rows needed by lagged controls before treating either route as compatible.

Validation to perform later:

- Use a bounded schema/coverage review of the exact chosen source and record its period; the one-row probe does not establish full coverage.

### ACT_VERIFY_REFUSA_ROUTE: Confirm authorized ReferenceUSA/Reference Solutions access and the prepared firm-state-year establishment table required by the driver.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_REFUSA_FIRMSTATE, ISSUE_INPUT_ROUTES
Evidence: E_REFUSA_INPUT, E_REFERENCEUSA_PUBLIC, E_CATALOG_NARROW

Preparation / proposed procedure:

1. Confirm current subscription entitlement and the permitted delivery method for the historical firm-state-year data.
2. Provide or prepare the author-compatible table with gvkey, state, year and firm_state_estabs for the 2002–2017 sample period, documenting the establishment count and gvkey mapping.

Validation to perform later:

- Verify the exported/author-prepared table schema and period against the merge before a separately authorized run; catalog misses and the subscription description do not establish access status.

### ACT_VERIFY_IBES_DETAIL_ROUTE: Verify the I/B/E/S detail input and its local candidate mapping to the author's EPS forecast-preparation code.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_IBES_DETAIL, ISSUE_INPUT_ROUTES
Evidence: E_IBES_PRODUCER, E_IBES_DET_PROBE, E_CATALOG_NARROW

Preparation / proposed procedure:

1. Confirm that the selected US detail source covers 2000–2019 and retains the CUSIP, EPS measure, analyst, forecast dates/times, actuals and values used by the supplied transformations.
2. If the local SAS candidate is selected, use an authorized format-conversion preparation step to create the named Stata input while preserving the source fields and exact author filters.
3. Keep the prepared detail input distinct from the separate CUSIP–GVKEY crosswalk.

Validation to perform later:

- Verify the exact 2000–2019 source coverage and required columns after conversion; the current one-row SAS probe only establishes readability and column names.

### ACT_VERIFY_CUSIP_MAP: Confirm the author-supported CUSIP-to-GVKEY/fiscal-year crosswalk contract used by the I/B/E/S preparation block.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_IBES_CUSIP_GVKEY, ISSUE_INPUT_ROUTES, ISSUE_IBES_FYEAR_SOURCE
Evidence: E_CUSIP_MAP_INPUT, E_IBES_PRODUCER, E_CATALOG_CUSIP_CANDIDATE, E_IBES_FYEAR_MAPPING, E_NATIVE_SOURCE_TRACE

Preparation / proposed procedure:

1. Confirm the source and preparation of cusip_gvkey_linktable, including ncusip, fyear_end_month, fyear_end_year and gvkey at the merge in the supplied source.
2. The block collapses observations by cusip/fpedats, generates only fyear_end_year and fyear_end_month in the visible excerpt, merges the crosswalk, and then renames fyear to year. Confirm that the crosswalk supplies fyear or identify an exact author-supported producer for it.
3. Document how the crosswalk relates fpedats fiscal-period keys to fyear; do not infer fyear from calendar year/month or use the local CCM candidate as a direct substitute without the required keys.
4. Verify coverage for the fiscal periods represented by the I/B/E/S detail history.

Validation to perform later:

- Check ncusip/fyear_end_month/fyear_end_year merge keys, gvkey and raw fyear mapping, period coverage and mapping uniqueness against the author specification before a separately authorized run.

### ACT_VERIFY_BOARDEX_INPUTS: Verify the two distinct BoardEx inputs used by the supplied director-independence producer.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_BOARDEX_CHARACTERISTICS, REQ_BOARDID_CIK, ISSUE_INPUT_ROUTES
Evidence: E_BOARDEX_PRODUCER, E_BOARD_COUNT_NAMES, E_CATALOG_NARROW

Preparation / proposed procedure:

1. Provide or identify na_dir_characteristics.dta with BoardID, year, NonExecutiveDirector and RowType fields and the history needed for the 2000–2017 construction.
2. Provide or identify the separate boardex_ID_CIK crosswalk with BoardID and cik fields, confirming its mapping coverage.
3. Confirm the Stata abbreviation context for the shortened count names under ACT_CONFIRM_STATA_ABBREVIATION_CONTEXT.

Validation to perform later:

- Verify both input schemas, BoardID/CIK mapping, year coverage and the final CIK-year producer schema before a separately authorized run.

### ACT_VERIFY_VT_AND_CIK_INPUTS: Confirm the permitted route and obtain the three distinct Violation Tracker inputs used by the workflow.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_VIOLATION_TRACKER, REQ_CIK_SUBSIDY_TRACKER, REQ_CIK_VIOLATION_TRACKER, ISSUE_INPUT_ROUTES
Evidence: E_VT_PUBLIC, E_VT_PRODUCER, E_CIK_LISTS_INPUT, E_CATALOG_NARROW

Preparation / proposed procedure:

1. Confirm current authorized access for the required Violation Tracker fields and historical-parent file; free search/display alone has not been shown to provide the complete input.
2. Obtain VT_with_historical_parents.csv with cik, pen_year, penalty_adjusted and agency_code, documenting its historical coverage and parent mapping.
3. Obtain the Subsidy Tracker CIK list and Violation Tracker CIK list as separate inputs, with their definitions and coverage used for the driver's zero classification.

Validation to perform later:

- Verify the required fields and periods for the CSV and each CIK list independently; retain unresolved coverage when the source does not document it.

### ACT_CLARIFY_NONOSHA_3YEAR_ORIGIN: Trace the annual non-OSHA input and the later penalties_not_OSHA_3year use to an author-selected source or documented producer before treating this branch as complete.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_NONOSHA_3YEAR_ORIGIN, REQ_VIOLATION_TRACKER, ISSUE_INPUT_ROUTES
Evidence: E_VT_PRODUCER, E_NONOSHA_OUTPUT_READ, E_NONOSHA_3YEAR_USE, E_NATIVE_SOURCE_TRACE

Preparation / proposed procedure:

1. Confirm whether penalties_not_OSHA_3year is supplied by an already selected prepared input, a prior master-table field or another author-supported producer; the visible VT producer creates annual penalties_not_OSHA only.
2. Request the exact origin, expected fields and history/period required for the three-year field, including the authors' documented handling of missing values, year gaps and zero classification.
3. Keep this field origin unresolved until its source and coverage are documented; do not invent a rolling-window calculation or alter the sample/design.

Validation to perform later:

- Before a separately authorized run, establish that the documented source provides penalties_not_OSHA_3year at the main consumer and verify its origin, time coverage and author-defined handling rules.

### ACT_CONFIRM_OSHA_EXPORT_NAMESPACE: Confirm the author-intended matching-export branch and the available variable namespace after the two supplied renames.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_OSHA_MATCH_EXPORT_NAMESPACE, REQ_OSHA_LINKTABLE
Evidence: E_OSHA_EXPORT_NAMESPACE, E_LINK_MERGE, E_DOC_CODE, E_NATIVE_SOURCE_TRACE

Preparation / proposed procedure:

1. Confirm whether the raw candidate matching CSV export at lines 102–108 is intended to run when the packaged hand-checked OSHA-to-Compustat linktable is supplied and consumed at line 116.
2. If the export branch is selected, verify the actual post-import/post-rename variable names and author-required CSV headers for line 104 before proposing any rename or keep-list change.
3. If the author-prepared crosswalk is the intended route, document the supported branch handling without requiring a new fuzzy-match reconstruction; retain the separate linktable year/open_year key clarification.

Validation to perform later:

- Confirm the selected branch and its exact retained/exported names from source-supported namespace evidence; do not infer absent fields or unique prefixes and do not run a namespace trial.


## Remaining issues and prerequisites

- ISSUE_OSHA_KEY_CONTRACT [unresolved; full_pipeline]: The driver merges on company_OSHA, year, zipcode_OSHA and open_year, while the bounded packaged-linktable probe found company_OSHA, year, zipcode_OSHA and gvkey. The intended year/open_year semantics and compatible key contract remain unresolved.
- ISSUE_STATA_ABBREVIATION_CONTEXT [unresolved; full_pipeline]: The helper generates num_repeat_viol and num_willful_viol while the driver refers to num_repeat and num_willful; the BoardEx block also generates longer count identifiers and later refers to shorter forms. Stata permits unique prefixes when abbreviation is enabled, but the supplied source does not establish the author session's abbreviation setting or variable namespace at those points.
- ISSUE_INTERMEDIATE_PATHS [preparation; full_pipeline]: The driver executes cd Data at line 1, so the full file must be launched from the parent of Data for that relative change to occur once. Starting the full file while already inside Data would resolve into Data/Data. The helper include is relative to the resulting Data directory although the package copy is at the package root; the inspection/violation intermediate is saved in the current directory and then loaded from OSHA/, and the non-OSHA producer path differs from the current-directory consumer.
- ISSUE_PRODUCER_ORDER [preparation; full_pipeline]: The main stream at original lines 3–344 consumes ibes_aggregated, director_independence_year and non_OSHA_violations before the supplied producers at original lines 357–431. In a working copy, move the complete producer blocks after setup lines 1–2 and before main line 3, then launch the reordered full file from the parent of Data so cd Data occurs once. Preserve the main stream through its final save at original line 344.
- ISSUE_INPUT_ROUTES [unresolved; full_pipeline]: The full supplied workflow reads separate OSHA CSV chunks, two distinct Compustat paths, prepared ReferenceUSA, I/B/E/S and CUSIP mapping inputs, two BoardEx inputs, historical-parent Violation Tracker data and two CIK lists. Most exact tables are absent from this package; candidate products, user entitlements, field mappings and full coverage remain unverified. The I/B/E/S map's raw fyear mapping and the non-OSHA three-year field origin are separately unresolved source contracts.
- ISSUE_IBES_FYEAR_SOURCE [unresolved; full_pipeline]: The I/B/E/S source is collapsed by cusip/fpedats and adds fyear_end_month/fyear_end_year, then merges the CUSIP crosswalk. The following rename fyear year requires a raw fyear value from that crosswalk or another author-supported producer; the supplied block does not establish a fiscal-year rule.
- ISSUE_NONOSHA_3YEAR_ORIGIN [unresolved; full_pipeline]: The supplied Violation Tracker producer groups and saves annual penalties_not_OSHA by CIK/year. The main stream later refers to penalties_not_OSHA_3year at lines 337 and 340. Its origin, history and author-defined missing/zero and year-alignment conventions are not established by this annual producer; keep the field origin unresolved without assuming it is absent from an unseen prepared source.
- ISSUE_OSHA_MATCH_EXPORT_NAMESPACE [unresolved; full_pipeline]: The raw matching-export stanza renames estab_name to company_OSHA and site_zip to zipcode_OSHA at lines 97–98, then line 104 selects the former names. The actual namespace after import/rename and whether this candidate export is selected when the packaged hand-checked linktable is used are not established. This is a conditional precondition, not a confirmed missing-column blocker or a requirement to reconstruct fuzzy matches.
- REQ_OSHA_VIOLATION_12 [undetermined]: The distinct OSHA violation CSV chunk osha_violation12.csv, imported jointly with the other named violation chunks before aggregation by activity_nr.
- REQ_OSHA_VIOLATION_11 [undetermined]: The distinct OSHA violation CSV chunk osha_violation11.csv, imported jointly with the other named violation chunks before aggregation by activity_nr.
- REQ_OSHA_VIOLATION_10 [undetermined]: The distinct OSHA violation CSV chunk osha_violation10.csv, imported jointly with the other named violation chunks before aggregation by activity_nr.
- REQ_OSHA_VIOLATION_9 [undetermined]: The distinct OSHA violation CSV chunk osha_violation9.csv, imported jointly with the other named violation chunks before aggregation by activity_nr.
- REQ_OSHA_VIOLATION_8 [undetermined]: The distinct OSHA violation CSV chunk osha_violation8.csv, imported jointly with the other named violation chunks before aggregation by activity_nr.
- REQ_OSHA_VIOLATION_7 [undetermined]: The distinct OSHA violation CSV chunk osha_violation7.csv, imported jointly with the other named violation chunks before aggregation by activity_nr.
- REQ_OSHA_VIOLATION_6 [undetermined]: The distinct OSHA violation CSV chunk osha_violation6.csv, imported jointly with the other named violation chunks before aggregation by activity_nr.
- REQ_OSHA_INSPECTION_4 [undetermined]: The distinct OSHA inspection CSV chunk osha_inspection4.csv, appended jointly with the other named inspection chunks before linking and aggregation.
- REQ_OSHA_INSPECTION_3 [undetermined]: The distinct OSHA inspection CSV chunk osha_inspection3.csv, appended jointly with the other named inspection chunks before linking and aggregation.
- REQ_OSHA_INSPECTION_2 [undetermined]: The distinct OSHA inspection CSV chunk osha_inspection2.csv, appended jointly with the other named inspection chunks before linking and aggregation.
- REQ_OSHA_INSPECTION_1 [undetermined]: The distinct OSHA inspection CSV chunk osha_inspection1.csv, appended jointly with the other named inspection chunks before linking and aggregation.
- REQ_OSHA_INSPECTION_0 [undetermined]: The distinct OSHA inspection CSV chunk osha_inspection0.csv, appended jointly with the other named inspection chunks before linking and aggregation.
- REQ_OSHA_LINKTABLE [undetermined]: The packaged hand-checked OSHA-to-Compustat linktable used to map inspections on company_OSHA, year, zipcode_OSHA and the driver's open_year key to gvkey.
- REQ_COMP_FISCAL_MATCH [undetermined]: The first Compustat_all_1995_2019 input merged to OSHA records by gvkey and year to identify fiscal-year dates.
- REQ_COMP_FIRMYEAR_CONTROLS [undetermined]: The second Compustat_all_1995_2019 input at ../../Generally_Useful_Data/Compustat_all_1995_2019, merged by gvkey and year for firm-year controls and lagged ratios.
- REQ_REFUSA_FIRMSTATE [undetermined]: The prepared firm-state-year ReferenceUSA establishment-count input merged to gvkey, state and year.
- REQ_IBES_DETAIL [undetermined]: The I/B/E/S EPS detail input used to construct analyst forecasts and actuals for 2000–2019.
- REQ_IBES_CUSIP_GVKEY [undetermined]: The separate CUSIP/fiscal-period-to-GVKEY crosswalk used by the I/B/E/S preparation; the merged source must also provide fyear for the subsequent rename to year, unless an author-supported producer supplies that field.
- REQ_BOARDEX_CHARACTERISTICS [undetermined]: The prepared North America BoardEx director-level characteristics input used to create CIK-year board-independence measures.
- REQ_BOARDID_CIK [undetermined]: The separate BoardEx BoardID-to-CIK mapping merged into director-level records.
- REQ_VIOLATION_TRACKER [undetermined]: The historical-parent Violation Tracker input used to construct non-OSHA CIK-year penalties.
- REQ_CIK_SUBSIDY_TRACKER [undetermined]: The separate CIK list from the Subsidy Tracker coverage database used to identify firms for which absence can be treated as zero.
- REQ_CIK_VIOLATION_TRACKER [undetermined]: The separate CIK list from the Violation Tracker coverage database used to identify firms for which absence can be treated as zero.

## Review notes

- The datasheet identifies data_preprocessing_FSY.do as the primary supplied preparation driver and aggregate_osha_violation_v2.do as its included helper. The helper's call-context comment is retained; no unprovided paper-wide analysis stage or separate helper entry point is added.
- The package also contains gvkeys_in_sample.txt, which the supplied driver does not read; it is not treated as a required input. No analysis_only scope is supported by a supplied analysis dataset and analysis program.
- The OSHA linktable probe is a one-row/readability and column check with coverage_verified=false; its absent open_year field and the meaning of its year key remain a specific unresolved merge contract.
- The catalog lookup and bounded local SAS probes identify candidate products and fields only. They do not establish complete periods, author-prepared file identity, current subscription entitlement or population coverage; catalog misses are not treated as proof of unavailability.
- The official OSHA result snippet supports a public data interface, while the Good Jobs First guide limits some fields and downloads to subscribers and ReferenceUSA is described as a subscription database. Current access and exact source compatibility remain unverified. JavaScript rendering and 403 fetch results are retained only in an unreferenced inspection record and are not used as evidence of a barrier.
- Stata 18 and the winsor command are available by metadata. No author program was run, no Stata name-resolution/syntax probe was run, and no computed result or execution claim is made.
- A narrow CRSP CCM catalog selection found link-history tables with gvkey/security and effective-date fields; their selected metadata did not include the CUSIP and fiscal-period keys required by the supplied prepared crosswalk, so no compatible local substitute is claimed.
- The corrected single-run procedure launches from the parent of Data, preserves the authored cd Data once, relocates complete original lines 357–431 after setup lines 1–2 and before main lines 3–344, applies the existing line 401 path alignment before relocation, and preserves the main line 344 final save.
- The I/B/E/S crosswalk contract explicitly includes raw fyear after the fiscal-period merge; the supplied excerpt does not establish its mapping rule, so no calendar/fiscal conversion is invented.
- The visible non-OSHA producer creates annual penalties_not_OSHA, while the main stream later uses penalties_not_OSHA_3year. Its source/history and missing/zero/year-gap conventions remain a scoped unresolved origin question, not a confirmed missing-variable blocker or a proposed formula.
- The inspection matching-export stanza renames estab_name/site_zip before a keep statement uses the former names. Its variable namespace and branch selection remain conditional; the supplied hand-checked crosswalk is retained and no fuzzy-match reconstruction is added as a mandatory route.
