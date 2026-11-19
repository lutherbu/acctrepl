# Patch proposal: jar-be539d420010

Why Do Countries Mandate Accrual Accounting for Tax Purposes?

DOI: 10.1111/1475-679X.12061

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Produce the full online appendix analyses, including alternative estimators, the Norway-inclusive sample, and the country-by-country sensitivity figures. The supplied appendix reports these outputs but does not specify their executable workflow or complete input lineage.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 52/Issue 5/12061 - Why-Do-Countries-Mandate-Accrual-Accounting-for-Tax-Purposes/jacob-appendix.pdf",
      "sha256": "c1c43f6a5ecbe5570a40ad0591a8999dab6955d7d534b970649d245a523f2142"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "63ffd8c0353e994b71d81662a9d3d1b513b618a00a27e43c2cdc8081176d8261",
  "work_item_sha256": "fc573ac5a6f0bed2c04977655facfa0bc54e8389863b57d07d2f1edbc09276d6"
}
```

## Proposed actions

### request_workflow: Request the author materials needed to regenerate the complete supplied online appendix; do not reconstruct the historical country panel or other source data independently.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: analysis_inputs, missing_code
Evidence: doc_results, package_inventory

Preparation / proposed procedure:

1. Obtain the author-provided executable workflow or an explicitly approved alternative, including its entry point, required run order, and runtime/software requirements for all reported appendix tables and figures.
2. Obtain the compatible author-prepared analysis data, or a complete input inventory and documented acquisition/build instructions that identify required files, fields, identifiers, periods, formats, and generated intermediates.
3. Confirm that the workflow covers the alternative-estimator analyses, the Norway-inclusive tables, and all country-exclusion figures described in the appendix.

Validation to perform later:

- After the materials are supplied, trace every appendix output to its documented producer and verify that all required input files, fields, and sample periods are covered.
- Run and compare all reported appendix tables and figures only under a separately authorized execution step.


## Remaining issues and prerequisites

- missing_code [unresolved; full_pipeline]: The assigned package contains only an online appendix document: no author program, entry point, run instructions, or producer map is supplied. The required input products and full workflow dependency closure therefore remain unknown.
- analysis_inputs [undetermined]: Author-provided analysis data and any upstream inputs needed to reproduce all appendix tables and figures are required; the supplied appendix describes a 26-country sample, a 27-country Norway-inclusive variant, alternative estimators, and country-exclusion analyses, but gives no compatible file list, schema, coverage specification, or build workflow.

## Review notes

- No analysis_only scope is supported because the assigned package supplies neither runnable analysis code nor author-prepared analysis data.
