# Patch proposal: jar-97e54651f961

Do Corporate Governance Analysts Matter? Evidence from the Expansion of Governance Analyst Coverage

DOI: 10.1111/1475-679X.12254

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied NL_code.do preparation workflow and its Table 1 sample-description and Table 2 analyses. The scope includes all six direct prepared-file reads and every generated Master/EM2 stage. Appendix-only analyses without supplied code (including the separate ISS proxy-voting table) are not independent targets.

Entry points: `NL_code.do`

Dependency closure: established for this scope.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 57/Issue 3/12254 - Do-Corporate-Governance-Analysts-Matter-Evidence-from-the-Expansion-of-Governance-Analyst-Coverage/lehmann-datasheet-and-code.zip",
      "sha256": "b38b97b2895ce8327017aa2cb5086ca7c12cb341647244126e81c4f3204d049b"
    },
    {
      "path": "JAR-Volume 57/Issue 3/12254 - Do-Corporate-Governance-Analysts-Matter-Evidence-from-the-Expansion-of-Governance-Analyst-Coverage/lehmann-online-appendix.pdf",
      "sha256": "ca47e516260cbf5f24769643c804f4439487ed6b4d3f69fde3e709ff70763f51"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "d1ef549f1f32ee1ed6bb0eef456d0fc58610f845b1a49e34a5c5756e4d47096b"
}
```

## Proposed actions

### ACT001: Confirm the exact author-prepared commercial and mixed-source inputs and their field/date contracts.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ001, REQ003, REQ004, ISS001
Evidence: SRC001, SRC002, SRC007, SRC008, SRC009, SRC011, SRC012, SRC018, INS001, CAT001

Preparation / proposed procedure:

1. Obtain or identify the exact author-prepared TR_data.dta, IBES_data.dta and TRAA_data.dta files intended for this NL_code.do version; provide a file manifest and codebook.
2. Confirm that TR_data combines the required Worldscope, Datastream and ASSET4 fields and preserves the dot-delimited wc05350 fiscal-year-end string, UK ISIN-year keys, units and full 2001–2009 panel; preserve the full population used by year-dummy indexing and pre-restriction winsor/PCA.
3. Confirm that IBES_data contains every column expanded by the two ordered Stata varlists, the named analyst/stock metrics, documented 60-day-before-FYE construction and coverage aligned to the full intended author panel. The catalog lists International unadjusted XEPS summary/actual candidates, but these do not establish the mixed prepared file or its exact construction.
4. Confirm the full TRAA ownership column range and ISIN-year coverage; catalog lookup returned no TRAA-named dataset, which is not evidence of absent access.
5. Keep provider access/entitlement status unknown until the exact user route is established; do not infer a blocked license from catalog presence, a catalog miss or historic provenance.

Validation to perform later:

- After an authorized handoff, perform bounded format-aware probes of each exact DTA input and compare all consumed fields, types, ISIN-year keys, duplicate behavior, full author period and measure units with NL_code.do.
- After data validation and a separate run authorization, execute the full workflow from the documented host-visible working directory and check generated Master files and Table 1/Table 2 outputs.

### ACT002: Confirm the two distinct ISS-related prepared inputs and current authorized availability.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ002, REQ005, ISS001
Evidence: SRC003, SRC004, SRC005, SRC010, SRC013, SRC020, INS001, CAT001

Preparation / proposed procedure:

1. Obtain or identify ISScoverage_data.txt and ISSFTSE_data.xlsx as separate inputs; confirm the first contains the UK CGQ/rating coverage fields used for 2003–2007 classification and that its year key matches the calendar fiscal-year year parsed from wc05350.
2. Confirm the second workbook has the Handcollected_Feb2018 sheet, usable Date and ISIN columns, WtCGI, and firm-year records compatible with the script merge; verify the imported Date type is suitable for the documented slash split.
3. Verify current user permission or another authorized source for each exact dataset separately; the catalog has no matching FTSE file and ISS catalog hits are unrelated, while historical confidentiality terms establish neither current entitlement nor universal access barriers.
4. Do not add the appendix-only ISS proxy-voting coverage series as a required Table 2 input unless a supplied code branch is identified.

Validation to perform later:

- After an authorized handoff, boundedly inspect the text and workbook sheet/headers; compare parsed year and ISIN coverage with TR_data and the 2003–2007 sample definition.
- After data validation and a separate run authorization, check merge uniqueness and the resulting treatment/control counts against the author’s reported sample.

### ACT003: Confirm the hand-collected governance workbook and its annual-report source/coding coverage.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ006, ISS001
Evidence: SRC004, SRC023, SRC024, SRC025, SRC030, SRC031, INS001, CAT001

Preparation / proposed procedure:

1. Obtain or identify GOV_data.xlsx with sheet data_new1 and confirm required variable names, first-row header handling, ISIN-year uniqueness and which three years produce the count==3 filter.
2. Request the exact issuer/year roster and annual-report/proxy-report provenance for the prepared GOV data, together with the coding crosswalk and treatment of missing/conflicting disclosures described in Appendix D.
3. If the prepared workbook is unavailable, verify an authorized report-by-report route for the named UK issuers and years before any manual collection; the frozen catalog documents SEC/LM corpora but not UK annual-report coverage, so do not assume they are compatible or scan them broadly.

Validation to perform later:

- After an authorized handoff, inspect the workbook sheet/header through a bounded read, verify all code-consumed columns, three valid GOVscore rows per retained ISIN and one row per ISIN-year, then compare the merge to Master4.
- After data validation and a separate run authorization, check the resulting Master5 sample and Table 2 outcomes against author outputs.

### ACT004: Confirm the input year sequence and common firm-year key before relying on the hardcoded year-dummy positions.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: REQ001, REQ002, REQ003, REQ004, REQ005, ISS002
Evidence: SRC007, SRC009, SRC018, SRC019, SRC020, SRC033, SRC039, CAT001

Preparation / proposed procedure:

1. Confirm the full TR_data year universe is 2001–2009 and that each of the nine calendar years appears in the imported panel before tab year, gen(year_).
2. Confirm the later assumptions year_3…year_7 = 2003–2007 and year_1/year_2/year_8/year_9 are the intended off-window years.
3. Confirm every merged source year variable uses the fiscal-year-end calendar year parsed from wc05350 and the ISIN identifier matches wc06008; distinguish year from fyear.
4. Preserve the stated 2001–2009 population for transformations run before sample restrictions. The code’s one-year lag is already supported by that panel; do not extend the input back to 2000 without author evidence.

Validation to perform later:

- After an authorized file handoff, boundedly inspect the distinct year values and key types for each prepared input; confirm the nine-year sequence and ISIN-year join behavior.
- After data validation and separate run authorization, compare sample and treatment counts for 2003–2007 construction and 2004–2006 Table 2 periods with the author-reported outputs.

### ACT005: Choose the local Table 2 output-retention behavior during run preparation: keep the supplied last-panel-only placeholder behavior, or retain all panels under separate panel-specific filenames in a working copy.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: ISS003
Evidence: SRC027, SRC028, SRC029

Preparation / proposed procedure:

1. If the supplied final-only output is sufficient, leave the existing Platzhalter.rtf destinations and replace/append sequence unchanged; no confirmation is needed.
2. If retaining all Table 2 panels, in a working copy route every Panel A `esttab using` write to Table2_PanelA.rtf, every Panel B write to Table2_PanelB.rtf, and every Panel C write to Table2_PanelC.rtf. Preserve the initial replace and later append behavior within Panel A, preserve each panel’s existing replace behavior, and keep every estimation and affected output write.
3. Treat the filenames as ordinary local output choices. Do not add a Table 1 export or change any regression, sample, variable, or estimation specification.

Validation to perform later:

- Review the working-copy diff to confirm it changes only Table 2 output filename operands and preserves every estimation and affected write, including the existing replace/append sequence.
- After any separately authorized run, verify that each intended Table 2 panel is retained in its own RTF; if preserving the supplied behavior, verify that Platzhalter.rtf contains the final Panel C output.

### ACT006: Configure a relative Stata working directory for the supplied do-file after inputs are verified.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: run procedure
Evidence: SRC007, SRC010, SRC011, SRC012, SRC013, SRC014, SRC021, SRC023, SRC025, SRC027, SRC028, SRC029

Preparation / proposed procedure:

1. Use a host-visible, writable working directory containing NL_code.do and all six exact prepared inputs; the code uses bare relative paths and has no cd or absolute-path setup.
2. Keep the Stata wrapper execution root and the do-file/current directory aligned. Use relative paths or a documented [redacted-path-4350499d7cdf] path in host configuration; do not hard-code the Dropbox workspace path into the author script.
3. After a separate run authorization, invoke Stata 18 in batch mode from that directory with stata -b do NL_code.do. Keep generated Data2–Data5, Master1–Master5, EM2data4_s1/s2/ALL, Handcollected_ISSGOV6 and result files in the designated writable output root.

Validation to perform later:

- Before any future run, verify host visibility and write permission for the selected relative root and that all six named inputs resolve there.
- During a separately authorized future run, confirm the generated intermediates appear in producer-before-consumer order and review the clarified Table 1/Table 2 outputs.


## Remaining issues and prerequisites

- ISS001 [unresolved; full_pipeline]: The frozen package supplies the Stata do-file, documentation, online appendix and NL_identifiers.dta, but not the six direct files read by NL_code.do. The author documentation identifies upstream providers and some timing/definitions, yet does not provide exact schemas, current authorized access, and complete field/year coverage for the prepared TR_data, ISS, mixed IBES/stock, TRAA, ISS/FTSE and hand-collected GOV inputs. Confirm the author-prepared file manifest and route; the historical ISS/RMG/FTSE agreements do not prove a current access barrier.
- ISS002 [unresolved; full_pipeline]: NL_code.do creates year dummies from the observed sorted year values, then hardcodes year_1, year_2 and year_8/year_9 as the outside years and year_3–year_7 as 2003–2007. The code comment describes a 2001–2009 TR_data panel, but the input is absent; missing or extra year categories would shift the dummy positions and alter the sample/treatment definitions. Confirm the complete nine-year input year sequence and that all firm-year inputs use the same fiscal-year-end calendar year key. No extra 2000 requirement is inferred solely from the one-year lag.
- ISS003 [preparation; full_pipeline]: The supplied Table 2 writes to the same placeholder file, Platzhalter.rtf. Panel A begins with replace and appends its remaining results; Panels B and C each use replace, so the final file contains only Panel C. This behavior is established by the supplied code. Retaining all three panels can be handled during ordinary output preparation by routing each panel’s existing writes to a separate local RTF in a working copy; if retaining only the final Panel C output is sufficient, the supplied behavior can remain. No author confirmation is needed to choose local output names, and no analysis or scientific definition changes are indicated.
- REQ001 [undetermined]: Author-prepared joint TR_data.dta input consumed as one Stata panel. It must combine Worldscope accounting/identity fields, Datastream financial and market fields, and ASSET4 score fields named in NL_code.do (including wc05350, wc06001, wc06008, wc07536, wc07021, wc05661, wc03251, wc02501, wc02999, dwta, dwse, wc03501, wc01001, wc04001, wc04860, wc05101, wc05001, mv, nosh, noshff, cgvscore). The code expects a dot-delimited fiscal-year-end string, forms calendar year, and documents a UK panel for 2001–2009. Keep the full documented panel because year_1…year_9 indexing, whole-panel winsorization and PCA/sample construction precede the 2003–2007 balanced sample and 2004–2006 Table 2. The code also uses a one-year sales lag; do not extend earlier than the documented panel solely on that basis. The joined schema, field types/units, supplier joins and period coverage are not available for inspection.
- REQ002 [undetermined]: ISScoverage_data.txt is the UK ISS governance-rating coverage input. NL_code.do uses countrycgq, country, indexcgq, isinmanuallycompleted and year, filters to the United Kingdom, then merges on ISIN-year and uses coverage for the 2003–2004 versus 2005–2007 treatment/control definitions. It is merged into the full 2001–2009 master panel before sample construction; confirm the intended coverage and that year is the fiscal-year-end calendar year expected by the other inputs. Historical RMG/ISS provenance does not establish current access or a barrier.
- REQ003 [undetermined]: IBES_data.dta is the mixed I/B/E/S and stock-metrics author-prepared firm-year input. NL_code.do labels RECNOmedian_m60FY, F1NEmedian_m60FY, MVmedian_m60FY, RV_m60FY, BASmedian_m60FY, ZTDmean_m60FY and TOmedian_m60FY as 60-day-pre-fiscal-year-end measures and uses ordered variable ranges for analyst following and liquidity. Confirm the complete range schema, the mixed-source construction and coverage; the script expects isin and year for the ISIN-year merge and computes winsor/PCA sample inputs before restricting to final periods. Local I/B/E/S XEPS-family products are only discovery candidates. The do-file’s ordered list repeats some field names; this contract records each field once, and the cited source lines preserve the literal code.
- REQ004 [undetermined]: TRAA_data.dta is the firm-year institutional-ownership input. NL_code.do uses the exact file, labels IB_InvManNonIndex and OTCountInvMan_nonIndex, and constructs ownership measures across the OwnTypCount_ALL–IB_OthersNonIndex and IB_ALL–IB_OthersNonIndex variable ranges. Confirm the complete schema, identifier/year key and intended coverage before merging; it is joined to the full prepared firm-year panel and contributes to PCA/sample selection before the final period restriction.
- REQ005 [undetermined]: ISSFTSE_data.xlsx sheet Handcollected_Feb2018 is a separate ISS/FTSE index-membership input. The reader expects Date and isin and later uses WtCGI; code derives year by splitting Date on slash and merges on ISIN-year. It remains in scope because the supplied preparation script reads and transforms it, even though Table 2 does not use an index-inclusion outcome directly. Confirm the exact sheet/header, that Excel import yields a Date value compatible with split Date, membership dates/firm coverage and current permitted access; do not infer an Excel header repair from the missing workbook.
- REQ006 [undetermined]: GOV_data.xlsx sheet data_new1 is the hand-collected UK governance input used to form GOVscore and Master5. The code expects isin, year, Board1all, Board2all, Comp1all, Audit1all, BoardSize, CGQdata, annualreport and proxyreport, converts four YES indicators, retains ISINs with three nonmissing GOVscore observations, and merges by ISIN-year. The exact workbook, firm/report list and the years corresponding to the three observations are not supplied.

## Review notes

- The work item lists 12 frozen dependencies: D0001–D0006 map to the six direct required inputs, and D0007–D0012 map to files produced by the supplied do-file. Every ID is now reviewed with source evidence.
- NL_code.do directly reads six prepared file names while the datasheet describes nine source categories; TR_data is joint Worldscope/Datastream/ASSET4, IBES_data mixes I/B/E/S and stock measures, and the supplied code does not contain a separate ISS proxy-voting read. Appendix Table A7 remains outside the supplied code target.
- Program dependency closure is accounted for, but all six required input routes remain unverified. The package-level NL_identifiers.dta probe is not an analysis-input route.
- The local catalog search records candidates only. It does not verify current SAS file access, user entitlement, UK historical coverage, the author’s prepared-file constructors or a substitute route. No live vendor inputs or UK annual reports were probed or scanned.
- The coordinator’s self-written Stata 18 zero-record probes confirmed `use <file>, replace` loads an empty file and clears an unsaved zero-observation variable definition (PRB005). This does not test author data, author code, or path/input compatibility; no defect or source repair is supported for this option alone. No author script or regression was executed.
- TR_data’s documented 2001–2009 period is kept separate from the later 2003–2007 balanced-panel logic and 2004–2006 Table 2 estimation. No 2000 input requirement is inferred from the one-year lag.
