
library(DBI)
library(RPostgres)
library(here)

source(here("R/database/db_connect.R"))

# Save inflation data to the database
save_inflation_data <- function(country_name, date, rate) {
  db <- connect_db()
  
  country_id <- get_country_id(db, country_name)
  if (is.na(country_id)) {
    dbExecute(db, "INSERT INTO countries (name) VALUES ($1)", list(country_name))
    country_id <- get_country_id(db, country_name)
  }
  
  dbExecute(
    db,
    "INSERT INTO inflation_data (country_id, date, inflation_rate) VALUES ($1, $2, $3)",
    list(country_id, date, rate)
  )
  
  dbDisconnect(db)
}
