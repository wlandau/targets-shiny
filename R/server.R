server <- function(input, output, session) {
  session_choices <- reactiveValues(names = session_list())
  output$session_choose <- renderUI(
    pickerInput(
      inputId = "session_choose",
      label = NULL,
      choices = session_choices$names,
      selected = "main",
      multiple = FALSE
    )
  )
  observeEvent(input$session_create, {
    session_create(input$session_new)
    session_choices$names <- session_list()
  })
}
