# Patch proposal: jar-cbdd0bf37a75

Information Spillovers at Earnings Announcements

DOI: 10.1111/1475-679X.12562

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow, including SAS event-panel preparation, comparability preparation, the SAS Vuong companion and all active Stata branches; no separate analysis-only scope is supported by the packaged identifiers list.

Entry points: `code/0masterfile.sas`, `code/3_mainanalysis.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 1/12562 - Information-Spillovers-at-Earnings-Announcements/fgr-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "a33993f17136a543c1b12d11b52088f02b0adcdfead77d0b6f98798b7dbff89f"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "8140b89766140896e5978a853d6e68f278071c59e3d116c8b911a832f2be2deb"
}
```

## Proposed actions

### A_SOURCE_CONTRACTS: Reconcile the exact local source tables against the code's columns, keys, source products and date/history requirements while retaining the separate jointly required inputs.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMP_FUNDA, R_COMP_FUNDQ, R_COMP_COMPANY, R_CRSP_DSF, R_CRSP_DSIX, R_CRSP_DSEDELIST, R_CRSP_STOCKNAMES, R_CRSP_MSF, R_CRSP_CCM_LINK, R_IBES_ACTUAL, R_IBES_DETAIL, I_SOURCE_COVERAGE, I_PRODUCT_SEMANTICS
Evidence: E_CATALOG, E_COMP_ANNUAL_INPUT, E_COMP_QUARTER_INPUT, E_COMP_HISTORY, E_COMP_TARGET_YEARS, E_COMP_COMPANY_JOIN, E_CRSP_ADJUSTMENT, E_CRSP_TRADING_DATES, E_CRSP_RETURN_WINDOW, E_CRSP_EXPAND, E_CRSP_DELIS_NAMES, E_CCM_LINK_INPUT, E_CRSP_MONTHLY_INPUT, E_IBES_ACTUAL_INPUT, E_IBES_DETAIL_INPUT, E_IBES_ESTIMATE_MATCH, E_PROBE_COMP_FUNDA, E_PROBE_COMP_FUNDQ, E_PROBE_COMP_COMPANY, E_PROBE_CRSP_DSF, E_PROBE_CRSP_DSIX, E_PROBE_CRSP_DSEDELIST, E_PROBE_CRSP_STOCKNAMES, E_PROBE_CRSP_MSF, E_PROBE_CRSP_CCM_LINK, E_PROBE_IBES_ACTUAL, E_PROBE_IBES_DETAIL

Preparation / proposed procedure:

1. Check that the exact catalog-listed Compustat, CRSP and I/B/E/S source tables provide the fields and join keys used in both SAS preparation programs; retain annual Funda, quarterly Fundq, company classifications, each CRSP table, and each I/B/E/S EPS table as separate jointly needed inputs.
2. Confirm required periods from the source code: annual/quarterly comparability history through 1995–2022, the 15-quarter estimation window, event fiscal periods 1999–2022, CRSP daily buffers from 1 Jul 1998 through 30 Jun 2023, and three monthly CRSP returns for each linked fiscal quarter. Confirm compatible identifier/link mappings and forecast/actual filters.
3. Confirm that the selected CRSP.DSIX series supplies the market-return meaning consumed as VWRETD, and that COMP.COMPANY's GVKEY-level ggroup/gind/gsector/gsubind fields have the classification coding/population the Stata branches expect. The supplied code joins company classifications by GVKEY without date matching; do not impose a historical panel requirement.
4. Use a compatible available source/history and the documented transformations; do not require author-identical file bytes or an unneeded generic full-data sweep.

Validation to perform later:

- Before any later authorized run, document that each required table's relevant columns, identifiers and code-specified date history are available and that DSIX/COMP.COMPANY semantics match the consumed fields.

### A_WRDS_MACROS: Confirm an authorized WRDS SAS/CONNECT host and the two documented I/B/E/S link-macro includes, including the generated link-table contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_WRDS_MACROS, SW_SAS_CONNECT
Evidence: E_DOC_PRODUCTS, E_BUILD_REMOTE, E_BUILD_LINK_MACROS, E_PROBE_IBES_ACTUAL, E_PROBE_IBES_DETAIL

Preparation / proposed procedure:

1. On the authorized remote SAS environment, confirm that [redacted-path-d7906ae55924] and iclink.sas are present and callable by the supplied source, and that the configured remote submit path is usable.
2. Confirm the macro outputs, including CIBESLNK and HOME.ICLINK, provide the identifiers and fields consumed by the native code for GVKEY/PERMNO/TICKER matching. Do not substitute an independently reconstructed link.

