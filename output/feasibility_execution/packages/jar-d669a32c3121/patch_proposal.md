# Patch proposal: jar-d669a32c3121

Upward Influencers in Teams

DOI: 10.1111/1475-679X.12601

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | restricted_access_required | blocked |

### full_pipeline

The supplied Stata program imports the research-site 360-degree evaluation, team, manager, and team-dynamics files plus employee and supervisor Workplace Survey responses; it constructs panels and runs the main tables and figure.

Entry points: `CCS_Upward Influencers in Teams.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 4/12601 - Upward-Influencers-in-Teams/ccs-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "99892124b7e5bff908b02e3d8df106f651172da4c60035454fb63ea1109c5984"
    },
    {
      "path": "JAR-Volume 63/Issue 4/12601 - Upward-Influencers-in-Teams/ccs-online-appendix.pdf",
      "sha256": "f6f3a21ea46ff1f97ca2f1e440f3ec368f48fd418392e3a278ed0b77327e676b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "989940270c5d80e22c27b62674a76be4d7bbbc387aecd977c3c875836018d07f"
}
```

## Proposed actions

### A_SITE_ACCESS: Obtain an explicitly authorized route for the research-site archival data and employee/supervisor Workplace Survey response files under the NDA, or document that controlled access is unavailable. The public appendix instrument does not provide response data.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_360_DATA, R_TEAM_DATA, R_MANAGER_DATA, R_TEAM_DYNAMICS, R_TEAM_SURVEY_ID, R_EMPLOYEE_SURVEY, R_SUPERVISOR_SURVEY, I_SITE_DATA_ACCESS
Evidence: E_NDA, E_CODE_360, E_CODE_TEAM, E_CODE_SITE_INPUTS, E_CODE_EMPLOYEE_SURVEY, E_CODE_SUPERVISOR_SURVEY, E_APPENDIX_SITE_SURVEY

Preparation / proposed procedure:

1. Request the research site's permitted controlled-access method and the author-held data dictionary for each raw workbook, crosswalk, and Qualtrics response export.
2. Confirm that access covers all seven files read by the supplied program and the required matching keys, retained periods, and survey response columns.
3. Stage authorized inputs under the relative CCS_UI in Teams/raw data/ path in a separate working copy; retain the package source bytes unchanged.

Validation to perform later:

- After authorization, verify each file's format, column names, identifiers, row units, period, and mapping to the supplied import and merge calls with bounded metadata checks.
- Do not link anonymous Workplace Survey response records to the archival panel; the appendix says respondents were kept unidentifiable.

### A_UNIVAR_SETUP: Install or activate a Stata-compatible user-written univar command in the runtime's user ADO path before the full workflow is attempted.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_UNIVAR
Evidence: E_UNIVAR_PROBE, E_CODE_ANALYSIS, E_CODE_TABLE8

Preparation / proposed procedure:

1. In a separately authorized software-setup step, install a compatible release of the Stata univar command in the host Stata user ADO path; do not replace the author's univar calls with another statistic command.

Validation to perform later:

- Before data execution, use Stata metadata only to confirm which univar resolves to the intended ado file and record the command version.

### A_TLD_CONFIRM: Ask the authors to confirm the intended tldmain unit, retained fields, and merge keys before any change to the closed keep list.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_TLD_HANDOFF
Evidence: E_CODE_TLD_OUTPUT, E_CODE_TLD_MANAGER_MERGE, E_CODE_ANALYSIS, E_CODE_MODELS

Preparation / proposed procedure:

1. Confirm whether one row per project_id is intended and whether manager_ID and year are constant at that unit.
2. Confirm the intended source and construction for team_perf and project_size and which fields must survive the first tldmain save.

Validation to perform later:

- After authorized data access, compare the confirmed keys and fields with bounded metadata from the intermediate files before editing or running dependent tables.

### A_ILD_CONFIRM: Ask the authors to identify the intended source and sample for the ratings used in Table 1 Panel C before changing the individual-panel keep list or table input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_ILD_RATINGS
Evidence: E_CODE_ILD_OUTPUT, E_CODE_ILDMAIN_OUTPUT, E_CODE_TABLE1_PANEL_C

Preparation / proposed procedure:

1. Confirm whether Panel C should read the ratings from 360eval.dta or whether up_eval, peer_eval, and other_eval should be retained in ildmain.dta.
2. Confirm the intended observational unit and sample for the reported rating comparisons.

Validation to perform later:

- After authorized data access and author clarification, verify the selected source contains the required rating fields and intended identifiers before any edit or execution.

### A_TABLE2_CONFIRM: Ask the authors to confirm the intended Table 2 relationship-variable source and sample before changing its input file or merge sequence.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_TABLE2_TDS_HANDOFF
Evidence: E_CODE_CORRELATIONS, E_CODE_SITE_INPUTS, E_CODE_TDS_AND_SURVEY_APPEND

Preparation / proposed procedure:

1. Confirm whether Table 2 is intended to use tdsmain.dta after the matched project_id merge, or a different relationship-variable construction.

Validation to perform later:

- Compare the confirmed intended sample with the available project_id coverage after access is authorized; do not infer a source change from filenames alone.

### A_RUN_SEQUENCE: After authorized access, install/activate the verified software prerequisite, and resolve the documented intermediate handoff questions, run the supplied entry program in a separate relative-path working copy in its authored order.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R_360_DATA, R_TEAM_DATA, R_MANAGER_DATA, R_TEAM_DYNAMICS, R_TEAM_SURVEY_ID, R_EMPLOYEE_SURVEY, R_SUPERVISOR_SURVEY, SW_STATA, SW_ESTSTO, SW_ESTPOST, SW_ESTTAB, SW_REGHDFE, SW_FTOOLS, SW_UNIVAR, I_SITE_DATA_ACCESS, I_TLD_HANDOFF, I_ILD_RATINGS, I_TABLE2_TDS_HANDOFF
Evidence: E_CODE_360_READ, E_CODE_TEAM_MERGE, E_CODE_TLD_OUTPUT, E_CODE_TLD_MANAGER_MERGE, E_CODE_SITE_INPUTS, E_CODE_TDS_AND_SURVEY_APPEND, E_CODE_SUPERVISOR_OUTPUT, E_CODE_WPSMAIN_OUTPUT, E_CODE_ILDMAIN_OUTPUT, E_CODE_ANALYSIS, E_CODE_CORRELATIONS, E_CODE_MODELS, E_CODE_TABLE6_TDS, E_CODE_TABLE8, E_CODE_FIGURE

Preparation / proposed procedure:

1. Use a separate working copy with the CCS_UI in Teams directory beneath the Stata working directory so the program's relative raw-data and JAR data paths resolve; keep frozen package and audit-generation bytes unchanged.
2. Stage all seven authorized inputs under CCS_UI in Teams/raw data/: 360Data.xls, TeamData.xlsx, ManagerData.xls, Team Dynamic Survey Data.xls, Team Survey ID.xls, Qualtrics_Workplace Survey_Employees.csv, and Qualtrics_Workplace Survey_Supervisors.csv.
3. Run the authored 360Data import and cleaning to create 360Data.dta and 360eval.dta; import TeamData.xlsx to TeamData.dta, merge with 360eval.dta by ID/year, derive team variables, and save the initial tldmain and ildmain intermediates.
4. Import ManagerData.xls to ManagerData.dta, reload tldmain, apply the authored manager_ID/year merge and manager-derived fields, and overwrite tldmain after the handoff fields and unit are confirmed.
5. Import and rename the team-dynamics workbook, join it to Team Survey ID.xls on jyd_id to create tdsmain, then merge matched project_id rows with tldmain and overwrite tdsmain.
6. Clean the employee and supervisor Qualtrics exports to their authored Stata intermediates, append them into Workplace Survey.dta, apply the authored filtering, recodes, and PCA steps, and save wpsmain.dta.
7. Reload ildmain, derive the authored averages and turnover_t1, and overwrite ildmain after resolving the missing-rating handoff.
8. Run the supplied main analysis and figure code in authored order after resolving the Table 2 relationship-variable sample question; keep the Stata session continuous where the program relies on data in memory.

Validation to perform later:

- Before any run, confirm site authorization covers all seven inputs, the exact column/key expectations, and the anonymous survey-linkage constraint; confirm univar resolves to the intended compatible ado.
- During an authorized run, retain the generated intermediates and record the exact producer and consumer outcomes; validate that each intended key, row unit, and required variable survives before dependent analyses.
- Do not claim reproduction until the generated outputs and author-confirmed handoffs have been checked against the stated analysis targets.


