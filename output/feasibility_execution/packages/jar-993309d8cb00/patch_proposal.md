# Patch proposal: jar-993309d8cb00

The Effects of Analyst-Country Institutions on Biased Research: Evidence from Target Prices

DOI: 10.1111/1475-679X.12245

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented SAS preparation and Stata analysis workflow, including the separate return-predictive-power branch and country-data construction.

Entry points: `TP 20161119Submit.sas`, `Stata codes submit.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 1/12245 - The-Effects-of-Analyst-Country-Institutions-on-Biased-Research-Evidence-from-Target-Prices/bht-datasheet-and-code.zip",
      "sha256": "a16658a51267ae7f3b952ab0581bf130018f5c4e72db8c1a6eb86941136f35a3"
    },
    {
      "path": "JAR-Volume 57/Issue 1/12245 - The-Effects-of-Analyst-Country-Institutions-on-Biased-Research-Evidence-from-Target-Prices/bht-online-appendix.pdf",
      "sha256": "fb50f0c8c3bc31299a6f8b9a7e1d5d6b0335cbf1cd3060c5c781810c8f703e79"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "954e45c46621d821286b6f5c5c73859ac977b30484dc555c0ba682ab2c5ed372"
}
```

## Proposed actions

### A01: Obtain or confirm access to the full author-prepared Final_location analyst-year history.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R01
Evidence: E101, E102, E103, P002, E101B, E101C

Preparation / proposed procedure:

1. Request the complete prepared file and schema for analyst, annual location, and lag/lead fields used by the move-event code.
2. Treat the packaged random one-third latest-year sample as a demonstration, not a substitute for the longitudinal input.

Validation to perform later:

- Use bounded metadata to check fields/dates, then validate annual history and join keys before execution.

### A02: Confirm exact WRDS I/B/E/S products and macro outputs; current entitlement remains unknown.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R04, R05, R08, R09, R23, R24, R25, R26
Evidence: E105, E106, E108, E111, E113, E114, P006, P007, CAT001, E105B, E106B, E111B, E113B, E114B, E111C, E113C

Preparation / proposed procedure:

1. Confirm authorized WRDS access to NPTGDET, RECDDET, NPTGDETU and ACTPSUMU variants with source-used fields.
2. Supply eps_US.sas before defining the IBES forecast/actual output schema.

Validation to perform later:

- Compare bounded metadata with source fields/filters and confirm dates for TP, recommendations, actuals and announcement windows.

### A03: Supply the four missing SAS includes and document their generated table contracts.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I002, I003, R12, R13
Evidence: E108, E109, E110, E115, E117, E109B, E109C, E117B

Preparation / proposed procedure:

1. Provide eps_US.sas, Compustat_global_NAm_with_IBES_ticker.sas, EarnMgmt.sas and winsor.sas at compatible paths.
2. Document producers, fields and keys for CompFinal, GvkeyTicker, dafull/EarnMgmt and winsorized final outputs.

Validation to perform later:

- Trace include reads/outputs and compare generated schemas with downstream SAS consumers.

### A04: Validate Compustat annual, daily-price and return-factor products as inputs to author transformations.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R10, R11, R14, R15, R16, R17, R18, R19
Evidence: E110, E111, E112, E115, P013, P014, P015, P016, P017, CAT001, E111B, E112B, E111C, E112C, E112D

Preparation / proposed procedure:

1. Confirm Global and North American product names/fields, including G.SEC_DTRT THRUDATE and A.FYR/A.CTRYRET producer contracts.
2. Use local products only where product and fields match; G_SECD remains unverified as return-factor source because THRUDATE is absent.
3. Retain the 2000–2013 price filter and announcement-relative windows.

Validation to perform later:

- Check keys, fields and observed period, then compare constructed variables with downstream SAS reads.

### A05: Provide or locate the exact crosswalks and country-source workbooks used by SAS, with schemas and periods.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R27, R28, R29, R30, R31, R32, R33, R34, R35, R36, R37, R38, R39
Evidence: E129, E130, E131, E132, E133, E134, E136, E129B, E130B, E130C, E131B, E132B, E132C, E134B, E134C

Preparation / proposed procedure:

1. Stage named broker/country CSVs, governance/IDV datasets and country workbooks under a relative or [redacted-path-bd95dd0a2e43] root after confirming source and access conditions.
2. Confirm country normalization, year labels, workbook sheets and imported headers.

