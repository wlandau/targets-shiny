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

project_marker <- function() {
  project_path("_project")
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
  path <- project_marker()
  if (file.exists(path)) readLines(path)
}

# Determine if the user is currently in a valid project.
project_exists <- function() {
  name <- project_get()
  any(nzchar(name)) && file.exists(project_path(name))
}

# Internally switch the app to the project with the given name.
project_set <- function(name) {
  writeLines(as.character(name), project_marker())
  project_setwd(name)
  control_set()
}

# Switch directories to the project with the given name.
# As discussed at https://github.com/ropensci/targets/discussions/297,
# {targets} needs to run from the root of the current project.
project_setwd <- function(name) {
  setwd(project_path(name))
}

# Update the UI to reflect the identity of the current project.
project_select <- function(name = project_get(), choices = project_list()) {
  session <- getDefaultReactiveDomain()
  updatePickerInput(session, "project", NULL, name, choices)
}

# Initialize a project but do not switch to it.
# This function has some safety checks on the project name.
project_init <- function(name) {
  name <- trimws(name)
  valid <- nzchar(name) &&
    !(name %in% project_list()) &&
    !grepl("[^[:alnum:]]", name)
  if (!valid) {
    shinyalert("Input error", "Project name must be unique and alphanumeric.")
    return(FALSE)
  }
  dir_create(project_path(name))
  TRUE
}

# Create a directory for a new project and switch to it,
# but do not fill the directory.
# project_save() populates and refreshes a project's files.
project_create <- function(name) {
  if (!project_init(name)) return()
  project_set(name)
  project_save(c("albumin", "log_bilirubin"), 1000L)
  project_select(name)
}

# Copy over all files from the current project (if it exists)
# except _targets/meta/process (with the PID) and `id` (with the job ID).
project_copy <- function(name) {
  old <- project_get()
  if (is.null(old)) {
    shinyalert("Cannot copy project.", "Select an active project first.")
    return()
  }
  if (!project_init(name)) return()
  show_modal_spinner(text = "Copying project...")
  on.exit(remove_modal_spinner())
  files <- c(
    "_targets.R",
    "functions.R",
    "settings.rds",
    "stderr.txt",
    "stdout.txt"
  )
  for (file in files) {
    if (file.exists(file)) {
      file_copy(project_path(old, file), project_path(name, file))
    }
  }
  if (dir.exists(project_path(old, "_targets"))) {
    dir_copy(project_path(old, "_targets"), project_path(name, "_targets"))
  }
  unlink(project_path(name, "_targets", "meta", "process"))
  project_set(name)
  project_select(name)
}

# Delete a project but do not necessarily switch to another.
project_delete <- function(name) {
  unlink(project_path(name), recursive = TRUE)
  if (!length(project_list())) unlink(project_marker())
  project_select(project_head())
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

# Load a project and handle errors gracefully.
project_load <- function() {
  tryCatch(project_load_try(), error = project_error)
}

# Set the working directory to the current project,
# read the settings file of the current project
# and update the UI to reflect the project's last known settings.
# Try to load the project. Assumes the project is uncorrupted.
# Errors should be handled gracefully.
project_load_try <- function() {
  if (!project_exists()) return()
  project_setwd(project_get())
  session <- getDefaultReactiveDomain()
  settings <- readRDS(project_path(project_get(), "settings.rds"))
  updatePickerInput(session, "biomarkers", selected = settings$biomarkers)
  updateSliderInput(session, "iterations", value = settings$iterations)
}

# Handle a corrupted project.
project_error <- function(error) {
  shinyalert(
    "Project is corrupted",
    conditionMessage(error),
    type = "error"
  )
}
