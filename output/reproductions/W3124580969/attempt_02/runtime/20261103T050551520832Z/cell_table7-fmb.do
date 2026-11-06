version 18
set more off
set linesize 120
adopath ++ "../../../output/reproduction_runs/ado"
use "data/reg.dta", clear

global y "sret1"
global x "gscore"
global ctrl "size bm mom accr eqoff"

global complete "!missing(sret1, gscore, size, bm, mom, accr, eqoff)"
keep if $complete
count
tabulate year

encode gvkey, gen(panel_id)
xtset panel_id year

levelsof year, local(annual_years)
local year_count : word count `annual_years'
local fit_count = 0
local n_min = .
local n_max = 0
local sample_n = _N
scalar audit_n = 0
scalar audit_ar2 = 0
foreach yy of local annual_years {
    regress $y $x $ctrl if year == `yy'
    if e(rank) != 7 | e(df_r) <= 0 {
        display as error "Annual OLS is not full rank or has no residual df in `yy'."
        exit 459
    }
    local fit_count = `fit_count' + 1
    local annual_n = e(N)
    if `annual_n' < `n_min' local n_min = `annual_n'
    if `annual_n' > `n_max' local n_max = `annual_n'
    scalar audit_n = audit_n + e(N)
    scalar audit_ar2 = audit_ar2 + e(r2_a)
}
if `year_count' != 23 | `fit_count' != 23 {
    display as error "Expected 23 full-rank annual fits; observed `fit_count'."
    exit 459
}
local audited_n = audit_n
if `audited_n' != `sample_n' {
    display as error "Annual OLS Ns do not equal the complete-case sample N."
    exit 459
}
local mean_ar2 = audit_ar2 / `fit_count'
display as text "Annual full-rank OLS fits: `fit_count'/23; rank=7; positive residual df; N range=`n_min'-`n_max'; total N=`audited_n'."
display as text "Mean native annual adjusted R-squared = " %7.4f `mean_ar2'

est clear
asreg $y $x $ctrl, fmb newey(1)
est store m1

/* Keep annual package coefficients in memory for the source-specific GSCORE correction. */
bysort year: asreg $y $x $ctrl
assert !missing(_b_size, _b_bm, _b_mom, _b_accr, _b_eqoff, _b_gscore)
egen byte year_tag = tag(year)
keep if year_tag
isid year
tsset year
gen double beta_gscore = _b_gscore
summarize beta_gscore
local beta_mean = r(mean)
local beta_sd = r(sd)
local beta_n = r(N)
if `beta_n' != `fit_count' {
    display as error "GSCORE coefficient series does not contain one value per verified annual fit."
    exit 459
}
local beta_se = `beta_sd' / sqrt(`beta_n')
gen double beta_lag = L.beta_gscore
count if !missing(beta_lag)
local pair_n = r(N)
if `pair_n' != `beta_n' - 1 {
    display as error "GSCORE lag correlation does not use the 22 adjacent annual pairs."
    exit 459
}
correlate beta_gscore beta_lag
matrix bern_corr = r(C)
scalar bern_phi = bern_corr[1,2]
scalar bern_n = `beta_n'
if missing(bern_phi) | abs(bern_phi) >= 1 {
    display as error "Bernard AR(1) phi is missing or outside (-1,1)."
    exit 459
}
scalar bern_phi_zero_factor = sqrt((1+0)/(1-0) - 2*0*(1-(0^bern_n))/(bern_n*(1-0)^2))
if abs(bern_phi_zero_factor-1) > 1e-10 {
    display as error "Bernard factor zero-phi check failed."
    exit 459
}
scalar bern_factor_sq = (1+bern_phi)/(1-bern_phi) - 2*bern_phi*(1-(bern_phi^bern_n))/(bern_n*(1-bern_phi)^2)
if missing(bern_factor_sq) | bern_factor_sq <= 0 {
    display as error "Bernard finite-sample factor is not positive and finite."
    exit 459
}
scalar bern_factor = sqrt(bern_factor_sq)
scalar bern_se = `beta_se' * bern_factor
if missing(bern_se) | bern_se <= 0 {
    display as error "Bernard-adjusted GSCORE standard error is not positive and finite."
    exit 459
}
scalar bern_t = `beta_mean' / bern_se
local gscore_bern_t = bern_t
display as text "Bernard phi convention: Pearson corr(beta_t, beta_t-1), 22 adjacent annual pairs; phi = " %7.4f bern_phi
display as text "Bernard factor (n=23) = " %7.4f bern_factor "; GSCORE mean = " %8.5f `beta_mean' "; unadjusted SE = " %8.5f `beta_se' "; adjusted t = " %7.3f bern_t

est restore m1
estadd scalar ar2 = `mean_ar2'
estadd scalar gscore_bern_t = `gscore_bern_t'

label variable sret1 "SRET1"
label variable gscore "GSCORE"
label variable size "SIZE"
label variable bm "BM"
label variable mom "MOM"
label variable accr "ACCR"
label variable eqoff "EQ_OFF"

esttab m1 using "tables/table7_col2_fmb.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2 ar2 gscore_bern_t, fmt(0 3 3 2) labels("Observations" "Mean R-squared" "Mean adjusted R-squared" "GSCORE Bernard-adjusted t")) replace label
esttab m1 using "tables/table7_col2_fmb.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2 ar2 gscore_bern_t, fmt(0 3 3 2) labels("Observations" "Mean R-squared" "Mean adjusted R-squared" "GSCORE Bernard-adjusted t")) replace label
esttab m1 using "tables/table7_col2_fmb.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2 ar2 gscore_bern_t, fmt(0 3 3 2) labels("Observations" "Mean R-squared" "Mean adjusted R-squared" "GSCORE Bernard-adjusted t")) replace label
esttab m1 using "tables/table7_col2_fmb.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2 ar2 gscore_bern_t, fmt(0 3 3 2) labels("Observations" "Mean R-squared" "Mean adjusted R-squared" "GSCORE Bernard-adjusted t")) replace label
est clear
exit, clear
