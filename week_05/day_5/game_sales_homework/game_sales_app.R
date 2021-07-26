library(shiny)
library(tidyverse)
library(DT)
library(shinydashboard)
library(viridis)
library(hrbrthemes)
library(plotly)

game_sales <- CodeClanData::game_sales

# UI ----------------------------------------------------------------------

ui <- dashboardPage(
    dashboardHeader(title = "Game Sales"),
    dashboardSidebar(
        sliderInput("year_input", "Select a year",
                    min = 1996, max = 2016, value = 2000, step = 1, sep = ""
        ),
        sidebarMenu(
            menuItem("Dashboard", tabName = "dashboard"),
            menuItem("Raw data", tabName = "rawdata")
        )
    ),
    dashboardBody(
        tabItems(
            tabItem("dashboard",
                    fluidRow(
                        # These three value boxes display 'Most Popular Game' by
                        # user score, 'Critics Choice' and 'Total Sales' on the
                        # selected year. These boxes make these headline insights
                        # quick and easy to read.
                        valueBoxOutput("popular"),
                        valueBoxOutput("critics_choice"),
                        valueBoxOutput("total_sales")
                    ),
                    fluidRow(
                        box(
                            # This graph displays the headlines numbers 
                            # for the top 10 games on the selected year based
                            # on sales numbers. This interactive plotly graph
                            # allows the user to compare user score,
                            # critics score and sales from these games. 
                            width = 8, status = "info", solidHeader = TRUE,
                            title = "Top 10 Games (based on Number of Sales)",
                            plotlyOutput("game_plot", width = "100%", height = 550)
                        ),
                        box(
                            # This table displays the 'Top Developer by Sales' 
                            # on the selected year. A data table allows the user 
                            # to compare and search these results easily. 
                            width = 4, status = "info", solidHeader = TRUE,
                            title = "Top Developer by Sales",
                            dataTableOutput("game_table", height = 550)
                        )
                    )
            ),
            tabItem("rawdata",
                    # The raw data is displayed on this page in a data table. 
                    # There is a button to download a CSV if they'd like to 
                    # inspect the data further.
                    dataTableOutput("rawtable"),
                    downloadButton("downloadCsv", "Download as CSV")
            )
        )
    )
)


# Server ------------------------------------------------------------------

server <- function(input, output) {
    
    game_sales_filtered <- reactive({
        
        game_sales %>% 
            group_by(year_of_release) %>% 
            filter(year_of_release == input$year_input) 
            
        })
    
    output$popular <- renderValueBox({
        
        valueBox(
            value = 
                tags$p(game_sales_filtered() %>% 
                ungroup() %>% 
                arrange(desc(user_score)) %>% 
                select(name) %>% 
                head(1),
                style = "font-size: 80%;"),
            subtitle = "Most Popular Game",
            icon = icon("heart"),
            color = "blue"
        )
    })
    
    output$critics_choice <- renderValueBox({
        valueBox(
            value = 
                tags$p(game_sales_filtered() %>% 
                ungroup() %>% 
                arrange(desc(critic_score)) %>% 
                select(name) %>% 
                head(1),
                style = "font-size: 80%;"),
            subtitle = "Critics Choice",
            icon = icon("star"),
            color = "blue"
        )
    })
    
    output$total_sales <- renderValueBox({
        
        valueBox(
            value = 
                tags$p(game_sales_filtered() %>% 
                select(sales) %>% 
                ungroup() %>% 
                summarise(sales = sum(sales)) %>% 
                pull(),
                style = "font-size: 80%;"),
            "Total Sales",
            icon = icon("usd"),
            color = "blue"
        )
    })
    
    output$game_plot <- renderPlotly({
        
        game_sales_filtered() %>% 
            slice_max(sales, n = 10) %>% 
            ggplot() +
            geom_point(aes(x = name, y = sales, colour = user_score, size = critic_score), alpha = 0.7) +
            scale_size(range = c(3, 12)) +
            scale_color_viridis(discrete = FALSE) +
            theme_ipsum() +
            theme(axis.text.x = element_text(size = 10, angle = 45),
                  axis.text.y = element_text(size = 10),
                  axis.title.x = element_text(size = 15),
                  axis.title.y = element_text(size = 15)) +
            labs(x = "Game Name", 
                 y = "Sales",
                 colour = "User Score")
            
    })
    
    output$game_table <- renderDataTable({

        game_sales_filtered() %>%
            select(developer, sales) %>% 
            ungroup() %>% 
            select(-year_of_release) %>% 
            group_by(developer) %>% 
            mutate(sales = sum(sales)) %>% 
            distinct() %>% 
            arrange(desc(sales))
    })
    
    output$downloadCsv <- downloadHandler(
        filename = "game_sales_filtered.csv",
        content = function(file) {
            write.csv(game_sales_filtered(), file)
        },
        contentType = "text/csv"
    )
    
    output$rawtable <- renderDataTable({
        
        game_sales_filtered() 
    })
}


shinyApp(ui, server)