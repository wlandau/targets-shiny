server <- function(input, output, session) {
  session_active_restore()
  sessions <- reactiveValues(
    active = session_active_get(),
    choices = session_list()
  )
  output$session_active <- renderUI(
    pickerInput(
      inputId = "session_active",
      label = NULL,
      choices = sessions$choices,
      selected = sessions$active,
      multiple = FALSE
    )
  )
  observe({
    sessions$active <- input$session_active
  })
  observeEvent(input$session_create, {
    session_create(input$session_new)
    sessions$choices <- session_list()
  })
}
