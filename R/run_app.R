#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  onStart = NULL,
  options = list(),
  enableBookmarking = NULL,
  uiPattern = "/",
  img_dir = tempfile(),
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

  file.path(
    app_sys(
      "app",
      "www",
      "img"
    ),
    "image-not-found.jpg"
  )
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
