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

      my_labels <- r_local$current_db |>
        dplyr::count(.data[[r_local$var_to_use]]) |>
        dplyr::arrange(.data[[r_local$var_to_use]]) |>
        dplyr::pull(.data[[r_local$var_to_use]])
      if (length(my_labels) == 1) my_labels <- list(my_labels)

      my_data <- r_local$current_db |>
        dplyr::count(.data[[r_local$var_to_use]]) |>
        dplyr::arrange(.data[[r_local$var_to_use]]) |>
        dplyr::pull(n)
      if (length(my_data) == 1) my_data <- list(my_data)

      golem::invoke_js(
        "call_chartjs",
        message = list(
          id = ns("myChart"),
          labels = my_labels,
          label = "Nombre d'albums",
          data = my_data
        )
      )
    })
  })
}

## To be copied in the UI
# mod_500_chartjs_ui("500_chartjs_1")

## To be copied in the server
# mod_500_chartjs_server("500_chartjs_1")
