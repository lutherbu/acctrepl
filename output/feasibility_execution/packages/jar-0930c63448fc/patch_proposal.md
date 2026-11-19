# Patch proposal: jar-0930c63448fc

Bridging the Gap: Evidence from Externally Hired CEOs

DOI: 10.1111/1475-679X.12200

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full author-supplied SAS preparation workflow and Table 2 data construction. The code says REPsample11 feeds Stata analyses; no Stata analysis program is in the package inventory.

Entry points: `Data and Code Sharing/REPsampleprep.sas`, `Data and Code Sharing/REPtable2.sas`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 56/Issue 2/12200 - Bridging-the-Gap-Evidence-from-Externally-Hired-CEOs/errz-datasheet-and-code.zip",
      "sha256": "c78372afa739b83af076764f23af1ae71db68a52b220c941884f8da88eaaab5f"
    },
    {
      "path": "JAR-Volume 56/Issue 2/12200 - Bridging-the-Gap-Evidence-from-Externally-Hired-CEOs/errz-online-appendix.pdf",
      "sha256": "d5eb964d2f1a00f23bfe670ac64e508801a83b77336dd00780b52dfc7eae4e59"
    },
    {
      "path": "JAR-Volume 56/Issue 2/12200 - Bridging-the-Gap-Evidence-from-Externally-Hired-CEOs/ertimur-rogers-zechman-accepted-proposal.pdf",
      "sha256": "5db66d196012dc097a0ffb8691187dabcfb78e77734db038ea5a73f293bbb97d"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "a2219b3711f6bb8cf069067d6e009afe9c0d76cd5f4ff62735f7b58fcda05348"
}
```

## Proposed actions

### A01: Confirm the author’s initial machine-readable External table and provide its schema/producer or prepared file, then map the supplied External CEO Dates fields onto HCData using the documented identifiers.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_EXTERNAL, R_HCDATA
Evidence: EV001, EV006, EV007, EV009, EV037, EV046, EV061

Preparation / proposed procedure:

1. Provide the exact REP.External producer/input contract, sample_id fields and the local-to-WRDS file handoff.
2. Map packaged GVKEY/EXECID and hand-collected fields onto the author’s REP.HCData columns without recollecting the supplied date/gap information.
3. Confirm supplemental HCData columns used by the SAS join and how the current CEO 2016-05-31 truncation is applied.

Validation to perform later:

- Verify join keys and field types against lines 28–66; reconcile the documented 2,036 hand-collected hires and the code’s filtering stages, preserving the 347 later-excluded cases until author filters run.

### A02: Confirm that the exact local/WRDS Compustat, Execucomp and CRSP products are available in the specified paths and cover the required identifiers and history. Use the known readable ANNCOMP product as a conditional source for the local COMP.ANNCOMP alias; no byte-identical file is required.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_COMPFUNDA, R_ACO_PNFNDA, R_COMPANY, R_SEC_MTH, R_EXEC_ANN, R_COMP_ANN_LOCAL, R_CCM_LINK, R_STOCKNAMES, R_CRS_MSF
Evidence: EV010, EV011, EV016, EV017, EV035, EV044, EV048, EV049, EV050, EV051, EV052, EV053, EV054, EV055

Preparation / proposed procedure:

1. Identify intended product/vintage and library/member mapping for each source, including the local COMP.ANNCOMP alias; compare required fields and history, not byte identity.
2. Confirm Compustat annual coverage from fiscal year 1966 and the lead/five-lag construction, plus ACO_PNFNDA and COMPANY joins.
3. Confirm CRSP link, names and monthly-return histories across all sample events and the rolling 60-month windows; confirm Table 2 SEC_MTH coverage.

Validation to perform later:

- Compare requested fields, identifiers, periods and history with the identified product members; verify the local COMP.ANNCOMP alias maps to a compatible ANNCOMP product for pension/deferred/severance fields without requiring identical source bytes.

### A03: Resolve the legacy CRSP.MSE alias using the bounded MSEALL and MSEDELIST candidates only after their event/date semantics are confirmed.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_CRS_MSE, I006
Evidence: EV012, EV030, EV044, EV056, EV057

Preparation / proposed procedure:

1. Confirm which candidate, if either, corresponds to the code’s DATE and EVENT=DELIST filter and DLSTCD exclusion.
2. Document any required date/variable mapping from DLSTDT to DATE; do not assume MSEALL or MSEDELIST is a drop-in alias.

Validation to perform later:

- Verify the resolved input supplies PERMNO, DATE, DLSTCD, DLRET and delisting-event semantics over the required return windows.

### A04: Acquire the official monthly 25 Size × Book-to-Market product using a supported historical return methodology compatible with the supplied macros; verify the FIZ/CIZ choice before selecting the file.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_FF25
Evidence: EV031, EV039, EV040

Preparation / proposed procedure:

1. Use the official product page and its historical archive route to identify a monthly 25-portfolio series using the same legacy FIZ or other confirmed method as the source analysis; if the product-specific archive/method is not clear, request the authors’ original methodology/vintage.
2. Convert the compatible series’ monthly date and 25 value-weighted returns to the FF.PORTFOLIOS25 schema consumed by the SAS code.

Validation to perform later:

- Confirm complete monthly coverage of sample return windows, exact FIZ/CIZ method compatibility, and a one-to-one mapping for each s1b1_vwret through s5b5_vwret series.

### A05: Acquire the official monthly ME breakpoint product and prepare the fields used in the return macros.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_ME_BREAKPOINTS
Evidence: EV013, EV041

Preparation / proposed procedure:

1. Download the official monthly ME breakpoint file.
2. Convert the date, year/month and p20/p40/p60/p80 breakpoints to the REP.ME_BREAKPOINTS fields.

Validation to perform later:

- Confirm monthly dates span all benchmark classification dates and each required percentile maps to the program’s sizeq assignment.

### A06: Acquire the official annual BE/ME breakpoint product and prepare the fields used in the return macros.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_BEME_BREAKPOINTS
Evidence: EV013, EV042

Preparation / proposed procedure:

1. Download the official annual BE/ME breakpoint file.
2. Convert year and p20/p40/p60/p80 percentiles to the REP.BE_ME_BREAKPOINTS fields.

Validation to perform later:

- Confirm annual coverage includes each benchmark classification year and required percentiles map to bmq.

### A07: Request the exact externally generated governance, ownership and BoardEx outputs or their author producer programs, schemas and paths.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_INSTOWNALL, R_DIRECTORS14, R_GENSPEC, R_BOARDEX_SUMMARY, I001
Evidence: EV014, EV015, EV024, EV032, EV033, EV034, EV044, EV058, EV059, EV060, EV061

Preparation / proposed procedure:

1. Request the prepared InstOwnALL output(s) used at the distinct WRDS REP and local TFN paths, with fields, date population and the TFN.S34 processing producer.
2. Request directors_14JUN2016 and its two RiskMetrics input mappings, type/name reconciliation and unique-ID procedure; identify whether the WRDS REP and local RISK copies are the same output.
3. Request gen_spec and BOARD_SUMMARY_CU outputs or exact producers, including BoardEx inputs, Compustat match fields and output schemas.

Validation to perform later:

- Check each output path independently against its SAS consumer fields, period and join keys; verify unique director IDs and table/report-date aggregation before use.

### A08: Request the author-prepared Form4 and compiled state-year Garmaise outputs and their exact schemas; do not rebuild historical source collection as part of this review.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_FORM4, R_GARMAISE, I001
Evidence: EV019, EV020, EV036, EV044, EV061

Preparation / proposed procedure:

1. Request REPForm4Output with its sample/firm identifiers, date fields, state values, and the author’s duplicate/manual-resolution contract.
2. Request the compiled State/year/gindex table first, including coverage endpoints and any adjacent-year values required for lead/lag joins; separately clarify access only if that compiled output is unavailable.

Validation to perform later:

- Verify REPForm4Output supports the 1,825-day pre-departure window and state mapping, and that the separate Garmaise table is state-year data rather than the company CIK NCC indicator.

### A09: Request the actual hand-collected supplements consumed by the current SAS branch with their field dictionaries and sample_id coverage.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: R_MISSINGSTATE, R_TDC1_HC, R_MISSINGAGE_HC, I001
Evidence: EV023, EV025, EV026, EV044, EV061

Preparation / proposed procedure:

1. Request MissingStateV2, TDC1_for_yonca and MissingAgeForHCv2 as prepared author tables or exact preparation specifications.
2. Confirm fields/types, flagged-case population, manual-exclusion logic and expected unresolved-case counts from the authors’ release.

Validation to perform later:

- Check the tables match the SAS consumer schemas and sample_id keys; confirm they address the current code’s missing-state, missing-TDC1 and missing-age populations.

### A10: Acquire or request the author’s matching compensation-incentives dataset for actual Step 12, and confirm the MISC library setup and field mapping.

Scopes: full_pipeline. Type: data_acquisition. Certainty: supported.
Addresses: R_NAVEEN_WEALTH, I004
Evidence: EV027, EV043, EV069

Preparation / proposed procedure:

1. Use the author data page’s Compensation Data route or obtain the cited 2017-era prepared file, then identify whether it matches MISC.Deltavega2015.
2. Confirm the intended MISC libname/path, map CO_PER_ROL to the code’s COPEROL join field, and determine the earliest prior-firm year required.

Validation to perform later:

- Verify GVKEY/YEAR/executive-role keys, firm-related-wealth values and available years cover the actual Step 12 prior-firm joins before building REPsample12.

### A11: Convert the packaged company-level NCC indicator into the CIK/NCA schema expected by Step 9.

Scopes: full_pipeline. Type: data_preparation. Certainty: supported.
Addresses: R_NCA
Evidence: EV021, EV022, EV038, EV047

Preparation / proposed procedure:

1. Retain the author CIK values and map NCC=1 to NCA="Yes" and NCC=0 to NCA="No".
2. Join the converted company-level table to CIK_PRIORFIRM_NCC as specified in the SAS source.

Validation to perform later:

- Check the converted fields and values against the code, track unmatched CIKs, and preserve the README’s initial-sample/SEC-filing coverage limitation.

### A12: Stage each intermediate across the actual local and WRDS boundaries before running its consuming branch.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: I003
Evidence: EV002, EV003, EV018, EV029, EV032, EV066, EV067, EV068, EV070

Preparation / proposed procedure:

1. Transfer the local REPsample1 file to the WRDS REP [redacted-path-370bd853f4d7] directory before main Steps 2–8.
2. After WRDS Step 8, transfer REPsample8 to the local REP directory used by Step 9.
3. Transfer local REPsample11 to the WRDS REP directory before Table 2 Steps 1–5; transfer the resulting WRDS Table2 back to the local REP directory before local Step 6.
4. Keep each producer/consumer path consistent; do not rename only one side of a pair.

Validation to perform later:

- At each handoff compare the exact dataset name, key variables and schema expected by the next read; record the source/destination paths and the completed copy.

### A13: Request the author’s missing Stata analysis entry and its explicit input/output handoff, including the actual Step 12 REPsample12 extension.

Scopes: full_pipeline. Type: clarification. Certainty: supported.
Addresses: I002
Evidence: EV001, EV027, EV061

Preparation / proposed procedure:

1. Request the Stata do-file(s), exact regression/table entry points and software/add-on requirements.
2. Ask whether the analyses consume REPsample11, the Step 12 REPsample12 handoff, or both; obtain the corresponding file path and expected variables.
3. Map each reported paper analysis/table to the supplied SAS preparation output and Stata entry.

Validation to perform later:

- Compare the delivered scripts’ imports and outputs with the actual REPsample11/REPsample12 schemas and the paper’s reported analyses; do not use independent reproduction code to fill this author-package gap.

### A14: Verify the SAS runtime in the intended supported environment; the local startup error is unresolved and does not establish licensing status.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S_SAS, I005
Evidence: EV045

Preparation / proposed procedure:

1. Run a benign version/startup probe in the intended SAS 9.4/WRDS environment with its documented autoexec and runtime configuration.
2. If the current host continues to fail at TKELS, record the site-supported execution environment and version instead of changing installations.

Validation to perform later:

- Confirm SAS version and a successful non-author startup probe, then check the author programs’ required SAS features against that runtime.

### A15: If the author confirms MissingState should be exported from the current temporary REPsample9 created at lines 1321–1325, change the export read to that current WORK member; if a prior-run permanent REP.REPsample9 is intentional, retain it and document its producer.

Scopes: full_pipeline. Type: source_edit. Certainty: conditional.
Addresses: I007
Evidence: EV063, EV064, EV065

**Proposed edit:** `Data and Code Sharing/REPsampleprep.sas:1328–1328`
Source SHA-256: `59341c30a762a4d3d616368715fae86d59aeefbfdc6c771dff009f1a97061d61`

Conditional on author confirmation that the current WORK.REPsample9 is intended; the code reads the permanent member before the shown first permanent write.

Current text:
```
	set REP.REPsample9;
