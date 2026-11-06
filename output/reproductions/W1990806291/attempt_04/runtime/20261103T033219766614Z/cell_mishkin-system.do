version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
use "data/reg.dta", clear
est clear

count if table2 == 1
local commonN = r(N)
count if table2 == 1 & !missing(earn_lead, sizeajr_lead, cfo_sc, nac, abnac)
if r(N) != `commonN' {
    display as error "Table 2 sample flag includes missing system inputs."
    exit 459
}
display as text "Common Table 2 sample N = " `commonN'

mlexp (lnnormalden(earn_lead, {g0=0} + {g1=0}*cfo_sc + {g2=0}*nac + {g3=0}*abnac, exp({lnsv=0})) ///
       + lnnormalden(sizeajr_lead, {alpha=0} + {beta=1}*(earn_lead - {g0} - {gs1=0}*cfo_sc - {gs2=0}*nac - {gs3=0}*abnac), exp({lnsr=0}))) ///
       if table2 == 1, variables(earn_lead sizeajr_lead cfo_sc nac abnac)
estimates store unrestricted
local fitN = e(N)
if `fitN' != `commonN' {
    display as error "Unrestricted conditional likelihood changed the common sample."
    exit 459
}
scalar ll_unrestricted = e(ll)

mlexp (lnnormalden(earn_lead, {g0=0} + {g1=0}*cfo_sc + {g2=0}*nac + {g3=0}*abnac, exp({lnsv=0})) ///
       + lnnormalden(sizeajr_lead, {alpha=0} + {beta=1}*(earn_lead - {g0} - {g1}*cfo_sc - {gs2=0}*nac - {gs3=0}*abnac), exp({lnsr=0}))) ///
       if table2 == 1, variables(earn_lead sizeajr_lead cfo_sc nac abnac)
estimates store constrained_cfo
local fitN = e(N)
if `fitN' != `commonN' {
    display as error "CFO restriction changed the common sample."
    exit 459
}
scalar ll_cfo = e(ll)
lrtest unrestricted constrained_cfo, df(1)
scalar LR_CFO = r(chi2)
scalar p_CFO = r(p)

mlexp (lnnormalden(earn_lead, {g0=0} + {g1=0}*cfo_sc + {g2=0}*nac + {g3=0}*abnac, exp({lnsv=0})) ///
       + lnnormalden(sizeajr_lead, {alpha=0} + {beta=1}*(earn_lead - {g0} - {gs1=0}*cfo_sc - {g2}*nac - {gs3=0}*abnac), exp({lnsr=0}))) ///
       if table2 == 1, variables(earn_lead sizeajr_lead cfo_sc nac abnac)
estimates store constrained_nac
local fitN = e(N)
if `fitN' != `commonN' {
    display as error "NAC restriction changed the common sample."
    exit 459
}
scalar ll_nac = e(ll)
lrtest unrestricted constrained_nac, df(1)
scalar LR_NAC = r(chi2)
scalar p_NAC = r(p)

mlexp (lnnormalden(earn_lead, {g0=0} + {g1=0}*cfo_sc + {g2=0}*nac + {g3=0}*abnac, exp({lnsv=0})) ///
       + lnnormalden(sizeajr_lead, {alpha=0} + {beta=1}*(earn_lead - {g0} - {gs1=0}*cfo_sc - {gs2=0}*nac - {g3}*abnac), exp({lnsr=0}))) ///
       if table2 == 1, variables(earn_lead sizeajr_lead cfo_sc nac abnac)
estimates store constrained_abnac
local fitN = e(N)
if `fitN' != `commonN' {
    display as error "ABNAC restriction changed the common sample."
    exit 459
}
scalar ll_abnac = e(ll)
lrtest unrestricted constrained_abnac, df(1)
scalar LR_ABNAC = r(chi2)
scalar p_ABNAC = r(p)

mlexp (lnnormalden(earn_lead, {g0=0} + {g1=0}*cfo_sc + {g23=0}*nac + {g23}*abnac, exp({lnsv=0})) ///
       + lnnormalden(sizeajr_lead, {alpha=0} + {beta=1}*(earn_lead - {g0} - {gs1=0}*cfo_sc - {gs23=0}*nac - {gs23}*abnac), exp({lnsr=0}))) ///
       if table2 == 1, variables(earn_lead sizeajr_lead cfo_sc nac abnac)
