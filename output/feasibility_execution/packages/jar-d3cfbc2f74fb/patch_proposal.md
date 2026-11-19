# Patch proposal: jar-d3cfbc2f74fb

Foreign Exchange Risk, Hedging, and Tax-Motivated Outbound Income Shifting

DOI: 10.1111/1475-679X.12326

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |
| analysis_only | local_available | preparation_required |

### full_pipeline

Complete supplied author workflow: SAS raw-data preparation and macro, the separate SAS Table 6 and Table 7 preparation branches, and the Stata analyses for Tables 3–7.

Entry points: `SAS_Main Program.pdf`, `SAS_AvgFTR Macro.pdf`, `SAS_DM Test.pdf`, `SAS_Stock Ret Test.pdf`, `STATA_DO.pdf`

Dependency closure: unresolved; see the issues and actions below.

### analysis_only

Run the supplied Stata analyses for Tables 3–7 from their six packaged final analysis DTA files, after extracting the embedded Stata source and adding the documented table-specific file loads. This scope does not rebuild raw data or claim full-pipeline reproduction; Tables 1–2 are not supplied as a Stata analysis branch.

Entry points: `STATA_DO.pdf`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 4/12326 - Foreign-Exchange-Risk-Hedging-and-Tax-Motivated-Outbound-Income-Shifting/deng-datasheet-and-code.zip",
      "sha256": "8ea3e9a4a05a27af4f5bd0b54972517b963c3e85c87b326d8e5a59a924949eb8"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "00bfac8e13ac6114734a95c747b6fd2671ca8cd9d60cd2cc6db875ab93436d80"
}
```

## Proposed actions

### ACT_ANALYSIS_LOADS: Prepare the supplied analysis-only route from the actual PDF and DTA artifacts.

Scopes: analysis_only. Type: run_procedure. Certainty: supported.
Addresses: REQ_ANALYSIS_T3, REQ_ANALYSIS_T4, REQ_ANALYSIS_T5A, REQ_ANALYSIS_T5B, REQ_ANALYSIS_T6, REQ_ANALYSIS_T7, ISSUE_PDF_IMPORT
Evidence: E-DATA, E-STATA, E-STA4, E-STA5A, E-STA5B, E-STA6, E-STA7, E-PROB-T3, E-PROB-T4, E-PROB-T5A, E-PROB-T5B, E-PROB-T6, E-PROB-T7, E-STA5A-CONTRACT, E-STA5B-SIGN, E-STA6-CLUSTER, E-STA6-MANUAL

Preparation / proposed procedure:

1. In an assigned working copy, extract/reflow STATA_DO.pdf to a .do file; retain all authored equations, transformations, samples, and table order.
2. Set the Stata working directory to the analysis-data folder using relative paths. Insert `use "Table 3.dta", clear` at the Table 3 marker, then corresponding loads for Tables 4, 5A, 5B, 6, and 7 at their markers; reload Table 5A after the existing clear.
3. Install the exact vce2way package through its verified repository route before Table 6; keep reghdfe and ftools on the active adopath for Table 7.
4. Run sections sequentially: Table 3 H1; Table 4 functional currency; Table 5A indicator then contract/assets; Table 5B breadth then reversed-sign depth; Table 6 baseline then full nonlinear model; Table 7 narrow then broad bootstrap regressions.
5. Capture a text log and save any result tables to the working output folder; record the manual Table 6 parameter-name adjustment described by the source.

Validation to perform later:

- Confirm each DTA loads with the required fields listed in its requirement, and confirm no table section consumes a prior section’s modified data unintentionally.
- Confirm Stata 18 resolves vce2way and that the supplied vce2way nlsur cluster(gvkey fyear) call runs with the expected two-way clustering; do not change the estimator or cluster keys without author evidence.
- Confirm Table 7 resolves reghdfe and ftools and reports the expected absorbed dimensions and GVKEY bootstrap cluster.
- Compare sample counts, summaries, coefficients, and output tables with the paper after authorized execution; this assessment did not execute regressions.

### ACT_VCE_INSTALL: Install the absent vce2way Stata module from its verified public software repository, then check the exact Table 6 invocation in Stata 18.

Scopes: analysis_only, full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_VCE2WAY
Evidence: E-VCE, E-PUBLIC-VCE, E-STA6, E-STA6-CLUSTER, E-STA6-MANUAL

Preparation / proposed procedure:

1. In the authorized host Stata environment, install vce2way from its documented SSC repository using the reported package name.
2. Keep the downloaded ado/help files in the active Stata PLUS/adopath; do not substitute a different estimator or cluster command.

Validation to perform later:

- Run `which vce2way` in the authorized Stata 18 environment.
- After extracting the source and loading Table 6.dta, validate the authored `vce2way nlsur ..., cluster(gvkey fyear)` command and preserve both cluster variables.

### ACT_LOCAL_RAW_DATA: Map the catalogued Compustat, geographic-segment, CCM and CRSP candidates through compatible local/remote libraries, then verify required year and population coverage before preparing the author-defined inputs.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_COMP_FUNDAMENTALS, REQ_COMP_SEGMENTS, REQ_COMP_COMPANY, REQ_CCMXPF_LINKS, REQ_CRSP_MSF, REQ_CRSP_MSEALL, REQ_CRSP_MSI, ISSUE_SEGMENT_LIBREF
Evidence: E-PROB-COMP-FUNDA, E-PROB-COMP-SEG, E-PROB-COMP-COMPANY, E-PROB-CRSP-LINK, E-PROB-CRSP-MSF, E-PROB-CRSP-MSEALL, E-PROB-CRSP-MSI, E-MAIN-GEO, E-MAIN-COMPANY-CCM, E-MAIN-L4, E-STOCK-WINDOW, E-MAIN-COMPANY, E-MAIN-CCM-DATE, E-STOCK-CRSP-WINDOW, E-STOCK-DATE-MATCH

Preparation / proposed procedure:

1. Map the physical geographic-segment candidate at ${ACCTREPL_SAS_ROOT}/comp/d_seghist/wrds_segmerged.sas7bdat through a compatible COMP libref or stage it under the two-level name comp.WRDS_SEGMERGED. The catalog label COMPSEG versus COMP is an ordinary configuration detail, not an author-byte identity requirement.
2. Verify annual Compustat history supports the 1997–2017 target plus t−4 controls and t−5 functional-currency rows; obtain the AvgFTR n contract separately before claiming its rolling-history coverage.
3. Verify that CCM link dates and types cover the author join filters and fiscal intervals.
4. Verify monthly CRSP files cover all included clusters and the nested inclusive 0–59-month windows. With complete continuous monthly data this is up to 119 total observations including the cluster month (118 prior); preserve the source count-completeness conditions and ±10-day fiscal-date matching.
5. After the exact mappings and coverage are established, prepare inputs using the supplied SAS selection and joins without replacing variables, sample filters, link rules or estimators.

Validation to perform later:

- Confirm each mapped source has the fields recorded in its requirement and that required annual/monthly history is present; one-row probes establish readability/columns only.
- Check geotp values against the author’s _2=dsale and _3=fsale transpose contract and verify required date history; these meaning/coverage checks remain separate from libref staging.

### ACT_MANUAL_INPUTS: Resolve the exact author-prepared country and hand-coded hedge inputs before running their import and merge branches; do not reconstruct them from source descriptions or assume local SEC roots contain the author-coded table.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_EX21_COUNTRY_DATA, REQ_ICRG_FX_RISK, REQ_POLITICAL_STABILITY, REQ_CAPITAL_CONTROLS, REQ_HAND_COLLECTED_HEDGE, ISSUE_MANUAL_INPUTS
Evidence: E-MAIN-EX21, E-MAIN-ICRG, E-MAIN-PS, E-MAIN-CC, E-MAIN-HEDGE, E-SEC-ROOTS, E-MAIN-HEDGE-OUTPUT, E-MAIN-OP-OUTPUT, E-MAIN-COMP03-WINSOR, E-DATA-EX21, E-DATA-ICRG, E-DATA-CAPITAL

Preparation / proposed procedure:

1. Obtain or identify the exact Exhibit 21, ICRG FX, ICRG political-stability, capital-control and author hand-collected fx.hedge files/editions expected by the program.
2. For each input, confirm its original import format, variable dictionary, identifiers, country/year coding, units, date ranges and coverage of the author’s stated match windows.
3. For hedge records, confirm how cik/fyear, matched_date_hedge, l4FX_contract and l4Hedge are defined and how those author values were collected; use the local SEC roots only as bounded document candidates if the author protocol confirms that source.

Validation to perform later:

- Confirm the imported field names and code values match the exact SAS consumers before merge; verify unmatched/missing counts and target-year coverage after authorized preparation.

### ACT_SAS_RUNTIME_SETUP: Establish the SAS runtime and remote-session configuration required by the supplied RSUBMIT, upload/download and PROC MODEL branches.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: SW_SAS_RUNTIME, SW_SAS_CONNECT, SW_SAS_ETS, ISSUE_SAS_SETUP
Evidence: E-ENV, E-MAIN, E-DM, E-RET, E-STOCK-MODEL

Preparation / proposed procedure:

1. Diagnose the documented SAS 9.4 batch startup failure at TKELS with the system SAS administrator; the current probe does not show whether SAS or a license is unavailable.
2. Verify SAS/CONNECT, the remote server/session, and SAS/ETS PROC MODEL availability; no module install or license claim is supported by the present probes.
3. Map each source libref and output path to the local or remote session that owns it, including FX, EXP, COMP, COMPSEG and CRSP; preserve the producer-to-consumer location across RSUBMIT boundaries.

Validation to perform later:

- Run bounded SAS startup and module/session checks after configuration, then confirm local and remote library assignments and a harmless transfer before running any supplied program.

### ACT_AVGFTR_CONTRACT: Confirm the intended AvgFTR macro arguments and output handoff before adding a call to an assigned working copy.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_AVGFTR_CALL
Evidence: E-MACRO, E-MACRO-WINDOW, E-MAIN-AVGFTR-JOIN, E-DM, E-MACRO-HEADER, E-MACRO-5YEAR-COMMENT

Preparation / proposed procedure:

1. Confirm the intended value of n, the dsetout name, and the exact call site/order that produces fx.avgftr for both Main and SAS_DM Test.
2. Confirm the required prior-year history and the naming of the intermediate columns consumed by both programs; do not infer n=5 from the comment alone.
3. Only after the contract is confirmed, add the documented macro invocation to a working copy and preserve the author’s macro calculations.

Validation to perform later:

- Confirm fx.avgftr is created before both consumers, contains the expected GVKEY/fyear keys and AvgFTR fields, and covers their required match/sample history.

### ACT_BIS_REER_INPUT: Resolve the exact paper-era BIS real effective exchange-rate series and return construction used to create exp.fxi.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_BIS_REER_RETURNS, ISSUE_BIS_CONSTRUCTOR
Evidence: E-STOCK-BIS, E-STOCK-FXI, E-STOCK-WINDOW, E-DATA-BIS

Preparation / proposed procedure:

1. Confirm the precise 2010-base broad and narrow BIS REER series identifiers, economy membership/weighting, historical vintage and date convention consistent with the source’s 61/27-economy specification.
2. Confirm the author’s transformation from those native REER levels to exp.fxi fields date, ret_nFXI and ret_bFXI, including the first required index observation before the return sample.
3. Obtain or prepare only those verified native REER inputs and construct exp.fxi according to the confirmed author mapping; do not substitute nominal exchange rates or NEER.

Validation to perform later:

- Check exp.fxi has the required date and both return fields over every required 60-month window, then verify complete nonmissing count requirements before the stock-return estimator.

### ACT_STOCK_HEDGE_HANDOFF: Resolve the distinct Table 7 exp.hedge input and its relationship, if any, to the main financial-hedge preparation branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_STOCK_TABLE7_HEDGE, ISSUE_STOCK_HEDGE_HANDOFF
Evidence: E-MAIN-HEDGE, E-STOCK-HEDGE, E-STOCK-OUTPUT, E-MAIN-HEDGE-OUTPUT, E-MAIN-OP-OUTPUT, E-MAIN-COMP03-WINSOR

Preparation / proposed procedure:

1. Identify the intended exp.hedge source and whether it is an independently prepared table or a documented transform of fx.hedge.
2. Confirm how source hedge observations map to ciknumber/fyear/hedge and how those fields align with the main fx.hedge CIK/fyear/matched_date_hedge/l4FX_contract/l4Hedge fields.
3. Do not infer an alias or create a conversion until the author’s data contract specifies it.

Validation to perform later:

- Confirm the exact exp.hedge schema and CIK-year match counts at the Table 7 consumer before running the stock branch.

### ACT_FULL_BRANCH_ORDER: Run the supplied companion preparation branches only after their shared producers, data inputs and library/session locations are confirmed.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: ISSUE_BRANCH_ORDER
Evidence: E-DATA, E-MAIN-AVGFTR-JOIN, E-DM-MAIN-HANDOFF, E-STOCK-WINDOW, E-MAIN-HEDGE, E-STOCK-HEDGE, E-STOCK-COMP

Preparation / proposed procedure:

1. After resolving the AvgFTR call and shared librefs, run its producer before Main and SAS_DM consumers that join fx.avgftr.
2. Run SAS_Main with the required raw and manual inputs to create the documented Comp03_all, sample/risk, functional-currency, financial-hedge and operational-hedge intermediates; retain separate branches.
3. Run SAS_DM Test after the Main branch has produced z7 and after the macro output/control data exist; retain its author-specific year matching and sample screens.
4. Run SAS_Stock Ret Test after Comp03_all, CRSP, native BIS exp.fxi and the explicitly resolved exp.hedge input are available; preserve its two 60-month windows and both narrow/broad models.
5. After all SAS outputs are made explicit, run the Stata table sections from their corresponding final table data in the supplied order.

Validation to perform later:

- Before each consumer, verify that its named producer ran in the same reachable session/library and that the exact expected intermediate fields and keys exist.
- Retain all six final table outputs and compare their field contracts with the six matching Stata sections before estimation.

### ACT_FINAL_OUTPUT_CONTRACT: Resolve the unfinished winsorization and export contracts for every full-pipeline table before treating the PDF programs as complete producers of the six Stata DTA files.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_WINSOR_EXPORT
Evidence: E-MAIN-SAMPLE, E-MAIN-HEDGE, E-MAIN-OP-WINSOR, E-DM-MAIN-HANDOFF, E-STOCK-OUTPUT, E-DATA, E-STATA, E-STA4, E-STA5A, E-STA5B, E-STA6, E-STA7, E-MAIN-HEDGE-OUTPUT, E-MAIN-OP-OUTPUT, E-MAIN-COMP03-WINSOR, E-DM-EXPORT

Preparation / proposed procedure:

1. Confirm the intended winsorization procedures/thresholds and output dataset names at each SAS placeholder for Tables 3–5, Table 6 and Table 7.
2. Confirm the author’s SAS-to-Stata export format, exact six filenames, output location and generation order.
3. Only after those specifications are available, complete the extraction/working-copy pipeline and add the documented exports; preserve each author branch and all table-specific variables.

Validation to perform later:

- Read each generated output with a bounded DTA metadata/one-row probe and confirm all columns consumed by the matching Stata section, identifiers and intended period.
- Confirm the outputs come from their documented SAS producers and that no output is silently sourced from a different branch or directory.

### ACT_FULL_STATA_SETUP: Prepare the Stata end of the full pipeline after verified SAS exports have created all six table DTA files.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: ISSUE_PDF_IMPORT
Evidence: E-DATA, E-STATA, E-STA4, E-STA5A, E-STA5B, E-STA6, E-STA7, E-MAIN-SAMPLE, E-STOCK-OUTPUT

Preparation / proposed procedure:

1. Extract and reflow STATA_DO.pdf into an assigned working .do copy; preserve all authors’ equations and table sections.
2. Configure a working directory with the six verified SAS-exported DTA files and add a corresponding use command at each existing table-data marker, including the Table 5A reload after clear.
3. Set up the documented Stata add-ons and execute the Stata sections only after the preceding SAS outputs have been verified.

Validation to perform later:

- Confirm each table load resolves to its corresponding full-pipeline export and required fields; compare samples and results to the paper only after authorized execution.


## Remaining issues and prerequisites

- ISSUE_PDF_IMPORT [preparation; full_pipeline, analysis_only]: The five substantive programs are embedded in PDFs. STATA_DO.pdf marks each dataset load in prose but supplies no executable use/import statement or working-directory configuration. Extract and reflow copies; add ordinary relative-path loads for the matching table DTA files, including reloading Table 5A after clear.
- ISSUE_SAS_SETUP [unresolved; full_pipeline]: The supplied SAS PDFs assume RSUBMIT/ENDRSUBMIT and PROC UPLOAD/DOWNLOAD but provide no LIBNAME, SAS/CONNECT session, remote-server, or data/output path configuration. The local SAS binary startup probe failed at TKELS; this does not establish whether SAS, SAS/CONNECT or SAS/ETS is licensed/configured.
- ISSUE_SEGMENT_LIBREF [preparation; full_pipeline]: The author program reads comp.WRDS_SEGMERGED while the matching local physical candidate is catalogued under a different libref. Configure a compatible COMP libref or stage the candidate at the program’s expected two-level name; this is ordinary path/library preparation and does not require proving original author-libref identity. The geotp value mapping and historical coverage remain separate unresolved data questions in REQ_COMP_SEGMENTS.
- ISSUE_AVGFTR_CALL [unresolved; full_pipeline]: The supplied AvgFTR file defines caller-supplied n and dsetout and has a comment about five-year sums. The main and DM programs join fx.avgftr, but no macro call supplies n/output, and the main program does not document a producer order. Do not infer n=5 from the comment.
- ISSUE_MANUAL_INPUTS [unresolved; full_pipeline]: The complete SAS workflow contains import placeholders for the author’s Exhibit 21 country data, ICRG FX scores z1, political-stability fx.ps, capital-control fx.cc, and hand-collected fx.hedge. Their products, files, editions, field/date coding and sample coverage are not supplied or fully specified; local SEC directory roots alone do not establish the coded hedge data.
- ISSUE_BIS_CONSTRUCTOR [unresolved; full_pipeline]: The stock program names 2010-base BIS broad/narrow real-effective-exchange-rate indices but assumes exp.fxi returns already exist. It does not identify exact series codes, country weights/mapping, the index-to-return transformation or the author-era vintage/history matching the stated 61/27-economy universe. Native BIS REER inputs must be retained; nominal FX/NEER measures are not substitutes.
- ISSUE_STOCK_HEDGE_HANDOFF [unresolved; full_pipeline]: SAS_Stock Ret Test consumes exp.hedge(ciknumber,fyear,hedge), while SAS_Main only names hand-collected fx.hedge and builds fx.hedge1/2 with matched_date_hedge, l4FX_contract and l4Hedge before a winsorize/export placeholder. No supplied code establishes that these data or schemas are the same or exports exp.hedge.
- ISSUE_BRANCH_ORDER [unresolved; full_pipeline]: Required SAS branches span multiple PDFs and share generated data: the AvgFTR macro output is joined by Main and DM, DM explicitly says to run Main to obtain z7, and the stock-return branch uploads Main’s Comp03_all. The exact macro call, shared local/remote library state and executable order are not fully documented; preserve all companion branches and verify producers before consumers.
- ISSUE_WINSOR_EXPORT [unresolved; full_pipeline]: The supplied SAS programs leave winsorization and export as placeholders for the main Compustat sample, financial/operational hedge tables, DM table and Table 7 branch. They do not identify or demonstrate creation of all six final Table 3/4/5A/5B/6/7 DTA files consumed by Stata; the exact final output contract and placement are unresolved.
- REQ_COMP_FUNDAMENTALS [undetermined]: All supplied SAS branches read Compustat annual fundamentals with INDL/STD/C/D filters. Main final sample is fiscal 1997–2017, while four-year controls and the functional-currency calculation require earlier annual rows (the latter reaches t−5); AvgFTR history depends on an unspecified macro n. The precise row history and source population coverage remain unverified.
- REQ_COMP_SEGMENTS [undetermined]: Main, AvgFTR and Table 6 preparation read geographic Compustat segments and derive domestic and foreign sales through the geotp transpose. The local candidate has the required columns and can be staged through a compatible COMP library mapping; geotp-to-_2/_3 meaning and required historical coverage remain unverified.
- REQ_COMP_COMPANY [undetermined]: Main and Table 6 preparation join COMP COMPANY to provide FIC and SIC by GVKEY for U.S. filters and industry coding; population coverage is not established by the bounded probe.
- REQ_CCMXPF_LINKS [undetermined]: Main preparation requires CCMXPF dated GVKEY–PERMNO links filtered by accepted link types, USED flag and overlap with each Compustat fiscal-year interval; link population and valid-date coverage are unverified.
- REQ_CRSP_MSF [undetermined]: Stock-return preparation requires monthly security returns from CRSP MSF. The source uses inclusive 0–59-month windows for both 60-month cumulative returns and a 60-observation estimation history. Under complete continuous monthly data, their nested union contains up to 119 total monthly observations including the CRSP cluster month (118 preceding months), subject to the source count-completeness conditions. The fiscal-date match is within ±10 days. Date history and sample support are unverified.
- REQ_CRSP_MSEALL [undetermined]: Stock-return preparation joins CRSP MSEALL to obtain exchange and share codes by PERMNO and date, then carries the last observed codes forward within security histories. Matching coverage is unverified.
- REQ_CRSP_MSI [undetermined]: The stock-return branch joins CRSP market-index returns by month and requires both value-weighted and equal-weighted monthly returns. The local candidate fields match, but date-history coverage is unverified.
- REQ_EX21_COUNTRY_DATA [undetermined]: Main preparation explicitly expects Scott Dyreng Exhibit 21 country-level data. The code needs CIK/date, country counts and identifiers, country/ISO3 and TAXHAVEN fields and matches country observations approximately five years later within ±12 months. The datasheet identifies an author-prepared EX-21 dataset URL, but the packaged input, schema and exact date coverage are unverified.
- REQ_ICRG_FX_RISK [undetermined]: The main FX-risk branch expects a wide ICRG country/year score file, transposes it to Country_Code/year/score and matches it to Exhibit 21 country counts before the approximately five-year ±12-month firm match. The datasheet identifies ICRG and a subscription provider URL, but exact source edition, fields and history remain unresolved.
- REQ_POLITICAL_STABILITY [undetermined]: Main preparation separately expects imported ICRG political-stability points in fx.ps with country codes and wide year columns, transposes them into PSIndex, and joins to Exhibit 21 country counts. The datasheet identifies ICRG subscription data, but the exact series, edition, variable coding and history remain unresolved.
- REQ_CAPITAL_CONTROLS [undetermined]: Main preparation expects fx.cc with ISO3/year/kao country-year observations to construct firm-level l4cc through Exhibit 21 country weights. The datasheet identifies the Fernández et al. (2015) capital-controls data appendix at NBER, but the exact kao mapping, scale, file fields and required historical coverage remain unresolved; no substitute proxy is assumed.
- REQ_HAND_COLLECTED_HEDGE [undetermined]: Main preparation requires author hand-collected fx.hedge data with CIK/fiscal-year matches, matched_date_hedge, l4FX_contract and l4Hedge. The package does not supply the underlying file or its coding, alignment and coverage specification. Exact SEC exhibit roots exist locally but have not been swept for CIK/year/section coverage and do not establish the author-coded values.
- REQ_STOCK_TABLE7_HEDGE [undetermined]: The stock-return branch separately joins exp.hedge by ciknumber/fyear and consumes hedge. The main program’s hand-collected fx.hedge schema is different and the supplied PDFs do not specify a producer, transformation, or export from that input to exp.hedge; this cross-branch handoff remains unresolved.
- REQ_BIS_REER_RETURNS [undetermined]: The stock-return branch uploads exp.fxi with date, ret_nFXI and ret_bFXI and forms 60-month cumulative returns. The paper-era source specifies 2010-base broad/narrow BIS real effective exchange-rate indices (61/27 economies); the datasheet names the BIS EER page and July 2018 retrieval. Exact series IDs, economy mapping, historical vintage and index-to-return construction for exp.fxi remain unresolved. Native BIS REER measures are required; nominal FX or NEER proxies are not compatible substitutes.
- SW_VCE2WAY [preparation_required]: The exact invoked command is absent from the current Stata 18 adopath; an authoritative repository route exists for this free Stata module. Installation and compatibility with the supplied nlsur call remain future setup/validation.
- SW_SAS_RUNTIME [unverified]: The SAS 9.4 executable path exists, but bounded startup failed at TKELS. This does not establish that SAS is absent or unlicensed; runtime readiness remains unverified.
- SW_SAS_CONNECT [unverified]: The programs require RSUBMIT/ENDRSUBMIT and PROC UPLOAD/DOWNLOAD; SAS/CONNECT module and remote-session configuration have not been verified.
- SW_SAS_ETS [unverified]: The Table 7 branch uses PROC MODEL for GMM estimation; availability of the SAS/ETS procedure and license has not been verified.

## Review notes

- The package static audit marked no supported code, but all five supplied program PDFs contain substantive SAS or Stata preparation/analysis programs; the datasheet identifies the six corresponding final DTA analysis inputs.
- The six bounded DTA header/read probes confirm separate table datasets and table-specific consumer fields: Table 3 (5,432 rows), Table 4 (5,432), Table 5A (6,271), Table 5B (5,432), Table 6 (5,736), and Table 7 (3,186). Header row counts are DTA file metadata and do not establish sample/date fidelity. All fields consumed by each matching Stata section are present.
- A supported analysis_only route exists from the six packaged DTA inputs to Stata Tables 3–7 after extracting/reflowing the embedded PDF and adding the indicated table-specific loads. Stata 18, reghdfe 6.12.3 and ftools 2.49.1 are available. vce2way is absent from the active Stata adopath; its exact repository/install route is recorded as setup evidence. No regression was run.
- Full-pipeline local raw candidates were checked with bounded one-row SAS reads: COMP.FUNDA, the geographic segment file, COMP.COMPANY, CCMXPF LINKTABLE, CRSP MSF, MSEALL and MSI. Matching source fields support local candidate routes, but exact history/population coverage remains unverified. The geographic file can be staged through a compatible COMP libref as ordinary configuration; geotp category meaning and historical coverage remain unresolved. SAS row counts from those probes are not claimed.
- The full SAS workflow also requires Exhibit 21, ICRG FX and political-stability, capital-control, and hand-coded hedge inputs. Datasheet source URLs are preserved as unverified candidates. The Main and DM branches share the AvgFTR and FX-risk intermediates; the macro caller/parameter/output is unspecified and SAS_DM explicitly requires z7 from Main. The stock-return branch requires CRSP, native 2010-base BIS REER broad/narrow measures and exp.fxi return fields, 60-month cumulative returns plus a 60-observation estimation window (under complete continuous data the nested union is 119 total monthly observations including the cluster month, 118 prior months), source count-completeness rules and ±10-day fiscal-date matching, and a separate exp.hedge input with no documented producer/handoff.
- SAS runtime/CONNECT/ETS availability is unverified because the bounded SAS startup probe failed at TKELS. SAS PDFs leave runtime/session/library configuration, several manual data imports, macro invocation, winsorization and final export contracts unresolved; they do not demonstrate production of all six DTA table outputs. Full-pipeline closure is therefore incomplete and this scope is not represented as a raw-data reproduction success.
- No author code was executed, imported, compiled or edited; no study data were downloaded or imported; no regressions or installations were run. Only bounded source/PDF inspection, DTA header/one-row reads, authorized one-row SAS metadata/data probes, exact path checks and tiny self-written software probes were used. The frozen dependency checklist is empty; no synthetic dependency identifiers were added.
- Datasheet lines 24–37 identify author-source candidates: the EX-21 dataset URL, ICRG subscription provider, NBER w20970 capital-controls appendix, and BIS EER page. These routes are recorded as unverified candidates only; current availability, required fields, exact variables, coverage and historical vintages remain unresolved.
