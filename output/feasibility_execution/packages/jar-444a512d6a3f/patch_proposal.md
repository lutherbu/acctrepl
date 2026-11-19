# Patch proposal: jar-444a512d6a3f

Does Social Capital Matter in Corporate Decisions? Evidence from Corporate Tax Avoidance

DOI: 10.1111/1475-679X.12159

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented SAS data construction and Stata analysis workflow, including the main paper and separately supplied online appendix; the named entry document contains embedded executable SAS DATA/PROC REG/PRINCOMP and Stata blocks.

Entry points: `Detail Step by Step Description.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 3/12159 - Does-Social-Capital-Matter-in-Corporate-Decisions-Evidence-from-Corporate-Tax-Avoidance/hhwz-datasheet-and-code.zip",
      "sha256": "187f247d1b8aa92cb9e8a1da40fa086a4ef6fda128c4b1cb4169edb0b08c985c"
    },
    {
      "path": "JAR-Volume 55/Issue 3/12159 - Does-Social-Capital-Matter-in-Corporate-Decisions-Evidence-from-Corporate-Tax-Avoidance/hoi-online-appendix.pdf",
      "sha256": "1c5c3d15b6fccd75434bbddcfd811f6392a1905c7542c847e39af362f82d6dfd"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6c5af1b6f2bb7e97911c10d87c9b1e6de7b02afb5c6fe5ea87197e5415ede33d",
  "work_item_sha256": "f94a3f180153c1ff3a9f96062b4d6754c0f1ee31738c6198aba49fce9eb8897b"
}
```

## Proposed actions

### ACT_REQUEST_CONTEXT: Obtain the missing complete author run context before attempting the full pipeline, including ordered producer code, complete input schemas, Stata setup, Table 1 and appendix recipes, and the unresolved derived-input definitions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_PROGRAM_CONTEXT, ISSUE_CLOSURE, ISSUE_BORDER, ISSUE_SHELTER, ISSUE_TABLE_LABEL
Evidence: E_PACKAGE_INVENTORY, E_SAS_DATA, E_SAS_REG, E_SAS_PCA, E_STATA_SOURCE, E_APPENDIX, E_DATASHEET_SOURCES, E_TABLE_LABEL, E_BORDER_SOURCE, E_SAS_FUNCTION, E_SHELTER_SOURCE, E_DYR_AUTHOR

Preparation / proposed procedure:

1. Extract the substantial SAS and Stata blocks already embedded in the PDF without normalizing line wraps or continuations; compare each extracted block against the original PDF before use, then request only missing producer/setup context rather than inventing code.
2. Request all SAS import/producer code and ordered run instructions for raw inputs, compu1, compu1_6/compu1_7, sc_1990/sc_1997/sc_2005/sc_2009, merges and the Stata panel.
3. Request Stata data-loading instructions and definitions of $control and $pathout, plus the Table 1 summary-statistics procedure.
4. Request procedures and input crosswalks for online-appendix Tables A.1–A.10; treat datasheet-only BEA/DOJ/TRAC IRS origins as source leads until associated with actual analyses.
5. Request the exact log_border producer, firm ZIP input, eligible border-county ZIP universe and SASHELP.ZIPCODE version.
6. Request Wilson/Rego shelter probability variable definitions, inputs and estimation/ranking steps.
7. Clarify whether the alternative ETR/CETR code block belongs to Table 6 or Table 8.

Validation to perform later:

- Confirm every consumed intermediate has a supplied producer and inputs, and documented order covers the main-paper tables and appendix analyses.
- Confirm Table 1 and each Table A.1–A.10 result has a recipe and linked data inputs before any authorized run.

