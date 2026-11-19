# Patch proposal: jar-253aad029488

Accrual Accounting and Resource Allocation: A General Equilibrium Analysis

DOI: 10.1111/1475-679X.12365

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete author-documented workflow: six source products, full SAS construction, StatTransfer 13 MATLAB7 handoff, all 16 SMM driver entry points with 51 same-folder helper functions, and documented manual spreadsheet assembly. The scope retains the author’s country, ICW/restatement, reversal and alternative 5%/10% branches.

Entry points: `datasheet and code/ConstructData.sas`, `datasheet and code/estimate_model/Table3467/SMMEstimation_China.m`, `datasheet and code/estimate_model/Table3467/SMMEstimation_India.m`, `datasheet and code/estimate_model/Table3467/SMMEstimation_US.m`, `datasheet and code/estimate_model/Table5/SMMEstimation_ICWE.m`, `datasheet and code/estimate_model/Table5/SMMEstimation_ICWIE.m`, `datasheet and code/estimate_model/Table5/SMMEstimation_NRES.m`, `datasheet and code/estimate_model/Table5/SMMEstimation_RES.m`, `datasheet and code/estimate_model/Table8A/SMMEstimation_Reversal_China.m`, `datasheet and code/estimate_model/Table8A/SMMEstimation_Reversal_India.m`, `datasheet and code/estimate_model/Table8A/SMMEstimation_Reversal_US.m`, `datasheet and code/estimate_model/Table8B10/SMMEstimation_10_China.m`, `datasheet and code/estimate_model/Table8B10/SMMEstimation_10_India.m`, `datasheet and code/estimate_model/Table8B10/SMMEstimation_10_US.m`, `datasheet and code/estimate_model/Table8B5/SMMEstimation_5_China.m`, `datasheet and code/estimate_model/Table8B5/SMMEstimation_5_India.m`, `datasheet and code/estimate_model/Table8B5/SMMEstimation_5_US.m`, `datasheet and code/result/Figure4.xlsx`, `datasheet and code/result/Table2.xlsx`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 4/12365 - Accrual-Accounting-and-Resource-Allocation-A-General-Equilibrium-Analysis/choi-datasheet-code-and-identifiers.zip",
      "sha256": "961c0045fead7018721b733602e8b10ecabd35e42920d7ec61c1ccdcbf29af5d"
    },
    {
      "path": "JAR-Volume 59/Issue 4/12365 - Accrual-Accounting-and-Resource-Allocation-A-General-Equilibrium-Analysis/choi-online-appendix.pdf",
      "sha256": "85a1993c892a867d03415ea156265a678c403739301cbe49a7491b7bd1057a25"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "4bc9b7ff75fab86566cf38844940b4634ba337c4cb504b2694ddb6099e6479fe"
}
```

## Proposed actions

### A_CONFIRM_KEYS: Check that the local Compustat and Audit Analytics extracts use compatible CIK/company_fkey values and dates for the exact prior-year joins already written in ConstructData.sas.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_AA_IDENTITY
Evidence: E_CIK_COMPANY_FKEY_JOIN, E_ICW_RESTATEMENT_FIELDS, E_PROBE_COMPANY_LOCAL, E_PROBE_ICW_LOCAL, E_PROBE_AA_RES_LOCAL, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Compare CIK Char(11) and company_fkey Char(10) using the raw source definitions and actual local values; report whether the source values match under the existing equality without guessing, padding, truncating or recoding.
2. Check the raw IC opinion dates against the exact authored `year-1` match and the restatement begin/end dates against the exact `intnx('year',datadate,-1)` interval.
3. Preserve both SAS join expressions and sample timing as written; treat incompatibility, if found, as unresolved pending evidence rather than changing the model definition.

Validation to perform later:

- During a later authorized data validation, report key-match coverage and type conversion behavior without changing author definitions.

### A_DATA_ACCESS: Validate the six readable local catalog candidates against the author-defined Compustat and Audit Analytics source products, period coverage, population and company identifiers; if they are not the compatible complete inputs, acquire those exact products through the documented WRDS route.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_FUNDA, R_COMPANY, R_G_FUNDA, R_G_COMPANY, R_ICW, R_AA_RES, I_DATA_ACCESS_AND_PERIOD
Evidence: E_README_INPUTS, E_PROBE_FUNDA_LOCAL, E_PROBE_COMPANY_LOCAL, E_PROBE_G_FUNDA_LOCAL, E_PROBE_G_COMPANY_LOCAL, E_PROBE_ICW_LOCAL, E_PROBE_AA_RES_LOCAL, E_GLOBAL_FILTER_JOIN, E_SAS_FIELD_OWNERSHIP, E_GLOBAL_FIELD_OWNERSHIP, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. For each existing local candidate, confirm it is the intended source product and complete source vintage; each current bounded read sampled one row and verified no historical/population coverage.
2. Retain the source filters: North America consol=C, indfmt=INDL, datafmt=STD, popsrc=D; Global consol=C, indfmt=INDL, datafmt=HIST_STD, popsrc=I, with the author’s India IND/INR and China CHN/CNY country/currency selections.
3. Keep the author’s gvkey join from funda/g_funda to company/g_company before later keep statements; do not invent aliases for company fields or edit the source.
4. Verify at least 2001–2013 North America annual history for the 2004–2013 ICW/restatement branch and at least 2010–2013 Global history for the 2013 country files; confirm any wider author source ranges from the actual full extracts.
5. Confirm Audit Analytics field formats, full required date coverage, CIK/company_fkey representation, the prior-year ICW match, and the restatement date intervals before accepting local compatibility.

Validation to perform later:

- Check exact source product, required fields/types and complete population/date coverage after acquisition; one-row probes alone do not prove them.
- Verify author-prescribed source filters, joins and generated row coverage without recoding timing or identifiers based on guessed conventions.

### A_ORDERED_HANDOFF: Run the documented SAS → StatTransfer 13 MATLAB7 → per-folder MATLAB workflow using actual producer/consumer paths, while preserving each country and ICW/restatement branch and every helper file.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I_MAT_HANDOFF
Evidence: E_README_TRANSFER_MAP, E_STATTRANSFER_SAMPLE, E_STATTRANSFER_SETTINGS, E_SAS_CAL_LIBRARY, E_TABLE5_LOAD_FIELDS, E_TABLE8A_US_LOAD, E_HELPER_STATE, E_HELPER_CALL, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Copy the six source products from their distinct source roots into a separate staged working Data folder; set Folder to that project root so CAL reads the staged inputs and writes derived datasets beside them without writing back to the source roots.
2. Use the documented Appendix 2 MATLAB7 settings and repeat its SAS7BDAT-to-MAT conversion for each exact named output: compc2013, compgchnc2013, compgindc2013, compicw01res, compicw01nres, compicw01ie and compicw01e. The SAS outputs and MATLAB driver loads identify the other six targets; no additional scientific transformation is implied.
3. Copy the three country 2013 MAT files into Table3467, Table8A, Table8B5 and Table8B10, where the actual country drivers load them; copy the four ICW/restatement subgroup MAT files into Table5, where its drivers load them. This corrects the reversed Table5/Table8A destination wording in README Step 3 using the actual driver inputs.
4. Before any model run, verify each MAT produces the author-used st_dataset with acl1, acl2, ael1, ael2, acgl1, aegl1, investg and industry2, preserving column types and row order as expected by the source.
5. Run only the 16 supplied SMMEstimation_*.m drivers, each with its own estimate_model subfolder as current folder; retain all 51 same-folder helper .m files as called-function closure. Do not treat criterionFunction, policyFunction or other stateful helper files as standalone launches.
6. Preserve original dimensions, random seeds, sample branches, multi values, SMM moments, simulated-annealing initialization, Knitro refinement and branch-specific policy functions; do not substitute a different estimator or collapse Table8B5 and Table8B10.

Validation to perform later:

- Verify each SAS producer, StatTransfer MAT and MATLAB relative load matches the exact table-country/subgroup handoff mapped in workflow_trace.json.
- Check the eight expected st_dataset fields and downstream MATLAB output names after an authorized run; do not run estimators as a feasibility check.

### A_SOFTWARE_METADATA: Resolve runtime availability and exact function/interface/license capability for the author-specified software through bounded metadata checks, without running estimation or simulation.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: I_SOFTWARE_CAPABILITY, SAS_94, MATLAB_R2017A, STATTRANSFER_13, KNITRO_1221, MATLAB_FUNCTIONS, SPREADSHEET_ENGINE
Evidence: E_README_SOFTWARE, E_ENVIRONMENT, E_SOFTWARE_PATH, E_SMM_SOLVER_CHAIN, E_CHI2CDF_CALL, E_XLSWRITE_CALL, E_STATTRANSFER_SAMPLE, E_FIG4_STATIC_PROGRAM, E_TABLE2_STATIC_PROGRAM

Preparation / proposed procedure:

1. Verify SAS 9.4 startup/configuration after reviewing the TKELS diagnostic; the current status is unverified and does not establish license availability.
2. When MATLAB R2017a is locatable, use only non-estimator metadata queries to confirm the exact `simulannealbnd`, `knitromatlab`, `chi2cdf` and `xlswrite` resolutions, associated required toolbox/interface components and license capability; do not invoke any optimizer or model function.
3. Verify StatTransfer 13 and its MATLAB7 writer path, and verify Knitro 12.2.1 MATLAB interface/license through supported software metadata.
4. Identify an available spreadsheet engine/version and check its formula/workbook support using software metadata only; keep formula evaluation for a separately authorized reproduction run.

Validation to perform later:

- Record software release, exact function resolution, required feature/license checks and command/process diagnostics in JSON under this package's probes directory.
- Do not install packages or execute author code, estimator/optimizer functions, synthetic trials, or workbook recalculation as part of a metadata check.

### A_WORKBOOK_RECIPE: Preserve the supplied Table2 and Figure4 formula programs, document their manual inputs, and establish the supported workbook engine/version and exact paste ranges.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_WORKBOOK_ENGINE
Evidence: E_README_MANUAL_ASSEMBLY, E_FIG4_STATIC_PROGRAM, E_FIG4_STATIC_STATUS, E_TABLE2_STATIC_PROGRAM, E_TABLE2_STATIC_STATUS, E_FIG4_README_FILENAME, E_FIG4_DRIVER_FILENAME, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Use the original Table2.xlsx (SHA256 f60940212306e40529aa474fbc0c904c0be310778e22c5cdf145939a50692912) and Figure4.xlsx (SHA256 bb6206d1a06fc70cb40e001d4d1b6322f4c980083c8967d7e3111e5cba6367ef) as the workbook-program entry points; preserve all formula bytes and existing sheet/cell structure.
2. For Table2, paste t2_dsus, t2_dschina and t2_dsindia into the documented yellow areas on dsus, dschn and dsind; the table sheet contains the supplied formula program.
3. For Figure3, paste the Table3467 US simulation_f3 output into the supplied Figure3 template; it has no inspected formula/pivot program.
4. For Figure4, the README says sensitivity_f4_US/China/India, while the drivers write sensitibity_f4_US/China/India.xlsx; locate the actual source-produced filenames and confirm the matching yellow country ranges in the supported spreadsheet engine.
5. Identify an available spreadsheet engine/version and confirm it supports the stored workbook formulas and required manual paste operation. Do not use Office/LibreOffice, recalculate, refresh pivots or dereference external links during this static feasibility assessment.

Validation to perform later:

- In a later authorized execution using the supported engine, confirm workbook sheets, manual input ranges and resulting formula cells after outputs exist.
- Retain the frozen workbook hashes and do not patch binary XLSX files or substitute cached values.


## Remaining issues and prerequisites

- I_AA_IDENTITY [unresolved; full_pipeline]: The SAS source compares CIK with company_fkey using ordinary equality; the frozen catalog types show Compustat CIK as Char(11) and Audit Analytics company_fkey as Char(10). No conversion/padding/crosswalk is supplied, so verify that the local extracts’ key representation is compatible with the authored equality. The code explicitly uses the prior-year ICW match and an intnx('year',datadate,-1) restatement interval; preserve those written timing rules while checking the raw dates/identifiers.
- I_DATA_ACCESS_AND_PERIOD [unresolved; full_pipeline]: No author-prepared analysis dataset is supplied. Six local catalog candidates for the documented Compustat and Audit Analytics products are readable in row_limit=1 probes, but those probes do not verify the full issuer population, required years, source vintage or construction compatibility. The US 2004–2013 subgroup branch requires three earlier same-month accounting years (at least 2001–2013); Global 2013 outputs require three prior years (at least 2010–2013); the Audit Analytics date coverage must align with the actual prior-year match and interval joins. Company fields are joined from company/g_company before later keep statements.
- I_MAT_HANDOFF [unresolved; full_pipeline]: README Step 3 lists the Table5 and Table8A country/subgroup MAT destinations in reverse order from actual driver loads. Actual Table5 drivers consume four compicw01 subgroup matrices; Table8A, like Table3467/Table8B5/Table8B10, consumes country 2013 matrices. Appendix 2 supplies the MATLAB7 transfer settings and a compc2013 example; SAS output names and driver loads define the other six files. The remaining contract to verify is the produced st_dataset field/type mapping and runtime compatibility, while every folder-relative load/export path must be preserved.
- I_SOFTWARE_CAPABILITY [unresolved; full_pipeline]: The README specifies SAS 9.4, MATLAB R2017a, StatTransfer 13 and Knitro 12.2.1. The bounded SAS startup attempt fails at TKELS with return code 1; MATLAB, StatTransfer and Knitro are not discoverable on PATH. Availability of simulannealbnd, knitromatlab, chi2cdf, xlswrite, required toolbox/interface components, licenses and the workbook calculation engine remains unverified. These observations are not evidence of missing licenses; no author routine or optimizer was run.
- I_WORKBOOK_ENGINE [unresolved; full_pipeline]: Table2.xlsx and Figure4.xlsx contain supplied formula programs for the README manual paste workflow, but the calculation engine/version and exact paste ranges are unspecified. Static inspection counted 126 and 210 formulas, respectively, without evaluating formulas or cached values. README calls Figure4 files sensitivity_f4, while the country drivers emit sensitibity_f4; use the exact native output names and confirm the input ranges in the supported spreadsheet engine.
- R_AA_RES [undetermined]: Audit Analytics Restatements (aa_res) records.
- R_COMPANY [undetermined]: Compustat North America company table used for CIK and company attributes.
- R_FUNDA [undetermined]: Compustat North America funda records used for US sample construction.
- R_G_COMPANY [undetermined]: Compustat Global g_company table joined for India sample identifiers and attributes.
- R_G_FUNDA [undetermined]: Compustat Global g_funda records used for India and China samples.
- R_ICW [undetermined]: Audit Analytics SOX 404 Internal Controls (icwrestatement) records.
- KNITRO_1221 [unverified]: The author drivers call knitromatlab. The package is not discoverable on PATH and the MATLAB function/interface/license could not be queried without MATLAB; no optimizer was invoked.
- MATLAB_FUNCTIONS [unverified]: These exact functions are called by supplied drivers. Function resolution, associated toolbox/license capability and writer compatibility remain unverified because MATLAB is not discoverable on PATH; no estimator, optimizer or simulation ran.
- MATLAB_R2017A [unverified]: Author-prescribed release. MATLAB is not discoverable on PATH; installation, exact release, functions/toolboxes and license capability remain unverified.
- SAS_94 [unverified]: Required by the author workflow. The existing bounded startup probe reports a TKELS extension load failure (return code 1); it does not establish an absent license or a complete availability result.
- SPREADSHEET_ENGINE [unverified]: The author requires manual workbook assembly and stored formula programs, but does not specify an Excel engine/version or compatibility. Workbooks were inspected statically only.
- STATTRANSFER_13 [unverified]: Author-prescribed SAS-to-MATLAB7 conversion tool. No executable is discoverable on PATH; installation, version and conversion availability remain unverified.

## Review notes

- Full source review is complete for all 75 frozen source entries (5,335 code lines, 1,447 document lines and 4 data/template lines); 43 unique source hashes are represented. Workflow trace records all 16 estimation drivers, 51 required same-folder helper files, all 37 dependency IDs, workbook programs and one-row raw-source probe results.
- Only actual drivers, ConstructData.sas and original formula-bearing Table2/Figure4 workbooks are entry points. MATLAB helpers remain in closure and are called with driver state. All source outputs, country/subgroup branches, native sample/definitions, SMM/optimizer sequence and workbook formulas remain preserved.
- Six local SAS catalog source candidates passed row_limit=1 readability/field probes, but population and date coverage remain unverified. Company fields used after keep are supplied by the joined company tables; CIK/company_fkey type-length and timing semantics remain unresolved.
- Workbook inspection was static XML only. No author SAS/MATLAB/StatTransfer/Knitro code, estimator, optimizer, simulation, workbook formula, pivot or cached value was executed or recalculated; no source or model changes are proposed.
- No analysis_only scope is supported: the packaged CompanyIdentifiers workbook contains a GVKEY identifier list, while the result workbooks are templates and the full workflow requires the six separate raw source products.
