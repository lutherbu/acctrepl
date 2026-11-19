# Patch proposal: jar-ad47df04b4a5

Regulation of Compensation and Systemic Risk: Evidence from the UK

DOI: 10.1111/1475-679X.12355

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

All supplied 01_data_build.do preparation, UK/EU/US systemic-risk, VLab, compensation, matching and final variable-construction stages. The appendix regression tables are contextual; no paper-wide regression driver is supplied in this package.

Entry points: `01_data_build.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 3/12355 - Regulation-of-Compensation-and-Systemic-Risk-Evidence-from-the-UK/ktdatasheetcodeandidentifiers.zip",
      "sha256": "97174c8e25e88d82770a7d42304f68776d3b4101b8dd92705c2827388a940b76"
    },
    {
      "path": "JAR-Volume 59/Issue 3/12355 - Regulation-of-Compensation-and-Systemic-Risk-Evidence-from-the-UK/kt-online-appendix.pdf",
      "sha256": "267414f0ab651b1d2897e144178166296a4acd01ba2a9fd2b53c6e1ae0aa4f2e"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "04f78c4d5fbc132901e8492ba3f23950ca081e8dbc1bd18f8f495bae2f73540c"
}
```

## Proposed actions

### A_INPUTS: Locate compatible author-prepared inputs and reconcile every named table contract before any run. Treat catalogued and historical vendor products as candidate routes, not evidence of current access or compatible fields.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CIQ_BANK_SUPPLEMENT, R_UK_FX, R_MARKIT, R_OWNERSHIP_UK, R_OWNERSHIP_EU, R_OWNERSHIP_US, R_BANK_TURNOVER, R_COVAR_UK, R_COVAR_EU, R_COVAR_US, R_EU_MEMBER_WORKBOOK, R_VLAB_SERIES, R_VLAB_RAW_LOOKUP, R_UK_MV, R_UK_P, R_UK_RI, R_UK_RETURN, R_UK_PTBV, R_UK_DPS, R_UK_RI_MARKET, R_UK_IDIO_RISK, R_UK_SALES, R_UK_TA, R_UK_ROA, R_UK_BV, R_UK_DEBT, R_UK_STDEBT, R_UK_LTDEBT, R_UK_NETDEBT, R_UK_CASSETS, R_UK_CLIABILITIES, R_UK_LIABILITIES, R_UK_LIABILITIESSHE, R_UK_STATIC, R_UK_REMUNERATION, R_UK_GRANTS, R_UK_LTIP, R_UK_IDS_COMPANIES, R_EU_US_BS_MV, R_EU_US_BS_P, R_EU_US_BS_RI, R_EU_US_BS_RETURN, R_EU_US_BS_PTBV, R_EU_US_BS_IDIO_RISK, R_EU_US_BS_DPS, R_EU_US_BS_NI, R_EU_US_BS_TA, R_EU_US_BS_ROA, R_EU_US_BS_SALES, R_UK_MASTER_MARKET_ALL, R_EU_BS_RI_MARKET_NEW, R_EU_BS_MASTER_MKT_RI_UPDATE, R_US_MARKET_RETURN, R_US_BS_MASTER_MKT_RI, R_EU_US_BS_MASTER_MKT_MV_UPDATE, R_MARKIT_IDENTIFIERS, R_IDS_STATIC_UPDATE, R_IDS_STATIC_UPDATE_ISIN, R_INDUSTRY_CROSSWALK, R_UK_COMPENSATION_MASTER, R_CHANGES_ALL, R_BONUS_CHANGES, R_UK_BIRPU_INDICATORS, R_EU_US_BANK_INDICATORS, R_ALL_IDS, R_EU_FLAGS, R_COUNTRY_CROSSWALK, I_UNPACKAGED_DATA, I_PREP_PRODUCERS
Evidence: E_PACKAGE, E_DATA_SHEET, E_HISTORY, E_DATASHEET_UK_MARKET, E_DATASHEET_GLOBAL, E_DATASHEET_BANKSCOPE, E_DATASHEET_CIQ, E_DATASHEET_OWNERSHIP, E_DATASHEET_TURNOVER, E_CATALOG_DATSTREAM, E_CATALOG_COMPUSTAT, E_CATALOG_CIQ, E_CATALOG_OTHER, E_REQ_UK_MASTER_MARKET_ALL, E_REQ_EU_BS_RI_MARKET_NEW, E_REQ_US_MARKET_RETURN

Preparation / proposed procedure:

1. For every requirement, locate the exact author-prepared table or documented source extract and record its product/version, native columns, row unit, identifier keys, date fields, units, frequency and full coverage; use the named table contracts rather than combining unrelated products.
2. Keep the UK IDS Static, Remuneration, Grants, LTIP and IDS_Companies inputs separate from UK Datastream MV/P/RI/Return/PTBV/DPS/RI_Market and the annual Sales/accounting tables. Credit Datastream as the documented primary UK source; retain Compustat Global only as a documented supplemental candidate unless a specific table mapping is established.
3. Keep each EU/US BS_* input separate and distinct from the single combined ciq_banksope author table. Confirm the Capital IQ and BankScope field mapping for that combined table rather than treating the brands as interchangeable or as separate mandatory inputs.
4. Retain region-specific ownership, turnover, FX, crosswalk and compensation-change inputs. For every named prepared table with no in-source producer, locate the earlier author stage or exact file/schema; do not invent a source, risk formula, sample rule or join.
5. Confirm input history relative to each constructed measure. The code comment requires source history from 2001 for CoVaR lag construction even though the main analysis period is 2006–2012. Verify commercial access from an actual permitted route; a catalog miss is not an access denial.

