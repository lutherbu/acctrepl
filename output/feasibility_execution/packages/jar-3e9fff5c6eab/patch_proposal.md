# Patch proposal: jar-3e9fff5c6eab

Involvement of Component Auditors in Multinational Group Audits: Determinants and Audit Outcomes

DOI: 10.1111/1475-679X.12418

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied Stata data-construction workflow from code/0_Master.do through Final_step10.dta and the final identifier-roster load, including the supplied code 12 construction of discretionary-accrual and discretionary-revenue measures.

Entry points: `code/0_Master.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 4/12418 - Involvement-of-Component-Auditors-in-Multinational-Group-Audits-Determinants-and-Audit-Outcomes/cstv-datasheet-code-and-identifiers.zip",
      "sha256": "6db0ca40e16225a794bc8b71bef82d5d91b5dff5f1d299e1b42298d4a314aa3c"
    },
    {
      "path": "JAR-Volume 60/Issue 4/12418 - Involvement-of-Component-Auditors-in-Multinational-Group-Audits-Determinants-and-Audit-Outcomes/cstv-online-appendix.pdf",
      "sha256": "6643d9a9293fc16ef945b45aff95bc39aed0b75b68fa87cf7b3d8272f3faca7e"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "6b6ddaa45b89a889e5827bf98bc39f4fc9bf7c1d238f45c2fa33d9a824205e60"
}
```

## Proposed actions

### A_MASTER_AND_PACKAGE_PATHS: In a working copy, use the relative project root and align master paths to the exact supplied files.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISSUE_BASE_CONFIGURATION, ISSUE_MASTER_PATHS, REQ_IDENTIFIER_SAMPLE
Evidence: E_MASTER_BASE, E_MASTER_CALLS, E_MASTER_FINAL, E_APPEND_STAGE, E_SUBS_STAGE, E_PROBE_IDENTIFIER

**Proposed edit:** `code/0_Master.do:19–19`
Source SHA-256: `6be043bd8890aa020e94da948f5a0ccc9deece00cbf314f54149109df7f816dc`

The README permits relative Stata paths; run from the copied project root containing code/ and data/.

Current text:
```
global base "\CSTV_GroupAudits"
```

Proposed replacement:
```
global base "."
```

**Proposed edit:** `code/0_Master.do:56–56`
Source SHA-256: `6be043bd8890aa020e94da948f5a0ccc9deece00cbf314f54149109df7f816dc`

Use the exact supplied append/selection source filename.

Current text:
```
do ".\code\9_Append_Data Selection.do"
```

Proposed replacement:
```
do ".\code\9_Append_DataSelection.do"
```

**Proposed edit:** `code/0_Master.do:60–60`
Source SHA-256: `6be043bd8890aa020e94da948f5a0ccc9deece00cbf314f54149109df7f816dc`

Use the exact supplied subsidiary source filename.

Current text:
```
do ".\code\Subsidiary_Data.do"
```

Proposed replacement:
```
do ".\code\10_Subsidiary_Data.do"
```

**Proposed edit:** `code/0_Master.do:80–80`
Source SHA-256: `6be043bd8890aa020e94da948f5a0ccc9deece00cbf314f54149109df7f816dc`

Use the exact packaged plural identifier-roster filename.

Current text:
```
use ".\data\Identifier_Final Sample.dta"
```

Proposed replacement:
```
use ".\data\Identifiers_Final Samples.dta"
```

Preparation / proposed procedure:

1. Start the later Stata session from the copied root that contains code/ and data/ so global base=. resolves consistently.
2. Keep the supplied original files unchanged and apply these path edits only to the working copy.

Validation to perform later:

- Before execution, confirm every master call matches a supplied code file and the identifier roster exists at its exact relative path.

### A_AUDIT_INTERMEDIATE_PATHS: Align the packaged audit workbook name and all 2006-2013 audit intermediates with code 3's data/ output directory.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISSUE_AUDIT_PATHS, REQ_AUDIT_FEES
Evidence: E_AUDIT_SOURCE, E_PROBE_AUDIT_FEES, E_STAGE4_AUDIT_PATHS, E_STAGE4_2013_OUTPUT

**Proposed edit:** `code/3_Generate_UNSW_Audit_Data.do:8–8`
Source SHA-256: `bd6195344974e5d660228c43ab3f85207cafb4325f99b2514a9374aaa7febcc0`

Use the exact packaged workbook path.

Current text:
```
import excel ".\data\Audit_Fee.xlsx", sheet("Audit_Fee") firstrow
```

Proposed replacement:
```
import excel ".\data\Audit_Fee_2006-2013.xlsx", sheet("Audit_Fee") firstrow
```

