# Patch proposal: jar-3df2b9b08f03

Ethnic Minority Analysts’ Participation in Public Earnings Conference Calls

DOI: 10.1111/1475-679X.12504

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full supplied variant: run 0_ANALYST VARIABLES.sas first to construct analyst/firm/forecast/price inputs, then run 1_ANALYST LEVEL TESTS.sas to join call participation, prepared labels and firm controls and create sample/supplement outputs. No analysis-only route is supported by the supplied identifier list.

Entry points: `0_ANALYST VARIABLES.sas`, `1_ANALYST LEVEL TESTS.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 61/Issue 5/12504 - Ethnic-Minority-Analysts-Participation-in-Public-Earnings-Conference-Calls/fgls-datasheet-code-and-identifiers.zip",
      "sha256": "a7a17fcd604580920750f9f86a2f8b67b63e96210f81c05305dda4b590193a05"
    },
    {
      "path": "JAR-Volume 61/Issue 5/12504 - Ethnic-Minority-Analysts-Participation-in-Public-Earnings-Conference-Calls/fgls-online-appendix.pdf",
      "sha256": "03d37abb3084446c203cdf1024b185a8e115a5d8f9bb6cad2286421658339633"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "6218b52bb1c92301dded6a2505a3fece54a5ca9fdcedb8276a27535c70fd0339",
  "work_item_sha256": "7c265c55af14309e10306517fd0a2803f53a34d754afeadd2dd0b6594ced259c"
}
```

## Proposed actions

### ACT-MACRO-REMOTE-CLOSURE: Resolve the supplied programs' two included macro files and the dynamic remote-session inputs before configuring the full workflow.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS-CLOSURE, ISS-MACRO-CLOSURE, ISS-REMOTE-SETUP
Evidence: EV-S0-INCLUDE, EV-S1-INCLUDE, EV-SENSITIVE-SCAN, EV-S0-FIRM-INPUT, EV-S1-PERMNO-MACRO, EV-S1-FIRM-HISTORY-MACROS, EV-S1-WT, EV-S0-SAMPLE, EV-S0-RSUBMIT, EV-S0-UPLOAD, EV-S0-SAFE-CHAIN

Preparation / proposed procedure:

1. Obtain the exact author macro files or written macro definitions for include_permno, ffsic, leadlag_qtr and WT; document each macro's input fields, output members and required history.
2. Preserve the visible order: combine SAMPLE1 and SAMPLE2 into local WORK.SAMPLE, enter the remote-submit block, upload SAMPLE as TMP.FIRMS, then copy/filter TMP.FIRMS into WORK.FIRMS. Resolve the input fields/history for SAMPLE1/SAMPLE2 and the actual remote session/libref data contract; lines 89-90 and all path/auth values stay withheld.
3. For a future authorized working copy, map the actual data roots and the six visible libref identifiers without copying credentials into shared logs; confirm transfer semantics and path ownership before changing any configuration.
4. Use the programs in their supplied order and retain the supplementary section as a separate downstream branch within the assessed full workflow.
5. Keep the open-commented tail of program 0 out of the active stage plan unless the author supplies a source version with a closed comment and documents its intended use.

Validation to perform later:

- Before any future authorized run, statically match every include, remote member read and macro output to an identified producer, field schema and path.

### ACT-IBES-COMPUSTAT-CRSP-ROUTES: Confirm the author-specific Compustat, IBES and CRSP input products and their field, key and history contracts.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ-COMPQ, REQ-IBES-MAP, REQ-HASCONFCALL, REQ-IBES-SUMMARY, REQ-IBES-DETU, REQ-IBES-EXCLUDED, REQ-IBES-REC, REQ-IBES-ACTUAL, REQ-CRSP-DSF
Evidence: EV-S0-COMPQ, EV-S0-IBESMAP, EV-S0-CONF-FIELDS, EV-S0-SUMMARY, EV-S0-DETU, EV-S0-EXCU, EV-S0-REC, EV-S0-ACTU, EV-S0-CRSP, EV-COMP-CATALOG, EV-COMP-PROBE, EV-STATSUMU-CATALOG, EV-STATSUMU-PROBE, EV-DETU-CATALOG, EV-DETU-PROBE, EV-EXCU-CATALOG, EV-RECDDET-CATALOG, EV-ACTU-CATALOG, EV-ACTU-PROBE, EV-CRSP-CATALOG, EV-CRSP-PROBE

