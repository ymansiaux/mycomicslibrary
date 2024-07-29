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
    tags$h4(id = ns("nobook"), "No book in the collection for the moment", style = "display: none;"),
    htmlTemplate(
      app_sys("app/www/templates_html/template_chartjs.html"),
      id = ns("myChart"),
      groupbuttonid = ns("chart_group_button"),
      divchart = ns("divchart")
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
      r_local$var_to_use <- get_var_to_display_on_chartjs()[[input$myChart_button]]
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

    observeEvent(r_local$current_db, ignoreNULL = FALSE, {
      show_hide_ids_depending_on_db_size(
        db = r_local$current_db,
        table_id = ns("divchart"),
        nobook_id = ns("nobook")
      )
    })

    observeEvent(r_local$var_to_use, ignoreNULL = FALSE, {
      if (!isTruthy(r_local$var_to_use)) {
        golem::invoke_js("hideid", paste0("container_", ns("myChart")))
      } else {
        golem::invoke_js("showid", paste0("container_", ns("myChart")))
      }
    })

    observeEvent(c(r_local$current_db, r_local$var_to_use), {
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
          label = "Number of books",
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
