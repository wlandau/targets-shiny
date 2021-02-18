# Show/hide the run buttons depending on whether the pipeline is running.
control_set <- function() {
  if (process_running()) {
    control_running()
  } else {
    control_stopped()
  }
}

# Allow the user to modify inputs and run a new pipeline.
control_running <- function() {
  hide("run_start")
  disable("biomarkers")
  disable("iterations")
  show("run_cancel")
}

# Disable UI inputs and prevent new pipelines from starting
# while a pipeline is already running.
control_stopped <- function() {
  hide("run_cancel")
  enable("biomarkers")
  enable("iterations")
  show("run_start")
}
