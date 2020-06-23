
# Dependencias ------------------------------------------------------------

library(readxl)
library(tidyr)
library(xts)
library(ggplot2)
library(dplyr)
library(plotly)
library(crosstalk)
library(prettydoc)

# Directorio de trabajo: carpeta en la que se encuentra el UI y SERVER


# Tema de los gráficos ---------------------------------------------------------------------------------

my_theme1 <- theme(rect = element_blank(), axis.line = element_line(color = "#DADADA"), 
                   axis.title = element_text(size = 10, color = "#505050", face = "italic"), 
                   axis.text = element_text(size = 9, color = "#505050"),
                   title = element_text(size = 13, color = "black"),
                   panel.grid.major.y = element_line(color = "#F3F3F3"),
                   legend.position = "top", legend.text = element_text(size = 9),
                   legend.title = element_text(size = 10, face = "bold"), legend.direction = "horizontal",
                   plot.caption = element_text(color = "black", size = "8", hjust = 0))



# Datos de Inflacion Comercial Porcentual-------------------------------------------------------------------------------------------------------------------------------------

inflacion_raw <- read_excel("Roberto_indicadores_macroeconómicos/Datos/IndicadorInflacionSociosComerciales/IINFP.xlsx", range = "Sheet1!A1:R13")
names(inflacion_raw)[1] <- c("Mes")
inflacion_raw$Mes <- c("01","02","03","04","05","06","07","08","09","10","11","12")
inflacion <- gather(inflacion_raw, Año, Porcentaje, -Mes)
inflacion <- unite(inflacion, Fecha, Año, Mes, sep = "-")

inflacion$Fecha <- seq(from = as.Date("2004-01-01"), to = as.Date("2020-12-01"), by = "month")

# Limpiamos ambiente
rm(inflacion_raw)


# Datos de Exportaciones -------------------------------------------------------------------------------------------------------------------------------------

exporta_raw <- read_excel("Roberto_indicadores_macroeconómicos/Datos/ExportacionesFOB/EFOBM.xlsx", range = "Sheet1!A1:CW120")
names(exporta_raw)[1] <- c("Producto")

exporta <- gather(exporta_raw, Fecha, Monto, -Producto)
exporta <- spread(exporta, Producto, Monto)
exporta <- separate(exporta, Fecha, c("Mes", "Año"))

# Orden de los datos
exporta$Mes[exporta$Mes == "Enero"] <- "a"
exporta$Mes[exporta$Mes == "Febrero"] <- "b"
exporta$Mes[exporta$Mes == "Marzo"] <- "c"
exporta$Mes[exporta$Mes == "Abril"] <- "d"
exporta$Mes[exporta$Mes == "Mayo"] <- "e"
exporta$Mes[exporta$Mes == "Junio"] <- "f"
exporta$Mes[exporta$Mes == "Julio"] <- "g"
exporta$Mes[exporta$Mes == "Agosto"] <- "h"
exporta$Mes[exporta$Mes == "Septiembre"] <- "i"
exporta$Mes[exporta$Mes == "Octubre"] <- "j"
exporta$Mes[exporta$Mes == "Noviembre"] <- "k"
exporta$Mes[exporta$Mes == "Diciembre"] <- "l"

exporta <- exporta %>% arrange(Año, Mes)

# Limpiamos ambiente
rm(exporta_raw)

# Ajustamos fechas

exporta <- unite(exporta, Fecha, Mes, Año, sep = " ")
exporta$Fecha <- seq(from = as.Date("2012-01-01"), to = as.Date("2020-04-01"), by = "month")



# Datos de Importaciones -------------------------------------------------------------------------------------------------------------------------------------

importa_raw <- read_excel("Roberto_indicadores_macroeconómicos/Datos/ImportacionesCIF/IMCIFM.xlsx", range = "Sheet1!A1:CL120")

names(importa_raw)[1] <- c("Producto")

importa <- gather(importa_raw, Fecha, Monto, -Producto)
importa <- spread(importa, Producto, Monto)
importa <- separate(importa, Fecha, c("Mes", "Año"))


# Orden de los datos
importa$Mes[importa$Mes == "Enero"] <- "a"
importa$Mes[importa$Mes == "Febrero"] <- "b"
importa$Mes[importa$Mes == "Marzo"] <- "c"
importa$Mes[importa$Mes == "Abril"] <- "d"
importa$Mes[importa$Mes == "Mayo"] <- "e"
importa$Mes[importa$Mes == "Junio"] <- "f"
importa$Mes[importa$Mes == "Julio"] <- "g"
importa$Mes[importa$Mes == "Agosto"] <- "h"
importa$Mes[importa$Mes == "Septiembre"] <- "i"
importa$Mes[importa$Mes == "Octubre"] <- "j"
importa$Mes[importa$Mes == "Noviembre"] <- "k"
importa$Mes[importa$Mes == "Diciembre"] <- "l"

