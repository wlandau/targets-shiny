card_stdout <- card(
  id = "stdout",
  tags$h3("Standard output"),
  tags$hr(),
  textOutput("stdout"),
  # Makes sure the stdout log has appropriate line breaks and scrolling:
  tags$head(tags$style("#stdout {white-space: pre-wrap}"))
)

card_stderr <- card(
  id = "stderr",
  tags$h3("Standard error"),
  tags$hr(),
  textOutput("stderr"),
  tags$head(tags$style("#stderr {white-space: pre-wrap}"))
)
