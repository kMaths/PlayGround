#1
if(!file.exists("./data")){dir.create("./data")}
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv",
              destfile = "./data/idahoSurvey.csv")
idaho <- read.csv("./data/idahoSurvey.csv")
split <- strsplit(names(idao),"wgtp")
split[123]

#2
GDP <- read.csv("./data/GDP.csv",stringsAsFactors = FALSE,na.strings = c("","<NA>"))
head(GDP)
tail(GDP)
GDP[235,2]
GDP <- GDP[!is.na(GDP$X),]
GDP <- GDP[!is.na(GDP$Gross.domestic.product.2012),]
tail(GDP)
head(GDP)
GDPX3 = GDP$X.3[!is.na(GDP$X.3)]
tail(GDPX3)
head(GDPX3)
noComma <- gsub(",","",GDPX3)
noComma <- gsub(" ","",noComma)
mean(as.numeric(noComma),na.rm = TRUE)

#3
grep("^United",GDP$X.2)


#4
EDU<-read.csv("./data/EDU.csv",stringsAsFactors = FALSE,na.strings = "")
names(EDU)
EDUGDP <- merge(EDU,GDP,by.x="CountryCode",by.y = "X")
head(GDP$X.8,20)
grep("Fiscal year end: June",EDUGDP[,10],value = TRUE)


#5
library(quantmod)
library(lubridate)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = ymd(index(amzn))
head(sampleTimes)
head(wday(sampleTimes),label=T)

length(grep("^2012",sampleTimes[which(wday(sampleTimes)==2)]))