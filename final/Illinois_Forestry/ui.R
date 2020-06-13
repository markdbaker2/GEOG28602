#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Importing Key Libraries
library(shiny)
library(raster)
library(sp)
library(sf)
library(rgdal)
library(leaflet)
library(ggplot2)
library(rasterVis)

# Reading In IL Shapefile, setting geometry to Null and then selecting county names for drop down interface.
il <- st_read("/Users/markbaker/Downloads/GEOG28602/final/IL_BNDY_County/IL_BNDY_County_Py.shp")
st_geometry(il) <- NULL
counties <- c("OVERALL", sort(as.vector(il$COUNTY_NAM)))

# Define UI for application
shinyUI(fluidPage(

    # Application title
    titlePanel("Illinois Forestry Sector Dashboard"),

    # Sidebar Layout
    sidebarLayout(
        sidebarPanel(
            # Start Year Slider - Not Fully Implemented
            sliderInput("y1",
                        "Start Year",
                        min = 2008,
                        max = 2019,
                        value = 2018,
                        sep = ""),
            # End Year Slider - Not Fully Implemented
            sliderInput("y2",
                        "End Year",
                        min = 2008,
                        max = 2019,
                        value = 2019,
                        sep = ""),
            # Drop down menu to change area of Interest
            selectInput("county", "Forested Area of Interest:", choices = counties),
            # Percentage Land Cover Data Table 
            tableOutput("data1"),
            #Polygn selected of Illinois
            leafletOutput("leafPlot")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            # Raster Data for land usage
            plotOutput("distPlot"),
            # Table highlight area of change
            plotOutput("change")
        )
    )
))
