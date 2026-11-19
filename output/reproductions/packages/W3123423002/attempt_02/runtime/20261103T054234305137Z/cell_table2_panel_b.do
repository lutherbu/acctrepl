version 18
set more off

global y "earnings_next"
global x_b "fcf_t tacc_t earn_low_tacc earn_low_tacc_si"
use "data/accrual_persistence_main/reg.dta", clear
keep if table2_sample==1

label var earnings_next "Earnings t+1"
label var fcf_t "Free cash flow"
label var tacc_t "Total accruals"
label var earn_low_tacc "Earnings x Low TACC"
label var earn_low_tacc_si "Earnings x Low TACC x SI"

est clear
regress $y $x_b
est store panel_b
esttab panel_b using "tables/table2_panel_b.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab panel_b using "tables/table2_panel_b.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab panel_b using "tables/table2_panel_b.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab panel_b using "tables/table2_panel_b.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
est clear
exit, clear
