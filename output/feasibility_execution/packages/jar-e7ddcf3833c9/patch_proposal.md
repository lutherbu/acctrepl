# Patch proposal: jar-e7ddcf3833c9

The Capital Market Effects of Centralizing Regulated Financial Information

DOI: 10.1111/1475-679X.12544

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The complete documented seven-stage workflow: initial and later sections of the supplied SAS program, Stata stages 2 and 4–7, and the called 7_syncher helper. There is no supported analysis-only route because the package contains no prepared analysis panel.

Entry points: `1_3_capital market data.sas`, `2_Compile_1.do`, `4_Coverage.do`, `5_Ownership.do`, `6_Synchronicity.do`, `7_Compile_2.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 4/12544 - The-Capital-Market-Effects-of-Centralizing-Regulated-Financial-Information/stv-datasheet-code-and-identifer-files.zip",
      "sha256": "37d720f3f1ade5c958571dc1481a9bd8843fd7368e9aab342f337855c851225c"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "75e3a474348926ac0ba9704919f5d75f3548f8729f09bf2747eec3fdcea55611"
}
```

## Proposed actions

### A001: Obtain or identify each separate QA Direct Datastream input named in the SAS source: FX rates and codes, primary return index, primary prices, shares, exchange, exchange-quote metadata, country-quote mappings, and adjustment history. Keep the two readable local quote candidates and the shares-table candidate distinct until their QA mappings and coverage are confirmed.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R001, R002, R003, R004, R005, R006, R007, R008, R009, I001
Evidence: E007, E026, E028, E055, E059, E060, E061

Preparation / proposed procedure:

1. For each required table, record the exact licensed product/table, source columns, join keys, units, currency mapping, effective dates, and required historical window.
2. Map the local TR_DS candidates to the author's QA table names only after their source definitions and keys are confirmed.
3. Retain each table as an independent required input; do not use the readable one-row sample to claim full history or population coverage.

Validation to perform later:

- Before any separately authorized execution, run bounded field/readability checks for the exact mapped inputs and verify keys, units, date coverage, and handoff columns.

### A002: Resolve the separately required Worldscope data indexes, item lookup, and dynamically selected item-value tables. A local wide fundamentals table is readable, but the author code expects its item lookup and long-form `value_` joins; no equivalence is established.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R010, R011, R012, R013, I001
Evidence: E007, E029, E030, E056, E062, E063

Preparation / proposed procedure:

1. Provide or identify the exact QA `wsndata`, `wsidata`, and `wsitem` tables, including table-name/frequency mappings for the ten item numbers in the source.
2. For each selected value table, confirm `item`, `value_`, code, year, frequency, and sequence key behavior and the table's historical coverage.
3. If using the local WRDS candidate, establish the required wide-to-long field and key mapping before treating it as a route.

Validation to perform later:

- Use the frozen one-row reader on each exact mapped table and requested source fields; separately verify the item mappings and date history before any authorized run.

### A003: Identify and make available the four independent QA Direct security-master and security-map tables required to connect Datastream and Worldscope identifiers.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R014, R015, R016, R017, I001
Evidence: E007, E033, E055

Preparation / proposed procedure:

1. Obtain exact `secmstrx`, `gsecmstrx`, `secmapx`, and `gsecmapx` table definitions and data routes.
2. Preserve the source's type and vendor-type conditions, keys, effective dates, and required code history when documenting compatibility.

Validation to perform later:

- Before a separately authorized run, confirm the exact key, identifier fields, and effective-date history for each table.

### A004: Resolve the regulated-firm quarterly panel and GDP input separately. The code names both files; only the GDP datasheet provenance points to the World Bank, and the exact `gdpc` series and transformation are not identified.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R018, R019, I001
Evidence: E002, E007, E008, E009, E064, E073

Preparation / proposed procedure:

1. Identify the exact regulated-firm file and confirm its `dscd`, year, and quarter key contract and required panel history.
2. Identify the World Bank indicator code, units, country identifiers, and annual-to-quarterly handling behind `GDP_Data.gdpc`.
3. Keep the official Indicators API as an unverified public route until its exact series is matched to the author's field and history.

Validation to perform later:

- Use bounded metadata/readability checks on both exact input files; verify required keys and the GDP source definition before declaring either route compatible.

### A005: Obtain the FactSet historical security/ISIN crosswalk and fund-level ownership detail as two distinct inputs, then verify their shared keys and time coverage.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R020, R021, I001
Evidence: E004, E007, E010, E011, E041, E042, E043

Preparation / proposed procedure:

