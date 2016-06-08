#Editing Text Variables

if(!file.exists("./data")){dir.create("./data")}
fileURL <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileURL,destfile = "./data/cameras.csv",method = "curl")
cameraData <- read.csv("./data/cameras.csv")
names(cameraData)
#make all of the names lower case
tolower(names(cameraData))
#also a to upper command

#get rid of periods
splitNames <- strsplit(names(cameraData),"\\.")
splitNames[[5]]
splitNames[[6]]

#subset out variable names

#asside on lists
mylist <- list(letters=c("A","B","C"), numbers = 1:3, matrix(1:25,ncol = 5))
head(mylist)
mylist[1]
mylist$letters
#takes vector
mylist[[1]]

#remove periods and get first part of the variable name
splitNames[[6]][[1]]
firstElement <- function(x){x[1]}
sapply(splitNames,firstElement)

file.exists("./data/reviews.csv")
reviews<-read.csv("./data/reviews.csv")
file.exists("./data/solutions.csv")
solutions <- read.csv("./data/solutions.csv")
head(reviews,2)
head(solutions,2)
names(reviews)
#only replaces the first in each
sub("_","",names(reviews))

#replace multiple
testName <- "this_is_a_test"
sub("_","",testName)
gsub("_","",testName)

#searching 
grep("Alameda",cameraData$intersection)
#returns true when it's there and false when it's not
table(grepl("Alameda",cameraData$intersection))

#subset
cameraData2 <- cameraData[!grepl("Alameda",cameraData$intersection),]

#putting value = TRUE will show you not the place it appears, but the acctual value
#of where it appears
grep("Alameda",cameraData$intersection,value = T)
#what happens when the value does not appear
grep("JeffStreet",cameraData$intersection)
length(grep("JeffStreet",cameraData$intersection))

library(stringr)
#how many characters are in a string
nchar("Jeffrey Leek")
#subset a string
#get 1 through 7
substr("Jeffery Leek",1,7)
#combine two strings
paste("Jeffery","Link")
paste("Jeffery","Link",sep = "*")
paste0("Jeffery","Link")
#cut off spaces at the end
str_trim("Jeff         ")

#Important points
#Names of variables should be
# All lower case when possibe (missing caps are hard to find)
# Descriptive
# Not duplicated
# Not have underscores or dots or white space

#Variables with character values
# Should usually be made into factor variables
# Should be descriptive (use Male/Female versus 0/1 or M/F)


#Regular expressions
#searching
#litterals and mettacharacters <->
#simplestpattern consists only of literals
#mathes to lines
#we need a way to express whitespace word boundaries, sets of literals,
#the beginning and end of a line, and alternatives ("war" or "peace")
#use metta characters

#^i think matteches the start

#$ mathes the end of the line

#use [] to give a list of characters we will accept
#then you can combine them
#you can also match a range 

#number followed by any letter
#[0-9] [a-zA-Z]

#the carrot ^ can also indicate what we don't want
#[^?.]$ mathes any line that does not end in ? or .


#regular expressions 2
#mettacharacters
#. is for any character
#| for alternatives the or
#can be combined
#^[Gg]ood|[Bb]ad is starts with good or has bad in it
#adding () will include everything
#^([Gg]ood|[Bb]ad) will get things that start with good or bad

#a ? after () inedicates it is opptional
#[Gg]eorge( [Ww]\.)? [Bb]ush makes the w opptional
#\ escaped the dot
#* means any number including none
#(.*) mathes anything in ()
#+ means at least one
#[0-9]+ (.*) [0-9]+
#{} interval quantifiers
#[Bb]ush( +[^ ]+ +){1,5} debate
#4:41 look again
#m.n means at least m but not more than n
#m means exactly m
#m, means at least m

#() can also be used to remember matched text
# +([a-zA-Z])+ +\1 +
#at least one space, followed by at least one letter, followed
#by at least on space, followed by the exact same string of letters,
#followed by at least one space

#meta characters are greedy, so it will take the longest possible string that
#satisfies an expression
#To make it less gredy
#use a questionmark
#^s(.*?)s
#Good to use when you want to extract data from "unfriendly" sources



#Working with dates
d1 = date()
d1

class(d1)

d2 = Sys.Date()
d2
class(d2)

#formatting
format(d2,"%a %b %d")
#%A unabbreviated weekday
#%m is mont %b is abbreviated month
#%y is 2 digit year %Y is 4 digit year
??dmy
library(lubridate)
x = c("1jan1960","2jan1960","31mar1960","30jul1960")
z = dmy(x)
z
z[1]-z[2]
as.numeric(z[1]-z[2])
weekdays(d2)
months(d2)
julian(d2)
?Sys.timezone
wday(dmy(x)[1])
wday(dmy(x)[1],label = TRUE)
#want in POSIXlt



#Data resources
#data.gov/opendatasites
#gapminder.org
#surveys
#asdfree.com
#infochimps.com/marketplace
#blog.mortardata.com/post/67652898761/6-dataset-list-curated-by-data-scientists
