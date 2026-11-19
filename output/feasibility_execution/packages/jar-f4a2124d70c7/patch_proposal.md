# Patch proposal: jar-f4a2124d70c7

Banks as Tax Planning Intermediaries

DOI: 10.1111/1475-679X.12246

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full pipeline here is the supplied GGM_2018_code.sas data-construction workflow through the datasets it writes: Steps 1–16, including the actual CRSP/CCM step despite its comment that it is not used in the main analyses, LRC3 and UTB outputs, and both new-banking-relationship branches. The datasheet separately documents a third pairing panel and Appendix A9/A10 outputs that this source does not produce; these remain explicit conditional downstream gaps. The two shipped CSVs are identifier lists and do not justify an analysis-only path.

Entry points: `GGM-datasheet-and-code/GGM_2018_code.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 1/12246 - Banks-as-Tax-Planning-Intermediaries/ggmdatasheetcodeandidentifiers.zip",
      "sha256": "ea90964f4b490b6c7e45b23ed7af81b30b2eb63a031036099e7923bd0a65b5ab"
    },
    {
      "path": "JAR-Volume 57/Issue 1/12246 - Banks-as-Tax-Planning-Intermediaries/ggm-online-appendix.pdf",
      "sha256": "a7e69571c39a501379c4c422715d48d1aa81f607064980c2798b55ef1dcd7713"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "669960d2e7b944e55d3b3e6399d0a5d5b685f6ba24db8a1fbad7cae905d2c85b"
}
```

## Proposed actions

### A_COMP: Identify/confirm the annual Compustat fundamentals input used by the supplied workflow. The local candidate has the probed core columns; additional code fields and required history for lag/rolling constructions remain to be checked. The static company-master route is already supported locally.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_COMP_ANNUAL
Evidence: E001, E024, E025, E026

Preparation / proposed procedure:

1. Use the documented Compustat/WRDS route to identify the annual Fundamentals source feeding the author `compa` input; preserve the fiscal, tax and accounting fields used by the code.
2. Retain upstream history used by the lag and rolling constructions before the LRC3 fyear>=1993 and UTB fyear>=2007 filters; those filters do not establish sufficient history.

Validation to perform later:

- Use bounded metadata/row-limit checks on the selected annual file to confirm every code-required field.
- Check the lag/rolling history and required gvkey/fyear coverage before an authorized run.

### A_COMPAGE: Obtain the author `compage` source or confirm its precise producer from full Compustat history; the code reads a separate input and its producer is absent.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COMPAGE
Evidence: E049, E024, E025

Preparation / proposed procedure:

1. Request the exact file or producer, schema, STD/consolidated filters, and the first_fyear definition.
2. If the authors confirm a derivation from Compustat Funda, preserve that stated procedure; do not substitute a different age measure.

Validation to perform later:

- Check gvkey, fyear, datafmt and consol on the confirmed source.
- Verify the first_fyear output covers every downstream gvkey/year before use.

### A_CRSP: Confirm the local CRSP/Compustat link-history and daily security products cover the inputs required by the actual Step 3 mapping.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_CCM_LINK_HISTORY, R_CRSP_DAILY_SECURITY
Evidence: E001, E020, E024, E027, E028

Preparation / proposed procedure:

1. Confirm the local CCM used-flag link history and daily stock-security products used by the supplied workflow.
2. Preserve link flags/dates, gvkey/PERMNO and CUSIP/PERMNO fields and configure the `ccmlink` and `crspdsf` inputs.
3. Include Step 3 because it is executed in the entry file despite its “not used in main analyses” comment.

Validation to perform later:

- Use bounded row-limit probes on exact selected files.
- Verify link-date eligibility and CUSIP coverage for all processed annual records before an authorized run.

### A_DEALSCAN: Confirm the five jointly required Dealscan products used to build facility, lender, covenant and pricing inputs. Catalog candidates expose the probed fields; target facility/package coverage remains unverified. The static Company lookup is already supported locally.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_DEALSCAN_FACILITY, R_DEALSCAN_FACILITY_AMENDMENT, R_DEALSCAN_LENDER_SHARES, R_DEALSCAN_COVENANTS, R_DEALSCAN_CURRENT_FACILITY_PRICING
Evidence: E001, E024, E029, E030, E031, E032, E033, E034

Preparation / proposed procedure:

1. Confirm the Facility, Facility Amendment, Lender Shares, Financial Covenant and Current Facility Pricing products independently; they are jointly used, not substitutes.
2. Preserve their separate facility/package/borrower/lender identifiers, dates, lender-role/allocation fields, covenant package keys and pricing fields.
3. Configure distinct source inputs and retain the author currency/date transformations.

Validation to perform later:

- Use bounded metadata/row-limit checks on the selected tables to confirm requirement fields.
- Confirm target facility/package and period coverage before executing merges.

### A_BORROWER_LINK: Resolve the `dropbox2` setup and exact 2012 Chava–Roberts borrower link file consumed at line 114.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_DEALSCAN_COMPUSTAT_BORROWER_LINK, I001
Evidence: E001, E007, E024

Preparation / proposed procedure:

1. Request the exact link-file path/member, WRDS source and setup that defines `dropbox2` (include, autoexec or approved configuration).
2. Confirm the file provides bcoid and gvkey and keep it distinct from the later hand-matched lender crosswalk.

Validation to perform later:

- Verify the resolved path and required identifiers with bounded metadata.
- Check borrower IDs and target-year coverage before an authorized run.

### A_LENDER_MAP: Obtain the authors’ hand-matched bank/lender crosswalk and final SAS schema; the authors describe the matching workbook and say the supplemental file is available on request.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_LENDER_COMPUSTAT_CROSSWALK
Evidence: E008, E013, E014, E015

Preparation / proposed procedure:

1. Request `lenders_lead_merge.sas7bdat` or its final workbook-derived counterpart with lendercompanyid, lender gvkey, fyear/date bounds and linktypeA/linktypeB.
2. Request the match history/correction notes, including the name/parent-name procedure and time-varying matches.
3. Preserve the explicit RBS gvkey correction unless the authors specify an updated crosswalk.

Validation to perform later:

- Check field types, leading-zero handling, match dates and fiscal-year coverage against the join.
- Reconcile unmatched/corrected lenders with author diagnostics.

### A_BANKS: Identify the author-compatible annual bank financial input for lender-year IB, NIINT and TXT. COMP.BANK_FUNDA is a readable candidate, not a verified match to `banks`.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_BANK_ANNUAL_FINANCIALS
Evidence: E009, E024, E035

Preparation / proposed procedure:

1. Use the documented Compustat/WRDS route to identify the separate annual `banks` source used by the workflow.
2. Retain gvkey, datafmt, fyear, ib, niint and txt for lender-year joins.

Validation to perform later:

- Probe the exact file with row_limit=1 and confirm the annual interface.
- Check lender gvkey-year coverage before an authorized run.

### A_BANKS_FS: Identify the separate author `banks_fs` input and producer; current bank annual/quarter catalog tables do not establish its source.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_BANK_FS_FINANCIALS
Evidence: E010, E024, E035, E036

Preparation / proposed procedure:

1. Request the exact file or producing program, intended product/frequency, required fields, construction and coverage.
2. Do not merge `banks_fs` into `banks` or substitute the quarterly product without author confirmation.

Validation to perform later:

- Confirm the author-specified transformation yields annual gvkey/fyear/datafmt/ib/niint/txt values expected by the code.
- Check separate source identity and lender-year coverage.

### A_ADSPRATE: Identify the author-compatible Compustat ratings table for borrower gvkey/datadate joins in both new-relationship branches.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_BORROWER_CREDIT_RATINGS
Evidence: E011, E024, E037

Preparation / proposed procedure:

1. Use the documented Compustat/WRDS route to identify the author-compatible ADSPRATE release.
2. Retain gvkey, datadate, splticrm, spsdrm and spsticrm separately from annual fundamentals.

Validation to perform later:

- Probe the exact selected table for the source columns.
- Check date coverage for borrowers in both new-relationship branches.

### A_MACROS: Obtain the two required author macros referenced by the SAS entry program: WT.sas and FF48.sas.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: I003, I004
Evidence: E003, E012

Preparation / proposed procedure:

1. Request the complete macro sources, versions and interfaces; both include statements say the macros are available upon request.
2. Configure both include paths consistently and confirm all `%WT` and `%FF48_Ind` calls resolve.
3. Preserve winsorization/truncation and industry assignment behavior.

Validation to perform later:

- After setup, confirm the includes and calls resolve and their generated variables match source consumers.
- Validate macro outputs before the downstream branches.

### A_TEMP12: Obtain the missing Step 10 producer/schema for `temp9i_11_4`; line 828 writes `local.temp12` from it, but no producer is present.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I002
Evidence: E005, E023, E082

