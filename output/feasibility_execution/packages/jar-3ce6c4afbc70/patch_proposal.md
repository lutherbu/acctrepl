# Patch proposal: jar-3ce6c4afbc70

Racial Disparities in Financial Complaints and the Role of Corporate Social Attitudes

DOI: 10.1111/1475-679X.12612

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |
| analysis_only | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow: Data_input.do preparation followed by T1_to_T6.do analysis, retaining all supplied branches and inter-file handoffs. Execution was not attempted.

Entry points: `data_input.do`, `t1_to_t6.do`

Dependency closure: unresolved; see the issues and actions below.

### analysis_only

Tables 1–6 analysis entry point using exact packaged prepared data where supplied, without running Data_input.do; retains the separate firmsize, company unemployment-adjusted panel, and restricted IDV gaps. Execution was not attempted.

Entry points: `t1_to_t6.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 4/12612 - Racial-Disparities-in-Financial-Complaints-and-the-Role-of-Corporate-Social-Attitudes/hjptdatasheetcodeandlogfiles.zip",
      "sha256": "d18f1995a9927cd9a4d3d2ba3301c805a2a2c4ac0dd13d5335ae7c6dba317eaf"
    },
    {
      "path": "JAR-Volume 63/Issue 4/12612 - Racial-Disparities-in-Financial-Complaints-and-the-Role-of-Corporate-Social-Attitudes/hjpt-online-appendix.pdf",
      "sha256": "2f5ddd7a1ffd5c4da8824d3a40b7d87152a1d2c7a0baa867af3b85886c2aac22"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "4d6c56434d2e7027baf5818ac98a8d72de0edba6afa55252d17dd04140cd583e"
}
```

## Proposed actions

### A_CENSUS_STAGE: Stage the packaged 2018 NHGIS raw CSV as the census.dta expected by the active preparation code.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_CENSUS_RAW, I_CENSUS_DTA_PRODUCER
Evidence: E_PKG_CENSUS_RAW, E_CENSUS_COMMENTED, E_CENSUS_READ

Preparation / proposed procedure:

1. In a working copy, import the packaged 2018 ZCTA CSV with its header and save census.dta before running Data_input.do.
2. Keep the source CSV unchanged and preserve all code-consumed NHGIS columns.

Validation to perform later:

- Confirm the staged DTA contains the exact consumed raw field set and that the subsequent ZIP3 output is written to the configured working data directory.

### A_ALIGN_DEPOSIT_FILENAME: Change the single deposit merge basename to match the earlier active writer.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_DEPOSIT_FILENAME
Evidence: E_SOD_AGG, E_DEPOSIT_CONSUMER

**Proposed edit:** `data_input.do:721–721`
Source SHA-256: `8d0fba11763637dfd369d53cb72b704513f65e2c6ffc9f6498376b565f815bd0`

Align the consumer basename with the exact generated product; zip3/year_deposit and deposit_zip3 match.

Current text:
```
merge n:1 zip3 year_deposit using deposit_zip3_2011to2022.dta
```

Proposed replacement:
```
merge n:1 zip3 year_deposit using deposit_zip3_20112022.dta
```

Preparation / proposed procedure:

1. Apply the one-line change in a working copy before running Data_input.do.

Validation to perform later:

- Confirm the producer and consumer share zip3 and year_deposit keys and deposit_zip3 payload.

### A_FIX_USE_OPTIONS: Replace the invalid use-option token at the eight identified use statements with clear.

Scopes: full_pipeline, analysis_only. Type: source_edit. Certainty: supported.
Addresses: I_USE_REPLACE_OPTION
Evidence: E_CENSUS_READ, E_HHI_READ, E_ANALYSIS_COMPANY, E_KLD_READ, E_BAD_USE_COMPANY_427, E_BAD_USE_KLD_435, E_BAD_USE_COMPANY_476, E_BOARD_READ, E_STATA_USE_MANUAL

