# Patch proposal: jar-88178a7d191f

Trade Secrets Law and Corporate Disclosure: Causal Evidence on Proprietary Cost Hypothesis

DOI: 10.1111/1475-679X.12187

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented SAS construction, cross-program handoffs and Stata Table 2 estimation; appendix branches remain in scope pending author mapping.

Entry points: `CODE1.sas`, `CODE2.sas`, `CODE3.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 1/12187 - Trade-Secrets-Law-and-Corporate-Disclosure-Causal-Evidence-on-Proprietary-Cost-Hypothesis/llz-datasheet-and-code.zip",
      "sha256": "d68f1f5101ebafac5a05f45323db16b7f89cb2af7956e25074193f6821464d77"
    },
    {
      "path": "JAR-Volume 56/Issue 1/12187 - Trade-Secrets-Law-and-Corporate-Disclosure-Causal-Evidence-on-Proprietary-Cost-Hypothesis/lilinzhangonlineappendix.pdf",
      "sha256": "271bff7d48dcb66b995341219c98609e76a96c276740046af4a75760dc2b1bd1"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "0e4b6c793c2c18d83eded93825874a9b86a385514c4a2f9fb585f6081821adcd",
  "work_item_sha256": "e47ca4318929d87cbb6dcfa31d5a8bf4b4cec9e3842def329fe60441e7dfa78b"
}
```

## Proposed actions

### A001: Obtain the exact segment input schema and author-documented source/join that supplies CIK before CIK2 and real_loca matching; do not infer an identifier mapping.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R001, I002
Evidence: E007, E008, E039, E042, E047

Preparation / proposed procedure:

1. Ask authors to identify the CIK-bearing extract or preceding merge, fields, keys and date/population coverage.
2. If the local COMPSEG candidate is intended, request the supported CIK construction and complete history.

Validation to perform later:

- Verify CIK2 population and author-confirmed joins from segment rows to real_loca/IDD before constructing disclosure outcomes.

### A002: Request the author-cleaned value_list and its identity/unreported coding rules.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R002
Evidence: E004, E007, E034, E048

Preparation / proposed procedure:

1. Obtain value_list fields CNMS and unreported plus its preparation notes.
2. Confirm the supplied merge and missing-value coding against the author recipe.

Validation to perform later:

- Check required columns, duplicate keys and merge coverage before producing hide_ratio/hide_ratio_sale.

### A003: Confirm current routes, field definitions and history for the IDD dates and 10-K header/locality inputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R003, R004
Evidence: E002, E008, E093, E094, E095

Preparation / proposed procedure:

1. Obtain the IDD event-date file and the named 10-K Header Data extract or documented current route.
2. Confirm State/CIK/date/location field mapping and complete coverage for target firm-years.
3. Treat the existing SEC raw, SEC parsed and LM 10-X roots as candidates only: their reused metadata confirms root presence, not readability, header schema or history. Confirm any author-supported extraction route and preservation of CIK/date/state fields before using them.

Validation to perform later:

- Check key/date formats, required periods and join coverage before building post/event time.
- For any author-confirmed filing route, verify CIK, f_fdate, ba_state/stinc schema, header-preservation rules and target-year/population coverage before joining to IDD/customer records.

### A004: Confirm the Compustat Annual product/vintage and map CODE1 `sic` to the author-confirmed field; preserve the full eligible U.S. industry-year population through HHI and adjusted-ROA/persistence fits, and establish only the code-documented 1976–2013 Big N plus t−1/lagged-ROA history.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R005, I008
Evidence: E010, E011, E035, E036, E042, E057, E034, E089, E090, E091, E092

Preparation / proposed procedure:

1. Confirm author extract or an exact WRDS Compustat North America Annual source and required fields.
2. Ask whether `sic` is intended to map to `sich`; preserve source code pending confirmation.
3. Verify annual history for Big N and lag/persistence construction; do not infer coverage from one-row samples.
4. Preserve all eligible FIC=USA annual observations through SIC/fyear HHI, adjusted-ROA and by-SIC persistence calculations; do not apply the packaged Firm ID list as an early screen. Apply any final sample restriction only at an author-confirmed stage.
5. Use the documented 1976–2013 Big N note and explicit t−1/lag construction; do not guess additional start/end dates.

Validation to perform later:

- Compare fields, years and identifiers with the author specification before constructing north/comp controls.
- Check group populations using the full eligible U.S. annual input and verify the author-confirmed later sample screen separately from group-level calculations.

