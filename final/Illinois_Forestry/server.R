#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Ley libraries
library(shiny)
library(raster)
library(sp)
library(sf)
library(rgdal)
library(leaflet)
library(ggplot2)

# Importing Necessary Data, note that if other years were implemented data would be included

#cdl2018 <- raster("/Users/markbaker/Downloads/GEOG28602/final/2018_30m_cdls/2018_IL.tif")
#cdl2019 <- raster("/Users/markbaker/Downloads/GEOG28602/final/2019_30m_cdls/2019_IL.tif")
il <- st_read("/Users/markbaker/Downloads/GEOG28602/final/IL_BNDY_County/IL_BNDY_County_Py.shp")
il <- st_transform(il, "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")

# Function that selects the key area of interest and crops appropriately based on the 
# drop down menu that has been implemented

select_region <- function(name){
    c1819 <- raster("/Users/markbaker/Downloads/GEOG28602/final/change/c1819.tif")
    if(name == "OVERALL")
        return(c1819)
    else
        county <- il[il$COUNTY_NAM == name,]
        county_forest <- intersect(c1819, county)
        blank <- raster(county_forest)
        land_raster <- rasterize(county, blank)
        land_raster[!(is.na(land_raster))] <- 1
        land_raster[(is.na(land_raster))] <- 0
        land_raster <- county_forest * land_raster
        return(land_raster)
}

# Generated the Data table showing precent land cover which will be displayed 
# in the sidebar of the application
change_table <- function(raster) {
    freq_table <- freq(raster, digits=0, value=NULL)
    freq_table <- as.data.frame(freq_table)
    freq_table <- freq_table[(freq_table$value == 1| freq_table$value == 2 | 
                                  freq_table$value == 3 | freq_table$value == 4) ,]
    rfreq <- head(freq_table[freq_table$value == 4, ],1)$count
    dfreq <- head(freq_table[freq_table$value == 1, ],1)$count
    nfreq <- head(freq_table[freq_table$value == 2, ],1)$count
    other <- head(freq_table[freq_table$value == 3, ],1)$count
    forest_calc <- data.frame("Type" = c("Reforested", "Deforested", "No Change in Forest", "Other Land"),
                              "Value" = c(4,1,2, 3),
                              "Percent_Cover" = c(rfreq/ sum(head(freq_table, 4)$count) *100,
                                            dfreq/ sum(head(freq_table, 4)$count) *100,
                                            nfreq/ sum(head(freq_table, 4)$count) *100,
                                            other/ sum(head(freq_table, 4)$count) *100))
    forest_calc
}

# Similar to the function above, but instead of returning the percentage cover, 
# it returns the areas of these regions, which will be used for the bar chart
# on the main display
count_table <- function(raster) {
    freq_table <- freq(raster, digits=0, value=NULL)
    freq_table <- as.data.frame(freq_table)
    freq_table <- freq_table[(freq_table$value == 1| freq_table$value == 2 | 
                                  freq_table$value == 3 | freq_table$value == 4) ,]
    rfreq <- head(freq_table[freq_table$value == 4, ],1)$count
    dfreq <- head(freq_table[freq_table$value == 1, ],1)$count
    nfreq <- head(freq_table[freq_table$value == 2, ],1)$count
    other <- head(freq_table[freq_table$value == 3, ],1)$count
    forest_calc <- data.frame("Type" = c("Reforested", "Deforested", "No Change in Forest"),
                              "Value" = c(4,1, 2),
                              "Area" = c(rfreq*.9/1000, dfreq*.9/1000, nfreq*.9/1000))
    forest_calc
}

# Selecting the polygon of interest in order to properly preform the necessary crops for the
# IL shapefile , which will be used for Illinois representation in the map and for 
# the necessary raster cropping which takes place.
poly_select <- function(name){
    il <- st_read("/Users/markbaker/Downloads/GEOG28602/final/IL_BNDY_County/IL_BNDY_County_Py.shp")
    il <- st_transform(il, "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
    if(name == "OVERALL")
        return(il)
    else
        return(il[il$COUNTY_NAM == name,])
}

# Define server logic required to create the dash board
shinyServer(function(input, output) {
    
    # Generating the Display for Raster Data
    output$distPlot <- renderPlot({
        r <- select_region(input$county)
        values(r)[values(r) == 0] = NA
        plot(r,
             col = c('red','blue','white','green'),
             main="Forestry Cover in Illinois",
             legend = FALSE,
             axes=FALSE)
        plot(poly_select(input$county)$geometry, add=TRUE,
             axes=FALSE)
        legend("topright", legend = c("Deforested","No Change in Forest", "Other Land", "Reforested"),
               fill = c('red','blue','white','green'))
    })
    
    # Creating the bar chart for the dashboard
    output$change <- renderPlot({
        
        p<-ggplot(data=count_table(select_region(input$county)), aes(x=Type, y=Area)) +
            ggtitle("Forest Change in Square Kilometers") +
            geom_bar(stat="identity", fill="steelblue") +
            geom_text(aes(label=Area), vjust=-0.25) +
            theme_minimal()
        print(p)
        
    })
    
    # Plotting Il polygon with selected polygon of interest
    output$leafPlot <- renderLeaflet({
        leaflet(il) %>%
            addTiles() %>%
            addPolygons(opacity = .1) %>%
            #addRasterImage(c1819, opacity = 0.8) %>%
            addPolygons(data= poly_select(input$county), opacity = 1) 
            #addLegend(pal = pal, values = values(c1819), title = "Change Type")
    })
    
    #Creating Finalized data table
    output$data1 <- renderTable({
        head(change_table(select_region(input$county))[,-2])
    })

})
