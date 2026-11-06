version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
use "data/reg.dta", clear
est clear
reg future_earn1 c.earn_t##ib1.vol_q if inlist(vol_q,1,5)
test 5.vol_q#c.earn_t = 0
local t2_p = r(p)
local t2_diff = -_b[5.vol_q#c.earn_t]
estadd scalar beta_diff = `t2_diff'
estadd scalar p_diff = `t2_p'
est store diff_t2
reg sum_earn5 c.earn_t##ib1.vol_q if inlist(vol_q,1,5)
test 5.vol_q#c.earn_t = 0
local t4_p = r(p)
local t4_diff = -_b[5.vol_q#c.earn_t]
estadd scalar beta_diff = `t4_diff'
estadd scalar p_diff = `t4_p'
est store diff_t4
esttab diff_t2 diff_t4 using "tables/persistence_contrasts.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a beta_diff p_diff, fmt(0 3 3 3 3) labels("N" "R-squared" "Adjusted R-squared" "Q1 minus Q5 beta" "Two-sided p-value")) replace label mtitles("Table 2 h=1" "Table 4 five-year sum")
esttab diff_t2 diff_t4 using "tables/persistence_contrasts.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a beta_diff p_diff, fmt(0 3 3 3 3) labels("N" "R-squared" "Adjusted R-squared" "Q1 minus Q5 beta" "Two-sided p-value")) replace label mtitles("Table 2 h=1" "Table 4 five-year sum")
esttab diff_t2 diff_t4 using "tables/persistence_contrasts.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a beta_diff p_diff, fmt(0 3 3 3 3) labels("N" "R-squared" "Adjusted R-squared" "Q1 minus Q5 beta" "Two-sided p-value")) replace label mtitles("Table 2 h=1" "Table 4 five-year sum")
esttab diff_t2 diff_t4 using "tables/persistence_contrasts.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a beta_diff p_diff, fmt(0 3 3 3 3) labels("N" "R-squared" "Adjusted R-squared" "Q1 minus Q5 beta" "Two-sided p-value")) replace label mtitles("Table 2 h=1" "Table 4 five-year sum")
est clear
exit, clear
