# Patch proposal: jar-5298be84f237

Enhancing Loan Quality Through Transparency: Evidence from the European Central Bank Loan Level Reporting Initiative

DOI: 10.1111/1475-679X.12162

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Supplied Stata workflow for data conversion and cleaning, sample construction and relationship generation, Table 3 Panels A–C loan-quality analysis, and online Appendix Tables A1–A4 robustness analyses. The do-file supplies Panels A and B; Panel C is manual-only and the appendix package contains results/descriptions without executable analysis procedures. The authors’ Stata version is unspecified; local Stata 18 probes are recorded separately.

Entry points: `ELW_code_updated.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 4/12162 - Enhancing-Loan-Quality-Through-Transparency-Evidence-from-the-European-Central-Bank-Loan-Level-Reporting-Initi/elw-datasheet-and-code.zip",
      "sha256": "1933109aa45573e188b87ee7c928b599e337e67ef1a0d577c2c8393caa47c410"
    },
    {
      "path": "JAR-Volume 55/Issue 4/12162 - Enhancing-Loan-Quality-Through-Transparency-Evidence-from-the-European-Central-Bank-Loan-Level-Reporting-Initi/wittenberg-et-al-online-appendix.pdf",
      "sha256": "93b74b414eb52eb39d2c95848241a447133b7d62a999f030636b9103e0ebf73f"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6c5af1b6f2bb7e97911c10d87c9b1e6de7b02afb5c6fe5ea87197e5415ede33d",
  "work_item_sha256": "628ce61d22a8eea7692c9c39a2a0448174201ee410f1192138c059f4a8c40012"
}
```

## Proposed actions

### ACT_EDW_INPUTS: Clarify permitted access and file setup for the author-compatible EDW loan and collateral inputs.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_EDW_LOANS, REQ_EDW_COLLATERAL, ISSUE_INPUT_CLOSURE, ISSUE_VERSION
Evidence: E_AUTHOR_DATA_DATE, E_AUTHOR_RESEARCH_ACCESS, E_EDW_PRODUCT, E_EDW_ACCESS, E_MAIN_RAW, E_COLLATERAL_PATH, E_CODE_VERSION, E_TEMPLATE_DOCS, E_AUTHOR_NONTRANSFER, E_AUTHOR_DELETE

Preparation / proposed procedure:

1. Ask the authors to clarify only what delivery, reuse, metadata or file-manifest information is permitted under the original EDW agreement; do not request or assume transfer of raw individual loan-level bytes.
2. Determine whether a separately approved current EDW route can provide compatible historical loan and collateral inputs, fields, identifiers and reporting history, and confirm its access and use conditions before any acquisition.
3. If permitted, obtain non-sensitive file/version manifests, schema or configuration/setup instructions needed to identify a locally authorized copy, without transmitting loan-level records.
4. Compare any lawfully accessible input metadata, country and reporting-quarter coverage, origination period, and collateral-key coverage with the datasheet and do-file.
5. Resolve why the do-file header says June 4–6 2014 while the datasheet identifies July 2014 as the analytic release.

Validation to perform later:

- Verify exact input filenames, field names, key uniqueness, country coverage and reporting/origination periods only for inputs accessible through a permitted route; follow the original agreement’s nondisclosure and deletion terms.

### ACT_CLEANING_SPEC: Obtain the missing manual standardization and duplicate-selection procedure.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_CLEANING_DEDUP
Evidence: E_AUTHOR_SAMPLE, E_DEDUP_COMMENT

Preparation / proposed procedure:

1. Request the authors’ lender/ABS name crosswalks, bank-specific reporting-quarter corrections, and the exact duplicate ranking/tie-break procedure that implements the comment at ELW_code_updated.do line 288.
2. Confirm the treatment of missing fields/timing errors and ensure the documented cleaning steps correspond to the July 2014 release.

Validation to perform later:

- Compare the supplied procedures with the reported 2,961,217 loan-quarter, seven-country estimation sample after any separately authorized run.

### ACT_RELATION_ORDER: Clarify the intended active dataset and producer-consumer order around relation.dta.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_RELATION_STATE
Evidence: E_REL_SAVE, E_REL_RELOAD, E_REL_MERGE, E_TABLE3_CODE

Preparation / proposed procedure:

1. Ask which dataset should be the master when relation.dta is merged after the full-data relationship construction and whether the cleaned summary_sme_loans should be reloaded before later fixed effects and Table 3 commands.
2. Obtain the intended sample and order from the authors before proposing any code edit; preserve the full-data relationship lookback and the reported restricted analysis sample.

Validation to perform later:

- After clarification, trace that the relationship producer uses the documented full raw history and the Table 3 consumer receives the intended cleaned analysis sample.

### ACT_PANEL_C: Obtain the missing manual classification and implementation for Table 3 Panel C.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_PANEL_C
Evidence: E_PANEL_C, E_TABLE3_CODE

Preparation / proposed procedure:

1. Request the bank list and reproducible selection rule for institutions that borrowed from the ECB ABS repo before 2013Q1, plus the Panel C model/sample procedure.

Validation to perform later:

- Check the documented bank list, period cutoff and model specification against Table 3 Panel C before any authorized execution.

### ACT_APPENDIX_SPECS: Obtain executable procedures, input definitions and sample rules for Online Appendix Tables A1–A4.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_APPENDIX_WORKFLOW, REQ_ECB_GDP, REQ_BANK_LEVERAGE, REQ_ECB_10Y
Evidence: E_APP_A1, E_APP_A2, E_APP_A3, E_APP_A4, E_APP_GDP, E_APP_LEVERAGE, E_APP_COLLATERAL, E_APP_A4_SOURCE, E_SUPP_BANKSCOPE, E_SUPP_CIQ

