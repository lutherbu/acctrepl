# Patch proposal: jar-e9152caa7af6

Bank Supervision and Organizational Capital: The Case of Minority Lending

DOI: 10.1111/1475-679X.12529

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

All seven README-listed SAS data-preparation programs as supplied, with the central HMDA producer before its dependent market-share, matched-sample, county-DID and HHI branches; no paper-wide estimation stage absent from this archive is added.

Entry points: `prepare_transaction_and_portfolio_share_data_v2.sas`, `prepare_market_share_data_v2.sas`, `prepare_bank_level_data_v2.sas`, `prepare_hhi_data.sas`, `prepare_matched_sample_v2.sas`, `prepare_bank_county_did.sas`, `prepare_cra_rating_data_v2.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 2/12529 - Bank-Supervision-and-Organizational-Capital-The-Case-of-Minority-Lending/abkt-datasheet-code-and-identifiers.zip",
      "sha256": "e68c0338778a9f8561bcdbab784908ebe53353a7f9c98693b922ce4e305b0163"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "3a4bae04dc372ea012a69c93961d0f2539439f5ad2a0593ce444f5d0dbcf94a2"
}
```

## Proposed actions

### ACT_HMDA_HISTORY: Resolve the exact annual HMDA transaction and historical identity-panel products before the central producer is prepared.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_HMDA_TX, REQ_HMDA_PANEL_2011_17, ISS_CLOSURE
Evidence: E_DS_HMDA, E_CODE_HMDA_2018, E_CODE_HMDA_2004_06, E_CODE_HMDA_2001_03, E_CODE_HMDA_1990_00, E_CODE_HMDA_2007_17, E_CODE_PANEL_HIST, E_PUBLIC_HMDA_HISTORY, E_CATALOG_HMDA

Preparation / proposed procedure:

1. Identify the official annual loan-level file and identity-panel route matching each author-named year and format for 1990–2018; retain exact files and versions.
2. Request the authors' historical panel source and mapping if official products do not supply respondent_id/respondent_rssd_id in the expected year-specific form.
3. Preserve the supplied 2012 RSSD correction and the source's existing year-specific harmonization; do not reconstruct HMDA identities independently.

Validation to perform later:

- Before the central preparation, confirm each required year has one compatible source, expected input columns and the IDs/years used by the supplied joins.
- Check the 2011–2017 panel period separately from the 2018 panel and record any remaining identity gaps.

### ACT_HMDA_PANEL_2018: Acquire the documented 2018 public HMDA panel for the central LEI-to-RSSD link.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ_HMDA_PANEL_2018
Evidence: E_CODE_PANEL_2018_TABLE, E_CODE_PANEL_2018_JOIN, E_PUBLIC_HMDA_PANEL, E_PUBLIC_HMDA_PANEL_2018

Preparation / proposed procedure:

1. Obtain the official public annual panel for activity_year 2018 and retain its original file and release date.
2. Import the four documented identifier fields into the author-named panel member without changing the linkage logic.

Validation to perform later:

- Check the imported field names and types against activity_year, lei, agency_code and respondent_rssd; confirm the 2018 identifier rows are present before the central producer is prepared.

### ACT_AUTHOR_PREPARED_INPUTS: Request the exact author-prepared tables and producing specifications consumed by the supplied scripts.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ_EDO, REQ_BNK2018, REQ_BNK2019, REQ_MASTER_COMMERCIAL, REQ_CALLREPORT_POST10, REQ_SOD_BRANCH, REQ_COUNTY_ECON, ISS_CLOSURE
Evidence: E_CODE_EDO, E_CODE_EDO_CRA, E_CODE_EDO_MATCH, E_CODE_EDO_CENTRAL, E_CODE_BNK2018_DID, E_CODE_BNK2019, E_CODE_MASTER_TABLE, E_CODE_CALLPOST, E_CODE_SOD_INPUT, E_CODE_COUNTY_INPUT, E_CODE_COUNTY_EMP, E_CODE_COUNTY_PER_CAP, E_CATALOG_EDO, E_CATALOG_BNK2018, E_CATALOG_BNK2019, E_CATALOG_MASTER, E_CATALOG_CALLPOST, E_CATALOG_SOD_PREPARED, E_CATALOG_BEACAINC30

