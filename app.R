source("R/packages.R")
source("R/ui.R") # Sources multiple UI helper scripts.
source("R/server.R")
source("R/project.R")
source("R/pipeline.R")
# source("R/process.R") # Uncomment to run pipelines as local server-side processes.
source("R/process_sge.R") # Uncomment to run pipelines as jobs on a Sun Grid Engine (SGE) cluster.
source("R/results.R")
source("R/logs.R")
source("R/transient.R")
shinyApp(ui = ui, server = server)
