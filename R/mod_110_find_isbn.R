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
        width = 6,
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
                  height: 250px;
                  ",
                  div(
                    textInput(
                      inputId = ns("isbn"),
                      label = "ISBN",
                      placeholder = "ISBN (10 ou 13 chiffres)"
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
                    h3("Détecter un ISBN à partir d'une photo"),
                    fileInput(
                      inputId = ns("upload_picture"),
                      label = "Uploader une photo",
                      accept = "image/*"
                    ),
                    actionButton(
                      inputId = ns("detect_isbn_from_picture"),
                      label = "Détecter l'ISBN"
                    )
                  ),
                  div(
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
                h3("cocuou")
              )
            )
          )
        )
      )
    )
  )
}

#' 110_find_isbn Server Functions
#'
#' @noRd
mod_110_find_isbn_server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns

      r_local <- reactiveValues(
        isbn_is_valid = FALSE,
        uploaded_img = NULL
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

      observeEvent(input$upload_picture, {
        req(input$upload_picture)

        file.copy(
          from = input$upload_picture$datapath,
          to = file.path(
            app_sys("app/www/"),
            "uploaded_picture.jpg"
          ),
          overwrite = TRUE
        )
        r_local$uploaded_img <- "www/uploaded_picture.jpg"
      })

      observeEvent(input$detect_isbn_from_picture, {
        req(r_local$uploaded_img)
        golem::invoke_js(
          "quagga",
          message = list(src = r_local$uploaded_img)
        )
      })

      observeEvent(input$detected_barcode_quagga, {
        req(input$detected_barcode_quagga)
        # Faire un template de modal qui affiche le résultat, et permet si on veut de mettre à jour l'ISBN
      })



      observeEvent(r_local$isbn_is_valid, {
        if (r_local$isbn_is_valid) {
          golem::invoke_js("reable", paste0("#", ns("search")))
        } else {
          golem::invoke_js("disable", paste0("#", ns("search")))
        }
      })
    }
  )
}

## To be copied in the UI
# mod_110_find_isbn_ui("110_find_isbn_1")

## To be copied in the server
# mod_110_find_isbn_server("110_find_isbn_1")
