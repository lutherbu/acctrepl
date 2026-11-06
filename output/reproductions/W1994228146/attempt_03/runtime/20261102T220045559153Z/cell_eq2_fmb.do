version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"

global y "roa_f1"
global x "grltnoa acc roa"
global timevar "year"
use "data/reg.dta", clear

label variable roa_f1 "ROA_(t+1)"
label variable grltnoa "GrLTNOA_t"
label variable acc "ACC_t"
label variable roa "ROA_t"
egen long firm_id = group(gvkey)
xtset firm_id $timevar

est clear
xtfmb $y $x
local fmb_years = e(N_g)
lincom grltnoa - acc
local eqdiff_t = r(t)
local eqdiff_p = r(p)
est store eq2_fmb

local r2sum = 0
local annual_fits = 0
local annual_failures = 0
local acc_lt_lt = 0
local equal_slopes = 0
local acc_gt_lt = 0
local missing_tests = 0
forvalues yr = 1964/1993 {
    quietly count if year == `yr'
    local annual_n = r(N)
    if `annual_n' > 0 {
        regress roa_f1 grltnoa acc roa if year == `yr'
        local fit_rc = _rc
        if `fit_rc' == 0 {
            local r2sum = `r2sum' + e(r2_a)
            local ++annual_fits
            test grltnoa = acc
            local p_equal = r(p)
            local b_lt = _b[grltnoa]
            local b_acc = _b[acc]
            if missing(`p_equal') {
                local ++missing_tests
                display as error "Missing annual equality test in `yr' (N=`annual_n')"
            }
            else if `p_equal' < 0.01 {
                if `b_acc' < `b_lt' local ++acc_lt_lt
                else if `b_acc' > `b_lt' local ++acc_gt_lt
                else local ++equal_slopes
            }
            else local ++equal_slopes
        }
        else {
            local ++annual_failures
            display as error "Annual OLS failed in `yr' (N=`annual_n', return=`fit_rc')"
        }
    }
    else {
        local ++annual_failures
        display as error "Annual OLS not estimable in `yr' (N=`annual_n')"
    }
}
if `annual_fits' > 0 local average_ar2 = `r2sum' / `annual_fits'
else local average_ar2 = .

display as text "Fama-MacBeth annual periods = `fmb_years'"
display as text "Annual OLS fits for adjusted R-squared and Panel C = `annual_fits'"
display as text "Annual OLS failures = `annual_failures'; missing equality tests = `missing_tests'"
display as text "Panel C counts at two-sided p < 0.01: ACC < GrLTNOA = `acc_lt_lt'; equal = `equal_slopes'; ACC > GrLTNOA = `acc_gt_lt'"
display as text "Mean annual adjusted R-squared = `average_ar2'"

est restore eq2_fmb
estadd scalar ar2 = `average_ar2'
estadd scalar eqdiff_t = `eqdiff_t'
estadd scalar eqdiff_p = `eqdiff_p'
estadd scalar annual_fits = `annual_fits'
estadd scalar acc_lt_lt = `acc_lt_lt'
estadd scalar equal_slopes = `equal_slopes'
estadd scalar acc_gt_lt = `acc_gt_lt'
est store eq2

esttab eq2 using "tables/table3_eq2.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 ar2 annual_fits eqdiff_t eqdiff_p acc_lt_lt equal_slopes acc_gt_lt, fmt(0 3 3 0 2 6 0 0 0) labels("Firm-year observations" "Average R-squared" "Average adjusted R-squared" "Annual regressions" "GrLTNOA minus ACC t-statistic" "GrLTNOA equals ACC p-value" "ACC < GrLTNOA, p < 0.01" "Equal at p >= 0.01" "ACC > GrLTNOA, p < 0.01")) replace label varlabels(_cons "Intercept")
esttab eq2 using "tables/table3_eq2.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 ar2 annual_fits eqdiff_t eqdiff_p acc_lt_lt equal_slopes acc_gt_lt, fmt(0 3 3 0 2 6 0 0 0) labels("Firm-year observations" "Average R-squared" "Average adjusted R-squared" "Annual regressions" "GrLTNOA minus ACC t-statistic" "GrLTNOA equals ACC p-value" "ACC < GrLTNOA, p < 0.01" "Equal at p >= 0.01" "ACC > GrLTNOA, p < 0.01")) replace label varlabels(_cons "Intercept")
esttab eq2 using "tables/table3_eq2.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 ar2 annual_fits eqdiff_t eqdiff_p acc_lt_lt equal_slopes acc_gt_lt, fmt(0 3 3 0 2 6 0 0 0) labels("Firm-year observations" "Average R-squared" "Average adjusted R-squared" "Annual regressions" "GrLTNOA minus ACC t-statistic" "GrLTNOA equals ACC p-value" "ACC < GrLTNOA, p < 0.01" "Equal at p >= 0.01" "ACC > GrLTNOA, p < 0.01")) replace label varlabels(_cons "Intercept")
esttab eq2 using "tables/table3_eq2.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 ar2 annual_fits eqdiff_t eqdiff_p acc_lt_lt equal_slopes acc_gt_lt, fmt(0 3 3 0 2 6 0 0 0) labels("Firm-year observations" "Average R-squared" "Average adjusted R-squared" "Annual regressions" "GrLTNOA minus ACC t-statistic" "GrLTNOA equals ACC p-value" "ACC < GrLTNOA, p < 0.01" "Equal at p >= 0.01" "ACC > GrLTNOA, p < 0.01")) replace label varlabels(_cons "Intercept")
est clear
exit, clear
