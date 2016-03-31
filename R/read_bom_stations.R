library(readr)
bom_stations <- read_fwf("tempdata/stations.txt",
                         fwf_widths(c(7, 6, 41, 8, 8, 9, 10, 15, 4, 11,
                                        9, 7)), skip = 4, na = "..")
to_cut <- which(is.na(bom_stations$X1))[1]
bom_stations <- bom_stations[1:(to_cut - 1), ]
colnames(bom_stations) <- c("site", "dist", "site_name", "start",
                            "end", "lat", "lon", "source", "sta",
                            "height", "bar_ht", "wmo")

bom_stations$start <- as.numeric(bom_stations$start)
bom_stations$end <- as.numeric(bom_stations$end)
bom_stations$wmo <- as.numeric(bom_stations$wmo)

active <- bom_stations[which(is.na(bom_stations$end) &
                               is.na(bom_stations$wmo)),]

library(ggplot2)
library(dplyr)

aus_map <- map_data("world", "australia")

gg <- ggplot()
gg <- gg + geom_map(data=aus_map, map=aus_map,
                    aes(x=long, y=lat, map_id=region),
                    color="#2b2b2b", size=0.15, fill=NA)
gg <- gg + geom_point(data=active, aes(x=lon, y=lat), color="red", size=1.0, alpha=0.5)
gg <- gg + coord_map()
gg <- gg + ggthemes::theme_map()
gg

load("data/all_aust_stations.RData")
noaa <- all_aust_stations %>%
  mutate(maxdate = ymd(maxdate))
current_noaa <- filter(noaa, year(maxdate) == 2016) # 795 current stations
gg <- ggplot()
gg <- gg + geom_map(data=aus_map, map=aus_map,
                    aes(x=long, y=lat, map_id=region),
                    color="#2b2b2b", size=0.15, fill=NA)
gg <- gg + geom_point(data=current_noaa,
                      aes(x=longitude, y=latitude), color="red",
                      size=0.3, alpha=0.5)
gg <- gg + coord_map()
gg <- gg + ggthemes::theme_map()
gg

head(bom_stations)

dat <- mutate(arrange(summarize(group_by(active, start, end), total=n()), desc(total)), end=ifelse(is.na(end), 2016, end))
dat <- add_rownames(dat)

dat <- mutate(summarize(group_by(active, start, end), total=n()), end=ifelse(is.na(end), 2016, end))
dat <- arrange(dat, start)
dat <- add_rownames(dat)
dat$rowname <- factor(as.numeric(dat$rowname))

gg <- ggplot(dat)
gg <- gg + geom_segment(aes(y=start, yend=end,
                            x=rowname, xend=rowname,
                            alpha=total))
gg <- gg + coord_flip()
gg <- gg + theme_minimal()
gg <- gg + theme(panel.grid=element_blank())
gg <- gg + theme(axis.text.y=element_blank())
gg <- gg + theme(axis.ticks=element_blank())
gg











