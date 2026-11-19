# Patch proposal: jar-3e9670be661e

Accounting for Cryptocurrencies

DOI: 10.1111/1475-679X.70018

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Author-documented keyword search, manual filing review and hand collection, Compustat/CRSP/Audit Analytics/I/B/E/S joins, cryptocurrency series construction, and Stata analyses.

Entry points: `Identify Crypto Mentions in XBRL.py`, `AFMS Accounting for Cryptocurrencies DO File.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 1/70018 - Accounting-for-Cryptocurrencies/afms-datasheet-code-identifier-and-log-files.zip",
      "sha256": "442f29e66fbca62ceee668908d2c024cf18058655e06f19dd71ddd1c8a0db481"
    },
    {
      "path": "JAR-Volume 64/Issue 1/70018 - Accounting-for-Cryptocurrencies/afms-internet-appendix-20250731.pdf",
      "sha256": "a1a929f1ff0cc734e3727f658fd3db57b9210064fa11cd99817accf8a93167f2"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "5eef960a33488d5ade6c1854e2111558a87c8fb70161c2102c1430b0c333aec0"
}
```

## Proposed actions

### A_SEC_ACQUIRE: Acquire the SEC notes/text datasets for the study years and identify the sample filings for manual verification using the final CIK/date list. Configure the Python input directory and confirm the SEC ZIP member layout expected by the source.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_SEC_NOTES, R_SEC_FILINGS
Evidence: E_SEC_NOTES_TEXT, E_SEC_NOTES_COVERAGE, E_SEC_TXT_VALUE, E_SEC_ARCHIVE, E_WORKFLOW_SEARCH, E_WORKFLOW_HANDCOLLECT

Preparation / proposed procedure:

1. Use the official SEC Financial Statement and Notes data releases covering 2013Q4–2022Q4.
2. Verify the downloaded source members expose the documented TXT value field in the exact archive layout expected by the Python reader.
3. Select filings by the packaged final-sample CIK/date list, manually verify keyword hits, and record the hand-collected values in the author-defined workbook once its schema is supplied.

Validation to perform later:

- Compare selected filing dates and CIKs with the final sample list.
- Check TXT field and archive member names before any full author-program run.

### A_COMP_SIC_PREP: Resolve the historical SIC owner and the date/key mapping needed to build both Compustat inputs and NFirms without changing the study’s quarter, SIC2 or firm-count definitions.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMP_FUNDQ_UNIVERSE, R_COMP_FUNDQ_MAIN, R_COMP_SIC_MAP, I_COMP_SIC_MAPPING
Evidence: E_COMP_FUNDQ_COMPARE_MAIN, E_COMP_FUNDQ_COMPARE_UNIVERSE, E_COMP_CO_INDUSTRY_PROBE, E_FUNDQ_UNIVERSE_INPUT, E_FUNDQ_MAIN_FIELDS, E_FUNDQ_NFIRMS_OUTPUT

Preparation / proposed procedure:

1. Confirm whether COMP.CO_INDUSTRY.sich is the intended historical SIC source and document the join keys/date rule for each Compustat quarter.
2. Prepare the source-required sic field for compustat_fundq_SIC.dta and compustat_fundq.dta only after the mapping is established.
3. Keep compustat_fundq_NFIRMS.dta as a generated output of the universe stage, not a separately sourced input.

Validation to perform later:

- Compare the selected SIC values and dates to the author’s source contract before generating NFirms.
- Confirm the main Compustat file contains every source-consumed field, including the mapped sic, and all final-sample CIK/date keys.

### A_AA_MAP: Obtain the Audit Analytics product/record definition that maps current auditor key/name to opinion-level fields and confirms the fiscal-year-date selection.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_AA_OPINIONS, I_AA_CURRENT_AUDITOR
Evidence: E_AA_COMPARE, E_AA_PROBE, E_AA_FIELDS, E_AA_YEAR_STAGE

Preparation / proposed procedure:

1. Confirm whether the selected Audit Analytics product has current-auditor values and how those values relate to AUDITOR_FKEY/AUDITOR_NAME on an opinion record.
2. Document the record selection and effective-date rule before creating aa_opinions.dta.

Validation to perform later:

- Compare exact current-auditor semantics, company key type and fiscal-year coverage before the author merge.

### A_IBES_COVERAGE: Use the supported US detail-with-actuals source and confirm sample-period history, then stage it as the author’s ibes_detail.dta. The source’s CUSIP case-normalizing rename is existing preparation.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_IBES_DETAIL
Evidence: E_IBES_PROBE, E_IBES_COMPARE, E_IBES_FIELDS, E_IBES_HANDOFF, E_APPENDIX_PERIOD

Preparation / proposed procedure:

1. Confirm DET_EPSUS contains observations spanning the required forecast periods and the CUSIP/date keys in the author’s sample list.
2. Convert the selected native detail fields to the expected Stata input while preserving estimator, activation date/time, value, actual and actual-announcement date.
3. Use the source’s existing CUSIP normalization and produce the copied analyst/estimate/actual fields for the hand-collected workbook.

Validation to perform later:

- Compare all eight consumed fields and date coverage before running the Stata entry point.
- Check that the existing field renames resolve native FPEDATS and CUSIP correctly.

### A_CRSP_PREP: Obtain the author’s prepared security-return producer/join specification and stage the supported CRSP.DSI market fields into the author merge contract without changing variables or return windows.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_CRSP_RETURNS, R_CRSP_MARKET_INDEX, I_CRSP_PRODUCERS
Evidence: E_CRSP_DSF_PROBE, E_CRSP_DSF_COMPARE, E_CRSP_DSENAMES_PROBE, E_CRSP_DSENAMES_COMPARE, E_CRSP_DSI_PROBE, E_CRSP_DSI_COMPARE, E_CRSP_METRICS, E_HC_STOCK_INPUT

Preparation / proposed procedure:

1. Confirm the CRSP security population, required dates and producer for crsp_returns.dta; use DSF daily security fields and DSENAMES PERMNO/TICKER plus NAMEDT/NAMEENDT only with the documented effective-date mapping.
2. For the verified local DSI market series, rename native DATE to caldt and preserve vwretd when staging crsp_mkt returns.dta.
3. Keep all author return, CAR and beta windows unchanged.

Validation to perform later:

- Check effective-date ticker mapping, PERMNO/CUSIP uniqueness and date coverage before constructing CRSP_MERGED RETURNS.dta.
- Check that the DSI date rename preserves the DATE/caldt contract and vwretd values; validate file format, path and sample-date coverage before using the market handoff.

### A_MISSING_HANDOFFS: Request the missing author-prepared workbooks and the named plot program, together with their field definitions, provenance and producer/consumer mapping.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CUSIP_DATE_MAP, R_COMBINED_ANALYSIS_DATA, I_HANDOFF, I_SOURCE_CLOSURE
Evidence: E_PACKAGE_INVENTORY, E_CUSIP_FDATE_STAGE, E_CUSIP_DATE_STAGE, E_COMBINED_IMPORT, E_COMBINED_FIELDS_A, E_COMBINED_FIELDS_B, E_COMBINED_MERGE_OUTPUT, E_DATASHEET_FILES, E_IBES_HANDOFF, E_CRSP_METRICS, E_HC_STOCK_OUTPUT

Preparation / proposed procedure:

1. Obtain CRSP returns_CUSIP & Date.xlsx and confirm the CUSIP/fdate and CUSIP/date column meanings and producer.
2. Obtain Crypto sample data_COMBINED.xlsx with column definitions and provenance for manual filing data and copied prepared CRSP/Audit Analytics/I/B/E/S/Yahoo outputs.
3. Obtain the named Plots for Paper code or confirm its role and whether it is needed for the stated output set.
4. Do not reconstruct the unavailable hand-collected workbook from regression outputs or synthetic records.

Validation to perform later:

- Map all required workbook columns to the source variable construction and analysis consumers.
- Confirm hand-collected observations, sample flags and analyst/auditor/return handoffs preserve the author sample.

### A_YAHOO_ACCESS: Confirm access to the needed Yahoo historical CSV product and the precise non-CRSP ticker/date coverage before preparing the author workbook.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_NONCRSP_STOCK_PRICES
Evidence: E_YAHOO_CSV, E_YAHOO_PLAN, E_HC_STOCK_INPUT

Preparation / proposed procedure:

1. Confirm that the user’s available Yahoo plan supplies daily Date, Ticker and Close observations for the required tickers and post-2010 sample dates.
2. Prepare Crypto sample stock prices.xlsx from the confirmed product without changing the source’s return/beta windows.

Validation to perform later:

- Check ticker, date frequency, field units and coverage before creating the workbook.

### A_CMC_ACCESS: Confirm the cryptocurrency identifiers, CoinMarketCap plan coverage and required daily history before preparing the author crypto-price workbook.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_CRYPTO_PRICE_VOLUME
Evidence: E_CMC_OHLCV, E_CMC_KEY, E_CMC_INPUT_FIELDS, E_CMC_ROLLING

Preparation / proposed procedure:

1. Confirm the coin IDs/symbols and eligible plan fields for daily close, volume and market capitalization.
2. If an authorized plan covers the study inputs, prepare Crypto prices_volume.xlsx with the source-required series and date granularity.
3. Do not test API keys or call the endpoint as part of this assessment.

Validation to perform later:

- Check selected coin identities, units, dates and sufficient observations for the source’s 91-day windows.

### A_PYTHON_SOURCE_EDIT: Propose the smallest Python source edits supported by the current import and pandas API evidence; no source file was modified.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: SW_PANDAS, SW_SWIFTER, I_PANDAS_API
Evidence: E_PYTHON_IMPORTS, E_PYTHON_READCSV, E_PYTHON_DISTRIBUTIONS, E_PANDAS_REMOVAL, E_PANDAS_ON_BAD_LINES, E_PANDAS_SKIP

**Proposed edit:** `Identify Crypto Mentions in XBRL.py:1–1`
Source SHA-256: `84ca80551dc47b4a2ec7e2bce7b40db8d0ab10073663f0f3bcefd8ff79603d6f`

swifter is not referenced outside its import and its distribution is missing; remove only the unused import rather than adding an unnecessary dependency.

Current text:
```
import pandas as pd, zipfile, numpy as np, csv, re, swifter, os
```

Proposed replacement:
```
import pandas as pd, zipfile, numpy as np, csv, re, os
```

**Proposed edit:** `Identify Crypto Mentions in XBRL.py:13–13`
Source SHA-256: `84ca80551dc47b4a2ec7e2bce7b40db8d0ab10073663f0f3bcefd8ff79603d6f`

pandas removed error_bad_lines from read_csv in version 2.0; the current documented on_bad_lines option with skip preserves the stated behavior.

Current text:
```
    df = pd.read_csv(BytesIO(input_zip.read('txt.tsv')),sep='\t',error_bad_lines=False) # Error bad lines = false will skip offending lines
```

Proposed replacement:
```
    df = pd.read_csv(BytesIO(input_zip.read('txt.tsv')),sep='\t',on_bad_lines='skip') # Skip offending lines
```

Preparation / proposed procedure:

1. Apply the two proposed changes in a working copy only after review.
2. Keep the SEC TXT selection, matching, multiprocessing and output semantics unchanged.

Validation to perform later:

- Check the edited lines against the frozen source hash and current pandas documentation.
- After all required input data and multiprocess are configured, run the author script only under the project’s normal user-approved workflow and confirm the output workbook is created.

### A_SOFTWARE_SETUP: Prepare the missing Python and Stata packages required by the supplied programs; no install was attempted.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_MULTIPROCESS, SW_ASROL, SW_UNIVAR, SW_WINSOR2, SW_OUTREG2
Evidence: E_PYTHON_DISTRIBUTIONS, E_PYTHON_IMPORTS, E_PYTHON_POOL_OUTPUT, E_STATA_ASROL, E_STATA_UNIVAR, E_ENVIRONMENT_PROBE, E_CMC_ROLLING, E_ANALYSIS_FIELDS, E_MARKET_ANALYSIS_FIELDS

