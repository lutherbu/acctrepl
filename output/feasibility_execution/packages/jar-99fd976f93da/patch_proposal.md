# Patch proposal: jar-99fd976f93da

Transparency and Tax Evasion: Evidence from the Foreign Account Tax Compliance Act (FACTA)

DOI: 10.1111/1475-679X.12293

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The entire supplied SAS/Stata workflow embedded in the code PDF: data preparation starting from a compatible author-prepared CPIS/Zucman matrix; SAS Table 1 descriptives; Appendix A; Figures 1–5A/B; Tables 1–6; and online appendix Tables 1–3 and weighted/robust alternatives. No analysis-only route is supported because the package includes no prepared analysis datasets.

Entry points: `DLM FATCA SAS and STATA Code.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 1/12293 - Transparency-and-Tax-Evasion-Evidence-from-the-Foreign-Account-Tax-Compliance-Act-FACTA/dlm-datasheet-and-code.zip",
      "sha256": "35fa4acd9658f405fad279629b1dc26b56a26a36c15cd72309d7539201aa6d70"
    },
    {
      "path": "JAR-Volume 58/Issue 1/12293 - Transparency-and-Tax-Evasion-Evidence-from-the-Foreign-Account-Tax-Compliance-Act-FACTA/dlm-online-appendix.pdf",
      "sha256": "b5a018608920d7888c7dfc8f604730732f5969715f557e9e32a6db69f7ba34e2"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "b7e5365a56c7168f58212aa0f02eee47bbb87d4bc8af49ada08fa3dfe3ab59d8"
}
```

## Proposed actions

### act_req_tic_1984_2011: Verify a current primary or author-prepared route for the required product, then acquire and convert/prepare it to the documented country/year schema.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_tic_1984_2011
Evidence: src_tic_inputs, sheet_sources, inv_package

Preparation / proposed procedure:

1. Check a current official or author-prepared source for the named product and the required historical period.
2. Obtain the author-prepared table when available; otherwise document a supported source-to-target conversion and preserve all country/ISO/year mappings.
3. Prepare the file in the expected format and compare source fields and keys against the embedded SAS/Stata reads.

Validation to perform later:

- Before a separately authorized run, verify readability, exact field names/keys, required history and country coverage against the downstream merge/filter.

### act_req_tic_2011_2015: Verify a current primary or author-prepared route for the required product, then acquire and convert/prepare it to the documented country/year schema.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_tic_2011_2015
Evidence: src_tic2_inputs, sheet_sources, inv_package

Preparation / proposed procedure:

1. Check a current official or author-prepared source for the named product and the required historical period.
2. Obtain the author-prepared table when available; otherwise document a supported source-to-target conversion and preserve all country/ISO/year mappings.
3. Prepare the file in the expected format and compare source fields and keys against the embedded SAS/Stata reads.

Validation to perform later:

- Before a separately authorized run, verify readability, exact field names/keys, required history and country coverage against the downstream merge/filter.

### act_req_zucman_prep: Obtain the exact author-prepared file or missing preparation program, its source schema, country/year keys, historical coverage and conversion instructions; do not reconstruct undocumented mappings.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_zucman_prep
Evidence: src_cpis_driver, inv_package

Preparation / proposed procedure:

1. Ask for the author-used input or the producer that creates it.
2. Record exact file format, keys, variables, country mappings, period and upstream source files.
3. If an upstream producer is supplied, preserve its original transformations and compare its output schema with every consuming call.

Validation to perform later:

- Before a separately authorized run, confirm the required file is readable and contains the expected keys and variables; reconcile coverage with the consumer’s year/country filters.

### act_req_tax_rates: Obtain the exact author-prepared file or missing preparation program, its source schema, country/year keys, historical coverage and conversion instructions; do not reconstruct undocumented mappings.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_tax_rates
Evidence: src_tax_haven, sheet_sources, inv_package

Preparation / proposed procedure:

1. Ask for the author-used input or the producer that creates it.
2. Record exact file format, keys, variables, country mappings, period and upstream source files.
3. If an upstream producer is supplied, preserve its original transformations and compare its output schema with every consuming call.

Validation to perform later:

- Before a separately authorized run, confirm the required file is readable and contains the expected keys and variables; reconcile coverage with the consumer’s year/country filters.

