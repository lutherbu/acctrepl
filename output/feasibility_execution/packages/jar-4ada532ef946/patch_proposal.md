# Patch proposal: jar-4ada532ef946

Non-GAAP Earnings Disclosure in Loss Firms

DOI: 10.1111/1475-679X.12216

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied Stata data construction and analysis workflow, retaining both packaged Perl text-search result branches, the two hand-collection rounds, the profitable-firm comparison, BCGW Table 6 Panel B, and all reported analysis sections. The packaged text-search CSVs are direct primary inputs; regenerating the revised output with the supplied Perl program is a separate conditional route because the numbered HTML working set is not supplied.

Entry points: `lv_jar_stata_code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 4/12216 - Non-GAAP-Earnings-Disclosure-in-Loss-Firms/lv2018-datasheet-and-code.zip",
      "sha256": "93d7739e052232fcd6794437db9a2f7b3f9ad0cff8bdd76420a116029bd140c5"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "dbbfecedae746b39024c500809444c34628eb698a4cf1892264903be4f665dbf"
}
```

## Proposed actions

### A_ITEMS8K: Confirm the exact SEC 8-K item-index route and the author filename-to-downloadId mapping before staging items8k.dta.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ITEMS8K, I_DATA_CONTRACTS
Evidence: E_DOC_WRDS_ITEMS, E_MAIN_ITEMS, E_PROBE_SEC, E_SEC_PUBLIC

Preparation / proposed procedure:

1. Check entitlement and usable coverage of the local WRDSSEC.ITEMS8K candidate for 2006–2014.
2. Confirm that nitem=="2.02", cik, fdate and fname follow the author’s expected definitions and that fname maps to the filing-text URL consumed by the separate Perl route.
3. If using a public SEC index instead, identify a documented permitted method to obtain the 2.02 item classification and reproduce the filename/downloadId join; the SEC index field list alone does not provide nitem.
4. Convert the confirmed rows to items8k.dta under the configured relative InFiles directory.

Validation to perform later:

- Verify the exported columns, types, 2006–2014 period, CIK/date key uniqueness after the code filter, and expected filename-to-downloadId match before Stata execution.

### A_IBES_PRODUCTS: Stage the separate unadjusted IBES actuals and summary files used by the main sample and ERC branches, checking measure-specific fields and period matches.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_IBES_ACTU, R_IBES_ACTU_GAAP, R_IBES_STATSUMU, R_IBES_STATSUMU_EPS, R_IBES_STATSUMU_GPS, I_DATA_CONTRACTS
Evidence: E_DOC_IBES_ACTU, E_DOC_IBES_STATS, E_MAIN_IBES_ACTU, E_MAIN_IBES_GAAP, E_MAIN_IBES_STATS, E_MAIN_IBES_EPS, E_MAIN_IBES_GPS, E_PROBE_IBES_ACTU, E_PROBE_IBES_STATS, E_DOC_IBES_GAAP, E_DOC_IBES_GPS, E_CAT_IBES_XEPS

Preparation / proposed procedure:

1. For EPS actuals and EPS summary files, the existing bounded probes support the column shapes of the ACTU_EPSUS and STATSUMU_EPSUS candidates; verify the required EPS/FPI and date coverage filters before staging those files.
2. For GAAP/GPS inputs, use the catalog-only ACTU_XEPSUS and STATSUMU_XEPSUS candidates as product leads. No row probes were run for them; do not transfer the EPSUS probe proof to these XEPSUS files.
3. Confirm that ACTU_XEPSUS provides quarterly MEASURE=GPS actuals and that STATSUMU_XEPSUS provides MEASURE=GPS/FPI=6 forecasts, including the author-required CUSIP or ticker and date fields, before preparing separate Stata files.
4. Apply the source filters on measure, periodicity and fiscal period only after confirming candidate values; retain announcement dates for actuals and the same-month STATPERS/FPEDATS filter for summaries.
5. Do not infer coverage from a single row or require original 2015/2016 byte snapshots solely from the datasheet retrieval dates.

Validation to perform later:

- For each prepared file, inspect its own product fields, types, measure/FPI/periodicity values and date coverage; verify sample and lagged-CUSIP/date or ticker/date joins before running author code.

### A_CRSP_MONTHLY: Stage both monthly stock returns/prices and the separate monthly value-weighted index return used in the full sample and Table 9 portfolio branch.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_CRSP_MONTHLY, R_CRSP_VWRETD, I_DATA_CONTRACTS
Evidence: E_DOC_CRSP, E_MAIN_CRSP, E_CRSP_UPDATE, E_PROBE_CRSP_MSF, E_PROBE_CRSP_MSIX

Preparation / proposed procedure:

1. Check the local CRSP MSF_V2 candidate for the required monthly history and map PERMNO/MthCalDt/MthPrc/MthRet to permno/date/prc/ret in a separate preparation copy.
2. Retain enough prior monthly observations for the three- and twelve-month return calculations and verify the 2015–2017 period used by the later portfolio extension; the exact needed extent depends on the sample dates and constructed group index.
3. For crspm_vwretd.dta, confirm that the local MSIX caldt and vwretd series matches the author definition, map caldt to date, and verify monthly coverage.
4. Do not treat the author’s historical retrieval dates as a requirement for byte-identical files when a compatible product and history are confirmed.

Validation to perform later:

- Check PERMNO/date keys, duplicate policy, monthly bounds and nonmissing prc/ret/vwretd in the prepared files before the Stata joins.

### A_QUARTERLY_AUX: Stage quarterly extensions and annual/quarterly Compustat histories used to construct future outcomes, firm age, volatility and sales growth.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_EXTRA_2016, R_EXTRA_2017, R_COMPAGE, R_XTRAVAR, I_DATA_CONTRACTS
Evidence: E_DOC_EXTRA, E_DOC_COMP_AGE_XTRA, E_DOC_XTRAVAR, E_LEADS_2016, E_LEADS_2017, E_AGE_XTRAVAR, E_PROBE_COMP_FUNDA, E_PROBE_COMP_FUNDQ

Preparation / proposed procedure:

1. Use local COMP.FUNDA/COMP.FUNDQ candidates only after confirming the applicable data-product route and exact date coverage.
2. Build separate inputs for the 2016 future-outcome extract, the 2017 12-quarter CFO extension, annual age history, and quarterly xtravar history. Retain the keys/fields consumed by the code.
3. For xtravar, verify coverage from 2002 through the estimation sample and the prior four-quarter values used for growth; for extra_data files, verify up to 12 future quarter leads after the 2006–2014 sample.
4. Do not infer minimum endpoints solely from retrieval dates; validate the code’s explicit 2002 lower filter and future-offset requirements.

Validation to perform later:

- Check required GVKEY/fiscal-year-quarter keys, U.S. firm/CIK/SIC fields and each source’s needed date window, then validate produced intermediate keys before merge.

### A_FUNDQ_LINK: Resolve the author’s merged quarterly input contract before constructing fundq.dta; the local COMP.FUNDQ candidate lacks lpermno.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_FUNDQ, I_FUNDQ_LINK
Evidence: E_MAIN_FUNDQ, E_PROBE_COMP_FUNDQ, E_CAT_FUNDQ, E_DOC_EXTRA

Preparation / proposed procedure:

1. Confirm whether the author-exported WRDS CRSP/Compustat Merged Fundamentals Quarterly input contains lpermno and the other columns used by the do-file, or obtain the exact documented author-prepared fundq.dta.
2. If a separate link-table export is proposed, obtain its documented date-effective link filters and output contract; do not infer a CCM merge recipe from the catalog link table alone.
3. Stage the compatible file as fundq.dta only after its identifiers, fiscal-quarter keys and required pre-sample lag history are established.

Validation to perform later:

- Verify lpermno, gvkey, datadate, fyearq, fqtr, CIK/SIC and all code-consumed accounting fields, plus the pre-2006 quarter history used by lags.

### A_ERDPORT1_CONTRACT: Resolve the prepared daily size-adjusted return file and its construction inputs for the event-return analysis.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ERDPORT1, I_ERDPORT1
Evidence: E_DOC_CRSP, E_DAILY_ADJUSTED, E_CAT_CRSP, E_PROBE_CRSP_DSF

