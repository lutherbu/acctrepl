# Patch proposal: jar-97ed7b0e0de6

The Effect of Federal Judicial System on Public Enforcement: Evidence from SEC Enforcement Actions

DOI: 10.1111/1475-679X.12571

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow with all five SAS preparation programs, the Stata PCA handoff, and downstream Stata analyses. Table 4–6, Table 7 accrual and ICW, and Table 8 late-filing branches remain in scope.

Entry points: `A_courteffmeasure.sas`, `B_restatementdata.sas`, `C_DistrictState_control.sas`, `D_FRQ_accrual.sas`, `E_latefiling.sas`, `stata_code_YJ.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 1/12571 - The-Effect-of-Federal-Judicial-System-on-Public-Enforcement-Evidence-from-SEC-Enforcement-Actions/jia-datasheet-code-identifier-and-log-files.zip",
      "sha256": "2866c621eb932d68964850d5610bce96b712a4f27704fe8a5010bb55886cfb95"
    },
    {
      "path": "JAR-Volume 63/Issue 1/12571 - The-Effect-of-Federal-Judicial-System-on-Public-Enforcement-Evidence-from-SEC-Enforcement-Actions/jia-internet-appendix.pdf",
      "sha256": "e366c9ae090952525973a11e419298b324bb9912dc0eb45f73543987f7c3d1b6"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "996818b1f1af6b0b6ca67daf8d1dcde28b758b13ba6cdcf5c51eeb7c34ff99c8"
}
```

## Proposed actions

### act_resolve_input_contracts: Resolve all 23 independent data-input contracts using either the currently named file or compatible local/public underlying data plus source-supported mapping, conversion, or preparation. The assessment does not require original bytes or a historic vintage, and does not mark any alternative route verified.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: req_court_efficiency_raw, req_judge_retirement, req_restatement_dates, req_enforcement_panel, req_comp_all, req_crsp_msd, req_enforcement_zip, req_state_controls, req_sec_budget, req_final_age, req_pop_income_county, req_employment_county, req_va_manual_crosswalk, req_religion_county, req_county_district_crosswalk, req_comp0408, req_rest_zip_crosswalk, req_sox404_icw, req_classaction, req_circuit_judges, req_late_filing, req_latefile_zip_crosswalk, req_eff_final_e, iss_input_closure
Evidence: ev_work_item_inventory, ev_datasheet_wrds_source, ev_datasheet_public_sources, ev_datasheet_controls_late, ev_datasheet_va_manual, ev_catalog_comp_candidate, ev_catalog_crsp_candidate_1, ev_catalog_crsp_candidate_2, ev_sas_stat_descriptor_copy

Preparation / proposed procedure:

1. For each of the 23 distinct input requirements, identify the code-named file or a compatible underlying source. Treat filenames as current code path references, not as original-byte or vintage requirements.
2. Record source fields, identifier/date/year keys, history, coverage, and each supported transformation. Keep unknown contracts explicitly unverified until those details match.
3. Keep comp_all_2023.sas7bdat and comp0408.sas7bdat as distinct logical panel requirements, all three ZIP/court crosswalks separate, and E's eff_final_20231213.xlsx distinct from the Stata PCA workbook. A shared underlying source may support multiple requirements only through supported, separately documented constructions.
4. For the CRSP input currently named msd.sas7bdat, confirm the actual frequency, sequence construction, security/event keys, return field, and event/pre-event windows. CRSP.MSF and CRSP.DSF remain unverified product candidates; neither is presumed equivalent.
5. Retain the documented Virginia county mapping and the source-required religion years. Compatible source data and a supported mapping/conversion may satisfy those contracts without preserving the author's original workbook bytes.

Validation to perform later:

- Verify that the selected source or supported transformation supplies each full input contract, including all observed field, key, history, and coverage requirements; do not use original-file identity as the criterion.
- Keep every independent panel/crosswalk/E efficiency requirement separate and leave any unverified route unresolved.

### act_configure_portable_paths: After compatible sources are identified, configure a portable working copy so all SAS and Stata source references resolve to the staged complete inputs and expected generated outputs. Preserve source filenames and independent input boundaries.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: iss_path_configuration
Evidence: ev_work_item_inventory, ev_safe_source_path_map

Preparation / proposed procedure:

1. Stage all selected source files under the assigned working directory and set one explicit root for the author inputs and generated products.
2. Map each source read/write basename from the frozen dependency inventory to the staged file or in-workflow producer; preserve the separate crosswalk and efficiency input names.
3. Keep the Windows author-root paths out of any unreviewed source edit; propose a path-only configuration change for review before applying it.