**Proposed edit:** `code/4_SPPR_Merge_AspectHuntley_Merge_UNSWAudit.do:39–39`
Source SHA-256: `fbe6347a10c79c73f4e4a6f2fbe6295584d86a95e138c04b22f732fa8af93f0e`

Read the annual file from the data/ directory where code 3 saves it.

Current text:
```
merge 1:1 groupcoycode using "Audit_Fee2006.dta" 
```

Proposed replacement:
```
merge 1:1 groupcoycode using ".\data\Audit_Fee2006.dta" 
```

**Proposed edit:** `code/4_SPPR_Merge_AspectHuntley_Merge_UNSWAudit.do:53–53`
Source SHA-256: `fbe6347a10c79c73f4e4a6f2fbe6295584d86a95e138c04b22f732fa8af93f0e`

Read the annual file from the data/ directory where code 3 saves it.

Current text:
```
merge 1:1 groupcoycode using "Audit_Fee2007.dta" 
```

Proposed replacement:
```
merge 1:1 groupcoycode using ".\data\Audit_Fee2007.dta" 
```

**Proposed edit:** `code/4_SPPR_Merge_AspectHuntley_Merge_UNSWAudit.do:67–67`
Source SHA-256: `fbe6347a10c79c73f4e4a6f2fbe6295584d86a95e138c04b22f732fa8af93f0e`

Read the annual file from the data/ directory where code 3 saves it.

Current text:
```
merge 1:1 groupcoycode using "Audit_Fee2008.dta" 
```

Proposed replacement:
```
merge 1:1 groupcoycode using ".\data\Audit_Fee2008.dta" 
```

**Proposed edit:** `code/4_SPPR_Merge_AspectHuntley_Merge_UNSWAudit.do:81–81`
Source SHA-256: `fbe6347a10c79c73f4e4a6f2fbe6295584d86a95e138c04b22f732fa8af93f0e`

Read the annual file from the data/ directory where code 3 saves it.

Current text:
```
merge 1:1 groupcoycode using "Audit_Fee2009.dta" 
```

Proposed replacement:
```
merge 1:1 groupcoycode using ".\data\Audit_Fee2009.dta" 
```

**Proposed edit:** `code/4_SPPR_Merge_AspectHuntley_Merge_UNSWAudit.do:95–95`
Source SHA-256: `fbe6347a10c79c73f4e4a6f2fbe6295584d86a95e138c04b22f732fa8af93f0e`

Read the annual file from the data/ directory where code 3 saves it.

Current text:
```
merge 1:1 groupcoycode using "Audit_Fee2010.dta" 
```

Proposed replacement:
```
merge 1:1 groupcoycode using ".\data\Audit_Fee2010.dta" 
```

**Proposed edit:** `code/4_SPPR_Merge_AspectHuntley_Merge_UNSWAudit.do:109–109`
Source SHA-256: `fbe6347a10c79c73f4e4a6f2fbe6295584d86a95e138c04b22f732fa8af93f0e`

Read the annual file from the data/ directory where code 3 saves it.

Current text:
```
merge 1:1 groupcoycode using "Audit_Fee2011.dta" 
```

Proposed replacement:
```
merge 1:1 groupcoycode using ".\data\Audit_Fee2011.dta" 
```

**Proposed edit:** `code/4_SPPR_Merge_AspectHuntley_Merge_UNSWAudit.do:123–123`
Source SHA-256: `fbe6347a10c79c73f4e4a6f2fbe6295584d86a95e138c04b22f732fa8af93f0e`

Read the annual file from the data/ directory where code 3 saves it.

Current text:
```
merge 1:1 groupcoycode using "Audit_Fee2012.dta" 
```

Proposed replacement:
```
merge 1:1 groupcoycode using ".\data\Audit_Fee2012.dta" 
```

**Proposed edit:** `code/4_SPPR_Merge_AspectHuntley_Merge_UNSWAudit.do:137–137`
Source SHA-256: `fbe6347a10c79c73f4e4a6f2fbe6295584d86a95e138c04b22f732fa8af93f0e`

Read the annual file from the data/ directory where code 3 saves it.

Current text:
```
merge 1:1 groupcoycode using "Audit_Fee2013.dta" 
```

Proposed replacement:
```
merge 1:1 groupcoycode using ".\data\Audit_Fee2013.dta" 
```

Validation to perform later:

- Statically verify code 3 saves Audit_FeeYYYY.dta under data/ and code 4 reads each 2004-2013 file from the same directory; the provided workbook covers 2006-2013, so retain the authored empty early-year outputs if generated.

