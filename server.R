library(shiny)
library(shinyMobile)
library(tidyverse)
library(shinyWidgets)
library(echarts4r)

historico_dolar <- readRDS("historico_dolar.RDS")

shinyServer(function(input, output, session) {
  
  output$compra_dolar <- countup::renderCountup({
    
    countup::countup(as.numeric(datos[nrow(datos),2]),duration = 0) 
    
  })
  
  output$venta_dolar <- countup::renderCountup({
    
    countup::countup(as.numeric(datos[nrow(datos),3]),duration = 0)
    
  })
  
  output$historico_dolar <- renderEcharts4r({
    
    historico_dolar
    
  })

})
