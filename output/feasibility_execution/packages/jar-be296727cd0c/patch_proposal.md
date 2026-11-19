# Patch proposal: jar-be296727cd0c

A New Measure of Disclosure Quality: The Level of Disaggregation of Accounting Data in Annual Reports

DOI: 10.1111/1475-679X.12094

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Complete author-documented workflow for the supplied appendix-only package variant; no runnable workflow is supplied.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 53/Issue 5/12094 - A-New-Measure-of-Disclosure-Quality-The-Level-of-Disaggregation-of-Accounting-Data-in-Annual-Reports/chen-miao-shevlin-online-appendix.pdf",
      "sha256": "be991a2e163ad316412b737bb908ec4d5f1e1047dc87b8f34fc12b0bda45e505"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "d77f7ccb49c486264567568c3f64bde25baa4b90585885a43d4729de56454ec7",
  "work_item_sha256": "badcdb43949cd40eef90efce3134b3c9d6aedb0dbcc9282b8ce6692a8e3e500a"
}
```

## Proposed actions

### action_request_author_workflow: Request the complete author replication materials for this paper and package variant: runnable code and entry instructions, a datasheet describing each required input and its source/product, field definitions and sample coverage, preparation and cross-program handoffs in execution order, and a table/figure-to-script map. Do not infer source subscriptions or reconstruct the data workflow from the appendix examples.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: issue_missing_code, issue_unknown_workflow_inputs
Evidence: ev_inventory, ev_appendix_scope, ev_formula_example

Preparation / proposed procedure:

1. Obtain the author code, README/datasheet, input data descriptions, and any documented preparation instructions for the supplied paper variant.
2. Identify the intended analysis entry points, required datasets and periods, generated intermediates, and output-to-script mapping from those materials.

Validation to perform later:

- Reassess the full input and software dependency closure against the supplied workflow and document compatible acquisition or local routes before attempting execution.


## Remaining issues and prerequisites

- issue_missing_code [blocking; full_pipeline]: The assigned package contains only the online appendix PDF; it supplies no executable author program, README/datasheet, or entry point, so there is no runnable author workflow to assess.
- issue_unknown_workflow_inputs [unresolved; full_pipeline]: The appendix lists account links and illustrates a hypothetical DQ_BS formula, but the author input datasets/products, sample period, required fields, data preparation, stage order, and full results workflow are unspecified. Those appendix mnemonics and formulas are context for clarification, not independently established live raw-data requirements; data requirements and dependency closure therefore remain unknown.

## Review notes

- The frozen dependency checklist is empty. This is a document-only package variant; no analysis_only scope is supported by supplied code and compatible author-prepared analysis inputs.
- The appendix table mnemonics and hypothetical DQ_BS arithmetic are explanatory context only until the authors identify the actual workflow and data product.
