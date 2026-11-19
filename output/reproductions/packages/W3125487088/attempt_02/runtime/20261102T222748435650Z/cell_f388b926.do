version 18
set more off

global descvars "eps_price dum ret dum_return ret_days"

use "reg.dta", clear
est clear
estpost tabstat $descvars, stat(count mean sd p25 p50 p75) columns(statistics)
esttab using "tables/annual_descriptives.md", replace label cells("count(fmt(0)) mean(fmt(4)) sd(fmt(4)) p25(fmt(4)) p50(fmt(4)) p75(fmt(4))")
est clear
estpost tabstat $descvars, stat(count mean sd p25 p50 p75) columns(statistics)
esttab using "tables/annual_descriptives.rtf", replace label cells("count(fmt(0)) mean(fmt(4)) sd(fmt(4)) p25(fmt(4)) p50(fmt(4)) p75(fmt(4))")
est clear
estpost tabstat $descvars, stat(count mean sd p25 p50 p75) columns(statistics)
esttab using "tables/annual_descriptives.csv", replace label cells("count(fmt(0)) mean(fmt(4)) sd(fmt(4)) p25(fmt(4)) p50(fmt(4)) p75(fmt(4))")
est clear
estpost tabstat $descvars, stat(count mean sd p25 p50 p75) columns(statistics)
esttab using "tables/annual_descriptives.tex", replace label cells("count(fmt(0)) mean(fmt(4)) sd(fmt(4)) p25(fmt(4)) p50(fmt(4)) p75(fmt(4))")
est clear
exit, clear
