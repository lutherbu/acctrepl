# Patch proposal: jar-3949425df05e

Paving the Road to the Buy-Side

DOI: 10.1111/1475-679X.70004

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented two-stage SAS preparation and Stata analysis workflow, preserving its separate manual and external data inputs.

Entry points: `Generate Bias Sample.sas`, `Make_Regressions.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 1/70004 - Paving-the-Road-to-the-Buy-Side/bzhangdatasheetcodeidentifiersandlogfile.zip",
      "sha256": "47adeb5e51567ba9b88ebfb041fecee2454b2d08f155c3d96fa27c10c85eecc8"
    },
    {
      "path": "JAR-Volume 64/Issue 1/70004 - Paving-the-Road-to-the-Buy-Side/zhang-online-appendix.pdf",
      "sha256": "e54bcbb898d314f3cda8907781e8cb30d2d4a52c00a8be3ad15047bf95c90e38"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "5762e47a99446516d86c14ecfbaef0f16afdb24b4173ed1c41ff4592e8594665"
}
```

## Proposed actions

### action_resolve_macro: Obtain the exact previous-trading-day macro source and contract used by the SAS preparation.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_macro_closure
Evidence: ev_sas_macro_call, ev_work_item, ev_sas_crsp_dsf

Preparation / proposed procedure:

1. Obtain the registered macro implementation and retain it in the portable working copy.
2. Confirm its input/output member names, date field and CRSP trading-calendar mapping without changing the authored sample.

Validation to perform later:

- Before any separately authorized run, verify that the macro contract produces the prior trading date consumed by the CRSP join and document the exact date/history range it supports.

### action_map_inputs: Supply or document the exact upstream producer and schema for each missing author-prepared input, keeping separate measures and time keys distinct.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_transition, req_star, req_ibes_recddet, req_s2, req_aum, req_crsp_weight, req_analyst_firm_exp, req_analyst_exp, req_analyst_buy_counts, req_firm_controls, issue_input_producers
Evidence: ev_author_workflow, ev_datasheet_sources, ev_datasheet_ibes, ev_datasheet_holdings, ev_datasheet_compustat, ev_sas_transition, ev_sas_star, ev_sas_recddet, ev_sas_holdings, ev_sas_aum, ev_sas_crsp_weight, ev_sas_analyst_firm_exp, ev_sas_analyst_exp, ev_sas_buy_counts, ev_sas_firm_controls, ev_field_matrix

Preparation / proposed procedure:

1. Confirm the author transition/manager mapping, star table and exact I/B/E/S recommendation product with the required identifiers and history.
2. For S2, document the producer that maps Type 3 holdings to final managers, CUSIP, quarter and adjusted holdings; separately identify the AUM and CRSP-weight producers and measure construction.
3. Provide the two analyst first-date tables and analyst-year N_Buy/N_Rec counts with their keys and calculation periods.
4. Provide the Firm_Controls producer and its Q, ROA, IOR, SHRCD, EXCHCD, FYENDDT and NEXT_FYENDDT definitions; do not treat COMP.FUNDQ as the prepared table without a documented construction.

Validation to perform later:

- Compare each received native header to the field matrix, map field case explicitly, and verify required IDs, units/measures and endpoint/history coverage before a later authorized full-pipeline attempt.

### action_stage_library_mappings: Map the reviewed native products and author-prepared inputs to portable SAS library aliases and align SAS export with the Stata working directory.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: req_ibes_detu_epsus, req_ibes_ptgdet, req_crsp_msenames, req_crsp_dsf, req_firm_controls
Evidence: ev_field_matrix, ev_handoff_check, ev_sas_export, ev_sas_export_format, ev_stata_input

Preparation / proposed procedure:

1. In a portable working copy, configure the `ibes`, `crsp2` and `wd` libraries to the reviewed input/staging directories; map IBES.DETU_EPSUS, IBES.PTGDET, CRSP.MSENAMES and CRSP.DSF using the exact native member and field spelling.
2. Preserve the source's SAS case-insensitive field references explicitly, including raw `analys` to native `ANALYS` and the source rename to `amaskcd`; do not rename or merge semantically different prepared inputs silently.
3. Keep the SAS `PROC EXPORT` target format explicitly `DBMS=STATA` and write its `dt3` result as `bias.dta` in the directory used by Stata `use bias`; configure tables and figures output macros to writable portable locations.

Validation to perform later:

- Read-only metadata confirms each configured member, exact native field map and file format. The shared output location continues to match the checked `bias` basename and SAS-before-Stata order; no sample or analysis logic changes.

### action_verify_sas_runtime: Confirm the intended SAS 9.4 runtime is available in the later execution context before attempting the preparation stage.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw_sas, issue_sas_runtime
Evidence: ev_environment_probe, ev_environment_view

Preparation / proposed procedure:

1. Use the approved environment's normal managed configuration to confirm the SAS launcher and runtime version; do not infer runtime availability from a failed metadata probe.

Validation to perform later:

- Record a typed runtime-availability result and confirm it is the same configured context that can see the portable SAS libraries and output directory.

### action_enable_winsor2: Make the source-required winsor2 Stata addon available in the intended Stata ado path.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw_winsor2, issue_stata_winsor2
Evidence: ev_environment_probe, ev_environment_view, ev_stata_analyses

Preparation / proposed procedure:

1. Use the user's approved Stata package source or managed environment to provide winsor2; no package installation or download was attempted during this assessment.
2. Repeat the bounded read-only `which winsor2` metadata check in the intended environment.

Validation to perform later:

- The metadata check locates winsor2 in the configured Stata environment before any later authorized analysis run.


## Remaining issues and prerequisites

