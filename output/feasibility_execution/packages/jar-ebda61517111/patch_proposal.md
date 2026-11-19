# Patch proposal: jar-ebda61517111

The disciplinary effect of social media: Evidence from workplace practices in response to Glassdoor reviews

DOI: 10.1111/1475-679X.12393

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

Complete supplied author workflow: the main program for Figures 1–3 and Tables 1–8 plus the independent online-appendix program for Tables A1–A5, with required preparation and data handoffs unresolved.

Entry points: `Code/csr_gd_main analysis_20210629.do`, `Code/csr_gd_online appendix_20210629.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 59/Issue 5/12393 - The-disciplinary-effect-of-social-media-Evidence-from-workplace-practices-in-response-to-Glassdoor-reviews/dz-datasheet-code-and-identifiers.zip",
      "sha256": "2bf105a2a0861d33cbf8de5fccdaec440128210f87b846d9837ef10c4fdfe7a0"
    },
    {
      "path": "JAR-Volume 59/Issue 5/12393 - The-disciplinary-effect-of-social-media-Evidence-from-workplace-practices-in-response-to-Glassdoor-reviews/dz-online-appendix.pdf",
      "sha256": "a25f98fa60cd4fb0400bd2d6ead6a33ab9cc9b0af4eb75cea3991446faf59212"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "b27a13e5107ad64aa7d573bd0d83eddda9fef42731cdc1c8d8677c1738fa296f",
  "work_item_sha256": "991671871672e4e5a3101dd0605a1dc2d477e7ff662d9917c1c7db0d0d63045e"
}
```

## Proposed actions

### A_PREP_DATA: Obtain the five named prepared inputs or the absent producer and field/merge specifications; preserve the independent main and appendix branches. The author history in the datasheet is not an executable replacement for these missing files.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R_CSR_PANEL, R_FIRST_REVIEWS, R_BAD_AVERAGE, R_EVENT_REVIEW_STATS, R_CALENDAR_REVIEW_STATS, ISS_DATA_CONSTRUCTION, ISS_FIGURE2_JOIN_CONTRACT
Evidence: E_README, E_MAIN_SCOPE, E_APP_SCOPE, E_WORK_ITEM, E_DATASHEET_ATTACHED_FILES

Preparation / proposed procedure:

1. Provide csr_gd3.dta with the traced panel fields; gd2v_re10re1.dta and gd_rating_eyear.dta with their actual permno-keyed schemas and documented joint source for post-join rating10/review1date; bad_ave.dta with permno/bad1ave/bad3ave/bad10ave; and gd_rating_year.dta with permno/year/rating_num/star_rating/tone, or provide their actual producer workflow.
2. For any producer workflow, specify source-to-output mappings, join keys/cardinalities, date history, filters and output directory. Do not make the candidate raw source tables an additional mandatory route while the prepared-file route remains the primary input.
3. Keep `mahasample.dta`, `aftermahapick`, `beforematching`, and `sample_2015` classified as generated workflow outputs/intermediates rather than external inputs.

Validation to perform later:

- After the required files or producer contract are supplied and a separate run is authorized, check the exact fields/periods and follow both ordered entry points in probes/workflow_trace.json.

### A_CONFIG_ROOT: Use the package root as the Stata working directory, set the main global GD to ./Data, comment out each cd-to-Data command, convert every active `$GD\...` path reference to `$GD/...`, and change the five Windows-only EMF output suffixes to PDF. The exact source-backed edits cover every explicit GD-prefixed read, save, graph export, table export and removal path; bare mahapicks intermediates remain in the package root.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISS_PATH_ROOT, ISS_EMF_EXPORT
Evidence: E_MAIN_PATH, E_APP_PATH, E_PATH_EDIT_INVENTORY, E_DOC_PATH, E_DOC_EMF, E_DOC_PDF_GRAPH

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:4–4`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use a package-root working directory and a single relative Data path for all reads and writes.

Current text:
```
global GD ".\Data"
```

Proposed replacement:
```
global GD "./Data"
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:5–5`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use a package-root working directory and a single relative Data path for all reads and writes.

Current text:
```
cd "$GD"
```

Proposed replacement:
```
* cd "$GD"
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:57–57`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear //firm-year panel for sample firms
```

Proposed replacement:
```
use "$GD/csr_gd3",clear //firm-year panel for sample firms
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:65–65`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
graph export "$GD\gd1streview_year.emf", replace 
```

Proposed replacement:
```
graph export "$GD/gd1streview_year.pdf", replace 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:68–68`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear //firm-year panel for sample firms
```

Proposed replacement:
```
use "$GD/csr_gd3",clear //firm-year panel for sample firms
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:75–75`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
graph export "$GD\gd1streviews.emf", replace 
```

Proposed replacement:
```
graph export "$GD/gd1streviews.pdf", replace 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:84–84`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\gd_rating_eyear",clear
```

Proposed replacement:
```
use "$GD/gd_rating_eyear",clear
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:85–85`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
joinby permno using "$GD\gd2v_re10re1", unmatched(master) 
```

Proposed replacement:
```
joinby permno using "$GD/gd2v_re10re1", unmatched(master) 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:103–103`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
graph export  "$GD\star_rating_eyear10g3.png", replace 
```

