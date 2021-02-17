This prototype app demonstrates how to create powerful data analysis tools with Shiny and [`targets`](https://docs.ropensci.org/targets/). The app manages multiple pipelines across multiple clients, and it ensures that user storage and background processes persist after logout. Because of [`targets`](https://docs.ropensci.org/targets/), subsequent runs skip computationally expensive steps that are already up to date.

## The use case

Bayesian joint models of survival and longitudinal non-survival outcomes reduce bias and describe relationships among endpoints ([Gould et al. 2015](https://pubmed.ncbi.nlm.nih.gov/24634327/)). Statisticians routinely refine and explore such complicated models ([Gelman et al. 2020](https://arxiv.org/abs/2011.01808)), but the computation is so slow that routine changes are tedious to refresh. This app shows how [`targets`](https://docs.ropensci.org/targets/) can speed up iteration and Shiny can ease the burden of code development for established use cases.

## Usage

When you first open the app, create a new project to establish a data analysis pipeline. You can create, switch, and delete projects at any time. Next, select the biomarkers and number of Markov chain Monte Carlo iterations. The pipeline will run one [univariate joint model](https://mc-stan.org/rstanarm/articles/jm.html#univariate-joint-model-current-value-association-structure) on each biomarker for the number of iterations you select. Each model analyzes [`rstanarm`](https://mc-stan.org/rstanarm/) datasets [`pbcLong`](https://mc-stan.org/rstanarm/reference/rstanarm-datasets.html) and [`pbcSurv`](https://mc-stan.org/rstanarm/reference/rstanarm-datasets.html) to jointly model survival (time to event) and the biomarker (longitudinally).

Click the "Run pipeline" button to run the correct models in the correct order. A spinner will appear in the upper right to show you that the pipeline is running in the background. The pipeline will run to completion even if you switch projects, log out, or get disconnected for idleness.

While the pipeline is running, the Progress and Logs tabs continuously refresh to monitor progress. The Progress tab uses the [`tar_watch()`](https://docs.ropensci.org/targets/reference/tar_watch.html) Shiny module, available through the functions [`tar_watch_ui()`](https://docs.ropensci.org/targets/reference/tar_watch_ui.html) and [`tar_watch_server()`](https://docs.ropensci.org/targets/reference/tar_watch_server.html).

The Results tab refreshes the final plot every time the pipeline stops. The plot shows the marginal posterior distribution of the association parameter between mortality and the longitudinal biomarker.

## Administration

1. Optional: to customize the location of persistent storage, create an `.Renviron` file at the app root and set the `TARGETS_SHINY_HOME` environment variable. If you do, the app will store projects within `file.path(Sys.getenv("TARGETS_SHINY_HOME"), Sys.getenv("USER"), ".targets-shiny")`. Otherwise, storage will default to `tools::R_user_dir("targets-shiny", which = "cache")`
2. Deploy the app to [RStudio Server](https://rstudio.com/products/rstudio-server-pro/), [RStudio Connect](https://rstudio.com/products/connect/), or other service that supports persistent server-side storage. Unfortunately, [shinyapps.io](https://www.shinyapps.io) is not sufficient.
3. Require a login so the app knows the user name.
4. Run the app as the logged-in user, not the system administrator or default user.
5. If applicable, raise automatic timeout thresholds in [RStudio Connect](https://rstudio.com/products/connect/) so the background processes running pipelines remain alive long enough to finish.

## Development

Shiny apps with [`targets`](https://docs.ropensci.org/targets/) require specialized techniques such as user storage and persistent background processes. 
### User storage

[`targets`](https://docs.ropensci.org/targets/) writes to storage to ensure the pipeline stays up to date after R exits. This storage must be persistent and user-specific. `tools::R_user_dir("app_name", which = "cache")` covers some situations. In addition, it is best to deploy to a service like [RStudio Server](https://rstudio.com/products/rstudio-server-pro/) or [RStudio Connect](https://rstudio.com/products/connect/) and provision enough space for the expected number of users. Unfortunately, [shinyapps.io](https://www.shinyapps.io) is not sufficient. Please consult your system administrator.

### Multiple projects

Projects manage multiple versions of the pipeline. In this app, each project is a directory inside user storage with app input settings, pipeline configuration, and results. A top-level `_project` file identifies the current active project. Functions in `R/project.R` configure, load, create, and destroy projects. The `update*()` functions in Shiny and `shinyWidgets`, such as `updateSliderInput()`, are particularly handy for restoring the input settings of a saved project. That is why this app does not need a single `renderUI()` or `uiOutput()`.

### Working directory

For reasons [described here](https://github.com/ropensci/targets/discussions/297), the `_targets.R` configuration file and `_targets/` data store always live at the root directory of the pipeline (where you run [`tar_make()`](https://docs.ropensci.org/targets/reference/tar_make.html)). So in order to run a pipeline in user storage, the app needs to change directories to the pipeline root. The `set_project()` function in this particular app accomplishes this, with a catch: the Shiny server function needs a callback to restore the working directory when the app exits.

```r
server <- function(input, output, session) {
  dir <- getwd()
  session$onSessionEnded(function() setwd(dir))
  # ...
}
```

### Pipeline setup


### Multiple projects


### Persistent background processes

### Progress

### Logs

### Results



## Thanks

For years, [Eric Nantz](https://shinydevseries.com/authors/admin/) has advanced the space of enterprise Shiny in the life sciences. The motivation for this app comes from his work, and it borrows many of his techniques.

## References

1. Brilleman S. "Estimating Joint Models for Longitudinal and Time-to-Event Data with rstanarm." `rstanarm`, Stan Development Team, 2020. <https://cran.r-project.org/web/packages/rstanarm/vignettes/jm.html>
2. Gelman A, Vehtari A, Simpson D, Margossian CC, Carpenter B, Yao Y, Kennedy L, Gabry J, Burkner PC, Modrak M. "Bayesian Workflow."  	*arXiv* 2020, arXiv:2011.01808, <https://arxiv.org/abs/2011.01808>.
3. Gould AL, Boye ME, Crowther MJ, Ibrahim JG, Quartey G, Micallef S, et al. "Joint modeling of survival and longitudinal non-survival data: current methods and issues. Report of the DIA Bayesian joint modeling working group." *Stat Med.* 2015; 34(14): 2181-95.
