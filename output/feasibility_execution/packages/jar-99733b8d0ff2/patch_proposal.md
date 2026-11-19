# Patch proposal: jar-99733b8d0ff2

Amendment Thresholds and Voting Rules in Debt Contracts

DOI: 10.1111/1475-679X.70011

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied data-preparation and regression workflow.

Entry points: `merge_JAR_2025.do`, `Regression_JAR_2025.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 64/Issue 1/70011 - Amendment-Thresholds-and-Voting-Rules-in-Debt-Contracts/chs-2026-datasheet-code-identifiers-and-log-file.zip",
      "sha256": "018493878e0eebbeb6a978f92b81de7af20eca0147ff920c53570736a641f05b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "feb4c6255f02db48be89c90a4e0adef8af320dfb0c5003af52b3a740f326b30f"
}
```

## Proposed actions

### A_STAGE_DEALSCAN: Stage the four readable local DealScan products with their supported native fields and the code's existing joins, role filters, and allocation operations.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_DEALSCAN_FACILITY, R_DEALSCAN_PACKAGE, R_DEALSCAN_LENDERSHARES, R_DEALSCAN_PRICING
Evidence: E_PROBE_DS_FACILITY, E_PROBE_DS_PACKAGE, E_PROBE_DS_LENDERSHARES, E_PROBE_DS_CURRFACPRICING, E_MATRIX, E_SRC_DS_FAC_FILTER, E_SRC_DS_PACKAGE_FIELDS, E_SRC_DS_LENDER_SHARE, E_SRC_DS_PRICING_FIELDS

Preparation / proposed procedure:

1. Import each native product into the working copy while retaining its native identifiers and required columns.
2. Map the native field case/format into the supplied Stata variable references and keep the Facility, Package, LenderShares, and CurrFacPricing tables as separate sources.
3. Apply the code's authored facility/package merges, USA and 1995+ sample filters, lender-role definitions, lender-share aggregation, and pricing deduplication in their supplied order.

Validation to perform later:

- Confirm the staged fields and FacilityID/PackageID/CompanyID mappings match the source contracts.
- During the future full run, validate ordinary sample-year and join coverage for the authored USA/1995+ sample and 36-month reputation construction without imposing new endpoints.
- Confirm each product is staged through its own source edge and that the authored output variables retain their units and labels.

### A_EXTRA_FACILITY_LINK: Identify the separate facility/borrower match input used after the Facility read.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_EXTRA_FACILITY_LINK
Evidence: E_SRC_EXTRA_FAC_LINK, E_SRC_EXTRA_FAC_MATCH, E_PATH_GROUPS, E_MATRIX

Preparation / proposed procedure:

1. Obtain the P0004 input's product, population purpose, exact field list, identifier types, and the author-prepared file or documented producer.
2. Keep this table distinct from the Facility product until the author source relationship is established.

Validation to perform later:

- Confirm facilityid and borrowercompanyid types/key coverage and the supplied m:1 match after staging.

### A_COMPUSTAT_PANEL: Resolve the prepared quarterly Compustat input's field ownership and component assembly.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COMPUSTAT_EXTRACT
Evidence: E_SRC_COMP_FIELDS, E_SRC_COMP_QUARTER, E_SRC_COMP_JOIN, E_PROBE_COMP_FUNDQ, E_MATRIX

Preparation / proposed procedure:

1. Obtain the author-prepared quarterly file and its schema, or the supplied construction steps that assemble ni/at and sic with the quarterly fundamentals.
2. Keep quarterly atq/niq and the other quarterly fields on their documented quarterly contract; do not substitute annual FUNDA values for them.
3. Confirm how gvkey, datadate, sic, cik, and cusip enter the prepared panel before deriving yq and the facility merge.

Validation to perform later:

- Validate the input's required columns against the source list, then confirm the existing gvkey/yq merge after author preparation.
- During a future full run, check actual consumed sample-period coverage under the authored datadate>=1994 filter.

