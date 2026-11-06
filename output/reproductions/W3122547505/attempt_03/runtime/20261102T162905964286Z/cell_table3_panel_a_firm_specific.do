version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"

use "data/reg.dta", clear
est clear

* Check the realized endpoints and the stricter interpretation that lead/lag
* data must also lie inside the paper's stated 1987-1999 outcome window.
count if fyear == 1987
display "Baseline eligible 1987 outcome rows = " r(N)
count if fyear == 1999
display "Baseline eligible 1999 outcome rows = " r(N)
preserve
keep if fyear <= 1998
bysort gvkey: egen strict_n = count(fyear)
bysort gvkey: keep if _n == 1
count if strict_n >= 8
quietly summarize strict_n if strict_n >= 8
display "Strict-window firm-years = " %9.0f r(sum) "; firms = " %9.0f r(N)
restore

* Estimate one OLS regression per firm and retain package-generated fit statistics.
asreg d_wc_scaled cfo_lag cfo_cur cfo_lead, by(gvkey) minimum(8)
keep if !missing(_b_cons, _b_cfo_lag, _b_cfo_cur, _b_cfo_lead, _adjR2)
bysort gvkey: keep if _n == 1

label variable _b_cons "Intercept"
label variable _b_cfo_lag "CFO(t-1)"
label variable _b_cfo_cur "CFO(t)"
label variable _b_cfo_lead "CFO(t+1)"
label variable _adjR2 "Adjusted R-squared"

* Built-in mean uses one estimate per firm; t statistics remain in the ordinary log, while the export uses template p-values.
mean _b_cons _b_cfo_lag _b_cfo_cur _b_cfo_lead
est store firmmeans
esttab firmmeans using "tables/table3_panel_a_crossfirm_means.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) replace label noobs
esttab firmmeans using "tables/table3_panel_a_crossfirm_means.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) replace label noobs
esttab firmmeans using "tables/table3_panel_a_crossfirm_means.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) replace label noobs
esttab firmmeans using "tables/table3_panel_a_crossfirm_means.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) replace label noobs

* The source reports t-statistics; retain native one-sample t-tests in the log.
ttest _b_cons == 0
ttest _b_cfo_lag == 0
ttest _b_cfo_cur == 0
ttest _b_cfo_lead == 0
est clear

* Companion table reports the full coefficient and adjusted-R-squared distributions.
estpost tabstat _b_cons _b_cfo_lag _b_cfo_cur _b_cfo_lead _adjR2, statistics(N mean sd p25 p50 p75) columns(statistics)
esttab using "tables/table3_panel_a_distribution.md", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") replace label noobs
esttab using "tables/table3_panel_a_distribution.rtf", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") replace label noobs
esttab using "tables/table3_panel_a_distribution.csv", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") replace label noobs
esttab using "tables/table3_panel_a_distribution.tex", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3))") replace label noobs
est clear
exit, clear
