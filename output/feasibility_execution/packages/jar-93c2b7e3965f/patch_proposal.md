# Patch proposal: jar-93c2b7e3965f

Do Investors Care Who Did the Audit? Evidence from Form AP

DOI: 10.1111/1475-679X.12392

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied author workflow: per-date TAQ construction and append programs; PCAOB Form AP preparation; SEC filing-index acquisition; R inspection matching; the primary SAS preparation pipeline; and the Stata restatement link. The package contains code and final-sample identifiers but no prepared analysis panel, so no analysis_only bypass is supported. The primary SAS creates volumerestatements2 and provides its Stata trim/scale setup snippet; paper-wide regression/table code omitted from this release is contextual, not a prerequisite to the supplied preparation workflow.

Entry points: `Programs for Submission/00 TAQ Programs/01 Trading Activity Program.sas`, `Programs for Submission/00 TAQ Programs/02 Open Close Price Program.sas`, `Programs for Submission/00 TAQ Programs/03 Bid Ask Spread Program.sas`, `Programs for Submission/00 TAQ Programs/04 Append Daily Files.sas`, `Programs for Submission/01 EDGAR Programs/EDGAR Filings Script.R`, `Programs for Submission/02 SAS Programs/Primary Code Final.sas`, `Programs for Submission/03 R Program Deficiencies/Merge Outside Part with Inspection Findings.R`, `Programs for Submission/04 Stata Programs/AA to PCAOB Restatement Link .do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 5/12392 - Do-Investors-Care-Who-Did-the-Audit-Evidence-from-Form-AP/dlls-datasheet-code-and-identifiers.zip",
      "sha256": "765fe2e7dc7a17f99cdb8d42585adb8da0aca72277446be12bbeb36342676e4f"
    },
    {
      "path": "JAR-Volume 59/Issue 5/12392 - Do-Investors-Care-Who-Did-the-Audit-Evidence-from-Form-AP/dlls-online-appendix.pdf",
      "sha256": "cb902eeed633b7f492a7d3ee8f3affd3555362ffeb52943d341a2371a503880a"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "a37ac2d91d582f8b46e63e23d6fefc56d78516c7f952ccf9710c6f4e5caaf191"
}
```

## Proposed actions

### A_FORMAP_SOURCE: Acquire the official PCAOB AuditorSearch Form AP CSV and perform the manual filing-time and outside-participant preparation documented by the primary SAS.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_FORMAP
Evidence: E_PCAOB_PUBLIC, E_PCAOB_CSV, E_PCAOB_TIMEZONE, E_SAS_FORMAP_PREP, E_PACKAGED_IDENTIFIERS

Preparation / proposed procedure:

1. Use the AuditorSearch whole-dataset CSV as the Form AP source; preserve its original headers and time-zone semantics.
2. Carry out the author-described filing-time text preparation and create OtherParticipantsFile from the outside-auditor participant field.
3. Import the prepared products into SAS as PCAOB_filing and OtherParticipantsFile; retain the supplied final-sample ID CSV only as an identifier reference.

Validation to perform later:

- Before SAS processing, compare the prepared headers/field types with the Form AP fields consumed in the code and record the date span and row coverage.

### A_TAQ_SOURCE_CONFIG: Confirm the WRDS TAQ date schedule and dated-table access, or a compatible staged local route, then make every TAQ library and append output root coherent with that schedule.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: R_TAQ_DATES, R_TAQ_CTM, R_TAQ_CQM, R_TAQ_NBBO, R_TAQ_MAST, I_TAQ_DYNAMIC_SOURCES
Evidence: E_TAQ_README, E_SAS_TAQ_HANDOFF, E_WORKFLOW_TRACE, E_CATALOG_LOOKUP

Preparation / proposed procedure:

1. Confirm access and compatible schemas for ct.ctm_YYYYMMDD, cq.cqm_YYYYMMDD, nbbo.nbbom_YYYYMMDD and mast.mastm_YYYYMMDD through the documented WRDS route or a compatible staged route; the local catalog lookup does not establish these dynamic tables.
2. Create the tradingdays.sas7bdat schedule with tdate and settle its date span against the author workflow; preserve the 20150102 seed used by the append loops.
3. Configure the distinct WRDS folder roots in the four programs and all three RSUBMIT blocks so per-day producers and append consumers share the same outputs.
4. Run 01, 02, and 03 for every tdate, then run all three 04 append blocks; keep the date schedule and generated table names aligned.

Validation to perform later:

- Before running the main SAS file, confirm the date schedule, required fields, seed outputs, output roots, and per-date file coverage using bounded metadata checks.

### A_CRSP_INPUTS: Prepare CRSP_Shares and Historical_Volume using the readable local DSF candidate and check the source-stated date bounds; keep the specific historical ticker producer/query gap unresolved.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_CRSP_DAILY, R_CRSP_HIST
Evidence: E_CRSP_DAILY_REQUEST, E_CRSP_DAILY_CONSUMER, E_HISTORICAL_VOLUME, E_HISTORICAL_TICKER, E_APPENDIX_VOLUME_HISTORY, E_CRSP_DSF_PROBE

Preparation / proposed procedure:

1. Use ${ACCTREPL_SAS_ROOT}/crsp/a_stock/dsf.sas7bdat as the verified-readable candidate for CUSIP, DATE, VOL, and SHROUT; the bounded probe does not establish history or population coverage.
2. Produce CRSP_Shares with the author-required CUSIP/date/volume/shares fields from 2016-01-01 as requested.
3. Resolve the Historical_Volume source beginning 2008 and the author-required ticker field used after the CRSP/TAQ stack; DSF has no ticker and the package supplies no ticker producer, so obtain the author query/mapping before filling it.
4. Preserve the code’s CRSP-before-2017 and TAQ-2017-through-2019 split, the appendix 2009-2019 estimation span, and the event windows.

Validation to perform later:

- Confirm exact input table names, types, CUSIP/date keys, ticker ownership, and the required period coverage before the main SAS join.

### A_COMPUSTAT_INPUTS: Use the readable local Compustat annual and quarterly candidates as preparation routes while resolving the SIC alias and confirming required year coverage.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMP_ANNUAL_ASSETS, R_COMP_SIC, R_COMP_RDQ, R_COMP_FISCAL_QUARTERS
Evidence: E_COMP_FUNDA_PROBE, E_COMP_FUNDQ_PROBE, E_CATALOG_LOOKUP, E_MAIN_IMPORTS, E_COMP_SIC_INPUT, E_RDQ_INPUT, E_FISCAL_QUARTERS

Preparation / proposed procedure:

1. Prepare annual_assets from COMP.FUNDA using cik, cusip, datadate, and at, retaining the fiscal-year join required by SAS.
2. Prepare SIC_Codes from annual fundamentals with CIK/CUSIP/FYEAR and a source SIC field; confirm whether SICH is the intended source for the author’s `sic` before mapping it.
3. Prepare RDQ_Date from COMP.FUNDQ with CUSIP/RDQ and Fiscal_Quarters with CIK/TIC/FYEARQ/FQTR/DATADATE.
4. Confirm coverage for the Form AP joins and the 2008-2019 daily series, including the preceding three quarter dates; the one-row probes establish readable columns only.

Validation to perform later:

- Before SAS, verify field names/types and date/year coverage for each named input against its consumer joins; preserve the source files and any documented aliases.

### A_SEC_INDEX_ACQUISITION: Configure the EDGAR R output directory and the SEC-compliant request settings, then acquire the exact quarterly master indexes named by the supplied script.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: R_SEC_INDEX
Evidence: E_EDGAR_SETTINGS, E_EDGAR_ROUTE, E_SEC_HANDOFF, E_SEC_INDEX_PUBLIC, E_SEC_2019Q4_FILE, E_SEC_USER_AGENT, E_SEC_RATE

