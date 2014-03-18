#' rCrimemap using reformatted JSON data - a faster version of rcmap()
#' 
#' 
#' ## Example Usage:
#' 
#' m_quick <- rcmap_quick()
#' m_quick
#' 

rcmap_quick <- function(period = "2010-12",                  ## reformatted data from 2010-12 to 2014-01
                        map_size = c(800, 800),              ## resolution of map
                        map_center = "Lichfield",            ## adjust center of the map, Lichfield is approx. center of England & Wales
                        provider = "Nokia.normalDay",        ## base map provider
                        zoom = 7,                            ## start from 7
                        marker = NULL)                       ## no marker unless specified
{
    
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
  
  ## Download reformatted JSON data directly from Bitbucket
  cat("[rCrimemap]: Downloading '", period, "-json.rda' from author's Bitbucket account ...\n", sep = "")
  con <- url(paste0("http://woobe.bitbucket.org/data/rCrimemap/", period, "-json.rda"))
  load(con)
  close(con)
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Create Leaflet object with Heat Map
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  ## Display
  cat("[rCrimemap]: Creating Leaflet with Heat Map ...\n")
  
  ## Approx. centroid
  suppressMessages(latlon <- geocode(paste0(map_center, ", UK")))
  
  ## Create Leaflet
  L2 <- rMaps::Leaflet$new()
  L2$params$width <- map_size[1]
  L2$params$height <- map_size[2]
  L2$setView(c(latlon$lat, latlon$lon), zoom)
  L2$tileLayer(provider = provider)   ## OpenStreetMap.Mapnik
  
  ## Set Marker
  if (!is.null(marker)) {
    suppressMessages(latlon <- geocode(paste(marker, ", UK")))
    L2$marker(c(latlon$lat, latlon$lon), bindPopup = marker)
  }
  
  ## Add leaflet-heat plugin. Thanks to Vladimir Agafonkin
  L2$addAssets(jshead = c("http://leaflet.github.io/Leaflet.heat/dist/leaflet-heat.js"))
  
  ## Add javascript to modify underlying chart
  L2$setTemplate(afterScript = sprintf("<script>
                                          var addressPoints = %s
                                          var heat = L.heatLayer(addressPoints).addTo(map)           
                                        </script>", 
                                       data_json))  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Return Leaflet object
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  return(L2)
  
  
}