### A_STAGE6_AND_STAGE8_PATHS: Repair the 2011 stage 6 output separator and point all stage 8 annual-return inputs to stage 7's data/ outputs.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISSUE_STAGE_PATHS
Evidence: E_STAGE6_2011_PATH, E_STAGE8_PRICE_PATH, E_STAGE7_INPUT, E_STAGE7_RETURN_FIELDS

**Proposed edit:** `code/6_Merge_SPPRprice.do:117–117`
Source SHA-256: `bb923300eb32d7049f2573c60323c374ce1aa3324a7859ed14d80fc9ade88f79`

Restore the data/ separator required by the stage 8 consumer.

Current text:
```
save ".\data2011SPPR_Financial_Audit_Prices.dta", replace
```

Proposed replacement:
```
save ".\data\2011SPPR_Financial_Audit_Prices.dta", replace
```

**Proposed edit:** `code/8_Merge_AnnualReturn.do:15–15`
Source SHA-256: `458f3ca3ea2516d1c295c0f7ed16c423b49c2851de63c9371b9601051875ee76`

Read the annual-return intermediate from the data/ directory where code 7 saves it.

Current text:
```
merge 1:1 id1 using "Price2000.dta" 
```

Proposed replacement:
```
merge 1:1 id1 using ".\data\Price2000.dta" 
```

**Proposed edit:** `code/8_Merge_AnnualReturn.do:38–38`
Source SHA-256: `458f3ca3ea2516d1c295c0f7ed16c423b49c2851de63c9371b9601051875ee76`

Read the annual-return intermediate from the data/ directory where code 7 saves it.

Current text:
```
merge 1:1 id1 using "Price2001.dta" 
```

Proposed replacement:
```
merge 1:1 id1 using ".\data\Price2001.dta" 
```

**Proposed edit:** `code/8_Merge_AnnualReturn.do:61–61`
Source SHA-256: `458f3ca3ea2516d1c295c0f7ed16c423b49c2851de63c9371b9601051875ee76`

Read the annual-return intermediate from the data/ directory where code 7 saves it.

Current text:
```
merge 1:1 id1 using "Price2002.dta" 
```

Proposed replacement:
```
merge 1:1 id1 using ".\data\Price2002.dta" 
```

**Proposed edit:** `code/8_Merge_AnnualReturn.do:84–84`
Source SHA-256: `458f3ca3ea2516d1c295c0f7ed16c423b49c2851de63c9371b9601051875ee76`

Read the annual-return intermediate from the data/ directory where code 7 saves it.

Current text:
```
merge 1:1 id1 using "Price2003.dta" 
```

Proposed replacement:
```
merge 1:1 id1 using ".\data\Price2003.dta" 
```

**Proposed edit:** `code/8_Merge_AnnualReturn.do:107–107`
Source SHA-256: `458f3ca3ea2516d1c295c0f7ed16c423b49c2851de63c9371b9601051875ee76`

Read the annual-return intermediate from the data/ directory where code 7 saves it.

Current text:
```
merge 1:1 id1 using "Price2004.dta" 
```

Proposed replacement:
```
merge 1:1 id1 using ".\data\Price2004.dta" 
```

**Proposed edit:** `code/8_Merge_AnnualReturn.do:130–130`
Source SHA-256: `458f3ca3ea2516d1c295c0f7ed16c423b49c2851de63c9371b9601051875ee76`

Read the annual-return intermediate from the data/ directory where code 7 saves it.

Current text:
```
merge 1:1 id1 using "Price2005.dta" 
```

Proposed replacement:
```
merge 1:1 id1 using ".\data\Price2005.dta" 
```

**Proposed edit:** `code/8_Merge_AnnualReturn.do:153–153`
Source SHA-256: `458f3ca3ea2516d1c295c0f7ed16c423b49c2851de63c9371b9601051875ee76`

Read the annual-return intermediate from the data/ directory where code 7 saves it.

Current text:
```
merge 1:1 id1 using "Price2006.dta" 
```

Proposed replacement:
```
merge 1:1 id1 using ".\data\Price2006.dta" 
```

**Proposed edit:** `code/8_Merge_AnnualReturn.do:176–176`
Source SHA-256: `458f3ca3ea2516d1c295c0f7ed16c423b49c2851de63c9371b9601051875ee76`

Read the annual-return intermediate from the data/ directory where code 7 saves it.

Current text:
```
merge 1:1 id1 using "Price2007.dta" 
```

Proposed replacement:
```
merge 1:1 id1 using ".\data\Price2007.dta" 
```

**Proposed edit:** `code/8_Merge_AnnualReturn.do:199–199`
Source SHA-256: `458f3ca3ea2516d1c295c0f7ed16c423b49c2851de63c9371b9601051875ee76`

