# Patch proposal: jar-f2345230c04c

Talk Less, Learn More: Strategic Disclosure in Response to Managerial Learning from the Options Market

DOI: 10.1111/1475-679X.12368

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | blocked |

### full_pipeline

The complete author-supplied Stata/SAS preparation workflow and every supplied branch in CNY_Stata and SAS code.pdf, in its interleaved stage order, through the listed main and companion regression analyses. The package contains CNY_Identifier.xls as a firm identifier list, not a prepared analysis dataset; the separate appendix's unprovided OA1-OA7 analyses are contextual and are not executable branches in this scope.

Entry points: `CNY_Stata and SAS code.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 5/12368 - Talk-Less-Learn-More-Strategic-Disclosure-in-Response-to-Managerial-Learning-from-the-Options-Market/cny-datasheet-code-and-identifiers.zip",
      "sha256": "620bd773692cca5bd3cc75ac2074c5be3ae927261ddab26b5aba7cc2032b9d85"
    },
    {
      "path": "JAR-Volume 59/Issue 5/12368 - Talk-Less-Learn-More-Strategic-Disclosure-in-Response-to-Managerial-Learning-from-the-Options-Market/cny-online-appendix.pdf",
      "sha256": "25fca1871db4730bcaa6841ff7b990004ed86d9262a4a018d88af576c69ddc1c"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "22425b0cafb65023729ee0eca5451c26a7050eb92bf614ff73a9d10ff642a916"
}
```

## Proposed actions

### act-embedded-working-copy: Extract the embedded program sections into a semantics-preserving Stata/SAS working copy, record the source page/line mapping, and apply only the supported setup repairs there.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: iss-embedded-code
Evidence: ev-doc-code-present, ev-option-chunks, ev-sas-link-export, ev-pmihtt-working-copy-repair, ev-winsor2-working-copy-reflow

Preparation / proposed procedure:

1. Reflow the code PDF's Stata and SAS sections into distinct editable files while preserving the original PDF and section order.
2. In the Stata working copy, correct line 634 from `replace pmihtt==1 if pmihtt>1` to `replace pmihtt=1 if pmihtt>1`.
3. In the cross-sectional working copy, reflow the standalone `replace` immediately after the winsor2 call as the winsor2 option `..., cuts(1 99) replace`; preserve the full variable list and placement.
4. Set ordinary host-visible input/intermediate/output roots and preserve the original author source paths in a run manifest.

Validation to perform later:

- Statically compare each extracted block with the cached source lines and visually check the two PDF page locations before any separate execution authorization.

### act-interleaved-handoffs: Configure and document the native interleaved Stata/SAS workflow, including producer-to-consumer files, host roots and the two changing `stkvol` definitions.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: iss-cross-language-handoffs
Evidence: ev-workflow-trace, ev-sas-link-export, ev-analyst-inputs, ev-history-controls, ev-stock-volatility, ev-late-analysis

Preparation / proposed procedure:

1. Run Stata stage 1 (code lines 14-47) to create daily prices, initial annual-volume `stkvol` and dated stocknames; run Stata stage 2 (52-185) on the 1996-2009 and 2010-2016 OptionMetrics chunks; then stage 3 (188-243) to append/annualize and build OS from the initial volume table.
2. Run SAS stage 4 (251-489) and map its `[redacted-path-3125633a3187]` export to the relative `gdet_lnk_new.dta` name consumed by Stata stages 5 and 12; this is ordinary host-visible root/path setup. Verify the exported fields and merge key before those consumers run.
3. Run Stata stage 6 (559-690) for SEO/13F and its CUSIP/CCM links; keep its `gvkey_cusip.dta` mapping distinct from CCM history. Then run Stata stage 7 (696-723), which overwrites `stkvol` with daily-return SD and creates turnover; preserve stage 3's OS result first.
4. Run SAS stage 8 (729-853) and map its `[redacted-path-db7eade3a9bc]` export to the relative `Analstsum_coverage` name consumed by Stata stage 9; this is ordinary host-visible root/path setup. Verify the exported fields and merge key before that consumer runs.
5. Run Stata stage 9 for the Compustat panel and early merges, then SAS stage 10 (978-1354) for controls and export `[redacted-path-3090f1634575]`; configure the same host-visible path for the Stata stage 11 import at lines 1356 onward.
6. Run Stata stage 11 (1356-1472) for controls merge, comparability, four-lag CFO volatility, insider transactions and one-year-forward investment; keep forward source year 2017 for the 1996-2016 sample.
7. Run all supplied Stata stage 12 branches (1477-1617), including terminal saves `8k_ann.dta`, `cofcall.dta` and `gb_all.dta`; retain their input needs without inventing a downstream consumer.
8. Run final Stata stage 13 (1622-1891) for the supplied estimation panel and regression/companion analyses. Do not reorder the mixed stages into separate language batches.