Preparation / proposed procedure:

1. Request the authors’ Appendix A1–A4 programs or complete procedures, including the Table A1 bank adoption classification, Table A2 collateral asset categories, Table A3 filters, and Table A4 macro merge.
2. Confirm whether Appendix A1.3 uses quarter-on-quarter or year-on-year country GDP growth, how “high GDP growth” is coded, and which GDP observations/quarters feed the issuance-quarter interaction.
3. Identify the bank leverage source and formula, bank identifier crosswalk and quarterly history used in Appendix A1.3; Bankscope is an author-listed source lead but the local catalog candidate does not establish compatible financial data.
4. Confirm the Appendix A2 collateral category coding and which records are excluded as unclassifiable or multiple-asset collateral.

Validation to perform later:

- Map each appendix table to its actual code and inputs; verify sample windows, bank/ABS identifiers and model specifications against the supplied appendix before any separate execution decision.

### ACT_ECB_GDP: Acquire the author-specified country GDP series and implement its confirmed high-growth transformation.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_ECB_GDP
Evidence: E_APP_GDP, E_ECB_MNA

Preparation / proposed procedure:

1. After author clarification of the GDP growth metric and threshold, acquire the matching public quarterly country series from ECB MNA and construct the high-growth indicator using that exact definition.

Validation to perform later:

- Confirm country-quarter coverage and merge quarter to the ABS issuance quarter; compare the resulting indicator definition with author instructions.

### ACT_ECB_IRS: Acquire ECB country 10-year government debt interest series and aggregate monthly observations to the specified origination quarter.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: REQ_ECB_10Y
Evidence: E_APP_A4_SOURCE, E_ECB_IRS_SERIES, E_ECB_IRS_COUNTRY

Preparation / proposed procedure:

1. Download country-level monthly IRS series for the sample countries and the required period, retaining month, country and percentage units.
2. Compute the arithmetic mean of the monthly ten-year observations within each origination quarter as the appendix specifies and merge by country and quarter.

Validation to perform later:

- Check quarterly averages and country/date matches for the 2011Q1-onward Appendix A4 sample before any authorized estimation.


## Remaining issues and prerequisites

- ISSUE_INPUT_CLOSURE [unresolved; full_pipeline]: The package does not contain SME_loans.dta or SME_collateral.dta. The supplied Excel workbook is described as a field-code template, not analysis data. The original EDW contract prohibits transmitting individual loan-level data and requires deletion on termination; any current EDW route is a separate, still-unverified possibility.
- ISSUE_CLEANING_DEDUP [unresolved; full_pipeline]: The datasheet says authors manually corrected lender names, missing fields and timing issues while preparing appended ABS-quarter reports. The do-file has manual-cleaning comments and ends with a duplicate-removal comment without executable deduplication logic; needed crosswalks and exact selection procedure are absent.
- ISSUE_RELATION_STATE [unresolved; full_pipeline]: The do-file saves summary_sme_loans, then reloads the full raw file and contracts it to create relation.dta; the following merge runs in the active contracted/full-data workflow and no reload of summary_sme_loans is shown before fixed effects and Table 3. The intended analysis master, sample state and order need author clarification.
- ISSUE_VERSION [unresolved; full_pipeline]: The do-file header identifies ED raw data version June 4–6 2014, while the datasheet says the analyses use the July 2014 version. The expected file and any version-specific corrections need confirmation.
- ISSUE_PANEL_C [unresolved; full_pipeline]: Table 3 Panel C is only described as using manually identified banks that borrowed from the ECB ABS repo before 2013Q1. No hand-collected bank list, selection procedure or Panel C code is supplied.
- ISSUE_APPENDIX_WORKFLOW [unresolved; full_pipeline]: Online Appendix Tables A1–A4 have results and prose descriptions but no supplied executable analysis program or complete procedures. Appendix A1.3 leaves the GDP growth definition/high-growth threshold and bank leverage source/base definition unclear; Appendix A2 needs ED collateral categories.
- REQ_EDW_LOANS [undetermined]: Author-prepared SME loan-level reporting records for the July 2014 analysis version, covering 2013Q1–2014Q2 reports and the 2009–2014 origination sample across seven countries, with the ED variables and identifiers used by ELW_code_updated.do (including as1–as7, as15, as18, as20, as25, as26, as37, as42, as50, as51, as53–as57, as65, as80, as115–as118, as121–as123 and as125).
- REQ_EDW_COLLATERAL [undetermined]: ED Loan Collateral Database input used as SME_collateral.dta, merged by loan_id and pool_id for collateralization and Appendix A2 asset classifications.
- REQ_ECB_GDP [undetermined]: Appendix A1.3 country GDP growth at the quarter of ABS issuance and the author-defined high-growth indicator used in the interaction model.
- REQ_BANK_LEVERAGE [undetermined]: Appendix A1.3 bank leverage ratio by quarter and bank, including at least four prior quarters, plus the exact bank identifier mapping and base leverage definition.
- REQ_ECB_10Y [public_acquisition_required]: Country-level ten-year government debt interest rate for Appendix A4, averaged over the quarter of loan origination, for loans originated after 2011Q1.

## Review notes

- Saved expanded findings after reading all assigned author sources and before controller finalization. Only read-only source/catalog/public-resource checks and small Stata software probes were performed; no author program, regression or study dataset was run or downloaded.
- The SME Template is a documentation workbook, not an analysis dataset. The Appendix A1–A4 results are within the full target scope, but the package supplies no appendix program.
- Commercial-source catalog searches are discovery only: the absence of a compatible local candidate does not establish missing institutional licensing. No Capital IQ substitution is claimed for the Appendix A1.3 leverage input.
