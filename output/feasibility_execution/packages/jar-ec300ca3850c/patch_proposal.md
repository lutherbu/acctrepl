# Patch proposal: jar-ec300ca3850c

Effects of an Information Sharing System on Employee Creativity, Engagement and Performance

DOI: 10.1111/1475-679X.12202

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied Stata preparation and main-analysis workflow, plus all current online-appendix outputs and companion procedures that are documented in the package.

Entry points: `1.1 Clean Poster Data.do`, `1.2 Prepare Customer Ratings.do`, `2.1  Attendance.do`, `3.1 Prepare Pre_Survey Data.do`, `3.2  Prepare Post_Survey Data.do`, `4.1 Store_sales.do`, `5.1 Store_characteristics.do`, `6.1 Clean Activity Data.do`, `7.1 Merge.do`, `7.2  Prepare Master Survey Dataset.do`, `7.3 Prepare Poster Datasets.do`, `8.0 Analyses and Proposed Tables.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 2/12202 - Effects-of-an-Information-Sharing-System-on-Employee-Creativity-Engagement-and-Performance/ls-datasheet-and-code.zip",
      "sha256": "d67a55e7934bc207a0b1af592d961c3f622c32a59128fd35062cfc78734e566d"
    },
    {
      "path": "JAR-Volume 56/Issue 2/12202 - Effects-of-an-Information-Sharing-System-on-Employee-Creativity-Engagement-and-Performance/li-sandino-accepted-proposal.pdf",
      "sha256": "25ac81917561cd4f6d68ade9ea0f131454409ba4ed4f38a11cb980ce5eaa498f"
    },
    {
      "path": "JAR-Volume 56/Issue 2/12202 - Effects-of-an-Information-Sharing-System-on-Employee-Creativity-Engagement-and-Performance/ls-online-appendix.pdf",
      "sha256": "40c2c9ef6fa47c2db63bbf171f55264f42c94e298591a91f41c8f1550b2e9412"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "148fcd5d1b087723732411df5a3fc933fcade8a59cb5c271b23bc522ee515999"
}
```

## Proposed actions

### A_MAIN_DATA_ACCESS: Obtain the author/company-approved source and survey inputs required by the full pipeline, in the documented formats and at the listed paths; verify schemas, periods, identifiers and coverage with the authors.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_POSTER_REGISTRY, R_TR_INDICATOR, R_CUSTOMER_PANEL, R_POSTER_HANDCODE, R_ATTENDANCE, R_PRE_MISSING_INFO, R_PRE_SURVEY, R_POST_SURVEY_LIST, R_POST_SURVEY_SPECIFIC, R_POST_SURVEY, R_STORE_SALES, R_MPR_COORD_NEW, R_MPR_COORD_OLD, R_STORE_CHARACTERISTICS, R_EMPLOYEE_LIST, R_ACTIVITY_LOG, R_TENURE_BESTGUESS, R_TL_CHANGE
Evidence: E_DATA_EXCLUSION, E_DATA_PROPRIETARY, E_SALES_PERIOD, E_ATTENDANCE_PERIOD, E_STORE_CHARACTERISTICS_DOC, E_ACTIVITY_DOC, E_REGISTRY_READ, E_PRE_SURVEY_READ, E_POST_SURVEY_READ

Preparation / proposed procedure:

1. Request an approved author/company handoff or authorized access route for every file named in the linked requirements; the archive explicitly omits proprietary input/output data.
2. For each workbook, confirm worksheet names and imported Stata field names; for store-specific sales CSVs, obtain the full store list and matching files without guessing redacted identifiers.
3. Confirm panel coverage, keys and date definitions against the stated periods, including the treatment indicator at both required input paths.
4. Do not reconstruct or substitute synthetic company, survey, customer-panel or activity data.

Validation to perform later:

- After an approved route is available, use bounded metadata/readability checks for each input and verify required fields, IDs, dates and sheet names before running its producer.
- Confirm sales and attendance cover May 2016–January 2017 and verify the stated periods for survey and poster inputs.

### A_POSTER_HANDCODE_CLARIFY: Clarify the required poster hand-coding step and provide or identify the exact Final_Stata input used by 1.2.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_POSTER_HANDCODE, I_POSTER_HANDOFF
Evidence: E_POSTER_OUTPUT_11, E_POSTER_HANDCODE_READ, E_DATA_EXCLUSION

Preparation / proposed procedure:

1. Ask the authors to provide poster_clean731_Final_Stata.dta or document the exact manual transformation from 1.1’s poster_clean731 export, including the poster key and every hand-coded field consumed by 1.2.
2. Confirm the intended directory and compatibility with CustomerPanel.dta; do not treat poster_clean731 as an alias without confirmation.

Validation to perform later:

- After the authors identify the route, check required columns and poster-key uniqueness with a bounded metadata/readability probe; confirm the produced CustomerPanel_Dataset path matches 7.3.

### A_REDACTED_LOGIC_CLARIFY: Request omitted author-specific code or privacy-preserving mappings needed to complete the preparation branches.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_REDACTED_MAPPINGS
Evidence: E_REDACT_11, E_REDACT_ATTEND, E_REDACT_PRE, E_REDACT_POST, E_REDACT_SALES, E_REDACT_SALES_BRANDS, E_REDACT_COORD, E_COORD_LOOP, E_COORD_CHUNK_CONSUMER, E_REDACT_ACTIVITY, E_REDACT_MERGE, E_REDACT_MASTER, E_REDACT_POSTERSET

Preparation / proposed procedure:

1. Ask for omitted store/brand normalization rules, experiment filters, username/employee/store mappings, manual survey corrections, and full store/brand lists.
2. Ask authors to confirm the coordinate chunk naming and output sequence: 5.1 writes mpr_coordinates_`val` but later opens mpr_coordinates_XXX.
3. Accept an approved privacy-preserving mapping or updated executable code; do not infer names, values or conditions from placeholders.

Validation to perform later:

- Review the returned text against every producer and consumer call, including store/brand loops, before any separately authorized run.
- Confirm each redacted filter/recode is present in the author-supplied version and preserves the documented analysis sample.

### A_12_OUTPUT_EDIT: Return to the customer-panel output directory after opening the log so relative intermediates and final saves reach the directory consumed by 7.3.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_12_OUTPUT_DIR
Evidence: E_12_DIR_SWITCH, E_12_CUSTOMER_SAVE, E_73_CUSTOMER_READ

**Proposed edit:** `1.2 Prepare Customer Ratings.do:168–168`
Source SHA-256: `c9ddb5e9d8bab39789ef6afd31699fb2d868372747ba232e4a52f478f3c974b7`

1.2 currently opens its log in programs/logs and never changes back; inserting the output-directory change after log initialization keeps Poster_AppRatings, temp1 and CustomerPanel_Dataset in the output folder expected by downstream code.

Current text:
```
	log using log_`time_string', text
```

Proposed replacement:
```
	log using log_`time_string', text
	cd "[redacted-path-1d41e6ede33f]"
```

Validation to perform later:

- After a separately authorized run, confirm Poster_AppRatings.dta, temp1.dta and CustomerPanel_Dataset.dta save under B. Data Preparation/01. Customer Panel Data/output.
- Confirm 7.3 reads that same CustomerPanel_Dataset path and matches poster/shop/brand keys.

### A_72_OUTPUT_EDIT: Switch to master-dataset output before saving the master survey and median files expected by 7.1 and 7.3.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_72_OUTPUT_DIR
Evidence: E_72_START_DIR, E_72_MASTER_SAVE, E_72_MEDIAN_SAVES, E_71_MASTER_READ, E_73_MASTER_READ

**Proposed edit:** `7.2  Prepare Master Survey Dataset.do:143–144`
Source SHA-256: `82a1f027eae5ad8a4bfd527586cf75739a56527568d432936b2a4a39512602ea`

7.2 stays in C. Master Dataset/input after reading its sources, but 7.1 and 7.3 use master_survey and both median datasets from C. Master Dataset/output. This change aligns all three saves with existing consumers.

Current text:
```
	* save data
	save master_survey, replace
```

Proposed replacement:
```
	* save data
	cd "[redacted-path-c07707c0f302]"
	save master_survey, replace
```

Validation to perform later:

- After a separately authorized run, confirm master_survey.dta, median_tenuregender_brand.dta and median_tenuregender.dta exist under C. Master Dataset/output.
- Confirm 7.1 and 7.3 read those exact paths; preserve the required execution order 7.2 before 7.1 before 7.3.

### A_HOST_PATH_CONFIG: Choose a project root compatible with the host and resolve hard-coded T: paths as one coherent directory tree.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_HOST_PATH_CONFIG
Evidence: E_MAIN_ANALYSIS, E_12_DIR_SWITCH, E_PROBE_STATA

Preparation / proposed procedure:

1. Either stage the project tree on a Windows host with the expected T: mapping or choose a Linux project root and adapt every [redacted-path-8de8923a2d96] path across all 12 scripts.
2. Preserve relative outputs such as 7.1’s cd ../output and the matching producer/consumer directories; review every import, use, save, export and log path.
3. Do not change an early call while leaving later consumers on the old root.

Validation to perform later:

- Perform a source-only path audit across all 12 do-files to confirm every T: reference is mapped consistently and each output matches its consumer.
- After a separately authorized setup, confirm the chosen root and required log/output directories exist before running code.

### A_GEODIST_SETUP: Add/configure Stata geodist required by the store-distance producer.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_GEODIST
Evidence: E_PROBE_GEODIST, E_PUBLIC_GEODIST, E_COORD_CHUNK_PRODUCER

Preparation / proposed procedure:

1. After a separate environment setup is authorized, install/configure geodist through its documented SSC route and make it visible on the Stata 18 adopath.
2. Retain observed statuses for the other invoked commands: eststo, esttab, estpost, icc, _gnvals and winsor are present.

Validation to perform later:

- Run `which geodist` in Stata 18 and confirm it resolves.
- In a future authorized run, verify the supplied geodist call syntax; do not execute author code during this assessment.

### A_OA6_COMPANION: Request complete author code or exact branch instructions for Online Appendix 6 robustness tests.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_OA6_ROBUSTNESS
Evidence: E_OA6_VARIANTS, E_OA6_VARIANTS_MORE, E_PUBLIC_TABLE_BRANCH, E_SALES_FILTER_AND_WINSOR, E_ATTENDANCE_FILTER, E_WINSOR_BUILD, E_NOVEMBER_SWITCH, E_INSPECT_CODE_SCAN

Preparation / proposed procedure:

1. Ask for the companion runner or variant table showing which upstream sales and attendance filters are reversed and how winsorized sales enter each model.
2. Preserve the original baseline branch; the existing November switch does not by itself implement zero-sales and alternate-attendance variants.

Validation to perform later:

- Verify every appendix variant maps to its stated output and uses the same identifiers and controls as its baseline table.
- Compare coefficients, sample sizes and captions with the relevant Online Appendix 6 tables after a separately authorized run.

### A_OA7_COMPANION: Request the power-simulation program or a fully specified replay recipe for Figure OA-7.1.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_OA7_POWER_WORKFLOW
Evidence: E_OA7_METHOD, E_OA7_SIMULATION, E_OA7_CONSTANTS, E_INSPECT_CODE_SCAN, E_2015_CONTEXT

Preparation / proposed procedure:

1. Ask for the simulator, parameter grid, random-seed convention, store/brand treatment assignment, time indexing, 100-replication loop and figure settings.
2. Ask whether the reported variance constants and literature-based creativity variance are complete simulation inputs; request 2015 data only if the intended replay re-estimates those variance components.
3. Do not independently rebuild the simulation or infer unreported values.

Validation to perform later:

- Verify the supplied procedure reproduces all three outcome panels and reported 80%-power thresholds under the stated 10% two-sided test.

### A_FULL_RUN_SEQUENCE: Use the producer-consumer sequence supported by current file paths after data, code, path and software prerequisites are resolved.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: run procedure
Evidence: E_POSTER_OUTPUT_11, E_ATTENDANCE_PRODUCER, E_PRESURVEY_PRODUCER, E_POSTSURVEY_PRODUCER, E_SALES_PRODUCER, E_COORD_PRODUCER, E_ACTIVITY_PRODUCER, E_72_MASTER_SAVE, E_71_MASTER_READ, E_STORE_DATA_PRODUCER, E_73_CUSTOMER_READ, E_POSTER_DV_PRODUCER, E_MAIN_ANALYSIS, E_CORR_COMMANDS, E_OA6_VARIANTS, E_OA7_METHOD

Preparation / proposed procedure:

1. Run independent preparation stages 1.1, 2.1, 3.1, 3.2, 4.1, 5.1 and 6.1 after inputs and redacted mappings are resolved; provide the distinct hand-coded poster input before running 1.2.
2. Run 1.2 after the output-directory correction.
3. Run 7.2 after 3.1 and 3.2; it produces the master survey and median files.
4. Run 7.1 after 2.1, 4.1, 5.1 and 7.2; it produces C. Master Dataset/output/store_data.dta.
5. Run 7.3 after 1.2, 7.1 and 7.2; it produces PosterData_DV and poster-preindicator datasets.
6. Run 8.0 after 7.1 and 7.3 and after 6.1 access aggregates. Keep logs and table CSVs; use the logged pwcorr output for OA5. Obtain the separate OA6 and OA7 companion instructions before claiming those appendix outputs are regenerated.

