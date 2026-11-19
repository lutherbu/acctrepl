# Patch proposal: jar-fab62a62750b

Unrecognized Expected Credit Losses and Bank Share Prices

DOI: 10.1111/1475-679X.12353

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow: SAS sample identification and CECL construction, WRDS merges, all 68 Step 2f sensitivity scripts, then Stata analyses.

Entry points: `Step1_identify_sample_banks.sas`, `Step2a_merge_data_for_ECL_estimation.sas`, `Step 2b Loan origination estimates/Step 2b-1 NIC File Import and Name Merge.sas`, `Step 2b Loan origination estimates/Step 2b-2 Top Regulatory ID by Period End.sas`, `Step 2b Loan origination estimates/Step 2b-3 HMDA Loan Origination Data.sas`, `Step2e_ECL Estimates based on Eq. (5) and Eq. (6).sas`, `Step3_merge_ecl_estimates_with_other_data.sas`, `Step 4 Table Code/CECL_Analyses.do`, `Step 2f Sensitivity Analyses/Step 2f-1 Eq. (5) 20 lags/ECL Estimation - Consumer Loans - Non-linear - 20 lags - 0.001 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-1 Eq. (5) 20 lags/ECL Estimation - Consumer Loans - Non-linear - 20 lags - 0.0025 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-1 Eq. (5) 20 lags/ECL Estimation - Consumer Loans - Non-linear - 20 lags - 0.005 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-1 Eq. (5) 20 lags/ECL Estimation - Consumer Loans - Non-linear - 20 lags - 0.0075 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-1 Eq. (5) 20 lags/ECL Estimation - Non-SF RE Loans - Non-linear - 20 lags - 0.001 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-1 Eq. (5) 20 lags/ECL Estimation - Non-SF RE Loans - Non-linear - 20 lags - 0.0025 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-1 Eq. (5) 20 lags/ECL Estimation - Non-SF RE Loans - Non-linear - 20 lags - 0.005 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-1 Eq. (5) 20 lags/ECL Estimation - Non-SF RE Loans - Non-linear - 20 lags - 0.0075 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-1 Eq. (5) 20 lags/ECL Estimation - Other Non-RE Loans - Non-linear - 20 lags - 0.001 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-1 Eq. (5) 20 lags/ECL Estimation - Other Non-RE Loans - Non-linear - 20 lags - 0.0025 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-1 Eq. (5) 20 lags/ECL Estimation - Other Non-RE Loans - Non-linear - 20 lags - 0.005 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-1 Eq. (5) 20 lags/ECL Estimation - Other Non-RE Loans - Non-linear - 20 lags - 0.0075 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-1 Eq. (5) 20 lags/ECL Estimation - SF Loans - Non-linear - 20 lags - 0.001 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-1 Eq. (5) 20 lags/ECL Estimation - SF Loans - Non-linear - 20 lags - 0.0025 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-1 Eq. (5) 20 lags/ECL Estimation - SF Loans - Non-linear - 20 lags - 0.005 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-1 Eq. (5) 20 lags/ECL Estimation - SF Loans - Non-linear - 20 lags - 0.0075 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-2 Eq. (5) 28 lags/ECL Estimation - Consumer Loans - Non-linear - 28 lags - 0.001 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-2 Eq. (5) 28 lags/ECL Estimation - Consumer Loans - Non-linear - 28 lags - 0.0025 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-2 Eq. (5) 28 lags/ECL Estimation - Consumer Loans - Non-linear - 28 lags - 0.005 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-2 Eq. (5) 28 lags/ECL Estimation - Consumer Loans - Non-linear - 28 lags - 0.0075 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-2 Eq. (5) 28 lags/ECL Estimation - Non-SF RE Loans - Non-linear - 28 lags - 0.001 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-2 Eq. (5) 28 lags/ECL Estimation - Non-SF RE Loans - Non-linear - 28 lags - 0.0025 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-2 Eq. (5) 28 lags/ECL Estimation - Non-SF RE Loans - Non-linear - 28 lags - 0.005 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-2 Eq. (5) 28 lags/ECL Estimation - Non-SF RE Loans - Non-linear - 28 lags - 0.0075 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-2 Eq. (5) 28 lags/ECL Estimation - Other Non-RE Loans - Non-linear - 28 lags - 0.001 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-2 Eq. (5) 28 lags/ECL Estimation - Other Non-RE Loans - Non-linear - 28 lags - 0.0025 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-2 Eq. (5) 28 lags/ECL Estimation - Other Non-RE Loans - Non-linear - 28 lags - 0.005 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-2 Eq. (5) 28 lags/ECL Estimation - Other Non-RE Loans - Non-linear - 28 lags - 0.0075 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-2 Eq. (5) 28 lags/ECL Estimation - SF Loans - Non-linear - 28 lags - 0.001 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-2 Eq. (5) 28 lags/ECL Estimation - SF Loans - Non-linear - 28 lags - 0.0025 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-2 Eq. (5) 28 lags/ECL Estimation - SF Loans - Non-linear - 28 lags - 0.005 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-2 Eq. (5) 28 lags/ECL Estimation - SF Loans - Non-linear - 28 lags - 0.0075 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-3 ECL estimate residuals 20 lags/ECL Estimate Residuals - Consumer Loans - 20 lags - 0.001 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-3 ECL estimate residuals 20 lags/ECL Estimate Residuals - Consumer Loans - 20 lags - 0.0025 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-3 ECL estimate residuals 20 lags/ECL Estimate Residuals - Consumer Loans - 20 lags - 0.005 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-3 ECL estimate residuals 20 lags/ECL Estimate Residuals - Consumer Loans - 20 lags - 0.0075 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-3 ECL estimate residuals 20 lags/ECL Estimate Residuals - Non-SF RE Loans - 20 lags - 0.001 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-3 ECL estimate residuals 20 lags/ECL Estimate Residuals - Non-SF RE Loans - 20 lags - 0.0025 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-3 ECL estimate residuals 20 lags/ECL Estimate Residuals - Non-SF RE Loans - 20 lags - 0.005 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-3 ECL estimate residuals 20 lags/ECL Estimate Residuals - Non-SF RE Loans - 20 lags - 0.0075 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-3 ECL estimate residuals 20 lags/ECL Estimate Residuals - Other Non-RE Loans - 20 lags - 0.001 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-3 ECL estimate residuals 20 lags/ECL Estimate Residuals - Other Non-RE Loans - 20 lags - 0.0025 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-3 ECL estimate residuals 20 lags/ECL Estimate Residuals - Other Non-RE Loans - 20 lags - 0.005 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-3 ECL estimate residuals 20 lags/ECL Estimate Residuals - Other Non-RE Loans - 20 lags - 0.0075 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-3 ECL estimate residuals 20 lags/ECL Estimate Residuals - SF Loans - 20 lags - 0.001 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-3 ECL estimate residuals 20 lags/ECL Estimate Residuals - SF Loans - 20 lags - 0.0025 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-3 ECL estimate residuals 20 lags/ECL Estimate Residuals - SF Loans - 20 lags - 0.005 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-3 ECL estimate residuals 20 lags/ECL Estimate Residuals - SF Loans - 20 lags - 0.0075 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-4 ECL estimate residuals 28 lags/ECL Estimate Residuals - Consumer Loans - 28 lags - 0.001 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-4 ECL estimate residuals 28 lags/ECL Estimate Residuals - Consumer Loans - 28 lags - 0.0025 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-4 ECL estimate residuals 28 lags/ECL Estimate Residuals - Consumer Loans - 28 lags - 0.005 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-4 ECL estimate residuals 28 lags/ECL Estimate Residuals - Consumer Loans - 28 lags - 0.0075 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-4 ECL estimate residuals 28 lags/ECL Estimate Residuals - Non-SF RE Loans - 28 lags - 0.001 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-4 ECL estimate residuals 28 lags/ECL Estimate Residuals - Non-SF RE Loans - 28 lags - 0.0025 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-4 ECL estimate residuals 28 lags/ECL Estimate Residuals - Non-SF RE Loans - 28 lags - 0.005 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-4 ECL estimate residuals 28 lags/ECL Estimate Residuals - Non-SF RE Loans - 28 lags - 0.0075 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-4 ECL estimate residuals 28 lags/ECL Estimate Residuals - Other Non-RE Loans - 28 lags - 0.001 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-4 ECL estimate residuals 28 lags/ECL Estimate Residuals - Other Non-RE Loans - 28 lags - 0.0025 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-4 ECL estimate residuals 28 lags/ECL Estimate Residuals - Other Non-RE Loans - 28 lags - 0.005 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-4 ECL estimate residuals 28 lags/ECL Estimate Residuals - Other Non-RE Loans - 28 lags - 0.0075 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-4 ECL estimate residuals 28 lags/ECL Estimate Residuals - SF Loans - 28 lags - 0.001 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-4 ECL estimate residuals 28 lags/ECL Estimate Residuals - SF Loans - 28 lags - 0.0025 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-4 ECL estimate residuals 28 lags/ECL Estimate Residuals - SF Loans - 28 lags - 0.005 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-4 ECL estimate residuals 28 lags/ECL Estimate Residuals - SF Loans - 28 lags - 0.0075 WRDS.sas`, `Step 2f Sensitivity Analyses/Step 2f-5 ECL Estimates - 20 Lags in Eq. (5).sas`, `Step 2f Sensitivity Analyses/Step 2f-6 ECL Estimates - 28 Lags in Eq. (5).sas`, `Step 2f Sensitivity Analyses/Step 2f-7 ECL Estimates - 2 years macro adjustment.sas`, `Step 2f Sensitivity Analyses/Step 2f-8 ECL Estimates - 3 years macro adjustment.sas`, `Step 4 Table Code/CECL_Table2_Future_Charge_Off_Tests.do`, `Step 4 Table Code/CECL_Procyclicality_Analysis.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 3/12353 - Unrecognized-Expected-Credit-Losses-and-Bank-Share-Prices/wheeler-datasheet-code-and-identifiers.zip",
      "sha256": "19a275c44909f066b0153ca6566791bce070cd32b07298a96f97023b41bf8492"
    },
    {
      "path": "JAR-Volume 59/Issue 3/12353 - Unrecognized-Expected-Credit-Losses-and-Bank-Share-Prices/wheeler-online-appendix.pdf",
      "sha256": "74717d965bcda7879ed1b4545f2230355bd28080a0a7a525a0450ed3d4fb6c7a"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "a257ea088bca727f8f8088228131f6ac1f3b836552dafe971698f13dacc231ee",
  "work_item_sha256": "af85a67fbee53dd7c442db0e0bc8e7643b45ddb94a0f5f8d05f3ed703b77cd09"
}
```

