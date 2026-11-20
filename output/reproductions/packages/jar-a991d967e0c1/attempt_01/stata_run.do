version 18
set more off
use "data/reg.dta", clear
log using "logs/stata_h1_mean.log", text replace

summarize link_ratio, meanonly
scalar mean_cut = r(mean)
generate byte mean_high = link_ratio > scalar(mean_cut) if !missing(link_ratio)
tabulate mean_high decision_match

count if mean_high==1
scalar n_above = r(N)
count if mean_high==1 & decision_match==1
scalar yes_above = r(N)
count if mean_high==1 & decision_match==0
scalar no_above = r(N)
scalar exp_above = scalar(n_above)/2
scalar chi_above = (scalar(yes_above)-scalar(exp_above))^2/scalar(exp_above) + (scalar(no_above)-scalar(exp_above))^2/scalar(exp_above)
scalar p_above = chi2tail(1,scalar(chi_above))

count if mean_high==0
scalar n_below = r(N)
count if mean_high==0 & decision_match==1
scalar yes_below = r(N)
count if mean_high==0 & decision_match==0
scalar no_below = r(N)
scalar exp_below = scalar(n_below)/2
scalar chi_below = (scalar(yes_below)-scalar(exp_below))^2/scalar(exp_below) + (scalar(no_below)-scalar(exp_below))^2/scalar(exp_below)
scalar p_below = chi2tail(1,scalar(chi_below))

display "Mean-split cutoff: " %9.6f scalar(mean_cut)
display "Above mean: N=" %3.0f scalar(n_above) " consistent=" %3.0f scalar(yes_above) " inconsistent=" %3.0f scalar(no_above) " expected/cell=" %6.2f scalar(exp_above) " chi2(1)=" %7.4f scalar(chi_above) " p=" %7.4f scalar(p_above)
display "Below mean: N=" %3.0f scalar(n_below) " consistent=" %3.0f scalar(yes_below) " inconsistent=" %3.0f scalar(no_below) " expected/cell=" %6.2f scalar(exp_below) " chi2(1)=" %7.4f scalar(chi_below) " p=" %7.4f scalar(p_below)

local n1 : display %3.0f scalar(n_above)
local y1 : display %3.0f scalar(yes_above)
local x1 : display %3.0f scalar(no_above)
local e1 : display %6.2f scalar(exp_above)
local c1 : display %7.4f scalar(chi_above)
local p1 : display %7.4f scalar(p_above)
local n0 : display %3.0f scalar(n_below)
local y0 : display %3.0f scalar(yes_below)
local x0 : display %3.0f scalar(no_below)
local e0 : display %6.2f scalar(exp_below)
local c0 : display %7.4f scalar(chi_below)
local p0 : display %7.4f scalar(p_below)

file open h1csv using "tables/table5_mean_split.csv", write replace
file write h1csv "Group,N_consistent,N_inconsistent,Expected_each,Chi_square,df,p" _n
file write h1csv "Above mean,`y1',`x1',`e1',`c1',1,`p1'" _n
file write h1csv "Below mean,`y0',`x0',`e0',`c0',1,`p0'" _n
file close h1csv

file open h1md using "tables/table5_mean_split.md", write replace
file write h1md "| Mean-split group | N consistent | N inconsistent | Expected per cell | Chi-square (1 df) | p |" _n
file write h1md "|---|---:|---:|---:|---:|---:|" _n
file write h1md "| Above mean | `y1' | `x1' | `e1' | `c1' | `p1' |" _n
file write h1md "| Below mean | `y0' | `x0' | `e0' | `c0' | `p0' |" _n
file close h1md

file open h1tex using "tables/table5_mean_split.tex", write replace
file write h1tex "\begin{tabular}{lrrrrr}" _n
file write h1tex "Group & Consistent & Inconsistent & Expected per cell & Chi-square (1 df) & p \\" _n
file write h1tex "Above mean & `y1' & `x1' & `e1' & `c1' & `p1' \\" _n
file write h1tex "Below mean & `y0' & `x0' & `e0' & `c0' & `p0' \\" _n
file write h1tex "\end{tabular}" _n
file close h1tex

