# Patch proposal: jar-bdb7785fea16

Show me the money! Dividend policy in countries with weak institutions

DOI: 10.1111/1475-679X.12363

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow

Entry points: `1_EK_Data_Assembly.sas`, `2_EK_Add_Variables.sas`, `3_EK_SOA_Datasets.sas`, `4_EK_Main_Tables.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 2/12363 - Show-me-the-money-Dividend-policy-in-countries-with-weak-institutions/ek-datasheet-code-and-identifiers.zip",
      "sha256": "8d20e4bb1ec75941fcfde043b084572d16685a2d55b16230f32ff7421c9bcacc"
    },
    {
      "path": "JAR-Volume 59/Issue 2/12363 - Show-me-the-money-Dividend-policy-in-countries-with-weak-institutions/ek-online-appendix.pdf",
      "sha256": "f034471fb7225d8dc9d2a2ea09d15fd3573e4f404773874e0c03348f7bd7e3ed"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "b414082ab842a26c3f4096fad0b77b19bf3c844ad8dee8c235bd76639f0ecc1b"
}
```

## Proposed actions

### ACT_FACTSET: Use the author-documented WRDS FactSet V3 route for the annual USC/INT fundamentals, monthly USC/INT prices, and named security/entity/exchange reference tables. Keep FSYM_ID and native field names intact.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_FACTSET_FUND, REQ_FACTSET_PRICE, REQ_FACTSET_MAP
Evidence: SRC_FACTSET_SOURCE, SRC_FACTSET_READS, SRC_FACTSET_PRICE_READS, SRC_FACTSET_MAP_READS, SRC_NO_PROPRIETARY

Preparation / proposed procedure:

1. Stage the exact V3 annual, monthly-price, and reference products under consistent SAS librefs; preserve the USC/INT distinction and native FSYM_ID.
2. Confirm the staged V3 products meet the required native fields, periods, and identifier contract; document any scientifically material version differences without requiring byte-identical 2018 downloads.
3. Do not substitute Compustat or another identifier system for FactSet FSYM_ID.

Validation to perform later:

- Inspect native columns against each requirement’s expected_fields.
- Record firm/date coverage and the history available before and after the authored sample; resolve remaining upper/lower date requirements with the authors.

### ACT_COUNTRY: Obtain compatible author-shaped country inputs and verify each alias/schema separately. The official WGI/GDP pages are candidate sources, but fields, country/year coverage, and derived columns remain unverified.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_FUND_CURRENCY, REQ_SOA_CURRENCY, REQ_ISO_CROSSWALK, REQ_WGI_RAW, REQ_WGI_ATIF, REQ_WGI3, REQ_GDP
Evidence: SRC_FUND_CURRENCY, SRC_SOA_CURRENCY, SRC_ISO_MAP, SRC_PROC_ISO, SRC_WGI_SOURCE, SRC_WGI_RAW, SRC_WGI_ATIF, SRC_WGI3, SRC_GDP_SOURCE, SRC_GDP_READS, PUB_WGI_2026, PUB_GDP_2026

Preparation / proposed procedure:

1. Obtain the exact currency tables with DATE and date_num forms, ISO2/ISO3 crosswalk, author-shaped WGI aliases, and GDP country-year table.
2. For WGI, verify field names, country/year coverage, definitions, and the transformation to the supplied aliases. The datasheet’s May 2018 download date is context; exact-byte vintage identity is not established as a requirement.
3. For GDP, confirm currency basis and the author construction of L0/L1/L2 growth and per-capita fields before shaping the public indicator into the code’s expected columns.
4. Confirm which SAS librefs (rawdata, proc, INST, proc_int) point to each version.

Validation to perform later:

- Verify all expected country, currency, date, and governance columns.
- Check that country/year keys uniquely match the FactSet panel and that required lead/lag rows exist.

### ACT_CRSP: Validate the already readable local CRSP candidates against full link/date and stocknames coverage.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_CRSP_LINK, REQ_CRSP_STOCKNAMES
Evidence: CATALOG_CRSP, PROBE_CRSP_LINK, PROBE_CRSP_STOCKNAMES, SRC_CRSP_LINK, SRC_CRSP_STOCKNAMES

Preparation / proposed procedure:

1. Retain the local catalog-listed CRSP route.
2. After authorized input preparation, verify valid GVKEY link intervals and the CUSIP/share-code/name-date fields used for cross-listing flags.
3. The existing one-row probes establish only readability and columns, not population or history.

Validation to perform later:

- Check date bounds, row population, nonmissing identifiers across required periods, and link validity rules before downstream joins.

### ACT_IBES: Acquire the matching US and international I/B/E/S summary, actual EPS, and price-history products described in the supplied programs.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_IBES_SUMMARY, REQ_IBES_ACTUAL, REQ_IBES_PRICE
Evidence: SRC_IBES_SUM, SRC_IBES_ACTUAL, SRC_IBES_PRICE, SRC_NO_PROPRIETARY

Preparation / proposed procedure:

1. Obtain all six named I/B/E/S tables at a compatible vintage.
2. Preserve ticker, period-end, statistic date, currency, firm flag, actual value, and price fields used in joins.
3. Confirm the annual forecast and price history match every sample fiscal year and report date.

Validation to perform later:

- Check expected native columns and merge-key types.
- Confirm annual periods, prior-month price coverage, and duplicates/order needed by the supplied sorts.

### ACT_SDC: Acquire the authors’ SDC Platinum cleaned IPO/SEO inputs or a confirmed compatible export.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_SDC_IPO, REQ_SDC_SEO
Evidence: SRC_SDC_SOURCE, SRC_SDC_IPO, SRC_SDC_SEO, SRC_NO_PROPRIETARY

Preparation / proposed procedure:

1. Use the documented Refinitiv SDC Global New Issues source and retain both IPO and SEO products.
2. Preserve CUSIP, deal/date, security code, IPO flag, share/proceeds, and issue-price fields; document scientifically material differences from the author-described March 2020 extract without making exact-vintage identity or author approval a prerequisite.

Validation to perform later:

- Verify the code-used 1990-2019 event range, CUSIP format, and every expected field before matching to FactSet monthly returns.

### ACT_WORLDSCOPE: Obtain the author-shared Worldscope/Datastream annual, daily-price, and identifier-header inputs with their original partitions and fields.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_WS_INDUSTRY, REQ_WS_DAILY, REQ_WS_HEADER
Evidence: SRC_WS_SOURCE, SRC_WS_ANNUAL, SRC_WS_DAILY, SRC_WS_HEADER

Preparation / proposed procedure:

1. Request or stage the five annual Worldscope partitions for 1980-2015 and all 25 daily price partitions for 1990-2014.
2. Obtain the header_cw crosswalk containing the SEDOL/ISIN and DSCD keys used by the supplied join code.
3. Do not infer that file 2 creates the raw annual partitions; it consumes them.

Validation to perform later:

- Verify all requested partitions exist and contain the expected native columns.
- Check daily price history includes prior observations needed for lagged price and market value and that the header mapping matches FactSet identifiers.

### ACT_MSCI: Obtain the author-collected Datastream MSCI crosswalk and daily return panel used for earnings-announcement abnormal returns.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_MSCI_CROSSWALK, REQ_MSCI_RETURNS
Evidence: SRC_WS_SOURCE, SRC_MSCI_MAP, SRC_MSCI_RETURNS

Preparation / proposed procedure:

1. Preserve the ISO3-to-MSCI region map and daily MSCI regional/ACWI returns.
2. Confirm the reshaped table uses the exact region/date/return keys consumed by the code and includes five daily observations on each side of each event.

Validation to perform later:

- Check region coverage, date ordering, return units, and event-window lead/lag availability.

### ACT_AUTHOR_TABLES: Obtain the exact author-prepared inputs or their producer sections and data dictionaries; do not independently reconstruct these tables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_DAILY_EVENT_RET, REQ_FIRM_IDS, REQ_HOLDINGS, REQ_FULL_SOA, REQ_COUNTRY_CHAR, REQ_CONT_DB
Evidence: SRC_DAILY_EVENT_RET, SRC_FIRM_IDS, SRC_HOLDINGS, SRC_FULL_SOA_READ, SRC_FILE3_SCRIPT4, SRC_COUNTRY_CHARACTERISTICS, SRC_CONTDB_SOURCE, SRC_CONTDB_READ

Preparation / proposed procedure:

