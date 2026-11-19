# Patch proposal: jar-9f26710aafff

Corporate Disclosure as a Tacit Coordination Mechanism: Evidence from Cartel Enforcement Regulations

DOI: 10.1111/1475-679X.12301

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied author preparation and construction workflow: transcript processing; the consumed firm-year supplier panel, supplied either prepared or through the documented Appendix A3 manual route; SAS-generated supporting measures; and Stata sample and variable construction ending in regress_sample.dta. Raw filing-index and Exhibit 10 sources are conditional inputs only when selecting that manual producer. Paper-wide final estimators are not supplied, and identifier CSVs do not provide a compatible analysis-only dataset.

Entry points: `1process conference calls.pdf`, `3additional variable construction.sas`, `2main.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 2/12301 - Corporate-Disclosure-as-a-Tacit-Coordination-Mechanism-Evidence-from-Cartel-Enforcement-Regulations/bsz-datasheet-code-and-identifiers.zip",
      "sha256": "4b7958852146feb4cfe575012c5898702f4193ad022c1c73772f8fb74e225c24"
    },
    {
      "path": "JAR-Volume 58/Issue 2/12301 - Corporate-Disclosure-as-a-Tacit-Coordination-Mechanism-Evidence-from-Cartel-Enforcement-Regulations/bsz-online-appendix.pdf",
      "sha256": "f064e99d66c0e7dab201769f3bb3ade1349a26b3237fc9c943f509edafa2fb6d"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "0264c02606fb410396d1cf78defa75653dc92607b51047828a5edf386f2f3169"
}
```

## Proposed actions

### A0001: Configure a coherent project-relative run root and draft3 output directory in working copies of 2main.do and the SAS file. Use the project root as launch directory, bsz_execution/run as the Stata/SAS run root, and draft3/ for generated files. Keep root Compustat_1990_2015.dta and draft3/Compustat_1990_2015.dta distinct pending confirmation of their intended variants.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I0002
Evidence: E0013, E0014, E0015, E0016, E0017

**Proposed edit:** `2main.do:4–4`
Source SHA-256: `61eccba0e8921e59251e29db421186ed725444eff29b580299fe7e33dcfea8bc`

Set a project-relative run root and define the existing $draft3 output convention before any consumers use it.

Current text:
```
cd "~"
```

Proposed replacement:
```
cd "bsz_execution/run"
global draft3 "draft3"
```

**Proposed edit:** `2main.do:128–128`
Source SHA-256: `61eccba0e8921e59251e29db421186ed725444eff29b580299fe7e33dcfea8bc`

Use a host-visible relative separator for the Dorn crosswalk path.

Current text:
```
merge 1:m naics6 using cw_n97_s87\cw_n97_s87,keep(3) nogen /*http://www.ddorn.net/data.htm*/
```

Proposed replacement:
```
merge 1:m naics6 using cw_n97_s87/cw_n97_s87,keep(3) nogen /*http://www.ddorn.net/data.htm*/
```

**Proposed edit:** `2main.do:336–336`
Source SHA-256: `61eccba0e8921e59251e29db421186ed725444eff29b580299fe7e33dcfea8bc`

Use the same draft3 directory and separator as the SAS public-firm-share output.

Current text:
```
merge m:1 naics_3digit  year using "$draft3\pctpublicfirm3d_s",keep(1 3) nogen
```

Proposed replacement:
```
merge m:1 naics_3digit  year using "$draft3/pctpublicfirm3d_s",keep(1 3) nogen
```

**Proposed edit:** `2main.do:342–342`
Source SHA-256: `61eccba0e8921e59251e29db421186ed725444eff29b580299fe7e33dcfea8bc`

Use the same draft3 directory and separator as the SAS Cournot output.

Current text:
```
merge m:1 sic3  year   using "$draft3\cournot",keep(1 3) nogen
```

Proposed replacement:
```
merge m:1 sic3  year   using "$draft3/cournot",keep(1 3) nogen
```

**Proposed edit:** `3additional variable construction.sas:216–216`
Source SHA-256: `6f56fe319a79bb860a0de32c2ced129df26e1284685f323594019ecefea10c1e`

Write the SAS Cournot output under the configured draft3 directory consumed by Stata.

Current text:
```
	file = "[redacted-path-ca5c97acfdfa]"
```

Proposed replacement:
```
	file = "draft3/cournot.dta"
```

**Proposed edit:** `3additional variable construction.sas:227–227`
Source SHA-256: `6f56fe319a79bb860a0de32c2ced129df26e1284685f323594019ecefea10c1e`

Read the specified Census source from the selected run root.

Current text:
```
proc import file="[redacted-path-d1d944582e97]" out=census replace;run; 
```

Proposed replacement:
```
proc import file="Census Concentration data.dta" out=census replace;run;
```

**Proposed edit:** `3additional variable construction.sas:356–356`
Source SHA-256: `6f56fe319a79bb860a0de32c2ced129df26e1284685f323594019ecefea10c1e`

