# Patch proposal: jar-e5eede6dbaaa

Anti-Mafia Police Actions, Criminal Firms and Peer Firm Tax Avoidance

DOI: 10.1111/1475-679X.12455

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied Stata preparation workflow for the primary comparison panel and both distinct GDF-related and GDF-unrelated branches. This release stops at generated data files; no regression/estimation commands are supplied, so paper-wide estimators are contextual rather than a required stage in this scope.

Entry points: `Code_Chircop et al_Mafia firms.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 1/12455 - Anti-Mafia-Police-Actions-Criminal-Firms-and-Peer-Firm-Tax-Avoidance/cfmp-datasheet-code-and-identifiers.zip",
      "sha256": "4cddcef5b84ea8ae665dc7987964aee9de129ec06f0fae8efe2a79244dee4eff"
    },
    {
      "path": "JAR-Volume 61/Issue 1/12455 - Anti-Mafia-Police-Actions-Criminal-Firms-and-Peer-Firm-Tax-Avoidance/cfmp-online-appendix.pdf",
      "sha256": "a57d10d6584b73d1063124bad7a35c7b3368ab0c4aeea7c446951dd824b3429e"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "07da3a33b514879427fb5d2388d6428c776c2b760dc0d7d29791821c57d0d4a2"
}
```

## Proposed actions

### ACTION_OBTAIN_PREPARED_INPUTS: Obtain the seven author-prepared Italian panel/classification/GDF lookup inputs, or document a supported compatible source-to-file preparation route for each input before attempting the supplied driver.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_MAIN_PANEL, REQ_GDF_CLASSIFICATION, REQ_GDF_PANEL, REQ_GDF_YES_MUNI, REQ_GDF_YES_PAIR, REQ_GDF_NO_MUNI, REQ_GDF_NO_PAIR, ISSUE_DATA_CLOSURE
Evidence: E_README_MAIN, E_README_GDF_CLASS, E_README_DATA_GDF, E_README_GDF_LOOKUPS, E_WORK_ITEM, E_DATASHEET_AIDA_GDF, E_CATALOG_SEARCH, E_PUBLIC_AIDA_HISTORY

Preparation / proposed procedure:

1. Stage mafia_project_full_def_operazioni_rev1.dta with the native Italian firm, municipality, province, ATECO, annual-year, criminal-status and event-year fields expected by the code.
2. Stage operazioni_gdf_touse.dta and data_gdf_full.dta with their exact author-described GDF classification and separate AIDA panel roles.
3. Stage the four related/unrelated municipality and municipality-industry lookup files; keep the yes-Mafia and no-Mafia branches distinct.
4. Resolve exact field names, period/history, row population, event-year construction, key uniqueness and the CODATECO-to-ateco_two mapping against source documentation before execution.

Validation to perform later:

- Use bounded metadata/header inspection of each acquired exact input; confirm the listed native fields, merge keys, event-year coverage and AIDA panel history without running analysis commands.

### ACTION_RESOLVE_GDF_PRODUCERS: Resolve the absent producer/data contract for all four GDF lookup inputs while preserving both branches.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE_GDF_HANDOFF
Evidence: E_README_GDF_LOOKUPS, E_REDACTED_STRUCTURE, E_TRACE, E_PUBLIC_GDF_PRESS

Preparation / proposed procedure:

1. For each municipality table, document the COMUNE_Istat-to-anno_operazione mapping and expected one-row-per-key contract.
2. For each municipality-industry table, document the COMUNE_Istat and ateco_two pair mapping, including the source ATECO code/normalization and uniqueness contract.
3. Identify whether these are supplied prepared files or are generated from already-accounted panel and classification inputs; do not infer an undocumented producer.

Validation to perform later:

- Before running, verify each merge-key mapping and uniqueness contract from the actual files/producer documentation.

### ACTION_VERIFY_AIDA_ROUTE: Use compatible author-prepared panels as the primary route when available; if the AIDA source route is needed, verify the licensed/export route, the required Italian financial fields and the actual historical span, and separately account for CRIMINAL/ANNO_OP and GDF construction inputs.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ_MAIN_PANEL, REQ_GDF_PANEL, ISSUE_AIDA_COMPAT
Evidence: E_DATASHEET_AIDA_GDF, E_PUBLIC_AIDA_HISTORY, E_PUBLIC_AIDA_DEMO, E_CATALOG, E_CATALOG_SEARCH

Preparation / proposed procedure:

1. Keep the exact author-prepared main panel and GDF-only panel as the first candidate inputs; do not infer an available license from the frozen catalog miss or from the datasheet's public-availability statement.
2. If sourcing raw AIDA records, verify the current permitted access route, exact financial columns, native firm/municipality/ATECO identifiers, and annual coverage against the supplied code's event and lag requirements.
3. Obtain or document the author-specific CRIMINAL and ANNO_OP data and GDF-related classifications needed to form the two panels; AIDA company accounting records alone do not close those fields.

