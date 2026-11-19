# Patch proposal: jar-d49e02f969b5

Boards of a Feather: Homophily in Foreign Director Appointments Around the World

DOI: 10.1111/1475-679X.12416

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The full supplied regional data preparation workflow and country-pair build through final_sample, retaining the separate announcement-preparation branch described for Table 10.

Entry points: `01-Clean_Raw_Data_BBIN 2022.do`, `02-Build_Work_Data_BBIN 2022.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 4/12416 - Boards-of-a-Feather-Homophily-in-Foreign-Director-Appointments-Around-the-World/bbindatasheetcodeandidentifiers.zip",
      "sha256": "08560190a6815952c24bb8df6530dd713262a425b0835e51e4a1a3b973d434e8"
    },
    {
      "path": "JAR-Volume 60/Issue 4/12416 - Boards-of-a-Feather-Homophily-in-Foreign-Director-Appointments-Around-the-World/bbin-online-appendix.pdf",
      "sha256": "da4ae2a62b4e43c6419827aa011efe8ca7170308ec92abcff7ff465c87cb6ddf"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "ed6dfeccd1572582d7d8ad0aab09eb38b78d50e8ca5769cc96527feb9577b36e"
}
```

## Proposed actions

### ACT-BOARDEx-EXPORTS: Locate or acquire the author-compatible regional BoardEx products through an authorized route and establish their source-to-code mapping. Catalog-listed SAS tables remain discovery candidates until file access, fields, history, and product equivalence are verified.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ-EMP-CURRENT, REQ-EMP-NONCURRENT, REQ-NONBOARD-CURRENT, REQ-NONBOARD-NONCURRENT, REQ-PROFILE, REQ-COMPANY-NETWORK, REQ-DETAILS-EU, REQ-DETAILS-NA, REQ-DETAILS-ROW, REQ-DETAILS-UK, REQ-ANN-EU, REQ-ANN-EU-SMDE, REQ-ANN-UK, REQ-ANN-UK-SMDE, REQ-ANN-NA, REQ-ANN-NA-SMDE, REQ-ANN-ROW-SMDE, REQ-ANN-ROW, ISS-BOARDEx-CLOSURE
Evidence: E-DOC-BOARDEx, E-BOARDEx-LICENSE, E-LOOKUP-BOARDEX, E-CLEAN-REGIONS, E-ANNOUNCEMENT-BRANCH, E-BUILD-FIRST-EMPLOYMENT

Preparation / proposed procedure:

1. For each of EU, UK, NA directors, NA senior managers, and ROW, obtain or locate the separate current and non-current employment, current and non-current non-board, Profile, and Company Network inputs read by Program 01.
2. Preserve the four company-details workbooks and all eight announcement workbooks as distinct jointly required regional inputs; retain Step 8 and its outcome/announcement output.
3. Compare actual source columns, identifier types, dates, region populations, and historical coverage with the code. The datasheet's December 2014 download date is contextual; enddate=2014 and the authored classifications/factor choices remain unchanged.

Validation to perform later:

- Before a separately authorized run, record the verified file-to-region and source-column mappings and confirm the employment history supports the supplied first-employment domicile logic.

### ACT-UNPRODUCED-AUXILIARIES: Recover or document the four author-referenced data inputs that neither supplied program produces. Preserve each as a distinct required input and do not construct a replacement from unrelated catalog candidates.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ-KAROLYI, REQ-GAAP-SIMILARITY, REQ-MATRIX-COUNTRIES, REQ-IFRS, ISS-AUX-INPUT-CLOSURE
Evidence: E-CLEAN-KAROLYI, E-CLEAN-GAAP, E-BUILD-MATRIX, E-BUILD-IFRS, E-WORKITEM-INVENTORY, E-LOOKUP-KAROLYI, E-LOOKUP-GAAP, E-LOOKUP-MATRIX, E-LOOKUP-IFRS

Preparation / proposed procedure:

1. Obtain the exact temp/karoly_oct2018.csv input and its countrycode1, institutionalquality, and year-wide source mapping needed by the reshape and six-factor branch.
2. Identify the source and schema for temp/gaap_similarity, including its countrycode1/countrycode2 pair fields, and the producer or supplied file used to generate it.
3. Obtain BBIN-2022/matrix_countries.csv with the source-country row and destination-country columns expected by the reshape; retain the authored directed 2000–2013 matrix expansion.
4. Obtain BBIN-2022/ifrs with the countrycode1, year, and ifrs fields used for both country directions; establish the required country-year coverage.

