library(readr)
setwd("~/Downloads/data/exports/split")
temp = list.files(pattern="*.csv")
xaa <- read_csv("~/Downloads/data/exports/split/xaa.csv")
#RUN ONLY ONCE!!!
for (file in temp[-1]){
  data <- read_csv(file, col_names = FALSE)
  colnames(data)<-colnames(xaa)
  write.csv(data, file=file, row.names=FALSE)
}

