# Patch proposal: jar-bb9da8ca9682

Corporate Litigation, Governance, and the Role of Law Firms

DOI: 10.1111/1475-679X.70021

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author workflow: CRSP-based SAS preparation, real-data Stata analysis, its gated event-study handoff, Appendix Figure C.2, and the separate synthetic mock validation branch.

Entry points: `01 - kim_skinner.sas`, `02 - transparency.sas`, `03a - tests_realdata.do`, `03b - tests_mockdata.do`, `04 - appendix_figure_C2.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 2/70021 - Corporate-Litigation-Governance-and-the-Role-of-Law-Firms/fmnpr-datasheet-code-identifier-and-log-files.zip",
      "sha256": "bc6d6dabc0bf2539fd63090e7ddd1fd1d5fa8749cb6d43137a07bd4cb9115eed"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "c73adda6a22cd2c406efd01bec1aaae84aaadbf85271ca3d3b023b3f0b95d583"
}
```

## Proposed actions

### ACT_MAIN_DATA_CLOSURE: Establish the exact author-prepared real analysis table and its documented producer-to-consumer handoff.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_MAIN_DATA, ISSUE_MAIN_DATA, ISSUE_SOURCE_CLOSURE
Evidence: E_REAL_INPUT, E_DS_UNIT, E_DS_LOGS, E_DS_LOGS_CONF, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Identify or supply the exact real-data Stata table named by 03a, together with its native schema, identifier definitions and observation unit.
2. Provide a sanitized, source-registered materialization/field-standardization description for the documented data-construction workflow; the current assessment leaves the raw log bodies opaque.
3. Confirm the table's producer order and that its one-record-per-lawsuit structure and fields match the supplied real-data driver; do not substitute mock_dataset.dta.

Validation to perform later:

- Compare the author's schema and observation unit with the 03a entry and datasheet before any future run.
- Verify the named output's native columns and producer handoff using authorized metadata without executing the historical log.

### ACT_CRSP_PREPARATION: Use the positive native CRSP/FF sources, retain the actual link-data gaps, and treat the SAS-to-Stata handoffs as portable same-data preparation.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_CRSP_MSF, REQ_CRSP_MSI, REQ_CRSP_DSF, REQ_FF_FACTORS_DAILY, REQ_KIM_GVKEY_LINK, REQ_KIM_NCUSIP_LINK, REQ_TRANS_GVKEY_LINK, ISSUE_SAS_LINKS, ISSUE_TRANS_HANDOFF, ISSUE_RAW_COVERAGE, ISSUE_KIM_EXPORT
Evidence: E_PROBE_MSF, E_PROBE_MSI, E_PROBE_DSF, E_PROBE_FF, E_PROBE_CCM, E_PROBE_MSENAMES, E_FIELD_COMPARISONS, E_SAS_LINK_KIM, E_SAS_NCUSIP_USE, E_SAS_TRANS_LINK, E_SAS_TRANS_TABLE, E_WRDS_MERGES, E_SAS_ROLL

Preparation / proposed procedure:

1. In a portable working copy, configure the SAS librefs for the already readable CRSP MSF/MSI/DSF and FF daily tables. During preparation compare source dates with the 1969 input filter, required lag history and 1970–2020 rolling outputs; the one-row probes establish fields, not full coverage.
2. Keep the two distinct CRSP-GVKEY link inputs and the NCUSIP/share-code panel separate. Resolve each source-supported filter/date rule and compare its identifier, DATADATE and link-interval contract before constructing any replacement.
3. Use source02 to build bidask, amihud and idiosyn and the GVKEY/PERMNO/year link, then carry the generated transparency measures to the Stata consumer. Preserve GVKEY/year and the three named measures; this handoff is generated from the real raw sources, not a separate raw input.
4. For source01, route the established t.kimskinner Stata export to a writable relative destination in the portable working copy, preserving its table definition and values; the masked original destination is an assessment display limit, not an author-approval gate.

Validation to perform later:

- As preparation, compare native fields, observed dates, required lag windows and intended population with the source filters and 1970–2020 outputs. Do not treat a one-row probe as coverage proof, and do not require an exhaustive full-file sweep absent a specific mismatch.
- Compare the generated transparency schema and GVKEY/year keys with the downstream Stata merge and the separately unresolved CRSP-GVKEY mapping; retain actual key, population and history gaps without inventing a substitute.