Validation to perform later:

- Check each exact supplied input against its code consumer and record unknown definitions, coverage, mappings, or producers before preparing a run.

### ACT-STAGE-PACKAGED-AUXILIARIES: Stage the exact supplied, probe-readable auxiliary files under the relative directory names expected by the author programs. This preserves their documented roles and file contents; it does not claim full-population coverage from one-row probes.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: REQ-REPORTINGQUALITY, REQ-PAIR-CTR4, REQ-CULTURAL-DISTANCE, REQ-COMMON-VARIABLES, REQ-COUNTRYLEVEL, REQ-CLTEST, ISS-WORKING-DIRECTORIES
Evidence: E-PROBE-COUNTRYLEVEL, E-PROBE-PAIR-CTR4, E-PROBE-COMMON-VARIABLES, E-PROBE-CULTURAL-DISTANCE, E-PROBE-CLTEST, E-PROBE-REPORTINGQUALITY, E-WORKITEM-INVENTORY, E-BUILD-CROSSWALK, E-BUILD-CROSSWALK-ABS, E-BUILD-PAIR-CTR4, E-BUILD-CULTURAL-DISTANCE, E-BUILD-CLTEST, E-BUILD-REPORTINGQUALITY, E-BUILD-COMMON-VARS

Preparation / proposed procedure:

1. Use the exact packaged files countrylevel.dta, pair_ctr4.dta, common_variables_old.dta, cultural_distance.dta, cltest.dta, and reportingquality.csv; stage copies under the program's BBIN-2022/ and BBIN_2022/ relative paths while retaining the original package files.
2. Map the second countrylevel read in the domicile fallback to that same staged crosswalk in the working copy; do not replace the crosswalk with an unrelated source.
3. Preserve native column names in the staged files so the existing joins/renames use countrycode1, countrycode2, reporteriso, partneriso, countrycode_dest, countrycode_orig, comlang, colony, and the documented covariates.

Validation to perform later:

- In a separately authorized run, confirm the staged paths resolve to the same probe-identified files and check the merge keys/required columns without treating the bounded probes as a full coverage audit.

### ACT-REGIONAL-HANDOFFS: Prepare the five regional producer runs and route each output to the exact filenames consumed by the following aggregation blocks, without changing the authored transformations.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: ISS-REGIONAL-OUTPUT-MAPPING
Evidence: E-CLEAN-REGIONS, E-CLEAN-REGIONAL-OUTPUTS, E-CLEAN-NONBOARD-OUTPUT, E-CLEAN-PROFILE-OUTPUT, E-CLEAN-NETWORK-OUTPUT, E-CLEAN-NETWORK-COUNTS, E-CLEAN-NETWORK-TEMP, E-WORKFLOW-TRACE

Preparation / proposed procedure:

1. Run the employment block once per region using both current and non-current exports; map outputs to eu_boardexemployment, uk_boardexemployment, na_boardexemployment, sm_boardexemployment, row_boardexemployment, then aggregate to global_employment.
2. Run the non-board block for the same five regions; map outputs to eu_boardexother, uk_boardexother, na_boardexother, sm_boardexother, row_boardexother, then aggregate to global_other.
3. Run the Profile block for the same five regions; map outputs to eu_profile, uk_profile, na_profile, sm_profile, row_profile, then aggregate to global_profile.
4. Run the Company Network block separately with the authored region file counts EU 31, UK 32, NA directors 109, NA senior managers 169, and ROW 34; preserve each region's temp/region_i intermediates, route outputs to eu_network, uk_network, na_network, sm_network, row_network, then aggregate to global_network.
5. Keep the Step 5 company-details-to-companylist chain, Step 6 Karolyi-to-instquality chain, Step 7 GAAP-to-francisjune25 chain, and Step 8 eight-workbook-to-announcement chain as separate producers in Program 01.

Validation to perform later:

- Before the build step, compare each regional staged output name with the following use/append commands and confirm global_network, global_employment, global_other, global_profile, companylist, instquality, francisjune25, and announcement were routed to their authored consumers or retained output branch.

