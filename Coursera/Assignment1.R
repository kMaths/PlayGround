#1
library(dplyr)
library(data.table)
if(!file.exists("assignments")){
  dir.create("assignments")
}

url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(url,destfile = "./assignments/2006IdahoHousing.csv",method = "curl")
dateDownloaded <- now()
mydf <- read.csv("./assignments/2006IdahoHousing", header = TRUE, na.strings = "")
housing <- tbl_dt(mydf)
filter(summarise(group_by(housing,VAL),n()), VAL == 24)

#2
#FES violates tidy data because there are two variables in this column: marriage type 
#and employment status

#3
library(xlsx)
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(url, destfile = "./assignments/Gas.xlsx", method = "curl")
dateDownloadedGas <- now()
colIndex <- 7:15
rowIndex <- 18:23
mydf <- read.xlsx("./assignments/Gas", sheetIndex = 1, header = TRUE, colIndex = colIndex, rowIndex = rowIndex)
head(mydf)
sum(mydf$Zip*mydf$Ext,na.rm=T)

#4
library(XML)
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
download.file(url, destfile = "./assignments/Restaurants.xml",method = "curl")
rests <- xmlTreeParse("./assignments/Restaurants.xml", useInternalNodes = T)