Proposed replacement:
```
graph export  "$GD/star_rating_eyear10g3.png", replace 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:115–115`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
graph export  "$GD\tone_eyear10g3.png", replace 
```

Proposed replacement:
```
graph export  "$GD/tone_eyear10g3.png", replace 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:124–124`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear //firm-year panel for sample firms
```

Proposed replacement:
```
use "$GD/csr_gd3",clear //firm-year panel for sample firms
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:162–162`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
graph export "$GD\csr_kld_dynamic.emf", replace  
```

Proposed replacement:
```
graph export "$GD/csr_kld_dynamic.pdf", replace  
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:170–170`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
graph export "$GD\csr_kld_dynamic_early.emf", replace
```

Proposed replacement:
```
graph export "$GD/csr_kld_dynamic_early.pdf", replace
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:175–175`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
graph export "$GD\csr_kld_dynamic_late.emf", replace
```

Proposed replacement:
```
graph export "$GD/csr_kld_dynamic_late.pdf", replace
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:184–184`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear 
```

Proposed replacement:
```
use "$GD/csr_gd3",clear 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:198–198`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear 
```

Proposed replacement:
```
use "$GD/csr_gd3",clear 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:213–213`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear 
```

Proposed replacement:
```
use "$GD/csr_gd3",clear 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:234–234`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\len.doc", bdec(3) ctitle(COX) replace
```

Proposed replacement:
```
outreg2 using "$GD/len.doc", bdec(3) ctitle(COX) replace
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:236–236`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\len.doc", bdec(3) ctitle(Weibull) 
```

Proposed replacement:
```
outreg2 using "$GD/len.doc", bdec(3) ctitle(Weibull) 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:238–238`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\len.doc", bdec(3) ctitle(Exponential)
```

Proposed replacement:
```
outreg2 using "$GD/len.doc", bdec(3) ctitle(Exponential)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:241–241`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\len.doc", bdec(3) ctitle(COX)
```

Proposed replacement:
```
outreg2 using "$GD/len.doc", bdec(3) ctitle(COX)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:243–243`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\len.doc", bdec(3) ctitle(Weibull)
```

Proposed replacement:
```
outreg2 using "$GD/len.doc", bdec(3) ctitle(Weibull)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:245–245`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\len.doc", bdec(3) ctitle(Exponential)
```

Proposed replacement:
```
outreg2 using "$GD/len.doc", bdec(3) ctitle(Exponential)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:246–246`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
rm "$GD\len.txt"
```

Proposed replacement:
```
rm "$GD/len.txt"
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:254–254`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear 
```

Proposed replacement:
```
use "$GD/csr_gd3",clear 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:256–256`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_kld_main.doc", replace bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/csr_kld_main.doc", replace bdec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:258–258`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_kld_main.doc", bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/csr_kld_main.doc", bdec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:260–260`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_kld_main.doc", bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/csr_kld_main.doc", bdec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:262–262`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_kld_main.doc", bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/csr_kld_main.doc", bdec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:263–263`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
rm "$GD\csr_kld_main.txt"
```

Proposed replacement:
```
rm "$GD/csr_kld_main.txt"
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:270–270`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear 
```

Proposed replacement:
```
use "$GD/csr_gd3",clear 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:273–273`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\kld_components", replace dec(3)
```

Proposed replacement:
```
outreg2 using "$GD/kld_components", replace dec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:275–275`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\kld_components", dec(3)
```

Proposed replacement:
```
outreg2 using "$GD/kld_components", dec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:277–277`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\kld_components", dec(3)
```

Proposed replacement:
```
outreg2 using "$GD/kld_components", dec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:279–279`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\kld_components", dec(3)
```

Proposed replacement:
```
outreg2 using "$GD/kld_components", dec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:284–284`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\kld_components2", replace dec(3)
```

Proposed replacement:
```
outreg2 using "$GD/kld_components2", replace dec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:286–286`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\kld_components2", dec(3)
```

Proposed replacement:
```
outreg2 using "$GD/kld_components2", dec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:288–288`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\kld_components2", dec(3)
```

Proposed replacement:
```
outreg2 using "$GD/kld_components2", dec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:290–290`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\kld_components2", dec(3)
```

Proposed replacement:
```
outreg2 using "$GD/kld_components2", dec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:292–292`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\kld_components2", dec(3)
```

Proposed replacement:
```
outreg2 using "$GD/kld_components2", dec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:294–294`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\kld_components2", dec(3)
```

Proposed replacement:
```
outreg2 using "$GD/kld_components2", dec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:302–302`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_kld_pm.doc", replace bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/csr_kld_pm.doc", replace bdec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:304–304`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_kld_pm.doc", bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/csr_kld_pm.doc", bdec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:312–312`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_kld_pm.doc", bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/csr_kld_pm.doc", bdec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:314–314`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_kld_pm.doc", bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/csr_kld_pm.doc", bdec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:315–315`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
rm "$GD\csr_kld_pm.txt"
```

Proposed replacement:
```
rm "$GD/csr_kld_pm.txt"
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:320–320`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_kld_robust.doc", bdec(3) replace 
```

