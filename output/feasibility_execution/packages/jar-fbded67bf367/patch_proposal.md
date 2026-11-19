# Patch proposal: jar-fbded67bf367

Do Mandatory Disclosure Requirements for Private Firms Increase the Propensity of Going Public?

DOI: 10.1111/1475-679X.12396

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

All branches in the supplied Stata workflow, including the U.S. biopharma analyses and the European firm-panel analyses.

Entry points: `AT IPO JAR Code Final.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 60/Issue 3/12396 - Do-Mandatory-Disclosure-Requirements-for-Private-Firms-Increase-the-Propensity-of-Going-Public/at-datasheet-and-code.zip",
      "sha256": "5fc5047131a53ef6128a38230239a193cbfd3910867ee05a34a7d43b6141f72a"
    },
    {
      "path": "JAR-Volume 60/Issue 3/12396 - Do-Mandatory-Disclosure-Requirements-for-Private-Firms-Increase-the-Propensity-of-Going-Public/at-online-appendix.pdf",
      "sha256": "fceb078249f1803425d11aaaccc10928f9c0d89f2b06acb48c5ee689f1047b50"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "ac0a5a2beb891176b4ebd6345f8a615df2cbeecce573517f14ada24a20608dab"
}
```

## Proposed actions

### A001: Request the eight distinct author-prepared U.S. biopharma tables and their codebooks as the primary route: Company Portfolios Firm.dta, BMT Disclosures Panel.dta, IPO Dates JAR Final.dta, Num Drugs Disclosure.dta, Company Portfolios.dta, Drug Indication Competition.dta, Appended Data IPOs BMT.dta and acquisition_year.dta.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R001, R002, R003, R004, R005, R006, R007, R008, I001, I004, I005, I006
Evidence: E007, E008, E009, E010, E011, E012, E013, E014, E015, E031, E032

Preparation / proposed procedure:

1. Ask the authors for the exact named prepared tables or an already authorized compatible release, plus a data dictionary, producer/processing notes, join-key definitions and full year/firm coverage for each file.
2. Confirm disclosure spellings without assuming num_disclosure, num_disclosures or disclosure are aliases; identify which table owns orphan_drug; preserve the separate project, firm-year and denominator table units.
3. For IPO Dates JAR Final.dta, request the manual Compustat-to-BioMedTracker matching rule and firm universe. The catalogued COMP.FUNDA file is only a candidate and does not establish the IPO-date field or crosswalk.
4. For Appended Data IPOs BMT.dta and acquisition_year.dta, request their producer notes and exact field definitions, including the distinction among risk_drug_acq, risk_drug_acq_y, late_drugacq and late_drugacq_y.
5. Treat the datasheet's historical BioMedTracker and Compustat subscription routes as provenance. It does not establish a current access barrier; if only raw sources are available, first request author-provided extraction and matching instructions rather than independently rebuilding the inputs.

Validation to perform later:

- Before analysis, use bounded metadata checks on each obtained .dta file to confirm exact filename, readability, required variables, key types, duplicates and year coverage, including the panel history needed by source-coded lags.
- Check that author-prepared files preserve the documented firm-year versus project-year units and the manually matched IPO-date relationship; retain all authored tables and definitions without changing samples or estimators.

### A002: Request the three separate BvD prepared panels for the distinct European, German and later Europe analyses; do not combine their versions.

Scopes: full_pipeline. Type: data_acquisition. Certainty: conditional.
Addresses: R009, R010, R011, I001, I007
Evidence: E016, E017, E018, E019, E020, E021, E022, E023, E024, E026, E031

Preparation / proposed procedure:

1. Request All Europe.dta, Germany Sample Competitiveness.dta, and All Europe v2.dta individually, with codebooks, source filters, country coverage, identifiers, panel periods and the Orbis/Amadeus merge or crosswalk steps.
2. Keep the 2002-2012 Orbis panel, Amadeus/Germany sample merged with Orbis IPO information, and 2002-2019 All Europe v2 panel as distinct inputs; preserve both Germany industry constructions and the twelve-country threshold panel.
3. Use the prepared panels as alternatives to recreating the historical WRDS extraction. Obtain raw Orbis/Amadeus sources only if compatible prepared tables are unavailable and the authors provide the exact preparation specification and a permitted access route.