Read the annual-return intermediate from the data/ directory where code 7 saves it.

Current text:
```
merge 1:1 id1 using "Price2008.dta" 
```

Proposed replacement:
```
merge 1:1 id1 using ".\data\Price2008.dta" 
```

**Proposed edit:** `code/8_Merge_AnnualReturn.do:222–222`
Source SHA-256: `458f3ca3ea2516d1c295c0f7ed16c423b49c2851de63c9371b9601051875ee76`

Read the annual-return intermediate from the data/ directory where code 7 saves it.

Current text:
```
merge 1:1 id1 using "Price2009.dta" 
```

Proposed replacement:
```
merge 1:1 id1 using ".\data\Price2009.dta" 
```

**Proposed edit:** `code/8_Merge_AnnualReturn.do:245–245`
Source SHA-256: `458f3ca3ea2516d1c295c0f7ed16c423b49c2851de63c9371b9601051875ee76`

Read the annual-return intermediate from the data/ directory where code 7 saves it.

Current text:
```
merge 1:1 id1 using "Price2010.dta" 
```

Proposed replacement:
```
merge 1:1 id1 using ".\data\Price2010.dta" 
```

**Proposed edit:** `code/8_Merge_AnnualReturn.do:268–268`
Source SHA-256: `458f3ca3ea2516d1c295c0f7ed16c423b49c2851de63c9371b9601051875ee76`

Read the annual-return intermediate from the data/ directory where code 7 saves it.

Current text:
```
merge 1:1 id1 using "Price2011.dta" 
```

Proposed replacement:
```
merge 1:1 id1 using ".\data\Price2011.dta" 
```

**Proposed edit:** `code/8_Merge_AnnualReturn.do:291–291`
Source SHA-256: `458f3ca3ea2516d1c295c0f7ed16c423b49c2851de63c9371b9601051875ee76`

Read the annual-return intermediate from the data/ directory where code 7 saves it.

Current text:
```
merge 1:1 id1 using "Price2012.dta" 
```

Proposed replacement:
```
merge 1:1 id1 using ".\data\Price2012.dta" 
```

**Proposed edit:** `code/8_Merge_AnnualReturn.do:314–314`
Source SHA-256: `458f3ca3ea2516d1c295c0f7ed16c423b49c2851de63c9371b9601051875ee76`

Read the annual-return intermediate from the data/ directory where code 7 saves it.

Current text:
```
merge 1:1 id1 using "Price2013.dta" 
```

Proposed replacement:
```
merge 1:1 id1 using ".\data\Price2013.dta" 
```

**Proposed edit:** `code/8_Merge_AnnualReturn.do:337–337`
Source SHA-256: `458f3ca3ea2516d1c295c0f7ed16c423b49c2851de63c9371b9601051875ee76`

Read the annual-return intermediate from the data/ directory where code 7 saves it.

Current text:
```
merge 1:1 id1 using "Price2014.dta" 
```

Proposed replacement:
```
merge 1:1 id1 using ".\data\Price2014.dta" 
```

**Proposed edit:** `code/8_Merge_AnnualReturn.do:360–360`
Source SHA-256: `458f3ca3ea2516d1c295c0f7ed16c423b49c2851de63c9371b9601051875ee76`

Read the annual-return intermediate from the data/ directory where code 7 saves it.

Current text:
```
merge 1:1 id1 using "Price2015.dta" 
```

Proposed replacement:
```
merge 1:1 id1 using ".\data\Price2015.dta" 
```

Validation to perform later:

- Statically compare all 16 stage 8 PriceYYYY.dta inputs with code 7's matching data/ output names.

### A_RESOLVE_STAGE6_PRODUCERS: Resolve the intended source or producer for the six stage 6 SPPR_Financial_Audit inputs not produced by stage 4.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_INTERMEDIATE_CLOSURE
Evidence: E_STAGE4_LAST_YEAR, E_STAGE4_2013_OUTPUT, E_STAGE6_NEWER_INPUTS, E_STAGE6_2000_INPUT

Preparation / proposed procedure:

1. Identify how the supplied workflow intends to create 2000-2003 and 2014-2015 SPPR_Financial_Audit files.
2. Retain every annual branch and the authored sample; do not fabricate or drop years while resolving the producer.

Validation to perform later:

- Before execution, map every stage 6 year to exactly one compatible producer and verify the required company/date/financial/audit fields.

### A_ACQUIRE_ASPECT_AND_SPPR: Provision the documented Australian Aspect Huntley financial product and SIRCA SPPR company and monthly-price inputs through an authorized compatible route.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_ASPECT, REQ_SPPR_COMPANY, REQ_SPPR_PRICE
Evidence: E_DOC_PRODUCT_SOURCES, E_ASPECT_FIELDS, E_SPPR_COMPANY_SOURCE, E_STAGE5_PRICE_FIELDS, E_CATALOG_LOOKUP_01

