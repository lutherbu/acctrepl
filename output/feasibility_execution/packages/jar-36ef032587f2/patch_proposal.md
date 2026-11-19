# Patch proposal: jar-36ef032587f2

Sexism, Culture, and Firm Value: Evidence from the Harvey Weinstein Scandal and the #MeToo Movement

DOI: 10.1111/1475-679X.12573

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full author-documented Stata workflow: raw-source preparation and sample/variable construction, followed by the empirical table-producing program. All supplied branches are retained; exact packaged mapping inputs are readable with the expected selected keys, while raw-source history/schema and several manual/generated handoffs remain unresolved.

Entry points: `Code/LRST-create-sample.do`, `Code/LRST-empirical-tests.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 5/12573 - Sexism-Culture-and-Firm-Value-Evidence-from-the-Harvey-Weinstein-Scandal-and-the-MeToo-Movement/lrst-datasheet-code-identifiers-and-log-files.zip",
      "sha256": "2d38ee009a319c19baf063c9af2d270a04897dd6f8c83b21fdaf37ef57482f37"
    },
    {
      "path": "JAR-Volume 62/Issue 5/12573 - Sexism-Culture-and-Firm-Value-Evidence-from-the-Harvey-Weinstein-Scandal-and-the-MeToo-Movement/lrst-online-appendix.pdf",
      "sha256": "68b2072986498dc67d85eae9d848d30105800225e656336c375986bafded3d3e"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "336124bf7075d91d29b901d258f3a8211c3d3d318c7e043615760d4458e8183d"
}
```

## Proposed actions