### act_req_worldbank_technology: Verify a current primary or author-prepared route for the required product, then acquire and convert/prepare it to the documented country/year schema.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_worldbank_technology
Evidence: src_wb_tech, sheet_wb, inv_package

Preparation / proposed procedure:

1. Check a current official or author-prepared source for the named product and the required historical period.
2. Obtain the author-prepared table when available; otherwise document a supported source-to-target conversion and preserve all country/ISO/year mappings.
3. Prepare the file in the expected format and compare source fields and keys against the embedded SAS/Stata reads.

Validation to perform later:

- Before a separately authorized run, verify readability, exact field names/keys, required history and country coverage against the downstream merge/filter.

### act_req_wgi: Verify a current primary or author-prepared route for the required product, then acquire and convert/prepare it to the documented country/year schema.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_wgi
Evidence: src_tax_wgi_haven, sheet_wb, inv_package

Preparation / proposed procedure:

1. Check a current official or author-prepared source for the named product and the required historical period.
2. Obtain the author-prepared table when available; otherwise document a supported source-to-target conversion and preserve all country/ISO/year mappings.
3. Prepare the file in the expected format and compare source fields and keys against the embedded SAS/Stata reads.

Validation to perform later:

- Before a separately authorized run, verify readability, exact field names/keys, required history and country coverage against the downstream merge/filter.

### act_req_haven_class: Obtain the exact author-prepared file or missing preparation program, its source schema, country/year keys, historical coverage and conversion instructions; do not reconstruct undocumented mappings.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_haven_class
Evidence: src_tax_haven, inv_package

Preparation / proposed procedure:

1. Ask for the author-used input or the producer that creates it.
2. Record exact file format, keys, variables, country mappings, period and upstream source files.
3. If an upstream producer is supplied, preserve its original transformations and compare its output schema with every consuming call.

Validation to perform later:

- Before a separately authorized run, confirm the required file is readable and contains the expected keys and variables; reconcile coverage with the consumer’s year/country filters.

### act_req_hmt_historical: Obtain the exact author-prepared file or missing preparation program, its source schema, country/year keys, historical coverage and conversion instructions; do not reconstruct undocumented mappings.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_hmt_historical
Evidence: src_hmt08, src_scope, inv_package

Preparation / proposed procedure:

1. Ask for the author-used input or the producer that creates it.
2. Record exact file format, keys, variables, country mappings, period and upstream source files.
3. If an upstream producer is supplied, preserve its original transformations and compare its output schema with every consuming call.

Validation to perform later:

- Before a separately authorized run, confirm the required file is readable and contains the expected keys and variables; reconcile coverage with the consumer’s year/country filters.

### act_req_ucits: Verify a current primary or author-prepared route for the required product, then acquire and convert/prepare it to the documented country/year schema.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_ucits
Evidence: src_ucits, sheet_swiss_geneva, inv_package

Preparation / proposed procedure:

1. Check a current official or author-prepared source for the named product and the required historical period.
2. Obtain the author-prepared table when available; otherwise document a supported source-to-target conversion and preserve all country/ISO/year mappings.
3. Prepare the file in the expected format and compare source fields and keys against the embedded SAS/Stata reads.

Validation to perform later:

- Before a separately authorized run, verify readability, exact field names/keys, required history and country coverage against the downstream merge/filter.

### act_req_realestate: Verify a current primary or author-prepared route for the required product, then acquire and convert/prepare it to the documented country/year schema.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_realestate
Evidence: src_realestate, sheet_realestate, inv_package

Preparation / proposed procedure:

1. Check a current official or author-prepared source for the named product and the required historical period.
2. Obtain the author-prepared table when available; otherwise document a supported source-to-target conversion and preserve all country/ISO/year mappings.
3. Prepare the file in the expected format and compare source fields and keys against the embedded SAS/Stata reads.

Validation to perform later:

- Before a separately authorized run, verify readability, exact field names/keys, required history and country coverage against the downstream merge/filter.

### act_req_swiss_customs: Verify present Swiss-Impex subscription terms/entitlement and the author-used export fields and years, then obtain the compatible workbook through an authorized route.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_swiss_customs
Evidence: src_swiss, src_swiss_lags, sheet_swiss_geneva, inv_package, src_swiss_zero_fill

Preparation / proposed procedure:

1. Check the current Swiss-Impex product, available historical period, canton-level fields and export method.
2. Confirm present entitlement for the Expert data used in the paper; do not assume a catalog miss or historical purchase proves current access.
3. Obtain or prepare a workbook matching the author’s period, canton identifiers, and import/export kilograms and CHF. Preserve the supplied code’s explicit zero-fill for unavailable or nonconsecutive lag 1–11 values; do not fabricate earlier source observations.

Validation to perform later:

- Inspect workbook headers and actual period/canton coverage before the Stata branch. A fully observed 11-lag window for a 2006 value could reach back to 1995, but the code zero-fills missing/nonconsecutive lag terms; missing 1995 alone is not a proven execution blocker.
- Confirm the lag conditions and zero replacements remain intact in the faithful working copy and report the observed input coverage.

### act_req_china_gdp: Obtain the exact author-prepared file or missing preparation program, its source schema, country/year keys, historical coverage and conversion instructions; do not reconstruct undocumented mappings.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_china_gdp
Evidence: src_chinarussia, src_stata_inputs, inv_package

Preparation / proposed procedure:

1. Ask for the author-used input or the producer that creates it.
2. Record exact file format, keys, variables, country mappings, period and upstream source files.
3. If an upstream producer is supplied, preserve its original transformations and compare its output schema with every consuming call.

Validation to perform later:

- Before a separately authorized run, confirm the required file is readable and contains the expected keys and variables; reconcile coverage with the consumer’s year/country filters.

### act_req_russia_gdp: Obtain the exact author-prepared file or missing preparation program, its source schema, country/year keys, historical coverage and conversion instructions; do not reconstruct undocumented mappings.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_russia_gdp
Evidence: src_chinarussia, src_stata_inputs, inv_package

Preparation / proposed procedure:

1. Ask for the author-used input or the producer that creates it.
2. Record exact file format, keys, variables, country mappings, period and upstream source files.
3. If an upstream producer is supplied, preserve its original transformations and compare its output schema with every consuming call.

Validation to perform later:

- Before a separately authorized run, confirm the required file is readable and contains the expected keys and variables; reconcile coverage with the consumer’s year/country filters.

### act_missing_producer: Resolve the missing CPIS/Zucman matrix input for the supplied-code target; use the raw producer and its source bundle only if an author-prepared compatible matrix is unavailable or that alternative is selected.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_missing_producer
Evidence: src_cpis_driver, inv_package, sheet_sources, public_imf_pip, public_dnb_sfi, public_imf_iip

Preparation / proposed procedure:

1. First obtain the author-prepared `dlm.dlm_full_matrices_keyvars` table and its schema/history manifest, then verify its source-IFS keys and variables against the supplied SAS join. This is the selected input route and preserves the remaining author code.
2. If instead the raw-rebuild alternative is selected, request the separate “DLM Data - CPIS and Zucman” program and its individual CPIS Table 11, Netherlands SFI, OANDA FX and IMF IIP inputs; confirm source vintages, fields, units, mappings and years for that alternative.
3. Keep the separately consumed `countrycodes` crosswalk as a direct requirement in either route; do not treat it as satisfied by the prepared matrix.
4. Trace the selected matrix through the SAS `cpisfull` and `zucmanfull` outputs into Table 4 and the online appendix consumers.

Validation to perform later:

- Compare the selected matrix columns, identifiers, keys and year coverage against SAS joins, variable construction and every Stata consumer. For the optional raw route, validate its producer output before substituting it for the prepared matrix.

### act_extract_programs: Create working copies of all supplied SAS and Stata program sections from the PDF while preserving authored logic; the PDF and its cached extraction are evidence, not directly executable program files.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: issue_embedded_code
Evidence: src_scope, src_stata_inputs, inv_package

Preparation / proposed procedure:

1. Extract the main SAS preparation, the companion SAS Table 1 program, and the complete Stata main/online appendix sections into separate working source files.
2. Retain every documented branch and output; reconcile line breaks/continuations against the source PDF before execution.
3. Record any missing includes, globals, macros, source data definitions or pre-processing instructions without inventing replacements.

Validation to perform later:

- Review the extracted source against the complete code PDF and confirm all named tables/figures and online appendix sections are present.

### act_configure_roots: Configure a coherent runtime tree for the separate SAS preparation, SAS Table 1 output, and Stata analyses, retaining the distinct embedded author roots while aligning outputs and consumers.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: issue_path_handoff
Evidence: src_z_outputs, src_roots, src_stata_root

