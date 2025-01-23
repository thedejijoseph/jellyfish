
source("ui.R")
source("server.R")
library(shiny)

options(shiny.autoreload = TRUE)
shinyApp(ui = ui, server = server)
