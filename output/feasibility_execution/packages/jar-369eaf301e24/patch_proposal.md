# Patch proposal: jar-369eaf301e24

The Disciplinary Role of Financial Statements: Evidence from Mergers and Acquisitions of Privately Held Targets

DOI: 10.1111/1475-679X.12256

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author workflow: CODE1 prepares the SDC acquirer sample; SEC hand collection supplies DISC; CODE2 constructs three outcomes/controls; CODE3 supplies the fourth and matched-control BHAR branch after CODE2 in the same SAS session.

Entry points: `CODE1.sas`, `CODE2.sas`, `CODE3.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 2/12256 - The-Disciplinary-Role-of-Financial-Statements-Evidence-from-Mergers-and-Acquisitions-of-Privately-Held-Targets/chen-datasheet-and-code.zip",
      "sha256": "a2b3ce0f844790585ef28533cb803dcd436d1f9232545dfc0d772e00672f582d"
    },
    {
      "path": "JAR-Volume 57/Issue 2/12256 - The-Disciplinary-Role-of-Financial-Statements-Evidence-from-Mergers-and-Acquisitions-of-Privately-Held-Targets/chen-joar-online-appendix.pdf",
      "sha256": "276a297a6dd43054e74a63ff939301c1196f0788cb5ec95abc00099b9d880650"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "40cdb3dd61d901f9756ae72008dc9cb3eb6c534cd158f822684e7de0b9391280"
}
```

## Proposed actions

### A_SDC: Prepare the SDC acquisition input only after establishing the field mapping for the locally catalogued SDC product or another authorized SDC product.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_SDC_DATA, I_SDC_CONTRACT
Evidence: E011, E012, E019, E044, E048

Preparation / proposed procedure:

1. Map source fields to exact CODE1 names ann, acq_u_cusip, dealvalue and TRG_PUBLIC plus acq_name and SIC fields; do not equate ENTVAL/EQVAL with dealvalue without product documentation.
2. Confirm 1997–2009, public acquirers, merger/acquisition type, private-target screen and documented repeated-acquisition/deal-size screens before writing Sample/sample_all.xlsx.

Validation to perform later:

- Compare workbook headers/types to CODE1 PROC IMPORT and downstream joins.
- Confirm date coverage, target/acquirer classifications, dealvalue units and unique acquisition keys.

### A_LINK: Identify the exact CUSIP-to-GVKEY/PERMNO linktable and missing work.permno producer.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_LINKTABLE, I_LINK_CONSTRUCTOR
Evidence: E013, E016, E053, E045, E062

Preparation / proposed procedure:

1. Provide supported source/schema for chen.linktable with CUSIP8, CUSIP, GVKEY and PERMNO, including any effective-date filters.
2. Identify where work.permno is built and its duplicate/link-selection rule; keep CCMXPF_LINKTABLE as a source lead only because its probed schema lacks the CUSIP fields.

Validation to perform later:

- Check exact source columns and resulting acquirer keys against CODE1 lines 96–107.
- Confirm each retained acquisition has the intended GVKEY and PERMNO before sample_collection is created.

### A_CIK_SEC: Use the documented public EDGAR manual route to build an acquirer CIK crosswalk and code DISC from announcement-related filings.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_CIK_CROSSWALK, R_SEC_FILINGS, I_FIRM_ID_CIK
Evidence: E014, E015, E038, E047, E049, E050

Preparation / proposed procedure:

1. Use each acquirer name/ticker and GVKEY crosswalk to find its CIK in SEC company search; FIRM ID.txt contains GVKEYs, not CIKs.
2. For each transaction announcement date, manually locate related 8-K, 8-K/A, S-4 or proxy filings and inspect for audited private-target financial statements under Regulation S-X.
3. Record CIK, acquisition key, form/date/accession and DISC=1 when such statements are disclosed, otherwise DISC=0 under the datasheet rule. Preserve the manual search record with the resulting workbook.

Validation to perform later:

- Validate CIK/entity matches against acquirer names and announcement dates.
- Check one manual classification per retained acquisition key and trace each classification to a reviewed filing or documented no-disclosure search.

