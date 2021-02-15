project_path <- function(name = "", ...) {
  file.path(R_user_dir("targets-shiny", "cache"), name, ...)
}

project_list <- function() {
  list.dirs(project_path(), full.names = FALSE, recursive = FALSE)
}

project_get <- function() {
  path <- project_path("_project")
  if (file.exists(path)) readLines(project_path("_project"))
}

project_set <- function(name) {
  writeLines(as.character(name), project_path("_project"))
}

project_select <- function(name = project_get(), choices = project_list()) {
  session <- getDefaultReactiveDomain()
  updatePickerInput(session, "project", NULL, name, choices)
}

project_create <- function(name) {
  name <- trimws(name)
  valid <- nzchar(name) && !(name %in% project_list())
  if (valid) dir_create(project_path(name))
}

project_delete <- function(name) {
  dir_delete(project_path(name))
}

project_head <- function(name) {
  head(project_list(), 1)
}

###

project_save <- function(name, biomarkers, iterations) {
  path <- project_path(name, "settings.rds")
  settings <- list(biomarkers = biomarkers, iterations = iterations)
  saveRDS(settings, path)
}

project_load <- function() {
  name <- project_get()
  
}

