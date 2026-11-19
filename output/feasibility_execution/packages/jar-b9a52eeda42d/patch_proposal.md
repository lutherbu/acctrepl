# Patch proposal: jar-b9a52eeda42d

Direct Evidence on the Informational Properties of Earnings in Loan Contracts

DOI: 10.1111/1475-679X.12168

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | blocked |

### full_pipeline

Full author data-generation workflow: run Compile DealData first to create the Dealscan covenant panel, then the public DVW SAS program to merge hand-collected rounds, supplements and Compustat/CRSP/IBES sources. The appendix describes Stata analyses, but no executable analysis program or compatible prepared-analysis bypass is included.

Entry points: `Compile DealData 20DEC2014.sas`, `DVW JAR_R2 Version1 Data -- Public.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 55/Issue 2/12168 - Direct-Evidence-on-the-Informational-Properties-of-Earnings-in-Loan-Contracts/dvw-datasheet-and-programs.zip",
      "sha256": "82ab25a7ec386adf54636be95e9c07bfe137b416dfcb7b06010ffeb3c1655a6d"
    },
    {
      "path": "JAR-Volume 55/Issue 2/12168 - Direct-Evidence-on-the-Informational-Properties-of-Earnings-in-Loan-Contracts/dyreng-vashishtha-weber-internet-appendix.pdf",
      "sha256": "245e0f768e0ddb9f4b63de5db449dc7cf07be0c35c8256f9f23b5a8d2e7fdc67"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6c5af1b6f2bb7e97911c10d87c9b1e6de7b02afb5c6fe5ea87197e5415ede33d",
  "work_item_sha256": "26b9a71b82233e4d509adf433e81294d7d7417fa245b172bf54dde17e678d9f3"
}
```

## Proposed actions

### ACT-AUTHOR-INPUTS: Obtain the exact author-prepared collection and supplemental input files referenced by the SAS code.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: REQ-HAND-COVENANT, REQ-HAND-NWDATA, REQ-HAND-STREET, REQ-HAND-TRUSLACK, REQ-CSTAT-VIOLATIONS, REQ-PROFORMA-SAMPLES, ISS-HIDDEN-INPUTS
Evidence: E-DATASHEET-RELEASE, E-PACKAGE-INVENTORY, E-HAND-SECOND, E-HAND-THIRD, E-HAND-NW, E-HAND-STREET, E-HAND-TRUSLACK, E-SOURCE-SUFI, E-PF-SOURCES

Preparation / proposed procedure:

1. Request both redacted Google CSV collection exports and the third-round Excel workbook; also request NWDATA, STREET, SLACK.SLACKDATA_04JUN2013, home.cstatviolations_nss_20090701, and DVW.COMPLETEPFSAMPLE/DVW.PFSAMPLE.
2. For each file, ask for its field definitions, identifiers, units, sample dates, importer settings and storage/libref location; preserve each distinct file as a separate source.
3. Place supplied files only in the author-confirmed locations after confirming permitted access; do not reconstruct missing collection records.

Validation to perform later:

- Run a bounded metadata/readability check on received files and compare fields/keys/date coverage with the source joins.
- Confirm the three bank-data rounds and each supplement cover the author sample; one-row readability does not prove full history.

### ACT-DEAL-LINK: Obtain the exact author-prepared Compustat–Dealscan link or a documented compatible route.

Scopes: full_pipeline. Type: access_request. Certainty: supported.
Addresses: REQ-DEALSCAN-LINK
Evidence: E-LINK-INPUT, E-PACKAGE-INVENTORY

Preparation / proposed procedure:

1. Request the historical Excel/SAS dealcomplink file described in the source and its creation/version notes.
2. Confirm its GVKEY, BCOID/DSID, FACID, SMBL_H, FACSTARTDATE and FIC fields, matching rules and period coverage.
3. Use only the author-confirmed link file/route; do not rebuild it from raw vendor data without an author-supported specification.

Validation to perform later:

- Inspect the delivered file with bounded metadata tools and confirm required fields and coverage before joining it.

