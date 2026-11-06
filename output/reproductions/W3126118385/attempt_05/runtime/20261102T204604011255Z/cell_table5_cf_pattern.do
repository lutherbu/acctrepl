version 18
set more off

use "data/reg.dta", clear
est clear
encode gvkey, gen(firm_id)

reghdfe drnoa_w rnoa_w drnoa_t_w grnoa_w dato_w dpm_w ib3.cf_stage if eligible_cf==1, vce(cluster firm_id fyear)
est store model

display "CF total stage effects (intercept plus contrast; controls at zero)"
lincom _b[_cons]
lincom _b[_cons] + _b[1.cf_stage]
lincom _b[_cons] + _b[2.cf_stage]
lincom _b[_cons] + _b[4.cf_stage]
lincom _b[_cons] + _b[5.cf_stage]

esttab model using "tables/table5_model1_cf_pattern.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(3.cf_stage) coeflabels(_cons "Mature reference (controls = 0)" 1.cf_stage "Introduction" 2.cf_stage "Growth" 4.cf_stage "Shake-Out" 5.cf_stage "Decline") addnotes("Stage rows are contrasts with mature firms; lincom total stage effects are in the Stata log." "OLS; two-way firm and fiscal-year clustered standard errors; two-sided tests.")
esttab model using "tables/table5_model1_cf_pattern.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(3.cf_stage) coeflabels(_cons "Mature reference (controls = 0)" 1.cf_stage "Introduction" 2.cf_stage "Growth" 4.cf_stage "Shake-Out" 5.cf_stage "Decline") addnotes("Stage rows are contrasts with mature firms; lincom total stage effects are in the Stata log." "OLS; two-way firm and fiscal-year clustered standard errors; two-sided tests.")
esttab model using "tables/table5_model1_cf_pattern.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(3.cf_stage) coeflabels(_cons "Mature reference (controls = 0)" 1.cf_stage "Introduction" 2.cf_stage "Growth" 4.cf_stage "Shake-Out" 5.cf_stage "Decline") addnotes("Stage rows are contrasts with mature firms; lincom total stage effects are in the Stata log." "OLS; two-way firm and fiscal-year clustered standard errors; two-sided tests.")
esttab model using "tables/table5_model1_cf_pattern.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(3.cf_stage) coeflabels(_cons "Mature reference (controls = 0)" 1.cf_stage "Introduction" 2.cf_stage "Growth" 4.cf_stage "Shake-Out" 5.cf_stage "Decline") addnotes("Stage rows are contrasts with mature firms; lincom total stage effects are in the Stata log." "OLS; two-way firm and fiscal-year clustered standard errors; two-sided tests.")
est clear
exit, clear