Preparation / proposed procedure:

1. Obtain Aspect records with asxcode/date/prelim/itemid/value and the years needed by the supplied annual build, including 2004 for two-year lags in 2006.
2. Obtain the 2015 SPPR company/listing table and prices00.xlsx through prices15.xlsx with their company and month keys.
3. Confirm the product fields, identifiers, historical coverage and units before use; do not replace the Australian Aspect/SPPR routes with US CRSP/Compustat products or impose byte-identical vintage files as a gate.

Validation to perform later:

- Compare the product, expected fields, units, year history and groupcoycode/ASX-code matching to the supplied source requirements before running the construction.

### A_ACQUIRE_ANNUAL_RETURN_INPUTS: Resolve the separate PriceYYYY annual-return workbook chain and its company-month key mapping.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_ANNUAL_RETURN_SOURCE, ISSUE_SPPR_KEY_CONTRACT
Evidence: E_STAGE7_RETURN_FIELDS, E_STAGE8_RETURN_MERGE, E_DOC_PRODUCT_SOURCES, E_CATALOG_LOOKUP_02

Preparation / proposed procedure:

1. Determine the intended source/export for Price2000.xlsx through Price2015.xlsx; stage 5's prices00.xlsx through prices15.xlsx do not produce these files.
2. Confirm grouptcode/ltdserial/pricerelative/ltdyr/ltdmo fields and equality of grouptcode-based month keys to the financial groupcoycode keys.
3. Retain the authored monthly log-relative formula with 11 lags and establish late-2005 history for target-year 2006.

Validation to perform later:

- Check all 16 year-specific inputs and company-month join coverage without altering the annual-return definition.

### A_VALIDATE_PACKAGED_MANUAL_INPUTS: Use the supplied author-prepared audit, partner/office, subsidiary, IFRS, location and generic ISO workbooks as the manual-input routes, validating only the actual field/year/key contracts still unresolved.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_AUDIT_FEES, REQ_PARTNER_OFFICE, REQ_SUBSIDIARIES, REQ_IFRS_ADOPTION, REQ_LOCATION_COVERAGE, REQ_ISO_RL
Evidence: E_STATIC_XLSX_INVENTORY, E_PROBE_AUDIT_FEES, E_PROBE_PARTNER, E_PROBE_SUBSIDIARIES, E_PROBE_IFRS, E_PROBE_LOCATION, E_PROBE_ISO, E_HAND_ENTERED_VALUES

Preparation / proposed procedure:

1. Keep the supplied 2006-2013 audit workbook and 2005-2013 partner/office workbook; the prepared 2005 data support 2006 lags, so no new raw historical recollection is requested.
2. Use the packaged country-adoption and location-coverage workbooks; preserve the explicit blank-GU drop and country renames.
3. Code 11 already supplies eight literal missing financial values; keep those replacements as authored and do not request their raw recollection again.
4. For the generic ISO workbook, verify the documented RL transformation and New Caledonia-to-FRA code before making an _RL working-copy alias.

Validation to perform later:

- Validate workbook schema and key/year coverage in the future working copy using the prescribed import path; do not open or recalculate workbooks in Office.

### A_RESOLVE_GDP_CROSSWALK: Obtain or construct the GDP-specific territory crosswalk required by code 14, preserving the supplied generic workbook as a starting candidate only.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_COUNTRY_CROSSWALKS, REQ_ISO_GDP
Evidence: E_PROBE_ISO, E_CROSSWALK_GDP_DETAIL

Preparation / proposed procedure:

1. Confirm the source-supported SUBS-to-ISO assignments for GDP where country/territory coverage differs from Rule of Law.
2. Do not copy the generic workbook to the _GDP filename until its GDP-specific assignments are verified.

Validation to perform later:

- Compare the GDP crosswalk population and identifiers to countrycode/yr2006-yr2013 before merging.

### A_ACQUIRE_COUNTRY_SERIES: Acquire and prepare the documented CEPII distance, WGI Rule-of-Law estimate and World Bank GDP-per-capita sources in the country fields, units and periods consumed by code 14; target-code/territory coverage still requires row-level confirmation.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_CEPII, REQ_WGI, REQ_WB_GDP
Evidence: E_CEPII_INPUT, E_COUNTRY_INPUTS, E_GDP_INPUT, E_DOC_COUNTRY_SOURCES, E_CATALOG_LOOKUP_01, E_CATALOG_LOOKUP_02, E_CEPII_PUBLIC_LANDING, E_CEPII_PUBLIC_DYADIC_FILE, E_CEPII_PUBLIC_DIST_FIELD, E_WGI_PUBLIC_SERIES, E_WGI_PUBLIC_PERIOD, E_WGI_PUBLIC_UPDATE, E_WB_GDP_PUBLIC_INDICATOR, E_WB_GDP_PUBLIC_PERIOD, E_PUBLIC_SOURCE_METADATA_ARTIFACT

