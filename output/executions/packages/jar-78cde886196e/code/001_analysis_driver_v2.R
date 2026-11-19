# Faithful code reflow from glz_knit_tables/README.pdf.

# It preserves the supplied snippets in their documented call-level then Q&A-level order.

# README.pdf source lines 21-22
library(sandwich)
library(lmtest)

# README.pdf source lines 30-125
library(stargazer)
library(dplyr, warn.conflicts = FALSE)
library(tidyr, warn.conflicts = FALSE)

# README.pdf line 34: Define function to set variable labels
get_labels <- Vectorize(function(str, latex = FALSE)
    # This function maps variable labels

     switch(gsub("_avg|_rev|_coreneg|_core", "", str),
            "count" = "Obs.",
            "nonans_rate" = "Non-answers",
            "comp" = "Competition",
            "comp_sic3_i" = "SIC3-level comp.",
            "hhi3" = "HHI SIC3",
            "tnic3tsimm_log" = "Log Similarity",
            "ibq_to_atq" = "Return on assets", # quarterly
            "ibq_to_atq_lead" = "Return on assets, next", # quarterly
            "lossq" = "Loss", # quarterly
            "type_ib" = "Future profitability",
            "impgr3_oth3_lag" = ifelse(latex, "3-year SIC3 import growth non-US$_{t-1}$",
                                       "3-year SIC3 import growth non-US(t-1)"),
            "impgr3_us3_lag" = ifelse(latex, "3-year SIC3 import growth US$_{t-1}$",
                                      "3-year SIC3 import growth US(t-1)"),
            "is_nonans" = "Non-answer",
            "positive" = "Positive tone",
            "negative" = "Negative tone",
            "uncertainty" = "Uncertainty",
            "has_forward_brvb" = "Future-related",
            "fog" = "Fog index",
            "has_nums" = "Contains numbers",
            "has_loc" = "Contains location",



               "has_date_time" = "Contains date or time",
               "has_money_percent" = "Contains money or percent",
               "has_earn_mpr" = "Perf.-related",
               "has_product" = "Proprietary-inf.",
               "has_earn_mpr_x_lossq" =
                   ifelse(latex, "Perf.-related $\\times$ Loss",
                                               "Perf.-related x Loss"),
               "has_earn_mpr_x_ibq_to_atq" =
                   ifelse(latex, "Perf.-related $\\times$ Return on assets",
                                                    "Perf.-related x Return on assets"),
               "has_earn_mpr_x_ibq_to_atq_lead" =
                   ifelse(latex, "Perf.-related $\\times$ Return on assets, next",
                                                         "Perf.-related x Return on assets, next"),
               "has_earn_mpr_x_type_ib" =
                   ifelse(latex, "Perf.-related $\\times$ Future profitability",
                                                 "Perf.-related x Future profitability"),
               "has_product_x_hhi3" =
                   ifelse(latex, "Proprietary-inf. $\\times$ HHI SIC3",
                                             "Proprietary-inf. x HHI SIC3"),
               "has_product_x_comp" =
                   ifelse(latex, "Proprietary-inf. $\\times$ Comp.",
                                             "Proprietary-inf. x Comp."),
               "has_product_x_tnic3tsimm_log" =
                   ifelse(latex, "Proprietary-inf. $\\times$ Log Similarity",
                                                       "Proprietary-inf. x Log Similarity"),
               "has_product_x_comp_sic3_i" =
                   ifelse(latex, "Proprietary-inf. $\\times$ SIC3 comp.",
                                                    "Proprietary-inf. x SIC3 comp."),
               str), "str")

# README.pdf line 95: Define functions to estimate regressions with year fixed effects and standard errors clustered by firm and year




# The variance-covariance matrix must be reweighted with
# dfcw = (N - k)/((N - k) - (M - 1)) if data is de-meaned for fixed effects
reg_year_fe <- function(y, x, mcw, data) {

    # Estimate linear regression
    model <- paste0(y, " ~ ", paste0(x, collapse = " + "), " + factor(fyear)")
    fm <- lm(as.formula(model), data)

    # Compute two-way clustered SE
    dfcw <- fm$df/(fm$df - (mcw - 1))
    se <- coeftest(fm, vcov = dfcw*vcovCL(fm, cluster = data[, c("cik", "fyear")]))
    return(list(fm, se = se[, 2], pval = se[, 4]))
}

