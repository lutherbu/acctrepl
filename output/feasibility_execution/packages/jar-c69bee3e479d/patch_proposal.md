# Patch proposal: jar-c69bee3e479d

Corporate R&D Investments Following Competitors’ Voluntary Disclosures: Evidence from the Drug Development Process

DOI: 10.1111/1475-679X.12509

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The complete six-part supplied SAS preparation workflow, including the manual date-formatting stage, all required inputs, generated intermediates, and the Part 4 to Part 5 same-session WORK handoff. The separate Stata regressions are not supplied and are outside scope.

Entry points: `Zhang_SAScodeJAR.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 1/12509 - Corporate-R-D-Investments-Following-Competitors-Voluntary-Disclosures-Evidence-from-the-Drug-Development-Proce/zhang-datasheet-code-and-identifiers.zip",
      "sha256": "822fc12506f72c937699cd9dc2de04dd685aef03954f1fd92090707c3a38bf89"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "f8474a40e19e1c04af1d9204ba2538c075abb1672bafdd0f90d82f6a4bd9014d"
}
```

## Proposed actions

### ACT_TRIALS_INPUT: Resolve the missing author-prepared trial panel and its date handoff while preserving the supplied sponsor sample and date rules.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_TRIALS_CSV, ISS_CSV_CONTRACT, ISS_DATE_HANDOFF, ISS_PIPELINE_CLOSURE
Evidence: SRC_DOC_RAW, SRC_SAS_CSV, SRC_SAS_DATE, PUB_CT_FIELDS, PRB_IDENTIFIER

Preparation / proposed procedure:

1. Request the author-prepared top50_concise.csv and its source-field/sample specification; do not substitute a generic current download for the 2018 hand-collected sample.
2. If the prepared CSV is not available, request the author's exact sponsor/sample mapping and field specification before any separately authorized reconstruction. The identifier workbook is only a bounded lookup, not the trial panel.
3. Resolve how the Excel-directed date formatting is saved/exported back into the imported CSV, preserving the month-year-to-15th rule and existing source date fields.

Validation to perform later:

- In a separately authorized preparation, compare the actual CSV headers and date representations with Part 1/2 reads, the Part 3 check diagnostic, and the stated sample/coverage specification before running the ordered pipeline.

### ACT_CHECK_FIELD: Confirm whether `check` is an intended field in the author CSV or a stale diagnostic in Part 3.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_CHECK_FIELD
Evidence: SRC_SAS_CHECK_DIAGNOSTIC, SRC_SAS_CSV

Preparation / proposed procedure:

1. Check the supplied author field specification or ask the author whether `check` is expected to carry through from the CSV; if absent, confirm whether the diagnostic was intended to be removed before proposing any code edit.

Validation to perform later:

- Verify the confirmed column or diagnostic decision in the prepared-input specification; do not create a synthetic value.

### ACT_MESH_INPUT: Obtain the author-named MeSH workbook or documented compatible conversion without changing its condition normalization and hierarchy join.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_MESH_CROSSWALK, ISS_MESH_CONTRACT, ISS_PIPELINE_CLOSURE
Evidence: SRC_SAS_MESH, PUB_MESH_FORMATS, PUB_MESH_TERMS

Preparation / proposed procedure:

1. Request MeSH_C_F_diseases.xlsx or the author's exact source workbook and edition/mapping specification; this audit does not download a MeSH payload.
2. Confirm the source fields `disease` and `mesh`, hierarchy depth, edition, and the condition-to-market coverage used by Part 2.

Validation to perform later:

- Before a separately authorized run, inspect the prepared workbook's schema and verify its join mapping/version against the author's specification.

### ACT_FOLDER_CONFIG: Configure the existing single folder macro in a working copy to a host-visible project data directory; preserve all relative input, library, and output references under that root.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISS_FOLDER_CONFIG
Evidence: SRC_SAS_FOLDER_USE, INSP_WORK_ITEM

Preparation / proposed procedure:

1. Set the existing folder root to the directory that contains the prepared CSV and MeSH workbook and receives SAS datasets and DTA exports.
2. Keep the same root through Parts 1-6 and run from the project root so the Part 4 WORK handoff remains in one session.

Validation to perform later:

- Statically resolve every folder-based input, library, and export call against the configured directory before a separately authorized execution.

### ACT_MOVE_CONTENTS: Move only the Part 1 CONTENTS diagnostic so it follows the final3 producer; this preserves the diagnostic and its output intent.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISS_CONTENTS_ORDER
Evidence: SRC_SAS_CONTENTS_ORDER, SRC_SAS_DATE_YEARS

**Proposed edit:** `Zhang_SAScodeJAR.sas:106–107`
Source SHA-256: `c35f55c5e941fefbdf625a4f525fcfe1295cc082efeb4f6e147fb439dfa0c5c2`

The diagnostic currently runs before the DATA final3 producer.

Current text:
```
proc contents data=final3 varnum;
run;
```

Proposed replacement:
```

```

**Proposed edit:** `Zhang_SAScodeJAR.sas:147–147`
Source SHA-256: `c35f55c5e941fefbdf625a4f525fcfe1295cc082efeb4f6e147fb439dfa0c5c2`

Place the unchanged diagnostic immediately after final3 is produced.

Current text:
```
run;
```

Proposed replacement:
```
run;
proc contents data=final3 varnum;
run;
```

Preparation / proposed procedure:

1. Apply these proposal fragments only in a separately reviewed working copy; do not modify the packaged author source.

Validation to perform later:

- Statically confirm the PROC CONTENTS call follows the DATA final3 step, then check that final3 retains the same output variables and filters.

### ACT_SOFTWARE_SETUP: Verify the actual host's SAS runtime, SAS/ETS and SAS/ACCESS components, and spreadsheet capability through documented version/component metadata.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, SW_SAS_ETS, SW_SAS_ACCESS, SW_EXCEL, ISS_SAS_RUNTIME, ISS_SAS_ETS, ISS_SAS_ACCESS, ISS_EXCEL, ISS_PIPELINE_CLOSURE
Evidence: PRB_ENVIRONMENT, PUB_SAS_EXPAND, PUB_SAS_ACCESS_AND_DTA, SRC_SAS_DATE

Preparation / proposed procedure:

1. Confirm the SAS release, startup configuration, and local module metadata for PROC EXPAND and PC Files support through separately authorized environment metadata; do not infer licenses from the TKELS failure.
2. Confirm Microsoft Excel or a compatible workflow for the documented date preparation without opening or recalculating the identifier workbook.

Validation to perform later:

- Record version/component evidence and spreadsheet capability before any separately authorized execution; no SAS process is run here.

### ACT_EXPORT_IDENTIFIER: Preserve the two .dta exports; if the intended SAS release requires the 9.4 identifier, change both PROC EXPORT calls together in a working copy.

Scopes: full_pipeline. Type: source_edit. Certainty: conditional.
Addresses: ISS_EXPORT_IDENTIFIER
Evidence: SRC_SAS_EXPORT3, SRC_SAS_EXPORT6, PUB_SAS_ACCESS_AND_DTA, PUB_SAS_STATA_LEGACY

**Proposed edit:** `Zhang_SAScodeJAR.sas:600–600`
Source SHA-256: `c35f55c5e941fefbdf625a4f525fcfe1295cc082efeb4f6e147fb439dfa0c5c2`

The current SAS 9.4 reference labels Stata .dta output as DBMS=DTA; apply only if the intended release does not accept the legacy STATA identifier.

Current text:
```
            DBMS=STATA REPLACE;
```

Proposed replacement:
```
            DBMS=DTA REPLACE;
```

**Proposed edit:** `Zhang_SAScodeJAR.sas:1057–1057`
Source SHA-256: `c35f55c5e941fefbdf625a4f525fcfe1295cc082efeb4f6e147fb439dfa0c5c2`

Keep the Part 6 Stata export identifier consistent with the Part 3 export if required by the intended release.

Current text:
```
            DBMS=STATA REPLACE;
```

Proposed replacement:
```
            DBMS=DTA REPLACE;
```