Preparation / proposed procedure:

1. Prepare CEPII's documented dyadic `dist_cepii.dta` fields `iso_o`, `iso_d` and `dist`; retain the code's Australia-origin filter, subsidiary-country mapping and existing distance calculation.
2. Use WGI series `GOV_WGI_RL_EST` for 2006-2013 and prepare the code's `RL_raw.xlsx` Sheet1 layout with `ISOCountryCode` and `RL2006`-`RL2013`; preserve the specified New Caledonia-to-FRA RL mapping, m:m merge and explicit RL imputations.
3. Use WDI indicator `NY.GDP.PCAP.CD` in current US dollars for 2006-2013; prepare the code's `ISOCountryCode` and `yr2006`-`yr2013` fields, retain its separate GDP territory map and authored average/log construction.

Validation to perform later:

- Confirm the prepared rows cover the subsidiary ISO/territory codes and required country-years; source-level documentation does not establish the package's exact country coverage.
- Record WGI and GDP source versions and retain their source units and history; the source code notes current GDP values may differ from its 2019 download.
- Preserve the native `dist` measure, Australia-origin filter, `m:m` joins, author filters, averaging/log construction, and explicit RL imputations.

### A_RL_FILTER_WORKING_COPY: In the working copy, add the explicit `if` to the Rule-of-Law using-only merge filter, matching the source's adjacent GDP filter while preserving the m:m join and subsequent author handling.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: REQ_WGI
Evidence: E_CROSSWALK_RL_DETAIL, E_CROSSWALK_GDP_DETAIL

**Proposed edit:** `code/14_SubsidiaryCountry Variables.do:254–254`
Source SHA-256: `110af3e073c9d38e4b10dbcec7a27118a53b276c21c9b3c259cd57f1f6ee6672`

The Rule-of-Law branch follows its m:m merge with `drop _merge==2`; the corresponding GDP branch in the same source uses `drop if _merge==2`. This proposes the explicit same-filter form without changing the merge type, target rows, later `drop _merge`, or RL imputations.

Current text:
```
drop _merge==2
```

Proposed replacement:
```
drop if _merge==2
```

Preparation / proposed procedure:

1. Apply only the one-line working-copy edit at code/14_SubsidiaryCountry Variables.do:254.
2. Keep the original m:m merge, right-only row filter, following `drop _merge`, and all explicit RL imputation statements.

Validation to perform later:

- Review the edit statically against the adjacent GDP branch and preserve all authored sample and missing-value decisions; no syntax or statistical trial was run.

### A_RESOLVE_SUBSIDIARY_JOIN: Resolve the company-key mapping between the supplied Subsidiaries.dta and Final_step4 before editing the merge.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_SUBSIDIARY_JOIN, REQ_SUBSIDIARIES
Evidence: E_SUBSIDIARY_JOIN, E_PROBE_SUBSIDIARIES, E_PROBE_IDENTIFIER

Preparation / proposed procedure:

1. Confirm how the historical ASX_CODE and YEAR in Subsidiaries.dta map to groupcoycode and year_SPPR in Final_step4.
2. Preserve the author-defined company identity and uniqueness; do not substitute an ASX-only join unless the source mapping supports it.

Validation to perform later:

- Check key uniqueness, historical identifier mapping and company-year coverage against the supplied merge specification before running stage 10.

### A_RESOLVE_PAYABLES_PRODUCER: Resolve the AccountsPayable.dta handoff without assuming a new independent raw source.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_PAYABLES_PRODUCER
Evidence: E_AP_CONSUMER, E_PAYABLES_FIELDS, E_ASPECT_FIELDS

Preparation / proposed procedure:

1. Confirm the intended producer and source-field mapping for value349, value301 and value2600 keyed by groupcoycode/year_SPPR.
2. First determine whether this prepared table is derived from the already-required Aspect financial input; only request a distinct input if the author's source contract requires it.
3. Confirm the lag history needed for 2006-2013 turnover measures.

Validation to perform later:

- Compare fields, keys, units and time history with code 13 before constructing Final_step8.

