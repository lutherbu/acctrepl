version 18
set more off
use "data/reg.dta", clear

est clear
label variable time "Time"
label variable sca "SCA"
label variable sox "SOX"
label variable abs_da "ABS DA"
label variable positive_da "Positive DA"
label variable negative_da "Negative DA"
label variable r_prod "R PROD"
label variable r_cfo "R CFO"
label variable r_disx "R DISX"
label variable rm_proxy "RM PROXY"

regress abs_da time sca sox
est store m1
regress positive_da time sca sox
est store m2
regress negative_da time sca sox
est store m3
regress r_prod time sca sox
est store m4
regress r_cfo time sca sox
est store m5
regress r_disx time sca sox
est store m6
regress rm_proxy time sca sox
est store m7

esttab m1 m2 m3 m4 m5 m6 m7 using "tables/table2_panel_a.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a, fmt(%9.0f %9.3f %9.3f) labels("Observations" "R-squared" "Adjusted R-squared")) replace label mtitle("ABS DA" "Positive DA" "Negative DA" "R PROD" "R CFO" "R DISX" "RM PROXY")
esttab m1 m2 m3 m4 m5 m6 m7 using "tables/table2_panel_a.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a, fmt(%9.0f %9.3f %9.3f) labels("Observations" "R-squared" "Adjusted R-squared")) replace label mtitle("ABS DA" "Positive DA" "Negative DA" "R PROD" "R CFO" "R DISX" "RM PROXY")
esttab m1 m2 m3 m4 m5 m6 m7 using "tables/table2_panel_a.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a, fmt(%9.0f %9.3f %9.3f) labels("Observations" "R-squared" "Adjusted R-squared")) replace label mtitle("ABS DA" "Positive DA" "Negative DA" "R PROD" "R CFO" "R DISX" "RM PROXY")
esttab m1 m2 m3 m4 m5 m6 m7 using "tables/table2_panel_a.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a, fmt(%9.0f %9.3f %9.3f) labels("Observations" "R-squared" "Adjusted R-squared")) replace label mtitle("ABS DA" "Positive DA" "Negative DA" "R PROD" "R CFO" "R DISX" "RM PROXY")
est clear
exit, clear
