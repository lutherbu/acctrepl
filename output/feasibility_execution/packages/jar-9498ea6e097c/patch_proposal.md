# Patch proposal: jar-9498ea6e097c

Facilitating Tacit Collusion through Voluntary Disclosure: Evidence from Common Ownership

DOI: 10.1111/1475-679X.12452

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

All supplied SAS preparation, merge, common-ownership branches and the appended native Stata data-preparation fragment. The delivered workflow includes its Top-5 branch but no regression driver; paper-wide estimations remain contextual.

Entry points: `PSZ_SAScodeJAR.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 5/12452 - Facilitating-Tacit-Collusion-through-Voluntary-Disclosure-Evidence-from-Common-Ownership/psz-datasheet-code-and-identifiers.zip",
      "sha256": "3c5340c06615980f2c01adcb5e0705484738cfd10ad18dda02daef13ad5babb5"
    },
    {
      "path": "JAR-Volume 60/Issue 5/12452 - Facilitating-Tacit-Collusion-through-Voluntary-Disclosure-Evidence-from-Common-Ownership/psz-online-appendix.pdf",
      "sha256": "1f4011b45ebf242a8391b529f107d29acb4afcac0702705d6ae715f2dc902907"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "7cc264b71d24d8ff3064e23e684d8ad93b663b96344b8e183ec9da73d1ac413f"
}
```

## Proposed actions

### ACT-PREPARED-INPUTS: Obtain the exact author-prepared clean-SIC and disclosure tables, or obtain their missing producers and precise output contracts before choosing any raw-source alternative.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ-S1, REQ-EAS2, REQ-CALLS2, REQ-CTO3, ISS-AUTHOR-PREP
Evidence: E-S1-CROSSWALK, E-PREPARED-TABLES, E-PYTHON-NAMED, E-IDENTIFIER-PROBE, E-PACKAGE-INVENTORY

Preparation / proposed procedure:

1. Confirm and stage the exact s1 table with its gvkey1/datadate/sic/sic2d contract and manually backfilled values.
2. Obtain the prepared eas2, calls2, and cto3 outputs with their exact keys, periods, population, and fields consumed by Part 3.
3. If the prepared outputs are unavailable, obtain the missing author producer and documented field mapping before selecting a source-data route; do not combine prepared and raw routes as mandatory parallel inputs.

Validation to perform later:

- Compare keys, field types, date coverage, and sample population with the supplied SAS joins before staging each table.
- Confirm the prepared-table provenance and working-copy paths without reading identifier rows or inventing missing measures.

### ACT-HANDOFFS: Obtain provenance and field contracts for the only supplied Part 4 reads without producers: main.d_prelimsample_a and main.mhhi_merge3.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-HANDOFFS
Evidence: E-UNPRODUCED-READS, E-TRACE

Preparation / proposed procedure:

1. Identify the producer or named prepared artifact for main.d_prelimsample_a and its gvkey/datacqtr field contract.
2. Identify the producer or named prepared artifact for main.mhhi_merge3 and its gvkey/id1 contract; do not substitute main.mhhi_merge2 unless source documentation confirms it.
3. Record the resolved local paths and keep these two genuine missing-predecessor contracts separate from the generated same-data staging routes.

Validation to perform later:

- For each predecessor, trace one source or producer to the exact consumer with matching fields and period before a future execution attempt.

### ACT-LOCAL-DATA-SOFTWARE: Confirm history/population compatibility of exact local Compustat, IBES, and Thomson candidates, and confirm the SAS runtime and PC Files component needed for PROC EXPORT.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ-FUNDQ, REQ-FUNDA, REQ-IBES-EPS, REQ-IBES-GUIDE, REQ-S34, SW-SAS, SW-SAS-PCFILES
Evidence: E-CATALOG-LOOKUPS, E-PROBE-FUNDQ, E-PROBE-FUNDA, E-PROBE-IBES-EPS, E-PROBE-IBES-GUIDE, E-PROBE-S34, E-ENVIRONMENT, E-PUBLIC-SAS-PCFILES

Preparation / proposed procedure:

1. Compare the exact local candidate tables' full history, dates, population, and source filters with the author WRDS dataset contracts; retain the one-row probes as field/readability evidence only.
2. Confirm SAS runtime availability and SAS/ACCESS Interface to PC Files support from a supported environment inventory before any future export attempt.

Validation to perform later:

- Record exact dataset IDs, periods, source filters, and population compatibility before changing each candidate route to verified.
- Before any future run, verify selected paths and output writability under the host wrapper's relative or [redacted-path-4b343a2c28d1] path conventions.

