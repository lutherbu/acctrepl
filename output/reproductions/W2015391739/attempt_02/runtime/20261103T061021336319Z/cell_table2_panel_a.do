version 18
set more off
use "data/basu_replication_1963_1990/reg.dta", clear
label variable x "Scaled earnings X"
label variable r_actual "Actual return"
label variable r_sim "Simulated return"
est clear
reg x r_actual if r_actual < 0
est store bad_actual
reg x r_sim if !missing(r_sim) & r_sim < 0
est store bad_sim
esttab bad_actual bad_sim using "tables/table2_panelA.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 drop(_cons) replace label mtitle("Actual returns" "Simulated returns")
esttab bad_actual bad_sim using "tables/table2_panelA.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 drop(_cons) replace label mtitle("Actual returns" "Simulated returns")
esttab bad_actual bad_sim using "tables/table2_panelA.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 drop(_cons) replace label mtitle("Actual returns" "Simulated returns")
esttab bad_actual bad_sim using "tables/table2_panelA.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 drop(_cons) replace label mtitle("Actual returns" "Simulated returns")
est clear
exit, clear
