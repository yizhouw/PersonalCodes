
source("AnomalyFunction.R")
Measure <- 8
Moving_Ave <- 7
Sig_Lev <- 1.96

Social_GMB <- import.csv('SocialGMB.csv')
Social_GMB[,1] <- as.Date(Social_GMB[,1])

GMB_US <- pivot(Social_GMB,Measure,"2012-01-01","2014-06-01","US",,)
GMB_DE <- pivot(Social_GMB,Measure,"2012-01-01","2014-06-01","DE",,)
GMB_AU <- pivot(Social_GMB,Measure,"2012-01-01","2014-06-01","AU",,)
GMB_UK <- pivot(Social_GMB,Measure,"2012-01-01","2014-06-01","UK",,)

# GMB_US[,1] <- as.Date(GMB_US[,1],"%y-%m-%d")
# typeof(GMB_US[,1])
#GMB_US <- GMB_US[order(GMB_US$session_date,descending = TRUE),]

### Moving Average
# US_Moving_Ave <- movingAverage(GMB_US[,2],5)
# DE_Moving_Ave <- movingAverage(GMB_DE[,2],5)
# UK_Moving_Ave <- movingAverage(GMB_UK[,2],5)
# AU_Moving_Ave <- movingAverage(GMB_AU[,2],5)
# 

##identify the outliers
US_Anomaly_date <- tsoutliers(GMB_US,Moving_Ave,level=Sig_Lev,title="US")
DE_Anomaly_date <- tsoutliers(GMB_DE,Moving_Ave,level=Sig_Lev,title="DE")
AU_Anomaly_date <- tsoutliers(GMB_AU,Moving_Ave,level=Sig_Lev,title="AU")
UK_Anomaly_date <- tsoutliers(GMB_UK,Moving_Ave,level=Sig_Lev,title="UK")

channel_analysis(Social_GMB,GMB_US,US_Anomaly_date,Measure)


browser_analysis(Social_GMB,GMB_US,US_Anomaly_date,Measure)


result <- browser_channel_analysis(Social_GMB,GMB_US,US_Anomaly_date,Measure)

for(i in 1:nrow(result)){
  print (result[i,1])
  case <- data.frame(requirement = as.vector(colnames(result[,-1])),correlation = unlist(unname(result[i,2:ncol(result)])))
#   case[order(-case$correlation)]
  case <- case[order(-case[[2]]),] 
  if(result[i,1] == as.Date("2014-04-05"))
  {
    print (case)
  }
  
}

write.csv(result,"channel_browser.csv")



GMB_US_FACEBOOK_FIREFOX <- pivot(Social_GMB,Measure,"2012-01-01","2014-06-01","US","facebook","Firefox")
GMB_US_FACEBOOK <- pivot(Social_GMB,Measure,"2012-01-01","2014-06-01","US","facebook",)
Correlation(GMB_US,GMB_US_FACEBOOK_FIREFOX,US_Anomaly_date,Measure)

# pivot(Social_GMB,7,"2012-01-01","2014-06-01","US",,"Firefox")

# channels <- as.vector(unique(Social_GMB[,3]))
# correlation_matrix <- data.frame(US_Anomaly_date)
# for(i in 1:length(channels)){
#   print(channels[i])
#   GMB_US_CHL <- pivot(Social_GMB,7,"2012-01-01","2014-06-01","US",channels[i])
#   result <- Correlation(GMB_US,GMB_US_CHL,US_Anomaly_date,7)
#   correlation_matrix <- cbind(correlation_matrix,result[,2])
#   colnames(correlation_matrix)[i+1] <- channels[i]
#   print(correlation_matrix)
#   print("##########")
# }
# 
# 
# GMB_US_FACEBOOK <- pivot(Social_GMB,7,"2012-01-01","2014-06-01","US","facebook")
# GMB_DE_FACEBOOK <- pivot(Social_GMB,7,"2012-01-01","2014-06-01","DE","facebook")
# GMB_AU_FACEBOOK <- pivot(Social_GMB,7,"2012-01-01","2014-06-01","AU","facebook")
# GMB_UK_FACEBOOK <- pivot(Social_GMB,7,"2012-01-01","2014-06-01","UK","facebook")
# 
# Correlation(GMB_US,GMB_US_FACEBOOK,US_Anomaly_date,7)
# Correlation(GMB_DE,GMB_DE_FACEBOOK,DE_Anomaly_date,7)
# Correlation(GMB_AU,GMB_AU_FACEBOOK,AU_Anomaly_date,7)
# Correlation(GMB_UK,GMB_UK_FACEBOOK,UK_Anomaly_date,7)
# 

