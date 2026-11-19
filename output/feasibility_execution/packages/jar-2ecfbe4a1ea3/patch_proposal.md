# Patch proposal: jar-2ecfbe4a1ea3

Comply or Explain: Do Firms Opportunistically Claim Trade Secrets in Mandatory Environmental Disclosure Programs?

DOI: 10.1111/1475-679X.12583

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented FracFocus preparation, manual QGIS joins, monitor/weather merges, operator aggregation and Stata analysis for the manuscript and online appendix. The supplied identifier.txt is only a sample identifier list, so no analysis-only route is supported.

Entry points: `Jiang-datasheet-code-identifiers-and-log-files/python_code_files/Step1_mergeFracFocus.py`, `Jiang-datasheet-code-identifiers-and-log-files/python_code_files/Step2_cleanFracFocus.py`, `Jiang-datasheet-code-identifiers-and-log-files/python_code_files/Step3_DBSCAN.py`, `Jiang-datasheet-code-identifiers-and-log-files/python_code_files/Step4_mergeDBSCAN.py`, `Jiang-datasheet-code-identifiers-and-log-files/python_code_files/Step5_monitors.py`, `Jiang-datasheet-code-identifiers-and-log-files/python_code_files/Step6_PRISM.py`, `Jiang-datasheet-code-identifiers-and-log-files/python_code_files/Step7_aggregate_operator.py`, `Jiang-datasheet-code-identifiers-and-log-files/stata_code_files/code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 5/12583 - Comply-or-Explain-Do-Firms-Opportunistically-Claim-Trade-Secrets-in-Mandatory-Environmental-Disclosure-Program/jiang-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "aab7373ce30ecec06fe43d709a77cf25b34d263e781da82185492be6c861b94d"
    },
    {
      "path": "JAR-Volume 62/Issue 5/12583 - Comply-or-Explain-Do-Firms-Opportunistically-Claim-Trade-Secrets-in-Mandatory-Environmental-Disclosure-Program/jiang-online-appendix.pdf",
      "sha256": "c6c2398fe97eacda3aed5c34ff953e2c3e4a77ebe47650c00441f0740efcb106"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "7bc2d5a9c3a8666fd87029725f75448fdc450851d3f1eb0001bf2b72e9ee19ba"
}
```

## Proposed actions

### A_PANDAS_APPEND: Replace the removed Step 1 DataFrame.append call with an equivalent pd.concat operation in an authorized working copy.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_PANDAS_APPEND
Evidence: E_STEP1_APPEND, E_PYTHON_PACKAGES, E_PUBLIC_PANDAS_APPEND

**Proposed edit:** `Jiang-datasheet-code-identifiers-and-log-files/python_code_files/Step1_mergeFracFocus.py:17–17`
Source SHA-256: `342f42899e2aa71bf0fd796dcc6c2ae1b9dbca67ad8fcb6b542c1a9510cdf6c5`

pandas 3.0.6 no longer provides DataFrame.append; pd.concat with ignore_index=False retains the old append index behavior.

Current text:
```
    df_final = df_final.append(df)
```

Proposed replacement:
```
    df_final = pd.concat([df_final, df], ignore_index=False)
```

Preparation / proposed procedure:

1. Apply the one-line edit only in an authorized working copy after review.
2. Keep the 22-input loop order and the current row/index semantics.

Validation to perform later:

- After future authorization, run Step 1 on the full approved FracFocus input set and confirm merged_raw_original.csv preserves the expected rows, columns, date parsing and index behavior.

### A_FRACFOCUS: Identify an authorized FracFocus CSV export matching the author's 22-file historical input and all directly consumed chemical, well-identifier, operator, state and coordinate fields.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_FRACFOCUS
Evidence: E_DOC_FRACFOCUS_ACCESS, E_DOC_CHEM_INPUT, E_STEP1_PRODUCER, E_PUBLIC_FRACFOCUS, E_STEP2_FRACFOCUS_FIELDS, E_STEP4_RAW

Preparation / proposed procedure:

1. Review the official data dictionary and identify the historical release/date boundary used by the paper.
2. Obtain the CSV records into the raw source directory only after the applicable terms are understood.
3. Compare the consumed fields UploadKey, JobEndDate, CASNumber, PercentHFJob, APINumber, OperatorName, StateNumber, Latitude and Longitude with the supplied code; record release/version compatibility and any schema mapping.

