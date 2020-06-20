library(shiny)
library(shinyMobile)
library(tidyverse)
library(shinyWidgets)
library(echarts4r)

shinyUI(
  f7Page(
    f7Card(
      h2("Indicadores financieros Costa Rica")
    ),
    f7Row(
      title = "Tipo de cambio al dia de hoy",
      f7Col(
        f7Card(
          h2(
            align = "center",
            tags$span(countup::countupOutput("compra_dolar")),
            br(),
            span(tags$small("Tipo de cambio compra"))
          )
        )
      ),
      f7Col(
        f7Card(
          h2(
            align = "center",
            tags$span(countup::countupOutput("venta_dolar")),
            br(),
            span(tags$small("Tipo de cambio venta"))
          )
        )
      )
    ),
    f7Card(
      title = "Historico del tipo de cambio del dolar en los ultimos 6 meses" ,
      id = "historico",
      echarts4rOutput("historico_dolar", height = "50vh")
    )
  )
)