### A_CODE2_DATA: Prepare the exact Sample/data.xlsx input consumed by CODE2 from the screened CODE1 sample, deal characteristics and manual DISC work.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_CODE2_DATA
Evidence: E018, E019, E021, E014, E015

Preparation / proposed procedure:

1. Use CODE1 sample_collection as the transaction/acquirer base and join documented hand-coded disclosure and deal fields to exact CODE2 names: ann, eff, key, gvkey, permno, acq_name, acq_sic, trg_sic, trg_nation_code, dealvalue, percent_stock and percent_cash.
2. Keep the required input names/types; this workbook is not included in the supplied release.

Validation to perform later:

- Compare imported variables/types to every CODE2 read and derivation.
- Check key uniqueness, dates, GVKEY/PERMNO consistency and DISC/payment values before outcome construction.

### A_CODE3_DATA: Resolve the separate CODE3 Data/chen.data input and its handoff from the Sample/manual data.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CODE3_DATA, I_CODE3_HANDOFF
Evidence: E018, E019, E032, E062

Preparation / proposed procedure:

1. Identify the producer and exact schema of Data/data.sas7bdat; determine whether/how it derives from Sample/data.xlsx and which fields/records are preserved.
2. Confirm fields/types for eff, ann, key, gvkey and permno, including whether CODE3 expects a subset or additional hand-coded fields. Do not assume WORK.DATA or CODE2’s Sample libref writes this file.

Validation to perform later:

- Check the Data-library file against every CODE3 consumer and join.
- Reconcile keys and row counts between prepared Sample and Data inputs and verify the ann/eff distinction.

### A_COMPMATCH: Obtain the CODE3 quarterly Compustat–CRSP match input or its supported author construction contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COMPMATCH, I_COMPMATCH_CONSTRUCTOR
Evidence: E029, E045, E062

Preparation / proposed procedure:

1. Specify producer for Data/comp_match.sas7bdat, including GVKEY/LPERMNO link choice, link dates, quarterly observation filters, SIC source and field types.
2. If using local COMP.FUNDQ and CCM components, document the exact merge/population rules before preparing it; the linktable alone is not a substitute.

Validation to perform later:

- Verify fyearq, gvkey, lpermno, datadate, ceqq and sic fields/types.
- Confirm quarterly coverage for dates consumed by CODE3 and compare matched firm/date keys to the monthly return panel.

### A_MCRSP: Validate the author m_crsp contract and resolve the observed HEXCD/exchcd mismatch before treating CRSP.MSF as a usable candidate.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_CRSP_MONTHLY, I_MCRSP_FIELD
Evidence: E030, E031, E046, E048

Preparation / proposed procedure:

1. Inspect the exact m_crsp schema and confirm exchcd semantics.
2. Only if product documentation confirms HEXCD is equivalent for this use, prepare a documented name mapping; otherwise identify the correct source column/file.
3. Ensure history covers the prior 12 and forward 36 months and all firms required for date-specific NYSE breakpoints.

Validation to perform later:

- Compare fields, types, exchange codes and dates to CODE3 m_crsp reads.
- Validate NYSE size/BTM breakpoints and prior/forward returns after an authorized run.

### A_CALENDARS: Resolve the four calendar paths separately and document each date mapping and prior/next convention.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_C2_CAL_EVENT, R_C2_CAL_PRIOR, R_C3_CAL_PRIOR, R_C3_CAL_STANDARD, I_CALENDAR_LIBREFS
Evidence: E022, E032, E058, E062

Preparation / proposed procedure:

1. Identify CODE2’s Sample-library chen.crsp_day_cal_2013 producer and the distinct main.crsp_day_cal_2013_prdt directory; define the MAIN libref instead of guessing its path.
2. Identify both CODE3 calendars under its Data library and reconcile the comment’s 2010 name with executable 2013 names.
3. Document cal_date/caldt mapping, which calendar implements prior versus next trading day, and period coverage.

Validation to perform later:

- Check both fields and dates across relevant announcement/effective dates.
- Validate event-, prior- and next-day mappings against the datasheet without merging distinct directories absent a documented match.

