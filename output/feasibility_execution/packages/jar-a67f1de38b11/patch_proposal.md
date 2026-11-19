# Patch proposal: jar-a67f1de38b11

The Real Effects of Modern Information Technologies: Evidence from the EDGAR Implementation

DOI: 10.1111/1475-679X.12496

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied Codes for JAR.do workflow for the main Table 2 analysis, retaining baseline Panels A/B and the stacked difference-in-differences Panel C.

Entry points: `Codes for JAR.do`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 5/12496 - The-Real-Effects-of-Modern-Information-Technologies-Evidence-from-the-EDGAR-Implementation/gyz-datasheet-code-and-identifiers.zip",
      "sha256": "1aec30818ea68a1ab6637b8b93f36e5d044eb095a9fa1f6f74b4026dbcae7efa"
    },
    {
      "path": "JAR-Volume 61/Issue 5/12496 - The-Real-Effects-of-Modern-Information-Technologies-Evidence-from-the-EDGAR-Implementation/gyz-online-appendix.pdf",
      "sha256": "b1da0d3a047767cd0f9424e1548f1e46aecdd7681ee8a8e8ab46e745e42a32a9"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "34eebc57fbde9bc98aebdaaa90aa645758559dedf3026a0d69bc75a2d80f48b6"
}
```

## Proposed actions

### A_Q_COMP: Resolve the remaining field and history gaps between the local COMP.FUNDQ candidate and the exact quarterly input read by the supplied driver.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_Q_COMP, I_Q_COMP_FIELDS, I_Q_COMP_HISTORY
Evidence: S02, S03, S06, S07, CAT_FUNDQ, PROBE_FUNDQ_A, PROBE_FUNDQ_B1, PROBE_FUNDQ_B21, PROBE_FUNDQ_DATADATE, PROBE_FUNDQ_CIK, E_TRACE

Preparation / proposed procedure:

1. The local COMP.FUNDQ candidate at ${ACCTREPL_SAS_ROOT}/comp/d_na/fundq.sas7bdat is a readable Merged Fundamental Quarterly File; prepare a Stata-readable author-input file at data/sources/20191009 Compustat data (quarterly).dta or configure a consistent path.
2. Confirm whether the author-prepared input contains the code-read sic field or document its actual historical producer/join; do not infer a current company lookup is a historical SIC mapping.
3. Confirm the candidate/input contains the authored fyearq 1990-2000 filter period and enough within-firm rows for the existing quarterly lead/lag calculations; retain the exact GVKEY/CIK mapping.

Validation to perform later:

- Use bounded metadata to confirm the prepared input's actual imported columns and IDs, then validate period, producer mapping, and lead/lag handoffs during a separately authorized run.

### A_ANNUAL_COMP: Prepare the local COMP.FUNDA candidate for the code's 1992 assets screen after confirming its required year and firm coverage.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_ANNUAL_COMP, I_ANNUAL_COMP_HISTORY
Evidence: S02, S06, CAT_FUNDA, PROBE_FUNDA, E_TRACE

Preparation / proposed procedure:

1. Use the readable local COMP.FUNDA candidate at ${ACCTREPL_SAS_ROOT}/comp/d_na/funda.sas7bdat; convert it to a Stata-readable file at data/sources/20191009 Compustat data (annual).dta or configure a consistent input path.
2. Confirm that 1992 observations supply GVKEY, datadate, and AT and support the code's latest-datadate-per-GVKEY screen; the row-limited probe did not establish this coverage.

Validation to perform later:

- Check the converted input's raw source columns, then validate 1992 coverage and the resulting asset screen during a separately authorized run.

### A_EDGAR_MAP: Identify the compatible source and construction contract for the CIK-to-phase_in group file actually consumed by the driver.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_EDGAR, I_EDGAR_MAP
Evidence: S02, S04, P_SEC, E_TRACE

Preparation / proposed procedure:

1. The bounded official SEC overview confirms a 33-6977 phase-in schedule exists, but not the group table read by this code; identify an exact public CIK/phase_in list or the author-prepared file.
2. If no compatible official public product is documented, obtain the author-prepared 20190930 EDGAR Phase-in Groups table or its explicit production instructions.
3. Confirm that CIK is unique, phase_in matches CF-01 through CF-10, and cohort population/effective-date mapping fit the code's joins.

Validation to perform later:

- Check the exact table's bounded metadata and join-key uniqueness/readability after a permitted compatible file is supplied; validate group coverage in a separately authorized run.

### A_SW_SETUP: Prepare the two Stata commands not found in checked adopaths and record the exact location/version of the available winsor command before an authorized workflow attempt.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_PSMATCH2, SW_OUTREG2, SW_WINSOR
Evidence: P_ENV, PROBE_PSMATCH2, CAP_PSMATCH2, PROBE_WINSOR, CAP_WINSOR

Preparation / proposed procedure:

1. Locate or prepare the exact Stata commands psmatch2 and outreg2 in the intended project adopath; record each command name, ado location, version, and which status without choosing an unverified substitute version.
2. Confirm the existing winsor command's ado location and version; the saved metadata established which success but did not return its package version.
3. Keep the available Stata 18, reghdfe 6.12.3, and ftools 2.49.1 versions and locations recorded as the checked environment baseline.

Validation to perform later:

- After deliberate dependency preparation, use a bounded agent-owned which/help metadata check to confirm exact names, locations, and versions; do not run author models or datasets as a package check.


## Remaining issues and prerequisites

- I_EDGAR_MAP [unresolved; full_pipeline]: The supplied workflow needs a separate EDGAR Phase-in Groups input with CIK-to-phase_in assignments. The datasheet names SEC Release No. 33-6977 as a phase-in schedule source, but does not establish the producer, full group population, or compatibility of that source with the file the code merges.
- I_Q_COMP_FIELDS [unresolved; full_pipeline]: The code reads sic from the quarterly analysis input, but the selected successful probes of the local COMP.FUNDQ candidate have not established that field and the supplied driver contains no sic-producing join. The author-named quarterly DTA is absent, so its exact field producer and compatibility remain unresolved.
- I_Q_COMP_HISTORY [unresolved; full_pipeline]: The code filters quarterly Compustat to fyearq 1990-2000 and uses within-firm lead/lag terms; selected one-row probes of the local COMP.FUNDQ candidate do not establish that date coverage or population.
- I_ANNUAL_COMP_HISTORY [unresolved; full_pipeline]: The supplied annual screen keeps nonmissing AT records for 1992, then the latest datadate per GVKEY; a one-row local COMP.FUNDA probe does not establish 1992 observations, population, or equivalence to the author-prepared DTA.
- R_Q_COMP [undetermined]: Quarterly Compustat source read at data/sources/20191009 Compustat data (quarterly).dta for the variable construction and the CIK-GVKEY crosswalk.
- R_EDGAR [undetermined]: EDGAR phase-in group file consumed at data/sources/20190930 EDGAR Phase-in Groups.dta; it supplies CIK-to-phase_in assignments that are not generated by the supplied do-file.
- R_ANNUAL_COMP [undetermined]: Annual Compustat source read at data/sources/20191009 Compustat data (annual).dta to construct the 1992 assets eligibility screen.
- SW_OUTREG2 [preparation_required]: outreg2 was not found in the checked default and shared adopaths; prepare or locate this dependency before attempting the supplied workflow.
- SW_PSMATCH2 [preparation_required]: The bounded Stata 18 which query returned 111 for psmatch2, so it was not found in the checked adopath; prepare or locate this dependency before attempting the supplied matching branch.

## Review notes

- This assessment covers the supplied Codes for JAR.do workflow for main Table 2, including its baseline Panels A/B and stacked Panel C branches. The frozen datasheet title and DOI match the output header. The supplied identifier_gvkey.txt is an identifier list, not an analysis dataset. Other datasheet-wide CRSP, IBES, CPI, FOIA, and SAS origins are contextual unless an actual supplied consumer requires them; appendix tables do not add an executable branch or a publication-stage gate. The trace and dependency review retain all seven frozen dependency IDs and the generated intermediates. closure_complete records source-graph identification; execution_verified remains false and data/software preparation remains outstanding.
- The local COMP.FUNDQ candidate is the frozen Merged Fundamental Quarterly File. Successful row-limit-1 metadata reads confirm the selected GVKEY, quarter/date, financial, and CIK columns, but do not establish the required 1990-2000 population or lead/lag history. The successful requests did not test sic, and the supplied driver has no demonstrated sic-producing join; its field producer remains unresolved. The author-named quarterly DTA is absent from the package inventory. A compatible author-prepared file is a valid route; the local SAS candidate would need Stata-format preparation and compatibility checks. No license absence is inferred.
- The local COMP.FUNDA candidate is the frozen Merged Fundamental Annual File, and the bounded row read confirms gvkey, datadate, and at. It does not establish 1992 AT population, the latest-datadate-per-GVKEY screen, or equivalence to the author-named annual DTA, which is absent from the package inventory. A compatible author-prepared file or ordinary local SAS-to-Stata preparation may be considered, followed by the required coverage checks. No original-byte requirement is inferred.
- The official static SEC overview documents Release 33-6977 and historical phase-in schedules, but it does not provide the code-consumed CIK/phase_in table schema, group population, or the mapping to the ten inline cohort dates. The public route remains unverified; a compatible author-prepared group file is an acceptable primary route. No independent group reconstruction is asserted.
- The saved Stata checks report Stata 18, reghdfe 6.12.3, and ftools 2.49.1 available; winsor was found by which but its version was not returned. psmatch2 returned which code 111 and outreg2 was not found in the checked adopaths, so both require preparation or location before an authorized attempt. No package was installed and no author code, datasets, estimator, or statistical analysis was executed.
- Process history only: the grouped COMP.FUNDQ outer capture was written to the preserved outside-generation path historical artifact comp_fundq_probe_command_result.json and byte-identically copied to historical artifact comp_fundq_probe_command_result.json; each has SHA-256 afeb8ae5d92a466e81752e0a3fa92dd162603e406aef91f242fccf6890199505. Its captured argv was ["python3", "historical artifact feasibility.py", "probe", "--catalog", "historical artifact catalog.json", "--request", "historical artifact comp_fundq_probe_request.json", "--output", "historical artifact comp_fundq_probe.json"], cwd was git, process status was 0, stdout was exactly the local comp_fundq_probe.json path followed by a newline, and stderr was empty. No prior-file existence/overwrite check was captured, so no claim is made about whether a prior file was overwritten; both copies remain preserved.
- Other process-only artifacts remain preserved: probes/attempt_record_capture_wrapper_misuse.json (SHA-256 ea7b189de921883ce799c9a64a67295586a1b7a5f20f1a7a2004714b27a376c5) records the wrapper being given a raw request and raising KeyError for argv before a probe ran; exact return code and separate streams were not surfaced. probes/attempt_record_archive_copy_misuse.json (SHA-256 fb686571190766507a82c47c31c04bd5acb0aa86f9800e39aae093422094853e) records a malformed archive-copy attempt and target-not-found output; exact return code and separate streams were not surfaced. The unexecuted malformed descriptor probes/comp_fundq_fields_b22_capture_request.json (SHA-256 39b4b6f8c428af686f14c5d8444b52c31578475bba1141e8fea0776fde3ca3cb) and corrected descriptor probes/comp_fundq_fields_b22_capture_request_corrected.json (SHA-256 1b4e1abe022c7c0aceb9cad1871b97cb740ab7a32c39b6465af5f5f4c2626ec2) are retained. The unsuccessful selected-field outputs probes/comp_fundq_probe.json (SHA-256 af2c905bdf98c0a6622a1afd2011cc752fe73ea17bc128e9efe5294b26b73a0a), probes/comp_fundq_fields_b_probe.json (SHA-256 307b02baeb08c3676f1f3b8375f328f5516cb048d360a9a15cde609db53f1a28), probes/comp_fundq_fields_b2_probe.json (SHA-256 2cb349e15a698978230c88f17d68a0d34945bb7bca6133c8f6ee0103d736b74c), and probes/comp_fundq_sic_probe.json (SHA-256 0f002bf0a1b7d1380844a2b5f0de16cdec45ab783c72d460db8dc5798c0e4d93) are unverified process outputs with generic requested-field errors. These process artifacts are not cited as scientific evidence and do not establish source-field absence, licensing status, or data unavailability.