Preparation / proposed procedure:

1. Use a documented relative or `[redacted-path-4b6766cb9c2e]` execution root for host wrappers; keep the original embedded absolute Dropbox/Windows paths only as evidence.
2. Set the SAS `dlm` library and output roots consistently with Stata input paths; preserve the separate SAS Table 1 output folder or explicitly configure it.
3. Provide a compatible, validated SAS-to-Stata handoff for data1, cpisfull, zucmanfull, dlm_hmt08 and dlm_hmt15. Their PROC EXPORT statements are block-commented; verify the chosen transfer rather than assuming the PDF writes `.dta` outputs.
4. Keep generated UCITS, real-estate and Swiss intermediate files in the Stata working root and route table/figure output paths to writable locations.

Validation to perform later:

- Before a separately authorized run, confirm each SAS output path is writable and visible to Stata, then compare producer/consumer names, formats, key fields and row counts after transfer.

### act_sas_runtime: Resolve SAS initialization/runtime setup and establish availability of the Base SAS and ODS export capabilities required by the source before execution.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: issue_sas_runtime, software_sas
Evidence: env_probe, src_scope

Preparation / proposed procedure:

1. Review the SAS startup failure with the runtime administrator and correct the TKELS initialization issue if supported.
2. Verify that the runtime can start in batch mode and provides the active procedures and ODS TAGSETS.EXCELXP output used by the source.
3. Retain version and component proof without treating the current startup failure as an entitlement denial.

Validation to perform later:

- Run a separately authorized empty-session version/capability check, not the author programs.

### act_stata_addons: Prepare the three missing Stata add-ons that the supplied code actively invokes; do not install or alter shared adopaths during this assessment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: software_outreg2, software_newey2, software_lgraph
Evidence: src_stata_newey_outreg, src_stata_lgraph, probe_outreg2, probe_newey2, probe_lgraph

Preparation / proposed procedure:

1. In the future authorized run environment, install or point to approved local copies of `outreg2`, `newey2` and `lgraph` using the site’s normal Stata package procedure.
2. Keep Stata 18 and its current compatible `set mem` behavior; do not add `winsor2`, whose only invocation is commented out.
3. Run direct `which` checks for the three commands in the same adopath that will execute the paper code.

Validation to perform later:

- Confirm each active command resolves in the intended Stata environment before starting the author do-file; record package versions and paths.

### act_conditional_run_order: After code/data/software contracts and roots are resolved, follow the supplied branch order and validate produced files without changing analytical logic.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: issue_embedded_code, issue_missing_producer, issue_path_handoff, issue_unknown_data_contracts, software_sas, software_stata
Evidence: src_scope, src_stata_inputs, src_sas_data1_write, src_sas_table1_ods, src_sas_exports_cpis, src_sas_export_hmt, src_stata_newey_outreg, src_stata_lgraph, inv_package

Preparation / proposed procedure:

1. Extract faithful working copies of the embedded main SAS preparation, separate SAS Table 1 section, and complete Stata program, including online appendix branches; compare each copy with the PDF.
2. Provide the directly required source tables and a compatible author-prepared `dlm.dlm_full_matrices_keyvars` matrix for the selected input route; resolve raw CPIS/SFI/OANDA/IIP contracts only if choosing to rebuild that matrix. Configure distinct SAS libraries, Stata working directory, outputs and explicit handoff.
3. Once SAS starts with active required procedures and ODS TAGSETS.EXCELXP, run the main SAS preparation before the separate Table 1 SAS section; verify generated SAS datasets and `descrip.XLS` at the configured destinations.
4. Transfer or expose `data1`, `cpisfull`, `zucmanfull`, `dlm_hmt08` and `dlm_hmt15` to Stata in a verified readable format. Stata 18 compatibility for `set mem 800m` is already confirmed; resolve missing add-ons first.
5. Run the supplied Stata branches in embedded order: Appendix A, Figures 1–5 (Figure 2 constants are in the program), Tables 1–6, then the online appendix Tables 1–3 and their included robustness/weighted branches. Use the separate UCITS, real-estate, Swiss and China/Russia inputs where their code reads them.

Validation to perform later:

- Before full regression execution, verify each source and generated file opens, expected field/key/year contracts match its direct consumers, and the SAS-to-Stata handoff preserves identifiers and row counts.
- After a separately authorized run, confirm every documented figure/table/appendix output exists, compare observed rows and sample filters to the supplied code, and inspect SAS logs, Stata return codes and output files. No numerical replication has been verified in this assessment.