Proposed replacement:
```
outreg2 using "$GD/csr_kld_robust.doc", bdec(3) replace 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:323–323`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_kld_robust.doc", bdec(3)  
```

Proposed replacement:
```
outreg2 using "$GD/csr_kld_robust.doc", bdec(3)  
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:326–326`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_kld_robust.doc", bdec(3)  ctitle("[-3,+3]")
```

Proposed replacement:
```
outreg2 using "$GD/csr_kld_robust.doc", bdec(3)  ctitle("[-3,+3]")
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:329–329`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_kld_robust.doc", bdec(3)  ctitle("[-5,+5]")
```

Proposed replacement:
```
outreg2 using "$GD/csr_kld_robust.doc", bdec(3)  ctitle("[-5,+5]")
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:330–330`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
rm "$GD\csr_kld_robust.txt"
```

Proposed replacement:
```
rm "$GD/csr_kld_robust.txt"
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:337–337`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear 
```

Proposed replacement:
```
use "$GD/csr_gd3",clear 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:377–377`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_kld_sub1.doc", bdec(3) replace
```

Proposed replacement:
```
outreg2 using "$GD/csr_kld_sub1.doc", bdec(3) replace
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:386–386`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_kld_sub1.doc", bdec(3) 
```

Proposed replacement:
```
outreg2 using "$GD/csr_kld_sub1.doc", bdec(3) 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:395–395`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_kld_sub1.doc", bdec(3) 
```

Proposed replacement:
```
outreg2 using "$GD/csr_kld_sub1.doc", bdec(3) 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:396–396`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
rm "$GD\csr_kld_sub1.txt"
```

Proposed replacement:
```
rm "$GD/csr_kld_sub1.txt"
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:402–402`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
joinby permno using "$GD\bad_ave", unmatched(master)
```

Proposed replacement:
```
joinby permno using "$GD/bad_ave", unmatched(master)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:412–412`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_kld_sub1ave.doc", bdec(3) replace
```

Proposed replacement:
```
outreg2 using "$GD/csr_kld_sub1ave.doc", bdec(3) replace
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:420–420`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_kld_sub1ave.doc", bdec(3) 
```

Proposed replacement:
```
outreg2 using "$GD/csr_kld_sub1ave.doc", bdec(3) 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:428–428`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_kld_sub1ave.doc", bdec(3) 
```

Proposed replacement:
```
outreg2 using "$GD/csr_kld_sub1ave.doc", bdec(3) 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:429–429`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
rm "$GD\csr_kld_sub1ave.txt"
```

Proposed replacement:
```
rm "$GD/csr_kld_sub1ave.txt"
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:438–438`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear 
```

Proposed replacement:
```
use "$GD/csr_gd3",clear 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:439–439`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
capture rm "$GD\de_kld_sub.doc"
```

Proposed replacement:
```
capture rm "$GD/de_kld_sub.doc"
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:443–443`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\de_kld_sub.doc", bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/de_kld_sub.doc", bdec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:445–445`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
rm "$GD\de_kld_sub.txt"
```

Proposed replacement:
```
rm "$GD/de_kld_sub.txt"
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:455–455`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear 
```

Proposed replacement:
```
use "$GD/csr_gd3",clear 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:457–457`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_report.doc", replace dec(3)
```

Proposed replacement:
```
outreg2 using "$GD/csr_report.doc", replace dec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:459–459`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_report.doc", append dec(3)
```

Proposed replacement:
```
outreg2 using "$GD/csr_report.doc", append dec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:465–465`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\csr_channels.doc", append dec(3)
```

Proposed replacement:
```
outreg2 using "$GD/csr_channels.doc", append dec(3)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:470–470`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear 
```

Proposed replacement:
```
use "$GD/csr_gd3",clear 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:565–565`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear 
```

Proposed replacement:
```
use "$GD/csr_gd3",clear 
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:641–641`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
save "$GD\mahasample", replace 
```

Proposed replacement:
```
save "$GD/mahasample", replace 
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:6–6`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use a package-root working directory and a single relative Data path for all reads and writes.

Current text:
```
cd "$GD"
```

Proposed replacement:
```
* cd "$GD"
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:58–58`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear
```

Proposed replacement:
```
use "$GD/csr_gd3",clear
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:71–71`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\gd_rating_year",clear
```

Proposed replacement:
```
use "$GD/gd_rating_year",clear
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:92–92`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear
```

Proposed replacement:
```
use "$GD/csr_gd3",clear
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:99–99`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
joinby permno year using "$GD\gd_rating_year", unmatched(master)
```

Proposed replacement:
```
joinby permno year using "$GD/gd_rating_year", unmatched(master)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:123–123`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
joinby permno using "$GD\bad_ave", unmatched(master)
```

Proposed replacement:
```
joinby permno using "$GD/bad_ave", unmatched(master)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:135–135`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating.doc", bdec(3) ctitle(rating) replace 
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating.doc", bdec(3) ctitle(rating) replace 
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:137–137`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating.doc", bdec(3) ctitle(rating) 
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating.doc", bdec(3) ctitle(rating) 
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:139–139`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating.doc", bdec(3) ctitle(rating)
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating.doc", bdec(3) ctitle(rating)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:141–141`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating.doc", bdec(3) 
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating.doc", bdec(3) 
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:143–143`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating.doc", bdec(3) 
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating.doc", bdec(3) 
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:145–145`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating.doc", bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating.doc", bdec(3)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:147–147`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
rm "$GD\gd_rating.txt"
```