estimates store constrained_nac_abnac
local fitN = e(N)
if `fitN' != `commonN' {
    display as error "Joint NAC/ABNAC restriction changed the common sample."
    exit 459
}
scalar ll_nac_abnac = e(ll)
lrtest unrestricted constrained_nac_abnac, df(2)
scalar LR_NAC_ABNAC = r(chi2)
scalar p_NAC_ABNAC = r(p)

mlexp (lnnormalden(earn_lead, {g0=0} + {g1=0}*cfo_sc + {g2=0}*nac + {g3=0}*abnac, exp({lnsv=0})) ///
       + lnnormalden(sizeajr_lead, {alpha=0} + {beta=1}*(earn_lead - {g0} - {g1}*cfo_sc - {g2}*nac - {g3}*abnac), exp({lnsr=0}))) ///
       if table2 == 1, variables(earn_lead sizeajr_lead cfo_sc nac abnac)
estimates store constrained_all
local fitN = e(N)
if `fitN' != `commonN' {
    display as error "All-components restriction changed the common sample."
    exit 459
}
scalar ll_all = e(ll)
lrtest unrestricted constrained_all, df(3)
scalar LR_ALL = r(chi2)
scalar p_ALL = r(p)

display as text "Conditional Gaussian likelihoods: unrestricted=" %12.3f scalar(ll_unrestricted) ///
    " CFO=" %12.3f scalar(ll_cfo) " NAC=" %12.3f scalar(ll_nac) ///
    " ABNAC=" %12.3f scalar(ll_abnac) " NAC/ABNAC=" %12.3f scalar(ll_nac_abnac) ///
    " all=" %12.3f scalar(ll_all)

estimates restore unrestricted
nlcom (forecast_sigma: exp(_b[/lnsv])) (return_sigma: exp(_b[/lnsr]))

regress earn_lead cfo_sc nac abnac if table2 == 1
scalar ols_g0 = _b[_cons]
scalar ols_g1 = _b[cfo_sc]
scalar ols_g2 = _b[nac]
scalar ols_g3 = _b[abnac]
estimates restore unrestricted
scalar gap_g0 = _b[/g0] - scalar(ols_g0)
scalar gap_g1 = _b[/g1] - scalar(ols_g1)
scalar gap_g2 = _b[/g2] - scalar(ols_g2)
scalar gap_g3 = _b[/g3] - scalar(ols_g3)
display as text "Forecast-equation OLS mapping max absolute gap = " %12.9g ///
    max(abs(scalar(gap_g0)), abs(scalar(gap_g1)), abs(scalar(gap_g2)), abs(scalar(gap_g3)))

regress sizeajr_lead earn_lead cfo_sc nac abnac if table2 == 1
scalar ols_r0 = _b[_cons]
scalar ols_rearn = _b[earn_lead]
scalar ols_rcfo = _b[cfo_sc]
scalar ols_rnac = _b[nac]
scalar ols_rabnac = _b[abnac]
estimates restore unrestricted
scalar gap_r0 = (_b[/alpha] - _b[/beta]*_b[/g0]) - scalar(ols_r0)
scalar gap_rearn = _b[/beta] - scalar(ols_rearn)
scalar gap_rcfo = (-_b[/beta]*_b[/gs1]) - scalar(ols_rcfo)
scalar gap_rnac = (-_b[/beta]*_b[/gs2]) - scalar(ols_rnac)
scalar gap_rabnac = (-_b[/beta]*_b[/gs3]) - scalar(ols_rabnac)
display as text "Return-equation OLS reparameterization max absolute gap = " %12.9g ///
    max(abs(scalar(gap_r0)), abs(scalar(gap_rearn)), abs(scalar(gap_rcfo)), ///
        abs(scalar(gap_rnac)), abs(scalar(gap_rabnac)))
nlcom (return_intercept: _b[/alpha] - _b[/beta]*_b[/g0]) ///
      (return_earnings: _b[/beta]) ///
      (return_cfo: -_b[/beta]*_b[/gs1]) ///
      (return_nac: -_b[/beta]*_b[/gs2]) ///
      (return_abnac: -_b[/beta]*_b[/gs3])

display as text "LR restriction degrees of freedom are 1, 1, 1, 2, and 3, respectively."

