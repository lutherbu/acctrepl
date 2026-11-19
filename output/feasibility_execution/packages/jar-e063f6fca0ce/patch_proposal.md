# Patch proposal: jar-e063f6fca0ce

The Effect of Mandatory Extraction Payment Disclosures on Corporate Payment and Investment Policies Abroad

DOI: 10.1111/1475-679X.12332

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Author-supplied Stata data-preparation pipeline: the payment, geographic segment capex, parent quarterly capex, licensing, historical bidding, and block-production/productivity branches, with the driver and cleaning helpers. Outputs are prepared regression datasets; no regression estimators are supplied in these ten programs.

Entry points: `0_Run_All_Code.do`, `1_data_payment.do`, `2_data_segment_capex.do`, `3_data_parent_capex.do`, `4_data_hist_bidding.do`, `5_data_licensing.do`, `6_data_productivity.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 5/12332 - The-Effect-of-Mandatory-Extraction-Payment-Disclosures-on-Corporate-Payment-and-Investment-Policies-Abroad/rauter-datasheet-code-and-identifiers.zip",
      "sha256": "da637895b9d35a577c93a74842cd7813543d400c98e0c9cabad70b2783b9e265"
    },
    {
      "path": "JAR-Volume 58/Issue 5/12332 - The-Effect-of-Mandatory-Extraction-Payment-Disclosures-on-Corporate-Payment-and-Investment-Policies-Abroad/rauter-online-appendix.pdf",
      "sha256": "a56ce4d797afcf5fc2b1856ffacbc70bde959dd0423e28d04bbe327757005f42"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "a42a083eeee3257ab3dedbfadc90febd85d34e3a39c50cb23090423a253bb7db"
}
```

## Proposed actions

### A_PAYMENT_DATA: Locate compatible prepared payment, enrichment, Compustat, currency and shaming inputs for the payment branch; use documented manual/vendor source leads only after checking the exact prepared-input route.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: I_PREP_INPUTS, R_EITI_PAYMENTS, R_EITI_ENR_ALL, R_EITI_ENR_ALL_UPDATE, R_EITI_ENR_PARENT, R_COMP_NA_ANNUAL, R_COMP_GLOBAL_ANNUAL, R_PAYMENT_CPI, R_PAYMENT_FX, R_COMP_MONTHLY_FX, R_EPD_MASTER, R_MEDIA_FACTIVA, R_ASC_INVESTMENTS, R_ASC_PAYMENTS
Evidence: E_EITI_PAYMENT_FIELDS, E_EITI_JOIN_FIELDS, E_COMP_NAICS_FIELDS, E_PAYMENT_FX_FIELDS, E_FX_COMP_MONTHLY, E_EXTRA_EPD, E_FACTIVA_SINCE2000, E_ACTIVIST_JOIN, E_DATASHEET_SOURCES, E_PROBE_FX, E_PAYMENT_LAGS_V2

Preparation / proposed procedure:

1. Check for the named author-prepared EITI payment workbook and each required enrichment sheet separately (`all`, `all_update`, `parent_gvkeys`); confirm their company/country or parent-country/GVKEY join keys and report-year coverage.
2. Check the separate Compustat North America and Global annual inputs for exact naics, issuer/date/fiscal-year keys, and the source history required by the coded lagged capex fractions. At t-5 the ratio reaches capx_(t-5)/assets_(t-6), subject to consecutive-fiscal-year checks; preserve missingness and do not infer an input lower bound. Local annual candidates expose naicsh, so establish an author-consistent mapping before using them.
3. Stage and verify the payment-specific country/currency/year/unit FX sheet and the monthly Compustat exchange product under both consumed filenames; verify the merge key and rates for all matched periods.
4. Locate the 2013 CPI workbook sheet, EPD masterfile, English Factiva firm-year coverage and the two distinct activist files. Datasheet provenance is a lead; it does not establish current rows, routes, or entitlement.
5. Keep manual EITI/EPD/activist sources and Factiva as separate products; do not reconstruct author-prepared tables unless the necessary source definitions and mappings are confirmed.

Validation to perform later:

- Verify required columns, date ranges, country/company keys and expected merge uniqueness for each input before a future driver attempt.
- Confirm payment observations from 2010 onward and the code’s consecutive-fiscal-year conditions for lagged capex fractions; preserve row-level missingness and do not require all lags to be nonmissing or infer a source lower bound. Confirm FX keys and CPI 2013 mappings.
- Confirm the shaming helper inputs have `gvkey`, year and campaign/media fields matching the payment branch.

