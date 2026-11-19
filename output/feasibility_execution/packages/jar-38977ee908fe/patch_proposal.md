# Patch proposal: jar-38977ee908fe

The Spillover Effect of Liquidity Transparency on Liquidity Holdings

DOI: 10.1111/1475-679X.12602

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow, including the separate aggregate-effect table and co-syndication analysis.

Entry points: `00_Compile/00_CoVaR/01_CoVaR_Input.sas`, `00_Compile/00_CoVaR/02_BankRet.sas`, `00_Compile/00_CoVaR/03_ForwardCoVaRPredictors_banklevel.sas`, `00_Compile/00_CoVaR/04_CoVaR_Calculation.sas`, `00_Compile/00_CoVaR/05_ForwardCoVaRCalculation_outofsample.sas`, `00_Compile/01_BHCData.sas`, `01_Build/01_BuildNW.sas`, `01_Build/02_NW_structure_BHC.sas`, `01_Build/03_CreateVariables.sas`, `01_Build/04_NWDetails.sas`, `01_Build/05_PSM.sas`, `01_Build/06_bankpairs.sas`, `01_Build/07_corr_connect.sas`, `01_Build/08_SystemicRisk.sas`, `02_Analysis/01_AllCombined_tex.do`, `02_Analysis/02_AggregateEffect.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 4/12602 - The-Spillover-Effect-of-Liquidity-Transparency-on-Liquidity-Holdings/yaoludatasheetcodeidentifierandlogfiles.zip",
      "sha256": "935c8799be1626273f908e8a54b0776ec360a7e6b1f25fd31a913ea5ab65c19d"
    },
    {
      "path": "JAR-Volume 63/Issue 4/12602 - The-Spillover-Effect-of-Liquidity-Transparency-on-Liquidity-Holdings/yao-lu-online-appendix.pdf",
      "sha256": "76fa99b316de0f3572515f55d8a0459ab29eb3da200a078274ab99d15b4524cc"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "3b019981fffa48a6d288b7170c69b7980e7d68f3ab07629ab5007accdd4bb21e"
}
```

## Proposed actions

### A_INPUT_ROUTE_CHECKS: Stage compatible raw CRSP/DealScan components and documented public daily Baa/VIX products; keep the unresolved author-specific series, universes, filings, and identifier mappings as separate contracts.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_INTEREST_RATES, R_REPO3M, R_MOODY_BAA, R_VIX, R_CRSP_VWRET, R_CRSP_RERET, R_BANKLIST, R_BANKRETURN, R_RETURNDATA, R_FR_Y9C, R_DEALSCAN_COMPANY, R_DEALSCAN_FACILITY, R_DEALSCAN_LENDER, R_DSRSSD_CROSSWALK, R_POTENTIALMA_MANUAL, R_BANKSRETURN, R_SRISK_VLAB, R_MES, R_CRSP_DSF_RAW
Evidence: E_DATASHEET_SOURCES, E_COVAR_CSV_INPUTS, E_DEALSCAN_INPUT, E_SYSTEMIC_INPUTS, E_PUBLIC_VIX, E_PUBLIC_DGS3MO, E_PUBLIC_DGS10, E_PUBLIC_DBAA, E_PUBLIC_FR_Y9C, E_PUBLIC_VLAB, E_CAT_DEALSCAN, E_CAT_DEALSCAN_LENDER, E_CAT_CRSP_DSF, E_CAT_CRSP_VWRETD, E_CAT_FRB_RATES, E_PROBE_DEALSCAN_COMPANY, E_PROBE_DEALSCAN_FACILITY, E_PROBE_DEALSCAN_LENDERSHARES, E_PROBE_CRSP_DSF, E_PROBE_CRSP_DSI, E_PROBE_FRB_RATES, E_CAT_NO_INTEREST_RATES, E_CAT_NO_REPO3M, E_CAT_NO_BLOOMBERG, E_CAT_NO_VIX, E_CAT_NO_Y9C, E_CAT_NO_SRIKS, E_CAT_NO_VLAB

