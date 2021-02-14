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
  list.dirs(session_user())
}
