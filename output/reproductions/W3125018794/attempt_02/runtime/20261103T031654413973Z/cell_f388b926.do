version 18
set more off

use "data/equity_offerings/reg.dta", clear

est clear
estpost tabstat abnormal_return realized_growth forecast_growth forecast_error, ///
    statistics(n mean sd p25 p50 p75) columns(statistics)
esttab using "tables/table7_descriptive.md", replace ///
    cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/table7_descriptive.rtf", replace ///
    cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/table7_descriptive.csv", replace ///
    cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/table7_descriptive.tex", replace ///
    cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
est clear
exit, clear
