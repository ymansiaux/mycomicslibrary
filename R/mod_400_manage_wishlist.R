#' 140_manage_wishlist UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_400_manage_wishlist_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$div(
      tags$h4(id = ns("nobook"), "Aucun livre dans la liste d'envies pour le moment", style = "display: none;"),
      tags$div(id = ns("my_wishlist"))
    )
  )
}

#' 140_manage_wishlist Server Functions
#'
#' @noRd
mod_400_manage_wishlist_server <- function(id, r_global) {
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
        filter(possede == 0) |>
        prepare_comics_db_to_see_wishlist(
          ns = ns
        )
    })

    observeEvent(r_local$current_db, {
      req(nrow(r_local$current_db) > 0)

      golem::invoke_js(
        "build_my_wishlist",
        list(
          id = ns("my_wishlist"),
          columns = names(r_local$current_db),
          data = do.call(cbind, lapply(r_local$current_db, as.character))
        )
      )
    })

    observeEvent(input$add_to_collection_button_clicked, {
      req(input$add_to_collection_button_clicked)

      golem::invoke_js(
        "modal_2_choices",
        message = list(
          id_resultat_modal = ns("do_i_move_the_book_in_collection"),
          title = "Êtes-vous sûr de vouloir déplacer ce livre dans votre collection ?",
          text = "Vous ne pourrez pas revenir en arrière !",
          icon = "warning",
          confirmButtonText = "Oui, déplacer !",
          cancelButtonText = "Non, annuler"
        )
      )
    })


    observeEvent(input$delete_button_clicked, {
      req(input$delete_button_clicked)

      golem::invoke_js(
        "modal_2_choices",
        message = list(
          id_resultat_modal = ns("do_i_delete_the_book_in_wishlist"),
          title = "Êtes-vous sûr de vouloir supprimer ce livre ?",
          text = "Vous ne pourrez pas revenir en arrière !",
          icon = "warning",
          confirmButtonText = "Oui, supprimer !",
          cancelButtonText = "Non, annuler"
        )
      )
    })

    observeEvent(input$do_i_move_the_book_in_collection, {
      r_local$current_book <- r_global$comics_db |>
        dplyr::filter(id_document == input$document_to_add_to_collection_id) |>
        get_most_recent_entry_per_doc()

      append_res <- append_comics_db(
        ISBN = r_local$current_book$ISBN,
        auteur = r_local$current_book$auteur,
        titre = r_local$current_book$titre,
        possede = 1,
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
            msg = "Le livre a été déplacé avec succès"
          )
        )
      } else {
        golem::invoke_js(
          "call_sweetalert2",
          message = list(
            type = "error",
            msg = "Le livre n'a pu être déplacé"
          )
        )
      }

      r_global$comics_db <- read_comics_db()
    })
    observeEvent(input$do_i_delete_the_book_in_wishlist, {
      req(input$do_i_delete_the_book_in_wishlist)

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
# mod_400_manage_wishlist_ui("140_manage_wishlist_1")

## To be copied in the server
# mod_400_manage_wishlist_server("140_manage_wishlist_1")