Validation to perform later:

- Inspect with bounded metadata and validate required keys, measures, years and country-year joins.

### A06: Reconcile SAS roots, library assignments, macro variables and local/remote boundaries.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I004, I006
Evidence: E104, E105, E131, E133, E134, E135, E136, E137, E138, E105B, E131B, E131C, E133B, E134B, E134C, E137B, E138B

Preparation / proposed procedure:

1. Choose a batch working directory visible to SAS and Stata; use coherent relative or [redacted-path-bd95dd0a2e43] paths while keeping distinct input/output directories.
2. Define local/remote contexts for A, N, T, SHARE and G; supply intended &dp and reconcile P/WORK aliases.
3. Check output visibility and writability before separate execution authorization.

Validation to perform later:

- Run configuration-only path/libref checks after files/macros are supplied; inspect all affected producer/consumer paths.

### A07: Document SAS-to-Stata producers, filenames, schemas and keys for JAR2 and Jarr1 branches.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I001, I007, R02, R03, R40, R41, R42, R43, R44, R45, R46, R47, R48, R49, R50
Evidence: E119, E120, E121, E122, E125, E135, E137, E120B, E121B, E121C, E122B, E137B, E121D, E121E

Preparation / proposed procedure:

1. Confirm whether final_new.dta supplies final.dta and specify a matching copy/rename or shared path.
2. Identify producers and schemas for headqctry_traits, govern, PCREV_firm, prc_revdate, PCREV, Jacksonroe and secreg files.
3. Confirm the separate Jarr1 product and SAS/Stata handoff.

Validation to perform later:

- Compare each Stata merge/use field with SAS outputs and key uniqueness; verify paths from the chosen working directory.

### A08: Identify A.FYR and A.CTRYRET producers, library, fields and date coverage.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I005
Evidence: E112

Preparation / proposed procedure:

1. Provide preparation code or a prepared-table specification for GVKEY/LOC/FYR and LOC/DATADATE/RET_DS.

Validation to perform later:

- Check keys and periods against daily prices and announcement windows.

### A09: Confirm the intended country-year merge key after Stata concatenates year into headqctry.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I008
Evidence: E120, E121, E120B, E121B, E121D

Preparation / proposed procedure:

1. Inspect prepared final/country files to establish whether keys are separate or combined; retain source transformation until confirmed.

Validation to perform later:

- Validate key uniqueness and merge cardinality.

### A10: Confirm whether the active one-observation-per-ticker filter is intended for later regressions.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I009
Evidence: E122

Preparation / proposed procedure:

1. Request intended analytic sample definition or a corrected source excerpt; do not infer from commented SampleTicker lines.

Validation to perform later:

- Validate row counts and uniqueness against the documented sample.

### A11: Remove the duplicate Stata declaration of y after the same variable has already been created.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I010
Evidence: E120, P005

**Proposed edit:** `Stata codes submit.do:20–20`
Source SHA-256: `c8e4c44581f8817c5a3d0ae9d11cf080b825bf7de5ff396837cb76bf81fcff09`

The same y variable is created at line 15 and is not dropped or renamed before this second gen; remove the duplicate declaration.

Current text:
```
gen y=string(year)
```

Proposed replacement:
```

```

Preparation / proposed procedure:

1. Apply this one-line proposal only in a separately authorized edit step; this assessment does not apply it.

Validation to perform later:

- Confirm one intended y declaration remains, then syntax-check after inputs are available.

### A12: Confirm intended treatment for the bare opt_accu6/opt_accu3 Stata assignments.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I011
Evidence: E118, E120, E118B, E120B

Preparation / proposed procedure:

1. Confirm whether to retain SAS-exported winsorized fields or recompute from ratio6/ratio3.
2. Do not add gen or replace before authors specify the intended treatment.

Validation to perform later:

- Check field presence and compare values with SAS export after clarification.

### A13: Map supplied A4 code to the documented non-US analyst sample and analyst-country-year unit.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I012, I013
Evidence: E122, E124, E128, E123B, E124B, E128B, E128C

Preparation / proposed procedure:

1. Confirm whether headqctry != "NA" is intended for A4 non-US analysts.
2. Confirm whether A4 Panel B uses analyst-country-year means or the coded firm/year/headquarter/analyst-country collapse.

Validation to perform later:

- Compare estimation sample and aggregation keys with A4 before execution.

