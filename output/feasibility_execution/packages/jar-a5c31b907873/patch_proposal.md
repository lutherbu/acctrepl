# Patch proposal: jar-a5c31b907873

The Decision Relevance of Loan Fair Values for Depositors

DOI: 10.1111/1475-679X.12564

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author workflow: SNL/SOD data preparation, Call Report–SNL/Berger–Bouwman merges, quarterly variable construction, main-text analyses and online appendix including the OA4 branch.

Entry points: `Data_Package (JAR Submission)/1. Process SNL data and SOD data/1a. Process SNL financial statement data.sas`, `Data_Package (JAR Submission)/1. Process SNL data and SOD data/1b. Compute SNL fiscal quarter end dates.do`, `Data_Package (JAR Submission)/1. Process SNL data and SOD data/1c. Generate final SNL dataset.sas`, `Data_Package (JAR Submission)/1. Process SNL data and SOD data/1d. Process and construct SOD data.sas`, `Data_Package (JAR Submission)/2. Merge datasets and construct variables/2a. Merge call report and SNL datasets.sas`, `Data_Package (JAR Submission)/2. Merge datasets and construct variables/2b. Construct a smaller dataset with key variables.do`, `Data_Package (JAR Submission)/2. Merge datasets and construct variables/2c. Merge aggregate deposit data and construct final variables.do`, `Data_Package (JAR Submission)/3. Regression Analyses/3a. Main tables.do`, `Data_Package (JAR Submission)/3. Regression Analyses/3b. Online appendix.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 1/12564 - The-Decision-Relevance-of-Loan-Fair-Values-for-Depositors/cvw-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "85e2311565028e09a0f544322b55a84de440fddb61f90df7e98c339b19928d2d"
    },
    {
      "path": "JAR-Volume 63/Issue 1/12564 - The-Decision-Relevance-of-Loan-Fair-Values-for-Depositors/cvw-online-appendix.pdf",
      "sha256": "06386d044f6671aa0f9ce21b8f0de24c36e864ed4bc30d79ba6e676937416fef"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "eb83bcec93b43a49f8596f9b0c61f3f32e4bf268716872df8e90ab7d0483729c"
}
```

## Proposed actions

### A_CALLREPORT: Obtain the author-prepared callreport1_2 table or its exact producer recipe, source queries, field mapping and date coverage for the WRDS/SNL combination.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CALLREPORT, I_CLOSURE, I_HISTORY
Evidence: E_DOC_CALL, E_CODE_CALL, E_CODE_CALL_FIELDS_A, E_CODE_CALL_FIELDS_B, E_CODE_CALL_FIELDS_C, E_CODE_HIST_LEADS

Preparation / proposed procedure:

1. Confirm the author-documented WRDS pre-2014 and SNL 2014–2019 source split and identify whether the prepared table or complete source inputs will be supplied.
2. Confirm rssd9001, rssd9999, bank identifiers and every active Call Report field listed in the 2a summary block, including the year-to-date/quarter-to-date transition.
3. Confirm complete panel endpoints and the history needed to construct the 11-quarter rolling window and outcomes through quarter 12.

Validation to perform later:

- In a separately authorized metadata/run workflow, verify the prepared SAS table has the required identifiers, date and active Call Report columns and covers the confirmed construction/sample history.

### A_QTRNUM: Convert the packaged qtrnum.xlsx mapping to the qtrnum SAS table in the Data library; preserve its year, quarter and code mapping.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_QTRNUM
Evidence: E_DOC_QTRMAP, E_CODE_QTR, E_CODE_QTR_2A, E_QTR_PROBE

Preparation / proposed procedure:

1. Resolve the author Data-library path in a portable working copy and import the packaged workbook as qtrnum.sas7bdat.

Validation to perform later:

- In a separately authorized workflow run, confirm every year-quarter code required by the SNL, Call Report and 2a joins is present.