### ACT_VENDOR_EXPORTS: Confirm the exact author-specified vendor products and supply compatible prepared exports or a documented local route.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_FINANCIAL_RATIOS, REQ_IBES, REQ_INST_OWNERSHIP, REQ_KLD_GOVERNANCE, REQ_BOARD_SIZE, REQ_CEO_PAY, REQ_BOARDEX_SUMMARY, REQ_TICKER_PERMNO, REQ_ISS_LEGACY, REQ_ISS_MODERN, ISSUE_VENDOR_INPUTS, ISSUE_TICKER_GOVERNANCE
Evidence: E_WRDS_MERGES, E_KLD_PREP, E_BOARD_PREP, E_CEO_PREP, E_BOARD_SUMMARY, E_TICKER_ISS, E_CONTROL_FIELDS, E_NATIVE_CATALOG, E_FIELD_COMPARISONS

Preparation / proposed procedure:

1. Confirm the Financial Ratios suite product, IBES forecast family, Thomson/Refinitiv ownership edition, KLD export, BoardEx board-size and separate summary files, ExecuComp CEO measure construction, and the legacy/modern ISS ESG exports.
2. For each product, provide current access/route, full native columns, identifier/date keys and exact period; preserve the distinct BoardEx files and the separate 1990-2006 and 2007-2020 ISS panels.
3. Compare the native exports to the code's GVKEY/year or TICKER/year fields, specified outcomes and lead/lag transformations; treat CRSP/KLD/ExecuComp catalog matches as candidates only until mapping is supported.

Validation to perform later:

- Verify product edition, field names, sample-period coverage and each join key against the source code before use.
- Confirm that one-year shifts and carry-forward transformations reproduce the code's timing.

### ACT_INSURANCE_PREMIUM_DATA: Establish the workbook and two manual premium inputs with their definitions, authorized routes and year mappings.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_INSURANCE, REQ_NY_PREMIUM_EXTRA, REQ_NY_PREMIUM, REQ_PPI, ISSUE_INSURANCE, ISSUE_MANUAL_PREMIUMS, ISSUE_PPI_MEANING
Evidence: E_INSURANCE_STATA, E_C2_INS_IMPORT, E_C2_INS_FIELDS, E_PREMIUM_EXTRA, E_PREMIUM_NY, E_PPI_CEO, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Identify the authorized version of confidential_insurance_data.xlsx and document GVKEY, PYear, limit, deductible-price and domestic-premium definitions, units and import headers.
2. Supply the two distinct research-assistant premium files with their provenance and native schemas; confirm the premium variable names and filing-year shifts.
3. Document the source, base year, unit and interpretation of idx in inflation_ppi.xlsx before using it to adjust compensation.

Validation to perform later:

- Verify workbook sheets/headers and native fields without exposing mixed workbook bodies.
- Check GVKEY/year joins and year+1 transformations against the supplied code and confirm idx's scale before any future calculation.

### ACT_EVENT_STUDY_HANDOFF: Resolve the gated WRDS event-study producer and its unconditional CAR-file consumers.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_EVENT_NCUSIP, REQ_EVENT_GVKEY_LINK, REQ_EVENT_ARS, REQ_EVENT_CARS, ISSUE_EVENT_BOOTSTRAP
Evidence: E_EVENT_BRANCH, E_EVENT_WORKSHEETS, E_EVENT_CARS, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Confirm the current doevtstudysample setting and whether cars_filedate.dta/cars_settledate.dta are already available; retain both downstream merges.
2. If the producer is intended to run, provide the exact CRSP monthly share-code and CRSP/Compustat link inputs, then follow the author's WRDS Event Study Suite handoff for separate filing-date and settlement-date Excel outputs.
3. Preserve the code's PERMNO/abret/event-time/date parsing and CAR(-1,+1), CAR(-3,+3), CAR(-5,+5) outputs; do not drop event windows or alter the analysis.

Validation to perform later:

