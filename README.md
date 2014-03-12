rCrimemap
=========

## This is the next generation of CrimeMap!


### Prerequisites

```
require(devtools)
install.packages(c("base64enc", "ggmap", "rjson", "dplyr"))
install_github('ramnathv/rCharts@dev')
install_github('ramnathv/rMaps')
```
## You also need RStudio IDE version 0.98.501 or newer.


### Install rCrimemap

```
install_github('woobe/rCrimemap')
```

### LondonR Demo 1
```
rcmap("Ball Brothers EC3R 7PP", "2011-08", "All", c(1000,1000),"Nokia.normalDay")
```
![ball](http://woobe.bitbucket.org/images/github/ball_brothers_animation.gif)  

### LondonR Demo 2
```
rcmap("Manchester", "2014-01", "All", c(1000,1000), "MapQuestOpen.OSM")
```
![ball](http://woobe.bitbucket.org/images/github/manchester_animation.gif)  


### Credits

* [rMaps by Ramnath Vaidyanathan](https://github.com/ramnathv/rMaps)
* [Leaflet Heat Maps](http://rmaps.github.io/blog/posts/leaflet-heat-maps/index.html)