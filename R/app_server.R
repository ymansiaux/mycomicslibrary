#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  observe({
    session$onSessionEnded(stopApp)
  })

  session$onSessionEnded(function() {
    if (length(session$userData$uploaded_img) > 0) {
      sapply(
        session$userData$uploaded_img,
        function(x) {
          if (file.exists(
            file.path(app_sys("app"), x)
          )) {
            file.remove(
              file.path(app_sys("app"), x)
            )
          }
        }
      )
    }
  })

  r_global <- reactiveValues()

  # Init comics db
  observeEvent(TRUE, once = TRUE, {
    # unlink(get_database_path())
    init_db <- try(
      init_comics_db()
    )
    r_global$comics_db_init <- !inherits(init_db, "try-error")
  })



  observeEvent(r_global$comics_db_init, {
    req(r_global$comics_db_init)
    # golem::invoke_js(
    #   "call_sweetalert2",
    #   message = list(
    #     type = "autoclose",
    #     msg = "Connexion à la base de données réussie"
    #   )
    # )
    if (isTRUE(r_global$comics_db_init)) {
      r_global$comics_db <- read_comics_db()
      print(r_global$comics_db)
      mod_100_search_isbn_server("100_search_isbn_1", r_global)
      mod_200_add_picture_server("120_add_picture_1", r_global)
      mod_130_manage_collection_server("130_poc_gridjs_1", r_global)
      mod_140_manage_wishlist_server("140_manage_wishlist_1", r_global)
    }
  })

  #  Webcam related operations are kept at the root level
  #  Because if it is located inside a module and called in a addCustomMessageHandler, it will not work (it never asks the user if it wants to use the webcam)
  observeEvent(input$base64url, {
    img_name <- file.path(
      app_sys("app/www/img_tmp"),
      basename(tempfile(fileext = ".jpg"))
    )

    export_img_from_dataurl(
      dataurl = input$base64url,
      output_img = img_name
    )


    session$userData$uploaded_img <- c(
      session$userData$uploaded_img,
      file.path(
        "www",
        "img_tmp",
        basename(img_name)
      )
    )
    r_global$new_picture_taken <- Sys.time()
  })
}
# 9782917371329