## Proposed actions

### ACT-REQ-SPGMI: Request the author’s individual SPGMI CSV exports and the MI Office M&A export, with subscription entitlement confirmed; retain SNL Key, year, quarter, RSSDID and original variable names.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: REQ-SPGMI
Evidence: EV-PACKAGED-LEGEND, EV-INVENTORY

Preparation / proposed procedure:

1. Request the author’s individual SPGMI CSV exports and the MI Office M&A export, with subscription entitlement confirmed; retain SNL Key, year, quarter, RSSDID and original variable names.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-SPGMI-MA: Confirm licensed access to the author-documented MI Office M&A export, obtain the CSV and codebook, and preserve the 2016-08-02 source vintage.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ-SPGMI-MA
Evidence: EV-DESC-SPGMI, EV-INVENTORY

Preparation / proposed procedure:

1. Confirm licensed access to the author-documented MI Office M&A export, obtain the CSV and codebook, and preserve the 2016-08-02 source vintage.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-AUTHOR-PANELS: Request the missing author-prepared all_* quarterly panels, rankdates, sample IDs, CECL intermediates and exact schemas/periods, plus producer code where those artifacts are derived.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: REQ-AUTHOR-PANELS
Evidence: EV-STEP2A, EV-STEP3-INPUTS, EV-INVENTORY

