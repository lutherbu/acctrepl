# Patch proposal: jar-8e128c1802ad

Disentangling Managers' and Analysts' Non-GAAP Reporting

DOI: 10.1111/1475-679X.12206

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied preparation and analysis-data assembly: CRSP–IBES linking, EA-date and analyst-exclusion controls, SEC index and raw 8-K processing, the v11.6 core sample, the independent Part II sample, and final assembly. Target sample is 2003–2012; code also needs pre-sample and future histories. No full econometric table regression code is supplied, and Identifiers.txt is only a key list.

Entry points: `_nested_Code/Code/EDGAR Filings -- SEC Website.sas`, `_nested_Code/Code/CRSP - IBES link - CRSP & IBES.sas`, `_nested_Code/Code/EA dates -- COMPUSTAT & IBES.sas`, `_nested_Code/Code/Analyst Non-GAAP Exclusions -- COMPUSTAT & IBES.sas`, `_nested_Code/Code/Book to Market -- COMPUSTAT & CRSP.sas`, `_nested_Code/Code/Getting SEC Filings v4.4.sas`, `_nested_Code/Code/DownloadFilings.py`, `_nested_Code/Code/WordCounts.py`, `_nested_Code/Code/Identify EA Announcements v2.2.sas`, `_nested_Code/Code/CheckEPS.py`, `_nested_Code/Code/Sentences.py`, `_nested_Code/Code/KoolAid_Analysis_v11.6.sas`, `_nested_Code/Code/KoolAid_Analysis_v11.3_PartII.sas`, `_nested_Code/Code/KoolAid_Final_v5.13.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 4/12206 - Disentangling-Managers-and-Analysts-Non-GAAP-Reporting/bcgw-datasheet-and-code.zip",
      "sha256": "caad2eae7bb6ff4d3171c7014288b1fa1b4ef56427efb4a3b8244a2fd57c8860"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "8c7afe90726fd9871dfc975374ea6739c24a94a35bac7aaee45e0bd1ca864fca"
}
```

## Proposed actions

### A001: Resolve the exact historical source products and schemas whose names are absent from the frozen catalog.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R003, R004, R005, R006, R007, R018, R019, I008
Evidence: E009, E010, E011, E068, E069

Preparation / proposed procedure:

1. Confirm availability and schema for WRDS_CSQ_UNRESTATED, WRDS_CSA_UNRESTATED, CO_FILEDATE, COMPHIST, COPEROL, IBES.ID, and IBES.IDSUM.
2. Map each author library alias to an exact local or authorized WRDS product; do not substitute current Compustat for the explicitly requested point-in-time products.
3. Confirm filing-date, historical-link, fiscal-period, and executive-role fields used at the cited code lines.

Validation to perform later:

- Record exact product, fields, version, and required periods/histories for every distinct table.

### A002: Acquire the target-period SEC company indexes and raw 8-K text through the official public archive.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R020, R021
Evidence: E017, E018, E063, E064

Preparation / proposed procedure:

1. Obtain company indexes and complete raw 8-K text for 2003–2013.
2. Use index paths and a declared User-Agent, observing SEC fair-access limits.
3. Preserve identifiers and raw filing text required by author parsers.

Validation to perform later:

- Compare index fields and filing paths with code inputs.
- Verify 8-K and section/text coverage for the target acquisition period.

### A004: Resolve each manager annotation version and sign-correction table as a distinct required input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R023, R024, R025, R026, R027, I005
Evidence: E022, E023, E024, E065, E067

Preparation / proposed procedure:

1. Confirm the source and fields for hc_sent, hc_sent_v2, hc_sent_v3, and hc_sent_both_v2 separately.
2. Confirm the independent handcollect_fix_neg_signs fields and correction history.
3. Treat the author Manager Non-GAAP EPS form as a conditional lead only until its match to each exact input is established.

Validation to perform later:

- Check each table’s filename key, manager EPS values, multiple/GAAP-only fields, sign handling, and target-period coverage.

### A005: Identify each separate post-sample accuracy-validation input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R028, R029, R030, I006
Evidence: E025, E026, E027, E055

Preparation / proposed procedure:

1. Confirm whether the full run includes the Hand Collection Master, Venn-diagram table, and Holdout Sample branch.
2. If included, obtain or identify each exact source separately with its source/coverage fields.

Validation to perform later:

- Confirm each input joins on the filename key and preserves the cited training/holdout definitions.

### A006: Establish SAS/CONNECT, library aliases, remote authentication, and working-directory/path configuration.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: S001, I001
Evidence: E008, E028, E030, E032, E053

Preparation / proposed procedure:

1. Confirm SAS/CONNECT and configure COMPM, CRSPQ, COMPSNAP, IBES, STORAGE, KOOLAID, and TEMP librefs.
2. Set SAS user-file root and Python current directory so Filings/, list files, dictionaries, and outputs resolve.