### A_REVIEW_INPUTS: Stage the compatible packaged mappings and any confirmed local/public products, then resolve each listed source's required fields, history, identifiers and documented joins before a full run. Preserve unsupported product/coverage gaps and the manual duplicate-map specification as explicit prerequisites.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COMP_FYEAR, R_EXEC_GENDER, R_EXEC_MAIN, R_CRSP_EVENT, R_BOARD_DIRECTORS, R_COMP_FYEAR_2018, R_CRSP_CUSIP_2015, R_EXEC_2019, R_FACTSET_SEC_PRICES, R_FACTSET_SEC_COVERAGE, R_FACTSET_SYM_COVERAGE, R_FACTSET_SECURITY_ENTITY, R_FACTSET_ENTITIES, R_FACTSET_GVKEY_LINK, R_FACTSET_13F, R_FACTSET_HSEC_CUSIP, R_FACTSET_HSEC_ISIN, R_FACTSET_HSEC_SEDOL, R_REF_ESG_HEADER, R_FACTSET_ENTITIES_NAME, R_REF_ESG_MEASURES, R_FACTSET_13F_ALL, R_CRSP_TABLE2_DAILY, R_FACTSET_HOLDINGS_BY_FIRM, R_CRSP_MONTHLY, R_REF_ESG_ITEMS, R_DATA_PRE_ESG, R_CRI_PD, R_COMP_ANNUAL_2021, R_COMP_QUARTERLY_2021, R_IBES_SUMMARY, R_IBES_PRICE, R_IBES_LINK, R_WRDS_CAR, R_SIC_PERMNO_LINK, I_DATA_INPUT_CLOSURE, R_GVKEY_DUPLICATES, R_COMPANYID_GVKEY_LINK, R_GVKEY_PERMNO_LINK
Evidence: E_DOC_PRODUCTS, E_DO_COMP_FYEAR, E_DO_EXEC_GENDER, E_DO_EXEC_MAIN, E_DO_CRSP_CAR, E_DO_CAR_INPUT, E_DO_CAR_WINDOWS, E_DO_SAVE_FIRM_FEMALE, E_DO_USE_FIRM_FEMALE, E_DO_USE_ARCRSP, E_DO_BOARD, E_DO_DIRECTORS_OUTPUT, E_DO_COMP18, E_DO_CRSP_CUSIP, E_DO_EXEC19, E_DO_FACTSET_PRICES, E_DO_FACTSET_COVERAGE, E_DO_FACTSET_SECURITY_ENTITY, E_DO_FACTSET_PRICE_HISTORY, E_DO_FACTSET_MKTCAP, E_DO_FACTSET_ENTITIES, E_DO_FACTSET_LINK, E_DO_FACTSET_13F, E_DO_FACTSET_HOLDINGS_TOTAL, E_DO_FACTSET_IDS, E_DO_REF_HEADER_CUSIP, E_DO_REF_HEADER_ISIN, E_DO_REF_HEADER_SEDOL, E_DO_REF_HEADER_NAME, E_DO_REF_HEADER_COMBINE, E_DO_REF_ESG_RAW, E_DO_FACTSET_ENTITIES_NAME, E_DO_13F_ESG, E_DO_ESG_JOIN, E_DO_ESG_WEIGHT, E_DO_ESG_HOLDINGS_FINAL, E_DO_LONGTERM, E_DO_TABLE2A, E_DO_TABLE2B, E_DO_TABLE3, E_DO_TABLE1, E_DO_TABLE4_START, E_DO_FACTSET_TMP1, E_DO_FACTSET_TMP1_USE, E_DO_ESG_SCORE_PRODUCER, E_DO_ESG_SCORE_USE, E_DO_TABLE2A_PRODUCER, E_DO_TABLE2A_USE, E_DO_DIRECTORS_USE, E_DO_TABLE3_PRODUCER, E_DO_TABLE3_USE, E_DO_TABLE4_FINAL, E_DO_TABLE56, E_DO_TABLE7, E_DO_TABLE8, E_DO_TABLE9, E_DO_MONTHLY_RETURNS, E_DO_TABLE4_PRODUCER, E_DO_TABLE4_USE, E_DO_13F_PERF_PRODUCER, E_DO_ESG_CONSTANT_PRODUCER, E_DO_ESG_CONSTANT_USE, E_DO_TABLE56_PRODUCER, E_DO_TABLE56_USE, E_DO_TABLE10, E_DO_PRIOR_ANALYSIS_INPUT, E_DO_PD_SAMPLE, E_DO_TABLE11_ANNUAL, E_DO_TABLE11_QUARTERLY, E_DO_TABLE12_EVENT_LIST, E_DO_TABLE12_WRDS_CAR, E_DO_TABLE12_IBES_PRICE, E_DO_TABLE12_MAIN, E_DO_SAVE_FIRM_FEMALE_2015, E_DO_USE_FIRM_FEMALE_2015, E_DO_USE_FIRM_FEMALE_2015_T12, E_DO_GVKEY_DUPLICATES, E_APP_LONGTERM_15Q, E_APP_REF_ESG_PERIOD, E_PACKAGED_INVENTORY, E_PACKAGED_1, E_PACKAGED_2, E_PACKAGED_3, E_PACKAGED_4, E_PACKAGED_5, E_PACKAGED_6, E_PACKAGED_7, E_PACKAGED_8, E_CATALOG_PRODUCTS, E_CATALOG_SPECIFIC, E_CATALOG_FIELDS_02, E_CATALOG_FIELDS_03, E_CATALOG_FIELDS_04, E_CATALOG_FIELDS_05, E_CATALOG_FIELDS_06, E_CATALOG_FIELDS_07, E_CATALOG_FIELDS_08, E_CATALOG_TARGETED, E_CATALOG_SELECTED, E_CATALOG_MARKET, E_LOCAL_FUNDA, E_LOCAL_FUNDQ, E_LOCAL_CCM_LINK, E_LOCAL_ANNCOMP, E_LOCAL_DSF, E_LOCAL_MSF, E_LOCAL_DSENAMES, E_LOCAL_DSI, E_LOCAL_MSI, E_LOCAL_BOARDEx, E_LOCAL_IBES, E_PUBLIC_NUS_PD, E_PUBLIC_NUS_CSV, E_PUBLIC_NUS_HISTORY, E_PUBLIC_NUS_LOGIN

Preparation / proposed procedure:

