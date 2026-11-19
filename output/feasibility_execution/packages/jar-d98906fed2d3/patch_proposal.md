# Patch proposal: jar-d98906fed2d3

Do Risk Disclosures Matter When It Counts? Evidence from the Swiss Franc Shock

DOI: 10.1111/1475-679X.12338

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow: import construction, data merging and preparation, main archival analysis, and both analyst and investor-relations survey analyses with their shared helper programs.

Entry points: `HMO_Code/00_Master-File.do`, `HMO_Code/05_Import_Sell_Side_Analyst_Survey.do`, `HMO_Code/06_Import_IR_Survey.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 1/12338 - Do-Risk-Disclosures-Matter-When-It-Counts-Evidence-from-the-Swiss-Franc-Shock/hmo-datasheet-code-and-identifiers.zip",
      "sha256": "8afe715bbc843beb055d5ffe8b967c3a877a6dbdb101daa3e360241ab7c55609"
    },
    {
      "path": "JAR-Volume 59/Issue 1/12338 - Do-Risk-Disclosures-Matter-When-It-Counts-Evidence-from-the-Swiss-Franc-Shock/hmo-internet-appendix.pdf",
      "sha256": "7ddcb450f97ee86fc53d2a72ce76091f045a66250792502f4322bdb166f5440b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "c8eeb8d35038f769e08f2ce4e2374f9b1f7c12685f558d7cc761503960965659"
}
```

## Proposed actions

### A_CONFIGURE_WORKSPACE: Prepare one README-compatible project tree and set the same local STANDARD_FOLDER root in the master and every child program.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_WORKSPACE_LAYOUT
Evidence: E_MASTER_VERSION_AND_ROOT, E_MASTER_STAGE_ORDER, E_SURVEY_HELPER, E_IR_HELPER, E_LABEL_HELPER, E_ROOT_01, E_ROOT_02, E_ROOT_03, E_ROOT_04, E_ROOT_05, E_ROOT_06, E_ROOT_10, E_ROOT_11, E_ROOT_20

Preparation / proposed procedure:

1. Choose one common writable host root with the README-compatible 1_Sources, 2_Code, 3_Datasets, and 4_Output layout.
2. Stage all supplied HMO_Code programs under 2_Code with original matching names, including 90_Additional_Survey_Code.do and 91_Label Variables.do.
3. In the execution copy, set STANDARD_FOLDER consistently in all ten declarations: 00_Master-File.do line 10 and 01, 02, 03, 04, 05, 06, 10, 11, and 20 at line 9; retain version 13.1 and do not edit archived originals.
4. Create 4_Output/LogFile and 4_Output/Tables as separate sibling directories under 4_Output.

Validation to perform later:

- Confirm all ten declarations resolve to the same common root and that supplied master/companion filenames resolve from 2_Code without content changes.
- Confirm 1_Sources, 3_Datasets, 4_Output/LogFile, and 4_Output/Tables are writable before a separately authorized run.

### A_ACQUIRE_BLOOMBERG_HISTORY: Obtain the exact historical Bloomberg workbook families and the author-specified SIX trading calendar, preserving the 241-firm, three-price-type, three-part overlap and daily market-value input contracts.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_BLOOMBERG_INTRADAY, R_BLOOMBERG_DAILY_MV, R_TRADING_CALENDAR
Evidence: E_INTRADAY_INPUT, E_INTRADAY_RAW_FIELDS, E_BLOOMBERG_MV_DECL, E_BLOOMBERG_MV_FIELDS, E_TRADING_AUTHOR_SOURCE, E_TRADING_CONSUMER

Preparation / proposed procedure:

1. Use an authorized Bloomberg Excel-tool route or obtain the author's original historical workbook files for the documented ticker and date spans; do not substitute daily CRSP quotes for minute bars.
2. Obtain the separate daily market-value/share-count workbook and the prepared TradingDays.dta calendar covering the dates needed by tsfill and post-shock panels.
3. Before staging, verify workbook counts, A1 identifiers, sheet headers, overlapping-part date ranges, and calendar columns against the route contracts.

