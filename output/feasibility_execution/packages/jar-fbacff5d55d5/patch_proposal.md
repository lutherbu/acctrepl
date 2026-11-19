# Patch proposal: jar-fbacff5d55d5

The Effect of Firms' Information Exposure on Safeguarding Employee Health: Evidence from COVID-19

DOI: 10.1111/1475-679X.12471

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow: embedded R SafeGraph preparation, firm information exposure and Infogroup ZIP matching, public control/policy data, ZIP main and county COVID outcomes, plus the S&P 500 validation companion.

Entry points: `00_Master_file.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 3/12471 - The-Effect-of-Firms-Information-Exposure-on-Safeguarding-Employee-Health-Evidence-from-COVID-19/ll-datasheet-code-and-identifiers.zip",
      "sha256": "30b206a9ab5b3fe417d5e22ad09e952ee83f18704a0806509928ad5e4b5e8564"
    },
    {
      "path": "JAR-Volume 61/Issue 3/12471 - The-Effect-of-Firms-Information-Exposure-on-Safeguarding-Employee-Health-Evidence-from-COVID-19/ll-online-appendix.pdf",
      "sha256": "98cd62dedc1ca8a40b7b01f1189dc6fc8249135ab39d1f0c3f4cb9c4b3df47c3"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "916edaa71ad7f1c44e934e229327c3dd3e539745b5e443c442c18d0d82a966d4"
}
```

## Proposed actions

### A_INPUT_STAGING: Resolve and stage compatible author-prepared, local or documented public inputs for the complete author workflow, retaining each product's actual fields, identifiers, population and required time history.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: I_SCOPE_INPUTS, R_SAFEGRAPH, R_TRACT_ZIP, R_FACTSET_PUBLIC, R_FACTSET_PRIVATE, R_BOARDEX_EDU, R_BOARDEX_COMPANY_EU, R_BOARDEX_COMPANY_REST, R_BOARDEX_OFFICERS, R_BOARDEX_COMPANY_PROFILE, R_BOARDEX_PSEUDO, R_WORLDSCOPE_SEGMENTS, R_CIQ_LINKS, R_WORLDSCOPE_BRANCH_FILES, R_COMPUSTAT_UNIQUE, R_INFOGROUP, R_INFOGROUP_MATCH_TARGETS, R_INFOGROUP_PRI_MATCH, R_PRI_SRI, R_DINGEL, R_CBP_2018, R_KEYSTONE_NPI, R_CITY_POLICY, R_CENSUS_GEOCODES, R_ELECTION_2020, R_MAYOR_ELECTIONS, R_NYT_COVID, R_CISA_ESSENTIAL, R_UNION_METRO, R_PLACEZIP, R_USZIPS, R_SOCIAL_CAPITAL, R_SP500_LIST, R_RAVENPACK_MAPPING, R_RAVENPACK_FEED, R_EARNINGS_TRANSCRIPTS, R_COMPUSTAT_2019
Evidence: E_WORKFLOW_TRACE, E_PACKAGE_SCOPE, E_FACTSET_INPUTS, E_BOARDEX_EDUCATION, E_WORLD_SCOPE, E_CIQ_LINKS, E_INFOGROUP_BASE, E_PRI_SRI, E_TELEWORK_CBP, E_COUNTY_POLICY, E_CITY_POLICY, E_CITY_GEOCODES, E_ELECTION_MAYOR, E_NYT_COVID, E_ESSENTIAL_UNION, E_ZIP_FILES, E_SOCIAL_CAPITAL, E_SP500_LIST, E_RAVENPACK, E_TRANSCRIPT_INPUT, E_COMPUSTAT_INPUT, E_CATALOG_NAMED, E_CATALOG_QUERIES, E_PUBLIC_DINGEL, E_PUBLIC_KEYSTONE, E_PUBLIC_ELECTION, E_PUBLIC_NYT_PERIOD, E_PUBLIC_NYT_FIELDS, E_PUBLIC_CISA, E_PUBLIC_UNION

Preparation / proposed procedure:

1. Use the full_pipeline requirements as the staging ledger; inspect authorized local candidates and exact catalog metadata for the named commercial products, treating catalog rows as candidates rather than evidence of access or compatibility.
2. For each selected route, verify the consumed fields and identifier formats, source population, product definition and date/history requirements before staging it under the author's expected name; preserve 7- and 14-day lead history and all branch-specific input populations.
3. For public products, use a documented compatible current product with ordinary filename/path staging when the required fields and history are supported. Verify remaining fields and coverage for the unverified Dingel, Keystone, election, CISA and UnionStats routes; retain the exact author URLs or workbook names until a compatible route is established.
4. Keep the separately required FactSet Revere public/private exports, BoardEx tables and manual branches, WorldScope segments, Capital IQ links, Infogroup and match files, PRI/SRI tables, RavenPack mapping/feed, transcripts, historical S&P 500 list and Compustat firm-year data distinct; do not infer missing license or substitute a current-company flag for historical index membership.
5. Use actualsample.dta only as the stated ZIP identifier list. Do not rebuild all source provenance independently or drop the ZIP main, S&P 500 validation or county COVID companion branch.

Validation to perform later:

- Before any future authorized analysis run, reconcile every consumed input in the ordered trace to a compatible staged route or a specific unresolved contract; retain the authored period, identifiers, branches and forward-history rows.

### A_RUNTIME_SETUP: Prepare the missing Stata add-ons and the exact embedded R/Python environments required by the supplied mixed-language stages.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_RSOURCE, SW_R_PACKAGES, SW_PYTHON_PACKAGES, SW_DISTINCT, SW_XFILL, SW_WINSOR2
Evidence: E_ENVIRONMENT, E_RUNTIME_EMBEDDED, E_SW_RSOURCE, E_SW_DISTINCT, E_SW_XFILL, E_SW_WINSOR2, E_SW_PYTHON, E_LANGUAGE_DRIVERS

Preparation / proposed procedure:

1. Configure the Stata rsource bridge to the installed R 4.5.0 and make readr, haven and data.table available in the embedded R runtime used by SafeGraph preparation.
2. Make distinct, xfill and winsor2 available to Stata 18; esttab, estpost, estadd, eststo, reghdfe and statastates already passed exact command lookups.
3. Prepare the Stata embedded Python 3.13.5 environment with pandas, numpy, cleanco and a supported Excel writer. Do not assume the separate Miniforge Python or package metadata alone proves embedded-backend compatibility; pyreadstat was also absent in the metadata probe but is not asserted as a direct code dependency.

Validation to perform later:

- After software setup, repeat only the bounded exact command and embedded-package metadata checks before any future authorized author run; do not use syntax, import or statistical trials as setup checks.

### A_LAYOUT: Prepare a portable working copy that preserves the master, all 11 called Stata stages, working data and output directory while keeping relative includes valid across current-directory changes.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_PATH_ORDER
Evidence: E_MASTER_ORDER, E_DRIVER_PATH, E_PATH_LITERAL, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Preserve the downloaded package unchanged and create a separate working copy with the master at a stable project root, the 11 supplied stages in the expected Dofiles location, a 2 Data working tree and the 2_output folder.
2. Configure one stable project/data root for all stages and reset the current directory before each later master include after a subprogram changes directories; reconcile every producing and consuming path rather than editing only the first include.
3. Keep all 11 stages and the S&P 500, ZIP main/cross-sectional and county COVID outputs in the selected full workflow.

Validation to perform later:

- Review the portable working-copy paths and master include order across all supplied files before any future authorized run; do not run the author programs during this assessment.

### A_COUNTYZIP_ORDER: Prepare countyzip from the named uszips workbook before its first consumer in 14_Import_Other_Data.do, preserving the authored state and county mapping.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_COUNTYZIP_ORDER, R_USZIPS
Evidence: E_COUNTYZIP_USE, E_ZIP_FILES, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. After staging a compatible uszips.xlsx, run or move the supplied ZIP-to-county construction block so countyzip exists before the earlier ZIP/county teleworkability merge.
2. Keep the original merge keys, Puerto Rico handling and retained county_fips fields; do not change the mapping definition to address ordering.

Validation to perform later:

- Confirm the produced countyzip identifier fields are the same ones consumed by the later ZIP/county merge before any future authorized full run.

