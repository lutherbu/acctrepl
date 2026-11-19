# Patch proposal: jar-f0574722aac7

The Effects of Mandatory ESG Disclosure around the World

DOI: 10.1111/1475-679X.12548

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied author workflow: SAS Script 3 constructs the static firm list, Script 2 constructs annual liquidity measures, Script 1 assembles the firm panel, then Stata merges the independent country/firm inputs and constructs factors and residual variables in memory. The final Stata target period is 2002–2020; upstream history and any earlier lag windows remain unverified.

Entry points: `SAS Code KSTZ.pdf`, `STATA Code KSTZ.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 5/12548 - The-Effects-of-Mandatory-ESG-Disclosure-around-the-World/kstz-datasheet-code-and-identifiers.zip",
      "sha256": "64283aeb55dad36c10d65d56c4b2e9dbe55632ecc2e618705263d853c0772e7d"
    },
    {
      "path": "JAR-Volume 62/Issue 5/12548 - The-Effects-of-Mandatory-ESG-Disclosure-around-the-World/kstz-online-appendix.pdf",
      "sha256": "a7023b62d704a64c5506ce20b03e90dd89f9bcf2719aa7dbf3d68856e0c112ea"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "9d5271c7ff22b3a3fd1da37c9578dae80d39ee94bf61d7e4c33f1682e59278a8"
}
```

## Proposed actions

### A_EXTRACT_SAS: Extract the three embedded SAS stages into separate editable files in a working copy, preserving source order and comments.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_CODE_CONTAINER
Evidence: E_README_EXEC, E_SCREEN_SAS

Preparation / proposed procedure:

1. Use the supplied SAS PDF as the extraction source.
2. Keep each extracted stage in its own file and retain a copy of the original PDF.
3. Run the same byte-first source screening on the extracted files before display or execution.

Validation to perform later:

- Confirm each extracted stage corresponds to its source section and remains byte-for-byte traceable to the supplied PDF text.

### A_INPUTS_EARLY: Resolve each independently consumed prepared input's exact source/table, fields, identifier/date keys, historical vintage and coverage. Use compatible prepared, local or public sources directly; no extra entitlement, original-byte or title-approval gate is supported by this assessment.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_DS_CONSTITUENTS, R_INDG_LIST, R_EIKON_FIRM_LIST, R_DAILY_STOCK, R_FUNDAMENTALS, R_IBES_FORECASTS, R_IBES_GUIDANCE, R_MACRO_PANEL, R_LEGAL_ORIGIN, R_STATA_MASTER, R_FACTSET_IO, R_ASSET4_CSR, R_INDEX_RET_VOL, R_EPI, R_IVS, R_GOOGLE_TRENDS, R_REPRISK, I_CLOSURE
Evidence: E_README_FLOW, E_DATASHEET_SOURCES, E_SAS1_FUND, E_SAS1_IBES, E_SAS1_GUIDE, E_SAS1_MACRO, E_SAS1_LEGAL, E_SAS2_FIRM_LIST, E_SAS2_DAILY, E_SAS3_STATIC_INPUT, E_SAS3_INDG, E_STATA_MASTER, E_STATA_FACTSET, E_STATA_ASSET4, E_STATA_INDEX, E_STATA_EPI, E_STATA_IVS, E_STATA_GS, E_STATA_REPRISK, E_CAT_DATASTREAM, E_CAT_IBES, E_PROBE_IBES_GUIDANCE, E_PUBLIC_EPI_2022, E_PUBLIC_WVS, E_PUBLIC_GOOGLE_TRENDS

Preparation / proposed procedure:

1. For each named requirement, identify the exact prepared file or compatible local/public product already available and its relevant vintage.
2. Confirm required fields, firm or country identifiers, date/fiscal-year keys, units, transformations and sample coverage against the receiving SAS or Stata branch.
3. For IVS, identify the survey family, wave selection, variable and country-year aggregation; for EPI, identify the release; for Google Trends, identify queries, scaling and date range.
4. For the FactSet, Asset4 and RepRisk inputs, provide the existing compatible prepared table or exact local source mapping; do not infer a license or a data-access barrier from the datasheet wording.
5. Keep Datastream list, INDG map, Eikon firm-year list, daily panel, fundamentals, I/B/E/S forecast/actuals, guidance, macro panel and legal-origin table separate as distinct consumed inputs.