1. Preserve the original package and prepare a separate portable working copy.
2. Resolve the exact prior-study pre-ESG and CRI PD source file contracts, sample/history, company identifiers and permission-compatible delivery; do not reconstruct the prior dataset independently.
3. Check the separate Compustat annual and quarterly sources and the L4.saleq history needed by the selected Table 11 rows.
4. For Table 12, prepare the event-date list in memory from the IBES summary, use the specified WRDS event-study parameters 120 80 20 -1 1, acquire the resulting output, and check its event dates/identifiers against the authored consumer without inventing a saved input-list filename.
5. Obtain/clarify the author-prepared raw\gvkey-duplicates-checked file, its lpermno/datadate population and the meaning of drop==1; do not recreate its manual decisions.
6. For the 13F persistence classification, confirm that the supplied source begins at 2014q1 or otherwise preserves the appendix's 15-quarter 2014q1-2017q3 definition; code currently applies only the 2017q3 upper bound.
7. Use the exact packaged CompanyID-gvkey, gvkey-permno, FactSet-gvkey, Refinitiv ESG-header, IBES-firm and SIC-permno files with their probed source columns; validate key types and coverage against consumers after staging, since each one-row probe establishes readability/schema only. Treat Sample/LRST-gvkey as an identifier list and the packaged Refinitiv-header-FactsetID as a generated output.
8. Use the bounded local candidate metadata only for the fields it establishes. Confirm the author-specific histories and complete schemas for Compustat, Execucomp, CRSP, BoardEx and IBES; resolve point-in-time links and any market-index/price joins using the supplied acquisition recipe before relying on those candidates. Retain FactSet/Refinitiv source-file requirements and the all-history 13F lower-bound clarification because the surfaced local records do not establish those products.
9. For the Table 10 NUS-CRI input, use the official PD/actuarial-spread monthly product as a candidate public route, but confirm login eligibility, historical period, CSV fields and exact CompanyID/month/spread mapping before acquisition; no download was attempted.

Validation to perform later:

- After a separately authorized run, verify every generated intermediate's columns, identifiers and date window against its immediate consumer.

### A_STATA_CHECK: Use the available Stata 18 runtime and confirmed reghdfe/ftools/esttab/estadd/sicff commands, and set up the missing winsor2 command before the full author workflow. Metadata and static documentation do not establish successful execution or every call option.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S_STATA, S_REGHDFE, S_WINSOR2, S_SICFF, S_ESTTAB, S_ESTADD, S_FTOOLS
Evidence: E_DOC_WORKFLOW, E_DOC_SCRIPTS, E_DO_TABLE1, E_DO_TABLE11_QUARTERLY, E_DO_TABLE12_MAIN, E_A_SCRIPT_HEADER, E_A_TABLE_OUTPUTS, E_A_TABLE9_ESTADD, E_ENVIRONMENT_SAFE, E_SOFTWARE_SICFF, E_DOC_REGHDFE, E_DOC_WINSOR2, E_DOC_ESTTAB, E_DOC_ESTADD

Preparation / proposed procedure:

1. Use the safe environment record for installed Stata 18, reghdfe 6.12.3, ftools 2.49.1, esttab 2.1.1 and estadd 2.3.5; the exact sicff command is found under Stata 18. Keep the requested Stata/MP Windows environment and local runtime/platform compatibility as a future check.
2. Before a separately authorized run, provision winsor2 from its official SSC package record; no package was installed during this assessment. Verify the supplied winsor2 ..., replace cut(1 99) call against the selected package help in the working copy.
3. In a separately authorized working copy, verify the exact authored reghdfe, esttab, estadd and sicff calls under the selected Stata/add-on releases, then run the supplied drivers in the documented order. Preserve all estimators, samples, windows and outputs.

Validation to perform later:

- Before author-code execution, record exact runtime/command versions and confirm the documented commands and options resolve; after separate authorization, compare both driver logs and all expected table CSV outputs.

