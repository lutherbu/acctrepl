# Patch proposal: jar-bb8dc104120f

Family Matters: Exploring the Link Between Parental and Executive Financial Misconduct

DOI: 10.1111/1475-679X.70028

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

All 27 supplied SAS preparation/construction programs in their traced producer-consumer order, the four documented Final_data_merging passes, and the supplied Stata analysis syntax. Required data inputs, the D0175 producer, and the exact SAS-to-Stata output mapping remain unverified.

Entry points: `KKLMN-datasheet, code, and log files/Code/Additional_demographic_variables_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/All mental_diagnosis_data_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/All_parents_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Biological_parents_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/CEO_Position_data_Asiakastieto_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/CEO_Position_data_PRH_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Crime_data_for_parents_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Crime_rates_as_minors_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Data_structure_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Demographic_data_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Education_data_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Familymembers_on_board_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Final_data_merging_for analysis_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Financial_statements_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Income_data_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Initial_sample_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Main_data_merging_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Mental_diagnosis_1996_2022_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Municipality_crime_data_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Other_executive_crimes_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Ownership_data_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Parents_data_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Person_crime_data_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Position_data_Asiakastieto_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Position_data_PRH_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Social_parents_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Spouses_data_JAR.sas`, `KKLMN-datasheet, code, and log files/Code/Spouses_data_for_analyses_JAR.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 2/70028 - Family-Matters-Exploring-the-Link-Between-Parental-and-Executive-Financial-Misconduct/kklmndatasheetcodeandlogfiles.zip",
      "sha256": "390e71a1aac50dc16e2115cfebed89153fb24b059c6bc7953ed93c1241c3eda4"
    },
    {
      "path": "JAR-Volume 64/Issue 2/70028 - Family-Matters-Exploring-the-Link-Between-Parental-and-Executive-Financial-Misconduct/kklmn-online-appendix.pdf",
      "sha256": "ef2ad867f28a6f5755a9cc7b91a0b9362711fc45c30263fb3d513f3e6eeacf43"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "941c035d127c6d8e917d89c07f39171a2417825bba74ed8c9cdce33c2826edf6",
  "work_item_sha256": "31cc08901c378eb57296e13a465bc20d015d7fa02b3c97e29473e4aa08c2990c"
}
```

## Proposed actions

### a_resolve_raw_access_and_contracts: Resolve each separately recorded source-table contract and its approved access route. Use the documented application route only as a lead until each table alias is mapped to its actual agency/product, identifier scheme, fields, periods, and full coverage.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: r_raw_asiakastieto_positions, r_raw_biological_parent_links, r_raw_birth_municipality, r_raw_convictions_1992_2019, r_raw_financial_statements, r_raw_historical_municipality, r_raw_icd10_reference, r_raw_inpatient_diagnoses_1969_1986, r_raw_inpatient_diagnoses_1987_1993, r_raw_inpatient_diagnoses_1994_1995, r_raw_inpatient_diagnoses_1996_2022, r_raw_municipality_crime_workbooks, r_raw_offense_details_1977_2022, r_raw_outpatient_diagnoses_2011_2022, r_raw_outpatient_diagnosis_codes, r_raw_parent_register_links, r_raw_person_demographics, r_raw_person_income, r_raw_prh_board_law_records, r_raw_prh_board_registry_records, r_raw_shareholder_ownership_2006_2019, r_raw_spouse_links, r_raw_total_shares_2006_2019, i_raw_source_access_contracts, i_author_copy_barrier
Evidence: e_datasheet_application, e_datasheet_nda, e_datasheet_proprietary, e_package_inventory

Preparation / proposed procedure:

1. Request a source-to-table crosswalk for the listed financial-statement, income, demographic, historical municipality, family-link, spouse-link, health, tax-share, conviction, offense-detail, and PRH/Asiakastieto inputs; preserve separate product contracts and annual partitions.
2. For each table, confirm the source provider, application route, fields/types, identifier/linkage meanings, year coverage and history, units, and any role/code or municipality crosswalk required by the supplied transformations.
3. For the eleven municipality crime-rate workbooks, identify the authoritative public release and verify year/municipality/category/units before using an alternative source; no URL or substitute is presently verified.
4. Do not request or redistribute the authors' Statistics Finland data copies; the data sheet states that the authors' NDA prohibits third-party sharing of covered data.

Validation to perform later:

- Compare the approved delivered fields and identifier mappings with the exact SAS statements cited for each grouped input and confirm all required years/period partitions are present.
- Keep access approval, delivery format, and population/history coverage separate; a catalog match or one-row read alone does not establish coverage.