### A_SEGMENT_DATA: Stage and verify the distinct Worldscope geographic-segment input, parent controls, NAICS mappings, currency and CPI tables used by segment capex.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_COMP_NA_NAICS_TEXT, R_COMP_GLOBAL_NAICS_TEXT, R_WORLD_SCOPE_SEGMENTS, R_WORLD_SCOPE_PARENT, R_WORLD_BANK_FX, R_CPI_SEGMENT_1998_2015, R_CPI_SEGMENT_2016, R_CPI_SEGMENT_2017, R_GVKEY_NA_NAICS_DTA, R_GVKEY_GLOBAL_NAICS_DTA, R_EPD_MASTER, R_MEDIA_FACTIVA, R_ASC_INVESTMENTS, I_CROSSWALK_PRODUCERS, I_WORLD_SCOPE_SCHEMA
Evidence: E_SEGMENT_SCHEMA, E_SEGMENT_PARENT_SCHEMA, E_NA_NAICS_SCHEMA, E_CROSSWALK_DIRS, E_WB_EXCHANGE_SCHEMA, E_CPI_SEGMENT_SCHEMA, E_PROBE_WSEG, E_PROBE_WCOMPANY, E_CATALOG_V2, E_SEGMENT_PERIOD

Preparation / proposed procedure:

1. First locate the single author-prepared `segment_data_worldscope_2017.csv` with all company/fiscal-year fields and item196xx segment columns; do not separately require a Worldscope company table when that compatible combined CSV is available.
2. If using the local Worldscope catalog candidates instead, verify issuer-year joins and company-field uniqueness between WRDS_WS_SEGMENTS and any company-information supplement before constructing the author CSV; the join and constructor are currently unsupported.
3. Locate the North America and Global Compustat NAICS text inputs and the separately consumed raw-directory GVKEY-to-NAICS DTA maps. Confirm whether the early clean_data crosswalk outputs are intended equivalents; validate CUSIP/SEDOL/ISIN key uniqueness before path/schema alignment.
4. Locate the author-prepared Worldscope parent fundamentals DTA or document how the local annual candidate maps to ws_id, year, assets, ROA, local assets and liabilities; retain the presample history required by the coded lagged controls, with exact lower bound and row-level missingness unverified.
5. Locate annual exchange rates and all three CPI workbooks (1998-2015, 2016, 2017), plus EPD/media/activist-investment inputs; verify country codes, units and periods before merging.

Validation to perform later:

- Confirm source has all ten segment field sets and exact firm/year keys; keep the segment_oic behavior as a separate author-intent question; do not add item19602 as a required input column.
- Verify CPI 1998-2017 rows and FX country-year units; check parent lag construction through 2017.
- Confirm both pre-2014 and 2014+ segment observations remain available for the coded regression sample.

### A_PARENT_DATA: Resolve the exact author-prepared quarterly and security input schemas before selecting local Compustat/SAS sources for parent capex.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COMP_MONTHLY_FX, R_SECURITY_DATA, R_COMP_GLOBAL_QUARTERLY, R_COMP_NA_QUARTERLY, R_EPD_MASTER, I_PARENT_CAPEX_SCHEMA
Evidence: E_PARENT_INPUTS, E_PARENT_SECURITY_SCHEMA, E_PROBE_COMP_Q, E_PROBE_COMP_GQ, E_PROBE_SECURITY, E_CATALOG_V2, E_PARENT_PERIOD_V2

Preparation / proposed procedure:

1. Locate the named Global/NA quarterly DTA inputs and security DTA used by the author code; compare actual columns to the exact fields selected and merged in the script.
2. If using local Compustat products, specify how exact `naics`, `conm`, `loc`/`fic`, identifiers, quarter/date fields and monthly FX are constructed and matched. Do not treat COMP.SECM or COMP.G_SECURITY alone as the author security file.
3. Retain the presample quarterly history required by the coded lagged/differenced variables before the 2010Q1-2017Q4 output filter; the exact lower bound and missingness pattern are unresolved, and one preceding quarter alone does not establish all controls.

Validation to perform later:

- Check one-to-one `gvkey datadate` security keys and monthly FX match coverage before a future run.
- Check required quarterly financial variables and North America/Global country mappings for every included issuer.

### A_LICENSE_DATA: Locate the separate Enverus licensing blocks table and manual participant/headquarters crosswalk, then resolve the same-program participant table path handoff.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_ENVERUS_BLOCKS, R_OPERATOR_HQ_CROSSWALK, R_EPD_MASTER, I_LICENSE_PARTICIPANT_PATH
Evidence: E_LICENSE_INPUTS, E_LICENSE_PRODUCED_PARTICIPANT, E_LICENSE_LOOKUP, E_LICENSE_PARTICIPANT_DIR, E_LICENSE_PARTICIPANT_USE, E_LICENSE_PERIOD, E_DATASHEET_SOURCES, E_COLLAPSE_PREFIX_PROBE, E_LIC_VERSION_BEHAVIOR

Preparation / proposed procedure:

1. Locate the Enverus BlocksTable export and the exact `Manual_merge_Formulas` workbook range. Verify block IDs, participant names/identifiers, award/expiry years, country and hydrocarbon type, along with GVKEY and headquarters-country mapping coverage.
2. Keep the two generated participant intermediates within the licensing program’s documented producer chain; do not require those generated files as separate raw inputs.
3. The program writes `oil_block_participant.dta` under clean_data and later consumes it from raw_data; use the supported working-copy path alignment action before running.

Validation to perform later:

- Confirm participant/block keys are unique at the code’s reshape/collapse levels and that the crosswalk retains `participantintname` for bidding.
- Confirm the licensing sample filter covers 2000-2018 and the final named output is written.
- Leave the local version suffix empty; verify Stata varabbrev is on (the default tested setting) and check participantintname-country-year uniqueness explicitly. Do not select ID mode, because participantID is not retained by collapse.

### A_BIDDING_DATA: Locate the separate historical bid-block workbook and inspect the full merge/projection chain that may supply the post_EPD field.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ENVERUS_HIST_BIDS, R_OPERATOR_HQ_CROSSWALK, R_EPD_MASTER, R_BID_POST_EPD_FIELD
Evidence: E_ENVERUS_BID, E_BID_SOURCE_KEYS, E_DATASHEET_SOURCES, E_BID_PREP_KEEP_V2, E_BID_MASTER_MERGE_V2, E_BID_ALLBIDDERS_KEEP_V2, E_BID_POST_COMMENT_V2, E_BID_POST_LABEL_V2, E_TRACE_V5

Preparation / proposed procedure:

1. Locate the author-named Hist_Bid_Blocks Africa.xlsx Bid Data sheet and verify the separate block, bid-round, bidder, country and contract fields; it is distinct from the licensing BlocksTable and Enverus ownership transactions.
2. Trace post_EPD through the actual code: the raw workbook is projected to bidding_hist_temp without the field; a later full epd_masterfile merge by company_standardized could supply it, but the all_bidders projection also omits it.
3. Determine whether post_EPD survives through the block-specific appends and final data. If not, obtain author direction on the field source and on the commented bid_round_year > 2013 definition.
4. Do not remove the active label or invent a source/threshold.

Validation to perform later:

- Verify the field survives the actual merge/keep/append chain and has author-supported meaning before the active label runs.

### A_PRODUCTIVITY_DATA: Locate the prepared field/block/EPD map and the two separate Enverus products required for productivity and block-entry preparation.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_ENVERUS_ASSET_TRANSACTIONS, R_PRODUCTION_FIELD_BLOCK_EPD, R_ENVERUS_MONTHLY_PRODUCTION, R_EPD_MASTER, I_PRODUCTIVITY_MAP
Evidence: E_PRODUCTIVITY_INPUTS, E_PRODUCTIVITY_MERGE, E_ASSET_TRANSACTION_DATES, E_PRODUCTIVITY_ASSET_FIRST, E_MONTHLY_PROD_FIELDS, E_MONTHLY_PROD_HIST, E_DATASHEET_SOURCES

Preparation / proposed procedure:

1. Locate the distinct prepared production_field_block_EPD.dta and verify field_name, block identifiers, reporting flags, EntityType and operator schema. It has no supplied producer and is not the raw monthly production table.
2. Locate the Enverus AssetTransactionsFull.CSV and verify completed transactions, block IDs/names, party names/shares and effective/closed/agreement dates. Retain pre-2010 rows needed to calculate first acquisition dates.
3. Locate the separate Enverus Production_monthly_field_well_level.dta and check field_name, month, output, wells, block/entity and operator/reporting fields. Verify monthly history sufficiently to assess six-month gap logic for Q1 2010-Q4 2017.
4. Keep the two authored outputs: field_production_data_interpol_FINAL.dta and block_entry_analysis_clean_FINAL.dta.

Validation to perform later:

- Verify field_name merge cardinality and monthly calendar coverage before interpolation.
- Check that interpolation fills no more than six consecutive missing months and that the final 2010Q1-2017Q4 sample excludes blocks flagged for longer gaps.
- Verify pre-2010 asset history is present before interpreting first-deal treatment variables.

### A_INPUT_INVENTORY: Reconcile the full named raw-input inventory for all six branches against the packaged release.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_PREP_INPUTS
Evidence: E_DRIVER, E_DATASHEET_SCOPE, E_PROBE_IDENTIFIERS, E_DEPENDENCY_REVIEW, E_TRACE_V5

Preparation / proposed procedure:

1. Use the 33 item-specific full_pipeline requirements and all 48 dependency dispositions as the checklist; record exact file, sheet/table, schema, key and history for each supplied input.
2. Treat Company_Identifiers.xlsx only as an identifier/name workbook; it does not satisfy any prepared regression panel requirement.
3. Prefer a compatible author-prepared table when available. Keep documented historical source provenance as context unless its raw reconstruction is selected and its field/key constructor is supported.

