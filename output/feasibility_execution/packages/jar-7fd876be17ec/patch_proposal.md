# Patch proposal: jar-7fd876be17ec

Algorithmic Trading and Forward-Looking MD&A Disclosures

DOI: 10.1111/1475-679X.12540

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | blocked |

### full_pipeline

Assess the supplied author data-construction workflow through the SAS output mydata.finaldataMDAAT, including the separate MD&A text and modification code. The appendix's regression tables are contextual; this package supplies no regression entry point.

Entry points: `AT.sas`, `GetForwardLooking_CalculateModification.py`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 4/12540 - Algorithmic-Trading-and-Forward-Looking-MD-A-Disclosures/twz-datasheet-code-and-identifiers.zip",
      "sha256": "bef15d288428afad4a9e89bca2c601acf57c9baa6a53e43cc02f35b5ec0c4ded"
    },
    {
      "path": "JAR-Volume 62/Issue 4/12540 - Algorithmic-Trading-and-Forward-Looking-MD-A-Disclosures/twz-online-appendix.pdf",
      "sha256": "d4767d9a4580e4378d85210ba71f0f343ae2b046925e69232da7c52bbb4db5df"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "93d22e8c3391f5e8fb560dfab74bd31a71a5251c1f9db4879c5010c8283a37ca"
}
```

## Proposed actions

### ACT_MIDAS: Resolve the exact author-described WRDS MIDAS security input or compatible prepared file before choosing a route; the bounded catalog search returned no candidate for the MIDAS aliases.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_MIDAS_SECURITY
Evidence: EV_DOC_PRODUCTS, EV_SAS_MIDAS, EV_CATALOG_SUMMARY

Preparation / proposed procedure:

1. Request the exact MIDAS table/file name, local or authorized WRDS route, required fields, date range, and any prepared form used by the authors.
2. Do not infer data absence, subscription status, or a license barrier from the catalog alias misses.

Validation to perform later:

- Once a concrete route is identified, run the bounded one-row required-field/readability check and verify the author-required period and identifiers before any program execution.

### ACT_COMPUSTAT: Prepare the supplied SAS stages against the catalog-listed, readable COMP.FUNDA candidate after confirming its fiscal-year history and population match the author windows.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_COMPUSTAT_FUNDA
Evidence: EV_SAS_COMPUSTAT, EV_SAS_HERF, EV_CATALOG_SUMMARY, EV_COMP_FUNDA_PROBE

Preparation / proposed procedure:

1. Use ${ACCTREPL_SAS_ROOT}/comp/d_na/funda.sas7bdat as the current local candidate; the required source fields passed a one-row check.
2. Confirm 2012–2021 fiscal-year history and observations needed for author filters, lags, and SIC-year concentration before constructing downstream panels.

Validation to perform later:

- Check the exact date range, key fields, and needed lag periods on the selected input using an authorized bounded metadata/data review.

### ACT_CRSP_LINK: Use the catalog-listed CRSP/Compustat link-history candidate only after its dated link coverage is confirmed for the author join windows.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_CRSP_LINKTABLE
Evidence: EV_SAS_LINK, EV_CATALOG_SUMMARY, EV_CRSP_LINK_PROBE

Preparation / proposed procedure:

1. The local candidate and gvkey/lpermno/linkprim/linktype/linkdt/linkenddt fields passed a one-row check.
2. Confirm appropriate link dates and author join filters for the required fiscal-year observations.

Validation to perform later:

- Review exact selected-file dates, keys, and retained links against the source's join requirements before executing AT.sas.

### ACT_CRSP_NAMES: Prepare the author-required dated ticker/exchange and historical CUSIP matches using a compatible stocknames product whose exact history is confirmed.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_CRSP_STOCKNAMES
Evidence: EV_SAS_NAMES, EV_SAS_TFN, EV_CATALOG_SUMMARY, EV_CRSP_NAMES_PROBE, EV_CRSP_NAMES_V2_PROBE

Preparation / proposed procedure:

1. The non-V2 local STOCKNAMES candidate passed a one-row field/readability check; its effective-date and CUSIP history still needs confirmation.
2. Treat STOCKNAMES_V2 as a distinct unverified alternative because its bounded field request did not verify the requested aliases; do not assume the two product variants are interchangeable.

Validation to perform later:

- Confirm the selected product's date history and CUSIP fields against both stocknames consumers before applying the documented joins.

### ACT_CRSP_MSF: Prepare CRSP monthly returns for the standard-deviation and lagged-change stage after confirming the required years and adjacent-year records.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_CRSP_MSF
Evidence: EV_SAS_MSF, EV_CATALOG_SUMMARY, EV_CRSP_MSF_PROBE, EV_CRSP_MSF_V2_PROBE

Preparation / proposed procedure:

1. The CRSP.MSF local candidate passed the one-row PERMNO/DATE/RET check.
2. Keep the WRDS MSF_V2 candidate separate and unverified; the bounded request did not verify its requested aliases.

Validation to perform later:

- Confirm exact return history through 2010–2020 and the adjacent-year observations used by the source before author-code execution.

### ACT_CRSP_DSF: Prepare CRSP daily volume, price, share-count and adjustment-factor inputs after confirming the author's full date window and prior-year observations.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_CRSP_DSF
Evidence: EV_SAS_DSF, EV_CATALOG_SUMMARY, EV_CRSP_DSF_PROBE, EV_CRSP_DSF_V2_PROBE

Preparation / proposed procedure:

1. The CRSP.DSF local candidate passed a one-row check for PERMNO, DATE, VOL, PRC, SHROUT, and CFACSHR.
2. Keep the WRDS DSF_V2 candidate distinct and unverified because the bounded request did not verify its requested aliases.

Validation to perform later:

- Confirm daily history through the author's 2011–2021 construction window and the prior-year observations before constructing annual changes.

### ACT_TFN: The catalog lists a TFN.S34 local candidate, but two bounded one-row required-field probes timed out; its readability and field availability remain unverified.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_TFN_S34
Evidence: EV_DOC_PRODUCTS, EV_SAS_TFN, EV_CATALOG_SUMMARY, EV_TFN_S34_TIMEOUT_1, EV_TFN_S34_TIMEOUT_2

Preparation / proposed procedure:

1. If this candidate is selected, establish an accessible exact-file route and required holdings-field/date coverage through an authorized bounded check; preserve both recorded timeouts without inferring absence or license status.
2. Retain the source's S34 dates, identifiers, share fields, and pre-datadate match windows.

Validation to perform later:

- Before construction, confirm requested fields and date history for the selected S34 source using an authorized bounded check.

### ACT_AUDITOPIN: Assess the readable Audit Analytics FEED34 candidate against the product revision and period used by the source's AUDIT.AUDITOPIN reference.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_AUDITOPIN
Evidence: EV_DOC_PRODUCTS, EV_SAS_AUDIT, EV_CATALOG_SUMMARY, EV_AUDIT_FEED34_PROBE

Preparation / proposed procedure:

1. Use the FEED34 route only as a candidate: the one-row probe confirms auditor_name, company_fkey, fiscal_year_end_op, and fiscal_year_of_op fields, but does not establish product revision or historical compatibility.
2. Confirm 2011–2019 product history and key semantics before preparing the auditor classification stage.

Validation to perform later:

- Compare the selected candidate's product/field/date contract with the source consumer and verify required history before execution.

### ACT_FL_MDA: Resolve the prepared mydata.fl_MDA input contract or its actual producer while preserving either supported prepared-input route or author producer workflow.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_FL_MDA, ISSUE_FL_MDA_HANDOFF
Evidence: EV_SAS_FL, EV_PY_FORWARD, EV_PY_MOD, EV_PY_DRIVER, EV_PACKAGE_INVENTORY

Preparation / proposed procedure:

1. Request the exact prepared table or producer, its char_gvkey/fyear/difference fields, keys, period, and any mapping from the per-file Python text or score outputs.
2. Do not rebuild an independent MD&A pipeline if the authors provide a compatible prepared table; keep undocumented mappings unknown.

Validation to perform later:

- Once the input is identified, verify its actual fields, join keys, and coverage against every supplied SAS consumer with a bounded check.

### ACT_INDEXLINKS: Request the exact producer or prepared mydata.IndexLinks_8k source and its filing-link data contract for the supplied 8-K join.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_INDEXLINKS_8K, ISSUE_INDEXLINKS_PRODUCER
Evidence: EV_SAS_INDEX, EV_DOC_PRODUCTS, EV_PACKAGE_INVENTORY, EV_PUBLIC_SEC_EDGAR

Preparation / proposed procedure:

1. Obtain the actual CIK/filing-date fields, population, period, source table/file and mapping into the final SAS join.
2. The SEC search landing page and the author datasheet's EDGAR provenance do not establish that the search interface or any particular filing set produces IndexLinks_8k.

Validation to perform later:

- After the prepared input or producer is supplied, verify the 364-day lookback, join keys, date coverage, and output mapping without inventing cikd/fillingdate lineage.

### ACT_MDA_INPUTS: Request the author's exact MD&A input corpus, filename sequence, scoring weights, keyword lists, and Python configuration/output contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_MDA_TEXT, REQ_MDA_SEQUENCE, REQ_SCORE_WEIGHTS, ISSUE_PYTHON_CONFIG
Evidence: EV_DOC_PRODUCTS, EV_DOC_CODE, EV_PACKAGED_IDENTIFIERS, EV_PUBLIC_SEC_EDGAR, EV_PY_SETUP, EV_PY_FORWARD, EV_PY_DRIVER, EV_PY_MOD

Preparation / proposed procedure:

1. The source requires a configured filename CSV and score-weight CSV; the packaged identifiers.xlsx first-sheet sample has GVKEY/FYEAR columns and is not evidence of that filename sequence or weights file.
2. Clarify filing years/population, text format, sequence ordering, required firm/year identifiers, globals and output fields, and how the optional/commented score function is intended to feed the SAS input.
3. Use either a compatible author-prepared text/input route or a documented author source workflow; do not infer that raw SEC rebuilding is required.

Validation to perform later:

- After inputs and configuration are identified, compare actual file order, mappings, weights, output fields, and sample period to the SAS consumer contract before any authorized run.

### ACT_SW_SAS: Resolve the observed SAS startup diagnostic and verify SAS Base version and procedure availability before data construction.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS
Evidence: EV_ENVIRONMENT, EV_SAS_MIDAS, EV_SAS_HERF

Preparation / proposed procedure:

1. The local SAS 9.4 executable returned a TKELS initialization failure in the bounded environment probe; this does not establish a missing license.
2. Confirm a usable SAS runtime and the standard procedures required by AT.sas, then resolve library assignments for the verified source inputs.

Validation to perform later:

- Record exact SAS version, available required procedures, and configured library locations before any authorized execution.

### ACT_PYTHON_CONFIG: Obtain a complete author source/configuration for the statically incomplete Python structures and the external values referenced by the functions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_PYTHON_CONFIG
Evidence: EV_PY_SETUP, EV_PY_FORWARD, EV_PY_DRIVER, EV_PY_MOD

Preparation / proposed procedure:

1. Request the complete forwardLookingList and exclusionList assignments and intended indentation/body for calculateForwardLookingModification.
2. Request definitions/values or authoritative setup for paths, input/output filenames, weights, count/location fields, and intended invocation; do not invent globals or output contracts.

Validation to perform later:

- Review any author-supplied completion statically, then validate the exact source and output files only in a later authorized execution step.

### ACT_EXCHCD: Clarify the exact source and timing of the exchange-code filter at atrading2 without changing its sample or inventing a field carry-forward.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_EXCHCD_STAGE
Evidence: EV_SAS_MIDAS, EV_SAS_EXCHCD, EV_SAS_NAMES, EV_CRSP_NAMES_PROBE

Preparation / proposed procedure:

1. Request the intended exchcd source and firm/ticker/date matching rule for the stage immediately following atrading1.
2. Keep the separate later CRSP.STOCKNAMES exchcd table distinct unless the author-provided mapping connects it to this stage.

Validation to perform later:

- Once the mapping is confirmed, trace its exact field and timing through the source and verify the filter's sample effect in a future authorized run.

### ACT_SKLEARN_API: Replace the removed CountVectorizer feature-name API with its documented successor while retaining the same count-matrix column labels.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: SW_SCIKIT_LEARN, ISSUE_SKLEARN_API
Evidence: EV_PY_SKLEARN_CALL, EV_PY_SOFTWARE, EV_PUBLIC_SKLEARN_REMOVAL, EV_PUBLIC_SKLEARN_OUT

**Proposed edit:** `GetForwardLooking_CalculateModification.py:80–80`
Source SHA-256: `7664063658d46ba6278b515b9bc324b46b57bd62d154d1a06b7d9dc0d96009a3`

The installed scikit-learn version is 1.9.1; official CountVectorizer documentation says get_feature_names was removed in 1.2 and documents get_feature_names_out.

Current text:
```
    df = pd.DataFrame(X_train_counts.toarray(),columns=count_vect.get_feature_names(),index=filenamelist)
