card_create <- card(
  id = "project_create",
  textInput(
    inputId = "project_new",
    label = NULL,
    value = NULL,
    placeholder = "Name of new project"
  ),
  actionBttn(
    inputId = "project_create",
    label = "Create empty project",
    color = "primary",
    style = "simple"
  ),
  actionBttn(
    inputId = "project_copy",
    label = "Copy current project",
    color = "primary",
    style = "simple"
  )
)

card_select <- card(
  id = "project",
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
    color = "royal"
  )
)

card_models <- card(
  id = "models",
  disabled(
    checkboxGroupInput(
      inputId = "biomarkers",
      label = "Biomarkers", 
      choices = c("albumin", "log_bilirubin", "log_platelet"),
      selected = c("albumin", "log_bilirubin"),
      inline = TRUE
    )
  ),
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

card_run <- card(
  id = "run",
  hidden(
    actionBttn(
      inputId = "run_start",
      label = "Run pipeline",
      style = "simple",
      color = "success"
    )
  ),
  hidden(
    actionBttn(
      inputId = "run_cancel",
      label = "Cancel pipeline",
      style = "simple",
      color = "warning"
    )
  ),
  hidden(
    actionBttn(
      inputId = "run_processing",
      label = "Processing...",
      style = "simple",
      color = "royal"
    )
  )
)
