# Patch proposal: jar-82f0b01af4a9

Index Creation, Information Changes, and Financing

DOI: 10.1111/1475-679X.12626

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied-package workflow target. The recovered 194-line Stata preparation entrypoint and its thirteen direct input contracts are mapped, but frozen Code.rar provenance records incomplete static inspection: the next selected member yielded zero bytes and a member-size mismatch. Full source and dependency closure are therefore unknown; no unread code, requirements, or scientific steps are inferred.

Entry points: `_rar_static_Code/Code/1_data preparation.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 5/12626 - Index-Creation-Information-Changes-and-Financing/guz-datasheet-code-indentifiers-and-log-files.zip",
      "sha256": "87e3ee1fd5a4697b255de3a7f834809ad32077a0b86cf8a44e43cc31e8c78c08"
    },
    {
      "path": "JAR-Volume 63/Issue 5/12626 - Index-Creation-Information-Changes-and-Financing/guz-online-appendix.pdf",
      "sha256": "870c50b6a9fd13dac6c624df8f6d7760854f6a122a80fcc1695007b8a7b97c20"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "48caa64802efffc4b9573d0ea8b48c66b2aa6c0f8a49ef58a85e18db557e8c1d"
}
```

## Proposed actions

### A-INPUTS: Resolve compatible source routes for every independently consumed input in the supplied preparation script.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R-EVENT-MASTER, R-FYE-PANEL, R-WORLDSCOPE-BV, R-WORLDSCOPE-EBITDA, R-WORLDSCOPE-TAX, R-WORLDSCOPE-LTD, R-WORLDSCOPE-MV, R-WORLDSCOPE-PRETAX, R-WORLDSCOPE-PPE, R-WORLDSCOPE-ASSETS-USD, R-WORLDSCOPE-ASSETS, R-WORLDSCOPE-DEBT, R-FYE-DATE-PANEL
Evidence: E-DOC-EVENT-SOURCE, E-DOC-WORLDSCOPE, E-CODE-EVENT-IMPORT, E-CODE-FYE-PANEL, E-CODE-WORLDSCOPE-BV, E-CODE-WORLDSCOPE-EBITDA, E-CODE-WORLDSCOPE-TAX, E-CODE-WORLDSCOPE-LTD, E-CODE-WORLDSCOPE-MV, E-CODE-WORLDSCOPE-PRETAX, E-CODE-WORLDSCOPE-PPE, E-CODE-WORLDSCOPE-ASSETS-USD, E-CODE-WORLDSCOPE-ASSETS, E-CODE-WORLDSCOPE-DEBT, E-CODE-FYE-DATE-OUTPUT, E-WORK-ITEM-INVENTORY, E-INDEX-PROBE, E-WORLDSCOPE-CATALOG, E-DATASTREAM-CATALOG, E-BLOOMBERG-CATALOG

Preparation / proposed procedure:

1. Locate the author-prepared event-master text file first. If it must be reconstructed, preserve the joint provider-event and Datastream/Bloomberg-constituent inputs described by the datasheet; the provider names/URLs, key/date joins, and full mapping to eventnumber/index/dscd/date/inclusion-deletion fields remain unspecified. The Datastream catalog candidates and empty Bloomberg query do not complete that contract.
2. The frozen catalog identifies TRWS.WRDS_WS_FUNDA as a Worldscope annual-fundamentals candidate under ${ACCTREPL_SAS_ROOT}; confirm the licensed source route, map the code's dscd key to the candidate identifiers, map each of the ten exports to its exact annual item fields, and establish the 1993–2016 wide-year construction before treating it as compatible.
3. Locate the separate fiscal-year-end-date text input and confirm its code/date columns and period before building the FYE output.
4. Record field, identifier, period, construction, and access evidence for each input separately; do not treat catalog discovery or one-row readability as proof of the complete contract.

Validation to perform later:

- After authorized source acquisition, use bounded metadata checks to verify exact columns, key types, and date formats; validate full history and coverage in a separately authorized run.
- For each reshaped Worldscope metric, verify dscd/fiscal_year key uniqueness required by the source's 1:1 merge; retain the code's 1993–2016 suffix mapping and do not infer additional history from catalog row metadata.

### A-PATH-CONFIG: Prepare a separate portable working copy with one host-visible project root and consistent Input, Data, and Results subdirectories.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I-PATH-CONFIG
Evidence: E-CODE-PATH-ROOT, E-CODE-EVENT-IMPORT, E-CODE-EVENT-OUTPUT, E-CODE-FINAL-PANEL

Preparation / proposed procedure:

1. Preserve the author source unchanged and make a writable working copy under a host-visible root.
2. Map every hard-coded input, output, log, and working-directory path in the copy from the same author root to the selected portable root; keep all reads and writes coherent.
3. Set the Stata working directory to the project root, retain separate Input/Data/Results locations, and verify visibility and write access before any separately authorized execution.

Validation to perform later:

- Statically compare every affected path in the working copy; do not apply edits or execute the author program during this assessment.

### A-RUN-PROCEDURE: Conditionally run the full supplied workflow only after complete source inspection, path setup, the thirteen recovered-source input contracts, and any additional contracts proven by the complete source set are resolved.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I-PATH-CONFIG, I-PARTIAL-ARCHIVE-CLOSURE
Evidence: E-RAR-INSPECTION-HISTORY, E-CODE-PATH-ROOT, E-CODE-EVENT-OUTPUT, E-CODE-FINAL-PANEL, E-CODE-FYE-DATE-OUTPUT

Preparation / proposed procedure:

1. Preserve the author source and use a writable working copy with every hard-coded Windows project-root path mapped consistently to a host-visible root.
2. Before treating this as the full supplied-package workflow, resolve the partial-archive source-inspection issue using a complete readable source set; map only contracts and producer-consumer links established by those sources.
3. Resolve the thirteen direct inputs evidenced in the recovered preparation entrypoint, including the event-master field/key/date contract, the ten annual Worldscope metric exports, both fiscal-year-end inputs, and their supported coverage/mappings; add further inputs only if complete source inspection proves them.
4. From the configured project root, run the supplied source set in Stata batch mode only after full source closure, all required inputs, and paths are ready.
5. The recovered entrypoint records event master and basis products, the fiscal-year-end merge, ten annual metric imports and merges, the event-stock join and main financial-panel save, then a separate fiscal-year-end-date input/output. Its downstream role in the complete package remains unknown until archive closure is resolved.

Validation to perform later:

- Before any future authorized run, verify every supplied source member and referenced module is readable, path visibility and writability, required source columns and keys, date conversion, and the recovered code's 1993–2016 suffix mapping; this assessment has not executed the program.

### A-SOURCE-CLOSURE: If a complete readable source set is made available through an authorized handoff, inspect all supplied code and referenced modules before claiming full-package source or dependency closure.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: I-PARTIAL-ARCHIVE-CLOSURE
Evidence: E-RAR-INSPECTION-HISTORY, E-WORK-ITEM-INVENTORY

Preparation / proposed procedure:

1. Use the existing Code.rar identity and frozen static_archive_provenance.json hash as the receipt for this known incomplete inspection; do not treat the zero-byte extraction as source content or proof that code is absent.
2. If the provider supplies a complete readable copy or source manifest, record its hashes and reconcile member sizes before reading source text byte-first.
3. Statically inspect every supplied code member and referenced module, then map actual input fields, keys, dates, producers, consumers, and software. Do not execute author code as part of this closure check.
4. Update the scope, requirements, and run plan only for dependencies established by readable source; any unread or mismatched source keeps closure_complete=false.

Validation to perform later:

- The full supplied source manifest is accounted for, all listed source members and referenced modules are readable with reconciled byte counts, and their actual contracts are mapped; otherwise retain the unresolved closure issue.


## Remaining issues and prerequisites