Preparation / proposed procedure:

1. Confirm a compatible author-prepared erdport1.dta or the exact authorized WRDS SAS/SSH query and transformation that produces permno, date, ret and benchmark decret from the documented daily returns and NYSE/AMEX/NASDAQ breakpoints.
2. Confirm sample dates and required 61 lag / 241 future trading-observation coverage.
3. Do not use raw DlyRet or a monthly index as a substitute for the precomputed benchmark-adjusted return series without that source contract.

Validation to perform later:

- Check fields, PERMNO/date uniqueness, return definitions and event-window endpoints in the prepared file before running Step 1b.

### A_FF_FACTORS: Confirm a monthly four-factor source compatible with the author’s Table 9 joins and prepare it under ff_factors_4.dta.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_FF_MONTHLY, I_DATA_CONTRACTS
Evidence: E_DOC_EXTRA, E_FF_CALLS, E_PROBE_FF, E_FF_PUBLIC

Preparation / proposed procedure:

1. Confirm local FF.FACTORS_MONTHLY or the official Fama/French 3-factor and Momentum files cover the portfolio regression months with compatible units and month keys.
2. Check the historical definition expected by the 2017 author file; the official library documents a FIZ-to-CIZ source-format change beginning January 2025 and offers historical files.
3. Map the required date and mktrf, smb, hml, umd fields to the author’s Stata input without changing the regressors.

Validation to perform later:

- Verify all four factor fields, units, monthly key alignment and complete span of the joined portfolio regressions.

### A_BCGW_ACCESS: Obtain and verify the BCGW comparison file used by the supplied Table 6 Panel B branch.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_BCGW, I_BCGW_ACCESS
Evidence: E_DOC_BCGW, E_BCGW_PUBLIC, E_BCGW_BRANCH

Preparation / proposed procedure:

1. Use the author’s Manager Non-GAAP EPS Dataset page and its linked access form to determine delivery and access conditions.
2. Verify the delivered dataset corresponds to Bentley, Christensen, Gee and Whipple (JAR 2018), covers 2003–2016, and includes gvkey, datadate, MGR_NG_EPS and mgr_exclude (plus url as dropped by the source).
3. Convert to the Stata input bcgw_2018_ng_data_2003to2016.dta after confirming its period and keys.

Validation to perform later:

- Check fields, coverage, GVKEY/date keys and the resulting join cardinality before the BCGW branch runs.

### A_RBOUNDS_SETUP: Add a compatible rbounds Stata command for the supplied sensitivity-analysis branches.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_RBOUNDS
Evidence: E_RBOUNDS_CALLS, E_SOFT_RBOUNDS, E_STATA_COMMANDS

Preparation / proposed procedure:

1. Obtain and install the rbounds Stata ado package through an authorized Stata package source.
2. Make the command discoverable on the Stata adopath used by the execution copy.

Validation to perform later:

- Run which rbounds in Stata 18 and confirm that it resolves to the intended command before running Table 8.

### A_PATHS: Create a configured execution copy with relative paths and the package helper directory first on the Stata adopath.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_PATHS, SW_STATA_ADOS
Evidence: E_MAIN_PATH, E_STATA_COMMANDS, E_SAMPLE_PRODUCERS

Preparation / proposed procedure:

1. Copy the supplied package to a separate execution directory with coherent InFiles, OutFiles and EDGAR directories.
2. In the copy only, set the root global to a relative root such as "."; convert all path separators to forward slashes and normalize Infiles/Outfiles spellings to InFiles/OutFiles consistently across producers and consumers.
3. Prepend the bundled helper directory with adopath ++ "ado" so the supplied cluster2, logit2, psmatch2 and konfound files are found ahead of other versions.
4. Keep executable configuration paths relative or under [redacted-path-1843e3452e62]; do not set the root to the Dropbox workspace path.

Validation to perform later:

- From the configured execution directory, run harmless Stata file-open checks using a relative forward-slash path, then use which to verify the four packaged ADO paths and the three invoked helpers.
- After all inputs and software are ready, launch the complete driver in Stata batch mode from the configured copy; retain all analysis branches and inspect generated output/logs for missing inputs.

### A_RUN_PROCEDURE: Use the complete supplied Stata driver after the input and software actions close their current gaps.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_PATHS
Evidence: E_MAIN_PATH, E_MAIN_FUNDQ, E_TEXT_HANDOFF, E_BCGW_BRANCH, E_RBOUNDS_CALLS, E_CRSP_UPDATE, E_FF_CALLS, E_FINAL_OUTPUT

Preparation / proposed procedure:

1. Complete the relative-path configuration and stage the inputs under the named directories.
2. Ensure Stata resolves the package ADOs and rbounds before execution; if regenerating text-search output, also stage the numbered HTML files and File::Slurp.
3. Run lv_jar_stata_code.do in Stata 18 batch mode from the configured copy so Steps 1–12, both hand-collected rounds, profit comparison, BCGW Panel B, ERC, sensitivity and portfolio branches run in source order.

Validation to perform later:

- Confirm that every expected producer output exists before its next consumer, both search CSV joins use the generated downloadId mapping, all analysis branches complete, and lv_jar_dataset.dta is produced with the documented share fields.


## Remaining issues and prerequisites

- I_DATA_CONTRACTS [unresolved; full_pipeline]: Named WRDS products and local SAS catalog candidates remain unverified for exact measures, source period, coverage and identifier mappings. The public SEC index does not itself establish the authors’ nitem==2.02 index. EPS actual/summary candidates have bounded column probes; the catalog also lists non-EPS XEPSUS actual/summary candidates for the GPS inputs, but no probes or GPS/FPI/date-coverage checks confirm them. Monthly return/factor vintages and all lead/lag history need validation.
- I_FUNDQ_LINK [unresolved; full_pipeline]: The quarterly main source requires lpermno, but local COMP.FUNDQ has no lpermno in the bounded field probe. A CRSP/Compustat link-table candidate exists, yet the package does not document the author’s link filters/producer or resulting fundq.dta contract.
- I_ERDPORT1 [unresolved; full_pipeline]: The supplied Stata driver consumes precomputed daily size-adjusted returns with ret and decret and creates forward windows through 240 trading observations. Local raw CRSP daily returns do not establish the author’s NYSE/AMEX/NASDAQ breakpoint-adjustment product or its exact producer.
- I_BCGW_ACCESS [unresolved; full_pipeline]: The author’s dataset page identifies the BCGW Manager Non-GAAP EPS dataset and links to a form, but the delivered file, fields, period coverage and access conditions have not been verified.
- I_PATHS [preparation; full_pipeline]: The do-file hard-codes [redacted-path-beeb72543b10], uses Windows backslash separators and alternates InFiles/Infiles and OutFiles/Outfiles. The Stata path probe showed forward slashes work and backslashes fail in this environment; configure a relative execution root and consistent path casing on a separate copy.
- R_ITEMS8K [undetermined]: Author’s items8k input used to identify earnings-release 8-Ks: CIK, filing date, nitem (filter 2.02), and fname for the later URL/downloadlist mapping. The code sample is 2006–2014. The local SEC catalog candidate has these columns, but local row sampling does not prove period/filter/URL compatibility.
- R_IBES_ACTU [undetermined]: Unadjusted actual quarterly EPS input, with CUSIP, period end, value, announcement date and ticker; code drops blank/zero CUSIP and missing values/dates and joins by CUSIP/date.
- R_IBES_ACTU_GAAP [undetermined]: Separate unadjusted GAAP EPS actuals input (IBES measure GPS), keyed by CUSIP and period end with actual value; used for agreement checks, ERC surprises and forecast/actual comparisons.
- R_IBES_STATSUMU [undetermined]: Unadjusted analyst coverage summary statistics for EPS/FPI 6; Stata uses NUMEST after requiring same calendar month of STATPERS and FPEDATS and joins on CUSIP/date.
- R_IBES_STATSUMU_EPS [undetermined]: Unadjusted EPS consensus forecasts for ERC tests: ticker, STATPERS, FPEDATS and MEDEST; code joins at ticker and quarter-end.
- R_IBES_STATSUMU_GPS [undetermined]: Separate unadjusted GAAP EPS consensus (GPS/FPI 6) for ERC tests; code needs median estimates matched by ticker and fiscal period end.
- R_FUNDQ [undetermined]: The author’s CRSP/Compustat merged quarterly input. Main construction uses GVKEY/date/fiscal-quarter keys, CIK, SIC, lpermno, U.S. flag, Compustat statement/earnings/price fields and lags. Sample bounds are 2006–2014; pre-sample quarterly history is consumed for lags and prior announcement checks.
- R_CRSP_MONTHLY [undetermined]: Monthly CRSP stock returns and prices. Step 1 uses prc/ret keyed by permno/date to calculate buy-and-hold checks; the Table 9 portfolio branch separately appends crspm_2015_2017.dta before monthly portfolio returns.
- R_CRSP_VWRETD [undetermined]: Monthly value-weighted return including distributions, author input crspm_vwretd.dta; code joins by date to construct 3- and 12-month market returns.
- R_EXTRA_2016 [undetermined]: Author’s additional quarterly data file used to attach one-to-twelve-quarter future operating, cash-flow, EPS and share-count outcomes; code drops records before fiscal year/date 2002.
- R_EXTRA_2017 [undetermined]: Author’s later quarterly merged input, used specifically to calculate up-to-12-quarter future operating cash flow for additional tests; code drops pre-2002 observations.
- R_ERDPORT1 [undetermined]: Author’s daily size-adjusted event-return file. Code expects permno, date, raw ret and benchmark return decret, and creates one-, 60-, 120- and 240-trading-observation forward abnormal returns plus lags.
- R_COMPAGE [undetermined]: Annual Compustat input used to derive firstyear by GVKEY and firm age; requires annual history through the analysis sample.
- R_XTRAVAR [undetermined]: Quarterly Compustat history used for earnings volatility over prior 2–8 quarters and sales growth; source code retains U.S. firms and drops fiscal/data years before 2002.
- R_FF_MONTHLY [undetermined]: Four monthly factors used in Table 9 regressions: mktrf, smb, hml and umd, joined by year/month to the portfolio return series.
- R_BCGW [undetermined]: Separate BCGW comparison dataset for Table 6 Panel B, keyed by GVKEY/datadate and used with MGR_NG_EPS and mgr_exclude. Expected author range is 2003–2016.
- SW_RBOUNDS [preparation_required]: The supplied Table 8 sensitivity branches invoke rbounds. The Stata 18 command lookup did not find it; add a compatible Stata ado package and verify the entry before running those branches.

