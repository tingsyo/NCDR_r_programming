# Module: Data Cleaning
# Task solution examples

# Loading libraries
require(dplyr)
require(Hmisc)
require(reshape2)

# Get and read data
furl <- "http://service.dataqualia.com/misc/2015_east.csv.zip"
download.file(furl, destfile="2015_east.csv.zip")
sdata <- read.csv(unz("2015_east.csv.zip", "2015_east.csv"), encoding="UTF-8", stringsAsFactors=F)

furl2 <- "http://service.dataqualia.com/misc/stations.csv"
download.file(furl2, destfile="stations.csv")
stations <- read.csv("stations.csv", encoding="UTF-8", stringsAsFactors=F)

# Retrieve O3 from sdata
o3 <- filter(sdata, sdata$item=="O3")
# Convert observation to numeric
o3[,4:27] <- apply(o3[,4:27], 2, as.numeric)
# Create "max" as the daily maximum value
dailyMax <- function(x){
  return(max(x[4:27], na.rm=T))
  }
o3$max <- as.numeric(apply(o3, 1, dailyMax))
# Calculate yearly average for each station
o3.year <- aggregate(select(o3,28), by=list(o3$station), mean)
names(o3.year) <- c("name","annual.avg")

# Merge with station info for lat/lon
o3.year <- merge(o3.year, select(stations,c(3, 6, 7)))

