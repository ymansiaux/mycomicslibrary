
skip_if_offline()

test_that("call_open_library_api works", {
  isbn_number <- "2365772013"
  
  result <- call_open_library_api(isbn_number = isbn_number)
  
  expect_equal(
    result,
    list(
      numFound = 1L,
      start = 0L,
      numFoundExact = TRUE,
      docs = list(
        list(
          author_alternative_name = list("Staples Fiona", "Vaughan Brian K."),
          author_key = list("OL9159259A", "OL9159260A"),
          author_name = list("Brian K. Vaughan", "Fiona Staples"),
          cover_edition_key = "OL32230088M",
          cover_i = 10867159L,
          ebook_access = "no_ebook",
          ebook_count_i = 0L,
          edition_count = 1L,
          edition_key = list("OL32230088M"),
          first_publish_year = 2013L,
          format = list("paperback"),
          has_fulltext = FALSE,
          isbn = list("2365772013", "9782365772013"),
          key = "/works/OL24344304W",
          last_modified_i = 1619115376L,
          number_of_pages_median = 168L,
          public_scan_b = FALSE,
          publish_date = list("Mar 14, 2013"),
          publish_year = list(2013L),
          publisher = list("URBAN COMICS"),
          seed = list(
            "/books/OL32230088M",
            "/works/OL24344304W",
            "/authors/OL9159259A",
            "/authors/OL9159260A"
          ),
          title = "SAGA - Tome 1",
          title_suggest = "SAGA - Tome 1",
          title_sort = "SAGA - Tome 1",
          type = "work",
          ratings_count_1 = 0L,
          ratings_count_2 = 0L,
          ratings_count_3 = 0L,
          ratings_count_4 = 1L,
          ratings_count_5 = 0L,
          ratings_average = 4,
          ratings_sortable = 2.3286738,
          ratings_count = 1L,
          readinglog_count = 1L,
          want_to_read_count = 0L,
          currently_reading_count = 0L,
          already_read_count = 1L,
          publisher_facet = list("URBAN COMICS"),
          `_version_` = 1795885530921041920,
          author_facet = list("OL9159259A Brian K. Vaughan", "OL9159260A Fiona Staples")
        )
      ),
      num_found = 1L,
      q = "",
      offset = NULL
    )
  )
  
  # No result with a wrong isbn_number
  result <- call_open_library_api(isbn_number = "XXXX")
  
  expect_equal(result$numFound,
               0)
  
  # Error 404
  result <-
    call_open_library_api(root_api = "https://openlibrary.org/api/bouks",
                          isbn_number = "2365772013")
  
  expect_true(inherits(result, "try-error"))
  
  # Error 500
  result <-
    call_open_library_api(root_api = "https://bobi.com/api/books",
                          isbn_number = "2365772013")
  
  expect_true(inherits(result, "try-error"))
})

test_that("clean_open_library_result works", {
  isbn_number <- "2365772013"
  result <- call_open_library_api(isbn_number = isbn_number) |>
    clean_open_library_result()
  
  expect_equal(result,
               structure(
                 list(
                   title = "SAGA - Tome 1",
                   author = "Brian K. Vaughan, Fiona Staples",
                   publisher = "URBAN COMICS",
                   publish_date = "2013",
                   number_of_pages = "168",
                   isbn = "2365772013"
                 ),
                 row.names = c(NA,-1L),
                 class = "data.frame"
               ))
})

skip_if_offline()
test_that("get_cover works", {
  withr::with_tempdir({
    cover_path <- get_cover(isbn_number = "9782365772013",
                            resourcepath = getwd())
    
    expect_true(file.exists(cover_path))
    
    expect_equal(cover_path,
                 file.path(getwd(),
                           "9782365772013.jpg"))
    unlink(cover_path)
  })
})

test_that("give_me_one_random_isbn works", {
  isbn_number <- give_me_one_random_isbn()
  
  expect_true(is.character(isbn_number))
  
  expect_equal(nchar(isbn_number),
               13)
  
  expect_equal(regmatches(isbn_number, regexec("^[0-9]{13}$", isbn_number))[[1]],
               isbn_number)
})

