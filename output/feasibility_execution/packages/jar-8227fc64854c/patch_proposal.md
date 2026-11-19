# Patch proposal: jar-8227fc64854c

Mandatory and Voluntary Disclosures: Dynamic Interactions

DOI: 10.1111/1475-679X.12210

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | not_applicable | no_runnable_code |

### full_pipeline

The theoretical paper material represented in this release: the online appendix of analytic proofs and derivations for Sections 3–5 and a preference extension. This work item contains the appendix only; it has no executable entry point, and the main article context referenced by some derivations is outside the package.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 4/12210 - Mandatory-and-Voluntary-Disclosures-Dynamic-Interactions/cs-online-appendix.pdf",
      "sha256": "b4dc9afb4264eef7dcb17758c6cd5ccadf9e92703fdcd9c7e2c3e4e3b7c1472c"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "5582975869504316187f0cfba4728c0266b948ae86896b613c598efcfea22705"
}
```

## Proposed actions

### act_manual_proof_review: Manually verify the analytic derivations supplied in the appendix; there is no code or empirical input to execute.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: run procedure
Evidence: ev_lemma_proof, ev_fixed_point, ev_threshold_derivation, ev_investment_derivation, ev_second_best

Preparation / proposed procedure:

1. Use the paper’s stated theoretical assumptions and definitions to review the supplied proofs and derivations, including the threshold/fixed-point argument in Lemma 7 and equations (A23)–(A24), the Proposition 2 investment argument, and the Section 5 comparative statics.
2. Treat G, V1, V2, probability distributions and parameters as theoretical model objects, not as empirical input files; no numerical solver procedure or observed dataset is specified in this appendix.
3. Consult the article text for referenced definitions/equations such as (A13) and Appendix C equation (A18), then record any missing premise or mismatch.

Validation to perform later:

- A reviewer confirms the appendix derivations follow from the paper’s definitions and assumptions, including the referenced main-text equations.
- If the full article requires a numerical routine or empirical input beyond the supplied analytic material, record that as an additional workflow dependency before execution.

### act_clarify_article_scope: Confirm the complete article-level reproducibility target and whether any computational workflow accompanies the theoretical results.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: issue_missing_workflow
Evidence: ev_inventory, ev_second_best, ev_wiley_abstract

Preparation / proposed procedure:

1. Consult the published article identified by the DOI for its complete definitions and stated target results; the appendix cross-references article material outside this package.
2. If those results depend on numerical computation, a program, or observed data not represented in the appendix, request the corresponding author workflow and specification before assessing execution feasibility.
3. If the paper’s target is fully analytical, record manual proof verification as the applicable workflow and retain the no-runnable-code outcome for this release.

Validation to perform later:

- The article-level result set and whether any executable or empirical component is required are confirmed from the article or author documentation.


## Remaining issues and prerequisites

- issue_missing_workflow [unresolved; full_pipeline]: The frozen package inventory contains only the supplementary online appendix. Its contents provide substantive analytic proofs and derivations, including implicit threshold/fixed-point relations and first- and second-best investment arguments, but no runnable program or numerical algorithm. The proofs also reference article equations and Appendix C outside this release, so the complete article-level workflow cannot be established from this package alone. This is a release/workflow limitation, not evidence that observed empirical data are required.

## Review notes

- Inference from the appendix’s formal threshold, expectation and investment derivations together with the Wiley abstract: the target is theoretical; model variables and fixed parameters are not observed empirical data. Accordingly data_required is false and data_status will be not_applicable.
- The proofs constitute substantive manual analytical content. They are credited as such; the release remains limited to the online appendix and does not establish an executable program or the full paper-level workflow.