Validation to perform later:

- Verify every intermediate exists at the exact path consumed by the next script and matches its expected keys before continuing.
- Check 8.0 table CSVs and logged correlation matrices against appendix sample counts.
- Execution remains unverified until prerequisites are resolved and a separately authorized run is completed.


## Remaining issues and prerequisites

- I_REDACTED_MAPPINGS [unresolved; full_pipeline]: The supplied Stata files replace required author-specific store, brand, user, employee and survey corrections with redaction comments or placeholder lists. This includes the undefined `stores` expansion in 4.1; literal `XXX` brand loops; the 5.1 loop that writes mpr_coordinates_XXXX but later reads mpr_coordinates_XXX; and redacted map/filter blocks in 1.1, 2.1, 3.1, 3.2, 6.1, 7.1, 7.2 and 7.3. These values and rules cannot be reconstructed from the package, so the full preparation closure remains incomplete.
- I_POSTER_HANDOFF [unresolved; full_pipeline]: 1.1 saves poster_clean731 in C. Master Dataset/input and exports an Excel workbook, but 1.2 reads B. Data Preparation/01. Customer Panel Data/input/poster_clean731_Final_Stata.dta with additional hand-coded poster fields. No supplied script creates that exact file or documents the manual conversion/merge-key checks. The two files cannot be treated as aliases without author confirmation.
- I_12_OUTPUT_DIR [preparation; full_pipeline]: 1.2 changes to the customer-panel output directory, then changes to programs/logs to open the log and never changes back. Its relative Poster_AppRatings, temp1 and CustomerPanel_Dataset saves therefore land under programs/logs; 7.3 expects CustomerPanel_Dataset under the customer-panel output directory.
- I_72_OUTPUT_DIR [preparation; full_pipeline]: 7.2 changes into C. Master Dataset/input and saves master_survey plus both median files by relative name without changing directory. 7.1 and 7.3 read those files from C. Master Dataset/output. The actual producer-consumer order is 7.2 before 7.1, despite the 7.1/7.2 filename order.
- I_HOST_PATH_CONFIG [preparation; full_pipeline]: The scripts hard-code a Windows T: project root for reads, writes and logs, while the available Stata 18 runtime is on this Linux environment. A consistent project-root mapping or host-specific path adaptation is needed across every affected producer and consumer; changing only one call would leave later handoffs unresolved.
- I_OA6_ROBUSTNESS [unresolved; full_pipeline]: The current online appendix reports robustness variants for winsorized sales, zero-sales rows, alternate attendance cleaning, November inclusion and fixed effects. The supplied scripts include the sales/attendance filters, create sales_w, and expose a November switch, but do not implement a complete set of those alternative runs or a separate branch that preserves the baseline. Request the author’s companion code or precise variant recipe; do not infer the missing sample rules.
- I_OA7_POWER_WORKFLOW [unresolved; full_pipeline]: The current online appendix reports Figure OA-7.1 from 100 simulations, but none of the 12 supplied Stata programs contains a power-simulation routine. The appendix provides variance constants and a literature-based creativity variance; the author must confirm whether these values fully replace the historical-data variance-estimation step and provide the simulator, scenario grid, random-seed convention and figure-generation instructions. Do not require raw 2015 data unless the intended replay re-estimates those variance components.
- R_POSTER_REGISTRY [undetermined]: Poster registry workbook with July, August, October and December sheets, used to create the cleaned poster list. Required source columns include shop, brand, colors and the column renamed L; exact full schema and missing author-specific mappings still need author confirmation.
- R_TR_INDICATOR [undetermined]: Treatment indicator workbook read from both the customer-panel and master-dataset input folders; it must be staged at both exact locations because no supplied program copies it between them. Required columns include shop and tr.
- R_CUSTOMER_PANEL [undetermined]: Customer-panel application ratings in author Stata format, merged by poster and reshaped/aggregated into the poster-rating dataset. Required fields include poster, trial_name, bucket, time, rater_id, Assign_High_Income, Assign_Low_Income and Assign_Dimension.
- R_POSTER_HANDCODE [undetermined]: Distinct hand-coded poster dataset consumed by 1.2 Prepare Customer Ratings.do. Required columns include poster, shop, brand, name, empid, clear, hindi, english, colors2, colors3, imagepicture, multiple, alldups, tr and month. The only supplied producer saves poster_clean731, not this Final_Stata file.
- R_ATTENDANCE [undetermined]: Monthly promoter attendance workbook used to calculate unique promoters and shop-brand-week attendance. Required columns include date, shop, brand and name; the workbook must include the May 2016 through January 2017 sheets named by the script.
- R_PRE_MISSING_INFO [undetermined]: Separate pre-survey workbook used to add missing demographic information before the main pre-survey merge. Required columns include shop, shopname, brand, gender, education, tenure_company_coded and age.
- R_PRE_SURVEY [undetermined]: Quantitative manager pre-intervention survey workbook, reshaped by employee and question then averaged to shop-brand. Required columns include StoreCode, Brand, Name, TLName, Q and ANS.
- R_POST_SURVEY_LIST [undetermined]: Post-survey lookup workbook with Eid and TLid sheets linking response IDs to employee/team-leader shop and brand. Required columns include Eid, Tlid, shop and brand.
- R_POST_SURVEY_SPECIFIC [undetermined]: Additional shop-specific tenure/gender workbook imported and saved as postsurvey_scbl by the supplied post-survey program. It is read unconditionally, though no downstream consumer of postsurvey_scbl appears in the supplied scripts; confirm whether this read is intentional.
- R_POST_SURVEY [undetermined]: Main post-experimental manager survey workbook used to construct post shop-brand observations. Required columns include Q17_1, Q17_2, RecordedDate, Q5, Q6_1, Q6_2, Q7, Q8, Q10, Q12_1–Q12_4, Q13_1–Q13_3, Q14_1–Q14_3, Q15_1, Q15_3, Q15_4 and tenure_coded.
- R_STORE_SALES [undetermined]: Store-specific invoice CSV files expanded from the redacted `stores` list and imported one by one. Required raw fields include invoicedatetime, location, group2, salesamtincltax, amountexclvat, totalprofit, homecreditcharges and ishomecredit.
- R_MPR_COORD_NEW [undetermined]: New-store coordinate workbook, detail sheet, used to append geocoded store and head-office coordinates. Required columns include stata_store, lat and lon.
- R_MPR_COORD_OLD [undetermined]: Existing combined coordinate Stata file read by 5.1 before appending new coordinates. Required columns include stata_store, lat and lon; no supplied producer creates this input.
- R_STORE_CHARACTERISTICS [undetermined]: Store characteristics workbook merged with derived distances. Required columns include shop, store size, store age fields, address/market type, renovation/closure dates and closure status.
- R_EMPLOYEE_LIST [undetermined]: Employee-account mapping workbook required to connect activity logs to internal employee IDs and store/brand attributes. Required columns include user_name, store_code, employee_ID, brand and employee_internal_ID.
- R_ACTIVITY_LOG [undetermined]: Information-sharing-system activity export required to generate store-level total/active/login access frequencies. Required columns include employee_internal_ID, store_code, brand, action and timestamp.
- R_TENURE_BESTGUESS [undetermined]: Pre/post tenure-best-guess workbook used to generate master-survey medians even though the code comments that these estimates were not used in the final regression. Required sheets are bestguess_pre and bestguess_post, with shop, brand and tenure variables.
- R_TL_CHANGE [undetermined]: Team-leader-change workbook merged into the master survey dataset. Required columns include shop and TL_changed.
- SW_GEODIST [preparation_required]: The invoked geodist command is not present in the checked Stata 18 adopath; a public SSC repository route is documented.

## Review notes

- The initial and expanded evidence/requirements checkpoints are retained. The first attempt to append issue/action/dependency sections stopped before writing because a grouped dependency coverage check raised KeyError: 'dependency_id'; the corrected build uses an explicit grouped-ID conditional.
- The full workflow has 12 Stata entry files and no supplied analysis-ready dataset route; no analysis_only scope is justified.
- OA5 pairwise-correlation variables are computed in 8.0 and written to its text log; the appendix table layout may require manual assembly.
- OA6 does not include all reported alternative cleaning runs. OA7 reports variance constants; historical 2015 data are not treated as a separate live requirement unless variance re-estimation is confirmed as part of the intended replay.
- Catalog lookups for company retail sales, promoter attendance, panel ratings and store-coordinate sources returned no candidate records; this does not establish that no local or licensed route exists.
- All software checks used self-written Stata which/version probes only; no author program or dataset was run.
