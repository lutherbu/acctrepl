version 18
set more off

global desc "pretax_usd prespc_l prespc_sl prespc_sp prespc_p"

use "data/reg.dta", clear
label var pretax_usd "Pretax income (USD millions)"
label var prespc_l "Income before special items in loss region (USD millions)"
label var prespc_sl "Income before special items in small-loss region (USD millions)"
label var prespc_sp "Income before special items in small-profit region (USD millions)"
label var prespc_p "Income before special items in profit region (USD millions)"

est clear
estpost tabstat $desc if sample_common == 1, stat(N mean sd p25 p50 p75) c(s)
esttab using "tables/table4_panel_b_descriptive.md", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/table4_panel_b_descriptive.rtf", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/table4_panel_b_descriptive.csv", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
esttab using "tables/table4_panel_b_descriptive.tex", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f))") label
est clear
exit, clear
