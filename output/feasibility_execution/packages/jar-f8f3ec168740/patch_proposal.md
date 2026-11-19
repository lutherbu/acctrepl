# Patch proposal: jar-f8f3ec168740

Limited Attention: Implications for Financial Reporting

DOI: 10.1111/1475-679X.12432

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | not_applicable | no_runnable_code |

### full_pipeline

The assessed target is the as-downloaded online appendix's supplementary theoretical analyses, proofs, and six numerical figures. This one-file release supplies mathematical content but no executable computational workflow. The scope does not infer the main article's unprovided empirical or paper-wide analyses; the appendix's main-text references remain an explicit context gap.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 5/12432 - Limited-Attention-Implications-for-Financial-Reporting/jlu-online-appendix.pdf",
      "sha256": "e97f0a95c9f986ff082dfa0ecb5d94ec397160a64fd0db1139b7b5917f57940e"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "1e9ca795a16aa9b3bdafa76f137245d90d0779f0ef80a09ceba40ffe85262ecf"
}
```

## Proposed actions

### action_request_author_workflow: Request the authors' actual computational source or a complete documented manual/computational recipe for the appendix's IPO and bank-run numerical verifications and Figures 1–6, plus the cited main-text model definitions required to interpret them. Do not substitute a new solver or reconstruct the research from equations.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: issue_missing_workflow, issue_main_text_context
Evidence: ev_numerical_methods, ev_ipo_numeric, ev_bank_numeric, ev_figure2_settings, ev_figure3_settings, ev_figure5_settings, ev_figure6_settings, ev_main_model_reference, ev_supplementary_proofs, ev_complete_source_trace

Preparation / proposed procedure:

1. Request the original program or the authors' complete actual numerical procedure and run instructions for the appendix's numerical claims and six figures.
2. Ask the authors to identify the software/version and any actual parameter grids, evaluation/optimization settings, and required inputs used, where applicable; the existing figure captions' stated parameter values are preserved as supplied.
3. Obtain the referenced Section 2 and Section 4 model definitions from the main text if they are not already supplied with the reproducibility materials.
4. Once supplied, inspect the actual source and dependencies, order its documented steps, and reassess required inputs and readiness before any separately authorized execution.

Validation to perform later:

- Confirm each appendix numerical claim and Figures 1–6 maps to an actual supplied entry point or documented manual step, with all required model definitions and inputs accounted for.
- Keep execution unverified until a separately authorized run checks the author's outputs.


## Remaining issues and prerequisites

- issue_missing_workflow [blocking; full_pipeline]: The assigned inventory contains only this mathematical online appendix. It reports numerical verification and presents six figures with some captioned parameter settings, but supplies no executable program, launch driver, identified software, or complete numerical reproduction procedure. Equations and proof derivations are model content, not an executable program. The appendix figures and numerical claims therefore cannot be rerun from this package alone.
- issue_main_text_context [unresolved; full_pipeline]: The appendix refers to Section 4 and Section 2 of the main text for model setup and proof expressions, but the frozen package contains only the online appendix. The exact referenced definitions are needed to interpret the supplementary material in context; no substitute definitions are inferred.

## Review notes

- Scope is limited to the sole as-downloaded online appendix in the frozen inventory. The title is consistent with the registered frozen header; no DOI conflict appears in the supplied source.
- The full cached appendix (lines 1–906) was read. Its equations, parameter statements, proofs, and numerical-verification prose are not treated as runnable code. The six figure captions do state parameters, so the assessment does not claim those settings are absent because of PDF text extraction.
- No empirical dataset, named software/product, author code, or author numerical recipe is supplied in this package. No empirical data requirement or analysis-only scope is invented; no catalog/product lookup was required because the source names no required product.
- No original-page render, model solution, numeric calculation, software probe, author contact, or broader package scan was performed. The static audit is cited only as a discovery aid; the direct complete source review supports the code-presence finding.
- A first finalized checkpoint had an incorrect source-reading cwd in its inspection trace. Its draft, trace, output pair, preflight record, and controller diagnostic are preserved read-only under probes/pre_correction_20261110T162643Z; the corrected trace records the workspace cwd for the full-source reads and the generation cwd for draft construction. The scientific source findings did not change.
- Controller attempt 002's retained input snapshot pointed to preflight_runner_result.json for the earlier draft. The actual submitted draft had already passed probes/preflight_runner_result_002.json; the original controller record is unchanged and paired with the pointer-only correction descriptor at probes/finalize_attempt_002_pointer_addendum.json. The controller invocation and source findings did not change.