1. Request the intended source/table and field dictionary for daily_ret, firm_ids, holdings_firms, div.script_4, country_characteristics, and cont_DB.
2. For firm_ids, provide the persistent FSYM_ID/CUSIP/ISIN/SEDOL mapping; the supplied WORK firm_ids does not establish that contract.
3. For script_4, confirm the full-window SOA/log_ratio producer and the intended estimation period.
4. For holdings and policy tables, provide keys, variable definitions, sample coverage, and the exact author-prepared files.

Validation to perform later:

- Match every table’s native fields and keys to its consuming join.
- Document coverage and any required lead/lag history before running dependent code.

### ACT_PIPELINE_ORDER: Stage the independently produced FactSet base map before file 1, then preserve the unresolved later script_6/script_7 handoffs.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: ISS_PIPELINE_ORDER
Evidence: SRC_CYCLE, SRC_FACTSET_MAP_PRODUCER, SRC_RETURN_FUNDA_PRODUCER, SRC_RETURN_FUNDA_CONSUMER, SRC_FILE3_MAP_INPUT, SRC_FILE3_ZK_INPUTS, SRC_SOAPRE_CONSUMER, SRC_SCRIPT7_SELFREAD, SRC_SCRIPT6_ORDER, SRC_SCRIPT6_PRODUCER

Preparation / proposed procedure:

1. In a future driver, run file 2 industry construction (lines 22-229), then its independent FactSet map construction (lines 240-242 and 253-381), leaving the sample-only div.dataset attachment at lines 244-248 until file 1 has produced that dataset.
2. After the base div.fsym_map exists and all required inputs/hand-offs are available, run file 1; then persist WORK.return_funda for file 2 and resume the sample-map and remaining file 2 stages.
3. Run file 3 and Stata after their producer paths are aligned. Keep the script_7 self-read and script_6-before-producer ordering unresolved until their actual intended input/order is established.

Validation to perform later:

- Review the staged driver to ensure each table is produced before its first consumer and all paths/columns match.

### ACT_PATH_EDITS: Persist the supplied file 1 and file 3 WORK outputs at the exact library aliases consumed downstream, and correct the file 1 WORK/rawdata mismatch.

Scopes: full_pipeline. Type: source_edit. Certainty: conditional.
Addresses: ISS_PATH_HANDOFFS
Evidence: SRC_RETURN_FUNDA_PRODUCER, SRC_RETURN_FUNDA_CONSUMER, SRC_RETURN_FUNDA15_PRODUCER, SRC_RETURN_FUNDA15_CONSUMER, SRC_SOAPRE_PRODUCER, SRC_SOAPRE_CONSUMER, SRC_FILE3_MAP_INPUT, SRC_FILE3_ZK_INPUTS, SRC_FILE3_INDUSTRY_INPUT

**Proposed edit:** `1_EK_Data_Assembly.sas:392–393`
Source SHA-256: `2d4441e89ac5ffa09705b5efb9189d9c1edd1001e717ea916c24d66fc97c0de1`

File 2 consumes div.return_funda, while file 1 creates only WORK.return_funda.

Current text:
```
order by a.FSYM_ID, a.FF_FYR;
quit;
```

Proposed replacement:
```
order by a.FSYM_ID, a.FF_FYR;
quit;
data div.return_funda; set return_funda; run;
```

**Proposed edit:** `1_EK_Data_Assembly.sas:949–949`
Source SHA-256: `2d4441e89ac5ffa09705b5efb9189d9c1edd1001e717ea916c24d66fc97c0de1`

File 1 created return_funda15 in WORK at lines 586-590; the rawdata libref has no supplied producer for this name.

Current text:
```
data return_funda15a; set rawdata.return_funda15;
```

Proposed replacement:
```
data return_funda15a; set return_funda15;
```

**Proposed edit:** `3_EK_SOA_Datasets.sas:1162–1164`
Source SHA-256: `bb3c0442a58b672359e8f3d5b618bd6be760401edd12ec292a77f6a0ec49db71`

File 1 consumes persistent div.soapre; file 3 currently leaves its SOA estimate only in WORK.

Current text:
```
proc sort data = SOApre;
by _EDF_;
quit;
```

Proposed replacement:
```
proc sort data = SOApre;
by _EDF_;
quit;
data div.soapre; set SOApre; run;
```

