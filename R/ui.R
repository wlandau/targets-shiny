source("R/ui_control.R")
source("R/ui_results.R")
source("R/ui_logs.R")
source("R/ui_about.R")

ui <- page_navbar(
  title = "App",
  
nav_panel(
    title = "Controls",
    layout_columns(
      col_widths = 6,
      card_create,
      card_select,
      card_models,
      card_run
    ),
    shinyjs::useShinyjs()
  ),
  
  nav_panel(
    title = "About",
    card_about
  ),
  
  nav_panel(
    title = "Progress",
    tar_watch_ui("targets-shiny", seconds = 15, targets_only = TRUE)
  ),
  nav_panel(
    title = "Logs",
    layout_columns(
      col_widths = 6,
      card_stdout,
      card_stderr
    )
  ),
  nav_panel(
    title = "Results",
     layout_columns(
       col_widths = 6,
       card_interpretation,
       card_association
     )
  )
)