- Verify both date-specific event workbooks, their normalized Stata columns, GVKEY/date merge keys and CAR outputs before running 03a.
- Confirm that the producer branch or an independently verified pre-existing output route supplies both unconditional merge inputs.

### ACT_C2_CASE_DATA: Identify the separate prepared lawsuit universe and case-source files required by Appendix C.2.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_RANKINGS, REQ_MSCAD, REQ_AA_CASES, REQ_FED_CASES, ISSUE_RANKINGS, ISSUE_C2_CASE_INPUTS
Evidence: E_C2_RANKINGS, E_C2_RANKING_OUTCOMES, E_C2_MSCAD, E_C2_AA_READ, E_C2_FED, E_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Supply or identify the author-prepared data_with_rankings_v7.dta producer and native schema, including masterid_all/source IDs, GVKEY, event dates, settlement outcomes and idx.
2. Identify the exact MSCAD, AA and federal source products behind their prepared case files, with case ID/nature-of-suit fields and the authorized linkage to masterid_all.
3. Keep those sources distinct and preserve the supplied litigation-risk filters and event-study design; do not independently reconstruct the data.

Validation to perform later:

- Validate each source's identifiers, fields, date coverage and linkage to the ranked lawsuit universe before running Appendix C.2.
- Confirm the ranked universe is not being substituted with the separate 03a real-data table.

### ACT_COMMENT_EDGE: Record the active sic_at.dta input with the supported C.2 consumer contract and resolve only its still-unknown availability, provenance, history and calendar-year mapping.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_SIC_AT, ISSUE_COMMENT_EDGE
Evidence: E_D49_BYTE_META, E_C2_RANKING_OUTCOMES, E_C2_SIC_AT_CONSUMER_FIELDS

Preparation / proposed procedure:

1. Use the hash-bound byte metadata and direct registered C.2 evidence to record D0049 as an active sic_at.dta input; no source-owner confirmation is needed for the command/comment boundary.
2. Carry the supported contract into preparation: GVKEY, FYEAR, SICH and SIC; force-destring GVKEY/SICH/SIC; retain rows with nonmissing GVKEY/FYEAR; deduplicate on GVKEY/FYEAR; fill missing SICH from SIC; and map SICH to FF12 with type 12. Leave the precise calendar-year conversion unspecified until directly supported.
3. Check the actual named input in the portable C.2 working directory against the four-field contract and document its acquisition/provider and source-history coverage when supported; keep the native route unverified until actual file availability is established.

Validation to perform later:

- Confirm a real input route and native presence of GVKEY, FYEAR, SICH and SIC; verify the preparation operations against the supported code, but do not claim provider, history or calendar-year mapping until documented.
- Keep REQ_SIC_AT required and availability unverified until a real route is supported; do not infer a producer, substitute, license status or unsupported date conversion.

### ACT_SAS_SOFTWARE: Verify the SAS/STAT runtime required by PROC REG and its author-defined library configuration.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS_STAT
Evidence: E_ENV_METADATA, E_SAS_STAT_DOC, E_SAS_FF

Preparation / proposed procedure:

1. In an authorized future execution environment, verify SAS 9.4 and SAS/STAT availability/license without running the author code during this assessment.
2. Configure the CRSP, FF and author-prepared link librefs from the verified data locations and preserve any author-required setup.

Validation to perform later:

- Record SAS/STAT/PROC REG availability and confirm CRSP/FF library mappings before the first authorized SAS run.

### ACT_STATA_ADDONS: Prepare the exact Stata add-ons that the supplied code currently cannot resolve.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_WINSOR2, SW_PSMATCH2, SW_PSACALC, SW_LABMASK, SW_PARMEST
Evidence: E_SW_WINSOR2, E_SW_PSMATCH2, E_SW_PSACALC, E_SW_LABMASK, E_SW_PARMEST

Preparation / proposed procedure:

1. In an authorized Stata 18 environment, install or configure winsor2, psmatch2, psacalc, labmask and parmest according to the user's package policy; this assessment made no installations.
2. Keep the code's calls and statistical design unchanged, and record the version/location used for each command.

Validation to perform later:

- Run exact `which` metadata checks for all five commands in the future run environment and confirm Stata reports each available before launching the author scripts.