Validation to perform later:

- A requirement-by-requirement source and field map exists for all 17 inputs.
- The map identifies the exact vintage and join keys without substituting a superficially similar catalog table.

### A_CONFIRM_HANDOFF: Confirm how the SAS Script 1 panel is staged or converted to the Stata master filename, and specify its schema, keys, coverage and relation to the 2002–2020 final Stata target period.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_STATA_MASTER, I_HANDOFF
Evidence: E_README_FLOW, E_SAS1_PRODUCER, E_SAS1_EXPORT_STRUCTURE, E_STATA_MASTER, E_SAS1_DS3_INPUT, E_SAS1_SAS2_INPUT, E_STATA_PERIOD_KEEP, E_STATA_PERIOD_DROP_2021

Preparation / proposed procedure:

1. Confirm whether jar.firm_data_all_liquidity is the source of all_data_liquidity_raw_final.dta and identify the PROC EXPORT DATA= object and output filename.
2. Specify any export, conversion, rename or staging step; provide required column names, key uniqueness, identifier mapping and date/fiscal-year convention.
3. Confirm coverage for the 2002–2020 analysis target and identify any earlier source history needed for lag windows; do not infer either from the withheld path.

Validation to perform later:

- The Stata launch read resolves to a named staged file whose declared fields, keys and period match the confirmed SAS Script 1 output.

### A_CONFIRM_MERGE_KEYS: Resolve the version-specific Stata merge syntax and intended key cardinality for the EPI and IVS using datasets before any eventual run.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_STATA_MERGE_SYNTAX, R_EPI, R_IVS
Evidence: E_STATA_EPI, E_STATA_IVS, E_STATA_MERGE_MANUAL

Preparation / proposed procedure:

1. Confirm the intended merge cardinality and Stata 18 syntax for both source lines using the target-version documentation; the current online manual does not establish Stata 18 acceptance of n:1.
2. Confirm whether country_code year is unique in each intended using dataset and whether those keys match the master data.
3. Document the supported syntax and key contract before making any source change; do not assume m:1 or infer using-key uniqueness from the current evidence.

Validation to perform later:

- The target-version merge form, intended cardinality and using-key uniqueness are documented separately for both EPI and IVS merges before execution.

### A_STAGE_PATHS: Adapt author absolute Windows working-directory and library references to one coherent staged working root in the working copy.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_CODE_CONTAINER, I_HANDOFF
Evidence: E_README_FLOW, E_STATA_MASTER, E_SAS1_PRODUCER

Preparation / proposed procedure:

1. After staging source and confirmed input names, configure SAS libraries and Stata working directory relative to the chosen project root.
2. Keep all generated files, logs and temporary outputs under the designated working-copy output tree.
3. Preserve the source copies and record each path mapping separately from the supplied code.

Validation to perform later:

- Every required path resolves within the staged working copy before any author program is started.

### A_SAS_RUNTIME: Resolve the SAS 9.4 runtime availability on the intended host; Stata 18 and winsor are already recorded available.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SAS_94, STATA_18, STATA_WINSOR, I_SAS_RUNTIME
Evidence: E_SOFTWARE_ENV, E_SOFTWARE_WINSOR

Preparation / proposed procedure:

1. Confirm the intended SAS 9.4 TS1M8 executable is usable and versioned without opening the existing raw diagnostic log.
2. Retain Stata 18 and the available winsor command; confirm the author-supplied winsor options against the target runtime before the eventual full workflow run.

Validation to perform later:

- A safe version/availability record confirms SAS 9.4, Stata 18 and the winsor command on the chosen execution host.

