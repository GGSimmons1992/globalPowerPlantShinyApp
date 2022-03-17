library(dplyr)
library(data.table)
library(ggplot2)
library(ggmap)
library(RColorBrewer)
library(leaflet)
library(scales)
library(plotly)

powerplants=read.csv('global_power_plant_database.csv')
powerplants[is.na(powerplants)] = 0
powerplants = powerplants %>% filter(
  (
     generation_gwh_2013 + estimated_generation_gwh_2013 +
     generation_gwh_2014 + estimated_generation_gwh_2014 +
     generation_gwh_2015 + estimated_generation_gwh_2015 +
     generation_gwh_2016 + estimated_generation_gwh_2016 +
     generation_gwh_2017 + estimated_generation_gwh_2017
  ) > 0
  
)
