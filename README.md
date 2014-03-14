rCrimemap
=========

## This is the next generation of CrimeMap!


### Prerequisites

```
require(devtools)
install.packages(c("base64enc", "ggmap", "rjson", "plyr", "dplyr"))
install_github('ramnathv/rCharts@dev')
install_github('ramnathv/rMaps')
```

**You also need RStudio IDE version 0.98.501 or newer.**


### Install rCrimemap

```
install_github('woobe/rCrimemap')
```

### Credits

* [rMaps by Ramnath Vaidyanathan](https://github.com/ramnathv/rMaps)
* [Leaflet Heat Maps](http://rmaps.github.io/blog/posts/leaflet-heat-maps/index.html)


### Changes

Version | Release Date | Comments
-------|-------|-------
0.01 | 11-Mar-2014 | Prototype for [LondonR Demo](http://bit.ly/londonr_crimemap). Raw and experimental.
0.02 | 14-Mar-2014 | Using plyr::ddply instead of dplyr::summarise for one step (dplyr::group_by is unstable for multiple columns at the moment). As a result, it is slower but stable.


### Usage Examples

#### LondonR Demo 1
```
rcmap("Ball Brothers EC3R 7PP", "2011-08", "All", c(1000,1000),"Nokia.normalDay")
```
![ball](http://woobe.bitbucket.org/images/github/ball_brothers_animation.gif)  

#### LondonR Demo 2
```
rcmap("Manchester", "2014-01", "All", c(1000,1000), "MapQuestOpen.OSM")
```
![ball](http://woobe.bitbucket.org/images/github/manchester_animation.gif)  

