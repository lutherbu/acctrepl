# Patch proposal: jar-5e570a601bd3

Inside the "Black Box" of Sell-Side Financial Analysts

DOI: 10.1111/1475-679X.12067

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

The assigned release is an online appendix with aggregate survey results, cross-sectional regression tables, and the survey instrument. The complete paper-wide author workflow, respondent-level inputs, and program/output map are unknown from this document-only material.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 53/Issue 1/12067 - Inside-the-Black-Box-of-Sell-Side-Financial-Analysts/brown-call-clement-sharp-online-appendix.pdf",
      "sha256": "d58bc30d9c4f2ef195f5d56a203a4eb10ce3d2db8c09da06788a0fdfdc46b74e"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "63ffd8c0353e994b71d81662a9d3d1b513b618a00a27e43c2cdc8081176d8261",
  "work_item_sha256": "ef1049f6ba5d139296fe0eeb3d006e186752cab5fd87c882e29445ec1221d6af"
}
```

## Proposed actions

### clarify_complete_author_release: Obtain the complete author replication materials and specifications before defining or attempting the full paper replication scope.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: survey_analysis_inputs_unknown, author_code_missing, full_workflow_unknown
Evidence: inv1, doc1, doc2, doc3, doc4

Preparation / proposed procedure:

1. Request the complete paper-wide author release, including programs and all entry points, README or data documentation, author-prepared respondent-level analysis data, and required software/version notes.
2. Request the authors’ mapping from each paper and appendix table/figure to its program, required inputs, generated intermediates, and execution order.
3. After receipt, inspect the author-prepared data fields, identifiers, period, transformations, and coverage against the specified analyses; do not treat the published aggregate tables or survey instrument as microdata.

Validation to perform later:

- Confirm the supplied release includes the author programs and an entry point for every documented output, or obtain an explicit author statement describing approved non-code alternatives.
- Verify every required survey-analysis input against the author documentation and assess whether it covers all appendix and paper results before assigning route and readiness outcomes.
- Only after workflow and inputs are fully specified, prepare a future authorized run plan and verify output coverage against the paper and online appendix.


## Remaining issues and prerequisites

- author_code_missing [blocking; full_pipeline]: No author program or executable workflow is supplied in this release; its assigned inventory contains only the online-appendix PDF.
- full_workflow_unknown [unresolved; full_pipeline]: The appendix contains supplementary survey results, cross-sectional analyses, and a survey instrument, but does not specify the complete paper-wide workflow, all analysis inputs, sample construction, entry points, or full output map. These requirements cannot be inferred from this document-only release.
- survey_analysis_inputs_unknown [undetermined]: Author-prepared respondent-level data and input specifications needed to reproduce the appendix cross-sectional survey analyses, plus the complete paper-wide analysis inputs; the supplied appendix reports aggregate results and does not establish a compatible input route.

## Review notes

- Assessment is limited to the assigned online-appendix PDF. It reports aggregate results and includes the survey instrument; neither supplies respondent-level analysis data or a runnable program.
- No analysis_only scope is justified: the release supplies no author analysis code or respondent-level analysis input with a supported compatible route. The paper-wide scope remains explicitly unknown.