Preparation / proposed procedure:

1. Set `store`/working directory in the EDGAR R script to a path visible to the later SAS import.
2. For the 2016Q1-2019Q4 requests, use an HTTP method that declares an identifying User-Agent and remains within the SEC’s current 10-requests-per-second limit.
3. Run the supplied EDGAR script after configuration, then import its resulting filing index as SEC_Filings.

Validation to perform later:

- Confirm the 16 requested quarterly index files are present and that the combined import has CIK, form type, and filing date fields before the Primary SAS Section 2 step.

### A_AA_INSPECTION_INPUTS: Obtain or identify the Audit Analytics inspection report export and its Country Names crosswalk; retain the local FEED89 catalog entry as a candidate only until its fields are confirmed against the actual R/SAS contract.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_AA_INSPECTION_REPORTS, R_COUNTRY_CROSSWALK
Evidence: E_R_DEFICIENCY_INPUTS, E_R_PARTICIPANT_INPUT, E_SAS_INSPECTIONS_HANDOFF, E_CATALOG_LOOKUP

Preparation / proposed procedure:

1. Supply the exact pcaob-reports-1582818827.csv export and Country Namesv1.xlsx expected by the R script, or confirm a documented compatible local source and transformation.
2. Check the report fields for affiliate/headquarter/business geography, auditor names, issuance date, inspection counts and deficiency fields passed through to SAS.
3. Check the crosswalk provides Country and NewCountry and preserve the source spelling and unmatched-country handling.

Validation to perform later:

- Before R, compare both input headers and key fields with the script; do not substitute FEED89 without confirming the downstream country and deficiency columns.

### A_PARTICIPANT_HANDOFF: Confirm and implement the interleaved SAS-to-R participant export, using outside_participants2 as the candidate producer and the R-required filename only after its schema is confirmed.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_PARTICIPANT_HANDOFF
Evidence: E_SAS_PARTICIPANT_PRODUCER, E_R_PARTICIPANT_INPUT, E_R_OUTPUT, E_SAS_INSPECTIONS_HANDOFF

Preparation / proposed procedure:

1. Run Primary SAS through the creation of outside_participants2, which includes Filing_Date.
2. Confirm the exact field aliases/types expected by the R code, then export that producer to outside_participantsv2.sas7bdat in the R working directory.
3. Run the deficiency R program with the two separate Audit Analytics inputs; import AP Inspection Findings.csv into the primary SAS as PCAOB_Inspections before continuing.

Validation to perform later:

- Confirm the exported SAS table opens with the expected participant, country, filing-date, firm-name, and filing-ID fields, and that the R output has the columns the SAS deficiency section uses.

### A_AA_RESTATEMENT_CONTRACT: Resolve the Stata raw restatement input, separate Restatements.dta merge input, and SAS output contract without inventing a file producer or join mapping.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_AA_RESTATEMENTS, R_AA_RESTATEMENT_KEY, I_STATA_LINK_CONTRACT
Evidence: E_STATA_RESTATEMENT_SOURCE, E_STATA_LINK_CONTRACT, E_SAS_RESTATEMENT_HANDOFF, E_SAS_RESTATEMENT_CONSUMER, E_CATALOG_LOOKUP

Preparation / proposed procedure:

1. Identify the exact Audit Analytics raw restatement input and source columns used by the cleaning/date/sample filters.
2. Identify the producer and field schema for `Restatement Data\Created Datasets\Restatements.dta`, including the `restatementkey` consumed by the m:1 merge.
3. Fill the omitted Stata load/save handoffs and the blank `joinby cikcode using` path only after the raw-file/intermediate/output contracts are provided.
4. Produce the Stata linked result required by Primary SAS Section 6 and import it as Restatements; keep the Form AP input separate from the restatement input.

Validation to perform later:

- Use Stata metadata commands to confirm input/output variables and merge keys before resuming Primary SAS at Section 6; verify the final file has the CIK, filing ID, partner ID, key, and disclosure-date fields used downstream.

