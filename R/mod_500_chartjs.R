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
    htmlTemplate(
      app_sys("app/www/templates_html/template_chartjs.html"),
      id = ns("myChart"),
      groupbuttonid = ns("chart_group_button")
    )
  )
}

#' 500_chartjs Server Functions
#'
#' @noRd
mod_500_chartjs_server <- function(id, r_global) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observeEvent(input$myChart_button, {
      if (input$myChart_button == "Année de publication") {
        r_local$var_to_use <- "annee_publication"
      } else if (input$myChart_button == "Note") {
        r_local$var_to_use <- "note"
      } else if (input$myChart_button == "Etat") {
        r_local$var_to_use <- "statut"
      } else {
        r_local$var_to_use <- "type_publication"
      }
      print(r_local$var_to_use)
    })

    r_local <- reactiveValues(
      current_db = NULL,
      var_to_use = NULL
    )


    observeEvent(r_global$comics_db, {
      req(nrow(r_global$comics_db) > 0)

      r_local$current_db <- r_global$comics_db |>
        get_most_recent_entry_per_doc() |>
        filter(possede == 1)
    })

    observeEvent(r_local$var_to_use, {
      req(nrow(r_local$current_db) > 0)
      req(r_local$var_to_use)
      browser()
      golem::invoke_js(
        "call_chartjs",
        message = list(
          id = ns("myChart"),
          labels = r_local$current_db |>
            dplyr::count(.data[[r_local$var_to_use]]) |>
            dplyr::arrange(.data[[r_local$var_to_use]]) |>
            dplyr::pull(.data[[r_local$var_to_use]]) |>
            stringi::stri_trans_general("latin-ascii"),
          label = "Nombre d'albums",
          data = r_local$current_db |>
            dplyr::count(.data[[r_local$var_to_use]]) |>
            dplyr::arrange(.data[[r_local$var_to_use]]) |>
            dplyr::pull(n)
        )
      )
      # problème avec les accents dans A définir je pense (et les espaces ?)
    })
  })
}

## To be copied in the UI
# mod_500_chartjs_ui("500_chartjs_1")

## To be copied in the server
# mod_500_chartjs_server("500_chartjs_1")
