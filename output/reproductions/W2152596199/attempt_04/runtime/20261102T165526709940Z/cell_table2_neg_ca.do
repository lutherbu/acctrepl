version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
global ctrl "tenure age size industry_growth cash_flow auditor_type"
global fe "i.sic2 ib2000.calyear"
use "data/main/reg.dta", clear
est clear
count if current_accrual < 0
regress current_accrual $ctrl $fe if current_accrual < 0
predict double start_mean if e(sample), xb
summarize current_accrual if e(sample), meanonly
local start_sigma = 2*abs(r(min))
if 2*abs(r(max)) > `start_sigma' local start_sigma = 2*abs(r(max))
summarize start_mean if e(sample), meanonly
if 2*abs(r(min)) > `start_sigma' local start_sigma = 2*abs(r(min))
if 2*abs(r(max)) > `start_sigma' local start_sigma = 2*abs(r(max))
matrix b0 = e(b)
matrix b0 = b0, (`start_sigma')
truncreg current_accrual $ctrl $fe if current_accrual < 0, ul(0) technique(bhhh 20 nr 300) vce(oim) from(b0, copy)
est store m1
esttab m1 using "tables/table2_panelB_negCA.md", mtitle("Negative Current Accruals") cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.sic2 *.calyear)
esttab m1 using "tables/table2_panelB_negCA.rtf", mtitle("Negative Current Accruals") cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.sic2 *.calyear)
esttab m1 using "tables/table2_panelB_negCA.csv", mtitle("Negative Current Accruals") cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.sic2 *.calyear)
esttab m1 using "tables/table2_panelB_negCA.tex", mtitle("Negative Current Accruals") cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label drop(*.sic2 *.calyear)
est clear
exit, clear