```

Proposed replacement:
```
	set REPsample9;
```

Preparation / proposed procedure:

1. Confirm whether line 1328 intentionally consumes a pre-existing permanent REP.REPsample9 or should consume the just-created WORK.REPsample9.
2. If the WORK table is intended, apply the single conditional replacement below; keep the later MissingStateV2 merge and permanent write order unchanged.

Validation to perform later:

- In a clean staging run, confirm the MissingState export reads the intended current table and produces the expected candidate cases before the later permanent write; preserve the manual merge and all subsequent joins.

### A16: If the author confirms Step 11B should inspect the current temporary REPsample11 made in Step 11A, change the read to WORK.REPsample11; if the pre-existing permanent member is intentional, retain it and document its producer.

Scopes: full_pipeline. Type: source_edit. Certainty: conditional.
Addresses: I008
Evidence: EV097, EV098, EV099, EV100

**Proposed edit:** `Data and Code Sharing/REPsampleprep.sas:1438–1438`
Source SHA-256: `59341c30a762a4d3d616368715fae86d59aeefbfdc6c771dff009f1a97061d61`

Conditional on author confirmation that the current WORK.REPsample11 from Step 11A is intended; the permanent REP.REPsample11 is first written later at line 1551.

Current text:
```
	set REP.REPsample11;
