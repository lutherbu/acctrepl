version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
global x "hvzat hvzdvc dd hvze nege hvzac"
use "data/rolling_fit_panel/reg.dta", clear
capture mkdir "tables"
est clear

keep gvkey avyear hvzy1 hvzy2 hvzy3 $x
expand 30
bysort gvkey avyear: gen byte copy=_n
gen byte horizon=ceil(copy/10)
gen int fityear=avyear+horizon+mod(copy-1,10)
keep if inrange(fityear,1969,2012) & inrange(avyear,fityear-9-horizon,fityear-horizon)
gen double y=.
replace y=hvzy1 if horizon==1
replace y=hvzy2 if horizon==2
replace y=hvzy3 if horizon==3
egen byte missct=rowmiss(y $x)
gen byte complete=missct==0
drop missct
bysort fityear horizon: egen long n_cc=total(complete)
sort fityear horizon gvkey avyear

gen byte rankok=0
local nchecked = 0
local nfull = 0
local nrank = 0
local nempty = 0
forvalues t=1969/2012 {
    forvalues h=1/3 {
        local ++nchecked
        quietly count if fityear==`t' & horizon==`h'
        local nrecords = r(N)
        if `nrecords' > 0 {
            quietly summarize n_cc if fityear==`t' & horizon==`h', meanonly
            local ncc = r(mean)
            if `ncc' > 7 {
                regress y $x if fityear==`t' & horizon==`h', notable
                if e(N)>7 & e(rank)==7 {
                    replace rankok=1 if fityear==`t' & horizon==`h'
                    local ++nfull

                    if `t'==1969 | `t'==2012 {
                        scalar hvz_nat_N_`h'_`t' = e(N)
                        scalar hvz_nat_cons_`h'_`t' = _b[_cons]
                        scalar hvz_nat_hvzat_`h'_`t' = _b[hvzat]
                        scalar hvz_nat_hvzdvc_`h'_`t' = _b[hvzdvc]
                        scalar hvz_nat_dd_`h'_`t' = _b[dd]
                        scalar hvz_nat_hvze_`h'_`t' = _b[hvze]
                        scalar hvz_nat_nege_`h'_`t' = _b[nege]
                        scalar hvz_nat_hvzac_`h'_`t' = _b[hvzac]
                    }
                }
                else {
                    local ++nrank
                }
            }
            else {
                local ++nempty
            }
        }
        else {
            local ++nempty
        }
    }
}
display "HVZ native grouped rank coverage: groups checked=" `nchecked' " full rank with residual df=" `nfull' " rank/df failures=" `nrank' " empty groups=" `nempty'
bysort fityear horizon: gen byte cc_tag=(_n==1)
format n_cc %9.0f
list fityear horizon n_cc rankok if cc_tag, noobs sepby(horizon)

forvalues h=1/3 {
    preserve
    keep if horizon==`h'
    bysort fityear: gen byte raw_tag=(_n==1)
    quietly count if raw_tag & !complete
    local rawmiss=r(N)
    display "HVZ horizon " `h' " raw first-row tags on incomplete observations=" `rawmiss'
    drop raw_tag
    keep if complete
    asreg y $x, by(fityear)
    bysort fityear: gen byte tag=(_n==1)
    quietly count if tag & !complete
    local postmiss=r(N)
    display "HVZ horizon " `h' " tagged incomplete results after complete-case restriction=" `postmiss'
    assert `postmiss'==0
    count if tag
    local ntag=r(N)
    assert `ntag'==44
    count if tag & !missing(_Nobs, _R2, _adjR2, _b_cons, _b_hvzat, _b_hvzdvc, _b_dd, _b_hvze, _b_nege, _b_hvzac)
    local nvec=r(N)
    assert `nvec'==44
    list fityear n_cc rankok _Nobs _R2 _adjR2 if tag, noobs
    foreach endpoint in 1969 2012 {
        quietly count if tag & rankok & fityear==`endpoint'
        local endpoint_rank=r(N)
        if `endpoint_rank'==1 {
            quietly summarize _b_cons if tag & fityear==`endpoint', meanonly
            local pcons=r(mean)
            local nvector=r(N)
            assert `nvector'==1
            quietly summarize _b_hvzat if tag & fityear==`endpoint', meanonly
            local p_hvzat=r(mean)
            quietly summarize _b_hvzdvc if tag & fityear==`endpoint', meanonly
            local p_hvzdvc=r(mean)
            quietly summarize _b_dd if tag & fityear==`endpoint', meanonly
            local p_dd=r(mean)
            quietly summarize _b_hvze if tag & fityear==`endpoint', meanonly
            local p_hvze=r(mean)
            quietly summarize _b_nege if tag & fityear==`endpoint', meanonly
            local p_nege=r(mean)
            quietly summarize _b_hvzac if tag & fityear==`endpoint', meanonly
            local p_hvzac=r(mean)
            quietly summarize _Nobs if tag & fityear==`endpoint', meanonly
            local asregN=r(mean)
            local natN=scalar(hvz_nat_N_`h'_`endpoint')
            local bdiff=max(abs(scalar(hvz_nat_cons_`h'_`endpoint')-`pcons'), abs(scalar(hvz_nat_hvzat_`h'_`endpoint')-`p_hvzat'), abs(scalar(hvz_nat_hvzdvc_`h'_`endpoint')-`p_hvzdvc'), abs(scalar(hvz_nat_dd_`h'_`endpoint')-`p_dd'), abs(scalar(hvz_nat_hvze_`h'_`endpoint')-`p_hvze'), abs(scalar(hvz_nat_nege_`h'_`endpoint')-`p_nege'), abs(scalar(hvz_nat_hvzac_`h'_`endpoint')-`p_hvzac'))
            local ndiff=abs(`natN'-`asregN')
            display "HVZ horizon " `h' " year " `endpoint' " native/asreg max coefficient difference=" %12.8g `bdiff' " N difference=" %9.0f `ndiff'
        }
        else {
            display "HVZ horizon " `h' " year " `endpoint' " native comparison skipped: full-rank check failed"
        }
    }
    count if tag & rankok
    local nfullvec=r(N)
    display "HVZ horizon " `h' " native full-rank years=" `nfullvec' " of 44 vectors"
    keep if tag & rankok
    count
    local nfits=r(N)
    assert `nfits'==44
    display "HVZ qualifying complete-case asreg fits at horizon " `h' "=" `nfits'
    quietly summarize _R2, meanonly
    local meanr2=100*r(mean)
    local r2fits=r(N)
    assert `r2fits'==44
    quietly summarize _adjR2, meanonly
    local meanar2=100*r(mean)
    local ar2fits=r(N)
    assert `ar2fits'==44
    quietly summarize _Nobs, meanonly
    local meanrows=r(mean)
    quietly summarize _Nobs
    local minrows=r(min)
    local maxrows=r(max)
    display "HVZ horizon " `h' " mean annual N=" %9.1f `meanrows' " min=" %9.0f `minrows' " max=" %9.0f `maxrows' " mean R2/AdjR2 percentages from 44 groups"
    mean _b_cons _b_hvzat _b_hvzdvc _b_dd _b_hvze _b_nege _b_hvzac
    estadd scalar r2=`meanr2', replace
    estadd scalar r2_a=`meanar2', replace
    est store h`h'
    restore
}
esttab h1 h2 h3 using "tables/hvz_forecast.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("t+1" "t+2" "t+3") coeflabels(_b_cons "Intercept" _b_hvzat "A" _b_hvzdvc "D" _b_dd "DD" _b_hvze "E" _b_nege "NegE" _b_hvzac "AC") addnotes("Each column averages annual OLS fit vectors that pass the native full-rank check; coverage counts and exceptions are documented in the log." "Parentheses show two-sided p-values for native tests of the mean coefficient; see logs for t statistics." "N counts annual fits; underlying regression N is summarized by year and horizon in the log." "R-squared statistics are percentages, as in Table 1.")
esttab h1 h2 h3 using "tables/hvz_forecast.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("t+1" "t+2" "t+3") coeflabels(_b_cons "Intercept" _b_hvzat "A" _b_hvzdvc "D" _b_dd "DD" _b_hvze "E" _b_nege "NegE" _b_hvzac "AC") addnotes("Each column averages annual OLS fit vectors that pass the native full-rank check; coverage counts and exceptions are documented in the log." "Parentheses show two-sided p-values for native tests of the mean coefficient; see logs for t statistics." "N counts annual fits; underlying regression N is summarized by year and horizon in the log." "R-squared statistics are percentages, as in Table 1.")
esttab h1 h2 h3 using "tables/hvz_forecast.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("t+1" "t+2" "t+3") coeflabels(_b_cons "Intercept" _b_hvzat "A" _b_hvzdvc "D" _b_dd "DD" _b_hvze "E" _b_nege "NegE" _b_hvzac "AC") addnotes("Each column averages annual OLS fit vectors that pass the native full-rank check; coverage counts and exceptions are documented in the log." "Parentheses show two-sided p-values for native tests of the mean coefficient; see logs for t statistics." "N counts annual fits; underlying regression N is summarized by year and horizon in the log." "R-squared statistics are percentages, as in Table 1.")
esttab h1 h2 h3 using "tables/hvz_forecast.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("t+1" "t+2" "t+3") coeflabels(_b_cons "Intercept" _b_hvzat "A" _b_hvzdvc "D" _b_dd "DD" _b_hvze "E" _b_nege "NegE" _b_hvzac "AC") addnotes("Each column averages annual OLS fit vectors that pass the native full-rank check; coverage counts and exceptions are documented in the log." "Parentheses show two-sided p-values for native tests of the mean coefficient; see logs for t statistics." "N counts annual fits; underlying regression N is summarized by year and horizon in the log." "R-squared statistics are percentages, as in Table 1.")
est clear
exit, clear