1. Identify the authorized export for `sym_v1.sym_isin_hist.csv.dta` and preserve its historical ISIN relationship and key definitions.
2. Identify the authorized export for `own_fund_detail.csv.dta` and document holdings, market-value, report-date, and fund-security fields separately.
3. Confirm the crosswalk and holdings coverage overlap without treating one file as a substitute for the other.

Validation to perform later:

- Before a separately authorized run, inspect each file independently for readability, required fields, keys, date coverage, and compatible identifier mappings.

### A006: Make the author-required RavenPack-Dow Jones Equities annual ZIP inputs for 2001–2015 available as one product's year partitions and verify the CSV fields expected by stage 4.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R022, I001
Evidence: E004, E007, E012, E013, E047, E058

Preparation / proposed procedure:

1. Identify or obtain the 2001 through 2015 `RPNA_DJEdition_{year}_4.0-Equities.zip` archives through an authorized route.
2. For each archive's CSV headers, confirm timestamp, relevance, topic, group, aev, isin, nip, and news_type fields before combining the annual partitions.
3. Keep the imported history and licensing/access method documented; no archive payload was requested or downloaded in this assessment.

Validation to perform later:

- Use bounded archive/header checks in a separately authorized preparation step and confirm all annual partitions and required fields are present.

### A007: Supply the exact two SAS include files named in the source and confirm their path under the configured SAS root, including the `array` and `do_over` macro definitions called later in stage 1.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I002
Evidence: E024, E025, E072

Preparation / proposed procedure:

1. Provide `Do_over.sas` and `array.sas` from the author workflow or identify the exact existing sources and versions.
2. Confirm whether either include defines additional required macro variables or source-table paths used by both SAS sections.

Validation to perform later:

- Before a separately authorized run, verify the include files resolve at the configured roots and that each invoked macro definition is present.

### A008: Resolve the exact `wsitem` table-name/frequency mapping for all ten item numbers and the intended `qa.ws&dataset.data` source tables, including the underlying `value_` and code/year/frequency/sequence keys.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I003, R013
Evidence: E029, E030, E056, E062

Preparation / proposed procedure:

1. Provide the resolved Worldscope source table and field mapping for each listed item number.
2. Confirm whether the local wide `WRDS_WS_FUNDA` candidate is a documented equivalent after a specified transformation; if not, identify the required long-form tables.

Validation to perform later:

- Compare exact source fields and join keys against lines 140–168 in the screened SAS source before marking the route verified.

### A009: Confirm shared root values for SAS `&path` and Stata `$MAIN`, `$DATA`, `$WORK`, `$OUTPUT`, and `$MAINDO` so each listed file and generated handoff resolves consistently.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I004
Evidence: E024, E034, E035, E036, E037, E038

Preparation / proposed procedure:

1. Specify the intended code, raw-data, prepared-data, work, output, and helper-program roots for this release.
2. Configure the corresponding globals in working copies while preserving the documented stage order and common handoff filenames.

Validation to perform later:

- Resolve every source and generated path against the same workspace map before any separately authorized execution.

### A010: Add `DBMS=DTA` to each of the six SAS exports that writes a `.dta` handoff, making the declared external format match its Stata consumers and SAS imports.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I005
Evidence: E016, E017, E018, E019, E065

**Proposed edit:** `1_3_capital market data.sas:269–269`
Source SHA-256: `11798d25eabf52daa886bc883d08e964b72e67dafd0e3a78c664ecaa9eb6d2c0`

Declare the Stata DTA output type explicitly so each .dta handoff uses the format consumed by the downstream Stata/SAS stages.

Current text:
```
proc export data=secmaster_q_8 replace outfile= "&path.\Data\quarterly_dataset.dta";
```

Proposed replacement:
```
proc export data=secmaster_q_8 replace outfile= "&path.\Data\quarterly_dataset.dta" dbms=dta;
```

**Proposed edit:** `1_3_capital market data.sas:273–273`
Source SHA-256: `11798d25eabf52daa886bc883d08e964b72e67dafd0e3a78c664ecaa9eb6d2c0`

Declare the Stata DTA output type explicitly so each .dta handoff uses the format consumed by the downstream Stata/SAS stages.

Current text:
```
proc export data=qa.ds2exchange outfile= "&path.\Data\exchange_ids.dta" replace; run;
```

Proposed replacement:
```
proc export data=qa.ds2exchange outfile= "&path.\Data\exchange_ids.dta" replace dbms=dta; run;
```

**Proposed edit:** `1_3_capital market data.sas:319–319`
Source SHA-256: `11798d25eabf52daa886bc883d08e964b72e67dafd0e3a78c664ecaa9eb6d2c0`