Proposed replacement:
```
rm "$GD/gd_rating.txt"
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:154–154`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating_ave.doc", bdec(3) ctitle(rating) replace 
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating_ave.doc", bdec(3) ctitle(rating) replace 
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:156–156`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating_ave.doc", bdec(3) ctitle(rating) 
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating_ave.doc", bdec(3) ctitle(rating) 
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:158–158`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating_ave.doc", bdec(3) ctitle(rating)
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating_ave.doc", bdec(3) ctitle(rating)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:160–160`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating_ave.doc", bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating_ave.doc", bdec(3)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:162–162`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating_ave.doc", bdec(3) 
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating_ave.doc", bdec(3) 
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:164–164`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating_ave.doc", bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating_ave.doc", bdec(3)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:166–166`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
rm "$GD\gd_rating_ave.txt"
```

Proposed replacement:
```
rm "$GD/gd_rating_ave.txt"
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:175–175`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating_nopm10.doc", bdec(3) ctitle(rating) replace 
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating_nopm10.doc", bdec(3) ctitle(rating) replace 
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:177–177`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating_nopm10.doc", bdec(3) ctitle(rating) 
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating_nopm10.doc", bdec(3) ctitle(rating) 
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:179–179`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating_nopm10.doc", bdec(3) ctitle(rating)
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating_nopm10.doc", bdec(3) ctitle(rating)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:181–181`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating_nopm10.doc", bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating_nopm10.doc", bdec(3)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:183–183`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating_nopm10.doc", bdec(3) 
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating_nopm10.doc", bdec(3) 
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:185–185`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating_nopm10.doc", bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating_nopm10.doc", bdec(3)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:187–187`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
rm "$GD\gd_rating_nopm10.txt"
```

Proposed replacement:
```
rm "$GD/gd_rating_nopm10.txt"
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:196–196`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating_ave_nopm10.doc", bdec(3) ctitle(rating) replace 
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating_ave_nopm10.doc", bdec(3) ctitle(rating) replace 
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:198–198`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating_ave_nopm10.doc", bdec(3) ctitle(rating) 
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating_ave_nopm10.doc", bdec(3) ctitle(rating) 
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:200–200`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating_ave_nopm10.doc", bdec(3) ctitle(rating)
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating_ave_nopm10.doc", bdec(3) ctitle(rating)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:202–202`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating_ave_nopm10.doc", bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating_ave_nopm10.doc", bdec(3)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:204–204`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating_ave_nopm10.doc", bdec(3) 
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating_ave_nopm10.doc", bdec(3) 
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:206–206`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\gd_rating_ave_nopm10.doc", bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/gd_rating_ave_nopm10.doc", bdec(3)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:208–208`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
rm "$GD\gd_rating_ave_nopm10.txt"
```

Proposed replacement:
```
rm "$GD/gd_rating_ave_nopm10.txt"
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:219–219`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear
```

Proposed replacement:
```
use "$GD/csr_gd3",clear
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:225–225`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
joinby permno year using "$GD\gd_rating_year", unmatched(master)
```

Proposed replacement:
```
joinby permno year using "$GD/gd_rating_year", unmatched(master)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:234–234`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\rating_fe.doc", bdec(3) ctitle(rating) replace 
```

Proposed replacement:
```
outreg2 using "$GD/rating_fe.doc", bdec(3) ctitle(rating) replace 
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:236–236`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\rating_fe.doc", bdec(3) ctitle(tone)
```

Proposed replacement:
```
outreg2 using "$GD/rating_fe.doc", bdec(3) ctitle(tone)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:253–253`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\rating_fe.doc", bdec(3) ctitle(rating_chg)
```

Proposed replacement:
```
outreg2 using "$GD/rating_fe.doc", bdec(3) ctitle(rating_chg)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:255–255`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\rating_fe.doc", bdec(3) ctitle(tone_chg)
```

Proposed replacement:
```
outreg2 using "$GD/rating_fe.doc", bdec(3) ctitle(tone_chg)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:257–257`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
rm "$GD\rating_fe.txt"
```

Proposed replacement:
```
rm "$GD/rating_fe.txt"
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:264–264`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\rating_fe_nopm10.doc", bdec(3) ctitle(rating) replace 
```

Proposed replacement:
```
outreg2 using "$GD/rating_fe_nopm10.doc", bdec(3) ctitle(rating) replace 
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:266–266`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\rating_fe_nopm10.doc", bdec(3) ctitle(tone)
```

Proposed replacement:
```
outreg2 using "$GD/rating_fe_nopm10.doc", bdec(3) ctitle(tone)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:284–284`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\rating_fe_nopm10.doc", bdec(3) ctitle(rating_chg)
```

Proposed replacement:
```
outreg2 using "$GD/rating_fe_nopm10.doc", bdec(3) ctitle(rating_chg)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:286–286`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\rating_fe_nopm10.doc", bdec(3) ctitle(tone_chg)
```