Preparation / proposed procedure:

1. Request the omitted construction block or exact author-prepared `temp9i_11_4` intermediate and its fields/order.
2. Do not infer that `temp9i_7_4` is the replacement; intended schema and producer are unknown.
3. Trace the confirmed `temp12` into Steps 11–12.

Validation to perform later:

- Compare the producer schema with the line 828 sort and the immediate Step 11 consumers.
- Validate Step 10–12 order only after the missing contract is resolved.

### A_EVENTTIME: Clarify the `eventtime` producer/definition used in both new-banking-relationship filters.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I005
Evidence: E021, E022, E023

Preparation / proposed procedure:

1. Request the source, reference event, units, fiscal alignment and producer order for `eventtime` in LRC3 and UTB.
2. Do not infer it from `fyear_change` or another paper variable.

Validation to perform later:

- Trace the confirmed field through both abs(eventtime)<4 filters.
- Check the author-specified event window and branch outputs before execution.

### A_PAIRING_PANEL: Obtain the missing producer or prepared-data contract for the third all-realized/potential bank-borrower pairing panel documented by the datasheet.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I006
Evidence: E019, E015, E023, E042, E043

Preparation / proposed procedure:

1. If this panel is in the intended replication target, request the author program or prepared panel and its field/identifier contract.
2. Request the eligibility rules for contract-initiation years and banks above the new-contract threshold.
3. Do not treat the gvkey-only CSVs or new-relationship panels as the pairing choice set.

Validation to perform later:

- Verify borrower/bank IDs, fiscal/event keys and eligibility conditions against the author contract.
- Reconcile the panel to author-provided Table 9/12 sample diagnostics before including this branch.

### A_APPENDIX_A9: For Appendix A9 only, request author-supplied tax-haven/SPE counts or increase/indicator data and the missing producer contract; this audit does not independently rebuild Exhibit 21 variables.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: I007
Evidence: E015, E016, E017, E023, E039, E040, E041, E045, E046

Preparation / proposed procedure:

1. If A9 is in scope, request author count/increase/indicator files, schema, firm-year keys, missingness rules and producer code.
2. Confirm current delivery, fields and coverage of the datasheet-named Dyreng EX21 source before relying on it.
3. Treat SEC public search and example EX-21 filing as a route to individual documents only; the local directory checks and WRDSSEC metadata do not establish full filing-text coverage.

Validation to perform later:

- Confirm the author products implement the stated country/entity rules, pre-1997 missingness and extraction-failure handling.
- Check firm-year coverage and A9 outcome mapping against author diagnostics.

### A_APPENDIX_A10: For Appendix A10 only, obtain the author driver and exact IBES Guidance classification/firm-year mapping. The readable local IBES product is only a candidate.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I008
Evidence: E018, E023, E038

Preparation / proposed procedure:

1. If A10 is in scope, request the analysis program or author-prepared guidance indicator with measurement, timing, ticker-to-gvkey mapping and missingness rules.
2. Do not infer the guidance indicator from one-row IBES fields.

Validation to perform later:

- Confirm the author’s announcement/reporting-period and gvkey/fyear merge rule.
- Check the guidance partition against author-provided A10 counts.

### A_SAS_RUNTIME: Verify the configured SAS runtime after the recorded TKELS initialization failure; this is not a license finding.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS
Evidence: E044

Preparation / proposed procedure:

1. Have the approved SAS environment maintainer verify the `sas_u8` path and TKELS launch-service setup; the existing artifact includes a bounded retry, so this assessment made no further startup attempt.
2. After an environment change, establish the actual runtime version and noninteractive startup before any code execution.

Validation to perform later:

- Record successful runtime/version evidence.
- Keep macro/version compatibility separate and do not run author code until data and source gaps are resolved.

### A_PATH_CONFIG: Prepare one workspace-local path configuration for a local execution copy so the supplied librefs and macro includes resolve consistently. Keep `local` writable for intermediates and stage or expose the two verified company lookup sources under the exact LOCAL members read by the code. Keep `dropbox2` in the same configuration, but bind it only to the confirmed borrower-link directory/member once I001 is resolved.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I009
Evidence: E003, E004

Preparation / proposed procedure:

1. For the local execution setup, map `local` to `data/GGM`, `lendlink` to `data/GGM/linking Dealscan to Compustat`, and `dropbox` to `output/GGM`; point each libref at its one consistent root wherever the supplied workflow writes and later reads intermediates or outputs.
2. Keep the configured `local` run library writable and stage or expose `${ACCTREPL_SAS_ROOT}/comp/d_na/company/company.sas7bdat` as `LOCAL.COMP_DOM` and `${ACCTREPL_SAS_ROOT}/tfn/dealscan/company.sas7bdat` as `LOCAL.DSCOMPANY`. Keep both common source libraries read-only; do not bind writable `LOCAL` directly to the shared source locations because the workflow also writes intermediates there. Stage or alias other source members only after their existing input contracts are resolved.
3. Resolve both includes under `support/SAS/WT.sas` and `support/SAS/FF48.sas` after the missing macro sources are obtained; source availability and interfaces remain separate issues I003/I004.
4. Add `dropbox2` to this same configuration only after the exact D0013 borrower-link path and member are confirmed under I001; do not infer it from the `lendlink` directory.
5. Keep this as local setup for an authorized execution copy; do not change the supplied author source during this assessment.

Validation to perform later:

- Confirm the three libref roots and both include paths resolve in the prepared local setup.
- Confirm `LOCAL.COMP_DOM` and `LOCAL.DSCOMPANY` resolve to the specified read-only source files through the prepared staging/view/alias setup, while `LOCAL` remains writable for workflow intermediates.
- Check that every `dropbox` producer and later consumer uses the same configured root, and that `dropbox2` resolves to the confirmed D0013 borrower-link member before an authorized run.


## Remaining issues and prerequisites

- I001 [unresolved; full_pipeline]: The workflow reads `dropbox2.DealScan_Compustat_Link_Aug_12` at SAS line 114, but the supplied entry file defines only `lendlink`, `local`, and `dropbox`. The required include/autoexec setup, exact 2012 borrower-link file path and input contract are not supplied or specified. A catalog miss does not show that the WRDS product or license is absent.
- I002 [unresolved; full_pipeline]: At SAS line 828 the program sorts `temp9i_11_4` into `local.temp12`; a complete-source scan finds only this read and no producer for `temp9i_11_4`. Its schema and missing construction cannot be inferred safely, so the downstream Steps 11–12 branch cannot be closed.
- I003 [unresolved; full_pipeline]: The entry program includes `WT.sas`, described as the winsorization/truncation macro available upon request. The macro source, version and macro body are not in this package; its many calls are required for data construction.
- I004 [unresolved; full_pipeline]: The entry program includes `FF48.sas`, described as the Fama-French 48 industry-assignment macro available upon request, and invokes `%FF48_Ind` in Step 3. Its source and interface are not supplied.
- I005 [unresolved; full_pipeline]: Both new-banking-relationship branches filter on `abs(eventtime)<4` (SAS lines 1984 and 2218), but complete-source inspection finds no assignment or producer for `eventtime`. Its reference event, units, fiscal alignment and intended source must be clarified before either branch is closed.
- I006 [unresolved; full_pipeline]: The datasheet describes a third panel containing realized and potential bank-borrower pairs, but the supplied SAS source does not produce that panel; it ends with the LRC3 and UTB new-relationship outputs. The pairing-panel producer or exact author-prepared panel contract is missing. The two shipped CSVs are gvkey-only borrower lists and do not supply this panel.
- I007 [unresolved; full_pipeline]: Appendix A8–A9 describes tax-haven and SPE counts from Dyreng/SEC Exhibit 21, including the country/entity rules and missingness for pre-1997 or unextractable filings. The datasheet says supplemental count increases/indicators for new-relationship tests are available on request, but the supplied SAS contains no EX21/SPE construction or A9 driver. Keep this as a conditional downstream appendix requirement; request the author-supplied data/producer contract if A9 is in scope, without independently rebuilding it.
- I008 [unresolved; full_pipeline]: Appendix A10 uses whether management provides guidance, measured with IBES Guidance, but the supplied SAS contains no IBES/guidance construction or A10 driver. The local `IBES.DET_GUIDANCE` product is only a candidate; the firm-year mapping, classification rule and branch code are not supplied. Keep this conditional downstream and request the author contract if A10 is in scope.
- I009 [preparation; full_pipeline]: The entry source hardcodes D: paths for the `lendlink`, `local` and `dropbox` librefs and for the `WT.sas` and `FF48.sas` includes. A local execution setup needs one consistent workspace path mapping for those roots and includes. The `dropbox2` borrower-link location remains unresolved under I001 and must be added to that same configuration only after its exact file path is confirmed.
- R_COMP_ANNUAL [undetermined]: Compustat North America Fundamentals Annual panel used to build borrower-year tax outcomes and controls (D0003).
- R_COMPAGE [undetermined]: Separate Compustat age/first-fiscal-year input used to add first_fyear by gvkey (D0006).
- R_CCM_LINK_HISTORY [undetermined]: CRSP/Compustat CCM link history used in the actual Step 3 branch (D0008).
- R_CRSP_DAILY_SECURITY [undetermined]: CRSP daily stock-security file used for CUSIP-to-PERMNO mapping in the actual Step 3 branch (D0009).
- R_DEALSCAN_FACILITY [undetermined]: Dealscan Facility table used to construct loan facilities and borrower-year overlap amounts (D0010).
- R_DEALSCAN_FACILITY_AMENDMENT [undetermined]: Dealscan facility amendment dates/maturity used to extend facility end dates (D0011).
- R_DEALSCAN_LENDER_SHARES [undetermined]: Dealscan lender-share/role/allocation data used to identify lead lenders and bank allocations (D0012).
- R_DEALSCAN_COMPUSTAT_BORROWER_LINK [undetermined]: Chava–Roberts Dealscan-to-Compustat borrower link file read as DealScan_Compustat_Link_Aug_12 (D0013).
- R_LENDER_COMPUSTAT_CROSSWALK [undetermined]: Author hand-matched Dealscan lender-company to Compustat-gvkey crosswalk, indexed by fiscal year and match type (D0021).
- R_DEALSCAN_COVENANTS [undetermined]: Dealscan financial covenants used to count covenants by package and link them to candidate facilities (D0022).
- R_DEALSCAN_CURRENT_FACILITY_PRICING [undetermined]: Dealscan current facility pricing used to calculate AllInDrawn statistics by facility (D0023).
- R_BANK_ANNUAL_FINANCIALS [undetermined]: Compustat bank annual financial input `banks` used to merge lender IB, NIINT and TXT (D0036).
- R_BANK_FS_FINANCIALS [undetermined]: Separate Compustat bank financial input `banks_fs` merged as a fallback lender financial source (D0037).
- R_BORROWER_CREDIT_RATINGS [undetermined]: Compustat S&P ratings merged to borrower gvkey/datadate in the new-relationship branches (D0038).
- SW_SAS [unverified]: The supplied entry point is SAS. The existing environment evidence names `sas_u8`, but bounded startup failed with a TKELS Launch Service Load Failure, so an observed runtime/version was not established. The artifact says this is not evidence of a missing license; no retry was made.

