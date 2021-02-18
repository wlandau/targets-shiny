# The default behavior of the app is to run the pipeline
# as a local background process on the Shiny server.
if (identical(Sys.getenv("TARGETS_SHINY_BACKEND"), "")) {

# Run the pipeline in a new background process if no such
# process is already running in the current project.
process_run <- function() {
  if (!project_exists()) return()
  if (process_running()) return()
  control_running()
  control_processing()
  on.exit(control_processed())
  args <- list(
    cleanup = FALSE, # Important! Garbage collection should not kill the process.
    supervise = transient_active(), # Otherwise, the process will quit if we log out.
    stdout = project_stdout(),
    stderr = project_stderr()
  )
  # Here is where we actually run the pipeline:
  px <- tar_make(callr_function = r_bg, callr_arguments = args)
  # Do not give back control until the pipeline write a _targets/meta/process
  # file with the PID of the main process.
  while (process_not_done(px) && !tar_exist_process()) Sys.sleep(0.05)
  # Do not give back control until the PID in _targets/meta/process
  # agrees with the PID of the process handle we have in memory.
  while (process_not_done(px) && !process_agrees(px)) Sys.sleep(0.05)
}

# Cancel the process if it is running.
process_cancel <- function() {
  if (!project_exists()) return()
  if (!process_running()) return()
  control_processing()
  ps_kill(ps_handle(tar_pid()))
}

# Get the process ID of the pipeline if it exists
process_id <- function() {
  if (!project_exists() || !tar_exist_process()) return(NA_integer_)
  tar_pid()
}

# Read the _targets/meta/process file to get the PID of the pipeline
# and check if it is running.
process_running <- function() {
  tar_exist_process() && (tar_pid() %in% ps_pids())
}

# Check if the in-memory processx handle reported an exit status yet.
process_not_done <- function(px) {
  is.null(px$get_exit_status())
}

# Status indicator that changes whenever a pipeline starts or stops.
# Useful as a reactive value to update the UI at the proper time.
process_status <- function() {
  list(pid = process_id(), running = process_running())
}

# The PID in _targets/meta/process must agree with the
# in-memory handle we get when we first launch the pipeline.
process_agrees <- function(px) {
  identical(px$get_pid(), tar_pid())
}

}