reg <- function(y, x, mcw, data) {

    # Estimate linear regression
    model <- paste0(y, " ~ ", paste0(x, collapse = " + "))
    fm <- lm(as.formula(model), data)

    # Compute two-way clustered SE
    dfcw <- fm$df/(fm$df - (mcw - 1))
    se <- coeftest(fm, vcov = dfcw*vcovCL(fm, cluster = data[, c("cik", "fyear")]))
    return(list(fm, se = se[, 2], pval = se[, 4]))
}

# Source-supported project-root setup: staged glz_knit_tables is under work/.
path <- "./"

# Route printed summaries and author tables to a fresh in-attempt result artifact.
sink("outputs/analysis_tables.txt", split = TRUE)

# README.pdf source lines 136-171
load(paste0(path, "glz_knit_tables/calls_set_glz.RData")) # Loads calls_set_glz

# Summary stats
ndigits <- 3
var_order <- c("nonans_rate",
              "lossq", "ibq_to_atq", "ibq_to_atq_lead", "type_ib",
              "hhi3", "tnic3tsimm_log", "comp", "comp_sic3_i",
              "impgr3_us3_lag", "impgr3_oth3_lag")

# Print table
calls_set_glz %>%
    summarise_at(.vars = vars(-cik, -file_name_alt, -fyear),
                  .funs = funs(nobs = formatC(sum(!is.na(.)), format = "d", big.mark = ","),
                               mean = mean(., na.rm = TRUE),
                               sd = sd(., na.rm = TRUE),
                               p5 = quantile(., 0.05, na.rm = TRUE),
                               p25 = quantile(., 0.25, na.rm = TRUE),
                               p50 = quantile(., 0.50, na.rm = TRUE),
                               p75 = quantile(., 0.75, na.rm = TRUE),
                               p95 = quantile(., 0.95, na.rm = TRUE))) %>%
    mutate_at(.vars = vars(-matches("_nobs|_nmiss")),
              .funs = funs(formatC(., format = "f", big.mark = ",", digits = ndigits))) %>%
    # Reshape summary stats table
    gather(var_stat, value) %>%
    # Extract stats from variable name
    extract(var_stat, c("var", "stat"), "([[:alnum:]_]+_*)_([[:alnum:]]+)$") %>%
    spread(stat, value) %>%



   # Reorder variables
   slice(match(var_order, var)) %>%
   mutate(var = get_labels(var, latex = FALSE)) %>%
   select(var, nobs, mean, sd, p5, p25, p50, p75, p95) %>%
   print(n = Inf)

# README.pdf source lines 197-238
# Convert non-answers to % and standardize continous independent variables
reg_data <-
    calls_set_glz %>%
    mutate(nonans_rate = 100*nonans_rate) %>%
    mutate_at(.vars = vars(ibq_to_atq, ibq_to_atq_lead, type_ib),
              .funs = funs(scale(., center = TRUE, scale = TRUE)))

# Regression with year fixed effects and standard errors clustered by {firm, year}
rhs <- list("lossq",
            "ibq_to_atq",
            "ibq_to_atq_lead",
            c("ibq_to_atq", "ibq_to_atq_lead"),
            "type_ib",
            c("ibq_to_atq", "type_ib"))

# Estimate regressions
mcw <- 1
reg_list <- lapply(rhs, reg_year_fe, y = "nonans_rate", mcw = mcw, data = reg_data)

# Collect models and standard errors
fm_list <- lapply(reg_list, `[[`, 1)
se_list <- lapply(reg_list, `[[`, 2)
pvalues_list <- lapply(reg_list, `[[`, 3)

# Print table
custom_coef_names <- get_labels(gsub("TRUE", "", unlist(rhs)), latex = FALSE) %>% unique()
stargazer(fm_list,



se = se_list,
p = pvalues_list,
header = FALSE,
omit = "(factor*)|(Intercept)|Constant",
covariate.labels = custom_coef_names,
keep.stat = c("n", "rsq", "chi2"),
# Table formatting
title = "\\textbf{Non-answers and performance: Replication}",
dep.var.caption = "Non-answers(\\%)",
dep.var.labels.include = FALSE
)

# README.pdf source lines 275-311
# Convert non-answers to % and standardize continous independent variables
reg_data <-
    calls_set_glz %>%
    mutate(nonans_rate = 100*nonans_rate) %>%
    mutate_at(.vars = vars(hhi3, tnic3tsimm_log, comp, comp_sic3_i),
              .funs = funs(scale(., center = TRUE, scale = TRUE)))