Validation to perform later:

- Before execution, record each stage's working directory and verify that every producer path resolves to the intended consumer file; compare output field names/types and merge keys at all three SAS-to-Stata handoffs.
- Confirm OS consumes the initial share-volume `stkvol` and that stage 7's return-SD `stkvol` is the later main-panel input; retain both authored meanings in the run record.

### act-annual-source-contracts: Resolve the actual source product, schema, identifiers, units and construction history for the shared annual sample and controls inputs before choosing any local or prepared route.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req-options, req-compustat-fundamentals, req-crsp-daily, req-crsp-monthly, req-crsp-stocknames, req-ccm-links, req-ibes-guidance-observations, req-ibes-wrds-ticker-permno, req-ibes-iclink, req-ibes-author-ticker-permno, req-ibes-cibeslnk, req-comp-security-ibtic, req-ibes-analyst-summary, req-13f-holdings, req-seo, req-gvkey-cusip-map, req-crsp-return-deciles, req-crsp-market-index, req-crsp-delisting, iss-input-coverage
Evidence: ev-datasheet-sources, ev-option-chunks, ev-options-transform, ev-main-compustat, ev-main-crsp-staging, ev-monthly-stock-input, ev-ownership-construction, ev-forecast-inputs, ev-forecast-gvkey-links, ev-forecast-ccm, ev-analyst-inputs, ev-history-controls, ev-controls-crsp-inputs, ev-probe-crsp-dsf, ev-probe-crsp-msf, ev-probe-crsp-stocknames, ev-probe-crsp-ccm, ev-probe-ibcrsphist, ev-probe-ibes-statsumu, ev-probe-tfn-s34, ev-probe-crsp-msi, ev-probe-crsp-delist, ev-probe-comp-funda, ev-catalog-local-products, ev-catalog-short-queries

Preparation / proposed procedure:

1. Confirm the OptionMetrics chunk files' identifiers, date encoding, price/strike scale and unit convention against the authored transforms; preserve strike_price/1000, bid-offer midpoint and value multiplied by 100, with all named 1996-2016 chunks.
2. Reconcile COMP.FUNDA and the two named Compustat Stata exports to their different consumers: main-panel SIC/SICH fields, SAS FYEAR 1984-2017 controls, the ten-year ROA history, four prior OANCF lags, and 2017 forward-investment input. Do not map SIC to SICH without author/data-source support.
3. Verify CRSP.DSF, monthly CRSP, dated STOCKNAMES and CCM as separate products. Resolve the direct `NCUSIP` field required from the author monthly Stata file against local CRSP.MSF's catalogued CUSIP field; do not silently source it from STOCKNAMES or rename CUSIP.
4. Retain the three concurrent forecast ticker-to-PERMNO sources (WRDS Linking Suite, ICLink and the author-referenced IBES_Ticker_permno file), then retain CIBESLNK, COMP.SECURITY/IBTIC and CCM GVKEY/PERMNO enrichment as separate joins with their distinct scores/date rules.
5. Verify the analyst summary product separately: IBES.STATSUMU_EPSUS fields and the 90-day lookback to Compustat fiscal year end; preserve the resulting annual analyst coverage export fields.
6. Verify 13F S34 report/holdings fields and the CUSIP8/year/month link, plus the actual SEO4 workbook headers and imported Excel types. Do not treat a TFN timeout or an empty catalog search as an access barrier.
7. Match the SAS monthly control inputs CRSP.MSF0918, ERMPORT1, MSI and DSEDELIST by their real product labels, link keys and fiscal-year windows; do not substitute a similarly named market-return table.

Validation to perform later:

- For each exact direct input and local candidate, confirm product/version, required source columns, types/units, identifier normalization, date history and expected population; keep the route unverified until each contract matches.
- Reconcile candidate mappings with the author's named files and SAS/Stata consumers before any separate acquisition or execution decision.

