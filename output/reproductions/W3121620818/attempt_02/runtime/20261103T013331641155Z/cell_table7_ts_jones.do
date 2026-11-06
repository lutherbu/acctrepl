version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
use "data/reg.dta", clear
keep if fit_common == 1
label variable audit "Audit Opinion"
label variable bp "BP"
label variable mktcap "MKTCAP"
label variable de "DE"
label variable perform "PERFORM"
label variable abs_tsj "abs(DA)"
est clear
logit audit bp mktcap de perform abs_tsj
test abs_tsj
estadd scalar model_chi2 = e(chi2)
estadd scalar model_p = e(p)
estadd scalar wald_da = r(chi2)
estadd scalar odds_da = exp(_b[abs_tsj])
est store m1
esttab m1 using "tables/table7_ts_jones.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars(r2_p model_chi2 model_p wald_da odds_da) replace label
esttab m1 using "tables/table7_ts_jones.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars(r2_p model_chi2 model_p wald_da odds_da) replace label
esttab m1 using "tables/table7_ts_jones.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars(r2_p model_chi2 model_p wald_da odds_da) replace label
esttab m1 using "tables/table7_ts_jones.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 scalars(r2_p model_chi2 model_p wald_da odds_da) replace label
est clear
exit, clear
