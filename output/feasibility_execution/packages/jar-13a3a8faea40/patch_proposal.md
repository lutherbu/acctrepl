# Patch proposal: jar-13a3a8faea40

Does Private Country-by-Country Reporting Deter Tax Avoidance & Income Shifting? Evidence from BEPS Action Item 13

DOI: 10.1111/1475-679X.12304

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied Stata workflow: primary tax-avoidance preparation/tests (Tables 4–7) and the separately dependent affiliate/parent income-shifting preparation/tests (Table 8). The code file is the exact entry point, but the required data loaders, generated handoffs and some field producers are absent. Appendix-only results without a supplied branch are contextual.

Entry points: `Joshi2020 code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 2/12304 - Does-Private-Country-by-Country-Reporting-Deter-Tax-Avoidance-Income-Shifting-Evidence-from-BEPS-Action-Item-1/joshi-datasheet-and-code-files.zip",
      "sha256": "e913df76f364f350c610559ae7285eaab0b8038a1cb8b146da5ec4d7694c6524"
    },
    {
      "path": "JAR-Volume 58/Issue 2/12304 - Does-Private-Country-by-Country-Reporting-Deter-Tax-Avoidance-Income-Shifting-Evidence-from-BEPS-Action-Item-1/joshi-online-appendix.pdf",
      "sha256": "63de0004d64ba860dd7a6710b4f4b0040960b23304a73f42e7adec760cf57eb9"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "c5bdba38db202b8533862a9ca69c88f429ec49d191fe5496e0d2e944179436d4"
}
```

## Proposed actions

### A-orbis-inputs: Acquire or use author-prepared global Orbis panels through a route permitted by the applicable license, keeping firm, affiliate and parent-year inputs distinct.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R-bvd-identifiers, R-orbis-primary-panel, R-orbis-affiliate-panel, R-orbis-parent-panel, SW-orbis-interface, I-input-driver
Evidence: P-orbis-product, P-orbis-interface, P-orbis-terms, S-datasheet-id-list, S-code-primary-sample, S-code-affiliate-panel

Preparation / proposed procedure:

1. Confirm the current authorized product, account and permitted interface/export under the relevant order; the vendor terms do not establish this workspace’s entitlement.
2. Use the supplied BvD identifier list as a firm lookup, then apply the author’s EU-headquartered global-ultimate-owner, foreign-subsidiary, financial/extractive exclusion and majority-owned-affiliate criteria. Do not substitute North American or bank-only samples for the Orbis population.
3. Obtain separate primary firm-year, majority-owned affiliate-year and parent-year files with source columns and mappings for every code field; include the correct 2010–2018 analysis years and the actual prior Revenue row needed by each modeled observation. Clarify whether the 2010 pre-period row is expected to receive PYRevenue.
4. If licensed method does not permit exporting the required amount, obtain an authorized prepared analysis input or permitted delivery path; do not scrape, exceed limits or bypass terms.

Validation to perform later:

- Confirm BvDIDnumber and GUOBvDIDnumber link coverage, Year keys, panel uniqueness and sample/period counts against author documentation. Verify required global affiliate and parent populations and lawful/authorized extraction.

### A-oecd-str: Build the STR country-year input from a compatible OECD statutory corporate income-tax series.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R-oecd-str
Evidence: P-oecd-data, P-oecd-history, S-code-str-merge, S-code-C-description, S-appendix-str-table

Preparation / proposed procedure:

1. Select a currently available annual standard statutory-rate measure compatible with the author STR definition; record the data vintage but do not require a byte-identical original vintage. The current OECD product reports multiple central, subcentral and combined measures.
2. Retrieve country-year values for 2010–2018 for every jurisdiction actually required by the Orbis parent/affiliate groups. Preserve identifiers and metadata, then map to the code’s country and Year merge keys.
3. Document the selected measure, units and country-name mapping; validate overlapping values against Appendix A2 before using the compatible current series.

Validation to perform later:

- Compare overlapping rates with the supplied Appendix A2 country-year table, confirm the compatible 2010–2018 rate concept and all affiliate-country coverage, then verify one country-Year merge row per key.

