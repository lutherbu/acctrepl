version 18
set more off

global y "conmkt"
global x "stdroa div lev roa size salesgro rndadv"
global sample "elig_mkt"

use "data/main/reg.dta", clear
est clear
regress $y $x if $sample == 1, vce(robust)
est store panel_a

esttab panel_a using "tables/table3_panel_a_levels_1993_98.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab panel_a using "tables/table3_panel_a_levels_1993_98.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab panel_a using "tables/table3_panel_a_levels_1993_98.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
esttab panel_a using "tables/table3_panel_a_levels_1993_98.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label
est clear
exit, clear
