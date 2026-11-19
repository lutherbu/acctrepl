# Patch proposal: jar-b0bbd79e00dc

Aggregated Compensation Peer Group Disclosure and Managerial Labor Market Competition: A Network Analysis

DOI: 10.1111/1475-679X.70026

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented job-hopping and managerial-labor-market-competition workflow, including the manual UCINET preparation and companion analyses/figure files.

Entry points: `code, identifiers, and log files/Readme.docx`, `GL datasheet.pdf`, `code, identifiers, and log files/cleaning code/ConstructSample_competition.do`, `code, identifiers, and log files/analysis code/Analysis_competition.do`, `code, identifiers, and log files/analysis code/Analysis_hopping.do`, `code, identifiers, and log files/analysis code/Figure 1.ipynb`, `code, identifiers, and log files/analysis code/Table 1A.do`, `code, identifiers, and log files/analysis code/Table 1B.do`, `code, identifiers, and log files/cleaning code/clustering coefficient.do`, `code, identifiers, and log files/cleaning code/Construction of network measures.docx`, `code, identifiers, and log files/cleaning code/Memo for UciNet.txt`, `code, identifiers, and log files/cleaning code/hopping.sas`, `code, identifiers, and log files/cleaning code/pay for luck.sas`, `code, identifiers, and log files/cleaning code/peer selection summary stats.sas`, `code, identifiers, and log files/cleaning code/tournament.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 2/70026 - Aggregated-Compensation-Peer-Group-Disclosure-and-Managerial-Labor-Market-Competition-A-Network-Analysis/gl-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "19959bf5ed0158a69eb147b4389b090cb222e95a506d5b5118ddf26caf2ac693"
    },
    {
      "path": "JAR-Volume 64/Issue 2/70026 - Aggregated-Compensation-Peer-Group-Disclosure-and-Managerial-Labor-Market-Competition-A-Network-Analysis/gl_online-appendix.pdf",
      "sha256": "1878c0aecb30556d6c7eb67a1526729d443cd1dc8877739fe4b454d34c6d483a"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "a8cbf5e695a6e10d7a77e89a38a3e3f5dced12707905b6c96bbf159d449a0039",
  "work_item_sha256": "2e5df1d13de60ab3d56d8eae87dd6ef1b35951454fbbafabf4c676bd0917e092"
}
```

## Proposed actions

### A_AUTHOR_PREPARED_INPUTS: Obtain or identify the exact author-prepared inputs cited by the supplied files; retain each file's identity and source-specific contract.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_EXEC_NONCEO, R_CEO_COMP, R_FIN_CONTROLS, R_PEERPAY_PANEL, R_SIZE_MATCH, R_DURATION, R_CEO_TENURE, R_TOURN_GAP, R_DELTA, R_VOLATILITY, R_COMP_CONSULTANT, R_GAI, R_NEWPAYPEER, R_PAYPEER_NETWORK, R_NETWORK_XLSX, R_TOURN_NETWORK_PEERS_XLSX, R_CLUSTER_CSV, R_EUCLID_C, R_EUCLID_R, R_TOURN_COMP_RAW, R_TOURN_NETWORK_MEASURES, R_HHI, R_FUTURE_PERFORMANCE, R_BOARD_DATA, R_EINDEX, R_CADMAN_CONTROLS, R_FIG1_REASONS
Evidence: E_WORK_ITEM, E_README_IDENTIFIERS, E_COMP_CEO, E_COMP_TEMP, E_COMP_PEERPAY, E_COMP_SIZE_MATCH, E_COMP_DURATION, E_COMP_TENURE, E_COMP_TOURN_GAP, E_COMP_DELTA, E_COMP_VOL, E_COMP_CONSULT, E_COMP_GAI, E_TABLE1B_JOIN, E_CLUSTER_INPUT, E_HOP_NETWORK_XLSX, E_TOURN_NETWORK_PEERS, E_EUCLID_YEAR_CALLS, E_TOURN_IMPORT_COMP_RAW, E_TOURN_FUNDA, E_ANALYSIS_HHI, E_ANALYSIS_PERFORMANCE, E_ANALYSIS_BOARD, E_ANALYSIS_EINDEX, E_ANALYSIS_CADMAN, E_FIG1_IMPORT

Preparation / proposed procedure:

1. For each named DTA/XLSX/control panel, obtain the author's exact prepared file or a documented source route; do not treat the packaged CIK/GVKEY identifier lists as analysis data.
2. Record the producer/provider, file format, join keys, all visible expected variables and period for every input; keep separately named panels distinct unless the author confirms compatible construction.
3. For masked input paths, resolve the exact file identity through a reviewed source view before assigning a run path; do not infer a proprietary restriction from the mask.

Validation to perform later:

- Compare each acquired/readable file's format, keys, full required columns and dates with the specific merge/use shown in the cited program.
- For Table 1B, retain prior-year peer pairs needed by the one-year turnover join; for lead/performance and rolling return inputs, validate the additional construction history explicitly.
- Record source version and missingness/coverage checks before any authorized execution.

### A_LOCAL_RESOURCE_FIELDS: Use successful bounded probes for matching local Compustat/Execucomp/CRSP/I/B/E/S raw components, while keeping specific unverified fields and prepared-panel contracts separate.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMP_FUNDA, R_TOURN_FUNDA_LOCAL, R_COMP_SEGMENT, R_EXECUCOMP_ANNUAL, R_DOW_MEMBERSHIP, R_SP500_MEMBERSHIP, R_CCMFUNDA_0428, R_CRSP_INFLATION, R_CRSP_MARKET, R_IBES_DETAIL, R_IBES_LINK
Evidence: E_COMP_FUNDA_CATALOG, E_COMP_FUNDA_COMMON_PROBE, E_PEER_FUNDA, E_TOURN_FUNDA, E_COMP_SEGMENT_PROBE, E_HOP_COMP, E_EXECUCOMP_ANNCOMP_PROBE, E_HOP_INDEX, E_DSP500LIST_PROBE, E_HOP_SEGMENT, E_PAY_CCMFUNDA, E_PAY_CPI, E_CRSP_MSI_PROBE, E_PAY_MARKET, E_IBES_DETAIL_PROBE, E_HOP_IBES, E_DATASHEET_SOURCES, E_DATASHEET_COMPUSTAT, E_DATASHEET_CRSP, E_DATASHEET_IBES

Preparation / proposed procedure:

1. Configure source librefs/member aliases to the verified local MSF, MSI market-return, S&P membership, segment, I/B/E/S detail and ANNCOMP components using their exact probed locations and native columns.
2. For COMP.FUNDA, credit gvkey/fyear/sale/sich as observed but leave the code-consumed SIC field unresolved; do not equate SICH with SIC. Keep tournament MYLIB1.FUNDA SIC/STATE and the imported author-prepared DTA as distinct contracts.
3. Keep DOW.NASDAQ, CIBESLNK and the custom CCM-FUNDA extract separate and unresolved where their exact product/field routes are not established; do not start SAS or read the external PROC CONTENTS catalog.

Validation to perform later:

- Validate specific date intervals and source aliases against the consumer code during an authorized run; bounded probes establish readable fields, not sample coverage.
- Verify the DOW and I/B/E/S link interval joins with their actual raw products and the code-specified master/using roles.
- Retain the unresolved SIC mapping, separate tournament STATE contract and author-prepared CEO/CXO panels; do not infer them from nearby raw tables.

### A_NETWORK_PREPARATION: Complete the author's annual edge and UCINET preparation using the documented inputs, and resolve its output mapping to the files consumed by SAS and Stata.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_NETWORK_XLSX, R_TOURN_NETWORK_PEERS_XLSX, R_CLUSTER_CSV, R_TOURN_NETWORK_MEASURES, R_EUCLID_C, R_EUCLID_R, R_PAYPEER_NETWORK, I_NETWORK_EXPORT_CONTRACT
Evidence: E_GUIDE_EDGE_OWN, E_GUIDE_EDGE_PEER, E_GUIDE_IMPORT, E_GUIDE_LOUVAIN, E_GUIDE_CENTRALITY, E_GUIDE_DENSITY, E_GUIDE_EUCLIDEAN, E_UCINET_MEMO, E_HOP_NETWORK_FIELDS, E_HOP_NETWORK_XLSX_JOIN, E_TOURN_NETWORK_PEER_JOIN, E_TOURN_NETWORK_MEASURES, E_TOURN_NETWORK_MEASURES_FIELDS, E_TOURN_NETWORK_MEASURE_GROUP, E_CLUSTER_INPUT, E_CLUSTER_OPERATIONS, E_WORK_ITEM