Proposed replacement:
```
outreg2 using "$GD/rating_fe_nopm10.doc", bdec(3) ctitle(tone_chg)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:288–288`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
rm "$GD\rating_fe_nopm10.txt"
```

Proposed replacement:
```
rm "$GD/rating_fe_nopm10.txt"
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:298–298`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear
```

Proposed replacement:
```
use "$GD/csr_gd3",clear
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:300–300`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\nocontrols.doc", replace bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/nocontrols.doc", replace bdec(3)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:302–302`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\nocontrols.doc", bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/nocontrols.doc", bdec(3)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:304–304`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\nocontrols.doc", bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/nocontrols.doc", bdec(3)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:306–306`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
outreg2 using "$GD\nocontrols.doc", bdec(3)
```

Proposed replacement:
```
outreg2 using "$GD/nocontrols.doc", bdec(3)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:307–307`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
rm "$GD\nocontrols.txt"
```

Proposed replacement:
```
rm "$GD/nocontrols.txt"
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:310–310`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear 
```

Proposed replacement:
```
use "$GD/csr_gd3",clear 
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:375–375`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear
```

Proposed replacement:
```
use "$GD/csr_gd3",clear
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:465–465`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear
```

Proposed replacement:
```
use "$GD/csr_gd3",clear
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:474–474`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear
```

Proposed replacement:
```
use "$GD/csr_gd3",clear
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:487–487`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Use forward-slash relative Data paths consistently from the package-root working directory; PDF replaces the Windows-only EMF suffix where applicable.

Current text:
```
use "$GD\csr_gd3",clear
```

Proposed replacement:
```
use "$GD/csr_gd3",clear
```

Preparation / proposed procedure:

1. Prepare a Data directory under the package root containing the named prepared .dta inputs.
2. Apply the full static edit inventory to working copies and run both scripts with the package root as the current directory; matching files created by the bare genfile/usefile names stay at that root.

Validation to perform later:

- Before a separately authorized run, statically confirm that explicit `$GD/` reads/outputs resolve under package-root/Data, bare mahapicks/mahapicks2 paths resolve under the package root, both do-files leave the current directory at the package root, and no affected producer/consumer path was omitted.
- Confirm all five graph exports use PDF and preserve their graph commands/options.

### A_CORRECT_ESAMPLE: Correct all active misspellings of the Stata estimation-sample function in the appendix program after checking every occurrence.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISS_E_SAMPLE_TYPO
Evidence: E_APP_TYPO, E_APP_ESAMPLE_60, E_APP_ESAMPLE_94, E_APP_ESAMPLE_221, E_APP_ESAMPLE_382, E_APP_ESAMPLE_400, E_APP_ESAMPLE_421, E_APP_ESAMPLE_446, E_DOC_ESAMPLE

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:60–60`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Correct the misspelled Stata estimation-sample function, preserving the intended sample restriction.

Current text:
```
keep if e(smaple)
```

Proposed replacement:
```
keep if e(sample)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:94–94`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Correct the misspelled Stata estimation-sample function, preserving the intended sample restriction.

Current text:
```
keep if e(smaple)
```

Proposed replacement:
```
keep if e(sample)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:221–221`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Correct the misspelled Stata estimation-sample function, preserving the intended sample restriction.

Current text:
```
keep if e(smaple)
```

Proposed replacement:
```
keep if e(sample)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:382–382`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Correct the misspelled Stata estimation-sample function, preserving the intended sample restriction.

Current text:
```
keep if e(smaple)
```

Proposed replacement:
```
keep if e(sample)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:400–400`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Correct the misspelled Stata estimation-sample function, preserving the intended sample restriction.

Current text:
```
keep if e(smaple)
```

Proposed replacement:
```
keep if e(sample)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:421–421`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Correct the misspelled Stata estimation-sample function, preserving the intended sample restriction.

Current text:
```
keep if e(smaple)
```

Proposed replacement:
```
keep if e(sample)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:446–446`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Correct the misspelled Stata estimation-sample function, preserving the intended sample restriction.

Current text:
```
keep if e(smaple)
```

Proposed replacement:
```
keep if e(sample)
```

Preparation / proposed procedure:

1. Apply the seven one-token changes in the appendix working copy; preserve each regression and its sample condition.

Validation to perform later:

- Statically compare every changed line with the frozen source before any separately authorized execution.

