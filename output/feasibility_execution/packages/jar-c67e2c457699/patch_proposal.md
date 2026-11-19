# Patch proposal: jar-c67e2c457699

Informed Trade of Earnings Announcements

DOI: 10.1111/1475-679X.70032

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Provisional review of the complete author-documented replication workflow; entry-point and dependency closure review is in progress.

Entry points: `Submission Code/Code/overall_metafile.do`, `Submission Code/Code/Appendix/MM_Estimation.m`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 4/70032 - Informed-Trade-of-Earnings-Announcements/xie-datasheet-code-identifier-and-log-files.zip",
      "sha256": "a6764e027653bb7a50c7d220246fd2361271b12cdd53943c57c44bd89f5df576"
    },
    {
      "path": "JAR-Volume 64/Issue 4/70032 - Informed-Trade-of-Earnings-Announcements/xie-online-appendix.pdf",
      "sha256": "5b937593b6260f15eba0b19ace94c5f85b7580f7e040a68b2f22a52c2024e4f9"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "941c035d127c6d8e917d89c07f39171a2417825bba74ed8c9cdce33c2826edf6",
  "work_item_sha256": "cf28bcf9e00905f35dbe8047e058443553ea69502d237f91eb92bef943106562"
}
```

## Proposed actions

### A_COMP_FUNDQ_STAGE: Stage the verified local quarterly Compustat component in a portable work copy as the author-named Compustat Data.dta input, preserving the observed native fields, GVKEY/RDQ join keys, and the documented 2010–2015 role.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_COMP_FUNDQ
Evidence: E_COMP_FUNDQ_PROBE, E_COMP_QUARTER_READ, E_COMP_README

Preparation / proposed procedure:

1. Use the catalog-listed COMP.FUNDQ product as the raw source and retain only the exact fields consumed by the supplied merge code.
2. Write the prepared DTA under the working copy's expected raw-data location without changing author definitions or source filters.

Validation to perform later:

- Confirm the staged DTA schema includes GVKEY, RDQ, and all listed quarterly fields.
- Check that the 2010–2015 target period and date-key join are present in the prepared copy; the bounded source probe does not establish those row-level counts.

### A_COMPANY_SIC_STAGE: Prepare the exact GVKEY/SIC company mapping expected by the merged-master stage from the verified local COMP.COMPANY component.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_COMPANY_SIC
Evidence: E_COMPANY_SIC_PROBE, E_GVKEY_SIC_INPUT

Preparation / proposed procedure:

1. Use the current COMP.COMPANY GVKEY/SIC fields to stage the gvkey_sic.dta interface in a portable working copy.
2. Keep source/version details with the staged mapping for later value-fidelity checks.

Validation to perform later:

- Confirm native GVKEY and SIC fields, key uniqueness/coverage for the master observations, and unchanged SIC-to-FF classification behavior.

### A_MACRO_DATE_WORKBOOKS: Retain both packaged macro-release date workbooks and verify the authored Release Dates sheet/A37 import contract in a later authorized preparation pass.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_MACRO_46, R_MACRO_50
Evidence: E_MACRO_DATES_READ, E_WORK_ITEM_INVENTORY

Preparation / proposed procedure:

1. Use both workbooks in a portable copy, preserving the existing 46/50 loop and append sequence.
2. Confirm that the imported column A contains the intended release-date values before merging it as rdq.

Validation to perform later:

- Verify both files are readable by the prescribed Stata import step and that the combined dates match the intended Macro_Date definition.

### A_TIC_MAP_CLARIFY: Obtain the exact producer or source mapping for Tic_Gvkey_Cusip and Tic_Gvkey_Cusip_Extened, including ticker, GVKEY, CUSIP, effective-date/selection logic, and the distinction between the two output names.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_TIC_GVKEY_CUSIP, I_TIC_MAP
Evidence: E_TIC_MAP_CRSP, E_TIC_MAP_IBES, E_TIC_MAP_EXTENDED, E_IDENTIFIERS_PROBE

Preparation / proposed procedure:

1. Use the packaged identifiers.dta only as a partial candidate for GVKEY/symbol; do not treat it as the complete CUSIP map.
2. Request the missing producer/input specification or the prepared mapping files and preserve the author's two separate logical names until the mapping is established.

Validation to perform later:

- Confirm every downstream join key maps to the same current ticker/GVKEY/CUSIP definitions and document the extended-map relationship.

### A_COMP_IDS_CLARIFY: Obtain the producer and required date/SIC selection for Compustat IDs.dta; do not assume a same-named field in the quarterly fundamentals file completes that mapping.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COMP_IDS, I_COMP_IDS
Evidence: E_COMP_IDS_INPUT, E_COMP_FUNDQ_PROBE

Preparation / proposed procedure:

1. Request the exact Compustat ID file or the documented source/selection steps for its GVKEY/RDQ/SIC fields.
2. If the intended source is COMP.FUNDQ, map the quarter and SIC fields explicitly before staging the author-named input.

Validation to perform later:

- Confirm the resulting join preserves the authored GVKEY/RDQ keys and SIC values used for FF10 earnings-cycle timing.

### A_GRSTYLE_SETUP: Install or expose the missing grstyle command in the Stata 18 working environment before the top-level driver starts.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_GRSTYLE
Evidence: E_SOFTWARE_GRSTYLE, E_GRSTYLE_USED

Preparation / proposed procedure:

1. Configure grstyle on the Stata 18 user adopath in the portable execution environment.

Validation to perform later:

- Confirm a read-only `which grstyle` check succeeds before invoking the driver.

### A_OUTREG2_SETUP: Install or expose the required outreg2 command in the Stata 18 working environment for the supplied regression table exports.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_OUTREG2
Evidence: E_ENV_ORIGINAL, E_OUTREG2_USED

Preparation / proposed procedure:

1. Configure outreg2 on the Stata 18 user adopath in the portable execution environment.

Validation to perform later:

- Confirm a read-only `which outreg2` check succeeds before running table-producing scripts.

### A_MATLAB_SETUP: Confirm an authorized MATLAB release, required numeric routines/toolboxes, working directory, and function/file-name resolution for the manual appendix while preserving the supplied model body.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: SW_MATLAB, I_MATLAB_HELPER_NAME
Evidence: E_DRIVER_MODEL, E_STRUCTURAL_MATLAB_INPUT, E_STRUCTURAL_CALL, E_STRUCTURAL_HELPER_NAME

Preparation / proposed procedure:

1. Identify the MATLAB release and check availability of the source-required routines, including readmatrix, fminsearch, normrnd, and unidrnd, plus any associated toolboxes.
2. Set the working directory to the generated MatlabData_Model.xlsx location and confirm MM_Fit resolves consistently to the supplied MM_Fit.m file, whose primary declaration is MM_Fit_V4.

Validation to perform later:

- Confirm the required MATLAB routines and toolboxes are available in the intended environment.
- Confirm the generated model workbook has the five source-defined inputs expected by MM_Estimation.m.
- Confirm function/file-name resolution from the intended working copy without changing the supplied model body or claiming runtime success.

### A_SOURCE_CLOSURE: Close the full-pipeline raw-source inventory by obtaining the exact author-prepared files or compatible source/product mapping for each unverified family, retaining separate field, period, identifier, and producer contracts.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_RAW_SOURCE_CLOSURE, R_FOIA_TRADES, R_CONTROL_CASES, R_CONTROL_FOIA, R_HORIZONS, R_CRSP_SERIES, R_IBES, R_GUIDANCE, R_RAVENPACK_FEED, R_RAVENPACK_CUSIP
Evidence: E_DRIVER_PREPROCESS, E_FOIA_INPUT, E_CONTROL_CASE_INPUT, E_HORIZONS_INPUT, E_CRSP_INPUTS, E_IBES_INPUT, E_GUIDANCE_INPUT, E_TAQ_RETURNS_LOOP, E_RAVENPACK_PERIOD

Preparation / proposed procedure:

1. For each addressed requirement, supply the named source or compatible product and the source-to-prepared-file transformation used by the author.
2. Keep independent vendor/source families and identifier maps distinct; preserve driver order and stage files only in a portable working copy.

Validation to perform later:

- Confirm consumed paths, native fields, date/key roles, required history, and producer position in the selected workflow before execution.

### A_SAMPLE_EA_EXTENDED_CONTRACT: Obtain the exact producer or author-prepared Sample_EA_Extended file and its ticker/date population, field, and relationship contract with the separate extended identifier map.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SAMPLE_EA_EXTENDED, I_SAMPLE_EA_EXTENDED
Evidence: E_TIC_MAP_EXTENDED, E_DRIVER_PREPROCESS, E_WORK_ITEM_INVENTORY

Preparation / proposed procedure:

1. Request the prepared panel or producing stage and its documented fields/date coverage.
2. Keep Sample_EA_Extended and Tic_Gvkey_Cusip_Extened separate until their join and population contract is established.

Validation to perform later:

- Confirm consumed fields and the author's event-date sample definition.
- Confirm the extended map's ticker/CUSIP relationship without substituting the separate Tic_Gvkey_Cusip map.

### A_RAVENPACK_PRESS_RELEASES: Identify the exact Press_Releases input, its timestamp/entity fields, period, and preparation contract for RavenPack processing.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_RAVENPACK_PRESS_RELEASES
Evidence: E_RAVENPACK_PRESS_READ, E_RAVENPACK_RAW, E_CATALOG_RAVENPACK

Preparation / proposed procedure:

1. Request the author-prepared Press_Releases file or producer and its documented fields and date coverage.
2. Keep it distinct from the monthly Equities CSV feed and the company-to-CUSIP map.

Validation to perform later:

- Confirm the input supports the timestamp and entity fields consumed by the source code.

### A_TAQ_PERIOD_CONTRACT: Resolve the TAQ year and field contract between the README and active source loops before identifying a compatible product.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_TAQ, I_TAQ_PERIOD_MISMATCH
Evidence: E_TAQ_README, E_TAQ_RETURNS_LOOP, E_TAQ_VOLUME_LOOP

Preparation / proposed procedure:

1. Obtain the intended TAQ source products, annual range, and prepared-file interface for both active loops.
2. Preserve the code's 2006–2016 return and 2009–2016 volume ranges unless author documentation establishes otherwise.

Validation to perform later:

- Confirm the product fields and annual coverage satisfy both source loops before execution.

### A_DRIVER_PATH_ALIGNMENT: Set the code-root macro and working copy to the supplied package tree, then confirm each include resolves to its exact registered source path; adjust spelling only if the target environment requires it.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_DRIVER_PATH_ALIGNMENT
Evidence: E_DRIVER_PREPROCESS, E_DRIVER_PROCESS, E_DRIVER_ANALYSIS_APPENDIX, E_WORK_ITEM_INVENTORY

Preparation / proposed procedure:

1. Configure the code-root macro to the registered Code directory while preserving the author stage order.
2. Check PreProcessing/Processing include names against the frozen paths in the intended working copy; keep Analysis calls and the manual MATLAB step distinct.

Validation to perform later:

- Confirm all 20 driver include edges resolve to their registered source files without changing workflow order.


## Remaining issues and prerequisites

- I_TIC_MAP [unresolved; full_pipeline]: The active workflow consumes Tic_Gvkey_Cusip in CRSP and IBES preparation and a separate Tic_Gvkey_Cusip_Extened mapping in EA sampling, but no registered driver stage writes either mapping. The packaged identifiers file only proves GVKEY and symbol, not the required CUSIP/ticker mapping or the extended-map construction.
- I_COMP_IDS [unresolved; full_pipeline]: Earnings Cycle.do consumes Compustat IDs.dta on GVKEY and RDQ and uses SIC, but the registered driver has no producer for that file or proof of its date/SIC selection. COMP.FUNDQ is a local candidate with GVKEY/RDQ fields, but this assignment's bounded probe did not establish the SIC mapping or the author-named product construction.
- I_RAW_SOURCE_CLOSURE [unresolved; full_pipeline]: The complete author driver requires several unprovided raw families and prepared panels (FOIA/control, Horizons, CRSP-linked data, IBES/guidance, TAQ, and RavenPack feed/mapping). Their named products, period or transformations remain unverified as recorded in the separate requirements; code source and catalog discovery do not establish a compatible local/public route.
- I_SAMPLE_EA_EXTENDED [unresolved; full_pipeline]: Sample EA Final consumes Sample_EA_Extended before joining Tic_Gvkey_Cusip_Extened, but the producer and exact population/date/field contract are not established by the recorded selected workflow or a verified package route. Treat this as a specific unverified input contract; absence from one inventory or call list is not proof that no producer exists elsewhere.
- I_TAQ_PERIOD_MISMATCH [unresolved; full_pipeline]: The TAQ README describes 2010–2015 material, while active return and volume loops request annual files from 2006–2016 and 2009–2016 respectively. A compatible route with the full code-required years and fields has not been verified.
- I_DRIVER_PATH_ALIGNMENT [preparation; full_pipeline]: The driver spells the registered PreProcessing and Processing folder segments as lowercase preprocessing/processing; the frozen registered source paths use PreProcessing/Processing. Analysis matches. Preserve the selected order and check code-root/include resolution in the intended working copy; no runtime resolution test or platform assumption is made.
- I_MATLAB_HELPER_NAME [preparation; full_pipeline]: The sole supplied helper file is MM_Fit.m and its primary declaration is MM_Fit_V4, while the manual appendix calls MM_Fit with matching six arguments and compatible output use. The source signatures align; the remaining item is ordinary function/file-name resolution in an authorized MATLAB environment. Runtime and search-path resolution remain unverified.
- R_MACRO_46 [undetermined]: The release_dates_46.xls list is imported from the Release Dates sheet at A37 and appended to the macro-release date list.
- R_MACRO_50 [undetermined]: The release_dates_50.xls list is imported from the Release Dates sheet at A37 and appended to the macro-release date list.
- R_FOIA_TRADES [undetermined]: Case-specific FOIA insider-trade workbook used to create the insider-trade sample and event calendar; the source code filters by earnings news type, a three-day trade flag, dates, ticker, trade/upload timing, and trade values.
- R_CONTROL_CASES [undetermined]: The MW, PR, and BW case-control announcement workbooks jointly used to build the newswire-stock control sample.
- R_CONTROL_FOIA [undetermined]: The MW, PR, and BW FOIA-control announcement workbooks plus the initial MW FOIA raw workbook used to build the control newswire-stock sample.
- R_HORIZONS [undetermined]: Annual Horizons workbooks H2006.xlsx through H2016.xlsx used to construct the announcement-date, ticker, company, fiscal-quarter, and fiscal-year panel.
- R_CRSP_SERIES [undetermined]: The two author-named CRSP data partitions used to create the CRSP_Sample and price/link inputs.
- R_TIC_GVKEY_CUSIP [undetermined]: Ticker–GVKEY–CUSIP maps consumed by the CRSP/IBES preparation and by the EA sample builder, including the separate extended-map file name.
- R_IBES [undetermined]: Author-prepared IBES.dta with quarterly EPS and revenue forecasts/actuals, fiscal-period dates, analyst and CUSIP mapping, and the historical fields consumed by the supplied preparation.
- R_GUIDANCE [undetermined]: Author-prepared Guidance Raw.dta used for quarterly EPS and sales guidance values, range/action/code fields, announcement dates, and mean-at-date comparisons.
- R_TAQ [undetermined]: Annual TAQ intraday files used for event-time returns, spread/volume measures, and pre/post-announcement calculations.
- R_RAVENPACK_FEED [undetermined]: Monthly RavenPack Equity 4.0 news files for 2010–2015, filtered to press releases and aggregated by CUSIP/date.
- R_RAVENPACK_CUSIP [undetermined]: Dated RavenPack company-to-CUSIP mapping CSV used to link news entities to security identifiers.
- R_COMP_IDS [undetermined]: A separate Compustat IDs.dta join input keyed by GVKEY and RDQ and used to supply SIC for the earnings-cycle timing variables.
- R_SAMPLE_EA_EXTENDED [undetermined]: Sample EA Final consumes Sample_EA_Extended and joins it by ticker to Tic_Gvkey_Cusip_Extened. The recorded workflow establishes the use site but not the panel producer, population, date coverage, or full field contract; the ticker join alone does not establish a compatible prepared panel.
- R_RAVENPACK_PRESS_RELEASES [undetermined]: RavenPack formatting separately consumes Press_Releases and drops rows without timestamp. Its construction, period, fields, and compatible route are unverified.
- SW_GRSTYLE [preparation_required]: The exact `grstyle` command is required at the start of the driver but is not found by the bounded Stata 18 metadata check.
- SW_OUTREG2 [preparation_required]: The supplied analyses invoke outreg2; the original typed environment probe reports the exact `outreg2` key unavailable.
- SW_MATLAB [unverified]: MATLAB is required by the separate manual structural-model step. The recorded environment metadata does not establish an authorized MATLAB runtime; the required routines/toolboxes and working-directory/function-search resolution remain unverified.

## Review notes

- The 60 checklist dependency IDs now have explicit review coverage. Data requirements, generated intermediates, the unverified Sample_EA_Extended contract, and the driver's include/path-alignment preparation item are linked to source evidence; generated products are tied to actual writers and consumers.
- Full workflow order is preserved: FOIA/control, Horizons/CRSP/sample/IBES preparation; returns/ERC/volume/guidance/earnings-cycle/RavenPack; master merge/date flags; five analysis scripts; and separate structural-model preparation followed by manual MATLAB.
- Unverified requirements remain distinct: FOIA/control, Horizons, CRSP, IBES/guidance, TAQ with a README/code period gap, RavenPack feed/map/Press_Releases, macro workbooks, ticker/GVKEY/CUSIP maps, Compustat IDs, and Sample_EA_Extended and the manual MATLAB runtime, toolbox, working-directory, and function/file-name resolution checks. Positive COMP.FUNDQ, COMP.COMPANY, and FOMC component evidence is preserved without generalizing coverage.
- No author program, statistical model, SAS executable, or data payload was run. Reading/capture/mask/method history is excluded from scientific evidence identifiers. Computed requirement and scope outcome fields remain omitted for the finalizer.
