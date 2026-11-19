# Patch proposal: jar-aed9625d06ef

Copycat Skills and Disclosure Costs: Evidence from Peer Companies’ Digital Footprints

DOI: 10.1111/1475-679X.12369

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

All three supplied SAS entry programs and their documented preparation branches, with baseline viewing/13F results staged before the later AbelNoser branch replaces same-named WORK tables. The unprovided Stata regression drivers mentioned by the datasheet remain contextual.

Entry points: `CDYZ_Copycat_CopycattingActivity.sas`, `CDYZ_Copycat_StockPerformance.sas`, `CDYZ_Copycat_FilerCost.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 4/12369 - Copycat-Skills-and-Disclosure-Costs-Evidence-from-Peer-Companies-Digital-Footprints/cdyz-datasheet-code-and-identifiers.zip",
      "sha256": "070bc653f682b235d58ab37e4a67542816f2232f2bfa8f0eac673e798a8c4925"
    },
    {
      "path": "JAR-Volume 59/Issue 4/12369 - Copycat-Skills-and-Disclosure-Costs-Evidence-from-Peer-Companies-Digital-Footprints/cdyz-online-appendix.pdf",
      "sha256": "717b7fe2795fe66e8634b86eb274c4ae0a0785bb3173a87b2124d8d845296d72"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "bcba31606efb662da0a12b2049ae588d2a3bd69a16e867d004df9944df36816e"
}
```

## Proposed actions

### A001: Prepare a coherent native SAS staging root and execute the supplied branches in producer-consumer order, retaining baseline WORK outputs before the Table 10 pass overwrites the same names.

Scopes: full_pipeline. Type: configuration. Certainty: supported.
Addresses: I001, I003, I008
Evidence: E004, E005, E009, E014, E023, E024, E025, E026, E027, E028, E029, E044, E045, E046, E047, E048, E049, E050, E052, E054, E055

Preparation / proposed procedure:

1. Stage the exact packaged viewing and research-intensity inputs in the writable COPYCAT project library; keep shared CRSP and TFN sources read-only.
2. Run the baseline CopycattingActivity/Table 3 segment to create copy12, baseline WORK.FB12/LS12, Trades, Holdings, Price, and durable COPYCAT.COPYCAT_FB/LS. Run StockPerformance with those baseline WORK tables still present. Run FilerCost only after the A005 QRET-to-return-field contract is resolved and its other unresolved requirements are addressed.
3. Run the supplied FB/LS sophisticated and naive focal_group/save_as settings and high/low research-intensity settings before their final comparisons consume the group outputs. Repeat the Table 4 procedure with ROBOT in place of DOWNLOAD for Table 11 Panel B.
4. Before Table 10, execute the source-backed repeat of the Thomson/CRSP Part 1 preparation using 1 March 2002–31 December 2012 dates, then run the AbelNoser branch using its separate activity/transaction inputs; a macro change alone does not rebuild the Part 1 WORK tables. Do not pass its overwritten manager-key WORK.FB12/LS12 to baseline StockPerformance.
5. Set BEG_YEAR=2001 and END_YEAR=2017 in the FilerCost session configuration, matching the explicit source window while retaining the source's existing partial rolling means.

Validation to perform later:

- Before a separately authorized execution, confirm the chosen root is writable, source-library datasets are visible, and every WORK/durable handoff retains the expected columns.

### A002: Verify supported local or licensed routes and exact fields/population/history for CRSP, Thomson 13F, matched hedge-fund returns, confidentiality, and AbelNoser inputs. TFN.S34 is a timed-out catalog candidate, not a verified substitute for S34TYPE1/3; no catalog miss or nonredistribution statement proves an access barrier.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R003, R004, R005, R006, R007, R008, R009, R010, R011, R012, R013, R014, R015, I002
Evidence: E006, E008, E009, E010, E011, E013, E030, E031, E032, E033, E034, E035, E036, E037, E038, E039

Preparation / proposed procedure:

1. Reconcile the frozen catalog and existing bounded probes with each exact consumed SAS table and the named source fields.
2. For each remaining unresolved route, establish population, identifiers, report/quarter dates and construction history before treating it as verified or blocked.
3. Compare the catalog-listed TFN.S34 product with the two distinct S34TYPE1/3 input roles and treat TASS tables as conditional source candidates only; no documented raw-to-matched_companyret construction is supplied.
4. Use the successful exact CRSP/FF one-row reads as local field/readability evidence only; verify source history and population for the dated consumers. The TFN.S34 read timed out at 15 seconds, so retain that candidate as unresolved without retry or an access-barrier claim.

