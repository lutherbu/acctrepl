# Patch proposal: jar-889910bc7428

Resolving Information Asymmetry through Contractual Risk Sharing: The Case of Private Firm

DOI: 10.1111/1475-679X.12335

Status: proposal only. No author code has been changed or executed.

## Target and readiness

| Scope | Data access | Execution readiness |
|---|---|---|
| full_pipeline | undetermined | undetermined |

### full_pipeline

All supplied author branches in seller_financing_code.do: the two figures, Table 1A-C, main Tables 2A-7, and Appendix B1-B4D, starting from Transactions_Data_2015.dta. The supplied program contains no producer for that prepared table, so the complete transformation handoff remains unresolved.

Entry points: `seller_financing_code.do`

Dependency closure: unresolved; see the issues and actions below.

## Source provenance

```
{
  "import_manifest_sha256": "376918f3b67cc4fe85ebeefa4950c9569ae5d1842307862fec43eaf0ff8b6b0d",
  "package_files": [
    {
      "path": "JAR-Volume 58/Issue 5/12335 - Resolving-Information-Asymmetry-through-Contractual-Risk-Sharing-The-Case-of-Private-Firm/jansen-datasheet-and-code.zip",
      "sha256": "912c2de93d3198bdb52806ae70e89bf420cbd402395a61e4a56a040b63052427"
    }
  ],
  "resource_catalog_sha256": "4fbed8b9668ba690dbce68bcbae08bbe4f3780cf4051a1d3f9fc11c43d336a27",
  "skill_sha256": "3189a6020750463db163d8b63addab7d94475423c1b01f8e9a73994a125ca463",
  "work_item_sha256": "5ce8de01c6a4bd82c089b389eac136b6469e2f2cbdf8a7e4e70cbf824a0d9e28"
}
```

## Proposed actions

### A-DATA-001: Resolve the exact prepared analysis-input route and the missing producer/schema handoff without assuming that a BVR brand match or a generic M&A file supplies the authored table.

Scopes: full_pipeline. Type: clarification. Certainty: conditional.
Addresses: R-DATA-001, I-DATA-ABSENT, I-DATA-CONTRACT
Evidence: E-LOAD, E-DATASHEET-DATA, E-DATASHEET-PROPRIETARY, E-DATASHEET-CODE, E-INVENTORY, E-CATALOG, E-SDC-PROBE, E-WORKFLOW-TRACE

Preparation / proposed procedure:

1. Confirm whether a compatible author-prepared Transactions_Data_2015.dta (or documented exact equivalent) can be supplied through an already authorized route; place it under Data/ only after the route is established.
2. Document its row unit, unique-key rules, file format/types, transaction population, coverage and variable definitions. Compare all expected fields in R-DATA-001-PREPARED against the actual table, including exact Stata case such as Earnout versus earnout and TransactionCosts versus l_TransactionCosts.
3. The two figure commands use yr 1995-2015 inclusive; the other supplied analysis branches have no overall year filter, so obtain the exact analysis population/history rather than infer a start date from the figures or filename.
4. If the prepared table is unavailable, obtain the missing producer program/specification and exact input-to-analysis-variable mapping before considering a raw rebuild. The datasheet identifies historical BVR primary data but no exact BVR product/export or current route; do not guess another vendor product or treat Minnis, Francis/Gunn, Moller or Garmaise origins as extra mandatory inputs when a compatible prepared table may include those fields.
5. Keep TransactionID as a BVR-specific identifier with no outside-resource crosswalk; BuyerCIK is reported but not used by the authors. The locally readable SDC.WRDS_MA_DETAILS candidate has distinct keys/fields and no documented transformation to this prepared input, so do not substitute it or infer joins from its names.

Validation to perform later:

- After an exact input is supplied, use a bounded metadata probe to check readability and the full expected-field list; separately confirm row unit, key, period and population because a one-row probe cannot establish coverage.
- Only after the route and construction contract are resolved, review the complete supplied workflow in an authorized working copy.

### A-CODE-001: Prepare a working copy of seller_financing_code.do for one host-visible relative project root and correct the documented Stata command-grammar placements while preserving all supplied branches, filters, model terms, options and output names.

Scopes: full_pipeline. Type: source_edit. Certainty: supported.
Addresses: I-PATHS, I-SYNTAX
Evidence: E-LOAD, E-PATHS, E-OUTPUT-FIGURES, E-OUTPUT-TABLE1, E-EDIT-PROPOSAL, E-PUB-STATA-SYNTAX, E-PUB-SUMMARIZE, E-PUB-TWOWAY, E-PUB-REGRESS, E-PUB-REGHDFE, E-PUB-ESTTAB

**Proposed edit:** `seller_financing_code.do:2–2`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Run from one relative project root rather than the original Windows data directory.

Current text:
```
cd "[redacted-path-b5fac5e97e7b]"
```

Proposed replacement:
```
cd "."
```

**Proposed edit:** `seller_financing_code.do:3–3`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Read the same prepared input from the Data directory under the host wrapper working root.

Current text:
```
use Transactions_Data_2015.dta, clear
```

Proposed replacement:
```
use "Data/Transactions_Data_2015.dta", clear
```

**Proposed edit:** `seller_financing_code.do:10–10`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the graph-wide yr filter before the top-level graph-options comma, preserving both plot-specific filters and the 1995-2015 range.