Preparation / proposed procedure:

1. For compustat_qtr, identify an authorized input containing the code-required fields, including SIC and INSTOWN, and document the GVKEY/date identifiers plus lead/lag history; the local COMP.FUNDQ candidate is partial.
2. Provide the producer and history for ibesticker_updated and hasconfcall.txt, including the GVKEY-to-IBES map and the filename/GVKEY/call-date keys.
3. Confirm the exact IBES summary, detail, excluded-forecast, recommendation and actual products and their identifiers; retain separate requirements for the direct source reads, including EXCU, RECDDET and ACTU.
4. Confirm the local IBES/CRSP candidate history for all selected issuers and dates; the one-row reads verify matching fields only, not full coverage or mapping.
5. Resolve the required CRSP PERMNO mapping through the author's supplied macro contract; do not substitute a different mapping or inferred link table.

Validation to perform later:

- After compatible inputs and history are documented, compare actual required columns and date windows against the code before any future run; preserve all original failed and corrected one-row probe artifacts.

### ACT-AUTHOR-PREPARED-CALL-AND-ANALYST-INPUTS: Recover or identify the author-prepared call, analyst and label inputs required by the second program.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: REQ-AFQ-90D, REQ-PERSONALITY, REQ-LOCATION-HAND, REQ-ALLSTAR, REQ-CC-ETHNICITY, REQ-TOTAL-ANALYSTS, REQ-ANALYST-CALL, REQ-ANALYST-ETHNICITY, REQ-IMAGE-CORRECTIONS, REQ-LINKEDIN-URL, ISS-DATA-CLOSURE
Evidence: EV-S1-AFQ90, EV-S1-PERSONALITY, EV-S1-LOCATION, EV-S1-ALLSTAR, EV-S1-CC-ETH, EV-S1-TOTAL-READ, EV-S1-ANALYST-CALL, EV-S1-ETH-MAP, EV-S1-IMAGE-CORRECTIONS, EV-S1-LINKEDIN-URL, EV-DOC-CODE

Preparation / proposed procedure:

1. Request the prepared afq_updating_within_90_days, personality_analyst, analyst-location, All-Star, cc_ethnicity, ANALYST CONF CALL PARTICIPATIONold1, analys_to_ethnicity, LINKEDIN IMAGE ETHNICITY CORRECTIONS and analys_linkedin_url inputs with their field dictionaries, identifiers and coverage.
2. Treat prepared ethnicity labels and correction values as primary supplied inputs. Ask for their existing codebook/provenance and preserve the source labels as provided; do not classify people from names, photos or profile searches.
3. Identify the existing total_analysts input and preserve its original bytes separately from the later generated same-named summary.
4. Retain the author-prepared call participation file as its own required input; document how filename, GVKEY, call date, analyst code/order and word/tone fields were created.

Validation to perform later:

- Confirm each recovered input's exact format, keys and required periods against the visible import and join code; any raw/prepared alternative must supply the same authored input contract.

### ACT-AUTHOR-PREPARED-FIRM-CONTROLS: Identify the author-prepared firm-control inputs and compatible histories used in the second program.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ-ZIPCODE, REQ-STATE-REGION, REQ-FORTUNE, REQ-KLD, REQ-IBES-FIRM, REQ-RET-VOL, REQ-SP500
Evidence: EV-S1-ZIP-REGION, EV-S1-FORTUNE, EV-S1-KLD, EV-S1-IBES-FIRM, EV-S1-RET-VOL, EV-S1-SP500, EV-KLD-CATALOG, EV-KLD-PROBE, EV-COMP-CATALOG, EV-COMP-PROBE

Preparation / proposed procedure:

1. Request the exact zipcode_data and state_region inputs and document GVKEY/state/date keys and the date-selection rule.
2. Request Fortune and KLD author-prepared files with ticker/year identifiers and the used periods; confirm the prior-year KLD shift and ticker crosswalk.
3. Request ibes_firm_data, retvol1 and sp500 with producer definitions, fields, identifiers, windows and coverage.
4. For local KLD.HISTORY and COMP.FUNDQ candidates, keep the matching-field read evidence separate from the unresolved missing join/field and history contracts.

Validation to perform later:

- Document the required columns and time coverage for every control before a future run; do not infer full compatibility from a catalog hit or single-row read.