Validation to perform later:

- Before any later authorized run, document the include paths, remote connection configuration, output schemas and key mapping needed by the sample builder.

### A_MACRO_EVENTS: Obtain or locate the author-documented macro-event workbook through an authorized route and preserve the Stata import contract.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_MACRO_EVENTS, I_MACRO_FILE
Evidence: E_STATA_MACRO, E_DOC_PRODUCTS, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Locate the compatible eco 97-24.xls workbook or obtain the documented Bloomberg Terminal event export through authorized access; no public alternative or access barrier has been verified.
2. Confirm the exact sheet name and that the prescribed Stata import yields Event, DateTime and B, with usable event/time records for the code's event-type filters and 1997–2022 period. If a supported file-format conversion is needed, preserve the imported variables and values.

Validation to perform later:

- Before Stata analysis, confirm that the specified workbook/sheet imports the required variables and the retained event records cover the code's stated filters and years.

### A_PANEL_VARIANTS: Generate the four nondefault Stata input panels from the supplied SAS producer using the corresponding author-defined industry and day-gap settings, then honor the native cross-language handoff order.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_PANEL_VARIANTS
Evidence: E_MASTER_ORDER, E_BUILD_REMOTE, E_BUILD_OUTPUT, E_STATA_BRANCHES, E_STATA_GIND_BRANCH, E_STATA_DAY_BRANCHES, E_STATA_SICH3_BRANCH, E_VUONG_SCALE_STEP, E_VUONG_MACRO

Preparation / proposed procedure:

1. In separate working copies or controlled repeated preparations, set both code/1_buildregressionsample.sas macro-assignment pairs consistently for each output: naicsh/10, gind/10, sich/5 and sich/3. Preserve the original sich/10 baseline settings and scientific code.
2. Follow the master’s documented interleaving: run code/1_buildregressionsample.sas, then code/2_comparability_defranco.sas, prepare the alternative panels before Stata needs them, run code/3_mainanalysis.do at the documented Stata handoff, then run code/4_vuongtest.sas. The master places SAS block 4 after the Stata handoff comment; that comment does not itself execute Stata. code/labvar.do is an included Stata helper.
3. The Vuong companion first fits the two supplied regressions and its comments direct the analyst to the RMSE output; the included macro call already carries author-supplied scale1=0.33110 and scale2=0.33127. Preserve these supplied values and clarify any discrepancy against the intended source data rather than inventing replacements.

Validation to perform later:

- Confirm each expected EAD_ret_vol_<industry><daysapart> SAS/Stata handoff is produced from its matching configuration and that Stata's baseline, alternative-industry and alternative-day branches each resolve to their corresponding panel.
- Confirm the SAS Vuong stage follows the Stata handoff and uses the supplied macro inputs and scale values as documented.

### A_HOST_PATHS: Prepare a writable host-visible working copy with one consistent project root and preserved code/data/log/processed directories.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_HOST_PATHS
Evidence: E_MASTER_PATHS, E_STATA_ROOT, E_BUILD_OUTPUT, E_MASTER_ORDER, E_STATA_HANDOFF

Preparation / proposed procedure:

1. In a separate working copy, map the author Windows code, data, table, log and Stata cwd roots to a writable location on the intended host. Keep all producer and consumer roots consistent and preserve the expected subdirectory layout.
2. Confirm the directory is visible and writable for SAS logs, SAS/Stata outputs and processed files before a future authorized run. Leave the frozen package unchanged.

Validation to perform later:

- Verify the chosen root resolves every documented relative input/output path and that required output directories can be written on the target host.

### A_STATA_EXTENSIONS: Configure the required Stata add-on not found in the checked paths; the exact-name eststo availability check has succeeded.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_WINSOR2, I_STATA_EXTENSIONS
Evidence: E_ENVIRONMENT, E_STATA_SOFTWARE, E_PROBE_ESTSTO

Preparation / proposed procedure:

1. Confirm winsor2 is available on the intended Stata adopath; the original bounded check did not find it in its two checked paths, so install or configure it only as appropriate for that environment.
2. The exact-name eststo metadata check succeeded in the assessed environment. Retain that available command in the target analysis session; no eststo installation action is indicated by this result.

Validation to perform later:

- Before Stata analysis, confirm winsor2 is exposed in the intended session and that eststo remains available there if the analysis environment changes.

