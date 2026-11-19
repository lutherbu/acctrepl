# Patch proposal: jar-7c73eb5e4c5a

Price Rigidities and the Value of Public Information

DOI: 10.1111/1475-679X.12495

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | blocked |

### full_pipeline

The registered author-supplied working-data workflow: both SAS preparation programs and the Stata master, including its independent output-producing branches. This scope follows the provided workflow and does not add unprovided paper-wide estimators.

Entry points: `_rar_static_Code Package/Code Package/Master File.do`, `_rar_static_Code Package/Code Package/Step1_sas_FFtiming.sas`, `_rar_static_Code Package/Code Package/Step6.1_sas_ERC.txt`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 1/12495 - Price-Rigidities-and-the-Value-of-Public-Information/gx-datasheet-code-and-identifiers.zip",
      "sha256": "5eda59559844952b6a83545fadeeeb02f3a1ebc8cfc9032ed27cbe0e236fe5ca"
    },
    {
      "path": "JAR-Volume 62/Issue 1/12495 - Price-Rigidities-and-the-Value-of-Public-Information/gx-online-appendix.pdf",
      "sha256": "39810d431248205cc5d40e7988b270b0be2bbff5da572fdefc974c44b82f8bd3"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "b63cb6ca8d618e61c47595a11d3e29084ad4b1b1566053072bbd6caebfc3c3c2"
}
```

## Proposed actions

### act_resource_routes: Confirm the local/authorized WRDS source products and complete input contracts for the supplied Compustat, CRSP and I/B/E/S stages before staging the local aliases or running the event study.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_compustat, req_compustat_quarterly, req_compustat_security, req_crsp, req_crsp_msedelist, req_crsp_linktable, req_crsp_dsf, req_ibes
Evidence: probe_comp_funda, probe_comp_fundq, probe_comp_security, probe_crsp_msf, probe_crsp_delist, probe_crsp_link, probe_crsp_dsf, probe_ibes_detu, probe_ibes_actu, catalog_compustat_search, catalog_crsp_search, catalog_ibes_search, src_sas1_compustat, src_sas1_crsp, src_sas1_ccm, src_sas6_dates, src_sas6_macros

Preparation / proposed procedure:

1. Use the documented author product route or the exact catalog-listed local candidates; record annual and quarterly vintages, sample populations, identifiers and complete required date ranges.
2. Confirm how the authored local.funda and local.fundq queries map to the selected annual and quarterly tables; preserve the Step 1 Compustat filters and Step 6.1 quarterly variables.
3. Establish the exact transformation/staging contracts for CRSP.MSF -> local.new, CRSP.MSEDELIST -> local.msedelist and CRSP.CCMXPF_LINKTABLE -> local.wonderful, including link type/primary-link/date rules and the 1959-plus accounting timeline.
4. Verify the CRSP daily event-window rows through the next earnings date and the I/B/E/S forecasts/actuals, report-date derivation, ticker linking and WRDS sample macro outputs; do not infer those from one-row table schemas.
5. Check that the annual SIC field used by the Stata working panel is actually produced; the catalog candidate has sich, so document an explicit source mapping rather than treating those names as equivalent.

Validation to perform later:

- After the source route and access are authorized, compare field names/types, full required periods, identifier/link uniqueness, and filter populations against the author code before any author program is run.
- Verify the staged SAS aliases and each cross-language key/schema at the documented handoff; preserve source and intermediate row counts without changing the authored definitions.

### act_path_setup: Prepare a working copy with coherent per-stage relative roots and writable outputs, while preserving the distinct author directories and avoiding workspace-specific absolute paths in executable configuration.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: issue_paths
Evidence: src_master_fisyrend, src_master_ffind, src_sas1_outputs, src_sas6_output

Preparation / proposed procedure:

1. Choose the runtime working directory and map each Stata global dir to the correct input or output root instead of the placeholder string.
2. Configure the SAS librefs and home/output library for the two independent SAS stages.
3. Resolve the supplied ffind helper into the path expected by the do call, using a copy of the registered helper or a coherent path update.
4. Keep project data roots relative or under [redacted-path-734f232c0925] in a future host wrapper and validate visibility/writability before any separately authorized run.

Validation to perform later:

- Review all reads, merges, includes, and writes against the configured roots without running author programs.

### act_ffind_contract: Keep SIC numeric for the supplied numeric-varlist ffind helper and configure the helper at the filename/path requested by the master.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: issue_ffind
Evidence: src_master_ffind, src_ffind_numeric

**Proposed edit:** `_rar_static_Code Package/Code Package/Master File.do:93–93`
Source SHA-256: `8095285b5cfcf96f2d3e552984d48d373bf1078be9261648f2802456e6c0082d`

The supplied ffind helper explicitly requires a numeric varlist, but the immediately preceding tostring changes sic to string. Remove only that incompatible conversion and preserve the authored numeric SIC input to the Fama-French mapping.

Current text:
```
tostring sic, replace 
```

Proposed replacement:
```