### A14: Verify SAS 9.4 Base SAS, SAS/CONNECT, SAS/STAT, SAS/ACCESS Interface to PC Files, and WRDS session configuration after paths and credentials are prepared.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW01, SW07
Evidence: E105, P003, E105B, E139, E140, E141, E142, E143, E144, E145, E146, E147, E148, PUBSTAT_OVERVIEW, PUBSTAT_MI, PUBACCESS_EXCEL, PUBACCESS_DTA, PUBACCESS_LICENSE, E149, E150, E151, E152, E153

Preparation / proposed procedure:

1. Confirm SAS 9.4 Base SAS, SAS/CONNECT, SAS/STAT procedures, and SAS/ACCESS Interface to PC Files capabilities on the execution host; establish authorized WRDS access without embedding credentials.
2. Retain the TKELS startup failure as unverified, not as evidence of an absent license. Check host compatibility of the source-used DBMS=EXCEL2000, XLS, XLSX, DTA, and STATA identifiers before running the package; the SAS/ACCESS 9.4 reference documents DTA for Stata export, so preserve DBMS=STATA as an unverified spelling check.

Validation to perform later:

- Use an empty-session startup and configuration check after setup; verify the target host’s SAS/ACCESS-supported workbook and DTA routes while preserving the source-used identifiers. Do not assume Microsoft Excel or a SAS PC Files Server prerequisite for every route. Workflow execution requires separate authorization.

### A15: After resolving gaps, run SAS preparation and both Stata branches in producer-consumer order.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: SW02, SW03, SW04, SW05, SW06, SW01, SW07
Evidence: E105, E119, E120, E121, E122, E123, E124, E125, P003, P004, E121C, E122B, E124B, E137B, E138B, E121E, E139, E140, E141, E142, E143, E144, E145, E146, E147, E148, PUBSTAT_OVERVIEW, PUBSTAT_MI, PUBACCESS_EXCEL, PUBACCESS_DTA, PUBACCESS_LICENSE, E149, E150, E151, E152, E153

Preparation / proposed procedure:

1. After inputs, paths, and software are resolved, run SAS in batch with the verified SAS/CONNECT, SAS/STAT, and SAS/ACCESS PC Files capabilities from a host-visible directory and authorized WRDS access.
2. Confirm final export, all merge inputs and Jarr1 before Stata.
3. Run main Stata analysis and separate return-predictive-power branch without dropping authored stages.

Validation to perform later:

- Capture logs/outputs and compare sample counts, keys and tables with author documentation.


## Remaining issues and prerequisites