Validation to perform later:

- Use bounded metadata checks on each delivered file family and then validate full firm/date coverage in a separately authorized author-workflow run.
- Confirm the calendar merge matches all generated dates and retain the intraday and daily market-value sources as distinct products.

### A_ACQUIRE_VENDOR_HISTORIES: Obtain the exact author-specific Datastream/Worldscope, ranking-link, weekly I/B/E/S, FX/TRI, and Figure 1 workbook inputs or verify an authorized compatible route for each.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_DATASTREAM_WORLDSCOPE, R_DISCLOSURE_RANKING_LINK, R_IBES_WEEKLY_COVERAGE, R_FX_AND_TRI_HISTORY, R_SMI_ALLSHARE_FX_FIGURE
Evidence: E_DS_IBES_INPUTS, E_WORLDscope_PERIOD_SELECTION, E_DS_RANKING_FIELDS, E_IBES_WEEKLY_HISTORY, E_FX_TRI_WORK, E_MISC_INPUTS, E_SMI_ALL_SHARE_FIELDS, E_CATALOG_DATA_CANDIDATES, E_PROBE_WRDS_WS_FUNDA, E_PROBE_IBES_WEEKLY_CANDIDATE, E_PROBE_DS_TRI_CANDIDATE

Preparation / proposed procedure:

1. Obtain the named Request Table and FX/TRI workbook plus the manually linked ranking and weekly Spreadsheet Link export through the documented authorized sources or as author-prepared files.
2. Obtain the separate All Share/CHF-EUR workbook used by the Figure 1 code path.
3. Treat local SAS candidates only as leads; verify firm identifiers, item mappings, weekly cadence, needed FX series, and full historical windows before considering any conversion route.

Validation to perform later:

- Check the workbook sheets, variable labels, matching identifiers, required 2013/2014 annual observations, weekly week-54 observation, and both long FX/TRI windows against supplied import code.
- Record a bounded compatibility table for any local candidate before using it; retain unverified candidate mappings as open until supported.

### A_OBTAIN_PREPARED_MANUAL_FILES: Obtain the authors' prepared manual coding and crosswalk workbooks, and confirm their firm identifiers, fields and documented observation coverage; do not recreate the coding independently.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_HANDCOLLECTED_ANNUAL_REPORT, R_SWISS_ADR_CROSSLIST, R_LINKEDIN_FIRM_COUNTS, R_RISK_HEDGING_REPORT_DATA, R_IR_CLUB_POSITION_LINK, R_FACTIVA_HANDCOLLECTED_NEWS
Evidence: E_HANDCOLLECTED_DECL, E_HANDCOLLECTED_FIELDS, E_MISC_INPUTS, E_SWISS_ADR_FIELDS, E_LINKEDIN_REPORT_FIELDS, E_IR_CROSSWALK_FIELDS, E_FACTIVA_FIELDS, E_FACTIVA_WINDOW_AND_HAND_ADJUSTMENTS

Preparation / proposed procedure:

1. Collect the prepared annual-report, ADR, LinkedIn, risk/hedging, IR Club/position, and Factiva files named in the code.
2. Verify firm Type/ID/BloombergCode links and the field lists used by each importer before staging.
3. For Factiva, retain the stated article-date filter and 10 December 2014 collection note; confirm what early-window coverage was available and preserve the two author-coded firm-day adjustments.

Validation to perform later:

- Use bounded workbook metadata and column checks to compare delivered sheets/headers with the corresponding import statements.
- Confirm full required firm matching and coverage in a separately authorized run; do not infer missing values or manually code reports/articles as replacements.

### A_OBTAIN_IBES_DETAIL_FILES: Obtain the author's ticker list and matched I/B/E/S detail-history extract with the announcement timestamp needed for the Swiss-local-date construction.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_IBES_DETAIL_HISTORY
Evidence: E_IBES_DETAIL_FIELDS, E_IBES_DETAIL_SAMPLE_WINDOW, E_PROBE_IBES_DET, E_PROBE_IBES_DETU

