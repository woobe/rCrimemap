\name{rcmap}
\alias{rcmap}
\title{rCrimemap using crime data from data.police.uk}
\usage{
rcmap(location = "Ball Brothers EC3R 7PP", period = "2010-12",
  type = "All", map_size = c(1000, 500), provider = "Nokia.normalDay",
  zoom = 10)
}
\description{
The next generation of CrimeMap based on rMaps!
}
\details{
Location: Location of interest within England and Wales
(e.g. London, Birmingham, Newcastle)

period: Specific month of interest between Dec 2010 and Jan
2014 in 'yyyy-mm' format (e.g. 2014-01)

type: Specific type of crime or all (e.g. "All",
"Anti-social behaviour", "Burglary", "Violent crime")

map_size: Resolution of the map (e.g. Full HD = c(1920 x
1080))

provider: Base map service provider (e.g.
"Nokia.normalDay", "MapQuestOpen.OSM", "Stamen.Watercolor")
(see
http://leaflet-extras.github.io/leaflet-providers/preview/index.html)

zoom: Zoom level of the map (default = 10)

## Example Usage:

rcmap()

rcmap("London", "2014-01", "All", c(1000,500),
"Nokia.normalDay")

rcmap("London", "2014-01", "All", c(1000,500),
"MapQuestOpen.OSM")

rcmap("London", "2014-01", "Anti-social behaviour",
c(1000,500), "Nokia.normalDay")

rcmap("Manchester", "2014-01", "All", c(1000,500),
"MapQuestOpen.OSM")

rcmap("Liverpool", "2014-01", "All", c(1000,500),
"MapQuestOpen.OSM")
}