### act-companion-source-contracts: Obtain or identify the exact prepared inputs and their producing procedures for the supplied CDS, comparability, insider, 8-K, conference-call and forecast-surprise branches.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req-cds-initiation, req-comparability-data, req-insider-options, req-sec-8k-filings, req-cik-gvkey-map, req-conference-call-analytics, req-mf-surprise, iss-input-coverage, iss-unproduced-prepared-inputs
Evidence: ev-datasheet-sources, ev-cds-branch, ev-comparability-input, ev-comparability-consumer, ev-insider-branch, ev-eightk-branch, ev-conference-call-branch, ev-goodbad-branch, ev-workflow-trace, ev-analyst-inputs, ev-profitmarg-producer

Preparation / proposed procedure:

1. Confirm the Markit CDS initiation input schema and producer for `CDS_incep_all.dta` (GVKEY/date_incep; supplied code window 1997-2015), and the exact De Franco 2013 author file's GVKEY/year key and m4_acctcomp column. Keep dispersion with the SAS analyst-summary producer and profitmarg with the main Stata Compustat producer.
2. Confirm `TFN_Table2_19962018.dta` fields, cleaning definitions and the shares*xprice unit contract, then check dated CRSP-name matching for transaction years 1996-2017.
3. Obtain the `8k_98_119.dta` extraction rules that produce CIK/fdate/nitem and the date-keyed `cikgvkey.dta` join. A local SEC corpus is only an unverified source candidate: no corpus scan was performed, and any later route must match 8-K item parsing, filters, CIK links and history.
4. Confirm Bushee's prepared `SHAREME_confcallanalytics02to15.dta` definition for num_words_comp_qa and verify the 2002-2015 input population; do not replace it with conference-call text from another product.
5. Obtain the producing code/schema for `mf_surprise.dta`, retaining its ann_date fields and separate branch from gdet_lnk_new. Preserve the terminal 8k_ann, cofcall and gb_all saves as supplied preparation outputs.

Validation to perform later:

- Check each prepared file against its exact direct-read columns, key and date transformation; document producer paths and history without inferring a raw-source-to-prepared-file conversion that is not supplied.
- Confirm every terminal branch input is accounted for and its saved output is retained; absence of a downstream consumer is not a closure defect by itself.

### act-sas-roa-definition: Clarify the missing ROA producer/definition that blocks the supplied SAS controls SQL consumers.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req-compustat-fundamentals, iss-sas-roa-contract
Evidence: ev-history-controls, ev-ten-year-history, ev-main-compustat, ev-workflow-trace

Preparation / proposed procedure:

1. The current SAS KEEP list excludes ROA and no SAS stage produces it before the two PROC SQL consumers, so this controls path is blocked as written. Clarify the intended SAS-stage ROA producer/definition before proposing a repair.
2. Keep the authored `0<a.fyear-b.fyear<=10` historical window and `numroa>=5` condition; do not insert a guessed ratio or assume the separate Stata `roa=ib/at` is available in SAS without a documented handoff.

Validation to perform later:

- After the producer is identified, compare its date, GVKEY and ROA definition with both SQL consumers and verify the rolling-history count without changing the requested control definition.

### act-compustat-sic-source: Resolve the main Compustat input's required SIC field against the candidate annual product and author export.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req-compustat-fundamentals, iss-compustat-sic-field
Evidence: ev-probe-comp-funda, ev-catalog-local-products, ev-main-compustat

Preparation / proposed procedure:

1. Confirm whether the author's 1950-2017 Stata export contains SIC in addition to SICH and identify its provenance; retain `sic` for the industry-group construction unless the authors document the input field.
2. Keep COMP.FUNDA's actual catalog field list and failed selected-field probe on record; do not substitute SICH for SIC.

Validation to perform later:

- Verify the exact imported SIC and SICH columns and their types in a bounded source metadata check before any authorized run.

### act-monthly-ncusip-source: Resolve how NCUSIP reaches the author monthly stock file used by the ownership join.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req-crsp-monthly, iss-crsp-monthly-ncusip-field
Evidence: ev-ownership-construction, ev-probe-crsp-msf, ev-probe-crsp-stocknames, ev-catalog-local-products

Preparation / proposed procedure:

1. Confirm whether `msf_19252017.dta` is an author-prepared file with NCUSIP, and if so document its source field and dated mapping; keep the separate CRSP.STOCKNAMES producer/consumer role explicit.
2. Do not rename CUSIP to NCUSIP or infer a crosswalk from a similarly named field.