file open h1rtf using "tables/table5_mean_split.rtf", write replace
file write h1rtf "{\rtf1\ansi\deff0" _n
file write h1rtf "\b Table 5. Mean-split chi-square tests\b0\par" _n
file write h1rtf "Group\tab Consistent\tab Inconsistent\tab Expected per cell\tab Chi-square (1 df)\tab p\par" _n
file write h1rtf "Above mean\tab `y1'\tab `x1'\tab `e1'\tab `c1'\tab `p1'\par" _n
file write h1rtf "Below mean\tab `y0'\tab `x0'\tab `e0'\tab `c0'\tab `p0'\par}" _n
file close h1rtf
log close

version 18
set more off
use "data/reg.dta", clear
log using "logs/stata_a1_median.log", text replace

summarize link_ratio, detail
scalar median_cut = r(p50)
generate byte median_high = link_ratio > scalar(median_cut) if !missing(link_ratio)
tabulate median_high decision_match

count if median_high==1
scalar n_median_above = r(N)
count if median_high==1 & decision_match==1
scalar yes_median_above = r(N)
count if median_high==1 & decision_match==0
scalar no_median_above = r(N)
scalar exp_median_above = scalar(n_median_above)/2
scalar chi_median_above = (scalar(yes_median_above)-scalar(exp_median_above))^2/scalar(exp_median_above) + (scalar(no_median_above)-scalar(exp_median_above))^2/scalar(exp_median_above)
scalar p_median_above = chi2tail(1,scalar(chi_median_above))

count if median_high==0
scalar n_median_below = r(N)
count if median_high==0 & decision_match==1
scalar yes_median_below = r(N)
count if median_high==0 & decision_match==0
scalar no_median_below = r(N)
scalar exp_median_below = scalar(n_median_below)/2
scalar chi_median_below = (scalar(yes_median_below)-scalar(exp_median_below))^2/scalar(exp_median_below) + (scalar(no_median_below)-scalar(exp_median_below))^2/scalar(exp_median_below)
scalar p_median_below = chi2tail(1,scalar(chi_median_below))

display "Median-split cutoff: " %9.6f scalar(median_cut)
display "Above median: N=" %3.0f scalar(n_median_above) " consistent=" %3.0f scalar(yes_median_above) " inconsistent=" %3.0f scalar(no_median_above) " expected/cell=" %6.2f scalar(exp_median_above) " chi2(1)=" %7.4f scalar(chi_median_above) " p=" %7.4f scalar(p_median_above)
display "Below median: N=" %3.0f scalar(n_median_below) " consistent=" %3.0f scalar(yes_median_below) " inconsistent=" %3.0f scalar(no_median_below) " expected/cell=" %6.2f scalar(exp_median_below) " chi2(1)=" %7.4f scalar(chi_median_below) " p=" %7.4f scalar(p_median_below)

local n1 : display %3.0f scalar(n_median_above)
local y1 : display %3.0f scalar(yes_median_above)
local x1 : display %3.0f scalar(no_median_above)
local e1 : display %6.2f scalar(exp_median_above)
local c1 : display %7.4f scalar(chi_median_above)
local p1 : display %7.4f scalar(p_median_above)
local n0 : display %3.0f scalar(n_median_below)
local y0 : display %3.0f scalar(yes_median_below)
local x0 : display %3.0f scalar(no_median_below)
local e0 : display %6.2f scalar(exp_median_below)
local c0 : display %7.4f scalar(chi_median_below)
local p0 : display %7.4f scalar(p_median_below)

file open a1csv using "tables/appendix_a1_median_split.csv", write replace
file write a1csv "Group,N_consistent,N_inconsistent,Expected_each,Chi_square,df,p" _n
file write a1csv "Above median,`y1',`x1',`e1',`c1',1,`p1'" _n
file write a1csv "Below median,`y0',`x0',`e0',`c0',1,`p0'" _n
file close a1csv

