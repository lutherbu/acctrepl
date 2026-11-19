# Patch proposal: jar-55682f28e520

Boosting Foreign Investment: The Role of Certification of Corporate Governance

DOI: 10.1111/1475-679X.12468

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied master_file.do data-preparation workflow, including both ACGS edition branches, two distinct FactSet branches, the authored merge/update and vendor-preparation stages, through ASEAN_final_file.dta. The supplied code stops at a prepared analysis dataset and contains no paper-wide final regression or result-table estimation commands.

Entry points: `master_file.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 1/12468 - Boosting-Foreign-Investment-The-Role-of-Certification-of-Corporate-Governance/bodatasheetcodeandidentifiers.zip",
      "sha256": "342e6a5ae8397fba8429a84d5d065eba4c198f357ff8b557a83faed42a9e14e6"
    },
    {
      "path": "JAR-Volume 61/Issue 1/12468 - Boosting-Foreign-Investment-The-Role-of-Certification-of-Corporate-Governance/bo-online-appendix.pdf",
      "sha256": "001f65d7c06a2cdd98f5a53a99aa3661b3fd15c86bbd659f46ce99ab787aeeb9"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "635706117d9184e4d08d11c44c4190087937ff04e5eda8e0399b91a8848b39d2"
}
```

## Proposed actions

### A_STAGE_RELATIVE_ROOT: In a working copy of master_file.do, replace each of the seven identical Windows cd statements with cd "." and change the two DATA ASEAN workbook path separators to forward slashes. Stage execution at the project root with DATA ASEAN/ present so all existing relative input/output names resolve consistently; keep the original source unchanged.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_WINDOWS_PATH
Evidence: E_DO_ACGS_OLD, E_DO_ACGS_LATER, E_DO_SHARES_HANDOFF, E_DO_STOCK_HANDOFF, E_DO_WGI, E_DO_ANALYST_FINAL, E_WORKFLOW_TRACE

**Proposed edit:** `master_file.do:21–21`
Source SHA-256: `8ef57d5d6c5d72b8eaa7d1fe2e68cf0d18d25620c946db30f9c7f788476019b3`

Make the root portable under the staged execution working directory while preserving the source's relative filenames and branch sequence.

Current text:
```
cd "[redacted-path-95daac1b8eca]"
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `master_file.do:58–58`
Source SHA-256: `8ef57d5d6c5d72b8eaa7d1fe2e68cf0d18d25620c946db30f9c7f788476019b3`

Make the root portable under the staged execution working directory while preserving the source's relative filenames and branch sequence.

Current text:
```
cd "[redacted-path-95daac1b8eca]"
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `master_file.do:933–933`
Source SHA-256: `8ef57d5d6c5d72b8eaa7d1fe2e68cf0d18d25620c946db30f9c7f788476019b3`

Make the root portable under the staged execution working directory while preserving the source's relative filenames and branch sequence.

Current text:
```
cd "[redacted-path-95daac1b8eca]"
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `master_file.do:950–950`
Source SHA-256: `8ef57d5d6c5d72b8eaa7d1fe2e68cf0d18d25620c946db30f9c7f788476019b3`

Make the root portable under the staged execution working directory while preserving the source's relative filenames and branch sequence.

Current text:
```
cd "[redacted-path-95daac1b8eca]"
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `master_file.do:978–978`
Source SHA-256: `8ef57d5d6c5d72b8eaa7d1fe2e68cf0d18d25620c946db30f9c7f788476019b3`

Make the root portable under the staged execution working directory while preserving the source's relative filenames and branch sequence.

Current text:
```
cd "[redacted-path-95daac1b8eca]"
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `master_file.do:999–999`
Source SHA-256: `8ef57d5d6c5d72b8eaa7d1fe2e68cf0d18d25620c946db30f9c7f788476019b3`

Make the root portable under the staged execution working directory while preserving the source's relative filenames and branch sequence.

Current text:
```
cd "[redacted-path-95daac1b8eca]"
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `master_file.do:1020–1020`
Source SHA-256: `8ef57d5d6c5d72b8eaa7d1fe2e68cf0d18d25620c946db30f9c7f788476019b3`

Make the root portable under the staged execution working directory while preserving the source's relative filenames and branch sequence.

