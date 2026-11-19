# Patch proposal: jar-cbc782a5edd2

Do Declines in Bank Health Affect Borrowers' Voluntary Disclosures? Evidence from International Propagation Of Banking Shocks

DOI: 10.1111/1475-679X.12034

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
      "path": "JAR-Volume 52/Issue 2/12034 - Do-Declines-in-Bank-Health-Affect-Borrowers-Voluntary-Disclosures-Evidence-from-International-Propagation-Of-B/lo-internet-appendix2013.pdf",
      "sha256": "beb14801ffc5ae1da7fa61a16173d3d66f65ffafc955ecc74fe9cf346a51cc6b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "a257ea088bca727f8f8088228131f6ac1f3b836552dafe971698f13dacc231ee",
  "work_item_sha256": "fcfd174e7d718350dacbbf5857d2393341d96fe8e36584488db318d56a8c8734"
}
```

## Proposed actions

### ACT-REQUEST-AUTHOR-WORKFLOW: Obtain the complete author replication release or an author-approved written substitute for the missing executable workflow, then trace its full dependency closure.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: ISSUE-NO-AUTHOR-CODE, ISSUE-INCOMPLETE-CLOSURE
Evidence: EV-PACKAGE-INVENTORY, EV-APPENDIX-SCOPE

Preparation / proposed procedure:

1. Request the author README or run instructions, entry scripts, supporting source/project files, exact data inputs or their author-prepared replacements, and required software/runtime configuration for all reported main analyses and appendix checks.
2. After the author materials are supplied, inventory entry points and supporting stages; trace every required input and producer-consumer handoff across languages and project containers, preserving any author-defined alternatives.

Validation to perform later:

- Confirm the supplied author workflow identifies and covers the reported main results and all five appendix robustness checks.
- Confirm each required dependency has an identified producer or supported acquisition route and all generated intermediates are consumed only after production; leave remaining branches as explicit unresolved issues.

### ACT-CLARIFY-ANALYSIS-INPUTS: Clarify the actual author input files and construction needed for the paper and appendix; do not infer a historical-source collection plan from the appendix alone.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: REQ-AUTHOR-ANALYSIS-INPUTS
Evidence: EV-PACKAGE-INVENTORY, EV-APPENDIX-MATCH, EV-APPENDIX-FOREIGN, EV-APPENDIX-CIG, EV-APPENDIX-PERIODS

Preparation / proposed procedure:

1. Ask the authors to identify and provide the analysis inputs used by their code, or their author-prepared analysis data if that is the released workflow, including exact file names, format, source columns, IDs/merge keys, periods and transformations.
2. Use the appendix descriptions to resolve which supplied measures or sample restrictions implement bank exposure and borrower forecasts, market-value/ROA matching, foreign-sales screening, analyst coverage, and the three non-crisis windows.

Validation to perform later:

- Once the workflow and inputs are provided, inspect files with bounded metadata probes and compare actual source columns, identifiers and covered periods with the author code before marking a route verified.
- Retain any undocumented input history, field mapping, sample construction or workflow branch as unresolved until author evidence supports it.


## Remaining issues and prerequisites

- ISSUE-NO-AUTHOR-CODE [blocking; full_pipeline]: The assigned package contains a single internet-appendix PDF and no runnable author program or entry point. It describes robustness analyses but cannot establish or execute the complete paper workflow.
- ISSUE-INCOMPLETE-CLOSURE [unresolved; full_pipeline]: With no author code, README, or analysis data in this document-only package, required input products, source fields, acquisition/construction steps, software, producer-consumer order, and any alternative branches cannot be traced. The appendix supplies selected robustness descriptions only; full dependency closure is unresolved.
- REQ-AUTHOR-ANALYSIS-INPUTS [undetermined]: Author-prepared analysis inputs and their construction for the paper’s reported results, including the five robustness checks described in the supplied internet appendix. The appendix refers to borrower forecasts and bank exposure, market value and ROA for matching, foreign sales, analyst following, and non-crisis periods, but this package does not identify the required files, source columns, formats, complete periods, merge keys, or transformations. No analysis data are supplied in the assigned package. The compatible author input route and full data requirements remain unknown; do not independently reconstruct historical sources.

## Review notes

- This document-only variant supports a description of selected robustness checks but not an executable assessment of the full article. No analysis-only scope is supported because neither analysis code nor usable author analysis inputs are supplied.
