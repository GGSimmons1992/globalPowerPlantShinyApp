library(shinydashboard)

dashboardPage(
  dashboardHeader(title="Global Power Plant Shiny App"),
  dashboardSidebar(
    sidebarUserPanel("GGSimmons1992",image="GGS_GK.jpeg"),
    sidebarMenu(
      radioButtons(
        inputId="tabselected",label="View by",
        choices=c("Country","Company")
      )
    ),
    conditionalPanel(condition = output$tabName == "Country",
                     selectizeInput(inputId="country_long",
                                    label='country',
                                    choice= unique(powerplants$country_long))
                     ),
    conditionalPanel(condition = output$tabName == "Company",
                     selectizeInput(inputId="owner",
                                    label='company',
                                    choice= unique(powerplants$owner))
    )
    
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName='Country'),
      tabItem(tabName = "Company")
    )
  )
)