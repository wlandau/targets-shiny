server <- function(input, output, session) {
  # Important! This app changes working directories to switch projects
  # (a requirement of the targets package).
  # So we need to reset the working directory when the app exits.
  # The proper way t odo this is with a Shiny callback.
  # Simple on.exit() will not work.
  dir <- getwd()
  session$onSessionEnded(function() setwd(dir))
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
  tar_watch_server("targets-shiny")
  # Define a special reactive to invalidate contexts
  # when a pipeline starts or stops.
  process <- reactiveValues(running = process_running())
  # Repeatedly check if the pipeline switched from stopped to running
  # or vice versa.
  observe({
    invalidateLater(millis = 100)
    process$running <- process_running()
  })
  # Show/hide the run buttons depending on whether the pipeline is running.
  observe({
    process$running
    process_button()
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
  # and switch the app to the new project. Settings are copied over
  # from the previously selected project.
  observeEvent(input$project_create, {
    req(input$project_new)
    project_create(input$project_new)
    project_select(input$project_new)
    project_set(input$project_new)
    project_save(input$biomarkers, input$iterations)
  })
  # When the user presses the button to delete a project,
  # remove the current project's files and switch to the next
  # available project. Be sure to cancel the deleted project's pipeline
  # first.
  observeEvent(input$project_delete, {
    process_cancel()
    project_delete(input$project)
    project_select(project_head())
  })
  # Run the pipeline if the user presses the appropriate button.
  observeEvent(input$run_start, process_run())
  # Stop the pipeline if the user presses the appropriate button.
  observeEvent(input$run_cancel, process_cancel())
  # Refresh the latest plot output when the pipeline stops.
  output$plot <- renderPlot({
    req(input$project)
    process$running
    results_plot()
  })
  # Continuously refresh the stdout log file while the pipeline is running.
  output$stdout <- renderText({
    req(input$project)
    if (process$running) invalidateLater(100)
    log_text(project_stdout(), input$stdout_tail)
  })
  # Continuously refresh the stdout log file while the pipeline is running.
  output$stderr <- renderText({
    req(input$project)
    if (process$running) invalidateLater(100)
    log_text(project_stderr(), input$stderr_tail)
  })
}