Preparation / proposed procedure:

1. Request the missing author-prepared all_* quarterly panels, rankdates, sample IDs, CECL intermediates and exact schemas/periods, plus producer code where those artifacts are derived.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-HMDA-1990-2014: Acquire the annual historic LAR files for 1990–2014 from the NARA collection and follow each supplied year-specific SAS import/filters.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ-HMDA-1990-2014
Evidence: EV-PUB-NARA, EV-HMDA-CODE

Preparation / proposed procedure:

1. Acquire the annual historic LAR files for 1990–2014 from the NARA collection and follow each supplied year-specific SAS import/filters.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-HMDA-2015-2016: Acquire annual HMDA LAR files for 2015–2016 from CFPB historic downloads and follow the author’s year-specific import/filters.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ-HMDA-2015-2016
Evidence: EV-PUB-CFPB, EV-HMDA-CODE

Preparation / proposed procedure:

1. Acquire annual HMDA LAR files for 2015–2016 from CFPB historic downloads and follow the author’s year-specific import/filters.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-HMDA-LINKS: Request the author-created 1990–2003 respondent-ID/RSSD name-location crosswalk and the exact annual panel_* files/schema for 2004–2016; identify producer scripts and keys.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: REQ-HMDA-LINKS
Evidence: EV-DESC-HMDA, EV-HMDA-CODE, EV-INVENTORY

Preparation / proposed procedure:

1. Request the author-created 1990–2003 respondent-ID/RSSD name-location crosswalk and the exact annual panel_* files/schema for 2004–2016; identify producer scripts and keys.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-NIC-2018: Locate and obtain the exact 2018-03-31 NIC XML snapshot or ask the authors for the archived source files and schema; map attributes, relationships and transformations to SAS inputs.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ-NIC-2018
Evidence: EV-PUB-NIC, EV-NIC-WRITE

Preparation / proposed procedure:

1. Locate and obtain the exact 2018-03-31 NIC XML snapshot or ask the authors for the archived source files and schema; map attributes, relationships and transformations to SAS inputs.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-NIC-2015: Ask for the provenance, file and fields for the required 2015-12-31 NIC relationships/transformations table; verify it is compatible with downstream macro reads.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: REQ-NIC-2015
Evidence: EV-PUB-NIC, EV-DESC-HMDA

Preparation / proposed procedure:

1. Ask for the provenance, file and fields for the required 2015-12-31 NIC relationships/transformations table; verify it is compatible with downstream macro reads.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-NYFED-CRSP-LINK: Obtain the NY Fed CRSP-FRB 2016:Q4 archive and compare its columns, date semantics and entity/permco mappings with the script’s requested link fields before the merge.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ-NYFED-CRSP-LINK
Evidence: EV-PUB-NYFED, EV-DESC-MACRO, EV-TOPREG

Preparation / proposed procedure:

1. Obtain the NY Fed CRSP-FRB 2016:Q4 archive and compare its columns, date semantics and entity/permco mappings with the script’s requested link fields before the merge.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-CRSP-MSF: Verify the full author-period CRSP.MSF history, required fields and access through the configured SAS-WRDS interface; if using the local catalog, confirm its version and date coverage.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ-CRSP-MSF
Evidence: EV-PROBE-CRSP-MSF, EV-DESC-SPGMI

Preparation / proposed procedure:

1. Verify the full author-period CRSP.MSF history, required fields and access through the configured SAS-WRDS interface; if using the local catalog, confirm its version and date coverage.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-CRSP-DSF: Verify full author-period CRSP.DSF history, field names and SAS-WRDS compatibility or confirm the local catalog version/date coverage.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ-CRSP-DSF
Evidence: EV-PROBE-CRSP-DSF, EV-DESC-SPGMI

Preparation / proposed procedure:

1. Verify full author-period CRSP.DSF history, field names and SAS-WRDS compatibility or confirm the local catalog version/date coverage.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-CRSP-COMP-LINK: Verify the complete CRSP/Compustat link history, validity intervals, matching conventions and the remote/local table version expected by the code.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ-CRSP-COMP-LINK
Evidence: EV-PROBE-CRSP-LINK

Preparation / proposed procedure:

1. Verify the complete CRSP/Compustat link history, validity intervals, matching conventions and the remote/local table version expected by the code.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-COMPUSTAT-FUNDQ: Confirm Compustat quarterly history and field/version compatibility through the author-period using SAS-WRDS or a documented local mirror.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ-COMPUSTAT-FUNDQ
Evidence: EV-PROBE-COMP-FUNDQ, EV-STEP3-WRDS

Preparation / proposed procedure:

1. Confirm Compustat quarterly history and field/version compatibility through the author-period using SAS-WRDS or a documented local mirror.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-FF-FACTORS: Confirm the full daily-factor period, unit conventions and local-versus-WRDS version before constructing market-adjusted returns.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ-FF-FACTORS
Evidence: EV-PROBE-FF-DAILY, EV-STEP3-WRDS

Preparation / proposed procedure:

1. Confirm the full daily-factor period, unit conventions and local-versus-WRDS version before constructing market-adjusted returns.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-IBES-STATS: Confirm I/B/E/S summary-history coverage, WRDS entitlement/version and ticker/date mapping for all forecast periods used.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ-IBES-STATS
Evidence: EV-PROBE-IBES-STATS, EV-DESC-SPGMI

Preparation / proposed procedure:

1. Confirm I/B/E/S summary-history coverage, WRDS entitlement/version and ticker/date mapping for all forecast periods used.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-IBES-ACTUALS: Confirm I/B/E/S actuals history, units, field/version compatibility and ticker/date mapping for the author period.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ-IBES-ACTUALS
Evidence: EV-PROBE-IBES-ACTUALS, EV-DESC-SPGMI

Preparation / proposed procedure:

