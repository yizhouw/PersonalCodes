source("AnomalyFunction.R")
# Measure <- 8
FileSize <- 100
options(shiny.maxRequestSize=FileSize*1024^2)


shinyServer(function(input, output) {
#   data<-NA
  

  import.csv <- function(filename) {
    return(read.csv(filename, sep = ",", header = TRUE))
  }
  
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects and uploads a 
    # file, it will be a data frame with 'name', 'size', 'type', and 'datapath' 
    # columns. The 'datapath' column will contain the local filenames where the 
    # data can be found.
    
    inFile <- input$file
    if (is.null(inFile)){return(NULL)}
    data <- import.csv(inFile$datapath)
    head(data,10)
  })
  
  ############ Get the measurement column name #########
  output$columns <- renderUI({
    inFile <- input$file
    if (is.null(inFile)){return(NULL)}
    data <- import.csv(inFile$datapath)
    col_names <- colnames(data)
    selectizeInput("measurement","Measure",col_names,selected=NULL,multiple=FALSE) 
  })
  
  ########### Get the Time Column ##############
  output$time <- renderUI({
    inFile <- input$file
    if (is.null(inFile)){return(NULL)}
    data <- import.csv(inFile$datapath)
    col_names <- colnames(data)
    selectizeInput("timecol","Time",col_names,selected=NULL,multiple=FALSE) 
  })
  
  ################# Get all filters ################
  output$filter <- renderUI({
    inFile <- input$file
    if (is.null(inFile)){return(NULL)}
    data <- import.csv(inFile$datapath)
    col_names <- colnames(data)
    selectizeInput("filter","Filter",col_names,selected=NULL,multiple=TRUE) 
  })
  
  ################ Set the Filter option ##########
  output$opts <- renderUI({
    filt <- input$filter
    if(is.null(filt)){return (NULL)}
    inFile <- input$file
    if (is.null(inFile)){return(NULL)}
    data <- import.csv(inFile$datapath)
    FilCol <- match(filt,names(data))
    Options <- as.vector(unique(data[,FilCol]))
    print(length(filt))
    selectizeInput("option",filt[1],Options,selected=NULL,multiple=TRUE)
#     for(i in 1:length(filt)){
# #       output$filters <- renderText({filt})
#       selectizeInput(filt[i],filt[i],Options,selected=NULL,multiple=TRUE)
#     } 
  })
  
  ################ Set parameters to be analyzed ########
  output$para <- renderUI({
    inFile <- input$file
    if (is.null(inFile)){return(NULL)}
    data <- import.csv(inFile$datapath)
    col_names <- colnames(data)
    selectizeInput("para","Parameter",col_names,selected=NULL,multiple=TRUE) 
  })
  
  
  
  ######## Calculating the Sum of the Selected Measurement ################
#   output$sum <- renderText({
#     meas <- input$measurement
#     if(is.null(meas)){return(NULL)}
#     inFile <- input$file
#     if (is.null(inFile)){return(NULL)}
#     data <- import.csv(inFile$datapath)
#     MeasCol <- match(meas,names(data))
#     Sum <- sum(data[,MeasCol])
#     Sum
#   })
  
    
  ################## Detection Graph ##############
  output$detection <- renderPlot({
    ### Read Filter Options ###
    Moving_Ave <- as.numeric(input$move)
    Sig_Lev <- as.numeric(input$sig_lvl)
    
    option <- input$option
    if(is.null(option)){return(NULL)}
#     print (option)
    ### Read File ###
    inFile <- input$file
    if (is.null(inFile)){return(NULL)}
    data <- import.csv(inFile$datapath)
    ### Read Time Column ###
    time <- input$timecol
    if(is.null(time)){return (NULL)}
#     print (time)
    TimeCol <- match(time,names(data))
#     print (TimeCol)
    data[,TimeCol] <- as.Date(data[,TimeCol])
    ### Read Measurement ###
    meas <- input$measurement
    if(is.null(meas)){return(NULL)}
    MeasCol <- match(meas,names(data))
#     print (MeasCol)
    
    GMB <- pivot(data,MeasCol,"2012-01-01","2014-06-01",option,,)
    current_weight <- input$year_weight
    current_weight <- current_weight/100
    Anomaly <- tsoutliers(GMB,Moving_Ave,level=Sig_Lev,title=option,weight=current_weight)
    Dates <- paste(shQuote(Anomaly[[2]]), collapse=", ")
    Anomaly <- Anomaly[1]
    Anomaly
    output$AnomalyDates <- renderText({
      Dates
    })
  })

})
