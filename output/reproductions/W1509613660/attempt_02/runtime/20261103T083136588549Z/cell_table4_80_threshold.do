version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
global y "ret"
global x "fr_sup fr_norm fr_inf"
use "data/revisions/reg.dta", clear
isid event_id
assert !missing($y, fr_sup, fr_norm, fr_inf)
est clear
regress $y $x
est store table4_80
test fr_sup = fr_norm
test fr_sup = fr_inf
test fr_norm = fr_inf
esttab table4_80 using "tables/table4_80_threshold.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab table4_80 using "tables/table4_80_threshold.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab table4_80 using "tables/table4_80_threshold.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab table4_80 using "tables/table4_80_threshold.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
est clear
exit, clear