### A_COMMENT_DATASET_PROSE: Comment the nine active dataset-description prose lines in working copies while preserving their wording.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISS_ACTIVE_DATASET_PROSE
Evidence: E_MAIN_SCOPE, E_APP_SCOPE, E_DOC_COMMENTS

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:15–15`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Mark the supplied dataset-description prose as a Stata comment without changing its content.

Current text:
```
"$GD\csr_gd3", firm-year panels from 2003-2018
```

Proposed replacement:
```
* "$GD\csr_gd3", firm-year panels from 2003-2018
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:16–16`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Mark the supplied dataset-description prose as a Stata comment without changing its content.

Current text:
```
"$GD\gd2v_re10re1", summary statistics of firms' first (3/10) reviews
```

Proposed replacement:
```
* "$GD\gd2v_re10re1", summary statistics of firms' first (3/10) reviews
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:17–17`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Mark the supplied dataset-description prose as a Stata comment without changing its content.

Current text:
```
"$GD\bad_ave", indicates whether the firm's initiative rating is negative relative to industry peer's average glassdoor ratings in that year
```

Proposed replacement:
```
* "$GD\bad_ave", indicates whether the firm's initiative rating is negative relative to industry peer's average glassdoor ratings in that year
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:18–18`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Mark the supplied dataset-description prose as a Stata comment without changing its content.

Current text:
```
"$GD\gd_rating_eyear", yearly Glassdoor reviews statistics aggregated by event year (relative to the 1st review)
```

Proposed replacement:
```
* "$GD\gd_rating_eyear", yearly Glassdoor reviews statistics aggregated by event year (relative to the 1st review)
```

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:19–19`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Mark the supplied dataset-description prose as a Stata comment without changing its content.

Current text:
```
"$GD\mahasample", sample for Mahalanobis distance matched sample, to replicate our numbers
```

Proposed replacement:
```
* "$GD\mahasample", sample for Mahalanobis distance matched sample, to replicate our numbers
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:16–16`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Mark the supplied dataset-description prose as a Stata comment without changing its content.

Current text:
```
"$GD\csr_gd3", firm-year panels from 2003-2018
```

Proposed replacement:
```
* "$GD\csr_gd3", firm-year panels from 2003-2018
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:17–17`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Mark the supplied dataset-description prose as a Stata comment without changing its content.

Current text:
```
"$GD\gd_rating_year", yearly Glassdoor reviews statistics aggregated from individual reviews by calendar year
```

Proposed replacement:
```
* "$GD\gd_rating_year", yearly Glassdoor reviews statistics aggregated from individual reviews by calendar year
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:18–18`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Mark the supplied dataset-description prose as a Stata comment without changing its content.

Current text:
```
"$GD\gd_rating_eyear", yearly Glassdoor reviews statistics aggregated from individual reviews by event year (relative to the 1st review)
```

Proposed replacement:
```
* "$GD\gd_rating_eyear", yearly Glassdoor reviews statistics aggregated from individual reviews by event year (relative to the 1st review)
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:19–19`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Mark the supplied dataset-description prose as a Stata comment without changing its content.

Current text:
```
"$GD\bad_ave", indicates whether the firm's initiative rating is negative relative to industry peer's average glassdoor ratings in that year
```

Proposed replacement:
```
* "$GD\bad_ave", indicates whether the firm's initiative rating is negative relative to industry peer's average glassdoor ratings in that year
```

Preparation / proposed procedure:

1. Prefix main lines 15-19 and appendix lines 16-19 with `* ` in working copies; preserve the supplied descriptions.

Validation to perform later:

- Statically verify the nine lines begin with `*` and no author descriptions were deleted or altered.

### A_VERSION_TABLE_CALLS: Use per-call Stata version control for the three legacy table c() calls so they retain their supplied syntax in Stata 18.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: ISS_LEGACY_TABLE
Evidence: E_TABLE_MAIN_208, E_TABLE_APP_80, E_TABLE_APP_82, E_DOC_TABLE, E_DOC_VERSION_PREFIX

**Proposed edit:** `Code/csr_gd_main analysis_20210629.do:208–208`
Source SHA-256: `65148dd5f3a65f282a90bf724ac13986235c746688cc97aaa13dfa0955db341f`

Preserve the authored legacy table c() syntax using per-command Stata version control.

Current text:
```
table ff12 if reviewed==1, c(N len median len) //conditional being reviewed before the data collection date
```

Proposed replacement:
```
version 16: table ff12 if reviewed==1, c(N len median len) //conditional being reviewed before the data collection date
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:80–80`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Preserve the authored legacy table c() syntax using per-command Stata version control.

Current text:
```
table year, c(sum rating_num mean star_rating sd star_rating mean tone sd tone )
```

Proposed replacement:
```
version 16: table year, c(sum rating_num mean star_rating sd star_rating mean tone sd tone )
```

**Proposed edit:** `Code/csr_gd_online appendix_20210629.do:82–82`
Source SHA-256: `86829f0b9bb1ba4a6f178267b19b2437d52d15496f41853b37ff5784a75b7151`

Preserve the authored legacy table c() syntax using per-command Stata version control.

Current text:
```
table ff12, c(mean star_rating sd star_rating mean tone sd tone )
```

Proposed replacement:
```
version 16: table ff12, c(mean star_rating sd star_rating mean tone sd tone )
```

Preparation / proposed procedure:

1. Prefix the three listed calls with `version 16:` in both working copies; retain their tables, options, and surrounding analyses.

Validation to perform later:

- Statically confirm all three legacy calls have the version prefix. Do not run trial table or descriptive commands during this review.

### A_SOFTWARE_SETUP: Set up the seven required community commands that were not found by the bounded metadata checks. This is environment preparation; no installer or download was run during assessment.

