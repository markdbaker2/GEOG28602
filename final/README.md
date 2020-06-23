About Me
========

I am a third year at the University of Chicago, majoring in
Computational and Applied Mathematics. Next year, I will be starting a
M.S. in Computer Science through the Physical Science Division at the
University of Chicago. I am interested in both Enviromental Systems and
Accessibilty. This project features Illinois Forestry Sector, examining
changes in land cover from 2018-2019.

Project Objectives
==================

Background Information
======================

In 2018, Illinois contained approximately 5 million acres of forest
land, accounting for approximately 61 percent of the native flora, 82
percent of the state’s mammals, 62 percent of the bird population, and
79 percent of the amphibian and reptile species (USDA Forest Service
2018). Additionally, forested areas have numerous environmental
regulatory services, which include maintaining air and water quality,
regulating atmospheric conditions, aiding pollination, retaining and
forming soil, and preventing invasive species (Jenkins and Schaap 2018;
Miura et al. 2015). However, it is important to note that of the 5
million acres composing Illinois forests, approximately 94 percent is
being utilized for timberland and around 83 percent of these forests are
privately owned (USDA Forest Service 2018). But besides the
environmental benefits associated with Illinois’s forestry sector,
forested areas greatly impact recreational activities as well. Based on
a 2008 Illinois Outdoor Recreation Survey, 80.6% of Illinois Residents
believe that more high quality, undisturbed land should be acquired and
protected by the state and 84.6% of residents believe that more wildlife
habitat should be protected and restored (Illinois Department of Natural
Resources 2009). Therefore, in order to ensure sustainable practices,
local and state governments take an active role in promoting
reforestation and incentivizing the uptake of forest management plans
(United States Department of Agriculture 2020). This project will
attempt to quantify the change in forestry cover overtime and promote
reforestation efforts by developing an interactive map highlighting the
changes in forest cover on county and state-level in Illinois. Using
this information, government officials and agencies will be able to
better allocate funds for incentivizing forest management places and
target key areas where reforestation efforts should be focused.

Data Overview
=============

For this project, I will be primarily using the Cropland Data Layer
(CDL) from the National Agricultural Statistics Service within the
United States Department of Agriculture, which is published yearly as a
GeoTIFF file. This dataset is a raster representation has a 30-meter
ground resolution and shows crop-specific land usage for the continental
United States. This dataset was generated using satellite imaging in
addition ancillary inputs, which supplement and improve the
classification process. The CDL file currently has approximately 90%
accuracy for 2019. Specifically, I am interested in using these raster
representations because they contain information about deciduous forest
(141 classification code), evergreen forest (142 classification code),
and mixed forest land coverage (143 classification code), all of which
will be the key focus of this research project. In particular, I will
utilize these classifications to quantify the changes in forest cover
(as deforested\*, no forestry change\*, and reforested\*) in Illinois
year over year from 2008 to 2019 (the years in which the data is
available) using raster algebra. Along with this data, I will also use
the county data layer file for Illinois to highlight changes in forestry
cover on a county level. The Illinois County Shapefile was obtained from
Illinois Geospatial Data Clearinghouse, which was last revised in 2003.
The shapefile contains the FIPS code in addition to the county name,
which will be utilized when developing the shiny application.

Data Sources
============

Data Processing
===============

Shiny Application (Figure 1 & 2)
================================

The created shiny interface include the following features:
Further Work
============

Although the sliders for the Start Year and End Year have been
implemented, the shiny app currently does not support changing the data
source years. Ideally, future work will allow for this implementation so
that when changing the slider, the data source changes so that the
dashboard can emphasize changes for user input year and export year. To
implement this, the data preprocessing protocal included must be
utilized on the CDL layers for 2008 - 2019.

References
----------

![Dashboard View examining Illinois’s Overall Forestry
Sector](visuals/Overall_DashboardView.png)

![Dashboard View examining Cook County’s Forestry
Sector](visuals/Cook_DashboardView.png)
