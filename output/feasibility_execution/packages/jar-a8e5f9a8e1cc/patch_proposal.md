# Patch proposal: jar-a8e5f9a8e1cc

Do Majority-of-Minority Shareholder Voting Rights Reduce Expropriation? Evidence from Related Party Transactions

DOI: 10.1111/1475-679X.12357

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Author-documented four-program SAS workflow: convert raw related-party transaction data to firm-year measures; merge ISS voting and Prowess data for the Section 4 voting outcome and Section 5 real-effect samples; create revision variables; and independently construct the Section 5.4 daily return panel. This is a substantive partial-code release, not a complete runnable project: required input files, relative path setup, runtime initialization, and specific field/producer contracts remain unresolved.

Entry points: `raw rpt to firm-year rpt.sas`, `merge data and construct sample.sas`, `additional variables created in the revision process.sas`, `construct daily return panel.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 4/12357 - Do-Majority-of-Minority-Shareholder-Voting-Rights-Reduce-Expropriation-Evidence-from-Related-Party-Transaction/n-li-datasheet-code-and-identifiers.zip",
      "sha256": "3855f301841445e9d76b027f911e21e0d9a23161ae89252ab0e8e9064c76868b"
    },
    {
      "path": "JAR-Volume 59/Issue 4/12357 - Do-Majority-of-Minority-Shareholder-Voting-Rights-Reduce-Expropriation-Evidence-from-Related-Party-Transaction/li-online-appendix.pdf",
      "sha256": "6b63e19ffec2cce5c73064457563f4a881ed21a6e4dc6e1ac9eef22d06c3c57d"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "eabbdbb39b82b403c2079b9d06b7c37c49c95a56ba6bcefa05ce448d82c4f35e"
}
```

## Proposed actions

### ACT_ISS_VOTING_INPUTS: Establish a permitted route to the author-compatible ISS Global Voting Analytics voting workbook and its separate category mapping workbook. A readable local RISK.GLOBALVOTERESULTS candidate has matching vote columns but has MGMTrec instead of the supplied program's ISSrec; product equivalence and 2014–2015 coverage remain unverified.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_ISS_VOTES, REQ_ISS_CATEGORY
Evidence: E_DS_SOURCE, E_VOTE_IMPORT, E_VOTECATEGORY_IMPORT, E_PACKAGE_INVENTORY, E_CATALOG_GLOBALVOTERESULTS, E_PROBE_GLOBALVOTERESULTS

Preparation / proposed procedure:

1. Confirm whether the historical ISS Global Voting Analytics export and the author category workbook can be lawfully accessed for this study; record the exact product, file names, sheet names, field mapping, and covered meeting population.
2. For the local candidate, verify whether MGMTrec corresponds to the author program's ISSrec and whether it represents the intended recommendation field; do not rename or substitute it without evidence.
3. Stage the two matching workbooks under the configured relative project data root without changing their analysis fields or mapping rows.
4. Keep the vote workbook and category mapping as separate mandatory inputs because the source joins them on AgendaGeneralDesc.

Validation to perform later:

- Read workbook sheet names and headers with a bounded metadata reader; confirm the exact fields used by the source, including ISSrec, before authorizing a run. For the local candidate, inspect full approved coverage and recommendation-field semantics before treating it as compatible.
- Check that the staged vote file covers the meeting-date population used for calendar years 2014 and 2015 and that AgendaGeneralDesc joins to the separate category mapping.

### ACT_PROWESS_CORE_INPUTS: Establish the author-compatible Prowess exports for company identity, standalone financial statements, and quarterly equity structure. The current catalog contains no Prowess product match, and the package has none of these source files; no Compustat proxy is established.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_PROWESS_ID, REQ_PROWESS_SFIN, REQ_PROWESS_EQUITY
Evidence: E_DS_SOURCE, E_DS_PROGRAMS, E_PROWESS_ID_IMPORT, E_PROWESS_SFIN_IMPORT, E_PROWESS_EQUITY_IMPORT, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Confirm and stage Prowess id0403.txt, sfin0403.txt, and equity0403.txt through the author-documented vendor route or an already authorized compatible export.
2. Preserve the separate data products and their native columns; do not replace Prowess company identifiers or financial/equity measures with a superficially similar vendor table.
3. Configure relative SAS paths from the selected project working directory and retain the authors' March fiscal-year logic.

