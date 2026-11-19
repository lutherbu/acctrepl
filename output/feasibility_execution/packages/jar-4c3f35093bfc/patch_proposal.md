# Patch proposal: jar-4c3f35093bfc

How Does Financial-Reporting Regulation Affect Industry-wide Resource Allocation?

DOI: 10.1111/1475-679X.12345

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Full documented workflow: BvD Amadeus 2005–2015 disc extraction and WRDS 2016 preparation, Europe company/panel/outcomes/regulation/scope/data/analysis/identifier outputs; separate Germany local coverage followed by secure URS/GWS FDZ work, screened outputs returned for local figures; and Statistics KLEMS/OECD/WIOD outputs.

Entry points: `Data & Code/IGM-BvD_Amadeus/Programs/STATA_Amadeus.do`, `Data & Code/IGM-BvD_Amadeus/Programs/SAS_Amadeus_WRDS.sas`, `Data & Code/IGM-BvD_Amadeus/Programs/SAS_Conversion_to_STATA.sas`, `Data & Code/Project_Europe/Programs/Setup.do`, `Data & Code/Project_Germany/Programs/Setup.do`, `Data & Code/Project_Statistics/Programs/Setup.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "identity_notes": [
    "Multiple original archive variants share this paper folder; each retains its own package ID."
  ],
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 1/12345 - How-Does-Financial-Reporting-Regulation-Affect-Industry-wide-Resource-Allocation/breuer-datasheet-code-and-identifiers.zip",
      "sha256": "81606890bfbaf7d651d321d344f0860c3a48d7b87e5c14ea606f3a09e185d3ae"
    },
    {
      "path": "JAR-Volume 59/Issue 1/12345 - How-Does-Financial-Reporting-Regulation-Affect-Industry-wide-Resource-Allocation/breuer-online-appendix.pdf",
      "sha256": "02a66cbdf048b341b9a2fcb4a79611f816a42343fe06da1c420ae46c7f3b2085"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "c6dd85d9e5f4dec376eb76dc6e9cb613bf659431be1ecc4a92989e8cff139d48"
}
```

## Proposed actions

### A_AMAD_WRDS: Obtain/reuse the authorized Amadeus input route with distinct 2005–2015 disc snapshots and the separate 2016 WRDS contribution, or verify a compatible Orbis Historical route against the actual consumer requirements.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_AMAD, R_WRDS2016, I01
Evidence: E01, E02, E05, E27, E73, E74, E51, E75, E76, E77

Preparation / proposed procedure:

1. Preserve static company and ownership snapshots for disc vintages 2005–2015, and financial history from the 2005, 2008 and 2012 discs as the author describes.
2. Preserve the separately supplied 2010 disc-vintage Bankers branch: run the included importer producer for country_Bankers_2010 with accnr and banker* fields, then validate the consumer’s accnr/b* field mapping. This is a 2010 Amadeus-disc path; do not add Bankers 2016 calls.
3. Retain the 2016 WRDS download as a separate input; include the company, financial, auditor and ownership/shareholder sections consumed in the supplied Europe and Germany paths.
4. Stage section files under the paths expected by the supplied importer and panel programs, preserving country, source vintage, identifiers, industry coding and fiscal-year history.
5. If using Orbis Historical, verify its country population, static snapshot semantics, financial items/history, ownership fields, identifier transitions, industry mapping and contribution for the 2016 branch; exact original bytes are not required when this compatibility is established.

Validation to perform later:

- Compare acquired section names, fields, identifier and industry mappings, country coverage, vintage dates, and historical year coverage with the supplied Companies.do, Panel.do and AMA_data.do consumers before building panels.

### A_AMAD_ID: Resolve the missing BvD identifier-change correspondence required before company vintages can be combined.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_AMD_ID
Evidence: E06, E50, E_IDENTIFIERS

Preparation / proposed procedure:

1. Obtain the author-compatible Amadeus_ID.txt mapping with the oldid field and its corresponding BvD identifier values, then stage it in Project_Europe/Programs/Amadeus.
2. Keep the included Identifiers.dta as an ID list only; do not use it as a substitute for the cross-vintage mapping.

