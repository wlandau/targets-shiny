server <- function(input, output, session) {
  projects <- reactiveValues(
    active = project_get(),
    choices = project_list()
  )
  output$project_active <- renderUI({
    browser()
    pickerInput(
      inputId = "project_active",
      label = NULL,
      selected = projects$active,
      choices = projects$choices,
      multiple = FALSE
    )
  })
  observe({
    req(input$project_active)
    browser()
    projects$active <- input$project_active
    project_set(projects$active)
  })
  observeEvent(input$project_create, {
    req(input$project_new)
    project_create(input$project_new)
    projects$choices <- project_list()
    projects$active <- input$project_new
    project_set(projects$active)
  })
}
