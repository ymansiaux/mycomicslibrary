
#' Show spinner
#'
#' @param inputId spinner div id
#' @return side effect. show spinner
#' @rdname fct_spinner
#' @noRd
showSpinner <- function(
  inputId,
  session = shiny::getDefaultReactiveDomain()
) {
  session$sendCustomMessage("show_spinner", inputId)
}

#' Hide spinner
#'
#' @param inputId spinner div id
#' @param session session
#' @return side effect. Hide le spinner
#' @rdname fct_spinner
#' @noRd
hideSpinner <- function(
  inputId,
  session = shiny::getDefaultReactiveDomain()
) {
  session$sendCustomMessage("hide_spinner", inputId)
}

#' withSpinner
#' @param expr L'operation a realiser.
#' @param session session shiny
#' @return html
#' @rdname fct_spinner
#' @noRd
withSpinner <- function(
  expr,
  session = shiny::getDefaultReactiveDomain()
) {
  showSpinner(inputId = "lds-ring", session = session)
  force(expr)
  on.exit(hideSpinner(inputId = "lds-ring", session = session))
}
