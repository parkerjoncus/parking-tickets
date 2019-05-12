#This script takes the years csv from the google drive and re-writes the rows to a new csv based on the ward. This allows us to have smaller files, but more files. 

#Load Library
library(readr)
#Set working directory to where the years data is
setwd("~/Downloads/data/exports/years")
temp = list.files(pattern="*.csv") #list of the years csvs

#create a list of the ward numbers
list<-1:50
#create a list to count the number of tickets in each ward
count<-(1:51)*0
#Get the number of tickets each ward (not necessary, just wrote this out of curiousity)
#WARNING: takes 10:20 min
for (file in temp){
  tickets <- read_csv(file) #Read each year one at a time
  nonempty<-tickets[!is.na(tickets$ward),] #some wards are NA so give non-Na to this dataframe
  empty<-tickets[is.na(tickets$ward),] #NA's to this dataframe
  for (ward in list){
    count[ward]<-count[ward]+sum(nonempty$ward==ward) #count the number of tickets for each ward
  }
  count[51]<-count[51]+length(empty$ward) #count the number of NA ward tickets
}

#Create empty ward csv files with correct column names and write to correct directory (make sure different than years directory)
for (ward in list){
  nonempty<-tickets[!is.na(tickets$ward),]
  setwd("~/Downloads/data/exports/wards")
  labels<-nonempty[nonempty$ward==500,]
  write.csv(labels, file=paste(toString(ward), ".csv", sep=""), row.names=FALSE)
}
#write one for the NA wards
setwd("~/Downloads/data/exports/wards")
write.csv(labels, file="empty.csv", row.names=FALSE)


#Writing the data to the correct ward csv
setwd("~/Downloads/data/exports/years")
for (file in temp){
  tickets <- read_csv(file) #read year
  nonempty<-tickets[!is.na(tickets$ward),] #Non-NA wards
  empty<-tickets[is.na(tickets$ward),] #NA wards
  setwd("~/Downloads/data/exports/wards") #writing directory
  #For each ward createa dataframe for that ward and append to the right csv
  for (ward in list){ 
    add_data<-nonempty[nonempty$ward==ward,] 
    write.table(add_data, file = paste(toString(ward), ".csv", sep=""), sep=',', row.names=FALSE, col.names=FALSE, append = TRUE)
  }
  #Append for the Na wards
  write.table(empty, file = "empty.csv", sep=',', row.names=FALSE, col.names=FALSE, append = TRUE)
  setwd("~/Downloads/data/exports/years") #swithc back to years csv
  file.remove(file) #delete that year (memory purposes)
}
