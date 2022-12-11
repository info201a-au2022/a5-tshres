#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(ggplot2)
library(dplyr)
library(plotly)
library(tidyverse)
library(scales)
library(shiny)
install.packages(plotly)

# Define UI for application that draws a histogram
ui <- navbarPage(
  title = "CO2 Emissions Data Analysis",
    tabPanel(
      "Introduction",
      #fluidPage(
      img(src = "https://nenow.in/wp-content/uploads/2019/08/file-20170615-23574-gzh6p7.jpg", height = "50%", width = "50%", align = "center"),
    #  ),
  h3(strong("Brief Overview")),
  h3("Carbon dioxide emissions caused by people, contain a large impact on other individuals, along with where they live. While being one of the greatest causes towards climate change, CO2 emissions have been increasing in many different countries. In order to represent the impact of CO2 emissions, data compiled by “Our World in Data” will be used. "),
  #),
    h3(strong("Three Relevant Variables That Were Calculated:")),
    h3("Which are the 10 most populated countries in 2021? ", strong("Bangladesh, Brazil, China, India, Indonesia, Mexico, Nigeria, Pakistan, Russia, United States")),
    h3("What are average values of CO2 of the top most populated countries in 1900 AND 2021?", strong("Average value in 1900: ", topPopulations_1900), strong("Average value in 2021: ", topPopulations_2021)),
    h3("How much has the CO2 per GDP variable changed over the past 100 years, in the 10 highest populated countries? ", strong(average_difference_GDP))
  ),
  

tabPanel(
  "CO2 Line Chart",
  fluidPage("Line Chart Representing CO2 Variables"),
  mainPanel(
    sliderInput("time", label = h3("Slider Range"), min = 1750, 
                max = 2021, value = c(1750, 2021)), 
 selectInput("CO2Value", label = h3("CO2 Variables"), 
             choices = list("CO2", "CO2 per GDP","Trade CO2"),
             selected = 1),
    plotlyOutput(outputId = "radioButton", width = "80%", height = "400%"),
 h3(strong("Conclusion")),
 h3("The overall goal of this chart is to show whether higher human populations cause an increase in different types of CO2 emissions over a period of time. By doing so, the visualization contains data from the top 10 populated countries of 2021."),
 h3(strong("Takeaways:")),
 h3("Each variable shows the impact of CO2 emissions, CO2 per GDP, and Trade CO2, over a period of time. CO2 levels started to rise in the late 1800’s, resulting in the data to start around that time."),
 h3(strong("CO2 :")),
 h3("All of the countries had an increase, whether it was large or small. This could be caused by the high population growth the countries have had. While China had the most increase, the U.S was second, followed by Russia, then India."),
 h3(strong("CO2 per GDP:")),
 h3("Most of the countries had an increase, while others had a significant decrease. Around 1920-1930 is when there was a drop. Mexico had the biggest decrease, along with the U.S. The reason being is associated with the economy at the time."),
 h3(strong("Trade CO2:")),
 h3("Many countries had consistency with Trade CO2 throughout the years. However,  a couple of countries seemed to be an outlier with either a strong increase or decrease. This could be caused by the amount of money a country has.")
 
  ))
)


