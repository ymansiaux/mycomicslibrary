#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  on.exit({
    file.remove(app_sys(
      "app/www/uploaded_picture.jpg"
    ))
  })

  # Your application server logic
  # session$sendCustomMessage("quagga", message = list(src = "www/avec_code_barres.jpg"))
  # session$sendCustomMessage("quagga", message = list(src = "www/sans_code_barres.jpg"))
  mod_100_search_isbn_server("100_search_isbn_1")
}
