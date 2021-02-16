card_stdout <- bs4Card(
  inputID = "stdout",
  title = "stdout",
  status = "primary",
  solidHeader = TRUE,
  width = 6,
  textOutput("stdout"),
  tags$head(tags$style("#stdout {white-space: pre-wrap; overflow-y:scroll; max-height: 600px;}"))
)

card_stderr <- bs4Card(
  inputID = "stderr",
  title = "stderr",
  status = "primary",
  solidHeader = TRUE,
  width = 6,
  textOutput("stderr"),
  tags$head(tags$style("#stderr {white-space: pre-wrap; overflow-y:scroll; max-height: 600px;}"))
)

tab_logs <- bs4TabItem("logs", fluidRow(card_stdout, card_stderr))