**Proposed edit:** `data_input.do:106–106`
Source SHA-256: `8d0fba11763637dfd369d53cb72b704513f65e2c6ffc9f6498376b565f815bd0`

Stata use supports clear rather than replace.

Current text:
```
use census.dta, replace
```

Proposed replacement:
```
use census.dta, clear
```

**Proposed edit:** `t1_to_t6.do:359–359`
Source SHA-256: `203933c46d43bd59d2ee21eee4313d72513ee5f83e0eaef2bcc080f2dee768ee`

Stata use supports clear rather than replace.

Current text:
```
use "hhi_zip3.dta",replace
```

Proposed replacement:
```
use "hhi_zip3.dta",clear
```

**Proposed edit:** `t1_to_t6.do:384–384`
Source SHA-256: `203933c46d43bd59d2ee21eee4313d72513ee5f83e0eaef2bcc080f2dee768ee`

Stata use supports clear rather than replace.

Current text:
```
use "company_zip_month.dta",replace
```

Proposed replacement:
```
use "company_zip_month.dta",clear
```

**Proposed edit:** `t1_to_t6.do:389–389`
Source SHA-256: `203933c46d43bd59d2ee21eee4313d72513ee5f83e0eaef2bcc080f2dee768ee`

Stata use supports clear rather than replace.

Current text:
```
use "cfpb_gvkey_kld.dta",replace
```

Proposed replacement:
```
use "cfpb_gvkey_kld.dta",clear
```

**Proposed edit:** `t1_to_t6.do:427–427`
Source SHA-256: `203933c46d43bd59d2ee21eee4313d72513ee5f83e0eaef2bcc080f2dee768ee`

Stata use supports clear rather than replace.

Current text:
```
use "company_zip_month.dta",replace
```

Proposed replacement:
```
use "company_zip_month.dta",clear
```

**Proposed edit:** `t1_to_t6.do:435–435`
Source SHA-256: `203933c46d43bd59d2ee21eee4313d72513ee5f83e0eaef2bcc080f2dee768ee`

Stata use supports clear rather than replace.

Current text:
```
use "cfpb_gvkey_kld.dta",replace
```

Proposed replacement:
```
use "cfpb_gvkey_kld.dta",clear
```

**Proposed edit:** `t1_to_t6.do:476–476`
Source SHA-256: `203933c46d43bd59d2ee21eee4313d72513ee5f83e0eaef2bcc080f2dee768ee`

Stata use supports clear rather than replace.

Current text:
```
use "company_zip_month.dta",replace
```

Proposed replacement:
```
use "company_zip_month.dta",clear
```

**Proposed edit:** `t1_to_t6.do:481–481`
Source SHA-256: `203933c46d43bd59d2ee21eee4313d72513ee5f83e0eaef2bcc080f2dee768ee`

Stata use supports clear rather than replace.

Current text:
```
use "cfpb_gvkey_kld_hq_dir3.dta",replace
```

Proposed replacement:
```
use "cfpb_gvkey_kld_hq_dir3.dta",clear
```

Preparation / proposed procedure:

1. Apply only the exact option-token changes in a working copy; preserve every table branch and data operation.

Validation to perform later:

- Confirm each edited use statement matches the documented use syntax before attempting execution.

### A_PATH_SETUP: Configure the datapath macro and working directory in a local run configuration without publishing or copying the author-specific path.

Scopes: full_pipeline, analysis_only. Type: configuration. Certainty: supported.
Addresses: I_PATH_SETUP
Evidence: E_PATH_TOKEN

Preparation / proposed procedure:

1. Set datapath to the local working data directory.
2. Run each entry point from the configured working copy so relative inputs and outputs resolve together.

Validation to perform later:

- Resolve every merge/use input against the local data directory before running the supplied program.

