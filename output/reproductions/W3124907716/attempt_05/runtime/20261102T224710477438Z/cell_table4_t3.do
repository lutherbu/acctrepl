version 18
set more off
use "data/table4_t3/reg.dta", clear
est clear
label variable em "EM3"
label variable dte "DTE"
label variable abaccfl "abaccfl"
label variable dcfo "dcfo"
probit em dte abaccfl dcfo i.sic2
est store m1
esttab m1 using "tables/table4_t3.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars(r2_p ll) keep(_cons dte abaccfl dcfo) replace label
esttab m1 using "tables/table4_t3.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars(r2_p ll) keep(_cons dte abaccfl dcfo) replace label
esttab m1 using "tables/table4_t3.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars(r2_p ll) keep(_cons dte abaccfl dcfo) replace label
esttab m1 using "tables/table4_t3.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars(r2_p ll) keep(_cons dte abaccfl dcfo) replace label
est clear
exit, clear
