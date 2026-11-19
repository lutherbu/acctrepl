# Patch proposal: jar-4c6f6d091116

Audit Implications of Non-GAAP Reporting

DOI: 10.1111/1475-679X.12433

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied Code.do data-preparation workflow through DATA/PROC DATA/FINAL.dta. It prepares a firm crosswalk, currency rates and vendor panels; merges those with the hand-collected workbook; constructs variables and applies final sample filters. No separate estimation/table-producing program is supplied, so this target does not claim to reproduce paper-wide results.

Entry points: `Code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 5/12433 - Audit-Implications-of-Non-GAAP-Reporting/hst-datasheet-code-and-identifiers.zip",
      "sha256": "b9b7285200e8ea16ec6de3197ca855dfd8a6ec5e3e55d80ac0ed2770fbc2e725"
    },
    {
      "path": "JAR-Volume 60/Issue 5/12433 - Audit-Implications-of-Non-GAAP-Reporting/hst-online-appendix.pdf",
      "sha256": "2952068edca993ffb011942cf441189c45c73531da3ea70a7bf020ff27ae900c"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "05899c03b9f0b00eb5d057e7f6c7e0f12ad003a3ba012a2f065a0e7ca7297f16"
}
```

## Proposed actions

### A_INPUTS: Obtain the missing author inputs or establish compatible same-product source mappings, then verify the actual fields, identifiers, units, periods and producer handoffs before a separately authorized run.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_HAND, R_CURRENCY, R_COMPUSTAT, R_FAME, R_IBES, R_AA, I_CLOSURE, I_FX_CONVENTION
Evidence: E_HAND, E_FX, E_FX_FILL, E_FX_COMMENT, E_IMF_DAILY, E_COMPUSTAT, E_COMPUSTAT_OUTPUT, E_FAME, E_IBES, E_AA, E_MERGE, E_VARIABLES, E_VARIABLES_OUTPUT, E_FINAL, E_DATA_PACKAGE, E_PACKAGED_IDS, E_CATALOG, E_CATALOG_SEARCH, E_COMP_G_FUNDA, E_IBES_STATSUM_EPSINT, E_AA_FEED71, E_AA_FEED70, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Request the named hand-collected workbook and its used sheets/headers; identify which workbook columns supply the non-vendor variables read by the downstream 2.2.a and FINAL stages. The packaged FIRM_IDS.csv probe shows only regno and Code.do does not read that list.
2. For currency conversion, obtain the exact author CSV or verify a compatible IMF-derived series for date and the six required currency columns; document quote direction because Code.do multiplies values ending in _USD_Convert. Verify coverage within each 30-day near-date match, the 2012 cutoff, the manually supplied GEL dates, and any pre-2012 Compustat observations used for four-year leads/lags. The official IMF archive is a public candidate, not a verified six-currency compatible route.
3. For Compustat Global, obtain the named gzip export or verify the local COMP.G_FUNDA candidate's full period, population and transformation compatibility. The bounded probe found the required columns, but its SEDOL column is uppercase while the supplied keep statement names lowercase sedol; specify a supported mapping before using this candidate. Preserve the datadate-year filter and four fiscal-year lead/lag construction.
4. For FAME, obtain the named lst2_fornick.dta input or identify an actually compatible FAME product/export with registered_number, firmtenure, non_audit_fee, audit_fee, accounts_date and ticker_symbol. The assigned catalog search found no FAME entry; this does not establish that the source or a license is unavailable.
5. For I/B/E/S, obtain the named EPS International summary file or verify the local IBES.STATSUM_EPSINT candidate's required period, full firm/fiscal-period population and 2013-2016 mapping. The bounded probe found the needed raw columns, and Code.do lowercases imported names, but the sample does not establish historical coverage.
6. For Audit Analytics, obtain the named Europe fee CSV or verify the FEED71 Europe fee table plus FEED70 company-map candidate as one route. Resolve ENTITY_MAP_FKEY-to-ISIN mapping, source-column renames, 2012-2016 coverage, population and the author's merge contract; do not treat either local table as a verified substitute on its own.
7. Stage compatible inputs under the exact DATA/RAW DATA names and verify bounded source headers plus the ordered generated-field/key contracts in probes/workflow_trace.json before any separately authorized execution.

