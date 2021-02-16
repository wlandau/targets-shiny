## Bayesian joint models

Bayesian joint models of survival and longitudinal non-survival outcomes reduce bias and describe relationships among endpoints ([Gould et al. 2015](https://pubmed.ncbi.nlm.nih.gov/24634327/)). Statisticians routinely refine and explore such complicated models ([Gelman et al. 2020](https://arxiv.org/abs/2011.01808)), but the computation is so slow that routine changes are tedious to refresh.

## The `targets` R package

The [`targets`](https://docs.ropensci.org/targets/) R package orchestrates tasks and skip steps that are already up to date, which reduces the runtime and speeds development in fields such as Bayesian data analysis, machine learning, simulation, clinical trials, and statistical genomics.

## Shiny

This Shiny app contains a [`targets`](https://docs.ropensci.org/targets/) pipeline to run Bayesian joint models with [`rstanarm`](https://mc-stan.org/rstanarm/) ([Brilleman 2017](https://cran.r-project.org/web/packages/rstanarm/vignettes/jm.html)). This app can manage multiple projects with [persistent storage](https://blog.r-hub.io/2020/03/12/user-preferences/), and users can recover their projects and running [`targets`](https://docs.ropensci.org/targets/) pipelines after logging out and logging back in again.

## Administration

1. Optional: to customize the location of persistent storage, create an `.Renviron` file at the app root and set the `TARGETS_SHINY_HOME` environment variable. If you do, the app will store projects within `file.path(Sys.getenv("TARGETS_SHINY_HOME"), Sys.getenv("USER"), ".targets-shiny")`. Otherwise, storage will default to `tools::R_user_dir("targets-shiny", which = "cache")`
2. Deploy the app to [RStudio Server](https://rstudio.com/products/rstudio-server-pro/), [RStudio Connect](https://rstudio.com/products/connect/), or other service that supports persistent server-side storage.
3. Run the app as the logged-in user, not the system administrator.
4. Raise automatic timeout thresholds on [RStudio Connect](https://rstudio.com/products/connect/) etc. so that worker processes remain alive long enough to finish pipelines in the background.

## Usage

#### Analysis

The app fits Bayesian joint models to the publicly available [`pbcLong`](https://mc-stan.org/rstanarm/reference/rstanarm-datasets.html) and [`pbcSurv`](https://mc-stan.org/rstanarm/reference/rstanarm-datasets.html) datasets in the [`rstanarm`](https://mc-stan.org/rstanarm/) package. The survival endpoint is time until death, and the longitudinal endpoint is the the biomarker of your choice. The app fits one [univariate joint model](https://mc-stan.org/rstanarm/articles/jm.html#univariate-joint-model-current-value-association-structure) for each biomarker you select. Adjust the number of MCMC iterations using the slider.

#### Projects

You can save a new versions of the pipeline by creating a new project. These projects run independently and save storage to different locations.

#### Runs

When you are ready, click the "Run pipeline" button to run the models. Watch progress with the "Progress" tab, and optionally cancel the pipeline early with the "Cancel run" button. View the output in the "Results" tab. Successive runs with the same models will complete quickly because [`targets`](https://docs.ropensci.org/targets/) skips steps that are already up to date.

#### Persistence

As long as the app is administered properly, you can safely log out and log back in. Any running pipelines will still be running, and data from all your projects will still be available.

## Thanks

For years, [Eric Nantz](https://shinydevseries.com/authors/admin/) has advanced the space of enterprise Shiny apps in the life sciences. The motivation for this app comes from his work, and it borrows many of his techniques.

## References

1. Brilleman S. "Estimating Joint Models for Longitudinal and Time-to-Event Data with rstanarm." `rstanarm`, Stan Development Team, 2020. <https://cran.r-project.org/web/packages/rstanarm/vignettes/jm.html>
2. Gelman A, Vehtari A, Simpson D, Margossian CC, Carpenter B, Yao Y, Kennedy L, Gabry J, Burkner PC, Modrak M. "Bayesian Workflow."  	*arXiv* 2020, arXiv:2011.01808, <https://arxiv.org/abs/2011.01808>.
3. Gould AL, Boye ME, Crowther MJ, Ibrahim JG, Quartey G, Micallef S, et al. "Joint modeling of survival and longitudinal non-survival data: current methods and issues. Report of the DIA Bayesian joint modeling working group." *Stat Med.* 2015; 34(14): 2181-95.
