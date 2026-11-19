# Patch proposal: jar-16f47f8318db

Disclosure Regulation and Corporate Acquisitions

DOI: 10.1111/1475-679X.12298

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | blocked |

### full_pipeline

Prepare every supplied Stata branch A–E, including SDC/country-month samples, separate 50% and 30% premium variants, and public, private and non-EU acquirer returns. Main paper-wide table estimators are contextual; the daily market-model regression used to create return variables stays in scope.

Entry points: `BDO.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 1/12298 - Disclosure-Regulation-and-Corporate-Acquisitions/bdo-datasheet-and-files.zip",
      "sha256": "a7468278c334563d23dddd5b5cec1c8f21c7c9b7ca55a490192492edda848085"
    },
    {
      "path": "JAR-Volume 58/Issue 1/12298 - Disclosure-Regulation-and-Corporate-Acquisitions/bdo-online-appendix.pdf",
      "sha256": "8630f1e8ae8795f4cb190743a55cc58527b11eebdcc65b290952a6033ec6722b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "aaa2d7f7de316e1272ee34cf598e5efc87d83b265b3d2b086b9d6a55f1d91a45"
}
```

## Proposed actions

### ACT_MONTH_LIFETIME: Keep the original month variable alive across Section A’s existing rename and restore sequence. month_b is used only to compose datadate_date_announced; its encoding is not a supported substitute for the FX month key.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISSUE_MONTH_LIFETIME, R_SDC_MAIN, R_FX
Evidence: EV_MONTH_DROP, EV_MONTH_RENAME, EV_MONTH_DATE, EV_MONTH_RESTORE, EV_FX

**Proposed edit:** `BDO.do:78–78`
Source SHA-256: `5a6fc58e8097744e0d838086a00b3236a16c45aa014467322dc898b6e38b3926`

The original month is renamed at line 90 and restored at line 114 for the currency merge. The separate abbreviation month_b is used to build the date string.

Current text:
```
drop month
```

Proposed replacement:
```
* preserve original month for its existing rename and currency join
```

Preparation / proposed procedure:

1. Retain the original month value while leaving the line-90 rename and line-114 restoration intact.
2. Keep month_b solely for the authored date-string construction.

Validation to perform later:

- After compatible inputs are staged, confirm the original month survives through the rename/restoration and compare its type and value encoding with the currency table key.

### ACT_FX_LINE_CLARIFICATION: Resolve the malformed line 124 using a validated conversion contract before editing; seek author clarification only if the factor field, units, direction or expression remain unknown.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_FX_LINE, R_FX, R_SDC_ADDON
Evidence: EV_FX_LINE, EV_FX, EV_SDC_EXTRA, EV_DOC_SOURCES

Preparation / proposed procedure:

1. Establish the factor field, units, date alignment, direction and value_USD formula from the input schema, metadata and documented construction; seek author clarification only for any remaining ambiguity.
2. Keep the CUSIP-pair/announcement-date add-on fields distinct from the FX table’s curcd/year/month join keys.
3. Apply the expression supported by the validated field, units and direction; do not guess a rate variable or invert the factor.

Validation to perform later:

- Check the corrected statements against the supplied field dictionary and a bounded matched example; then validate value_USD construction and missing merge rates before running all branches.

### ACT_TRANSACTION_INPUTS: Stage compatible transaction and policy inputs, preserving their separate merge keys, source populations and histories.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: ISSUE_INPUT_CLOSURE, ISSUE_INTL_CONTRACT, R_SDC_MAIN, R_SDC_ADDON, R_FX, R_POLICY_DATES, R_ACQ_TECH
Evidence: EV_SDC, EV_SDC_EXTRA, EV_FX, EV_POLICY, EV_TECH, EV_DOC_SOURCES, EV_CATALOG, EV_SDC_PROBE

Preparation / proposed procedure:

1. Supply an SDC transaction workbook or a demonstrably compatible extract, with actual query/extract filters, deal population, identifier mappings, exact field dictionary and required history. October 2016 is the documented vintage; a different-vintage extract is usable when its population, fields, history and transformations are shown compatible. If a required contract remains unknown, use clarification to resolve it; a demonstrated compatible extract need not match the original vintage.
2. Obtain swap_deals_new var.dta or its documented producer with Acquiror_CUSIP, Target__CUSIP and Date_Announced keys, bidder count, value and value_USD fields.
3. Provide the FX table with DKK, GBP, SEK and EUR coverage, its conversion-factor field, units, direction, month encoding and source vintage.
4. Provide swap_disc_regulation_update.dta and Acquisition_Technique_cleaned.dta with their country/date and transaction keys, field definitions and covered periods.
5. Treat SDC.WRDS_MA_DETAILS as a local product candidate only; its one-row probe does not establish extract population, history, ISIN coverage or field compatibility. Assess those properties from the actual extract and its metadata/transformation contract; author clarification may resolve a remaining gap but is not a prerequisite when compatibility is demonstrated.

Validation to perform later:

- Check each file’s stated keys, fields, types, uniqueness and period against the corresponding merges before preparing the downstream branches.

### ACT_COUNTRY_CROSSWALKS: Supply the consumed country, listing, public-status, regulation, ownership and macro-control tables together with the manual/public/commercial handoffs that produced them.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: ISSUE_INPUT_CLOSURE, ISSUE_INTL_CONTRACT, R_GERMAN, R_AIM, R_PUBLIC_STATUS, R_FILL, R_LISTED, R_MKT_CONTROL, R_GOV_BOND, R_GDP, R_GFCF, R_CONS, R_ANTI, R_INST, R_OWN
Evidence: EV_GERMAN, EV_AIM, EV_PUBLIC, EV_FILL, EV_LISTED, EV_MKT, EV_BOND, EV_GDP, EV_GFCF, EV_CONS, EV_ANTI, EV_INST, EV_OWN, EV_DOC_SOURCES, EV_DOC_COUNTRY, EV_CATALOG, EV_PUB_WB, EV_PUB_EUROSTAT

Preparation / proposed procedure:

1. Provide the author-compatible german neu market.dta, AIM_def.dta, EU_public_firms.dta and filling obs_new.dta, including ISIN/country/date/year keys and the exact public-status and monthly-grid rules.
2. Provide number_listed firms.dta, mkt_control_.dta and interest rate/gov_bond_10y.dta with country/year or country/month keys, units and underlying population.
3. Provide gdp_per_capita.dta, Gross capital formation.dta and final consumption expenditures.dta with exact World Bank/Eurostat series identifiers, country codes, calendar/fiscal-year definitions, quarter labels, units and adjustment conventions.
4. Provide anti_takeover country level.dta, inst _ inv.dta and own conc country level.dta with country mapping, source-to-country crosswalk, field dictionary, aggregation rules and vintages. The datasheet cites EC, Amadeus/BvD, FactSet/LionShares, Kaufmann, Christensen and ECB inputs; it does not establish current entitlement or compatible coverage.
5. Use the exact prepared author tables if available; otherwise request their manual lookup/crosswalk and preparation handoff. Do not substitute a one-row catalog candidate or assume a public series is the author’s exact measure.

Validation to perform later:

- Reconcile ISO/country names, ISIN validity periods, month/year/quarter keys, units, missing-value rules and join cardinality against each merge before running the sample.

### ACT_EVENT_RETURN_INPUTS: Obtain compatible target, public-acquirer and non-EU-acquirer return panels and the identifier/index handoffs needed to construct the authored event windows.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: ISSUE_INPUT_CLOSURE, ISSUE_RETURN_HISTORY, ISSUE_INTL_CONTRACT, R_TARGET_RET, R_ACQ_RET, R_NON_EU_RET
Evidence: EV_TARGET_PRICE, EV_ACQ_PRICE, EV_NON_EU, EV_EVENT_DATE, EV_EST, EV_CAR, EV_CUSIP_PROBE, EV_DOC_CUSIP, EV_DOC_SOURCES, EV_DS_RI_PROBE, EV_DS_MAP_PROBE, EV_DS_INDEX_PROBE, EV_CATALOG

