version 18
set more off
use "data/table3_information/reg.dta", clear

est clear
label variable car "Three-day market-adjusted return"
label variable uop_street "Unexpected STREET EPS scaled by beginning-quarter price"
label variable uop_epsop "Unexpected operating EPS scaled by beginning-quarter price"
label variable street_usd "I/B/E/S STREET EPS (USD)"
label variable epsop_usd "Operating EPS (USD)"
label variable forecast_usd "Latest pre-announcement mean forecast (USD)"
label variable price0_usd "Beginning-quarter price (USD)"
regress car uop_street
est store m1

esttab m1 using "tables/table3_information_street.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab m1 using "tables/table3_information_street.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab m1 using "tables/table3_information_street.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab m1 using "tables/table3_information_street.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
exit, clear
