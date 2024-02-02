## code to prepare `isbn_sample` dataset goes here
#  source : https://nudger.fr/opendata
#  https://www.data.gouv.fr/fr/datasets/base-de-codes-barres-noms-et-categories-produits/#/resources
library(data.table)
library(magrittr)

#  Fichier supprimé car gigantesque
big_db <- fread("data-raw/open4goods-full-gtin-dataset.csv", nrows = 5000000, select = c(1, 7))
isbn_sample <- big_db[gtinType == "ISBN_13"][sample(.N, 1e5)]

usethis::use_data(isbn_sample, overwrite = TRUE)
checkhelper::use_data_doc("isbn_sample")
rstudioapi::navigateToFile("R/doc_isbn_sample.R")
attachment::att_amend_desc()