# Regression with year fixed effects and standard errors clustered by {firm, year}
rhs <- list("hhi3", "tnic3tsimm_log", "comp", "comp_sic3_i")

# Estimate regressions
mcw <- 1
reg_list <- lapply(rhs, reg_year_fe, y = "nonans_rate", mcw = mcw, data = reg_data)

# Collect models and standard errors
fm_list <- lapply(reg_list, `[[`, 1)
se_list <- lapply(reg_list, `[[`, 2)
pvalues_list <- lapply(reg_list, `[[`, 3)

# Print table
custom_coef_names <- get_labels(gsub("TRUE", "", unlist(rhs)), latex = FALSE) %>% unique()
stargazer(fm_list,
          se = se_list,
          p = pvalues_list,
          header = FALSE,
          omit = "(factor*)|(Intercept)|Constant",
          covariate.labels = custom_coef_names,



keep.stat = c("n", "rsq", "chi2"),
# Table formatting
title = "\\textbf{Non-answers and competition: Replication}",
dep.var.caption = "Non-answers(\\%)",
dep.var.labels.include = FALSE
)

# README.pdf source lines 344-379
# Convert non-answers to % and standardize continous independent variables
reg_data <-
    calls_set_glz %>%
    select(cik, fyear, nonans_rate, impgr3_oth3_lag, impgr3_us3_lag) %>%
    na.omit() %>%
    mutate(nonans_rate = 100*nonans_rate) %>%
    # 2nd stage independent variables are standardized
    mutate(impgr3_us3_lag = scale(impgr3_us3_lag, center = TRUE, scale = TRUE))

# Regression with year fixed effects and standard errors clustered by {firm, year}

# Estimate first stage
mcw <- 1
fm <- lm("impgr3_us3_lag ~ impgr3_oth3_lag + factor(fyear)", data = reg_data)
# Compute two-way clustered SE
dfcw <- fm$df/(fm$df - (mcw - 1))
se <- coeftest(fm, vcov = dfcw*vcovCL(fm, cluster = reg_data[, c("cik", "fyear")]))

# Print table
custom_coef_names <- get_labels("impgr3_oth3_lag")
stargazer(fm,
          se = list(se[, 2]),
          p = list(se[, 4]),
          header = FALSE,
          omit = "(factor*)|(Intercept)|Constant",
          covariate.labels = custom_coef_names,
          keep.stat = c("n", "rsq", "chi2"),



         # Table formatting
         title = "Panel A: First stage",
         dep.var.caption = get_labels("impgr3_us3_lag"),
         dep.var.labels.include = FALSE
         )

# README.pdf source lines 393-419
# Estimate second stage
impgr3_us3_lag_hat <- predict(fm, data = reg_data)
reg_data_alt <- cbind(reg_data, impgr3_us3_lag_hat)
mcw <- 1
fm <- lm("nonans_rate ~ impgr3_us3_lag_hat + factor(fyear)", data = reg_data_alt)
# Compute two-way clustered SE
dfcw <- fm$df/(fm$df - (mcw - 1))
se <- coeftest(fm, vcov = dfcw*vcovCL(fm, cluster = reg_data_alt[, c("cik", "fyear")]))

# Print table
custom_coef_names <- get_labels("impgr3_us3_lag")
stargazer(fm,
          se = list(se[, 2]),
          p = list(se[, 4]),



header = FALSE,
omit = "(factor*)|(Intercept)|Constant",
covariate.labels = custom_coef_names,
keep.stat = c("n", "rsq", "chi2"),
# Table formatting
title = "Panel B: Second stage",
dep.var.caption = "Non-answers (\\%)",
dep.var.labels.include = FALSE
)

# README.pdf source lines 442-478
load(paste0(path, "glz_knit_tables/ner_set_glz.RData")) # Loads ner_set_glz

# Summary stats
ndigits <- 3
var_order <- c("is_nonans",
              "positive", "negative", "uncertainty", "fog",
              "has_nums", "has_money_percent", "has_loc", "has_date_time",
              "has_earn_mpr", "has_product")