### A-compustat-match: Use the global annual Compustat candidate to construct the documented cash-tax matched input only after the missing author transformation contract is resolved.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R-compustat-cash-taxes, I-cetr-producer
Evidence: C-compustat-global, P-comp-g-funda, S-datasheet-compustat, S-code-cetr-merge

Preparation / proposed procedure:

1. Treat COMP.G_FUNDA as a local candidate: it provides catalog fields ISIN, datadate, fyear, txpd, pi and at and a readable one-row sample. Do not treat the one-row sample, a null txpd in that row, or COMP.FUNDA’s North American product as evidence of complete global match coverage.
2. Confirm the author’s fiscal Year mapping, currency conversion to the code’s mEUR fields, pretax-income/assets correspondence, exact ISIN matching steps, missing-value rules and winsorization inputs/thresholds.
3. Using an authorized, compatible global input, produce CETR.dta with the precise code-consumed keys and fields CashTaxes_CETR_w, PTI_CETR_w and TA_CETR; retain the raw source fields and a match audit.

Validation to perform later:

- Verify required fields and nonmissing coverage for 2010–2018; reconcile a bounded sample of ISIN-Year rows and Orbis/Compustat pretax income/assets; compare generated fields/units to author specifications before any authorized run.

### A-match-disposition: Resolve the discrepancy-filter contract between the documented manual match step and the supplied flags.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-match-exclusion, R-compustat-cash-taxes
Evidence: S-code-match-check, S-datasheet-compustat

Preparation / proposed procedure:

1. Confirm whether observations with Match==0 or Match1==0 are excluded, retained, or treated by another specified rule; identify required comparison tolerances, units and handling of missing values.
2. Return the exact validation table or procedure used to hand-match ISIN, total assets and pretax income. Do not infer that creating Match/Match1 flags performs the documented exclusion.

Validation to perform later:

- Verify that the completed matched input reproduces the chosen inclusion rule and that subsequent sample counts are reported.

### A-parent-affiliate-schema: Obtain the wide source schemas and exact reshaping/handoff contract for both panels.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-orbis-affiliate-panel, R-orbis-parent-panel, I-affiliate-reshape-contract
Evidence: S-code-main-reshape, S-code-reshape-long, S-code-affiliate-panel, S-code-return-table7

Preparation / proposed procedure:

1. Provide the source columns matching the literal reshape stub varlist for each panel, the BvDIDnumber and Year key uniqueness, and the actual construction/mapping of GUOBvDIDnumber.
2. Specify how ParentData.dta is produced, which parent-year fields it contains, and the required order/state transitions from primary panel to affiliate panel and back to primary Table 7 analyses.
3. Retain both the primary tax-avoidance branch and the Table 8 affiliate branch; do not merge different directories/schemas or consume ParentData.dta before its producer.

Validation to perform later:

- Validate the wide-to-long row counts and keys separately for primary and affiliate panels, parent-child links, and that a staged run can restore the right data state before Table 7.

### A-income-shift-contract: Resolve the missing C producer and exact regression variable names without guessing aliases.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-income-shift-construction, R-orbis-affiliate-panel, R-orbis-parent-panel
Evidence: S-code-C-description, S-code-income-aliases

Preparation / proposed procedure:

1. Provide the exact C construction or a compatible prepared C input, including the statutory-rate measure, revenue-versus-assets scale choice, parent-year/affiliate population, currency units and missing-affiliate rules.
2. Specify the intended model terms and exact variables for CBCR_POST versus POST_CBCR; C_CBCR and C_CBCR_POST versus the created C_POST and C_POST_CBCR; and perctmissingC versus perctmissing.
3. Supply the code or reproducible producer and do not substitute a proxy, infer aliases, or drop the income-shifting branch.

Validation to perform later:

- Verify all regressors are produced from the matching affiliate/parent fields and compare the C/missingness definitions to the author’s documented model.

### A-gdp-source: Identify the GDP series and producer used by the affiliate model.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-country-gdp
Evidence: S-code-gdp, S-code-affiliate-panel

Preparation / proposed procedure:

1. Specify the GDP source/product, annual measure, units, jurisdiction mapping and Year key that produce the code’s GDP variable.
2. Deliver or identify the exact country-Year input and its authorized acquisition route; do not assume Orbis or OECD tax data supply GDP.

