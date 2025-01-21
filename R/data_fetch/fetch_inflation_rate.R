library(rvest)

fetch_inflation_rate <- function(country_url) {
  page <- read_html(country_url)
  inflation_rate <- page %>%
    html_node(".some-class-for-inflation") %>%
    html_text() %>%
    as.numeric()
  return(inflation_rate)
}
