#Quick code to add a numeric day and minute column to the ticket data based on the timestamp rather than always working with the timestamp.

#Load packages
library(readr)

#Set directory. This is assuming the years csv files from the google drive. 
setwd("~/Downloads/data/exports/years")
temp = list.files(pattern="*.csv") #list of all the csv files

#loop to read the data, add the day the minute column and re-write the table
for (file in temp){
  data<-read_csv(file, col_types = cols(issue_date = col_datetime(format = "%Y-%m-%d %H:%M:%S")))
  data$day<-as.numeric(format(data$issue_date, "%d"))
  data$minute<-as.numeric(format(data$issue_date, "%M"))
  write.table(data, file = file, sep=',', row.names=FALSE)
}
