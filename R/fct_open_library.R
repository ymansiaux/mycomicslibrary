
#' Appel a l'API Open Library
#' @param root_api l'URL de base de l'API
#' @param isbn_number le numero ISBN 10
#' @return un tibble avec les informations de l'API
#' @importFrom cli cli_alert_warning
#' @importFrom glue glue
#' @importFrom httr2 request req_perform resp_body_json
#' @export
#' @rdname fct_open_library
#' @examples
#' call_open_library_api(isbn_number = "2365772013")
call_open_library_api <- function(
  root_api = "https://openlibrary.org/search.json",
  isbn_number
) {
  if (isFALSE(as.character(isbn_number))) {
    stop("The ISBN number must be passed as a string.")
  }

  url <- glue("{root_api}?isbn={isbn_number}")

  req <- request(url)

  result <- try(
    req |>
      req_perform() |>
      resp_body_json(),
    silent = TRUE
  )

  return(result)
}

#' Nettoyage du resultat de l'API Open Library
#' @param book result of the API call
#' @return a tibble with the cleaned result of the API call
#' @importFrom purrr map map_chr possibly set_names
#' @export
#' @rdname fct_open_library
#' @examples
#' isbn_number <- "2365772013"
#' result <- call_open_library_api(isbn_number = isbn_number)
#'
#' clean_open_library_result(result)
#' isbn_number <- "2365772013"
#' result <- call_open_library_api(isbn_number = isbn_number)
#'
#' clean_open_library_result(result)
clean_open_library_result <- function(book) {
  possibly_get_nested_element <- possibly(
    get_nested_element,
    otherwise = NA_character_
  )

  names_df <- c(
    "title",
    "author_name",
    "publisher",
    "publish_year",
    "number_of_pages_median"
  )
  expected_names <- c(
    "title",
    "author",
    "publisher",
    "publish_date",
    "number_of_pages"
  )

  df <- map(
    names_df,
    ~ possibly_get_nested_element(book, .x)
  ) |>
    set_names(expected_names)

  df <- data.frame(df)
  df$isbn <- unlist(map(book$docs, "isbn"))[1]
  df
}

# #' @noRd
get_nested_element <- function(book, element) {
  map(book$docs, element) |>
    unlist() |>
    paste0(collapse = ", ")
}

#' Get the cover of a book from Open Library
#' @param root_api the base URL of the API
#' @param isbn_number the ISBN 10 number or the ISBN 13 number of the book
#' @param cover_size the size of the cover
#' @param resourcepath the path to the resource
#' @return a URL to the cover of the book
#' @importFrom glue glue
#' @importFrom utils download.file
#' @rdname fct_open_library
#' @export
#' @examples
#' get_cover(isbn_number = "9782365772013")
#' path <- "home/yohann/Documents/perso/mycomicslibrary/inst/app/www/cover_tmp/9782365772013.jpg"
get_cover <- function(
  root_api = "http://covers.openlibrary.org/b/isbn",
  isbn_number,
  cover_size = "M",
  resourcepath = resourcePaths()["covers"]
) {
  match.arg(cover_size, c("S", "M", "L"))
  url <- glue("{root_api}/{isbn_number}-{cover_size}.jpg?default=false")
  cover_output <- file.path(
    resourcepath,
    paste0(isbn_number, ".jpg")
  )

  if (!file.exists(cover_output)) {
    cover_dl <- try(
      download.file(
        url = url,
        cover_output,
        mode = "wb"
      ),
      silent = TRUE
    )

    if (inherits(cover_dl, "try-error")) {
      cover_output <- file.path(
        resourcepath,
        "image-not-found.jpg"
      )
    }
  }
  return(
    cover_output
  )
}

#' Return a random ISBN from mycomicslibrary::isbn_sample
#' @return a random ISBN
#' @rdname fct_open_library
#' @export
#' @examples
#' give_me_one_random_isbn()
give_me_one_random_isbn <- function() {
  mycomicslibrary::isbn_sample |>
    sample(1) |>
    as.character()
}
