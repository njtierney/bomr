map(names(station_list), function(x) {
  map(station_list[[x]], function(y) {
    cat(".")
    S_read_bom(x, y)
  })
}) -> wx
