
test_that("get_database_path works", {
  expect_equal(
    withr::with_envvar(
      c("SQL_STORAGE_PATH" = "BOBI"),
      {
        get_database_path()
      }
    ),
    "BOBI"
  )
})

test_that("connect_to_comics_db works", {
  expect_true(inherits(connect_to_comics_db(), "SQLiteConnection"))
})

test_that("init/read/append works", {
  withr::with_tempdir({
    withr::with_envvar(
      c("SQL_STORAGE_PATH" = "BOBI.sqlite"),
      {
        init_comics_db()
        expect_true(inherits(read_comics_db(), "data.frame"))
        expect_equal(
          init_comics_db(),
          read_comics_db()
        )

        expect_equal(
          append_comics_db(
            ISBN = "1234567890",
            auteur = "BILL",
            titre = "BOBI",
            possede = 1,
            annee_publication = "2020-01-01",
            nb_pages = 154,
            editeur = "truc",
            note = 5,
            type_publication = "comics",
            statut = "Lu",
            lien_cover = "https://mycover.com"
          ),
          1
        )

        db <- read_comics_db()

        expect_equal(
          db$ISBN,
          "1234567890"
        )

        expect_equal(
          db$auteur,
          "BILL"
        )

        expect_equal(
          db$titre,
          "BOBI"
        )

        expect_equal(
          db$possede,
          1
        )

        expect_equal(
          db$annee_publication,
          "2020-01-01"
        )

        expect_equal(
          db$nb_pages,
          154
        )

        expect_equal(
          db$editeur,
          "truc"
        )

        expect_equal(
          db$note,
          5
        )

        expect_equal(
          db$type_publication,
          "comics"
        )

        expect_equal(
          db$statut,
          "Lu"
        )

        expect_equal(
          db$lien_cover,
          "https://mycover.com"
        )
      }
    )
  })
})

test_that("get_most_recent_entry_per_doc works", {
  withr::with_tempdir({
    withr::with_envvar(
      c("SQL_STORAGE_PATH" = "BOBI.sqlite"),
      {
        init_comics_db()

        # Document 1
        append_comics_db(
          ISBN = "1234567890",
          auteur = "BILL",
          titre = "BOBI",
          possede = 0,
          annee_publication = "2020-01-01",
          nb_pages = 154,
          editeur = "truc",
          note = 5,
          type_publication = "comics",
          statut = "Non-lu",
          lien_cover = "https://mycover.com"
        )

        db <- read_comics_db()
        res <- get_most_recent_entry_per_doc(db)

        expect_equal(
          res |>
            dplyr::filter(ISBN == "1234567890") |>
            dplyr::pull(statut),
          "Non-lu"
        )

        expect_equal(
          res |>
            dplyr::filter(ISBN == "1234567890") |>
            dplyr::pull(possede),
          0
        )

        append_comics_db(
          ISBN = "1234567890",
          auteur = "BILL",
          titre = "BOBI",
          possede = 1,
          annee_publication = "2020-01-01",
          nb_pages = 154,
          editeur = "truc",
          note = 5,
          type_publication = "comics",
          statut = "Non-lu",
          lien_cover = "https://mycover.com"
        )

        db <- read_comics_db()
        res <- get_most_recent_entry_per_doc(db)


        expect_equal(
          res |>
            dplyr::filter(ISBN == "1234567890") |>
            dplyr::pull(statut),
          "Non-lu"
        )

        expect_equal(
          res |>
            dplyr::filter(ISBN == "1234567890") |>
            dplyr::pull(possede),
          1
        )

        append_comics_db(
          ISBN = "1234567890",
          auteur = "BILL",
          titre = "BOBI",
          possede = 1,
          annee_publication = "2020-01-01",
          nb_pages = 154,
          editeur = "truc",
          note = 5,
          type_publication = "comics",
          statut = "Lu",
          lien_cover = "https://mycover.com"
        )


        db <- read_comics_db()
        res <- get_most_recent_entry_per_doc(db)

        expect_equal(
          res |>
            dplyr::filter(ISBN == "1234567890") |>
            dplyr::pull(statut),
          "Lu"
        )

        expect_equal(
          res |>
            dplyr::filter(ISBN == "1234567890") |>
            dplyr::pull(possede),
          1
        )

        # Document 2
        append_comics_db(
          ISBN = "9786543210",
          auteur = "BILL",
          titre = "BOBI2",
          possede = 1,
          annee_publication = "2020-01-01",
          nb_pages = 154,
          editeur = "truc",
          note = 5,
          type_publication = "comics",
          statut = "Non-lu",
          lien_cover = "https://mycover.com"
        )

        db <- read_comics_db()
        res <- get_most_recent_entry_per_doc(db)

        expect_equal(
          res |>
            dplyr::filter(ISBN == "9786543210") |>
            dplyr::pull(statut),
          "Non-lu"
        )

        expect_equal(
          res |>
            dplyr::filter(ISBN == "9786543210") |>
            dplyr::pull(possede),
          1
        )

        append_comics_db(
          ISBN = "9786543210",
          auteur = "BILL",
          titre = "BOBI2",
          possede = 1,
          annee_publication = "2020-01-01",
          nb_pages = 154,
          editeur = "truc",
          note = 5,
          type_publication = "comics",
          statut = "Lu",
          lien_cover = "https://mycover.com"
        )

        db <- read_comics_db()
        res <- get_most_recent_entry_per_doc(db)

        expect_equal(
          res |>
            dplyr::filter(ISBN == "9786543210") |>
            dplyr::pull(statut),
          "Lu"
        )

        expect_equal(
          res |>
            dplyr::filter(ISBN == "9786543210") |>
            dplyr::pull(possede),
          1
        )
      }
    )
  })
  unlink("BOBI.sqlite")
})
