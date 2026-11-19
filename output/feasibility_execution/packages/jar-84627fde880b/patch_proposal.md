# Patch proposal: jar-84627fde880b

Audit Partners’ Role in Material Misstatement Resolution: Survey and Interview Evidence

DOI: 10.1111/1475-679X.12506

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

The as-downloaded PDF-only release, assessed for the documented survey and interview workflow. The proposal's manual recruitment, survey, and interview stages are credited as research workflow; they do not supply executable analysis code or establish which planned stages were completed.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 1/12506 - Audit-Partners-Role-in-Material-Misstatement-Resolution-Survey-and-Interview-Evidence/mpsw-datasheet-and-survey-instrument.pdf",
      "sha256": "51460e1acbdcf3cf7c27512ba5756368066598f65524df43c8cdb8337ca39f7c"
    },
    {
      "path": "JAR-Volume 62/Issue 1/12506 - Audit-Partners-Role-in-Material-Misstatement-Resolution-Survey-and-Interview-Evidence/mpsw-in-principle-accepted-version.pdf",
      "sha256": "a6645c4a8a5c27bac35cd8f4b0fa20dc87cd31057a9979b6307c35d62df45daa"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "f9b227c40446b33f16ea9f6c8415791d904af08e298a07cb75da1ac0906c1c1e"
}
```

## Proposed actions

### act_survey_responses: Request the existing author-prepared Qualtrics export or a deidentified analysis table and a field/label map.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: req_survey_responses
Evidence: ev_qualtrics_export, ev_survey_and_platform, ev_proprietary_item, ev_retention_promise

Preparation / proposed procedure:

1. Obtain the authors' existing respondent-level export or prepared table; do not administer a new survey as a substitute.
2. Document the source columns for the 12 primary response questions and the background items used in cross-sectional analyses.
3. Obtain the exact respondent filters, missing-response treatment, response-label map, and any ranking/comparison preparation applied to this file.

Validation to perform later:

- Check the received file's schema against the included survey instrument and confirm that each derived analysis variable has a documented source or transformation.

### act_sampling_metadata: Request privacy-preserving sample and comparison inputs, and resolve whether the actual AuditAnalytics population-level data product can support the named partner comparison.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_sampling_metadata, req_auditanalytics_reference
Evidence: ev_recruitment, ev_contact_log, ev_sample_checks, ev_auditanalytics, ev_proprietary_item, ev_catalog_auditanalytics, ev_auditanalytics_lookup, ev_auditanalytics_fields

Preparation / proposed procedure:

1. Ask for deidentified invitation and response counts/attributes sufficient to reproduce early-versus-late and firm-size composition checks; do not request or query individuals.
2. Identify the exact AuditAnalytics product/table, partner-versus-firm record unit, fields, identifier map, and reference period used; confirm any permitted access route without assuming current entitlement or a restriction.
3. The catalog's AUDIT.FEED89_PCAOB_REPORT lists aggregate NUMBER_OF_PARTNERS and NUMBER_OF_PROFESSIONAL_STAFF; use it only if authors confirm that these firm-level counts supply a specific required comparison, and do not treat it as individual partner background or demographic data.
4. If authors provide a prepared benchmark summary, document its source and mapping and whether it bypasses the underlying product.

Validation to perform later:

- Reconcile the comparison population, fields, identifiers, and denominator to the documented respondent/invited populations before treating any candidate as compatible.

### act_interview_materials: Clarify which interview stages were completed and obtain the permitted transcript or quote-support materials needed for the reported qualitative evidence.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_interview_materials
Evidence: ev_post_interview_sampling, ev_post_interview_review, ev_presurvey_interviews, ev_presurvey_transcription

Preparation / proposed procedure:

1. Separate the nine documented pre-survey interviews from any post-survey interviews actually completed; do not treat future-tense planned interviews as completed observations.
2. Ask for deidentified transcripts, excerpt provenance, and any available coding/deviant-case/quote-verification records that can be shared under the participant consent terms.
3. If full transcripts cannot be shared, obtain an authorized auditable alternative and record the actual limits without presuming a legal or license restriction.

Validation to perform later:

- Verify that each quoted qualitative claim in the target paper is traceable to the permitted interview evidence and documented selection/review procedure.

### act_missing_program: Obtain the supplied processing/analysis code or a complete author-written manual workflow, including software and output mapping.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: issue_missing_program, issue_method_detail
Evidence: ev_package_inventory, ev_qualtrics_export, ev_sample_checks, ev_post_interview_review

Preparation / proposed procedure:

1. Request the programs that transform the Qualtrics export and produce the survey comparisons, together with any separate interview coding or quote-selection procedure.
2. If the authors did not use executable programs, request a step-by-step description identifying each manual/GUI stage, the actual software, inputs, transformations, exclusions, calculations, and outputs.
3. Do not infer a statistical runtime, estimator, or data restriction from the current PDF-only release.

Validation to perform later:

- Trace every required survey/interview input through the documented sequence to the reported tables and quoted findings; retain unresolved mappings as explicit gaps.

### act_confirm_target_version: Confirm that the supplied registered-report proposal is the intended workflow source for the frozen paper and identify completed versus planned stages.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: issue_proposal_stage
Evidence: ev_proposal_label, ev_post_interview_sampling, ev_qualtrics_export

Preparation / proposed procedure:

1. Ask the repository or authors to confirm whether this proposal and datasheet represent the target paper's final empirical workflow; retain the frozen title and DOI unless contrary source evidence is supplied.
2. Request the final analysis description or author confirmation distinguishing the completed survey, pre-survey interviews, and any post-survey interviews from planned stages.

Validation to perform later:

- Reconcile the confirmed workflow and realized sample/materials with the title/DOI target before treating proposal statements as completed data or results.


## Remaining issues and prerequisites

- issue_missing_program [blocking; full_pipeline]: The package inventory contains only two PDF documents and no executable program. The documentation does provide a substantive manual/Qualtrics survey and interview workflow, but it does not include the computer program or a detailed step-by-step processing recipe that produces the final analysis data.
- issue_method_detail [unresolved; full_pipeline]: The datasheet describes ranking and comparing survey response options, and the proposal outlines cross-sectional and nonresponse checks, but the supplied documents do not specify exact data preparation, calculations/tests, result-generation steps, software, or the mapping from the Qualtrics export to analyzed variables. These are concrete workflow gaps, not proof that a data source is restricted.
- issue_proposal_stage [unresolved; full_pipeline]: The supplied paper text labels itself a 2021 JAR Registered Reports Conference Proposal and describes survey and post-survey interview stages in future tense. Its title matches the frozen title, so no attribution conflict is inferred; however, the package does not establish which planned stages or analyses were completed for the frozen paper target.
- req_survey_responses [undetermined]: The author-prepared respondent-level survey data needed to reproduce the documented ranking/comparison of response options and cross-sectional analyses. The datasheet says the final dataset came from the Qualtrics survey portal, but this release contains no response file. The required export schema, response labels, missing-value handling, exclusions, and any derived variables remain unspecified.
- req_sampling_metadata [undetermined]: A deidentified participant/invitation and response summary sufficient for the proposal's early/late response comparison and respondent-versus-invited-pool firm-size/generalizability checks, including the relevant dates or response-order field, contact mode, eligibility, participant characteristics, and denominator values. Do not assume personal names or email addresses are needed in a shared file.
- req_auditanalytics_reference [undetermined]: The proposal calls for comparing respondents' background, experience, specialization, and demographic characteristics with partners covered by AuditAnalytics. The frozen catalog returns auditor firm/entity and change/event candidates; AUDIT.FEED89_PCAOB_REPORT exposes aggregate partner/staff counts, not a demonstrated individual-partner profile. The exact source product/table, population unit, required fields, identifier map, reference period, and compatible access route remain unverified. This firm-level count candidate is not treated as a substitute for the named partner-level comparison.
- req_interview_materials [undetermined]: The proposal includes selected pre-survey quotations drawn from nine transcripts, but no separate full transcripts or transcript/quote-selection files appear in the assigned inventory. The proposal also describes post-survey coding and planned deviant-case/quote checks in future tense; which stages were later completed is unresolved. Participant confidentiality is described, but current sharing permission or a restriction is not established.

## Review notes

- Frozen title and DOI metadata are preserved. The proposal's printed title matches the frozen title; its conference-proposal label and future-tense survey/post-survey interview descriptions are retained as stage/version uncertainty, not an attribution conflict or evidence that planned stages were completed.
- The release's two PDFs provide a substantive research workflow: the survey instructions and instrument, manual participant-pool and invitation description, Qualtrics survey administration and respondent comparisons, nine completed pre-survey interviews with selected transcript-derived quotations, and a planned post-survey interview coding/deviant-case/quote-review process. This is workflow and prepared-document evidence, not executable analysis code.
- The datasheet says the final survey dataset came from Qualtrics and that two authors would retain data/programs for six years. The assigned inventory contains no response export, participant/invitation frame, AuditAnalytics input, transcript files, or program; no separate analysis-only scope is supported.
- The frozen catalog lookup for AuditAnalytics returned 54 candidates. The selected metadata includes auditor identity/change feeds and a PCAOB report table with aggregate partner/staff counts; it does not establish a compatible person-level partner-profile input, data-file readability, historical coverage, or current access. No underlying table or data rows were read.
- The datasheet marks its proprietary-source disclosure item not applicable. This does not establish current user access or unrestricted permission to share survey or interview records; no NDA, license, or confidentiality barrier is inferred. The interview materials must be considered under their actual consent terms.
- No analysis software or executable statistical procedure is named in the supplied text. Qualtrics is identified as survey-administration software, not as evidence of a verified analysis runtime. No software dependency is inferred.
- The assigned dependency checklist is empty; the input requirements above were derived from the actual documents rather than assuming that an empty static/code checklist establishes workflow closure.
- The initial unprefixed-python path check and a later inline metadata-summary syntax failure are preserved as process-only JSON records and are not referenced as scientific evidence. The first substantive draft was archived byte-exact with mode 0444 before this update. No author code, SAS process, data rows, API, participant search, or participant contact was used.
