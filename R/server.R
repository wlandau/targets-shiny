server <- function(input, output, session) {
  updatePickerInput(
    session = session,
    inputId = "project",
    selected = project_get(),
    choices = project_list()
  )
  observeEvent(input$project_create, {
    project_create(input$project_new)
    project_set(input$project_new)
    updatePickerInput(
      session = session,
      inputId = "project",
      selected = input$project_new,
      choices = project_list()
    )
  })
  observe({
    req(input$project)
    project_set(input$project)
  })
}
