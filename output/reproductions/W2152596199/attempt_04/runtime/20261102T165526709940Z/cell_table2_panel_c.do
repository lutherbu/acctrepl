version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
global ctrl "tenure age size industry_growth cash_flow auditor_type"
global fe "i.sic2 ib2000.calyear"
use "data/main/reg.dta", clear
est clear
regress discretionary_accrual $ctrl $fe
est store m1
regress current_accrual $ctrl $fe
est store m2
esttab m1 m2 using "tables/table2_panelC.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.sic2 *.calyear)
esttab m1 m2 using "tables/table2_panelC.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.sic2 *.calyear)
esttab m1 m2 using "tables/table2_panelC.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.sic2 *.calyear)
esttab m1 m2 using "tables/table2_panelC.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.sic2 *.calyear)
est clear
exit, clear
