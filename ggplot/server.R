#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(SPARQL)
library(stringr)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  endpoint <- 'http://statistics.gov.scot/sparql'
  query <- 'PREFIX qb: <http://purl.org/linked-data/cube#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX sdmx: <http://purl.org/linked-data/sdmx/2009/concept#>
PREFIX data: <http://statistics.gov.scot/data/>
PREFIX sdmxd: <http://purl.org/linked-data/sdmx/2009/dimension#>
PREFIX mp: <http://statistics.gov.scot/def/measure-properties/>
PREFIX stat: <http://statistics.data.gov.uk/def/statistical-entity#>
SELECT ?areaname ?nratio ?yearname ?areatypename WHERE {
?indicator qb:dataSet data:alcohol-related-discharge ;
             sdmxd:refArea ?area ;
             sdmxd:refPeriod ?year ;
             mp:ratio ?nratio .
?year rdfs:label ?yearname .
  
?area stat:code ?areatype ;
      rdfs:label ?areaname .
?areatype rdfs:label ?areatypename .
}'
  qd <- SPARQL(endpoint,query)
  df <-qd$results
 # input$year
  
  output$distPlot <- renderPlot({
    #moved from outside renderplot to inside - 2 lines
    yearrange <- str_c(input$year,"-" , (input$year + 1), collapse='')
    df2013 <- df[(df$areatypename == 'Council Areas' & df$yearname == yearrange), ]
    # df2013 <- df[(df$areatypename == 'Council Areas' & df$yearname == '2012-2013'), ]
    charttitle <- str_c('Alcohol-related Hospital Discharges ', yearrange, ' (Rate per 100,000 people)')
    c <- ggplot(data = df2013, aes(x=reorder(areaname, -nratio), y=nratio, fill=areaname)) + theme_bw() + geom_bar(stat='identity') + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) + ggtitle(charttitle) + labs(x='Council Area', y='Rate per 100,000 people') + theme(legend.position='none')
    
    
   c
    
  })
  
})
