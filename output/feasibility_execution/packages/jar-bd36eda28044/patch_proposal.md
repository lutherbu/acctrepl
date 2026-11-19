# Patch proposal: jar-bd36eda28044

Financial Gatekeepers and Investor Protection: Evidence from Criminal Background Checks

DOI: 10.1111/1475-679X.12265

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-supplied workflow for converting source data into main advisor/firm samples and estimating Tables 1–10, including the unresolved table-data handoff.

Entry points: `LawMills 2019 JAR Replication Codes Part 1 Convert Raw Data.do`, `LawMills 2019 JAR Replication Codes Part 2 Estimate Regressions.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 2/12265 - Financial-Gatekeepers-and-Investor-Protection-Evidence-from-Criminal-Background-Checks/lm-datasheet-and-code.zip",
      "sha256": "2162a99ac8345ca334923ef68e9a3f8b0ad360b0f89348f2e51bdcbcb740e141"
    },
    {
      "path": "JAR-Volume 57/Issue 2/12265 - Financial-Gatekeepers-and-Investor-Protection-Evidence-from-Criminal-Background-Checks/lm-online-appendix.pdf",
      "sha256": "7e45424d7a70afd37a973e91913302dece86cb93ad9c439e1172dbb6d7e81fe3"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "3d64b410c866683aa638e23f6819fe91a4951fa4fc2d0a0a9e8063d2b6704754"
}
```

## Proposed actions

### A001: Locate the 19 Part 1 inputs or compatible prepared equivalents, then verify each merge key and listed field set before using the two preparation branches. The author file names are path aliases, not a byte-identity requirement.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R001, R002, R003, R004, R005, R006, R007, R008, R009, R010, R011, R012, R013, R014, R015, R016, R017, R018, R019, I001
Evidence: E030, E031, E032, E033, E034, E035, E036, E037, E038, E039, E040, E041, E042, E043, E044, E045, E046, E047, E048, E001, E002, E016, E021, E022, E009

Preparation / proposed procedure:

1. Resolve or obtain the author-named advisor and firm .dta inputs listed by requirements R001–R019, or document a compatible author-prepared/source-derived route for each; do not treat the packaged CRD identifier list as the full sample.
2. Check every merge key and route expected_fields against the available source files, and keep the advisor gender, criminal-record, exclusion, firm-address, ADV, regulatory-event, and fee datasets separate.
3. For employment_combined.dta, verify complete employment-history coverage needed to form year and since; the raw scrape dates in the datasheet are acquisition dates, not coverage bounds.
4. For the static zip lookup, check whether catalog-listed SASHELP.ZIPCODE can be converted to the required Stata lookup fields zip/x/y/city/state/statecode/county/msa; verify only its actual zip/geography fit, without a generic author-vintage approval gate.
5. After the inputs are identified, map every Part 1 read and both save targets consistently to the chosen project root.

Validation to perform later:

- Use bounded metadata checks on each candidate .dta and compare actual fields to the requirement route; verify date/geography coverage separately where relevant.
- In a future authorized run, execute both Part 1 branches and confirm Main Advisor Sample.dta and Main Advisory Firm Sample.dta are written with the required join keys and downstream fields.

### A002: Identify the missing author producer stages or compatible prepared datasets for every Part 2 table input, and document the correct source/intermediate handoff from Part 1. Preserve the shared-input branches for Tables 4/10B and Tables 6/7A/10A.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R020, R021, R022, R023, R024, R025, R026, R027, R028, R029, R030, R031, I002
Evidence: E049, E050, E051, E052, E053, E054, E055, E056, E057, E058, E059, E060, E019, E020, E014, E015, E008, E023, E024

Preparation / proposed procedure:

1. Obtain the producer script or exact compatible prepared input for each table file R020–R031, including the direct Part 2 read Data for Table 06, 07A, and 10A.dta that is omitted from the frozen checklist.
2. Trace each table input from its real producer and source/intermediate; verify all fields listed on its requirement, identifiers, geography, period, and transformations against the consuming Part 2 block.
3. Confirm the intended mapping, if any, between Part 1 outputs and Part 2 names such as regfirm_90/highrisk_brokerage and lnbusinesstypecount/lnnum_business_lines; do not infer equivalence.
4. For Table 5, identify the specific ACS/Social Explorer product and vintage/geography fields through the author producer; for Table 9, map the CRSP Mutual Fund product to the exact table fields and confirm an accessible compatible route. Do not infer a license barrier from the catalog.
5. Once the bridge is established, preserve the Table 01A 2007–2017 yearly counts and all other table analyses as supplied.
6. For Table 8, inspect and preserve any time-series declaration, index, and frequency carried by the native Data for Table 08.dta. If no declaration is present, obtain the intended time variable/rule before adding one; do not guess or run a regression.