### A_DUM_MALE_OWNERSHIP: Verify whether dum_male is inherited from the actual Form AP or other imported source schemas through the two whole-table joins; do not infer an absent column or invent a gender model.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_MALE_PRODUCER
Evidence: E_SAS_MALE_REF, E_SAS_WHOLE_TABLE, E_SAS_IDENTIFIERS2_SIC

Preparation / proposed procedure:

1. Check the schemas of the actual inputs to Identifiers and SIC_Codes and trace any dum_male producer through SELECT A.*,B.* and identifiers2 SELECT a.*,b.sic.
2. If the field is present upstream, document that producer; if absent, obtain the authors’ intended source/definition before running the affected join.

Validation to perform later:

- Confirm the upstream owner and type of dum_male and that the identifiers2 consumer receives it before VolumeFormAP is created.

### A_R_PACKAGES: Install the listed R packages into the R 4.5 library used for this project; no packages were installed during the assessment.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_R_PACKAGES
Evidence: E_R_PACKAGE_METADATA, E_R_DEFICIENCY_INPUTS, E_EDGAR_ROUTE

Preparation / proposed procedure:

1. Provision readr, readxl, stringr, haven, lubridate, dplyr, data.table, stringdist, and tidyverse in the selected R library.
2. Keep the runtime at R 4.5.0 unless the authors specify a different compatible release.

Validation to perform later:

- Use installed-package metadata to confirm the named packages are available in the R library before starting either author script.

### A_WINSOR2_SETUP: Make the Stata winsor2 command available in the configured Stata 18 ado path before running the supplied trim/scale preparation block.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_WINSOR2
Evidence: E_WINSOR2_PROBE, E_SAS_STATA_TAIL

Preparation / proposed procedure:

1. Obtain the author/user-written winsor2 ado package from its maintained source or an existing approved local ado directory and add that directory to the active Stata adopath.
2. Extract Primary Code Final.sas lines 2919-2930 into a working-copy Stata do-file after exporting volumerestatements2.

Validation to perform later:

- Use `which winsor2` and help metadata to confirm Stata resolves the command before running the trim/scale snippet.

### A_SAS_RUNTIME_REVIEW: Resolve the local SAS/TKELS startup configuration and confirm SAS/STAT availability before attempting the supplied SAS program; prior startup failures do not establish a license barrier.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS_RUNTIME, SW_SAS_STAT
Evidence: E_ENVIRONMENT, E_SAS_REG_CODE, E_SAS_REG_DOC

Preparation / proposed procedure:

1. Have the local SAS environment owner inspect the existing 9.4 TS1M8/TKELS configuration and establish a successful SAS startup in an authorized setting.
2. Confirm SAS/STAT is installed for PROC REG; do not substitute another estimator or SAS product.

Validation to perform later:

- Record the runtime and component versions from authorized software metadata before attempting the SAS workflow.

### A_NATIVE_RUN_ORDER: After data/schema and software prerequisites are resolved, follow the supplied cross-language producer order and pause at the actual handoffs.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: run procedure
Evidence: E_WORKFLOW_TRACE, E_TAQ_README, E_SAS_PARTICIPANT_PRODUCER, E_R_OUTPUT, E_SAS_INSPECTIONS_HANDOFF, E_EDGAR_ROUTE, E_SAS_TAQ_HANDOFF, E_SAS_RESTATEMENT_HANDOFF, E_STATA_LINK_CONTRACT, E_SAS_STATA_TAIL

Preparation / proposed procedure:

1. Create the tdate schedule; run TAQ programs 01, 02, and 03 per date, then each of the three 04 append RSUBMIT blocks from its 20150102 seed.
2. Prepare Form AP and run Primary SAS through outside_participants2; pause for its confirmed export, run the R deficiency branch, then import AP Inspection Findings.csv as PCAOB_Inspections.
3. Configure and run EDGAR R and import SEC_Filings before the primary SAS reaches the SEC joins. Continue Primary SAS Sections 2-5 with the appended TAQ, CRSP, and Compustat inputs through Abnormal_Volume_Regression2, then pause before Section 6 for the Stata restatement link.
4. Before Primary SAS Section 6, run the Stata restatement link with its resolved raw data, separate keyed Restatements.dta input, and PCAOB input; import the result into SAS as Restatements and resume Section 6. The completed Section 6 creates volumerestatements2.
5. After Section 6 creates volumerestatements2, export it to Stata and run the provided winsor2/scale preparation snippet; paper-wide regression/table code is not a required driver in this package.

Validation to perform later:

- At each handoff, compare names/fields and accessible coverage with the next consumer before continuing; retain logs and generated outputs for coordinator review.

### A_SASCONNECT_OR_LOCAL_APPEND_ROUTE: Verify the native SAS/CONNECT signon and WRDS remote SAS path, while retaining a conditional local append option only if staged daily outputs and MAST inputs match the author contract. These are alternatives; the audit does not require both routes at once.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: SW_SAS_CONNECT, SW_WRDS_SAS_REMOTE
Evidence: E_TAQ_README, E_WORKFLOW_TRACE, E_SAS_TAQ_HANDOFF

Preparation / proposed procedure:

1. For the source-native path, confirm an authorized SAS/CONNECT client, compatible WRDS SAS remote runtime, and visibility of each SIGNON/RSUBMIT input/output library root.
2. If the required per-date TAQ outputs and MAST tables can be staged locally with the same fields, dates, and 20150102 append seed, confirm that a compatible local append route is supported; do not treat it as established by the catalog lookup.
3. Keep the WRDS/raw TAQ access requirement separate from the execution location for the append stage.

Validation to perform later:

- Before running the append stage, record the selected execution route, SAS/CONNECT or local runtime versions, daily input paths, required fields, and append seed compatibility.


## Remaining issues and prerequisites