### a_resolve_final_sas_stata_handoff: Establish the exact outputs of the four Final_data_merging runs and map every Stata import block to its SAS producer. Resolve D0175's stata_talous_011025 producer without reconstructing masked paths.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: r_stata_talous_input, i_final_analysis_handoff, i_stata_talous_producer, i_screened_source_coverage
Evidence: e_readme_four_datasets, e_stata_import_syntax, e_stata_analysis_code, e_dep_D0038, e_prod_main_panel_998, e_dep_D0175

Preparation / proposed procedure:

1. Obtain an unmasked author-confirmed output-to-import crosswalk for the four Final_data_merging runs, including run settings, output names, directory, required columns, and exact Stata import blocks.
2. Identify the active producer, schema, and role of stata_talous_011025.sas7bdat; confirm whether it is a final-merge output or a distinct prepared dataset.
3. Confirm the exact library used by the D0134 consumer against the direct same-named producer; its screened consumer line is unavailable, so the metadata name match does not settle the library contract.
4. If an author-prepared analysis dataset is offered, verify that its schema and period cover the exact Stata code before considering an analysis-only route.

Validation to perform later:

- Confirm every Stata import has one compatible supplied producer or an explicitly documented acquisition route, and verify all four final outputs against their intended analyses before any future execution.

### a_verify_required_runtime_components: Verify the required SAS runtime, SAS XLSX import capability, Stata installation, and `ebalance` command in an authorized research environment. No software was installed or started during this assessment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw_sas, sw_sas_xlsx_import_support, sw_stata, sw_ebalance, i_runtime_capabilities_unverified
Evidence: e_original_environment_probe, e_datasheet_sas_workflow, e_stata_analysis_code, e_dep_D0085

Preparation / proposed procedure:

1. Confirm SAS can start under the approved secure environment and check whether PROC IMPORT supports the required XLSX DBMS/engine; do not assume base SAS availability covers that extension.
2. Confirm Stata 18 is the environment to use and check whether the `ebalance` command is installed and callable; if unavailable, follow institution-approved setup instructions.
3. Record runtime and package versions without executing the study programs until all data routes and the SAS-to-Stata handoff are resolved.

Validation to perform later:

- Compare later successful availability evidence to the exact runtime and command names in the assessment; validate compatibility only in a separately authorized execution stage.


## Remaining issues and prerequisites

