version 18
set more off

use "data/order_backlog_firm_years/reg.dta", clear
est clear

count if missing(earn_lead, sar, earn_t, bklg)
if r(N) != 0 {
    display as error "The declared common sample contains missing system inputs."
    exit 459
}
count
local commonN = r(N)
display as text "Common Table 2 sample N = " `commonN'

mlexp (lnnormalden(earn_lead, {omega0=0} + {omega1=0}*earn_t + {omega2=0}*bklg, exp({lnsige=0})) ///
       + lnnormalden(sar, {beta0=0} + {beta1=1}*(earn_lead - {omega0} - {omega1star=0}*earn_t - {omega2star=0}*bklg), ///
                     exp({lnsigsar=0}))), variables(earn_lead sar earn_t bklg)
if e(converged) != 1 {
    display as error "Unrestricted independent-error Gaussian likelihood did not converge."
    exit 498
}
estimates store unrestricted
local fitN = e(N)
if `fitN' != `commonN' {
    display as error "Unrestricted likelihood changed the common sample."
    exit 459
}
scalar ll_unrestricted = e(ll)

mlexp (lnnormalden(earn_lead, {omega0=0} + {omega1=0}*earn_t + {omega2=0}*bklg, exp({lnsige=0})) ///
       + lnnormalden(sar, {beta0=0} + {beta1=1}*(earn_lead - {omega0} - {omega1}*earn_t - {omega2star=0}*bklg), ///
                     exp({lnsigsar=0}))), variables(earn_lead sar earn_t bklg)
if e(converged) != 1 {
    display as error "The omega1 efficiency restriction did not converge."
    exit 498
}
estimates store constrained_omega1
if e(N) != `commonN' {
    display as error "The omega1 restriction changed the common sample."
    exit 459
}
lrtest unrestricted constrained_omega1, df(1)
scalar LR_omega1 = r(chi2)
scalar p_omega1 = r(p)

mlexp (lnnormalden(earn_lead, {omega0=0} + {omega1=0}*earn_t + {omega2=0}*bklg, exp({lnsige=0})) ///
       + lnnormalden(sar, {beta0=0} + {beta1=1}*(earn_lead - {omega0} - {omega1star=0}*earn_t - {omega2}*bklg), ///
                     exp({lnsigsar=0}))), variables(earn_lead sar earn_t bklg)
if e(converged) != 1 {
    display as error "The omega2 efficiency restriction did not converge."
    exit 498
}
estimates store constrained_omega2
if e(N) != `commonN' {
    display as error "The omega2 restriction changed the common sample."
    exit 459
}
lrtest unrestricted constrained_omega2, df(1)
scalar LR_omega2 = r(chi2)
scalar p_omega2 = r(p)

display as text "Independent-error conditional Gaussian likelihoods: unrestricted=" %12.3f scalar(ll_unrestricted)

display as text "Native likelihood-ratio restrictions each have one degree of freedom."

regress earn_lead earn_t bklg
scalar ols_omega0 = _b[_cons]
scalar ols_omega1 = _b[earn_t]
scalar ols_omega2 = _b[bklg]
scalar ols_sigma_forecast = sqrt(e(rss)/e(N))

regress sar earn_lead earn_t bklg
scalar ols_reduced_intercept = _b[_cons]
scalar ols_beta1 = _b[earn_lead]
if abs(scalar(ols_beta1)) < 1e-10 {
    display as error "Conditional return coefficient is zero; structural reparameterization is undefined."
    exit 459
}
scalar ols_omega1star = -_b[earn_t]/_b[earn_lead]
scalar ols_omega2star = -_b[bklg]/_b[earn_lead]
scalar ols_beta0 = _b[_cons] + _b[earn_lead]*scalar(ols_omega0)
scalar ols_sigma_return = sqrt(e(rss)/e(N))

