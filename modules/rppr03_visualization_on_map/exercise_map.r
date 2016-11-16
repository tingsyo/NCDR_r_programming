# Module: Visualization on Map
# Exercise Solutions

# 1. Install and load required packages
require(ggmap)
require(sp)
require(gstat)
require(maptools)
require(dplyr)

# 2. download and merge data
furl2 <- "http://service.dataqualia.com/misc/stations.csv"
download.file(furl2, destfile="stations.csv")
stations <- read.csv("stations.csv", encoding="UTF-8", stringsAsFactors=F)

# 3. Show some maps
map <- get_map(location="Taiwan", zoom=7, language="zh-TW")
g3 <- ggmap(map) + geom_point(data=stations, aes(x=longititude, y=latitude), alpha=0.7)


# 4. Create a random value for plotting
tmp <- select(stations, name, lon=longititude, lat=latitude)
center <- c(122.011567, 23.113398)
distance <- (tmp$lon - center[1])^2 + (tmp$lat - center[2])^2
set.seed(12345)
tmp$value <- 6 - 20*exp(-2*distance) + abs(rnorm(nrow(tmp)))

# 5. Plot the value
g5 <- ggmap(map) + 
     geom_point(data=tmp, aes(x=lon, y=lat, size=value), alpha=0.7)

# 6. Density plot
map <- get_map(location="Taiwan", zoom=7, language="zh-TW", color="bw")
g6 <- ggmap(map, extent="panel", maprange=F) + 
  stat_density2d(data=tmp, aes(x=lon,y=lat, fill=..level.., alpha=..level..),
                 size = 0.1, bins = 100, geom = 'polygon') +
  scale_alpha(range = c(0.10, 0.30), guide = FALSE) +
  geom_density2d(data=tmp, aes(x=lon,y=lat, alpha=0.6))

# 7. Spatial Interpolation
x.range <- as.numeric(c(117.5, 124.5))
y.range <- as.numeric(c(20.5, 27.2))
grd <- expand.grid(lon = seq(from = x.range[1], to = x.range[2], by = 0.1),
                   lat = seq(from = y.range[1], to = y.range[2], by = 0.1))  
coordinates(grd) <- ~lon+lat
gridded(grd) <- TRUE
coordinates(tmp) = ~lon+lat
idw <- idw(formula=value~1, locations=tmp, newdata=grd, idp=4.0, debug.level=0)  
idw.output = as.data.frame(idw, stringsAsFactors=F)
names(idw.output)[1:3] <- c("lon", "lat", "value")  
g7 <- ggmap(map, extent="panel", maprange=F) + 
          geom_tile(data=idw.output, aes(x=lon, y=lat, fill=value), alpha=0.5) +
          scale_fill_gradient(low = "green", high = "red") +
          theme(axis.title = element_blank(), text = element_text(size = 12))


