
test_that("prepare_comics_db_to_see_wishlist works", {
  expect_true(inherits(prepare_comics_db_to_see_wishlist, "function"))
})

test_that("make_stars_rating_div works", {
  stars <- make_stars_rating_div(note = 0)

  expect_true(
    length(regmatches(x = stars, m = gregexpr("checked", stars))[[1]]) == 0
  )

  stars <- make_stars_rating_div(note = 1) |> as.character()
  expect_true(
    length(regmatches(x = stars, m = gregexpr("checked", stars))[[1]]) == 1
  )

  stars <- make_stars_rating_div(note = 5) |> as.character()
  expect_true(
    length(regmatches(x = stars, m = gregexpr("checked", stars))[[1]]) == 5
  )
})

test_that("create_html_for_modal_modify_book_in_collection works", {
  expect_true(inherits(create_html_for_modal_modify_book_in_collection, "function"))
})