Validation to perform later:

- Before running Part 2, verify each named Data for Table*.dta file exists at the configured root and passes a bounded field/readability check against its expected_fields.
- After an authorized run, confirm each table block consumes the intended dataset in order and the shared Table 4/10B and Table 6/7A/10A datasets serve both documented result groups.

### A003: Check whether the shorter Table 06/07A/10A token settle resolves uniquely to the source variable settled_complaint before treating it as an issue.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I003
Evidence: E025, E026, E064

Preparation / proposed procedure:

1. Inspect the effective Stata varabbrev setting and the actual R027 input schema before execution.
2. If abbreviation is enabled and settled_complaint is the only field matched by settle, preserve the source spelling; no second field, author confirmation, or code edit is needed.
3. Ask for the intended field only if abbreviation is disabled, the prefix is ambiguous, or the schema shows that settle and settled_complaint are genuinely distinct fields.

Validation to perform later:

- Before an authorized run, confirm that the active setting resolves settle uniquely to settled_complaint in the actual input schema; if it does, retain the current source text.

### A004: Map the author’s coherent D: project tree to an accessible run root, keeping all Part 1 reads/writes and the Part 2 global path/log together.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I004
Evidence: E061, E062, E027, E063

Preparation / proposed procedure:

1. Choose or create the local project root corresponding to [redacted-path-0cbd15600f04] JAR Replications; this setup choice does not depend on identifying every input file.
2. Map all literal Part 1 use/merge/save paths and the Part 2 global path/log path to that root; changing only the Part 2 global does not update Part 1 literals.
3. Preserve the advisor/firm subdirectories and the Part 2 table-input locations under the common root; resolve the missing table-data handoff separately.

Validation to perform later:

- Before running, inspect every resolved input/output path to confirm it points to the intended file and directory, and confirm the log/output directories are writable.

### A005: Install or configure the community command packages needed by the actual Stata calls, then check the commands themselves in Stata 18.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S002, S003, S004, S005, I005
Evidence: E004, E005, E006, E007, E010, E011, E012, E013

Preparation / proposed procedure:

1. In a future authorized setup, install gtools (the package that supplies gduplicates, gcollapse, and gdistinct) and distinct from SSC, or configure equivalent existing copies on Stata’s adopath.
2. Keep reghdfe and its available ftools dependency as verified; the author code does not require esttab or other probed but unused commands.
3. Verify each exact entry point gduplicates, gcollapse, gdistinct, and distinct is found by Stata; confirm the gtools C plugin loads under Stata 18.

Validation to perform later:

- Use Stata which for each actual command and confirm plugin loading with a small self-written empty-session software probe before any author program/data run.


## Remaining issues and prerequisites