Validation to perform later:

- Check the actual source headers and entity identifiers used in the code, including co_code versus sa_finance1_cocode and shp_cocode.
- Confirm annual financial history needed for the retained years and the one-fiscal-year lag, and confirm quarterly equity dates permit selection of the last available quarter in each relevant fiscal year.

### ACT_REVISION_RAW_INPUTS: Obtain the separate Prowess director, insider-trading, and stock-share exports required by the JAR R1 additional-variable stage; the supplied code maps each into fiscal-year aggregates and merges them by Prowess company code.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_PW_DIRECTOR, REQ_PW_INSIDER, REQ_PW_STOCK
Evidence: E_DS_SOURCE, E_DIRECTOR_IMPORT, E_INSIDER_IMPORT, E_STOCK_INPUT, E_STOCK_FIELDS, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Confirm the author-compatible 2019 Prowess exports and their permitted access route, then stage director0919.txt, insider0919.txt, and stock0729.sas7bdat under the configured relative data roots.
2. Preserve raw identifiers and transaction-date/stock-date columns; retain the supplied March fiscal-year conversion in the author programs.
3. Keep the three datasets distinct because director pay, insider transaction volume, and share-count denominators are separate inputs to R1_ADD_0919.

Validation to perform later:

- Check the exact fields used in source, the company-code crosswalk, and fiscal-year alignment across director, insider, stock, and standalone-financial inputs.
- Confirm the stock panel provides the date and equity_shares_on_stkdate population needed to compute mean/median shares for the target fiscal years.

### ACT_DAILY_PRICE_INPUT: Obtain the author-compatible daily Prowess price/return source for the event panel, including full date-window market-cap observations used to calculate date-specific value-weighted returns.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_PW_DAILY_PRICE
Evidence: E_DS_SOURCE, E_PRICE_INPUT, E_PRICE_HISTORY, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Confirm and stage the exact price0411.txt product in the configured relative data root without changing the author return and market-cap columns.
2. Retain the code's 2012-10-01 through 2014-06-30 inclusive filter and use the full eligible cross-section on each date when constructing the market portfolio.

Validation to perform later:

- Check that all dates and relevant Prowess company codes are present across the period, not only firms in the study sample, because bse_market_cap totals are computed over all loaded rows.
- Confirm bse_returns, nse_returns, and bse_market_cap have the expected units and compatible missingness before an authorized run.

### ACT_STAGE_PREPARED_SAS_INPUTS: Stage the distinct author-prepared SAS inputs used by the main and companion daily-return branches, including project-capex, blockholder, and market-cap/book-equity tables that the main program actively reads and merges. None is included, and the supplied programs do not produce these tables.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_RPT0807, REQ_CONTROL0814, REQ_BOARD0619, REQ_ID_0719, REQ_ID_0719_RPT, REQ_PROJECT0511, REQ_BLOCK0524, REQ_MKTCAP0307
Evidence: E_PREPARED_RPT0807, E_PREPARED_RPT0807_PARTITION, E_PREPARED_CONTROL, E_PREPARED_CONTROL_DAILY, E_PREPARED_BOARD, E_PREPARED_ID0719, E_PREPARED_ID0719_DAILY, E_PACKAGE_INVENTORY, E_PROJECT_READ, E_PROJECT_FIELDS, E_BLOCK_READ, E_MKTCAP_READ

Preparation / proposed procedure:

1. Confirm the author-compatible files for rpt0807.sas7bdat, control0814.sas7bdat, board0619.sas7bdat, project0511.sas7bdat, block0524.sas7bdat, mktcap0307.sas7bdat, and both path/id_0719.sas7bdat and path2/id_0719.sas7bdat reads; retain the roots and schemas separately unless the author confirms identical files may be staged from one source.
2. Place each required member under a configured relative data root visible to the SAS batch working directory; preserve the distinct key names, especially year versus fyear, and do not treat the project table as optional because a source comment says its fields are not used in the published analysis.
3. Retain all supplied branches, including the daily panel's independent reads of rpt0807, board0619, control0814, and id_0719.

Validation to perform later:

- Read one bounded row and headers for each staged SAS file, then compare exact join keys, variable names, and required years with the source contracts.
- Check path/path2 assignments against every producing and consuming call before any separately authorized run.

### ACT_IDH0403_CLARIFY: Clarify the role, required fields, and period for the active idh0403.txt imports. Until the author confirms the source read is intentionally unnecessary, the supplied workflow still requires the file to be present.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_PROWESS_IDH
Evidence: E_PROWESS_IDH_IMPORT, E_RAW_IDH_IMPORT, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Obtain the exact historical identity export used by the author or a written schema/role specification tied to the supplied code.
2. Do not delete either active import or treat idh as optional solely because no later consumer is visible in the supplied source.

Validation to perform later:

- Compare the supplied field schema and intended consumer to both import calls and obtain author confirmation before proposing any removal or replacement.

### ACT_RPT_RAW_INPUTS: Obtain the three distinct Prowess inputs required by the raw-RPT conversion: consolidated prior-year financials, standalone prior-year financials, and firm-year-party raw transactions.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_PW_CNW_R1, REQ_PW_SNW_R1, REQ_RPT_RAW
Evidence: E_DS_SOURCE, E_CNW_R1_IMPORT, E_SNW_R1_IMPORT, E_RPT_RAW_IMPORT, E_RPT_RAW_FIELD_ARRAY, E_RPT_RAW_KEYS, E_RPT_PARTY_FIELDS, E_RPT_FIN_LAG, E_RPT_RELATED_PARTY_LAG, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Confirm and stage cnw_r1.txt, snw_r1.txt, and rpt_raw_r1.csv as separate author-compatible Prowess exports under the configured relative path root.
2. Preserve the raw party-level RPT record unit and all transaction-category columns; do not substitute the firm-year output for its own raw input or infer a different table schema.
3. Retain the supplied joins from RPT fiscal year t to firm and related-party financial records at fiscal year t−1; actual source history must cover the records used by the chosen analysis period.

Validation to perform later:

- Check the actual imported headers, numeric/text storage, Prowess company identifiers, party-name matching fields, and date coverage before the raw-RPT program is authorized to run.
- Confirm each RPT component field, the exact `rpt_party_type` codes, and related_party_type_mst category values against the author data dictionary or export documentation.

### ACT_CONFIGURE_SAS_CHAIN: Configure the supported producer sequence and library staging so WORK intermediates and named SAS members reach the supplied consumers.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISSUE_HANDOFF
Evidence: E_RPT_LIBREF, E_RPT_WORK_PRODUCERS, E_RPT_SNW1_PRODUCER, E_RPT_OUTPUT, E_REVISION_LIBREFS, E_REVISION_R1_ADD_PRODUCER, E_MAIN_LIBREF, E_MAIN_RPTFY1_CONSUMER, E_EXTENSION_READS

Preparation / proposed procedure:

1. Choose a SAS batch working directory and configure relative path, path1, and path2 roots with host-visible inputs and writable output locations; keep path assignments consistent across the affected scripts.
2. Run raw rpt to firm-year rpt.sas first, then additional variables created in the revision process.sas, then merge data and construct sample.sas in the same SAS session so WORK.rptfylist, WORK.rptfy1, and WORK.snw1 remain available to their consumers.
3. The raw-RPT program writes tn1.rptfy0901 under path while the revision program writes tn1.r1_add_0919 under path2. Stage those exact members under the main consumer's configured tn1 root, or configure a consistent root and member-copy step; preserve their authored names and schemas.
4. Run construct daily return panel.sas as its companion branch after the firm-year RPT file is staged; it does not consume the main branch's WORK tables. Keep its independent prepared inputs and full date-window market denominators.
5. Keep the unresolved RPTFY1, item_disc/rabove/rbelow, and sfin3_5 field/producer questions in their linked issues; this orchestration action does not invent or alter scientific variables.

Validation to perform later:

- Before any separately authorized execution, statically confirm every read/write path and libref against the chosen relative roots and verify the required persistent SAS member names are staged.
- During a future authorized run, confirm WORK.rptfylist, WORK.rptfy1, and WORK.snw1 exist before the main consumers, and compare the produced RPT headers with the unresolved field contracts before interpreting outputs.

### ACT_CAPDIV_PATH_STAGE: Stage the exact capdiv Prowess export under the configured relative data root and replace the machine-specific import path in a working copy.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: REQ_CAPDIV0511, ISSUE_CAPDIV_PATH
Evidence: E_CAPDIV_IMPORT, E_CAPDIV_FIELDS, E_MAIN_LIBREF, E_PACKAGE_INVENTORY

**Proposed edit:** `merge data and construct sample.sas:346–350`
Source SHA-256: `6358162088e5380f76a56c8d7a422535875c06edeacfe53641df63eb458aa9df`

The source uses a host-specific D: drive path here while the other main imports use the configured relative path root. A relative path preserves the named Prowess input and its data transformation.

Current text:
```
proc import datafile='[redacted-path-753966e8bc76]'
     out=capex
     dbms=dlm
     replace;
     delimiter='|';
```

Proposed replacement:
```
proc import datafile='path\capdiv0511.txt'
     out=capex
     dbms=dlm
     replace;
     delimiter='|';
```

Preparation / proposed procedure:

1. Obtain the author-compatible capdiv0511.txt export through the same Prowess route as the other required Prowess inputs and stage it as path/capdiv0511.txt relative to the selected SAS working directory.
2. Apply the path-only replacement to a working copy and configure path consistently for all reads and writes; do not edit the original package file.

Validation to perform later:

- Check the staged header for sa_finance1_cocode, sa_finance1_year, sa_cf_purchase_fixed_ast, sa_cf_redemp_buyback_cap, sa_cf_div_paid, and sa_depreciation, and confirm the source period supports the main fiscal years and lagged financial measures.

### ACT_RPTFY1_SCHEMA_CLARIFY: Resolve the RPTFY1-to-main-panel field contract before relying on the constructed firm-year RPT variables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_RPTFY1_SCHEMA
Evidence: E_RPT_WORK_PRODUCERS, E_MAIN_RPTFY1_CONSUMER, E_MAIN_RPT_SUM_ARRAY, E_RAW_RPT_FIELDS, E_RPT_OUTPUT

Preparation / proposed procedure:

1. Confirm whether main Part 1 is intended to join the supplied WORK.rptfy1 table or another author-produced RPT table, and provide the intended field schema and record unit for the 36 names in the following DATA step.
2. Confirm whether the zero-fill of fields absent from the rptfy1 KEEP list is intended; if a different producer or table is intended, identify it explicitly rather than substituting rptfy2 or creating sums from undocumented fields.
3. Preserve the supplied treatment, sample, fiscal-year, and RPT definitions until the author specifies a compatible field contract.

Validation to perform later:

- Compare the exact generated WORK.rptfy1 and named firm-year output headers with the main consumer's 36-variable list before any separately authorized run.

