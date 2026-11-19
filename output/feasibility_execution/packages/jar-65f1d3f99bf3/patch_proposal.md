# Patch proposal: jar-65f1d3f99bf3

Explaining Rules-Based Characteristics in U.S. GAAP: Theories and Evidence

DOI: 10.1111/1475-679X.12112

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Complete author-documented article and appendix workflow. This Internet Appendix supplies detailed manual procedures and summary/results tables for selected measures, but the package contains no executable program or complete analysis-data files.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 54/Issue 3/12112 - Explaining-Rules-Based-Characteristics-in-U-S-GAAP-Theories-and-Evidence/donelson-mcinnis-mergenthaler-online-appendix.pdf",
      "sha256": "97342ac24a9c497554c2e95115b4fa204eaba73cedbfcbae846ee59f96ca6151"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "d77f7ccb49c486264567568c3f64bde25baa4b90585885a43d4729de56454ec7",
  "work_item_sha256": "319dec6d0d2403e73b6808aa20a80318395208fac7c3d5791d333d552ee94ae1"
}
```

## Proposed actions

### A_acquire_FASB_texts: Acquire the official historical standard texts needed for the documented manual standard-year construction.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: D_standard_texts
Evidence: E_manual_RBC, E_RBC_period, E_FASB_standards, E_FASB_legacy

Preparation / proposed procedure:

1. Retrieve the official FASB, APB, and Committee on Accounting Procedure standard texts, original/amended pronouncements, and effective-date materials for the 1953–2009 period; retain document titles, standard identifiers, versions, and dates in a provenance list.
2. Use the appendix’s documented year-by-year procedure to account for later amendments and modifications when preparing standard text for each effective year; then apply the stated keyword, word-count, and transaction-complexity coding procedures without replacing author definitions.

Validation to perform later:

- Confirm the source inventory covers the standards and years in the author-defined sample and retains amendment/effective-date provenance.
- Compare resulting per-standard summary fields with Table IA1 as a consistency check; this does not replace the complete annual panel or author review of manual classifications.

### A_verify_interpretive_guidance: Obtain the complete author-compatible set of interpretive guidance documents and effective-year records.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: D_interpretive_guidance
Evidence: E_manual_RBC, E_FASB_legacy

Preparation / proposed procedure:

1. Request the exact source list or author-prepared standard-year guidance counts for the EITF, Financial Statement Positions, FASB Interpretations, Technical Bulletins, and AICPA Interpretations used in the RBC measure.
2. Confirm document coverage and effective dates for every standard-year observation from 1953–2009 before treating the public FASB archive as a complete route.

Validation to perform later:

- Verify that the returned source list/data documents each guidance item, linked standard, and effective year and reconciles to the author-defined period.

### A_acquire_SEC_materials: Acquire the specifically documented SEC source materials for frequency, speech-mention, and investigation measures.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: D_edgar_2008, D_sec_speeches, D_sec_annual_reports
Evidence: E_frequency, E_SEC_speeches, E_SEC_annual, E_SEC_EDGAR, E_SEC_speech_archive, E_SEC_speech_1997, E_SEC_speech_2005, E_SEC_annual_start, E_SEC_annual_end, E_SEC_report_count, E_local_LM10X_2008_candidate

Preparation / proposed procedure:

1. Before acquiring 2008 10-K text, check the local ${ACCTREPL_LM10X}/2008 corpus for the author-required filer population, 10-K filings, Item 7 text, and usable cleaned format. Use it only if those compatibility checks pass; otherwise retrieve the missing underlying 2008 Form 10-K filing text from official EDGAR and apply the documented Item 7 keyword count.
2. Retrieve SEC speeches and public statements from 1997–2005; apply the Table IA1 search terms and manually review each hit for a substantive mention of the relevant standard.
3. Retrieve the SEC annual reports for 1953–2009 and extract the authors’ annual investigation count using the same definition across years; form the documented three-year change only after the annual series is complete.

Validation to perform later:

- Record a year-by-year coverage inventory for each source; do not infer missing annual observations.
- Confirm keyword hit review and investigation-count extraction against the appendix definitions and preserve all source-document identifiers.

### A_request_coded_case_data: Request author-coded analysis data and exact case/source mappings that are not supplied by the appendix tables.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: D_rbc_panel, D_private_litigation, D_public_restatement_sample, D_scandal_coding, I_workflow_incomplete
Evidence: E_RBC_period, E_table_IA1, E_litigation, E_scandals, E_package_inventory

Preparation / proposed procedure:

1. Request the complete standard-year RBC panel and component scores, plus the author-prepared cross-sectional variables and identifiers used in the main paper; Table IA1’s first/median/last-year summaries and keyword list are not a compatible substitute for these annual observations.
2. Request the private class-action complaint list and standards-coded allegations used by Donelson et al. (2012), and the public SEC-enforcement restatement sample and matched 10-K references/standard coding used by Mergenthaler (2012).
3. Request case-specific source citations and the author’s standard-violation coding for each named scandal. Preserve the appendix’s stated manual screening and coding definitions; do not independently rebuild the case samples.

Validation to perform later:

- Check that the returned data contain the author-defined standard/case identifiers, periods, coding fields, and sample coverage before classifying any local route as compatible.
- Reconcile case and standard counts, panel years, and key variables to the article and appendix tables after the full manuscript/workflow is supplied.

### A_request_complete_program: Request the executable author program and the missing complete article-level workflow documentation.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I_missing_code, I_workflow_incomplete
Evidence: E_appendix_scope, E_package_inventory, E_litigation, E_frequency, E_SEC_speeches, E_SEC_annual

Preparation / proposed procedure:

1. Request all programs for the primary article and appendix analyses, their true entry points and execution order, any documented manual stages, required software/versions, intermediate outputs, and the input/output map for every reported table and figure.
2. Request the main paper’s complete datasheet and variable definitions, sample construction, remaining controls and analysis instructions. The supplied appendix’s documented manual procedures should be retained as stages in the full author workflow.

Validation to perform later:

- Review the returned package against every primary-paper and appendix output; confirm all author code, manual steps, inputs, generated intermediates, software, and branches are mapped before declaring dependency closure complete.


## Remaining issues and prerequisites

- I_missing_code [blocking; full_pipeline]: The assigned package contains only the Internet Appendix PDF and no executable author program. The appendix does document manual construction and analysis procedures; this is classified as no runnable code while retaining those procedures and their inputs separately.
- I_workflow_incomplete [unresolved; full_pipeline]: The appendix says it supplements the main paper and supplies selected manual variable-construction steps and robustness analyses, but the main paper’s complete analysis workflow, remaining variable/control definitions, author sample selections, software/entry points, and several author-coded data products are not included. Table IA1 is not a complete annual RBC dataset. Full dependency closure is therefore unresolved.
- D_standard_texts [public_acquisition_required]: Historical U.S. accounting-standard source texts and amendment/modification records for the 146 unique standards covered over 1953–2009. The appendix uses these texts to track each standard by effective year and manually code RBC characteristics and transaction complexity.
- D_interpretive_guidance [undetermined]: Interpretive pronouncements and effective-year records for each standard, including the EITF Issues, Financial Statement Positions, FASB Interpretations, FASB Technical Bulletins, and AICPA Interpretations counted in the author-described RBC guidance component.
- D_rbc_panel [undetermined]: The author-coded standard-year RBC panel and component values needed for the article’s cross-sectional and time-series analyses, with standard identity, year, amendment status, and the derived measures used in the decomposition. Table IA1 is only a per-standard summary and keyword list, not the complete annual panel.
- D_private_litigation [undetermined]: The private-litigation input used to count accounting-related securities class actions during 1997–2005, with the accounting standard allegedly violated coded for each complaint.
- D_public_restatement_sample [undetermined]: The author-used sample of restatements resulting in SEC enforcement actions during 1997–2005, with the related 10-Ks and standard-violation coding described as sourced from Mergenthaler (2012). The sample identifiers and compatible author-prepared coding file are not in this package.
- D_scandal_coding [undetermined]: Author-coded standard violations for the nine named accounting scandals, based on the cited SEC filings, court documents, and historical narratives.
- D_edgar_2008 [public_acquisition_required]: SEC EDGAR Form 10-K filing text for 2008, specifically Item 7, searched using the per-standard keywords listed in Table IA1 to construct the transaction-frequency measure.
- D_sec_speeches [public_acquisition_required]: SEC speech and public-statement texts from 1997–2005, searched with the standard-specific keyword list and manually reviewed to confirm that each hit identifies the standard as a concern.
- D_sec_annual_reports [public_acquisition_required]: SEC annual-report PDFs containing annual investigation counts for the article’s 1953–2009 time-series measure, from which the documented three-year window is formed.

## Review notes

- This appendix contains real manual data-processing instructions and must not be described as having no workflow. It still has no runnable program and supplies only summary/results tables, not the complete author-coded data or main-paper workflow.
- Verified public FASB/SEC routes apply only to the raw source products documented in the appendix. They do not verify author-coded RBC, litigation, restatement, or scandal inputs where sample selection or coding remains unspecified. No analysis_only scope is supported because the package contains neither runnable analysis code nor a compatible full analysis dataset.
