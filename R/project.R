# All the projects live in project_home(). tools::R_user_dir()
# provides unobtrusive persistent user-specific storage for packages
# and apps. If you are the administrator and need to change where
# persistent user files are stored, this is the place to do so.
# In transient mode, the app only writes to temporary storage.
project_home <- function() {
  if (transient_active()) return(file.path(tempdir(), "targets-shiny"))
  home <- Sys.getenv("TARGETS_SHINY_HOME")
  if (identical(home, "")) {
    R_user_dir("targets-shiny", "cache")
  } else {
    file.path(home, Sys.getenv("USER"), ".targets-shiny")
  }
}

# Identify the absolute file path of any file in a project
# given the project's name.
project_path <- function(name, ...) {
  file.path(project_home(), name, ...)
}

# Identify the absolute path of the project's stdout log file.
project_stdout <- function() {
  project_path(project_get(), "stdout.txt")
}

# Identify the absolute path of the project's stderr log file.
project_stderr <- function() {
  project_path(project_get(), "stderr.txt")
}

# Identify all the instantiated projects of the current user.
project_list <- function() {
  list.dirs(project_home(), full.names = FALSE, recursive = FALSE)
}

# Identify the first project in the project list.
# This is useful for finding out which project to switch to
# when the current project is deleted.
project_head <- function() {
  head(project_list(), 1)
}

# Identify the project currently loaded.
project_get <- function() {
  path <- project_path("_project")
  if (file.exists(path)) readLines(project_path("_project"))
}

# Determine if the user is currently in a valid project.
project_exists <- function() {
  name <- project_get()
  any(nzchar(name)) && file.exists(project_path(name))
}

# Internally switch the app to the project with the given name.
project_set <- function(name) {
  writeLines(as.character(name), project_path("_project"))
  setwd(project_path(name))
}

# Update the UI to reflect the identity of the current project.
project_select <- function(name = project_get(), choices = project_list()) {
  session <- getDefaultReactiveDomain()
  updatePickerInput(session, "project", NULL, name, choices)
}

# Create a directory for a new project but do not fill it.
# project_save() populates and refreshes a project's files.
project_create <- function(name) {
  name <- trimws(name)
  valid <- nzchar(name) && !(name %in% c("_project", project_list()))
  if (valid) dir_create(project_path(name))
}

# Delete a project but do not necessarily switch to another.
project_delete <- function(name) {
  unlink(project_path(name), recursive = TRUE)
}

# Populate or refresh a project's files.
# This happens when a project is created or the user
# changes settings that affect the pipeline.
project_save <- function(biomarkers, iterations) {
  if (!project_exists()) return()
  name <- project_get()
  settings <- list(biomarkers = biomarkers, iterations = iterations)
  saveRDS(settings, project_path(name, "settings.rds"))
  write_functions(project_path(name))
  write_pipeline(project_path(name), biomarkers, iterations)
}

# Read the settings file of the current project
# and update the UI to reflect the project's last known settings.
project_load <- function() {
  if (!project_exists()) return()
  session <- getDefaultReactiveDomain()
  settings <- readRDS(project_path(project_get(), "settings.rds"))
  updatePickerInput(session, "biomarkers", selected = settings$biomarkers)
  updateSliderInput(session, "iterations", value = settings$iterations)
}
