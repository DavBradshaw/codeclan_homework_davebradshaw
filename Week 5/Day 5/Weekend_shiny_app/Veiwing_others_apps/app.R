library(shiny)
library(tidyverse)
library(bslib)

game_sales <- CodeClanData::game_sales

years <- sort(unique(game_sales$year_of_release))

platforms <- game_sales %>% 
  distinct(platform) %>% 
  pull()


# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = bs_theme(bootswatch = "darkly"),
  tabsetPanel(
    tabPanel(
      title = "Best sellers",
      sidebarLayout(
        sidebarPanel(
          selectInput(
            "year",
            "Year",
            choices = years
          )
        ),
        mainPanel(
          titlePanel(tags$h3("Best selling games each year (sales in millions)")),
          tableOutput("table")
        )
      )
    ),
    tabPanel(
      title = "Total Platform Sales",
      sidebarLayout(
        sidebarPanel(
          checkboxGroupInput(
            "platform",
            "Platforms",
            choices = platforms,
            selected = platforms
          ),
          actionButton(
            "selectall",
            "Select All"
          ),
          actionButton(
            "select",
            "Apply Platforms"
          )
        ),
        mainPanel(
          plotOutput("plot")
        )
      )
    )
  )
  
)

server <- function(input, output) {
  
  observe({
    if (input$selectall > 0) {
      if (input$selectall %% 2 == 0){
        updateCheckboxGroupInput(inputId="platform",
                                 choices = platforms,
                                 selected = platforms
        )} 
      else {
        updateCheckboxGroupInput(inputId="platform",
                                 choices = platforms,
                                 selected = ""
        )}}
  })    
  
  filtered_platforms <- eventReactive(input$select,{
    game_sales %>% 
      filter(platform == input$platform) %>% 
      group_by(year_of_release, platform) %>% 
      summarise(total_sales = sum(sales)) 
    
  })
  
  output$table <- renderTable(
    #was curious about the best selling games of each year 
    #and thought a table would show the top 10 well 
    game_sales %>% 
      filter(year_of_release == input$year) %>% 
      select(name, developer, sales, platform) %>% 
      slice_max(order_by = sales, n = 10)
  )
  
  output$plot <- renderPlot(
    if(is.null(input$platform)){
      print("No Platforms selected")
    }
    else{
      #thought it would be interesting to see how different platforms came in
      # and out of popularity 
      #check box input allows for comparison between same generation platforms
      filtered_platforms() %>% 
        ggplot(aes(x = year_of_release, y = total_sales, colour = platform)) +
        geom_line() 
    }
  )
}


# Run the application 
shinyApp(ui = ui, server = server)