### A_RUN_AFTER_RESOLUTION: After input contracts, handoff, Stata merge contract and runtime are resolved, run only the supplied extracted SAS stages and Stata program in the staged working copy.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_CLOSURE, I_HANDOFF, I_STATA_MERGE_SYNTAX, I_SAS_RUNTIME
Evidence: E_README_FLOW, E_SAS1_PRODUCER, E_SAS2_PRODUCER, E_SAS3_PRODUCER, E_STATA_NO_FINAL_SAVE, E_STATA_MERGE_MANUAL

Preparation / proposed procedure:

1. Run Script 3, Script 2 and Script 1 in dependency order, then run the Stata workflow against the confirmed master file and documented target-version merge forms.
2. Keep actual logs and generated outputs under this run's working-copy output tree.
3. Treat the Stata in-memory panel as the endpoint unless the supplied author workflow or confirmed handoff defines an additional saved output.

Validation to perform later:

- Record actual process status and streams, confirm expected keys and variables using the author-provided contracts, and preserve any failure without rewriting input evidence.


## Remaining issues and prerequisites

- I_CODE_CONTAINER [preparation; full_pipeline]: The three SAS programs are embedded in SAS Code KSTZ.pdf and need extraction to standalone source files in a working copy before execution. This is supported preparation, not a no-code finding.
- I_HANDOFF [unresolved; full_pipeline]: README describes a SAS intermediate followed by Stata. SAS Script 1 creates jar.firm_data_all_liquidity and includes a PROC EXPORT statement at lines 219–224, while Stata reads all_data_liquidity_raw_final.dta. The export DATA= source, output filename, schema, keys and mapping to the Stata input remain unestablished because the source path is withheld.
- I_STATA_MERGE_SYNTAX [unresolved; full_pipeline]: Stata source lines 426 and 431 use merge n:1 country_code year using. The current official merge manual lists 1:1, m:1, 1:m and m:m forms, but the exact Stata 18 manual was unavailable in this check. Static version compatibility, intended cardinality and uniqueness of country_code year in the using data therefore remain unresolved; no syntax or data trial was performed.
- I_CLOSURE [unresolved; full_pipeline]: The workflow requires separate prepared vendor, macro, legal-origin, survey and country-year inputs that are absent from the archive. Bounded catalog candidates and one-row probes do not establish field, identifier, vintage, history, construction or coverage compatibility. The only packaged DTA is an identifier reference.
- I_SAS_RUNTIME [unresolved; full_pipeline]: The safe environment fields record Stata 18 and winsor as available, but SAS 9.4 is recorded unavailable with return code 1. The nested raw diagnostic log was not inspected, so SAS startup/version remains unverified.
- R_DS_CONSTITUENTS [undetermined]: Datastream constituent/static-firm-list input imported by SAS Script 3. The exact author workbook and screening fields are not supplied.
- R_INDG_LIST [undetermined]: Industry-code mapping table jar.indg_list joined by SAS Script 3 to assign INDG and apply the final non-common-equity exclusions.
- R_EIKON_FIRM_LIST [undetermined]: Firm-year Eikon list jar.eikon_firm_list required by SAS Script 2 to define annual liquidity windows.
- R_DAILY_STOCK [undetermined]: Daily stock panel jar.data_stock_daily_raw required by SAS Script 2 to calculate liquidity measures.
- R_FUNDAMENTALS [undetermined]: Worldscope/Eikon firm fundamentals jar.eikon_firm_fundamental_all consumed by SAS Script 1.
- R_IBES_FORECASTS [undetermined]: Prepared I/B/E/S forecasts and actuals table jar.IBES_ALL consumed by SAS Script 1; the raw product composition is unresolved.
- R_IBES_GUIDANCE [undetermined]: Prepared managerial-guidance table jar.guide_data_raw consumed by SAS Script 1 to form annual guidance counts.
- R_MACRO_PANEL [undetermined]: Prepared country-year macro panel jar.macro_data_all consumed by SAS Script 1 for emissions, GDP, globalization and governance measures.
- R_LEGAL_ORIGIN [undetermined]: Country-level legal-origin table jar.legal_origin consumed by SAS Script 1 and later country-level residual construction.
- R_STATA_MASTER [undetermined]: Stata master file all_data_liquidity_raw_final.dta read at launch for a final analysis target period of 2002–2020; no packaged copy or confirmed SAS-to-Stata mapping is supplied.
- R_FACTSET_IO [undetermined]: FactSet institutional-ownership file factset_io.dta merged by ISIN/date in Stata.
- R_ASSET4_CSR [undetermined]: Asset4 sustainability-report file asset4_csr merged by ISIN/year and used to form lagged voluntary-report indicators.
- R_INDEX_RET_VOL [undetermined]: Country-year equity-index return and volatility file index_ret_vol merged by country/year in Stata.
- R_EPI [undetermined]: Country-year Yale Environmental Performance Index input EPI merged by country/year and used in residual construction.
- R_IVS [undetermined]: Country-year survey input ivs_data_esg_refine; exact IVS/WVS/EVS composition is not established.
- R_GOOGLE_TRENDS [undetermined]: Country-year Google Trends file gs_data merged in the final supplied Stata branch.
- R_REPRISK [undetermined]: Country-year RepRisk ESG-incident file esg_incidents_reprisk merged in the final supplied Stata branch.
- SAS_94 [unverified]: Environment metadata records the SAS 9.4 path with available=false and return code 1. Raw diagnostics were not displayed and no SAS program was run.

