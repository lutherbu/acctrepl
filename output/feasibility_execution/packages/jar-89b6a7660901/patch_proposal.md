# Patch proposal: jar-89b6a7660901

The Information Externality of Public Firms’ Financial Information in the State-Bond Secondary Market

DOI: 10.1111/1475-679X.12361

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author-documented SAS preparation workflow followed by the Stata main-regression program.

Entry points: `sas code.sas`, `stata code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 2/12361 - The-Information-Externality-of-Public-Firms-Financial-Information-in-the-State-Bond-Secondary-Market/cheng-datasheet-code-and-identifiers.zip",
      "sha256": "d2a596bc1e0b3456225cdf5a2981d6debd53c4c8c7702d1e89000d45af7193c4"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "4b0a93c9ed8fc62e33db5cf0b0541425962cf5fa850ced48daa78a80700ec471"
}
```

## Proposed actions

### A001: Locate the author's prepared firm-quarter panel and verify its full input contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R001
Evidence: E001, E014, E026, E029, E030, E032, E033, E034, E035

Preparation / proposed procedure:

1. Identify and stage the author-prepared Data.comp_2000_2017 table, or record its authorized physical location, format, and SAS library name.
2. Confirm that the table supplies gvkey1, datadate, rdq, piq, mkvaltq, historical state, and equity_ret with the types and identifier/date mappings expected by sas code.sas.
3. Verify actual input coverage and same-quarter lag history for state-month signals filtered to 2005–2017; the table name and one-row Compustat/CRSP probes do not establish coverage.
4. If the author confirms an upstream reconstruction route, treat local COMP.FUNDQ and CRSP.MSF only as candidate ingredients and identify the missing historical-state source, joins, and transformations; they do not replace this prepared-panel requirement by themselves.

Validation to perform later:

- Before an authorized run, compare a bounded panel schema and actual date/identifier coverage with the confirmed contract, including all lag history needed for the 2005–2017 signal sample.
- After an authorized preparation run, confirm Data.Geofa contains the expected state-month signal fields and quarter-end key.

### A002: Locate the controls workbook and confirm each required sheet, source-column mapping, and construction history.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R002, R003, R004, R005, R006, R007
Evidence: E003, E009, E010, E011, E012, E013, E025

Preparation / proposed procedure:

1. Provide or identify the exact controls workbook referenced by the relative filename controls and confirm that it contains the gsp, ur, coin, rating, gvtfa_gen, and GvtFa_govt sheets.
2. Map the imported columns to the code contract for each sheet: state/calendar_qtr_end/gsp; date/_NAME_/ur; date plus state-code series and the PROC TRANSPOSE label-to-state mapping; state/code/year/rating; the general-fund financial columns; and the government-fund financial columns.
3. Confirm imported SAS column names and types, including the coin state-key mapping and Fiscal_Year_End parsing, and identify missing-value conventions.
4. Verify the preceding state-quarter or state-year observations used by growth, rating-change, and fund-change lag calculations, plus the fiscal-year-end reporting-lag joins in the final merge. Do not infer a minimum history not established by the workbook.

Validation to perform later:

- Before an authorized run, inspect each actual worksheet with a bounded format-aware reader and compare its columns, keys, date representation, state coverage, and required prehistory with sas code.sas.
- After an authorized preparation run, confirm the six Data.ctrl_* outputs have the exact join keys and derived control columns required by the final merge.

### A003: Identify the four bond-return inputs and verify their joins, fields, and date coverage without substituting unrelated catalog tables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R008, R009, R010, R011
Evidence: E004, E005, E006, E015, E016, E017, E025, E031, E038, E039, E040, E041

Preparation / proposed procedure:

