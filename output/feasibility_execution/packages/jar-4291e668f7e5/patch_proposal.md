# Patch proposal: jar-4291e668f7e5

Do PCAOB Inspections Improve the Accuracy of Accounting Estimates?

DOI: 10.1111/1475-679X.12339

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied Stata Sections A–C in the author’s 262-line Stuber Hogan Code.txt source, ending with File for Analysis.dta; no separate estimation program is supplied for paper-wide tables/figures.

Entry points: `Stuber Hogan Code.txt`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 1/12339 - Do-PCAOB-Inspections-Improve-the-Accuracy-of-Accounting-Estimates/sh-datasheet-code-and-identifiers.zip",
      "sha256": "2004151d4c8bde8043a837dfd3d944626a2c91aeb82682c207d896e0ffdc480a"
    },
    {
      "path": "JAR-Volume 59/Issue 1/12339 - Do-PCAOB-Inspections-Improve-the-Accuracy-of-Accounting-Estimates/sh-online-appendix-tables.pdf",
      "sha256": "bb84a1b73842763ff12fdf75307b24a2c7ea6ab540c7b81821de61b694137ab6"
    },
    {
      "path": "JAR-Volume 59/Issue 1/12339 - Do-PCAOB-Inspections-Improve-the-Accuracy-of-Accounting-Estimates/sh-online-appendix.pdf",
      "sha256": "8b20de0541d90faf85cbf0f06091bddf5a4515effd9afa75d000932d0a11237b"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "33da0b0ccd69273cdc9638a4f439cdcf539122858a7c684a4c4f9b6d21b2fc71"
}
```

## Proposed actions

### resolve_inputs: Locate or document compatible versions of the five exact inputs and verify their complete contracts before running the supplied workflow. Keep prepared author files as the primary input route; any raw-source reconstruction is conditional and must not replace the authored definitions.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: pcaob_tracker, bank_holding_panel, auditor_sample, state_assignment, fed_numbers, input_contracts
Evidence: ev_a_import, ev_b_import, ev_b_sample, ev_c_merges, ev_pcaob_public_reports, ev_pcaob_dataset_period, ev_fdic_public_data, ev_wrds_product, ev_wrds_access, ev_catalog_product_screen, ev_label_quote_probe, ev_nic_about, ev_nic_download, ev_nic_dictionary

Preparation / proposed procedure:

1. Stage PCAOB Report Tracker.xlsx with the exact Formatted for Merge sheet and verify first-row/imported names for all required fields, including annu_insp (dropped before recreation) and repyr (needed by the later merge, not created in Section A).
2. Stage 2005-2018 Bank and Holding Company Data for Analysis.dta and check every expected field; preserve distinct lnatresr/lnatres and lnrenrot/lnrenres references until their actual source meanings are confirmed.
3. Verify the Auditor Sample.dta auditor_key_msu lookup is unique and matches the described selected auditor set. Verify State Number Assignment.dta stalp and Fed Reserve Numbers.dta fed lookup uniqueness, coverage, and actual non-key payload columns.
4. Confirm the bank panel period, ordering, missing-year gaps and within-bank rows needed by the code’s _n-1/_n-2/_n+1/_n+2/_n+3 constructions. These are row offsets, not gap-aware calendar-year lags/leads.
5. Preserve the whole loaded bank input for the authored winsor operations, which occur before keep if repyr > 2005; do not recalculate cutoffs on only the final sample or create a 1991 raw-data dependency from the hard-coded chargeoff constants.
6. In a working copy, set a relative runtime working directory containing the five input files, extract/reflow the supplied TXT as a Stata do-file if desired, then run Sections A → B → C in order: A creates PCAOB Inspection Findings.dta; C consumes it, then merges State Number Assignment and Fed Reserve Numbers before saving File for Analysis.dta.
7. If PCAOB Report Tracker.xlsx cannot be obtained, use the official PCAOB report page as a candidate public source and follow Appendix A’s manual report classification procedure; confirm 2006–2017 report coverage, report-date-to-repyr mapping, and the auditor_key_msu crosswalk before producing the exact tracker. The detailed Part I.A/Part I.B series described on the current page starts with 2018 annual / 2019 triennial reports and is not a substitute for the earlier manual review.
8. If the prepared bank panel cannot be obtained, assess the public FDIC plus FFIEC NIC route first: obtain the Call Report/SDI and FR Y-9C source files, then confirm source columns, RSSD/auditor identifiers, year-end joins, bank-panel aliases and row history against the exact prepared-file contract. The public route can replace WRDS if it supplies compatible fields/IDs; use the datasheet’s WRDS route only as an alternative if needed and available. Neither source-product labels nor the one-row sample establish the completed author panel.

Validation to perform later:

- Before an authorized run, use bounded metadata checks for expected field names/types and using-table key uniqueness; verify tracker sheet name and imported variable names, and preserve the named source periods and lookup payloads.
- After a separately authorized run, check that each merge retains the author-coded matched sample, confirm the generated Findings file precedes its merge, validate final repyr filtering and output schema, and inspect row-offset edge/gap behavior without changing the authored definitions.


## Remaining issues and prerequisites

- input_contracts [unresolved; full_pipeline]: The five external files directly consumed by Sections A–C are not supplied in the listed inventory. Confirm the Tracker sheet/schema (including active-drop annu_insp and later merge-key repyr), bank input fields and actual row/year ordering (including distinct lnatresr/lnatres and lnrenrot/lnrenres references), and lookup keys/cardinality/payloads for Auditor Sample, State Number Assignment and Fed Reserve Numbers. The three merge files retain matched rows only. The public/manual report route and composite FDIC/WRDS bank-data reconstruction remain unverified alternatives, not access-barrier findings; neither resolves the author-specific workbook/lookup mappings. A public FDIC plus FFIEC NIC route is now documented as a candidate alternative to WRDS; its underlying source fields, author-specific ID/date joins and prepared-panel aliases remain unresolved.
- pcaob_tracker [undetermined]: The Section A workbook imported from sheet “Formatted for Merge”; code explicitly consumes the report dates, engagement/client counts, inspection flag, auditor key, finding counts and merge year (`repyr`), with remaining workbook field/schema details to verify.
- bank_holding_panel [undetermined]: The supplied 2005–2018 bank/holding-company panel consumed by Section B, with bank, auditor, call-report, loan, charter and geographic fields read or joined in the code.
- auditor_sample [undetermined]: The Section B auditor-key sample used to retain the triennially inspected sample auditors.
- state_assignment [undetermined]: The Section C state crosswalk merged by `stalp`; payload schema and source are not specified by the merge call alone.
- fed_numbers [undetermined]: The Section C Federal Reserve number lookup merged by `fed`; payload schema and source are not specified by the merge call alone.

## Review notes

- First source checkpoint: the supplied 262-line TXT contains substantive Stata Sections A–C, so code is present despite the zero-DID static parser result. The provisional target is the documented preparation workflow ending in File for Analysis.dta. The separately named rssdBANKS.xlsx is an identifier list and is not read by the supplied program.
- Manually derived data dependencies because the static report had zero dependency edges: five external inputs are actual quoted reads/merges, and PCAOB Inspection Findings.dta is generated by Section A then consumed in Section C, not a sixth external requirement.
- The tracker must provide repyr for the merge in Section C; Section A does not construct it. annu_insp must exist for the active drop before Section A recreates it.
- By construction order, bank covariates and winsor calls operate on the loaded 2005–2018 panel before the final repyr>2005 keep. Explicit _n offsets within fed_rssd use row neighbors; xtset alone does not make those expressions gap-aware.
- The hard-coded historical loan chargeoff rates are numeric constants in the supplied program and do not introduce a separate 1991 raw-data requirement.
- The PCAOB report coding recipe is a described manual source route if the prepared tracker cannot be supplied; it is not a sixth mandatory input alongside the tracker. FDIC and WRDS data are the described provenance of a prepared bank panel, not extra AND requirements when that panel is available.
- The bundled rssdBANKS.xlsx is a readable RSSDID/year identifier list with a one-row probe and unverified coverage, and is not read by the supplied program. It does not satisfy the required bank panel.
- Official PCAOB metadata supports public report access; the present detailed Part I.A/Part I.B datasets are described as beginning in 2018 for annually inspected firms and 2019 for triennially inspected firms. The author’s cited 2006–2017 intensity classifications still require the actual tracker or a manual historical review and unresolved auditor/date mapping.
- FDIC and WRDS official pages are candidate raw-source evidence only: FDIC lists legacy SDI downloads, and WRDS documents Call Report and FR Y-9 data products. No exact FDIC/SDI/FRY-9C product name appears in the frozen local metadata catalog screen; this does not prove local unavailability, WRDS access status, or a source-data barrier.
- The Stata 18 same-run synthetic parser probe accepts the visually unclosed final label quote form and stores its text. No quote repair is supported by that appearance alone; the supplied workflow still needs later validation as a complete extracted working copy.
- The Stata entry source is packaged as Stuber Hogan Code.txt rather than the named Stuber Hogan.do file in the datasheet. Copy/reflow it into an assigned working .do file if needed and set an ordinary relative working directory as preparation; the supplied A/B/C content is the analysis-file preparation workflow.
- FFIEC NIC’s official pages document FR Y-9C financial data back to 2000, quarterly files and BHCF/RSSD variable dictionaries. Together with FDIC Call Report/SDI sources, this is a meaningful public raw-source candidate that may avoid WRDS entitlement; it does not establish a compatible merged bank panel or fill the auditor/lookup mappings.
- The FR Y-9C public route is preferred as a candidate when it meets the actual field, ID, period and construction contract. WRDS remains a conditional alternative only; current WRDS membership is not a mandatory gate if FDIC+NIC data can supply the required panel.
