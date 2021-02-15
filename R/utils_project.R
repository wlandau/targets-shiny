project_path <- function(name = "", ...) {
  file.path(R_user_dir("targets-shiny", "cache"), name, ...)
}

project_set <- function(name) {
  writeLines(as.character(name), project_path("_project"))
}

project_get <- function() {
  path <- project_path("_project")
  if (file.exists(path)) readLines(project_path("_project"))
}

project_list <- function() {
  list.dirs(project_path(), full.names = FALSE, recursive = FALSE)
}

project_create <- function(name) {
  name <- trimws(name)
  valid <- nzchar(name) && !(name %in% project_list())
  if (valid) dir_create(project_path(name))
}

project_delete <- function(name) {
  dir_delete(project_path(name))
}

project_ui <- function(selected = project_get(), choices = project_list()) {
  session <- getDefaultReactiveDomain()
  updatePickerInput(session, "project", NULL, selected, choices)
}

project_select <- function(name = head(project_list(), 1)) {
  project_set(name)
  project_ui(name)
}
