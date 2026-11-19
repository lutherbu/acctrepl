# Faithful table-code reflow from note_on_estimates.Rmd.
# Path mapping and output capture are the only changes; author calculations stay intact.

package_root <- "@@ACCTREPL_WORK@@/package"
dataid <- "_revenue_wtenure_erc_delta0.9_wealth1"
dataid_label <- "Revenue recognition errors"

set_stars <- function(p_value) {
    symnum(p_value, corr = FALSE,
           cutpoints = c(0,  .01,.05,.1, 1),
           symbols = c("***","**","*"," ") )
}

library(xtable)
library(R.matlab)

# Parameter-estimate chunk from the supplied Rmd.
datafile <- file.path(package_root, "estimate_model/smm_solutions",
                      paste0("smm", dataid, ".mat"))
name_params <- c("$g$", "$\\kappa_1$", "$\\kappa_2$", "$f_1$", "$f_2$", "$\\gamma$")

se     <- matrix( , 1, 6)
params <- matrix( , 1, 6)
fval   <- vector( , 1)
pval   <- vector( , 1)
Jtest  <- vector( , 1)
N_obs  <- vector( , 1)

colnames(se)     <- name_params
colnames(params) <- name_params

data <- R.matlab::readMat(datafile)
se <- c(data$se*c(100,100,1,1,1,1))
params <- c(data$xOpt*c(100,100,1,1,1,1))
fval  <- data$fval
pval  <- data$pval
Jtest <- data$Jtest
N_obs <- formatC(data$N, big.mark = ",")

# Get significance, format params and set stars.
p_value <- 2*(1 - pnorm(abs(params/se)))
params <- formatC(params, format = "f", digits = 3)
se     <- formatC(se, format = "f", digits = 3)
pval   <- formatC(pval, format = "f", digits = 3)
Jtest  <- formatC(Jtest, format = "f", digits = 3)
params <- paste0(params, "$^{", set_stars(p_value), "}$")

# Create a separate line for standard errors and p-val for J-test.
table_est <- matrix(as.vector(rbind(as.character(params),
                                    paste0("(", as.vector(se),")"))), nrow = 2)
res <- as.data.frame(cbind(rbind("", ""), table_est, rbind(Jtest, pval)))
names(res) <- c("", name_params, "$J-$text ($p-$value)")
res_title <- paste0(dataid_label, " (N = ", N_obs, ")")

library(xtable)
res_table <- xtable(res,
                    caption = res_title)
align(res_table) <- rep("c", ncol(res) + 1)
capture.output(
  print(res_table,
    type = "latex",
    include.colnames = TRUE,
    include.rownames = FALSE,
    sanitize.text.function = function(x) {x},
    booktabs = TRUE,
    comment = FALSE),
  file = file.path(getwd(), "table4_parameter_estimates.tex")
)

# Model-implied manipulation chunk from the supplied Rmd.
library(dplyr)
library(psych)

bp_file <- file.path(package_root, "implied_manip/csv",
                     paste0("manip", dataid, ".csv"))
vw_file <- file.path(package_root, "data/data_joar_value_weights.csv")

bp <- read.csv(bp_file)
vw <- read.csv(vw_file)

res <- list()

# Incidence of manipulation.
res[["obs"]] <- nrow(bp)
res[["est"]] <- sum(bp[["state"]])
res[["est_pr"]] <- sum(bp[["state"]])/nrow(bp)*100

# Unique executives.
res[["exec"]] <-
    bp %>%
    filter(state == 1) %>%
    select(executiveid) %>%
    distinct() %>%
    nrow()

# Value-weighted bias in stock price.
bp_data <-
    bp %>%
    mutate(bias_price = (nprc_eq - iprice)/nprc_eq) %>%
    # Winsorize at 5-/95-.
    mutate(bias_price = winsor(bias_price, 0.05)) %>%
    # Merge to value weights.
    left_join(vw)

# Unconditional bias in stock price.
res[["bias_price"]] <-
    bp_data %>%
    summarize(vw_bias_price = sum(bias_price*vw)*100)

# Bias conditional on manipulating.
res[["bias_price_cond"]] <-
    bp_data %>%
    filter(state == 1) %>%
    # vw must sum up to one in this sub-sample.
    summarize(vw_bias_price = sum(bias_price*vw)/sum(vw)*100)

res_names <- names(res)

# Format for the table.
res[["obs"]] <- formatC(res[["obs"]], big.mark = ",")
res[["est"]] <- formatC(res[["est"]], big.mark = ",")
res[["exec"]] <- formatC(res[["exec"]], big.mark = ",")
res[["est_pr"]] <- formatC(res[["est_pr"]], format = "f", digits = 2)
res[["bias_price"]] <- formatC(unlist(res[["bias_price"]]), format = "f", digits = 2)
res[["bias_price_cond"]] <- formatC(unlist(res[["bias_price_cond"]]), format = "f", digits = 2)

# Table.
res_table <- as.data.frame(res)
names(res_table) <- c("Obs.",
                      "Manip. count",
                      "Manip. count (\\%)",
                      "CEO count",
                      "Value-weighted bias (\\%)",
                      "Value-weighted bias for manip. CEOs (\\%)")
res_title <- "Model-implied manipulation"

library(xtable)
res_table <- xtable(res_table,
                    caption = res_title)
align(res_table) <- c("c", "P{0.4in}", "P{0.55in}", "P{0.75in}",
                      "P{0.55in}", "P{1.25in}", "P{1.5in}")
capture.output(
  print(res_table,
    type = "latex",
    include.colnames = TRUE,
    include.rownames = FALSE,
    sanitize.text.function = function(x) {x},
    booktabs = TRUE,
    comment = FALSE),
  file = file.path(getwd(), "table8_pooled_subset.tex")
)
