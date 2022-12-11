#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("ui.R")
library(plotly)

emissionsData <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")


# Three Values that I calculated

# Which are the 10 most populated countries in 2021? (Variable 1: Country)
topPopulations <- emissionsData %>%
  select(year, country, population) %>%
  filter(year == "2021")
View(topPopulations)

top10 <- topPopulations %>%
  filter(!row_number() %in% c(257, 15, 136, 249, 2, 103, 74, 135, 218, 172)) %>%
  top_n(10, population) %>%
  pull(country)


# What are average values of CO2 of the top most populated countries in 1900 AND 2021? (Variable 2: CO2)
topPopulations_1900 <- emissionsData %>%
  select(year, country, population, co2) %>%
  filter(year == "1900") %>%
  filter(!row_number() %in% c(238, 14, 231, 127, 98, 70, 2, 157, 126)) %>%
  top_n(10, population) %>%
  summarize(average_in_1900 = mean(co2, na.rm = TRUE))

topPopulations_2021 <- emissionsData %>%
  select(year, country, population, co2) %>%
  filter(year == "2021") %>%
  filter(!row_number() %in% c(257, 15, 136, 249, 2, 103, 74, 135, 218, 172)) %>%
  top_n(10, population)%>%
  summarize(average_in_2021 = mean(co2, na.rm = TRUE))

# How much has the CO2 per GDP variable changed over the past 100 years, in the 10 highest populated countries?
topPopulations_1900 <- emissionsData %>%
  select(year, country, population, co2_per_gdp) %>%
  filter(year == "1900") %>%
  filter(!row_number() %in% c(238, 14, 231, 127, 98, 70, 2, 157, 126)) %>%
  top_n(10, population) %>%
  summarize(average1900 = mean(co2_per_gdp, na.rm = TRUE))


topPopulations_2000 <- emissionsData %>%
  select(year, country, population, co2_per_gdp) %>%
  filter(year == "2000") %>%
  filter(!row_number() %in% c(257, 16, 136, 249, 104, 2, 75, 172, 135, 218)) %>%
  top_n(10, population) %>%
  summarize(average2021 = mean(co2_per_gdp, na.rm = TRUE))

average_difference_GDP <- topPopulations_2000 - topPopulations_1900

# Other data that is useful for line chart 
table <- emissionsData %>%
  select(year, country, co2) %>%
  drop_na() %>%
  filter(country == c("China", "India", "United States", "Indonesia",
                      "Pakistan", "Brazil", "Nigeria", "Bangladesh", "Russia", "Mexico"))

table_gdp <- emissionsData %>%
  select(year, country, co2_per_gdp) %>%
  drop_na() %>%
  filter(country == c("China", "India", "United States", "Indonesia",
                      "Pakistan", "Brazil", "Nigeria", "Bangladesh", "Russia", "Mexico"))

table_gdp_trade <- emissionsData %>%
  select(year, country, trade_co2) %>%
  drop_na() %>%
  filter(country == c("China", "India", "United States", "Indonesia",
                      "Pakistan", "Brazil", "Nigeria", "Bangladesh", "Russia", "Mexico"))


shiny <- function(input, output){
  output$radioButton <- renderPlotly({
    
    if(input$CO2Value == "CO2"){
      chart_data <- table %>%
        select(year, country, co2) %>%
        drop_na() %>%
        filter(country %in% country) %>%
        filter(table$year >= input$time[1], table$year <= input$time[2]) %>%
        group_by(year, country) %>%
        summarise(co2= sum(co2, na.rm = TRUE))
    
    
      plot_line_chart <- ggplot(chart_data) +
        geom_line(mapping = aes(x = year, y = co2, colour = country)) +
        labs(
          x = "Year",
          y = "CO2",
          Title = "CO2 Emissions in Populated Countries")
    
    
      ggplotly(plot_line_chart)
    
  }
    else
      if(input$CO2Value == "CO2 per GDP") {
      chart_data2 <- table_gdp %>%
      select(year, country, co2_per_gdp) %>%
      drop_na() %>%
      filter(country %in% country) %>%
      filter(table_gdp$year >= input$time[1], table_gdp$year <= input$time[2]) %>%
      group_by(year, country) %>%
      summarise(co2_per_gdp = sum(co2_per_gdp, na.rm = TRUE))
    
    
    plot_line_chart2 <- ggplot(chart_data2) +
      geom_line(mapping = aes(x = year, y = co2_per_gdp, colour = country)) +
      labs(
        x = "Year",
        y = "CO2 per GDP",
        Title = "CO2 per GDP in Populated Countries")
    
    ggplotly(plot_line_chart2)
      }
    
    else{
      chart_data3 <- table_gdp_trade %>%
        select(year, country, trade_co2) %>%
        drop_na() %>%
        filter(country %in% country) %>%
        filter(table_gdp_trade$year >= input$time[1], table_gdp_trade$year <= input$time[2]) %>%
        group_by(year, country) %>%
        summarise(trade_co2 = sum(trade_co2, na.rm = TRUE))
      
      
      plot_line_chart3 <- ggplot(chart_data3) +
        geom_line(mapping = aes(x = year, y = trade_co2, colour = country)) +
        labs(
          x = "Year",
          y = "Trade CO2",
          Title = "Trade CO2 in Populated Countries")
      
      ggplotly(plot_line_chart3)
      
    }
    
  })
}



    