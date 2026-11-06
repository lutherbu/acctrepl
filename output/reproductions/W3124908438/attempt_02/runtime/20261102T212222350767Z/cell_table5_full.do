version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
use "data/reg.dta", clear
egen long firmid = group(gvkey)
xtset firmid fyear
est clear
xtfmb rt earn dearn rnoa drnoa pm ato dpm dato rnoap1 pmp1 atop1, lag(1)
est store m1
esttab m1 using "tables/table5_full_future_components.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 replace label
esttab m1 using "tables/table5_full_future_components.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 replace label
esttab m1 using "tables/table5_full_future_components.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 replace label
esttab m1 using "tables/table5_full_future_components.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 replace label
est clear
exit, clear
