version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
global y "pct_small_positive_profit"
global x "fiscal_year"
use "data/ibes_surprises/reg.dta", clear
label variable $x "Fiscal year trend"
est clear
regress $y $x
est store m1
esttab m1 using "tables/small_positive_profit_surprise.md", keep(fiscal_year) cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab m1 using "tables/small_positive_profit_surprise.rtf", keep(fiscal_year) cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab m1 using "tables/small_positive_profit_surprise.csv", keep(fiscal_year) cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab m1 using "tables/small_positive_profit_surprise.tex", keep(fiscal_year) cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
est clear
exit, clear
