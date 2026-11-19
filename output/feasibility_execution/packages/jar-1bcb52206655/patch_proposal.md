# Patch proposal: jar-1bcb52206655

Procyclicality of US Bank Leverage

DOI: 10.1111/1475-679X.12163

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete assessed workflow for the main Tables 1–8 and the supplied online appendix analyses A–E; appendix companion procedures and inputs remain unresolved.

Entry points: `procyclicality_code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 2/12163 - Procyclicality-of-US-Bank-Leverage/laux-rauter-datasheet-and-code.zip",
      "sha256": "1c8aef115b839b9e7451ddd83410be14e0b6f91da3aff847885783e090d7c8e4"
    },
    {
      "path": "JAR-Volume 55/Issue 2/12163 - Procyclicality-of-US-Bank-Leverage/laux-rauter-online-appendix.pdf",
      "sha256": "2e247226998082b76caf2d88d1ff24efb7daeffee73bd2621b6d596fa29b71e0"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6c5af1b6f2bb7e97911c10d87c9b1e6de7b02afb5c6fe5ea87197e5415ede33d",
  "work_item_sha256": "9272df29a9febe3c59ab3be50d38ba95ae7995806db512d984dbb14e37dfbe40"
}
```

## Proposed actions

### A-SNL-ACCESS: Establish a current permitted route to the author-specified SNL bank data or an author-approved compatible prepared workbook, then populate bank_data_raw.xlsx using the supplied sample-ID list and SNL KeyField mapping.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R-SNL-BANK
Evidence: EV1, EV2, EV3, EV4, EV7, EV14, EV15

Preparation / proposed procedure:

1. Confirm current SNL Financial access and the data-use terms for the project; the package does not document a current license or access route.
2. Use the 932 supplied institution identifiers and the 26 SNL KeyField numbers to request/download the documented US commercial/savings-bank holding-company series with full coverage depth.
3. Obtain quarterly observations for Q1 1994 through Q1 2013, including the SNLxl period field, and save an Excel workbook named bank_data_raw.xlsx in the configured run directory.
4. Verify the exported first-row variable names match the supplied do-file’s expected fields before running; preserve the source identifier list separately because the do-file exports to the same filename.

Validation to perform later:

- Confirm authorization and permitted data use before acquisition.
- Check that the raw workbook exposes all expected fields, includes the author’s full quarterly range and selected institutions, and reflects the documented historical/revision vintage or an author-approved equivalent.
- Confirm that the project can retain the data only in accordance with the current SNL terms.

### A-BEA-GDP: Acquire the supported public quarterly BEA real-GDP level series and prepare macro_data_raw.xlsx in the field and history format required by the Stata code, documenting the selected data vintage.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R-BEA-GDP
Evidence: EV2, EV3, EV4, EV6, EV14, EV26, EV27

Preparation / proposed procedure:

1. Acquire quarterly real GDP levels from BEA’s “Real GDP (Inflation-Adjusted Dollars): Quarters, Since 1947” product; FRED GDPC1 identifies the corresponding BEA account A191RX as quarterly real GDP in chained 2017 dollars at a seasonally adjusted annual rate. Select the level series, not a percent-change series, and retain the source and vintage metadata.
2. Check whether the BEA historical/vintage archive can provide the authors’ reported October 2015 vintage. If using the current revised series, record the retrieval date and vintage and do not describe it as an exact historical-value match.
3. Reshape/reformat the quarterly observations for Q1 1994 through Q1 2013 into a long-format workbook with period and real_gdp columns, documenting the source-column mapping and quarter encoding; save it as macro_data_raw.xlsx in the configured run directory.

Validation to perform later:

- Confirm one correctly ordered observation per quarter from Q1 1994 through Q1 2013 and that the selected data are real-GDP levels, not growth rates.
- Check the source-to-target column mapping, units, quarterly frequency, seasonal-adjustment/annual-rate metadata, and selected vintage; record any difference from the authors’ October 2015 vintage.
- After authorized preparation, verify the code creates gdp_data.dta before the bank merge and inspect the resulting quarter alignment.

### A-WORKDIR: Configure the author’s working directory placeholder and isolate run outputs from the source package and acquisition-selector file.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I-WORKDIR
Evidence: EV5, EV9, EV10

Preparation / proposed procedure:

1. Create/use a writable run directory that contains bank_data_raw.xlsx and macro_data_raw.xlsx.
2. Set the `cd` path in the run copy according to the do-file instruction; do not edit the frozen package in this assessment.
3. Keep the supplied snl_institution_keys.txt in a separate read-only acquisition/reference location because the code writes the final key list to that same filename.
4. Run the author do-file from the configured directory so the log and table_*.rtf outputs are written to a known location.

Validation to perform later:

- Before an authorized run, confirm the working directory resolves, both input files are readable there, and the source key list remains unchanged.
- After an authorized run, confirm the log and expected RTF outputs are created in the run directory.

### A-APPENDIX-WORKFLOW: Obtain the missing companion workflow, compatible inputs, and producer-consumer sequence for the online appendix analyses included in the full-pipeline target.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-APPENDIX-INPUTS, I-APPENDIX-WORKFLOW
Evidence: EV3, EV11, EV12, EV13

Preparation / proposed procedure:

1. Request the companion entrypoints or complete author-approved processing and regression procedures for appendix sections A–E, including Tables IA2–IA5.
2. Request the exact additional data fields, prepared inputs/intermediates, and their production order needed for the crisis/TARP and loan-portfolio analyses.
3. Map each required appendix output to its supplied procedure and compatible inputs alongside the main Tables 1–8 workflow; do not reconstruct analyses from published appendix estimates.

Validation to perform later:

- Map each required supplementary table to a supplied procedure, compatible input, and correct producer-consumer order.
- Check that any newly supplied programs preserve the author-reported sample period and methods and regenerate the corresponding appendix outputs.


## Remaining issues and prerequisites

- I-WORKDIR [preparation; full_pipeline]: The Stata do-file retains `cd ""` as an explicit directory placeholder and uses relative paths for both raw inputs, its log, generated files, and RTF table outputs. It also writes a final key list to the same `snl_institution_keys.txt` name supplied as the SNL acquisition selector, so the source key list should be preserved outside the run-output directory.
- I-APPENDIX-WORKFLOW [unresolved; full_pipeline]: The full-pipeline target includes the online appendix sections A–E and outputs such as Tables IA2–IA5 on crisis/TARP effects and alternative loan/business-model measures. The supplied datasheet/main code map Tables 1–8, while the package does not map appendix outputs to code, additional fields/intermediates, or their procedures/order. Obtain the companion programs or complete author-approved procedures and compatible inputs; do not reconstruct the additional analyses from reported appendix tables.
- R-SNL-BANK [undetermined]: SNL Financial bank-level quarterly data for the US commercial and savings banks/holding companies selected by the authors, Q1 1994 through Q1 2013, imported as bank_data_raw.xlsx. The workbook must expose period and the 26 SNL variables named in the supplied field dictionary and code: instkey, industry, totassets, taccass, afssec, htmsec, net_lns, gw, cash_equ, totequ, totdep, seniordebt, totsubdebt, rwa, tieroneratio, rwcapitalratio, marketcap, chg_unrealgain, netprofit, gainsaleloan, tot_assetssec, uncmt_onefourrevlin, uncmt_creditcardlin, uncmt_totcommrelin, uncmt_secunderwrit, and uncmt_othcmt.
- R-BEA-GDP [public_acquisition_required]: Quarterly real US GDP levels for Q1 1994 through Q1 2013, prepared as the long-format macro_data_raw.xlsx input. The code imports period and real_gdp, encodes calendar quarters, and computes adjacent-quarter GDP growth; the authors report an October 2015 download vintage.
- R-APPENDIX-INPUTS [undetermined]: The full-pipeline target includes the supplied online appendix analyses A–E, including Tables IA2–IA5. Their compatible input fields, preparation steps, complete procedures/order, and any author-prepared intermediates remain unspecified; the package supplies one main Stata entrypoint for Tables 1–8 but no executable appendix workflow or compatible prepared-input route.

## Review notes

- The initial partial draft was saved after source reading and before environment/catalog/resource checks.
- The supplied identifier file contains 932 unique numeric bank identifiers, and the workbook inspection returns 26 named SNL KeyField mappings plus the separate real_gdp entry. Neither file contains the quarterly bank/GDP observations required by the code.
- The do-file creates gdp_data.dta from macro_data_raw.xlsx before importing and merging the SNL bank workbook. The frozen checklist’s two read dependencies are both reviewed as mandatory inputs.
- The author code’s explicit winsor, eststo, estpost, and esttab commands are available in the checked Stata 18 environment. No author code or dataset was executed.
- The bounded frozen-catalog lookups did not identify a matching local candidate; the default local PostgreSQL endpoint did not respond. Neither check establishes data absence, licensing, or the status of other configured sources.
- The official BEA product page and FRED’s BEA-sourced GDPC1 series page support public acquisition of quarterly real-GDP levels spanning the required period. Current product series, frequency, units, and seasonality are identified; the exact author-reported October 2015 values and workbook headers/layout remain a separate vintage/format check. No data were downloaded.
- The full-pipeline target retains the supplied online appendix A–E analyses. Their companion workflow and compatible inputs remain unresolved; the proposal requests those materials without treating appendix analyses as optional or truncating the target.