Preparation / proposed procedure:

1. Install or otherwise provide the multiprocess Python distribution in the selected Python environment.
2. Provide Stata add-ons asrol, univar, winsor2 and outreg2 in the Stata 18 environment.
3. Keep rangestat as the already available Stata add-on.

Validation to perform later:

- Use the frozen version/which and distribution-metadata helpers to confirm each required command/module is available in the runtime used for the author workflow.


## Remaining issues and prerequisites

- I_HANDOFF [unresolved; full_pipeline]: The Stata source requires Crypto sample data_COMBINED.xlsx and CRSP returns_CUSIP & Date.xlsx, while the frozen package inventory does not list either file. The combined workbook holds manual filing and prepared vendor outputs; its exact schema, data provenance, and output-to-column mapping are not supplied.
- I_SOURCE_CLOSURE [unresolved; full_pipeline]: The datasheet names a Plots for Paper code file among the package code; no such source appears in the frozen inventory. Its role and whether it is necessary for the target outputs are not established.
- I_COMP_SIC_MAPPING [unresolved; full_pipeline]: The Compustat universe and main-file stages require sic, but COMP.FUNDQ lacks it. COMP.CO_INDUSTRY provides historical sich and datadate/gvkey; the source-compatible field/date join and universe selection are not specified.
- I_AA_CURRENT_AUDITOR [unresolved; full_pipeline]: The source requires CURR_AUD_FKEY and CURR_AUD_NAME. The candidate audit product has AUDITOR_FKEY/AUDITOR_NAME instead, but their record-level meaning and date relationship to the current-auditor fields are not established.
- I_CRSP_PRODUCERS [unresolved; full_pipeline]: The source consumes prepared crsp_returns.dta and crsp_mkt returns.dta, but the supplied program does not establish their producers or all joins. The raw daily CRSP.DSI market product is locally verified; the missing prepared filename still needs field-preserving date staging. For the security-return composite, CRSP name history supplies TICKER, while the PERMNO/effective-date mapping, population and required history remain unresolved.
- I_PANDAS_API [preparation; full_pipeline]: The Python source passes error_bad_lines to pandas.read_csv, which was removed in pandas 2.0 and is incompatible with the installed pandas 3.0.6 API. The official replacement is on_bad_lines; no author program was run.
- R_SEC_NOTES [public_acquisition_required]: Public SEC financial-statement and notes data used by the Python keyword search, including the text value field.
- R_SEC_FILINGS [public_acquisition_required]: SEC filing documents used for manual verification and hand collection after keyword hits are identified.
- R_COMP_FUNDQ_UNIVERSE [undetermined]: Quarterly Compustat universe records used to count firms by fiscal quarter and historical SIC2 for NFirms.
- R_COMP_FUNDQ_MAIN [undetermined]: Quarterly Compustat fundamentals, identifiers and SIC used to match sample firm-quarters, calculate prior-quarter assets and create the firm-quarter handoff.
- R_COMP_SIC_MAP [undetermined]: Historical SIC classification needed by both Compustat input stages and the NFirms join.
- R_AA_OPINIONS [undetermined]: Audit Analytics opinion records needed to identify current auditor fields and merge audit information to the final sample by firm/fiscal year.
- R_CRSP_RETURNS [undetermined]: Daily CRSP security returns/prices with CUSIP, PERMNO and effective-date ticker fields, plus value-weighted market returns, needed to construct the author crsp_returns.dta and return metrics.
- R_CUSIP_DATE_MAP [undetermined]: The CUSIP/forecast-date and CUSIP/filing-date map used to select I/B/E/S and CRSP observations for the study sample.
- R_NONCRSP_STOCK_PRICES [undetermined]: Daily non-CRSP stock prices imported as Date, Ticker and Close to calculate returns and market-adjusted metrics.
- R_CRYPTO_PRICE_VOLUME [undetermined]: Daily cryptocurrency close, volume and market-capitalization series needed for 91-day rolling liquidity/volatility measures and quarterly Bitcoin variables.
- R_COMBINED_ANALYSIS_DATA [undetermined]: The author-prepared combined workbook that hand-joins filing hand collection and prepared Compustat, audit, I/B/E/S and CRSP outputs, then supplies the primary Crypto sample data.dta analysis dataset.
- SW_PANDAS [preparation_required]: pandas 3.0.6 is installed, but the source uses error_bad_lines, removed from read_csv in pandas 2.0; use the documented on_bad_lines option in a source edit.
- SW_SWIFTER [preparation_required]: The module is imported but no further use was found in the screened program; it is absent from package metadata and can be removed from the import line.
- SW_MULTIPROCESS [preparation_required]: The program imports and invokes multiprocess.Pool; package metadata reports it missing.
- SW_ASROL [preparation_required]: The cryptocurrency construction block calls asrol; the Stata software helper reports it unavailable.
- SW_WINSOR2 [preparation_required]: The analysis calls winsor2; the typed environment probe reports it unavailable.
- SW_UNIVAR [preparation_required]: The descriptive statistics block calls univar; the Stata software helper reports it unavailable.
- SW_OUTREG2 [preparation_required]: The market tests call outreg2 to write tables; the typed environment probe reports it unavailable.