### A_NUM_LENDER: Obtain the prepared facility-level lender count and its source definition.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_NUM_LENDER
Evidence: E_SRC_NUM_LENDER, E_MATRIX, E_WORKITEM

Preparation / proposed procedure:

1. Request num_lender.dta or its author-documented producer, including the facility key, count unit, and any filtering or lender-correction rules.
2. Keep the separate count contract until the author supplies its construction; the readable lender-share source does not specify that prepared count by itself.

Validation to perform later:

- Check facilityid and num_lender fields and apply the supplied one-to-one merge and the authored minimum-two-lender filter.

### A_COVENANT_COUNTS: Resolve the prepared facility-level covenant count table and the definitions used by the analysis.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_FINANCIAL_COVENANT_COUNTS
Evidence: E_SRC_COV_JOIN, E_SRC_COV_FIELDS, E_MATRIX

Preparation / proposed procedure:

1. Request the prepared facility-level count input or its author-supplied producer and definitions for financialcovenant_count, tightcov_count, num_incomecov, and num_bscov.
2. Clarify how the package-level raw covenant candidate maps to the facility-level counts if it is part of the author's documented construction.

Validation to perform later:

- Verify the facility key, count definitions, and all four consumed fields before applying the one-to-one merge.

### A_MONTHLY_RATING: Obtain the issuer-quality table with the code's monthly gvkey/ym/spcsrc contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_MONTHLY_RATING
Evidence: E_SRC_MONTHLY_RATING_KEY, E_SRC_MONTHLY_RATING_JOIN, E_SRC_MONTHLY_RATING_USE, E_MATRIX

Preparation / proposed procedure:

1. Request the actual monthly prepared input or its documented construction, including the gvkey and ym key and the historical spcsrc meaning.
2. Keep current COMP.COMPANY ranking separate from the monthly rating input.

Validation to perform later:

- Confirm the monthly key and rating fields and future merge coverage for the facility year-months retained by the code.

### A_ADSPRATE: Stage the compatible annual S&P rating component from local COMP.ADSPRATE.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_ANNUAL_SPRATING
Evidence: E_PROBE_COMP_ADSPRATE, E_MATRIX, E_SRC_ANNUAL_RATING_JOIN, E_SRC_ANNUAL_RATING_USE

Preparation / proposed procedure:

1. Stage gvkey, datadate, and splticrm from the readable ADSPRATE product into the annual issuer input.
2. Map datadate to calendar year for the supplied gvkey-year merge, preserving splticrm and its issuer-rating meaning.

Validation to perform later:

- Confirm the existing m:1 gvkey-year merge for the prepared input and ordinary coverage of the facility years used; request a within-year rule only if a real duplicate-key condition remains after the source's existing preparation.

### A_BASU_COEFFICIENT: Identify the source and calculation that produce _b_loss_return for the annual issuer input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_BASU_COEFFICIENT
Evidence: E_SRC_BASU_USE, E_SRC_ANNUAL_RATING_JOIN, E_MATRIX

Preparation / proposed procedure:

1. Request the author-prepared coefficient field or its exact producer, including its measure definition, issuer/year keys, and merge into the annual issuer input.
2. Keep the rating component and coefficient component distinct until the supplied producer establishes their relationship.

Validation to perform later:

- Verify the coefficient's source fields and gvkey/year coverage before applying the authored high_conserve and winsorization operations.

### A_UNDERWRITING_TABLES: Identify the four separately consumed underwriting tables and their schemas.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_LEAD_UNDERWRITING, R_NONLEAD_UNDERWRITING, R_NONLENDER_UNDERWRITING, R_UNDERWRITER_ALLOCATION
Evidence: E_SRC_LEAD_UW_JOIN, E_SRC_LEAD_UW_USE, E_SRC_NONLEAD_UW_JOIN, E_SRC_NONLEAD_UW_USE, E_SRC_NONLENDER_UW_JOIN, E_SRC_NONLENDER_UW_USE, E_SRC_UW_ALLOCATION_JOIN, E_SRC_UW_ALLOCATION_FIELDS, E_PATH_GROUPS, E_MATRIX