1. Confirm I/B/E/S actuals history, units, field/version compatibility and ticker/date mapping for the author period.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-IBES-PTG: Confirm I/B/E/S price-target history, field/version compatibility and ticker/date mapping for the author period.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ-IBES-PTG
Evidence: EV-PROBE-IBES-PTG, EV-DESC-SPGMI

Preparation / proposed procedure:

1. Confirm I/B/E/S price-target history, field/version compatibility and ticker/date mapping for the author period.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-BLS: Acquire the monthly seasonally adjusted unemployment series for the analysis years and construct quarterly values using the author’s intended period aggregation.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ-BLS
Evidence: EV-PUB-BLS, EV-DESC-MACRO

Preparation / proposed procedure:

1. Acquire the monthly seasonally adjusted unemployment series for the analysis years and construct quarterly values using the author’s intended period aggregation.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-BEA: Acquire quarterly real GDP for the analysis period and construct quarterly growth; document vintage/base and map the resulting series to chgdp_quarterly.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ-BEA
Evidence: EV-PUB-BEA, EV-DESC-MACRO

Preparation / proposed procedure:

1. Acquire quarterly real GDP for the analysis period and construct quarterly growth; document vintage/base and map the resulting series to chgdp_quarterly.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-SLOOS: Identify the precise April 2017 SLOOS question/series and transformation for large-and-mid and small domestic C&I standards, then map it to the expected variables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ-SLOOS
Evidence: EV-PUB-SLOOS, EV-DESC-MACRO

Preparation / proposed procedure:

1. Identify the precise April 2017 SLOOS question/series and transformation for large-and-mid and small domestic C&I standards, then map it to the expected variables.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-REQ-CASE-SHILLER: Obtain/register for the national Case-Shiller NSA index, identify the author-period vintage, and construct quarter-to-quarter qtch_csindex as specified.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ-CASE-SHILLER
Evidence: EV-PUB-CASE, EV-DESC-MACRO

Preparation / proposed procedure:

1. Obtain/register for the national Case-Shiller NSA index, identify the author-period vintage, and construct quarter-to-quarter qtch_csindex as specified.

Validation to perform later:

- Check all expected years are present, identifiers/units match the SAS consumer, and the exact required field mapping is documented.

### ACT-SW-SAS: Resolve SAS 9.4 startup/TKELS configuration and confirm authorized runtime access before the author workflow is attempted.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-SAS
Evidence: EV-ENVIRONMENT

Preparation / proposed procedure:

1. Resolve SAS 9.4 startup/TKELS configuration and confirm authorized runtime access before the author workflow is attempted.

Validation to perform later:

- Run Stata/SAS package/runtime availability checks only after authorized setup; confirm expected command and version resolve.

### ACT-SW-WRDS: Confirm WRDS credentials, access to the remote libraries/directories and a reproducible transfer procedure for each local/remote intermediate.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-WRDS
Evidence: EV-STEP3-WRDS, EV-WRDS-TRANSFER

Preparation / proposed procedure:

1. Confirm WRDS credentials, access to the remote libraries/directories and a reproducible transfer procedure for each local/remote intermediate.

Validation to perform later:

- Run Stata/SAS package/runtime availability checks only after authorized setup; confirm expected command and version resolve.

### ACT-SW-CORSP: Install corsp through an authorized Stata package route and record its version; do not alter author analysis commands.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-CORSP
Evidence: EV-PROBE-CORSP, EV-STATA-PKGS

Preparation / proposed procedure:

1. Install corsp through an authorized Stata package route and record its version; do not alter author analysis commands.

Validation to perform later:

- Run Stata/SAS package/runtime availability checks only after authorized setup; confirm expected command and version resolve.

### ACT-SW-OUTREG2: Install outreg2 through an authorized Stata package route and record its version.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-OUTREG2
Evidence: EV-PROBE-OUTREG2, EV-STATA-REGS

Preparation / proposed procedure:

1. Install outreg2 through an authorized Stata package route and record its version.

Validation to perform later:

- Run Stata/SAS package/runtime availability checks only after authorized setup; confirm expected command and version resolve.

### ACT-SW-WINSOR2: Install winsor2 through an authorized Stata package route and record its version.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-WINSOR2
Evidence: EV-PROBE-WINSOR2, EV-STATA-WINSOR

Preparation / proposed procedure:

1. Install winsor2 through an authorized Stata package route and record its version.

Validation to perform later:

- Run Stata/SAS package/runtime availability checks only after authorized setup; confirm expected command and version resolve.

