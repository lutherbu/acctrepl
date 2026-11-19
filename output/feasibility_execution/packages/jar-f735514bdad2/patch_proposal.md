# Patch proposal: jar-f735514bdad2

Do rating agencies benefit from providing higher ratings? Evidence from the consequences of municipal bond ratings recalibration

DOI: 10.1111/1475-679X.12263

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Author-supplied BGPW_final.sas Table 2 sample-construction workflow from Texas and California bond data.

Entry points: `Final Zip File/BGPW_final.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 2/12263 - Do-rating-agencies-benefit-from-providing-higher-ratings-Evidence-from-the-consequences-of-municipal-bond-rati/bgpw-datasheet-and-code.zip",
      "sha256": "e0502b31f6c6db49decd28e2a5f72aea768a61e02e125979111845c5f03b0658"
    },
    {
      "path": "JAR-Volume 57/Issue 2/12263 - Do-rating-agencies-benefit-from-providing-higher-ratings-Evidence-from-the-consequences-of-municipal-bond-rati/bgpw-internet-appendix.pdf",
      "sha256": "dee4b6cdd6cfc68530f63a0f5aad2f7035bec25364eaa4d08db7094e54c334db"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "3c28b56c4e76b13938f6c3eae490e9a5179242c4733eeafa992cc7c220ae9c5f"
}
```

## Proposed actions

### ACT-DATA-SOURCES: Obtain compatible Texas and California historical issue data and prepare the three SAS tables consumed by BGPW_final.sas.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: REQ-TEXAS, REQ-TEXAS-ENTITY, REQ-CALIFORNIA
Evidence: E-TEXAS-ORIGIN, E-TEXAS-MANUAL-PREP, E-PUBLIC-TEXAS, E-CA-ORIGIN, E-PUBLIC-CA-FIELDS, E-PUBLIC-CA-EXPORT, E-PUBLIC-CA-HISTORY, E-TEXAS-READ, E-ENTITY-READ, E-CA-READ, E-TEXAS-WINDOW, E-CA-WINDOW, E-WINSOR-WINDOW, E-TABLE2-YEARS

Preparation / proposed procedure:

1. For Texas, inspect the current official BRB portal route for 2007–2013 issue-level records and the fields needed for the SAS inputs; if its exact product/schema is not available, request the author-prepared Texas source files and schema rather than substituting annual aggregates.
2. Prepare bgpwd.texas from the annual Texas data as documented: add the bond-sector column and remove subtotal rows. Prepare the separate bgpwd.entity_file with _entity_type and the issue/issuer/county/par/date join fields.
3. For California, use the official DebtWatch issue-level export as a candidate public acquisition route for 2007–2013. Map the displayed fields to the author schema only where definitions match; specifically verify the required guarantor_flag and new_money semantics, and request the author-prepared data/schema if those fields cannot be supported.
4. Import or convert the compatible TX and CA source data into SAS tables with the exact names and types read by BGPW_final.sas. The original March 2017 author bytes are not required if a compatible public route and the documented transformations are verified.

Validation to perform later:

- Before any authorized run, use bounded metadata checks to confirm every raw column read by the SAS source and the correct date, amount, rating and fee types.
- Confirm both ratings-level inputs cover 2007–2013. Preserve the base population used for winsorization before selecting 2008, 2009, 2011 and 2012; do not infer completeness from the current portal summary alone.
- Validate the Texas issue/entity join keys and the California CDIAC issue identifier; verify the exact mappings for guarantor_flag, new_money and the source rating/sale fields.

### ACT-ISSUER-CROSSWALK: Obtain or confirm the exact author-prepared bgpw.withissuernum crosswalk used after s3.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ-ISSUER-CROSSWALK, ISSUE-ISSUER-CROSSWALK
Evidence: E-ISSUER-LIST, E-XWALK-READ, E-PACKAGED-ISSUER-PROBE, E-PACKAGE-INVENTORY

