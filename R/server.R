server <- function(input, output, session) {
  output$session_choose <- renderUI(
    pickerInput(
      inputId = "session_choose",
      label = NULL,
      choices = session_list(),
      selected = "main",
      multiple = FALSE
    )
  )
}