### ACT_INPUTS_INVENTORY_RECONCILE: Reconcile the complete mandatory input inventory against author-compatible files before any run; the package includes code, documentation, and an identifier list but no analysis datasets.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: ISSUE_INPUTS
Evidence: E_DS_SOURCE, E_DS_PROGRAMS, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Use the linked per-input actions to obtain/stage every selected requirement, keeping separate products and same-basename files in distinct roots unless their identity is verified.
2. For each staged input, record actual field names, identifiers, record unit, population, dates and history, and any transformations or join keys used by the supplied code.
3. Do not count identifier_prowess_cocode.csv as analysis data or treat a catalog candidate or one-row read as proof of full coverage.

Validation to perform later:

- Compare each staged file with its requirement route and source-read evidence; confirm required fiscal-year lags and full-panel date/population operations before a separately authorized execution.

### ACT_CFIN0807_INPUT: Obtain the separate Prowess consolidated-financial export imported by main Part 2; do not substitute the distinct cnw_r1.txt raw-RPT input.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_CFIN0807
Evidence: E_CFIN0807_IMPORT, E_PACKAGE_INVENTORY, E_CATALOG_PROWESS_SEARCH

Preparation / proposed procedure:

1. Obtain the author-compatible cfin0807.txt export and stage it under the configured path root with the exact author basename or a consistent working-copy path change.
2. Keep this main-analysis consolidated statement file distinct from cnw_r1.txt, which feeds the raw-RPT conversion.

Validation to perform later:

- Check ca_finance1_cocode, ca_finance1_year, ca_total_assets, and ca_total_income and verify coverage for the retained firm-year base; the source joins consolidated and standalone data on same-year fiscal-year keys.

### ACT_SNW0427_INPUT: Retain the actively imported snw0427.txt input and resolve its intended role; it is distinct from raw-RPT snw_r1.txt and from the WORK.snw1 produced by the raw-RPT stage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_PW_SNW0427
Evidence: E_SNW0427_IMPORT, E_SNW_WORK_HANDOFF, E_SNW_R1_IMPORT, E_RPT_SNW1_PRODUCER, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Stage the author-specified snw0427.txt file so the active main-program import remains reproducible.
2. Confirm the intended role, required headers, and period for WORK.snw; do not assume it creates or replaces WORK.snw1, which has a separate raw-RPT producer.

Validation to perform later:

- Trace any author-specified downstream consumer of WORK.snw and verify its actual imported headers and period; until then retain the read as mandatory and its contract as unresolved.

### ACT_RPT_EXTENSION_CLARIFY: Resolve the producer and field contract for item_disc, rabove, and rbelow before the main Part 2 join is relied upon.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_RPT_EXTENSION
Evidence: E_EXTENSION_READS, E_RAW_RPT_FIELDS, E_RPT_OUTPUT

Preparation / proposed procedure:

1. Identify the author-provided producer or prepared file that supplies item_disc, rabove, and rbelow, including its configured root, record unit, join keys, and definitions.
2. Compare the actual named member fields with the supplied raw-RPT rptfy0901 output; do not invent these variables or silently replace the output table.

Validation to perform later:

- Verify the identified producer's member name, keys, and all three columns against the main Part 2 join before a separately authorized run.

### ACT_SFIN3_5_CLARIFY: Identify the missing sfin3_5 producer or correct upstream handoff without replacing the main program's sample definitions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_SFIN3_5
Evidence: E_SFIN3_PRODUCER, E_SFIN3_5, E_DS_PROGRAMS

Preparation / proposed procedure:

1. Confirm how sfin3_5 is produced from the supplied sfin3 block, including any omitted author code and the intended retained fields/order.
2. If an author-specified producer exists, stage or restore that exact stage in the supplied workflow; do not treat sfin3 and sfin3_5 as interchangeable without evidence.

Validation to perform later:

- Check that the confirmed producer creates sfin3_5 with the fields consumed by the next DATA step and that sample/treatment rules remain authored before any separate execution authorization.

