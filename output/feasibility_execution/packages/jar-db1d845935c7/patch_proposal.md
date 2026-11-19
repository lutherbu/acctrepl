# Patch proposal: jar-db1d845935c7

Corporate Tax Enforcement Externalities and the Banking Sector

DOI: 10.1111/1475-679X.12334

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author data-preparation workflow: the ordered SAS build and every supplied Part I, main-sample, IRSRRA/Diff-in-Diff, cross-sectional, CRA, Dealscan, and appendix-data-preparation branch in the Stata source. This targets inputs used for the analyses; the package does not contain a complete regression/table driver.

Entry points: `00_build.sas`, `GJ Data Generation September 2020.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 5/12334 - Corporate-Tax-Enforcement-Externalities-and-the-Banking-Sector/gj-datasheet-code-and-identifiers.zip",
      "sha256": "620f7834a1b736a289d16b0d16309e8eb69d62fb40a926c16a960dd61e7e80dd"
    },
    {
      "path": "JAR-Volume 58/Issue 5/12334 - Corporate-Tax-Enforcement-Externalities-and-the-Banking-Sector/gj-online-appendix.pdf",
      "sha256": "e5dd6fcf46b27c4e1da0c8d31fd91e09d7c6cf5bf4c5409fdf8436d1d5d11556"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "949143758817b4b4c6b1a834f18df3c937c7db50f1ccd40cc13e11fa34a4f3a2"
}
```

## Proposed actions

### A_CALLREPORT: Obtain the author-stated Chicago Fed/FFIEC Call Report vintages for 1985–2015 and reconcile each field selected in 01_callreport.sas across pre/post-2011 formats.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: CALLREPORT
Evidence: EV_CALLREPORT_PUBLIC, EV_CALLREPORT_INPUT

Preparation / proposed procedure:

1. Retain the Chicago Fed complete files and FFIEC PDD vintages as separate source versions.
2. Map native item names and reporting periods to the exact RSSD/date and call-report fields selected by the source.
3. Preserve prior periods required by the code’s lag and moving-window calculations.

Validation to perform later:

- Check key uniqueness by RSSD/date and field coverage for every year 1985–2015 before SAS preparation.

### A_SOD: Acquire the official historical and current FDIC SOD files for 1990–2005 and map the native schema to the SAS branch inputs.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: BRANCH_SOD
Evidence: EV_SOD_PUBLIC, EV_SOD_ARCHIVE_PUBLIC, EV_BRANCH_INPUT

Preparation / proposed procedure:

1. Use the 1987–1993 archive for the early years and annual SOD downloads for 1994–2005.
2. Confirm institution/branch IDs, state/county, branch deposits and domestic-deposit denominators across the file-layout break.
3. Keep the separate Stata branch-history file requirement open for its acquired/established dates and asset fields.

Validation to perform later:

- Check required native fields and unique branch/year keys across the selected annual files; compare totals before SAS construction.

### A_BRANCH_STATA_HISTORY: Request the exact author-prepared branch.dta and its source/version notes, including the SIMS acquisition/establishment and asset fields.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: BRANCH_STATA_HISTORY
Evidence: EV_STATA_BRANCH_INPUT

Preparation / proposed procedure:

1. Obtain the file or a precise specification and producer for its branch/year, bank, county, deposits, asset and SIMS date fields.
2. Keep this input separate from standard SOD until the fields and identifiers are reconciled.

Validation to perform later:

- Check required variable names/types, RSSD/branch/county keys and coverage for 1990–2000 before later branch calculations.

### A_TED: Retrieve the historical FRED TEDRATE series in the author’s date/value form after confirming the supported file export and needed date coverage.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: TED_RATE
Evidence: EV_TEDRATE_PUBLIC, EV_TED_INPUT

Preparation / proposed procedure:

1. Use the TEDRATE series itself; it is discontinued but the historical observations remain the stated target.
2. Prepare the two-column no-header Excel input expected by PROC IMPORT without changing date/value units.

Validation to perform later:

- Check daily observations cover the author sample and compute nonmissing quarter counts before making the SAS summary.

### A_HPI: Acquire FHFA state quarterly purchase-only indexes in seasonally adjusted and unadjusted forms, then verify current-file history before preparing the SAS input table.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: FHFA_HPI
Evidence: EV_HPI_PUBLIC, EV_HPI_INPUT

