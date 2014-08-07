# Anomaly Detection Functions
library(reshape)


######################## Open and Write Files ##################

import.csv <- function(filename) {
  return(read.csv(filename, sep = ",", header = TRUE))
}

# utility function for export to csv file
write.csv <- function(ob, filename) {
  write.table(ob, filename, quote = FALSE, sep = ",", row.names = FALSE)
}


######################### Moving Average ###########################

movingAverage <- function(x, n, centered=TRUE) {
  
  if (centered) {
    before <- floor  ((n-1)/2)
    after  <- ceiling((n-1)/2)
  } else {
    before <- n-1
    after  <- 0
  }
  
  # Track the sum and count of number of non-NA items
  s     <- rep(0, length(x))
  count <- rep(0, length(x))
  
  # Add the centered data 
  new <- x
  # Add to count list wherever there isn't a 
  count <- count + !is.na(new)
  # Now replace NA_s with 0_s and add to total
  new[is.na(new)] <- 0
  s <- s + new
  
  # Add the data from before
  i <- 1
  while (i <= before) {
    # This is the vector with offset values to add
    new   <- c(rep(NA, i), x[1:(length(x)-i)])
    
    count <- count + !is.na(new)
    new[is.na(new)] <- 0
    s <- s + new
    
    i <- i+1
  }
  
  # Add the data from after
  i <- 1
  while (i <= after) {
    # This is the vector with offset values to add
    new   <- c(x[(i+1):length(x)], rep(NA, i))
    
    count <- count + !is.na(new)
    new[is.na(new)] <- 0
    s <- s + new
    
    i <- i+1
  }
  
  # return sum divided by count
  return (s/count)
}



############################## Outlier Detection #######################
tsoutliers <- function(data,mov_len,plot=TRUE,level = 1.96,title="Title",weight=0.5)
{
  x <- data[,1]
  y <- movingAverage(data[,2],mov_len)
  y <- as.ts(y)
#   if(frequency(x)>1)
#     resid <- stl(y,s.window="periodic",robust=TRUE)$time.series[,3]
#   else
#   {
#     tt <- 1:length(y)
#     resid <- residuals(loess(y ~ tt))
#   }
#   resid.q <- quantile(resid,prob=c(0.25,0.75))
#   iqr <- diff(resid.q)
#   limits <- resid.q + 1.5*iqr*c(-1,1)
#   score <- abs(pmin((resid-limits[1])/iqr,0) + pmax((resid - limits[2])/iqr,0))
  
  #### past 30 days stdev #####
  past_30_std_dev <- data.frame(date = x,std = 0)
  for(i in 31:nrow(data)){
    past_30_days <- as.vector(data[(i-30):(i-1),2])
    past_30_std_dev[i,2] <- sd(past_30_days)
  }
#   print(past_30_std_dev)
  
  ############# last Year 30 days period ###########
  last_year_30_std_dev <- data.frame(date = x,std = 0)
  for(i in (366+16):nrow(data)){
    current_date <- data[i,1]
    current_date <- as.POSIXlt(current_date)
    current_date$year <- current_date$year -1
    last_year_date <- as.Date(current_date)
    last_year_index = which(data[,1]==last_year_date)
    last_year_30_days <- as.vector(data[(last_year_index-15):(last_year_index+15),2])
    last_year_30_std_dev[i,2] <- sd(last_year_30_days)   
  }
#   print(last_year_30_std_dev)
  
############## integrated std deviation #############
#Average of this year 30 days deviation and last year 30 days deviation
  std_dev <- (weight*past_30_std_dev[,2]+(1-weight)*last_year_30_std_dev[,2]) ######## need exploration
#     std_dev <- sd(y)
#   print (std_dev)
#   move <- diff(y)



############ move information #############
  move <- data.frame(date = x,move = 0)
  for(i in 10:nrow(data)){
    move[i,2] <- abs(mean(as.numeric(data[i-9,2]):as.numeric(data[i-5,2]))-mean(as.numeric(data[i-4,2]),as.numeric(data[i,2])))
  }
#   print(move)


############## Calculating Score ##############
  score <- move[,2] /std_dev
  score[1:366] <- 0
#   print(score)
  if(plot)
  {
    result <- plot(x,y,type="l")
    y2 <- ts(rep(NA,length(y)))
#     print (y2)
    y2[abs(score)>level] <- y[abs(score)>level]
#     print (y2)
    index <- match(subset(y2,y2>0),y2)
    anomaly_date <- x[index]
    tsp(y2) <- tsp(y)
    points(x,y2,pch=19,col="red")
    title(main=title)
#     print (anomaly_date)
    return(list(result,anomaly_date))
  }
  else
    return(score)
}

###################### pivoting the dataset ####################
# dateset
# m - measure
# start
# end
# site 
# chan - channel