Validation to perform later:

- Verify every active read has a corresponding input requirement or same-run producer, and every produced intermediate is written to the directory/path consumed downstream.

### A_ROOT_CONFIG: Configure the six-branch project root and helper-code path in a working copy.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_ROOT_SETUP
Evidence: E_ROOT_MACROS, E_HELPER_PAYMENT, E_HELPER_SEGMENT, E_HELPER_SEGMENT_SHAMING

Preparation / proposed procedure:

1. Set main_dir to the working directory containing the supplied Stata programs and the expected 00_Raw_Data, 01_Clean_Data and 02_Final_data folders.
2. Set code to the directory containing clean_company_name.do, clean_country_name.do and clean_shaming_data.do.
3. Create or select the three data subdirectories under that main_dir; preserve all authored output names.

Validation to perform later:

- Confirm the expanded raw_data, clean_data, final_data and code paths resolve before starting the driver.

### A_DRIVER_ORDER: Move the licensing producer before the bidding consumer in a working copy of the driver.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_ORDER_HANDOFF
Evidence: E_ORDER_DRIVER, E_ORDER_CONSUMER, E_ORDER_PRODUCER, E_ORDER_PRODUCER_HC

**Proposed edit:** `0_Run_All_Code.do:50–60`
Source SHA-256: `79b040d6f22adfb9dd4be7680668ec93f934e676b85bbf6f6682669c63f08520`

The bidding program consumes two files produced by licensing; the supplied order runs the consumer first.

Current text:
```
********************** 4) AUCTION PARTICIPATION ANALYSIS ***********************
********************************************************************************

	do "$main_dir/4_data_hist_bidding.do"

	
********************************************************************************
***************************  5) LICENSING ANALYSIS  ****************************
********************************************************************************

	do "$main_dir/5_data_licensing.do"
```

Proposed replacement:
```
********************************************************************************
***************************  5) LICENSING ANALYSIS  ****************************
********************************************************************************
	do "$main_dir/5_data_licensing.do"

********************************************************************************
********************** 4) AUCTION PARTICIPATION ANALYSIS ***********************
********************************************************************************
	do "$main_dir/4_data_hist_bidding.do"
```

Preparation / proposed procedure:

1. Keep the payment, segment and parent capex branches first.
2. Run 5_data_licensing.do before 4_data_hist_bidding.do so participant_EPD_clean.dta and mainHC_type.dta exist before the bidding reads.
3. Keep 6_data_productivity.do as the sixth branch.

Validation to perform later:

- Confirm the licensing program produces both clean_data handoff files before bidding starts.
- Confirm all six named final branch outputs remain in place.

### A_WORLD_SCOPE_SCHEMA: Resolve whether the author-prepared combined Worldscope CSV is available, or document a supported constructor from local tables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_WORLD_SCOPE_SCHEMA, R_WORLD_SCOPE_SEGMENTS
Evidence: E_SEGMENT_SCHEMA, E_PROBE_WSEG, E_PROBE_WCOMPANY, E_CATALOG_V2, E_TRACE_V5

Preparation / proposed procedure:

1. Prefer the single author-named segment_data_worldscope_2017.csv if available and verify all company/fiscal-year plus ten segment item fields.
2. If reconstructing from local catalog tables, first specify and validate the Worldscope identifier/year/frequency join between segments and company attributes; do not treat WRDS_WS_COMPANY as an additional mandatory input when the combined author CSV is used.
3. Preserve the original name, nation, nation_code, region and fyearend fields required by the source code.

Validation to perform later:

- Verify source fields, key uniqueness, 2000+ history and 2010-2017 sample coverage before using either route.

### A_CROSSWALK_GAP: Resolve the raw-directory NAICS crosswalk filenames/schema against the two different clean_data products generated earlier.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_CROSSWALK_PRODUCERS, R_GVKEY_NA_NAICS_DTA, R_GVKEY_GLOBAL_NAICS_DTA
Evidence: E_NA_NAICS_SCHEMA, E_CROSSWALK_DIRS, E_TRACE_V5

Preparation / proposed procedure:

1. Locate the intended gvkey_to_naics_north_america.dta and gvkey_to_naics_global.dta, or document whether the code-generated clean_data/compustat_*_naics.dta tables are intended producers.
2. Do not copy or redirect the generated crosswalks until required variables and unique merge keys are checked: CUSIP for NA, and separate SEDOL/ISIN mappings for Global.
3. Keep NA and Global maps separate and retain the author’s NAICS/year histories.

Validation to perform later:

- Verify the exact key contract for every m:1 merge and confirm all expected DTA paths exist before the segment branch.