Validation to perform later:

- Check every frozen path edge resolves to its verified compatible input contract or supported producer output before any program execution.
- Check that no generated output basename collides with a distinct author-provided input.

### act_provision_software: Provide an authorized environment with SAS for the five preparation programs and Stata with the exact required ado packages. SAS availability is unverified; winsor2 and outreg2 are not located, while Stata, reghdfe, and ftools are present in the registered probe. SAS/STAT PROC REG capability is handled by a separate same-scope clarification action.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: sw_sas, sw_stata, sw_winsor2, sw_reghdfe, sw_ftools, sw_outreg2, iss_software_environment
Evidence: ev_environment_probe, ev_stata_pca

Preparation / proposed procedure:

1. Confirm an authorized SAS runtime is available for all five preparation programs and supports the operations used by the source; do not rely on old logs as current availability proof.
2. Provision winsor2 and outreg2 in the intended Stata environment, retaining the exact names called by the source.
3. Record verified Stata, reghdfe, and ftools versions in the approved environment record before execution.

Validation to perform later:

- Use the approved typed environment check for exact software names and versions; do not start SAS or run author code as part of this metadata assessment.

### act_propose_source_corrections: Prepare three narrowly scoped source corrections for review: change `the` to `then` in both Los Angeles mappings, and prefix the existing Stata same-variable division by 10 with `replace`. These preserve the authored office-6 mapping and scaling expression; no edits were applied.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: iss_sas_if_typo, iss_stata_bare_assignment
Evidence: ev_B_sas_typo, ev_E_sas_typo, ev_stata_scale_command

**Proposed edit:** `B_restatementdata.sas:258–258`
Source SHA-256: `f9f663bbb745ec52f89b6686ae16f594bb39a448d96dfd407c4137862934214c`

The literal `the` interrupts the adjacent SAS IF/THEN office mapping; this supported token correction preserves office 6.

Current text:
```
if LosAngeles =1 the office = 6;
```

Proposed replacement:
```
if LosAngeles =1 then office = 6;
```

**Proposed edit:** `E_latefiling.sas:285–285`
Source SHA-256: `2d1a0f00cb6791e6880c66f868b687820beaabc7284802bd2f3b8caa22d876c7`

The same source-token defect appears in E; the adjacent mapping uses THEN and office 6.

Current text:
```
if LosAngeles =1 the office = 6;
```

Proposed replacement:
```
if LosAngeles =1 then office = 6;
```

**Proposed edit:** `stata_code_YJ.do:109–109`
Source SHA-256: `f43015f551e66394a837f4e7dbb11b10d97f3d048091cb2610f4e2fcd2199e3a`

Prefix the existing same-variable scaling with Stata's replace command while preserving the authored division by 10; no new variable or random draw is supported.

Current text:
```
new_avg_pc2_w  = new_avg_pc2_w /10
```

Proposed replacement:
```
replace new_avg_pc2_w = new_avg_pc2_w /10
```

Preparation / proposed procedure:

1. Keep the three edits as unapplied proposals until a working copy is approved.
2. Preserve the original author files and the exact pre-edit hashes.

Validation to perform later:

- Review the three exact before/after lines against the hash-bound source evidence; the assessment did not compile or execute either language.

### act_stage_native_workflow: Stage the author workflow around the PCA handoff. Run A first; run only the Stata PCA preamble after A to produce A_effmeasure_final.xlsx; run C before its B/D/E consumers; run all B, D accrual and ICW, and E late-filing branches; then run the downstream Stata analyses for Tables 4–8 after their datasets exist.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: iss_stage_order
Evidence: ev_A_eff2_export, ev_stata_pca, ev_B_pca_join, ev_C_control_output, ev_D_dynamic_trim, ev_safe_source_path_map, ev_readme_workflow, ev_D_proc_reg

Preparation / proposed procedure:

1. Run A_courteffmeasure.sas to produce the Stata court-efficiency input and A judge-vacancy output.
2. Run the Stata PCA preamble that consumes eff_measure_A.dta and exports A_effmeasure_final.xlsx; stop before the downstream analysis blocks.
3. Run C_DistrictState_control.sas to produce final_county_control, then run B_restatementdata.sas and D_FRQ_accrual.sas with the PCA workbook available.
4. Run E_latefiling.sas with its distinct eff_final_20231213.xlsx input; retain the Table 8 branch alongside B Tables 4–6 and D Table 7 accrual and ICW branches.
5. After B_restate_enforcement.dta, D_FRQ_accrual.dta, D_FRQ_ICW.dta, and E_latefilng.dta exist, run the downstream Stata analysis sections for Tables 4–8.