Validation to perform later:

- Use bounded metadata checks to confirm each table's expected fields, identifiers and supported year/country coverage; verify the Germany table contains the merged IPO and Amadeus fields used by both industry-definition blocks.
- For the 2002-2019 table, verify the author's original currency field and treatment history needed by the code's two-consecutive-year L/L2 construction; do not extrapolate beyond the supported source period.

### A003: Clarify the exact annual FRED series and the separate fields/units used by the author currency file before treating a public USD/EUR series as compatible.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R012, I008
Evidence: E025, E026, E040

Preparation / proposed procedure:

1. Ask the authors for USD EUR Exch.dta or the exact FRED series identifiers, annual aggregation, source date, variable dictionary, currency directions and the mapping of the file's EXCHRATE and usd_eur fields.
2. Confirm why EXCHRATE is multiplied only for ORIG_CURRENCY != EUR while usd_eur is multiplied for every currency, and whether those source variables already reflect other currency conversions.
3. Treat FRED AEXUSEU as a candidate only; do not substitute it or alter multiply/divide logic without the author mapping.

Validation to perform later:

- After clarification, compare the prepared rate values and units to the confirmed series for the full 2002-2019 input period, verify merge-by-year uniqueness, and confirm the conversion formula for each currency before full workflow execution.

### A004: Install or enable the documented Stata psmatch2 add-on in the authorized host environment; it is required only for the matched Europe branch.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: S006, I010
Evidence: E021, E038, E044

Preparation / proposed procedure:

1. Use the documented SSC installation route for psmatch2 in the approved Stata environment; no estimator or matching replacement is proposed.
2. Keep the installed package in the Stata ado path used by the host wrapper.

Validation to perform later:

- After setup, use an exact which psmatch2 lookup and confirm the psmatch2 command is available before processing the matched Europe block.

### A005: In a working copy of the driver, replace each of the 19 literal directory placeholders with cd "." so all named input, generated intermediate and relative output paths resolve from one staged directory.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I002
Evidence: E045, E046, E047, E048, E049, E050, E051, E052, E053, E054, E055, E056, E057, E058, E059, E060, E061, E062, E063

**Proposed edit:** `AT IPO JAR Code Final.do:12–12`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Stage the driver and its named inputs in one working directory and preserve relative use/save paths under the host-wrapper requirement.

Current text:
```
cd "..."
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `AT IPO JAR Code Final.do:45–45`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Stage the driver and its named inputs in one working directory and preserve relative use/save paths under the host-wrapper requirement.

Current text:
```
cd "..."
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `AT IPO JAR Code Final.do:80–80`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Stage the driver and its named inputs in one working directory and preserve relative use/save paths under the host-wrapper requirement.

Current text:
```
cd "..."
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `AT IPO JAR Code Final.do:173–173`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Stage the driver and its named inputs in one working directory and preserve relative use/save paths under the host-wrapper requirement.

Current text:
```
cd "..."
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `AT IPO JAR Code Final.do:233–233`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Stage the driver and its named inputs in one working directory and preserve relative use/save paths under the host-wrapper requirement.

Current text:
```
cd "..."
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `AT IPO JAR Code Final.do:264–264`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Stage the driver and its named inputs in one working directory and preserve relative use/save paths under the host-wrapper requirement.

Current text:
```
cd "..."
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `AT IPO JAR Code Final.do:299–299`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Stage the driver and its named inputs in one working directory and preserve relative use/save paths under the host-wrapper requirement.

Current text:
```
cd "..."
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `AT IPO JAR Code Final.do:339–339`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Stage the driver and its named inputs in one working directory and preserve relative use/save paths under the host-wrapper requirement.

Current text:
```
cd "..."
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `AT IPO JAR Code Final.do:375–375`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Stage the driver and its named inputs in one working directory and preserve relative use/save paths under the host-wrapper requirement.

Current text:
```
cd "..."
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `AT IPO JAR Code Final.do:415–415`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Stage the driver and its named inputs in one working directory and preserve relative use/save paths under the host-wrapper requirement.

Current text:
```
cd "..."
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `AT IPO JAR Code Final.do:463–463`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Stage the driver and its named inputs in one working directory and preserve relative use/save paths under the host-wrapper requirement.

