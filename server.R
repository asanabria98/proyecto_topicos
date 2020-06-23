library(shiny)
library(shinyMobile)
library(tidyverse)
library(shinyWidgets)
library(echarts4r)
library(DT)
library(plotly)
library(ggplot2)

historico_dolar <- readRDS("historico_dolar.RDS")
g_inflacion <- readRDS("scripts_y_datos_teambryan/Datos/IndicadorInflacionSociosComerciales/g_inflacion.RDS")
codigo <- read.table("scripts_y_datos_teambryan/Datos/ExportacionesFOB/Nomenclatura_de_productos.txt", header = TRUE, sep = "\t")
g_imp <- readRDS("scripts_y_datos_teambryan/Datos/ImportacionesCIF/g_imp.RDS")
g_exp <- readRDS("scripts_y_datos_teambryan/Datos/ExportacionesFOB/g_exp.RDS")
grafico_casos <- readRDS("scripts_y_datos_teambryan/Datos/Datos Covid/grafico_casos.RDS")
grafico_hospitalizados <- readRDS("scripts_y_datos_teambryan/Datos/Datos Covid/grafico_hospitalizados.RDS")
grafico_provincia <- readRDS("scripts_y_datos_teambryan/Datos/Datos Covid/grafico_provincia.RDS")


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
  # Grafico inflacion comercial ---------------------------------------------------------
  
  output$plotly_inflacion <- renderPlotly({
    
    g_inflacion
    
  })
  # Tabla descripcion productos importExport ---------------------------------------------------------
  
  output$tabla_productos <- renderDataTable({
    
    datatable(codigo, rownames = FALSE, options = list(
      columnDefs = list(list(className = 'dt-center', targets = 0)),
      order = FALSE
    ))
    
    
  })
  # Grafico importaciones ---------------------------------------------------------
  
  output$plotly_importaciones <- renderPlotly({
    
    g_imp
    
  })
  # Grafico exportaciones ---------------------------------------------------------
  
  output$plotly_exportaciones <- renderPlotly({
    
    g_exp
    
  })
  # Grafico exportaciones ---------------------------------------------------------
  
  output$grafico_casos <- renderPlot({
    
    grafico_casos 
    
  })
  # Grafico exportaciones ---------------------------------------------------------
  
  output$grafico_hospitalizados <- renderPlot({
    
    grafico_hospitalizados
    
  })
  # Grafico exportaciones ---------------------------------------------------------
  
  output$grafico_provincia <- renderPlot({
    
    grafico_provincia
    
  })

})
