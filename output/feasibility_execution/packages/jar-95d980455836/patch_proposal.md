# Patch proposal: jar-95d980455836

Switching From Incurred to Expected Loan Loss Provisioning: Early Evidence

DOI: 10.1111/1475-679X.12354

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied workflow: Stata daily-return construction, multi-file merge, sample/variable construction, discretionary LLP and winsorized dataset; plus the two supplied MATLAB risk/event-return functions and their required handoffs. The release does not supply the full paper's regression scripts.

Entry points: `LOS_Main.do`, `Risk_Ind_calc.m`, `StockABR_IFRS9_calc.m`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 3/12354 - Switching-From-Incurred-to-Expected-Loan-Loss-Provisioning-Early-Evidence/los-datasheet-code-and-identifiers.zip",
      "sha256": "3e043b7e8f8d4374e74c113180fae19686a764a9873122e019d202d36e7a343b"
    },
    {
      "path": "JAR-Volume 59/Issue 3/12354 - Switching-From-Incurred-to-Expected-Loan-Loss-Provisioning-Early-Evidence/los-online-appendix.pdf",
      "sha256": "a8effd2c31a1e99c4f67b72580a030cc59c780a671fea8dab490be10951ad694"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "a2da433e4c4e8f85daa4c3955ca20bf7c80c39d4728d64ad9d9cc9bfcf33ca21"
}
```

## Proposed actions

### A-DAILY-PRICE-ROUTE: Resolve whether the readable Datastream primary-quote product is the intended route to Close_price_LLP.dta or whether the author-prepared DTA must be supplied. Preserve the do-file's lagged-return definition and do not infer the annual event selection.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-CLOSE-DAILY, I-DAILY-FYEAR-KEY
Evidence: E-DS-DATASTAGE, E-DAILY-PRICE-PROBE, E-DO-DAILY-INPUT, E-DO-PRET-RETURN-MERGE

Preparation / proposed procedure:

1. Confirm the product and provide the InfoCode-to-ISIN/Bank_ID crosswalk, source field mapping for id/day/isin/Close_price, price units, and required fiscal-year/report-date fields; otherwise provide the exact author-prepared Close_price_LLP.dta.
2. Specify how daily rows become the one-row-per-ISIN-FYear past_ret_fyear_end.dta required by the later 1:1 merge, including the filing/fiscal-year selection rule and treatment of multiple reports.
3. Retain at least 250 prior business-calendar price observations for each required return date; identify the required paper years and bank population before preparing the panel.

Validation to perform later:

- Before any author-code run, verify the chosen input's identifier/date/price columns, product mapping, needed historical span, and unique annual ISIN-FYear output keys with bounded metadata/schema checks.
- Compare the resulting annual row-selection rule with the author-specified procedure; do not derive or alter the research sample independently.

### A-ACCOUNTING-ROUTE: Identify the exact Accounting.dta input and its schema. The readable Worldscope annual table is only a nearby local candidate and is not credited as a compatible substitute for the authors' Datastream accounting file.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-ACCOUNTING
Evidence: E-DS-DATASTAGE, E-WORLDSCOPE-ACCOUNT-PROBE, E-DO-MERGE-ACCOUNTING

Preparation / proposed procedure:

1. Provide the author-prepared Accounting.dta, or confirm the local Worldscope candidate only after supplying a mapping from code/year_/ITEM5350 to the author identifiers, FYear, required fields, units, years, and bank sample.
2. Document how loan-loss provisions and allowance values that were historically completed from Capital IQ and statements are represented in the actual prepared DTA; do not reconstruct them from an unverified product.

Validation to perform later:

- Check the author-confirmed master input has usable ISIN and FYear fields, nonmissing FYear under the code's filter, and the documented fields required by the complete merge/transform chain.
- Keep vendor-history claims separate from current field and sample compatibility; the one-row Worldscope probe establishes only readability and three column names.

### A-DTA-INPUTS-AND-SCHEMAS: Obtain the nine missing author-prepared DTA handoffs and their codebooks/producers. These are direct inputs to LOS_Main.do beyond Close_price_LLP.dta and Accounting.dta; the datasheet's historical vendor/source descriptions are not a substitute for the prepared files or field schemas.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-RISK-FF, R-STOCK-ABR, R-CDS-ABS, R-REG-SUPV, R-SOV-CDS, R-LOAN-STAGES, R-LLA-STAGES, R-ECL-BANK, R-FTA-EVENT, I-DTA-SCHEMAS
Evidence: E-DO-MERGE-RISK, E-DO-MERGE-STOCK-ABR, E-DO-MERGE-CDS, E-DO-MERGE-SUPV, E-DO-MERGE-SOV-CDS, E-DO-MERGE-LOAN-STAGES, E-DO-MERGE-LLA-STAGES, E-DO-MERGE-ECL, E-DO-MERGE-FTA, E-DTA-SCHEMA-GAP, E-PACKAGE-INVENTORY

Preparation / proposed procedure:

1. Provide Risk_FF.dta, Stock_ABR.dta, CDS_ABS.dta, Regl_Supv_index.dta, Sov_CDS.dta, Loan_Stages.dta, LLA_Stages.dta, ECL_Bank.dta, and FTA_event_study.dta from this same package variant, or provide each actual producer and its source/input contract.
2. For every DTA, document field types/units, identifier and country mappings, fiscal-year coverage, and ownership of the fields consumed after all merges; preserve the source code's exact ISIN-FYear, ISIN, and Country-FYear keys.
3. Confirm right-side key uniqueness for each declared 1:1 or m:1 merge, plus downstream fields including risk, CABR, supervisory, sovereign-CDS, stage, treatment, and event-study values without assigning fields to unseen inputs by guess.
4. Keep data construction within the author-supported workflow. Do not rebuild data from historical sources independently or replace missing prepared inputs with synthetic rows.

Validation to perform later:

- After the author inputs are available, use bounded format-aware metadata checks to confirm each DTA opens and contains its documented keys/fields; then check declared key cardinality and coverage before an authorized full run.
- Confirm FTA_event_study.dta is located under the same project-root-relative Stata/Raw_data directory used by the other inputs.

### A-SAMPLE-ISIN-FLAG: Use the supplied final-sample ISIN workbook only as the identifier source for the sample_restriction.dta handoff; it does not supply the analysis panel.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R-SAMPLE-RESTRICTION
Evidence: E-DS-ISIN-LIST, E-XLSX-INSPECTION, E-DO-MERGE-SAMPLE

Preparation / proposed procedure:

1. Prepare a one-row-per-supplied-ISIN sample_restriction.dta with the documented inclusion indicator ResSample=1, preserving workbook ISIN text and the author's chosen Stata string conventions.
2. Place this DTA beside the other prepared files under Stata/Raw_data; do not represent the workbook as a regression panel or the missing Excel benchmark workbook.

Validation to perform later:

- Check the complete workbook identifiers are read without truncation or normalization mismatches and are unique at the m:1 ISIN merge key.
- Confirm the author-coded sample restriction keeps exactly the provided included-bank identifiers after the later ResSample==1 condition; do not add a separate zero/omitted-ID rule without evidence.

### A-MAT-PRODUCERS-AND-CONVERSIONS: Restore the author-provided Stata-to-MAT producers, MATLAB caller/driver, function arguments, and MAT/text-to-DTA conversions in producer-before-consumer order. Keep the function's positional and output contracts explicit until the missing mappings are documented.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-RET-STOCK-MAT, R-STOCK-ABR-MAT, R-RISK-FF, R-STOCK-ABR, I-MAT-HANDOFFS, I-MAT-ROWS-COMPAT
Evidence: E-RISK-COLUMN-CONTRACT, E-RISK-FWD-WINDOW, E-RISK-OUTPUT, E-ABR-COLUMN-CONTRACT-A, E-ABR-COLUMN-CONTRACT-B, E-ABR-WINDOW-ARGS, E-ABR-OUTPUT, E-DO-DATA-USES-RISK, E-DO-DATA-USES-ABR, E-MAT-WRITEMATRIX-DOC, E-RISK-ROWS-CALL, E-ABR-ROWS-CALL

Preparation / proposed procedure:

1. Provide the producer that creates Ret_Stock.mat and specify row sort, types, key/date fields, filing-date marker, source returns, within-bank forward windows, exact fwd_d value, and any required data before the first reported event.
2. Provide the producer for StockABRIFRS9calc.mat and its exact eleven-column order/types, daily stock/factor/risk-free coverage, event markers, row order, and W_est/W_est_end/W_event caller values. Source comments use 100/5/3 only when callers pass NaN; no call site in this package supplies them.
3. Provide the actual caller/output filenames. Risk_Ind_calc returns [ISIN,FYear,ReportDate,IV,IR,TR] and calls writematrix without a filename; specify how event rows and field names map into the one-row-per-ISIN-FYear Risk_FF.dta contract, including whether/why TR maps to TRisk.
4. Specify the supported mapping from StockABR_IFRS9_calc's [BankID,FYear,ABR] returned positions to the ISIN-FYear Stock_ABR.dta key and downstream CABR field, and supply the DTA conversion path without guessing an ISIN crosswalk.
5. Confirm the intended MATLAB release and whether its supported environment resolves rows(table); preserve the source call unless an author-approved compatible alternative is documented.

Validation to perform later:

- Before converting outputs, compare actual function outputs and table field order against the documented Stata merge keys, variable names, numeric/string types, and one-row-per-key requirements.
- Confirm all forward and event windows have the necessary within-bank daily history and that output rows correspond to the author-specified events and fiscal years.
- Use a non-estimator `which rows`/version check in the intended MATLAB environment to verify function resolution; do not call either study function during this assessment.

### A-CDS-EXCEL-PRODUCERS: Restore the missing CDS/benchmark production materials and their output mapping without assuming that the Excel benchmark calculation and CDS_ABS.dta are the same stage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-CDS-ABS, R-BENCHMARK-EXCEL, I-CDS-BENCHMARK-PRODUCERS
Evidence: E-DS-THIRD-MATLAB, E-DS-EXCEL-BENCHMARK, E-DO-MERGE-CDS, E-XLSX-INSPECTION

Preparation / proposed procedure:

1. Provide the absent CDSABD_IFRS9_calc.m, the actual benchmark-CDS calculation workbook with formulas/source ranges, the cited main-paper Appendix A method, and all required manual input/crosswalk sheets or prepared series.
2. Document the producer, row unit, output fields, dates, identifiers, and conversion steps for CDS_ABS.dta; explicitly state whether it consumes either missing CDS/Excel stage or whether these are separate branches.
3. Confirm the intended Excel release and workbook refresh/manual calculation procedure; retain formulas and any source ranges without replacing the workbook with the supplied identifier list.

Validation to perform later:

- After the missing materials are supplied, verify the workbook's source ranges/formulas and each producer output against the documented CDS_ABS.dta ISIN-FYear contract using bounded metadata checks only before an authorized run.
- Do not infer a benchmark formula, producer, or license barrier from the absent file alone.

### A-INCOME-VOL-TSEGEN: Resolve the exact extension command and source of NI_TA before the volatility construction is run.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-INCOME-VOL-INPUT, S-TSEGEN, R-ACCOUNTING
Evidence: E-DO-INCOME-VOL-LINE, E-TSEGEN-PROBE, E-DO-MERGE-ACCOUNTING

Preparation / proposed procedure:

1. Identify and configure the author-compatible tsegen command/version on the intended Stata adopath; the current exact `which tsegen` check returned 111 only on checked paths.
2. Document which prepared DTA supplies NI_TA and its definition/units, or provide the author-specified source producer; do not substitute the later NI variable or invent an NI_TA formula.
3. For every retained FYear, preserve the current plus four prior panel observations used in rowsd(L(0/4).NI_TA,5), and confirm the author sample's needed construction history.

Validation to perform later:

- In the intended Stata environment, verify the exact tsegen command is resolved with `which tsegen` and its version/source is recorded before any author-code run.
- Check NI_TA exists with the documented definition before the line 141 construction and that the required five-period window is available for retained years.

### A-FILTER-SPEC-CLARIFICATION: Resolve the actual imported variable namespace and intended sample-filter values before proposing a source change. The source order alone does not determine whether a bare filter name is absent, an exact existing variable, or a unique abbreviation of a longer imported name.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-FILTER-ORDER
Evidence: E-DO-SAMPLE-FILTER, E-DO-DERIVED-FIELDS, E-DTA-SCHEMA-GAP, E-PACKAGE-INVENTORY

Preparation / proposed procedure:

1. Obtain the schemas/codebooks for the merged inputs and the Stata setup or documented runtime setting that establishes whether variable abbreviations are enabled at the filter. Determine how LLP, NII, TLoan, TSec, and SizeAsset resolve at line 100 and whether each exact short name is already present before its later gen statement.
2. Ask the author to confirm the intended values and sample-membership rule for those five filter terms. Preserve the current filter, generated definitions, and sample until that mapping is established.
3. If the confirmed namespace and author rule require a correction, specify the smallest working-copy change that preserves the intended inclusion rule; do not infer a rename, move the filter, or replace scientific definitions from the ordering alone.

Validation to perform later:

- Before a future authorized run, verify each filter token's resolution against the documented input schemas and Stata varabbrev setting, and verify each later gen targets an unoccupied exact name or has an author-confirmed resolution.
- Compare the corrected filter logic to the author-confirmed sample rule; do not use a candidate prefix match as proof that the supplied dataset contains that alias or that the sample is preserved.

### A-MATLAB-ENVIRONMENT: Verify the MATLAB runtime/release and required Statistics and Machine Learning Toolbox functions in the intended environment; no MATLAB call or installation was attempted in this assessment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S-MATLAB, S-MATLAB-STATISTICS-TOOLBOX
Evidence: E-DS-EXCEL-BENCHMARK, E-ABR-REGRESS-CALL, E-MAT-REGRESS-DOC, E-MAT-NAN-TOOLBOX-DOC

Preparation / proposed procedure:

1. Confirm the author's MATLAB release and verify installed/toolbox availability using `version`, `ver`, and non-estimator `which` checks for regress, nanstd, nanmean, and nansum.
2. Verify `rows` function resolution separately and preserve existing author calls until its compatibility is established; do not substitute modern alternatives without checking sample-sensitive behavior.

Validation to perform later:

- Record MATLAB and toolbox version/availability in the future run log before processing any study MAT input.
- Limit pre-run checks to version/which inspection; do not invoke either study function as a probe.

### A-EXCEL-ENVIRONMENT: Verify the specified Excel environment only after the benchmark workbook and its calculation procedure are supplied.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S-EXCEL, R-BENCHMARK-EXCEL
Evidence: E-DS-EXCEL-BENCHMARK, E-XLSX-INSPECTION

Preparation / proposed procedure:

1. Confirm the author-intended Excel version, workbook calculation mode, manual refresh steps, and external linked source ranges for the benchmark workbook.
2. Do not assume LibreOffice or another spreadsheet engine reproduces the author's workbook calculations until compatibility is documented.

Validation to perform later:

- After receiving the workbook, perform a static inventory of formulas, ranges, links, and sheet names without recalculating or refreshing formulas during this assessment.

### A-TSEGEN-ENVIRONMENT: Locate or configure the author-compatible tsegen extension in the future Stata environment; the current checked adopath lookup is not a license or system-wide absence finding.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S-TSEGEN
Evidence: E-TSEGEN-PROBE, E-DO-INCOME-VOL-LINE

Preparation / proposed procedure:

1. Once the author-compatible distribution/version is identified, configure its directory on the intended Stata adopath or supply the required package through normal authorized setup.
2. Keep the package installation and study-code execution outside this assessment; do not infer access denial from the current `which` result.

Validation to perform later:

- Before an authorized run, confirm Stata resolves the exact `tsegen` command with `which tsegen` and record its source/version.

### A-RELATIVE-PATH-SETUP: In a separate working copy, change the eleven absolute /Stata/Raw_data/ input paths to Stata/Raw_data/ and run from a host-visible, writable project root that contains LOS_Main.do and Stata/Raw_data/. The existing FTA_event_study.dta path already uses this relative layout and needs no text edit.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I-PATH-SETUP
Evidence: E-DO-DAILY-INPUT, E-DO-MERGE-ACCOUNTING, E-DO-MERGE-RISK, E-DO-MERGE-STOCK-ABR, E-DO-MERGE-CDS, E-DO-MERGE-SUPV, E-DO-MERGE-SAMPLE, E-DO-MERGE-SOV-CDS, E-DO-MERGE-LOAN-STAGES, E-DO-MERGE-LLA-STAGES, E-DO-MERGE-ECL, E-DO-MERGE-FTA

**Proposed edit:** `LOS_Main.do:15–15`
Source SHA-256: `333b2a81cdeda0c75ddef3a3aa47e4e56da9d44dffab8b3ca1f47069a26a7b43`

Use the configured project root's Stata/Raw_data directory consistently instead of the absolute /Stata path.

Current text:
```
use "[redacted-path-775e63b665ac]", clear
```

Proposed replacement:
```
use "Stata/Raw_data/Close_price_LLP.dta", clear
```

**Proposed edit:** `LOS_Main.do:37–37`
Source SHA-256: `333b2a81cdeda0c75ddef3a3aa47e4e56da9d44dffab8b3ca1f47069a26a7b43`

Use the configured project root's Stata/Raw_data directory consistently instead of the absolute /Stata path.

Current text:
```
use "[redacted-path-508f040d24f9]", clear
```

Proposed replacement:
```
use "Stata/Raw_data/Accounting.dta", clear
```

**Proposed edit:** `LOS_Main.do:49–49`
Source SHA-256: `333b2a81cdeda0c75ddef3a3aa47e4e56da9d44dffab8b3ca1f47069a26a7b43`

Use the configured project root's Stata/Raw_data directory consistently instead of the absolute /Stata path.

Current text:
```
merge 1:1 ISIN FYear using "/Stata/Raw_data/Risk_FF.dta"
```

Proposed replacement:
```
merge 1:1 ISIN FYear using "Stata/Raw_data/Risk_FF.dta"
```

**Proposed edit:** `LOS_Main.do:54–54`
Source SHA-256: `333b2a81cdeda0c75ddef3a3aa47e4e56da9d44dffab8b3ca1f47069a26a7b43`

Use the configured project root's Stata/Raw_data directory consistently instead of the absolute /Stata path.

Current text:
```
merge 1:1 ISIN FYear using "/Stata/Raw_data/Stock_ABR.dta"
```

Proposed replacement:
```
merge 1:1 ISIN FYear using "Stata/Raw_data/Stock_ABR.dta"
```

**Proposed edit:** `LOS_Main.do:59–59`
Source SHA-256: `333b2a81cdeda0c75ddef3a3aa47e4e56da9d44dffab8b3ca1f47069a26a7b43`

Use the configured project root's Stata/Raw_data directory consistently instead of the absolute /Stata path.

Current text:
```
merge 1:1 ISIN FYear using "/Stata/Raw_data/CDS_ABS.dta"
```

Proposed replacement:
```
merge 1:1 ISIN FYear using "Stata/Raw_data/CDS_ABS.dta"
```

**Proposed edit:** `LOS_Main.do:64–64`
Source SHA-256: `333b2a81cdeda0c75ddef3a3aa47e4e56da9d44dffab8b3ca1f47069a26a7b43`

Use the configured project root's Stata/Raw_data directory consistently instead of the absolute /Stata path.

Current text:
```
merge m:1 ISIN FYear using "/Stata/Raw_data/Regl_Supv_index.dta"
```

Proposed replacement:
```
merge m:1 ISIN FYear using "Stata/Raw_data/Regl_Supv_index.dta"
```

**Proposed edit:** `LOS_Main.do:69–69`
Source SHA-256: `333b2a81cdeda0c75ddef3a3aa47e4e56da9d44dffab8b3ca1f47069a26a7b43`

Use the configured project root's Stata/Raw_data directory consistently instead of the absolute /Stata path.

Current text:
```
merge m:1 ISIN using "/Stata/Raw_data/sample_restriction.dta"
```

Proposed replacement:
```
merge m:1 ISIN using "Stata/Raw_data/sample_restriction.dta"
```

**Proposed edit:** `LOS_Main.do:74–74`
Source SHA-256: `333b2a81cdeda0c75ddef3a3aa47e4e56da9d44dffab8b3ca1f47069a26a7b43`

Use the configured project root's Stata/Raw_data directory consistently instead of the absolute /Stata path.

Current text:
```
merge m:1 Country FYear using "/Stata/Raw_data/Sov_CDS.dta"
```

Proposed replacement:
```
merge m:1 Country FYear using "Stata/Raw_data/Sov_CDS.dta"
```

**Proposed edit:** `LOS_Main.do:79–79`
Source SHA-256: `333b2a81cdeda0c75ddef3a3aa47e4e56da9d44dffab8b3ca1f47069a26a7b43`

Use the configured project root's Stata/Raw_data directory consistently instead of the absolute /Stata path.

Current text:
```
merge m:1 ISIN FYear using "/Stata/Raw_data/Loan_Stages.dta"
```

Proposed replacement:
```
merge m:1 ISIN FYear using "Stata/Raw_data/Loan_Stages.dta"
```

**Proposed edit:** `LOS_Main.do:84–84`
Source SHA-256: `333b2a81cdeda0c75ddef3a3aa47e4e56da9d44dffab8b3ca1f47069a26a7b43`

Use the configured project root's Stata/Raw_data directory consistently instead of the absolute /Stata path.

Current text:
```
merge m:1 ISIN FYear using "/Stata/Raw_data/LLA_Stages.dta"
```

Proposed replacement:
```
merge m:1 ISIN FYear using "Stata/Raw_data/LLA_Stages.dta"
```

**Proposed edit:** `LOS_Main.do:89–89`
Source SHA-256: `333b2a81cdeda0c75ddef3a3aa47e4e56da9d44dffab8b3ca1f47069a26a7b43`

Use the configured project root's Stata/Raw_data directory consistently instead of the absolute /Stata path.

Current text:
```
 merge m:1 ISIN using "/Stata/Raw_data/ECL_Bank.dta"
