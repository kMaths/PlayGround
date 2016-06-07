set.seed(13435)
X <- data.frame("var1"=sample(1:5),"var2"=sample(6:10),"var3"=sample(11:15))
X
X <- X[sample(1:5),]
X$var2[c(1,3)]=NA
X
X[,1]
X[,"var1"]
X[1:2,"var2"]
#subset using logic
X[(X$var1 <= 3 & X$var3 >11),]
#using or
X[(X$var1 <= 3 | X$var3 >15),]
#missing values - Doesn't return NA's when using which
X[(X$var2 >8),]
X[which(X$var2 > 8),]
#sorting
sort(X$var1)
sort(X$var1,decreasing = TRUE)
#Notes, without na.last = TRUE we do not see the na's
sort(X$var2)
sort(X$var2,na.last = TRUE)
#sort while also seeing the entire matrix
X[order(X$var1),]
X[order(X$var1,X$var2),]

#equivalent method using plyr package 
library(dplyr)
arrange(X,var1)
arrange(X,desc(var1))

#adding new variables
X$var4 <- rnorm(5)
X
Y <- cbind(X,rnorm(5))
Y
#biostat.jhsph.edu/~ajaffe/lec_winterR/Lecture%202.pdf


#Summarizing data
if(!file.exists("./data")){dir.create("./data")}
fileURL <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileURL,destfile='./data/restaurants.csv', method="curl")
restData <- read.csv("./data/restaurants.csv")
head(restData)
tail(restData,n=3)
summary(restData)
#see that one of the zip codes is negative
#look at the types each factor is
str(restData)
#look at spread
quantile(restData$councilDistrict,na.rm = TRUE)
#look at different percentiles
quantile(restData$councilDistrict,probs = c(.5,.75,.9))
#you can see how many of each value there is. 
#here we see there is only one value that is negative
#we also put in useNA if any (not i fany) that will add up any of the NA's if there are any
#by default R doesn't tell you
table(restData$zipCode,useNA = "ifany")
#make 2D
#get a sence of the relationship between variables
table(restData$councilDistrict,restData$zipCode)

#count number of na
sum(is.na(restData$councilDistrict))
sum(restData$zipCode == "21212")
#do any equal na?
any(is.na(restData$councilDistrict))
#checks if all
all(restData$zipCode > 0)
#row and column sums
colSums(is.na(restData))
all(colSums(is.na(restData))==0)
#values with specific characteristics
#you could uses == but you can see if there are any in the list
table(restData$zipCode %in% c("21212"))
table(restData$zipCode %in% c("21212","21213"))
#use this new logic to subset the data.frame
restData[restData$zipCode %in% c("21212","21213"),]
#load Berkley data set
data("UCBAdmissions")
#turn it into data.frame
DF = as.data.frame(UCBAdmissions)
summary(DF)

#cross tabs
head(DF)
dim(DF)
xt <- xtabs(Freq ~ Gender + Admit, data = DF)
xt

#flat tables
warpbreaks$replicate <- rep(1:9, len=54)
xt <- xtabs(breaks ~ . , data = warpbreaks)
xt
ftable(xt)
fakeData = rnorm(1e5)
object.size(fakeData)
print(object.size(fakeData),units="Mb")



#Creating new variables
#missing value indicators
#"cutting up" quantitative variables
#Applying transforms when you have weird distributions
#use restaurant data again
s1 <- seq(1,10,by=2)
s1
s2 <- seq(1,10,length=3)
s2
x <- c(1,3,8,25,100)
#for indexing or looping
seq(along = x)
#by, length, along

#subsetting variables
restData$nearMe = restData$neighborhood %in% c("Roland Park", "Homeland")
table(restData$nearMe)



#Reshaping data

#we want
#Each variable to form a column
#Each observation to form a row
#And each table/file to store about one kind of observation
#focus on the first two.

library(reshape2)
head(mtcars)
str(mtcars)
#first melt the data set
mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars, id = c("carname", "gear", "cyl"), measure.vars = c("mpg", "hp"))
head(carMelt)
tail(carMelt)
#Now a tall skinny data set

cylData <- dcast(carMelt, cyl ~ variable)
cylData

cylData <- dcast(carMelt, cyl~variable,mean)
cylData

