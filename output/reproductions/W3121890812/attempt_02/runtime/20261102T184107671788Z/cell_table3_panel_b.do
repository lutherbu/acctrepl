version 18
set more off
use "data/book_tax_firm_years/reg.dta", clear

label var ptbi_tp1 "PTBI(t+1)"
label var lnbtd "LNBTD"
label var lpbtd "LPBTD"
label var ptbi_t "PTBI(t)"
label var ptbi_lnbtd "PTBI(t) x LNBTD"
label var ptbi_lpbtd "PTBI(t) x LPBTD"

est clear
regress ptbi_tp1 lnbtd lpbtd ptbi_t ptbi_lnbtd ptbi_lpbtd
est store table3_panel_b
test ptbi_lnbtd = ptbi_lpbtd
estadd scalar F_equal = r(F)
estadd scalar p_equal = r(p)

esttab table3_panel_b using "tables/table3_panel_b.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(r2 r2_a N F_equal p_equal, fmt(3 3 0 2 4) labels("R-squared" "Adjusted R-squared" "Observations" "F test gamma4=gamma5" "F-test p-value")) replace label
esttab table3_panel_b using "tables/table3_panel_b.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(r2 r2_a N F_equal p_equal, fmt(3 3 0 2 4) labels("R-squared" "Adjusted R-squared" "Observations" "F test gamma4=gamma5" "F-test p-value")) replace label
esttab table3_panel_b using "tables/table3_panel_b.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(r2 r2_a N F_equal p_equal, fmt(3 3 0 2 4) labels("R-squared" "Adjusted R-squared" "Observations" "F test gamma4=gamma5" "F-test p-value")) replace label
esttab table3_panel_b using "tables/table3_panel_b.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(r2 r2_a N F_equal p_equal, fmt(3 3 0 2 4) labels("R-squared" "Adjusted R-squared" "Observations" "F test gamma4=gamma5" "F-test p-value")) replace label
est clear
exit, clear
