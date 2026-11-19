# Patch proposal: jar-8ce6d68a4837

Opening up the 'Black Box' of Audit Firms: The Effects of Audit Partner Ownership on Audit Adjustments

DOI: 10.1111/1475-679X.12333

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied workflow in Section 2 (raw-to-final preparation, including manual EQR identity matching) and Section 3 main-paper Tables 1-5. The 53-page program is embedded in LWW_JAR_code.pdf, not supplied as a standalone .do file.

Entry points: `LWW_JAR_code.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 5/12333 - Opening-up-the-Black-Box-of-Audit-Firms-The-Effects-of-Audit-Partner-Ownership-on-Audit-Adjustments/lww-datasheet-code-and-identifiers.zip",
      "sha256": "66109b9ed8152c9a0d51a3a5c2cf783a66f3c1d55b2621f346241771e344775c"
    },
    {
      "path": "JAR-Volume 58/Issue 5/12333 - Opening-up-the-Black-Box-of-Audit-Firms-The-Effects-of-Audit-Partner-Ownership-on-Audit-Adjustments/lww-online-appendix.pdf",
      "sha256": "98af818814302c9c3e2e99ba1668cdc01cbc8373bd9c2a969b82c7204df6253a"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "78333c41152aaefe49ff976e801abcb5d323f01bc35dd6854a4fc19719427515"
}
```

## Proposed actions

### A-EXTRACT-SETUP: Prepare a working .do copy and configure the author directory layout for the host batch runtime.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I-RUN-SETUP
Evidence: SRC-CODE-TOC, SRC-CODE-PATHS, INSP-WORKFLOW

Preparation / proposed procedure:

1. Extract/reflow the embedded Section 1-3 program from LWW_JAR_code.pdf into a new working-copy .do file; compare wrapped statements, especially macros and multi-line expressions, against the source pages. Do not patch the binary PDF or treat cached text as a standalone source file.
2. Choose one host-visible run root and map dir0 through dir8 to explicit relative or [redacted-path-072c96d722cf] subdirectories, preserving distinct source roots and a writable results directory. Set the Stata working directory to the parent of those paths; do not put absolute Dropbox workspace paths in executable host configuration.
3. Keep dir0/main.dta, repeated dir0/temp*.dta, the separate dir1/temp.dta branch intermediate, dir0/main1.dta and dir0/sample.xlsx in their documented roles.

Validation to perform later:

- Before a separately authorized execution, confirm each configured source/output root is visible and writable from the host batch wrapper and confirm same-basename intermediates remain distinct.

### A-CSRC-DATA: Stage the author-maintained CSRC-related workbook inputs and preserve the manual EQR crosswalk stage through an authorized route.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R-EQR-WORKBOOK, R-BRANCH, I-INPUTS, I-CROSSWALK
Evidence: SRC-DATASHEET-ACCESS, SRC-CODE-EQR, SRC-CODE-CROSSWALK, SRC-CODE-BRANCH

Preparation / proposed procedure:

1. Use the exact author-maintained audit_EQR.xls workbook with raw 2013-2015 fullname/eqr/clienttype/yr rows and compatible Sheet2/Sheet3 crosswalks, or a prepared version with the same required sheets and keys. A prepared version bypasses only the hand-matching work if it preserves the exact raw/derived contracts.
2. For manual completion on a workbook copy, follow the PDF order: identify tbd duplicate names; copy dup=0 results to replace Sheet2; append dup=1 records; use Sheet3 to match auditor and audfirm and copy the matched CPA codes to Sheet2; retain ambiguous same-firm identities and allow the supplied code to drop ambig=1 before merging eqrcode.
3. Stage dir2/audbranch/branch.xlsx only through an authorized author-prepared route, retaining code/year/branch keys for the ci_o construction. The historical CSRC agreement names the authors; it does not establish the current operator’s access or denial. No contact or form submission was made.

Validation to perform later:

- Later validate each worksheet’s fields, firm/year keys, matching decisions and ambiguity flags against the supplied merge sequence before any authorized run.

### A-MOF-DATA: Stage the separate author-maintained MOF inputs used by the full workflow under current authorization.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R-AUDIT-UPTO, R-CPA-BASIC, R-CPA-ADDITIONAL, R-CPA-BACKGROUND, R-SHARE, R-MOF-ASSETS, I-INPUTS
Evidence: SRC-DATASHEET-ACCESS, SRC-CODE-AUDIT, SRC-CODE-CPA-BASIC, SRC-CODE-CPA-ADDL, SRC-CODE-CPA-BG, SRC-CODE-SHARE, SRC-CODE-ADJUSTMENT

Preparation / proposed procedure:

1. Use the exact audit_upto2015.xls, cpa.dta, additionalcpa.xls, auditor_background/cpa.dta, share.xls and asst_upto2015.dta inputs with the listed company/year, CPA, auditor, earnings, ownership and asset fields. Keep their source directories distinct.
2. Prefer author-prepared files already available to an appropriately authorized operator. The datasheet’s historical grants to named authors neither transfer current access nor prove denial; this proposal does not investigate contract eligibility or contact the agencies.
3. Do not reconstruct the proprietary partner ownership, auditor characteristics or adjustment measures from independent sources. Provide the exact author input plus its field and date coverage notes.

Validation to perform later:

- Later verify matching keys and required fields for each separate file and confirm all authored merges preserve the intended company-year and CPA-year rows.

### A-CSMAR-DATA: Provide compatible CSMAR author-prepared inputs for the company-name mapping and audited-earnings comparison.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R-FULLNAME, R-CSMAR-TP, I-INPUTS
Evidence: SRC-CODE-EQR, SRC-CODE-ADJUSTMENT, SRC-DATASHEET-ACCESS, CATALOG-CSMAR, INSP-CATALOG

Preparation / proposed procedure:

1. Stage the named fullname.xls and tp.dta with fullname/code and code/year/tp fields respectively, through an existing authorized route or as author-prepared files.
2. The frozen common catalog has no exact CSMAR candidate; its Chinese exchange-rate and US name/M&A matches are not substitutes. The current CSMAR entitlement and file-to-table contract remain unknown; do not add a current-entitlement approval gate unless actual access evidence requires it.

Validation to perform later:

- Later confirm file formats, code/year joins, Chinese issuer coverage, and the observed CSMAR/MOF audited-earnings reconciliation fields before running.

### A-OTHER-CONTROLS: Stage each remaining author-prepared control and lookup file as a separate input, without rebuilding its underlying measures.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R-AUDFEE, R-FTEN, R-PTEN, R-CASHFLOW, R-SOE, R-BOARD, R-MISSING-DUAL, R-ICW, R-FIN-LISTDATE, R-LISTDATE-FALLBACK, I-INPUTS
Evidence: SRC-CODE-CONTROLS, SRC-CODE-DATES, SRC-DATASHEET-ACCESS

Preparation / proposed procedure:

1. Supply the exact audfee.dta, ften.dta, pten.dta, cashflow.dta, soe.dta, board.xlsx, missing_dual.xls, icw2013_2016.xlsx, fin2016.xls and listdate.xls files with their stated code/year keys and consumed fields.
2. Keep missing_dual.xls as the manual update table, and preserve the distinction between listdate text parsed as YMD and listdt numeric Stata date used only as fallback.
3. Where the datasheet names CSMAR, WIND, DIB and annual reports but does not map a provider to each stored control file, accept the exact author-prepared file as primary and request its field/history notes; do not independently reconstruct subs, board, ICW or tenure measures.

Validation to perform later:

- Later inspect each file’s actual type, keys, columns and period; verify that updates and listage fallbacks use the expected formats and that all 2013-2015 sample rows are covered.

