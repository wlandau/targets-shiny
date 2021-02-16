card_about <- bs4Card(
  inputID = "about",
  title = "About",
  status = "primary",
  solidHeader = TRUE,
  width = 12,
  includeMarkdown("README.md")
)

tab_about <- bs4TabItem("about", card_about)
