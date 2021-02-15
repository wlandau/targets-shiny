server <- function(input, output, session) {
  project_ui()
  observe({
    req(input$project)
    project_set(input$project)
  })
  observeEvent(input$project_create, {
    project_create(input$project_new)
    project_select(input$project_new)
  })
  observeEvent(input$project_delete, {
    project_delete(input$project)
    project_select()
  })
}