file open a1md using "tables/appendix_a1_median_split.md", write replace
file write a1md "| Median-split group | N consistent | N inconsistent | Expected per cell | Chi-square (1 df) | p |" _n
file write a1md "|---|---:|---:|---:|---:|---:|" _n
file write a1md "| Above median | `y1' | `x1' | `e1' | `c1' | `p1' |" _n
file write a1md "| Below median | `y0' | `x0' | `e0' | `c0' | `p0' |" _n
file close a1md

file open a1tex using "tables/appendix_a1_median_split.tex", write replace
file write a1tex "\begin{tabular}{lrrrrr}" _n
file write a1tex "Group & Consistent & Inconsistent & Expected per cell & Chi-square (1 df) & p \\" _n
file write a1tex "Above median & `y1' & `x1' & `e1' & `c1' & `p1' \\" _n
file write a1tex "Below median & `y0' & `x0' & `e0' & `c0' & `p0' \\" _n
file write a1tex "\end{tabular}" _n
file close a1tex

file open a1rtf using "tables/appendix_a1_median_split.rtf", write replace
file write a1rtf "{\rtf1\ansi\deff0" _n
file write a1rtf "\b Online Appendix Table A1. Median-split chi-square tests\b0\par" _n
file write a1rtf "Group\tab Consistent\tab Inconsistent\tab Expected per cell\tab Chi-square (1 df)\tab p\par" _n
file write a1rtf "Above median\tab `y1'\tab `x1'\tab `e1'\tab `c1'\tab `p1'\par" _n
file write a1rtf "Below median\tab `y0'\tab `x0'\tab `e0'\tab `c0'\tab `p0'\par}" _n
file close a1rtf
log close

version 18
set more off
use "data/reg.dta", clear
log using "logs/stata_table6_ancova.log", text replace

label define presentation_label 1 "Benchmark" 2 "Narrative" 3 "Strategy map", replace
label values presentation presentation_label
tabstat link_ratio nonlink_ratio experience_years, by(presentation) statistics(n mean sd) format(%8.3f)

/* Between-subject Type III effects are tested on each participant's mean
   across the two repeated measures, the standard two-level RM decomposition. */
generate mean_ratio = (link_ratio+nonlink_ratio)/2
regress mean_ratio i.presentation c.experience_years c.gender01
testparm i.presentation
scalar F_presentation = r(F)
scalar df1_presentation = r(df)
scalar df2_presentation = r(df_r)
scalar p_presentation = Ftail(scalar(df1_presentation),scalar(df2_presentation),scalar(F_presentation))
test c.experience_years
scalar F_experience = r(F)
scalar df1_experience = r(df)
scalar df2_experience = r(df_r)
scalar p_experience = Ftail(scalar(df1_experience),scalar(df2_experience),scalar(F_experience))
test c.gender01
scalar F_gender = r(F)
scalar df1_gender = r(df)
scalar df2_gender = r(df_r)
scalar p_gender = Ftail(scalar(df1_gender),scalar(df2_gender),scalar(F_gender))

rename link_ratio ratio1
rename nonlink_ratio ratio2
reshape long ratio, i(pid) j(measure)
label define measure_label 1 "Linked" 2 "Nonlinked", replace
label values measure measure_label

/* Type III/partial repeated-measures ANCOVA. pid is nested within the
   randomized between-subject presentation group. Experience and gender are
   numeric covariates. */
anova ratio presentation c.experience_years c.gender01 / pid|presentation measure measure#presentation measure#c.experience_years measure#c.gender01, repeated(measure)

