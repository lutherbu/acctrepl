# Patch proposal: jar-cebecb552281

Aggressive Boards and CEO Turnover

DOI: 10.1111/1475-679X.12350

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | not_applicable | no_runnable_code |

### full_pipeline

Assess the complete workflow represented by the supplied theoretical online appendix, including its continuous-type model results and model-based numerical illustrations in Appendix C.3 (Figures 6–11). The appendix documents assumptions and results but does not supply an executable computation or plotting workflow. This release does not support an empirical CEO-turnover replication target.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 2/12350 - Aggressive-Boards-and-CEO-Turnover/ah-online-appendix.pdf",
      "sha256": "ac95c1f028b4dca69383c59e8bb768cfd9c31f95178857ff47e05f59ba6647e1"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "787845736a9710413db66bd8a728a8ba15fc41708f78045d74ca45bcacfa629c"
}
```

## Proposed actions

### action-obtain-numerical-workflow: Obtain the author-provided computational workflow for Appendix C.3 before attempting to regenerate its numerical figures.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue-no-runnable-program
Evidence: ev-numerical-settings, ev-second-type-illustration, ev-source-review

Preparation / proposed procedure:

1. Request the executable source or a step-by-step calculation and plotting recipe for each documented Appendix C.3 output: Figure 6 (objective and selected aggressiveness), Figure 7 (misreporting probability and interval width), Figure 8 (manager-selection gain and equilibrium versus optimal cutoffs), Figure 9 (three type-group contributions), Figure 10 (normal-type objective), and Figure 11 (normal-type counterparts of Figures 7 and 8).
2. Request the computation method, exact parameter grids/ranges, intermediate values or files, and any other inputs used to generate those plots.
3. Request the actual software/runtime and release plus any computational input files; preserve the stated distributions and parameter values in the appendix as specification evidence, not as a substitute for missing code.
4. When the author workflow is supplied, inspect its complete producer-to-figure sequence and input definitions in a working copy, then stage an authorized reproduction using those specified materials.
5. Keep empirical CEO-turnover analyses outside this release-specific target unless corresponding author materials are supplied and separately assessed.

Validation to perform later:

- After the workflow, inputs, and software are available, verify that the documented procedure reproduces Figures 6–11 and the stated illustrative optimum c ≈ 0.4775 and normal-type case N(10,1), without changing model definitions or assumptions.


## Remaining issues and prerequisites

- issue-no-runnable-program [unresolved; full_pipeline]: The sole supplied artifact is a mathematical appendix. Appendix C.3 reports model-based figures 6–11 and numerical settings, but provides no executable program, numerical procedure, manual/GUI recipe, named software/runtime, or computational input file from which those figures can be regenerated. The target is limited to the supplied theory and illustrations; the paper title does not establish an empirical CEO/board dataset dependency.

## Review notes

- Final source coverage: all 1,650 cached appendix lines were read in six contiguous ranges; original PDF pp. 10–16 were rendered, visually inspected, and preserved with hashes in probes/source_review.json. The work-item inventory contains only ah-online-appendix.pdf and its dependency checklist is empty; the static report says no_supported_code, treated only as discovery evidence.
- Content review finds mathematical theory, propositions/proofs, stated model assumptions, and figures 6–11; it contains no executable code, calculation algorithm, manual/GUI workflow, named software/runtime, or observed empirical input dataset. The release-specific target is the appendix’s theory and model-based numerical illustrations, not unprovided paper-wide empirical tests. No analysis-only scope is supported.
- No author code or study data were executed or reconstructed. No empirical-source or software-availability checks were performed because the appendix identifies no such dependency; calculation/plot production details and runtime remain unresolved pending author materials.
