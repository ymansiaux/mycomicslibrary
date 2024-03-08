#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # observe({
  #   session$onSessionEnded(stopApp)
  # })

  session$onSessionEnded(function() {
    removeResourcePath("img_app")
    if (Sys.getenv("COMICS_SQL_PATH_INIT") == "empty") {
      unlink(Sys.getenv("COMICS_SQL_PATH"))
      Sys.setenv(COMICS_SQL_PATH = "")
    }
  })

  r_global <- reactiveValues()

  # Init comics db
  observeEvent(TRUE, once = TRUE, {
    print(Sys.getenv("COMICS_SQL_PATH"))
    env_var_are_missing <- FALSE
    msg <- ""
    if (Sys.getenv("COMICS_SQL_PATH") == "") {
      msg <- paste0(msg, "La variable d'environnement 'COMICS_SQL_PATH' n'est pas renseignée. Un fichier temporaire sera utilisé, vous ne pourrez pas retrouver le contenu de votre base la prochaine fois !<br>")
      env_var_are_missing <- TRUE
      Sys.setenv(COMICS_SQL_PATH = tempfile(fileext = ".sqlite"))
      Sys.setenv(COMICS_SQL_PATH_INIT = "empty")
    }

    if (Sys.getenv("COVERS_PATH") == "") {
      env_var_are_missing <- TRUE
      msg <- paste0(
        msg,
        "<br>La variable d'environnement 'COVERS_PATH' n'est pas renseignée. Un dossier temporaire sera utilisé, vous ne pourrez pas retrouver les images de couverture de vos BD la prochaine fois !"
      )
    }

    if (env_var_are_missing) {
      msg <- paste0(
        "<p>",
        msg,
        "</p>"
      )
      golem::invoke_js(
        "call_sweetalert2",
        message = list(
          type = "warning",
          msg = msg
        )
      )
    }
    # unlink(get_database_path())

    init_db <- try(
      init_comics_db()
    )
    r_global$comics_db_init <- !inherits(init_db, "try-error")
    r_global$resource_path <- resourcePaths()["img_app"]
    r_global$cover_path <- resourcePaths()["covers"]
  })



  observeEvent(r_global$comics_db_init, {
    req(r_global$comics_db_init)

    if (isTRUE(r_global$comics_db_init)) {
      r_global$comics_db <- read_comics_db()
      print(r_global$comics_db)
      mod_100_search_isbn_server("100_search_isbn_1", r_global)
      mod_200_add_picture_server("120_add_picture_1", r_global)
      mod_300_manage_collection_server("130_poc_gridjs_1", r_global)
      mod_400_manage_wishlist_server("140_manage_wishlist_1", r_global)
      mod_500_chartjs_server("500_chartjs_1", r_global)
    }
  })

  #  Webcam related operations are kept at the root level
  #  Because if it is located inside a module and called in a addCustomMessageHandler, it will not work (it never asks the user if it wants to use the webcam)
  observeEvent(input$base64url, {
    img_name <- file.path(
      r_global$resource_path,
      basename(tempfile(fileext = ".jpg"))
    )

    export_img_from_dataurl(
      dataurl = input$base64url,
      output_img = img_name
    )


    session$userData$uploaded_img <- c(
      session$userData$uploaded_img,
      file.path(
        "img_app",
        basename(img_name)
      )
    )
    r_global$new_picture_taken <- Sys.time()
  })
}