Validation to perform later:

- Confirm the 22 expected inputs, all named consumed fields, unique job/CAS representation, date coverage and release-version differences before Step 1 and downstream Step 2/Step 4 consumers.

### A_FRACFOCUS_TERMS: Confirm which FracFocus terms govern the historical author export and whether the supplied cleaning/transformations are permitted for the current public export.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_FRACFOCUS_TERMS
Evidence: E_PUBLIC_FRACFOCUS_TERMS, E_DOC_FRACFOCUS_ACCESS, E_DOC_CHEM_INPUT

Preparation / proposed procedure:

1. Review the terms attached to the exact release intended for use.
2. If a term does not permit an authored transformation, identify an expressly authorized compatible route rather than changing or bypassing the data-use conditions.

Validation to perform later:

- Record the governing release terms and an authorized transformation path before any data processing.

### A_UNIQUECAS: Obtain the author-prepared uniqueCAS.csv positional mapping and establish its provenance, source/history and compatibility with the Step 2 mapping operation.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_UNIQUECAS
Evidence: E_WORKITEM, E_DOC_CHEM_INPUT, E_STEP2_UNIQUECAS_MAP

Preparation / proposed procedure:

1. Locate the file in the authorized study workspace or request the author-prepared mapping.
2. Confirm it is headerless with position 0 serving as the CASNumber mapping key and the following value column serving as CAS_cleaned; do not require invented header names.
3. Document the mapping's source/history and verify the actual mapping content against the documented CASNumber-to-CAS_cleaned operation and SD-row drop.

Validation to perform later:

- Confirm the provided mapping covers the CAS values required by the approved study input and matches the documented Step 2 semantics before running Step 2; source history and pandas compatibility must also be resolved.

### A_WELLDB: Identify the authorized author-prepared header_prod.csv or compatible WellDatabase delivery with the exact API/Play/coordinate/six-month-production fields and API-number join.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_WELLDB
Evidence: E_DOC_WELLDB, E_STEP2_WELLDB, E_PUBLIC_WELLDB_API, E_DOC_PROPRIETARY

Preparation / proposed procedure:

1. Confirm whether the 2022 study input was a vendor export, REST route or an author-prepared table; an API well number is an identifier, not proof of REST API use.
2. Obtain the compatible file or document the allowed export/API account route and retain its product vintage and coverage dates.
3. Check the exact fields API, Play, Latitude, Longitude, FirstSixMonthOil and FirstSixMonthBOE, and the APINumber-to-API left-join key.

Validation to perform later:

- Confirm the exact selected fields, APINumber-to-API join, required study coverage and route compatibility; record applicable access terms without assuming an API account or license from the documentation page.

### A_STEP4_INPUTS: Identify and supply the five author-prepared Step 4 tables with their source, exact schema, period, units and construction definitions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_STATE_MAN, R_DISC_STRICT, R_BUDGET, R_TORT, R_OPERATOR_MATCH
Evidence: E_STEP4_STATE_MAN, E_STEP4_DISC_BUDGET, E_STEP4_TORT, E_STEP4_OPERATOR

Preparation / proposed procedure:

1. For state_man.csv, document the mandate date source and StateNumber/date keys.
2. For disc_strict.csv, document the strict-disclosure construction and StateNumber key.
3. For budget_staff_gdp.csv, document the state-year measure, spend/oggdp units and source.
4. For tort_filedate.csv, document OperatorName/StateNumber date provenance and coverage.
5. For operator_match.csv, document the operator-name-to-ticker source, mapping date and duplicate-resolution rule.

Validation to perform later:

- Verify the required keys and columns in each exact file before Step 4; preserve unresolved coverage or mapping conflicts.

