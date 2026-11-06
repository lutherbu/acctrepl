version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
use "data/reg.dta", clear
est clear
reg future_earn1 earn_t
est store full_h1
reg future_earn1 earn_t if vol_q==1
est store q1_h1
reg future_earn1 earn_t if vol_q==2
est store q2_h1
reg future_earn1 earn_t if vol_q==3
est store q3_h1
reg future_earn1 earn_t if vol_q==4
est store q4_h1
reg future_earn1 earn_t if vol_q==5
est store q5_h1
esttab full_h1 q1_h1 q2_h1 q3_h1 q4_h1 q5_h1 using "tables/persistence_h1.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a, fmt(0 3 3) labels("N" "R-squared" "Adjusted R-squared")) replace label drop(_cons) mtitles("Full h=1" "Q1 h=1" "Q2 h=1" "Q3 h=1" "Q4 h=1" "Q5 h=1")
esttab full_h1 q1_h1 q2_h1 q3_h1 q4_h1 q5_h1 using "tables/persistence_h1.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a, fmt(0 3 3) labels("N" "R-squared" "Adjusted R-squared")) replace label drop(_cons) mtitles("Full h=1" "Q1 h=1" "Q2 h=1" "Q3 h=1" "Q4 h=1" "Q5 h=1")
esttab full_h1 q1_h1 q2_h1 q3_h1 q4_h1 q5_h1 using "tables/persistence_h1.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a, fmt(0 3 3) labels("N" "R-squared" "Adjusted R-squared")) replace label drop(_cons) mtitles("Full h=1" "Q1 h=1" "Q2 h=1" "Q3 h=1" "Q4 h=1" "Q5 h=1")
esttab full_h1 q1_h1 q2_h1 q3_h1 q4_h1 q5_h1 using "tables/persistence_h1.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a, fmt(0 3 3) labels("N" "R-squared" "Adjusted R-squared")) replace label drop(_cons) mtitles("Full h=1" "Q1 h=1" "Q2 h=1" "Q3 h=1" "Q4 h=1" "Q5 h=1")
est clear
exit, clear
