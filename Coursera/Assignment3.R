#1
if(!(file.exists("./data"))){dir.create("./data")}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileURL,destfile = "./data/IdahoHousing.csv",method = "curl")
housing <- read.csv("./data/IdahoHousing.csv")
dim(housing)
head(housing)
names(housing)
agriculturalLogical <- (housing$ACR== 2 & housing$AGS == 6)
which(agriculturalLogical)


#2
library(jpeg)
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(fileURL,destfile = "./data/ProfPic.jpg",method = "curl")
pic <- readJPEG("./data/ProfPic.jpg",native = TRUE)
quantile(pic,probs = c(.3,.8))

#3
fileURL1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
fileURL2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
#Source
#http://data.worldbank.org/data-catalog/GDP-ranking-table
#http://data.worldbank.org/data-catalog/ed-stats
download.file(fileURL1,destfile = "./data/GDP.csv",method = "curl")
download.file(fileURL2,destfile = "./data/EDU.csv",method = "curl")
GDP <- read.csv("./data/GDP.csv",na.strings = "", stringsAsFactors = FALSE)
EDU <- read.csv("./data/EDU.csv",na.strings = "", stringsAsFactors = FALSE)
head(GDP)
tail(GDP)
str(GDP)
names(GDP)
names(EDU)

codes <- select(EDU,CountryCode,Income.Group)
dim(codes)

merged <- merge(GDP, codes, by.x = "X", by.y = "CountryCode",incomparables = NA)
library(dplyr)
newMerged <- merged %>% filter(!is.na(Gross.domestic.product.2012)) %>% 
  arrange(desc(as.numeric(Gross.domestic.product.2012)))
newMerged[13,]

#4
splt <- split(newMerged$Gross.domestic.product.2012,newMerged$Income.Group)
names(splt)
summarise(splt,High = mean(as.numeric(splt$`High income: OECD`)),
          HighNon=mean(as.numeric(splt$`High income: nonOECD`)))

#5
newMerged$quart <- with(newMerged, 
       cut(as.numeric(newMerged$Gross.domestic.product.2012),
       breaks = quantile(as.numeric(newMerged$Gross.domestic.product.2012),
       probs=c(.2,.4,.6,.8,1)),include.lowest = TRUE))
table(newMerged$Income.Group,newMerged$quart)