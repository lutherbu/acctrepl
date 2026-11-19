# Patch proposal: jar-085948b2cf86

When Employees Go to Court: Audit Office Labor Market Reputation and Audit Quality

DOI: 10.1111/1475-679X.12534

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The supplied native SAS workflow in JAR_JC2024.sas constructs audit-engagement, audit-office, auditor-personnel, and test-sample tables. The assessed endpoint is the in-memory SAS WORK state; the supplied driver does not provide paper estimators or an export step.

Entry points: `JAR_JC2024.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 4/12534 - When-Employees-Go-to-Court-Audit-Office-Labor-Market-Reputation-and-Audit-Quality/chen92024datasheetcodeandidentifiers.zip",
      "sha256": "d5d7dc64b9145f9a4e0f3e0a9242f21a44536f66c14a9e24c81cd97cf0996445"
    },
    {
      "path": "JAR-Volume 62/Issue 4/12534 - When-Employees-Go-to-Court-Audit-Office-Labor-Market-Reputation-and-Audit-Quality/jade-chen-online-appendix.pdf",
      "sha256": "5814bd93ae62d0d036a9e880ac7349bfd27b7ccf8896c2fd58c88e77f2755b4d"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "ba9bd5062df86e8d1cd08eafa539bceee8d2707b19cde0409aa344eebcf0ac62"
}
```

## Proposed actions

### A_INPUTS_G1: Locate or obtain the six distinct Employee inputs and establish their compatible contracts before a future supplied-workflow run.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_AUDOPIN, R_COMPFUNDA_SIC, R_MSA, R_AUDITCHANGE, R_COMPANN, R_RESTATE, I_INPUT_CLOSURE
Evidence: E_D_AUDOPIN, E_D_COMPFUNDA_SIC, E_D_MSA, E_D_AUDITCHANGE, E_CODE_COMPANN, E_D_RESTATE, E_WORK_ITEM_INVENTORY, E_DOC_AUDIT_ANALYTICS_ORIGIN, E_DOC_COMPUSTAT_ORIGIN, E_CATALOG_SELECTED, E_PROBE_COMPFUNDA

Preparation / proposed procedure:

1. For Employee.audopin, Employee.Compfunda_sic, Employee.msa, Employee.auditchange, Employee.compann and Employee.restate, identify a current readable author-prepared or compatible local/product route and retain each as a separate input.
2. Confirm the actual source columns, CIK/GVKEY and city/state/office identifiers, year versus fyear convention, transformation lineage and required history for each file from its data dictionary or bounded metadata.
3. For Audit Analytics and Compustat candidates, compare the actual source product/table and required fields/history; the candidate listings alone do not verify access or construction compatibility.
4. After selecting compatible Employee members, choose a portable Employee root for the prepared inputs and stage a working copy with coherent relative paths; leave supplied source bytes unchanged.
5. Treat COMP.FUNDA and the catalogued Audit Analytics feeds as underlying candidates only; compare each candidate with its separately consumed Employee table and required fields/history before crediting a route.

Validation to perform later:

- Before execution, verify each distinct input can be resolved at the configured Employee libref and has the required columns, keys and construction history.
- Only after separately authorized execution, confirm the documented intermediate joins and final in-memory sample tables are produced.

### A_LIBREF: Configure a portable Employee libref for the selected compatible staged members. The actual member schemas, mappings, history and source root remain unverified.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: SW_SAS, I_INPUT_CLOSURE
Evidence: E_D_AUDOPIN, E_WORK_ITEM_INVENTORY

Preparation / proposed procedure:

1. Set the Employee libref to the chosen portable folder containing the separately selected compatible prepared members; the withheld source value is not needed for this setup.

Validation to perform later:

- Before a future authorized run, verify the selected input members resolve through Employee from the chosen run root.

### A_INPUTS_G2: Propose the deterministic year-only dateindex calendar as setup, then establish the remaining wage, unemployment, ZIP-code and population inputs and their construction routes.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_WAGE, R_UNEMPLOY, R_SASHELP_ZIPCODE, R_POP, I_INPUT_CLOSURE
Evidence: E_D_DATEINDEX, E_D_WAGE, E_D_UNEMPLOY, E_D_ZIPCODE, E_D_POP, E_DOC_WAGE_SOURCE, E_DOC_BEA_SOURCE, E_CODE_DATEINDEX_RANGE, E_CODE_WAGE_FIELDS, E_CODE_UNEMPLOY_FIELDS, E_CODE_POP_FIELDS, E_PUBLIC_DOL_DISCLOSURE, E_PUBLIC_DOL_LCA, E_PUBLIC_BEA_POP, E_PUBLIC_BEA_POP_LINE, E_PUBLIC_BEA_API_REGISTRATION, E_PUBLIC_ROUTE_CHECK, E_CODE_DATEINDEX_CONSUMER

