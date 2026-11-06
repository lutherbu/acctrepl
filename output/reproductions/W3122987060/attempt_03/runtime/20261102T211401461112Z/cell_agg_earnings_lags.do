version 18
set more off
use "data/main/reg.dta", clear

label variable cf_lead "CF(t+1)"
label variable earn0 "EARN(t)"
label variable earn1 "EARN(t-1)"
label variable earn2 "EARN(t-2)"
label variable earn3 "EARN(t-3)"
label variable earn4 "EARN(t-4)"
label variable earn5 "EARN(t-5)"
label variable earn6 "EARN(t-6)"

est clear
local models ""
forvalues k = 0/6 {
    local rhs ""
    forvalues j = 0/`k' {
        local rhs "`rhs' earn`j'"
    }
    regress cf_lead `rhs'
    est store k`k'
    local models "`models' k`k'"
}

esttab `models' using "tables/table2_aggregate_earnings.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab `models' using "tables/table2_aggregate_earnings.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab `models' using "tables/table2_aggregate_earnings.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab `models' using "tables/table2_aggregate_earnings.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
est clear
exit, clear
