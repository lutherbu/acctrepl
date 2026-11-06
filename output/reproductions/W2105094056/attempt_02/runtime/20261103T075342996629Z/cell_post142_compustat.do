version 18
set more off
use "data/goodwill_panel_19290/reg.dta", clear
egen long firmid = group(gvkey)
label variable imppi "IMPI(t-1)"
label variable btmg1 "BTMG1(t-1)"
label variable comp_impdum "Compustat impairment indicator"
est clear
clogit comp_impdum imppi btmg1 if inrange(fyear,2004,2011), group(firmid) vce(cluster firmid)
est store model1
gen byte fit_sample = e(sample)

esttab model1 using "tables/table3a_post_compustat.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars("r2_p Pseudo R-squared") replace label
esttab model1 using "tables/table3a_post_compustat.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars("r2_p Pseudo R-squared") replace label
esttab model1 using "tables/table3a_post_compustat.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars("r2_p Pseudo R-squared") replace label
esttab model1 using "tables/table3a_post_compustat.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars("r2_p Pseudo R-squared") replace label

preserve
keep if fit_sample
estpost tabstat comp_impdum imppi btmg1, stat(N mean sd p25 p50 p75) c(s)
esttab using "tables/descriptives_post_compustat.md", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/descriptives_post_compustat.rtf", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/descriptives_post_compustat.csv", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/descriptives_post_compustat.tex", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
restore
est clear
exit, clear
