# Patch proposal: jar-d0ea8ffac4b2

Divergence of Cash Flow and Voting Rights, Opacity, and Stock Crash Risk: International Evidence

DOI: 10.1111/1475-679X.12185

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow: supplied SAS construction from weekly dual-class security, index, currency, and Worldscope inputs through My.low/My.high, plus the manuscript and Online Appendix analyses described by the package. The supplied script stops at the two prepared opacity samples, so final table production remains unresolved.

Entry points: `HKW_SAS Program.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 5/12185 - Divergence-of-Cash-Flow-and-Voting-Rights-Opacity-and-Stock-Crash-Risk-International-Evidence/hong-kim-welker-datasheet-and-code.zip",
      "sha256": "e6f91d2cf7649f6fa34eb54927b5e30d14ff0a991165bca86bfcbcc72b873dd0"
    },
    {
      "path": "JAR-Volume 55/Issue 5/12185 - Divergence-of-Cash-Flow-and-Voting-Rights-Opacity-and-Stock-Crash-Risk-International-Evidence/hong-kim-welker-online-appendix.pdf",
      "sha256": "1af5ed772ca95fde44d47fd2b51775daf250a6dbd4c871bd8ab2176399a68bf0"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "fe0b135fe9d92e42bcaf43d86c8570e459342ad3bd0244b8d239c7033732c67a",
  "work_item_sha256": "6afab4183332e603e45f51446f4db7b1efb8b9ae5139685ab4a63a97045fd67d"
}
```

## Proposed actions

### ACT_INPUT_DATA: Obtain the author-prepared inputs and verify source-product compatibility, identifier mappings, and the histories required by the supplied workflow.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_WEEKLY_DS, R_BLOOMBERG_TURNOVER, R_FX, R_DUAL_LIST, R_SEDOL_MAP, R_GLOBAL_INDEX, R_US_INDEX, R_WS_ANNUAL, R_WS_OPACITY, R_INDUSTRY, R_APPENDIX_INPUTS
Evidence: E_DOC_SOURCES, E_DOC_METHOD, E_COUNTRY_CALLS, E_BLOOMBERG_READ, E_FX_READ, E_DUAL_INPUT, E_SEDOL_JOIN, E_MARKET_READ, E_US_INDEX, E_ANNUAL_CONTROLS, E_CFO_WINDOW, E_SMOOTH_WINDOW, E_APPENDIX_A12, E_CATALOG_PRODUCTS, E_SEDOL_PACKAGED, E_LOCAL_DS_INDEX, E_LOCAL_DS_NAMES, E_LOCAL_DS_FX, E_LOCAL_WS_FUNDA, E_LOCAL_CRSP_DSI

Preparation / proposed procedure:

1. Request/stage the 20 author-prepared country series, Bloomberg turnover matrix, raw exchange-rate matrix, Dual_List, country/global index series, US index series, Worldscope_data, WS_EXT_INT_SMTH, the My2 industry_sample input, and the type-to-SEDOL mapping. The packaged workbook is only a one-column identifier list.
2. Confirm Datastream identifiers and pair/class coding, weekly Friday frequency, currency mapping and USD quote units, Bloomberg firm/date/turnover mapping, and Worldscope SEDOL/year item-code-to-alias mapping. Retain author-prepared inputs where available; do not reconstruct the hand-collected voting-rights list independently.
3. Verify the weekly inputs cover the code’s 1994–2007 filter and required prior-week return plus two market, US, and FX leads/lags around retained Fridays. The datasheet reports 26 observations per firm-year; reconcile the appendix’s 20-week description before fixing expected sample counts.
4. Verify annual SEDOL/year history for the one-year lags and five-year CFO/opacity windows. The code differences ocf/accruals and drops the first row per SEDOL twice before those five constructed values, so raw prerequisites may precede the visible rolling window; exact earliest alignment remains unknown because producers/joins are incomplete. Obtain the author’s coverage requirement rather than guessing a start year or independently rebuilding the input.
5. Use the frozen local Datastream, Worldscope, and CRSP product probes only as field-level candidates. The probes read one row and explicitly leave population/sample history unverified; confirm the author-schema transformations and actual product access before treating any candidate as compatible.
6. Request author input specifications and data for unprovided appendix branches. Treat FactSet/LionShares, Compustat Global/America, and other appendix references as source leads until the missing analysis workflow confirms exact products, fields, sample, and dates.

