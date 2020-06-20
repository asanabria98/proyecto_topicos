library(readxl)
library(lubridate)
library(stringr)

datos <- read_excel("datos.xlsx")
names(datos) <- c("fecha","compra","venta")

datos$fecha <- str_replace(datos$fecha, "Ago", "Aug")
datos$fecha <- str_replace(datos$fecha, "Set", "Sep")
datos$fecha <- str_replace(datos$fecha,"Dic","Dec")
datos$fecha <- str_replace(datos$fecha,"Ene","Jan")
datos$fecha <- str_replace(datos$fecha,"Abr","Apr")
datos$fecha <- dmy(datos$fecha)

# Indicador Compra dolar del dia actual

compra_dolar <- datos[nrow(datos),2]

venta_dolar <- datos[nrow(datos),3]

#Hacer los saveRDS por aca

#historico dolar  



historico_dolar <- datos %>%
  e_charts(fecha) %>%
  e_line(compra, name = "Tipo cambio compra") %>%
  e_line(venta, name = "Tipo cambio venta") %>%
  e_tooltip(trigger = "axis") %>%
  e_x_axis(name = "Fecha", nameLocation = "center", nameGap = 40) %>%
  e_y_axis(min = 500) %>%
  e_text_style(fontSize = 12)
  
  
saveRDS(historico_dolar, file = "historico_dolar.RDS")  
    

