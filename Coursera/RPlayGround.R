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