Validation to perform later:

- Check key uniqueness, units, coverage over the affiliate sample years and that LogGDP uses the intended nonnegative values.

### A-bandwidth-fields: Obtain the definitions and producer for the Table 4 bandwidth-group indicators.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-table4-bandwidth-flags, I-table4-bandwidth-producer
Evidence: S-code-window-flags

Preparation / proposed procedure:

1. Specify how BW1_250, BW1_450 and BW1_550 are formed, the running variable, threshold/date window, boundary inclusivity and eligible population.
2. Provide the producer or an exact compatible prepared input; the variable labels alone do not establish definitions.

Validation to perform later:

- Verify indicator values and sample counts for each Table 4 test against the author specification.

### A-input-driver-and-paths: Complete the data-loading and stage-directory contract for all supplied branches.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-input-driver
Evidence: S-code-str-merge, S-code-cetr-merge, S-code-affiliate-panel, S-code-return-table7, S-code-duplicate-POST-main, S-code-duplicate-POST-affiliate

Preparation / proposed procedure:

1. Identify the primary firm panel and the distinct STR Only.dta, CETR.dta, ParentData.dta and affiliate-panel producers; document exact branch order and whether they require separate Stata sessions or explicit reload/restore steps.
2. Once file locations are known, update all affected path calls consistently and use relative paths or approved [redacted-path-9f1eb7ee7437] paths only; do not place absolute Dropbox paths in an executable host wrapper.
3. Include the return from Table 8 affiliate data to the Table 7 primary outcome panel and account for the duplicate POST generation across data states.

Validation to perform later:

- Confirm every read resolves from the documented working directory and each branch starts with its required schema before an authorized execution.

### A-comment-C-heading: Comment the raw primary-sample narrative and C heading so Stata does not parse documentation as commands.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I-uncommented-C-heading, I-uncommented-primary-sample-prose
Evidence: S-code-uncommented-C-heading, S-code-uncommented-primary-prose, S-code-primary-sample

**Proposed edit:** `Joshi2020 code.do:214–214`
Source SHA-256: `d05f05960c86ed3906f0ed739f6c59e2c6547eb2b7545a9e11d1f2bbbe5af4d7`

Mark the author’s narrative section heading as a comment; this preserves the text and does not supply the missing C construction.

Current text:
```
Calculation of C (Tax Incentive Variable)
```

Proposed replacement:
```
*Calculation of C (Tax Incentive Variable)
```

**Proposed edit:** `Joshi2020 code.do:19–28`
Source SHA-256: `d05f05960c86ed3906f0ed739f6c59e2c6547eb2b7545a9e11d1f2bbbe5af4d7`

Prefix every line of the prose-only sample description with a Stata comment marker, preserving its text and all code.

Current text:
```
The primary sample in the study consists of EU MNCs. I restrict the sample to EU MNCs because CbCr was effective in EU member states on the same date (January 1, 2016). 
In addition, the tax and legal environments in EU nations are comparable across jurisdictions, and there is better availability of affiliate-level data through 
databases compiled by Bureau van Dijk. I obtain annual financial statements and ownership data for the years 2010 to 2018 from the Orbis database (Bureau van Dijk). 
In the EU, a primary reporting obligation under CbCr arises when, in a multinational group, either the ultimate parent or a member of the group is resident in 
a member state. CbCr requirements for resident and nonresident EU firms when the parent entity is headquartered outside an EU member state depends on whether 
the parent jurisdiction has adopted the rules and on the exchange relationship between parent home country and EU member states. I therefore restrict my primary 
sample to EU headquartered firms and, in an additional analysis (section 8.3), include nonresident EU firms. I start with EU-headquartered firms that are identified 
as global ultimate owners in the Orbis database and that have at least one foreign subsidiary. I exclude financial institutions and firms in the extractive industries 
because they are subject to additional CbCr requirements.  After excluding firms with missing data required to calculate the regression variables, the final sample
 consists of 5,312 EU-headquartered multinationals (57,131 firm year-ends). 
```

