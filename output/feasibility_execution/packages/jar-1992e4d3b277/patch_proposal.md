# Patch proposal: jar-1992e4d3b277

Information Complementarities and the Dynamics of Transparency Shock Spillovers

DOI: 10.1111/1475-679X.12510

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

The two supplied code branches are assessed together: Python MD&A extraction and Stata peer-sample preparation followed by its synthetic estimation illustration. The supplied sources show no notebook-to-Stata consumer link; the Stata estimates reload synthetic data and are not the paper's empirical results.

Entry points: `BDSY-datasheet-and-code/MDA Extractor.ipynb`, `BDSY-datasheet-and-code/master_do_file.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 1/12510 - Information-Complementarities-and-the-Dynamics-of-Transparency-Shock-Spillovers/bdsydatasheetcodeandidentifiers.zip",
      "sha256": "efce401adbc8550ba5a2b85ad68cfbbef1dba9346166bf6bcfb5bb9e3b21bedf"
    },
    {
      "path": "JAR-Volume 62/Issue 1/12510 - Information-Complementarities-and-the-Dynamics-of-Transparency-Shock-Spillovers/bdsy-online-appendix.pdf",
      "sha256": "b38b1e5ecb3e0a3d907335804e12c40ee54d65951f4ae837fb7cc7875f051709"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "16ce82cb0108941929017164185dc0fc4f0f047d7807e9d8282368ef8c978a79"
}
```

## Proposed actions

### A_CPLIST: Obtain the author-prepared close/distant peer list or its documented producer and exact schema; do not reconstruct peer or cohort membership from unrelated catalog tables.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CPLIST, I_CPLIST_CONSTRUCTION
Evidence: E_MASTER_CPLIST, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Request cplist.dta or the exact author preparation program and data dictionary, including i, gvkey, SIC/SIC3 fields, evt_yr, cohort meaning, event definitions, sample population and formation period.
2. Keep the close-peer gvkey join and distant-peer sic2 join as distinct contracts; do not infer a compatible key or create peer rows independently.

Validation to perform later:

- After the author input is supplied, use a bounded metadata/row-one check in a separate working copy to compare imported field names and types with the two Stata joins.
- Before a separately authorized run, verify the documented population and historical window required by the peer construction; a one-row schema check does not establish coverage.

### A_FLIST: Obtain the author-prepared fraud/event list or its documented producer and semantics before using it to remove firms and build SIC3 event-year exclusions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_FLIST, I_FLIST_CONSTRUCTION
Evidence: E_MASTER_FLIST, E_MASTER_FLIST_FIELDS, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Request flist.dta or the exact preparation code and data dictionary for gvkey, sic3 and evt_yr, including how fraud firms/events are defined and the applicable period.
2. Do not infer fraud/event membership from public filings or independently manufacture the exclusion list.

Validation to perform later:

- After receipt, check the prepared schema and keys against the supplied Stata merges and compare period/population documentation before any authorized run.

### A_COMPANN: Confirm the exact author-prepared comp_ann product or a documented mapping from the local COMP.FUNDA candidate, including the SIC fields, identifiers and annual history used in both joins.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COMPANN, I_COMPANN_COMPATIBILITY
Evidence: E_MASTER_COMPANN, E_MASTER_COMPJOIN, E_MASTER_DISTANT_JOIN, E_COMPANN_CATALOG, E_COMPANN_FIELDS, E_COMPANN_PROBE

Preparation / proposed procedure:

1. Request the comp_ann source alias or author mapping for gvkey, sic2 and fyear and the required fiscal-year period; the checked COMP.FUNDA candidate exposes historical SIC as sich but is not established as a drop-in input.
2. Confirm any SIC transformation and its timing from the authors; do not silently substitute sich or assume a two-digit mapping.

Validation to perform later:

- After the mapping is documented, verify the selected source fields and required year coverage with bounded metadata and compare both gvkey and sic2 joins in a portable copy.

### A_DOWNLOADLIST: Obtain the actual downloadlist.txt worklist and its schema/producer contract, and determine whether the separately named downloadindex.sas7bdat is an upstream alternative or a required input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_DOWNLOADLIST, I_DOWNLOADLIST
Evidence: E_NOTEBOOK_FILELIST, E_NOTEBOOK_DOWNLOAD, E_NOTEBOOK_PERIOD, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Request the author-prepared list or its exact preparation steps, including row keys, filing identifiers, date/form fields and expected path/encoding.
2. Treat downloadindex.sas7bdat as a possible upstream preparation contract only until a direct code read or author specification establishes otherwise.

Validation to perform later:

- Before any future acquisition, compare the list schema and selected 2002-2016 10-K-family population to the notebook's safe visible parser/output contract and the official public filing product.