Preparation / proposed procedure:

1. The bounded probe shows the packaged workbook headers are state and issuer, while the SAS join requires id1, fitchi, moodyi, spi and issuernum. Ask the authors to confirm whether this workbook is only a name list and to provide the exact row-level crosswalk or the supported issuer assignment and alias rules.
2. If using an original author crosswalk, preserve the input ordering that generated its id1 values. If using a compatible newer public input, use the id1 values generated consistently from that input and an author-supported issuer/entity/name bridge with the documented manual corrections; do not invent issuer mappings.

Validation to perform later:

- Confirm every Table 2 s3 row maps uniquely on the generated id1 and three rating-agency indicators, and issuernum matches an author-supported assignment. For a newer input, verify that each alias/manual correction follows the supplied issuer mapping rules.

### ACT-MACROS-PATHS: Obtain the external macro sources and configure coherent SAS input, output and macro locations.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISSUE-MACROS, ISSUE-PATHS
Evidence: E-MACRO-PATHS, E-WINSOR-CALL, E-INTERACT-CALL, E-PACKAGE-INVENTORY, E-PRODUCER-TXBL, E-PRODUCER-TXRL, E-PRODUCER-CABL, E-PRODUCER-CARL, E-PRODUCER-BASE, E-WINSOR-INVOKE

Preparation / proposed procedure:

1. Request the definitions and dependencies for the included interact and winsorize members, and for the invoked %winsor and %interact macros. Confirm the intended filename macros target and how the included members define the invoked macros; do not infer a mismatch from the names alone.
2. After the input and output roots are known, replace the three literal location placeholders consistently. Set bgpwd to the raw-data root, set bgpw to a writable output root, and point filename macros to the supplied macro directory.
3. For a future host SAS wrapper, choose an explicit working directory and use relative or [redacted-path-ac7a1499514f] paths only. Preserve all BGPW producer/consumer references so the Texas/California bond-level and ratings-level files, combined base and final table2 resolve through the same bgpw library.

Validation to perform later:

- Confirm the host batch wrapper can read the raw-data and macro paths and write the bgpw library before any authorized author-code execution.
- Check that the macro definitions produce the called winsorized dataset and post-interaction variables without changing the specified sample or transformations.

### ACT-SAS-STARTUP: Resolve the current SAS startup environment failure or identify a separately available authorized SAS runtime; the observed error does not establish a missing license.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SOFT-SAS, ISSUE-SAS-STARTUP
Evidence: E-ENVIRONMENT, E-CODE-SCOPE

Preparation / proposed procedure:

1. Have the host SAS launch environment checked for the observed TKELS extension initialization failure, or select an authorized SAS runtime that can open a batch session.
2. Keep runtime version and author version compatibility as separate checks; the author release is not specified. Do not infer entitlement from the startup error.

Validation to perform later:

- After the environment issue is addressed, verify the exact SAS command and observed version with a bounded empty-session/version check before preparing an authorized execution.

### ACT-RUN-PROCEDURE: Future run procedure after the required data, macro sources, paths and SAS runtime are resolved.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: REQ-TEXAS, REQ-TEXAS-ENTITY, REQ-CALIFORNIA, REQ-ISSUER-CROSSWALK, ISSUE-MACROS, ISSUE-PATHS, SOFT-SAS
Evidence: E-CODE-SCOPE, E-TABLE2-OUTPUT, E-PRODUCER-TXBL, E-PRODUCER-TXRL, E-PRODUCER-CABL, E-PRODUCER-CARL, E-PRODUCER-BASE, E-CONSUME-BASE, E-XWALK-READ

Preparation / proposed procedure:

1. Set the working directory explicitly and run BGPW_final.sas through the authorized host SAS batch wrapper, using only relative or [redacted-path-ac7a1499514f] paths and a writable bgpw output library.
2. Retain the SAS log and confirm the ordered outputs: Texas and California bond-level files, Texas and California ratings-level files, BGPW.TEXAS_CALI_RL, then bgpw.table2.
3. Do not run until the macro sources, author crosswalk, input schemas, SAS startup and host path permissions are resolved.

