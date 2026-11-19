# Patch proposal: jar-76b61760c0c9

Real Activity Forecasts Using Loan Portfolio Information

DOI: 10.1111/1475-679X.12110

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

The complete supplemental empirical workflow described in the assigned internet appendix: capital-incentive analysis (Table 1A), annual GSP forecasting (Table 2A), single-state-bank robustness (Table 3A), additional economic-condition specifications (Table 4A), and state-recession forecasts (Table 5A). The appendix has no executable code or data.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 54/Issue 3/12110 - Real-Activity-Forecasts-Using-Loan-Portfolio-Information/khan-ozel-internet-appendix.pdf",
      "sha256": "cf20c037931fbc925f0e7b4cac7ae0b65d61e15007e2e922e09f80bc6a414eaa"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "d77f7ccb49c486264567568c3f64bde25baa4b90585885a43d4729de56454ec7",
  "work_item_sha256": "11a3850ce3b4f9bbe1f99c34a197c32e8fb6126247e335c62c9316607a46c789"
}
```

## Proposed actions

### action_request_author_replication_materials: Request the authors’ analysis programs for Tables 1A–5A or an approved executable replacement, together with the main-paper Appendix A variable definitions and an input/output manifest. Ask whether a compatible author-prepared analysis dataset exists; if it does, request its exact files, fields, identifiers, historical coverage, and preparation provenance. Do not independently reconstruct the research or turn every data source named in the supplement into a separate required input.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: issue_appendix_programs_missing, issue_analysis_input_contract, req_appendix_analysis_inputs
Evidence: ev_inventory, ev_table1a, ev_gsp_analysis, ev_single_state, ev_additional_specs, ev_variable_defs

Preparation / proposed procedure:

1. Obtain the author-supplied code or an explicitly approved non-code workflow for each supplemental table.
2. Obtain the main paper’s variable definitions and a table-to-entry-point/data manifest, including exact inputs and generated intermediates.
3. Confirm whether any author-prepared analysis dataset is available and whether it bypasses raw-data construction without undocumented reconstruction.

Validation to perform later:

- Map every table, 1A through 5A, to its author-supported entry point and required dataset/intermediate.
- Verify any returned dataset’s exact fields, identifiers, coverage, units, and transformations against the author manifest before treating it as a compatible route.

### action_conditional_appendix_run: No run command can be specified for the current PDF-only variant. After the author supplies programs and compatible data, follow the documented supplementary branches for capital-ratio splits, annual GSP growth, single-state banks, additional economic-condition specifications, and state recessions; determine actual producer-consumer order from the supplied code.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: issue_appendix_programs_missing, issue_analysis_input_contract
Evidence: ev_inventory, ev_capital_test, ev_gsp_analysis, ev_single_state, ev_additional_specs

Preparation / proposed procedure:

1. Use only author-provided entry points and input files after confirming their manifest.
2. Establish output producer and consumer order for all five appendix tables from the supplied programs; do not infer it from table order.
3. Retain execution logs and map generated tables to the five reported appendix outputs.

Validation to perform later:

- Confirm every intermediate has a documented producer and every table output has a supplied author-supported entry point.
- Review logs and output presence; this assessment does not verify numerical reproduction.


## Remaining issues and prerequisites

- issue_appendix_programs_missing [blocking; full_pipeline]: The supplied variant reports five supplementary empirical regression outputs (Tables 1A–5A) but contains no author analysis or data-preparation program and no runnable entry point. The appendix is results documentation only.
- issue_analysis_input_contract [unresolved; full_pipeline]: The appendix describes the supplemental estimands and some transformations but does not provide the main paper’s variable definitions, source-to-variable mapping, analysis-data filenames, population/history, or the code and producer order for the five tables. The appendix’s references to BEA, call-report capital, deposits, and other study variables are contextual leads only; they do not establish separate live raw-source requirements. No analysis-only bypass is supported because no compatible dataset or analysis entry point is supplied.
- req_appendix_analysis_inputs [undetermined]: Author-compatible analysis data or the author-specified source inputs needed to regenerate supplemental regression Tables 1A–5A. These results require empirical observations, but the assigned appendix contains no dataset or input manifest and defers many variable definitions to the absent main-paper Appendix A. Exact file products, fields, history, identifiers, and preparation steps are therefore unresolved.

## Review notes

- This is an appendix-only empirical-results release, not a code or data release. The five supplemental regression tables establish that data are needed to rerun these analyses.
- No analysis_only scope is justified because no author-prepared analysis data, analysis code, or compatible route is supplied.
- The appendix defers variable definitions to the main paper. Source/data terms and formulas within this results appendix remain context until author materials establish exact live inputs.
- The frozen dependency checklist is empty; no dependency IDs are omitted from dependency_review. Producer-consumer order cannot be established without author code.
- No code was run, data were loaded, packages installed, or external sources checked.