### A_HISTORY: Confirm source-specific history and population after compatible routes are identified; current one-row probes do not establish coverage.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: I_HISTORY_COVERAGE, R_COMPUSTAT_FUNDQ, R_COMPUSTAT_FUNDA, R_CRSP_DSF, R_CRSP_DSI, R_COMPMATCH, R_CRSP_MONTHLY
Evidence: E023, E026, E027, E031, E040, E041, E042, E043, E046, E063

Preparation / proposed procedure:

1. Check CODE1 COMP.FUNDQ pre_year-through-ann_year and nearest datadate selection for each retained event.
2. Check CODE2 COMP.FUNDA eff-year −3..−1 and +1..+3 plus the separate 1990–2012 full-population industry-median input.
3. Check CRSP.DSF/DSI observations inside eventdate−200 to eventdate−60 calendar-day bounds set by CODE2 INTNX("Day") statements. For CODE3, check quarterly match plus monthly prior-12/forward-36 returns, including all firms used for NYSE breakpoints.
4. Use date-bounded metadata or later authorized validation; do not infer full history from one-row probes or require an original snapshot.

Validation to perform later:

- Verify each required window and the full 1990–2012 industry population.
- Record any source-specific coverage gaps and resolve them before constructing reported outcomes.

### A_RET: Clarify the CODE2 ret dataset read at line 191; the market-window stage creates ret2 and no work.ret producer is supplied.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_CODE2_RET
Evidence: E023, E024, E057, E062

Preparation / proposed procedure:

1. Identify the intended producer and exact key/date/return columns for work.ret.
2. If the author confirms ret2 is intended, propose a coherent change only after checking ret_beta, ABR and CAR consumers; do not apply a guessed rename.

Validation to perform later:

- Confirm the intended producer precedes line 188 and that key/date joins to beta are as specified.
- After authorized execution, inspect retained daily observations within the calendar-day bounds and CAR output counts.

### A_THRESHOLD: Confirm whether all threshold1 macro calls should use the constructed threshold variable or a separately defined column.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_THRESHOLD_ALIAS
Evidence: E021, E025, E034, E059, E062

Preparation / proposed procedure:

1. Confirm the intended threshold variable from the author specification.
2. If threshold is confirmed, prepare one consistent proposal for CODE2 lines 258, 381 and 498 and CODE3 line 542.

Validation to perform later:

- Inspect input columns and winsor output for CAR, ROA, industry-adjusted ROA and BHAR.
- Confirm all four branches retain the intended threshold control before later execution.

### A_ANALYSIS: Record the appendix model as a conditional extension if reproducing Table OA1 is in scope; the supplied builders do not consume STOCK_DEAL.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_FINAL_ANALYSIS_DRIVER
Evidence: E028, E034, E035, E036, E057, E061

Preparation / proposed procedure:

1. If final Table OA1 reproduction is intended, obtain the associated regression/table driver and map CAR3, ΔROA, ΔROA_IND and BHAR to the supplied builder outputs.
2. For that conditional branch only, confirm STOCK_DEAL treatment of stock and mixed stock/cash, its TRG_SIZE interaction, controls and year effects; Equation A1 excludes separate STOCK and CASH controls.
3. Keep this request separate from the mandatory CODE1–CODE3 outcome-builder workflow.

Validation to perform later:

- Compare future specifications/sample sizes to Table OA1 and document outcome-specific differences.
- Verify STOCK_DEAL and interaction values under the confirmed payment rule and requested controls/year effects.

### A_SAS: Resolve SAS 9.4 startup and verify documented SAS capabilities and WRDS connection without inferring missing licenses from the current probe.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, SW_CONNECT, SW_STAT
Evidence: E039, E017, E023, E051, E052, E057

Preparation / proposed procedure:

1. Diagnose the existing TKELS startup failure through intended SAS environment support, then perform a self-written empty-session startup/version check.
2. Confirm SAS 9.4 supports PROC IMPORT DBMS=XLSX, SAS/CONNECT SIGNON/RSUBMIT/UPLOAD/DOWNLOAD, and PROC REG through SAS/STAT.
3. Confirm authorized WRDS connection credentials/module availability; do not retry author code or infer licensing from the startup diagnostic.

Validation to perform later:

- Record successful empty-session SAS startup and module checks.
- Verify configured SAS/CONNECT can transfer a self-created empty table before any later authorized workflow run.

