link_shiny <- shiny::tags$a(
  shiny::icon("github"),
  "Shiny",
  href = "https://github.com/rstudio/shiny",
  target = "_blank"
)
link_posit <- shiny::tags$a(
  shiny::icon("r-project"),
  "Posit",
  href = "https://posit.co",
  target = "_blank"
)

#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    bootstrapLib(theme = bslib::bs_theme(version = 5)),
    htmlTemplate(
      app_sys("app/www/template.html"),
      module1 = mod_100_search_isbn_ui("100_search_isbn_1"),
      module2 = mod_120_add_picture_ui("120_add_picture_1")
    )
    # Your application UI logic
    # page_navbar(
    #   title = "My App",
    #   nav_panel(
    #     title = "One",
    #     mod_100_search_isbn_ui("100_search_isbn_1")
    #   ),
    #   nav_panel(title = "Two", p("Second page content.")),
    #   nav_panel("Three", p("Third page content.")),
    #   nav_spacer(),
    #   nav_menu(
    #     title = "Links",
    #     align = "right",
    #     nav_item(link_shiny),
    #     nav_item(link_posit)
    #   )
    # )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "mycomicslibrary"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