Validation to perform later:

- Confirm the producer/consumer basename map and exact stage prerequisites before execution; no source, dataset, or model execution is included in this assessment.

### act_clarify_sas_stat_proc_reg: D_FRQ_accrual.sas lines 241–244 call PROC REG. Confirm the authorized target SAS environment includes SAS/STAT PROC REG capability; current installation and licensing status are unverified.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: sw_sas_stat, iss_software_environment
Evidence: ev_D_proc_reg, ev_sas_stat_primary, ev_sas_stat_descriptor_copy, ev_environment_probe

Preparation / proposed procedure:

1. Before the Table 7 accrual branch is run, obtain an authorized environment-owner confirmation that PROC REG from SAS/STAT is available for the target run.
2. Keep the official manual excerpt as procedure-family documentation only; do not infer installed or licensed capability from it.

Validation to perform later:

- Record environment capability through the approved software metadata process without starting SAS or invoking PROC REG in this assessment.


## Remaining issues and prerequisites

- iss_input_closure [unresolved; full_pipeline]: The six supplied programs reference 23 distinct data inputs that are absent from this assigned package. This establishes package omission only; no access prohibition, irreparable source failure, or required unlicensed resource is confirmed. Compatible local or public underlying data plus source-supported mapping, conversion, or preparation may satisfy each contract after fields, keys, history, and coverage match. The specific unverified field/key/history/construction questions remain in the separate requirements.
- iss_sas_if_typo [preparation; full_pipeline]: B_restatementdata.sas line 258 and E_latefiling.sas line 285 each contain `the` in the Los Angeles office mapping where adjacent lines use `then`; the branch value remains office 6.
- iss_stata_bare_assignment [preparation; full_pipeline]: stata_code_YJ.do line 109 contains a same-variable scaling expression without a Stata command. A supported same-variable `replace` edit can preserve the authored division by 10; no generated variable or new random draw is supported.
- iss_path_configuration [preparation; full_pipeline]: The frozen dependency inventory records author-machine absolute paths for inputs and outputs. Configure a portable path mapping after compatible sources have been selected and staged; no path edits were applied.
- iss_stage_order [preparation; full_pipeline]: The Stata file first consumes A's eff_measure_A.dta and creates the PCA workbook imported by B and D, then later consumes B, D, and E outputs. The workflow therefore requires a PCA preamble before SAS consumers and the downstream Stata analysis after B/D/E outputs exist.
- iss_software_environment [unresolved; full_pipeline]: SAS availability and SAS/STAT PROC REG capability are unverified. The exact-name Stata probe did not locate winsor2 or outreg2; the exact-name Stata, reghdfe, and ftools findings remain as recorded. No software was started or installed.
- req_court_efficiency_raw [undetermined]: A_courteffmeasure.sas imports the workbook currently named by its source path from Sheet1 with GETNAMES=YES. It supplies the court-efficiency construction used by the Stata PCA; the full workbook schema and year coverage were not available to verify. Current code path basename: court_eff_0320_final.xlsx. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_judge_retirement [undetermined]: A_courteffmeasure.sas imports this distinct Sheet1 workbook and uses it to construct the judge-vacancy output. Match the judge/court/date join keys and all years used by A; the workbook fields and coverage were not independently validated. Current code path basename: 20200616_judge_retire.xlsx. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_restatement_dates [undetermined]: B_restatementdata.sas reads this separate cleaned restatement-date workbook. The required event identifiers, date field, and source history must match B's joins and filters; the full workbook schema is absent. Current code path basename: 2020_0603_rsdate_clean.xlsx. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_enforcement_panel [undetermined]: B and E independently read the same logical enforcement panel. Keep its enforcement case identifiers, filing dates, and source-provided venue fields intact; confirm the required keys, years, and row granularity from the selected source before any join. Current code path basename: 20210831_matchfull_2.xlsx. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_comp_all [undetermined]: B, D, and E read this separately named Compustat panel, which is separate from comp0408.sas7bdat. D filters CONSOL='C', INDFMT='INDL', DATAFMT='STD', POPSRC='D', and FIC='USA'; retain GVKEY, DATADATE, and FYEAR plus the financial fields used by the scripts. Required coverage and author preparation remain unverified. Current code path basename: comp_all_2023.sas7bdat. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_crsp_msd [undetermined]: B and E read the CRSP input currently named by the code. The source filters date to 1993 onward and indexes returns in event-relative sequence windows (dseq_id around the event and a pre-event window); confirm the actual frequency, sequence construction, return field, security/event keys, and history. Frozen catalog MSF/DSF entries are not verified equivalent inputs; a compatible underlying series plus supported sequence construction may satisfy this contract after field/key/history matching. Current code path basename: msd.sas7bdat. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_enforcement_zip [undetermined]: B reads this enforcement ZIP/court mapping workbook. It is a distinct crosswalk from D's and E's files; preserve the source's required ZIP-to-state/district/year mapping and confirm sheet, key, and historical coverage from the selected data source. Current code path basename: 2020_0528_enf_zip.xlsx. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_state_controls [undetermined]: B, D, and E read the same logical state-control panel. The SAS joins use state/district/year keys and fields including ws_incomegr, ws_unemprate, ws_regrate, and total_pop; preserve the relevant sheets and years. Current code path basename: state_data_final_0527.xlsx. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_sec_budget [undetermined]: B reads this separate SEC budget workbook. The budget measure, time key, sheet, and coverage are author-input contracts and were not available in the package inventory. Current code path basename: sec_budget.xlsx. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_final_age [undetermined]: B, D, and E read the same logical firm-age dataset. D and E join by GVKEY and use FYEAR to calculate age; retain the complete firm/year history needed for those joins. Current code path basename: final_age.sas7bdat. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_pop_income_county [undetermined]: C imports this Sheet1 county population/income workbook to construct district controls. Preserve the county and year join keys and the source-specific population/income measures; the full workbook schema is absent. Current code path basename: pop_income_county.xlsx. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_employment_county [undetermined]: C reads county employment data and derives fips from state and county plus numeric year2 from year; retain the source state, county, and year fields and the employment/unemployment measures used by C. Current code path basename: emp_data_2023.sas7bdat. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_va_manual_crosswalk [undetermined]: C imports this author-prepared Virginia reconciliation workbook. The datasheet documents manual BEA county reconciliation as the sole manual cleaning exception; use the documented Virginia mapping or a compatible source-supported reconstruction; do not infer it from masked source views. Current code path basename: va_missing.xlsx. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_religion_county [undetermined]: C imports the four named sheets 1990, 2000, 2010, and 2020 and uses county fips, year, and regrate. Keep each sheet and all four years in the resulting panel. Current code path basename: religion_county.xlsx. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_county_district_crosswalk [undetermined]: C imports the sheet named collect_county_court2 for county-to-federal-district mapping. This is distinct from all ZIP crosswalks; retain the county, state, and district mapping and coverage. Current code path basename: collect_county_court2.xlsx. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_comp0408 [undetermined]: D reads this distinct prepared Compustat accrual panel, filters Compustat format flags, and uses firm/year financial fields in the accrual and cash-flow constructions. Retain GVKEY, DATADATE, FYEAR, the rows satisfying the code's filters, and the history needed for current plus prior four fiscal-year calculations; do not conflate it with comp_all_2023.sas7bdat. Current code path basename: comp0408.sas7bdat. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_rest_zip_crosswalk [undetermined]: D reads a separate restatement ZIP-to-district crosswalk. Preserve this separate D ZIP/state/district/year mapping contract. Do not conflate it with B/E crosswalks; another source can satisfy it only after field/key/history matching. Current code path basename: 2020_0607_rest_zip.xlsx. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_sox404_icw [undetermined]: D reads this separate SOX 404 internal-control weakness input for the Table 7 ICW branch and exports D_FRQ_ICW.dta. Retain the firm/year keys and source-defined ICW field and verify the panel coverage from the actual prepared dataset. Current code path basename: sox404_2024.sas7bdat. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_classaction [undetermined]: D imports Sheet2 of the class-action workbook currently named by the code and derives year_f from filingdate; source code uses ticker and filingdate. Keep the authored class-action events and source history. Current code path basename: classaction_data_final.xlsx. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_circuit_judges [undetermined]: D imports Sheet3 and Judge_clean2. It joins by circuit and year to judge commission/termination years and uses judge names and appointing-president fields; preserve those sheet-level fields or a compatible mapped extract and the full term history. Current code path basename: circut_judge_ideology.xlsx. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_late_filing [undetermined]: E reads the SeekEdgar late-filing input currently named by the code and uses FORM, FDATE, and CIK; it derives fiscal-year filing counts and applies two prior-year lags, with FDATE year capped at 2010. Current code path basename: late_filing.sas7bdat. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_latefile_zip_crosswalk [undetermined]: E reads its own late-filing ZIP-to-district crosswalk, distinct from B's and D's mapping workbooks. Preserve E's separate ZIP/state/district/year mapping contract and verify its required years. Current code path basename: 2020_0602_latefile_zip.xlsx. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- req_eff_final_e [undetermined]: E imports this distinct Sheet1 court-efficiency input. It is a distinct E efficiency input, not the Stata PCA workbook A_effmeasure_final.xlsx. Do not presume equivalence; a compatible source may satisfy E only after field/year matching. Current code path basename: eff_final_20231213.xlsx. The current code path name is not an original-byte or vintage gate: a compatible local/public source plus a source-supported mapping, conversion, or preparation may satisfy the same contract after fields, keys, history, and coverage are verified; no alternative is currently verified.
- sw_sas [unverified]: Five supplied preparation programs are SAS. The registered exact-name environment probe reports SAS as unavailable with status unverified; no SAS executable, startup, version, autoexec, or host wrapper was invoked.
- sw_winsor2 [preparation_required]: The exact-name probe did not locate winsor2; the supplied Stata preamble and analysis invoke it. No install or source run was attempted.
- sw_outreg2 [preparation_required]: The exact-name probe did not locate outreg2; the supplied Stata program uses it for table output. No install or source run was attempted.
- sw_sas_stat [unverified]: D_FRQ_accrual.sas actively calls PROC REG for grouped accrual construction. SAS/STAT is the documented procedure family; availability and licensing in the intended environment remain unverified, and no SAS process was started.

