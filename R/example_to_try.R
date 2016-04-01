## Must have your NOAA API key loaded as the object `steve`

library(rnoaa)
options("noaakey" = steve)

# One station in Australia is ASM00094275
ex_data <- ghcnd(stationid = "ASN00003003",
                 date_min = "1990-01-01",
                 date_max = "2007-01-01")
head(ex_data$data)
