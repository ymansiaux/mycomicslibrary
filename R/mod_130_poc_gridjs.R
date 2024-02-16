#' 130_poc_gridjs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_130_poc_gridjs_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$div(
      class = "col",
      h3("Top Ten Homme"),
      tags$div(id = ns("top_ten_homme"))
    )
  )
}

#' 130_poc_gridjs Server Functions
#'
#' @noRd
mod_130_poc_gridjs_server <- function(id, r_global) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observeEvent(r_global$comics_db, {
      # browser()

      db <- prepare_comics_db_to_see_collection(
        r_global$comics_db
      )

      browser()

      golem::invoke_js(
        "build_gridpochtml2",
        list(
          id = ns("top_ten_homme"),
          columns = names(db),
          data = do.call(cbind, lapply(db, as.character))
        )
      )
    })


    # observe({
    #   iris2 <- iris[1:10, "Species"] |>
    #     as.data.frame()

    #   iris2$ht <- sapply(1:nrow(iris2), function(i) {
    #     sprintf(
    #       '<button type="button" class="btn btn-primary" id="%s" onclick="%s">Primary</button>',
    #       paste0("button", i),
    #       glue::glue("alert('Button {i}!')")
    #     )
    #   })

    #   colnames(iris2) <- c("Species", "ht")

    #   golem::invoke_js(
    #     "build_grid",
    #     list(
    #       id = ns("top_ten_homme"),
    #       # columns = names(iris),
    #       columns = names(iris2),
    #       # data = apply(iris, 2, as.character)
    #       data = apply(iris2, 2, as.character)
    #     )
    #   )
    # })
  })
}

## To be copied in the UI
# mod_130_poc_gridjs_ui("130_poc_gridjs_1")

## To be copied in the server
# mod_130_poc_gridjs_server("130_poc_gridjs_1")