### A_SEC_FILINGS: The official EDGAR source is a verified public route to raw filings for the declared period; acquisition is still future work and must follow the author-list contract and notebook compatibility checks.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_SEC_FILINGS
Evidence: E_SEC_PUBLIC, E_NOTEBOOK_PERIOD, E_NOTEBOOK_FILELIST, E_LM10X_PATHS

Preparation / proposed procedure:

1. Once the downloadlist contract is known, acquire only the required public 2002-2016 filing records and raw text through the official EDGAR route in a separately authorized data-acquisition step.
2. Do not treat the stat-only local roots or cleaned LM 10-X candidate as verified raw-text substitutes; keep any permitted public/local alternatives separate.

Validation to perform later:

- Verify filing population, form/date coverage, raw-text format and Item 7/8 extraction compatibility against the author list before a future author-workflow run.

### A_MDA_OPAQUE_BLOCK: Resolve the notebook's withheld downloader/control contract from a reviewed redacted source copy or author specification while keeping any literal connection/configuration values undisclosed.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_MDA_OPAQUE_BLOCK
Evidence: E_SOURCE_SCREEN, E_NOTEBOOK_SAFE_VIEW, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Request a reviewed non-secret description or redacted source excerpt for cached lines 242-266 that retains the control flow, worklist fields, request method/target class, output file/schema and directory mapping.
2. Do not expose or probe withheld literal values and do not run the notebook or issue a request during this assessment.

Validation to perform later:

- Before future acquisition, confirm that the documented request path uses the official public filing product and that the worklist and output schema match the visible extraction functions.

### A_DISTANT_EVENT_YEAR: Clarify the producer and mapping for evt_yr in the distant-peer panel after the sic2 join; the supplied code does not establish that it comes from Compustat.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_DISTANT_EVENT_YEAR
Evidence: E_MASTER_DISTANT_JOIN, E_MASTER_DISTANT_EVENT, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Request the author's event-year source, join key and timing rule for the distant-peer branch, including any field supplied by cplist or a prepared intermediate.
2. Preserve the supplied event-time definition; do not insert an inferred evt_yr from COMP.FUNDA or another source.

Validation to perform later:

- After a source contract is supplied, trace the field through the sic2 join and verify its presence before the line that computes evt_time in a portable working copy.

### A_EVT_YEAR_RENAME: Correct the SIC3 loop's name reference to the event-year variable actually written to tmp1.dta.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I_EVT_YEAR_RENAME
Evidence: E_MASTER_FLIST_FIELDS, E_MASTER_TMP1, E_MASTER_RENAME, E_WORKFLOW_TRACE

**Proposed edit:** `BDSY-datasheet-and-code/master_do_file.do:89–89`
Source SHA-256: `046d7df02bf7194a435e3b96030d527adb0727ac2e62b1a1dad35fc9bcef57f2`

The preceding flist stage keeps evt_yr and saves it in tmp1.dta; the consumer should use that exact field while preserving the event-year definition.

Current text:
```
	rename evt_year evt_check
```

Proposed replacement:
```
	rename evt_yr evt_check
```

Preparation / proposed procedure:

1. Apply this one-variable-name correction only in a separate portable working copy after preserving the original package bytes.

Validation to perform later:

- Review the copy's one-line diff against the frozen file hash and verify the producer/consumer name agrees; execution remains a separate authorized step after data and path gaps are closed.

### A_ROOT_CONFIGURATION: Configure the Stata and notebook branches to use separate, coherent relative paths in a portable working copy without copying the machine-specific notebook path or using an absolute Dropbox workspace path.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I_ROOT_CONFIGURATION
Evidence: E_MASTER_CPLIST, E_MASTER_DEMO_CALL, E_NOTEBOOK_DOWNLOAD, E_WORKFLOW_TRACE, E_SIM_ROOT_RESET

Preparation / proposed procedure:

1. In the separate portable copy, set master_do_file.do line 7 and sim_sample.do line 10 to the same relative BDSY-datasheet-and-code root from the chosen Stata working directory. sim_sample.do resets global jar at line 10 before loading sim_sample.dta at line 12; make the master line 110 include resolve as $jar/sim_sample.do.
2. Keep the prepared comp_ann input in the documented Stata current directory or use a coherent relative location after its input contract is confirmed.
3. In the notebook copy, set its existing filepath configuration to a relative MDA-Section directory containing the confirmed downloadlist.txt, preserving a separate directory for the Python branch.

Validation to perform later:

- Before any separately authorized run, confirm the master and included script both resolve global jar to the same directory, the line-110 include resolves to sim_sample.do, and the packaged synthetic input is reachable there; also verify notebook paths and host visibility/write access without running author code.


## Remaining issues and prerequisites

