# Patch proposal: jar-152eed81a1a5

Sharing Risk with the Government: How Taxes Affect Corporate Risk Taking

DOI: 10.1111/1475-679X.12157

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | blocked |

### full_pipeline

Full documented workflow: SAS construction of annual stock-return measures and separate Stata construction of quarterly volatility, followed by the main Stata analysis for Table 2 and the documented appendix analyses. Appendix code/output mapping is not supplied, so closure remains unresolved.

Entry points: `datasheet and code/LZZ code stock return.sas`, `datasheet and code/LZZ code volatility.do`, `datasheet and code/LZZ_JAR_Code.do`, `_audit_supplements/ljungqvist-zhang-zuo-online-appendix.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 3/12157 - Sharing-Risk-with-the-Government-How-Taxes-Affect-Corporate-Risk-Taking/lzz-datasheet-and-code.zip",
      "sha256": "7e293f09bd1a1fdc3dcffc44ed86964f8af19242910e1dc26e671c42e262545f"
    },
    {
      "path": "JAR-Volume 55/Issue 3/12157 - Sharing-Risk-with-the-Government-How-Taxes-Affect-Corporate-Risk-Taking/ljungqvist-zhang-zuo-online-appendix.pdf",
      "sha256": "b9f34c900702b4594e7dad58da5e27feb500e4f7500a65fa9fca7825f4ec170d"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6c5af1b6f2bb7e97911c10d87c9b1e6de7b02afb5c6fe5ea87197e5415ede33d",
  "work_item_sha256": "4322c66f1fe0f1a8339c67d0c7ac3cd39fcbb5f9ad8a21cfb0a504c1eb964c2d"
}
```

## Proposed actions

### resolve_inputs: Resolve the exact analysis-ready inputs and configuration. Frozen metadata/probes show local raw Compustat and CRSP candidates, and local DealScan products for the appendix, but not compatible historical coverage or the author’s derived variables/files.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: compustat_annual_sas, crsp_return_sources, exchange_history, compustat_quarterly, compustat_annual_stata, company_state, compustat_start, bea_gdp_deflator, bea_state_gsp, bls_unemployment, nets_weighted_changes, missing_author_inputs, unresolved_librefs_and_paths
Evidence: src_datasheet_sources, src_sas_comp, src_sas_crsp, src_sas_exchange, src_volatility, src_main_inputs, src_main_pipeline, src_gvkey_only, catalog_candidates, probe_comp_funda, probe_comp_fundq, probe_comp_company, probe_crsp_msf, probe_crsp_linktable

Preparation / proposed procedure:

1. For each code-consumed dataset, specify exact source version, selected fields, sample/year coverage, identifiers, transformation and file path; inspect the documented local Compustat/CRSP candidate fields against that contract.
2. Confirm or provide the exchange.sas7bdat, compustat_start, NETS weighted changes, and BEA/BLS outputs with their producer/conversion steps.
3. Confirm COMP/CRSP library assignments, Stata working directories, and cross-language file handoffs.
4. Record and apply the SAS library definitions and shared working-directory/path setup assumed by the supplied scripts before opening any dataset.

Validation to perform later:

- After authorized setup, confirm each required input opens and contains the source fields and period needed by its downstream stage.

### obtain_missing_code: Obtain the two invoked author do-files and their accompanying hand-collected HQ and tax-change inputs/specifications; the source explicitly directs readers to contact an author for the HQ corrections file.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: missing_code_includes, manual_tax_changes
Evidence: src_main_inputs, src_datasheet_manual

Preparation / proposed procedure:

1. Request the exact HQ history-correction and tax-change cleaning programs, their inputs/outputs, and supported path/configuration assumptions.
2. Keep the manually collected state tax rates and loss-offset changes as the authors document them; do not reconstruct missing firm-year assignments independently.

Validation to perform later:

- Review the returned files and confirm the named producers generate the variables/files consumed by LZZ_JAR_Code.do.

### map_appendix_workflow: Obtain the author program/output map and exact data specifications for Tables A.3–A.12, including DealScan A.5, SDC M&A A.9, and CRSP/Compustat appendix analyses; preserve all documented appendix analyses in target scope.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: dealscan_covenants, sdc_acquisitions, appendix_analysis_inputs, appendix_coverage
Evidence: src_appendix_dealscan, src_appendix_sdc, src_appendix_scope, src_main_output, catalog_candidates, probe_dealscan_facility, probe_dealscan_package, probe_dealscan_financialcovenant, probe_dealscan_networthcovenant

Preparation / proposed procedure:

