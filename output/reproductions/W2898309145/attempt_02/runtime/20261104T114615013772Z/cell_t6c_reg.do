version 18
set more off
global y "dmva1"
global x "time"
global firm "gvkey_id"
global yr "year"
use "data/main/reg.dta", clear
est clear
ivreg2 $y $x, cluster($firm $yr) small
est store m1
esttab m1 using "tables/table6c_all.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab m1 using "tables/table6c_all.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab m1 using "tables/table6c_all.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab m1 using "tables/table6c_all.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
est clear
exit, clear