```

Preparation / proposed procedure:

1. In a working copy, remove the incompatible conversion at line 93 and retain the source version in the proposal record.
2. Place a copy of the registered ffind helper at the working-copy path named ffind.ado, or make the corresponding exact helper path resolve without changing its mapping logic.

Validation to perform later:

- After authorized execution, confirm the helper loads and produces the intended ffind48 mapping from numeric SIC values; this static assessment did not apply or execute the edit.

### act_producer_handoffs: Obtain the missing author-prepared working-panel inputs and producer/schema contracts, including each distinct SP1500 first, second, and third membership-period file; keep the SAS Step 1 outputs and Stata assumed panel separate until an explicit mapping is supplied.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_prepared_files, req_fisyrend, req_financialvars, req_analyst_counts, req_sp1500_membership, req_sp1500_membership_2, req_sp1500_membership_3, req_annual_panel, req_quarterly_controls, issue_prepared_producers
Evidence: src_master_step1, src_master_fisyrend, src_master_financialvars, src_master_analyst, src_master_spindex, src_master_annual_iv, src_master_quarterly_controls, src_sas1_outputs, catalog_fisyrend_search, catalog_financialvars_search, catalog_analyst_search, catalog_sp1500_search, catalog_annual_panel_search, catalog_quarterly_controls_search

Preparation / proposed procedure:

1. Request or locate Financial Data/FisYrEnd_All.dta, Financial Data/FinancialVars.dta, analyst.dta, all three SP1500 snapshots, Annual (1960-2017).dta and Quarterly Controls (1980-2017).dta with their author definitions.
2. For each file, document its exact key fields, period, identifier types, row uniqueness, variables consumed, upstream producer and compatible file path; the catalog misses do not establish that a copy or license is absent elsewhere.
3. Identify which firm-time dataset the Master expects loaded in memory and how it receives gvkey/year/portmonth/SIC/NAICS fields; obtain the exact SAS-to-Stata export/copy and filtering procedure if loc1.ccm3_june or loc2.ccm4 is intended to contribute.
4. Keep the three S&P membership merges and the separate annual/quarterly prepared panels in the supplied workflow; do not replace them with a guessed common panel or rebuild from raw products without the author contract.

Validation to perform later:

- Before running the master, compare every prepared input's merge keys, variable names/types, years, industry-code widths and merge uniqueness with the exact consuming statements.
- Trace the initial loaded panel and every prepared-file producer to its first consumer, including the observed working directory and output location.

### act_sas_stata_conversion: Prepare the documented SAS-to-Stata conversion/copy for mine.suecars at the consumer's expected relative path and verify the converted schema, rows, and history before the Stata consumer runs, after SAS inputs and runtime are separately authorized.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: issue_sas_stata_handoff, issue_suecars_schema_history
Evidence: src_sas6_output, src_master_sas_handoff, src_master_quarterly_controls

Preparation / proposed procedure:

1. Export or convert the SAS table mine.suecars from the configured SAS home library to the Stata-readable .dta path the master consumes; do not treat the SAS dataset name/location as an existing Stata file.
2. Preserve the SAS output columns gvkey, lpermno, ticker, ibtic, rdq, fqenddt, fyearq, fqtr, sue1, sue2, sue3, numest, car1, daysCAR1 and car2, with the corresponding SAS labels where supported.
3. Keep the Stata rename of lpermno to permno and the subsequent merge to Quarterly Controls by permno/fyearq/fqtr; define the configured root so producer and consumer refer to the same file.

Validation to perform later:

- After authorized conversion, use bounded metadata to verify the output path, Stata readability, exact columns and storage types, merge keys, row preservation, and period/history coverage before the Stata consumer runs.

### act_identifier_mapping: Confirm the source and exact construction of the SAS ticker-list input and whether the packaged gvkey-only Identifier.xlsx can be mapped to it.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_identifier_list, issue_ticker_mapping
Evidence: probe_identifier_metadata, src_sas6_macros, src_sas6_dates

Preparation / proposed procedure:

1. Request the intended tickers input file and its contents/schema from an authorized owner; do not expose identifier values in the assessment.
2. Document the chosen IBES ticker vintage, any gvkey-to-ticker link rule, sample filters and output path; do not assume a gvkey workbook is a ticker list.

Validation to perform later:

- Before SAS execution, compare the generated list's identifiers and fields with the author sample macro requirements using bounded metadata and an authorized mapping review.

### act_dispersion_key: Resolve the prepared inputs and author-supported repair for the independent Step 7.3 dispersion branch; the current post-collapse source references i/n and pyear that are not present or produced after collapse.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_eps2yr, req_unique_cusip_link, req_stockprice, issue_dispersion_period, issue_dispersion_namespace
Evidence: src_master_step7_dispersion, probe_ibes_statsumu, probe_crsp_msf, catalog_two_year_eps_search, catalog_unique_cusip_search, catalog_stockprice_search, pub_stata_collapse_manual

Preparation / proposed procedure:

1. Preserve the confirmed current namespace defect: collapse by yr/permno leaves only the dispersion measure and those keys, before the source drops i/n and groups by pyear. Obtain author-supported corrected source or mapping; do not guess a year definition, add a reload, or change the aggregation.
2. Request the two-year-ahead monthly summary file with STDEV, ANNDATS and CUSIP and the full 1976-2021 sample contract; the catalogued I/B/E/S summary candidate lacks ANNDATS and is not a direct substitute.
3. Request Link (Unique Cusip).dta and its unique-CUSIP/PERMNO selection, identifier vintage and effective-date rule.
4. Request stockprice.dta or an author-supported monthly CRSP price mapping that preserves end-of-month PRC and the permno/yr/m key used by the Stata merge.
5. Clarify how pyear is created after the collapse by yr/permno and whether the grouped unit is a calendar or portfolio year; do not infer it from a different branch.

Validation to perform later:

- Verify CUSIP uniqueness, permno/year/month merge keys, June announcement selection, end-of-month price, pyear availability and output row uniqueness before running the branch.

### act_wrds_setup: Resolve SAS runtime initialization and prepare an authorized SAS/CONNECT WRDS session with the named sample macros, without copying credentials into the assessment or working-copy code.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw_sas_wrds, issue_wrds_setup
Evidence: src_sas1_compustat, src_sas1_crsp, src_sas1_ccm, src_sas6_macros, probe_environment

Preparation / proposed procedure:

1. Have the environment owner resolve the recorded TKELS startup failure or confirm a supported SAS 9.4 runtime; the available evidence does not establish a missing license.
2. Confirm authorized SAS/CONNECT access to WRDS and the referenced Compustat, CRSP, I/B/E/S and sample-macro paths through the approved secure runtime mechanism.
3. Review the withheld connection/return-source blocks privately only through the same credential-screened reader, and resolve missing field/history/query contracts without exposing connection values.
4. Keep runtime setup and the author-provided SAS sources unchanged until the required data and handoffs are confirmed.

Validation to perform later:

- Before any future author run, verify SAS initialization and macro-file availability using approved environment checks; separately verify WRDS service authorization without storing credentials in project files.

### act_bea_bls_sources: Confirm each author-shared FPA level file separately, the direct Month.dta input and its actual producer/contract, the prepared BEA/BLS files and vintages, and the firm-time handoff used by the visibility and instrument stages.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_fpa, req_fpa_5d, req_fpa_4d, req_fpa_3d, req_bea, req_io_naics, req_bls, req_bls_metadata, req_month_grid, issue_bls_handoff, req_bls_visibility_5d, req_bls_visibility_4d, issue_bls_namespace
Evidence: src_doc_proprietary_fpa, src_master_fpa, src_master_bls_raw, src_master_discontinued_inputs, src_master_bls_join, src_master_io_map, src_master_bls_iv_producer, src_master_bls_handoff, src_master_iv_inputs, pub_bea_io_accounts, pub_bea_io_guide, pub_bls_ppi_faq, pub_bls_ppi_overview, catalog_fpa_search, catalog_bea_search, catalog_inputshares_search, catalog_io_naics_search, catalog_bls_search, catalog_data_bls_search, catalog_month_search, src_master_bls_collapse_namespace, pub_stata_collapse_manual

Preparation / proposed procedure:

1. Obtain all four shared FPA files and their frequency definitions, NAICS key widths, variable names, population and period; preserve the authored six-/five-/four-digit fallback and three-digit merge.
2. Obtain the 1997-2017 monthly industry input-share table and IO NAICS crosswalk, or the author-approved table vintages and exact construction rules. The checked BEA pages document annual table levels but do not establish this monthly panel or mapping.
3. Obtain the author-selected BLS PPI history and the separate data_bls series-start/end metadata contract. BLS pages confirm current/discontinued historical PPI access, but do not establish the exact series or data_bls schema used here.
4. Treat Month.dta as generated calendar setup only after verifying the full data_bls begin/end period and YYYYMM key convention; preserve the supplied cross-and-range-filter logic that produces BLS Disclosure (discontinued).
5. Trace BLS Disclosure (--2018) and the generated discontinued panel into the input shares, then the IO NAICS join into the NAICS-month visibility table and the six-/five-/four-digit December-2002 outputs.
6. Resolve the step from the saved NAICS-month visibility table back to the firm-time panel, including the effective `$dir` value, subdirectory/output path, panel reload, portmonth creation and key types. Do not merge visibility data into a different in-memory table by assumption.
7. Obtain the five- and four-digit visibility tables as separate prepared inputs; document each producer, root, NAICS/portmonth keys, and the ratio-field names used by both the earlier merge and the December-2002 IV branch. Do not substitute the six-digit table or assume an aggregation.
8. Resolve the confirmed post-collapse namespace break with an author-supported reload/key mapping: the supplied source collapses to NAICS/month/BLSratio/BLSratio1 and then sorts naics6d/portmonth without reloading a firm-time panel. Preserve the actual mapping and path uncertainty until supported.

Validation to perform later:

- After authorized source acquisition/preparation, compare NAICS/useIO keys, year/month format, row uniqueness, index-series periods and all generated output schemas with each downstream merge.
- Confirm the producer path and every consumer path for the 1997-2017 visibility files and the three December-2002 files before running the ordered Stata sections.
- Before any later run, verify the collapsed table contract separately from the firm-time panel, and verify the independently consumed five- and four-digit inputs and their consumer-specific ratio fields.

### act_dailyreturn: Supply the prepared daily bid-ask input or document an exact CRSP DSF-to-dailyreturn preparation route that preserves the authored daily spread branch.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_dailyreturn
Evidence: src_master_step7_bidask, probe_crsp_dsf, catalog_dailyreturn_search

Preparation / proposed procedure:

1. Request Raw Data/dailyreturn.dta with permno, date, bid and ask, or obtain the author-defined DSF extraction/filter/conversion procedure for the same sample.
2. If using CRSP.DSF as an upstream candidate, verify paired nonmissing bid/ask, date conventions, security coverage and the DTA field types before creating the expected working-copy input.

Validation to perform later:

- Confirm the prepared input keys and the calculation's midpoint denominator, then preserve the separate Raw Data/bidaskspread.dta branch output and verify it is not silently substituted for another analysis input.

### act_pin_inputs: Request the author-prepared PIN component panel and its provenance; the supplied code computes pin from the named components and overwrites that input file.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_pin_data
Evidence: src_master_step7_pin, catalog_pin_search

Preparation / proposed procedure:

1. Obtain the exact Pin (--2012).dta input with a, u, eb and es plus its identifier, date/frequency, period, and source definition.
2. Confirm the intended overwrite/output location in the working copy while retaining the original author input and the separate PIN calculation branch.

Validation to perform later:

- Check component names/types, key uniqueness, sample dates and the formula output after the data route is authorized; retain the pre-calculation file unchanged.


## Remaining issues and prerequisites

- issue_paths [preparation; full_pipeline]: The Stata master repeats placeholder global-dir values and the SAS sources retain author-specific library/home roots. The effective working directories, input roots, and writable output locations are not configured for this environment.
- issue_ffind [preparation; full_pipeline]: The registered ffind helper is substantive code and declares a numeric input varlist. The master converts sic to string immediately before calling it, and its path requests ffind.ado while the registered filename is ffind.ado.ado.
- issue_prepared_producers [unresolved; full_pipeline]: The Stata master assumes an initial firm-time panel and several named prepared inputs, but no supplied Stata load step or producer is shown for them. The three SP1500 first/second/third membership-period files are distinct required inputs, and their producers and period coverage are not supplied. SAS Step 1 writes loc1.ccm3_june and loc2.ccm4; the master does not consume those names. The catalogued Compustat annual candidate exposes sich while the Stata helper call is supplied a sic variable; no mapping or panel handoff is established.
- issue_bls_handoff [unresolved; full_pipeline]: Separate from the confirmed current in-memory namespace defect in issue_bls_namespace, the supplied source does not establish the valid firm-time panel reload, NAICS/portmonth mapping, effective $dir root, or saved-file path. It also independently consumes author-prepared five- and four-digit visibility panels for the later merge and IV stage; no producer or cross-branch ratio-name mapping for those panels is supplied. Preserve these handoff and file-contract uncertainties without guessing a reload, key conversion, or aggregation.
- issue_sas_stata_handoff [preparation; full_pipeline]: A supported preparation step is to export/convert/copy SAS Step 6.1's mine.suecars dataset from its configured SAS home library to the Stata master's expected relative earnings surprise/suecars/suecars.dta path before Step 6.2. The source and consumer names/path are documented; no conversion was performed here. The remaining post-conversion schema, row, and history checks are tracked separately as issue_suecars_schema_history; effective roots remain under issue_paths.
- issue_suecars_schema_history [unresolved; full_pipeline]: After the supported SAS-to-Stata conversion/copy, the DTA storage types, row preservation/cardinality, and period/history coverage matching the separate Quarterly Controls file remain unverified. The source artifacts name the producer output fields and Stata consumer merge keys, but no converted DTA metadata or row/history check was performed; verify these contracts after conversion and before Step 6.2.
- issue_ticker_mapping [unresolved; full_pipeline]: The SAS event-study block has a ticker-list input whose surrounding connection/preparation statement was withheld after credential screening. The packaged Identifier.xlsx probe exposes a gvkey header, which does not establish the ticker list or a safe construction/mapping rule.
- issue_dispersion_period [unresolved; full_pipeline]: Independently of the confirmed namespace failure in issue_dispersion_namespace, the branch does not establish a producer or intended annual-period rule for pyear. The prepared EPS, CUSIP-link, and stockprice schemas, source periods, and fiscal-period mapping remain unverified. Do not infer calendar year, portfolio year, or another grouping from yr or from a different branch.
- issue_wrds_setup [unresolved; full_pipeline]: The SAS workflow requires a remote WRDS session and sample macros. The credential/connection scan identified candidate lines in the author sources; complete surrounding blocks were withheld from display, and no credentials or connection were used. SAS/WRDS access and the exact hidden connection configuration remain unresolved.
- issue_bls_namespace [blocking; full_pipeline]: In the supplied Master File.do, collapse by NAICS/month leaves only NAICS, month, BLSratio, and BLSratio1 in memory. The source saves that table, resets $dir, then sorts and merges on naics6d/portmonth without a use/reload between those statements. This is a confirmed current source-level namespace defect, supported by the saved source view and documented Stata collapse semantics. The intended firm-time reload and mapping are not supplied; do not invent them or treat the unresolved repair as a verified result.
- issue_dispersion_namespace [blocking; full_pipeline]: The supplied Step 7.3 source collapses to disp2_2year_ahead, yr, and permno, then issues drop i n before creating i or n in the collapsed table; it also groups by pyear without a producer. This is a confirmed current source-level namespace defect in the rank branch, separate from uncertainty about a scientifically valid grouping or repair. No execution or output is inferred.
- req_compustat [undetermined]: Compustat North America annual fundamentals read by SAS Step 1 from local.funda. The authored fields support book-equity construction; the later Stata SIC field belongs to the missing initial panel and is not inferred from Compustat sich.
- req_crsp [undetermined]: CRSP monthly security/return data used by the supplied Fama-French timing and portfolio-preparation stage. That stage actively reads local.new and does not actively create it in the commented source block.
- req_ibes [undetermined]: I/B/E/S US EPS detail forecast inputs used by SAS Step 6.1. The source declares the forecast fields and invokes WRDS sample and linking macros; actual-date derivation, CUSIP/ticker/CRSP linking, and coverage remain unverified.
- req_fpa [undetermined]: The distinct author-shared FPA6d.dta panel is merged m:1 on naics6d and supplies freq_id6 as the most granular inflex input. It is one of four separately required FPA files; types, frequency definition, NAICS mapping, and coverage remain unverified.
- req_fpa_5d [undetermined]: The distinct author-shared FPA5d.dta panel is directly merged m:1 on naics5d and supplies freq_id5; it is the second source in the inflex fallback. Its field types, frequency measure definition, NAICS vintage/crosswalk, and coverage remain unverified.
- req_fpa_4d [undetermined]: The distinct author-shared FPA4d.dta panel is directly merged m:1 on naics4d and supplies freq_id4; it is the third source in the inflex fallback. Its field types, frequency measure definition, NAICS vintage/crosswalk, and coverage remain unverified.
- req_fpa_3d [undetermined]: The distinct author-shared FPA3d.dta panel is directly merged m:1 on naics3d and supplies freq_id3; it is the final source in the inflex fallback. Its field types, frequency measure definition, NAICS vintage/crosswalk, and coverage remain unverified.
- req_bea [undetermined]: The author-prepared 1997-2017 monthly industry-by-industry input-share panel directly consumed by Stata Step 4.3. The separately consumed IO NAICS crosswalk is a second required input.
- req_bls [undetermined]: The BLS PPI series panel named by the Stata master and used to generate the current-period NAICS-month disclosure intermediate.
- req_prepared_files [undetermined]: The Stata master begins with an assumed in-memory firm-time panel and does not show a loader or a consume/copy of the SAS Step 1 outputs. Known later key use includes gvkey, year/fyear, portmonth, SIC, and NAICS industry codes, but the exact initial panel schema and SAS-to-Stata row mapping are not supplied.
- req_identifier_list [undetermined]: An identifier input is used by the SAS earnings-surprise stage, which reads [redacted-path-a17fddecd603]; the packaged Identifier.xlsx probe reports gvkey only, so the relationship is unconfirmed and does not establish an analysis-data route.
- req_pin_data [undetermined]: The PIN branch reads the author-named precomputed microstructure panel with components a, u, eb, and es. No compatible source mapping or producer is supplied.
- req_compustat_quarterly [undetermined]: Compustat North America quarterly fundamentals and earnings data queried by SAS Step 6.1 for the supplied earnings-surprise branch.
- req_compustat_security [undetermined]: Compustat Security identifier data needed for the ibtic field retained in the SAS earnings-surprise output.
- req_crsp_msedelist [undetermined]: CRSP monthly delisting returns and dates used by the supplied SAS Fama-French timing stage.
- req_crsp_linktable [undetermined]: CRSP/Compustat link history read as local.wonderful to match accounting observations to CRSP securities.
- req_crsp_dsf [undetermined]: CRSP daily return history read by the SAS earnings-announcement code for abnormal-return and CAR calculations.
- req_io_naics [undetermined]: The missing IO NAICS mapping directly joined to BEA use-industry code and year in the visibility construction; it is jointly required with the monthly input-share panel.
- req_bls_metadata [undetermined]: The BLS discontinued-series metadata input data_bls.dta, carrying industry code and beginning/ending year-period values used to generate a discontinued-index-by-month panel.
- req_month_grid [undetermined]: The Stata master directly cross-reads Month.dta while building the discontinued-index-by-month panel. The consumed month field is clear, but the file's producer, storage/encoding contract, calendar coverage, and construction method are not supplied.
- req_fisyrend [undetermined]: Author-prepared fiscal-year-end mapping file merged by gvkey/year before the master builds the working panel.
- req_financialvars [undetermined]: Author-prepared FinancialVars.dta merged by gvkey/fyear; the code excerpt establishes the merge key but not the file's complete variables, period, or producer.
- req_analyst_counts [undetermined]: Author-prepared analyst.dta merged by gvkey/fyear to create the annual number of outstanding valid analyst forecasts.
- req_sp1500_membership [undetermined]: The distinct author-prepared SP1500 1.dta file supplies the first SP1500 membership year-month interval. The master merges it m:1 by gvkey and consumes fromymonthSP1500/thrumonthSP1500; its exact dates, types, coverage, row uniqueness, and producer are not supplied. It is not interchangeable with the other occurrence files.
- req_sp1500_membership_2 [undetermined]: The distinct author-prepared SP1500 2.dta file supplies the second SP1500 membership year-month interval. The master merges it m:1 by gvkey and consumes fromymonthSP15002/thrumonthSP15002; its exact dates, types, coverage, row uniqueness, and producer are not supplied. It is not interchangeable with the other occurrence files.
- req_sp1500_membership_3 [undetermined]: The distinct author-prepared SP1500 3.dta file supplies the third SP1500 membership year-month interval. The master merges it m:1 by gvkey and consumes fromymonthSP15003/thrumonthSP15003; its exact dates, types, coverage, row uniqueness, and producer are not supplied. It is not interchangeable with the other occurrence files.
- req_annual_panel [undetermined]: Author-prepared Annual (1960-2017).dta directly used as the annual NAICS panel in the input-cost visibility instrument stage. No producer or source mapping is supplied.
- req_quarterly_controls [undetermined]: Author-prepared Quarterly Controls (1980-2017).dta merged to the SAS earnings-surprise output by permno/fyearq/fqtr. No producer or complete control-variable contract is supplied.
- req_dailyreturn [undetermined]: Prepared dailyreturn.dta used in the independent Stata daily bid-ask branch. The supplied code requires date, permno, bid, and ask and writes a separate bidaskspread output.
- req_eps2yr [undetermined]: The author-prepared monthly two-year-ahead EPS forecast-dispersion panel used in Step 7.3, with STDEV, ANNDATS, and CUSIP required by the Stata code.
- req_unique_cusip_link [undetermined]: Author-prepared unique-CUSIP-to-CRSP-PERMNO link table used by the two-year-ahead dispersion branch.
- req_stockprice [undetermined]: Author-named monthly stockprice.dta merged to the two-year-ahead dispersion panel by permno/year/month and used as the month-end price denominator.
- req_bls_visibility_5d [undetermined]: The author-prepared five-digit NAICS visibility panel named by the Stata master and independently consumed by the working-panel merge and December-2002 IV branch. The merge expects naics5d/portmonth and BLSdisratio5d/BLSdisratio15d; the IV branch reads naics5d/portmonth and BLSratio5d/BLSratio15d. The source does not establish whether these are co-resident fields or how the names relate, and supplies no producer for this prepared table.
- req_bls_visibility_4d [undetermined]: The author-prepared four-digit NAICS visibility panel named by the Stata master and independently consumed by the working-panel merge and December-2002 IV branch. The merge expects naics4d/portmonth and BLSdisratio4d/BLSdisratio14d; the IV branch reads naics4d/portmonth and BLSratio4d/BLSratio14d. The source does not establish whether these are co-resident fields or how the names relate, and supplies no producer for this prepared table.
- sw_sas_wrds [unverified]: The environment metadata records that the configured SAS command failed initialization at TKELS and classifies SAS availability as unverified; it does not establish a missing license. The author sources also require SAS/CONNECT to WRDS and named sample macros, which remain unverified. No SAS startup, author source, credentials or connection were used in this assessment.

## Review notes

- The full RAR nested sources are registered in the current work item with source and cache hashes. The earlier static audit's no-supported-code/unsupported-archive finding does not override the registered native Stata and SAS program content; this assessment credits the actual code, including Step6.1_sas_ERC.txt and ffind.ado.ado.
- The credential scan retained candidate line numbers and hashes only. Safe redacted views were used for source review; SAS connection/prelude blocks and candidate database/API/authentication statements were not displayed, copied, or used. Exact configuration and parts of the CRSP event-return producer remain unresolved.
- The assessment target is the supplied working-data workflow. Online appendix results and paper-wide estimators without a supplied consumer remain contextual limitations; all supplied SAS/Stata preparation and independent Step 7 output branches remain in scope.
- No author code, import/parse/syntax trial, SAS process, regression, statistical command, dataset, credential, installation, or payload was used. execution_verified remains false.
- A draft-section patch attempt was rejected before writing with the recorded apply_patch diagnostic; the unchanged prior draft was preserved before the smaller successful checkpoint. The rejected payload was not saved byte-for-byte in a local artifact and is not used as scientific evidence.
- The frozen local SAS catalog checks covered named Compustat, CRSP and I/B/E/S candidates plus exact prepared-file aliases; one-row probes establish bounded schema/readability only, not full history, population or license entitlement.
- Official BEA/BLS checks on 2026-11-11 inspected static documentation pages only; no dataset payload, form submission, API endpoint or download was requested. Public availability of a product does not establish the package-specific transformation or coverage.
- A saved frozen metadata-preflight invocation stopped before artifact verification because the draft contained a 63-character catalog_fpa_search SHA string. The exact failed result is preserved; the draft record is corrected to the actual query-artifact SHA before the next preflight.
- The second frozen metadata-preflight invocation stopped at the software evidence key check: the probe registers `Stata` while the draft named `Stata 18`. The exact failed result is preserved; the draft now uses the probe key and states version 18 in its description.
- Source-contract correction from the saved credential-screened view: the four FPA files are distinct merges with inflex fallback six-to-five-to-four-to-three, separate from the annual-IV six-to-five-to-four fallback. SP1500 1/2/3 are independent first, second, and third membership-period files. Month.dta is a direct input with no supplied producer or supported grid coverage/schema. The mine.suecars-to-DTA copy is a supported preparation step; only post-conversion storage types, row preservation, and history alignment remain unresolved. The earlier PPI hash correction and failure records remain preserved.
- Post-collapse source correction from the hash-verified credential-screened view: Step 4.3 leaves NAICS/month/BLSratio/BLSratio1 in memory and then sorts naics6d/portmonth without reloading; Step 7.3 leaves disp2_2year_ahead/yr/permno before referring to i/n and pyear. These are confirmed current namespace defects, while valid reload/key or year-grouping repairs remain unresolved. The five- and four-digit visibility panels are separately named inputs with independent consumers and no supplied producer; they remain distinct requirements. No author/runtime trial was used and no computed outcome/readiness claim was forced.
- The official Stata collapse manual was checked as static documentation on 2026-11-11. Its short quoted example supports only the in-memory dataset replacement semantics used in the source review; the failed version-18 URL fetch and current documentation provide no claim about the installed runtime.
