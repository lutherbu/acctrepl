# Patch proposal: jar-6a47f5290ee4

Wrong Kind of Transparency? Mutual Funds’ Higher Reporting Frequency, Window Dressing, and Performance

DOI: 10.1111/1475-679X.12527

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The target is all supplied SAS preparation followed by the complete Stata driver, including its separate propensity-matching and unbalanced-sample branches. The root-verified safe source view withholds the entire Regression_sample.sas body; that source remains code-present and its unverified sample-builder contracts are retained as unresolved review limits.

Entry points: `WD_measure.sas`, `WD_momadj_measure.sas`, `Regression_sample.sas`, `Regressions.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 2/12527 - Wrong-Kind-of-Transparency-Mutual-Funds-Higher-Reporting-Frequency-Window-Dressing-and-Performance/xyz-datasheet-code-and-identifiers.zip",
      "sha256": "8a24b8c6c8655bf64ac68c40d65f034c729eb5f02712daa5aa35423feab6fc03"
    },
    {
      "path": "JAR-Volume 62/Issue 2/12527 - Wrong-Kind-of-Transparency-Mutual-Funds-Higher-Reporting-Frequency-Window-Dressing-and-Performance/xyz-online-appendix.pdf",
      "sha256": "5924521b130392a7adedb4efd8d2734d90757e8c5fec8ca5c174425cff91715b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "86b04a78dc6ba72d6fff43c4d3adc7999113889cdd3414bcf5571a2629c590eb"
}
```

## Proposed actions

### A-VERIFY-CRSP-STOCK-ROUTES: Validate empirical coverage and identifier behavior for the compatible local legacy stock routes, and resolve the separate hidden DSI/sample-builder contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-CRSP-MSF, R-CRSP-DSF, R-CRSP-MSENAMES, R-CRSP-DSI
Evidence: E-CAT-CRSP-MSF, E-PROBE-CRSP-MSF, E-CAT-CRSP-DSF, E-PROBE-CRSP-DSF, E-CAT-CRSP-MSENAMES, E-PROBE-CRSP-MSENAMES, E-CAT-CRSP-DSI, E-PROBE-CRSP-DSI, E-PUB-CRSP-STOCK, E-PUB-WRDS-ACCESS

Preparation / proposed procedure:

1. Retain the verified CRSP.MSF and CRSP.MSENAMES local routes for the visible consumers; check empirical-period coverage, identifier/date continuity, required CUSIP matches, adjustment conventions and construction-window extent before a later run.
2. Retain the verified local CRSP.DSF route for the visible daily-stock consumer and configure its CRSP2017 alias through the separate supported configuration action.
3. Resolve the separate CRSP DSI/sample-builder producer/consumer contract from an authorized specification; do not infer its fields from a CRSP catalog or from the visible DSF field match.
4. If WRDS is chosen instead of the existing local legacy product, confirm the selected table and entitlement before any later authorized acquisition.

Validation to perform later:

- Check actual date coverage, identifiers, key behavior, adjustment conventions and lag/window coverage for the selected products; do not require original author bytes or vintage when the compatible local legacy product meets the contract.
- Keep any specific hidden DSI/sample-builder field or producer gap linked to the opaque sample-builder issue.

### A-VERIFY-CRSPF-STYLE-MONTHLY: Confirm the CRSP mutual-fund style, summary, monthly return and monthly asset tables and fields used for fund filters, weights and return construction.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-CRSPF-FUND-STYLE, R-CRSPF-FUND-SUMMARY, R-CRSPF-MONTHLY-RETURNS, R-CRSPF-MONTHLY-TNA
Evidence: E-CAT-CRSP-MF, E-PUB-CRSP-MF-GUIDE, E-PUB-WRDS-ACCESS, E-WD-FUND-STYLE-SUMMARY, E-WD-MONTHLY-FUND-INPUTS, E-MOMADJ-CRSP-FUND-INPUTS

Preparation / proposed procedure:

1. Select a compatible local or documented public route separately for each logical table; routes are alternatives, while the tables are distinct inputs.
2. Confirm fund-class identifiers, date joins, objective/style fields, per_com transformation, monthly return and TNA columns, and the source population/date coverage.
3. Check the required lag and lead history used by rolling returns and asset weights; do not treat the 1998–2012 filter as the full construction-history bound.