1. Locate the author-prepared Data.msrb_2005_2017 table with cusip, dollar_price, dollar_price_dirty, par_traded, trade_date, and TRADE_TYPE_INDICATOR; verify its actual trade-date span and that every retained return month has the prior-calendar-month same-CUSIP price record required by the inner self-join.
2. Locate the sdc_cusip_list workbook's state sheet and verify cusip6, issuer, and state mapping for the municipal issuers used in the MSRB join.
3. Locate the Bloomberg workbook's state sheet and verify the CUSIP, bond-type, coupon, issue/maturity, coupon-month, issuer, state-code, and bond-size fields and their numeric/date representations.
4. Locate Data.treasury with CALDT and the B1RET, B2RET, B5RET, B7RET, B10RET, B20RET, and B30RET term series used in ret_avg/ret_w; preserve T90RET, T30RET, and CPIRET fields that the authored output branch also carries, and verify matching month-end coverage.
5. Treat frozen-catalog SDC M&A tables and empty MSRB/Bloomberg/Treasury-index searches only as discovery findings; they do not prove absence, access restrictions, or compatibility with these contracts.

Validation to perform later:

- Before an authorized SAS run, inspect each supplied file with a bounded reader and compare actual fields, identifiers, units, date types, CUSIP joins, and return-month history with the source contracts.
- After an authorized run, verify the named producer chain Data.return → SAS final merge → Data.finaldata and confirm that required rows survive the authored missing-value and two-trade rules.

### A004: Resolve the SAS library and relative-path context in a host-visible working copy.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I001
Evidence: E001, E003, E005, E006, E008, E018, E025

Preparation / proposed procedure:

1. Choose a host-visible, writable run root under [redacted-path-b2bd128e4b16] or another approved host path; keep runtime configuration relative to that root or under [redacted-path-b2bd128e4b16], never an absolute Dropbox workspace path.
2. Set the SAS batch process working directory to the folder containing the exact controls, sdc_cusip_list, and Bloomberg workbook filenames and the intended data02152021.dta destination.
3. After the author-prepared SAS tables are located, define the Data libref in an authorized wrapper or startup configuration to the directory containing the exact comp_2000_2017, msrb_2005_2017, and treasury tables and the generated Data.* outputs.
4. Keep the relative source filenames and authored data names intact unless inspection later proves a specific path edit is necessary; record distinct source, working, and output directories.

Validation to perform later:

- Before a separately authorized run, verify on the host that each configured input is visible and that SAS can write the Data library, data02152021.dta, and logs in the selected root.
- Confirm the effective SAS current directory and Data libref mapping from the authorized wrapper/log without treating the TKELS startup failure reported by the reused frozen environment probe as an access barrier.

### A005: Add a separate Stata driver that loads the SAS-exported dataset before the supplied analysis script.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I002
Evidence: E008, E021, E025

Preparation / proposed procedure:

1. In the working copy, create a small Stata driver that sets the working directory to the host-visible folder containing data02152021.dta, executes use "data02152021.dta", clear, and then executes do "stata code.do".
2. Keep the authored Stata code unchanged; preserve the generated data file, driver log, and T3.rtf in the selected output root.

Validation to perform later:

- After an authorized SAS run, confirm data02152021.dta exists at the chosen relative path and Stata can read it before invoking stata code.do.
- Confirm the expected analysis variables are present in memory and the final esttab output T3.rtf is written to the documented output directory.

### A006: Verify the staged quarter-key spelling and use Stata's supported unique-prefix behavior or the fully expanded existing name in the working-copy driver.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I003
Evidence: E002, E007, E025

Preparation / proposed procedure:

1. After staging the SAS export, inspect the actual variable spelling and case. calendar_qtr is an exact-case unique prefix of calendar_qtr_end in the supplied source, and the default Stata varabbrev setting supports this ordinary abbreviation unless disabled or made ambiguous by the imported schema.
2. In the working-copy driver, retain the default/supported varabbrev behavior or use the fully expanded existing calendar_qtr_end name only after the loaded schema confirms it; preserve the same quarter grouping and do not create a new field or formula.

Validation to perform later:

- Before the authorized regression run, inspect the loaded final-data schema and effective Stata varabbrev setting; verify that the quarter group command resolves to the existing calendar_qtr_end field.
- If using the fully expanded name in a working copy, check the configuration against the SAS producer, exported DTA, and all Stata consumers without executing the analysis during this assessment.

### A007: Resolve the SAS batch startup environment and verify required Base procedures and file formats before any author run.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S001
Evidence: E028, E025

Preparation / proposed procedure:

1. Retain the captured TKELS extension initialization diagnostic and resolve the host-side startup configuration in an authorized environment; do not infer that SAS licensing is absent from this failed startup.
2. Confirm availability of the actual SAS capabilities invoked by this source: PROC IMPORT with DBMS=XLSX, PROC SORT, PROC MEANS, PROC TRANSPOSE, PROC SQL, and PROC EXPORT to Stata format. No SAS/STAT estimator is used by the supplied SAS source.

Validation to perform later:

- Before a separately authorized run, verify that the SAS runtime launches in batch mode and that the required procedure/format capabilities are available in the same host environment used for the workflow.

### A008: Install or configure the required winsor2 Stata add-on in the user adopath.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S003
Evidence: E022, E028

Preparation / proposed procedure:

1. Before the future authorized analysis run, install or configure winsor2 in the same Stata user adopath used by the host batch command; do not replace its percentile or variable list with a different winsorization procedure.
2. Retain the currently available esttab 2.1.1 and confirm the Stata batch run resolves it in the same adopath.

Validation to perform later:

- Use a bounded Stata which check for winsor2 in the exact future run environment before running stata code.do; retain the observed path/version in the run record.

### A009: Run the supplied preparation and analysis programs in their supported producer-to-consumer order after the data, paths, runtime, and quarter-key contract are resolved.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: E008, E019, E020, E021, E025

Preparation / proposed procedure:

1. From a host-visible, writable run root, define the SAS Data library and current working directory for the relative workbooks and outputs.
2. Run sas code.sas in its authored sequence: Data.comp_2000_2017 → Data.Geofa; controls workbook sheets → six Data.ctrl_* tables; MSRB + SDC + Bloomberg + Data.treasury → Data.return; Data.return + Data.Geofa + controls → Data.finaldata → data02152021.dta.
3. In a separate Stata driver, load data02152021.dta into memory, verify the confirmed quarter-key contract, then run stata code.do to create m1–m3 and T3.rtf.
4. Archive the SAS and Stata logs, generated DTA, final RTF, and the working-copy driver/configuration together without modifying the frozen package source.

Validation to perform later:

- After a separate execution authorization, check each named producer/intermediate/consumer handoff and confirm output files and logs are written in the chosen root.
- Review the final Stata log and T3.rtf after execution; this static assessment itself makes no numerical or successful-execution claim.


## Remaining issues and prerequisites