### A_ACQUIRE_PUBLIC_RAW: Acquire and prepare author-named public inputs through the documented routes, confirming the FDIC candidate page exposes the specified annual SOD product before staging it.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_BLS_RAW, R_FDIC_SOD, R_JHU_COVID_RAW, R_CFPB_T2, R_CFPB_PRE, R_CFPB_PANEL
Evidence: E_BLS_LAUS_FORMAT, E_AUTHOR_FDIC, E_SOD_AGG, E_JHU_REPO, E_CFPB_FIELDS, E_AUTHOR_CFPB

Preparation / proposed procedure:

1. For BLS, stage the LAUS county series fields used by the code for 2018–2020.
2. For FDIC, check the listed official custom-download candidate and stage annual 2011–2022 branch files with year, state, branch ZIP, and deposits if the product is available there.
3. For CSSE, stage the US county confirmed-case time series through 2020-12-31; do not substitute an unrelated COVID measure.
4. For CFPB, stage the complaint fields and date windows already specified by the source code.

Validation to perform later:

- Check the consumed keys/fields and date windows at each source-to-Stata conversion; retain version/value validation for the documented CFPB ZIP update.

### A_CFPB_ZIP_VINTAGE: Ask whether the documented June 16, 2021 CFPB ZIP assignment must be preserved, or whether current post-2023 ZIP values are acceptable for exact reproduction.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_CFPB_ZIP_VINTAGE, R_CFPB_T2, R_CFPB_PRE, R_CFPB_PANEL
Evidence: E_AUTHOR_CFPB, E_CFPB_RELEASE, E_CFPB_PANEL_WINDOW, E_CFPB_ZIP3

Preparation / proposed procedure:

1. Request the author’s preferred source vintage or an authorized 2021 export if exact historical ZIP assignment is required.
2. If the current public dataset is accepted, record that ZIP values for historical complaints may reflect the later Census-based update.

Validation to perform later:

- Verify date, ZIP, product, company, state and complaint-ID fields and compare any available source-vintage documentation before accepting the panel.

### A_COUNTY_CROSSWALK_SPEC: Request the exact county-to-ZIP crosswalk source/vintage, fips/zip key format, res_ratio meaning, and uniqueness/coverage rule used by both transforms.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COUNTY_ZIP_LINK, I_COUNTY_ZIP_LINK
Evidence: E_COVID_CROSSWALK, E_BLS_CROSSWALK

Preparation / proposed procedure:

1. Obtain the crosswalk file or author specification for weights that allocate county cases, labor force, and unemployment to ZIP5/ZIP3.
2. Keep this mapping separate from the ZIP3-to-state display map.

Validation to perform later:

- Confirm the documented weight semantics and keys match both joins before building either transformed panel.

### A_CENSUS_RESIDUAL_SPEC: Request the source, annual construction, residual-adjustment definition and fields for censuspanel_zip3_residual.dta.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CENSUS_PANEL_RESIDUAL, I_CENSUS_PANEL_RESIDUAL
Evidence: E_CENSUS_PANEL_READ, E_CENSUS_PANEL_FIELDS

Preparation / proposed procedure:

1. Obtain a producer file or a precise author-supplied construction for zip3_num/year and the demographic/population fields consumed downstream.

Validation to perform later:

- Confirm its annual keys and field meanings before using it in the complaint panel.

### A_UNEMP_MONTHLY_SPEC: Request the producer/source and exact definition for unemployment_monthly.dta, including the monthly rate and one-month lag.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_UNEMP_MONTHLY, I_UNEMP_MONTHLY
Evidence: E_UNEMP_MONTHLY_READ, E_UNEMP_PANEL_FIELDS

Preparation / proposed procedure:

1. Obtain the monthly ZIP3 panel keyed by zip3/yearmonth and identify how unemploymentrate_zip3_l1m is constructed.

Validation to perform later:

- Confirm it is not substituted with the packaged lag1 field or the annual lag product.

### A_UNEMP_LAG1YR_SPEC: Request the producer/source and exact annual lag definition for unemployment_lag1yr.dta.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_UNEMP_LAG1YR, I_UNEMP_LAG1YR
Evidence: E_UNEMP_LAG1YR_READ, E_UNEMP_PANEL_FIELDS

