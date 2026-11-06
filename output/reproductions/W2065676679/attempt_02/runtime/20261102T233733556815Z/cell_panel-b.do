version 18
set more off
global future "roe1 roe2 roe3 roe4 roe5"
use "data/main/reg.dta", clear
est clear
summarize identity_pass, meanonly
local identityok = (r(min) == 1 & r(max) == 1)
local h = 1
foreach y of varlist $future {
    regress `y' roe0 bc lc timefx eps, vce(robust)
    lincom bc - lc
    local cdiff = r(estimate)
    local cdt = r(t)
    local cdp = r(p)
    estadd scalar cdiff = `cdiff'
    estadd scalar cdt = `cdt'
    estadd scalar cdp = `cdp'
    if `identityok' {
        test (bc = lc) (bc = timefx) (bc = eps)
        local incrF = r(F)
        local incrp = r(p)
        estadd scalar incrF = `incrF'
        estadd scalar incrp = `incrp'
    }
    else {
        estadd scalar incrF = .
        estadd scalar incrp = .
    }
    est store b`h'
    local ++h
}
esttab b1 b2 b3 b4 b5 using "tables/table5_panel_b.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(cdiff cdt incrF N, fmt(3 2 2 0) labels("c-d" "t(c-d)" "Incremental robust F" "N")) replace label mtitles("1 year" "2 years" "3 years" "4 years" "5 years")
esttab b1 b2 b3 b4 b5 using "tables/table5_panel_b.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(cdiff cdt incrF N, fmt(3 2 2 0) labels("c-d" "t(c-d)" "Incremental robust F" "N")) replace label mtitles("1 year" "2 years" "3 years" "4 years" "5 years")
esttab b1 b2 b3 b4 b5 using "tables/table5_panel_b.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(cdiff cdt incrF N, fmt(3 2 2 0) labels("c-d" "t(c-d)" "Incremental robust F" "N")) replace label mtitles("1 year" "2 years" "3 years" "4 years" "5 years")
esttab b1 b2 b3 b4 b5 using "tables/table5_panel_b.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(cdiff cdt incrF N, fmt(3 2 2 0) labels("c-d" "t(c-d)" "Incremental robust F" "N")) replace label mtitles("1 year" "2 years" "3 years" "4 years" "5 years")
esttab b1 b2 b3 b4 b5 using "tables/table5_panel_b_tests.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) stats(cdiff cdt cdp incrF incrp N r2 ar2, fmt(3 2 3 2 3 0 3 3) labels("BC-LC" "t(BC-LC)" "p(BC-LC)" "Incremental robust F(3,df)" "p(incremental F)" "N" "R-squared" "Adjusted R-squared")) drop(*) replace label mtitles("1 year" "2 years" "3 years" "4 years" "5 years")
esttab b1 b2 b3 b4 b5 using "tables/table5_panel_b_tests.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) stats(cdiff cdt cdp incrF incrp N r2 ar2, fmt(3 2 3 2 3 0 3 3) labels("BC-LC" "t(BC-LC)" "p(BC-LC)" "Incremental robust F(3,df)" "p(incremental F)" "N" "R-squared" "Adjusted R-squared")) drop(*) replace label mtitles("1 year" "2 years" "3 years" "4 years" "5 years")
esttab b1 b2 b3 b4 b5 using "tables/table5_panel_b_tests.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) stats(cdiff cdt cdp incrF incrp N r2 ar2, fmt(3 2 3 2 3 0 3 3) labels("BC-LC" "t(BC-LC)" "p(BC-LC)" "Incremental robust F(3,df)" "p(incremental F)" "N" "R-squared" "Adjusted R-squared")) drop(*) replace label mtitles("1 year" "2 years" "3 years" "4 years" "5 years")
esttab b1 b2 b3 b4 b5 using "tables/table5_panel_b_tests.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) stats(cdiff cdt cdp incrF incrp N r2 ar2, fmt(3 2 3 2 3 0 3 3) labels("BC-LC" "t(BC-LC)" "p(BC-LC)" "Incremental robust F(3,df)" "p(incremental F)" "N" "R-squared" "Adjusted R-squared")) drop(*) replace label mtitles("1 year" "2 years" "3 years" "4 years" "5 years")
est clear
exit, clear
