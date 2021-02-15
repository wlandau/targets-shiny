project_parent <- function() {
  R_user_dir("targets-shiny", "cache")
}

project_path <- function(name, ...) {
  file.path(project_parent(), name, ...)
}

project_list <- function() {
  list.dirs(project_parent(), full.names = FALSE, recursive = FALSE)
}

project_head <- function() {
  head(project_list(), 1)
}

project_get <- function() {
  path <- project_path("_project")
  if (file.exists(path)) readLines(project_path("_project"))
}

project_undefined <- function() {
  !any(nzchar(project_get()))
}

project_set <- function(name) {
  writeLines(as.character(name), project_path("_project"))
  setwd(project_path(name))
}

project_select <- function(name = project_get(), choices = project_list()) {
  session <- getDefaultReactiveDomain()
  updatePickerInput(session, "project", NULL, name, choices)
}

project_create <- function(name) {
  name <- trimws(name)
  valid <- nzchar(name) && !(name %in% c("_project", project_list()))
  if (valid) dir_create(project_path(name))
}

project_delete <- function(name) {
  dir_delete(project_path(name))
}

project_save <- function(biomarkers, iterations) {
  if (project_undefined()) return()
  name <- project_get()
  settings <- list(biomarkers = biomarkers, iterations = iterations)
  saveRDS(settings, project_path(name, "settings.rds"))
  write_functions(project_path(name))
  write_pipeline(project_path(name), biomarkers, iterations)
}

project_load <- function() {
  if (project_undefined()) return()
  session <- getDefaultReactiveDomain()
  settings <- readRDS(project_path(project_get(), "settings.rds"))
  updatePickerInput(session, "biomarkers", selected = settings$biomarkers)
  updateSliderInput(session, "iterations", value = settings$iterations)
}
