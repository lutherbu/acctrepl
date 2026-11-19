# Patch proposal: jar-e7fa1f1cdada

Disclosure versus Recognition: Inferences from Subsequent Events

DOI: 10.1111/1475-679X.12128

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Reproduce the complete author-documented workflow and results, including the main analyses and online-appendix specifications. The supplied variant contains a README, a firm-event identifier sample and an online appendix, but no executable entry point.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 1/12128 - Disclosure-versus-Recognition-Inferences-from-Subsequent-Events/michels-cusips.zip",
      "sha256": "3c8e307f7941d15aa92cee5f3a7d8587eb39f4b237f175890089b0b8318eb429"
    },
    {
      "path": "JAR-Volume 55/Issue 1/12128 - Disclosure-versus-Recognition-Inferences-from-Subsequent-Events/michels-online-appendix.pdf",
      "sha256": "5fef5ea337102f5229bb80d6888627ef394a057ac8a7747dfa944fef3a54f4ed"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6c5af1b6f2bb7e97911c10d87c9b1e6de7b02afb5c6fe5ea87197e5415ede33d",
  "work_item_sha256": "7f7f6ede38eeed4a32ab4a69738a3e12d0fae22d76d5a482ab419549347a3f89"
}
```

## Proposed actions

### action_clarify_complete_workflow: Obtain the complete author-provided workflow and data specification, including a compatible route for all analysis inputs and a map from each main and supplementary result to its producer and input data.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: req_event_sample, req_complete_analysis_inputs, issue_missing_code, issue_workflow_inputs_unknown
Evidence: ev_inventory, ev_static_audit, ev_readme_sample, ev_abnormal_return, ev_selection_sample, ev_disclosure_keywords, ev_conference_call, ev_text_probe

Preparation / proposed procedure:

1. Request the complete executable program set or an approved documented manual replacement, run instructions, required software and version details, and execution logs.
2. Request a data dictionary and end-to-end stage map specifying how the packaged CUSIP/event-date list is used, how the full subsequent-event analysis sample and disclosure/recognition measures are produced, and where each required analysis input comes from.
3. Request the compatible author-prepared analysis files or a permitted access route for return outcomes, quarterly filing dates, disclosure text or coding, loss and control variables, and earnings-call information; preserve any author-defined sample and matching decisions.
4. Request the table-to-entry-point mapping for the main analyses and all four appendix analyses, including the alternative matching specifications, selection model, disclosure-keyword tabulation, and conference-call analysis.

Validation to perform later:

- After the complete materials are obtained, inventory the data and programs, verify readable fields, identifiers, date formats and coverage, trace producer-consumer order, and confirm that each reported result maps to a documented entry point.


## Remaining issues and prerequisites

- issue_missing_code [blocking; full_pipeline]: The supplied variant contains a README, a two-variable event sample and a supplemental PDF, but no executable program, entry point or complete author-approved manual workflow.
- issue_workflow_inputs_unknown [unresolved; full_pipeline]: The appendix describes required results using abnormal returns through the next quarterly filing, matched disclosure and recognition samples, quantified and non-quantified events, loss and filing-lag measures, footnote keyword counts, and earnings-call discussion. The supplied CUSIP/event-date sample does not establish a compatible complete analysis input route; the remaining data, construction, sample coverage, software, sequencing and mapping from inputs to results are unspecified. No analysis-only route can be established without executable analysis code and compatible author-prepared analysis inputs.
- req_complete_analysis_inputs [undetermined]: Complete event-level analysis inputs beyond the CUSIP/event-date list, including subsequent-event return outcomes, filing-period information, disclosure/recognition and loss measures, controls and the inputs needed for supplementary disclosure and earnings-call analyses. The exact complete input package, schema, coverage and preparation route are not specified.

## Review notes

- The bundled CUSIP/event-date list is an author-prepared firm-event identifier sample, not a demonstrated complete analysis dataset. No analysis_only scope is created because no analysis code or compatible full analysis inputs are supplied.
- The metadata helper has no bounded reader for this plain-text format; a separate bounded plaintext metadata probe verified the header and all 423 records without establishing population coverage.
