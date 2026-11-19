# Patch proposal: jar-098a7b151026

If You Want My Advice: Status Motives and Audit Consultations About Accounting Estimates

DOI: 10.1111/1475-679X.12150

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | restricted_access_required | no_runnable_code |

### full_pipeline

The package supplies a 102-participant survey instrument and a detailed Systat GUI procedure for creating contrariness/precision measures, descriptive statistics, factorial ANOVAs and planned contrasts. It contains no executable program or response dataset. The datasheet states that raw data and the firm identity are protected by a verbal confidentiality agreement. The supplied manual procedure is credited; analysis remains no-runnable-code until software and data access are resolved.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 54/Issue 5/12150 - If-You-Want-My-Advice-Status-Motives-and-Audit-Consultations-About-Accounting-Estimates/knechel-leiby-datasheet-and-instrument.zip",
      "sha256": "0baf7ddc2091d714fa705a958f8eca00e64ca4224bcbb89516f11ae5ab101160"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6c5af1b6f2bb7e97911c10d87c9b1e6de7b02afb5c6fe5ea87197e5415ede33d",
  "work_item_sha256": "3d493e544c2648ff189984e847428dd86387708636421c14747679d7a0fd74c1"
}
```

## Proposed actions

### action_request_survey_data: Determine whether the authors or firm can provide an authorized confidential research copy of the 2014 survey responses, or specify the permissible replication access procedure.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: survey_responses, restricted_raw_data
Evidence: survey_collection, datasheet_confidentiality, manual_dv_formula, instrument_questions

Preparation / proposed procedure:

1. Request access through the authors’ established firm contact only under the existing confidentiality agreement and authorized terms; do not disclose the firm identity or redistribute respondent-level data.
2. Request the permitted response file format, variable/data dictionary, de-identification rules and mapping for RATE, range endpoints, STATUS, AUTH and KNOW.
3. If access is not possible, ask the authors whether an approved controlled-access copy or certified summary outputs exist; do not synthesize or recollect replacement responses.

Validation to perform later:

- Verify the permitted access conditions and confirm that the received data contain the inputs required by the Systat instructions without exposing the firm identity or participant identifiers.

### action_probe_systat: Confirm whether a compatible SYSTAT installation and version are available for the documented GUI workflow.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: systat, software_version_unverified
Evidence: datasheet_systat, manual_intro

Preparation / proposed procedure:

1. Check the available SYSTAT executable or licensed GUI installation and record its version; the appendix does not specify a required version.
2. If unavailable, ask the authors for the version used and whether a licensed access route or supported version exists before selecting an alternative implementation.

Validation to perform later:

- Use the documented Systat transformations, descriptive-statistics menus, ANOVAs and planned contrasts to verify the software setup only after authorized data access.

### action_document_procedure: Follow the supplied Systat GUI procedure after response-data access and software are established; the PDFs provide a manual recipe, not a runnable program.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: missing_program
Evidence: manual_dv_formula, manual_descriptives, manual_anova, manual_contrasts, datasheet_steps

Preparation / proposed procedure:

1. Import the authorized response data into SYSTAT using an author-confirmed mapping for RATE, upper/lower acceptable-rate responses, STATUS, AUTH and KNOW; derive RANGE_SIZE from the range endpoints.
2. Create CONTRARY = RATE – 13.2 and PRECISION = ABS(RANGE_SIZE – 7) using the documented Data>>Transform>>Let GUI steps.
3. Run Table 1 descriptive statistics by STATUS/KNOW and STATUS/AUTH, then the two 2×2×2 ANOVAs for CONTRARY and PRECISION.
4. Run the specified H1a/H1b/H2a/H2b contrasts and their partial-effect tests; use the stated two-tailed p-values for primary contrasts and one-tailed p-values for partial effects.

Validation to perform later:

- Confirm the 102-observation sample and compare Table 1/Table 2 outputs plus the supplemental ANOVA results against the paper; preserve assigned conditions, contrast weights and p-value conventions.


## Remaining issues and prerequisites

- missing_program [unresolved; full_pipeline]: No executable SYSTAT program or script is supplied. The PDFs do provide a substantive manual/GUI procedure with exact variable transformations, menu sequences, model factors and planned contrasts; this procedure is credited as workflow documentation rather than treated as runnable code.
- restricted_raw_data [blocking; full_pipeline]: The 102-participant response dataset is absent. The authors state that raw responses and the firm identity are protected by a verbal confidentiality agreement. A questionnaire is not participant-level outcome data; access requires authorization under the existing agreement.
- software_version_unverified [unresolved; full_pipeline]: SYSTAT is prescribed, but no version is stated and a bounded PATH lookup found no systat/SYSTAT command. This does not establish that licensed GUI access is unavailable.
- survey_responses [restricted_access_required]: The authors’ response-level survey data for 102 participants, needed to reproduce Table 1 descriptive statistics and Table 2 hypothesis tests. The procedure uses the recommended rate (RATE), acceptable-range endpoints/RANGE_SIZE, randomized status and authority conditions (STATUS/AUTH), and specialized-knowledge measure (KNOW); CONTRARY and PRECISION are generated measures.
- systat [unverified]: SYSTAT is the prescribed statistical package for GUI-based variable transformations, descriptive statistics, factorial ANOVAs and planned contrasts. A bounded PATH lookup found no systat/SYSTAT command; the supplied PDFs do not specify a version, and the lookup does not establish license or GUI availability.

## Review notes

- The three supplied PDFs include an experimental instrument and an explicit Systat GUI procedure for descriptive statistics, two factorial ANOVAs, planned contrasts and partial-effect tests. These are credited as manual workflow instructions; no executable program is included.
- The response data are a separate, required artifact: n=102 participants, collected through a firm-supported Qualtrics survey, with raw data and firm identity protected by a verbal confidentiality agreement. The instrument alone is not analysis data.
- No analysis-only scope was added because no response data or executable analysis entry point is supplied. No data were accessed or downloaded, and no author workflow was run.