Current text:
```
	twoway (line note_paid_avg_yr yr if public_buyer==0) (line note_paid_avg_yr yr if public_buyer==1, lcolor(forest_green) lpattern(dash)), ymtick(, nolabels) ytitle(Transactions using Seller Financing (%)) legend(lab(1 Private Buyer) lab(2 Public Buyer)) legend(cols(1) ring(0) position(2) bmargin(large)) scheme(s1mono) xtitle(Transaction Year) subtitle(, nobox), if yr>1994 & yr<2016
```

Proposed replacement:
```
	twoway (line note_paid_avg_yr yr if public_buyer==0) (line note_paid_avg_yr yr if public_buyer==1, lcolor(forest_green) lpattern(dash)) if yr>1994 & yr<2016, ymtick(, nolabels) ytitle(Transactions using Seller Financing (%)) legend(lab(1 Private Buyer) lab(2 Public Buyer)) legend(cols(1) ring(0) position(2) bmargin(large)) scheme(s1mono) xtitle(Transaction Year) subtitle(, nobox)
```

**Proposed edit:** `seller_financing_code.do:11–11`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	graph export "[redacted-path-b66b4dbb4bd1]", replace
```

Proposed replacement:
```
	graph export "Results/App_SF_yr.png", replace
```

**Proposed edit:** `seller_financing_code.do:14–14`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the graph-wide yr filter before the top-level graph-options comma, preserving both plot-specific filters and the 1995-2015 range.

Current text:
```
	twoway (line earnout_avg_yr yr if public_buyer==0) (line earnout_avg_yr yr if public_buyer==1, lcolor(forest_green) lpattern(dash)), ymtick(, nolabels) ytitle(Transactions using Earnouts (%)) legend(lab(1 Private Buyer) lab(2 Public Buyer)) legend(cols(1) ring(0) position(10) bmargin(large)) scheme(s1mono) xtitle(Transaction Year) subtitle(, nobox), if yr>1994 & yr<2016
```

Proposed replacement:
```
	twoway (line earnout_avg_yr yr if public_buyer==0) (line earnout_avg_yr yr if public_buyer==1, lcolor(forest_green) lpattern(dash)) if yr>1994 & yr<2016, ymtick(, nolabels) ytitle(Transactions using Earnouts (%)) legend(lab(1 Private Buyer) lab(2 Public Buyer)) legend(cols(1) ring(0) position(10) bmargin(large)) scheme(s1mono) xtitle(Transaction Year) subtitle(, nobox)
```

**Proposed edit:** `seller_financing_code.do:15–15`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	graph export "[redacted-path-7f6ea1f7f9d9]", replace
```

Proposed replacement:
```
	graph export "Results/App_EO_yr.png", replace
```

**Proposed edit:** `seller_financing_code.do:24–24`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Place the same using filename before the esttab options comma and preserve all options.

Current text:
```
	esttab, cells("mean sd p25 p50 p75 count" b(fmt(%12.3fc))) label replace, using "[redacted-path-7db53aee2019]"
```

Proposed replacement:
```
	esttab using "Results/1_summary_stat.tex", cells("mean sd p25 p50 p75 count" b(fmt(%12.3fc))) label replace
```

**Proposed edit:** `seller_financing_code.do:25–25`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Place the same using filename before the esttab options comma and preserve all options.

Current text:
```
	esttab, cells("mean sd p25 p50 p75 count" b(fmt(%12.3fc))) label replace, using "[redacted-path-22c6dc77e25d]"
```

Proposed replacement:
```
	esttab using "Results/1_summary_stat.csv", cells("mean sd p25 p50 p75 count" b(fmt(%12.3fc))) label replace
```