Preparation / proposed procedure:

1. In a separate working copy, configure the SAS and Stata libraries under a coherent relative project root and keep source, analysis, logs, and output folders distinct.
2. Use the verified CRSP.DSI DATE/VWRETD fields for the value-weighted series; map DATE to the author's CALDT field and apply the supplied weekly aggregation.
3. Use the verified CRSP.DSF raw PERMNO/PERMCO/DATE/RET/PRC/SHROUT fields. Stage security-level returndata for the supplied PERMCO banklist join; keep the real-estate and bank-only subsets separate until their universe rules are documented.
4. Use the verified DealScan COMPANY, FACILITY, and LENDERSHARES tables with their probed fields and lender roles. Preserve the supplied transaction filters and validate selected-row coverage during ordinary preparation.
5. Acquire Cboe daily VIX and FRED DBAA; map provider date/value headings into date/vix and date/dbaa, normalize dates, and validate the requested daily observations after acquisition.
6. Keep the combined interest-rate input conditional on confirming whether the source's tb3m uses DGS3MO or a discount-yield definition; identify the exact Bloomberg three-month GC repo series and its acquisition route.
7. Obtain the quarterly FR Y-9C member layout and required field list, the separate banklist, the DealScan-RSSD crosswalk, the completed manual flags, and the exact SRISK/MES measures and firm-to-RSSD/quarter mapping.
8. Stage each compatible product in the configured author library structure and validate headers, identifiers, dates, and selected-row coverage as standard data preparation.

Validation to perform later:

- Confirm the DSI DATE-to-CALDT mapping and daily VWRETD observations before applying the source's weekly transformation.
- Confirm all six DSF raw fields; keep banklist separate and obtain the real-estate/bank-stock selection rule before preparing RERET or BANKRETURN.
- Confirm the DealScan consumed fields and roles match the probed local COMPANY/FACILITY/LENDERSHARES tables; check transaction coverage during ordinary preparation.
- Confirm provider date/value column mappings for Cboe VIX and FRED DBAA and validate their required daily date range after acquisition.
- Resolve the TB3M series definition and Bloomberg repo product, then confirm FR Y-9C schema, crosswalk/manual mappings, and V-Lab SRISK/MES identifiers and quarter construction.

### A_DSRSSD_CLARIFICATION: Obtain the author-prepared DealScan-to-RSSD crosswalk and its coverage/construction notes, or document a compatible replacement route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_DSRSSD_CROSSWALK, I_DSRSSD_CROSSWALK
Evidence: E_DSRSSD_INPUT

Preparation / proposed procedure:

1. Preserve the exact LenderUltiParentID-to-RSSD9001_final/isBHC mapping expected by the program.

Validation to perform later:

- Check identifier coverage and the BHC flag against the supplied merge contract before an authorized run.

### A_MANUAL_FLAGS_CLARIFICATION: Obtain the completed author manual-markup workbook and the rules used to assign its acquisition flags.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_POTENTIALMA_MANUAL, I_MANUAL_ACQUIRER_FLAGS
Evidence: E_MANUAL_CANDIDATE_EXPORT, E_MANUAL_CANDIDATE_IMPORT

Preparation / proposed procedure:

1. Preserve the supplied potentialma candidate export and map its RSSD9001 identifier to the author markup rows.

Validation to perform later:

- Confirm the meanings and coverage of AcquiringBank and AG_above_20 before running the sample builder.

### A_BANKSRETURN_HANDOFF: Confirm which supplied author-stage creates the exact permanent build.banksreturn member and document its daily return fields and date coverage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_BANKSRETURN, I_BANKSRETURN_PRODUCER
Evidence: E_BANKSRETURN_INPUT, E_BANKSRETURN_WORK_CREATION, E_RETURNDATA_INPUT

Preparation / proposed procedure:

1. Keep the WORK banksreturn produced in the return-preparation script distinct from the build-library file consumed by the Granger script until their mapping is documented.

Validation to perform later:

- Verify the exact library member, RSSD/date/return keys, and daily frequency before an authorized run.