### A_WEIGHTS: Stage the verified packaged weights_y9c.dta under Data/LMI and use the supplied 2a date-to-year/quarter derivation and merge. Exact endpoints were not sampled; retain panel-date coverage as a future workflow validation check, not a route-availability requirement.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_LIQUIDITY_WEIGHTS
Evidence: E_CODE_WEIGHTS_ROUTE, E_WEIGHT_PROBE, E_PUBLIC_BAI

Preparation / proposed procedure:

1. Copy the packaged file byte-for-byte into the portable working copy's Data/LMI directory, as the supplied 2a input path expects.
2. Use 2a's supplied date-to-year/quarter derivation and merge on year and quarter; no separate qtrnum mapping or data conversion is required for this weights route.

Validation to perform later:

- During a separately authorized workflow, compare the actual file date coverage with the required panel dates and the author-reported 2002Q2–2015Q1 period; this is a coverage check after local route availability has been established.

### A_SAS: Confirm an authorized SAS 9.4 runtime and required SAS/ETS PROC EXPAND capability through approved metadata, then configure a separate portable working copy.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_SAS
Evidence: E_ENV_PROBE, E_CODE_EXPAND

Preparation / proposed procedure:

1. Keep the original package unchanged and use a coherent relative or [redacted-path-b70287d0a31e] execution root.

Validation to perform later:

- Before a separately authorized workflow run, verify SAS 9.4 and PROC EXPAND are available without starting SAS during this assessment.

### A_SNL_INPUT: Obtain the SNL bank financial statement panel via the author-documented Office add-in route, use the packaged field list to rename its fields in Excel, and stage the resulting SAS table as Data/financialdata.sas7bdat.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_SNL_FINANCIAL, R_SNL_FIELDLIST, S_EXCEL, S_CIQ_OFFICE_ADDIN
Evidence: E_DOC_SNL, E_DOC_QTRMAP, E_CODE_SNL, E_SNL_FIELDS_PROBE, E_DOC_NONPROPRIETARY

Preparation / proposed procedure:

1. Confirm an authorized Capital IQ Pro Office add-in and Excel environment for the documented manual collection/rename stage.
2. Use the packaged SNL Data Field List to map the SNL keys to the SAS names required by 1a and 2a; preserve SNLid, fqe/year/quarter, bank identifiers, SNL_NCO, FV/CV fields and fvfreq.
3. Stage the converted SAS dataset under the configured Data root and document its complete date coverage and any type conversion.

Validation to perform later:

- In a separately authorized metadata/run workflow, confirm the staged SNL panel contains the documented identifiers and valuation variables for the required panel history.

### A_SOD_INPUT: Acquire the 29 annual FDIC Summary of Deposits CSV members required by the 1d macro and stage them together in its SOD input folder.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_SOD
Evidence: E_DOC_SOD, E_PUBLIC_FDIC, E_CODE_SOD_IMPORT, E_CODE_SOD_CONVERT, E_CODE_SOD_FIELDS

Preparation / proposed procedure:

1. Use the official FDIC Summary of Deposits annual survey interface for the exact author-required years; no CSV payload was requested during this assessment.
2. Retain the institution, branch, state, year and deposit fields required by 1d and preserve each annual file as a separate CSV member.
3. Allow the supplied SAS conversion macro to convert its listed fields before stacking the 29 members.

Validation to perform later:

- In a separately authorized run, confirm the 29 staged CSVs have the expected columns and numeric fields and that the required institution/year coverage is present.

### A_BB_INPUTS: Obtain both Berger–Bouwman liquidity-creation CSVs through an authorized author route and keep their independent historical coverage contracts.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_BB_8498, R_BB_9916
Evidence: E_DOC_BB, E_CODE_BB_FILES, E_CODE_BB_JOIN

Preparation / proposed procedure:

1. Obtain LCitemswebsite8498_B2016.csv and LCitemswebsite9916_B2016.csv from an authorized author source; the unsuccessful static page request did not establish route absence.
2. Confirm each file supplies rssd9001, date, catfat, gta, lc_l and lc_a, and document the actual date range rather than inferring it from the filename.

Validation to perform later:

- In a separately authorized bounded metadata/run workflow, confirm both files load, stack, and join to the Call Report panel on rssd9001/date.

### A_FEDFUNDS: Obtain the exact monthly Fed Funds series or author-prepared WRDS table used for ff_o, with its units, source definition and history.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_FEDFUNDS
Evidence: E_DOC_FEDFUNDS, E_CODE_FED_MKT, E_CATALOG_FEDFUNDS

Preparation / proposed procedure:

1. Confirm the author-required monthly date and ff_o contract and stage the resulting panel as Data/fedfundrate20200616.sas7bdat.

Validation to perform later:

- In a separately authorized metadata/run workflow, confirm monthly date coverage and PROC EXPAND quarterly averages across the required panel history.

### A_MKTRETURN: Verify the local CRSP.MSI monthly vwretd candidate's required history before using it as the author panel; otherwise obtain the exact prepared WRDS market-return file.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_MKTRETURN
Evidence: E_CODE_FED_MKT, E_CRSP_MSI_CATALOG, E_CRSP_MSI_PROBE

Preparation / proposed procedure:

1. Confirm that CRSP.MSI's monthly DATE/vwretd coverage and series definition match the author-prepared mktreturn20200616 input for the Call Report/SNL panel.
2. Stage the validated monthly panel under Data/mktreturn20200616.sas7bdat or document a consistent same-data import path.

Validation to perform later:

- In a separately authorized bounded metadata/run workflow, verify monthly endpoint coverage and quarterly averaging by PROC EXPAND.

### A_FRED_DEPOSITS: Acquire the public FRED DPSACBM027NBOG monthly series as the CSV input named by 2c and reconcile the downloaded header/date format with the authored import.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_FRED_DEPOSITS
Evidence: E_DOC_FRED, E_PUBLIC_FRED, E_CODE_FRED, E_CODE_HIST_LEADS

Preparation / proposed procedure:

1. Use the FRED series page to obtain the exact series as CSV; no dataset payload was requested during this assessment.
2. Confirm that the import exposes a date field and a DPSACBM027NBOG value column compatible with the Stata names used in 2c.
3. Retain monthly observations far enough beyond each used quarter to support the one-month lead and subsequent two-quarter lead in the authored growth formula.

Validation to perform later:

- In a separately authorized metadata/run workflow, confirm the CSV date parser, monthly units/history and final agg_dep_gr observations.

### A_SAS_SETUP: Confirm an authorized SAS 9.4 runtime and SAS/ETS PROC EXPAND capability before a future workflow run.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_SAS, S_SAS_ETS
Evidence: E_ENV_PROBE, E_CODE_EXPAND, E_CODE_SOD_IMPORT

Preparation / proposed procedure:

1. Check SAS and PROC EXPAND availability through an approved metadata method without starting SAS during this assessment.
2. Configure the future run to use the same portable Data root and preserve the SAS/ETS requirement for the monthly-to-quarter transformations.

Validation to perform later:

- Before a separately authorized workflow run, record SAS version/capability metadata and confirm PROC EXPAND can be invoked without loading author data.

### A_STATA_ADDONS: Prepare the four unavailable Stata commands used by the supplied stages while retaining the already available Stata 18, reghdfe, ftools and rangestat.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_MDESC, S_UNIVAR, S_WINSOR2, S_OUTREG2
Evidence: E_ENV_PROBE, E_SW_MDESC_PROBE, E_SW_UNIVAR_PROBE, E_CODE_MDESC, E_CODE_UNIVAR_WINSOR2, E_CODE_ANALYSIS_ADDONS

Preparation / proposed procedure:

1. Install or configure mdesc, univar, winsor2 and outreg2 in the Stata ado path using the user's authorized software-management process.
2. Verify each exact command with a metadata-only which check; do not run the supplied programs as part of setup.

Validation to perform later:

- Confirm exact command resolution for all four names before a separately authorized workflow run.

