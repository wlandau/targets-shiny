library(shiny)
Sys.unsetenv("TARGETS_SHINY_HOME")
Sys.setenv(TARGETS_SHINY_TRANSIENT = "false")
runApp()
# Run a long pipeline, close the app, open it again, and verify
# that the pipeline is still running.