### ACT-ISS-CLOSURE: Request an author-supplied producer map for every unresolved checklist read, including macro-expanded names, remote/local context, exact source file, version/date, fields, keys and any manual transfer. Reconcile the returned map one-to-one against the frozen 9,373 IDs.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: ISS-CLOSURE
Evidence: EV-DESC-ORDER, EV-STEP2A, EV-STEP3-INPUTS, EV-STEP3-WRDS, EV-WRDS-TRANSFER, EV-INVENTORY

Preparation / proposed procedure:

1. For each unresolved dependency, obtain a cited producer, a compatible external route, or an explicitly documented optional branch; do not infer artifacts from filenames alone.

Validation to perform later:

- Re-run static dependency resolution on the documented paths/macros and confirm all 9,373 IDs are classified with zero unexplained mandatory reads.

### ACT-ISS-NIC-NAME: After the author confirms the raw relationship table is intended, align the NIC merge input to the table actually written by the preceding data step.

Scopes: full_pipeline. Type: source_edit. Certainty: conditional.
Addresses: ISS-NIC-NAME
Evidence: EV-NIC-WRITE, EV-NIC-READ, EV-NIC-NAMES

**Proposed edit:** `Step 2b Loan origination estimates/Step 2b-1 NIC File Import and Name Merge.sas:85–85`
Source SHA-256: `a5a03d7045ac8662b2924bf70dfdf08c708f61016984522e53df1e9da1f8d63c`

The preceding script writes nic.nic_relationships_20180331; no producer for nic.relationships_20180331 is shown.

Current text:
```
from nic.relationships_20180331 as a left join nic.attributes_active_20180331 as b
```

Proposed replacement:
```
from nic.nic_relationships_20180331 as a left join nic.attributes_active_20180331 as b
```

Preparation / proposed procedure:

1. Confirm which relationship vintage and fields were intended by the authors.
2. If confirmed, change only the line 85 input table reference to the existing producer output.

Validation to perform later:

- Run only the NIC preparation stage after authorization and confirm the merge reads the intended relationship table and writes relationships_names_20180331 with expected parent/offspring fields.

### ACT-ISS-TOPREG: Request the intended producer/version for box.top_regid_byperiod and explain how it differs from box.top_regid_byperiod_2017; do not infer or synthesize parent IDs.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: ISS-TOPREG
Evidence: EV-TOPREG, EV-HMDA-CODE, EV-DESC-HMDA

Preparation / proposed procedure:

1. Ask authors to provide the missing producer or confirm the exact downstream target and source mapping.

Validation to perform later:

- After clarification, verify every consumer resolves to the documented top-regulatory-ID dataset with the required dates and IDs.

### ACT-ISS-LIBNAMES: Request or define one explicit local configuration for the authors’ Box Sync library roots and user-specific folders, then map each SAS libname/input path consistently without changing dataset semantics.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: ISS-LIBNAMES
Evidence: EV-HMDA-CODE, EV-STEP2A, EV-STEP3-FINAL

Preparation / proposed procedure:

1. List each physical input/output root and map every hard-coded libname and infile path to it.

Validation to perform later:

- Statically compare all stage paths and confirm each input resolves to the intended producer output; after authorization, verify directory access.

### ACT-ISS-WRDS-TRANSFER: Ask the authors to specify the exact transfer protocol, filenames, destination paths and handoff points for ECL estimation files moved between local SAS and WRDS.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: ISS-WRDS-TRANSFER
Evidence: EV-WRDS, EV-WRDS-TRANSFER, EV-STEP3-WRDS

Preparation / proposed procedure:

1. Document each upload/download and distinguish local WORK, permanent local libraries and WRDS remote libraries.

Validation to perform later:

- Confirm every transferred artifact has a matching producer and consumer path and that the remote library is authorized and writable.

### ACT-ISS-SAS-STATA-HANDOFF: Request the intended SAS-to-Stata export/import step, output format/path and variable-name conventions for cecl_dataset, plus the required dataset reload and run order for each of the three Stata analysis scripts; do not guess the handoff or ordering.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: ISS-SAS-STATA-HANDOFF
Evidence: EV-STEP3-FINAL, EV-STATA-START, EV-STATA-ANALYSES-SCOPE, EV-STATA-TABLE2, EV-STATA-PROCYCLICALITY, EV-DESC-ORDER

Preparation / proposed procedure:

1. Obtain the missing handoff and orchestration instructions, including whether each Stata script reloads an input or depends on shared in-memory state.

Validation to perform later:

- Confirm each Stata script loads the intended dataset in the author-confirmed order and that required variables match downstream references.

