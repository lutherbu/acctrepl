# Patch proposal: jar-7d401212a59a

Gaming the IRS’s Third-Party Reporting System: Evidence from Pari-Mutuel Wagering

DOI: 10.1111/1475-679X.12483

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied Stata workflow embedded in Stata Code.pdf: the main race-level pool construction and its T1, T3, and T5–T10/Figure 1 branches, plus the separate T4 IRS state panel. The PDF contains substantive Stata commands but needs extraction/reflow into a working copy and a portable data root. The packaged states data.xlsx matches the T4 code's field contract and can serve as its prepared-input route, bypassing the historical IRS copy/paste step. The T8 comment supports omitting line 600; whether the separate line 602 missing-lnpurse filter is also omitted remains unresolved.

Entry points: `Stata Code.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 4/12483 - Gaming-the-IRSs-Third-Party-Reporting-System-Evidence-from-Pari-Mutuel-Wagering/ferguson-datasheet-code-and-identifiers.zip",
      "sha256": "fa3699b83949cfc22343e75087f5548b907e7f551689d6acef95e1276c7b1210"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "22158105ff23667e8de663194caf131a9f4a918f6dc7a3fcd53b5d07b6bd2ea4"
}
```

## Proposed actions

### ACT_EQUIBASE_ACCESS: Obtain the author-held race panel or another permitted export compatible with the supplied analysis. The historical price/use statement does not determine present access; do not reconstruct the race panel independently.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_EQUIBASE_PANEL, ISSUE_EQUIBASE_PANEL
Evidence: SRC_DOC_DATA_TERMS, SRC_MAIN_IMPORT, INSPECT_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Request or confirm an authorized academic-use route for the single race-level dataset consumed as Original1.csv, and clarify whether the datasheet's Jockey Club reference describes the Equibase dataset's provenance or another provider relationship; do not create a second required product unless the workflow confirms one.
2. Before acquisition, obtain the actual column/type contract and observation coverage needed for country, racedate/month/year, purse, distance, runners, track/race identifiers and the pool fields referenced by the embedded program.
3. Record whether the delivered history supports the code's year indicators and the T6 one-year track lag; the source period is not stated in the datasheet.

Validation to perform later:

- After lawful acquisition, compare the file headers/types and coverage with the supplied import and cleaning commands. Do not run the author workflow until separately authorized.

### ACT_T8_BRANCH: Materialize a separate T8 touchup branch using the explicit line 600 instruction, retaining the distinct line 602 missing-lnpurse filter and carrying its exact sample scope as unresolved.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: ISSUE_T8_VARIANT
Evidence: SRC_FINAL_FILTERS, SRC_MAIN_OUTPUT, SRC_T8_VARIANT, INSPECT_WORKFLOW_TRACE, SRC_LNPURSE_PREPARATION

Preparation / proposed procedure:

1. In the separate working copy, rerun the same upstream preparation through winsorization for the T8 branch while omitting only source line 600 (`drop if betratioX == 0 | betratioX == .`); retain the separate line 602 filter (`drop if lnpurse == .`) unless supplied evidence expressly supports removing it.
2. Save this branch under a distinct working-copy output name such as testdataNEW_T8.dta and change only the T8 load at source line 1280 to that variant; leave T1/T3/T5-T7/T9-T10/Figure 1 on testdataNEW.dta.
3. Carry forward the specific unresolved sample-scope question: the line 1282 comment does not expressly state whether line 602 is also omitted. Do not infer line 602 removal from adjacency.

Validation to perform later:

- Statically verify the T8 variant omits line 600 only, retains line 602 and the other authored transformations, and leaves other section loads on ordinary testdataNEW.dta.
- Record line 602 applicability to the exact T8 sample as unresolved unless supplied evidence explicitly settles it.

### ACT_EXTRACT_CODE: Create a separate Stata working-copy source from the supplied document-embedded commands without modifying the original PDF.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISSUE_EMBEDDED_CODE
Evidence: SRC_DOC_STATA, SRC_MAIN_IMPORT

Preparation / proposed procedure:

1. Extract/reflow the full Stata command text from Stata Code.pdf into a working-copy .do file, retaining the section order and all named table/figure branches.
2. Keep the original package PDF unchanged and preserve its SHA-256 as the source for any extraction corrections.

Validation to perform later:

- Compare the working-copy text against all supplied program sections in the cached PDF reading and confirm no section or command was omitted; do not execute, parse or compile it in this assessment.

### ACT_PORTABLE_ROOT: Use a portable relative data root in the working copy for all reads and generated outputs.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISSUE_DATA_ROOT
Evidence: SRC_DATA_ROOT, SRC_MAIN_IMPORT

Preparation / proposed procedure:

1. Set the copied program's global path to a relative Data directory under the working project, and stage all required relative inputs there; preserve the authored output names and order.
2. Keep the supplied generation directory as evidence only and run only from a separate authorized working copy.