Validation to perform later:

- Before author-code execution, compare field names/types and key/date coverage for the selected tables against the visible consumers.
- Confirm each required rolling window has sufficient history before finalizing the source date bounds.

### A-VERIFY-CRSPF-DAILY-FEES: Confirm fee intervals and the daily/monthly fund return, TNA and NAV products used in daily return-gap construction.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-CRSPF-FUND-FEES, R-CRSPF-DAILY-RETURNS, R-CRSPF-MONTHLY-NAV, R-CRSPF-DAILY-NAV
Evidence: E-CAT-CRSP-MF, E-PUB-CRSP-MF-GUIDE, E-PUB-WRDS-ACCESS, E-WD-MONTHLY-FUND-INPUTS, E-MOMADJ-CRSP-FUND-INPUTS

Preparation / proposed procedure:

1. Verify the exact local table aliases, fund/date keys, beginning/end fee intervals and return/NAV fields; the catalog product family alone does not confirm these contracts.
2. Confirm how monthly TNA and NAV are aligned with daily NAV/returns and what history is needed for daily transformations.
3. Use a compatible local or public product route for each distinct table; do not require byte-identical vendor files.

Validation to perform later:

- Before later authorized execution, verify key/date joins and that fee intervals and daily/monthly series cover the full required construction window.

### A-VERIFY-LOAD-TERMS: Confirm separate front-load and rear-load source tables, fields and validity-date conventions used in the sample-construction workflow.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-CRSPF-FRONT-LOAD, R-CRSPF-REAR-LOAD
Evidence: E-CAT-FRONT-LOAD, E-CAT-REAR-LOAD, E-PUB-CRSP-MF-GUIDE, E-PUB-WRDS-ACCESS, E-WORK-ITEM-DEPENDENCIES

Preparation / proposed procedure:

1. Identify a compatible local or public source for each load table and confirm fund identifier, load amount/class and effective-date fields.
2. Do not infer an interval rule or combine front- and rear-load products without source evidence.

Validation to perform later:

- Before a later authorized run, compare the selected load fields and validity intervals with the actual consumers and required history.

### A-VERIFY-S12-LINKS: Confirm S12 type-1 reporting records, type-3 security holdings and both CRSP/Thomson linking tables, including identifier and effective-date contracts.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-S12-TYPE1, R-S12-TYPE3, R-MFLINK1, R-MFLINK2-BEG-END
Evidence: E-CAT-S12, E-CAT-S12-TYPE1, E-CAT-S12-TYPE3, E-CAT-MFLINKS, E-CAT-MFLINK2, E-PUB-S12-MAP, E-PUB-MFLINKS, E-WD-S12, E-WD-MFLINK-HOLDINGS, E-MOMADJ-S12, E-MOMADJ-HOLDING-LINK, E-WD-MFLINK1, E-MOMADJ-MFLINK1

Preparation / proposed procedure:

1. For each logical table, confirm the selected local or public route, table type, identifier fields and date bounds.
2. Verify S12 report/vintage dates, CUSIP-to-PERMNO mapping, WFICN crosswalk and MFLINK2 effective link dates as consumed by the source.
3. Check three- and six-month holdings windows and the additional source history required before the first target report date.

Validation to perform later:

- Before a later authorized run, confirm key uniqueness/validity windows and verify the expected fields and date history against the visible SAS joins.

### A-VERIFY-FACTOR-SERIES: Validate empirical date alignment and window coverage for the verified monthly factor route, and resolve the separate author-specific daily mom_1/mom_3 construction.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-FF-MONTHLY, R-FF-DAILY-CUSTOM, I-MOMENTUM-FACTOR-CONTRACT
Evidence: E-CAT-FF-MONTHLY, E-PROBE-FF-MONTHLY, E-CAT-FF-DAILY, E-PROBE-FF-DAILY, E-MOMADJ-CUSTOM-FACTORS, E-MOMADJ-3M-WINDOW, E-MOMADJ-6M-OUTPUT, E-PUB-FRENCH-DAILY-FACTORS, E-PUB-FRENCH-DAILY-MOM

Preparation / proposed procedure:

1. For the verified FF.FACTORS_MONTHLY route, check date alignment and any required lag/lead coverage during later validation; do not impose an author-vintage requirement when the local product contract fits.
2. Obtain the exact construction or source for mom_1 and mom_3, including 90/180-day windows, breakpoints, weighting and timing conventions.
3. Do not substitute standard UMD or standard momentum for the custom three/six-month fields without author confirmation.

