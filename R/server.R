server <- function(input, output, session) {
  projects <- reactiveValues(
    active = project_get(),
    choices = project_list()
  )
  output$project_active <- renderUI(
    pickerInput(
      inputId = "project_active",
      label = NULL,
      choices = projects$choices,
      selected = projects$active,
      multiple = FALSE
    )
  )
  observe({
    req(input$project_active)
    projects$active <- input$project_active
    project_set(projects$active)
  })
  observeEvent(input$project_create, {
    req(input$project_new)
    project_create(input$project_new)
    projects$active <- input$project_new
    projects$choices <- project_list()
    project_set(input$project_new)
  })
}