Current text:
```
cd "..."
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `AT IPO JAR Code Final.do:515–515`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Stage the driver and its named inputs in one working directory and preserve relative use/save paths under the host-wrapper requirement.

Current text:
```
cd "..."
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `AT IPO JAR Code Final.do:562–562`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Stage the driver and its named inputs in one working directory and preserve relative use/save paths under the host-wrapper requirement.

Current text:
```
cd "..."
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `AT IPO JAR Code Final.do:607–607`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Stage the driver and its named inputs in one working directory and preserve relative use/save paths under the host-wrapper requirement.

Current text:
```
cd "..."
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `AT IPO JAR Code Final.do:647–647`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Stage the driver and its named inputs in one working directory and preserve relative use/save paths under the host-wrapper requirement.

Current text:
```
cd "..."
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `AT IPO JAR Code Final.do:702–702`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Stage the driver and its named inputs in one working directory and preserve relative use/save paths under the host-wrapper requirement.

Current text:
```
cd "..."
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `AT IPO JAR Code Final.do:714–714`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Stage the driver and its named inputs in one working directory and preserve relative use/save paths under the host-wrapper requirement.

Current text:
```
cd "..."
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `AT IPO JAR Code Final.do:764–764`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Stage the driver and its named inputs in one working directory and preserve relative use/save paths under the host-wrapper requirement.

Current text:
```
cd "..."
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `AT IPO JAR Code Final.do:818–818`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Stage the driver and its named inputs in one working directory and preserve relative use/save paths under the host-wrapper requirement.

Current text:
```
cd "..."
```

Proposed replacement:
```
cd "."
```

Preparation / proposed procedure:

1. Place the working-copy driver and all exact-named prepared input files in the same isolated directory and launch the Stata host wrapper with that directory as the working directory; use relative paths only.

Validation to perform later:

- Check each replacement against the frozen source hash and verify all 19 cd statements now point to the same staged directory.
- Confirm the same directory is used for relative reads and saves, including the generated propensity-score table, before an authorized run.

### A006: Make both consumers use the exact capitalization of the generated PS Sample Germany.dta file.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I003
Evidence: E021, E064, E065

**Proposed edit:** `AT IPO JAR Code Final.do:682–682`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Match the generated file capitalization at line 680 on a case-sensitive filesystem.

Current text:
```
merge m:1 id using "PS sample Germany.dta"
```

Proposed replacement:
```
merge m:1 id using "PS Sample Germany.dta"
```

**Proposed edit:** `AT IPO JAR Code Final.do:703–703`
Source SHA-256: `5a80cc16cc46b89deb13585a3d2b45737476e5f380270aa61fccd59ac8078ae6`

Match the generated file capitalization at line 680 on a case-sensitive filesystem.

Current text:
```
use "PS sample Germany.dta"
```

Proposed replacement:
```
use "PS Sample Germany.dta"
```

Validation to perform later:

- Verify from source text that line 680 produces the file before both consumers and that the staged working directory is unchanged across the producer and consumers.

### A007: Obtain author clarification for the xi: reg calls that specify absorb(company), preserving the intended fixed effects, controls, cluster variable and sample.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: I009
Evidence: E027, E041

Preparation / proposed procedure:

1. Ask whether the calls at lines 223-224, 227-229 and 294 are intended to use reg with another supported fixed-effect syntax or a different command, and request the authors' exact Stata 18-compatible source line if a repair is needed.
2. Do not substitute areg or another estimator without author confirmation, because the code's complete fixed-effect, xi-prefix, robust and clustering behavior must be preserved.

Validation to perform later:

- After receiving the supported syntax, confirm it against the Stata 18 command documentation and compare the intended variables, fixed effects, sample filters and clustered standard errors before any authorized execution.

### A008: Once the author data contracts, software setup and unapplied source repairs are resolved, run the complete supplied driver in the staged directory with the Stata host wrapper and inspect all branch outputs.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R001, R002, R003, R004, R005, R006, R007, R008, R009, R010, R011, R012, S001, S002, S003, S004, S005, S006, S007, I001, I002, I003, I004, I005, I006, I007, I008, I009, I010, S008, I011
Evidence: E029, E030, E028, E044, E066, E067