### ACT-STATA-ALIGNMENT: Prepare the exact source-supported export/import path and variable-name corrections in a working copy. These preparation edits can proceed independently of the separate unresolved mean_io and FC_ind/fc_ind contracts; no author source is edited here.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISS-STATA-NAME-REPAIRS
Evidence: E-STATA-MIXED-ENTRY, E-PUBLIC-SAS-DTA, E-ROA-MISMATCH, E-STDDEV-PRODUCER, E-STDDEV-RENAME, E-FIRMOVERLAP-RENAME, E-RENAME-MAPPINGS, E-STDIND-PRODUCER, E-STDIND-RENAME

**Proposed edit:** `PSZ_SAScodeJAR.sas:1538–1538`
Source SHA-256: `163d0f9508851408e3e71028b0cbf8ff6f5c9407c6c169eb4ca12eba85133188`

Use a relative DTA path from the common runtime working directory and match the Stata load name; create outputs/ under that working directory before a future run.

Current text:
```
            OUTFILE= "Enter File Path\pszsample.dta" 
```

Proposed replacement:
```
            OUTFILE= "./outputs/pszsample.dta"
```

**Proposed edit:** `PSZ_SAScodeJAR.sas:1547–1547`
Source SHA-256: `163d0f9508851408e3e71028b0cbf8ff6f5c9407c6c169eb4ca12eba85133188`

Load the exact DTA filename exported by SAS using the same relative runtime path.

Current text:
```
use "Enter Path\pszsample1.dta"
```

Proposed replacement:
```
use "./outputs/pszsample.dta"
```

**Proposed edit:** `PSZ_SAScodeJAR.sas:1601–1601`
Source SHA-256: `163d0f9508851408e3e71028b0cbf8ff6f5c9407c6c169eb4ca12eba85133188`

Filter the variable generated immediately above as roa_a.

Current text:
```
replace allvar=0 if roa==.
```

Proposed replacement:
```
replace allvar=0 if roa_a==.
```

**Proposed edit:** `PSZ_SAScodeJAR.sas:1622–1622`
Source SHA-256: `163d0f9508851408e3e71028b0cbf8ff6f5c9407c6c169eb4ca12eba85133188`

Align exact input names to the supplied producers and filter names: firmoverlap is one field, SAS creates stdev, and SAS creates std_ind_sale. mean_io and FC_ind/fc_ind remain separate unresolved contracts.

Current text:
```
rename (firmmhhi firm overlap top5_value fc_ind stddev abschange herfindahl nonbhin totalbhown2 mean_io num_analysts2  std_ind_sal  ind_ppe_med logms) ///
```

Proposed replacement:
```
rename (firmmhhi firmoverlap top5_value fc_ind stdev abschange herfindahl nonbhin totalbhown2 mean_io num_analysts2 std_ind_sale ind_ppe_med logms) ///
```

Preparation / proposed procedure:

1. Apply the proposed path/name corrections in a working copy as source preparation; no numeric or scientific trial is needed to prepare these direct mappings.
2. Keep the SAS export and Stata fragment as separate batch stages from the same runtime working directory, with relative or [redacted-path-4b343a2c28d1] paths.

Validation to perform later:

- Check the corrected DTA path/name matches and the direct source-produced input names align with their filters and rename outputs.
- Before a future execution, check the complete remaining Stata input contract, including mean_io and FC_ind/fc_ind, and confirm the relative output directory is writable.

### ACT-PATH-SETUP: Configure known same-data SAS library and staging paths in a working copy; the supported route is direct and does not require reconstructing scientific measures.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: ISS-PATH-SETUP
Evidence: E-FUNDA-JOIN, E-PROBE-FUNDA, E-PART4-ROOTS, E-SHARE1-WRITER, E-COVAR-READ, E-FIRM-MHII-PRODUCER, E-BH-MHII-PRODUCER, E-HERFINDAHL-KEYS, E-FIRMS-WORK-PRODUCER, E-FIRMS-MAIN-CONSUMER, E-TOP5-CALCULATED, E-HHI-PRODUCER, E-MAIN-HHI-PRODUCER, E-PSZ-TEMP-OUTPUT, E-PSZ-STAGE

Preparation / proposed procedure:

1. Map the comp libref used for comp.funda to the exact local COMP.FUNDA candidate directory ${ACCTREPL_SAS_ROOT}/comp/d_na; retain separate unverified history/population coverage in REQ-FUNDA.
2. Point share1 and covar at the same host-visible output directory so the generated mhhifirmfinal and mhhifirmfinal_bh members are read through their existing names.
3. Stage temp.hhi_compustat under main.hhi_compustat and stage the Part 3 temp.pszsample under main.pszsample; verify the main-sample gvkey/datacqtr join keys in that staged member.
4. Route the generated WORK.firms table to main.firms, for example with a same-data SAS copy after the Top-5 calculation; retain its existing id1/cusip8/top5_value fields.
5. Choose coherent relative or [redacted-path-4b343a2c28d1] roots for main, share1, and covar and keep them inside the runtime working directory or supported host paths.

Validation to perform later:

- Confirm each configured library points to the producer's member and each staged member has the consumer's expected keys and fields.
- Before a future run, verify the selected host-visible paths and output directories are writable without using an absolute Dropbox path.

### ACT-TOP5-ID: Confirm the intended id1 producer/key mapping for the Top-5 branch, which starts before id1 is added to ownershipper2.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-TOP5-ID
Evidence: E-S34-INPUT, E-PROBE-S34, E-TOP5-OWNERPER-INPUT, E-ID1-OWNERPER2, E-HERFINDAHL-KEYS

Preparation / proposed procedure:

1. Confirm the author-intended S34-to-industry-quarter key source for the Top-5 input or document the existing prepared input that supplies id1.
2. Keep the current source order intact until the exact input/key mapping is documented; do not invent id1 from an unverified schema.

Validation to perform later:

- After a documented mapping is supplied, verify id1 and cusip keys align between the Top-5 producer and downstream main.firms join without a numeric trial.

### ACT-STATA-CONTRACT: Resolve the two genuine remaining Stata source contracts independently of the supported name/path preparation edits.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-STATA-MAPPING
Evidence: E-MEANIO-USE, E-GUIDANCE-PRODUCER, E-STATA-MIXED-ENTRY

Preparation / proposed procedure:

1. Identify the supplied or prepared producer and exact field contract for mean_io; do not compute or substitute a new definition.
2. Confirm how the SAS export's FC_ind is presented to Stata and whether the lower-case fc_ind token is valid in the intended DTA file.

Validation to perform later:

- Document both exact exported field names and their source/consumer mappings before a future Stata run.


## Remaining issues and prerequisites