- I001 [unresolved; full_pipeline]: Part 1 directly reads 19 author-named .dta files from the [redacted-path-0cbd15600f04] JAR Replications tree. None of those files is in this package; the only packaged .dta is an individualid/CRD list, not a complete analysis input. The datasheet describes historical BrokerCheck scraping and Python parsing, but no scraper/parser is supplied. Locate compatible prepared inputs or a documented compatible route and verify fields/history; the old collection date alone does not establish observation coverage.
- I002 [unresolved; full_pipeline]: Part 1 writes Main Advisor Sample.dta and Main Advisory Firm Sample.dta, whereas Part 2 directly reads 12 separate Data for Table*.dta files, including the unlisted Data for Table 06, 07A, and 10A.dta. No supplied producer or handoff connects the Part 1 outputs to these table inputs, so the full table workflow order and schemas remain unknown. Keep source lineage conditional until the author bridge is identified: the datasheet reports ACS/Social Explorer for Census data and CRSP Mutual Fund/WRDS; catalog discovery did not verify a CRSP mutual-fund route, access, or entitlement. Table 8’s factor/portfolio source is also unspecified. Part 1’s regfirm_90, lnbusinesstypecount, and lnstatereg do not directly match Part 2’s highrisk_brokerage, lnnum_business_lines, and lnnum_state_reg; do not guess aliases.
- I003 [unresolved; full_pipeline]: The shared Table 06/07A/10A block uses settled_complaint in a regression and the shorter token settle in tabstat. The shorter token may be a valid unique Stata variable abbreviation. The table dataset and effective varabbrev setting are not available here, so this is not a confirmed field mismatch. Inspect the schema and active setting before execution; ask for clarification only if abbreviation is disabled, ambiguous, or intended to refer to a genuinely different field.
- I004 [preparation; full_pipeline]: Both scripts use a coherent [redacted-path-0cbd15600f04] JAR Replications project root: Part 1 uses its advisor/firm subdirectories, and Part 2 uses that root for its table inputs and log. Mapping this known tree to the Linux run environment is supported path preparation and can be chosen independently of the unresolved table-data producer.
- I005 [preparation; full_pipeline]: The invoked Stata commands gduplicates, gcollapse, gdistinct, and distinct were not found in the checked adopaths. StataCorp and the package repositories document SSC installation routes; install/configure the required command packages and verify the actual command entry points under Stata 18.
- R001 [undetermined]: Raw FINRA advisor employment: Input to the Part 1 advisor-year expansion; its begin/end history also determines the generated cohort field since.
- R002 [undetermined]: Advisor gender: Merged to the advisor-year branch by individualid; downstream table fields need separate schema validation.
- R003 [undetermined]: Advisor basic information: Part 1 describes this as names, exams, and bar-status information; confirm the columns needed by later table-data producers.
- R004 [undetermined]: Advisor criminal records: Part 1 merges by individualid and explicitly sets missing criminal to zero.
- R005 [undetermined]: Advisor deregistration exclusions: Part 1 drops records flagged excluded==1.
- R006 [undetermined]: Advisor scope exclusions: Part 1 drops records flagged notinscope==1.
- R007 [undetermined]: Raw FINRA advisory-firm information: Firm-branch base table. The code filters on bcscope and constructs formation, size, sanctions, business-line, and state-registration fields.
- R008 [undetermined]: Firm advisor/criminal counts: Firm merge input for advisor and criminal counts.
- R009 [undetermined]: Firm address details: Firm-address merge input; address-column provenance across the following firm merges needs checking.
- R010 [undetermined]: IA firm address details: Second firm-address merge, using update.
- R011 [undetermined]: Firm registrations: Firm-registration merge input; postal-code fields used after address/registration merges need source-schema validation.
- R012 [undetermined]: Firm branch-office location: The firm branch uses branchoffice_zipcode as a fallback zip.
- R013 [undetermined]: Zip-to-geography lookup: Static lookup merged on zip; Part 1 explicitly keeps these output columns.
- R014 [undetermined]: Firms hiring advisors with pre-advisor criminal records: Firm-level indicator merge.
- R015 [undetermined]: Fraction of advisors with pre-advisor criminal records: Firm-level fraction merge; the resulting variable name/schema is not specified in the merge code.
- R016 [undetermined]: SEC ADV 2017 cleaned firm data: The code labels this SEC ADV Form 2017 data; the downstream account-count construction reads _5f_2_f after the merge chain.
- R017 [undetermined]: Retail investment-adviser classification: Retail status is used later to create missing_indicator.
- R018 [undetermined]: Active-firm regulatory events: Part 1 uses disclosurecount to create log disclosures and regfirm_90.
- R019 [undetermined]: Firm fee structure: Firm merge for the fee controls consumed in Tables 4 and 10B.
- R020 [undetermined]: Table 1A year-by-year and all-years distinct counts: The per-year loops request 2007–2017; the same block also reports totals over all available rows, whose full coverage is unspecified.
- R021 [undetermined]: Table 1B criminal-charge summary: Charge-type fields and summary flags read by the Table 1B block.
- R022 [undetermined]: Table 1C city-geography summary: City input is used for both the >=2,000-advisor and <2,000-advisor ranking branches.
- R023 [undetermined]: Table 3A advisor criminal-record profile: The block estimates felony, misdemeanor, and criminal outcomes and uses startingyear/cityid fixed effects.
- R024 [undetermined]: Table 3B pre-advisor criminal-record profile: The block estimates pre-advisor charge outcomes and uses startingyear/cityid fixed effects.
- R025 [undetermined]: Tables 4 and 10B firm hiring and service-disruption analyses: One shared prepared table dataset feeds both sets of regressions, summary statistics, cluster(zip3), and absorb(cityid formyear).
- R026 [undetermined]: Table 5 firm-location regressions: County/state geography and Census-related fields are read; the exact ACS table, geography, and period contract is not supplied.
- R027 [undetermined]: Tables 6, 7A, and 10A baseline advisor outcomes: The code uses settled_complaint in the Table 7A regression and the shorter token settle in tabstat; check actual variable-abbreviation resolution and the source schema before treating this as a separate field.
- R028 [undetermined]: Table 7B alternative matched-sample analyses: Alternative matched-sample input; this is a separate prepared file and does not substitute for the baseline Table 06/07A/10A input.
- R029 [undetermined]: Table 8 fund-return regressions: The newey calls use the prepared .dta input, which may carry a native time-series declaration/index/frequency. Preserve and inspect those characteristics; if absent, the intended time variable/rule is unspecified and must be clarified before adding a declaration.
- R030 [undetermined]: Table 9 column 1 mutual-fund expense-ratio analysis: The datasheet identifies CRSP Mutual Fund data in WRDS as a source, but no producer/schema maps it to this analysis file.
- R031 [undetermined]: Table 9 columns 2–3 purchase-charge analyses: The datasheet identifies CRSP Mutual Fund data in WRDS as a source, but no producer/schema maps it to this analysis file.
- S002 [preparation_required]: Part 1 invokes gduplicates; the actual command was not found in the checked default/shared Stata adopaths. It is documented by the gtools maintainer.
- S003 [preparation_required]: Part 1 invokes gcollapse; the actual command was not found in the checked default/shared Stata adopaths. It is supplied by gtools.
- S004 [preparation_required]: Part 2 invokes gdistinct; the actual command was not found in the checked default/shared Stata adopaths. It is supplied by gtools.
- S005 [preparation_required]: Part 2 invokes distinct; the actual command was not found in the checked default/shared Stata adopaths. Its SSC record documents installation via ssc install distinct.

