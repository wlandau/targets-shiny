card_interpretation <- bs4Card(
  inputID = "interpretation",
  title = "Interpretation",
  status = "primary",
  width = 4,
  includeMarkdown("doc/interpretation.md")
)

card_association <- bs4Card(
  inputID = "association",
  title = "Association",
  status = "success",
  width = 8,
  div("read the plot")
)

tab_results <- bs4TabItem(
  "results",
  fluidRow(card_interpretation, card_association)
)
