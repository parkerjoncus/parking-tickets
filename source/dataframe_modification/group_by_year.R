#This R script took the split csv files from the original 21GB dataset and regrouped and wrote them into new csv files based on the year. 

#load library
library(readr)
#set working directory to the split data
setwd("~/Downloads/data/exports/split")
temp = list.files(pattern="*.csv") #list of the split csv's.
#List of all of the years
list<-1996:2018
#List for the counts per year
count<-(1996:2018)*0

#Get the number of tickets each year
#Not neccessary, did this out of curiousity.
#WARNING: takes 10-20 min
for (file in temp){
  tickets <- read_csv(file)
  for (year in list){
    count[year-1995]<-count[year-1995]+sum(tickets$year==year)
  }
}

#Create empty year csv files with correct column names for each year. 
#Make sure the writing directory is different than reading directory
for (year in list){
  setwd("~/Downloads/data/exports/years") #writing directory
  labels<-tickets[tickets$year==20,]
  write.csv(labels, file=paste(toString(year), ".csv", sep=""), row.names=FALSE)
}

#Writing the data to the correct year csv
setwd("~/Downloads/data/exports/split") #reading directory
for (file in temp){
  tickets <- read_csv(file)
  setwd("~/Downloads/data/exports/years") #writing directory
  for (year in list){
    add_data<-tickets[tickets$year==year,] #dataframe of each year and append to correct csv
    write.table(add_data, file = paste(toString(year), ".csv", sep=""), sep=',', row.names=FALSE, col.names=FALSE, append = TRUE)
  }
  setwd("~/Downloads/data/exports/split") #reading directory
  file.remove(file) #delete the split csv for memory space
}
