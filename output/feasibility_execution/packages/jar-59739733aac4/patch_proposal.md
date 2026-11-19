# Patch proposal: jar-59739733aac4

Measuring Greenhouse Gas Emissions: What Are the Costs and Benefits

DOI: 10.1111/1475-679X.12613

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | not_applicable | no_runnable_code |

### full_pipeline

Supplied online appendix only: analytical model extensions and proofs, plus the captioned numerical Figure 2; no executable workflow is supplied.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 3/12613 - Measuring-Greenhouse-Gas-Emissions-What-Are-the-Costs-and-Benefits/msz2025-online-appendix.pdf",
      "sha256": "8832b533c57fe229d8bd548bdfef8c32ba51eaa9108b57c6894130dbc22bf98f"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "c78024baa66687496ffa6c4c07dcfc4a2f169d5d217876461dd12e2e9eb8e5fc"
}
```

## Proposed actions

### A_CLARIFY_IMPLEMENTATION: Confirm whether this appendix-only PDF is the intended complete reproduction release. If computational reproduction of Figure 2 is intended, obtain the author-supplied plotting/calculation program or an explicit reproducible procedure, including the software/runtime and any concrete inputs it consumes; retain the published parameter settings and do not assume an external dataset.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_MISSING_PROGRAM
Evidence: E_PACKAGE_INVENTORY, E_STATIC_AUDIT, E_DOC_NUMERICAL, E_PAGE15_REVIEW

Preparation / proposed procedure:

1. Ask whether separate companion code or run instructions exist for this online appendix.
2. If numerical reproduction is intended, request the supplied driver, its software/version and invocation, and a precise input/output contract; the Figure 2 caption already provides its parameter settings.

Validation to perform later:

- If materials are supplied, trace the entry point, calculation dependencies, software and outputs, and confirm the implementation uses the captioned Figure 2 settings before any separately authorized run.


## Remaining issues and prerequisites

- I_MISSING_PROGRAM [unresolved; full_pipeline]: The frozen package inventory contains only the online appendix PDF. It presents analytical model extensions and proofs and a numerical Figure 2, but no executable program, launch instructions, software/version, or numerical plotting implementation. No empirical input is identified for this appendix; if computational reproduction of Figure 2 is intended, the implementation is an unresolved prerequisite.

## Review notes

- The assessed target is the supplied appendix only. The frozen inventory and architecture report contain no separate script, dataset, data description or run instructions; analyses from the main paper are not inferred as mandatory inputs.
- The appendix is a theoretical model extension/proof document with one captioned numerical illustration. No empirical input is identified for this supplied workflow, so data_required is false; the absence of an executable implementation is recorded separately.
- Pre-display screening flagged one candidate line at cached-text line 977. The entire corresponding PDF page 17 (cached-text lines 939-989) was withheld from inspection. No candidate text was displayed or used; this remains a source-review boundary, not a confirmed credential, data-access finding, or blocker.