Validation to perform later:

- After a separate authorized run, confirm all prepared inputs are readable with matching identifiers/fields and the required date history, and reconcile sample counts to the author-confirmed 26- versus 20-week rule and version-specific expected outputs.

### ACT_LIBRARY_SETUP: Recover the author’s SAS library setup for My and My2 and map it to the staged input folder.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: ISS_LIBRARY_SETUP
Evidence: E_CODE_LIBNAME, E_INDUSTRY_READ, E_INVENTORY

Preparation / proposed procedure:

1. Request the omitted autoexec or documented library assignments and the exact path containing each named dataset.
2. After the files and configuration are available, set up My and My2 in the future authorized SAS environment without changing the underlying variable definitions.

Validation to perform later:

- In a future authorized SAS session, confirm both libraries resolve and the named datasets are readable with PROC CONTENTS; check that My2.industry_SAMPLE has the author-confirmed industry key and classification.

### ACT_SOURCE_CLARIFICATIONS: Resolve missing intermediate producers, exchange-rate and PROC CORR schema handoffs, and conflicting sample/classification details before modifying the author program.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: ISS_O0_INT, ISS_MKTCAP, ISS_SAMPLE_THRESHOLD, ISS_INDUSTRY_CODE, ISS_FX_SCHEMA_HANDOFF, ISS_SMOOTH_OUTPUT_MATCH
Evidence: E_CFO_WINDOW, E_MARKETCAP_CALC, E_MKTCAP_USE, E_MKTCAP_CONTROL, E_DOC_METHOD, E_26WEEK_CODE, E_INDUSTRY_READ, E_INDUSTRY_APPENDIX, E_FX_HANDOFF_SOURCE, E_FX_DOWNSTREAM_SCHEMA, E_SMOOTH_OUTPUT_NAME_CHECK

Preparation / proposed procedure:

1. Ask the authors to supply the producer/schema for o0_int or confirm whether it should link to a differently named saved dataset; do not silently substitute o0_out.
2. Ask whether MKTCAP is an input alias or an omitted derived variable and how it relates to the program’s MARKET_CAP calculation; do not rename or recalculate without confirmation.
3. Ask which sample cutoff is authoritative for this release: the datasheet/code’s 26 weekly returns or Appendix A1’s 20 weekly observations, and request the corresponding expected counts.
4. Ask for the source and mapping that turns the My2 SICH/dnum industry value into Appendix A1’s Fama-French 48 classification.
5. Ask the authors to confirm the exchange-rate schema written at My.exchange_rate after the transpose and provide the omitted mapping to downstream DATE, RATE, and COUNTRY fields; preserve units and the 18-currency crosswalk.
6. Ask for the PROC CORR output schema or missing producer that explains the SMTH_numerator/SMTH_denominator inputs versus the SMTH2_denominator/SMTH2_numerator names selected downstream; do not rename or recompute the smoothing measure without confirmation.

Validation to perform later:

- After the author-provided details are applied in a future authorized run, confirm the named intermediate and market-cap variable are produced, sample eligibility matches the confirmed threshold, and the industry categories match the stated table definition.
- After confirmed source/schema details are available, verify that the PROC CORR output yields the intended smoothing records and that the rewritten exchange-rate dataset provides the downstream date/rate/country fields and required lead-lag series.

### ACT_ANALYSIS_PROGRAMS: Request the remaining executable analysis workflow for the manuscript results and Online Appendix tables.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: ISS_ANALYSIS_PROGRAMS, R_APPENDIX_INPUTS
Evidence: E_DOC_SAS, E_FINAL_OUTPUT, E_APPENDIX_TABLES_1, E_APPENDIX_TABLES_2, E_APPENDIX_A12, E_INVENTORY

Preparation / proposed procedure:

1. Request all remaining main-result regression and table-generation scripts, including independent appendix branches, their prerequisites, run order, and version notes.
2. Request schemas or prepared analysis inputs for the matched single-class branch and the specific A12 institutional-ownership/market-competition analysis; confirm whether the listed sources are supplied, restricted, or need author-prepared merges.
3. Obtain expected output names and table-level sample counts so the supplied My.low/My.high construction can be connected to the reported results without independently reconstructing missing analyses.

Validation to perform later:

- In a future authorized execution, trace each reported main and appendix table to its supplied entry point and verify that the expected output datasets and sample counts are produced.

### ACT_SAS_RUNTIME: Establish a working, version-compatible SAS runtime for the supplied program.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS
Evidence: E_DOC_SAS, E_GMM_MODEL, E_ENV

Preparation / proposed procedure:

1. Ask the local SAS administrator to confirm an authorized SAS runtime and availability of PROC MODEL/GMM for this program; the TKELS startup failure is an initialization finding, not evidence of absent entitlement.
2. After libraries and inputs are ready, run the supplied program only in a separately authorized execution step, then evaluate its intended downstream analysis scripts after they are provided.

Validation to perform later:

- Record the working SAS version and confirm PROC MODEL/GMM availability in the authorized environment before running the author workflow; do not infer runtime availability from the current failed startup probe.


## Remaining issues and prerequisites