Validation to perform later:

- Statically trace each path reference against the chosen relative root; confirm future host visibility/writability before any separately authorized run.

### ACT_T4_STAGE: Use the supplied author-prepared IRS state workbook for T4, avoiding independent reconstruction of its underlying public IRS table.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: REQ_IRS_TABLE4_PANEL, ISSUE_T4_PATH
Evidence: SRC_DOC_IRS_PROCESS, SRC_T4_IMPORT, PROBE_STATES_DATA, INSPECT_WORKFLOW_TRACE

Preparation / proposed procedure:

1. In the separate working copy, stage states data.xlsx at the relative Statetottests/states1.xlsx path beneath the selected $path, or make that same-path substitution in the extracted .do copy; retain the original workbook unchanged.
2. Treat the supplied workbook as the primary T4 route. The raw IRS county-data steps are an alternative reconstruction route and are not an additional mandatory input while the prepared workbook route fits.

Validation to perform later:

- After a separately authorized run, verify Stata imports the named T4 columns and that the four-year State expansion/filtering handoff matches the supplied code; compare output only when the reference output is available.

### ACT_WINSOR2_SETUP: Make the exact winsor2 command available in a Stata ado path before running the supplied cleaning and T10 branches.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_WINSOR2, ISSUE_WINSOR2
Evidence: SRC_WINSOR, PROBE_ENVIRONMENT

Preparation / proposed procedure:

1. If winsor2 remains absent from the authorized Stata environment, obtain and configure the user-written winsor2 command in a Stata ado path; do not install it during this assessment.
2. Keep the author's `replace cuts(1 99)` operations unchanged.

Validation to perform later:

- In a future authorized setup check, confirm `which winsor2` resolves to the configured ado file and inspect its own help/version for the authored replace/cuts options before running any analysis.

### ACT_RUN_ORDER: Future authorized execution procedure for the supplied full Stata workflow; the code has not been run.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: REQ_EQUIBASE_PANEL, REQ_IRS_TABLE4_PANEL, ISSUE_EQUIBASE_PANEL, ISSUE_T8_VARIANT, ISSUE_EMBEDDED_CODE, ISSUE_DATA_ROOT, ISSUE_T4_PATH, SW_STATA, SW_REGHDFE, SW_FTOOLS, SW_WINSOR2
Evidence: SRC_MAIN_IMPORT, SRC_T4_IMPORT, SRC_T8_VARIANT, SRC_REGHDFE, PROBE_ENVIRONMENT, INSPECT_WORKFLOW_TRACE

Preparation / proposed procedure:

1. After the Equibase panel is obtained, the T8 touchup variant is prepared, the prepared T4 workbook is staged, and winsor2 is available, run the extracted program in a separate working copy using Stata batch mode and the selected relative Data root.
2. Preserve source order: Original1.csv -> Original.dta -> data1.dta -> data2New.dta -> data3NEW.dta -> testdataNEW.dta; then the Descriptive Stats/T1 and T3 sections use testdataNEW.dta.
3. At its supplied position after T3, run the independent T4 states1.xlsx -> statesdata.dta -> two State-fixed-effect regression sequence using the staged prepared workbook; then continue with T5, T6 and T7. T7 creates Canadasample.dta, draws a non-Canada sample and appends the saved Canada sample for its comparison.
4. Run T8 with the separate variant that omits line 600 and retains line 602; carry line 602 applicability to the exact T8 sample as unresolved. Then run T9, T10 and Figure 1 from the ordinary author dataset. Do not treat the unselected raw IRS route as required if the packaged prepared workbook is used.

Validation to perform later:

- Before a future full execution, confirm all actual inputs and generated handoffs exist at the selected relative paths, Stata and add-ons resolve, and the T8 branch has a distinct verified source that omits line 600 while retaining line 602. Record the line 602 sample-scope ambiguity. Then compare reported analyses to available paper outputs.


## Remaining issues and prerequisites