Proposed replacement:
```
*The primary sample in the study consists of EU MNCs. I restrict the sample to EU MNCs because CbCr was effective in EU member states on the same date (January 1, 2016). 
*In addition, the tax and legal environments in EU nations are comparable across jurisdictions, and there is better availability of affiliate-level data through 
*databases compiled by Bureau van Dijk. I obtain annual financial statements and ownership data for the years 2010 to 2018 from the Orbis database (Bureau van Dijk). 
*In the EU, a primary reporting obligation under CbCr arises when, in a multinational group, either the ultimate parent or a member of the group is resident in 
*a member state. CbCr requirements for resident and nonresident EU firms when the parent entity is headquartered outside an EU member state depends on whether 
*the parent jurisdiction has adopted the rules and on the exchange relationship between parent home country and EU member states. I therefore restrict my primary 
*sample to EU headquartered firms and, in an additional analysis (section 8.3), include nonresident EU firms. I start with EU-headquartered firms that are identified 
*as global ultimate owners in the Orbis database and that have at least one foreign subsidiary. I exclude financial institutions and firms in the extractive industries 
*because they are subject to additional CbCr requirements.  After excluding firms with missing data required to calculate the regression variables, the final sample
* consists of 5,312 EU-headquartered multinationals (57,131 firm year-ends). 
```

Validation to perform later:

- In a future authorized run, confirm execution proceeds beyond the heading; C itself remains unresolved.

### A-rd-name: Confirm the valid Stata variable name for the R&D intensity formula while preserving the calculation.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-RD-variable-name
Evidence: S-code-RD-invalid

Preparation / proposed procedure:

1. Specify the intended valid Stata identifier for the authored R&D/Totalassets field and whether it is consumed by any supplied table.
2. Retain the variable-construction block; do not invent an alias or remove it because current model blocks do not reference it.

Validation to perform later:

- Confirm the final identifier is legal in Stata and matches all intended consumers.

### A-cetr-variants: Resolve the two duplicate CETR construction variants and their dependent variables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-cetr-duplicate-variants, R-compustat-cash-taxes
Evidence: S-code-cetr-variant1, S-code-cetr-variant2

Preparation / proposed procedure:

1. Identify whether CashTaxPaid/PLbeforetaxmEUR and CashTaxes_CETR_w/PTI_CETR_w are separate intended alternatives or an obsolete/current pair.
2. Specify how MissingCETR, CETR_R and CETR_T should be constructed in each variant, including the line where CETR_T is assigned from ETR.
3. Retain both variants as separate documented inputs/branches if both are intended; do not execute duplicate gen statements or silently remove one.

Validation to perform later:

- Validate each retained variant against its exact source fields and reported table outcome definitions.

### A-pyrevenuelag: Resolve the PYRevenue command and its date/history semantics.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-pyrevenuelag-command, R-orbis-primary-panel
Evidence: S-code-lagged-revenue, S-code-egen-lag

Preparation / proposed procedure:

1. Specify whether PYRevenue is prior calendar-year revenue or prior available row within BvDIDnumber, how gaps/duplicate years are handled, and which first-year rows must be populated.
2. Provide the intended Stata producer for the selected lag rule and the required lead-in history relative to the 2010–2018 analysis years; do not infer 2009 as mandatory unless 2010 PYRevenue is part of the target.

Validation to perform later:

- Verify lagged revenue maps to the intended prior period for each retained panel row and that no unintended future/older row is used.

### A-cbcr-rename: Specify the observation-level disposition intended by the conditional rename.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-maxcbcr-rename
Evidence: S-code-conditional-rename

Preparation / proposed procedure:

1. Clarify what should happen to CBCR and MaxCBCR when Equals==1 and when it is not 1; provide the intended variable-name and row-level operation.
2. Do not replace the conditional rename with a guessed replace, drop or rename operation.

Validation to perform later:

- Confirm the produced CBCR values and names match the authored CBCR contract before estimating models.

### A-safe-stata-operators: Correct the unambiguous missing() spelling and headquarters equality operator in all affected lines.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I-stata-missing-function-typo
Evidence: S-code-missing-typo1, S-code-missing-typo2, S-code-missing-typo3, S-code-HQ-equality