### A_QGIS_EXPORTS: Prepare each separately required QGIS export by following the supplied manual join/intersection/radius procedures and resolve the remaining layer, coordinate-system, key and output-schema choices.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_TIGER_2019, R_URBAN_JOINED, R_RIVER_JOINED, R_RIVER_JOINED_5KM, R_RIVER_JOINED_10KM, R_WELL_JOINED, R_SHALENET_JOINED, R_GRID_JOINED, SW_QGIS, I_QGIS_SPEC, I_URBAN_LAYER_SELECTION
Evidence: E_STEP4_URBAN, E_STEP5_QGIS, E_STEP6_GRID_QGIS, E_DOC_QGIS, E_PUBLIC_TIGER_URBAN, E_QGIS_PATH_PROBE

Preparation / proposed procedure:

1. Make an appropriate QGIS application available through the analyst's supported GUI or executable path and confirm its version; the audit's one PATH lookup found no qgis command and did not test other installation routes.
2. For urban_joined.csv, use the documented 2019 TIGER/Line and well-point intersection; resolve the Urban Areas versus MMSA layer wording and preserve the downstream NAME field.
3. For the five Step 5 exports, follow the documented river 2.5/5/10 km, well 500 m and Shale Network 2.5 km joins with their stated nearest-neighbor settings; identify exact source layers and keys.
4. For grid_joined.csv, follow the documented nearest PRISM grid-to-well join with one neighbor and confirm the grid keys and coordinate systems.
5. Record QGIS version, coordinate reference systems, distance units, maximum-neighbor settings and row/cardinality behavior for every export.

Validation to perform later:

- Verify each separately named CSV follows the supplied manual producer and check its exact key/schema/cardinality against its own Python consumer before execution.
- Confirm the selected 2019 polygon layer and urban NAME field match the author definition.
- Verify the accessible QGIS version supports the documented manual join/intersection operations before performing those author-described stages.

### A_WQP: Retrieve the author-period WQP site and sampling-activity profiles through the official portal, preserving the 2008–2021 study window and identifiers.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_WQP_SITES, R_WQP_SAMPLING
Evidence: E_DOC_MONITOR_PERIODS, E_STEP5_WQP, E_PUBLIC_WQP, E_PUBLIC_WQP_VERSION, E_PUBLIC_WQP_PROFILES, E_PUBLIC_WQP_ACTIVITY

Preparation / proposed procedure:

1. Select Site Data Only for spatial monitor layers and Sampling Activity for observation dates.
2. Use the author-documented 2008–2021 window and retain MonitoringLocationIdentifier/ActivityStartDate.
3. Record which WQX/NWIS profile and release version supplies each table; do not assume WQX2.2 and WQX3.0 are interchangeable.

Validation to perform later:

- Verify the required site IDs, coordinates, activity dates and historical coverage before the QGIS and Step 5 stages.

### A_SHALENET: Select an authorized Shale Network snapshot or cited dataset compatible with the author's 2011–2021 study data and required SiteID/date/coordinate fields.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SHALENET
Evidence: E_DOC_MONITOR_PERIODS, E_STEP5_SHALENET, E_PUBLIC_SHALENET_SNAPSHOT, E_PUBLIC_SHALENET_ACCESS

Preparation / proposed procedure:

1. Compare the available dated snapshot/dataset descriptions to the author sample period and required site/sample fields.
2. If a newer extract is needed, obtain it only through an authorized Shale Network route; no contact or download was made during this audit.

Validation to perform later:

- Confirm SiteID, LocalDateTime and site-coordinate coverage and preserve the source metadata/data-use terms.

### A_PRISM: Prepare the PRISM daily-to-monthly grid panels used by Step 6, retaining the documented 2020–2021 same-month prior-three-year average and the author grid identifiers.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_PRISM, I_PRISM_YEAR_PRODUCERS
Evidence: E_DOC_PRISM_METHOD, E_STEP6_DAILY, E_STEP6_2012_OUTPUT, E_STEP6_ANNUAL_FILES, E_PUBLIC_PRISM, E_PUBLIC_PRISM_ELEMENTS

Preparation / proposed procedure:

1. Use an authorized PRISM daily product for the analysis dates and preserve the 4-km/2.5-mile grid resolution, tmin/tmax/precipitation definitions and date convention.
2. Document the mapping from raster cells to gridNumber/fips/latitude/longitude and to the code's tMin/tMax/prec fields.
3. Provide or produce 2013–2019 monthlevel panels and construct 2020–2021 same-month averages from the prior three years.
4. Create grid.csv, pause for the manual nearest QGIS join to wells, then resume the consumer portion of Step 6.

