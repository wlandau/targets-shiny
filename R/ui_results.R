card_interpretation <- bs4Card(
  inputID = "interpretation",
  title = "Interpretation",
  status = "primary",
  solidHeader = TRUE,
  width = 4,
  includeMarkdown("doc/interpretation.md")
)

card_association <- bs4Card(
  inputID = "association",
  title = "Association",
  status = "success",
  solidHeader = TRUE,
  width = 8,
  withSpinner(plotOutput("plot"))
)

tab_results <- bs4TabItem(
  "results",
  fluidRow(card_interpretation, card_association)
)