- i_raw_source_access_contracts [unresolved; full_pipeline]: The supplied SAS workflow reads distinct financial, tax, demographic, family-link, health, criminal, position-register, and municipality crime-rate inputs. The source table aliases and code-level minimum fields/periods are recorded, but exact provider-to-product mapping, delivery/access conditions, identifier semantics, full history, and compatibility have not been verified. The datasheet's application route is a general lead and is not mapped to each input.
- i_author_copy_barrier [preparation; full_pipeline]: The authors' copy of the Statistics Finland study data is not a shareable acquisition route: the data sheet says their NDA prohibits sharing covered data with third parties. The documented agency-application route remains a separate unverified alternative, so this barrier does not establish that all access routes are blocked.
- i_final_analysis_handoff [unresolved; full_pipeline]: The README documents four final merge passes and repeated SAS imports in the Stata syntax, but the exact four output names and import-to-producer mapping are not established from the screened source views. Final_data_merging_for analysis_JAR.sas contains a withheld source block at lines 1032-1033, which remains a coverage unknown rather than evidence of a defect or absent program.
- i_stata_talous_producer [unresolved; full_pipeline]: D0175 reads stata_talous_011025.sas7bdat, but no active producer is established in the visible screened code. The exact producer and whether it is one of the four Final_data_merging outputs remain unresolved.
- i_screened_source_coverage [unresolved; full_pipeline]: The registered source screen withheld a large Person_crime_data_JAR.sas span (lines 1300-1347), Final_data_merging lines 2 and 1032-1033, and Stata import path tokens. It also withheld the D0134 consumer line in Parents_data_JAR.sas:215; the registered target name matches a direct producer, but its consumer library cannot be confirmed. These specific gaps prevent confirmation of hidden statements or path mappings; no absence or author defect is inferred.
- i_runtime_capabilities_unverified [unresolved; full_pipeline]: SAS is unverified in the original registered environment metadata; availability of XLSX import support and the Stata `ebalance` command is also unverified. Stata 18 itself is available. No author program or statistical procedure was run.
- r_raw_financial_statements [undetermined]: The `tp8623` firm financial-statement table read by Financial_statements_JAR.sas. Code uses firm identifiers, fiscal year, and accounting fields to construct `tilinpaatokset_kaikki_080622`; the source product definition, provider, units, and full coverage require confirmation.
- r_raw_person_income [undetermined]: The `henkiloverotus_9_s` person-income table read by Income_data_JAR.sas. The supplied code selects `shnro`, `vuosi`, `svatva`, `svatv`, and `svatvp` before constructing the normalized income input; product/provider, units, and coverage need confirmation.
- r_raw_person_demographics [undetermined]: The `demografiset_9_s` person-year demographics table used by Demographic_data_JAR.sas and Education_data_JAR.sas. Code uses person ID, year, sex, age, citizenship, marital/family/employment fields, and education codes; provider, full fields, and coverage need confirmation.
- r_raw_historical_municipality [undetermined]: The historical person-year municipality table `u0599_9_kaikki_akunta_71_86_s`, used for 1971-1986 location and childhood-crime construction. Native municipality coding and coverage are unverified.
- r_raw_birth_municipality [undetermined]: The birth-municipality table `u0599_9_kaikki_skunta_s`, used by Demographic_data_JAR.sas and Parents_data_JAR.sas. Code uses `shnro` and `skunta`; provider, municipality code history, and coverage are unverified.
- r_raw_biological_parent_links [undetermined]: The child-to-parent identifiers in `u0599_kohdj_laps_s`, used by the biological- and social-parent constructions. The source uses `shnro` with biological parent identifiers and social-parent identifiers; the exact provider schema and population coverage need confirmation.
- r_raw_parent_register_links [undetermined]: The parent-side identifiers in `u0599_kohdj_vanhemmat_s`, used together with the child-side table in biological- and social-parent constructions. Exact provider schema and population coverage need confirmation.
- r_raw_spouse_links [undetermined]: The spouse-link table `u0599_kohde_puoliso_87_22_s`, used by both spouse construction programs. The code links the study person to `puolison_shnro` by year; identifiers, relationship timing, and completeness need confirmation.
- r_raw_inpatient_diagnoses_1996_2022 [undetermined]: The `suoj_u0599_hilmo` hospital-diagnosis table used to build 1996-2022 inpatient mental-diagnosis records. Code joins `shnro`/`hilmoid` with diagnosis codes and uses admission/discharge dates; provider schema and full coverage need confirmation.
- r_raw_icd10_reference [undetermined]: The `u0599_icd10` diagnosis-code reference used to normalize 1996-2022 inpatient records. Code joins by `hilmoid` and keeps `koodi`, `n`, and `kentta`; release and code coverage need confirmation.
- r_raw_inpatient_diagnoses_1994_1995 [undetermined]: The separate legacy inpatient diagnosis table `suoj_u0599_poisto9495`, processed by All mental_diagnosis_data_JAR.sas using legacy diagnosis fields. Its field and coding contract differs from the later ICD-10 branch and needs confirmation.
- r_raw_inpatient_diagnoses_1987_1993 [undetermined]: The separate legacy inpatient diagnosis table `suoj_u0599_poisto8793`, processed by All mental_diagnosis_data_JAR.sas using legacy diagnosis fields. Its field and coding contract differs from the later ICD-10 branch and needs confirmation.
- r_raw_inpatient_diagnoses_1969_1986 [undetermined]: The separate legacy inpatient diagnosis table `suoj_u0599_poisto6986`, processed by All mental_diagnosis_data_JAR.sas using its older diagnosis layout. Its field and coding contract requires confirmation.
- r_raw_outpatient_diagnoses_2011_2022 [undetermined]: The 12-year outpatient-care series `suoj_u0599_avohilmo_11` through `_22`, jointly stacked by Mental_diagnosis_1996_2022_JAR.sas. Code uses person/visit IDs, visit dates, and service-type fields; completeness and year-specific schema consistency need confirmation.
- r_raw_outpatient_diagnosis_codes [undetermined]: The `u0599_ah_kayntisyy` outpatient diagnosis-code reference used to join ICD-10 codes to outpatient visits; exact release and code coverage need confirmation.
- r_raw_municipality_crime_workbooks [undetermined]: Eleven four-year-period Excel workbooks imported by Municipality_crime_data_JAR.sas, spanning 1980-2023. The code converts municipality crime rates into municipality/year and region/year series; the source URL, field labels, units, municipality crosswalk, and period completeness are unverified.
- r_raw_shareholder_ownership_2006_2019 [undetermined]: The 2006-2019 annual shareholder ownership series `vero6b_9_s_osakas_YYYY`, jointly used to calculate person ownership percentages and control flags. The code maps firm/person identifiers and share counts; exact tax-product definitions, ownership units, and full year coverage need confirmation.
- r_raw_total_shares_2006_2019 [undetermined]: The separate 2006-2019 total-share-count series: `verolomake6b_9_s_2006` through `_2016`, `vero6b_osakkeet_prh_asiakas_2017`, and `vero6b_osakkeet_9_s_2018`/`_2019`. The code uses firm, year, and total share count as the ownership denominator; source schema and year-to-year continuity need confirmation.
- r_raw_convictions_1992_2019 [undetermined]: The 1992-2019 conviction/penalty year series: one 1992-2004 table and annual 2005-2019 tables. Person_crime_data_JAR.sas uses person identifiers, offense/sentence information, age-at-offense, and fine values; annual schema consistency, code meanings, and coverage need confirmation.
- r_raw_offense_details_1977_2022 [undetermined]: The separate `uusrik_1977_2022_u0599_9_s` offense-detail table used for offense-year crime categories and counts. Code uses offense year, person identifier, person count, and numeric offense-code fields; native contract and coverage need confirmation.
- r_raw_asiakastieto_positions [undetermined]: The Asiakastieto officer/position table `vasthlo_20210707_s`. Position_data_Asiakastieto_JAR.sas uses firm/person identifiers, role names, and registration start/end dates, expands positions into years, and excludes starts in 2021; license, field definitions, and coverage need confirmation.
- r_raw_prh_board_law_records [undetermined]: The two PRH board-law source tables for 1994-2015 and 2016-2019, both needed to construct the PRH positions panel. Code filters Finnish limited companies and board/CEO roles; exact registry/product fields, role history, and access conditions need confirmation.
- r_raw_prh_board_registry_records [undetermined]: The two PRH board-register source tables for 1994-2015 and 2016-2019, jointly used with the corresponding board-law tables. The code filters Finnish limited companies and board/CEO roles; exact registry/product fields, role history, and access conditions need confirmation.
- r_stata_talous_input [undetermined]: SAS dataset `stata_talous_011025.sas7bdat` read by Spouses_data_for_analyses_JAR.sas (D0175). No active producer has been established in the screened supplied sources; a hidden Final_data_merging span may affect the cross-language handoff, so this remains a required but unresolved input.
- sw_sas [unverified]: Required by the supplied SAS construction programs. The original registered environment projection marks SAS unverified; no SAS startup or author-code execution was attempted.
- sw_sas_xlsx_import_support [unverified]: Municipality_crime_data_JAR.sas imports 11 XLSX workbooks through PROC IMPORT. The required Excel/PC Files engine and license/configuration are not established by the original environment projection.
- sw_ebalance [unverified]: The Stata syntax invokes `ebalance`; availability of that Stata command/package is not established by a matching successful entry in the original environment metadata.

