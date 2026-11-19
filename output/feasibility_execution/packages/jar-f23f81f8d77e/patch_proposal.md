# Patch proposal: jar-f23f81f8d77e

Do Commercial Ties Influence ESG Ratings? Evidence from Moody’s and S&P

DOI: 10.1111/1475-679X.12582

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied workflow: 11 ordered SAS data-preparation/table stages, including the Step 3 firm-matching step, followed by the supplied Stata table analyses and all seven matching SAS-to-Stata dataset handoffs.

Entry points: `code.sas`, `code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "identity_notes": [
    "The same source DOI is associated with multiple paper folders; no folders were merged.",
    "Source titles conflict for this DOI; original publication metadata is retained for review."
  ],
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 62/Issue 5/12582 - Do-Commercial-Ties-Influence-ESG-Ratings-Evidence-from-Moodys-and-S-P/llz-datasheet-2024-code-identifier-log-files.zip",
      "sha256": "94324036c227b313df245201420cfe058085b3b64b6ff5da23acf028ca4f2489"
    },
    {
      "path": "JAR-Volume 62/Issue 5/12582 - Do-Commercial-Ties-Influence-ESG-Ratings-Evidence-from-Moodys-and-S-P/llz-online-appendix-2024.pdf",
      "sha256": "99004bee75fcf4fcd2afbb41c9add32729d149f3513d50f92ed42acf2a4f10f8"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b44d1ab3b3d5f005fd9723448386ffc9b76b241e68a80d5269fd5d92afff49a5",
  "work_item_sha256": "b2e07b29d23f27a4d3aa479665ddcc1d2b0b7a8f293bfa6955a44edc434b0db9"
}
```

## Proposed actions

### A_RAW_PRODUCTS: Complete the source mappings for the supplied 39 product tables by carrying the code-required fields, identifiers and year/date windows into compatible local prepared tables or another supported product route. The selected catalog candidates are starting points only where route records say compatibility remains unverified.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: I_INPUT_MAPPING, R_MOODY_ESG, R_WS_FUNDA, R_WS_STOCK, R_WS_COMPANY, R_IBES_INT, R_IBES_US, R_FACTSET_OWNERSHIP, R_CIQ_ISIN, R_SP_ESG, R_SP_COUNTRY_MAP, R_MOODY_ENTITY_RATING, R_MOODY_SECURITY_RATING, R_MOODY_SECURITY_INFO, R_MOODY_ENTITY_INFO, R_MOODY_COUNTRY, R_MOODY_ENTITY_IDS, R_SP_ENTITY_RATING, R_SP_ENTITY_SECURITY_IDS, R_SP_SECURITY_RATING, R_REFINITIV_ESG, R_MSCI_ESG, R_SUST_RATING, R_SUST_RISK_IDS, R_SUST_RISK, R_FACTSET_PRICE, R_FACTSET_HOLDINGS, R_BLOOMBERG_ESG, R_REFINITIV_GREEN_BOND, R_SDC_BOND_ISSUE, R_MOODY_SECURITY_IDS, R_SP_SECURITY_INFO, R_TV_ISIN_IDS, R_TV_ENTITY_IDS, R_TV_ORG_IDS, R_TV_ESG, R_TV_VOLUME, R_REPRISK_INCIDENTS, R_REPRISK_IDS, R_TRUCOST_EMISSION
Evidence: E_DOC_PRODUCTS, E_WORKFLOW_TRACE, E_CAT_A, E_CAT_B, E_CAT_C, E_CAT_D, E_CAT_FOLLOWUP_A, E_CAT_FOLLOWUP_B, E_CAT_FOLLOWUP_C, E_CAT_SOURCE_FIELDS, E_LOCAL_SAS_PROBES, E_SRC_MOODY_ESG, E_SRC_WORLDSCOPE_FUNDA, E_SRC_WORLDSCOPE_STOCK, E_SRC_WORLDSCOPE_COMPANY, E_SRC_IBES_DET_EPS_INT, E_SRC_IBES_DET_EPS_US, E_SRC_FACTSET_OWNERSHIP, E_SRC_SP_CAPITALIQ_ISIN, E_SRC_SP_ESG, E_SRC_SP_ESG_WORLDSCOPE_COUNTRY, E_SRC_MOODY_CREDIT_ENTITY_RATING, E_SRC_MOODY_CREDIT_SECURITY_RATING, E_SRC_MOODY_CREDIT_SECURITY_INFO, E_SRC_MOODY_CREDIT_ENTITY_INFO, E_SRC_MOODY_CREDIT_COUNTRY, E_SRC_MOODY_CREDIT_ENTITY_IDS, E_SRC_SP_CREDIT_ENTITY_RATING, E_SRC_SP_CREDIT_ENTITY_SECURITY_IDS, E_SRC_SP_CREDIT_SECURITY_RATING, E_SRC_REFINITIV_ESG, E_SRC_MSCI_ESG, E_SRC_SUSTAINALYTICS_ESG_RATING, E_SRC_SUSTAINALYTICS_ESG_RISK_IDS, E_SRC_SUSTAINALYTICS_ESG_RISK, E_SRC_FACTSET_PRICE, E_SRC_FACTSET_HOLDINGS, E_SRC_BLOOMBERG_ESG, E_SRC_REFINITIV_GREEN_BOND, E_SRC_SDC_BOND_ISSUE, E_SRC_MOODY_CREDIT_SECURITY_IDS, E_SRC_SP_CREDIT_SECURITY_INFO, E_SRC_TRUVALUE_ISIN_IDS, E_SRC_TRUVALUE_ENTITY_IDS, E_SRC_TRUVALUE_ORG_IDS, E_SRC_TRUVALUE_ESG, E_SRC_TRUVALUE_ESG_VOLUME, E_SRC_REPRISK_ESG, E_SRC_REPRISK_ESG_IDS, E_SRC_TRUCOST_EMISSION

