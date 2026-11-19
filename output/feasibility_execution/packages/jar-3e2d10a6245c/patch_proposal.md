# Patch proposal: jar-3e2d10a6245c

Externalities of Financial Statement Fraud on the Incoming Accounting Labor Force

DOI: 10.1111/1475-679X.12501

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

All three supplied program branches: AAER construction, HERI preparation, and the mixed SAS/Stata EMSI preparation/model block. Author-prepared compatible inputs are alternative routes when confirmed; no analysis-only scope is supported by the current five-file inventory.

Entry points: `CCM_AAER_Code.sas`, `CCM_HERI_Code.do`, `emsicode 5.16.2023.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 5/12501 - Externalities-of-Financial-Statement-Fraud-on-the-Incoming-Accounting-Labor-Force/ccmdatasheetcodeandidentifiers.zip",
      "sha256": "7c76ab422514decd207d0635dd11895fadfcedfee2e9be1d2de4f9b562cd3635"
    },
    {
      "path": "JAR-Volume 61/Issue 5/12501 - Externalities-of-Financial-Statement-Fraud-on-the-Incoming-Accounting-Labor-Force/ccm-online-appendix.pdf",
      "sha256": "7d9725a484ff32bc21edc564cb2e63790a3a1f2ef7d26ee472e23a4db58f1911"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "58014ddc7a33ca39c9e9723b26c0bd99653e638dc3718814b4b28524152b08f6"
}
```

## Proposed actions

### A_AAER_INPUTS: Prefer a compatible author-prepared fraud output. If raw AAER reconstruction is intended, resolve the missing macro context and source maps, and retain the exact named output variants for the supported persistence step. Confirm existing permitted access separately without conducting searches or inferring a missing license.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_AAER_FRAUD, I_INPUTS, I_MACROS, SW_SAS, SW_SAS_PCFILES
Evidence: E_INVENTORY, E_AAER_DOC, E_AAER_LINK_COMPANY, E_AAER_LINK_LOCATIONS, E_AAER_LINK_CIK, E_AAER_MAP_IMPORT, E_AAER_OUTPUT, E_AAER_COUNTY_OUTPUT, E_CATALOG_COMMON, E_CATALOG_SPECIFIC, E_ENV, E_SAS_PCFILES, E_TRACE_02

Preparation / proposed procedure:

1. Ask for complete author-prepared state/year and county/year JAR/highmedia/lowmedia inputs first, including identifiers, years, fields and media definitions.
2. If the raw route is needed, obtain the exact macros.sas include, AAER/LM/manual input files, and the author's Compustat/CRSP alias definitions; do not perform Factiva, company, person, or entity searches.
3. Confirm the user's current permitted access separately for any Factiva, Compustat, CRSP/WRDS or EMSI product; product names and the quoted author agreement do not prove the user's access status.
4. Confirm the existing SAS runtime and PC Files Server/EXCELCS configuration; do not assume availability from the installed-path listing.

Validation to perform later:

- Before a future authorized run, verify the selected prepared or raw route has the exact consumed identifier fields and required period.
- Map each generated product and variant to the exact named consumer input path; roots may differ, and field/history compatibility is validated separately.

### A_HERI_INPUTS: Request a compatible author-prepared HERI panel and covariates first. If raw inputs are intended, identify the exact 2016/2020 versions and missing maps/controls, then verify merge keys and years. Resolve the disagg read order before any future run.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_HERI_PANEL, R_HERI_STATE_ABBREV, R_HERI_LOCATIONS, R_HERI_GDP, R_HERI_FRAUD, R_HERI_ZIP, R_HERI_UNEMPLOYMENT, R_HERI_CENSUS, R_HERI_BEAPI, I_INPUTS, I_HERI_ORDER
Evidence: E_INVENTORY, E_HERI_SURVEY_YEARS_2016, E_HERI_SURVEY_YEARS_2020, E_HERI_EARLY_DISAGG, E_HERI_2016_DISAGG_PRODUCER, E_HERI_2020_DISAGG_PRODUCER, E_HERI_STATE_ABBREV, E_HERI_LOC_HERI_SENIOR, E_HERI_LOC_ZIP_STATE, E_HERI_UNEMPLOYMENT, E_HERI_CENSUS_FIELDS, E_HERI_BEAPI_INPUT, E_BLS_LAUS, E_BEA_CAInc1, E_PUBLIC_CHECKS, E_TRACE_02

Preparation / proposed procedure:

1. Use a complete author-prepared panel if its fields, sample years, identifiers and weights match the supplied consumer; do not require it in addition to raw files.
2. Otherwise obtain the named 2016 DTA and 2020 SAV source components plus the exact StateNamesAbbrev, HERISeniorStates, USZipCodesStates, unemployment, Census and BEA inputs.
3. For the early disagg label read, first confirm whether OriginalsDTA/disagg.dta is intentionally pre-existing; if absent, move that label preparation after the same-file producer in a working copy without changing the analyses.
4. Confirm the HERI fraud and ZIP/FIPS inputs are physically saved at the exact paths the do-file reads; do not substitute same-basename files from other roots.

Validation to perform later:

- Check expected fields/keys (year, subjid, acerecode, homezip, FIPS and year/state joins), periods, survey version, and weight definitions against the supplied source.
- Confirm any order preparation uses the exact producer output and does not omit the HERI source/analysis branches.

### A_EMSI_INPUTS: Request a compatible author-prepared Stata input first. If the raw EMSI route is intended, resolve the current agreement scope, three profile inputs, IPEDS mapping, and distinct fraud/control field and history requirements. The SAS-to-Stata load step is covered as supported routing preparation. No licensed data are downloaded or queried.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_EMSI_PROFILES, R_EMSI_IPEDS, R_EMSI_FRAUD, R_EMSI_UNEMPLOYMENT, R_EMSI_GDPG, R_EMSI_CENSUS, R_EMSI_BEAPI, I_INPUTS, SW_SAS, SW_SAS_PCFILES
Evidence: E_INVENTORY, E_EMSI_SOURCE_PURCHASED, E_EMSI_LICENSE, E_EMSI_PROFILE_EDU, E_EMSI_PROFILE_SKILLS, E_EMSI_PROFILE_OCCUPATIONS, E_EMSI_IPEDS, E_EMSI_FRAUD_READ, E_EMSI_UNEMPLOYMENT, E_EMSI_GDPG, E_EMSI_BEAPI, E_EMSI_CENSUS, E_IPEDS_PUBLIC, E_BLS_LAUS, E_BEA_CAInc1, E_CENSUS_POPEST, E_TRACE_02

Preparation / proposed procedure:

1. Ask for an author-prepared model input if available; otherwise confirm lawful local EMSI profile copies and the data-sharing agreement's current scope without inferring user status from the author agreement.
2. Confirm exact source fields, identifiers, units and history for IPEDSStates.csv, unemployment.csv, GDPg.csv, the EMSI Census member and the EMSI CAINC1 file.
3. Use the separate state-year JAR fraud product for EMSI only after its fields, JAR definition and exposure history match the consumer; do not substitute HERI county or media-split variants.
4. Confirm SAS and the required EXCELCS/PC Files Server setup before using the SAS segment.

Validation to perform later:

- Verify all author-required fields, units, identifiers and year coverage for the chosen input route before any authorized execution.
- For a prepared Stata input, check the consumed model fields; for the raw route, use the supplied SAS export and the supported Stata load step without changing the model or sample.

### A_EMSI_ROUTING: In a working copy, extract the Stata commands beginning at the explicit heading after the preceding SAS export and add a Stata load for that segment's `all` dataset. Configure the export and load paths consistently; preserve every supplied model command, order and sample. Validate the serialized fields before a future run.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_EMSI_LANGUAGE, I_EMSI_HANDOFF, SW_STATA, SW_REGHDFE, SW_FTOOLS
Evidence: E_EMSI_OUTPUT, E_EMSI_STATA_BLOCK, E_EMSI_FIRST_STATA, E_EMSI_REGHDFE, E_ENV, E_TRACE_02

Preparation / proposed procedure:

1. Keep the SAS data-preparation segment and its PROC EXPORT of dataset all in place.
2. At the beginning of the extracted Stata block, add a use/load step for the all dataset emitted by that preceding SAS export, and configure the writer and reader paths consistently for the runtime.
3. Move the complete Stata block starting at the explicit heading to a separate .do runner; preserve the table/figure commands, regressors, fixed effects, clusters, and sample definitions.

Validation to perform later:

- Check that the exported all dataset contains the fields consumed by the Stata block and that its configured load path resolves to that same output.
- Compare the prepared Stata block line-for-line with the supplied segment; do not change the model or sample.

