library(sp)
library(maptools)
library(rgeos)
library(rgdal)
library(raster)
library(geojsonio)
library(dismo)
library(ggplot2)
library(viridis)

aus <- readOGR("tempdata/au-states.geojson", "OGRGeoJSON")
aus <- SpatialPolygonsDataFrame(unionSpatialPolygons(aus, rep(1, 9)), data.frame(id=1))
plot(aus)

grid <- raster(extent(aus))
res(grid) <- 0.5
proj4string(grid) <- proj4string(aus)
grid_polygon <- rasterToPolygons(grid)

geojson_write(grid_polygon, geometry="polygon", file="tempdata/ausgrid.json", group="grid")

pts <- data.frame(active[,c("lon", "lat")])
coordinates(pts) <- ~lon+lat
proj4string(pts) <- CRS(proj4string(grid_polygon))

stations_grid <- count(pts %over% grid_polygon, layer)

aus_grid <- fortify(grid_polygon, region="layer")

gg <- ggplot()
gg <- gg + geom_map(data=aus_grid, map=aus_grid,
                    aes(x=long, y=lat, map_id=id),
                    color="#2b2b2b", size=0.05, fill=NA)
gg <- gg + geom_map(data=stations_grid, map=aus_grid,
                    aes(fill=log(n), map_id=layer))
gg <- gg + scale_fill_viridis()
gg <- gg + ggthemes::theme_map()
gg <- gg + theme(legend.position="right")
gg