Preparation / proposed procedure:

1. Use the documented WRDS/detail-history route or obtain the author's exact ticker workbook and Swiss_IBES_Detail_Data.dta.
2. Verify ANNTIMS and all other required EPS detail fields and confirm the firm ticker links before conversion or analysis.

Validation to perform later:

- Check the delivered history includes 1 December 2014 through 28 February 2015 and can support the specified 11:30 Swiss-time adjustment and firm-day analyst counts.
- Keep local DET/DETU tables as unverified candidates until their timestamp field, firm mapping and history are documented.

### A_OBTAIN_SURVEY_EXPORTS: Obtain the two existing author Qualtrics CSV exports used by the required analyst and IR survey branches, preserving their in-file analyses and downstream IR handoff.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_ANALYST_SURVEY_EXPORT, R_IR_SURVEY_EXPORT
Evidence: E_SURVEY_BRANCHES, E_IR_SURVEY_OUTPUT, E_ANALYST_QUALTRICS_FIELDS, E_IR_QUALTRICS_FIELDS, E_SURVEY_HELPER, E_IR_HELPER

Preparation / proposed procedure:

1. Locate the two dated Qualtrics CSV exports under the author-specified Surveys source folder; do not field new surveys.
2. Preserve the supplied question coding and 90_Additional_Survey_Code.do analyses, and stage all response exports without publishing respondent data.

Validation to perform later:

- Verify UTF-8 header names and expected respondent/question fields with bounded metadata before any authorized processing.
- Confirm the IR branch creates MatchIRDescriptives.dta and IRSurveyData.dta for the later merge; confirm the analyst branch runs its provided in-file analyses.

### A_SETUP_STATA_ADOS: Prepare the four missing Stata add-ons in an authorized ado path; preserve the verified ftools 2.49.1 and reghdfe 6.12.3 installations and author version declarations.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_DISTINCT, S_ROLLSTAT, S_FSUM, S_OUTREG2
Evidence: E_ENVIRONMENT_RUNTIME, E_SOFTWARE_DISTINCT, E_SOFTWARE_ROLLSTAT, E_SOFTWARE_FSUM, E_SOFTWARE_OUTREG2, E_SOFTWARE_REGHDFE, E_MASTER_VERSION_AND_ROOT

Preparation / proposed procedure:

1. Use approved package sources or an existing authorized ado archive to prepare distinct, rollstat, fsum, and outreg2; do not install packages during this assessment.
2. Keep Stata 18, reghdfe 6.12.3, and its verified ftools 2.49.1 dependency recorded in both default and separately configured paths; retain author version 13.1 statements.

Validation to perform later:

- Before a separately authorized run, use Stata which/version checks to confirm the four missing commands resolve in the intended adopath and record versions.
- Confirm ftools and reghdfe still resolve in the intended path; the current environment check confirms both paths, while no author workflow was executed.

### A_RECONCILE_INPUT_INVENTORY: Close the documented input gap by reconciling delivered author-prepared files against all declared workbook, Stata-file, calendar and survey contracts, then retain unknown compatibility as unresolved.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_MISSING_INPUTS
Evidence: E_README_SAMPLE, E_MISC_INPUTS, E_SURVEY_BRANCHES, E_IR_SURVEY_OUTPUT, E_MERGE_INPUT_ORDER, E_PREP_OUTPUTS

Preparation / proposed procedure:

1. Compare the delivered 1_Sources tree with all 18 explicit input requirements and preserve the identifier-only ActualSample151.dta as a sample check, not an analysis panel.
2. If exact files or their coverage/schema remain unavailable, record the precise unresolved contracts instead of inventing an independent rebuild.

Validation to perform later:

- Reconcile every import read and frozen dependency ID to its source requirement, generated intermediate or configuration issue before author execution.
- Do not set closure complete until every mandatory branch and its input producer chain is supported.