### ACT_VERIFY_DATA: Verify exact author-input versions, periods, identifiers, fields, crosswalks and permitted access for each unverified source route; preserve the named sources unless compatibility is established.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ_COMPUSTAT, REQ_SEC_10K, REQ_CSG, REQ_OPTN, REQ_ARDA, REQ_KLD, REQ_EX21_US, REQ_EX21_FOREIGN, REQ_HAVEN
Evidence: E_COMP_CAT, E_COMP_PROBE_OLD, E_COMP_PROBE, E_SEC_PARSED, E_SEC_RAW, E_SEC_WEB, E_CSG_WEB, E_OPTN_WEB, E_ARDA_WEB, E_KLD_CAT, E_KLD_PROBE, E_WRDS_CAT, E_WRDS_PROBE, E_WRDS_WEB, E_TAXHAVEN_SOURCE, E_EX21_US_SOURCE, E_EX21_FOR_SOURCE, E_LM10X, E_DYR_AUTHOR

Preparation / proposed procedure:

1. Confirm COMP.FUNDA author-period population and required financial/control fields including TXTUBEND; its current candidate and sample probes do not establish 1990–2012 coverage.
2. For SEC filing text, verify local parsed/raw roots and exact LM10X 1993–2012 year paths; directories exist, but check targeted filing population, CIK/year coverage, retained address headers and cleaning compatibility before relying on them. Resolve the 1993 filing gap without inferring coverage from EDGAR start dates.
3. Verify KLD version, year coverage, seven concern variables, CUSIP/GVKEY mapping and author sample coverage.
4. Identify the exact annual CSG statutory corporate-rate tables and OPTN state/year donor counts for 1990–2012.
5. Determine which ARDA file/release and adherence denominator were used and how collection years aligned with the annual firm panel.
6. Verify separate domestic and international Dyreng Exhibit 21 files, years, state/country fields and coverage; do not substitute the local WRDS candidate without compatibility evidence.
7. Verify the author tax-haven jurisdiction list and classification version.

Validation to perform later:

- Compare confirmed source schemas, identifiers and history with author-documented sample requirements before any authorized construction.

### ACT_ACQUIRE_NRCRD_CENSUS: Acquire the verified official NRCRD old/new county files and relevant USA Counties historical demographic files; prepare only the documented components and merge keys.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: REQ_NRCRD_OLD, REQ_NRCRD_NEW, REQ_CENSUS
Evidence: E_NRCRD_OLD_WEB, E_NRCRD_NEW_WEB, E_NRCRD_SOURCE, E_NRCRD_TRANSFORM, E_CENSUS_WEB, E_CENSUS_SOURCE

Preparation / proposed procedure:

1. Obtain both official NRCRD Excel workbooks: 1990/1997/2005 and 1997/2005/2009.
2. Apply the documented 1990 Nccs estimate, consistent ten-organization Assn measure, four-year PCA, and preceding-observed-year fill.
3. Obtain relevant historical Census subject files for author-defined county/state variables and use Appendix A definitions before selecting and filling variables.
4. Prepare county/state identifiers and year keys as described for county-year and state-year merges.

Validation to perform later:

- Verify workbook vintages, required years, county identifiers, requested fields and documented transformations before merging.

### ACT_SOFTWARE_SETUP: Resolve the SAS startup issue and configure the author-required Stata add-ons and SAS ZIP reference data before any authorized analysis run.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, SW_WINSOR2, SW_OUTREG2, SW_SASHELP_ZIPCODE
Evidence: E_ENVIRONMENT, E_SOFT_WINSOR2, E_SOFT_OUTREG2, E_WINSOR_SOURCE, E_STATA_SOURCE, E_SAS_FUNCTION, E_BORDER_SOURCE

Preparation / proposed procedure:

1. Resolve the SAS TKELS initialization error and verify SAS 9.4 can run the documented DATA/PROC code; do not infer license status from the current error.
2. Verify SASHELP.ZIPCODE exists and its vintage is appropriate for ZIPCITYDISTANCE.
3. Provide winsor2 and outreg2 on the intended Stata adopath and verify each exact command.
4. Retain Stata 18, which the environment probe reports available.

Validation to perform later:

- After setup, run bounded version/which checks; defer author code until workflow context and inputs are complete.


## Remaining issues and prerequisites

