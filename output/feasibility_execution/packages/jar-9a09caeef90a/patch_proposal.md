# Patch proposal: jar-9a09caeef90a

Government Subsidies and Corporate Misconduct

DOI: 10.1111/1475-679X.12553

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author workflow: SDC/subsidy merger preparation, subsidy generation, two-pass Stata panel assembly, R board-filing stage, political-connection generation, and final panel analysis. No separate analysis-only route is established from a supplied complete prepared panel.

Entry points: `process_merger_data_final.do`, `generate_connected_sub_years_final.do`, `assemble_final_data.do`, `scrape_DEF_14A.r`, `generate_pcon_vars_final.do`, `analyses_final.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 4/12553 - Government-Subsidies-and-Corporate-Misconduct/raghunandan-datasheet-code-and-identifiers.zip",
      "sha256": "666bdf50cdd2659ed0e18372fa49f14119341a273c62e1b4d5f889d54fee8832"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "b2a6644bc98d832fa6b64f95cbab27e690184cd56fee439881faf6795f6ab2ff"
}
```

## Proposed actions

### A01: Resolve each required author input to a compatible author-prepared or documented local route and stage it at the exact code-relative path. The COMP.FUNDA candidate is field-readable for R05; its coverage/construction remain unresolved, and the SDC candidates remain name-only until checked. No source is declared absent, licensed, or blocked.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R01, R02, R03, R04, R05, R06, R07, R08, R09, R10, R11, R12, R13, R14, R15, R16, R17, R18, R19, R20, I01, I06
Evidence: E_WORK_ITEM, E_ASM_ELECTIONS, E_ASM_OFFICEHOLDERS, E_ASM_STATE_VIOL, E_ASM_REFUSA, E_ASM_COMP, E_ASM_CIK, E_ASM_FED_VIOL, E_GEN_SUB_SOURCE, E_GEN_INHERITED_SOURCE, E_MERGER_SDC, E_MERGER_SUBSIDY, E_MERGER_IMPORT_CHECKED, E_MERGER_CUSIP_LINK, E_R_PATH_SOURCE, E_PCON_STATE_SOURCE, E_PCON_CEO_STATE_SOURCE, E_PCON_CEO_FED_SOURCE, E_PCON_FIRM_SOURCE, E_PCON_LOBBY_SOURCE, E_ANALYSIS_DETAIL, E_COMMON_CATALOG_LOOKUP_270, E_COMP_FUNDA_FIELDS_270

Preparation / proposed procedure:

1. Resolve and stage the separate required inputs R01-R20 at their recorded paths; keep jointly consumed products as distinct requirements and do not merge them into one assumed source.
2. For each route, check the exact product/file, readability, raw headers, identifiers, units, population, and required year/history against the consuming code. Keep the filename label or a sampled date range separate from verified full coverage.
3. Use compatible author-prepared full inputs when their fields and coverage fit; original byte identity or download vintage is not an additional requirement. Record the actual local route and any specified conversion without inventing field aliases or unknown producer history.
4. If an exact producer, field mapping, or coverage contract remains unknown, retain that input as unresolved and obtain its specific mapping/source specification before the relevant stage.
5. For R05, the bounded probe found all eleven expected fields readable in COMP.FUNDA. If using this candidate, document any required export/conversion to the code-relative input and verify entity/year population, units, history, and author-specific construction before treating the route as compatible.

Validation to perform later:

- Before a future authorized run, use bounded format-aware checks at the exact recorded input paths and confirm every code-required field and identifier mapping.
- Confirm required temporal coverage and construction history from the actual consumers; do not infer it solely from the 2004-2016 final sample restriction or a filename.
- Treat COMP.FUNDA field presence/readability as a bounded column check only; confirm population, historical coverage, identifier meaning, units, and construction from the actual required input before closing R05.

### A02: Close the supplied merger branch with its actual raw inputs, fuzzy-match review, inherited-subsidy field mapping, and CUSIP-to-gvkey linkage. Preserve the author's filters and hand-check stage.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R09, R10, R11, R12, R13, I02, I06
Evidence: E_MERGER_SDC, E_MERGER_CLEAN_OUT, E_MERGER_SUBSIDY, E_MERGER_GJF_CLEAN_OUT, E_MERGER_RECLINK, E_MERGER_EXPORT_CANDIDATES, E_MERGER_IMPORT_CHECKED, E_MERGER_CUSIP_LINK, E_MERGER_INHERITED_SOURCE, E_MERGER_ADDITIONAL_OUT, E_GEN_INHERITED_CIK, E_COMMON_CATALOG_LOOKUP_270

Preparation / proposed procedure:

1. Resolve the producer and provenance of Data/subsidy_mergers_raw_for_thomson; the supplied code consumes this file but the reviewed workflow does not specify its producer.
2. For R10, the bounded compact SDC lookup identified WRDS_MA_DETAILS and ADVISORS as catalog candidates only. Check candidate fields, readability, period/population, and relationship to the authored expected fields before selecting either or determining whether both are needed. If a compatible route is established, stage it at Data/Mergers/US_Mergers_2003_2016 and retain the authored filters and normalization before producing the CLEAN file.
3. Use the generated GJF/SDC fuzzy-match candidate export as the input to the documented hand-check stage. Populate Data/Mergers/GJF_ThomsonSDC_fuzzy_checked.csv with supported match decisions and the expected truematch field; do not infer unchecked matches.
4. Provide Data/gvkey_cusip_cik_clean.dta with a verified mapping from imported ncusip to gvkey, cik, and fyear for the merger join.
5. Inspect the actual inherited_subsidies_full.xlsx headers and reconcile the current_cik rename in the subsidy builder with the cik field retained by the merger builder. Keep the requirement unresolved until the same workbook contract is established; do not guess a repair.
6. After those prerequisites, preserve the code's output chain to Data/Mergers/additional_inherited_from_thomson and then the inherited_subsidies output.

Validation to perform later:

- Before running either consumer, verify source fields and exact code-relative paths with a bounded metadata check.
- After a separately authorized stage run, compare generated candidate, checked-match, and inherited-subsidy fields and keys before passing them to the subsidy/year builder.

### A03: Stage the two author-defined board-data handoffs at the names and directories their next consumers read, while preserving the CIK population and generated records.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I03
Evidence: E_ASM_CIK_EXPORT, E_R_SETWD, E_R_CIK_SOURCE, E_R_OUTPUT, E_PCON_R_SOURCE

Preparation / proposed procedure:

1. After the first assembler pass, stage Data/cik_for_board_data_upload.txt as Data/Board/cik_for_boardex_upload.csv with a reader-compatible CSV header and unchanged CIK values; preserve the authored population.
2. The R stage writes Data/Board/DEF14A_scraped_connected_firms.csv. Stage its produced table at Data/DEF14A_scraped_connected_firms.csv for the Stata pcon reader, preserving the file's columns and row identifiers.
3. Use a coherent project root so Stata Data/... paths and R's setwd(Data/Board/) resolve as written.

Validation to perform later:

- Check exact working directory, filenames, header, delimiter, and CIK key before each consumer reads the handoff.
- After the R stage, confirm the staged scraper output has the fields and identifiers expected by the pcon import before running that builder.

### A04: Clarify the intended governor-flag producer and lineage before changing the R connection construction.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I04
Evidence: E_R_GOV_COMMENT, E_R_DPLYR_CALL, E_R_GOV_USE, E_SEMANTIC_FACTS

Preparation / proposed procedure:

1. Determine how DEF14A_output_stacked$governor is intended to be produced and passed through the existing stack/rowSums stages.
2. Retain the line 55 expression only as a conditional candidate until its effect on connection flags and the stacked schema is established; do not unconditionally uncomment it or invent a replacement.

Validation to perform later:

- Resolve the source-supported column lineage and whether the current commented assignment is intentional before proposing any source edit.
- Preserve the existing connection construction unless evidence supports a specific semantics-preserving change.

### A05: Complete ordinary setup for the missing reclink command and six R package distributions, and record versions for the available Stata add-ons. Official dplyr documentation identifies bind_rows as a documented function provider; its installed-release and paper-specific input-object compatibility remain untested. This action covers preparation and later version/API checks without asserting a function failure.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW06, SW07, SW08, SW09, SW11, SW12, SW13, SW14, SW15, SW16, I05
Evidence: E_STATA_ESTSTO_REHDFE, E_STATA_WINSOR, E_STATA_COEFPLOT, E_MERGER_RECLINK, E_R_PACKAGES, E_R_DPLYR_CALL, E_SW_ESTSTO_PROBE, E_SW_WINSOR_PROBE, E_SW_COEFPLOT_PROBE, E_SW_RECLINK_PROBE, E_R_PACKAGE_METADATA, E_ENV_META, E_DPLYR_BIND_ROWS_DOC_270

Preparation / proposed procedure:

1. The exact Stata 18 which checks found eststo, winsor, and coefplot. Their add-on release versions were not reported; record compatible versions during authorized setup.
2. The exact Stata 18 which check did not find reclink in the checked command paths. Arrange an appropriate authorized command version before the merger stage; this is a preparation task, not a license or data-access finding.
3. The bounded R package metadata check did not find edgar, edgarWebR, plyr, rvest, httr, or dplyr in the queried active library paths. Arrange ordinary package setup in an authorized environment; no package was loaded.
4. Official dplyr documentation lists bind_rows as a row-binding function. Keep installed-release, call/API, and paper-specific input-object compatibility unverified until a separately authorized run.

