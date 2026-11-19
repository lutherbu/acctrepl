# Patch proposal: jar-4b89ab1a9628

Short-Term Institutions, Analyst Recommendations, and Mispricing: The Role of Higher-Order Beliefs

DOI: 10.1111/1475-679X.12352

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Author-supplied SAS data-construction workflow that creates the final dataset; it does not include the paper-wide regression/portfolio analysis programs.

Entry points: `CPS_finaldataset_code.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 3/12352 - Short-Term-Institutions-Analyst-Recommendations-and-Mispricing-The-Role-of-Higher-Order-Beliefs/cps-datasheet-code-and-identifiers.zip",
      "sha256": "00f088198873ab464b2bc5e40de6efb5d9c91845c96a74481e271a7c9adf6b67"
    },
    {
      "path": "JAR-Volume 59/Issue 3/12352 - Short-Term-Institutions-Analyst-Recommendations-and-Mispricing-The-Role-of-Higher-Order-Beliefs/cps-online-appendix.pdf",
      "sha256": "9e95054e27cce70ab18b0402bcbc81d7a49ddeb6ad55dc027c0ccfd256bbe637"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "a604f429fe27061226e7b52f7e8872b0b0ed48347d5c1e6b35500ad2f4f16103"
}
```

## Proposed actions

### A_INPUTS_AND_PRODUCERS: Stage compatible direct inputs and resolve the missing preparation handoffs without changing the authors' formulas, filters, joins or variable definitions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CRSP_MONTHLY, R_13F_HOLDINGS, R_CHARS, R_IDIORISKFF, R_BUSHEE_VARIABLES, R_FUND_TURNOVER_LTSTIO, R_IBES_SUMMARY, R_EARNVOL, R_HERDING, R_RDSALE, I_MISSING_PRODUCERS
Evidence: E_DOC_RAW, E_CRSP, E_HOLDINGS, E_CHARS, E_IDIORISK, E_BUSHEE, E_FUND_STIO, E_IBES, E_EARNVOL, E_HERDING, E_RDSALE, E_APPENDIX_EARNVOL, E_FROZEN_CATALOG, E_CATALOG_SEARCH, E_IBES_CATALOG, E_PROBE_CRSP_MSF, E_PROBE_CRSP_MSENAMES, E_PROBE_TFN_S34, E_PROBE_COMP_FUNDA, E_ID_LIST

Preparation / proposed procedure:

1. Prepare the author-shaped crsp.crspdata input. CRSP.MSF is readable with CUSIP, PERMNO, DATE, PRC, RET and SHROUT, while CRSP.MSENAMES is readable with PERMNO, CUSIP, SHRCD and name-validity dates; confirm a date-valid join supplies the required share code and the author's period/product before treating the pair as compatible.
2. Treat catalog-listed TFN.S34 only as a 13F candidate: its label and catalog metadata identify Thomson-Reuters 13F holdings, but the bounded probe timed out and the catalog fields do not include PERMNO. Resolve readability and the time-valid CUSIP-to-PERMNO handoff before using it as Holdings.Holdings_type.
3. Locate compatible prepared chars, idioriskff, bushee_variables, fundturnover_ltstio, ibesrecosummary, jointmz.earnvol, herdingmeasures_final2 and rddata inputs, or obtain the omitted producer programs and their exact input/output contracts.
4. For chars, confirm the listed stock-quarter fields and prc consumed by the final filter; for the Bushee input, confirm year, qtr, permno, io_tra and io; for IBES, confirm CUSIP/statpers/meanrec/numrec; preserve the source's distinct year, qtrno2 and fyear keys.
5. Obtain the missing fundturnover_ltstio producer or exact prepared table; preserve the source comment's link to fundturnover_inst and testinst and resolve how stio_fundturn/ltio_fundturn are constructed.
6. COMP.FUNDA is readable with cusip, fyear, datadate, at, ib, sale and xrd columns, but the one-row probe does not establish history or nonmissing values. Obtain the omitted earnvol producer and confirm its five-fiscal-year deflated-earnings window/minimum-three rule; obtain the exact rdsale recipe and herding definitions rather than substituting guessed aliases.
7. The assigned frozen catalog returned no exact MEANREC/NUMREC or recsum candidate for ibesrecosummary. Confirm the author-compatible IBES recommendation-summary product and its history/identifier mapping; do not replace it with an EPS summary table.
8. The packaged CPS_Final Sample_Identifiers.txt is only a CUSIP/year/qtr list; it does not bypass the missing direct inputs or supply the final dataset. After staging compatible inputs, perform bounded metadata checks and later validate required keys, fields and join coverage during an authorized execution.

Validation to perform later:

- Confirm all required source columns and key types in the staged tables.
- After an authorized run, inspect merge counts and verify finaldataset contains the documented fields and passes the authored final filter.