### ACT_RUN_AFTER_PREPARATION: Run the supplied branches after genuine required inputs and software are configured; validate generated handoffs and keep routine date/population checks within preparation.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: REQ_MAIN_DATA, REQ_CRSP_MSF, REQ_CRSP_MSI, REQ_CRSP_DSF, REQ_FF_FACTORS_DAILY, REQ_EVENT_CARS, REQ_RANKINGS, REQ_SIC_AT, REQ_MOCK_DATA, ISSUE_MAIN_DATA, ISSUE_EVENT_BOOTSTRAP, ISSUE_RAW_COVERAGE
Evidence: E_DS_PROGRAMS, E_DS_UNIT, E_SAS_ROLL, E_SAS_TRANS_TABLE, E_FIXED_SAMPLE, E_C2_RANKINGS, E_EVENT_CARS, E_MOCK_LOAD, E_PROBE_MOCK

Preparation / proposed procedure:

1. After input setup, run SAS programs 01 and 02 in their source-supported configurations in a portable working copy, then validate their generated SAS/Stata table handoffs.
2. Run 03a after its real prepared table, vendor files, insurance workbook, distinct manual premium inputs, PPI input and both CAR merge inputs are available and their native contracts are checked.
3. Run Appendix C.2 separately after the active sic_at.dta target, rankings, case, insurance and BoardEx inputs have documented/readable contracts; run 03b only against the synthetic mock-data branch.
4. Preserve the authors’ variables, observations, estimators and event windows. Keep execution_verified false until an authorized end-to-end execution is actually completed.

Validation to perform later:

- Check each stage’s expected fields and keys before passing its outputs downstream; distinguish generated tables from independent raw inputs.
- Treat comparison of dates, lag history and populations as routine preparation. The bounded native probes do not verify full coverage, and no specific incompatible period is established here.


## Remaining issues and prerequisites