Validation to perform later:

- Use bounded metadata inspection to verify the generated table2 fields and date window, then compare the author-specified sample and output before any downstream analysis.


## Remaining issues and prerequisites

- ISSUE-MACROS [unresolved; full_pipeline]: The program assigns the fileref macros to the literal placeholder location, includes the members interact and winsorize, and later invokes %winsor and %interact. The external source/member definitions and usable include location are not supplied. The different include-member and invocation spellings alone are not treated as a defect.
- ISSUE-PATHS [preparation; full_pipeline]: Both SAS library assignments and the filename macros fileref use the literal placeholder location on computer; their coherent host-visible input, output and macro roots are not defined.
- ISSUE-ISSUER-CROSSWALK [unresolved; full_pipeline]: The Table 2 builder consumes bgpw.withissuernum by id1, fitchi, moodyi and spi and adds issuernum. The bounded workbook probe shows only state and issuer headers, so the supplied issuer list is not verified as a direct row-level bridge; the issuer assignment/alias rules and manual corrections remain unresolved. Original row-order identity is required only if using a crosswalk keyed to the original author id1 values.
- ISSUE-SAS-STARTUP [unresolved; full_pipeline]: The existing bounded SAS environment probe failed while loading the TKELS extension before reporting a usable runtime version. This makes SAS startup unverified in the current environment; it does not establish a missing license or entitlement.
- REQ-TEXAS [undetermined]: Texas Bond Review Board bond-issuance data prepared as the SAS table bgpwd.texas. The code reads issuance identifiers, issuer/issue/county, par amount and closing date, long-term ratings and agency fees, insurance fee, sale terms, new-money amount, issue type and financial adviser. The required base input supports the 2007–2013 construction window; Table 2 uses 2008–2009 and 2011–2012 after excluding 2010.
- REQ-TEXAS-ENTITY [undetermined]: Texas entity-type lookup prepared from the raw Texas bond data as bgpwd.entity_file. The code joins this table to bgpwd.texas on issue and issuer fields to create _entity_type and issuer-type indicators.
- REQ-CALIFORNIA [undetermined]: California State Treasurer Debt Watch municipal bond-issuance data prepared as bgpwd.california. The code uses issue identifiers, issuer/county, ratings, sale date, principal amount, agency fee, sale and insurance flags, issuer group, new-money amount, debt type and financial adviser.
- REQ-ISSUER-CROSSWALK [undetermined]: Author-prepared issuer-number crosswalk consumed as bgpw.withissuernum to add issuernum after s3. It must join on id1, fitchi, moodyi and spi and provide issuernum. If reusing an original crosswalk, its id1 values must align with the original input ordering; a crosswalk prepared for a compatible newer public input may use the id1 values generated from that input plus an author-supported issuer entity/name bridge.
- SOFT-SAS [unverified]: SAS is required by the supplied SAS 9.4-style dataset builder. The observed environment path is sas_u8, but the bounded startup probe failed at TKELS and did not establish a usable runtime version. Author version is unspecified; entitlement remains unknown.

## Review notes

- Assessment target is the supplied BGPW_final.sas Table 2 sample-construction workflow ending in bgpw.table2. The separate Mergent municipal-yield analysis is described for the online appendix and is not a read in this builder.
- No analysis_only scope is supported: the packaged issuer workbook is a two-column issuer list, not a verified full row-level analysis panel, and there is no separate analysis entry point.
- The static audit reports partial coverage and does not evaluate dynamic SAS macros. The ten frozen dependency IDs were manually reconciled to raw reads, generated SAS intermediates and macro includes in the source.
- No exact Texas or California raw-data product was found in the frozen catalog. This is discovery-only evidence; public-source availability, fields and local entitlement are not inferred from the catalog result.
