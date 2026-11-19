# Patch proposal: jar-144875ea16bb

Measuring the Prevalence of Earnings Manipulations: A Novel Approach

DOI: 10.1111/1475-679X.12578

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | restricted_access_required | blocked |

### full_pipeline

Complete author-documented workflow: all three supplied Stata drivers, all nine raw response products, generated handoffs, the manual Excel tables/figure, and both independent Table 2 population-input constructions. No compatible analysis-only bypass is supplied.

Entry points: `List Experiment.do`, `Survey.do`, `Demographics.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 1/12578 - Measuring-the-Prevalence-of-Earnings-Manipulations-A-Novel-Approach/cgv-datasheet-code-and-identifier-files.zip",
      "sha256": "099a5df389d412258976e2016f835cc34ef41b9d5364eeeeac8fd32841994a91"
    },
    {
      "path": "JAR-Volume 63/Issue 1/12578 - Measuring-the-Prevalence-of-Earnings-Manipulations-A-Novel-Approach/cgv-in-principle-accepted-version.pdf",
      "sha256": "f5c313d54e25c9764346e7566a6f649f80a9b96564edaa144a68296a1c6700bc"
    },
    {
      "path": "JAR-Volume 63/Issue 1/12578 - Measuring-the-Prevalence-of-Earnings-Manipulations-A-Novel-Approach/cgv-online-appendix.pdf",
      "sha256": "6cd9ecf6114630f506004abc99df58f0cb3f1f53ba3b5c81372b7b400160cddd"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "6cf3db8164bec9b4e16d7b412f3c508f688acf60326a0a1e702f909ca622adf8"
}
```

## Proposed actions

### A_RAW_ACCESS: Use only an already-authorized author-prepared response export if existing participant written-consent records permit that disclosure. No participant or author contact, new consent request, survey collection, or response reconstruction is part of this assessment. If prior consent cannot be documented from existing authorized records, keep the nine inputs blocked.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_LIST1_FULL, R_LIST1_LINK, R_LIST1_MAIL, R_LIST2_FULL, R_LIST2_LINK, R_LIST2_MAIL, R_DIRECT_FULL, R_DIRECT_LINK, R_DIRECT_MAIL, I_RAW_ACCESS
Evidence: E_DOC_NDA, E_INVENTORY, E_DOC_WORKFLOW

Preparation / proposed procedure:

1. Review only existing authorized documentation for prior written consent covering disclosure of the specific response exports.
2. If existing consent already permits the required disclosure, use only the corresponding author-prepared exports through an approved channel; do not collect new responses or reconstruct the survey data.
3. If applicable prior consent cannot be documented, leave all nine response requirements blocked and do not seek respondent consent as part of this assessment.

Validation to perform later:

- Before any future import, verify that existing consent documentation covers the intended data disclosure and recipient; after separately authorized receipt, compare bounded workbook header metadata with code-required fields without viewing response rows.

### A_MANUAL_EXCEL: The full native route requires the original workbook or source materials and recorded manual steps for Table 1, Table 4, and Figure 2. Do not invent a recipe or mark the native manual stage closed without that producer contract.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_MANUAL_OUTPUTS, I_MANUAL_EXCEL
Evidence: E_DOC_MANUAL, E_INVENTORY

Preparation / proposed procedure:

1. If the original workbook/source materials and written calculation steps are made available through an authorized review, preserve their identity and version.
2. Keep the three manual outputs separate from the nine response inputs and both Table 2 population inputs.

Validation to perform later:

- Compare the provided workbook/source identities and documented calculations with the named outputs without refreshing, recalculating, or executing macros during this assessment.

### A_CASED_HANDOFFS: In a working copy, change only each producer basename's case to match the downstream append spelling; preserve the datasets and all analysis choices.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_CASED_HANDOFFS
Evidence: E_LIST1_LINK_SAVE, E_LIST_LINK_APPEND1, E_LIST2_LINK_SAVE, E_LIST_LINK_APPEND2, E_SURVEY_LINK_SAVE, E_SURVEY_LINK_APPEND

**Proposed edit:** `List Experiment.do:68–68`
Source SHA-256: `b6ed34dbc44881867a21b8344fb4cdb828e45bf922680f2d9421efcb6836aaaa`

