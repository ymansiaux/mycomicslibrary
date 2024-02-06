#' 120_add_picture UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_120_add_picture_ui <- function(id) {
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
                  height: 250px;
                  ",
                  div(
                    h3("Détecter un ISBN à partir d'une photo"),
                    fileInput(
                      inputId = ns("upload_picture"),
                      label = "Uploader une photo",
                      accept = "image/*"
                    ),
                    actionButton(
                      inputId = ns("take_picture_from_webcam"),
                      label = "Prendre une photo depuis la webcam"
                    ),
                    take_picture_from_webcam_ui(
                      id = ns("div_take_picture_from_webcam")
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
mod_120_add_picture_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    #  la partie gestion d'image doit être faite dans un autre module
    observeEvent(input$take_picture_from_webcam, {
      #  mettre un toggle à la place
      golem::invoke_js(
        "show",
        paste0("#", ns("div_take_picture_from_webcam"))
      )

      golem::invoke_js(
        "takewebcampicture",
        message = list(photo_id = "webcam_photo")
      )
    })

    observeEvent(input$pause, {
      browser()
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
  })
}

## To be copied in the UI
# mod_120_add_picture_ui("120_add_picture_1")

## To be copied in the server
# mod_120_add_picture_server("120_add_picture_1")