importa <- importa %>% arrange(Año, Mes)

# Limpiamos ambiente
rm(importa_raw)

# Ajustamos fechas

importa <- unite(importa, Fecha, Mes, Año, sep = " ")
importa$Fecha <- seq(from = as.Date("2012-12-01"), to = as.Date("2020-04-01"), by = "month")



# Grafica cambios porcentuales en la inflacion -------------------------------------------------------------

g_inflacion <- inflacion %>% 
  plot_ly(x= ~Fecha, y= ~Porcentaje, hoverinfo = "text", text = ~paste("Fecha: ", Fecha,
                                                                       "<br>Nivel de Inflacion: ", round(Porcentaje, 2),"%")) %>% 
  add_lines() %>%
  layout(xaxis = list(title = "Fecha", range = c("2004-01-01","2020-04-01"), showgrid = FALSE), yaxis = list(title = "Porcentaje"), title= "Cambio en Inflacion Comercial Anual de Costa Rica", side = "left")

saveRDS(g_inflacion, file = "Roberto_indicadores_macroeconómicos/Datos/IndicadorInflacionSociosComerciales/g_inflacion.RDS")



# Gráfico Importaciones -------------------------------------------------------------

# Columna 120 es la de TOTAL
importa_p <- gather(importa[,-120], Producto, `Millones USD`, -Fecha) %>% arrange(Fecha, Producto)
exporta_p <- gather(exporta[-c(1:11),-120], Producto, `Millones USD`, -Fecha) %>% arrange(Fecha, Producto)


# Datos globales de exportaciones e importaciones por producto
impexp <- importa_p
names(impexp)[3] <- c("Importaciones")
impexp$Exportaciones <- exporta_p$`Millones USD`
rm(importa_p, exporta_p)


## Generación de gráfico Importaciones

# Ajuste de variables
g_imp <- impexp %>% arrange(Fecha) %>%
  SharedData$new(key= ~Producto, group = "Seleccione el Producto")  %>%
  plot_ly(x= ~Fecha, y= ~Importaciones, hoverinfo = "text", text = ~paste("Fecha: ", Fecha,
                                                                          "<br>Monto: $", round(Importaciones,2),"M")) %>% group_by(Producto)
g_imp <- g_imp %>% add_lines(y= ~Importaciones, name= "Importaciones", alpha = 0.7, color = "red")


# Ajuste de botones en Layout
g_imp <- g_imp %>% layout(showlegend = FALSE,
                          title = "Importaciones en Costa Rica",
                          xaxis = list(
                            rangeselector = list(
                              buttons = list(
                                list(
                                  count = 3,
                                  label = "3 mo",
                                  step = "month",
                                  stepmode = "backward"),
                                list(
                                  count = 6,
                                  label = "6 mo",
                                  step = "month",
                                  stepmode = "backward"),
                                list(
                                  count = 1,
                                  label = "1 yr",
                                  step = "year",
                                  stepmode = "backward"),
                                list(step = "all"))),
                            
                            rangeslider = list(type = "date")),
                          
                          yaxis = list(title = "Millones USD")) %>%
  
  highlight(selectize = TRUE, defaultValues = "NP112", color = "black")


saveRDS(g_imp, file = "Roberto_indicadores_macroeconómicos/Datos/ImportacionesCIF/g_imp.RDS")



# Grafico exportaciones ---------------------------------------------------

# Ajuste de variables
g_exp <- impexp %>% arrange(Fecha) %>%
  SharedData$new(key= ~Producto, group = "Seleccione el Producto")  %>%
  plot_ly(x= ~Fecha, y= ~Exportaciones, hoverinfo = "text", text = ~paste("Fecha: ", Fecha,
                                                                          "<br>Monto: $", round(Exportaciones,2),"M")) %>% group_by(Producto)
g_exp <- g_exp %>% add_lines(y= ~Exportaciones, name= "Exportaciones", alpha = 0.7, color = "blue")


# Ajuste de botones en Layout
g_exp <- g_exp %>% layout(showlegend = FALSE,
                          title = "Exportaciones en Costa Rica",
                          xaxis = list(
                            rangeselector = list(
                              buttons = list(
                                list(
                                  count = 3,
                                  label = "3 mo",
                                  step = "month",
                                  stepmode = "backward"),
                                list(
                                  count = 6,
                                  label = "6 mo",
                                  step = "month",
                                  stepmode = "backward"),
                                list(
                                  count = 1,
                                  label = "1 yr",
                                  step = "year",
                                  stepmode = "backward"),
                                list(step = "all"))),
                            
                            rangeslider = list(type = "date")),
                          
                          yaxis = list(title = "Millones USD")) %>%
  
  highlight(selectize = TRUE, defaultValues = "NP112", color = "black")


saveRDS(g_exp, file = "Roberto_indicadores_macroeconómicos/Datos/ExportacionesFOB/g_exp.RDS")