- I001 [unresolved; full_pipeline]: The SAS source contains no LIBNAME statement or current-directory setup. It reads and writes persistent Data.* tables while controls, sdc_cusip_list, Bloomberg, and data02152021.dta use relative paths. The physical Data library, runtime working directory, and visibility/writability of the input/output locations are unresolved; no external autoexec/include was inspected.
- I002 [unresolved; full_pipeline]: SAS exports data02152021.dta, but the supplied Stata script has no use/import/load statement and therefore assumes its analysis variables are already in memory. A separately configured driver/staging step is required to connect the SAS producer to the Stata consumer; it is not present in this package.
- I003 [unresolved; full_pipeline]: Stata's calendar_qtr token is a unique exact-case prefix of SAS-produced calendar_qtr_end and may resolve under the default varabbrev setting; this is not an established syntax failure. The final DTA is not supplied, so its imported spelling/case and the effective Stata setting remain unverified. Check the staged schema and use the fully expanded existing name or supported setting in the working-copy driver if needed, preserving the same quarter groups; no new producer or formula is indicated by the supplied code.
- R001 [undetermined]: Prepared firm-quarter input Data.comp_2000_2017 read by SAS to construct seasonal earnings lags, state-month earnings signals, and equity-return controls. Required fields are gvkey1, datadate, rdq, piq, mkvaltq, state, and equity_ret; the source panel and its full history are not packaged or verified.
- R002 [undetermined]: Required controls workbook sheet gsp, imported through relative filename controls. SAS uses state, calendar_qtr_end, and gsp to calculate within-state GSP growth; the workbook location and coverage are not verified.
- R003 [undetermined]: Required controls workbook sheet ur. SAS expects date, _NAME_, and ur, derives a two-character state code and quarter-end key, and computes within-state unemployment growth; the exact layout and historical coverage are unverified.
- R004 [undetermined]: Required controls workbook sheet coin. SAS transposes the state-code columns to state-quarter records and computes within-state coincident-index growth; imported date, state columns, and the _LABEL_-to-state mapping are not verified.
- R005 [undetermined]: Required controls workbook sheet rating. SAS maps rating strings to sp_rtg, differences them by state_code and year, and merges the result by bond-state key and year; the original rating observations and coverage are not supplied.
- R006 [undetermined]: Required controls workbook sheet gvtfa_gen for state general-fund measures. SAS uses state, year, Fiscal_Year_End, Total_Assets, Cash___Near_Cash, Accounts___Notes_Receivable, Accounts_Payable, and Accrued_Liabilities, then derives reporting dates and controls; government_type appears only in the SAS output keep list. Source history is unverified.
- R007 [undetermined]: Required controls workbook sheet GvtFa_govt for state government-fund measures. SAS uses state, year, Fiscal_Year_End, change_in_net_assets_per_capita, Total_Assets, Current_Assets_Reported, and Current_Liabilities, then derives reporting dates and controls; government_type appears only in the SAS output keep list. Source history is unverified.
- R008 [undetermined]: Prepared SAS table Data.msrb_2005_2017, used to create monthly municipal-bond trade prices and returns. Required source fields are cusip, dollar_price, dollar_price_dirty, par_traded, trade_date, and TRADE_TYPE_INDICATOR; the prior-calendar-month self-join and actual coverage need validation.
- R009 [undetermined]: SDC state CUSIP workbook imported from relative filename sdc_cusip_list, sheet state, and joined to MSRB on six-character CUSIP. SAS expects cusip6, issuer, and state; issuer and period coverage need verification.
- R010 [undetermined]: Bloomberg bond-characteristics workbook imported from relative filename Bloomberg, sheet state. SAS filters fixed-rate GO bonds, merges on CUSIP, and uses coupon, maturity, issue and bond-size fields; exact field types and history are unverified.
- R011 [undetermined]: CRSP Treasury-index return table Data.treasury, joined to bond return months by calendar month-end. The SAS code selects B1RET, B2RET, B5RET, B7RET, B10RET, B20RET, or B30RET by bond maturity and also carries T90RET, T30RET, and CPIRET into the final dataset; table path and date coverage are unverified.
- S001 [unverified]: The workflow requires DATA steps, PROC SORT, PROC MEANS, PROC IMPORT with DBMS=XLSX, PROC TRANSPOSE, PROC SQL, and PROC EXPORT to Stata format. The bounded environment record shows SAS startup failing during TKELS initialization, so runtime and required component/format availability are unverified; this is not evidence of an absent license. The supplied SAS source contains no estimator or SAS/STAT procedure.
- S003 [preparation_required]: The supplied Stata analysis invokes winsor2 for 1st/99th percentile replacement; it was not found in the checked default or separately configured Stata adopaths. Install or configure this required free add-on in the future authorized run environment.

## Review notes

- This scope covers both supplied programs and all source-backed branches in them; the datasheet's wider Powerlytics, RavenPack, IBES, and SIFMA references are contextual because no supplied program consumes them.
- The datasheet's BEA, FRED, Pew, and Bloomberg control-source descriptions are historical origins for the controls workbook sheets; they are not separate live raw-data requirements while the supplied SAS code consumes those author-prepared sheets. If raw reconstruction is later chosen, the mappings and transformations require confirmation.
- The packaged cusip.dta is a readable identifier list only. No final analysis panel is supplied, so it does not support a separate analysis_only scope or bypass the SAS preparation stage.
- The prepared Data.comp_2000_2017 panel remains the primary route. Local COMP.FUNDQ and CRSP.MSF candidates provide only parts of its upstream contract; bounded samples and catalog metadata do not establish complete field mapping, historical-state joins, or coverage.
- Catalog misses and the SAS TKELS startup diagnostic do not prove data absence, licensing barriers, or missing entitlement. No additional current-entitlement or author-approval gate is imposed on readable local Compustat/CRSP candidates.
- No author program, proposed edit, estimator, or numerical analysis was executed. Runtime and compatibility outcomes remain unverified; execution_verified is false.
