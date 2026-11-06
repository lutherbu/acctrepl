version 18
set more off

global dep "pretax_usd"
global x "prespc_l prespc_sl prespc_sp prespc_p"

use "data/reg.dta", clear
label var pretax_usd "Pretax income (USD millions)"
label var prespc_l "Income before special items in loss region (USD millions)"
label var prespc_sl "Income before special items in small-loss region (USD millions)"
label var prespc_sp "Income before special items in small-profit region (USD millions)"
label var prespc_p "Income before special items in profit region (USD millions)"

est clear
regress $dep $x if sample_common == 1
est store panel_b

test prespc_sl = prespc_sp
estadd scalar F_SLSP = r(F)
estadd scalar P_SLSP = r(p)
test prespc_l = prespc_p
estadd scalar F_LP = r(F)
estadd scalar P_LP = r(p)

esttab panel_b using "tables/table4_panel_b.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a F_SLSP P_SLSP F_LP P_LP, labels("Observations" "R-squared" "Adjusted R-squared" "F: beta_SL = beta_SP" "p: beta_SL = beta_SP" "F: beta_L = beta_P" "p: beta_L = beta_P") fmt(0 3 3 2 3 2 3)) replace label
esttab panel_b using "tables/table4_panel_b.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a F_SLSP P_SLSP F_LP P_LP, labels("Observations" "R-squared" "Adjusted R-squared" "F: beta_SL = beta_SP" "p: beta_SL = beta_SP" "F: beta_L = beta_P" "p: beta_L = beta_P") fmt(0 3 3 2 3 2 3)) replace label
esttab panel_b using "tables/table4_panel_b.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a F_SLSP P_SLSP F_LP P_LP, labels("Observations" "R-squared" "Adjusted R-squared" "F: beta_SL = beta_SP" "p: beta_SL = beta_SP" "F: beta_L = beta_P" "p: beta_L = beta_P") fmt(0 3 3 2 3 2 3)) replace label
esttab panel_b using "tables/table4_panel_b.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 stats(N r2 r2_a F_SLSP P_SLSP F_LP P_LP, labels("Observations" "R-squared" "Adjusted R-squared" "F: beta_SL = beta_SP" "p: beta_SL = beta_SP" "F: beta_L = beta_P" "p: beta_L = beta_P") fmt(0 3 3 2 3 2 3)) replace label
est clear
exit, clear
