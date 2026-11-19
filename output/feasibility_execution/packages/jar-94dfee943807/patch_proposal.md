# Patch proposal: jar-94dfee943807

Accounting for Published Empirical Claims: Understanding and Improving Registration- Based and Traditional Editorial Processes

DOI: 10.1111/1475-679X.12208

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Complete author-documented workflow for the conference and discretion surveys, including the manual discretion-survey transformation recipe and the reported empirical analyses.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "identity_notes": [
    "Multiple original archive variants share this paper folder; each retains its own package ID."
  ],
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 2/12208 - Accounting-for-Published-Empirical-Claims-Understanding-and-Improving-Registration-Based-and-Traditional-Edito/brs-datasheet-and-file.zip",
      "sha256": "347284ee223d50b6761ea82d48356a1925cbd6741db4334dbb95186422b27aa0"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "20bff9422f9075d5b85364c27fba830f09f47143f2be3065fba8a31d90ec57e7"
}
```

## Proposed actions

### act-obtain-survey-data: Confirm and obtain the author/JAR-approved anonymized conference- and discretion-survey response inputs, with file formats, field definitions, and response coverage. Do not use identifiable retained records.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req-conference-survey, req-discretion-survey, issue-survey-inputs
Evidence: ev-datasheet-retention, ev-author-retention-discretion, ev-author-retention-conference, ev-datasheet-instrument, ev-package-inventory

Preparation / proposed procedure:

1. Ask the authors or JAR whether the anonymized response data described in the datasheet are available to the replicator and under what conditions.
2. Obtain the compatible response files and their format, field labels, survey/form mapping, and response coverage.
3. Confirm whether the Qualtrics instruments referenced in the datasheet are required to interpret or map the response fields.

Validation to perform later:

- After authorized receipt, use bounded format-aware metadata/readability checks and compare observed fields with author-supplied definitions before any execution.

### act-clarify-analysis-workflow: Obtain a complete author-specified path from survey responses through the documented preparation steps to the reported analyses; the no-program statement covers data conversion only.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue-missing-code, issue-analysis-workflow
Evidence: ev-datasheet-roles, ev-datasheet-processing, ev-datasheet-no-program, ev-discretion-recipe-a, ev-discretion-recipe-b, ev-package-inventory

Preparation / proposed procedure:

1. Request analysis entry points and prescribed software/version, or an author-approved step-by-step manual analysis description, including any companion scripts, tables, and required data files.
2. Ask the authors to map the conference and discretion survey inputs and discretion-survey transformation tabs to the analyses/results in scope.
3. The work item lists a separate local discovery candidate, jar-26fff798131a (brs-online-appendices.zip); preserve its package identity and verify its contents and compatibility separately before crediting any instrument or workflow material.

Validation to perform later:

- Review the supplied workflow and every named input/output to establish dependency closure before attempting execution.


## Remaining issues and prerequisites

- issue-survey-inputs [unresolved; full_pipeline]: The assigned variant includes no conference- or discretion-survey responses. The datasheet reports historical author/JAR custody, but this package does not establish a replicator-facing route, file format, fields, or response coverage.
- issue-missing-code [unresolved; full_pipeline]: No executable author program is supplied in this archive. The discretion-survey PDF is a manual preparation recipe, and the datasheet says no specific computer program is required for converting the raw data to the final dataset; that statement does not provide executable analysis code.
- issue-analysis-workflow [unresolved; full_pipeline]: The datasheet says the authors processed and analyzed the surveys, but supplies no analysis entry point, prescribed software/runtime, detailed statistical workflow, or mapping from the survey inputs and preparation steps to the reported analyses.
- req-conference-survey [undetermined]: Anonymized raw conference-survey response data, after removing identifying information, required for the documented conference-survey analysis. It is not in the assigned archive; response coverage and fields are not supplied.
- req-discretion-survey [undetermined]: Anonymized raw discretion-survey response data, after removing identifying information, required for the documented manual preparation and reported analysis. It is not in the assigned archive; response coverage and fields are not supplied.

## Review notes

- The assigned archive was inspected directly: it contains two PDFs and no embedded files. The Data Transformation for Discretion Survey PDF provides substantive manual preparation guidance, which is credited; it is not executable program code.
- No analysis-only scope is added: this variant has no analysis inputs or executable analysis program, and no compatible prepared-data route is verified.
- The related online-appendices archive jar-26fff798131a is a separate discovery candidate. It was not opened or credited in this single-package assessment; the datasheet mentions an online appendix generically but does not identify that archive as the data or analysis release.