- ISS_LIBRARY_SETUP [unresolved; full_pipeline]: The only supplied LIBNAME declaration hard-codes My to [redacted-path-1fa234784ad3], while the program reads My2.industry_SAMPLE without declaring My2. The assigned release contains neither the referenced SAS datasets nor an autoexec/library setup, so the intended My/My2 locations and industry input path are unresolved.
- ISS_O0_INT [unresolved; full_pipeline]: The program creates o0_out from the five-year CFO window, then joins from o0_int; no o0_int producer is present in the only supplied SAS program. The intended producer/input cannot be inferred safely.
- ISS_MKTCAP [unresolved; full_pipeline]: The code computes MARKET_CAP from the two share-class market values, but downstream annual aggregation and control formulas use MKTCAP. No assignment to MKTCAP appears in the supplied program; whether it is an expected input alias or an omitted mapping is unresolved.
- ISS_SAMPLE_THRESHOLD [unresolved; full_pipeline]: The datasheet and supplied SAS implement a 26-week minimum, while Appendix A1 describes inclusion with 20 weekly observations. The intended version-specific sample criterion and expected counts need author confirmation.
- ISS_INDUSTRY_CODE [unresolved; full_pipeline]: Appendix A1 specifies Fama-French 48 industry, while the code only reads SICH as dnum from the undeclared My2.industry_SAMPLE input. No supplied mapping to FF48 or A1 table-generation path is present.
- ISS_ANALYSIS_PROGRAMS [unresolved; full_pipeline]: The only SAS program constructs crash measures/controls and finishes with My.low and My.high. The datasheet says SAS ran the analyses and the supplied Online Appendix lists A1–A12 analyses, but no further main-result regression or table-generation programs are included. The remaining procedures, branch-specific inputs, and output sequence need author clarification.
- ISS_FX_SCHEMA_HANDOFF [unresolved; full_pipeline]: The code reads My.exchange_rate as an input, then overwrites that same dataset with transposed e1_out data carrying the currency/date-oriented schema. Later code expects DATE, RATE, and COUNTRY and constructs FX leads/lags, but no mapping or producer from the rewritten schema to those downstream fields is visible. Request the author-confirmed schemas/omitted transformation; do not invent a rename or currency/quote conversion.
- ISS_SMOOTH_OUTPUT_MATCH [unresolved; full_pipeline]: The supplied code constructs SMTH_numerator and SMTH_denominator, then filters PROC CORR output for _NAME_="SMTH2_denominator" and reads SMTH2_numerator before keeping only nonmissing smoothing. No rename or producer for the SMTH2_* names is shown, so the correlation-to-smoothing output match remains unresolved and may drop the intended observations. Request the author-confirmed PROC CORR output schema/producer; do not rename blindly or infer the scientific measure.
- R_WEEKLY_DS [undetermined]: Author-prepared weekly Friday-to-Friday Datastream securities input for the 20 named country tables (security/date keys, close price, weekly return, equity market value, dividends, shares outstanding, and turnover). The program filters 1994–2007 and the stated final sample is 1995–2007 with at least 26 observations per firm-year; two local-market leads/lags and the within-firm prior-week return require adjacent weekly history around the retained dates. Exact first/last Friday coverage is unverified.
- R_BLOOMBERG_TURNOVER [undetermined]: Supplemental Bloomberg turnover matrix joined by Bloomberg firm and date for the Datastream turnover gaps; field naming, units, ticker coverage, and the actually needed missing-value population are not provided.
- R_FX [undetermined]: Prepared exchange-rate matrix keyed to weekly dates and 18 code-mapped currencies, used to convert both share-class market values into USD and to construct exchange-rate leads/lags in the return model. The program later overwrites My.exchange_rate with its transposed e1_out structure, then expects DATE/RATE/COUNTRY downstream; the intervening mapping, product, quote direction, units, and complete date range are undocumented.
- R_DUAL_LIST [undetermined]: Complete author-maintained dual-class share table with Datastream security codes, high/low flags, pair identifiers, vote-per-share counts, currency, Bloomberg ticker, and effective dates for the 20-country sample; eligibility criteria must match the selected release version.
- R_SEDOL_MAP [undetermined]: Security crosswalk required by the code to join each high/low Datastream code to a SEDOL and then to annual Worldscope data; the code expects My.sedol fields used as type and sedol_code.
- R_GLOBAL_INDEX [undetermined]: Country-level Datastream index series with country identifier, date, market-index level/return fields used to form weekly local market returns, for all included countries. Code uses FIC, datadate, PRCCD, and mkt_ret aliases; the author-specific extraction and product configuration are absent.
- R_US_INDEX [undetermined]: US market-index observations with DATE and S&P 500 return (SPRTRN), filtered to Fridays and used with two leads and two lags across the 1994–2007 panel.
- R_WS_ANNUAL [undetermined]: Annual Worldscope firm-year input joined by SEDOL/year for book equity, assets, income, long-term debt, receivables, inventory, sales, cash flow, and related control variables. The author aliases and exact item mapping are not documented.
- R_WS_OPACITY [undetermined]: Author-prepared Worldscope extended international smoothing input WS_EXT_INT_SMTH with SEDOL/year, cash-flow/accrual item fields, and five annual constructed values per rolling calculation. The code differences ocf/accruals and drops the first row per SEDOL twice before forming windows year−5 through year−1, so raw source history may need to precede those five constructed values; exact earliest alignment remains unknown because the producer/join handoff is incomplete.
- R_INDUSTRY [undetermined]: Industry crosswalk read as My2.industry_SAMPLE with SEDOL and SICH, attached to the dual-class observations. Appendix A1 describes Fama-French 48 categories; the supplied code does not show the mapping to that classification.
- R_APPENDIX_INPUTS [undetermined]: Data and workflow for the complete manuscript/Online Appendix result tables beyond the supplied construction of My.low and My.high. The Appendix names further analysis variants (including a matched single-class sample, and A12 institutional holdings/market competition sources) but does not provide runnable analysis programs, full input schema, or historical requirements; these product names remain clarification leads.
- SW_SAS [unverified]: The author requires SAS; supplied code uses PROC MODEL with GMM and other SAS procedures. The author’s exact SAS version is not stated. The local SAS executable probe failed during TKELS initialization, so the working version, PROC MODEL availability, and license status remain unverified.

## Review notes

- No analysis_only scope is supported: the release has no complete author-prepared analysis dataset or completed regression inputs. SEDOL_HKW.xlsx is only an identifier list, and the SAS program itself creates My.low/My.high from absent raw/author-prepared inputs.
- The full supplied SAS program and all appendix output descriptions were inspected. Checklist edges D0001–D0019 are reviewed; raw reads in the program not represented by the static checklist, including My.sedol and o0_int, were assessed separately.
- Local Datastream, Worldscope, and CRSP probes were bounded to one row on exact frozen-catalog paths. They establish readability/columns only, not compatible author mappings, full product access, or sample/history coverage.
- The program’s 26-week filter and Appendix A1’s 20-week description conflict. The final sample counts and analysis versions cannot be reconciled without author clarification.