- ISSUE_MAIN_DATA [unresolved; full_pipeline]: The real-data driver names its author-prepared analysis table, but the registered package inventory does not include it and no successful compatible read/schema probe is registered. This is an inventory/route gap, not proof that the file is absent elsewhere.
- ISSUE_SOURCE_CLOSURE [unresolved; full_pipeline]: The datasheet places dataset-construction instructions in author logs and reports confidentiality suppression around name-standardization output. The full log bodies remain opaque in this review, so the exact producer, normalized fields and handoff are not established; this is not a claim that no workflow exists.
- ISSUE_SAS_LINKS [unresolved; full_pipeline]: SAS programs 01 and 02 read distinct author-prepared CRSP-GVKEY link inputs, and program 01 separately reads NCUSIP/share-code history. Local CRSP link/name products are positive raw candidates, but interval/date expansion and the author's exact filters/output schemas are not established.
- ISSUE_TRANS_HANDOFF [preparation; full_pipeline]: Source02 constructs bidask, amihud and idiosyn, builds the GVKEY/PERMNO/year link and merges the transparency measures; source03a consumes the GVKEY/year keyed measures. The named handoff is generated from CRSP DSF/FF and link inputs. Portable SAS-to-Stata staging is same-data preparation; retain upstream link/history and future schema/key/population checks without a duplicate raw transparency requirement.
- ISSUE_VENDOR_INPUTS [unresolved; full_pipeline]: The analysis names separate WRDS financial-ratio, IBES, institutional-ownership, KLD, BoardEx, ExecuComp and ISS ESG inputs. Their prepared files, exact product variants, current access routes, complete native fields and source periods are not registered. Exact catalog hits are candidates; catalog misses do not establish absence or licensing status.
- ISSUE_MANUAL_PREMIUMS [unresolved; full_pipeline]: Two different NY premium files are described as manually collected from 10-K and DEF 14A filings. Neither file is registered, and their distinct variable mappings/provenance need confirmation.
- ISSUE_INSURANCE [unresolved; full_pipeline]: Both real-data and Appendix C.2 programs consume the same confidentially labeled insurance workbook. Its current authorized route, column definitions, coverage and unit conventions are unverified; the label alone is not treated as a confirmed denial.
- ISSUE_EVENT_BOOTSTRAP [unresolved; full_pipeline]: The source gates event-date production behind a scalar and comments that it is enabled by setting the scalar to 1; the resulting cars files are later merged unconditionally. The current setting, pre-existing files, CRSP link inputs and manual WRDS event-study results are not verified.
- ISSUE_TICKER_GOVERNANCE [unresolved; full_pipeline]: The CRSP ticker mapping and two distinct ISS governance panels must cover the stated legacy and modern periods and retain the specified ticker/year transformations. The author's files and full periods are not registered.
- ISSUE_PPI_MEANING [unresolved; full_pipeline]: The code multiplies CEO compensation by an imported December index named idx, but the visible source does not define the series, base year or scale.
- ISSUE_RANKINGS [unresolved; full_pipeline]: Appendix C.2 requires a separate prepared ranked-lawsuit universe with source IDs, GVKEY, dates, settlement fields and idx. The registered scripts do not supply its producer, and this file is distinct from the main 03a input.
- ISSUE_C2_CASE_INPUTS [unresolved; full_pipeline]: Appendix C.2 reads distinct MSCAD, AA and federal case sources and maps their identifiers to masterid_all. Their prepared files, current routes and population coverage are not verified.
- ISSUE_RAW_COVERAGE [preparation; full_pipeline]: The four exact native CRSP/FF one-row probes positively establish readability and consumed fields but not full dates or population. No specific incompatibility is established. Check the 1969 filters, lag history and 1970–2020 outputs as ordinary preparation; do not claim coverage verified or require exhaustive full-file proof.
- ISSUE_KIM_EXPORT [preparation; full_pipeline]: Source01 establishes the t.kimskinner producer and labels the following operation as a Stata export. Its literal destination was withheld from the assessment view; that display limit does not establish a missing output or require author confirmation. Choose a writable relative path in a portable working copy and preserve the same table.
- ISSUE_COMMENT_EDGE [unresolved; full_pipeline]: The byte-only receipt and the direct registered C.2 consumer excerpt establish that sic_at.dta is an active required input and establish the supported GVKEY/FYEAR/SICH/SIC field and transformation contract: GVKEY/SICH/SIC are force-destringed, rows require nonmissing GVKEY/FYEAR, records are deduplicated by GVKEY/FYEAR, missing SICH falls back to SIC, and SICH maps to FF12 type 12. The precise calendar-year mapping, input acquisition/provider and source-history coverage remain unknown; no producer or access status is inferred. The command/comment boundary is resolved without author-version confirmation, while the actual route remains unverified.
- REQ_MAIN_DATA [undetermined]: The author's real-data Stata input, described as one observation per lawsuit, must match the complete 03a field contract and preserve the prepared sample and analysis design. The package includes only a synthetic mirror and an identifier list, not this real analysis table.
- REQ_KIM_GVKEY_LINK [undetermined]: The first SAS program reads an author-prepared GVKEY/LPERMNO/DATADATE link source, renames the identifiers to PERMNO/date, and joins monthly return statistics by security/year/month. Preserve this input as distinct from the similarly named source in SAS program 02.
- REQ_KIM_NCUSIP_LINK [undetermined]: The first SAS program reads a separate CRSP monthly CUSIP/share-code history input, merges it to stocks by PERMNO/date and keeps share codes 10/11. The author panel's construction and coverage are not registered.
- REQ_TRANS_GVKEY_LINK [undetermined]: The second SAS program reads its own author-prepared CRSP-GVKEY link input and creates an annual GVKEY/PERMNO link using the source date. This path/source is kept separate from SAS program 01.
- REQ_FINANCIAL_RATIOS [undetermined]: The real-data analysis merges the WRDS Financial Ratios suite export by GVKEY/year_f and uses at least cash_lt. Other ratio variables used by model macros must be matched against the actual prepared file; the exact Financial Ratios product/period is unresolved.
- REQ_IBES [undetermined]: The analysis merges an author-prepared IBES export by GVKEY/year_f and model macros use andisp, anerr and ancoverage. The exact IBES family/forecast definition, format, years and route are not specified.
- REQ_INST_OWNERSHIP [undetermined]: The analysis merges Thomson/Refinitiv (now LSEG) institutional ownership by GVKEY/year and uses instown, top10instown, instblockown, numinstowners, numinstblockowners and instown_hhi. Current source edition, fields and annual coverage remain unverified.
- REQ_KLD_GOVERNANCE [undetermined]: The real-data driver expects a prepared GVKEY/year/eindex table from the KLD page in WRDS and shifts the index one year before filing. The vendor export and exact e-index construction are not registered.
- REQ_BOARD_SIZE [undetermined]: The real-data driver expects BoardEx board size keyed by GVKEY/year and shifts it one year before filing. The author-prepared file and matching history are not in the package.
- REQ_CEO_PAY [undetermined]: The real-data analysis consumes prepared ExecuComp CEO measures keyed by GVKEY/year, including salary, bonus, equity pay, TDC1 and executive-role ID, for both filing and settlement timing. The author's prepared-to-native mapping and compensation definitions are unresolved.
- REQ_BOARDEX_SUMMARY [undetermined]: Appendix C.2 separately merges a BoardEx summary by masterid_all and later uses board-composition change variables. This file is distinct from boardex_touse.dta and its full field contract/product route are not verified.
- REQ_INSURANCE [undetermined]: The shared insurance workbook is consumed by both 03a and Appendix C.2. The code uses GVKEY, PYear, deductible-price, domestic-premium and coverage-limit fields, with a filing-year normalization and annual panel. The workbook and its definitions/access route are not in the package.
- REQ_NY_PREMIUM_EXTRA [undetermined]: A separately collected NY-incorporated premium file supplies premium/GVKEY/year values and is shifted to filing year. The author describes collection from 10-K and DEF 14A filings; provenance and prepared file are not included.
- REQ_NY_PREMIUM [undetermined]: A second, distinct NY-incorporated premium file is merged by GVKEY/year and contributes insurancepremium. It is also described as manually collected; do not treat it as the extra file.
- REQ_EVENT_NCUSIP [undetermined]: If the event-study producer is enabled, it requires a CRSP Monthly Stocks PERMNO/date/share-code panel and keeps share codes 10/11 before event-date construction. The author-prepared Stata link file is not registered.
- REQ_EVENT_GVKEY_LINK [undetermined]: If the event-study producer is enabled, a separate CRSP/Compustat merged link file joins PERMNO to GVKEY and derives year/month from DATADATE. Exact link filters and date coverage are not established.
- REQ_EVENT_ARS [undetermined]: The event-study branch imports separate filedate and settledate Excel results produced through the WRDS Event Study Suite. Required columns are PERMNO, abnormal return, event time and event date; exact event population/window coverage is not verified.
- REQ_EVENT_CARS [undetermined]: The real-data driver merges cars_filedate.dta and cars_settledate.dta by GVKEY/date outside the event producer block. The block can write these products from the date-specific WRDS spreadsheets when enabled; the current setting and a pre-existing compatible route are not established.
- REQ_TICKER_PERMNO [undetermined]: The governance-history construction requires a CRSP Monthly Stocks ticker/PERMNO/date mapping, retains December records, and joins two ISS panels by TICKER/year. The author-prepared table and exact history are not in the package.
- REQ_ISS_LEGACY [undetermined]: The legacy ISS governance panel supplies TICKER/YEAR/GINDEX and the six legacy E-index components for 1990-2006, which the code maps to PERMNO and carries forward by year.
- REQ_ISS_MODERN [undetermined]: The modern ISS panel supplies TICKER/Year, SUPERMAJOR_PCNT and Yes/No governance flags for 2007-2020; the code converts these to a binary e-index and merges by ticker/year.
- REQ_PPI [undetermined]: The CEO compensation construction imports date and idx from an author workbook and uses December observations to adjust salary, bonus and TDC1. The substantive definition/source and scale of idx are not specified in the visible code.
- REQ_RANKINGS [undetermined]: Appendix C.2 requires the prepared lawsuit/rankings universe keyed by masterid_all and source identifiers and uses GVKEY, filing/settlement dates, settlement outcome/value and idx. It is distinct from the 03a star_lf input; no producer or compatible package copy is registered.
- REQ_SIC_AT [undetermined]: Appendix C.2 actively consumes the author-named sic_at.dta input. Its bounded consumer requires GVKEY, FYEAR, SICH and SIC; force-destrings GVKEY, SICH and SIC; keeps nonmissing GVKEY/FYEAR rows; deduplicates by GVKEY/FYEAR; fills missing SICH from SIC; and maps SICH to 12-industry FF12. The input acquisition/provider, source-history coverage and precise calendar-year mapping remain unknown; native file availability remains unverified.
- REQ_MSCAD [undetermined]: Appendix C.2 uses MSCAD lawsuit identifiers/category/type to classify D&O risk and then matches those identifiers to masterid_all. Required fields are mscad_id/mscad_id_0, case_category and case_type.
- REQ_AA_CASES [undetermined]: Appendix C.2 uses the AA case identifier and nature-of-suit fields, filters specified nature-of-suit codes, and links them to masterid_all.
- REQ_FED_CASES [undetermined]: Appendix C.2 uses federal case IDs and nature-of-suit fields, filters specified codes, and links them to masterid_all.
- SW_SAS_STAT [unverified]: The typed environment projection did not verify SAS availability. The supplied SAS code invokes PROC REG, which SAS's official SAS/STAT guide documents as a SAS/STAT regression procedure; installation/license availability remains unverified.
- SW_WINSOR2 [preparation_required]: The exact Stata 18 which probe returned not found; the supplied drivers call winsor2.
- SW_PSMATCH2 [preparation_required]: The exact Stata 18 which probe returned not found; the supplied drivers call psmatch2.
- SW_PSACALC [preparation_required]: The exact Stata 18 which probe returned not found; the supplied drivers call psacalc.
- SW_LABMASK [preparation_required]: The exact Stata 18 which probe returned not found; the supplied drivers call labmask.
- SW_PARMEST [preparation_required]: The exact Stata 18 which probe returned not found; the supplied drivers call parmest to produce stepper tables.

