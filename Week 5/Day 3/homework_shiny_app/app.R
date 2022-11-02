library(shiny)
library(tidyverse)
library(bslib)


milk <- CodeClanData::milk
pivoted_milk <- milk %>% 
  pivot_longer(-name, names_to = "component", values_to = "percentage")
milk_animals <- pivoted_milk %>% 
  distinct(name) %>% 
  arrange(name) %>% 
  pull()

ui <- fluidPage(
  titlePanel(
    tags$h1("Do you want something to drink?")),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "animal",
                  label = "Which animals milk would you like?",
                  choices = c(milk_animals)
                  
      )
    ),
    mainPanel(plotOutput("milk_plot"))
  )
  
  
)
  
  


server <- function(input, output) {
  output$milk_plot <- renderPlot(
    pivoted_milk %>%
      filter(name == input$animal) %>% 
      ggplot(aes(x = component, y = percentage, fill = component)) +
      geom_col()+
      labs(
        title = "Components of chosen animals milk"
      )+
      scale_fill_manual(values = c("ash" = "azure4", "protein" = "yellow",
                                   "fat" = "antiquewhite1", "water" = "cadetblue1",
                                   "lactose" = "white"))
  )
}

shinyApp(ui, server)