## Review notes

- The EDGAR/downloadlist.txt file was treated as data. Only the frozen inventory size/hash were used; no line contents were read as narrative.
- The supplied Perl source was statically inspected from the actual package file even though the frozen source reader did not cache it. A hashed JSON records its local HTML input/output interface. The HTML presentation copy is not treated as a second program.
- The hand-collected DTA files and both text-search CSV outputs are accepted as author-prepared primary inputs. This avoids making the historical collection/download path a mandatory dependency where the Stata driver consumes supplied outputs.
- The final lv_jar_dataset.dta is a sharing/output dataset with identifiers, text-search and hand-coded variables; its probe and variable list do not support a separate analysis-only scope that reproduces the paper analyses.
- Source and software checks were static or bounded metadata probes only. No author code, model regressions, dataset imports into author software, installation or downloads were performed. execution_verified remains false.
- Optional, unselected Perl regeneration lead: static inspection shows the supplied program reads numbered local HTML via File::Slurp and writes output_new.csv; the Perl runtime is present and File::Slurp is absent. The primary Stata workflow directly consumes the two verified packaged text-search CSVs, so the Perl module and HTML handoff are not mandatory for this target. If the regeneration route is selected later, stage the numbered HTML files in its working directory, prepare File::Slurp, and verify the output_new.csv File_Number/word schema against the Stata download IDs.