Validation to perform later:

- Confirm the file is tab-delimited with the expected oldid column and verify one-to-one/duplicate ID transitions before running Companies.do.

### A_WB_INPUTS: Acquire the official candidate World Bank annual series only after checking their coverage against the author panel, then format them for the two supplied text-file consumers.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R_WB_EXCH, R_WB_DEFL
Evidence: E07, E09, E10, E58

Preparation / proposed procedure:

1. Check the official PA.NUS.FCRF and NY.GDP.DEFL.ZS series for the exact required countries, Euro-area entry, 1999–2015 sample years and 2015 conversion/rebasing observation.
2. If coverage is compatible, export WB_nominal_exchange_rate.txt and WB_GDP_deflator.txt with tab-delimited countryname, time and value fields; preserve the code’s legacy currency mapping, exchange-rate normalization and within-country 2015 deflator rebasing.
3. Keep the routes unverified until country/history coverage and exchange/currency construction match the source panel and Regulation.do requirements.

Validation to perform later:

- Confirm field names, annual country-year uniqueness, required 1999–2015 observations and 2015 base values; check the Euro-area and late-euro currency cases used by the supplied code.

### A_MAD_IFRS_TPD: Resolve concurrent-regulation source contracts using the actual imported country key and downstream variable names, without guessing source ownership or inventing a TPD input.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_MAD, R_IFRS, I03_TPD
Evidence: E08, E19

Preparation / proposed procedure:

1. Obtain the author-specified MAD.csv and IFRS.csv row/history definitions and confirm each import has the country key required by Regulation.do’s country merges.
2. Confirm which source provides madyear and which provides ifrsdate, including expected value format for the trailing-year extraction.
3. Identify the supplied producer for tpdyear (or confirm whether it is generated from an already documented input); do not assign it to MAD.csv or IFRS.csv without evidence.

Validation to perform later:

- After authorized data are staged, verify the merged Regulation.dta exposes country, ifrsdate, madyear and tpdyear with the expected country-year coverage before running Europe Data.do.

### A_GERMANY_ACCESS: Resolve the documented German secure-data route and preserve the exact local-to-FDZ-to-screened-return workflow. This is a future access/workflow proposal only; no application, contact or remote data access was made.

Scopes: full_pipeline. Type: access_request. Certainty: conditional.
Addresses: R_URS, R_GWS, I02
Evidence: E01, E12, E14, E15, E16, E17

Preparation / proposed procedure:

1. Use the author-documented FDZ proposal/approval path before handling URS_panel.dta or GWS_panel.dta; agree the approved years, population, variable lists, geography and linkage fields in the secure environment.
2. For URS, confirm the actual UNR, urs_jahr, untern, aktiv, urs_1ef20, urs_1ef26 and downstream outcome/location fields; reconcile author-described 2003–2012 coverage with code conditions extending to 2001 and a 2014 anchor.
3. For GWS, confirm the code-consumed gwa_jahr, of2_2014, ef14, ef81, ef86, ef85, ef94–ef97, of1, ef99u*, ef100u*, ef102, ef124 and ef98 fields and their approved coding.
4. Run Master_Local locally first and transfer AMA_coverage.dta through the FDZ’s authorized screening/transfer procedure; do not move unscreened restricted data outside the FDZ.
5. Within the FDZ, preserve the supplied order URS_data → GWS_data → URS_outcomes → GWS_outcomes → Data merge → Analyses; return only outputs cleared by FDZ screening.

Validation to perform later:

- Before execution, verify approval, extract period and dictionary mappings with the FDZ; after screening, verify only approved result files return and that the local AMA_coverage input joined by county-industry-year.

### A_GERMANY_CROSSWALKS: Stage the packaged NACE crosswalk for Germany and verify the county AGS header mapping required by the local coverage branch.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_NACE, R_COUNTIES, R_WZ, I05_county_field
Evidence: E_NACE, E_COUNTIES, E_WZ, E55, E12

Preparation / proposed procedure:

1. Copy the packaged NACE Rev. 1.1-to-Rev. 2 crosswalk from Project_Europe/Programs/Amadeus into the Project_Germany/Programs/Amadeus location expected by AMA_panel.do.
2. Keep the supplied Counties.csv in the Germany Amadeus input folder and confirm the Stata import-delimited name for raw header “ags (all)” maps to the code’s later `agsall` reference.
3. Keep the WZ mapping at the supplied Project_Germany/Programs/Data path; URS_data.do imports without variable names and uses the second and fifth columns from row 3 onward.

Validation to perform later:

- In a future authorized Stata preparation, inspect the imported Counties variables and confirm the selected AGS column is the intended 2014 county code; confirm the WZ import reads the documented v2/v5 positions.

### A_SAS_RUNTIME: Verify the author-required SAS 9.4 runtime, PC SAS Connect/WRDS session, WLATIN1 encoding and Windows PIPE/date-enumeration behavior in the authorized execution environment.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: SW_SAS, SW_SASCONNECT, I07_SAS_CONTRACT
Evidence: E_ENV, E22, E67, E68, E69, E70, E71, E72

Preparation / proposed procedure:

1. Resolve the observed SAS startup failure (`tkels` initialization) in the approved SAS 9.4 environment without inferring missing entitlement from that diagnostic.
2. Confirm the PC SAS Connect TCP remote signon and WRDS rsubmit/proc download path works under an authorized session.
3. Confirm the author-required WLATIN1 session encoding and the Windows `dir` PIPE output format/first-ten-character mmddyy10 parser are supported in the intended host; compatibility with this Linux/UTF-8 environment is unverified.
4. Do not substitute a new portable directory parser or change encoding semantics without a documented compatible route.
5. Confirm filename case on the actual host: the converter creates lower-case country prefixes while Europe consumers request capitalized prefixes; use documented same-file copies/name staging where needed, without changing values or inventing a new parser.

Validation to perform later:

- Before any extraction, validate the runtime and WRDS session under an approved environment using a permitted non-study check; verify that directory enumeration yields the date/name fields the supplied macro expects.
- On the intended filesystem, verify the case-sensitive produced filenames match each downstream `use`/`project` path; retain source files and stage copies if needed.

### A_PROJECT_INSTALL: Make the required Stata project command available through the package’s documented setup path.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_PROJECT
Evidence: E_PROJECT, E21

Preparation / proposed procedure:

1. After the user-approved execution step, install the author-required project command through the existing Setup.do `ssc install project` instruction or an equivalent permitted package source.
2. Configure the three Setup.do master paths to the checked-out Project_Europe, Project_Germany and Project_Statistics Program folders.

Validation to perform later:

- Run `which project` in the intended Stata 18 adopath and confirm each project master resolves from its configured Programs path.

### A_STATA_ADDONS: Resolve the two absent Stata add-ons that the author’s Europe External_programs.do declares for setup.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_OUTREG2, SW_IVREGHDFE
Evidence: E_OUTREG2, E_IVREGHDFE, E23

Preparation / proposed procedure:

1. After a permitted package-installation step, use the author-declared SSC installation route for outreg2 and ivreghdfe, or an authorized equivalent.
2. Do not infer an active ivreghdfe estimator call from the installer; the current evidence establishes the setup command, not execution of that estimator.

Validation to perform later:

- Run Stata `which outreg2` and `which ivreghdfe` after setup; confirm both resolve in the configured adopath.

### A_PROJECT_PATHS: Configure the author’s explicit master and raw-data path placeholders consistently before the extraction and project branches run.

Scopes: full_pipeline. Type: configuration. Certainty: conditional.
Addresses: R_AMAD, R_WRDS2016, SW_PROJECT
Evidence: E03, E21, E22, E28, E71, E72

Preparation / proposed procedure:

1. Set the master directory locals in each supplied Setup.do to the corresponding Programs directory and fill the documented `...` path placeholders in the IGM Stata/SAS files and Europe/Germany/Statistics programs.
2. Stage extracted SAS and Stata files under the directory layout consumed by the code: IGM STATA_Data/SAS_Data and project-specific Amadeus/Data folders; preserve the distinct Europe and Germany folders.
3. Preserve the author’s Windows path and `dir`-enumeration assumptions until the target SAS host’s supported behavior is documented; do not treat a generic path substitution as sufficient.
4. For the actual host, preserve the converter’s lower-case country-prefix output and stage matching capitalized filenames used by Europe consumers through ordinary same-byte copies/name configuration where needed.

Validation to perform later:

- Review every resolved macro expansion against the frozen path reads and producer outputs before execution; confirm all three project masters and the 2016 conversion path refer to the same intended staged inputs.

### A_SAS_YEAR: Conditionally correct the SAS conversion year only after the author-documented 2016 WRDS sections are staged.

Scopes: full_pipeline. Type: source_edit. Certainty: conditional.
Addresses: I06_WRDS_YEAR
Evidence: E05, E59

**Proposed edit:** `Data & Code/IGM-BvD_Amadeus/Programs/SAS_Conversion_to_STATA.sas:185–185`
Source SHA-256: `58afa88ae570c9bea121ed643cf5bfb44428f0e8e022ce7761bab7b0c3e067b9`

The author documents WRDS data downloaded in November 2016, while this provided conversion invocation requests 2018.

Current text:
```
%conversion(2018); /* specify which year to convert */
```

Proposed replacement:
```
%conversion(2016); /* specify which year to convert */
```

Preparation / proposed procedure:

1. After the required 2016 WRDS data are staged and the extraction section calls are configured, apply this proposed one-line change only to an authorized working copy; preserve the original package.

Validation to perform later:

- Diff the one-line edit against the frozen source hash and confirm the staged folder is the documented 2016 WRDS input before converting.

### A_GERMANY_GRAPH_ORDER: Defer the hard-coded Germany graph program until after FDZ analysis outputs have been screened and returned, then run the supplied graph program locally.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I02
Evidence: E12, E17, E57, E18

**Proposed edit:** `Data & Code/Project_Germany/Programs/Master_Destatis.do:67–67`
Source SHA-256: `2d751fb276a381be5aff23c39a91b6d6601eb15c04d5548fce6ef2724586796d`

The author documents that FDZ output is screened and returned before local figures, and identifies Graphs.do as hard-coded from FDZ regression output.

Current text:
```
project, do(Dofiles/Graphs.do)
```

Proposed replacement:
```
* Deferred until screened outputs return; run Dofiles/Graphs.do locally.
```

Preparation / proposed procedure:

1. Apply the proposed edit only in an authorized working copy; in the FDZ run the supplied master through Analyses, then have the FDZ screen and return permitted results.
2. Run the unchanged supplied Graphs.do locally after the approved output returns.

Validation to perform later:

- Diff the one-line deferred call and verify the FDZ master still runs URS/GWS cleaning, outcomes, Data merge and Analyses in source order; confirm local figures use only the author-hard-coded approved results.

### A_EUROPE_RUN: Run the complete Europe workflow only after the Amadeus, identifier, World Bank and regulation input contracts are resolved and the required software/paths are configured.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: E03, E27

Preparation / proposed procedure:

1. After authorized runtime/host checks, configure the supplied WRDS macro to invoke each required section/year separately (Amadeus/Company, Auditors, Financials, Shareholders/Ownership) while retaining the existing Activities invocation; then convert the staged 2016 outputs. Run the Stata import/section assembly for the documented disc vintages and sections.
2. Run Project_Europe/Programs/Setup.do; preserve the master order Companies → Panel → Outcomes → Regulation → Scope → Data → Analyses → Graphs → Identifiers.
3. Keep Scope.do’s author-defined construction and simulation branch in the Europe full workflow; use supplied Scope_2.dta only in the separate Statistics branch.

Validation to perform later:

- At each stage compare the named producer file, fields, vintage/year and directory with the next consumer; verify generated Outcomes, Regulation, Scope and Data outputs before downstream analysis.

### A_GERMANY_RUN: Execute the German branch in its documented local, secure FDZ and screened-return order.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: run procedure
Evidence: E12, E13, E16, E17, E18

Preparation / proposed procedure:

1. Run Master_Local locally in order AMA_panel → AMA_data → AMA_coverage; stage the NACE crosswalk and verify Counties.csv mapping.
2. Pass AMA_coverage.dta to the approved FDZ route; inside the FDZ run URS_data → GWS_data → URS_outcomes → GWS_outcomes → Data → Analyses.
3. Return only FDZ-screened result outputs; run Graphs.do locally after return, using the proposed Master_Destatis deferred-graph edit.

Validation to perform later:

- Verify the local coverage input joins FDZ outcomes by county-industry-year, each generated file precedes its consumer, and only outputs approved by screening leave the secure environment.

### A_STATISTICS_RUN: Run the separately documented Statistics supplement for Table 8 using its supplied raw national-statistics inputs and prepared Scope_2.dta.

Scopes: full_pipeline. Type: run_procedure. Certainty: supported.
Addresses: run procedure
Evidence: E20, E24, E_OECD, E_WIOD, E_SCOPE2, E_KLEMS_NA, E_KLEMS_GROWTH, E_KLEMS_CAP

Preparation / proposed procedure:

1. After project/setup paths are configured, run Project_Statistics/Programs/Setup.do and preserve Master_Statistics order: KLEMS → OECD → WIOD after External_programs.
2. Use the packaged Statistical_National-Accounts, Statistical_Growth-Accounts, Statistical_Capital, OECD DATA.txt, WIOD DATA worksheet and Scope_2.dta as separate actual inputs.
3. Treat the OECD cached text extraction as capped; use the original packaged file. Preserve the observed WIOD 2000–2014 source columns and code’s inclusive 2001–2015 upper filter without imposing an unsupported 2015 requirement.

Validation to perform later:

- For each source, confirm the expected fields and generated KLEMS/OECD/WIOD outputs; verify the Table 8 logs are produced and retain the input coverage limitation rather than manufacturing years.

### A_WRDS_SECTIONS: Conditionally add explicit section/year calls for 2016 inputs consumed by Europe and Germany while retaining the existing Activities invocation. This call configuration remains conditional on SAS/CONNECT, encoding and host enumeration compatibility.

Scopes: full_pipeline. Type: source_edit. Certainty: conditional.
Addresses: R_WRDS2016, I07_SAS_CONTRACT
Evidence: E05, E22, E53, E54, E67, E68, E69, E70, E71, E72

**Proposed edit:** `Data & Code/IGM-BvD_Amadeus/Programs/SAS_Amadeus_WRDS.sas:122–122`
Source SHA-256: `277ee5b6f20d14497a6332eeac1b71438ae7db8cf21a1c626f3c60094dd34a9f`

The macro accepts section/year inputs, the source comment lists Amadeus, Auditors, Financials and Shareholders, but the current invocation requests Activities only; these sections feed the supplied panel programs.

Current text:
```
%downloading(Activities, 2016); /* specify section and year for download */
```

Proposed replacement:
```
%downloading(Activities, 2016); /* specify section and year for download */
%downloading(Amadeus, 2016);
%downloading(Auditors, 2016);
%downloading(Financials, 2016);
%downloading(Shareholders, 2016);
```

Preparation / proposed procedure:

1. Use this edit only after an authorized environment confirms the supplied WRDS macro’s section names and its PC SAS Connect, WLATIN1 and Windows PIPE/date-enumeration contracts.
2. Preserve the Activities call and keep each added section/year call explicit; do not add other sections without a documented consumer.
3. When staging converted outputs on a case-sensitive filesystem, keep the converter’s lower-case filenames and make same-byte copies under the exact capitalized names consumed by Europe if required; do not alter observations or source values.

Validation to perform later:

- Review the macro output directory for each requested 2016 section and confirm the generated files match the names and fields expected by the supplied conversion and panel code before any analysis.

### A_WRDS_CASE_STAGE: Preserve the SAS converter’s lower-case country filenames while staging same-byte copies under the capitalized country names consumed by the Europe panel on a case-sensitive filesystem.

Scopes: full_pipeline. Type: data_preparation. Certainty: conditional.
Addresses: R_WRDS2016, I07_SAS_CONTRACT
Evidence: E71, E72, E05

