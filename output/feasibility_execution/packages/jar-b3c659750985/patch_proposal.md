# Patch proposal: jar-b3c659750985

Information Intermediary or De Facto Standard Setter? Field Evidence on the Indirect and Direct Influence of Proxy Advisors

DOI: 10.1111/1475-679X.12261

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Complete author-documented qualitative interview workflow, including preparation of the de-identified interview corpus and NVivo-assisted manual coding. Historical IRB approval, recruitment, consent, interviews, transcription, and transcription verification are not treated as live execution dependencies for auditing a released prepared corpus.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 4/12261 - Information-Intermediary-or-De-Facto-Standard-Setter-Field-Evidence-on-the-Indirect-and-Direct-Influence-of-Pr/hv-datasheet.pdf",
      "sha256": "5a8e7c7b7f603ca489b874699677300a566e1813da218ee937a9b2008ba74303"
    },
    {
      "path": "JAR-Volume 57/Issue 4/12261 - Information-Intermediary-or-De-Facto-Standard-Setter-Field-Evidence-on-the-Indirect-and-Direct-Influence-of-Pr/hv-online-appendix.pdf",
      "sha256": "dd265f96cb2647a9d1207116b27c6be50c223e10c1be84f6d44c186b05244c5b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "2e6380a05fc452614b227f4e635e73bb6b1031d0a81558853eec0479e31e3b50"
}
```

## Proposed actions

### act_clarify_qualitative_package: Request the current author-prepared de-identified corpus and qualitative analysis materials, together with the actual manual/GUI coding protocol and NVivo compatibility details, subject to the participants’ consent and applicable IRB terms.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_interview_corpus, req_qualitative_coding_record, sw_nvivo, issue_no_executable_program, issue_workflow_and_input_specification, issue_current_retention_and_sharing
Evidence: e_datasheet_interviews, e_datasheet_nvivo, e_datasheet_no_code, e_datasheet_retention, e_consent_confidentiality, e_appendix_sample_script, e_appendix_indicative, e_package_inventory, e_environment_inventory

Preparation / proposed procedure:

1. Confirm whether the author-prepared, de-identified corpus still exists; identify the interviews actually used in the paper; provide verified transcripts for recorded sessions and the detailed notes for the five participants who declined recording; and describe current retention status.
2. Confirm the lawful access and sharing conditions under the participant consent and applicable IRB terms. The confidentiality language does not by itself establish either permission or a categorical bar to sharing de-identified materials.
3. If retained and shareable, provide the NVivo project or compatible coded export, code definitions/codebook or documented coding scheme, coding matrix or coded segments, and the actual steps for independent initial coding, final coding, and resolution of coding differences.
4. Specify NVivo version, project/export format, any manual lookup or crosswalk inputs, and the human coding workflow needed to obtain the reported outputs. Verify current software access rather than assuming a license is present.
5. If the corpus or coding files are unavailable or cannot be shared, document that limitation and provide the most complete non-identifying prepared coding outputs and manual workflow description that may be shared. Do not recruit participants again or infer the full dataset from published excerpts.

Validation to perform later:

- Verify that the permitted prepared corpus covers all interviews the authors actually analyzed and distinguishes transcripts from notes for unrecorded participants.
- Verify that the supplied coding records and manual protocol identify the analytical units, code definitions, coder assignments, reconciliation rules, and outputs reported in the paper.
- Confirm the supplied NVivo project/export opens in the specified software version or in a documented compatible format, and that the named current access route is available.


## Remaining issues and prerequisites

- issue_no_executable_program [blocking; full_pipeline]: The supplied release contains no executable author program. The datasheet explicitly says no program or code was used for the qualitative analysis; the documented manual/GUI coding workflow remains only partially specified.
- issue_workflow_and_input_specification [unresolved; full_pipeline]: The release contains no interview transcripts or notes, NVivo project, codebook, coding matrix, coded export, or complete manual coding/reconciliation recipe. Appendix A supplies only customized sample questions; Appendix B contains selected indicative quotations, not the full corpus or analytic record. Current retention and lawful sharing conditions remain unverified.
- issue_current_retention_and_sharing [unresolved; full_pipeline]: The six-year retention statement is historical and does not prove that materials are still retained or were deleted. The consent form promises reasonable confidentiality efforts but does not establish that de-identified interview materials cannot be shared; present access permission under the consent and IRB terms needs confirmation.
- req_interview_corpus [undetermined]: Author-prepared, de-identified and verified qualitative interview corpus used in the paper: interviews with 37 board directors, HR executives, and compensation consultants, plus six interviews involving eight proxy-advisor representatives. The corpus must include transcripts for recorded interviews and the detailed notes for the five participants who declined recording.
- req_qualitative_coding_record [undetermined]: Qualitative analysis records needed to apply or inspect the reported coding scheme: code definitions/codebook or coding scheme, coded segments or coding matrix, and the NVivo project or a compatible coded export, if these records were retained.
- sw_nvivo [unverified]: NVivo was used to facilitate the documented qualitative analysis. The author version, project/export format requirements, and current software/access availability are unverified; the bounded environment inventory does not test NVivo.

## Review notes

- The assigned package root contains only the datasheet and online appendix. It has no author program, transcripts, notes, NVivo project, codebook, coding matrix, or coded export. The datasheet explicitly says no program or code was used; the documented NVivo and human coding procedure is credited as a workflow, but it is not a supplied executable program or complete manual recipe.
- Appendix A is a sample question list customized by interview role and prior information. Appendix B supplies selected indicative excerpts. Neither is the complete interview corpus or a substitute for the coding record.
- The six-year retention assurance is historical and does not establish current retention, access, or deletion. Consent confidentiality language does not automatically prove sharing impossible; lawful current access to de-identified materials remains unverified.
- Historical IRB approval, recruitment, informed consent, conducting new interviews, transcription, and transcription verification are not proposed as live execution dependencies for auditing an author-prepared corpus. Original recordings are not independently demanded if authors can supply their verified analysis corpus and notes.