Preparation / proposed procedure:

1. Use the current FHFA state purchase-only files; do not substitute the distinct all-transactions or expanded-data products.
2. Map state, year, quarter, index_sa and index_nsa to the SAS input table.
3. Confirm the current downloaded range and retain the source’s actual early-edge missingness when the code forms 1- and 4-quarter lags; do not impose an independent input start year or complete-lag screen.

Validation to perform later:

- Check state/year/quarter keys, the current file’s actual start year and lag availability by state before calculating changes.
- Confirm early missing lag values remain as produced by the author code rather than excluding observations solely to force complete lag history.

### A_BLS_STATE: Acquire BLS monthly state unemployment series in both SA and NSA forms and prepare the author’s state/date input tables while preserving the code’s lag windows.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: BLS_UNEMPLOYMENT
Evidence: EV_BLS_PUBLIC, EV_UNEMP_INPUT

Preparation / proposed procedure:

1. Use the public monthly state SA and NSA series; BLS documents observations from 1976 to present.
2. Map the rate, state and month fields to the SAS input table and retain source rows needed to compute 3- and 12-month lags before quarter-end screening.
3. Treat the later 1990–2005 combined-bank filter as a downstream screen; do not use it to invent a separate macro-source start requirement.

Validation to perform later:

- Check state/date merge keys and the 3- and 12-month lag windows before quarterly screening.
- Review early-period missingness as produced by the source/code; do not require a complete 1984+ series.

### A_COUNTY_LABOR: Identify the exact annual construction used for lf_all3.dta; BLS county LAUS is a public candidate but does not establish the author’s annual file version.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: COUNTY_LABOR
Evidence: EV_BLS_PUBLIC, EV_COUNTY_LABOR_INPUT

Preparation / proposed procedure:

1. Confirm whether the file uses annual averages or a specified month from county monthly labor-force data.
2. Map FIPS, year, Labor_Force and Unemployed and retain 1990–2000.

Validation to perform later:

- Check county/year keys and reproduce the annual convention against an author-provided file description.

### A_COUNTY_HPI: Request the source, construction and exact file specification for HPI_fips.dta; do not substitute the SAS state HPI table.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: COUNTY_HPI
Evidence: EV_COUNTY_HPI_INPUT

Preparation / proposed procedure:

1. Confirm the county index definition, 1990 base, annual change formula, geography crosswalk and covered years.
2. Obtain the exact author-prepared file or its documented producer.

Validation to perform later:

- Check fips/year keys and variables annualchange and hpiwith1990base before district aggregation.

### A_STATA_FIPS_DIST: Request the exact fips_dist.dta crosswalk, source/version and key definitions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: STATA_FIPS_DIST
Evidence: EV_FIPS_DIST_INPUT

Preparation / proposed procedure:

1. Confirm county FIPS-to-IRS-district mapping and spelling conventions used in Stata.
2. Do not treat collect.idfips or zip_fips_dist as the same file without evidence.

Validation to perform later:

- Check county key uniqueness, complete coverage and district labels before Stata merges.

### A_STATE_GDP: Request the original quarterly and annual state real-GDP source files and vintage used by the authors, especially for the pre-2005 quarterly years.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: STATE_GDP
Evidence: EV_BEAGDP_PUBLIC, EV_GDP_INPUT

Preparation / proposed procedure:

1. Confirm the exact product, table IDs, real-GDP definition, date fields, state identifiers and coverage.
2. Keep current BEA annual/quarterly series as candidates only until legacy coverage matches.

Validation to perform later:

- Check year/quarter coverage and the SAS merge keys for the full 1990–2005 panel.

### A_TRAC_SAS: Obtain the authors’ TRAC subscription aggregate district table or an exact permitted product specification.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: IRS_TRAC_AUDITS
Evidence: EV_SUBSCRIPTION, EV_IRS_INPUT

Preparation / proposed procedure:

1. Request only the aggregate audit table needed by SAS, its years, district/class coding and native fields.
2. Do not infer confidential IRS return-facility access from TRAC’s subscription status.

Validation to perform later:

- Check district/year/code keys and fields aud, ret, hrs, tax and aun against 03_irs.sas.

### A_TRAC_STATA: Obtain the separate author-used TRAC CSV and exact size-band definitions/source metadata.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: IRS_TRAC_STATA_CSV
Evidence: EV_SUBSCRIPTION, EV_STATA_TRAC_CSV_INPUT

Preparation / proposed procedure:

1. Request the FY 1992–2000 aggregate CSV or a precise authorized delivery path and its return-size bins.
2. Keep this separate from the SAS table until keys and construction are shown to match.

Validation to perform later:

- Check CSV columns, district/year/class keys and denominators before building audit_rates_per_class.

### A_IRS_CROSSWALK: Request the author-prepared collect.idfips SAS table or its precise county/FIPS-to-IRS-district source and version.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: IRS_DISTRICT_CROSSWALK
Evidence: EV_IRS_INPUT, EV_BRANCH_INPUT

Preparation / proposed procedure:

1. Confirm exact FIPS, county name and district columns and the Pacific Northwest spelling convention.
2. Keep this SAS input distinct from Stata fips_dist.dta until compatibility is evidenced.

Validation to perform later:

- Check county key uniqueness and full lookup coverage before SAS IRS and branch joins.

### A_COMPUSAT: Use the readable local Compustat tables only after their vintage, field history and 1989–2001 firm coverage are confirmed.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: COMPUSAT
Evidence: EV_COMP_FUND_PROBE, EV_COMP_COMPANY_PROBE, EV_STATA_COMP_INPUT

Preparation / proposed procedure:

1. Use COMP.FUNDA and COMP.COMPANY as candidate native sources joined by gvkey; preserve annual datadate/fyear and firm identifiers.
2. Confirm the relationship of annual historical sich to the code’s sic fields; do not replace historical industry codes with current values without author support.
3. Request the exact author extract/specification if the local tables do not match the expected firm history.

Validation to perform later:

- Check 1989–2001 date/key coverage and all referenced variables before Stata preparation; one-row probes alone are insufficient.

### A_SEC_HEADERS: Verify a bounded CIK/year sample and coverage in the documented SEC corpus or request the exact author-prepared 10-K_Headers.dta.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: SEC_10K_HEADERS
Evidence: EV_SEC_PUBLIC, EV_STATA_HEADER_INPUT

Preparation / proposed procedure:

1. Identify the relevant CIKs and 1989–2001 filing years before any bounded local corpus query.
2. Confirm how business-address ZIP (ba_zip5) is chosen, normalized and carried forward across missing years.

Validation to perform later:

- Check CIK/fyear uniqueness, business-address ZIP extraction and all required years before Stata merges.

### A_STATE_TAX: Request the exact State_Tax_Rates input or its source/version and state-year tax-rate definition.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: STATE_TAX_RATES
Evidence: EV_SOURCES, EV_MAIN_OUTPUT

Preparation / proposed procedure:

1. Confirm the Heider–Ljungqvist (2015) file, included states/years, variable names and merge keys.
2. Do not construct a substitute state-tax series without the author’s specification.

Validation to perform later:

- Check unique state/year keys and merge retention before writing final_for_regression.dta.

### A_DEALSCAN: Validate the accessible local Dealscan tables against the author’s required 1990–2005 facility/lender history before using them.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: DEALSCAN_TABLES
Evidence: EV_DEALSCAN_COMPANY_PROBE, EV_DEALSCAN_FACILITY_PROBE, EV_DEALSCAN_LENDERSHARES_PROBE, EV_DEALSCAN_OFFSET_ERRORS, EV_DEALSCAN_INPUT

Preparation / proposed procedure:

1. Preserve the native CompanyID/FacilityID and lender-share fields and source table identity.
2. Confirm the complete FacilityStartDate period and any author vintage restrictions; the bounded samples establish column readability only.
3. Do not substitute a generic Dealscan–GVKEY link for the separately required RSSD links.

Validation to perform later:

- Check each required year, role/allocation fields and company/facility/lender identifiers before running the SAS construction at a later authorized step.

### A_JANKEIL: Acquire the separate Jan Keil lender and ultimate-parent RSSD CSV link files from the author page.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: JANKEIL_DEALSCAN_RSSD_LINK
Evidence: EV_JANKEIL_PUBLIC, EV_LINK_INPUT

