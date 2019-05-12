#This R script was created to join together the demographic, health, and socioeconomic datasets by ward. 

#load librarys
library(readr)
library(sqldf)

#read the community and ward makeup file. This file give the population of each community and ward combination possible
ward <- read_csv("~/Documents/parking-tickets/datasets/community_to_ward_percentages.csv")

#Get the community to ward percentages by getting total population of ward and dividing the populations of each community in that ward by the total.
add<-sqldf('SELECT NEWWARD, SUM(TOT2010) AS tot FROM ward GROUP BY NEWWARD')
ward<-merge(ward,add, by = 'NEWWARD')
ward$percent<-(ward$TOT2010)/(ward$tot)
ward$CHGOCA<-as.numeric(ward$CHGOCA)
ward$NEWWARD<-as.numeric(ward$NEWWARD)

#Create initial overall dataset to join on.
#Ward population is already by ward so add to it
dataset <- read_csv("~/Documents/parking-tickets/datasets/Estimated Ward Populations.csv")
dataset<-dataset[-51,]
dataset<-dataset[,c(-2,-3,-(10:27))] #remove some of the unnecceary columns
dataset$Ward<-as.numeric(dataset$Ward) #make sure ward is numeric

#create new columns to get the reace percentages rather than just populations. 
dataset$Whiteperc<-(dataset$White2010)/(dataset$Total2010) 
dataset$Blackperc<-(dataset$Black2010/dataset$Total2010)
dataset$Asianperc<-(dataset$Asian2010/dataset$Total2010)
dataset$Hisperc<-(dataset$HisLat2010/dataset$Total2010)
dataset$otherperc<-(dataset$Other2010/dataset$Total2010)

#Translate income data to ward data
#income data is given by community. Need to use weighted averages by the ward percentages found above.
income <- read_csv("~/Documents/parking-tickets/datasets/censusData.csv")
income<-income[-78,] #remove total row
income<-income[,-2] #remvoe name

#Create initial ward income dataframe
income_ward<-income[1:50,]
colnames(income_ward)[1]<- 'Ward'
income_ward[,2:8]<-NA

#Loop to use weigted average of the commnity data.
for (i in 1:50){
  comm<-ward[ward$NEWWARD==i,]$CHGOCA #communities a part of the current ward
  perc<-ward[ward$NEWWARD==i,]$percent #those percentages
  x<-colSums(income[comm,c(2:8)]*perc) #get the data for those communities and multiple by correct percentage and add by column
  income_ward[i,c(2:8)]<-data.frame(t(x)) #add to the correct row
}

#Translate health into wards
health <- read_csv("~/Documents/parking-tickets/datasets/Public_Health_Statistics.csv")
health<-health[,-2] #remove names

#Need to do something for the missing values (try average insert) Somewhat unneccessary since not used in modeling.
health$`Gonorrhea in Males`<-as.numeric(health$`Gonorrhea in Males`)
health$`Childhood Blood Lead Level Screening`[is.na(health$`Childhood Blood Lead Level Screening`)] <- mean(health$`Childhood Blood Lead Level Screening`[!is.na(health$`Childhood Blood Lead Level Screening`)])
health$`Childhood Lead Poisoning`[is.na(health$`Childhood Lead Poisoning`)] <- mean(health$`Childhood Lead Poisoning`[!is.na(health$`Childhood Lead Poisoning`)])
temp<-health[complete.cases(health[,c(20,21)]),]
diff<-mean(temp$`Gonorrhea in Females`-temp$`Gonorrhea in Males`)
fem_avg<-mean(temp$`Gonorrhea in Females`)
mal_avg<-mean(temp$`Gonorrhea in Males`)
health$`Gonorrhea in Males`[!is.na(health$`Gonorrhea in Females`) & is.na(health$`Gonorrhea in Males`)]<- health$`Gonorrhea in Females`[!is.na(health$`Gonorrhea in Females`) & is.na(health$`Gonorrhea in Males`)] - diff
health$`Gonorrhea in Females`[is.na(health$`Gonorrhea in Females`) & !is.na(health$`Gonorrhea in Males`)]<- health$`Gonorrhea in Males`[is.na(health$`Gonorrhea in Females`) & !is.na(health$`Gonorrhea in Males`)] + diff
health$`Gonorrhea in Females`[!complete.cases(health[,c(20,21)])] <- fem_avg
health$`Gonorrhea in Males`[!complete.cases(health[,c(20,21)])] <- mal_avg

#Transfer from community to ward for health data
#initialize health by ward dataframe
health_ward<-health[1:50,]
colnames(health_ward)[1]<- 'Ward'
health_ward[,2:28]<-NA

#Same loop as the income expect for health. 
for (i in 1:50){
  comm<-ward[ward$NEWWARD==i,]$CHGOCA
  perc<-ward[ward$NEWWARD==i,]$percent
  x<-colSums(health[comm,c(2:28)]*perc)
  health_ward[i,c(2:28)]<-data.frame(t(x))
}

#add the income by ward to the final dataset
finaldata<-merge(dataset, income_ward, by = 'Ward')
#add the health by ward to the final dataset
finaldata<-merge(finaldata, health_ward, by = 'Ward')
#write files
#FILE ALREADY given, be careful of overwriting. 
setwd("~/Documents/parking-tickets")
write.csv(finaldata, file = "PredictionData.csv",row.names=FALSE)

