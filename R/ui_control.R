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
    placeholder = "Name of new project"
  ),
  fluidRow(
    actionBttn(
      inputId = "project_create",
      label = "Create empty project",
      style = "simple",
      color = "primary",
      size = "sm",
      block = FALSE,
      no_outline = TRUE
    ),
    div(
      style = "padding-left: 10px",
      actionBttn(
        inputId = "project_copy",
        label = "Copy current project",
        style = "simple",
        color = "primary",
        size = "sm",
        block = FALSE,
        no_outline = TRUE
      )
    )
  )
)

card_select <- bs4Card(
  inputID = "project",
  title = "Select active project",
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
    color = "royal",
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
  disabled(
    awesomeCheckboxGroup(
      inputId = "biomarkers",
      label = "Biomarkers", 
      choices = c("albumin", "log_bilirubin", "log_platelet"),
      selected = c("albumin", "log_bilirubin"),
      status = "primary",
      inline = TRUE
    )
  ),
  chooseSliderSkin("Flat", color = "blue"),
  disabled(
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
)

card_run <- bs4Card(
  inputID = "run",
  title = "Run pipeline",
  status = "primary",
  solidHeader = TRUE,
  width = 12,
  fluidRow(
    hidden(
      actionBttn(
        inputId = "run_start",
        label = "Run pipeline",
        style = "simple",
        color = "success",
        size = "sm",
        block = FALSE,
        no_outline = TRUE
      )
    ),
    hidden(
      actionBttn(
        inputId = "run_cancel",
        label = "Cancel pipeline",
        style = "simple",
        color = "warning",
        size = "sm",
        block = FALSE,
        no_outline = TRUE
      )
    ),
    div(
      style = "margin-left: 10px",
      hidden(
        actionBttn(
          inputId = "run_processing",
          label = "Processing...",
          style = "simple",
          color = "royal",
          size = "sm",
          block = FALSE,
          no_outline = TRUE
        )
      )
    )
  )
)

tab_control <- bs4TabItem(
  "control",
  fluidRow(
    column(6, card_select, card_create),
    column(6, card_run, card_models)
  )
)