### ACT_SAS_RUNTIME_SETUP: Resolve the recorded SAS startup failure and verify runtime/format support before any future author-program execution.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SOFTWARE_SAS
Evidence: E_ENV_SAS_RUNTIME, E_PACKAGE_INVENTORY, E_DS_PROGRAMS, E_VOTE_IMPORT, E_PRICE_INPUT, E_RPT_RAW_IMPORT

Preparation / proposed procedure:

1. Resolve the TKELS launch initialization failure for the documented sas_u8 command in the approved batch environment and confirm a SAS version on successful startup; the current probe does not establish absence of a license.
2. Confirm support in the available runtime for the actual active procedures (IMPORT, EXPORT, SORT, SQL, MEANS, RANK, TRANSPOSE, UNIVARIATE, CORR) and the used XLSX, DLM, and CSV import formats.
3. Verify how the two PROC EXPORT calls write their .dta targets; their source statements do not specify DBMS. Keep component/version compatibility unverified until confirmed.

Validation to perform later:

- A future authorized software-only check should confirm empty-session startup, version, required import/export engines and procedure availability without loading study data or executing the supplied programs.

### ACT_ID0719_BSE_DATE_CLARIFY: Confirm the intended BSE delisting-date field mapping in the supplied listing rule before relying on its sample classification.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_ID0719_BSE_DATE
Evidence: E_PREPARED_ID0719

Preparation / proposed procedure:

1. Ask the author to confirm whether bse_end is intentionally derived from nse_delist_date after the bse_delist_date condition, or whether the input field should be different.
2. Do not change the date assignment or listing sample rule until that field mapping is confirmed.

Validation to perform later:

- After clarification, compare the resulting date fields and the as-of-2014 listing exclusion against the author-defined rule before any separately authorized execution.


## Remaining issues and prerequisites