Validation to perform later:

- Resolve all required tables/paths before considering code runnable.

### A007: Provide a compatible runtime for Python 2.7/urllib2 scripts or prepare a reviewed Python 3 migration.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S002
Evidence: E001, E029, E052

Preparation / proposed procedure:

1. Choose an isolated compatible Python 2.7 runtime or review and port urllib2 and text/file behavior to a supported runtime.

Validation to perform later:

- Check imports and compare output schemas for downloads, word counts, EPS flags, and sentence files.

### A008: Locate and verify the custom SAS macro library expected by the supplied code.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I002
Evidence: E024, E034, E038

Preparation / proposed procedure:

1. Identify the definitions and versions of %dupl, %ff48, and %winsorize_truncate.
2. Map them into SAS without changing author code until behavior is confirmed.

Validation to perform later:

- Confirm macro parameters and duplicate, industry, and truncation behavior.

### A009: Activate the exact EDGAR WORK-to-STORAGE copy already supplied in the producer.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I003
Evidence: E018, E019, E016

Preparation / proposed procedure:

1. Configure the STORAGE libref.
2. Activate the supplied data storage.Edgar_Filings_1993to2013; set Edgar_Filings_1993to2013; run; statements at source lines 53–55 by removing their surrounding comment delimiters or executing those statements after the macro.
3. Run the downstream SEC join only after that exact persistent table exists.

Validation to perform later:

- Confirm the persistent table name/fields and row count match the EDGAR WORK table.
- Confirm the downstream SET statement reads the produced table.

### A010: Prepare lossless, stage-specific six-file views from filinglist_full.txt without changing filing membership.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: I004
Evidence: E017, E020, E021, E028, E031

Preparation / proposed procedure:

1. Preserve the two-column id/url source export with its original order.
2. If a filing ID occurs more than once, keep all matching IDs within the same operational chunk and verify whether IDs are unique before any file-name-based download; never drop duplicate rows.
3. Split the source into six operational chunks without changing filing membership. Create headerless Python views because DownloadFilings.py processes every CSV row.
4. Create corresponding headered SAS views because Identify EA Announcements v2.2.sas reads filename/extension with FIRSTOBS=2. Keep every data row and order identical across stage views.
5. Use stage-specific directories and expected basenames coherently at each call, checking text_file[11:] naming for Filings and WordCount outputs. Keep the author EA 8-K component separate.

Validation to perform later:

- Verify each original id/url row appears exactly once in the six chunk set; duplicated IDs remain together and are not silently overwritten.
- Verify no Python header is treated as a filing and no SAS first data row is skipped.
- Verify every input/output basename agrees with text_file[11:] and the current directory/path each script resolves.
- Confirm six WordCount outputs use the names and tab-separated schema consumed by the SAS importer.

### A011: Use exact supplied Part II filename and preserve main → Part II → final order.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I007
Evidence: E035, E037, E039

Preparation / proposed procedure:

1. Use _nested_Code/Code/KoolAid_Analysis_v11.3_PartII.sas after KoolAid_Analysis_v11.6.sas.
2. Pass koolaid.sample_partII to KoolAid_Final_v5.13.sas.

Validation to perform later:

- Confirm Part II output keys match the final program’s gvkey/datadate join.


## Remaining issues and prerequisites

