# Patch proposal: jar-89a42cf5671a

Public Pressure and Corporate Tax Behavior

DOI: 10.1111/1475-679X.12101

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Complete author workflow for reproducing the online appendix analyses in Tables A1–A8 and the accompanying robustness/bootstrap discussions. The package contains only the appendix PDF, so there is no runnable entry point or established dependency closure.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 54/Issue 1/12101 - Public-Pressure-and-Corporate-Tax-Behavior/dyreng-et-al-online-appendix.pdf",
      "sha256": "84b64e11aa263a674bc791dc028eac01dbf04523d262c690f2b24e3273ad8abc"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "d77f7ccb49c486264567568c3f64bde25baa4b90585885a43d4729de56454ec7",
  "work_item_sha256": "49bbc9dbe5b57558144942cca4c8f39cffaee1641c97ded42dca955a9a16553a"
}
```

## Proposed actions

### ACT_REQUEST_COMPLETE_APPENDIX_PACKAGE: Request the author replication workflow and input specifications for the complete appendix analysis set.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: REQ_APPENDIX_ANALYSIS_INPUTS, ISSUE_AUTHOR_WORKFLOW_MISSING
Evidence: E_APPENDIX_TABLE_MAP, E_APPENDIX_FTSE_ANALYSIS, E_APPENDIX_ACTIONAID_DATA, E_APPENDIX_BOOTSTRAP, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Request the executable author code or an approved replacement workflow, including supporting programs, software/version details, run instructions, execution order, and a mapping of every listed Table A1–A8 analysis and bootstrap/randomization result to its producer.
2. Request the author-prepared analysis data or a verified acquisition route, with file/product format, identifiers, required fields, covered years, sample definitions, transformations, and access conditions. Ask how the Appendix’s ActionAid and other source references relate to the prepared input; do not infer independent raw-source requirements from these references alone.
3. After receipt, trace each actual producer-consumer handoff, including any separate companion analysis, and revise the dependency closure only from supplied workflow evidence.

Validation to perform later:

- Confirm that every Table A1–A8 result and the bootstrap/randomization analyses have a supplied entry point and documented producer chain.
- Check the received input specification against author-defined samples, variables, periods, and transformations before treating any route as compatible.
- Only after a separate authorized execution, compare reproduced sample counts and table outputs with the appendix; preserve all author-described samples and resampling procedures.


## Remaining issues and prerequisites

- ISSUE_AUTHOR_WORKFLOW_MISSING [unresolved; full_pipeline]: The assessed package contains only an online appendix PDF. It provides result tables and methodological notes but no executable author code, data description, datasets, README, or entry-point instructions, so the complete software requirements and table-by-table producer/consumer workflow cannot be established.
- REQ_APPENDIX_ANALYSIS_INPUTS [undetermined]: Author-compatible input data sufficient to reproduce the empirical results in appendix Tables A1–A8 and the associated analyses are required. The appendix reports firm-level estimation samples, subsidiary disclosure measures, and bootstrap/randomization results, but supplies no data or data specification; the prepared input product(s), identifiers, full fields/history, transformations, and compatible acquisition route are undetermined. Source mentions such as Compustat, ActionAid, and media-search terms are clarification leads; without the author workflow they do not establish separate mandatory live raw-source requirements.

## Review notes

- This is an appendix-only release. The cited Compustat, ActionAid, and media-search references are useful leads for author clarification, but no executable workflow or data route establishes them as separate live raw inputs.
- No analysis_only scope is supported because there is no supplied analysis code or author-prepared analysis dataset.