### A_RUN_ORDER: After data, calendar, field and software prerequisites are resolved, use the actual producer-consumer order and preserve CODE3’s independent BHAR branch.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: run procedure
Evidence: E016, E017, E018, E019, E022, E023, E029, E032, E033, E034, E056, E059

Preparation / proposed procedure:

1. Before the workflow, apply the supported Sample/Data Linux root mapping in A_PATH_CONFIG and keep the unresolved MAIN calendar location separate.
2. Run CODE1 to produce sample_collection, then complete the documented SEC CIK/filing hand-collection step and prepare CODE2’s Sample/data.xlsx.
3. Run CODE2 after its source/calendar contracts are resolved. Keep CODE2 and CODE3 in the same SAS session because CODE3 consumes WORK.controls and the winsor macro established by CODE2.
4. Then run CODE3 with its distinct Data library and separately prepared data.sas7bdat, comp_match, m_crsp and calendars.
5. Run the final regression/table driver only after it is supplied and mapped to the four outcome outputs. No author program was run during this audit.

Validation to perform later:

- Check outputs in their expected Sample/Data directories and exact next-stage fields.
- Validate event-study windows, pre/post ROA periods, monthly 12/36 return construction, independent matched-control BHAR and final table sample counts.

### A_PATH_CONFIG: For a future authorized batch run, map the known Windows Sample and Data roots and both literal XLSX paths to distinct relative execution roots under the assigned runtime working directory. Keep the unresolved MAIN prior-calendar location separate.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: R_SDC_DATA, R_CODE2_DATA, R_COMPMATCH, R_CRSP_MONTHLY, R_CODE3_DATA, R_C2_CAL_EVENT, R_C2_CAL_PRIOR, R_C3_CAL_PRIOR, R_C3_CAL_STANDARD, I_CODE3_HANDOFF, I_CALENDAR_LIBREFS
Evidence: E004, E007, E022, E032, E058

Preparation / proposed procedure:

1. Set the SAS host wrapper working directory to the assigned runtime work directory before batch launch. Use distinct relative roots `execution/Sample` for CODE1/CODE2 and `execution/Data` for CODE3; create the two subdirectories there if needed.
2. Map CODE1 `libname chen` (line 14) and `sample_all.xlsx` (line 18) under `execution/Sample`, with workbook path `execution/Sample/sample_all.xlsx` relative to the runtime working directory.
3. Map CODE2 `libname chen` (line 17) and `data.xlsx` import (line 22) under the same `execution/Sample`, with workbook path `execution/Sample/data.xlsx` relative to the runtime working directory.
4. Map CODE3 `libname chen` (line 12) under distinct `execution/Data` so its referenced `comp_match.sas7bdat`, `m_crsp.sas7bdat`, `data.sas7bdat`, `crsp_day_cal_2013_prdt.sas7bdat` and `crsp_day_cal_2013.sas7bdat` use that Data root. Root mapping does not establish these files are present or produced.
5. Keep CODE2 `main.crsp_day_cal_2013_prdt` unresolved and separate; do not alias it to Sample or Data until its actual location is identified.
6. Keep the Sample/Data distinction and the Code2-to-Code3 handoff issue; path localization alone does not supply a producer or convert data.xlsx into Data/chen.data.

Validation to perform later:

- Before batch launch, verify the wrapper current working directory is the assigned runtime work directory and that it is writable.
- Resolve CODE1/CODE2 libname and import locations relative to that directory under the same Sample root; verify literal workbook filenames.
- Resolve CODE3 data-library references relative to that directory under the separate Data root and verify required prebuilt inputs are supplied at the documented names.
- Confirm Sample and Data roots are distinct and writable; validate the MAIN calendar independently after its actual path is specified.


## Remaining issues and prerequisites

