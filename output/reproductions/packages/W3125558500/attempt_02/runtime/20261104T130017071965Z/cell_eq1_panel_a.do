version 18
set more off

global dep "ni_usd"
global x "pretax_l pretax_sl pretax_sp pretax_p"

use "data/reg.dta", clear
label var ni_usd "Net income (USD millions)"
label var pretax_l "Pretax income in loss region (USD millions)"
label var pretax_sl "Pretax income in small-loss region (USD millions)"
label var pretax_sp "Pretax income in small-profit region (USD millions)"
label var pretax_p "Pretax income in profit region (USD millions)"

est clear
regress $dep $x if sample_common == 1
est store panel_a

test pretax_sl = pretax_sp
estadd scalar F_SLSP = r(F)
estadd scalar P_SLSP = r(p)
test pretax_l = pretax_p
estadd scalar F_LP = r(F)
estadd scalar P_LP = r(p)

esttab panel_a using "tables/table4_panel_a.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a F_SLSP P_SLSP F_LP P_LP, labels("Observations" "R-squared" "Adjusted R-squared" "F: beta_SL = beta_SP" "p: beta_SL = beta_SP" "F: beta_L = beta_P" "p: beta_L = beta_P") fmt(0 3 3 2 3 2 3)) replace label
esttab panel_a using "tables/table4_panel_a.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a F_SLSP P_SLSP F_LP P_LP, labels("Observations" "R-squared" "Adjusted R-squared" "F: beta_SL = beta_SP" "p: beta_SL = beta_SP" "F: beta_L = beta_P" "p: beta_L = beta_P") fmt(0 3 3 2 3 2 3)) replace label
esttab panel_a using "tables/table4_panel_a.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a F_SLSP P_SLSP F_LP P_LP, labels("Observations" "R-squared" "Adjusted R-squared" "F: beta_SL = beta_SP" "p: beta_SL = beta_SP" "F: beta_L = beta_P" "p: beta_L = beta_P") fmt(0 3 3 2 3 2 3)) replace label
esttab panel_a using "tables/table4_panel_a.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a F_SLSP P_SLSP F_LP P_LP, labels("Observations" "R-squared" "Adjusted R-squared" "F: beta_SL = beta_SP" "p: beta_SL = beta_SP" "F: beta_L = beta_P" "p: beta_L = beta_P") fmt(0 3 3 2 3 2 3)) replace label
est clear
exit, clear
