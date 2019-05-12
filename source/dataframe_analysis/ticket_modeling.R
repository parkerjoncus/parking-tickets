#This code is all of the multiple linear regression done during the project.

#Load Librarys
library(readr)
library(sqldf)
library(MASS)
library(stats)
library(BBmisc)
library(caret)
library(ggplot2)
library(corrplot)
library(leaps)

#Load data. Prediction data is the data being used to try to predict the ticket counts
PredictionData <- read_csv("~/Documents/parking-tickets/datasets/PredictionData.csv")
ticket_counts <- read_csv("~/Documents/parking-tickets/datasets/ticket_counts.csv")

#merge the prediction data with the ticket counts by ward.
data <- merge(PredictionData, ticket_counts, by = 'Ward')
data$`PER CAPITA INCOME`<-NULL
View(data)

#Get a qucik correlation and correlation plot just to visualize
cor(data[,c(8:11,44:48)])
corrplot.mixed(cor(data[,c(8:11,44:48)]), main = 'Correlation Plot')

#Multinomial linear regression on number of tickets
#using step regression by creating empty model1, full model2, and going from empty up with step regression in model3 or top down in model 4.
model1<-lm(TicketCount ~ 1, data=data)
model2<-lm(TicketCount ~ . - StickerCount - DupCount - ExpCount - Ward,data=data)
model3<-step(model1, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
model4<-step(model2, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
#sticking to smaller models so get the summary
summary(model3)

#Multinmial linear regression on number of city stickers
#using step regression by creating empty model1, full model2, and going from empty up with step regression in model3 or top down in model 4.
model1<-lm(StickerCount ~ 1, data=data)
model2<-lm(StickerCount ~ . - TicketCount - DupCount - ExpCount - Ward,data=data)
model3<-step(model1, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
model4<-step(model2, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
#sticking to smaller models so get the summary
summary(model3)

#Multinomial linear regression on Duplicate tickets
#using step regression by creating empty model1, full model2, and going from empty up with step regression in model3 or top down in model 4.
model1<-lm(DupCount ~ 1, data=data)
model2<-lm(DupCount ~ . - StickerCount - TicketCount - ExpCount - Ward,data=data)
model3<-step(model1, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
model4<-step(model2, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
#sticking to smaller models so get the summary
summary(model3)

#REMOVE LOOP from the data since it is an outlier. 
data1<-data[-42,]
#Multinomial linear regression on number of tickets
#using step regression by creating empty model1, full model2, and going from empty up with step regression in model3 or top down in model 4.
model1<-lm(TicketCount ~ 1, data=data1)
model2<-lm(TicketCount ~ . - StickerCount - DupCount - ExpCount - Ward,data=data1)
model3<-step(model1, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
model4<-step(model2, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
#sticking to smaller models so get the summary
summary(model3)

#Multinmial linear regression on number of city stickers
#using step regression by creating empty model1, full model2, and going from empty up with step regression in model3 or top down in model 4.
model1<-lm(StickerCount ~ 1, data=data1)
model2<-lm(StickerCount ~ . - TicketCount - DupCount - ExpCount - Ward,data=data1)
model3<-step(model1, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
model4<-step(model2, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
#sticking to smaller models so get the summary
summary(model3)

#Multinomial linear regression on Duplicate tickets
#using step regression by creating empty model1, full model2, and going from empty up with step regression in model3 or top down in model 4.
model1<-lm(DupCount ~ 1, data=data1)
model2<-lm(DupCount ~ . - StickerCount - TicketCount - ExpCount - Ward,data=data1)
model3<-step(model1, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
model4<-step(model2, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
#sticking to smaller models so get the summary
summary(model3)

#REMOVE LOOP and standarize by population
data1$TicketCount<-data1$TicketCount/data1$Total2010
data1$StickerCount<-data1$StickerCount/data1$Total2010
data1$DupCount<-data1$DupCount/data1$Total2010
data1$ExpCount<-data1$ExpCount/data1$Total2010

#Multinomial linear regression on number of tickets
#using step regression by creating empty model1, full model2, and going from empty up with step regression in model3 or top down in model 4.
model1<-lm(TicketCount ~ 1, data=data1)
model2<-lm(TicketCount ~ . - StickerCount - DupCount - ExpCount - Ward,data=data1)
model3<-step(model1, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
model4<-step(model2, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
#sticking to smaller models so get the summary
summary(model3)

#Multinmial linear regression on number of city stickers
#using step regression by creating empty model1, full model2, and going from empty up with step regression in model3 or top down in model 4.
model1<-lm(StickerCount ~ 1, data=data1)
model2<-lm(StickerCount ~ . - TicketCount - DupCount - ExpCount - Ward,data=data1)
model3<-step(model1, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
model4<-step(model2, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
#sticking to smaller models so get the summary
summary(model3)

#Multinomial linear regression on Duplicate tickets
#using step regression by creating empty model1, full model2, and going from empty up with step regression in model3 or top down in model 4.
model1<-lm(DupCount ~ 1, data=data1)
model2<-lm(DupCount ~ . - StickerCount - TicketCount - ExpCount - Ward,data=data1)
model3<-step(model1, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
model4<-step(model2, scope = list(lower=formula(model1),upper=formula(model2)), direction = 'both')
#sticking to smaller models so get the summary
summary(model3)

##Using R's Leaps function to get all subsets and remove redundant variables
data2<-data1
#Remove some of the factors that are not important or we do not care abuot. for example, gonorhea. 
data2<-data2[,-(2:7)]
data2<-data2[,c(-6,-7, -8, -9, -12, -16, -17, -20, -21, -22, -23, -24, -26, -27, -28, -29, -30, -31, -32, -33, -10)]

#Leaps for Ticket Counts
regsubsets.out <-regsubsets(TicketCount ~ . - StickerCount - DupCount - ExpCount - Ward,
                            data = data2,
                            nbest = 1,       # 1 best model for each number of predictors
                            nvmax = NULL,    # NULL for no limit on number of variables
                            force.in = NULL, force.out = NULL,
                            method = "exhaustive")
regsubsets.out
#See what factors are selected
summary.out <- summary(regsubsets.out)
as.data.frame(summary.out$outmat)
#Visualize the selected factors
plot(regsubsets.out, scale = "adjr2", main = "Adjusted R^2 for ticket counts")


#Leaps for City Stickers
regsubsets.out <-regsubsets(StickerCount ~ . - DupCount - TicketCount - ExpCount - Ward,
                            data = data2,
                            nbest = 1,       # 1 best model for each number of predictors
                            nvmax = NULL,    # NULL for no limit on number of variables
                            force.in = NULL, force.out = NULL,
                            method = "exhaustive")
regsubsets.out
#See what factors are selected
summary.out <- summary(regsubsets.out)
as.data.frame(summary.out$outmat)
#Visualize the selected factors
plot(regsubsets.out, scale = "adjr2", main = "Adjusted R^2 for City Stickers")

#Leaps for Duplicate tickets
regsubsets.out <-regsubsets(DupCount ~ . - StickerCount - TicketCount - Ward,
             data = data2,
             nbest = 1,       # 1 best model for each number of predictors
             nvmax = NULL,    # NULL for no limit on number of variables
             force.in = NULL, force.out = NULL,
             method = "exhaustive")
regsubsets.out
#See what factors are selected
summary.out <- summary(regsubsets.out)
as.data.frame(summary.out$outmat)
#Visualize the selected factors
plot(regsubsets.out, scale = "adjr2", main = "Adjusted R^2 for duplicates")

#Testing the best model from leaps
#Whitepercent, Hispercent, age, birth rate, fertility rate, birth weight, teen birth, crowded housing, dependancy, diploma, per capita income. 
model5<-lm(DupCount ~ 1 + Whiteperc + Hisperc + `PERCENT AGED UNDER 18 OR OVER 64` + `Birth Rate` + `General Fertility Rate` + `Low Birth Weight` + `Teen Birth Rate` + `Crowded Housing` + Dependency + `No High School Diploma` + `Per Capita Income`, data=data2)
#per capita income and whiteperc are most significant at p level. 

regsubsets.out <-regsubsets(DupCount ~ . - StickerCount - TicketCount - ExpCount - Ward,
                            data = data2,
                            nbest = 1,       # 1 best model for each number of predictors
                            nvmax = 5,    # NULL for no limit on number of variables
                            force.in = NULL, force.out = NULL,
                            method = "exhaustive")
regsubsets.out
#See what factors are selected
summary.out <- summary(regsubsets.out)
as.data.frame(summary.out$outmat)
#Visualize the selected factors
plot(regsubsets.out, scale = "adjr2", main = "Adjusted R^2 for duplicates")

#Summarizing one of the models from leaps
model5<-lm(DupCount ~ Whiteperc + `PERCENT AGED UNDER 18 OR OVER 64` + `Per Capita Income` + `Below Poverty Level`, data=data2)
summary(model5)

#Expired plates counts of duplicates
#Remove per capita income it is on a larger scale.
data2$`Per Capita Income`<-NULL

#Leaps for xpired plate duplicates
regsubsets.out <-regsubsets(ExpCount ~ . - DupCount - StickerCount - TicketCount - Ward,
                            data = data2,
                            nbest = 1,       # 1 best model for each number of predictors
                            nvmax = 10,    # NULL for no limit on number of variables
                            force.in = NULL, force.out = NULL,
                            method = "exhaustive")
regsubsets.out
#See the factors that are the best model
summary.out <- summary(regsubsets.out)
as.data.frame(summary.out$outmat)
#Visualize the factors
plot(regsubsets.out, scale = "adjr2", main = "Adjusted R^2 for expired plate duplicates")

#Create a model with some of the important factors to see what is significant. Trial and error
model5<-lm(ExpCount ~ Blackperc + `PERCENT AGED UNDER 18 OR OVER 64` + `Below Poverty Level`, data=data2)
summary(model5)

#Create a model for expired plate duplicate tickets to see if there is a differnce in ticketing by race. 
model6<-lm(ExpCount ~ 0 + Blackperc + Whiteperc + Asianperc + Hisperc, data=data2)
summary(model6)
