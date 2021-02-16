source("R/packages.R")
source("R/ui.R") # Sources multiple UI helper scripts.
source("R/server.R")
source("R/project.R")
source("R/pipeline.R")
source("R/process.R")
source("R/results.R")
source("R/logs.R")
shinyApp(ui = ui, server = server)