Preparation / proposed procedure:

1. Use the probed Worldscope and I/B/E/S tables for the exact source fields and key/year joins in code.sas; verify sample-window coverage and the annual/prior-year alignment.
2. Assess the CIQ, SDC, TRESG, RepRisk and Trucost candidates against the source-to-target mappings recorded above, including issue/tranche identity, rating type, ESG score semantics, firm identifiers and coded emission-item definitions.
3. For remaining source families with no matching local candidate, prepare compatible product tables with the source fields and history the code reads; do not require byte-identical vintage where a compatible route is supported.
4. Apply ordinary path/libref configuration, file conversion and data cleaning in a portable working copy once a compatible source mapping is established.

Validation to perform later:

- Before any separately authorized full run, confirm each prepared input exposes the code-required keys and fields for its actual date window; preserve coverage limits and any unresolved provider mapping.

### A_FUZZY_MATCH: Prepare the missing reviewed firm crosswalk for the supplied Step 3 mapping and make its SAS import compatible with the intended environment, while preserving the authored vigeokey-to-MAST_ISSR_NUM mapping and review provenance.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_FUZZY_CHECKED, I_FUZZY_MATCH, I_SAS_EXCEL_IMPORT_PORTABILITY
Evidence: E_FUZZY_EXPORT, E_FUZZY_CODE_COMMENT, E_FUZZY_IMPORT, E_IDENTIFIER_PROBE, E_SAS_EXCEL_IMPORT_CONTRACT, E_SAS_EXCEL_WINDOWS_DOC, E_SAS_XLSX_UNIX_DOC

Preparation / proposed procedure:

1. Obtain or prepare the reviewed Fuzzy_Checked.xlsx mapping through a supported ordinary route, preserving the authored vigeokey-to-MAST_ISSR_NUM fields and match-review provenance; the workbook is currently absent. Keep Identifier.xlsx separate unless a supported mapping contract establishes it as the named crosswalk.
2. For the supplied import block, first confirm the actual workbook format and intended SAS/ACCESS capability. If the workbook and installed SAS/ACCESS release support direct XLSX import under UNIX, use a compatible XLSX route for the same sheet; otherwise use a supported compatible Windows or PC Files Server setup.
3. Check that Sheet1 exists, GETNAMES=YES yields the expected headers, and imported values retain the intended identifier/date types. Use only options supported by the chosen DBMS; do not carry MIXED=NO, SCANTEXT=YES, USEDATE=YES or SCANTIME=YES over blindly or treat an untested source rewrite as complete.

Validation to perform later:

- Once the workbook is available, verify its sheet, headers and type handling against the reviewed mapping and the selected import route. Preserve review provenance. The SAS/ACCESS installation and workbook contract remain unknown; no import trial or source edit is claimed.

### A_SOFTWARE_SETUP: Prepare the unavailable Stata add-ons outreg2 and ttable3 in the intended environment and establish the unverified SAS prerequisite; Stata 18, reghdfe and ebalance have successful metadata proofs.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: I_SOFTWARE_SETUP, SW_SAS, SW_OUTREG2, SW_TTABLE3
Evidence: E_ENV_SAFE_PROJECTION, E_SOFT_REGHDFE, E_SOFT_OUTREG2, E_SOFT_TTABLE3, E_SOFT_EBALANCE, E_DOC_SOFTWARE, E_ENVIRONMENT_CAPTURE, E_SOFT_TTABLE3_CHECK, E_SOFT_EBALANCE_CHECK

Preparation / proposed procedure:

1. Use the available Stata 18, reghdfe and ebalance proofs as recorded; make outreg2 and ttable3 available through ordinary add-on setup in the intended Stata lookup paths before their table steps.
2. Establish the required SAS environment and configure portable librefs and working roots without relying on hidden author-machine paths.

Validation to perform later:

- Before any separately authorized workflow, record the intended SAS/Stata versions and confirm required add-on availability. This assessment ran only frozen bounded version/which metadata helpers; no author program, statistical workflow, model run or installation was performed.


## Remaining issues and prerequisites