- ISS-AUTHOR-PREP [unresolved; full_pipeline]: The source needs a manually clean-SIC s1 table and prepared eas2/calls2/cto3 tables; only a gvkey/datadate identifier list is packaged. The datasheet names PSZ_PythonJAR.py, which is absent from the extracted inventory. These prepared outputs remain the primary route instead of independently recreating text extraction; their contracts remain unknown.
- ISS-HANDOFFS [unresolved; full_pipeline]: Two direct Part 4 reads have no producer in the supplied source: main.d_prelimsample_a and main.mhhi_merge3. Their exact source/producer and field contracts remain unresolved. Known same-data library and staging routes are recorded separately as supported path setup.
- ISS-STATA-MAPPING [unresolved; full_pipeline]: Two Stata input contracts remain unresolved: mean_io is consumed but has no supplied producer, and the case/name mapping from SAS FC_ind to Stata fc_ind is not established by the supplied export instructions. Do not invent or calculate either contract.
- ISS-TOP5-ID [unresolved; full_pipeline]: The Top-5 branch starts from ownershipper built from main.s34 and immediately sorts by id1. The supplied source derives id1 later on ownershipper2, not on the ownershipper input used by this branch; the exact one-row S34 schema also has no id1. The intended input/key mapping is unresolved and must not be invented.
- ISS-PATH-SETUP [preparation; full_pipeline]: Known generated members use different SAS librefs or need local staging: map comp.funda to the exact COMP.FUNDA candidate, route share1 loop outputs to the same members later read through covar, route the generated WORK.firms table to main.firms, and stage Part 1/3 outputs under main.hhi_compustat/main.pszsample. These are supported same-data path/staging tasks; verify the main.pszsample gvkey/datacqtr join fields while configuring paths.
- ISS-STATA-NAME-REPAIRS [preparation; full_pipeline]: The mixed source has direct path and name mismatches with source-supported corrections: SAS exports pszsample.dta while Stata loads pszsample1.dta; Stata generates roa_a but filters roa; SAS produces stdev and firmoverlap while the rename tuple uses stddev and separate firm/overlap tokens; the SAS-produced std_ind_sale is entered as std_ind_sal. These corrections are proposed in a working copy and do not depend on the separate unresolved mean_io/FC_ind contracts.
- REQ-FUNDQ [undetermined]: Compustat quarterly fundamentals read as compm.fundq. The supplied code filters USD, fyearq > 1999 and nonmissing atq, and uses rolling historical rows to calculate controls. The exact local catalog candidate has all named fields and is readable at one row; its history, period coverage, and population match are unverified.
- REQ-FUNDA [undetermined]: Compustat annual funda table used to add backup sich by gvkey/fyear. The exact local COMP.FUNDA candidate is readable and contains join fields; assign the source's comp libref to that local table as path configuration. Historical period and population compatibility with the WRDS source remain unverified.
- REQ-S1 [undetermined]: Prepared clean-SIC sample table s1, joined on gvkey1/datadate and supplying sic/sic2d for the selected sample. Manual SIC backfilling is explicitly part of the design. The packaged identifier CSV provides only gvkey and datadate and is not this prepared SIC crosswalk.
- REQ-IBES-EPS [undetermined]: IBES detailed EPS table det_epsus, read for FPEDATS, ticker, CUSIP, and analyst identifiers to calculate num_analysts. Exact candidate fields are readable at one row; population and period compatibility remain unverified.
- REQ-IBES-GUIDE [undetermined]: IBES detailed guidance table det_guidance, read for announcement dates and ticker to generate FC_ind on quarterly dates. Exact candidate fields are readable at one row; population and period compatibility remain unverified.
- REQ-EAS2 [undetermined]: Author-prepared earnings-announcement table eas2 joined on CIK/disc_date for revguide and totalwords_EA. The package lacks the table and the named Python producer. Prepared output remains the primary route; exact fields, periods, population, and construction are unresolved.
- REQ-CALLS2 [undetermined]: Author-prepared conference-call table calls2 joined on gvkeycc/disc_date and consumed with b.* fields. The package lacks the table and named Python producer; its complete field, period, population, and measure contracts are not supplied. Prepared output remains primary.
- REQ-CTO3 [undetermined]: Author-prepared SEC CTO table cto3 joined on CIK/disc_date and consumed through b.* for CTO measures. The package lacks the prepared table and producer; exact measures, sections, period, and population remain unresolved. Prepared output remains primary.
- REQ-S34 [undetermined]: Thomson Reuters S34 institutional ownership table used for manager/firm/report-date/share data. A local exact-ID candidate is readable and contains the source's listed share fields; its history/population match and the Top-5 branch's id1 handoff remain unresolved. The bounded schema does not contain id1.
- SW-SAS [unverified]: The supplied workflow uses Base SAS procedures and macros. Existing runtime evidence reports a TKELS startup failure but does not establish a missing license; no new SAS process was started.
- SW-SAS-PCFILES [unverified]: The supplied PROC EXPORT DBMS=STATA step requires SAS/ACCESS Interface to PC Files support in SAS 9.4; the author SAS version and local component availability are not established.

## Review notes

- This assessment covers the full supplied mixed SAS/Stata workflow and all 38 frozen dependencies; the package contains no regression driver, and no analysis-only bypass is evidenced.
- The five exact catalog-selected SAS candidates were read only one row each with Python; readability and field names do not verify population, date coverage, or historical completeness. The identifier CSV was limited to its bounded header probe; no rows were read or counted.
- SEC evidence is limited to an official public filing route description and bounded existence checks for the two documented corpus roots. The S&P transcript product is a candidate only; product identity and access details remain unverified. No filings, transcripts, dataset payloads, archives, or API payloads were fetched.
- No author SAS, Stata, or Python program, SAS process, estimator, analysis, or data transformation was executed. Existing supplied SAS startup evidence records a TKELS failure without establishing a missing license; no new SAS startup attempt was made.
- The proposed source edits are recommendations only; no author source was changed. The DTA path proposal uses one relative name from a shared runtime working directory, consistent with the host-wrapper path guidance.
- One draft-assembly helper failed before writing because it keyed dependency reviews on id instead of dependency_id. The exact failing helper source, input patch, captured stderr/return code, and unchanged draft snapshot are preserved; a corrected helper applied the same saved section.
- For the three bounded probes completed before their sidecars were added, the helper-produced argv/cwd, per-query or per-path results, and summary-reported streams are retained. The raw outer exec envelopes were not retained; the supplemental record labels this capture limit.
- Coordinator-authorized correction: D0004 now treats the exact COMP.FUNDA route as a requirement with libref configuration; D0029/D0030, D0031, and D0036 are generated outputs with same-data path/staging preparation. Actual missing producers remain limited to main.d_prelimsample_a and main.mhhi_merge3; Top-5 id1, mean_io, and FC_ind/fc_ind contracts remain unresolved.