Preparation / proposed procedure:

1. Use the annual ISS focal/peer CIK edgelists, apply the author's stated blank/self/duplicate cleaning, and retain a directed edge list.
2. Run the documented UCINET steps separately for each required year; save Louvain assignment, in-degree, eigenvector, group density and separate row/column Euclidean outputs with year and node keys.
3. Map those outputs to the path-screened annual cluster CSV, the author workbook's 0616_1718 sheet, the Stata centrality file and the separate CIK peer-edge input only after the author confirms their field-level correspondence.

Validation to perform later:

- Check every annual file's year/node/edge keys, directedness, self/duplicate handling and required group/centrality fields.
- Verify row/column Euclidean distance labels and CIK-pair orientation against the supplied SAS joins.
- Do not assume the 2018 guide example proves a complete 2006–2018 export or the louvain_small/disclose fields.

### A_ACQUIRE_TNIC: Acquire the official TNIC-2 and TNIC-3 products and stage them for the supplied SAS import code.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_TNIC2, R_TNIC3
Evidence: E_TNIC_PAGE, E_TNIC2_README, E_TNIC3_README, E_HOP_TNIC2, E_HOP_TNIC3, E_PAY_TNIC3, E_PEER_TNIC2, E_TOURN_TNIC2

Preparation / proposed procedure:

1. Obtain TNIC-2 for the TNIC-2 branches and TNIC-3 for the TNIC-3 branches from the official Hoberg–Phillips library; retain product/release metadata.
2. Confirm from the delivered file layout how the code's year token is represented; preserve the product's gvkey1, gvkey2 and score fields, year association and six-character GVKEY formatting without guessing a conversion.
3. Keep the author's self-pair removal and pair direction logic unchanged.

Validation to perform later:

- Compare the delivered header, delimiter, key types and years with the supplied infile/input statements.
- Confirm the 2006–2018 rows are present and preserve pair orientation/duplicates as expected by each stage; do not use TNIC-2 as a silent substitute for TNIC-3 or vice versa.

### A_FF48_SERIES: Use the official French 48 Industry Portfolios route after confirming the exact value-weighted series, vintage and layout expected by the path-screened return import.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_FF48_RETURNS
Evidence: E_FF48_PAGE, E_FF48_DETAIL, E_HOP_FF48

Preparation / proposed procedure:

1. Acquire the 48-industry return product through the official library; retain a supported 2006–2018 monthly history.
2. Confirm that the selected product corresponds to the code's value-weighted expectation, date/header convention and required SAS transpose layout; do not guess or replace the weighted series.

Validation to perform later:

- Check date and industry columns, missing-value sentinels, requested history and original series vintage before importing.
- Validate the transpose result against the code's date/year and ret1 missing-code handling.

### A_VALIDATE_CRSP_MSF: Use the verified local CRSP.MSF raw component and confirm the exact code-window coverage during run preparation.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_CRSP_MSF
Evidence: E_CRSP_MSF_PROBE, E_HOP_MSF, E_PAY_CRSP

Preparation / proposed procedure:

1. Reuse the successful bounded probe as field/readability evidence; do not repeat a whole-data sweep.
2. Before an authorized run, confirm required monthly dates and identifiers cover 2006–2018 and any rolling 12-month/lead/lag windows visible in the producer code.

Validation to perform later:

- Confirm PERMNO/DATE/PRC/RET/SHROUT are present in the selected local MSF file and that dates cover required windows.
- Keep the probe's coverage_verified=false flag as a statement about that one-row sample, and record the later scoped coverage check separately.

### A_FF48_INCLUDE: Resolve the screened external include target before attempting the hopping sample construction.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_FF48_INCLUDE
Evidence: E_HOP_INCLUDE_PATH, E_HOP_INCLUDE, E_WORK_ITEM

Preparation / proposed procedure:

1. Obtain a reviewed view of the exact include target and source/version.
2. Confirm that %ind_ff48 accepts the call's dataset/SIC/output parameter names and writes the fields consumed later in hopping.sas; keep the supplied call unchanged until its contract is established.

Validation to perform later:

- Verify the macro source is present in a coherent run root and its documented output fields match the downstream code.
- Do not replace it with a different built-in classification or infer absence from the screened path token.

