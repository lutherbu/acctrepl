# Patch proposal: jar-348577807f0c

Tax Subsidy Information and Local Economic Effects

DOI: 10.1111/1475-679X.12591

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow: R county employment panel construction, Stata subsidy preparation and county regressions, subsequent-subsidy descriptives, MSU state-year preparation, and the separate state/program-year disclosure analyses. The active main-analysis path excludes megadeals; its documented inclusion alternative is retained separately with its own unresolved sample input. The order between the MSU merge producer, county panel, subsidy sample and later state/program models also remains unresolved.

Entry points: `assemble_county_data_final.R`, `clean_msu_data_final.do`, `regressions_final.do`, `state_by_year_disclosure_dynamics_final.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 2/12591 - Tax-Subsidy-Information-and-Local-Economic-Effects/dlrdatasheetcodeidentifierandlogfiles.zip",
      "sha256": "d4096d86693aed686bd5d7bcce59c93511cdb8511ceb5b178415be145152355a"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "c010e99d06394d0864f94c279fd0d764577239a5403562187b9ee462936e63da"
}
```

## Proposed actions

### A_QCEW_ACQUIRE: Acquire and stage the documented annual QCEW input series for the R county-construction branch.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_BLS_QCEW
Evidence: E_BLS_PUBLIC, E_R_BLS_YEARS_START, E_R_BLS_YEARS_END, E_R_BLS_FIELDS, E_BLS_LAYOUT

Preparation / proposed procedure:

1. From the official BLS QCEW page, obtain the NAICS annual-average single-file product for every year 2001–2019; retain one archive per year.
2. Place archives at the author-named Data/BLS/<year>_annual_singlefile.zip paths after confirming the R working directory; rename annual_avg_estabs_count to annual_avg_estabs in the prepared CSV because that is the field name consumed by the supplied code.
3. Keep county/state/national and ownership/industry records required by the supplied filters; do not substitute quarterly or by-area products.

Validation to perform later:

- After an authorized data-preparation run, verify each annual CSV has the source fields in the official layout, the prepared establishment field has the author-expected name, and the combined panel contains the full 2001–2019 sequence.
- Verify the 2015 panel's one-year-ahead outcomes can draw on 2016 records.

### A_STATE_GDP: Confirm and acquire a compatible BEA state GDP product, then reshape it for the R and Stata consumers.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_STATE_GDP
Evidence: E_BEA_PUBLIC, E_R_GDP, E_R_GDP_MERGE, E_CONTROLS_GDP

Preparation / proposed procedure:

1. Confirm which annual BEA table and price basis matches the authors' all-industry GDP series; the current page supports a state GDP source but not this exact unit mapping.
2. Obtain the selected state-level series and reshape annual values to the author file's GeoFIPS/Year/Description/GDP form, retaining state identifiers and the all-industry total.
3. Place or path-map the same logical GDP product for both the R Data/StateGovt reference and the Stata StateGovt reference once the project root is confirmed.

Validation to perform later:

- Before any analysis execution, compare the source table's state identifiers, years, industry-total row and units to the supplied joins and model uses.
- After authorized preparation, verify R and Stata resolve the same logical state-year series.

### A_PUBLIC_MINIMUM_WAGE: Resolve a historical minimum-wage series compatible with the author-prepared state-year file.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_MINIMUM_WAGE
Evidence: E_BERKELEY_PUBLIC, E_DOC_MINWAGE, E_R_MINWAGE

Preparation / proposed procedure:

1. Use the UC Berkeley ordinance inventory as a candidate source and obtain the historical workbooks or author-prepared input covering the panel years.
2. Preserve the state, county/area, federal, effective-rate and lag fields expected by the R program; document transformations and version dates.
3. Do not treat the current ordinance list alone as a historical state-year panel.

Validation to perform later:

- Verify historical year coverage, geographic keys, federal/state rates, and each effective/lag column against the R import contract before the future R run.

### A_CENSUS_STATE_SERIES: Obtain the exact Census/ACS state and county series and restore their documented county-preparation handoffs.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_STATE_EDUCATION, R_STATE_POPULATION, R_COUNTY_EDUCATION, R_COUNTY_POPULATION, I_COUNTY_CENSUS_PRODUCERS
Evidence: E_CENSUS_PUBLIC, E_DOC_ACS, E_DOC_CENSUS_POP, E_COUNTY_EDUC_COMMENTED, E_COUNTY_POP_COMMENTED, E_PREPROC_COUNTY_EDUC_CONSUMER, E_PREPROC_COUNTY_POP_CONSUMER