Write the SAS public-firm-share outputs under the draft3 directory consumed by Stata.

Current text:
```
    file="[redacted-path-8d648f8bd8a5]" replace;
```

Proposed replacement:
```
    file="draft3/pctpublicfirm&i.d_s.dta" replace;
```

**Proposed edit:** `3additional variable construction.sas:366–366`
Source SHA-256: `6f56fe319a79bb860a0de32c2ced129df26e1284685f323594019ecefea10c1e`

Read the specified patent source from the selected run root.

Current text:
```
 infile '[redacted-path-0fe76ef106d2]' delimiter = ',' MISSOVER DSD lrecl=32767  firstobs=2 ;
```

Proposed replacement:
```
 infile 'patents.csv' delimiter = ',' MISSOVER DSD lrecl=32767  firstobs=2 ;
```

**Proposed edit:** `3additional variable construction.sas:447–447`
Source SHA-256: `6f56fe319a79bb860a0de32c2ced129df26e1284685f323594019ecefea10c1e`

Write the industry patent output under draft3 for the Stata merge.

Current text:
```
proc export data =indpatent file = "[redacted-path-946fb717c55f]"
```

Proposed replacement:
```
proc export data =indpatent file = "draft3/patent_industry_level.dta"
```

**Proposed edit:** `3additional variable construction.sas:592–592`
Source SHA-256: `6f56fe319a79bb860a0de32c2ced129df26e1284685f323594019ecefea10c1e`

Write the SAS stock-return output under draft3 for the Stata merge.

Current text:
```
     file = "[redacted-path-c6afb523620a]" replace;
```

Proposed replacement:
```
     file = "draft3/stockreturn.dta" replace;
```

Preparation / proposed procedure:

1. Launch from the project root and create bsz_execution/run, bsz_execution/run/draft3 and bsz_execution/run/cw_n97_s87 before the future stages.
2. In a working copy, set the Stata run directory to bsz_execution/run and define global draft3 as draft3.
3. Invoke future authorized SAS stages with the run directory as working directory and the host-supported relative paths.
4. Use the matching draft3 path for SAS outputs consumed by Stata: cournot, public-firm shares, patent-industry output and stockreturn.
5. Place the named Census and patent inputs at the configured run root, and place the crosswalk at cw_n97_s87/cw_n97_s87 beneath it.
6. Keep root Compustat_1990_2015.dta and draft3/Compustat_1990_2015.dta distinct until their intended variants are confirmed.
7. Do not hardcode an absolute workspace path in executable configuration.

Validation to perform later:

- Review all producing and consuming paths as one relative layout from the project root.
- Before a future authorized run, confirm each expected file is created at the exact consumer path and that root and draft3 Compustat files are intentionally distinct.

### A0002: Correct the supported TNIC deduplication key in a working copy: the code keeps gvkey/year and merges on gvkey/year, so duplicates should use that retained key.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: R0026, I0004
Evidence: E0008

**Proposed edit:** `2main.do:279–279`
Source SHA-256: `61eccba0e8921e59251e29db421186ed725444eff29b580299fe7e33dcfea8bc`

Deduplicate on the retained gvkey/year fields used by the subsequent merge.

Current text:
```
duplicates drop gvkey fyear,force 
```

Proposed replacement:
```
duplicates drop gvkey year,force 
```

Preparation / proposed procedure:

1. Replace the TNIC duplicates key with gvkey year in a working copy of 2main.do.

Validation to perform later:

- Review the resulting key against the preceding keep and following merge; do not change the p75 input population or similarity calculation.

### A0003: Guard the PPI cleanup after the merge that uses nogen.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: R0022, R0023, I0005
Evidence: E0009

**Proposed edit:** `2main.do:144–144`
Source SHA-256: `61eccba0e8921e59251e29db421186ed725444eff29b580299fe7e33dcfea8bc`

The preceding crosswalk merge uses nogen; capture makes this cleanup safe whether _merge is present or absent.

Current text:
```
drop _merge
```

Proposed replacement:
```
capture drop _merge
```

Preparation / proposed procedure:

1. In a working copy of 2main.do, change drop _merge to capture drop _merge.

Validation to perform later:

- Confirm the edit leaves the existing cleanup when _merge exists and is harmless when it does not; make no replacement merge variable.

### A0004: Extract the four Perl programs from the supplied PDF into working copies and configure their relative transcript layout. Embedded Stata Program 5 is a separate stage that reads its inputs from the run root. The PDF remains unchanged.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: R0014, R0015, R0016, I0002, I0003
Evidence: E0017, E0018, E0019, E0020, E0021, E0023

Preparation / proposed procedure:

1. Configure Program 1 to enter bsz_execution/transcripts when launched from the project root. Run Programs 2–4 with their process working directory at bsz_execution/transcripts; each stage then changes into its own input directory.
2. Create output_step1, output_step1_QA, output_step2 and output_step3 beneath the transcript root before running the Perl stages.
3. In Program 1 working copy, include a path separator in both output directory strings because they are concatenated directly to filenames.
4. In Program 2 and Program 3 working copies, set output directories to ../output_step2 and ../output_step3 after changing into their input directories.
5. In Program 4 working copy, keep its input stage at output_step3, place the exact dic.txt used by that stage there, and set its output directory to ../ so the counts file lands in the transcript root.
6. Copy the resulting conference_product_market_counts.txt into bsz_execution/run and place the confirmed conference_header input there. Program 5 has no directory change and must be run from bsz_execution/run.
7. Keep missing dictionary/header fields and producer contracts unresolved until the exact author inputs are available.

Validation to perform later:

- Review each Perl process working directory and internal directory change as an ordered chain before any future authorized run.
- Confirm Program 5 reads the copied count file and header from the run root, merges by cid and writes words_conference there after a future authorized run.

### A0005: Resolve and stage the documented Schott U.S. SIC trade input used for foreign-leniency weighting. Its actual vintage, fields and full population are not established by the package.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R0001
Evidence: E0032, E0043

Preparation / proposed procedure:

1. Obtain or identify the author-compatible trade file with country code, SIC, year, customs imports, exports and shipment value fields.
2. Confirm the supplied source period and SIC vintage cover the documented 1972–2005 series, including 1990 rows used to form weights.
3. Preserve the full source file needed for the author aggregation; do not substitute an independently rebuilt trade series.

Validation to perform later:

- Check field types, SIC coding, country identifiers, year coverage and the 1990 weight inputs against the source code and appendix before using the route.

### A0006: Build the country-year leniency input from the adoption years and None values already supplied in Appendix A2.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R0002
Evidence: E0025, E0033, E0065

Preparation / proposed procedure:

1. Map every Appendix A2 country to the author’s fic code using an identified mapping source or supplied crosswalk.
2. Confirm the author’s annual panel convention, including how adoption years and countries listed None are represented in each year.
3. Create country level.dta only after the mapping and year-domain rules are established; do not reacquire dates already tabulated in the appendix.

Validation to perform later:

- Compare the country/adoption-year entries and None cases with Appendix A2, then verify unique fic/year keys and the author-required leniencylaw coding.

### A0007: Resolve the missing import_penetrate producer from the documented Schott trade input while preserving its stated definition.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R0003
Evidence: E0034, E0044, E0026

Preparation / proposed procedure:

1. Confirm the author-compatible import/shipment/export source fields and four-digit SIC vintage for each year.
2. Apply imports divided by imports plus shipments minus exports, then carry the 2005 value forward after 2005 as the code describes.
3. Do not infer that the weighting file in R0001 is itself this finished panel; retain separate source and output roles.

Validation to perform later:

- Check output keys and import_penetrate values against the documented formula and post-2005 carry-forward rule; confirm the required period before merging.

### A0008: Use the boundedly readable local COMP.FUNDA candidate only after confirming its annual history, field mapping and the distinct source paths used by the author code.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R0004
Evidence: E0028, E0035, E0053, E0044

Preparation / proposed procedure:

1. Confirm the local candidate covers the author’s named 1990–2015 annual extract and all source filters.
2. Resolve the field mapping for Stata SIC versus the local sich field, plus identifiers, fiscal dates and required accounting fields.
3. Stage the root Compustat_1990_2015.dta read and the separate draft3/Compustat_1990_2015.dta read according to their confirmed roles; do not assume they are the same variant.

Validation to perform later:

- Verify field types, unique keys, annual coverage and all required source filters over the full candidate, not just the one-row readability sample.

### A0009: Check the local COMPSEGD.WRDS_SEGMERGED candidate against the author’s primary-segment SIC bridge before using it.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R0005
Evidence: E0028, E0036, E0060

Preparation / proposed procedure:

1. Confirm that SICS1 is the required SIC field and that the author’s intended primary segment can be identified without inventing a selection rule.
2. Check whether rows are unique on gvkey/datadate and cover the annual Compustat dates used by the Stata merge.
3. Use the author’s sic_from_segment input if the local table cannot be shown compatible; do not substitute MSE or another segment definition.

Validation to perform later:

- Check the full period and gvkey/datadate key behavior and confirm the sics1 mapping before updating the route status.

### A0010: Validate the boundedly readable local Compustat and CRSP candidates as complete inputs before using them in the SAS support branch.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R0006, R0007, R0008, R0009, R0010, R0011
Evidence: E0012, E0013, E0015, E0028, E0054, E0055, E0056, E0057, E0058, E0059

Preparation / proposed procedure:

1. For COMP.COMPANY, COMP.NAMES and COMP.FUNDQ, verify the required company, SIC and quarterly fields and the source periods used in the SAS joins and filters.
2. For CRSP.CCMXPF_LINKTABLE, CRSP.MSEALL and CRSP.MSF, verify the exact identifiers, date/link fields, listing/delisting fields and monthly return fields expected by the supplied blocks.
3. Confirm full historical coverage: quarterly Compustat input 1990–2013 with its full constructed-row population for global percentile cuts; annual/company/link/CRSP spans required by the documented 1993–2013 output branches.
4. Stage only the exact validated catalogued products under the approved SAS wrapper path and preserve product distinctions.