### A_WRDS_EVENT: Complete the supplied Table 12 manual event-study handoff. The source creates an in-memory list of adjusted IBES announcement dates and specifies WRDS Event Study parameters 120 80 20 -1 1, then reads a downloaded output file; service access and exact output alignment remain unverified. The official static documentation states that the suite requires a subscription; this user's entitlement and exact output schema have not been checked.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_WRDS_CAR, S_WRDS_EVENT
Evidence: E_DO_TABLE12_EVENT_LIST, E_DO_TABLE12_WRDS_CAR, E_PUBLIC_WRDS_EVENT

Preparation / proposed procedure:

1. In a separate working copy, run the supplied event-date preparation from the IBES summary/link inputs and transfer its in-memory permno/date list to the WRDS Event Study tool.
2. Use the authored 120 80 20 -1 1 parameters and save the compatible result to the author's raw\WRDS-car-m1p1-mm path in the working copy.
3. Confirm nrets/evtdate/permno/car fields, event dates and adjusted-date matching before the full analysis run.
4. Before a separately authorized WRDS step, confirm account entitlement and the documented event-list interface/output fields through the ordinary product documentation or account workflow; no login/query was performed here.

Validation to perform later:

- After separately authorized execution, compare each retained WRDS event record with the IBES event list and verify the generated CAR joins by permno and adjusted announcement date.

### A_FULL_RUN_ORDER: Run the two supplied Stata entry points in producer-consumer order in a separate portable working copy and preserve authored outputs/logs.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_DATA_INPUT_CLOSURE, S_STATA, S_REGHDFE, S_ESTTAB, S_ESTADD
Evidence: E_DOC_SCRIPTS, E_A_SCRIPT_HEADER, E_A_TABLE_OUTPUTS, E_SB_OUT_TABLE1, E_SB_OUT_TABLE2A, E_SB_OUT_TABLE3, E_SB_OUT_TABLE4, E_SB_OUT_TABLE56, E_SB_OUT_TABLE7A, E_SB_OUT_TABLE7B, E_SB_OUT_TABLE8A, E_SB_OUT_TABLE8B, E_SB_OUT_TABLE9A, E_SB_OUT_TABLE9B, E_SB_OUT_TABLE10, E_SB_OUT_TABLE11, E_SB_OUT_TABLE12, E_A_READ_TABLE1, E_A_READ_TABLE12

Preparation / proposed procedure:

1. Stage all verified raw sources and packaged link inputs under a portable working root with the authored raw, links, compiled and output directories; keep original package files unchanged.
2. Run Code/LRST-create-sample.do first. It creates the sample/leadership/controls inputs, daily event CARs and directors; then the FactSet prices/security/13F chain, Refinitiv identifier crosswalk and ESG score/weighted holdings branches; then Table 2-9, Table 10 PD, Table 11 quarterly Compustat and Table 12 IBES/WRDS outputs.
3. After the sample builder completes, run Code/LRST-empirical-tests.do to consume the generated Table 1-12 samples and export output/table*.csv; keep the supplied table and event-study branches, including both panels and the constant/time-varying ESG samples.
4. Preserve the data-creation and results logs and compare each generated file's columns/keys to its next listed consumer before interpreting output.

Validation to perform later:

- After separately authorized execution, confirm both scripts complete from the same working root, every expected generated intermediate exists with its source-defined columns/keys, and all Table 1-12 output CSVs are written.

### A_DUPLICATE_MAP: Resolve the missing manual duplicate-check input as an author-prepared source. Its drop flag affects which Compustat records survive the firm-controls stage, and no supplied producer or rule defines those decisions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_GVKEY_DUPLICATES, I_DATA_INPUT_CLOSURE
Evidence: E_DO_GVKEY_DUPLICATES

Preparation / proposed procedure:

1. Obtain the exact author-prepared raw\gvkey-duplicates-checked table and its lpermno/datadate keys.
2. Confirm the population and definition of drop==1 and its coverage for the Compustat records used by the sample builder.
3. Keep the original table and author decision rule with the portable working copy; do not independently re-create the flag.

Validation to perform later:

- After a separately authorized run, verify the table's keys/flag and resulting Compustat join against the supplied source definition.