### ACT-WORKING-DIRECTORY-SETUP: Create a coherent host-visible relative execution root in a working copy and reconcile every current-directory change and data/output path across both programs.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISS-WORKING-DIRECTORIES
Evidence: E-CODE-CWD-ISSUES, E-CLEAN-OUTCOME-CD, E-BUILD-CROSSWALK-ABS, E-BUILD-CROSSWALK, E-WORKITEM-INVENTORY

Preparation / proposed procedure:

1. Set one relative project root for Program 01 and Program 02, and make each block's input/output paths resolve from that root or from a documented stable subdirectory.
2. Replace the author-specific absolute Mac working directory and absolute crosswalk reference in the working copy with the chosen relative execution root and staged countrylevel path.
3. Keep the authored original files/region, original files, outcome, temp, BBIN-2022, and BBIN_2022 roles distinct; reconcile all affected read/write calls before any run.

Validation to perform later:

- Statically check every cd/read/write path in both supplied programs against the chosen root and verify host visibility/writability in a separately authorized run.

### ACT-CARRYFORWARD-CHECK: Verify the actual carryforward command/function under the available Stata 18 setup before execution; the existing environment record proves Stata only and does not prove the add-on is absent.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-CARRYFORWARD, ISS-CARRYFORWARD-AVAILABILITY
Evidence: E-CLEAN-CARRYFORWARD, E-PROBE-ENVIRONMENT

Preparation / proposed procedure:

1. Use a separately authorized read-only Stata which/find-package or installed-package metadata check for carryforward; if it is unavailable, identify an approved compatible installation source before planning any package setup.

Validation to perform later:

- Confirm the exact invoked function is available under the Stata 18 path without running the author code or a syntax/data trial.

### ACT-ORDERED-PROCEDURE: Follow the supplied producer order and named handoffs through final_sample while retaining the standalone Table 10 announcement branch.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: ISS-REGIONAL-OUTPUT-MAPPING, ISS-WORKING-DIRECTORIES, ISS-AUX-INPUT-CLOSURE
Evidence: E-WORKFLOW-TRACE, E-CLEAN-EMP-GLOBAL, E-CLEAN-NONBOARD-GLOBAL, E-CLEAN-PROFILE-GLOBAL, E-CLEAN-NETWORK-GLOBAL, E-CLEAN-COMPANYLIST, E-CLEAN-INSTQUALITY-OUTPUT, E-CLEAN-GAAP-OUTPUT, E-CLEAN-ANNOUNCEMENT-OUTPUT, E-BUILD-CONSUMER, E-BUILD-FIRST-EMPLOYMENT, E-BUILD-MATRIX, E-BUILD-PAIR-CTR4, E-BUILD-FINAL-SAMPLE

Preparation / proposed procedure:

1. Program 01 Step 1–Step 4: regional employment -> global_employment; regional non-board experience -> global_other; regional Profile -> global_profile; regional Company Network CSVs -> temp/region_i -> regional network files -> global_network.
2. Program 01 support branches: four company-details workbooks -> companylist; Karolyi CSV -> reshaped country-year dimensions -> instquality; temp/gaap_similarity -> reciprocal pair rows -> francisjune25; eight announcement workbooks -> outcome/announcement for Table 10.
3. Program 02 opens global_network, merges global_employment/global_other for both directors plus companylist and global_profile, then builds network enrichment -> temp/global_network3 -> swapped temp/globalnetwork3b -> profile-cohort director subset -> first-employment histories and nationality -> firstcountry/domicile combination -> directorcountry -> dir_firm_country -> countrypairsyear and country_ndirectors.
4. Program 02 creates matrix_countries -> matrix_countries country-pair/year base for 2000–2013, merges countrypairsyear, pair_ctr4, cltest, cultural_distance, IFRS for both directions, common_variables_old, instquality for both directions, reportingquality for both directions, country_ndirectors, and francisjune25, then saves outcome/final_sample.
5. Preserve the final_sample target as the supplied build output; paper-wide estimators and unprovided Worldscope/CRSP analysis consumers remain contextual limitations, not added mandatory AND stages.

Validation to perform later:

- In a separately authorized run, confirm the generated file sequence and joins at each named handoff while retaining the authored sample and construction choices.


## Remaining issues and prerequisites

