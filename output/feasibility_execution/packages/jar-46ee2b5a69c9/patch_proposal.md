# Patch proposal: jar-46ee2b5a69c9

Multimarket Contact and Mutual Forbearance in Audit Markets

DOI: 10.1111/1475-679X.12406

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied author workflow: main 2-digit SIC construction and sample selection, the separate FF48 sensitivity branch, and the Table 9 switcher-choice preparation and analysis branch.

Entry points: `create datasets.do`, `retrieve compustat variables.do`, `create feedataset.do`, `Final sample selection.do`, `Final sample selection Table 9.do`, `create datasets ff48.do`, `create feedataset ff48.do`, `Final sample selection ff48 industries.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 5/12406 - Multimarket-Contact-and-Mutual-Forbearance-in-Audit-Markets/dgkw-datasheet-code-and-identifiers.zip",
      "sha256": "42243152cab1338b37b4baa378689308b78346871023f0c72c6183d129325d9a"
    },
    {
      "path": "JAR-Volume 59/Issue 5/12406 - Multimarket-Contact-and-Mutual-Forbearance-in-Audit-Markets/dgkw-online-appendix.pdf",
      "sha256": "bcb1be52d1d4e5a369e3abdf3e5973e8756535c3a797116a02399313413ba68d"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "ce3e805e7af9cce8674f984a35b74c8e066b9e123eb0f624f0ae4a8a07fa7d3a"
}
```

## Proposed actions

### A-INPUT-DELIVERY: Obtain compatible inputs for every supplied branch while preserving source-specific fields, joins, and year-history requirements.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R-AUDITANALYTICS, R-COMPUSTAT, R-FF48-START, R-MWSOX, R-RESTATEMENTS, R-SEGMENTS, R-MATERIALWEAKNESS, R-GOINGCONCERN
Evidence: E-AA-FEED-PRICING, E-CATALOG-LOOKUP, E-COMP-FIELDS, E-CREATE-EXTERNALS, E-DATASHEET-SOURCES, E-FEED-JOINS, E-FF48-START, E-MAIN-RAW, E-MATERIALWEAKNESS, E-WORKFLOW-TRACE, E-WRDS-SUBSCRIBER-ACCESS

Preparation / proposed procedure:

1. Provide integrated AuditAnalytics fields company_fkey, fiscal_year, audit_fees, auditor_fkey, sic_code_fkey, bus_state, and bus_county, with source period and row-coverage details; FEED03 is only an unverified candidate.
2. Provide Compustat fields consumed by the main merge, including datadate, fyear, cik, and the financial variables used downstream. Verify that the delivered CIK field and AA company_fkey support the explicit Access SQL join; record the retrieval comment's gvkey discrepancy without assuming a conversion.
3. Identify the producer and required fields for auditanalytics20112019_start.dta.
4. Provide distinct Mwsox.txt, restatements.txt, segments.txt, and materialweakness.txt inputs with the fields and years read by the source.
5. Provide the goingconcern table with fiscal_year_of_op, company_fkey, and going_concern, including source and compatible population.
6. Record the delivered source-year coverage and author boundary treatment for lead and prior-row variables; ask whether extended years were used for published-output fidelity, without imposing new 2003/2016 rows or changing sample filters.

Validation to perform later:

- Compare delivered fields, key types, row units, populations, and year ranges with source reads and manual join keys.
- Review actual edge-year coverage and documented boundary treatment against the authored lead/prior-row logic; do not require extra observations or alter the sample without author-supported evidence.

### A-MANUAL-HANDOFFS: Document Excel and Access handoffs across the main, FF48, and Table 9 branches, including exact schemas and switcher selector values.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-MANUAL-HANDOFFS, I-TABLE9-HANDOFF
Evidence: E-CREATE-MANUAL, E-CREATE-EXTERNALS, E-FEED-JOINS, E-TABLE9-CHOICE, E-TABLE9-TABLE10-INPUT, E-FF48-FEED

Preparation / proposed procedure:

1. For each Excel deduplication, identify source sheet/file, key fields, retained-row rule, and exact output schema/path.
2. For each Access join, provide source schemas, output columns, duplicate handling, and row-cardinality expectations. For Compustat, verify the actual SQL key pair AAData.company_fkey/Compustatdata.cik and year_aa/fiscal_year; retain the retrieval comment's gvkey reference as a documentation discrepancy.
3. For Table 9, provide switcher msa_number, sic2digit, fiscal_year values and Table10.dat fields, and document the Table10_1, msandranks_auditfirms, and switchers assembly.
4. For FF48, document the Access table fields and how they provide measures plus existing een/n_obs_client values.

Validation to perform later:

- Compare each handoff schema to downstream reads and join predicates.
- Check key types, duplicate policy, cardinality, and output paths before a future authorized run.

### A-CLARIFY-BRANCH-CONTRACTS: Resolve source-specific incomplete expressions, field mappings, rank limits, file handoffs, and period/history contracts evidenced by the supplied programs.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I-FF48-HANDOFF, I-KLAD-FRAGMENT, I-MAIN-RANK-BOUNDS, I-COMPUSTAT-JOIN, I-DATE-HISTORY, I-FF48-PERIOD
Evidence: E-COMP-FIELDS, E-DATASHEET-SOURCES, E-FEED-JOINS, E-FF48-MISMATCH, E-FF48-PERIOD, E-FIRSTYEAR-HISTORY, E-KLAD-FRAGMENT, E-MAIN-CASE-FILTER, E-MAIN-FORWARD, E-MAIN-MM-RANK-BOUNDS, E-WORKFLOW-TRACE

Preparation / proposed procedure:

1. Identify the actual producer/schema for Ymultimarketmatrix_ff48.dta; do not assume it aliases multimarketmatrix_ff48.dta.
2. Identify the producer and intended expressions for res_begin_date/res_end_date and the incomplete KLAD statements.
3. Confirm the intended mm_rank upper bound without changing the authored algorithm.
4. Verify that delivered Compustat CIK and AA company_fkey types/populations support the explicit SQL join on year_aa/cik; record the separate gvkey comment discrepancy without inventing a conversion.
5. Record actual input coverage and intended boundary treatment for next-row and prior-row variables, and clarify whether extended years were used for the reported output; preserve the authored sample filters and do not impose extra 2003/2016 rows.

Validation to perform later:

- Compare clarified producers, fields, keys, and periods with probes/workflow_trace_02.json.
- Review source changes statically; do not execute, import, compile, or syntax-test author code.

### A-SAVE-SYNTAX: In a working copy, remove using from the Table 9 save command while retaining the same output filename.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I-STATA-SAVE-SYNTAX
Evidence: E-STA-SAVE-MANUAL, E-TABLE9-TESTS

**Proposed edit:** `Final sample selection Table 9.do:133–133`
Source SHA-256: `1e04c2fcba6e19c3bd879e53802d89b0160b26986e6d20ad5523bed5607af667`

The filename-only form matches Stata 18 save syntax and preserves the named output.

Current text:
```
save using "Table10_regression.dat"
```

Proposed replacement:
```
save "Table10_regression.dat"
```

Preparation / proposed procedure:

1. Apply this one-line change only in an extracted working copy after preserving the frozen source.

Validation to perform later:

- Compare to official Stata 18 save syntax and confirm the filename is unchanged; do not run the command during this assessment.

### A-DUPLICATE-RENAME: Remove the repeated sumsegments-to-busseg rename at line 92 while keeping the earlier line 44 rename.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I-DUPLICATE-RENAME
Evidence: E-FEED-DUPLICATE-RENAME, E-FEED-RENAME-AGAIN, E-STA-RENAME-MANUAL

**Proposed edit:** `create feedataset.do:92–92`
Source SHA-256: `d1bd3b7f498a4e3f6b4574cdb411f0ee1831b1ea9987e6e32f69531a8b10cd33`

The source already renames sumsegments at line 44 and does not recreate it before line 92.

Current text:
```
rename sumsegments busseg
```

Proposed replacement:
```

```

Preparation / proposed procedure:

1. Remove only the second rename in the extracted working copy.

Validation to perform later:

- Inspect intervening source lines and confirm the first rename remains; do not run a syntax trial.