Preparation / proposed procedure:

1. For P0016 through P0019, obtain each author-prepared file or its producer separately.
2. Confirm facilityid joins, lead/nonlead/nonlender definitions, required equity/bond/IPO-lender fields, and the allocation fields and percentage units.

Validation to perform later:

- Validate each table's own facility key and field contract before its one-to-one merge; preserve the four distinct table roles.

### A_HF_TABLES: Resolve the three distinct facility-keyed hedge-fund/auxiliary inputs and map their consumed fields.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_HF_NONLEAD, R_UNNAMED_MERGE_790, R_UNNAMED_MERGE_794
Evidence: E_SRC_HF_NONLEAD_JOIN, E_SRC_HF_NONLEAD_FIELDS, E_SRC_HF_EXTRA_790, E_SRC_HF_EXTRA_794, E_SRC_HF_CONSUMERS, E_SRC_HF_HOLDING_CONSUMER, E_MATRIX, E_PATH_GROUPS

Preparation / proposed procedure:

1. Obtain the P0020 input's product and have_hf_nonlead field definition.
2. For P0021 and P0022, identify which file supplies all and which supplies total_hf_holding, together with their definitions, units, and facility key.

Validation to perform later:

- Verify each table and its actual consumed fields separately before the three facility-level merges.

### A_UW_LENDER_COUNT: Obtain the facility-level underwriting-lender count table and its counting rule.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_UNDERWRITING_LENDER_COUNT
Evidence: E_SRC_UW_COUNT_JOIN, E_SRC_UW_COUNT_FIELDS, E_PATH_GROUPS, E_MATRIX

Preparation / proposed procedure:

1. Request the P0023 prepared input or producer, defining num_underwriting_lender and its facility-level counting unit.

Validation to perform later:

- Confirm the facilityid and num_underwriting_lender fields and the input expected by the existing fraction calculation with num_lender.

### A_INPUT_CLOSURE: Resolve all remaining prepared-table and producer contracts named by their input-specific actions before treating the supplied workflow as closed.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_PREPARED_INPUTS
Evidence: E_MATRIX, E_TRACE, E_WORKITEM

Preparation / proposed procedure:

1. Collect the author-prepared inputs and source/field specifications requested by the linked requirements.
2. Keep independent facility merges separate and retain the specific Compustat frequency, covenant grain, rating period, count-definition, and hedge-fund field-mapping gaps until supported.

Validation to perform later:

- Reconcile every active source read and the missing include against the selected full_pipeline requirements, then update closure only when each branch has a compatible route or a supplied producer.

### A_PATH_CONFIGURATION: Prepare a portable working copy with a consistent project root, staged input locations, and required relative output directories.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_PATH_CONFIGURATION
Evidence: E_SRC_ACTIVE_CD, E_SRC_TEMP_SAVE, E_PATH_GROUPS, E_TRACE

Preparation / proposed procedure:

1. Copy the two supplied programs into a working copy and set the intended working directory there.
2. Configure every active input reference coherently to the staged products and author-prepared tables, keeping the original package unchanged.
3. Create temp/ in the working copy before running the preparation program.

Validation to perform later:

- Review each active read and write in the working copy for consistent locations and verify temp/ exists before the first preparation run.

### A_CORRECT_LENDER: Obtain the missing lender-correction include or a complete author-provided mapping specification.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_CORRECT_LENDER
Evidence: E_MISSING_CODE, E_WORKITEM, E_TRACE

Preparation / proposed procedure:

1. Request correct_lender.do with any referenced mapping inputs, or a complete mapping specification that identifies its input fields and corrected lender identifiers.
2. Keep all call sites in the preparation workflow in their supplied order.

Validation to perform later:

- Review the supplied include for its field/key contract and referenced inputs before the full merge program is attempted.

