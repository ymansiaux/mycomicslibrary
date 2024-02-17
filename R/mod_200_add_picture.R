#' 120_add_picture UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_200_add_picture_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 10,
        card(
          card_header(
            class = "bg-dark",
            "Chercher une BD à partir de son ISBN (10 ou 13 chiffres)"
          ),
          card_body(
            fluidRow(
              column(
                width = 12,
                h4("Détecter un ISBN à partir d'une photo"),
                div(
                  style = "
                  padding-top: 1em;
                  display: flex;
                  flex-direction: column;
                  justify-content: space-around;
                  ",
                  div(
                    style = "
                  display: flex;
                  flex-direction: row;
                  justify-content: space-between;
                  ",
                    div(
                      fileInput(
                        inputId = ns("upload_picture"),
                        label = "Uploader une photo",
                        buttonLabel = "Choisir une photo",
                        placeholder = "Aucune photo sélectionnée",
                        accept = "image/*"
                      )
                    ),
                    div(
                      htmlTemplate(
                        app_sys("app/www/templates_html/template_webcam.html"),
                        button1 = tagList(
                          actionButton(
                            inputId = "webcam-start-camera",
                            label = "Démarrer la caméra",
                            onclick = "showcameraelements()"
                          )
                        ),
                        button2 = tagList(
                          actionButton(
                            inputId = "webcam-click-photo",
                            label = "Prendre une photo"
                          )
                        ),
                        button3 = tagList(
                          actionButton(
                            inputId = "webcam-stop-camera",
                            label = "Arrêter la caméra",
                            onclick = "hidecameraelements()"
                          )
                        ),
                      )
                    )
                  ),
                  div(
                    style = "
                            align-items: center;
                            text-align: center;
                            border-top: black dotted;
                            padding-top: 1em;
                            ",
                    uiOutput(ns("current_image")),
                    actionButton(
                      inputId = ns("detect_isbn_from_picture"),
                      label = "Détecter l'ISBN"
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

#' 120_add_picture Server Functions
#' @importFrom reticulate source_python
#' @noRd
mod_200_add_picture_server <- function(id, r_global) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    r_local <- reactiveValues(
      uploaded_img = NULL,
      last_picture = NULL,
      detected_barcode = NULL
    )

    observeEvent(
      r_global$new_picture_taken,
      {
        req(r_global$new_picture_taken)
        r_local$last_picture <- session$userData$uploaded_img[length(
          session$userData$uploaded_img
        )]
      }
    )

    output$current_image <- renderUI({
      req(r_local$last_picture)
      tags$img(
        src = r_local$last_picture,
        style = "max-width: 25%;"
      )
    })

    observeEvent(input$upload_picture$datapath, {
      req(input$upload_picture$datapath)

      img_name <- tempfile(fileext = ".jpg")

      file.copy(
        from = input$upload_picture$datapath,
        to = file.path(
          app_sys("app/www/img_tmp"),
          basename(img_name)
        ),
        overwrite = TRUE
      )

      r_local$uploaded_img <- file.path(
        "www",
        "img_tmp",
        basename(img_name)
      )

      session$userData$uploaded_img <- c(
        session$userData$uploaded_img,
        r_local$uploaded_img
      )
      r_global$new_picture_taken <- Sys.time()
    })

    observeEvent(input$detect_isbn_from_picture, {
      req(r_local$last_picture)

      source_python(app_sys("python/decode_photo.py"))
      detected_barcode_python <- decode_my_photo(
        app_sys("app", r_local$last_picture)
      )

      if (length(detected_barcode_python) == 0) {
        r_local$detected_barcode <- "none"
      } else {
        r_local$detected_barcode <- detected_barcode_python[1]
      }
      r_local$trigger <- Sys.time()
    })

    observeEvent(r_local$trigger, {
      req(r_local$detected_barcode)
      if (r_local$detected_barcode == "none") {
        golem::invoke_js(
          "call_sweetalert2",
          message = list(
            type = "error",
            msg = "Aucun ISBN détecté"
          )
        )
      } else {
        golem::invoke_js(
          "modal_result_detect_isbn",
          message = list(
            msg = paste0("ISBN détecté: ", r_local$detected_barcode),
            id = ns("do_i_keep_the_isbn")
          )
        )
      }
    })

    observeEvent(
      input$do_i_keep_the_isbn,
      {
        r_global$do_i_keep_the_isbn <- as.logical(input$do_i_keep_the_isbn)
        r_global$detected_barcode <- r_local$detected_barcode
      }
    )
  })
}

## To be copied in the UI
# mod_200_add_picture_ui("120_add_picture_1")

## To be copied in the server
# mod_200_add_picture_server("120_add_picture_1")