Validation to perform later:

- Record exact package and command versions for the required Stata add-ons and R distributions after authorized setup.
- The official descriptor supports the dplyr::bind_rows provider route only; verify the installed release and actual input-object compatibility in a separately authorized run, without treating documentation as a runtime result.

### A06: Preserve the supported interleaved native order for the full workflow and verify each producer output before its consumer; this is a future procedure after the unresolved input, handoff, source-edit, and software conditions are addressed.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I06
Evidence: E_MERGER_CLEAN_OUT, E_MERGER_ADDITIONAL_OUT, E_GEN_FED_SUB_OUT, E_GEN_ELEC_OUT, E_GEN_STATE_SUB_OUT, E_GEN_INHERITED_OUT, E_ASM_TWOPASS, E_ASM_CIK_EXPORT, E_R_OUTPUT, E_PCON_STATE_OUT, E_PCON_BOARD_OUT, E_PCON_CEO_STATE_OUT, E_PCON_CEO_FED_OUT, E_PCON_FIRM_OUT, E_PCON_LOBBY_SOURCE, E_ASM_FINAL_PANEL, E_ASM_FINAL_YEARS, E_ANALYSIS_PANEL, E_ANALYSIS_DETAIL

Preparation / proposed procedure:

1. From a project root containing the documented relative Data tree, run process_merger_data_final.do to create the cleaned SDC match table and fuzzy-match candidates; complete the checked-match stage and preserve the additional_inherited_from_thomson producer chain.
2. Run generate_connected_sub_years_final.do after its subsidy and merger inputs are staged; verify its federal_subsidies_final, governor/state connection, and inherited_subsidies outputs.
3. Run assemble_final_data.do for the first pass and stop at the documented CIK export. Stage the CIK file for the R reader using A03.
4. Run scrape_DEF_14A.r from its Data/Board working directory with the required filing-path manifest; stage its output for the Stata pcon reader using A03.
5. Run generate_pcon_vars_final.do after all contribution inputs and the staged board output are present; verify the generated firm/state/year and CIK/year tables before the second assembly pass.
6. Run assemble_final_data.do again to create the final panel, retaining the authored 2004-2016 final-sample restriction; then run analyses_final.do, including its separate detailed violation_data input.

Validation to perform later:

- Before each stage, verify the current working directory and exact producer paths; after each stage, check its actual output schema and keys before the next consumer.
- Keep the merger manual review, two-pass board handoff, and final detailed-violation analysis branch in scope; do not treat these as optional merely because the first pass can stop early.


## Remaining issues and prerequisites

