version 18
set more off
clear all
adopath ++ "../../../output/reproduction_runs/ado"

global y "yib"
global x "atw dvw dd ibw negib acw"
use "data/reg.dta", clear

est clear
xtset panelid fit_year
foreach h in 1 2 3 {
    quietly summarize ar2mean if tau == `h' & fitok == 1, meanonly
    local adjr2 = r(mean)
    count if tau == `h' & fitok == 1
    xtfmb $y $x if tau == `h' & fitok == 1, lag(3)
    estadd scalar r2_a = `adjr2'
    di as text "horizon=`h' xtfmb_origin_periods=" %9.0f e(N_g) ///
        " mean_annual_adjusted_R2=" %7.4f `adjr2'
    est store h`h'
}

esttab h1 h2 h3 using "tables/table1_panel_b_eq1.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("1-year ahead" "2-year ahead" "3-year ahead")
esttab h1 h2 h3 using "tables/table1_panel_b_eq1.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("1-year ahead" "2-year ahead" "3-year ahead")
esttab h1 h2 h3 using "tables/table1_panel_b_eq1.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("1-year ahead" "2-year ahead" "3-year ahead")
esttab h1 h2 h3 using "tables/table1_panel_b_eq1.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("1-year ahead" "2-year ahead" "3-year ahead")
est clear
exit, clear
