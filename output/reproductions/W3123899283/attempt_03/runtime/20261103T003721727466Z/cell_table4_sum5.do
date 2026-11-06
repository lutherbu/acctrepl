version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
use "data/reg.dta", clear
est clear
reg sum_earn5 earn_t
est store full_sum5
reg sum_earn5 earn_t if vol_q==5
est store high_sum5
reg sum_earn5 earn_t if vol_q==1
est store low_sum5
esttab full_sum5 high_sum5 low_sum5 using "tables/five_year_sum.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a, fmt(0 3 3) labels("N" "R-squared" "Adjusted R-squared")) replace label drop(_cons) mtitles("Full sample" "Q5 high volatility" "Q1 low volatility")
esttab full_sum5 high_sum5 low_sum5 using "tables/five_year_sum.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a, fmt(0 3 3) labels("N" "R-squared" "Adjusted R-squared")) replace label drop(_cons) mtitles("Full sample" "Q5 high volatility" "Q1 low volatility")
esttab full_sum5 high_sum5 low_sum5 using "tables/five_year_sum.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a, fmt(0 3 3) labels("N" "R-squared" "Adjusted R-squared")) replace label drop(_cons) mtitles("Full sample" "Q5 high volatility" "Q1 low volatility")
esttab full_sum5 high_sum5 low_sum5 using "tables/five_year_sum.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a, fmt(0 3 3) labels("N" "R-squared" "Adjusted R-squared")) replace label drop(_cons) mtitles("Full sample" "Q5 high volatility" "Q1 low volatility")
est clear
exit, clear
