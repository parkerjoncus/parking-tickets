library(readr)
library(sqldf)

ward <- read_csv("~/Documents/parking-tickets/CAWARD15 - CAWARD15.csv")

#Get the community to ward percentages
add<-sqldf('SELECT NEWWARD, SUM(TOT2010) AS tot FROM ward GROUP BY NEWWARD')
ward<-merge(ward,add, by = 'NEWWARD')
ward$percent<-(ward$TOT2010)/(ward$tot)
ward$CHGOCA<-as.numeric(ward$CHGOCA)
ward$NEWWARD<-as.numeric(ward$NEWWARD)

#Start the overall dataset for the wards info
dataset <- read_csv("~/Documents/parking-tickets/Estimated Ward Populations - Estimated Ward Populations.csv")
dataset<-dataset[-51,]
dataset<-dataset[,c(-2,-3,-(10:27))]
dataset$Ward<-as.numeric(dataset$Ward)

dataset$Whiteperc<-(dataset$White2010)/(dataset$Total2010)
dataset$Blackperc<-(dataset$Black2010/dataset$Total2010)
dataset$Asianperc<-(dataset$Asian2010/dataset$Total2010)
dataset$Hisperc<-(dataset$HisLat2010/dataset$Total2010)
dataset$otherperc<-(dataset$Other2010/dataset$Total2010)

#Translate income data to ward data
income <- read_csv("~/Documents/parking-tickets/Census_Data_-_Selected_socioeconomic_indicators_in_Chicago__2008___2012.csv")
income<-income[-78,]
income<-income[,-2]

income_ward<-income[1:50,]
colnames(income_ward)[1]<- 'Ward'
income_ward[,2:8]<-NA
for (i in 1:50){
  comm<-ward[ward$NEWWARD==i,]$CHGOCA
  perc<-ward[ward$NEWWARD==i,]$percent
  x<-colSums(income[comm,c(2:8)]*perc)
  income_ward[i,c(2:8)]<-data.frame(t(x))
}

#Translate health into wards
health <- read_csv("~/Documents/parking-tickets/Public_Health_Statistics-_Selected_public_health_indicators_by_Chicago_community_area.csv")
health<-health[,-2]
#Need to do something for the missing values (try average insert)
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

#Transfer from commnity to ward
health_ward<-health[1:50,]
colnames(health_ward)[1]<- 'Ward'
health_ward[,2:28]<-NA
for (i in 1:50){
  comm<-ward[ward$NEWWARD==i,]$CHGOCA
  perc<-ward[ward$NEWWARD==i,]$percent
  x<-colSums(health[comm,c(2:28)]*perc)
  health_ward[i,c(2:28)]<-data.frame(t(x))
}

finaldata<-merge(dataset, income_ward, by = 'Ward')
finaldata<-merge(finaldata, health_ward, by = 'Ward')
setwd("~/Documents/parking-tickets")
write.csv(finaldata, file = "PredictionData.csv",row.names=FALSE)

#Count how many duplicates per ward