Preparation / proposed procedure:

1. Apply these proposal edits only in a working copy after the stage order and librefs are confirmed.
2. The file 2 versus file 3 proc_int/rawdata/div output aliases still require a consistent copy or library mapping; do not assume matching basenames establish the path.

Validation to perform later:

- Review all producing and consuming paths together and confirm the expected fields for each handoff before any future run.

### ACT_MISSING_PRODUCERS: Obtain the missing producer or schema for the unresolved file-level handoffs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_MISSING_HANDOFFS
Evidence: SRC_FIRM_IDS, SRC_FULL_SOA_READ, SRC_FILE3_SCRIPT4, SRC_SCRIPT7_SELFREAD, SRC_SCRIPT6_ORDER, SRC_SCRIPT6_PRODUCER

Preparation / proposed procedure:

1. Ask whether div.firm_ids and div.script_4 are intended supplied author tables or omitted outputs.
2. For script_4, confirm a producer with FSYM_ID, SOA, and log_ratio; the supplied file 3 aggregate script_4 is not that schema.
3. Clarify whether script_7’s self-read is an intended earlier input and how script_6 is available before its later creation.

Validation to perform later:

- Match confirmed producer keys, columns, and order to each consumer without dropping stages or substituting data.

### ACT_WINSOR_SETUP: Load the supplied %winsor macro before any file 1, 2, or 3 call.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: ISS_MACROS
Evidence: SRC_WINSOR_CALLS, SRC_WINSOR_DEF

Preparation / proposed procedure:

1. Place the exact supplied macro body from file 3 lines 1176-1245 in a shared SAS initialization include.
2. Configure the staged driver to compile that include before the first %winsor call in file 3 at line 418 and before calls in files 1 and 2.
3. Keep it in the same SAS session or explicitly compile it for each separate session.

Validation to perform later:

- Confirm %winsor is defined at every first call and that the provided body retains its input/output semantics.

### ACT_MACROS: Obtain only the missing custom macro definitions or include paths.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_MACROS
Evidence: SRC_MACROS_UNDEFINED, SRC_ADD_STRING_UNDEFINED

Preparation / proposed procedure:

1. Request the definitions or include paths for %ffi17, %ffi48, and %add_string; their outputs affect the industry and analyst-variable construction.
2. Keep these separate from the supplied %winsor body, which can be loaded as a routine preparation step.

Validation to perform later:

- After obtaining the sources, verify their macro names and expected input/output variables before any future author-code execution.

### ACT_LIBRARY_SETUP: Set one local project root and explicit SAS/Stata paths and librefs for this Windows-authored workflow.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: ISS_LIBRARY_SETUP
Evidence: SRC_SAS_PATHS, SRC_SAS_LIBRARIES, SRC_STATA_ENTRY, SRC_STATA_PATHS

Preparation / proposed procedure:

1. Map the [redacted-path-89dc9a534c97] project roots and the [redacted-path-9871aafeee05] and [redacted-path-de31ba925afa] analysis paths to the staged workspace.
2. Define or confirm proc, INST, and proc_int librefs and map each one to the corresponding compatible data location.
3. Keep the two Stata input outputs (FIRM_0115.dta and dataset_w.dta) aligned with their respective producer paths.

Validation to perform later:

- Before any future run, resolve every SAS libname and Stata use/cd path against the staged inputs and outputs.

### ACT_SAS_RUNTIME: Resolve the observed SAS TKELS startup failure through the environment owner and verify the required 9.4 runtime/export capability.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: SW_SAS, SW_SAS_EXPORT
Evidence: PROBE_ENV, SRC_MAIN_OUTPUTS

Preparation / proposed procedure:

1. Use the documented SAS 9.4 TS1M8 installation and resolve its TKELS launch-service initialization issue.
2. After SAS starts successfully, verify PROC EXPORT DBMS=STATA support and all SAS procedures used by the supplied workflow.
3. No entitlement or license absence is inferred from the failed startup probe.

Validation to perform later:

- Capture successful version/procedure checks with a bounded software-only probe before any later authorized author-code run.

### ACT_STATA_ADDONS: Make the two missing Stata community commands available on the active adopath.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_OUTREG2, SW_WINSOR2
Evidence: PROBE_ENV, SRC_STATA_ANALYSIS, SRC_PACKAGE_STATA_EXTRA

