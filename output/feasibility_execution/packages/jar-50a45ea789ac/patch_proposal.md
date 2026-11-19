# Patch proposal: jar-50a45ea789ac

Assessing the Social Impact of Corporations: Evidence from Management Control Interventions in the Supply Chain to Increase Worker Wages

DOI: 10.1111/1475-679X.12472

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied workflow: author-prepared H&M source-data construction, Stata wage panel and all supplied Stata analyses, then R figures and additional tables.

Entry points: `build_fairwage_panel.do`, `analyze_wages.do`, `wages_figures.R`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 3/12472 - Assessing-the-Social-Impact-of-Corporations-Evidence-from-Management-Control-Interventions-in-the-Supply-Chain/ds-datasheet-code-and-identifiers.zip",
      "sha256": "ab8e076f0e4a45a6563eb60cf72458cbe562ba368654a840ed7ce4566cc855c3"
    },
    {
      "path": "JAR-Volume 61/Issue 3/12472 - Assessing-the-Social-Impact-of-Corporations-Evidence-from-Management-Control-Interventions-in-the-Supply-Chain/ds-online-appendix2023.pdf",
      "sha256": "53b030ccea6cfb469158e9ab31bf354c607a851f137eb5fd4fc96b4c39518eaa"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "cdb779404ee10819761bcf3d683d9576f29859f067fd1d60ef74d1fa787a4341"
}
```

## Proposed actions

### ACT_HM_SOURCE_INPUTS: Establish compatible, authorized access to the exact author-prepared inputs and stage them in a separate portable project copy. Do not treat the identifier list or historical source-server provenance as the analysis panel or as a live-server requirement.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: DATA_COUNTRY_WAGES, DATA_ICOC_CSV, DATA_STEP_WAGES, DATA_CURRENCY_CONVERSION, DATA_PROGRAM_INPUTS, DATA_SRM_INPUTS, DATA_BUSINESS_INPUTS, DATA_OTHER_INPUTS, ISS_HM_INPUT_ROUTE
Evidence: E_README_BUILD, E_MASTER_COUNTRY_CALLS, E_ICOC_CSV, E_STEP_2017_INPUT, E_PROGRAM_SOURCE, E_SRM_MAPPING_INPUT, E_BUSINESS_INPUTS, E_OTHER_LOC_INPUT_OUTPUT, E_DS_RELEASE, E_IDENTIFIER_PROBE

Preparation / proposed procedure:

1. For each workbook/CSV family, confirm the user has an authorized current route; the datasheet and NDA do not answer current entitlement.
2. Map the exact supplied file names, sheets, fields, identifiers and coverage against every country constructor, ICOC loop, STEP builder and supporting-data builder.
3. In a separate portable copy with build/ beside data/, stage only the code-consumed author-prepared inputs at the relative paths used by the source.
4. Keep the 2020/2021 STEP Excel enrollment inputs distinct from the step2020.dta/step2021.dta handoff requirement.

Validation to perform later:

- Use bounded read-only metadata on the staged inputs to confirm workbook readability, exact sheets/columns, identifiers and expected source periods before any separately authorized code run.
- Confirm the author source-to-variable mapping for each workbook and retain access/provenance records without redistributing proprietary files.

### ACT_STEP_DTA_HANDOFF: Resolve the exact source or producer contract for step2020.dta and step2021.dta before running merge_icoc_step.do.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: DATA_STEP_2020_2021_DTA, ISS_STEP_HANDOFF
Evidence: E_HANDOFF_CONSUMER, E_SOURCE_STEP_DTA_SCAN, E_HANDOFF_EXCEL_DISTINCT, E_HANDOFF_2020_EXCEL

Preparation / proposed procedure:

1. Inspect already-authorized local handoff metadata and provided author documentation for whether both named .dta files are intended inputs and for their generating code/version or source.
2. Confirm country, spurid, year, base and total fields and the intended 2020/2021 row coverage; do not infer that the inputs are optional solely from the later year filter.
3. Keep the two Excel enrollment inputs separate unless a documented producer proves they create the exact .dta handoff.

Validation to perform later:

- After clarification, compare bounded metadata from both staged .dta files to the consumer field names and period, and verify a documented producer if one exists.
- If no source contract is supplied, keep this dependency unresolved and do not replace it with synthetic or inferred data.

### ACT_PUBLIC_DEFLATORS: Verify the official macro-data products against the Stata import schemas and required construction history, then stage compatible public files in the portable data tree.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: DATA_WB_EXCHANGE, DATA_IMF_INFLATION, DATA_FRED_GDPDEF, ISS_PUBLIC_DATA_COMPATIBILITY
Evidence: E_PUBLIC_WB_FX, E_PUBLIC_IMF_CPI, E_PUBLIC_FRED_GDPDEF, E_MERGE_STEP_READ, E_HANDOFF_CONSUMER

Preparation / proposed procedure:

1. For World Bank indicator PA.NUS.FCRF, confirm the actual CSV fields, nine-country coverage, and 2012–2019 values, including the code’s 2013/2014 calibration years.
2. For the IMF input, identify the exact annual price-index series and author-compatible country/year layout, including Estim semantics, reference years 2012 and 2019, and the code’s 2012–2021 construction filter.
3. For FRED GDPDEF, verify a CSV with date and gdpdef fields and quarterly history for 2012–2021; preserve the code’s annual averaging and 2019 normalization.
4. Stage confirmed files under the relative deflators/ paths in the separate copy; do not use a substitute series or silently change the author transformations.

Validation to perform later:

- Read-only metadata must confirm the exact imported file schema, required years and country identifiers; only after a separately authorized execution compare the generated deflators with the code’s documented base years.

### ACT_REORDER_STEP_PRODUCER: In the separate portable copy, call the supplied STEP builder before the ICOC builder because the latter reads the former’s step.dta output.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISS_STEP_ORDER
Evidence: E_PANEL_BUILD_ORDER, E_STEP_FINAL_OUTPUT, E_ICOC_STEP_READ, E_STEP_CWD, E_MASTER_CWD

**Proposed edit:** `build_fairwage_panel.do:9–10`
Source SHA-256: `5a7db8df1c738cbe37c843d37c1f323384cd5df5367703a11f489a646deae32a`

rebuild_step.do writes ../data/build_wage/step.dta from its own STEP workbooks and conversion workbook; rebuild_icoc.do reads that same relative path to construct China ratios. The driver currently calls the consumer first. The source comments require the build working directory, and the output/consumer relative paths match.

Current text:
```
do rebuild_icoc.do
do rebuild_step.do
```

Proposed replacement:
```
do rebuild_step.do
do rebuild_icoc.do
```

Preparation / proposed procedure:

1. Copy the author package into a separate portable project tree and apply the two-line reorder only there.
2. Keep rebuild_step.do inputs and the build/ working directory prerequisites in place; retain the downstream merge and all source stages.

Validation to perform later:

- Review the copied driver to confirm rebuild_step.do precedes rebuild_icoc.do and both continue to run before merge_icoc_step.do.
- After data/software prerequisites are separately satisfied, run the panel build from the documented build/ working directory and confirm that the expected step.dta is created before ICOC uses it.

### ACT_STATA_ADDONS: Make the six invoked Stata add-ons available in the user’s Stata 18 environment before the complete analysis chain.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: STATA_OUTREG2, STATA_WINSOR2, STATA_MAT2TXT, STATA_TWOWAYFEWEIGHTS, STATA_DID_MULTIPLEGT, STATA_STACKEDEV, ISS_STATA_ADDONS
Evidence: E_ENVIRONMENT, E_SW_OUTREG2, E_SW_WINSOR2, E_SW_MAT2TXT, E_SW_TWOWAYFEWEIGHTS, E_SW_DID_MULTIPLEGT, E_SW_STACKEDEV

Preparation / proposed procedure:

1. Resolve compatible sources and versions for outreg2, winsor2, mat2txt, twowayfeweights, did_multiplegt and stackedev; verify user adopath configuration without changing author code.
2. Set up only the packages needed for this workflow in the user’s Stata environment; installation was not performed during this assessment.

Validation to perform later:

- Before any author-code run, use Stata metadata-only which checks to confirm all six command entry points resolve on the selected user adopath.

### ACT_R_PACKAGES: Prepare the R packages used by wages_figures.R in the user’s R 4.5.0 library.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: R_TIDYVERSE, R_PANELVIEW, R_TJBAL, R_PANELMATCH, R_DID, R_HAVEN, R_GGPLOT2, R_DPLYR, R_READR, R_SCALES, ISS_R_PACKAGES
Evidence: E_R_PACKAGE_METADATA, E_R_INPUT_PACKAGES, E_ENVIRONMENT

Preparation / proposed procedure:

1. Resolve suitable versions and user-library access for tidyverse, panelView, tjbal, PanelMatch, did, haven and scales; also confirm their ggplot2, dplyr and readr dependencies.
2. Do not load or install packages as part of this assessment.

Validation to perform later:

- Use installed.packages metadata in the selected R library to confirm the required packages and dependencies before a future separately authorized figures run.

### ACT_FUTURE_RUN_SEQUENCE: Future complete run sequence after the documented data handoffs, software and source-order preparation are resolved.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: E_README_BUILD, E_README_ANALYSIS, E_PANEL_BUILD_ORDER, E_ANALYSIS_COMPANIONS, E_R_INPUT_PACKAGES, E_EVENT_STUDY_TAB_OUTPUTS, E_STACKED_TAB_OUTPUT

Preparation / proposed procedure:

1. In a separate portable copy, create the expected build/tables and build/figures directories and start Stata in build/.
2. After staging compatible inputs and applying the proposed producer-order change, run do build_fairwage_panel.do, then do analyze_wages.do.
3. Run wages_figures.R with its working directory set to the location of analyze_wages.do, after the Stata tables and estimation-sample dataset exist.

Validation to perform later:

- Confirm the builder creates ../data/fairwage_panel.dta, the analysis creates ../data/fairwage_panel_estsample.dta and all five R-facing wage event-study tab files, and the R step writes its documented figures/additional table.
- Compare output paths, sample years, focal countries and expected table names with the source; any output difference remains a future execution finding, not an assessment assumption.


## Remaining issues and prerequisites

- ISS_HM_INPUT_ROUTE [unresolved; full_pipeline]: All named author-prepared H&M source families remain unverified for current user-side access, exact fields, identifiers, sheets and full construction history. NDA/nonsharing statements and catalog misses do not establish an access barrier.
- ISS_STEP_ORDER [preparation; full_pipeline]: The current driver invokes rebuild_icoc.do before rebuild_step.do even though rebuild_icoc.do reads step.dta and rebuild_step.do creates that exact path. Statically verified inputs and working-directory conventions support swapping those two calls in a separate working copy.
- ISS_STEP_HANDOFF [unresolved; full_pipeline]: The supplied merge requires step2020.dta and step2021.dta, but the complete supplied code-source set contains no producer for these exact outputs. The similarly named Excel workbooks are used by program_enrollment.do, not produced as these .dta files; intended access and source/schema/history need clarification.
- ISS_PUBLIC_DATA_COMPATIBILITY [unresolved; full_pipeline]: Official pages identify candidate World Bank exchange-rate, IMF CPI and FRED GDPDEF products, but exact fields, country/year coverage, series construction, revisions and in-code file formats remain unverified.
- ISS_STATA_ADDONS [preparation; full_pipeline]: Six invoked Stata commands were not found by successful metadata checks on the checked paths; add-on availability/version and user adopath setup remain preparation items.
- ISS_R_PACKAGES [preparation; full_pipeline]: The successful R metadata query did not find the ten named packages in active library paths. User-side package setup and version checks remain necessary.
- DATA_COUNTRY_WAGES [undetermined]: Author-prepared country wage workbooks read by the nine country constructors: Bangladesh, Cambodia, China, India, Indonesia, Myanmar, Pakistan, Turkey and Vietnam; year sheets 2013–2019. Constructors require country-specific factory IDs, year, currency and wage/worker/business fields, with header mappings defined per source. Legacy source filenames in comments are provenance only; these active paths consume the listed cleaned workbooks.
- DATA_ICOC_CSV [undetermined]: Year-specific ICOC_Wage_YYYY.csv inputs for 2012–2015, consumed by rebuild_icoc.do to construct ICOC factory-year wages and compare them with annualwage.dta. Required identifiers, wage fields, coverage and author-specific CSV construction history are not present in the release.
- DATA_STEP_WAGES [undetermined]: STEP wage workbooks read by rebuild_step.do: all-country 2017, one country-specific file for each of nine countries in 2018, all-country 2019 and the separate Indonesia 2019 file. The code uses monthly and annual wage/worker data, factory identifiers, country labels and country-specific net/gross adjustments.
- DATA_CURRENCY_CONVERSION [undetermined]: Author-prepared currency conversion.xlsx input, read by STEP construction and merge_icoc_step.do. It is joined on country/year and used to convert local-currency wage values; the workbook fields, rate units and required country-year completeness have not been probed.
- DATA_PROGRAM_INPUTS [undetermined]: Program enrolment WPD and WMS .xlsx master list plus the separate step_all_countries_wage_2020.xlsx and _2021.xlsx sheets used to refresh enrollment fields. Code uses SPURID, enrollment identifiers/years, and updates for 2020–2021; these Excel files are distinct from the missing step2020.dta/step2021.dta handoff.
- DATA_SRM_INPUTS [undetermined]: Supplier-to-PU mapping workbook SPUR supplier code to PU_202005140635.xlsx; srm_database.xlsx year sheets 2013–2019; and srm_scbrand.xlsx year sheets 2013–2019. The supplied builder uses suppliercode, SPURIDs, years, quantity/performance and supplier-brand fields to construct the matching SRM outputs.
- DATA_BUSINESS_INPUTS [undetermined]: business.xlsx (China sheet used for the shared 2013–2018 pieces series) and 2019_PurchaseVolumePU.xlsx (2019 sheet) supply placed-pieces measures joined to the generated annualwage.dta by factory/year.
- DATA_OTHER_INPUTS [undetermined]: Other construction inputs: Letter of concern list (Feb 2020).xlsx, STEP2019_absenteeism.xlsx, PlanPlaced.xlsx (seasonal data through 202001) and Consolidated Trade Union data_20200729.xlsx (2017–2019 sheets). Each is used to build compliance, absenteeism, plan/placed and union indicators joined into the final panel.
- DATA_STEP_2020_2021_DTA [undetermined]: merge_icoc_step.do explicitly appends ../data/build_wage/step2020.dta and step2021.dta before diagnostics and a year>=2020 drop. No supplied source creates these exact .dta names. The consumer expects country, spurid, year, base and total; source, production code, version/history and intended presence are unresolved. Keep separate from the 2020/2021 Excel enrollment inputs.
- DATA_WB_EXCHANGE [undetermined]: merge_icoc_step.do reads WB_Exchange_to_USD.csv as a wide annual exchange-rate file, renames CountryName, IndicatorName and IndicatorCode, reshapes year columns and uses country/year rates. Required focal-country wage history is 2012–2019, with 2013/2014 calibration against H&M rates.
- DATA_IMF_INFLATION [undetermined]: merge_icoc_step.do reads IMF_Inflation_Index_Wide.xlsx, reshapes year columns, uses country names, an Estim flag and index levels; code filters 2012–2021 and normalizes to 2012/2019, while the final wage panel retains 2012–2019. Exact IMF product/series, observed-versus-estimated history, fields and mapping are unresolved.
- DATA_FRED_GDPDEF [undetermined]: merge_icoc_step.do reads StLouisFed_GDPDEF.csv with date and gdpdef fields, averages quarterly values by year for 2012–2021 and rescales USD wages to 2019 dollars. The final wage sample retains 2012–2019; compatible CSV headers, required history and vintage are not verified.
- STATA_OUTREG2 [preparation_required]: outreg2 is invoked by supplied author code but was not found by its successful Stata metadata query on the checked paths; this does not establish global absence or licensing.
- STATA_WINSOR2 [preparation_required]: winsor2 is invoked by supplied author code but was not found by its successful Stata metadata query on the checked paths; this does not establish global absence or licensing.
- STATA_MAT2TXT [preparation_required]: mat2txt is invoked by supplied author code but was not found by its successful Stata metadata query on the checked paths; this does not establish global absence or licensing.
- STATA_TWOWAYFEWEIGHTS [preparation_required]: twowayfeweights is invoked by supplied author code but was not found by its successful Stata metadata query on the checked paths; this does not establish global absence or licensing.
- STATA_DID_MULTIPLEGT [preparation_required]: did_multiplegt is invoked by supplied author code but was not found by its successful Stata metadata query on the checked paths; this does not establish global absence or licensing.
- STATA_STACKEDEV [preparation_required]: stackedev is invoked by supplied author code but was not found by its successful Stata metadata query on the checked paths; this does not establish global absence or licensing.
- R_TIDYVERSE [preparation_required]: tidyverse was not found in installed.packages metadata across the active R library paths; this does not establish absence outside those paths.
- R_PANELVIEW [preparation_required]: panelView was not found in installed.packages metadata across the active R library paths; this does not establish absence outside those paths.
- R_TJBAL [preparation_required]: tjbal was not found in installed.packages metadata across the active R library paths; this does not establish absence outside those paths.
- R_PANELMATCH [preparation_required]: PanelMatch was not found in installed.packages metadata across the active R library paths; this does not establish absence outside those paths.
- R_DID [preparation_required]: did was not found in installed.packages metadata across the active R library paths; this does not establish absence outside those paths.
- R_HAVEN [preparation_required]: haven was not found in installed.packages metadata across the active R library paths; this does not establish absence outside those paths.
- R_GGPLOT2 [preparation_required]: ggplot2 was not found in installed.packages metadata across the active R library paths; this does not establish absence outside those paths.
- R_DPLYR [preparation_required]: dplyr was not found in installed.packages metadata across the active R library paths; this does not establish absence outside those paths.
- R_READR [preparation_required]: readr was not found in installed.packages metadata across the active R library paths; this does not establish absence outside those paths.
- R_SCALES [preparation_required]: scales was not found in installed.packages metadata across the active R library paths; this does not establish absence outside those paths.

## Review notes

- This assessment follows the single assigned JAR archive variant and traces all 86 native dependency IDs across the country constructors, wage builders, supporting-data builders, final panel, four Stata companions, and the R figures/additional-tables script.
- The prepared README/datasheet discovery is the coordinator-approved cached artifact; identifiers.dta is a readable spurid list, not a prepared analysis panel. No analysis-only route is supported by supplied compatible data.
- H&M proprietary/NDA documentation, catalog results and generic wage/supplier candidates do not establish current user access, licensing absence, or compatible fields. Current route and required schema/history remain unresolved where stated.
- The 2020/2021 Excel enrollment refresh inputs are distinct from merge_icoc_step.do’s step2020.dta/step2021.dta handoff. The latter have no producer in the supplied source set; later year filtering is not used as a bypass rationale.
- The driver order issue is supported by a static producer/consumer path match: rebuild_step.do reads its named workbooks and writes ../data/build_wage/step.dta; rebuild_icoc.do reads that same path for China ratios; the build working-directory comments are consistent. The two-line reorder is proposed only for a separate portable copy.
- Software checks were metadata-only. R and Stata runtimes are present; explicit invoked add-ons and R packages are listed with current setup needs. No author code, author data, statistical analysis, SAS startup, package install, data download, source edit, or synthetic substitute was executed or applied.
- A first unexecuted reader-script draft was overwritten before it was archived; it did not run or contribute evidence. The subsequent redacted source-reader, its actual output and all later command requests/results are preserved. Malformed helper requests and the earlier unsuccessful R package query are preserved but not cited.
- A read-only metadata inspection attempt initially invoked `python` (not installed on PATH) and returned `[redacted-path-96a6928f42ba]`; the wrapper exposed only combined output, so it did not retain separate stdout/stderr or a return-code field. The inspection was rerun with `python3` and succeeded. The failed attempt supplied no evidence.
- A helper-generation patch failed verification because a hunk was malformed and wrote no file. The diagnostic was captured; the exact patch body was not stored locally. This process-only attempt did not change the assessment or author artifacts.
