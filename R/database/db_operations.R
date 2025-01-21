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

# Save bond rates to the database
save_bond_rates <- function(country_name, bond_data) {
  db <- connect_db()
  
  country_id <- get_country_id(db, country_name)
  if (is.na(country_id)) {
    dbExecute(db, "INSERT INTO countries (name) VALUES ($1)", list(country_name))
    country_id <- get_country_id(db, country_name)
  }
  
  for (i in 1:nrow(bond_data)) {
    dbExecute(
      db,
      "INSERT INTO bond_rates (country_id, tenure, rate, date) VALUES ($1, $2, $3, $4)",
      list(
        country_id,
        bond_data$Tenure[i],
        bond_data$Rate[i],
        Sys.Date()
      )
    )
  }
  
  dbDisconnect(db)
}
