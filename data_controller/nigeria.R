
library(httr)
library(rvest)
library(dplyr)
library(stringr)

source(here("database/db_connect.R"))


extract_nigeria_indicators <- function(url = "https://tradingeconomics.com/nigeria/indicators") {
  # Read the HTML content of the page
  page <- read_html(url)

  # Extract the table using CSS selector
  table_html <- html_nodes(page, "table.table.table-hover") %>% 
    html_table()

  # Handle potential empty lists (if the table is not found)
  if (length(table_html) == 0) {
    warning("No table found on the page.")
    return(NULL) 
  }

  # Clean the table data
  table_data <- table_html[[1]] %>%  # Extract the first table (assuming only one table is expected)
    as_tibble(.name_repair = "minimal") #%>%  # Assign minimal names to unnamed columns
    # filter(if_all(everything(), ~ !is.na(.) & . != "")) 

  # Replace empty column names with generic names
  colnames(table_data) <- ifelse(colnames(table_data) == "", 
                                paste0("Column_", 1:ncol(table_data)), 
                                colnames(table_data))

  # Rename columns 
  colnames(table_data) <- c("Indicator", "Last", "Previous", "Highest", "Lowest", "Unit", "Period")

  # Write data to CSV
  # write.csv(table_data, "nigeria_indicators.csv", row.names = FALSE)

  # message("Data extracted and saved to nigeria_indicators.csv")
  return(table_data)
}

# Fetch inflation rates for Nigeria
fetch_inflation_rates = function(){
  # Extract the period, and the inflation rate from the table
  # Default inflation_type is "CBI Inflation Rate"
  inflation_rates <- extract_nigeria_indicators() %>%
    filter(Indicator == "Inflation Rate") %>%
    select(Indicator, Period, Last) %>%
    rename(inflation_type = Indicator, date = Period, inflation_rate = Last) %>%
    mutate(inflation_rate = as.numeric(str_replace(inflation_rate, "%", "")))

  return(inflation_rates)
}

fetch_bond_rates <- function() {
  conn <- connect_db()

  # Build the query safely using glue_sql to prevent SQL injection
  query <- glue_sql("
    SELECT 
      bond_name AS name,
      maturity_period AS tenure,
      coupon_rate AS rate
    FROM bonds
  ", .con = conn)

  # Execute the query and fetch the results
  bond_rates <- tryCatch({
    dbGetQuery(conn, query)
  }, error = function(e) {
    message("Error fetching bond rates: ", e$message)
    return(NULL)
  })

  # Check if bond_rates is NULL or empty
  if (is.null(bond_rates) || nrow(bond_rates) == 0) {
    message("No bond rates found for the specified country.")
    return(data.frame(bond_name = character(0), tenure = character(0), rate = numeric(0)))
  }

  return(bond_rates)
}

fetch_instruents <- function() {
  # Fetch all the available instruments for any given country, e.g. Nigeria
  # Returns a data frame with columns: instrument, description, returns

  bonds <- fetch_bond_rates() %>%
    rename(instrument = name, description = tenure, returns = rate)

  instruments <- bind_rows(bonds)

  if (nrow(instruments) == 0) {
    message("No instruments found for the specified country.")
    return(data.frame(instrument = character(0), description = character(0), returns = numeric(0)))
  }
  return(instruments) # data.frame(instrument = character(0), description = character(0), returns = numeric(0))
}

fetch_below_par_instruments <- function() {
  # Fetch all the available instruments for any given country, e.g. Nigeria
  # Returns a data frame with columns: instrument, description, returns

  instruments <- fetch_instruents()
  inflation_rates <- fetch_inflation_rates() %>%
    filter(inflation_type == "Inflation Rate") %>%
    select(inflation_rate)
  par_rate <- inflation_rates$inflation_rate[1]

  # if return of instrument is lower than par_rate, add to dataframe and return
  below_par_instruments <- instruments %>%
    filter(returns < par_rate)

  if (nrow(below_par_instruments) == 0) {
    message("No instruments found for the specified country.")
    return(data.frame(instrument = character(0), description = character(0), returns = numeric(0)))
  }
  return(below_par_instruments)

}

fetch_above_par_instruments <- function() {
  # Fetch all the available instruments for any given country, e.g. Nigeria
  # Returns a data frame with columns: instrument, description, returns

  instruments <- fetch_instruents()
  inflation_rates <- fetch_inflation_rates()
  par_rate <- inflation_rates$inflation_rate[3]

  # if return of instrument is lower than par_rate, add to dataframe and return
  above_par_instruments <- instruments %>%
    filter(returns > par_rate)

  if (nrow(above_par_instruments) == 0) {
    message("No instruments found for the specified country.")
    return(data.frame(instrument = character(0), description = character(0), returns = numeric(0)))
  }
  return(above_par_instruments)
}
