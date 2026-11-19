# Patch proposal: jar-0b42eb009932

Do opinions on Financial Misstatement Firms Affect Analysts’ Reputation with Investors? Evidence from Reputational Spillovers

DOI: 10.1111/1475-679X.12119

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Complete author workflow for the reported robustness analyses in the online appendix; executable entry points and their input workflow are not supplied.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 54/Issue 4/12119 - Do-opinions-on-Financial-Misstatement-Firms-Affect-Analysts-Reputation-with-Investors-Evidence-from-Reputation/onlineappendixleelo.pdf",
      "sha256": "b2cacf2febb6b3f761ee9dc9727b6ddc1887b68828f293540cc9c1816fb22371"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "d77f7ccb49c486264567568c3f64bde25baa4b90585885a43d4729de56454ec7",
  "work_item_sha256": "c06d560d3f008cd87368823723633884dccb2c6ee5b5729133d4ec54895d6080"
}
```

## Proposed actions

### A_AUTHOR_WORKFLOW: Obtain the author-provided replication workflow for the analyses covered by this release before attempting reproduction.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: D_APPENDIX_INPUTS, I_MISSING_CODE, I_WORKFLOW_UNKNOWN
Evidence: E_APPENDIX_SCOPE, E_APPENDIX_METHOD, E_PACKAGE_INVENTORY, E_STATIC_AUDIT

Preparation / proposed procedure:

1. Request all author executable programs and supporting files, or the documented manual/GUI procedures, that produce the appendix robustness analyses and any required companion analyses.
2. Request the author-prepared analysis datasets or documented acquisition products together with input filenames, required fields and identifiers, period coverage, construction steps, and producer-consumer order.
3. Request required software, versions, configuration, and run instructions, including how the supplied analyses map to Tables IA1–IA3.
4. After receipt, map each documented analysis entry point and mandatory input, then verify input compatibility and required software before any separately authorized execution.

Validation to perform later:

- Confirm that every appendix robustness result in scope is mapped to a supplied program or documented manual procedure and its required inputs.
- Confirm that input histories, fields, transformations, and software requirements are specified well enough to assess a complete workflow.


## Remaining issues and prerequisites

- I_MISSING_CODE [blocking; full_pipeline]: The supplied package inventory contains only the online appendix PDF and no executable program, manual/GUI recipe, or run instructions. The reported robustness analyses therefore have no supplied runnable or prepared manual workflow.
- I_WORKFLOW_UNKNOWN [unresolved; full_pipeline]: Without the author workflow, exact inputs, their required fields and periods, preparation order, supporting scripts, software, and any manual steps cannot be established. References to variables and analysis methods in the appendix are contextual evidence, not verified live-source dependencies.
- D_APPENDIX_INPUTS [undetermined]: Author-provided analysis input data needed to reproduce the appendix robustness results (including Tables IA1–IA3); exact input files, fields, identifiers, historical coverage, and preparation steps are unspecified in the supplied release.

## Review notes

- No analysis_only scope is supported: the release supplies neither executable analysis code nor author-prepared analysis data or a verified compatible acquisition route.
- Appendix variable definitions, source labels, and reported results are treated as clarification context; no independent raw-source requirements or reconstruction steps are inferred.
- Execution was not verified.