# Print table
ner_set_glz %>%
    select(var_order) %>%
    summarise_at(.vars = vars(everything()),
                 .funs = funs(nobs = formatC(sum(!is.na(.)), format = "d", big.mark = ","),
                              mean = mean(., na.rm = TRUE),
                              sd = sd(., na.rm = TRUE),
                              p5 = quantile(., 0.05, na.rm = TRUE),
                              p25 = quantile(., 0.25, na.rm = TRUE),
                              p50 = quantile(., 0.50, na.rm = TRUE),
                              p75 = quantile(., 0.75, na.rm = TRUE),
                              p95 = quantile(., 0.95, na.rm = TRUE))) %>%
    mutate_at(.vars = vars(-matches("_nobs|_nmiss")),
              .funs = funs(formatC(., format = "f", big.mark = ",", digits = ndigits))) %>%
    # Reshape summary stats table
    gather(var_stat, value) %>%
    # Extract stats from variable name
    extract(var_stat, c("var", "stat"), "([[:alnum:]_]+_*)_([[:alnum:]]+)$") %>%



   spread(stat, value) %>%
   # Reorder variables
   slice(match(var_order, var)) %>%
   mutate(var = get_labels(var, latex = FALSE)) %>%
   select(var, nobs, mean, sd, p5, p25, p50, p75, p95) %>%
   print(n = Inf)

# README.pdf source lines 504-548
# Convert non-answers to %, standardize continous independent variables,
# and de-mean all by call
reg_data <-
    ner_set_glz %>%
    mutate(is_nonans = 100*is_nonans) %>%
    mutate_at(.vars = vars(positive, negative, uncertainty, fog),
              .funs = funs(scale(., center = TRUE, scale = TRUE))) %>%
    # De-mean by call
    group_by(file_name_alt) %>%
    mutate_at(.vars = vars(is_nonans, positive, negative, uncertainty, fog,
                           has_nums, has_money_percent, has_loc, has_date_time),
              .funs = funs(scale(., center = TRUE, scale = FALSE))) %>%
    ungroup()

# Regressions with standard errors clustered by {firm, year}
# WARNING: variables are already de-meaned by call, that is call fixed effects are included
rhs <- list("positive", "negative", "uncertainty", "fog",
            "has_nums", "has_money_percent", "has_loc", "has_date_time")

# Estimate regressions
mcw <- length(unique(reg_data[["file_name_alt"]]))
reg_list <- lapply(rhs, reg, y = "is_nonans", mcw = mcw, data = reg_data)

# Collect models and standard errors
fm_list <- lapply(reg_list, `[[`, 1)
se_list <- lapply(reg_list, `[[`, 2)
pvalues_list <- lapply(reg_list, `[[`, 3)



# Print table
custom_coef_names <- get_labels(gsub("TRUE", "", unlist(rhs)), latex = FALSE) %>% unique()
stargazer(fm_list,
          se = se_list,
          p = pvalues_list,
          header = FALSE,
          omit = "(factor*)|(Intercept)|Constant",
          covariate.labels = custom_coef_names,
          keep.stat = c("n", "rsq", "chi2"),
          # Table formatting
          title = "\\textbf{Non-answers and type of information demanded}",
          dep.var.caption = "Non-answers(\\%)",
          dep.var.labels.include = FALSE
          )

# README.pdf source lines 594-652
# Convert non-answers to %, standardize continous independent variables,
# and de-mean all by call
reg_data <-
    ner_set_glz %>%
    mutate(is_nonans = 100*is_nonans) %>%
    mutate_at(.vars = vars(ibq_to_atq, ibq_to_atq_lead, type_ib),
              .funs = funs(scale(., center = TRUE, scale = TRUE))) %>%
    # Create iteraction terms
    mutate(has_earn_mpr_x_lossq = has_earn_mpr*lossq,
           has_earn_mpr_x_ibq_to_atq = has_earn_mpr*ibq_to_atq,
           has_earn_mpr_x_ibq_to_atq_lead = has_earn_mpr*ibq_to_atq_lead,
           has_earn_mpr_x_type_ib = has_earn_mpr*type_ib) %>%
    # De-mean by call
    group_by(file_name_alt) %>%
    mutate_at(.vars = vars(is_nonans, has_earn_mpr,
                           lossq, ibq_to_atq, ibq_to_atq_lead, type_ib,
                           has_earn_mpr_x_lossq, has_earn_mpr_x_ibq_to_atq,
                           has_earn_mpr_x_ibq_to_atq_lead, has_earn_mpr_x_type_ib),
              .funs = funs(scale(., center = TRUE, scale = FALSE))) %>%
    ungroup()