```

Proposed replacement:
```
 merge m:1 ISIN using "Stata/Raw_data/ECL_Bank.dta"
```

Preparation / proposed procedure:

1. Create a separate project working directory with LOS_Main.do at its root and the supplied inputs in Stata/Raw_data/; keep generated intermediates and LOS_main.dta in that working root.
2. Run the batch command with that working root as the current directory. Use relative paths in the source, and verify that the chosen host-visible directory exists and is writable before an authorized run.
3. Do not embed the Dropbox workspace's absolute path in executable configuration; the host wrapper maps the caller's current directory and supports relative or [redacted-path-ef244b0967bd] paths.

Validation to perform later:

- Statically review the working-copy do-file to confirm all source paths resolve under the same project root and every generated filename uses that root's current directory.
- In the future run environment, verify the project root and Stata/Raw_data/ inputs are visible and the root is writable before invoking `stata -b do LOS_Main.do`.

### A-FINAL-SAVE-OPTION: Correct the final Stata save option in a separate working copy while preserving the LOS_main.dta output name.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I-FINAL-SAVE-OPTION
Evidence: E-DO-FINAL-SAVE, E-STATA-SAVE-DOC

**Proposed edit:** `LOS_Main.do:387–387`
Source SHA-256: `333b2a81cdeda0c75ddef3a3aa47e4e56da9d44dffab8b3ca1f47069a26a7b43`

Stata save overwrites with replace; clear is a use option. Preserve the named output and allow a repeat batch run to overwrite it deliberately.

Current text:
```
save LOS_main.dta, clear
```

Proposed replacement:
```
save LOS_main.dta, replace
```

Preparation / proposed procedure:

1. Replace clear with replace on the final save line in the working copy; keep clear on use statements unchanged.
2. Run from the configured writable project root so the output file is created there.

Validation to perform later:

- Statically confirm the final command reads `save LOS_main.dta, replace` and that no other source statement changed.
- In a future authorized batch run with all dependencies resolved, confirm LOS_main.dta is written to the project root.

### A-ORDERED-RUN-PROCEDURE: Producer-before-consumer order for a future run after the missing author handoffs, filter namespace/sample-definition question, and other listed prerequisites are resolved. This is a procedure proposal only; no author program is run here.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I-PATH-SETUP, I-DAILY-FYEAR-KEY, I-MAT-HANDOFFS, I-CDS-BENCHMARK-PRODUCERS, I-INCOME-VOL-INPUT, I-FILTER-ORDER, I-FINAL-SAVE-OPTION
Evidence: E-DO-DAILY-INPUT, E-RISK-COLUMN-CONTRACT, E-ABR-COLUMN-CONTRACT-A, E-DS-THIRD-MATLAB, E-DS-EXCEL-BENCHMARK, E-DO-MERGE-ACCOUNTING, E-DO-GENERATED-LOS, E-DO-GENERATED-DLLP, E-DO-FINAL-SAVE

Preparation / proposed procedure:

1. In a separate working project root, place LOS_Main.do and the author-prepared DTA inputs in Stata/Raw_data/; apply only the supported relative-path and final-save-option changes after recording a source copy.
2. Run the documented daily-price Stata construction stage first to create past_ret_fyear_end.dta, using the author-confirmed daily-to-FYear row selection and 250-business-day history. The current code does not itself visibly produce Ret_Stock.mat.
3. With the missing author Stata-to-MAT producers and caller specifications supplied, create Ret_Stock.mat and StockABRIFRS9calc.mat with the stated positional contracts; run the two MATLAB functions only with the author-specified fwd_d and W_est/W_est_end/W_event values, then perform the documented event/key/name conversion into Risk_FF.dta and Stock_ABR.dta.
4. With the missing CDS/benchmark MATLAB/Excel materials and the explicit output relationship supplied, complete that stage and prepare CDS_ABS.dta; do not infer that it is the output of the missing Excel or CDS file.
5. After all nine other direct DTA inputs and the sample restriction handoff are present and schema/key checks pass, run LOS_Main.do from the project root. Its visible downstream order is merge/transform to LOS_merged_data.dta, DLLP regressions for 2014-2018 and WinsDLLP to LOS_merged_data_w_DLLP.dta, then winsorization and LOS_main.dta.
6. Resolve the exact namespace and intended sample semantics of the line-100 filter and the NI_TA/tsegen dependency before attempting the full do-file; preserve the author-confirmed sample and estimator.

Validation to perform later:

- Before any future execution, check all direct DTA input paths and documented schemas, each 1:1 or m:1 right-key contract, sample identifiers, MAT positional columns, chosen function arguments, and downstream DTA names/keys.
- Check the project's current directory is the intended writable root and review generated intermediate names in order; then, only after blockers are resolved and execution is separately authorized, use `stata -b do LOS_Main.do`.


## Remaining issues and prerequisites

- I-DAILY-FYEAR-KEY [unresolved; full_pipeline]: The first stage reads daily close prices, calculates L250.Close_price on a business calendar, and saves the resulting rows directly as past_ret_fyear_end.dta. It does not visibly select fiscal-year-end rows, create FYear, or reduce/check uniqueness before the later 1:1 ISIN FYear merge. Confirm the actual input's date-to-fiscal-year field, row unit, annual selection rule, key cardinality, current working directory, and 250 prior business-day observations required before each reported return. Do not guess a sample-preserving aggregation or filter.
- I-FILTER-ORDER [unresolved; full_pipeline]: LOS_Main.do line 100 references LLP, NII, TLoan, TSec, and SizeAsset before later gen statements define exact short names at lines 117, 134, 119, 140, and 139. The packaged release contains no merged DTA schemas or Stata setup proving the variable namespace or varabbrev setting. If abbreviations are enabled, a bare name may resolve uniquely to a longer imported variable while the later gen creates a distinct exact short name; an absent/ambiguous resolution or an existing exact name has different behavior. None of these namespace cases is established by the supplied sources. The line order is confirmed, but a source-order failure or the intended sample-preserving correction is not; clarify actual name resolution and intended filter values before changing the filter, variable definitions, or sample.
- I-MAT-HANDOFFS [unresolved; full_pipeline]: The two supplied MATLAB functions have no supplied MAT producer or caller. Ret_Stock.mat has a five-column positional table contract and requires a caller-supplied fwd_d; StockABRIFRS9calc.mat has an eleven-column positional contract and requires caller-supplied W_est/W_est_end/W_event values. Their outputs are matrices/text rather than the Stata annual-key DTA contracts: risk output contains TR while Stata consumes TRisk, and the stock-event output positions BankID/FYear/ABR but has no ISIN while Stata merges on ISIN-FYear and consumes CABR. The text export name, file read by Stata, mappings, conversion steps, and source-row order/periods are unresolved.
- I-DTA-SCHEMAS [unresolved; full_pipeline]: Ten direct Stata DTA handoffs beyond Close_price_LLP.dta and Accounting.dta are listed as individual requirements, but none is supplied with a codebook/schema or readable data probe. Merge keys are visible in source; field names, types, units, identifier/country mappings, row uniqueness for each declared 1:1 or m:1 join, sample/year coverage, and ownership of downstream fields are not. Keep input ownership unassigned until these schemas are provided.
- I-INCOME-VOL-INPUT [unresolved; full_pipeline]: LOS_Main.do calls tsegen IncomeVol = rowsd(L(0/4).NI_TA,5) after xtset Bank_ID FYear. The actual extension command is not found in the checked Stata adopath, and NI_TA is not generated in the supplied do-file (which generates NI under a different name); its source/definition in a prepared input and availability in another Stata adopath are unverified. The retained panel needs the current and prior four FYear observations for this expression; the exact input-history rule and author intent must be confirmed.
- I-MAT-ROWS-COMPAT [unresolved; full_pipeline]: Both supplied MATLAB files call rows(table) to obtain the number of rows. No MATLAB runtime/release or compatibility probe is available, and the code does not identify its intended MATLAB versus other runtime. Preserve the source call until its compatibility is checked in the author's intended environment; do not silently replace it.
- I-CDS-BENCHMARK-PRODUCERS [unresolved; full_pipeline]: The datasheet names absent CDSABD_IFRS9_calc.m and an Excel Appendix-A benchmark-CDS calculation, while Stata consumes CDS_ABS.dta. The supplied online supplementary appendix is not the cited main-paper Appendix A, no Excel calculation workbook/formulas or input contracts are supplied, and no source evidence maps either absent stage directly to CDS_ABS.dta. Obtain the missing producer/hand-off specifications rather than inventing an excess-CDS formula or assuming the identifier workbook is the calculation workbook.
- I-PATH-SETUP [preparation; full_pipeline]: LOS_Main.do mixes eleven absolute /Stata/Raw_data/ reads with one relative Stata/Raw_data/FTA_event_study.dta read and writes intermediates/final output in the current directory. A supported batch setup is a project root containing Stata/Raw_data/ and LOS_Main.do, run with that root as the working directory; the host-visible source/data directory and write permission still require future confirmation.
- I-FINAL-SAVE-OPTION [preparation; full_pipeline]: The last line uses save LOS_main.dta, clear. Stata documents clear for use and replace for overwriting a dataset with save. A one-token source edit to replace is a routine supported correction; future run should confirm output write access in the configured project root.
- R-CLOSE-DAILY [undetermined]: Author-prepared daily close-price file read as /Stata/Raw_data/Close_price_LLP.dta. LOS_Main.do renames id/day/isin, creates a business calendar, sets Bank_ID by business date, computes a 250-business-calendar-observation lagged log return, then saves all visible rows as past_ret_fyear_end.dta. The later merge requires one row per ISIN-FYear; exact annual selection, FYear mapping, row reduction/key uniqueness, price scaling, identifier crosswalk, and 250-observation prehistory are not established.
- R-ACCOUNTING [undetermined]: Author-prepared bank accounting master file read as /Stata/Raw_data/Accounting.dta. It must supply ISIN and FYear for the master panel and nonmissing FYear rows; the transformed merged panel later uses accounting and supervisory/stage variables, but the package includes no input codebook to allocate every field to its DTA source. Exact product, variable ownership, units, identifiers, fiscal periods, and imputation of loan-loss provisions/allowance remain unresolved.
- R-RISK-FF [undetermined]: LOS_Main.do directly reads Risk_FF.dta as the Bank forward-risk handoff input; required merge contract: one row per ISIN-FYear. IV, IR, and the downstream Stata TRisk field are used later; the MATLAB result uses TR, and the field-name mapping is not supplied. No matching DTA is supplied, and no complete schema/coverage probe is available.
- R-STOCK-ABR [undetermined]: LOS_Main.do directly reads Stock_ABR.dta as the Abnormal stock-return handoff input; required merge contract: one row per ISIN-FYear. Downstream Stata uses CABR; the supplied MATLAB function returns BankID, FYear, and ABR but no ISIN, so the required identifier and field conversion are unresolved. No matching DTA is supplied, and no complete schema/coverage probe is available.
- R-CDS-ABS [undetermined]: LOS_Main.do directly reads CDS_ABS.dta as the Abnormal CDS-spread handoff input; required merge contract: one row per ISIN-FYear. This directly merged DTA is absent; the package does not show its producer or prove whether it is the output of the missing CDSABD MATLAB/Excel stage. No matching DTA is supplied, and no complete schema/coverage probe is available.
- R-REG-SUPV [undetermined]: LOS_Main.do directly reads Regl_Supv_index.dta as the Supervisory-intensity handoff input; required merge contract: many master rows per ISIN-FYear, merged m:1 on ISIN FYear. Downstream code uses SupPower_index; no input schema or field ownership is supplied. No matching DTA is supplied, and no complete schema/coverage probe is available.
- R-SOV-CDS [undetermined]: LOS_Main.do directly reads Sov_CDS.dta as the Sovereign CDS handoff input; required merge contract: many master rows per Country-FYear, merged m:1 on Country FYear. Downstream code uses Sov_CDS and Sov_CDS18; the codebook, country mapping, units, and coverage are not supplied. No matching DTA is supplied, and no complete schema/coverage probe is available.
- R-LOAN-STAGES [undetermined]: LOS_Main.do directly reads Loan_Stages.dta as the Loan-by-stage handoff input; required merge contract: many master rows per ISIN-FYear, merged m:1 on ISIN FYear. The DTA is named and merged, but its field schema and source-field ownership are absent; do not infer variables from the separate LLA-by-stage file. No matching DTA is supplied, and no complete schema/coverage probe is available.
- R-LLA-STAGES [undetermined]: LOS_Main.do directly reads LLA_Stages.dta as the Loan-loss-allowance-by-stage handoff input; required merge contract: many master rows per ISIN-FYear, merged m:1 on ISIN FYear. Later code uses Stage1_LLA, Stage2_LLA, and Stage3_LLA; the absent schema does not establish all source columns or data transformations. No matching DTA is supplied, and no complete schema/coverage probe is available.
- R-ECL-BANK [undetermined]: LOS_Main.do directly reads ECL_Bank.dta as the Treated-bank indicator handoff input; required merge contract: many master rows per ISIN, merged m:1 on ISIN. The source labels this as a treated-dummy input; the DTA and treatment-variable field contract are not supplied. No matching DTA is supplied, and no complete schema/coverage probe is available.
- R-FTA-EVENT [undetermined]: LOS_Main.do directly reads FTA_event_study.dta as the Day-1 impact/event-study handoff input; required merge contract: one row per ISIN-FYear. The relative path already differs from the other /Stata/Raw_data/ reads. The DTA is absent and no producer/schema is supplied. No matching DTA is supplied, and no complete schema/coverage probe is available.
- R-RET-STOCK-MAT [undetermined]: Risk_Ind_calc.m loads Ret_Stock.mat as a daily table whose positional fields are 1 ISIN, 2 FYear, 3 ReportDate, 4 Ret, and 5 Bank_ID. It needs fwd_d subsequent daily rows from each ReportDate==1 within a bank; the exact fwd_d, source Stata-to-MAT producer, ordering, storage types, and historic/edge-row treatment are not supplied.
- R-STOCK-ABR-MAT [undetermined]: StockABR_IFRS9_calc.m loads StockABRIFRS9calc.mat as a table with positional fields 1 Bank_ID, 2 Date, 3 ISIN, 4 unused, 5 Ret, 6 FYear, 7 Event_d, 8-10 Fama-French factors, and 11 Rf. The event-window call values, table row ordering/types, stationarity/market-history coverage, and MAT producer are not supplied.
- R-BENCHMARK-EXCEL [undetermined]: The datasheet specifies an Excel calculation of benchmark CDS using Appendix A of the paper, but this package supplies no calculation workbook, formulas/source ranges, market-data input contract, or manual step instructions. The main paper's Appendix A method is not part of this package's supplementary appendix file; retain its formula and data requirements unresolved.
- S-TSEGEN [preparation_required]: LOS_Main.do invokes the tsegen command for rowsd(). Stata 18 is available, but the exact `which tsegen` probe returned 111 on the checked adopath; locate or configure the required extension in a future environment. This is not evidence of license denial or absence outside that adopath.
- S-MATLAB [unverified]: The datasheet and supplied functions require MATLAB, but no runtime/release or installation verification is available. Verify the intended MATLAB release and function compatibility before preparing the cross-language handoffs.
- S-EXCEL [unverified]: The datasheet assigns an Excel benchmark-CDS step to the workflow, but the benchmark workbook, Excel version, and local Excel availability are not verified. Do not substitute another spreadsheet engine without compatibility evidence.
- S-MATLAB-STATISTICS-TOOLBOX [unverified]: The supplied MATLAB code invokes regress, nanstd, nanmean, and nansum. Official MathWorks documentation classifies these functions in the Statistics and Machine Learning Toolbox; installation/license status and the author's MATLAB release are unverified.

## Review notes

- Generation_002 is a scoped reassessment of the prior pair. It retains the actual supplied Stata construction/DLLP workflow and both MATLAB functions without adding unprovided paper-wide regressions. The four frozen parser dependency IDs remain covered; all 15 source/input contracts, five software items, nine issues, and supported preparation edits remain in scope.
- The source confirms line 100 precedes later exact-name gen statements, but the inputs' variable schemas and Stata varabbrev setting are absent. Unique-prefix resolution of a longer imported name is a possible third namespace case, not evidence that such an alias exists. I-FILTER-ORDER is therefore unresolved rather than a confirmed blocker; no filter move, rename, definition, or sample change is proposed.
- The prior bounded Datastream, Worldscope, and tsegen probe JSON files are copied byte-identically from generation_001 into this work directory with their original timestamps, methods, and limitations; the provenance manifest records the copy. No data/software probe was run for this reassessment. The frozen generation_002 environment and workbook inspection artifacts are used at their supplied paths.
- The daily-return/fiscal-year row selection and key history, all prepared-DTA schemas and merge keys, NI_TA and five-period history, MATLAB input/caller/row contracts and output conversions, missing CDS/benchmark producers, and software compatibility remain unresolved as previously supported. The workbook remains only the final-sample ISIN list.
- The 11 relative input-path preparations and final save-option correction remain source-checked setup proposals. No author code/function, estimation, study data, installation, download, contact, or applied edit was used in this reassessment; execution is not verified.