Validation to perform later:

- Before a later authorized run, verify monthly factor date coverage/alignment and compare custom daily fields with their documented definitions and window timing.

### A-VERIFY-IBES-LINKS: Confirm the I/B/E/S detail table and ICLINK history required by sample construction, including exact forecast measures and issuer/security identifiers.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-IBES-DETAIL, R-IBES-ICLINK
Evidence: E-CAT-IBES-DETAIL, E-PROBE-IBES-DETAIL, E-CAT-ICLINK, E-PUB-IBES-GUIDE, E-PUB-IBES-CRSP-LINK, E-PUB-WRDS-ACCESS, E-WORK-ITEM-DEPENDENCIES

Preparation / proposed procedure:

1. Identify the required I/B/E/S forecast fields, fiscal-period/date convention and key fields from the supplied workflow specification.
2. Confirm link-score/valid-date requirements for ICLINK and select one compatible local or public route per product.
3. Retain unresolved history and identifier mapping until verified; do not acquire records during this review.

Validation to perform later:

- Before a later authorized run, compare field types, identifier links and date coverage with the sample-construction consumers.

### A-CLARIFY-PREPARED-SAMPLE-INPUTS: Confirm the author-prepared treatment-fund and filing-date inputs named by the assigned workflow, their locations, schemas and date conventions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-TREATMENT-FUNDS, R-FILING-DATES
Evidence: E-WORK-ITEM-DEPENDENCIES, E-DATASHEET-SOURCES, E-DATASHEET-CODE

Preparation / proposed procedure:

1. Locate the exact author-prepared files if supplied and document keys, units, event/date definitions and coverage.
2. If those inputs are not supplied, obtain the source/field specification from the package documentation before deciding whether any supported alternative exists.
3. Do not independently rebuild treatment labels or filing dates from raw sources based only on the paper title or datasheet.

Validation to perform later:

- Before later authorized execution, confirm file readability, key uniqueness, date semantics and sample coverage against the source specification.

### A-SETUP-SAS-PRODUCTS: Confirm/configure the SAS Base installation, SAS/STAT PROC REG and SAS/ACCESS PC Files export engine required for the SAS-to-Stata workflow.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-SAS-BASE, SW-SAS-STAT-REG, SW-SAS-ACCESS-PCFILES
Evidence: E-PROBE-ENVIRONMENT, E-DATASHEET-CODE, E-PUB-SAS-REG, E-PUB-SAS-PCFILES

Preparation / proposed procedure:

1. Verify the required SAS products and license on the intended host; the current bounded projection leaves availability unverified.
2. Configure the PC Files export engine for DBMS=STATA only if the supplied handoff requires it and the product is licensed.

Validation to perform later:

- At the later authorized run stage, confirm the installed product/module configuration and successful SAS-to-Stata file handoff without altering study variables or sample definitions.

### A-SETUP-STATA-MISSING-ADDONS: Add the required winsor2 and psmatch2 Stata packages to the intended Stata adopath after confirming the prescribed versions and source.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-STATA-WINSOR2, SW-STATA-PSMATCH2
Evidence: E-PROBE-WINSOR2, E-PROBE-PSMATCH2, E-STATA-ADDONS-REGRESSION, E-STATA-PSMATCH

Preparation / proposed procedure:

1. Confirm the package source/version and install or configure each add-on in the intended Stata environment; neither was found by the bounded current-adopath probe.
2. Do not install packages during this assessment.

Validation to perform later:

- After setup, use `which winsor2` and `which psmatch2` in the intended Stata environment and confirm both commands resolve before any later authorized author-code run.

### A-CLARIFY-REGRESSION-SAMPLE-CLOSURE: Confirm the producer/consumer contracts for the supplied SAS sample-construction stage, its dynamic WORK tables, its generated finalsam output and the SAS-to-Stata handoff.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-REGRESSION-SOURCE-OPAQUE
Evidence: E-DATASHEET-CODE, E-STATA-ENTRY, E-STATA-UNBALANCED, E-WORK-ITEM-DEPENDENCIES

Preparation / proposed procedure:

1. Use an authorized reviewable specification to identify table schemas, identifiers, date/filter rules, missing-value rules, lag/window history and output paths for the full sample branch.
2. Confirm how the dynamic WORK tables and external helper include are produced and consumed within the supplied stage.
3. Keep this stage code-present and the unknown contracts unresolved until documented; do not treat the whole-file safe-view withholding as absent code/data.

Validation to perform later:

- Before a later authorized run, compare generated output schemas and fields with the visible Stata entry and branch consumers, including the data export/load ordering.

### A-CLARIFY-CRSP2017-MAPPING: Configure the CRSP2017 SAS namespace as a same-data libref/path alias to the verified local CRSP.DSF route used by the visible daily stock consumer.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: R-CRSP-DSF, I-CRSP2017-LIBREF
Evidence: E-MOMADJ-DATE-PRICE, E-CAT-CRSP-DSF, E-PROBE-CRSP-DSF, E-PUB-WRDS-CRSP-SIZ, E-PUB-FRENCH-CIZ

Preparation / proposed procedure:

1. Set the CRSP2017 libref/path to the existing local CRSP.DSF product; preserve the source dataset and its contents.
2. Keep the empirical-period and construction-lookback coverage check as a later validation step.

Validation to perform later:

- Before a later authorized run, confirm the CRSP2017 namespace resolves to the selected local legacy DSF and that its period/lookback coverage satisfies the visible consumer.

### A-CLARIFY-WD-FIELD-PRODUCERS: Identify the supplied producers and definitions for Hvalue_3, tna_3 and sizetna, including keys, units, date alignment and required history.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-WD-FIELD-PRODUCERS
Evidence: E-WD-HVALUE3-USE, E-WD-MEASURE-FIELDS, E-WD-MEASURE-OUTPUT

Preparation / proposed procedure:

1. Trace each field to its actual visible producer or obtain the source specification if the producer is outside this program.
2. Record same-data namespace/path mapping separately from any scientific definition; do not infer a formula or variable construction.

Validation to perform later:

- Before a later authorized run, verify that each field is present at its consumer step with the documented unit/key/date convention.

### A-CLARIFY-WINSORIZE-TRUNCATE: Confirm the exact WinsorizeTruncate.sas include file, path, macro interface and required input fields for the sample-construction stage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-WINSORIZE-TRUNCATE-INCLUDE
Evidence: E-WORK-ITEM-DEPENDENCIES, E-DATASHEET-CODE

Preparation / proposed procedure:

1. Check the assigned package's authorized file inventory and accompanying author documentation for the helper; if its location or interface is unspecified, obtain the exact specification.
2. Do not substitute another truncation or winsorization formula.

Validation to perform later:

- Before a later authorized run, confirm the include resolves and its inputs/outputs match the documented call without changing the study design.

### A-CLARIFY-UNBALANCED-SAMPLE: Confirm the named SAS producer and exact generation contract for finalsam_unbalance, including rdate1/rdate2 and its relation to the main sample.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-FINALSAM-UNBALANCE-PRODUCER
Evidence: E-STATA-UNBALANCED, E-DATASHEET-CODE, E-WORK-ITEM-DEPENDENCIES

Preparation / proposed procedure:

1. Obtain the producer specification for this distinct unbalanced-sample product and confirm whether its date fields are generated in the supplied sample-construction branch.
2. Retain this Stata table branch and do not substitute finalsam or infer an unbalanced-sample algorithm.

Validation to perform later:

- Before a later authorized run, check that the generated product and its date fields exist and match the supplied Stata branch's documented use.

### A-FIX-WD-HOLDINGS-ALIAS: Correct the same-data holdings input spelling in the WD_measure output step.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I-WD-HOLDINGS-ALIAS
Evidence: E-WD-HOLDINGS-TYPO

**Proposed edit:** `WD_measure.sas:146–146`
Source SHA-256: `848461fe62a59385004a572f3362d25ad803356acb729b0645df74965c737136`

Hret4 is created immediately before the output step; Hert4 is a same-data spelling mismatch.

Current text:
```
data WD.holdings_wficn; set Hert4; Hvalue_0=shares_adj*prc_adj; run;
```

Proposed replacement:
```
data WD.holdings_wficn; set Hret4; Hvalue_0=shares_adj*prc_adj; run;
```

Preparation / proposed procedure:

1. Review the one-line alias correction at WD_measure.sas line 146.
2. Apply only as a proposed same-data spelling correction; no source file is edited in this assessment.

Validation to perform later:

- In a later authorized SAS run, confirm the holdings output step reads the Hret4 table created immediately above and preserves its keys/fields.

### A-FIX-WD6-MOMADJ-ALIAS: Correct the same-data WD6MomAdj table spelling before the following join.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I-WD-MOMADJ-ALIAS
Evidence: E-MOMADJ-ALIAS

**Proposed edit:** `WD_momadj_measure.sas:444–444`
Source SHA-256: `522af9b2fd0e1a08835200f84a5f7ad18c336596631ff1a52e3475450a2aed26`

The following visible join consumes WD6MomAdj; this spelling correction does not change calculations.

Current text:
```
data WD6MomAdi; set alpha170; wd170_v3=wd170_v3*180; drop _freq_ _n_;
```

Proposed replacement:
```
data WD6MomAdj; set alpha170; wd170_v3=wd170_v3*180; drop _freq_ _n_;
```

Preparation / proposed procedure:

1. Review the one-line table alias correction at WD_momadj_measure.sas line 444.
2. Apply only as a proposed same-data spelling correction; no source file is edited in this assessment.

Validation to perform later:

- In a later authorized SAS run, confirm the created WD6MomAdj table is consumed by the following join and preserves the existing return calculation.

### A-FIX-STATA-TEMPFILE-HANDLE: Declare the temp1 tempfile handle used by the later Stata save/use sequence while preserving the earlier all handle.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I-STATA-TEMPFILE-HANDLE
Evidence: E-STATA-TEMPFILE, E-STATA-ALL-TEMPFILE-INIT, E-STATA-ALL-TEMPFILE-USE1, E-STATA-ALL-TEMPFILE-USE2

**Proposed edit:** `Regressions.do:240–240`
Source SHA-256: `e26e5e2bcefb082bc70b040599b8e1521dab9fabda5c0150019d4574442db235`

Line 240's following save/use statements reference temp1; declaring temp1 here avoids reassigning the earlier all handle used again later.

Current text:
```
	tempfile all
```

Proposed replacement:
```
	tempfile temp1
```

Preparation / proposed procedure:

1. Review the earlier all handle and later temp1 save/use statements.
2. Change only the later tempfile declaration at line 240; no data, estimation or table logic changes are proposed.

Validation to perform later:

- In a later authorized Stata run, confirm the temp1 save/use pair resolves and the original all handle remains available to its later uses.

### A-CLARIFY-STATA-WD6-REFERENCE: Resolve whether wd6 at Regressions.do line 107 is an intended exact field or a permitted abbreviation of wd60_v3 before proposing any line 8 keep-list change.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-STATA-WD6-KEEP
Evidence: E-STATA-ENTRY, E-STATA-WD60-INTERMEDIATE, E-STATA-WD6-CONSUME, E-PUB-STATA-VARABBREV

Preparation / proposed procedure:

1. Inspect the authorized finalsam schema and effective varabbrev setting when available; identify the intended measure/reference from the supplied data definition.
2. If wd6 is a distinct intended field, confirm its source and values before proposing same-data retention; if it is intended as an abbreviation, preserve the existing wd60_v3 flow. Do not edit the keep list while the meaning is unresolved.

Validation to perform later:

- Before a later authorized run, verify the imported field list and effective abbreviation setting, then confirm line 107 selects the intended field without changing the analysis measure or sample.


## Remaining issues and prerequisites