### A_SETUP_WINSOR2: Make the required winsor2 Stata command available in the Stata environment used for the full workflow.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_WINSOR2
Evidence: E_ENV, E_WINSOR2

Preparation / proposed procedure:

1. Set up winsor2 through an authorized Stata ado source in the selected Stata environment.
2. Record the available command version and location after setup.

Validation to perform later:

- Run which winsor2 and confirm Stata resolves the command before running the merge program.

### A_SETUP_OUTREG2: Make the required outreg2 Stata command available in the Stata environment used for the regression entry point.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_OUTREG2
Evidence: E_ENV, E_OUTREG2

Preparation / proposed procedure:

1. Set up outreg2 through an authorized Stata ado source in the selected Stata environment.
2. Record the available command version and location after setup.

Validation to perform later:

- Run which outreg2 and confirm Stata resolves the command before running the regression program.

### A_RUN_SEQUENCE: Run the supplied workflow in producer order after its data, include, path, and software prerequisites are prepared.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_PREPARED_INPUTS, I_CORRECT_LENDER, I_PATH_CONFIGURATION, SW_WINSOR2, SW_OUTREG2
Evidence: E_TRACE, E_PRODUCER, E_CONSUMER, E_SRC_LOAN_SAMPLE_PRODUCER, E_SRC_RENEG_PRODUCER, E_SRC_TEMP_FACILITY_YM_PRODUCER, E_SRC_TEMP_LEAD_PRODUCER, E_SRC_TEMP_PAIR_PRODUCER, E_SRC_COMBINED_REP_PRODUCER, E_SRC_MERGE_SAMPLE_PRODUCER, E_SRC_MERGE_SAMPLE_CONSUMER

Preparation / proposed procedure:

1. Run merge_JAR_2025.do first in the configured working copy; retain its loan_sample.dta and renegotiation_percent_new.dta outputs and all later supplied preparation stages.
2. Preserve the ordered reputation chain: temp/facility_ym.dta, temp/insample_leadlender.dta and temp/insample_lead_nonleadpair.dta, temp/set_insample_leadloans.dta, temp/reputation.dta and temp/insample_lead_past36total.dta, then combined_reputation.dta.
3. Continue through the underwriting, covenant, Compustat, rating, hedge-fund, and other facility inputs; retain merge_sample.dta and the supplied lead_mktshare_facility.dta output.
4. After the merge program saves regression_sample.dta, run Regression_JAR_2025.do from the same configured working directory.

Validation to perform later:

- Confirm each documented producer completes before its consumer, including merge_sample.dta before line 781 and regression_sample.dta before the regression entry read.
- Confirm the final dataset contains the variables referenced by the regression code and that outreg2 writes the authored table target.
- Record software and data versions/coverage from the future run without treating this static assessment as execution verification.


## Remaining issues and prerequisites