### A_STATA_ADDON_SETUP: Prepare the Stata ado environment with the three source-invoked add-on commands not found by metadata checks.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_WINSOR2, SW_FILLMISSING, SW_WBOPENDATA
Evidence: E_PROBE_ENVIRONMENT, E_PROBE_FILLMISSING, E_PROBE_WBOPENDATA, E_FINANCIAL_LAGS, E_PAYABLES_FIELDS, E_CROSSWALK_GDP_DETAIL

Preparation / proposed procedure:

1. Install or configure winsor2, fillmissing and wbopendata in the intended Stata ado path before author execution.
2. Verify each actual command with Stata which/version metadata; no package was installed during this assessment.

Validation to perform later:

- Use the assigned software metadata helper or an equivalent self-written which probe only; do not run package examples or author data code.

### A_RUN_SUPPLIED_WORKFLOW: After the documented data, key contracts, source repairs and Stata add-ons are ready, run the complete supplied data-construction master in Stata 18 from the working-copy project root.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: ISSUE_BASE_CONFIGURATION, ISSUE_MASTER_PATHS, ISSUE_AUDIT_PATHS, ISSUE_STAGE_PATHS, ISSUE_INTERMEDIATE_CLOSURE, ISSUE_SPPR_KEY_CONTRACT, ISSUE_SUBSIDIARY_JOIN, ISSUE_PAYABLES_PRODUCER, ISSUE_COUNTRY_CROSSWALKS
Evidence: E_MASTER_BASE, E_MASTER_EARLY_CALLS, E_MASTER_LATE_CALLS, E_FINAL_TRACE

Preparation / proposed procedure:

1. From the copied root containing code/ and data/, run: stata -b do code/0_Master.do.
2. Retain the Stata log and inspect Final_step10.dta plus the final identifier roster for the authored 2006-2013 sample, joins, units and missingness.
3. The assessment itself does not execute any author program or estimator.

Validation to perform later:

- Review completed source-to-output handoffs, preserve all years/branches and the eight code 11 replacements, and compare final sample construction to the supplied data sheet/appendix.


## Remaining issues and prerequisites

