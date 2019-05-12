#This R script with count the number of tickets, city sticker tickets, and duplicate tickets by ward

#Load Packages
library(readr)
library(sqldf)

#Set path to load in the correct data. This code is assuming that you have the years data and are 1 by 1 reading them in and counting. 
setwd("~/Downloads/data/exports/years")
temp = list.files(pattern="*.csv") #List of all of the csv files in the folder

#Create empty dataframe with 50 wards, ticketcounts and sticker counts (initialized to 0)
total_tickets<-data.frame(matrix(, nrow=50, ncol=3))
colnames(total_tickets)<-c('Ward', 'TicketCount', 'StickerCount')
total_tickets$Ward<-1:50
total_tickets$TicketCount<-0
total_tickets$StickerCount<-0

#Loop to read each file and use sql to count the number of tickets and city sticker violations grouping by ward. Then adding to the right row/column in the dataframe.
#WARNING: Takes about 10-20 min
for (file in temp){
  print(file)
  tickets <- read_csv(file)
  counts<-sqldf('SELECT ward, COUNT(ticket_number) as count FROM tickets GROUP BY ward')
  counts2<-sqldf("SELECT ward, COUNT(ticket_number) as count FROM tickets WHERE violation_description LIKE '%CITY STICKER%' GROUP BY ward")
  total_tickets$TicketCount[1:50]<-total_tickets$TicketCount[1:50]+counts$count[2:51] #There are some that have an unknown ward and they are the first count so take 2:51.
  total_tickets$StickerCount[1:50]<-total_tickets$StickerCount[1:50]+counts2$count[2:51]
}

#Write the file of the new ticket counts
#WARNING: the csv already exists so beware of overwriting. 
setwd("~/Documents/parking-tickets")
write.csv(total_tickets, file = "ticket_counts.csv",row.names=FALSE)

#Read in the newly created csv as a dataframe as well as the duplciate dataset
ticket_counts <- read_csv("~/Documents/parking-tickets/datasets/ticket_counts.csv")
duplicates <- read_csv("~/Documents/parking-tickets/datasets/cleaned_duplicates.csv") #Need to create yourself or get from google drive

#Create list of the duplicate counts by ward
dup_count <- sqldf('SELECT ward, COUNT(ticket_number) as count FROM duplicates GROUP BY ward')
#Add the counts to the dupCount column in the ticket counts dataframe
ticket_counts$DupCount<-dup_count$count[2:51]
#Write the final ticket counts
#WARNING: beware of overwriting.
setwd("~/Documents/parking-tickets")
write.csv(ticket_counts, file = "ticket_counts.csv",row.names=FALSE)

