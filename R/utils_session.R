session_user <- function() {
  R_user_dir("targets-shiny", "cache")
}

session_root <- function(session) {
  file.path(session_user(), session)
}

session_path <- function(session, ...) {
  file.path(session_root(session), ...)
}

session_list <- function() {
  list.files(session_user())
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
  if (name %in% session_list()) {
    shinyalert(title = "Error", paste("Session", name, "already exists."))
    return()
  }
}

session_create_impl <- function(name) {
  dir_create(session_path(name))
}