Validation to perform later:

- Use bounded metadata/readability checks only; do not run author code or infer license denial from a catalog miss or nonredistribution statement.

### A003: Correct the baseline last-sell sort key to the generated FILER variable before a future authorized run.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I004
Evidence: E012

**Proposed edit:** `CDYZ_Copycat_CopycattingActivity.sas:387–387`
Source SHA-256: `471163124068fdee53aa21d117af44067e7213599747943c908b260883b338b9`

The LSF1 producer and adjacent sorts use FILER/DOWNLOADER; FILE is not generated in the supplied schema.

Current text:
```
by rdate file downloader; run;
```

Proposed replacement:
```
by rdate filer downloader; run;
```

Preparation / proposed procedure:

1. Apply this one-line correction in a working copy after the project root is configured.

Validation to perform later:

- Inspect the changed line and adjacent sort keys statically; do not compile or execute the author program during this assessment.

### A004: Confirm a usable native SAS batch runtime and its required export support through approved host runtime support; the inherited startup failure does not justify an entitlement conclusion.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW001, SW002, I005
Evidence: E017, E018

Preparation / proposed procedure:

1. Resolve the recorded TKELS launch-service initialization failure outside this audit and verify SAS execution plus PROC EXPORT DBMS=STATA/DTA support before any data run.

Validation to perform later:

- After separate authorization, use a self-written empty-session software check only; do not run the supplied research programs as a software test.

### A005: Resolve the field/measure contract between StockPerformance and FilerCost before running the copycat-sophistication branch.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I006
Evidence: E019, E020

Preparation / proposed procedure:

1. Obtain the intended QRET definition or an author-approved mapping from the produced FB_RET/LS_RET fields; do not select or combine the series by assumption.
2. Update the working copy only after the intended construct is specified, then statically confirm the generated and consumed column names.

Validation to perform later:

- After separate execution authorization and data access, compare the resulting downloader return columns with the clarified consumer contract.

### A006: Resolve the Holdings.VALUE reference in the supplied weights output stage without guessing a value definition.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I007
Evidence: E021, E022

Preparation / proposed procedure:

1. Ask the authors to specify the intended native holding-value field/formula or confirm that the unconsumed WORK.WEIGHTS output is not required in their workflow.
2. Do not replace VALUE with shares_adj multiplied by price or remove the stage until that interpretation is supported.

Validation to perform later:

- Once specified, statically compare the chosen field with the supplied Holdings schema and check all downstream consumers before a future authorized run.


## Remaining issues and prerequisites

