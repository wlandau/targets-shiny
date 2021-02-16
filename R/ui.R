source("R/ui_control.R")
source("R/ui_results.R")
source("R/ui_progress.R")
source("R/ui_logs.R")
source("R/ui_about.R")

tabs <- bs4TabItems(
  tab_control,
  tab_results,
  tab_progress,
  tab_logs,
  tab_about
)

menu <- bs4SidebarMenu(
  id = "menu",
  bs4SidebarMenuItem("Control", tabName = "control", icon = icon("cog")),
  bs4SidebarMenuItem("Results", tabName = "results", icon = icon("chart-area")),
  bs4SidebarMenuItem("Progress", tabName = "progress", icon = icon("spinner")),
  bs4SidebarMenuItem("Logs", tabName = "logs", icon = icon("file")),
  bs4SidebarMenuItem("About", tabName = "about", icon = icon("info"))
)

ui <- bs4DashPage(
  title = "app",
  body = bs4DashBody(use_busy_spinner(spin = "cube-grid"), tabs),
  header = bs4DashNavbar(controlbarIcon = NULL),
  sidebar = bs4DashSidebar(skin = "light", inputId = "sidebar", menu),
  dark = FALSE
)
