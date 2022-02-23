library(shiny)
library(dplyr)
library(ggplot2)
library(leaflet)

function(input, output){
  powerplantCountry = reactive({
    powerplantbycountry = powerplants %>% filter(country_long == input$country_long)
  })
  powerplantType = reactive({
    powerplantbytype = powerplants %>% filter(primary_fuel == input$type)
  })
  output$map = renderLeaflet({
    powerplantType() %>%  
    leaflet() %>%
    addTiles() %>% 
    addMarkers(~longitude,~latitude,popup= ~primary_fuel,label= ~name)
  })
  
}