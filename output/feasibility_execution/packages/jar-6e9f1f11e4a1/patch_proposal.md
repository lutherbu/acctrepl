# Patch proposal: jar-6e9f1f11e4a1

Do Borrowers Intentionally Avoid Covenant Violations? A Reexamination of the Debt Covenant Hypothesis

DOI: 10.1111/1475-679X.12456

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The complete author-documented SAS preparation workflow: Compustat and Dealscan preparation, three covenant sample exports, manual EDGAR contract review and threshold spreadsheet completion, then three SAS import/merge/preparation programs and their Stata exports. The bundled Stata files are described as sample identifiers, not analysis panels; no separate analysis-only scope is supported by this package.

Entry points: `1_cstat.sas`, `2_cov_cleanup.sas`, `3a_crsampleexport.sas`, `3b_nwsampleexport.sas`, `3c_desampleexport.sas`, `4a_crdataprep.sas`, `4b_nwdataprep.sas`, `4c_dedataprep.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 5/12456 - Do-Borrowers-Intentionally-Avoid-Covenant-Violations-A-Reexamination-of-the-Debt-Covenant-Hypothesis/bd-datasheet-code-and-identifiers.zip",
      "sha256": "6c5805d3b7bcccb5dff92461b3aef55e062870794db2518c56af6c03583a0da5"
    },
    {
      "path": "JAR-Volume 60/Issue 5/12456 - Do-Borrowers-Intentionally-Avoid-Covenant-Violations-A-Reexamination-of-the-Debt-Covenant-Hypothesis/bd-online-appendix.pdf",
      "sha256": "3b22e54d10c30c822782718007bfb4eba6ce04e2061fde1a6f4471569390cb49"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "a4d9e6e236e5464e3a793cfbb2d376c20157ebf26f346490028b9f0a89932d57"
}
```

## Proposed actions

### ACT_CONFIRM_LOCAL_TABLES: Use the locally readable COMP.FUNDQ/FUNDA and DEALSCAN facility/financialcovenant/networthcovenant candidates as compatible product-family candidates; their sampled names are supported, while required history, populations, actual field definitions, and value compatibility remain unknown. The authors' 2020 pull dates document provenance, not a requirement to reproduce the original byte snapshots. Stage the unchanged Dealscan tables into the writable a-library root, and point comp at the local Compustat root.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_FUNDQ, REQ_FUNDA, REQ_FACILITY, REQ_FINANCIAL_COVENANT, REQ_NETWORTH_COVENANT, ISS_CLOSURE
Evidence: CAT_COMPUSTAT, CAT_DEALSCAN, PRB_FUNDQ, PRB_FUNDA, PRB_FACILITY, PRB_FINANCIAL_COVENANT, PRB_NETWORTH_COVENANT, SRC_DATASHEET_PRODUCTS, TRACE_WORKFLOW

Preparation / proposed procedure:

1. Confirm the Compustat quarterly and annual field types and usable fiscal-year history from 1980, including the annual SIC join, annual backfill, lag construction, and rolling-quarter measures described by 1_cstat.sas.
2. Confirm the Dealscan table populations, actual facility/covenant field definitions, and value compatibility for the author joins; investigate a product revision only if a material mismatch is specifically supported. The 2020 pull dates alone do not require byte-identical copies; do not substitute the unrelated IBES-CRSP catalog hit for the Dealscan-Compustat workbook.
3. Configure comp to the local Compustat library, stage the three exact Dealscan SAS files into the writable a root, and then produce cstat_final and fac_type_cov_fullsamp with the supplied first and second programs.

Validation to perform later:

- Confirm the verified source history covers the authored filters and downstream join/lead/lag windows before running the full workflow.
- Confirm cstat_final and fac_type_cov_fullsamp are produced in the shared library root and contain the fields consumed by the three sample-export branches.

### ACT_CONFIRM_LINK_WORKBOOK: Locate the exact author-named Dealscan-Compustat Linking Database workbook. It must contain the link_data sheet and bcoid/facid/gvkey mapping expected by stages 3a/3b/3c and 4b. The package inventory and frozen catalog search provide no matching copy; an unrelated IBES-CRSP link table is not a substitute.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_LINK, ISS_CLOSURE, ISS_HANDOFF
Evidence: SRC_SAMPLE_EXPORT, SRC_NW_CROSSWALK, CAT_LINK, INS_PACKAGE_INVENTORY, TRACE_WORKFLOW

