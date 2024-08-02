
#' A function to create the HTML for the modal API search result
#' @param book A list with the book information
#' @param book_cover A character with the URL of the book cover
#' @return A shiny.tag.list
#' @rdname fct_mod_110
#' @export
create_html_for_modal_api_search_result <- function(
  book,
  book_cover
) {
  tagList(
    tags$div(
      style = "
          display: flex;
          flex-direction: column;
          ",
      tags$div(
        tags$ul(
          style = "text-align: left; list-style-type: none;",
          tags$li(
            sprintf("Title : %s", book$title)
          ),
          tags$li(
            sprintf("Author(s) : %s", book$author)
          ),
          tags$li(
            sprintf("Publication year : %s", book$publish_date)
          ),
          tags$li(
            sprintf("Number of pages : %s", book$number_of_pages)
          ),
          tags$li(
            sprintf("Editor : %s", book$publisher)
          )
        )
      ),
      tags$div(
        tags$img(
          src = book_cover,
          style = "width: 30%; height: auto;"
        )
      )
    )
  )
}