pivot <- function (dataset,meas,start,end,site=as.vector(unique(dataset[,2])),chan=as.vector(unique(dataset[,3])),brow=as.vector(unique(dataset[,6]))){  
  start <- as.Date(start)
  end <- as.Date(end)
  subset <- subset(dataset,session_date>=start&session_date<=end&Site %in% site&Channel %in% chan&browser %in% brow)
#   print ("Done Subsetting!")
  subset <- melt(subset, id=setdiff(c(1:ncol(dataset)),c(meas)),measure=meas)
#   print ("Done Melting!")
  subset <- cast(subset,session_date ~ variable,sum)
#   print ("Done Casting!")
  All <- data.frame(session_date = as.Date(start:end, origin="1970-01-01"),iGMB = 0)
  missing_date <- setdiff(as.vector(All[,1]),as.vector(subset[,1]))
  index <- which(as.vector(All[,1]) %in% as.vector(subset[,1]))
  All[index,2] <- subset[,2]
  return (All)
}



#####################  Correlation Calculation ####################

Correlation <- function (dataset1,dataset2,time,window){
#   result <- data.frame()
  length <- floor((window-1)/2)
  time <- as.Date(time, origin="1970-01-01")
#   for(i in 1:length(time)){
#     subset_1 <- subset(dataset1,session_date>=time[i]-length&session_date<=time[i]+length)
#     subset_2 <- subset(dataset2,session_date>=time[i]-length&session_date<=time[i]+length)
# #     GMB_US_FACEBOOK <- pivot(Social_GMB,6,time[1]-length,time[1]+length,"US","facebook")
#     correlation <- cor(log(subset_1[,2]),log(subset_2[,2]))
#     result <- rbind(result, data.frame(time=time[i],cor = correlation))
# #     print (result)
#   }
  subset_1 <- subset(dataset1,session_date>=time-length&session_date<=time+length)
  subset_2 <- subset(dataset2,session_date>=time-length&session_date<=time+length)
#     GMB_US_FACEBOOK <- pivot(Social_GMB,6,time[1]-length,time[1]+length,"US","facebook")
  correlation <- cor(log(subset_1[,2]),log(subset_2[,2]))
  result <-data.frame(time=time,cor = correlation)
#   print (result)
  return(result)
}




########################  Matrix Analysis ######################
channel_analysis <- function(all_data,subset,time,measure){
  channels <- as.vector(unique(all_data[,3]))
  correlation_matrix <- data.frame(time)
  for(i in 1:length(channels)){
    print(channels[i])
    GMB_US_CHL <- pivot(all_data,measure,"2012-01-01","2014-06-01","US",channels[i],)
#     print("fusion completed!")
    result <- Correlation(subset,GMB_US_CHL,time,7)
    correlation_matrix <- cbind(correlation_matrix,result[,2])
    colnames(correlation_matrix)[i+1] <- channels[i]
  }
  return (correlation_matrix)
}


browser_analysis <- function(all_data,subset,time,measure,browsers,site){
  correlation_matrix <- data.frame()
  for(i in 1:length(browsers)){
#     print(browsers[i])
    GMB_US_BROSR <- pivot(all_data,measure,"2012-01-01","2014-06-01",site,,browsers[i])
    #     print("fusion completed!")
    result <- Correlation(subset,GMB_US_BROSR,time,7)
    correlation_matrix <- rbind(correlation_matrix,data.frame(browsers[i],result[,2]))
    
  }
  colnames(correlation_matrix) <- c("Browser","Correlation")
  correlation_matrix <- correlation_matrix[order(-correlation_matrix[[2]]),]
  return (correlation_matrix)
}



browser_channel_analysis <- function(all_data,subset,time,measure,channels,browsers,site){
#   channels <- as.vector(unique(all_data[,3]))
#   browsers <- as.vector(unique(all_data[,6]))
  correlation_matrix <- data.frame()
  for (i in 1:length(channels)){
    for (j in 1:length(browsers)){
#       name <- paste(channels[i],"-",browsers[j])
      GMB_US_CROSS <- pivot(all_data,measure,"2012-01-01","2014-06-01",site,channels[i],browsers[j])
      result <- Correlation(subset,GMB_US_CROSS,time,7)   
      correlation_matrix <- rbind(correlation_matrix,data.frame(channels[i],browsers[j],result[,2]))
#       correlation_matrix <- cbind(correlation_matrix,result[,2])
#       colnames(correlation_matrix)[ncol(correlation_matrix)] <- name
    }
  }
  colnames(correlation_matrix) <- c("Channel","Browser","Correlation")
  correlation_matrix <- correlation_matrix[order(-correlation_matrix[[3]]),]
  return (correlation_matrix)
}




channelAnalyze <- function(all_data,subset,time,measure,channels,site){
  correlation_matrix <- data.frame()
  for(i in 1:length(channels)){
    print(channels[i])
    GMB_US_CHL <- pivot(all_data,measure,"2012-01-01","2014-06-01",site,channels[i],)
    result <- Correlation(subset,GMB_US_CHL,time,7)
    correlation_matrix <- rbind(correlation_matrix,data.frame(channels[i],result[,2]))
  }
  colnames(correlation_matrix) <- c("Channel","Correlation")
  correlation_matrix <- correlation_matrix[order(-correlation_matrix[[2]]),]
  return (correlation_matrix)
}



