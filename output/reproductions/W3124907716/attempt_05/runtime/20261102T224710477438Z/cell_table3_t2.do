version 18
set more off
use "data/table23_t2/reg.dta", clear
est clear
label variable em "EM2"
label variable dte "DTE"
label variable abaccmj "abaccmj"
label variable cfo "cfo"
probit em dte abaccmj cfo i.sic2
est store m1
esttab m1 using "tables/table3_t2.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars(r2_p ll) keep(_cons dte abaccmj cfo) replace label
esttab m1 using "tables/table3_t2.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars(r2_p ll) keep(_cons dte abaccmj cfo) replace label
esttab m1 using "tables/table3_t2.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars(r2_p ll) keep(_cons dte abaccmj cfo) replace label
esttab m1 using "tables/table3_t2.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars(r2_p ll) keep(_cons dte abaccmj cfo) replace label
est clear
exit, clear
