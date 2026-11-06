version 18
set more off

global y "eps_price"
global x "dum ret dum_return"

use "reg.dta", clear
est clear
regress $y $x
est store m1

esttab m1 using "tables/annual_pooled_eq1.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab m1 using "tables/annual_pooled_eq1.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab m1 using "tables/annual_pooled_eq1.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab m1 using "tables/annual_pooled_eq1.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
est clear
exit, clear