estimates restore unrestricted
estadd scalar LR_CFO = scalar(LR_CFO)
estadd scalar p_CFO = scalar(p_CFO)
estadd scalar LR_NAC = scalar(LR_NAC)
estadd scalar p_NAC = scalar(p_NAC)
estadd scalar LR_ABNAC = scalar(LR_ABNAC)
estadd scalar p_ABNAC = scalar(p_ABNAC)
estadd scalar LR_NAC_ABNAC = scalar(LR_NAC_ABNAC)
estadd scalar p_NAC_ABNAC = scalar(p_NAC_ABNAC)
estadd scalar LR_ALL = scalar(LR_ALL)
estadd scalar p_ALL = scalar(p_ALL)
est store m1

esttab m1 using "tables/table2_mishkin.md", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(g1:_cons g2:_cons g3:_cons gs1:_cons gs2:_cons gs3:_cons) coeflabels(g1:_cons "Forecast CFO" g2:_cons "Forecast NAC" g3:_cons "Forecast ABNAC" gs1:_cons "Valuation CFO" gs2:_cons "Valuation NAC" gs3:_cons "Valuation ABNAC") stats(N ll LR_CFO p_CFO LR_NAC p_NAC LR_ABNAC p_ABNAC LR_NAC_ABNAC p_NAC_ABNAC LR_ALL p_ALL, labels("N" "Unrestricted log likelihood" "LR: CFO, chi2(1)" "p-value" "LR: NAC, chi2(1)" "p-value" "LR: ABNAC, chi2(1)" "p-value" "LR: NAC and ABNAC, chi2(2)" "p-value" "LR: all components, chi2(3)" "p-value") fmt(0 3 2 4 2 4 2 4 2 4 2 4)) replace label
esttab m1 using "tables/table2_mishkin.rtf", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(g1:_cons g2:_cons g3:_cons gs1:_cons gs2:_cons gs3:_cons) coeflabels(g1:_cons "Forecast CFO" g2:_cons "Forecast NAC" g3:_cons "Forecast ABNAC" gs1:_cons "Valuation CFO" gs2:_cons "Valuation NAC" gs3:_cons "Valuation ABNAC") stats(N ll LR_CFO p_CFO LR_NAC p_NAC LR_ABNAC p_ABNAC LR_NAC_ABNAC p_NAC_ABNAC LR_ALL p_ALL, labels("N" "Unrestricted log likelihood" "LR: CFO, chi2(1)" "p-value" "LR: NAC, chi2(1)" "p-value" "LR: ABNAC, chi2(1)" "p-value" "LR: NAC and ABNAC, chi2(2)" "p-value" "LR: all components, chi2(3)" "p-value") fmt(0 3 2 4 2 4 2 4 2 4 2 4)) replace label
esttab m1 using "tables/table2_mishkin.csv", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(g1:_cons g2:_cons g3:_cons gs1:_cons gs2:_cons gs3:_cons) coeflabels(g1:_cons "Forecast CFO" g2:_cons "Forecast NAC" g3:_cons "Forecast ABNAC" gs1:_cons "Valuation CFO" gs2:_cons "Valuation NAC" gs3:_cons "Valuation ABNAC") stats(N ll LR_CFO p_CFO LR_NAC p_NAC LR_ABNAC p_ABNAC LR_NAC_ABNAC p_NAC_ABNAC LR_ALL p_ALL, labels("N" "Unrestricted log likelihood" "LR: CFO, chi2(1)" "p-value" "LR: NAC, chi2(1)" "p-value" "LR: ABNAC, chi2(1)" "p-value" "LR: NAC and ABNAC, chi2(2)" "p-value" "LR: all components, chi2(3)" "p-value") fmt(0 3 2 4 2 4 2 4 2 4 2 4)) replace label
esttab m1 using "tables/table2_mishkin.tex", cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(g1:_cons g2:_cons g3:_cons gs1:_cons gs2:_cons gs3:_cons) coeflabels(g1:_cons "Forecast CFO" g2:_cons "Forecast NAC" g3:_cons "Forecast ABNAC" gs1:_cons "Valuation CFO" gs2:_cons "Valuation NAC" gs3:_cons "Valuation ABNAC") stats(N ll LR_CFO p_CFO LR_NAC p_NAC LR_ABNAC p_ABNAC LR_NAC_ABNAC p_NAC_ABNAC LR_ALL p_ALL, labels("N" "Unrestricted log likelihood" "LR: CFO, chi2(1)" "p-value" "LR: NAC, chi2(1)" "p-value" "LR: ABNAC, chi2(1)" "p-value" "LR: NAC and ABNAC, chi2(2)" "p-value" "LR: all components, chi2(3)" "p-value") fmt(0 3 2 4 2 4 2 4 2 4 2 4)) replace label
est clear
exit, clear
