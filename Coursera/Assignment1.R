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
rests <- xmlTreeParse("./assignments/Restaurants.xml", useInternalNodes = TRUE)
rootNode <- xmlRoot(rests)
xmlName(rootNode[[1]])
names(rootNode[[1]])
?xmlSApply
rootNode[[1]][['row']]
zipcodes<-xpathSApply(rootNode,"//zipcode" ,xmlValue)
zips <- as.data.frame(zipcodes)
zips %>% filter(zipcodes == '21231') %>% summarise(n())


#5
library(data.table)
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
DT <- fread(url)
class(DT)
system.time(DT[,mean(pwgtp15),by=SEX])
rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
system.time(mean(DT[DT$SEX==1,]$pwgtp15))
            mean(DT[DT$SEX==2,]$pwgtp15)
            
#this is the fastest
system.time(mean(DT$pwgtp15,by=DT$SEX))