- I_CORRECT_LENDER [unresolved; full_pipeline]: The supplied merge program calls correct_lender.do at several preparation stages, but that file is absent from the assigned package inventory; the lender-correction mapping is therefore not reproducible from this package.
- I_PREPARED_INPUTS [unresolved; full_pipeline]: The full pipeline also consumes separate prepared inputs whose producer, product, or schema is not supplied: an extra facility/borrower match table, the Compustat panel assembly, lender/covenant counts, monthly rating, conservatism coefficient, underwriting tables, and hedge-fund/underwriter auxiliary tables.
- I_PATH_CONFIGURATION [preparation; full_pipeline]: The merge program starts with an active author-root working-directory change and reads several absolute inputs; it also writes relative temp outputs. A portable working copy needs a coherent input/output layout and a temp directory before the preparation stage runs.
- R_EXTRA_FACILITY_LINK [undetermined]: A second, distinct facilityid/borrowercompanyid table is inner-joined into the Facility sample. Its product, role, and remaining schema are not supplied.
- R_COMPUSTAT_EXTRACT [undetermined]: Author-prepared quarterly Compustat input used to construct issuer controls and joined by quarterly gvkey/yq.
- R_NUM_LENDER [undetermined]: Prepared facility-level num_lender input used for sample inclusion, lender-share denominators, and the underwriting-lender fraction.
- R_FINANCIAL_COVENANT_COUNTS [undetermined]: Prepared facility-level count table consumed for total/tight covenant, income-covenant, and business-standard-covenant measures.
- R_MONTHLY_RATING [undetermined]: Monthly issuer spcsrc table joined to facilities by gvkey and calendar year-month.
- R_BASU_COEFFICIENT [undetermined]: Separate annual _b_loss_return measure consumed with the issuer rating input; its producer and measure definition are not supplied.
- R_LEAD_UNDERWRITING [undetermined]: Separate facility-level lead underwriting relationship table; the match creates lead-relationship presence and the source contributes num_equity_deal, num_bond_deal, and have_ipo_lender.
- R_NONLEAD_UNDERWRITING [undetermined]: Separate facility-level nonlead underwriting relationship table; the code derives presence from the match.
- R_NONLENDER_UNDERWRITING [undetermined]: Separate facility-level nonlender-underwriter event table; the code derives presence and preserves it separately from lender-underwriter relations.
- R_UNDERWRITER_ALLOCATION [undetermined]: Separate facility-level underwriter allocation table with total, lead, and nonlead allocation values; the script converts percentages to proportions.
- R_HF_NONLEAD [undetermined]: Facility-level hedge-fund nonlead input with its have_hf_nonlead flag; the supplied code fills missing flags with zero.
- R_UNNAMED_MERGE_790 [undetermined]: Additional independently merged facility-keyed input. Its product and fields beyond facilityid are unknown; later code consumes all and total_hf_holding but does not map either field to this file.
- R_UNNAMED_MERGE_794 [undetermined]: A second, distinct facility-keyed input. Its product and fields beyond facilityid are unknown; the assignment of all and total_hf_holding across this and the line-790 input is not supplied.
- R_UNDERWRITING_LENDER_COUNT [undetermined]: Facility-level number of underwriting lenders used to construct frac_underwriting_lender with the separate num_lender input.
- SW_WINSOR2 [preparation_required]: The required Stata command is not available in the original registered environment probe.
- SW_OUTREG2 [preparation_required]: The required Stata command is not available in the original registered environment probe.

## Review notes

- The target is the complete supplied merge and regression workflow. No analysis_only route is supported because regression_sample.dta is produced by the merge program and is absent from the package inventory.
- The datasheet title matches the frozen package title in substance; its workflow documentation names WRDS and merge_JAR_2025.do. Frozen title and DOI metadata remain unchanged.
- The local DealScan Facility, Package, LenderShares, and CurrFacPricing products are positively verified for their required raw products, fields, identifiers, and meanings using direct readable probes. Remaining import, formatting, merge, and ordinary sample-coverage checks are preparation steps.
- The quarterly Compustat contract remains unresolved at ni/at/sic ownership and panel assembly. FUNDQ is quarterly; FUNDA supplies annual ni/at and COMPANY has sic. The assessment does not switch frequency or infer an unprovided join.
- ADSPRATE is credited for the issuer-rating field with datadate mapped to calendar year. The distinct _b_loss_return producer, monthly spcsrc input, facility counts, underwriting tables, hedge-fund field ownership, and separate facility link remain specific prepared-input questions.
- The two commented-out lending-relationship and distance blocks are excluded from the mandatory input set. The active lead-market-share preparation output is retained in the workflow trace despite having no later supplied consumer.
- A byte-first safe reader was used for source evidence; datasheet lines 10-11 remain withheld, and log_file.smcl remains opaque. Quoted author path tokens are kept out of the assessment and represented only by the line/hash path map.
- No author code, source data, regressions, model, install, download, network request, or executable startup was run. The one-row probes establish readable metadata/fields only; execution_verified remains false.
