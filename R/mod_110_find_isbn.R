#' 110_find_isbn UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom bslib card card_header card_body
mod_110_find_isbn_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 12,
        card(
          card_header(
            class = "bg-dark",
            "Chercher une BD à partir de son ISBN (10 ou 13 chiffres)"
          ),
          card_body(
            fluidRow(
              column(
                width = 6,
                div(
                  style = "
                  display: flex;
                  flex-direction: column;
                  justify-content: space-around;
                  height: 300px;
                  ",
                  div(
                    h4("Recherche par ISBN"),
                    div(
                      style = "padding-top:0.5em;",
                      textInput(
                        inputId = ns("isbn"),
                        label = "ISBN",
                        placeholder = "ISBN (10 ou 13 chiffres)",
                        value = "9782365772013"
                      )
                    ),
                    div(
                      style = "
                       padding: 10px;
                       padding-top: 0px;
                       font-size: .75rem;
                       color: #FF0000BB;",
                      id = ns("error_isbn_length"),
                      "L'ISBN doit contenir 10 ou 13 chiffres"
                    )
                  ),
                  div(
                    actionButton(
                      inputId = ns("surprise_me"),
                      label = "Surprends moi !",
                      icon = icon("surprise")
                    )
                  ),
                  div(
                    actionButton(
                      inputId = ns("add_barcode_picture"),
                      label = "Importer une photo de code-barres",
                      icon = icon("camera"),
                      onclick = "window.location.href = '#detectisbn';"
                    )
                  ),
                  div(
                    style = "padding-top: 1em;",
                    actionButton(
                      inputId = ns("search"),
                      label = "Rechercher le livre",
                      icon = icon("search")
                    )
                  )
                )
              ),
              column(
                width = 6,
                div(
                  style = "
                  display: flex;
                  flex-direction: column;
                  align-items: center;
                  justify-content: space-around;
                  align-items: center;
                  height: 300px;
                  border-left: grey dotted;
                  padding-left: 1em;
                  ",
                  div(
                    actionButton(
                      inputId = ns("show_api_call_result"),
                      label = "Pas de résultat à afficher pour le moment"
                    ) |> shiny::tagAppendAttributes("disabled" = "disabled")
                  )
                )
              )
            )
          )
        )
      )
    )
  )
}