Preparation / proposed procedure:

1. Check for an author-prepared copy of Dealscan-Compustat Linking Database.xlsx and, if absent, identify the documented WRDS or author-provided source for this exact workbook without replacing its join keys.
2. Place the verified workbook in the configured local-folder path used by the sample exports and net-worth preparation program.

Validation to perform later:

- Confirm the link_data worksheet exists and exposes compatible bcoid, facid, and gvkey fields for the supplied joins.

### ACT_COMPLETE_COVENANT_WORKBOOKS: Preserve the documented manual SEC-threshold stage between the three SAS exports and the three SAS imports. Use author-prepared completed workbooks as the primary alternatives if exact compatible copies are available; otherwise follow the README's manual filing review and quarter-entry procedure. The audit did not query issuers or retrieve filings.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: REQ_SEC_FILINGS, REQ_CR_THRESHOLDS, REQ_NW_THRESHOLDS, REQ_DE_THRESHOLDS, ISS_CLOSURE, ISS_HANDOFF
Evidence: SRC_README_MANUAL, SRC_PREP_INPUT, SRC_NW_PREP_INPUT, SRC_DE_PREP_INPUT, SRC_CR_Q_RANGE, SRC_NW_Q_RANGE, SRC_DE_Q_RANGE, PUB_SEC_SEARCH, PUB_SEC_INDEX, CAT_SEC_LOCAL, PRB_SEC_RAW_ROOT, PRB_SEC_PARSED_ROOT, PRB_LM10X_ROOT, INS_PACKAGE_INVENTORY, TRACE_WORKFLOW

Preparation / proposed procedure:

1. First locate exact author-prepared cr_packages_complete.xlsx, NW_packages_complete.xlsx, and de_packages_complete.xlsx files; inspect their worksheets and fields against the supplied SAS import contracts before choosing them as primary inputs.
2. If no compatible completed workbooks are available, run the authored manual stage: use the three package exports to identify required borrowers and facilities, review relevant 8-K/10-Q/10-K or other SEC filings, record each threshold step by quarter from loan inception, and retain static thresholds once where the README permits.
3. Use exact borrower-specific files from the documented SEC raw, parsed, or LM10X roots when coverage is verified; otherwise use the official EDGAR search route. Keep the current-ratio, net-worth, and debt-to-EBITDA workbooks separate and save the exact import filenames under local folder.

Validation to perform later:

- Check issuer, form, filing-date, loan-inception, and maturity coverage for each required contract before recording a complete threshold history; the present root-only probes do not establish such coverage.
- Check that the current-ratio workbook contains required package fields and q1-q87, the net-worth workbook contains its step/escalator fields and q1-q61, and the debt-to-EBITDA workbook contains the fullsamp sheet and q1-q40 before SAS import.
- Confirm quarterly thresholds extend through maturity and preserve the source's static-threshold carry-forward behavior.

### ACT_RESOLVE_SAS_COMPONENTS: Resolve the existing SAS 9.4 startup failure, then establish that Base SAS, SAS/ETS for PROC TIMEDATA, and SAS/ACCESS 9.4 Interface to PC Files for XLSX/DTA are available on the target system. Confirm a spreadsheet editor that preserves the required XLSX sheets and headers. The observed TKELS diagnostic is not evidence of missing entitlement; no SAS/STAT or Stata analysis runtime is inferred.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, SW_SAS_ETS, SW_SAS_ACCESS_PCF, SW_EXCEL, ISS_SAS_STARTUP
Evidence: PRB_SAS_ENV, PUB_SAS_ETS, PUB_SAS_ACCESS, PUB_CORR_BASE, SRC_TIMEDATA, SRC_DTA_EXPORT, SRC_README_MANUAL

Preparation / proposed procedure:

1. Have the SAS 9.4 runtime startup issue checked so an initialized SAS session is available; retain the existing diagnostic and do not infer license status from it.
2. Confirm installed SAS components and site entitlement for SAS/ETS and SAS/ACCESS Interface to PC Files, and identify a compatible spreadsheet editor for the manual XLSX stage.

Validation to perform later:

- Confirm the SAS runtime initializes and that the required SAS/ETS and SAS/ACCESS components are available before starting the author sequence.
- Confirm the selected editor can preserve the workbook sheets and column names used by the SAS imports.

### ACT_CONFIGURE_PATHS: Supported preparation: configure comp, my, and a to the known source and shared writable roots, choose one SAS working directory, create its literal local folder subdirectory, and apply the supported 4b working-copy edit so it reads the same relative crosswalk location as 3a/3b/3c. These path and library changes are routine setup; the actual crosswalk and completed threshold workbooks remain separate unresolved inputs.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: REQ_LINK
Evidence: SRC_LIBNAME_ROOTS, SRC_SAMPLE_EXPORT, SRC_PREP_INPUT, SRC_NW_PREP_INPUT, SRC_DE_PREP_INPUT, SRC_NW_CROSSWALK, TRACE_WORKFLOW

**Proposed edit:** `4b_nwdataprep.sas:49–49`
Source SHA-256: `d416811902c9ec8b4ac28b0af118777c37c95a42f759350bcb0f00717138513e`

Use the same project-relative workbook location as the three sample-export programs so that stages 3a/3b/3c and 4b can consume the same link_data workbook. Apply only in a working copy.

Current text:
```
PROC IMPORT OUT= dc_link DATAFILE= "[redacted-path-5f883f1bfd5f]" 
```

Proposed replacement:
```
PROC IMPORT OUT= dc_link DATAFILE= "local folder\Dealscan-Compustat Linking Database.xlsx" 
```

Preparation / proposed procedure:

1. Set the SAS working directory once and create its local folder subdirectory; place the link workbook there when an exact compatible copy is available.
2. Map comp to the local Compustat directory and map my and a to the same writable project data root; stage the catalogued Dealscan facility and covenant input files in that a root before step 2.
3. After stages 3a/3b/3c write the three package spreadsheets to the working directory, place compatible author-prepared or manually completed workbooks under local folder with the exact names imported by 4a/4b/4c.

Validation to perform later:

- Confirm all relative spreadsheet imports resolve from the selected working directory and the 4b link path resolves to the same workbook used by the three sample-export programs.
- Confirm cstat_final and fac_type_cov_fullsamp are written to the shared library root before their downstream consumers run.

### ACT_RUN_NATIVE_SEQUENCE: Once the input, workbook, software, and path contracts are resolved, follow the complete author-supplied preparation sequence. The six Stata DTA files are outputs of SAS preparation; the package supplies no Stata analysis program, so no separate analysis-only route or Stata execution is specified.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: REQ_FUNDQ, REQ_FUNDA, REQ_FACILITY, REQ_FINANCIAL_COVENANT, REQ_NETWORTH_COVENANT, REQ_LINK, REQ_SEC_FILINGS, REQ_CR_THRESHOLDS, REQ_NW_THRESHOLDS, REQ_DE_THRESHOLDS, SW_SAS, SW_SAS_ETS, SW_SAS_ACCESS_PCF, SW_EXCEL, ISS_CLOSURE, ISS_HANDOFF, ISS_SAS_STARTUP
Evidence: SRC_README_ORDER, SRC_README_MANUAL, SRC_CSTAT_OUTPUT, SRC_COV_OUTPUT, SRC_SAMPLE_EXPORT, SRC_PREP_INPUT, SRC_NW_PREP_INPUT, SRC_DE_PREP_INPUT, SRC_DTA_EXPORT, TRACE_WORKFLOW

Preparation / proposed procedure:

1. Run 1_cstat.sas using COMP.FUNDQ/FUNDA and produce my.cstat_final.
2. Run 2_cov_cleanup.sas using the three Dealscan tables; produce a.fac_type_cov_fullsamp for the next three branches and retain a.fac_cov_fullsamp as an unused supplied output.
3. Run 3a_crsampleexport.sas, 3b_nwsampleexport.sas, and 3c_desampleexport.sas using fac_type_cov_fullsamp, cstat_final, and the link_data workbook; produce cr_packages.xlsx, nw_packages.xlsx, and de_packages.xlsx in the SAS working directory.
4. Perform the documented manual EDGAR/spreadsheet step or use exact compatible author-completed workbook alternatives; provide cr_packages_complete.xlsx, NW_packages_complete.xlsx, and de_packages_complete.xlsx at the expected local-folder paths.
5. Run 4a_crdataprep.sas, 4b_nwdataprep.sas, and 4c_dedataprep.sas using cstat_final, their completed threshold workbook, and the link workbook required by 4b; preserve each branch's quarter-level and loan-level SAS/DTA outputs.

Validation to perform later:

- Verify each generated intermediate exists under the configured library/current-directory roots before launching its consumer.
- Verify all six output names are created and remain identifiable as the current-ratio, net-worth, and debt-to-EBITDA quarter-level and loan-level outputs.


## Remaining issues and prerequisites

- ISS_CLOSURE [unresolved; full_pipeline]: The catalog and bounded reads identify locally readable Compustat and Dealscan candidates with the requested sampled field names. The datasheet's 2020 pull dates record source provenance; no original-byte identity condition is imposed. Required Compustat history, Dealscan populations, and actual field/value definitions remain unverified; no specific material product mismatch is established. No matching link workbook is present in the package or catalog search, and no completed threshold workbook is inventoried. Exact borrower filing coverage and manual-workbook contents remain unresolved.
- ISS_HANDOFF [unresolved; full_pipeline]: The supplied sequence requires three sample exports, manual EDGAR/spreadsheet completion, and three SAS imports. No completed threshold workbooks or exact crosswalk workbook are inventoried, and their schemas, mapping/quarter coverage, and manual filing coverage are unresolved. The shared SAS library roots, working directory, local folder, and 4b same-workbook path edit are known preparation steps, not unresolved blockers.
- ISS_SAS_STARTUP [unresolved; full_pipeline]: The assigned environment record shows two failed SAS 9.4 startup attempts with a TKELS extension load diagnostic. This leaves runtime availability and product components unverified; it is not evidence of missing license or entitlement.
- REQ_FUNDQ [undetermined]: Compustat quarterly fundamentals used to build quarterly actual covenant measures and later add filing CIK identifiers. The readable local COMP.FUNDQ candidate has the requested sampled field names; the author program filters from fiscal year 1980 and uses rolling quarters, while usable history, population, field definitions, and value compatibility remain unverified.
- REQ_FUNDA [undetermined]: Compustat annual fundamentals used to add fiscal-year SIC and backfill missing quarterly values, including lagged earnings. The author program filters from fiscal year 1980; usable history and compatibility remain unverified.
- REQ_FACILITY [undetermined]: Dealscan facility table used for package, facility, borrower, dates, amount, maturity, company, and ticker fields in covenant cleanup. The readable local DEALSCAN.FACILITY candidate has the requested sampled field names; population, full coverage, field definitions, and value compatibility remain unverified.
- REQ_FINANCIAL_COVENANT [undetermined]: Dealscan financial-covenant table with covenant type and initial ratio/amount plus event/final values; separately consumed in covenant cleanup. The readable local DEALSCAN.FINANCIALCOVENANT candidate has the requested sampled field names; population, full coverage, field definitions, and value compatibility remain unverified.
- REQ_NETWORTH_COVENANT [undetermined]: Separate Dealscan net-worth covenant table appended to financial-covenant records. The readable local DEALSCAN.NETWORTHCOVENANT candidate has the requested sampled field names; population, full coverage, field definitions, and value compatibility remain unverified.
- REQ_LINK [undetermined]: Dealscan-Compustat Linking Database workbook, `link_data` worksheet, consumed by all three sample exports and again by the net-worth preparation program. It must map borrower/facility identifiers to GVKEY; no exact workbook or matching catalog table is verified.
- REQ_SEC_FILINGS [undetermined]: Company SEC filings used in the required manual covenant-contract review between sample export and completed threshold spreadsheets. The author names 8-K, 10-Q, 10-K, or other relevant filings; exact issuers, forms, dates, and coverage depend on missing loan workbooks and were not queried.
- REQ_CR_THRESHOLDS [undetermined]: Current-ratio covenant threshold workbook completed after SEC filing review. The 4a program imports cr_packages_complete.xlsx and consumes package/facility metadata plus q1-q87 threshold fields. No completed workbook is inventoried; an author-prepared completed workbook can be used as the primary alternative to repeating the manual EDGAR work if it becomes available.
- REQ_NW_THRESHOLDS [undetermined]: Net-worth covenant threshold workbook completed after SEC filing review. The 4b program imports NW_packages_complete.xlsx and consumes package metadata, escalation/step fields, and q1-q61 thresholds. No completed workbook is inventoried; an author-prepared completed workbook can be used as the primary alternative to repeating manual EDGAR work if it becomes available.
- REQ_DE_THRESHOLDS [undetermined]: Debt-to-EBITDA covenant threshold workbook completed after SEC filing review. The 4c program imports de_packages_complete.xlsx from the `fullsamp` sheet and consumes package metadata plus q1-q40 thresholds. No completed workbook is inventoried; an author-prepared completed workbook can be used as the primary alternative to repeating manual EDGAR work if it becomes available.
- SW_SAS [unverified]: All eight supplied entry programs are SAS. The assigned environment artifact records SAS startup failing at TKELS; Base SAS runtime availability is therefore unverified, and the diagnostic does not establish missing entitlement. PROC CORR is documented as a Base SAS procedure; no separate SAS/STAT dependency is inferred.
- SW_SAS_ETS [unverified]: PROC TIMEDATA is used in the covenant preparation programs and is documented in the SAS/ETS 14.3 User's Guide. The installed product and entitlement were not established by the failed runtime probe.
- SW_SAS_ACCESS_PCF [unverified]: The sources import and export XLSX files and export Stata DTA files. Official SAS/ACCESS 9.4 documentation identifies XLSX and DTA support; actual component availability and site entitlement are unverified. The DTA output does not imply a Stata analysis runtime because no supplied Stata consumer exists.
- SW_EXCEL [unverified]: The author workflow requires a manual spreadsheet stage to record quarter-by-quarter covenant terms before SAS import. The package does not specify an editor or version, and compatibility with the workbook structure has not been checked.

