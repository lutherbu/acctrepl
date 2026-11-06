version 18
set more off

global y "drnoa_f1"
global x "rnoa_t dnoa_t wdelta_ato wdelta_pm int_raw"

use "data/main/reg.dta", clear

est clear
count
tabulate t_year
summarize drnoa_f1 rnoa_t dnoa_t wdelta_ato wdelta_pm int_raw
reg $y $x
estimates store model3

esttab model3 using "tables/table2_model3.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab model3 using "tables/table2_model3.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab model3 using "tables/table2_model3.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab model3 using "tables/table2_model3.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
est clear
exit, clear