- I001 [unresolved; full_pipeline]: Author SAS programs use SAS/CONNECT RSUBMIT and unconfigured library aliases and user paths. Python files use relative Filings/, list, dictionary, and output paths requiring a specific current directory. No source supplies the connection, libname, path, or current-directory configuration.
- I002 [unresolved; full_pipeline]: The SAS programs call %dupl, %ff48, and %winsorize_truncate, but no macro definitions are included among the supplied programs; their source location and behavior are unverified.
- I003 [preparation; full_pipeline]: The EDGAR producer’s storage.Edgar_Filings persistence copy is already supplied at lines 53–55 but commented. After the STORAGE libref is configured, activating that copy gives Getting SEC Filings v4.4.sas the exact named table; this is a supported handoff preparation step.
- I004 [preparation; full_pipeline]: Getting SEC Filings v4.4.sas exports one two-column filinglist_full.txt with PUTNAMES=NO. DownloadFilings.py reads every CSV row and does not skip a header, while Identify EA Announcements v2.2.sas reads six numbered parts as filename/extension and skips row 1 with FIRSTOBS=2. The required split is operational file preparation: preserve all source rows and order, provide headerless Python inputs and headered SAS views, and never discard the first data row or treat the author’s EA announcement list as these initial filing lists.
- I005 [unresolved; full_pipeline]: Main analysis jointly reads four distinct versioned manager sentence/EPS tables and a separate sign-correction table. The datasheet documents manual collection and README says it is not separately included. The author-shared manager component has no verified mapping to any exact consumed table.
- I006 [unresolved; full_pipeline]: The complete main script separately imports Hand Collection Master.csv, reads a Venn-diagram hand-collection table, and imports Holdout Sample_Results2.csv after sample generation. These inputs are absent from the exact package inventory.
- I007 [preparation; full_pipeline]: README names KoolAid_Analysts_v11.3_PartII.sas; supplied program is KoolAid_Analysis_v11.3_PartII.sas. The supplied file produces sample_partII consumed by the supplied final program.
- I008 [unresolved; full_pipeline]: Exact Compustat PIT/unrestated, CO_FILEDATE, CRSP COMPHIST/COPEROL, and I/B/E/S ID/IDSUM products are not listed in the frozen local catalog. This snapshot is not an access/license test; exact product versions and fields remain to be confirmed.
- R003 [undetermined]: Quarterly Compustat point-in-time/unrestated values explicitly required by the source code.
- R004 [undetermined]: Annual Compustat point-in-time/unrestated values explicitly required by the source code.
- R005 [undetermined]: Compustat filing-date history table CO_FILEDATE.
- R006 [undetermined]: CRSP company-history table COMPHIST for historical issuer/CIK matching.
- R007 [undetermined]: Compustat COPEROL officer-role table used in Part II.
- R018 [undetermined]: I/B/E/S ID detail identifier product used to determine analyst forecast basis.
- R019 [undetermined]: I/B/E/S IDSUM summary identifier product used for ticker/CRSP links and forecast/actual joins.
- R020 [public_acquisition_required]: Public EDGAR company-index rows required to locate target-period filings and filing paths.
- R021 [public_acquisition_required]: Complete raw SEC 8-K filing text used for word counts, announcement identification, EPS checks, and sentence extraction.
- R023 [undetermined]: Exact jointly consumed manager EPS sentence/label table koolaid.hc_sent; this version remains distinct from the other three versions.
- R024 [undetermined]: Exact jointly consumed manager EPS sentence/label table koolaid.hc_sent_v2; this version remains distinct from the other three versions.
- R025 [undetermined]: Exact jointly consumed manager EPS sentence/label table koolaid.hc_sent_v3; this version remains distinct from the other three versions.
- R026 [undetermined]: Exact jointly consumed manager EPS sentence/label table koolaid.hc_sent_both_v2; this version remains distinct from the other three versions.
- R027 [undetermined]: Distinct handcollect_fix_neg_signs correction table applied to manager/analyst EPS comparisons.
- R028 [undetermined]: Separate post-sample training/accuracy-validation CSV.
- R029 [undetermined]: Separate post-sample Venn-diagram hand-collection SAS table.
- R030 [undetermined]: Separate post-sample holdout accuracy-validation CSV.
- S001 [unverified]: SAS 9.4 binary is installed, but the existing startup probe failed while loading TKELS; no retry was made. SAS/CONNECT, COMPM/CRSPQ/COMPSNAP librefs, remote authentication, author paths, and custom macros are not established.
- S002 [preparation_required]: The README specifies Python 2.7 and DownloadFilings.py imports urllib2. The local environment check found no python2.7 executable; Python 3.12 is available but urllib2 is not. A compatible runtime or reviewed Python 3 port is required before these scripts can run.

## Review notes

- This is the expanded source/resource checkpoint; the remaining frozen dependencies are being mapped incrementally before finalization.
- All 14 exact packaged SAS/Python paths are retained. README Part II filename differs from the supplied _nested_Code/Code/KoolAid_Analysis_v11.3_PartII.sas; the supplied file is used because its sample_partII output is consumed by the final program.
- The frozen identifier list was inspected only at its header, first three rows, total line/record count, and frozen hash; it is not a prepared analysis panel.
- One-row SAS probes establish only readable candidate files and requested fields. They do not verify historical population coverage, alias mapping, license entitlement, or point-in-time equivalence.
- No author code was run or imported, no datasets were downloaded or deserialized, no packages were installed, and no external author forms were submitted.
- Resource requirements are split by every jointly required table and packaged dictionary. Standard local Compustat, CRSP, and I/B/E/S products are verified at the exact field/readability level; only explicit PIT/unrestated/history/identifier products remain unresolved.
- Author Manager Non-GAAP EPS form remains a conditional candidate for the specific hand-collected tables. The author Earnings Announcement 8-K form is an optional lead only: supplied Identify EA Announcements v2.2.sas creates koolaid.EAs_2003to2013 at lines 235–240, so that form is not a mandatory input.
- README’s approximately 300 GB and more-than-one-week warnings are author estimates; no local run was measured.
- The first bounded COMP.FUNDQ request included SICH, which is a FUNDA field and is absent from the FUNDQ catalog. The helper rejected that field before reading rows; this is not evidence of missing data. The corrected successful FUNDQ probe omits SICH and is the only probe cited for the local route.
- Entry points retain the README preparation order and use the exact supplied PartII filename after the v11.6 main analysis and before final assembly.
