results_plot <- function() {
  store <- project_path(project_get(), "_targets")
  if (tar_exist_objects("plot", store = store)) {
    return(tar_read(plot, store = store))
  }
  ggplot() +
    geom_text(aes(label = "No results yet.", x = 0, y = 0), size = 16) +
    theme_void()
}
