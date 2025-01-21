library(shiny)

# Define the UI for the Jellyfish app
ui <- fluidPage(

  # Application title
  titlePanel("Jellyfish: Financial Insights"),

  # Sidebar layout with input and output definitions
  sidebarLayout(

    # Sidebar panel for inputs
    sidebarPanel(
      selectInput(
        inputId = "country",
        label = "Select a Country:",
        choices = c("Nigeria"),
        selected = "Nigeria"
      ),
      actionButton(
        inputId = "refresh",
        label = "Refresh Data",
        icon = icon("sync")
      ),
      helpText(
        "Choose a country to view financial data, including inflation rates and bond yields."
      )
    ),

    # Main panel for displaying outputs
    mainPanel(
      tabsetPanel(
        type = "tabs",

        # Tab for inflation data
        tabPanel(
          "Inflation Rates",
          h4("Current Inflation Rate"),
          textOutput("inflation_rate"),
          br(),
          plotOutput("inflation_trend")
        ),

        # Tab for bond rates
        tabPanel(
          "Bond Rates",
          h4("Government Bond Yields"),
          tableOutput("bond_table")
        ),

        # Future tabs can be added here
        tabPanel(
          "About",
          h4("About Jellyfish"),
          p("Jellyfish is a financial insights app designed to help users explore and compare effective interest rates across different countries. Currently, it supports data for Nigeria, including inflation rates and government bond yields.")
        )
      )
    )
  )
)