### ACT-SUPPLEMENTAL-INPUTS: Resolve the supplemental XS branch's starting files, join keys and definitions before running its output overwrites.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ-SUPP-FGLS, REQ-SUPP-NOFURTHER, REQ-SUPP-ONCALL, REQ-SUPP-AFQ90
Evidence: EV-S1-SUPP-FGLS, EV-S1-SUPP-SAMENAME, EV-S1-SUPP-AFQ90, EV-S1-SUPP-IDENTIFIERS

Preparation / proposed procedure:

1. Request the exact producer and schema for perm.fgls, perm.nofurtherquestions, perm.on_the_call_for and perm.afq_updating_last_90_days, including the authored keys and indicator definitions.
2. Preserve the incoming perm.fgls member before the code writes perm.FGLS after each successive join.
3. Keep each supplemental join/export stage in source order and identify its distinct output location in the working copy.

Validation to perform later:

- Check each incoming field and join key against the author-defined supplemental contract before any future execution.

### ACT-PRESERVE-WORKING-COPY-OUTPUTS: Prepare a working-copy archive for members read and later overwritten by the supplied programs.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: ISS-OVERWRITE-PRESERVATION, REQ-TOTAL-ANALYSTS, REQ-SUPP-FGLS
Evidence: EV-S1-TOTAL-READ, EV-S1-TOTAL-WRITE, EV-S1-SUPP-FGLS, EV-S1-SUPP-SAMENAME, EV-S1-SUPP-AFQ90

Preparation / proposed procedure:

1. Before a future authorized run, copy the initial total_analysts and perm.fgls members byte-for-byte into a read-only archive under the working copy.
2. Direct outputs and DBMS=STATA exports to distinct new working-copy paths and refuse to overwrite prior result files until they are byte-archived.
3. Keep logs, outputs and probes in separate directories from source inputs and macro files.

Validation to perform later:

- Record the archived member hashes and confirm output targets are new or already archived before running the programs.

### ACT-SAS-AND-PROC-CAPABILITIES: Verify the actual SAS runtime and only the product capabilities called by the supplied programs after resolving environment setup.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW-SAS, SW-SASSTAT, SW-SASCONNECT, ISS-SOFTWARE-CAPABILITY
Evidence: EV-ENV, EV-S0-ANALYST-FOLL-OUT, EV-S0-AFQ-OUT, EV-S0-PRICE-OUT, EV-S0-REMOTE-END, EV-S1-TTEST, EV-S1-RANK, EV-S1-MAIN-EXPORT, EV-S1-SUPP-FGLS

Preparation / proposed procedure:

1. Resolve the recorded TKELS startup failure through the site's documented SAS setup and verify SAS version/startup in an isolated, empty-work environment; this audit did not retry SAS.
2. Confirm SAS/STAT availability for the active PROC TTEST call, SAS/CONNECT support for remote-submit/PROC DOWNLOAD steps, and DBMS=STATA export support; do not infer these capabilities from the SAS executable path.
3. Verify that the supplied external macro definitions are available in the configured SAS session before attempting the program.

Validation to perform later:

- Document successful version and exact procedure, remote-connect and export capability checks before a separately authorized author-code run; retain SAS runtime status as unverified until then.

### ACT-FUTURE-RUN-ORDER: After resolving all input, macro and software gaps, run the two supplied SAS programs in their documented dependency order from a protected working copy.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: ISS-CLOSURE
Evidence: EV-DOC-CODE, EV-S0-AFQ-OUT, EV-S1-AFQ-IN, EV-S1-SAVESAMPLE, EV-S1-MAIN-EXPORT, EV-S1-SUPP-FGLS, EV-S0-SAMPLE, EV-S0-RSUBMIT, EV-S0-UPLOAD, EV-S0-SAFE-CHAIN

Preparation / proposed procedure:

1. Configure the author's actual librefs and output roots in the working copy without placing credentials in shared logs.
2. Run 0_ANALYST VARIABLES.sas before 1_ANALYST LEVEL TESTS.sas only after its macro/data inputs and remote session are confirmed; the first program visibly builds WORK.SAMPLE, uploads TMP.FIRMS, and later uses that member to build WORK.FIRMS.
3. Run the supplemental XS section after the main sample stage using its preserved starting members and distinct output destinations.
4. No Stata regression stage is shown in the supplied programs. Treat the appendix's reported analyses as published-code limitations unless a real operational call or separate author program is supplied.

Validation to perform later:

- After a separately authorized run, confirm expected outputs and schemas, sample keys/date windows and both Stata-format exports; this proposal does not claim execution or statistical validation.


## Remaining issues and prerequisites

- ISS-CLOSURE [unresolved; full_pipeline]: The target is the supplied two-program SAS workflow. The source-visible local WORK.SAMPLE to remote TMP.FIRMS upload to WORK.FIRMS consumer chain is identified, but remote session availability, SAMPLE1/SAMPLE2 source fields and history, required macros, and many other author-prepared or raw inputs lack confirmed producer-to-consumer closure. The identifiers file is not an analysis dataset. No analysis-only bypass is supported by the supplied materials.
- ISS-MACRO-CLOSURE [unresolved; full_pipeline]: Both programs include two external SAS macro files. Active calls include include_permno, ffsic, leadlag_qtr and WT; their definitions, inputs and outputs are not supplied. The local %test123 definition is visible, but its PROC TTEST capability still needs SAS/STAT support.
- ISS-REMOTE-SETUP [unresolved; full_pipeline]: The first program constructs local WORK.SAMPLE from SAMPLE1 and SAMPLE2, begins a remote-submit block, names libref identifiers, uploads SAMPLE as TMP.FIRMS, and later copies/filters TMP.FIRMS into WORK.FIRMS. The original pre-read scan flagged candidate connection/authentication lines 89-90; those values and all libref RHS/path values remain withheld. Actual session/connection availability, software support, SAMPLE1/SAMPLE2 field/history contracts, and remote source data are unverified. Do not expose or copy credentials into the assessment.
- ISS-DATA-CLOSURE [unresolved; full_pipeline]: The package contains only the identifier dataset alongside code and the datasheet. Multiple consumed call, analyst, label, mapping and control inputs are absent, and bounded catalog hits do not verify the required complete history or author-specific field contracts. The requested raw and author-prepared inputs are alternatives where they provide the same authored input; they are not jointly required duplicates.
- ISS-SOFTWARE-CAPABILITY [unresolved; full_pipeline]: The supplied programs use SAS procedures including SQL, SORT, MEANS, FREQ, PRINT, RANK, TTEST, EXPORT and remote PROC DOWNLOAD within a remote-submit block, plus custom macros. The environment record reports SAS startup failure at TKELS; SAS/STAT support for PROC TTEST, SAS/CONNECT support for the remote steps, and the DBMS=STATA export engine are unverified. No SAS/ETS use was identified, and the environment failure is not evidence of an absent license.
- ISS-OVERWRITE-PRESERVATION [preparation; full_pipeline]: The main program reads the existing total_analysts member before replacing it. The supplemental section also repeatedly writes perm.FGLS after reading it. Preserve the initial input members and each required intermediate in a working-copy archive before any future run.
- REQ-COMPQ [undetermined]: Both programs read the author-named compustat_qtr.sas7bdat. The code needs GVKEY, DATADATE, RDQ, SIC, TIC, CUSIP, PRCCQ, CSHOQ, CEQQ, FYR, OANCFY/OANCFQ, IBQ, ATQ and INSTOWN across the source and control sections. Program 0 filters DATADATE from 2000; the controls section filters 2001-2021; the final sample uses 2002-2017. Required lead/lag history and a compatible SIC/ownership field source remain unresolved.
- REQ-IBES-MAP [undetermined]: The author-specific ibesticker_updated.sas7bdat maps GVKEY and DATADATE to IBES ticker before forecast construction. Its producer, exact key validity and historical mapping contract are not supplied.
- REQ-HASCONFCALL [undetermined]: Both programs read the prepared hasconfcall.txt index with filename, GVKEY and conference-call date. The datasheet describes Factiva as the transcript source; the transcript-to-index preparation and coverage contract are absent.
- REQ-IBES-SUMMARY [undetermined]: IBES.STATSUMU_EPSUS supplies unadjusted quarterly EPS summary counts used to construct analyst following by IBES ticker and fiscal period.
- REQ-IBES-DETU [undetermined]: IBES.DETU_EPSUS provides unadjusted quarterly EPS detail forecasts for analyst activity, forecast matching and experience. The code filters EPS/FPI, forecast dates near DATADATE and prior-year announcement windows, and separately uses the earliest observed dates for experience.
- REQ-IBES-EXCLUDED [undetermined]: The program directly reads IBES.EXCU_EPSUS to flag excluded US-firm EPS forecasts by ticker, forecast period, analyst, FPI, actual date/time and measure. The exact local product route and required fields are unresolved.
- REQ-IBES-REC [undetermined]: The program directly reads IBES.RECDDET for recommendations outstanding before earnings dates, using ticker, analyst code, announcement date and recommendation code. The matching local table, schema and coverage are unverified.
- REQ-IBES-ACTUAL [undetermined]: IBES.ACTU_EPSUS supplies quarterly unadjusted actual EPS joined to matched forecast periods within the authored five-day window around DATADATE.
- REQ-CRSP-DSF [undetermined]: CRSP.DSF supplies daily PERMNO/DATE/PRC values for the authored weekday interval from 10 to 2 days before each call. GVKEY-to-PERMNO construction is delegated to a missing macro.
- REQ-AFQ-90D [undetermined]: The second program reads afq_updating_within_90_days.sas7bdat and uses its GVKEY/ANALYS/CONFCALLDATE matching contract. Its producer, flag definition, history and coverage are not supplied.
- REQ-PERSONALITY [undetermined]: The second program reads personality_analyst.sas7bdat and merges EXTRA by analyst code. The transcript-to-personality preparation, schema and coverage are absent.
- REQ-LOCATION-HAND [undetermined]: The second program imports the analyst location hand-collection CSV, orders records by analyst and latest year, and constructs an international indicator from ZIPCODE. The author-prepared CSV is absent.
- REQ-ALLSTAR [undetermined]: The second program merges Complete All Star List 1972-2017.csv by ANALYS and calendar year. The prepared file and coverage are absent.
- REQ-CC-ETHNICITY [undetermined]: The second program reads cc_ethnicity.csv with filename and author-prepared analyst/executive label fields, then creates call-level summaries. The prepared labels and their dictionary are absent; this assessment does not infer identity or protected traits from names or images.
- REQ-TOTAL-ANALYSTS [undetermined]: The second program reads total_analysts.sas7bdat before later overwriting that same member with a new summary. The initial input fields include filename and total counts by the code's existing categories; preserve the initial member in a working copy.
- REQ-ANALYST-CALL [undetermined]: The second program reads ANALYST CONF CALL PARTICIPATIONold1.txt with call/analyst keys, order and analyst/manager word-count and tone-count fields. Its transcript-processing producer and field definitions are absent.
- REQ-ANALYST-ETHNICITY [undetermined]: The second program reads analys_to_ethnicity.csv by analyst code with the authors' existing coded group and related fields. The prepared input and coding dictionary are absent; no classifications were generated in this audit.
- REQ-IMAGE-CORRECTIONS [undetermined]: The second program reads LINKEDIN IMAGE ETHNICITY CORRECTIONS.txt and applies existing corrected_ethnicity values. The prepared correction file is absent; this audit does not review photos or infer identity.
- REQ-LINKEDIN-URL [undetermined]: The second program reads analys_linkedin_url.csv and uses analyst-code membership to create a URL-presence flag. The author-prepared file is absent; no individual profile lookup is required for this assessment.
- REQ-ZIPCODE [undetermined]: The second program reads zipcode_data.sas7bdat with GVKEY, DATADATE, filing date and headquarters ZIP/state fields to attach location information. The prepared file and coverage are absent.
- REQ-STATE-REGION [undetermined]: The second program reads state_region.csv to map headquarters state into region indicators. The crosswalk is absent.
- REQ-FORTUNE [undetermined]: The second program reads Fortune Best in Workplace Diversity.csv and joins by ticker/year; it sets values missing before 2015. The author-prepared file and identifier/year coverage are absent.
- REQ-KLD [undetermined]: The second program reads KLD.csv with ticker/year diversity-strength and concern fields, then constructs prior-year values. The author input and required ticker join remain unresolved.
- REQ-IBES-FIRM [undetermined]: The second program reads ibes_firm_data.sas7bdat, removes RDQ and joins by GVKEY/call date; later code uses expearn_mean. Its producer, complete field schema and historical coverage are absent.
- REQ-RET-VOL [undetermined]: The second program reads retvol1.sas7bdat with PERMNO, call date and RETVOL. The volatility definition, return window, producer and coverage are absent.
- REQ-SP500 [undetermined]: The second program reads sp500.sas7bdat with GVKEY, call date and historical SP500 membership. Its producer, date definitions, firm mapping and coverage are absent.
- REQ-SUPP-FGLS [undetermined]: The supplemental section reads perm.fgls.sas7bdat as input before later overwriting perm.FGLS. Its producer, full fields and coverage are absent; preserve the initial member.
- REQ-SUPP-NOFURTHER [undetermined]: The supplemental section reads perm.nofurtherquestions.sas7bdat with GVKEY/call-date keys and NO_FURTHER_QUESTIONS. Its producer and field definitions are absent.
- REQ-SUPP-ONCALL [undetermined]: The supplemental section reads perm.on_the_call_for.sas7bdat with GVKEY/call-date/analyst keys and SAME_NAME. Its producer and matching definition are absent.
- REQ-SUPP-AFQ90 [undetermined]: The supplemental section reads perm.afq_updating_last_90_days.sas7bdat for a 90-day-update indicator using firm/analyst/call keys. Its producer and exact window contract are absent.
- SW-SAS [unverified]: Both entry points are SAS. The supplied programs actively call PROC SQL, SORT, MEANS, FREQ, PRINT, RANK, EXPORT, UPLOAD and DOWNLOAD. They also call include_permno, ffsic, leadlag_qtr and WT; those external macro definitions are not supplied. Program 1 locally defines test123, whose PROC TTEST requirement is recorded separately under SAS/STAT. Package-specific SAS version and product capabilities remain unverified; no author program was executed.
- SW-SASSTAT [unverified]: Program 1 locally defines and invokes test123; its supplied body runs PROC TTEST and assembles ODS statistics outputs. SAS/STAT availability is not established by package-specific product metadata. The program also uses PROC EXPORT with DBMS=STATA, whose engine support is unverified. No Stata regression stage appears in the supplied programs.
- SW-SASCONNECT [unverified]: Program 0 contains RSUBMIT/ENDRSUBMIT, PROC UPLOAD and PROC DOWNLOAD calls. The bounded safe view confirms the intended WORK.SAMPLE to TMP.FIRMS upload and six libref identifiers while withholding all configuration/path values. SAS/CONNECT availability, actual session setup and remote data contracts remain unverified; no author program was executed.