Preparation / proposed procedure:

1. Use the lender and ultimate-parent CSVs matching the SAS input tables.
2. Retain RSSD, companyid/ultimateparentid, year and the FDIC/FED flag.

Validation to perform later:

- Check link-key types and year coverage against Dealscan IDs before building SAS link outputs.

### A_ZIP_FIPS: Request the exact ZIP-to-FIPS/IRS-district crosswalk used in the Stata firm-information and information-environment branches.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ZIP_FIPS_DIST
Evidence: EV_STATA_ZIP_FIPS_INPUT

Preparation / proposed procedure:

1. Confirm source, county/ZIP vintage, mapping rules and duplicate policy for zip_fips_dist.dta.

Validation to perform later:

- Check ZIP key coverage and uniqueness for the author CIK/firm records before merge.

### A_ZIP_STATE: Request the separate author-prepared zip_state.dta source/version and state mapping rule.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ZIP_STATE
Evidence: EV_STATA_ZIP_STATE_INPUT

Preparation / proposed procedure:

1. Keep this file distinct from zip_fips_dist.dta; confirm ZIP, state and any multi-state ZIP handling.

Validation to perform later:

- Check ZIP key coverage and state codes before the Stata merge.

### A_AUDIT_PROB: Request the exact irs_audit_prob.dta source, producer and field definitions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: IRS_AUDIT_PROBABILITY
Evidence: EV_STATA_AUDIT_INPUT

Preparation / proposed procedure:

1. Confirm district/year keys and the construction of perc_audited_main/other and related probability measures.
2. Do not assume the separately read TRAC CSV produces this file.

Validation to perform later:

- Check district/year uniqueness and merge keys before deposit-share construction.

### A_SIZE_AUDITS: Request the exact irs_audit_prob_size.dta source and size-class definitions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: IRS_SIZE_CLASS_AUDITS
Evidence: EV_STATA_AUDIT_INPUT

Preparation / proposed procedure:

1. Confirm irsdist/code/year keys, size bin thresholds and variable definitions.
2. Keep it distinct from the TRAC raw aggregate and post-2000 corporate audit table.

Validation to perform later:

- Check key uniqueness and match rate before the information-environment merge.

### A_POST2000_AUDITS: Request the exact corp_audits_post_2000.dta source and code/year variable definitions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: CORP_AUDITS_POST2000
Evidence: EV_STATA_AUDIT_INPUT

Preparation / proposed procedure:

1. Confirm coverage after 2000, return-code definitions and any relation to the TRAC source.

Validation to perform later:

- Check code/year key uniqueness and periods before merging.

### A_CRA_FILES: Acquire and extract FFIEC CRA transmittal and disclosure flat files for 1996–2003 using their year-specific file specifications.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: CRA_RAW_FILES
Evidence: EV_FFIEC_CRA_PUBLIC, EV_CRA_BRANCH

Preparation / proposed procedure:

1. Retain the 1996–2003 annual files and specs; keep each year’s raw layout separate for the author parser.
2. Place files in CRA-Data or map the project path consistently with the Stata current-directory change.

Validation to perform later:

- Check the respondent file, per-year disclosure layout, record lengths and parsed field counts before later authorized Stata execution.

### A_CRA_MATCH: Request rssd_matched and its respondent/RSSD/headquarters-district source, key definitions and producer.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: CRA_RSSD_MATCH
Evidence: EV_STATA_RSSD_MATCH_INPUT

Preparation / proposed procedure:

1. Obtain the exact match table and define respondent/RSSD/irsdist_hq fields.
2. Do not treat the code-generated rssd_respondentid as this separate table.

Validation to perform later:

- Check RSSD uniqueness and respondent/year match rate before CRA district calculations.

### A_ALSTON: Request the exact source and field/key specification for collect.alst_cross_states.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ALSTON_REGULATORY_LENIENCY
Evidence: EV_ALSTON_INPUT

Preparation / proposed procedure:

1. Confirm the referenced Alston cross-state measure, state/year identifiers and version.
2. Obtain the author-prepared table or an exact documented producer rather than inferring a proxy.

Validation to perform later:

- Check unique state/year keys and coverage before 20_combine.sas.

### A_GGM_FLY: Request the exact fly_nb_lrc3.xlsx author/coauthor input, worksheet and included years.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: GGM_FLY_DATA
Evidence: EV_STATA_GGM_FLY_INPUT

Preparation / proposed procedure:

1. Confirm fyear_change, len and ta columns and how missing/year values are coded.

Validation to perform later:

- Check worksheet headers, year/firm key and coverage before Stata transformation.

### A_GGM_NB: Request the exact ggm_nb.dta file and lender_g construction/version.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: GGM_NB_DATA
Evidence: EV_STATA_GGM_NB_INPUT

Preparation / proposed procedure:

1. Confirm GVKEY/lender identifiers and bank sample coverage.

Validation to perform later:

- Check uniqueness and key types before merging the GGM linking table.

### A_GGM_LINK: Request the separate linking.dta file and its GVKEY/RSSD relationship, vintage and duplicate handling.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: GGM_LINKING_DATA
Evidence: EV_STATA_GGM_LINK_INPUT

Preparation / proposed procedure:

1. Confirm the exact prepared link table; do not substitute Jan Keil’s Dealscan RSSD links.

Validation to perform later:

- Check GVKEY/RSSD keys and coverage before joining the GGM bank list.

### A_CRA_MATCH_ISSUE: Resolve the remaining unverified author-prepared inputs by obtaining a precise file inventory, source/version, field definitions and coverage for each requirement.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: UNRESOLVED_EXTERNAL_INPUTS
Evidence: EV_TRACE, EV_RSSD_LIST

Preparation / proposed procedure:

1. Use the requirement-specific actions for exact files and product routes; prioritize inputs with no producer: county HPI, crosswalks, tax rates, audit-probability tables, CRA match, Alston table and GGM inputs.
2. Treat the packaged RSSD file as an identifier list only, not a panel.

Validation to perform later:

- For each input, verify native fields, keys, time history and producer before marking any route verified.

### A_MACRO: Request the missing 99_macros.sas file or the exact original categoryvar definition and output contract.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: CATEGORYVAR_MACRO
Evidence: EV_SAS_INCLUDES, EV_MISSING_MACRO

Preparation / proposed procedure:

1. Confirm the intended include path and full macro body from the authors.
2. Do not guess category mappings or replace category IDs with a new implementation.

Validation to perform later:

- Check the macro creates stateid, dateid and stateyearid consistently with downstream SAS code.

### A_HANDOFF: Transfer the generated SAS library members to the DTA paths consumed by Stata using a standard, format-compatible converter after confirming support for the actual SAS file flavor. This is a file-format step, not a missing scientific producer, and it does not require the authors’ original export script.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: SAS_TO_STATA_HANDOFF
Evidence: EV_SAS_FINAL_OUTPUT, EV_BRANCH_OUTPUT, EV_DEALSCAN_OUTPUT, EV_STATA_DATASET, EV_STATA_DISTRICT_SHARE_INPUT, EV_SAS_DEALSCAN_MIXED_SCHEMA, EV_STATA_DEALSCAN_MIXED_INPUT, EV_STATA_DEALSCAN_LINK_INPUT, EV_DEALSCAN_COMPANY_PROBE

Preparation / proposed procedure:

1. Transfer build.final to final.dta, build.district_share to district_share.dta, build.dealscan_mixed to dealscan_mixed.dta, and build.link_lenderid/build.link_parentid to their matching Stata DTA paths.
2. Preserve source storage types, character identifiers and leading zeros, numeric/date units, labels and native field names; do not coerce identifiers or rescale dates during format transfer.
3. For district_share, retain SAS rssdid; Stata references rssd as a unique-prefix candidate, so verify it is unambiguous instead of renaming by assumption.
4. Read the actual generated/transferred mixed-Dealscan header before any alias decision. The local Company probe has native UltimateParentID, and the SAS source’s lower-case lexical token alone does not establish output metadata case.
5. Verify the parent-link table retains the lower-case field that Stata reads and then explicitly renames before merging.

Validation to perform later:

- Confirm each named SAS library member exists and is readable by the selected standard converter before transfer.
- Compare source/DTA row counts and key distributions; verify RSSD/lender/year keys, dates, types, IDs with leading zeros and actual header names.
- Check all Stata consumer references against transferred headers; do not apply a blanket global case conversion or create a variable absent from the SAS member.

### A_STATA_CMD: Resolve the missing standalone rssdid command before the deposit-share branch is attempted.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: Stata_rssdid, STATA_RUNTIME_ADDONS
Evidence: EV_STATA_RSSDID, EV_SW_RSSDID

Preparation / proposed procedure:

1. Request the intended ado/source or author explanation for `rssdid rssd`; the exact command is absent in Stata 18.
2. If the authors identify a package, verify the exact command entry point and documented setup in an authorized later step.

Validation to perform later:

- Confirm the command’s documented output and compare it with downstream use of input_share_deposits.dta; do not replace it with an assumed egen/id command.

### A_SAS_COMPONENTS: Verify the configured SAS runtime and components needed by the supplied build.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SAS
Evidence: EV_ENV, EV_SAS_ORDER

Preparation / proposed procedure:

1. After the SAS installation/session is configured, verify license entitlement and PROC EXPAND availability.
2. Verify PROC IMPORT DBMS=XLS engine support; do not infer failure from an empty-session TKELS initialization.

Validation to perform later:

- Record SAS version and verify PROC EXPAND and DBMS=XLS component availability without running study programs.

### A_PATHS: Map the authored Windows roots to a readable, writable project root and make current-directory/output handling consistent across SAS and Stata branches.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: HOST_PATHS
Evidence: EV_SAS_ORDER, EV_STATA_DATASET, EV_CRA_BRANCH

Preparation / proposed procedure:

1. Set the project/data/results root consistently for all SAS includes and Stata paths.
2. Keep CRA-Data inputs and relative outputs together after the explicit `cd`; reconcile capitalization variants before execution.
3. Verify the required output folders are writable and source paths readable.

Validation to perform later:

- Resolve every path and working directory for the full branch list before executing author programs.

### A_DEALSCAN_BEST_MATCH: Confirm the native crosswalk source and definition for the best_match field used by Stata duplicate filters.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: DEALSCAN_BEST_MATCH_FIELD
Evidence: EV_JANKEIL_PUBLIC, EV_JANKEIL_FIELDS, EV_SAS_DEALSCAN_LINK_PASSTHROUGH, EV_STATA_DEALSCAN_LINK_INPUT

Preparation / proposed procedure:

1. Confirm whether collect.rssd_lenderid and collect.rssd_ultimateparentid carry best_match and document its source, definition and values.
2. If the field is absent, obtain the exact author-prepared crosswalk or producer specification; do not manufacture a matching-score flag.
3. Keep this field check separate from the routine SAS-to-DTA format transfer and from the Jan Keil/Dealscan-GVKEY distinction.

Validation to perform later:

- Verify best_match exists in both transferred link datasets with the documented meaning before Stata uses it to filter duplicate lender/parent rows.


## Remaining issues and prerequisites