Preparation / proposed procedure:

1. Provide price_file.dta, price_file_acq_returns.dta and acq new returns/acq new returns.dta or the author-defined Datastream extraction and transformation contracts for these distinct target, public-acquirer and non-EU panels.
2. Specify ISIN/security mapping validity, event populations, primary/listing-market choice, daily return and price fields, market-index series, currency/adjustment rules and lower history bound. Preserve the separate non-EU group_isin handoff and subdirectory.
3. Retain the exact event-date match, estimation observations t−253 through t−127, CAR coverage through t+126, and the authored shorter windows beginning at −63 and −41; the code has an upper event cutoff of 2011-12-31 but no lower bound.
4. Use cusip_TARGET.xlsx only as the supplied identifier list it is; its two stake sheets and bounded sample do not establish daily return coverage or a Datastream-to-ISIN history.

Validation to perform later:

- Verify exact event-date anchors and available observations at each required relative day for every in-scope event; separately check market-index alignment and non-EU/security mapping.

### ACT_BRANCH_HANDOFFS: Resolve the missing producer and exact sample contracts for the separate public 50%, public 30% and private-target handoffs without collapsing their aliases or membership rules.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_INPUT_CLOSURE, ISSUE_VARIANTS, R_LIST50, R_TYPE50, R_PAYMENT, R_OTHER50, R_TOE50, R_LIST30, R_TYPE30, R_OTHER30, R_TOE30, R_TYPE_PRIVATE
Evidence: EV_PROD3, EV_LIST50, EV_LIST30, EV_TYPE50, EV_TYPE30, EV_TYPE_PRIVATE, EV_PAYMENT, EV_OTHER50, EV_TOE50, EV_OTHER30, EV_TOE30

Preparation / proposed procedure:

1. Request the producer and exact keys/population for target_list_to_merge 50 50.dta and target_list_to_merge 30 30.dta; BDO.do writes only target_list_tomerge.dta, so do not assume a rename or common membership.
2. Obtain type_50_50.dta, type_30_30.dta and type_private.dta, plus the distinct 50% and 30% other-bidder/toehold files and swap_deals_payment.dta, with field definitions and matched-only merge behavior.
3. Preserve each 50%, 30%, private/public and payment branch as supplied, including Acquiror_CUSIP, Target__CUSIP, isin and Date_Announced key alignment.

Validation to perform later:

- Compare the producer output schemas and sample membership separately for each branch before appending or merging; confirm no alias points to a file from a different population.

### ACT_PORTABLE_PATHS: Replace the hard-coded Windows data root with the configured working root and normalize every source read/write path separator across BDO.do.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISSUE_PATHS, R_SDC_MAIN, R_FX, R_GOV_BOND, R_NON_EU_RET
Evidence: EV_ROOT, EV_SDC, EV_FX, EV_BOND, EV_NON_EU

**Proposed edit:** `BDO.do:30–30`
Source SHA-256: `5a6fc58e8097744e0d838086a00b3236a16c45aa014467322dc898b6e38b3926`

Use the configured working root and consistent host-independent separators while preserving the authored subdirectory and filename.

Current text:
```
global location "[redacted-path-ce57d062a4f5]"
```

Proposed replacement:
```
global location "."
```

**Proposed edit:** `BDO.do:32–32`
Source SHA-256: `5a6fc58e8097744e0d838086a00b3236a16c45aa014467322dc898b6e38b3926`

Use the configured working root and consistent host-independent separators while preserving the authored subdirectory and filename.

Current text:
```
import excel "excel file\M&A master EU RA.xlsx", sheet("M&A master EU RA") firstrow
```

Proposed replacement:
```
import excel "excel file/M&A master EU RA.xlsx", sheet("M&A master EU RA") firstrow
```

**Proposed edit:** `BDO.do:121–121`
Source SHA-256: `5a6fc58e8097744e0d838086a00b3236a16c45aa014467322dc898b6e38b3926`

