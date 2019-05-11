library(readr)
library(sqldf)

setwd("~/Downloads/data/exports/years")
temp = list.files(pattern="*.csv")
total_tickets<-data.frame(matrix(, nrow=50, ncol=3))
colnames(total_tickets)<-c('Ward', 'TicketCount', 'StickerCount')
total_tickets$Ward<-1:50
total_tickets$TicketCount<-0
total_tickets$StickerCount<-0
for (file in temp){
  print(file)
  tickets <- read_csv(file)
  counts<-sqldf('SELECT ward, COUNT(ticket_number) as count FROM tickets GROUP BY ward')
  counts2<-sqldf("SELECT ward, COUNT(ticket_number) as count FROM tickets WHERE violation_description LIKE '%CITY STICKER%' GROUP BY ward")
  total_tickets$TicketCount[1:50]<-total_tickets$TicketCount[1:50]+counts$count[2:51]
  total_tickets$StickerCount[1:50]<-total_tickets$StickerCount[1:50]+counts2$count[2:51]
}

setwd("~/Documents/parking-tickets")
write.csv(total_tickets, file = "ticket_counts.csv",row.names=FALSE)

ticket_counts <- read_csv("~/Documents/parking-tickets/ticket_counts.csv")
duplicates <- read_csv("~/Documents/parking-tickets/cleaned_duplicates.csv")

#top<-sqldf('SELECT license_plate_number, COUNT(ticket_number) as count FROM duplicates GROUP BY license_plate_number ORDER BY count DESC')
#top[1:5,]
#duplicates<- duplicates[duplicates$license_plate_number!='c2083069204047c50c2792d39043ef36e1e3eacefdd137a6a78ef253ad66596a',]
#duplicates<- duplicates[duplicates$license_plate_number!='e4fe6b20bfe6fe56ef1292bb6f82c1057de21d854e5de9aed7f5eae305986a54',]

dup_count <- sqldf('SELECT ward, COUNT(ticket_number) as count FROM duplicates GROUP BY ward')
ticket_counts$DupCount<-dup_count$count[2:51]
setwd("~/Documents/parking-tickets")
write.csv(ticket_counts, file = "ticket_counts.csv",row.names=FALSE)

