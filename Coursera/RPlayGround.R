#Coursera Notes on Getting and Cleaning Data Week 1


#create new directory if it doesn't exist
#using dir.create()
#Create file with file.create or write.table or use as below download.file

if(!file.exists("data")) (
  dir.create("data")
)

#Import from URL
#https set method = "curl"

fileURL <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileURL, destfile = "./data/cameras.csv", method = "curl")
list.files("./data")
#record the data you downloaded the data
dateDownloaded <- date()
dateDownloaded

#Import from XML

#tags = labels: <start> ends with </start> or <empty tag /> 
#elements are specific examples of tags
#attributes = components of the label:
#<img src= "jeff.jpg" alt="instructor"/>
# See wikipedia page on XML

library(XML)
fileURL = "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileURL, useInternal = TRUE)
#wrapper element for the entire document
rootNode <- xmlRoot(doc)
#get name out
xmlName(rootNode)
#shows elements within rootNode
names(rootNode)
#directly access parts of document. 
#Similar to accessing list elements

#first subcomponent of the root node
rootNode[[1]]
#first subcomponent of the first subcomponent of the root node
rootNode[[1]][[1]]

#Programmatically extract parts of file

#gets every single value of every single tagged element
xmlSApply(rootNode,xmlValue)

#get specific component using XPath language. Ugh: 
#see www.stat.berkely.edu/~statcur/Workshop2/Presentations/XML.pdf

#/node is top level node
#//node is any level

#gets items on the menu. Gets nodes with tags named name
xpathSApply(rootNode,"//name",xmlValue)

#gets prices
xpathSApply(rootNode,"//price",xmlValue)

#right click and select "view source" to see xml code on sites

fileURL = "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
#use htmlTreeParse when getting html file
doc <- htmlTreeParse(fileURL,useInternal = TRUE)
#li = list items, 
scores <- xpathSApply(doc,"//li[@class='score']",xmlValue)
teams <- xpathSApply(doc,"//li[@class='team-name']",xmlValue)



#Import JSON

library(jsonlite)
jsonData = fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)
#data frame in data frame!
names(jsonData$owner)
#one for each repo
jsonData$owner$login

#turn something into jSON
myjson <- toJSON(iris, pretty = TRUE)
cat(myjson)
iris2 <- fromJSON(myjson)
head(iris2)

#see json.org or
#r-bloggers.com/new-package-jsonlite-a-smarter-json-encoderdecoder/
#jsonlite vignette


#data.table package
#written in c, and very fast; faster than data.frame
library(data.table)

#Create the same way you would a data.frame
DF <- data.frame(x=rnorm(9),y=rep(c("a", "b","c"),each=3),z=rnorm(9))
head(DF,3)

DT <- data.table(x=rnorm(9),y=rep(c("a","b","c"),each=3),z=rnorm(9))
head(DT,3)

#see all tables in memory
tables()

#subset rows just like data.frame

DT[2,]
DT[DT$y=="a",]

#if you don't specify index, it takes rows
DT[c(2,3)]

#subsetting columns is different from data.frame: uses expresions
DT[,c(1,2)]

#expressions are between {}
k={print(10);5}
print(k)

DT[,list(mean(x),sum(z))]
DT[,table(y)]

#add w to table, does not make copy of table like data.frame does.
DT[,w:=z^2]
head(DT,3)

#be careful because a copy is not made
DT2 <- DT
DT[,y:=2]
head(DT,3)
head(DT2,3)
#instead use the copy function

#multiple functions. Note: left to right, not mathematical
DT[,m:={tmp <- z; log2(tmp+5)}]
head(DT,3)
#plyr like operations
DT[,a:=x>=0]
head(DT,3)

#grouping
DT[,b:= mean(x+w), by=a]
head(DT)

# .N gives you an integer, length 1, containing the number
# ie, it counts instead of using DT$x
DT <- data.table(x=sample(letters[1:3],1E5,TRUE))
DT[,.N, by=x]

#Keys
DT <- data.table(x=rep(c("a", "b", "c"),each=100),y=rnorm(300))
setkey(DT,x)
DT['a']

#Use keys to facilitate joins aka
#merge
DT1 <- data.table(x=c("a",'a','b','dt1'), y=1:4)
DT2 <- data.table(x=c('a','b','dt2'), z=5:7)
setkey(DT1,x); setkey(DT2,x)
#merge on keys, so matching 
merge(DT1,DT2)
#Question: does merge take cartesian product?
DT3 <- data.table(x=c('a','a'),y=1:2)
DT4 <- data.table(x=c('a','a'),y=3:4)
setkey(DT3,x); setkey(DT4,x)
merge(DT3,DT4)
#yes, yes it does

#reading from disk is fast
big_df <- data.frame(x=rnorm(1E6), y=rnorm(1E6))
#set up temp file
file <- tempfile()
#write data.frame to file
write.table(big_df, file=file, row.names=FALSE, col.names = FALSE, sep = "\t", quote = FALSE)
#time how long it takes to read in table. 
#fread reads in table similar to read.table, but using tab separation
system.time(fread(file))
#using data.frame read in command
system.time(read.table(file, header=TRUE,sep="\t"))
#need to get solid state hard drive
#See:
#https://r-forge.r-project.org/scm/viewvc.php/pkg/NEWS?viewmarkup&root=datatable
#stackoverflow.com/questions/13618488/what-you-can-do-with-data-frame-that-you-cant-in-data-table


