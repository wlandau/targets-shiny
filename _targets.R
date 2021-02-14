library(dplyr)
library(targets)
library(tarchetypes)
library(tidyr)

tar_option_set(
  packages = c("ggplot2", "rstanarm", "tibble"),
  memory = "transient",
  garbage_collection = "true"
)

preprocess_data_long <- function() {
  pbcLong %>%
    rename(log_bilirubin = logBili) %>%
    mutate(log_platelet = log(platelet))
}

fit_model <- function(data_long, biomarker, iterations) {
  model <- stan_jm(
    formulaLong = as.formula(paste(biomarker, "~ year + (1 | id)")),
    formulaEvent = Surv(futimeYears, death) ~ sex + trt,
    time_var = "year",
    dataLong = data_long,
    dataEvent = pbcSurv,
    iter = iterations
  )
  tibble(
    alpha = as.data.frame(model)[["Assoc|Long1|etavalue"]],
    biomarker = biomarker
  )
}

plot_samples <- function(samples) {
  ggplot(samples) +
    geom_density(aes(x = alpha, fill = biomarker), alpha = 0.5) +
    theme_gray(16)
}

models <- tar_map(
  values = list(biomarker = c("albumin", "log_bilirubin", "log_platelet")),
  tar_fst_tbl(model, fit_model(data_long, biomarker, 1000))
)

list(
  tar_target(data_long, preprocess_data_long()),
  models,
  tar_combine(samples, models),
  tar_qs(plot, plot_samples(samples))
)
