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
        
        # Tab for manual bond entry
        tabPanel(
          "Add Bond Information",
          h4("Enter Bond Details"),
          textInput(
            inputId = "bond_name",
            label = "Bond Name:",
            placeholder = "Enter the name of the bond"
          ),
          numericInput(
            inputId = "maturity_period",
            label = "Maturity Period (Years):",
            value = 1,
            min = 1
          ),
          numericInput(
            inputId = "coupon_rate",
            label = "Coupon Rate (%):",
            value = 0,
            min = 0,
            step = 0.01
          ),
          dateInput(
            inputId = "opening_date",
            label = "Opening Date:",
            value = Sys.Date()
          ),
          dateInput(
            inputId = "closing_date",
            label = "Closing Date:",
            value = Sys.Date()
          ),
          dateInput(
            inputId = "settlement_date",
            label = "Settlement Date:",
            value = Sys.Date()
          ),
          textInput(
            inputId = "coupon_payment_dates",
            label = "Coupon Payment Dates:",
            placeholder = "Enter dates separated by commas (e.g., 2024-01-01, 2024-07-01)"
          ),
          actionButton(
            inputId = "save_bond",
            label = "Save Bond Information",
            icon = icon("save")
          ),
          verbatimTextOutput("bond_save_status")
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
