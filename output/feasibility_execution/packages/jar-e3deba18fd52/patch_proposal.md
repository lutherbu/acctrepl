# Patch proposal: jar-e3deba18fd52

Short Squeezes After Short-Selling Attacks

DOI: 10.1111/1475-679X.12595

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The complete author-documented SAS preparation and analysis workflow, followed by Stata tables.

Entry points: `Step 1a sas code to create the short attack sample and the control sample.sas`, `Step 1b sas code to create control variables.sas`, `Step 2 sas code to join files for final datasets.sas`, `Step 3a sas code to generate figures and table 1 2 3a and 5.sas`, `Step 3b stata code to generate other tables.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 3/12595 - Short-Squeezes-After-Short-Selling-Attacks/swz-datasheet-code-identifier-and-log-files.zip",
      "sha256": "a2ac6c4d7302407b75c09f88d93f4dc33bf311bfe4786fa2188141b379ff6bda"
    },
    {
      "path": "JAR-Volume 63/Issue 3/12595 - Short-Squeezes-After-Short-Selling-Attacks/swz-internet-appendix.pdf",
      "sha256": "5c9ed87747f0c1321d0ff2fdbabd8e985c3a92f33122b429c7975550247167b5"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "e58eefb31a5d0ae2afce4f93c8974213f1d1b621836e7f4a1fc1dd255443158f"
}
```

## Proposed actions

### action-verify-core-routes: Prepare the previously positively verified CRSP DSF, CRSP DSI, and Compustat short-interest products for the author’s run. Stage the same products at the author’s declared libraries or paths and record physical format and source-field spellings/case, using the existing successful leaf probes as the underlying field contract. Resolve only actual product or field-definition gaps.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: req-crsp-dsf, req-crsp-dsi, req-comp-sec-shortint
Evidence: ev-step1a-dsf, ev-step1a-dsi, ev-step1b-shortint, ev-step1b-dsf

Preparation / proposed procedure:

1. Ask the author which library or mount path, physical filename, and native format will supply each of CRSP DSF, CRSP DSI, and Compustat short interest, and whether any source-field aliases or case changes are expected; stage those same products at the declared locations.
2. Compare each staged product identity and actual underlying field list with its existing successful original leaf result and expected fields; record actual source-field spellings/case and any supported alias mapping in setup notes.
3. If a required field, product variant, or definition is absent or changed, ask the author for the exact product and field definition and a compatible same-product source. Do not repeat completed catalog or one-row checks.

Validation to perform later:

- Confirm each staged same-product path and format is the author’s intended input and each existing expected underlying field is present or explicitly unresolved. Keep the 15 positively verified local underlying routes intact; unsampled dates alone do not withdraw a compatible raw route.

### action-map-remaining-inputs: Use the documented five-program sequence as a conditional author run plan after the required early-read bootstrap products are available. Preserve the existing branch dependencies and resolve the specific staging questions instead of repeating the completed dependency audit.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: issue-input-route
Evidence: ev-step1a-dsf, ev-step1a-dsi, ev-step1b-shortint, ev-step1b-dsf, ev-src-insidetrade-first-read, ev-src-insidetrade-late-producer, ev-src-erc-allvar, ev-src-erc-proc-download, ev-src-stata-all-dta-input, ev-src-stata-alltype-day10-dta-input, ev-src-stata-insider-alltype8c-byday3-dta-input, ev-src-cclink1-step2, ev-source-eststo, ev-source-esttab, ev-source-reghdfe, ev-source-winsor2, ev-src-re-ctdmroib, ev-src-producer-taq-ctdmroib, ev-inspect-package-inventory

Preparation / proposed procedure:

1. Before the first consumer reads them, obtain the author’s confirmation and stage the pre-existing insider, ERC/control bootstrap products and all three unproduced Stata input files at their intended product, library/path, and native format; record each product definition, required fields, and initial producer or bootstrap method. A later recreation does not satisfy an earlier read.
2. After each branch’s prerequisites are staged, follow the documented five entry programs in their existing dependency sequence: Step1a and Step1b prerequisites, then Step2 joins/exports, then the Step3a and Step3b consumers. Run only branches whose inputs are available; if an early-read/later-recreation cycle leaves order unresolved, ask the author to clarify that branch before running it.
3. Preserve all program branches and dependencies. Keep the five Step1b opaque ranges fully excluded; do not infer steps from them, silently reorder code, invent data transformations, or replace author models.
4. Keep TAQ.CTDMROIB and RE.CTDMROIB as distinct products with distinct contracts; do not substitute one for the other.

Validation to perform later:

- Before starting each branch, confirm its author-staged same-product prerequisites exist at the intended library/path and native format with the required underlying fields, and record the author-confirmed bootstrap/producer. Preserve the Step1a/Step1b → Step2 → Step3a/Step3b dependency and branch-specific edges without claiming a total order across unresolved early-read/later-recreation cycles; keep all five Step1b opaque ranges excluded and TAQ.CTDMROIB distinct from RE.CTDMROIB.

### action-setup-winsor2: Make the Stata winsor2 command available in the controlled Stata adopath, then verify the command with a non-author which probe.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: sw-winsor2, issue-winsor2-setup
Evidence: ev-source-winsor2, ev-probe-winsor2

Preparation / proposed procedure:

1. Use the approved local/site Stata package source to stage winsor2.
2. Run a Stata which check for winsor2 and record the package version without executing the author program.

Validation to perform later:

- Confirm that which winsor2 succeeds in the Stata environment intended for the author script.

### action-confirm-sas-toolchain: Confirm the authorized SAS runtime/module and macro bindings, including the CRSP merge macro and event-side fields, using approved non-execution metadata; document the remote TAQ bootstrap separately.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue-sas-stack, sw-sas, sw-sas-stat, sw-sas-connect, sw-sas-winsor-macro, sw-crspmerge, req-crsp-mse
Evidence: ev-probe-environment, ev-source-proc-reg, ev-inspect-remote-stage, ev-source-sas-winsor, ev-inspect-package-inventory, ev-src-crsp-mse-options, ev-src-crspmerge-call

Preparation / proposed procedure:

1. Confirm SAS, SAS/STAT, and SAS/CONNECT status without starting SAS or reading startup configuration.
2. Confirm whether %winsor and %crspmerge are supplied by an authorized environment binding; obtain exact definitions/bootstrap instructions if not.
3. Document required CRSP monthly stock/event field mapping and the remote TAQ session bootstrap without exposing connection values.

Validation to perform later:

- Verify each required macro/runtime component with approved metadata and preserve withheld remote configuration blocks opaque.

### action-acquire-13f-data: Use the official SEC Form 13F data route as a candidate for the 2013–2022 holdings/header inputs, then map its current flattened format to the two author table contracts.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req-13f-filingsoutput, req-13f-header-info
Evidence: ev-public-sec13f, ev-src-f13-filings, ev-src-f13-header, ev-src-f13-header-join

Preparation / proposed procedure:

1. Acquire the SEC Form 13F records for the source-required period only after confirming the official file/table definitions against the author joins.
2. Construct separate information-table and filing-header inputs with the fields needed by the supplied code; preserve filing identifiers and report/file dates.
3. Check 2013–2022 coverage, unique filing keys, CUSIP and date compatibility, and the author transformations before continuing to the price/13F branch.

Validation to perform later:

- Compare official product fields and period with the supplied joins and verify that both distinct input tables are available before running Step 1a.

### action-clarify-f13-msf-all3: Request the author-prepared F13.MSF and F13.ALL3 table locations, field definitions, and producers; keep them separate from CRSP.MSF and generated RE.ALL3.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: req-f13-msf, req-f13-all3, issue-input-route
Evidence: ev-src-f13-price-input, ev-src-f13-all3-nonput, ev-catalog-f13-msf, ev-catalog-f13-all3

Preparation / proposed procedure:

1. Confirm the local source and field contract for F13.MSF (NCUSIP, DATE, PRC).
2. Confirm the local source and construction for the separate F13.ALL3 non-put holdings input (FILE_NAME, PUT, CUSIP, SHARES1, PRC).
3. Keep the source product distinct from CRSP.MSF and from RE.ALL3 unless matching construction and field evidence is supplied.

Validation to perform later:

- Verify both actual source products and their joins before the 13F holdings branch is attempted.

### action-clarify-tfn-crsp-products: Confirm the local product, definition, field mapping, and stage source for the Forester control sample, Thomson Reuters 13F files, CRSPA.ERDPORT1, and CRSP.COMPHIST.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req-alltype3-fw, req-tfn-s34type1, req-tfn-s34type3, req-crspa-erdport1, req-crsp-comphist, issue-input-route
Evidence: ev-src-alltype3-fw, ev-src-tfn-s34type1, ev-src-tfn-s34type3, ev-src-crspa-erdport1, ev-src-crsp-comphist, ev-catalog-s34type1, ev-catalog-s34type3, ev-catalog-erdport1, ev-catalog-comphist

Preparation / proposed procedure:

1. Identify the actual local input roots and history for the two TFN S34 products, keeping TYPE1 and TYPE3 separate.
2. Confirm the author-prepared Forester control table and its producer/field contract.
3. Confirm the exact CRSPA.ERDPORT1 and CRSP.COMPHIST product routes and consumed fields; do not substitute another table based only on similar names.

Validation to perform later:

- Check product labels, identifiers, period, and field mappings against the code before running the related branches.

### action-clarify-sec-insider-staging: Confirm the pre-existing insider table and the separate SEC Analytics Suite document/transaction inputs, including their ordering and field/history contracts.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req-self-insidetrade-nodup, req-sec-document-info, req-sec-nonderivatives, issue-insider-input-order
Evidence: ev-src-insidetrade-first-read, ev-src-insidetrade-late-producer, ev-src-insider-sas, ev-src-sec-document-info, ev-src-sec-nonderivatives

Preparation / proposed procedure:

1. Confirm the exact pre-existing SELF.INSIDETRADE_NODUP product consumed before the later same-name write.
2. Confirm the local SEC Analytics Suite DOCUMENT_INFO and NONDERIVATIVES products, their retained history, and the accession/CIK/transaction fields used by the supplied joins.
3. Document the authorized preparation order that produces the initial insider table without reading or exposing connection configuration.

Validation to perform later:

- Verify that the early input exists with the required fields before the first Step 1b read and that the later rebuild consumes the intended SEC products.

### action-acquire-finra-shortvol: Use FINRA's Reg SHO Daily Short Sale Volume product as a public candidate for the author's 2009–2020 short-sale-volume input, then verify its fields and source-specific identifier/history mapping.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req-finra-shortvol
Evidence: ev-public-finra-shortvol, ev-public-finra-distinction, ev-src-finra-shortvol

Preparation / proposed procedure:

1. Acquire the official daily short-sale-volume product for the code-required 2009–2020 period after checking its format and field documentation.
2. Map its per-security symbol/date/volume fields to the author-required SYMBOL, DATE, and SIZE contract and the supplied CRSP stock-name mapping.
3. Keep daily short-sale volume distinct from twice-monthly short interest and validate the period/identifier mapping before computing short-covering measures.

Validation to perform later:

- Confirm the source product's historical coverage, per-security identifiers, date semantics, and volume measure against the code before joining it to CRSP.DSF.

### action-clarify-event-master-calendars: Confirm the two distinct event-master inputs and the two custom date/trading-date tables, their producers, fields, periods, and stage order.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req-event-master-w, req-event-master-base, req-crsp-tdate, req-re-tday2, issue-input-route
Evidence: ev-src-event-master-w, ev-src-event-master-base, ev-src-crsp-tdate, ev-src-re-tday2-rdate, ev-src-re-tday2-fdate

Preparation / proposed procedure:

1. Identify the source and field/period contract for DATA.EVENT_MASTER_ALLREVERSAL031021W and the separately consumed base DATA.EVENT_MASTER_ALLREVERSAL031021.
2. Confirm the custom CRSP.TDATE and RE.TDAY2 calendars and their DATE/TRDDT and DATE/DATE1/TDAY key mappings.
3. Retain the MENSQ W table as a generated intermediate only after the DATA W input has been resolved.

Validation to perform later:

- Verify exact input source, fields, identifiers, period, and producer order before running the Step 1a/Step 2 branches.

### action-clarify-ravenpack-products: Confirm the local RavenPack story, equities, CUSIP reference, and article-count products, preserving their distinct product versions and required years.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req-rp-story-2000-2017, req-rp-story-2018-2020, req-rp-equities, req-rp-cusip2, req-rp-narticle, issue-input-route
Evidence: ev-src-rp-story-2000, ev-src-rp-story-2017, ev-src-rp-story-2018, ev-src-rp-story-2019, ev-src-rp-story-2020, ev-src-rp-equities-2000, ev-src-rp-equities-2020, ev-src-rp-cusip2, ev-src-rp-narticle, ev-catalog-ravenpack

Preparation / proposed procedure:

1. Confirm the actual RavenPack product and local route for 2000–2017 story files and 2018–2020 DJ Edition full-year files separately.
2. Confirm the Equities and CUSIP2 reference fields used to attach security identifiers to stories.
3. Confirm the NARTICLE date/count fields and required event-window coverage; do not treat one RavenPack table as a substitute for another.

Validation to perform later:

- Check product label/version, year coverage, story/security identifiers, and count/date fields against each source join before the event-master construction.

### action-clarify-step2-products: Confirm the exact Step 2 source products, local routes, identifiers, field contracts, year coverage, and order for the unverified inputs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req-rp-all-us1, req-sec-tone8ka, req-re-allvolpre, req-ibes-management-forecast, req-re-allegation, req-crsp-marketret1, req-crd-roll3m1, req-shortme-all3, req-pr-content-std1, req-twitter-round2-all, req-co-twt1, req-crd-lasty2, req-crd-roll3y1, req-rp-rpdj, req-rp-rpall, req-rp-rpwe, req-rp-rppr, req-loanmk-saelpost00, issue-input-route
Evidence: ev-src-rp-all-us1, ev-src-sec-tone8ka, ev-src-re-allvolpre, ev-src-ibes-management-forecast, ev-src-re-allegation, ev-src-crsp-marketret1, ev-src-crd-roll3m1, ev-src-shortme-all3, ev-src-pr-content-std1, ev-src-twitter-round2-all, ev-src-co-twt1, ev-src-crd-lasty2, ev-src-crd-roll3y1, ev-src-rp-rpdj, ev-src-rp-rpall, ev-src-rp-rpwe, ev-src-rp-rppr, ev-src-loanmk-saelpost00

Preparation / proposed procedure:

1. Identify the actual source/product and compatible local route for each listed input as a separate requirement.
2. Confirm the product version, event/date keys, consumed fields, and period for each input against its specific join.
3. Confirm that the generated TONE8KB intermediate is built from the resolved TONE8KA source before the event-panel join.

Validation to perform later:

- Check local readability, identifiers, consumed fields, and required time coverage for each product before the Step 2 event-panel joins.

### action-clarify-taq-stage: Confirm the remote retail-imbalance branch inputs, schemas, product versions, historical windows, and bootstrap requirements from an authorized description of the opaque stage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req-taq-ct, req-taq-ctd-2009-2014, req-taqmsec-ctm, issue-taq-stage
Evidence: ev-inspect-remote-stage

Preparation / proposed procedure:

1. Obtain a safe description of the intended TAQ and TAQ-MSEC input products, years, and consumed fields without exposing connection credentials or private config.
2. Confirm whether the external source stage is required for the full target scope and identify the supported handoff products.
3. Keep any produced TAQ.CTDMROIB output distinct from the separately consumed RE.CTDMROIB table.

