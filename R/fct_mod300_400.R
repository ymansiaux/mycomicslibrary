
#' show or hide elements depending on the size of a database
#'
#' @return side effect
#' @rdname fct_mod300_400
#' @noRd
show_hide_ids_depending_on_db_size <- function(db, table_id, nobook_id) {
  if (
    !isTruthy(db) ||
      nrow(db) == 0
  ) {
    golem::invoke_js(
      "showid",
      nobook_id
    )
    golem::invoke_js(
      "hideid",
      table_id
    )
  } else {
    golem::invoke_js(
      "hideid",
      nobook_id
    )
    golem::invoke_js(
      "showid",
      table_id
    )
  }
}

#' call sweet alert depending on the result of an append operation

#' @return side effect
#' @rdname fct_mod300_400
#' @noRd
call_sweet_alert_depending_on_db_append <- function(append_res, msg_success, msg_error) {
  if (append_res == 1) {
    golem::invoke_js(
      "call_sweetalert2",
      message = list(
        type = "success",
        msg = msg_success
      )
    )
  } else {
    golem::invoke_js(
      "call_sweetalert2",
      message = list(
        type = "error",
        msg = msg_error
      )
    )
  }
}
