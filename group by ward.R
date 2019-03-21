library(readr)
setwd("~/Downloads/data/exports/years")
temp = list.files(pattern="*.csv")
minimum<-1
maximum<-50
list<-1:50
#list[51]<-NA
count<-(1:51)*0
#Get the number of tickets each ward
for (file in temp){
  tickets <- read_csv(file)
  nonempty<-tickets[!is.na(tickets$ward),]
  empty<-tickets[is.na(tickets$ward),]
  for (ward in list){
    count[ward]<-count[ward]+sum(nonempty$ward==ward)
  }
  count[51]<-count[51]+length(empty$ward)
}

#Create empty year csv files
for (ward in list){
  setwd("~/Downloads/data/exports/wards")
  labels<-tickets[tickets$ward==500,]
  write.csv(labels, file=paste(toString(ward), ".csv", sep=""), row.names=FALSE)
}
setwd("~/Downloads/data/exports/wards")
labels<-tickets[tickets$ward==500,]
write.csv(labels, file="empty.csv", row.names=FALSE)


#Writing the data to the correct year csv
setwd("~/Downloads/data/exports/years")
for (file in temp){
  tickets <- read_csv(file)
  nonempty<-tickets[!is.na(tickets$ward),]
  empty<-tickets[is.na(tickets$ward),]
  setwd("~/Downloads/data/exports/wards")
  for (ward in list){
    add_data<-nonempty[nonempty$ward==ward,]
    write.table(add_data, file = paste(toString(ward), ".csv", sep=""), sep=',', row.names=FALSE, col.names=FALSE, append = TRUE)
  }
  write.table(empty, file = "empty.csv", sep=',', row.names=FALSE, col.names=FALSE, append = TRUE)
  setwd("~/Downloads/data/exports/years")
  file.remove(file)
}

##LOOKUP POLIC BEATS
#Github.com/vingkan/crash