Validation to perform later:

- Check the full candidate histories, required fields, date bounds, key cardinality and remote/local product compatibility; the one-row probes establish readability only.

### A0011: Resolve exact access and schema for the distinct CRSP MSE industry table and ERMPORT1 benchmark input; the catalog miss does not establish absence or a license barrier.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R0012, R0013
Evidence: E0014, E0016, E0028

Preparation / proposed procedure:

1. Confirm an authorized route to CRSP MSE with PERMNO/date/SIC fields and the 1999–2012 history required by the patent branch.
2. Confirm an authorized route to ERMPORT1 with PERMNO/date/RET/decret/capn fields and the benchmark date range required by stockreturn.
3. Keep MSE distinct from MSEALL; do not infer equivalence or access restrictions from the local catalogue results.

Validation to perform later:

- Confirm product names, fields, date bounds and current route availability before treating either input as usable.

### A0012: Resolve whether the local Capital IQ transcript tables can supply the author’s Thomson Reuters/StreetEvents XML transcript fields and history, or provide the compatible author XML input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R0014
Evidence: E0002, E0017, E0021, E0052

Preparation / proposed procedure:

1. Request or identify the exact transcript product/version and file format used for 2002–2012 calls.
2. For the local PostgreSQL candidate, first establish the permitted identifier/date/type/speaker mapping from transcript components to calls and firm identifiers; current inspected metadata alone does not supply those fields.
3. Confirm that the compatible input preserves presentation/Q&A text, speaker roles and call identifiers needed by all four Perl stages.

Validation to perform later:

- Compare call dates, IDs, presentation text, Q&A text, speaker roles and complete required history before marking either route compatible.

### A0013: Obtain the exact author conference_header and baseline dic.txt inputs, including their field/encoding and vocabulary contracts.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R0015, R0016
Evidence: E0021, E0022, E0023, E0066

Preparation / proposed procedure:

1. Request conference_header with cid, gvkey, dateformatted and eflag, plus its full 2002–2012 coverage and key rules.
2. Resolve the exact baseline dictionary file and encoding. The embedded code comment lists 12 tokens, while Appendix A11’s baseline definition lists product, service, offering, offer, customers and client; Dic2 and Dic3 are separate definitions.
3. Do not silently choose or expand the baseline word list. Preserve the documented dictionary variant selected by the authors.

Validation to perform later:

- Check unique cid keys, date/GVKEY types and earnings-call indicator semantics for the header.
- Compare the baseline dictionary against the confirmed author file and relevant appendix definition before running the word counter.

### A0016: For the required redacted-supplier firm-year panel, use either a compatible author-prepared panel or the documented Appendix A3 Exhibit 10 selection and manual-review procedure as its producer. The raw filing index and exhibit texts are conditional upstream inputs to that producer, not additional mandatory requirements.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R0019
Evidence: E0003, E0024

Preparation / proposed procedure:

1. Use the author-prepared redact_supplier_June2017 panel if its key, field and coverage contract is confirmed, or select the Appendix A3 raw-manual route as the producer for the same panel.
2. Only for the raw-manual route, resolve compatible filing-index records and Exhibit 10 texts for 2000–2012; preserve the appendix’s title/text filters, first-200-word exclusions, manual non-supply exclusions, supplier-versus-customer filer rule, nonmanufacturing exclusions and control-variable screen.
3. Record manual review decisions and preserve the authors’ documented stage counts; do not fabricate labels or replace the reviewed supplier classification.
4. Do not require the prepared panel and the raw filing route simultaneously.

Validation to perform later:

- For a prepared panel, confirm gvkey/year keys, redaction fields, contract-sample coverage and coding semantics.
- For a completed manual route, compare documented stage counts (6,671, 3,066, 1,611, 959 and 414 control-data firm-years) and final output keys against Appendix A3.

### A0017: Resolve the two distinct Connor cartel outputs and their current usable route without assuming a present access barrier from a historical purchase.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R0020, R0021
Evidence: E0037, E0038, E0044

Preparation / proposed procedure:

1. Identify the author cartels-by-industry input or compatible Connor source for SIC2/year total_cartels and total_convict.
2. Identify the separate cartel_convict firm-year GVKEY/year identifiers needed for conviction and recent-peer measures, including sufficient pre-observation history.
3. Confirm the current authorized delivery route and the name-matching rules used to assign cartels to SIC and firms.
4. Do not infer an NDA, entitlement restriction or current barrier from the historical purchase/agreement note alone.

Validation to perform later:

- Check fields, types, keys, SIC/GVKEY mappings and full required years/history for each output separately.

