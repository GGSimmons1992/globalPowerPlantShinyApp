library(shiny)
library(dplyr)
library(ggplot2)
library(leaflet)

function(input, output){
  powerplantCountry = reactive({
    powerplantbycountry = powerplants %>% filter(country_long == input$country_long)
  })
  
  powerplantCompany = reactive({
    powerplantbycompany = powerplants %>% filter(owner == input$owner)
  })
  
  output$tabName = input$tabselected
  
}