#' 110_find_isbn Server Functions
#' @importFrom dplyr filter
#' @noRd
mod_110_find_isbn_server <- function(id, r_global) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns

      r_local <- reactiveValues(
        isbn_is_valid = FALSE,
        api_call_status = NULL,
        api_res = NULL,
        cleaned_res = NULL
      )

      observeEvent(
        input$isbn,
        {
          req(input$isbn)

          if (nchar(as.character(input$isbn)) %in% c(10, 13)) {
            r_local$isbn_is_valid <- TRUE
          } else {
            r_local$isbn_is_valid <- FALSE
          }
        }
      )

      observeEvent(input$surprise_me, {
        updateTextInput(
          session = session,
          inputId = "isbn",
          value = give_me_one_random_isbn()
        )
      })

      observeEvent(r_local$isbn_is_valid, {
        if (r_local$isbn_is_valid) {
          golem::invoke_js("reable", paste0("#", ns("search")))
          golem::invoke_js("hide", paste0("#", ns("error_isbn_length")))
        } else {
          golem::invoke_js("disable", paste0("#", ns("search")))
          golem::invoke_js("show", paste0("#", ns("error_isbn_length")))
        }
      })

      observeEvent(r_global$do_i_keep_the_isbn, {
        req(r_global$do_i_keep_the_isbn)
        if (r_global$do_i_keep_the_isbn) {
          updateTextInput(
            session = session,
            inputId = "isbn",
            value = r_global$detected_barcode_quagga
          )
        }
      })

      observeEvent(input$search, {
        req(input$isbn)
        req(r_local$isbn_is_valid)

        api_res <- call_open_library_api(
          isbn_number = input$isbn
        )

        if (inherits(api_res, "try-error")) {
          r_local$api_call_status <- "error"
        } else if (nrow(api_res) == 0) {
          r_local$api_call_status <- "warning"
        } else {
          r_local$api_call_status <- "success"
        }

        r_local$api_res <- api_res
      })

      observeEvent(r_local$api_call_status, {
        req(r_local$api_call_status)

        if (r_local$api_call_status == "error") {
          golem::invoke_js("disable", paste0("#", ns("show_api_call_result")))
          updateActionButton(
            session = session,
            inputId = "show_api_call_result",
            label = "Erreur lors de l'appel à l'API",
            icon = icon("exclamation-triangle")
          )
        } else if (r_local$api_call_status == "warning") {
          golem::invoke_js("disable", paste0("#", ns("show_api_call_result")))
          updateActionButton(
            session = session,
            inputId = "show_api_call_result",
            label = "Aucun résultat à afficher",
            icon = icon("exclamation-triangle")
          )
        } else {
          golem::invoke_js("reable", paste0("#", ns("show_api_call_result")))
          updateActionButton(
            session = session,
            inputId = "show_api_call_result",
            label = "Afficher le résultat",
            icon = icon("check")
          )
        }
      })

      observeEvent(input$show_api_call_result, {
        req(r_local$api_res)

        r_local$cleaned_res <- clean_open_library_result(
          book_tibble = r_local$api_res
        )
        book_cover <- try(
          get_cover(
            isbn_number = input$isbn,
            cover_size = "M"
          ),
          silent = TRUE
        )

        golem::invoke_js(
          "waitForButtons",
          message = list(
            buttonToWaitFor1 = ns("add_to_wishlist"),
            buttonToWaitFor2 = ns("add_to_library"),
            shinyinput = ns("do_i_add_to_library"),
            triggerid = ns("trigger")
          )
        )


        shiny_alert_api_result(
          book = r_local$cleaned_res,
          book_cover = book_cover,
          add_library_button_id = ns("add_to_library"),
          add_wishlist_button_id = ns("add_to_wishlist"),
          cancel_button_id = ns("leave_modal")
        )
      })

      observeEvent(input$trigger, {
        req(r_local$cleaned_res)

        to_add <- list(
          ISBN = r_local$cleaned_res$isbn_13,
          titre = r_local$cleaned_res$title,
          date_publication = r_local$cleaned_res$publish_date,
          nb_pages = r_local$cleaned_res$number_of_pages,
          editeur = r_local$cleaned_res$publisher,
          note = "",
          type_publication = "",
          statut = "",
          lien_cover = get_cover(
            isbn_number = r_local$cleaned_res$isbn_13
          )
        )

        if (input$do_i_add_to_library) {
          to_add$possede <- 1
        } else {
          to_add$possede <- 0
        }

        is_the_book_already_in_db <- read_comics_db() |>
          filter(ISBN == to_add$ISBN) |>
          nrow()
        is_the_book_already_in_db <- is_the_book_already_in_db > 0

        if (isTRUE(is_the_book_already_in_db)) {
          golem::invoke_js(
            "call_sweetalert2",
            message = list(
              type = "error",
              msg = "Ce livre est déjà dans la base de données."
            )
          )
        } else {
          append_res <- append_comics_db(
            ISBN = to_add$ISBN,
            titre = to_add$titre,
            possede = to_add$possede,
            date_publication = to_add$date_publication,
            nb_pages = to_add$nb_pages,
            editeur = to_add$editeur,
            note = to_add$note,
            type_publication = to_add$type_publication,
            statut = to_add$statut,
            lien_cover = to_add$lien_cover
          )
          if (append_res == 1) {
            golem::invoke_js(
              "call_sweetalert2",
              message = list(
                type = "success",
                msg = "Le livre a été ajouté avec succès"
              )
            )

            r_global$comics_db <- read_comics_db()
          } else {
            golem::invoke_js(
              "call_sweetalert2",
              message = list(
                type = "error",
                msg = "Le livre n'a pu être ajouté à la base de données"
              )
            )
          }
        }

        print(read_comics_db())
      })
    }
  )
}

## To be copied in the UI
# mod_110_find_isbn_ui("110_find_isbn_1")

## To be copied in the server
# mod_110_find_isbn_server("110_find_isbn_1")