### A0018: Resolve the author-compatible monthly BLS PPI input and preserve the supplied six-digit NAICS aggregation and year filters.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R0022
Evidence: E0039, E0044

Preparation / proposed procedure:

1. Confirm the required pc.data.0.Current.txt field contract and selected monthly series identifiers.
2. Apply the code’s monthly mean by series_id/year, author series cleanup and six-digit NAICS filters, retaining years through 2012.
3. Do not substitute another PPI vintage or invent a series-selection rule when the author series mapping is not supplied.

Validation to perform later:

- Check series identifiers, date range, aggregation and resulting naics6/year/PPI keys against the exact code filters.

### A0019: Obtain the exact Dorn 1997 NAICS-to-1987 SIC crosswalk named in the supplied code and verify its weighted mapping fields.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R0023
Evidence: E0040, E0044

Preparation / proposed procedure:

1. Identify the author-compatible cw_n97_s87 file and confirm its naics6, sic4 and weight columns.
2. Place it beneath the configured run root at cw_n97_s87/cw_n97_s87 so the corrected relative Stata path resolves.
3. Retain the documented weight-based SIC mapping for the PPI construction; do not substitute an unweighted or differently-vintaged concordance.

Validation to perform later:

- Check crosswalk version, key/multiplicity, weights and six-digit NAICS coverage before merging.

### A0020: Resolve the Census manufacturing sales/concentration input used by the SAS public-firm-share branch.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R0024
Evidence: E0013, E0041

Preparation / proposed procedure:

1. Identify the exact Census Concentration data.dta or author-compatible equivalent with ic, year, total_sales, total_comps and digits.
2. Confirm the Census years and code vintage, and that annual interpolation is supported through 2012 after the code’s 1997+ filter.
3. Stage the input under the run root for the configured SAS import; preserve its distinction from the separate Census HHI panel.

Validation to perform later:

- Check source years, field definitions, code vintage and interpolation inputs; do not infer complete annual values from the four Census benchmark years.

### A0021: Resolve the separate four-digit NAICS Census HHI panel consumed as hhi_census, including its missing producer and output contract.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R0025
Evidence: E0026, E0042

Preparation / proposed procedure:

1. Request the exact author HHI panel or its documented producer, join keys, variable name and Census vintage.
2. Confirm naics_4digit/census_yr coverage for the author-selected 1997, 2002, 2007 and 2012 periods.
3. Keep this Census HHI input distinct from Compustat HHI and the Census sales panel used by SAS.

Validation to perform later:

- Check the exact merge key and field types and confirm the HHI meaning/units before updating the route.

### A0022: Obtain the author-compatible all-years TNIC score file and preserve the entire intended input population because p75 is computed before aggregation.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R0026
Evidence: E0008, E0026

Preparation / proposed procedure:

1. Identify the version of tnic3_allyears_extend_scores.txt used by the authors, including gvkey1, gvkey2, year and score.
2. Confirm complete intended year and pair population, not just sampled firm-years or a subset of target years.
3. Stage the full score input and apply the separate supported gvkey/year deduplication edit in A0002.

Validation to perform later:

- Verify unique field parsing and source population before computing p75; do not infer historical completeness from a bounded sample.

### A0023: Resolve the documented Kogan patent CSV version and complete PERMNO/date history needed for cumulative patent counts.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R0027
Evidence: E0014, E0026

Preparation / proposed procedure:

1. Identify patents.csv with the nine columns and types specified by the SAS import, plus required PERMNO linkage and issue-date history from 1995 through 2012.
2. Place the confirmed input under the configured SAS run root.
3. Preserve the author’s cumulative 1995-to-year patent counts and SIC2/year median construction; do not substitute a different patent measure.

Validation to perform later:

- Check CSV header order, field types, date conversion, PERMNO formatting and period coverage before the SAS branch is run.

### A0024: Close the remaining missing-producer and generated-file handoffs with the author’s exact source, key and output definitions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I0003
Evidence: E0005, E0034, E0036, E0037, E0038, E0042, E0023, E0013, E0014, E0016

Preparation / proposed procedure:

1. For import_penetrate, sic_from_segment, cartel_convict, cartels by industry and hhi_census, confirm the selected producer or prepared input, exact fields, keys and period.
2. For conference_header and dic.txt, confirm the exact author inputs, encoding, vocabulary/role definitions and history.
3. For SAS-generated files consumed by Stata, confirm the export path, file format, key and field names for cournot, public-firm shares, stockreturn, patent-industry summaries and other referenced intermediates.
4. Preserve intermediate producers already present in the supplied code; do not treat them as new external data requirements.

Validation to perform later:

- Build a consumer-to-producer handoff table and verify every input path, schema, key and period against its source before author execution.

### A0025: Before any future authorized run, reconcile the delivered inputs with the full scoped requirement list and record their exact product/version, fields, identifier mapping and historical population.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I0001
Evidence: E0001, E0002, E0003, E0024, E0029, E0030, E0065

Preparation / proposed procedure:

1. Treat the packaged CID/GVKEY CSVs as identifier/test lists only, not full analysis inputs.
2. For each requirement, select a documented compatible route and resolve its field, period, source variant, and output contract before marking it available.
3. Preserve alternative routes as alternatives and keep unresolved history or construction gaps explicit.
4. Do not infer a present access barrier from absent files or historical purchase notes.

Validation to perform later:

- Verify every route against its stated source and full required population; one-row readability probes and identifier lists do not establish compatibility or completeness.

### A0026: Make the exact Perl modules imported by the author word-processing stages available to the selected Perl runtime during future setup.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW0003, SW0004, SW0005
Evidence: E0061, E0019, E0021

Preparation / proposed procedure:

1. Configure the future authorized Perl environment to load File::chdir, Lingua::Stem::En and Lingua::StopWords.
2. Use a supported module path for the selected Perl v5.40.1 runtime; do not rely on the Windows library path embedded in the PDF.
3. Do not run the author programs as part of this metadata/setup assessment.

Validation to perform later:

- In a future authorized setup, check each exact module import with the same Perl executable and confirm the selected runtime’s library path.

### A0027: Confirm SAS 9.4, SAS/CONNECT and PROC REG availability through an authorized future session; the recorded TKELS startup failure does not establish an entitlement barrier.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW0006, SW0007
Evidence: E0012, E0031

Preparation / proposed procedure:

1. Use the authorized WRDS SAS session or approved local SAS configuration to confirm remote RSUBMIT/DOWNLOAD, required libraries and PROC REG support.
2. Do not retry SAS startup as part of this assessment or interpret the earlier TKELS failure as license evidence.
3. Do not run or compile the supplied SAS program during this check.

Validation to perform later:

- Record the successful runtime and remote procedure availability before scheduling a future author run.

### A0028: Provide the exact Stata winsor2 command required by 2main.do in a future authorized environment setup.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW0008
Evidence: E0063, E0011

Preparation / proposed procedure:

1. Resolve a supported installation or supplied ado source for the exact winsor2 command without installing packages during this assessment.
2. Configure its ado path in the future Stata environment.

Validation to perform later:

- Check the exact command entry point and required varlist/cut/replace syntax before a future authorized run.

### A0029: Provide the exact Stata hhi command in a future authorized setup while preserving the unknown generated-variable contract.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW0009
Evidence: E0062, E0010, E0011

Preparation / proposed procedure:

1. Resolve the author-required hhi command source and configure its ado path without installing packages during this assessment.
2. Do not substitute a different HHI routine or infer its output names from the command label.

Validation to perform later:

- Inspect the exact command’s documented output variables and compare them with the supplied rename and downstream varlist before a future run.

### A0030: Provide the exact egen wtmean() extension function invoked by the supplied Stata code.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW0010
Evidence: E0064, E0040

Preparation / proposed procedure:

1. Resolve the _gwtmean function source and configure the appropriate ado/egen path in a future authorized environment.
2. Do not install packages or run the author do-file during this assessment.

Validation to perform later:

- Check the exact function entry point and weighted-mean output contract before future use.

### A0031: Resolve the HHI command’s actual output and the later hhi_ varlist reference before proposing any variable-name edit.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I0006, SW0009
Evidence: E0010, E0011, E0062

Preparation / proposed procedure:

1. Confirm which variables the author-required hhi sale, by(sic2 year) command creates.
2. Trace the supplied rename hhi_sale to hh_index and any other variable available at the later winsor2 call.
3. Check whether Stata’s variable abbreviation expansion or the actual winsor2 parser accepts the requested hhi_ name in that real schema.
4. Do not rename hh_index, invent a new variable, or declare the hhi command itself unusable without its output contract.

Validation to perform later:

- Use a future authorized schema/command check to establish the exact output, variable lifetime and accepted downstream varlist; otherwise retain the issue as unresolved.

### A0032: Resolve the SAS stockreturn export and Stata bhar_size reference using the actual exported/imported spelling and Stata abbreviation settings.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I0007, R0011
Evidence: E0016, E0011, E0031

Preparation / proposed procedure:

1. Confirm the exported stockreturn field names and their case after SAS export and Stata import.
2. Check the current Stata varabbrev setting and whether the actual imported field has the lower-case spelling bhar_sizeadj; confirm that bhar_size is a unique valid prefix only if the case and setting permit it.
3. Preserve BHAR and BHAR_sizeadj and do not propose a replacement field based only on the spelling difference.

Validation to perform later:

- Record the actual imported schema, Stata abbreviation setting and exact prefix resolution before treating this as a mismatch or confirming compatibility.

### A0033: After the inputs, software and schema handoffs are resolved, follow this ordered full preparation procedure with the configured relative roots. This is a future authorized run plan, not a claim that the workflow has executed.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: I0002, I0003, R0014, R0015, R0016
Evidence: E0012, E0013, E0014, E0015, E0016, E0017, E0018, E0019, E0020, E0021, E0023

