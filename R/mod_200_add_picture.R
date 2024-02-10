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
                width = 6,
                div(
                  style = "
                  display: flex;
                  flex-direction: column;
                  justify-content: space-around;
                  height: 250px;
                  ",
                  div(
                    h3("Détecter un ISBN à partir d'une photo"),
                    fileInput(
                      inputId = ns("upload_picture"),
                      label = "Uploader une photo",
                      buttonLabel = "Choisir une photo",
                      placeholder = "Aucune photo sélectionnée",
                      accept = "image/*"
                    ),
                    actionButton(
                      inputId = ns("detect_isbn_from_picture"),
                      label = "Détecter l'ISBN"
                    ),
                    actionButton(
                      inputId = ns("pause"),
                      label = "Pause"
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
#'
#' @noRd
mod_200_add_picture_server <- function(id, r_global) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    r_local <- reactiveValues(
      uploaded_img = NULL
    )

    observeEvent(input$pause, {
      browser()
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
    })

    observeEvent(input$detect_isbn_from_picture, {
      req(r_local$uploaded_img)
      golem::invoke_js(
        "quagga",
        message = list(
          src = r_local$uploaded_img,
          id = ns("detected_barcode_quagga"),
          quagga_has_finished = ns("quagga_has_finished")
        )
      )
    })

    observeEvent(
      input$do_i_keep_the_isbn,
      ignoreInit = TRUE,
      {
        r_global$do_i_keep_the_isbn <- as.logical(input$do_i_keep_the_isbn)
        r_global$detected_barcode_quagga <- input$detected_barcode_quagga
      }
    )

    observeEvent(input$quagga_has_finished, {
      req(input$detected_barcode_quagga)

      if (input$detected_barcode_quagga == "No barcode detected") {
        golem::invoke_js(
          "waitForButtons",
          message = list(
            buttonToWaitFor1 = ns("leave_modal_error"),
            buttonToWaitFor2 = ns("fake_button"),
            shinyinput = ns("do_i_keep_the_isbn")
          )
        )
        shiny_alert_isbn_not_detected_on_img(
          cancel_button_id = ns("leave_modal_error")
        )
      } else {
        golem::invoke_js(
          "waitForButtons",
          message = list(
            buttonToWaitFor1 = ns("leave_modal"),
            buttonToWaitFor2 = ns("validate_detected_isbn"),
            shinyinput = ns("do_i_keep_the_isbn")
          )
        )

        shiny_alert_isbn_detected_on_img(
          input$detected_barcode_quagga,
          validate_button_id = ns("validate_detected_isbn"),
          cancel_button_id = ns("leave_modal")
        )
      }
    })
  })
}

## To be copied in the UI
# mod_200_add_picture_ui("120_add_picture_1")

## To be copied in the server
# mod_200_add_picture_server("120_add_picture_1")