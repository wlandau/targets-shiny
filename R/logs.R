log_text <- function(path) {
  if (file.exists(path)) {
    paste0(readLines(path), collapse = "\n")
  }
}
