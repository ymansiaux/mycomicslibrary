#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#' @param img_dir The directory where the images will be stored.
#' @param cover_dir The directory where the covers will be stored.
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  onStart = NULL,
  options = list(),
  enableBookmarking = NULL,
  uiPattern = "/",
  img_dir = tempfile(),
  cover_dir = tempfile(),
  ...
) {
  dir.create(img_dir)
  shiny::addResourcePath("img_app", img_dir)
  file.copy(
    file.path(
      app_sys(
        "app",
        "www",
        "img"
      ),
      "image-not-found.jpg"
    ),
    file.path(img_dir, "image-not-found.jpg")
  )

  if (isTRUE(getOption("golem.app.prod"))) {
    cover_dir <- Sys.getenv("cover.dir")
  } else {
    cover_dir <- app_sys(
      "app",
      "www",
      "covers"
    )
  }


  shiny::addResourcePath("covers", cover_dir)

  with_golem_options(
    app = shinyApp(
      ui = app_ui,
      server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}