- I_INPUT_MAPPING [unresolved; full_pipeline]: The supplied workflow reads 39 external product tables plus Fuzzy_Checked.xlsx. Exact frozen-catalog searches and selected one-row local checks find usable candidates for some Worldscope/IBES/Capital IQ/SDC/Refinitiv ESG/RepRisk/Trucost components, but do not verify full source-field meanings, identifiers, product versions or historical coverage. Several named families have no compatible frozen-catalog candidate. The package contains no SAS input panels; candidate mappings and 2011–2021 credit / 2014–2018 pre-period / 2016–2021 ESG windows remain unverified.
- I_FUZZY_MATCH [unresolved; full_pipeline]: Step 3 exports unmatched ESG and credit firm lists, imports Fuzzy_Checked.xlsx and uses reviewed mappings to create output.step32. The named workbook is absent from the package. A SAS source comment locates a Python fuzzy-match step in a log, but the unread log does not establish its contents; the actual matching/review provenance and imported sheet contract remain unresolved. The separately supplied Identifier.xlsx is a bounded one-row event/isin file, not a supported substitute.
- I_SOFTWARE_SETUP [preparation; full_pipeline]: Stata 18, reghdfe and ebalance are captured available. outreg2 and ttable3 were not found in the checked Stata lookup paths; the supplied workflow also needs SAS, whose registered status remains unverified. These are setup/verification tasks, not evidence of an access barrier.
- I_SAS_EXCEL_IMPORT_PORTABILITY [preparation; full_pipeline]: The supplied SAS block imports Fuzzy_Checked.xlsx with DBMS=EXCEL and requests Sheet1$, GETNAMES=YES, MIXED=NO, SCANTEXT=YES, USEDATE=YES and SCANTIME=YES. The official SAS/ACCESS 9.4 reference lists the EXCEL engine on Microsoft Windows and documents direct XLSX handling under UNIX. For Linux SAS, prepare a supported route for the same reviewed workbook or use a compatible Windows/PC Files Server environment; check the workbook sheet, headers, types and only options supported by the selected route. The workbook and SAS/ACCESS capability remain unknown, and no import or source edit was tested.
- R_FUZZY_CHECKED [undetermined]: Reviewed firm-name crosswalk imported from Fuzzy_Checked.xlsx to link unmatched Moody ESG vigeokey values to Moody credit MAST_ISSR_NUM values. The included Identifier.xlsx (event, isin) is not the named crosswalk and does not establish this mapping.
- R_MOODY_ESG [undetermined]: Monthly ESG and firm identity: vigeokey, produceddate, globalscore, ISIN, country, title and LEI. Code forms 2016–2021 month ends, carries the latest produceddate at or before each month end, then averages globalscore by firm and year. The same identifiers feed the Moody credit match.
- R_WS_FUNDA [undetermined]: Annual company records keyed by ITEM6105 and matched by ISIN ITEM6008; code requires year_, Freq="A", ITEM5350 date and nonmissing ITEM2999, then uses ITEM7230, ITEM3501, ITEM2501, ITEM3255, ITEM18191, ITEM8631, ITEM1201, ITEM2001 and ITEM4551 for controls. ESG year joins to the prior fiscal year; the authored panel is 2016–2021.
- R_WS_STOCK [undetermined]: ITEM6105 and year_ link the stock record to annual fundamentals; ITEM8002 supplies same-year market capitalization for Tobin Q.
- R_WS_COMPANY [undetermined]: ITEM6105 links company records; ITEM6026 supplies the Worldscope country and ITEM7021 the industry for the ESG firm-year panel.
- R_IBES_INT [undetermined]: Code joins ITEM6038 to ticker, counts distinct analys by anndats year, and uses the year before each ESG firm-year. This is the international detail panel, separate from the US table.
- R_IBES_US [undetermined]: Code joins ITEM6038 to ticker, counts distinct analys by anndats year, and uses the year before each ESG firm-year. This is the US detail panel, separate from the international table.
- R_FACTSET_OWNERSHIP [undetermined]: Code needs ISIN, quarter and io; derives year from quarter/100 and averages ownership by ISIN in the year before each ESG observation.
- R_CIQ_ISIN [undetermined]: Code needs isin, companyid, startdate and enddate. It matches ESG years and bond/green-bond issue dates only within the identifier interval.
- R_SP_ESG [undetermined]: Code needs cid, year and ESG, plus country and ticker for Worldscope linking. It creates 2016–2021 firm-year rows and merges source ESG by cid and year.
- R_SP_COUNTRY_MAP [undetermined]: Code maps the S&P country field to Worldscope ITEM6026 and adjusts S&P tickers for the specified country formats before joining annual fundamentals.
- R_MOODY_ENTITY_RATING [undetermined]: Code needs MAST_ISSR_NUM, RATG_DATETIME, RATG_EXPIRE_DATETIME and ISSR_RATG_TXT. It carries active ratings into a 2011–2021 issuer-year panel and uses the latest valid issuer rating at bond issue date.
- R_MOODY_SECURITY_RATING [undetermined]: Code needs MAST_DEBT_NUM, RATG_CLSS_NUM, RATG_DATETIME, RATG_END_DATETIME and RATG_TXT; it counts valid ratings by issuer/security/class over the 2011–2021 panel.
- R_MOODY_SECURITY_INFO [undetermined]: Code joins by MAST_DEBT_NUM to add MAST_ISSR_NUM and, for bond records, uses FIRST_LT_RATG.
- R_MOODY_ENTITY_INFO [undetermined]: Code joins MAST_ISSR_NUM to ISSUER_NAM and MDY_DOMN_NUM when assembling the credit-firm list.
- R_MOODY_COUNTRY [undetermined]: Code joins MDY_DOMN_NUM to DOMN_NAM for the issuer country used in matching and panel construction.
- R_MOODY_ENTITY_IDS [undetermined]: Code joins MAST_ISSR_NUM to ISSR_ID, filtered to ISSR_ID_NUM="LEI", to match Moody ESG firms through LEI before the reviewed crosswalk.
- R_SP_ENTITY_RATING [undetermined]: Code needs company_id, ratingtypecode, ratingdate, ratingtime and ratingsymbol, carries rating intervals through 2011–2021 and uses STDLONG issuer ratings at bond issue date. A local CIQ issuer-rating table is only a candidate because product/version and history are not established.
- R_SP_ENTITY_SECURITY_IDS [undetermined]: Code needs companyid and security_id to link each S&P ESG firm to security-level ratings. The exact entity/security link table was not matched in the catalog.
- R_SP_SECURITY_RATING [undetermined]: Code needs security_id, ratingtypecode, ratingdate, ratingtime and ratingsymbol, constructs validity intervals and counts non-NR security ratings by firm-year.
- R_REFINITIV_ESG [undetermined]: Code joins isin and fyear to ESGCombinedScore in the same firm-year. TRESG.WRDS_ESG_CATSCORES has a readable Score/FisYear/FeedDate/OrgID candidate and TRESG.WRDS_COMPANY_INFO has OrgID/Isin, but the catalog and one-row checks do not establish that Score is the required ESGCombinedScore or verify year coverage.
- R_MSCI_ESG [undetermined]: Code needs ISSUERID, ISSUER_ISIN, AS_OF_DATE and weighted_average_score; links issuer ISIN and averages the score by year for the matched firms. KLD.HISTORY is not an equivalent overall-score field map.
- R_SUST_RATING [undetermined]: Code needs CapitalIQ_ID, date and total_esg_score; extracts the company identifier from CapitalIQ_ID and averages ratings by year.
- R_SUST_RISK_IDS [undetermined]: Code needs EntityId and isin to connect the provider risk series to matched ESG firms.
- R_SUST_RISK [undetermined]: Code needs EntityId, file_date and ESG_Risk_Score; averages within year, reverses score sign, and coalesces with the ratings series for the matched year.
- R_FACTSET_PRICE [undetermined]: Code needs FSYM_ID, price_date, price and shares_outstanding, retains the latest observation in each firm-quarter, and joins the prior quarter to calculate turnover.
- R_FACTSET_HOLDINGS [undetermined]: Code needs factset_entity_id, FSYM_ID, quarter, io and isin; aligns current and prior-quarter holdings and computes the 2014–2018 institutional turnover measure.
- R_BLOOMBERG_ESG [undetermined]: Code needs isin, year and esgdiscscore; averages the pre-event 2014–2018 disclosure score.
- R_REFINITIV_GREEN_BOND [undetermined]: Code needs ISIN, IssueDate, green-issue identification and bond_amount for 2016–2021, then maps companyid through dated Capital IQ ISIN intervals and computes pre/post counts and amounts.
- R_SDC_BOND_ISSUE [undetermined]: Code needs Bond_ID, Issuer, IssueDate, ISIN, Country, Industry, Bond_Amount, Bond_Yield and Bond_Maturity for 2016–2021; it joins security/issuer ratings and firm-year treatment, then excludes Fannie Mae and Freddie Mac. SDC.WRDS_NI_DETAILS is a local new-issue candidate whose differently named deal/tranche, date, principal, yield, maturity, name, ISIN, nation and industry fields need an explicit contract and tranche mapping.
- R_MOODY_SECURITY_IDS [undetermined]: Code needs ID_NUM, ID_NUM_CD and MAST_DEBT_NUM, filters ID_NUM_CD="ISI", and maps bond ISIN to Moody debt identifiers.
- R_SP_SECURITY_INFO [undetermined]: Code needs isin and security_id to match bond ISINs to S&P security ratings.
- R_TV_ISIN_IDS [undetermined]: Code needs isin and FSYM_ID to start the provider-specific identifier chain.
- R_TV_ENTITY_IDS [undetermined]: Code needs FSYM_ID, FACTSET_ENTITY_ID, START_DATE and END_DATE to construct the valid entity interval.
- R_TV_ORG_IDS [undetermined]: Code needs FACTSET_ID and PROVIDER_ID to map FactSet entity identifiers to TV_ORG_ID.
- R_TV_ESG [undetermined]: Code needs TV_ORG_ID, TV_DATE and INSIGHT_SCORE; it joins within identifier validity intervals, uses the future year, and averages only years with at least 180 scored days.
- R_TV_VOLUME [undetermined]: Code needs TV_ORG_ID, TV_DATE and ARTICLE_VOLUME, matched to the insight record and screened at a minimum of five articles before annual scoring.
- R_REPRISK_INCIDENTS [undetermined]: Code needs reprisk_id, incident_date and severity, classifies severity 2 or 3 as severe and joins the future year to the matched firm panel. The RepRisk V2 incident table has matching field names, but coverage/version compatibility remains unverified.
- R_REPRISK_IDS [undetermined]: Code needs primary_isin and reprisk_id to join matched firm ISINs to incident records. The RepRisk V2 company identifiers candidate exposes these names; history and coverage are unverified.
- R_TRUCOST_EMISSION [undetermined]: Code needs companyid, fiscalyear, S1, S2, S3_Up and S3_Down, then joins the following fiscal year. Local TRUCOST.WRDS_COMPANIES exposes institutionid/companyid and WRDS_ENVIRONMENT exposes institutionid/fiscalyear/periodenddate plus coded di_* fields; the source-category definitions and mapping to all four code inputs remain unverified.
- SW_SAS [unverified]: The supplied datasheet requires SAS. The registered environment capture projects SAS status as unverified with no version token; no SAS executable, startup, autoexec or PROC check was made in this assessment.
- SW_OUTREG2 [preparation_required]: The supplied Stata program writes tables with outreg2. The registered safe projection reports it unavailable in both checked Stata lookup paths; make it available in the intended Stata environment before attempting the workflow.
- SW_TTABLE3 [preparation_required]: The supplied Stata program calls ttable3. The frozen Stata 18 version/which helper did not find it (which return code 111); make it available in the intended Stata lookup paths before the descriptive table step.

