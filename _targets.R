library(targets)
library(tarchetypes)
library(tidyr)

tar_option_set(
  packages = c("ggplot2", "rstanarm", "tibble"),
  memory = "transient",
  garbage_collection = "true"
)

fit_model <- function(hazard, regularization, iterations) {
  model <- stan_jm(
    formulaLong = logBili ~ year + (1 | id),
    formulaEvent = Surv(futimeYears, death) ~ sex + trt,
    time_var = "year",
    dataLong = pbcLong,
    dataEvent = pbcSurv,
    prior_covariance = lkj(regularization = regularization, autoscale = TRUE),
    basehaz = hazard,
    iter = iterations,
    chains = 4,
    cores = 1
  )
  tibble(
    alpha = as.data.frame(model)[["Assoc|Long1|etavalue"]],
    hazard = hazard,
    regularization = regularization
  )
}

plot_samples <- function(samples) {
  ggplot(samples) +
    geom_density(aes(x = alpha), fill = "#606060", alpha = 0.5) +
    facet_grid(hazard ~ regularization, labeller = label_both) +
    theme_gray(12)
}

values <- expand_grid(
  hazard = c("bs", "weibull", "piecewise"),
  regularization = c(0.5, 1, 2)
)

models <- tar_map(
  values = values,
  tar_fst_tbl(model, fit_model(hazard, regularization, 1000))
)

list(
  models,
  tar_combine(samples, models),
  tar_qs(plot, plot_samples(samples))
)
