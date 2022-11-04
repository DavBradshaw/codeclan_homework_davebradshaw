library(shiny)
library(tidyverse)

platforms <- CodeClanData::game_sales %>% 
  distinct(platform) %>% 
  arrange(platform) %>% 
  pull()

genre <- CodeClanData::game_sales %>% 
  distinct(genre) %>% 
  arrange(genre) %>% 
  pull()


ui <- fluidPage(
  
  titlePanel("I'm selective about what games I buy"),
  
  tabsetPanel(
    tabPanel(title = "What kind of game would you like?",
      fluidRow(
        column(4,
               selectInput(
                 inputId = "platform",
                 label = "What platform:",
                 choices = platforms
               )),
        
        column(4,
               selectInput(
                 inputId = "genre",
                 label = "What Genre:",
                 choices = genre
               )),
        
        column(4,
               sliderInput(
                 inputId = "year",
                 label = "What year:",
                 min = 1988,
                 max = 2016,
                 value = 2000,
                 sep = NULL
                 
               ))
        
      ),
      fluidRow(
        column(6,
               tableOutput(outputId = "games_table")),
        
        column(6,
               plotOutput(outputId = "sales_plot"))
        
        ),
      fluidRow(
        column(6,
               plotOutput(outputId = "user_plot")),
        column(6,
               plotOutput(outputId = "critics_plot"))
      )
    ),
    
    
    
    
    tabPanel(title = "I just want the best",
             )
  )
  
)

server <- function(input, output, session) {
  
  year_genre_platform <- reactive(
    CodeClanData::game_sales %>% 
      filter(genre == input$genre,
             year_of_release == input$year,
             platform == input$platform)
  )
  
  output$games_table <- renderTable(
    year_genre_platform() %>% 
          select(name, user_score, critic_score, sales, rating, developer)
  )

output$sales_plot <- renderPlot(
  year_genre_platform() %>% 
    ggplot()+
    geom_col(aes(y = sales, x = name, fill = name), show.legend = FALSE)+
    labs(x = "Game Title",
         y = "Sales on this patform (millions)")+
    coord_flip()+
    scale_fill_brewer(palette = "Pastel1")
  )
  
  output$user_plot <- renderPlot(
    year_genre_platform() %>% 
      ggplot()+
      geom_col(aes(y = user_score, x = name, fill = name), show.legend = FALSE)+
      labs(x = "Game Title",
           y = "Average user score (out of 10")+
      coord_flip()+
      scale_fill_brewer(palette = "Pastel1")
  )

    output$critics_plot <- renderPlot(
      year_genre_platform() %>% 
        ggplot()+
        geom_col(aes(y = critic_score, x = name, fill = name), show.legend = FALSE)+
        labs(x = "Game Title",
             y = "Average critic score (out of 100)")+
        coord_flip()+
        scale_fill_brewer(palette = "Pastel1")
    )
  

}

shinyApp(ui, server)