#' @importFrom memoise memoise
call_open_library_api_mem <- memoise::memoise(call_open_library_api)

#' @importFrom memoise memoise
get_cover_mem <- memoise::memoise(get_cover)