# Regressions with standard errors clustered by {firm, year}
# WARNING: variables are already de-meaned by call, that is equivalent
# to inclusion of call fixed effects. Because of de-meaning by call
# (i.e., including call fixed effects), call-level variables such as
# {lossq, ibq_to_atq, ibq_to_atq_lead, type_ib} drop out
rhs <- list("has_earn_mpr",



           c("has_earn_mpr", "has_earn_mpr_x_lossq"),
           c("has_earn_mpr", "has_earn_mpr_x_ibq_to_atq"),
           c("has_earn_mpr", "has_earn_mpr_x_ibq_to_atq_lead"),
           c("has_earn_mpr", "has_earn_mpr_x_type_ib"))

# Estimate regressions
mcw <- length(unique(reg_data[["file_name_alt"]]))
reg_list <- lapply(rhs, reg, y = "is_nonans", mcw = mcw, data = reg_data)

# Collect models and standard errors
fm_list <- lapply(reg_list, `[[`, 1)
se_list <- lapply(reg_list, `[[`, 2)
pvalues_list <- lapply(reg_list, `[[`, 3)

# Print table
custom_coef_names <- get_labels(gsub("TRUE", "", unlist(rhs)), latex = FALSE) %>% unique()
stargazer(fm_list,
          se = se_list,
          p = pvalues_list,
          header = FALSE,
          omit = "(factor*)|(Intercept)|Constant",
          covariate.labels = custom_coef_names,
          keep.stat = c("n", "rsq", "chi2"),
          # Table formatting
          title = "\\textbf{Performance-related questions, non-answers, and performance}",
          dep.var.caption = "Non-answers(\\%)",
          dep.var.labels.include = FALSE
          )

# README.pdf source lines 693-751
# Convert non-answers to %, standardize continous independent variables,
# and de-mean all by call
reg_data <-
    ner_set_glz %>%
    mutate(is_nonans = 100*is_nonans) %>%
    mutate_at(.vars = vars(hhi3, tnic3tsimm_log, comp, comp_sic3_i),
              .funs = funs(scale(., center = TRUE, scale = TRUE))) %>%
    # Create iteraction terms
    mutate(has_product_x_hhi3 = has_product*hhi3,
           has_product_x_tnic3tsimm_log = has_product*tnic3tsimm_log,
           has_product_x_comp = has_product*comp,
           has_product_x_comp_sic3_i = has_product*comp_sic3_i) %>%
    # De-mean by call
    group_by(file_name_alt) %>%
    mutate_at(.vars = vars(is_nonans, has_product,
                           hhi3, tnic3tsimm_log, comp, comp_sic3_i,
                           has_product_x_hhi3, has_product_x_tnic3tsimm_log,
                           has_product_x_comp, has_product_x_comp_sic3_i),
              .funs = funs(scale(., center = TRUE, scale = FALSE))) %>%
    ungroup()

# Regressions with standard errors clustered by {firm, year}
# WARNING: variables are already de-meaned by call, that is equivalent
# to inclusion of call fixed effects. Because of de-meaning by call
# (i.e., including call fixed effects), call-level variables such as
# {hhi3, tnic3tsimm_log, comp, comp_sic3_i} drop out
rhs <- list("has_product",



           c("has_product", "has_product_x_hhi3"),
           c("has_product", "has_product_x_tnic3tsimm_log"),
           c("has_product", "has_product_x_comp"),
           c("has_product", "has_product_x_comp_sic3_i"))

# Estimate regressions
mcw <- length(unique(reg_data[["file_name_alt"]]))
reg_list <- lapply(rhs, reg, y = "is_nonans", mcw = mcw, data = reg_data)

# Collect models and standard errors
fm_list <- lapply(reg_list, `[[`, 1)
se_list <- lapply(reg_list, `[[`, 2)
pvalues_list <- lapply(reg_list, `[[`, 3)

# Print table
custom_coef_names <- get_labels(gsub("TRUE", "", unlist(rhs)), latex = FALSE) %>% unique()
stargazer(fm_list,
          se = se_list,
          p = pvalues_list,
          header = FALSE,
          omit = "(factor*)|(Intercept)|Constant",
          covariate.labels = custom_coef_names,
          keep.stat = c("n", "rsq", "chi2"),
          # Table formatting
          title = "\\textbf{Proprietary-information questions, non-answers, and competition}",
          dep.var.caption = "Non-answers(\\%)",
          dep.var.labels.include = FALSE
          )


# Close the declared text result capture.
sink()

