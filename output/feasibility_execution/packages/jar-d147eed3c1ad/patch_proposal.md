# Patch proposal: jar-d147eed3c1ad

Imperfect Accounting and Reporting Bias

DOI: 10.1111/1475-679X.12170

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Reproduce the supplemental empirical analyses reported in Tables OA1–OA13 and their Table OA14 variable definitions, including their documented dependencies on the main paper.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 4/12170 - Imperfect-Accounting-and-Reporting-Bias/fang-internet-appendix.pdf",
      "sha256": "490495b64c229d28acc923e46580a4c8a51bc99e8caff18914ea126839cf4d22"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b339a0e3a03207a70703666926608174d29bcbef458afd4e10be2da7d4ad8255",
  "work_item_sha256": "6a4bfc3d4e0df927751f2572e2fc72ba6eb7d4256764fb48aa04166deddb8400"
}
```

## Proposed actions

### ACT-clarify-release: Obtain the complete author-supplied reproducibility workflow for the supplemental analyses before attempting reproduction.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: REQ-analysis-inputs, ISS-missing-code, ISS-workflow-unknown
Evidence: EV-appendix-scope, EV-main-paper-dependencies, EV-variable-definitions, EV-package-inventory

Preparation / proposed procedure:

1. Request the executable programs or, if the authors used a manual/GUI process, its complete documented procedure and software/runtime requirements.
2. Request author-prepared analysis data or a complete input inventory and construction workflow, including exact products, fields, identifiers, sample history and transformations; do not infer separate live raw-source requirements from variable names or formulas in the appendix.
3. Request the main paper material needed to define the controls and variables referenced in Tables OA1–OA13, including the cited Table 2/Table 7 specifications and Appendix B definitions, plus the producer-consumer order and mapping from each appendix table to its supporting program/data.
4. If supplied author-prepared analysis data are intended to support an analysis-only route, obtain the exact file list, format, field specification, coverage and required entry points before assessing that scope.

Validation to perform later:

- After receipt, map every target table OA1–OA13 to its entry/supporting program and required inputs, and verify the complete producer-consumer order.
- Inspect supplied data using bounded format-aware metadata/readability checks and compare the documented identifiers, fields, period and construction to the target analyses.
- Check the documented software and manual steps, then record a future run procedure; no execution is claimed by this assessment.


## Remaining issues and prerequisites

- ISS-missing-code [blocking; full_pipeline]: The assigned release contains an online appendix with reported tables and prose definitions, but no supplied executable program or documented manual/GUI replacement procedure. The package inventory lists only the appendix PDF; the appendix describes results rather than an executable workflow.
- ISS-workflow-unknown [unresolved; full_pipeline]: The complete workflow, required inputs and transformations, software/runtime, table-to-program mapping, and producer-consumer order are not documented in this release. The appendix points to controls and variable definitions in the main paper but does not provide the corresponding workflow or input specifications.
- REQ-analysis-inputs [undetermined]: Empirical input data and any inputs required to construct analysis data for Tables OA1–OA13 are required, but this PDF release does not identify a complete compatible input set, preparation workflow, or analysis-ready data artifact. Exact input products, fields, identifiers, history, coverage, and transformations remain unknown.

## Review notes

- This assessment covers the assigned PDF-only package variant. Its formulas and data-source names are contextual clarification leads, not independent mandatory raw-data requirements.
- No analysis_only scope is supported: the release provides neither executable analysis code nor a verified route to compatible author-prepared analysis data.
- The empirical reproduction target requires data even though this release identifies no concrete compatible input route; data_required is therefore true and the input requirement remains undetermined.