### A-WORKING-DIRECTORY: Select one project working root and replace all eight literal directory placeholders with the current directory.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I-WORKING-DIR
Evidence: E-CD-MAIN, E-CD-COMPUSTAT, E-CD-FEED, E-CD-MAIN-SAMPLE, E-CD-TABLE9, E-CD-FF48, E-CD-FEED-FF48, E-CD-FF48-SAMPLE

**Proposed edit:** `create datasets.do:2–2`
Source SHA-256: `98f74b08eaea52ee0939081a40b7930550d48a2f39f4e9b8e9efb0932c732fc1`

Use the selected common run root for relative helper, input, and output paths.

Current text:
```
cd "NAME OF FOLDER"
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `retrieve compustat variables.do:2–2`
Source SHA-256: `740099de209174903855ae799f895ffd4024b105b32e01441ba05fe9e2980cd6`

Use the selected common run root for relative helper, input, and output paths.

Current text:
```
cd "NAME OF FOLDER"
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `create feedataset.do:2–2`
Source SHA-256: `d1bd3b7f498a4e3f6b4574cdb411f0ee1831b1ea9987e6e32f69531a8b10cd33`

Use the selected common run root for relative helper, input, and output paths.

Current text:
```
cd "NAME OF FOLDER"
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `Final sample selection.do:2–2`
Source SHA-256: `22c91351cb8da8d8e53a7ac9ca16071a81b91c92f0ed86b8fd5b82db6669bb85`

Use the selected common run root for relative helper, input, and output paths.

Current text:
```
cd "NAME OF FOLDER"
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `Final sample selection Table 9.do:2–2`
Source SHA-256: `1e04c2fcba6e19c3bd879e53802d89b0160b26986e6d20ad5523bed5607af667`

Use the selected common run root for relative helper, input, and output paths.

Current text:
```
cd "NAME OF FOLDER"
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `create datasets ff48.do:3–3`
Source SHA-256: `e06ce0cb31e4beffd61ace225192f204bcb239e08dfa9aa51d3e88324bc1685b`

Use the selected common run root for relative helper, input, and output paths.

Current text:
```
cd "NAME OF FOLDER"
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `create feedataset ff48.do:2–2`
Source SHA-256: `fc0be1fd06ca6d1d95180e122fecb423a9b49e8755146a64b8fb1fc8a4420e8a`

Use the selected common run root for relative helper, input, and output paths.

