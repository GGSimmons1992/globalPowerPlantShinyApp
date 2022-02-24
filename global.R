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