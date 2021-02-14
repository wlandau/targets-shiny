source("R/ui_control.R")
source("R/ui_progress.R")

tabs <- bs4TabItems(
  tab_control,
  tab_progress
)

menu <- bs4SidebarMenu(
  id = "menu",
  bs4SidebarMenuItem("Control", tabName = "control", icon = "cog"),
  bs4SidebarMenuItem("Progress", tabName = "progress", icon = "spinner")
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