- ISSUE_PROGRAM_CONTEXT [unresolved; full_pipeline]: The detailed PDF includes executable SAS DATA/PROC REG/PRINCOMP blocks and Stata regressions, but starts from pre-existing datasets such as compu1 and sc_1990 and omits complete imports/producers, Stata data loading and definitions of $control/$pathout.
- ISSUE_CLOSURE [unresolved; full_pipeline]: The full producer-consumer order and input schemas are not supplied for all intermediates; Table 1 has no recipe and online appendix Tables A.1–A.10 have outputs but no workflows. Datasheet-only BEA/DOJ/TRAC source names remain clarification leads. GVKEY.xlsx is only an identifier sheet.
- ISSUE_BORDER [unresolved; full_pipeline]: Table 8 consumes log_border, but no border-county ZIP universe, selection steps or log_border producer is supplied. SAS documentation says ZIPCITYDISTANCE uses ZIP centroids and requires SASHELP.ZIPCODE, whose presence/runtime is unverified.
- ISSUE_SHELTER [unresolved; full_pipeline]: Table 9 consumes an annual firm sheltering probability/top-quartile dummy and references Wilson (2009) through Rego and Wilson (2012), but supplies no estimation recipe, input mapping or producer.
- ISSUE_TABLE_LABEL [unresolved; full_pipeline]: The workflow calls the alternative ETR/CETR analysis Table 6 while the embedded code comment calls it Table 8; intended output/table mapping needs clarification.
- REQ_COMPUSTAT [undetermined]: Compustat Annual firm-year financial inputs for the 1990–2012 U.S. county-headquartered firm panel, including identifiers, tax variables and controls (including TXTUBEND for Table 9).
- REQ_SEC_10K [undetermined]: SEC 10-K filing headers or equivalent author-collected records to map firm CIK/year to historical headquarters address/county, including relocations.
- REQ_NRCRD_OLD [public_acquisition_required]: Older NRCRD county component workbook for 1990, 1997 and 2005 used with the newer version for component harmonization.
- REQ_NRCRD_NEW [public_acquisition_required]: Newer NRCRD county component workbook for 1997, 2005 and 2009, used with the older file and the authors’ Nccs/Assn adjustments.
- REQ_CENSUS [public_acquisition_required]: County demographics and population for age, education, income and inequality controls, state population denominators for organ donations, and four-category ethnicity homogeneity.
- REQ_CSG [undetermined]: Annual state statutory corporate tax rates for the state-year controls.
- REQ_OPTN [undetermined]: Annual state organ-donor counts for 1990–2012, matched by state-year and divided by state population.
- REQ_ARDA [undetermined]: County religion adherence inputs and population denominator for the Table 4 firm-year regressions.
- REQ_KLD [undetermined]: Firm-year KLD negative-rating inputs across seven categories, identifiers and coverage sufficient to construct corporate irresponsibility.
- REQ_EX21_US [undetermined]: Dyreng domestic Exhibit 21 subsidiary locations by firm/year to identify firms with material subsidiaries in at least four U.S. states.
- REQ_EX21_FOREIGN [undetermined]: Dyreng international Exhibit 21 subsidiary-country data by firm/year to identify offshore tax-haven subsidiaries for Table 9.
- REQ_HAVEN [undetermined]: Dyreng and Lindsay tax-haven jurisdiction list used with foreign subsidiaries for the Table 9 tax-haven indicator.
- SW_SAS [unverified]: SAS DATA/PROC code is required, but the configured runtime failed during TKELS initialization; usable availability is unverified and entitlement cannot be inferred.
- SW_WINSOR2 [preparation_required]: The authors require winsor2; the exact command probe did not find it in checked adopaths.
- SW_OUTREG2 [preparation_required]: The supplied Stata blocks invoke outreg2; the exact command probe did not find it in checked adopaths.
- SW_SASHELP_ZIPCODE [unverified]: SAS documentation requires SASHELP.ZIPCODE for ZIPCITYDISTANCE; the current SAS runtime cannot establish its presence/version.

## Review notes

- The embedded SAS and Stata blocks count as supplied executable author code. The PDF is a partial workflow, not a complete runnable program; GVKEY.xlsx is an identifier sheet only. No author code, regression or dataset download was run.
- Local catalog candidates and bounded probes do not establish author-version compatibility, full coverage or absent licenses. Appendix-only source names remain workflow clarification leads until mapped to output recipes.