### act_req_countries_2_3: Obtain the exact author-prepared `countries_2_3` table or verify a compatible primary route and the required schema/history.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_countries_2_3
Evidence: src_countries_2_3, catalog_lookup, inv_package

Preparation / proposed procedure:

1. Locate the author-used `countries_2_3` file or source specification and preserve its original name and transformation.
2. Confirm exact fields, keys, units, year columns, country mappings and required coverage against the supplied consumer.
3. If a compatible World Bank route is used, document the indicator-to-author-column mapping and country/year checks; do not replace undocumented repair constants.

Validation to perform later:

- Before a separately authorized run, inspect exact headers and keys; verify the full required history and downstream merge coverage.

### act_req_countrycodes: Obtain the exact author-prepared `countrycodes` table or verify a compatible primary route and the required schema/history.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_countrycodes
Evidence: src_countrycodes, catalog_lookup, inv_package

Preparation / proposed procedure:

1. Locate the author-used `countrycodes` file or source specification and preserve its original name and transformation.
2. Confirm exact fields, keys, units, year columns, country mappings and required coverage against the supplied consumer.
3. If a compatible World Bank route is used, document the indicator-to-author-column mapping and country/year checks; do not replace undocumented repair constants.

Validation to perform later:

- Before a separately authorized run, inspect exact headers and keys; verify the full required history and downstream merge coverage.

### act_req_euro_fx: Obtain the exact author-prepared `euro` table or verify a compatible primary route and the required schema/history.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_euro_fx
Evidence: src_euro_fx, src_fx_repair, catalog_lookup, inv_package

Preparation / proposed procedure:

1. Locate the author-used `euro` file or source specification and preserve its original name and transformation.
2. Confirm exact fields, keys, units, year columns, country mappings and required coverage against the supplied consumer.
3. If a compatible World Bank route is used, document the indicator-to-author-column mapping and country/year checks; do not replace undocumented repair constants.

Validation to perform later:

- Before a separately authorized run, inspect exact headers and keys; verify the full required history and downstream merge coverage.

### act_req_fx_repair: Obtain the exact author-prepared `fx_01_15` table or verify a compatible primary route and the required schema/history.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_fx_repair
Evidence: src_fx_repair, src_wb_fx, catalog_lookup, inv_package

Preparation / proposed procedure:

1. Locate the author-used `fx_01_15` file or source specification and preserve its original name and transformation.
2. Confirm exact fields, keys, units, year columns, country mappings and required coverage against the supplied consumer.
3. If a compatible World Bank route is used, document the indicator-to-author-column mapping and country/year checks; do not replace undocumented repair constants.

Validation to perform later:

- Before a separately authorized run, inspect exact headers and keys; verify the full required history and downstream merge coverage.

### act_req_wb_fx: Obtain the exact author-prepared `wb_xrate` table or verify a compatible primary route and the required schema/history.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_wb_fx
Evidence: src_wb_fx, public_wb_fx, catalog_lookup, inv_package

Preparation / proposed procedure:

1. Locate the author-used `wb_xrate` file or source specification and preserve its original name and transformation.
2. Confirm exact fields, keys, units, year columns, country mappings and required coverage against the supplied consumer.
3. If a compatible World Bank route is used, document the indicator-to-author-column mapping and country/year checks; do not replace undocumented repair constants.

Validation to perform later:

- Before a separately authorized run, inspect exact headers and keys; verify the full required history and downstream merge coverage.

### act_req_wb_gdp: Obtain the exact author-prepared `wb_gdp` table or verify a compatible primary route and the required schema/history.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_wb_gdp
Evidence: src_wb_gdp, public_wb_gdp, catalog_lookup, inv_package

Preparation / proposed procedure:

1. Locate the author-used `wb_gdp` file or source specification and preserve its original name and transformation.
2. Confirm exact fields, keys, units, year columns, country mappings and required coverage against the supplied consumer.
3. If a compatible World Bank route is used, document the indicator-to-author-column mapping and country/year checks; do not replace undocumented repair constants.

Validation to perform later:

- Before a separately authorized run, inspect exact headers and keys; verify the full required history and downstream merge coverage.