### A_SAS_PRODUCTS: Verify the SAS runtime and the specific services/procedures/export engines required by the supplied source on the intended host.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, SW_SAS_CONNECT, SW_SAS_STAT, SW_SAS_ETS, SW_SAS_CAS, SW_SAS_EXPORT, I_SAS_RUNTIME
Evidence: E_ENVIRONMENT, E_BUILD_REMOTE, E_BUILD_LINK_MACROS, E_MASTER_CAS, E_MASTER_CAS_END, E_VUONG_PROCS, E_CRSP_EXPAND, E_BUILD_OUTPUT, E_COMP_EXPORTS, E_VUONG_EXCEL1, E_VUONG_EXCEL2

Preparation / proposed procedure:

1. Confirm successful batch startup of the intended SAS runtime/version without running the author programs; the recorded original SAS probe did not establish startup and did not establish a license/access barrier.
2. Confirm required remote-submit/PROC DOWNLOAD support, both PROC CAS master logging calls, PROC REG and PROC SURVEYSELECT, PROC EXPAND, and the DBMS=STATA/EXCEL PROC EXPORT engines on that host. Confirm product/service availability with the host administrator or documented local SAS configuration as needed.

Validation to perform later:

- Before any later authorized author-code execution, confirm each required procedure, remote service and export engine is available in the configured SAS session.


## Remaining issues and prerequisites

