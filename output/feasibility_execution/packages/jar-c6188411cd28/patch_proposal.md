# Patch proposal: jar-c6188411cd28

Real Effects of Hedge Accounting Standards: Evidence from ASU 2017-12

DOI: 10.1111/1475-679X.12614

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied R workflow across its manuscript tables and appendix branches, including the mapped raw-source components, author-prepared intermediate panels, manual SEC disclosure inputs, matching branches and event studies.

Entry points: `Code ABC (2025).R`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 5/12614 - Real-Effects-of-Hedge-Accounting-Standards-Evidence-from-ASU-2017-12/abc-datasheet-code-identifier-and-log-files.zip",
      "sha256": "e58b685875bad9451e999fa87bc5be21dd173c13b63117b51b43e38649be0e22"
    },
    {
      "path": "JAR-Volume 63/Issue 5/12614 - Real-Effects-of-Hedge-Accounting-Standards-Evidence-from-ASU-2017-12/abc-online-appendix.pdf",
      "sha256": "f6a074d55f1fb9a3ea90bc697ec63a8cc50459a4ed146273a49c6378052e6033"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "f5eff7e849869364447aeb4fec763030e234f5181f8b8f80a5d07b38d963b20e"
}
```

## Proposed actions

### ACT-VALIDATE-LOCAL-RAW-COMPONENTS: Use only exact catalog field records and bounded approved one-row metadata probes to finish raw product, field, identifier and required-period mapping; preserve candidate routes without claiming compatibility until all consumed fields are proved.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: ISSUE-RAW-PRODUCT-FIELD-PROOF, REQ-CRSP-MONTHLY, REQ-COMPUSTAT-ANNUAL, REQ-COMPUSTAT-QUARTERLY, REQ-FOREIGN-SEGMENTS, REQ-CRSP-DAILY, REQ-IBES-SUMMARY, REQ-IBES-CRSP-LINK, REQ-MACRO-TRADE-WEIGHTED-USD, REQ-MACRO-LIBOR, REQ-QUARTERLY-DERIVATIVE-VALUES, REQ-DEBT-ISSUANCE-PANEL
Evidence: E-CAT-CRSP-MSF, E-CAT-CRSP-DSF, E-CAT-COMP-FUNDA, E-CAT-COMP-FUNDQ, E-CAT-COMPSEG, E-CAT-IBES-SUMMARY, E-CAT-FRB-FX, E-CAT-FRB-RATES, E-R-CRSP-MONTHLY-FIELDS, E-R-COMPUSTAT-ANNUAL-FIELDS, E-R-IBES-LINK-FIELDS

Preparation / proposed procedure:

1. Map each code-consumed raw field and identifier/date role to an exact catalog field record before any row probe.
2. Retain the CRSP monthly/daily, Compustat annual/quarterly, segment, IBES and FRB catalog candidates as unverified until complete field and history evidence exists.
3. Do not substitute the FRB candidate index or rate for the author Datastream measure without the exact index definition/tenor.

Validation to perform later:

- Confirm all consumed fields, identifier links, fiscal/calendar date rules and the specific 2009–2019 plus lag/lead periods before marking a route verified.

### ACT-SUPPLY-PREPARED-PANEL-PRODUCERS: Supply the distinct author-prepared panels and crosswalks that lack in-source producers, with their field definitions and row keys. The separate unmatched_sample1 file is addressed by a source-supported save of main_sample.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE-MISSING-PREPARED-PRODUCERS, REQ-OVERALL-INDUSTRY-EXPOSURE-PANEL, REQ-UNMATCHED-SAMPLE-WITH-LAGS, REQ-DEBT-ISSUANCE-PANEL, REQ-DETERMINANTS-SAMPLE, REQ-OVERALL-LONGER-PANEL, REQ-SIC2-CROSSWALK, REQ-NEW-USER-LIST
Evidence: E-R-OVERALL-SAMPLE-FIELDS, E-R-LAGGED-SAMPLE, E-R-DEBT-ISSUANCE-READ, E-R-DETERMINANTS-SAMPLE, E-R-LONGER-PANEL, E-R-SIC-MAP, E-R-NEW-USER-LIST

Preparation / proposed procedure:

1. Provide the prior overall-sample exposure panel because the source intentionally restores its revised-sample exposure values.
2. Provide or document producers for unmatched_sample_with_lags, unmatched_sample_used_in_determinants and the longer panel.
3. Document and supply the SIC crosswalk and new-user membership rule.
4. For debt issuance, align the source formula from DLTT, DLC and lagged AT to the keyed data_date file consumed downstream.

Validation to perform later:

- Confirm exact firm-date/fiscal-year keys, measure units, sample selection, and lag/lead history against the supplied downstream consumers.

### ACT-CLARIFY-UNUSED-INDUSTRY-READ: Confirm whether industry_wise_split.csv is an intended run prerequisite or a stale unused read; if retained, provide the file and its basic header contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ-INDUSTRY-WISE-SPLIT-READ
Evidence: E-R-INDUSTRY-WISE-READ

Preparation / proposed procedure:

1. The code actively calls read_csv for the file, then the imported object is not referenced; do not silently omit it in a full unmodified run.
2. Ask the author to provide the file or authorize removing the unused read after confirming there is no omitted downstream branch.

Validation to perform later:

- Confirm the program proceeds through the SIC partition branch with the documented decision and without changing any reported analyses.

### ACT-COLLECT-MANUAL-SEC-DATA: Collect or obtain the distinct SEC-derived adoption, hedge-use, hedge-type, UGL, instrument/risk, currency, commodity and risk-specific inputs following the author workflow; the filings are public but the author rows are not supplied.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: ISSUE-HANDCOLLECTED-DISCLOSURE-PANEL, REQ-ASU-ADOPTION-DATES, REQ-HEDGE-USE-PANEL, REQ-HEDGE-TYPE-PANEL, REQ-UGL-MANUAL-VALUES, REQ-INSTRUMENT-RISK-CLASSIFICATION, REQ-CURRENCY-HEDGING-CLASSIFICATION, REQ-COMMODITY-HEDGING-CLASSIFICATION, REQ-COMMODITY-RISK-SUBSAMPLE, REQ-FX-RISK-SUBSAMPLE, REQ-LIBOR-RISK-SUBSAMPLE
Evidence: E-DOC-SEC-SOURCES, E-DOC-HANDCOLLECTION, E-SEC-SEARCH, E-R-ADOPTION-FIELDS, E-R-HANDCOLLECTED-FIELDS, E-R-HA-TYPE-FIELDS, E-R-UGL-FIELDS, E-R-DERIV-TYPE-FIELDS, E-R-CURRENCY-FIELDS, E-R-COMMODITY-FIELDS, E-R-RISK-SUBSAMPLE-FIELDS

Preparation / proposed procedure:

1. Use the official SEC EDGAR 10-Q/10-K filings for the defined author firm-period population and follow the supplied Appendix A collection steps.
2. Keep each data contract distinct: adoption dates; overall hedge use; type-specific hedge use; UGL values; instrument/risk classes; currency classes; commodity classes; and risk-specific designated-use subsets.
3. Retain CIK only as a filer identifier aid and record firm/date/source-filing links for each manual observation.

Validation to perform later:

- Check every required firm-period and field against the author code and the Appendix A collection template; do not treat public filing availability as proof the hand-collected panel is complete.

### ACT-RESOLVE-IBES-LINK: Identify and provide the exact WRDS IBES-to-CRSP historical link product matching SCORE, ticker, PERMNO and effective start/end dates.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: ISSUE-IBES-LINK-IDENTITY, REQ-IBES-CRSP-LINK
Evidence: E-R-IBES-LINK-FIELDS, E-CAT-IBES-LINK-SEARCH, E-DOC-WRDS-SOURCES

Preparation / proposed procedure:

1. Confirm the exact source dataset alias and field names for the scored effective-dated ticker/PERMNO link.
2. Establish the author sample-period link coverage and the treatment of non-unique tickers after SCORE filtering.

Validation to perform later:

- Verify the required fields and link validity dates against the source and downstream firm-year join.

### ACT-PERSIST-STACKED-PANEL: Persist the existing in-memory stacked cohort object immediately before the first workspace reset at line 2631; a write before the later line 2689 reset would be too late because stacked has already been removed. The source edit remains conditional on downstream timing-key and row-order validation.

Scopes: full_pipeline. Type: source_edit. Certainty: conditional.
Addresses: ISSUE-STACKED-DATA-PERSISTENCE
Evidence: E-R-STACKED-IN-MEMORY, E-R-STACKED-FIRST-RESET, E-R-STACKED-CONSUMER

**Proposed edit:** `Code ABC (2025).R:2631–2631`
Source SHA-256: `2b91ae803e9b8f20a170ffa71d25e2e8b66dfc27451b0a932d1120b794b8a284`

Persist the exact in-memory cohort before the first workspace reset removes it, using the same relative CSV path read by the existing event-study consumer.

Current text:
```
rm(list = ls())
```

Proposed replacement:
```
readr::write_csv(stacked, "./stacked_data.csv")
rm(list = ls())
```

Preparation / proposed procedure:

1. Insert the proposed write of the existing stacked object immediately before the first workspace reset at line 2631, while that object is still in memory.
2. Keep the existing ./stacked_data.csv path and cohort construction; a write before the later line 2689 reset is too late.

Validation to perform later:

- Confirm the write executes before the first reset at line 2631 and that no later stacked reassignment is needed before the line 2709 consumer.
- Check saved gvkey, asu and fyear values, within-firm row ordering and cohort timing against the consumer cumsum logic; confirm repeated event-study consumers use the same file contract and outcomes/controls still come from the joined determinants sample.

### ACT-CHECK-R-PACKAGES: Confirm availability of the exact R packages loaded by the author source before running its table and appendix branches.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: ISSUE-R-PACKAGE-CLOSURE, SOFT-R-PACKAGES
Evidence: E-ENV-R, E-R-LIBRARIES-CORE, E-R-LIBRARIES-APPENDIX, E-R-LIBRARIES-ROBUSTNESS

Preparation / proposed procedure:

1. Check package metadata without loading author code; if any required package is absent, use the environment owner’s approved installation process.

Validation to perform later:

- Confirm each declared library call resolves in the selected R runtime before analysis.

### ACT-PREP-EXPOSURES: After compatible monthly inputs and R packages are confirmed, materialize the author-described exposure object before its consumer.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ-CRSP-MONTHLY, REQ-COMPUSTAT-ANNUAL, REQ-MACRO-PPI, REQ-MACRO-TRADE-WEIGHTED-USD, REQ-MACRO-LIBOR
Evidence: E-R-EXPOSURES-PRODUCER, E-R-MACRO-FIELDS

Preparation / proposed procedure:

1. Run the commented author exposure block only after CRSP monthly, Compustat link and all three macro-series contracts are confirmed.
2. Write the resulting exposure table to exposures_new.rds as the active consumer expects.

Validation to perform later:

- Confirm the output keys and beta, libor_exp, comm_exp and fx_exp measures align with the subsequent PERMNO/fiscal-year join.

### ACT-RUN-FULL-PIPELINE: Run the supplied R workflow only after required raw product contracts, author-prepared producers, hand-collected panels, identifier links and package requirements have been resolved.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: ISSUE-DEPENDENCY-CLOSURE
Evidence: E-DOC-CODE-STRUCTURE, E-R-CRSP-MONTHLY-READ, E-R-STACKED-CONSUMER, E-R-STACKED-FIRST-RESET

Preparation / proposed procedure:

1. Stage only verified files and explicitly generated outputs in the package working directory.
2. Preserve producer-before-consumer ordering for exposures_new.rds, ha_use_final_data_after_cleaning.csv, derivative_type_data.csv and final_data_with_replacement_31Oct.csv.
3. Apply and validate the main_sample save before line 441 and the stacked cohort save before the first line 2631 reset; the later line 2709 consumer follows a separate reset at line 2689. Resolve remaining distinct panel producers, raw product contracts, hand-collected inputs, identifier links and package requirements before running the workflow.

Validation to perform later:

- Confirm every mandatory input is present with required fields and each generated output is written before its first consumer; retain separate full-pipeline closure status.

### ACT-PERSIST-UNMATCHED-SAMPLE1: Persist the source-identified final main_sample object at the exact CSV path read after the workspace reset; the edit is conditional on downstream schema and key validation.

Scopes: full_pipeline. Type: source_edit. Certainty: conditional.
Addresses: REQ-UNMATCHED-SAMPLE1
Evidence: E-R-MAIN-SAMPLE-COMMENT, E-R-UNMATCHED-SAMPLE1

**Proposed edit:** `Code ABC (2025).R:441–441`
Source SHA-256: `2b91ae803e9b8f20a170ffa71d25e2e8b66dfc27451b0a932d1120b794b8a284`

The source explicitly identifies main_sample as the object corresponding to the later CSV read. Save that exact object to the existing path before clearing the workspace.

Current text:
```
rm(list=ls())
```

Proposed replacement:
```
readr::write_csv(main_sample, "./unmatched_sample1.csv")
rm(list=ls())
```

Preparation / proposed procedure:

1. Insert the proposed write of main_sample immediately before the line 441 workspace reset; preserve the existing source object and file path.
2. Do not substitute another sample or reconstruct the handcollected join.

Validation to perform later:

- Confirm the emitted file resolves to the same working-directory path as the line 443 read.
- Compare emitted column names and imported types with all downstream consumers, and validate required firm/date/treatment/adoption/outcome/control fields and row keys before running later branches.


## Remaining issues and prerequisites

- ISSUE-DEPENDENCY-CLOSURE [unresolved; full_pipeline]: All 33 frozen read dependencies are dispositioned. Full closure remains unresolved because local raw candidates lack complete field/identifier/history proof, hand-collected SEC-derived rows are not supplied, several distinct prepared panels remain without in-source producers, and stacked_data.csv needs a validated persistence step from the existing in-memory cohort object before its first workspace reset at line 2631.
- ISSUE-RAW-PRODUCT-FIELD-PROOF [unresolved; full_pipeline]: The bounded catalog results identify candidate CRSP, Compustat, segment, IBES and FRB products, but no successful exact-field probe established complete consumed-field mappings or row/history coverage. Candidate table presence is not treated as compatible raw availability.
- ISSUE-MISSING-PREPARED-PRODUCERS [unresolved; full_pipeline]: The supplied R source reads overall_sample.csv, unmatched_sample_with_lags.csv, data_with_debt_issuance.csv, unmatched_sample_used_in_determinants.csv and overall_sample_longer_panel_october_2023.csv without a preceding writer in the supplied source. These author-named files have distinct panels/keys and cannot be collapsed into generic extract identity or ordinary preparation. The separate unmatched_sample1 input has an explicitly identified in-memory source object and a concrete save-before-reset proposal.
- ISSUE-HANDCOLLECTED-DISCLOSURE-PANEL [unresolved; full_pipeline]: The datasheet states the 11,000-row quarterly hedge-position compilation is proprietary while providing Appendix A guidance. SEC filings are public, but firm-period population, manual category values, adoption and UGL fields are not packaged, so reconstructing the documented collection remains a real data task.
- ISSUE-IBES-LINK-IDENTITY [unresolved; full_pipeline]: The IBES join requires scored, effective-dated TICKER-to-PERMNO links with SCORE=1 and unique ticker selection. The bounded exact ICLINK lookup found no matching leaf, and no compatible local link product or period alignment was established.
- ISSUE-STACKED-DATA-PERSISTENCE [unresolved; full_pipeline]: The source builds the in-memory stacked cohort at line 2574, then clears the workspace at the first reset at line 2631. The full intervening source block through the later reset at line 2689 contains no stacked reassignment, so the previous proposed write before line 2689 would use an object already removed. The event-study consumer reads ./stacked_data.csv at line 2709 and derives year_treated from gvkey, asu and fyear before joining the determinants sample by gvkey. A conditional save of the existing stacked object immediately before the first reset is supported; output row order, timing keys and repeated consumers still require validation.
- ISSUE-R-PACKAGE-CLOSURE [unresolved; full_pipeline]: The R runtime is registered, but availability of the 17 library dependencies called by the core and appendix source has not been verified.
- REQ-CRSP-MONTHLY [undetermined]: Monthly security returns, market returns, price/bid-ask and trading volume used for annual firm exposures and liquidity measures. The author CSV alias also needs PERMNO and names_date linkage; local field aliases and the full consumed period have not been proved.
- REQ-COMPUSTAT-ANNUAL [undetermined]: Annual fundamentals used for accounting controls, derivatives classifications, lagged denominators, issuance, and firm-year identifiers. The author export additionally expects historical PERMNO/link and firm-name fields; a raw fundamentals table alone is not proven equivalent.
- REQ-COMPUSTAT-QUARTERLY [undetermined]: Quarterly fundamentals used to calculate annual earnings and cash-flow volatility after fiscal-year lag stacking.
- REQ-FOREIGN-SEGMENTS [undetermined]: Foreign-sales control is constructed from annual segment revenue, report date and segment name, retaining the United States row to infer foreign sales.
- REQ-MACRO-PPI [undetermined]: Monthly Producer Price Index level mapped to the author macro_us comm series and converted to a lagged monthly percentage change; exact PPI series and scale are unspecified.
- REQ-MACRO-TRADE-WEIGHTED-USD [undetermined]: Federal Reserve trade-weighted U.S. dollar index mapped to fx in the monthly macro panel and converted to a lagged percentage change; exact broad/major/emerging index definition is unspecified.
- REQ-MACRO-LIBOR [undetermined]: Monthly LIBOR series mapped to libor in the macro panel and converted to a lagged percentage change; the code and datasheet do not state the tenor.
- REQ-CRSP-DAILY [undetermined]: Daily CRSP security and market returns used to compute annualized return, total risk and market-model residual risk.
- REQ-IBES-SUMMARY [undetermined]: USD IBES analyst summary observations matched by IBES ticker and period end, using actual EPS, mean estimate, dispersion, analyst count and security identifiers.
- REQ-IBES-CRSP-LINK [undetermined]: Historical IBES ticker to CRSP PERMNO links with score and start/end dates; ticker uniqueness after score filtering drives firm-year joins.
- REQ-OVERALL-INDUSTRY-EXPOSURE-PANEL [undetermined]: A prior overall_sample panel restores ind_libor, ind_comm, ind_fx, ind_earnings_vol, ind_cashflow_vol and ind_firm_risk by GVKEY/date to preserve older sample exposure values after revisions.
- REQ-ASU-ADOPTION-DATES [undetermined]: Hand-collected early-adoption observations joined by GVKEY and used to assign y17/y18 adoption timing for firm-year observations.
- REQ-HEDGE-USE-PANEL [undetermined]: Hand-collected overall hedge-use observations joined by GVKEY/date and used for treatment, ASU adoption and hedge-accounting-use outcomes and scaling.
- REQ-UNMATCHED-SAMPLE1 [undetermined]: The downstream file ./unmatched_sample1.csv is explicitly identified in the source comment as corresponding to the in-memory main_sample object, which is built from descriptive_items1 joined with handcollected and cleaned. A save-before-reset source fix is supported; exact downstream column names, types and row keys still need validation.
- REQ-SIC2-CROSSWALK [undetermined]: Two-digit SIC category mapping used to report descriptive treatment/control counts by industry category.
- REQ-UNMATCHED-SAMPLE-WITH-LAGS [undetermined]: Prepared Table 3 panel consumed with quarterly derivatives; requires firm/fiscal-year keys, lagged assets and the scaled exposures/controls used by the determinant regressions.
- REQ-QUARTERLY-DERIVATIVE-VALUES [undetermined]: Quarterly Compustat derivative-use values needed for average and volatility measures, joined by GVKEY and fiscal year to the lagged analysis panel.
- REQ-DEBT-ISSUANCE-PANEL [undetermined]: Prepared debt-issuance crosswalk consumed by later regressions using GVKEY/date/debt_issuance. The supplied code defines the annual debt-change measure from DLTT, DLC and lagged assets but does not write this separate file.
- REQ-DETERMINANTS-SAMPLE [undetermined]: Prepared firm-date analysis sample used across determinants, UGL, hedge-type, instrument, currency, commodity, risk-subset and event-study branches; exact required fields are inherited from the regression covariate/outcome formulas.
- REQ-HEDGE-TYPE-PANEL [undetermined]: Hand-collected designated hedge-type panel joined to the determinants sample, with derivative, fair-value hedge, cash-flow hedge, non-designated hedge and adoption classifications.
- REQ-UGL-MANUAL-VALUES [undetermined]: Annual-report UGL values for fair-value, cash-flow and non-designated hedges, keyed by firm/date and scaled by Compustat assets.
- REQ-INSTRUMENT-RISK-CLASSIFICATION [undetermined]: Hand-collected instrument and hedged-risk classifications used for counts and instrument-type outcomes.
- REQ-NEW-USER-LIST [undetermined]: Firm identifier list used to select the new-user treatment panel; GVKEY is augmented to a new_user flag in the R source.
- REQ-CURRENCY-HEDGING-CLASSIFICATION [undetermined]: Hand-collected hedged-currency counts and indicators used for currency-specific subsample analyses.
- REQ-INDUSTRY-WISE-SPLIT-READ [undetermined]: The supplied program actively reads industry_wise_split.csv but its imported object is not used downstream. The file remains required by the unmodified full script unless its unused read is explicitly removed.
- REQ-COMMODITY-HEDGING-CLASSIFICATION [undetermined]: Hand-collected commodity counts and class indicators used for the commodity hedging analyses.
- REQ-COMMODITY-RISK-SUBSAMPLE [undetermined]: Commodity-risk specific sample with designated-use scaling and the shared firm-year outcome/control panel for risk-focused regressions.
- REQ-FX-RISK-SUBSAMPLE [undetermined]: Foreign-exchange risk specific sample with designated-use scaling and the shared firm-year outcome/control panel for risk-focused regressions.
- REQ-LIBOR-RISK-SUBSAMPLE [undetermined]: Interest-rate risk specific sample with designated-use scaling and the shared firm-year outcome/control panel for risk-focused regressions.
- REQ-OVERALL-LONGER-PANEL [undetermined]: October 2023 longer firm panel used to construct one-period-ahead exposure, debt and investment outcomes; input also requires accounting and precomputed exposure variables.
- SOFT-R-PACKAGES [unverified]: The source loads tidyverse, janitor, lubridate, caTools, stargazer, DescTools, lmtest, broom, lfe, Hmisc, data.table, fixest, ebal, MatchIt, Matching, cobalt and glm2. Package availability was not checked.

## Review notes

- Cumulative source/dependency checkpoint: all 33 frozen read IDs have explicit requirement, generated, optional or issue dispositions tied to source evidence.
- Candidate local product leaves are recorded as catalog evidence only. No local raw product is credited as compatible without full consumed-field, identifier, and period proof.
- Author-created derivative-type, cleaned hedge-use, and replacement-matched panels have in-source writers before consumers. The commented exposure writer is a conditional preparation step.
- The source identifies main_sample as the object corresponding to unmatched_sample1.csv, with a conditional save before reset 441. The stacked cohort is constructed at 2574 and must be saved before the first reset at 2631; the later 2689 reset precedes the 2709 CSV consumer. Remaining prepared panels and downstream schema/key checks stay separate.
- The CIK file is an identifier aid only. Public EDGAR search confirms access to filings, not completeness of the proprietary hand-collected observations.
- The registered R runtime is retained under the exact proof key R; add-on package availability is unverified. The failed COMP.FUNDA all-fields request, R package metadata attempt, first metadata-preflight attempt and an early draft-helper NameError are preserved as process-only and do not support package findings.
- The second metadata preflight found three literal source quote mismatches; these were corrected from safe bounded source views, and the diagnostic remains process-only.
- The source explicitly maps main_sample to unmatched_sample1.csv, supporting a conditional save-before-reset edit; distinct historical panels remain unresolved. The stacked cohort object is also present in source and has a conditional persistence edit, pending downstream timing-key and row-order validation.
