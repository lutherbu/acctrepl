version 18
set more off
set scheme s1mono
use "data/reg.dta", clear
label var year "Calendar year"
label var z_loss "Avoid loss"
label var z_decrease "Avoid earnings decrease"
label var z_surprise "Avoid negative surprise"
est clear
regress z_loss year
est store m_loss
regress z_decrease year
est store m_decrease
regress z_surprise year
est store m_surprise
esttab m_loss m_decrease m_surprise using "tables/figure1_trend_ols.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("Avoid loss" "Avoid earnings decrease" "Avoid negative surprise") varlabels(year "Year" _cons "Constant") addnotes("Conventional OLS standard errors; p-values are two-sided. Figure 1 reports one-tailed language for the threshold criterion.")
esttab m_loss m_decrease m_surprise using "tables/figure1_trend_ols.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("Avoid loss" "Avoid earnings decrease" "Avoid negative surprise") varlabels(year "Year" _cons "Constant") addnotes("Conventional OLS standard errors; p-values are two-sided. Figure 1 reports one-tailed language for the threshold criterion.")
esttab m_loss m_decrease m_surprise using "tables/figure1_trend_ols.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("Avoid loss" "Avoid earnings decrease" "Avoid negative surprise") varlabels(year "Year" _cons "Constant") addnotes("Conventional OLS standard errors; p-values are two-sided. Figure 1 reports one-tailed language for the threshold criterion.")
esttab m_loss m_decrease m_surprise using "tables/figure1_trend_ols.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("Avoid loss" "Avoid earnings decrease" "Avoid negative surprise") varlabels(year "Year" _cons "Constant") addnotes("Conventional OLS standard errors; p-values are two-sided. Figure 1 reports one-tailed language for the threshold criterion.")

twoway (line z_loss year, lcolor(black) lpattern(solid) lwidth(medthick)) (connected z_decrease year, lcolor(black) lpattern(dash) msymbol(square) mcolor(black)) (connected z_surprise year, lcolor(black) lpattern(shortdash) msymbol(circle) mcolor(black)), title("Temporal analysis of quarterly earnings thresholds") ytitle("Standardized differences", margin(medsmall)) xtitle("Year") xlabel(1985(1)2002, angle(90) labsize(vsmall)) ylabel(-18(2)6, labsize(small)) yscale(range(-18 6)) yline(0, lcolor(gs8) lpattern(dash)) legend(order(1 "Avoid loss" 2 "Avoid earnings decrease" 3 "Avoid negative surprise") rows(2) size(small) position(6)) graphregion(color(white)) xsize(9) ysize(5)
graph export "figures/figure1_thresholds.pdf", replace
graph export "figures/figure1_thresholds.png", width(1800) replace

preserve
keep year z_loss z_decrease z_surprise
reshape long z_, i(year) j(threshold_name) string
generate byte threshold = .
replace threshold = 1 if threshold_name == "loss"
replace threshold = 2 if threshold_name == "decrease"
replace threshold = 3 if threshold_name == "surprise"
label define threshold 1 "Avoid loss" 2 "Avoid earnings decrease" 3 "Avoid negative surprise"
label values threshold threshold
regress z_ ib1.threshold##c.year
test (2.threshold#c.year = 0) (3.threshold#c.year = 0)
restore
est clear
exit, clear