- I001 [preparation; full_pipeline]: The main file reuses WORK names across baseline and AbelNoser passes. Preserve/interleave baseline FB12/LS12 and Trades/Holdings/Price for StockPerformance and FilerCost before the supported Table 10 repeat of the Thomson/CRSP preparation overwrites those WORK objects.
- I002 [unresolved; full_pipeline]: The supplied Table 10 branch consumes branch-specific AbelNoser activity and trade tables; a compatible source and the field/history contract have not yet been established.
- I003 [preparation; full_pipeline]: SAS library roots, a writable COPYCAT staging/output location, export paths and date macros need coherent working-directory configuration; WRDS-specific defaults in comments are not evidence that a remote service is mandatory.
- I004 [preparation; full_pipeline]: The baseline last-sell sort uses FILE although its generated dataset and surrounding sorts use FILER; verify and apply the minimal source-backed key correction before any future authorized run.
- I005 [unresolved; full_pipeline]: The inherited SAS batch startup failed while initializing TKELS; this does not establish a missing license or unavailable entitlement, and the frozen work item prohibits another SAS startup/retry. Usable SAS runtime and the required DBMS=STATA/DTA export capability therefore remain unverified.
- I006 [unresolved; full_pipeline]: FilerCost requests QRET from downloader_FBLS_ret, but StockPerformance creates that table with FB_RET and LS_RET. The intended sophistication score/field mapping is not stated; do not choose one return series or combine them without author specification.
- I007 [unresolved; full_pipeline]: The supplied Holdings producer does not create VALUE, while FilerCost selects HOLDINGS.VALUE when creating WORK.WEIGHTS. No later WEIGHTS consumer is visible in the supplied programs. Preserve this output stage and clarify the intended field or whether the unused stage is intentionally run; do not invent a value formula or silently drop it.
- I008 [preparation; full_pipeline]: FilerCost uses BEG_YEAR and END_YEAR for its CRSP daily reads without defining them in that file. Configure them consistently with the supplied 2001–2017 source window while preserving the stated partial prior-quarter averages; do not infer a requirement for a complete 8- or 12-quarter history.
- R003 [undetermined]: CRSP monthly stock and corporate-action observations used to build quarterly holdings prices/returns and portfolio performance.
- R004 [undetermined]: Thomson 13F s34type1 report/vintage metadata used to identify first and last reports.
- R005 [undetermined]: Thomson 13F s34type3 security/share holdings used to derive trades.
- R006 [undetermined]: CRSP historical name/security link used to map CUSIPs to PERMNOs.
- R007 [undetermined]: CRSP daily security/event table used to select common stocks for the liquidity branch.
- R008 [undetermined]: CRSP daily stock table used to construct the bid-ask spread measure.
- R009 [undetermined]: Monthly Fama-French-Carhart factor table merged into portfolio outputs.
- R010 [undetermined]: Hedge-fund manager-number crosswalk used by the Table 9 Panel A branch.
- R011 [undetermined]: Confidential-treatment filer/date intervals used in both supplied FilerCost and CopycattingActivity analyses.
- R012 [undetermined]: Monthly matched hedge-fund company-return panel used in the FilerCost analyses.
- R013 [undetermined]: AbelNoser viewer-filer-quarter activity panel required by the supplied Table 10 branch.
- R014 [undetermined]: AbelNoser downloader transaction/sign fields used in Table 10 first-buy and last-sell classification.
- R015 [undetermined]: AbelNoser filer-downloader transaction validation table used in Table 10.
- SW001 [unverified]: The three entry programs use DATA steps, PROC SQL, SORT, APPEND, RANK, TRANSPOSE and EXPORT. The inherited SAS batch command failed at TKELS initialization; usable runtime, procedure components and entitlement are not established.
- SW002 [unverified]: The supplied SAS code uses PROC EXPORT with DBMS=STATA and DBMS=DTA. Availability of the required SAS export engine is unverified; no separate Stata estimation driver is supplied in this package.

## Review notes

- All three supplied SAS programs, the complete datasheet/appendix, and all 17 frozen dependency IDs were reviewed. The frozen catalog and six bounded SAS metadata probes are cited in the assessment; the five successful probes read one row each and do not establish population or historical coverage. The TFN.S34 candidate probe timed out at 15 seconds and was not retried.
- The packaged viewer_filer_qtr and research_intensity inputs are exact author-prepared routes with readable matching fields. Their bounded probes do not prove full coverage; no separate full sweep is required solely to recognize these routes. The XLSX files are company identifier lists, not full panels or consumed inputs. Historical EDGAR logs and WHOIS are not additional mandatory inputs for the supplied prepared viewer_filer_qtr consumer.
- Baseline COPYCAT.COPYCAT_FB/LS are produced by CopycattingActivity and feed COPY12; baseline WORK.FB12/LS12 feed StockPerformance. StockPerformance creates downloader_FBLS_ret with FB_RET and LS_RET, while FilerCost requests QRET. Later AbelNoser code overwrites WORK.FB12/LS12 with manager-key schemas and produces distinct durable Table 10 outputs. The workflow trace preserves these separate handoffs.
- Table 10 explicitly calls for repeating the earlier Thomson/CRSP Part 1 with the 2002–2012 dates. The documented repeat is a supported preparation recipe; changing macros alone is insufficient. StockPerformance also documents sophisticated/naive, high/low research-intensity, and Table 11B ROBOT runs.
- Specific unresolved source contracts remain: FilerCost requests QRET although its supplied producer emits FB_RET/LS_RET, and FilerCost selects HOLDINGS.VALUE although the supplied Holdings producer creates SHARES_ADJ. No WEIGHTS consumer is visible. The FILE-to-FILER baseline sort correction, WRDS path setup, and BEG_YEAR/END_YEAR settings are source-backed preparation actions.
- The SAS TKELS startup failure is inherited evidence; no retry, author-code execution, estimator execution, install, download, or source edit occurred. Stata regression drivers are described but unprovided and remain contextual. Commercial-source comments do not establish that the user's licensed/local access is unavailable.
