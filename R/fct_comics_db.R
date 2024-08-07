
#' Connection
#'
#' @noRd
#' @rdname fct_comics_db
#' @examples
#' connect_to_comics_db()
connect_to_comics_db <- function() {
  DBI::dbConnect(
    RSQLite::SQLite(),
    get_database_path()
  )
}

#' get_database_path
#'
#' @noRd
#' @rdname fct_comics_db
#' @examples
#' get_database_path()
get_database_path <- function(session = getDefaultReactiveDomain()) {
  Sys.getenv(
    paste0("SQL_STORAGE_PATH", session$token),
    unset = ""
  )
}

#' Get most recent entry per document
#' @param db comics db
#' @return A data.frame with the most recent entry per document
#' @importFrom dplyr group_by slice_max ungroup
#' @rdname fct_comics_db
#' @noRd
get_most_recent_entry_per_doc <- function(db) {
  db |>
    group_by(id_document) |>
    slice_max(datetime) |>
    ungroup()
}

#' Comics db functions
#'
#' @rdname fct_comics_db
#' @noRd
#' @examples
#' withr::with_tempdir({
#'   withr::with_envvar(
#'     c("SQL_STORAGE_PATH" = "BOBI.sqlite"),
#'     {
#'       init_comics_db()
#'       read_comics_db()
#'       append_comics_db(
#'         ISBN = "1234567890",
#'         auteur = "BILL",
#'         titre = "BOBI",
#'         possede = 1,
#'         annee_publication = "2020-01-01",
#'         nb_pages = 154,
#'         editeur = "truc",
#'         note = 5,
#'         type_publication = "comics",
#'         statut = "Lu",
#'         lien_cover = "https://mycover.com"
#'       )
#'       read_comics_db()
#'       delete_comics_db()
#'       unlink("BOBI.sqlite")
#'     }
#'   )
#' })

init_comics_db <- function() {
  con <- connect_to_comics_db()
  on.exit({
    DBI::dbDisconnect(con)
  })
  if (!"comics" %in% DBI::dbListTables(con)) {
    DBI::dbCreateTable(
      con,
      "comics",
      fields = c(
        id_db = "TEXT",
        id_document = "TEXT",
        ISBN = "TEXT",
        auteur = "TEXT",
        possede = "INTEGER",
        titre = "TEXT",
        annee_publication = "TEXT",
        nb_pages = "INTEGER",
        editeur = "TEXT",
        note = "INTEGER",
        type_publication = "TEXT",
        statut = "TEXT",
        lien_cover = "TEXT",
        datetime = "TEXT"
      )
    )
  }

  read_comics_db()
}


#' @rdname fct_comics_db

read_comics_db <- function() {
  con <- connect_to_comics_db()
  on.exit({
    DBI::dbDisconnect(con)
  })
  DBI::dbReadTable(con, "comics")
}
#' @rdname fct_comics_db

append_comics_db <- function(
  ISBN,
  auteur,
  titre,
  possede,
  annee_publication,
  nb_pages,
  editeur,
  note,
  type_publication,
  statut,
  lien_cover
) {
  datetime <- Sys.time()

  id_db <- digest::digest(
    c(
      ISBN,
      auteur,
      titre,
      possede,
      annee_publication,
      nb_pages,
      editeur,
      note,
      type_publication,
      statut,
      lien_cover,
      datetime
    )
  )
  id_document <- paste0(
    "doc_",
    digest::digest(as.character(ISBN))
  )

  con <- connect_to_comics_db()
  on.exit({
    DBI::dbDisconnect(con)
  })
  DBI::dbAppendTable(
    con,
    "comics",
    data.frame(
      id_db = id_db,
      id_document = id_document,
      ISBN = ISBN,
      auteur = auteur,
      titre = titre,
      possede = possede,
      annee_publication = annee_publication,
      nb_pages = nb_pages,
      editeur = editeur,
      note = note,
      type_publication = type_publication,
      statut = statut,
      lien_cover = lien_cover,
      datetime = datetime
    )
  )
}
#' @rdname fct_comics_db

delete_comics_db <- function() {
  con <- connect_to_comics_db()
  on.exit({
    DBI::dbDisconnect(con)
  })
  DBI::dbRemoveTable(
    con,
    "comics"
  )
}