### A005: Confirm the World Bank annual GDP-deflator series, units, history and fiscal-year mapping used by CODE1.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R006
Evidence: E009

Preparation / proposed procedure:

1. Obtain the cited series identifier or author extract and document units and year coverage.
2. Preserve the author deflator conversion and merge rules.

Validation to perform later:

- Check fyear coverage and units before merging inflation into annual controls.

### A006: Request the prepared SDC SEO/M&A indicators or the exact author extraction and transformation recipes.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R007, R008
Evidence: E005, E042, E053, E054, E055, E056

Preparation / proposed procedure:

1. Obtain sdcseo/sdcma files and definitions for GVKEY, FYEAR, SEO, MA, event filters and vintages.
2. Do not substitute raw deal records without author-supported mapping.

Validation to perform later:

- Check fields/key uniqueness/event years and the fyear=b.fyear+1 joins.

### A007: Acquire the annual state GDP-growth and unemployment inputs from the author-described BEA/BLS products after confirming the exact measure and file headers.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R009, R010
Evidence: E014, E045, E046

Preparation / proposed procedure:

1. Use BEA GDP-by-state downloadable data and BLS annual-average state series; confirm the historic vintage and exact growth/unemployment measures.
2. Create the CODE2 CSV inputs only after validating state/year/value headers and author-required transformations.

Validation to perform later:

- Check state/year coverage, units and prior-year joins before CODE2.

### A008: Request the three Gordon Phillips product-market files and their data dictionaries, history and keys.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R011, R012, R013
Evidence: E005, E015

Preparation / proposed procedure:

1. Obtain FICHHIdata_extend.txt, TNIC3HHIdata_extend.txt and fic_data_extended.txt.
2. Confirm required fields and mapping for ICODE300/FIC300HHI, GVKEY/TNIC3HHI/TNIC3TSIMM, and GVKEY/ICODE300.

Validation to perform later:

- Verify delimiters/headers, date coverage and prior-year merge keys.

### A009: Request the hand-cleaned political workbook and confirm its 93-2011 range and field meanings.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R014
Evidence: E022, E062

Preparation / proposed procedure:

1. Obtain the author workbook and confirm state/year/re/de/ind columns and imported types.
2. Preserve the specified worksheet range unless authors document a supported change.

Validation to perform later:

- Check imported headers and state/year match coverage before merging into reg11.

### A010: Resolve which analyst-count route feeds the final panel: the remote NumAnalysts_ann output or the separately consumed local analysts file.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R015, I004
Evidence: E018, E019, E020, E021

Preparation / proposed procedure:

1. Ask authors for the consumed analyst file producer, period, fields and mapping, and whether the remote branch is required.
2. Do not equate or remove the two routes without confirmation.

Validation to perform later:

- Verify the author-selected NANALYSTS field merges at GVKEY and the specified prior fiscal year and reaches CODE3.

### A011: Request the `issue` table producer/source and confirm whether the propensity-score branch is part of the replication target.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R016, I003
Evidence: E023

Preparation / proposed procedure:

1. Obtain the source/program for GVKEY/FYEAR/EQUITYFIN/DEBTFIN and its history.
2. Confirm the intended place of this branch in the output chain.

Validation to perform later:

- Check the input schema and author-specified logistic branch order before reg12.

### A012: Confirm the source product/vintage and period of fiscal_quarter_price; COMP.FUNDQ is only a matching-field candidate.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R017
Evidence: E012, E037, E042

Preparation / proposed procedure:

1. Ask whether the author file is Compustat Quarterly, CRSP or another product.
2. Confirm fiscal-year history and within-year fallback selection.

Validation to perform later:

- Check GVKEY/FYEARQ/FQTR/CSHOQ/PRCCQ and fallback observations before calculating market value.

### A013: Confirm WRDS SAS/CONNECT access, exact iclink.sas include/version and required CRSP/IBES history for the remote branch.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R018, R019, I007
Evidence: E016, E017, E018, E038, E040, E043, E058, E059, E060, E061

Preparation / proposed procedure:

1. Obtain supported remote-session instructions and included-link code/output.
2. Verify authorized access and history for COMP.FUNDA, CRSP.CCMXPF_LINKTABLE and IBES.DETU_EPSUS.
3. Confirm whether this generated route is needed alongside the local analysts file.

Validation to perform later:

- Check link dates/types and forecast announcement windows against author definitions after access is confirmed.

### A014: Identify the opaque age file, its source/producer, CUSIP/BEGDAT definitions, coverage and intended consumer in the CODE2 tail.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R020, I005
Evidence: E024, E025, E026, E027, E063, E064