test measure
scalar F_measure = r(F)
scalar df1_measure = r(df)
scalar df2_measure = r(df_r)
scalar p_measure = Ftail(scalar(df1_measure),scalar(df2_measure),scalar(F_measure))
test measure#presentation
scalar F_measure_presentation = r(F)
scalar df1_measure_presentation = r(df)
scalar df2_measure_presentation = r(df_r)
scalar p_measure_presentation = Ftail(scalar(df1_measure_presentation),scalar(df2_measure_presentation),scalar(F_measure_presentation))
test measure#c.experience_years
scalar F_measure_experience = r(F)
scalar df1_measure_experience = r(df)
scalar df2_measure_experience = r(df_r)
scalar p_measure_experience = Ftail(scalar(df1_measure_experience),scalar(df2_measure_experience),scalar(F_measure_experience))
test measure#c.gender01
scalar F_measure_gender = r(F)
scalar df1_measure_gender = r(df)
scalar df2_measure_gender = r(df_r)
scalar p_measure_gender = Ftail(scalar(df1_measure_gender),scalar(df2_measure_gender),scalar(F_measure_gender))

display "Table 6 target contrasts (native Stata tests after repeated-measures ANCOVA):"
display "Favored measure F(" %2.0f scalar(df1_measure) "," %2.0f scalar(df2_measure) ")=" %7.4f scalar(F_measure) " p=" %7.4f scalar(p_measure)
display "Presentation format F(" %2.0f scalar(df1_presentation) "," %2.0f scalar(df2_presentation) ")=" %7.4f scalar(F_presentation) " p=" %7.4f scalar(p_presentation)
display "Working experience F(" %2.0f scalar(df1_experience) "," %2.0f scalar(df2_experience) ")=" %7.4f scalar(F_experience) " p=" %7.4f scalar(p_experience)
display "Gender F(" %2.0f scalar(df1_gender) "," %2.0f scalar(df2_gender) ")=" %7.4f scalar(F_gender) " p=" %7.4f scalar(p_gender)
display "Favored measure x presentation F(" %2.0f scalar(df1_measure_presentation) "," %2.0f scalar(df2_measure_presentation) ")=" %7.4f scalar(F_measure_presentation) " p=" %7.4f scalar(p_measure_presentation)
display "Favored measure x working experience F(" %2.0f scalar(df1_measure_experience) "," %2.0f scalar(df2_measure_experience) ")=" %7.4f scalar(F_measure_experience) " p=" %7.4f scalar(p_measure_experience)
display "Favored measure x gender F(" %2.0f scalar(df1_measure_gender) "," %2.0f scalar(df2_measure_gender) ")=" %7.4f scalar(F_measure_gender) " p=" %7.4f scalar(p_measure_gender)

local f1 : display %7.4f scalar(F_measure)
local p1 : display %7.4f scalar(p_measure)
local d11 : display %2.0f scalar(df1_measure)
local d21 : display %2.0f scalar(df2_measure)
local f2 : display %7.4f scalar(F_presentation)
local p2 : display %7.4f scalar(p_presentation)
local d12 : display %2.0f scalar(df1_presentation)
local d22 : display %2.0f scalar(df2_presentation)
local f3 : display %7.4f scalar(F_experience)
local p3 : display %7.4f scalar(p_experience)
local d13 : display %2.0f scalar(df1_experience)
local d23 : display %2.0f scalar(df2_experience)
local f4 : display %7.4f scalar(F_gender)
local p4 : display %7.4f scalar(p_gender)
local d14 : display %2.0f scalar(df1_gender)
local d24 : display %2.0f scalar(df2_gender)
local f5 : display %7.4f scalar(F_measure_presentation)
local p5 : display %7.4f scalar(p_measure_presentation)
local d15 : display %2.0f scalar(df1_measure_presentation)
local d25 : display %2.0f scalar(df2_measure_presentation)
local f6 : display %7.4f scalar(F_measure_experience)
local p6 : display %7.4f scalar(p_measure_experience)
local d16 : display %2.0f scalar(df1_measure_experience)
local d26 : display %2.0f scalar(df2_measure_experience)
local f7 : display %7.4f scalar(F_measure_gender)
local p7 : display %7.4f scalar(p_measure_gender)
local d17 : display %2.0f scalar(df1_measure_gender)
local d27 : display %2.0f scalar(df2_measure_gender)

