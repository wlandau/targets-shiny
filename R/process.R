process_run <- function() {
  if (project_undefined()) return()
  if (process_running()) return()
  log <- project_path(project_get(), "log.txt")
  args <- list(supervise = TRUE, stdout = log, stderr = log)
  tar_make(callr_function = r_bg, callr_arguments = args)
}

process_cancel <- function() {
  if (project_undefined()) return()
  if (!process_running()) return()
  ps_kill(ps_handle(tar_pid()))
}

process_running <- function() {
  tar_exist_process() && (tar_pid() %in% ps_pids())
}