Use the configured working root and consistent host-independent separators while preserving the authored subdirectory and filename.

Current text:
```
merge m:1 curcd year month using "exchange_rate\currency_file.dta" // currency exchange rates by currency-year-month from the Federal Reserve of Saint Louis - FRED Database
```

Proposed replacement:
```
merge m:1 curcd year month using "exchange_rate/currency_file.dta" // currency exchange rates by currency-year-month from the Federal Reserve of Saint Louis - FRED Database
```

**Proposed edit:** `BDO.do:337–337`
Source SHA-256: `5a6fc58e8097744e0d838086a00b3236a16c45aa014467322dc898b6e38b3926`

Use the configured working root and consistent host-independent separators while preserving the authored subdirectory and filename.

Current text:
```
merge m:1 country month_year using "interest rate\gov_bond_10y.dta", gen(_merge_i)
```

Proposed replacement:
```
merge m:1 country month_year using "interest rate/gov_bond_10y.dta", gen(_merge_i)
```

**Proposed edit:** `BDO.do:573–573`
Source SHA-256: `5a6fc58e8097744e0d838086a00b3236a16c45aa014467322dc898b6e38b3926`

Use the configured working root and consistent host-independent separators while preserving the authored subdirectory and filename.

Current text:
```
merge m:1 country month_year using "interest rate\gov_bond_10y.dta", gen(_merge_i)
```

Proposed replacement:
```
merge m:1 country month_year using "interest rate/gov_bond_10y.dta", gen(_merge_i)
```

**Proposed edit:** `BDO.do:940–940`
Source SHA-256: `5a6fc58e8097744e0d838086a00b3236a16c45aa014467322dc898b6e38b3926`

Use the configured working root and consistent host-independent separators while preserving the authored subdirectory and filename.

Current text:
```
merge m:1 country month_year using "interest rate\gov_bond_10y.dta"
```

Proposed replacement:
```
merge m:1 country month_year using "interest rate/gov_bond_10y.dta"
```

**Proposed edit:** `BDO.do:1157–1157`
Source SHA-256: `5a6fc58e8097744e0d838086a00b3236a16c45aa014467322dc898b6e38b3926`

Use the configured working root and consistent host-independent separators while preserving the authored subdirectory and filename.

Current text:
```
merge m:1 country month_year using "interest rate\gov_bond_10y.dta"
```

Proposed replacement:
```
merge m:1 country month_year using "interest rate/gov_bond_10y.dta"
```

**Proposed edit:** `BDO.do:1442–1442`
Source SHA-256: `5a6fc58e8097744e0d838086a00b3236a16c45aa014467322dc898b6e38b3926`

Use the configured working root and consistent host-independent separators while preserving the authored subdirectory and filename.

Current text:
```
					 merge 1:m isin using "acq new returns\acq new returns.dta", gen(_merge_deal)
```

Proposed replacement:
```
					 merge 1:m isin using "acq new returns/acq new returns.dta", gen(_merge_deal)
```

**Proposed edit:** `BDO.do:1481–1481`
Source SHA-256: `5a6fc58e8097744e0d838086a00b3236a16c45aa014467322dc898b6e38b3926`

Use the configured working root and consistent host-independent separators while preserving the authored subdirectory and filename.

Current text:
```
					 capture save "acq new returns\acq_`y'NEW.dta"
```

Proposed replacement:
```
					 capture save "acq new returns/acq_`y'NEW.dta"
```

**Proposed edit:** `BDO.do:1488–1488`
Source SHA-256: `5a6fc58e8097744e0d838086a00b3236a16c45aa014467322dc898b6e38b3926`

Use the configured working root and consistent host-independent separators while preserving the authored subdirectory and filename.

Current text:
```
				capture use "acq new returns\acq_`y'NEW.dta", clear
```

Proposed replacement:
```
				capture use "acq new returns/acq_`y'NEW.dta", clear