Validation to perform later:

- Confirm all 2012–2021 monthly file names, fields, units, grid keys, expected calendar months and the 2020–2021 averaging rule before creating fracfocus_welllevel.csv.

### A_SINGLETONS: Obtain singletons.csv or its documented producer and clarify how UploadKey values are defined and selected for Step 7 exclusion.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SINGLETONS
Evidence: E_STEP7_INPUTS

Preparation / proposed procedure:

1. Locate the author-prepared exclusion list or document the exact rule and source table used to generate it.
2. Keep the supplied sample and within-operator construction unchanged.

Validation to perform later:

- Verify that UploadKey is present and the exclusion list matches the intended author sample before Step 7.

### A_FINANCIAL: Use the readable local COMP.FUNDA candidate to prepare the Step 7 annual financial input, with an explicit fyear/tic-to-year/ticker mapping and the author's fiscal/calendar convention.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_FINANCIAL, I_COMP_FINANCIAL_ALIGNMENT
Evidence: E_COMP_CATALOG, E_COMP_PROBE, E_STEP7_FINANCIAL, E_APPENDIX_COMP_FACTIVA

Preparation / proposed procedure:

1. Preserve the probed source columns fyear, tic, at, dltt, dlc, seq, ni, csho, prcc_f, ceq, che, capx, xrd and sale.
2. Confirm whether year means fiscal or calendar year and how tic is linked to the Step 4 operator ticker before building financial.csv.
3. Use a bounded schema check first, then confirm exact required study-year availability without treating a one-row probe as a coverage estimate.

Validation to perform later:

- Verify output year/ticker keys and every downstream financial variable against Step 7 before Step 7 execution.

### A_FACTIVA: Identify the authorized Factiva annual media-count route and the author table's year/ticker matching and sample-period coverage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_FACTIVA
Evidence: E_STEP7_FACTIVA, E_APPENDIX_COMP_FACTIVA, E_DOC_PROPRIETARY

Preparation / proposed procedure:

1. Locate the author-prepared factiva.csv or document an authorized Factiva export route and product scope.
2. Confirm media_num's annual unit, year/ticker key and treatment of missing coverage.

Validation to perform later:

- Check year, ticker and media_num fields and the exact operator-year coverage before Step 7.

### A_DBSCAN_ALL_PLAYS: Supply or document the complete active all-play DBSCAN producer required by the code and appendix parameter table; retain the Austin Chalk example and Granite Wash branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_DBSCAN_PLAY_COVERAGE
Evidence: E_STEP3_AUSTIN_READ, E_STEP3_GRANITE_READ, E_STEP3_GRANITE_NOISE, E_STEP3_GRANITE_CLUSTERS, E_STEP3_REPEAT_COMMENT, E_APPENDIX_DBSCAN_PARAMETERS

Preparation / proposed procedure:

1. Identify the author-intended executable producer for each required play using its listed epsilon/minPts values.
2. Produce the per-play noisekey and cluster_1k files that Step 4's directory globs consume.
3. Do not silently omit plays or convert the comment into an assumed producer.

Validation to perform later:

- Before Step 4, verify every included play has its expected noise/cluster files and keys; compare the active method and parameters with the appendix.

### A_REFINED_DISTANCE: Follow the supplied one-neighbor QGIS nearest-monitor procedure and resolve the remaining source geometry, keys, distance units and output fields for refined_distance.csv.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_REFINED_DISTANCE, I_REFINED_DISTANCE_QGIS
Evidence: E_STATA_REFINED_DISTANCE, E_DOC_QGIS

Preparation / proposed procedure:

1. Use the documented nearest-monitor join and one-neighbor setting.
2. Identify the exact geometry inputs, coordinate systems, distance units, exported keys and fields expected by the Stata do-file.
3. Place the compatible export at final_data/refined_distance.csv or align its path with the Stata import in the portable working copy.

Validation to perform later:

- Verify the export matches the Stata variables and keys and resolves at the configured final_data path.