### A_INFOGROUP_MATCH: Resolve the distinct Infogroup name-match target and PRI/SRI manual match handoffs and place the supplied Python producer before its Stata workbook consumer.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_INFOGROUP_MATCH_ORDER, I_INFOGROUP_HANDOFF, R_INFOGROUP, R_INFOGROUP_MATCH_TARGETS, R_INFOGROUP_PRI_MATCH, R_PRI_SRI
Evidence: E_INFOGROUP_BASE, E_INFOGROUP_MATCH_ORDER, E_INFOGROUP_MATCHER, E_INFOGROUP_MATCHER_OUTPUT, E_PRI_SRI, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Stage compatible 2019 Infogroup records and establish the author source and company_name population for dataset_tomatch.dta.
2. Preserve the supplied order dependency: create infogroup2019_name.dta, run the embedded Python matcher, produce infogroup_dataset_match.xlsx, then import that workbook in the Stata merge stage.
3. Separately identify the producer and exact match_id, match_name and id_numerical contract for infogroup_prisri_match.xlsx; do not reuse the other match workbook without evidence.
4. Keep the PRI/SRI GVKEY-flag inputs and all ZIP-level aggregation branches in the workflow.

Validation to perform later:

- Before the Infogroup stage proceeds, verify the target-file source, the two distinct workbook handoffs and their field/identifier mappings against the supplied consumer code.

### A_BOARDEX_BRANCHES: Resolve the absent BoardEx pseudo-country, Capital IQ link and WorldScope country-branch producer contracts while preserving every control/placebo branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_BOARDEX_HANDOFF, R_BOARDEX_PSEUDO, R_WORLDSCOPE_BRANCH_FILES, R_CIQ_LINKS, R_COMPUSTAT_UNIQUE
Evidence: E_BOARDEX_PSEUDO, E_WORLD_SCOPE_COMBINE, E_CIQ_LINKS, E_PRI_SRI, E_CATALOG_NAMED, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Identify the author producers and field contracts for pseudo_boardex_identifier.dta, CompanyID_isin.dta, CompanyID_gvkey.dta and compustat_unique_gvkey.dta; the supplied comments and catalog metadata are not complete producer specifications.
2. Obtain the exact source filters and schemas for usfirm_EU_branch_gvkey.dta, usfirm_UK_branch_gvkey.dta, usfirm_CA_branch_gvkey.dta and usfirm_Asia_branch_gvkey.dta before supplying the merges; do not guess the country edits from the China/Italy branch.
3. Retain the China/Italy exposure construction and all EU, UK, Canada and Asia control/placebo branches in the full target.

Validation to perform later:

- Confirm each missing producer's keys and output fields against its supplied downstream merge before closing the branch handoff issue.

### A_COLUMN_CONTRACT: Preserve conditional input and post-merge column contracts until compatible source data and their actual imported namespaces can be inspected.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_COLUMN_CONTRACT, R_PLACEZIP
Evidence: E_RAVENPACK, E_MAIN_CLEAN, E_MAIN_FIELDS, E_PLACE_FIELDS, E_COUNTY_CLEAN, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Inspect the actual merged RavenPack namespace before deciding whether rp_pr_date is already supplied or whether rp_pr_date_new must be mapped; do not infer absence from a generated statement alone.
2. Compare the actual variable produced after winsor2 exposure_firm_count_scaled, trim with the downstream _tr and exposure_firm_count_n100_scaletr references; retain the exact names until source/output evidence supports a specific repair.
3. Check whether the imported placezip or prepared panel carries Population and demo_asian before treating either as absent; preserve the code's ZIP and county branch use.

Validation to perform later:

- Use bounded metadata on compatible staged inputs and generated outputs before proposing a field repair; do not run author code or alter the underlying variable definitions during this assessment.

### A_SOCIAL_CAPITAL_PREPARATION: Satisfy the single county social-capital input through either a compatible prepared workbook or the author-described source-workbook/manual-extraction route.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_SOCIAL_CAPITAL
Evidence: E_SOCIAL_CAPITAL, E_PACKAGE_SCOPE

Preparation / proposed procedure:

1. Choose one compatible route: stage 2 Data/social_capital_county.xlsx with its County Index sheet, or use social-capital-project-social-capital-index-data.xlsx and perform the documented manual extraction into social_capital_county.xlsx, retaining CountyLevelIndex.
2. Treat the raw source workbook and prepared workbook as alternatives in one input chain, not separate mandatory inputs. Keep the source workbook schema, county identifier definition, period/history and editing application unresolved until the selected route is inspected.
3. After the selected workbook is staged, preserve the supplied Stata operation that keeps county_fips and CountyLevelIndex, converts county_fips to numeric and writes social_capital_county_clean.dta.

Validation to perform later:

- For the selected route, verify the county_fips/CountyLevelIndex contract and available county/time coverage by bounded workbook metadata; do not invent population counts or require both workbooks.


## Remaining issues and prerequisites

- I_SCOPE_INPUTS [unresolved; full_pipeline]: The package contains all 11 Stata stages, documentation and actualsample.dta, but no author 2 Data exports or full analysis panel. actualsample.dta is the stated 18,316-ZIP identifier list only. All 67 frozen dependencies and the additional manual/unlisted handoffs are traced; most required input routes and schemas remain unverified.
- I_PATH_ORDER [preparation; full_pipeline]: The master includes scripts under ./Dofiles although the packaged scripts are at package root; called scripts set a literal 2 Data working directory, so later relative includes and data/output paths need a consistent portable working-copy layout and working-directory reset plan.
- I_COUNTYZIP_ORDER [preparation; full_pipeline]: 14_Import_Other_Data.do consumes countyzip before importing uszips.xlsx and saving countyzip later in the same script. The source and crosswalk definition are supplied; place the existing construction before its first consumer without changing the mapping.
- I_INFOGROUP_MATCH_ORDER [preparation; full_pipeline]: 13_Import_Infogroup.do imports infogroup_dataset_match.xlsx before its later embedded Python block produces that workbook. Preserve the supported chain: create infogroup2019_name.dta, run the embedded matcher, then import the match workbook; stage the sequence coherently in a working copy.
- I_INFOGROUP_HANDOFF [unresolved; full_pipeline]: The embedded matcher reads dataset_tomatch.dta/company_name without a supplied producer or source population. Separately, the PRI/SRI branch consumes infogroup_prisri_match.xlsx, which is not produced by the shown matcher that writes infogroup_dataset_match.xlsx. Retain both handoffs and establish their exact source, fields and producer before that branch can close.
- I_BOARDEX_HANDOFF [unresolved; full_pipeline]: The source consumes pseudo_boardex_identifier.dta and four EU/UK/CA/Asia WorldScope branch-by-GVKEY outputs, but the complete producer blocks and prepared schemas are absent. CompanyID link files and compustat_unique_gvkey are additional consumed inputs without supplied producers; preserve the Italy/China and placebo/control branches pending exact specifications.
- I_COLUMN_CONTRACT [unresolved; full_pipeline]: Keep the exact rp_pr_date_new/rp_pr_date, exposure_firm_count_scaled versus downstream _tr spelling, and imported Population/demo_asian contracts for post-merge review. The package does not prove these fields absent: imported/prepared namespaces may already contain them, and no trial or guessed repair is supported.
- R_SAFEGRAPH [undetermined]: SafeGraph daily social-distancing CSV.GZ files read by embedded R for 2020-01-01 through 2020-07-04 and then aggregated by census tract and TRACT_ZIP_032020.xlsx to ZIP/date inputs.
- R_TRACT_ZIP [undetermined]: March 2020 census-tract-to-ZIP crosswalk used to map SafeGraph census block groups through tract_11 to ZIP identifiers; code retains the highest TOT_RATIO row for each tract.
- R_FACTSET_PUBLIC [undetermined]: FactSet Revere public-firm relation and headquarters-country exports used together to create factset_public and country exposure measures.
- R_FACTSET_PRIVATE [undetermined]: FactSet Revere private-firm relation and headquarters-country exports used together to create factset_private and then exposure_factset.
- R_BOARDEX_EDU [undetermined]: BoardEx individual education table needed to classify directors linked to Italy and China/Hong Kong company tables.
- R_BOARDEX_COMPANY_EU [undetermined]: BoardEx Company_EU table joined to education records by CompanyID to mark Italy exposure.
- R_BOARDEX_COMPANY_REST [undetermined]: BoardEx Company_Rest table joined to education records by CompanyID to mark China/Hong Kong exposure.
- R_BOARDEX_OFFICERS [undetermined]: BoardEx North America company-officer composition table used to aggregate director exposure to CompanyID.
- R_BOARDEX_COMPANY_PROFILE [undetermined]: BoardEx North America company profile table used to select U.S. quoted/private firms, company identifiers, addresses and ZIPs.
- R_BOARDEX_PSEUDO [undetermined]: BoardEx pseudo-country company identifier table merged into the China/Italy company output to preserve UK, Canada, EU and Asia education-exposure controls.
- R_WORLDSCOPE_SEGMENTS [undetermined]: WorldScope segment-by-country records for North American firms; code filters U.S. firms and country text for China/Italy branch presence and keeps years >= 2016.
- R_CIQ_LINKS [undetermined]: Capital IQ company-ID mappings from ISIN to companyid and from companyid to GVKEY, both used to link WorldScope segment records to Compustat firms.
- R_WORLDSCOPE_BRANCH_FILES [undetermined]: Four pseudocountry WorldScope branch-by-GVKEY outputs merged with China/Italy branch flags for EU, UK, Canada and Asia.
- R_COMPUSTAT_UNIQUE [undetermined]: Unique-GVKEY Compustat helper table used in both WorldScope branch linking and PRI/SRI firm preparation.
- R_INFOGROUP [undetermined]: Infogroup 2019 firm-location records used to generate ZIP/industry/firms aggregates and merge exposure records by ABI, parent number, ticker and name.
- R_INFOGROUP_MATCH_TARGETS [undetermined]: Separate firm-name target file read by the embedded Python matcher to produce the Infogroup exposure match workbook.
- R_INFOGROUP_PRI_MATCH [undetermined]: Second author/manual Infogroup-to-PRI/SRI name-match workbook consumed by the PRI/SRI branch.
- R_PRI_SRI [undetermined]: GVKEY-keyed SRI mutual-fund and PRI institution indicators joined with Compustat firm identifiers before Infogroup ZIP aggregation.
- R_DINGEL [undetermined]: Three-digit NAICS teleworkability measure used to weight ZIP and county establishment counts.
- R_CBP_2018 [undetermined]: 2018 ZIP Business Patterns detailed establishment file used to weight 3-digit NAICS teleworkability by ZIP and county.
- R_KEYSTONE_NPI [undetermined]: County and state COVID non-pharmaceutical intervention start dates used to derive policy and lockdown dates.
- R_CITY_POLICY [undetermined]: City-government COVID response workbook used to derive city policy dates and merge city names to Census place identifiers.
- R_CENSUS_GEOCODES [undetermined]: 2017 Census place geocodes used as the city-policy place-FIPS crosswalk.
- R_ELECTION_2020 [undetermined]: County-level 2020 presidential election results used to compute Democratic, Republican and vote-margin indicators.
- R_MAYOR_ELECTIONS [undetermined]: OurCampaign mayoral election workbook used to select the latest qualifying city mayoral win from 2010 through 2019.
- R_NYT_COVID [public_acquisition_required]: NYT county COVID cumulative cases and deaths used to create daily outcomes and 7-/14-day forward values for the county companion analysis.
- R_CISA_ESSENTIAL [undetermined]: CISA v4.1 six-digit NAICS essential-industry indicators used to weight Infogroup ZIP firm counts.
- R_UNION_METRO [undetermined]: 2020 metropolitan-area union membership measure and author-prepared ZIP crosswalk, weighted by maximum population.
- R_PLACEZIP [undetermined]: ZIP-to-place workbook used to assign each ZIP to the city with the largest population and carry place/state identifiers into the ZIP panel.
- R_USZIPS [undetermined]: ZIP-to-county/state workbook from which the supplied code generates countyzip.dta.
- R_SOCIAL_CAPITAL [undetermined]: One county-level social-capital index input consumed in 14_Import_Other_Data.do to create social_capital_county_clean.dta. A compatible prepared workbook OR the author-named source workbook followed by the documented manual extraction can supply this same contract; the two files are not separate mandatory empirical inputs.
- R_SP500_LIST [undetermined]: WRDS S&P 500 constituent history workbook used to form the validation companion sample as of January 1, 2020.
- R_RAVENPACK_MAPPING [undetermined]: RavenPack entity-mapping export used to connect S&P 500 tickers and names to RavenPack entity IDs and country attributes.
- R_RAVENPACK_FEED [undetermined]: RavenPack COVID news-event export used to find the first press-release event date for each linked S&P 500 entity.
- R_EARNINGS_TRANSCRIPTS [undetermined]: Prepared firm-quarter earnings-call transcript analysis table used to add the latest pre-April 2020 COVID exposure and risk measures to the S&P 500 companion.
- R_COMPUSTAT_2019 [undetermined]: Compustat firm-year records used to add fiscal 2019 accounting controls to the S&P 500 validation companion.
- SW_RSOURCE [preparation_required]: The exact rsource command lookup failed. SafeGraph uses embedded R, so configure the required Stata-to-R bridge before a future run.
- SW_R_PACKAGES [preparation_required]: The active embedded R runtime is version 4.5.0, but readr, haven and data.table were not available in its package metadata probe. foreign was present; that does not establish compatibility with the code's required libraries.
- SW_PYTHON_PACKAGES [preparation_required]: The active Stata Python 3.13.5 probe found pandas, numpy, cleanco, openpyxl, xlsxwriter and pyreadstat unavailable. The embedded matcher directly imports pandas, numpy and cleanco and writes an Excel handoff; configure those imports and a supported Excel writer in this exact interpreter before any future run. The missing pyreadstat result is recorded but is not asserted as a required backend.
- SW_DISTINCT [preparation_required]: The exact distinct command lookup failed; the supplied city and mayor matching preparation invokes distinct.
- SW_XFILL [preparation_required]: The exact xfill command lookup failed; the Infogroup exposure stage uses xfill to fill linked attributes.
- SW_WINSOR2 [preparation_required]: The exact winsor2 command lookup failed; the main and county analysis cleaning stages call winsor2 with trim. Preserve the downstream variable-name contracts for later source/data review; no trial was performed.