## Review notes

- Scope boundary: full_pipeline assesses the supplied GGM_2018_code.sas data-construction workflow through the datasets it writes, including Steps 1–16, the actual CRSP/CCM step despite its “not used in main analyses” comment, both LRC3/UTB branches, and both new-banking-relationship branches. The datasheet separately documents a third pair-choice panel and Appendix A9/A10 paths that this source does not produce; these remain explicit conditional downstream gaps.
- No analysis_only scope is supported: the two packaged CSVs are one-column unique-gvkey lists, not analysis panels, and no supplied branch skips raw-data construction with a compatible full analysis input.
- Catalog lookups covered both source products and exact author aliases. One-row SAS probes establish readability and requested columns for probed products; they do not establish historical coverage or population for time-varying panels. Those remaining period, key and construction checks are stated on the relevant routes. COMPA.COMPANY and DEALSCAN.COMPANY are supported local static lookups for the requested fields, joined respectively by gvkey and CompanyID with no year filter in the supplied code. Catalog/alias misses are not evidence that data or a license is absent.
- The two independent bank annual sources `banks` and `banks_fs` remain separate requirements. COMP.BANK_FUNDA is a readable candidate for the annual interface; COMP.BANK_FUNDQ is quarterly and not a direct substitute; the exact author `banks_fs` producer remains unknown.
- Local SEC raw/parsed roots were checked only for existence, and WRDSSEC.EXHIBITS was checked only as a one-row metadata product. No directory listing or broad filing scan was performed. The Dyreng author URL is named by the datasheet, but the direct page check did not establish current file delivery or coverage.
- The SAS environment artifact reports a TKELS Launch Service Load Failure and marks SAS unverified. It explicitly does not establish a missing license; the prior bounded startup check/retry were reused without another retry.
