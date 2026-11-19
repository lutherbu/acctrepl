# Patch proposal: jar-68d4a7531569

Are Trade Size Based Inferences About Traders Reliable? Evidence from Institutional Earnings-Related Trading

DOI: 10.1111/1475-679X.12056

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
      "path": "JAR-Volume 52/Issue 4/12056 - Are-Trade-Size-Based-Inferences-About-Traders-Reliable-Evidence-from-Institutional-Earnings-Related-Trading/cready-appendix.pdf",
      "sha256": "88c080485bbbb04687b55a451d1d771edb28f7e15641e6676fd50b345618dc2d"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "a257ea088bca727f8f8088228131f6ac1f3b836552dafe971698f13dacc231ee",
  "work_item_sha256": "03d88122e2b82fca8d3a96affcfa9020cefb91be53ec6937c6b9f10c1b1d3836"
}
```

## Proposed actions

### ACT-REQUEST-AUTHOR-WORKFLOW: Obtain the complete author replication release or an author-approved written substitute for the missing executable workflow, then trace all stages and dependencies.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: ISSUE-NO-AUTHOR-CODE, ISSUE-INCOMPLETE-CLOSURE
Evidence: EV-PACKAGE-INVENTORY, EV-APPENDIX-SCOPE

Preparation / proposed procedure:

1. Request author run instructions, entry and supporting programs/project files, complete author analysis inputs or data-construction specification, and required software/runtime configuration for the main paper and appendix.
2. After author materials are supplied, trace all mandatory inputs, generated intermediates, cross-language handoffs, and author-defined alternatives; do not infer producers or acquisition steps from appendix tables.

Validation to perform later:

- Confirm the supplied author workflow covers the paper results and the appendix tables, including the restricted 2003–2005 analyses and supplemental Tables 10–11.
- Confirm each mandatory dependency has an identified producer or supported acquisition route and consumers follow producers; preserve all unresolved branches as issues.

### ACT-CLARIFY-ANALYSIS-INPUTS: Ask which author inputs supply the paper and appendix analysis measures and obtain their exact data and construction specifications.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: REQ-AUTHOR-ANALYSIS-INPUTS
Evidence: EV-PACKAGE-INVENTORY, EV-APPENDIX-PERIODS, EV-TRADE-MEASURES, EV-IBES-INPUTS, EV-ANCERNO-SAMPLE

Preparation / proposed procedure:

1. Request the author-provided input files or author-prepared analysis data used by their workflow, with exact filenames, product/version, format, source columns, identifiers/merge keys, full periods, sample coverage, and transformations.
2. Clarify how the authors construct transaction/order/position-change measures, earnings-announcement inputs, analyst forecasts, and the samples underlying the appendix tables. Treat source names as context only, not as verified routes or evidence of a license barrier.

Validation to perform later:

- When author code and files are available, use bounded metadata probes and compare actual source columns, identifiers, sample periods, and coverage against the code before marking any route verified.
- Keep source access, history, construction, and the full-paper input requirements unresolved until supported by author or authoritative route evidence.


## Remaining issues and prerequisites

- ISSUE-NO-AUTHOR-CODE [blocking; full_pipeline]: The assigned author package contains only an appendix PDF with published tables and descriptions. It contains no runnable author program or entry point for the appendix or the full article workflow.
- ISSUE-INCOMPLETE-CLOSURE [unresolved; full_pipeline]: The appendix identifies selected sample periods, measures, and data references but no README, executable stages, author data files, prescribed software, producer-consumer sequence, or full-paper workflow. Required products/fields/coverage and data construction, access routes, and any alternative branches remain unresolved.
- REQ-AUTHOR-ANALYSIS-INPUTS [undetermined]: Author-specified analysis inputs and complete executable workflow for the paper and supplied appendix. The appendix contains published tables: Tables 3A–9A parallel paper tables for a 2003–2005 sample, and Tables 10–11 add analysis involving announcement-period order imbalance and post-earnings-announcement drift. It describes transactions, orders, position changes, earnings-announcement measures, IBES forecasts, and an Ancerno sample, but the assigned package supplies no underlying analysis data or program. Exact author input files/products, fields, identifiers, full historical coverage, transformations, and the complete main-paper workflow remain unknown. The named sources are not verified acquisition routes and do not establish an access barrier. Obtain the author inputs and specifications; do not independently reconstruct historical sources.

## Review notes

- The appendix supplies reported tables and definitions, not usable author analysis data or executable code. No analysis-only scope is supported. The document’s mentions of IBES and Ancerno do not establish a current data route or access barrier.
