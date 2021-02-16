# Run the pipeline in a new background process if no such
# process is already running in the current project.
process_run <- function() {
  if (!project_exists()) return()
  if (process_running()) return()
  args <- list(
    cleanup = FALSE, # Important! Otherwise, gc() will end the process.
    supervise = FALSE, # Otherwise, the process will quit if we log out.
    stdout = project_stdout(),
    stderr = project_stderr()
  )
  # Here is where we actually run the pipeline:
  px <- tar_make(callr_function = r_bg, callr_arguments = args)
  # Do not give back control until the pipeline write a _targets/meta/process
  # file with the PID of the main process.
  while(process_not_done(px) && !tar_exist_process()) Sys.sleep(0.05)
  # Do not give back control until the PID in _targets/meta/process
  # agrees with the PID of the process handle we have in memory.
  while(process_not_done(px) && !process_agrees(px)) Sys.sleep(0.05)
}

# Cancel the process if it is running.
process_cancel <- function() {
  if (!project_exists()) return()
  if (!process_running()) return()
  ps_kill(ps_handle(tar_pid()))
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

# The PID in _targets/meta/process must agree with the
# in-memory handle we get when we first launch the pipeline.
process_agrees <- function(px) {
  identical(px$get_pid(), tar_pid())
}

# Show a nice shinybusy spinner if and only if the pipeline
# is running. We toggle this with a reactive that gets invalidated
# when the pipeline stops or starts.
process_spinner <- function() {
  if (process_running()) {
    show_spinner()
  } else {
    hide_spinner()
  }
}
