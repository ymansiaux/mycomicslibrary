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
        # tags$img(src = "img_app/image-not-found.jpg", width = "100%"),
        card(
          card_header(
            class = "bg-dark",
            "Search for a book by its ISBN (10 or 13 digits)"
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
                        placeholder = "ISBN (10 ou 13 digits)",
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
                      "L'ISBN must be 10 or 13 digits-long"
                    )
                  ),
                  div(
                    actionButton(
                      inputId = ns("surprise_me"),
                      label = "Surprise me !",
                      icon = icon("surprise")
                    )
                  ),
                  div(
                    actionButton(
                      inputId = ns("add_barcode_picture"),
                      label = "Use a barcode picture",
                      icon = icon("camera"),
                      onclick = "window.location.href = '#detectisbn';"
                    )
                  ),
                  div(
                    style = "padding-top: 1em;",
                    actionButton(
                      inputId = ns("search"),
                      label = "Search",
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
                      label = "No results found"
                    ) |> shiny::tagAppendAttributes(
                      "disabled" = "disabled"
                    )
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

      observeEvent(
        input$isbn,
        ignoreInit = TRUE,
        {
          golem::invoke_js(
            "disable",
            paste0("#", ns("show_api_call_result"))
          )

          updateActionButton(
            session = session,
            inputId = "show_api_call_result",
            label = "Search again with the new ISBN",
            icon = icon("exclamation-triangle")
          )

          golem::invoke_js(
            "removeClassToAButton",
            message = list(
              id = ns("show_api_call_result"),
              class = "btn-danger"
            )
          )
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
          golem::invoke_js(
            "addClassToAButton",
            message = list(
              id = ns("search"),
              class = "btn-secondary"
            )
          )
        } else {
          golem::invoke_js("disable", paste0("#", ns("search")))
          golem::invoke_js("show", paste0("#", ns("error_isbn_length")))
          golem::invoke_js(
            "removeClassToAButton",
            message = list(
              id = ns("search"),
              class = "btn-secondary"
            )
          )
        }
      })

      observeEvent(r_global$trigger_isbn, {
        req(r_global$do_i_keep_the_isbn)
        if (r_global$do_i_keep_the_isbn) {
          updateTextInput(
            session = session,
            inputId = "isbn",
            value = r_global$detected_barcode
          )

          r_local$trigger_new_search_from_isbn_detected_on_barcode <- Sys.time()
        }
      })

      observeEvent(r_local$trigger_new_search_from_isbn_detected_on_barcode, {
        req(r_local$trigger_new_search_from_isbn_detected_on_barcode)
        golem::invoke_js(
          "updateIsbnValue",
          message = list(
            isbn_field_id = ns("isbn"),
            new_val = r_global$detected_barcode
          )
        )
        golem::invoke_js(
          "clickon",
          paste0("#", ns("search"))
        )
      })

      observeEvent(input$search, {
        req(input$isbn)
        req(r_local$isbn_is_valid)

        withSpinner(
          expr = {
            api_res <- call_open_library_api_mem(
              isbn_number = input$isbn
            )
          }
        )
        if (inherits(api_res, "try-error")) {
          r_local$api_call_status <- "error"
        } else if (api_res$numFound == 0) {
          r_local$api_call_status <- "warning"
        } else {
          r_local$api_call_status <- "success"
        }
        r_local$trigger_api_call_status <- Sys.time()
        r_local$api_res <- api_res
      })

      observeEvent(r_local$trigger_api_call_status, {
        req(r_local$api_call_status)

        golem::invoke_js(
          "removeClassToAButton",
          message = list(
            id = ns("search"),
            class = "btn-secondary"
          )
        )

        golem::invoke_js(
          "removeClassToAButton",
          message = list(
            id = ns("show_api_call_result"),
            class = "btn-danger"
          )
        )

        if (r_local$api_call_status == "error") {
          golem::invoke_js(
            "disable",
            ns("show_api_call_result")
          )
          golem::invoke_js(
            "call_sweetalert2",
            message = list(
              type = "error",
              msg = "API call error"
            )
          )
          updateActionButton(
            session = session,
            inputId = "show_api_call_result",
            label = "API call error",
            icon = icon("exclamation-triangle")
          )
        } else if (r_local$api_call_status == "warning") {
          golem::invoke_js(
            "disable",
            paste0("#", ns("show_api_call_result"))
          )
          golem::invoke_js(
            "call_sweetalert2",
            message = list(
              type = "error",
              msg = "No book found !"
            )
          )
          updateActionButton(
            session = session,
            inputId = "show_api_call_result",
            label = "No result to display",
            icon = icon("exclamation-triangle")
          )
        } else {
          golem::invoke_js(
            "reable",
            paste0("#", ns("show_api_call_result"))
          )

          golem::invoke_js(
            "clickon",
            paste0("#", ns("show_api_call_result"))
          )

          golem::invoke_js(
            "addClassToAButton",
            message = list(
              id = ns("show_api_call_result"),
              class = "btn-danger"
            )
          )
          updateActionButton(
            session = session,
            inputId = "show_api_call_result",
            label = "Show the result",
            icon = icon("check")
          )
        }
      })

      observeEvent(input$show_api_call_result, {
        req(r_local$api_res)

        withSpinner(expr = {
          r_local$cleaned_res <- clean_open_library_result(
            book = r_local$api_res
          )
          r_local$book_cover <- file.path(
            "covers",
            basename(get_cover_mem(isbn_number = r_local$cleaned_res$isbn))
          )
        })

        golem::invoke_js(
          "modal_api_search_result",
          message = list(
            id_ajout_bibliotheque = ns("do_i_add_to_library"),
            html = create_html_for_modal_api_search_result(
              book = r_local$cleaned_res,
              book_cover = r_local$book_cover
            ) |> as.character()
          )
        )
      })

      observeEvent(input$do_i_add_to_library, {
        req(input$do_i_add_to_library)
        req(r_local$cleaned_res)

        to_add <- list(
          ISBN = r_local$cleaned_res$isbn,
          titre = r_local$cleaned_res$title,
          auteur = r_local$cleaned_res$author,
          annee_publication = r_local$cleaned_res$publish_date,
          nb_pages = r_local$cleaned_res$number_of_pages,
          editeur = r_local$cleaned_res$publisher,
          note = 1,
          type_publication = "A définir",
          statut = "A définir",
          lien_cover = r_local$book_cover
        ) |> map(function(x) {
          if (is.null(x)) {
            return("")
          } else {
            return(x)
          }
        })


        to_add$possede <- as.numeric(
          as.logical(
            input$do_i_add_to_library
          )
        )
        is_the_book_already_in_db <- read_comics_db() |>
          get_most_recent_entry_per_doc() |>
          filter(ISBN == to_add$ISBN)

        is_the_book_already_in_db <- nrow(is_the_book_already_in_db) > 0 & is_the_book_already_in_db$possede != -1

        if (isTRUE(is_the_book_already_in_db)) {
          golem::invoke_js(
            "call_sweetalert2",
            message = list(
              type = "error",
              msg = "This book is already present in your collection !"
            )
          )
        } else {
          append_res <- append_comics_db(
            ISBN = to_add$ISBN,
            auteur = to_add$auteur,
            titre = to_add$titre,
            possede = to_add$possede,
            annee_publication = to_add$annee_publication,
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
                msg = "The book has been added !"
              )
            )
          } else {
            golem::invoke_js(
              "call_sweetalert2",
              message = list(
                type = "error",
                msg = "The book was not added !"
              )
            )
          }
        }

        r_global$comics_db <- read_comics_db()
        r_global$new_entry_in_db <- Sys.time()
        print(read_comics_db())
      })
    }
  )
}

## To be copied in the UI
# mod_110_find_isbn_ui("110_find_isbn_1")

## To be copied in the server
# mod_110_find_isbn_server("110_find_isbn_1")
