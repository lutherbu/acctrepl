# Patch proposal: jar-6855bc192db5

Voluntary Disclosure and Information Asymmetry: Evidence from the 2005 Securities Offering Reform

DOI: 10.1111/1475-679X.12022

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

The supplied variant is a supplemental results appendix only. It provides tables and a figure but no author code, observation-level data, data description, or executable workflow for reproducing those results or the paper's analyses.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 51/Issue 5/12022 - Voluntary-Disclosure-and-Information-Asymmetry-Evidence-from-the-2005-Securities-Offering-Reform/online_appendix_v2.pdf",
      "sha256": "c476cfd108a09260772879f9a4d95b6ce33a9b19ce4f805d80ef315137ba97d4"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "a257ea088bca727f8f8088228131f6ac1f3b836552dafe971698f13dacc231ee",
  "work_item_sha256": "12b8a31fb8063b8571cd0029acfffc161eb92dd1a997b35d75b391798c59134d"
}
```

## Proposed actions

### ACTION-REQUEST-REPLICATION-MATERIALS: Request the authors' executable programs or complete documented manual/GUI run procedure, plus the observation-level analysis dataset(s) and a data description for the reported analyses. Ask for the exact stages, input files and required fields/identifiers/periods, transformations, required software/version, and mapping to the paper and Appendix Tables OA1–OA6 and Figure OA1. Clarify whether CRSP return inputs are contained in a prepared dataset or require a separately documented source route; the appendix alone does not establish compatible fields, history, or access.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: REQ-ANALYSIS-INPUTS, ISSUE-MISSING-CODE, ISSUE-MISSING-DATA, ISSUE-WORKFLOW-CLOSURE
Evidence: E-APPX-SCOPE, E-APPX-MAIN-SPECS, E-APPX-RETURNS, E-STATIC-INVENTORY

Preparation / proposed procedure:

1. Ask for the complete author workflow or approved manual/GUI reproduction steps and the analysis-ready or construction data needed for the appendix's reported analyses.
2. Request the data dictionary and precise input history, fields, identifiers, sample periods, transformations, producer-consumer order, software/version, invocation, and output mapping.
3. Ask whether CRSP firm/index returns are supplied as prepared variables or need a separate route; do not assume availability or a restricted-access barrier until the product and access conditions are specified.
4. After receiving the materials, reassess each mandatory input and workflow edge, then verify compatible data routes and output checks before any later authorized run.

Validation to perform later:

- Confirm each required input has a documented producer or verified compatible route with the needed fields and history, and that all stage ordering is explicit.
- Confirm the author procedures map to the reported paper and Appendix OA1–OA6/Figure OA1 outputs and can be compared with the reported results in a later authorized run.


## Remaining issues and prerequisites

- ISSUE-MISSING-CODE [blocking; full_pipeline]: The package contains only online_appendix_v2.pdf; it provides no executable script, project container, or complete manual run procedure. No author analysis can be attempted from this variant.
- ISSUE-MISSING-DATA [unresolved; full_pipeline]: No observation-level dataset or data description is included. The appendix supplies result tables and a figure, but its full variable definitions are deferred to the paper and no compatible data input route can be established.
- ISSUE-WORKFLOW-CLOSURE [unresolved; full_pipeline]: The authors' entry points, additional inputs and transformations, stage order, required software, and mapping to all reported results are unknown. The appendix refers to the main paper for other variable definitions and does not supply the executable workflow or input specification.
- REQ-ANALYSIS-INPUTS [undetermined]: Observation-level input data needed to reproduce the supplemental tables and figure and the paper analyses. This package contains only the results appendix; it does not identify complete input files, variables, identifiers, history, or an analysis-ready data route. The appendix identifies the CRSP value-weighted index in an abnormal-return measure but defers other variable definitions to the main paper.

## Review notes

- No analysis_only scope is established because the package contains neither author analysis code nor a dataset and documents no separate analysis route.
- The appendix contains reported supplemental results, not the inputs needed to reproduce them. Its CRSP reference is retained as a documented input clue; no access status or compatible route is inferred.
