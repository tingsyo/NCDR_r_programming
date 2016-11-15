# Module: Visualization on Map
# Exercise
require(ggmap)
twn.map <- get_map(location="Taiwan", zoom=7, language="zh-TW")
g <- ggmap(twn.map) + geom_point(data=sinfo.selected, aes(x=longititude, y=latitude), alpha=0.7)
g

#

