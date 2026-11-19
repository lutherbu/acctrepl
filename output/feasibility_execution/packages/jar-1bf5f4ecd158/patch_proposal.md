# Patch proposal: jar-1bf5f4ecd158

Earnings News and Over-the-Counter Markets

DOI: 10.1111/1475-679X.12522

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied mixed SAS-to-R workflow: manually stage the TRACE Enhanced source and author-described WRDS/TAQ linking inputs, run the SAS TRACE cleaner, perform the documented conversion to the RDS input, then run the master R workflow including pooled and trade-size branches, TAQ matching, tables, and figures. The companion matched-pair program is retained as a required stage despite the master's current wrong source path.

Entry points: `code/data_cleaning_construction/00_wrds_clean_trace_enhanced_file.SAS`, `code/master_script.R`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 2/12522 - Earnings-News-and-Over-the-Counter-Markets/hkw-datasheet-code-and-identifiers.zip",
      "sha256": "84860857b3d1211c9a1902d5f48c7371b34a22ccdf87ef2fd09a575aca634d3b"
    },
    {
      "path": "JAR-Volume 62/Issue 2/12522 - Earnings-News-and-Over-the-Counter-Markets/hkw-online-appendix.pdf",
      "sha256": "c8c810b010b6d61e468597b8a65ab2467ac32f9e085ce196f7115f6d2f337b04"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "580e8ad9fe7f4177bee800980355eea68c37cfec1c4bd2d75a9375d115525d52"
}
```

## Proposed actions

### A_DRIVER_PATHS: Correct the two master include targets to supplied files: call 04a_merge_ea_trace_eventtime_by_tradesize.R for the size branch and 06_matched_pair_data_construct.R for matched-pair construction. Keep the native SAS-to-R branch order.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_DRIVER_PATHS
Evidence: E_MASTER_04A_PATH, E_MASTER_06_PATH, E_MASTER_BRANCHES

**Proposed edit:** `code/master_script.R:52–52`
Source SHA-256: `5d3312afbfb054c2dbd0cb71347dbb88a063af170ab1d6bb71103c522b5b8d42`

The supplied branch file is named 04a_merge_ea_trace_eventtime_by_tradesize.R.

Current text:
```
source('data_cleaning_construction/04_merge_ea_trace_eventtime_by_tradesize.R')
```

Proposed replacement:
```
source('data_cleaning_construction/04a_merge_ea_trace_eventtime_by_tradesize.R')
```

**Proposed edit:** `code/master_script.R:60–60`
Source SHA-256: `5d3312afbfb054c2dbd0cb71347dbb88a063af170ab1d6bb71103c522b5b8d42`

The master currently invokes R05 a second time, while the next documented dependency is the supplied R06 matched-pair constructor.

Current text:
```
source('data_cleaning_construction/05_taq_event_construct.R')
```

Proposed replacement:
```
source('data_cleaning_construction/06_matched_pair_data_construct.R')
```

Validation to perform later:

- Confirm both target files exist in the assigned package and the master order is SAS cleaner, R01, R02/R02a, R03, R04/R04a, R05, R06, tables, figures.

### A_TRACE_HANDOFF: Preserve the supplied manual CSV-to-RDS handoff between SAS and R. Stage the converted file at the exact R01 consumer path or change the R01 path to the documented staging path; establish and record a schema/type/date conversion contract from the same generated CSV.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: I_TRACE_HANDOFF, R_TRACE
Evidence: E_MASTER_MANUAL, E_SAS_EXPORT, E_R01_INPUT

Preparation / proposed procedure:

1. Run the SAS cleaner only in the authorized future run after local connection settings are configured.
2. Convert the generated temporary CSV into the RDS format that R01 consumes; do not treat either RDS path as an externally required raw dataset.
3. Resolve the clean_data versus cleaned_data spelling through one documented work-copy path and record column names, types, date handling, and NA handling from the generated export.

Validation to perform later:

- Confirm the producer output and R01 input refer to the same staged RDS file and its schema preserves the fields used downstream.

### A_WORKDIRS_AND_LINK_PATH: Configure a single work-copy code root and a shared relative data/link path for R04, R04a, R06, and analysis scripts. Initialize datapath inside analysis_tables.R after its environment reset rather than relying on a variable left by another sourced script.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_LOCAL_PATHS, I_TABLE_GLOBAL
Evidence: E_04_BONDLINK, E_04A_LINK, E_TABLE_PATHS, E_TABLE_DATAPATH_READ, E_06_OUTPUT

Preparation / proposed procedure:

1. Choose the documented code directory as the R working directory for the work copy.
2. Replace machine-specific working-directory and bond-link references with one local configuration or relative path shared by both event-time branches.
3. Set datapath explicitly in analysis_tables.R before reading matched outputs.

Validation to perform later:

- Resolve every package-relative RDS and link path from the configured work directory without using an author workstation path.

### A_FIGURE_EXPORT_NAMES: Clarify the intended PDF filenames or index behavior before editing; the supplied script shows no loop binding for i.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_FIGURE_I
Evidence: E_FIGURE_I, E_FIGURE_INDEX_ALL

Preparation / proposed procedure:

1. Remove the unresolved i suffix from the four figure output names if only one output per call is intended, or define the intended index at the source of those calls.

Validation to perform later:

- Confirm all four figure paths are uniquely named and require no undefined object.

### A_SECURE_CONNECTION_SETUP: Use approved local secure configuration for SAS librefs and the R WRDS database connection. Keep credentials outside the copied source and do not infer connection success from a catalog entry.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_AUTH_CONFIG
Evidence: E_AUTH_SCAN, E_REDACTED_SOURCE_VIEW, E_ENVIRONMENT

Preparation / proposed procedure:

1. Configure access using the user's already authorized local institutional route and approved secret storage.
2. Preserve the original author connection/helper code and keep runtime values out of the submitted draft and logs.

Validation to perform later:

- Verify configuration only in the authorized future run; no credentials or endpoint payloads should be included in shared evidence.

### A_VERIFY_DATA_COVERAGE: For each required input, check the local or institutionally licensed source actually available to the researcher against the code-used fields, identifiers, and historical dates. A prepared compatible author/source copy can satisfy the same input; do not require byte identity, full-row cleaning, or an additional raw-data rebuild when an equivalent prepared input is supported.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: I_REQUIRED_DATA_COVERAGE, R_TRACE, R_FISD_ISSUE, R_FISD_RATINGS, R_IBES_LINK, R_CCM_LINKTABLE, R_COMP_SECURITY, R_IBES_DETAIL, R_IBES_ACTUAL, R_CRSP_DSI, R_CRSP_DSF, R_COMP_FUNDQ, R_BOND_LINK, R_CCM_LNKHIST, R_TAQ_IID, R_TAQMCLINK
Evidence: E_CATALOG_BATCH1, E_CATALOG_BATCH2, E_PROBE_CAPTURE, E_PUBLIC_BOND_LINK, E_PUBLIC_TAQ, E_PUBLIC_FISD, E_PUBLIC_COMPUSTAT, E_PUBLIC_CRSP

Preparation / proposed procedure:

1. Use the per-table requirements below as separate joint inputs; do not collapse CCMXPF_LINKTABLE and CCMXPF_LNKHIST or the two IBES tables.
2. For local catalog candidates, confirm relevant years, identifiers, and nonmissing fields beyond the one-row structural probes.
3. For missing manual files, use a compatible author-prepared file or an explicitly documented alternative route, then validate that it supplies the same code-consumed keys and validity dates.
4. Retain TAQ's direct code input as the prepared taq_iid.RDS plus taqmclink.sas7bdat mapping; a raw TAQ acquisition is only an upstream alternative for deriving that same input.

Validation to perform later:

- Record what exact route, source version, period, and key fields satisfy each requirement; a timeout/catalog miss is not evidence of absent data or absent entitlement.

### A_RECORD_IBES_VINTAGE: Record the IBES data vintage and the history/ID treatment used for this replication; preserve the supplied forecast/actual construction and do not alter sample definitions based only on the vendor alert.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_IBES_VINTAGE, R_IBES_DETAIL, R_IBES_ACTUAL
Evidence: E_PUBLIC_IBES, E_03_QUERY, E_03_ACTUALS

Preparation / proposed procedure:

1. Identify the historical forecast/actual extract or compatible current route used by the original authors and document any post-2018 identifier versioning.

Validation to perform later:

- Verify the selected vintage contains the author-used ticker, estimator, analyst, report-date, and actual-date fields for the code-defined sample window.

### A_RUN_NATIVE_WORKFLOW: After the source-path and input handoffs are prepared, follow the supplied SAS-to-R pipeline and retain the generated intermediates for the downstream branches. Do not reconstruct the study with a different language architecture.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_DRIVER_PATHS, I_TRACE_HANDOFF, I_LOCAL_PATHS, I_TABLE_GLOBAL, I_FIGURE_I, I_AUTH_CONFIG, I_REQUIRED_DATA_COVERAGE
Evidence: E_MASTER_MANUAL, E_MASTER_BRANCHES, E_SAS_EXPORT, E_04_OUTPUT, E_04A_OUTPUT, E_05_OUTPUT, E_06_STOCKS_OUT, E_06_PAIRS_OUT, E_06_PLOT_OUT

Preparation / proposed procedure:

1. Run the SAS TRACE cleaner to generate its CSV output, then perform the manual CSV-to-RDS handoff.
2. Run R01, both R02 branches, R03, both R04 event-time branches, R05, and R06 in the master order after fixing includes.
3. Run tables and figures against the generated R04/R04a/R06 products after configuring local paths.

Validation to perform later:

- Preserve each future command's actual argv, cwd, return code, stdout, and stderr; report absent capture fields as null rather than reconstructing them.
- Check expected generated outputs at their declared consumer paths before interpreting any estimates or figures.

### A_R_PACKAGE_SETUP: Check the author-referenced R package and namespace set in the authorized R environment and record the versions available before a future run.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_R_PACKAGES, SW_RPOSTGRES
Evidence: E_MASTER_IMPORTS, E_R01_IMPORTS, E_R02_IMPORTS, E_R02A_IMPORTS, E_R03_IMPORTS, E_R04_IMPORTS, E_R04A_IMPORTS, E_R05_IMPORTS, E_R06_IMPORTS, E_TABLE_IMPORTS, E_FIGURE_IMPORTS

Preparation / proposed procedure:

1. Compare installed package availability and versions with the static import/namespace list in this draft.
2. If the researcher's authorized environment lacks a required package, prepare it through the normal user-managed environment process before the author workflow is separately run.

Validation to perform later:

- Record the environment and package versions used for the future author run.

### A_SAS_ENVIRONMENT_SETUP: Resolve the baseline SAS 9.4 runtime initialization uncertainty in the authorized host environment before the author SAS cleaner is separately run.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS
Evidence: E_ENVIRONMENT, E_SAS_INPUT

Preparation / proposed procedure:

1. Confirm the intended SAS 9.4 runtime is initialized in the research environment using its approved machine setup procedure.
2. Keep environment diagnosis separate from the author's data-cleaning script.

Validation to perform later:

- Record the runtime readiness result before any separately authorized SAS workflow execution.


## Remaining issues and prerequisites

- I_DRIVER_PATHS [preparation; full_pipeline]: The master points to an absent trade-size script name instead of the supplied 04a file, then sources the TAQ constructor again where the supplied matched-pair constructor is needed. This prevents the master's documented branch/output order from closing.
- I_TRACE_HANDOFF [unresolved; full_pipeline]: The SAS cleaner writes a temporary CSV; the master describes a manual CSV-to-RDS conversion, but the documented cleaned_data path and R01's cleaned_data path differ and the package supplies no typed conversion recipe or RDS.
- I_LOCAL_PATHS [preparation; full_pipeline]: R04 contains a machine-specific bond-link path and the table/matched-pair scripts set a machine-specific code working directory. A coherent work-copy root and shared relative link path are needed.
- I_TABLE_GLOBAL [preparation; full_pipeline]: The table script reads matched outputs through datapath without setting it locally; the master clears the global environment before sourcing the analysis script. Give this script an explicit local data path.
- I_FIGURE_I [preparation; full_pipeline]: Four PDF export filenames concatenate an i variable with no visible loop binding; determine the intended stable filenames or bind a documented index before producing figures.
- I_AUTH_CONFIG [unresolved; full_pipeline]: The scanner-flagged SAS and R connection/libref blocks remain wholly withheld, so the draft cannot establish the author connection configuration. Configure required librefs/DB connections through an approved local secure setup; no credential was copied and no connection was attempted.
- I_REQUIRED_DATA_COVERAGE [unresolved; full_pipeline]: The frozen catalogue and one-row probes establish selected local table identities/fields/readability only; they do not establish the full source populations, required date history, vendor vintage, or the user's entitlements. TRACE Enhanced and several author-prepared link/TAQ inputs lack an exact local candidate in the bounded lookups. A FISD issue probe timed out without establishing absence or a license condition.
- I_IBES_VINTAGE [unresolved; full_pipeline]: The supplied code uses broker and analyst identifiers across a 2000-2021 sample but records no IBES data vintage; official WRDS documentation describes identifier changes and subsequent reshuffling. Preserve the author's method and record the input vintage before comparing outputs.
- R_TRACE [undetermined]: Raw TRACE Enhanced input consumed by the supplied SAS cleaner. The cleaner distinguishes pre/post 2012-02-06 fields and uses trade, status, correction/reversal and security identifiers; the published sample window is built downstream.
- R_FISD_ISSUE [undetermined]: Mergent FISD issue table joined to TRACE in R01 for convertible/security attributes and CUSIP linkage; it is a separate jointly consumed table from FISD ratings.
- R_FISD_RATINGS [undetermined]: Mergent FISD issue ratings table separately used by the R01 bond merge.
- R_IBES_LINK [undetermined]: Author-prepared IBES-to-CRSP link CSV used by R03. The code lowercases fields, converts date columns, keeps score <= 2, and joins on PERMNO/TICKER with link-date validity.
- R_CCM_LINKTABLE [undetermined]: CRSP/Compustat link-table rows used by R03 to map GVKEY to PERMCO/PERMNO and link dates; code filters USEDFLAG=1 and LINKPRIM P/C and fills missing LINKENDDT with the run date.
- R_COMP_SECURITY [undetermined]: Compustat security header table used by R03 as an IBTIC ticker fallback for GVKEYs not linked through the primary mapping.
- R_IBES_DETAIL [undetermined]: IBES unadjusted EPS detail forecasts used by R03 to form quarterly analyst consensus and SUE3; code selects FPI 6/7, chooses the latest estimate per ticker/fiscal-period/broker/analyst, and accepts forecasts up to 90 days before report date.
- R_IBES_ACTUAL [undetermined]: IBES unadjusted quarterly actual EPS table separately consumed by R03 and joined to estimates by TICKER and fiscal-period end.
- R_CRSP_DSI [undetermined]: CRSP daily index trading-date calendar used by R03 to map IBES dates to the closest preceding CRSP trading date within five calendar days.
- R_CRSP_DSF [undetermined]: CRSP daily stock table consumed by R03 for CFACSHR share adjustment factors on mapped announcement/report dates.
- R_COMP_FUNDQ [undetermined]: Compustat quarterly fundamentals used by R03 to compute SUE1/SUE2 and market capitalization. The supplied code filters CONSOL=C, POPSRC=D, INDFMT=INDL, DATAFMT=STD and uses cshoq*prccq as mcap.
- R_BOND_LINK [undetermined]: Author-prepared TRACE/FISD-to-CRSP bond link file read by R04 and R04a. The local WRDSAPPS.BONDCRSP_LINK table has the expected CUSIP/PERMNO and trace/CRSP validity-date field family as a potentially compatible route, subject to row-level/key and period compatibility.
- R_CCM_LNKHIST [undetermined]: CRSP CCM link history used by the pooled and size event-time merges and the TAQ event construction; kept distinct from the R03 CCMXPF_LINKTABLE.
- R_TAQ_IID [undetermined]: Author-prepared intraday TAQ RDS input read by R05, which constructs +/-30 NYSE business-day earnings event windows. This is the supplied workflow's direct TAQ-stage input; the package contains no such RDS, and no separate raw TAQ rebuild is imposed as an additional conjunctive requirement.
- R_TAQMCLINK [undetermined]: Author-prepared TAQ-to-CRSP link SAS file separately read by R05. No local candidate was found in the selected TAQ alias lookup.
- SW_SAS [unverified]: The supplied machine instructions document SAS 9.4 TS1M8, while the pre-existing environment startup probe reports initialization failure at TKELS. This agent did not launch SAS or run SAS startup/version/PROC commands; the probe is not evidence of a missing data license.
- SW_R_PACKAGES [unverified]: Static library/namespace references include DescTools, RColorBrewer, RPostgres, bizdays, broom, data.table, fixest, ggplot2, ggthemes, haven, lfe, lmtest, lubridate, magrittr, scales, tidyverse, timeDate, xtable, and zoo. Package versions/installation were not queried and no packages were installed.
- SW_RPOSTGRES [unverified]: The code uses RPostgres-backed database access; required secure local connection settings, network path, account entitlements, and runtime connectivity were not tested or inferred.

## Review notes

- The target is the actual supplied SAS-to-R sequence: manual TRACE input and SAS cleaner, manual CSV-to-RDS handoff, R01-R05 construction including the pooled and size branches, R06 matched-pair stage, then tables and figures. No earlier SAS-to-Stata architecture was imposed.
- The 13 frozen dependency IDs are all reviewed. D0001 and D0002 are generated R04 outputs; D0003 and D0004 are actual external/manual inputs; D0005-D0009 and D0011-D0013 are supplied source stages; D0010 is the incorrect master include path. Additional DB tables and author-prepared links found by static code review are separate requirements.
- Source-defined period/construction: the SAS cleaner has a pre/post 2012-02-06 TRACE structure and cleans cancellation/correction/reversal records. R03 selects earnings dates 2000-01-01 through 2021-08-01, uses quarterly estimates within 90 days of reported actuals, chooses the earlier of Compustat RDQ and IBES report dates, maps dates to the preceding CRSP trading date within five calendar days, forms SUE expectations from the same fiscal quarter one year earlier, then adds firm leads/lags after its sample-date filter. The pooled R04 branch retains announcements after 2002-06-30 with +/-30 NYSE business-day event time; R04a is the size variant and does not contain that same explicit cutoff. R05 uses +/-30 NYSE business days, and R06 matches stock/bond events by PERMNO and event date. These authored boundaries remain unchanged.
- One-row resource probes establish selected table identity, requested field readability, and bounded structural metadata only. Their coverage_verified flag is false. The FISD issue-table probe timed out at its fixed 15-second cap; this is not evidence of missing data, a missing license, or unavailable coverage.
- The local packaged earnings_otc_markets_ids.csv is only a CUSIP identifier list, not an analysis panel or a substitute for the generated RDS inputs. This release supports one full_pipeline scope and no analysis_only scope.
- Current WRDS static product documentation describes product pages and selected public coverage/identifier issues; it does not establish this user's entitlements or the vintage of the author's source data. The datasheet's historical access statements and its broader nonproprietary-data wording are provenance context, not a current license determination.
- IBES/Compustat/CRSP/FISD/TRACE/TAQ products remain distinct code-used sources. Known generated RDS files remain generated, compatible author-prepared inputs can satisfy the same requirement, and no byte identity, full-row cleaning, or additional raw-data rebuild was imposed.
- All work was static. No author SAS/R script, language parser, model/statistical routine, data payload, API, or endpoint was run or queried. No credentials, connection values, or access tokens were included in this draft.