```

**Proposed edit:** `BDO.do:1490–1490`
Source SHA-256: `5a6fc58e8097744e0d838086a00b3236a16c45aa014467322dc898b6e38b3926`

Use the configured working root and consistent host-independent separators while preserving the authored subdirectory and filename.

Current text:
```
				capture save "acq new returns\acq_`y'_dNEW.dta"
```

Proposed replacement:
```
				capture save "acq new returns/acq_`y'_dNEW.dta"
```

**Proposed edit:** `BDO.do:1494–1494`
Source SHA-256: `5a6fc58e8097744e0d838086a00b3236a16c45aa014467322dc898b6e38b3926`

Use the configured working root and consistent host-independent separators while preserving the authored subdirectory and filename.

Current text:
```
use "acq new returns\acq_1_dNEW.dta", clear
```

Proposed replacement:
```
use "acq new returns/acq_1_dNEW.dta", clear
```

**Proposed edit:** `BDO.do:1496–1496`
Source SHA-256: `5a6fc58e8097744e0d838086a00b3236a16c45aa014467322dc898b6e38b3926`

Use the configured working root and consistent host-independent separators while preserving the authored subdirectory and filename.

Current text:
```
				append using "acq new returns\acq_`y'_dNEW.dta"
```

Proposed replacement:
```
				append using "acq new returns/acq_`y'_dNEW.dta"
