
#' HTML for modal modify book in collection
#'
#' @return a div with the HTML for the modal to modify a book in the collection
#' @param current_book the current book
#' @param ns the namespace
#' @importFrom shiny tags sliderInput textInput selectInput
#' @export
#' @rdname fct_mod_300
create_html_for_modal_modify_book_in_collection <- function(
  current_book,
  ns
) {
  tagList(
    tags$div(
      id = ns("modal_modify_book_in_collection"),
      style = "
          display: flex;
          flex-direction: column;
          ",
      tags$div(
        tags$ul(
          style = "text-align: left; list-style-type: none;",
          textInput(
            inputId = ns("annee_publication"),
            label = "Publication year",
            value = current_book$annee_publication
          ),
          textInput(
            inputId = ns("nb_pages"),
            label = "Number of pages",
            value = current_book$nb_pages
          ),
          textInput(
            inputId = ns("auteur"),
            label = "Author(s)",
            value = current_book$auteur
          ),
          textInput(
            inputId = ns("editeur"),
            label = "Editor(s)",
            value = current_book$editeur
          ),
          selectInput(
            inputId = ns("note"),
            label = "Rating",
            choices = 0:5,
            selected = current_book$note
          ),
          selectInput(
            inputId = ns("format"),
            label = "Type of book",
            choices = c("Comic strip", "Comic book", "Graphical novel", "Other", "To be defined"),
            selected = current_book$type_publication
          ),
          selectInput(
            inputId = ns("etat"),
            label = "Condition",
            choices = c("To be read", "In progress", "Read", "To be defined"),
            selected = current_book$statut
          )
        )
      )
    )
  )
}

#' Make stars rating div
#' @param note a note between 0 and max_note
#' @param max_note the maximum note
#' @return a div with stars
#' @importFrom htmltools tags
#' @rdname fct_mod_300
#' @export
#' @examples
#' make_stars_rating_div(note = 1)
make_stars_rating_div <- function(
  note,
  max_note = 5
) {
  stars_full <- stars_empty <- list()
  if (note != 0) {
    stars_full <- lapply(1:note, function(x) {
      tags$span(class = "fa fa-star checked")
    })
  }

  if (note != max_note) {
    stars_empty <- lapply(1:(max_note - note), function(x) {
      tags$span(class = "fa fa-star")
    })
  }

  tagList(
    c(stars_full, stars_empty)
  ) |> as.character()
}

#' Prepare comics database to see collection
#' @param comics_db a comics database
#' @param ns the namespace
#' @return a comics database with only the columns needed to see the collection
#' @rdname fct_mod_300
#' @importFrom dplyr select mutate
#' @importFrom purrr map_chr
#' @importFrom shiny selectInput
#' @export
prepare_comics_db_to_see_collection <- function(comics_db, ns) {
  db <- comics_db |>
    select(
      id_document,
      titre,
      annee_publication,
      nb_pages,
      auteur,
      editeur,
      note,
      type_publication,
      statut,
      lien_cover,
      ISBN
    ) |>
    mutate(
      note = map_chr(note, make_stars_rating_div)
    )

  modify_properties_buttons <- sapply(seq_len(nrow(db)), function(i) {
    sprintf(
      '<button type="button" class="btn btn-primary" id="%s" onclick="%s"><i class="fas fa-edit"></i></button>',
      ns(paste0("modify_book_button", i)),
      sprintf(
        "Shiny.setInputValue(
        '%s',
        '%s',
        {priority : 'event'}
      );
      Shiny.setInputValue(
        '%s',
        Math.random(),
        {priority : 'event'}
      );",
        ns("document_to_modify_id"),
        db$id_document[i],
        ns("modify_button_clicked")
      )
    )
  })

  delete_book_buttons <- sapply(seq_len(nrow(db)), function(i) {
    sprintf(
      '<button type="button" class="btn btn-danger" id="%s" onclick="%s"><i class="fa fa-trash"></i></button>',
      ns(paste0("delete_book_button", i)),
      sprintf(
        "Shiny.setInputValue(
        '%s',
        '%s',
        {priority : 'event'}
      );
      Shiny.setInputValue(
        '%s',
        Math.random(),
        {priority : 'event'}
      );",
        ns("document_to_delete_id"),
        db$id_document[i],
        ns("delete_button_clicked")
      )
    )
  })

  db$modify_properties_buttons <- modify_properties_buttons
  db$delete_book_buttons <- delete_book_buttons

  db |>
    select(-id_document)
}

#' prepare comics database to see wishlist
#' @param comics_db a comics database
#' @param ns the namespace
#' @return a comics database with only the columns needed to see the wishlist
#' @importFrom dplyr select
#' @export
#' @rdname fct_mod_300
prepare_comics_db_to_see_wishlist <- function(comics_db, ns) {
  db <- comics_db |>
    select(
      id_document,
      titre,
      annee_publication,
      nb_pages,
      auteur,
      editeur,
      note,
      type_publication,
      statut,
      lien_cover,
      ISBN
    )

  add_to_collection_buttons <- sapply(seq_len(nrow(db)), function(i) {
    sprintf(
      '<button type="button" class="btn btn-primary" id="%s" onclick="%s"><i class="fa-solid fa-plus"></i></button>',
      ns(paste0("add_book_to_collection_button", i)),
      sprintf(
        "Shiny.setInputValue(
        '%s',
        '%s',
        {priority : 'event'}
      );
      Shiny.setInputValue(
        '%s',
        Math.random(),
        {priority : 'event'}
      );",
        ns("document_to_add_to_collection_id"),
        db$id_document[i],
        ns("add_to_collection_button_clicked")
      )
    )
  })

  delete_book_buttons <- sapply(seq_len(nrow(db)), function(i) {
    sprintf(
      '<button type="button" class="btn btn-danger" id="%s" onclick="%s"><i class="fa fa-trash"></i></button>',
      ns(paste0("delete_book_button", i)),
      sprintf(
        "Shiny.setInputValue(
        '%s',
        '%s',
        {priority : 'event'}
      );
      Shiny.setInputValue(
        '%s',
        Math.random(),
        {priority : 'event'}
      );",
        ns("document_to_delete_id"),
        db$id_document[i],
        ns("delete_button_clicked")
      )
    )
  })

  db$add_to_collection_buttons <- add_to_collection_buttons
  db$delete_book_buttons <- delete_book_buttons


  db |>
    select(
      titre,
      annee_publication,
      nb_pages,
      auteur,
      editeur,
      lien_cover,
      ISBN,
      add_to_collection_buttons,
      delete_book_buttons
    )
}