Validation to perform later:

- Compare the actual monthly file columns and `cusip8` join to their documented source/mapping and confirm all required years before running the holdings merge.

### act-stata-addons: Prepare Stata's three invoked add-on commands in the intended runtime environment without changing their authored use.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: sw-winsor2, sw-quantiles, sw-hhi5
Evidence: ev-stata-winsor2, ev-stata-quantiles, ev-stata-hhi5, ev-quantiles-command, ev-winsor2-working-copy-reflow

Preparation / proposed procedure:

1. Identify approved versions/sources for winsor2, quantiles and hhi5, then make those exact commands available in the Stata adopath during a separately authorized run; no package was installed during this assessment.
2. Retain Stata 18, reghdfe 6.12.3 and ftools 2.49.1 as verified base-environment facts; use the separate Table 5 IV compatibility action to resolve the author-targeted inline-IV version/backend and its dependencies.

Validation to perform later:

- In a later environment-only metadata check, confirm `which winsor2`, `which quantiles` and `which hhi5` resolve to the intended versions before any author program is run.

### act-sas-runtime: Resolve the SAS runtime initialization issue before the SAS stages are attempted.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: sw-sas
Evidence: ev-runtime-environment, ev-sas-link-export

Preparation / proposed procedure:

1. Have the runtime environment's TKELS load failure diagnosed at the host/runtime level; do not infer missing entitlement or retry SAS startup as part of this assessment.
2. Once the initialization problem is resolved under a separate execution authorization, verify the SAS 9.4 TS1M8 session and DTA/Stata import/export support with a minimal empty-session check before loading author programs or data.

Validation to perform later:

- Record the future SAS version, startup return code, actual log/stderr and import/export component status; then validate the required DATA step, SORT, SQL and MEANS procedures without invoking the author code.

### act-reghdfe-iv-version: Resolve and prepare the documented Stata backend/version for the supplied Table 5 inline IV specifications, preserving the author equations.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: iss-reghdfe-iv-version, sw-reghdfe-legacy-iv
Evidence: ev-table5-inline-iv, ev-runtime-environment, ev-reghdfe-iv-doc, ev-ivreghdfe-dependency-doc

Preparation / proposed procedure:

1. Confirm the authors' targeted reghdfe version and IV backend for the four Table 5 calls. If they intended the legacy inline form, verify the documented reghdfe version(3) compatibility route or the specified historical version through primary help/version metadata before setup; do not trial the syntax.
2. Only if the authors identify a separate ivreghdfe backend, treat it as a conditional alternative setup path and check the documented ivreg2, reghdfe 5.x and ftools dependencies. Keep the supplied endogenous variable, instrument, outcomes, absorbed effects and clustering; do not migrate automatically or claim equivalence. These modern-only packages are not mandatory scope software unless that backend is confirmed.
3. Record the selected package versions and backend in the run environment manifest. Do not run a regression or estimator during software preparation.

Validation to perform later:

- Use metadata-only `which` and version/help inspection for the selected legacy reghdfe path; inspect ivreghdfe, ivreg2 and their documented dependencies only if the authors confirm that optional backend. Do not execute any IV call.


## Remaining issues and prerequisites

