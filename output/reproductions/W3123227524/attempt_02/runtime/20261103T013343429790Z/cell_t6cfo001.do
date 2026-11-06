version 18
set more off
global y "droa1"
global x "r_cfo"
global ctrl "da sale_growth capex_growth"
adopath ++ "../../../output/reproduction_runs/ado"
use "data/seo_earnings_mgmt/reg.dta", clear
egen long event_panel = group(MASTER_DEAL_NO)
xtset event_panel offer_year
capture mkdir "tables"
est clear
xtfmb $y $x $ctrl
local nperiods = e(N_g)
est store m1
local ar2sum = 0
local ar2n = 0
levelsof offer_year if !missing($y) & !missing($x) & !missing(da) & !missing(sale_growth) & !missing(capex_growth), local(years)
foreach yr of local years {
    regress $y $x $ctrl if offer_year == `yr'
    if e(df_m) == 4 {
        local ar2sum = `ar2sum' + e(r2_a)
        local ar2n = `ar2n' + 1
    }
}
if `ar2n' != `nperiods' {
    display as error "Adjusted R-squared aggregation does not match the estimable Fama-MacBeth years."
    exit 459
}
est restore m1
* Report mean annual adjusted R-squared in the source table's percent units.
estadd scalar r2_a = 100 * `ar2sum' / `ar2n'
esttab m1 using "tables/table6_b_col7.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2 r2_a, labels("Observations" "R-squared" "Mean annual adjusted R-squared (%)") fmt(0 3 3)) replace label drop(_cons)
esttab m1 using "tables/table6_b_col7.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2 r2_a, labels("Observations" "R-squared" "Mean annual adjusted R-squared (%)") fmt(0 3 3)) replace label drop(_cons)
esttab m1 using "tables/table6_b_col7.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2 r2_a, labels("Observations" "R-squared" "Mean annual adjusted R-squared (%)") fmt(0 3 3)) replace label drop(_cons)
esttab m1 using "tables/table6_b_col7.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2 r2_a, labels("Observations" "R-squared" "Mean annual adjusted R-squared (%)") fmt(0 3 3)) replace label drop(_cons)
est clear
exit, clear