## Review notes

- Assessment is limited to the assigned jar-97ed7b0e0de6 generation_001; no other package or generation was read or used.
- All 21 assigned sources were read by content through the screened source/document readers. The eight logs remain opaque; their bodies were not used as current environment, data-availability, or scientific-result evidence.
- The four identifier spreadsheets were only structurally inspected and are identifier lists, not the complete analysis panels. The internet appendix was read in full for scope context; unprovided supplemental analyses were not added to the supplied workflow.
- All 44 frozen dependency IDs are dispositioned: 31 external edges map to 23 distinct whole-file requirements, and 13 edges are linked to direct in-code producers or dynamic SAS WORK intermediates. No unrelated catalog product was accepted as an equivalent input.
- The source-to-output map is A to Stata PCA to SAS consumers: A exports eff_measure_A.dta, the Stata preamble creates A_effmeasure_final.xlsx for B and D, C creates final_county_control for B/D/E, and the downstream Stata analyses consume the B, D accrual, D ICW, and E outputs.
- No author source was imported, executed, compiled, or parsed; no datasets/models/statistical/descriptive/synthetic trials were run; no data were imported, downloaded, or deserialized; no SAS executable/startup/version/autoexec was invoked; no packages were installed; no source edits were applied; no outgoing message, acceptance, or publication occurred.
- A preliminary wrapper call with a cwd outside generation_001 failed before child launch and was replaced by the saved fixed viewer runner. A later unqualified `python` shell command reported `python: command not found`; the helper was then invoked only through python3. Those shell failures are not represented as reconstructed stream artifacts.
- One capture-wrapper preflight used an invalid input-snapshot path and failed before child launch, so it wrote no result artifact; its actual shell trace remains in the turn transcript and has not been reconstructed.
- The first captured builder run returned status 1 from a source_evidence argument collision; its actual stderr and status are preserved in probes/build_assessment_exec.json. The builder source was versioned before correction and the next captured build succeeded.
- The initial read-only metadata preflight returned status 2 because three source quotes lost trailing spaces in the screened rendering and the draft carried a closed-schema extra field on each requirement. The exact report is preserved in probes/preflight_metadata_exec.json; these were submission-metadata defects, not author/data barriers, and no source files changed.
- The first pinned read-only finalizer invocation returned child status 2 because one or more generated dependency reviews lacked source-kind evidence for the producer. The exact run record and stream hashes are preserved in probes/controller_readonly_20261112T024835204748Z/run.json; direct B/D/E producer excerpts and safe output-name mapping are now included, with no source edits or data execution.
- Coordinator source-QA calibration: package omission is unresolved rather than a confirmed access/repair barrier. The 23 separate input contracts permit compatible local/public underlying data with supported transformations; no route or candidate is verified and original bytes/vintage are not required.
- D_FRQ_accrual.sas lines 241–244 call PROC REG; SAS/STAT is recorded as required but unverified. The copied official SAS/STAT guide excerpt is documentation only, not installed/license proof. No literal esttab call appears in the six registered code files, so esttab is not a mandatory dependency.