- I001 [unresolved; full_pipeline]: SAS exports p.final as final_new.dta under [redacted-path-5d2d967035bf], but Stata starts in [redacted-path-af3786afe81b] and loads final; a later branch also loads Jarr1. No supplied handoff or Jarr1 producer/schema is established.
- I002 [unresolved; full_pipeline]: Four named SAS includes are absent: eps_US.sas, Compustat_global_NAm_with_IBES_ticker.sas, EarnMgmt.sas and winsor.sas. Their executable definitions are needed for closure.
- I003 [unresolved; full_pipeline]: Absent include code leaves the exact EPS, CompFinal/GvkeyTicker, EarnMgmt/dafull and winsor output contracts unresolved.
- I004 [unresolved; full_pipeline]: SAS hard-codes D:, C: and F: roots; later code references A/N/T/SHARE without visible local assignments, G is declared only inside Rsubmit, and &dp is undefined. Host-visible directories and producer/consumer paths are unresolved.
- I005 [unresolved; full_pipeline]: A.FYR and A.CTRYRET are consumed to attach firm location and country returns, but no producer, assigned A library or complete field/history contract is visible.
- I006 [unresolved; full_pipeline]: P.IBESCTRY, N.IBESCTRY, P.GOVERN, G.GOVERN, T.EFW and A.ISO_IDCTRY/A.WGI are used without a matching visible producer/library contract; similarly named WORK tables do not establish those aliases. The P.TRAITS_MISSADJ table also has no visible producer in the supplied source.
- I007 [unresolved; full_pipeline]: Stata merges headqctry_traits, govern, PCREV_firm, prc_revdate, PCREV, Jacksonroe and secreg, but the supplied sources do not show compatible DTA producers for these exact inputs.
- I008 [unresolved; full_pipeline]: Stata concatenates year into headqctry before merges keyed by separate headqctry and year; intended prepared key contract needs confirmation.
- I009 [unresolved; full_pipeline]: The active `by ticker: keep if _n==1` reduces JAR2 to one row per ticker before later regressions; the adjacent SampleTicker lines are commented. Whether this filter is analytic or diagnostic is unresolved.
- I010 [preparation; full_pipeline]: Stata creates y twice without dropping or renaming the first y; the second gen is a concrete name collision.
- I011 [unresolved; full_pipeline]: Stata uses bare opt_accu6/3 assignments. SAS creates and winsorizes those fields before export, so the intended treatment cannot be safely changed to gen/replace without confirming whether to retain or recompute the values.
- I012 [unresolved; full_pipeline]: Appendix A4 Panel A describes a non-US analyst sample, while supplied code filters on headquarter country `headqctry != "NA"` (non-US firms per its comment). Confirm the intended A4 sample interpretation.
- I013 [unresolved; full_pipeline]: A4 Panel B describes analyst-country-year averages while supplied code collapses by firm, year, headquarter country and analyst location. The intended unit needs confirmation.
- R01 [undetermined]: Full author-prepared Final_location analyst-year history required by SAS sample construction and the move-event branch.
- R02 [undetermined]: Main Stata data file named final.dta and the fields required by Stata merges/analyses.
- R03 [undetermined]: Distinct Jarr1 input used by the WGI-preparation and Stata return-predictive-power branches.
- R04 [undetermined]: I/B/E/S normalized target-price detail NPTGDET used for target-price forecasts from 2002 onward.
- R05 [undetermined]: I/B/E/S RECDDET recommendation detail used in recommendation histories and analyst characteristics.
- R08 [undetermined]: IBES EPS forecast/actual dataset `ibes` consumed after the absent eps_US.sas macro.
- R09 [undetermined]: I/B/E/S unadjusted target-price detail NPTGDETU used from 1995 in the later return branch.
- R10 [undetermined]: Compustat Global annual fundamentals used by the missing Compustat macro to prepare CompFinal.
- R11 [undetermined]: Compustat North America annual fundamentals jointly used by the missing Compustat macro.
- R12 [undetermined]: Compustat-to-I/B/E/S ticker/security mapping GVKEYTICKER used to attach GVKEY and IID.
- R13 [undetermined]: CompFinal annual Compustat dataset consumed by subsequent SAS construction.
- R14 [undetermined]: Compustat Global daily security price product G_SEC_DPRC used to prepare return windows.
- R16 [undetermined]: Compustat Global daily return-factor product G_SEC_DTRT used for split/dividend adjustment.
- R18 [undetermined]: Compustat fiscal-year location mapping A.FYR for daily-return country joins.
- R19 [undetermined]: Country daily return table A.CTRYRET for country-adjusted stock returns.
- R23 [undetermined]: I/B/E/S ACTPSUMU_XEPSUS product used for actuals, monthly prices or shares outstanding.
- R24 [undetermined]: I/B/E/S ACTPSUMU_XEPSINT product used for actuals, monthly prices or shares outstanding.
- R25 [undetermined]: I/B/E/S ACTPSUMU_EPSUS product used for actuals, monthly prices or shares outstanding.
- R26 [undetermined]: I/B/E/S ACTPSUMU_EPSINT product used for actuals, monthly prices or shares outstanding.
- R27 [undetermined]: Top-broker name crosswalk used to classify the top 35 brokers.
- R28 [undetermined]: I/B/E/S country-code CSV used to map country names and identifiers.
- R29 [undetermined]: La Porta country-traits CSV used in governance construction.
- R30 [undetermined]: Shleifer self-dealing workbook joined with La Porta country traits.
- R31 [undetermined]: Prepared P.CULTURE dataset used for IDV country assignment.
- R32 [undetermined]: Prepared P.GOVERNRAW dataset used for country governance/enforcement traits.
- R33 [undetermined]: US Portfolio Holdings of Foreign Securities.xls required by the SAS country-data stage.
- R34 [undetermined]: Marketcap by country.xls required by the SAS country-data stage.
- R35 [undetermined]: world_stock_market_capitalization.xls required by the SAS country-data stage.
- R36 [undetermined]: Lionshares_IO_county_level_data_4Jun07.xls required by the SAS country-data stage.
- R37 [undetermined]: EFWdataset2012.xls required by the SAS country-data stage.
- R38 [undetermined]: World Bank WGI workbook used to create analyst and headquarter country-year governance ranks.
- R39 [undetermined]: ISO-to-I/B/E/S analyst-country map A.ISO_IDCTRY used in WGI joins.
- R40 [undetermined]: wgi_rank.dta required by Stata. analyst_loc/year WGI ranks; SAS export path differs from Stata cwd.
- R41 [undetermined]: pc.dta required by Stata. analyst_loc/year principal components; SAS export path differs from Stata cwd.
- R42 [undetermined]: wgi_headqctry.dta required by Stata. headqctry/year WGI measures; SAS export path differs from Stata cwd.
- R43 [undetermined]: headqctry_traits.dta required by Stata. Headquarter-country/year traits; no producer is visible.
- R44 [undetermined]: pc_firm.dta required by Stata. Headquarter-country/year principal components; SAS export path differs from Stata cwd.
- R45 [undetermined]: govern.dta required by Stata. Analyst-country governance fields; no compatible DTA export is visible.
- R46 [undetermined]: PCREV_firm.dta required by Stata. Firm-country/year PCREV data; no producer visible in supplied sources.
- R47 [undetermined]: prc_revdate.dta required by Stata. Revision-date price fields; no producer visible in supplied sources.
- R48 [undetermined]: PCREV.dta required by Stata. Analyst-country/year PCREV data; no producer visible in supplied sources.
- R49 [undetermined]: Jacksonroe.dta required by Stata. Jackson-Roe enforcement data; no producer visible in supplied sources.
- R50 [undetermined]: secreg.dta required by Stata. Securities-regulation data; no producer visible in supplied sources.
- SW01 [unverified]: The supplied SAS program uses Base SAS data/SQL procedures, SAS/CONNECT for the WRDS session, and SAS/STAT procedures PROC REG, MI, PRINCOMP, SURVEYSELECT, and GLM. A bounded startup probe failed to initialize TKELS; SAS/CONNECT, SAS/STAT, runtime/license availability, and WRDS session configuration remain unverified.
- SW07 [unverified]: The supplied SAS source imports workbooks with DBMS=EXCEL2000 (lines 1540, 1586, 1605, 1634, and 1681), DBMS=XLS (line 1723), and DBMS=XLSX (line 1784), exports XLSX, and exports Stata .dta outputs with DBMS=STATA. The official SAS/ACCESS 9.4 reference documents XLS/XLSX PROC import/export and Stata DTA import/export (DBMS=DTA). Availability and target-host compatibility of the source-used identifiers remain unverified; no Microsoft Excel or PC Files Server prerequisite is inferred.