- I-PATH-CONFIG [preparation; full_pipeline]: The supplied Stata script uses a fixed Windows project root for its working directory, inputs, outputs, and log; it needs a coherent host-visible working-copy root before a run on this environment.
- I-PARTIAL-ARCHIVE-CLOSURE [unresolved; full_pipeline]: The supplied Code.rar has not been completely inspected. Frozen provenance records the recovered 194-line preparation source, then a zero-byte result for the next selected member and a member-size mismatch. The supplied package's full source and dependency closure cannot be established; the unread member's contents, existence beyond recorded metadata, and scientific role are unknown.
- R-EVENT-MASTER [undetermined]: The supplied program imports `20160810_index_events_master.txt`; it needs eventkey, event, eventdetail, announcementdate, changedate, announcementofevent, stocksdeletion, eventnumber, index, datastreamname, dscd, exchange, icbdsd, icbsuc, and sicdsd. It parses three event dates, encodes event categories, creates inclusion/deletion status, and keeps event/date/identifier fields for the basis product. The packaged workbook does not establish this complete input contract.
- R-FYE-PANEL [undetermined]: `20160818_index_events_stocks_Fiscal year end.txt` supplies fiscalyearend and dscd for a month conversion and merge with the event basis; the source's exact coverage and schema are not otherwise established. The resulting annual panel is later joined to the event basis by dscd.
- R-WORLDSCOPE-BV [undetermined]: `20160818_index_events_stocks_BV common equity.txt` supplies wide BV values keyed by dscd; the program reshapes to fiscal_year and creates BV_common_equity for the combined panel. After reshape, the metric must support the code's one-to-one merge on dscd and fiscal_year.
- R-WORLDSCOPE-EBITDA [undetermined]: `20160818_index_events_stocks_EBITDA.txt` supplies wide EBITDA values keyed by dscd for the combined annual panel. After reshape, the metric must support the code's one-to-one merge on dscd and fiscal_year.
- R-WORLDSCOPE-TAX [undetermined]: `20160818_index_events_stocks_Income tax.txt` supplies wide income-tax values keyed by dscd for the combined annual panel. After reshape, the metric must support the code's one-to-one merge on dscd and fiscal_year.
- R-WORLDSCOPE-LTD [undetermined]: `20160818_index_events_stocks_Long term debt.txt` supplies wide long-term-debt values keyed by dscd for the combined annual panel. After reshape, the metric must support the code's one-to-one merge on dscd and fiscal_year.
- R-WORLDSCOPE-MV [undetermined]: `20160818_index_events_stocks_MV common equity.txt` supplies wide market-value-of-common-equity values keyed by dscd for the combined annual panel. After reshape, the metric must support the code's one-to-one merge on dscd and fiscal_year.
- R-WORLDSCOPE-PRETAX [undetermined]: `20160818_index_events_stocks_Pretax income.txt` supplies wide pretax-income values keyed by dscd for the combined annual panel. After reshape, the metric must support the code's one-to-one merge on dscd and fiscal_year.
- R-WORLDSCOPE-PPE [undetermined]: `20160818_index_events_stocks_Property plant equipment.txt` supplies wide property, plant and equipment values keyed by dscd for the combined annual panel. After reshape, the metric must support the code's one-to-one merge on dscd and fiscal_year.
- R-WORLDSCOPE-ASSETS-USD [undetermined]: `20160818_index_events_stocks_Total assets USD.txt` supplies wide USD total-assets values keyed by dscd for the combined annual panel. After reshape, the metric must support the code's one-to-one merge on dscd and fiscal_year.
- R-WORLDSCOPE-ASSETS [undetermined]: `20160818_index_events_stocks_Total assets.txt` supplies wide total-assets values keyed by dscd for the combined annual panel. After reshape, the metric must support the code's one-to-one merge on dscd and fiscal_year.
- R-WORLDSCOPE-DEBT [undetermined]: `20160818_index_events_stocks_Total debt.txt` supplies wide total-debt values keyed by dscd for the combined annual panel. After reshape, the metric must support the code's one-to-one merge on dscd and fiscal_year.
- R-FYE-DATE-PANEL [undetermined]: `20160909_index_event_stocks_fiscal_year_end_date.txt` supplies code and year-suffixed date fields reshaped to type/fiscal_year/FYE and saved as a separate output after the main financial-panel save.

## Review notes

- The full_pipeline scope is the supplied package's code workflow. The recovered 194-line Stata preparation entrypoint has thirteen directly evidenced inputs and recorded output stages; the frozen archive inspection is incomplete, so package-wide source and dependency closure remain unknown. No additional scientific workflow or input is inferred from unread code.
- The author datasheet title differs from the frozen output-header title and does not state the frozen DOI. Preserve the frozen bibliographic metadata; retain the related-title difference as provenance context only, without inferring a different paper or a physical-run prerequisite.
- The datasheet describes eight preparation files and table-labeled programs. Because archive inspection is incomplete, these statements remain context and do not establish which additional source members or contracts are present; no unobserved code or scientific steps are invented. The separate fiscal-year-end-date save is the last output in the recovered entrypoint, while its role in the full package is unknown.
- Worldscope annual fundamentals, Datastream name/index-constituent tables, and the event workbook are discovery candidates only. Their returned fields do not establish the supplied code's complete key/measure/date contract. The Bloomberg catalog query was empty and is not evidence of unavailable data or entitlement.
- The work item's frozen dependency checklist has zero IDs; no dependency-review rows were invented. Source-proven output stages and their order are recorded in the run procedure.
- Frozen static_archive_provenance.json records Code.rar as unverified: the recovered source is 7,673 bytes, the next selected member returned zero bytes, and the inspection reports a member-size mismatch with partial_archive_inspection=true. This is a real source-closure limit, not evidence that unread code is absent. Author logs were not displayed or used as source evidence.
- No author program, data payload, SAS process, or software installation was run or performed in this assessment.
