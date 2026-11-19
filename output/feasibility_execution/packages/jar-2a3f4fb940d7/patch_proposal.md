# Patch proposal: jar-2a3f4fb940d7

The Valuation Impact of SEC Enforcement Actions on Nontarget Foreign Firms

DOI: 10.1111/1475-679X.12098

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

Complete author-documented workflow for the supplied appendix-only package variant; the appendix describes sample construction and reports supplemental analyses, but supplies no runnable program.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 54/Issue 1/12098 - The-Valuation-Impact-of-SEC-Enforcement-Actions-on-Nontarget-Foreign-Firms/silvers-online-appendix.pdf",
      "sha256": "820971e5d676fd68c596ec73a596797c50f87a28e6546a9e032a33188bb31954"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "d77f7ccb49c486264567568c3f64bde25baa4b90585885a43d4729de56454ec7",
  "work_item_sha256": "a4bd58edbb87a8d3227a4898f28e3978f59018bec6383e3a8aca304829648765"
}
```

## Proposed actions

### action_request_author_replication_materials: Request the complete author replication materials for this paper variant: runnable code and run instructions, a datasheet and the author-prepared event/sample and analysis inputs (or exact input products, fields, units and historical coverage), documented manual coding and preparation steps, execution order and software requirements, and a map from the paper and supplemental tables/figure to their producing programs. Do not independently reconstruct event coding or infer complete data requirements from the appendix source references.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: issue_missing_code, issue_unknown_workflow_inputs
Evidence: ev_inventory, ev_sample_process, ev_event_data, ev_firm_coverage, ev_supplement, ev_figure

Preparation / proposed procedure:

1. Obtain the author code, README/datasheet, machine-readable event/sample files, analysis input descriptions and documented manual preparation instructions for the intended release.
2. Confirm author-defined inputs, their required fields and periods, the mapping between event-level and firm-level observations, and the full stage order.
3. Map all in-scope paper and appendix outputs, including the supplementary tables and Figure I, to their author entry points.

Validation to perform later:

- Reassess the complete data and software dependency closure against the supplied workflow, verify compatible local or public routes for each required input, and confirm every in-scope output has a documented producer.


## Remaining issues and prerequisites

- issue_missing_code [blocking; full_pipeline]: The assigned package contains only the online appendix PDF and no executable author program, README/datasheet, or entry point; the tables and figure are reported results, not runnable code.
- issue_unknown_workflow_inputs [unresolved; full_pipeline]: The appendix describes manual assembly and coding of 172 SEC enforcement events and reports firm-year coverage under Compustat and accounting accrual measures, but no machine-readable event/sample data, field definitions, complete input products and histories, code, preparation sequence, software requirements, or table/figure-to-script mapping are supplied. Source names and historical collection steps are clarification context, not independently established mandatory live raw-source routes. Data requirements and dependency closure remain undetermined.

## Review notes

- The frozen dependency checklist is empty. The bounded package inventory contains only the appendix PDF, so no analysis_only scope is supported by supplied code and compatible author-prepared analysis inputs.
- The appendix provides sample-construction context, selected coverage facts, supplemental regression tables and a figure; its historical source references do not by themselves establish all mandatory live data dependencies or a reproducible workflow.
