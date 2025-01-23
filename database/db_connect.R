
library(dotenv)
library(here)
library(DBI)
library(RPostgres)
library(glue)

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
