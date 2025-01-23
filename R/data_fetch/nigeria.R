library(httr)
library(rvest)

# Fetch inflation rate for Nigeria
# fetch_inflation_rate <- function() {
#   url <- "https://tradingeconomics.com/nigeria/inflation-cpi"
#   page <- GET(url)
#   html <- content(page, as = "text")
#   inflation_rate <- html %>%
#     read_html() %>%
#     html_node(".value") %>%
#     html_text() %>%
#     as.numeric()
#   return(inflation_rate)
# }

library(rvest)
library(dplyr)
library(stringr)


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

# Fetch inflation rate for Nigeria
fetch_inflation_rate = function(){
  # Extract the inflation rate from the table
  inflation_rate <- extract_nigeria_indicators() %>%
    filter(Indicator == "Inflation Rate") %>%
    pull(Last) %>%
    as.numeric()

  return(inflation_rate)
}

# fetch_inflation_rate = function() {
#   url <- "https://tradingeconomics.com/nigeria/indicators"
#   inflation_data <- readLines(url, warn = FALSE)
#   # cat(inflation_data)
#   inflation_pattern <- gregexpr("Inflation Rate</a></td>.*?<td>([0-9\\.]+)%", inflation_data)
#   inflation_pattern
#   inflation_rate <<- as.numeric(regmatches(inflation_data, inflation_pattern)[[1]][2])
# }

# Fetch bond rates for Nigeria
# fetch_bond_rates <- function() {
#   url <- "https://tradingeconomics.com/nigeria/government-bond-yield"
#   page <- GET(url)
#   html <- content(page, as = "text")
  
#   bond_rates <- html %>%
#     read_html() %>%
#     html_nodes("table") %>%
#     html_table() %>%
#     .[[1]]  # Assuming the bond table is the first table
#   return(bond_rates)
# }


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
    return(data.frame(tenure = character(0), rate = numeric(0)))
  }

  return(bond_rates)
}

