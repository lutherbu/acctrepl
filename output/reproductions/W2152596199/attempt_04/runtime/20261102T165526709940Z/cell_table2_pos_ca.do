version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
global ctrl "tenure age size industry_growth cash_flow auditor_type"
global fe "i.sic2 ib2000.calyear"
use "data/main/reg.dta", clear
est clear
count if current_accrual > 0
truncreg current_accrual $ctrl $fe if current_accrual > 0, ll(0)
est store m1
esttab m1 using "tables/table2_panelB_posCA.md", mtitle("Positive Current Accruals") cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.sic2 *.calyear)
esttab m1 using "tables/table2_panelB_posCA.rtf", mtitle("Positive Current Accruals") cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.sic2 *.calyear)
esttab m1 using "tables/table2_panelB_posCA.csv", mtitle("Positive Current Accruals") cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.sic2 *.calyear)
esttab m1 using "tables/table2_panelB_posCA.tex", mtitle("Positive Current Accruals") cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.sic2 *.calyear)
est clear
exit, clear
