session_user <- function() {
  R_user_dir("targets-shiny", "cache")
}

session_clear_all <- function() {
  unlink(list.files(session_user(), full.names = TRUE), recursive = TRUE)
}

session_path <- function(name, ...) {
  file.path(session_user(), name, ...)
}

session_exists <- function(name) {
  if (!length(name)) {
    return(FALSE)
  }
  file.exists(session_path(name))
}

session_active_path <- function() {
  session_path("_session")
}

session_active_set <- function(name) {
  writeLines(name, session_path("_session"))
}

session_active_get <- function() {
  name <- character(0)
  if (file.exists(session_active_path())) {
    name <- readLines(session_path("_session"))
  }
  if (!any(name %in% session_list())) {
    name <- head(session_list(), 1)
  }
  name
}

session_active_restore <- function() {
  name <- session_active_get()
  if (!session_exists(name)) {
    session_create("main")
    session_active_set("main")
  }
}

session_list <- function() {
  list.dirs(session_user(), full.names = FALSE, recursive = FALSE)
}

session_create <- function(name) {
  name <- trimws(name)
  session_check_name(name)
  session_create_impl(name)
}

session_check_name <- function(name) {
  if (!nzchar(name)) {
    shinyalert(title = "Error", "Please type a session name.")
    return()
  }
  if (identical(name, "_session")) {
    shinyalert(title = "Error", "Session name cannot be _session.")
    return()
  }
  if (name %in% session_list()) {
    shinyalert(title = "Error", paste("Session", name, "already exists."))
    return()
  }
}

session_create_impl <- function(name) {
  dir_create(session_path(name))
}

session_ensure <- function(name) {
  if (!session_exists(name)) {
    session_create(name)
  }
}
