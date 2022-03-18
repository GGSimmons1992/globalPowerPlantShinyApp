library(shiny)
library(dplyr)
library(ggplot2)
library(leaflet)

function(input, output){
  
  retrievePowerplantType = reactive({
    powerplantbytype = powerplants %>% 
      filter(primary_fuel == input$type)
  })
  
  retrievePowerplantCountryFuel = reactive({
    powerplantbycountry = powerplants %>% 
      filter(country_long == input$country_long)
    powerplantsCountryFuel = powerplantbycountry %>% group_by(primary_fuel)
  })
  
  retrievePowerplantCountryFuelYear = reactive({
    powerplantsCountryFuel = retrievePowerplantCountryFuel()
    powerplantsCountryFuelYear = powerplantsCountryFuel %>% 
      summarise(energy2013 = 0.5* (sum(generation_gwh_2013) + 
                                     sum(estimated_generation_gwh_2013)),
                energy2014 = 0.5* (sum(generation_gwh_2014) + 
                                     sum(estimated_generation_gwh_2014)),
                energy2015 = 0.5* (sum(generation_gwh_2015) + 
                                     sum(estimated_generation_gwh_2015)),
                energy2016 = 0.5* (sum(generation_gwh_2016) + 
                                     sum(estimated_generation_gwh_2016)),
                energy2017 = 0.5* (sum(generation_gwh_2017) + 
                                     sum(estimated_generation_gwh_2017)),
    )
      
  })
  
  retrievePowerplantTotalEnergy = reactive({
    retrievePowerplantCountryFuelYear() %>% 
      mutate(total =energy2013+ energy2014 + energy2015 + energy2016 + 
               energy2017)
  })
  
  retrievePowerplantDataLong = reactive({
    powerplantsCountryFuelYear = retrievePowerplantCountryFuelYear()
    powerplantsCountryFuelYearDF = as.data.frame(powerplantsCountryFuelYear)
    powerplantsCountryFuelYearLabeled = powerplantsCountryFuelYearDF[,-1]
    row.names(powerplantsCountryFuelYearLabeled) = powerplantsCountryFuelYearDF[,1]
    transposePowerplantsCountryFuelYear = transpose(powerplantsCountryFuelYearLabeled)
    colnames(transposePowerplantsCountryFuelYear) = powerplantsCountryFuelYearDF[,1]
    transposePowerplantsCountryFuelYear$Year = c(2013,2014,2015,2016,2017)
    data_long= melt(transposePowerplantsCountryFuelYear, id="Year")
    colnames(data_long) = c("Year","primary_fuel","energy")
    data_long = data_long %>% filter(energy > 0)
  })
  
  retrieveNumberOfPlantsPerType = reactive({
    numberOfPlantsPerType = retrievePowerplantCountryFuel() %>% summarize(number = n())
  })
  
  output$map = renderLeaflet({
    retrievePowerplantType() %>%  
    leaflet() %>%
    addTiles() %>% 
    addMarkers(~longitude,~latitude,popup= ~primary_fuel,label= ~country_long,
               clusterOptions = markerClusterOptions())
  })
  
  output$totalEnergy = renderPlot({
    retrievePowerplantTotalEnergy() %>%
      ggplot(mapping=aes(x=reorder(primary_fuel,total),
                             y=total,fill=primary_fuel)) + 
      geom_bar(stat="identity") + coord_flip() + 
      scale_y_continuous(trans= 'log10', 
                         labels = trans_format('log10',math_format(10^.x))) + 
      theme(axis.text.x = element_text(angle=90)) + 
      ylab("Energy Accumulated MWH") + xlab("Primary Fuel") + 
      ggtitle("Energy Accumulated between 2013-2017")
  })
  output$time = renderPlotly({
    retrievePowerplantDataLong() %>% 
      plot_ly(x=~Year,y=~energy, color= ~primary_fuel,
              mode="lines") %>%
      layout(title="Energy Produced over the Years per Type",
             xaxis=list(title = "Year",
                        zeroline = FALSE),
             yaxis=list(title = "Energy Produced MWH",
                        zeroline = TRUE,
                        type='log')
             )
  })
  output$numberOfPlants = renderPlot({
      retrieveNumberOfPlantsPerType() %>% 
      ggplot(mapping=aes(x=reorder(primary_fuel,number), 
                 y=number,fill=primary_fuel)) + 
      geom_bar(stat="identity") + theme(axis.text.x = element_text(angle=90)) +
      coord_flip() + 
      scale_y_continuous(trans= 'log10', labels = 
                           trans_format('log10',math_format(10^.x))) + 
      xlab("Primary Fuel") + ylab("Number of Plants") +
      ggtitle("Number of Plants per Type")
  })
}