Validation to perform later:

- Before a separately authorized run, compare bounded source metadata with the named Stata reads and merges, including actual imported column names, identifiers, date types, currency/units, duplicate policy and required history.
- Verify the all_identifiers_final.xlsx candidate against the all_IDs merge by key and coverage; the one-row probe does not establish workbook completeness or equivalent import semantics.

### A_RISK_INPUTS: Resolve the distinct prepared Idio_Risk and BS_Idio_Risk producers and contracts before market-risk stages.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_UK_IDIO_RISK, R_EU_US_BS_IDIO_RISK, I_RISK_PRODUCERS
Evidence: E_UK_MARKET_IDIO, E_BS_IDIO_RISK, E_SOURCE_END

Preparation / proposed procedure:

1. Locate the author producer or prepared outputs for UK Idio_Risk and EU/US BS_Idio_Risk separately, including their exact volatility/risk recipe, fields, date keys, security/bank keys, units and construction period.
2. Keep the supplied merge keys distinct: the UK branch merges by Date and Type; the bank branch merges by Date and id_Type. Do not substitute a generic market return or guessed volatility calculation.

Validation to perform later:

- Once producer files are identified, verify the two risk tables' keys, column types, required history and unique-merge compatibility against the source without running the risk branch during assessment.

### A_VLAB_DATA: Verify whether the current public VLab per-firm export can supply the historical country/firm series and lookup used by the authors; otherwise identify the historical author files.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_VLAB_SERIES, R_VLAB_RAW_LOOKUP, R_EU_MEMBER_WORKBOOK, I_VLAB_POPULATION
Evidence: E_DATASHEET_VLAB, E_PUBLIC_VLAB_SERIES, E_PUBLIC_VLAB_LOGIN, E_EU_MEMBER_INPUT, E_VLAB_LOOKUP_DAT, E_VLAB_IMPORT_ALL, E_VLAB_DENOM

Preparation / proposed procedure:

1. Compare the official per-firm ZIP and lookup route with the authors' January 2018 delivery for fields, dates, country codes, firm population, vintage and daily series schema. Free registration is a preparation step; do not submit requests or forms during this assessment.
2. Stage the full relevant country/firm population in a clean VLab outputdata directory and reconcile each lookup row to its corresponding CSV. The existing code appends all .dta files in the current folder, so ensure no unrelated or stale files enter the aggregate.
3. Confirm the EU-member workbook sheet/range and country labels match the VLab lookup merge; verify the resulting country-year denominator uses the full required population rather than only study firms.

Validation to perform later:

- Before any separately authorized VLab processing, compare CSV field names/types, lookup references, historical period and full country/firm counts with the code's normalized SRISK_VLAB columns and country aggregates.

### A_VLAB_PATH: Read the filtered lookup.dta from the exact modified/Analysis directory where the supplied stage saves it.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_VLAB_HANDOFF
Evidence: E_VLAB_PATHS, E_VLAB_READ, E_EU_MEMBER_INPUT

**Proposed edit:** `01_data_build.do:1166–1166`
Source SHA-256: `382523bb121248f286dd1dac2d0d74ae3d3fe1e4136b35fd31740a8b64435e31`

The supplied producer saves this filtered lookup at $modified/Analysis/lookup.dta after applying the EU-member filter; align the consumer path with that known output instead of requiring an unproduced copy.

Current text:
```
use "$data\SRISK_VLab\lookup.dta", clear
```

Proposed replacement:
```
use "$modified\Analysis\lookup.dta", clear
```

Preparation / proposed procedure:

1. Apply this path change only in a working copy after the modified/Analysis directory has been staged; retain the existing lookup variables and country filter.

Validation to perform later:

- Later, verify the generated lookup's filename/country columns and compare them with the CSV loop's expected file list before processing the full population.

### A_MARKIT_PATH: Save the supplied Markit bank and UK subsets under the modified directory already used by their consumers.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: R_MARKIT, R_MARKIT_IDENTIFIERS, I_MARKIT_HANDOFF
Evidence: E_DATASHEET_MARKIT, E_MARKIT_PATHS, E_MARKIT_READ

**Proposed edit:** `01_data_build.do:832–832`
Source SHA-256: `382523bb121248f286dd1dac2d0d74ae3d3fe1e4136b35fd31740a8b64435e31`

Align the producer with the existing $modified consumer at line 859 while preserving the subset and filename.

Current text:
```
save markit_bank_subset, replace
```

Proposed replacement:
```
save "$modified\markit_bank_subset", replace
```

**Proposed edit:** `01_data_build.do:892–892`
Source SHA-256: `382523bb121248f286dd1dac2d0d74ae3d3fe1e4136b35fd31740a8b64435e31`

Align the UK producer with the existing $modified consumer at line 925 while preserving the subset and filename.

Current text:
```
save markit_uk_subset, replace
```

Proposed replacement:
```
save "$modified\markit_uk_subset", replace
```

Preparation / proposed procedure:

1. Stage the compatible Markit source and resolve the separate markit_identifiers producer/key table before using these subsets; the output-path edits do not supply that missing identifier mapping.

Validation to perform later:

- Statically confirm both edited producers match their exact existing consumers; later verify the subsets retain the ticker/redcode, date and spread fields expected by downstream merges.

