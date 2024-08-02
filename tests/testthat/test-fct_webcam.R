
test_that("clean_data_url works", {
  dataurl <- "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD"
  expect_equal(
    clean_data_url(dataurl = dataurl),
    "/9j/4AAQSkZJRgABAQAAAQABAAD"
  )
})

test_that("export_img_from_dataurl works", {
  dataurl <- readLines(
    file.path(
      system.file(package = "mycomicslibrary"),
      "unit_test",
      "base64url.txt"
    )
  )
  img_out <- tempfile(fileext = ".jpg")

  export_img_from_dataurl(
    dataurl = dataurl,
    output_img = img_out
  )
  expect_true(
    file.exists(img_out)
  )
  expect_true(
    file.size(img_out) > 0
  )
  unlink(img_out)
})
