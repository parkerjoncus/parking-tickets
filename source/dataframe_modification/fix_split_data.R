#This script was used because the original data we recieved was 21 GB. Therefore I had to split it into a lot of files with 250,000 rows with mac terminal.
#This script takest those split files and makes sure they all have the right column headings.
#ONLY RUN THIS IF YOU SPLIT AND NEED THE COLUMN HEADINGS

#load package
library(readr)
#Set directiory with split files
setwd("~/Downloads/data/exports/split")
#create the list of the csv files
temp = list.files(pattern="*.csv")

#The first file will be labeled xaa by the mac terminal split. It will also have the correct column heading, so load in first
xaa <- read_csv("~/Downloads/data/exports/split/xaa.csv")

#RUN ONLY ONCE!!!
#Loop for all the files in the list expect the first one (xaa) to read it in without column names and give it the column names from xaa and then re_write.
for (file in temp[-1]){
  data <- read_csv(file, col_names = FALSE)
  colnames(data)<-colnames(xaa)
  write.csv(data, file=file, row.names=FALSE)
}
#If accidentaly ran too many times, you will have a row in all but the first with the column names instead of values. These can be easily deleted, just be aware. 