### A-CICPA-DATA: Stage the annual CICPA ranking workbook and inspect its unrestricted columns for lowrank/shno before altering code.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R-CICPA-RANK, I-INPUTS, I-LOWRANK
Evidence: SRC-CODE-RANK, SRC-CODE-SHNO-USE

Preparation / proposed procedure:

1. Use rank_cicpa_2013to2015.xlsx as the preferred author-prepared input. The program imports it without a keep filter, so inspect its existing columns and preserve any supplied lowrank or shno field.
2. If using the author-described CICPA public materials instead, first verify that the official 2013-2015 releases contain the required firm/year/rank/revenue/CPA-count values and can be mapped to the author’s workbook; this route is unverified here.
3. Do not infer shno from the number of company/year identifiers, signing partners or rank rows.

Validation to perform later:

- Later confirm ranking coverage across sampled firms and years and reconcile any existing lowrank/shno field definitions with the authored descriptive statistics.

### A-HISTORY: Resolve the actual historical coverage and earliest source year for partner/auditor history inputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-HISTORY, R-AUDIT-UPTO, R-PTEN
Evidence: SRC-CODE-PRIOR, SRC-CODE-COSIGN, SRC-CODE-TENURE

Preparation / proposed procedure:

1. Confirm the author-prepared audit history includes 2011-2014 rows for the explicit prior_audit t-2/t-1 construction for 2013-2015 targets.
2. Confirm the full pre-target history required by dcosign and cumulative eqr_accu/pten variables, which use prior observations without an explicit start-year bound; do not invent a start year from the sample filter.

Validation to perform later:

- Later report the earliest actual year available for each history input and verify the generated prior_audit, dcosign and cumulative tenure measures against the supplied code definitions.

### A-LOWRANK: Inspect lowrank in the actual ranking workbook and preserve an author-provided field; use a documented derivation only if the field is absent.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-LOWRANK, R-CICPA-RANK
Evidence: SRC-CODE-RANK

Preparation / proposed procedure:

1. After the actual rank workbook becomes available, check whether it already contains lowrank and whether its values match the documented size cutoff; the unrestricted merge can carry an input field into main.dta.
2. If lowrank is absent and the rank field is the documented 1-40 ordering, add the following statement to the extracted working copy immediately after the rank workbook merge: gen lowrank=(rank_cicpa>25) if rank_cicpa!=. This encodes rank>25 as small and keeps rank 25 in the medium group. Do not add it unconditionally or overwrite an existing field.

Validation to perform later:

- Later tabulate rank_cicpa against lowrank and confirm ranks 1-25 are 0 and ranks 26-40 are 1 before constructing medium/small indicators.

### A-SHNO: Resolve the source, key and definition of shno before Table 4 Panel A.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-SHNO, I-SHNO, R-SHARE, R-CICPA-RANK
Evidence: SRC-CODE-SHARE, SRC-CODE-RANK, SRC-CODE-SHNO-USE

Preparation / proposed procedure:

1. Inspect whether shno is already carried through the unrestricted rank workbook merge or another author-prepared firm-year input. If present, preserve its actual producer and confirm the firm-year key and denominator.
2. If no compatible source is supplied, obtain the author-defined shno producer/field contract before changing the working copy. The share.xls comment describes shno, but the code’s share imports discard it; do not guess which firm or count the statistic represents.

Validation to perform later:

- Later confirm shno exists on the final main.dta firm-year rows and reproduces the specified Table 4 count definition.

### A-SOFTWARE: Make the two invoked Stata add-ons available to the later run while retaining the authored commands.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-WINSOR2, SW-OUTREG2
Evidence: PROBE-ENV, SRC-CODE-PATHS, SRC-CODE-WINSOR, SRC-CODE-TABLE5

Preparation / proposed procedure:

1. Locate authorized copies of winsor2 and outreg2 or arrange their ordinary installation/configuration before a separately authorized run; neither was found in the checked default/shared adopaths. No install was performed.
2. Keep reghdfe and ftools available in the selected Stata adopath; the frozen probe found reghdfe 6.12.3 and ftools 2.49.1.

