version 18
set more off

use "data/reg.dta", clear
est clear
encode gvkey, gen(firm_id)

reghdfe drnoa_w rnoa_w drnoa_t_w grnoa_w dato_w dpm_w ib3.age_stage if eligible_age==1, vce(cluster firm_id fyear)
est store model

display "AGE total stage effects (intercept plus contrast; controls at zero)"
lincom _b[_cons]
lincom _b[_cons] + _b[1.age_stage]
lincom _b[_cons] + _b[2.age_stage]
lincom _b[_cons] + _b[4.age_stage]
lincom _b[_cons] + _b[5.age_stage]

esttab model using "tables/table5_model1_age_quintiles.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(3.age_stage) coeflabels(_cons "Middle-age reference (controls = 0)" 1.age_stage "Introduction (young)" 2.age_stage "Growth (mid-young)" 4.age_stage "Shake-Out (mid-old)" 5.age_stage "Decline (old)") addnotes("Rows align age quintiles to the five cash-flow labels in Table 5 footnote 18. Stage values are contrasts with the middle-age quintile; lincom total effects are in the log." "OLS; two-way firm and fiscal-year clustered standard errors; two-sided tests.")
esttab model using "tables/table5_model1_age_quintiles.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(3.age_stage) coeflabels(_cons "Middle-age reference (controls = 0)" 1.age_stage "Introduction (young)" 2.age_stage "Growth (mid-young)" 4.age_stage "Shake-Out (mid-old)" 5.age_stage "Decline (old)") addnotes("Rows align age quintiles to the five cash-flow labels in Table 5 footnote 18. Stage values are contrasts with the middle-age quintile; lincom total effects are in the log." "OLS; two-way firm and fiscal-year clustered standard errors; two-sided tests.")
esttab model using "tables/table5_model1_age_quintiles.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(3.age_stage) coeflabels(_cons "Middle-age reference (controls = 0)" 1.age_stage "Introduction (young)" 2.age_stage "Growth (mid-young)" 4.age_stage "Shake-Out (mid-old)" 5.age_stage "Decline (old)") addnotes("Rows align age quintiles to the five cash-flow labels in Table 5 footnote 18. Stage values are contrasts with the middle-age quintile; lincom total effects are in the log." "OLS; two-way firm and fiscal-year clustered standard errors; two-sided tests.")
esttab model using "tables/table5_model1_age_quintiles.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(3.age_stage) coeflabels(_cons "Middle-age reference (controls = 0)" 1.age_stage "Introduction (young)" 2.age_stage "Growth (mid-young)" 4.age_stage "Shake-Out (mid-old)" 5.age_stage "Decline (old)") addnotes("Rows align age quintiles to the five cash-flow labels in Table 5 footnote 18. Stage values are contrasts with the middle-age quintile; lincom total effects are in the log." "OLS; two-way firm and fiscal-year clustered standard errors; two-sided tests.")
est clear
exit, clear