Preparation / proposed procedure:

1. As a proposed local setup step, create and stage Employee.dateindex as a numeric year-only calendar for 1900-2021, following the source definition at line 333 and its read/consumer at lines 334 and 342. No author-supplied generator or observed empirical calendar is assumed; preserve existing joins and do not add fields or years.
2. For Employee.wage, identify the current prepared table and its audit-position, rank, office, wage and year mappings; separately inspect the author-named DOL H-1B product before relying on it as a source route.
3. For Employee.Unemploy and Employee.pop, identify the exact BEA county-year and state-year tables and compare geography, year, units and source columns with the code joins.
4. Confirm SASHELP.ZIPCODE is available in the selected SAS runtime and exposes the required city/state/county crosswalk columns without starting SAS during this assessment.
5. Use the official BEA SAINC1 population series only as a state-population candidate and confirm its unit, vintage and prepared-table mapping; the exact county unemployment source remains unconfirmed.

Validation to perform later:

- Verify the prepared dateindex calendar follows the source-defined 1900-2021 range and verify other data fields and city/state/county or state-year key mappings against the exact selected tables.
- After separately authorized execution, compare the mapped unemployment and population columns at the documented office-year keys.

### A_INPUTS_G3: Establish the prepared individual-resume and lawsuit tables and their exact upstream mappings before a future supplied-workflow run.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_MAININFO, R_EDU, R_CERTIFICATION, R_WORKEXPERIENCE, R_OFFICECASE1, I_INPUT_CLOSURE
Evidence: E_D_MAININFO, E_D_EDU, E_D_CERTIFICATION, E_D_WORKEXPERIENCE, E_D_OFFICECASE1, E_DOC_RESUMES, E_DOC_LITIGATION_PACER, E_CATALOG_SELECTED, E_PUBLIC_PACER_SEARCH, E_PUBLIC_PACER_FEES, E_PUBLIC_ROUTE_CHECK

Preparation / proposed procedure:

1. Locate the distinct Employee.maininfo, Employee.edu, Employee.Certification1 and Employee.workexperience inputs or obtain their documented field mappings, extraction steps and coverage; the bounded official Mantheos-site searches found no interface documentation, so request the author-prepared inputs and source specification.
2. For Employee.workexperience, confirm profile/company/office identifiers, dates, locations, Auditor_Key, AuditPosition and PositionRank meanings, plus how the source records map to the program's join keys.
3. Locate or document the single Employee.Officecase1 table; the local Audit Analytics legal-case feed is only a catalog candidate and PACER requires a registered-user route. Determine whether either route supports the same required fields and office-year population without assuming undocumented hand collection.
4. Keep the author-prepared inputs primary; do not issue API, case, person or filing queries or reconstruct the empirical sample independently.

Validation to perform later:

- Before a future run, compare the actual source fields, identifier types and year ranges with the code's reads and joins, retaining unresolved field definitions or population gaps.
- After separately authorized execution, verify the named individual and office-case in-memory tables are joined to the intended test samples.

### A_WORKYEARS: Resolve only the source-level workyears/workyears1 mapping after the Employee.workexperience schema is known.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_WORKYEARS
Evidence: E_WORKYEARS_ASSIGN, E_WORKYEARS_READ

Preparation / proposed procedure:

1. Check whether workyears is an input column in the supplied author-prepared workexperience data and ask for the intended mapping if the schema does not resolve it; do not propose a replacement expression from inference alone.

Validation to perform later:

- Once the input contract is confirmed, review the exact expression in a working copy without executing or compiling the program during this assessment.

### A_SAS_SETUP: Confirm the supported SAS runtime and startup configuration required by the supplied SAS workflow.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS
Evidence: E_ENV_SAS, E_SCREEN_SAS

Preparation / proposed procedure:

1. Identify the supported SAS 9.4 release and a usable runtime in the intended environment; resolve the recorded TKELS startup diagnostic through supported system setup.
2. Confirm the Employee libref root and required configuration separately, retaining the screened connection/setup statement as withheld source content.

Validation to perform later:

- Record the supported SAS release and runtime availability result, then confirm that the configured Employee library resolves the required prepared members before any separately authorized workflow execution.


## Remaining issues and prerequisites