### ACT-ISS-SENSITIVITY-CONDITION: For this full-workflow scope, retain all 68 Step 2f sensitivity scripts in the documented sequence and resolve each script’s required inputs/producers; keep the main-only branch as an unselected alternative and do not remove sensitivity variables.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: ISS-SENSITIVITY-CONDITION
Evidence: EV-DESC-OPTIONAL, EV-STEP3-SENS

Preparation / proposed procedure:

1. Preserve and order all 68 Step 2f files before the Step 3 sensitivity merges.
2. Request author documentation for any unresolved sensitivity-specific input, macro expansion, path or transfer step.

Validation to perform later:

- After authorized execution, confirm every Step 2f output expected by Step 3 is produced and the sensitivity merge references resolve; no main-only variable removal is included.

### ACT-RUN-FULL-WORKFLOW: Conditional future procedure: after data, software, paths, WRDS transfers and the SAS-to-Stata handoff are resolved, run the author-ordered SAS stages through Step 3, including all 68 Step 2f sensitivity scripts, then run all three Stata analysis scripts in the author-confirmed order. Preserve the unresolved reload/order question until the authors specify it.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: ISS-CLOSURE, ISS-SENSITIVITY-CONDITION, ISS-SAS-STATA-HANDOFF
Evidence: EV-DESC-ORDER, EV-STEP3-SENS, EV-STEP3-FINAL, EV-STATA-ANALYSES-SCOPE, EV-STATA-TABLE2, EV-STATA-PROCYCLICALITY

Preparation / proposed procedure:

1. Start with Step 1 sample identification; follow with Step 2a and the documented Step 2b origination/NIC stages, then Step 2c estimation, 2d residuals and 2e estimate combination.
2. Run all 68 Step 2f sensitivity programs before Step 3 sensitivity merges; resolve each input and output path from author documentation.
3. Run Step 3 to create the final SAS analysis dataset and complete the author-confirmed SAS-to-Stata export/import handoff.
4. After obtaining author confirmation of per-script input reload and the Stata script order, run CECL_Analyses.do, CECL_Table2_Future_Charge_Off_Tests.do and CECL_Procyclicality_Analysis.do as directed.

Validation to perform later:

- Confirm all SAS-stage inputs and outputs resolve and Step 3 produces the author-expected final dataset.
- Confirm each of the three Stata scripts loads or receives the intended analysis dataset in the author-confirmed sequence; do not infer persistent in-memory state or a reload order.


## Remaining issues and prerequisites

