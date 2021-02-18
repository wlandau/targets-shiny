# Prep the contents of a stdout or stderr log for
# renderText() and textOutput().
log_text <- function(path, tail_only) {
  if (!(length(path) && file.exists(path))) return()
  out <- readLines(path, warn = FALSE)
  if (tail_only) out <- tail(out, n = 25)
  paste0(out, collapse = "\n")
}
