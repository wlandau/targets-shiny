project_path <- function(name = "", ...) {
  file.path(R_user_dir("targets-shiny", "cache"), name, ...)
}

project_set <- function(name) {
  writeLines(name, project_path("_project"))
}

project_get <- function() {
  if (file.exists(project_path("_project"))) {
    readLines(project_path("_project"))
  } else {
    character(0)
  }
}

project_list <- function() {
  list.dirs(project_path(), full.names = FALSE, recursive = FALSE)
}

project_create <- function(name) {
  name <- trimws(name)
  if (!project_valid(name)) {
    return()
  }
  dir_create(project_path(name))
}

project_valid <- function(name) {
  out <- FALSE
  if (!nzchar(name)) {
    shinyalert("Error", "Please type a project name.")
  } else if (identical(name, "_project")) {
    shinyalert("Error", "project name cannot be _project.")
  } else if (name %in% project_list()) {
    shinyalert("Error", paste("project", name, "already exists."))
  } else {
    out <- TRUE
  }
  out
}




project_clear <- function() {
  unlink(list.files(project_path(), full.names = TRUE), recursive = TRUE)
}


project_exists <- function(name) {
  any(file.exists(project_path(name)))
}