### A_SRISK_MES_CLARIFICATION: Identify the exact SRISK and MES measures and author-expected series, identifiers, and periods used by the systemic-risk merge.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SRISK_VLAB, R_MES, I_SRISK_MES_MAPPING
Evidence: E_SYSTEMIC_INPUTS, E_PUBLIC_VLAB, E_CAT_NO_SRIKS, E_CAT_NO_VLAB

Preparation / proposed procedure:

1. Use the V-Lab documentation as a candidate route and obtain the exact author-selected model, metrics, firm identifiers, and quarter construction.
2. Confirm that separate SRISK and MES fields map to RSSD9001/year/quarter for the author panel before selecting or transforming an export.

Validation to perform later:

- Confirm the source fields and RSSD9001/year/quarter mapping before producing the combined covar output.

### A_PORTABLE_PROJECT_ROOT: Prepare a separate host-visible project copy and follow the documented native stage groups conditionally, preserving unresolved bootstrap and handoff contracts.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_WINDOWS_PATHS
Evidence: E_COVAR_CSV_INPUTS, E_DEALSCAN_INPUT, E_ANALYSIS_INPUTS, E_README_ORDER, E_README_STAGE_LIST, E_FORWARD_MACRO_INCLUDE, E_NETWORK_PRODUCER

Preparation / proposed procedure:

1. Keep the original package unchanged. In the copy, replace machine-specific roots with relative paths; configure dc, Bankdata, dsdata, build, and covarraw plus the included 99_Macros.sas file under host-visible directories; validate read/write access before an authorized run.
2. Conditional authored order: run 00_Compile/00_CoVaR/01_CoVaR_Input.sas, 02_BankRet.sas, 03_ForwardCoVaRPredictors_banklevel.sas, 04_CoVaR_Calculation.sas, and 05_ForwardCoVaRCalculation_outofsample.sas in the README's sequential CoVaR order.
3. Run 00_Compile/01_BHCData.sas to prepare bankdata.bhcdata after its quarterly BHCF inputs are staged.
4. Run 01_Build/01_BuildNW.sas, 02_NW_structure_BHC.sas, 03_CreateVariables.sas, and 04_NWDetails.sas in sequence after DealScan, FR Y-9C, crosswalk, and manual-flag inputs are prepared.
5. Then run 01_Build/05_PSM.sas and 06_bankpairs.sas after their nwregvar/existingpairs/BHC inputs; run 07_corr_connect.sas only after the permanent build.banksreturn producer is confirmed; run 08_SystemicRisk.sas after the CoVaR/fwd-CoVaR and SRISK/MES inputs are mapped.
6. Run 02_Analysis/01_AllCombined_tex.do after its Stata exports are prepared. Run 02_Analysis/02_AggregateEffect.sas as a separate SAS branch after its own sample input is staged.
7. Keep the in-memory WORK banksreturn from the predictor stage distinct from permanent build.banksreturn until the exact producer handoff is confirmed; obtain the active trimlist_rank producer before attempting its consumer.

Validation to perform later:

- Verify the README stage order, all 16 supplied entry points, configured library visibility, and output writability before any separately authorized run.
- Confirm each stage input/output handoff, especially WORK banksreturn versus build.banksreturn and trimlist_rank, without assuming an undocumented cross-branch total order.
- Confirm the Stata analysis inputs exist after their SAS producers, and keep the AggregateEffect SAS branch's input/output root separate.

### A_TRIM_RANK_CLARIFICATION: Obtain a schema-level description of the active trim_by_year macro's trimlist_rank producer and its relationship to the dataline trimlist.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_TRIM_RANK_PRODUCER
Evidence: E_TRIM_BY_YEAR_USE, E_MACRO_MASK_VIEW, E_TRIM_CALL_SCAN

Preparation / proposed procedure:

1. Ask the authors to identify the variable names and work-table construction for trimlist_rank without providing any credential or connection material.

Validation to perform later:

- Confirm the active call's trimlist_rank table has one row per trimmed variable and that the complete macro input/output chain is represented before an authorized run.

