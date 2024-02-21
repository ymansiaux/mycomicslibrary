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
      tags$div(id = ns("my_collection"))
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
      req(nrow(r_global$comics_db) > 0)

      db <- r_global$comics_db |>
        get_most_recent_entry_per_doc() |>
        prepare_comics_db_to_see_collection(
          ns = ns
        )
      # il faut garder la dernière entrée


      golem::invoke_js(
        "build_my_collection",
        list(
          id = ns("my_collection"),
          columns = names(db),
          data = do.call(cbind, lapply(db, as.character))
        )
      )
    })

    observeEvent(input$modify_button_clicked, {
      # browser()
      print("tu as cliqué sur le button")
      print(input$modify_button_clicked_id)
      golem::invoke_js(
        "waitForModalModifyBookInCollection",
        message = list(
          modalToWaitFor = ns("modal_modify_book_in_collection"),
          id_note = ns("note"),
          id_format = ns("format"),
          id_etat = ns("etat")
        )
      )
      golem::invoke_js(
        "modal_api_search_result",
        message = list(
          id_ajout_bibliotheque = ns("do_i_add_to_library"),
          html = create_html_for_modal_modify_book_in_collection(ns = ns) |> as.character()
        )
      )
    })

    observe({
      print(input$note)
      print(input$format)
      print(input$etat)
    })
  })
}

## To be copied in the UI
# mod_130_poc_gridjs_ui("130_poc_gridjs_1")

## To be copied in the server
# mod_130_poc_gridjs_server("130_poc_gridjs_1")
