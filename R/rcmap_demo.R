#' rCrimemap demo scripts
#' 
#' ## Example Usage:
#' 
#' rcmap_demo(1)
#' 
#' rcmap_demo(2)

rcmap_demo <- function(num_demo = 1) 
  
  {
  
  ## Load Packages
  suppressMessages(library(rCharts))
  suppressMessages(library(rMaps))
  suppressMessages(library(ggmap))
  suppressMessages(library(rjson))
  
  ## Demo 1
  if (num_demo == 1) {
    all_year_month <- format(seq(as.Date("2011-01-01"), length=12, by="months"), "%Y-%m") 
    for (n_year_month in 1:12) {
      
      filename_output <- paste0(all_year_month[n_year_month], "-demo1-output.rda")
      
      m <- rcmap_quick(period = all_year_month[n_year_month],
                       map_size = c(800,800),
                       provider = "Nokia.normalDay",
                       zoom = 7)
      
      save(m, file = filename_output)
      
    }
  }
    
    ## Demo 2
    if (num_demo == 2) {
      all_year_month <- format(seq(as.Date("2011-01-01"), length=12, by="months"), "%Y-%m")
      for (n_year_month in 1:12) {
        
        filename_output <- paste0(all_year_month[n_year_month], "-demo2-output.rda")
        
        m <- rcmap_quick(period = all_year_month[n_year_month],
                         map_size = c(800,800),
                         map_center = "London SOHO",
                         provider = "Nokia.normalDay",
                         zoom = 14)
                
        save(m, file = filename_output)
        
      }
    }

}