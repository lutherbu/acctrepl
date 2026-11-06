version 18
set more off
use "data/main/reg.dta", clear

label variable cf_lead "CF(t+1)"
label variable cf0 "CF(t)"
label variable d_ar "Delta AR(t)"
label variable d_inv "Delta INV(t)"
label variable d_ap "Delta AP(t)"
label variable depr "DEPR(t)"
label variable amort "AMORT(t)"
label variable other "OTHER(t)"

est clear
regress cf_lead cf0 d_ar d_inv d_ap depr amort other
est store components

esttab components using "tables/table3_cf_components.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab components using "tables/table3_cf_components.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab components using "tables/table3_cf_components.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab components using "tables/table3_cf_components.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
est clear
exit, clear
