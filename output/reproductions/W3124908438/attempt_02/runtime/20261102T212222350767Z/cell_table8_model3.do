version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
use "data/reg.dta", clear
egen long firmid = group(gvkey)
xtset firmid fyear
est clear
xtfmb anrev sur dpm dato drnoa, lag(1)
est store m1
esttab m1 using "tables/table8_model3.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 replace label
esttab m1 using "tables/table8_model3.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 replace label
esttab m1 using "tables/table8_model3.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 replace label
esttab m1 using "tables/table8_model3.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 replace label
est clear
exit, clear
