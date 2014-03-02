\name{rcmap}
\alias{rcmap}
\title{rCrimemap using uk crime data in Jan 2014 from data.police.uk}
\usage{
rcmap(location = "London Eye", map_size = c(1000, 500),
  provider = "Nokia.normalDay")
}
\description{
The next generation of CrimeMap based on rMaps
}
\details{
## Example Usage:

rcmap("London Eye", c(1000, 500), "Nokia.normalDay")

rcmap("Manchester", c(1920, 1080), "OpenStreetMap.Mapnik")
}