Preparation / proposed procedure:

1. Obtain the ZIP3/year panel and identify the year/reference period behind unemploymentrate_zip3_l1yr.

Validation to perform later:

- Confirm the annual measure remains separate from monthly l1m and the packaged monthly unemployment panel.

### A_FIRMSIZE_SPEC: Request the missing firmsize producer and exact annual-row selection; use the already available local COMP.FUNDA fields as a compatible raw component without treating them as a completed firmsize file.

Scopes: full_pipeline, analysis_only. Type: clarification. Certainty: conditional.
Addresses: R_FIRMSIZE, I_FIRMSIZE
Evidence: E_FIRMSIZE_READ, E_COMP_FUNDA_CATALOG, E_COMP_FUNDA_PROBE

Preparation / proposed procedure:

1. Use the locally available COMP.FUNDA file at ${ACCTREPL_SAS_ROOT}/comp/d_na/funda.sas7bdat; its native fields are gvkey, datadate, fyear, at, sale, mkvalt, csho, and prcc_f.
2. Confirm the fiscal-year/datadate selection and one-row-per-gvkey rule before constructing the separate firmsize working input.

Validation to perform later:

- Verify the confirmed output's unique GVKEY rule and required fields; do not invent a latest-year selection.
- Keep the native COMP.FUNDA availability separate from the unresolved firmsize row-selection/output contract.

### A_COMPANY_UNEMP_SPEC: Request the author-provided company_zip_month_unemploy20220601.dta or its exact producer and variable definition.

Scopes: full_pipeline, analysis_only. Type: clarification. Certainty: conditional.
Addresses: R_COMPANY_UNEMPLOY, I_COMPANY_UNEMPLOY
Evidence: E_COMPANY_UNEMPLOY_READ, E_PKG_COMPANY

Preparation / proposed procedure:

1. Confirm the company_cfpb/zip3/ym keys and the exact d_post_ne_priunemploy2019h1_0601 field.
2. Do not rename the similarly named base-panel field unless the author confirms identical construction.

Validation to perform later:

- Verify the exact requested field and its construction before the Table 4 merge.

### A_IDV_ACCESS: Request authorized access to the restricted IDVdata.dta analysis panel and its producer/schema.

Scopes: full_pipeline, analysis_only. Type: access_request. Certainty: conditional.
Addresses: R_IDVDATA, I_IDVDATA
Evidence: E_AUTHOR_IDV, E_IDV_READ

Preparation / proposed procedure:

1. Ask the authors or authorized data custodian for a permitted copy and the full regression-panel variables/keys expected by the supplied direct use.
2. Confirm that the file contains idv_board_av plus the Table 5 outcome, controls and zip3/frstmo/gvkey keys, or obtain the documented merge-preparation step.

Validation to perform later:

- Check the authorized file’s exact field set and provenance before using it.

### A_STAGE_UNEMPLOYMENT_ALIAS: Stage the packaged unemployment ZIP3 product under the alternate _0601 basename for the Gallup branch after confirming its complete schema and date keys.

Scopes: analysis_only. Type: data_preparation. Certainty: supported.
Addresses: R_UNEMPLOYMENT_ZIP3
Evidence: E_PKG_UNEMPLOYMENT, E_BLS_OUTPUT, E_UNEMP_ZIP3_READ

Preparation / proposed procedure:

1. Use the package’s unemployment_zip3.dta as the matching six-field product and place a working-copy alias at unemployment_zip30601.dta for the second merge.

Validation to perform later:

- Confirm zip3/yearmonth plus current, lag1, 2018 and 2019H1 rate fields; compare the dated output’s values/vintage as ordinary validation.

### A_ADDON_SETUP: Install and verify winsor2, which is required in both supplied entry-point scopes and is unavailable in the registered environment proof.