### act_req_wb_population: Obtain the exact author-prepared `wb_pop` table or verify a compatible primary route and the required schema/history.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_wb_population
Evidence: src_wb_population, public_wb_population, catalog_lookup, inv_package

Preparation / proposed procedure:

1. Locate the author-used `wb_pop` file or source specification and preserve its original name and transformation.
2. Confirm exact fields, keys, units, year columns, country mappings and required coverage against the supplied consumer.
3. If a compatible World Bank route is used, document the indicator-to-author-column mapping and country/year checks; do not replace undocumented repair constants.

Validation to perform later:

- Before a separately authorized run, inspect exact headers and keys; verify the full required history and downstream merge coverage.

### act_req_wdi2015: Obtain the exact author-prepared `wdi2015` table or verify a compatible primary route and the required schema/history.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_wdi2015
Evidence: src_wdi2015_input, catalog_lookup, inv_package

Preparation / proposed procedure:

1. Locate the author-used `wdi2015` file or source specification and preserve its original name and transformation.
2. Confirm exact fields, keys, units, year columns, country mappings and required coverage against the supplied consumer.
3. If a compatible World Bank route is used, document the indicator-to-author-column mapping and country/year checks; do not replace undocumented repair constants.

Validation to perform later:

- Before a separately authorized run, inspect exact headers and keys; verify the full required history and downstream merge coverage.


## Remaining issues and prerequisites