## Review notes

- Full pipeline is the only supported scope. The package includes a Python keyword-search program and a Stata preparation/analysis program; no complete analysis-only prepared dataset and entry point is supplied.
- The SEC/filing/manual hand-collection workflow, Compustat, Audit Analytics, I/B/E/S, CRSP, non-CRSP stock prices and crypto series all feed the missing author-prepared combined workbook. The appendix reports 2013Q4–2022Q4 full sample and 2013Q4–2018Q2 pre-guidance period.
- Producer/consumer accounting: sample firms_CIK & FS dates.dta is generated from the packaged sample CIK/date workbook and consumed in Compustat/Audit Analytics matching; compustat_fundq_NFIRMS.dta is generated at the Compustat universe stage and consumed by the combined workbook; CRYPTO_LIQUIDITY.dta is generated from Crypto prices_volume.xlsx and consumed by the combined workbook; Crypto sample data.dta is generated after those joins and consumed by the descriptive, discretion and market-test blocks.
- The Stata source also writes Compustat merged, Audit Analytics, I/B/E/S, CRSP and non-CRSP return staging outputs and comments that some are copied into the main Excel handoff. The CRSP market handoff crsp_mkt returns.dta is consumed by the non-CRSP branch although its producer is not established in the supplied source/static dependency checklist; it is covered as a required CRSP market input and unresolved preparation issue, not as an invented frozen dependency ID.
- DET_EPSUS is the selected I/B/E/S raw candidate: the full consumed-field comparison and one-row readable probe support the verified local raw route. Native CUSIP capitalization is ordinary staging; sample-date history/selection remains in A_IBES_COVERAGE as future validation.
- CRSP.DSENAMES supplies native PERMNO/TICKER and name effective-date fields, so TICKER is not treated as absent from CRSP. CRSP.DSI DATE/vwretd is a verified local raw market route; DATE-to-caldt naming, format/path and sample-date checks are preparation. The security-return composite’s producer, name join and population remain unresolved.
- Only successful typed JSON probe artifacts and exact screened source/public quotations are cited. Bounded one-row reads establish schema/readability, not population, time coverage or file counts. The source quote capture excludes masked lines; the machine-specific Python input path is not reproduced.
- Process failures and capture limitations are preserved in process_history_manifest_v2.json and individual process artifacts, but none are referenced as scientific evidence or used to infer data/software barriers. No author code, author imports, models or regressions were run; no datasets were downloaded; no software was installed; no edits were applied; execution_verified remains false.
