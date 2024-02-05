#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  session$sendCustomMessage("quagga", message = list(src = "www/avec_code_barres.jpg"))
  session$sendCustomMessage("quagga", message = list(src = "www/sans_code_barres.jpg"))
}
