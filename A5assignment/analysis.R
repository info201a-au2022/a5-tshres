emissionsData <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")


library(ggplot2)
library(dplyr)
library(plotly)
library(tidyverse)
library(shiny)
library(scales)



# What is the average value of my variable across all the counties (in the current year)?

average_co2 <- emissionsData %>%
  filter(co2 == mean(co2, na.rm = TRUE)) %>%
  pull(year)
  

average <- average_co2 %>%
  summarise(x = mean(co2, na.rm = TRUE)) %>%
  pull(x)


# Top 10 highest populated country in 2021
topPopulations <- emissionsData %>%
  select(year, country, population) %>%
  filter(year == "2021")
View(topPopulations)
  
top10 <- topPopulations %>%
  filter(!row_number() %in% c(257, 15, 136, 249, 2, 103, 74, 135, 218, 172)) %>%
  top_n(10, population) %>%
  pull(country)
View(top10)





# Average value of CO2 of these countries in 1900 vs. 2021

topPopulations_1900 <- emissionsData %>%
  select(year, country, population, co2) %>%
  filter(year == "1900") %>%
  filter(!row_number() %in% c(238, 14, 231, 127, 98, 70, 2, 157, 126)) %>%
  top_n(10, population) %>%
  summarize(average_in_1900 = mean(co2, na.rm = TRUE))
View(topPopulations_1900)

topPopulations_2021 <- emissionsData %>%
  select(year, country, population, co2) %>%
  filter(year == "2021") %>%
  filter(!row_number() %in% c(257, 15, 136, 249, 2, 103, 74, 135, 218, 172)) %>%
  top_n(10, population)%>%
  summarize(average_in_2021 = mean(co2, na.rm = TRUE))
View(topPopulations_2021)


# How much has the CO2 per GDP variable changed over the past 100 years in the 10 highest populated countries?
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

# This represents the difference between the average CO2 emissions from 1900 vs. 2021, of the top 10 countries




tabledata <- emissionsData %>%
  select(year, country, co2_per_gdp) %>%
  drop_na() %>%
  filter(co2_per_gdp == max(co2_per_gdp, na.rm = TRUE))


Co2 <- emissionsData %>%
  select(year, country, co2)%>%
  drop_na()

table_gdp_trade <- emissionsData %>%
  select(year, country, trade_co2) %>%
  drop_na() %>%
  filter(country == c("China", "India", "United States", "Indonesia",
                      "Pakistan", "Brazil", "Nigeria", "Bangladesh", "Russia", "Mexico"))

  
tabledata1 <- emissionsData %>%
  select(year, country, co2_per_gdp) %>%
  drop_na() %>%
  filter(year == "1900")
#  filter(co2_per_gdp > 0) %>%
  #filter(co2_per_gdp == max(co2_per_gdp, na.rm = TRUE))


# Data for co2 per gdp

table <- emissionsData %>%
  select(year, country, co2_per_gdp) %>%
  drop_na() %>%
  filter(country == c("China", "India", "United States", "Indonesia",
                      "Pakistan", "Brazil", "Nigeria", "Bangladesh", "Russia", "Mexico"))
  


  chart_data <- table %>%
    select(year, country, co2_per_gdp) %>%
    drop_na() %>%
    filter(country %in% country) %>%
    group_by(year, country) %>%
    summarise(co2_per_gdp = sum(co2_per_gdp, na.rm = TRUE))



  plot_line_chart <- ggplot(chart_data) +
    geom_line(mapping = aes(x = year, y = co2_per_gdp, colour = country)) +
    labs(
      x = "Year",
      y = "CO2 per GDP",
      Title = "Line Chart")
  
 #   return(plot_line_chart)
#}


chart <- plot_line_chart()

# Data for co2


table_co2 <- emissionsData %>%
  select(year, country, co2) %>%
  drop_na() %>%
  filter(country == c("China", "India", "United States", "Indonesia",
                      "Pakistan", "Brazil", "Nigeria", "Bangladesh", "Russia", "Mexico"))


chart_data_co2 <- table_co2 %>%
  select(year, country, co2) %>%
  drop_na() %>%
  filter(country %in% country) %>%
  group_by(year, country) %>%
  summarise(co2 = sum(co2, na.rm = TRUE))



plot_line_chart_co2 <- ggplot(chart_data_co2) +
  geom_line(mapping = aes(x = year, y = co2, colour = country)) +
  labs(
    x = "Year",
    y = "CO2",
    Title = "Line Chart")
    