### A_PATHS: Create a portable working copy with one consistent root and align every Python/Stata input and output path without modifying the source archive.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_MERGED_RAW_PATH, I_HARDCODED_PATHS, I_FINAL_DATA_PATHS
Evidence: E_STEP1_PATH, E_STEP1_PRODUCER, E_STEP2_ROOT, E_STEP4_RAW, E_STEP6_WELLLEVEL, E_STEP7_WITHIN_OUTPUT, E_STEP7_FACTIVA, E_STEP7_VALIDATION, E_STATA_WITHIN_PATH, E_STATA_BETWEEN_PATH, E_STATA_VALIDATION_PATH, E_STATA_WELLLEVEL_PATH

Preparation / proposed procedure:

1. Make Step 2 read the exact merged_raw_original.csv produced under Fracfocus_raw.
2. Rebase the absolute Windows paths to a writable project root while preserving the existing subfolder roles.
3. Either write Step 7 outputs to final_data or update the do-file imports so every producer and consumer names the same file.
4. For future Stata use, follow the workspace common README's relative or [redacted-path-42901eaa63c4] host-wrapper path rule.

Validation to perform later:

- Resolve every frozen file edge to one producer/consumer location before any authorized run; verify no output is silently moved to a different basename or directory.

### A_INPUT_CLOSURE: Resolve the remaining author-prepared inputs and document all manual stage sources before execution; the package's identifier list is not a full analysis dataset.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_INPUT_CLOSURE
Evidence: E_WORKITEM, E_DOC_ENTRY, E_STEP4_STATE_MAN, E_STEP4_DISC_BUDGET, E_STEP4_TORT, E_STEP4_OPERATOR, E_STEP7_INPUTS, E_STEP7_FINANCIAL, E_STEP7_FACTIVA, E_STEP4_URBAN, E_STEP5_QGIS, E_STEP6_GRID_QGIS, E_STATA_REFINED_DISTANCE

Preparation / proposed procedure:

1. Reconcile each missing file named in D0001–D0044 with a supplied compatible input, directly evidenced producer, or explicit unresolved source contract.
2. Keep public, commercial/local and unknown routes distinct, and record any licensing or terms checks without sending requests during this audit.

Validation to perform later:

- Confirm every dependency row has one justified disposition and every required input has a route or precise unresolved action.

### A_RUN_SEQUENCE: After the Step 1 source edit and Step 2 pandas compatibility decision, path work, data closure and QGIS preparation, run the author workflow in its evidenced order.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_INPUT_CLOSURE, I_DBSCAN_PLAY_COVERAGE, I_PRISM_YEAR_PRODUCERS, I_QGIS_SPEC, I_REFINED_DISTANCE_QGIS, I_MERGED_RAW_PATH, I_HARDCODED_PATHS, I_FINAL_DATA_PATHS, I_PANDAS_APPEND, I_PANDAS_LEGACY_APIS
Evidence: E_DOC_ENTRY, E_STEP1_PRODUCER, E_STEP2_SPLIT, E_STEP3_REPEAT_COMMENT, E_STEP4_URBAN, E_STEP5_QGIS, E_STEP6_GRID_QGIS, E_STEP7_WITHIN_OUTPUT, E_STATA_DRIVER, E_STATA_REFINED_DISTANCE

Preparation / proposed procedure:

1. Run Step 1 then Step 2 after their file/path prerequisites are satisfied.
2. Run the complete all-play Step 3 producer, prepare the Step 4 QGIS urban layer and other Step 4 inputs, then run Step 4.
3. Prepare the Step 5 QGIS monitor exports and source activities, then run Step 5.
4. Prepare 2012 daily and 2013–2021 monthly PRISM panels; run Step 6 through grid.csv, pause for the QGIS nearest-grid join, then resume Step 6.
5. Run Step 7 after singletons/financial/Factiva inputs are complete; create refined_distance.csv by the documented QGIS stage; run the Stata do-file after aligning final_data paths.

Validation to perform later:

- At each handoff verify exact path, keys, schema, play/year coverage and expected output names before proceeding; do not treat a run log as proof of current data compatibility.

### A_PANDAS_COMPATIBILITY: Select an author-supported pandas release for the Step 2 calls or specify source-preserving replacements for its legacy read_csv and groupby APIs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_PANDAS_LEGACY_APIS
Evidence: E_STEP2_SQUEEZE, E_STEP2_GROUPBY47, E_STEP2_GROUPBY63, E_PYTHON_PACKAGES

