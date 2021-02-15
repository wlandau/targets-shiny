server <- function(input, output, session) {
  project_ui()
  observe({
    req(input$project)
    project_set(input$project)
  })
  observeEvent(input$project_create, {
    project_create(input$project_new)
    project_set(input$project_new)
    project_ui(input$project_new)
  })

}