Preparation / proposed procedure:

1. Request edo_modified_v2 plus its field definitions, event-history coverage and producer provenance.
2. Request separate bnk_vars_2018 and bnk_vars_2019 files with source years, frequency, required fields and their producing code/specification.
3. Request master_commercial and callreport_post10 with their Call Report vintages, raw item definitions and author-side transformation code.
4. Request branch_vars_deposit_transfer with branch/RSSD/geography fields, deposit vintage and any branch-transfer or geography crosswalk history.
5. Request county_econ with the original BEA table/vintage and mapping to geofips, year, emp and per_capita_personal_inc.
6. Do not reconstruct these author-prepared panels from raw sources while their transformations or historical contracts remain unknown.

Validation to perform later:

- For every received table, check its producer, row unit, keys, variables, types and year/quarter coverage against its use in the supplied code.
- Confirm all joins and branch-specific periods are supported before marking the full input closure complete.

### ACT_CRA_RATINGS: Acquire the official CRA ratings file documented for the supplied CRA preparation program.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ_CRA_RATINGS
Evidence: E_CODE_CRA_IMPORT, E_CODE_CRA_FIELDS, E_PUBLIC_CRA_FORMAT, E_PUBLIC_CRA_FIELDS, E_PUBLIC_CRA_HISTORY

Preparation / proposed procedure:

1. Obtain the official FFIEC Interagency CRA Ratings file and retain its original release and specifications.
2. Confirm its tab-delimited positional layout and map the first nine documented fields to the supplied import logic.

Validation to perform later:

- Check header and trailing-column behavior, field order, examination dates and regulator identifiers against the official specification before using the file.

### ACT_SAS_RUNTIME: Confirm a usable licensed SAS runtime and supported batch paths for the author programs.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS
Evidence: E_ENV, E_ORDER

Preparation / proposed procedure:

1. Request an environment status check for the installed SAS version, license state, batch invocation and host-visible working directories.
2. Prepare the host batch working directory only after runtime and license status are confirmed; no startup trial was performed in this assessment.

Validation to perform later:

- Record the verified SAS version and batch availability without running the author programs as part of the feasibility review.

### ACT_SAS_ETS: Confirm SAS/ETS availability because the source invokes PROC EXPAND.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS_ETS
Evidence: E_CODE_EXPAND, E_PUBLIC_SAS_ETS, E_PUBLIC_SAS_ETS_GUIDE, E_ENV

Preparation / proposed procedure:

1. Check the same SAS installation's licensed component inventory for SAS/ETS and the PROC EXPAND procedure.
2. Do not substitute another library or procedure for the authors' time-series operations.

Validation to perform later:

- Record whether SAS/ETS is installed/licensed; do not invoke PROC EXPAND during this review.

### ACT_WINSOR_SOURCE: Obtain the authors' winsor.SAS macro source and version used by all four programs.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: ISS_WINSOR
Evidence: E_CODE_WIN, E_WIN_CENTRAL, E_WIN_MATCH, E_WIN_CRA, E_PACKAGE_INVENTORY, E_CATALOG_WINSOR

Preparation / proposed procedure:

1. Request the exact winsor.SAS source from the authors and confirm its expected path and macro signature.
2. Retain its percentile, by-group and variable semantics; do not replace it with an independently written macro.

Validation to perform later:

- Before any future run, verify that every %winsor call in the four supplied programs resolves to the provided definition with the same arguments.

### ACT_EXPORT_NAME: Point the central CSV export at the versioned transaction member created immediately above.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISS_EXPORT
Evidence: E_CODE_TRANSACTION_PRODUCER, E_CODE_EXPORT_LINE, E_CODE_MARKET_TRANSACTION_INPUT

