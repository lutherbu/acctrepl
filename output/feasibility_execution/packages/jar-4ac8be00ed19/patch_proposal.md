# Patch proposal: jar-4ac8be00ed19

Implied Equity Duration: A Measure of Pandemic Shutdown Risk

DOI: 10.1111/1475-679X.12348

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author workflow for Tables 1–9 and Figures 2–6, including the WRDS SAS preparation programs and bundled Stata helpers; the separately described Excel Figure 1 is not a supplied executable branch.

Entry points: `Code/WRDS_data_1.sas`, `Code/WRDS_data_2.sas`, `Code/Tables and Figures.do`, `Code/ado files/ffind.ado`, `Code/ado files/fmb.ado`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 1/12348 - Implied-Equity-Duration-A-Measure-of-Pandemic-Shutdown-Risk/dess-datasheet-code-and-identifiers.zip",
      "sha256": "1b3400e51251973225ddb342cf0adbe8596ee635e94217461afe8d8bf3b34d19"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "447f4ba99e35c6904baebc0e56ee2f0a4fbe2f09fa98a597d16def1b2f3091db"
}
```

## Proposed actions

### A_NATIVE: Confirm the authorized local/WRDS sources behind the 13 native requirements, their fields, units, population and complete required date/history, and establish the SAS library binding. In particular, resolve whether catalogued CRSP.* products are the products intended by the CRSPQ.* source references. Once product, fields and coverage fit, ordinary libref/path binding or staging is preparation; the authors’ original libref names and identical source bytes are not required.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COMPD_FUNDA, R_COMPD_FUNDQ, R_CRSP_MSF, R_CRSP_MSEDELIST, R_CRSP_DSEDELIST, R_CRSP_MSENAMES, R_CRSP_DSF, R_CRSP_DSENAMES, R_CCM, R_FF_MONTHLY, R_FF_DAILY, R_IBES_DETU, R_IBES_ACTU, I_NATIVE_HISTORY, I_SAS_LIBREFS
Evidence: E_CATALOG, E_WORKFLOW_TRACE, E_P_COMPD_FUNDA, E_P_COMPD_FUNDQ, E_P_CRSP_MSF, E_P_CRSP_MSEDELIST, E_P_CRSP_DSEDELIST, E_P_CRSP_MSENAMES, E_P_CRSP_DSF, E_P_CRSP_DSENAMES, E_P_CRSP_CCM, E_P_FF_MONTHLY, E_P_FF_DAILY, E_P_IBES_DETU, E_P_IBES_ACTU, E_SAS_SOURCE_START, E_SAS2_SOURCE_START

Preparation / proposed procedure:

1. For each named COMPD, CRSP/CRSPQ, CCM, FF and IBES table, confirm source product and actual column mapping against its requirement fields; do not silently equate CRSPQ with CRSP.
2. Confirm source dates and units/population against construction needs: 1960+ annual/quarterly Compustat with the eight-quarter/four-quarter derived history; monthly CRSP with 11 prior monthly returns; daily return/name/delisting history through the 2020 Q1 construction; monthly/daily factor units; and the 2019–20 IBES forecast/actual windows and documented update.
3. After compatibility is established, configure the intended librefs or bind the compatible local table paths and prepare the inputs for the supplied SAS programs; if a local table does not fit, obtain the matching authorized source product.

Validation to perform later:

- Check product identity, expected source columns, units, population and required date/history before marking a route locally usable.
- Confirm the chosen LIBNAME/library setup resolves every supplied COMPD, CRSPQ, CRSP, FF and IBES table reference.

### A_FACTSET: Obtain the distinct FactSet return/equity-value input used by Figure 6 through an authorized FactSet route and verify its schema and coverage; it is not replaced by a CRSP table.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_FACTSET, I_FACTSET
Evidence: E_FACTSET_DOC, E_FACTSET_STATA, E_FIG6_APPEND, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Use the documented FactSet source for the named November 2020 file and confirm authorized account access.
2. Prepare FactSetReturns110520_111720.dta with the required PERMNO/date/return/market-equity fields, units and November 5–17 2020 observations at Data/FactSetReturns110520_111720.dta after path configuration.

Validation to perform later:

- Check the input has the fields and observation window used by the Figure 6 append; preserve it as a separate FactSet input.

### A_NWORDS: Confirm that the selected SAS/WRDS macro environment supplies the called %nwords macro; its definition is not present in either supplied SAS source, so no replacement is proposed.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: SW_NWORDS, I_NWORDS
Evidence: E_NWORDS, E_NWORDS_ACTIVE, E_SAS_SOURCE_START, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Check the documented WRDS or authorized local SAS macro setup for %nwords and confirm it is available to the active WINSORIZE macro calls.
2. If the intended environment does not supply it, obtain the source/provider or author instruction before changing the supplied macro.

Validation to perform later:

- In the chosen SAS environment, confirm macro resolution and intended variable-count behavior for the supplied WINSORIZE calls before running the full preparation programs.

### A_SAS_RUNTIME: Select an authorized SAS environment for the supplied DATA step, PROC SORT, UNIVARIATE, MEANS, SQL and PROC EXPORT programs, and confirm that its DTA export capability is available. The observed local TKELS initialization failure does not establish a licensing barrier.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, I_SAS_RUNTIME
Evidence: E_ENVIRONMENT, E_SAS1_EXPORT_PANEL, E_SAS1_EXPORT_PORT, E_SAS2_EXPORT_IBES, E_WRDS_DOC

Preparation / proposed procedure:

1. Use the documented WRDS Cloud route or an available SAS environment with the needed Base SAS procedures.
2. Confirm PROC EXPORT DBMS=DTA support in that chosen runtime and establish the run working directory before preparing the three generated DTA files.

Validation to perform later:

- Check the authorized runtime and DTA export capability in its documentation or environment setup before a future full pipeline run.

### A_GTOOLS: Set up the author-commented gtools package in the Stata environment; the source also calls gstats, gcollapse and gegen, which were not found in the checked adopaths.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_GTOOLS
Evidence: E_STATA_REQUIRED_PACKAGES, E_STATA_ADDITIONAL_TOOLS, E_P_GTOOLS, E_P_GSTATS, E_P_GCOLLAPSE, E_P_GEGEN

Preparation / proposed procedure:

1. In the authorized Stata environment, install/configure gtools as directed by the author comment and make its commands available on the adopath.

Validation to perform later:

- Use metadata-only which checks for gstats, gcollapse and gegen in the prepared Stata environment.

### A_FASTERTILE: Identify the source and version of the separately called fasterxtile command before setting it up; the author package does not identify its provider.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: SW_FASTERTILE
Evidence: E_STATA_FASTERTILE, E_P_FASTERTILE

Preparation / proposed procedure:

1. Confirm the intended fasterxtile distribution/provider and version from the authors or established project environment, then configure that command in Stata.

Validation to perform later:

- Run a metadata-only which check for fasterxtile after the source and version are confirmed.

### A_TABLE_ADDONS: Identify compatible sources/versions for the required frmttable and matselrc commands, which are called but not bundled or found on the checked adopaths.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: SW_FRMTABLE, SW_MATSELRC
Evidence: E_STATA_ADDITIONAL_TOOLS, E_STATA_MATSELR, E_P_FRMTABLE, E_P_MATSELRC

Preparation / proposed procedure:

1. Confirm the intended source and version for frmttable and matselrc, then configure the commands on the Stata adopath without changing table definitions.

Validation to perform later:

- Use metadata-only which checks for both commands in the prepared environment.

### A_ASREG: Expose the already-observed asreg 4.8 ado directory to Stata; the helper is available on the shared project adopath but not the default path.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: SW_ASREG
Evidence: E_ENVIRONMENT, E_STATA_ASREG

Preparation / proposed procedure:

1. From the shared project environment, add adopath ++ "output/reproductions/resources/ado" before the supplied Stata driver.

Validation to perform later:

- Confirm which asreg resolves to the shared path and reports version 4.8 in the configured session.

### A_BUNDLE_ADO: Add the bundled helper directory to Stata’s adopath and use the supplied fmb/ffind implementations unchanged, preserving their version 9.2 directives and fmb adjusted-R-squared behavior.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: SW_FMB, SW_FFIND
Evidence: E_STATA_REQUIRED_PACKAGES, E_FMB_VERSION, E_FMB_ADJR2, E_FFIND_VERSION, E_FFIND_CONTRACT, E_FMB_VERBOSE, E_STATA_FMB_CALLS

Preparation / proposed procedure:

1. From the project root, add adopath ++ "Code/ado files" before the supplied Stata driver.
2. Keep the bundled fmb.ado and ffind.ado contents unchanged; the supplied main driver already calls ffind type(49) and calls fmb without verbose.

Validation to perform later:

- Use metadata-only which checks to confirm Stata resolves the bundled fmb and ffind files from Code/ado files.

### A_PATH_CONFIG: In a working copy, configure all Stata inputs/outputs and all three SAS exports under one project-relative root so producer and consumer paths match. Launch both SAS programs and Stata from the project root; create Data and Results directories and stage generated files there if the SAS and Stata hosts differ.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_PATH_CONFIG
Evidence: E_STATA_PATHS, E_SAS1_EXPORT_PANEL, E_SAS1_EXPORT_PORT, E_SAS2_EXPORT_IBES, E_WORKFLOW_TRACE

**Proposed edit:** `Code/Tables and Figures.do:10–10`
Source SHA-256: `2952b7a5b5280c497a87dec44243602687773d1fee8ea41aeb4c5bdffa41c4c8`

Use a project-relative output directory when the supplied Stata program is launched from the project root.

Current text:
```
global path "[redacted-path-cfb0b9a6d42b]"
```

Proposed replacement:
```
global path "Results"
```

**Proposed edit:** `Code/Tables and Figures.do:13–13`
Source SHA-256: `2952b7a5b5280c497a87dec44243602687773d1fee8ea41aeb4c5bdffa41c4c8`

Read the SAS-produced panel from the shared project Data directory.

Current text:
```
global panel "[redacted-path-fa425497f217]" 
```

Proposed replacement:
```
global panel "Data/duration_panel.dta"
```

**Proposed edit:** `Code/Tables and Figures.do:16–16`
Source SHA-256: `2952b7a5b5280c497a87dec44243602687773d1fee8ea41aeb4c5bdffa41c4c8`

Read the SAS-produced portfolio file from the shared project Data directory.

Current text:
```
global port "[redacted-path-96facc3a6a6c]" 
```

Proposed replacement:
```
global port "Data/duration_portfolios.dta"
```

**Proposed edit:** `Code/Tables and Figures.do:19–19`
Source SHA-256: `2952b7a5b5280c497a87dec44243602687773d1fee8ea41aeb4c5bdffa41c4c8`

Read the second SAS program’s output from the shared project Data directory.

Current text:
```
global ibes "[redacted-path-08116f888439]" 
```

Proposed replacement:
```
global ibes "Data/ibes_2020q2.dta"
```

**Proposed edit:** `Code/Tables and Figures.do:22–22`
Source SHA-256: `2952b7a5b5280c497a87dec44243602687773d1fee8ea41aeb4c5bdffa41c4c8`

Place the distinct required FactSet input at the same configured project Data root.

Current text:
```
global fs "[redacted-path-4daf909aa16f]"
```

Proposed replacement:
```
global fs "Data/FactSetReturns110520_111720.dta"
```

**Proposed edit:** `Code/WRDS_data_1.sas:606–606`
Source SHA-256: `eff8606bcd3c6facf7b9a0be27534c1f0e4f074b0abb38cc4961676a41aa1eff`

Write the generated panel to the same project-relative Data path read by Stata.

Current text:
```
proc export data=duration_panel outfile='[redacted-path-2553debd9dfe]' dbms=dta replace;
```

Proposed replacement:
```
proc export data=duration_panel outfile='Data/duration_panel.dta' dbms=dta replace;
```

**Proposed edit:** `Code/WRDS_data_1.sas:630–630`
Source SHA-256: `eff8606bcd3c6facf7b9a0be27534c1f0e4f074b0abb38cc4961676a41aa1eff`

Write generated portfolios to the same project-relative Data path read by Stata.

Current text:
```
proc export data=alldata outfile='[redacted-path-1ce3c1ea4dc8]' dbms=dta replace;
```

Proposed replacement:
```
proc export data=alldata outfile='Data/duration_portfolios.dta' dbms=dta replace;
```

**Proposed edit:** `Code/WRDS_data_2.sas:226–226`
Source SHA-256: `b21201ec3cf9add5cdbced23f3d36f79cccc93f9aa2417faca521fd03cfb93c3`

Write the generated IBES/MNC file to the same project-relative Data path read by Stata.

Current text:
```
proc export data=data outfile='[redacted-path-45d0e62fe2ce]' dbms=dta replace;
```

Proposed replacement:
```
proc export data=data outfile='Data/ibes_2020q2.dta' dbms=dta replace;
```

Preparation / proposed procedure:

1. Apply the eight proposed path edits together in a working copy; do not apply only one side of a producer/consumer handoff.
2. Create project-root Data and Results directories before the future run.
3. If SAS and Stata run on different hosts, copy the three generated DTA outputs into the configured Data directory before Stata reads them.

Validation to perform later:

- Statically confirm that the three SAS outfile paths equal the Stata panel/portfolio/IBES paths and that the distinct FactSet path is under the same Data root.
- Confirm the launched working directory is the project root so the relative Data and Results paths resolve.

### A_RUN_ORDER: After resolving the cited source, software, SAS macro/runtime, FactSet and path requirements, run the supplied stages in their supported order; the two SAS programs are independent of each other, and both precede Stata.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: run procedure
Evidence: E_WORKFLOW_TRACE, E_SAS1_EXPORT_PANEL, E_SAS1_EXPORT_PORT, E_SAS2_EXPORT_IBES, E_ENTRY_PANEL, E_ENTRY_PORT, E_ENTRY_IBES, E_ENTRY_FACTSET

Preparation / proposed procedure:

1. Run Code/WRDS_data_1.sas to produce Data/duration_panel.dta → Code/Tables and Figures.do $panel (Tables 1–2, Table 6–9 and Figure 6), and Data/duration_portfolios.dta → $port (Tables 3–5 and Figures 2–5).
2. Run Code/WRDS_data_2.sas independently to produce Data/ibes_2020q2.dta → $ibes (Table 6 join and Tables 7–9). Both SAS programs must finish and their outputs be staged in the shared Data directory before starting the Stata driver; neither SAS program depends on the other’s DTA output.
3. Place the separately sourced Data/FactSetReturns110520_111720.dta alongside those inputs for the Figure 6 append; it is a distinct input.
4. Run Code/Tables and Figures.do from the configured project root after all paths and software are ready.

Validation to perform later:

- Before Stata, confirm each SAS output exists at the exact configured consumer path and has the fields required by the corresponding branch.
- Confirm FactSet remains separately available for Figure 6 and the workflow has not silently substituted a CRSP file.


## Remaining issues and prerequisites

- I_NATIVE_HISTORY [unresolved; full_pipeline]: The bounded local SAS probes confirm sampled readability and columns only. The full date bounds, source vintage, units, population and required history remain unverified; the scripts use 1960+ annual/quarterly inputs, 11 monthly lags, daily observations through the 2020 Q1 window, and 2019–20 IBES inputs.
- I_SAS_LIBREFS [unresolved; full_pipeline]: Neither supplied SAS program specifies a LIBNAME/include setup. The source uses COMPD, CRSPQ, CRSP, FF and IBES directly; the local catalog exposes the CRSP products under CRSP.*, so a CRSPQ-to-local mapping and the authorized working library setup need confirmation. This is a setup/compatibility question, not proof that the products are absent.
- I_NWORDS [unresolved; full_pipeline]: The active WRDS WINSORIZE macro calls %nwords(&vars), but the macro definition is not supplied in either SAS program. Its availability in the intended WRDS/local SAS macro environment is unknown.
- I_FACTSET [unresolved; full_pipeline]: Figure 6 appends a distinct FactSet file named FactSetReturns110520_111720.dta. The datasheet identifies its November 2020 source/date, but it is absent from the package and no compatible access route or fields/history have been verified. It is not interchangeable with the CRSP tables in the supplied program.
- I_SAS_RUNTIME [unresolved; full_pipeline]: The existing empty-session SAS probe fails during TKELS initialization. The local SAS runtime/version and PROC EXPORT DBMS=DTA support remain unverified; this does not establish entitlement or rule out the documented WRDS cloud environment.
- I_PATH_CONFIG [preparation; full_pipeline]: The SAS producers write three DTA files under [redacted-path-23ddccf20ba3], while Stata expects them under [redacted-path-5af06322f7f2]; Stata also writes outputs to an author-specific Overleaf Results path. Relocate these routine roots consistently in a working copy and run from one project root.
- R_COMPD_FUNDA [undetermined]: Annual Compustat North America fundamentals used for annual/quarterly variable construction and the MNC control. The source applies 1960+ annual filters in WRDS_data_1 and 2018–19 in WRDS_data_2.
- R_COMPD_FUNDQ [undetermined]: Quarterly Compustat fundamentals used to derive book equity, four-quarter earnings/operating leverage and eight-quarter sales growth before the quarterly-to-monthly merge.
- R_CRSP_MSF [undetermined]: Monthly CRSP security returns and prices used for monthly excess returns, delisting merges, rolling return history and firm market values in WRDS_data_1.
- R_CRSP_MSEDELIST [undetermined]: Monthly CRSP delisting returns and dates used to form monthly total returns in WRDS_data_1.
- R_CRSP_DSEDELIST [undetermined]: Daily CRSP delisting events used in both the monthly return/delisting construction and daily panel construction.
- R_CRSP_MSENAMES [undetermined]: CRSP monthly name/security intervals providing share codes, exchanges, CUSIP, ticker, SIC and company names for the monthly return/link panel.
- R_CRSP_DSF [undetermined]: Daily CRSP security prices/returns/shares used to build daily panel/portfolio inputs and the I/B/E/S adjustment/link file.
- R_CRSP_DSENAMES [undetermined]: Daily CRSP PERMNO/name intervals used for daily delisting exchange codes and I/B/E/S CUSIP linkage.
- R_CCM [undetermined]: CRSP/Compustat historical link table used in both the duration data builder and MNC-control builder.
- R_FF_MONTHLY [undetermined]: Monthly Fama–French risk-free factor series joined to monthly CRSP returns by calendar month.
- R_FF_DAILY [undetermined]: Daily Fama–French risk-free and market factor series used for daily excess returns and portfolio market-factor output.
- R_IBES_DETU [undetermined]: I/B/E/S US detail EPS forecasts used to compute December 2019 and April–May 2020 Q2 forecasts and the December 2019 FY2 consensus.
- R_IBES_ACTU [undetermined]: I/B/E/S US quarterly actual EPS records joined to the 2020 Q2 forecast periods by ticker and period end.
- R_FACTSET [undetermined]: Distinct FactSet security returns and equity market values used for Figure 6 around the November 2020 vaccine announcements.
- SW_SAS [unverified]: The two author preparation programs use Base SAS DATA/PROC SORT/UNIVARIATE/MEANS/SQL and PROC EXPORT DBMS=DTA. The existing local empty-session probe fails during TKELS initialization; no entitlement conclusion is supported, and DTA export support is unverified.
- SW_GTOOLS [preparation_required]: The author comments require gtools; metadata checks found gstats, gcollapse and gegen absent from the checked Stata adopaths.
- SW_FASTERTILE [preparation_required]: The active Stata code calls fasterxtile, which is not found in the checked adopaths. Its provider/version is not named by the author package comment.
- SW_FRMTABLE [preparation_required]: The supplied Stata program calls frmttable repeatedly; it is not found in the checked adopaths and no version/source is bundled.
- SW_MATSELRC [preparation_required]: The supplied Stata program calls matselrc; it is not found in the checked adopaths and no version/source is bundled.
- SW_ASREG [preparation_required]: asreg 4.8 is found in the shared project adopath only after adding output/reproductions/resources/ado; it is absent from the default adopath.
- SW_FMB [preparation_required]: The supplied Fama–MacBeth helper is bundled at Code/ado files/fmb.ado and declares version 9.2. Its original implementation, including adjusted-R-squared behavior, is retained; add the directory to the Stata adopath.
- SW_FFIND [preparation_required]: The numeric SIC-to-FF49 helper is bundled at Code/ado files/ffind.ado and declares version 9.2. Add that directory to the Stata adopath so the supplied mapping is resolved.
- SW_NWORDS [unverified]: WRDS_data_1 calls %nwords(&vars) in an active WINSORIZE macro, but no definition/include is present in the supplied programs; availability in the WRDS/local macro environment is unknown.

## Review notes

- Completed the supplied workflow review and mapped all 28 frozen dependency IDs to generated stages, native source requirements, or the unselected verbose-only fmb tempfile. The 13 bounded native SAS probes establish sampled readability and columns only; full coverage, history, units and population remain unverified. FactSet remains a distinct unverified Figure 6 input, and the packaged PERMNO/date panel is identifier-only, not analysis data. Stata 18 is available; the main driver has no version directive while bundled fmb and ffind declare version 9.2, with the supplied fmb adjusted-R-squared implementation preserved. SAS runtime/DBMS=DTA support, library and CRSPQ mapping, %nwords availability, several Stata command providers/path setup and source-history contracts remain unresolved or preparation items. No author program, estimation or regression was executed; computed readiness and data status remain undetermined.