- I_PARTICIPANT_HANDOFF [unresolved; full_pipeline]: The primary SAS creates outside_participants2 after adding Filing_Date, but no SAS export creates the outside_participantsv2.sas7bdat filename/schema read by R. R writes AP Inspection Findings.csv, which the primary SAS later imports as PCAOB_Inspections; this interleaved handoff needs its exact aliases/fields confirmed.
- I_MALE_PRODUCER [unresolved; full_pipeline]: The primary SAS selects dum_male from identifiers2 without explicitly defining it in the supplied code. Since Identifiers uses SELECT A.*,B.* and identifiers2 carries a.*, the imported Form AP/source fields could supply it; ownership remains unresolved until the actual source schemas and producer are confirmed.
- I_STATA_LINK_CONTRACT [unresolved; full_pipeline]: The Stata preprocessing file has GUI-style load/save commands omitted, an empty joinby cikcode path, and a separate Restatements.dta merge input whose producer/schema are unspecified. Primary SAS Section 6 expects the resulting Stata output as Restatements. The supplied Stata trim/scale snippet at the end of primary SAS is a separate setup handoff.
- I_TAQ_DYNAMIC_SOURCES [unresolved; full_pipeline]: The TAQ programs require a separately prepared tradingdays.tdate schedule and dated CTM/CQM/NBBO/MAST tables, while the append script seeds each product from 20150102 and uses distinct WRDS paths. The date span, source access, per-date schema/coverage and coherent output roots remain unverified; a catalog miss is not evidence of absent access.
- R_FORMAP [public_acquisition_required]: PCAOB Form AP issuer filings and partner/issuer records imported as PCAOB_filing by the primary SAS and selected again by the Stata restatement-link step. The SAS instructions also require a manual extraction of the external-auditor participant field into OtherParticipantsFile; this is a preparation product of the Form AP source, not a separate vendor input.
- R_TAQ_DATES [undetermined]: A SAS tradingdays dataset with tdate values drives the date loop in all four TAQ programs and the append stages. The README says this date list must be created/stored, but no schedule file or producer is included; exact dates and required run span need to be reconciled with the analysis inputs.
- R_TAQ_CTM [undetermined]: Dated NYSE TAQ CTM trade tables (ct.ctm_YYYYMMDD) for the trading-day schedule; used by daily trading activity, open/close price, and spread construction. The required table schema and compatible coverage remain to be checked.
- R_TAQ_CQM [undetermined]: Dated NYSE TAQ CQM quote tables (cq.cqm_YYYYMMDD) for the trading-day schedule; used with NBBO and trade records by the bid/ask-spread program. Required fields and compatible coverage remain to be checked.
- R_TAQ_NBBO [undetermined]: Dated NYSE TAQ NBBO tables (nbbo.nbbom_YYYYMMDD) for the trading-day schedule; jointly required with CQM and CTM to construct official NBBO and effective spreads. Required fields and compatible coverage remain to be checked.
- R_TAQ_MAST [undetermined]: Dated NYSE TAQ MAST security-master tables (mast.mastm_YYYYMMDD) for the trading-day schedule; the append program combines them into Master, which the primary SAS joins to daily trading activity for CUSIP and shares outstanding.
- R_CRSP_DAILY [undetermined]: CRSP daily shares/volume input named CRSP_Shares, requested by the primary SAS beginning 2016-01-01 and joined to TAQ by CUSIP and date. Exact source fields and compatible history need checking.
- R_CRSP_HIST [undetermined]: CRSP daily historical-volume input named Historical_Volume, requested beginning 2008-01-01 and used with TAQ daily volume to construct the firm-specific detrending series. The appendix describes daily-volume estimation from 2009 through 2019; actual code reads CRSP rows before 2017 and TAQ rows from 2017 through 2019.
- R_COMP_ANNUAL_ASSETS [undetermined]: Compustat annual fundamentals input named annual_assets, used to map CIK to CUSIP and later to join assets at fiscal year end. The code reads cik, cusip, datadate, and at; period and identifier compatibility need checking.
- R_COMP_SIC [undetermined]: Compustat annual fundamentals input named SIC_Codes, used to join SIC by CIK/CUSIP and construct industry indicators. The code reads cik, cusip, fyear, and sic; period and match contract need checking.
- R_COMP_RDQ [undetermined]: Compustat earnings-announcement date input named RDQ_Date, joined by CUSIP and daily date to identify event-date controls. Required source fields are CUSIP and RDQ; period coverage and any date alignment need checking.
- R_COMP_FISCAL_QUARTERS [undetermined]: Compustat fiscal-quarter input named Fiscal_Quarters, used to assign fiscal quarters to the 2008-2019 CRSP/TAQ daily series. The code requires CIK, TIC, FYEARQ, FQTR, and DATADATE and joins the current fiscal year to the preceding three quarter dates.
- R_SEC_INDEX [public_acquisition_required]: SEC EDGAR quarterly master index files for 2016 Q1 through 2019 Q4, downloaded by the supplied R script, combined and filtered, then imported as SEC_Filings by the primary SAS. The primary SAS uses CIK, form type, and filing date to build controls for 10-Q, 10-K, 8-K, and other filings.
- R_AA_INSPECTION_REPORTS [undetermined]: Audit Analytics PCAOB inspection-findings CSV named pcaob-reports-1582818827.csv. The R program reads affiliate/headquarter/business country fields, auditor names, issuance date, deficiency counts and deficiency indicators before matching findings to Form AP outside participants.
- R_COUNTRY_CROSSWALK [undetermined]: Country Namesv1.xlsx, the crosswalk jointly required by the R deficiency-matching program to map Form AP country names to inspection-report country names. The R program joins on Country and keys inspection rows by NewCountry; the file is not included.
- R_AA_RESTATEMENTS [undetermined]: The Stata source identifies a raw Audit Analytics restatement file and cleans date/value fields before a CIK join. Exact raw filename, headers, date population and saved intermediate contract are not included; this is separate from the keyed Restatements.dta file imported by merge.
- R_AA_RESTATEMENT_KEY [undetermined]: The Stata file separately merges on restatementkey using Restatement Data\Created Datasets\Restatements.dta. Its producer, fields, path portability and relation to the raw Audit Analytics restatement file are unspecified.
- SW_SAS_RUNTIME [unverified]: SAS 9.4 TS1M8 executable path is documented, but prior empty-session startup probes failed at TKELS initialization. This does not establish a missing license or unavailable runtime.
- SW_SAS_STAT [unverified]: The author code calls PROC REG. SAS documentation places REG in SAS/STAT; the installed component is unverified because SAS startup was not established.
- SW_R_PACKAGES [preparation_required]: The supplied R scripts call readr, readxl, stringr, haven, lubridate, dplyr, data.table, stringdist, and tidyverse; none appears in inspected installed-package metadata.
- SW_WINSOR2 [preparation_required]: The supplied Stata trimming snippet calls winsor2. The Stata helper could not find this command in the checked adopaths; no installation was attempted.
- SW_SAS_CONNECT [unverified]: The supplied TAQ append program uses SIGNON/RSUBMIT blocks. SAS/CONNECT availability and local-to-WRDS compatibility are unverified; no login or runtime trial was performed.
- SW_WRDS_SAS_REMOTE [unverified]: The native TAQ workflow runs dated-table programs and three append blocks on WRDS Cloud. Account/service access and remote SAS runtime compatibility have not been established.