### A_PARENT_SCHEMA_GAP: Obtain or identify the exact author-prepared quarterly and security DTA construction contract before selecting local candidates.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_PARENT_CAPEX_SCHEMA, R_COMP_GLOBAL_QUARTERLY, R_COMP_NA_QUARTERLY, R_SECURITY_DATA
Evidence: E_PARENT_REQUIRED_FIELDS, E_PARENT_SECURITY_SCHEMA, E_PROBE_COMP_GQ, E_PROBE_SECURITY, E_CATALOG_V2, E_PROBE_COMP_Q, E_PARENT_PERIOD_V2

Preparation / proposed procedure:

1. Compare author input schemas to the code-required exact variable names, date/key types and country/security attributes.
2. If using local Compustat, document transformations for naics, company name and issuer-country/security fields and how global/NA quarterly files are bounded to sample periods.
3. Keep COMP.SECM and COMP.G_SECURITY distinct; neither candidate alone verifies the author security_data.dta input.

Validation to perform later:

- Verify quarterly 1:1 gvkey/datadate keys, monthly FX merge keys and sufficient presample/analysis history for the coded lags and differences; do not assume one prior quarter suffices.

### A_LICENSE_PARTICIPANT_PATH: Point the hydrocarbon-type consumer to the participant table produced earlier in the same licensing script.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_LICENSE_PARTICIPANT_PATH
Evidence: E_LICENSE_PARTICIPANT_DIR, E_LICENSE_PARTICIPANT_USE, E_LICENSE_HC_PRODUCER

**Proposed edit:** `5_data_licensing.do:192–192`
Source SHA-256: `ea0da1a5273e0fe4fba1972e38e862132c029329810497a950ea8cea2ff4b61e`

The same program produces this basename in clean_data; reading raw_data leaves the producer-consumer chain unresolved.

Current text:
```
use "$raw_data/oil_block_participant.dta", clear
```

Proposed replacement:
```
use "$clean_data/oil_block_participant.dta", clear
```

Preparation / proposed procedure:

1. In a working copy, change the consumer to read clean_data/oil_block_participant.dta, matching the line-44 producer; preserve the same basename and output logic.

Validation to perform later:

- Confirm the line-44 output is available when the hydrocarbon-type section runs and contains participantintname and hydrocarbontype.

### A_BID_POST_EPD_RESOLUTION: Trace and resolve the post_EPD field through the actual bidding input, full EPD merge, intermediate projection and final label.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_BID_POST_EPD, R_BID_POST_EPD_FIELD, R_ENVERUS_HIST_BIDS, R_EPD_MASTER
Evidence: E_BID_PREP_KEEP_V2, E_BID_MASTER_MERGE_V2, E_BID_ALLBIDDERS_KEEP_V2, E_BID_POST_COMMENT_V2, E_BID_POST_LABEL_V2, E_TRACE_V5

Preparation / proposed procedure:

1. The initial bid workbook is explicitly projected to bidding_hist_temp without post_EPD; verify its schema only as one potential source, not as proof of the final field.
2. The later full epd_masterfile merge by company_standardized could add post_EPD; the subsequent all_bidders keep list omits that variable, so trace whether any relevant bidder/block rows preserve it through append and later processing.
3. If the final variable is absent, obtain author confirmation of the intended field source and whether the commented bid_round_year > 2013 derivation is intended; preserve the active label pending clarification.
4. Do not remove the label or create a new threshold without a supported source/pass-through and definition.

Validation to perform later:

- Verify post_EPD survives the actual merge/keep/append path to the final dataset, or obtain the supported author definition for the commented derivation; confirm its meaning matches the active label before running.

### A_PRODUCTIVITY_MAP_RESOLUTION: Locate or document the author-prepared production_field_block_EPD.dta input and its schema.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_PRODUCTIVITY_MAP, R_PRODUCTION_FIELD_BLOCK_EPD
Evidence: E_PRODUCTIVITY_INPUTS, E_MONTHLY_PROD_FIELDS, E_TRACE_V5

Preparation / proposed procedure:

1. Locate the prepared field/block/EPD mapping and confirm field-to-block identifiers, reporting flags, block/entity data and key types.
2. If a producer exists outside these ten supplied programs, document its source input and conversion; do not infer the mapping from monthly production alone.

Validation to perform later:

- Verify field_name merge cardinality and presence of the operator and reporting fields before joining the monthly Enverus table.

### A_SOFTWARE_SETUP: Make the two invoked Stata add-on commands available in the working Stata adopath.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_WINSOR2, SW_KOUNTRY
Evidence: E_STATA_ENV, E_PROBE_KOUNTRY, E_HELPER_PAYMENT, E_HELPER_SEGMENT

Preparation / proposed procedure:

1. Install or configure the free Stata commands winsor2 and kountry using the project’s approved software process; no installation was performed in this assessment.
2. Retain Stata 18 as the available runtime; the add-ons are separate requirements.