Preparation / proposed procedure:

1. Confirm the expected Series/DataFrame shapes for read_csv(squeeze=True) and each tuple-based groupby selection from the already-documented workflow.
2. Choose an author-supported pandas environment or exact source-preserving changes; do not infer a compatible release from the removed calls alone.

Validation to perform later:

- Before any separately authorized run, verify every Step 2 API call against the selected pandas release or reviewed source replacements without changing study rows, group keys or output schemas.


## Remaining issues and prerequisites

- I_PANDAS_APPEND [preparation; full_pipeline]: Step 1 calls DataFrame.append at line 17; pandas 3.0.6 no longer provides it. A one-line pd.concat replacement with ignore_index=False preserves the original append index and column-union behavior as a supported working-copy edit proposal.
- I_MERGED_RAW_PATH [preparation; full_pipeline]: Step 1 writes merged_raw_original.csv under its Fracfocus_raw working directory, while Step 2 changes to the FracFocusCSV parent and reads the same basename there. The producer/consumer paths must be aligned.
- I_HARDCODED_PATHS [preparation; full_pipeline]: The Python stages and Stata do-file contain hard-coded Windows paths. This host uses a Linux workspace and the common README specifies host-wrapper paths must be relative or under [redacted-path-42901eaa63c4]; no author code was run.
- I_FINAL_DATA_PATHS [preparation; full_pipeline]: Step 7 writes fracfocus_within_op.csv, fracfocus_between_op.csv and inn_validation.csv in the project root, while the do-file imports them from final_data; Step 6's well-level output is likewise written in the project root but imported from final_data.
- I_DBSCAN_PLAY_COVERAGE [unresolved; full_pipeline]: The supplied Step 3 reads Austin Chalk for a kNN example and actively creates noise/cluster outputs only for Granite Wash, then comments to repeat the process for all shale samples. Step 4 globs those per-play outputs and the appendix lists play-specific parameters, so the full-play producer is missing.
- I_PRISM_YEAR_PRODUCERS [unresolved; full_pipeline]: Step 6 actively builds only 2012monthlevel.csv, then reads 2013monthlevel.csv through 2021monthlevel.csv. Its comment to repeat for all years is not an active producer; 2020–2021's documented averaging rule also needs to be encoded or supplied as prepared panels.
- I_QGIS_SPEC [unresolved; full_pipeline]: The datasheet and source comments explicitly provide manual QGIS producers for the urban, river/well/Shale Network monitor and PRISM grid exports, including the named outputs and stated join/radius settings. Remaining uncertainty concerns exact source layers, QGIS availability/version, coordinate systems, keys, output columns and row/cardinality contracts; the completed exports are not in the package. A single PATH lookup did not find the qgis executable; GUI/other-path availability is unverified, so this is a setup/configuration task, not a global access barrier.
- I_URBAN_LAYER_SELECTION [unresolved; full_pipeline]: Step 4's QGIS comment says 2019 TIGER/Line and MMSA polygons, while the output is converted to an urban flag using nonmissing NAME. The intended 2019 Urban Areas versus metropolitan/micropolitan layer must be confirmed before creating urban_joined.csv.
- I_REFINED_DISTANCE_QGIS [unresolved; full_pipeline]: The Stata file imports final_data/refined_distance.csv and its comments specify the manual one-neighbor QGIS producer. The completed table is absent; exact source geometry, keys, distance units and consumed fields remain unresolved.
- I_FRACFOCUS_TERMS [unresolved; full_pipeline]: The current FracFocus download terms say its data may not be altered, while the author workflow cleans and transforms the disclosures. The terms applicable to the historical author export and the intended transformations need confirmation; this is not a conclusion about legal permissibility.
- I_INPUT_CLOSURE [unresolved; full_pipeline]: The author package contains source code, documentation and an identifier list, but no full analysis datasets or required prepared CSVs. Several mandatory files have no documented active producer or exact author route, so full dependency closure is incomplete.
- I_COMP_FINANCIAL_ALIGNMENT [unresolved; full_pipeline]: COMP.FUNDA is a readable local candidate with the financial measures and fyear/tic fields, but the annual fiscal-year-to-well-calendar-year convention and ticker linkage used to build financial.csv are not specified.
- I_PANDAS_LEGACY_APIS [unresolved; full_pipeline]: Step 2 also uses legacy read_csv(squeeze=True) and tuple-based groupby column selections. Their compatibility with the installed pandas 3.0.6 and a semantics-preserving source change or author-supported compatible release remain unverified; no parser or code trial was run.
- R_FRACFOCUS [undetermined]: The 22 numbered FracFocus CSVs are the raw chemical/disclosure input. Step 1 derives date/year/month from JobEndDate; Step 2 consumes UploadKey, APINumber and OperatorName, and Step 4 consumes UploadKey, StateNumber, Latitude and Longitude. The exact historical schema and coverage must match the supplied pipeline.
- R_UNIQUECAS [undetermined]: Step 2 reads uniqueCAS.csv as a headerless positional mapping: column 0 supplies CASNumber lookup keys and the value column supplies CAS_cleaned values. It maps CASNumber to CAS_cleaned and drops rows mapped to SD. The mapping contents, source/history and present-file compatibility remain unverified.
- R_WELLDB [undetermined]: Step 2 reads header_prod.csv, selects API, Play, Latitude, Longitude, FirstSixMonthOil and FirstSixMonthBOE, then left joins FracFocus APINumber to WellDatabase API. The product vintage, coverage and accessible delivery remain unverified.
- R_STATE_MAN [undetermined]: state_man.csv provides state mandate dates for the Step 4 state/date merge; its source, history and file contract are not supplied.
- R_DISC_STRICT [undetermined]: disc_strict.csv is merged by StateNumber in Step 4; the strict-disclosure measure's source, construction and additional fields are not provided.
- R_BUDGET [undetermined]: budget_staff_gdp.csv is a state-year input to the Step 4 budget_high construction; source, period and units must be established.
- R_TORT [undetermined]: tort_filedate.csv supplies operator/state lawsuit dates for the Step 4 post-tort indicator; its source and coverage are not provided.
- R_OPERATOR_MATCH [undetermined]: operator_match.csv maps operator names to public-market tickers for Step 4; the matching source, key quality and coverage are unspecified.
- R_TIGER_2019 [undetermined]: The documented urban QGIS stage needs a 2019 TIGER/Line polygon layer and the upstream well coordinates. The code says MMSA polygons while the public 2019 product is titled Urban Areas; the exact layer selection is unresolved.
- R_WQP_SITES [undetermined]: Water Quality Portal site metadata supplies monitor locations for the manual river/well monitor joins; the author's exact site export and local layer are absent.
- R_WQP_SAMPLING [undetermined]: frac_monitor_sampling.csv supplies WQP activity dates used to determine whether linked monitors were sampled within 365 days.
- R_SHALENET [undetermined]: shalenet_raw.csv supplies Shale Network sampling dates/site identifiers used in Step 5, and site coordinates are also needed for the manual QGIS join.
- R_PRISM [undetermined]: Step 6 needs daily grid-level tMin, tMax and precipitation observations for 2012–2019, with 2020–2021 values defined as same-month averages over the prior three years. Exact grid identifiers and monthly file construction remain to be aligned.
- R_SINGLETONS [undetermined]: singletons.csv supplies UploadKey values excluded by Step 7; its producer and definition are not included.
- R_FINANCIAL [undetermined]: Step 7 needs annual operator financial fields for size, leverage, ROA, Tobin's Q, cash, capex, R&D and profit margin. A readable local COMP.FUNDA candidate contains the required measures plus fyear/tic, but the author fiscal/calendar-year and ticker-link convention for the year/ticker merge remains unverified.
- R_FACTIVA [undetermined]: Step 7 needs annual Factiva media_num values keyed by year/ticker; the dataset, account route and date coverage are not supplied.
- R_URBAN_JOINED [undetermined]: urban_joined.csv is a separately consumed Step 4 table from the manual well-point/polygon join; Step 4 uses NAME to form the urban flag. Its complete export contract and intended polygon layer remain unresolved.
- R_RIVER_JOINED [undetermined]: river_joined.csv is an independently consumed Step 5 QGIS export for the documented baseline river-monitor match. Its exact source layer, key and output-column contract remain unresolved.
- R_RIVER_JOINED_5KM [undetermined]: river_joined_5km.csv is a separately consumed Step 5 QGIS export for the 5 km river-monitor match. Its exact site, distance, key and output-column contract is not supplied.
- R_RIVER_JOINED_10KM [undetermined]: river_joined_10km.csv is a separately consumed Step 5 QGIS export for the 10 km river-monitor match. Its exact site, distance, key and output-column contract is not supplied.
- R_WELL_JOINED [undetermined]: well_joined.csv is an independently consumed Step 5 QGIS export for the documented 500 m well-monitor match. Its exact source layer, key and output-column contract remain unresolved.
- R_SHALENET_JOINED [undetermined]: shalenet_joined.csv is an independently consumed Step 5 QGIS export for the documented 2.5 km Shale Network match. Its exact source layer, key and output-column contract remain unresolved.
- R_GRID_JOINED [undetermined]: grid_joined.csv is an independently consumed Step 6 QGIS export matching the PRISM grid to well locations. Its exact grid key, neighbor fields and output schema are not supplied.
- R_REFINED_DISTANCE [undetermined]: final_data/refined_distance.csv is an independently consumed Stata input from the documented manual nearest-monitor QGIS join. Its exact source layers, keys, distance units and columns remain unspecified.
- SW_QGIS [preparation_required]: The qgis executable was not found on the checked PATH. This PATH-only result does not establish global absence; provide or identify an accessible compatible QGIS installation and confirm its version for the manual workflow.