- iss-embedded-code [preparation; full_pipeline]: The substantial Stata and SAS program sections are embedded in a PDF rather than supplied as standalone drivers. They need extraction/reflow into working-copy files, ordinary host-visible roots, and the two supported working-copy syntax/reflow repairs preserved from the source.
- iss-cross-language-handoffs [unresolved; full_pipeline]: SAS stages 4 and 8 export to Windows absolute paths while downstream Stata reads relative basenames; ordinary host-visible root/path mapping is run preparation. The exported fields/types and merge contracts at the Stata consumers still require verification. The stage 10 controls export/import already share [redacted-path-3090f1634575], but its retained fields must still match the consumer.
- iss-input-coverage [unresolved; full_pipeline]: The package supplies a firm identifier list and embedded workflow code, not the prepared estimation data. All 26 consumed data products/files remain unverified for exact schema, units, population/history and construction; bounded one-row candidates do not establish full coverage.
- iss-sas-roa-contract [blocking; full_pipeline]: The SAS controls DATA step starts with `COMP.FUNDA (keep=&vars)` where the defined KEEP list omits ROA; its intervening SAS DATA/SQL stages before the earnings-volatility block create no ROA. Both subsequent PROC SQL consumers reference b.roa, so the supplied SAS controls branch has a source-level missing-column blocker as written. The intended ROA producer/definition remains unresolved. Stata later derives roa=ib/at in another stage, but no handoff to the SAS controls table is supplied; do not insert a guessed definition.
- iss-compustat-sic-field [unresolved; full_pipeline]: The bounded COMP.FUNDA candidate request fails because SIC is absent from its catalog schema; the supplied main Stata panel explicitly reads sic and later constructs industry groups from sic. The same catalog has SICH, but no supported alias or mapping equates SICH with SIC here. Confirm the intended producer/field or author-export schema.
- iss-crsp-monthly-ncusip-field [unresolved; full_pipeline]: The supplied Stata ownership stage reads NCUSIP from msf_19252017.dta, whereas frozen CRSP.MSF metadata lists CUSIP and no NCUSIP. CRSP.STOCKNAMES has NCUSIP in its own dated-name table, but the code's direct monthly-file contract and author-export provenance do not establish a mapping from that separate source.
- iss-unproduced-prepared-inputs [unresolved; full_pipeline]: The supplied code directly reads CDS_incep_all.dta, gvkey_cusip.dta, cikgvkey.dta, mf_surprise.dta and 8k_98_119.dta without a producing step in the supplied PDF. Some source families are named in the datasheet, but exact preparation, identifiers/date semantics, fields and history are not specified. These remain input/producer contracts, not evidence that their terminal output branches need later consumers.
- iss-reghdfe-iv-version [unresolved; full_pipeline]: The Table 5 block contains four reghdfe inline 2SLS calls instrumenting LnOptvol with lnmoney. Local metadata establishes reghdfe 6.12.3 and ftools 2.49.1, not support for this older inline-IV form. Maintainer help documents IV/2SLS in reghdfe v3, its move to ivreghdfe from v4, and a version(3) compatibility option; the exact author-targeted version/backend and whether the installed legacy path accepts these calls remain unverified. ivreg2 and ivreghdfe availability are not established. Preserve the author equation and fixed effects; do not automatically substitute a backend or assert equivalence.
- req-options [undetermined]: OptionMetrics daily option observations in the author-named chunks. Required source fields are date, cp_flag, strike_price, best_bid, best_offer, volume, open_interest and cusip. The supplied Stata transforms parse dates, use strike_price/1000, midpoint (best_bid+best_offer)/2, and option value midpoint*volume*100 before matching daily CRSP stock prices and aggregating by firm-year-quarter. The target sample is 1996-2016; code names 1996-2009 annual/split chunks and 2010-2016 quarterly a-d chunks.
- req-compustat-fundamentals [undetermined]: Annual Compustat fundamentals consumed through the Stata 1950-2017 and 1950-2018 files and SAS COMP.FUNDA. Main panel code selects 1996-2017; SAS controls explicitly select FYEAR 1984-2017 and form a one-year lag and ten-year ROA history; cash-flow volatility uses four prior OANCF lags and forward investment is shifted one year from FYEAR 1996-2017. Preserve the different consumers and histories.
- req-crsp-daily [undetermined]: CRSP daily stock observations for daily permno-date prices matched to OptionMetrics, annualized share and dollar volume, and daily return standard deviation. Author code reads dsf_19252017.dta with CUSIP, PERMNO, DATE, PRC, VOL and RET; the annual volume stkvol is consumed by OS before a later stage overwrites stkvol with return SD.
- req-crsp-monthly [undetermined]: CRSP monthly stock data for year-end price, institutional-holdings shareout matching, and the SAS 12-month return/turnover controls. Stata names msf_19252017.dta; SAS also reads crsp.msf0918. The exact delivered schemas and overlap are unresolved.
- req-crsp-stocknames [undetermined]: CRSP historical stock-name/CUSIP records used to form NCUSIP-PERMNO and dated ticker/security joins, fill missing SIC from SICCD, and link insider transactions by CUSIP and transaction date. Required fields include PERMNO, NCUSIP, NAMEDT, NAMEENDDT and SICCD.
- req-ccm-links [undetermined]: CRSP/Compustat CCM link history for forecast-to-GVKEY/PERMNO completion, annual panel joins, SAS control matching and ownership linking. Code applies LINKPRIM/LINKTYPE filters and date-effective LINKDT/LINKENDDT intervals.
- req-ibes-guidance-observations [undetermined]: IBES management guidance observations imported from mf19922017.dta for the supplied SAS linker. The code uses ticker, announcement and forecast-period dates, periodicity, measure, values and identifiers to create linked management-forecast outputs. Author target period is 1992-2017; no producer of this prepared file is supplied.
- req-ibes-wrds-ticker-permno [undetermined]: WRDS Linking Suite IBES ticker-to-PERMNO records used as the first source in the management-forecast link join, filtered to scores 1 or 2 and bounded by sdate/edate around announcement date.
- req-ibes-iclink [undetermined]: The separate ICLink table read by the forecast linker, deduplicated by PERMNO and then TICKER using SCORE before joining ticker-level announcements. It is used alongside the WRDS and author link tables, not as an interchangeable product.
- req-ibes-author-ticker-permno [undetermined]: The separate author-referenced IBES_Ticker_permno file used as a third concurrent ticker-to-PERMNO source, with date bounds and duplicate/inconsistency filters.
- req-ibes-cibeslnk [undetermined]: IBES ticker-to-GVKEY dated link table LINK.CIBESLNK, joined on ticker and announcement date using FDATE/ LDATE, then supplemented by the Compustat security mapping and CCM history.
- req-comp-security-ibtic [undetermined]: Compustat security ticker mapping imported as gvkey_ibtic_link_sas.dta and joined on IBES ticker to supply GVKEY when CIBESLNK does not. It is a distinct link source from CCM and CIBESLNK.
- req-ibes-analyst-summary [undetermined]: Unadjusted US IBES EPS summary statistics joined to Compustat firm fiscal-year ends for analyst coverage. The SAS code uses ticker, measure/FPI, period end date, numest/meanest/stdev and statpers within the 90 days before fiscal month-end; the export then supplies coverage/forecast-summary fields.
- req-13f-holdings [undetermined]: Thomson-Reuters 13F holdings used to form annual institutional ownership by CUSIP/PERMNO and then GVKEY. The Stata author file tfn_S34_19802017.dta uses rdate, mgrno, typecode, cusip, shares, prc, shrout1 and change and pairs holdings with monthly CRSP shareout data.
- req-seo [undetermined]: Thomson One equity-issuance workbook SEOall.xls, worksheet SEO4. Stata imports the first row with lowercase names and uses CUSIP, issuedate and SEO to create a six-character CUSIP/year issuance indicator for the estimation panel.
- req-gvkey-cusip-map [undetermined]: GVKEY-CUSIP-year crosswalk gvkey_cusip.dta used to assign GVKEY to institutional-ownership rows without PERMNO. The supplied code reads it but does not create it; expected keys are CUSIP8/year and GVKEY.
- req-crsp-return-deciles [undetermined]: CRSP monthly exchange/index return-decile data CRSP.ERMPORT1 joined by PERMNO and DATE to supply decret and capn for size-adjusted fiscal-year return controls.
- req-crsp-market-index [undetermined]: CRSP monthly market index returns from CRSP.MSI, joined by DATE to form market-adjusted fiscal-year return controls.
- req-crsp-delisting [undetermined]: CRSP delisting events from CRSP.DSEDELIST used to replace or adjust monthly CRSP returns when a delisting occurs in the fiscal-year window. Code consumes PERMNO, DLSTDT, DLRET and DLSTCD (and imports DLPDT).
- req-cds-initiation [undetermined]: Markit CDS initiation data supplied to Stata as CDS_incep_all.dta. The code reads GVKEY and date_incep, creates firm-year CDS initiation/trading indicators, and uses this branch for the supplied Table 4 Panel C specifications; its stated analytic window is 1997-2015.
- req-comparability-data [undetermined]: De Franco et al. firm-year accounting comparability data read from verdi_2011_jn_benefitsfinancial_data_2013.dta, then deduplicated by GVKEY/year and merged into the supplied cross-sectional analyses. The shown comparability source measure is m4_acctcomp; dispersion is produced in the SAS analyst-coverage stage and profitmarg is generated in the main Stata Compustat stage.
- req-insider-options [undetermined]: Thomson Reuters insider transaction file TFN_Table2_19962018.dta for the supplied annual insider option-transaction measure. The Stata branch filters form 4, officer roles, P/S transaction codes and option/call/put types; calculates shares*xprice and links CUSIP to dated CRSP names, then saves annual PERMNO dollar volume for 1996-2017.
- req-sec-8k-filings [undetermined]: Prepared 8-K item observations 8k_98_119.dta for the standalone supplied filing-count branch. Code reads CIK, filing date and item number, counts different item families before/after 2004, joins CIK/GVKEY and shifts counts to following year; the branch terminates at saved 8k_ann.dta with no supplied estimation consumer.
- req-cik-gvkey-map [undetermined]: CIK-GVKEY date-keyed mapping in cikgvkey.dta for the 8-K branch's merge m:1 CIK/FDATE. It is a distinct required input from the 8-K item dataset; its producer and filing-date linkage semantics are not supplied.
- req-conference-call-analytics [undetermined]: Bushee et al. prepared quarterly conference-call analytics in SHAREME_confcallanalytics02to15.dta, consumed by a supplied branch that keeps GVKEY, PERMNO, RDQ and NUM_WORDS_COMP_QA, derives LNQAWORDS from NUM_WORDS_COMP_QA, and saves following-year QA word-count output cofcall.dta. The terminal output has no later supplied estimation consumer.
- req-mf-surprise [undetermined]: Prepared management forecast surprise input mf_surprise.dta for the supplied positive/negative news branch. It is a separate direct input from the earlier gdet_lnk_new.dta linker output: the branch uses ann_date and forecast values/period fields and saves following-year prop_pcmd_all/prop_ncmd_all in terminal gb_all.dta; no producer is supplied.
- sw-sas [unverified]: SAS 9.4 TS1M8 binary is present, but the saved bounded startup probe failed at TKELS initialization. No author SAS program was started; runtime readiness and entitlement remain unverified. Supplied active procedures include DATA steps, PROC IMPORT/EXPORT (DTA/Stata), SORT, SQL and MEANS.
- sw-winsor2 [preparation_required]: The supplied code invokes winsor2; a metadata-only which query did not find it in the checked Stata 18 adopaths.
- sw-quantiles [preparation_required]: The supplied code invokes quantiles to construct year-grouped Z-score quantiles; a metadata-only which query did not find that command in the checked Stata 18 adopaths.
- sw-hhi5 [preparation_required]: The supplied cross-sectional code invokes hhi5 sale, by(Ind year); a metadata-only which query did not find that command in the checked Stata 18 adopaths.
- sw-reghdfe-legacy-iv [unverified]: The current reghdfe help documents a version(3) compatibility path for earlier IV/2SLS support, but no local metadata or syntax check establishes that the installed 6.12.3 build accepts the exact author calls through that path.