## Review notes

- Scope is the two supplied March 8, 2019 Stata programs: Part 1 builds advisor and firm main samples; Part 2 claims the main Tables 1–10. No independent analysis-only scope is supported because the packaged CRD list is not a table-level analysis input and no compatible prepared table dataset route is verified.
- The inventory lists only one packaged .dta, Identifiers for Final Sample.dta. Its bounded probe reads individualid (label crd), with file metadata count 1,041,643; this is an identifier list, not the analysis data needed by Part 2.
- The exact Part 1 path aliases are 19 merge/read inputs; its only two saves are Main Advisor Sample.dta and Main Advisory Firm Sample.dta. Part 2 instead reads 12 Data for Table*.dta inputs. Treat the missing table-data bridge as unresolved, not as proof that the Part 1 samples are the Part 2 files.
- The code itself creates advisor-year rows from begin/end and sets since to the earliest available year. Full employment-history coverage is unknown; the author’s 2017 scrape window is not an observation-history bound. Part 2 Table 1A loops 2007–2017 but also reports all-available-row totals.
- The Table 05 ACS/Social Explorer and Table 09 CRSP Mutual Fund/WRDS references are source leads for the missing table-data producers. Catalog metadata does not verify CRSP mutual-fund coverage, access, or entitlement. A compatible route may use public/local sources and documented conversion/cleaning without requiring identical author bytes or an additional author-approval condition.
- The datasheet and online appendix describe Google Trends and the Madoff-victim list for online-appendix investor-awareness tests. Those analyses are not read by either supplied entry program and remain conditional off-target leads, not mandatory inputs for this main Tables 1–10 scope.
- The scripts are marked March 8, 2019 but do not declare a Stata version; available Stata 18 is not labeled incompatible on that basis. The four actually invoked user commands still need setup.
- No author program, regression, dataset import beyond the provided one-row metadata probe, package installation, source edit, or download was performed. Execution remains unverified.
- Part 2 calls newey on the Table 08 input without an explicit tsset/xtset line. The native .dta may carry time-series characteristics; inspect and preserve them, and clarify the intended time index only if none is present.
