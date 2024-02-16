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
      # selectInput(
      #   inputId = ns("select"),
      #   label = "Select",
      #   choices = c(
      #     NULL
      #   )
      # )
      selectizeInput(
        inputId = ns("select"),
        label = "Select",
        choices = c(
          "0" = make_stars_rating_div(note = 0),
          "1" = make_stars_rating_div(note = 1),
          "2" = make_stars_rating_div(note = 2),
          "3" = make_stars_rating_div(note = 3)
        ),
        options = list(
          render = I(
            '{
        item: function(item, escape) {
          return "<div>" + item.value + "</div>";
          },
        option: function(item, escape) {
          return "<div>" + item.value + "</div>";
          }
        }'
          )
        )
      )
    ),
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

    # updateSelectizeInput(
    #   session,
    #   inputId = "select",
    #   choices = c(
    #     "0" = make_stars_rating_div(note = 0),
    #     "1" = make_stars_rating_div(note = 1),
    #     "2" = make_stars_rating_div(note = 2),
    #     "3" = make_stars_rating_div(note = 3)
    #   ),
    #   options = list(
    #     render = I(
    #       '{
    #     item: function(item, escape) {
    #       return "<div>" + item.value + "</div>";
    #       },
    #     option: function(item, escape) {
    #       return "<div>" + item.value + "</div>";
    #       }
    #     }'
    #     )
    #   ),
    #   server = FALSE
    # )

    observeEvent(input$select, {
      print(input$select)
    })

    observeEvent(r_global$comics_db, {
      # browser()

      db <- prepare_comics_db_to_see_collection(
        r_global$comics_db,
        ns = ns
      )

      # browser()

      golem::invoke_js(
        "build_gridpochtml2",
        list(
          id = ns("top_ten_homme"),
          columns = names(db),
          data = do.call(cbind, lapply(db, as.character))
        )
      )
    })

    observeEvent(input$button_clicked, {
      # browser()
      print("tu as cliqué sur le button")
      print(input$button_clicked_id)
    })
  })
}

## To be copied in the UI
# mod_130_poc_gridjs_ui("130_poc_gridjs_1")

## To be copied in the server
# mod_130_poc_gridjs_server("130_poc_gridjs_1")
