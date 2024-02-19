isbn_sample <- readLines("data-raw/isbn.txt") |>
  gsub(pattern = "-", replacement = "")

usethis::use_data(isbn_sample, overwrite = TRUE)
checkhelper::use_data_doc("isbn_sample")
rstudioapi::navigateToFile("R/doc_isbn_sample.R")
attachment::att_amend_desc()
