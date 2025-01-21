fetch_bond_rates <- function(country_url) {
  page <- read_html(country_url)
  
  bond_rates <- data.frame(
    tenure = c("2Y", "5Y", "10Y"),
    rate = c(
      html_node(page, ".bond-2y-class") %>% html_text() %>% as.numeric(),
      html_node(page, ".bond-5y-class") %>% html_text() %>% as.numeric(),
      html_node(page, ".bond-10y-class") %>% html_text() %>% as.numeric()
    )
  )
  
  return(bond_rates)
}