Preparation / proposed procedure:

1. Install or configure outreg2 and winsor2 from an approved local/community package source in a later setup step.
2. Keep the installed package versions and adopath in the reproduction record.

Validation to perform later:

- Run which/version checks for outreg2 and winsor2 after setup.

### ACT_CLOSURE: Reconcile the full frozen dependency checklist against the supplied sources and stage all required compatible inputs before attempting the complete workflow.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: ISS_EXTERNAL_INPUTS
Evidence: INS_PACKAGE_INVENTORY, PROBE_IDS, SRC_DOC_PROGRAMS, SRC_MAIN_OUTPUTS

Preparation / proposed procedure:

1. Use the dependency review to obtain or generate every mandatory input, resolve the path, macro, and ordering issues, and confirm the generated dataset handoffs.
2. The supplied EK_Identifiers.csv is only a final-sample FSYM_ID list and does not supply the analysis panels.
3. Keep full_pipeline as the only scope until a compatible author-prepared analysis dataset and supported code route are documented.

Validation to perform later:

- Check every frozen dependency ID and every mandatory requirement against its producer, route, and evidence; record remaining unknowns without declaring completion.


## Remaining issues and prerequisites

- ISS_PIPELINE_ORDER [unresolved; full_pipeline]: No complete stage driver is supplied. File 2 reads div.dataset before creating div.fsym_map; file 1 consumes the map, later file 2 reads div.return_funda, and file 3 consumes file 2 outputs while also supplying SOA inputs used by file 1. File 3 additionally reads script_7 before a supplied producer and reads script_6 before its later creation. The valid segmentation/order is unresolved.
- ISS_MISSING_HANDOFFS [unresolved; full_pipeline]: No compatible producer/schema is supplied for div.firm_ids and full-window div.script_4. The only supplied file 3 script_4 is an aggregated summary without the SOA/log_ratio contract. File 3 script_7 self-reads before a producer; script_6 is consumed before its later country-section creation.
- ISS_PATH_HANDOFFS [unresolved; full_pipeline]: Several exact paths do not match supplied producers: file 1 makes WORK.return_funda and WORK.return_funda15 but later consumers name div.return_funda and rawdata.return_funda15; file 3 writes WORK.SOAPre while file 1 reads div.soapre. File 2 writes file 3 inputs under rawdata/div while file 3 reads them under proc_int. File 3 uses proc and INST aliases without defining them.
- ISS_LIBRARY_SETUP [preparation; full_pipeline]: The SAS and Stata programs hard-code Windows D:, E:, and G: roots, and file 3 has undeclared proc/INST librefs. A consistent local root/library mapping is needed before use.
- ISS_MACROS [unresolved; full_pipeline]: The SAS programs call %ffi17, %ffi48, and %add_string without supplied definitions or include paths. %winsor is supplied only at the end of file 3, after earlier calls in file 3 and calls from files 1 and 2.
- ISS_EXTERNAL_INPUTS [unresolved; full_pipeline]: The package contains source code and a final-sample FSYM_ID list, not the firm-year analysis data or the vendor/author-prepared tables required by the complete workflow. Multiple inputs and histories remain unverified, so the full pipeline closure is incomplete.
- REQ_FACTSET_FUND [undetermined]: FactSet Fundamentals V3 US/Canadian and international annual firm records keyed by native FSYM_ID. Both universes feed assembly and SOA; the complete history required for lags, leads, and rolling construction is not specified.
- REQ_FACTSET_PRICE [undetermined]: FactSet monthly US/Canadian and international price and return records used for monthly returns and IPO/SEO event windows.
- REQ_FACTSET_MAP [undetermined]: FactSet security coverage/entity/exchange reference tables required to build the FSYM_ID-to-entity, country, listing, and identifier map.
- REQ_FUND_CURRENCY [undetermined]: The currency-rate table joined to FactSet fundamentals by CURRENCY and exact DATE in file 1.
- REQ_SOA_CURRENCY [undetermined]: The distinct currency table used in file 3, whose date_num join is within three days of DATE.
- REQ_ISO_CROSSWALK [undetermined]: Country code crosswalk(s) used by the assembly and SOA programs to map ISO2, ISO3, and country identifiers.
- REQ_WGI_RAW [undetermined]: World Bank governance indicators joined to the FactSet panel by ISO3 and calendar year.
- REQ_WGI_ATIF [undetermined]: The author-prepared WGI table consumed by file 3 under proc.wbgi_atif.
- REQ_WGI3 [undetermined]: The separate two-character-country WGI table consumed by file 3 as proc_int.wbgi_3.
- REQ_GDP [undetermined]: Country-year GDP-per-capita and growth lead/lag columns consumed by assembly.
- REQ_CRSP_LINK [undetermined]: CRSP CCM link-history records used to map FactSet GVKEY values to CRSP identifiers on valid dates.
- REQ_CRSP_STOCKNAMES [undetermined]: CRSP stocknames used to identify US cross-listed securities and their first CRSP price date.
- REQ_IBES_SUMMARY [undetermined]: Annual US and international I/B/E/S summary-statistics forecasts used to form first/last forecasts and dispersion.
- REQ_IBES_ACTUAL [undetermined]: Annual US and international I/B/E/S actual EPS announcements joined to summary forecasts.
- REQ_IBES_PRICE [undetermined]: I/B/E/S EPS price history used to scale forecast errors and dispersion.
- REQ_SDC_IPO [undetermined]: Refinitiv SDC Platinum IPO records used to connect offer dates and offer outcomes to FactSet returns.
- REQ_SDC_SEO [undetermined]: Refinitiv SDC Platinum SEO records used to connect secondary equity-offering dates and outcomes to FactSet returns.
- REQ_WS_INDUSTRY [undetermined]: Worldscope annual company data used to map FactSet FSYM_IDs to Fama-French industry classifications.
- REQ_WS_DAILY [undetermined]: Worldscope daily price/market-value records used to calculate annual return volatility.
- REQ_WS_HEADER [undetermined]: Worldscope/Datastream identifier header table used to link FactSet identifiers to DSCD and country.
- REQ_MSCI_CROSSWALK [undetermined]: ISO3-to-MSCI-region mapping used to attach regional and ACWI returns to FactSet earnings dates.
- REQ_MSCI_RETURNS [undetermined]: Datastream daily returns for MSCI regional indexes and the ACWI series, with event-date leads/lags.
- REQ_DAILY_EVENT_RET [undetermined]: Precomputed daily earnings-announcement return records consumed by file 1.
- REQ_FIRM_IDS [undetermined]: Persistent firm identifier table joined by FSYM_ID in file 1.
- REQ_HOLDINGS [undetermined]: Institutional holdings table joined to the assembly panel by FSYM_ID and year.
- REQ_FULL_SOA [undetermined]: Full-window firm SOA records joined from div.script_4 by FSYM_ID.
- REQ_COUNTRY_CHAR [undetermined]: Author-prepared country-characteristics table joined to the file 3 firm-level panel.
- REQ_CONT_DB [undetermined]: Hand-collected stated dividend-policy data, including recent IPO-prospectus disclosures, merged by FSYM_ID.
- SW_SAS [unverified]: The machine lists SAS 9.4 TS1M8, but the bounded launch probe failed during TKELS initialization. This does not establish missing installation or entitlement.
- SW_SAS_EXPORT [unverified]: The programs use PROC EXPORT DBMS=STATA; runtime capability could not be checked because SAS did not initialize.
- SW_OUTREG2 [preparation_required]: outreg2 was not found on the checked default or shared adopaths. This is a free-package setup task, not an access barrier.
- SW_WINSOR2 [preparation_required]: winsor2 was not found on the checked default or shared adopaths. This is a free-package setup task, not an access barrier.

## Review notes

- Complete source review and a section-level ordered workflow trace are saved in probes/workflow_trace.json.
- All 109 frozen dependency IDs are covered exactly once. The review separates mandatory vendor/author-prepared inputs, generated intermediates, and unresolved path/producer issues.
- No analysis_only route is supported: the supplied CSV contains FSYM_ID identifiers only, not analysis variables or firm-year observations.
- Local CRSP probes are bounded one-row checks; they establish readability/fields only, not historical or population coverage.
- The SAS environment startup failed at TKELS and remains unverified; the failure is not evidence of absent entitlement.
