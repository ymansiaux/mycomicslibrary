
#' Clean data URL from webcam
#' @param dataURL A string with the data URL
#' @return A string with the data URL without the prefix
#' @rdname fct_webcam
#' @noRd
clean_data_url <- function(dataurl) {
  gsub(
    pattern = "data:image/jpeg;base64,",
    replacement = "",
    x = dataurl
  )
}

#' Export image from data URL
#' @param dataurl A string with the data URL
#' @param output_img A string with the path to the output image
#' @return write an img in inst/
#' @importFrom base64enc base64decode
#' @rdname fct_webcam
#' @export
export_img_from_dataurl <- function(
  dataurl,
  output_img
) {
  cleaned_url <- clean_data_url(dataurl)

  url_as_text <- tempfile(pattern = "base64", fileext = ".txt")
  file.create(url_as_text)
  writeLines(cleaned_url, url_as_text)
  inconn <- file(url_as_text, "rb")
  outconn <- file(output_img, "wb")
  base64decode(what = inconn, output = outconn)
  close(inconn)
  close(outconn)
  unlink(url_as_text)
}