### A_RUN_AUTHOR_WORKFLOW: After the documented inputs, workspace and software prerequisites are ready, run the supplied author workflow in its supported producer-consumer order, retaining both survey analyses and all companion programs.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: run procedure
Evidence: E_MASTER_STAGE_ORDER, E_SURVEY_HELPER, E_IR_HELPER, E_MERGE_INPUT_ORDER, E_FINAL_SAMPLE_SAVE, E_PREP_INTRADAY_SAVE, E_PREP_DAILY_SAVE, E_ARCHIVAL_FINAL_DATA_CONSUMERS, E_ARCHIVAL_PANEL_READS, E_LABEL_HELPER

Preparation / proposed procedure:

1. Run 01_Import_Bloomberg.do, 02_Import_HandCollected.do, 03_Import_DatastreamIBES.do, and 04_Import_Various.do in master order to create their declared producer handoffs.
2. Run 05_Import_Sell_Side_Analyst_Survey.do and 06_Import_IR_Survey.do; retain each branch's in-file survey analyses and the shared 90_Additional_Survey_Code.do helper. The IR branch must create MatchIRDescriptives.dta and IRSurveyData.dta for the later merge.
3. Run 10_Merge_Datafiles.do after all six import branches; it consumes BloombergMerge.dta, ReportData.dta, Datastream_IBES_Final.dta, PXLastIntraday.dta, BloombergMVShares.dta, SwissCrossListing.dta, RiskHedgingData.dta, IR_DataArchival.dta, IntradayRollingWindow.dta, NewInformationData.dta, IRSurveyData.dta, ActualSample151.dta, and TradingDays.dta to create Final30MinSample.dta.
4. Run 11_Preparation_Main_Variables.do after the merge; it creates IntradayDataFinal.dta, applies 91_Label Variables.do, and saves DailyDataFinal.dta from the intraday preparation output.
5. Run 20_Main_Archival_Analysis.do last, consuming DailyDataFinal.dta and IntradayDataFinal.dta for the daily and intraday archival analyses and its table outputs, including Table8.doc.

Validation to perform later:

- Record successful completion of each producer before starting its named consumer, and verify each expected handoff exists with the columns required by the next supplied stage.
- Confirm both survey analyses and the 90/91 companions ran in sequence and that the final daily/intraday model outputs are produced; keep execution unverified until an authorized full run completes.


## Remaining issues and prerequisites

