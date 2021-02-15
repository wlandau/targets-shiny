process_run <- function() {
  if (!process_running()) {
    tar_make(callr_function = r_bg, callr_arguments = list(supervise = TRUE))
  }
}

process_cancel <- function() {
  if (process_running()) {
    ps_kill(ps_handle(tar_pid()))
  }
}

process_running <- function() {
  pid <- tryCatch(tar_pid(), error = function(e) NA_integer_)
  if (anyNA(pid)) {
    return(FALSE)
  }
  ps_is_running(ps_handle(pid))
}
