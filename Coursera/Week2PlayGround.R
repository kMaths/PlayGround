#mySQL
library(RMySQL)
ucscDb <- dbConnect(MySQL(), user = 'genome', host = 'genome-mysql.cse.ucsc.edu')
#"show databases" is a mysql command
result <- dbGetQuery(ucscDb,"show databases;")
#make sure you disconnect from the server
dbDisconnect(ucscDb)
#all available databases
result

#On each server there are multiple databases. In each database, there are multiple tables
#Each table can be thought of as a data.frame
hg19 <- dbConnect(MySQL(), user='genome',db='hg19',host="genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)
#first 5 tables
allTables[1:5]
dbListFields(hg19,"affyU133Plus2")
#count all of the records
dbGetQuery(hg19, "select count(*) from affyU133Plus2")
#get dataframe out
affyData <- dbReadTable(hg19, 'affyU133Plus2')
head(affyData)
warnings()
#get part of the table
#that where command looks weird. Is that just a mysql thing?
query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query)
quantile(affyMis$misMatches)
#suck out a small amount of data to make sure you're getting what you want
affyMisSmall <- fetch(query, n=10)
#clear query
dbClearResult(query)
dim(affyMisSmall)
dbDisconnect(hg19)
#http://cran.r-project.org/web/packages/RMySQL/RMySQL.pdf
#pantz.org/software/mysql/mysqlcommands.html
#r-bloggers.com/mysql-and-r
#Do not delete, add or join things from ensembl



#HDF5
#see bioconductor.org/packages/release/bioc/vignettes/rhdf5/inst/doc/rhdf5.pdf
source('https://bioconductor.org/biocLite.R')
biocLite("rhdf5")
library(rhdf5)
created = h5createFile("example.h5")
created
#create groups within file
created = h5createGroup("example.h5","foo")
created = h5createGroup("example.h5","baa")
#subgroup of foo
created = h5createGroup("example.h5","foo/foobaa")
h5ls('example.h5')
A = matrix(1:10,nr=5,nc=2)
h5write(A,"example.h5","foo/A")
B = array(seq(0.1,2.0,by=0.1),dim=c(5,2,2))
#attributes here are like units
attr(B,"scale")<- "liter"
h5write(B, "example.h5","foo/foobaa/B")
h5ls('example.h5')
#a is h5 data set of integers etc

#write data set
df = data.frame(1L:5L, seq(0,1,length.out=5), c("ab","cde","fghi","a","s"), stringsAsFactors = FALSE)
h5write(df, "example.h5","df")
h5ls('example.h5')
H5close()

#reading data
#read data set
readA = h5read("example.h5","foo/A")
readB = h5read("example.h5","foo/foobaa/B")
readdf = h5read("example.h5","df")
readA
readdf
#write 12,13,14 to a particular part of the data set
#here the 1st 3 rows in the first column
h5write(c(12,13,14),"example.h5","foo/A",index=list(1:3,1))
h5read("example.h5","foo/A")
#you can use index to read a specific part of the dataset as well

#hdf5 can be used to optimize reading/writing from disc in F





#Reading data from the web intro

#webscraping: programatically extracting data from the HTML code of websites
#eg google scholar
con= url("https://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
htmlCode
library(XML)
library(RCurl)

#none of the below worked
#xData <- getURL(url)
#html <- htmlParse(xData)
url <- "https://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
#url2 <- "view-source:https://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
#html2 <- htmlTreeParse(url2, useInternalNodes = T)
#html <- htmlTreeParse(url, useInternalNodes = T)
#class(html)
#rootNode <- xmlRoot(html)
#rootNode
#xpathSApply(html2, "//title", xmlValue)
#names(rootNode)
#names(html)
#xpathSApply(html, "//td[@id='col-citedby']",xmlValue)
#xmlSApply(html,xmlValue)

#this worked
library(httr)
html2 = GET(url)
content2 = content(html2, as="text")
parsedHTML = htmlParse(content2, asText = TRUE)
xpathSApply(parsedHTML, "//title", xmlValue)

#you can authenticate 
#we call pg2 the handle
pg2 = GET("http://httpbin.org/basic-auth/user/passwd", authenticate('user','passwd'))
names(pg2)
#we get to kind of save the authentication when we use handles

#www.r-bloggers.com/?s=Web+Scraping
#cran.r-project.org/web/packages/httr/httr.pdf



#Reading from apis
#stands for application programming interface
myapp = oauth_app("twitter", key = "d6GwQnsNx6BbYNnscLgf9Yngz", secret = "PSestbbZd0eFr7cN9O3ppvJqIACnKsW72LUJcaRECyRrfbEdOp")
sig = sign_oauth1.0(myapp, token = "733867692554260486-ctupket4Qegke8v4aoft1OBJX1LYJbx", token_secret = "SoxMgESI3dUO1Jb7E9mNO4tvDoBd98Vkm6NYLxkEbEbZV")
homeTL = GET('https://api.twitter.com/1.1/statuses/home_timeline.json',sig)
#content recognizes it's json
library(jsonlite)
json1 = content(homeTL)
json2 = jsonlite::fromJSON(toJSON(json1))
json2[1,4]
#httr allows GET, POST, PUT, DELETE if you are authorized
#works well with facebook, github, etc

#foreing package for reading from S, SAS, SOSS, Stata, Systat
#read images
#


#Reading from other sources
#"data storage mechanism R package"
#file - opens a text file that is local
#url- open a connection to a url
#gzfile - open a connection to a .gz file
#bzfile - open a connection to a .bz2 file
#?connections for more information
#remember to close connections