**Proposed edit:** `Joshi2020 code.do:34–34`
Source SHA-256: `d05f05960c86ed3906f0ed739f6c59e2c6547eb2b7545a9e11d1f2bbbe5af4d7`

Correct the misspelled built-in Stata missing-value function without changing the condition or sample.

Current text:
```
drop if misisng( BvDIDnumber)
```

Proposed replacement:
```
drop if missing( BvDIDnumber)
```

**Proposed edit:** `Joshi2020 code.do:53–53`
Source SHA-256: `d05f05960c86ed3906f0ed739f6c59e2c6547eb2b7545a9e11d1f2bbbe5af4d7`

Correct the misspelled built-in Stata missing-value function without changing the condition or sample.

Current text:
```
drop if misisng( BvDIDnumber)
```

Proposed replacement:
```
drop if missing( BvDIDnumber)
```

**Proposed edit:** `Joshi2020 code.do:58–58`
Source SHA-256: `d05f05960c86ed3906f0ed739f6c59e2c6547eb2b7545a9e11d1f2bbbe5af4d7`

Correct the misspelled built-in Stata missing-value function without changing the condition or sample.

Current text:
```
drop if misisng( BvDIDnumber)
```

Proposed replacement:
```
drop if missing( BvDIDnumber)
```

**Proposed edit:** `Joshi2020 code.do:208–208`
Source SHA-256: `d05f05960c86ed3906f0ed739f6c59e2c6547eb2b7545a9e11d1f2bbbe5af4d7`

Correct the misspelled built-in Stata missing-value function without changing the condition or sample.

Current text:
```
drop if misisng( BvDIDnumber)
```

Proposed replacement:
```
drop if missing( BvDIDnumber)
```

**Proposed edit:** `Joshi2020 code.do:144–144`
Source SHA-256: `d05f05960c86ed3906f0ed739f6c59e2c6547eb2b7545a9e11d1f2bbbe5af4d7`

Use Stata’s equality operator in this clearly stated binary headquarters condition.

Current text:
```
replace EUHQ=1 if HQLocatedEU=1 
```

Proposed replacement:
```
replace EUHQ=1 if HQLocatedEU==1 
```

Validation to perform later:

- After the remaining unresolved source/data contracts are addressed, run only under a separately authorized Stata execution and confirm all four missing() filters plus the HQ equality condition parse as intended.

### A-py-shared-run-procedure: Future execution procedure for the supplied Stata workflow after required inputs, unresolved code contracts and approved corrections are complete.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: run procedure
Evidence: P-environment, S-code-export-list, S-code-window-flags

Preparation / proposed procedure:

1. Run an authorized copy from its project root working directory using Stata 18 batch mode. Keep input paths relative to the execution root or under an approved [redacted-path-9f1eb7ee7437] path; do not configure absolute Dropbox paths.
2. Preserve the authored CSV basenames ResultTable5.csv, ResultTable6.csv, ResultTable8-1.csv, ResultTable7PanelA.csv and ResultTable7PanelB.csv. Capture the batch log for Table 4 t-test output and archive each run’s CSVs/logs in a separate run-specific output location.
3. Load/restore the primary and affiliate datasets at the clarified stage boundaries; retain all supplied analyses.

Validation to perform later:

- Confirm every required file is visible from the host working directory, all five CSVs and the Table 4 log are archived, and sample/results are compared with the paper only after execution is separately authorized.


## Remaining issues and prerequisites

