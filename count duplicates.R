library(readr)
library(sqldf)

setwd("~/Downloads/data/exports/years")
temp = list.files(pattern="*.csv")
tickets <- read_csv(temp[1])

dup<-tickets[tickets$year==0,]
for (file in temp){

}
#dup<-tickets[tickets$year==0,]
#for (file in temp){
#  tickets <- read_csv(file)
#  i<-1
#  while (i < length(tickets$license_plate_number) - 1 ){
#    flag<-FALSE
#    j<-i+1
#    while (j < (length(tickets$license_plate_number))){
#      if ((tickets$license_plate_number[i]==tickets$license_plate_number[j]) && (tickets$violation_code[i]==tickets$violation_code[j]) && (tickets$day[i]==tickets$day[j]) && (tickets$month[i]==tickets$month[j])){
#        flag<-TRUE
#        dup<-rbind(dup,tickets[j,])
#        tickets<-tickets[-j,]
#      }
#      else if (tickets$day[i] != tickets$day[j]){
#        j<-length(tickets$license_plate_number) + 1
#      }
#      else{
#        j<-j+1
#      }
#    }
#    if (flag){
#      dup<-rbind(dup,tickets[i,])
#    }
#    i<-i+1
#  }
#}
#setwd("~/Downloads/data/exports")
#write.table(dup, file = "duplciate.csv", sep=',', row.names=FALSE)

#dup<-tickets[tickets$year==0,]
#for (file in temp){
#  tickets <- read_csv(file)
#  i<-1
#  while (i < length(tickets$license_plate_number) - 1 ){
#    x=tickets$license_plate_number[i]
#    y=tickets$violation_code[i]
#    day=tickets$day[i]
#    month=tickets$month[i]
#    test<-tickets[(tickets$license_plate_number==x) & (tickets$violation_code==y) & (tickets$day==day) & (tickets$month==month),]
#    if (length(test$day) > 1){
#      dup<-rbind(dup, test)
#      tickets<-tickets[!((tickets$license_plate_number==x) & (tickets$violation_code==y) & (tickets$day==day) & (tickets$month==month)),]
#    }
#    else{
#      i<-i+1
#    }
#  }
#}
