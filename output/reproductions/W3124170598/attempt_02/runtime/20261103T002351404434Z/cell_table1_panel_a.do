version 18
set more off

adopath ++ "../../../output/reproduction_runs/ado"

global raw_da "da_jones da_mj da_jlag da_jcur da_mjlag da_mjcur"
global matched_da "da_jones_pm_lag da_jones_pm_cur da_mj_pm_lag da_mj_pm_cur"
global winsor_vars "ta $raw_da $matched_da"
global pct_vars "ta_pct da_jones_pct da_mj_pct da_jlag_pct da_jcur_pct da_mjlag_pct da_mjcur_pct da_jones_pm_lag_pct da_jones_pm_cur_pct da_mj_pm_lag_pct da_mj_pm_cur_pct"

use "data/reg.dta", clear
sort sic2 fyear gvkey
egen fitgrp=group(sic2 fyear)

* Jones equation (6): ordinary constant is included by default.
egen n_j = total(!missing(ta,inv_at,d_sales,ppe_n)), by(sic2 fyear)
capture drop _residuals
quietly asreg ta inv_at d_sales ppe_n if n_j>=10, by(sic2 fyear) fit
gen byte coef_complete_j = !missing(_b_cons,_b_inv_at,_b_d_sales,_b_ppe_n) if n_j>=10
replace coef_complete_j=0 if missing(coef_complete_j)
gen byte rank_j=.
levelsof fitgrp if n_j>=10, local(groups_j)
local residual_checks_j=0
foreach g of local groups_j {
    regress ta inv_at d_sales ppe_n if fitgrp==`g' & n_j>=10, noheader notable
    local native_rank = e(rank)
    quietly replace rank_j=`native_rank' if fitgrp==`g'
    if `native_rank'==4 & `residual_checks_j'<3 {
        capture drop audit_resid_native audit_resid_abs
        predict double audit_resid_native if e(sample), residual
        gen double audit_resid_abs=abs(_residuals-audit_resid_native) if e(sample)
        quietly summarize audit_resid_abs if fitgrp==`g', meanonly
        local audit_n_j=r(N)
        local audit_max_j=r(max)
        display as text "Residual comparison (Jones equation (6)): group=`g'; N=`audit_n_j'; max |asreg-native|=`audit_max_j'"
        drop audit_resid_native audit_resid_abs
        local ++residual_checks_j
    }
}
egen byte coef_any_j=max(coef_complete_j), by(sic2 fyear)
egen byte coef_all_j=min(coef_complete_j), by(sic2 fyear)
gen byte fit_ok_j=coef_any_j==1 & rank_j==4
replace _residuals=. if fit_ok_j==0
rename _residuals da_jones
egen tag_j=tag(sic2 fyear) if n_j>=10
quietly count if tag_j==1
local g_j=r(N)
quietly count if tag_j==1 & coef_any_j==1
local coef_any_j=r(N)
quietly count if tag_j==1 & coef_all_j==1
local coef_all_j=r(N)
quietly count if tag_j==1 & rank_j==4
local rank_full_j=r(N)
tabulate rank_j if tag_j==1, missing
quietly count if tag_j==1 & fit_ok_j==1
local full_j=r(N)
quietly count if !missing(da_jones)
local obs_j=r(N)
display as text "Jones equation (6): qualifying groups=`g_j'; asreg any/all-row groups=`coef_any_j'/`coef_all_j'; native full-rank groups=`rank_full_j'; retained groups/rows=`full_j'/`obs_j'"
drop tag_j coef_complete_j coef_any_j coef_all_j rank_j fit_ok_j
capture drop _fitted
capture drop _b_*
capture drop _Nobs _R2 _adjR2

* Modified Jones equation (6): re-estimate with the receivables-adjusted sales change.
egen n_mj = total(!missing(ta,inv_at,d_mj,ppe_n)), by(sic2 fyear)
capture drop _residuals
quietly asreg ta inv_at d_mj ppe_n if n_mj>=10, by(sic2 fyear) fit
gen byte coef_complete_mj = !missing(_b_cons,_b_inv_at,_b_d_mj,_b_ppe_n) if n_mj>=10
replace coef_complete_mj=0 if missing(coef_complete_mj)
gen byte rank_mj=.
levelsof fitgrp if n_mj>=10, local(groups_mj)
local residual_checks_mj=0
foreach g of local groups_mj {
    regress ta inv_at d_mj ppe_n if fitgrp==`g' & n_mj>=10, noheader notable
    local native_rank = e(rank)
    quietly replace rank_mj=`native_rank' if fitgrp==`g'
    if `native_rank'==4 & `residual_checks_mj'<3 {
        capture drop audit_resid_native audit_resid_abs
        predict double audit_resid_native if e(sample), residual
        gen double audit_resid_abs=abs(_residuals-audit_resid_native) if e(sample)
        quietly summarize audit_resid_abs if fitgrp==`g', meanonly
        local audit_n_mj=r(N)
        local audit_max_mj=r(max)
        display as text "Residual comparison (Modified Jones equation (6)): group=`g'; N=`audit_n_mj'; max |asreg-native|=`audit_max_mj'"
        drop audit_resid_native audit_resid_abs
        local ++residual_checks_mj
    }
}
egen byte coef_any_mj=max(coef_complete_mj), by(sic2 fyear)
egen byte coef_all_mj=min(coef_complete_mj), by(sic2 fyear)
gen byte fit_ok_mj=coef_any_mj==1 & rank_mj==4
replace _residuals=. if fit_ok_mj==0
rename _residuals da_mj
egen tag_mj=tag(sic2 fyear) if n_mj>=10
quietly count if tag_mj==1
local g_mj=r(N)
quietly count if tag_mj==1 & coef_any_mj==1
local coef_any_mj=r(N)
quietly count if tag_mj==1 & coef_all_mj==1
local coef_all_mj=r(N)
quietly count if tag_mj==1 & rank_mj==4
local rank_full_mj=r(N)
tabulate rank_mj if tag_mj==1, missing
quietly count if tag_mj==1 & fit_ok_mj==1
local full_mj=r(N)
quietly count if !missing(da_mj)
local obs_mj=r(N)
display as text "Modified Jones equation (6): qualifying groups=`g_mj'; asreg any/all-row groups=`coef_any_mj'/`coef_all_mj'; native full-rank groups=`rank_full_mj'; retained groups/rows=`full_mj'/`obs_mj'"
drop tag_mj coef_complete_mj coef_any_mj coef_all_mj rank_mj fit_ok_mj
capture drop _fitted
capture drop _b_*
capture drop _Nobs _R2 _adjR2

* Jones equation (7), prior-year ROA.
egen n_jlag = total(!missing(ta,inv_at,d_sales,ppe_n,roa_lag)), by(sic2 fyear)
capture drop _residuals
quietly asreg ta inv_at d_sales ppe_n roa_lag if n_jlag>=10, by(sic2 fyear) fit
gen byte coef_complete_jlag = !missing(_b_cons,_b_inv_at,_b_d_sales,_b_ppe_n,_b_roa_lag) if n_jlag>=10
replace coef_complete_jlag=0 if missing(coef_complete_jlag)
gen byte rank_jlag=.
levelsof fitgrp if n_jlag>=10, local(groups_jlag)
local residual_checks_jlag=0
foreach g of local groups_jlag {
    regress ta inv_at d_sales ppe_n roa_lag if fitgrp==`g' & n_jlag>=10, noheader notable
    local native_rank = e(rank)
    quietly replace rank_jlag=`native_rank' if fitgrp==`g'
    if `native_rank'==5 & `residual_checks_jlag'<3 {
        capture drop audit_resid_native audit_resid_abs
        predict double audit_resid_native if e(sample), residual
        gen double audit_resid_abs=abs(_residuals-audit_resid_native) if e(sample)
        quietly summarize audit_resid_abs if fitgrp==`g', meanonly
        local audit_n_jlag=r(N)
        local audit_max_jlag=r(max)
        display as text "Residual comparison (Jones equation (7), prior-year ROA): group=`g'; N=`audit_n_jlag'; max |asreg-native|=`audit_max_jlag'"
        drop audit_resid_native audit_resid_abs
        local ++residual_checks_jlag
    }
}
egen byte coef_any_jlag=max(coef_complete_jlag), by(sic2 fyear)
egen byte coef_all_jlag=min(coef_complete_jlag), by(sic2 fyear)
gen byte fit_ok_jlag=coef_any_jlag==1 & rank_jlag==5
replace _residuals=. if fit_ok_jlag==0
rename _residuals da_jlag
egen tag_jlag=tag(sic2 fyear) if n_jlag>=10
quietly count if tag_jlag==1
local g_jlag=r(N)
quietly count if tag_jlag==1 & coef_any_jlag==1
local coef_any_jlag=r(N)
quietly count if tag_jlag==1 & coef_all_jlag==1
local coef_all_jlag=r(N)
quietly count if tag_jlag==1 & rank_jlag==5
local rank_full_jlag=r(N)
tabulate rank_jlag if tag_jlag==1, missing
quietly count if tag_jlag==1 & fit_ok_jlag==1
local full_jlag=r(N)
quietly count if !missing(da_jlag)
local obs_jlag=r(N)
display as text "Jones equation (7), prior-year ROA: qualifying groups=`g_jlag'; asreg any/all-row groups=`coef_any_jlag'/`coef_all_jlag'; native full-rank groups=`rank_full_jlag'; retained groups/rows=`full_jlag'/`obs_jlag'"
drop tag_jlag coef_complete_jlag coef_any_jlag coef_all_jlag rank_jlag fit_ok_jlag
capture drop _fitted
capture drop _b_*
capture drop _Nobs _R2 _adjR2

* Jones equation (7), current-year ROA.
egen n_jcur = total(!missing(ta,inv_at,d_sales,ppe_n,roa_cur)), by(sic2 fyear)
capture drop _residuals
quietly asreg ta inv_at d_sales ppe_n roa_cur if n_jcur>=10, by(sic2 fyear) fit
gen byte coef_complete_jcur = !missing(_b_cons,_b_inv_at,_b_d_sales,_b_ppe_n,_b_roa_cur) if n_jcur>=10
replace coef_complete_jcur=0 if missing(coef_complete_jcur)
gen byte rank_jcur=.
levelsof fitgrp if n_jcur>=10, local(groups_jcur)
local residual_checks_jcur=0
foreach g of local groups_jcur {
    regress ta inv_at d_sales ppe_n roa_cur if fitgrp==`g' & n_jcur>=10, noheader notable
    local native_rank = e(rank)
    quietly replace rank_jcur=`native_rank' if fitgrp==`g'
    if `native_rank'==5 & `residual_checks_jcur'<3 {
        capture drop audit_resid_native audit_resid_abs
        predict double audit_resid_native if e(sample), residual
        gen double audit_resid_abs=abs(_residuals-audit_resid_native) if e(sample)
        quietly summarize audit_resid_abs if fitgrp==`g', meanonly
        local audit_n_jcur=r(N)
        local audit_max_jcur=r(max)
        display as text "Residual comparison (Jones equation (7), current-year ROA): group=`g'; N=`audit_n_jcur'; max |asreg-native|=`audit_max_jcur'"
        drop audit_resid_native audit_resid_abs
        local ++residual_checks_jcur
    }
}
egen byte coef_any_jcur=max(coef_complete_jcur), by(sic2 fyear)
egen byte coef_all_jcur=min(coef_complete_jcur), by(sic2 fyear)
gen byte fit_ok_jcur=coef_any_jcur==1 & rank_jcur==5
replace _residuals=. if fit_ok_jcur==0
rename _residuals da_jcur
egen tag_jcur=tag(sic2 fyear) if n_jcur>=10
quietly count if tag_jcur==1
local g_jcur=r(N)
quietly count if tag_jcur==1 & coef_any_jcur==1
local coef_any_jcur=r(N)
quietly count if tag_jcur==1 & coef_all_jcur==1
local coef_all_jcur=r(N)
quietly count if tag_jcur==1 & rank_jcur==5
local rank_full_jcur=r(N)
tabulate rank_jcur if tag_jcur==1, missing
quietly count if tag_jcur==1 & fit_ok_jcur==1
local full_jcur=r(N)
quietly count if !missing(da_jcur)
local obs_jcur=r(N)
display as text "Jones equation (7), current-year ROA: qualifying groups=`g_jcur'; asreg any/all-row groups=`coef_any_jcur'/`coef_all_jcur'; native full-rank groups=`rank_full_jcur'; retained groups/rows=`full_jcur'/`obs_jcur'"
drop tag_jcur coef_complete_jcur coef_any_jcur coef_all_jcur rank_jcur fit_ok_jcur
capture drop _fitted
capture drop _b_*
capture drop _Nobs _R2 _adjR2

* Modified Jones equation (7), prior-year ROA.
egen n_mjlag = total(!missing(ta,inv_at,d_mj,ppe_n,roa_lag)), by(sic2 fyear)
capture drop _residuals
quietly asreg ta inv_at d_mj ppe_n roa_lag if n_mjlag>=10, by(sic2 fyear) fit
gen byte coef_complete_mjlag = !missing(_b_cons,_b_inv_at,_b_d_mj,_b_ppe_n,_b_roa_lag) if n_mjlag>=10
replace coef_complete_mjlag=0 if missing(coef_complete_mjlag)
gen byte rank_mjlag=.
levelsof fitgrp if n_mjlag>=10, local(groups_mjlag)
local residual_checks_mjlag=0
foreach g of local groups_mjlag {
    regress ta inv_at d_mj ppe_n roa_lag if fitgrp==`g' & n_mjlag>=10, noheader notable
    local native_rank = e(rank)
    quietly replace rank_mjlag=`native_rank' if fitgrp==`g'
    if `native_rank'==5 & `residual_checks_mjlag'<3 {
        capture drop audit_resid_native audit_resid_abs
        predict double audit_resid_native if e(sample), residual
        gen double audit_resid_abs=abs(_residuals-audit_resid_native) if e(sample)
        quietly summarize audit_resid_abs if fitgrp==`g', meanonly
        local audit_n_mjlag=r(N)
        local audit_max_mjlag=r(max)
        display as text "Residual comparison (Modified Jones equation (7), prior-year ROA): group=`g'; N=`audit_n_mjlag'; max |asreg-native|=`audit_max_mjlag'"
        drop audit_resid_native audit_resid_abs
        local ++residual_checks_mjlag
    }
}
egen byte coef_any_mjlag=max(coef_complete_mjlag), by(sic2 fyear)
egen byte coef_all_mjlag=min(coef_complete_mjlag), by(sic2 fyear)
gen byte fit_ok_mjlag=coef_any_mjlag==1 & rank_mjlag==5
replace _residuals=. if fit_ok_mjlag==0
rename _residuals da_mjlag
egen tag_mjlag=tag(sic2 fyear) if n_mjlag>=10
quietly count if tag_mjlag==1
local g_mjlag=r(N)
quietly count if tag_mjlag==1 & coef_any_mjlag==1
local coef_any_mjlag=r(N)
quietly count if tag_mjlag==1 & coef_all_mjlag==1
local coef_all_mjlag=r(N)
quietly count if tag_mjlag==1 & rank_mjlag==5
local rank_full_mjlag=r(N)
tabulate rank_mjlag if tag_mjlag==1, missing
quietly count if tag_mjlag==1 & fit_ok_mjlag==1
local full_mjlag=r(N)
quietly count if !missing(da_mjlag)
local obs_mjlag=r(N)
display as text "Modified Jones equation (7), prior-year ROA: qualifying groups=`g_mjlag'; asreg any/all-row groups=`coef_any_mjlag'/`coef_all_mjlag'; native full-rank groups=`rank_full_mjlag'; retained groups/rows=`full_mjlag'/`obs_mjlag'"
drop tag_mjlag coef_complete_mjlag coef_any_mjlag coef_all_mjlag rank_mjlag fit_ok_mjlag
capture drop _fitted
capture drop _b_*
capture drop _Nobs _R2 _adjR2

* Modified Jones equation (7), current-year ROA.
egen n_mjcur = total(!missing(ta,inv_at,d_mj,ppe_n,roa_cur)), by(sic2 fyear)
capture drop _residuals
quietly asreg ta inv_at d_mj ppe_n roa_cur if n_mjcur>=10, by(sic2 fyear) fit
gen byte coef_complete_mjcur = !missing(_b_cons,_b_inv_at,_b_d_mj,_b_ppe_n,_b_roa_cur) if n_mjcur>=10
replace coef_complete_mjcur=0 if missing(coef_complete_mjcur)
gen byte rank_mjcur=.
levelsof fitgrp if n_mjcur>=10, local(groups_mjcur)
local residual_checks_mjcur=0
foreach g of local groups_mjcur {
    regress ta inv_at d_mj ppe_n roa_cur if fitgrp==`g' & n_mjcur>=10, noheader notable
    local native_rank = e(rank)
    quietly replace rank_mjcur=`native_rank' if fitgrp==`g'
    if `native_rank'==5 & `residual_checks_mjcur'<3 {
        capture drop audit_resid_native audit_resid_abs
        predict double audit_resid_native if e(sample), residual
        gen double audit_resid_abs=abs(_residuals-audit_resid_native) if e(sample)
        quietly summarize audit_resid_abs if fitgrp==`g', meanonly
        local audit_n_mjcur=r(N)
        local audit_max_mjcur=r(max)
        display as text "Residual comparison (Modified Jones equation (7), current-year ROA): group=`g'; N=`audit_n_mjcur'; max |asreg-native|=`audit_max_mjcur'"
        drop audit_resid_native audit_resid_abs
        local ++residual_checks_mjcur
    }
}
egen byte coef_any_mjcur=max(coef_complete_mjcur), by(sic2 fyear)
egen byte coef_all_mjcur=min(coef_complete_mjcur), by(sic2 fyear)
gen byte fit_ok_mjcur=coef_any_mjcur==1 & rank_mjcur==5
replace _residuals=. if fit_ok_mjcur==0
rename _residuals da_mjcur
egen tag_mjcur=tag(sic2 fyear) if n_mjcur>=10
quietly count if tag_mjcur==1
local g_mjcur=r(N)
quietly count if tag_mjcur==1 & coef_any_mjcur==1
local coef_any_mjcur=r(N)
quietly count if tag_mjcur==1 & coef_all_mjcur==1
local coef_all_mjcur=r(N)
quietly count if tag_mjcur==1 & rank_mjcur==5
local rank_full_mjcur=r(N)
tabulate rank_mjcur if tag_mjcur==1, missing
quietly count if tag_mjcur==1 & fit_ok_mjcur==1
local full_mjcur=r(N)
quietly count if !missing(da_mjcur)
local obs_mjcur=r(N)
display as text "Modified Jones equation (7), current-year ROA: qualifying groups=`g_mjcur'; asreg any/all-row groups=`coef_any_mjcur'/`coef_all_mjcur'; native full-rank groups=`rank_full_mjcur'; retained groups/rows=`full_mjcur'/`obs_mjcur'"
drop tag_mjcur coef_complete_mjcur coef_any_mjcur coef_all_mjcur rank_mjcur fit_ok_mjcur
capture drop _fitted
capture drop _b_*
capture drop _Nobs _R2 _adjR2

drop fitgrp

* Performance matching is a post-fit difference, separate from equation (7).
* Match with replacement within SIC/year; candidate firms need the fitted residual and ROA.
* Sorting by ROA then GVKEY makes ties deterministic; equal-distance ties use the previous row.
egen n_j_cur_match=total(!missing(da_jones,roa_cur)), by(sic2 fyear)
egen n_j_lag_match=total(!missing(da_jones,roa_lag)), by(sic2 fyear)
egen n_mj_cur_match=total(!missing(da_mj,roa_cur)), by(sic2 fyear)
egen n_mj_lag_match=total(!missing(da_mj,roa_lag)), by(sic2 fyear)

gen byte bad_j_cur=missing(da_jones,roa_cur)
sort sic2 fyear bad_j_cur roa_cur gvkey
by sic2 fyear: gen double jcur_prev_roa=roa_cur[_n-1] if bad_j_cur==0
by sic2 fyear: gen double jcur_next_roa=roa_cur[_n+1] if bad_j_cur==0
by sic2 fyear: gen double jcur_prev_da=da_jones[_n-1] if bad_j_cur==0
by sic2 fyear: gen double jcur_next_da=da_jones[_n+1] if bad_j_cur==0
gen double jcur_prev_dist=abs(roa_cur-jcur_prev_roa) if bad_j_cur==0
gen double jcur_next_dist=abs(roa_cur-jcur_next_roa) if bad_j_cur==0
gen double da_jones_pm_cur=.
replace da_jones_pm_cur=da_jones-jcur_prev_da if bad_j_cur==0 & !missing(jcur_prev_dist) & (missing(jcur_next_dist) | jcur_prev_dist<=jcur_next_dist)
replace da_jones_pm_cur=da_jones-jcur_next_da if bad_j_cur==0 & !missing(jcur_next_dist) & (missing(jcur_prev_dist) | jcur_next_dist<jcur_prev_dist)
drop bad_j_cur jcur_prev_roa jcur_next_roa jcur_prev_da jcur_next_da jcur_prev_dist jcur_next_dist

gen byte bad_j_lag=missing(da_jones,roa_lag)
sort sic2 fyear bad_j_lag roa_lag gvkey
by sic2 fyear: gen double jlag_prev_roa=roa_lag[_n-1] if bad_j_lag==0
by sic2 fyear: gen double jlag_next_roa=roa_lag[_n+1] if bad_j_lag==0
by sic2 fyear: gen double jlag_prev_da=da_jones[_n-1] if bad_j_lag==0
by sic2 fyear: gen double jlag_next_da=da_jones[_n+1] if bad_j_lag==0
gen double jlag_prev_dist=abs(roa_lag-jlag_prev_roa) if bad_j_lag==0
gen double jlag_next_dist=abs(roa_lag-jlag_next_roa) if bad_j_lag==0
gen double da_jones_pm_lag=.
replace da_jones_pm_lag=da_jones-jlag_prev_da if bad_j_lag==0 & !missing(jlag_prev_dist) & (missing(jlag_next_dist) | jlag_prev_dist<=jlag_next_dist)
replace da_jones_pm_lag=da_jones-jlag_next_da if bad_j_lag==0 & !missing(jlag_next_dist) & (missing(jlag_prev_dist) | jlag_next_dist<jlag_prev_dist)
drop bad_j_lag jlag_prev_roa jlag_next_roa jlag_prev_da jlag_next_da jlag_prev_dist jlag_next_dist

gen byte bad_mj_cur=missing(da_mj,roa_cur)
sort sic2 fyear bad_mj_cur roa_cur gvkey
by sic2 fyear: gen double mjcur_prev_roa=roa_cur[_n-1] if bad_mj_cur==0
by sic2 fyear: gen double mjcur_next_roa=roa_cur[_n+1] if bad_mj_cur==0
by sic2 fyear: gen double mjcur_prev_da=da_mj[_n-1] if bad_mj_cur==0
by sic2 fyear: gen double mjcur_next_da=da_mj[_n+1] if bad_mj_cur==0
gen double mjcur_prev_dist=abs(roa_cur-mjcur_prev_roa) if bad_mj_cur==0
gen double mjcur_next_dist=abs(roa_cur-mjcur_next_roa) if bad_mj_cur==0
gen double da_mj_pm_cur=.
replace da_mj_pm_cur=da_mj-mjcur_prev_da if bad_mj_cur==0 & !missing(mjcur_prev_dist) & (missing(mjcur_next_dist) | mjcur_prev_dist<=mjcur_next_dist)
replace da_mj_pm_cur=da_mj-mjcur_next_da if bad_mj_cur==0 & !missing(mjcur_next_dist) & (missing(mjcur_prev_dist) | mjcur_next_dist<mjcur_prev_dist)
drop bad_mj_cur mjcur_prev_roa mjcur_next_roa mjcur_prev_da mjcur_next_da mjcur_prev_dist mjcur_next_dist

gen byte bad_mj_lag=missing(da_mj,roa_lag)
sort sic2 fyear bad_mj_lag roa_lag gvkey
by sic2 fyear: gen double mjlag_prev_roa=roa_lag[_n-1] if bad_mj_lag==0
by sic2 fyear: gen double mjlag_next_roa=roa_lag[_n+1] if bad_mj_lag==0
by sic2 fyear: gen double mjlag_prev_da=da_mj[_n-1] if bad_mj_lag==0
by sic2 fyear: gen double mjlag_next_da=da_mj[_n+1] if bad_mj_lag==0
gen double mjlag_prev_dist=abs(roa_lag-mjlag_prev_roa) if bad_mj_lag==0
gen double mjlag_next_dist=abs(roa_lag-mjlag_next_roa) if bad_mj_lag==0
gen double da_mj_pm_lag=.
replace da_mj_pm_lag=da_mj-mjlag_prev_da if bad_mj_lag==0 & !missing(mjlag_prev_dist) & (missing(mjlag_next_dist) | mjlag_prev_dist<=mjlag_next_dist)
replace da_mj_pm_lag=da_mj-mjlag_next_da if bad_mj_lag==0 & !missing(mjlag_next_dist) & (missing(mjlag_prev_dist) | mjlag_next_dist<mjlag_prev_dist)
drop bad_mj_lag mjlag_prev_roa mjlag_next_roa mjlag_prev_da mjlag_next_da mjlag_prev_dist mjlag_next_dist
sort sic2 fyear gvkey

* Count the model-specific potential matching pools and successful post-fit matches.
egen tag_match=tag(sic2 fyear)
quietly count if tag_match & n_j_cur_match>=2
local groups_j_cur=r(N)
quietly count if !missing(da_jones_pm_cur)
local matched_j_cur=r(N)
display as text "Jones current-ROA matching: eligible SIC/year groups=`groups_j_cur'; matched residuals=`matched_j_cur'"
quietly count if tag_match & n_j_lag_match>=2
local groups_j_lag=r(N)
quietly count if !missing(da_jones_pm_lag)
local matched_j_lag=r(N)
display as text "Jones prior-ROA matching: eligible SIC/year groups=`groups_j_lag'; matched residuals=`matched_j_lag'"
quietly count if tag_match & n_mj_cur_match>=2
local groups_mj_cur=r(N)
quietly count if !missing(da_mj_pm_cur)
local matched_mj_cur=r(N)
display as text "Modified-Jones current-ROA matching: eligible SIC/year groups=`groups_mj_cur'; matched residuals=`matched_mj_cur'"
quietly count if tag_match & n_mj_lag_match>=2
local groups_mj_lag=r(N)
quietly count if !missing(da_mj_pm_lag)
local matched_mj_lag=r(N)
display as text "Modified-Jones prior-ROA matching: eligible SIC/year groups=`groups_mj_lag'; matched residuals=`matched_mj_lag'"
drop tag_match

* Final common Table 1 sample applies the target-firm screens after fitting/matching.
egen match_cur_n = total(!missing(da_jones,da_mj,roa_cur)), by(sic2 fyear)
egen match_lag_n = total(!missing(da_jones,da_mj,roa_lag)), by(sic2 fyear)
gen byte sample_pre = !missing(ta,da_jones,da_mj,da_jlag,da_jcur,da_mjlag,da_mjcur, ///
    da_jones_pm_cur,da_jones_pm_lag,da_mj_pm_cur,da_mj_pm_lag, ///
    btm,ep,mve,sales_gr,ocf_at,roa_cur,roa_lag) & abs(ta)<=1
quietly count
local n_support=r(N)
quietly count if !missing(da_jones,da_mj,da_jlag,da_jcur,da_mjlag,da_mjcur)
local n_all=r(N)
gen byte sample_da_ta = !missing(ta,da_jones,da_mj,da_jlag,da_jcur,da_mjlag,da_mjcur) & abs(ta)<=1
quietly count if sample_da_ta==1
local n_ta=r(N)
quietly count if sample_da_ta==1 & !missing(btm,ep,mve,sales_gr,ocf_at)
local n_strata=r(N)
quietly count if sample_da_ta==1 & !missing(da_jones_pm_cur,da_jones_pm_lag,da_mj_pm_cur,da_mj_pm_lag)
local n_matched=r(N)
quietly count if sample_pre==1
local n_pre=r(N)
display as text "support=`n_support'; six-residual complete=`n_all'; |TA|<=1=`n_ta'; five-strata complete=`n_strata'; all four performance-matched measures=`n_matched'; final joint sample=`n_pre'"
keep if sample_pre==1
assert !missing(ta,da_jones,da_mj,da_jlag,da_jcur,da_mjlag,da_mjcur, ///
    da_jones_pm_cur,da_jones_pm_lag,da_mj_pm_cur,da_mj_pm_lag)
display as text "Final Table 1 sample MVE source by year"
tabulate fyear mve_src, missing
display as text "Final Table 1 sample OCF source by year"
tabulate fyear ocf_src, missing
display as text "Final Table 1 sample stratification-variable summaries"
tabstat btm ep mve sales_gr ocf_at, stat(n mean sd p25 p50 p75) c(s)
count

table fyear, statistic(count da_jones) statistic(count da_mj) ///
    statistic(count da_jlag) statistic(count da_jcur) ///
    statistic(count da_mjlag) statistic(count da_mjcur) ///
    statistic(count da_jones_pm_lag) statistic(count da_jones_pm_cur) ///
    statistic(count da_mj_pm_lag) statistic(count da_mj_pm_cur)

* The source reports all measures after 1st/99th-percentile winsorization.
foreach v of varlist $winsor_vars {
    quietly summarize `v', detail
    local cut1=r(p1)
    local cut99=r(p99)
    replace `v'=`cut1' if `v'<`cut1'
    replace `v'=`cut99' if `v'>`cut99'
}
foreach v of varlist ta $raw_da $matched_da {
    gen `v'_pct=100*`v'
}
label var ta_pct "Total accruals"
label var da_jones_pct "Jones model"
label var da_mj_pct "Modified-Jones model"
label var da_jlag_pct "Jones model with prior-year ROA"
label var da_jcur_pct "Jones model with current-year ROA"
label var da_mjlag_pct "Modified-Jones model with prior-year ROA"
label var da_mjcur_pct "Modified-Jones model with current-year ROA"
label var da_jones_pm_lag_pct "Performance-matched Jones model, prior-year ROA"
label var da_jones_pm_cur_pct "Performance-matched Jones model, current-year ROA"
label var da_mj_pm_lag_pct "Performance-matched Modified-Jones model, prior-year ROA"
label var da_mj_pm_cur_pct "Performance-matched Modified-Jones model, current-year ROA"

est clear
estpost tabstat $pct_vars, stat(N mean sd p25 p50 p75) c(s)
esttab using "tables/table1_panel_a.md", ///
    cells("count(fmt(%9.0f)) mean(fmt(%9.2f)) sd(fmt(%9.2f)) p25(fmt(%9.2f)) p50(fmt(%9.2f)) p75(fmt(%9.2f))") label replace
esttab using "tables/table1_panel_a.rtf", rtf ///
    cells("count(fmt(%9.0f)) mean(fmt(%9.2f)) sd(fmt(%9.2f)) p25(fmt(%9.2f)) p50(fmt(%9.2f)) p75(fmt(%9.2f))") label replace
esttab using "tables/table1_panel_a.csv", csv ///
    cells("count(fmt(%9.0f)) mean(fmt(%9.2f)) sd(fmt(%9.2f)) p25(fmt(%9.2f)) p50(fmt(%9.2f)) p75(fmt(%9.2f))") label replace
esttab using "tables/table1_panel_a.tex", tex ///
    cells("count(fmt(%9.0f)) mean(fmt(%9.2f)) sd(fmt(%9.2f)) p25(fmt(%9.2f)) p50(fmt(%9.2f)) p75(fmt(%9.2f))") label replace
est clear
exit, clear
