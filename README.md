This prototype app demonstrates how to create powerful data analysis tools with Shiny and [`targets`](https://docs.ropensci.org/targets/). The app manages multiple pipelines across multiple clients, and it ensures that user storage and background processes persist after logout. Because of [`targets`](https://docs.ropensci.org/targets/), subsequent runs skip computationally expensive steps that are already up to date.

## Case study

Bayesian joint models of survival and longitudinal non-survival outcomes reduce bias and describe relationships among endpoints ([Gould et al. 2015](https://pubmed.ncbi.nlm.nih.gov/24634327/)). Statisticians routinely refine and explore such complicated models ([Gelman et al. 2020](https://arxiv.org/abs/2011.01808)), but the computation is so slow that routine changes are tedious to refresh. This app shows how [`targets`](https://docs.ropensci.org/targets/) can speed up iteration and Shiny can ease the burden of code development for established use cases.

## Usage

When you first open the app, create a new project to establish a data analysis pipeline. You can create, switch, and delete projects at any time. Next, select the biomarkers and number of Markov chain Monte Carlo iterations. The pipeline will run one [univariate joint model](https://mc-stan.org/rstanarm/articles/jm.html#univariate-joint-model-current-value-association-structure) on each biomarker for the number of iterations you select. Each model analyzes [`rstanarm`](https://mc-stan.org/rstanarm/) datasets [`pbcLong`](https://mc-stan.org/rstanarm/reference/rstanarm-datasets.html) and [`pbcSurv`](https://mc-stan.org/rstanarm/reference/rstanarm-datasets.html) to jointly model survival (time to event) and the biomarker (longitudinally).

Click the "Run pipeline" button to run the correct models in the correct order. The app button replaces the "Run pipeline" button with the the "Cancel pipeline" button when the pipeline of the current project is running in the background. The pipeline will run to completion even if you switch projects, log out, or get disconnected for idleness.

While the pipeline is running, the Progress and Logs tabs continuously refresh to monitor progress. The Progress tab uses the [`tar_watch()`](https://docs.ropensci.org/targets/reference/tar_watch.html) Shiny module, available through the functions [`tar_watch_ui()`](https://docs.ropensci.org/targets/reference/tar_watch_ui.html) and [`tar_watch_server()`](https://docs.ropensci.org/targets/reference/tar_watch_server.html).

The Results tab refreshes the final plot every time the pipeline stops. The plot shows the marginal posterior distribution of the association parameter between mortality and the longitudinal biomarker.

## Administration

1. Optional: to customize the location of persistent storage, create an `.Renviron` file at the app root and set the `TARGETS_SHINY_HOME` environment variable. If you do, the app will store projects within `file.path(Sys.getenv("TARGETS_SHINY_HOME"), Sys.getenv("USER"), ".targets-shiny")`. Otherwise, storage will default to `tools::R_user_dir("targets-shiny", which = "cache")`
2. To support persistent pipelines, deploy the app to [Shiny Server](https://rstudio.com/products/shiny/shiny-server/), [RStudio Connect](https://rstudio.com/products/connect/), or other service that supports persistent server-side storage. Alternatively, if you just want to demo the app on a limited service such as [shinyapps.io](https://www.shinyapps.io), set the `TARGETS_SHINY_TRANSIENT` environment variable to `"true"` in the `.Renviron` file in the app root directory. That way, the UI alerts the users that their projects are transient, the app writes to temporary storage (overriding `TARGETS_TRANSIENT_HOME`), and background processes terminate when the app exits.
3. Require a login so the app knows the user name.
4. Run the app as the logged-in user, not the system administrator or default user.
5. If applicable, raise automatic timeout thresholds in [RStudio Connect](https://rstudio.com/products/connect/) so the background processes running pipelines remain alive long enough to finish.

## Development

Shiny apps with [`targets`](https://docs.ropensci.org/targets/) require specialized techniques such as user storage and persistent background processes.

### User storage

[`targets`](https://docs.ropensci.org/targets/) writes to storage to ensure the pipeline stays up to date after R exits. This storage must be persistent and user-specific. This particular app defaults to `tools::R_user_dir("app_name", which = "cache")` but uses `file.path(Sys.getenv("TARGETS_SHINY_HOME"), Sys.getenv("USER"))` if `TARGETS_SHINY_HOME` is defined in the `.Renviron` file at the app root directory. In addition, it is best to deploy to a service like [Shiny Server](https://rstudio.com/products/shiny/shiny-server/) or [RStudio Connect](https://rstudio.com/products/connect/) and provision enough space for the expected number of users.

### Multiple projects

Projects manage multiple versions of the pipeline. In this app, each project is a directory inside user storage with app input settings, pipeline configuration, and results. A top-level `_project` file identifies the current active project. Functions in `R/project.R` configure, load, create, and destroy projects. The `update*()` functions in Shiny and `shinyWidgets`, such as `updateSliderInput()`, are particularly handy for restoring the input settings of a saved project. That is why this app does not need a single `renderUI()` or `uiOutput()`.

### Working directory

For reasons [described here](https://github.com/ropensci/targets/discussions/297), the `_targets.R` configuration file and `_targets/` data store always live at the root directory of the pipeline (where you run [`tar_make()`](https://docs.ropensci.org/targets/reference/tar_make.html)). So in order to run a pipeline in user storage, the app needs to change directories to the pipeline root. The best time to switch directories is when the user selects the corresponding project. This technique works as long as the Shiny server function uses a callback to restore the working directory when the app exits.

```r
server <- function(input, output, session) {
  dir <- getwd()
  session$onSessionEnded(function() setwd(dir))
  # ...
}
```

### Pipeline setup

Every [`targets`](https://docs.ropensci.org/targets/) pipeline requires a `_targets.R` configuration file and R scripts with supporting functions if applicable. The [`tar_helper()`](https://docs.ropensci.org/targets/reference/tar_helper.html) function writes arbitrary R scripts to the location of your choice, and tidy evaluation with `!!` is a convenient templating mechanism that translates Shiny UI inputs into target definitions. In this app, the functions in `R/pipeline.R` demonstrate the technique.

### Persistent background processes

This particular app runs pipelines as background processes that persist after the user logs out. Before you launch a new pipeline, first check if there is already an existing one running. [`tar_pid()`](https://docs.ropensci.org/targets/reference/tar_pid.html) retrieves the ID of the most recent process to run the pipeline, and [`ps::pid()`](https://ps.r-lib.org/reference/ps_pids.html) lists the IDs of all processes currently running. If no process is already running, start the [`targets`](https://docs.ropensci.org/targets/) pipeline in a persistent background process:

```r
processx_handle <- tar_make(
  callr_function = r_bg,
  callr_arguments = list(
    cleanup = FALSE,
    supervise = FALSE,
    stdout = "/PATH/TO/USER/PROJECT/stdout.txt",
    stderr = "/PATH/TO/USER/PROJECT/stderr.txt"
  )
)
```

`cleanup = FALSE` keeps the process alive after the [`processx`](https://processx.r-lib.org) handle is garbage collected, and `supervise = FALSE` keeps process alive after the app itself exits. As long as the server keeps running, the pipeline will keep running. To help manage resources, the UI should have an action button to cancel the current process, and the server should automatically cancel it when the user deletes the project.

### Monitor the background process

The app should continuously check whether the process is running at any given moment:

1. Check if a process ID is available using `targets::tar_exist_process()`.
2. If possible, get the process ID of the most recent pipeline using `targets::tar_pid()`.
3. Check if the process ID is in `ps::ps_pids()` to see if the pipeline is running.

This particular app implements a `process_status()` function to do this.

```r
process_status()
#> $pid
#> [1] 19442
#> 
#> $running
#> [1] FALSE
```

Inside the Shiny server function, we continuously refresh the status in a reactive value. 

```r
process <- reactiveValues(status = process_status())
observe({
  invalidateLater(millis = 10)
  process$status <- process_status()
})
```

This reactive value helps us:

1. Only show certain UI elements if the pipeline is running. Use `process$status$running` to show activity or disable inputs when the pipeline is busy. Useful tools include [`show_spinner()`](https://dreamrs.github.io/shinybusy/reference/manual-spinner.html) from [`shinybusy`](/dreamrs.github.io/shinybusy/) and `show()`, `hide()`, `enable()`, and `disable()` from [`shinyjs`](https://deanattali.com/shinyjs/).
2. Refresh output and logs when the pipeline starts or stops. Simply write `process$status` inside a reactive context such as `observe()` or `renderPlot()`.

### Scaling out to many users

Serious scalable apps in production should long background processes as jobs on a cluster like SLURM or a cloud computing platform like Amazon Web Services. The [existing high-performance computing capabilities in `targets`](https://books.ropensci.org/targets/hpc.html) alleviate some of this, but the main process of each pipeline still runs locally. If this becomes too burdensome for the server, consider distributing these main processes as well. In this app, the file `R/process_sge.R` is an alternative to `R/process.R` for a Sun Grid Engine (SGE) cluster.

### Transient mode

For demonstration purposes, you may wish to deploy your app to a more limited service like [shinyapps.io](https://www.shinyapps.io). For these situations, consider implementing a transient mode to alert users and clean up resources. If this particular app is deployed with the `TARGETS_SHINY_TRANSIENT` environment variable equal to `"true"`, then:

1. `tar_make()` runs with `supervise = TRUE` in `callr_arguments` so that all pipelines terminate when the R session exits.
2. All user storage lives in a subdirectory of `tempdir()` so project files are automatically cleaned up.
3. When the app starts, the UI shows a `shinyalert` to warn users about the above.


### Progress

The [`tar_watch()`](https://docs.ropensci.org/targets/reference/tar_watch.html) Shiny module is available through the functions [`tar_watch_ui()`](https://docs.ropensci.org/targets/reference/tar_watch_ui.html) and [`tar_watch_server()`](https://docs.ropensci.org/targets/reference/tar_watch_server.html). This module continuously refreshes the [`tar_visnetwork()`](https://docs.ropensci.org/targets/reference/tar_visnetwork.html) graph and the [`tar_progress_branches()`](https://docs.ropensci.org/targets/reference/tar_progress_branches.html) table to communicate the current status of the pipeline. Visit [this article](https://shiny.rstudio.com/articles/modules.html) for more information on Shiny modules.

### Logs

The `stdout` and `stderr` log files provide cruder but more immediate information on the progress of the pipeline. To generate logs, set the `stdout` and `stderr` `callr` arguments as described previously. In the app server function, define text outputs that continuously refresh: every few milliseconds when the pipeline is running, once when the pipeline starts or stops, and once when the user switches projects. Below, you may wish to return just the last few lines instead of the full result of `readLines()`.

```r
output$stdout <- renderText({
  req(input$project)
  process$status
  if (process$status$running) invalidateLater(100)
  readLines("/PATH/TO/USER/PROJECT/stdout.txt")
})
output$stderr <- renderText({
  req(input$project)
  process$status
  if (process$status$running) invalidateLater(100)
  readLines("/PATH/TO/USER/PROJECT/stderr.txt")
})
```

In the UI, define text outputs that display proper line breaks and enable scrolling:

```r
fluidRow(
  textOutput("stdout"),
  textOutput("stderr"),
  tags$head(tags$style("#stdout {white-space: pre-wrap; overflow-y:scroll; max-height: 600px;}")),
  tags$head(tags$style("#stderr {white-space: pre-wrap; overflow-y:scroll; max-height: 600px;}"))
)
```

### Results

[`targets`](https://docs.ropensci.org/targets/) stores the output of the pipeline in a `_targets/` folder at the project root. Use [`tar_read()`](https://docs.ropensci.org/targets/reference/tar_read.html) to return a result. We use the `process$status` reactive value to refresh the data sparingly: once when the user switches projects and once when the pipeline starts or stops.

```r
output$plot <- renderPlot({
  req(input$project)
  process$running
  tar_read(final_plot)
})
```

## Thanks

For years, [Eric Nantz](https://shinydevseries.com/authors/admin/) has advanced the space of enterprise Shiny in the life sciences. The motivation for this app comes from his work, and it borrows many of his techniques.

## Code of Conduct
  
Please note that the `targets-shiny` project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.

## References

1. Brilleman S. "Estimating Joint Models for Longitudinal and Time-to-Event Data with rstanarm." `rstanarm`, Stan Development Team, 2020. <https://cran.r-project.org/web/packages/rstanarm/vignettes/jm.html>
2. Gelman A, Vehtari A, Simpson D, Margossian CC, Carpenter B, Yao Y, Kennedy L, Gabry J, Burkner PC, Modrak M. "Bayesian Workflow."  	*arXiv* 2020, arXiv:2011.01808, <https://arxiv.org/abs/2011.01808>.
3. Gould AL, Boye ME, Crowther MJ, Ibrahim JG, Quartey G, Micallef S, et al. "Joint modeling of survival and longitudinal non-survival data: current methods and issues. Report of the DIA Bayesian joint modeling working group." *Stat Med.* 2015; 34(14): 2181-95.
