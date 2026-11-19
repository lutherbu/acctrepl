# Patch proposal: jar-239fb7148174

The Changing Landscape of Accrual Accounting

DOI: 10.1111/1475-679X.12100

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

The complete author-documented workflow for reproducing the supplemental analyses in the Internet Appendix. Only the appendix PDF is supplied, so no executable entry point or complete dependency closure can be established.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 54/Issue 1/12100 - The-Changing-Landscape-of-Accrual-Accounting/bushman-lerman-zhang-online-appendix.pdf",
      "sha256": "b9dab91415db9489619d88b476a53192c5033b2e7c50b1ffdec4e58eb577b562"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "d77f7ccb49c486264567568c3f64bde25baa4b90585885a43d4729de56454ec7",
  "work_item_sha256": "f916ed3f56b5cbfeda67bf95818c7e58363fe068fc66d8f0ebc41330ddc1d652"
}
```

## Proposed actions

### ACT_AUTHOR_PACKAGE_CLARIFICATION: Request the complete author replication workflow and a compatible input route for the appendix analyses.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: REQ_ANALYSIS_INPUTS, ISSUE_WORKFLOW_UNDOCUMENTED
Evidence: E_APPENDIX_SCOPE, E_APPENDIX_OUTPUTS, E_APPENDIX_SAMPLE30_40, E_APPENDIX_TABLE_SAMPLE, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Request the complete author-provided replication package, or an approved replacement workflow, including entry points, supporting programs, software/version requirements, execution order, and a mapping from each listed appendix figure/table to the scripts that produce it.
2. Request the author-prepared analysis inputs or a verified acquisition route, with product/file format, identifiers, required columns, covered years, sample definitions, transformations, and any access conditions. Do not treat the cited model/formula names alone as proof of separate raw-source inputs.
3. After receiving the materials, trace the actual producer-consumer order and update the dependency closure and compatible input routes from that evidence.

Validation to perform later:

- Confirm that every supplied appendix figure and table is mapped to an author entry point and that every required intermediate has a documented producer.
- Confirm the supplied input route supports the documented variables, identifiers, sample construction, and reported periods before classifying it as compatible.
- Only after a separate authorized execution, compare reproduced sample totals and appendix outputs with the author-reported periods and counts.


## Remaining issues and prerequisites

- ISSUE_WORKFLOW_UNDOCUMENTED [unresolved; full_pipeline]: The assessed package contains only a supplemental-results appendix and no README/data description, executable author code, entry points, or workflow instructions. The full dependency closure and software requirements therefore cannot be determined.
- REQ_ANALYSIS_INPUTS [undetermined]: Inputs sufficient to reproduce the appendix empirical analyses and their reported sample construction are required. The appendix describes annual firm-level analyses and reports sample periods and selected counts, but the package supplies no data or input specification; the compatible data product, identifiers, complete fields/history, transformations, and acquisition route remain undetermined. Model and formula references in this appendix do not by themselves establish separate mandatory raw-source dependencies.

## Review notes

- This is an appendix-only release with no supplied author workflow. The cited model and formula names are context for clarifying the missing workflow; they do not automatically create distinct live raw-data requirements.
- No analysis_only scope is supported because neither author code nor an author-prepared analysis-input route is supplied.
