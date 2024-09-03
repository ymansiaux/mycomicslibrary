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
    if(Sys.getenv(paste0("COMICS_USER_STORAGE", session$token)) != "") {
      unlink(Sys.getenv(paste0("COMICS_USER_STORAGE", session$token)), recursive = TRUE)
    }
  })


  # Init comics db
  observeEvent(TRUE, once = TRUE, {
    env_var_are_missing <- FALSE
    print(session$token)
    
    # Deal with storage folders
    user_storage <- file.path(tempfile(), session$token)
    args = list(user_storage)
    names(args) = paste0("COMICS_USER_STORAGE", session$token)
    do.call(Sys.setenv, args)
    dir.create(user_storage, recursive = TRUE)
    print(Sys.getenv(paste0("COMICS_USER_STORAGE", session$token)))
    ## Store picture taken from webcam and uploaded by users
    img_dir <- file.path(user_storage, "imgs")
    dir.create(img_dir, recursive = TRUE)
    shiny::addResourcePath(paste0("img_app",session$token), img_dir)
    
    ## sqlite directory
    if (Sys.getenv("COMICS_SQL_PATH") == "") {
      env_var_are_missing <- TRUE
      print("using a tempfile for sql")
      sql_dir <- file.path(user_storage, "sql")
      dir.create(sql_dir, recursive = TRUE)
      sql_db <- tempfile(tmpdir = sql_dir, fileext = ".sqlite")  
      file.create(sql_db)
      args = list(sql_db)
      names(args) = paste0("SQL_STORAGE_PATH", session$token)
      do.call(Sys.setenv, args)
    } else {
      args = list(Sys.getenv("COMICS_SQL_PATH"))
      names(args) = paste0("SQL_STORAGE_PATH", session$token)
      do.call(Sys.setenv, args)
    }
    
    ## covers
    if (Sys.getenv("COVERS_PATH") == "") {
      print("using a tempfile for covers")
      covers_dir <- file.path(user_storage, "covers")
      dir.create(covers_dir, recursive = TRUE)
      args = list(covers_dir)
      names(args) = paste0("COVERS_STORAGE_PATH", session$token)
      do.call(Sys.setenv, args)
    } else {
      args = list(Sys.getenv("COVERS_PATH"))
      names(args) = paste0("COVERS_STORAGE_PATH", session$token)
      do.call(Sys.setenv, args)
    }
    file.copy(
      file.path(
        app_sys(
          "img"
        ),
        "image-not-found.jpg"
      ),
      file.path(covers_dir, "image-not-found.jpg")    )
 
    shiny::addResourcePath(paste0("covers",session$token), Sys.getenv(paste0("COVERS_STORAGE_PATH", session$token)))
    
    if (env_var_are_missing) {
      msg <- paste0("You are using a demo version of the app, which means you won't be able to retrieve the content of your library at your next visit. To be able to fully use mycomicslibrary, please visit the ",
                    "<a href='https://github.com/ymansiaux/mycomicslibrary' target='_blank' rel='noreferrer'>",
                    "Github repository </a>",
                    "everything you need to know is explained there :-)"
      )
      golem::invoke_js(
        "call_sweetalert2_with_html",
        message = list(
          type = "info",
          html = msg
        )
      )
    }

    init_db <- try(
      init_comics_db()
    )
    r_global$comics_db_init <- !inherits(init_db, "try-error")
    r_global$resource_path <- resourcePaths()[paste0("img_app",session$token)]
    r_global$cover_path <- resourcePaths()[paste0("covers",session$token)]
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

  # Webcam related operations are kept at the root level
  # Because if it is located inside a module and called in a addCustomMessageHandler, it will not work (it never asks the user if it wants to use the webcam)
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
        paste0("img_app",session$token),
        basename(img_name)
      )
    )
    r_global$new_picture_taken <- Sys.time()
  })
}
