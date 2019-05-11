library(readr)
library(sqldf)

#Ward 11 is bridgeport area
ward <- read_csv("~/Downloads/data/exports/wards/11.csv", 
                col_types = cols(issue_date = col_datetime(format = "%Y-%m-%d %H:%M:%S"), 
                                 ticket_queue_date = col_date(format = "%Y-%m-%d")))
View(ward)

ward$violation_code<-as.factor(ward$violation_code)
ward$day<-as.numeric(format(ward$issue_date, "%d"))
ward$minute<-as.numeric(format(ward$issue_date, "%M"))

counts<-sqldf('SELECT license_plate_number, COUNT(ticket_number) AS num FROM ward GROUP BY license_plate_number ORDER BY num DESC')

#NA license plate numbers.
test<-ward[ward$license_plate_number==counts$license_plate_number[1],]
View(test)

most<-ward[ward$license_plate_number==counts$license_plate_number[2],]
View(most)
sqldf('SELECT violation_code, violation_description, COUNT(violation_code) AS num FROM most GROUP BY violation_code ORDER BY num DESC')
#123 out of 250 of the tickets were for city sticker violations.
#City sticker given out 3 times a day sometimes, 2 times within a few hours, and mainly July on. Typically every day. 
sticker<-most[most$violation_code=='0964125',]
View(sticker)
#Paid 25 tickets totaling $3917.99 rest are dismissed becuase of death.
sum(most$total_payments)
sqldf('SELECT officer, COUNT(officer) AS num FROM most GROUP BY officer ORDER BY num DESC')
#There are 5 officers that gave out tickets to this car more than 10 times within 
sqldf('SELECT officer, COUNT(officer) AS num FROM sticker GROUP BY officer ORDER BY num DESC')
#4 officers gave the car a city sticker violation to this car more than 10 times
time<-sqldf('SELECT officer, COUNT(officer) AS num, MIN(issue_date) AS mindate, MAX(issue_date) AS maxdate FROM sticker GROUP BY officer ORDER BY num DESC')
time$diff<-time$maxdate-time$mindate
time$avgdate<-time$diff/time$num
time$avgdays<-time$avgdate/(3600*24)
#There are 3 officers that write a city sticker ticket less than every 10 days on average.


person2<-ward[ward$license_plate_number==counts$license_plate_number[3],]
sum(person2$total_payments)
sum(person2$current_amount_due)
#Paid $13,841.44 in tickets still has $16,894.88 to pay
sqldf('SELECT violation_code, violation_description, COUNT(violation_code) AS num FROM person2 GROUP BY violation_code ORDER BY num DESC')
#Mainly city stickers or expired plates. When viewing data, many times the two are paired together at the same time.

person3<-ward[ward$license_plate_number==counts$license_plate_number[4],]
sum(person3$total_payments)
sum(person3$current_amount_due)
#Paid all tickets costing $5,518
#spans 2004 to 2018
sqldf('SELECT violation_code, violation_description, COUNT(violation_code) AS num FROM person3 GROUP BY violation_code ORDER BY num DESC')
#Mainly expired meters

person4<-ward[ward$license_plate_number==counts$license_plate_number[5],]
sum(person4$total_payments)
sum(person4$current_amount_due)
#Paid no tickets costing $5,970
#spans 2013 to 2014
#ALl DOF
#Virginia License Plate so probably not registered in the city so no city sticker violation most likely
sqldf('SELECT violation_code, violation_description, COUNT(violation_code) AS num FROM person4 GROUP BY violation_code ORDER BY num DESC')
#Mainly expired plates and permit parking

person5<-ward[ward$license_plate_number==counts$license_plate_number[6],]
sum(person5$total_payments)
sum(person5$current_amount_due)
#Paid most tickets costing $6,752.80
#spans 2008 to 2018
sqldf('SELECT violation_code, violation_description, COUNT(violation_code) AS num FROM person5 GROUP BY violation_code ORDER BY num DESC')
#street cleaning mostly


#28th ward, owes the second most
ward <- read_csv("~/Downloads/data/exports/wards/28.csv", 
                 col_types = cols(issue_date = col_datetime(format = "%Y-%m-%d %H:%M:%S"), 
                                  ticket_queue_date = col_date(format = "%Y-%m-%d")))
View(ward)

ward$violation_code<-as.factor(ward$violation_code)

counts<-sqldf('SELECT license_plate_number, COUNT(ticket_number) AS num FROM ward GROUP BY license_plate_number ORDER BY num DESC')
#24 people have had more than 100 tickets!

#NA license plate numbers.
test<-ward[ward$license_plate_number==counts$license_plate_number[1],]
View(test)

most<-ward[ward$license_plate_number==counts$license_plate_number[2],]
sum(most$total_payments)
sum(most$current_amount_due)
#Paid no tickets, owes $25,720
#All in 1998
sqldf('SELECT violation_code, violation_description, COUNT(violation_code) AS num FROM most GROUP BY violation_code ORDER BY num DESC')
#4 types that have all been given out together

person2<-ward[ward$license_plate_number==counts$license_plate_number[3],]
sum(person2$total_payments)
sum(person2$current_amount_due)
#Paid no tickets only owes $915
#spans 1997-1998
#Most dismissed because not enforceable
sqldf('SELECT violation_code, violation_description, COUNT(violation_code) AS num FROM person2 GROUP BY violation_code ORDER BY num DESC')
#Mainly city stickers or hazardous DilaPitatd Vehicle

person3<-ward[ward$license_plate_number==counts$license_plate_number[4],]
sum(person3$total_payments)
sum(person3$current_amount_due)
#Paid $2,654.83, owes $23,180
#spans 1997
sqldf('SELECT violation_code, violation_description, COUNT(violation_code) AS num FROM person3 GROUP BY violation_code ORDER BY num DESC')
#Mainly expired stickers and rear and front plates

person4<-ward[ward$license_plate_number==counts$license_plate_number[5],]
sum(person4$total_payments)
sum(person4$current_amount_due)
#Paid no tickets, owes 268.4
#Dissmissed for not enforceable
#spans 1998
sqldf('SELECT violation_code, violation_description, COUNT(violation_code) AS num FROM person4 GROUP BY violation_code ORDER BY num DESC')
#abandanded and city sticker

person5<-ward[ward$license_plate_number==counts$license_plate_number[6],]
sum(person5$total_payments)
sum(person5$current_amount_due)
#Paid no tickets, owes $22,845.8
#spans 1997
sqldf('SELECT violation_code, violation_description, COUNT(violation_code) AS num FROM person5 GROUP BY violation_code ORDER BY num DESC')
#city sticker and rear and front plate.

years<-sqldf('SELECT year, COUNT(year) as tot FROM ward GROUP BY year')
plot(years$year, years$tot)

