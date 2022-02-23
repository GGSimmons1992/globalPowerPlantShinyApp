library(shinydashboard)

dashboardPage(
  dashboardHeader(title="Global Power Plant Shiny App"),
  dashboardSidebar(
    sidebarUserPanel("GGSimmons1992",image="GGS_GK.jpeg"),
    sidebarMenu(
      menuItem("Country energy info",tabName = "Country", icon=icon("flag")),
      menuItem("Selected Fuel Type Locations",
               tabName = "Type",
               icon=icon("map"))
    )
    
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "Type",
              selectizeInput(inputId="type",
                             label='fuel type',
                             choice= unique(powerplants$primary_fuel)),
              fluidRow(
                leafletOutput("map")
              )
      ),
      tabItem(tabName='Country',
              selectizeInput(inputId="country_long",
                                    label='country',
                                    choice= unique(powerplants$country_long))
      
      )
    )
  )
)