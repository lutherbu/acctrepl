version 18
set more off

global desc "ni_usd pretax_l pretax_sl pretax_sp pretax_p"

use "data/reg.dta", clear
label var ni_usd "Net income (USD millions)"
label var pretax_l "Pretax income in loss region (USD millions)"
label var pretax_sl "Pretax income in small-loss region (USD millions)"
label var pretax_sp "Pretax income in small-profit region (USD millions)"
label var pretax_p "Pretax income in profit region (USD millions)"

est clear
estpost tabstat $desc if sample_common == 1, stat(N mean sd p25 p50 p75) c(s)
esttab using "tables/table4_panel_a_descriptive.md", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/table4_panel_a_descriptive.rtf", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/table4_panel_a_descriptive.csv", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/table4_panel_a_descriptive.tex", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
est clear
exit, clear