- issue_missing_producer [unresolved; full_pipeline]: The supplied SAS program names a separate “DLM Data - CPIS and Zucman” producer for `dlm.dlm_full_matrices_keyvars`, but that program and matrix are absent from this PDF-only package. The selected supplied-code target can start from a compatible author-prepared matrix; only if the raw-rebuild alternative is chosen are CPIS Table 11, Netherlands SFI, OANDA FX and IMF IIP separate upstream input contracts. Their exact history/schema remains unclosed, so that alternative is not the selected mandatory input set.
- issue_embedded_code [preparation; full_pipeline]: All supplied SAS and Stata programs are embedded in a PDF; no standalone `.sas`, `.do`, or source data files are inventoried. Extract faithful working copies from the document and resolve any omitted setup before running; source text itself is not an executable path.
- issue_path_handoff [preparation; full_pipeline]: The main SAS library uses `[redacted-path-0a49898a8ce5]`; the separate Table 1 SAS section switches to `[redacted-path-c5b4dfd6e8e8]`; Stata changes to a third user Dropbox folder. The active main SAS code writes `dlm.data1`, while PROC EXPORT calls for data1, cpisfull, zucmanfull, dlm_hmt08 and dlm_hmt15 are all inside block comments. Configure distinct roots and a verified handoff. Active ODS TAGSETS.EXCELXP writes the separate Table 1 workbook.
- issue_unknown_data_contracts [unresolved; full_pipeline]: The PDF-only package lacks directly consumed author tables and exact source-to-output manifests needed to validate fields, country mappings, units, cleaning and history. Each direct read, including the CPIS/Zucman matrix and countrycodes, has its own requirement. CPIS Table 11, Netherlands SFI, OANDA FX and IMF IIP belong only to the conditional raw-preparer route and can be bypassed by a compatible matrix.
- issue_sas_runtime [unresolved; full_pipeline]: The only bounded SAS startup checks failed before a SAS session could initialize TKELS. Base SAS procedures and active ODS TAGSETS.EXCELXP therefore remain unverified in this environment; the failure does not establish absent licensing. The Stata exports in the PDF are block-commented, so no active SAS-to-Stata export facility is required by the source.
- req_tic_1984_2011 [undetermined]: The SAS preparation reads `dlm.ticdata_ftot`, a converted monthly Treasury source with country code/name, date and agency/corporate-stock/corporate-bond/Treasury positions, for the documented 1984–2011 branch. Source-history coverage and matching source fields still need verification.
- req_tic_2011_2015 [undetermined]: The SAS preparation reads `dlm.Slt1d_global_forsas` for 2011–2015, with country code/name, date and agency, corporate bond/stock and Treasury position fields; data are combined with the earlier monthly branch.
- req_countries_2_3 [undetermined]: The SAS preparation separately reads `dlm.countries_2_3` to match TIC country names and to attach ISO mappings. The exact author table and country aliases must be verified.
- req_countrycodes [undetermined]: The supplied SAS code directly reads `dlm.countrycodes` to join source IFS identifiers to ISO2, ISO3 and country names while consuming `dlm.dlm_full_matrices_keyvars`; this crosswalk remains a required input even when the prepared matrix is used.
- req_zucman_prep [undetermined]: The main SAS code directly consumes `dlm.dlm_full_matrices_keyvars`. For the selected supplied-code target, a compatible author-prepared matrix is the input contract; the separate upstream producer and its raw sources are not simultaneous mandatory inputs. The exact matrix schema and required history are absent.
- req_tax_rates [undetermined]: SAS joins `dlm.indiv_rates` by ISO3 and year. It must supply top statutory individual tax rates with compatible country-year keys; the datasheet says the authors compiled coverage across University of Michigan, OECD, KPMG, Tax Foundation and Trading Economics.
- req_wb_population [undetermined]: The SAS macro reads `dlm.wb_pop` and reshapes annual country values to population by ISO3/year. It is a distinct input from GDP, exchange rates and the separate 2015 workbook.
- req_wb_gdp [undetermined]: The SAS macro separately reads `dlm.wb_gdp` and reshapes annual GDP values by country code. This is distinct from population, WB exchange rates and the 2015 workbook.
- req_wb_fx [undetermined]: The SAS macro separately reads `dlm.wb_xrate` and reshapes annual country-code values; its output is labeled official exchange rate in local currency per US dollar, period average.
- req_wdi2015 [undetermined]: The 2015 SAS branch separately reads `dlm.wdi2015`, a manually reheaded workbook with Country, iso3, gdp, population and xrate; it is not the generated `wbdata2015` intermediate.
- req_euro_fx [undetermined]: The SAS FX repair logic separately reads `dlm.euro`, filters `country_code="EMU"`, and derives annual euro rates to fill missing euro-area rates. This is an author-prepared source table, not a generated intermediate.
- req_fx_repair [undetermined]: The main SAS controls separately read `dlm.fx_01_15` for annual exchange rates and use it in the WB exchange-rate repair. Exact source, units, countries and complete years are not identified.
- req_worldbank_technology [undetermined]: `dlm.wb_techdata` is required for mobile subscription controls. The macro reads annual columns for 2000–2016 and SAS derives mobile subscriptions per 100 people; source columns/indicator coverage need verification.
- req_wgi [undetermined]: `dlm.wgi_sas` is read for `GE.PER.RNK` and transformed into a country-level high-effectiveness indicator using 2012 values. Exact workbook years and source columns require verification.
- req_haven_class [undetermined]: `dlm.havenlistx6` supplies the 2009 tax-haven country classification joined by ISO2; exact table and mapping are absent.
- req_hmt_historical [undetermined]: Appendix A consumes `dlm.dlm_84to15` for HMT-country December data through 2008. No producer for this SAS dataset appears in the supplied program; the main TIC branch is not shown writing this named table.
- req_ucits [undetermined]: Figures 3, Table 5 and online appendix analyses import `ucits_assets_final.xlsx`, reshape country/year asset columns and retain full 10-observation panels after excluding 2005/2016. The expected workbook layout, units and historical country coverage are unverified.
- req_realestate [undetermined]: Figures 4, Table 6 and online appendix read `datacollection_cleaned.csv`; required fields include date, country, ISO2/ISO3, nominal price, real price, rent and income, transformed to country-year means. Table 6 estimates 2006–2015; original source combination, matching and country/history coverage remain unverified.
- req_swiss_customs [undetermined]: Figures 5A/B import `swiss_data_to_import` with period, canton number/name and gross import/export kg/CHF. The code constructs gross and net stocks with 11 prior annual lags and explicitly replaces unavailable/nonconsecutive lag values with zero before summing. For a fully observed 11-lag window beginning in 2006, the earliest potential lag year is 1995; actual workbook history and fields remain unknown, and absence of 1995 alone is not a proven blocker.
- req_china_gdp [undetermined]: Table 6 and the online appendix actively merge `chinagdp` by year. The source/product, required history and GDP column names are not documented in the supplied code; the merge is inside a branch retained in scope.
- req_russia_gdp [undetermined]: Table 6 and the online appendix actively merge `russiagdp` by year. The source/product, required history and GDP column names are not documented in the supplied code; the merge is inside a branch retained in scope.
- software_sas [unverified]: SAS 9.4 is named on the host but bounded startup probes fail while initializing TKELS, so actual SAS runtime availability is unverified. Source uses active Base SAS data steps/PROC SQL/SORT/TRANSPOSE/APPEND/MEANS/PRINT and active ODS TAGSETS.EXCELXP for Table 1. All PROC EXPORT calls producing Stata `.dta` files are block-commented; no active SAS-to-Stata export capability is evidenced.
- software_outreg2 [preparation_required]: Stata add-on required for Excel regression tables; direct `which outreg2` probe returned unavailable in the checked adopaths.
- software_newey2 [preparation_required]: Stata add-on required for Appendix A and Newey-West robustness branches; direct probe returned unavailable in the checked adopaths.
- software_lgraph [preparation_required]: Stata add-on required by supplied figure commands; direct probe returned unavailable in the checked adopaths.

