#' rCrimemap using crime data from data.police.uk
#' 
#' The next generation of CrimeMap based on rMaps!
#' 
#' Location: Location of interest within England and Wales (e.g. London, Birmingham, Newcastle)
#' 
#' period: Specific month of interest between Dec 2010 and Jan 2014 in 'yyyy-mm' format (e.g. 2014-01)
#' 
#' type: Specific type of crime or all (e.g. "All", "Anti-social behaviour", "Burglary", "Violent crime")
#' 
#' map_size: Resolution of the map (e.g. Full HD = c(1920 x 1080))
#' 
#' provider: Base map service provider (e.g. "Nokia.normalDay", "MapQuestOpen.OSM", "Stamen.Watercolor") (see http://leaflet-extras.github.io/leaflet-providers/preview/index.html)
#' 
#' zoom: Zoom level of the map (default = 10)
#' 
#' ## Example Usage:
#' 
#' rcmap()
#' 
#' rcmap("London", "2014-01", "All", c(1000,500), "Nokia.normalDay")
#' 
#' rcmap("London", "2014-01", "All", c(1000,500), "MapQuestOpen.OSM")
#'
#' rcmap("London", "2014-01", "Anti-social behaviour", c(1000,500), "Nokia.normalDay")
#' 
#' rcmap("Manchester", "2014-01", "All", c(1000,500), "MapQuestOpen.OSM")
#' 
#' rcmap("Liverpool", "2014-01", "All", c(1000,500), "MapQuestOpen.OSM")

rcmap <- function(location = "Ball Brothers EC3R 7PP", 
                  period = "2014-01",
                  type = "All",
                  map_size = c(1000, 500), 
                  provider = "Nokia.normalDay",
                  zoom = 10) {
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## References
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  ## https://github.com/ramnathv/rMaps
  ## http://data.police.uk
  ## http://leaflet-extras.github.io/leaflet-providers/preview/index.html
  ## http://leaflet.github.io/Leaflet.heat/dist/leaflet-heat.js
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Pre-load Packages
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  suppressMessages(library(rCharts))
  suppressMessages(library(rMaps))
  suppressMessages(library(ggmap))
  suppressMessages(library(dplyr))
  suppressMessages(library(rjson))
  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Download data (reformatted and stored in author's Bitbucket account)
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  ## Make sure the input is valid
  all_year_month <- format(seq(as.Date("2010-12-01"), length=38, by="months"), "%Y-%m")
  
  if (!period %in% all_year_month) {  
    
    ## Set period to latest available dataset
    period <- all_year_month[length(all_year_month)]
    
    ## Display error message
    cat("[rCrimemap]: The input period is out of range! The latest dataset '",
        period, "' is used instead.\n", sep = "")
    
  }
    
  ## Loading crime data directly from Bitbucket
  if (period == "2014-01") {
    cat("[rCrimemap]: Loading '", period, ".rda' (included with the rCrimemap package) ...\n", sep = "")
    load("./data/2014-01.rda")
  } else {
    cat("[rCrimemap]: Downloading '", period, ".rda' from author's Bitbucket account ...\n", sep = "")
    con <- url(paste0("http://woobe.bitbucket.org/data/rCrimemap/", period, ".rda"))
    load(con)
    close(con)
  }
  

  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Convert data frame into json
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  ## Display
  cat("[rCrimemap]: Converting raw data into JSON format for Leaflet ...\n")
  
  ## Use ggmap::geocode to obtain lat and lon (not foolproof yet - need to improve this later)
  suppressMessages(latlon <- ggmap::geocode(paste0(location, " , United Kingdom")))
  
  ## Approx. Centroid
  tbl_centroid <- dplyr::group_by(crime_data, Falls.within)
  centroid <- dplyr::summarise(tbl_centroid, lat = mean(Latitude, na.rm = TRUE), lon = mean(Longitude, na.rm = TRUE))
  diff_centroid <- data.frame(force = centroid$Falls.within, diff = as.matrix(abs(latlon$lat - centroid$lat)) + as.matrix(abs(latlon$lon - centroid$lon)))
    
  ## Locate the nearest police service
  police_nearest <- as.character(diff_centroid[which(diff_centroid$diff < 0.1),]$force) 
  
  ## Identify records of interest
  if (type == "All") {
    rows_samp <- which(crime_data$Falls.within %in% police_nearest)
  } else {
    rows_samp <- which((crime_data$Falls.within %in% police_nearest) & (crime_data$Crime.type == type))
  }
  
  ## Convert data
  data_tbl <- dplyr::group_by(crime_data[rows_samp,], Latitude, Longitude)
  data_count <- dplyr::summarise(data_tbl, n = length(LSOA.name))
  data_array <- rCharts::toJSONArray2(na.omit(data_count), json = F, names = F)
  data_json <- rjson::toJSON(data_array)
    
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Create Leaflet object with Heat Map
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  ## Display
  cat("[rCrimemap]: Creating Leaflet with Heat Map ...\n")
  
  ## Create Leaflet
  L2 <- rMaps::Leaflet$new()
  L2$params$width <- map_size[1]
  L2$params$height <- map_size[2]
  L2$setView(c(latlon$lat, latlon$lon), zoom)
  L2$tileLayer(provider = provider)   ## OpenStreetMap.Mapnik
  
  ## Set Marker
  L2$marker(c(latlon$lat, latlon$lon), bindPopup = location)
  
  ## Add leaflet-heat plugin. Thanks to Vladimir Agafonkin
  L2$addAssets(jshead = c("http://leaflet.github.io/Leaflet.heat/dist/leaflet-heat.js"))
  
  ## Add javascript to modify underlying chart
  L2$setTemplate(afterScript = sprintf("<script>
                                          var addressPoints = %s
                                          var heat = L.heatLayer(addressPoints).addTo(map)           
                                        </script>", 
                                       data_json))  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Print a Summary
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  cat("\n[rCrimemap]: =======================================================\n")
  cat("[rCrimemap]: Summary of Crime Data Used and Leaflet Map\n")
  cat("[rCrimemap]: =======================================================\n\n")
  cat("Point of Interest           :", location, "\n")
  cat("Police Force(s)             :", police_nearest, "\n")
  cat("Period of Crime Records     :", period, "\n")
  cat("Type of Crime Records       :", type, "\n")
  cat("Total No. of Crime Records  :", dim(data_tbl)[1], "\n")
  cat("Map Resolution              :", map_size[1], "x", map_size[2], "\n")
  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Return Leaflet object
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  return(L2)
  
  
}