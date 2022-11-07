library(shiny)
library(tidyverse)
library(jpeg)
library(ggpubr)

platforms <- CodeClanData::game_sales %>% 
  distinct(platform) %>% 
  arrange(platform) %>% 
  pull()

genre <- CodeClanData::game_sales %>% 
  distinct(genre) %>% 
  arrange(genre) %>% 
  pull()

resident_evil_by_year <- CodeClanData::game_sales %>% 
  filter(str_detect(name, "esident")) %>% 
  group_by(name) %>% 
  arrange(year_of_release) %>% 
  distinct(name) %>% 
  pull(name)

resident_evil <- CodeClanData::game_sales %>% 
  filter(str_detect(name, "esident")) %>% 
  mutate(name = factor(name, levels = resident_evil_by_year)) %>% 
  group_by(name) %>% 
  mutate(total_sales = sum(sales)) %>% 
  mutate(average_user_score = mean(user_score)) %>% 
  mutate(average_critic_score = mean(critic_score)) %>% 
  distinct(name, total_sales, average_critic_score, average_user_score)

img <- readJPEG("Umbrella-Corporation-Logo-720x450.jpg")

ui <- fluidPage(
  
  titlePanel("What game to buy?"),
  
  tabsetPanel(
    tabPanel(title = "I'm open to anything",
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
                      "Table showing data for the games avialable with set filters",
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
    #The idea behind showing the data in these three formats was that the user could decide what factors mattered
    #most to them when deciding what game they might purchase given the criteria they have chosen. 
    #Showing all three may help them make decisions when factors are close and visuals may be more beneficial
    #than a table for this (particularly in years with lots of games). 
    
    
    
    tabPanel(title = "I only care about Resident Evil games",
             
             plotOutput(outputId = "resi_plot")
      
    ),
    
    #This graph will show readers which resident evil games received the best user scores with an acknowledgment
    #to the critic score using the size of the point. It should help them identify the best game as the users of the game have rated it.
    
    tabPanel(title = "I only care about FIFA games",
             selectInput(
               inputId = "release_year",
               label = "Which year:",
               choices = c(2000:2016)
             ),
             plotOutput(outputId = "fifa_plot"),
             "Table showing data for the games released in the chosen year",
             tableOutput(outputId = "fifa_table"),
             plotOutput(outputId = "fifa_overall")
    )
  )
  
  #This plot shows the total sales of all FIFA games released in a given year. Data shows this appears to have peaked in popularity in
  #2012/2013 before declining again. It appers not as many people are buying new FIFA games annually as they were a few years ago. 
  #The smooth curve "loess" method was used as the data appears to have peaked and it now declining therefore a straight line would not have been suitable.
  
)

server <- function(input, output, session) {
  
  year_genre_platform <- reactive(
    CodeClanData::game_sales %>% 
      filter(genre == input$genre,
             year_of_release == input$year,
             platform == input$platform)
  )
  
  fifa_year <- reactive(CodeClanData::game_sales %>% 
    filter(str_detect(name, "FIFA"), year_of_release == input$release_year)
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
      scale_fill_brewer(palette = "Pastel1")+
      ylim(0, 10)
  )

    output$critics_plot <- renderPlot(
      year_genre_platform() %>% 
        ggplot()+
        geom_col(aes(y = critic_score, x = name, fill = name), show.legend = FALSE)+
        labs(x = "Game Title",
             y = "Average critic score (out of 100)")+
        coord_flip()+
        scale_fill_brewer(palette = "Pastel1")+
        ylim(0, 100)
    )
  
    
    output$resi_plot <- renderPlot(
      resident_evil %>% 
        ggplot()+
        background_image(img)+
        geom_point(aes(x = name, y = average_user_score, size = average_critic_score), colour = "#8a0303", show.legend = FALSE)+
        coord_flip()+
        labs(title = "Resident Evil games showing user and critic scores (size of bubble)",
             y = "Average user score (out of 10) across platforms",
             x = "Game")
    )
    
    output$fifa_plot <- renderPlot(
      fifa_year() %>% 
      ggplot()+
        geom_col(aes(y = name, x = sales, fill = platform), position = "dodge")+
        labs(x = "Sales (millions)",
             y = "Game Title",
             title = "Sales of FIFA games released in chosen year by release platfrom")
    )

    output$fifa_table <- renderTable(
      fifa_year() %>% 
      select(-year_of_release)
    )
    
    output$fifa_overall <- renderPlot(
    CodeClanData::game_sales %>% 
      filter(str_detect(name, "FIFA")) %>%
      group_by(year_of_release) %>% 
      mutate(sales_in_year = sum(sales))%>% 
      ggplot()+
      geom_point(aes(x = year_of_release, y = sales_in_year))+
      geom_smooth(aes(x = year_of_release, y = sales_in_year), method = loess)+
      labs(title = "Total sales of FIFA games across the years",
           x = "Year",
           y = "Total sales of all games released that year (millions)")
    )
}

shinyApp(ui, server)