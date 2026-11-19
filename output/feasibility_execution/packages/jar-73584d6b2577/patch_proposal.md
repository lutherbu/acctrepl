# Patch proposal: jar-73584d6b2577

Does A Government Mandate Crowd Out Voluntary Corporate Social Responsibility? Evidence from India

DOI: 10.1111/1475-679X.12461

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |
| analysis_only | local_available | preparation_required |

### full_pipeline

Complete supplied workflow: Prowess/MCA data creation and Tables.do, plus the distinct climate-control and event-study branches. Several supplied inputs and generated intermediates are supported, while raw-header/history, climate firm-year, event-source mapping, and event-date coverage questions remain.

Entry points: `do/data_creation.do`, `do/Tables.do`, `special_test/Climate Measures/climate_control.do`, `special_test/Event Study/GetTreatment.do`, `special_test/Event Study/EventStudyCode.do`, `special_test/Event Study/NewNovCode.do`

Dependency closure: unresolved; see the issues and actions below.

### analysis_only

Tables.do using the supplied author-prepared panel and its supplied auxiliary inputs. This route bypasses Prowess/MCA reconstruction and excludes the separate climate and event-study branches.

Entry points: `do/Tables.do`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 1/12461 - Does-A-Government-Mandate-Crowd-Out-Voluntary-Corporate-Social-Responsibility-Evidence-from-India/RT datasheet and code.zip",
      "sha256": "30e4ccd781fb1d99037b61260b0471650ae88531e4e657ce2c8723adf041607b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "941c035d127c6d8e917d89c07f39171a2417825bba74ed8c9cdce33c2826edf6",
  "work_item_sha256": "c5ca54b50e49d8f66cd86a6037d025a8d5b089c2e61c3628babb4ad28035d94b"
}
```

## Proposed actions

### ACT_PROJECT_ROOT: Set one coherent working directory and resolve the package-relative paths used by the selected program sequence.

Scopes: full_pipeline, analysis_only. Type: configuration. Certainty: supported.
Addresses: ISS_PROJECT_ROOT
Evidence: E_README_DATA_CREATION, E_README_TABLES, E_TABLES_PANEL_INPUT, E_TABLES_TWITTER_IMPORT

Preparation / proposed procedure:

1. For the documented full sequence, start data_creation.do and then Tables.do from a working copy whose raw/, dta/, and tables/ directories resolve as shown in the source.
2. For analysis_only, start Tables.do from the package working root with the supplied prepared panel and auxiliary inputs at their referenced locations.

Validation to perform later:

- Confirm the selected entry point resolves its first required input and output directory before any authorized run.

### ACT_MAIN_RECONSTRUCTION: Resolve the supplied raw input contracts and required firm/year history before full Prowess/MCA reconstruction.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_PROWESS_CSR, REQ_PROWESS_IDENTITY, REQ_MCA_CSR, ISS_PROWESS_IMPORT_CONTRACT, ISS_MAIN_HISTORY
Evidence: E_DATA_PROWESS_IMPORT, E_DATA_PROWESS_DROP, E_DATA_IDENTITY_IMPORT, E_DATA_MCA_IMPORT, E_DATA_MCA_RENAME, E_DATA_LAG_CONSTRUCTION, E_DATA_YEAR_FILTER, E_GETTREATMENT_YEAR_WINDOW, E_TEXT_INPUT_HEADERS, E_MCA_PROBE

Preparation / proposed procedure:

1. Use the existing packaged Prowess CSR, identity, and MCA files; do not request duplicate raw deliveries solely because the full input history was not scanned.
2. Before the author drop of v53-v57, document how the imported Prowess positions map to repeated native headers under the Stata importer; do not guess renames.
3. Confirm the MCA CSV headers map to the source's CIN and CSR amount rename, then preserve the author's merge and panel construction sequence.
4. Check the source periods and firm histories needed to construct prior-observation lags and the 2011-2013 GetTreatment variables.

Validation to perform later:

- Verify native input columns and Stata import names, the identity/MCA joins, generated panel fields, and required prior-year and 2011-2013 coverage.

### ACT_CLIMATE_INPUTS: Confirm use of the supplied prepared ISIN crosswalk and identify the separate climate firm-year dataset and its field contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_CLIMATE_ISIN, REQ_CLIMATE_FIRM_YEAR, ISS_CLIMATE_INPUT
Evidence: E_CLIMATE_IDENTITY_RENAME, E_CLIMATE_ISIN_MERGE, E_CLIMATE_FIRM_YEAR_MERGE, E_CLIMATE_FIELD_BASE, E_CLIMATE_FIELD_OP, E_CLIMATE_FIELD_RG, E_CLIMATE_FIELD_PH, E_CLIMATE_ISIN_PROBE, E_WORK_ITEM_INVENTORY

Preparation / proposed procedure:

1. Ask the package maintainer to confirm the working-copy load step that uses special_test/Climate Measures/isin.dta at the climate merge location while avoiding reliance on an unprovided raw crosswalk.
2. Obtain the actual separate climate firm-year input or its documented source, identifier/date contract, and all base/op_cc/rg_cc/ph_cc measures; no compatible file is in this package inventory.

Validation to perform later:

- Confirm the crosswalk fields match the Prowess-code/ISIN join and the climate source matches ISIN/year plus every consumed climate measure.

### ACT_EVENT_INPUTS_AND_HANDOFFS: Preserve the independent EventStudyCode, GetTreatment, and NewNov branches and validate their supplied-input and generated-output handoffs in a working copy.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: REQ_EVENT1B, REQ_EVENT1_RAW, REQ_EVENT2_RAW, REQ_EVENT3_RAW, REQ_EVENT1_NEW_RAW, REQ_EVENT_ALLFIRM_RAW, REQ_EVENT_TREATMENT2_RAW, REQ_MARKET_EVENT1, REQ_MARKET_EVENT1B, REQ_MARKET_EVENT2, REQ_MARKET_EVENT3, REQ_EVENT_TREATMENT, REQ_EVENT_INDUSTRY_NIC, REQ_MURLI_2019, REQ_MURLI_2013, ISS_EVENT_SOURCE_MAPPING, ISS_EVENT_DATE_COVERAGE
Evidence: E_EVENT_AUG29_WRITE, E_EVENT_AUG08_MERGE, E_GETTREATMENT_YEAR_WINDOW, E_GETTREATMENT_CODE_KEY, E_EVENT_11_OBSERVATION_RULE, E_EVENT1B_11_OBSERVATION_RULE, E_EVENT1NEW_TRADE_FILTER, E_NEWNOV_EVENT2_LABEL, E_NEWNOV_EVENT3_LABEL, E_WORK_ITEM_INVENTORY, E_TEXT_INPUT_HEADERS, E_EVENT1B_PROBE, E_TREATMENT2RAW_PROBE, E_MARKET_EVENT1_PROBE, E_MARKET_EVENT1B_PROBE, E_MARKET_EVENT2_PROBE, E_MARKET_EVENT3_PROBE, E_EVENT_TREATMENT_PROBE, E_INDUSTRY_NIC_PROBE, E_MURLI_2019_PROBE, E_MURLI_2013_PROBE

Preparation / proposed procedure:

1. Keep Event1_B, each event text file, market series, treatment, industry, and Murli inputs as separate products; route each only to the matching event block.
2. Resolve the GetTreatment input identity from the author-visible path before treating it as the generated main panel; retain the separate 2011-2013 treatment construction.
3. Keep the Aug29 and AllFirmData outputs, and Treatment_1/Treatment_2 producer-to-consumer order, aligned within the event working directories.
4. Check co_stkdate storage, market merge coverage, required eleven-observation windows, and the Event1_new traded-day filter for each branch.

Validation to perform later:

- Confirm every branch opens its intended supplied or generated input, its date/identifier keys match the corresponding market/treatment file, and each documented window condition is met.

### ACT_STATA_ADDONS: Make the two called Stata add-ons available in the selected ado path before an authorized run.

Scopes: full_pipeline, analysis_only. Type: software_setup. Certainty: supported.
Addresses: SW_OUTREG2, SW_WINSOR2, ISS_ADDONS
Evidence: E_TABLES_WINSOR, E_TABLES_OUTREG, E_ENV_SOFTWARE

Preparation / proposed procedure:

1. Review and add the required outreg2 and winsor2 ado packages to the Stata environment used for this package.
2. Do not replace the required commands or change the study's analysis while preparing the runtime.

Validation to perform later:

- Use Stata's command lookup to confirm both exact entry points resolve in the active ado path.


## Remaining issues and prerequisites

- ISS_PROJECT_ROOT [preparation; full_pipeline, analysis_only]: The visible Tables.do inputs and outputs use project-relative raw/, dta/, and tables/ paths. Set a consistent working directory for the chosen branch and keep these paths resolvable in a working copy.
- ISS_PROWESS_IMPORT_CONTRACT [unresolved; full_pipeline]: The Prowess CSR source has repeated native header names, and data_creation.do drops importer fields v53-v57 immediately after import. Confirm the imported position-to-header mapping under the required Stata importer before using this raw-construction route; do not infer that a field is absent or rename columns from their visible labels.
- ISS_MAIN_HISTORY [unresolved; full_pipeline]: Full reconstruction builds prior-observation lags before retaining year>=2010, while GetTreatment uses 2011-2013. Existing bounded metadata does not establish the required firm/year history for those constructions. This is a full-reconstruction history question; it does not erase the available prepared Tables inputs in analysis_only.
- ISS_CLIMATE_INPUT [unresolved; full_pipeline]: The climate branch requires a firm-year input joined on ISIN/year and uses the base and op_cc/rg_cc/ph_cc measure families. The assigned package inventory contains no compatible climate firm-year source; the prepared ISIN crosswalk is a separate local input and does not replace this dataset.
- ISS_EVENT_SOURCE_MAPPING [unresolved; full_pipeline]: GetTreatment has a distinct 2011-2013 company-code construction stage, but the approved current view does not establish its exact input file identity. Do not assume that a similarly shaped prepared panel is the same producer; resolve the source-to-generated-panel mapping before closing the event branch.
- ISS_EVENT_DATE_COVERAGE [unresolved; full_pipeline]: Event branches require eleven-observation windows and Event1_new also filters on traded-day coverage. Header and first-record metadata do not establish date storage, full event dates, market matches, or firm coverage for those conditions.
- ISS_ADDONS [preparation; full_pipeline, analysis_only]: Stata, reghdfe, and ftools are available, but the supplied commands also call outreg2 and winsor2, which were not found in the checked ado paths.
- REQ_PROWESS_CSR [undetermined]: Raw Prowess CSR/financial firm-year source for full data construction; duplicate header names and the source's v53-v57 drop leave the Stata import-name/column mapping unresolved.
- REQ_PROWESS_IDENTITY [undetermined]: Prowess company-code/CIN and industry identity crosswalk used to create the main panel.
- REQ_CLIMATE_FIRM_YEAR [undetermined]: Separate climate firm-year input joined by ISIN/year, with the base cc_expo/cc_risk/cc_pos/cc_neg/cc_senti variables and their op_cc, rg_cc, and ph_cc families. No compatible source appears in the assigned package inventory.
- REQ_EVENT1_RAW [undetermined]: Supplied pipe-delimited Event1 firm/date source shared by the event programs.
- REQ_EVENT2_RAW [undetermined]: Supplied pipe-delimited Event2 firm/date observations used in the 2019 event branch.
- REQ_EVENT3_RAW [undetermined]: Separate supplied pipe-delimited Event3 firm/date observations used in its own event branch.
- REQ_EVENT1_NEW_RAW [undetermined]: Separate Event1_new firm/date source used in the 2013 event branch.
- REQ_EVENT_ALLFIRM_RAW [undetermined]: Packaged firm-account text source transformed to AllFirmData.dta for the final event branch.
- SW_OUTREG2 [preparation_required]: The supplied analysis and auxiliary programs call outreg2; the registered checked ado paths do not contain it.
- SW_WINSOR2 [preparation_required]: Tables.do calls winsor2; the registered checked ado paths do not contain it.

## Review notes

- The analysis_only route has current field-level native proof for all nine Tables inputs. The main panel's meanprofit reference is covered by the native meanprofits field; the leading blank Twitter header is imported as v1 and dropped. Neither naming distinction is treated as a missing field.
- The text header projections and one-row package probes establish bounded input readability only. They do not establish full population, historical coverage, date matching, or successful author execution.
- Full Prowess reconstruction and the climate and event branches remain separate from the Tables-only route. In particular, the climate firm-year source and GetTreatment source identity remain unresolved.
- Tables.do generates twitter_treatment.dta, treatment_A10.dta, and stk.dta before their visible consumer commands; none is requested as an extra raw delivery.
- No author program, regression, data reconstruction, or result reproduction was run in this assessment.
