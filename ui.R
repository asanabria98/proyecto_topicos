library(shiny)
library(shinyMobile)
library(tidyverse)
library(shinyWidgets)
library(echarts4r)
library(plotly)
library(ggplot2)
library(DT)

shinyUI(
  f7Page(
    title = "app macroeconomica",
    dark_mode = FALSE,
    f7TabLayout(
      navbar = f7Navbar(
        title = "Indicadores macroeconómicas Costa Rica",
        hairline = FALSE,
        shadow = TRUE,
        left_panel = FALSE,
        right_panel = FALSE
      ),
      f7Tabs(
        animated = TRUE,
        id = "tabs",
        f7Tab(
          tabName = "Indicadores",
          icon = f7Icon("money_dollar", old = FALSE),
          active = TRUE,
          swipeable = FALSE,
          #waiter_show_on_load(html = loader),
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
          f7Row(
            f7Col(
              f7Card(
                title = "Historico del tipo de cambio del dolar en los ultimos 6 meses" ,
                id = "historico",
                echarts4rOutput("historico_dolar", height = "50vh")
              ),
              f7Card(
                title = "Inflacion comercial" ,
                id = "inflacion",
                h2("Cambios en inflacion comercial anual de Costa Rica"),
                plotlyOutput("plotly_inflacion", height = "50vh")
              ),
              f7Card(
                title = "Importaciones y exportaciones" ,
                id = "importExport",
                h2("Tabla con descripción de los productos"),
                dataTableOutput("tabla_productos"),
                h2("Importaciones por producto"),
                plotlyOutput("plotly_importaciones", height = "50vh"),
                h2("Exportaciones por producto"),
                plotlyOutput("plotly_exportaciones", height = "50vh")
              )
            )
          )
        ),
        f7Tab(
          tabName = "Datos COVID-19",
          icon = f7Icon("burst_fill", old = FALSE),
          active = TRUE,
          swipeable = FALSE,
          f7Row(
            f7Col(
              f7Card(
                title = "Datos del COVID-19 en Costa Rica" ,
                id = "covid",
                h2("Positivos, recuperados y activos"),
                plotOutput("grafico_casos"),
                h2("Cantidad de personas hospitalizadas y en UCI"),
                plotOutput("grafico_hospitalizados", height = "50vh"),
                h2("Cantidad de casos activos por provincia"),
                plotOutput("grafico_provincia", height = "50vh")
              )
            )
          )
        )
      )
    )
  )
)
