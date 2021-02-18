# Detect if storage is transient and projects will vanish on logout.
# The app author needs to know this in advance and set the
# TARGETS_SHINY_TRANSIENT environment variable.
transient_active <- function() {
  env <- Sys.getenv("TARGETS_SHINY_TRANSIENT")
  identical(trimws(tolower(env)), "true")
}

# Alert the user if the project is transient
transient_alert <- function() {
  if (!transient_active()) {
    return()
  }
  text <- paste(
    "This app is running in transient mode.",
    "When you log out, all your pipelines will stop",
    "and all your projects will vanish.",
    "Visit the 'About' tab to learn how to create",
    "persistent projects and jobs on supporting infrastructure."
  )
  shinyalert("Transient mode", text = text, type = "info")
}
