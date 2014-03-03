\name{rcmap}
\alias{rcmap}
\title{rCrimemap using crime data from data.police.uk}
\usage{
rcmap(location = "London Eye", period = "2010-12", type = "All",
  map_size = c(1920, 1080), provider = "Nokia.normalDay")
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
"Nokia.normalDay", "OpenStreetMap.Mapnik") (see
http://leaflet-extras.github.io/leaflet-providers/preview/index.html)

## Example Usage:

rcmap()

rcmap("Newcastle", "2013-01", "All", c(1000,500),
"Nokia.normalDay")

rcmap("London", "2011-08", "All", c(1000,500),
"OpenStreetMap.Mapnik")
}

