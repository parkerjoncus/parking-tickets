library(readr)
setwd("~/Downloads/data/exports/years")
temp = list.files(pattern="*.csv")

for (file in temp){
  data<-read_csv(file, col_types = cols(issue_date = col_datetime(format = "%Y-%m-%d %H:%M:%S")))
  data$day<-as.numeric(format(data$issue_date, "%d"))
  data$minute<-as.numeric(format(data$issue_date, "%M"))
  write.table(data, file = file, sep=',', row.names=FALSE)
}