### A_COVAR_PATHS: Align the known EU and US generated macro-state paths/names with their downstream consumers while retaining separate regional CoVaR contracts.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: R_COVAR_UK, R_COVAR_EU, R_COVAR_US, I_COVAR_HANDOFF
Evidence: E_EU_COVAR_WRITE, E_EU_COVAR_READ, E_US_COVAR_WRITE, E_US_COVAR_READ, E_UK_COVAR_INPUT, E_EU_COVAR_INPUT, E_US_COVAR_INPUT

**Proposed edit:** `01_data_build.do:1643–1643`
Source SHA-256: `382523bb121248f286dd1dac2d0d74ae3d3fe1e4136b35fd31740a8b64435e31`

The same daily EU macro-state basename is produced under $modified at line 1537; align the consumer root with that supplied producer.

Current text:
```
merge m:1 Date using "$data\EU_CoVAR_M_inputs_daily"
```

Proposed replacement:
```
merge m:1 Date using "$modified\EU_CoVAR_M_inputs_daily"
```

**Proposed edit:** `01_data_build.do:1776–1776`
Source SHA-256: `382523bb121248f286dd1dac2d0d74ae3d3fe1e4136b35fd31740a8b64435e31`

The downstream US state-input merge reads this basename under $modified; align the supplied producer's output name without changing the series or sample.

Current text:
```
save "$modified\S_CoVAR_M_inputs_daily", replace
```

Proposed replacement:
```
save "$modified\US_CoVAR_M_inputs_daily", replace
```

Preparation / proposed procedure:

1. Keep the UK, EU and US source macro tables separate and verify their actual fields/units against each branch; these path/name changes do not alter the CoVaR definitions or establish missing market-panel producers.

Validation to perform later:

- Statically confirm the producer/consumer names and roots match exactly, then later compare daily Date keys and required macro columns before any separately authorized model stage.

### A_PROJECT_ROOT: Anchor the configured project root to the initial Stata current directory before the script changes directories, while retaining the author-relative project layout.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_PATH_CONFIG
Evidence: E_BUILD_SCOPE

**Proposed edit:** `01_data_build.do:36–36`
Source SHA-256: `382523bb121248f286dd1dac2d0d74ae3d3fe1e4136b35fd31740a8b64435e31`

Expand the runtime current directory before the subsequent `cd` so `$path` remains a stable root for the original-data, analysis, modified-data and results directories; do not hard-code the Dropbox workspace path.

Current text:
```
global path "..\Regulation_of_Compensation"
```

Proposed replacement:
```
global path "`c(pwd)'\..\Regulation_of_Compensation"
```

Preparation / proposed procedure:

1. Launch from the configured parent directory expected by the existing `..\Regulation_of_Compensation` layout; the `c(pwd)` expression anchors that root before line 39 changes directory.
2. Keep the 00_Original_Data, 01_Analysis, 02_Modified_Data and 03_Raw_Tables subdirectories beneath the anchored root; stage inputs there after their schemas are resolved.

Validation to perform later:

- Before any separately authorized run, confirm how the target Stata host resolves the generated `c(pwd)` path and verify the anchored root and all four subdirectories after the script's `cd`.

### A_MACRO_PATH_FIX: Correct the three confirmed `$modifed` misspellings to the defined `$modified` global in a working copy.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_PATH_MACRO_TYPO
Evidence: E_BUILD_SCOPE, E_MACRO_TYPO_STATIC, E_MACRO_TYPO_MARKIT, E_MACRO_TYPO_CD

**Proposed edit:** `01_data_build.do:1019–1019`
Source SHA-256: `382523bb121248f286dd1dac2d0d74ae3d3fe1e4136b35fd31740a8b64435e31`

The source defines global modified at line 43; correct the misspelled macro while preserving the table basename and merge.

Current text:
```
merge m:1 Type using "$modifed\IDS_Static_update"
```

Proposed replacement:
```
merge m:1 Type using "$modified\IDS_Static_update"
```

**Proposed edit:** `01_data_build.do:1076–1076`
Source SHA-256: `382523bb121248f286dd1dac2d0d74ae3d3fe1e4136b35fd31740a8b64435e31`

The source defines global modified at line 43; correct the misspelled macro while preserving the Markit merge variables.

Current text:
```
merge m:1 redcode year month day using "$modifed\markit_subset_bank_w_avg_last"
```

Proposed replacement:
```
merge m:1 redcode year month day using "$modified\markit_subset_bank_w_avg_last"
```

**Proposed edit:** `01_data_build.do:1142–1142`
Source SHA-256: `382523bb121248f286dd1dac2d0d74ae3d3fe1e4136b35fd31740a8b64435e31`

The source defines global modified at line 43; correct the directory macro while preserving the Analysis destination.

Current text:
```
	cd "$modifed\Analysis"
```

Proposed replacement:
```
	cd "$modified\Analysis"