### A_SAS_RUNTIME_CHECK: Confirm SAS 9.4 and the required SAS/STAT and SAS/ETS procedures in the intended execution environment using an authorized environment check.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_SAS_94, I_SAS_RUNTIME
Evidence: E_ENV_SAS, E_SAS_QUANTREG, E_SAS_PSMATCH, E_SAS_AUTOREG, E_SAS_VARMAX

Preparation / proposed procedure:

1. Use the machine's approved software inventory or a separately authorized, non-study SAS capability check; this assessment does not launch SAS.

Validation to perform later:

- Verify SAS 9.4 and the QUANTREG, PSMATCH, AUTOREG, and VARMAX procedures before any authorized author-program execution.

### A_OUTREG2_SETUP: Install or enable the Stata outreg2 command through an authorized package source before running the supplied analysis driver.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_OUTREG2, I_OUTREG2_UNAVAILABLE
Evidence: E_STATA_ADDONS, E_SOFTWARE_OUTREG2

Preparation / proposed procedure:

1. Use the approved Stata add-on channel for outreg2 in the execution environment.

Validation to perform later:

- Repeat the exact-name outreg2 lookup and confirm the command resolves under Stata 18 before running the analysis driver.


## Remaining issues and prerequisites

- I_DSRSSD_CROSSWALK [unresolved; full_pipeline]: The DealScan-to-RSSD crosswalk is an independently imported workbook; its underlying source, delivery route, and mapping coverage are not established in the supplied package.
- I_MANUAL_ACQUIRER_FLAGS [unresolved; full_pipeline]: The sample builder imports a separate manual workbook containing AcquiringBank and AG_above_20, but the classification rule and completed workbook are not supplied in the registered package inventory.
- I_BANKSRETURN_PRODUCER [unresolved; full_pipeline]: The Granger stage reads the permanent build.banksreturn member. The supplied return-preparation source creates a same-named WORK table but does not establish that exact persisted build-library product; its producer/path mapping needs confirmation.
- I_SRISK_MES_MAPPING [unresolved; full_pipeline]: The systemic-risk stage separately imports srisk_vlab and mes; the required series, source fields, period, and identifier mapping are not established by the supplied program text.
- I_WINDOWS_PATHS [preparation; full_pipeline]: The supplied programs embed Windows Dropbox roots and file-level paths across SAS and Stata calls, so an execution copy needs a coherent portable project-root and library setup.
- I_TRIM_RANK_PRODUCER [unresolved; full_pipeline]: The active trim_by_year macro consumes trimlist_rank, but the complete SAS statements that define its producer are masked in the safe view. Its variables and exact source table need a schema-level confirmation.
- I_SAS_RUNTIME [unresolved; full_pipeline]: The supplied programs require SAS procedures from SAS/STAT and SAS/ETS, while the registered safe environment viewer leaves SAS unverified. This audit did not launch SAS.
- I_OUTREG2_UNAVAILABLE [preparation; full_pipeline]: The Stata driver uses outreg2, and the exact-name software probe returned available=false under Stata 18.
- R_INTEREST_RATES [undetermined]: Daily interest-rate series used to construct weekly changes in three-month rates and the yield-curve slope.
- R_REPO3M [undetermined]: Three-month general-collateral repo rates used with tb3m to construct weekly liquidity spreads.
- R_MOODY_BAA [public_acquisition_required]: Moody's BAA yield series used to construct the credit spread and its weekly change.
- R_VIX [public_acquisition_required]: Daily VIX observations used to construct weekly volatility regressors.
- R_CRSP_RERET [undetermined]: CRSP real-estate return, price, and share observations used for the value-weighted real-estate market return.
- R_BANKLIST [undetermined]: Bank-level adoption and entity-to-PERMCO mapping used in the return and predictor panels.
- R_BANKRETURN [undetermined]: Bank stock-return table used to form the value-weighted banking-sector return.
- R_FR_Y9C [undetermined]: Quarterly FR Y-9C BHC filings used to create the regulatory bank panel and forward-CoVaR predictors.
- R_DSRSSD_CROSSWALK [undetermined]: DealScan-to-RSSD/BHC crosswalk required to identify bank holding companies in the lender network.
- R_POTENTIALMA_MANUAL [undetermined]: Manual acquirer and above-$20bn flags imported after exporting the potential-M&A review table.
- R_BANKSRETURN [undetermined]: Daily bank return panel read from the build library for the Granger-causality stage; its active producer or construction is not established by the supplied code.
- R_SRISK_VLAB [undetermined]: SRISK observations merged into the systemic-risk output by RSSD9001, year, and quarter; the consumed measure mapping needs confirmation.
- R_MES [undetermined]: MES observations merged into the systemic-risk output by RSSD9001, year, and quarter; the consumed measure mapping needs confirmation.
- S_SAS_94 [unverified]: The supplied programs require QUANTREG, PSMATCH, AUTOREG, VARMAX, and REG. The safe environment viewer leaves SAS unverified; this audit did not launch SAS.
- S_OUTREG2 [preparation_required]: The Stata driver invokes outreg2, and the exact-name Stata helper probe returned available=false under Stata 18.

