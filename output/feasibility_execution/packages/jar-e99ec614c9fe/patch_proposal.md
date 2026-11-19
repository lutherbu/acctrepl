# Patch proposal: jar-e99ec614c9fe

Cash-for-information whistleblower programs: Effects on whistleblowing and consequences for whistleblowers

DOI: 10.1111/1475-679X.12370

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied DHP Stata workflow prepares the district-year analysis panel and runs the 15 regressions for Tables 3, 4C, 5, and 6. The appendix's IA1–IA5 results and the datasheet's historical raw-data provenance are contextual; no extra programs or raw-source rebuild are inferred.

Entry points: `DHP_code_final.do`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 5/12370 - Cash-for-information-whistleblower-programs-Effects-on-whistleblowing-and-consequences-for-whistleblowers/dhp-datasheet-and-code.zip",
      "sha256": "749632596b083fc4fa0d7e1e111a72025dd906a18b867d9b149e958172041445"
    },
    {
      "path": "JAR-Volume 59/Issue 5/12370 - Cash-for-information-whistleblower-programs-Effects-on-whistleblowing-and-consequences-for-whistleblowers/dhp-online-appendix.pdf",
      "sha256": "2d60b565c7036741c9d525d8e3149e286e5cf7bdfd110b228d85eefae126dc93"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "2ffd419a4d417a7f90ff246289ce7c8d4da68df0e01e6b5dc3af94da9eb24f11"
}
```

## Proposed actions

### A_VERIFY_INPUTS: Identify and obtain the four compatible author-prepared inputs, or obtain enough exact source contracts to establish compatible routes. Use author-prepared analysis inputs as the primary route; the datasheet's historical FOIA/Engstrom/PACER/BLS/DOJ/network/Smartlinx provenance is not a set of mandatory AND inputs for this supplied program.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CASES, R_JURISDICTION, R_DISTRICT, R_CONTROLS, I_INPUT_ROUTES, I_FIELD_OWNERSHIP, I_PANEL_SHAPE
Evidence: E_DATASHEET_PROVENANCE, E_CODE_INPUTS, E_CODE_TRANSFORMS, E_CODE_PANEL, E_CODE_CONTROLS, E_CATALOG_REVIEW, E_PACKAGE_INVENTORY, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Locate compatible author-prepared versions of district_courts_all, jd_to_circuit, district_variables.dta, and controls.dta; the assigned package inventory and related_packages list contain none. If no compatible release can be identified, request the exact input schemas, producers, and coverage instead of independently rebuilding unstructured historical data.
2. For district_courts_all, verify the code-consumed fields Received_Date, Election_Date, Election_Decision, Total_Federal_Recovery, Relator_Share, and Judicial_District; confirm date/type and election-category compatibility, target population, and 1994–2012 case-derived outcomes. Then verify the resulting panel has native 1993 rows/values needed by first in-sample lags; the code itself adds MP/VI/GU boundary rows at 1993 and 2013 after case aggregation, so do not assume 2013 raw case records are required.
3. For jd_to_circuit, verify unique Judicial_District keys, numeric circuit values, coverage of every case-panel district, and the ARW-to-8 override. FJC.APPEALS is only a catalog candidate with DDIST/DCIRC; use it only if a documented crosswalk, uniqueness, and complete district coverage are established.
4. Inspect district_variables.dta and controls.dta separately with bounded metadata reads. Resolve which file supplies each consumed field, any overlapping names, matching Judicial_District/year types, unique district-year using keys, and coverage needed for 1993 lags; preserve the code-generated 1993/2013 boundary rows without inferring extra raw-year requirements.
5. After collapse and the circuit merge, check the actual row count and ordering around observations 1485–1490 before the fixed MP/VI/GU 1993/2013 assignments; then check the resulting tsfill panel and 1993 values required by the first in-sample lags. Preserve 1994–2012 as the estimation sample.

Validation to perform later:

- All four code reads resolve in one documented current working directory, and bounded source metadata matches the actual consumed fields and identifiers.
- Both merge types are compatible; the using side is unique on Judicial_District for jd_to_circuit and on Judicial_District/year for each district-year file.
- The estimation sample remains 1994–2012, native 1993 values support the first in-sample lagged specifications, and the source-generated MP/VI/GU 1993/2013 boundary rows remain in the panel.
- Fields used after the two whole-table merges have verified file ownership, numeric/string types, nonconflicting names, and adequate year coverage.
- The fixed assignments at observations 1485–1490 do not overwrite pre-existing districts; the tsfill-produced panel remains compatible with the 15 supplied regressions.

### A_RUN: After the input contracts and panel shape are verified, run the supplied entry point unchanged in a working copy with Stata 18, reghdfe 6.12.3, and ftools 2.49.1. All reads are relative to the current working directory; no execution or compatibility test was performed in this assessment.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R_CASES, R_JURISDICTION, R_DISTRICT, R_CONTROLS
Evidence: E_ENVIRONMENT, E_WORKFLOW_TRACE, E_TABLE3, E_TABLE4C, E_TABLE5, E_TABLE6A, E_TABLE6B

Preparation / proposed procedure:

1. Copy the package into a working directory with the four verified inputs and make that directory the current directory before launching the code.
2. Run `do DHP_code_final.do` in Stata 18 with reghdfe and ftools available; retain the Stata session output for review. The source contains 15 reghdfe specifications and does not save/export the final in-memory panel or tables.
3. Review Tables 3, 4C, 5, and 6A–B against the paper after confirming all 15 specifications used sample years 1994–2012 and the prescribed treatment/circuit clustering definitions.

Validation to perform later:

- Confirm the script completes all four reads and two district-year merges without changing source rows or merge semantics.
- Confirm output includes 3 Table 3 models, 3 Table 4C models, 3 Table 5 models, 3 Table 6A models, and 3 Table 6B models.
- Compare reported coefficients and sample sizes with the paper after input compatibility has been established; execution must not be treated as verified until a future authorized run succeeds.


## Remaining issues and prerequisites

- I_INPUT_ROUTES [unresolved; full_pipeline]: The package contains no data files or related package candidate, although the supplied code directly reads four inputs. No exact prepared-file catalog alias or matching code-field catalog hit was found. FJC.CIVIL and FJC.APPEALS are catalogued candidates with different product fields, not verified substitutes; no access barrier is established. The four inputs' readability, population, join contracts, and period remain unresolved.
- I_FIELD_OWNERSHIP [unresolved; full_pipeline]: After merging district_variables.dta and controls.dta as whole tables by Judicial_District and year, the code consumes district_internal_report, district_num_cases, labor_force_sum, civil_begin_pending, attorney_hours, and unemprate. With both source files unseen, their field ownership, types, overlap, and complete year coverage cannot be assigned or verified.
- I_PANEL_SHAPE [unresolved; full_pipeline]: The program writes MP, VI, and GU into fixed observations 1485–1490 at 1993 and 2013 before encode/tsset/tsfill. The unseen case-derived panel's row count and ordering determine whether these rows are additions or overwrite existing observations; this is unverified, not a confirmed failure.
- R_CASES [undetermined]: Case-level input `district_courts_all` (the code uses an extensionless Stata `use` path). The code reads Received_Date, Election_Date, Election_Decision, Total_Federal_Recovery, Relator_Share, and Judicial_District; it derives year/election date/invdays and case outcomes, filters missing/National Election_Decision rows, and collapses to Judicial_District × year. Case population, field types, completeness, and source period are unverified; district-year outcomes must support the 1994–2012 sample and the resulting panel must preserve the 1993 lag history. The code generates the MP/VI/GU 1993 and 2013 boundary rows after case aggregation; no 2013 raw case-record requirement is inferred.
- R_JURISDICTION [undetermined]: District-to-circuit input `jd_to_circuit` (extensionless Stata `using` path), merged m:1 by Judicial_District and supplying circuit_court; the code overrides ARW to circuit 8. The using key must be unique and cover all case-panel districts. Actual mapping coverage and compatibility remain unverified.
- R_DISTRICT [undetermined]: Separate district-year input `district_variables.dta`, merged m:1 by Judicial_District and year before the second controls merge. Its actual columns and which consumed post-merge fields it supplies are unknown because the file is absent and the code whole-table merges both inputs. Verify its key uniqueness, types, coverage, and any overlapping names with `controls.dta`.
- R_CONTROLS [undetermined]: Separate district-year input `controls.dta`, merged m:1 by Judicial_District and year after `district_variables.dta`. Its actual columns and source ownership of downstream fields are unknown; do not assign labor_force_sum, civil_begin_pending, attorney_hours, unemprate, district_internal_report, or district_num_cases to either file until actual metadata is checked. Verify key uniqueness, types, coverage, and overlaps.

## Review notes

- Scope covers only the supplied DHP_code_final.do workflow documented for Tables 3, 4C, 5, and 6. The appendix's IA1–IA5 results have no supplied executable programs and are contextual; no extra analyses are inferred.
- All four direct data reads are separately accounted for. The frozen dependency checklist lists only D0001 for district_courts_all; manual source review finds the other three reads at lines 57, 91, and 93. No unsupported dependency IDs were invented.
- The dependency graph for the supplied code is accounted for, but compatible input availability, schemas, field ownership, full coverage, and fixed-row panel shape remain unresolved. The sample is 1994–2012; validate 1993 lag values in the resulting panel, while MP/VI/GU 1993/2013 boundary rows are generated after case aggregation. The catalog and environment evidence are metadata/probes only, not proof of coverage or successful execution.
- FJC.APPEALS is retained only as an unverified mapping candidate (DDIST/DCIRC). FJC.CIVIL is a catalogued federal civil docket candidate, not a verified equivalent for the FCA whistleblower case input or its election/recovery fields. Catalog misses do not establish license denial.
- The authors' historical sources are provenance for their prepared data; they are not added as mandatory raw-source requirements. No author code, regression, data read, install, or source edit was executed or applied.
- The supplied code emits regression output in Stata but contains no saved/exported final panel or table command; this output persistence limit is retained as context rather than an invented extra data blocker.
