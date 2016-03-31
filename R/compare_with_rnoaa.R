## Must have your NOAA API key loaded as the object `steve`

library(rnoaa)
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