estimates restore unrestricted
scalar gap_omega0 = _b[/omega0] - scalar(ols_omega0)
scalar gap_omega1 = _b[/omega1] - scalar(ols_omega1)
scalar gap_omega2 = _b[/omega2] - scalar(ols_omega2)
scalar gap_beta0 = _b[/beta0] - scalar(ols_beta0)
scalar gap_beta1 = _b[/beta1] - scalar(ols_beta1)
scalar gap_omega1star = _b[/omega1star] - scalar(ols_omega1star)
scalar gap_omega2star = _b[/omega2star] - scalar(ols_omega2star)
scalar gap_sigma_forecast = exp(_b[/lnsige]) - scalar(ols_sigma_forecast)
scalar gap_sigma_return = exp(_b[/lnsigsar]) - scalar(ols_sigma_return)
scalar gap_abs = max(abs(scalar(gap_omega0)), abs(scalar(gap_omega1)), abs(scalar(gap_omega2)), ///
    abs(scalar(gap_beta0)), abs(scalar(gap_beta1)), abs(scalar(gap_omega1star)), ///
    abs(scalar(gap_omega2star)), abs(scalar(gap_sigma_forecast)), abs(scalar(gap_sigma_return)))
scalar gap_rel = max(abs(scalar(gap_omega0))/(1+abs(scalar(ols_omega0))), ///
    abs(scalar(gap_omega1))/(1+abs(scalar(ols_omega1))), ///
    abs(scalar(gap_omega2))/(1+abs(scalar(ols_omega2))), ///
    abs(scalar(gap_beta0))/(1+abs(scalar(ols_beta0))), ///
    abs(scalar(gap_beta1))/(1+abs(scalar(ols_beta1))), ///
    abs(scalar(gap_omega1star))/(1+abs(scalar(ols_omega1star))), ///
    abs(scalar(gap_omega2star))/(1+abs(scalar(ols_omega2star))), ///
    abs(scalar(gap_sigma_forecast))/(1+abs(scalar(ols_sigma_forecast))), ///
    abs(scalar(gap_sigma_return))/(1+abs(scalar(ols_sigma_return))))
display as text "Unrestricted structural-to-OLS mapping: max absolute gap = " %12.8g scalar(gap_abs) ///
    "; max scale-relative gap = " %12.8g scalar(gap_rel)
display as text "Estimated positive error SDs: forecast=" %10.6g exp(_b[/lnsige]) ///
    " return=" %10.6g exp(_b[/lnsigsar])

estadd scalar LR_omega1 = scalar(LR_omega1)
estadd scalar p_omega1 = scalar(p_omega1)
estadd scalar LR_omega2 = scalar(LR_omega2)
estadd scalar p_omega2 = scalar(p_omega2)
estadd scalar sigma_forecast = exp(_b[/lnsige])
estadd scalar sigma_return = exp(_b[/lnsigsar])
est store m_table2

esttab m_table2 using "tables/table2_forecasting_equation.md", ///
    cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) ///
    keep(omega0:_cons omega1:_cons omega2:_cons) ///
    coeflabels(omega0:_cons "omega0 (shared intercept)" omega1:_cons "omega1" omega2:_cons "omega2 (order backlog)") ///
    stats(N ll LR_omega1 p_omega1 LR_omega2 p_omega2 sigma_forecast sigma_return, ///
    labels("N" "Log likelihood" "LR: omega1 = omega1*" "p-value" ///
           "LR: omega2 = omega2*" "p-value" "Forecast error SD" "Return error SD") ///
    fmt(0 3 2 4 2 4 3 3)) eqlabels(none) replace label
esttab m_table2 using "tables/table2_forecasting_equation.rtf", ///
    cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) ///
    keep(omega0:_cons omega1:_cons omega2:_cons) ///
    coeflabels(omega0:_cons "omega0 (shared intercept)" omega1:_cons "omega1" omega2:_cons "omega2 (order backlog)") ///
    stats(N ll LR_omega1 p_omega1 LR_omega2 p_omega2 sigma_forecast sigma_return, ///
    labels("N" "Log likelihood" "LR: omega1 = omega1*" "p-value" ///
           "LR: omega2 = omega2*" "p-value" "Forecast error SD" "Return error SD") ///
    fmt(0 3 2 4 2 4 3 3)) eqlabels(none) replace label
esttab m_table2 using "tables/table2_forecasting_equation.csv", ///
    cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) ///
    keep(omega0:_cons omega1:_cons omega2:_cons) ///
    coeflabels(omega0:_cons "omega0 (shared intercept)" omega1:_cons "omega1" omega2:_cons "omega2 (order backlog)") ///
    stats(N ll LR_omega1 p_omega1 LR_omega2 p_omega2 sigma_forecast sigma_return, ///
    labels("N" "Log likelihood" "LR: omega1 = omega1*" "p-value" ///
           "LR: omega2 = omega2*" "p-value" "Forecast error SD" "Return error SD") ///
    fmt(0 3 2 4 2 4 3 3)) eqlabels(none) replace label