### A_HHI_CONTRACT: Resolve the hhi control's producer and definition before the competition analysis merge.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_HHI, I_HHI_PRODUCER
Evidence: E_ANALYSIS_HHI, E_ANALYSIS_HHI_KEYS

Preparation / proposed procedure:

1. Request the exact prepared hhi input, its underlying source/measure definition, its GVKEY/fiscal-year keys and its applicable sample years.
2. Keep hhi separate from the pay-for-luck idio_var/corr output unless source evidence establishes a shared producer.

Validation to perform later:

- Compare the file's HHI definition, keys, fields and years to the line-115 merge before use.
- Do not fabricate a concentration measure or infer a producer from the filename mask.

### A_REVIEWED_SOURCE_VIEW: Resolve the remaining source-level branch and input handoff contracts before attempting the full workflow.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_MASKED_SOURCE_VIEW
Evidence: E_ANALYSIS_CXO_SOURCE, E_ANALYSIS_NONCEO_FIELDS, E_ANALYSIS_NONCEO_PERIOD, E_ANALYSIS_CXO_KEYS, E_HOP_INCLUDE_PATH, E_HOP_INCLUDE, E_ANALYSIS_HHI_KEYS, E_WORK_ITEM

Preparation / proposed procedure:

1. Request a reviewed source view for Analysis_competition.do lines 390–392 and any exact input/include path whose producer or output role remains unresolved.
2. Keep any returned view inside the assigned generation and use the pinned approved viewer; do not inspect raw cache, log bodies or native binaries.

Validation to perform later:

- Record the reviewed line ranges and source hashes.
- Update only contracts directly supported by the reviewed source; preserve unknown producer, field and join semantics as unresolved.

### A_SAS_STATA_OUTPUT_STAGING: Persist the source-proven SAS WORK products for the Stata consumers using an explicit, loss-checked interchange path.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: I_SAS_STATA_HANDOFF
Evidence: E_HOP_OUTPUT, E_PAY_RPE_OUTPUT, E_TOURN_OUTPUT, E_PEER_SUMMARY_OUT, E_PEER_SUMMARY_FIELDS, E_ANALYSIS_HOP_FIELDS, E_ANALYSIS_RPE_PAY, E_ANALYSIS_RPE_CONTROLS, E_ANALYSIS_TOURN, E_TABLE1B_SUMMARY

Preparation / proposed procedure:

1. Keep hopping19, rpe3, tournament_final and summary as generated logical products; do not add independent raw-data requirements solely because the current programs omit a persistent export.
2. Export/convert each product to the exact Stata-consumer file location after confirming the masked path; preserve keys and all visible variables and keep the SAS and Stata working directories coherent.

Validation to perform later:

- Compare each exported product's keys/columns with its consumer: GVKEY pair/year for hopping; GVKEY/fyear and pay/RPE fields; tournament gap fields; and summary benchmark/interlock fields.
- Confirm the imported DTA is from the current SAS run and not a stale same-basename file.

### A_NATIVE_FIGURE_WORKFLOW: Clarify the creation/update steps and data connections for the bundled Tableau and Gephi figure projects.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_NATIVE_FIGURE_PROJECTS
Evidence: E_README_COMP_ANALYSIS, E_WORK_ITEM, E_SOFTWARE_GEPhI_TABLEAU

Preparation / proposed procedure:

1. Request the intended source files, data connections, saved project/export procedure and application versions for Figure 2.twbx and Figure 3A/3B.gephi.
2. Preserve the supplied native project files unchanged during the feasibility review.

Validation to perform later:

- After the project instructions and compatible applications are available, confirm the stated figure inputs and output exports without treating an opaque project file as proof of successful execution.

### A_STATA_ADDONS: Prepare the missing Stata add-ons required by the supplied analysis/cleaning code in a separately authorized run environment.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_WINSOR2, SW_LOGIT2, SW_FIRTHLOGIT, SW_RANGEJOIN, SW_CORSP, SW_NWSET, SW_NWCLUSTERING, SW_WORDCLOUD
Evidence: E_SW_WINSOR2, E_SW_LOGIT2, E_SW_FIRTHLOGIT, E_SW_RANGEJOIN, E_SW_CORSP, E_SW_NWSET, E_SW_NWCLUSTERING, E_PYTHON_PACKAGES, E_ANALYSIS_LOGIT2, E_ANALYSIS_FIRTH, E_TABLE1B_JOIN, E_CLUSTER_INPUT, E_CLUSTER_OPERATIONS

