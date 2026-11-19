version 18
set more off
use "data/icw_pp_ratio_eligible/reg.dta", clear

global descvars "pp_ratio"
est clear
estpost tabstat $descvars, stat(n mean sd p25 p50 p75) c(s)
esttab using "tables/descriptive_pp_ratio.md", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") replace label addnotes("Rated PP facilities with classifiable pricing bases; borrowers have rated PP facilities before and after the first report.")
esttab using "tables/descriptive_pp_ratio.rtf", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") replace label addnotes("Rated PP facilities with classifiable pricing bases; borrowers have rated PP facilities before and after the first report.")
esttab using "tables/descriptive_pp_ratio.csv", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") replace label addnotes("Rated PP facilities with classifiable pricing bases; borrowers have rated PP facilities before and after the first report.")
esttab using "tables/descriptive_pp_ratio.tex", cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") replace label addnotes("Rated PP facilities with classifiable pricing bases; borrowers have rated PP facilities before and after the first report.")
est clear
exit, clear
