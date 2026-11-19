# Patch proposal: jar-e586e3777838

The Financially Material Effects of Mandatory Non-Financial Disclosure

DOI: 10.1111/1475-679X.12499

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied author workflow: Stata source preparation and firm-year panel construction, S34 institutional-ownership preparation, supplied Table 1–2/Tables 8–10 programs, the Figure 3a panel builder, the three distinct R synthetic-control alternatives, and the Figure 3 graph consumer.

Entry points: `0-master_file.do`, `a-F3b-synth_controls_partial.R`, `a-F3b-synth_controls_pooled.R`, `a-F3b-synth_controls_seperate.R`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 5/12499 - The-Financially-Material-Effects-of-Mandatory-Non-Financial-Disclosure/gibbons-datasheet-code-and-identifiers.zip",
      "sha256": "8ba71ab7283734417ec50243d9bc0634c2389ee206d4365266a153dea77620a6"
    },
    {
      "path": "JAR-Volume 62/Issue 5/12499 - The-Financially-Material-Effects-of-Mandatory-Non-Financial-Disclosure/gibbons-online-appendix.pdf",
      "sha256": "edeb608d045e4ee99135c517fad3f5515a757a7056785380f05fa6a4e72dbe67"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "0d819d257a3fa8d86286857b8afac7e2d82f7e94c74f6a1051766a9936e7418c"
}
```

## Proposed actions

### A_PUBLIC_INPUTS: Obtain the author-compatible public country and patent data snapshots in a future data-preparation step, then align their exact series, version, identifiers and coverage to the supplied code.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_WDI, R_WGI, R_DPI, R_GCPD_FILINGS, R_GCPD_CITATIONS
Evidence: E_WDI_PUBLIC, E_WGI_PUBLIC, E_DPI_PUBLIC, E_GCPD_PUBLIC

Preparation / proposed procedure:

1. Confirm the author-required series, vintage and country or patent identifiers for each product.
2. Use the official public product route to obtain only the needed snapshot when authorized.
3. Compare the downloaded columns, years and identifiers with the source code before merging.

Validation to perform later:

- Verify all required series and fields against the supplied code.
- Verify the period and country/patent identifiers before joining to the author panel.

### A_VENDOR_INPUTS: For requirements whose inputs remain unresolved, obtain the author’s field definitions, join keys, units, sample periods and any still-missing extracts. Use the locally readable Worldscope and Compustat Global fields where their mapping and coverage meet the contract; obtain a compatible input for fields or history not available locally.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: I_INPUT_CLOSURE, R_WORLDSCOPE_ANNUAL, R_WORLDSCOPE_COMPANY, R_WORLDSCOPE_MONTHLY, R_BLOOMBERG, R_FACTSET_INDUSTRY, R_FACTSET_OWNERSHIP, R_FACTSET_LOCATIONS, R_COMPUSTAT_ACCOUNTING, R_COMPUSTAT_GLOBAL_KEYS, R_COMPUSTAT_NA_KEYS, R_S34_HOLDINGS
Evidence: E_CAT_WORLDSCOPE, E_CAT_COMPUSTAT, E_CAT_S34, E_FACTSET_WRDS, E_LSEG_WRDS, E_COMPUSTAT_WRDS, E_LOCAL_COMMON_PROBES

Preparation / proposed procedure:

1. Reconcile each addressed input to the exact source fields, identifiers, units and periods required by the supplied program; retain unknown joins or mappings where the source does not specify them.
2. Use the readable local Worldscope and Compustat Global fields where they satisfy the relevant input contract; obtain compatible data only for unresolved or absent fields and history.
3. Preserve separate Worldscope annual, descriptor and monthly inputs; separate Compustat accounting and identifier inputs; and separate ownership, industry and location inputs.

Validation to perform later:

- Compare exact field definitions, identifier joins, units and sample windows with the supplied source-program evidence.
- Record which fields were read successfully and which joins and periods remain unverified; one-row reads do not establish coverage.

### A_TREATMENT_KEY: Request the treatment key and its exact company identifiers, event-year coding and coverage specification.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_TREATMENT_KEY
Evidence: E_FACTSET_STAGE, E_ITEM_INVENTORY

Preparation / proposed procedure:

1. Obtain the author-named treatment spreadsheet or its documented producer.
2. Confirm identifier, treatment date and cohort definitions before merging.

Validation to perform later:

- Check that all code-required identifiers and treatment years are present and unique as expected.

### A_COUNTRY_CROSSWALK: Obtain the author-prepared country-name crosswalk or its complete matching instructions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COUNTRY_CROSSWALK, I_COUNTRY_CROSSWALK
Evidence: E_COUNTRY_STAGE, E_ITEM_INVENTORY

Preparation / proposed procedure:

1. Request the source-to-Worldscope mapping used for WDI, WGI and DPI merges.
2. Retain unresolved or many-to-one country matches for author confirmation.

Validation to perform later:

- Check country and year uniqueness and verify each indicator merge against the author field names.

### A_PRI_CROSSWALK: Obtain the author signatory source and completed manager-name matching file used to create PRI flags for S34 holdings.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_PRI_SIGNATORY_DATA, R_PRI_MANAGER_MAP, I_PRI_MANAGER_CROSSWALK
Evidence: E_PRI_PUBLIC, E_PRI_MAP, E_S34_STAGE

Preparation / proposed procedure:

1. Confirm the required signatory years and source vintage.
2. Obtain the author signatory data through an applicable public or academic route.
3. Request the completed manager-to-organization matching decisions and input schema.

Validation to perform later:

- Check that every S34 manager identifier maps to a documented organization and signatory year.

### A_ESG_PANEL: Obtain the author-prepared ESG synthetic-control panel or its documented producer, including fields, identifiers and history.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_AUGSYNTH_ESG, I_ESG_PANEL_PRODUCER
Evidence: E_F3A_PANEL_OUTPUT, E_ESG_PANEL_READ, E_ESG_FIELD

Preparation / proposed procedure:

1. Request the exact panel or complete producer instructions.
2. Confirm how its ESG score and treatment/event fields are constructed and whether it depends on a shared R session.

Validation to perform later:

- Compare the available panel fields and cohort/year coverage with the R branch requirements.

### A_FIGURE3_BRIDGE: Obtain the Figure 3 result workbook or the complete author recipe mapping each R alternative and outcome to the graph input columns.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_FIGURE3_BRIDGE, I_FIGURE3_HANDOFF
Evidence: E_F3C_BRIDGE, E_F3C_FIELDS

Preparation / proposed procedure:

1. Request the missing workbook or a complete aggregation specification.
2. Confirm row keys for event time, model variant and outcome, plus estimate and confidence-interval columns.

Validation to perform later:

- Check that each graph row maps to one intended R model and outcome without omitting a supplied alternative.

### A_PORTABLE_COPY: Prepare a portable working copy with a consistent root and repaired local include references while preserving all author transformations and sample logic.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_PATH_LAYOUT, I_F3A_PATH
Evidence: E_DEPENDENCY_MAP, E_PATH_AUDIT

Preparation / proposed procedure:

1. Choose a working directory and configure a local project root for the Stata and R inputs and outputs.
2. Update the path references consistently in a working copy, using the packaged script name for the Figure 3a generator.
3. Keep producer and consumer filenames aligned across the master, table and graph programs.

Validation to perform later:

- Review every include, data input and output reference against the staged filenames.
- Confirm that all output destinations are writable before any later authorized execution.

### A_LABEL_HELPER: Obtain the missing variable-label helper or its complete author-supplied replacement instructions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_LABEL_HELPER
Evidence: E_LABEL_CALL, E_ITEM_INVENTORY

Preparation / proposed procedure:

1. Request the helper referenced by the master and supplied tables.
2. Preserve the call order and do not remove labeling calls without author confirmation.

Validation to perform later:

- Check that the helper resolves in the portable working copy before a future run.

### A_MASTER_AUX_CODE: Obtain the source programs directly called by the selected master or their author-supplied replacement instructions. The direct master calls remain in scope; distinguish them from unreferenced paper-wide estimators.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_MASTER_AUX_CODE
Evidence: E_T3_7_CALL, E_ITEM_INVENTORY

Preparation / proposed procedure:

1. Supply the missing table/appendix programs called by the selected master or author-provided instructions for their outputs and inputs.
2. Preserve the direct call order and document any unreferenced paper-wide estimators separately from this selected workflow.

Validation to perform later:

- Reconcile each direct master call against the supplied source set before considering the selected workflow complete.

### A_SOFTWARE_SETUP: Prepare the remaining unavailable Stata commands and R library dependencies in an approved environment; eststo is available in the captured Stata 18 environment.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_WINSOR2, S_IHSTRANS, S_MAGRITTR, S_DPLYR, S_AUGSYNTH, S_HAVEN, S_TIDYR, S_GGPLOT2, S_GGREPEL
Evidence: E_STATA_IHSTRANS, E_ENVIRONMENT_SAFE, E_R_PACKAGE_META, E_R_LIBS, E_ESTSTO_SOFTWARE_CHECK_037

Preparation / proposed procedure:

1. Locate or install the approved Stata source for winsor2 and ihstrans.
2. Install the missing R packages in a user-approved R library after confirming package versions compatible with the authors’ scripts.
3. Keep the installed foreign package and currently available Stata helpers as recorded; eststo passed the exact metadata-only availability check.

Validation to perform later:

- Run metadata-only package and exact command availability checks for the remaining preparation-required dependencies.
- Record the R and Stata versions used before any authorized analysis run.


## Remaining issues and prerequisites

- I_INPUT_CLOSURE [unresolved; full_pipeline]: Several author-prepared input workbooks, crosswalks and the final analysis panel are absent from the package. One-row local reads verified selected Worldscope annual/company/stock and Compustat Global annual/name fields; the bounded S34 read timed out at 15 seconds. The author-file mappings, joins, rolling/sample history, PRI manager-year match and other input coverage remain unresolved.
- I_COUNTRY_CROSSWALK [unresolved; full_pipeline]: Country-level indicators require a manually prepared name crosswalk to Worldscope names. The crosswalk and full mapping rows are not supplied.
- I_PRI_MANAGER_CROSSWALK [unresolved; full_pipeline]: S34 manager names require a separately prepared PRI signatory match file. The workbook, match decisions and completed mapping are not supplied.
- I_ESG_PANEL_PRODUCER [unresolved; full_pipeline]: The partial R branch consumes a separate ESG synthetic-control panel, while the supplied Stata preparation writes only the non-ESG panel. The ESG panel producer and compatible schema are unresolved.
- I_FIGURE3_HANDOFF [unresolved; full_pipeline]: The Figure 3 graph consumes a manually aggregated workbook from the three R alternatives. The workbook and field-level aggregation recipe are absent.
- I_PATH_LAYOUT [preparation; full_pipeline]: The supplied Stata workflow contains machine-specific absolute paths, so a portable working-copy configuration is required before an execution attempt.
- I_F3A_PATH [preparation; full_pipeline]: A supplied include names the Figure 3a generator with a filename spacing mismatch relative to the packaged source file.
- I_LABEL_HELPER [unresolved; full_pipeline]: The master and supplied table programs call a separate variable-label helper that is not in the package inventory.
- I_MASTER_AUX_CODE [unresolved; full_pipeline]: The selected master directly calls additional table/appendix programs at source line 45, but the called source is absent from the package inventory. Those direct calls are in the selected workflow; unreferenced paper-wide estimators remain outside this entrypoint finding.
- R_WORLDSCOPE_ANNUAL [undetermined]: The author-named annual Worldscope item workbooks used to create firm-year accounting, balance-sheet, market and ESG controls.
- R_WORLDSCOPE_COMPANY [undetermined]: The distinct Worldscope company-descriptor workbook used for names, country and security identifiers.
- R_WORLDSCOPE_MONTHLY [undetermined]: The distinct monthly Worldscope price workbook used to calculate return variance over the authored rolling monthly window.
- R_WDI [undetermined]: Fourteen World Development Indicators country-year series named by the preparation program, including CO2, GDP per capita and growth, capital formation, inflation, oil use, prime rates, renewable energy, resource rents, risk, taxes, unemployment and urban population.
- R_WGI [undetermined]: The six author-selected WGI dimensions imported from a six-sheet governance workbook and merged at country-year level.
- R_DPI [undetermined]: The author-named DPI2017 political-institutions panel used in the country-level merge.
- R_COUNTRY_CROSSWALK [undetermined]: The manually prepared country-name crosswalk linking World Bank, WGI and DPI names to Worldscope country names.
- R_BLOOMBERG [undetermined]: Three Bloomberg ESG disclosure extracts: the overall disclosure score, component scores and expanded component values used in the firm-year panel.
- R_FACTSET_INDUSTRY [undetermined]: The author-named FactSet industry extract used in firm classification and panel preparation.
- R_TREATMENT_KEY [undetermined]: The separate author treatment key used to create treatment assignment and event-time variables.
- R_FACTSET_OWNERSHIP [undetermined]: FactSet institutional-ownership exports used to create the firm-level ownership measures.
- R_FACTSET_LOCATIONS [undetermined]: FactSet firm-location values used in the author data construction and matching steps.
- R_COMPUSTAT_ACCOUNTING [undetermined]: The author-prepared Compustat Global standardized accounting table used for accounting-standard and financial-variable construction.
- R_COMPUSTAT_GLOBAL_KEYS [undetermined]: The Compustat Global identifier-to-GVKEY mapping used in patent and firm-data joins.
- R_COMPUSTAT_NA_KEYS [undetermined]: The Compustat North America identifier-to-GVKEY mapping used in patent and firm-data joins.
- R_GCPD_FILINGS [undetermined]: The author-formatted GCPD patent-filing extract linked to firms for annual patent counts.
- R_GCPD_CITATIONS [undetermined]: The author-formatted GCPD citation extract linked to patent numbers and firm identifiers for annual citation measures.
- R_S34_HOLDINGS [undetermined]: Thomson Reuters/LSEG S34 holdings and manager data used to construct ownership measures for final-sample CUSIPs.
- R_PRI_SIGNATORY_DATA [undetermined]: PRI signatory names and historical signatory status used to classify institutional managers in the S34 workflow.
- R_PRI_MANAGER_MAP [undetermined]: The manually prepared PRI-to-S34 manager mapping used to create PRI flags for S34 holdings.
- R_AUGSYNTH_ESG [undetermined]: The separate ESG synthetic-control panel consumed by the partial R alternative, with author-required treatment year, year, firm effect and ESG disclosure score fields.
- R_FIGURE3_BRIDGE [undetermined]: The manually aggregated R-result workbook consumed by the Figure 3 Stata graph program.
- S_WINSOR2 [preparation_required]: The existing bounded environment check did not find winsor2 in checked adopaths; install or locate its approved command source before running the author code.
- S_IHSTRANS [preparation_required]: Metadata-only Stata lookup did not find ihstrans.
- S_MAGRITTR [preparation_required]: The package is not installed in the inspected R library metadata.
- S_DPLYR [preparation_required]: The package is not installed in the inspected R library metadata.
- S_AUGSYNTH [preparation_required]: The package is not installed in the inspected R library metadata.
- S_HAVEN [preparation_required]: The package is not installed in the inspected R library metadata.
- S_TIDYR [preparation_required]: The package is not installed in the inspected R library metadata.
- S_GGPLOT2 [preparation_required]: The package is not installed in the inspected R library metadata.
- S_GGREPEL [preparation_required]: The package is not installed in the inspected R library metadata.

## Review notes

- The package is assessed as one full_pipeline scope. The partial, pooled and separate R scripts are retained as distinct alternatives. No analysis_only route is claimed because the package contains no verified compatible author-prepared analysis panel.
- No author program was run and no source edit was applied. Current evidence does not establish complete data access, exact product compatibility, historical coverage, or output execution.
- The author-specified cohort construction and model branches are preserved for a future run. The master also references absent paper-wide table/appendix code, recorded as an unresolved workflow limitation without creating separate unsupported scopes.
- Process-only history, excluded from scientific evidence: one read-only metadata projection rendered a nested diagnostic field, and one external dependency target value was displayed during metadata inspection. Values are not reproduced; no authentication-like value was observed and no exhaustive absence claim is made. The environment artifact remains unchanged. Location/hash records are in probes/process_history.json and probes/process_history_addendum.json; no access barrier or scientific claim is based on them.
