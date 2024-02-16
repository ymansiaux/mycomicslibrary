#' 130_poc_gridjs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_130_poc_gridjs_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$div(
      class = "col",
      h3("Ma collection"),
      tags$div(id = ns("ma_collection"))
    )
  )
}

#' 130_poc_gridjs Server Functions
#'
#' @noRd
mod_130_poc_gridjs_server <- function(id, r_global) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns


    observeEvent(r_global$comics_db, {
      # browser()

      db <- r_global$comics_db |>
        get_most_recent_entry_per_doc() |>
        prepare_comics_db_to_see_collection(
          ns = ns
        )
      # il faut garder la dernière entrée
      # browser()

      golem::invoke_js(
        "build_ma_collection",
        list(
          id = ns("ma_collection"),
          columns = names(db),
          data = do.call(cbind, lapply(db, as.character))
        )
      )
    })

    observeEvent(input$button_clicked, {
      # browser()
      print("tu as cliqué sur le button")
      print(input$button_clicked_id)
    })
  })
}

## To be copied in the UI
# mod_130_poc_gridjs_ui("130_poc_gridjs_1")

## To be copied in the server
# mod_130_poc_gridjs_server("130_poc_gridjs_1")
