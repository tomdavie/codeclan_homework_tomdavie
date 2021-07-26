library(tidyverse)
library(shiny)
library(shinythemes)
library(CodeClanData)
library(shinydashboard)

olympics_overall_medals <- olympics_overall_medals

# UI ----------------------------------------------------------------------

ui <- fluidPage(
    
    theme = shinytheme("sandstone"),
    titlePanel(tags$h1("Five Country Medal Comparison")),
    
    tabsetPanel(
        
        tabPanel("Plot", plotOutput("medal_plot")
        ),
        
        tabPanel(tags$b("More info"), "Some text"
        ),
        
        tabPanel(tags$b("Website"), "Some different text"
        )
    ),
    
    column(4,
           wellPanel(
               radioButtons(inputId = "season_input",
                            "Which season",
                            choices = c("Summer", "Winter"))
           )
    ),
    
    column(4, 
           wellPanel(
               radioButtons(inputId = "medal_input",
                            "Which medal?",
                            choices = c("Gold", "Silver", "Bronze"))
           )
    )
)


# Server ------------------------------------------------------------------

server <- function(input, output){
    
    output$medal_plot <- renderPlot({
        
        olympics_overall_medals %>%
            filter(team %in% c("United States",
                               "Soviet Union",
                               "Germany",
                               "Italy",
                               "Great Britain")) %>%
            filter(medal == input$medal_input) %>%
            filter(season == input$season_input) %>%
            ggplot() +
            aes(x = team, y = count, fill = medal) +
            geom_col() +
            scale_fill_manual(values = c("Gold" = "#D4AF37", 
                                         "Silver" = "#C0C0C0",
                                         "Bronze" = "#B08D57")) +
            labs(x = "Team",
                 y = "Number of Medals", 
                 fill = "Medal")
        
    })
}

shinyApp(ui = ui, server = server)