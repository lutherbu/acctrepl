# Patch proposal: jar-26fff798131a

Accounting for Published Empirical Claims: Understanding and Improving Registration- Based and Traditional Editorial Processes

DOI: 10.1111/1475-679X.12208

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

The complete author-documented survey collection and analysis workflow for the paper. This variant documents Qualtrics survey administration and removal of identifying email data before analysis, and supplies free-response appendices, but does not identify the full quantitative analysis inputs or an analysis workflow.

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
      "path": "JAR-Volume 56/Issue 2/12208 - Accounting-for-Published-Empirical-Claims-Understanding-and-Improving-Registration-Based-and-Traditional-Edito/brs-online-appendices.zip",
      "sha256": "3e979d14a31305068c4843fd735c19f6e93e59860cf3648652377c9ba4eb65c0"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "0d3e28ec54c05aba547755a2f601d01ce2ab3bc4b61bd0c19dfa31b05b845bb9"
}
```

## Proposed actions

### act_clarify_workflow_and_inputs: Request the author’s complete article-to-artifact workflow for this survey study, including the exact participant-level response/derived-data files used for each reported table and figure and the preparation/analysis steps that produce them. In particular, ask which Discretion Survey frequency and extent ratings across the six instrument domains are analyzed and where their values and any coded fields reside; the supplied Excel workbooks expose only participant descriptors and free-response prompts. Ask whether the supplied free-response workbooks are supplemental qualitative materials or inputs to any reported results, and provide the missing quantitative responses, codebook/mapping, analysis code or precise manual/GUI recipe, required software, and run order as applicable. Preserve the existing free-response workbooks and survey instruments as supplied materials.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: req_analysis_responses, issue_missing_workflow, issue_quantitative_inputs
Evidence: ev_archive_review, ev_discretion_instrument, ev_discretion_scale_items, ev_discretion_itemareas, ev_discretion_scale_domains_more, ev_discretion_samples_domain, ev_discretion_hypothesis_domain, ev_discretion_prediction_domain, ev_survey_platform, ev_anonymization_workflow, ev_conference_appendix, ev_discretion_appendix, ev_conference_workbook, ev_discretion_workbook, ev_discretion_frequency_scale

Preparation / proposed procedure:

1. Ask the authors to identify every reported table/figure and trace its required response fields, input files, preparation stages, and analysis output.
2. For the Discretion Survey, identify which participant-level frequency/extent ratings and other structured fields are used by each result, and provide the corresponding complete response data and codebook or export mapping.
3. Clarify whether the supplied free-response workbooks are supplemental qualitative material or inputs to any reported outputs; retain them as supplied data either way.
4. Request executable analysis/preparation code or a complete manual/GUI recipe with the actual software, any data-handling steps, and execution order.
5. After clarification, review the exact listed inputs and workflow for readability, field compatibility, and complete coverage before attempting reproduction.

Validation to perform later:

- Confirm each reported table/figure maps to a supplied or explicitly obtainable input and a documented preparation/analysis step.
- Use the author-specified future run procedure to reproduce and compare the reported outputs; execution is not verified by this static assessment.


## Remaining issues and prerequisites

- issue_missing_workflow [blocking; full_pipeline]: The archive contains Qualtrics survey instruments and actual free-response materials. The instruments document respondent-facing collection and state that identifying email information is deleted before analysis, but the release supplies no executable analysis/preparation program, README/datasheet, table-to-file map, numeric response/coding workflow, software instructions, or manual recipe linking the response materials to the reported outputs.
- issue_quantitative_inputs [unresolved; full_pipeline]: The Discretion Survey Instrument asks closed-ended frequency ratings and extent ratings across six forms of discretion: selecting measures/analyses to report, excluding observations, collecting additional observations, omitting samples/subsamples, omitting hypotheses, and changing predictions/theory. The two supplied workbooks instead expose participant/role or method/rank descriptors and free-response prompt columns; no corresponding rating-value columns are present in the probed headers. No separate complete numeric response file or author mapping is included in this archive, so the exact required scale fields, analytic subset, and table linkage need author confirmation.
- req_analysis_responses [undetermined]: The complete author-prepared survey responses and any coded/derived variables used by the paper’s analyses and reported tables/figures. Specifically, the Discretion Survey Instrument includes participant-level frequency ratings and extent ratings (e.g., informative/overstated, and focused/accurate/overstated) across discretion over reported measures/analyses, excluded observations, added observations, omitted samples/subsamples, omitted hypotheses, and revised predictions/theory. The supplied Excel headers expose participant descriptors and free-response prompts, not these rating values. Which scale responses feed the paper’s outputs and what further fields are required remain unresolved.

## Review notes

- This is the jar-26fff798131a online-appendices/free-response archive. It remains a separate package unit from jar-94dfee943807; the related-inventory precheck was reused only after matching the exact archive SHA and both exact workbook member hashes, with package identity preserved in the inspection artifact.
- The release contains two survey instruments, two free-response appendix PDFs, and two corresponding Excel free-response workbooks. These are genuine survey data/instruments and must be credited; bounded workbook probes establish header/readability only and do not establish full-row or population coverage.
- The printed Qualtrics instruments document survey administration and pre-analysis deletion of identifying email data. This is respondent/collection handling context, not an analysis code path. The Discretion instrument also contains repeated closed-ended rating items; the provided workbook headers expose only participant descriptors and free-response prompts, so the numerical response values and their reported-table mapping are a specific unresolved input gap.
- The supplied member content has no executable analysis program or manual analysis recipe. There is no analysis_only scope because this variant supplies neither analysis code nor a verified compatible author-prepared analysis-data route.