Scopes: full_pipeline, analysis_only. Type: software_setup. Certainty: supported.
Addresses: S_WINSOR2
Evidence: E_ENV_PROBE, E_CFPB_PANEL_WRITER, E_T6_READ

Preparation / proposed procedure:

1. Add winsor2 to the intended Stata ado environment using an authorized package source.

Validation to perform later:

- Confirm winsor2 resolves in the intended Stata environment before executing either supplied workflow.

### A_FULL_RUN_ORDER: After all required inputs, unresolved producer contracts, source-option fixes, and software setup are addressed, run the complete documented workflow in stage order.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_PATH_SETUP, I_CENSUS_DTA_PRODUCER, I_DEPOSIT_FILENAME
Evidence: E_CODE_ROLES, E_CENSUS_OUTPUT, E_CFPB_GALLUP_WRITER, E_CFPB_PANEL_WRITER, E_COMPANY_WRITER

Preparation / proposed procedure:

1. Stage census.dta and all public/local source inputs in the configured working copy.
2. Run data_input.do first so its complaints, ZIP3/COVID/unemployment and company panel outputs exist before their first consumers.
3. Then run t1_to_t6.do, preserving all supplied table branches.

Validation to perform later:

- Confirm every input has a compatible route, generated writers precede first consumers, and no branch was silently omitted.

### A_ANALYSIS_RUN: Use the exact packaged prepared-file route to attempt Tables 1–6 without Data_input.do only after the three genuine missing analysis inputs and ordinary setup are resolved.

Scopes: analysis_only. Type: run_procedure. Certainty: conditional.
Addresses: I_PATH_SETUP, I_FIRMSIZE, I_COMPANY_UNEMPLOY, I_IDVDATA
Evidence: E_CODE_ROLES, E_PKG_COMPLAINTS, E_PKG_COMPLAINTS2012, E_PKG_COMPANY, E_IDV_READ, E_FIRMSIZE_READ, E_COMPANY_UNEMPLOY_READ

Preparation / proposed procedure:

1. Stage the exact packaged prepared DTA/XLSX files under the local data directory and stage the matching unemployment alias for the Gallup branch.
2. Resolve the separate firmsize, company unemployment-adjusted panel, and restricted IDV analysis-panel contracts.
3. Configure the local datapath, install/verify winsor2, and run only t1_to_t6.do; frameappend is not used by this entry point.

Validation to perform later:

- Confirm each table input is present with all consumed fields and record that execution itself remains unverified.

### A_FRAMEAPPEND_SETUP: Install and verify frameappend for Data_input.do preparation; the analysis_only entry point has no frameappend call.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_FRAMEAPPEND
Evidence: E_FRAMEAPPEND_PROBE, E_SOD_AGG, E_CFPB_GALLUP_WRITER

Preparation / proposed procedure:

1. Add frameappend to the intended Stata ado environment using an authorized package source before running Data_input.do.

Validation to perform later:

- Confirm frameappend resolves before running the full preparation entry point; it is not a prerequisite for analysis_only.


## Remaining issues and prerequisites

