library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(readxl)
library(ggplot2)
library(psych)
library(DT)
library(dplyr)
library(leaflet)
library(tmap)
library(sf)

#df <- read_excel('SDR-2022-database.xlsx', sheet = "SDR2022 Data")
df <- read_excel('gds fix.xlsx')
index <- 'df$Country'

#ts <- read_excel('SDR-2022-database.xlsx', sheet = "Backdated SDG Index")
ts<-read_excel('timeseries fix.xlsx')
ranked<-df[order(df$`2022 SDG Index Score`, decreasing = TRUE), ]



ui<-dashboardPage(
  skin='blue',
  dashboardHeader(title = "SDGs 2022"
                  ),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview SDG", 
               tabName = "SDG",
               badgeLabel = "info",
               badgeColor="green"
               )
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "SDG",
              fluidRow(
                h1(strong("Sustainable Development Goals Scored Dashboard"), style="text-align: center;font-family: Plus Jakarta Sans;"),
                box(
                  selectInput("Negara", "Pilih Negara:",
                              c(df$Country)), width = 12 
                ),
                box(title=h4(strong('Overview')),
                    width=12,
                    infoBoxOutput(outputId = "SDG",
                                  width=4),
                    infoBoxOutput(outputId = "Rank",
                                  width=4),
                    infoBoxOutput(outputId = "Reg",
                                  width = 4)),
                
                box(plotOutput("rangkuman_indonesia"), width = 6),
                
                box(plotOutput("index"),width = 6),
                
                
                box(dataTableOutput("rank"), width=12)
                )),
      tabItem(tabName = "report",
              h2(strong("What Is SDGs ?"),style="text-align:center"),
              column(
                width=12,
                align="center"
                
              ),
              
              p(style="text-align: center; font-size = 40px","SDGs stands for Sustainable Development Goals. They are a set of 17 global goals adopted by the United Nations in 2015 as part of the 2030 Agenda for Sustainable Development. The SDGs are intended to be a blueprint for achieving a better and more sustainable future for all people and the planet.
                The SDGs cover a wide range of issues, including poverty, hunger, health, education, climate change, gender equality, water, sanitation, energy, the environment, and social justice. They are designed to be integrated and indivisible, meaning that they are interconnected and must be addressed together in order to achieve sustainable development."
                ),
              h2(strong(" 17 Suistanable Development Goals"),style="text-align:center"),
              column(
                width=6,
                align="center",
                #"C:\Users\Syahrul Maulana W\Documents\sdgs.png"
                
                ),
             
              p(style="text-align: left; font-size = 40px","17 Sustainable Development Goals (SDGs) that were adopted by the United Nations in 2015 as part of the 2030 Agenda for Sustainable Development. These goals are:   No Poverty Zero Hunger Good Health and Well-Being Quality Education Gender Equality  Clean Water and Sanitation Affordable and Clean Energy Decent Work and Economic Growth Industry, Innovation and Infrastructure Reduced Inequalities  Sustainable Cities and Communities Responsible Consumption and Production Climate Action  Life Below Water Life On Land  Peace, Justice and Strong Institutions  Partnerships for the Goals  Each of these goals has specific targets that define what needs to be achieved in order to achieve the goal. For example, Goal 1 is to End poverty in all its forms everywhere. The targets for this goal include reducing the percentage of people living in extreme poverty, increasing the employment rate, and increasing access to financial services."
                ),
              p("kakaka \n akakaka")
    
      ),
      #coding untuk map  
      tabItem(tabName = "map",
              box(leafletOutput("leafletMap"),
                  width=12)
              
              
              
              )
    )
  )
)
  
  