Validation to perform later:

- Use Stata `which winsor2` and `which kountry` in the intended runtime/adopath before the first author-program run.

### A_ORDERED_RUN: Run the six preparation branches in producer-consumer order after required inputs, setup and source repairs are ready.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: I_ROOT_SETUP, I_ORDER_HANDOFF
Evidence: E_DRIVER_1, E_DRIVER_2, E_DRIVER_3, E_DRIVER_5, E_DRIVER_4, E_DRIVER_6, E_TRACE_V5

Preparation / proposed procedure:

1. Configure main_dir, code, raw_data, clean_data and final_data in a working copy and stage/verify the requirements linked to the six branches.
2. Run 1_data_payment.do.
3. Run 2_data_segment_capex.do.
4. Run 3_data_parent_capex.do.
5. Run 5_data_licensing.do; it produces participant_EPD_clean.dta and mainHC_type.dta for bidding.
6. Run 4_data_hist_bidding.do after the licensing outputs exist.
7. Run 6_data_productivity.do, preserving both field-production and block-entry outputs.
8. Do not add paper-wide estimators or appendix-only analyses to this supplied-data-preparation target.

Validation to perform later:

- Confirm the six final output filenames and the additional field_production_data_interpol_FINAL.dta appear in final_data.
- Confirm no producer-consumer path mismatch remains; this action is a future procedure and has not been run.

### A_SEGMENT_OIC_CLARIFICATION: Clarify the intended segment_oic output and whether the absent Worldscope item mapping is deliberate before changing data or code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_SEGMENT_OIC, R_WORLD_SCOPE_SEGMENTS
Evidence: E_SEGMENT_FIELDS_V2, E_SEGMENT_RESHAPE_V2, E_SEGMENT_DUPLICATE_V2, E_PROBE_WSEG, E_SYNTHETIC_RESHAPE_V2

Preparation / proposed procedure:

1. The code currently allows reshape to create an all-missing segment_oic when no source stub is mapped; this permits execution but may affect the later duplicates drop key.
2. Although the catalog labels ITEM19602 as operating income, confirm that the author CSV should use this field and how missing/duplicate segment rows should behave before proposing any mapping.
3. Do not make ITEM19602 or the other OIC items a required raw input column absent that confirmation.

Validation to perform later:

- Compare the intended output and duplicate-removal behavior against author documentation/input semantics before any future edit; preserve existing segment observations and all six branches.


## Remaining issues and prerequisites

