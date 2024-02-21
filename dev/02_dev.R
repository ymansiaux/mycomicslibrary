# Building a Prod-Ready, Robust Shiny Application.
#
# README: each step of the dev files is optional, and you don't have to
# fill every dev scripts before getting started.
# 01_start.R should be filled at start.
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
#
#
###################################
#### CURRENT FILE: DEV SCRIPT #####
###################################

# Engineering

## Dependencies ----
## Amend DESCRIPTION with dependencies read from package code parsing
## install.packages('attachment') # if needed.
attachment::att_amend_desc()

## Add modules ----
## Create a module infrastructure in R/
golem::add_module(name = "100_search_isbn", with_test = TRUE) # Name of the module
golem::add_module(name = "110_find_isbn", with_test = TRUE) # Name of the module
golem::add_module(name = "120_add_picture", with_test = TRUE) # Name of the module
golem::add_module(name = "130_poc_gridjs", with_test = TRUE) # Name of the module

## Add helper functions ----
## Creates fct_* and utils_*
golem::add_fct("helpers", with_test = TRUE)
golem::add_utils("helpers", with_test = TRUE)

## External resources
## Creates .js and .css files at inst/app/www
golem::add_js_file("script")
golem::add_js_handler("quaggajs")
golem::add_js_handler("quaggajs_webcam")
golem::add_js_handler("wait_for_button_to_be_available")
golem::use_external_js_file("https://cdn.jsdelivr.net/npm/sweetalert2@11.10.5/dist/sweetalert2.all.min.js", name = "sweetalert2")
golem::use_external_css_file("https://cdn.jsdelivr.net/npm/sweetalert2@11.10.5/dist/sweetalert2.min.css", name = "sweetalert2")
golem::use_external_js_file(
  "https://unpkg.com/gridjs/dist/gridjs.umd.js"
)
golem::add_js_handler("gridjs")

golem::add_js_handler("call_sweetalert2")
golem::add_css_file("ccsY")
golem::add_sass_file("custom")
golem::add_html_template("template")

## Add internal datasets ----
## If you have data in your package
usethis::use_data_raw(name = "isbn_sample", open = FALSE)

## Tests ----
## Add one line by test you want to create
usethis::use_test("app")

# Documentation

## Vignette ----
usethis::use_vignette("mycomicslibrary")
devtools::build_vignettes()

## Code Coverage----
## Set the code coverage service ("codecov" or "coveralls")
usethis::use_coverage()

# Create a summary readme for the testthat subdirectory
covrpage::covrpage()

## CI ----
## Use this part of the script if you need to set up a CI
## service for your application
##
## (You'll need GitHub there)
usethis::use_github()

# GitHub Actions
usethis::use_github_action()
# Chose one of the three
# See https://usethis.r-lib.org/reference/use_github_action.html
usethis::use_github_action_check_release()
usethis::use_github_action_check_standard()
usethis::use_github_action_check_full()
# Add action for PR
usethis::use_github_action_pr_commands()

# Travis CI
usethis::use_travis()
usethis::use_travis_badge()

# AppVeyor
usethis::use_appveyor()
usethis::use_appveyor_badge()

# Circle CI
usethis::use_circleci()
usethis::use_circleci_badge()

# Jenkins
usethis::use_jenkins()

# GitLab CI
usethis::use_gitlab_ci()

# You're now set! ----
# go to dev/03_deploy.R
rstudioapi::navigateToFile("dev/03_deploy.R")
