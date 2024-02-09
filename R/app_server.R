#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
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

  mod_100_search_isbn_server("100_search_isbn_1", r_global)
  mod_120_add_picture_server("120_add_picture_1", r_global)
}
