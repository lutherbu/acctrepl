# Patch proposal: jar-3b82b88126f1

The Value of Mandatory Certification: A Real-Effects Perspective

DOI: 10.1111/1475-679X.12460

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | not_applicable | no_runnable_code |

### full_pipeline

The supplied 799-line online appendix provides analytical equilibrium proofs and six parameterized theoretical figures (OA1-OA6). It includes manual analytical procedures, including a piecewise-profit maximization method for the OA5 audit-market extension, but no executable program, software specification or complete end-to-end plotting recipe. The only packaged author artifact is the appendix PDF.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 1/12460 - The-Value-of-Mandatory-Certification-A-Real-Effects-Perspective/jxx-online-appendix.pdf",
      "sha256": "110af744aec0d4145cf3e1a45c0305f5dd90564e08179cf4a261290bb3ceb9ee"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "8630ef11f58a44eaeb07f8c93a9133b98e54deb7dc139d4e95c04c16ab417273"
}
```

## Proposed actions

### ACTION_REPROCEDURE: Request the authors' complete recorded calculation and plotting steps for OA1-OA6, or any executable materials they used; identify software only if a tool was used and request specific main-text definitions only where needed to interpret an appendix result.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_NO_CODE, ISSUE_REPROCEDURE
Evidence: EV_WORK_ITEM, EV_STATIC_AUDIT, EV_APPENDIX_OPENING, EV_OA1_FIGURE, EV_OA2_FIGURE, EV_OA3_FIGURE, EV_OA4_FIGURE, EV_OA5_FIGURE, EV_OA6_FIGURE, EV_OA4_METHOD_MD, EV_OA4_METHOD_V

Preparation / proposed procedure:

1. For OA1-OA6, request the original calculations and plotting workflow, including any code if it exists.
2. Record whether the authors used manual calculations or a specified software tool; do not infer a solver or software from the equations.
3. Where the appendix refers to main-paper results or definitions, request only the specific material needed to interpret the supplied appendix workflow.
4. Keep the supplied PDF unchanged while reviewing any subsequently provided instructions or source files.

Validation to perform later:

- Check that the delivered procedure accounts for the OA1-OA6 parameter values and panel definitions.
- For the OA5 fee analysis, confirm that the described procedure covers the piecewise regimes and stated local/global comparisons.
- If no executable program exists, confirm that the manual steps and any software actually used are documented before assessing a future reproduction attempt.


## Remaining issues and prerequisites

- ISSUE_NO_CODE [blocking; full_pipeline]: No executable author program is supplied. The appendix contains analytical prose, equations and figure descriptions, but no launchable program or named software workflow.
- ISSUE_REPROCEDURE [unresolved; full_pipeline]: The appendix provides substantial manual analytical work: equilibrium proofs, parameterized figures OA1-OA6, and a piecewise-profit maximization procedure for the Figure OA5 audit-market extension. It gives no executable calculation or plotting workflow and names no software, so this release cannot be directly run or establish how the plotted panels were produced. References to main-paper results remain context rather than additional input requirements.

## Review notes

- The target is the as-supplied online appendix only. Its first page labels it 'Online Appendix' and does not state a conflicting title or DOI; the frozen work-item header is retained.
- The PDF contains analytical derivations and six parameterized theory figures: OA1-OA3 compare efficiency regimes, OA4 welfare, OA5 auditing-market structure, and OA6 long-term incentives. Their parameter statements are cited individually.
- No executable program, empirical dataset, named software, or named commercial/public product appears in the full appendix. No resource-catalog or official-product check was applicable; no hypothetical solver or empirical reconstruction was introduced.
- The appendix gives a manual piecewise-profit maximization procedure for the OA5 figure extension, but no software or complete plotting workflow. The source discovery lead was treated only as a lead; the assessment rests on full 799-line content review.
- The required credential-safe scan found no candidate credential/connection lines. Its scan record is preserved in probes as process evidence and is not cited as proof of the author workflow.
- The frozen dependency checklist is empty. The reading-text captions retain the figure parameters, so no original-page rendering was needed to resolve a material setting.
