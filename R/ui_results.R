card_association <- bs4Card(
  inputID = "association",
  title = "Association",
  status = "success",
  width = 8,
  div("read the plot")
)

tab_results <- bs4TabItem(
  "results",
  fluidRow(
    card_association
  )
)
