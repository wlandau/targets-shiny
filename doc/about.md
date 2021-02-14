# Motivation

Bayesian joint models of survival and longitudinal non-survival outcomes reduce bias and describe relationships among endpoints ([Gould et al. 2015](https://pubmed.ncbi.nlm.nih.gov/24634327/)). Statisticians routinely refine and explore such complicated models ([Gelman et al. 2020](https://arxiv.org/abs/2011.01808)), but the computation is so slow that routine iteration is tedious. The [`targets`](https://docs.ropensci.org/targets/) R package orchestrates tasks and skip steps that are already up to date, which reduces the runtime and speeds development.

# The app

This Shiny app contains a [`targets`](https://docs.ropensci.org/targets/) pipeline to run Bayesian joint models with [`rstanarm`](https://mc-stan.org/rstanarm/) ([Stan Development Team 2017](https://cran.r-project.org/web/packages/rstanarm/vignettes/jm.html), [Brilleman 2017](https://cran.r-project.org/web/packages/rstanarm/vignettes/jm.html)).

# References

1. Gould AL, Boye ME, Crowther MJ, Ibrahim JG, Quartey G, Micallef S, et al. "Joint modeling of survival and longitudinal non-survival data: current methods and issues. Report of the DIA Bayesian joint modeling working group." *Stat Med.* 2015; 34(14): 2181-95.
1. Gelman A, Vehtari A, Simpson D, Margossian CC, Carpenter B, Yao Y, Kennedy L, Gabry J, Burkner PC, Modrak M. "Bayesian Workflow."  	*arXiv* 2020, arXiv:2011.01808, <https://arxiv.org/abs/2011.01808>.
