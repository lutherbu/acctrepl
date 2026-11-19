version 18
set more off

global y "earnings_next"
global x_a "cfo_t opacc_t earn_low_op earn_low_op_si"
use "data/accrual_persistence_main/reg.dta", clear
keep if table2_sample==1

label var earnings_next "Earnings t+1"
label var cfo_t "Cash flows from operations"
label var opacc_t "Operating accruals"
label var earn_low_op "Earnings x Low OPACC"
label var earn_low_op_si "Earnings x Low OPACC x SI"

est clear
regress $y $x_a
est store panel_a
esttab panel_a using "tables/table2_panel_a.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab panel_a using "tables/table2_panel_a.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab panel_a using "tables/table2_panel_a.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab panel_a using "tables/table2_panel_a.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
est clear
exit, clear