Declare the Stata DTA output type explicitly so each .dta handoff uses the format consumed by the downstream Stata/SAS stages.

Current text:
```
proc export data=ar_ret replace outfile= "&path.\Data\annual_report_all_events.dta"; run;
```

Proposed replacement:
```
proc export data=ar_ret replace outfile= "&path.\Data\annual_report_all_events.dta" dbms=dta; run;
```

**Proposed edit:** `1_3_capital market data.sas:354–354`
Source SHA-256: `11798d25eabf52daa886bc883d08e964b72e67dafd0e3a78c664ecaa9eb6d2c0`

Declare the Stata DTA output type explicitly so each .dta handoff uses the format consumed by the downstream Stata/SAS stages.

Current text:
```
proc export data=OAM3 outfile= "&path.\Data\weekly_returns_processed.dta" REPLACE; run;
```

Proposed replacement:
```
proc export data=OAM3 outfile= "&path.\Data\weekly_returns_processed.dta" REPLACE dbms=dta; run;
```

**Proposed edit:** `1_3_capital market data.sas:381–381`
Source SHA-256: `11798d25eabf52daa886bc883d08e964b72e67dafd0e3a78c664ecaa9eb6d2c0`

Declare the Stata DTA output type explicitly so each .dta handoff uses the format consumed by the downstream Stata/SAS stages.

Current text:
```
proc export data=ar_dates_long_7 replace outfile= "&path.\Data\annual_events_1.dta"; run;
```

Proposed replacement:
```
proc export data=ar_dates_long_7 replace outfile= "&path.\Data\annual_events_1.dta" dbms=dta; run;
```

**Proposed edit:** `1_3_capital market data.sas:400–400`
Source SHA-256: `11798d25eabf52daa886bc883d08e964b72e67dafd0e3a78c664ecaa9eb6d2c0`

Declare the Stata DTA output type explicitly so each .dta handoff uses the format consumed by the downstream Stata/SAS stages.

Current text:
```
proc export data=ar_dates_long replace outfile= "&path.\Data\annual_events_2.dta"; run;
```

Proposed replacement:
```
proc export data=ar_dates_long replace outfile= "&path.\Data\annual_events_2.dta" dbms=dta; run;
```

Preparation / proposed procedure:

1. Apply the six one-line proposal fragments to an authorized working copy of `1_3 capital market data.sas` after retaining the original file hash.
2. Keep all table names, data steps, observations, sample filters, and analysis logic unchanged.

Validation to perform later:

- In a separately authorized SAS environment with DTA support, verify that each named output is readable as Stata DTA and that stage 2 and stage 3 consume the same fields and keys.

### A011: Confirm a supported SAS 9.4 runtime in the intended host; the existing TKELS startup failure does not establish a missing installation or license.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S002
Evidence: E023, E024

Preparation / proposed procedure:

1. Use an administrator-provisioned SAS batch runtime and retain the author macro include files and configured working roots.
2. Do not infer component availability from the failed startup probe.

Validation to perform later:

- Perform a future read-only SAS version and required Base feature check in the intended runtime before separately authorized execution.

### A012: Make the exact `astile` and `carryforward` commands invoked by the supplied Stata stages available on the intended adopath.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S004, S005
Evidence: E050, E051, E068, E069

Preparation / proposed procedure:

1. Place compatible copies of the two ado commands in a permitted user or project adopath, or configure the intended ado path to their existing locations.
2. Do not change the author's quantile or fill operations to bypass these commands.

Validation to perform later:

- Repeat exact Stata `which` and version metadata checks for `astile` and `carryforward` in the intended runtime before separately authorized execution.

### A013: Confirm whether SAS/ACCESS Interface for PC Files is available and licensed in the intended SAS runtime for the explicit DTA export format.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S010
Evidence: E065, E066

Preparation / proposed procedure:

1. Check the target SAS installation's installed/licensed components; no absence is inferred from documentation or catalog metadata.

Validation to perform later:

- Verify DTA export support with the intended SAS/ACCESS component using a separately authorized minimal non-author-data capability check.

### A014: Proposed execution order for the supplied interleaved workflow after the actual roots, inputs, macro includes, and required software are configured.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I004
Evidence: E001, E002, E003, E004, E005, E006, E018, E019, E020, E021, E022, E075, E076

Preparation / proposed procedure:

1. Configure the shared SAS `&path` and Stata `$DATA`, `$WORK`, `$OUTPUT`, `$MAIN`, and `$MAINDO` roots, and resolve the required source inputs and macro includes.
2. Submit the existing SAS part 1 section through its initial handoff exports (source lines 1–319), leaving that same SAS session active with its existing WORK tables and macro state.
3. Run `2_Compile_1.do` in Stata to create the processed quarterly and annual-event handoffs required by the later SAS section.
4. Resume the existing SAS part 3 section (source STEP 3, lines 321–448) in the retained SAS session so it can use the part 1 WORK.DS_overview_pricing table and the Stata stage 2 files; then produce the weekly-return and annual-event handoffs.
5. Run `4_Coverage.do`, `5_Ownership.do`, `6_Synchronicity.do`, and `7_Compile_2.do` in the documented order; `7_Compile_2.do` calls `7_syncher.do` as its helper.

Validation to perform later:

- Before any separately authorized run, confirm each generated handoff and its actual next consumer while preserving the same open SAS session across the stage 2 interleave.

### A015: Change only the stage 4 `use` option from `replace` to `clear`; keep the same collapsed RavenPack input and all subsequent processing unchanged.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I006
Evidence: E013, E074, E077

**Proposed edit:** `4_Coverage.do:72–72`
Source SHA-256: `160e403d33d525ef883dcf36a8309bfbf44276998f0c8169588745267d867424`

The official use manual lists clear/nolabel loading options; the source context already loads data with clear. Preserve the same collapsed RavenPack file and downstream processing while making the loading option consistent with the documented command.

Current text:
```
use "$DATA/collapsed_ravenpack_20012015", replace
```

Proposed replacement:
```
use "$DATA/collapsed_ravenpack_20012015", clear
```

Preparation / proposed procedure:

1. Apply the one-line proposal to an authorized working copy of `4_Coverage.do` after preserving the original source hash.
2. Retain the same file path, merge keys, sample coverage, and downstream calculations.

Validation to perform later:

- In a separately authorized future execution, confirm the command loads the same collapsed RavenPack panel and the following merge uses the unchanged `isin` and `yearqtr` keys.


## Remaining issues and prerequisites