- ISSUE_INPUTS [unresolved; full_pipeline]: The supplied programs read numerous ISS/Prowess text, CSV, XLSX, and SAS datasets that are absent from this package. The included co_code identifier list is not the analysis data. Exact per-file field, population, fiscal-year history, and compatible acquisition or prepared-input routes remain unresolved.
- ISSUE_HANDOFF [preparation; full_pipeline]: The source establishes a workable producer order, while the package lacks a driver and configured roots: raw RPT creates WORK.rptfylist, WORK.rptfy1, WORK.snw1, and tn1.rptfy0901; the revision program creates tn1.r1_add_0919 under its separate path2 root; main Part 1 consumes WORK.rptfy1 and Part 2 reads both persistent tn1 members without defining tn1 in that script. Configure the project-relative roots, run the raw-RPT and revision programs before the main program in one SAS session, retain the WORK products, and stage the two persistent members under the main consumer's configured tn1 root. The daily panel is a companion branch that can run after the firm-year RPT output is staged. This is supported preparation; unresolved field contracts are recorded separately.
- ISSUE_SFIN3_5 [unresolved; full_pipeline]: The main program builds a DATA step named sfin3, then later reads sfin3_5, but the supplied program contains no producer for sfin3_5. Resolve the intended producer and the proper order/schema before treating the main analysis output as constructible.
- ISSUE_RPT_EXTENSION [unresolved; full_pipeline]: Main Part 2 consumes item_disc, rabove, and rbelow from tn1.rptfy0901. The supplied raw-RPT producer's firm-year output contains neither these fields nor a source-generation block for them; the inputs may be a separate revision extension, but no compatible producer/file/schema is supplied. Confirm the intended producer, path, keys, and field definitions before using this merge.
- ISSUE_CAPDIV_PATH [preparation; full_pipeline]: Main Part 2 imports capdiv0511.txt from a machine-specific D: drive path, unlike the program's configured relative path root. Stage the exact compatible input under the chosen relative root and change only this path in a working copy.
- ISSUE_RPTFY1_SCHEMA [unresolved; full_pipeline]: Main Part 1 joins WORK.rptfy1, whose supplied raw-RPT producer has an explicit KEEP list of unsummed component fields. The next main DATA step names 36 fields including rtotal_sum, rtotal2_sum, and category *_sum variables and fills missing array members with zero. The separate raw-RPT firm-year output is built from rptfy2. The supplied sources do not establish whether the main join is intended to receive these sums or whether zero filling is intentional; do not substitute rptfy2 or manufacture sums without author specification.
- ISSUE_ID0719_BSE_DATE [unresolved; full_pipeline]: The raw-RPT listing block checks bse_delist_date but derives bse_end by inputting nse_delist_date. Because the supplied listing exclusion later uses nse_end or bse_end to select firms, the intended date-to-variable mapping is unresolved; confirm it before interpreting the listing classification. No repair is inferred.
- REQ_ISS_VOTES [undetermined]: ISS Global Voting Analytics voting-outcome workbook used for 2014–2015 meetings in Section 4, with the meeting, company/security identifiers, ballot description, vote counts, outstanding shares, ForPct, and the ISS recommendation field read by the supplied program.
- REQ_ISS_CATEGORY [undetermined]: The separate author-specified Sheet2 voting-category workbook joined to voting outcomes by AgendaGeneralDesc; the program imports its catgory and rpt_id columns.
- REQ_PROWESS_ID [undetermined]: Prowess company-identification export used to map ISS tickers to co_code, select the firm sample, and carry ownership/listing/industry identifiers through the firm-year branch.
- REQ_PROWESS_SFIN [undetermined]: Prowess standalone financial statements imported in the RPT, voting, real-effect, and revision-variable programs; downstream joins use sa_finance1_cocode and fiscal year derived as int(sa_finance1_year/10000), with financial controls and lagged assets/revenue.
- REQ_PROWESS_EQUITY [undetermined]: Prowess quarterly equity-ownership export used to choose the last available quarter within each fiscal year and construct promoter, family, institutional, and foreign ownership controls.
- REQ_PW_DIRECTOR [undetermined]: Prowess director-compensation export used to aggregate total director, executive, and promoter compensation before merging the resulting revision variables by company and fiscal year.
- REQ_PW_INSIDER [undetermined]: Prowess insider-trading export used to aggregate buy, sell, and total transaction share volumes by company and March fiscal year.
- REQ_PW_STOCK [undetermined]: Prowess daily stock file used to calculate average and median shares outstanding by company and March fiscal year, which scale insider-trading volume in the revision branch.
- REQ_PW_DAILY_PRICE [undetermined]: Prowess daily price/return export used to build the Section 5.4 event-return panel and date-specific equal- and value-weighted market return denominators.
- REQ_RPT0807 [undetermined]: Prepared path2/rpt0807 SAS table consumed by the daily-return panel to add the 2012 firm-list controls and RPT partition variables; no supplied program produces this table.
- REQ_CONTROL0814 [undetermined]: Prepared control0814 SAS table used in the voting-outcome sample, real-effect panel, and daily-return control averages.
- REQ_BOARD0619 [undetermined]: Prepared board/governance SAS table used to derive board and audit-committee independence variables in the real-effect and daily-return branches.
- REQ_ID_0719 [undetermined]: Prepared Prowess id_0719 SAS table under path2 used by the daily panel to carry owner and industry-code fields into the event-return panel.
- REQ_PROWESS_IDH [undetermined]: Prowess historical-identity file idh0403.txt, actively imported by both the RPT and main Part 2 programs. The supplied code does not reference the resulting WORK.idh table afterward, so the file's intended role and field contract are unresolved; it remains a required read for the code as supplied.
- REQ_PW_CNW_R1 [undetermined]: Prowess consolidated-financial export cnw_r1.txt used by the raw RPT program to select the larger of consolidated and standalone prior-year revenue/net worth for firm and related-party thresholds.
- REQ_PW_SNW_R1 [undetermined]: Prowess standalone net-worth/revenue export snw_r1.txt used with consolidated financials to construct prior-year firm and related-party denominators in the raw RPT conversion.
- REQ_RPT_RAW [undetermined]: Prowess raw related-party transactions at the firm-year-party level, which the supplied raw-RPT program cleans, aggregates, classifies using prior-year revenue, and saves as RPTFY0901.
- REQ_CFIN0807 [undetermined]: Separate Prowess consolidated-financial export imported by main Part 2 and joined to standalone statements by company and same fiscal year to supply consolidated assets and income.
- REQ_PW_SNW0427 [undetermined]: Prowess standalone accounting export snw0427.txt is actively imported in main Part 2 as WORK.snw. The supplied source later sorts WORK.snw1, which the raw-RPT program creates separately; no direct consumer of WORK.snw is visible, so its intended role remains unresolved and the active read remains in scope.
- REQ_CAPDIV0511 [undetermined]: Prowess capital-expenditure, dividends, repurchases, and depreciation export used to form capex, payout, depreciation, and capex-ex-depreciation controls in main Part 2.
- REQ_PROJECT0511 [undetermined]: Prepared project-capex SAS table actively merged into the main firm-year panel, with eight project fields carried forward even though the code comments that the published analysis does not use them.
- REQ_BLOCK0524 [undetermined]: Prepared blockholder-ownership SAS table joined to the main firm-year base for bh_d5, bh_d1, and bmax partition variables.
- REQ_MKTCAP0307 [undetermined]: Prepared market-cap/book-equity SAS table used to add mktcap and bv to the main firm-year panel. The source joins by co_code and its field year, not a field named fyear.
- REQ_ID_0719_RPT [undetermined]: Prepared Prowess id_0719 SAS table under path used by the raw-RPT conversion to derive listing status from first-traded and delisting dates plus listing symbols/codes.
- SOFTWARE_SAS [unverified]: The four supplied entry programs require SAS. They actively use PROC IMPORT/EXPORT, SORT, SQL, MEANS, RANK, TRANSPOSE, UNIVARIATE, and CORR; imports use XLSX, DLM, and CSV. The saved environment probe records sas_u8 but startup fails at TKELS initialization with return code 1, so version/runtime usability and exact .dta export support are unverified. No additional licensed module is inferred from these procedures.