## Review notes

- The cumulative correction covers the supplied full_pipeline and all 16 entry points; every one of the 75 frozen dependency IDs retains exactly one review disposition. The sole registered workbook is an identifier list, not the banklist, DealScan-RSSD crosswalk, manual flags, or a prepared analysis panel; no analysis_only scope is supported.
- The successful local CRSP.DSI probe has both DATE and VWRETD; the raw value-weighted series is available with ordinary DATE-to-CALDT mapping. The successful CRSP.DSF probe has PERMNO/PERMCO/DATE/RET/PRC/SHROUT. The banklist join remains independent; the real-estate and bank-stock subset selections remain specific unresolved inputs.
- Successful local DealScan COMPANY, FACILITY, and LENDERSHARES probes contain every declared consumed raw field, including facility dates and lender role/allocation/agent/lead-arranger fields. These local raw components are credited; row coverage and author release provenance are ordinary preparation checks.
- Cboe documents daily VIX closing values and FRED DBAA documents the daily Moody's Baa yield, so both public routes are credited for ordinary acquisition/header/date preparation. The interest-rate input remains conditional on the exact TB3M measure; DGS3MO is not assumed equivalent to a discount-yield series.
- The FRB.RATES_DAILY successful bounded probe supports date/DBAA as a local candidate. Its failed exact-field request remains preserved as an unused top-level evidence record; it is not referenced scientifically and does not establish data absence or a product/access barrier.
- The FR Y-9C historical member schema, DealScan-RSSD mapping, banklist, manual acquisition flags, SRISK/MES measures and mappings, active trimlist_rank producer, SAS runtime, and WORK-versus-build banksreturn handoff remain specifically identified preparation or clarification steps.
- The 24 source quotes containing private author roots were narrowed to literal screened line excerpts outside those roots; path-only records were removed where no substantive excerpt was needed. Source files, probes, source views, and earlier helpers remain unchanged; prior input and output copies are byte-exact and mode 0444.
- The SAS safe view retains original line numbering and masks complete candidate-bearing statements and continuations in 99_Macros.sas at lines 37-40, 59-62, and 83-86. The active trim_by_year consumer remains visible; trimlist_rank remains unresolved, while the uncalled trim_harris lists remain optional.
- The first saved source-view invocation failed because --path was omitted; its empty output, actual CLI stderr, and helper copy remain preserved. Author .txt/.smcl logs remain metadata-only; no raw log or generated log view was displayed or used as program evidence, so no log-only completion claim is made.
- The conditional run procedure preserves the documented CoVaR sequence, BHCData preparation, sequential Build stages, Stata main analysis, and separate SAS AggregateEffect branch. It does not establish an undocumented cross-branch order or collapse unresolved input handoffs.
- No author code, SAS executable, statistical procedure, dataset-wide descriptive trial, parser, or model was run for this correction. No new resource probe or data download was performed. execution_verified remains false.