### A_SNL_OFFICE_SETUP: Confirm the documented Excel and Capital IQ Pro Office add-in environment for SNL collection and manual field renaming.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_EXCEL, S_CIQ_OFFICE_ADDIN, R_SNL_FINANCIAL, R_SNL_FIELDLIST
Evidence: E_DOC_SNL, E_DOC_QTRMAP, E_SNL_FIELDS_PROBE

Preparation / proposed procedure:

1. Use an authorized Office environment with the Capital IQ Pro add-in and the packaged SNL Data Field List workbook; the workbook itself is already available.

Validation to perform later:

- Before SNL collection, confirm the add-in can export the fields needed by the supplied SAS preparation code and that Excel can apply the documented crosswalk.

### A_PATH_SETUP: Choose one portable working root and resolve the supplied SAS Data-library and Stata Code/Data placeholders consistently across every stage.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_PATH_SETUP
Evidence: E_CODE_PATH_STATA, E_CODE_PATH_SAS_1D, E_CODE_PATH_SAS_2A, E_CODE_2A_DS_LARGER, E_CODE_2B_DS_LARGER_READ, E_CODE_SOD_EXPORT, E_CODE_2C_BANKSTATES_READ

Preparation / proposed procedure:

1. Preserve the author folder structure with explicit Data and Code roots in a working copy; use relative paths or approved [redacted-path-b70287d0a31e] paths only.
2. Resolve the SAS LIBNAME and export destinations and the Stata global runpath/input paths so the documented 1d-to-2c and 2a-to-2b file handoffs refer to the same outputs.
3. Stage weights_y9c.dta under Data/LMI and keep every producer/consumer rooted consistently.

Validation to perform later:

- Before a separately authorized workflow run, verify each configured producer output path matches the next script's consumer path without changing data definitions.

### A_HISTORY: Confirm complete source history for the bank-quarter panel and monthly macro inputs against the exact supplied lag, rolling-window and future-outcome operations.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_HISTORY, R_CALLREPORT, R_SNL_FINANCIAL, R_FEDFUNDS, R_MKTRETURN, R_FRED_DEPOSITS
Evidence: E_CODE_HIST_ROLLING, E_CODE_HIST_LEADS, E_CODE_FRED, E_DOC_CALL

Preparation / proposed procedure:

1. Identify the retained estimation quarter range and source endpoints for Call Report, SNL, Fed Funds and market-return inputs.
2. Retain at least the required prior history for the 11-quarter rolling statistic and future observations through quarter 12; extend the monthly FRED series enough to support the nested one-month and two-quarter forward operations.
3. Document the selected sample range separately from construction-history needs.

Validation to perform later:

- In a separately authorized metadata/run workflow, check the actual date endpoints and missing leads/lags for each input before analyzing results.

### A_OA4: Preserve the unchanged main pass first. For OA4, rerun a separate working copy from the same original upstream 2c inputs: activate filter 260 before winsorization and save 305, while disabling baseline save 304 only in that OA4 variant. Never derive OA4 by filtering the already-winsorized FV_clean_main.dta.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_OA4
Evidence: E_CODE_OA4_FILTER_COMMENT, E_CODE_OA4_SAVE_COMMENT, E_CODE_OA4_CONSUMER, E_CODE_2C_FINAL_WRITE

**Proposed edit:** `Data_Package (JAR Submission)/2. Merge datasets and construct variables/2c. Merge aggregate deposit data and construct final variables.do:260–260`
Source SHA-256: `165393c83f0b2f87211bd912a65560d0e7bfb7ba342802e2d3282a74ffa9f736`

In the OA4-only working copy, activate the source-labeled sample filter before the supplied winsorization operations; leave it commented in the unchanged baseline pass.

Current text:
```
	*drop if diff_dep_scaled < -0.02 | diff_dep_scaled > 0.02 //apply this criteria to generate FV_clean_OA4.dta used for Table OA4
```

Proposed replacement:
```
	drop if diff_dep_scaled < -0.02 | diff_dep_scaled > 0.02 //apply this criteria to generate FV_clean_OA4.dta used for Table OA4
```