## Remaining issues and prerequisites

- I_DATA_INPUT_CLOSURE [unresolved; full_pipeline]: The full supplied workflow has two Stata entry points: raw/sample construction in Code/LRST-create-sample.do and table analyses in Code/LRST-empirical-tests.do. All 50 frozen dependency IDs are reviewed, including 16 exact producer-to-consumer empirical sample files. The packaged DTA files are readable with their selected mapping/header schemas; Sample/LRST-gvkey is only a gvkey identifier list, not an analysis panel. The packaged CompanyID-gvkey, gvkey-permno, FactSet-gvkey, Refinitiv ESG-header, IBES-firm and SIC-permno mappings are compatible author inputs at the probed schema level; the one-row probes do not establish mapping coverage or types.

Required raw-source gaps remain for distinct Compustat annual/fiscal-date and quarterly/employee inputs, three Execucomp panels, CRSP daily event/2015 identifier/Table 2 and monthly-return inputs, BoardEx directors, the FactSet price/coverage/symbol/security/entity/13F/entity-name/H_SECURITY/ownership-summary products, Refinitiv ESG measures and items, the pre-ESG Table 10 panel, NUS-CRI monthly PD/AS values, and IBES summary/price inputs. Bounded local SAS catalog metadata and one-row probes identify candidate Compustat FUNDA/FUNDQ, Execucomp ANNCOMP, CRSP DSF/MSF/DSENAMES/CCMXPF_LINKTABLE/DSI/MSI, BoardEx NA_DIR_PROFILE_DETAILS and IBES STATSUM_EPSUS fields. These checks do not establish the required file periods/populations or full author contracts: Compustat EMP/SIC/LPERMNO and link semantics, BoardEx CompanyID/year/director-type fields, CRSP market-index and point-in-time identifier joins, and IBES adjusted product/price/PRDAYS mapping remain open. Distinct Revelio and WRDS ESG catalog candidates do not establish the required FactSet security/holdings or Refinitiv firm-security/item products; catalog misses are not availability, licensing or access-barrier findings.

The appendix's long-term investor definition requires holdings every quarter from 2014q1 through 2017q3, while the supplied all-history 13F count has an upper bound but no matching 2014q1 lower bound. The appendix also reports Refinitiv ESG gender-diversity measures for 2013-2020, whose mapping to the supplied ESG-items file remains unverified. The manual raw\gvkey-duplicates-checked input and the definition/population of its drop flag have no supplied producer. The official NUS-CRI pages identify monthly PD/AS products and access conditions, but the Table 10 companyid/mon_yr/spread mapping, required history and account eligibility are unresolved; WRDS documentation requires an Event Study Suite subscription, but account entitlement and the nrets/evtdate/permno/car output alignment are unknown.