### A_AAER_OUTPUT_SETUP: For the raw AAER route, persist the named PROC FREQ fraud products and the SASHELP.ZIPCODE-derived Zipcode dataset, then save/copy each to the exact existing consumer path. This is routing/setup preparation; exact schema, variant and history compatibility remains a separate unresolved check.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: I_HANDOFF, I_HANDOFF_CONTRACT, R_AAER_FRAUD, R_HERI_FRAUD, R_HERI_ZIP, R_EMSI_FRAUD
Evidence: E_AAER_OUTPUT, E_AAER_COUNTY_OUTPUT, E_AAER_HISTORY, E_AAER_ZIP_WORK, E_HERI_FRAUD_READ, E_HERI_COUNTY_FRAUD_READ, E_HERI_ZIP_READ, E_EMSI_FRAUD_READ, E_SAS_BLOCK_COMMENT, E_TRACE_02

Preparation / proposed procedure:

1. Persist the named state/county JAR, highmedia and lowmedia PROC FREQ products; place the corresponding state/county variants at the existing CCM inputs read by HERI.
2. Persist/copy the Zipcode result from SASHELP.ZIPCODE to the exact physical SAS7BDAT path read by HERI.
3. Save/copy only the state-year JAR product to the distinct EMSI input path; retain separate CCM and EMSI roots and do not substitute county or media-split products for EMSI JAR.
4. Keep the compatible author-prepared fraud-output route available as an alternative to raw AAER construction.

Validation to perform later:

- At each consumer, compare actual fields, identifiers, variant definitions and periods with its required input contract; retain any mismatch or unknown history as unresolved.
- Confirm each consumer path receives the intended producer product; different roots do not require author confirmation by themselves and do not prove product equivalence.


## Remaining issues and prerequisites

