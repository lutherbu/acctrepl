# Patch proposal: jar-324d12ebf090

Performance Effects of Setting a High Reference Point for Peer-Performance Comparison

DOI: 10.1111/1475-679X.12199

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied Stata do-file analyzes both the main and supplemental HarvardX experiments from author-prepared files.

Entry points: `EN_RP_Code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 2/12199 - Performance-Effects-of-Setting-a-High-Reference-Point-for-Peer-Performance-Comparison/en-datasheet-and-code.zip",
      "sha256": "3331cff1dd36ce500fb6e4e0803cda953ac554415431227642447c6f3980b782"
    },
    {
      "path": "JAR-Volume 56/Issue 2/12199 - Performance-Effects-of-Setting-a-High-Reference-Point-for-Peer-Performance-Comparison/en-online-appendix.pdf",
      "sha256": "a8e4d320993e997556a13bce8229131b0dafe37b7f0538f5333a076ff0a4c2df"
    },
    {
      "path": "JAR-Volume 56/Issue 2/12199 - Performance-Effects-of-Setting-a-High-Reference-Point-for-Peer-Performance-Comparison/eyring-narayanan-accepted-proposal.pdf",
      "sha256": "d351313c07b8f1017598f3eb42512ba7c4540512e61e61ebc5f4c65247b2c9f8"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "d5adff56763299a7d41cf45e5c742e74f25f55973edc57fdaabe5ce3b7521b2b"
}
```

## Proposed actions

### A_DATA_ACCESS: Obtain an authorized route to both exact author-prepared Stata analysis files, or an author-confirmed compatible analysis-data release and its path. Do not independently rebuild the experiment data from historical HarvardX or Qualtrics source systems.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_ACTIVITY, R_GRADE, I_DATA_ACCESS
Evidence: E_MAIN_USE, E_SUPP_USE, E_PROPRIETARY, E_NO_SHARE

Preparation / proposed procedure:

1. Ask the authors or HarvardX data steward for permitted access to both the main activity-level and supplemental grade-level analysis files, or for an authorized compatible analysis-data release.
2. Confirm the delivered files contain the consumed variables listed on the routes, with compatible types, treatment and sample identifiers, and the survey responses required by the do-file.
3. Once received, configure the two `use` paths on a working copy while keeping both main and supplemental branches intact; run the assigned bounded metadata helper against each file.

Validation to perform later:

- Confirm the exact files are readable in Stata and that every expected source column is present with a compatible type; do not treat a one-row probe as proof of population coverage.
- After authorized access and setup, validate the code against both complete experiment inputs without dropping analyses or replacing data.

### A_OUTPUT_CLOSURE: Ask the authors to identify the executable producer or approved manual/output source for reported results that the released do-file does not actively produce, and to confirm the canonical table numbering.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_OUTPUT_CLOSURE
Evidence: E_APP_OA1, E_APP_OA3, E_APP_SURVEY, E_APP_OA12, E_APP_LATE_TEXT, E_APP_OA11_CAPTION, E_APP_OA12_CAPTION, E_APP_BAYES, E_APP_BAYES_SUPP, E_APP_BAYES_SUPP_H3, E_CODE_BAYES, E_OUTPUT_SCAN

Preparation / proposed procedure:

1. Request the companion program or author-confirmed workflow for OA1/OA2 correlations, OA3/OA4 continent tables, survey response percentages for Tables 9/10, ITT/TOT coefficient-equality tests, and the Bayes factors reported in OA7/OA8.
2. Ask the authors to reconcile the OA13/OA14 references in Appendix prose with the OA11/OA12 table captions and code comments.
3. Obtain any needed definitions and required analysis fields from the authors; retain the published samples, comparisons, and output scope. Do not invent the missing calculations.

Validation to perform later:

- Map every documented table result to an active supplied or author-confirmed producer and its input fields before marking dependency closure complete.
- For any author-provided companion workflow, verify the expected results are generated and preserved after authorized execution.

### A_PRESERVE_OUTPUTS: On an authorized working copy, preserve the Stata Results stream in a named text log while running the supplied do-file. This captures active tabulations, regressions, tests, and survey signrank output but does not replace the missing producers in I_OUTPUT_CLOSURE.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_OUTPUT_PRESERVATION
Evidence: E_OUTPUT_SCAN, E_CODE_SCOPE, E_ENV

Preparation / proposed procedure:

1. After the data paths are authorized and configured, create an `output/` folder in the working copy and set Stata’s working directory to that copy.
2. Run the do-file in a Stata session with a text log directed to `output/EN_RP_Code.log`; close any existing default log before starting the named log, then close the named log when the do-file finishes.
3. If using batch Stata, direct its single session log to this same named artifact and do not rely on an undocumented default log location.

Validation to perform later:

- Confirm the log contains outputs from both the main and supplemental experiment sections, including access tabulations, regression results, and test/signrank results.
- Retain the log and record its path with the future run artifacts.

### A_TABLE_LABELS: Correct the two hypothesis-test section comments so they match the online appendix captions; the proposed comment-only edits do not alter the analyses.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_TABLE_LABELS
Evidence: E_MAIN_TABLE_LABEL, E_SUPP_TABLE_LABEL, E_APP_TABLE_OA7, E_APP_TABLE_OA8

**Proposed edit:** `EN_RP_Code.do:34–34`
Source SHA-256: `f45006953f4f3f08ae16fa74be6ee242051916541076fe81535ac5d54dfcbefc`

The online appendix identifies Table OA7 as the main-experiment hypothesis-test table.

Current text:
```
***	Hypothesis Tests - Table OA8
```

Proposed replacement:
```
***	Hypothesis Tests - Table OA7
```

**Proposed edit:** `EN_RP_Code.do:236–236`
Source SHA-256: `f45006953f4f3f08ae16fa74be6ee242051916541076fe81535ac5d54dfcbefc`

The online appendix identifies Table OA8 as the supplemental-experiment hypothesis-test table.

Current text:
```
*** Hypothesis Tests - Table OA7
```

Proposed replacement:
```
*** Hypothesis Tests - Table OA8
```

Validation to perform later:

- Compare the corrected section labels with the main and supplemental table captions in the online appendix; confirm no executable command changed.


## Remaining issues and prerequisites

- I_DATA_ACCESS [unresolved; full_pipeline]: The complete workflow reads two author-prepared HarvardX analysis files, one for the main activity experiment and one for the supplemental grade experiment; neither file is in the package. The datasheet identifies the data as proprietary and says public sharing permission is absent. No authorized researcher route or compatible replacement has been established, so the required fields, types, and contents cannot be checked.
- I_OUTPUT_CLOSURE [unresolved; full_pipeline]: The online appendix reports results not actively produced by the only supplied do-file: OA1/OA2 correlation matrices, OA3/OA4 continent-by-development tables, the survey response percentages in Tables 9/10, ITT/TOT coefficient-equality tests, and Bayes factors. The Bayesian lines are commented; separate ITT/TOT fits do not calculate the documented equality tests. No companion analysis program is included. Appendix prose also calls the ITT/TOT tables OA13/OA14 while their captions and do-file label them OA11/OA12. The source of these results and complete output mapping therefore remain unresolved.
- I_OUTPUT_PRESERVATION [preparation; full_pipeline]: The supplied do-file contains no explicit log, table export, graph export, or dataset-save command, and no output artifact is in the package. Durable preservation of its printed regression, test, and tabulation results currently depends on an undocumented Stata invocation.
- I_TABLE_LABELS [preparation; full_pipeline]: The main-experiment hypothesis-test block is labeled OA8 and the supplemental block OA7 in the do-file, while the online appendix captions identify OA7 as main and OA8 as supplemental.
- R_ACTIVITY [undetermined]: Author-prepared main-experiment activity-level Stata analysis dataset, read from the absolute path shown in EN_RP_Code.do.
- R_GRADE [undetermined]: Author-prepared supplemental-experiment grade-level Stata analysis dataset, read from the absolute path shown in EN_RP_Code.do.

## Review notes

- The first checkpoint was saved after reading the datasheet and complete do-file; subsequent review covered the appendix table map, required data, local Stata runtime, dependencies, and output preservation.
- The expected field lists are derived from the consumed variables in the do-file; the absent DTA files prevented format, types, identifiers, and actual fields from being probed.
- Full pipeline retains both documented branches in order: main activity experiment from its author-prepared DTA, then supplemental grade experiment from its separate author-prepared DTA. The code contains no preprocessing producer for either file; no analysis_only bypass has a supported input route because both required analysis files are absent.
- Datasheet history about HarvardX folder access and Qualtrics surveys is treated as provenance, not as a separate live raw-source requirement: the executable workflow starts from the two prepared analysis DTA files.
- No commercial data product, SAS source, database input, or external Stata add-on is called by active code. Comment-only Bayes and eststo lines are not active software dependencies.
- Shortened names such as activity_new_w, c_median_conf, interact_ac, type_75_ac, ans_diff_over, type_75_grade, and interact_grade are preserved as unique Stata variable abbreviations; no defect is inferred from their spelling.
- The existing author-results appendix and current do-file do not establish the missing output producers or full table mapping. Keep those gaps unresolved until the authors provide a companion workflow or clarify scope.
- The main dataset must also provide ctrl_low, ctrl_med, and ctrl_high, which the main branch consumes before defining them; the supplemental branch creates its own corresponding variables and does not require these as raw input fields.
- The authors do not name their Stata release. Stata 18 is available; no specific active-command incompatibility is established, so the version difference remains a future validation limit rather than a separate access gate.