Preparation / proposed procedure:

1. After all inputs are staged and the confirmed preparation edits are made in a working copy, invoke Stata batch mode from the staged working directory as documented by the host wrapper: stata -b do "AT IPO JAR Code Final.do".
2. Preserve the wrapper's log and any generated graphs/intermediates; review all U.S., Europe, Germany and Table A6 branches in their supplied order and compare output against the authors' materials.
3. Keep the authored constants, years, after and after2 definitions, median-39 split, threshold rules, lag history, samples and estimators unless the authors supply a supported correction.

Validation to perform later:

- Confirm all named inputs and generated handoffs resolve, every required branch completes, and all expected graph/table results can be reconciled with author results; do not claim execution success until an authorized run actually completes.

### A009: Confirm the installed ranktest version satisfies the required ivreg2 dependency before running the reghdfe HAC branch; update the package only if that version check fails.

Scopes: full_pipeline. Type: software_setup. Certainty: conditional.
Addresses: S008, I011
Evidence: E066, E067

Preparation / proposed procedure:

1. Use the installed ivreg2 package's documented ranktest version check in the target Stata 18 environment before attempting the affected analysis branch; the current exact which lookup verifies command presence only.
2. If the package check reports a missing or insufficient ranktest version, install or update ranktest through its documented SSC route in the authorized environment. Preserve ivreg2, reghdfe, the robust,bw(2) option and the authored estimator.

Validation to perform later:

- Confirm the ranktest version meets the minimum enforced by the installed ivreg2 package and that Stata resolves it on the same ado path used by the workflow before any model execution.


## Remaining issues and prerequisites