- I_SOURCE_COVERAGE [unresolved; full_pipeline]: All 11 exact catalog-listed table probes succeeded and returned the requested column names, but each read one row with coverage_verified=false. Required history includes Compustat annual/quarterly comparability records for 1995–2022 and the 15-quarter lookback with 14–16 complete records, plus the 1999–2022 event construction, CRSP daily two-quarter buffers (1 Jul 1998–30 Jun 2023), linked quarterly/monthly observations and I/B/E/S fiscal-period/report-date matches. Probe samples do not establish the required rows, identifiers or full history.
- I_PRODUCT_SEMANTICS [unresolved; full_pipeline]: The catalog describes CRSP.DSIX as a capitalization-decile series while the author program uses its VWRETD field as the market return; the candidate's exact series meaning remains unverified. COMP.COMPANY exposes the probed GICS classification field names, but its GVKEY population and field coding are not established. The source joins these classifications by GVKEY without date matching, so no time-varying historical-classification panel is required.
- I_WRDS_MACROS [unresolved; full_pipeline]: The sample builder includes WRDS CIBESLINK and ICLINK source files under [redacted-path-4a3670aff8a2] and reads the resulting CIBESLNK/Home.ICLINK link inputs inside a remote-submit workflow. Those include files, remote SAS/CONNECT configuration and the generated link table's complete schema/population were not verified; no access or entitlement barrier is inferred.
- I_MACRO_FILE [unresolved; full_pipeline]: Stata requires data/eco 97-24.xls, sheet 5424185_20240104_214940_eco, and imported Event, DateTime and B variables for the 1997–2022 event filters. The workbook is not in the frozen package inventory; the datasheet names Bloomberg Terminal as the source, but a compatible local workbook, sheet/column mapping and access route were not verified.
- I_PANEL_VARIANTS [preparation; full_pipeline]: The Stata script consumes naicsh10, gind10, sich5 and sich3 panels in addition to the sich10 baseline. The supplied SAS producer supports the industry/day-gap macro settings, but its recorded default is only sich/10; the four additional outputs must be generated with consistent settings at both producer assignments before Stata consumes them.
- I_HOST_PATHS [preparation; full_pipeline]: The SAS master, preparation/companion files and Stata entry point contain author-host Windows project roots. A writable, host-visible working copy with the same code/data/log directory relationships must be configured before a later attempt; this is path setup, not a scientific source repair.
- I_STATA_EXTENSIONS [preparation; full_pipeline]: The supplied Stata analysis invokes winsor2 and eststo. The exact-name eststo command check succeeded; winsor2 was not found in the two adopaths checked by the original environment probe, and availability outside those paths remains unverified.
- I_SAS_RUNTIME [unresolved; full_pipeline]: The original environment probe did not establish successful SAS startup. The supplied workflow requires SAS remote-submit, PROC CAS for master logging, PROC REG/SURVEYSELECT, PROC EXPAND, and DBMS=STATA/EXCEL export support. Runtime/product/service availability remains unverified; the recorded startup diagnostic is not evidence of a license barrier.
- R_COMP_FUNDA [undetermined]: Compustat annual fundamentals used to construct event and comparability samples, including industry filters and annual fiscal periods.
- R_COMP_FUNDQ [undetermined]: Compustat quarterly fundamentals used for announcement matching and quarterly comparability measures; it is jointly required with annual fundamentals.
- R_COMP_COMPANY [undetermined]: Compustat company classification fields joined by GVKEY to support supplied industry variants; the author code does not date-match these fields.
- R_CRSP_DSF [undetermined]: CRSP daily stock records used to adjust I/B/E/S EPS for split factors, build focal/peer daily returns and volume, and construct rolling three-day returns.
- R_CRSP_DSIX [undetermined]: CRSP daily index candidate for trading-day alignment and the code's `VWRETD` market-return field. The catalog label describes capitalization deciles, so the specific market-series meaning remains unverified despite a readable field.
- R_CRSP_DSEDELIST [undetermined]: CRSP daily delisting events joined to daily stock returns to construct delisting-adjusted returns.
- R_CRSP_STOCKNAMES [undetermined]: CRSP name/share-code validity intervals used to retain ordinary common shares in the daily return panel.
- R_CRSP_MSF [undetermined]: CRSP monthly stock returns and prices used to construct quarterly buy-and-hold returns and market value for comparability estimation.
- R_CRSP_CCM_LINK [undetermined]: Dated CRSP/Compustat CCM link history required by the comparability program to map GVKEY records to PERMNOs.
- R_IBES_ACTUAL [undetermined]: Unadjusted US quarterly actual EPS used to form the Compustat/I/B/E/S announcement-date match and observed earnings surprises.
- R_IBES_DETAIL [undetermined]: Unadjusted US detail EPS forecasts used to calculate consensus estimates and surprise measures, with the author-specified forecast-period indicators and analyst filters.
- R_MACRO_EVENTS [undetermined]: The Stata Table 9 macro-news branch requires the author-specified macro-event workbook and its imported event/date/time fields; it is a separate input jointly used with the generated analysis panel.
- SW_WINSOR2 [preparation_required]: The required Stata command was not found in the two checked adopaths in the original environment record; availability elsewhere is not ruled out.
- SW_SAS [unverified]: The original environment record did not establish a successful SAS runtime startup. Its diagnostic is not evidence of a missing license or blocked access.
- SW_SAS_CONNECT [unverified]: The SAS sources use remote-submit/download and WRDS link-macro calls; availability of the CONNECT service and authorized WRDS session configuration was not established.
- SW_SAS_STAT [unverified]: The companion program invokes PROC REG and PROC SURVEYSELECT; their host product support was not established by the environment record.
- SW_SAS_ETS [unverified]: The event-panel source invokes PROC EXPAND; its host product support was not established by the environment record.
- SW_SAS_CAS [unverified]: The master invokes PROC CAS; the original SAS startup probe did not establish PROC CAS availability or session support.
- SW_SAS_EXPORT [unverified]: The scripts use PROC EXPORT for Stata and Excel outputs; exact host engine support was not established by the environment probe.

## Review notes

- Static, package-specific assessment only. No author SAS or Stata program, runtime, model, data analysis, parser, or statistical estimation was executed; execution_verified remains false.
- Native source files were byte-screened before review. Authentication/connection/example blocks and all raw author-log content remained opaque; the log was used only through its frozen hash/inventory metadata.
- The eleven successful one-row source probes preserve their exact source-field credit and establish readable local candidates only; none establishes complete population/date coverage. No original author file-byte identity or generic full-data sweep is required when the documented source product, fields, history and transformation are supported.
- COMP.COMPANY classifications are joined by GVKEY without date matching in the supplied code. The assessment keeps only row-population/classification semantics open and does not require a time-varying historical-classification panel.
- The packaged identifiers.dta is an identifier list, not a full analysis panel, so no analysis_only scope is supported. The full SAS-to-Stata workflow and the separate SAS Vuong companion remain in scope.
- All 58 frozen dependency IDs are reviewed. Generated intermediates cite their active producers; distinct jointly needed raw tables remain separate requirements; unresolved WRDS and macro-workbook inputs remain explicit rather than inferred as blocked.
- The environment record is cited only for its exact-name software status. Its SAS startup diagnostic does not establish a license barrier; no software was installed and no source/data payload was downloaded. An exact-name eststo metadata probe succeeded at software:eststo; winsor2 remains not found in the checked adopaths.
