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
  
  r_global <- reactiveValues()
  

  session$onSessionEnded(function() {
    if(Sys.getenv("COMICS_USER_STORAGE") != "") {
      unlink(Sys.getenv("COMICS_USER_STORAGE"), recursive = TRUE)  
    }
  })


  # Init comics db
  observeEvent(TRUE, once = TRUE, {
    env_var_are_missing <- FALSE
    # Deal with storage folders
    user_storage <- file.path(tempfile(), session$token)
    Sys.setenv("COMICS_USER_STORAGE" = user_storage)
    dir.create(user_storage, recursive = TRUE)
    ## Store picture taken from webcam and uploaded by users
    img_dir <- file.path(user_storage, "imgs")
    dir.create(img_dir, recursive = TRUE)
    shiny::addResourcePath("img_app", img_dir)
    
    ## sqlite directory
    if (Sys.getenv("COMICS_SQL_PATH") == "") {
      env_var_are_missing <- TRUE
      print("using a tempfile for sql")
      sql_dir <- file.path(user_storage, "sql")
      dir.create(sql_dir, recursive = TRUE)
      sql_db <- tempfile(tmpdir = sql_dir, fileext = ".sqlite")  
      file.create(sql_db)
      Sys.setenv(SQL_STORAGE_PATH = sql_db)
    } else {
      Sys.setenv(SQL_STORAGE_PATH = Sys.getenv("COMICS_SQL_PATH"))
    }
    
    ## covers
    cover_dir <- Sys.getenv("COVERS_PATH", unset = file.path(user_storage, "covers"))
    if (!dir.exists(cover_dir)) {
      dir.create(cover_dir, recursive = TRUE)
    }
    print(list.files(cover_dir))
    
    shiny::addResourcePath("covers", cover_dir)

    
    if (env_var_are_missing) {
      msg <- "You are using a demo version of the app, which means you won't be able to retrieve the content of your library at your next visit. To be able to fully use mycomicslibrary, please visit the Github repository, everything you need to know is explained there :-)"
      golem::invoke_js(
        "call_sweetalert2",
        message = list(
          type = "info",
          msg = msg
        )
      )
    }

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
