
#' fileInput which does not scroll to the top of the page
#' @param inputId the input id
#' @param ... other arguments passed to fileInput
#' @return a file input
#' @importFrom htmltools tagQuery
#' @importFrom shiny fileInput
#' @noRd
#' @rdname fct_misc
customfileinput <- function(inputId, ...) {
  el <- fileInput(inputId, ...)

  tagQ <- htmltools::tagQuery(el)

  tagQ$
    find(sprintf("input#%s", inputId))$
    removeAttrs("style")$
    addAttrs("style" = "display:none;")$
    allTags()
}
