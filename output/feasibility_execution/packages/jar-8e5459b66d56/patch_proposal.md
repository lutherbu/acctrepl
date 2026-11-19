# Patch proposal: jar-8e5459b66d56

Prepopulating Audit Workpapers with Prior Year Assessments: Default Option Effects on Risk Rating Accuracy

DOI: 10.1111/1475-679X.12218

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Full author-documented experiment-data workflow: manual Excel construction of accuracy, stick-with-last-year, Work Fast and cognitive-process measures; SPSS ANOVAs, Preacher-Hayes Model 4 mediation/exploratory analyses, and Model 7 moderated mediation; AMOS SEM for Figures 2–4 and low/high multi-group moderation for each moderator. The supplied package includes experimental materials and Appendix C prior-year crosswalk but no participant responses or executable program.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 5/12218 - Prepopulating-Audit-Workpapers-with-Prior-Year-Assessments-Default-Option-Effects-on-Risk-Rating-Accuracy/bmr-datasheet-and-experimental-instrument-files.zip",
      "sha256": "13dd332c44167c4c98b4b393aebd72e6d6229e3a25e492b237bfc35e7c7a6e05"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "cc724cbde223ef63bc36b8ec037ce2ebde4688d4fb8602f962ee3eb359c3f9a4"
}
```

## Proposed actions

### act-obtain-participant-data: Identify and request the exact author-prepared participant-response or analysis workbook for the reported n=117 experiment through an authorized route. Confirm whether it contains raw responses, the Excel-derived measures, or both; no route or schema is established by this archive.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req-participant-data, iss-data-contract-route
Evidence: ev-author-data, ev-sample-size, ev-risk-measures, ev-package-inspection

Preparation / proposed procedure:

1. Ask the authors or designated maintainer to identify the exact file, delivery route, format, access conditions, and whether it is response-level or analysis-ready.
2. After authorized receipt, map available participant fields to current-year ratings and evidence text, prepopulation assignment, task timing, and the three measured moderators; identify which Excel measures are already present.
3. Do not recreate or recollect the historical auditor responses, and do not use synthetic or demonstration observations.

Validation to perform later:

- Confirm the reported 117-participant sample and reconcile any exclusions to the paper.
- Confirm the response inputs needed for the 19-factor measures and moderator analyses, and document the author-provided field names and workbook format.

### act-clarify-design-and-models: Obtain the missing mapping between the instrument conditions and the analyzed participant groups, and the exact model/path specifications referenced as Figures 2–4, including Excel-to-SPSS/AMOS variable handoffs. Preserve the documented branches without guessing how guidance conditions were coded or analyzed.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: iss-condition-model-mapping
Evidence: ev-instrument-guidance, ev-treatment, ev-anova, ev-mediation, ev-amos-models, ev-multigroup-moderation, ev-model7, ev-model-page-inspection

Preparation / proposed procedure:

1. Ask the authors or locate an included specification that maps General Guidance and Task-Specific Guidance screens to the experimental sample, treatment coding, and any reported tests.
2. Obtain the exact Figure 2–4 model diagrams or a variable/path table and the SPSS/AMOS input-field mapping, including any reported exclusions or condition handling.
3. Keep ANOVA, Model 4, AMOS SEM, both moderation approaches, and Model 7 in the scope; do not add guidance effects or drop cases without confirmation.

Validation to perform later:

- Reconcile every instrument condition and sample code to the documented analysis branches.
- Confirm each model’s observed variables, paths, moderator grouping/cutoffs, and handoff field names before attempting the GUI analyses.

### act-verify-software: Confirm the available compatible spreadsheet, SPSS and Amos software and the exact Preacher-Hayes macro release before running the manual workflow. LibreOffice 25.2.3.2 is an available spreadsheet candidate, but its compatibility with the absent author workbook is unverified; command lookup misses do not prove licensed software is absent.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: sw-spreadsheet, sw-spss, sw-ph-macro, sw-amos, iss-software-compatibility
Evidence: ev-author-software, ev-excel-accuracy, ev-mediation, ev-model7, ev-amos-models, ev-software-probe

Preparation / proposed procedure:

1. Check authorized local application access and identify the actual software/version used for the Excel, SPSS and Amos GUI steps.
2. Identify the Preacher-Hayes macro file/release and confirm its documented Model 4/Model 7 and bootstrap behavior; do not assume a current PROCESS macro is equivalent.
3. If a compatible environment is not already available, arrange authorized access or obtain author guidance on a compatible substitute before attempting the procedure.

Validation to perform later:

- With the received workbook and approved software, verify the Excel formulas and workbook import/export behavior.
- Verify SPSS ANOVA and macro menus/Model 4 and Model 7 settings, then verify AMOS model and multiple-group functionality without changing the described estimators or sample.

### act-manual-analysis-procedure: No executable program is supplied, but the datasheet documents a manual GUI workflow. Once the input, design mapping and software are confirmed, follow that procedure and retain all reported analysis branches.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: iss-no-executable-program
Evidence: ev-excel-accuracy, ev-stick-with-last-year, ev-work-fast, ev-motivated-reasoning, ev-superficial-processing, ev-anova, ev-mediation, ev-amos-models, ev-multigroup-moderation, ev-model7, ev-prior-year-crosswalk, ev-prior-year-pages

Preparation / proposed procedure:

1. In the author workbook, compute the three accuracy totals from the 8 increasing, 6 decreasing, and 5 unchanged factors; construct Stick with Last Year by the documented cross-group sums.
2. Compute Work Fast from Qualtrics task time using the stated 69 words-per-minute scalar: estimate prepopulated-condition typing time from new evidence words/69 and subtract it from raw time; also compute average non-prepopulated typing time from average words/69 and add that estimate to each prepopulated participant’s time, as described.
3. Calculate motivated-reasoning transition-word counts and new-word counts separately for increasing and decreasing risks, using the documented word list and Excel functions; use the documented professional-identity, reverse-scored Replenishment, and prepopulated-workpaper-use moderator measures.
4. Run SPSS GLM univariate ANOVAs for the three accuracy outcomes (H1/H2), then the documented Preacher-Hayes Model 4 mediation models for Figures 2–4 and exploratory cognitive-process analyses, retaining the stated 90% bias-corrected bootstrap intervals.
5. Run the AMOS structural equation models for Figures 2–4 with residual error terms on mediators and dependent variables; record estimates and fit statistics.
6. For each of the three moderators, create the documented low/medium/high groups using closest even-split cutoffs and perform the low/high AMOS multi-group comparison by constraining Prepopulation-to-mediator paths, separately for increasing and decreasing risks.
7. Run the Preacher-Hayes Model 7 moderated-mediation models with continuous moderators for Figures 2–3/changing risks.

Validation to perform later:

- Compare the H1/H2 ANOVA results to Table 1, Panel C and compare all mediation/moderation outputs with the paper’s specified tables/figures after obtaining the missing model definitions.
- Record software versions, input field mappings, exclusions and manual GUI settings; leave execution_verified false until an authorized execution is completed.


## Remaining issues and prerequisites

- iss-no-executable-program [preparation; full_pipeline]: The three archive members are PDFs. The item 5 file gives substantial manual Excel/SPSS/AMOS procedures and illustrative function names, but supplies no executable analysis/preparation program, workbook, SPSS syntax file, or AMOS project; there is no executable entry point.
- iss-data-contract-route [unresolved; full_pipeline]: The required n=117 participant-response dataset is absent. The datasheet reports author access/retention but does not identify an input file, schema, prepared-measure state, or delivery route; access availability is unknown, not a confirmed barrier.
- iss-condition-model-mapping [unresolved; full_pipeline]: The instrument names General Guidance and Task-Specific Guidance screens, while the item 5 analysis recipe describes prepopulation and three measured moderators. The archive does not map those guidance conditions to participant coding/sample or analyses, nor include the model diagrams/variable-path details for referenced Figures 2–4; their role must be clarified without adding tests or assuming exclusions.
- iss-software-compatibility [unresolved; full_pipeline]: The documented spreadsheet/SPSS/AMOS and Preacher-Hayes macro targets are not verified locally. The bounded command checks establish LibreOffice availability only; they do not establish absence of other GUI/licensed applications or confirm compatibility of the workbook/macro.
- req-participant-data [undetermined]: Author-prepared participant-level data/workbook for the n=117 experiment, containing current-year risk ratings and evidence text for 19 factors, prepopulation assignment, task timing and the three measured moderator responses, with enough raw information to reproduce the documented Excel measures unless they are already author-prepared. Prior-year ratings/evidence are supplied separately in Appendix C. Exact file/format, field names, prepared-measure state, guidance-condition coding, and compatible delivery route are not established.
- sw-spreadsheet [unverified]: The authors used an Excel data file and standard Excel functions for accuracy, mediator and text measures. LibreOffice 25.2.3.2 is available as a candidate, but the author workbook is absent and formula/import/output compatibility is unverified; Microsoft Excel installation and version are also unverified.
- sw-spss [unverified]: The documented manual workflow uses SPSS GUI ANOVAs and macro analyses. A bounded lookup did not find an spss command, which does not establish that a licensed or GUI installation is absent; author version is unspecified.
- sw-ph-macro [unverified]: The datasheet specifies the Preacher-Hayes macro and Models 4/7 but does not supply the macro file or exact compatible release. No equivalent current macro is assumed.
- sw-amos [unverified]: The documented analyses require manual AMOS SEM and multiple-group model comparisons. A bounded lookup did not find AmosGraphics/amos commands; this does not establish that a licensed or GUI installation is absent, and no version is specified.

## Review notes

- The item 5 datasheet is a substantive manual/GUI recipe, not an executable program: isolated Excel function names do not constitute a supplied formula workbook or driver.
- The experiment sample is n=117. No analysis-ready participant-response data are in the three-PDF archive. Do not recreate or recollect responses; request the author-prepared input and its format/route.
- Appendix C pages 28–30 contain the prior-year ratings/evidence for all 19 risk factors; this packaged crosswalk is credited. The 69 words-per-minute scalar is given in the datasheet, so the historical ten-person typing exercise is not a separate live data requirement.
- All documented analysis branches are retained: three accuracy ANOVAs, Figure 2–4 SEM and Model 4 analyses including exploratory cognitive processes, AMOS low/high moderation for three moderator constructs by increasing/decreasing risks, and Model 7 continuous moderated mediation for changing risks in Figures 2–3.
- General Guidance and Task-Specific Guidance screens are present in the instrument; their relationship to the reported prepopulation analyses remains an explicit clarification, not an assumed extra test or exclusion. Visual inspection confirmed that the item 5 pages do not include the referenced Figure 2–4 model diagrams.
- No analysis-only scope is justified without a supported compatible participant-data route. No author programs were executed and no participant-level analysis dataset was read; visual inspection was limited to the supplied instrument/reference and method pages.