### ACT-WRDS-ROUTES: Confirm authorized WRDS access and map the current vendor products to the authors’ legacy SAS names, fields and study periods.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ-DEALSCAN, REQ-COMPUSTAT, REQ-CRSP, REQ-IBES, ISS-CLOSURE
Evidence: E-WRDS-ACCESS, E-WRDS-DEALSCAN, E-WRDS-COMPUSTAT, E-WRDS-CRSP, E-WRDS-IBES, E-CAT-DEALSCAN, E-CAT-COMPUSTAT, E-CAT-CRSP, E-CAT-IBES

Preparation / proposed procedure:

1. Confirm subscriber affiliation and product entitlements for LSEG DealScan, Compustat, CRSP and IBES; WRDS terms limit use to authorized users of subscribing institutions.
2. Ask WRDS support or the data steward to map current product schemas to DEALSCAN.*, COMPM.*, COMP.*, CRSP.COMPHIST/CCM/stock records, and IBES.IDSUM/STATSUMU/ACTPSUMU.
3. For local catalog candidates, separately verify source vintage and full history; do not treat one-row probes, product names or catalog misses as evidence of complete availability.
4. Retain the author filters/identifiers and do not silently substitute a neighboring dataset when fields or dates differ.

Validation to perform later:

- After access confirmation, inspect schemas and covered dates for every jointly required table, identifiers and return/earnings fields.
- Confirm the remote SAS librefs and actual dataset names before any later authorized execution.

### ACT-SAS-CONFIG: Resolve SAS startup, macro-loading and remote-library configuration from the environment owner/authors.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-SAS, ISS-RUN-CONFIG, ISS-CLOSURE
Evidence: E-P-ENVIRONMENT, E-WRDS-SETUP, E-COMPILE-SETUP, E-DVW-SETUP, E-DVW-PATHS

Preparation / proposed procedure:

1. Have the environment owner explain or resolve the TKELS Launch Service Load Failure and confirm SAS 9.4/SAS Connect availability; the probe does not establish license or entitlement.
2. Confirm how the separate WRDS.sas macro is loaded, where `%wrds` is defined for both entry files, and the remote location for the supplied WT.sas include.
3. Confirm remote HOME/DEALSCAN/COMPM/COMP/CRSP/IBES libraries and the client-side DVW/SLACK paths left blank in the distributed source.
4. Document which side owns each input/output directory and the authorized sign-on method.

Validation to perform later:

- Repeat a standalone SAS startup/version probe and confirm SAS Connect separately.
- After configuration review, verify each needed libref resolves to metadata for the expected datasets before any author code is run.

### ACT-ANALYSIS-SPEC: Obtain the missing analysis programs or complete procedure for the paper’s result tables and figures.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: ISS-ANALYSIS-CODE
Evidence: E-ANALYSIS-END, E-APPENDIX-MI, E-APPENDIX-ANALYSIS, E-PACKAGE-INVENTORY

Preparation / proposed procedure:

1. Request the Stata analysis programs or full step-by-step specification for all reported analyses, including the MI variable set, regression model, estimation/pooling commands and output targets.
2. Confirm the exact version of JAR_R2_FINAL_10MAR2016 used as analysis input and identify any further author-prepared files.
3. Keep analysis separate from the supplied SAS data build; do not add an analysis_only route until compatible prepared inputs and executable instructions exist.

Validation to perform later:

- Map each table/figure to a supplied entry point, exact inputs and outputs; verify that the five-imputation method and model are reproducible.

### ACT-RUN-ORDER: After all inputs, access, software and configuration are resolved, preserve the documented producer-consumer order.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: E-PRODUCE-DEALDATA, E-STAGE-ORDER, E-IBES-OUTPUT

Preparation / proposed procedure:

1. Prepare author inputs and confirm remote/local librefs under authorized WRDS/SAS setup.
2. Run Compile DealData 20DEC2014.sas first and confirm DEALSCAN.DEALDATA_22DEC2014 and ALLLOANS_22DEC2014 are written to the expected library.
3. Then run DVW JAR_R2 Version1 Data -- Public.sas; it consumes the DealData output and writes DVW.JAR_R2_FINAL_10MAR2016.
4. Only after the missing analysis workflow is supplied can the paper analyses be run against the confirmed output version.