file open t6csv using "tables/table6_repeated_ancova.csv", write replace
file write t6csv "Effect,df_numerator,df_denominator,F,p" _n
file write t6csv "Favored measure,`d11',`d21',`f1',`p1'" _n
file write t6csv "Presentation format,`d12',`d22',`f2',`p2'" _n
file write t6csv "Working experience,`d13',`d23',`f3',`p3'" _n
file write t6csv "Gender,`d14',`d24',`f4',`p4'" _n
file write t6csv "Favored measure x presentation format,`d15',`d25',`f5',`p5'" _n
file write t6csv "Favored measure x working experience,`d16',`d26',`f6',`p6'" _n
file write t6csv "Favored measure x gender,`d17',`d27',`f7',`p7'" _n
file close t6csv

file open t6md using "tables/table6_repeated_ancova.md", write replace
file write t6md "| Effect | df numerator | df denominator | F | p |" _n
file write t6md "|---|---:|---:|---:|---:|" _n
file write t6md "| Favored measure | `d11' | `d21' | `f1' | `p1' |" _n
file write t6md "| Presentation format | `d12' | `d22' | `f2' | `p2' |" _n
file write t6md "| Working experience | `d13' | `d23' | `f3' | `p3' |" _n
file write t6md "| Gender | `d14' | `d24' | `f4' | `p4' |" _n
file write t6md "| Favored measure x presentation format | `d15' | `d25' | `f5' | `p5' |" _n
file write t6md "| Favored measure x working experience | `d16' | `d26' | `f6' | `p6' |" _n
file write t6md "| Favored measure x gender | `d17' | `d27' | `f7' | `p7' |" _n
file close t6md

file open t6tex using "tables/table6_repeated_ancova.tex", write replace
file write t6tex "\begin{tabular}{lrrrr}" _n
file write t6tex "Effect & df numerator & df denominator & F & p \\" _n
file write t6tex "Favored measure & `d11' & `d21' & `f1' & `p1' \\" _n
file write t6tex "Presentation format & `d12' & `d22' & `f2' & `p2' \\" _n
file write t6tex "Working experience & `d13' & `d23' & `f3' & `p3' \\" _n
file write t6tex "Gender & `d14' & `d24' & `f4' & `p4' \\" _n
file write t6tex "Favored measure x presentation format & `d15' & `d25' & `f5' & `p5' \\" _n
file write t6tex "Favored measure x working experience & `d16' & `d26' & `f6' & `p6' \\" _n
file write t6tex "Favored measure x gender & `d17' & `d27' & `f7' & `p7' \\" _n
file write t6tex "\end{tabular}" _n
file close t6tex

file open t6rtf using "tables/table6_repeated_ancova.rtf", write replace
file write t6rtf "{\rtf1\ansi\deff0" _n
file write t6rtf "\b Table 6. Repeated-measures mixed ANCOVA\b0\par" _n
file write t6rtf "Effect\tab df numerator\tab df denominator\tab F\tab p\par" _n
file write t6rtf "Favored measure\tab `d11'\tab `d21'\tab `f1'\tab `p1'\par" _n
file write t6rtf "Presentation format\tab `d12'\tab `d22'\tab `f2'\tab `p2'\par" _n
file write t6rtf "Working experience\tab `d13'\tab `d23'\tab `f3'\tab `p3'\par" _n
file write t6rtf "Gender\tab `d14'\tab `d24'\tab `f4'\tab `p4'\par" _n
file write t6rtf "Favored measure x presentation format\tab `d15'\tab `d25'\tab `f5'\tab `p5'\par" _n
file write t6rtf "Favored measure x working experience\tab `d16'\tab `d26'\tab `f6'\tab `p6'\par" _n
file write t6rtf "Favored measure x gender\tab `d17'\tab `d27'\tab `f7'\tab `p7'\par}" _n
file close t6rtf
log close
