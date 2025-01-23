
fetch_inflation_rates <- function() {
    # Fetch key inflation rate indicators for any given country, e.g. Nigeria

    # Returns a data frame with columns: inflation_type, date, inflation_rate
    inflation_rates <- data.frame(inflation_type = character(0), date = character(0), inflation_rate = numeric(0))
    return (inflation_rate)
}

fetch_bond_rates <- function() {
    # Fetch bond rates for any given country, e.g. Nigeria

    # Returns a data frame with columns: bond_name, maturity_period, coupon_rate
    bond_rates <- data.frame(bond_name = character(0), maturity_period = numeric(0), coupon_rate = numeric(0))
    return (bond_rates)
}

fetch_instruents <- function() {
  # Fetch all the available instruments for any given country, e.g. Nigeria
  
  # Returns a data frame with columns: instrument, description, returns
  instruments <- data.frame(instrument = character(0), description = character(0), returns = numeric(0))
  return(instruments)