#averaging values
head(InsectSprays)
#within each value of spray this will count up the sum of count
tapply(InsectSprays$count,InsectSprays$spray,sum)
#split
spIns = split(InsectSprays$count,InsectSprays$spray)
spIns
sprCount <- lapply(spIns,sum)
sprCount
unlist(sprCount)
#combines sum and unlist
sapply(spIns,sum)

#ddply
library(plyr)
ddply(InsectSprays,.(spray),summarize,sum = sum(count))

spraySum <- ddply(InsectSprays,.(spray),summarize, sum = ave(count, FUN=sum))
dim(spraySum)
head(spraySum)
tail(spraySum)

#http://plyr.had.co.nz/09-user/
#slideshare.net/jeffrybreen/reshaping-data-in-r
#r-bloggers.com/a-quic-primer-on-split-apply-combine-problems
#see also,
#acast - for casting a multi-dimensional arrays - similar to dcast but array instead of data.frame
#arrange - for faster reordering without using order() commands
#mutate - adding new variables




#Manageing data frames in R
#arrange, filter, select, mutate and rename as well as summerise
#dplyer simplifies existing functionality and makes it faster
#select returns subset of columns
#filter returns subset of rows
#arrange reorders rows of a data frame
#rename renames variables in a data frame
#mutate adds new vaiables/columns or transforms existing variables
#summaraize generates summary statistics of different variables in the data frame, possibly within strata
#There is also print method that prevents you from printing a lot of data to the console

#properties
#first argument is always a data frame
#subsequent arguments describe what to do with it. you can refer to columns in the datat frame directly without using the $
#result is new data frame
#make sure format of your data frame is correct.

library(dplyr)
chicago <- readRDS("chicago.rds")
dim()
str()
names()
head(select(chicago, city:dptp))
head(select(chicago,-(city:dptp)))


chic.f <- filter(chicago,  pm25tmean2 >30)
chic.f <- filter(chicago, pm25tmean2 >30 & tmpd >80)

chicago <- arrange(chicago, date)
arrange(chicago, desc(date))


chicago <- rename(chicago, pm25 = pm25tmean2)
head(chicago)


mutate(chicago, pm25detrend = pm25-mean(pm25, na.rm = TRUE))
head(sleect(chicago, pm25, pm25detrend))

hotcold <- mutate(chicago, tempcat = factor(1*(tmpd>80), labels = c("cold","hot")))
hotcold
summarize(hotcold, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2mean2))


chicago <- mutated(chicago, year = as.POSIXlt(data)$year +1900)
years <- grou_by(chicago, year)
summarize(years, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

#pipeline opperator
chicago %>% mutate(month = as.POSIXlt(data)$mon +1) %>% group_by(moth) %>% summarize(mp25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

#Once you learn the dplyr "grammar" you can also
#work with data frame "backends"
#you and work with data.table for large ast tables
#SQl interface for relational databases via the DBI package
#no need to learn a whole new set of commands



#merging data sets
if(!file.exists("./data")){dir.create("./data")}
fileURL1 = "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
fileURL2 = "https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"
download.file(fileURL1,destfile = "./data/reviews.csv", method = "curl")
download.file(fileURL2,destfile = "./data/solutions.csv",method = "curl")
reviews = read.csv("./data/reviews.csv")
solutions <- read.csv("./data/solutions.csv")
head(reviews,2)
head(solutions,2)
#solution_id = id in reviews
names(reviews)
names(solutions)
#important parameters for merge
#x,y, by.x or by.y which do we merge and all
#By default it just tries to merge on variables that have the same name
#This probably isn't what we want
mergedData <- merge(reviews, solutions,by.x = "solution_id", by.y = "id", all =T)
head(mergedData)

intersect(names(solutions),names(reviews))
mergedData2 <- merge(reviews,solutions,all = TRUE)
#just an even bigger dataframe
head(mergedData2)

#using join in plyr
#can only merge on common names
#connot merge like we just did
#it's faster 
df1 = data.frame(id=sample(1:10),x=rnorm(10))
df2 = data.frame(id=sample(1:10),y=rnorm(10))
arrange(join(df1,df2),id)
#easier to join multiple tables with join_all
df3<-data.frame(id=sample(1:10),z=rnorm(10))
dfList = list(df1,df2,df3)
join_all(dfList)
#statmethods.net/management/merging.html
#plyr.had.co.nz/
#en.wikipedia.org/wiki/Join_(SQL)
