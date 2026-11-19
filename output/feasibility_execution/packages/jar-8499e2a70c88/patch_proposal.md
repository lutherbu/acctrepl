# Patch proposal: jar-8499e2a70c88

Accounting for Goodwill

DOI: 10.1111/1475-679X.12618

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied R preparation, Julia notebook estimation, Julia block bootstrap, and R counterfactual/table workflow, including both DealStats link strategies.

Entry points: `execution_script.R`, `Code/EstimationNotebooks/main_estimation.ipynb`, `Code/EstimationNotebooks/split_estimation.ipynb`, `Code/Bootstrap/run_bootstraps.sh`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 63/Issue 3/12618 - Accounting-for-Goodwill/hm-datasheet-code-identifier-and-log-files.zip",
      "sha256": "57d90f0d67037e3123e33d307187787cde363893553a7c4bfe5f7a54b1280cff"
    },
    {
      "path": "JAR-Volume 63/Issue 3/12618 - Accounting-for-Goodwill/hm-online-appendix.pdf",
      "sha256": "d83c875c63713dbaf880998ea3d5a911a4f87d6c821128726394914530e2d7f1"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "06db97e62e4baa420e55eca57d749bad4c3409b58a55358fedb878d2d68fc7c0"
}
```

## Proposed actions

### A001: Resolve the source and schema contracts for both counterfactual parameter CSVs and the impairment ID before calling the full workflow closed.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I001, RQ017, RQ018
Evidence: S042, S069, S078, S085, S098, S101

Preparation / proposed procedure:

1. Ask the authors to identify the exact producer, output schema, parameter rows/columns and intended path for parameter_estimates_industry_variation.csv and parameter_estimates_ind_vary.csv.
2. Ask how the prepared 20221031 goodwill pull's ID field is constructed and how its source rows cover the required post-2001 impairment history.
3. Keep the two differently named parameter inputs separate unless the authors establish that they are the same product.

Validation to perform later:

- Trace each exact writer to each consumer and confirm field meaning, date/history and same-product identity without running author code.

### A002: Create one coherent case-sensitive project root and explicit file handoffs for all included stages.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I002
Evidence: S010, S028, S029, S038, S059, S060, S061, S098, S101, S103, S106

Preparation / proposed procedure:

1. Select a working root and map the README's Code/execution_script.R reference to the supplied root execution_script.R.
2. Normalize or stage Code/code, Data/data, and PPA/ppa paths consistently, including the documented absolute GM2015 location and the lowercase DealStats consumers.
3. Map each notebook-produced JLD object to its bootstrap consumer path and preserve the exact produced file bytes; do not substitute parameter CSVs for JLD results.
4. Retain each producer stage and both DealStats link strategies when preparing the run order.

Validation to perform later:

- Resolve every source/include and each producer-consumer pair under the selected root on a case-sensitive filesystem; verify identical logical product names and field contracts.

### A003: Obtain or author-confirm each separately required prepared acquisition/PPA/impairment input and its permitted access route.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: RQ001, RQ002, RQ003, RQ010, RQ013, RQ014, RQ015, RQ016
Evidence: S003, S004, S010, S024, S026, S032, S034, S036, S042, S031, S033, PR007, CAT001, INSP001

Preparation / proposed procedure:

1. Request the post-2012 deal_details file, pre-2013 gm2015 file and post-June-2001 cash-only acquisition file as separate inputs with their sample/identifier definitions.
2. Obtain the documented dated BVR DealStats export, manual PPA supplement, historical CRSP CIK/GVKEY linktable and WRDS SEC linktable through the authors' permitted delivery routes; confirm the manual supplement's file-name mapping.
3. Request the dated goodwill/impairment pull with its ID construction, source filters and prior-history definition; the COMP.FUNDA candidate is not a complete substitute until the ID mapping is specified.
4. Confirm local licenses/account access for commercial/WRDS sources; a catalog result or vendor name does not establish access or a restriction.

Validation to perform later:

- Confirm the delivered products contain the cited identifiers, date bounds and construction fields and preserve separate inputs and the two link strategies.

### A004: Stage the readable local Compustat/CRSP catalog products as same-product author inputs, with deterministic field-case and path conversion.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: RQ004, RQ005, RQ006, RQ007, RQ008
Evidence: PR002, PR003, PR004, PR005, PR006, CAT001, INSP001, S013, S014, S016, S021, S123, S124, S125, S126, S127, S128, S129, S130, S131, S132

Preparation / proposed procedure:

1. Use the exact catalog-listed COMP.FUNDQ, COMP.COMPANY, CRSP.CCMXPF_LINKTABLE, CRSP.DSF and CRSP.DSP500 products and the probed fields recorded on each requirement route.
2. Convert/stage the underlying same-product tables into the expected author paths and normalize CRSP DSF uppercase fields to the R-side names where required.
3. Preserve the quarterly lookback and the documented event-price/index windows; defer empirical coverage and original-vintage validation to the prepared run.

Validation to perform later:

- Check field names, key joins, date types, study-window coverage and lookback availability after staging, without a whole-data sweep during this audit.

### A005: Confirm exact metadata, readable object schemas and intended versions of the two separately used packaged SIC/FF12 crosswalks.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: RQ011, RQ012
Evidence: S022, S023, S039, S043

Preparation / proposed procedure:

1. Keep the Step1 SIC-range-to-industry crosswalk distinct from the Step2/Step3 ID/label table; use each only for its supplied construction role.
2. Obtain an ordinary compatible metadata or export route for the two packaged RDS objects before relying on their schema or coverage.

Validation to perform later:

- Confirm exact fields, types, mapping uniqueness and range/label coverage after an authorized compatible metadata/export step; do not infer these from source code or inventory alone.

### A006: Confirm the exact FRED/ALFRED series IDs, frequencies, date bounds, vintages and registration route used by the masked author requests.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: RQ009
Evidence: S017, S018, S019, S020, PUB001, PUB002, PUB003, PUB004, PUB005, PUB006, PUB007, PUB008

Preparation / proposed procedure:

1. Use the author's permitted FRED/ALFRED API or static distribution after mapping the exact requests to the candidate series; registration is a setup step.
2. Normalize dates/frequency according to the supplied rolling-GDP and date-join construction, preserving the stated series units and vintage policy.

Validation to perform later:

- Confirm each exact series ID/measure, units, frequency, date range, vintage and missing-date handling against the author source before acquiring values.

### A007: Verify the Julia runtime and imported Julia/R package set in an isolated project environment; install nothing during this assessment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW002, SW003
Evidence: S006, S096, S099, S113, S114, S115, PR001, PUB003

Preparation / proposed procedure:

1. Check whether Julia 1.6.3 and the required JLD2/CSV/Tables/Optim/Distributions packages plus the notebook kernel are available.
2. Check the R libraries imported by the supplied stages, including alfred and fixest; add only documented missing packages through the user's normal environment-management process.
3. Keep the registered R 4.5.0 status separate from the README's R 4.1.1 requirement and verify package compatibility without changing scientific definitions.

Validation to perform later:

- Record exact runtime/package versions and confirm the notebook/bootstrap entry points can resolve their required libraries before any author workflow is considered runnable.

### A008: Schedule the block bootstrap with an authorized compute allocation based on the authors' documented scale.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: I003
Evidence: S008, S102

Preparation / proposed procedure:

1. Reserve an appropriate multi-core allocation and plan the bootstrap/logging window; the README reports 60 cores for 18 hours or about 45 days on one core.
2. Run the two bootstrap stages only after the upstream notebook results and path handoffs are verified.

Validation to perform later:

- Confirm the allocated worker count, wall-time allowance, output paths and logs are ready before the separate authorized run.

### A009: Provide or document a compatible ts timestamp helper in the bootstrap shell PATH before the bootstrap stage.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW004
Evidence: PR011, S102

Preparation / proposed procedure:

1. Make ts resolve in the intended bootstrap shell environment or document an authorized compatible timestamping helper.
2. Record the helper path and version as metadata before any separate authorized bootstrap run.

Validation to perform later:

- Confirm PATH resolution and version metadata without passing study data to the helper or starting the bootstrap runner.


## Remaining issues and prerequisites

- I001 [unresolved; full_pipeline]: The full branch still has unresolved required input provenance/construction and parameter-file handoffs. In particular, two distinct counterfactual parameter CSVs have active consumers but no exact matching producer in the supplied stages; the impairment pull also requires a preconstructed ID. Keep the scope open until these contracts are confirmed.
- I002 [preparation; full_pipeline]: The documented root and packaged paths are not coherent as-is: code changes to a user download root, README names Code/execution_script.R while the supplied root is execution_script.R, active includes use both Code/code, PPA/Data directory case differs across producer/consumer paths, and Julia result objects are written/read under different relative directories. Resolve one consistent case-sensitive root and stage same-product handoffs without changing scientific definitions.
- I003 [preparation; full_pipeline]: The included block bootstrap is a material resource stage: the README reports 60 cores and 18 hours, with an estimated 45 days on one core. Plan an authorized compute allocation before running this branch.
- RQ001 [undetermined]: Post-2012 deal and bidder detail input read by Step1 as data/deal_details.RDS.
- RQ002 [undetermined]: Pre-2013 Gorbenko-Malenko bid detail/control input gm2015.RDS, which Step1 reads at a home-download path.
- RQ003 [undetermined]: Prepared cash-only acquisition list for 100% acquisitions, non-spinoffs, after June 2001; both link strategies consume it.
- RQ009 [undetermined]: FRED/ALFRED macroeconomic time series joined by date; the exact protected request IDs and full vintage/date contract remain unverified.
- RQ010 [undetermined]: Author-prepared annual goodwill/impairment pull 20221031_compustat_goodwill_pull.RDS, including the already-constructed industry ID.
- RQ011 [undetermined]: Step1 SIC-range to FF12 industry crosswalk ff_12ind.rds.
- RQ012 [undetermined]: Step2/Step3 industry-label crosswalk FF12_siccode_match.RDS.
- RQ013 [undetermined]: Dated BVR DealStats PPA export used to build transaction-level goodwill allocation fields.
- RQ014 [undetermined]: Separately hand-collected PPA supplement used when DealStats has no goodwill allocation.
- RQ015 [undetermined]: CRSP Compustat historical CIK/GVKEY company-history link CSV used in the DealStats match branch.
- RQ016 [undetermined]: WRDS SEC Analytics Suite CIK/GVKEY link CSV used as the second active DealStats matching strategy.
- RQ017 [undetermined]: Parameter estimates CSV parameter_estimates_industry_variation.csv consumed by counterfactuals 01 and 02.
- RQ018 [undetermined]: Separate parameter_estimates_ind_vary.csv consumed by counterfactual 03.
- SW002 [unverified]: README specifies Julia 1.6.3. No Julia availability proof appears in the registered environment record; source imports Distributions, CSV, Tables, Optim and JLD2. Runtime and package versions remain unverified.
- SW003 [unverified]: The code imports data.table, dplyr, readr, tidyr, stringr, glue, openxlsx, lubridate, purrr, dotenv, alfred, zoo, stringdist, ggplot2, xtable, foreach, scales, fixest and DBI. Their local availability is not established by the registered R runtime record.
- SW004 [preparation_required]: The bootstrap shell pipeline uses ts for timestamped output, but the bounded PATH check did not resolve an executable; no version could be reported. Provide or document an authorized compatible helper in the bootstrap PATH before that stage.

## Review notes

- Drafting progress: the full author-documented target, root R driver, initial data inventory, and sequential runtime handoff are recorded. The README's stated path Code/execution_script.R differs from the packaged root execution_script.R; reconcile actual path/case through source evidence. Input requirements and feasibility remain provisional pending source/dependency tracing.
- Checkpoint 002 supersedes the provisional aggregate RQ001/A001 mapping with 18 independent data requirements, 3 software records and a reviewed full_pipeline dependency set. RQ001 now refers only to deal_details.RDS; the earlier progress note described the prior provisional state.
- Screen-reader boundary metadata (opaque; no source/log/config bodies or raw report redisplayed): source Code/Step1/clean_deal_details_to_GM_format.R original SHA-256 9acb8ff89883cc8036cf14b9fc6fd6020c2464cfa563043116d13460dea55454; cached path reading/Code/Step1/clean_deal_details_to_GM_format.R.txt and cached SHA-256 9acb8ff89883cc8036cf14b9fc6fd6020c2464cfa563043116d13460dea55454. V1 reader probes/screen_cached_sources.py SHA-256 46d13419f6971553b49149af51a905ce59afda3b28b3e9a3fadc27887e5fd75d; v1 view probes/screened_sources/023_clean_deal_details_to_GM_format.R.redacted.txt SHA-256 9acb8ff89883cc8036cf14b9fc6fd6020c2464cfa563043116d13460dea55454 (no v1 withheld ranges); v1 report probes/screened_sources.json SHA-256 6c648224ed3e3d592deb7f7a9f8f10bebb2acc675c9485db03f64883055cf1f5.
- Second protected source Code/Utilities/fetchWRDS2.R original SHA-256 982adfde98ec72072b1f8d993e89d09079b2d259076deb10fbd3ef05f8246c49; cached path reading/Code/Utilities/fetchWRDS2.R.txt and cached SHA-256 982adfde98ec72072b1f8d993e89d09079b2d259076deb10fbd3ef05f8246c49. Its v1 view probes/screened_sources/036_fetchWRDS2.R.redacted.txt SHA-256 bd71dfb492dca5f31612e5111777813691bc6466f23639d9ae32722a83c07bdc withheld ranges [1,1] and [7,13].
- V2 reader probes/screen_cached_sources_v2.py SHA-256 244d33a46d9aa242c66835b57bc29b21f9630f43b54c9cdc8ba37c66f5643fef; report probes/screened_sources_v2.json SHA-256 cc6294548c4057a1ff1b2838d120dc312e88814fed4a188de228f6d9379157df (39 code sources screened, 17 candidate lines). Step1 v2 view probes/screened_sources_v2/023_clean_deal_details_to_GM_format.R.redacted.txt SHA-256 aabfb019b69819a81e8ca77d3e23deb06ef9ce30cdda37a30e3b279dcdb0c7ff, withheld ranges [37,40], [92,92], [105,105], [164,164], [227,229], [232,232], [242,242], [248,248], [254,254], [260,260]. fetchWRDS2 v2 view probes/screened_sources_v2/036_fetchWRDS2.R.redacted.txt SHA-256 df68f5fe872fc45e19eaac01e5f6799b1f1d46a79b30fc91c1a0571f3ca59450, withheld ranges [1,1], [6,13], [16,16], [24,25]. The known earliest previously displayed source location was Code/Step1/clean_deal_details_to_GM_format.R:37; no line content is repeated. Preserve v1 bytes/views opaquely and retain the reported boundary limit. No security/access/execution finding is inferred from SQL/request content; source presence and review limitation remain distinct.
- Catalog file SHA-256 4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27 and embedded catalog text hash 458948bcaae160ebf8b967bc8eaa1ee160f739c29471256a02d34ccaf12583c6 are distinct identifiers. Selected candidates/probes establish catalog product/field readability only; one-row results do not verify population or empirical coverage. RDS crosswalk reader status remains unverified; no RDS was loaded.
- The registered environment source remains probes/environment.json SHA-256 52959efae1466c6707313ccb7b9cce434882f91442b0e9c3ae6684b8a7182f00. Its fixed safe projection reports R 4.5.0; Julia is not verified; projection output is not substituted for original probe evidence.
- The packaged identifiers/identifiers.csv probe is a one-row identifier list only and does not satisfy an analysis-data requirement. Commercial/WRDS routes remain unverified where agreement or current-access evidence is absent; catalog misses are not treated as access barriers. Bounded handling note: an earlier v1-view inspection displayed some SQL/API request statements from Code/Step1; the earliest known source location is recorded above without line content. A separate command unintentionally displayed the first 65 lines of the cached package log at reading/logfiles/data_cleaning_preparation.txt.txt. No credential content was reported in the recorded display; that is a bounded report of the visible output, not an independent certification of absence. The displayed output was not separately saved as an artifact, so its capture path/hash are unknown/missing. S129 cites visible, static product-selection SQL text outside the declared v2 withheld ranges; no cited source quote intersects a declared withheld range. No query was executed, and S129 does not establish access. Raw-log content and log-derived facts are not cited or used as scientific evidence. Preserve the original log and v1 artifacts opaquely; do not redisplay their bodies. No successful access or execution is inferred.
- Crosswalk method limit: the frozen inventory records both packaged paths, while the prior bounded metadata-reader attempts remain retained as unused audit artifacts. No RDS was read or retried in this correction. Exact RDS metadata, readability, types and empirical coverage remain unverified; no absence or unusability claim is inferred.
- Bootstrap helper metadata: PATH-only lookup did not resolve ts, so no version was reported. The shell source requires ts for timestamped pipeline output; this remains a preparation prerequisite. No bootstrap data or runner was invoked.