**Proposed edit:** `prepare_transaction_and_portfolio_share_data_v2.sas:1314–1314`
Source SHA-256: `ec342a2a37bfd1ba43db8104d71db26b0136c76e2b1b8d4361c7283e373f93ea`

The immediately preceding DATA step produces data.edo_hmda_transaction_v2, and the downstream market-share script reads that versioned member. The export filename already has the _v2 suffix; changing only its input member preserves calculations and output naming.

Current text:
```
proc export data=data.edo_hmda_transaction replace
```

Proposed replacement:
```
proc export data=data.edo_hmda_transaction_v2 replace
```

Preparation / proposed procedure:

1. Apply this one-line repair only in a preserved working copy, then confirm downstream code still reads the versioned member and CSV filename.

Validation to perform later:

- Review the edited source text and confirm the producer, export input and downstream consumer use the same versioned member; do not execute the author program.

### ACT_PATH_CONFIGURATION: Map the documented author roots in a preserved working copy and reserve an isolated future execution directory.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISS_PATHS
Evidence: E_CODE_PATHS_E, E_CODE_PATHS_F

Preparation / proposed procedure:

1. Reserve [redacted-path-3b8cc50d46bf] as the separate isolated future execution working directory, outside the audit, controller, frozen, probe and checkpoint trees; do not run author code there during this assessment. The queue run_root is only an audit locator.
2. Keep the EDO_KT raw-data root distinct from the ABKT replication 00 Data and 01 Analysis roots. Treat the HHI F: ABKT reference as a path alias only; preserve its exact basenames and do not assume the E: and F: files are scientifically identical.
3. Map each SAS libref, include, input and output location in a preserved working copy to host-visible paths, retaining the exact author basenames and producer-consumer order.
4. Keep the original sources unchanged and do not insert absolute Dropbox paths into author code.

Validation to perform later:

- Review all seven scripts' path mappings and confirm every exact basename and producer-consumer handoff resolves within the isolated working copy.
- Keep schema, history and producer compatibility questions assigned to ISS_CLOSURE; no path mapping alone satisfies a data requirement.


## Remaining issues and prerequisites

- ISS_CLOSURE [unresolved; full_pipeline]: The archive supplies seven preparation programs and an identifier-only dataset, but not the full HMDA history/identity panels, EDO and bank panels, Call Report tables, branch-deposit transfer table or county economics table. Their exact schemas, period coverage and some producers remain unresolved.
- ISS_WINSOR [unresolved; full_pipeline]: Four required programs include [redacted-path-0118c8c0fbbb], which is not in the assigned package inventory; its macro definition and exact version are needed to preserve the authors' calculations.
- ISS_EXPORT [preparation; full_pipeline]: The central program creates data.edo_hmda_transaction_v2 but the following export reads data.edo_hmda_transaction; no producer for the unversioned member appears in the supplied program. The same-run name repair is explicit and preserves the output filename.
- ISS_PATHS [preparation; full_pipeline]: The programs explicitly reference the EDO_KT raw-data root and the ABKT replication data/analysis root; the HHI branch uses F: for its ABKT data alias while other scripts use E:. Mapping these known roots to host paths is routine setup. Whether separate [redacted-path-51e7424d6027]: files have identical schemas or histories is not inferred and remains part of input closure.
- REQ_HMDA_TX [undetermined]: Annual HMDA transaction tables required by the central producer for 1990–2018. The code handles several historical formats and harmonizes them; no annual transactions are in the assigned archive.
- REQ_HMDA_PANEL_2011_17 [undetermined]: Historical HMDA respondent/RSSDID panels for 2011–2017, including the 2012 correction. The author code combines year-specific panels and retains respondent_rssd_id, activity_year, respondent_id and agency_code.
- REQ_HMDA_PANEL_2018 [public_acquisition_required]: The separate 2018 HMDA institution panel used to link LEI to respondent RSSD and agency identifiers.
- REQ_EDO [undetermined]: Author-prepared data.edo_modified_v2 consumed by the central, bank-level, matched-sample and CRA programs. Its producing code, schema, event history and complete file are not supplied.
- REQ_BNK2018 [undetermined]: Author-prepared data.bnk_vars_2018 used by the central producer, market-share, matched-sample, CRA, bank-level and county-DID branches; its full field, period and construction contract is absent.
- REQ_BNK2019 [undetermined]: Author-prepared data.bnk_vars_2019 consumed by the bank-level event-time branch; the separate 2019 panel and its producing procedure are absent.
- REQ_MASTER_COMMERCIAL [undetermined]: Author-prepared bnk.master_commercial Call Report table used for the earlier NPA panel construction; the code requests identity, reporting date and past-due/nonaccrual item fields.
- REQ_CALLREPORT_POST10 [undetermined]: Author-prepared data.callreport_post10 table consumed by the bank-level branch for later NPA variables; its exact author-side producer and reporting-vintage transformations are not supplied.
- REQ_SOD_BRANCH [undetermined]: Author-prepared data.branch_vars_deposit_transfer required by the deposit HHI branch. The supplied code expects branch, RSSD, geography and deposit variables from this prepared table.
- REQ_COUNTY_ECON [undetermined]: Author-prepared data.county_econ required by the central and matched-sample branches. Supplied code consumes geofips, year, emp and per_capita_personal_inc; source code and vintage mapping are absent.
- REQ_CRA_RATINGS [public_acquisition_required]: Public CRA exam rating file read by the CRA branch as a tab-delimited, positional file and mapped to institution, exam, and rating fields.
- SW_SAS [unverified]: The seven author programs require SAS. Existing environment evidence did not verify a usable runtime/license state; this assessment did not start SAS.
- SW_SAS_ETS [unverified]: The supplied programs invoke PROC EXPAND. Official SAS documentation places this procedure in SAS/ETS; local component availability and licensing remain unverified.

