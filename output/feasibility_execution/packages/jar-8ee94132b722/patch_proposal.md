# Patch proposal: jar-8ee94132b722

Short Selling Pressure, Stock Price Behavior, and Management Forecast Precision: Evidence from a Natural Experiment

DOI: 10.1111/1475-679X.12068

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

The assigned release is an online appendix reporting Tables OA1–OA14 for a Reg SHO natural experiment, including multiple forecast-news measures and an alternative event window. The complete paper-wide author workflow, inputs, and output-to-code map are unknown from this document-only material.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 53/Issue 1/12068 - Short-Selling-Pressure-Stock-Price-Behavior-and-Management-Forecast-Precision-Evidence-from-a-Natural-Experime/li-zhang-online-appendix.pdf",
      "sha256": "7271c1d6ed7a4196fa45ac15ec2c03780300705a46adaabafe3e1fc916b320ec"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "63ffd8c0353e994b71d81662a9d3d1b513b618a00a27e43c2cdc8081176d8261",
  "work_item_sha256": "0d4b8b7c2852d406c8258a0d2136b33eaae34a579f76d0ce25e23b32489e5b40"
}
```

## Proposed actions

### clarify_complete_author_release: Obtain the complete author replication materials and workflow specifications before defining or attempting the full paper replication scope.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: analysis_panel_inputs_unknown, author_code_missing, full_workflow_unknown
Evidence: inv1, doc1, doc2, doc3, doc4

Preparation / proposed procedure:

1. Request the complete paper-wide author release, including programs and all entry points, README or data documentation, author-prepared analysis inputs, and required software/version notes.
2. Request the authors’ mapping from every paper and appendix table/figure to its program, inputs, generated intermediates, and execution order, covering Tables OA1–OA14 and all reported branches.
3. Clarify how the required panel and both forecast-news measures are supplied or constructed, and how the alternate event window and IBES-based consensus branch fit the author workflow; do not infer historical raw-source dependencies from the appendix alone.
4. After receipt, verify the prepared data fields, identifiers, event-quarter period, forecast-news variants, and coverage against author instructions before assigning routes.

Validation to perform later:

- Confirm the supplied release includes author programs and entry points for every documented paper and appendix output, or obtain an explicit author statement describing approved non-code alternatives.
- Verify that author-prepared inputs cover the documented 34,096 firm-quarter sample and the required forecast-news variants and alternative-event-window outputs without assuming the summary tables are analysis data.
- Only after workflow and inputs are fully specified, prepare a future authorized run plan and verify output coverage against the paper and online appendix.


## Remaining issues and prerequisites

- author_code_missing [blocking; full_pipeline]: No author program or executable workflow is supplied in this release; the assigned inventory contains only the online-appendix PDF.
- full_workflow_unknown [unresolved; full_pipeline]: The appendix reports additional analyses and robustness checks, but does not specify the complete paper-wide workflow, all analysis inputs and construction, entry points, or code supporting Tables OA1–OA14. Paper-wide requirements cannot be inferred from this document-only release.
- analysis_panel_inputs_unknown [undetermined]: Author-prepared analysis inputs and specifications for the appendix Reg SHO analyses, including the reported 34,096 firm-quarter full sample in event window [-8,+7], plus the complete paper-wide analysis inputs. The appendix does not provide a compatible analysis-data route or full input/variable construction specification.

## Review notes

- Assessment is limited to the assigned online-appendix PDF. Its contents enumerate OA1–OA14, report results using traditional and Rogers–Van Buskirk forecast-news measures, describe an IBES detailed-file analysis, and include an alternative event window. These reported branches are retained in the requested author workflow mapping.
- No analysis_only scope is justified: this release supplies no author analysis code or underlying author-prepared analysis data with a supported compatible route. The complete paper-wide workflow remains explicitly unknown.