Scopes: full_pipeline. Type: software_setup. Certainty: supported.
Addresses: SW_PSMATCH2, SW_MAHAPICK, SW_MAHASELECTUNIQUE, SW_BACONDECOMP, SW_COMPLETE_RA, SW_OUTREG2, SW_WINSOR2
Evidence: E_SOFTWARE_PSMATCH2, E_SOFTWARE_MAHAPICK, E_SOFTWARE_MAHASELECTUNIQUE, E_SOFTWARE_BACONDECOMP, E_SOFTWARE_COMPLETE_RA, E_SOFTWARE_OUTREG2, E_SOFTWARE_WINSOR2, E_MAIN_PSMATCH2, E_MAIN_MATCHING, E_APP_BACONDECOMP, E_APP_A5_RANDOMIZATION, E_MAIN_OUTREG2, E_APP_WINSOR_251, E_APP_WINSOR_282

Preparation / proposed procedure:

1. Make psmatch2, mahapick, mahaselectunique, bacondecomp, complete_ra, outreg2, and winsor2 available on the Stata adopath using their documented distribution/setup instructions.
2. Retain Stata 18, available reghdfe 6.12.3 and ftools 2.49.1, coefplot, and _gxtile; do not replace the authored estimator, matching steps, or winsor2 variables.

Validation to perform later:

- Before a separately authorized run, use `which` and package version metadata to confirm the required command locations/versions; no estimator or data command is part of software setup validation.

### A_MATCHING_CONTRACT: After the required command versions are available, consult their version-specific help/documentation and compare the documented output interface with the supplied downstream merge keys permno, _prime_id, and _matchnum. If those documents resolve the interface, no author clarification is needed; request a specific unresolved interface only if they do not.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: ISS_WORKFLOW_CLOSURE
Evidence: E_MAIN_MATCHING, E_MAIN_MATCHING_REFRESH, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. After command setup, read the help/documentation for the exact mahapick and mahaselectunique versions found; compare their documented output columns, key uniqueness, row meaning, and year behavior to the supplied consumers.
2. Preserve the supplied sequence that writes mahapicks.dta and mahapicks2.dta, reads mahapicks.dta, merges on permno _prime_id _matchnum, saves each year to mahapick, then merges by permno/year into aftermahapick; treat these as supplied generated stages.

Validation to perform later:

- Using documentation only, verify the exact available add-on's output interface against every consuming merge in the main branch before any separately authorized run; do not run a synthetic or statistical command trial.

### A_ORDERED_RUN_PROCEDURE: Follow both supplied entry points with their named prepared inputs, source-supported working-copy corrections, and generated intermediates; the ordered branches are recorded in the linked workflow trace.

Scopes: full_pipeline. Type: run_procedure. Certainty: conditional.
Addresses: R_CSR_PANEL, R_FIRST_REVIEWS, R_BAD_AVERAGE, R_EVENT_REVIEW_STATS, R_CALENDAR_REVIEW_STATS, ISS_DATA_CONSTRUCTION, ISS_WORKFLOW_CLOSURE, ISS_FIGURE2_JOIN_CONTRACT
Evidence: E_README, E_MAIN_SCOPE, E_APP_SCOPE, E_WORKFLOW_TRACE

Preparation / proposed procedure:

1. Complete the supported source/path/software preparation and supply the five exact prepared inputs or their documented producer specifications.
2. From the package root, run the main do-file through its figures/tables; its Figure 2 branch uses gd_rating_eyear joined to gd2v_re10re1, and its Mahalanobis branch generates the matching files and mahasample output in the recorded order.
3. Run the appendix do-file separately through A1-A5; A1-A3 use gd_rating_year, A4 creates/loads cohort tempfiles, and A5 uses complete_ra.
4. Keep any newly supplied input construction as a separate producer handoff; do not launch the appendix from the main file or treat the identifier list as the panel.

Validation to perform later:

- Under separate run authorization, verify each generated product against the traced downstream key, fields, and order; execution has not been verified in this static assessment.


## Remaining issues and prerequisites

