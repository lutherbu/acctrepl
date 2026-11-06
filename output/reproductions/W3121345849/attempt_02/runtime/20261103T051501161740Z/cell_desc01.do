version 18
set more off
adopath ++ "../../../output/reproduction_runs/ado"
use "data/rolling_fit_panel/reg.dta", clear
capture mkdir "tables"
est clear
isid gvkey avyear

global x "hvzat hvzdvc dd hvze nege hvzac"
keep gvkey avyear hvzy1 hvzy2 hvzy3 $x
label var hvzat "A: total assets (USD millions)"
label var hvzdvc "D: dividends (USD millions)"
label var dd "DD: positive dividend indicator"
label var hvze "E: current earnings (USD millions)"
label var nege "NegE: negative earnings indicator"
label var hvzac "AC: accounting changes (USD millions)"
forvalues h=1/3 {
    preserve
    local firstfit=1969
    local winlo=`firstfit'-9-`h'
    local winhi=2012-`h'
    gen double y=hvzy`h'
    label var y "Future earnings, h=`h' (USD millions)"
    egen byte missct=rowmiss(y $x)
    gen byte inunion=0
    forvalues fit=`firstfit'/2012 {
        replace inunion=1 if inrange(avyear,`fit'-9-`h',`fit'-`h')
    }
    keep if inunion & missct==0
    isid gvkey avyear
    count
    local nunion=r(N)
    display "HVZ horizon " `h' " complete-case window union: base AVYEAR " `winlo' "-" `winhi' "; unique rows=" `nunion'
    estpost tabstat y $x, statistics(n mean sd p1 p99) columns(statistics)
    estadd scalar union_rows=`nunion', replace
    est store desc_h`h'
    restore
}
esttab desc_h1 desc_h2 desc_h3 using "tables/hvz_input_union.md", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p1(fmt(3)) p99(fmt(3))") nostar stats(union_rows, fmt(0) labels("Unique rows in window union")) replace label mtitles("h=1" "h=2" "h=3") addnotes("Sample is unique GVKEY-by-availability-year input rows appearing in at least one qualifying annual training window for the model and horizon." "Rows are complete for the model outcome and regressors; N counts unique inputs, not expanded/repeated fit rows or the annual-fit coefficient summary." "Input statistics reflect the annual 1/99 winsorized construction; union endpoints and counts are logged.")
esttab desc_h1 desc_h2 desc_h3 using "tables/hvz_input_union.rtf", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p1(fmt(3)) p99(fmt(3))") nostar stats(union_rows, fmt(0) labels("Unique rows in window union")) replace label mtitles("h=1" "h=2" "h=3") addnotes("Sample is unique GVKEY-by-availability-year input rows appearing in at least one qualifying annual training window for the model and horizon." "Rows are complete for the model outcome and regressors; N counts unique inputs, not expanded/repeated fit rows or the annual-fit coefficient summary." "Input statistics reflect the annual 1/99 winsorized construction; union endpoints and counts are logged.")
esttab desc_h1 desc_h2 desc_h3 using "tables/hvz_input_union.csv", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p1(fmt(3)) p99(fmt(3))") nostar stats(union_rows, fmt(0) labels("Unique rows in window union")) replace label mtitles("h=1" "h=2" "h=3") addnotes("Sample is unique GVKEY-by-availability-year input rows appearing in at least one qualifying annual training window for the model and horizon." "Rows are complete for the model outcome and regressors; N counts unique inputs, not expanded/repeated fit rows or the annual-fit coefficient summary." "Input statistics reflect the annual 1/99 winsorized construction; union endpoints and counts are logged.")
esttab desc_h1 desc_h2 desc_h3 using "tables/hvz_input_union.tex", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p1(fmt(3)) p99(fmt(3))") nostar stats(union_rows, fmt(0) labels("Unique rows in window union")) replace label mtitles("h=1" "h=2" "h=3") addnotes("Sample is unique GVKEY-by-availability-year input rows appearing in at least one qualifying annual training window for the model and horizon." "Rows are complete for the model outcome and regressors; N counts unique inputs, not expanded/repeated fit rows or the annual-fit coefficient summary." "Input statistics reflect the annual 1/99 winsorized construction; union endpoints and counts are logged.")
est clear

use "data/rolling_fit_panel/reg.dta", clear
isid gvkey avyear
global x "nege epx epnegx"
keep gvkey avyear eppy1 eppy2 eppy3 $x
label var nege "NegE: negative earnings indicator"
label var epx "E: current earnings per share (USD)"
label var epnegx "NegE x E: interaction"
forvalues h=1/3 {
    preserve
    local firstfit=1969
    local winlo=`firstfit'-9-`h'
    local winhi=2012-`h'
    gen double y=eppy`h'
    label var y "Future earnings per share, h=`h' (USD)"
    egen byte missct=rowmiss(y $x)
    gen byte inunion=0
    forvalues fit=`firstfit'/2012 {
        replace inunion=1 if inrange(avyear,`fit'-9-`h',`fit'-`h')
    }
    keep if inunion & missct==0
    isid gvkey avyear
    count
    local nunion=r(N)
    display "EP horizon " `h' " complete-case window union: base AVYEAR " `winlo' "-" `winhi' "; unique rows=" `nunion'
    estpost tabstat y $x, statistics(n mean sd p1 p99) columns(statistics)
    estadd scalar union_rows=`nunion', replace
    est store desc_h`h'
    restore
}
esttab desc_h1 desc_h2 desc_h3 using "tables/ep_input_union.md", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p1(fmt(3)) p99(fmt(3))") nostar stats(union_rows, fmt(0) labels("Unique rows in window union")) replace label mtitles("h=1" "h=2" "h=3") addnotes("Sample is unique GVKEY-by-availability-year input rows appearing in at least one qualifying annual training window for the model and horizon." "Rows are complete for the model outcome and regressors; N counts unique inputs, not expanded/repeated fit rows or the annual-fit coefficient summary." "Input statistics reflect the annual 1/99 winsorized construction; union endpoints and counts are logged.")
esttab desc_h1 desc_h2 desc_h3 using "tables/ep_input_union.rtf", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p1(fmt(3)) p99(fmt(3))") nostar stats(union_rows, fmt(0) labels("Unique rows in window union")) replace label mtitles("h=1" "h=2" "h=3") addnotes("Sample is unique GVKEY-by-availability-year input rows appearing in at least one qualifying annual training window for the model and horizon." "Rows are complete for the model outcome and regressors; N counts unique inputs, not expanded/repeated fit rows or the annual-fit coefficient summary." "Input statistics reflect the annual 1/99 winsorized construction; union endpoints and counts are logged.")
esttab desc_h1 desc_h2 desc_h3 using "tables/ep_input_union.csv", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p1(fmt(3)) p99(fmt(3))") nostar stats(union_rows, fmt(0) labels("Unique rows in window union")) replace label mtitles("h=1" "h=2" "h=3") addnotes("Sample is unique GVKEY-by-availability-year input rows appearing in at least one qualifying annual training window for the model and horizon." "Rows are complete for the model outcome and regressors; N counts unique inputs, not expanded/repeated fit rows or the annual-fit coefficient summary." "Input statistics reflect the annual 1/99 winsorized construction; union endpoints and counts are logged.")
esttab desc_h1 desc_h2 desc_h3 using "tables/ep_input_union.tex", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p1(fmt(3)) p99(fmt(3))") nostar stats(union_rows, fmt(0) labels("Unique rows in window union")) replace label mtitles("h=1" "h=2" "h=3") addnotes("Sample is unique GVKEY-by-availability-year input rows appearing in at least one qualifying annual training window for the model and horizon." "Rows are complete for the model outcome and regressors; N counts unique inputs, not expanded/repeated fit rows or the annual-fit coefficient summary." "Input statistics reflect the annual 1/99 winsorized construction; union endpoints and counts are logged.")
est clear

use "data/rolling_fit_panel/reg.dta", clear
isid gvkey avyear
global x "nege rix rinegx rib ritacc"
keep gvkey avyear riy1 riy2 riy3 $x
label var nege "NegE: negative earnings indicator"
label var rix "E: current earnings per share (USD)"
label var rinegx "NegE x E: interaction"
label var rib "B: book value per share (USD)"
label var ritacc "TACC: accruals per share (USD)"
forvalues h=1/3 {
    preserve
    local firstfit=1969
    if `h'==3 local firstfit=1970
    local winlo=`firstfit'-9-`h'
    local winhi=2012-`h'
    gen double y=riy`h'
    label var y "Future earnings per share, h=`h' (USD)"
    egen byte missct=rowmiss(y $x)
    gen byte inunion=0
    forvalues fit=`firstfit'/2012 {
        replace inunion=1 if inrange(avyear,`fit'-9-`h',`fit'-`h')
    }
    keep if inunion & missct==0
    isid gvkey avyear
    count
    local nunion=r(N)
    display "RI horizon " `h' " complete-case full-rank window union: base AVYEAR " `winlo' "-" `winhi' "; unique rows=" `nunion'
    estpost tabstat y $x, statistics(n mean sd p1 p99) columns(statistics)
    estadd scalar union_rows=`nunion', replace
    est store desc_h`h'
    restore
}
esttab desc_h1 desc_h2 desc_h3 using "tables/ri_input_union.md", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p1(fmt(3)) p99(fmt(3))") nostar stats(union_rows, fmt(0) labels("Unique rows in window union")) replace label mtitles("h=1" "h=2" "h=3") addnotes("Sample is unique GVKEY-by-availability-year input rows appearing in at least one native full-rank annual training window for the model and horizon." "Rows are complete for the model outcome and regressors; N counts unique inputs, not expanded/repeated fit rows or the annual-fit coefficient summary." "RI h=3 begins at T=1970 because native full-rank checking rejects T=1969; base-year union endpoints and counts are logged. Statistics reflect annual 1/99 winsorization.")
esttab desc_h1 desc_h2 desc_h3 using "tables/ri_input_union.rtf", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p1(fmt(3)) p99(fmt(3))") nostar stats(union_rows, fmt(0) labels("Unique rows in window union")) replace label mtitles("h=1" "h=2" "h=3") addnotes("Sample is unique GVKEY-by-availability-year input rows appearing in at least one native full-rank annual training window for the model and horizon." "Rows are complete for the model outcome and regressors; N counts unique inputs, not expanded/repeated fit rows or the annual-fit coefficient summary." "RI h=3 begins at T=1970 because native full-rank checking rejects T=1969; base-year union endpoints and counts are logged. Statistics reflect annual 1/99 winsorization.")
esttab desc_h1 desc_h2 desc_h3 using "tables/ri_input_union.csv", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p1(fmt(3)) p99(fmt(3))") nostar stats(union_rows, fmt(0) labels("Unique rows in window union")) replace label mtitles("h=1" "h=2" "h=3") addnotes("Sample is unique GVKEY-by-availability-year input rows appearing in at least one native full-rank annual training window for the model and horizon." "Rows are complete for the model outcome and regressors; N counts unique inputs, not expanded/repeated fit rows or the annual-fit coefficient summary." "RI h=3 begins at T=1970 because native full-rank checking rejects T=1969; base-year union endpoints and counts are logged. Statistics reflect annual 1/99 winsorization.")
esttab desc_h1 desc_h2 desc_h3 using "tables/ri_input_union.tex", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) p1(fmt(3)) p99(fmt(3))") nostar stats(union_rows, fmt(0) labels("Unique rows in window union")) replace label mtitles("h=1" "h=2" "h=3") addnotes("Sample is unique GVKEY-by-availability-year input rows appearing in at least one native full-rank annual training window for the model and horizon." "Rows are complete for the model outcome and regressors; N counts unique inputs, not expanded/repeated fit rows or the annual-fit coefficient summary." "RI h=3 begins at T=1970 because native full-rank checking rejects T=1969; base-year union endpoints and counts are logged. Statistics reflect annual 1/99 winsorization.")
est clear
exit, clear