## Review notes

- Static feasibility assessment only. No author source, statistical model, parser, Stata model, SAS startup, or QGIS workflow was executed; no data/API/archive payload was requested or downloaded.
- The candidate inventory contains documentation, code, an identifier list, HTML exports and an old output log; identifier.txt is not the analysis panel. Its registered D0001–D0044 checklist is fully accounted for in dependency_review.
- The candidate-free source contract confirms uniqueCAS.csv is read as a headerless positional CASNumber-to-CAS_cleaned mapping, with rows mapped to SD dropped. The actual mapping values and source/history remain unknown; original source-display and helper-version capture limits stay in preserved process records and are not scientific evidence.
- The local COMP.FUNDA probe read one row and verified the requested source columns, including fyear/tic; it does not establish study-period coverage. The open issue is the specific fiscal/calendar-year and ticker-link convention, not a full-data sweep requirement.
- The author's cited Columbia PRISM URL returned 404 on 2026-11-12. The official PRISM daily product is a candidate route for study years; grid identifiers, raster-to-.dta mapping and the missing 2013–2021 monthly producers remain unresolved.
- The current FracFocus terms mention no alteration; this is recorded as a use-terms clarification, not a legal conclusion or an access barrier. The exact historical author export terms were not checked.
- Public-source checks were static landing/documentation pages only. The Shale Network page lists a dated June 2022 snapshot; no dataset request or contact was made.
- The first populated draft and its actual builder/capture history are preserved byte-exactly as checkpoint 01. This checkpoint was built without editing author sources or shared helpers.
- The urban, five Step 5, grid and refined-distance QGIS exports are separately consumed required inputs and are tracked as separate unverified requirements. The supplied datasheet/source comments explicitly document their manual producer procedures and named outputs; remaining route details concern exact layers, fields, keys, coordinate systems and compatibility.
- Pandas 3.0.6 conflicts with Step 1 DataFrame.append; an exact pd.concat edit is proposed as preparation. Step 2 also contains legacy pandas API patterns whose compatibility or semantics-preserving source changes remain unresolved; no author code or parser was run.
- Public WQP quote fragments from the same URL are literal and total fewer than 25 words; the site-only and sampling-activity profiles are cited separately.
- The sole QGIS software check was stdlib shutil.which('qgis'): the executable was not on the current PATH. This does not prove the application is globally absent; QGIS accessibility/version remains a setup check before the documented manual GIS stages.
- The failed finalizer required exact successful software proof names. The prior bundled Python-package record is split into pandas, numpy, scipy, scikit-learn, matplotlib and tqdm entries matching the exact keys in the existing metadata-only probe; no packages were imported or author code run.
