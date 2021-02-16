card_stdout <- bs4Card(
  inputID = "stdout",
  title = "stdout",
  status = "primary",
  solidHeader = TRUE,
  width = 6,
  textOutput("stdout")
)

card_stderr <- bs4Card(
  inputID = "stderr",
  title = "stderr",
  status = "primary",
  solidHeader = TRUE,
  width = 6,
  textOutput("stderr")
)

tab_logs <- bs4TabItem("logs", fluidRow(card_stdout, card_stderr))
