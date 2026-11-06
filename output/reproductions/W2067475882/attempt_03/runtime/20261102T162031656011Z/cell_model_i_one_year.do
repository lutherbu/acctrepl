version 18
set more off

global y "dy"
global x "dx"
global asym "interaction"

use "data/reg.dta", clear

est clear
regress $y $x $asym if trimflag == 1
est store m1

esttab m1 using "tables/table2_model_i_one_year.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label title("Model (I), one-year pooled OLS") addnotes("Best-effort conventional OLS standard errors; Table 2 does not identify its covariance procedure.")
esttab m1 using "tables/table2_model_i_one_year.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label title("Model (I), one-year pooled OLS") addnotes("Best-effort conventional OLS standard errors; Table 2 does not identify its covariance procedure.")
esttab m1 using "tables/table2_model_i_one_year.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label title("Model (I), one-year pooled OLS") addnotes("Best-effort conventional OLS standard errors; Table 2 does not identify its covariance procedure.")
esttab m1 using "tables/table2_model_i_one_year.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label title("Model (I), one-year pooled OLS") addnotes("Best-effort conventional OLS standard errors; Table 2 does not identify its covariance procedure.")
est clear
exit, clear
