server <- function(input, output, session) {
  project_select()
  project_load()
  observe({
    req(input$project)
    project_set(input$project)
    project_load()
  })
  observe({
    req(input$biomarkers)
    req(input$iterations)
    project_save(input$biomarkers, input$iterations)
  })
  observeEvent(input$project_create, {
    project_create(input$project_new)
    project_select(input$project_new)
    project_set(input$project_new)
    project_save(input$biomarkers, input$iterations)
  })
  observeEvent(input$project_delete, {
    project_delete(input$project)
    project_select(project_head())
  })
}