## Review notes

- Assessment is limited to the supplied variant: two SAS source programs, one datasheet/appendix and an identifier dataset. The identifier file is not a usable analysis input; no analysis_only scope is supported.
- The work-item source hashes and package archive hashes remain the frozen provenance. Source evidence quotes are exact, one-based slices from the assigned cached content; the first program's candidate connection/authentication block was conservatively withheld at lines 65-110 after a static scan flagged lines 89-90.
- No author code, SAS runtime, model, regression or data-construction program was executed. The SAS startup failure and bounded catalog/probe results are not license or full-coverage evidence. Each successful SAS data probe reads at most one row; no whole-file counts or population coverage are inferred.
- A prior initial field request failed because the selected COMP.FUNDQ/KLD fields were absent. Those requests, errors and original probes remain preserved. Corrected one-row probes used only fields present in the candidates; COMP.FUNDQ still lacks SIC/INSTOWN in the selected fields and KLD.HISTORY lacks the required ticker join.
- The source directly reads IBES EXCU, RECDDET and ACTU tables in addition to the prepared call, analyst and control inputs. These direct inputs were retained even when not represented as standalone checklist edges.
- The supplied programs contain active PROC SQL, SORT, MEANS, FREQ, PRINT, RANK, TTEST and EXPORT calls. SAS/STAT and DBMS=STATA export support remain unverified. External macros include include_permno, ffsic, leadlag_qtr and WT; the test123 macro is defined in program 1. No SAS/ETS use was identified.
- Program 0 opens a block comment at line 473 that remains open through EOF; the tail is inactive in the supplied file. Program 1 reads total_analysts before rewriting that member and repeatedly writes perm.FGLS in its supplemental section; a working-copy archive is required.
- The appendix reports analyses, but the two supplied programs contain no standalone regression-stage program. A separate Stata regression stage is not added without a real operational source/call. No new ethnicity, race, religion, nationality or other protected-trait inference was performed from names, photos, people or companies; author-prepared label inputs were assessed only as declared fields.
- The datasheet describes Factiva transcript use, LinkedIn photos for the authors' verification process and Compustat/CRSP/IBES data. Those descriptions do not close the missing file/schema/history contracts; contact details and personal identifiers are not copied into the assessment.
- A separate process_trace.json records retained catalog/probe and helper capture metadata. It is custody/process history only and is not cited recursively as scientific evidence.