- I_INPUT_CLOSURE [unresolved; full_pipeline]: Treating the source-defined year-only dateindex calendar as proposed setup rather than an empirical input leaves 15 distinct dependencies: 14 Employee-library members and SASHELP.ZIPCODE. The frozen package inventory does not supply the Employee members; their contracts, mappings, producers and history remain unresolved, and SASHELP.ZIPCODE availability depends on the selected SAS runtime.
- I_WORKYEARS [unresolved; full_pipeline]: The code assigns workyears1=Prev_Workyears+(year-started_on_year), then uses workyears in WORK_YEARS=log(workyears+1). The supplied source does not establish whether a workyears input column exists or whether the names were intended to differ. Retain this specific unresolved mapping question; do not patch or test it without the input schema/author intent.
- R_AUDOPIN [undetermined]: Employee.audopin is the audit-opinion input used for engagement construction.
- R_COMPFUNDA_SIC [undetermined]: Employee.Compfunda_sic supplies historical SIC and CIK mapping joined to audit engagements.
- R_MSA [undetermined]: Employee.msa supplies city/state-to-MSA identifiers used in engagement and office construction.
- R_AUDITCHANGE [undetermined]: Employee.auditchange supplies client auditor-change dates for the engagement-year indicator.
- R_COMPANN [undetermined]: Employee.compann supplies annual client financial statement values and lagged variables.
- R_RESTATE [undetermined]: Employee.restate supplies restatement records for engagement- and office-year construction.
- R_WAGE [undetermined]: Employee.wage supplies annual audit-associate wage records joined to office-year records.
- R_UNEMPLOY [undetermined]: Employee.Unemploy supplies county-year unemployment observations that the code maps to city/state using SASHELP.ZIPCODE.
- R_SASHELP_ZIPCODE [undetermined]: SASHELP.ZIPCODE supplies city, state, county and county-name crosswalk fields for the unemployment mapping.
- R_POP [undetermined]: Employee.pop supplies state-year population observations joined to office-year records.
- R_MAININFO [undetermined]: Employee.maininfo supplies individual gender/profile information joined to work experience.
- R_EDU [undetermined]: Employee.edu supplies education, degree, institution-rank and date fields used to derive education controls.
- R_CERTIFICATION [undetermined]: Employee.Certification1 supplies profile-level CPA certification records.
- R_WORKEXPERIENCE [undetermined]: Employee.workexperience supplies individual job records, dates, locations and author-prepared audit employer/position mappings.
- R_OFFICECASE1 [undetermined]: Employee.Officecase1 supplies office/year employee-lawsuit records joined into the test samples.
- SW_SAS [unverified]: The supplied native workflow requires SAS. The existing bounded environment record leaves availability unverified after a TKELS startup failure; it does not establish a missing license. The exact author-supported SAS release is not stated in the supplied program.

## Review notes

- This assessment covers the actual supplied JAR_JC2024.sas workflow and preserves the frozen package header and provenance. The datasheet and appendix titles differ from the frozen output title; this remains a contextual attribution limitation, not a separate prerequisite for the supplied workflow.
- All 16 frozen dependency IDs D0001-D0016 remain represented in dependency review; D0007 is a source-defined numeric year-only calendar for 1900-2021, to be created and staged as proposed setup rather than treated as supplied generator code or observed empirical data. The other 15 remain distinct empirical or system inputs. The assessed endpoint remains in-memory SAS WORK sample tables; the supplied driver provides no paper estimators or export.
- The exact catalog lookup identified COMP.FUNDA and Audit Analytics feed candidates. A one-row metadata probe verified only a selected COMP.FUNDA field subset; other catalog rows were not read-probed. Author-table mappings, required fields and historical coverage remain unresolved.
- The populated draft had a duplicated E_CODE_COMPANN evidence record at the same line and quote with differing descriptions; the final draft retains one source citation and preserves the captured merge failure record.
- Official static DOL, BEA and PACER documentation supports candidate routes only; the required Employee table contracts and coverage remain unresolved. The Mantheos official-domain-limited searches returned no result. No public data or API payloads were accessed.
- The source-level workyears1 assignment versus workyears use remains unresolved pending Employee.workexperience schema/producer evidence; no name-resolution or SAS trial was performed.
- No author code was imported, executed, compiled, syntax-checked, name-resolved, or used for model/statistical/descriptive/synthetic trials. No SAS executable/startup/autoexec/PROC was invoked in this assessment; no source edits or data downloads were made.
- Process-only records remain outside all recursive evidence references: prior Python/path capture incidents, nine first-wrapper catalog refusals and their correction, this assessment's tool-failure log and captured compact-catalog helper failure, and the single metadata-catalog relocation record. The wrapper refusals did not launch the catalog CLI; the relocated metadata copy is mode 0444 with unchanged bytes/hash and verified same inode.
- The initial public-route record is preserved as version 1; the final draft uses version 2, which corrects the BEA static-documentation quote to the exact table-list text.
- Process limitation: a prior internal output displayed a filesystem-path value from task metadata. The value is not repeated or used here. A bounded metadata audit classified that field as path-like with no checked authentication pattern; this does not establish the absence of sensitive content elsewhere.