Preparation / proposed procedure:

1. Run the four Perl transcript stages in order under bsz_execution/transcripts, using the working-directory conventions and stage paths in A0004.
2. Copy conference_product_market_counts.txt and the confirmed conference_header input into bsz_execution/run. Run embedded Stata Program 5 from that run directory so its relative inputs resolve and words_conference.dta is produced there.
3. Run the complete supplied 3additional variable construction.sas support program with host working directory bsz_execution/run. Preserve every supplied branch and output; its draft3 exports must land at the paths consumed by Stata.
4. Launch 2main.do from the project root. Its configured first lines enter bsz_execution/run and set global draft3, so launching it from the run directory would apply the relative cd twice. Preserve the supplied Stata source order.
5. Proceed only after each required input, output schema, software dependency and path handoff in the assessment is resolved; do not treat this procedure as evidence of a successful run.

Validation to perform later:

- Before a future run, confirm the four Perl stage outputs, Program 5 handoff, all SAS output paths, and the internal 2main.do cd/global setup as one ordered chain.
- After an authorized run, confirm each consumer sees the intended producer output, with no omitted SAS branch or changed Stata code order.


## Remaining issues and prerequisites

- I0001 [unresolved; full_pipeline]: The package contains code and CID/GVKEY identifier or test lists, but not the full analysis inputs. The source-specific products, author-prepared panels, fields, versions and historical populations in the data requirements remain unresolved; no current access barrier is established.
- I0002 [preparation; full_pipeline]: The Perl stages concatenate some output directory names to filenames and nest later-stage outputs under the current input directory. SAS and Stata also use inconsistent tilde and $draft3 paths, and 2main.do has no explicit project working directory or draft3 global. These are resolvable working-copy path and orchestration setup tasks; the separate missing dic.txt and conference_header inputs and generated-file schema handoffs remain unresolved under I0003.
- I0003 [unresolved; full_pipeline]: Appendix A3 documents the Exhibit 10 selection and manual-review producer for the supplier-contract sample, so R0019 has a documented manual route as an alternative to the author-prepared panel. The final panel’s field/key/coding/coverage contract remains unresolved. Other consumers lack supplied producers or output contracts, including import_penetrate, sic_from_segment, cartel_convict, cartels by industry, hhi_census, conference_header and dic.txt; the Stata consumer and SAS producer schemas for generated files also require reconciliation.
- I0004 [preparation; full_pipeline]: The TNIC block keeps gvkey/year/similar, then drops duplicates by gvkey/fyear before merging on gvkey/year. The retained and deduplication keys conflict. The supported working-copy correction is to deduplicate on gvkey/year.
- I0005 [preparation; full_pipeline]: The PPI crosswalk merge uses nogen, and the later unconditional drop _merge can fail if that variable is absent. A guarded capture drop preserves the cleanup when _merge exists and is a no-op when it does not.
- I0006 [unresolved; full_pipeline]: The supplied code calls hhi sale, renames hhi_sale to hh_index, and later requests hhi_ in a winsor2 varlist. The hhi command output contract and variable state are not established; verify the actual producer output and Stata abbreviation behavior before proposing a variable edit.
- I0007 [unresolved; full_pipeline]: The supplied SAS stockreturn output defines BHAR and BHAR_sizeadj, while 2main.do refers to bhar_size. Stata variable names are case-sensitive: a lower-case bhar_size abbreviation could match only an actual lower-case bhar_sizeadj field, subject to varabbrev and uniqueness. Verify the actual export/import spelling and abbreviation setting before treating this as a mismatch.
- R0001 [undetermined]: U.S. SIC import/export/shipment data used to compute foreign-leniency weights; code expects country code, SIC, year, customs imports, exports and shipment values, with 1990 weights and a described 1972–2005 series.
- R0002 [undetermined]: Country-year foreign leniency adoption panel consumed as country level.dta (fic, year, leniencylaw). Appendix A2 supplies country adoption years and explicit None values; the country-to-fic mapping and annual panel convention remain unresolved.
- R0003 [undetermined]: Four-digit SIC import-penetration panel consumed as import_penetrate. Code defines imports/(imports+shipments−exports) and carries the 2005 value forward after 2005.
- R0004 [undetermined]: Annual Compustat fundamentals and identifiers used by Stata and SAS. Stata filters firm records, forms fiscal-year lags and constructs the 1994+ sample.
- R0005 [undetermined]: Primary-segment SIC bridge consumed as $draft3/sic_from_segment, keyed by gvkey/datadate with sics1; no producer or packaged equivalent is supplied.
- R0006 [undetermined]: Compustat company master used by SAS to attach NAICS codes to annual public-firm observations.
- R0007 [undetermined]: Compustat Names/SIC table joined to quarterly fundamentals to create sic3.
- R0008 [undetermined]: Quarterly Compustat fundamentals for complement/substitute construction. Input filter is fyearq 1990–2013; full constructed rows feed global winsor percentiles; annual regressions use year−3 through year for 1994–2012.
- R0009 [undetermined]: CRSP/Compustat CCM link history maps GVKEY/datadate to PERMNO for public-firm and return outputs.
- R0010 [undetermined]: CRSP MSEALL security/event history used for exchange/share-code screens and delisting-return fields.
- R0011 [undetermined]: CRSP monthly stock file for monthly returns, prices, shares and volume in SAS stockreturn.
- R0012 [undetermined]: CRSP MSE industry history maps PERMNO to SIC for patent summaries (date, permno, siccd/hsiccd, 1999–2012).
- R0013 [undetermined]: CRSP ERM portfolio returns provide benchmark decile returns in stockreturn.
- R0014 [undetermined]: Thomson Reuters/StreetEvents XML transcripts with call IDs, dates, types, presentation/Q&A text and speaker roles for the embedded Perl stages.
- R0015 [undetermined]: Conference header crosswalk required to link CID to GVKEY, call date and earnings-call type.
- R0016 [undetermined]: Baseline product-market dictionary dic.txt read by the Perl count program.
- R0019 [undetermined]: Firm-year redacted-supplier panel consumed as $draft3/redact_supplier_June2017. The required input may be the author-prepared compatible panel or the output of the documented Appendix A3 Exhibit 10 selection and manual-review producer. Raw filing-index and exhibit-text sources are conditional upstream inputs only for the manual route.
- R0020 [undetermined]: Connor cartel industry-year counts used to construct Table1_PanelA (sic_2digits/year, total_cartels, total_convict).
- R0021 [undetermined]: Firm-year cartel conviction identifiers consumed as cartel_convict.dta for auxiliary conviction and recent-peer measures.
- R0022 [undetermined]: BLS PPI monthly source file used to form annual six-digit NAICS values through 2012.
- R0023 [undetermined]: 1997 NAICS-to-1987 SIC concordance used to map annual PPI and apply employment weights.
- R0024 [undetermined]: Census sales/concentration panel consumed by SAS to interpolate total_sales and compute three-digit public-firm shares.
- R0025 [undetermined]: Four-digit NAICS Census HHI panel merged by naics_4digit/census_yr; distinct from SAS Census sales data.
- R0026 [undetermined]: Hoberg–Phillips TNIC3 all-years similarity scores. Stata computes p75 before firm/year aggregation, so all input rows affect the threshold.
- R0027 [undetermined]: Patent-level data for cumulative PERMNO patent counts through 2012 and SIC2/year industry medians.
- SW0003 [preparation_required]: The embedded Perl stages import File::chdir; it did not load from the current default Perl library paths. Future setup must make the author-required module available to the selected Perl runtime.
- SW0004 [preparation_required]: The Perl word counter imports Lingua::Stem::En; it did not load from the current default Perl library paths. Future setup must make the author-required module available to the selected Perl runtime.
- SW0005 [preparation_required]: The Perl word counter imports Lingua::StopWords; it did not load from the current default Perl library paths. Future setup must make the author-required module available to the selected Perl runtime.
- SW0006 [unverified]: The SAS program uses remote RSUBMIT/DOWNLOAD and a local SAS runtime. Existing startup stopped at TKELS; no retry was made, and that failure does not establish missing software entitlement.
- SW0007 [unverified]: The code invokes PROC REG; availability on the WRDS remote host or local runtime is unverified.
- SW0008 [preparation_required]: Stata 2main.do invokes winsor2; the exact command was not found in checked adopaths. Future setup must provide the invoked command and verify the expected varlist behavior.
- SW0009 [preparation_required]: Stata 2main.do invokes hhi; the exact command was not found in checked adopaths. The actual output-variable contract remains unknown; do not substitute a guessed command or output.
- SW0010 [preparation_required]: The Stata code invokes egen wtmean(); its exact _gwtmean function entry point was not found in checked adopaths. Future setup must provide the invoked function and verify its weighted-mean result.

## Review notes

- Assessed the full supplied workflow only: embedded transcript Perl/Stata code, all SAS support branches and 2main.do. Appendix estimators and robustness analyses without supplied programs remain contextual limitations.
- Reviewed each of the 41 frozen dependency IDs. External reads are mapped to product-level requirements; remote/work datasets are classified as generated only where the supplied code contains their producer. Additional literal reads not represented in the frozen checklist are tracked as separate requirements, including import_penetrate, sic_from_segment, PPI crosswalk, conference_header, dic.txt, redaction panel, conviction panel and hhi_census.
- The packaged CID/GVKEY CSVs were read only through existing one-row probes and are identifier/test lists, not full analysis inputs. Local catalog records are candidates only; they do not establish data access or historical coverage.
- No author programs, regression, dataset download, software install, data edit or SAS startup retry was performed.
- A metadata-only PostgreSQL check of the documented Capital IQ transcript candidate found one component-text table and no call-header/role mapping table in its schema. No transcript row data were read; its compatibility with the Thomson Reuters XML workflow remains unresolved.