Match the produced LinkedIn basename to the existing append consumer on case-sensitive filesystems.

Current text:
```
save List1-LinkedIN, replace
```

Proposed replacement:
```
save List1-LinkedIn, replace
```

**Proposed edit:** `List Experiment.do:166–166`
Source SHA-256: `b6ed34dbc44881867a21b8344fb4cdb828e45bf922680f2d9421efcb6836aaaa`

Match the produced LinkedIn basename to the existing append consumer on case-sensitive filesystems.

Current text:
```
save List2-LinkedIN, replace
```

Proposed replacement:
```
save List2-LinkedIn, replace
```

**Proposed edit:** `Survey.do:88–88`
Source SHA-256: `084acf13a8efea4294d94911023aecd1d2f40b4ab1c2e1ec23ea7bf4e6ca179e`

Match the produced LinkedIn basename to the existing append consumer on case-sensitive filesystems.

Current text:
```
save "DirectQ-LinkedIN", replace
```

Proposed replacement:
```
save "DirectQ-LinkedIn", replace
```

Preparation / proposed procedure:

1. Apply these exact case-only edits to working copies after verifying the frozen source hashes.
2. Keep the same underlying pilot exports and retain the full, pilot, and mail branches.

Validation to perform later:

- Statically compare every changed producer basename with its unchanged consumer spelling before any separately authorized run.

### A_ROOT_SETUP: Configure ordinary input/output paths for the literal directory placeholders and establish explicit writable working roots for each driver, while preserving source files and any withheld path-setting text.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_ROOT_SETUP
Evidence: E_SOURCE_SCREEN, E_LIST1_FULL_IMPORT, E_SURVEY_FULL_IMPORT, E_LIST_APPEND, E_SURVEY_LINK_APPEND, E_DEMO_COMBINED_USE

Preparation / proposed procedure:

1. Stage unchanged source copies and document one working directory per driver with separate output locations.
2. Map each authorized input export to the literal path placeholder expected by its driver, and retain List and Survey staged outputs for downstream handoffs.
3. After List Experiment and Survey have produced their outputs, run Demographics so it can consume Combined and DirectQ-ForDemo.
4. Keep the three manual Excel outputs and both independent Table 2 population inputs in the full-pipeline scope.

Validation to perform later:

- Before a future authorized run, confirm that each configured input mapping resolves to the intended product and each output directory is writable; do not test by running an author driver during this assessment.

### A_COMP_FIELDS: Request the exact author-used Compustat annual extract/construction definition, including the revenue column, historical SIC choice, target-firm key mapping, and latest-fiscal-year rule.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_COMPUSTAT_POP, I_COMP_CONSTRUCTION
Evidence: E_DOC_TABLE2_INPUTS, E_COMP_LOOKUP, E_COMP_FIELDS, E_COMP_PROBE

Preparation / proposed procedure:

1. Ask for the firm identifiers and the exact Compustat table/columns and fiscal-year selection used for Table 2 column 5.
2. Use the existing local candidate only after confirming it matches the author-defined population and field semantics; do not construct replacement firm records independently.

Validation to perform later:

- Compare the supplied specification to the bounded candidate fields and verify key/history/construction compatibility before claiming the route verified.

### A_FOUNDED_RECORDS: Request the authors' exact random-500 target-firm list, founding-decade crosswalk, and source records or their retained prepared output; do not independently recreate the sample or collect new records.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_FOUNDED_DATES, I_FOUNDING_SAMPLE_RECORDS
Evidence: E_DOC_TABLE2_INPUTS, E_PUBLIC_SEC, E_PUBLIC_YAHOO, E_INVENTORY

Preparation / proposed procedure:

1. Request the random-500 identities and the decade-founded result with the source record for each firm.
2. If the authors provide a prepared file, keep it separate from Compustat and preserve the author-defined sample selection and construction history.

Validation to perform later:

- Verify that the supplied records map to exactly the author-defined target-firm sample and support the requested founding-decade field; do not infer coverage from a generic public filing/profile page.

