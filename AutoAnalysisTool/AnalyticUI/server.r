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
#     print(length(filt))
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
    current_weight <- current_weight/100.0
    Anomaly <- tsoutliers(GMB,Moving_Ave,level=Sig_Lev,title=option,weight=current_weight)
    Dates <- paste(shQuote(Anomaly[[2]]), collapse=", ")
    Anomaly_plot <- Anomaly[[1]]
    Anomaly_plot
    output$AnomalyDates <- renderText({
      Dates
    })
    output$analysis_datechoose <- renderUI({
      date_list <- Anomaly[[2]]
      if(is.null(date_list)){return (NULL)}
      selectizeInput("analysis_date","Choose the Analysis Date",date_list,selected=NULL,multiple=FALSE)
    })

    output$calendar <- renderUI({
      date_list <- Anomaly[[2]]
      if(is.null(date_list)){return (NULL)}
      dateInput("calendar", "Choose the Analysis Date", value = NULL, min = NULL,
                max = NULL, format = "yyyy-mm-dd", startview = "month",
                weekstart = 0, language = "en")
    })
    
    output$analysis_type <- renderUI({
      date_list <- Anomaly[[2]]
      if(is.null(date_list)){return (NULL)}
      radioButtons('analysis_type', 'Choose the Analysis Type',
                   c("Channel",
                     "Browser",
                     "Both"),
                   'Both')
    })
    output$analysis_result <- renderTable({
      ana_result <- NULL
      channelCol <- match("Channel",names(data))
      channels <- as.vector(unique(data[,channelCol]))
      browserCol <- match("browser",names(data))
      browsers <- as.vector(unique(data[,browserCol]))
      ana_type <- input$analysis_type
      meas <- input$measurement
      if(is.null(meas)){return(NULL)}
      MeasCol <- match(meas,names(data))
      date <- input$calendar
      if(is.null(ana_type)){return (NULL)}
      site <- input$option
      if (ana_type == 'Channel'){
        ana_result <- channelAnalyze(data,GMB,date,MeasCol,channels,site)
      }
      if (ana_type == 'Both'){
        ana_result <- browser_channel_analysis(data,GMB,date,MeasCol,channels,browsers,site)
      }
      if (ana_type == 'Browser'){
        ana_result <- browser_analysis(data,GMB,date,MeasCol,browsers,site)
      }
      print (ana_type)
      head(ana_result,10)
    })

  })

})