## Review notes

- The assessed full_pipeline includes all four supplied SAS programs. No analysis_only scope is supported because the package contains no compatible author-prepared analysis dataset or complete analysis-only route; the packaged identifier CSV is not analysis data.
- All 35 frozen read dependencies are reviewed: 31 point to 24 mandatory data requirements, three are generated outputs with supplied producers, and one targets the unresolved item_disc/rabove/rbelow field contract. No read was labeled optional. Every selected data requirement, software dependency, and issue has a linked action.
- The supported order is raw RPT conversion, revision-variable preparation, then the main sample program in one SAS session for the WORK handoffs; configure relative roots and stage tn1.rptfy0901 and tn1.r1_add_0919 for the main consumer. The daily-return panel is a companion branch after its firm-year RPT output is staged. The RPTFY1 36-field contract, item_disc/rabove/rbelow, sfin3_5, and id_0719 BSE-date mapping remain specifically unresolved.
- A bounded read confirms the local RISK.GLOBALVOTERESULTS candidate is readable and has voting fields, but it exposes MGMTrec (Management Recommendation), not the source's ISSrec; product equivalence and 2014–2015 coverage are unverified, so it is not substituted.
- The available SAS environment probe records a TKELS startup failure with return code 1. SAS runtime/version and import/export component availability are unverified; this is not treated as a license barrier.
- No author program, estimator, or analysis dataset was executed. The work used static source review, frozen catalog lookup results, and one bounded row_limit=1 read; all command, helper, and probe outcomes are preserved under the assigned generation_001/probes directory.
