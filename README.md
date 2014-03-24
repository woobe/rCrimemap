rCrimemap: The Next Generation of CrimeMap
=========

- Note that **rCrimemap** is still raw and experimental. Check out my blog [**"Blend It Like a Bayesian!"**](http://bit.ly/blenditbayes) for latest updates. 
- See my [**LondonR presentation**](http://bit.ly/londonr_crimemap) for the history and motivation behind developing **'CrimeMap'** and **rCrimemap**.

------

## Introduction 

*(based on my useR! conference abstract)*  

The maturality and extensive graphical abilities of *R* and its packages make *R* an excellent choice for professional data visualisation. Previous work has shown that it is possible to combine the functionality in packages **ggmap**, **ggplot2**, **shiny** and **shinyapps** for crime data visualization in the form of a web application named **'CrimeMap'** ([Chow, 2013](http://bit.ly/bib_crimemap)). The web application is user-friendly and highly customizable. It allows users to create and customize spatial visualization in a few clicks without prior knowledge in *R* (see screenshot below). Moreover, **shiny** automatcially adjusts the layout of **'CrimeMap'**  for best viewing experience on desktop computers, tablets and smartphones.

<center>![ball](http://woobe.bitbucket.org/images/github/milestone_2013_11.jpg)</center>

Following the release of **rCharts** ([Vaidyanathan, 2013](http://rcharts.io/))and **rMaps** ([Vaidyanathan, 2014](https://github.com/ramnathv/rMaps)), Chow built upon the original **'CrimeMap'** and created a new package **rCrimemap** ([Chow, 2014](http://bit.ly/rCrimemap)). Leveraging the power of *JavaScript* mapping libraries such as 'leaflet' via **rMaps**, **rCrimemap** allows users to create an interactive crime map in *R* with intuitive map controls using only one line of code. Both zooming and navigation are similar to what ones would expect from using a typical digital map (see screenshots below).  

<center><img src="http://3.bp.blogspot.com/-TAJdmlqeIfE/Uyw6_eq1fCI/AAAAAAAAAfY/B9fCjp_GtLI/s1600/rCrimemap_test.gif"></center>

The availability of these packages means *R* developers can now easily overlay both graphcial and numerical results from complex statistical analysis with maps to create professional and insightful spatial visualization. This is particularly useful for effective communication and decision making.  

------

## Prerequisites

You will need the following packages and **[RStudio IDE version 0.98.501 (or newer)](http://www.rstudio.com/ide/download/)**.

```
require(devtools)
install.packages(c("base64enc", "ggmap", "rjson", "plyr", "dplyr"))
install_github('ramnathv/rCharts@dev')
install_github('ramnathv/rMaps')
```


## Install rCrimemap

```
install_github('woobe/rCrimemap')
```

------

## Credits

* [rMaps by Ramnath Vaidyanathan](https://github.com/ramnathv/rMaps)
* [Leaflet Heat Maps](http://rmaps.github.io/blog/posts/leaflet-heat-maps/index.html)

------

## Changes

Version | Release Date | Comments
-------|-------|-------
0.0.1 | 11/03/2014 | Prototype for [LondonR Demo](http://bit.ly/londonr_crimemap). Raw and experimental.
0.0.2 | 14/03/2014 | Using **plyr::ddply** instead of **dplyr::summarise** for one step (**dplyr::group_by** is unstable for multiple columns at the moment). As a result, it is slower but stable.
0.0.3 | 18/03/2014 | Added function 'rcmap_quick()' for quicker map generation using reformatted JSON data of **ALL crimes**. Support period from 2010-12 to 2011-12 (I will continue to convert the rest and make them available in next version).
0.0.3 | 24/03/2014 | Not a package update. All reformatted crime data (2010-12 to 2014-01) in JSON format has been uploaded to Bitbucket. Use **rcmap_quick()** function to take advantages of these datasets. 

------

## Using 'rcmap_quick()' to create self-contained interactive crime map!

Create an interactive crime map of ALL CRIMES using the function **rcmap_quick()**.  

```
m_quick <- rcmap_quick(period = "2014-01", map_size = c(1900, 1060), 
                       provider = "Nokia.normalDay", zoom = 7)
                       
[rCrimemap]: Downloading '2014-01-json.rda' from author's Bitbucket account ...
[rCrimemap]: Creating Leaflet with Heat Map ...
```

```
## Display the map in RStudio
m_quick
```

```
## Create a self-contained crime map
m_quick$save('mymap.html', cdn = TRUE)
```

### Rendered Self-Contained HTML Examples:

1. rCrimemap (2014-01, 1900 x 1060) [Link](http://bit.ly/1jbmINy)
2. rCrimemap (2014-01, 940 x 620) [Link](http://bit.ly/1jbn8DR)


------
  
## Using 'rcmap()'

### Note: This was my first attempt. The wrapper uses 'plyr' instead of 'dplyr' so it can be really slow. Try rcmap_quick() first :)

You can create interactive crime map using the function **rcmap()**. The function has the following arguments:  

```
rcmap(location = "Ball Brothers EC3R 7PP", ## LondonR venue since 2013
      period = "2010-12",                  ## reformatted data from 2010-12 to 2014-01
      type = "All",                        ## type of crimes
      map_size = c(1000, 500),             ## resolution of map in pixel
      provider = "Nokia.normalDay",        ## base map provider
      zoom = 10)                           ## zoom level
```

## LondonR Demo 1

```
library(rCrimemap)
m1 <- rcmap("Ball Brothers EC3R 7PP", "2011-08", "All", c(1000,1000),"Nokia.normalDay")
m1
```

### Text Output:
```
[rCrimemap]: Downloading '2011-08.rda' from author's Bitbucket account ...
[rCrimemap]: Converting raw data into JSON format for Leaflet ...
[rCrimemap]: Creating Leaflet with Heat Map ...

[rCrimemap]: Summary of Crime Data Used and Leaflet Map ...

Point of Interest           : Ball Brothers EC3R 7PP 
Nearest Police Force(s)     : City of London Police Metropolitan Police Service 
Period of Crime Records     : 2011-08 
Type of Crime Records       : All 
Total No. of Crime Records  : 109653 
Map Resolution              : 1000 x 1000
```

### Interactive Map Output in RStudioIDE:

**Note**: use the export to browser button (top left of map) to view the map in a browser.  

<center><img src="http://woobe.bitbucket.org/images/github/rCrimemap_RStudioIDE.jpg"></center>


### Zooming:
<center><img src="http://woobe.bitbucket.org/images/github/ball_brothers_animation.gif"></center>
  


## Enjoy!

All feedback and suggestions are welcome!