- ISSUE_BASE_CONFIGURATION [preparation; full_pipeline]: Master sets global base to the Windows-style path \CSTV_GroupAudits. A Linux working copy needs a relative project-root base with Stata started from the directory containing code/ and data/.
- ISSUE_MASTER_PATHS [preparation; full_pipeline]: Master calls code/9_Append_Data Selection.do and code/Subsidiary_Data.do, but the supplied programs are code/9_Append_DataSelection.do and code/10_Subsidiary_Data.do. The final roster read also uses Identifier_Final Sample.dta while the package contains Identifiers_Final Samples.dta.
- ISSUE_AUDIT_PATHS [preparation; full_pipeline]: Code 3 imports Audit_Fee.xlsx although the package supplies Audit_Fee_2006-2013.xlsx; code 4 saves/reads annual Audit_FeeYYYY files under data/ for 2004-2005 but reads 2006-2013 files relative to base while code 3 saves them under data/.
- ISSUE_STAGE_PATHS [preparation; full_pipeline]: Stage 6 writes the 2011 merged-price output to data2011... without the directory separator; stage 8 reads every PriceYYYY.dta relative to base although stage 7 saves them under data/.
- ISSUE_INTERMEDIATE_CLOSURE [unresolved; full_pipeline]: Stage 6 reads 2015 down to 2000 SPPR_Financial_Audit files; stage 4 produces only 2004-2013. The 2000-2003 and 2014-2015 intermediates have no producer in the supplied master chain. Preserve the calls and annual branches pending the intended producer/source contract.
- ISSUE_SPPR_KEY_CONTRACT [unresolved; full_pipeline]: Stage 5 keys price rows from grouptcode/ltdmo, stage 6 creates a company-month key from financial groupcoycode/month, and stage 7/8 similarly join grouptcode to groupcoycode. The separate raw workbooks are absent, so the key-value and month alignment are not verified.
- ISSUE_SUBSIDIARY_JOIN [unresolved; full_pipeline]: The packaged Subsidiaries.dta probe lists ASX_CODE and YEAR but no groupcoycode. Code 10 renames those to asxcode and year_SPPR, then merges using groupcoycode/year_SPPR. A historically valid company-key mapping and uniqueness contract is needed; do not substitute ASX code without support.
- ISSUE_PAYABLES_PRODUCER [unresolved; full_pipeline]: Code 13 reads AccountsPayable.dta without a supplied producer. It uses value349, value301 and value2600 with lags and groupcoycode/year_SPPR; these fields may be derivable from the already-required Aspect panel, so no independent raw-source requirement is assumed.
- ISSUE_COUNTRY_CROSSWALKS [unresolved; full_pipeline]: The supplied generic SUBS/ISO workbook has the expected headers and may support the source-specified distance/RL mapping, including New Caledonia mapped to FRA; its rows and full target coverage were not value-checked. Code 14 explicitly says GDP availability differs for territories/special administrative regions and expects a separate _GDP map, which is not established by the generic workbook.
- REQ_ASPECT [undetermined]: Australian listed-firm financial records consumed by the supplied Aspect build, keyed by ASX code/date/preliminary status/item ID and value. The code creates annual files 2000-2014; the 2006 target's two-year lag calculations require 2004 financial history.
- REQ_SPPR_COMPANY [undetermined]: SPPR company/listing records used to map time-invariant groupcoycode values to the latest ASX code and listing intervals for the annual financial merge.
- REQ_SPPR_PRICE [undetermined]: SPPR monthly price inputs prices00.xlsx through prices15.xlsx used by stage 5 and merged with company-month records in stage 6.
- REQ_ANNUAL_RETURN_SOURCE [undetermined]: Separate Price2000.xlsx through Price2015.xlsx monthly input workbooks used by stage 7 to construct annual returns from monthly log price relatives.
- REQ_SUBSIDIARIES [undetermined]: Author-prepared Australian listed-firm subsidiary country counts and indicators used for subsidiary totals, regions, distance, IFRS, rule-of-law, GDP and location coverage.
- REQ_ISO_RL [undetermined]: Subsidiary-name to ISO country-code mapping used with the World Bank Rule-of-Law records; the code documents the distance mapping with New Caledonia mapped to FRA.
- REQ_ISO_GDP [undetermined]: Subsidiary-name to ISO country-code mapping for GDP records, with territory/special-administration mappings distinct from the Rule-of-Law map.
- REQ_CEPII [public_acquisition_required]: CEPII GeoDist country-pair distances used to compute Australia-to-subsidiary-country average distance.
- REQ_WGI [public_acquisition_required]: World Bank Worldwide Governance Indicators Rule-of-Law estimates for subsidiary countries in 2006-2013, prepared in the format consumed by code 14.
- REQ_WB_GDP [public_acquisition_required]: World Bank GDP per capita, current US dollars, for subsidiary countries in 2006-2013, using indicator NY.GDP.PCAP.CD.
- SW_WINSOR2 [preparation_required]: Code 12 and code 13 invoke winsor2; the frozen Stata metadata snapshot reports it not found in the checked adopaths.
- SW_FILLMISSING [preparation_required]: Code 14 invokes fillmissing and contains ssc install fillmissing; the bounded which probe did not find the command.
- SW_WBOPENDATA [preparation_required]: Code 14 invokes wbopendata for indicator NY.GDP.PCAP.CD and contains ssc install wbopendata; the bounded which probe did not find the command.

## Review notes

- Title context: the frozen assessment header remains ‘Involvement of Component Auditors in Multinational Group Audits: Determinants and Audit Outcomes’; the author datasheet and supplied master say ‘Involvement of Component Auditors in Multinational Group Audits: Determinants, Audit Quality and Audit Fees’. This is the minor descriptive/working-title wording variation identified by the frozen prompt; no material identity conflict or attribution prerequisite is supported.
- Static review is complete for the two supplied author documents, all 15 native Stata sources, the five manual-input workbooks, and all 124 dependency IDs. Resource-catalog and software metadata checks, workbook schema probes, and the documented source/path/action review are recorded. The official source pass checked CEPII GeoDist, WGI Rule of Law, and WDI GDP per capita; source-level fields and histories are recorded with exact official quotations and access date in the evidence and saved metadata probe.
- Specific gaps remain in current CEPII Australia-to-subsidiary dyad coverage, WGI/GDP coverage for each mapped subsidiary country and territory, and the separate GDP territory crosswalk. Other unresolved contracts remain the Aspect/SPPR source years and identifiers, missing stage-6 intermediate producers for 2000-2003 and 2014-2015, SPPR key/month alignment, the Subsidiaries ASX_CODE-to-groupcoycode/year mapping, and the AccountsPayable producer/lags. The provided audit, partner-office, IFRS, location-coverage and identifier inputs retain their documented manual roles; one-row/header probes do not establish full row coverage.
- The working-copy proposal retains the 30 source-supported path edits and adds one source-supported line-254 Rule-of-Law merge-filter repair. No author program, estimator, syntax check, data transformation, spreadsheet recalculation, statistical process, or dataset/API payload was run or fetched. Stata 18 metadata is available; the checked add-ons winsor2, fillmissing and wbopendata were not found in the checked adopaths. Execution readiness remains undetermined pending the specific source, key, year and environment preparations.
