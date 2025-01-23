library(glue)

fetch_bond_rates <- function(conn, country_name) {
  # Build the query safely using glue_sql to prevent SQL injection
  query <- glue_sql("
    SELECT 
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
