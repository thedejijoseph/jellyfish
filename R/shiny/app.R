
source("R/shiny/ui.R")
source("R/shiny/server.R")
library(shiny)

options(shiny.autoreload = TRUE)
shinyApp(ui = ui, server = server)