**Proposed edit:** `seller_financing_code.do:31–31`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab using "[redacted-path-7db53aee2019]", replace cells("mean(fmt(%7.2fc) label(Mean)) sd(fmt(%7.2fc) label(Std Dev)) p25(fmt(%7.2fc)) p50(fmt(%7.2fc)) p75(fmt(%7.2fc)) count(fmt(%9.0fc) label(N Obs))") fragment nofloat booktabs noobs label nonumber ord(`vlst1')
```

Proposed replacement:
```
	esttab using "Results/1_summary_stat.tex", replace cells("mean(fmt(%7.2fc) label(Mean)) sd(fmt(%7.2fc) label(Std Dev)) p25(fmt(%7.2fc)) p50(fmt(%7.2fc)) p75(fmt(%7.2fc)) count(fmt(%9.0fc) label(N Obs))") fragment nofloat booktabs noobs label nonumber ord(`vlst1')
```

**Proposed edit:** `seller_financing_code.do:40–40`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original summary-statistic sample qualifier before the options comma, preserving the detail option.

Current text:
```
	state_audit disclosure_nomerit noncompete_garmaise, detail, if note_paid==0 & public_buyer==0
```

Proposed replacement:
```
	state_audit disclosure_nomerit noncompete_garmaise if note_paid==0 & public_buyer==0, detail
```

**Proposed edit:** `seller_financing_code.do:41–41`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Place the same using filename before the esttab options comma and preserve all options.

Current text:
```
	esttab, cells("mean sd p50 count" b(fmt(%12.3fc))) label replace, using "[redacted-path-06d8d9252907]"
```

Proposed replacement:
```
	esttab using "Results/1_summary_stat_pb_0_sf_0.tex", cells("mean sd p50 count" b(fmt(%12.3fc))) label replace
```

**Proposed edit:** `seller_financing_code.do:42–42`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Place the same using filename before the esttab options comma and preserve all options.

Current text:
```
	esttab, cells("mean sd p50 count" b(fmt(%12.3fc))) label replace, using "[redacted-path-de67066efdf9]"
```

Proposed replacement:
```
	esttab using "Results/1_summary_stat_pb_0_sf_0.csv", cells("mean sd p50 count" b(fmt(%12.3fc))) label replace
```

**Proposed edit:** `seller_financing_code.do:47–47`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original summary-statistic sample qualifier before the options comma, preserving the detail option.

Current text:
```
	state_audit disclosure_nomerit noncompete_garmaise, detail, if note_paid==1 & public_buyer==0
```

Proposed replacement:
```
	state_audit disclosure_nomerit noncompete_garmaise if note_paid==1 & public_buyer==0, detail
```

**Proposed edit:** `seller_financing_code.do:48–48`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Place the same using filename before the esttab options comma and preserve all options.

Current text:
```
	esttab, cells("mean sd p50 count" b(fmt(%12.3fc))) label replace, using "[redacted-path-26ca7b021f8b]"
```

Proposed replacement:
```
	esttab using "Results/1_summary_stat_pb_0_sf_1.tex", cells("mean sd p50 count" b(fmt(%12.3fc))) label replace
```

**Proposed edit:** `seller_financing_code.do:49–49`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Place the same using filename before the esttab options comma and preserve all options.

Current text:
```
	esttab, cells("mean sd p50 count" b(fmt(%12.3fc))) label replace, using "[redacted-path-2a5a729d1697]"
```

Proposed replacement:
```
	esttab using "Results/1_summary_stat_pb_0_sf_1.csv", cells("mean sd p50 count" b(fmt(%12.3fc))) label replace
```

**Proposed edit:** `seller_financing_code.do:55–55`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original regression sample qualifier before the options comma and preserve cluster(ind_code_48).

Current text:
```
	quietly reg  `v' note_paid, cluster(ind_code_48),  if public_buyer==0
```

Proposed replacement:
```
	quietly reg  `v' note_paid if public_buyer==0, cluster(ind_code_48)
```

**Proposed edit:** `seller_financing_code.do:58–58`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab n* using "[redacted-path-954df26ea2d8]" , p stats(N, fmt(%9.0g) labels(R-squared)) legend label mtitle modelwidth(10) collabels(none) star(* 0.1 ** 0.05 *** 0.01)  replace
```

Proposed replacement:
```
	esttab n* using "Results/1_summary_stat_pb_0_ttest.csv" , p stats(N, fmt(%9.0g) labels(R-squared)) legend label mtitle modelwidth(10) collabels(none) star(* 0.1 ** 0.05 *** 0.01)  replace
```

**Proposed edit:** `seller_financing_code.do:65–65`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original summary-statistic sample qualifier before the options comma, preserving the detail option.

Current text:
```
	state_audit disclosure_nomerit noncompete_garmaise, detail, if note_paid==0 & public_buyer==1
```

Proposed replacement:
```
	state_audit disclosure_nomerit noncompete_garmaise if note_paid==0 & public_buyer==1, detail
```

**Proposed edit:** `seller_financing_code.do:66–66`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Place the same using filename before the esttab options comma and preserve all options.

Current text:
```
	esttab, cells("mean sd p50 count" b(fmt(%12.3fc))) label replace, using "[redacted-path-c0d2a695eac8]"
```

Proposed replacement:
```
	esttab using "Results/1_summary_stat_pb_1_sf_0.tex", cells("mean sd p50 count" b(fmt(%12.3fc))) label replace
```

**Proposed edit:** `seller_financing_code.do:67–67`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Place the same using filename before the esttab options comma and preserve all options.

Current text:
```
	esttab, cells("mean sd p50 count" b(fmt(%12.3fc))) label replace, using "[redacted-path-5e1f01b4caa9]"
```

Proposed replacement:
```
	esttab using "Results/1_summary_stat_pb_1_sf_0.csv", cells("mean sd p50 count" b(fmt(%12.3fc))) label replace
```

**Proposed edit:** `seller_financing_code.do:72–72`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original summary-statistic sample qualifier before the options comma, preserving the detail option.

Current text:
```
	state_audit disclosure_nomerit noncompete_garmaise, detail, if note_paid==1 & public_buyer==1
```

Proposed replacement:
```
	state_audit disclosure_nomerit noncompete_garmaise if note_paid==1 & public_buyer==1, detail
```

**Proposed edit:** `seller_financing_code.do:73–73`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Place the same using filename before the esttab options comma and preserve all options.

Current text:
```
	esttab, cells("mean sd p50 count" b(fmt(%12.3fc))) label replace, using "[redacted-path-3fcc63e3d9ef]"
```

Proposed replacement:
```
	esttab using "Results/1_summary_stat_pb_1_sf_1.tex", cells("mean sd p50 count" b(fmt(%12.3fc))) label replace
```

**Proposed edit:** `seller_financing_code.do:74–74`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Place the same using filename before the esttab options comma and preserve all options.

Current text:
```
	esttab, cells("mean sd p50 count" b(fmt(%12.3fc))) label replace, using "[redacted-path-94aa51f3073d]"
```

Proposed replacement:
```
	esttab using "Results/1_summary_stat_pb_1_sf_1.csv", cells("mean sd p50 count" b(fmt(%12.3fc))) label replace
```

**Proposed edit:** `seller_financing_code.do:80–80`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original regression sample qualifier before the options comma and preserve cluster(ind_code_48).

Current text:
```
	quietly reg  `v' note_paid, cluster(ind_code_48),  if public_buyer==1
```

Proposed replacement:
```
	quietly reg  `v' note_paid if public_buyer==1, cluster(ind_code_48)
```

**Proposed edit:** `seller_financing_code.do:83–83`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab n* using "[redacted-path-5b29129acdcc]" , p stats(N, fmt(%9.0g) labels(R-squared)) legend label mtitle modelwidth(10) collabels(none) star(* 0.1 ** 0.05 *** 0.01)  replace
```

Proposed replacement:
```
	esttab n* using "Results/1_summary_stat_pb_1_ttest.csv" , p stats(N, fmt(%9.0g) labels(R-squared)) legend label mtitle modelwidth(10) collabels(none) star(* 0.1 ** 0.05 *** 0.01)  replace
```

**Proposed edit:** `seller_financing_code.do:100–100`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab r1 r2 r3 r4 r5 r6 using "[redacted-path-3c0cdb58422b]", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

Proposed replacement:
```
	esttab r1 r2 r3 r4 r5 r6 using "Results/2A_Firm.tex", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

**Proposed edit:** `seller_financing_code.do:104–104`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r2: reghdfe note_paid  				l_age Age_Ind EBTtoS l_revenue disclosure_nomerit, cluster(state_id) absorb(ind_code_48 yr), if public_buyer==0
```

Proposed replacement:
```
	quietly eststo r2: reghdfe note_paid  				l_age Age_Ind EBTtoS l_revenue disclosure_nomerit if public_buyer==0, cluster(state_id) absorb(ind_code_48 yr)
```

**Proposed edit:** `seller_financing_code.do:105–105`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r3: reghdfe note_paid  				l_age Age_Ind EBTtoS l_revenue state_audit, cluster(state_id) absorb(ind_code_48 yr), if public_buyer==0
```

Proposed replacement:
```
	quietly eststo r3: reghdfe note_paid  				l_age Age_Ind EBTtoS l_revenue state_audit if public_buyer==0, cluster(state_id) absorb(ind_code_48 yr)
```

**Proposed edit:** `seller_financing_code.do:106–106`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r4: reghdfe note_paid           		l_age Age_Ind EBTtoS l_revenue stock_purchase, cluster(ind_code_48) absorb(ind_code_48 yr), if public_buyer==0	
```

Proposed replacement:
```
	quietly eststo r4: reghdfe note_paid           		l_age Age_Ind EBTtoS l_revenue stock_purchase if public_buyer==0	, cluster(ind_code_48) absorb(ind_code_48 yr)
```

**Proposed edit:** `seller_financing_code.do:107–107`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r5: reghdfe note_paid           		l_age Age_Ind EBTtoS l_revenue hi_IA disclosure_nomerit state_audit stock_purchase, cluster(ind_code_48 state_id) absorb(yr), if public_buyer==0
```

Proposed replacement:
```
	quietly eststo r5: reghdfe note_paid           		l_age Age_Ind EBTtoS l_revenue hi_IA disclosure_nomerit state_audit stock_purchase if public_buyer==0, cluster(ind_code_48 state_id) absorb(yr)
```

**Proposed edit:** `seller_financing_code.do:117–117`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab r1 r2 r3 r4 r5 using "[redacted-path-d9c9d59ff907]", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

Proposed replacement:
```
	esttab r1 r2 r3 r4 r5 using "Results/2B_Environment.tex", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

**Proposed edit:** `seller_financing_code.do:131–131`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab r1 r2 r3 r4 r5 r6 using "[redacted-path-8754421e7ae7]", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

Proposed replacement:
```
	esttab r1 r2 r3 r4 r5 r6 using "Results/4A_Earnout_Firm.tex", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

**Proposed edit:** `seller_financing_code.do:135–135`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r2: reghdfe Earnout  				l_age Age_Ind EBTtoS l_revenue disclosure_nomerit, cluster(state_id) absorb(ind_code_48 yr), if public_buyer==0
```

Proposed replacement:
```
	quietly eststo r2: reghdfe Earnout  				l_age Age_Ind EBTtoS l_revenue disclosure_nomerit if public_buyer==0, cluster(state_id) absorb(ind_code_48 yr)
```

**Proposed edit:** `seller_financing_code.do:136–136`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r3: reghdfe Earnout  				l_age Age_Ind EBTtoS l_revenue state_audit, cluster(state_id) absorb(ind_code_48 yr), if public_buyer==0
```

Proposed replacement:
```
	quietly eststo r3: reghdfe Earnout  				l_age Age_Ind EBTtoS l_revenue state_audit if public_buyer==0, cluster(state_id) absorb(ind_code_48 yr)
```

**Proposed edit:** `seller_financing_code.do:137–137`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r4: reghdfe Earnout           		l_age Age_Ind EBTtoS l_revenue stock_purchase, cluster(ind_code_48) absorb(ind_code_48 yr), if public_buyer==0	
```

Proposed replacement:
```
	quietly eststo r4: reghdfe Earnout           		l_age Age_Ind EBTtoS l_revenue stock_purchase if public_buyer==0	, cluster(ind_code_48) absorb(ind_code_48 yr)
```

**Proposed edit:** `seller_financing_code.do:138–138`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r5: reghdfe Earnout           		l_age Age_Ind EBTtoS l_revenue hi_IA disclosure_nomerit state_audit stock_purchase, cluster(ind_code_48 state_id) absorb(yr), if public_buyer==0
```

Proposed replacement:
```
	quietly eststo r5: reghdfe Earnout           		l_age Age_Ind EBTtoS l_revenue hi_IA disclosure_nomerit state_audit stock_purchase if public_buyer==0, cluster(ind_code_48 state_id) absorb(yr)
```

**Proposed edit:** `seller_financing_code.do:148–148`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab r1 r2 r3 r4 r5 using "[redacted-path-5ec825b81f57]", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

Proposed replacement:
```
	esttab r1 r2 r3 r4 r5 using "Results/4B_Earnout_Environment.tex", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

**Proposed edit:** `seller_financing_code.do:162–162`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab r1 r2 r3 r4 r5 r6 using "[redacted-path-af8e9bc230ae]", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

Proposed replacement:
```
	esttab r1 r2 r3 r4 r5 r6 using "Results/5_Price_Time.tex", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

**Proposed edit:** `seller_financing_code.do:178–178`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab r1 r2 r3 r4 r5 r6 using "[redacted-path-52895d115489]", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

Proposed replacement:
```
	esttab r1 r2 r3 r4 r5 r6 using "Results/3A_SFperc_Firm.tex", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

**Proposed edit:** `seller_financing_code.do:182–182`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r2: reghdfe seller_financing  				l_age Age_Ind EBTtoS l_revenue disclosure_nomerit, cluster(state_id) absorb(ind_code_48 yr), if public_buyer==0
```

Proposed replacement:
```
	quietly eststo r2: reghdfe seller_financing  				l_age Age_Ind EBTtoS l_revenue disclosure_nomerit if public_buyer==0, cluster(state_id) absorb(ind_code_48 yr)
```

**Proposed edit:** `seller_financing_code.do:183–183`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r3: reghdfe seller_financing  				l_age Age_Ind EBTtoS l_revenue state_audit, cluster(state_id) absorb(ind_code_48 yr), if public_buyer==0
```

Proposed replacement:
```
	quietly eststo r3: reghdfe seller_financing  				l_age Age_Ind EBTtoS l_revenue state_audit if public_buyer==0, cluster(state_id) absorb(ind_code_48 yr)
```

**Proposed edit:** `seller_financing_code.do:184–184`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r4: reghdfe seller_financing           		l_age Age_Ind EBTtoS l_revenue stock_purchase, cluster(ind_code_48) absorb(ind_code_48 yr), if public_buyer==0	
```

Proposed replacement:
```
	quietly eststo r4: reghdfe seller_financing           		l_age Age_Ind EBTtoS l_revenue stock_purchase if public_buyer==0	, cluster(ind_code_48) absorb(ind_code_48 yr)
```

**Proposed edit:** `seller_financing_code.do:185–185`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r5: reghdfe seller_financing           		l_age Age_Ind EBTtoS l_revenue hi_IA disclosure_nomerit state_audit stock_purchase, cluster(ind_code_48 state_id) absorb(yr), if public_buyer==0
```

Proposed replacement:
```
	quietly eststo r5: reghdfe seller_financing           		l_age Age_Ind EBTtoS l_revenue hi_IA disclosure_nomerit state_audit stock_purchase if public_buyer==0, cluster(ind_code_48 state_id) absorb(yr)
```

**Proposed edit:** `seller_financing_code.do:195–195`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab r1 r2 r3 r4 r5 using "[redacted-path-5b917e1c7b7c]", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace	
```

Proposed replacement:
```
	esttab r1 r2 r3 r4 r5 using "Results/3B_SFperc_Environment.tex", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace	
```

**Proposed edit:** `seller_financing_code.do:207–207`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab r1 r2 r3 r4 using "[redacted-path-df4daa7abe07]", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

Proposed replacement:
```
	esttab r1 r2 r3 r4 using "Results/7A_Moral_Hazard.tex", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

**Proposed edit:** `seller_financing_code.do:219–219`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab r1 r2 r3 r4 using "[redacted-path-d415d2b59e48]", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

Proposed replacement:
```
	esttab r1 r2 r3 r4 using "Results/6_Public_Buyers.tex", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

**Proposed edit:** `seller_financing_code.do:224–224`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	eststo r1: reghdfe note_paid  			l_age Age_Ind EBTtoS l_revenue state_audit, cluster(state_id M_ind) absorb(M_ind yr), if public_buyer==0
```

Proposed replacement:
```
	eststo r1: reghdfe note_paid  			l_age Age_Ind EBTtoS l_revenue state_audit if public_buyer==0, cluster(state_id M_ind) absorb(M_ind yr)
```

**Proposed edit:** `seller_financing_code.do:225–225`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	eststo r2: reghdfe seller_financing 	l_age Age_Ind EBTtoS l_revenue state_audit, cluster(state_id M_ind) absorb(M_ind yr), if public_buyer==0
```

Proposed replacement:
```
	eststo r2: reghdfe seller_financing 	l_age Age_Ind EBTtoS l_revenue state_audit if public_buyer==0, cluster(state_id M_ind) absorb(M_ind yr)
```

**Proposed edit:** `seller_financing_code.do:226–226`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	eststo r3: reghdfe Earnout 				l_age Age_Ind EBTtoS l_revenue state_audit, cluster(state_id M_ind) absorb(M_ind yr), if public_buyer==0
```

Proposed replacement:
```
	eststo r3: reghdfe Earnout 				l_age Age_Ind EBTtoS l_revenue state_audit if public_buyer==0, cluster(state_id M_ind) absorb(M_ind yr)
```

**Proposed edit:** `seller_financing_code.do:227–227`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	eststo r4: reghdfe note_paid  			l_age Age_Ind EBTtoS l_revenue state_audit, cluster(state_id M_ind) absorb(M_ind yr), if public_buyer==0 & noncompete==0
```

Proposed replacement:
```
	eststo r4: reghdfe note_paid  			l_age Age_Ind EBTtoS l_revenue state_audit if public_buyer==0 & noncompete==0, cluster(state_id M_ind) absorb(M_ind yr)
```

**Proposed edit:** `seller_financing_code.do:228–228`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	eststo r5: reghdfe seller_financing 	l_age Age_Ind EBTtoS l_revenue state_audit, cluster(state_id M_ind) absorb(M_ind yr), if public_buyer==0 & noncompete==0
```

Proposed replacement:
```
	eststo r5: reghdfe seller_financing 	l_age Age_Ind EBTtoS l_revenue state_audit if public_buyer==0 & noncompete==0, cluster(state_id M_ind) absorb(M_ind yr)
```

**Proposed edit:** `seller_financing_code.do:229–229`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	eststo r6: reghdfe Earnout 	l_age Age_Ind EBTtoS l_revenue state_audit, cluster(state_id M_ind) absorb(M_ind yr), if public_buyer==0 & noncompete==0
```

Proposed replacement:
```
	eststo r6: reghdfe Earnout 	l_age Age_Ind EBTtoS l_revenue state_audit if public_buyer==0 & noncompete==0, cluster(state_id M_ind) absorb(M_ind yr)
```

**Proposed edit:** `seller_financing_code.do:236–236`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab r1 r2 r3 r4 r5 r6 using "[redacted-path-51ac59420975]", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace	
```

Proposed replacement:
```
	esttab r1 r2 r3 r4 r5 r6 using "Results/App_3_Ind_audit.tex", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace	
```

**Proposed edit:** `seller_financing_code.do:252–252`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab r1 r2 r3 r4 r5 r6 using "[redacted-path-e8541d49c9a0]", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

Proposed replacement:
```
	esttab r1 r2 r3 r4 r5 r6 using "Results/App_2_1m+_Firm.tex", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

**Proposed edit:** `seller_financing_code.do:259–259`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r2: reghdfe note_paid  				l_age Age_Ind EBTtoS l_revenue disclosure_nomerit, cluster(state_id) absorb(ind_code_48 yr), if public_buyer==0
```

Proposed replacement:
```
	quietly eststo r2: reghdfe note_paid  				l_age Age_Ind EBTtoS l_revenue disclosure_nomerit if public_buyer==0, cluster(state_id) absorb(ind_code_48 yr)
```

**Proposed edit:** `seller_financing_code.do:260–260`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r3: reghdfe note_paid  				l_age Age_Ind EBTtoS l_revenue state_audit, cluster(state_id) absorb(ind_code_48 yr), if public_buyer==0
```

Proposed replacement:
```
	quietly eststo r3: reghdfe note_paid  				l_age Age_Ind EBTtoS l_revenue state_audit if public_buyer==0, cluster(state_id) absorb(ind_code_48 yr)
```

**Proposed edit:** `seller_financing_code.do:261–261`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r4: reghdfe note_paid           		l_age Age_Ind EBTtoS l_revenue stock_purchase, cluster(ind_code_48) absorb(ind_code_48 yr), if public_buyer==0	
```

Proposed replacement:
```
	quietly eststo r4: reghdfe note_paid           		l_age Age_Ind EBTtoS l_revenue stock_purchase if public_buyer==0	, cluster(ind_code_48) absorb(ind_code_48 yr)
```

**Proposed edit:** `seller_financing_code.do:262–262`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r5: reghdfe note_paid           		l_age Age_Ind EBTtoS l_revenue hi_IA disclosure_nomerit state_audit stock_purchase, cluster(ind_code_48 state_id) absorb(yr), if public_buyer==0
```

Proposed replacement:
```
	quietly eststo r5: reghdfe note_paid           		l_age Age_Ind EBTtoS l_revenue hi_IA disclosure_nomerit state_audit stock_purchase if public_buyer==0, cluster(ind_code_48 state_id) absorb(yr)
```

**Proposed edit:** `seller_financing_code.do:272–272`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab r1 r2 r3 r4 r5 using "[redacted-path-f20851c6cfbe]", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace	
```

Proposed replacement:
```
	esttab r1 r2 r3 r4 r5 using "Results/App_2_1m+_Environment.tex", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace	
```

**Proposed edit:** `seller_financing_code.do:285–285`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab r1 r2 r3 r4 using "[redacted-path-e4874fef183a]", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

Proposed replacement:
```
	esttab r1 r2 r3 r4 using "Results/App_1_Const_Rest.tex", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

**Proposed edit:** `seller_financing_code.do:299–299`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab r1 r2 r3 r4 r5 r6 using "[redacted-path-91868d2fb99f]", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

Proposed replacement:
```
	esttab r1 r2 r3 r4 r5 r6 using "Results/App_4A_MH_Firm.tex", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

**Proposed edit:** `seller_financing_code.do:303–303`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r2: reghdfe note_paid  				noncompete_garmaise nc_g_int noncompete employ_agree l_age Age_Ind EBTtoS l_revenue disclosure_nomerit, cluster(state_id) absorb(ind_code_48 yr), if public_buyer==0
```

Proposed replacement:
```
	quietly eststo r2: reghdfe note_paid  				noncompete_garmaise nc_g_int noncompete employ_agree l_age Age_Ind EBTtoS l_revenue disclosure_nomerit if public_buyer==0, cluster(state_id) absorb(ind_code_48 yr)
```

**Proposed edit:** `seller_financing_code.do:304–304`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r3: reghdfe note_paid  				noncompete_garmaise nc_g_int noncompete employ_agree l_age Age_Ind EBTtoS l_revenue state_audit, cluster(state_id) absorb(ind_code_48 yr), if public_buyer==0
```

Proposed replacement:
```
	quietly eststo r3: reghdfe note_paid  				noncompete_garmaise nc_g_int noncompete employ_agree l_age Age_Ind EBTtoS l_revenue state_audit if public_buyer==0, cluster(state_id) absorb(ind_code_48 yr)
```

**Proposed edit:** `seller_financing_code.do:305–305`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r4: reghdfe note_paid           		noncompete_garmaise nc_g_int noncompete employ_agree l_age Age_Ind EBTtoS l_revenue stock_purchase, cluster(ind_code_48) absorb(ind_code_48 yr), if public_buyer==0	
```

Proposed replacement:
```
	quietly eststo r4: reghdfe note_paid           		noncompete_garmaise nc_g_int noncompete employ_agree l_age Age_Ind EBTtoS l_revenue stock_purchase if public_buyer==0	, cluster(ind_code_48) absorb(ind_code_48 yr)
```

**Proposed edit:** `seller_financing_code.do:306–306`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r5: reghdfe note_paid           		noncompete_garmaise nc_g_int noncompete employ_agree l_age Age_Ind EBTtoS l_revenue hi_IA disclosure_nomerit state_audit stock_purchase, cluster(ind_code_48 state_id) absorb(yr), if public_buyer==0
```

Proposed replacement:
```
	quietly eststo r5: reghdfe note_paid           		noncompete_garmaise nc_g_int noncompete employ_agree l_age Age_Ind EBTtoS l_revenue hi_IA disclosure_nomerit state_audit stock_purchase if public_buyer==0, cluster(ind_code_48 state_id) absorb(yr)
```

**Proposed edit:** `seller_financing_code.do:316–316`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab r1 r2 r3 r4 r5 using "[redacted-path-c1e360592321]", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

Proposed replacement:
```
	esttab r1 r2 r3 r4 r5 using "Results/App_4B_MH_Environment.tex", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

**Proposed edit:** `seller_financing_code.do:333–333`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab r1 r2 r3 r4 r5 r6 using "[redacted-path-29ba173ad227]", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

Proposed replacement:
```
	esttab r1 r2 r3 r4 r5 r6 using "Results/App_4C_MH_Firm.tex", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

**Proposed edit:** `seller_financing_code.do:340–340`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r2: reghdfe note_paid  				l_age Age_Ind EBTtoS l_revenue disclosure_nomerit, cluster(state_id) absorb(ind_code_48 yr), if public_buyer==0
```

Proposed replacement:
```
	quietly eststo r2: reghdfe note_paid  				l_age Age_Ind EBTtoS l_revenue disclosure_nomerit if public_buyer==0, cluster(state_id) absorb(ind_code_48 yr)
```

**Proposed edit:** `seller_financing_code.do:341–341`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r3: reghdfe note_paid  				l_age Age_Ind EBTtoS l_revenue state_audit, cluster(state_id) absorb(ind_code_48 yr), if public_buyer==0
```

Proposed replacement:
```
	quietly eststo r3: reghdfe note_paid  				l_age Age_Ind EBTtoS l_revenue state_audit if public_buyer==0, cluster(state_id) absorb(ind_code_48 yr)
```

**Proposed edit:** `seller_financing_code.do:342–342`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r4: reghdfe note_paid           		l_age Age_Ind EBTtoS l_revenue stock_purchase, cluster(ind_code_48) absorb(ind_code_48 yr), if public_buyer==0	
```

Proposed replacement:
```
	quietly eststo r4: reghdfe note_paid           		l_age Age_Ind EBTtoS l_revenue stock_purchase if public_buyer==0	, cluster(ind_code_48) absorb(ind_code_48 yr)
```

**Proposed edit:** `seller_financing_code.do:343–343`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Move the original reghdfe sample qualifier before the options comma while preserving the exact model and options.

Current text:
```
	quietly eststo r5: reghdfe note_paid           		l_age Age_Ind EBTtoS l_revenue hi_IA disclosure_nomerit state_audit stock_purchase, cluster(ind_code_48 state_id) absorb(yr), if public_buyer==0
```

Proposed replacement:
```
	quietly eststo r5: reghdfe note_paid           		l_age Age_Ind EBTtoS l_revenue hi_IA disclosure_nomerit state_audit stock_purchase if public_buyer==0, cluster(ind_code_48 state_id) absorb(yr)
```

**Proposed edit:** `seller_financing_code.do:353–353`
Source SHA-256: `2db3cbea9bb3f075f7cd350842ae5782f371f89770cdf6cd22ccb71501acf428`

Keep the original result filename under a relative Results directory rooted at the host wrapper working directory.

Current text:
```
	esttab r1 r2 r3 r4 r5 using "[redacted-path-4155c1e468af]", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

Proposed replacement:
```
	esttab r1 r2 r3 r4 r5 using "Results/App_4D_MH_Environment.tex", ar2 compress label scalars(Sample Industry_FE Year_FE  Cluster) cells(b(star fmt(%12.3f)) t(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps tex replace
```

Preparation / proposed procedure:

1. Configure the host Stata batch wrapper to start in a relative project root containing Data/ and Results/. The proposed line 2 keeps Stata in that root; line 3 reads Data/Transactions_Data_2015.dta; every one of the 32 result paths is moved under Results/ with its original filename. Preserve the distinct Data and Results directories.
2. Apply the line-level edits in the proposal to a working copy only. They move the two graph-wide yr qualifiers before the graph-options comma, four summarize and two regress filters before option commas, thirty reghdfe filters before option commas, and ten esttab using filenames before option commas.
3. Keep the existing chart filters yr>1994 & yr<2016, every public-buyer/non-compete sample condition, every table/model specification, and every original output filename unchanged. The proposal does not modify the author package.

Validation to perform later:

- Before a separately authorized run, confirm the relative root, Data/ input visibility and writable Results/ directory through the host Stata batch wrapper.
- After the required data is available and execution is separately authorized, run the complete do-file in the working copy and check all listed figures/tables/appendix outputs; execution has not been verified in this assessment.


## Remaining issues and prerequisites

- I-DATA-ABSENT [unresolved; full_pipeline]: Transactions_Data_2015.dta is required by the only data read but is not among the datasheet and do-file inventoried in this package. This is a missing package input; current access to the authors’ prepared file is unverified, not a confirmed access barrier.
- I-DATA-CONTRACT [unresolved; full_pipeline]: The datasheet says Stata data manipulation/construction occurred, but the supplied program starts by loading Transactions_Data_2015.dta and contains only figures, statistics, regressions and exports. The full field/type contract, row unit/key, transaction population/history and producer mapping for the required analysis variables are not documented.
- I-PATHS [preparation; full_pipeline]: The program hardcodes a Windows G: data directory and 32 Windows G: Results output filenames. A host Stata batch run needs one coherent relative execution root with Data/ and writable Results/ paths.
- I-SYNTAX [preparation; full_pipeline]: The supplied do-file places graph-wide yr filters after the graph options comma; places if qualifiers after option commas in four summarize, two reg and thirty reghdfe calls; and places using filenames after option commas in ten esttab calls. Primary command documentation supports precise moves that preserve the existing filters, model specifications, options and output filenames.
- R-DATA-001 [undetermined]: The sole data input named by the supplied program: author-prepared Transactions_Data_2015.dta. The downstream code expects the listed transaction, firm, buyer, industry/state, regulatory, financing and annual-figure variables already present; it does not construct them. Its row grain, unique-key rules, full period/population and upstream variable definitions are not supplied.

## Review notes

- The frozen output header and DOI are copied literally. The complete datasheet heading adds “Acquisitions” to the paper title; because this release supplies the datasheet and do-file only, that source-document difference is noted without silently changing frozen identity metadata.
- The full supplied workflow is one 377-line Stata do-file. It reads one unprovided prepared table and then runs its figures, Table 1A-C, Tables 2A-7 and Appendices B1-B4D. No separate data-construction program or analysis-only prepared-data branch is supplied, so no analysis_only scope is justified.
- The datasheet names BVR as the historical proprietary primary data source and reports old purchase/publication/commercial-use terms. Those statements do not establish present user denial or identify the BVR product/export. No purchase, contact, form submission or eligibility investigation occurred.
- Historical Minnis state-audit, Francis/Gunn complexity, Moller filing and Garmaise enforcement origins are not direct reads in the supplied program. Keep them conditional to the missing prepared-table reconstruction only if its actual producer requires them; they are not additional AND requirements while a compatible prepared file can supply the consumed fields.
- A one-row local read confirms SDC.WRDS_MA_DETAILS is readable and exposes 146 distinct SDC fields including MASTER_DEAL_NO, DATEANN, names, status, consideration and value fields. It does not provide the do-file’s prepared variable contract or a mapping to BVR TransactionID; this is a discovery candidate, not an equivalent route. The catalog count is PROC CONTENTS metadata, not a one-row sample count; no full-data coverage was tested.
- The named prepared-table contract retains the actual code-consumed variables, exact case and the known 1995-2015 figure filter. Overall regression/table history, row key/grain, population and upstream constructions remain unspecified. BuyerCIK is unused and TransactionID is vendor-only; no external CIK or generic transaction join was assumed.
- The Stata qualifier and esttab using-position corrections and the coherent relative paths are proposals only. No author program, regression, estimator, or study dataset was executed; execution_verified remains false.