## Review notes

- Assessment remains provisional until the pinned read-only finalizer accepts the exact schema and dependency crosswalk. Source-code bodies were obtained only through the registered source-view wrapper and its safe output rows; every capture range was limited to 400 or fewer one-based rows.
- The package inventory contains 28 code files and 47 documents; no raw data files are listed in this archive inventory. This does not establish machine-wide data absence. `.log` and Output text files were not opened.
- Exact coverage limits from the screened source views: the data sheet masked lines 19 and 21; Person_crime_data_JAR.sas masked lines 1300-1347; Final_data_merging_for analysis_JAR.sas masked lines 2 and 1032-1033; and the Stata SAS-import path tokens were masked. These limits are recorded as unknown coverage, not source defects or evidence of absent programs.
- The D0038 producer-consumer path is visible: Main_data_merging declares Kirjanpitodata_tekovuosi1_220925 at line 998, and Final_data_merging reads it at line 9. The separate D0175 input stata_talous_011025 has no visible producer established in the supplied screened sources.
- All directly produced tables are represented as generated dependency-review edges with empty target_ids and direct producer evidence; they are preparation steps, not separate raw-data delivery requirements. The 23 separately recorded raw-input families remain mandatory. The Data_structure macro edges resolve through `years` (line 9), `xset1` (line 77), and the loop call (line 89). Positions and CEOs are matched by explicit lib100 producer and consumer statements; no generic SAS USER configuration uncertainty is inferred.
- The four Final_data_merging passes remain an unresolved producer-to-Stata-import mapping, not an extra generic final-dataset requirement. D0175 remains a separate unresolved required input. D0134 has a direct same-named producer, but its screened consumer line is withheld so the library mapping remains specifically unresolved.
- The exact-name frozen catalog lookups performed for selected source aliases returned no candidates. Those catalog misses were not treated as data, license, or entitlement absence evidence; no further catalog search is needed to retain the unresolved route status.
- All original environment values were read only through project_environment_metadata.py. Available software claims cite the original `probes/environment.json` probe hash; SAS and unlisted components remain unverified, and no SAS startup, Stata execution, author-code run, import, or statistical procedure was attempted.
- Process-only failures retained: one earlier catalog lookup pointed `--catalog` at the helper instead of the frozen catalog and returned a JSON parse error; four source-window requests exceeded the wrapper's 400-row cap and returned no body before being corrected to bounded ranges; and one early jq formatting expression printed literal placeholders before being corrected. These failures do not support scientific claims and are not cited by evidence IDs.