- I-REGRESSION-SOURCE-OPAQUE [unresolved; full_pipeline]: Regression_sample.sas is a supplied 555-line entry program, but the root-verified safe view withholds the complete body. The current assessment therefore preserves the program as code-present and leaves sample-builder-specific producer, alias and output-path details unresolved where they cannot be independently supported by the visible companion stages. The mask is not evidence of missing code or data.
- I-WD-FIELD-PRODUCERS [unresolved; full_pipeline]: In the visible WD_measure program, Hvalue_3 is consumed and tna_3/sizetna are referenced in the output construction, but their exact producer, key, period, unit and construction-history contracts are not established. Confirm the supplied producer and its field definitions; do not infer formulas.
- I-MOMENTUM-FACTOR-CONTRACT [unresolved; full_pipeline]: The momentum-adjusted workflow consumes author-specific mom_1 and mom_3 series for three- and six-month windows. The sampled local daily factor table contains standard factors but not these custom fields; exact construction, source, history and timing remain unresolved.
- I-CRSP2017-LIBREF [preparation; full_pipeline]: WD_momadj_measure names CRSP2017.dsf while the verified compatible local legacy route is CRSP.DSF. Configure the CRSP2017 libref/path as a same-data alias to that product before execution; empirical coverage remains a route-validation check, and the external CIZ format change does not require conversion of this compatible local route.
- I-WINSORIZE-TRUNCATE-INCLUDE [unresolved; full_pipeline]: The assigned workflow dependency ledger records a WinsorizeTruncate.sas source include. The exact include file, path and macro interface are not established in this safe review; confirm the supplied helper and its expected inputs before running the sample-construction stage.
- I-FINALSAM-UNBALANCE-PRODUCER [unresolved; full_pipeline]: The separate unbalanced-sample Stata branch consumes finalsam_unbalance with rdate1/rdate2 fields. Its named SAS producer is part of the supplied, code-present sample-construction stage, but the exact output construction and field contract cannot be verified from the fully withheld safe view.
- I-WD-HOLDINGS-ALIAS [preparation; full_pipeline]: WD_measure creates Hret4 and the holdings output step refers to Hert4. This is a supported same-data spelling correction at the visible handoff.
- I-WD-MOMADJ-ALIAS [preparation; full_pipeline]: WD_momadj_measure creates WD6MomAdi while the following join refers to WD6MomAdj. This is a supported same-data spelling correction at the visible handoff.
- I-STATA-WD6-KEEP [unresolved; full_pipeline]: Regressions.do line 8 retains wd60_v3 but not exact wd6; lines 84–91 collapse and restore wd60_v3, while line 107 uses wd6. StataCorp documents unique variable-name abbreviations, so if abbreviation is enabled wd6 may select wd60_v3. The imported finalsam schema, effective abbreviation setting and intended reference are unverified; adding wd6 to the keep list could change the selected measure.
- I-STATA-TEMPFILE-HANDLE [preparation; full_pipeline]: The later Stata block declares tempfile all but saves and reloads temp1; the earlier all handle is used again later. Declare temp1 at the later block so the original all handle remains available.
- R-CRSP-DSI [undetermined]: Daily CRSP market-index returns consumed by the sample-construction stage.
- R-CRSPF-FUND-STYLE [undetermined]: CRSP mutual-fund style/objective fields used to form the domestic-equity fund subset.
- R-CRSPF-FUND-SUMMARY [undetermined]: CRSP fund-summary fields used in the fund-style/objective filter.
- R-CRSPF-MONTHLY-RETURNS [undetermined]: CRSP monthly fund-class returns used for net/raw return and future-return construction.
- R-CRSPF-MONTHLY-TNA [undetermined]: CRSP monthly fund-class net assets used for fund-size weights and daily TNA construction.
- R-CRSPF-FUND-FEES [undetermined]: CRSP fund-class expense-ratio intervals used to construct raw returns.
- R-CRSPF-DAILY-RETURNS [undetermined]: CRSP daily fund-class returns used for daily return-gap construction.
- R-CRSPF-MONTHLY-NAV [undetermined]: CRSP monthly fund-class NAV used to infer daily shares/assets.
- R-CRSPF-DAILY-NAV [undetermined]: CRSP daily fund-class NAV used with monthly assets to construct daily TNA.
- R-S12-TYPE1 [undetermined]: Thomson S12 type-1 reporting/vintage history used to define fund reporting dates.
- R-S12-TYPE3 [undetermined]: Thomson S12 type-3 security holdings and shares matched to type-1 fund/date records.
- R-MFLINK1 [undetermined]: CRSP fund-class to WFICN linking table used for monthly/daily aggregate returns.
- R-MFLINK2-BEG-END [undetermined]: Thomson fund number to WFICN crosswalk with effective link-date bounds for both S12 stages.
- R-FF-DAILY-CUSTOM [undetermined]: Daily factor series including the author-specific mom_1 and mom_3 variables used by the three- and six-month WD adjustments.
- R-CRSPF-FRONT-LOAD [undetermined]: CRSP mutual-fund front-load terms used in the fund-return adjustment workflow.
- R-CRSPF-REAR-LOAD [undetermined]: CRSP mutual-fund rear-load terms used in the fund-return adjustment workflow.
- R-IBES-DETAIL [undetermined]: I/B/E/S detail records used by the fund/sample-construction workflow.
- R-IBES-ICLINK [undetermined]: I/B/E/S-to-CRSP identifier-link history used by the sample-construction workflow.
- R-TREATMENT-FUNDS [undetermined]: Treatment-fund classification input for sample construction; its producer, unit, fields and effective-date convention require confirmation.
- R-FILING-DATES [undetermined]: Filing-date input for sample construction; the filing universe, issuer/fund key and date convention require confirmation.
- SW-SAS-BASE [unverified]: Required to run the supplied SAS workflow. The bounded environment projection does not verify the SAS installation state for this assessment.
- SW-SAS-STAT-REG [unverified]: PROC REG is a required SAS statistical component for the supplied workflow; module and license availability are unverified.
- SW-SAS-ACCESS-PCFILES [unverified]: The SAS-to-Stata handoff requires the PC Files export engine for DBMS=STATA; module and license availability are unverified.
- SW-STATA-WINSOR2 [preparation_required]: The workflow requires winsor2, but the bounded search-path probe did not find it on the current Stata adopaths. This is a setup task, not evidence of global unavailability.
- SW-STATA-PSMATCH2 [preparation_required]: The workflow requires psmatch2, but the bounded search-path probe did not find it on the current Stata adopaths. This is a setup task, not evidence of global unavailability.