Validation to perform later:

- Before any run, verify the exact input-field map, event-year and annual-history coverage, population, and lawful local acquisition route from actual product metadata and the acquired file headers.

### ACTION_VERIFY_WINSOR: Confirm the installed winsor 1.3.0 help/syntax metadata supports the authored winsor calls; the command itself is found under Stata 18, so no installation step is currently supported.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_WINSOR, ISSUE_WINSOR_SYNTAX
Evidence: E_CODE_LAG_STAGE, E_CODE_ACCOUNTING_FIELDS, E_CODE_GDF_ACCOUNTING, E_WINSOR_PROBE, E_STATA_HELP_META

Preparation / proposed procedure:

1. Review the nonexecuting help or primary documentation for the installed winsor 1.3.0 command outside batch help mode.
2. Confirm that g()/generate() and p(0.01) preserve the authored winsorized-variable outputs at each call site.
3. If the installed help supports those calls, proceed without an addon change; if not, identify a compatible release preserving the same percentile transformation before an authorized run.

Validation to perform later:

- Use version/which/help metadata only; do not run the author's winsor calls or create trial data.

### ACTION_RUN_PREPARATION: After all data and the winsor option syntax are resolved, run the supplied Stata preparation file from a host-visible writable staging directory using its unqualified relative filenames. The described workflow produces prepared data files, not paper regression tables.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: REQ_MAIN_PANEL, REQ_GDF_CLASSIFICATION, REQ_GDF_PANEL, REQ_GDF_YES_MUNI, REQ_GDF_YES_PAIR, REQ_GDF_NO_MUNI, REQ_GDF_NO_PAIR, SW_STATA, SW_WINSOR
Evidence: E_README_WORKFLOW, E_CODE_ENTRY, E_TRACE, E_ENVIRONMENT, E_WINSOR_PROBE, E_STATA_HELP_META, E_WORK_ITEM

Preparation / proposed procedure:

1. Create a dedicated host-visible writable staging directory and put the unchanged author do-file plus the seven exact input .dta names in that directory; do not use sample_id.dta as an analysis panel.
2. Set the Stata working directory to the staged project root so the authored unqualified use/merge/save names resolve there; keep host-wrapper paths relative or under [redacted-path-539b9c6a1f18] and do not embed absolute Dropbox workspace paths in executable configuration.
3. From that directory, invoke batch Stata 18 with the quoted filename: stata -b do "Code_Chircop et al_Mafia firms.do".
4. Preserve the authored order: main panel to criminal/year municipality lists; derive cleaned municipal/province/industry lists; construct master.dta, master_rev1.dta and the 2005-count-adjusted master_rev2.dta; then form master_rev3.dta from the GDF classification.
5. Run both separate data_gdf_full branches using the matching yes-Mafia and no-Mafia municipality/pair lookups, retaining database_gdf_related.dta and database_gdf_unrelated.dta as separate outputs.
6. Capture the actual host working directory, batch log and return status; keep generated outputs in the dedicated staging directory so authored replace saves do not overwrite original input files.

Validation to perform later:

- Before an authorized run, confirm host visibility/writability of the staging directory and every exact input filename.
- After an authorized run, inspect only the generated data-file schemas and documented producer-consumer handoffs; do not treat this preparation driver as the paper's missing regression program.


## Remaining issues and prerequisites

