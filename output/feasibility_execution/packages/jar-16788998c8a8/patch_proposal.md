# Patch proposal: jar-16788998c8a8

Made in the U.S.A.? A Study of Firm Responses to Domestic Production Incentives

DOI: 10.1111/1475-679X.12269

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Feasibility target: prepare and match using the supplied Stata program, preserving all six source stages and the implemented H1 intertemporal, H2 cross-border, H3a domestic investment, and H3b domestic employment data-construction branches. Table-producing estimators are outside this selected preparation/matching scope.

Entry points: `Lester_Code_Description.pdf`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 4/12269 - Made-in-the-U-S-A-A-Study-of-Firm-Responses-to-Domestic-Production-Incentives/lester-datasheet-and-code.zip",
      "sha256": "cba46e8faffa332c6f8dc5fd0deed4f59022ba73ccd2ee3898d619841e381915"
    },
    {
      "path": "JAR-Volume 57/Issue 4/12269 - Made-in-the-U-S-A-A-Study-of-Firm-Responses-to-Domestic-Production-Incentives/lester-online-appendix.pdf",
      "sha256": "f0b9246091482c0a18425b3ab055b45534ea397c6747cdb612d719f3312fbfb4"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "e49ee71823498ff7ea7c8abe5351514ae2d65c34f0a34dbb0c60f900d811ac97"
}
```

## Proposed actions

### act_extract_stata: Extract the Stata code printed in Lester_Code_Description.pdf into a separate working .do file. Keep the supplied PDF unchanged and compare any ambiguous wrapped statements with the original PDF page rendering.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: iss_embedded_stata
Evidence: ev_code_steps

Preparation / proposed procedure:

1. Create a working .do copy from the embedded code in the assigned work directory.
2. Check all wrapped or page-split statements against the PDF before any separately authorized run.

Validation to perform later:

- Review the extracted file to confirm that all six listed preparation and matching stages remain present.

### act_h1_missing_cohorts: Obtain omitted H1 cohort producer blocks and complete quarter mapping, or establish which compatible intermediate files are separately supplied.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: iss_h1_cohort_builders
Evidence: ev_h1_cohort_gap

Preparation / proposed procedure:

1. Request missing H1 cohort build steps or exact handoff contract and period.
2. Preserve all supplied H1 treatment, comparison, and pooled branches.

Validation to perform later:

- Confirm every referenced H1 intermediate has a documented producer and 2005–2013 timing matches the author sample.

### act_data_contracts: Verify or obtain each author-prepared/manual table with its own schema and history: DPAD classifications, total/federal NOL, Hoopes rdchand through 2010, and processed Exhibit 21 subsidiary/haven counts.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: req_dpad_firms, req_nol_data, req_rdchand, req_exhibit21, iss_manual_input_contracts
Evidence: ev_dpad_manual_source, ev_nol_manual_source, ev_hoopes_period_source, ev_ex21_author_source, ev_identifiers_shape

Preparation / proposed procedure:

1. Check for compatible author-prepared tables and field dictionaries before independent collection.
2. For DPAD, establish search terms, reviewed-hit rules, treatment years, and keys.
3. For NOL, establish total/federal definitions, coding, and collection years.
4. Preserve Hoopes 1997–2010 rdchand separately from code-derived 2011–2013 values.
5. Verify the author Exhibit 21 route and country/haven rules; treat local SEC roots as candidates, not processed data.

Validation to perform later:

- Confirm firm/year keys, fields, histories, and coverage against each consuming code branch before staging.

### act_compustat_stage: Stage and validate the distinct annual, quarterly, and segment Compustat products and separate 1995–2013 versus 2013–2017 windows required by the code.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: req_compustat_annual_1995_2013, req_compustat_quarterly_1995_2013, req_compustat_segments_1995_2013, req_compustat_annual_2013_2017, req_compustat_segments_2013_2017
Evidence: ev_inputs_products, ev_catalog_products, ev_fundq_probe, ev_segments_probe, ev_h2_inputs_window, ev_h2_leads, ev_h2_forward

Preparation / proposed procedure:

1. Resolve COMP.FUNDA, COMP.FUNDQ, and COMPSEG.WRDS_SEGMERGED fields and historical coverage before extraction.
2. Keep quarterly and segment products separate from annual fundamentals; keep H2 extracts distinct from lag-history inputs.
3. Create relative working files only after periods and identifiers are confirmed.

Validation to perform later:

- Check expected fields, firm-year/quarter keys, H1 lag history and 1997–2013 window, plus H2 source/composite periods including the 2017 drop.

### act_bea_access: Verify existing authorized BEA Special Sworn Employee project access and exact retained domestic and foreign company-level products, fields, identifiers, and years.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: req_bea_domestic, req_bea_foreign
Evidence: ev_bea_access_source, ev_bea_access_official, ev_bea_h3a, ev_bea_h3b

Preparation / proposed procedure:

1. Verify current access status and whether required historical domestic and foreign products remain available within the project.
2. Map bea_dom_data_97_10, bea_dom_data_11_13, and bea_for_data to their precise restricted-data fields and keys.

Validation to perform later:

- Confirm private firm-level files and periods match code inputs; do not substitute public BEA aggregates.

### act_aliases_and_inherited: Resolve the separate capex and employees input producers and the origin of H3b log_compen/log_for_emp fields before any run.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: req_capex_input, req_employees_input, iss_alias_producers, iss_h3b_imported_logs
Evidence: ev_bea_h3a, ev_bea_h3b, ev_h3b_tail_contract

Preparation / proposed procedure:

1. Obtain each alias producer/schema and gvkey/fyear coverage.
2. Confirm whether log_compen and log_for_emp are inherited from a separately imported prepared table and identify that table.
3. Do not infer these variables from similarly named Compustat or BEA fields.

Validation to perform later:

- Trace every alias and inherited field to a documented table with compatible keys and period.

### act_software_setup: Provide the three community Stata commands used by the code through ordinary installation/adopath setup.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: sw_todate, sw_nsplit, sw_mahapick
Evidence: ev_todate_probe, ev_nsplit_probe, ev_mahapick_probe

Preparation / proposed procedure:

1. Install or add to Stata adopath versions of todate, nsplit, and mahapick compatible with Stata 18.

Validation to perform later:

- Confirm Stata resolves each command with which before a separately authorized run.

### act_run_procedure: After required source/data/software contracts are complete and a preparation/matching run is authorized, execute the extracted Stata program in normal batch mode from its coherent working directory.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: req_compustat_annual_1995_2013, req_bea_domestic
Evidence: ev_runtime_probe, ev_code_complete_steps

Preparation / proposed procedure:

1. Use relative working paths or [redacted-path-a0743dbf69d6] paths; keep machine-specific Dropbox paths out of executable configuration.
2. Run the documented Stata executable in normal batch mode from the intended working directory.
3. Stage required inputs in the documented relative run root and preserve separate H1/H2/H3a/H3b outputs.

Validation to perform later:

- Before the run, verify staged contracts and working-directory visibility; afterward reconcile each generated preparation dataset and matching/H1/H2/H3a/H3b construction branch against source.


## Remaining issues and prerequisites

- iss_embedded_stata [preparation; full_pipeline]: The substantial Stata preparation program is printed inside Lester_Code_Description.pdf rather than supplied as an executable .do file. Extract a working copy and compare wrapped/page-split statements against the PDF before an authorized run.
- iss_h1_cohort_builders [unresolved; full_pipeline]: H1 labels its quarter map abbreviated/example, saves pooled cohorts for 2004, 2007, and 2010, and appends a 2005–2013 range whose producer blocks are absent from supplied text. Obtain omitted builders or confirm separately supplied intermediates; do not invent cohorts.
- iss_h3b_imported_logs [unresolved; full_pipeline]: The source ends by cleaning log_compen and log_for_emp but shows no producers or imported table schema. They may be inherited from an undocumented source; the code excerpt does not prove they are absent from all inputs.
- iss_alias_producers [unresolved; full_pipeline]: Code loads capex and employees as separate aliases, but their source producers/schema and date coverage are undocumented. Similar Compustat field names are candidates until merge contracts are confirmed.
- iss_manual_input_contracts [unresolved; full_pipeline]: DPAD, NOL, Hoopes R&D credit, and Dyreng Exhibit 21 inputs have distinct sources and histories. Compatible author-prepared tables and exact schemas/rules/coverage must be established; historical assistance is not by itself a current NDA barrier.
- req_dpad_firms [undetermined]: Prepared DPAD firm/year classification used in matching. Code imports DPAD_firms with firstrow and consumes match_text, datadate, cik, and fiscal_year. The datasheet describes term-based filing search and manual review/coding; the prepared data and complete rules are not in the package.
- req_compustat_annual_1995_2013 [undetermined]: Annual Compustat fundamentals used for matching and H1 preparation, source period 1995–2013 to support annual lag construction.
- req_compustat_quarterly_1995_2013 [undetermined]: Quarterly Compustat fundamentals for H1 intertemporal shifting. Source builds quarterly lags; H1 analysis is filtered to 1997–2013.
- req_compustat_segments_1995_2013 [undetermined]: Compustat segment history used in base matching/cross-border construction, downloaded for 1995–2013.
- req_compustat_annual_2013_2017 [undetermined]: Separate annual Compustat product for H2 cross-border tests. Code drops 2012 and 2017 before forming the appended extension.
- req_compustat_segments_2013_2017 [undetermined]: Separate Compustat segment extract for the H2 2013–2017 extension, merged with the annual extension product.
- req_nol_data [undetermined]: Hand-collected company NOL data merged into H1 by gvkey and fyear. Datasheet describes total and federal NOL amounts, but the prepared table, exact names, coding rules, and years are absent.
- req_rdchand [undetermined]: Historical author-shared R&D credit data consumed as rdchand with cik, year (renamed fyear), and rcxm. Source describes Hoopes assistance through 2010; code separately derives 2011–2013 from Compustat.
- req_exhibit21 [undetermined]: Processed Exhibit 21 firm-year subsidiary/haven data used by H2. Code reads ciknumber, datadate, taxhaven, and totalcount, derives firm-year measures, then merges to Compustat segments.
- req_bea_domestic [undetermined]: Confidential BEA domestic firm-level data consumed by H3a investment and H3b employment. Code reads distinct domestic inputs for 1997–2010 and 2011–2013. These records are restricted company-level data, not public BEA aggregates; current authorized access and exact contract are unverified.
- req_bea_foreign [undetermined]: Separate confidential BEA foreign activity data consumed by H3a and keyed separately from domestic BEA records.
- req_capex_input [undetermined]: Separate capex input alias consumed in H3a and merged by gvkey/fyear. Equivalence to a similarly named Compustat field is unverified without its producer contract.
- req_employees_input [undetermined]: Separate employees input consumed in H3b. Code uses emp and xlr and constructs one-year lags before merging by gvkey/fyear; upstream source and historical window are unknown.
- sw_todate [preparation_required]: The supplied code calls todate; targeted which check did not find it on the current adopath. Provide it through ordinary package setup before a future run.
- sw_nsplit [preparation_required]: The supplied code calls nsplit; targeted which check did not find it on the current adopath. Provide it through ordinary package setup before a future run.
- sw_mahapick [preparation_required]: The matching code calls mahapick; targeted which check did not find it on the current adopath. Provide it through ordinary package setup before a future run.

## Review notes

- The frozen dependency list is empty, but the printed program contains explicit use, merge, and append reads. Manual source inspection recorded external reads as data requirements and distinguished generated intermediates from supplied inputs.
- Static code-parser zero is not evidence that the package has no code: extracted PDF text contains a substantial printed Stata .do program. The package has no standalone .do file.
- Table-producing estimator code is not included in the supplied PDF; this is a contextual limitation outside the selected preparation/matching scope.
- H1 source shows an abbreviated/example quarter map, explicit 2004/2007/2010 pooled producers, and an append range for 2005–2013 with no visible producer blocks for that sequence; treat these as unresolved source/intermediate contracts.
- H2 annual and segment products for 2013–2017 are separate from Compustat/segment history 1995–2013. The extension code drops 2012 and 2017; longer intermediate leads do not establish longer future outcome horizons.
- H3a and H3b consume restricted BEA company-level domestic records; H3a also reads a separate foreign BEA file. Public BEA aggregates cannot replace these private inputs. Current individual secure-site access remains unknown.
- DPAD, NOL, Hoopes rdchand, and Dyreng Exhibit 21 are distinct input contracts with different sources and histories. Historical researcher assistance is not treated as a current NDA barrier.
- The supplied Sample Firm Identifiers workbook is a one-column identifier list, not an analysis panel or proof of linked data coverage.
- The appendix discusses ETI, positive shocks, and Hanlon repatriator data, but no consumer appears in supplied program; they remain context, not invented requirements.
- One-row Compustat and root-only SEC/LM probes are candidates only and do not establish required coverage. Raw/parsed filing roots do not prove processed DPAD, NOL, or Exhibit 21 panels.
- No author code was executed, no datasets downloaded, and no software installed. Future .do extraction is working preparation; supplied PDF remains unchanged.
