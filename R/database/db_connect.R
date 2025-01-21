
library(dotenv)
library(here)

load_dot_env(here(".env"))

connect_db <- function() {
  db <- dbConnect(
    Postgres(),
    dbname = Sys.getenv("DB_NAME"),
    host = Sys.getenv("DB_HOST"),
    port = Sys.getenv("DB_PORT"),
    user = Sys.getenv("DB_USER"),
    password = Sys.getenv("DB_PASS")
  )
  return(db)
}

get_country_id <- function(db, country_name) {
  query <- "SELECT id FROM countries WHERE name = $1"
  result <- dbGetQuery(db, query, list(country_name))
  if (nrow(result) > 0) return(result$id) else return(NA)
}
