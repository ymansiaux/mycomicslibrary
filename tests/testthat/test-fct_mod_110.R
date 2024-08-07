
test_that("create_html_for_modal_api_search_result works", {
  expect_true(inherits(
    create_html_for_modal_api_search_result(
      book = list(
        title = "title",
        author = "author",
        publish_date = "publish_date",
        number_of_pages = "number_of_pages",
        publisher = "publisher"
      ),
      book_cover = "book_cover"
    ),
    "shiny.tag.list"
  ))
})
