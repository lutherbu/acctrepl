version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"

global y "delta_roa"
global ctrl "trg_comprnk acq_size acq_lev acq_tobin_dum acq_roa acq_fcf acq_q_fcf trg_size trg_lev trg_tobin trg_roa stock_corr sync block all_cash all_stock tender_d hostile diffind rel_size"

use "data/us_acquisitions_1307/reg.dta", clear
est clear
regress $y $ctrl, vce(robust)
estadd scalar adjusted_r2 = e(r2_a)
quietly summarize $y if e(sample)
estadd scalar outcome_mean = r(mean)
est store m1

esttab m1 using "tables/table3_delta_roa.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 adjusted_r2 outcome_mean, fmt(0 3 3 3) labels("Observations" "R-squared" "Adjusted R-squared" "Outcome mean")) replace label
esttab m1 using "tables/table3_delta_roa.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 adjusted_r2 outcome_mean, fmt(0 3 3 3) labels("Observations" "R-squared" "Adjusted R-squared" "Outcome mean")) replace label
esttab m1 using "tables/table3_delta_roa.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 adjusted_r2 outcome_mean, fmt(0 3 3 3) labels("Observations" "R-squared" "Adjusted R-squared" "Outcome mean")) replace label
esttab m1 using "tables/table3_delta_roa.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 adjusted_r2 outcome_mean, fmt(0 3 3 3) labels("Observations" "R-squared" "Adjusted R-squared" "Outcome mean")) replace label
est clear
exit, clear