Preparation / proposed procedure:

1. Confirm the exact state education and population tables and their year ranges; the current Census landing page does not establish the author's historical contracts.
2. For county education, obtain the named 2008 S1501 workbook plus the prior county education panel and confirm the 2008 value conversion and county FIPS keys.
3. For county population, obtain the 25–64 county series with the lag history needed for regression years, and confirm whether to reactivate the existing commented producer block or supply its final intermediate.
4. Keep state population, county education and county population as separate logical inputs.

Validation to perform later:

- Before a future Stata run, verify county/state identifiers, education units, population age range and history required by 2008–2015 outcomes/lags.
- After author clarification, validate that each active merge receives its named intermediate.

### A_R_AUXILIARY_INPUTS: Obtain the distinct R auxiliary files and their version/field contracts, including files that the current R source reads without later use.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_UNEMPLOYMENT, R_STATUTORY_TAX, R_APPORTIONMENT, R_GOVERNOR_ELECTIONS, R_RIGHT_TO_WORK, R_BEA_PCE, R_GIROUD_RAUH
Evidence: E_R_UNEMP, E_R_TAX, E_R_APPORT, E_R_ELECTIONS, E_R_RTW, E_R_STATE_POP, E_R_PCE, E_R_GIR, E_DOC_GIR, E_INVENTORY

Preparation / proposed procedure:

1. For Unemployment_Rates_By_State.csv, State_TopTaxRates.csv, YoY_Apportionment.csv, governor_elections_all.csv and right_to_work_state_list.csv, request the exact author-prepared files, sources, years and raw headers individually.
2. For state_populations.csv and personal_consumption_all.csv, confirm why the active reads remain and identify the precise source series; do not treat the loaded objects as analysis inputs beyond what the supplied code uses.
3. For giroud_rauh_controls.csv, obtain the cited archive and the authors' later-year supplements with their source years, field mapping and construction notes.
4. If authors confirm an actively read but unused table can be omitted, make only the exact corresponding source edits in a later authorized patch review.

Validation to perform later:

- Run bounded metadata checks on each received file separately and compare all source fields, geography keys, units and historical ranges to the exact R and Stata reads.
- After any author-approved source edit, re-review the full script's read/merge closure before execution.

### A_UNION_SERIES: Identify the exact private-sector union membership/coverage series used by both languages.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_UNION_MEMBERSHIP
Evidence: E_R_UNION, E_CONTROLS_UNION, E_DOC_ACS, E_INVENTORY

Preparation / proposed procedure:

1. Obtain the author-used UnionMembership_All.csv and its source citation/version; confirm how its membership, coverage and annual changes relate to the author's documented source description.
2. Keep a single logical series, then resolve the two relative roots after the shared project directory is confirmed.

Validation to perform later:

- Verify state/year keys, private-sector subset, X.Mem/X.Cov and change columns, and Stata's 2003–2015 control coverage before a future run.

### A_GJF_ACQUIRE: Obtain the exact Good Jobs First Subsidy Tracker release used by the author code.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_GJF_SUBSIDY
Evidence: E_DOC_SUBSIDY, E_DOC_SUBSIDY_VINTAGE, E_GJF_RAW_CONTRACT, E_GJF_RAW_FIELDS

Preparation / proposed procedure:

1. Request or obtain the December 2021 file from the documented Good Jobs First route or authors' archived copy; the current audit did not verify the historical download.
2. Record release date and the source's primary company field, county FIPS, subsidy year, level/type, program and all amount/classification fields consumed downstream.
3. Preserve the supplied 2008–2019 subsidy-year filter and documented state/local sample logic.

Validation to perform later:

- After receipt, perform bounded CSV metadata/readability checks and verify the exact field contract and 2008–2019 coverage before author-code execution.

### A_SUBSIDY_SAMPLE_FILES: Obtain and identify the two distinct subsidy sample-filter files.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_STATE_SUBSIDY_SAMPLE, R_LOCAL_SUBSIDY_SAMPLE
Evidence: E_CREATE_STATE_SAMPLE, E_CREATE_LOCAL_SAMPLE, E_INVENTORY

Preparation / proposed procedure:

1. Obtain the state sample CSV with its exact included-state list and version.
2. Separately obtain the local county sample CSV with area_fips and local/state eligibility semantics; do not substitute the attached distinct-county FIPS list.
3. Confirm both lists match the analysis sample and the GJF file's identifiers.

