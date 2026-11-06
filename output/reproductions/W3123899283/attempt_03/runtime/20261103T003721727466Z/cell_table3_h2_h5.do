version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
use "data/reg.dta", clear
est clear
reg future_earn2 earn_t
est store full_h2
reg future_earn2 earn_t if vol_q==5
est store high_h2
reg future_earn2 earn_t if vol_q==1
est store low_h2
reg future_earn3 earn_t
est store full_h3
reg future_earn3 earn_t if vol_q==5
est store high_h3
reg future_earn3 earn_t if vol_q==1
est store low_h3
reg future_earn4 earn_t
est store full_h4
reg future_earn4 earn_t if vol_q==5
est store high_h4
reg future_earn4 earn_t if vol_q==1
est store low_h4
reg future_earn5 earn_t
est store full_h5
reg future_earn5 earn_t if vol_q==5
est store high_h5
reg future_earn5 earn_t if vol_q==1
est store low_h5
esttab full_h2 high_h2 low_h2 full_h3 high_h3 low_h3 full_h4 high_h4 low_h4 full_h5 high_h5 low_h5 using "tables/persistence_h2_h5.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a, fmt(0 3 3) labels("N" "R-squared" "Adjusted R-squared")) replace label drop(_cons) mtitles("Full h=2" "Q5 h=2" "Q1 h=2" "Full h=3" "Q5 h=3" "Q1 h=3" "Full h=4" "Q5 h=4" "Q1 h=4" "Full h=5" "Q5 h=5" "Q1 h=5")
esttab full_h2 high_h2 low_h2 full_h3 high_h3 low_h3 full_h4 high_h4 low_h4 full_h5 high_h5 low_h5 using "tables/persistence_h2_h5.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a, fmt(0 3 3) labels("N" "R-squared" "Adjusted R-squared")) replace label drop(_cons) mtitles("Full h=2" "Q5 h=2" "Q1 h=2" "Full h=3" "Q5 h=3" "Q1 h=3" "Full h=4" "Q5 h=4" "Q1 h=4" "Full h=5" "Q5 h=5" "Q1 h=5")
esttab full_h2 high_h2 low_h2 full_h3 high_h3 low_h3 full_h4 high_h4 low_h4 full_h5 high_h5 low_h5 using "tables/persistence_h2_h5.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a, fmt(0 3 3) labels("N" "R-squared" "Adjusted R-squared")) replace label drop(_cons) mtitles("Full h=2" "Q5 h=2" "Q1 h=2" "Full h=3" "Q5 h=3" "Q1 h=3" "Full h=4" "Q5 h=4" "Q1 h=4" "Full h=5" "Q5 h=5" "Q1 h=5")
esttab full_h2 high_h2 low_h2 full_h3 high_h3 low_h3 full_h4 high_h4 low_h4 full_h5 high_h5 low_h5 using "tables/persistence_h2_h5.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a, fmt(0 3 3) labels("N" "R-squared" "Adjusted R-squared")) replace label drop(_cons) mtitles("Full h=2" "Q5 h=2" "Q1 h=2" "Full h=3" "Q5 h=3" "Q1 h=3" "Full h=4" "Q5 h=4" "Q1 h=4" "Full h=5" "Q5 h=5" "Q1 h=5")
est clear
exit, clear