Validation to perform later:

- Before a later run, verify which winsor2 and which outreg2 resolve in the actual host Stata session; do not execute study code as a software check.

### A-RUN-PROCEDURE: Follow the complete supplied producer-to-consumer sequence once inputs, handoffs, setup and software are resolved.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: run procedure
Evidence: INSP-WORKFLOW, SRC-CODE-TOC, SRC-CODE-MAIN-TABLES, SRC-CODE-SAMPLE, SRC-CODE-TABLE5

Preparation / proposed procedure:

1. Run Sections 1-2 in source order in the working copy: audit_EQR.xls + fullname.xls -> initial dir0/main.dta; MOF audit records + manual Sheet2/Sheet3 resolution -> eqrcode; signing-team and three CPA-background sources -> partner attributes; share and rank inputs -> ownership/size measures; year-history joins -> workloads/prior_audit/dcosign/tenure; separate earnings/assets/control/board/ICW/listing-date inputs -> analysis controls; branch + audit-upon-year ta -> ci_o; sample filters/ranks/winsor/revonly -> final main.dta and sample.xlsx.
2. Run Section 3 Tables 1-5 against the completed main.dta, retaining the fixed-effects logit/reghdfe models and all supplied branches. The supplemental workflow trace records the distinct dir0/dir1 temp.dta files and intermediate order.
3. Compare the generated sample.xlsx code/year IDs with the packaged identifier list and compare main-table outputs with the paper as later validation; the current one-row probe does not establish complete ID coverage.

Validation to perform later:

- A separately authorized execution must verify successful completion of all included branches and table outputs; execution_verified remains false until that occurs.


## Remaining issues and prerequisites

