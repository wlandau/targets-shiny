server <- function(input, output, session) {
  project_select()
  project_load()
  tar_watch_server("targets-shiny")
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
  observeEvent(input$run_start, process_run())
  observeEvent(input$run_cancel, process_cancel())
  output$plot <- renderPlot(tar_read(plot))
}
