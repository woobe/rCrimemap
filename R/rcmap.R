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
#' provider: Base map service provider (e.g. "Nokia.normalDay", "OpenStreetMap.Mapnik") (see http://leaflet-extras.github.io/leaflet-providers/preview/index.html)
#' 
#' 
#' ## Example Usage:
#' 
#' rcmap()
#' 
#' rcmap("Newcastle", "2013-01", "All", c(1000,500), "Nokia.normalDay")
#' 
#' 
#' rcmap("London", "2011-08", "All", c(1000,500), "OpenStreetMap.Mapnik")

rcmap <- function(location = "London Eye", 
                  period = "2010-12",
                  type = "All",
                  map_size = c(1100, 700), 
                  provider = "Nokia.normalDay") {
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## References
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  ## https://github.com/ramnathv/rMaps
  ## http://data.police.uk
  ## http://leaflet-extras.github.io/leaflet-providers/preview/index.html
  ## http://leaflet.github.io/Leaflet.heat/dist/leaflet-heat.js
  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Download data (reformatted and stored in author's Bitbucket account)
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  ## Start timer
  time_start <- proc.time()
  
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
  cat("[rCrimemap]: Downloading '", period, ".rda' from author's Bitbucket account ... ", sep = "")
  con <- url(paste0("http://woobe.bitbucket.org/data/rCrimemap/", period, ".rda"))
  load(con)
  close(con)
  
  ## Stop timer
  time_stop <- proc.time()
  time_diff <- sum(time_stop - time_start)
  cat(round(time_diff, 2), "seconds.\n")
  time_total <- time_diff
  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Convert data frame into json
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  ## Start timer
  time_start <- proc.time()
  
  ## Display
  cat("[rCrimemap]: Converting raw data into JSON format for Leaflet ... ")
  
  ## Use ggmap::geocode to obtain lat and lon (not foolproof yet - need to improve this later)
  suppressMessages(latlon <- ggmap::geocode(paste0(location, " , United Kingdom")))
  
  ## Locate the nearest police service
  diff_latlon <- as.matrix(abs(crime_data$Latitude - latlon$lat) + abs(crime_data$Longitude - latlon$lon))
  diff_latlon[is.na(diff_latlon)] <- 999999
  police_force <- as.character(crime_data$Falls.within[which(diff_latlon == min(diff_latlon))])[1]
  
  ## Identify records of interest
  if (type == "All") {
    rows_samp <- which(crime_data$Falls.within == police_force)
  } else {
    rows_samp <- which(crime_data$Falls.within == police_force & crime_data$Crime.type == type)
  }
  
  ## Convert data
  data_tbl <- dplyr::group_by(crime_data[rows_samp,], Latitude, Longitude)
  data_count <- dplyr::summarise(data_tbl, n = length(LSOA.name))
  data_array <- rCharts::toJSONArray2(na.omit(data_count), json = F, names = F)
  data_json <- rjson::toJSON(data_array)
  
  ## Stop timer
  time_stop <- proc.time()
  time_diff <- sum(time_stop - time_start)
  cat(round(time_diff, 2), "seconds.\n")
  time_total <- time_total + time_diff
    
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Create Leaflet object with Heat Map
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  ## Start timer
  time_start <- proc.time()
  
  ## Display
  cat("[rCrimemap]: Creating Leaflet with Heat Map ... ")
  
  ## Create Leaflet
  L2 <- rMaps::Leaflet$new()
  L2$params$width <- map_size[1]
  L2$params$height <- map_size[2]
  L2$setView(c(latlon$lat, latlon$lon), 10)
  L2$tileLayer(provider = provider)   ## OpenStreetMap.Mapnik
  L2$marker(c(latlon$lat, latlon$lon), bindPopup = location)
  
  ## Add leaflet-heat plugin. Thanks to Vladimir Agafonkin
  L2$addAssets(jshead = c("http://leaflet.github.io/Leaflet.heat/dist/leaflet-heat.js"))
  
  ## Add javascript to modify underlying chart
  L2$setTemplate(afterScript = sprintf("<script>
                                          var addressPoints = %s
                                          var heat = L.heatLayer(addressPoints).addTo(map)           
                                        </script>", 
                                       data_json))
      
  ## Stop timer
  time_stop <- proc.time()
  time_diff <- sum(time_stop - time_start)
  cat(round(time_diff, 2), "seconds.\n")
  time_total <- time_total + time_diff
  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Print a Summary
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  cat("\n[rCrimemap]: =======================================================\n")
  cat("[rCrimemap]: Summary of Data Used\n")
  cat("[rCrimemap]: =======================================================\n\n")
  cat("Point of Interest           :", location, "\n")
  cat("Police Force                :", police_force, "\n")
  cat("Period of Crime Records     :", period, "\n")
  cat("Type of Crime Records       :", type, "\n")
  cat("Total No. of Crime Records  :", dim(data_tbl)[1], "\n")
  cat("Map Resolution              :", map_size[1], "x", map_size[2], "\n")
  cat("Duration                    :", round(time_total,2), "seconds.\n\n")
  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Return Leaflet object
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  return(L2)
  
  
}