Preparation / proposed procedure:

1. Install/configure compatible Stata commands winsor2, logit2, firthlogit, rangejoin, corsp, nwset and nwclustering only after a separate execution authorization.
2. Install the missing wordcloud Python distribution for Figure 1 in the notebook's selected kernel; keep pandas/numpy/matplotlib versions and the exact word-cloud operation unchanged.

Validation to perform later:

- Use bounded `which`/distribution metadata to confirm each package name/version after setup.
- Validate required syntax/options only in a later authorized run; do not change estimators or use a trial regression as a setup check.

### A_MANUAL_SOFTWARE: Verify the documented SAS/UCINET/spreadsheet/Gephi/Tableau/notebook tools and their required versions in an appropriate user environment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, SW_SAS_PCFILES, SW_UCINET, SW_EXCEL, SW_GEPHI, SW_TABLEAU, SW_JUPYTER, SW_XLSX_ENGINE
Evidence: E_SOFTWARE_SAS_STATA, E_SOFTWARE_GEPhI_TABLEAU, E_GUI_PATHS, E_GUIDE_IMPORT, E_HOP_NETWORK_XLSX, E_TOURN_NETWORK_MEASURES, E_FIG1_IMPORT

Preparation / proposed procedure:

1. Confirm access to SAS 9.4 and its DBMS=EXCEL PC Files engine without using the current audit environment's SAS startup; runtime, license and autoexec remain unverified.
2. Confirm UCINET 6.66 and a compatible spreadsheet application for the documented GUI network operations and Excel interchange.
3. Confirm Gephi 0.10.1 and Tableau 2023.2 for the native figure projects; confirm Jupyter/kernel and the pandas Excel-reading engine for Figure 1.

Validation to perform later:

- Record exact application/version and required library/engine configuration using documentation or user-provided metadata.
- Do not infer GUI absence from a missing PATH entry and do not launch applications or source programs during this audit.

### A_RUN_PROCEDURE: When the listed data, software and path contracts are resolved, run the supplied author workflow in dependency order.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: E_README_HOPPING, E_README_COMP_SAMPLE, E_README_COMP_ANALYSIS, E_GUIDE_IMPORT, E_GUIDE_EUCLIDEAN, E_COMP_SAVE, E_HOP_OUTPUT, E_PAY_RPE_OUTPUT, E_TOURN_OUTPUT, E_PEER_SUMMARY_OUT, E_PEER_SUMMARY_FIELDS, E_FIG1_IMPORT

Preparation / proposed procedure:

1. Work from a separate, writable package copy with a coherent relative execution root and configured author-library paths; do not hard-code a Dropbox workspace path in executable code.
2. Acquire/prepare the raw and author-prepared inputs, then perform the annual Excel/UCINET network stages and Stata clustering step.
3. Run the SAS hopping, pay-for-luck, tournament and peer-summary producers after their inputs/includes; persist their verified WORK outputs to the Stata paths only after confirming the visible consumer schema.
4. Run ConstructSample_competition.do to produce sample.dta, then the Table 1A/1B, Analysis_hopping.do, Analysis_competition.do and Figure 1 notebook; finalize the Tableau/Gephi figures only after their data connections are documented.

Validation to perform later:

- Keep a fresh run log with each program's working directory, inputs, outputs and versions; do not use the packaged historical logs as execution proof.
- Confirm every output has the expected fields, keys, years and sample counts at the immediate consumer boundary.
- Record execution as unverified until the full author workflow completes successfully under a separately authorized run.


## Remaining issues and prerequisites

