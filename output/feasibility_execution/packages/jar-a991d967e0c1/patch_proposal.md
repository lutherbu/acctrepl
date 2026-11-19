# Patch proposal: jar-a991d967e0c1

The Role of Visual Attention in the Managerial Judgment of Balanced-Scorecard Performance Evaluation: Insights from using an Eye-Tracking Device

DOI: 10.1111/1475-679X.12102

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | local_available | no_runnable_code |

### full_pipeline

The author-described statistical workflow from the supplied participant-level analysis workbook through the SPSS analyses for H1–H3 and the separate median-split robustness result in Online Appendix Table A1. The package includes a manual SPSS route and prepared analysis data, but no executable analysis program.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 54/Issue 1/12102 - The-Role-of-Visual-Attention-in-the-Managerial-Judgment-of-Balanced-Scorecard-Performance-Evaluation-Insights/chen-et-al-dataset.xlsx",
      "sha256": "b5906d63d71121c2bcf39dcaa73ae577f87b834314d4435178bd5b81de7d87f0"
    },
    {
      "path": "JAR-Volume 54/Issue 1/12102 - The-Role-of-Visual-Attention-in-the-Managerial-Judgment-of-Balanced-Scorecard-Performance-Evaluation-Insights/chen-et-al-online-appendix.pdf",
      "sha256": "0a12b58b75964d9a37d783effa4c5e78de5f8bf351432e578ddb673bf5b49096"
    },
    {
      "path": "JAR-Volume 54/Issue 1/12102 - The-Role-of-Visual-Attention-in-the-Managerial-Judgment-of-Balanced-Scorecard-Performance-Evaluation-Insights/chen-jermaias-panggabean-data-description-sheet.pdf",
      "sha256": "6dee4975ef12857a001f8c7e3db9f6edd5ec4330c34e7d640e9fde9b8a701703"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "d77f7ccb49c486264567568c3f64bde25baa4b90585885a43d4729de56454ec7",
  "work_item_sha256": "cb84e27f9b0915b9206d190beeaee33d269a0520483912a25e01ff847a4d89f9"
}
```

## Proposed actions

### ACT_REQUEST_SPSS_PROCEDURE_DETAILS: Obtain the exact author SPSS syntax or fully specified manual settings for the supplied analysis dataset.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: ISSUE_MANUAL_PROCEDURE_DETAILS
Evidence: E_MANUAL_H1, E_MANUAL_H23, E_APPENDIX_A1_SPLIT, E_WORKBOOK_INSPECTION

Preparation / proposed procedure:

1. Ask the authors for executable SPSS syntax, if available, or the exact dialog options and output mapping for H1, H2/H3, and the supplementary Appendix A1 analysis.
2. Keep the data-description sheet’s main H1 mean-split procedure separate from Appendix Table A1’s explicitly reported median-split robustness analysis; request clarification only where exact output settings are not stated.
3. Confirm that the workbook raw header PresentationFormat maps to the documented Presentation factor and how the blank trailing AX header is handled on import. Do not infer a code repair from these header differences.
4. Use the supplied participant-level statistical dataset as the primary analysis input. Request historical Locarna videos/tagging intermediates only if the authors say the supplied workbook is insufficient for a documented statistical output.

Validation to perform later:

- Confirm the author instructions map the supplied fields MATCH, LinkFixationRatio, NonLinkFixationRatio, PresentationFormat, Experience, and Gender to each described statistical procedure.
- Confirm that the prepared workbook has the expected 60 participant records and that both mean-split H1 and median-split Appendix A1 remain distinct analyses.
- After a separate authorized manual or scripted SPSS run, compare H1/H2/H3 and Appendix A1 outputs with the author reports; do not treat workbook readability alone as execution verification.

### ACT_VERIFY_SPSS22_ACCESS: Verify access to the author-specified SPSS version before attempting the manual analyses.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SPSS_22
Evidence: E_DATA_DESCRIPTION_SPSS

Preparation / proposed procedure:

1. Check whether licensed SPSS version 22 is available for the intended run. If it is not, request access or an author-confirmed compatible version before substituting another package.

Validation to perform later:

- Record the SPSS version shown by the installed application and confirm it can import the workbook with the required fields before the later authorized analysis.


## Remaining issues and prerequisites

- ISSUE_MANUAL_PROCEDURE_DETAILS [unresolved; full_pipeline]: The package supplies an actual manual SPSS procedure: H1 uses a mean split and chi-square crosstab, while H2/H3 use a two-level repeated-measures ANOVA. The appendix separately identifies Table A1 as a median-split result. No executable SPSS syntax is supplied, and exact menu settings/output mapping and the import mapping from workbook header PresentationFormat to the data-sheet factor Presentation are not fully documented. The manual route is present; full procedural closure and a runnable program are not.
- SW_SPSS_22 [unverified]: The data-description sheet specifies SPSS version 22 for the statistical analyses. Local licensed availability, exact version, and the prescribed Excel-import behavior have not been verified.

## Review notes

- The workbook is an author-prepared statistical-analysis dataset. Its stated historical Locarna video, tagging, CSV, and Excel PivotTable steps produced the supplied analysis input; they are not separate live requirements for the described statistical rerun unless author clarification shows otherwise.
- The data-description sheet’s H1 mean split and Appendix Table A1 median split are preserved as distinct analyses, not treated as contradictory instructions.
- The bounded metadata probe identifies the raw header PresentationFormat while the data-description sheet calls the between-subject factor Presentation; an extra trailing AX header is blank. No import repair is proposed without the author’s prescribed SPSS import behavior.
- No analysis_only scope is added because the package supplies no executable code for such a scope; the documented manual statistical route is assessed under full_pipeline.
