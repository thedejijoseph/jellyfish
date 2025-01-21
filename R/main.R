source("R/config.R")
source("R/data/fetch_inflation.R")
source("R/data/fetch_bond_rates.R")
source("R/database/db_connect.R")
source("R/database/db_operations.R")

# Example: Fetch and save data for Nigeria
db <- connect_db()

# Fetch inflation rate
nigeria_url <- "https://tradingeconomics.com/nigeria"
inflation_rate <- fetch_inflation_rate(nigeria_url)
insert_inflation_data(db, "Nigeria", Sys.Date(), inflation_rate)

# Fetch bond rates
bond_rates <- fetch_bond_rates(nigeria_url)
for (i in 1:nrow(bond_rates)) {
  insert_bond_rate(db, "Nigeria", bond_rates$tenure[i], bond_rates$rate[i], Sys.Date())
}

disconnect_db(db)
