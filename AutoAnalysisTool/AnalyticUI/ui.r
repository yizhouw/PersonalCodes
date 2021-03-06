shinyUI(pageWithSidebar(
  headerPanel("Auto Analytics"),
  sidebarPanel(
    fileInput('file', 'Choose CSV File',
              accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    tags$hr(),
    checkboxInput('header', 'Header', TRUE),
    radioButtons('sep', 'Separator',
                 c(Comma=',',
                   Semicolon=';',
                   Tab='\t'),
                 'Comma'),
    radioButtons('quote', 'Quote',
                 c(None='',
                   'Double Quote'='"',
                   'Single Quote'="'"),
                 'Double Quote') ,
    textInput("move","Moving Average",value=7),
    textInput("sig_lvl","Significant Level",value=1.96),
    sliderInput("year_weight", "Past Year - Current Year Weight", 0, 100, value= 50,step=10)
  ),

  mainPanel(
    uiOutput("columns"),
    uiOutput("time"),
    uiOutput("filter"),
    
    uiOutput("opts"),
#     uiOutput("para"),

    h3("Anomaly Dates:"),
    
    plotOutput('detection'),
    textOutput("AnomalyDates"),
    uiOutput("calendar"),
    uiOutput("analysis_type"),
    tableOutput('analysis_result'),
    h3("QuickView of Dataset"),
    tableOutput('contents')

  )
))
