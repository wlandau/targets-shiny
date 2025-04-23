card_interpretation <- card(
  id = "interpretation",
  includeMarkdown("doc/interpretation.md")
)

card_association <- card(
  id = "association",
  plotOutput("plot")
)
