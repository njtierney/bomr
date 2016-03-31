## Must have your NOAA API key loaded as the object `steve`

library(rnoaa)
library(dplyr)
library(readr)
library(lubridate)
library(dplyr)
options("noaakey" = steve)

# Find out the location ID for Australia
ex_locs <- ncdc_locs(limit = 20, locationcategoryid = "CNTRY")
ex_locs$data[ex_locs$data$name == "Australia", ]

# Pull a few Australia locations, to get a look at the data and find out the
# total number of stations available
ex_stations <- ncdc_stations(limit = 5, datasetid = "GHCND",
                             datatypeid = "TMAX",
                             locationid = "FIPS:AS")
ex_stations$meta$totalCount ## total number of stations in Australia available
ex_stations$data[ , c("name", "id")] ## example stations, with name and id

# Let me see if I can pull all the Australian stations...
ex_stations <- ncdc_stations(limit = 1000,
                             datasetid = "GHCND",
                             datatypeid = "TMAX",
                             locationid = "FIPS:AS")
# Pull extra data past the 1000 limit
ex_2 <- ncdc_stations(limit = ex_stations$meta$totalCount - 1000,
                      datasetid = "GHCND",
                      datatypeid = "TMAX",
                      locationid = "FIPS:AS",
                      offset = 1001)
all_aust_stations <- rbind(ex_stations$data, ex_2$data) %>%
  mutate(short_id = as.numeric(substring(id, 13, 17)))

# save(all_aust_stations, file = "data/all_aust_stations.RData")

# Compare the stations available for NOAA versus BOM
bom_stations <- read_fwf("tempdata/stations.txt",
                         fwf_widths(c(7, 6, 41, 8, 8, 9, 10, 15, 4, 11,
                                      9, 7)), skip = 4, na = "..")
to_cut <- which(is.na(bom_stations$X1))[1]
bom_stations <- bom_stations[1:(to_cut - 1), ]
colnames(bom_stations) <- c("site", "dist", "site_name", "start",
                            "end", "lat", "lon", "source", "sta",
                            "height", "bar_ht", "wmo")

noaa_stations <- all_aust_stations %>%
  mutate(mindate = ymd(mindate),
         maxdate = ymd(maxdate),
         start = year(mindate),
         end = year(maxdate))

bom_wmo_stations <- filter(bom_stations, !is.na(wmo))

nrow(bom_wmo_stations)
## 874 of the bom_stations actually have values for the WMO station identifier

# How many of the stations from BOM are in the NOAA station list?
both_stations <- inner_join(bom_wmo_stations[ , c("site_name", "wmo", "lat", "lon")],
                            noaa_stations[ , c("name", "short_id", "latitude", "longitude")],
                            by = c("wmo" = "short_id"))
