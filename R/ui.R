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
  bs4SidebarMenuItem("About", tabName = "about", icon = "info"),
  bs4SidebarMenuItem("Control", tabName = "control", icon = "cog"),
  bs4SidebarMenuItem("Progress", tabName = "progress", icon = "spinner"),
  bs4SidebarMenuItem("Results", tabName = "results", icon = "chart-area")
)

sidebar <- bs4DashSidebar(
  skin = "light",
  inputId = "sidebar",
  menu
)

ui <- bs4DashPage(
  title = "app",
  body = bs4DashBody(tabs),
  navbar = bs4DashNavbar(controlbarIcon = NULL),
  sidebar = sidebar
)