- I001 [unresolved; full_pipeline]: The package supplies code, documentation, and a firm identifier list, not a prepared analysis panel. Local one-row probes establish readable Datastream and Worldscope candidates, but exact author-table mappings and required history remain unverified; the regulated-firm, GDP, FactSet, and RavenPack inputs also lack compatible verified routes.
- I002 [unresolved; full_pipeline]: The SAS source includes two external macro files through an unresolved path macro and later calls `array` and `do_over`. The work-item inventory lists no `Do_over.sas` or `array.sas`; their definitions and paths must be supplied to close this stage.
- I003 [unresolved; full_pipeline]: The Worldscope macro obtains a table name and frequency from `wsitem`, then joins `qa.ws&dataset.data` on item and keys. The package does not identify those resolved source tables or show that a local wide `WRDS_WS_FUNDA` table reproduces the required long-form joins for all ten item numbers.
- I004 [preparation; full_pipeline]: The entry scripts retain literal `Insert file path` placeholders in their global roots. Actual shared SAS and Stata data, work, output, and helper-program paths must be configured before the author workflow can resolve its file handoffs.
- I005 [preparation; full_pipeline]: Six SAS PROC EXPORT statements write `.dta`-named handoffs without an explicit DBMS identifier, while later SAS imports specify DTA and Stata consumes the same files. SAS documentation identifies DBMS as the output-type selector and lists DTA for Stata `.dta` files; making that format explicit is a supported interoperability preparation.
- I006 [preparation; full_pipeline]: Stage 4 line 72 specifies `replace` on a Stata `use` command, while the official current use manual lists `clear` and `nolabel`; nearby source context uses `clear` when loading the same intermediate. Propose replacing only this option, preserving the file and all downstream data and sample definitions. This is a documentation-supported preparation correction, not a claim based on a runtime failure or a Stata 18 syntax trial.
- R001 [undetermined]: QA Direct Datastream FX-rate table `ds2fxrate`, used with FX-code keys to build currency conversion rates.
- R002 [undetermined]: QA Direct Datastream FX-code lookup table `ds2fxcode`, joined to the rate table for source/destination currencies and rate type.
- R003 [undetermined]: QA Direct Datastream primary return-index table `ds2primqtri`, merged by instrument, market date, and exchange with the primary price table.
- R004 [undetermined]: QA Direct Datastream primary price/quote table `ds2primqtprc`, merged with the return-index table to create prices, bids, asks, volume, currency, and market-value inputs.
- R005 [undetermined]: QA Direct Datastream share-count table `ds2numshares`, used to attach effective-dated shares outstanding to the price panel.
- R006 [undetermined]: QA Direct Datastream exchange lookup table `ds2exchange`, used to map exchange names and country identifiers.
- R007 [undetermined]: QA Direct Datastream exchange-quote information table `ds2exchqtinfo`, used to map exchange-level codes and price units.
- R008 [undetermined]: QA Direct Datastream country-quote information table `ds2ctryqtinfo`, used to map instrument codes to country-specific Datastream codes.
- R009 [undetermined]: QA Direct Datastream adjustment table `ds2adj`, used to construct adjusted price and return series.
- R010 [undetermined]: QA Direct Worldscope non-standard data index `wsndata`, used to assemble code, year, frequency, and sequence keys.
- R011 [undetermined]: QA Direct Worldscope index `wsidata`, used alongside `wsndata` to assemble code, year, frequency, and sequence keys.
- R012 [undetermined]: QA Direct Worldscope item lookup `wsitem`, used to map each requested item number to a Worldscope data-table name and frequency.
- R013 [undetermined]: Worldscope value tables selected dynamically by `wsitem` for item numbers 5350, 5905, 6010, 6011, 7021, 7022, 6026, 6099, 2999, and 1706; the source table names, keys, item field mappings, and history remain unresolved.
- R014 [undetermined]: QA Direct Datastream security-master table `secmstrx`, used for type-1 security records and identifiers.
- R015 [undetermined]: QA Direct Datastream global security-master table `gsecmstrx`, used for type-10 security records and identifiers.
- R016 [undetermined]: QA Direct Datastream security-map table `secmapx`, used to map security identifiers to Datastream and Worldscope codes.
- R017 [undetermined]: QA Direct Datastream global security-map table `gsecmapx`, used alongside `secmapx` for global security records.
- R018 [undetermined]: Regulated-firm quarterly status panel merged by Datastream code, year, and quarter; the source file and field/history contract are not supplied in this package.
- R019 [undetermined]: Country-year GDP input merged by country and year; Stata uses `gdpc` to derive a four-quarter lag and log, while the exact World Bank series, definition, units, country keys, and history are unspecified.
- R020 [undetermined]: FactSet historical security/ISIN crosswalk `sym_v1.sym_isin_hist.csv.dta`, used to map sample identifiers to FactSet securities.
- R021 [undetermined]: FactSet fund-level ownership detail `own_fund_detail.csv.dta`, used with the independent security/ISIN crosswalk to construct the quarterly ownership panel.
- R022 [undetermined]: RavenPack-Dow Jones Equities annual ZIP archives for 2001–2015; stage 4 extracts CSVs and retains timestamp, relevance, topic, group, event, ISIN, NIP, and news-type fields.
- S002 [unverified]: A preexisting SAS 9.4 runtime startup probe returned an initialization error at TKELS; runtime availability and entitlement remain unverified.
- S004 [preparation_required]: Stages 6 and 7 invoke `astile`; the command was not found in the checked default Stata adopath.
- S005 [preparation_required]: The ownership time-series fill invokes `carryforward`; the command was not found in the checked default Stata adopath.
- S010 [unverified]: Official SAS documentation makes PC Files licensing relevant to DTA export; this component's availability in the intended runtime was not checked.

## Review notes

- Full-pipeline scope only: the README specifies seven ordered stages and a called helper; the package has substantive code but no prepared analysis panel. The supplied identifiers.txt is not treated as the full panel.
- All source quotations were generated from the hash-bound, byte-first, exclusion-aware reader views. SAS credential/auth/connection statement blocks were redacted before decoding; no candidate value was reproduced or used.
- All 52 frozen dependency IDs are covered once. Every generated classification cites direct source producer lines; unresolved includes and dynamic Worldscope tables remain linked to concrete issues and actions. No optional dependency was invented.
- The exact frozen Python SAS reader used only one-row, zero-offset, 15-second metadata/readability checks. Successful samples do not establish date or population coverage. A later Worldscope item-field request was rejected by the catalog field precheck; its artifact is retained in probes and is not used to infer missing data or fields.
- Stata checks queried only Stata version and exact command availability; no author program, model, statistic, description, or dataset value was executed. The preexisting SAS environment record is treated only as unverified metadata; SAS was not started for this assessment.
- Public verification was limited to official static World Bank and SAS documentation; no data payloads were requested and no page links were followed. Literal quotes remain below 25 words per URL.
- No author source was changed and no patch was applied. The six DTA format edits are proposal fragments only; exact current source lines and their original source hash are preserved in the action record.
- A narrow Stata loading-option correction is proposed from the official current use manual and screened source line 72. The provided sanitized descriptor records that the Stata 18 manual URL was inaccessible to the documentation tool; no retry, version-specific syntax claim, or runtime trial was made.