- I_INPUTS [unresolved; full_pipeline]: The frozen inventory contains two PDFs and three program files but no empirical datasets. Required routes, product versions, fields, identifiers, and histories remain unverified. Compatible author-prepared data are preferred alternatives where they can supply the required inputs.
- I_MACROS [unresolved; full_pipeline]: The AAER program has a dynamic macros.sas include and unresolved macro/library context; that support file is absent from the assigned inventory, so expansion and output locations remain unknown.
- I_HANDOFF [preparation; full_pipeline]: The AAER SAS code names state/county JAR and highmedia/lowmedia PROC FREQ outputs and creates a Zipcode dataset from SASHELP.ZIPCODE, while HERI/EMSI read corresponding physical inputs. Persisting/copying each named product to the exact existing consumer paths is supported routing/setup preparation. Keep the CCM and EMSI roots distinct; this preparation does not declare their files identical.
- I_HERI_ORDER [preparation; full_pipeline]: The HERI major-label block reads the 2016 and 2020 OriginalsDTA disagg paths before later code creates those exact files. The label outputs are not used later in the supplied do-file, but the early reads can stop the file when no prior copy exists; this is a source-supported order-preparation candidate.
- I_EMSI_LANGUAGE [preparation; full_pipeline]: The .sas container includes SAS imports/transforms and an explicit Stata regression block after PROC EXPORT. Assess both supplied segments; extraction/routing at that boundary is preparation, and the extension alone does not establish the language of the whole file.
- I_EMSI_HANDOFF [preparation; full_pipeline]: The SAS segment constructs dataset all from bachelors15c and exports it as Stata format immediately before the explicit Stata regression block. Adding a Stata load for this preceding export and routing the block into a driver are known setup preparation steps. Preserve the supplied model and sample; validate the exported fields and configured path before any future run.
- I_HANDOFF_CONTRACT [unresolved; full_pipeline]: The named producer/consumer stages do not establish data-level compatibility for every state/county JAR, highmedia, lowmedia and ZIP product: exact fields, variant definitions and historical coverage still require validation at each consumer. Distinct roots and similar basenames do not prove equivalence.
- R_AAER_FRAUD [undetermined]: State/county fraud measure data for the downstream HERI and EMSI consumers. Use a compatible author-prepared output as the preferred route; raw AAER reconstruction is an alternative, not an additional requirement. The raw route uses the 2020 AAER workbook, manual missing-GVKEY mapping, Compustat/CRSP aliases, LM header, Factiva reveal sheets, county population workbook, and the missing macro context. No company/person/entity lookup was performed.
- R_HERI_PANEL [undetermined]: HERI Freshman Survey panel needed by the Stata preparation branch, covering the author's combined 2016/2020 versions. The code comments report 2016 through 2006 and 2020 through 2009; raw inputs are six 2016 DTA components plus disagg and seven 2020 SAV components. A compatible author-prepared panel is an alternative to acquiring and assembling both raw versions.
- R_HERI_STATE_ABBREV [undetermined]: The HERI GDP producer merges the separately named StateNamesAbbrev.dta map; the file is not among the five package files.
- R_HERI_LOCATIONS [undetermined]: Two separate author-specific HERI location crosswalks support state assignment and location checks: HERISeniorStates.dta and USZipCodesStates.dta.
- R_HERI_GDP [undetermined]: State GDP growth and lag controls. The do-file can consume an author-prepared gdpstatereal.dta with GDPg, or build it from two BEA state-GDP CSVs plus the separate state-name map; these are alternative routes.
- R_HERI_FRAUD [undetermined]: State and county fraud SAS7BDAT inputs consumed by HERI from the CCM data root. The AAER source names matching PROC FREQ products; persistence/copying to HERI's paths is a preparation route. Exact fields, variant definitions and history remain to be validated. A compatible prepared file is an alternative.
- R_HERI_ZIP [undetermined]: HERI reads a physical zipcode.sas7bdat file. The AAER program builds a bare Zipcode WORK dataset from SASHELP.ZIPCODE; persisting/copying that named product to HERI's existing input path is preparation, with source-column and ZIP/FIPS coverage compatibility still unverified.
- R_HERI_UNEMPLOYMENT [undetermined]: HERI's state unemployment control file, joined by year and full state name, with author-named 1980-2019 history.
- R_HERI_CENSUS [undetermined]: The HERI-root Census SAS file supplies county and state STCOU/FIPS, year, age, education, and minority measures for the supplied program.
- R_HERI_BEAPI [undetermined]: The HERI-root BEA CAINC1 file supports county/state per-capita income controls for 1969-2019.
- R_EMSI_PROFILES [undetermined]: EMSI education, skills, and occupation profile inputs required by the raw SAS preparation branch. The author datasheet says the profiles were purchased and the quoted agreement restricts public dataset access; neither fact establishes this user's present license or entitlement. A compatible author-prepared model input is the preferred alternative.
- R_EMSI_IPEDS [undetermined]: The EMSI branch imports a separate IPEDSStates.csv mapping used to attach institution/state identifiers.
- R_EMSI_FRAUD [undetermined]: The EMSI SAS library reads its own state-year JAR fraud file. The AAER stage names a corresponding state-year JAR product that can be saved/copied to that consumer path as setup if its fields and history match. The separate roots remain distinct, and compatibility is not inferred from the basename.
- R_EMSI_UNEMPLOYMENT [undetermined]: The EMSI unemployment.csv input must provide year and unemployment measure with an FIPS value whose formatting supports the code's two-digit state extraction.
- R_EMSI_GDPG [undetermined]: The EMSI branch imports GDPg.csv and averages GDP growth over high-school and college exposure windows. No producer/export to this CSV path appears in the supplied mixed-language file.
- R_EMSI_CENSUS [undetermined]: The EMSI library reads its own us_census_1980_2019 SAS member for robustness controls; it is separate from the same-basename HERI-root file.
- R_EMSI_BEAPI [undetermined]: The EMSI branch imports a separate [redacted-path-623c3b8a3ec1] CAINC1 file for county personal-income growth robustness controls; do not equate it with the HERI-root file solely by basename.
- SW_SAS [unverified]: The assigned environment metadata does not verify a SAS runtime. No SAS executable, startup, version, autoexec, PROC CONTENTS or dataset-read command was invoked in this package review; this does not establish absence of a license.
- SW_SAS_PCFILES [unverified]: The AAER code imports Excel workbook ranges with DBMS=EXCELCS. SAS documentation says this engine needs a running PC Files Server; presence and configuration were not checked.

## Review notes

- The frozen title and DOI were retained from output_header. The assigned package has two document files and three programs but no empirical data file.
- The actual EMSI source content is mixed SAS and Stata; its extension and the datasheet's Stata label do not override the code content. Both stages and their handoff remain in scope.
- The Factiva instructions are documentation only. No Factiva search, company/person/entity query, contact, author-code execution, data import, model, or SAS process was used.
- Factiva, Compustat/CRSP/WRDS and EMSI catalog/page labels do not establish the user's present license status. The author agreement quote does not establish that the user lacks access.
- The HERI output path fragment is a SAS block comment, and the GDP keep-list token is treated as a possible unique Stata abbreviation for GDPg under the official Stata 18 rule; neither observation is presented as a runtime test.
- HERI disagg ordering, AAER output persistence/copy routing, and mixed-language Stata extraction/load are source-supported setup steps. Exact input fields, variant/history contracts and all supplied models remain in scope; no analysis or sample changes were proposed.
- The official public pages establish candidate products and stated access interfaces only; exact input fields, vintages, identifiers, local copies and histories remain unverified.
- The assigned SAS environment metadata is unverified and the SAS PC Files Server was not probed; neither is described as unlicensed or unavailable.
