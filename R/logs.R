# Prep the contents of a stdout or stderr log for
# renderText() and textOutput().
log_text <- function(path) {
  if (file.exists(path)) {
    paste0(readLines(path), collapse = "\n")
  }
}