Validation to perform later:

- Check each CSV's key uniqueness, values and coverage against the author-defined sample before a future join.

### A_PROGRAM_CLASSIFICATIONS: Obtain each distinct author-prepared program classification workbook/table and confirm how the two state-program lists differ.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_JOB_DISCLOSURE, R_MEGadeal_CLASSIFICATION, R_STATE_PROGRAM_LIST_UPDATED, R_CLEAN_PROGRAM_NAMES, R_STATE_PROGRAM_LIST_BASE, R_LOCAL_PROGRAM_CLASSIFICATION
Evidence: E_CREATE_JOB_DISCLOSURE, E_MEGACLASS_INPUT, E_STATE_LIST_INPUT, E_PROGRAM_NAMES_INPUT, E_PROGRAM_LIST_BASE_INPUT, E_LOCAL_CLASS_INPUT, E_DOC_MANUAL_PRECISION, E_INVENTORY

Preparation / proposed procedure:

1. Obtain the program-job-disclosure file, megadeal company/type classification workbook, updated state-program list, clean-program-name workbook, older state-program list and local-program classifications as separate source items.
2. For each item, preserve its independent state/program/company/year/type/agency keys and the full classification columns consumed by the Stata loops.
3. Ask authors to identify release dates, sampled states, duplicates, workbook sheet/header rules and whether each file is an input or an author-maintained crosswalk.

Validation to perform later:

- After receipt, perform bounded workbook/CSV/DTA metadata inspections per file and check join-key uniqueness and full consumed variable coverage; do not substitute one classification file for another.

### A_PROGRAM_DISCLOSURE_YEARS: Resolve the missing active program-disclosure-years producer while preserving the 27-state statute review.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_PROGRAM_DISCLOSURE_YEARS, I_PROGRAM_DISCLOSURE_PRODUCER
Evidence: E_DOC_LAWS, E_DOC_NEXIS, E_DOC_LAWS_POSTED, E_PROGRAM_DISCLOSURE_INPUT, E_DISCLOSURE_COMMENTED_PRODUCER, E_STATE_DISCLOSURE_CONSUMER

Preparation / proposed procedure:

1. Obtain the exact author-posted or author-maintained program disclosure-years input and its provenance; the documented short URL was not opened and is not verified.
2. Request the workbook/source code and instructions for the 27-jurisdiction statute review, including internal/external disclosure years, general-law classification, pre-2000 historical review and current period.
3. Confirm whether to reactivate the commented Excel producer or use a supplied compatible prepared input; retain all state/program rows and fields.

Validation to perform later:

- Verify state/program keys, year_internal, year_external and general_law_flag, then confirm both subsidy construction and state/program analyses consume the same logical table.
- After author clarification, execute the documented manual/source preparation only in a separately authorized run.

### A_ONLINE_DISCLOSURE_TIMING: Obtain the separate online program disclosure timing/precision table and its manual evidence procedure.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ONLINE_PROGRAM_TIMING
Evidence: E_ONLINE_INPUT, E_DOC_MANUAL_PRECISION, E_DOC_MANUAL_TIMING, E_DOC_SUBSIDY

Preparation / proposed procedure:

1. Obtain online_programs_after_external_strict with its actual producer, date fields, merge keys and affected program rows.
2. Confirm the authors' use of Good Jobs First posting dates, original state web pages and Wayback dates; preserve those source-specific choices and the strict external-disclosure subset.

Validation to perform later:

- Verify state/program keys, all consumed timing/precision fields and historical row coverage before a future subsidy-data run.

### A_MEGA_SAMPLE: Resolve the producer and provenance of the distinct megadeal county-year sample file and keep the author's inclusion alternative separate from the active baseline.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COUNTY_SAMPLE_MEGADEALS, I_MEGADEAL_ALTERNATIVE
Evidence: E_MEGA_SAMPLE_INPUT, E_SAMPLE_CYCLE_OUTPUT, E_INVENTORY, E_MEGADEAL_BRANCH, E_MEGADEAL_BASELINE, E_MEGADEAL_OUTPUT

Preparation / proposed procedure:

1. Ask the authors whether county_years_in_sample_with_megadeals_2023_03_31 is a retained prior-run output or a separate input and obtain its exact producer/version.
2. Do not substitute county_years_in_sample_final or infer that a similarly named sample is compatible.

Validation to perform later:

- Verify area_fips/year keys, megadeal inclusion rule and intended sample coverage before using the file.