- I_CENSUS_DTA_PRODUCER [preparation; full_pipeline]: Data_input.do reads census.dta, but its adjacent Census CSV import and save commands are commented. The matching 2018 NHGIS raw CSV is packaged, so a working-copy staging/conversion step can supply the expected DTA.
- I_DEPOSIT_FILENAME [preparation; full_pipeline]: The long deposit writer saves deposit_zip3_20112022.dta with zip3, year_deposit and deposit_zip3; its first consumer merges the same complete key/value product as deposit_zip3_2011to2022.dta. This is a supported filename alignment.
- I_USE_REPLACE_OPTION [preparation; full_pipeline, analysis_only]: Eight supplied use statements specify replace, while Stata's use syntax permits clear/nolabel. Change only those exact option tokens to clear in a working copy.
- I_PATH_SETUP [preparation; full_pipeline, analysis_only]: The analysis entry point expects a configured datapath macro and working directory. Configure a local working-copy path without copying or publishing the author-specific root.
- I_COUNTY_ZIP_LINK [unresolved; full_pipeline]: county_zip_link.dta is first consumed by the county COVID transform and later by the unemployment transform. Required fields are fips, zip, and res_ratio; the crosswalk source/vintage, weight meaning, and key uniqueness are not supplied.
- I_CENSUS_PANEL_RESIDUAL [unresolved; full_pipeline]: censuspanel_zip3_residual.dta is a separate annual ZIP3 panel joined on zip3_num/year. Its residual-adjusted measure definitions and producer are not supplied, and the static 2018 package panel does not establish it.
- I_UNEMP_MONTHLY [unresolved; full_pipeline]: unemployment_monthly.dta supplies current ZIP3/month unemployment and the l1m measure. No producer or measure definition is supplied; it is distinct from the packaged one-month lag field named unemploymentrate_zip3_lag1.
- I_UNEMP_LAG1YR [unresolved; full_pipeline]: unemployment_lag1yr.dta supplies a separate ZIP3/year unemploymentrate_zip3_l1yr value. No producer or annual lag definition is supplied; it is not the monthly l1m product.
- I_FIRMSIZE [unresolved; full_pipeline, analysis_only]: The supplied code requires a separate firmsize file unique by gvkey, but does not state which Compustat fiscal-year/date row to select. Local COMP.FUNDA raw fields are available; do not infer a latest-year or other selection rule.
- I_COMPANY_UNEMPLOY [unresolved; full_pipeline, analysis_only]: The Table 4 merge requires company_zip_month_unemploy20220601.dta and d_post_ne_priunemploy2019h1_0601. The packaged company_zip_month.dta has a similar but differently named interaction and no supplied producer for the required product.
- I_IDVDATA [unresolved; full_pipeline, analysis_only]: The Table 5 IDVdata.dta file is absent. Author documentation identifies joint proprietary IDV data; code then runs the regression directly on that file without a merge, so the required full panel fields/keys and authorized route are unresolved.
- I_CFPB_ZIP_VINTAGE [unresolved; full_pipeline]: The author documents a June 16, 2021 CFPB download; official release notes say historical ZIP values were updated in 2023 based on 2019 Census ACS. Because the code assigns complaints to ZIP3, author confirmation is needed on whether the current public values are acceptable for exact reproduction.
- R_BLS_RAW [public_acquisition_required]: Monthly LAUS county employment input used to form unemployment and labor-force measures, then weight them to ZIP3.
- R_FDIC_SOD [undetermined]: Annual FDIC Summary of Deposits branch records used to build ZIP3 deposit totals and the 2019/2020 deposit summary.
- R_JHU_COVID_RAW [public_acquisition_required]: Daily CSSE confirmed COVID cases by US county, reshaped to monthly county and ZIP3 case counts.
- R_CFPB_T2 [public_acquisition_required]: CFPB complaint rows for the primary sample, filtered by the code to 2019-08-01 through 2020-09-30.
- R_CFPB_PRE [public_acquisition_required]: CFPB complaint CSV rows for the Gallup pre-period, filtered to 2019-03-01 through 2019-05-31.
- R_CFPB_PANEL [public_acquisition_required]: CFPB complaint rows from 2012-01-01 through 2020-02-29 used to construct the monthly ZIP3 complaint panel.
- R_COUNTY_ZIP_LINK [undetermined]: Independent county-to-ZIP5 crosswalk and res_ratio weights used by both COVID and unemployment transformations.
- R_CENSUS_PANEL_RESIDUAL [undetermined]: Annual ZIP3 residual-adjusted Census panel merged to the 2012–2020 complaint panel.
- R_UNEMP_MONTHLY [undetermined]: Independent ZIP3-by-month unemployment panel used for the current monthly rate and one-month lag.
- R_UNEMP_LAG1YR [undetermined]: Independent ZIP3-by-year unemployment panel supplying the annual one-year lag measure.
- R_FIRMSIZE [undetermined]: Separate firmsize output merged by GVKEY for Table 3; local COMP.FUNDA raw rows are available, but the fiscal-year/datadate row selection and one-row-per-GVKEY producer contract are unspecified.
- R_COMPANY_UNEMPLOY [undetermined]: Separate unemployment-adjusted company-by-ZIP3-by-month panel consumed in Table 4.
- R_IDVDATA [undetermined]: Restricted director individualism/ancestry analysis input; the supplied Table 5 file must include the IDV measure and full regression panel.
- S_FRAMEAPPEND [preparation_required]: The exact command probe reports frameappend unavailable; Data_input.do uses it to combine yearly deposit frames and the Gallup pre-period.
- S_WINSOR2 [preparation_required]: The original registered environment probe reports winsor2 unavailable; both supplied scripts invoke it.