esttab m_table2 using "tables/table2_forecasting_equation.tex", ///
    cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) ///
    keep(omega0:_cons omega1:_cons omega2:_cons) ///
    coeflabels(omega0:_cons "omega0 (shared intercept)" omega1:_cons "omega1" omega2:_cons "omega2 (order backlog)") ///
    stats(N ll LR_omega1 p_omega1 LR_omega2 p_omega2 sigma_forecast sigma_return, ///
    labels("N" "Log likelihood" "LR: omega1 = omega1*" "p-value" ///
           "LR: omega2 = omega2*" "p-value" "Forecast error SD" "Return error SD") ///
    fmt(0 3 2 4 2 4 3 3)) eqlabels(none) replace label

esttab m_table2 using "tables/table2_returns_equation.md", ///
    cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) ///
    keep(omega0:_cons omega1star:_cons omega2star:_cons beta0:_cons beta1:_cons) ///
    coeflabels(omega0:_cons "omega0 (shared intercept)" omega1star:_cons "omega1*" ///
               omega2star:_cons "omega2* (order backlog)" beta0:_cons "beta0" beta1:_cons "beta1") ///
    stats(N ll LR_omega1 p_omega1 LR_omega2 p_omega2 sigma_forecast sigma_return, ///
    labels("N" "Log likelihood" "LR: omega1 = omega1*" "p-value" ///
           "LR: omega2 = omega2*" "p-value" "Forecast error SD" "Return error SD") ///
    fmt(0 3 2 4 2 4 3 3)) eqlabels(none) replace label
esttab m_table2 using "tables/table2_returns_equation.rtf", ///
    cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) ///
    keep(omega0:_cons omega1star:_cons omega2star:_cons beta0:_cons beta1:_cons) ///
    coeflabels(omega0:_cons "omega0 (shared intercept)" omega1star:_cons "omega1*" ///
               omega2star:_cons "omega2* (order backlog)" beta0:_cons "beta0" beta1:_cons "beta1") ///
    stats(N ll LR_omega1 p_omega1 LR_omega2 p_omega2 sigma_forecast sigma_return, ///
    labels("N" "Log likelihood" "LR: omega1 = omega1*" "p-value" ///
           "LR: omega2 = omega2*" "p-value" "Forecast error SD" "Return error SD") ///
    fmt(0 3 2 4 2 4 3 3)) eqlabels(none) replace label
esttab m_table2 using "tables/table2_returns_equation.csv", ///
    cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) ///
    keep(omega0:_cons omega1star:_cons omega2star:_cons beta0:_cons beta1:_cons) ///
    coeflabels(omega0:_cons "omega0 (shared intercept)" omega1star:_cons "omega1*" ///
               omega2star:_cons "omega2* (order backlog)" beta0:_cons "beta0" beta1:_cons "beta1") ///
    stats(N ll LR_omega1 p_omega1 LR_omega2 p_omega2 sigma_forecast sigma_return, ///
    labels("N" "Log likelihood" "LR: omega1 = omega1*" "p-value" ///
           "LR: omega2 = omega2*" "p-value" "Forecast error SD" "Return error SD") ///
    fmt(0 3 2 4 2 4 3 3)) eqlabels(none) replace label
esttab m_table2 using "tables/table2_returns_equation.tex", ///
    cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) ///
    keep(omega0:_cons omega1star:_cons omega2star:_cons beta0:_cons beta1:_cons) ///
    coeflabels(omega0:_cons "omega0 (shared intercept)" omega1star:_cons "omega1*" ///
               omega2star:_cons "omega2* (order backlog)" beta0:_cons "beta0" beta1:_cons "beta1") ///
    stats(N ll LR_omega1 p_omega1 LR_omega2 p_omega2 sigma_forecast sigma_return, ///
    labels("N" "Log likelihood" "LR: omega1 = omega1*" "p-value" ///
           "LR: omega2 = omega2*" "p-value" "Forecast error SD" "Return error SD") ///
    fmt(0 3 2 4 2 4 3 3)) eqlabels(none) replace label
est clear
exit, clear
