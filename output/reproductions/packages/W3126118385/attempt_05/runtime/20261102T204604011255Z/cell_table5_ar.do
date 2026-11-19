version 18
set more off

use "data/reg.dta", clear
est clear
encode gvkey, gen(firm_id)

reghdfe drnoa_w rnoa_w drnoa_t_w grnoa_w dato_w dpm_w ib3.ar_stage if eligible_ar==1, vce(cluster firm_id fyear)
est store model

display "AR total stage effects (intercept plus contrast; controls at zero)"
lincom _b[_cons]
lincom _b[_cons] + _b[1.ar_stage]
lincom _b[_cons] + _b[2.ar_stage]
lincom _b[_cons] + _b[4.ar_stage]
lincom _b[_cons] + _b[5.ar_stage]

esttab model using "tables/table5_model1_ar.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(3.ar_stage) coeflabels(_cons "Mature reference (controls = 0)" 1.ar_stage "Introduction (A&R Growth)" 2.ar_stage "Growth (A&R Growth/Mature)" 4.ar_stage "Shake-Out (A&R Mature/Stagnant)" 5.ar_stage "Decline (A&R Stagnant)") addnotes("Rows align the A&R portfolios to the five cash-flow labels in Table 5 footnote 18. Stage values are contrasts with mature firms; lincom total effects are in the log." "OLS; two-way firm and fiscal-year clustered standard errors; two-sided tests.")
esttab model using "tables/table5_model1_ar.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(3.ar_stage) coeflabels(_cons "Mature reference (controls = 0)" 1.ar_stage "Introduction (A&R Growth)" 2.ar_stage "Growth (A&R Growth/Mature)" 4.ar_stage "Shake-Out (A&R Mature/Stagnant)" 5.ar_stage "Decline (A&R Stagnant)") addnotes("Rows align the A&R portfolios to the five cash-flow labels in Table 5 footnote 18. Stage values are contrasts with mature firms; lincom total effects are in the log." "OLS; two-way firm and fiscal-year clustered standard errors; two-sided tests.")
esttab model using "tables/table5_model1_ar.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(3.ar_stage) coeflabels(_cons "Mature reference (controls = 0)" 1.ar_stage "Introduction (A&R Growth)" 2.ar_stage "Growth (A&R Growth/Mature)" 4.ar_stage "Shake-Out (A&R Mature/Stagnant)" 5.ar_stage "Decline (A&R Stagnant)") addnotes("Rows align the A&R portfolios to the five cash-flow labels in Table 5 footnote 18. Stage values are contrasts with mature firms; lincom total effects are in the log." "OLS; two-way firm and fiscal-year clustered standard errors; two-sided tests.")
esttab model using "tables/table5_model1_ar.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(3.ar_stage) coeflabels(_cons "Mature reference (controls = 0)" 1.ar_stage "Introduction (A&R Growth)" 2.ar_stage "Growth (A&R Growth/Mature)" 4.ar_stage "Shake-Out (A&R Mature/Stagnant)" 5.ar_stage "Decline (A&R Stagnant)") addnotes("Rows align the A&R portfolios to the five cash-flow labels in Table 5 footnote 18. Stage values are contrasts with mature firms; lincom total effects are in the log." "OLS; two-way firm and fiscal-year clustered standard errors; two-sided tests.")
est clear
exit, clear
