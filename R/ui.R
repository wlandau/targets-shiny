card_biomarkers <- bs4Card(
  inputID = "control",
  title = "Control",
  status = "primary",
  closable = FALSE,
  collapsible = FALSE,
  width = 3,
  pickerInput(
    inputId = "biomarkers",
    label = NULL,
    choices = c("albumin", "log_bilirubin", "log_platelet"),
    selected = c("albumin", "log_bilirubin"),
    multiple = TRUE,
    options = pickerOptions(
      actionsBox = TRUE,
      deselectAllText = "none",
      selectAllText = "all",
      noneSelectedText = "no label"
    )
  )
)

tab_control <- bs4TabItem(
  "control",
  fluidRow(
    card_biomarkers
  )
)

tabs <- bs4TabItems(
  tab_control
)

menu <- bs4SidebarMenu(
  id = "menu",
  bs4SidebarMenuItem("Control", tabName = "control", icon = "shuttle-van")
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
