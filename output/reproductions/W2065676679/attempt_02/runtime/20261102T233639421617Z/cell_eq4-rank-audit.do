version 18
set more off
use "data/history/reg.dta", clear
encode gvkey, gen(firm_id)
xtset firm_id fyear
gen r0 = ret
forvalues j = 1/6 {
    gen r`j' = L`j'.ret
}
est clear
local h = 1
forvalues formation = 1984/1988 {
    preserve
    keep if inrange(fyear,1981,`formation')
    keep if !missing(btm,r0,r1,r2,r3,r4,r5,r6)
    bysort firm_id: gen nfit = _N
    keep if nfit >= 4
    reghdfe btm r0-r6, absorb(firm_id fyear)
    est store q`h'
    local ++h
    restore
}
esttab q1 q2 q3 q4 q5 using "tables/eq4_rank_audit.md", cells(b(fmt(3))) drop(*) stats(N df_m df_r, fmt(0 0 0) labels("Observations" "Model df" "Residual df")) replace label mtitles("1984" "1985" "1986" "1987" "1988")
esttab q1 q2 q3 q4 q5 using "tables/eq4_rank_audit.rtf", cells(b(fmt(3))) drop(*) stats(N df_m df_r, fmt(0 0 0) labels("Observations" "Model df" "Residual df")) replace label mtitles("1984" "1985" "1986" "1987" "1988")
esttab q1 q2 q3 q4 q5 using "tables/eq4_rank_audit.csv", cells(b(fmt(3))) drop(*) stats(N df_m df_r, fmt(0 0 0) labels("Observations" "Model df" "Residual df")) replace label mtitles("1984" "1985" "1986" "1987" "1988")
esttab q1 q2 q3 q4 q5 using "tables/eq4_rank_audit.tex", cells(b(fmt(3))) drop(*) stats(N df_m df_r, fmt(0 0 0) labels("Observations" "Model df" "Residual df")) replace label mtitles("1984" "1985" "1986" "1987" "1988")
est clear
exit, clear