- ISS_DATA_CONSTRUCTION [unresolved; full_pipeline]: The supplied Stata files consume, but do not construct, the required csr_gd3, gd2v_re10re1, bad_ave, gd_rating_eyear, and gd_rating_year datasets. The package inventory contains identifiers.dta but no Data directory or prepared panel/aggregates. The datasheet describes manual and commercial sources but provides no field-level producer, joins, cardinalities, complete date history, or mapping to these analysis files. Figure 2's rating10/review1date ownership across its two joined files is also unconfirmed.
- ISS_PATH_ROOT [preparation; full_pipeline]: Both programs define a relative Data path, change into it, and then continue to prefix reads, writes, graph exports, table outputs and removals with that relative path; this leaves an inconsistent effective root. The 129-line working-copy edit inventory sets package-root execution, keeps explicit GD-prefixed inputs/outputs under Data, leaves bare mahapicks/mahapicks2 intermediates at the package root, uses forward slashes, and changes five Windows-only EMF suffixes to PDF.
- ISS_E_SAMPLE_TYPO [preparation; full_pipeline]: Seven active appendix lines use e(smaple) after regressions. The source-supported one-token working-copy correction is e(sample), preserving each intended estimation-sample restriction.
- ISS_WORKFLOW_CLOSURE [unresolved; full_pipeline]: The supplied main matching loop uses mahapick and mahaselectunique to produce matching files, then reads and merges them on permno _prime_id _matchnum. These add-on versions were not found on checked paths, so their version-specific help/documentation and output-interface compatibility with the consuming merge must be confirmed after setup. The generated files are not missing external inputs, and the source sequence does not require an independently reconstructed author program.
- ISS_FIGURE2_JOIN_CONTRACT [unresolved; full_pipeline]: Figure 2 joins gd_rating_eyear and gd2v_re10re1 by permno; later code uses rating10 and review1date, but both input schemas are absent. The supplied source does not assign either post-join field to a specific file. rating103g is generated later from rating10 and is not a separate raw input requirement.
- ISS_ACTIVE_DATASET_PROSE [preparation; full_pipeline]: Nine quoted dataset-description lines in the two do-files are not prefixed by Stata comment markers. In working copies prefix main lines 15-19 and appendix lines 16-19 with `* ` while preserving their wording; the Stata 18 manual says a leading `*` makes the line ignored.
- ISS_LEGACY_TABLE [preparation; full_pipeline]: The main program has one table call and the appendix has two calls using legacy c() syntax. Stata redesigned table in version 17 and preserves old behavior under version control; apply a per-call `version 16:` prefix to all three calls, preserving their options.
- ISS_EMF_EXPORT [preparation; full_pipeline]: The main script contains five .emf graph exports, while the checked Stata 18 runtime is Linux. Stata documents EMF as a Windows export format and PDF as a vector format; change only each output suffix to .pdf.
- R_CSR_PANEL [undetermined]: Author-prepared 2003-2018 firm-year panel consumed by both programs as Data/csr_gd3.dta. Directly referenced imported fields include permno, year, fyear, ff12, ff48, ff48year, review1date, review1date2, review1rating, rating3, rating10, post_gd, de_kld, oth_kld, wl, comp, culture, residual, comp_str, comp_con, culture_str, culture_con, residual_str, residual_con, emppct_report, emppct_report_w, lnnummf, lnfcount8k, nummf, fcount8k, high_empat, high_pih, youngceo, pm10, lnsale, roa_w, btm_w, cash_w, div_w, leverage_w, sa_index_w, pih_w, lnnumana, rd_w, ad_w, and ln_emp_at. The exact producer, input history and joins are not supplied.
- R_FIRST_REVIEWS [undetermined]: Prepared first-review summary read as Data/gd2v_re10re1.dta and joined by permno to the event-year Glassdoor statistics in Figure 2. `permno` is the documented join key. The combined post-join result must provide rating10 and review1date, but the supplied code does not establish which joined input supplies either field.
- R_BAD_AVERAGE [undetermined]: Prepared firm-level classification relative to industry-year review averages, joined by permno in the main and appendix classification branches. Directly referenced columns are permno, bad1ave, bad3ave, and bad10ave; derivation, cardinality, and history are not supplied.
- R_EVENT_REVIEW_STATS [undetermined]: Prepared firm-by-event-year Glassdoor rating and tone statistics read by Figure 2 and joined by permno to the first-review summary. Directly referenced event-year fields include permno, eyear, star_rating, and tone. The combined post-join result must provide rating10 and review1date, with ownership across the two joined files unresolved.
- R_CALENDAR_REVIEW_STATS [undetermined]: Prepared firm-calendar-year Glassdoor statistics read in appendix Tables A1-A3 and joined by permno/year. Directly referenced fields include permno, year, rating_num, star_rating, tone, and the appended panel's ff12 classification; the producer and aggregation contract are absent.
- SW_PSMATCH2 [preparation_required]: Not found by the bounded `which` check on the default Stata adopath; set up the required command before running the main matching branch.
- SW_MAHAPICK [preparation_required]: Not found by the bounded `which` check on the default Stata adopath; required by the main Mahalanobis matching loop.
- SW_MAHASELECTUNIQUE [preparation_required]: Not found by the bounded `which` check on the default Stata adopath; required to produce the second matching file.
- SW_BACONDECOMP [preparation_required]: Not found by the bounded `which` check on the default Stata adopath; required by the appendix decomposition branch.
- SW_COMPLETE_RA [preparation_required]: Not found by the bounded `which` check on the default Stata adopath; required by appendix A5 random assignment.
- SW_OUTREG2 [preparation_required]: Not found on the checked default and configured Stata adopaths; used to export many main and appendix tables.
- SW_WINSOR2 [preparation_required]: Not found on the checked default and configured Stata adopaths; used on star_rating_chg and tone_chg in appendix code. Preserve these authored calls and variables.

## Review notes

- Static assessment covers both independent Stata entry points and all documented main and appendix branches. All eight frozen dependency IDs are reviewed; generated matching/cohort intermediates remain generated, and mahasample is an output. Five required prepared inputs are absent, their construction and key field/history contracts remain unresolved, and Figure 2 post-join rating10/review1date ownership is unassigned. Bounded software metadata and official Stata documentation support the listed environment preparation and exact working-copy edits. No author program, data transform, descriptive command, estimator, or statistical trial was run; execution remains unverified.