- ISSUE_EQUIBASE_PANEL [unresolved; full_pipeline]: Original1.csv, the main race-level panel used by the supplied workflow, is not in this package. The datasheet names The Jockey Club and Equibase in its acquisition statement, then describes one Equibase dataset; the provider relationship is unresolved. The actual export fields/types, exact period/history and present access conditions are unspecified. No evidence establishes a no-license or categorical access barrier.
- ISSUE_T8_VARIANT [unresolved; full_pipeline]: The T8 comment requires a touchup without the final missing/zero drop and explicitly matches source line 600 (`drop if betratioX == 0 | betratioX == .`). The adjacent line 602 filter (`drop if lnpurse == .`) is separate. Purse is prepared at lines 51–55, and no supplied source establishes that the line 602 exclusion is redundant or that T8 should omit it. Prepare the separate T8 branch without line 600 and retain line 602; whether T8 was intended to include observations excluded by line 602 remains an unresolved sample-scope condition.
- ISSUE_EMBEDDED_CODE [preparation; full_pipeline]: The substantive Stata commands are embedded in Stata Code.pdf, not supplied as a standalone do-file. Reflow/extraction into a working copy is needed before an ordinary Stata batch run; this is a preparation step, not evidence that no code was supplied.
- ISSUE_DATA_ROOT [preparation; full_pipeline]: The embedded program's global data root is a workstation-specific Windows path. Select a relative data root in a separate working copy and keep the inputs and generated outputs under that root before running.
- ISSUE_T4_PATH [preparation; full_pipeline]: T4 imports $path/Statetottests/states1.xlsx, whereas the packaged prepared workbook is named states data.xlsx at the package root. Its bounded probe confirms the consumed headers, so stage it at the expected relative location in a working copy; do not treat the filename mismatch as missing IRS data.
- ISSUE_WINSOR2 [preparation; full_pipeline]: The code invokes winsor2, but the supplied environment probe did not find that command in the default or separately configured shared ado paths. Availability outside those checked paths is unknown; no install was attempted.
- REQ_EQUIBASE_PANEL [undetermined]: The race-level panel imported as Original1.csv for the main preparation and analyses. The supplied Stata code consumes raw country/date/year/month, purse/distance/runners, track/race/weather/surface fields and the listed pool columns; the actual author export, definitions, period and row coverage are not packaged or specified in the datasheet.
- SW_WINSOR2 [preparation_required]: The supplied environment probe did not find the exact winsor2 command in its default and separately configured shared ado paths. Availability outside those checked paths remains unverified; no installation was attempted.

## Review notes

- The frozen static audit reports no supported code or entry point because extension-only discovery skipped the document-embedded program. Full inspection of the 1,390-line cached Stata Code.pdf text found substantive command blocks for the supplied table and figure workflow; has_code is therefore true and the original PDF is the traceable entry point. The audit remains unchanged and discovery-only.
- The datasheet title matches the frozen title in substance; it contains no DOI to conflict with the frozen DOI. The datasheet names both The Jockey Club and Equibase in its acquisition statement, then describes one dataset obtained from Equibase; the exact provider relationship remains unclear. It says public release is inappropriate under an academic-use understanding but also says there is no NDA. Present access and licensing remain unverified; this is not treated as a no-license finding or a confirmed access barrier.
- The packaged states data.xlsx is the author-prepared IRS Table 4 workbook: its first-sheet headers match every field consumed by the T4 code. The state and track identifier workbooks are single-column lookups, not full analysis panels. The Stata source hardcodes the track-to-state mapping and imports states1.xlsx, so those lookup sheets are supporting references rather than separate mandatory empirical inputs. The prepared workbook route bypasses the historical IRS download/copy-paste construction.
- The T8 comment says to run the touchup without the final missing/zero drop; this matches source line 600, which drops zero/missing betratioX. Separate line 602 drops missing lnpurse. The supplied code prepares purse at lines 51–55, and no supplied evidence says the line 602 filter is redundant or that T8 should omit it. The separate working-copy T8 branch therefore omits line 600 only and retains line 602; exact T8 inclusion of observations excluded by line 602 remains an unresolved sample-scope condition. This is specific to T8 sample definition and does not create an author-approval gate for routine extraction or path setup.
- The credential/API/database keyword screen was saved before source display and found no candidate lines; its screen is limited to the listed keyword pattern. Three attempted cats of cached XLSX text failed because their space-containing paths were not shell-quoted; the same exact cached files were then read successfully with quotes. The initial draft initializer also failed because it looked for draft_path in work_item.json instead of the frozen batch assignment. The screening and both incident records are preserved only as unreferenced process evidence and do not support scientific claims.
- The work item has no frozen dependency checklist edges; the complete input and generated-file chain is documented in the linked static workflow trace instead of inventing dependency IDs. T7 draws a non-Canada sample with runiform and the supplied source contains no explicit set seed; record this as a result-fidelity context for later comparison, not as an independent missing data input or execution barrier.
- The official IRS county-data landing page was opened as static HTML; it documents county data with State totals and a 1989-2022 span. This covers the code's 2016-2019 years by inference but does not demonstrate the exact itemized/nonlimited measure fields or state-year construction. The packaged states data.xlsx remains the selected primary T4 route, and no annual download links or data payloads were opened.
- For Equibase/Jockey Club discovery, the frozen lookup helper itself was invoked for Equibase, Jockey and Jockey Club, but all three attempts exited 2 before lookup because the expected sibling resources.py path was missing. A separate saved read-only scan of the exact assigned catalog hash searched those literal terms and found no matching strings. That catalog discovery does not establish missing access, entitlement or licensing; all failed CLI and zero-hit process records and the catalog evidence row remain unreferenced.