**Proposed edit:** `Data_Package (JAR Submission)/2. Merge datasets and construct variables/2c. Merge aggregate deposit data and construct final variables.do:304–304`
Source SHA-256: `165393c83f0b2f87211bd912a65560d0e7bfb7ba342802e2d3282a74ffa9f736`

Comment out the baseline FV_clean_main save only in the OA4-only variant so the filtered rerun cannot replace the main-pass dataset; the unchanged baseline pass retains the original active save.

Current text:
```
save FV_clean_main.dta, replace 
```

Proposed replacement:
```
*save FV_clean_main.dta, replace 
```

**Proposed edit:** `Data_Package (JAR Submission)/2. Merge datasets and construct variables/2c. Merge aggregate deposit data and construct final variables.do:305–305`
Source SHA-256: `165393c83f0b2f87211bd912a65560d0e7bfb7ba342802e2d3282a74ffa9f736`

Activate the existing OA4-labeled save in the separate variant after the supported filter and winsorization steps.

Current text:
```
*save FV_clean_OA4.dta, replace     //Save the dataset to be used for Table OA4
```

Proposed replacement:
```
save FV_clean_OA4.dta, replace     //Save the dataset to be used for Table OA4
```

Preparation / proposed procedure:

1. Run the supplied 2c source unchanged from its original upstream inputs, keeping filter 260 and OA4 save 305 commented, to create baseline FV_clean_main.dta for the main analysis.
2. Create a separate OA4-only working copy from the original 2c source and rerun it from the same original upstream inputs; do not use the already-winsorized FV_clean_main.dta as the variant input.
3. Only in the OA4 variant, activate filter 260 before winsorization, comment out baseline save 304, and activate OA4 save 305. Keep the original baseline script and its output untouched.
4. After both products exist, run 3a against FV_clean_main.dta and 3b with both FV_clean_main.dta and FV_clean_OA4.dta available for their supplied consumers.

Validation to perform later:

- In a separately authorized workflow, verify the unchanged 2c pass produces FV_clean_main.dta, then verify the OA4-only variant starts from the same original upstream inputs, produces FV_clean_OA4.dta, and does not overwrite the baseline output.
- Confirm 3a consumes the retained baseline product and 3b consumes both the baseline and OA4 products. No author workflow was run during this assessment.

### A_RUN_SEQUENCE: Run the complete cross-language author workflow in producer-consumer order, preserving the unchanged main-data pass and producing the OA4 variant separately from the same original upstream inputs.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R_CALLREPORT, R_SNL_FINANCIAL, R_QTRNUM, R_LIQUIDITY_WEIGHTS, R_SOD, R_SNL_FIELDLIST, R_BB_8498, R_BB_9916, R_FEDFUNDS, R_MKTRETURN, R_FRED_DEPOSITS, S_STATA, S_REGHDFE, S_FTOOLS, S_RANGESTAT, S_MDESC, S_UNIVAR, S_WINSOR2, S_OUTREG2, S_SAS, S_SAS_ETS, S_EXCEL, S_CIQ_OFFICE_ADDIN, I_CLOSURE, I_HISTORY, I_PATH_SETUP, I_OA4
Evidence: E_CODE_SNL_STAGE_A, E_CODE_SNL_STAGE_A_EXPORT, E_CODE_SNL_STAGE_B, E_CODE_SNL_STAGE_C_INPUT, E_CODE_SNL_STAGE_C_OUTPUT, E_CODE_SOD_IMPORT, E_CODE_SOD_STATES, E_CODE_SOD_EXPORT, E_CODE_BB_FILES, E_CODE_CALL, E_CODE_FED_MKT, E_CODE_WEIGHTS_ROUTE, E_CODE_2A_DS_LARGER, E_CODE_2B_DS_SMALL_WRITE, E_CODE_2C_FINAL_WRITE, E_CODE_3A_MAIN_READ, E_CODE_3B_MAIN_READ, E_CODE_OA4_CONSUMER, E_CODE_2B_DS_LARGER_READ

Preparation / proposed procedure:

1. Configure the shared Data and Code roots; stage the SNL financialdata panel, qtrnum mapping, FDIC SOD CSV members, both Berger–Bouwman files, prepared Call Report panel, monthly Fed Funds and market-return panels, FRED deposits CSV and packaged liquidity weights.
2. Run 1a SAS to create financialdata2_fqecode2.dta and financialdata2_nofqecode.sas7bdat.
3. Run 1b Stata to fill fiscal-quarter codes and save financialdata2_fqecode3.dta; then run 1c SAS to produce Data/financialdata2.sas7bdat.
4. Run 1d SAS to import and stack SOD files, create states.sas7bdat and export Bank_States_06032023.dta.
5. Run 2a SAS after all prepared inputs are staged; it merges Call Report, Berger–Bouwman, SNL, SOD, macro panels and weights and exports ds_larger.dta.
6. Run 2b Stata after 2a exports ds_larger.dta: read that same supplied ds_larger panel and create ds_small.dta before either 2c pass.
7. Run the supplied 2c source unchanged from the original upstream inputs with OA4 filter 260 and save 305 still commented, producing baseline FV_clean_main.dta for the main analysis.
8. For OA4, create a separate 2c working copy and rerun from the same original upstream inputs; only in that variant, activate filter 260 before winsorization, comment out baseline save 304, and activate OA4 save 305. Do not filter the already-winsorized FV_clean_main.dta, and do not let the variant overwrite it.
9. Run 3a using the unchanged FV_clean_main.dta baseline; run 3b after both FV_clean_main.dta and FV_clean_OA4.dta are available for its supplied consumers.

Validation to perform later:

- In a separately authorized workflow, verify the 2a ds_larger.dta export is the 2b input and 2b creates ds_small.dta before both 2c passes; also verify the unchanged main 2c baseline is retained while the separate OA4 variant uses the same original upstream inputs without replacing it.


## Remaining issues and prerequisites

- I_CLOSURE [unresolved; full_pipeline]: The supplied programs consume Data/callreport1_2.sas7bdat, but no supplied stage creates it; the datasheet documents the WRDS/SNL source split without the combining construction or complete table specification.
- I_HISTORY [unresolved; full_pipeline]: The supplied pipeline requires an 11-quarter rolling history, outcomes through future quarter 12, and monthly FRED leads followed by quarterly leads. Exact panel/sample endpoints are not specified by the inputs currently available, so source-history sufficiency cannot be determined.
- I_PATH_SETUP [preparation; full_pipeline]: SAS library/data-file paths and Stata Code/Data roots still contain ellipsis placeholders. Resolve them in a portable working copy and align the supplied cross-language outputs and consumers before a future run.
- I_OA4 [preparation; full_pipeline]: Online appendix 3b consumes FV_clean_OA4.dta. The supplied 2c source includes the labeled OA4 filter and save as comments, so the branch is supported preparation: first run unchanged 2c to preserve baseline FV_clean_main.dta; then run an OA4-only working copy from the same original upstream inputs, activating the filter before winsorization and the OA4 save while disabling the baseline save only in that variant. No source edits were applied.
- R_CALLREPORT [undetermined]: Prepared Call Report panel consumed as Data/callreport1_2.sas7bdat. Stage 2a needs rssd9001/rssd9999 for the Berger–Bouwman join, the bank identifiers and date, and the active Call Report item fields listed in its summary block. The datasheet documents WRDS before 2014 and SNL for 2014–2019; no supplied program creates the prepared table.
- R_SNL_FINANCIAL [undetermined]: S&P Capital IQ Pro/SNL financial statement panel staged as Data/financialdata.sas7bdat. The SAS preparation filters public entities, derives fiscal-year/quarter codes, and later merges bank fair/book values and SNL NCO. The author documents Office add-in retrieval and Excel field renaming with the supplied crosswalk.
- R_SOD [undetermined]: FDIC Summary of Deposits annual CSV set imported from the SOD folder by 1d; the author macro names 29 imported members. The code uses branch, institution, geography, year and deposit fields to build the SOD panel.
- R_BB_8498 [undetermined]: First Berger–Bouwman liquidity-creation CSV, LCitemswebsite8498_B2016.csv, independently imported into SAS and stacked with the second file.
- R_BB_9916 [undetermined]: Second Berger–Bouwman liquidity-creation CSV, LCitemswebsite9916_B2016.csv, independently imported into SAS and stacked with the first file.
- R_FEDFUNDS [undetermined]: Separate monthly Federal Funds rate panel used by 2a and averaged to quarters before merging.
- R_MKTRETURN [undetermined]: Monthly market-return panel used by 2a and averaged to quarters as vwretd.
- R_FRED_DEPOSITS [undetermined]: Monthly FRED aggregate deposits series DPSACBM027NBOG, imported from CSV and used to construct quarterly deposit growth.
- S_SAS [unverified]: SAS author code is supplied, but the original registered environment probe leaves SAS availability unverified; no SAS executable was started.
- S_MDESC [preparation_required]: Exact Stata metadata probe reports mdesc unavailable; 1b invokes it.
- S_UNIVAR [preparation_required]: Exact Stata metadata probe reports univar unavailable; 2c invokes it.
- S_WINSOR2 [preparation_required]: Original registered environment probe reports the exact Stata command winsor2 unavailable; 2c uses it for sample variables.
- S_OUTREG2 [preparation_required]: Original registered environment probe reports the exact Stata command outreg2 unavailable; 3a/3b use it for results tables.
- S_SAS_ETS [unverified]: SAS 2a invokes PROC EXPAND for quarterly conversion; SAS/ETS availability is unverified.
- S_EXCEL [unverified]: The documented SNL field-renaming stage uses Excel; this software was not verified in the registered environment.
- S_CIQ_OFFICE_ADDIN [unverified]: The datasheet documents the Office add-in as the SNL data collection route; current add-in access is unverified.