1. Request the supplied appendix scripts, complete stage order, and per-table data requirements, filters, joins, and variable construction.
2. Identify required access or author-prepared files for each appendix dataset and record verified routes without substituting proxy measures.

Validation to perform later:

- Confirm every documented appendix table has a supplied or author-specified reproducible script and all inputs are mapped before declaring workflow closure.

### configure_software: Resolve the SAS startup/TKELS configuration and confirm PROC EXPAND; configure the invoked outreg2 command in the intended Stata 18 adopath.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sas94, outreg2, software_configuration
Evidence: probe_environment, probe_outreg2, src_sas_expand, src_main_output

Preparation / proposed procedure:

1. Resolve the SAS startup/TKELS environment configuration or confirm the intended supported SAS installation and PROC EXPAND availability.
2. Install or configure the exact outreg2 command in a Stata adopath if it is not available in the intended execution environment.

Validation to perform later:

- Run software-only version/which checks in the intended environment before any authorized research execution.


## Remaining issues and prerequisites

- unresolved_librefs_and_paths [unresolved; full_pipeline]: SAS code defines MY and DATASETS only; COMP and CRSP librefs, shared project paths, Stata working directory, and the analysis input location are not established by supplied setup files.
- missing_author_inputs [unresolved; full_pipeline]: The archive contains code, documentation, the A.1–A.2 event tables and a gvkey identifier list, but not the prepared files consumed by the programs. Frozen catalog and same-run probes show local Compustat/CRSP/DealScan candidates; exact author-compatible history, derived datasets, exchange/NETS inputs, and public BEA/BLS output formats remain unresolved.
- missing_code_includes [blocking; full_pipeline]: Main code invokes two absent do-files: HQ history corrections (author access is requested in source comment) and tax-change cleaning/mapping based on hand-collected Table A.1 data. Their exact transformations and producer outputs are unavailable in this package.
- appendix_coverage [unresolved; full_pipeline]: The supplied main script documents Table 2 output; appendix Tables A.3–A.12 include additional specifications and DealScan, SDC, CRSP, and Compustat analyses without matching supplied program/output mapping. Full target closure cannot be confirmed.
- software_configuration [unresolved; full_pipeline]: The existing SAS runtime probe failed during TKELS startup, which does not establish version, PROC EXPAND availability or licensing; Stata 18 is available, but the dedicated probe did not find the required outreg2 command.
- compustat_annual_sas [undetermined]: Compustat annual fundamentals used by the SAS stock-return producer.
- crsp_return_sources [undetermined]: CRSP monthly returns, market index, delisting returns, name history and CCM link history consumed by the SAS stock-return producer.
- exchange_history [undetermined]: Exchange-code history joined to stock-return output.
- compustat_quarterly [undetermined]: Compustat Fundamentals Quarterly input to the separate volatility producer.
- compustat_annual_stata [undetermined]: Compustat Fundamentals Annual input to the main Stata program.
- company_state [undetermined]: Compustat company-level headquarters-state file merged by gvkey.
- compustat_start [undetermined]: Per-firm Compustat starting-year file merged by gvkey.
- bea_gdp_deflator [undetermined]: Annual GDP deflator used to create real assets and sales.
- bea_state_gsp [undetermined]: State-year real gross state product growth input.
- bls_unemployment [undetermined]: State-year unemployment-rate input.
- nets_weighted_changes [undetermined]: Author-prepared NETS weighted corporate-tax-change file merged by gvkey and datadate.
- manual_tax_changes [undetermined]: State tax-rate and loss-offset-change data, and the missing author code that maps changes to firms/years.
- dealscan_covenants [undetermined]: DealScan loan covenant data needed for Online Appendix Table A.5 covenant tightness and slack analyses.
- sdc_acquisitions [undetermined]: SDC Mergers and Acquisitions data needed for Online Appendix Table A.9 acquisition outcomes.
- appendix_analysis_inputs [undetermined]: Input and prepared-variable coverage for Online Appendix analyses beyond Table 2, including CRSP equity volatility and Compustat earnings-management variables.
- sas94 [unverified]: The supplied SAS program uses PROC EXPAND; the existing environment probe failed SAS startup at TKELS, so installed version and licensing are not established.
- outreg2 [preparation_required]: The supplied main code calls outreg2; the dedicated Stata 18 helper probe did not find the command in the checked adopath.

## Review notes

- Expanded source and bounded metadata checkpoint saved before finalization. The frozen catalog and same-run probes expose local raw Compustat, CRSP and DealScan product candidates, but do not establish author-specific history, derived files, matching, or complete coverage. Appendix Tables A.3–A.12 remain in the target; code/data mapping is unresolved. No author programs were run.