### A_KICT_SETUP: Obtain the approved kict package/version information and set up the exact command in the execution environment before attempting either authored design-effect branch.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_KICT, I_KICT_ADDON
Evidence: E_KICT_DEFF, E_STATA_KICT

Preparation / proposed procedure:

1. Ask the authors or software administrator for the exact kict source/version and any documented prerequisites.
2. After separately authorized setup, verify the exact kict command with metadata-only checks; retain both deff calls and all authored observation/data choices.

Validation to perform later:

- Confirm the exact command is available without invoking kict deff on study or synthetic data during this assessment.

### A_EXCEL_SETUP: Confirm the authorized Excel application and version used for the manual output branch; retain the authors' original workbook and workbook engine assumptions.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_EXCEL, I_EXCEL_UNVERIFIED
Evidence: E_DOC_MANUAL, E_ENVIRONMENT_PROBE

Preparation / proposed procedure:

1. Confirm whether Microsoft Excel is available in the intended execution environment and record its version.
2. Do not substitute another spreadsheet engine without evidence that it preserves the authors' manual workflow.

Validation to perform later:

- After the workbook is supplied and a future run is authorized, check the specified application/version and manual calculation steps without recalculating during this assessment.


## Remaining issues and prerequisites

- I_RAW_ACCESS [unresolved; full_pipeline]: The datasheet records a legally binding consent gate: response data may not be disclosed without participants' prior written consent. All nine named response exports are absent from the supplied package, and the package does not establish whether prior consent already authorizes release or whether a compliant author-prepared export is obtainable. This is an actual documented access condition, not a finding that consent was denied or that authorization is absent. Until an already-authorized response-level route is documented, the required exports remain blocked.
- I_MANUAL_EXCEL [unresolved; full_pipeline]: The full native scope includes Table 1, Table 4, and Figure 2, which the datasheet says were produced manually in Excel. The registered release has no workbook, underlying source materials, or manual calculation steps, so this manual producer stage is not closed. Classifying every frozen checklist ID does not supply the missing manual producer contract.
- I_CASED_HANDOFFS [preparation; full_pipeline]: Three producer basenames differ from their consumer spellings only by the case of the final N/n: List1-LinkedIN/LinkedIn, List2-LinkedIN/LinkedIn, and DirectQ-LinkedIN/LinkedIn. Align the case in the working copies before running on a case-sensitive filesystem.
- I_ROOT_SETUP [preparation; full_pipeline]: The supplied code uses literal DIRECTORY NAME/RAW DATA DIRECTORY NAME placeholders and its intended per-driver working roots and output mappings are not established. Treat these as ordinary path configuration; source-screen masking of separate path-setting blocks does not prove that a real private author path was supplied. Configure a coherent working copy without exposing withheld text or changing the original source files.
- I_COMP_CONSTRUCTION [unresolved; full_pipeline]: A local Compustat annual-file candidate is readable, but the required field mapping between revt and sale, SIC field semantics, target-firm key crosswalk, and latest-fiscal-year selection/coverage are not specified or verified.
- I_FOUNDING_SAMPLE_RECORDS [unresolved; full_pipeline]: The author-collected random-500 firm identities, founding-decade records, supporting sources, and firm-to-target-sample crosswalk are not in the release. Static SEC/Yahoo pages establish only candidate source categories, not the needed records or coverage.
- I_KICT_ADDON [preparation; full_pipeline]: Both authored design-effect branches require kict deff, and the exact kict command is unavailable in the metadata-only which probe.
- I_EXCEL_UNVERIFIED [preparation; full_pipeline]: The required manual Excel branch is documented, but an Excel runtime and version have not been verified on the host.
- R_LIST1_FULL [restricted_access_required]: List 1 full-launch response workbook (List Group 1 - Full Launch 2_26_24.xlsx); a distinct raw response product required by the supplied workflow.
- R_LIST1_LINK [restricted_access_required]: List 1 LinkedIn pilot response workbook (List Group 1 - LinkedIn Pilot 10_2_23.xlsx); a distinct raw response product required by the supplied workflow.
- R_LIST1_MAIL [restricted_access_required]: List 1 mail pilot response workbook (List Group 1 - Mail Pilot 10_2_23.xlsx); a distinct raw response product required by the supplied workflow.
- R_LIST2_FULL [restricted_access_required]: List 2 full-launch response workbook (List Group 2 - Full Launch 2_26_24.xlsx); a distinct raw response product required by the supplied workflow.
- R_LIST2_LINK [restricted_access_required]: List 2 LinkedIn pilot response workbook (List Group 2 - LinkedIn Pilot 10_2_23.xlsx); a distinct raw response product required by the supplied workflow.
- R_LIST2_MAIL [restricted_access_required]: List 2 mail pilot response workbook (List Group 2 - Mail Pilot 10_2_23.xlsx); a distinct raw response product required by the supplied workflow.
- R_DIRECT_FULL [restricted_access_required]: Direct-question full-launch response workbook (Direct Q - Full Launch 2.26.24.xlsx); a distinct raw response product required by the supplied workflow.
- R_DIRECT_LINK [restricted_access_required]: Direct-question LinkedIn pilot response workbook (Direct Q - LinkedIn Pilot 7_6_23.xlsx); a distinct raw response product required by the supplied workflow.
- R_DIRECT_MAIL [restricted_access_required]: Direct-question mail pilot response workbook (Direct Q - Mail Pilot 10_2_23.xlsx); a distinct raw response product required by the supplied workflow.
- R_MANUAL_OUTPUTS [undetermined]: Source workbook(s), underlying inputs, and manual recipe for the Excel-produced Table 1, Table 4, and Figure 2.
- R_COMPUSTAT_POP [undetermined]: Compustat firm records supplying SIC-based industry and the target firms' revenue from their latest fiscal year for Table 2 column 5.
- R_FOUNDED_DATES [undetermined]: Author-collected founding decade and supporting firm-to-sample/source crosswalk for a random sample of 500 target-sample firms used in Table 2 column 5.
- SW_KICT [preparation_required]: The required kict deff command is not available in the Stata which-only probe; package/version setup and exact command availability require confirmation.
- SW_EXCEL [unverified]: Excel is required by the datasheet's manual Table 1, Table 4, and Figure 2 branch; host availability/version is not established.

