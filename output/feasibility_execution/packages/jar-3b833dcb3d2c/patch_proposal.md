# Patch proposal: jar-3b833dcb3d2c

Diversity Tokenism

DOI: 10.1111/1475-679X.70019

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied workflow: raw/prepared input construction, replacement-probability analysis, regression tables, protest maps, DiD plots and the economic-magnitude Python figure. Some source sections remain withheld for safe assessment, while full_pipeline scope is retained and input/dependency closure remains incomplete.

Entry points: `DiversityTokenism_DataPolicy/Codes/25-08-15 LT-sample construction.do`, `DiversityTokenism_DataPolicy/Codes/25-08-15 LT-replacement probabilities.do`, `DiversityTokenism_DataPolicy/Codes/25-08-15 LT-regressions.do`, `DiversityTokenism_DataPolicy/Codes/25-08-15 LT-protest maps.do`, `DiversityTokenism_DataPolicy/Codes/25-08-15 LT-DiD plots.do`, `DiversityTokenism_DataPolicy/Codes/25-08-15 LT-eco mag plot.py`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 1/70019 - Diversity-Tokenism/lt-datasheet-code-identifier-and-log-files.zip",
      "sha256": "c2b9ebe12c949e02c5d5ab790dd8c5465569eaf444e994567e8f5a391ff68905"
    },
    {
      "path": "JAR-Volume 64/Issue 1/70019 - Diversity-Tokenism/law-tan-jar-diversity-tokenism-online-appendix.pdf",
      "sha256": "5e263a57949fdafa6979ce81ead61591329930d54f69cb1969e7bd197e8c633b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "16c2b09962b5e69a4142d4db37172e13d0db2aca6ce251c5211ab5dd7fbe15c8"
}
```

## Proposed actions

### A_INPUT_CLOSURE: Obtain or identify the author-prepared tables and exact field/history contracts for the unresolved inputs; do not infer substitutions from same-brand catalog products.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_HQ, REQ_BLM, REQ_DIRECTOR, REQ_EXECUTIVE, REQ_EMP_CIK, REQ_EMP_STATE, REQ_COMPUSTAT, REQ_REFINITIV, REQ_COMMUNITY, REQ_COUNTY_DEM, REQ_JOINLEAVE, I_INPUT_CLOSURE
Evidence: E_README_INPUTS, E_DATA_SOURCES, E_DATA_ACCESS, E_GPT_GENERATION, E_APPENDIX_PERSON_GRAIN, E_PROBE_COMPANY, E_PROBE_LATEST_HQ, E_PROBE_DIRECTOR, E_PROBE_EXECUTIVE, E_PROBE_COMPUSTAT, E_PROBE_TRESG_SO, E_PROBE_TRESG_BOARD, E_SELECTED_SCHEMAS, E_PUBLIC_BLM, E_PUBLIC_ACS, E_HQ_SOURCE, E_DIR_SOURCE, E_EXEC_SOURCE, E_EMP_CIK_READ, E_EMP_STATE_SOURCE, E_JOINLEAVE_SOURCE, E_COMP_SIC, E_REFINITIV_SOURCE, E_COMMUNITY_SOURCE, E_COUNTY_SOURCE

Preparation / proposed procedure:

1. For hq.dta, provide the historical GVKEY-year county-FIPS panel and its CIK link; current company and most-recent HQ products do not establish county history.
2. For BLM events, identify the exact public compiled file and document pid, event dates, protest counts and county-FIPS derivation before mapping it to blmprotests.dta.
3. Provide the director and executive gpt_race files with the original input identifier mapping, or the author’s complete prepared classification outputs; the local ExecuComp rosters do not contain gpt_race.
4. Provide the CIK-year and CIK-state-year workforce race-count tables and the separate firm-year join/leave panel, with Revelio product, record grain, category definitions and date coverage. The catalogued monthly geography aggregate is not a substitute.
5. For Compustat, confirm the code’s sic input against the local FUNDA sich field and the historical industry definition; a current company sic field does not supply annual fundamentals.
6. For Refinitiv, identify the exact RIC/GVKEY/year mapping and data dictionary for each diversity, policy, target and gender metric; the local TRESG candidates have different OrgId/FisYear/member-level schemas.
7. For community_rep.dta and county-dem.dta, supply the ACS table/measure-to-field mapping, numerator/denominator definitions, vintages and source for county Gini; then acquire the mapped public tables.

Validation to perform later:

- Compare every delivered table’s native headers, key uniqueness, category definitions and calendar coverage against the cited Stata reads and joins.
- Confirm the Table 2 join/leave producer and its individual-to-firm-year aggregation before running replacement probabilities.
- Preserve the actual producer/consumer partial order: sample construction before main-master consumers, replacement matrices within the Table 2 branch, and separate map and Python figure branches.

### A_CIK_LINK_PREP: Build the supplied CIK-year-GVKEY merge input from the readable historical CIK/GVKEY link interval product.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: REQ_CIK_GVKEY
Evidence: E_CIK_LINK_SOURCE, E_PROBE_CIK_GVKEY, E_SELECTED_SCHEMAS

Preparation / proposed procedure:

1. Expand each valid link_start_date/link_end_date interval to the calendar years intersecting the employee CIK-year panel, while preserving the source CIK and GVKEY values.
2. Normalize CIK/GVKEY types to the Stata input contract and resolve overlapping or multiple links before writing cik-gvkey_linking.dta.

Validation to perform later:

- Check that the prepared table has one row per CIK-year where the code performs merge 1:1, and quantify unmatched/ambiguous links across the retained year range.

### A_TIGER_ACQUIRE: Acquire the 2018 Census TIGER/Line county shapefile archive and prepare its Stata map intermediates.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ_TIGER
Evidence: E_TIGER_SOURCE, E_TIGER_JOIN, E_TIGER_STATEFP, E_TIGER_RENDER, E_PUBLIC_TIGER_NAME, E_PUBLIC_TIGER_GEOID

Preparation / proposed procedure:

1. Obtain the official 2018 county archive from the route URL and preserve the shapefile with its attribute, index and projection sidecars.
2. Place the source under the supplied relative TIGER Line Shapefiles path and use the supplied shp2dta call to create tl_2018_us_county.dta and us_counties_coord.dta.

Validation to perform later:

- Check GEOID formatting against the code-created five-character county FIPS key and confirm STATEFP and geometry are available before mapping.

### A_SOFTWARE_SETUP: Resolve source-called Stata add-ons and command-path configuration using the documented project dependencies.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_GDUPLICATES, SW_CARRYFORWARD, SW_WINSOR, SW_FFIND, SW_ASREG, SW_EBALANCE, SW_ASTILE, SW_FSUM, SW_SHP2DTA, SW_SPMAP
Evidence: E_README_SOFTWARE, E_STATA_GDUPLICATES, E_STATA_CARRYFORWARD, E_STATA_WINSOR, E_STATA_FFIND, E_STATA_ASREG, E_STATA_EBALANCE, E_STATA_ASTILE, E_STATA_FSUM, E_STATA_SHAPE_TOOLS, E_STATA_SPMAP, E_PY_IMPORTS, E_PY_PACKAGE_METADATA, E_PY_PACKAGE_PROJECTION, E_ENVIRONMENT

Preparation / proposed procedure:

1. The current environment probe identifies Stata, reghdfe and ftools; configure asreg through the registered Stata command path where needed.
2. Check the exact source-called Stata commands gduplicates, carryforward, winsor, ffind, asreg, ebalance, astile, fsum, shp2dta and spmap; use the README installation list where applicable and resolve undocumented providers/versions before execution.
3. Python distribution metadata lists pandas, matplotlib and numpy; confirm import/API compatibility during future validation without running author modules.

Validation to perform later:

- Record command availability/version evidence for source-called add-ons and confirm imports under the selected Python runtime without running author modules.

### A_RUN_PROCEDURE: Conditional procedure for all six supplied program entry points, following the evidenced producer/consumer partial order and keeping independent figure branches separate.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: REQ_HQ, REQ_BLM, REQ_DIRECTOR, REQ_EXECUTIVE, REQ_EMP_CIK, REQ_CIK_GVKEY, REQ_EMP_STATE, REQ_COMPUSTAT, REQ_REFINITIV, REQ_COMMUNITY, REQ_COUNTY_DEM, REQ_JOINLEAVE, REQ_TIGER, SW_STATA, SW_REGHDFE, SW_FTOOLS, SW_PYTHON, SW_PANDAS, SW_MATPLOTLIB, SW_NUMPY, SW_GDUPLICATES, SW_CARRYFORWARD, SW_WINSOR, SW_FFIND, SW_ASREG, SW_EBALANCE, SW_ASTILE, SW_FSUM, SW_SHP2DTA, SW_SPMAP, I_INPUT_CLOSURE
Evidence: E_WORKDIR_MACRO, E_README_INPUTS, E_README_ORDER, E_README_STAGE_SAMPLE, E_README_STAGE_REPLACEMENT, E_README_STAGE_REGRESSIONS, E_README_STAGE_MAPS, E_README_STAGE_PYTHON, E_README_STAGE_DID, E_MAIN_MASTER_PRODUCER, E_MAIN_MASTER_READ_REPLACE, E_MAIN_MASTER_READ_REG, E_MAIN_MASTER_READ_DID, E_REPLACEMENT_DIR_OUTPUT, E_REPLACEMENT_EXEC_OUTPUT, E_REPLACEMENT_EMP_OUTPUT, E_JOINLEAVE_SOURCE, E_BLM_MAP_READ, E_TIGER_SOURCE, E_TIGER_JOIN, E_TIGER_STATEFP, E_TIGER_RENDER, E_PY_IMPORTS, E_PY_EMBEDDED_DATAFRAME, E_PY_FIGURE_OUTPUT

Preparation / proposed procedure:

1. Use a portable working copy. Before each Stata entry point, set its existing $path project-root macro to that copy and stage the named prepared inputs and writable relative output/log locations there; the screened macro value is not repeated or proposed as a source edit.
2. After the required data and software preconditions are met, run LT-sample construction.do first. It writes main-master.dta; confirm that product and its merge keys before running any supplied program that consumes it.
3. Run LT-replacement probabilities.do after sample construction for Table 2. It consumes main-master.dta, director/executive label panels and emp_gvkey-year_join-leave.dta, then writes replacement_dir_gvkey-year.dta, replacement_exec_gvkey-year.dta and replacement_emp_gvkey-year.dta. These are Table 2 outputs; do not make them prerequisites to a later program unless an actual consumer is established.
4. Run LT-regressions.do and LT-DiD plots.do after main-master.dta is produced. Their visible entry reads consume main-master.dta. The README lists replacement before regressions, but the supplied regression source does not establish a dependency on replacement outputs.
5. Run LT-protest maps.do as its own branch after blmprotests.dta and the 2018 TIGER shapefile plus sidecars are staged. Within that branch, shp2dta creates tl_2018_us_county.dta and us_counties_coord.dta before the GEOID join, STATEFP handling and spmap rendering.
6. Run LT-eco mag plot.py as an independent Python figure branch after the Python runtime and pandas/matplotlib/numpy packages are available. It constructs a DataFrame from in-program data and saves eco mag plot.png; no external data-file read is shown in the screened source.

Validation to perform later:

- Before launch, verify each named input against its cited native fields, key uniqueness, period and construction contract, and resolve the unverified input/software routes separately.
- Confirm main-master.dta exists before replacement, regression and DiD consumers; confirm the three replacement outputs as Table 2 results without inventing downstream edges.
- Confirm the protest-map Stata intermediates preserve the five-character GEOID join and required STATEFP/geometry fields, and confirm the Python figure output at its relative path.
- No supplied program was executed during this assessment; these are future validation steps after the input and software prerequisites are resolved.


## Remaining issues and prerequisites

- I_INPUT_CLOSURE [unresolved; full_pipeline]: The archive contains code and documentation but not the required prepared historical HQ, protest, director/executive classification, employee-count, Compustat, Refinitiv, state/county demographic, or Table 2 join/leave panels. The packaged geo workbook and GVKEY identifier list do not supply these contracts. Local candidates have concrete field/grain/history mismatches, and no producer for emp_gvkey-year_join-leave.dta is supplied.
- REQ_HQ [undetermined]: Historical firm headquarters input `hq.dta`, keyed by GVKEY-year and containing county FIPS and CIK for the supplied treatment construction.
- REQ_BLM [undetermined]: Prepared BLM event input `blmprotests.dta` with county_fips, date, pid and pcount; the supplied code derives county-level first-event and annual protest measures.
- REQ_DIRECTOR [undetermined]: Director-level `dirname_gvkey-year-dir_full-results.dta` with gvkey, year, input_id and author-generated gpt_race labels.
- REQ_EXECUTIVE [undetermined]: Executive-level `execname_gvkey-year-exec_full-results.dta` with gvkey, year, input_execid and author-generated gpt_race labels.
- REQ_EMP_CIK [undetermined]: Employee race-count input `emp_cik-year.dta`, keyed by CIK-year with n_white, n_api, n_hispanic and n_black.
- REQ_EMP_STATE [undetermined]: Employee state-year race-count input `emp_cik-state-year.dta`, keyed by CIK-state-year with sn_white, sn_api, sn_hispanic and sn_black.
- REQ_COMPUSTAT [undetermined]: Annual Compustat input with GVKEY/CIK, datadate/fyear, the supplied accounting and market fields, and both sic/sich fields consumed by the code.
- REQ_REFINITIV [undetermined]: Prepared Refinitiv firm-year input with ric, gvkey, year, dir_diver_score, policy_diveropp_d, target_diveropp_d, bod_genderdiver and exe_genderdiver.
- REQ_COMMUNITY [undetermined]: State-year community representation input `community_rep.dta` with black_pct, nonblackm_pct and white_pct.
- REQ_COUNTY_DEM [undetermined]: County-year demographic input with population/race/poverty/labor-force/education fields plus density, median household income and Gini used by the supplied county controls.
- REQ_JOINLEAVE [undetermined]: Table 2 firm-year workforce join/leave input with CIK, GVKEY, year and race-specific new-hire and leave-in/leave-out counts.
- REQ_TIGER [public_acquisition_required]: The 2018 US county TIGER/Line shapefile and its required shapefile sidecars; the supplied map code joins on GEOID, reads STATEFP and uses county geometry.
- SW_GDUPLICATES [unverified]: Supplied Stata code calls gduplicates; current command availability is not established.
- SW_CARRYFORWARD [unverified]: Supplied Stata code calls carryforward; README documents installation, but current command availability is not established.
- SW_WINSOR [unverified]: Supplied Stata code calls winsor; README documents installation. The separate winsor2 name was not substituted.
- SW_FFIND [unverified]: Supplied Stata code calls ffind; current command availability is not established.
- SW_ASREG [preparation_required]: Supplied code and README require asreg; the registered environment records it as available only with configuration.
- SW_EBALANCE [unverified]: Supplied Stata code calls ebalance; README documents installation, but current command availability is not established.
- SW_ASTILE [unverified]: Supplied Stata code calls astile; README documents installation, but current command availability is not established.
- SW_FSUM [unverified]: Supplied regression code calls fsum; current command availability is not established.
- SW_SHP2DTA [unverified]: Supplied map code calls shp2dta; README documents installation, but current command availability is not established.
- SW_SPMAP [unverified]: Supplied map code calls spmap; current command availability is not established.

## Review notes

- Scope remains full_pipeline and closure_complete is false. No separate analysis_only scope is supported by the packaged identifier list or the README-described aggregated firm-year panel; that panel has no names and is not a substitute for the classification inputs.
- Assessment coverage limit only: byte-first screening withheld one-based physical DiD ranges 1–6, 101–112, 126–137 and 151–162, plus README lines 91 and 146–147. These are not labeled an author-program defect, missing code, access barrier or required author patch; the supplied DiD program remains in scope, and no withheld body was used to infer absence. Scope remains incomplete because the actual input contracts and some dependency coverage are unresolved.
- A prior source-field comparison draft v1 associated probes too broadly. It was preserved; source_field_comparison_v2 corrected the table/probe associations and is the comparison audit basis, but neither comparison artifact is cited as supporting evidence here.
- The bounded Revelio workforce geo SAS probe returned unverified and is preserved without supporting evidence. Two Stata add-on metadata attempts produced no markers; they are preserved without supporting evidence. Do not interpret either as proof of absence.
- GPT-4 is historical label-generation context only. The supplied Stata code consumes prepared gpt_race inputs; no live model runtime or call is included in the supplied programs.
- The successful one-row local probes establish readability and selected columns, not full sample population, year coverage or author-extract identity. The CIK-GVKEY route uses historical link intervals with calendar-year preparation; interval uniqueness and full required coverage remain validation checks.
- No data were downloaded, no author program or software was executed, no source patch was proposed/applied, and no statistical or synthetic trial was performed. The 2018 TIGER route is an official public product acquisition; the exact compiled BLM and ACS variable mappings remain unresolved.
- The process-only paths listing note in probes/process_note_paths_only_listing.md is not scientific evidence and is not referenced by the draft.
