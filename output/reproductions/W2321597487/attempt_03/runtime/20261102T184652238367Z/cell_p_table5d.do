version 18
set more off
use "data/reg.dta", clear
est clear
regress acc cf delta_cf abnret dcf dcf_cf ddelta_cf ddelta_cf_x_delta_cf dind dind_indadj_cf dabnret dabnret_abnret if sample_t5d_cf==1
local __r2=100*e(r2)
local __ar2=100*e(r2_a)
estadd scalar r2=`__r2', replace
estadd scalar r2_a=`__ar2', replace
est store p_cf
regress acc cf cf_lag cf_lead abnret dcf dcf_cf ddelta_cf ddelta_cf_x_delta_cf dind dind_indadj_cf dabnret dabnret_abnret if sample_t5d_dd==1
local __r2=100*e(r2)
local __ar2=100*e(r2_a)
estadd scalar r2=`__r2', replace
estadd scalar r2_a=`__ar2', replace
est store p_dd
regress acc drev gppe delta_cf indadj_cf abnret dcf dcf_cf ddelta_cf ddelta_cf_x_delta_cf dind dind_indadj_cf dabnret dabnret_abnret if sample_t5d_jones==1
local __r2=100*e(r2)
local __ar2=100*e(r2_a)
estadd scalar r2=`__r2', replace
estadd scalar r2_a=`__ar2', replace
est store p_jones
esttab p_cf p_dd p_jones using "tables/table5_panelD_pooled.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 addnotes("R-squared and adjusted R-squared are percent.") replace label
esttab p_cf p_dd p_jones using "tables/table5_panelD_pooled.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 addnotes("R-squared and adjusted R-squared are percent.") replace label
esttab p_cf p_dd p_jones using "tables/table5_panelD_pooled.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 addnotes("R-squared and adjusted R-squared are percent.") replace label
esttab p_cf p_dd p_jones using "tables/table5_panelD_pooled.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 addnotes("R-squared and adjusted R-squared are percent.") replace label
est clear
exit, clear