## Review notes

- The assessed target is the full author-documented pipeline. All three supplied Stata drivers and all 25 frozen checklist IDs remain represented, but `closure_complete` is false because the required manual Excel producer for Tables 1 and 4 and Figure 2 lacks its workbook/source materials and calculation steps. Checklist coverage alone does not close that native stage.
- The nine response workbooks remain separate inputs. The datasheet states an actual prior-written-consent condition on disclosure; the route is blocked pending evidence that existing consent permits the needed disclosure. The package does not establish whether consent exists or has been denied, nor whether an authorized export is obtainable. No respondent contact or request for new consent was made or proposed; no new data were collected or reconstructed.
- Tables 1 and 4 and Figure 2 are separate manual Excel outputs. The source workbook/materials and manual recipe are absent, and Excel availability is unverified.
- Table 2 column 5 has two jointly required, separate constructions: Compustat SIC/revenue from each target firm's latest fiscal year, and founding decade for an author-selected random 500 target firms. A local Compustat candidate was read only through a bounded one-row metadata probe; the exact revenue field, SIC semantics, firm key, year-selection/history, and population coverage remain unknown. The random-500 identity/crosswalk and source records are also absent. SEC/Yahoo pages are unverified candidates only; no external company payloads were retrieved.
- The code uses Aware in missing-value statements while other stages retain Awareness. Aware could be a unique abbreviation of Awareness if Stata's imported namespace and varabbrev setting permit it; this is neither a proven alias nor a supported missing-variable finding. No rename is proposed.
- Both authored kict deff calls remain required. The second keeps the source's set obs 1577 and designated observation values; this author-specified design-effect test was preserved without a runtime trial or methodological repair.
- Three case-only staged-file mismatches remain proposed as exact working-copy basename edits. Literal directory placeholder strings are visible in import statements; treat them as ordinary path configuration, and do not infer that conservative screening of separate path-setting blocks proves a real private path. No author source was edited or executed, and raw startup/software logs remain opaque.
- Available Stata and command claims use metadata-only probes. Excel remains unverified, and kict is unavailable in the exact which-only check. The final assessment does not claim execution success.
