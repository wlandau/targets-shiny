server <- function(input, output, session) {
  # Clear logs from deleted projects
  project_clear_logs()
  # Alert users if the app is in transient mode.
  transient_alert()
  # Load the saved settings of the project into the biomarker
  # dropdown and iterations slider. This is important to do
  # before project_select() because of the reactivity loop.
  project_load()
  # Identify the set project in the _project file
  # and populate the dropdown menu.
  project_select()
  # The tar_watch() module powers the "Progress" tab.
  # This is the server-side component.
  tar_watch_server("targets-shiny", config = project_config())
  # Define a special reactive to invalidate contexts
  # when a pipeline starts or stops.
  process <- reactiveValues(status = process_status())
  observe({
    invalidateLater(millis = 5000)
    process$status <- process_status()
  })
  # Refresh the UI to indicate whether the pipeline is running.
  observe({
    process$status
    control_set()
  })
  # Every time the user selects a project in the drop-down menu
  # of the "Control" tab, switch to that project and load the settings.
  observe({
    req(input$project)
    project_set(input$project)
    project_load()
  })
  # Every time the user tweaks the pipeline settings,
  # update the project's files settings.rds and _targets.R
  # The former ensures the project is recovered after a logout,
  # and the latter defines a pipeline with the user's new settings.
  observe({
    req(input$biomarkers)
    req(input$iterations)
    project_save(input$biomarkers, input$iterations)
  })
  # When the user presses the button to create a project,
  # create a new project folder, populate it with the required files,
  # and switch the app to the new project.
  # Settings revert to the global defaults.
  observeEvent(input$project_create, {
    req(input$project_new)
    project_create(input$project_new)
  })
  # For copied projects, copy over all the project files except
  # _targets/meta/process (with the PID) and `id` (with the job ID).
  observeEvent(input$project_copy, {
    req(input$project_new)
    project_copy(input$project_new)
  })
  # When the user presses the button to delete a project,
  # remove the current project's files and switch to the next
  # available project. Be sure to cancel the deleted project's pipeline
  # first.
  observeEvent(input$project_delete, {
    req(input$project)
    process_cancel()
    project_delete(input$project)
  })
  # Run the pipeline if the user presses the appropriate button.
  observeEvent(input$run_start, process_run())
  # Stop the pipeline if the user presses the appropriate button.
  observeEvent(input$run_cancel, process_cancel())
  # Refresh the latest plot output when the pipeline starts or stops
  # or when the user switches the project.
  output$plot <- renderPlot({
    req(input$project)
    process$status
    results_plot()
  })
  # Continuously refresh the stdout log file while the pipeline is running.
  # Also refresh when the pipeline starts or stops
  # and when the user switches projects.
  output$stdout <- renderText({
    req(input$project)
    process$status
    if (process$status$running) invalidateLater(millis = 250)
    log_text(project_stdout(), input$stdout_tail)
  })
  # Same for stderr.
  output$stderr <- renderText({
    req(input$project)
    process$status
    if (process$status$running) invalidateLater(millis = 250)
    log_text(project_stderr(), input$stderr_tail)
  })
}
