#' 100_search_isbn UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_100_search_isbn_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 10,
        mod_110_find_isbn_ui(ns("110_find_isbn_1"))
      )
    )
  )
}

#' 100_search_isbn Server Functions
#'
#' @noRd
mod_100_search_isbn_server <- function(id, r_global) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    mod_110_find_isbn_server("110_find_isbn_1", r_global)
    mod_200_add_picture_server("120_add_picture_1", r_global)
  })
}

## To be copied in the UI
# mod_100_search_isbn_ui("100_search_isbn_1")

## To be copied in the server
# mod_100_search_isbn_server("100_search_isbn_1")