- I-input-driver [unresolved; full_pipeline]: The only Stata file does not load the primary data and directly references STR Only.dta and CETR.dta at machine-specific Windows paths. The income-shifting branch separately references ParentData.dta and a reshaped affiliate input; the file later returns to primary-panel Table 7 outcomes after the Table 8 affiliate branch without restoring that dataset. It creates POST in both branches, but no clear/load/driver transition establishes separate datasets or run order. Exact producers, current directories and host-visible relative paths must be supplied; do not infer a single-session workflow.
- I-cetr-producer [unresolved; full_pipeline]: The raw Compustat-to-CETR.dta producer is absent. Code later expects CashTaxes_CETR_w, PTI_CETR_w and TA_CETR, but no source-column mapping, fiscal-year conversion, currency/unit transformation, winsorization population/rule, or output producer is supplied. The catalog-listed global Funda candidate and one-row read do not establish complete match coverage.
- I-match-exclusion [unresolved; full_pipeline]: Step 6 says discrepant Orbis/Compustat observations are excluded, but the supplied code only generates Match and Match1 equality flags and does not filter on them. The intended discrepancy rule, units/tolerance and whether these flags drive deletion remain unresolved.
- I-income-shift-construction [unresolved; full_pipeline]: The income-shifting code documents C as a weighted average of affiliates’ statutory rates but supplies no C producer or complete implementation contract. It creates POST_CBCR, C_POST and C_POST_CBCR, while regressions reference CBCR_POST, C_CBCR and C_CBCR_POST; it creates perctmissing but filters on perctmissingC. Do not guess replacements or supply a proxy variable.
- I-affiliate-reshape-contract [unresolved; full_pipeline]: Both primary and income-shifting sections reshape an unprovided wide panel using the literal varlist stub and BvDIDnumber key. The affiliate branch additionally expects parent GUOBvDIDnumber and annual fields. No source column schema, producer, key uniqueness, or relationship between the affiliate input and ParentData.dta is supplied.
- I-table4-bandwidth-producer [unresolved; full_pipeline]: Table 4 requires BW1_250, BW1_450 and BW1_550, but the code never creates or imports them and the package does not document their eligibility rules.
- I-stata-missing-function-typo [preparation; full_pipeline]: The Stata source calls misisng() on four lines (34, 53, 58 and 208) and uses a single equals sign in the HQLocatedEU=1 condition on line 144. These are supported spelling/operator corrections; exact line edits are included.
- I-uncommented-C-heading [preparation; full_pipeline]: The raw narrative heading Calculation of C is not a Stata comment and will be parsed as a command. A comment marker is an unambiguous supported correction; it does not supply the missing C producer.
- I-RD-variable-name [unresolved; full_pipeline]: The source writes gen R&D=..., using an ampersand in a Stata variable name. The formula uses RD divided by assets, but the intended valid variable name/alias is not established; preserve this block and ask for the target name rather than invent one.
- I-cetr-duplicate-variants [unresolved; full_pipeline]: The code generates CETR, MissingCETR, CETR_R and CETR_T from CashTaxPaid/PLbeforetaxmEUR, then generates the same names again using CashTaxes_CETR_w/PTI_CETR_w. Stata cannot execute both gen blocks in one data state. The first block also assigns CETR_T from ETR. Which source variant is intended and how both documented variants should be retained is unresolved. Do not silently select, delete or overwrite a source variant.
- I-pyrevenuelag-command [unresolved; full_pipeline]: The PYRevenue statement calls egen with a bare expression, not an egen function, and uses _n-1 within firm rows. The executable construction and whether PYRevenue means the previous observation or previous calendar year (including missing/duplicate year handling and the first required observation) are unresolved.
- I-maxcbcr-rename [unresolved; full_pipeline]: The source uses rename MaxCBCR CBCR if Equals==1. Stata rename does not act on observations through an if qualifier; the intended condition-specific variable disposition cannot be inferred safely.
- I-uncommented-primary-sample-prose [preparation; full_pipeline]: Lines 19–28 are explanatory primary-sample prose embedded in the .do file without comment markers, so Stata parses them as commands. The block is unambiguously documentation; comment-only prefixing preserves the text and executable commands.
- R-orbis-primary-panel [undetermined]: Orbis annual financial-statement and ownership panel for EU-headquartered global ultimate owners with foreign subsidiaries, excluding financial and extractive firms; author states 2010–2018 and 5,312 firms/57,131 firm-year ends. The supplied code reshapes this input using the literal varlist stub, then expects BvDIDnumber, Year, country, ISIN, Conscode, Revenue, HQLocatedEU, TaxationmEUR, PLbeforetaxmEUR, PTI, TA, NetIncome, Totalassets, TotalEquityLiab, ShareholdersfundsmEUR, Intangibles, RD, Numberofpatents and Numberoftrademarks. The source wide-column names/pattern that satisfy varlist are unknown. It sets PYRevenue to the previous available Revenue row by BvDIDnumber; if 2010 rows are intended in the Table 5 pre-period, their prior row would require 2009 data. Calendar-gap, duplicate-year and first-year rules remain unspecified.
- R-oecd-str [undetermined]: Country-Year OECD statutory tax-rate series used directly as STR, merged into the primary panel by country and Year and used in TaxDiff and affiliate-group C construction. The intended period is 2010–2018 over jurisdictions represented by the Orbis parent/affiliate groups, not only EU headquarters. The required rate concept, units, country mapping and affiliate-country coverage must be compatible. Record the data vintage and document differences from the paper appendix; byte-identical original vintage is not required.
- R-compustat-cash-taxes [undetermined]: Compustat Global annual observations matched to Orbis by ISIN and Year, with pretax income and total-assets comparisons and cash taxes for CETR. The supplied code consumes a derived CETR.dta and later refers to CashTaxes_CETR_w, PTI_CETR_w and TA_CETR, but its raw-to-merged producer, fiscal-year-to-Year mapping, currency/unit treatment, winsorization rules, match tolerance and sample coverage are absent. This is the primary raw Compustat route; an author-prepared CETR.dta is not separately required unless documented as an alternative handoff.
- R-orbis-affiliate-panel [undetermined]: Separate Orbis majority-owned affiliate-year panel for the income-shifting branch, reshaped from author-supplied wide data and keyed by affiliate BvDIDnumber, parent GUOBvDIDnumber and Year. Code needs PTI, Tangiblefixedassets, EmployeesCost, Employees, NACERev2Corecode4digits, parent-group identifiers, and the revenue/STR/scale inputs used to construct C. Affiliate population, selection rules, field mappings, missing-year handling and 2010–2018 coverage are not supplied.
- R-orbis-parent-panel [undetermined]: Separate parent-year input referenced as ParentData.dta and merged by GUOBvDIDnumber and Year. Code/documentation requires a parent-level CBCR indicator and other parent variables, but no ParentData.dta or parent-panel producer is supplied; exact columns beyond the key and CBCR, period, and directory/order contract are unknown.
- R-country-gdp [undetermined]: Country-Year GDP input consumed by the affiliate branch to create LogGDP. The code and datasheet do not name its source, rate/value definition, unit, country-year merge key conversion or period.
- R-table4-bandwidth-flags [undetermined]: The Table 4 t-tests require BW1_250, BW1_450 and BW1_550 indicators. No supplied code or author data producer defines these flags or identifies their eligible observations; the values and construction cannot be inferred from the labels.
- SW-orbis-interface [unverified]: The vendor lists a web interface/API option, but the author’s actual data-extraction interface and current licensed user access are unspecified. This is a manual acquisition-stage dependency, not a Stata code runtime.

