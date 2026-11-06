version 18
set more off

global fe "forecast_error"
global ar "abnormal_return"
global growth "forecast_growth"

use "data/equity_offerings/reg.dta", clear

est clear
mlexp (lnnormalden($fe, {a0=0} + {a1=0}*$growth, exp({lnsfe=0})) ///
       + lnnormalden($ar, {b1=1}*($fe - {a0star=0} - {a1star=0}*$growth), ///
                     exp({lnsar=0}))), variables($fe $ar $growth)
estimates store unrestricted

mlexp (lnnormalden($fe, {a0=0} + {a1=0}*$growth, exp({lnsfe=0})) ///
       + lnnormalden($ar, {b1=1}*($fe - {a0} - {a1}*$growth), ///
                     exp({lnsar=0}))), variables($fe $ar $growth)
estimates store market_efficiency
lrtest unrestricted market_efficiency
local lr_me_chi2 = r(chi2)
local lr_me_p = r(p)

mlexp (lnnormalden($fe, {a0=0} + {a1=0}*$growth, exp({lnsfe=0})) ///
       + lnnormalden($ar, {b1=1}*$fe, exp({lnsar=0}))), variables($fe $ar $growth)
estimates store naive_expectations
lrtest unrestricted naive_expectations
local lr_naive_chi2 = r(chi2)
local lr_naive_p = r(p)

estimates restore unrestricted
regress $fe $growth
estimates restore unrestricted
nlcom (ols_intercept: -_b[/b1]*_b[/a0star]) ///
      (ols_growth_slope: -_b[/b1]*_b[/a1star]) ///
      (ols_forecast_error_slope: _b[/b1])
regress $ar $fe $growth
estimates restore unrestricted
estadd scalar lr_me_chi2 = `lr_me_chi2'
estadd scalar lr_me_p = `lr_me_p'
estadd scalar lr_naive_chi2 = `lr_naive_chi2'
estadd scalar lr_naive_p = `lr_naive_p'

esttab unrestricted using "tables/table7_joint_system.md", ///
    cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) ///
    keep(a0:_cons a1:_cons b1:_cons a0star:_cons a1star:_cons) ///
    stats(N ll lr_me_chi2 lr_me_p lr_naive_chi2 lr_naive_p, ///
    labels("Observations" "Log likelihood" "Market-efficiency LR chi-square" ///
           "Market-efficiency LR p-value" "Naive-expectations LR chi-square" ///
           "Naive-expectations LR p-value") fmt(0 3 3 3 3 3)) replace label
esttab unrestricted using "tables/table7_joint_system.rtf", ///
    cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) ///
    keep(a0:_cons a1:_cons b1:_cons a0star:_cons a1star:_cons) ///
    stats(N ll lr_me_chi2 lr_me_p lr_naive_chi2 lr_naive_p, ///
    labels("Observations" "Log likelihood" "Market-efficiency LR chi-square" ///
           "Market-efficiency LR p-value" "Naive-expectations LR chi-square" ///
           "Naive-expectations LR p-value") fmt(0 3 3 3 3 3)) replace label
esttab unrestricted using "tables/table7_joint_system.csv", ///
    cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) ///
    keep(a0:_cons a1:_cons b1:_cons a0star:_cons a1star:_cons) ///
    stats(N ll lr_me_chi2 lr_me_p lr_naive_chi2 lr_naive_p, ///
    labels("Observations" "Log likelihood" "Market-efficiency LR chi-square" ///
           "Market-efficiency LR p-value" "Naive-expectations LR chi-square" ///
           "Naive-expectations LR p-value") fmt(0 3 3 3 3 3)) replace label
esttab unrestricted using "tables/table7_joint_system.tex", ///
    cells(b(star fmt(3)) p(par)) starlevels(* 0.1 ** 0.05 *** 0.01) ///
    keep(a0:_cons a1:_cons b1:_cons a0star:_cons a1star:_cons) ///
    stats(N ll lr_me_chi2 lr_me_p lr_naive_chi2 lr_naive_p, ///
    labels("Observations" "Log likelihood" "Market-efficiency LR chi-square" ///
           "Market-efficiency LR p-value" "Naive-expectations LR chi-square" ///
           "Naive-expectations LR p-value") fmt(0 3 3 3 3 3)) replace label
est clear
exit, clear