Preparation / proposed procedure:

1. After the authorized 2016 conversion, compare actual generated names such as lower-case country prefixes with the exact capitalized file names built by Panel.do and Companies.do.
2. If the target filesystem distinguishes case, stage ordinary same-byte copies with the exact names expected by the supplied consumers; preserve the original converter outputs and all variable values.

Validation to perform later:

- Confirm each resulting filename resolves from its downstream source path and that staged copies have identical bytes to the converted originals before panel construction.


## Remaining issues and prerequisites

- I01 [unresolved; full_pipeline]: The full Europe results and Germany coverage preparation require the author-version Amadeus source histories and country-year section files, but the release excludes those materials. The cited historical product note does not establish a compatible substitute: compatibility must preserve static snapshots, historical financial items, ownership, harmonized firm IDs and industry mappings, and the 2016 WRDS contribution.
- I02 [unresolved; full_pipeline]: The separate German Destatis branch requires confidential URS_panel.dta and GWS_panel.dta inside the secure FDZ workflow. The documented author order is local Amadeus coverage (AMA_coverage) → FDZ URS/GWS cleaning and outcomes → Data merge using the passed local coverage → analyses → screened outputs returned; the field-level approved extract and local figure handoff remain to be resolved.
- I03_TPD [unresolved; full_pipeline]: Europe Regulation.do imports MAD.csv and IFRS.csv and merges each by country. Europe Data.do later consumes ifrsdate (derives ifrs_year), tpdyear and madyear. The raw CSV rows/history and ownership of ifrsdate/madyear are unverified; no producer or source for tpdyear is identified. Preserve these known consumer names and key without assigning tpdyear or fields to a guessed source.
- I05_county_field [unresolved; full_pipeline]: Counties.csv is readable and includes a raw header `ags (all)`, while AMA_panel.do later keeps/renames `agsall`. The exact Stata import-delimited normalization of this header was not checked; confirm the required field maps before treating the local coverage branch as closed.
- I06_WRDS_YEAR [unresolved; full_pipeline]: SAS_Conversion_to_STATA.sas invokes conversion for 2018 at line 185, while the author documents a WRDS download from November 2016 and says the SAS-to-Stata conversion is used for 2016. The supported correction is to set the invocation to 2016 after preserving the supplied year-specific data path; no conversion was run.
- I07_SAS_CONTRACT [unresolved; full_pipeline]: The SAS WRDS macro supports section/year inputs but the current call requests Activities only; the downstream workflow also consumes Company/Amadeus, Financials, Auditors and Shareholders/Ownership. The source header specifies PC SAS Connect and WLATIN1; both SAS scripts enumerate Windows `dir` output via PIPE and parse the first ten characters as mmddyy10. The local SAS startup probe failed at TKELS, so section invocation, SAS/CONNECT, encoding and current Linux/UTF-8 host compatibility remain unverified. Do not invent a portable directory parser or infer entitlement from the startup error. The conversion macro derives lower-case country prefixes for output filenames, while Europe consumers form filenames from capitalized country labels; behavior on a case-sensitive host and the required simple staging/name mapping remain unverified.
- R_AMAD [undetermined]: BvD Amadeus disc extracts for 2005–2015 static company/ownership snapshots and financial histories (the 2005, 2008, and 2012 discs supply up to ten-year histories) used to construct Europe and German local coverage firm-year inputs. Preserve country, vintage, section, firm identifier and industry mappings; exact output panel compatibility remains to be validated. The supplied 2010 importer branch also keeps accnr and banker* fields and produces country_Bankers_2010; Companies.do consumes accnr and b* fields to derive a bank count. Preserve the raw-to-consumer prefix/field mapping as a compatibility check rather than assuming exact aliases.
- R_WRDS2016 [undetermined]: Separate BvD Amadeus WRDS November 2016 download required for the 2016 company (Amadeus), financial, auditor and ownership/shareholder sections; company/ownership data span through 2016 and financials through fiscal 2015. SAS_Amadeus_WRDS.sas defines a section/year macro but its current call invokes Activities only, so required sections need explicit authorized calls before conversion.
- R_AMD_ID [undetermined]: Amadeus_ID.txt BvD identifier-change correspondence imported by Companies.do (oldid renamed bvd_id); supplied Identifiers.dta has only a bvd_id list and is not this correspondence or a complete panel.
- R_WB_EXCH [undetermined]: Tab-delimited World Bank nominal exchange-rate input mapped from countryname/time/value to country/year/exch, including currency mapping, Euro-area rates, a 2015 baseline and history needed by Outcomes.do and Regulation.do.
- R_WB_DEFL [undetermined]: Tab-delimited World Bank GDP deflator input mapped from countryname/time/value to country/year/deflator and rebased within country to 2015 by Outcomes.do.
- R_MAD [undetermined]: MAD.csv imported and merged into Europe Regulation.dta by country. Data.do later consumes madyear; confirm the author-compatible source rows/history and which imported table supplies this field.
- R_IFRS [undetermined]: IFRS.csv imported and merged into Europe Regulation.dta by country. Data.do later consumes ifrsdate and derives ifrs_year from its trailing four characters; confirm the source rows/history and which imported table supplies this field.
- R_COUNTIES [undetermined]: Packaged Counties.csv location and county crosswalk used by AMA_panel.do. Raw header includes city, zipcode, match_name, and several AGS labels, including “ags (all)”; Stata’s imported variable name for the last field and its compatibility with code name agsall need checking.
- R_URS [undetermined]: Confidential German URS_panel.dta raw enterprise panel, consumed as `use URS_panel if untern==1 & aktiv==1`; code requires UNR/urs_jahr, untern/aktiv, urs_1ef20/urs_1ef26 and downstream outcome/location/industry fields, then forward-fills legal form and WZ codes. Author description says URS/GWS are confidential; documented source period is 2003–2012 while code’s look-forward conditions reach 2001–2013/2014, so exact approved extract bounds must be resolved securely.
- R_GWS [undetermined]: Confidential German GWS_panel.dta notification-year panel; GWS_data.do uses gwa_jahr, of2_2014, ef14, ef81, ef86, ef85, ef94–ef97, of1, ef99u*, ef100u*, ef102, ef124 and filters ef98. Exact panel history, population and approved code-list mapping remain unverified.
- SW_SAS [unverified]: SAS 9.4 launcher did not initialize TKELS in the bounded environment probe. This does not establish absent entitlement; author WRDS extraction and SAS-to-Stata conversion remain unverified.
- SW_SASCONNECT [unverified]: The author SAS extraction invokes TCP remote signon, rsubmit and proc download to WRDS. Local connection/service access is unverified.
- SW_PROJECT [preparation_required]: The Stata project command is required by all three Stata project masters; the bounded which probe did not find it, while each Setup path declares ssc install project.
- SW_OUTREG2 [preparation_required]: Environment probe reports outreg2 absent from checked adopaths; Europe External_programs.do declares its installation.
- SW_IVREGHDFE [preparation_required]: Environment probe reports ivreghdfe absent; the Europe External_programs.do unconditionally declares its installation, even though no active estimator call has been established in the source search.

## Review notes

- SAS/WRDS section and host contracts are explicit: current call is Activities only; required 2016 sections need calls through the supplied section/year macro. The author source requires PC SAS Connect/WLATIN1 and uses Windows `dir` PIPE output with first-ten-character date parsing; conversion emits lower-case country prefixes while Europe consumers form capitalized names. Linux/UTF-8 and filename-case compatibility remain unverified. The 2018→2016 source edit is conditional on staged 2016 inputs. The 2010 Bankers dependency is traced to the supplied importer producer and its Companies.do consumer; raw banker*/b* field mapping remains to verify. No author programs, estimators or simulations were executed; no SAS retry, restricted-data access, dataset download, package install or author-source mutation occurred. Bounded metadata inspection of supplied packaged data was performed: one-row table probes, streaming of the original OECD header/first record, and a read-only inspection of the WIOD DATA worksheet’s first two rows; no full analysis dataset was materialized.