```

Proposed replacement:
```
	set REPsample11;
```

Preparation / proposed procedure:

1. Confirm whether Step 11B is meant to read a prior-run permanent REP.REPsample11 or the current WORK.REPsample11 created by Step 11A.
2. If the work table is intended, apply only the one-line conditional source edit and preserve the later final permanent write.

Validation to perform later:

- In clean staging, confirm the intended dataset is read for missing-age detection and that the downstream interpolation/manual-age merge receives the same sample_id population before the first permanent write.


## Remaining issues and prerequisites

- I001 [unresolved; full_pipeline]: The supplied branches depend on custom or externally prepared tables whose actual producer, output schema, location or compatible route is not established: InstOwnALL, normalized directors_14JUN2016, REPForm4Output, compiled Garmaise, MissingStateV2, gen_spec, TDC1_for_yonca, MissingAgeForHCv2 and BOARD_SUMMARY_CU. Required raw histories and prepared conversions remain unresolved where noted in the data requirements. Checklist edges D0022, D0023, D0033, D0060 and D0061 identify the generated ownership/director/generalist outputs whose producers remain unclosed.
- I002 [unresolved; full_pipeline]: REPsampleprep says REPsample11 is the Stata analysis input, but the package inventory has no author Stata analysis entry or exact downstream handoff. The actual Step 12 extension separately creates REPsample12 from REPsample11 with wealth, pension, deferred-compensation and severance variables. Without the analysis entry, it is unresolved whether the paper analyses consume REPsample11, the actual Step 12 REPsample12 handoff, or both. The independent reproduction code in this workspace is not part of the author package and does not close this gap. The requested Stata entry must state whether it consumes the actual Step 12 REPsample12 output, REPsample11, or both; neither use is inferred from a self-check read.
- I003 [unresolved; full_pipeline]: The source switches from local Z: libraries to WRDS [redacted-path-370bd853f4d7] for REPsampleprep Steps 2–8, then returns to local paths for Steps 9–12. REPsample1 must reach the WRDS REP directory, REPsample8 must reach the local Step 9 path, and the separate Table 2 program consumes REPsample11 and later Table2 across its WRDS/local boundary. Same basenames in separate locations do not prove the transfers or matching schemas occurred. The affected generated handoff edges are D0006, D0030, D0049, D0057 and D0059.
- I004 [unresolved; full_pipeline]: Actual Step 12 reads MISC.Deltavega2015, while the displayed local library setup defines REP, COMP, CRSP, FF, RISK, TFN and BOARDEX but no MISC assignment. The required site path/autoexec or intended library is unresolved. This setup gap is attached to dependency edge D0040.
- I005 [unresolved; full_pipeline]: The SAS 9.4 startup probe failed to load TKELS, so SAS execution availability/version is unverified in this environment. This diagnostic is not evidence of a missing license.
- I006 [unresolved; full_pipeline]: Both supplied return macros request CRSP.MSE with DATE and EVENT=DELIST. Local MSEALL and MSEDELIST candidates are readable but expose different bounded schemas; neither has been shown to match the legacy table semantics. Resolve the date/event mapping before using either. The unsupported legacy alias is recorded on dependency edges D0017 and D0055.
- I007 [unresolved; full_pipeline]: In Step 9, lines 1321–1325 build the current temporary WORK.REPsample9 and assign STATE_PriorFirm_Final. The missing-state export at line 1328 instead reads REP.REPsample9 from the permanent library, while the first write to permanent REP.REPsample9 is later at line 1338, after the MissingStateV2 merge. On a clean staging directory this is unresolved; the read may rely on a stale prior-run member unless the intended source is corrected. The specific read-before-producer dependency is D0031.
- I008 [unresolved; full_pipeline]: In Step 11A, the current sample is created as temporary WORK.REPsample11 and receives the TDC1 adjustment. Step 11B then reads REP.REPsample11 from the permanent library to find missing age, but the first permanent write of REP.REPsample11 is only at line 1551 after the intervening age calculation and hand-collected age join. In clean staging this is unresolved and may rely on a stale prior-run member; author intent is needed before changing the read. This is dependency edge D0037.
- R_EXTERNAL [undetermined]: The initial machine-readable CEO/employer table consumed as REP.External; its producer, exact schema, event population and local-to-WRDS handoff are not supplied.
- R_HCDATA [undetermined]: Hand-collected dates/gap records joined to REP.External by sample_id, with prior-firm identifiers and supplemental fields.
- R_COMPFUNDA [undetermined]: Compustat annual fundamentals used to calculate book equity, market value, BM, ROA, leads/lags and controls.
- R_ACO_PNFNDA [undetermined]: Compustat ACO_PNFNDA pension/postretirement asset field joined by GVKEY and DATADATE.
- R_COMPANY [undetermined]: Compustat COMPANY state field used to supplement prior-firm headquarters state.
- R_SEC_MTH [undetermined]: Compustat SEC_MTH security descriptor used for the Table 2 S&P 1500 restriction.
- R_EXEC_ANN [undetermined]: Execucomp annual observations used for current/lead TDC1/TDC2, age/gender, pension, deferred-balance, change-of-control and termination payments.
- R_COMP_ANN_LOCAL [undetermined]: Local COMP.ANNCOMP member read in Step 12 for prior-firm compensation; it is a separate library path from WRDS EXECCOMP.ANNCOMP.
- R_CCM_LINK [undetermined]: CRSP/Compustat link history used to resolve current and prior-firm PERMNO/PERMCO.
- R_STOCKNAMES [undetermined]: CRSP stock-name/security history used to identify current and prior-firm PERMNO/PERMCO.
- R_CRS_MSF [undetermined]: CRSP monthly stock file for returns, market value and rolling standard deviations.
- R_CRS_MSE [undetermined]: Legacy CRSP delisting-event input used with PERMNO, DATE, DLSTCD, DLRET and EVENT=DELIST.
- R_FF25 [undetermined]: Monthly 25 Size × Book-to-Market portfolio benchmark returns used in supplied return macros.
- R_ME_BREAKPOINTS [public_acquisition_required]: Monthly market-equity percentile breakpoints used to classify firms into five size groups.
- R_BEME_BREAKPOINTS [public_acquisition_required]: Annual book-to-market percentile breakpoints used to classify firms into five BM groups.
- R_INSTOWNALL [undetermined]: Prepared firm/report-date institutional ownership table with PERMNO/PERMCO, RDATE, institutional/block percentages and block-holder counts; main and Table 2 calls use different library paths.
- R_DIRECTORS14 [undetermined]: Externally generated directors_14JUN2016 table with normalized RiskMetrics fields, PERMCO, yearALT, meeting date and a unique director ID.
- R_FORM4 [undetermined]: Prepared REPForm4Output table used to assign prior-firm state from insider trades; code requires sample_id, prior PERMNO, prior-departure date, trade date, state and DateDiff.
- R_GARMAISE [undetermined]: Compiled state-year Garmaise enforceability index with State, year and gindex for lead/lag joins.
- R_MISSINGSTATE [undetermined]: Hand-collected MissingStateV2 supplement joined by sample_id for missing prior-firm states and foreign status.
- R_GENSPEC [undetermined]: Externally generated generalist/specialist table joined by sample_id, with CEO experience, firm, industry, position and conglomerate fields.
- R_TDC1_HC [undetermined]: Hand-collected TDC1 completion table used for current sample observations missing Execucomp compensation.
- R_MISSINGAGE_HC [undetermined]: Hand-collected MissingAgeForHCv2 supplement used after Execucomp-based age interpolation.
- R_NAVEEN_WEALTH [undetermined]: Lalitha Naveen compensation-incentives data used in actual Step 12 to add prior-firm firm-related wealth.
- R_BOARDEX_SUMMARY [undetermined]: Externally generated BOARDEX.BOARD_SUMMARY_CU consumed by the independent Table 2 governance branch.
- S_SAS [unverified]: The supplied preparation/Table 2 programs require SAS. A bounded startup check of sas_u8 failed at TKELS initialization; this does not establish an absent license or author-program compatibility. Preliminary package logs reflect an older SAS environment, while the current program version is not pinned.

## Review notes

- This checkpoint records source and documentation findings before catalog, exact-file, or software resource checks. It is intentionally incomplete.
- Assess the two current supplied SAS programs and their actual local/WRDS/local stages. The separate accepted-proposal PDF describes registered-proposal hypotheses and planned designs; those historical plans are contextual and are not automatically additional current entry points.
