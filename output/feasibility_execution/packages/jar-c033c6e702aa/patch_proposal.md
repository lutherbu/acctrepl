# Patch proposal: jar-c033c6e702aa

Debt contract enforcement and conservatism: Evidence from a natural experiment

DOI: 10.1111/1475-679X.12238

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Author-provided SAS sample construction and preparation of variables for the main paper and internet-appendix analyses. This package does not provide a downstream regression driver or full analysis-ready dataset.

Entry points: `AL2018_sas_07122018.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 5/12238 - Debt-contract-enforcement-and-conservatism-Evidence-from-a-natural-experiment/al-datasheet-and-code.zip",
      "sha256": "6daea21c0f62d2da9dc92741d27f2840a98d7909fb276fe60fe82597756a3cfc"
    },
    {
      "path": "JAR-Volume 56/Issue 5/12238 - Debt-contract-enforcement-and-conservatism-Evidence-from-a-natural-experiment/al-internet-appendix.pdf",
      "sha256": "baf43012a9663c547a5d2bab502911f65b3ea85704531c6501ab32c19cf01339"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "5899b50696cb36f3687101fd97756cbaefc74329f4c639ec616b89ad64ed4ccc"
}
```

## Proposed actions

### ACT_PATHS: Configure the Windows-rooted SAS paths as one consistent local data/output root before attempting the author program.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISS_PATHS
Evidence: E003, E004, E005, E006, E013, E014, E015, E016, E021, E028

Preparation / proposed procedure:

1. Select a writable local root for the author data tree and its india SAS library.
2. Map the [redacted-path-000b6ae25a3a] library root and the [redacted-path-7479df7c77d8] locations consistently across source lines 17, 24, 33, 42, 254, 279, 301, 508, 841 and 1099; preserve the same root for india.TLR0516 creation/readback and all india.* tables.
3. Place each verified author input and the winsor macro at its mapped location; keep the final AL2018.dta output under the configured output root.

Validation to perform later:

- Statically confirm every C: path resolves under the same configured root and each india.* producer/consumer shares the same library.
- After runtime and inputs are separately verified, inspect SAS logs for successful reads, TLR0516 write/read, macro calls, and final export.

### ACT_PROWESS: Resolve access to the Prowess exports consumed by the supplied author sample builder. CMIE currently describes a subscription product with downloadable text financial data, but current field/vintage compatibility is unverified.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_FIN, R_LINES, R_BORR, R_ID, R_BANKERS
Evidence: E002, E004, E005, E006, E013, E021, E029, E036

Preparation / proposed procedure:

1. Confirm an authorized Prowess route and whether the author-era exports or compatible versions are available; do not treat the catalog miss as a license decision.
2. Obtain the separate pipe-delimited exports financials0521.txt, lineitems0808.txt, borrowings061517.txt, and identity0427.txt, preserving their company/date keys and the source fields used throughout the SAS construction; obtain the field map and exact vintage from the authors if needed.
3. Confirm financial history covers at least 1989–2004: final rows are 1991–2004, while the one-year lag of change_pat is itself built from a one-year-lagged accounting change.
4. Obtain bankers.txt as a distinct bank-history input with bnkhist_cocode, bnkhist_date and banker_name; confirm source, exact date encoding and treatment-year endpoint.

Validation to perform later:

- Check the three financial files each contain sa_finance1_cocode and sa_finance1_year and that their field mapping supplies every downstream variable consumed by the program.
- Confirm identity keys/attributes match the financial company codes and that required historical observations exist without inferring completeness from the current product page.
- For bankers.txt, verify company/date/banker keys match the financial date encoding and the author-confirmed comparison horizon.

### ACT_PIN: Obtain the author’s 2015 Government PIN crosswalk or confirm a compatible current official file and mapping. The present OGD page’s listed fields do not establish the code’s state/district columns.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_PIN
Evidence: E014, E037

Preparation / proposed procedure:

1. Request the original crosswalk or identify a documented compatible official source containing pincode, state and district.
2. If using the current OGD directory, verify the required state/district columns and historical mapping; do not infer them from office/region fields.
3. Preserve six-character PIN formatting and the code’s join to regdpin.

Validation to perform later:

- Confirm pincode, statename and Districtname fields, key formatting, uniqueness/duplicate handling and state/district match rates against firm identity records.

### ACT_STATE_ECON: Obtain the author’s RBI state_econ.csv or a documented compatible DBIE extract; the current RBI catalog establishes a product family but not the author’s fields or vintage.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_STATE_ECON
Evidence: E015, E038

Preparation / proposed procedure:

1. Request the November 2015 author file or the exact RBI table(s), years and transformation rules that produce state_name, credit_g, high_cg, gdp_g and high_gg.
2. If using DBIE/Handbook data, verify source definitions, units, state labels and compatibility before creating the code-expected CSV.

Validation to perform later:

- Confirm all five expected fields and state-name join compatibility; compare coverage and values to author-provided specifications before running the merge.

### ACT_AUTHOR_TABLES: Request the author-prepared SAS datasets absent from the release. The supplied source gives consumers but not complete producers, provenance or schemas; do not reconstruct them independently.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_IND90, R_DEBT, R_AUDIT, R_NBANKS, R_STATECON, R_BSIZE
Evidence: E017, E018, E019, E020, E026, E027, E032

Preparation / proposed procedure:

1. Obtain ind90.sas7bdat with ISIC2/hextdep; debt_intensity.sas7bdat with co_code/large/hlev/leverage/debtrupee; auditor.sas7bdat with audhist_cocode/audyear/big4/t20/t40/t50/t100; and nbanks.sas7bdat with co_code and the intended downstream bank-count fields.
2. Obtain state_con.sas7bdat with statename_low/fyear and the intended state-bank analysis fields, covering the 1991–2004 panel; obtain bsize.sas7bdat with banker_name/bank_asset_avg/ba_rank_10 and its applicable bank population/history.
3. Ask for each dataset’s author producer, definitions, time coverage and any required ordering; keep these as six distinct inputs because the code reads distinct tables.

Validation to perform later:

- Use a bounded SAS row-limit-1 probe for each supplied SAS table after receipt; verify exact keys/fields and leave full population coverage unclaimed until author documentation supports it.
- Confirm state and firm merge keys, uniqueness/duplicate behavior, period coverage, and that none of the tables is being silently replaced by a different-schema catalog candidate.

### ACT_DISTBANK: Resolve the author’s district-bank table or a documented compatible RBI Banking Outlet extract. RBI confirms branch listings are searchable/downloadable, but required historic coverage, classifications and constructed columns remain unknown.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_DISTBANK
Evidence: E024, E025, E032, E039

Preparation / proposed procedure:

1. Request dist_bank.sas7bdat or exact author specifications for the source years, bank-type classification and construction of statebranch, privbranch, forebranch, nbranch_ds and nbank_ds.
2. If the RBI outlet listing is the intended source, verify that historical records and bank types cover the relevant DRT periods and that the documented aggregation reproduces the expected state/district aliases.

Validation to perform later:

- Confirm required state_name/state_long and district_name/district_long fields plus count/share columns; verify geographic joins and coverage for the appendix partitions.

### ACT_WINSOR: Obtain the missing author winsor.sas macro and confirm its behavior at the two included calls; do not replace it with an assumed implementation.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_WINSOR
Evidence: E016, E032

Preparation / proposed procedure:

1. Request the exact winsor.sas source or an author-confirmed equivalent and its compatibility notes.
2. Place the macro at the configured include path while preserving the two per-fyear settings: 1/99 for the basic variables and 0.1/99.9 for the line-item variables.

Validation to perform later:

- Before any full run, verify the macro name/signature matches both calls and its output columns preserve master3 and all downstream variables.

### ACT_SAS: Resolve the SAS startup environment through its administrator; the existing probe failed during TKELS initialization and does not establish absent licensing.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS
Evidence: E034, E004, E005, E006, E014, E015, E028

Preparation / proposed procedure:

1. Ask the SAS environment administrator to diagnose runtime startup/TKELS initialization and confirm the installed SAS 9.4 TS1M8 environment and entitlement.
2. Do not install packages or infer a license outcome from the existing failure.

Validation to perform later:

- After the environment owner resolves startup, run only a bounded empty-session SAS check first and preserve its log; attempt the author program only after its data, macro, paths and analysis scope are resolved and separately authorized.
- As part of a future authorized capability check, confirm that PROC IMPORT reads the required pipe-delimited and CSV formats and that the PROC EXPORT statement actually creates the intended Stata-format AL2018.dta; do not infer a format defect from an omitted DBMS option alone.
- Verify that the exported AL2018.dta is readable by the intended downstream reader and exposes the expected prepared-data fields; perform no SAS retry or author-program execution during this assessment.

### ACT_ANALYSIS: Request the missing author analysis driver(s) and any analysis-only prepared data routes needed to reproduce the main-paper and appendix tables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_ANALYSIS
Evidence: E001, E028, E029, E030, E032, E033, E010, E036

Preparation / proposed procedure:

1. Request the Stata or other downstream regression program(s) for the exported AL2018.dta and a table-to-script/input map for the main paper and every appendix result.
2. For Table AI, retain the appendix as the source for a Prowess daily BSE return candidate: the downstream script must annualize firm-year returns and apply the stated 150-trading-day minimum. CMIE currently lists daily returns for listed firms, but exact BSE fields, historical coverage and compatibility remain unverified; request the authors’ actual route and mapping with the missing program.
3. Request the code and any specifically documented inputs for Table AII and Table AIII; Table AIII requires a 1998–2010 placebo sample with hypothetical DRT shifted seven years, which is absent from the supplied 1991–2004 actual-DRT builder.
4. Do not create an analysis_only scope until a supplied analysis entry point and compatible author-prepared analysis data route are identified.

Validation to perform later:

- Verify the supplied analysis scripts point to the output actually produced by this SAS program, identify all additional inputs and table-specific routes, and cover the documented outputs without changing samples or estimators.
- For Table AI, verify the author-documented BSE daily-return field mapping, annualization, 150 valid trading days per retained firm-year and relevant period before estimating.
- For Table AIII, verify a separate supported placebo construction produces the documented 1998–2010 sample and seven-year treatment shift.

### ACT_AVIII: Clarify the appendix AVIII bank-count horizon before changing the bank-history construction.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_AVIII
Evidence: E023, E031

Preparation / proposed procedure:

1. Ask whether the intended post period is DRT_1styear+1 as coded or two years after implementation as described in Appendix Table AVIII.
2. Request the corresponding bank-history endpoint and any corrected author source if the code or appendix description is stale.

Validation to perform later:

- Confirm the final pre/post-year selection and resulting bank counts match the author-confirmed definition and Table AVIII sample before estimating the appendix result.


## Remaining issues and prerequisites

