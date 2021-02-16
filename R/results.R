results_plot <- function() {
  if (tar_exist_objects("plot")) {
    return(tar_read(plot))
  }
  ggplot() +
    geom_text(aes(label = "No results yet.", x = 0, y = 0), size = 16) +
    theme_void()
}

results_hash <- function() {
  ifelse(
    tar_exist_objects("plot"),
    tar_meta(plot, data)$data,
    NA_character_
  )
}
