# Patch proposal: jar-df873778fc00

Political Incentives to Suppress Negative Information: Evidence from Chinese Listed Firms

DOI: 10.1111/1475-679X.12071

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Complete author-documented workflow for the assigned package; the supplied online appendix reports empirical tables and sensitivity analyses, but no runnable program or analysis dataset is supplied.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 53/Issue 2/12071 - Political-Incentives-to-Suppress-Negative-Information-Evidence-from-Chinese-Listed-Firms/piotroskiwongzhang-online-appendix.pdf",
      "sha256": "27b23beafcc71ebd420777fab7463b9b957a746c0f6c69470519acda9f54c312"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "63ffd8c0353e994b71d81662a9d3d1b513b618a00a27e43c2cdc8081176d8261",
  "work_item_sha256": "6bcd285205e84d8f3dc19fa2f2483cf14eb4993881f95d133f4e26adebe2c36a"
}
```

## Proposed actions

### action_request_author_programs_and_inputs: Obtain the executable author workflow and compatible analysis-input specification for the appendix analyses.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: req_appendix_analysis_data, issue_missing_author_code, issue_unresolved_analysis_workflow
Evidence: ev_package_inventory, ev_table4a_design, ev_undefined_variables, ev_table11a

Preparation / proposed procedure:

1. Request the runnable author programs and instructions for this package variant, including each entry point, required runtime/software, stated alternative branches, and the order in which programs produce and consume intermediate files.
2. Request the complete author-provided input inventory and specifications: exact prepared analysis files or products, formats, field names, identifiers, historical periods, constructions, and any author-supported acquisition routes. Ask for the Table 1 and Appendix A variable definitions cited by the appendix if these form part of the author instructions.
3. Retain all appendix analyses and stated variants in the assessed target; do not infer code, inputs, or a data-construction workflow from the reported coefficients.

Validation to perform later:

- After receiving the materials, trace the workflow and map all appendix outputs (Tables 4A–4I, 8A, 11A, and A–F) to their actual generating entry points, supporting stages, branches, and inputs.
- Review the full dependency closure and producer-consumer order; verify fields, identifiers, and required periods against bounded metadata for each author-supplied or author-identified compatible input before any separately authorized execution.


## Remaining issues and prerequisites

- issue_missing_author_code [blocking; full_pipeline]: The assigned package contains only the online appendix PDF; no executable author program or run instructions are supplied.
- issue_unresolved_analysis_workflow [unresolved; full_pipeline]: The appendix reports a broad set of alternative and supplementary analyses but supplies no executable workflow, data description, or dependency order. It refers readers to Table 1 and Appendix A for other variable definitions, which are not included in the assigned package; required analysis inputs and their compatibility therefore remain unspecified.
- req_appendix_analysis_data [undetermined]: The appendix's empirical tables require analysis data, but no data file or compatible author-prepared analysis-data route is supplied or specified. The package does not identify the exact input files/products, fields, identifiers, period coverage, or construction needed to reproduce the reported analyses.

## Review notes

- No analysis_only scope is supported: the assigned package has no author-prepared dataset or executable analysis entry point from which a bypass and its compatible inputs can be verified.