- ISS-BOARDEx-CLOSURE [unresolved; full_pipeline]: The package lacks the regional BoardEx employment, non-board, Profile, Company Network, company-details, and announcement exports consumed by Step 1–Step 5 and Step 8. The author reports university-licensed access; frozen-catalog SAS records are candidates only. Exact export schemas, current availability, regional population, and historical membership are unresolved. Program 02 uses employment history to determine first-observed employment and domicile. The current-employment enddate=2014, classifications, and factor choices are authored behavior, not proposed corrections or byte-vintage gates.
- ISS-AUX-INPUT-CLOSURE [unresolved; full_pipeline]: The supplied workflow refers to temp/karoly_oct2018.csv, temp/gaap_similarity, BBIN-2022/matrix_countries.csv, and BBIN-2022/ifrs, but these inputs are absent from the assigned inventory and no supplied producer constructs them. The matrix country population and schema, IFRS country-year coverage, Karolyi factor source fields/history, and GAAP pair source/definition remain unresolved. Frozen-catalog misses do not establish data absence or lack of access.
- ISS-REGIONAL-OUTPUT-MAPPING [preparation; full_pipeline]: The code comments prescribe five region-specific employment, non-board, profile, and network output files, but the repeated regional blocks save literal names. The network loop is fixed to 31 files while comments list region counts 31/32/109/169/34. These are supported producer-to-file mapping/setup tasks; they do not create independent raw-data requirements. Preserve the authored transformations and map each regional run to its expected output before aggregation.
- ISS-WORKING-DIRECTORIES [preparation; full_pipeline]: Program 01 changes into relative original files/region and outcome directories without returning to one stable project root between sections; Program 02 changes to an absolute author-machine directory and later names a second absolute path for countrylevel. The packaged auxiliaries are at the assigned package root while the code expects BBIN-2022/ and BBIN_2022/ paths. A coherent host-visible relative working root and same-file staging/path configuration are required in a working copy.
- ISS-CARRYFORWARD-AVAILABILITY [unresolved; full_pipeline]: The supplied cleaning code invokes carryforward, but no existing exact-function probe establishes its installation. Stata 18 is available. Availability remains unverified rather than unavailable, and no author or syntax trial was run.
- REQ-EMP-CURRENT [undetermined]: Employment_Current.csv for each of Europe, UK, North America directors, North America senior managers, and Rest of the World. The code maps current positions to enddate 2014 as authored and expands the source into director-company-year records.
- REQ-EMP-NONCURRENT [undetermined]: Employment_Non_Current.csv for each of the same five BoardEx regional runs; these rows are appended to current employment before yearly expansion and first-employment/domicile construction.
- REQ-NONBOARD-CURRENT [undetermined]: Non_Board_Current.csv for each of the five BoardEx regional runs; the supplied code constructs year-level non-board experience and merges it with director-company network records.
- REQ-NONBOARD-NONCURRENT [undetermined]: Non_Board_Non_Current.csv for each of the five BoardEx regional runs; the code appends non-current appointments to the current non-board records before expanding years.
- REQ-PROFILE [undetermined]: Profile.csv for each of the five BoardEx regional runs. The supplied code derives profile, nationality, gender, and related director fields and aggregates region outputs into global_profile.
- REQ-COMPANY-NETWORK [undetermined]: Region-indexed Company Network CSV family for the five regional runs. These inputs generate regional network panels and the global_network consumed at the start of the build program; author comments give file counts EU 31, UK 32, NA directors 109, NA senior managers 169, ROW 34.
- REQ-DETAILS-EU [undetermined]: Europe-Company-Details.xlsx, appended into the generated companylist used to assign company country in the build program.
- REQ-DETAILS-NA [undetermined]: NA-Company-Details.xlsx, appended into the generated companylist used to assign company country in the build program.
- REQ-DETAILS-ROW [undetermined]: ROW-Company-Details.xlsx, appended into the generated companylist used to assign company country in the build program.
- REQ-DETAILS-UK [undetermined]: UK-Company-Details.xlsx, appended into the generated companylist used to assign company country in the build program.
- REQ-KAROLYI [undetermined]: temp/karoly_oct2018.csv, the input to the supplied institutional-quality preparation that generates outcome/instquality for destination and origin country merges.
- REQ-ANN-EU [undetermined]: Europe-Company-Announcements.xlsx, the first regional workbook in the separate Step 8 branch that produces outcome/announcement for Table 10.
- REQ-ANN-EU-SMDE [undetermined]: Europe-SMDE-Announcements.xlsx, appended into the Step 8 announcement output.
- REQ-ANN-UK [undetermined]: UK-Company-Announcements.xlsx, appended into the Step 8 announcement output.
- REQ-ANN-UK-SMDE [undetermined]: UK-SMDE-CompanyAnnouncements.xlsx, appended into the Step 8 announcement output.
- REQ-ANN-NA [undetermined]: NA-Company-Announcements.xlsx, appended into the Step 8 announcement output.
- REQ-ANN-NA-SMDE [undetermined]: NA-SMDE-Announcements.xlsx, appended into the Step 8 announcement output.
- REQ-ANN-ROW-SMDE [undetermined]: ROW-SMDE-Announcements.xlsx, appended into the Step 8 announcement output.
- REQ-ANN-ROW [undetermined]: ROW-Company-Announcements.xlsx, appended into the Step 8 announcement output.
- REQ-GAAP-SIMILARITY [undetermined]: Country-pair temp/gaap_similarity input used by Step 7 to make reciprocal country directions and produce outcome/francisjune25. No producer or input file is in the supplied inventory.
- REQ-MATRIX-COUNTRIES [undetermined]: BBIN-2022/matrix_countries.csv used to generate the directed country-pair-by-year matrix for 2000–2013 before merging the BoardEx-derived country-pair panel.
- REQ-IFRS [undetermined]: Country-year IFRS adoption file read twice to merge destination and origin country indicators into the country-pair build.
- SW-CARRYFORWARD [unverified]: The preparation code calls carryforward within Stata. The existing environment artifact establishes Stata 18 but contains no proof for this command's availability; do not treat it as absent.