- I001 [unresolved; full_pipeline]: None of the twelve named .dta tables is included in the release. The driver has required U.S. BioMedTracker/Compustat and separate Orbis/Amadeus Europe/Germany/FX panels; exact fields, producers, full coverage and current access remain unverified. The additional direct merge/append inputs identified by source review are included in the requirements.
- I002 [preparation; full_pipeline]: The 19 branch setup lines contain literal cd placeholders. Stage the driver and exact-named inputs together and use a relative working-directory setting in a working copy before attempting the workflow.
- I003 [preparation; full_pipeline]: The same Germany propensity-score sample is saved as PS Sample Germany.dta and consumed twice as PS sample Germany.dta. Matching the two consumer spellings to the producer capitalization is a routine case-sensitive path repair if the same staged file is intended.
- I004 [unresolved; full_pipeline]: The disclosure input is consumed under num_disclosure, num_disclosures, disclosure, phase2_disc and phaseabove_disc spellings. The absent input namespace prevents confirming whether these are separate fields or any intended alias mapping.
- I005 [unresolved; full_pipeline]: IPO Dates JAR Final.dta is described as Compustat IPO dates manually matched to BioMedTracker names. The match procedure and covered firm universe are not supplied; the local COMP.FUNDA candidate lacks a verified IPO-date field or matching crosswalk.
- I006 [unresolved; full_pipeline]: The project-level portfolio, indication competition, appended IPO supplement and acquisition-year tables are separate inputs. Their exact schemas, producers, and ownership of fields such as orphan_drug are not fully specified by the source files.
- I007 [unresolved; full_pipeline]: All Europe.dta, Germany Sample Competitiveness.dta and All Europe v2.dta are distinct prepared inputs with different source populations, periods and fields. Their exact BvD query/merge preparation, country coverage and full panel histories are unverified.
- I008 [unresolved; full_pipeline]: The FX file is described as annual USD/EUR rates, but the code merges by year and multiplies every monetary variable by usd_eur, while applying EXCHRATE first to non-EUR observations. The series identities, field ownership, directions and units are unresolved; no replacement formula is inferred.
- I009 [unresolved; full_pipeline]: Several calls use xi: reg ... , r absorb(company) cluster(company). Stata 18 documentation associates absorb() with areg, while the supplied command is reg. This is an unresolved compatibility question; no command substitution or estimator test was made.
- I010 [preparation; full_pipeline]: psmatch2 is required to produce the German propensity-score sample but is unavailable in the current Stata command lookup. Its documented SSC route makes this a software setup task.
- I011 [unresolved; full_pipeline]: The installed ivreg2 4.1.12 help and ado require ranktest and check a minimum version. The exact `which ranktest` check succeeds, but it does not report the installed ranktest version; compatibility with the package's Stata 18 call path therefore remains unverified.
- R001 [undetermined]: Company Portfolios Firm.dta, a distinct BioMedTracker firm-year portfolio panel used throughout the U.S. analyses.
- R002 [undetermined]: BMT Disclosures Panel.dta, a separate BioMedTracker firm-year disclosure panel merged by bmtnm and year.
- R003 [undetermined]: IPO Dates JAR Final.dta, containing the manually matched BioMedTracker firm-name and Compustat IPO-date input used throughout the U.S. workflow.
- R004 [undetermined]: Num Drugs Disclosure.dta, a separate company-year denominator panel merged into the Figure 1-2 disclosure scaling branch.
- R005 [undetermined]: Company Portfolios.dta, the drug-indication-year source panel used to construct the U.S. competitiveness/orphan-drug firm-year branch. Company Portfolios.dta and Company Portfolios Firm.dta are distinct inputs.
- R006 [undetermined]: Drug Indication Competition.dta, joined to Company Portfolios.dta by indication and year before collapse; the exact prepared schema and orphan-drug field ownership are unknown.
- R007 [undetermined]: Appended Data IPOs BMT.dta, a separate company-year supplement appended after project-panel collapse and before the IPO-date merge.
- R008 [undetermined]: acquisition_year.dta, a firm-year panel of acquisitions, initiations and suspensions joined to the U.S. portfolio panel for Tables A2, A4 and 9-10.
- R009 [undetermined]: All Europe.dta, the distinct author-prepared Orbis firm-year panel for Europe Table 11 and Figure 4.
- R010 [undetermined]: Germany Sample Competitiveness.dta, a distinct German Amadeus panel joined with Orbis IPO information for Table 12.
- R011 [undetermined]: All Europe v2.dta, a separate Orbis firm-year version for Table A6 with twelve country-specific disclosure thresholds.
- R012 [undetermined]: USD EUR Exch.dta, a yearly exchange-rate input merged by year in the separate All Europe v2 workflow.
- S006 [preparation_required]: The matched Europe branch calls psmatch2 and the exact command is absent from the current Stata lookup. A repository record documents an SSC installation route; setup is preparation, not an access blocker.

## Review notes

- The target is the complete 890-line Stata driver: U.S. biopharma figures/tables; separate project-indication, appended-IPO and acquisition outcomes; Europe Table 11/Figure 4 and its generated matched sample; both Germany Table 12 industry definitions; and the distinct All Europe v2/FRED Table A6 branch.
- All 19 frozen parser IDs are covered in dependency_review. The trace also records seven direct using inputs omitted by the frozen parser: BMT Disclosures Panel.dta, IPO Dates JAR Final.dta, Num Drugs Disclosure.dta, Drug Indication Competition.dta, Appended Data IPOs BMT.dta, acquisition_year.dta and USD EUR Exch.dta.
- Prepared author tables are the primary routes. Historical BioMedTracker, Compustat, Orbis, Amadeus and FRED provenance is not expanded into an AND-list of raw-source prerequisites; the exact manual IPO match and source preparation remain unresolved where the prepared table is absent.
- Keep Company Portfolios.dta separate from Company Portfolios Firm.dta; keep All Europe.dta, Germany Sample Competitiveness.dta and All Europe v2.dta separate; and retain the generated Germany matching handoff, exact field spellings, authored periods, median-39 cutoff, after/after2 interactions and both industry definitions.
- No compatible analysis-only input route is supplied or verified, so only the full_pipeline scope is assessed. The source evidence is static; no author data, analysis command or estimator was run, and execution_verified remains false.
- The installed ivreg2 4.1.12 help and ado explicitly require ranktest and perform a version check. One exact `which ranktest` lookup finds the helper command, but the installed ranktest version remains unverified; keep this as a software compatibility issue and do not change the HAC estimator.
