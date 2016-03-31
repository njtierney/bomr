library(readr)
bom_stations <- read_fwf("tempdata/stations.txt",
                         fwf_widths(c(7, 6, 41, 8, 8, 9, 10, 15, 4, 11,
                                        9, 7)), skip = 4, na = "..")
to_cut <- which(is.na(bom_stations$X1))[1]
bom_stations <- bom_stations[1:(to_cut - 1), ]
colnames(bom_stations) <- c("site", "dist", "site_name", "start",
                            "end", "lat", "lon", "source", "sta",
                            "height", "bar_ht", "wmo")