#pendefinisian kolom mana saja yang akan dipakai
server <- function(input, output){
  
  showNotification("Dashboard project by @syahrulmwijaya", duration = 5, type = "message")
  ## ini untuk output plot dengan nama rangkuman_indonesia
  output$rangkuman_indonesia <- renderPlot({
    
    indonesia <- c(df$`Goal 1 Score`[df$Country == input$Negara],
                   df$`Goal 2 Score`[df$Country == input$Negara],
                   df$`Goal 3 Score`[df$Country == input$Negara],
                   df$`Goal 4 Score`[df$Country == input$Negara],
                   df$`Goal 5 Score`[df$Country == input$Negara],
                   df$`Goal 6 Score`[df$Country == input$Negara],
                   df$`Goal 7 Score`[df$Country == input$Negara],
                   df$`Goal 8 Score`[df$Country == input$Negara],
                   df$`Goal 9 Score`[df$Country == input$Negara],
                   df$`Goal 10 Score`[df$Country == input$Negara],
                   df$`Goal 11 Score`[df$Country == input$Negara],
                   df$`Goal 12 Score`[df$Country == input$Negara],
                   df$`Goal 13 Score`[df$Country == input$Negara],
                   df$`Goal 14 Score`[df$Country == input$Negara],
                   df$`Goal 15 Score`[df$Country == input$Negara],
                   df$`Goal 16 Score`[df$Country == input$Negara],
                   df$`Goal 17 Score`[df$Country == input$Negara]
                   )
    
    nama_bar <- c("SDG 1",
                  "SDG 2",
                  "SDG 3",
                  "SDG 4",
                  "SDG 5",
                  "SDG 6",
                  "SDG 7",
                  "SDG 8",
                  "SDG 9",
                  "SDG 10",
                  "SDG 11",
                  "SDG 12",
                  "SDG 13",
                  "SDG 14",
                  "SDG 15",
                  "SDG 16",
                  "SDG 17"
                  )
    
    #variabel warna 
    
    warna <- c(ifelse(df$`Goal 1 Score`[df$Country == input$Negara] > 50, "green", 
                    ifelse(df$`Goal 1 Score`[df$Country == input$Negara] > 40, "yellow", 
                           ifelse(df$`Goal 1 Score`[df$Country == input$Negara] > 30, "orange", 
                                  ifelse(df$`Goal 1 Score`[df$Country == input$Negara] > 20, "red", 
                                         "grey")))),
               
               ifelse(df$`Goal 2 Score`[df$Country == input$Negara] > 50, "green", 
                      ifelse(df$`Goal 2 Score`[df$Country == input$Negara] > 40, "yellow", 
                             ifelse(df$`Goal 2 Score`[df$Country == input$Negara] > 30, "orange", 
                                    ifelse(df$`Goal 2 Score`[df$Country == input$Negara] > 20, "red", 
                                           "grey")))),
               
               ifelse(df$`Goal 3 Score`[df$Country == input$Negara] > 50, "green", 
                      ifelse(df$`Goal 3 Score`[df$Country == input$Negara] > 40, "yellow", 
                             ifelse(df$`Goal 3 Score`[df$Country == input$Negara] > 30, "orange", 
                                    ifelse(df$`Goal 3 Score`[df$Country == input$Negara] > 20, "red", 
                                           "grey")))),
               
               ifelse(df$`Goal 4 Score`[df$Country == input$Negara] > 50, "green", 
                      ifelse(df$`Goal 4 Score`[df$Country == input$Negara] > 40, "yellow", 
                             ifelse(df$`Goal 4 Score`[df$Country == input$Negara] > 30, "orange", 
                                    ifelse(df$`Goal 4 Score`[df$Country == input$Negara] > 20, "red", 
                                           "grey")))),
               
               ifelse(df$`Goal 5 Score`[df$Country == input$Negara] > 50, "green", 
                      ifelse(df$`Goal 5 Score`[df$Country == input$Negara] > 40, "yellow", 
                             ifelse(df$`Goal 5 Score`[df$Country == input$Negara] > 30, "orange", 
                                    ifelse(df$`Goal 5 Score`[df$Country == input$Negara] > 20, "red", 
                                           "grey")))),
               
               ifelse(df$`Goal 6 Score`[df$Country == input$Negara] > 50, "green", 
                      ifelse(df$`Goal 6 Score`[df$Country == input$Negara] > 40, "yellow", 
                             ifelse(df$`Goal 6 Score`[df$Country == input$Negara] > 30, "orange", 
                                    ifelse(df$`Goal 6 Score`[df$Country == input$Negara] > 20, "red", 
                                           "grey")))),
               
               ifelse(df$`Goal 7 Score`[df$Country == input$Negara] > 50, "green", 
                      ifelse(df$`Goal 7 Score`[df$Country == input$Negara] > 40, "yellow", 
                             ifelse(df$`Goal 7 Score`[df$Country == input$Negara] > 30, "orange", 
                                    ifelse(df$`Goal 7 Score`[df$Country == input$Negara] > 20, "red", 
                                           "grey")))),
               
               ifelse(df$`Goal 8 Score`[df$Country == input$Negara] > 50, "green", 
                      ifelse(df$`Goal 8 Score`[df$Country == input$Negara] > 40, "yellow", 
                             ifelse(df$`Goal 8 Score`[df$Country == input$Negara] > 30, "orange", 
                                    ifelse(df$`Goal 8 Score`[df$Country == input$Negara] > 20, "red", 
                                           "grey")))),
               
               ifelse(df$`Goal 9 Score`[df$Country == input$Negara] > 50, "green", 
                      ifelse(df$`Goal 9 Score`[df$Country == input$Negara] > 40, "yellow", 
                             ifelse(df$`Goal 9 Score`[df$Country == input$Negara] > 30, "orange", 
                                    ifelse(df$`Goal 9 Score`[df$Country == input$Negara] > 20, "red", 
                                           "grey")))),
               
               ifelse(df$`Goal 10 Score`[df$Country == input$Negara] > 50, "green", 
                      ifelse(df$`Goal 10 Score`[df$Country == input$Negara] > 40, "yellow", 
                             ifelse(df$`Goal 10 Score`[df$Country == input$Negara] > 30, "orange", 
                                    ifelse(df$`Goal 10 Score`[df$Country == input$Negara] > 20, "red", 
                                           "grey")))),
               
               ifelse(df$`Goal 11 Score`[df$Country == input$Negara] > 50, "green", 
                      ifelse(df$`Goal 11 Score`[df$Country == input$Negara] > 40, "yellow", 
                             ifelse(df$`Goal 11 Score`[df$Country == input$Negara] > 30, "orange", 
                                    ifelse(df$`Goal 11 Score`[df$Country == input$Negara] > 20, "red", 
                                           "grey")))),
               
               ifelse(df$`Goal 12 Score`[df$Country == input$Negara] > 50, "green", 
                      ifelse(df$`Goal 12 Score`[df$Country == input$Negara] > 40, "yellow", 
                             ifelse(df$`Goal 12 Score`[df$Country == input$Negara] > 30, "orange", 
                                    ifelse(df$`Goal 12 Score`[df$Country == input$Negara] > 20, "red", 
                                           "grey")))),
               
               ifelse(df$`Goal 13 Score`[df$Country == input$Negara] > 50, "green", 
                      ifelse(df$`Goal 13 Score`[df$Country == input$Negara] > 40, "yellow", 
                             ifelse(df$`Goal 13 Score`[df$Country == input$Negara] > 30, "orange", 
                                    ifelse(df$`Goal 13 Score`[df$Country == input$Negara] > 20, "red", 
                                           "grey")))),
               
               ifelse(df$`Goal 14 Score`[df$Country == input$Negara] > 50, "green", 
                      ifelse(df$`Goal 14 Score`[df$Country == input$Negara] > 40, "yellow", 
                             ifelse(df$`Goal 14 Score`[df$Country == input$Negara] > 30, "orange", 
                                    ifelse(df$`Goal 14 Score`[df$Country == input$Negara] > 20, "red", 
                                           "grey")))),
               
               ifelse(df$`Goal 15 Score`[df$Country == input$Negara] > 50, "green", 
                      ifelse(df$`Goal 15 Score`[df$Country == input$Negara] > 40, "yellow", 
                             ifelse(df$`Goal 15 Score`[df$Country == input$Negara] > 30, "orange", 
                                    ifelse(df$`Goal 15 Score`[df$Country == input$Negara] > 20, "red", 
                                           "grey")))),
               
               ifelse(df$`Goal 16 Score`[df$Country == input$Negara] > 50, "green", 
                      ifelse(df$`Goal 16 Score`[df$Country == input$Negara] > 40, "yellow", 
                             ifelse(df$`Goal 16 Score`[df$Country == input$Negara] > 30, "orange", 
                                    ifelse(df$`Goal 16 Score`[df$Country == input$Negara] > 20, "red", 
                                           "grey")))),
               
               ifelse(df$`Goal 17 Score`[df$Country == input$Negara] > 50, "green", 
                      ifelse(df$`Goal 17 Score`[df$Country == input$Negara] > 40, "yellow", 
                             ifelse(df$`Goal 17 Score`[df$Country == input$Negara] > 30, "orange", 
                                    ifelse(df$`Goal 17 Score`[df$Country == input$Negara] > 20, "red", 
                                           "grey"))))
               
              )
                    
    
    barplot(indonesia, names.arg = nama_bar, col = warna,xlab="SDGs", ylab="Nilai", main="Score pada tiap SDGs")
  })
  
  output$index <- renderPlot({
    data<- ts$`SDG Index Score`[ts$Country == input$Negara]
    #plot(ts$`Year`[ts$Country == input$Negara], ts$`SDG Index Score`[ts$Country == input$Negara], type='l',main='line plot', col='blue')
    plot(ts$`Year`[ts$Country == input$Negara], ts$`SDG Index Score`[ts$Country == input$Negara], type='l',main='SDGs score dari tahun ke tahun', col='blue', xlab='tahun', ylab='SDG Index', lty=2)
    #ggplot(data = ts$`SDG Index Score`[ts$Country == input$Negara], aes(x='Year', y='SDGs Index' ))+geom_line()
  })
  
  output$rank <-renderDataTable({
    ranked %>% select(2:3)
    })
    #datatable(ranked)
    #select(ranked, cols=c(2,3))

    #select(ranked, cols=c('Country','2022 SDG Index Score'))
    #datatable(df)
  
  output$SDG<-renderInfoBox({
    
    infoBox(title = "2022 SDGs Score",
            color = "green",
            value= df$`2022 SDG Index Score`[df$Country == input$Negara],
            fill=TRUE
            )
    
  })
  output$Rank<- renderInfoBox({
    infoBox(title = "International Rank",
            color = "red",
            value= df$`2022 SDG Index Rank`[df$Country == input$Negara],
            fill=TRUE)
  })
  output$Reg<-renderInfoBox({
    infoBox(title="Regional Score",
            color="blue",
            value= df$`Regional Score (0-100)`[df$Country == input$Negara],
            fill=TRUE)
  })
  
  output$leafletMap <- renderLeaflet({
    leaflet()%>%
      addTiles()%>%
      addMarkers(lat=-7.250445, lng=112.768845, popup="Kediri")
  })
  
  
}

shinyApp(ui=ui, server=server)