```

**Proposed edit:** `BDO.do:1500–1500`
Source SHA-256: `5a6fc58e8097744e0d838086a00b3236a16c45aa014467322dc898b6e38b3926`

Use the configured working root and consistent host-independent separators while preserving the authored subdirectory and filename.

Current text:
```
save "acq new returns\acq ret_nonEU.dta"
```

Proposed replacement:
```
save "acq new returns/acq ret_nonEU.dta"
```

**Proposed edit:** `BDO.do:1507–1507`
Source SHA-256: `5a6fc58e8097744e0d838086a00b3236a16c45aa014467322dc898b6e38b3926`

Use the configured working root and consistent host-independent separators while preserving the authored subdirectory and filename.

Current text:
```
append using "acq new returns\acq ret_nonEU.dta"
```

Proposed replacement:
```
append using "acq new returns/acq ret_nonEU.dta"
```

**Proposed edit:** `BDO.do:1756–1756`
Source SHA-256: `5a6fc58e8097744e0d838086a00b3236a16c45aa014467322dc898b6e38b3926`

Use the configured working root and consistent host-independent separators while preserving the authored subdirectory and filename.

Current text:
```
merge m:1 country month_year using "interest rate\gov_bond_10y.dta"
```

Proposed replacement:
```
merge m:1 country month_year using "interest rate/gov_bond_10y.dta"
```

Preparation / proposed procedure:

1. Run Stata with the working directory set to the directory that contains the staged author inputs and the excel file, exchange_rate, interest rate and acq new returns subdirectories.
2. Set global location to the relative working root and convert every affected backslash in BDO.do to a forward slash; keep all authored subdirectories and filenames unchanged.

Validation to perform later:

- Before running, check each read and write path resolves beneath the chosen root, including repeated bond merges and all non-EU loop reads/writes.

### ACT_POST_STAGE_RUN: After compatible inputs, producer handoffs and supported source corrections are available, attempt the complete supplied A–E Stata workflow and inspect each saved branch output.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: ISSUE_INPUT_CLOSURE, ISSUE_MONTH_LIFETIME, ISSUE_FX_LINE, ISSUE_VARIANTS, ISSUE_RETURN_HISTORY, ISSUE_PATHS
Evidence: EV_BRANCH, EV_STATA_PROBE, EV_SETTINGS_PROBE, EV_WINSOR_PROBE, EV_PROD1, EV_PROD3, EV_PROD10, EV_PROD18

Preparation / proposed procedure:

1. Use the available Stata 18 environment and start from the configured data root with all required input files and subdirectories staged.
2. Apply the supported month-lifetime edit, the FX expression supported by the validated field/units/direction contract, and the complete path configuration before running BDO.do. Clarify with the authors only if the FX contract remains unresolved.
3. Run the supplied sections in their authored order; retain all 50%, 30%, public, non-EU and private branches. Capture a Stata log and inspect commands wrapped in capture as well as the generated output files.
4. Do not consume unsupported target-list/type/toehold aliases until their exact producers and sample compatibility are supplied.

Validation to perform later:

- Check each expected generated file exists at the next consumer, inspect keys, row counts and merge outcomes, and verify target/acquirer event history against the required relative windows. Record execution status only after that run; this assessment does not execute author code.


## Remaining issues and prerequisites

- ISSUE_MONTH_LIFETIME [blocking; full_pipeline]: Section A constructs the original month from announcement-date text at line 57; month_b is an abbreviation used only in the date string at line 88. Line 78 drops the original month before line 90 renames it, and line 114 renames it back before the currency merge at line 121. Preserve the original variable through this sequence; its external key type/encoding is not documented.
- ISSUE_FX_LINE [blocking; full_pipeline]: Line 124 combines rate multiplication and destring text on one Stata source line. The actual conversion-factor field and direction are unknown, so the intended replacement cannot be guessed.
- ISSUE_INPUT_CLOSURE [unresolved; full_pipeline]: Many direct source files and manual/prepared joins are absent. Requirements record each consumed filename and its actual keys/fields; authors must supply matching files or exact producers and field/history dictionaries.
- ISSUE_VARIANTS [unresolved; full_pipeline]: The script writes target_list_tomerge.dta but consumes distinct 50% and 30% target-list aliases; no producer is shown for these aliases, type_50_50/type_30_30/type_private, or the branch-specific toehold files. Preserve each branch until same-key and population compatibility is documented.
- ISSUE_RETURN_HISTORY [unresolved; full_pipeline]: Daily target/acquirer event inputs need exact event-date matches, t−253…t−127 estimation observations and returns through t+126. Prepared files, event population and lower date bound are not supplied; catalog probes read one row only.
- ISSUE_INTL_CONTRACT [unresolved; full_pipeline]: The SDC base is worldwide but treatment country, lower history bound, market/exchange population and SDC-to-ISIN handoffs are unspecified. Datastream price/index definitions and Amadeus/BvD and FactSet/LionShares country aggregates remain separate, unverified source contracts; local probes/catalog metadata do not prove entitlement or coverage.
- ISSUE_PATHS [preparation; full_pipeline]: BDO.do hardcodes a Windows G: root and backslash subdirectories. A host-visible relative execution root and consistent paths across all read/write calls are needed; preserve exchange_rate, interest rate and acq new returns subdirectories.
- R_SDC_MAIN [undetermined]: SDC transaction workbook imported from excel file/M&A master EU RA.xlsx; downstream code needs deal keys, stakes, status, countries, SIC and ISIN identifiers. Author extract vintage, population and lower date bound are not supplied.
- R_SDC_ADDON [undetermined]: swap_deals_new var.dta adds bidder count and transaction values to SDC rows using CUSIP pair and announcement date. Its producer and schema are absent.
- R_FX [undetermined]: Monthly currency factors join on curcd/year/month; code maps DKK, GBP, SEK and EUR by target country. The factor column, units/direction and a malformed code line remain unresolved.
- R_POLICY_DATES [undetermined]: swap_disc_regulation_update.dta supplies country-specific directive start dates consumed by B/C/D/E, including exact datadate_start_date* fields in the source.
- R_ACQ_TECH [undetermined]: Acquisition_Technique_cleaned.dta classifies matched transactions and gates the included deal sample.
- R_GERMAN [undetermined]: german neu market.dta identifies targets on the German Neuer Markt by ISIN.
- R_AIM [undetermined]: AIM_def.dta identifies AIM targets by ISIN and Date_Announced.
- R_PUBLIC_STATUS [undetermined]: EU_public_firms.dta classifies target public status by ISIN/year; code comment says Datastream merged with BvD.
- R_FILL [undetermined]: filling obs_new.dta adds the country/year/month/target_public grid before fillin.
- R_LISTED [undetermined]: number_listed firms.dta supplies country/year listed-firm counts used in the pre-TD scaling denominator.
- R_MKT_CONTROL [undetermined]: mkt_control_.dta provides market size and return-volatility controls by country/month.
- R_GOV_BOND [undetermined]: gov_bond_10y.dta supplies a country/month ten-year government yield control attributed to FRED.
- R_GDP [undetermined]: gdp_per_capita.dta contains country/year gdp_capita, which the code logs.
- R_GFCF [undetermined]: Gross capital formation.dta is merged quarterly; the datasheet calls the investment measure gross fixed capital formation, leaving the exact family unresolved.
- R_CONS [undetermined]: final consumption expenditures.dta supplies the country/year/quarter consumption control.
- R_ANTI [undetermined]: anti_takeover country level.dta supplies regulatory quality, anti-takeover provisions and shareholder-identification controls; datasheet lineage spans EC, Kaufmann, Christensen and ECB sources.
- R_INST [undetermined]: inst _ inv.dta supplies country-level institutional ownership; datasheet reports FactSet/LionShares May 2017.
- R_OWN [undetermined]: own conc country level.dta supplies country ownership structure; datasheet reports Amadeus/BvD October 2016.
- R_TARGET_RET [undetermined]: price_file.dta supplies target daily returns and market returns for event-study construction. Code requires exact announcement-date match, t−253…−127 estimation, and CAR windows through t+126 plus shorter −63/−41 windows.
- R_LIST50 [undetermined]: target_list_to_merge 50 50.dta supplies public 50% premium-branch membership; BDO.do only writes target_list_tomerge.dta.
- R_TYPE50 [undetermined]: type_50_50.dta gates the public 50% premium sample by a matched-only merge.
- R_PAYMENT [undetermined]: swap_deals_payment.dta supplies CASH, STOCK and MIXED variables in public 50%, 30% and private branches.
- R_OTHER50 [undetermined]: other_bidders_toehold SEP 50 50.dta is a distinct required matched input in the public 50% branch.
- R_TOE50 [undetermined]: toehold 50 50.dta is a second distinct required matched input in the public 50% branch.
- R_LIST30 [undetermined]: target_list_to_merge 30 30.dta supplies public 30% premium-branch membership; BDO.do only writes target_list_tomerge.dta.
- R_TYPE30 [undetermined]: type_30_30.dta gates the public 30% premium sample by a matched-only merge.
- R_OTHER30 [undetermined]: other_bidders_toehold SEP 30 30.dta is a distinct required matched input in the public 30% branch.
- R_TOE30 [undetermined]: toehold 30 30.dta is a second distinct required matched input in the public 30% branch.
- R_ACQ_RET [undetermined]: price_file_acq_returns.dta supplies public-acquirer daily returns for public-target and private-target branches.
- R_NON_EU_RET [undetermined]: acq new returns/acq new returns.dta supplies a separate non-EU acquirer return panel; code uses group_isin over a 224-event loop.
- R_TYPE_PRIVATE [undetermined]: type_private.dta gates the private-target/acquirer-return branch through a matched-only merge.

## Review notes

- Full BDO.do, datasheet and online appendix were read. The CUSIP workbook is identifiers in separate final-stake sheets; its bounded probe does not establish full-data coverage.
- Only the exact SDC and Datastream local catalog candidates were inspected with bounded one-row reads; no US dataset was substituted. These probes do not establish full coverage, license entitlement or author compatibility.
- The code imposes an upper announcement cutoff of 2011-12-31 but no lower date bound. History requirements are stated relative to each event where the code supports them.
- The 19 frozen dependency edges are all dispositioned; the draft also enumerates direct source/prepared inputs and producer handoffs beyond those edges, with linked actions.
- Month-key review: month_b is used only in the announcement-date string; preserve the original numeric-text month through its existing rename/restore and FX-merge sequence. External key type/encoding remains unverified.
