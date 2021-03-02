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
    "In addition, depending on the platform,",
    "some processes may terminate if you spawn too many",
    "pipelines at a time.",
    "Visit the 'About' tab to learn how to create",
    "persistent projects and launch persistent jobs",
    "on supporting infrastructure. That way, the app",
    "can recover running jobs and saved data",
    "when the user logs back in."
  )
  shinyalert("Transient mode", text = text, type = "info")
}