Validation to perform later:

- Before any later authorized execution, confirm every produced table and required downstream field/date coverage against the author specification.
- Data generation alone does not establish reproduction of the paper estimates.


## Remaining issues and prerequisites

- ISS-HIDDEN-INPUTS [blocking; full_pipeline]: The programs require hand-collected CSV/Excel inputs, supplementary prepared tables and an earlier Dealscan–Compustat link. These files are absent from the assigned archive, so author delivery/specification is needed before data construction.
- ISS-RUN-CONFIG [unresolved; full_pipeline]: Entry programs invoke %WRDS/remote blocks, but support macro loading is not shown in the entries; remote librefs/home paths, SAS Connect, WT remote include path and blank DVW/SLACK paths need confirmation.
- ISS-ANALYSIS-CODE [blocking; full_pipeline]: The SAS programs prepare data and say subsequent analysis is separate. The appendix describes Stata MI/other analyses, but no executable analysis program or complete per-table procedure is supplied. No compatible prepared-analysis bypass supports analysis_only.
- ISS-CLOSURE [unresolved; full_pipeline]: All frozen edges are reviewed, but full history/field compatibility, macro-expanded IBES IDSUM/actual routes, legacy aliases and remote configuration remain unresolved. One-row probes establish columns/readability only, not history. Known stage order is Compile DealData before DVW.
- REQ-HAND-COVENANT [undetermined]: Three author/RA hand-collected performance-covenant earnings rounds: first/second Google CSV and third Excel, merged as the primary bank EBITDA panel.
- REQ-DEALSCAN-LINK [undetermined]: Author-prepared home.dealcomplink mapping Compustat GVKEY and company/facility identifiers to Dealscan records.
- REQ-DEALSCAN [undetermined]: Dealscan facility, package, amendment, pricing, lender-share, financial-covenant and net-worth-covenant records.
- REQ-COMPUSTAT [undetermined]: Compustat quarterly, annual, company/name and separately referenced ratings records for financial ratios, earnings, SIC and controls.
- REQ-CRSP [undetermined]: CRSP company history, stock-name/return records and CCM link history for joins and IBES identifiers; exact COMPHIST mapping is required.
- REQ-IBES [undetermined]: IBES IDSUM identifier history, summary forecasts and unadjusted actual EPS records linked to CRSP.
- REQ-HAND-NWDATA [undetermined]: Separate author NWDATA workbook with net-worth covenant confirmation, escalator, definition and contract URL/date.
- REQ-HAND-STREET [undetermined]: Separate author STREET workbook with non-bank annual/quarterly earnings and availability marker.
- REQ-HAND-TRUSLACK [undetermined]: Author-prepared SLACK.SLACKDATA_04JUN2013 covenant target/actual table.
- REQ-CSTAT-VIOLATIONS [undetermined]: Separate home.cstatviolations_nss_20090701 file used to derive SUFI violation indicators.
- REQ-PROFORMA-SAMPLES [undetermined]: Prepared DVW.COMPLETEPFSAMPLE and DVW.PFSAMPLE pro-forma EPS inputs.
- SW-SAS [unverified]: The data pipeline requires SAS/WRDS remote execution. A bounded standalone startup probe fails TKELS; the probe explicitly does not infer license or entitlement and does not establish SAS Connect availability.

## Review notes

- Expanded draft checkpoint saved after author source/dependency review, bounded catalog probes and official route checks.
- Commercial product routes remain unverified: one-row probes show readability/columns only; product pages do not establish entitlement, exact legacy mapping or full history; catalog misses do not establish absence.
- The required order is Compile DealData before the public DVW SAS program. No analysis_only scope is supported.
- The Compustat PROC DOWNLOAD block is active; DVW.COMPDATA_10MAR2016 is classified as generated. Its destination path and remote/libref configuration remain unresolved.
