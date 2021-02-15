source("R/ui_about.R")
source("R/ui_control.R")
source("R/ui_progress.R")
source("R/ui_results.R")

tabs <- bs4TabItems(
  tab_about,
  tab_control,
  tab_progress,
  tab_results
)

menu <- bs4SidebarMenu(
  id = "menu",
  bs4SidebarMenuItem("About", tabName = "about", icon = icon("info")),
  bs4SidebarMenuItem("Control", tabName = "control", icon = icon("cog")),
  bs4SidebarMenuItem("Progress", tabName = "progress", icon = icon("spinner")),
  bs4SidebarMenuItem("Results", tabName = "results", icon = icon("chart-area"))
)

ui <- bs4DashPage(
  title = "app",
  body = bs4DashBody(tabs),
  header = bs4DashNavbar(controlbarIcon = NULL),
  sidebar = bs4DashSidebar(skin = "light", inputId = "sidebar", menu),
  dark = FALSE
)
