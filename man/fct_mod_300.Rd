% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fct_mod_300.R
\name{create_html_for_modal_modify_book_in_collection}
\alias{create_html_for_modal_modify_book_in_collection}
\alias{make_stars_rating_div}
\alias{prepare_comics_db_to_see_collection}
\alias{prepare_comics_db_to_see_wishlist}
\title{HTML for modal modify book in collection}
\usage{
create_html_for_modal_modify_book_in_collection(current_book, ns)

make_stars_rating_div(note, max_note = 5)

prepare_comics_db_to_see_collection(comics_db, ns)

prepare_comics_db_to_see_wishlist(comics_db, ns)
}
\arguments{
\item{current_book}{the current book}

\item{ns}{the namespace}

\item{note}{a note between 0 and max_note}

\item{max_note}{the maximum note}

\item{comics_db}{a comics database}
}
\value{
a div with the HTML for the modal to modify a book in the collection

a div with stars

a comics database with only the columns needed to see the collection

a comics database with only the columns needed to see the wishlist
}
\description{
HTML for modal modify book in collection

Make stars rating div

Prepare comics database to see collection

prepare comics database to see wishlist
}
\examples{
make_stars_rating_div(note = 1)
}
