# Patch proposal: jar-191bca7fd8fe

Uninvited U.S. Investors? Economic Consequences of Involuntary Cross-listings

DOI: 10.1111/1475-679X.12035

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Complete author-documented workflow

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 52/Issue 2/12035 - Uninvited-U-S-Investors-Economic-Consequences-of-Involuntary-Cross-listings/illiev-miller-roth-online-appendix-10-25-13.pdf",
      "sha256": "f4558e569bcc9417cb5518f4ea4aec59bd952c94aeee4bdb6f78398945700b2f"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "a257ea088bca727f8f8088228131f6ac1f3b836552dafe971698f13dacc231ee",
  "work_item_sha256": "926ed2c2222f80b65d109cb57242bf22ba89a2f331c1c7d479c4bb2c55490d77"
}
```

## Proposed actions

### ACT-REQUEST-AUTHOR-WORKFLOW: Obtain the complete author replication release or an author-approved written substitute for the missing programs and workflow, then trace all stages and dependencies.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: ISSUE-NO-AUTHOR-CODE, ISSUE-INCOMPLETE-CLOSURE
Evidence: EV-PACKAGE-INVENTORY, EV-APPENDIX-IDENTITY

Preparation / proposed procedure:

1. Request the author README/run instructions, entry and supporting programs or project files, required software/runtime configuration, and an explicit stage order covering the full article and appendix analyses.
2. After author materials are supplied, trace every required input, generated intermediate, cross-language handoff, and author-defined alternative branch; do not infer producers or acquisition steps from filenames or the appendix alone.

Validation to perform later:

- Confirm the supplied workflow covers the main paper results and all four appendix sections, including required robustness variants.
- Confirm every mandatory dependency has an identified producer or a supported acquisition route, with all intermediate consumers ordered after their producers; retain unresolved branches as explicit issues.

### ACT-CLARIFY-ANALYSIS-INPUTS: Clarify which author inputs implement the paper and appendix analyses, including actual released data and their field, history, and construction specifications.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: REQ-AUTHOR-ANALYSIS-INPUTS
Evidence: EV-PACKAGE-INVENTORY, EV-OUTLIER-CHECKS, EV-MOMENTUM-CHECK, EV-ASIF-CHECK, EV-JPM-CHECK, EV-APPENDIX-SOURCES

Preparation / proposed procedure:

1. Ask the authors to identify and provide the data inputs used by their programs, or their author-prepared analysis datasets if that is the released workflow, with exact filenames, product/version, formats, source columns, identifiers/merge keys, covered periods, sample restrictions, and transformations.
2. Use the appendix’s stated valuation measures and source families only to resolve the author workflow; do not treat the names of Worldscope, Datastream, CRSP, depositary-receipt lists, or SEC filings as verified current routes or infer a license barrier.

Validation to perform later:

- When the code and files are available, use bounded format-aware metadata probes and compare actual source fields, IDs, periods, and sample coverage against the author code before marking any route verified.
- Keep unknown source access, product history, data construction, missing fields, and baseline-paper requirements unresolved until supported by author or authoritative route evidence.


## Remaining issues and prerequisites

- ISSUE-NO-AUTHOR-CODE [blocking; full_pipeline]: The assigned package contains only an online-appendix PDF. It has no runnable author program or entry point for the appendix or the full article workflow.
- ISSUE-INCOMPLETE-CLOSURE [unresolved; full_pipeline]: The document gives selected robustness-test descriptions and some data-source names, but no README, scripts, analysis data, software instructions, or producer-consumer sequence. It cannot establish full-paper inputs, exact source fields/coverage, data construction, acquisition/access conditions, required software, or all branches. Dependency closure remains unresolved.
- REQ-AUTHOR-ANALYSIS-INPUTS [undetermined]: Author-specified analysis inputs and complete construction workflow for the paper’s reported results and the supplied appendix. The appendix describes outlier-removal and matching checks, momentum-adjusted propensity matching, an “as-if” valuation analysis, and a J.P. Morgan case. It names some input source families for its valuation tables (depositary-receipt lists, CRSP files, SEC Form F-6 filings, Worldscope, and Datastream), but no data or programs are included. The package does not identify the exact author-distributed files, product/version, source fields, identifiers, complete historical coverage, construction, or full-paper stages. The named sources are not verified acquisition routes and do not establish an access barrier. Obtain author inputs/specifications; do not independently reconstruct historical sources.

## Review notes

- This is a document-only appendix variant; reported table values and descriptions do not supply usable analysis datasets or runnable code. No analysis-only scope is supported. The appendix’s cited data-source names were retained as discovery context, not treated as verified acquisition routes or license barriers.
