# Patch proposal: jar-65162abb4ac7

How Common Are Intentional GAAP Violations? Estimates from a Dynamic Model

DOI: 10.1111/1475-679X.12190

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | blocked |
| analysis_only | local_available | blocked |

### full_pipeline

Complete documented raw preparation and build of normalized revenue-recognition-error data, then SMM estimation, implied-manipulation inference and R table compilation. The paper package’s raw preparation is explicitly illustrative and its full source-data construction is not closed.

Entry points: `Datasheet and code/data_processing.Rmd`, `Datasheet and code/snippet_data/snippet_tranches.sas`, `Datasheet and code/snippet_data/snippet_bs_input.sas`, `Datasheet and code/snippet_data/snippet_delta.sas`, `Datasheet and code/snippet_data/snippet_mu_sigma.sas`, `Datasheet and code/snippet_data/restatement_impact_span.sql`, `Datasheet and code/snippet_data/get_price_function.py`, `Datasheet and code/estimate_model/estimateParams.m`, `Datasheet and code/implied_manip/invertPrice.m`, `Datasheet and code/knit_tables/note_on_estimates.Rmd`

Dependency closure: unresolved; see the issues and actions below.

### analysis_only

Use the supplied author-prepared normalized dataparam MAT and value weights to rerun the revenue-recognition SMM, create the gmmobjres solution, invert model-implied manipulation to CSV, then compile the supported parameter table and pooled Table 8 subset. The packaged SMM-result MAT and manipulation CSV also let the R table branch consume reference outputs directly. Supported outputs are Table 4 parameter estimates and pooled 2003–2010 incidence/value-weighted stock-price bias; withheld identities, years and adjustment factors prevent broader Table 8 outputs.

