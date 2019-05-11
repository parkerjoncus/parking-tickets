library(readr)
setwd("~/Downloads/data/exports/split")
temp = list.files(pattern="*.csv")
minimum<-1996
maximum<-2018
list<-1996:2018
count<-(1996:2018)*0
#Get the number of tickets each year
for (file in temp){
  tickets <- read_csv(file)
  for (year in list){
    count[year-1995]<-count[year-1995]+sum(tickets$year==year)
  }
}

#Create empty year csv files
for (year in list){
  setwd("~/Downloads/data/exports/years")
  labels<-tickets[tickets$year==20,]
  write.csv(labels, file=paste(toString(year), ".csv", sep=""), row.names=FALSE)
}

#Writing the data to the correct year csv
setwd("~/Downloads/data/exports/split")
for (file in temp){
  tickets <- read_csv(file)
  setwd("~/Downloads/data/exports/years")
  for (year in list){
    add_data<-tickets[tickets$year==year,]
    write.table(add_data, file = paste(toString(year), ".csv", sep=""), sep=',', row.names=FALSE, col.names=FALSE, append = TRUE)
  }
  setwd("~/Downloads/data/exports/split")
  file.remove(file)
}

##LOOKUP POLIC BEATS
#Github.com/vingkan/crash