## Review notes

- The frozen title and DOI are preserved. Both supplied Stata program headers name Boards of a Feather: Homophily in Foreign Director Appointments Around the World, matching the datasheet; no material attribution conflict is supported.
- The target is both supplied data-preparation programs through outcome/final_sample, plus the separate Step 8 outcome/announcement producer for Table 10. Paper-wide estimators and unprovided Worldscope/CRSP analysis consumers are contextual limits, not extra mandatory stages.
- The package's company_identifiers.dta is credited as the Table 10 final-sample firm identifier file described by the datasheet. Its bounded probe shows announcementdate and cusip only, and neither supplied program reads it; it is not treated as a full analysis panel or bypass route.
- The packaged countrylevel crosswalk, pair_ctr4 bilateral table, common_variables_old, cultural_distance, cltest country attributes, and reportingquality file are credited for the actual joins and roles in Program 02. Bounded probes confirm the listed source fields; they do not establish complete population/history coverage. Their root-to-code directory differences are staging setup.
- No separate analysis_only scope is supported: the packaged auxiliaries are not a compatible author-prepared analysis panel and the supplied programs construct final_sample rather than run the paper-wide estimators.
- The authored current-employment enddate=2014 behavior, executive/company-type classifications, and one- and three-factor specifications are retained as written. The datasheet's December 2014 vintage is contextual; actual historical membership, export schema, and coverage remain unresolved where downstream code requires them.
- The header's Parallel 16.1 Edition wording is not a dependency finding because neither supplied program invokes the community parallel command. carryforward is an actual Stata command call and remains unverified in the existing environment record, which establishes Stata 18 only.
- All 40 checklist dependency IDs and the five-region producer/consumer chain are mapped in probes/workflow_trace_checkpoint_1.json. The ordered procedure retains employment, non-board, profile, network, company-details, Karolyi, GAAP, and announcement producer branches, then the country-pair build.
- An early trace JSON parse failed; the malformed original trace was preserved as probes/workflow_trace_checkpoint_1_failed.json and its observed traceback/limited capture is recorded in probes/roundtrip_check_failure.json. The record has no reliable process return code or separate stdout/stderr. A saved checker later confirmed the corrected checkpoint JSON round-trip.
- A later source-evidence expansion patch accidentally left a duplicate trailing draft block. The malformed draft bytes were preserved as probes/draft_source_evidence_expansion_failed_20261110.json; the observed JSON error was Extra data at line 492, column 5. The duplicate tail was removed, and the current draft parsed successfully. This incident is process history, not scientific evidence.
- The first required metadata preflight exited with code 2 because one lookup-log SHA and one source quote did not match their stored artifacts. Its actual input hash, saved helper, captured stdout/stderr, return code, and diagnostic are preserved in probes/preflight_assessment_attempt_01.json and probes/preflight_assessment_attempt_01.py. Both evidence metadata errors were corrected before the next preflight.
