#' rCrimemap using uk crime data in Jan 2014 from data.police.uk
#' 
#' The next generation of CrimeMap based on rMaps
#' 
#' ## Example Usage:
#' 
#' rcmap("London Eye", c(1000, 500), "Nokia.normalDay")
#' 
#' rcmap("Manchester", c(1920, 1080), "OpenStreetMap.Mapnik") 
#' 


rcmap <- function(location = "London Eye", 
                  map_size = c(1000, 500), 
                  provider = "Nokia.normalDay") {
  
  ## ===========================================================================
  ## rCrimemap (Demo)
  ## Reference:
  ##    https://github.com/ramnathv/rMaps
  ##    http://leaflet-extras.github.io/leaflet-providers/preview/index.html
  ## ===========================================================================
  
  ## Load Data (included with package)
  df <- readRDS("./data/police_uk_data_2014_01.rds")
  
  ## Location
  suppressMessages(latlon <- geocode(paste0(location, " ,UK")))
  
  ## Locate the nearest police service
  diff_latlon <- as.matrix(abs(df$Latitude - latlon$lat) + abs(df$Longitude - latlon$lon))
  diff_latlon[is.na(diff_latlon)] <- 999999
  service_nearest <- as.character(df$Falls.within[which(diff_latlon == min(diff_latlon))])[1]
  
  ## Convert
  rows_samp <- which(df$Falls.within == service_nearest)
  data_tbl <- as.tbl(df[rows_samp,])
  data_tbl <- group_by(data_tbl, Latitude, Longitude)
  data_count <- summarise(data_tbl, n = length(LSOA.name))
  data_array <- toJSONArray2(na.omit(data_count), json = F, names = F)
  data_json <- rjson::toJSON(data_array)
  
  ## Create Leaflet
  L2 <- Leaflet$new()
  L2$params$width <- map_size[1]
  L2$params$height <- map_size[2]
  L2$setView(c(latlon$lat, latlon$lon), 10)
  L2$tileLayer(provider = provider)   ## Stamen.TonerBackground, OpenStreetMap.Mapnik
  L2$marker(c(latlon$lat, latlon$lon), bindPopup = location)
  
  ## Add leaflet-heat plugin. Thanks to Vladimir Agafonkin
  L2$addAssets(jshead = c("http://leaflet.github.io/Leaflet.heat/dist/leaflet-heat.js"))
  
  # Add javascript to modify underlying chart
  L2$setTemplate(afterScript = sprintf("<script>
                                     var addressPoints = %s
                                     var heat = L.heatLayer(addressPoints).addTo(map)           
                                     </script>", 
                                       data_json))
  
  ## Return the Leaflet Object
  return(L2)
  
}