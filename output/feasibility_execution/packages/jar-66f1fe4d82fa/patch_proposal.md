# Patch proposal: jar-66f1fe4d82fa

Discontinuous Distribution of Test Statistics Around Significance Thresholds in Empirical Accounting Studies

DOI: 10.1111/1475-679X.12579

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | local_available | undetermined |

### full_pipeline

Complete author-documented Stata workflow, including preparation, sample construction, figures, tables, and the formula-bearing archival workbook as supplied program content. The workbook is consumed as an input; formula presence alone does not add a live spreadsheet recalculation stage.

Entry points: `00_Master_file.do`, `test_stats_archival.xlsx`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 1/12579 - Discontinuous-Distribution-of-Test-Statistics-Around-Significance-Thresholds-in-Empirical-Accounting-Studies/cgl-datasheet-code-and-log-files.zip",
      "sha256": "a073d4330cf3413598b1af1ad606326a413de3c11ac793d25897b145fe78042d"
    },
    {
      "path": "JAR-Volume 63/Issue 1/12579 - Discontinuous-Distribution-of-Test-Statistics-Around-Significance-Thresholds-in-Empirical-Accounting-Studies/cgl-online-appendix.pdf",
      "sha256": "4b17b2b7d8c13bbd6570f805233d07bb757544031e914ba2a30eeba018af3c09"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "6385184bd5f4618252dc9dc44d2d42a66d3fb0ec589591024cc67c1149f639d9"
}
```

## Proposed actions

### A_HEADER_ALIGNMENT: Keep both exact supplied workbook inputs. Align only raw headers to downstream names if the native Stata firstrow import does not already do so: test statistics to teststatistics for the archival workbook, and the unique why? column to why for the vague XLS. This is conditional same-data preparation; no value, row, formula or study definition changes.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_ARCHIVAL, R_VAGUE
Evidence: E_ARCHIVAL_PROBE, E_ARCHIVAL_FIELD_TARGET, E_VAGUE_HEADER_ROUTE, E_VAGUE_TARGET, E_VAGUE_EXACT_TARGET

Preparation / proposed procedure:

1. Use test_stats_archival.xlsx as supplied; first confirm the imported header corresponding to raw test statistics and the downstream teststatistics name. If needed, map that one source column in the imported data.
2. Use test_stats_vague.xls as supplied; retain raw underlying field why? and map its unique source column to downstream why only if native import does not already expose that name.
3. Do not alter row values, drop observations, edit workbook bytes, open Office, or recalculate formulas.

Validation to perform later:

- In a future authorized Stata session, perform a header-only import check with no row values displayed; confirm both source-to-target mappings.
- Then verify the existing import/filter statements refer to the intended columns before running the author workflow.

### A_ADDON_SETUP: Provide and configure the eight required Stata add-on commands on the project ado path, preserving the author-invoked command semantics. No package was installed during this assessment.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: I_ADDONS, SW_MATCHIT, SW_MMERGE, SW_CURVEFIT, SW_CHITESTI, SW_AKDENSITY, SW_ASDOC, SW_MATSELR_C, SW_MATMAP
Evidence: E_PROBE_MATCHIT, E_PROBE_MMERGE, E_PROBE_CURVEFIT, E_PROBE_CHITESTI, E_PROBE_AKDENSITY, E_PROBE_ASDOC, E_PROBE_MATSELR_C, E_PROBE_MATMAP, E_SRC_MATCHIT, E_SRC_MMERGE, E_SRC_CURVEFIT, E_SRC_CHITESTI, E_SRC_AKDENSITY, E_SRC_ASDOC, E_SRC_MATSELR_C, E_SRC_MATMAP

Preparation / proposed procedure:

1. Obtain or configure compatible versions of matchit, mmerge, curvefit, chitesti, akdensity, asdoc, matselrc, and matmap in the configured Stata ado path.
2. Keep wmat as the asdoc subcommand; do not seek a separate wmat package.
3. Retain the full stages and study analyses that call these commands.

Validation to perform later:

- In the configured Stata environment, run `which` for each of the eight actual command names and confirm successful resolution.
- After the other path, scheme, and export gaps are resolved, run the existing master workflow and confirm the commands complete without changing sample or estimator definitions.

### A_SCHEME_SETUP: Establish availability of the author-requested lean2 graph scheme in the configured Stata environment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: I_SCHEME, SW_LEAN2
Evidence: E_SRC_LEAN2

Preparation / proposed procedure:

1. Check whether scheme(lean2) is available in the configured Stata ado path.
2. If unavailable, obtain the exact referenced scheme from its documented source or the package author; preserve the requested plot styling and avoid an unsupported substitute.

Validation to perform later:

- Confirm the configured Stata environment resolves lean2 before running the figure and table stages.

### A_EMF_SETUP: Resolve the documented Windows-only EMF export requirement while preserving all figure calculations and content.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: I_EMF
Evidence: E_SRC_EMF_OUTPUT, E_MASTER_EMF_OUTPUT, E_EMF_OFFICIAL

Preparation / proposed procedure:

1. Confirm the Stata edition/platform available for the run supports as(emf).
2. If no compatible Windows Stata context is available, obtain the authors’ required figure format or agree on a Stata-supported same-figure output format; preserve graph data, labels, and analysis.

Validation to perform later:

- Before the full run, confirm the selected Stata context supports the chosen output format; do not perform an export trial during this assessment.

### A_PATH_SETUP: Resolve the macro-based run-directory mapping for the supplied numbered Stata programs and inputs. The released safe view withholds two master lines, so their effect remains unassessed.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_CODE_PATH
Evidence: E_MASTER_STAGE_10, E_MASTER_STAGE_20, E_MASTER_STAGE_30, E_MASTER_STAGE_40, E_SAFE_VIEW_MANIFEST, E_SAFE_VIEW_VERIFICATION

Preparation / proposed procedure:

1. Confirm the effective `$dir` value points to the assigned package directory containing the four input files and numbered do-files.
2. Confirm the same configured working directory is used for generated sample intermediates and result files.
3. If either setup fact cannot be established from the released safe instructions, request a value-free setup clarification; do not infer a missing input or connection failure.

Validation to perform later:

- Before the workflow run, verify the resolved paths for the listed files without opening data rows or executing author code.
- After an authorized run, confirm sample_exp_pvalue, sample_pvalue, sample_article, sample_bootstrap and the declared result outputs are written at the expected locations.

### A_FULL_RUN_PROCEDURE: After the specified setup items are resolved, run the complete author workflow through its master entry point, including the nested ordering, figure-modification, and bootstrap programs.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I_CODE_PATH, I_ADDONS, I_SCHEME, I_EMF
Evidence: E_DATASHEET_SCOPE, E_MASTER_STAGE_10, E_MASTER_STAGE_20, E_MASTER_STAGE_30, E_MASTER_STAGE_40, E_CLEAN_NESTED_ORDER, E_FIG_NESTED_MODIFIER, E_TABLE_NESTED_BOOTSTRAP, E_BOOTSTRAP_OUTPUT, E_ENVIRONMENT

Preparation / proposed procedure:

1. Launch the registered Stata environment using its project-configured path so esttab and estadd resolve.
2. Run 00_Master_file.do from the confirmed package directory; retain the author-provided prepared inputs and execute every master-called stage.
3. Do not add a live spreadsheet recalculation step solely because the archival workbook contains formulas; Stata consumes the supplied workbook as an input.

Validation to perform later:

- Confirm the required intermediate datasets are created by their supplied producers before their consumers run.
- Compare the resulting declared figures and tables with the master output list, including EMF support, without dropping stages or changing study analyses.


## Remaining issues and prerequisites

- I_CODE_PATH [unresolved; full_pipeline]: The numbered Stata stages are supplied and called, but macro-based directory resolution for the complete run has not been established from the released safe views. This is a setup uncertainty, not absent code or data.
- I_ADDONS [preparation; full_pipeline]: Eight required Stata add-on commands are not available on the registered probed path: matchit, mmerge, curvefit, chitesti, akdensity, asdoc, matselrc, and matmap.
- I_SCHEME [unresolved; full_pipeline]: The required lean2 graph scheme is referenced by supplied table code but its availability in the configured Stata path has not been established.
- I_EMF [unresolved; full_pipeline]: The author workflow emits EMF figures, and Stata 18 graphics documentation describes EMF export as Windows-only. The registered environment proof does not establish a compatible Windows Stata context; no export trial was run.
- SW_MATCHIT [preparation_required]: Required command did not resolve on the registered probed path.
- SW_MMERGE [preparation_required]: Required command did not resolve on the registered probed path.
- SW_CURVEFIT [preparation_required]: Required command did not resolve on the registered probed path.
- SW_CHITESTI [preparation_required]: Required command did not resolve on the registered probed path.
- SW_AKDENSITY [preparation_required]: Required command did not resolve on the registered probed path.
- SW_ASDOC [preparation_required]: Required command did not resolve on the registered probed path; wmat is its subcommand.
- SW_MATSELR_C [preparation_required]: Required command did not resolve on the registered probed path.
- SW_MATMAP [preparation_required]: Required command did not resolve on the registered probed path.
- SW_LEAN2 [unverified]: The supplied table code requests scheme(lean2); availability has not been probed.

## Review notes

- This is an incremental clean draft. The complete dependency review, software checks, and linked actions are added in later saved steps before finalization.
- No author code, workbook, Office application, data row, formula cache, or model was executed or recalculated.
- The archival workbook is counted as supplied formula-bearing code and as the exact workbook imported by Stata. Formula/cached values were not inspected, Office was not opened, and no live spreadsheet stage is inferred solely from formula presence.
- Static source evidence supports the observed producers and consumers for sample_exp_pvalue, sample_pvalue, sample_article, and sample_bootstrap. The two withheld master lines remain an inspection limit; their effect is not inferred.
- The registered which nt/ntden command-name diagnostics and standalone which wmat diagnostic are preserved as inapplicable checks, not missing-software findings: nt()/ntden() are expression functions, and wmat is the asdoc subcommand. The separate documentation fetch failure remains a retrieval limit only.
- Source context uses nt() and ntden() as mathematical expressions; official Stata documentation identifies them as built-in noncentral-t functions. Preserve the earlier which-command rc111 diagnostics as inapplicable to expression availability. The only Windows-only technical limitation recorded is EMF export; current platform compatibility remains unresolved.
- The controls DTA is a separate mandatory requirement inferred from the visible sample-stage match/merge; it is absent from the frozen parser dependency list, so it is linked directly as R_CONTROLS. Frozen dependency D0016 reports line 845, which is blank in the released safe view; the actual sample_bootstrap read is cited at visible source line 847.
- Several frozen dependency line hints for generated intermediates land on blank lines in the verified safe views; the frozen IDs are retained, while citations use the actual visible producer/consumer locations: D0009 285/290, D0012 8, D0014 15, D0015 47, and D0016 847. These are line-metadata limits, not missing-file findings.
- The registered workbook probes report underlying raw headers. For the archival workbook, source code imports firstrow/allstring and later uses teststatistics; for the vague .xls, the unique raw why? column corresponds to downstream why. Native firstrow name sanitization was not trialed, so both are conditional same-data header-alignment steps, not confirmed source defects.
- A common-document review was stopped. The coordinator root disposition at runs/sweep_01/scope_incidents/jar-66f1fe4d82fa_common_document_root_disposition_20261112.json (SHA256 e60ce4f86373b1faf4f36256df15064dd5d4b2f9316a2445f45528947b36a0f8) says the prior unspecified configuration viewing was authorized and is not a confirmed credential/access violation. Actual content, type, value, validity, and capture extent remain unknown; no body was reread, copied, classified, or tested in this phase.
- Method history: an earlier truncated in-memory draft-builder attempt did not save its helper or capture, and its designated output was absent at the subsequent hash-only check. That original capture is missing and was not reconstructed; the new clean draft was built in saved incremental helpers.
- Method history: a saved source-evidence helper failed because it selected blank safe-view line 6 instead of visible line 8; its helper and actual tool traceback remain preserved, with no separate stdout/stderr capture file. A separate saved software-evidence helper failed on a manually transcribed curvefit hash; its helper and actual tool traceback remain preserved, with no separate stdout/stderr capture file. The corrected successful helper derives probe digests from pinned verified-existing-artifacts metadata and exact artifact bytes.
- Method history: an initial safe-view verification path and an initial packaged_2 hash transcription were wrong; both were corrected before any source/data value display, and the pinned safe-view verification and actual packaged_2 digest then matched. The initial root-disposition path projection also used the wrong parent directory; the corrected sweep_01/scope_incidents path matched its pinned SHA and no disposition body was read in the failed attempt.
- Frozen dependency IDs are retained even where their line hints land on blank lines in the released safe views; citations use the visible source locations documented above. These are line-metadata limits, not missing-code or missing-data findings.
- The original frozen .xls reader limitation and failed exact-version document retrieval remain separate process records from the successful custom xlrd header-only capture. The custom capture queried/emitted zero data rows; the normalized route record is clearly attributed to that capture and is not represented as the frozen probe.
- The formula-bearing archival workbook counts as supplied program code, while the supplied Stata producer programs remain separately identified. No formula text, cached row values, workbook application, or recalculation was used. Readability/header probes do not establish complete population coverage.
- No author program, Stata study analysis, SAS startup, software installation, dataset download, connection/API, Office application, model, export, or generated figure/table trial was run.