## Review notes

- The frozen title is retained: the datasheet adds a leading COVID descriptor, while the online appendix title matches the registered header; this wording difference does not establish a package identity conflict.
- Strict source review was byte-first. The connected source statement in data_input.do line 224 is fully withheld; its path, line and hash remain in the safe-screen record. Do not reproduce its body.
- An earlier bounded reader/view displayed author-supplied private-path text at t1_to_t6.do line 1 because its path-masking/display method did not suppress it. The original capture is missing; the earlier reader/view bytes remain in probes. This was private-path text, not a credential, source-data value, or raw-log value. Do not repeat or reconstruct it. It is not a separate source or access gate.
- The strict source view omits line 1 from both programs and the connected line 224 statement. Evidence quotes below use only safe source lines; no old faulty view supports any route, issue, action, scope or dependency review.
- Package data probes read one row for headers/metadata. Exact packaged author-prepared inputs are credited when the full consumed field set and product role match; unsampled endpoint/value checks remain ordinary validation, not generic availability gates.
- The full order is Data_input.do followed by T1_to_T6.do. The writers at data_input.do lines 568, 589, 733 and 987 precede the first consumers in the later analysis entry point; the long deposit writer at line 93 precedes its same-file consumer at line 721. No runtime or author code was started.
- The packaged unemployment_zip3.dta and the supplied dated generator output unemployment_zip30601.dta have the same complete six-field schema and unemployment role. The basename can be staged; value/vintage comparison is ordinary validation. The distinct unemployment_monthly, unemployment_lag1yr and censuspanel_zip3_residual inputs remain separately unresolved.
- company_zip_month_unemploy20220601.dta remains distinct from company_zip_month.dta because the requested _0601 field is not present in the packaged base panel and no matching producer is supplied.
- README.docx mentions treat_control_list.dta for Table 6, but neither supplied driver reads it; it is not an active dependency. The workbook formulas are confined to the unused Individual Indicators sheet; the code imports Overall Gender Index only.
- Public source checks were static documentation/landing pages only. No API request, public data payload, model, or source data was downloaded or queried. No author code, SAS startup, installations, or statistical execution were performed.
- The official FDIC SOD custom-download/help page view contained no readable lines. Its official product URL is retained as an unverified candidate; source code and author documentation still establish the actual field/product role. No data payload was requested, and no access or licensing barrier is inferred.
- COMP.FUNDA is not directly read by either supplied driver. The successful local raw component at ${ACCTREPL_SAS_ROOT}/comp/d_na/funda.sas7bdat has native gvkey, datadate, fyear, at, sale, mkvalt, csho, and prcc_f fields. This positive availability is credited within R_FIRMSIZE, but does not establish the separate firmsize producer or missing fiscal-year/datadate row selection for one row per GVKEY.
- frameappend is needed only in the full_pipeline Data_input.do preparation scope; analysis_only runs t1_to_t6.do without it. winsor2 remains a required unavailable command in both scopes, and statastates remains part of the analysis entry point.
