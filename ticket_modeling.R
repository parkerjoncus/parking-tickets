library(readr)
library(sqldf)
library(MASS)
library(stats)
library(BBmisc)
library(caret)
library(ggplot2)
library(corrplot)
library(leaps)

PredictionData <- read_csv("~/Documents/parking-tickets/PredictionData.csv")
ticket_counts <- read_csv("~/Documents/parking-tickets/ticket_counts.csv")

data <- merge(PredictionData, ticket_counts, by = 'Ward')
data$`PER CAPITA INCOME`<-NULL
View(data)

cor(data[,c(8:11,44:48)])
corrplot.mixed(cor(data[,c(8:11,44:48)]), main = 'Correlation Plot')

#Multinomial linear regression on number of tickets
model1<-lm(TicketCount ~ 1, data=data)
model2<-lm(TicketCount ~ . - StickerCount - DupCount - ExpCount - Ward,data=data)
model3<-step(model1, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
model4<-step(model2, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
summary(model3)

#Multinmial linear regression on number of city stickers
model1<-lm(StickerCount ~ 1, data=data)
model2<-lm(StickerCount ~ . - TicketCount - DupCount - ExpCount - Ward,data=data)
model3<-step(model1, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
model4<-step(model2, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
summary(model3)

#Multinomial linear regression on Duplicate tickets
model1<-lm(DupCount ~ 1, data=data)
model2<-lm(DupCount ~ . - StickerCount - TicketCount - Ward,data=data)
model3<-step(model1, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
model4<-step(model2, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
summary(model3)

#REMOVE LOOP
data1<-data[-42,]
#Multinomial linear regression on number of tickets
model1<-lm(TicketCount ~ 1, data=data1)
model2<-lm(TicketCount ~ . - StickerCount - DupCount - Ward,data=data1)
model3<-step(model1, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
model4<-step(model2, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
summary(model3)

#Multinmial linear regression on number of city stickers
model1<-lm(StickerCount ~ 1, data=data1)
model2<-lm(StickerCount ~ . - TicketCount - DupCount - Ward,data=data1)
model3<-step(model1, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
model4<-step(model2, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
summary(model3)

#Multinomial linear regression on Duplicate tickets
model1<-lm(DupCount ~ 1, data=data1)
model2<-lm(DupCount ~ . - StickerCount - TicketCount - ExpCount - Ward,data=data1)
model3<-step(model1, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
model4<-step(model2, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
summary(model3)

#REMOVE LOOP and standarize by population
data1$TicketCount<-data1$TicketCount/data1$Total2010
data1$StickerCount<-data1$StickerCount/data1$Total2010
data1$DupCount<-data1$DupCount/data1$Total2010
#Multinomial linear regression on number of tickets
model1<-lm(TicketCount ~ 1, data=data1)
model2<-lm(TicketCount ~ . - StickerCount - DupCount - Ward,data=data1)
model3<-step(model1, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
model4<-step(model2, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
summary(model3)

#Multinmial linear regression on number of city stickers
model1<-lm(StickerCount ~ 1, data=data1)
model2<-lm(StickerCount ~ . - TicketCount - DupCount - Ward,data=data1)
model3<-step(model1, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
model4<-step(model2, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
summary(model3)

#Multinomial linear regression on Duplicate tickets
model1<-lm(DupCount ~ 1, data=data1)
model2<-lm(DupCount ~ . - StickerCount - TicketCount - Ward,data=data1)
model3<-step(model1, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
model4<-step(model2, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
summary(model3)

##Leaps to get all subsets and remove redundant variables
data2<-data1
data2<-data2[,-(2:7)]
data2<-data2[,c(-6,-7, -8, -9, -12, -16, -17, -20, -21, -22, -23, -24, -26, -27, -28, -29, -30, -31, -32, -33, -10)]

#Overall tickets
regsubsets.out <-regsubsets(TicketCount ~ . - StickerCount - DupCount - Ward,
                            data = data2,
                            nbest = 1,       # 1 best model for each number of predictors
                            nvmax = NULL,    # NULL for no limit on number of variables
                            force.in = NULL, force.out = NULL,
                            method = "exhaustive")
regsubsets.out
summary.out <- summary(regsubsets.out)
as.data.frame(summary.out$outmat)
plot(regsubsets.out, scale = "adjr2", main = "Adjusted R^2 for ticket counts")


#City Stickers
regsubsets.out <-regsubsets(StickerCount ~ . - DupCount - TicketCount - Ward,
                            data = data2,
                            nbest = 1,       # 1 best model for each number of predictors
                            nvmax = NULL,    # NULL for no limit on number of variables
                            force.in = NULL, force.out = NULL,
                            method = "exhaustive")
regsubsets.out
summary.out <- summary(regsubsets.out)
as.data.frame(summary.out$outmat)
plot(regsubsets.out, scale = "adjr2", main = "Adjusted R^2 for City Stickers")

#Duplicate tickets
regsubsets.out <-regsubsets(DupCount ~ . - StickerCount - TicketCount - Ward,
             data = data2,
             nbest = 1,       # 1 best model for each number of predictors
             nvmax = NULL,    # NULL for no limit on number of variables
             force.in = NULL, force.out = NULL,
             method = "exhaustive")
regsubsets.out
summary.out <- summary(regsubsets.out)
as.data.frame(summary.out$outmat)
plot(regsubsets.out, scale = "adjr2", main = "Adjusted R^2 for duplicates")
#Whitepercent, Hispercent, age, birth rate, fertility rate, birth weight, teen birth, crowded housing, dependancy, diploma, per capita income. 
model5<-lm(DupCount ~ 1 + Whiteperc + Hisperc + `PERCENT AGED UNDER 18 OR OVER 64` + `Birth Rate` + `General Fertility Rate` + `Low Birth Weight` + `Teen Birth Rate` + `Crowded Housing` + Dependency + `No High School Diploma` + `Per Capita Income`, data=data2)
#per capita income and whiteperc are most significant at p level. 

regsubsets.out <-regsubsets(DupCount ~ . - StickerCount - TicketCount - Ward,
                            data = data2,
                            nbest = 1,       # 1 best model for each number of predictors
                            nvmax = 5,    # NULL for no limit on number of variables
                            force.in = NULL, force.out = NULL,
                            method = "exhaustive")
regsubsets.out
summary.out <- summary(regsubsets.out)
as.data.frame(summary.out$outmat)
plot(regsubsets.out, scale = "adjr2", main = "Adjusted R^2 for duplicates")

model5<-lm(DupCount ~ Whiteperc + `PERCENT AGED UNDER 18 OR OVER 64` + `Per Capita Income` + `Below Poverty Level`, data=data2)
summary(model5)
plot(model5)

#Expired plates counts of duplicates
duplicates <- read_csv("~/Documents/parking-tickets/cleaned_duplicates.csv")
dup_exp_count <- sqldf("SELECT ward, COUNT(ticket_number) as count FROM duplicates WHERE violation_description LIKE '%EXPIRED PLATE%' GROUP BY ward")
ticket_counts$ExpCount<-dup_exp_count$count[2:51]
data <- merge(PredictionData, ticket_counts, by = 'Ward')
data$`PER CAPITA INCOME`<-NULL
data1<-data[-42,]
data1$TicketCount<-data1$TicketCount/data1$Total2010
data1$StickerCount<-data1$StickerCount/data1$Total2010
data1$DupCount<-data1$DupCount/data1$Total2010
data1$ExpCount<-data1$ExpCount/data1$Total2010
data2<-data1
data2<-data2[,-(2:7)]
data2<-data2[,c(-6,-7, -8, -9, -12, -16, -17, -20, -21, -22, -23, -24, -26, -27, -28, -29, -30, -31, -32, -33, -10, -38)]
regsubsets.out <-regsubsets(ExpCount ~ . - DupCount - StickerCount - TicketCount - Ward,
                            data = data2,
                            nbest = 1,       # 1 best model for each number of predictors
                            nvmax = 10,    # NULL for no limit on number of variables
                            force.in = NULL, force.out = NULL,
                            method = "exhaustive")
regsubsets.out
summary.out <- summary(regsubsets.out)
as.data.frame(summary.out$outmat)
plot(regsubsets.out, scale = "adjr2", main = "Adjusted R^2 for expired plate duplicates")
model5<-lm(ExpCount ~ Blackperc + Whiteperc + `PERCENT AGED UNDER 18 OR OVER 64` + `Below Poverty Level`, data=data2)
summary(model5)
model6<-lm(ExpCount ~ 0 + Blackperc + Asianperc + Hisperc, data=data2)
summary(model6)
model6<-lm(TicketCount ~ 0 + Blackperc + Whiteperc + Asianperc + Hisperc, data=data2)
summary(model6)
model6<-lm(StickerCount ~ 0 + Blackperc + Whiteperc + Asianperc + Hisperc, data=data2)
summary(model6)
model6<-lm(DupCount ~ 0 + Blackperc + Whiteperc + Asianperc + Hisperc, data=data2)
summary(model6)

#Normalize everything by population?

