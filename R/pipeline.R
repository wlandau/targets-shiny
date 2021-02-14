write_functions <- function(dir) {
  tar_helper(file.path(dir, "functions.R"), {
    get_data_biomarker <- function() {
      pbcLong %>%
        rename(log_bilirubin = logBili) %>%
        mutate(log_platelet = log(platelet))
    }
    fit_model <- function(data_biomarker, biomarker, iterations) {
      model <- stan_jm(
        formulaLong = as.formula(paste(biomarker, "~ year + (1 | id)")),
        formulaEvent = Surv(futimeYears, death) ~ sex + trt,
        time_var = "year",
        dataLong = data_biomarker,
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
  })
}

write_pipeline <- function(
  dir,
  biomarkers =  c("albumin", "log_bilirubin", "log_platelet"),
  iterations = 1000
) {
  tar_helper(file.path(dir, "_targets.R"), {
    library(dplyr)
    library(targets)
    library(tarchetypes)
    library(tidyr)
    source("functions.R")
    tar_option_set(
      packages = c("ggplot2", "rstanarm", "tibble"),
      memory = "transient",
      garbage_collection = "true"
    )
    models <- tar_map(
      values = list(biomarker = !!biomarkers),
      tar_fst_tbl(model, fit_model(data_biomarker, biomarker, !!iterations))
    )
    list(
      tar_target(data_biomarker, get_data_biomarker()),
      models,
      tar_combine(samples, models),
      tar_qs(plot, plot_samples(samples))
    )
  })
}