## Review notes

- Final scope remains the complete supplied SAS preparation workflow in README order: 1_cstat.sas, 2_cov_cleanup.sas, 3a/3b/3c sample exports, manual SEC filing and threshold-spreadsheet completion, then 4a/4b/4c imports and DTA exports. All 30 dependency IDs are reviewed in the linked trace. Catalog and bounded reads identify locally readable Compustat and Dealscan product-family candidates with requested sampled names; the datasheet's 2020 pull dates are provenance, not a byte-identity requirement. Required history, population, field/value definitions, and any specifically supported material mismatch remain unverified. The exact crosswalk and completed threshold workbooks are not inventoried, and manual filing coverage is unknown. Shared roots, working directory, local folder, and the 4b same-workbook path are supported preparation steps. The SAS environment probe's TKELS failure is not evidence of missing entitlement. The three bundled DTA files contain identifiers only and do not support an analysis-only scope.
- Process history: the first draft metadata-check command was passed inline, and no complete helper was saved before execution. Its first assertion raised KeyError('import_manifest_sha256'); the command, cwd, exit code, stdout, and stderr visible from that tool invocation are recorded retrospectively in probes/metadata_check_incident.json. No separate pre-execution wrapper or standalone stream logs were captured; that later descriptor is not an originally saved runner and no missing bytes were reconstructed. The failed check did not read or alter author data, and no author-source finding is based on the error. This process-history record is not assessment evidence and its ID is not referenced in any evidence_ids list.
- Pre-correction pair, draft, trace, finalizer runner, record, streams, and submitted-copy bytes were hash-verified in the coordinator checkpoint manifest and copied to probes/checkpoint_before_semantic_correction_20261110T181325Z/. The attempt-002 submitted copy's mode 0444 is ordinary owner-changeable read-only permissions, not immutable storage.
