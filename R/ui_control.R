card_create <- bs4Card(
  inputID = "project_create",
  title = "New project",
  status = "primary",
  solidHeader = TRUE,
  width = 12,
  textInput(
    inputId = "project_new",
    label = NULL,
    value = NULL,
    placeholder = "new_project_name"
  ),
  actionBttn(
    inputId = "project_create",
    label = "Create new project",
    style = "simple",
    color = "primary",
    size = "sm",
    block = FALSE,
    no_outline = TRUE
  )
)

card_select <- bs4Card(
  inputID = "project",
  title = "Select project",
  status = "primary",
  solidHeader = TRUE,
  width = 12,
  pickerInput(
    inputId = "project",
    label = NULL,
    selected = character(0),
    choices = character(0),
    multiple = FALSE
  ),
  actionBttn(
    inputId = "project_delete",
    label = "Delete selected project",
    style = "simple",
    color = "primary",
    size = "sm",
    block = FALSE,
    no_outline = TRUE
  )
)

card_models <- bs4Card(
  inputID = "models",
  title = "Models",
  status = "primary",
  solidHeader = TRUE,
  width = 12,
  pickerInput(
    inputId = "biomarkers",
    label = "Biomarkers",
    choices = c("albumin", "log_bilirubin", "log_platelet"),
    selected = c("albumin", "log_bilirubin"),
    multiple = TRUE,
    options = pickerOptions(
      actionsBox = TRUE,
      deselectAllText = "none",
      selectAllText = "all",
      noneSelectedText = "no label"
    )
  ),
  chooseSliderSkin("Flat", color = "blue"),
  sliderInput(
    inputId = "iterations",
    label = "Iterations",
    value = 1000,
    min = 100,
    max = 10000,
    step = 100,
    ticks = FALSE
  )
)

card_run <- bs4Card(
  inputID = "run",
  title = "Run",
  status = "primary",
  solidHeader = TRUE,
  width = 12,
  actionBttn(
    inputId = "run_start",
    label = "Run pipeline",
    style = "simple",
    color = "success",
    size = "sm",
    block = FALSE,
    no_outline = TRUE
  ),
  br(),
  br(),
  actionBttn(
    inputId = "run_cancel",
    label = "Cancel run",
    style = "simple",
    color = "danger",
    size = "sm",
    block = FALSE,
    no_outline = TRUE
  )
)

tab_control <- bs4TabItem(
  "control",
  fluidRow(
    column(6, card_create, card_select),
    column(6, card_run, card_models)
  )
)