Entry points: `Datasheet and code/estimate_model/estimateParams.m`, `Datasheet and code/implied_manip/invertPrice.m`, `Datasheet and code/knit_tables/note_on_estimates.Rmd`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 1/12190 - How-Common-Are-Intentional-GAAP-Violations-Estimates-from-a-Dynamic-Model/zakolyukina-datasheet-and-code.zip",
      "sha256": "7dc19e6f9bf0282e664f91dc158101bb4a20640580f3c99129ef7f7d47825e6c"
    },
    {
      "path": "JAR-Volume 56/Issue 1/12190 - How-Common-Are-Intentional-GAAP-Violations-Estimates-from-a-Dynamic-Model/zakolyukina-online-appendix.pdf",
      "sha256": "837b0ae6b437edb61887a995bf1df1836652b919454f25b0301eaf819ee0d591"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "ab011260dad9f69a58c3dfd0971bdcf0f1c938d7447c5e95ba705d7188b7eef6",
  "work_item_sha256": "0ba9da94acf406c56d6d7e26b61b4befeed3cb1a212fd287aec51a429a0e1a77"
}
```

## Proposed actions

### A_FIX_MOMENT_CLEANUP: Propose correcting the NaN cleanup target so the matrix actually used by the manipulation-history and five-period filter is cleaned before the reverse cumulative sum. This is a one-line proposal only; the source file remains unchanged.

Scopes: full_pipeline, analysis_only. Type: source_edit. Certainty: supported.
Addresses: I_MOMENT_CLEANUP
Evidence: E014, E015

**Proposed edit:** `Datasheet and code/estimate_model/momentsSim.m:57–57`
Source SHA-256: `cf9d6cf01254d9c936d28a2b1eaaad9646fe1e20e09dd55b55455ffc155ef454`

The subsequent history and reverse five-period filter use nmanip_temp; vectsim marks post-follow-up cells NaN.

Current text:
```
nmnaip_temp(isnan(nmanip_temp)) = 0;
```

Proposed replacement:
```
nmanip_temp(isnan(nmanip_temp)) = 0;
```

Preparation / proposed procedure:

1. Apply the proposed one-line change only after authorization to edit/run the author model.

Validation to perform later:

- In a later authorized estimation run, confirm NaNs in nmanip_temp are replaced before cumsum(fliplr(nmanip_temp)) and confirm the source’s last-five-period filter still applies.

### A_ACQUIRE_EQUILAR: Obtain the authorized Equilar executive-compensation inputs required by the author’s documented 2010-12-31 source workflow, including equity and option detail.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_EQUILAR
Evidence: E001, E007, E020

Preparation / proposed procedure:

1. Record the authorized Equilar source files, identifiers, date coverage and fields used for executive compensation, holdings and grants.
2. Use the author’s supplied R cleaning/linking workflow once obtained; do not infer missing identifiers or fabricate source rows.

Validation to perform later:

- Check that the authorized source fields match the supplied SAS/R transformations and cover the documented executive dates.

### A_ACQUIRE_AUDIT_ANALYTICS: Obtain the authorized Audit Analytics Advanced Restatement Feed 39 notification, periods and filings tables for the documented SQL construction.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_AUDIT_FEED39
Evidence: E001, E018, E029, E030

Preparation / proposed procedure:

1. Identify the authorized Feed 39 delivery/schema for feed39_aaer24, feed39_restatement_periods and feed39_restatement_filings.
2. Document period coverage and the fields used by the SQL builder; no tables were downloaded or queried for values in this assessment.

Validation to perform later:

- After authorized read-only setup, confirm each table’s required schema and target restatement coverage before the author SQL is run.

### A_LINK_COMPANY_IDENTIFIERS: Resolve the author’s complete company-link construction and exact data mappings for Equilar, Compustat names/company, CCM and historical CIK links.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_COMP_NAMES, R_COMPANY_CIK, R_CRSP_CCM, R_SEC_CIK_LINK, I_UNRESOLVED_PRODUCERS
Evidence: E007, E008, E021

Preparation / proposed procedure:

1. Obtain the executable author R/manual-link stage and its review decisions for CUSIP, ticker/date, name/date and GVKEY links.
2. Specify exact table/library aliases and historical CIK-link fields, including the role of COMP.NAMES, COMP.COMPANY and CCM.
3. Preserve manual verification rules and document date validity for every link.

Validation to perform later:

- Statically trace the completed link outputs into the Equity/BoardEx and restatement merges, confirming identifier and validity-date fields without changing the target sample.

### A_VERIFY_BOARDEx: Confirm the BoardEx table and role-date fields that implement the author’s CEO left-date requirement; the locally readable candidate is not asserted equivalent to the author-selected input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_BOARDEx, I_RAW_PREPARATION
Evidence: E008, P_BOARDEx_CANDIDATE, C_BOARDEx

Preparation / proposed procedure:

1. Obtain the author’s exact BoardEx table/version, company/person link keys, and mapping from source dates to CEO left_date.
2. Confirm the source coverage for the Equilar CEO sample and preserve the author’s widest-interval date rules.

Validation to perform later:

- Confirm the selected fields supply company/person identifiers, start/end/left dates and coverage required by the documented merge.

### A_VERIFY_CRSP_HISTORY: Resolve exact local/WRDS CRSP tables and aliases and verify the historical windows needed by the author’s market, option and intrinsic-price preparation.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_CRSP_CCM, R_CRSP_MSF, R_CRSP_DSF, R_CRSP_DIVIDENDS, R_CRSP_EXCHDATES, R_CRSP_INDEX, R_CRSP_TREASURY, SW_SAS_WRDS, I_UNRESOLVED_PRODUCERS
Evidence: E021, E022, E025, P_CRSP_MSF, P_CRSP_DSF, P_CCM_LINK, C_CRSP_MSF, C_CRSP_DSF, C_CCM_LINK

Preparation / proposed procedure:

1. Map the local one-row candidates to the author’s remote and local SAS librefs; do not assume a catalog candidate matches a WRDS alias.
2. Verify full historical coverage for the 36-month daily-return window, prior-12-month distributions, 30-day dividend-price match, monthly base/date/fiscal-year prices, and the 1999-onward beta/volatility history implied by the 2002-08 start minus three years.
3. Resolve the local/remote T-bill table naming and document whether `mylib.t_bill` and `mycrsp.t_bill` refer to the same source.

Validation to perform later:

- After access and setup are established, check exact field names and date coverage for each source table with bounded metadata/history summaries; do not infer complete coverage from the one-row probes.

### A_VERIFY_POSTGRES_METADATA: Recheck only the exact source-named PostgreSQL metadata tables after an authorized read-only connection is available; the current socket error proves neither presence nor absence.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_AUDIT_FEED39, R_CRSP_XPF, SW_POSTGRES
Evidence: E018, E019, P_POSTGRES_META

Preparation / proposed procedure:

1. Use an authorized read-only connection to inspect information_schema for the three Feed 39 source tables and struct_manip.crsp_xpf/price_function only.
2. Preserve the exact current OperationalError and do not infer that the schemas or tables are missing.

Validation to perform later:

- Confirm the exact columns against the SQL/Python source requirements and record the database name separately from the schema/table names.

### A_RESOLVE_CRSP_XPF_PRODUCER: Obtain the missing producer and complete setup for struct_manip.crsp_xpf before the Python price-function branch can be considered closed.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CRSP_XPF, I_UNRESOLVED_PRODUCERS
Evidence: E009, E019, E031, P_POSTGRES_META

Preparation / proposed procedure:

1. Ask for the author’s exact source table producer, field construction, units, fiscal-year dates, GICS groups and history for ggroup/fyear/prc_adj/ibps/bps.
2. Confirm the generated struct_manip.price_function table and its columns and link it into the normalized final-data path only as the author specifies.

Validation to perform later:

- Trace the producer output into the price-function/price-process variables and confirm its stated date and industry-group coverage.

### A_PREPARE_R_TABLES: Prepare the R PDF toolchain required by the author’s note; package installation was not performed.

Scopes: full_pipeline, analysis_only. Type: software_setup. Certainty: supported.
Addresses: SW_R_TABLE_TOOLCHAIN
Evidence: E005, E017, E032, P_RUNTIME

Preparation / proposed procedure:

1. Install or configure the R packages xtable, R.matlab, dplyr, psych, knitr and rmarkdown in the intended R 4.5.0 environment.
2. Make Pandoc available to rmarkdown; pdflatex is already on PATH.

Validation to perform later:

- Confirm required package versions and Pandoc availability, then compile from the knit_tables working directory and verify note_on_estimates.pdf.

### A_VERIFY_MATLAB: Verify a MATLAB environment compatible with the author’s R2015b code, optimization/parallel functions and bundled Linux x86-64 MEX. The PATH check did not establish whether MATLAB is installed elsewhere or licensed.

Scopes: full_pipeline, analysis_only. Type: clarification. Certainty: conditional.
Addresses: SW_MATLAB
Evidence: E003, E013, P_RUNTIME

Preparation / proposed procedure:

1. Confirm the intended MATLAB installation/version, availability of patternsearch and the parallel-pool APIs, and compatibility of nakeinterp1m.mexa64.
2. If the intended runtime is elsewhere, document its path; do not infer an absent license from the PATH result.

Validation to perform later:

- Use a later minimal version/which/MEX-load compatibility check without running the author model until the source-logic issue is resolved.

### A_VERIFY_SAS_WRDS: Confirm the author’s SAS startup mode, WRDS remote SIGNON setup and local library/macro definitions after the recorded startup failure; no retry was made in this assessment.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: SW_SAS_WRDS, I_UNRESOLVED_PRODUCERS
Evidence: E020, E021, E022, P_ENVIRONMENT

Preparation / proposed procedure:

1. Identify the intended noninteractive SAS startup configuration and exact WRDS credentials/configuration from the author project setup.
2. Document local aliases for equilar, biglib, struct, mylib and mycrsp, macro definitions such as idvars, and remote WRDS library paths.

Validation to perform later:

- In a later authorized setup review, confirm the session and aliases without running author data programs.

### A_CLARIFY_PYTHON_APIS: Resolve the legacy Python API incompatibilities in the illustrative price-function snippet through author-supported runtime/revision information before any later full-preparation run.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I_PYTHON_API_COMPAT
Evidence: E006, E009, E019, E031, P_RUNTIME

Preparation / proposed procedure:

1. Request the author-supported Python/pandas/SQLAlchemy versions or a compatible source revision for itertools.izip, DataFrame.ix and Engine.execute.
2. Do not infer substitutions or alter the regression/data-construction logic during this audit.

Validation to perform later:

- Statically confirm the documented interpreter exposes every invoked API and database driver before a later authorized run.

### A_RUN_ANALYSIS_ORDER: After the moment-cleanup proposal is approved and MATLAB/R requirements are prepared, follow the author’s analysis order from the supplied final data through the table outputs. The current bundled SMM/manipulation files are reference outputs and can feed the R note directly.

Scopes: analysis_only. Type: run_procedure. Certainty: supported.
Addresses: R_FINAL_DATA, R_SMM_REFERENCE, R_MANIP_REFERENCE, R_VALUE_WEIGHTS
Evidence: E012, E013, E004, E016, E017, E032, P_FINAL_DATA, P_SMM_OUTPUT, P_MANIP_OUTPUT, P_VALUE_WEIGHTS

Preparation / proposed procedure:

1. From estimate_model, run the README script calling estimateParams(111,1000); this writes smm_solutions/smm_revenue_wtenure_erc_delta0.9_wealth1.mat and gmmobjres_files/gmmobjres_revenue_wtenure_erc_delta0.9_wealth1.mat.
2. From implied_manip, load that generated gmmobjres MAT, run invertPrice, and write csv/manip_revenue_wtenure_erc_delta0.9_wealth1.csv with the documented header.
3. From knit_tables, compile note_on_estimates.Rmd to note_on_estimates.pdf using the SMM result, manipulation CSV and data_joar_value_weights.csv.

Validation to perform later:

- Check the named output paths and expected SMM variables, manipulation CSV columns and value-weight join keys; the supported paper outputs remain Table 4 and the pooled Table 8 subset only.


## Remaining issues and prerequisites

- I_MOMENT_CLEANUP [blocking; full_pipeline, analysis_only]: In momentsSim.m, line 57 assigns zeros to `nmnaip_temp` using an `isnan(nmanip_temp)` mask, leaving the intended `nmanip_temp` matrix unchanged. Lines 58–61 build the manipulation history and reverse five-period cumulative filter from `nmanip_temp`; vectsim.m places NaNs outside follow-up, so those NaNs can propagate through the reverse cumulative sum and prevent the stated last-five-period restriction from trimming the history. The spelling alone does not create an undefined-variable crash in MATLAB; the supported finding is ineffective cleanup of the matrix later used.
- I_RAW_PREPARATION [unresolved; full_pipeline]: The author explicitly says the SAS preprocessing snippets cannot run as supplied and are illustrative. The documented raw-to-final workflow also requires R import/clean/merge, manual identifier verification, Equilar/BoardEx executive matching, restatement-to-executive merging and normalization for which no complete runnable driver is supplied. This is separate from the prepared-data analysis route.
- I_UNRESOLVED_PRODUCERS [unresolved; full_pipeline]: The full-preparation code does not supply producers for `equilar.equilar_gvkey_link` or `struct_manip.crsp_xpf`, and leaves setup/aliases such as `equilar`, `biglib`, `struct`, `mylib` and `mycrsp` unresolved. The BS snippet writes `mylib.t_bill`, while the intrinsic-price snippet reads `mycrsp.t_bill`; no included mapping establishes those as the same table. The commented `&idvars` note does not define the macro. Retain these setup/producer mappings as unknown rather than reconstructing them.
- I_PYTHON_API_COMPAT [unresolved; full_pipeline]: The illustrative get_price_function.py uses Python 2 `itertools.izip`, pandas DataFrame `.ix`, and SQLAlchemy Engine `.execute`; the Python 3.12 / pandas 3.0.6 / SQLAlchemy 2.1.3 probe shows those APIs are absent. The author labels the preparation snippets as not runnable as-is, and no supported Python version or corrected script is documented. This issue affects only the raw-preparation branch, not the supplied MATLAB analysis route.
- R_EQUILAR [undetermined]: Author-described Equilar executive compensation data as of 2010-12-31, including equity holdings, option grants, CEO identity and company/date fields, used to produce normalized compensation inputs.
- R_AUDIT_FEED39 [undetermined]: Audit Analytics Advanced Restatement Feed 39 tables `feed39_aaer24`, `feed39_restatement_periods`, and `feed39_restatement_filings`, jointly read by the SQL restatement builder.
- R_COMP_NAMES [undetermined]: Compustat names/history used to link Equilar company identifiers through historical CUSIP or company-name matches.
- R_COMPANY_CIK [undetermined]: Compustat company file used as the author’s fallback header CIK link by GVKEY.
- R_CRSP_CCM [undetermined]: Historical Compustat–CRSP link intervals used to map GVKEY to PERMNO at the executive data dates.
- R_CRSP_MSF [undetermined]: CRSP monthly stock observations used for sample-start prices and fiscal-year/base-date prices, with adjustment factors.
- R_CRSP_DSF [undetermined]: CRSP daily stock prices and returns used to price dividend events and calculate historical volatility.
- R_CRSP_DIVIDENDS [undetermined]: CRSP distribution events used to obtain dividend amounts/pay dates for option valuation.
- R_CRSP_EXCHDATES [undetermined]: CRSP exchange-history table used to define the listed-company universe.
- R_CRSP_INDEX [undetermined]: CRSP index beta/volatility and market-return inputs: DPORT6–DPORT9 and ASIC/ASIO series used jointly to build the intrinsic price-process parameters.
- R_CRSP_TREASURY [undetermined]: CRSP monthly fixed-term treasury yields used to create risk-free rates for Black–Scholes and intrinsic-price calculations.
- R_BOARDEx [undetermined]: BoardEx director/employment history used with Equilar to identify CEO role start, resignation and company-left dates.
- R_SEC_CIK_LINK [undetermined]: Historical CIK link records from WRDS SEC filings, used with GVKEY to connect Equilar companies to restatement companies.
- R_CRSP_XPF [undetermined]: `struct_manip.crsp_xpf` price-function input read by get_price_function.py before it writes the generated price_function output.
- SW_MATLAB [unverified]: Author requests MATLAB R2015b and the estimator uses patternsearch, parcluster/parpool/gcp and a bundled x86-64 MEX; no MATLAB or Octave command was found on PATH, which does not establish installation/licensing elsewhere.
- SW_R_TABLE_TOOLCHAIN [preparation_required]: The R note directly loads xtable, R.matlab, dplyr and psych and needs the R Markdown/knitr PDF pipeline; the runtime probe found these packages and Pandoc unavailable. pdflatex is present.
- SW_SAS_WRDS [unverified]: The preprocessing snippets require local SAS, remote WRDS SIGNON/Rsubmit, CRSP library paths and author macro/library setup. The frozen SAS startup probe failed with the recorded TKELS Launch Service Load Failure; no retry was made and remote access remains unverified.
- SW_POSTGRES [unverified]: The author SQL/Python sources expect PostgreSQL schemas. `psql` is present, but the exact read-only metadata probe was denied by the sandbox socket boundary; table presence and database access remain unknown.

## Review notes

- The frozen author variant is the revenue-recognition-errors release. The supplied final MAT and value-weight file support a distinct prepared-data analysis scope; historical source collection is not made mandatory there.
- Execution order for the analysis route is estimateParams.m loading dataparam -> patternsearch/SMM saving smm_*.mat and gmmobjres_*.mat -> invertPrice.m loading gmmobjres and writing manip_*.csv -> note_on_estimates.Rmd reading the SMM result, manipulation CSV and value weights.
- The SMM result MAT and manipulation CSV in the package are reference outputs, not evidence that the local estimator/inversion ran. A direct R table build from them is narrower than regeneration of the model outputs.
- The author’s documented Table 8 reproduction is limited to pooled 2003–2010 incidence and value-weighted stock-price bias; withheld identifiers, years and adjustment factors prevent broader company/year outputs.
- For raw preparation, the SAS source uses filters such as MSF date>=2002-08, DPORT years>=1999, normalized index year(date)<2011, exchange end dates>=2007-12-31 and treasury datadate>1980; those source filters are reported separately from the explicit 36-month daily-return, prior-12-month dividend and 30-day pre-pay-date construction windows. End coverage and any additional nested history remain unverified.
- The one-row SAS probes establish readability and selected fields only. The BoardEx candidate is not treated as the author alias, and catalog misses/metadata connection errors do not establish absent data or licensing.
- The frozen dependency checklist has 51 read edges; every item is separately classified below as a generated SAS intermediate, a raw source requirement, or an unresolved producer/setup issue.