Stata 18, reghdfe 6.12.3, ftools 2.49.1, esttab 2.1.1, estadd 2.3.5 and the sicff command are reported available by safe metadata; winsor2 is not found in checked ado paths and requires setup. Version-specific call behavior was not run. The scope remains full_pipeline with closure_complete=false and an unresolved issue; the package does not supply a verified analysis-only dataset route.
- R_COMP_FYEAR [undetermined]: The author workflow's Compustat annual source supplies gvkey/fyear/datadate/lpermno for the fiscal-year/date and firm-controls stages. A local FUNDA candidate confirms selected gvkey/datadate/fyear fields; the exact lpermno construction, required row history, and compatible data coverage remain unresolved.
- R_EXEC_GENDER [undetermined]: The separate author-named Execucomp 2010-2022 input supplies execid, nameprefix and gender to the gender-correction stage. A local ANNCOMP candidate has a matching selected-field probe, but the required period/population and full-file type compatibility remain unverified.
- R_EXEC_MAIN [undetermined]: A distinct raw Execucomp panel feeds the main female-leadership construction, links on fyear/gvkey to the generated Compustat date table and selects records before 2017-10-01. The local ANNCOMP candidate confirms several matching executive fields, but the complete main-file contract and required history remain unverified.
- R_CRSP_EVENT [undetermined]: Daily CRSP observations joined to the 2017 firm sample supply permno/date/ret/vwretd for a market model estimated over 2016-09-01 to before 2017-09-01 and event windows in October-November 2017. The filename indicates June 2014-June 2018; actual field and date coverage remain unverified.
- R_BOARD_DIRECTORS [undetermined]: The 2019-02-07 BoardEx summary feeds the director panel; code reads CompanyID, AnnualReportYear, Gender and DirectorTypeEDorSD, forms the latest eligible record in 2016-10-01 to 2017-10-01, then links through the supplied CompanyID-gvkey and gvkey-permno files. Actual file schema/history and route remain unverified.
- R_COMP_FYEAR_2018 [undetermined]: A distinct raw Compustat 2010-2018 file supplies gvkey/fyear/datadate/lpermno to create compiled/fyear-datadate-2010-2018 for the 2015 executive and identifier preparations. Actual coverage and route remain unverified.
- R_CRSP_CUSIP_2015 [undetermined]: A separate CRSP daily source supplies date, permno and ncusip; the code retains monthly-end identifiers for calendar 2015 and saves compiled/cusip-2015. Local DSF and DSENAMES candidates provide selected date/permno and permno/ncusip fields, but their point-in-time join and required 2015 coverage are not established. The produced intermediate's downstream consumer is not identified in the cited workflow.
- R_EXEC_2019 [undetermined]: A distinct raw Execucomp 2010-2019 file feeds the 2015 leadership construction and joins to the separately generated 2010-2018 fiscal-date table. Observed code needs year, gvkey, execid, execrankann, ceoann, cfoann, execdir, gender and nameprefix; actual coverage and route remain unverified.
- R_FACTSET_SEC_PRICES [undetermined]: FactSet security prices are consumed in multiple stages to identify securities with prices, calculate security termination dates, historical monthly prices/market value, and construct market capitalization. Observed input fields include FSYM_ID, PRICE_DATE, ADJ_PRICE, ADJ_SHARES_OUTSTANDING, UNADJ_PRICE and UNADJ_SHARES_OUTSTANDING; the required date range is not explicit for the full-history operations.
- R_FACTSET_SEC_COVERAGE [undetermined]: FactSet security coverage is filtered to equity/ADR/preferred types and joined by FSYM_ID to raw symbol coverage; the security-coverage file supplies FSYM_ID, ISSUE_TYPE and ISO_COUNTRY, while the separate symbol file supplies FREF_SECURITY_TYPE.
- R_FACTSET_SYM_COVERAGE [undetermined]: Raw FactSet symbol coverage is independently consumed by a join on FSYM_ID to add FREF_SECURITY_TYPE to eligible securities; this source read is absent from the frozen dependency checklist.
- R_FACTSET_SECURITY_ENTITY [undetermined]: A distinct FactSet Security entity source is joined by FSYM_ID to security/termination data and contributes FACTSET_ENTITY_ID; this raw join is absent from the frozen dependency checklist.
- R_FACTSET_ENTITIES [undetermined]: The supplied preparation code reads a distinct FactSet entity table for FACTSET_ENTITY_ID, ENTITY_TYPE, ENTITY_SUB_TYPE and ISO_COUNTRY and saves compiled/factset/inst_type_country. No downstream read of that intermediate is identified in the cited branches; the supplied source read is retained and its intended use should be confirmed. Bounded local queries did not establish a compatible local FactSet source.
- R_FACTSET_13F [undetermined]: FactSet institutional holdings records are independently required. The supplied code uses FSYM_ID, FACTSET_ENTITY_ID, REPORT_DATE and ADJ_HOLDING, retains the latest report date per institution-quarter, and joins quarterly date keys to generated security prices and market capitalization. The ESG branch also keeps ISO_COUNTRY, a source field required for that join/holding stage.
- R_FACTSET_HSEC_CUSIP [undetermined]: FactSet H_SECURITY_CUSIP is independently read and reduced to CUSIP, PROPER_NAME and FACTSET_ENTITY_ID for the ESG identifier crosswalk.
- R_FACTSET_HSEC_ISIN [undetermined]: FactSet H_SECURITY_ISIN is a separate required identifier table, reduced to ISIN, PROPER_NAME and FACTSET_ENTITY_ID.
- R_FACTSET_HSEC_SEDOL [undetermined]: FactSet H_SECURITY_SEDOL is a separate required identifier table, reduced to SEDOL, PROPER_NAME and FACTSET_ENTITY_ID.
- R_FACTSET_ENTITIES_NAME [undetermined]: A second and distinct raw FactSet Entities table is read for FACTSET_ENTITY_ID and ENTITY_NAME to build the ESG name-matching crosswalk. This differs from the earlier factset-entities type/country table.
- R_REF_ESG_MEASURES [undetermined]: A distinct raw Refinitiv ESG export is required. Code joins it to the generated dscode-to-FactSet map, uses fyr_month/year/esg_fyr_latest, recasts the score fields and constructs TRESGS/SOSCORE/TRESGSOWOS quarterly measures; the exact ordered variable range ENSCORE-TRESGSOWOS and raw export schema still require confirmation.
- R_FACTSET_13F_ALL [undetermined]: A distinct later FactSet '13F holdings, all' file is used to count investor-firm quarter holdings for long-term/transient classification. Code renames factset_entity_id, joins through FSYM_ID, retains reports through 2017q3 and counts holding quarters over whatever source history is supplied; the required lower history bound is unspecified. The online appendix defines long-term investors as held every quarter for 15 quarters from 2014q1 through 2017q3, while this code counts all source history before 2017q4 without an explicit 2014q1 lower bound; the source start/history contract must therefore be resolved for that classification.
- R_CRSP_TABLE2_DAILY [undetermined]: A distinct CRSP daily return file supplies permno/date/ret/vwretd to Table 2 Panel A and Table 3. Code keeps 2017-09-01 through 2017-11-30 and retains only permnos with N==63 after de-duplication; actual coverage and market-return fields remain unverified.
- R_FACTSET_HOLDINGS_BY_FIRM [undetermined]: A distinct FactSet Ownership Summary/holdings_by_firm_msci input joins to the 2017 firm panel on factset_entity_id and provides rquarter, mktcap and quarter for Table 4, which feeds Tables 5-6. Its compatible local source, complete field contract and required period remain unresolved.
- R_CRSP_MONTHLY [undetermined]: A distinct CRSP monthly 2015-2022 file supplies PERMNO, date, RET and vwretd to create quarterly firm and market returns/excess returns. The code reads all rows; the actual downstream Table 8 sample uses only the quarters inherited from the 2016-2019 FactSet summary panel, so no extra post-2019 coverage is inferred as mandatory.
- R_REF_ESG_ITEMS [undetermined]: A separate Refinitiv ESG items file is independently joined by CUSIP in both Table 9 panels; code reads year and a further set of item fields used by the empirical analysis. Panel A keeps year>=2013 and drops 2017; Panel B keeps year>=2013 and creates event-time indicators through 2020. Exact item schema/history and field mapping remain to be confirmed. The appendix reports Refinitiv ESG gender-diversity measures over 2013-2020, but the exact mapping from those measures to this code's named ESG-items file and variables remains unverified.
- R_DATA_PRE_ESG [undetermined]: The supplied code requires a distinct author-prepared pre-ESG monthly analysis file joined on gvkey. It feeds companyid/cusip_id/month identifiers and the variables spread, rating, mve, offering_amt, retvol_d, duration, month12 and int1-int4 into Table 10; exact schema, history and acquisition route are unresolved.
- R_CRI_PD [undetermined]: The Credit Research Initiative NUS PD file is joined on companyid and mon_yr and contributes spread to the Table 10 monthly credit-spread panel. The source population, field ownership after the join and date coverage remain unresolved.
- R_COMP_ANNUAL_2021 [undetermined]: Annual Compustat employee data provide gvkey/fyear/emp/datadate to build employeesY-2021-08-02; code selects the last datadate within each gvkey/fyear and joins the output to quarterly Compustat by gvkey/fyear.
- R_COMP_QUARTERLY_2021 [undetermined]: Quarterly Compustat supplies datadate, gvkey, fyearq, oibdpq, saleq, cogsq, atq and sic to Table 11, after deduplication against the 2015 Execucomp leadership panel and employee join. Because sales_growth uses L4.saleq before filtering, input rows must support four-quarter lags for selected periods: 2015q1 onward for 2016 sample rows and 2017q1 onward for 2018-2020 rows, with authored sample windows 2016-01-01–2017-09-30 and 2018-01-01–2020-12-31.
- R_IBES_SUMMARY [undetermined]: The adjusted IBES summary file is used for earnings announcement dates/times, annual actual and meanest values, ticker/fiscal period and statpers. The code joins the packaged ticker-company link, restricts to annual fpi=1 for Table 12, takes the latest statpers per ticker/fpedats, and later keeps anndats_act from 2016-01-01 with fpedats through 2020-12-31 while excluding announcements in October 2017.
- R_IBES_PRICE [undetermined]: A separate adjusted IBES price file supplies ticker, statpers, price and prdays; it is joined to the annual IBES summary by ticker/statpers and nonpositive/missing prices are excluded before constructing ux/price.
- R_WRDS_CAR [undetermined]: The supplied workflow expects a separate downloaded WRDS Event Study output file. The code creates the event list in memory from IBES announcement dates/times, sends permno/date to the tool with event-study parameters 120 80 20 -1 1, and then reads nrets/evtdate/permno/car; it retains maximum nrets and joins CAR by permno/adjusted announcement date. The manual tool run, output availability and event-date alignment remain unverified.
- R_GVKEY_DUPLICATES [undetermined]: The firm-controls stage requires a separate author-prepared manual duplicate-check table keyed by lpermno/datadate; the supplied code drops rows where its drop flag equals 1. The table's source population, exact flag definition, coverage and producer are not provided and must not be independently reconstructed.
- S_WINSOR2 [preparation_required]: winsor2 was not found in checked ado paths. Its official SSC record documents a replace option matching the supplied call's option family, but the command is not installed and the exact cut(1 99) syntax/version behavior remains to be confirmed after setup.
- S_WRDS_EVENT [unverified]: The official WRDS page describes the event-study service and requires a suite subscription. Current account entitlement and the author output interface remain unverified; no login or query was attempted.

