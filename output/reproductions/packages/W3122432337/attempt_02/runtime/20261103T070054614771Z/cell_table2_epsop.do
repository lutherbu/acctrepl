version 18
set more off
use "data/table2_valuation/reg.dta", clear

est clear
label variable price3_usd "Price three months after quarter end (USD)"
label variable bvps_usd "Book value per share (USD)"
label variable street_usd "I/B/E/S STREET EPS (USD)"
label variable epsop_usd "Operating EPS (USD)"
label variable other_street_usd "Bottom-line EPS less STREET EPS (USD)"
label variable other_epsop_usd "Bottom-line EPS less operating EPS (USD)"
label variable ni_usd "Bottom-line EPS including extraordinary items (USD)"
regress price3_usd bvps_usd epsop_usd other_epsop_usd
est store m1

esttab m1 using "tables/table2_valuation_epsop.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab m1 using "tables/table2_valuation_epsop.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab m1 using "tables/table2_valuation_epsop.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab m1 using "tables/table2_valuation_epsop.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
exit, clear