Preparation / proposed procedure:

1. Ask authors to identify q21e3b6b2f0bbe3e5 and the separate comp file, plus output destination and consumer.
2. Confirm age summary years and the fyear−9 rolling window; do not classify the branch optional without confirmation.

Validation to perform later:

- Verify CUSIP/date history, ten-year coverage and output mapping against the author recipe.

### A015: Obtain the supported cross-program handoffs from CODE1 c_report4 to all data.dta and from CODE2 to all data5.dta, including the exact column-name/case mapping consumed by CODE3.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I001, I009
Evidence: E013, E014, E027, E028, E034, E067, E068, E069, E070, E071

Preparation / proposed procedure:

1. Ask authors for missing producer/export stages or prepared-intermediate specifications, exact paths and columns/labels.
2. Confirm producer order and variables consumed by CODE3; do not invent renames or exports.
3. Confirm how the serialized DTA exposes mixed-case SAS names such as GDPGR/nAnalysts and whether it maps them to CODE3 lowercase gdpgr/nanalysts; do not invent a rename.
4. Confirm how mixed-case SAS names such as GDPGR and nAnalysts are serialized and whether they become the lowercase gdpgr/nanalysts consumed by Stata; do not invent a rename.

Validation to perform later:

- Compare the author-confirmed outputs with the next consumers and verify both handoff files exist before a future authorized run.
- Compare the actual author-confirmed exported column names and labels against CODE3 variable references; verify any normalization before a future authorized run.
- Compare exported variable names and labels against CODE3 references before a future authorized run.

### A016: Request appendix analysis programs/input mapping for OA1–OA9 and Figures OA1–OA2, or author confirmation those results are outside this package target.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I006
Evidence: E001, E030, E031, E032, E033, E072, E073, E074, E075, E076, E077, E078

Preparation / proposed procedure:

1. Ask for companion code/data and table/figure-to-entry-point mapping, including Census HHI, event windows, NETS pseudo-segments and 1,000 pseudo-date repetitions.
2. Do not reconstruct appendix analyses from result tables.

Validation to perform later:

- Confirm every targeted appendix result has a supplied or author-confirmed program and input path.

### A017: Have the environment owner verify approved SAS 9.4 TS1M8 runtime/import support and SAS/CONNECT/WRDS capability; the startup probe is unverified and gives no license conclusion.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_SAS, S_SASCONNECT
Evidence: E016, E043

Preparation / proposed procedure:

1. Verify SAS runtime and required DTA/XLS/CSV/TAB import engines with the environment owner.
2. Confirm authorized CONNECT/WRDS session capability without startup troubleshooting or author-program execution in this review.

Validation to perform later:

- After a separately authorized execution stage, retain SAS logs confirming required imports and RSUBMIT behavior.

### A018: Confirm the exact author institutional-ownership input, its 13F source/preparation, SHARES/SHROUT1 units and history; retain the code’s annual CUSIP aggregation and one-year lag unless the authors document otherwise. The TFN.S34 catalog/probe is only an unverified candidate.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R021
Evidence: E002, E041, E042, E079, E080, E081, E082, E083, E084, E085

Preparation / proposed procedure:

1. Ask the authors to identify the file at the io path, its source/vintage, preprocessing, units for SHARES and SHROUT1, CUSIP/FDATE definitions and coverage.
2. Confirm the yearly aggregation (sum within CUSIP/FDATE, then mean within CUSIP/year), CUSIP-to-CUSIP8 Compustat match and fyear=b.fyear+1 panel merge.
3. Do not substitute TFN.S34 or infer shares units/history solely from matching catalog field names.

Validation to perform later:

- Check the confirmed input’s fields, units, CUSIP/FDATE ranges and annual coverage before calculating ratio/ownership indicators.
- Verify aggregation keys and the one-year panel join against the author’s preparation notes before a future authorized run.

### A019: After the authors/environment owner confirms runtime roots, configure idd/pead/con and the literal Windows input, intermediate, staging and output locations. Preserve path roles and do not guess Windows-to-POSIX replacements.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I010
Evidence: E012, E014, E015, E022, E028, E029, E086, E087, E088

Preparation / proposed procedure:

1. Obtain confirmed runtime mappings for CODE1/CODE2 librefs idd, pead and con and literal locations including [redacted-path-96b0118604bf] and disclosure\raw data, its control variables/regression data subfolders, [redacted-path-1c24889e61f0], [redacted-path-5067a752f7ba], the political/product-market/age inputs and fiscal_quarter_price.
2. Confirm the intended staging and output destinations for all data.dta, all data5.dta, SAS WORK intermediates and the relative IDD_TABLE2.csv output.
3. Only after roots are confirmed, parameterize the librefs and path references while preserving the author file roles; do not convert drives or filenames by assumption.

Validation to perform later:

- Check each configured input and output path against the author-confirmed mapping and verify staging does not overwrite source inputs.
- At a separately authorized execution stage, confirm SAS WORK/intermediate paths and Stata’s IDD_TABLE2.csv destination from logs.


## Remaining issues and prerequisites

- I001 [unresolved; full_pipeline]: CODE1 creates c_report4 only in SAS WORK and does not export all data.dta; CODE2 imports that separate file and ends without writing all data5.dta; CODE3 reads all data5.dta. Neither handoff is packaged and the producer/consumer sequence is unsupported.
- I002 [unresolved; full_pipeline]: CODE1 expects CIK on segment rows to create CIK2 and join real_loca; the local customer-segment candidate lacks CIK and no author schema/merge supplies it. Do not guess an alias or join.
- I003 [unresolved; full_pipeline]: CODE2 reads `issue` with EQUITYFIN/DEBTFIN but neither supplied program produces or imports it; source/history are unspecified.
- I004 [unresolved; full_pipeline]: CODE2 creates remote IBES counts and downloads NumAnalysts_ann, but later consumes a separate local analysts file. The code does not show that they match or say whether the remote branch is needed.
- I005 [unresolved; full_pipeline]: CODE2 reads comp_2 and an opaque age file, creates age/stability and rolling-ten-year sale_std outputs, but does not merge them into reg12 or write the CODE3 input. Confirm branch scope and intended consumer before classifying as optional or editing.
- I006 [unresolved; full_pipeline]: The supplied Internet Appendix reports Tables OA1–OA9 and Figures OA1–OA2, including Census-HHI, event-window, additional capital-market/state-variable, Compustat/small-business, leverage/capital-structure, NETS pseudo-segment and random-date analyses. README identifies CODE3 only for Table 2; no appendix program/input mapping is supplied.
- I007 [unresolved; full_pipeline]: CODE2 depends on external [redacted-path-36c2397a51fe] and WRDS SAS/CONNECT signon; the include body and connection setup are outside the package. Current access is unverified, not proven absent.
- I008 [unresolved; full_pipeline]: CODE1 uses `sic` while the observed local COMP.FUNDA candidate has `sich`, not `sic`. The author extract may differ; confirm mapping before claiming compatibility or proposing edits.
- I009 [unresolved; full_pipeline]: CODE1/CODE2 create names such as RD_to_Sales, Intangible_to_AT, Advertise_to_sale, LnAT, ABROA_persistence, bigN, GDPGR and nAnalysts, while CODE3 refers to lowercase names such as rd_to_sales, lnat, abroa_persistence, bign, gdpgr and nanalysts. Stata names are case-sensitive, but the missing DTA producer/export step means any case normalization is undocumented and cannot be verified. Confirm the actual handoff schema before proposing renames.
- I010 [unresolved; full_pipeline]: CODE1/CODE2 bind idd, pead and con to literal Windows roots and also contain literal Windows file paths for inputs/intermediates. CODE3 reads all data5.dta by a Windows absolute path and writes IDD_TABLE2.csv relative to its working directory. The package supplies no confirmed runtime root, staging or output mapping; do not infer a POSIX replacement or conversion.
- R001 [undetermined]: Company customer-segment records used by CODE1 (GVKEY/CNMS/CTYPE/SALECS/SRCDATE) plus the CIK field consumed to form CIK2 and join the 10-K location table. Local candidate lacks CIK; compatible author schema/history is unestablished.
- R002 [undetermined]: Author-cleaned value_list keyed by CNMS with unreported identity labels, used to construct reported/unreported customer measures.
- R003 [undetermined]: IDD state status/event dates with State, begin-date and end-date fields used to calculate adoption/rejection timing.
- R004 [undetermined]: 10-K Header/locality input with CIK, filing date, state and location fields used to attach IDD status and firm headquarters. Existing SEC raw, SEC parsed and LM 10-X roots are candidates for deriving/checking header information only; no exact file schema, header preservation or history is verified.
- R005 [undetermined]: Compustat North America annual data used for CODE1 controls and CODE2 accounting/share inputs. CODE1 filters to FIC=USA and calculates HHI and adjusted-ROA/persistence at SIC/industry-year level. Preserve the full eligible U.S. industry-year population through those group calculations; do not screen early to the packaged Firm ID GVKEY list. Controls use t−1; code notes 1976–2013 Big N history. The exact remaining analysis-window limits and any later Firm ID screen are not specified.
- R006 [undetermined]: Annual inflation/GDP-deflator series read by CODE1 and merged by fiscal year; code labels World Bank as source.
- R007 [undetermined]: Prepared SDC SEO file with GVKEY/FYEAR/SEO; CODE2 shifts the event-year indicator to attach next-year SEO.
- R008 [undetermined]: Prepared SDC M&A file with GVKEY/FYEAR/MA; CODE2 shifts the event-year indicator to attach next-year M&A.
- R009 [undetermined]: State-year GDP growth input imported as GDPGR and joined at prior calendar year (fyear=year+1).
- R010 [undetermined]: State-year unemployment input; CODE2 averages Value by state/year and joins the prior calendar year.
- R011 [undetermined]: FICHHIdata_extend.txt input joined by ICODE300 and prior year to create FIC300HHI; authors say it was provided by Gordon Phillips.
- R012 [undetermined]: TNIC3HHIdata_extend.txt input with GVKEY/year/TNIC3HHI/TNIC3TSIMM joined by firm and prior year; authors say it was provided by Gordon Phillips.
- R013 [undetermined]: fic_data_extended.txt input with GVKEY/year/ICODE300 joined by firm and prior year; authors say it was provided by Gordon Phillips.
- R014 [undetermined]: Hand-cleaned political/election workbook, range 93-2011, with state/year/re/de/ind variables used in CODE2.
- R015 [undetermined]: Separate local prepared analysts file consumed by CODE2; needs GVKEY, FYENDDT (converted to year) and NANALYSTS. Its producer, period and relation to the remote IBES count output are unknown.
- R016 [undetermined]: Unproduced CODE2 `issue` input with GVKEY/FYEAR/EQUITYFIN/DEBTFIN read to construct a logistic propensity-score branch.
- R017 [undetermined]: Fiscal-quarter-price file read by CODE1 to compute CSHOQ×PRCCQ for quarter two and fill missing values from within firm-year quarters.
- R018 [undetermined]: CRSP/Compustat link history used remotely to map GVKEY to PERMNO by link type, used flag and valid fiscal year-end dates.
- R019 [undetermined]: IBES detailed US EPS forecasts used to count ANAlYS within the fiscal-year period from 11 months before fiscal year-end through fiscal year-end.
- R020 [undetermined]: Opaque age input read by CODE2 with CUSIP/BEGDAT to calculate firm age and SIC-year age/stability summaries; one summary filters 1994–2010 and sale_std uses a ten-year rolling interval. Source, coverage, producer and final consumer are unidentified.
- R021 [undetermined]: Institutional-ownership file read directly by CODE2 at the local io path. Required raw columns are SHARES, SHROUT1, CUSIP and FDATE. CODE2 computes shares/(SHROUT1×1,000,000), applies a >0.05 indicator, sums by CUSIP/FDATE, averages by CUSIP/year, matches Compustat on CUSIP8/year, then lags the resulting ownership measures into the firm-year panel. The author file’s source/preparation, units, coverage and relationship to the TFN.S34 candidate remain unverified.
- S_SAS [unverified]: Required for CODE1/CODE2. Frozen environment probe failed before initialization (TKELS/launch service); license and usable runtime are not established. CODE2 imports DTA/XLS/CSV/TAB formats.
- S_SASCONNECT [unverified]: CODE2 uses SIGNON/RSUBMIT and an external WRDS include; current CONNECT support and credentials are unverified.

## Review notes

- Expanded from the saved first checkpoint after reviewing all 26 frozen dependency IDs, all supplied code, author documents and Internet Appendix.
- No author SAS/Stata programs, regressions or dataset downloads were run. Checks were limited to frozen catalog metadata, bounded one-row helper probes, reused exact same-run probes and official BEA/BLS pages.
- One-row probes establish only observed columns/readability; neither probe rows nor catalog counts prove population/history coverage, entitlement or exact author-file compatibility.
- This incremental correction adds the actual unlisted CODE2 institutional-ownership input/aggregation, reuses exact same-run root metadata for SEC/parsed/LM filing candidates, adds conditional path configuration, and preserves the full eligible U.S. industry-year population for grouped Compustat calculations. No new probes, searches or execution were performed.
