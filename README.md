
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mycomicslibrary

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/ymansiaux/mycomicslibrary/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ymansiaux/mycomicslibrary/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The objective of the {mycomicslibrary} package is to manage your comics
library.

## Installation

You can install the development version of mycomicslibrary from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ymansiaux/mycomicslibrary", dependencies = TRUE)
```

You should install Python and the required dependencies with the
following command:

``` r
reticulate::install_python()
reticulate::py_install("pyzbar")
reticulate::py_install("pillow")
```

It is advised to set the following environment variables in your
.Renviron file:

``` r
COVERS_PATH = "path_to_app_storage/covers"
COMICS_SQL_PATH = "path_to_app_storage/db/db.sqlite"
```

`COVERS_PATH` will be used to store your books covers and
`COMICS_SQL_PATH` will be used to store your comics library.

If theses environment variables are not set, the app will use temporary
directories, which implies that your library and covers will be lost
when you close the app.

To run the app, you can use the following command:

``` r
mycomicslibrary::run_app()
```

The app has been developed using the {shiny} package and the following
ressources: - books characteristics are retrieved from the Open Library
API : <https://openlibrary.org/dev/docs/api/search> - html template :
<https://startbootstrap.com/template/scrolling-nav> - Python code to
extract ISBN from images :
<https://stackoverflow.com/questions/67423405/is-there-an-r-package-to-read-a-barcode-from-an-image>
- JS libraries - sweetalert2: <https://sweetalert2.github.io/> - gridjs
: <https://gridjs.io/> - chartjs : <https://www.chartjs.org/> - html
template to take pictures with the webcam :
<https://usefulangle.com/post/352/javascript-capture-image-from-camera>