## Review notes

- The static trace covers the supplied 11 ordered SAS stages, including Step 11 switch-firm and bond branches, and seven exact SAS-to-Stata export basenames consumed by code.do. All 66 frozen dependency IDs now have exactly one review; D0001-D0007 are generated exports, not external raw data.
- The code has 39 direct raw product-table inputs and the separate reviewed Fuzzy_Checked.xlsx crosswalk. Each input requirement records the source fields, keys, joins and relevant source period; no raw SAS input panel is packaged. Identifier.xlsx is a different bounded one-row event/isin workbook.
- Selected one-row local probes verified readable source columns for Worldscope, I/B/E/S, CIQ, SDC new issues, TRESG, RepRisk V2 and Trucost candidates. These checks do not establish full history, population coverage, source-version semantics or score/emissions definitions; route mappings remain unverified where those details are outstanding.
- The frozen catalog returned no direct matching table/field candidate for the authored Moody credit/ESG identifiers, FactSet holdings/price, Bloomberg ESG, Sustainalytics, Truvalue, or the authored MSCI overall-score fields. This is a catalog finding, not evidence that no vendor/public route exists or that any license/access barrier applies.
- The registered safe software projection reports Stata 18 and reghdfe 6.12.3 available and outreg2 unavailable in the checked paths; the additional frozen Stata 18 version/which helpers found ebalance and did not find ttable3. SAS remains unverified. These bounded metadata helpers ran, but no author SAS/Stata program, statistical workflow, model run or installation was run. Exact commands, cwd, separate streams, return codes, elapsed times, hashes and capture limits are retained in probes/software_metadata_invocations.json.
- An auxiliary catalog lookup runner stopped at its local frozen-pin guard before invoking any query; its exact combined tool output is retained with separate streams and numeric return code null because the wrapper did not expose them. The corrected frozen-helper field lookup completed successfully.
- Process/method limit from the earlier environment summary: a read-only summary emitted one non-whitelisted SAS diagnostic field. No credential/license value or raw log body was displayed or retrieved. Its text and original capture fields remain unavailable (NULL), and this does not establish credential exposure, an access barrier or a runtime blocker.
- All 95 code-source evidence windows were group-checked through the saved safe reader against original source line labels and withheld spans, including the supplied SAS import contract; all literal quotes matched. No source facts or route mappings were changed during citation reconciliation.
- Pinned finalizer preflight requires each available software row to cite its successful helper JSON. Stata and reghdfe continue to cite the original registered environment probe; ebalance cites its exact matching Stata 18 version/which result. The safe environment projection remains a reporting view, and raw helper logs were not read.
- The pinned finalizer preflight also required explicit proposal-action targets for every known prerequisite. A_RAW_PRODUCTS now addresses all 39 raw-source requirements; A_SOFTWARE_SETUP addresses the four nonavailable/unverified software prerequisites. Scientific descriptions, severities and routes are unchanged.
- The supplied SAS import block uses DBMS=EXCEL for Fuzzy_Checked.xlsx and requests Sheet1$ with GETNAMES=YES and additional type/date options. The official SAS/ACCESS 9.4 reference supports a conditional XLSX-under-UNIX route or a compatible Windows/PC Files Server setup. The workbook, its reviewed mapping provenance and SAS/ACCESS capability remain unknown; no import attempt or source edit is claimed.