- I01 [unresolved; full_pipeline]: Twenty author-code inputs are identified. A bounded SAS metadata/readability probe confirms all eleven R05-consumed fields are present and readable in the common COMP.FUNDA candidate. This does not verify the author-native file, target population/history, units, identifier meaning, or producer construction; the other required input routes also retain their documented unknowns. The native route and full data compatibility remain unresolved, without implying absence or a license barrier.
- I02 [unresolved; full_pipeline]: The merger workflow reads subsidy_mergers_raw_for_thomson without a documented producer, imports a separate hand-checked match file, and references CIK fields differently across two consumers of the inherited subsidy workbook. Those producer, header, and coverage contracts are unresolved.
- I03 [preparation; full_pipeline]: The assembler exports Data/cik_for_board_data_upload.txt while R reads Data/Board/cik_for_boardex_upload.csv. R writes the scraped output under Data/Board, while the Stata pcon builder reads Data/DEF14A_scraped_connected_firms.csv. These author-defined handoffs need path/name staging and import-format checks.
- I04 [unresolved; full_pipeline]: The R source comments out the governor assignment at line 55 and later reads a governor column at line 100. Before that parser, the assigned source QA records the stacked filing rows and a rowSums any-connection construction. Enabling the commented expression may change the connection construction; the current evidence does not establish a harmless repair or the intended column lineage.
- I05 [preparation; full_pipeline]: Bounded Stata 18 checks found eststo, winsor, and coefplot but did not report their add-on versions, and did not find reclink in the checked command paths; bounded R metadata did not find the six named package distributions. Official dplyr documentation identifies bind_rows as a documented provider, while installed-release/API and paper-specific input-object compatibility remain untested. The remaining items are ordinary setup and version-preparation tasks; no software was installed, no package was loaded, and no author code was run.
- I06 [unresolved; full_pipeline]: The complete target spans merger preparation, subsidy generation, a two-pass assembler, an R/Stata board handoff, pcon generation, and analysis. Several inputs and producer/schema mappings remain unverified, so the full workflow dependency closure is not established.
- R01 [undetermined]: Governor election input used to build governor-year/subsidy connections and merge election records into the firm-state-year panel. The code derives the first office year as election_year + 1; required coverage and headers remain unverified.
- R02 [undetermined]: Attorney general and governor party/status input consumed by the assembler; imported labels and key coverage have not been checked.
- R03 [undetermined]: State violation and penalty source used to create state_penalty_data, including historical CIK correction and penalty aggregation.
- R04 [undetermined]: Firm-state-year establishment measures with gvkey used as the assembler's panel base. The source file's exact column mapping and required coverage are not verified.
- R05 [undetermined]: Compustat firm-year input used for identifiers and financial controls in the assembled panel; exact population and historical coverage are unverified.
- R06 [undetermined]: CIK list used to restrict the assembler to the stated firm coverage universe; source construction and coverage are not established by the code excerpt.
- R07 [undetermined]: Firm-state-year federal violation aggregate consumed as a separate assembler input, with agency_code retained for the analysis by agency.
- R08 [undetermined]: Author subsidy recipient workbook consumed by the subsidy/year builder; the script renames the CIK and year fields and retains subsidy values.
- R09 [undetermined]: Inherited subsidy workbook read by both the subsidy/year builder and merger builder. The code refers to current_cik in one route and cik in the other; the actual workbook headers and compatible mapping remain unresolved.
- R10 [undetermined]: SDC merger source used by the merger builder, which filters public/completed transactions and creates a cleaned acquirer/target matching table before fuzzy matching. Required product population and fields are not verified.
- R11 [undetermined]: Subsidy recipient/parent-change records used as the GJF side of the Thomson/SDC fuzzy match; the supplied workflow does not establish the producer or provenance of this named input.
- R12 [undetermined]: Hand-checked fuzzy-match decisions imported after the code exports candidate matches; true-match selection and the checked file's provenance are mandatory for the merger branch.
- R13 [undetermined]: GVKEY/CUSIP/CIK/fiscal-year mapping input used to link merger CUSIPs back to subsidy records; the source fields and coverage are unverified.
- R14 [undetermined]: SEC filing path manifest read by the R board-scraping stage. The R working directory changes to Data/Board; CIK is a confirmed join key, while other required path/date fields and manifest coverage remain unresolved.
- R15 [undetermined]: Firm-state-year lobbying/contribution aggregate fuzzy-matched to gvkey; the pcon builder renames fyear and lobby_amount and fills firm-state-year keys.
- R16 [undetermined]: CEO-state contribution file with author-described hand-verified gvkey matches; the file is collapsed to firm-state-year PAC amounts.
- R17 [undetermined]: CEO federal PAC contribution input mapped to employer gvkey, then relabeled into party-specific amounts by the pcon builder.
- R18 [undetermined]: Corporate federal PAC contribution input mapped to gvkey, then relabeled into party-specific amounts by the pcon builder.
- R19 [undetermined]: Corporate lobbying records merged to gvkey and relabeled as federal lobbying by the pcon builder.
- R20 [undetermined]: Detailed violation rows merged into the analysis sample and collapsed by agency_code; this is a distinct requirement from the firm-state-year aggregate consumed during panel assembly.
- SW09 [preparation_required]: The exact Stata 18 which check did not find reclink in the checked command paths; this is a setup finding, not a license or data-access finding.
- SW11 [preparation_required]: The bounded R metadata check did not find the edgar distribution in the queried active R library paths; no package was loaded.
- SW12 [preparation_required]: The bounded R metadata check did not find the edgarWebR distribution in the queried active R library paths; no package was loaded.
- SW13 [preparation_required]: The bounded R metadata check did not find the plyr distribution in the queried active R library paths; no package was loaded.
- SW14 [preparation_required]: The bounded R metadata check did not find the rvest distribution in the queried active R library paths; no package was loaded.
- SW15 [preparation_required]: The bounded R metadata check did not find the httr distribution in the queried active R library paths; no package was loaded.
- SW16 [preparation_required]: The bounded R metadata check did not find the dplyr distribution in the queried active R library paths; no package was loaded. The dplyr::bind_rows function export was not loaded or function-checked.

## Review notes

- The static workflow review used the saved byte-first screened projections for the assigned code sources. Withheld source positions were not treated as missing statements. No author program was executed and no candidate data payload was opened or transformed.
- All source and environment claims are limited to the assigned work item, registered environment metadata, and the safe captured source excerpts. Local input availability, unprobed fields, coverage, and unresolved producer mappings remain explicit.
