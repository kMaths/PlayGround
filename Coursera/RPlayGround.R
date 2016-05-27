#Coursera Notes aka "PlayGround"

#create new file if it doesn't exist

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

#right click and selecet "view source" to see xml code on sites

fileURL = "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
#use htmlTreeParse when getting html file
doc <- htmlTreeParse(fileURL,useInternal = TRUE)
#li = list items, 
scores <- xpathSApply(doc,"//li[@class='score']",xmlValue)
teams <- xpathSApply(doc,"//li[@class='team-name']",xmlValue)
