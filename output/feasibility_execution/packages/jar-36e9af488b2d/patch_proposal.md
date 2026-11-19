# Patch proposal: jar-36e9af488b2d

Contractibility and Transparency of Financial Statement Information Prepared Under IFRS: Evidence from Debt Contracts Around IFRS Adoption

DOI: 10.1111/1475-679X.12095

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Complete author-documented workflow for the supplied appendix-only package variant; no runnable workflow is supplied.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 53/Issue 5/12095 - Contractibility-and-Transparency-of-Financial-Statement-Information-Prepared-Under-IFRS-Evidence-from-Debt-Con/balllishivakumaronlineappendix.pdf",
      "sha256": "7f659678456eb6539c5653601c59bb104366c543c05b0f73780de30132275b6f"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "d77f7ccb49c486264567568c3f64bde25baa4b90585885a43d4729de56454ec7",
  "work_item_sha256": "dac8c934540f91b999085d514281df179c4c117485cadc4696d35be1f3ff890b"
}
```

## Proposed actions

### action_request_complete_author_materials: Request the complete author materials for this paper/package variant: executable code and run instructions, a datasheet identifying author-prepared primary inputs and any hand-collected analysis inputs with products, fields, units and historical coverage, the stage order and software requirements, and a table/figure-to-entry-point map. Ask the authors to confirm whether the Table IA18 results and the referenced Internet Appendix III are missing or intentionally outside this release. Do not infer the complete dataset route from generic database references or the prospectus subset.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: issue_missing_code, issue_unknown_workflow_inputs, issue_appendix_coverage
Evidence: ev_inventory, ev_primary_data, ev_hand_collected, ev_ia18_text, ev_last_table, ev_text_inventory

Preparation / proposed procedure:

1. Obtain the author code, README/datasheet, dataset descriptions and documented preparation instructions for the intended paper release.
2. Confirm which outputs are in scope and whether Table IA18 or Internet Appendix III is separately supplied.
3. After receipt, map every supplied paper and appendix output to the author entry points and identify exact input fields, periods, handoffs and software.

Validation to perform later:

- Reassess every required data and software dependency against the supplied workflow, verify compatible acquisition/local routes, and confirm all in-scope outputs have a documented producer.


## Remaining issues and prerequisites

- issue_missing_code [blocking; full_pipeline]: The assigned package contains only an online appendix PDF and no executable author program, README/datasheet, or entry point, so the reported analyses cannot be run from the supplied variant.
- issue_unknown_workflow_inputs [unresolved; full_pipeline]: The appendix says primary analyses use machine-readable debt-contract data from various databases and describes a hand-collected prospectus subset for additional analyses, but the actual data products, author-prepared inputs, required fields, periods, preparation steps, software, and execution order are not specified. These descriptions are clarification leads, not independently established mandatory raw-source routes, so dependency closure and concrete data requirements remain undetermined.
- issue_appendix_coverage [unresolved; full_pipeline]: The appendix narrative describes results for Table IA18 Panels A and B, while the supplied appendix contains table headings only through IA17 and ends on page 46. Confirm whether IA18 results or a companion appendix are missing, or whether the narrative references are intentionally unfulfilled or misnumbered.

## Review notes

- The frozen dependency checklist is empty. The static package inventory contains only the online appendix PDF, so no analysis_only scope is supported by supplied code and compatible author-prepared analysis inputs.
- The appendix points to machine-readable debt-contract data, a hand-collected prospectus subset, and supplementary output tables. Their product identities and workflow roles remain clarification leads until author workflow materials are available.
- The table heading scan found IA1–IA17 while the narrative mentions IA18 Panels A and B; this is recorded as a package completeness question rather than a reconstructed analysis requirement.