- ISS_PATHS [preparation; full_pipeline]: The entry program uses a Windows C: library root and absolute C: paths for raw imports, the winsor include, and the Stata export. This Linux SAS environment needs one coherent local root/configuration across every producer and consumer, including the india library tables.
- ISS_WINSOR [unresolved; full_pipeline]: The active include [redacted-path-132782fd308b] and its %winsor macro definition are absent from the supplied package. Both calls are required before final sample export; their exact implementation cannot be supplied from this release.
- ISS_ANALYSIS [unresolved; full_pipeline]: The supplied SAS file constructs and exports an analysis dataset but contains no estimation or table-generation program. The workbook is only a firm-key list, not a prepared analysis dataset. The supplied builder filters to fiscal years 1991–2004 and assigns actual DRT dates; Appendix Table AIII instead uses 1998–2010 with hypothetical DRT shifted seven years, and no alternate preparation branch is supplied. Appendix Table AI documents Prowess daily BSE returns annualized by firm-year with at least 150 trading days, but the supplied SAS builder does not consume returns; this remains a candidate input lead for the absent downstream analysis program, with current product compatibility unverified. Obtain the companion analysis code and its required inputs before claiming paper-level reproduction.
- ISS_AVIII [unresolved; full_pipeline]: For the internet-appendix bank-count comparison, supplied SAS selects fyear=DRT_1styear+1, while Appendix Table AVIII describes measuring change through two years after implementation. The intended post year and matching bank-history coverage are unresolved.
- R_FIN [undetermined]: Prowess financial statement export financials0521.txt used as the left/base financial panel. The three financial exports are jointly needed, keyed by company code and financial date; downstream columns and 1989–2004 construction history must be confirmed.
- R_LINES [undetermined]: Prowess additional financial line-item export lineitems0808.txt, joined to the base financial panel; its downstream field mapping must be confirmed.
- R_BORR [undetermined]: Prowess borrowing-composition export borrowings061517.txt, joined with the other two financial exports.
- R_ID [undetermined]: Prowess firm identity export identity0427.txt; required to map financial company codes to postal, listing/delisting, industry and ownership attributes.
- R_PIN [undetermined]: Government of India PIN-code crosswalk needed to attach state and district to Prowess firm identity.
- R_STATE_ECON [undetermined]: RBI state_econ.csv contributes state-level credit/GDP growth controls merged by state name.
- R_IND90 [undetermined]: Author-prepared SAS table india.ind90 supplies external-finance dependence by ISIC2.
- R_DEBT [undetermined]: Author-prepared SAS table india.debt_intensity supplies firm-level debt-intensity partitions and controls.
- R_AUDIT [undetermined]: Author-prepared auditor SAS table supplies auditor-history indicators joined by company and year.
- R_NBANKS [undetermined]: Author-prepared SAS table india.nbanks is merged by company and its columns are carried into the prepared output.
- R_BANKERS [undetermined]: Bank relationship history imported from bankers.txt for appendix bank-count construction and bank-size linking.
- R_DISTBANK [undetermined]: Author-prepared district-bank SAS table supplies state/district branch and bank counts and shares for appendix partitions.
- R_STATECON [undetermined]: Author-prepared state-bank SAS table is merged by normalized state and fiscal year.
- R_BSIZE [undetermined]: Author-prepared bank-size SAS table provides bank_asset_avg and ba_rank_10 keyed by banker_name.
- SW_SAS [unverified]: The author supplied SAS code but no version. The existing environment probe attempted the documented SAS 9.4 TS1M8 command and failed to initialize TKELS; its own note says entitlement cannot be inferred. Runtime capability for the program’s pipe-delimited and CSV PROC IMPORT reads and Stata-format PROC EXPORT output, including the readability of the resulting AL2018.dta, remains unverified.

## Review notes

- The complete package variant is sample-construction code plus a firm-identifier workbook, not a supplied regression package. The workbook probe reads one key column in one row and does not establish full analysis data or a bypass route.
- The SAS file writes TLR0516 and reads it back under the same india library; D0007 is generated by the supplied producer, while the separate india.* tables and [redacted-path-b70c89c5c662] remain distinct external inputs.
- The final code panel is fiscal years 1991–2004. Main financial lags require preceding-year data; lchange_pat lags a change measure that already uses lagged accounting values, so Table AII’s early panel needs raw financial history through 1989. The exact Prowess vintage/field mapping is unresolved.
- All 16 frozen dependency IDs are covered. Catalog lookups included author aliases and the documented Prowess/CMIE, RBI and Government PIN source families; no matches are metadata only and do not establish absent data or licenses.
- The SAS comments identify bankers.txt, dist_bank, state_con and bsize as appendix-only inputs; they remain in scope because the supplied entry point runs them and exports the combined dataset. Table AIII’s requested 1998–2010 hypothetical-DTR preparation is not present in the 1991–2004 actual-DTR builder.
- Appendix AI’s Prowess daily-return and 150-trading-day specification is retained only as an unverified input lead for the missing downstream analysis driver; it is not a mandatory input to the supplied SAS builder. No independent analysis reconstruction is proposed.