## Review notes

- The assessed scope is the complete supplied workflow across Code/LRST-create-sample.do and Code/LRST-empirical-tests.do. The supplied Sample/LRST-gvkey.dta is a one-column identifier list and the other packaged DTA files are links/headers, so they do not support a separate analysis-only route. Full-pipeline closure remains unresolved for the inputs and specifications stated in I_DATA_INPUT_CLOSURE. Exact packaged mapping roles and selected schemas are credited; one-row coverage_verified=false metadata is retained as a coverage limitation, not imposed as a blanket prerequisite for author-prepared mappings.
- The appendix's 2014q1-2017q3 long-term investor definition remains distinct from the source code's upper-bound-only 13F count; the appendix's 2013-2020 Refinitiv diversity period is not mapped to a file without evidence. The manual duplicate-check drop flag remains author-defined and unresolved. Public NUS-CRI/WRDS routes remain candidates with the documented access conditions and unknown user eligibility/output mapping.
- Process history only: probes/source_display_incident.json is value-free and intentionally unreferenced; original stdout/stderr capture fields remain null, and the bounded initial byte screen found zero checked authentication/connection/credential patterns and one private-filesystem-path candidate. It is not an exhaustive secret-absence claim. No source body was re-retrieved or re-displayed after the report. This display-guard method limit is not evidence of credentials, input incompatibility or an additional workflow gate. Catalog field-selection repair history and two failed static estout help-page fetches are also preserved in unreferenced E_PROCESS_* records; they are not scientific findings. No author program, statistical trial, dataset/model download, software install, login or service query was performed.