## Review notes

- The assessed target is the complete supplied author workflow: embedded R SafeGraph preparation; FactSet, BoardEx and WorldScope exposures; Infogroup/PRI/SRI matching; public/policy/geography inputs; S&P 500 validation; ZIP main/cross-sectional analyses; and the county COVID companion. All 11 supplied Stata stages and all 67 frozen dependency IDs are retained in the ordered trace and dependency review.
- The frozen title and DOI are retained. The README/datasheet and supplied programs inspected for this variant do not support a material title/DOI conflict. The only packaged data file, actualsample.dta, is an 18,316-ZIP identifier list, not a full analysis panel; no analysis_only scope is supported.
- Input requirements distinguish author-prepared files and manual handoffs from candidate catalog metadata. Exact commercial product families were searched in the registered frozen catalog; matches are discovery metadata only and establish neither live access nor compatibility. No absence-of-license finding is made. The NYT documentation supports a 2020 county CSV route with the cited six-column header; stage a compatible annual file under the authored name while retaining the forward rows needed by the county code. Other public routes remain unverified where the static documentation did not establish the exact file/schema or history.
- Imported/prepared namespaces may already contain rp_pr_date, Population, demo_asian or exposure fields. The named field contracts remain conditional pending matching input/output evidence; no source repair, syntax trial, import or analysis trial was performed.
- E_PUBLIC_FAILURES is process-only evidence for failed Census and JEC static-document opens and is intentionally unreferenced in every evidence_ids list. The earlier explicit Keystone README open was summarized as a cache miss without retained raw output; that historical response is not reconstructed, and the later repository-root README is used only for its supported generic description. Initial helper failure receipts and successful reruns are preserved under probes/ as process history.
- Program-source credential/connection scanning occurred before source display. No provider/account/entity/person/city/court queries, contact, forms, data/API/model/archive payload downloads, link-ID clicks, author source imports, parsing/syntax/statistical/synthetic trials, installations or applied source edits occurred. Software evidence is limited to bounded runtime and exact command/package metadata probes; execution_verified remains false.
- The county social-capital source workbook and its prepared County Index workbook are alternative routes for one consumed county_fips/CountyLevelIndex contract. The raw source schema, county definition, period/history and editing application remain unknown; the manual step is retained only on that conditional route. The existing _gnvals probe is successful and now accounts for the Infogroup egen nvals() helper.
