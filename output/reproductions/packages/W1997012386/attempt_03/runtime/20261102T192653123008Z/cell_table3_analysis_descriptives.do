version 18
set more off

use "data/main/reg.dta", clear
est clear
estpost tabstat conmkt conacc stdroa div lev roa size salesgro rndadv beta mse if elig_mkt == 1, stat(N mean sd p25 p50 p75) c(s)
esttab using "tables/table3_analysis_descriptives.md", replace label cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))")
esttab using "tables/table3_analysis_descriptives.rtf", replace label cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))")
esttab using "tables/table3_analysis_descriptives.csv", replace label cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))")
esttab using "tables/table3_analysis_descriptives.tex", replace label cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))")
est clear
exit, clear