## Review notes

- The release supplies substantive SAS preparation and Stata analysis code plus a ticker identifier list. SampleTicker.dta contains only ticker and is not a full analysis panel.
- Only full_pipeline is assessed; a compatible complete Stata analysis input route is not supplied or verified, so analysis_only is unsupported.
- Full Final_location analyst-year history is required. The packaged one-third latest-year sample does not cover the annual location-change joins.
- The 2005 confidential broker-translation history is not made a separate live input because the supplied code consumes prepared Final_location; current WRDS entitlement remains unknown for products actually read.
- SAS price construction filters 2000–2013 and builds return histories up to 365 days before and 182 days after target-price dates; check required construction history from actual operations.
- All local data probes are bounded one-row reads and establish only listed columns/readability. The retained path-error record explicitly has null hashes for four files removed before their hashes were captured.
- Stata 18 ignores set mem with return code zero in an empty-session self-written probe; no set mem edit is proposed.
- No author code/regression, installation, dataset download or applied edit was run. The duplicate Stata y declaration is proposed as a one-line source edit; opt_accu treatment remains unresolved.
- Appendix A1 and A3 remain contextual: the supplied files do not claim separate executable branches for those descriptions. Appendix A4 sample and aggregation differences remain specific clarification items.
- SAS capability scope includes Base SAS, SAS/CONNECT, SAS/STAT (PROC REG, MI, PRINCOMP, SURVEYSELECT, GLM), and SAS/ACCESS Interface to PC Files for the supplied DBMS=EXCEL2000, XLS, XLSX, DTA, and STATA routes. Availability and target-host compatibility remain unverified. The 9.4 reference documents DBMS=DTA for Stata; the source’s DBMS=STATA spelling is retained for a bounded compatibility check, without inferring an absent license or an Excel/PC Files Server prerequisite.