### A_WORKFLOW_ORDER: Resolve the actual producer handoffs and preserve the supplied SAS construction order from raw CRSP/13F inputs through the filtered finaldataset.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_MISSING_PRODUCERS
Evidence: E_CRSP, E_HOLDINGS, E_TURNOVER, E_FUND_TURNOVER_OUTPUT, E_CHARS, E_IDIORISK, E_BUSHEE, E_FUND_STIO, E_IBES, E_EARNVOL, E_HERDING, E_RDSALE, E_FINAL_FILTER

Preparation / proposed procedure:

1. Load quarter-end monthly CRSP and Holdings.Holdings_type; derive quarter-end rdates, sort both inputs, and merge on permno/rqdate to create the matched holdings rows. Keep the code's existing share-code/return/price filters, qtrno2/value/pctshares calculations and native SAS KEEP/RENAME behavior.
2. From matched holdings, form fundqtr and test2 to fill observed two-quarter reporting gaps, append test and test2 into testchange, align lagged holding values on the next qtrno2, apply maxqtr, and produce testinst. Preserve that the source's lag and semiannual logic is part of the turnover input construction.
3. Re-read quarter-end CRSP prices and merge with testinst; compute num/den and sum by fundno/qtrno2/semiannual into fundturnover_inst, then create lagturn1-3, the four-quarter mean and turnrank. Merge fundturnover_inst with testinst2 to create fundturnshares and aggregate to stock_fundturnover/fundturnlen.
4. Before the final merge, resolve the absent producer for fundturnover_ltstio. The source comment links its stio_fundturn/ltio_fundturn measures to fundturnover_inst and testinst, but no supplied block creates that table; do not consume it until the producer/schema handoff is supplied.
5. Merge chars with the generated stock_fundturnover by qtrno2/permno to start finaldataset. Then, in the supplied order, merge idioriskff by qtrno2/permno; bushee_variables by qtrno2/permno; fundturnover_ltstio by qtrno2/permno; IBES recommendation summary by qtrno2/CUSIP after selecting the last statpers per quarter; jointmz.earnvol by fyear/CUSIP; herdingmeasures_final2 by qtrno2/permno; and rddata by CUSIP/fyear.
6. Apply the supplied SIC-code intangible assignments, then retain only observations with nonmissing fundturnlen, nonmissing meanrec, and prc >= 1; persist finaldataset to the chosen durable output library. Do not infer a regression or portfolio driver from the online appendix.

Validation to perform later:

- Before any separately authorized run, verify each producer's output dataset, keys and columns against its next consumer, including fyear versus qtrno2 and the char prc field used by the final filter.
- After an authorized run, verify the documented order, the prepared-input merge keys and the persistent finaldataset output.

### A_CONFIG_AND_OUTPUT: Configure SAS library roots and a durable finaldataset output for a future batch run while preserving the program's original source directories and table names.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: S_SAS, I_LIBREF_CONFIG, I_SAS_RUNTIME, I_FINAL_OUTPUT
Evidence: E_CRSP, E_HOLDINGS, E_EARNVOL, E_FINAL_FILTER, E_ENV

Preparation / proposed procedure:

1. Use a SAS 9.4 batch runtime only after its TKELS initialization problem is resolved; the current frozen probe does not establish whether the installed runtime is usable.
2. Configure crsp, Holdings and jointmz librefs plus the library/current-directory containing the unqualified prepared tables. Use coherent relative or approved [redacted-path-1ea520892f47] paths in any host wrapper; validate path visibility and write access before the separately authorized execution.
3. Set an explicit durable output library and filename for finaldataset after the final filter, and document that output as the construction result. The supplied package includes no paper-wide regression or portfolio-analysis driver; that analysis workflow is outside this data-construction target.
4. Run the supplied source in its documented step order only after inputs, library paths and SAS runtime are ready; do not alter KEEP/RENAME, chained comparisons or other authored data semantics during configuration.

Validation to perform later:

- Verify the SAS runtime version and batch startup after environment resolution.
- Verify every LIBNAME and prepared input resolves to the intended dataset and persist the final dataset at the selected output path.


## Remaining issues and prerequisites

