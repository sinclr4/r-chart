#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(SPARQL)
library(ggplot2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Alcohol related discharge data"),

  # Sidebar with a slider input for the year to look ats 
  sidebarLayout(
    sidebarPanel(
       sliderInput(inputId = "year",
                   "Year to consider:",
                   min = 2008,
                   max = 2012,
                   value = 2010,
                   step = 1)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
    
      plotOutput("distPlot")
    )
  )
))