## Review notes

- The frozen dependency checklist is empty; required reads and handoffs are derived from the complete supplied Stata source and datasheet.
- The BvD identifier list is a lookup, not full company/affiliate panel data.
- Datasheet mentions Google Trends and Factiva, but the supplied Stata source does not consume either; these do not become mandatory requirements for this supplied-code target. The study treatment is private Country-by-Country Reporting, not evidence that private tax returns are accessed.
- Online appendix reports A1–A6 outputs without corresponding supplied code branches; retain them as contextual limitations rather than add unprovided estimators to this scope.
- Static audit export warnings for Table 6/Table 7 are not treated as missing export commands: the supplied source has esttab CSV outputs after the model blocks. The Table 4 t-tests do not have a separate table export command.
- Bounded Compustat probe row 1 had a null txpd value; this is a sample observation and does not establish that the field is absent or the required population unavailable.
- The global Compustat annual product is a possible cash-tax source candidate; North American COMP.FUNDA and bank-only products are not substitutes for global Orbis selection/affiliate coverage.
- Additional syntax and stage-state issues from the complete source review are preserved explicitly: uncommented narrative heading, invalid R&D identifier, duplicate CETR construction variants, bare egen row expression, conditional rename, and return to Table 7 without restoring the primary panel. Safe corrections are proposed only where the literal intent is clear; semantic choices remain author-dependent.