- I_FF48_INCLUDE [unresolved; full_pipeline]: hopping.sas calls %ind_ff48 after a screened external %include statement. The include target is not visible in the approved view or package inventory, so its source/version, directory and output contract are unresolved.
- I_NETWORK_EXPORT_CONTRACT [unresolved; full_pipeline]: The UCINET guide documents a 2018 example and Louvain/centrality/density/distance outputs, while hopping.sas consumes a path-screened annual cluster CSV with CIK/year/louvain/louvain_small/disclose and tournament.sas consumes a separate 0616_1718 workbook with group_id. The complete export/crosswalk for all years is not established.
- I_HHI_PRODUCER [unresolved; full_pipeline]: Analysis_competition.do separately consumes hhi on GVKEY/fiscal-year keys, but the supplied code does not establish its measure definition, producer or file identity.
- I_MASKED_SOURCE_VIEW [unresolved; full_pipeline]: Analysis_competition.do contains a separate non-CEO/CXO panel whose visible setup is followed by an unresolved downstream block at lines 390–392. Its exact input-to-output contract, required joins and interaction with the rest of the competition analysis remain unknown.
- I_SAS_STATA_HANDOFF [preparation; full_pipeline]: The SAS programs create WORK tables hopping19, rpe3, tournament_final and summary, while Stata consumers refer to author paths and DTA inputs. Visible producer/consumer fields support these as generated logical products; the persistent interchange format/path is not shown and should be configured without creating separate raw-data requirements.
- I_NATIVE_FIGURE_PROJECTS [unresolved; full_pipeline]: The package inventory includes Figure 2.twbx and Figure 3A/3B.gephi, while the README says remaining filenames indicate tables/figures. Their native payloads were not opened; data connections, generation steps and export versions are unverified.
- R_COMP_FUNDA [undetermined]: Compustat annual FUNDA component for peer summary. The peer-summary code reads COMP.FUNDA on GVKEY/FYEAR keys and consumes SIC/SALE. The local probe confirms readable raw columns gvkey/fyear/sale/sich; it does not establish a `sic` field or a SICH-to-SIC alias. The separate tournament author-prepared SIC/STATE panel remains distinct.
- R_TOURN_FUNDA_LOCAL [undetermined]: Tournament local FUNDA source for industry mapping. Tournament SAS separately reads MYLIB1.FUNDA and selects GVKEY/FYEAR/SIC/SALE/STATE for its industry mapping; this is a distinct raw source read from peer-summary COMP.FUNDA and the path-screened tournament DTA.
- R_EXEC_NONCEO [undetermined]: Execucomp CEO/CXO analysis panel. Analysis_competition uses a separate author-prepared CXO panel, filters missing TDC1, renames YEAR to FYEAR, excludes CEO observations, then retains 2006–2018.
- R_CEO_COMP [undetermined]: CEO compensation input for competition sample. Competition builder merges an author-prepared unique CEO/GVKEY/fiscal-year panel.
- R_FIN_CONTROLS [undetermined]: Financial-controls seed panel. ConstructSample_competition begins with this author-prepared file; its exact columns and historical construction must be supplied.
- R_PEERPAY_PANEL [undetermined]: ISS benchmarking peer-pay panel. Competition sample merges peer_pay and peer counts from an author-prepared GVKEY/fiscal-year file.
- R_SIZE_MATCH [undetermined]: Size-matched peer-pay controls. Competition analyses merge FF/SIC/HP/geographic median-pay and peer-count controls; the source path is screened but the visible field list is retained.
- R_DURATION [undetermined]: CEO pay duration input. Competition builder merges duration_ceo0 by GVKEY/fiscal year.
- R_CEO_TENURE [undetermined]: CEO tenure control. Competition builder merges ceo_tenure2 by GVKEY/fiscal year and documents its date/minimum-observation treatment.
- R_TOURN_GAP [undetermined]: Tournament pay-gap controls. Competition builder merges within-firm pay gap and FF48 CEO-count fields.
- R_DELTA [undetermined]: Delta/vega control input. Competition builder merges delta by executive-firm/fiscal year.
- R_VOLATILITY [undetermined]: Industry volatility control. Competition builder merges the visible vol_ind field from a screened input path.
- R_COMP_CONSULTANT [undetermined]: Compensation-consultant control. Competition builder requires consultant type/id/name by CIK/year; hopping code independently imports consultant data by CIK/year.
- R_GAI [undetermined]: Custodio General Ability Index. Competition builder merges GAI by normalized GVKEY/executive identifiers and fiscal year, then renames the measure ga_index.
- R_NEWPAYPEER [undetermined]: Author peer-compensation network panel. Table 1A/1B consume the prepared peer-year panel; Table 1B needs prior-year pair records for its turnover join. The identifier DTA files in the package are not this panel.
- R_PAYPEER_NETWORK [undetermined]: Annual CIK peer-edge input for clustering. Stata clustering script loads an annual directed CIK peer-edge input; the source path is screened and the script retains the current year after blank/self-pair cleaning.
- R_NETWORK_XLSX [undetermined]: Annual ISS peer-network workbook for hopping. Hopping SAS imports an Excel peer-pair workbook and joins on fyear, cik_own and cik_peer; the guide identifies annual focal/peer CIK edgelists.
- R_TOURN_NETWORK_PEERS_XLSX [undetermined]: Tournament peer-network workbook. Tournament SAS imports a path-screened Excel workbook on Sheet1 and joins its focal CIK/year rows to link and executive-compensation records. It may be shared with hopping's workbook, but masked paths do not confirm identity.
- R_CLUSTER_CSV [undetermined]: Louvain cluster export. Hopping SAS imports a path-screened CSV as table network and consumes CIK/year/louvain/louvain_small/disclose. The manual guide gives a 2018 Louvain assignment but not the complete annual export or all required columns.
- R_DOW_MEMBERSHIP [undetermined]: Dow Jones membership history. Hopping code joins Compustat firms using from/thru membership dates and a Dow Jones Industrials name.
- R_TNIC2 [undetermined]: Hoberg–Phillips TNIC-2 pairwise product data. Supplied SAS code reads a year token, GVKEY pair and score and removes self-pairs. The official readme documents the pair and score fields, but does not establish how the required year token is represented in the downloadable file.
- R_TNIC3 [undetermined]: Hoberg–Phillips TNIC-3 pairwise product data. Supplied SAS code reads a year token, GVKEY pair and score and removes self-pairs. The official readme documents the pair and score fields, but does not establish how the required year token is represented in the downloadable file.
- R_FF48_RETURNS [undetermined]: Fama–French 48-industry return series. Hopping SAS imports a path-screened CSV, transposes date-by-industry columns and applies return sentinel filters. The official library lists 48 Industry Portfolios with long historical returns; the exact value-weighted variant/vintage and headers are not fully confirmed.
- R_CCMFUNDA_0428 [undetermined]: Custom CCM-FUNDA extract for pay-for-luck. The script requires GVKEY/LPERMNO, datadate/fiscal-year, SIC/NAICS/sales and market-value inputs; it derives SIC2 and ROA and can derive market value from price and shares.
- R_CRSP_INFLATION [undetermined]: CRSP inflation series. Pay-for-luck SAS reads the CRSP inflation table and later uses caldt/cpiret to adjust returns.
- R_IBES_LINK [undetermined]: I/B/E/S ticker-to-GVKEY link intervals. Hopping SAS joins analyst detail to link rows on ticker and date interval.
- R_EUCLID_C [undetermined]: Annual column-mode Euclidean-distance workbooks. Hopping SAS imports each annual C workbook with an ID key and peer columns, transposes those values, then maps generated labels/value to own-peer distance rows.
- R_EUCLID_R [undetermined]: Annual row-mode Euclidean-distance workbooks. Hopping SAS imports each annual R workbook with an ID key and peer columns, transposes those values, then maps generated labels/value to own-peer distance rows.
- R_TOURN_COMP_RAW [undetermined]: Tournament author-prepared Compustat panel. Tournament SAS imports a separate path-screened author-prepared Compustat DTA; later code requires GVKEY/year/SIC/sales/state fields, while the imported file's exact identity and history are not visible.
- R_TOURN_NETWORK_MEASURES [undetermined]: Author network-measure workbook. Tournament SAS imports the 0616_1718 sheet and uses CIK/year/group_id together with link and ownership data.
- R_HHI [undetermined]: HHI control input. Competition analysis separately merges hhi on GVKEY/fiscal year from a screened path; no matching named producer or measure definition is established in the visible code.
- R_FUTURE_PERFORMANCE [undetermined]: Future operating/return-performance panel. Competition analysis merges lead ROA and return summaries, their dispersion and observation counts.
- R_BOARD_DATA [undetermined]: BoardEx governance panel. Competition analysis consumes board size, independence, busyness and chair/CEO variables on CUSIP6/year keys.
- R_EINDEX [undetermined]: E-index control panel. Competition analysis consumes eindex on CUSIP8/year keys.
- R_CADMAN_CONTROLS [undetermined]: Cadman et al. competition-control panel. Competition analysis consumes chosen-peer, HHI, distance, insider and noncompete indicators on CIK/year keys.
- R_FIG1_REASONS [undetermined]: Figure 1 reason workbook. Notebook reads Sheet1 and concatenates the Category column to create a word cloud.
- SW_WINSOR2 [preparation_required]: The Stata 18 which probe completed but did not find winsor2, which is invoked by the competition-sample and analysis code.
- SW_LOGIT2 [preparation_required]: The Stata 18 which probe completed but did not find logit2; the code invokes its two-way clustering call.
- SW_FIRTHLOGIT [preparation_required]: The Stata 18 which probe completed but did not find firthlogit, required by the OA.3 branch.
- SW_RANGEJOIN [preparation_required]: The Stata 18 which probe completed but did not find rangejoin, required for Table 1B's one-year join.
- SW_CORSP [preparation_required]: The Stata 18 which probe completed but did not find corsp, invoked by Analysis_competition.do.
- SW_NWSET [preparation_required]: The Stata 18 which probe completed but did not find nwset, required to declare the directed edgelist.
- SW_NWCLUSTERING [preparation_required]: The Stata 18 which probe completed but did not find nwclustering, required by clustering coefficient.do.
- SW_WORDCLOUD [preparation_required]: Python distribution metadata did not find wordcloud, which the Figure 1 notebook imports.
- SW_JUPYTER [unverified]: Figure 1 is supplied as an executable notebook; no notebook server/kernel was probed. Python availability alone does not verify notebook execution.
- SW_XLSX_ENGINE [unverified]: The notebook calls pandas.read_excel; the required Excel-reading engine/version was not checked.
- SW_SAS [unverified]: The datasheet specifies SAS 9.4. This audit did not invoke SAS in any form, so runtime version, license, libraries and startup state remain unverified.
- SW_SAS_PCFILES [unverified]: SAS code imports XLSX with DBMS=EXCEL; the PC Files access engine and its configuration were not verified.
- SW_UCINET [unverified]: The datasheet specifies UCINET 6.66 and the guide requires manual Excel import, Louvain, centrality, density and distance operations. No application was launched; not being on PATH does not establish absence.
- SW_EXCEL [unverified]: The manual UCINET guide begins with Excel edgelists and the SAS programs import XLSX workbooks. No spreadsheet application/engine was launched or compatibility-tested.
- SW_GEPHI [unverified]: The datasheet specifies Gephi 0.10.1; path metadata did not find a gephi command, which does not verify GUI absence or version.
- SW_TABLEAU [unverified]: The datasheet specifies Tableau 2023.2; path metadata did not find a tableau command, which does not verify GUI absence or version.

