# Patch proposal: jar-8754481109d2

Strategic Director Appointments

DOI: 10.1111/1475-679X.12351

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | not_applicable | no_runnable_code |

### full_pipeline

Scope limited to the supplied Internet Appendix: formal director-payoff/equilibrium proofs, the information-sharing extension and its parameterized Figure 4. The official abstract identifies the article as a theoretical framework; no empirical data input is indicated. The supplied PDF contains no executable program or complete reproduction recipe.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 4/12351 - Strategic-Director-Appointments/ds-internet-appendix.pdf",
      "sha256": "3bb250cfe5dea8d65003ffe48a0f585a691f845d7d9db6fe30d704e122e4770b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "5508f5f3df988e0e4d341eace8d274895cbb61700524cfa2efd3f8c182e48fcc"
}
```

## Proposed actions

### clarify_appendix_reproduction_method: Obtain the intended reproducibility procedure for this appendix before attempting an execution. No author contact or request is made in this assessment.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: no_executable_code, workflow_closure_unresolved
Evidence: ev_static_inventory, ev_prop8_omission, ev_proofs_upon_request, ev_figure_caption, ev_figure_page16

Preparation / proposed procedure:

1. Confirm whether the PDF is the entire distributed reproducibility material or whether separate author source files or instructions accompany it.
2. If supplementary workflow materials exist, obtain the complete entry source, documented inputs and outputs, dependency/software versions, and execution order; then trace its requirements before any separately authorized run.
3. If the authors intend a manual or formula-based reproduction, request the specific calculation and plotting steps for the equilibrium thresholds and Figure 4, including any intermediate values not defined by the appendix.
4. Treat the statement that additional proofs are available upon request as a lead only; do not contact authors or reconstruct the omitted derivation during this audit.

Validation to perform later:

- After separately authorized receipt of a complete procedure, verify that its inputs and ordered calculations produce the appendix's equilibrium regions and Figure 4 under the captioned parameter values, including X_B = -900.


## Remaining issues and prerequisites

- no_executable_code [blocking; full_pipeline]: The assigned package contains one 16-page Internet Appendix and no supplied executable program, entry-point file, or run instructions. Its substantive contents are formal proofs and a plotted theoretical figure. This is a confirmed no-runnable-code blocker for the supplied package only; it does not establish whether separate materials exist elsewhere.
- workflow_closure_unresolved [unresolved; full_pipeline]: The appendix does not specify a complete calculation/plotting procedure for reproducing the theoretical results. It explicitly omits Proposition 8's complete detailed proof and says proofs of two related assertions are available upon request. The package therefore has incomplete workflow closure until its intended procedure or supplementary materials are known.

## Review notes

- Assessment covers only the assigned 16-page Internet Appendix (all 777 cached lines read; original PDF page 16 inspected to verify Figure 4 and its parameter labels). The rendered caption shows X_B = -900; the literal cached caption quote prints XB = 900 because extraction dropped the minus glyph. The source is formal payoff/equilibrium analysis and a parameterized model figure; the official abstract classifies the paper as theoretical.
- The assigned package inventory contains a single PDF; the frozen dependency checklist has zero edges. No executable author program, entry point, run instructions or dataset is supplied here. No author code or study data were executed.
- No empirical data requirement is assigned to this theoretical target. Remaining limits are whether supplementary execution materials exist outside this package and the exact procedure, if any, to calculate/plot Figure 4 and complete the omitted Proposition 8 detail. The appendix's statement that proofs are available upon request is recorded as a lead only; no author contact was made.
