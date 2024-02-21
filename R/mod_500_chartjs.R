#' 500_chartjs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_500_chartjs_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      tags$canvas(id = ns("myChart"))
    )
  )
}

#' 500_chartjs Server Functions
#'
#' @noRd
mod_500_chartjs_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observe(
      golem::invoke_js(
        "call_chartjs",
        message = list(
          id = ns("myChart")
        )
      )
    )
  })
}

## To be copied in the UI
# mod_500_chartjs_ui("500_chartjs_1")

## To be copied in the server
# mod_500_chartjs_server("500_chartjs_1")
