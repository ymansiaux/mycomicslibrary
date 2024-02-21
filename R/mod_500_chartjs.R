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
      style = "height: 90%; width: 90%; text-align: -webkit-center; margin: auto; padding: 10px; background-color: white; border-radius: 10px; box-shadow: 0 0 10px 0 rgba(0, 0, 0, 0.1);",
      tags$canvas(id = ns("myChart"))
    )
  )
}

#' 500_chartjs Server Functions
#'
#' @noRd
mod_500_chartjs_server <- function(id, r_global) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    r_local <- reactiveValues(
      current_db = NULL
    )


    observeEvent(r_global$comics_db, {
      req(nrow(r_global$comics_db) > 0)

      r_local$current_db <- r_global$comics_db |>
        get_most_recent_entry_per_doc() |>
        filter(possede == 1)
    })

    observeEvent(r_local$current_db, {
      req(nrow(r_local$current_db) > 0)


      golem::invoke_js(
        "call_chartjs",
        message = list(
          id = ns("myChart"),
          labels = sort(r_local$current_db$annee_publication),
          label = "Nombre d'albums",
          data = r_local$current_db |>
            dplyr::count(annee_publication) |>
            dplyr::arrange(annee_publication) |>
            dplyr::pull(n)
        )
      )




      # golem::invoke_js(
      #   "call_chartjs",
      #   message = list(
      #     id = ns("myChart"),
      #     labels = c("Red", "Blue", "Yellow", "Green", "Purple", "Orange"),
      #     label = "# of Votes",
      #     data = c(12, 19, 3, 5, 2, 3)
      #   )
      # )
    })
  })
}

## To be copied in the UI
# mod_500_chartjs_ui("500_chartjs_1")

## To be copied in the server
# mod_500_chartjs_server("500_chartjs_1")