Validation to perform later:

- Verify the named products, field/period contracts, and source-to-stage handoffs before any remote-stage execution.

### action-clarify-re-ctdmroib: Confirm the author-staged RE.CTDMROIB source, producer, fields, and relationship to the separately named TAQ.CTDMROIB table.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req-re-ctdmroib, issue-input-route
Evidence: ev-src-re-ctdmroib, ev-src-producer-taq-ctdmroib

Preparation / proposed procedure:

1. Identify the producer and local route for RE.CTDMROIB, including the DATE, MROIBVOL, and MROIBTRD contract used by Step 2.
2. Confirm whether any documented handoff converts TAQ.CTDMROIB to RE.CTDMROIB; do not infer substitution from similar names.

Validation to perform later:

- Check exact library/table identity, fields, identifiers, and stage order before joining the retail-imbalance series.

### action-clarify-stata-inputs: Identify the author-specified source and field contract for the three Stata inputs without supported producers in the supplied program set.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req-stata-all-dta, req-stata-alltype-day10-dta, req-stata-insider-alltype8c-byday3-dta, issue-unproduced-stata-inputs
Evidence: ev-src-stata-all-dta-input, ev-src-stata-alltype-day10-dta-input, ev-src-stata-insider-alltype8c-byday3-dta-input, ev-inspect-package-inventory

Preparation / proposed procedure:

1. Identify the local route or producing program for all.dta, alltype_day10.dta, and insider_alltype8c_byday3.dta separately.
2. Confirm each file’s analysis fields, identifiers, and relationship to the Step 2 exports.
3. Keep the three files distinct from alltype3.dta, selfpre3.dta, all_camp.dta, and regw10132023.dta.

Validation to perform later:

- Verify each named file is readable with the fields used by its Stata branch and has a documented producer or author-prepared source.

### action-clarify-cclink-ncusip: Confirm the source, producer, key fields, and local route for the distinct RE.CCLINK1 and MENSQ.NCUSIP crosswalks.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req-cclink1, req-mensq-ncusip, issue-input-route
Evidence: ev-src-cclink1-step1a, ev-src-cclink1-step2, ev-src-mensq-ncusip

Preparation / proposed procedure:

1. Identify the source and fields for RE.CCLINK1, including its LPERMNO, GVKEY, and SIC mapping.
2. Identify the producer and coverage for MENSQ.NCUSIP, including its NCUSIP, PERMNO, and DATE history.
3. Keep both crosswalks distinct from the other supplied CRSP link tables and from generated MENSQ.NCUSIP1/2 outputs.

Validation to perform later:

- Verify each exact table identity, keys, fields, coverage, and stage order before the Step 1a/Step 2 joins.

### action-clarify-initial-input-routes: Confirm the author-prepared short sample, I/B/E/S crosswalk/actuals products, custom put/report calendars, distinct Markit panels, and ERC input route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req-link-iclink, req-ibes-idsum, req-ibes-actpsumu-epsus, req-self-activistshorts2020, req-markit-permnodate, req-putreportdate1, req-crsp-alldates, req-markit-permnodate2020, req-erc-allvar
Evidence: ev-step1a-iclink, ev-catalog-iclink, ev-step1b-ibes-idsum, ev-catalog-ibes-idsum, ev-step1b-ibes-actuals, ev-catalog-ibes-actpsumu, ev-src-activistshorts, ev-src-markit-permnodate, ev-src-markit-permnodate-fields, ev-catalog-markit, ev-src-putreportdate1, ev-src-crsp-alldates, ev-catalog-crsp-alldates, ev-src-markit-2020-step1b, ev-src-markit-2020-fields-step1b, ev-src-erc-allvar, ev-src-erc-proc-download

Preparation / proposed procedure:

1. Identify the source and sample/field contract for SELF.ACTIVISTSHORTS2020.
2. Confirm LINK.ICLINK, IBES.IDSUM, and IBES.ACTPSUMU_EPSUS as distinct I/B/E/S products and verify their ticker/date/actual fields.
3. Confirm the custom REALEFF.PUTREPORTDATE1 and CRSP.ALLEDATES keys and their relationship to the separate SELF.ALLDATES calendar.
4. Confirm the distinct SELF.MKTUSEQ_PERMNODATE and SELF.MKTUSEQ_PERMNODATE2020 products, required fields, and date coverage.
5. Identify the producer and period contract for SELF.ERC_ALLVAR.

Validation to perform later:

- Check each local route and the exact fields, identifiers, and time coverage consumed by Step 1a/Step 1b before running those branches.


## Remaining issues and prerequisites

- issue-input-route [unresolved; full_pipeline]: Step 2 still consumes distinct RavenPack, CRD, market-return, SEC tone, event-label, report-content, social-media, press-release, IBES forecast, and securities-lending inputs without verified local product/schema/coverage routes. Similar names and shared event keys do not establish substitutes. RE.CCLINK1 and MENSQ.NCUSIP are also consumed author-staged inputs without a visible producer in the admitted source files.
- issue-winsor2-setup [preparation; full_pipeline]: Stata source calls winsor2, and the Stata 18 which probe reports it not found in checked adopaths. No package was installed during assessment.
- issue-sas-stack [unresolved; full_pipeline]: The supplied SAS workflow depends on an unverified SAS runtime/SAS-STAT and external macro bindings including %winsor and %crspmerge, plus a remote TAQ processing stage. The environment result is unverified, connected source blocks remain opaque, and no license, connection, or preconfiguration status is inferred.
- issue-insider-input-order [unresolved; full_pipeline]: Step 1b reads SELF.INSIDETRADE_NODUP near its start, then later writes that same name after building SEC insider trades. The early read still requires a pre-existing input; the later in-file write does not establish it before first use or prove matching history.
- issue-taq-stage [unresolved; full_pipeline]: The supplied workflow includes a remote TAQ/TAQ-MSEC retail-imbalance branch whose product schema, history, and external bootstrap contract remain unresolved. Connected source blocks, comments, and configuration are intentionally kept opaque. The opaque block does not establish credentials, access, license status, or a runnable route.
- issue-unproduced-stata-inputs [unresolved; full_pipeline]: Three Stata inputs are explicitly loaded but have no supported producer among the supplied program sources. Their local availability and field contracts remain unknown; this is not a finding that the files are absent.
- req-link-iclink [undetermined]: I/B/E/S-to-CRSP link file consumed to map PERMNO to the I/B/E/S ticker in the short-attack sample.
- req-ibes-idsum [undetermined]: I/B/E/S identifier-summary mapping used to match CUSIP to ticker before constructing earnings-event inputs.
- req-ibes-actpsumu-epsus [undetermined]: I/B/E/S unadjusted US EPS actuals used to attach announcement-period actual EPS to the earnings-event panel.
- req-self-activistshorts2020 [undetermined]: Author-prepared activist short-attack observations used as the main sample for the supplied short-attack construction.
- req-markit-permnodate [undetermined]: Author-staged Markit security-lending observations used for the short-interest and lending-fee measures in Step 1a.
- req-putreportdate1 [undetermined]: Author-prepared Putreportdate1 event/report-date table joined into the 13F put-option branch.
- req-crsp-alldates [undetermined]: Custom CRSP.ALLEDATES date/trading-date table used by the insider and event-date joins; it is distinct from the code-generated SELF.ALLDATES calendar.
- req-markit-permnodate2020 [undetermined]: Author-staged Markit security-lending panel used to construct control-group and event-window lending measures.
- req-erc-allvar [undetermined]: Author-prepared earnings-announcement return/forecast table used to filter announcement dates and join actual earnings data.
- req-crsp-mse [undetermined]: CRSP monthly event fields consumed by the supplied CRSP merge macro for the institutional-ownership series.
- req-13f-filingsoutput [undetermined]: Yearly author-prepared Form 13F information-table inputs (2013–2022) appended into the holdings construction.
- req-13f-header-info [undetermined]: Yearly Form 13F filing-header inputs (2013–2022) joined to the information-table rows by filing name.
- req-f13-msf [undetermined]: F13.MSF security/date price observations used to price 13F holdings by NCUSIP and report date.
- req-f13-all3 [undetermined]: Pre-existing F13.ALL3 non-put holdings table used as a separate input to the 13F comparison branch.
- req-self-insidetrade-nodup [undetermined]: The pre-existing SELF.INSIDETRADE_NODUP table read at the beginning of Step 1b to create the daily insider-trade control variables.
- req-alltype3-fw [undetermined]: The author-prepared Forester control-sample table consumed in Step 1b before the supplied control-variable construction.
- req-tfn-s34type1 [undetermined]: Thomson Reuters 13F S34TYPE1 filing-date records used to select the first manager/report-date vintage.
- req-tfn-s34type3 [undetermined]: Thomson Reuters 13F S34TYPE3 holdings records merged with the S34TYPE1 vintage selection.
- req-crspa-erdport1 [undetermined]: CRSPA.ERDPORT1 year-end capitalization portfolio daily returns joined to earnings announcement dates.
- req-crsp-comphist [undetermined]: CRSP.COMPHIST historical GVKEY-to-CIK link fields used to join SEC insider documents to Compustat firms.
- req-sec-document-info [undetermined]: SEC Analytics Suite Document_info filing metadata used to match issuer CIKs to accession numbers and report periods.
- req-sec-nonderivatives [undetermined]: SEC Analytics Suite Nonderivatives transaction records joined to document metadata and CRSP security history for insider-trade measures.
- req-finra-shortvol [undetermined]: Daily FINRA short-sale volume observations used with CRSP daily volume and shares to construct short-covering measures for 2009–2020.
- req-event-master-w [undetermined]: Author-prepared W variant of the event master used to remove overlapping 13F put events and to seed the MentionSq merge.
- req-event-master-base [undetermined]: Base Event_master_allreversal031021 event panel read to start the Step 2 event-master transformations.
- req-crsp-tdate [undetermined]: Custom CRSP.TDATE calendar used to attach trading dates around event dates in the Step 2 placebo panel.
- req-re-tday2 [undetermined]: Author-staged RE.TDAY2 calendar crosswalk used to attach trading dates to 13F report and filing dates.
- req-rp-story-2000-2017 [undetermined]: RavenPack story-data yearly files for 2000–2017 used to construct the mention/squeeze panel.
- req-rp-story-2018-2020 [undetermined]: RavenPack full-year story files for 2018–2020 from the later DJ Edition source set.
- req-rp-equities [undetermined]: RavenPack Equities yearly security-reference files for 2000–2020 joined to the story panel.
- req-rp-cusip2 [undetermined]: RavenPack reference CUSIP mapping used to add CUSIP8 to the combined story-equity panel.
- req-rp-narticle [undetermined]: RavenPack NARTICLE article-count observations joined to the event master for pre/post campaign measures.
- req-rp-all-us1 [undetermined]: RavenPack ALL_US1 article/date input used to form a deduplicated date panel.
- req-sec-tone8ka [undetermined]: SEC tone/8-K source rows used to create the filtered TONE8KB intermediate.
- req-re-allvolpre [undetermined]: Author-prepared pre-event volatility/spread panel joined to the Step 2 event table.
- req-ibes-management-forecast [undetermined]: Management-forecast observations used to create the event-level guide indicator.
- req-re-allegation [undetermined]: Author-prepared allegation labels joined by event ID.
- req-crsp-marketret1 [undetermined]: CRSP market-return series used to attach value-weighted returns by trading date.
- req-crd-roll3m1 [undetermined]: CRD three-month event/return summary joined to the event master.
- req-shortme-all3 [undetermined]: Author report-content table joined to the event master for report-text measures.
- req-pr-content-std1 [undetermined]: Author-prepared press-release content records joined by PERMNO and date.
- req-twitter-round2-all [undetermined]: Author-prepared Twitter company/event panel joined by PERMNO and date.
- req-co-twt1 [undetermined]: Author-prepared company-tweet table joined to the event panel by PERMNO.
- req-crd-lasty2 [undetermined]: CRD last-year event-return summary joined by event ID.
- req-crd-roll3y1 [undetermined]: CRD three-year campaign summary joined by event ID.
- req-rp-rpdj [undetermined]: RavenPack DJ Edition article/event summary joined to the event panel.
- req-rp-rpall [undetermined]: RavenPack all-news article/event summary joined to the event panel.
- req-rp-rpwe [undetermined]: RavenPack web/editorial article/event summary joined to the event panel.
- req-rp-rppr [undetermined]: RavenPack press-release article/event summary joined to the event panel.
- req-loanmk-saelpost00 [undetermined]: Markit securities-lending post-event summary joined to the event panel.
- req-taq-ct [undetermined]: Remote TAQ trade input table used in the TAQ retail-imbalance stage; exact input schema and history remain unresolved.
- req-taq-ctd-2009-2014 [undetermined]: TAQ CTD 2009–2014 input used in the remote retail-imbalance processing branch.
- req-taqmsec-ctm [undetermined]: TAQ-MSEC CTM input used in the remote retail-imbalance branch.
- req-re-ctdmroib [undetermined]: Author-staged RE.CTDMROIB retail-imbalance table joined into the Step 2 event panel.
- req-stata-all-dta [undetermined]: Author-specified all.dta input loaded by the Stata table program.
- req-stata-alltype-day10-dta [undetermined]: Author-specified alltype_day10.dta input loaded by the Stata table program.
- req-stata-insider-alltype8c-byday3-dta [undetermined]: Author-specified insider_alltype8c_byday3.dta input loaded by the Stata table program.
- req-cclink1 [undetermined]: Author-staged CCM crosswalk RE.CCLINK1 used to attach GVKEY and SIC to PERMNO rows.
- req-mensq-ncusip [undetermined]: Author-staged NCUSIP/PERMNO/date interval crosswalk used to create MENSQ.NCUSIP1 and NCUSIP2.
- sw-winsor2 [preparation_required]: The author Stata source calls winsor2; a self-written Stata version/which probe returned which code 111, so the command was not found in the checked adopaths.
- sw-sas [unverified]: The full workflow contains SAS programs, but the existing bounded environment result reports SAS status unverified. No SAS executable, startup, version, or autoexec was invoked or inspected in this audit.
- sw-sas-stat [unverified]: The source invokes PROC REG; SAS/STAT module availability has not been established and no license absence is inferred.
- sw-sas-connect [unverified]: The supplied preparation stage includes remote TAQ processing; SAS/CONNECT and its session bootstrap remain unverified, with the connected blocks kept opaque.
- sw-sas-winsor-macro [unverified]: The SAS programs call %winsor, while the frozen supplied-source inventory has no standalone macro definition. A preloaded external definition remains possible and unverified.
- sw-crspmerge [unverified]: The supplied code calls %crspmerge with CRSP monthly stock/event inputs; its definition and authorized bootstrap are not present in the SAFE source views.

## Review notes

- Step 2 event-master/calendar and RavenPack source products have separate requirements and remain unverified pending product/field mapping.
- Step 2 products remain separate requirements; SEC.TONE8KB is produced from SEC.TONE8KA in the supplied source.
- TAQ.TAQMSEC and RE.CTDMROIB remain separate source products; the connected source stage stays opaque. Three Stata input files have no supported producer in the supplied program sources.
- The supplied source does not produce RE.CCLINK1 or MENSQ.NCUSIP; both remain explicit author-prepared inputs. Producer evidence is recorded for visible generated intermediates across the supplied branches.
- Dependency review covers all 278 frozen IDs. Generated products cite direct supplied producer statements; unresolved raw inputs and opaque remote-stage intermediates remain linked to requirements or issues.
- Action coverage preflight linked every remaining unverified Step 1a route and the winsor2 issue to same-scope actions.