## Review notes

- The assessed target is only the supplied full pipeline in CNY_Stata and SAS code.pdf; no compatible analysis-only route is supplied. CNY_Identifier.xls is an identifier list, not an analysis dataset.
- The static pattern audit reported no supported code artifacts, but direct reading and page inspection found substantial Stata and SAS programs embedded in the PDF. The embedded text is not a standalone runnable driver.
- The saved workflow trace preserves the actual Stata to SAS to Stata interleaving and producer-consumer paths. The first stkvol output is stock volume consumed by OS; the later same-name output is daily-return standard deviation. Retain that author order.
- The 8k_ann, cofcall and gb_all branches end in supplied save statements and are retained as terminal preparation outputs. No missing downstream consumer is inferred from the supplied text.
- All matching local data probes were bounded to a row or metadata lookup. Their results do not establish full history, population, values or licensing. The failed Compustat field request and TFN timeout are not treated as access denials.
- No author program, estimator, regression, simulation, dataset construction, download or install was performed. Stata and add-on checks were metadata-only; the saved SAS startup error is TKELS initialization and does not establish license status.
- No numeric outcome fields are asserted in this draft. Execution has not been verified.
- The SAS controls stage has a confirmed source-level blocker: its KEEP list omits ROA and the later SQL consumers reference b.roa; the intended definition/fix remains unresolved and has not been guessed.
- Table 5's four inline reghdfe IV calls are preserved. The installed reghdfe 6.12.3 and ftools 2.49.1 do not establish compatibility with that legacy form; the author help documents a v3 IV path, a version(#) route and later ivreghdfe integration. Exact legacy compatibility remains unverified. A separate ivreghdfe/ivreg2 dependency stack is conditional on author confirmation and is not a mandatory scope software requirement. No syntax trial, regression, or estimator migration was performed.