- I_PREP_INPUTS [unresolved; full_pipeline]: The release has ten Stata preparation/helper programs, the datasheet, appendix, and Company_Identifiers.xlsx, but no raw inputs or prepared regression datasets. The workbook is an identifier/name list, not an analysis panel. The 33 input requirements distinguish the actual products/tables used in all six branches; their exact field, key, producer, history, and access routes remain unresolved where not probed.
- I_ORDER_HANDOFF [preparation; full_pipeline]: The driver calls 4_data_hist_bidding.do before 5_data_licensing.do, but licensing produces participant_EPD_clean.dta and mainHC_type.dta consumed by bidding. Reorder the existing calls so licensing completes first, retaining all six branches.
- I_ROOT_SETUP [preparation; full_pipeline]: The driver leaves main_dir blank and derives raw_data, clean_data and final_data from it; helper calls in payment and segment scripts use a separate code global that is not set in supplied code. Configure project/output roots and code directory in a working copy before attempting the six branches.
- I_SEGMENT_OIC [unresolved; full_pipeline]: The segment loop does not map an operating-income field, but the later reshape declares segment_oic. A self-written Stata fixture confirms that the absent stub does not halt reshape and yields an all-missing variable. Although the local Worldscope product labels item19602 as operating income, the author input and intended output semantics are unverified; a mapping would also change the later duplicate-drop key. Clarify author intent before any source or input change; this is not a mandatory raw-column requirement.
- I_WORLD_SCOPE_SCHEMA [unresolved; full_pipeline]: The single consumed author CSV is expected to contain segment fields plus company/name, nation, region and fiscal-year-end columns. The local WRDS_WS_SEGMENTS candidate confirms the item196 fields but lacks several company fields; WRDS_WS_COMPANY is a potential supplement, but the join key, uniqueness and author-compatible CSV constructor are not provided. Use the single author CSV if available; keep any raw-table merge conditional until its contract is supported.
- I_CROSSWALK_PRODUCERS [unresolved; full_pipeline]: The segment program imports NA/global NAICS text files to create clean_data crosswalks, but later reads separate gvkey_to_naics_north_america.dta and gvkey_to_naics_global.dta from raw_data. No supplied producer creates those raw-directory names; the generated files have different paths and key checks do not establish uniqueness on every later merge key (CUSIP, SEDOL, ISIN). Confirm the intended prepared files or validate a supported working-copy path/schema alignment.
- I_PARENT_CAPEX_SCHEMA [unresolved; full_pipeline]: The parent quarterly branch expects author-named Compustat/security DTA inputs with exact NAICS and company/location fields, merges security by gvkey/datadate, and builds lagged/differenced controls before its 2010Q1-2017Q4 output filter. The code drops its internally indexed Q4 2009 observation, but this does not establish complete pre-sample history for all controls. Local quarterly candidates cover many date/financial fields but not the full author schema (including exact naics/conm), and no producer/merge constructor is supplied.
- I_LICENSE_PARTICIPANT_PATH [preparation; full_pipeline]: 5_data_licensing.do saves oil_block_participant.dta to clean_data, then reads the same basename from raw_data to classify hydrocarbon type. These different directories do not establish a producer-consumer handoff. Align the consumer to the produced clean_data path in a working copy.
- I_BID_POST_EPD [unresolved; full_pipeline]: The bidding branch comments out both post_EPD derivation statements but later labels post_EPD. The initial raw bid table is projected to a saved keep list that excludes the field. A later full epd_masterfile merge by company_standardized could add a same-named field, but the all_bidders projection also omits it, so pass-through to the final dataset is not established. Confirm the intended field source, survival path and definition before execution; do not remove the label or invent the indicator.
- I_PRODUCTIVITY_MAP [unresolved; full_pipeline]: The productivity program requires production_field_block_EPD.dta, containing field-to-block identity, reporting flags and entity attributes, but no supplied program produces it. It is a separate prepared mapping input and cannot be inferred from the raw monthly Enverus production file alone.
- R_EITI_PAYMENTS [undetermined]: EITI host-country/company reconciliation payment table imported by the payment branch. Needs company-country-year payment fields and identifiers; target sample keeps years 2010 onward.
- R_EITI_ENR_ALL [undetermined]: EITI enrichment workbook sheet `all`, merged on company and country for payment observations.
- R_EITI_ENR_ALL_UPDATE [undetermined]: EITI enrichment workbook sheet `all_update`, used to update the first company-country merge.
- R_EITI_ENR_PARENT [undetermined]: EITI enrichment workbook sheet `parent_gvkeys`, mapping parent and parent-country to GVKEY.
- R_COMP_NA_ANNUAL [undetermined]: Compustat North America annual fundamentals used for payment controls and the coded lagged capex-fraction ratios.
- R_COMP_GLOBAL_ANNUAL [undetermined]: Compustat Global annual fundamentals appended to North America fundamentals for payment controls.
- R_PAYMENT_CPI [undetermined]: TI CPI workbook for the 2013 country scores used to classify corrupt/non-corrupt host countries.
- R_PAYMENT_FX [undetermined]: Payment-specific FX spreadsheet, joined by country/currency/year/unit and used to compute period-end GBP rates.
- R_COMP_MONTHLY_FX [undetermined]: Monthly Compustat exchange-rate product prepared under `currencies.dta` (payment branch) and `g_exr_monthly.dta` (parent-capex branch, with tocurm renamed curcdq). These are separate staged aliases to the same product, not interchangeable raw author files.
- R_EPD_MASTER [undetermined]: Author-prepared EPD reporting/master file joined across payment, segment, quarterly parent, bidding and productivity branches. Code uses GVKEY/company keys, report flag and effective dates; bidding also performs a full company_standardized merge whose post_EPD pass-through is not established.
- R_MEDIA_FACTIVA [undetermined]: Firm-year English business-press coverage used to construct prior EPD media exposure.
- R_ASC_INVESTMENTS [undetermined]: NGO activist campaign input for investment-analysis branches (segment capex); helper requires campaign flag and firm key.
- R_ASC_PAYMENTS [undetermined]: NGO activist campaign input for payment-analysis branch; separate from the investment campaign file.
- R_COMP_NA_NAICS_TEXT [undetermined]: Compustat North America NAICS history text used for the segment CUSIP crosswalk.
- R_COMP_GLOBAL_NAICS_TEXT [undetermined]: Compustat Global NAICS history text used for SEDOL/ISIN segment crosswalks.
- R_WORLD_SCOPE_SEGMENTS [undetermined]: Single Worldscope Geographic Segments CSV imported by the segment branch. The source code consumes company/year metadata and segment description/assets/capex items; segment_oic is separately declared at reshape but its intended input mapping is unresolved, not a required raw column.
- R_WORLD_SCOPE_PARENT [undetermined]: Worldscope annual parent-fundamentals Stata input used for current and lagged assets, ROA, local assets/liabilities.
- R_WORLD_BANK_FX [undetermined]: Annual World Bank currency-conversion table joined to Worldscope country/year before segment USD conversion.
- R_CPI_SEGMENT_1998_2015 [undetermined]: Transparency International CPI workbook for 1998-2015, jointly used in segment capex construction.
- R_CPI_SEGMENT_2016 [undetermined]: Separate 2016 TI CPI workbook used to extend the segment CPI panel.
- R_CPI_SEGMENT_2017 [undetermined]: Separate 2017 TI CPI workbook used to extend the segment CPI panel.
- R_GVKEY_NA_NAICS_DTA [undetermined]: North America GVKEY/NAICS crosswalk DTA read from raw_data by CUSIP; no producer for this filename/schema is supplied.
- R_GVKEY_GLOBAL_NAICS_DTA [undetermined]: Global GVKEY/NAICS crosswalk DTA read from raw_data then subset by SEDOL and ISIN; no producer for this expected file is supplied.
- R_SECURITY_DATA [undetermined]: Security data input merged one-to-one with global Compustat by gvkey/datadate before constructing parent quarterly panel.
- R_COMP_GLOBAL_QUARTERLY [undetermined]: Compustat Global quarterly Stata input, joined to monthly currency/security sources and used in parent capex output.
- R_COMP_NA_QUARTERLY [undetermined]: Compustat North America quarterly Stata input joined with exchange rates and appended to selected global quarterly observations.
- R_ENVERUS_HIST_BIDS [undetermined]: Historical bid-block and auction-participant workbook imported by the bidding branch, separate from Enverus licensing blocks.
- R_ENVERUS_BLOCKS [undetermined]: Enverus BlocksTable export used to construct the block-participant and licensing firm-country-year panels.
- R_OPERATOR_HQ_CROSSWALK [undetermined]: Manual operator-name/headquarters and GVKEY crosswalk workbook that enriches the Enverus licensing panel and produces the bidding EPD handoff.
- R_PRODUCTION_FIELD_BLOCK_EPD [undetermined]: Prepared field/block/EPD map required before monthly field-level production is attached; no supplied code produces this DTA.
- R_ENVERUS_ASSET_TRANSACTIONS [undetermined]: Enverus asset ownership-change transactions, used to construct block-month treatment and first-acquisition dates.
- R_ENVERUS_MONTHLY_PRODUCTION [undetermined]: Enverus monthly well-level production table joined to the prepared field/block/EPD map; separate from asset transactions.
- R_BID_POST_EPD_FIELD [undetermined]: The final bidding path requires a post_EPD field for an active label. Candidate sources are the full EPD masterfile merge and the imported bid workbook, but the explicit keep/projection steps do not show either route surviving; code-derived creation remains commented and undefined for the current target.
- SW_WINSOR2 [preparation_required]: The supplied programs invoke winsor2. The local Stata environment probe did not find this command in the default or checked shared adopaths; add/configure the package before a future run. No install was performed.
- SW_KOUNTRY [preparation_required]: The supplied programs invoke kountry for country-code normalization. A Stata 18 which probe did not find the command; add/configure it before a future run. No install was performed.

