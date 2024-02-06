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

  # Your application server logic
  # session$sendCustomMessage("quagga", message = list(src = "www/avec_code_barres.jpg"))
  # session$sendCustomMessage("quagga", message = list(src = "www/sans_code_barres.jpg"))
  mod_100_search_isbn_server("100_search_isbn_1")
}
