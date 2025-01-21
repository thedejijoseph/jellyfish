
library(shiny)
library("here")

# source("R/data_fetch/nigeria.R")
source(here("R/data_fetch/fetch_bond_rates.R"))
source(here("R/data_fetch/nigeria.R"))
source(here("R/database/db_operations.R"))

server <- function(input, output, session) {
  output$inflation_rate <- renderText({
    rate <- fetch_inflation_rate()
    save_inflation_data("Nigeria", Sys.Date(), rate)
    paste("Nigeria's Inflation Rate:", rate, "%")
  })
  
  output$bond_table <- renderTable({
    bond_data <- fetch_bond_rates()
    save_bond_rates("Nigeria", bond_data)
    bond_data
  })
}