```

Preparation / proposed procedure:

1. Apply the three exact substitutions to a working copy only; the IDS_Static_update producer remains a separate unresolved requirement.

Validation to perform later:

- Compare all three before/after lines against the frozen source hash and later confirm each intended modified/Analysis path resolves within the staged relative project tree.

### A_MATCH_OUTPUT: Add the missing save token to the supplied matching-result output statement without changing the result path or matching specification.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_MATCH_OUTPUT
Evidence: E_MATCH_OUTPUT, E_FINAL_TARGET

**Proposed edit:** `01_data_build.do:2627–2627`
Source SHA-256: `382523bb121248f286dd1dac2d0d74ae3d3fe1e4136b35fd31740a8b64435e31`

The matching loops have produced results in memory and this following line names the intended output dataset; add the standard Stata save verb and preserve the exact path and replace option.

Current text:
```
"$modified\Master_Accounting_Market_covar_contracts_match", replace
```

Proposed replacement:
```
save "$modified\Master_Accounting_Market_covar_contracts_match", replace
```

Preparation / proposed procedure:

1. Apply this exact output-token repair in a working copy after matching prerequisites are resolved.

Validation to perform later:

- Statically confirm the resulting command is `save` to the named modified-directory file with `replace`; later verify that the output is created after the matching loops.

### A_TEMP_SAVE: Remove the redundant closing quote from the existing temp_2 save path while preserving its name and directory.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_TEMP_SAVE
Evidence: E_TEMP_SAVE

**Proposed edit:** `01_data_build.do:1811–1811`
Source SHA-256: `382523bb121248f286dd1dac2d0d74ae3d3fe1e4136b35fd31740a8b64435e31`

Remove the extra closing quote; the source explicitly names the same `$modified\temp_2` output and no filename choice changes.

Current text:
```
save "$modified\temp_2"", replace
```

Proposed replacement:
```
save "$modified\temp_2", replace
```

Preparation / proposed procedure:

1. Apply this single-character path syntax repair in a working copy.

Validation to perform later:

- Compare the repaired line with the source and confirm later temp_2 reads, if any, use the same unchanged filename.

### A_SOFTWARE_SETUP: Make the four actually invoked Stata commands available in the target Stata 18 adopath before any separately authorized run.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_MDESC, SW_COVAR, SW_PSMATCH2, SW_OUTREG2
Evidence: E_SW_MDESC, E_SW_COVAR, E_SW_PSMATCH2, E_SW_OUTREG2, E_SW_CRCSLBL, E_ENVIRONMENT

Preparation / proposed procedure:

1. Use the project's authorized Stata package source or preserved author bundle to supply mdesc, covar, psmatch2 and outreg2; do not assume that the base Stata installation includes them.

Validation to perform later:

- In the target Stata 18 environment, record the add-on release/source and verify `which mdesc`, `which covar`, `which psmatch2`, and `which outreg2`; also retain the already successful `_crcslbl` check. Do not invoke any risk or matching estimator as a setup test.

### A_RUN_ORDER: Use the supplied 01_data_build.do in authored stage order after its named inputs, producers, paths and add-ons have been resolved. This is a future authorized procedure, not an execution performed in this assessment.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_PREP_PRODUCERS, I_RISK_PRODUCERS, I_VLAB_POPULATION, I_MARKIT_HANDOFF, I_COVAR_HANDOFF
Evidence: E_BUILD_SCOPE, E_HISTORY, E_FINAL_TARGET, E_SOURCE_END, E_PRODUCER_D0016, E_PRODUCER_D0019, E_PRODUCER_D0022, E_PRODUCER_D0028, E_PRODUCER_D0048, E_PRODUCER_D0050

Preparation / proposed procedure:

1. First stage the source tree and validate UK raw inputs, then build MV/P/RI/Return/PTBV/DPS and RI_Market into Master_Market and Master_Market_last; build Sales and each annual account table into Master_Accounting, merge the IDS compensation tables and company map, and produce the UK accounting-market panel. Resolve the missing Master_Market_all_UK producer before the UK Markit and CoVaR consumers.
2. Build the combined EU/US bank tables from their separate BS_* inputs, CIQ/BankScope supplement, EU_flags and UK_FX, then produce BS_Master_Market_last and BS_Master_comp_EU_US. Supply the missing BS_RI_Market_new, BS_Master_Market_RI_update_ck, US_Market_return and BS_Master_Market_RI intermediates and resolve the separate Idio_Risk/BS_Idio_Risk producer recipes.
3. Process wrds_markit.dta into the bank and UK subsets, their annual/monthly spread summaries and downstream CDS merges; verify the identifier/crosswalk inputs and stage each generated subset at the modified-directory consumers.
4. Import lookup.dat, join the EU-membership workbook, save the filtered lookup, read the per-firm VLab series, generate SRISK_VLAB and calculate full-population country-year/quarter aggregates before merging them into the study panel.
5. Run the UK CoVaR input chain, then the separate EU and US chains, preserving each region's macro input, market history and daily/weekly intermediates. Align only the supplied EU/US macro-state paths/output names and verify each Date/schema handoff; do not infer missing market panels or scientific lag/sample rules.
6. Merge the prepared risk panels into Master_Accounting_Market_covar, build Master_Accounting_Market_covar_contracts and then run the annual 2006–2012 UK-bank matches to US/EU plus the <=2009 robustness matches, followed by their outreg2 reports, only after psmatch2/outreg2 and all input/output issues are resolved.

Validation to perform later:

- Before execution, compare the ordered producer-to-consumer names and columns against source reads, confirm the working directory and all files, and verify required Stata commands. This action does not add the appendix's unprovided paper-wide regression drivers to the scope.

### A_BS_RETURN_SPEC: Confirm the intended source for the EU/US bank return variable before changing the colliding gen statement.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_EU_US_BS_RETURN, I_BS_RETURN_OVERWRITE
Evidence: E_BS_RETURN_INPUT, E_BS_RETURN_RENAME, E_BS_RETURN_RECOMPUTE

Preparation / proposed procedure:

1. Clarify whether the imported BS_Return series should be overwritten by the supplied BS_RI ratio formula at line 515, or whether the imported return series should remain the downstream BS_Return value.
2. If the authored design confirms the formula should replace the imported values, changing `gen` to `replace` is the ordinary one-token syntax repair. If the imported series should remain, obtain the exact authored rename/drop/staging remedy without changing the BS_RI formula or sample.

Validation to perform later:

- After the intended variable is confirmed, statically verify the loop's imported and derived columns and downstream merge fields; do not execute the branch or estimate a risk model during this correction pass.


## Remaining issues and prerequisites

- I_UNPACKAGED_DATA [unresolved; full_pipeline]: The package inventory contains the 01_data_build.do source, datasheet, appendix and all_identifiers_final.xlsx, but none of the consumed study panels or raw/prepared tables. The workbook is an identifier list, not a firm-year analysis panel. The named data requirements are retained individually; current local or commercial availability, source fields, keys, units and periods remain unknown rather than blocked.
- I_PREP_PRODUCERS [unresolved; full_pipeline]: The supplied do-file consumes several separately named prepared tables for which it provides no matching producer, including Master_Market_all_UK, BS_RI_Market_new, BS_Master_Market_RI_update_ck, US_Market_return, BS_Master_Market_RI, BS_Master_Market_MV_update_ck, Markit and IDS identifier updates, indg_crosswalk, UK_BIRPU_indicators, EU_US_Bank_indicators, EU_flags, UK_compensation_master, changes_all, and bonus_changes. It also reads all_IDs; the packaged identifier workbook is a plausible crosswalk candidate, but its staging and coverage are unverified. The source supplies some indicator definitions and flags, so this gap concerns file projection/staging, keys and producer-consumer schemas rather than unknown indicator definitions.
- I_RISK_PRODUCERS [unresolved; full_pipeline]: The UK Idio_Risk and EU/US BS_Idio_Risk tables are consumed as prepared inputs, but the supplied program does not define their producer, risk/volatility recipe, fields or sample history. Their contract cannot be replaced by the price/return series without changing the authored risk construction.
- I_VLAB_HANDOFF [preparation; full_pipeline]: The code imports/filter lookup.dat with the EU membership workbook and produces lookup.dta under $modified\Analysis, then reads the generated basename from $data\SRISK_VLab. The matching output exists in the supplied source; changing the consumer to the known producer path is a supported staging edit. The full-population and current-versus-2018 VLab series questions remain separate.
- I_MARKIT_HANDOFF [preparation; full_pipeline]: The code saves markit_bank_subset and markit_uk_subset in the current directory and then reads each under $modified. Aligning the two supplied producers to the existing modified-directory consumers is a supported path edit. The separately consumed markit_identifiers table still has no producer and is tracked in I_PREP_PRODUCERS.
- I_COVAR_HANDOFF [preparation; full_pipeline]: The UK, EU and US macro-state contracts remain separate. The EU branch produces EU_CoVAR_M_inputs_daily under $modified while its consumer uses the same basename under $data; the US branch produces S_CoVAR_M_inputs_daily and later reads a US_CoVAR_M_inputs_daily alias. Aligning these known generated files' paths/names is a supported configuration edit; it does not settle the distinct macro inputs, field mapping or CoVaR sample definitions.
- I_PATH_CONFIG [preparation; full_pipeline]: The script initializes `$path` as a relative ..\Regulation_of_Compensation value and then changes the current directory to `$path\00_Original_Data` before defining the downstream globals. Because that relative macro is re-expanded after the directory change, the project root must be anchored before the first `cd` in a working copy.
- I_PATH_MACRO_TYPO [preparation; full_pipeline]: Three supplied path calls use $modifed while setup defines $modified: the IDS static merge, Markit bank-spread merge, and change to Analysis. Correcting the misspelling is a supported path-configuration edit; it does not produce the missing prepared tables.
- I_MATCH_OUTPUT [preparation; full_pipeline]: The matching stage ends with a bare quoted Master_Accounting_Market_covar_contracts_match target and replace option after the matching results. Adding the ordinary Stata save token preserves the supplied dataset name and matching design.
- I_TEMP_SAVE [preparation; full_pipeline]: The supplied US build has one redundant closing quote after the unchanged `temp_2` filename. Removing that extra quote preserves the specified temporary output path.
- I_VLAB_POPULATION [unresolved; full_pipeline]: The VLab series directory loop concatenates every .dta file in the current outputdata folder, and the later country-year denominator sums SRISK over the loaded firms. The full eligible country/firms population, historical vintage, CSV field/schema compatibility and prevention of stale-file inclusion must be established; study identifiers alone do not provide this denominator.
- I_BS_RETURN_OVERWRITE [unresolved; full_pipeline]: The bank-market input loop includes BS_Return and renames its imported M variable to that name; the later source line generates BS_Return from BS_RI under the same variable name. The source supports a possible gen-to-replace syntax repair only if the computed ratio is meant to overwrite the imported series. Whether to retain imported values or use the derived formula is not established; do not guess a data definition or make the issue a confirmed execution blocker.
- R_CIQ_BANK_SUPPLEMENT [undetermined]: The combined `ciq_banksope` input used to supplement EU/US bank compensation/accounting. The code expects the combined author-prepared table with CTYPE* and DATA* fields; which fields came from Compustat Capital IQ versus Bankscope, and the actual source keys/types, are unresolved. Catalog candidates are discovery evidence only.
- R_UK_FX [undetermined]: The separate UK_FX yearly currency conversion input consumed by the EU/US bank compensation conversion branch. Its producer, source, date convention and expected exchange-rate units are not supplied or established in the package.
- R_MARKIT [undetermined]: The Markit CDS input (`wrds_markit.dta`) and the author's matching identifiers/series needed by the bank and UK CDS branches. Required series, historical vintage, identifiers, row coverage and relationship to the downstream Markit subset files remain unresolved; treat those regional transformations separately from the source input.
- R_OWNERSHIP_UK [undetermined]: The distinct UK hand-collected FactSet_ownership UK file used by the ownership branch, plus its company identifiers, dates, ownership and option-holding fields. The author-prepared file and its field/key contract are not packaged or verified.
- R_OWNERSHIP_EU [undetermined]: The distinct EU FactSet_ownership file read by the supplied script, with the author-collected ownership records and the exact identifiers/period expected by its merge. No compatible file is packaged; regional coverage and schema remain unknown.
- R_OWNERSHIP_US [undetermined]: The separate US FactSet_ownership input referenced by the ownership branch, including the author-collected records and matching key/period. The file is absent from this package and its schema/coverage are unverified.
- R_BANK_TURNOVER [undetermined]: The hand-collected bank CEO forced/unforced turnover and destination-history input (`bank_ceo_turnover`) consumed in the supplied build. Its exact firm/person identifiers, date coding, regional sample and observation history are not supplied.
- R_COVAR_UK [undetermined]: UK daily macro state input `CoVAR_M_inputs.dta`, separately consumed by the UK systemic-risk branch. The code expects UK series including `d3M_Yield_UKTR`, `A10YRTR_3MTR`, `A3MLIBOR_3MTR`, and `Moodys_BAA_TR10YR` alongside the UK market series; source naming, units, dates, joins and full construction history are unverified. The code comment states the downloaded sample starts in 2001 for CoVaR lags, before its 2006–2012 analysis window.
- R_COVAR_EU [undetermined]: EU daily macro state input `CoVAR_M_inputs_EU.dta`, separate from both UK and US contracts. Code expects `d3M_Yield_EUTR`, `A10YREUTR_3MEUTR`, `A3MEURIBOR_3MEUTR`, and `Moodys_BAA_EUTR10YR` alongside EU market series. The datasheet names FactSet and Datastream inputs, but exact dates, units, fields, identifiers and the 2001-plus lag history remain unverified.
- R_COVAR_US [undetermined]: US daily macro state input `CoVAR_M_inputs_US.dta`, distinct from the UK and EU files. Code expects `d3M_Yield_USTR`, `A10YRUSTR_3MUSTR`, `A3MLIBOR_3MUSTR`, `Moodys_BAA_USTR10YR`, and US market fields including `sprtrn`; the datasheet names CRSP, FRED and FactSet. Exact author construction, units, field schema and lag history remain unverified.
- R_EU_MEMBER_WORKBOOK [undetermined]: The exact EU membership workbook imported by the VLab country-filter stage (`eu_member_states 2018-01-12.xlsx`, sheet `data`, range A1:B29 with first row as headers). It is not included in the package; the country-code and membership labels must match the lookup merge.
- R_VLAB_SERIES [undetermined]: Per-firm SRISK/LRMES VLab CSV series for the relevant country population, used to generate `SRISK_VLAB` and later full-country denominator aggregates. The code initializes normalized columns such as date, lrmes, varday, beta, corr_msci, lvg_ratio, srisk and mkt_cap, but the raw CSV schema, 2018 vintage, country/firm population and historical field compatibility are unresolved. Do not restrict this input to study-firm identifiers because the code aggregates across the loaded country population.
- R_VLAB_RAW_LOOKUP [undetermined]: The raw VLab `lookup.dat` file read under the current outputdata directory and used to identify per-firm CSV inputs and country membership. The matching historical lookup, country codes and correspondence to each file's series are unverified.
- R_UK_MV [undetermined]: The UK market-value table `MV` read by the supplied build. Its native field names, units, identifier, date frequency and 2001-start CoVaR history are unverified.
- R_UK_P [undetermined]: The separate UK price table `P` required by the market-input loop. Its price basis, adjustment, identifiers, dates and history are not verified.
- R_UK_RI [undetermined]: The separate UK return-index table `RI` required by the market-input loop. Its return definition, units, date and security key are not verified.
- R_UK_RETURN [undetermined]: The separate UK return table `Return` required by the market-input loop; its construction, frequency and correspondence to RI are unknown.
- R_UK_PTBV [undetermined]: The separate UK price-to-book table `PTBV` required by the market-input loop. Its definition, units and firm/date keys are unverified.
- R_UK_DPS [undetermined]: The separate UK dividend-per-share table `DPS` required by the market-input loop. Its units, adjustment basis, security identifiers and date coverage are unverified.
- R_UK_RI_MARKET [undetermined]: The distinct UK market-benchmark return-index input `RI_Market` merged into firm market construction. Its market scope, return definition, dates and identifier contract are unresolved.
- R_UK_IDIO_RISK [undetermined]: The separate prepared UK idiosyncratic-risk table `Idio_Risk` required by the market build. The supplied source reads it but provides no producer or volatility/risk recipe, field types, identifier mapping or history.
- R_UK_SALES [undetermined]: The UK `Sales` accounting input read separately before the annual-accounting loop. The code describes a Datastream/IDS source context, but the variable's native column, units, identifiers and required history are not verified.
- R_UK_TA [undetermined]: The separate annual UK total-assets input `TA` used in the accounting build; source column, units, identifier and period mapping are unverified.
- R_UK_ROA [undetermined]: The separate annual UK return-on-assets input `ROA` used in the accounting build; source definition, units and row mapping are unverified.
- R_UK_BV [undetermined]: The separate annual UK book-value input `BV` used in the accounting build; its definition and mapping to the code's balance-sheet measures are unverified.
- R_UK_DEBT [undetermined]: The separate annual UK debt input `Debt` used in the accounting build; definition, units and coverage are unverified.
- R_UK_STDEBT [undetermined]: The separate annual UK short-term-debt input `STDebt`; code/source mapping and units are unverified.
- R_UK_LTDEBT [undetermined]: The separate annual UK long-term-debt input `LTDebt`; code/source mapping and units are unverified.
- R_UK_NETDEBT [undetermined]: The separate annual UK net-debt input `NetDebt`; source formula, units and missing-value treatment are unverified.
- R_UK_CASSETS [undetermined]: The separate annual UK current-assets input `CAssets`; source field, units and row coverage are unverified.
- R_UK_CLIABILITIES [undetermined]: The separate annual UK current-liabilities input `CLiabilities`; source field, units and row coverage are unverified.
- R_UK_LIABILITIES [undetermined]: The separate annual UK total-liabilities input `Liabilities`; source field, units and row coverage are unverified.
- R_UK_LIABILITIESSHE [undetermined]: The separate annual UK liabilities-and-shareholders'-equity input `LiabilitiesSHE`; its source definition, units and row coverage are unverified.
- R_UK_STATIC [undetermined]: The separate Thomson Reuters IDS `Static` company/identifier table consumed by the UK accounting build; source identifiers, types and historical joins are unverified.
- R_UK_REMUNERATION [undetermined]: The separate Thomson Reuters IDS `Remuneration` table consumed for compensation measures; imported fields, keys, dates and sample coverage are unverified.
- R_UK_GRANTS [undetermined]: The separate IDS `Grants` table joined to Remuneration; award fields, director/company keys, financial-year dates and coverage are unverified.
- R_UK_LTIP [undetermined]: The separate IDS `LTIP` table joined to the compensation build; award fields, director/company keys, year coding and coverage are unverified.
- R_UK_IDS_COMPANIES [undetermined]: The separate IDS_Companies table used to map company identifiers into the UK accounting/compensation panel; its key uniqueness and mapping coverage are unverified.
- R_EU_US_BS_MV [undetermined]: The separate BS_MV market-value table used by the combined EU/US bank build. Its native measure, units, identifiers and dates are not verified against the authored merge and sample.
- R_EU_US_BS_P [undetermined]: The separate BS_P price table jointly required by the EU/US bank market build; exact adjustment basis, field name, firm key and history are unresolved.
- R_EU_US_BS_RI [undetermined]: The separate BS_RI return-index table used in EU/US bank market construction; definition, units, identifiers and dates are not established.
- R_EU_US_BS_RETURN [undetermined]: The separate BS_Return input table is loaded by the EU/US bank-market loop. The source later generates a same-named BS_Return value from BS_RI without an intervening drop; whether the supplied series is intended to be recomputed or retained is unresolved. Its native return definition, units, identifiers and history also remain unverified.
- R_EU_US_BS_PTBV [undetermined]: The separate BS_PTBV table used in the EU/US bank market build; exact definition, scale, identifiers and coverage are unverified.
- R_EU_US_BS_IDIO_RISK [undetermined]: The distinct prepared EU/US bank idiosyncratic-risk input merged into BS market construction. No producer, risk/volatility recipe, field contract, firm-date key or required history appears in the supplied program; do not substitute the price/return series for it.
- R_EU_US_BS_DPS [undetermined]: The separate BS_DPS dividend input consumed by the EU/US bank build; currency, per-share basis, adjustment conventions and dates are unresolved.
- R_EU_US_BS_NI [undetermined]: The separate EU/US bank net-income input BS_NI; accounting-period key, units, source field and coverage are not verified.
- R_EU_US_BS_TA [undetermined]: The separate EU/US bank total-assets input BS_TA; units, period dates, identifier and source mapping are unresolved.
- R_EU_US_BS_ROA [undetermined]: The separate EU/US bank return-on-assets input BS_ROA; definition, units, accounting period and source mapping are unresolved.
- R_EU_US_BS_SALES [undetermined]: The separate EU/US bank sales input BS_Sales; unit, fiscal-year coding, source field and coverage remain unverified.
- R_UK_MASTER_MARKET_ALL [undetermined]: The prepared UK market panel `Master_Market_all_UK` used by the Markit and UK CoVaR branches. No compatible producer or source table schema is supplied in this program.
- R_EU_BS_RI_MARKET_NEW [undetermined]: The prepared EU market-return panel `BS_RI_Market_new.dta` required for EU CoVaR construction. Its producer, date/return fields and coverage are unresolved in this release.
- R_EU_BS_MASTER_MKT_RI_UPDATE [undetermined]: The prepared EU bank market panel `BS_Master_Market_RI_update_ck.dta` consumed by the EU systemic-risk branch. No producer or schema contract is present in the supplied code.
- R_US_MARKET_RETURN [undetermined]: The prepared US market-return panel `US_Market_return.dta` consumed by US CoVaR construction. Its return series, date key, producer and required history are unresolved.
- R_US_BS_MASTER_MKT_RI [undetermined]: The prepared US bank market/return input `BS_Master_Market_RI` consumed by the US risk branch. No producer or input schema appears in the supplied source.
- R_EU_US_BS_MASTER_MKT_MV_UPDATE [undetermined]: The prepared EU/US bank market-value update table referenced by the build; its producer, field contract, region coverage and relationship to the BS_* tables are unresolved.
- R_MARKIT_IDENTIFIERS [undetermined]: The prepared Markit-to-firm identifier mapping `markit_identifiers` consumed by the CDS merge. Its producer, company/security identifiers and link history are not supplied.
- R_IDS_STATIC_UPDATE [undetermined]: The prepared IDS static-type mapping `IDS_Static_update` consumed by Markit matching. Its producer, key/type semantics and current `modified` path are unresolved.
- R_IDS_STATIC_UPDATE_ISIN [undetermined]: The separate prepared IDS/ISIN mapping `IDS_Static_update_isin` consumed by the Markit merge. Its producer, field semantics, key uniqueness and coverage are unresolved.
- R_INDUSTRY_CROSSWALK [undetermined]: The industry-group crosswalk `indg_crosswalk` used to map the CDS panel. Its producer, labels, identifier key and coverage are not supplied.
- R_UK_COMPENSATION_MASTER [undetermined]: The prepared UK compensation master input used in downstream changes; its producer, compensation fields, company/director keys and sample definition are unresolved.
- R_CHANGES_ALL [undetermined]: The prepared `changes_all` input consumed in the UK compensation-change branch. Its event definition, keys, sample period and producer are not supplied.
- R_BONUS_CHANGES [undetermined]: The separate prepared `bonus_changes` input consumed in the compensation-change branch. Its event definition, keys, period and producer remain unresolved.
- R_UK_BIRPU_INDICATORS [undetermined]: The source explicitly defines UK_BIRPU from a listed set of ISINs in the UK build, and separately merges a `UK_BIRPU_indicators` table in the risk branch. The indicator definition is supplied; whether the separately named table can be projected/staged from it, and the required Type key, row coverage and join contract, remain unresolved.
- R_EU_US_BANK_INDICATORS [undetermined]: The source explicitly constructs UK_Bank, US_Bank, EU_Bank and EU_Bank_x_UK flags from country/EU membership in the bank build, and separately merges `EU_US_Bank_indicators` later. The flag definitions are supplied; the separately named table's projection/staging, Type key and row coverage still require reconciliation.
- R_ALL_IDS [undetermined]: The prepared all_IDs crosswalk is consumed by an ISIN merge. The packaged `all_identifiers_final.xlsx` has a bounded probe showing CIQ_companyid, DS_Type, isin and sedol and is a candidate source for this table, but author-prescribed import names, exact keys, full coverage and compatibility with the merge remain unverified.
- R_EU_FLAGS [undetermined]: The prepared country-code EU membership flags table used in the bank sample build. Its producer, country codes, date-vintage and membership definition are unverified.
- R_COUNTRY_CROSSWALK [undetermined]: The country/country-code crosswalk used in the systemic-risk and country-denominator branches. Its producer, code system, country labels and full coverage are unresolved.
- SW_MDESC [preparation_required]: The source invokes mdesc. Stata 18 `which mdesc` returned 111; set up the required add-on through the normal package channel before any authorized author-code run.
- SW_COVAR [preparation_required]: The UK/EU/US systemic-risk branches invoke covar. Stata 18 `which covar` returned 111; the command must be made available before any authorized run. No estimator was invoked during this assessment.
- SW_PSMATCH2 [preparation_required]: The matching stage invokes psmatch2. Stata 18 `which psmatch2` returned 111; set up the command before any authorized matching run.
- SW_OUTREG2 [preparation_required]: The matching stage invokes outreg2. Stata 18 `which outreg2` returned 111; set up this reporting add-on before any authorized matching run.

## Review notes

- Read the complete cached 2,793-line Stata source, the full datasheet and the full online appendix. The assessed scope is the single supplied 01_data_build.do workflow, including its UK, EU, US, VLab, Markit, compensation and matching branches. The appendix's regression tables are publication context; no separate paper-wide regression/table driver is included in this package.
- The only workbook is all_identifiers_final.xlsx. Its bounded probe reads one row and reports CIQ_companyid, DS_Type, isin and sedol; it is a candidate crosswalk for all_IDs, with source/import mapping and coverage unresolved, and it is not a firm-year analysis panel. No analysis_only scope is supported.
- The source comments identify a 2006–2012 main period and a 2001-start downloaded sample for CoVaR lags. UK, EU and US market/state-input contracts remain separate. VLab country-year denominators use all loaded positive-SRISK firms, so the full relevant country/firm population and the prevention of stale .dta inputs remain unresolved.
- The datasheet names IDS, Datastream, Compustat Capital IQ/Global, Bankscope, Markit, FactSet/financial statements, CRSP/FRED and VLab sources. Commercial entitlement and compatible exports were not established by catalog metadata. The datasheet's IDS proprietary statement conflicts with its later no-proprietary-data statement; no access barrier was inferred. Current official VLab download guidance is a public candidate but is not verified against the authors' January 2018 per-firm files.
- Only bounded Stata 18 `which` checks for commands invoked by this source were performed. mdesc, covar, psmatch2 and outreg2 were not found; _crcslbl was found. No author code, risk model, matching routine or regression was run, and no software or data were installed or acquired.
- Preservation limitation: the copied feasibility helper source was saved before its failed help invocation and the failure is retained. Initial resource/catalog helper calls imported packages.py/resources.py before both imported helper bytes had been copied into probes; the snapshots saved later are not represented as the original first-execution bytes, and the missing prior bytes were not reconstructed. The captured failed-helper and bare-python subcommand attempts are retained with commands, return codes and separate streams.
- A narrow correction pass now proposes a stable `c(pwd)`-anchored project root before the initial `cd`, adds the supplied matching output's ordinary save token, and removes the redundant quote in the existing temp_2 target. These are preparation edits only; no source was modified or run.
- The EU/US bank branch imports BS_Return in its market loop and later attempts to generate BS_Return from BS_RI under the same name. The input-versus-derived return definition is retained as unresolved; gen-to-replace is mentioned only as a conditional syntax remedy if that is the authored intent.