- I_MISSING_INPUTS [unresolved; full_pipeline]: The full master workflow requires 18 explicit input families covering Bloomberg minute and daily data, the trading calendar, hand-coded annual-report and firm crosswalk files, Datastream/Worldscope and I/B/E/S histories, Factiva coding, the SMI figure workbook, and both survey exports. The supplied ActualSample151.dta is only the 151-firm identifier list, not the analysis panel. Input contracts and generated handoffs are mapped, but all absent/unverified files, population and historical coverage remain unresolved; no independent reconstruction or substitute dataset is supported.
- I_WORKSPACE_LAYOUT [preparation; full_pipeline]: The master and each of the nine child programs reset STANDARD_FOLDER independently: the master declaration is at line 10, and 01–06, 10, 11 and 20 declare the same root at line 9. Stage the supplied programs under the expected 2_Code directory, set all ten declarations to one common README-compatible host root, and create 1_Sources, 2_Code, 3_Datasets, 4_Output/LogFile and 4_Output/Tables as sibling output subdirectories. This is ordinary working-layout configuration, not a missing-source or filename defect.
- R_BLOOMBERG_INTRADAY [undetermined]: Three-part Bloomberg minute-bar workbook family for each of 241 ticker symbols, separately for Trade, Bid, and Ask. Code reads the company identifier from A1 and each sheet from A3, imports date/open/high/low/last_price/number_ticks/volume/value, deduplicates overlapping dates, fills one-minute gaps, forms 30-minute intervals, and keeps an October 2014–April 2015 firm panel for subsequent analyses.
- R_TRADING_CALENDAR [undetermined]: TradingDays.dta, the manually transcribed Swiss trading-day calendar used after one-minute tsfill and again to construct the post-shock daily information panel. It must cover all dates generated from the intraday sample and distinguish trading from non-trading days.
- R_BLOOMBERG_DAILY_MV [undetermined]: Separate Bloomberg daily market-value workbook used to create current market capitalization/share-count panels and PXLast from the intraday trade file. The required exact workbook is not listed in the package inventory.
- R_HANDCOLLECTED_ANNUAL_REPORT [undetermined]: Author-coded 2013 annual-report workbook for the most recent report available before 15 January 2015, including disclosure score/subscores and firm controls. This is a prepared author input; independent report coding is not an established substitute.
- R_DATASTREAM_WORLDSCOPE [undetermined]: Author Datastream/Worldscope Excel Request Table with per-variable worksheets, firm identifiers, annual fundamentals and linked market variables used to build the firm-year panel. The authors' item-to-variable mapping and exact workbook are not supplied.
- R_DISCLOSURE_RANKING_LINK [undetermined]: Swiss Finance Institute 2014 disclosure-ranking workbook for 2013 reports, augmented by the authors' manual Bloomberg, Datastream, and I/B/E/S links. The author-added matching layer is needed to merge the rank to the constructed firm panel.
- R_IBES_WEEKLY_COVERAGE [undetermined]: Multi-sheet Thomson Reuters Spreadsheet Link weekly I/B/E/S coverage workbook used to derive analyst following for matched firms and retain the final pre-shock weekly observation.
- R_FX_AND_TRI_HISTORY [undetermined]: Datastream workbook containing company total-return indices and USD/EUR exchange rates, merged on daily dates to compute pre/post regime weekly correlations. The separate commercial historical input is not verified locally.
- R_SWISS_ADR_CROSSLIST [undetermined]: Author-assembled Swiss cross-listing lookup that assigns each Datastream Type a cross-listing category for firm-level controls.
- R_LINKEDIN_FIRM_COUNTS [undetermined]: Author-manually collected LinkedIn query counts used for risk, hedging and investor-relations employee measures.
- R_RISK_HEDGING_REPORT_DATA [undetermined]: Author-coded risk-management and hedging variables from 2013 annual reports, consumed by the 04 importer as firm Type-level controls.
- R_IR_CLUB_POSITION_LINK [undetermined]: Prepared IR Club membership indicator and manually linked senior IR-position lookup, merged on firm ID to construct archival IR controls.
- R_IBES_DETAIL_HISTORY [undetermined]: Post-shock daily IBES detail history and author-prepared ticker list used to count distinct analyst EPS revisions by firm-day after local Swiss announcement-time adjustment.
- R_FACTIVA_HANDCOLLECTED_NEWS [undetermined]: Author-read and coded Factiva SNB research articles, one worksheet per firm, used to create firm-date relevant-news counts and combine with daily EPS revisions.
- R_SMI_ALLSHARE_FX_FIGURE [undetermined]: Separate Datastream Swiss All Share, SMI, Prime and EUR/CHF series imported for the paper's Figure 1 output, even though no later supplied code consumes the intermediate file.
- R_ANALYST_SURVEY_EXPORT [undetermined]: Author's 2016 Qualtrics sell-side analyst survey CSV, consumed by code and analyzed within the same branch; the survey analysis remains part of the full master-driver scope.
- R_IR_SURVEY_EXPORT [undetermined]: Author's 2016 Qualtrics investor-relations survey CSV; its in-file analysis creates MatchIRDescriptives.dta and IRSurveyData.dta used for paper analyses and main-variable preparation.
- S_DISTINCT [preparation_required]: Required by the Bloomberg trading-date and time-slot checks but not found in the checked Stata ado paths.
- S_ROLLSTAT [preparation_required]: Required to calculate the rolling standard deviation of returns for intraday analyses but not found in the checked Stata ado paths.
- S_FSUM [preparation_required]: Used for analyst-survey and main archival summary tables but not found in the checked Stata ado paths.
- S_OUTREG2 [preparation_required]: Required to export the archival regression tables but not found in the checked Stata ado paths.

## Review notes

- Source checkpoint saved after reading the datasheet, README, all 12 supplied Stata programs, and targeted appendix sections. No author program or study data was executed.