### A_SLATTERY_DATA: Request the author-described state-year budget dataset and clarify its access terms and units.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_NASB_SLATTERY
Evidence: E_DOC_SLATTERY, E_NASB_CONSUMER, E_NASB_FIELDS

Preparation / proposed procedure:

1. In a separately authorized contact step, request the exact Stata dataset referred to as NASB_data, its data dictionary, state/year coverage and units, and permission/terms for replication use.
2. Do not treat the previous email exchange as a current access barrier; no refusal or license barrier is established.

Validation to perform later:

- On receipt, verify state/year keys and total_credits, total_budget and total_incentives (plus every other consumed field) before the comparison stage.

### A_STATE_RATINGS: Identify the exact state disclosure-rating dataset and author updates used in county preprocessing.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_STATE_DISCLOSURE_RATINGS
Evidence: E_DOC_IPPSR, E_IPPSR_PUBLIC, E_RATINGS_CONSUMER, E_INVENTORY

Preparation / proposed procedure:

1. Obtain state_disclosure_ratings_all and the mapping from the three documented transparency measures to the exact variables and source years.
2. Separate IPPSR source columns from author-augmented observations and preserve state-level merge keys.

Validation to perform later:

- Verify state-key uniqueness and every downstream-used rating field against the regression programs before a future run.

### A_GOVERNOR_PARTY: Identify the producer and source for the distinct governor/party/election state-year file.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_GOVERNOR_PARTY_ELECTIONS
Evidence: E_NASB_CONSUMER, E_STATE_PARTY_CONSUMER, E_INVENTORY

Preparation / proposed procedure:

1. Obtain StateGovt/governor_party_and_elections and ask for its code/source, key definitions and period; do not infer compatibility from the separate R governor_elections_all.csv.
2. Keep state names/codes and election timing consistent with both Stata consumers.

Validation to perform later:

- Verify state/year keys and all fields used by county and state/program regressions before a future run.

### A_WALLSTREET_DATA: Obtain the exact historical Best Run State ranking file for the separate state/program models.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_WALLSTREET_BEST_RUN
Evidence: E_DOC_BEST_RUN, E_STATE_WALLSTREET, E_INVENTORY

Preparation / proposed procedure:

1. Obtain wallstreet_best_run_for_merging.csv and its 24/7 Wall Street/Ballotpedia source notes, historical state ranks and release date.
2. Preserve the rank field and the state/year keys used to construct the top-quartile measure.

Validation to perform later:

- Verify state/year key uniqueness and period alignment before a future state/program analysis.

### A_IPPSR_WORKBOOK: Match the legacy IPPSR workbook to the public Correlates of State Policy source and author updates.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_IPPSR_WORKBOOK
Evidence: E_IPPSR_PUBLIC, E_DOC_IPPSR, E_MSU_RAW_INPUT

Preparation / proposed procedure:

1. Use the official IPPSR public-data route as a candidate and obtain the author-used IPPSR_dataset.xlsx vintage or a documented compatible conversion.
2. Confirm the 27 states, 2008–2015 years and each political/transparency field retained by the MSU cleaner; do not equate current project coverage with legacy variable compatibility.

Validation to perform later:

- After receipt, inspect workbook sheets/headers without recalculation and verify the full set of fields selected by clean_msu_data_final.do.

### A_PARTY_DETAILS: Obtain the separate party-composition workbook used in the MSU state-year merge.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_PARTY_DETAILS
Evidence: E_MSU_PARTY_INPUT, E_INVENTORY

Preparation / proposed procedure:

1. Obtain State Partisan Composition/state partisan details.xlsx and its version, source and coverage notes.
2. Preserve the state/year key and same_party_control field used after the merge.

Validation to perform later:

- Verify expected columns, key uniqueness and coverage for the 27-jurisdiction 2008–2015 panel.

### A_LAYOUT: Configure a local project working directory and stage the unchanged supplied programs and generated products at the paths used by the author statements.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_PROJECT_LAYOUT
Evidence: E_INVENTORY, E_R_PANEL_WRITE, E_STATA_PANEL_READ, E_MAIN_CWD, E_MAIN_CALLS, E_MSU_CLEAN_OUTPUT, E_STATE_MSU_CONSUMER

Preparation / proposed procedure:

1. Choose a local project layout with a driver working directory from which ../Code/Estimations resolves to a Code/Estimations directory; copy the four supplied called Stata programs there without editing their contents.
2. Set each cd ~ placeholder or launcher working directory to the chosen project location and create the relative Data, StateGovt, Subsidies, Results and Tableau directories used by the supplied programs.
3. Run the R producer from the selected project root; after it creates Data/countydata_agg_updated2022.csv, stage that same generated county panel at the current-directory basename read by Stata.
4. Run the MSU cleaner at its selected working directory; stage its cleaned_msu_data_final output at StateGovt/cleaned_msu_data_final for the state/program consumer.
5. Keep each generated file’s records and native schema unchanged during path staging; preserve the separate later producer/consumer order and sample dependencies as unresolved.

Validation to perform later:

- Before a future authorized author-code run, resolve each stated relative path against the selected local working directory and confirm each supplied include path points to the corresponding staged program.
- After each upstream producer is separately authorized, verify that the staged county and MSU files are the same generated products expected by their consumers, including county/state identifiers, time keys and consumed columns.
- Keep the county sample/bootstrap cycle, the cross-branch state/program order, and all unresolved input versions/fields/history open until their separate producer or author contract is established.

### A_SAMPLE_ORDER: Obtain the intended first-run bootstrap and post-run iteration for the generated county sample.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_SAMPLE_ORDER
Evidence: E_SAMPLE_CYCLE_USE, E_SAMPLE_CYCLE_OUTPUT, E_RERUN_NOTE, E_MAIN_CALLS

Preparation / proposed procedure:

1. Ask the authors how county_years_in_sample_final is made available to the first create_subsidy_data_final.do call, since the main script generates it only later.
2. Confirm the exact iteration after the main run's sample output is created; the source comment directs a subsidy-data rerun but does not specify whether preprocessing and downstream analyses must also be repeated.
3. Keep the two named county-year sample files distinct and preserve the baseline/megadeal branch definitions.

Validation to perform later:

- Write a staged procedure that never consumes a sample before its producer and explicitly validates the first-pass and post-run sample handoffs.

### A_INPUT_MANIFEST: Close the complete author-input manifest without combining independent data products or classifications.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_INPUT_CLOSURE
Evidence: E_INVENTORY, E_DOC_WORKFLOW, E_MAIN_CALLS, E_STATE_REQUIRED_FIELDS

Preparation / proposed procedure:

1. For every requirement in the full_pipeline scope, record the exact source/version, file path, access route, geography/year coverage, identifiers, units and complete fields consumed by its branch.
2. Keep generated intermediates, independent raw products, author crosswalks and manual review tables as separate logical items.
3. Retain unresolved items until the author confirms their producer or a compatible documented route is supported.

Validation to perform later:

- Reconcile the confirmed input manifest against all 31 frozen dependency IDs and all additional active reads before any future authorized execution.

### A_PLYR: Install/configure the R package required by the county-construction program in a later authorized environment-preparation step.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_PLYR
Evidence: E_PLYR_PROBE, E_R_PLYR

Preparation / proposed procedure:

1. Use the institution-approved R package repository to install plyr; do not change the source call or install packages during this assessment.

Validation to perform later:

- Use a small package-metadata check in the intended R environment to verify plyr's installed version before the future R pipeline run.

### A_OUTREG2: Install/configure the missing Stata output command before the county and state/program regression branches are attempted.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_OUTREG2
Evidence: E_ENVIRONMENT, E_STATA_OUTREG2

Preparation / proposed procedure:

1. In a later authorized setup step, install outreg2 from an approved Stata package source and make it visible in the configured Stata environment; no installation was attempted here.

Validation to perform later:

- Run the exact `which outreg2` software availability check in the intended Stata context and record the version/source before a future regression run.

### A_CROSS_BRANCH_ORDER: Obtain the author's staged execution order for the MSU, subsidy, county-preprocessing and separate state/program branches.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_CROSS_BRANCH_ORDER
Evidence: E_MSU_STATE_MERGE_OUTPUT, E_PREPROC_MSU_STATE_CONSUMER, E_SUBSIDIES_FINAL_OUTPUT, E_SUBSIDIES_FINAL_CONSUMER, E_CONTROL_OUTPUT, E_CONTROL_STATE_CONSUMER, E_MAIN_CALLS, E_SAMPLE_CYCLE_OUTPUT

Preparation / proposed procedure:

1. Ask the authors how to produce the MSU merge intermediate needed by county preprocessing when the separate state/program script later consumes subsidy and control outputs from the main workflow.
2. Request any intended first-pass or precomputed intermediate handoffs, their versions and the exact sequence for rerunning the main and state/program analyses.
3. Retain the complete state/program branch and all county analyses; do not consume generated intermediates before their producers or infer a partial-script execution from the package.

Validation to perform later:

- Write an explicit producer-before-consumer graph covering cleaned_msu_data_final_for_merging, subsidies_in_final_sample, control_variables_all and full_dataset_for_regression.
- After the author-specified order is confirmed and separately authorized, verify that each stage creates every downstream input before the consumer runs.


## Remaining issues and prerequisites

- I_INPUT_CLOSURE [unresolved; full_pipeline]: The archive includes programs and documentation but no empirical input datasets. The active workflow references public products, author-prepared tables and manual classifications; most exact versions, fields or histories remain unverified and are listed as separate requirements.
- I_PROJECT_LAYOUT [preparation; full_pipeline]: These are supported setup/staging handoffs between the supplied programs: R writes Data/countydata_agg_updated2022.csv and Stata imports the same county-panel basename from its current directory; the MSU cleaner writes cleaned_msu_data_final and the state/program script reads that same state-year product under StateGovt/; the main driver calls ../Code/Estimations paths while the registered supplied programs are flat. A local project root and directory/staging layout can resolve these known same-product paths while preserving the supplied records and code. No specific data or schema mismatch is established by the path differences; original author directory identity is not required.
- I_SAMPLE_ORDER [unresolved; full_pipeline]: create_subsidy_data_final.do merges county_years_in_sample_final before regressions_final.do creates that file later. The driver explicitly instructs a later subsidy-data rerun. The supplied materials do not specify the first-run seed or the exact post-run rerun sequence, so the producer/consumer cycle needs author clarification and a staged procedure.
- I_PROGRAM_DISCLOSURE_PRODUCER [unresolved; full_pipeline]: The main subsidy workflow and the separate state/program analysis consume program_level_disclosure_years, but its only supplied workbook-import producer is commented out and references an unlisted workbook. The author-described 27-jurisdiction statute review and required fields are known; the exact active input, version and construction handoff are not.
- I_COUNTY_CENSUS_PRODUCERS [unresolved; full_pipeline]: The only shown county education and population construction blocks are commented out, but later active code merges educ_county_year and county_pop_25_64. The documented 2008 education workbook and Census population source do not close the exact historical series or intermediate production contract.
- I_MEGADEAL_ALTERNATIVE [unresolved; full_pipeline]: The supplied main analysis defaults to excluding megadeal counties and explicitly documents a comment-out alternative to include them. The subsidy program also builds a separate megadeal-inclusive sample output from county_years_in_sample_with_megadeals_2023_03_31, whose producer is not supplied. The alternative is therefore preserved as a distinct unresolved branch rather than silently treated as the baseline or as a verified option.
- I_CROSS_BRANCH_ORDER [unresolved; full_pipeline]: County preprocessing consumes StateGovt/cleaned_msu_data_final_for_merging, which the separate state/program script produces. Later in that same state/program script, analyses consume subsidies_in_final_sample from subsidy preparation and control_variables_all from county preprocessing. The main driver runs subsidy preparation and county preprocessing before the later county sample is created, and it does not call the separate state/program script. The archive does not specify the staged/bootstrap passes needed to satisfy all of these producer/consumer dependencies without skipping a branch.
- R_BLS_QCEW [public_acquisition_required]: The R county-construction entry point reads the annual QCEW NAICS single-file series for 2001–2019, filters to selected industries, ownerships and aggregation levels, then constructs state/county/national outputs. The lead outcomes require a later year beyond the main 2008–2015 county period.
- R_UNEMPLOYMENT [undetermined]: The R program actively reads and renames the state unemployment file. It is not joined into the later county panel in the supplied source, but the active read still requires the file unless authors approve removing the unused read.
- R_STATUTORY_TAX [undetermined]: The R program reads the state top-tax file twice, maps its source columns, and joins tax rates to the county panel. This is distinct from the Giroud–Rauh control archive.
- R_APPORTIONMENT [undetermined]: The R program actively reads and renames apportionment factors; no downstream use is visible in the supplied R program, so the file remains an execution input unless authors confirm the read can be removed.
- R_GOVERNOR_ELECTIONS [undetermined]: The R program actively reads governor election data and renames Election_Year; no downstream use is visible in the supplied R program. This is separate from the state-year governor/party file consumed in Stata.
- R_RIGHT_TO_WORK [undetermined]: The R program actively reads and renames right-to-work year fields; no downstream use is visible in the supplied R program, so this remains a code-level input unless authors approve removing the read.
- R_MINIMUM_WAGE [undetermined]: The R program joins state/year minimum wage measures to the county employment panel. Authors identify UC Berkeley source workbooks; the currently documented page does not establish the exact historical state-year file and transformations.
- R_UNION_MEMBERSHIP [undetermined]: The R and Stata workflows read a private-sector union membership/coverage table and use membership, coverage and change measures. The authors' broad ACS source description does not verify the exact union series represented by UnionMembership_All.csv.
- R_STATE_EDUCATION [undetermined]: The R and Stata workflows use state-year education measures; the author documentation points to ACS, but the exact table, education definition, release vintage and input header are not identified.
- R_STATE_POPULATION [undetermined]: The R program actively reads state populations but the value is not used later in the supplied R source. The file remains an active runtime input unless authors confirm removal; its exact source table is unknown.
- R_BEA_PCE [undetermined]: The R program reads and filters a BEA personal-consumption file, but the filtered object is not used in the supplied R source. It remains an active execution input unless authors confirm the read can be removed.
- R_GIROUD_RAUH [undetermined]: R and Stata read the Giroud–Rauh state/year control data. The code selects unemployment, income, property, tax-incentive and industry columns; authors describe a source archive plus later extensions, whose exact files and history are not supplied.
- R_STATE_GDP [undetermined]: The R county builder and Stata state-controls builder consume one logical BEA state GDP product under different relative roots. The scripts select all-industry state-year values; exact BEA table, price basis and vintage are not specified.
- R_IPPSR_WORKBOOK [undetermined]: The MSU cleaner imports IPPSR_dataset.xlsx and retains 27 states, 2008–2015, and state-year political/transparency fields. The current public IPPSR project is a candidate route, but the exact workbook vintage and required legacy fields are not confirmed.
- R_PARTY_DETAILS [undetermined]: The MSU cleaning program separately imports the party-composition workbook and merges its state-year fields with IPPSR data. This is an independent manual workbook input.
- R_GJF_SUBSIDY [undetermined]: The subsidy builder imports the authors' December 2021 Good Jobs First subsidy file and keeps county-linked records with subsidy years 2008–2019. This commercial/public source is a separate logical input from the sample filters and manual program classifications.
- R_STATE_SUBSIDY_SAMPLE [undetermined]: A separate state-sample CSV filters the raw subsidy observations by state; its list and period are not included in the package.
- R_LOCAL_SUBSIDY_SAMPLE [undetermined]: A separate local county-sample CSV filters raw subsidy observations and marks local sample eligibility; it is not the attached FIPS identifier list.
- R_JOB_DISCLOSURE [undetermined]: The subsidy builder imports a distinct state/program ex-ante job-disclosure file; the authors describe manual review of program disclosure precision.
- R_MEGadeal_CLASSIFICATION [undetermined]: The subsidy builder imports an independent company-level megadeal subsidy-type classification workbook and merges it to the raw subsidy records.
- R_STATE_PROGRAM_LIST_UPDATED [undetermined]: The subsidy builder imports the updated state-program classification workbook to label subsidy purposes. It is distinct from the older state-program list imported later in the same program.
- R_CLEAN_PROGRAM_NAMES [undetermined]: The subsidy builder imports a separate manual raw-to-clean program-name mapping and uses the cleaned name in subsidy and law panels.
- R_STATE_PROGRAM_LIST_BASE [undetermined]: A second, differently named state-program classification workbook is imported later in the subsidy builder. It is an independent input and must not be replaced by the updated list without author evidence.
- R_LOCAL_PROGRAM_CLASSIFICATION [undetermined]: The subsidy builder merges a separate local subsidy-program classification table by state, program, subsidy type and agency.
- R_PROGRAM_DISCLOSURE_YEARS [undetermined]: A manually constructed disclosure-years input must provide program-level internal/external first years and a general-law flag for the 27-jurisdiction statute review. It is consumed by subsidy preparation and state/program-year analyses; its shown Excel producer is commented out.
- R_ONLINE_PROGRAM_TIMING [undetermined]: The subsidy builder actively merges a program-level online-disclosure table after external disclosure years; authors describe manual review of job targets, posting dates and state websites/Wayback dates.
- R_COUNTY_SAMPLE_MEGADEALS [undetermined]: A distinct county-year file with megadeal observations is consumed to generate the megadeal sample output. No producer appears in the supplied programs.
- R_COUNTY_EDUCATION [undetermined]: Active preprocessing merges a county education panel; a commented producer names the 2008 ACS S1501 workbook and a prior county education file. The 2008-specific data are transformed to county percentage Bachelor's degree, but the earlier panel and full history are unspecified.
- R_COUNTY_POPULATION [undetermined]: Active preprocessing merges county population ages 25–64 and uses a one-year lag; the only shown construction from Census county_employable_populations.csv is commented out.
- R_NASB_SLATTERY [undetermined]: The county regression workflow merges a state-year budget input and later compares subsidy totals to total credits, total budgets and total incentives. Authors describe a Stata dataset received from Slattery by email in 2023.
- R_STATE_DISCLOSURE_RATINGS [undetermined]: Active county preprocessing merges state disclosure ratings; authors say the state transparency measures were largely obtained from IPPSR and updated by the author team. Exact measure names, source years and extension are unverified.
- R_GOVERNOR_PARTY_ELECTIONS [undetermined]: Both county preprocessing and state/program analyses merge a separate state-year governor/party/election table. The R election file is a different named input and does not establish this table's producer.
- R_WALLSTREET_BEST_RUN [undetermined]: The separate state/program workflow imports state-year Best Run rankings and creates a top-quartile indicator. Authors identify 24/7 Wall Street and Ballotpedia as source families.
- S_PLYR [preparation_required]: The R entry program calls library(plyr); a metadata-only package probe reports it unavailable. Install/configure plyr in R before a future authorized run.
- S_OUTREG2 [preparation_required]: The supplied regression programs call outreg2, which the original environment probe reports unavailable. Install/configure the command before a future authorized run; no installation was attempted.