- I-INPUTS [unresolved; full_pipeline]: The release has no complete analysis dataset and omits the many distinct named raw/prepared files consumed by Section 2. The packaged workbook supplies only company/year identifiers. Input routes and exact coverage remain unverified; this is not evidence that access is denied.
- I-CROSSWALK [unresolved; full_pipeline]: Step 1.2 depends on manual duplicate-name checks and edits/copies across audit_EQR.xls Sheet2/Sheet3 before eqrcode is merged. The release contains no completed crosswalk workbook.
- I-HISTORY [unresolved; full_pipeline]: The code needs at least 2011-2014 data for prior_audit across target years 2013-2015, while dcosign and cumulative engagement histories use all earlier records without a coded start year. The supplied inputs and earliest available history are absent/unknown.
- I-LOWRANK [unresolved; full_pipeline]: lowrank is referenced but never generated in the PDF. The ranking workbook is imported without a keep filter and may already contain it; its presence and values are unknown. Inspect the actual author workbook and preserve a valid field. If absent, only add the documented rank_cicpa>25 definition after confirming the input ranks/cutoff.
- I-SHNO [unresolved; full_pipeline]: Table 4 Panel A uses shno, while share.xls imports keep only cpacode/auditor/yr/share and thereby drop the comment-documented shno field. The rank workbook is merged without a field restriction and may carry shno, but no firm-year source/key/definition is documented. Preserve any existing field and resolve its contract before changing code.
- I-RUN-SETUP [preparation; full_pipeline]: The supplied Stata program is embedded in a PDF with Windows D: roots rather than a standalone .do driver. It requires extraction/reflow and routine host-visible directory configuration before a later run; this is preparation, not evidence of a code incompatibility.
- R-EQR-WORKBOOK [undetermined]: Author-maintained audit_EQR.xls workbook: CSRC EQ reviewer/company names and the manually prepared Sheet2/Sheet3 name-to-CPA-code crosswalk, including ambiguity decisions.
- R-FULLNAME [undetermined]: CSMAR full-company-name to stock-code lookup used before constructing main.dta.
- R-AUDIT-UPTO [undetermined]: MOF author-maintained firm-year audit workbook used for CPA mapping, signer data, adjustments, workload, prior-audit, co-sign and partner-history construction.
- R-CPA-BASIC [undetermined]: MOF basic CPA background database joined to signer 1, signer 2 and EQ reviewer CPA codes.
- R-CPA-ADDITIONAL [undetermined]: Supplementary MOF CPA background workbook used to update missing signer/EQR background fields.
- R-CPA-BACKGROUND [undetermined]: Supplementary auditor_background CPA database used with update/replace semantics for signer and reviewer fields.
- R-SHARE [undetermined]: MOF partner identity and annual equity-share workbook for each EQ reviewer and signing auditor; the comment also says the workbook carries shno.
- R-SHNO [undetermined]: Author-defined firm-year total equity partner count consumed as shno in Table 4 Panel A. The comment names shno in share.xls, but the code drops it from the share merges and the final producer/key is unknown.
- R-CICPA-RANK [undetermined]: CICPA audit-firm ranking/revenue/CPA-count workbook used for firm-size classifications and Table 4.
- R-CSMAR-TP [undetermined]: CSMAR audited-earnings comparison table merged to MOF post-audit earnings to compute diff_tp.
- R-MOF-ASSETS [undetermined]: MOF pre-audit and audited total-assets data.
- R-AUDFEE [undetermined]: Author-prepared firm-year finance/control table for leverage, ROA and consolidated subsidiary counts.
- R-FTEN [undetermined]: Author-prepared audit-firm tenure variable.
- R-PTEN [undetermined]: Author-prepared signing-partner cumulative tenure inputs.
- R-CASHFLOW [undetermined]: Author-prepared operating-cashflow data used to construct pre_acc.
- R-SOE [undetermined]: Author-prepared state-ownership data.
- R-BOARD [undetermined]: Author-prepared board characteristics for board size, independent-director share and raw duality.
- R-MISSING-DUAL [undetermined]: Manual duality values used to update missing dual_raw entries.
- R-ICW [undetermined]: Prepared internal-control weakness workbook consumed to construct dicw.
- R-FIN-LISTDATE [undetermined]: Author-prepared listing-date data used to compute listage from YMD text.
- R-LISTDATE-FALLBACK [undetermined]: Separate author-prepared numeric-date fallback used to fill missing listage.
- R-BRANCH [undetermined]: Author-maintained branch/office mapping sourced from CSRC and joined to audit-year total assets to create ci_o.
- SW-WINSOR2 [preparation_required]: The supplied code invokes winsor2; it was not found in the checked default/shared Stata adopaths. Availability outside those paths is unknown.
- SW-OUTREG2 [preparation_required]: The supplied global output macro invokes outreg2; it was not found in the checked default/shared Stata adopaths. Availability outside those paths is unknown.

## Review notes

- The frozen static audit reports no supported code and zero dependency edges because the substantial Stata program is embedded in a PDF. Manual review of all 2,090 cached code lines supplied the dependency and branch trace; the empty parser graph is not treated as closure.
- LWW_firm_identifier.xlsx is a code/year sample identifier list, not a full analysis panel or supported analysis-only route. The code exports sample.xlsx and never reads the packaged identifier file.
- The datasheet’s MOF and CSRC agreements document historical grants for named authors; they neither establish the current operator’s entitlement nor prove denial. No agreement eligibility research, private-file investigation, agency contact or request form was performed.
- The common catalog returned no exact CSMAR candidate. Chinese exchange-rate, US ExecuComp name and SDC M&A cashflow entries are not compatible substitutes; no generic US data proxy is proposed and no candidate data file was opened.
- The appendix contains additional analyses (including quadratic/rank, robust, abnormal-adjustment and medium/small comparisons) that are not supplied in the Section 3 Tables 1-5 program. They remain contextual scope limitations and are not reconstructed.
- All input routes remain unverified, histories and lowrank/shno fields retain their specific unknowns, and add-on availability remains preparation work. No author code, regressions or study data were executed/read; all execution_verified values remain false.
