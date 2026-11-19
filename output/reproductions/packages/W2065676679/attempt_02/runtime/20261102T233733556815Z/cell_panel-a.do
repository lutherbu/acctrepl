version 18
set more off
global future "roe1 roe2 roe3 roe4 roe5"
use "data/main/reg.dta", clear
est clear
local h = 1
foreach y of varlist $future {
    regress `y' roe0 btm, vce(robust)
    est store a`h'
    local ++h
}
esttab a1 a2 a3 a4 a5 using "tables/table5_panel_a.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("1 year" "2 years" "3 years" "4 years" "5 years")
esttab a1 a2 a3 a4 a5 using "tables/table5_panel_a.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("1 year" "2 years" "3 years" "4 years" "5 years")
esttab a1 a2 a3 a4 a5 using "tables/table5_panel_a.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("1 year" "2 years" "3 years" "4 years" "5 years")
esttab a1 a2 a3 a4 a5 using "tables/table5_panel_a.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("1 year" "2 years" "3 years" "4 years" "5 years")
est clear
exit, clear