## Review notes

- A previous stop was classified as sensitive after a worker display included a previously screened SAS source range. Actual value/type/validity/effects and unreported display consequences remain unverified. The protected display body/transport capture was not retrieved or reconstructed; no credential use, test or connection is reported.
- A later worker redacted view left a line in the known Regression_sample.sas range visible because of a mask-offset error. Its body remains protected and untouched. This assessment uses only the later independently verified coordinator view, which withholds lines 480–490 inclusive and the full 555-line sample-builder source.
- A path-only listing command was run in the execution_feasibility tree while searching for a safe reader. The known command was `rg --files historical artifact execution_feasibility | rg 'redact|safe|mask|structural|environment_metadata|finalize_clean' | sort` from `[LOCAL_PATH_REDACTED]; its tool output was truncated, and the complete raw stream and nested return code were not preserved. No exhaustive absence or no-effects conclusion is drawn from that event.
- The supplied appendix is treated as publication context; the assessed target remains the three SAS programs and every branch in Regressions.do. No author code or data were run or edited.
- Common-resource and software facts use the exact bounded prior probes and official static pages; no broad catalog walk, product payload download or entitlement test was made. Catalog misses and one-row metadata remain discovery/sample evidence, not proof of absence, full history or access.
- Static completion used the root release disposition 7e3664d421b4f80547dd1c67831dc6ce7b79df7248e6e903596c5a0181652d05 and only the coordinator-verified safe views. Regression_sample.sas remains code-present; its entire 555-line implementation is withheld in that safe view. This review makes no claim about the original protected material's contents, validity, use or effects.
- Reference/route revision: the safe Regressions.do view (lines 8, 84–91 and 107) plus StataCorp User’s Guide §11.2.3 shows that the wd6 reference may depend on unique-prefix abbreviation; the finalsam schema, effective setting and intended field remain unknown. The unsupported line 8 edit was removed and replaced with conditional clarification. Existing local CRSP.MSF/DSF/MSENAMES and FF monthly field probes are credited for the matched fields/time keys; coverage, history and route-specific construction checks remain unresolved where not observed. The full 555-line sample builder remains code-present but withheld. No author code, data or model was run or changed, and no new probe was made.
- Raw-route completion: existing catalog and bounded field probes support the local CRSP.MSF, CRSP.DSF, CRSP.MSENAMES and FF.FACTORS_MONTHLY product/field routes for their named visible or declared uses. Those underlying routes receive compatibility credit; empirical 1998–2012 coverage, identifier/date continuity, historical CUSIP matching and lag/window extent remain validation checks. The separate DSI/sample-builder producer contract and its exact hidden field/order use remain unresolved; the hidden SAS body is still code-present and withheld. The custom daily mom_1/mom_3 definitions remain unresolved. No new source review or probe was performed.