- ISS-CLOSURE [unresolved; full_pipeline]: The 9,373-edge checklist contains unresolved macro/remote-context reads and external inputs whose exact producer, compatible vintage, or path cannot be established from the supplied workflow and bounded probes. Preserve this gap pending the authors’ complete producer list and schema/path details.
- ISS-NIC-NAME [unresolved; full_pipeline]: The NIC step writes nic.nic_relationships_20180331, later reads nic.relationships_20180331, and separately writes nic.relationships_names_20180331. The read target has no matching name in these inspected producer lines; confirm intended raw/enriched table before execution.
- ISS-TOPREG [unresolved; full_pipeline]: Step 2b-2 writes box.top_regid_byperiod_2017, while downstream inputs reference top-regulatory-by-period tables; no producer for the legacy box.top_regid_byperiod target is demonstrated.
- ISS-LIBNAMES [unresolved; full_pipeline]: The code hard-codes Windows Box Sync paths under different user names and directory roots across stages, so the supplied workflow has no configured path mapping for this environment.
- ISS-WRDS-TRANSFER [unresolved; full_pipeline]: The consumer-loan estimation file marks a transfer to WRDS and leaves the concrete transfer instruction as a placeholder; local and remote copies of intermediate data are not linked by a reproducible supplied step.
- ISS-SAS-STATA-HANDOFF [unresolved; full_pipeline]: Step 3 saves box.cecl_dataset as a SAS dataset. Three Stata analyses are supplied, but their entry code has no visible data-load/import step; the intended transfer, dataset reload per script, and correct run order are unspecified.
- ISS-SENSITIVITY-CONDITION [unresolved; full_pipeline]: The complete requested workflow includes all 68 Step 2f sensitivity scripts, but their full producer/input closure is not verified. The author documents a separate main-only branch that skips Step 2f only after removing marked Step 3 variables; that branch is not selected here.
- REQ-SPGMI [undetermined]: S&P Global Market Intelligence loan composition, charge-off/nonperforming-loan, financial-statement and other bank panel CSVs used in the CECL workflow.
- REQ-SPGMI-MA [undetermined]: S&P Global MI M&A screen/export used to construct bank merger and acquisition attributes.
- REQ-AUTHOR-PANELS [undetermined]: Author-prepared bank holding company and commercial-bank quarterly panels and keys, including rankdates, all_* series, sample identifiers and related CECL input tables.
- REQ-HMDA-1990-2014 [public_acquisition_required]: HMDA LAR source files for 1990–2014 required by the annual origination processing.
- REQ-HMDA-2015-2016 [public_acquisition_required]: HMDA LAR source files for 2015–2016 required by the annual origination processing.
- REQ-HMDA-LINKS [undetermined]: HMDA respondent-to-RSSD panel/crosswalk inputs, including author-created name-and-location links for 1990–2003 and annual panel_* inputs used by the scripts.
- REQ-NIC-2018 [undetermined]: Dated NIC attributes, relationships and transformations files used to form regulatory-parent and acquisition mappings.
- REQ-NIC-2015 [undetermined]: NIC relationships/transformations snapshot used by model macros for historical bank relationship data.
- REQ-NYFED-CRSP-LINK [undetermined]: Federal Reserve Bank of New York CRSP-RSSD link table used to match regulatory IDs to CRSP PERMCO.
- REQ-CRSP-MSF [undetermined]: CRSP monthly stock file fields used for market value and return construction.
- REQ-CRSP-DSF [undetermined]: CRSP daily stock data used to construct daily/quarterly returns.
- REQ-CRSP-COMP-LINK [undetermined]: CRSP/Compustat identifier link data required for matching quarterly firm observations.
- REQ-COMPUSTAT-FUNDQ [undetermined]: Compustat quarterly fundamentals used in the Step 3 market-data merge.
- REQ-FF-FACTORS [undetermined]: Fama-French daily factors used in market-adjusted returns.
- REQ-IBES-STATS [undetermined]: I/B/E/S analyst forecast summary data used in the earnings forecast merge.
- REQ-IBES-ACTUALS [undetermined]: I/B/E/S actual EPS data used in the analyst-data merge.
- REQ-IBES-PTG [undetermined]: I/B/E/S price target summary data used in the analyst-data merge.
- REQ-BLS [public_acquisition_required]: Historical unemployment series used to create the quarterly unemployment control.
- REQ-BEA [public_acquisition_required]: Quarterly real GDP series used to create the GDP growth control.
- REQ-SLOOS [undetermined]: Federal Reserve Senior Loan Officer Opinion Survey series used to construct commercial-bank lending standards controls.
- REQ-CASE-SHILLER [undetermined]: S&P Case-Shiller national home price index used to form the quarterly housing-price control.
- SW-SAS [unverified]: The documented workflow is primarily SAS; environment probe reports executable presence but TKELS startup failed, so usable runtime/license status remains unverified.
- SW-WRDS [unverified]: Author code requires WRDS signon, remote libraries and file transfer; no authenticated connection/remote path was verified.
- SW-CORSP [preparation_required]: The author uses corsp; Stata 18 which probe did not find the package.
- SW-OUTREG2 [preparation_required]: The author uses outreg2; Stata 18 which probe did not find the package.
- SW-WINSOR2 [preparation_required]: The author uses winsor2; Stata 18 which probe did not find the package.

## Review notes

- Assessment is limited to the frozen author package, its cached source text, supplied bounded probes and the listed official public product pages. No author code or regression was run.
- The package includes extensive SAS/Stata source code and one SPGMI legend workbook, but no prepared final analysis dataset. Analysis-only is therefore unsupported.
- All 9,373 frozen dependency IDs are covered below. The requested full workflow includes all 68 Step 2f sensitivity scripts; their unresolved edges are linked to a concrete issue. The author-documented main-only route is retained as an unselected alternative and is not used to classify in-scope dependencies as optional.
- Readable local CRSP, Compustat, FF and I/B/E/S catalog probes verify only requested columns and a one-row read, not historical coverage or equivalence to the authors’ WRDS vintage/interface.
- The NIC relationship name mismatch, missing legacy top-regulatory producer, hard-coded Windows path differences, WRDS transfer placeholder and SAS-to-Stata handoff remain actionable source/workflow gaps.
- The full workflow includes all three supplied Stata analyses: the main tables excluding Table 2, Table 2 future charge-off tests, and Figure 3/Section 6.3 procyclicality. Fresh-dataset reload and script order remain unresolved until author confirmation.
- Supplementary Stata software review confirms _gxtile and ranktest are available via successful Stata 18 which probes and author/developer documentation.