```

Proposed replacement:
```
    df = pd.DataFrame(X_train_counts.toarray(),columns=count_vect.get_feature_names_out(),index=filenamelist)
```

Preparation / proposed procedure:

1. Apply this one-line proposal only to a separate working copy after the Python source is completed by the author; it does not resolve the incomplete keyword assignments, indentation, or input contract.

Validation to perform later:

- Confirm the exact replacement in the working copy and, in a later authorized run with the required inputs, verify that the DataFrame retains feature-name columns without changing the author's counting or scoring design.


## Remaining issues and prerequisites

- ISSUE_PYTHON_CONFIG [blocking; full_pipeline]: The source has two assignments with no right-hand-side values for forwardLookingList and exclusionList, and the lines following the modification function's with-open statement are not indented as its suite. These are statically incomplete source structures. Other referenced globals, paths, count/location/output variables, and the intended function invocation may be supplied externally; their values and contract remain unknown and are not asserted missing.
- ISSUE_FL_MDA_HANDOFF [unresolved; full_pipeline]: AT.sas reads mydata.fl_MDA and joins char_gvkey/fyear, then filters on difference. The supplied Python source writes per-file text and a raw adjacent-similarity score, while the modification call is commented out; this package does not show a producer or mapping into the SAS table. Whether a prepared compatible input exists remains unknown.
- ISSUE_INDEXLINKS_PRODUCER [unresolved; full_pipeline]: AT.sas consumes mydata.IndexLinks_8k, copies it to WORK, and uses CIK and filing-date fields in the 8-K lookback. No producer or prepared-table schema, population, coverage, or upstream field mapping is shown in the supplied package. The later cikd and fillingdate lineage remains undocumented.
- ISSUE_EXCHCD_STAGE [unresolved; full_pipeline]: The supplied source's MIDAS DATA step has an explicit KEEP list without exchcd; the following PROC SUMMARY groups by ticker and classifies year, lists the trading measures as VAR fields, and writes atrading1. The immediate next DATA step references exchcd, but the source does not show its origin or a path from the later stocknames table into this stage. The field mapping and resulting filter/sample effect remain unresolved; no runtime error or row-selection effect is asserted.
- ISSUE_SKLEARN_API [blocking; full_pipeline]: The installed scikit-learn distribution is 1.9.1 while the source calls CountVectorizer.get_feature_names(), documented as removed in 1.2. The documented output-name API is get_feature_names_out(); a one-line source edit is supported, but other Python setup and source gaps remain.
- REQ_MIDAS_SECURITY [undetermined]: WRDS MIDAS security daily records used for 2012–2018 algorithmic-trading measures. AT.sas reads ticker, security, date, qtr, oddlotvol, cancels, littrades, litvol, tradesforoddlots, trade_to_order_volume, cancel_to_trade and OrderVol.
- REQ_COMPUSTAT_FUNDA [undetermined]: Compustat FUNDA annual accounting records for the supplied filters, matching and controls, lagged changes, and SIC-year concentration calculation. The code uses overlapping 2011–2021 fiscal-year windows and fields including gvkey, fyear, datadate, sich, cik, at, prcc_f, cusip, act, lct, dlc, lt, oancf, capx, epsfi and revt.
- REQ_CRSP_LINKTABLE [undetermined]: CRSP CCMXPF link table with gvkey, lpermno, linkprim, linktype, link dates and end dates for the dated Compustat-to-PERMNO match.
- REQ_CRSP_STOCKNAMES [undetermined]: CRSP stocknames history for PERMNO/ticker/name/exchange-date matching and the historical CUSIP-to-NCUSIP mapping used for institutional ownership.
- REQ_CRSP_MSF [undetermined]: CRSP monthly stock-file returns with permno, date and ret for the 2010–2020 annual standard-deviation and prior-year-change construction.
- REQ_CRSP_DSF [undetermined]: CRSP daily stock-file price, volume, share-count and adjustment-factor fields used for annual dollar trading volume and its prior-year change; AT.sas filters dates to 2011–2021.
- REQ_TFN_S34 [undetermined]: Thomson Financial/TFN S34 institutional holdings for 2011–2019, including rdate, cusip, ticker, shares, price, and share-outstanding fields; SAS aggregates and maps holdings into each firm-year window.
- REQ_AUDITOPIN [undetermined]: Audit Analytics audit-opinion data for 2011–2019 with auditor name, company_fkey, fiscal_year_end_op and fiscal_year_of_op for auditor classification and fiscal-year matching.
- REQ_FL_MDA [undetermined]: Prepared mydata.fl_MDA input consumed by AT.sas, joined on char_gvkey and fyear and supplying difference. The table's producer, field mapping, period and compatibility with the Python outputs are unresolved.
- REQ_INDEXLINKS_8K [undetermined]: Prepared mydata.IndexLinks_8k input consumed by AT.sas to count 8-K filings, requiring CIK and filing-date history covering the preceding 364-day window through each output filing date. The source product, producer, population and field mapping are unresolved.
- REQ_MDA_TEXT [undetermined]: The Python program's MD&A disclosure text files in the configured input folder, selected by a filename sequence. The author datasheet identifies EDGAR as the source, but the filing population, years, format and firm-year identifiers are not specified in this package.
- REQ_MDA_SEQUENCE [undetermined]: CSV filename sequence read by the Python driver and modification function. At least the first column is used as a file name; the row order and required firm/year mapping for adjacent-year comparisons remain unspecified.
- REQ_SCORE_WEIGHTS [undetermined]: CSV score-weight input read by calculateForwardLookingModification; the code reads the third column after its header and applies these values to the text-count matrix. The file, dictionary contract and construction are not supplied.
- SW_SAS [unverified]: The local SAS 9.4 executable path was found, but bounded startup attempts failed with a TKELS initialization diagnostic. Version, required PROC availability, and library configuration remain unverified; this does not establish a missing license.
- SW_SCIKIT_LEARN [blocked]: Installed distribution metadata reports scikit-learn 1.9.1. The source calls CountVectorizer.get_feature_names(), which official documentation says was removed in 1.2; the current documented replacement is get_feature_names_out(). No author-code or API trial was run.

## Review notes

- The early populated checkpoint was saved before product catalog and one-row file checks. All supplied sources were reviewed through the saved byte-first screened reader; its initial credential/authentication/connection candidate scans returned no candidate ranges. No SAS executable, author program, import, compilation, parsing, or model/statistical trial was run.
- The exact local Compustat, CRSP, and Audit Analytics candidates and bounded probe results are recorded. One-row readability and fields do not establish population/history compatibility. The FEED34 audit-opinion product revision remains unknown; both TFN S34 15-second timeouts are preserved and were not repeated further. V2 candidate checks that did not verify requested aliases are not treated as evidence of absence or license status.
- The packaged identifiers.xlsx bounded inspection reads one row from the first sheet and reports GVKEY/FYEAR headers; it is not the Python filename sequence, MD&A corpus, or score weights file. The local SEC roots were confirmed as directories only and were not listed or read; the official EDGAR page supports filings since 2001 but not this package's filing sample, format, sequence, or mappings.
- Python distribution metadata records Python 3.12.14, scikit-learn 1.9.1, and pandas 3.0.6 without importing packages or author code. The old CountVectorizer method incompatibility has a one-line proposal; the source's incomplete assignments and with-suite indentation remain blocking, while externally supplied globals and output contracts stay unknown.
- The exchange-code stage remains unresolved from the complete supplied producer-consumer window: the preceding explicit MIDAS KEEP and SUMMARY fields do not show the exchcd handoff, while a separate later stocknames input contains exchcd. No runtime error, filter outcome, or sample change is asserted.
- The failed source-path/view operations and the two public page retrieval failures are retained as process observations. The author-site 502 and SAS documentation-PDF 400/size-limit observations have no raw browser response capture in this package; no retry, link click, or download was made.