## Review notes

- Workflow trace in probes/workflow_trace.json covers all 41 frozen dependency IDs and now separates Sections 2-5 (through Abnormal_Volume_Regression2), the Stata link, Primary SAS Section 6 (volumerestatements2), and the final Stata trimming/scaling preparation.
- Workflow trace in probes/workflow_trace.json covers all 41 frozen dependency IDs and preserves actual SAS/R/Stata ordering, generated intermediates, source field contracts and unknowns.
- The three bounded local SAS probes read one row only; each has coverage_verified:false. COMP.FUNDA has source SICH rather than the supplied SIC_Codes sic field. CRSP.DSF has no ticker; the Historical_Volume downstream ticker producer remains unresolved.
- The packaged Form AP identifier CSV is one row/one identifier column and is not a prepared analysis panel.
- TAQ dates and source access/coverage remain unverified; the 20150102 append seed and distinct RSUBMIT/output roots must be reconciled with the actual tradingdays schedule.
- Do not infer that dum_male is absent: primary SAS uses whole-table joins, so imported source schemas remain relevant.
- The provided SAS builds volumerestatements2 and includes a Stata winsor/scale preparation snippet. Missing paper-wide regressions and tables are outside the supplied execution workflow and are not treated as a mandatory analysis driver.
- No author program, estimator, statistical command, dataset download, package installation, source edit, or SAS startup was performed during this update.
- Official SEC pages verify the historical master.idx product and the exact 2019Q4 listing; SEC request headers/rate policy still need to be configured in the supplied EDGAR downloader.
- PCAOB AuditorSearch publicly provides the whole Form AP dataset as CSV. Its manual field/time preparation remains part of the author workflow.
- R 4.5.0 and Stata 18 runtimes are present. The R packages are absent from inspected package metadata, winsor2 was not found by the Stata helper, and SAS/SAS-STAT startup/component status remains unverified.
- The 04 TAQ append route uses SIGNON/RSUBMIT and WRDS remote SAS; its compatibility is unverified. A local append route is only a conditional alternative if the exact dated inputs, seed, and fields can be staged compatibly.
- CRSP input periods are source-stated (CRSP_Shares from 2016; Historical_Volume from 2008; the code uses CRSP before 2017 and TAQ through 2019). Coverage remains unverified, but checking those bounds does not require an additional author confirmation; the historical ticker producer remains a specific unresolved handoff.