## Review notes

- Scope includes R county construction, MSU state-year preparation, the main county regressions, subsequent-subsidy descriptives, and the independent state/program-year analyses.
- Generated outputs are classified from active source producers; they do not require pre-existing populated probes. Raw inputs and unresolved producer/consumer order are assessed separately.
- The screening incident is recorded in probes/screening_incident.json and is not cited as workflow evidence; candidate content and adjacent screened lines are excluded from this assessment.
- Public-page fetch failures are preserved in probes/public_inspection_failures_v001.json as inspection limits only; they do not establish restricted access or unavailable data.
- Requirements keep independent source products, author spreadsheets and manual classifications separate; common schemas are not treated as equivalent datasets.
- The R source actively reads several auxiliary CSVs that are not used downstream in the supplied file. They remain runtime requirements pending author confirmation of removable reads.
- The public BLS QCEW route is verified for the annual 2001–2019 product. BEA, Census, Berkeley and IPPSR pages identify candidate source families, while exact author contracts remain unverified where stated.
- All 31 frozen dependency IDs are reviewed individually. Active data reads map to distinct logical requirements; source-produced intermediates and unresolved producers are distinguished.
- The flat package inventory contains the four active main-driver helper files, while the driver names a separate ../Code/Estimations layout; this remains a project-root/staging issue rather than an absent-program claim.
- Every nonlocal or unverified input, unavailable software item, and unresolved issue has a linked action; no source edits, downloads, installs or author execution were performed.
- The verified public product route is BLS QCEW. BEA GDP and other official/repository candidate sources remain unverified where exact table units, vintage or author fields are unresolved.
- The official QCEW annual layout exposes annual_avg_estabs_count; the R script expects annual_avg_estabs, so the supported input route includes a one-column rename in the prepared CSV.
- Frozen catalog lookups used the registered helper copy and remained discovery-only; unrelated metadata matches and zero exact candidates were not treated as access or availability findings.
- The main driver's active baseline excludes megadeal counties; the explicitly documented inclusion alternative and its separate sample input/output remain a distinct unresolved branch.
- Additional generated handoffs are source-proven: the clean-name mapping and subsidy-by-type dataset are produced by subsidy preparation, and the StateGovt MSU merge dataset is produced by the separate state/program script before county preprocessing. These outputs do not require pre-existing populated probes.
- A separate cross-branch order issue records that county preprocessing consumes an MSU merge output from the state/program script, while later state/program models consume subsidy and control intermediates from the main branch. No unsupported staged order is assumed.
- The exact local project root is a setup choice: source-supported same-product relative paths can be resolved by directory staging/configuration. This does not resolve the separate county sample cycle, cross-branch ordering, or unknown input contracts.