## Review notes

- Assessment scope is full_pipeline only. The packaged Identifiers KSTZ.dta is a baseline sample identifier reference, not the complete analysis panel; no analysis_only route is supported.
- Manual review covers the complete supplied native workflow. SAS is embedded in a PDF; source-stage dependency order is Script 3 → Script 2 → Script 1, followed by Stata. The SAS1 source includes a PROC EXPORT statement, but its DATA= object and output name remain withheld/unestablished against the Stata master. The static audit is partial and Stata-only, so it does not override the direct producer/consumer review.
- Stata source filters initially to 2002–2021 and later drops 2021; the final target period is therefore 2002–2020. Exact upstream product history, source coverage and earlier lag-window requirements remain unverified.
- Two Stata merges use the literal n:1 prefix. The current official merge manual lists 1:1, m:1, 1:m and m:m forms, but an exact Stata 18 manual was unavailable; intended cardinality and using-key uniqueness are not inferred.
- The Stata branch merges the FactSet, Asset4, country-index, EPI, values-survey, Google Trends and RepRisk tables independently. The separate source requirements are retained. It constructs an illiquidity factor and five country-year residuals; the supplied program has no active named final save, and no paper-wide regression results are inferred.
- All catalog checks were bounded lookups against the frozen local catalog. One-row metadata probes against catalog-listed SAS resources establish readability and selected field availability only; every probe reports coverage_verified=false, so no history, sample coverage or author-table equivalence is claimed.
- The datasheet's statement that no proprietary data are used conflicts with its named commercial-provider source list. This discrepancy is recorded as provenance context only; it does not create an entitlement gate or imply that any route is unavailable.
- Official public documentation was checked on 2026-11-11T20:13:27Z. The public pages establish candidate route and version facts only; they do not verify the historical fields or prepared data contract used by the authors.
- The environment artifact contains nested diagnostics. Only safe availability, version, which and executable-path fields are represented here; no raw logs, connection statements, or screened SAS candidate blocks are reproduced.
- Only the frozen dependency D0001 is listed in dependency_review. Manual source review also identified the SAS3 firm-list, SAS2 liquidity and SAS1 panel producers, with direct evidence in their source records; no non-frozen dependency IDs are invented. The packaged identifier file is an optional baseline reference, not a complete panel.
- Operator-only process history is stored at probes/process_history.json and is excluded from scientific evidence. It records scope/validation/finalizer diagnostics without reproducing unrelated paths or reconstructing missing original process fields.
