
library(shiny)
library("here")

source(here("R/data_controller/nigeria.R"))
source(here("R/database/db_operations.R"))
source(here("R/database/db_connect.R"))

server <- function(input, output, session) {
  output$inflation_rate <- renderText({
    rate <- fetch_inflation_rate()
    # save_inflation_data("Nigeria", Sys.Date(), rate)
    paste("Nigeria's Inflation Rate:", rate, "%")
  })
  
  output$inflation_table <- renderTable({
    inflation_data <- fetch_inflation_rates()
    # save_inflation_data("Nigeria", inflation_data)
    inflation_data
  })

  output$instruments_table <- renderTable({
    instruments_data <- fetch_instruents()
    instruments_data
  })

  output$below_par_instruments_table <- renderTable({
    below_par_instruments_data <- fetch_below_par_instruments()
    below_par_instruments_data
  })

  output$above_par_instruments_table <- renderTable({
    above_par_instruments_data <- fetch_above_par_instruments()
    above_par_instruments_data
  })

  output$bond_table <- renderTable({
    bond_data <- fetch_bond_rates()
    # save_bond_rates("Nigeria", bond_data)
    bond_data
  })

  # Observe Save Button Click
  observeEvent(input$save_bond, {
    db <- connect_db()

    # Capture the bond details
    bond_data <- list(
      bond_name = input$bond_name,
      maturity_period = input$maturity_period,
      coupon_rate = input$coupon_rate,
      opening_date = input$opening_date,
      closing_date = input$closing_date,
      settlement_date = input$settlement_date,
      coupon_payment_dates = input$coupon_payment_dates
    )
    
    # Validate inputs
    if (bond_data$bond_name == "" || is.null(bond_data$bond_name)) {
      output$bond_save_status <- renderText("Bond Name is required.")
      return()
    }
    
    # Insert bond data into the database
    tryCatch({
      dbExecute(
        db,
        "INSERT INTO bonds (bond_name, maturity_period, coupon_rate, opening_date, closing_date, settlement_date, coupon_payment_dates)
         VALUES ($1, $2, $3, $4, $5, $6, $7)",
        params = list(
          bond_data$bond_name,
          bond_data$maturity_period,
          bond_data$coupon_rate,
          bond_data$opening_date,
          bond_data$closing_date,
          bond_data$settlement_date,
          bond_data$coupon_payment_dates
        )
      )
      output$bond_save_status <- renderText("Bond information saved successfully.")
    }, error = function(e) {
      output$bond_save_status <- renderText(paste("Error saving bond:", e$message))
    })
  })
}