## Review notes

- Assessment is limited to jar-b0bbd79e00dc generation_002. The output header/provenance is copied from the supplied template. No generation_001 artifacts, source views, draft, logs or helper outputs were read or reused.
- The approved source-view register covers the substantive code and workflow documents. Historical log/SMCL bodies, native Tableau/Gephi project payloads and analytical DTA contents remain opaque; no prior log or bundled project is treated as execution proof.
- The package's two readable DTA artifacts are firm-identifier lists according to the README and their one-row metadata probes; they are not compatible prepared-analysis panels. The other author-prepared datasets are not present in the inventory.
- The approved reader masks specific path tokens and selected blocks. Preserve those as review limits only; do not interpret masks as missing code, inactive SAS macro prefixes, authentication/license barriers, or proof of proprietary data. A reviewed view is requested only for the listed unresolved semantics.
- COMP.FUNDA is only a frozen-catalog candidate; its field/readability probe is unverified and cannot support a positive route. CRSP.MSF is a verified readable local component for the five required fields, with temporal coverage still unverified. TNIC-2 and TNIC-3 have verified official public product routes; the French 48-industry series is a public candidate with value-weight/vintage/header compatibility still unverified.
- Generated outputs are assessed as code-proven logical products: sample.dta, hopping19, WORK.summary, rpe3, tournament_final and the annual Euclidean intermediates. SAS-to-Stata persistence is path/format staging; it is not an independent raw-data requirement.
- No author code, statistical model, data payload, notebook, SAS session, GUI, install, download, patch or outgoing message was run. execution_verified remains false.