- ISSUE_DATA_CLOSURE [unresolved; full_pipeline]: The assigned package inventory contains only sample_id.dta as data, a one-column CF identifier list, while the seven author-described panel/classification/lookup files consumed by the supplied workflow are absent. No exact compatible full-panel or GDF branch input route is verified.
- ISSUE_GDF_HANDOFF [unresolved; full_pipeline]: The four related/unrelated GDF municipality and municipality-industry lookup files are consumed by the supplied code but no producer is supplied. Exact construction from the main panel and GDF classification, event-year mapping, ATECO key mapping and input-key uniqueness remain unspecified; both authored branches must be retained. The official GDF Press Office page confirms a public press-release channel but does not supply the classification schema or historical/key coverage needed for these files.
- ISSUE_AIDA_COMPAT [unresolved; full_pipeline]: AIDA is the named accounting source for both author panels, but the current official product page only establishes company information, up to ten years of company history and a demo-request path. The frozen catalog has no AIDA/BVD/Orbis candidate. Exact access rights, AIDA fields, product vintage/history, and the criminal/event-year augmentation for the main panel remain unknown; this is not evidence of absent entitlement or a confirmed access barrier.
- ISSUE_WINSOR_SYNTAX [unresolved; full_pipeline]: The exact winsor command is installed under Stata 18 (ado header version 1.3.0), but its batch help request was ignored, so support for the authored g()/generate() and p(0.01) call syntax is not established by this metadata pass. The command is available; this is not an installation or license blocker.
- REQ_MAIN_PANEL [undetermined]: Primary author-prepared Italian firm-year panel combining AIDA accounting observations with criminal-firm classification and Anti-Mafia Action year. The supplied code requires native CF, COMUNE_Istat, PROV_id, CODATECO_2 and ANNO identifiers plus the accounting fields it reads; ANNO_OP values are used for 2005–2016 action-year lists, while total ANNO history needed for panel and lag construction is not bounded by the code.
- REQ_GDF_CLASSIFICATION [undetermined]: Author-prepared GDF versus other-police-action classification consumed by a municipality-keyed merge to create the GDF branch. The actual table must provide the GDF indicator and COMUNE_Istat join key; source construction and key uniqueness are not supplied.
- REQ_GDF_PANEL [undetermined]: Separate AIDA Italian firm-year panel used by the two supplied GDF-only comparison branches. Code reads CF, COMUNE_Istat, CODATECO and ANNO, derives ateco_two from CODATECO, and consumes the listed financial fields; expected history, row population and data contract are not supplied.
- REQ_GDF_YES_MUNI [undetermined]: GDF municipalities with at least one Mafia-targeting action, used to attach anno_operazione by COMUNE_Istat in the related branch. Exact source schema, event-year mapping, and key uniqueness are not supplied.
- REQ_GDF_YES_PAIR [undetermined]: GDF municipality-industry pairs hit by an action targeting at least one Mafia firm; the related branch merges membership on COMUNE_Istat and derived ateco_two.
- REQ_GDF_NO_MUNI [undetermined]: GDF municipalities whose action targeted no Mafia firms, used to attach anno_operazione by COMUNE_Istat in the separate unrelated branch.
- REQ_GDF_NO_PAIR [undetermined]: GDF municipality-industry pairs hit by an action targeting no Mafia firms; the separate branch merges membership on COMUNE_Istat and derived ateco_two.

## Review notes

- Source review is complete for the supplied preparation driver. It has one main comparison panel and two distinct GDF branches, but supplies no regression/estimation commands; paper-wide estimators are outside this workflow scope. The authored input/field and branch contracts, static checks, unresolved source gaps and run procedure are recorded below.
- The exact eight work-item dependency IDs are preserved in order in probes/workflow_trace_001.json. Additional merge inputs discovered through the source review are represented as separate requirements and hash-bound safe structural evidence, not invented dependency IDs.
- The initial scan's six candidate lines are withheld from display; a subsequent hash-bound structural pass confirms their use/merge command type, author-documented references and safe merge keys. No credentials or connection material were emitted into source evidence.
- Process-only search-scope incident is recorded in probes/process_incident_websearch_001.json and is not used for any assessment claim; its evidence row is deliberately unused.
- Frozen catalog check: literal AIDA, BVD and Orbis queries returned zero matches among 959 dataset metadata records in the exact assigned catalog JSON, supported by the catalog and search records. The assigned lookup CLI failed to load its sibling resources.py module; preserve that failed command attempt only as process history, not scientific proof. The catalog miss is not evidence of absent access or entitlement.
- Official Moody's AIDA page describes Italian company data with up to ten years of history and a request-a-demo path; it does not verify fields, the authored period, public download or current user entitlement. The official GDF Press Office page supports that press releases exist, not a structured historic action file or its key/schema. Neither source was scraped and no payload was requested.
- Stata 18 is available; a bounded software helper found the actual winsor command at version 1.3.0. Batch help requests for winsor and use were ignored, leaving the addon-call options unverified. The frozen task guidance notes Stata 18 accepts use, replace; no repair is proposed for those authored calls.
- The author title differs from the frozen title only by punctuation/ligature styling; the frozen title/DOI are preserved and no material attribution conflict is supported. The supplied sample_id.dta has only a CF identifier column, so no analysis_only scope is supported.
- Process-only scope incident: the initial coordinator assignment explicitly said "NO person/court/firm/Telemaco/issuer queries or contacts/scraping." One passive search query was `site:info.camere.it Telemaco imprese company data`; it was generic vendor/product documentation, no result was opened, and no person/issuer lookup, contact, form, API, payload or validation request occurred. The raw web-tool response was not separately persisted; probes/process_incident_websearch_001.json records that limit and attributes the initial assignment, frozen prompt and discovery lead separately. This process-only item is unreferenced; disposition remains with coordinator/root.
