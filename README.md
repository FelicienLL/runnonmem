
<!-- README.md is generated from README.Rmd. Please edit that file -->

# runnonmem

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of runnonmem is to run NONMEM from R. Developed and tested on a
Windows environment.

## Installation

``` r
# install.packages("remotes")
remotes::install_github("FelicienLL/runnonmem")
```

## Example

First, define where is NONMEM is installed

``` r
library(runnonmem)
options(runnonmem_nmfe_location = "C:/nmXXXXX/util/nmfeXX.bat")
```

Then launch a run

``` r
#If the control stream is in the working directory, just execute
runnonmem("mod001.mod")

# Or specify the project directory apart
runnonmem("mod001.mod", "/my/working/directory")

# Or full path to model object
runnonmem(file = "C:/my/working/directory.mod001.mod")
```

## Development

I often need to run NONMEM with the snap of a finger, without opening
Pirana or something else. So a long time ago I made some messy code to
achieve that. Recently, I decided to clean it and I turned it into a
small proper R package. Instead of keeping it for myself, here it is.
