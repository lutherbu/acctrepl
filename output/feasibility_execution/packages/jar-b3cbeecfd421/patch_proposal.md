# Patch proposal: jar-b3cbeecfd421

The Dog that Didn't Bark: Limited Price Efficiency and Strategic Nondisclosure

DOI: 10.1111/1475-679X.12296

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied preparation and data-construction workflow, including main regression-sample preparation, factor and size construction, two independent Table 10 trading outputs, and the pseudo-RDQ robustness-data branch. Paper-wide regression/table estimators are not supplied in this release.

Entry points: `Codes_ZZ2019/01 Guidance/quarterly_ols_sample_construction20191216.sas`, `Codes_ZZ2019/02 Controls/Controls20191216.sas`, `Codes_ZZ2019/03 Factor and Size/FactorBetasParellelStageI20191216sub.sh`, `Codes_ZZ2019/03 Factor and Size/FactorBetasParellelStageII20191216sub.sh`, `Codes_ZZ2019/03 Factor and Size/FactorBetasParellelStageIII20191216sub.sh`, `Codes_ZZ2019/03 Factor and Size/FactorBetasParellelStageIV20191216sub.sh`, `Codes_ZZ2019/03 Factor and Size/FactorBetasStageI20191216.do`, `Codes_ZZ2019/03 Factor and Size/FactorBetasStageII20191216.do`, `Codes_ZZ2019/03 Factor and Size/FactorBetasStageIII20191216.do`, `Codes_ZZ2019/03 Factor and Size/FactorBetasStageIV20191216.do`, `Codes_ZZ2019/03 Factor and Size/SizeAdjustment20191216.do`, `Codes_ZZ2019/04 RDQ/RDQ_AfterHour20191216.sas`, `Codes_ZZ2019/05 XS/MarkitBorrowingCost20191216.sas`, `Codes_ZZ2019/07 Merge/PastNG3y.sas`, `Codes_ZZ2019/07 Merge/RP_merge.sas`, `Codes_ZZ2019/07 Merge/disclosure_new_20191216.do`, `Codes_ZZ2019/07 Merge/regsample20191216.do`, `Codes_ZZ2019/08 Trading/CalendarTrading20191216.sas`, `Codes_ZZ2019/08 Trading/CalendarTrading_Daily20191216.sas`, `Codes_ZZ2019/09 Robustness/quarterly_ols_sample_construction20191216_pseudordq.sas`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 1/12296 - The-Dog-that-Didn-t-Bark-Limited-Price-Efficiency-and-Strategic-Nondisclosure/zz-datasheet-and-code-files.zip",
      "sha256": "c086bd9c2541c591c7771696b436ce5d98a71709da5929053276a0bb0092a85c"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "8a099a7ddb1a6efcac0ec186b2bac09c8d5e72bb43340e65265ef12a1728bfb1"
}
```

## Proposed actions

### A_RAW_INPUTS: Resolve each actual source product and field contract, then prepare compatible files for the supplied code without independently rebuilding the research.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_GUIDANCE, R_IBES_CRSP_LINK, R_IBES_GUIDANCE_LINK, R_CCM_QUARTERLY, R_CRSP_DAILY, R_CRSP_INDEX, R_CRSP_STOCKNAMES, R_CCM_LINKTABLE, R_COMPANY_HEADER, R_IBES_DETAIL, R_TR_OWNERSHIP, R_IBES_ACTUAL, R_FRENCH_FACTORS, R_FRENCH_SIZE_RETURNS, R_FRENCH_SIZE_BREAKPOINTS, R_MARKIT, R_CCM_RAVEN_CROSSWALK, R_RAVENPACK, I_RAW_INPUTS
Evidence: E_GUIDANCE_RAW, E_CONTROLS_INPUTS, E_DATASHEET_ID, E_CATALOG_LOOKUP, E_PROBE_IBES_GUIDANCE, E_PROBE_IBES_DETAIL, E_PROBE_IBES_ACTUAL, E_PROBE_COMP_FUNDQ, E_PROBE_COMP_COMPANY, E_PROBE_CRSP_DSF, E_PROBE_CRSP_DSI, E_PROBE_CRSP_STOCKNAMES, E_PROBE_CCM_LINK, E_PROBE_FF_FACTORS, E_PROBE_RP_2002, E_PROBE_RP_2017, E_PROBE_IDENTIFIERS

Preparation / proposed procedure:

1. Use the recorded local catalog hits and bounded probes as candidate leads; resolve the exact author product/vintage and full input fields/history for every listed requirement, retaining separate IBES guidance, EPS detail and timestamped actuals products.
2. Confirm the author joins and identifier contracts before staging inputs; COMP.FUNDQ and COMP.COMPANY are not direct replacements for the author-linked quarterly CCM/company inputs because the local probes do not show PERMNO. Do not substitute the differently labeled TFN, RavenPack or French product families without a supported mapping.
3. Stage each confirmed input under consistent host-visible relative/storage roots and preserve the source 0/missing and lag rules. Check actual date coverage for the required event population and construction history, including whether the CRSP bundle covers each 90-calendar-day pre-RDQ factor window.

Validation to perform later:

- For each staged product, run a bounded schema/format check against the exact author fields; separately validate full date and identifier coverage from metadata or authorized non-destructive checks before execution.
- After a future authorized run, validate each generated input/output contract against the next consumer and retain unmatched/missing observations according to supplied source behavior.

### A_PATHS: Configure host-visible roots and the two known generated-file handoffs across the supplied Stata stages.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_PATH_HANDOFF
Evidence: E_FACTOR_INPUT, E_FACTOR_COMBINE, E_DISCLOSURE_HANDOFF

Preparation / proposed procedure:

1. Keep the supplied Codes_ZZ2019 stage folders distinct beneath a staged project root such as [redacted-path-7d4ab7c4c0c3]; define consistent per-stage Stata globals and SAS macro roots for rawdata, datafinal, datanew and analysis.
2. Reconcile the guidance-produced crspdateprice_bundled_20191216.dta by configuring Factor Stage I to read its datafinal path or by staging an exact copy/link at the configured rawdata basename while leaving other rawdata inputs intact.
3. Reconcile the Factor Stage III FactorBetas20191216.dta output in datanew with the disclosure consumer by configuring its data root or staging an exact copy/link at the datafinal consumer basename. Do not rename either file or alter schemas.
4. Use a staged run directory for logs, shell task outputs and business calendars; keep outputs outside Dropbox.

Validation to perform later:

- After a future authorized run, verify each producer file exists and its consumer path resolves to that same file or a schema-checked exact copy/link before Factor Stage I and disclosure use it.

### A_WRAPPERS: Configure the known Stata-to-SAS source and working-directory handoffs, then verify the separately unverified SAS runtime and DTA import/export support.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_SAS_WRAPPERS, SAS, SAS_DTA, SASWRAPPER
Evidence: E_REGSAMPLE_WRAPPERS, E_REGSAMPLE_PASTNG, E_RP_SAS, E_PASTNG_SAS, E_PROBE_SASWRAPPER, E_ENVIRONMENT

Preparation / proposed procedure:

1. Configure the Stata dofile path so both SAS companions resolve from the supplied Codes_ZZ2019/07 Merge folder or an exact staged copy. Resolve their hard-coded Windows cd/libname destinations to the staged datafinal location through the staged wrapper configuration or copies, without changing the frozen package sources.
2. Keep RP_merge after Stata creates RP_news.dta and temp_permno_final_EPS_20191216_2.dta; validate RP_news_merge.dta before its Stata merge. Keep PastNG3y after Stata writes temp_pastNG.dta and validate temp_sas_pastNG_merge.dta before its merge.
3. Install/configure the saswrapper command in Stata 18 and separately confirm SAS 9.4 startup plus PROC IMPORT/EXPORT DBMS=DTA support; the current wrapper lookup did not find saswrapper and runtime/format capability remain separate software preparation/verification items.

Validation to perform later:

- For a future authorized run, validate each wrapper exit status, required input files, output paths, and the SAS outputs RP_news_merge.dta and temp_sas_pastNG_merge.dta before their Stata merges.

### A_FACTOR_TASKS: Retain the four authored factor stages and use the current group count produced by Stage I to enumerate all Stage II tasks.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: I_FACTOR_TASKS, SGE
Evidence: E_FACTOR_INPUT, E_FACTOR_COMBINE, E_FACTOR_STAGEI_TASK, E_FACTOR_STAGEII_TASK, E_FACTOR_STAGEIII_TASK, E_FACTOR_STAGEIV_TASK, E_PRODUCES_FACTOR_START, E_PRODUCES_FACTOR_GROUP, E_PRODUCES_FACTOR_BETAS

Preparation / proposed procedure:

1. Run FactorBetasStageI20191216.do from its author folder and record the actual FirmGroupNum count created in temp_FactorBetasStartFile.dta.
2. Use the supplied Stage II task with one task per group identifier from 1 through the observed count, preserving one output per group and waiting for all tasks to complete. Use the authored SGE command only if the scheduler is available; do not infer the group count from commented historical ranges.
3. Run Stage III with the same observed count, confirm FactorBetas20191216.dta is complete, and run Stage IV cleanup only after combination and downstream staging. SGE availability is assessed separately.

Validation to perform later:

- Confirm every expected group output exists before Stage III, the combined output has permno/rdqlag and BetaMkt/BetaSMB/BetaHML/BetaMom, and Stage IV leaves the combined file intact.

### A_STATA_SETUP: Add the required Stata winsor2 command to the configured Stata 18 environment before the supplied sample-construction workflow is run.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: STATA_WINSOR2
Evidence: E_ENVIRONMENT, E_WINSOR2_SOURCE

Preparation / proposed procedure:

1. Install or configure winsor2 through an authorized local Stata ado path; do not change the supplied winsorization commands.
2. Confirm Stata resolves winsor2 from the execution adopath before a future authorized package run.

Validation to perform later:

- Use Stata which winsor2 and record the resolved path/version.

### A_RUN_ORDER: After inputs, software and staged roots are confirmed, run the supplied preparation workflow in its source-supported order, retaining the in-Stata SAS calls and all auxiliary branches.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: I_RAW_INPUTS, I_PATH_HANDOFF, I_SAS_WRAPPERS, I_FACTOR_TASKS
Evidence: E_README_REGSAMPLE, E_REGSAMPLE_WRAPPERS, E_REGSAMPLE_PASTNG, E_FACTOR_STAGEI_TASK, E_FACTOR_STAGEII_TASK, E_FACTOR_STAGEIII_TASK, E_FACTOR_STAGEIV_TASK, E_TRADING_CLASSIC_OUTPUT, E_TRADING_DAILY_OUTPUT, E_PSEUDORDQ_OUTPUT

Preparation / proposed procedure:

1. Run Guidance SAS to produce GUIDECCM and the daily CRSP bundle, then Controls SAS. Confirm the consumer roots point to these outputs.
2. Run Factor Stage I and record its actual FirmGroupNum; run Stage II once per observed group, wait for every group output, combine in Stage III and run Stage IV cleanup only after the combined output has been checked. Run SizeAdjustment with its separate daily returns and monthly breakpoints inputs.
3. Run RDQ_AfterHour SAS using the guidance output and IBES actual/link products, then MarkitBorrowingCost SAS after all required annual Markit inputs are staged.
4. Run disclosure_new_20191216.do to build the intermediate and final EPS datasets. Run regsample20191216.do next; preserve its in-script RP_merge SAS call after its two Stata input files are written and its PastNG3y SAS call after temp_pastNG.dta is written.
5. Run CalendarTrading20191216.sas and CalendarTrading_Daily20191216.sas as separate Table 10 companions after their shared generated inputs are ready. Run the pseudo-RDQ robustness SAS branch after its final_EPS_2 input is available.

Validation to perform later:

- At each stage, verify the named generated file exists at the actual consumer path, expected identifier/date keys and fields are present, and all per-group factor outputs exist before Stage III.
- Validate both distinct Table 10 output files and the pseudo-RDQ output, and preserve source missing/lag behavior; do not infer current factor job counts from commented historical qsub ranges.


## Remaining issues and prerequisites

- I_RAW_INPUTS [unresolved; full_pipeline]: The supplied sources require the individual WRDS, IBES, CRSP, Thomson Reuters, French, Markit and RavenPack inputs listed in the data requirements. Local catalog/probe candidates are recorded, but exact author product/vintage, complete history, joins and route availability remain to be confirmed. The included identifier list contains only PERMNO, DATADATEQ and RDQ, not the full analysis inputs.
- I_PATH_HANDOFF [preparation; full_pipeline]: Two generated DTA handoffs use different configured roots: the guidance producer writes crspdateprice_bundled_20191216.dta under datafinal while Factor Stage I reads that basename under rawdata; Factor Stage III writes FactorBetas20191216.dta under datanew while disclosure reads it under datafinal. Both are known basename/path handoffs that can be resolved with coherent per-stage roots or an exact staged copy/link and schema check; no scientific input contract is unresolved here.
- I_SAS_WRAPPERS [preparation; full_pipeline]: regsample calls RP_merge.sas and PastNG3y.sas inside Stata at known source points. The supplied SAS companions are under Codes_ZZ2019/07 Merge while the Stata dofile path resolves through analysis/07 Merge, and the SAS code contains hard-coded Windows working-directory/libname paths. Staged source-path and datafinal working-directory configuration are preparation steps. SAS runtime and PROC IMPORT/EXPORT DBMS=DTA support remain separately unverified in software records.
- I_FACTOR_TASKS [preparation; full_pipeline]: The authored factor sequence is supported: Stage I creates the current group count/start file, Stage II consumes one group identifier per task, Stage III combines completed groups, and Stage IV cleans up. The actual count is derived at runtime from Stage I; selecting that count and retaining the authored order are preparation. SGE client/service availability remains unverified in its separate software record. Historical qsub task ranges/comments are not the current group count.
- R_GUIDANCE [undetermined]: IBES guidance detail used to build firm-quarter guidance decisions (det_guidance; management guidance period 2002–2017).
- R_IBES_CRSP_LINK [undetermined]: IBES-to-CRSP link file IBESCRSPLINK, read by guidance, controls, RDQ and pseudo-RDQ programs.
- R_IBES_GUIDANCE_LINK [undetermined]: Guidance-specific IBES-to-CRSP link file IBESGuideCRSPLINK, jointly read with IBESCRSPLINK.
- R_CCM_QUARTERLY [undetermined]: Quarterly CCM/Compustat source ccmq00to17_20180227; guidance and pseudo-RDQ use permno/gvkey/datadate/fqtr/rdq, and controls also uses financial fields.
- R_CRSP_DAILY [undetermined]: CRSP daily stock file dsf02to17_20181016, used for event returns and controls.
- R_CRSP_INDEX [undetermined]: CRSP daily index file dsi_20181016 used to supply vwretd for market-adjusted quarterly returns.
- R_CRSP_STOCKNAMES [undetermined]: CRSP stocknames20181104 used for ncusip/CUSIP-to-PERMNO and historical name-date matching.
- R_CCM_LINKTABLE [undetermined]: ccmxpf_linktable_20180227.sas7bdat is loaded unconditionally by Controls20191216.sas; no downstream use is visible, so the precise column requirement is unspecified.
- R_COMPANY_HEADER [undetermined]: company20180305.sas7bdat is joined to quarterly CCM on both PERMNO and GVKEY to add SIC; local COMP.COMPANY candidate lacks PERMNO.
- R_IBES_DETAIL [undetermined]: det_epsus00to17_20180227.sas7bdat supplies analyst following counts.
- R_TR_OWNERSHIP [undetermined]: stockown98to16.sas7bdat supplies quarterly institutional ownership measures.
- R_IBES_ACTUAL [undetermined]: IBES_Actual197001to201803_20181124.dta supplies timestamped actual announcement dates for the RDQ adjustment.
- R_FRENCH_FACTORS [undetermined]: FactorsRF19260701to20181031_20181204.dta supplies daily market, SMB, HML, momentum and risk-free returns.
- R_FRENCH_SIZE_RETURNS [undetermined]: Portfolios_Formed_on_ME_daily_vw20181204.csv supplies three daily value-weighted size portfolio returns.
- R_FRENCH_SIZE_BREAKPOINTS [undetermined]: ME_Breakpoints.csv supplies monthly 30th/70th market-equity breakpoints.
- R_MARKIT [undetermined]: Annual amereqty datasets for 2002–2017 supply security-level borrowing-cost and utilization inputs.
- R_CCM_RAVEN_CROSSWALK [undetermined]: Author raw crosswalk CRSP_Compustat_Merged_LinkingTable.dta maps RavenPack issuer identifiers to CRSP PERMNO.
- R_RAVENPACK [undetermined]: RavenPack archive rp20020101to20171231_20181210.dta supplies Dow Jones news records for the regression-sample merge.
- SAS [unverified]: SAS 9.4 is documented locally, but the existing bounded startup probe failed during toolkit initialization. The diagnostic does not establish an absent license or missing installation; do not retry in this assessment. Required procedures/runtime remain unverified.
- SAS_DTA [unverified]: Supplied SAS programs use PROC IMPORT/EXPORT DBMS=DTA for Stata-file handoffs. SAS availability and PC Files support are unverified; a successful import/export format check has not been performed.
- SASWRAPPER [preparation_required]: regsample invokes saswrapper, and the bounded Stata which-probe did not find the command in checked adopaths. Configure the supplied wrapper before execution.
- STATA_WINSOR2 [preparation_required]: The existing Stata which-probe did not find winsor2 in checked adopaths; add the command to the authorized environment before running the supplied sample construction.
- SGE [unverified]: Factor Stage II shell code uses SGE task-array variables/directives. Scheduler availability and task-array configuration are not probed; historical task counts/comments do not establish the current FirmGroup count.

## Review notes

- The assessed target is the complete supplied data-preparation and sample-construction workflow, including the pseudo-RDQ and both Table 10 trading companions. The authors do not provide the paper-wide estimator/table scripts in this archive; those remain contextual limitations.
- Frozen catalog lookup and bounded local probes are now recorded. Local candidates include IBES guidance/detail/actuals, CRSP daily/index/stocknames/linktable, quarterly Compustat, daily factors, and the RavenPack annual equities family. These are candidates only: full period/history, exact product/vintage, required author joins, and access are not established. French size return/breakpoint, Markit, IBES link, Thomson Reuters ownership and author RavenPack crosswalk routes remain unresolved; catalog misses do not establish license absence.
- The one-row COMP.FUNDQ probe matches quarterly financial fields but does not provide PERMNO; COMP.COMPANY exposes GVKEY/SIC but not PERMNO. Do not substitute these candidates directly for author-built CCM inputs. IBES guidance, detail and timestamped actuals are distinct products. RPA.RP_EQUITIES_2002 matches requested fields; the bounded 2017 probe timed out and was not retried.
- Stata 18 is available; winsor2 was not found in checked adopaths, saswrapper was not found, and SAS startup remains unverified after a toolkit initialization diagnostic. No author program or regression has been run. Source path and producer handoffs and the interleaved in-Stata SAS wrapper calls remain unresolved setup steps.
- Probe artifacts were generated with row_limit=1. They establish bounded readability and listed fields only; their sample rows do not establish date coverage, history or population fidelity. The embedded original PROC CONTENTS catalog hash is 45894893e45d56cb56150252c2ce4e85dfa88f5d891f3e547d3e9ea8003993fb; the frozen catalog JSON file hash is 4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27; the catalog lookup artifact has its own recorded SHA.
- All 65 frozen dependency IDs are now individually reviewed and linked to their exact cached source line. Raw inputs link to their data requirements; generated handoffs link to supplied producer lines; the two actual path mismatches link to I_PATH_HANDOFF. The dependency closure is enumerated, while input product/history and execution readiness remain unresolved.
- The supported run order interleaves Stata and SAS where regsample calls RP_merge.sas and PastNG3y.sas through saswrapper. Factor Stage I establishes the actual group count, Stage II is retained per group, Stage III combines completed groups, and Stage IV follows combination; historical qsub comments are not current counts. Both Table 10 trading programs and the pseudo-RDQ branch remain in scope.
- QA update: known file-root and wrapper working-directory handoffs are ordinary preparation choices supported by the exact producer/consumer paths; the factor group count is derived by Stage I. SAS runtime/DBMS=DTA and SGE availability remain separately unverified. No spelling-based SAS failure is inferred.