## Review notes

- The required target is the seven supplied README preparation scripts. The central transaction/portfolio program produces the shared RSSD-linked HMDA, all-institution county, EDO transaction and EDO share tables; market-share, matched-sample, county-DID and HHI branches consume central outputs. Bank-level and CRA branches remain separate README-required preparations with their own inputs. No paper-wide analysis stage absent from this archive is invented.
- The market-share program creates hmda_complete_cnty_only_cmrl internally before writing loan_marketshare_bnkcty_v2; it is a generated intermediate, not a missing external dataset. The bank-level, HHI, matched-sample, county-DID and CRA programs each retain their distinct outputs and input contracts.
- The datasheet's historical sources are not automatically live inputs. The supplied scripts consume prepared edo_modified_v2, bnk_vars_2018/2019, master_commercial, callreport_post10, branch_vars_deposit_transfer and county_econ tables; their producers or exact compatibility are unresolved. No independent reconstruction is proposed.
- Frozen resource catalog checks for HMDA, FFIEC/Call Reports, CAINC30, FDIC SOD, CRA and author-specific table/macro names returned zero matching datasets/files. These catalog discovery results do not establish license absence or public unavailability.
- The packaged identifiers.sas7bdat probe read one row and only RSSDID; it is an identifier sample, not a full analytic dataset or evidence of historical coverage.
- The saved credential/API/connection reader screen recorded zero candidates for all seven SAS programs before the initial source display. Subsequent source views and rereads used the saved fail-closed reader after the coordinator's later reminder; this records the actual timing and method without implying a sensitive exposure.
- No author program was executed, imported, compiled, parsed, syntax-checked, statistically run or started through SAS. No data were downloaded, installed or reconstructed; no API payload, endpoint, credential or connection was used. Public checks were limited to official static documentation/search excerpts.
- The public CRA and 2018 HMDA panel routes are documented, but their files have not been acquired. Legacy HMDA inputs and identity panels, author-prepared bank/EDO/Call Report/SOD/county tables, SAS/SAS-ETS availability and the winsor macro remain prerequisites. Known EDO_KT/ABKT roots are ordinary host-path setup; [redacted-path-51e7424d6027]: data equivalence remains unverified under input closure. No computed outcome or execution-readiness field is supplied in this draft.