Validation to perform later:

- Compare each acquired or mapped source's actual imported fields, record unit, identifiers, fiscal-period mapping, date coverage and units with the cited Code.do reads and joins; confirm every trace handoff from FIRM_ID.dta and 1.2.K.dta through 1.2.A.dta, 1.2.F.dta, 1.2.J.dta, 1.2.T.dta, 2.1.dta, 2.2.a.dta and FINAL.dta without executing author code during this assessment.

### A_ROOT: Replace the author's machine-specific root with a relative root and execute from the prepared project directory that contains the DATA subdirectories.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_ROOT
Evidence: E_ROOT, E_HAND, E_MERGE

**Proposed edit:** `Code.do:4–4`
Source SHA-256: `6a4d015cd4bb68553681d595d690a42f03820de7c6199b2d984c5d696bc3436c`

The host wrapper can choose the working directory; keeping the supplied DATA-relative paths intact avoids the hard-coded author workstation path.

Current text:
```
global home_directory "[redacted-path-1204eec0c014]"
```

Proposed replacement:
```
global home_directory "."
```

Preparation / proposed procedure:

1. In a working copy, make the line 4 replacement and keep the subsequent cd and all DATA-relative paths unchanged.
2. On the eventual execution host, place Code.do and the staged DATA tree in a dedicated writable run root; invoke Stata batch mode with that root as the current working directory. Use a relative path or [redacted-path-e8ccba0b8ba7] path in the host wrapper, not a Dropbox workspace path.

Validation to perform later:

- Before an authorized run, confirm that all DATA/RAW DATA and DATA/PROC DATA locations resolve under the chosen root and that the host can read inputs and write generated intermediates there.

### A_APPENDIX: Resolve whether the included U.S. Auditor Materiality Decisions appendix is intended to accompany this registered Non-GAAP paper.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_APPENDIX
Evidence: E_DATA_TITLE, E_APPENDIX_TITLE

Preparation / proposed procedure:

1. Ask the depositor to identify the appendix's intended paper/package and provide the matching appendix only if this file was included in error.

Validation to perform later:

- Check the confirmed appendix title/DOI against the registered header before using its material as evidence about this paper.

### A_GBP_MACRO: In a working copy, quote the expanded currency-loop macro in the two GBP division-by-100 conditions while preserving the original division, currency tests and multipliers.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_GBP_MACRO
Evidence: E_GBP_MACRO, E_STATA_MACRO_QUOTING, E_WORKFLOW_TRACE

**Proposed edit:** `Code.do:262–262`
Source SHA-256: `6a4d015cd4bb68553681d595d690a42f03820de7c6199b2d984c5d696bc3436c`

The loop value is a string label; quoting its expansion makes the comparison test that label against GBP while preserving the existing GBP-only forecast scaling and all following currency-conversion logic.

Current text:
```
		replace `var' = `var'/100 if `cur' == GBP & curcode == "GBP"
```

Proposed replacement:
```
		replace `var' = `var'/100 if "`cur'" == "GBP" & curcode == "GBP"
```

**Proposed edit:** `Code.do:269–269`
Source SHA-256: `6a4d015cd4bb68553681d595d690a42f03820de7c6199b2d984c5d696bc3436c`

The loop value is a string label; quoting its expansion preserves the existing GBP-only actual-value scaling and subsequent currency conversion.

Current text:
```
	replace value = value/100 if `cur' == GBP & curr_act == "GBP"
```

Proposed replacement:
```
	replace value = value/100 if "`cur'" == "GBP" & curr_act == "GBP"