Preparation / proposed procedure:

1. First verify the actual SAS release's supported PROC EXPORT identifier; retain DBMS=STATA if accepted.

Validation to perform later:

- In a future authorized software check, confirm both exports still use their existing .dta filenames and that the target release supports the selected identifier.

### ACT_ORDERED_PIPELINE: After missing inputs and software are resolved, preserve the six supplied parts in one ordered SAS session because Part 5 consumes Part 4 WORK datasets.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: ISS_PIPELINE_CLOSURE
Evidence: INSP_TRACE_ADDENDUM_02, SRC_SAS_PART4_OUTPUT, SRC_SAS_PART5_WORK, SRC_SAS_PART6_INPUTS

Preparation / proposed procedure:

1. Run Parts 1 through 6 in source order only after separate authorization and after the prepared CSV, MeSH workbook, path, date handoff, and SAS components are confirmed.
2. Retain the named SAS and DTA outputs, including myp_long, my_wide, fmy_decile, fmy_own123, and fmy_forstata; Part 6's Stata regressions are not supplied.

Validation to perform later:

- For a future authorized run, record each generated intermediate from its producing part and verify Part 4 WORK state is available to Part 5 in the same session; no numerical or execution verification is claimed here.


## Remaining issues and prerequisites

- ISS_CSV_CONTRACT [unresolved; full_pipeline]: The required top50_concise.csv is not packaged. Its consumed headers, sponsor/sample selection, row coverage, date values, and author construction cannot be verified; the bounded one-row sponsor identifier workbook is not a trial-level panel.
- ISS_CHECK_FIELD [unresolved; full_pipeline]: Part 3 runs PROC FREQ on `check`, but the supplied program does not assign it. The CSV or generated Part 1 data may carry it through; presence is unknown, and it is not safe to invent a field or assume the diagnostic can be deleted.
- ISS_MESH_CONTRACT [unresolved; full_pipeline]: MeSH_C_F_diseases.xlsx is not packaged. Exact author-named crosswalk edition, XLSX conversion, disease-to-mesh mapping, source field coverage, and join coverage remain unverified.
- ISS_DATE_HANDOFF [unresolved; full_pipeline]: The source directs manual Excel short-date formatting and gives a month-year-to-15th rule, while Part 1 then parses text dates. No source workbook/range or saved/exported CSV handoff is supplied. Preserve the authored rule and do not infer a replacement conversion.
- ISS_FOLDER_CONFIG [preparation; full_pipeline]: The SAS program uses one author-specific Windows folder macro for its library, inputs, and exports. That root is not the host workspace location; the root must be configured coherently before a future run.
- ISS_CONTENTS_ORDER [preparation; full_pipeline]: Part 1 executes PROC CONTENTS on final3 before the DATA final3 step creates it. This diagnostic should be moved after its producer in a working copy; the rest of the program remains unchanged.
- ISS_SAS_RUNTIME [unresolved; full_pipeline]: The supplied environment evidence leaves SAS startup unverified after TKELS failed to initialize. It does not prove a missing license or a successful runtime; no startup or author program is run in this assessment.
- ISS_SAS_ETS [unresolved; full_pipeline]: PROC EXPAND in Parts 3 and 5 requires the PROC EXPAND product component, identified by SAS documentation as SAS/ETS. Local product/version metadata are unavailable, so component availability is unverified.
- ISS_SAS_ACCESS [unresolved; full_pipeline]: The XLSX import and Stata file exports require the SAS/ACCESS PC Files interface under the documented SAS 9.4 product boundary. Local module availability is unverified; the CSV import alone does not require this interface.
- ISS_EXCEL [unresolved; full_pipeline]: The author-directed Excel date-preparation stage is part of the assessed workflow, but local Excel or compatible spreadsheet availability is not established.
- ISS_EXPORT_IDENTIFIER [unresolved; full_pipeline]: The source uses DBMS=STATA for two .dta exports. An older official example uses STATA, while the SAS 9.4 reference names DTA; the intended local release is unverified. Do not treat the legacy spelling as a confirmed defect.
- ISS_PIPELINE_CLOSURE [unresolved; full_pipeline]: The archive supplies a datasheet, a 1062-line SAS workflow, and a bounded sponsor identifier workbook, but neither required input workbook/CSV is present. D0003-D0006 are generated by prior parts, and Part 4 WORK outputs feed Part 5 in one ordered SAS session; closure is therefore incomplete until inputs, manual handoff, and components are resolved.
- REQ_TRIALS_CSV [undetermined]: Part 1 requires the author-prepared ClinicalTrials.gov extract top50_concise.csv. It filters the author's interventional drug-trial/sponsor sample and uses trial type, intervention, phase, firm, results, funding, dates, NCT identifier, Conditions, and the Part 3 diagnostic field check. The file is absent; exact headers, sponsor selection, complete period, and the Excel date handoff are unverified. The supplied sponsor-identifier workbook is not the panel.
- REQ_MESH_CROSSWALK [undetermined]: Part 2 requires the author-named MeSH_C_F_diseases.xlsx workbook to map normalized Conditions to disease and MeSH hierarchy values, producing mesh_class1/2/3. The workbook is absent; its year/version, matching rules, source columns, and disease/market coverage are unknown. Current NLM public product formats do not establish a compatible author-specific workbook.
- SW_SAS [unverified]: The six-stage native program uses Base SAS data steps/procedures plus file imports and exports. The supplied environment record reports a TKELS initialization failure and SAS startup unverified; this does not establish a missing license or a successful SAS session.
- SW_SAS_ETS [unverified]: PROC EXPAND is used in Parts 3 and 5 for MOVSUM, annual lags, and phase-2 leads. Product documentation identifies PROC EXPAND as SAS/ETS, but local module/version metadata is absent.
- SW_SAS_ACCESS [unverified]: Part 2 imports an XLSX MeSH workbook; Parts 3 and 6 export Stata .dta files. SAS 9.4 documentation describes the PC Files interface and its license boundary. The installed component and release-specific DBMS=STATA compatibility are unverified.
- SW_EXCEL [unverified]: The author explicitly directs manual Excel short-date formatting before/alongside import. No workbook/range and save/export handoff are documented, and the supplied environment record does not verify Excel or a compatible spreadsheet workflow.