- I_CPLIST_CONSTRUCTION [unresolved; full_pipeline]: cplist.dta is an active repeated input, but is absent from the inventory and has no supplied producer or defined peer/cohort construction contract.
- I_FLIST_CONSTRUCTION [unresolved; full_pipeline]: flist.dta is an active repeated input, but is absent from the inventory and has no supplied fraud-event population/variable construction contract.
- I_COMPANN_COMPATIBILITY [unresolved; full_pipeline]: The named Compustat annual input has no supplied local file or explicit physical path. Its source columns and transformations do not establish all join keys/event variables the downstream peer panels require.
- I_DOWNLOADLIST [unresolved; full_pipeline]: The notebook declares a downloadlist.txt worklist under its configured directory, but the file is not in the package inventory; its row mapping cannot be verified. The separately cited downloadindex.sas7bdat is not established as a joint requirement.
- I_MDA_OPAQUE_BLOCK [unresolved; full_pipeline]: The notebook's line 242–266 downloader/control block remains opaque after a conservative security screen. Its request target/configuration and exact output mapping are not inferred from the withheld text; no connection or request was made.
- I_DISTANT_EVENT_YEAR [unresolved; full_pipeline]: The distant-peer branch keeps only i and sic before its sic2 join, then uses evt_yr to create evt_time. The source of evt_yr in that produced panel is not specified; do not assign it to Compustat without schema evidence.
- I_EVT_YEAR_RENAME [preparation; full_pipeline]: The master creates tmp1.dta with evt_yr, but the SIC3 loop renames evt_year. This exact name mismatch is repairable in a portable working copy without changing the event-year definition.
- I_ROOT_CONFIGURATION [preparation; full_pipeline]: The master Stata global root and include use placeholders, the included sim_sample.do resets global jar to its own placeholder before reading sim_sample.dta, and the notebook uses a machine-specific folder setting. Configure the Stata caller/callee roots consistently and set separate relative paths for the two branches in a portable working copy.
- R_CPLIST [undetermined]: Author-prepared cplist.dta read by the master Stata workflow. The supplied code uses gvkey, i, sic, sic3, and evt_yr in close-peer and distant-peer construction; its row population and construction are not specified in the supplied code.
- R_FLIST [undetermined]: Author-prepared flist.dta read to exclude fraud firms and create SIC3/event-year comparisons. The code uses gvkey, sic3, and evt_yr; the fraud-event population, variable definitions, and construction are not supplied.
- R_COMPANN [undetermined]: The Stata code expects an annual Compustat input named comp_ann and uses gvkey, sic2 and fyear/event-year fields in two peer branches. The local COMP.FUNDA file is a readable candidate, but its prepared alias, SIC mapping, required years and event-year handoff are not established.
- R_DOWNLOADLIST [undetermined]: The notebook's downloadlist.txt worklist in its configured MDA-Section folder. The package inventory contains neither this file nor the separately named downloadindex.sas7bdat; the latter is not established as a direct code read.
- R_SEC_FILINGS [public_acquisition_required]: Raw filing text for the notebook's documented 2002-2016 10-K-family MD&A extraction branch. Official EDGAR documentation verifies a public raw-filing/index route for this period; exact list selection, request interface, local corpus compatibility and output mapping remain unresolved because the request/control block is withheld.

## Review notes

- Assessment covers both supplied branches as separate workflows. The packaged cc-info.csv is documented/readable MD&A material, but the Stata master does not consume it; no notebook-to-Stata bridge is treated as a mandatory dependency.
- The included Stata estimates are explicitly a synthetic illustration: sim_sample.do reloads sim_sample.dta and creates a random-normal icc. The supplied release does not provide a verified empirical analysis panel or empirical estimator route, and none is invented as a prerequisite for attempting its included demonstration.
- SAS appears in the datasheet's historical description of data conversion, but no SAS program or specific SAS input/output contract is supplied and the Stata driver does not invoke SAS. SAS is retained as context, not a required runtime for the supplied Python and Stata branches.
- Notebook cached source lines 242-266 remain conservatively opaque under the assigned security screen. No request target, connection configuration, or output mapping is inferred from those values; no payload request or notebook execution was made.
- The Stata peer branch has unresolved author-prepared cplist.dta and flist.dta inputs, an unresolved comp_ann field/period contract, an unspecified evt_yr source in the distant-peer join, and a supported evt_yr/evt_year name correction in a portable copy.
- No author program, notebook, estimator, SAS process, synthetic-data process, or SEC filing payload was executed or downloaded. Inspection used assigned static sources, exact-path stat checks, catalog metadata, installed-package metadata, and bounded one-row format/schema probes; those samples do not establish population or historical coverage.
- Local SEC raw/parsed roots and exact Loughran-McDonald 2002-2016 year directories were checked by stat only; no file listing or content read occurred. The official SEC access page supports a public raw-filing route, but compatibility of local corpora and the notebook's specific worklist/request block remains unresolved.
- COMP.FUNDA is a local metadata/readability candidate, not a proven comp_ann substitute. The bounded probes read one row each and do not establish full schema population, source history, field coverage or access rights.