- I_SDC_CONTRACT [unresolved; full_pipeline]: CODE1 requires SDC-derived ann, acq_u_cusip, dealvalue and TRG_PUBLIC fields plus acquirer/target names and SIC fields. The local SDC.WRDS_MA_DETAILS candidate exposes DATEANN, ACUSIP, APUBLIC, TPUBLIC, ENTVAL and EQVAL; exact mappings, transaction-type fields and period coverage are not established.
- I_LINK_CONSTRUCTOR [unresolved; full_pipeline]: CODE1 joins chen.linktable using CUSIP8/CUSIP and reads GVKEY/PERMNO, then sorts and concatenates an unproduced work.permno table. The probed CCMXPF_LINKTABLE candidate has GVKEY/LPERMNO/link dates but lacks the CUSIP and PERMNO fields this join uses.
- I_HISTORY_COVERAGE [unresolved; full_pipeline]: One-row probes establish local readability/columns for COMP.FUNDA, COMP.FUNDQ, CRSP.DSF and CRSP.DSI, not population or date coverage. CODE1 needs pre_year through ann_year; CODE2 needs eff-year −3..−1 and +1..+3, a 1990–2012 full-population industry input, and daily observations inside the eventdate−200 to −60 calendar-day bounds (the executable INTNX statements use the Day interval); CODE3 needs quarterly match history plus prior 12 and forward 36 monthly returns and date-specific breakpoint populations. Required sample coverage is unverified.
- I_CODE2_RET [unresolved; full_pipeline]: CODE2 creates market-model data as ret2, then joins beta from a separate dataset named ret at line 191. No producer for work.ret appears in the supplied programs; intended table name and contents are unspecified.
- I_THRESHOLD_ALIAS [unresolved; full_pipeline]: CODE2 constructs threshold at line 68, while three outcome branches and CODE3’s BHAR branch call the winsor macro on threshold1. The intended column is unspecified; do not assume threshold1 means threshold.
- I_CALENDAR_LIBREFS [unresolved; full_pipeline]: CODE2 reads chen.crsp_day_cal_2013 and main.crsp_day_cal_2013_prdt, but no MAIN libref is assigned. CODE3 separately reads two calendars under its Data libref; comments refer to 2010 while executable names use 2013. Calendar producers, mappings, directory relationships and coverage remain unspecified.
- I_CODE3_HANDOFF [unresolved; full_pipeline]: CODE2 imports Sample/data.xlsx into WORK.DATA; CODE3 later reads Data/chen.data.sas7bdat. No supplied producer connects these distinct paths/directories, and the shared key/field/type mapping, including ann versus eff, is undocumented.
- I_COMPMATCH_CONSTRUCTOR [unresolved; full_pipeline]: CODE3 requires a prebuilt quarterly Compustat–CRSP comp_match table with fyearq, gvkey, lpermno, datadate, ceqq and sic, but supplies no producer, inclusion/link rules or history contract. The catalogued CCM linktable is not this merged dataset.
- I_MCRSP_FIELD [unresolved; full_pipeline]: CODE3 reads m_crsp with exchcd. The local CRSP.MSF candidate exposes hexcd, not exchcd, and does not establish that author m_crsp exchange-code semantics or required 12/36-month history match.
- I_FINAL_ANALYSIS_DRIVER [preparation; full_pipeline]: Conditional lead beyond the supplied outcome-builder target: Appendix Table OA1 reports final disclosure-performance regressions, but CODE1–CODE3 provide sample/outcome construction and a market-model PROC REG, not the final table driver. If reproducing OA1 is intended, the final regression code and the exact STOCK_DEAL constructor (including mixed stock/cash treatment) need to be identified; this audit does not add those as mandatory builder inputs.
- I_FIRM_ID_CIK [preparation; full_pipeline]: The datasheet says FIRM ID lists CIKs for the final sample, but bounded inspection shows a gvkey header. It is an identifier list, not a filing-ready CIK crosswalk or analysis panel; create and validate the needed acquirer CIK crosswalk via public SEC company lookup.
- R_SDC_DATA [undetermined]: SDC acquisition observations used to create sample_all.xlsx: announced 1997–2009; public acquirers; merger/acquisition transaction type; private targets retained; screens use ann, acq_u_cusip, dealvalue, TRG_PUBLIC, acq_name and SIC fields.
- R_LINKTABLE [undetermined]: CODE1 CUSIP-to-Compustat/CRSP crosswalk consumed as chen.linktable, with CUSIP8, CUSIP, GVKEY and PERMNO-compatible fields; CODE1 also references unexplained work.permno.
- R_CIK_CROSSWALK [public_acquisition_required]: Manual mapping of CODE1 acquirer names/GVKEY to SEC CIKs. Datasheet calls FIRM ID a CIK list, but bounded inspection shows header gvkey and a single-column ID list.
- R_SEC_FILINGS [public_acquisition_required]: Public acquirer EDGAR filings around announcement dates, with manual review of 8-K/8-KA, S-4 and proxy filings to code audited private-target financial-statement disclosure under Regulation S-X.
- R_CODE2_DATA [undetermined]: Hand-collected and deal-characteristics workbook imported by CODE2 from Sample/data.xlsx; exact consumer contract includes ann, eff, key, gvkey, permno, acq_name, acq_sic, trg_sic, trg_nation_code, dealvalue, percent_stock and percent_cash, plus DISC for downstream models.
- R_COMPMATCH [undetermined]: CODE3 quarterly Compustat–CRSP match consumed as Data/comp_match.sas7bdat, with fyearq, gvkey, lpermno, datadate, ceqq and sic; producer, merge filters and historical coverage are not supplied.
- R_CRSP_MONTHLY [undetermined]: CODE3 monthly CRSP stock data consumed as chen.m_crsp with permno, exchcd, date, prc, shrout and ret. It builds 12-month prior returns, 36-month forward returns and date-specific NYSE breakpoints.
- R_CODE3_DATA [undetermined]: CODE3 separately reads chen.data from its Data library. Exact code-consumer fields include eff, ann, key, gvkey and permno; relation to CODE2 Sample/data.xlsx and its schema is undocumented.
- R_C2_CAL_EVENT [undetermined]: CODE2 Sample-library calendar chen.crsp_day_cal_2013 used to map announcement and next trading dates, with cal_date/caldt and semantics consistent with the documented event-day rules.
- R_C2_CAL_PRIOR [undetermined]: CODE2 prior-day calendar main.crsp_day_cal_2013_prdt, with cal_date and caldt. The main libref/path is not assigned in CODE2.
- R_C3_CAL_PRIOR [undetermined]: CODE3 Data-library prior-trading calendar chen.crsp_day_cal_2013_prdt, with cal_date and caldt for comp_match date and acquisition month-end mappings.
- R_C3_CAL_STANDARD [undetermined]: CODE3 Data-library calendar chen.crsp_day_cal_2013, with cal_date and caldt for acquisition effective-date mapping.
- SW_SAS [unverified]: Author runtime is SAS 9.4. The frozen environment probe could not initialize TKELS at sas_u8, so runtime startup and DBMS=XLSX import support remain unverified; this does not establish a missing license.
- SW_CONNECT [unverified]: CODE1/CODE2 use SIGNON, RSUBMIT, PROC UPLOAD and PROC DOWNLOAD. SAS/CONNECT runtime, WRDS connectivity and credentials are unverified.
- SW_STAT [unverified]: CODE2 uses PROC REG to estimate market-model parameters; SAS documentation places PROC REG in SAS/STAT. Module availability is unverified.