Current text:
```
cd "[redacted-path-95daac1b8eca]"
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `master_file.do:22–22`
Source SHA-256: `8ef57d5d6c5d72b8eaa7d1fe2e68cf0d18d25620c946db30f9c7f788476019b3`

Use a relative forward-slash path for the workbook subdirectory so the prepared staging root resolves on the approved host.

Current text:
```
import excel "DATA ASEAN\data_2012_2017_1_all.xls", sheet("Sheet1") firstrow clear
```

Proposed replacement:
```
import excel "DATA ASEAN/data_2012_2017_1_all.xls", sheet("Sheet1") firstrow clear
```

**Proposed edit:** `master_file.do:59–59`
Source SHA-256: `8ef57d5d6c5d72b8eaa7d1fe2e68cf0d18d25620c946db30f9c7f788476019b3`

Use a relative forward-slash path for the workbook subdirectory so the prepared staging root resolves on the approved host.

Current text:
```
import excel "DATA ASEAN\data_2017_on_all.xls", sheet("Sheet1") firstrow clear
```

Proposed replacement:
```
import excel "DATA ASEAN/data_2017_on_all.xls", sheet("Sheet1") firstrow clear
```

Preparation / proposed procedure:

1. Create a working copy of master_file.do and make all nine line-specific path replacements recorded here.
2. Stage required inputs at the root and preserve the DATA ASEAN subfolder expected by both workbook imports.
3. Use the approved Stata host wrapper with a relative or supported [redacted-path-5102ec1c040f] path; do not place an absolute Dropbox workspace path into executable configuration.

Validation to perform later:

- Before any authorized run, text-check that the seven cd statements use the staged relative root and both DATA ASEAN imports use forward slashes; verify all other relative input/output references remain consistent.
- Confirm the staged root is visible and writable to the host wrapper and contains each required named input.
- Retain the workflow through ASEAN_final_file.dta without adding estimators absent from the supplied code.

### A_CLOSE_INPUT_PRODUCERS: Obtain the release-specific producer, compatible prepared file or authorized route, schema, keys and coverage for the fifteen unresolved non-WGI direct inputs. Stage WGI through its verified public route using A_WGI_PUBLIC_PREPARATION; do not use a broken catalog helper or undocumented raw-source reconstruction to infer availability.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_INPUT_CLOSURE
Evidence: E_WORK_ITEM, E_DO_INPUT_GAPS, E_WORKFLOW_TRACE, E_CATALOG_CANDIDATES

Preparation / proposed procedure:

1. Resolve these fifteen named inputs separately: data_2012_2017_1_all.xls; data_2017_on_all.xls; factset_data.dta; factset_dataII.dta; fuzzy_matching_def_cleaned_isin.dta; fuzzy_matching_def_cleaned_isin_2017.dta; _merge_d_2012_2017.dta; _merge_d_2017.dta; scores_lead_def.dta; Accounting_vars.dta; Mkt_vars.dta; Accounting_vars__II.dta; number_shares_tempI.dta; stock_price_data.dta; and following_def_DEF.dta.
2. Acquire and stage the verified public WGI standard-unit estimates through the separate WGI action; reuse the source-coded 2010 country filters, Country rename and spelling adjustment.
3. Keep the ACGS editions, FactSet extracts, fuzzy crosswalks and manual updates as separate source stages.

Validation to perform later:

- Map every direct read in the 78-event ordered workflow trace to a supplied input or a specifically documented producer.
- Confirm no missing input remains grouped under a generic placeholder and no required branch is omitted.

### A_ACGS_WORKBOOKS: Request the two author-prepared ACGS score/Top 50 workbooks through the authors' documented access route, together with the field definitions and edition coverage needed by each branch. The datasheet describes the score/ranking data as proprietary author-supplied material.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_ACGS_OLD, R_ACGS_LATER
Evidence: E_DS_SOURCES, E_DO_ACGS_OLD, E_DO_ACGS_LATER, E_WORK_ITEM

Preparation / proposed procedure:

1. Obtain DATA ASEAN/data_2012_2017_1_all.xls and DATA ASEAN/data_2017_on_all.xls as distinct prepared inputs or receive an author-documented compatible replacement for each.
2. Request the workbook schemas, score definitions, edition/year coverage and authorized handling terms; do not infer an open download route from the source description.

Validation to perform later:

- Check that each workbook has the Sheet1 and header layout expected by its separate import and supports the corresponding edition branch.
- Verify the imported keys and score fields against the downstream merge/reshape statements without exposing row-level identifiers.

### A_FACTSET_EXTRACTS: Request the distinct author-prepared FactSet/LionShares extracts and their schemas through an authorized documented route. A product/catalog miss does not establish that either vendor source is unavailable or that this environment has no entitlement.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_FACTSET_EARLY, R_FACTSET_2017
Evidence: E_DS_SOURCES, E_DO_FACTSET_EARLY, E_DO_FACTSET_2017, E_CATALOG_CANDIDATES

Preparation / proposed procedure:

1. Obtain factset_data.dta for the early edition branch and factset_dataII.dta for the distinct 2017 branch, or obtain separate documented compatible prepared extracts.
2. Request the field dictionary, download-vintage notes, identifier/date conventions and authorized access conditions for each table.

Validation to perform later:

- Check required firm/time/ownership fields and coverage for the source-coded event windows, including the prior history used by the transformations.
- Preserve both branch inputs and the code's separate manual-update handoffs.

### A_MATCH_CROSSWALKS: Request both edition-specific fuzzy matching crosswalks and both manual unmatched-observation update files, plus the matching/update rules that created them.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_MATCH_OLD, R_MATCH_LATER, R_MANUAL_MATCH_OLD, R_MANUAL_MATCH_2017
Evidence: E_DO_FUZZY_OLD, E_DO_FUZZY_LATER, E_DO_MANUAL_MATCHES, E_DO_MANUAL_MATCHES_2017, E_WORK_ITEM

Preparation / proposed procedure:

1. Obtain fuzzy_matching_def_cleaned_isin.dta and fuzzy_matching_def_cleaned_isin_2017.dta as separate prepared inputs with source and decision documentation.
2. Obtain _merge_d_2012_2017.dta and _merge_d_2017.dta with the author-described unmatched-observation update semantics and edition-specific fields.

Validation to perform later:

- Check the expected company-name/ISIN and merge-key columns, branch assignment and join behavior from the supplied code.
- Record matching decisions and manual-update provenance without printing row-level identifier values.

### A_SCORE_LEADS: Request scores_lead_def.dta or the exact author-specified construction of its lead score fields; this table is directly consumed but has no producer in the supplied do-file.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SCORE_LEADS
Evidence: E_DO_INPUT_GAPS, E_WORK_ITEM, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Request the table's ACGS edition source, score-column dictionary, lead-year convention, key definition and producer steps.
2. Use the author-prepared table if supplied rather than inferring a lead transformation from unrelated files.

Validation to perform later:

- Check the required isin/file_year merge and lead-score fields against the downstream score-change calculations.
- Confirm that source years and edition branches line up with the author's declared lead convention.

### A_ACCOUNTING_AND_MARKET_TABLES: Request the author-prepared accounting and market-variable tables with their complete producer and field-mapping notes. The registered catalog contains plausible Datastream/Worldscope raw candidates, but catalog metadata alone does not show live readability or establish the author's firm, year, currency, measure and lag/lead transformations.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ACCOUNTING_LAG, R_MARKET_CAP_LAG, R_ACCOUNTING_CURRENT_LEAD
Evidence: E_DS_SOURCES, E_DO_INPUT_GAPS, E_CATALOG_CANDIDATES, E_RESOURCE_CATALOG, E_WORK_ITEM

Preparation / proposed procedure:

1. Request Accounting_vars.dta, Mkt_vars.dta and Accounting_vars__II.dta as the primary author-prepared inputs, with variable definitions and t−1/t/t+1 year conventions.
2. If the author documents a raw-source alternative, resolve the Worldscope code-to-ISIN mapping and identify the appropriate fields/measures, including income choice, currency, units and fiscal-year timing.
3. Treat TRWS.WRDS_WS_FUNDA, TRWS.WRDS_WS_COMPANY and TR_DS.DS2MKTVAL only as catalog-listed candidates; do not assume access or map their columns without author or source documentation.

Validation to perform later:

- Confirm all required output fields map to the source-coded calculations and preserve the separate lag/current/lead table roles.
- Check key coverage, currency and unit conventions, fiscal-year alignment and the code's t−1/t/t+1 requirements before building the tables.

### A_SHARES_TABLE: Request number_shares_tempI.dta and its author-described producer as the primary route. The registered Datastream market-value table is a candidate for a documented alternative, not a verified substitute.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_SHARES
Evidence: E_DS_SOURCES, E_DO_SHARES_INPUT, E_DO_SHARES_HANDOFF, E_CATALOG_CANDIDATES, E_WORK_ITEM

Preparation / proposed procedure:

1. Obtain the prepared shares table or a complete authorized transformation from the catalog-listed TR_DS.DS2MKTVAL fields.
2. For any raw alternative, document the InfoCode-to-ISIN map, ValDate selection, consolidated share measure and the table's thousands scaling.

Validation to perform later:

- Check date and firm coverage for the program's quarterly mean/median windows and t−4 through t+4 quarters.
- Confirm units and keys before merging the generated shares panel into the main working file.

### A_DAILY_STOCK_TABLE: Request stock_price_data.dta and its exact producer, including the source for the market-return field and the event-date mappings. Catalogued Datastream quote/return-index tables are candidates only and do not establish the prepared input contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_STOCK_PRICES
Evidence: E_DS_SOURCES, E_DO_STOCK_INPUT, E_DO_STOCK_HANDOFF, E_CATALOG_CANDIDATES, E_WORK_ITEM

Preparation / proposed procedure:

1. Obtain the prepared daily firm price/return table or an author-documented compatible construction from TR_DS.DS2PRIMQTPRC and, if appropriate, TR_DS.DS2PRIMQTRI.
2. Resolve the security-to-ISIN mapping, exchange/currency and price-selection rules, market return series and each branch's event-date fields.

Validation to perform later:

- Verify daily coverage of event-date rows, the previous observation used for returns and the authored cumulative-return window.
- Check all required stock_price_data.dta columns and the produced car.dta join key before merging.

### A_WGI_PUBLIC_PREPARATION: Acquire the verified public 2026 WGI Stata product and stage its annual standard-unit estimates into the fields used by master_file.do. The supplied source already handles the required country selection and Country spelling conversion.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_WGI
Evidence: E_DO_WGI, E_WGI_PUBLIC_CATALOG, E_WGI_PUBLIC_DIMS, E_WGI_PUBLIC_PERIOD, E_WGI_PUBLIC_ACCESS, E_WGI_PUBLIC_LICENSE, E_WGI_PUBLIC_HOME, E_WGI_PUBLIC_ANNUAL, E_WGI_LITERAL_SOURCE_QA

Preparation / proposed procedure:

1. Acquire the catalog-listed public WGI 2026 Stata product when staging the full inputs; no access request or original-byte match is needed.
2. Select the standard-statistical-unit estimates for Regulatory Quality and Rule of Law, then reshape/rename the current source fields into the code's expected year, countryname, rqe and rle structure.
3. Retain the supplied 2010 country filter, countryname-to-Country rename and Philippines spelling adjustment in master_file.do.

Validation to perform later:

- Check the staged input has the required 2010 standard-unit estimates for both indicators and the source-coded country set.
- Confirm the staged fields support the existing do-file country operations and preserve the named ASEAN_final_file.dta endpoint.
- Record that the 2026 release recalculates historical values and may change output values; treat this as an output-fidelity note, not an access, compatibility or byte-identity gate.

### A_ANALYST_FOLLOWING: Request following_def_DEF.dta and its source/product and construction specification; the package and supplied do-file do not define the provenance of tot_following.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_ANALYST_FOLLOWING
Evidence: E_DO_ANALYST_FINAL, E_WORK_ITEM, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Obtain the prepared table or exact author-approved producer, including analyst-following field definition, reporting period and any threshold inputs.
2. Preserve the source-coded isin/file_year merge and country-year high/low construction.

Validation to perform later:

- Check the required keys and tot_following field against the final merge.
- Confirm the median-group construction inputs and period before preparing the final output.


## Remaining issues and prerequisites

- I_INPUT_CLOSURE [unresolved; full_pipeline]: Sixteen direct input files named by master_file.do are absent from the frozen package. The official public WGI product is a verified compatible route and needs routine acquisition/field staging; the remaining fifteen direct inputs still lack verified compatible prepared routes or complete producer/field/history contracts. Keep ACGS and FactSet editions distinct; catalogued Datastream/Worldscope tables remain raw candidates until their keys, units, dates and author transformations are established.
- I_WINDOWS_PATH [preparation; full_pipeline]: The do-file resets to the same Windows-only absolute directory at seven locations, and both DATA ASEAN workbook imports use Windows backslash separators. A staged working copy needs one consistent relative root and host-portable forward-slash subdirectory paths.
- R_ACGS_OLD [undetermined]: Author-provided first-edition ACGS score and Top 50 workbook consumed by the first-edition branch (`DATA ASEAN\data_2012_2017_1_all.xls`). It is absent from the frozen package inventory; its schema and covered editions remain unverified.
- R_ACGS_LATER [undetermined]: Separate author-provided subsequent-edition ACGS score and Top 50 workbook consumed by the later-edition branch (`DATA ASEAN\data_2017_on_all.xls`). It is absent from the frozen package inventory; its schema and covered editions remain unverified.
- R_FACTSET_EARLY [undetermined]: Separate author-prepared FactSet/LionShares quarterly foreign-institutional-ownership input used for the 2012–2015 edition branches, read as factset_data.dta and filtered before event-window reshaping. The exact file is absent; field and period compatibility remain unverified.
- R_FACTSET_2017 [undetermined]: Separate FactSet/LionShares quarterly foreign-institutional-ownership input for the 2017 edition branch, read as `factset_dataII.dta`. The exact data file is absent; field and period compatibility remain unverified.
- R_MATCH_OLD [undetermined]: First-edition author-created CompanyName-to-ISIN crosswalk read as `fuzzy_matching_def_cleaned_isin.dta`. The supplied code uses its `CompanyName` and `isin_fact` fields; the crosswalk's source, matching decisions and producer are not supplied.
- R_MATCH_LATER [undetermined]: Separate subsequent-edition CompanyName-to-ISIN crosswalk read as `fuzzy_matching_def_cleaned_isin_2017.dta`. The code uses its `CompanyName` and `isin_fact` fields; the crosswalk's source, matching decisions and producer are not supplied.
- R_MANUAL_MATCH_OLD [undetermined]: First-edition manual-match update table read as `_merge_d_2012_2017.dta` to update the FactSet-to-score merge on `isin` and `date_to_merge`. The exact source rows, updated columns, mapping rules and producer are not supplied.
- R_MANUAL_MATCH_2017 [undetermined]: Separate 2017 manual-match update table read as `_merge_d_2017.dta` to update the later-edition merge on `isin` and `date_to_merge`. The updated columns, source rows, mapping rules and producer are not supplied.
- R_SCORE_LEADS [undetermined]: Lead-score table read as `scores_lead_def.dta` and merged by `isin file_year` to construct score changes. The supplied do-file does not produce it; the exact lead-period construction and field/schema contract remain unverified.
- R_ACCOUNTING_LAG [undetermined]: Author-prepared accounting table `Accounting_vars.dta`, merged 1:1 on `isin file_year` and documented in the code comment as the t−1 accounting input. The supplied program computes leverage, size, ROA, ROE and sales/assets from its fields; its producer, field history and exact Datastream/WorldScope mapping are not supplied.
- R_MARKET_CAP_LAG [undetermined]: Author-prepared market-variable table `Mkt_vars.dta`, merged 1:1 on `isin file_year` and commented as t−1. The code forms `log_mkt` from `mkt`; the ownership of other later-used market fields is not established by the supplied producer code.
- R_ACCOUNTING_CURRENT_LEAD [undetermined]: Additional author-prepared current/lead accounting table `Accounting_vars__II.dta`, merged on `isin file_year` and commented as t and t+1. It supplies the current, lagged and lead values used for changes in accounting outcomes, book value and net margin; its producer and annual field mapping are absent.
- R_SHARES [undetermined]: Author-prepared share-count source table `number_shares_tempI.dta`. The code reads `isin`, `date_s`, `year`, `month` and `shares`, derives quarterly mean/median shares for its edition windows and merges the generated share panel into the main workfile. The producer and exact Datastream/WorldScope mapping are absent.
- R_STOCK_PRICES [undetermined]: Author-prepared daily stock-price input `stock_price_data.dta`. The supplied code reads firm/date/price and market-return fields plus the event-date fields, computes daily market-adjusted returns and CAR windows, and merges the produced CAR table into the prepared workfile. Exact event-date mapping and required observed-day coverage are not verified.
- R_WGI [public_acquisition_required]: WGI table used for 2010 Regulatory Quality and Rule of Law standard-unit estimates. The code expects year, countryname, rqe and rle, then applies its own country filtering, countryname-to-Country rename and Philippines spelling adjustment. The prepared wgidataset.dta is absent; the official current public Stata product is a compatible alternative requiring ordinary acquisition and field staging.
- R_ANALYST_FOLLOWING [undetermined]: Separate analyst-following table following_def_DEF.dta, merged on isin file_year and used through tot_following to create the country-year analyst-following indicator. The source, construction, field contract and period are not documented in the release.

## Review notes

- The assessment follows the full supplied preparation workflow and stops at ASEAN_final_file.dta; the do-file contains no final regression or table-estimation endpoint.
- The packaged list_identifiers.xls is separately identified in the datasheet but is not consumed by master_file.do, so it is not a required analysis input.
- The sixteen named direct input files are absent. WGI has a verified public current route; fifteen other inputs remain unresolved. Datastream and Worldscope catalog entries are raw candidates only; catalog metadata does not establish live access or author-specific construction.
- The official WGI product includes annual standard-unit estimates, 2010 is in coverage, and the code supplies its country selection/rename/spelling operations. The 2026 release recalculates history and may change output values; this is an output-fidelity note rather than an access, compatibility or byte-identity gate.
- All source edits are proposals only. The working copy retains both ACGS editions, both ownership branches, manual updates, all preparation stages and the supplied final dataset endpoint.