## Remaining issues and prerequisites

- I_SITE_DATA_ACCESS [blocking; full_pipeline]: Every supplied run path depends on missing raw site or site-survey files. The datasheet says the proprietary underlying data cannot be shared because the research-site NDA prohibits sharing; reproduction therefore requires a separately authorized controlled-access arrangement. The package does not establish that such access is available.
- I_TLD_HANDOFF [blocking; full_pipeline]: The first tldmain.dta save uses a closed keep list after duplicates drop project_id. That list omits manager_ID and year required by the later ManagerData merge, and omits team_perf and project_size used by the table code. The later reload and overwrite cannot restore fields already dropped. The intended project-level row construction, required retained fields, and key uniqueness must be confirmed against authorized data before any source edit.
- I_ILD_RATINGS [blocking; full_pipeline]: The ildmain.dta keep list omits up_eval, peer_eval, and other_eval, while Table 1 Panel C reloads ildmain.dta and uses those fields. The later ildmain overwrite only derives averages and turnover_t1 from fields already saved. Confirm whether Panel C should use the available 360eval intermediate or whether the individual keep list should retain these ratings; the intended sample and unit must be preserved.
- I_TABLE2_TDS_HANDOFF [unresolved; full_pipeline]: Table 2 loads tldmain.dta but requests H_Relationship and V_Relationship, introduced in the separate dynamic-survey branch and present in tdsmain after its matched project_id merge. Confirm whether Table 2 is intended to use the matched tdsmain sample or another construction before changing the input or merge sequence.
- R_360_DATA [restricted_access_required]: Research-site 360Data.xls used to construct person-level evaluation differences and upward-influencer indicators, then merged to team data by ID and year.
- R_TEAM_DATA [restricted_access_required]: Research-site TeamData.xlsx used for team membership, project identifiers and the team-level variables merged with the 360-degree person data.
- R_MANAGER_DATA [restricted_access_required]: Research-site ManagerData.xls joined to the constructed team panel by manager_ID and year for manager tenure and the manager-experience analysis.
- R_TEAM_DYNAMICS [restricted_access_required]: Research-site Team Dynamic Survey Data.xls providing the horizontal- and vertical-relationship measures merged into the team panel.
- R_TEAM_SURVEY_ID [restricted_access_required]: Research-site Team Survey ID.xls crosswalk supplying jyd_id and project_id to connect team-dynamics survey records to project teams.
- R_EMPLOYEE_SURVEY [restricted_access_required]: Qualtrics employee Workplace Survey response export required for the survey-based tests and employee responses in the workplace-survey analysis.
- R_SUPERVISOR_SURVEY [restricted_access_required]: Qualtrics supervisor Workplace Survey response export required for the combined employee/supervisor survey dataset and workplace-survey analysis.
- SW_UNIVAR [preparation_required]: The exact Stata command univar is used for summary statistics in Table 1 and Table 8. The bounded Stata 18 software probe returned available:false (which return code 111); install or activate a compatible user-written command before attempting the full workflow.

## Review notes

- Static package review and bounded metadata checks cover the supplied Stata entry program, author datasheet and appendix, all 15 frozen dependency IDs, the packaged identifier workbook probe, the assigned resource catalog, and registered Stata metadata. The full supplied code path depends on seven missing site inputs barred from sharing by the stated NDA; controlled access remains unconfirmed. No compatible local/public input product was established in the bounded catalog queries, which is not evidence of absence or permanent denial. Stata 18 and required estimation helpers are available; univar is a preparation item. The generated review records the complete dependency set and the produced-intermediate lineage. Three code handoff issues remain for author/data confirmation: the tldmain keep list, the ildmain rating fields, and Table 2's dynamic-survey source/sample. The online appendix also describes analyses without supplied code; those analyses are outside the supplied executable closure. The separate author log was not used as local feasibility evidence. The qfitci standalone lookup and failed Stata manual open are unreferenced process-only captures; official StataCorp evidence supports qfitci as a Stata 18 plot type, and the set memory statement is not a blocker. No scientific program, author startup file, data payload, or model was executed.