## Review notes

- Static feasibility assessment only. No author/SAS startup/model/statistical/query/import/compile trial, installation, download, authentication test, source mutation or outgoing message was performed; execution_verified remains false.
- Author logs and mixed workbook bodies remain opaque. Datasheet statements about logs are cited as documentation only; they do not establish that construction code/data is absent.
- The first source-screening pass transiently displayed a quoted drive-root token at line 9 of 03a before the forward-slash path mask was corrected. That value was not retained locally, the pre-correction reader bytes/capture were not preserved, and it is not reproduced here. Corrected safe_reader.py and archived safe_reader_corrected_v3.py share SHA-256 8ca4882e0e3c7d4e578a0afe19076cdbe2fd5e27149d801af5608761be07f21d; five value-free fixtures passed. The process-only incident record captures this method, source-line, provenance and retention limit; it is not scientific evidence and does not establish an access, credential or execution barrier.
- Successful one-row probes preserve positive local CRSP/FF native-field routes. Their coverage_verified=false result limits period/population claims but does not negate field compatibility or file readability.
- The mock dataset is directly readable but synthetic. No analysis_only scope is supported because no compatible real-data analysis input route has been verified.
- Exact catalog misses and partial product matches remain discovery limits, not evidence of absent data or licenses. Candidate raw products are not substituted for author-prepared panels without source-supported field and transformation mappings.
- D0049 is an active sic_at.dta input based on the byte-only receipt. Direct registered C.2 consumer evidence E_C2_SIC_AT_CONSUMER_FIELDS establishes the supported field contract GVKEY, FYEAR, SICH and SIC: GVKEY/SICH/SIC are force-destringed; rows with nonmissing GVKEY/FYEAR are retained; records are deduplicated by GVKEY/FYEAR; missing SICH falls back to SIC; and SICH maps to FF12 type 12. The source row and trailing comment remain opaque. Input acquisition/provider, source-history coverage and precise calendar-year mapping remain unknown; no producer or license is inferred, and native availability remains unverified. E_D49_SCREEN and E_D49_WORKITEM remain unused process-history inspections and appear in no evidence_ids list. The transparency handoff is generated from separate raw DSF/FF/link inputs. The Kim export destination mask is an assessment display limit handled by portable same-table setup; the four native table field routes remain positive, while date, lag and population validation is routine preparation. All three earlier finalizer attempts and corrected reader/capture-limit records remain preserved outside scientific references.
