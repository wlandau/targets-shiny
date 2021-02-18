# Show/hide the run buttons depending on whether the pipeline is running.
control_set <- function() {
  if (process_running()) {
    control_running()
  } else {
    control_stopped()
    control_processed()
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

# Show a "Processing..." indicator while the app is cancelling jobs.
control_processing <- function() {
  show("run_processing")
}

# Hide "Processing..."
control_processed <- function() {
  hide("run_processing")
}