```

Preparation / proposed procedure:

1. Apply the two exact after snippets to Code.do in a working copy, preserving tabs, surrounding loop structure, the divide-by-100 operations, and the following USD-conversion lines.

Validation to perform later:

- Statically compare both edited conditions with the adjacent quoted currency comparisons; after any separately authorized run, verify the affected I/B/E/S GBP values retain the author's documented input units before USD conversion.

### A_SOFTWARE: Configure compatible Stata 18 ado support for all four commands invoked by Code.do; Stata itself is available, but the commands were not found in either checked ado path.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_GZUSE, S_DROPMISS, S_NEARMRG, S_WINSOR2
Evidence: E_SW_GZUSE, E_SW_DROPMISS, E_SW_NEARMRG, E_SW_WINSOR2, E_SW_CONFIGURED, E_ENVIRONMENT

Preparation / proposed procedure:

1. Before a separately authorized run, identify and configure the compatible source/release and ado path for gzuse, dropmiss, nearmrg and winsor2. Preserve the Code.do calls, including nearmrg's nearvar(), genmatch() and limit(30) options, rather than substituting commands or changing the analysis.
2. Record the command versions and any required dependencies in the run environment; do not install or download packages as part of this assessment.

Validation to perform later:

- On the eventual Stata 18 execution host, use read-only which/help checks for each exact invoked command and confirm the documented call options before any separately authorized full workflow run.

### A_ORDER: Follow the supplied Code.do order and named producer-consumer chain through FINAL.dta after the raw-input, software and working-root preparation is complete.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: I_CLOSURE
Evidence: E_WORKFLOW_TRACE, E_ROOT, E_HAND, E_FX, E_COMPUSTAT, E_FAME, E_IBES, E_AA, E_MERGE, E_VARIABLES, E_VARIABLES_OUTPUT, E_FINAL

Preparation / proposed procedure:

1. Use a dedicated writable working root containing Code.do and DATA/RAW DATA plus DATA/PROC DATA; create those directories during setup because the supplied script does not create them. Set home_directory to '.' in the working copy and start batch Stata from that root.
2. Import HAND_COLLECTED_DATA.xlsx and create DATA/PROC DATA/FIRM_ID.dta; import the currency CSV and create 1.2.K.dta. The currency panel feeds the subsequent Compustat, FAME and I/B/E/S stages.
3. Run the supplied Compustat Global stage with FIRM_ID.dta and 1.2.K.dta to produce 1.2.A.dta; then the FAME stage with FIRM_ID.dta and 1.2.K.dta to produce 1.2.F.dta; the I/B/E/S stage with FIRM_ID.dta and 1.2.K.dta to produce 1.2.J.dta; and the Audit Analytics stage with FIRM_ID.dta to produce 1.2.T.dta.
4. Import the hand-collected workbook as the 2.1 base. Merge 1.2.A.dta by gvkey/fyear, 1.2.T.dta by isin/fyear/audit_firm_hand, 1.2.F.dta by regno/fyear with update, then 1.2.J.dta by sedol2/fyear; save 2.1.dta.
5. Consume 2.1.dta in the variable-construction stage, including its gvkey/fyear panel, and save 2.2.a.dta. Consume 2.2.a.dta in the final stage, apply the supplied winsor2 and dropmiss calls, and save FINAL.dta.
6. Keep all named inputs and branches in this order. The trace records these intermediate files as generated dependencies, not as separate external-data requirements; their schemas and upstream compatibility are still subject to the unresolved input checks.

Validation to perform later:

- Before a separately authorized execution, verify each staged directory is visible and writable and each preceding output has the expected name, key fields and source-to-consumer mappings in probes/workflow_trace.json; no stage was executed in this assessment.


## Remaining issues and prerequisites

- I_CLOSURE [unresolved; full_pipeline]: Code.do reads six named raw files that are absent from the package: the hand-collected workbook, currency CSV, Compustat Global gzip file, FAME DTA, I/B/E/S EPS International file, and Audit Analytics Europe fee CSV. The package's only data file is a registration-number list and Code.do does not read it. The assigned frozen catalog has native global Compustat and I/B/E/S candidates with successful one-row reads, and an Audit Analytics Europe fee/company candidate pair; those are not yet verified for period, population, transformations or every handoff. No FAME or exact raw-file catalog entry was found. Hand-workbook field ownership, currency quote/history, vendor-source mappings and required observation coverage remain unresolved before the 2.1.dta -> 2.2.a.dta -> FINAL.dta chain is closed.
- I_ROOT [preparation; full_pipeline]: The entry script changes to an absolute Mac user directory that is not part of this release. The DATA-relative paths can be preserved by staging the expected DATA tree under a dedicated writable run root, setting home_directory to '.', and launching Code.do in batch mode from that root.
- I_APPENDIX [unresolved; full_pipeline]: The frozen header and datasheet identify Audit Implications of Non-GAAP Reporting, while the included online appendix identifies itself as U.S. Auditor Materiality Decisions and describes a U.S. audit-partner survey. Retain the registered title/DOI and the Code.do workflow as imported; ask the depositor to confirm whether this appendix belongs in this package before attributing its contents to the registered paper. The appendix is not used as an input or analysis entry point for the supplied Code.do target.
- I_FX_CONVENTION [unresolved; full_pipeline]: The supplied currency CSV is absent. Code.do says the source rates were daily representative rates reported to the IMF, filters the source to dates from 2012, and multiplies accounting/fee/forecast fields by names ending in _USD_Convert. The official IMF archive describes representative rates as currency units per U.S. dollar. The exact author CSV quote convention, inverse conversion, six-currency coverage, required event dates within the 30-day merge limit, and treatment of any pre-2012 Compustat rows used in the four-year lags are unresolved; do not change conversion direction or extend coverage without supported evidence.
- I_GBP_MACRO [preparation; full_pipeline]: The two I/B/E/S division-by-100 conditions compare the expanded loop macro to bare GBP tokens. Stata 18 documents that an unquoted macro value is treated as a variable; the adjacent currency-selection conditions already quote the macro. Quote the expanded macro in both comparisons in a working copy, preserving the GBP-only scaling, source variables and subsequent currency multipliers. This is a supported same-operation preparation correction, not a result of executing Code.do.
- R_HAND [undetermined]: Author-prepared hand-collected workbook used both to create the firm crosswalk and as the base table for the four-source merge. The workbook's full schema and the origin of its non-vendor analysis fields are not supplied.
- R_CURRENCY [undetermined]: Daily currency-rate input required by Compustat, FAME and I/B/E/S preparation stages; all three merge rates by a date within a 30-day limit.
- R_COMPUSTAT [undetermined]: Compustat Global fundamentals file used to construct the gvkey/fyear accounting panel and up to four fiscal-year leads and lags.
- R_FAME [undetermined]: FAME firm audit-fee and auditor-tenure file used in the 1.2.F preparation stage and later merged by regno/fyear.
- R_IBES [undetermined]: International I/B/E/S EPS summary input used to construct the annual firm-year analyst measures merged into the analysis table.
- R_AA [undetermined]: Audit Analytics Europe audit-fees CSV used to build the 1.2.T firm-year/auditor fee panel merged into the hand-collected base.
- S_GZUSE [preparation_required]: The actual command used to read the Compustat Global and I/B/E/S files was not found by which in Stata 18's default or checked shared ado path. Its required release/source and compatible inputs remain to be configured.
- S_DROPMISS [preparation_required]: The actual command used for missing-observation drops was not found by which in Stata 18's default or checked shared ado path. Its required release/source remains to be configured.
- S_NEARMRG [preparation_required]: The actual command used for currency-date matching was not found by which in Stata 18's default or checked shared ado path. Its required release/source and limit(30) call compatibility remain to be configured.
- S_WINSOR2 [preparation_required]: The actual command used for final 1st/99th percentile replacement was not found by which in Stata 18's default or checked shared ado path. Its required release/source remains to be configured.

## Review notes

- This target covers the supplied Code.do data-preparation stages through FINAL.dta. No separate estimation or table-producing program is supplied; this is not a claim of paper-wide result reproduction.
- The packaged FIRM_IDS.csv is an identifier list with a bounded one-row probe exposing regno only, and Code.do does not read it; it is not a compatible analysis panel.
- The supplied online appendix identifies itself as U.S. Auditor Materiality Decisions while the frozen title/datasheet identify Audit Implications of Non-GAAP Reporting. The attribution issue is retained; frozen metadata and the as-downloaded Code.do workflow remain unchanged, and the appendix is not treated as a workflow input.
- Assessment was static. No author code, estimator, SAS startup, data payload, or synthetic/descriptive trial was run. E_CATALOG_CLI_FAILURE is retained only as process history and is intentionally absent from every evidence_ids list; its missing snapshot sibling resources.py is not a data or access finding.
- Local Compustat Global, I/B/E/S and paired Audit Analytics Europe records and the official IMF archive are candidates with specific unresolved source-field, period, population, construction or coverage contracts. The FAME catalog miss and bounded one-row probes do not establish availability or completeness.
