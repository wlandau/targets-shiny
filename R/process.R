process_run <- function() {
  if (project_undefined()) return()
  if (process_running()) return()
  log <- project_path(project_get(), "log.txt")
  args <- list(supervise = TRUE, stdout = log, stderr = log)
  px <- tar_make(callr_function = r_bg, callr_arguments = args)
  while(process_not_done(px) && !tar_exist_process()) Sys.sleep(0.05)
  while(process_not_done(px) && !process_agrees(px)) Sys.sleep(0.05)
}

process_cancel <- function() {
  if (project_undefined()) return()
  if (!process_running()) return()
  ps_kill(ps_handle(tar_pid()))
}

process_running <- function() {
  tar_exist_process() && (tar_pid() %in% ps_pids())
}

process_not_done <- function(px) {
  is.null(px$get_exit_status())
}

process_agrees <- function(px) {
  identical(px$get_pid(), tar_pid())
}