## Review notes

- Frozen header identity is retained exactly: title says FACTA while the author datasheet/code say FATCA.
- The source-sanity note was not used as a substitute for reading: the full 3,024-line embedded program, 158-line datasheet and 143-line appendix were reviewed. Static audit reports zero code/edges, but the PDF contains substantial active SAS/Stata programs; source-driven requirements are enumerated here.
- The full target retains the supplied SAS creation/Table 1 branches, Appendix A, Figures 1–5A/B, Tables 1–6, and online appendix Tables 1–3. Figure 2 uses constants in code; do not add a new Federal Register raw-data requirement for this supplied consumer. Hong Kong pension and cryptocurrency are listed only for completeness and have no consumer in supplied code.
- The code is embedded in a PDF, and the separate DLM Data - CPIS and Zucman preparation program is explicitly named but absent. No analysis-only scope is supported because this package contains no prepared analysis datasets.
- Source paths diverge across SAS `libname dlm`, the SAS Table 1 `libname`, and the Stata `cd`; exports to Stata data files are commented. A future configuration must bind each producer and downstream read without changing analytical formulas.
- The source Stata code uses 11 prior annual lags for Figure 5 import and net-import stocks and explicitly replaces unavailable/nonconsecutive lag 1–11 values with zero. For a fully observed 11-lag window beginning in 2006, 1995 is the earliest potential lag year; the source workbook’s actual coverage remains unknown, and missing 1995 alone is not a proven blocker. Preserve the zero-fill rule and do not fabricate earlier observations.
- The frozen dependency list has zero DIDs. Each observed source read was manually checked against the full code PDF and datasheet; the frozen dependency audit was not treated as complete coverage.
- The direct `countries_2_3` and `countrycodes` reads are separate required crosswalks. The WB population, GDP, xrate, separately reheaded wdi2015, euro, and fx_01_15 tables are separate contracts; wbdata, wbdata2015, fxcut, controls, regdata, cpisfull and zucmanfull are generated outputs/intermediates, not additional raw requirements.
- The datasheet lists Geneva Freeport statements and a presentation, but the supplied code directly imports only `swiss_data_to_import`; no direct file consumer for those financial statements or presentation was identified. Geneva Freeport is contextual, not a mandatory input.
- Active Stata add-ons are outreg2, newey2, lgraph, coefplot and eststo. Bounded checks found outreg2/newey2/lgraph unavailable in checked adopaths and coefplot/eststo available. The winsor2 invocation is commented out and is not required.
- SAS export inventory: PROC EXPORT statements for data1, cpisfull, zucmanfull, dlm_hmt15 and dlm_hmt08 are all block-commented. Active SAS creates `dlm.data1` and the separate Table 1 program uses ODS TAGSETS.EXCELXP to write `descrip.XLS`; whether that ODS component works is unverified because SAS could not start. Stata 18 accepted the old `set mem 800m` command as a no-op.
- The current Treasury and IMF/WB landing pages and field metadata were checked as candidates only. Current PIP is the renamed CPIS product; current DNB no longer compiles SFIs; current WB source fields do not resolve the author vintages, mappings or repair files. No route was claimed verified solely from a landing page or catalog miss.
- The selected full-pipeline target starts the supplied SAS code from a compatible author-prepared `dlm_full_matrices_keyvars` matrix. The raw CPIS Table 11, Netherlands SFI, OANDA FX and IMF IIP inputs are conditional contracts for the alternative missing producer, not simultaneous mandatory inputs when a compatible matrix is supplied. The main supplied SAS code still separately reads `countrycodes`, which remains mandatory. No analysis-only scope is inferred from this alternative.