- issue_macro_closure [unresolved; full_pipeline]: The SAS driver calls an external previous_trading_day macro and requires its output member/previous-day field before the CRSP daily join. The macro body and exact input/output behavior are not in the package or registered source closure; the date mapping cannot be treated as verified.
- issue_input_producers [unresolved; full_pipeline]: The supplied SAS source consumes author-prepared TRANS_ANALYST, STAR, S2, AUM, CRSP_WEIGHT, analyst-date/count tables and FIRM_CONTROLS whose exact local catalog candidates/producers are not established. IBES.RECDDET is author-documented from WRDS but lacks an exact local candidate/header. COMP.FUNDQ is a readable local candidate; among the eight source-required Firm_Controls fields, only CUSIP appears in its header. DATADATE is available as a separate candidate date field, but no supplied interval/control construction maps it to FYENDDT/NEXT_FYENDDT or the required controls. These products and their fields/history remain unresolved; the packaged CUSIP list is identifier-only, not the prepared panel.
- issue_sas_runtime [preparation; full_pipeline]: The safe view of the original environment probe reports the SAS runtime as unverified with return code 1 and no version token. This assessment did not start SAS; the intended SAS 9.4 runtime must be confirmed in the eventual execution context.
- issue_stata_winsor2 [preparation; full_pipeline]: The source uses `winsor2`; static metadata says the command is unavailable in both default and configured Stata paths. Other source-used Stata commands were found, so this is a specific addon preparation need.
- req_transition [undetermined]: Author-prepared analyst-transition and buy-side mapping; SAS consumes analyst ID, transition dates, manager number, transition/final classification, source/type flags, gaps, transition counts and IBES career bounds. The hand-coded matching and history are not supplied.
- req_star [undetermined]: Analyst star-status table joined by ACODE and YEAR in the year of or year before the transition; the exact table is author-prepared and no matching local catalog member was found.
- req_ibes_recddet [undetermined]: I/B/E/S recommendation detail used to form recommendation records and rating measures. SAS consumes CUSIP, ESTIMID, AMASKCD, ANNDATS, ANALYST, REVDATS, IRECCD, USFIRM and CNAME; it filters and recodes ratings and uses revision timing.
- req_s2 [undetermined]: Separate adjusted institutional holdings table joined by final manager, CUSIP and quarter; raw fields consumed are FINAL_MGRNO, CUSIP, YRQTR and ADJ_HOLDING. The author-documented Type 3 holdings family is not itself a proven equivalent.
- req_aum [undetermined]: Separate assets-under-management table joined by final manager and quarter; SAS consumes FINAL_MGRNO, YRQTR and AUM. The source and construction are not identified in the supplied code or local catalog.
- req_crsp_weight [undetermined]: Separate CRSP-weight table joined by PERMNO and quarter; SAS consumes PERMNO, YRQTR and CRSP_WEIGHT. No product or weighting construction is supplied.
- req_analyst_firm_exp [undetermined]: Separate analyst-firm first-recommendation-date table keyed by AMASKCD and CUSIP, with FIRST_ANNDATS; the code uses it to calculate firm-specific experience.
- req_analyst_exp [undetermined]: Separate analyst first-recommendation-date table keyed by AMASKCD, with FIRST_ANNDATS; the code uses it to calculate overall analyst experience.
- req_analyst_buy_counts [undetermined]: Separate analyst-year counts table keyed by AMASKCD and ANNYEAR, with N_Buy and N_Rec; the code uses the buy share.
- req_firm_controls [undetermined]: Prepared Firm_Controls table joined by CUSIP and fiscal-year interval. The SAS source needs Q, ROA, IOR, SHRCD, EXCHCD, FYENDDT and NEXT_FYENDDT. COMP.FUNDQ is present locally and readable, but its full native header lacks these source-table fields and no supplied producer maps it to Firm_Controls.
- sw_sas [unverified]: Static environment metadata did not verify the SAS runtime or version. No SAS execution was performed for this assessment.
- sw_winsor2 [preparation_required]: The Stata source invokes winsor2, but frozen metadata reports it unavailable in both default and configured paths; make the addon available in the intended Stata environment and recheck the command before a later authorized run.

## Review notes

- The byte-first reader screened the complete supplied SAS and Stata source and the registered documentation before any source/document display. Quoted Windows path bytes and connection/configuration blocks were masked; raw logs and helper streams remain opaque.
- The field matrix records source-consumed raw fields, full exact native catalog field lists/case, and exact headers from successful one-row probes. Four complete compatible local products (IBES.DETU_EPSUS, IBES.PTGDET, CRSP.MSENAMES and CRSP.DSF) are positively routed; the probes establish readability/header compatibility, not population, value or endpoint-history coverage.
- COMP.FUNDQ is a complete/readable 648-field local candidate, but the direct SAS consumer is prepared WD.Firm_Controls. Among that table's eight explicitly consumed fields only CUSIP appears in COMP.FUNDQ; DATADATE is separately present but no producer or fiscal-interval mapping is inferred.
- WD.TRANS_ANALYST, WD.STAR, WD.S2, WD.AUM, WD.CRSP_WEIGHT, both analyst-date tables, the analyst-year counts and WD.Firm_Controls remain distinct author-prepared products. The datasheet's documented WRDS products provide partial upstream routes only where stated; they do not prove prepared-table construction or history.
- The SAS source also reads CRSP2.MSENAMES at lines 263-265, which the frozen dependency registry did not enumerate; it is separately tracked and has a verified local native product route.
- The saved handoff check confirms the SAS Stata-format export basename and directory match Stata's `bias` input and working directory; SAS preparation precedes the Stata analysis. No author SAS/model/regression/statistical execution, installation, download or source edit was performed.