Current text:
```
cd "NAME OF FOLDER"
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `Final sample selection ff48 industries.do:2–2`
Source SHA-256: `f70fab4a43d0bf602af9306ecae7bd3d1898e63a798e020e005622b14654c20c`

Use the selected common run root for relative helper, input, and output paths.

Current text:
```
cd "NAME OF FOLDER"
```

Proposed replacement:
```
cd "."
```

Preparation / proposed procedure:

1. Stage all supplied drivers, three lookup helpers, and compatible inputs in one chosen run root, preserving originals.
2. Change line 2 in seven drivers and line 3 in create datasets ff48.do from cd "NAME OF FOLDER" to cd "."; retain all relative filenames and outputs.

Validation to perform later:

- Review all eight path changes and confirm helpers, inputs, and intermediates resolve from the selected root without launching an author driver.

### A-SOFTWARE-AVAILABILITY: Establish availability and versions of spreadsheet and database software required for documented manual stages.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S-EXCEL, S-ACCESS
Evidence: E-CREATE-MANUAL, E-CREATE-EXTERNALS, E-FEED-JOINS, E-TABLE9-MANUAL, E-FF48-FEED

Preparation / proposed procedure:

1. Record Excel and Access versions and identify the workbook/database files and manual procedures used at each handoff; no installation or substitute is evidenced.

Validation to perform later:

- Confirm the available products can perform the authored manual operations while preserving field names and join keys.

### A-RUN-ORDER: After inputs, schemas, and source-specific unknowns are resolved, follow the main, Table 9, and independent FF48 producer-consumer order.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R-AUDITANALYTICS, R-COMPUSTAT, R-FF48-START, R-MWSOX, R-RESTATEMENTS, R-SEGMENTS, R-MATERIALWEAKNESS, R-GOINGCONCERN, I-MANUAL-HANDOFFS, I-FF48-HANDOFF, I-TABLE9-HANDOFF
Evidence: E-INFO-ORDER, E-DATASHEET-BRANCHES, E-WORKFLOW-TRACE

Preparation / proposed procedure:

1. Stage AuditAnalytics and create auditanalytics_start.dta and auditorleveldata.dta; perform documented Excel deduplication before multimarket construction consumes auditorleveldata.dta.
2. Construct main multimarket outputs, retrieve Compustat, then perform documented Access joins for Compustat, multimarket, goingconcern, count_mw, restatements, and segments to create AA_regressionsample.dta.
3. Apply the main sample selection to create regressiondata.dta; record actual edge-year coverage and boundary behavior for lead/prior-row variables without changing the authored sample.
4. Run Table 9 from regressiondata.dta and multimarketmatrix.dta only after selector and Table10.dat contracts are supplied; retain t-tests as source code for a future authorized run.
5. Run the separate FF48 construction only after its start-data producer and filename/schema handoff are resolved; preserve the authored >=2015 filter.

Validation to perform later:

- Compare each stage's fields and filenames with probes/workflow_trace_02.json before any future authorized launch; this assessment ran no author program or analysis command.


## Remaining issues and prerequisites

- I-MANUAL-HANDOFFS [unresolved; full_pipeline]: The included workflow has required manual Excel deduplication and Microsoft Access joins across Stata stages. Exact schemas, source ownership, keys/cardinality, and completed handoff files are not supplied; the Table 9 selector and Table10.dat assembly are separately unresolved.
- I-FF48-HANDOFF [unresolved; full_pipeline]: The FF48 branch has separate imported and generated filenames, including a consumer name that does not match its supplied producer. Compatibility and the branch's actual output contract are unresolved.
- I-TABLE9-HANDOFF [unresolved; full_pipeline]: Table 9 initializes switchsample to zero and leaves the switcher marking as a commented placeholder. Its manual Excel/Access preparation and Table10.dat field contract are unspecified.
- I-KLAD-FRAGMENT [unresolved; full_pipeline]: The active KLAD lines use res_begin_date/res_end_date without a named producer and include incomplete statements. Their source rows and intended expressions are unknown.
- I-MAIN-RANK-BOUNDS [unresolved; full_pipeline]: The main producer creates mm_rank2 through mm_rank64, while later construction loops through mm_rank70. The intended upper bound and definitions for mm_rank65–70 are not supplied.
- I-COMPUSTAT-JOIN [unresolved; full_pipeline]: The Access SQL explicitly joins year_aa to AAData.fiscal_year and Compustatdata.cik to AAData.company_fkey. The retrieval comment instead names year_aa/gvkey. The SQL defines the current join; imported CIK/company_fkey types and populations remain unverified, and the comment mismatch does not establish a required identifier conversion.
- I-DATE-HISTORY [unresolved; full_pipeline]: The main code creates adjacent-year lead/change fields before filtering to 2004–2015; next-row values may be missing at the last observed year, and the main complete-case list does not drop those lead fields. create feedataset.do marks each company's earliest observed row firstyear=1 and checks up to five prior rows. Actual input coverage and author boundary treatment remain relevant to output fidelity, but the source does not establish that extra 2003 or 2016 rows are mandatory before any run.
- I-FF48-PERIOD [unresolved; full_pipeline]: The FF48 selection drops fiscal_year below 2015 and retains 2015 onward, while the datasheet describes source coverage through 2015. Preserve the authored filter pending clarification.
- I-STATA-SAVE-SYNTAX [preparation; full_pipeline]: Table 9 uses save using at line 133, which does not match Stata 18 save syntax. A filename-only edit preserves the named output.
- I-DUPLICATE-RENAME [preparation; full_pipeline]: create feedataset.do renames sumsegments to busseg at line 44 and repeats that rename at line 92 without a supplied recreation of sumsegments in between.
- I-WORKING-DIR [preparation; full_pipeline]: All eight launch drivers contain the literal cd placeholder. A common relative run root is a routine configuration choice; scripts, helpers, inputs, and intermediates must resolve from that root.
- R-AUDITANALYTICS [undetermined]: The main branch imports the author-named AuditAnalytics source and consumes company_fkey, fiscal_year, audit_fees, auditor_fkey, sic_code_fkey, bus_state, and bus_county. The datasheet describes Audit Analytics audit-fee data for 2004–2015; the exact integrated file, key types, covered rows, and lead/history compatibility are unverified.
- R-COMPUSTAT [undetermined]: The main merged panel requires the Compustat source imported as compustat.txt. The code constructs year_aa from datadate/fyear, and the Access SQL explicitly joins year_aa to fiscal_year and Compustatdata.cik to AAData.company_fkey. The retrieval comment says year_aa/gvkey; compatibility of the actual CIK/company_fkey field types and populations remains unverified, and the comment discrepancy is not evidence of a required conversion. The datasheet states 2004–2015.
- R-FF48-START [undetermined]: The separate FF48 construction driver reads auditanalytics20112019_start.dta, for which this release provides no producer or prepared file. The filename suggests a period but does not verify it; required columns include the fields used for market construction, including auditor_fkey, fiscal_year, msa_number, ff48, and audit_fees.
- R-MWSOX [undetermined]: The main preparation branch reads Mwsox.txt for count_weak and matchfy_sumfees_fy and manually deduplicates/matches it by company_fkey and fiscal year. This is distinct from materialweakness.txt, and no source file or compatible route is supplied.
- R-RESTATEMENTS [undetermined]: The main preparation branch reads restatements.txt with file_date, fiscal_ye, matchfy_sumfees_fy, and company_fkey fields to create rest_filing for a manual Access match. The required source population and file are not supplied.
- R-SEGMENTS [undetermined]: The main preparation branch reads segments.txt and uses datadate, gvkey, cik, stype, sid, and snms to construct year and sumsegments before an Excel deduplication and Access match. The exact client-key mapping and compatible source file are unresolved.
- R-MATERIALWEAKNESS [undetermined]: The main preparation branch separately reads materialweakness.txt and uses material_weakness, matchfy_sumfees_fy, and company_fkey to construct mw. It is a distinct input from Mwsox.txt and no compatible source file is supplied.
- R-GOINGCONCERN [undetermined]: The main manual Access join requires the goingconcern table with fiscal_year_of_op, company_fkey, and going_concern; the code later uses going_concern to form gc. This table has no supplied producer or compatible file.
- S-EXCEL [unverified]: The workflow explicitly requires Excel deduplication/copy-paste; installation and version are unverified.
- S-ACCESS [unverified]: The workflow explicitly requires Access SQL joins; installation and version are unverified.

## Review notes

- The assigned company_fkey.txt is an identifier list, not an analysis panel. The coordinator's earlier cached-list line-count read is preserved in semantic_prechecks/metadata_preview_cached_identifier_count_20261109.json (sha256 32263d1126153afdf230cce9a4cd8144379ccd96959e21726897e475c812b4a8) as a bounded-method lapse; the count is not coverage evidence, and no second read/count occurred.
- The scope includes the main 2-digit SIC workflow, the separate FF48 branch, and the Table 9 switcher-choice branch. It does not infer unprovided paper estimators.
- The supplied FIPS, FIPS-to-MSA, and MSA-number lookup bodies contain no external file reads and support a historical mapping route; raw Census data are contextual rather than a separate mandatory input for this supplied path.
- The existing catalog_shape_failed_attempt.json preserves one failed shell command using unavailable python (exit 127), and checkpoint_03_run_failed.json preserves a draft-helper NameError before any draft write; both exact failures are archived. Subsequent helper calls used python3.
- The pre-existing run-level environment.json records two failed SAS startup attempts before this package assessment. This worker did not repeat them or use them as SAS availability evidence; the assessed package branches use Stata and manual Excel/Access operations.
- No author code, data import, compilation, syntax trial, statistical/descriptive test, or executable transformation was run. The source creates firstyear on the earliest observed client row and next-year fields may be missing at the final observed year; actual coverage/boundary treatment are output-fidelity questions, not assumed 2003/2016 prerequisites. Table 9 t-test commands were inspected as source only.
