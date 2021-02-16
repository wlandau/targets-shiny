log_html <- function(path) {
  HTML(paste(readLines(path), collapse = "<br>"))
}
