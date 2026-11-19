# Patch proposal: jar-70be7c44828d

Shareholder Votes and Proxy Advisors: Evidence from Say on Pay

DOI: 10.1111/1475-679X.12024

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | no_runnable_code |

### full_pipeline

The supplied variant is an online appendix with narrative examples and reported event-study results. It includes no executable author workflow, observation-level dataset, data description, or run procedure.

Entry points: No runnable entry point established.

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 51/Issue 5/12024 - Shareholder-Votes-and-Proxy-Advisors-Evidence-from-Say-on-Pay/online_appendix_jar_aug2.pdf",
      "sha256": "80663b5c0cb6e57b36f4b61bda06d65b7744084a98eb6293253e35b67357615d"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "a257ea088bca727f8f8088228131f6ac1f3b836552dafe971698f13dacc231ee",
  "work_item_sha256": "e4c01efea1a017995ea96731d634c13e8def9f01f53794cf768eb9360990b606"
}
```

## Proposed actions

### ACTION-REQUEST-AUTHOR-MATERIALS: Request the authors' runnable programs or complete documented manual/GUI run procedure and the observation-level analysis data needed for the paper and online appendix. Ask for the complete data dictionary, sample and event definitions, identifiers and dates, return inputs and transformations, required software/version, execution order, and mapping to reported outputs. Clarify whether the historical proxy and Form 8-K materials described for event identification must be reacquired by an execution step or are already represented in author-prepared data; do not assume a live source route from the historical description alone.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: REQ-ANALYSIS-DATA, ISSUE-MISSING-CODE, ISSUE-MISSING-DATA, ISSUE-WORKFLOW-CLOSURE
Evidence: E-APPENDIX-SCOPE, E-APPENDIX-EVENTS, E-APPENDIX-SAMPLE, E-STATIC-INVENTORY

Preparation / proposed procedure:

1. Ask the authors to provide all executable scripts/project files or, for a manual or GUI process, the complete procedure used to generate the paper and appendix results.
2. Request the analysis-ready or construction dataset(s), data dictionary, event/sample definitions, firm identifiers, dates, return variables, sample history, and all transformations.
3. Ask whether proxy statements and Form 8-K Item 5.02 filings are current workflow inputs or historical sources already represented in prepared data, and request precise source products and access conditions only if they are required inputs.
4. After receiving the materials, reassess every required input and stage dependency, then establish compatible routes and a later authorized execution procedure.

Validation to perform later:

- Confirm that each required event, firm, date, and return input has a verified compatible route and that any file collection/cleaning stages are represented in the documented producer-consumer order.
- Confirm the author workflow maps to the reported paper and Appendix Table A1 outputs and can be compared against the reported results in a later authorized run.


## Remaining issues and prerequisites

- ISSUE-MISSING-CODE [blocking; full_pipeline]: The package contains only online_appendix_jar_aug2.pdf; no executable script, project container, or complete manual run procedure is supplied. The reported author analyses cannot be attempted from this variant.
- ISSUE-MISSING-DATA [unresolved; full_pipeline]: No observation-level data or data description is included. The appendix reports results and describes an event study, but does not provide the event records, return data, or a verified compatible input route.
- ISSUE-WORKFLOW-CLOSURE [unresolved; full_pipeline]: The authors' actual entry points, data transformations, full list of inputs, software, stage order, and output mapping are unknown. The appendix describes past manual identification of events from proxy filings and Form 8-Ks, but no program shows whether those source materials are required to be reacquired or are already represented in author-prepared data.
- REQ-ANALYSIS-DATA [undetermined]: Observation-level data and event records needed to reproduce the paper and the appendix event-study results. The appendix describes 218 compensation-change events, with event dates tied to proxy filings or Form 8-K disclosures and returns measured around those events, but supplies no machine-readable event data, full data dictionary, or compatible input route. Its description of reading historical filings does not by itself establish that the supplied author workflow requires reacquiring those sources.

## Review notes

- No analysis_only scope is established because this package contains neither code nor analysis data and does not document a separate executable route.
- The appendix's account of reading proxy and Form 8-K filings is retained as historical event-construction evidence. It is not treated as proof that those sources must be reacquired for execution; the authors' input specification is needed.