- CATEGORYVAR_MACRO [unresolved; full_pipeline]: 00_build explicitly includes 99_macros.sas, which is absent from the frozen package inventory. Cross-file review found active %categoryvar calls in 01_callreport.sas and no definition in any supplied SAS source. The required category mapping/ID algorithm cannot be restored from call sites alone.
- SAS_TO_STATA_HANDOFF [preparation; full_pipeline]: The supplied SAS stages produce build.final, build.district_share, build.dealscan_mixed, build.link_lenderid and build.link_parentid; Stata reads their corresponding DTA paths. A standard SAS7BDAT-to-DTA format transfer is the remaining preparation step, not a missing scientific producer. Validate the actual generated/transferred headers against Stata consumers, preserving storage types, identifiers, dates and field names. The native Dealscan company probe contains UltimateParentID, matching the Stata parent field; SAS source spelling alone does not establish physical output case. The separate best_match field producer is tracked as its own unresolved issue.
- UNRESOLVED_EXTERNAL_INPUTS [unresolved; full_pipeline]: The supplied branches require distinct public, subscription and author-prepared inputs. Probes verify only a unique RSSD identifier list and bounded rows from local Compustat/Dealscan tables; they do not establish full history or the numerous missing crosswalk, audit, tax, CRA match, GGM and county-prepared inputs. Identified public products are recorded separately from unresolved schemas/coverage.
- STATA_RUNTIME_ADDONS [unresolved; full_pipeline]: Exact Stata 18 checks find winsor and ffind, while rssdid is absent (return code 111). The source invokes standalone rssdid rssd and supplies no command definition or installation instructions, so its intended function and corrective setup remain unresolved.
- HOST_PATHS [preparation; full_pipeline]: The SAS driver hard-codes Windows drive roots; Stata hard-codes multiple Dropbox/Desktop paths with capitalization variants and changes into CRA-Data before writing relative outputs. A host-visible, writable project-root mapping and consistent current directories are required.
- DEALSCAN_BEST_MATCH_FIELD [unresolved; full_pipeline]: The Stata Dealscan link branch uses best_match to filter lender and parent link rows, but the supplied SAS stage only passes collect.rssd_lenderid and collect.rssd_ultimateparentid through, drops rssd=0, and joins bank names; it does not construct best_match. The author-described Jan Keil CSV fields are companyid/RSSD and FDIC-FED flags, and no supplied source defines best_match. Confirm whether this field is carried by the author-prepared collect tables and obtain its definition/producer before using the Stata duplicate filters.
- CALLREPORT [undetermined]: Underlying bank Call Report data consumed as bank.comm, with the report identifiers and regulatory, balance-sheet, income, deposit, capital, loan-quality and audit fields selected by 01_callreport.sas. The author code filters 1985–2015 and constructs lags and rolling histories.
- BRANCH_SOD [undetermined]: Branch-level Summary of Deposits inputs used by SAS district-share/competition construction. The Stata branch cross-section is a separate prepared-file requirement.
- BRANCH_STATA_HISTORY [undetermined]: Separate author-prepared branch.dta used by Stata for 1990–2000 cross-sectional branch and entry analyses. The code uses deposits, bank/branch IDs, county, asset, and SIMS acquired/established-date fields; no supplied producer was found.
- TED_RATE [undetermined]: Daily TEDRATE spreadsheet imported without header names and aggregated into quarter-level descriptive statistics.
- FHFA_HPI [undetermined]: FHFA state purchase-only quarterly HPI series, seasonally adjusted and unadjusted, used with state/year/quarter keys and one- and four-quarter lag construction. The current file start year and edge missingness are not verified.
- BLS_UNEMPLOYMENT [public_acquisition_required]: State monthly unemployment-rate series in both seasonal forms, joined by state/date and transformed using 3- and 12-month lags before quarter-end screening. Required lag windows are distinct from an unsupported absolute input start year.
- COUNTY_LABOR [undetermined]: County labor-force and unemployment values in lf_all3.dta, keyed by FIPS/year for constructing IRS-district unemployment. This input is not the state BLS table above.
- COUNTY_HPI [undetermined]: Separate county-level HPI input HPI_fips.dta, merged to FIPS/year to construct IRS-district annual HPI change and 1990-base level; distinct from the SAS state purchase-only HPI.
- STATA_FIPS_DIST [undetermined]: County FIPS to IRS-district crosswalk fips_dist.dta used in the Stata county and CRA branches; kept distinct from SAS collect.idfips and ZIP mappings.
- STATE_GDP [undetermined]: State quarterly and annual real GDP growth inputs read by 02_macroecon.sas and merged into the bank panel.
- IRS_TRAC_AUDITS [undetermined]: TRAC aggregate district audit table collect.irs_audits_1992_2000_districts consumed by the SAS IRS stage to construct all-return and size-threshold audit measures. This is subscription aggregate material, not presumed confidential IRS facility data.
- IRS_TRAC_STATA_CSV [undetermined]: Separate TRAC aggregate CSV read by Stata as IRS District Audits, FY 1992 - 2000.csv for audit rates by class.
- IRS_DISTRICT_CROSSWALK [undetermined]: SAS collect.idfips county/FIPS-to-IRS-district crosswalk used in IRS and branch construction; not assumed to equal Stata fips_dist.dta.
- COMPUSAT [undetermined]: Compustat inputs for listed-firm district controls and information-environment preparation, including the supplied 1989–2001 construction and firm-history variables.
- SEC_10K_HEADERS [undetermined]: 10-K header/location input with CIK, fyear and business-address ZIP (ba_zip5) used to construct firm headquarters ZIP histories.
- STATE_TAX_RATES [undetermined]: State-year tax-rate table State_Tax_Rates merged into the main Stata sample; no producer is supplied.
- DEALSCAN_TABLES [undetermined]: Thomson Reuters/WRDS Dealscan Company, Facility and Lendershares tables used to construct term-loan/revolver summaries and lender allocations.
- JANKEIL_DEALSCAN_RSSD_LINK [public_acquisition_required]: Jan Keil Dealscan-to-RSSD lender ID and ultimate-parent ID links used by the SAS Dealscan stage; distinct from Dealscan-GVKEY linking data.
- ZIP_FIPS_DIST [undetermined]: ZIP-to-FIPS/IRS-district crosswalk zip_fips_dist.dta used in Stata Compustat and information-environment construction; distinct from fips_dist.dta.
- ZIP_STATE [undetermined]: Separate ZIP-to-state crosswalk zip_state.dta used to assign states to 10-K header/firm records.
- IRS_AUDIT_PROBABILITY [undetermined]: Prepared irs_audit_prob.dta merged with district-share data; no supplied source/preparation code produces the file.
- IRS_SIZE_CLASS_AUDITS [undetermined]: Prepared irs_audit_prob_size.dta merged by IRS district, return code and year in the information-environment branch; no supplied producer.
- CORP_AUDITS_POST2000 [undetermined]: Prepared corp_audits_post_2000.dta merged by return code and year; no producer or exact source is supplied.
- CRA_RAW_FILES [public_acquisition_required]: FFIEC CRA respondent transmittal and annual disclosure raw files parsed by the supplied CRA branch for 1996–2003.
- CRA_RSSD_MATCH [undetermined]: Separate rssd_matched respondent/RSSD/headquarters-district match file merged after the Stata branch builds respondent IDs; no producer is supplied.
- ALSTON_REGULATORY_LENIENCY [undetermined]: SAS collect.alst_cross_states regulatory-leniency input merged into the combined bank panel; source and native fields are not identified.
- GGM_FLY_DATA [undetermined]: Separate GGM TPI spreadsheet fly_nb_lrc3.xlsx, imported to construct bank-year avoidance status; distinct from the RSSD-DealScan crosswalk.
- GGM_NB_DATA [undetermined]: Separate GGM bank/lender file ggm_nb.dta used to identify lender GVKEYs for the TPI match.
- GGM_LINKING_DATA [undetermined]: Separate GGM linking.dta file merged by GVKEY to link the GGM bank list to RSSDs.
- SAS [unverified]: SAS 9.4 is required for the seven-program build, with active PROC EXPAND and PROC IMPORT DBMS=XLS usage. The frozen empty-session check did not initialize TKELS; entitlement and needed ETS/PC Files components remain unverified, not presumed unavailable.
- Stata_rssdid [unverified]: The exact standalone command rssdid is not found in Stata 18 (return code 111). No supplied definition or setup instructions identify its semantics; obtain the intended command/source before choosing a setup or code change.

## Review notes

- The assessment follows the two-entry complete supplied preparation workflow, including main, IRSRRA/Diff-in-Diff, branch/cross-sectional, CRA, Dealscan and TPI appendix-data stages. No compatible complete prebuilt analysis panel was verified, so no analysis_only scope is claimed.
- Public product routes, local candidates and subscription/author-prepared inputs are kept distinct. Route verification is withheld where native history, transformations, or authored files remain unverified; catalog misses and bounded samples are not treated as access denials or complete-coverage evidence.
- All 67 frozen dependency IDs have explicit dispositions. No author program, estimator or data download was executed; execution_verified remains false.
- Source QA removed an unsupported absolute macro-series start year, downgraded FHFA state purchase-only history to unverified while retaining the exact product route, and treated SAS-to-Stata conversion as preparation. The remaining handoff issue names only the specific field/case checks supported by source text.
- Follow-up source QA confirmed the local Dealscan Company probe reports native UltimateParentID. No case mismatch is asserted from SAS lexical spelling; validate the generated/transferred header. The specific best_match producer used by Stata remains unresolved.