- I_MISSING_PRODUCERS [unresolved; full_pipeline]: The supplied source consumes chars, idioriskff, bushee_variables, fundturnover_ltstio, herdingmeasures_final2 and rddata without producing them. It also consumes jointmz.earnvol without its stated annual Compustat producer. Source-level field names/keys are visible, but definitions, upstream order, histories and compatible inputs are not supplied. The datasheet's vendor/source inventory does not provide these producer programs or datasets.
- I_LIBREF_CONFIG [unresolved; full_pipeline]: The SAS source does not assign LIBNAMEs or define a working-directory/import setup for crsp, Holdings, jointmz or the unqualified prepared datasets. The frozen parser flags the three qualified datasets as dynamic. Required path and staging configuration remain unspecified.
- I_SAS_RUNTIME [unresolved; full_pipeline]: SAS runtime availability is unverified because the frozen bounded startup probe failed to initialize TKELS. Do not infer absent licensing; runtime initialization must be resolved before a future authorized run.
- I_FINAL_OUTPUT [preparation; full_pipeline]: The supplied source ends after filtering the SAS WORK table finaldataset and does not document a persistent output library, export format or downstream consumer. A durable output location/name can be configured during preparation; the remaining paper-wide analysis workflow is not supplied and is outside this data-construction target.
- R_CRSP_MONTHLY [undetermined]: Monthly CRSP input read as crsp.crspdata. The code expects cusip, permno, date, shrcd, prc, ret and shrout, and uses March/June/September/December rows in its turnover construction. A local monthly securities candidate has every expected field except SHRCD; a name-history join may supply it, but the code's author-shaped product, identifier history, quarter coverage and required construction history remain unverified.
- R_13F_HOLDINGS [undetermined]: Institutional 13F holdings input read as Holdings.Holdings_type. The code uses permno, rdate, mgrno, shares and cusip to create quarterly fund holdings. The frozen catalog lists the Thomson-Reuters S34 13F table as a product candidate, but its catalog fields do not show PERMNO and its one-row probe timed out; identifier linkage, reporting periods and coverage remain unverified.
- R_CHARS [undetermined]: Prepared quarterly chars dataset merged into the final dataset. The comment identifies mcap, bmratio, io, avgdailyturnover, mom12, cusip, permno, siccd, qtrno2 and fyear; the later final filter also consumes prc. Its producer, history and schema are not supplied.
- R_IDIORISKFF [undetermined]: Prepared idioriskff dataset with qtrno2, permno and idioriskff, merged into finaldataset. Its producer, return/factor definition, identifiers and history are not supplied.
- R_BUSHEE_VARIABLES [undetermined]: Prepared bushee_variables dataset with year, qtr, permno, io_tra and io; the code derives qtrno2 and transientpct=io_tra/io before merging by qtrno2 and permno. Its construction and mapping are not supplied.
- R_FUND_TURNOVER_LTSTIO [undetermined]: Prepared fundturnover_ltstio dataset with year, qtr, permno, stio_fundturn and ltio_fundturn. The comment says these are calculated from fund turnover and institution holdings, but this source creates fundturnover_inst and stock_fundturnover, not fundturnover_ltstio.
- R_IBES_SUMMARY [undetermined]: IBES recommendation-summary input read as ibesrecosummary. The code uses cusip, statpers, meanrec and numrec, reverses the recommendation scale, and keeps the last statpers in each CUSIP-quarter; compatible IBES table, identifiers and history remain to be verified.
- R_EARNVOL [undetermined]: Prepared jointmz.earnvol input with cusip, fyear and earnvol. Its annual Compustat producer is absent. The appendix describes a five-fiscal-year standard deviation of deflated earnings with a minimum of three years. A readable North American annual-fundamentals candidate contains cusip, fyear, at and ib, but the producer, date coverage, earnings mapping and history remain unverified.
- R_HERDING [undetermined]: Prepared herdingmeasures_final2 input merged by qtrno2 and permno. The source does not state output measure names, construction, history or raw source mapping; no producer is supplied.
- R_RDSALE [undetermined]: Prepared rddata input with rdsale, cusip and fyear. The producer, fiscal-year matching and ratio definition are not supplied. A readable COMP.FUNDA candidate contains cusip, fyear, xrd and sale columns, but those underlying fields do not verify the prepared ratio or its construction.
- S_SAS [unverified]: SAS is required for the supplied DATA-step, PROC SORT, PROC MEANS and PROC RANK workflow. The frozen environment probe did not initialize SAS; this is unresolved runtime availability, not evidence of missing entitlement.

## Review notes

- This static assessment targets only the supplied SAS final-dataset construction program. The package does not supply a paper-wide regression or portfolio-analysis driver.
- The packaged CUSIP/year/qtr list is an identifier file, not a full analysis dataset. One-row catalog probes establish only sampled readability and column names; coverage, compatible history and prepared-input mappings remain unresolved.
- Direct CRSP, 13F and Compustat candidates remain unverified for this author workflow; TFN.S34 timed out on a bounded read, and exact catalog searches found no MEANREC/NUMREC recommendation-summary candidate.
- The required prepared-table producers, SAS library/workspace configuration and final-output handoff remain incomplete. SAS runtime availability remains unverified after the frozen TKELS startup failure.
- No source edits, author-code execution, estimator execution, dataset downloads or package installations occurred. Authored SAS KEEP/RENAME, filter, comment and chained-comparison semantics are preserved without repair proposals.
