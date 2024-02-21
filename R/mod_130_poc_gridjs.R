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

    r_local <- reactiveValues(
      current_db = NULL
    )

    observeEvent(r_global$comics_db, {
      req(nrow(r_global$comics_db) > 0)

      r_local$current_db <- r_global$comics_db |>
        get_most_recent_entry_per_doc() |>
        prepare_comics_db_to_see_collection(
          ns = ns
        )
      r_local$trigger_new_book_in_db <- Sys.time()
    })

    observeEvent(r_local$current_db, {
      req(nrow(r_local$current_db) > 0)
      print("tu as ajouté un nouveau livre")
      golem::invoke_js(
        "build_my_collection",
        list(
          id = ns("my_collection"),
          columns = names(r_local$current_db),
          data = do.call(cbind, lapply(r_local$current_db, as.character))
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
        "modal_modify_book_in_collection",
        message = list(
          id_valider_modification = ns("do_i_modify_the_book_in_collection"),
          html = create_html_for_modal_modify_book_in_collection(ns = ns) |> as.character()
        )
      )
    })

    observeEvent(input$do_i_modify_the_book_in_collection, {
      req(input$do_i_modify_the_book_in_collection)
      document_to_modify <- input$document_to_modify_id
      document_to_modify_values_in_db <- r_global$comics_db |>
        dplyr::filter(id_document == document_to_modify) |>
        get_most_recent_entry_per_doc()

      append_res <- append_comics_db(
        ISBN = document_to_modify_values_in_db$ISBN,
        auteur = document_to_modify_values_in_db$auteur,
        titre = document_to_modify_values_in_db$titre,
        possede = document_to_modify_values_in_db$possede,
        date_publication = document_to_modify_values_in_db$date_publication,
        nb_pages = document_to_modify_values_in_db$nb_pages,
        editeur = document_to_modify_values_in_db$editeur,
        note = input$note,
        type_publication = input$format,
        statut = input$etat,
        lien_cover = document_to_modify_values_in_db$lien_cover
      )

      if (append_res == 1) {
        golem::invoke_js(
          "call_sweetalert2",
          message = list(
            type = "success",
            msg = "Le livre a été modifié avec succès"
          )
        )
      } else {
        golem::invoke_js(
          "call_sweetalert2",
          message = list(
            type = "error",
            msg = "Le livre n'a pu être modifié"
          )
        )
      }

      r_global$comics_db <- read_comics_db()
    })

    observe({
      print(input$note)
      print(input$format)
      print(input$etat)
      print(input$do_i_modify_the_book_in_collection)
    })
  })
}

## To be copied in the UI
# mod_130_poc_gridjs_ui("130_poc_gridjs_1")

## To be copied in the server
# mod_130_poc_gridjs_server("130_poc_gridjs_1")
