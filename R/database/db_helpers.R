
country_exists <- function(db, country_name) {
  query <- "SELECT id FROM countries WHERE name = $1"
  result <- dbGetQuery(db, query, list(country_name))
  if (nrow(result) > 0) {
    return(result$id[1])
  }
  return(NA)
}

add_country <- function(db, country_name) {
  if (is.na(country_exists(db, country_name))) {
    dbExecute(db, "INSERT INTO countries (name) VALUES ($1)", list(country_name))
  }
}

get_country_id <- function(db, country_name) {
  query <- "SELECT id FROM countries WHERE name = $1"
  result <- dbGetQuery(db, query, list(country_name))
  if (nrow(result) > 0) return(result$id) else return(NA)
}
