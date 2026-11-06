version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
use "data/main/reg.dta", clear

global y "y_price"
global x "xrd_price_w"
global z "capx_price_w"
global ad "xad_price_w"
global size "size_price_w"
global lev "lev_price_w"
global sampleflag "fit_price"
global impflag "imp_price"

count if $sampleflag==1 & $impflag==0
local observed_outcomes = r(N)
count if $sampleflag==1 & $impflag==1
local imputed_outcomes = r(N)
local imputed_pct = 100*`imputed_outcomes'/(`imputed_outcomes'+`observed_outcomes')
display "Outcome coverage: `observed_outcomes' observed; `imputed_outcomes' imputed (`imputed_pct' percent)"

egen long firm_id = group(gvkey)
xtset firm_id fyear
label variable y_price "SD of future earnings"
label variable xrd_price_w "R&D"
label variable capx_price_w "Capital expenditures"
label variable xad_price_w "Advertising"
label variable size_price_w "Log market value (USD billions)"
label variable lev_price_w "Leverage"

gen double rdplus = xrd_price_w + capx_price_w if $sampleflag==1
local adj_sum = 0
local rank_years = 0
forvalues yr = 1972/1992 {
    regress $y $x $z $ad $size $lev if $sampleflag==1 & fyear==`yr'
    if e(df_m)==5 & e(df_r)>0 {
        local adj_sum = `adj_sum' + e(r2_a)
        local rank_years = `rank_years' + 1
    }
}
local mean_adj = .
if `rank_years'>0 local mean_adj = `adj_sum'/`rank_years'
display "Full-rank annual fits: `rank_years' of 21; mean annual adjusted R-squared: `mean_adj'"

est clear
xtfmb $y $x $z $ad $size $lev if $sampleflag==1, lag(5)
est store m_base
local annual_fits = e(N_g)
xtfmb $y $x rdplus $ad $size $lev if $sampleflag==1, lag(5)
local gap_beta = _b[$x]
local gap_se = _se[$x]
local gap_t = `gap_beta'/`gap_se'
local gap_df = e(df_r)
local gap_p = 2*ttail(`gap_df',abs(`gap_t'))
est restore m_base
estadd scalar r2_a = `mean_adj'
estadd scalar annual_fits = `annual_fits'
estadd scalar full_rank_years = `rank_years'
estadd scalar observed_outcomes = `observed_outcomes'
estadd scalar imputed_outcomes = `imputed_outcomes'
estadd scalar imputed_pct = `imputed_pct'
estadd scalar rd_capx_gap = `gap_beta'
estadd scalar rd_capx_gap_se = `gap_se'
estadd scalar rd_capx_gap_t = `gap_t'
estadd scalar rd_capx_gap_p = `gap_p'

esttab m_base using "tables/table3_panel_b.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label stats(N r2 r2_a annual_fits full_rank_years observed_outcomes imputed_outcomes imputed_pct rd_capx_gap rd_capx_gap_se rd_capx_gap_t rd_capx_gap_p, fmt(0 3 3 0 0 0 0 1 3 3 2 3) labels("Observations" "Average R-squared" "Mean annual adjusted R-squared" "Annual fits" "Full-rank years" "Observed outcomes" "Imputed outcomes" "Imputed percent" "R&D minus CapEx" "Difference NW SE" "Difference NW t" "Difference two-sided p")) addnotes("Separate annual OLS cross-sections, averaged over fiscal years 1972–1992; coefficient-series inference uses Newey–West lag 5." "R&D minus CapEx is estimated as the R&D coefficient in the equivalent R&D and R&D+CapEx parameterization; its reported p-value is two-sided.")
esttab m_base using "tables/table3_panel_b.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label stats(N r2 r2_a annual_fits full_rank_years observed_outcomes imputed_outcomes imputed_pct rd_capx_gap rd_capx_gap_se rd_capx_gap_t rd_capx_gap_p, fmt(0 3 3 0 0 0 0 1 3 3 2 3) labels("Observations" "Average R-squared" "Mean annual adjusted R-squared" "Annual fits" "Full-rank years" "Observed outcomes" "Imputed outcomes" "Imputed percent" "R&D minus CapEx" "Difference NW SE" "Difference NW t" "Difference two-sided p")) addnotes("Separate annual OLS cross-sections, averaged over fiscal years 1972–1992; coefficient-series inference uses Newey–West lag 5." "R&D minus CapEx is estimated as the R&D coefficient in the equivalent R&D and R&D+CapEx parameterization; its reported p-value is two-sided.")
esttab m_base using "tables/table3_panel_b.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label stats(N r2 r2_a annual_fits full_rank_years observed_outcomes imputed_outcomes imputed_pct rd_capx_gap rd_capx_gap_se rd_capx_gap_t rd_capx_gap_p, fmt(0 3 3 0 0 0 0 1 3 3 2 3) labels("Observations" "Average R-squared" "Mean annual adjusted R-squared" "Annual fits" "Full-rank years" "Observed outcomes" "Imputed outcomes" "Imputed percent" "R&D minus CapEx" "Difference NW SE" "Difference NW t" "Difference two-sided p")) addnotes("Separate annual OLS cross-sections, averaged over fiscal years 1972–1992; coefficient-series inference uses Newey–West lag 5." "R&D minus CapEx is estimated as the R&D coefficient in the equivalent R&D and R&D+CapEx parameterization; its reported p-value is two-sided.")
esttab m_base using "tables/table3_panel_b.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label stats(N r2 r2_a annual_fits full_rank_years observed_outcomes imputed_outcomes imputed_pct rd_capx_gap rd_capx_gap_se rd_capx_gap_t rd_capx_gap_p, fmt(0 3 3 0 0 0 0 1 3 3 2 3) labels("Observations" "Average R-squared" "Mean annual adjusted R-squared" "Annual fits" "Full-rank years" "Observed outcomes" "Imputed outcomes" "Imputed percent" "R&D minus CapEx" "Difference NW SE" "Difference NW t" "Difference two-sided p")) addnotes("Separate annual OLS cross-sections, averaged over fiscal years 1972–1992; coefficient-series inference uses Newey–West lag 5." "R&D minus CapEx is estimated as the R&D coefficient in the equivalent R&D and R&D+CapEx parameterization; its reported p-value is two-sided.")

est clear
asreg $y $x $z $ad $size $lev if $sampleflag==1, by(fyear)
egen byte coefyear = tag(fyear) if $sampleflag==1
label variable _b_xrd_price_w "R&D"
label variable _b_capx_price_w "Capital expenditures"
label variable _b_xad_price_w "Advertising"
label variable _b_size_price_w "Log market value (USD billions)"
label variable _b_lev_price_w "Leverage"
label variable _b_cons "Constant"
label variable _adjR2 "Adjusted R-squared"
estpost tabstat _b_xrd_price_w _b_capx_price_w _b_xad_price_w _b_size_price_w _b_lev_price_w _b_cons _adjR2 if coefyear==1, statistics(N mean sd min p25 p50 p75 max) columns(statistics)
esttab using "tables/table3_panel_b_annual_coef_stats.md", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) min(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f)) max(fmt(%9.3f))") label
esttab using "tables/table3_panel_b_annual_coef_stats.rtf", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) min(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f)) max(fmt(%9.3f))") label
esttab using "tables/table3_panel_b_annual_coef_stats.csv", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) min(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f)) max(fmt(%9.3f))") label
esttab using "tables/table3_panel_b_annual_coef_stats.tex", replace cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) min(fmt(%9.3f)) p25(fmt(%9.3f)) p50(fmt(%9.3f)) p75(fmt(%9.3f)) max(fmt(%9.3f))") label
est clear
exit, clear