## Review notes

- The frozen title and DOI are retained. The datasheet title matches the frozen title apart from punctuation/layout; no DOI is stated in the supplied datasheet.
- The target is all six supplied SAS preparation parts, not only the final script block. Part 4 produces WORK.raw2, WORK.myp0, and WORK.mkt for Part 5; preserve one ordered session and every named output. No Stata regression source is supplied.
- The identifier XLSX is a sponsor lookup artifact, not the ClinicalTrials.gov trial-level panel. Its bounded sample is one header/row with coverage_verified=false; no values or entities are used here.
- D0001 and D0002 are the missing input requirements; D0003-D0006 are generated by Parts 1, 2, 3, and 5. The exact frozen catalog name search found no ClinicalTrials.gov, MeSH, or trial-named local candidate; catalog metadata is not live-access evidence.
- SAS startup remains unverified after the supplied TKELS initialization failure. PROC EXPAND requires SAS/ETS; XLSX import and Stata exports require SAS/ACCESS Interface to PC Files under the documented SAS 9.4 boundary. Local product/component metadata are unverified.
- PROC CONTENTS on final3 precedes its producer and has a supported diagnostic-order repair proposal. `check` is called only by a diagnostic and its presence in the author CSV is unresolved. The SAS chained year/date comparisons are valid DATA-step range comparisons; no filter change is proposed.
- DBMS=STATA appears in two DTA exports; older official SAS documentation uses that identifier, while the SAS 9.4 reference names DTA. Any rename is conditional on the verified target release, with both exports kept consistent.
- Official product documentation checks were static only. ClinicalTrials.gov and NLM material does not establish the author input schema, sample history, MeSH workbook mapping, or compatibility. No SAS startup, author-program execution, dataset query/download, API/payload request, or clinical/entity lookup occurred.