## Review notes

- The assessed target is the complete supplied full-pipeline workflow; no analysis_only scope is supported because 3a/3b consume the 2c-produced analysis datasets and no compatible author-prepared analysis dataset route is supplied.
- All 33 frozen dependency IDs are covered exactly once. Generated rows cite active producers of the named logical products. The ds_larger and Bank_States outputs are treated as supplied generated handoffs; resolving the authored Data/Code root placeholders is ordinary working-copy preparation.
- The datasheet states that none of the data were obtained from an organization on a proprietary basis. No access barrier is inferred from catalog misses, vendor labels or failed static-page requests; routes remain unverified where present access, field compatibility or history is not established.
- The exact supplied weights_y9c.dta route is locally available: the bounded packaged-file check confirmed date and awgt_loan_ORG0, and supplied 2a derives year and quarter from date for its join. The author page reports 2002Q2–2015Q1, but exact supplied-file endpoints were not sampled; compare them with required panel dates during future workflow validation. Data/LMI staging is preparation, not an availability gate.
- The main unresolved scientific input is the prepared callreport1_2 table and its producer/schema. Required panel history remains unknown against the explicit 11-quarter rolling and 12-quarter forward operations. OA4 is a supported preparation variant: run unchanged 2c first for the baseline, then rerun an OA4-only working copy from the same original upstream inputs with the filter before winsorization, the OA4 save active, and baseline save 304 disabled only in that variant.
- The public-page request record at probes/public_page_attempts.json (SHA-256 0a5a9f6e39782748fb1358c47e7301f361bb75b2bbbbb607950930effc29ce27) is process-only and its evidence row is intentionally unreferenced. It records the unsuccessful Berger–Bouwman page request and FDIC page fetch limitations; neither is used as proof of a data barrier or absent route.
- The initial CRSP request and mdesc redirect failure are preserved in their failed-attempt JSON descriptors and addenda; they were orchestration/no-child failures, not evidence of missing data or unavailable software. The corrected CRSP and Stata metadata results are the evidence used.
- Raw author logs were kept opaque because of license/identity content. No author program, research data, model/statistical routine or dataset payload was executed, installed, downloaded or edited during this assessment; execution_verified remains false.
