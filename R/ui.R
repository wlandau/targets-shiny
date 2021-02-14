card_sessions <- bs4Card(
  inputID = "sessions",
  title = "Sessions",
  status = "primary",
  closable = FALSE,
  collapsible = FALSE,
  width = 6,
  actionBttn(
    inputId = "session_create",
    label = "Create new session",
    style = "simple",
    color = "primary",
    size = "sm",
    block = FALSE,
    no_outline = TRUE
  ),
  br(),
  br(),
  textInput(
    inputId = "session_new",
    label = NULL,
    value = NULL,
    placeholder = "session_name"
  ),
  pickerInput(
    inputId = "session_choose",
    label = "Choose session",
    choices = c("main", "other"),
    selected = "main",
    multiple = FALSE
  )
)

card_models <- bs4Card(
  inputID = "control",
  title = "Control",
  status = "primary",
  closable = FALSE,
  collapsible = FALSE,
  width = 6,
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
  bs4Sortable(
    card_sessions,
    card_models
  )
)

tabs <- bs4TabItems(
  tab_control
)

menu <- bs4SidebarMenu(
  id = "menu",
  bs4SidebarMenuItem("Control", tabName = "control", icon = "cog")
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
