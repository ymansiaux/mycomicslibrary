#' 130_poc_gridjs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_130_manage_collection_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$div(
      tags$h4(id = ns("nobook"), "Aucun livre dans la collection pour le moment", style = "display: none;"),
      tags$div(id = ns("my_collection"))
    )
  )
}

#' 130_poc_gridjs Server Functions
#' @importFrom dplyr filter
#' @noRd
mod_130_manage_collection_server <- function(id, r_global) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    r_local <- reactiveValues(
      current_db = NULL,
      current_book = NULL
    )

    observeEvent(r_local$current_db, ignoreNULL = FALSE, {
      if (
        !isTruthy(r_local$current_db) ||
          nrow(r_local$current_db) == 0
      ) {
        golem::invoke_js(
          "showid",
          ns("nobook")
        )
      } else {
        golem::invoke_js(
          "hideid",
          ns("nobook")
        )
      }
    })

    observeEvent(r_global$comics_db, {
      req(nrow(r_global$comics_db) > 0)

      r_local$current_db <- r_global$comics_db |>
        get_most_recent_entry_per_doc() |>
        filter(possede == 1) |>
        prepare_comics_db_to_see_collection(
          ns = ns
        )
    })

    observeEvent(r_local$current_db, {
      req(nrow(r_local$current_db) > 0)

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
      r_local$current_book <- r_global$comics_db |>
        dplyr::filter(id_document == input$document_to_modify_id) |>
        get_most_recent_entry_per_doc()


      golem::invoke_js(
        "waitForModalModifyBookInCollection",
        message = list(
          modalToWaitFor = ns("modal_modify_book_in_collection"),
          id_note = ns("note"),
          note_initial_value = r_local$current_book$note,
          id_format = ns("format"),
          format_initial_value = r_local$current_book$type_publication,
          id_etat = ns("etat"),
          etat_initial_value = r_local$current_book$statut,
          id_annee_publication = ns("annee_publication"),
          annee_publication_initial_value = r_local$current_book$annee_publication,
          id_nb_pages = ns("nb_pages"),
          nb_pages_initial_value = r_local$current_book$nb_pages,
          id_auteur = ns("auteur"),
          auteur_initial_value = r_local$current_book$auteur,
          id_editeur = ns("editeur"),
          editeur_initial_value = r_local$current_book$editeur
        )
      )

      golem::invoke_js(
        "modal_modify_book_in_collection",
        message = list(
          id_valider_modification = ns("do_i_modify_the_book_in_collection"),
          html = create_html_for_modal_modify_book_in_collection(
            current_book = r_local$current_book,
            ns = ns
          ) |> as.character()
        )
      )
    })

    observeEvent(input$do_i_modify_the_book_in_collection, {
      req(input$do_i_modify_the_book_in_collection)

      append_res <- append_comics_db(
        ISBN = r_local$current_book$ISBN,
        auteur = input$auteur,
        titre = r_local$current_book$titre,
        possede = r_local$current_book$possede,
        annee_publication = input$annee_publication,
        nb_pages = input$nb_pages,
        editeur = input$editeur,
        note = input$note,
        type_publication = input$format,
        statut = input$etat,
        lien_cover = r_local$current_book$lien_cover
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

    observeEvent(input$delete_button_clicked, {
      golem::invoke_js(
        "modal_2_choices",
        message = list(
          id_resultat_modal = ns("do_i_delete_the_book_in_collection"),
          title = "Êtes-vous sûr de vouloir supprimer ce livre ?",
          text = "Vous ne pourrez pas revenir en arrière !",
          icon = "warning",
          confirmButtonText = "Oui, supprimer !",
          cancelButtonText = "Non, annuler"
        )
      )
    })
    observeEvent(input$do_i_delete_the_book_in_collection, {
      req(input$do_i_delete_the_book_in_collection)

      r_local$current_book <- r_global$comics_db |>
        dplyr::filter(id_document == input$document_to_delete_id) |>
        get_most_recent_entry_per_doc()

      append_res <- append_comics_db(
        ISBN = r_local$current_book$ISBN,
        auteur = r_local$current_book$auteur,
        titre = r_local$current_book$titre,
        possede = -1,
        annee_publication = r_local$current_book$annee_publication,
        nb_pages = r_local$current_book$nb_pages,
        editeur = r_local$current_book$editeur,
        note = r_local$current_book$note,
        type_publication = r_local$current_book$type_publication,
        statut = r_local$current_book$statut,
        lien_cover = r_local$current_book$lien_cover
      )

      if (append_res == 1) {
        golem::invoke_js(
          "call_sweetalert2",
          message = list(
            type = "success",
            msg = "Le livre a été supprimé avec succès"
          )
        )
      } else {
        golem::invoke_js(
          "call_sweetalert2",
          message = list(
            type = "error",
            msg = "Le livre n'a pu être supprimé"
          )
        )
      }

      r_global$comics_db <- read_comics_db()
    })
  })
}

## To be copied in the UI
# mod_130_manage_collection_ui("130_poc_gridjs_1")

## To be copied in the server
# mod_130_manage_collection_server("130_poc_gridjs_1")
