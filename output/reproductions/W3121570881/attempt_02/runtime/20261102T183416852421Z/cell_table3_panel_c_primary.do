version 18
set more off
use "data/primary_ferc/reg.dta", clear
est clear
label variable rt "R_t"
label variable xm1 "X_t-1"
label variable xt "X_t"
label variable xt3 "X_t3"
label variable rt3 "R_t3"
label variable is "IS_t"
reg rt xm1 xt xt3 rt3 is isxm1 isxt isxt3 isrt3
est store primary
esttab primary using "tables/table3_panel_c_primary.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab primary using "tables/table3_panel_c_primary.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab primary using "tables/table3_panel_c_primary.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab primary using "tables/table3_panel_c_primary.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
est clear
exit, clear