## Review notes

- Assessed target is the ten supplied Stata files implementing six regression-data preparation outputs plus one prepared field-production intermediate. Datasheet and appendix describe further estimation/event-study work; no corresponding estimator/event-study program is supplied in this package, so these analyses are contextual and not added as mandatory scope.
- Company_Identifiers.xlsx is a readable one-row-sampled identifier workbook with six analysis-labeled sheets; it is not a prepared panel or an alternative route for any of the empirical inputs.
- The local SAS observations are exact product candidates and bounded one-row evidence only. Field matches do not establish full-history, key uniqueness, author schema construction or complete availability.
- Datasheet notes EITI, EPD, TI CPI and activist information as public/manual collection leads; Factiva and Enverus as commercial product provenance. No public source was live-verified in this assigned check. No catalog hit/miss is treated as proof of access or license status.
- The licensing program leaves version empty. The provided synthetic Stata fixture shows `isid participant country year` succeeds via default/on abbreviation to the retained participantintname key; explicit ID mode fails because collapse does not retain participantID. No macro edit is proposed; future setup should confirm varabbrev on and check the full key.
- The segment reshape can execute with all-missing segment_oic; catalog item19602 is a possible operating-income source, but author intent and duplicate-removal effects are unverified. No raw OIC field or source edit is mandatory until clarified.
- For bidding post_EPD, the raw-workbook keep list omits the field; the full EPD merge could supply it, but its later all_bidders projection also omits it. The final field source/pass-through and derivation remain unresolved.
- Annual payment lag5 is the capex fraction at t-5 with denominator assets at t-6, subject to consecutive-year checks. Code preserves missingness and does not state the intended lower source bound. The parent quarterly filter/drop similarly does not prove a single preceding quarter makes every lag available.
- The work item allowed exact SAS catalog probes and bounded approved checks. No author program or study dataset was run; no source file was edited; execution_verified remains false.