## Review notes

- The supplied FIRM ID.txt is a bounded single-column GVKEY list rather than an analysis dataset or the CIK list described in the datasheet; no analysis_only scope is supported.
- The public SEC manual route is available for the described CIK/form/date workflow. The required hand-coding remains a preparation task; no author snapshot identity or author-approval gate is imposed.
- CODE2 writes under its Sample libref while CODE3 reassigns chen to the Data directory. CODE3 also consumes the CODE2 WORK.controls table and winsor macro, so the supplied programs require the stated same-session order and separately resolved Data inputs.
- All 20 frozen dependency IDs are reviewed individually. Local one-row probes support source readability/column availability only; source-specific history, population, constructor and field-alias gaps remain explicit.
- No author SAS program or regression was run. No original author package files were edited; execution_verified remains false.
- Appendix Table OA1 and STOCK_DEAL are retained as a conditional lead for a paper-table extension, not as mandatory external inputs to the supplied CODE1–CODE3 outcome-builder target.
- CODE2’s executable INTNX("Day") statements set calendar-day market-model bounds −200 and −60; CRSP daily rows are joined inside those bounds.
- Added a supported future batch configuration using relative execution/Sample and execution/Data roots from the assigned runtime working directory; no mapping was applied and the MAIN prior-calendar location remains unresolved.
