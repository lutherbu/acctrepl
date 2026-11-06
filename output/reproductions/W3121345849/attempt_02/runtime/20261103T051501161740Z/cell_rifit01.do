version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
global x "nege rix rinegx rib ritacc"
use "data/rolling_fit_panel/reg.dta", clear
capture mkdir "tables"
est clear

keep gvkey avyear riy1 riy2 riy3 $x
expand 30
bysort gvkey avyear: gen byte copy=_n
gen byte horizon=ceil(copy/10)
gen int fityear=avyear+horizon+mod(copy-1,10)
keep if inrange(fityear,1969,2012) & inrange(avyear,fityear-9-horizon,fityear-horizon)
gen double y=.
replace y=riy1 if horizon==1
replace y=riy2 if horizon==2
replace y=riy3 if horizon==3
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
            if `ncc' > 6 {
                regress y $x if fityear==`t' & horizon==`h', notable
                if e(N)>6 & e(rank)==6 {
                    replace rankok=1 if fityear==`t' & horizon==`h'
                    local ++nfull

                    if `t'==1969 | `t'==2012 {
                        scalar ri_nat_N_`h'_`t' = e(N)
                        scalar ri_nat_cons_`h'_`t' = _b[_cons]
                        scalar ri_nat_nege_`h'_`t' = _b[nege]
                        scalar ri_nat_rix_`h'_`t' = _b[rix]
                        scalar ri_nat_rinegx_`h'_`t' = _b[rinegx]
                        scalar ri_nat_rib_`h'_`t' = _b[rib]
                        scalar ri_nat_ritacc_`h'_`t' = _b[ritacc]
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
display "RI native grouped rank coverage: groups checked=" `nchecked' " full rank with residual df=" `nfull' " rank/df failures=" `nrank' " empty groups=" `nempty'
bysort fityear horizon: gen byte cc_tag=(_n==1)
format n_cc %9.0f
list fityear horizon n_cc rankok if cc_tag, noobs sepby(horizon)

forvalues h=1/3 {
    preserve
    keep if horizon==`h'
    bysort fityear: gen byte raw_tag=(_n==1)
    quietly count if raw_tag & !complete
    local rawmiss=r(N)
    display "RI horizon " `h' " raw first-row tags on incomplete observations=" `rawmiss'
    drop raw_tag
    keep if complete
    asreg y $x, by(fityear)
    bysort fityear: gen byte tag=(_n==1)
    quietly count if tag & !complete
    local postmiss=r(N)
    display "RI horizon " `h' " tagged incomplete results after complete-case restriction=" `postmiss'
    assert `postmiss'==0
    count if tag
    local ntag=r(N)
    assert `ntag'==44
    count if tag & !missing(_Nobs, _R2, _adjR2, _b_cons, _b_nege, _b_rix, _b_rinegx, _b_rib, _b_ritacc)
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
            quietly summarize _b_nege if tag & fityear==`endpoint', meanonly
            local p_nege=r(mean)
            quietly summarize _b_rix if tag & fityear==`endpoint', meanonly
            local p_rix=r(mean)
            quietly summarize _b_rinegx if tag & fityear==`endpoint', meanonly
            local p_rinegx=r(mean)
            quietly summarize _b_rib if tag & fityear==`endpoint', meanonly
            local p_rib=r(mean)
            quietly summarize _b_ritacc if tag & fityear==`endpoint', meanonly
            local p_ritacc=r(mean)
            quietly summarize _Nobs if tag & fityear==`endpoint', meanonly
            local asregN=r(mean)
            local natN=scalar(ri_nat_N_`h'_`endpoint')
            local bdiff=max(abs(scalar(ri_nat_cons_`h'_`endpoint')-`pcons'), abs(scalar(ri_nat_nege_`h'_`endpoint')-`p_nege'), abs(scalar(ri_nat_rix_`h'_`endpoint')-`p_rix'), abs(scalar(ri_nat_rinegx_`h'_`endpoint')-`p_rinegx'), abs(scalar(ri_nat_rib_`h'_`endpoint')-`p_rib'), abs(scalar(ri_nat_ritacc_`h'_`endpoint')-`p_ritacc'))
            local ndiff=abs(`natN'-`asregN')
            display "RI horizon " `h' " year " `endpoint' " native/asreg max coefficient difference=" %12.8g `bdiff' " N difference=" %9.0f `ndiff'
        }
        else {
            display "RI horizon " `h' " year " `endpoint' " native comparison skipped: full-rank check failed"
        }
    }
    count if tag & rankok
    local nfullvec=r(N)
    display "RI horizon " `h' " native full-rank years=" `nfullvec' " of 44 vectors"
    keep if tag & rankok
    count
    local nfits=r(N)
    if `h'==3 {
        assert `nfits'==43
    }
    else {
        assert `nfits'==44
    }
    display "RI qualifying complete-case asreg fits at horizon " `h' "=" `nfits'
    quietly summarize _R2, meanonly
    local meanr2=100*r(mean)
    local r2fits=r(N)
    if `h'==3 {
        assert `r2fits'==43
    }
    else {
        assert `r2fits'==44
    }
    quietly summarize _adjR2, meanonly
    local meanar2=100*r(mean)
    local ar2fits=r(N)
    if `h'==3 {
        assert `ar2fits'==43
    }
    else {
        assert `ar2fits'==44
    }
    quietly summarize _Nobs, meanonly
    local meanrows=r(mean)
    quietly summarize _Nobs
    local minrows=r(min)
    local maxrows=r(max)
    display "RI horizon " `h' " mean annual N=" %9.1f `meanrows' " min=" %9.0f `minrows' " max=" %9.0f `maxrows' " mean R2/AdjR2 percentages from " `nfits' " groups"
    mean _b_cons _b_nege _b_rix _b_rinegx _b_rib _b_ritacc
    estadd scalar r2=`meanr2', replace
    estadd scalar r2_a=`meanar2', replace
    est store h`h'
    restore
}
esttab h1 h2 h3 using "tables/ri_forecast.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("t+1" "t+2" "t+3") coeflabels(_b_cons "Intercept" _b_nege "NegE" _b_rix "E" _b_rinegx "NegE*E" _b_rib "B" _b_ritacc "TACC") addnotes("Each column averages annual OLS fit vectors that pass the native full-rank check; coverage counts and exceptions are documented in the log." "Parentheses show two-sided p-values for native tests of the mean coefficient; see logs for t statistics." "N counts annual fits; underlying regression N is summarized by year and horizon in the log." "R-squared statistics are percentages, as in Table 1.")
esttab h1 h2 h3 using "tables/ri_forecast.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("t+1" "t+2" "t+3") coeflabels(_b_cons "Intercept" _b_nege "NegE" _b_rix "E" _b_rinegx "NegE*E" _b_rib "B" _b_ritacc "TACC") addnotes("Each column averages annual OLS fit vectors that pass the native full-rank check; coverage counts and exceptions are documented in the log." "Parentheses show two-sided p-values for native tests of the mean coefficient; see logs for t statistics." "N counts annual fits; underlying regression N is summarized by year and horizon in the log." "R-squared statistics are percentages, as in Table 1.")
esttab h1 h2 h3 using "tables/ri_forecast.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("t+1" "t+2" "t+3") coeflabels(_b_cons "Intercept" _b_nege "NegE" _b_rix "E" _b_rinegx "NegE*E" _b_rib "B" _b_ritacc "TACC") addnotes("Each column averages annual OLS fit vectors that pass the native full-rank check; coverage counts and exceptions are documented in the log." "Parentheses show two-sided p-values for native tests of the mean coefficient; see logs for t statistics." "N counts annual fits; underlying regression N is summarized by year and horizon in the log." "R-squared statistics are percentages, as in Table 1.")
esttab h1 h2 h3 using "tables/ri_forecast.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace label mtitles("t+1" "t+2" "t+3") coeflabels(_b_cons "Intercept" _b_nege "NegE" _b_rix "E" _b_rinegx "NegE*E" _b_rib "B" _b_ritacc "TACC") addnotes("Each column averages annual OLS fit vectors that pass the native full-rank check; coverage counts and exceptions are documented in the log." "Parentheses show two-sided p-values for native tests of the mean coefficient; see logs for t statistics." "N counts annual fits; underlying regression N is summarized by year and horizon in the log." "R-squared statistics are percentages, as in Table 1.")
est clear
exit, clear
