
# Dependencias ------------------------------------------------------------

library(ggplot2)
library(dplyr)
library(gapminder)
library(tidyr)
library(rlang)
library(stringr)

# Directorio de trabajo: carpeta en la que se encuentra el UI y SERVER


# Cragar y transformar datos -------------------------------------------------------------------------------------------------------------------------------------

datosxcanton <- data.frame(read.csv("scripts_y_datos_teambryan/Datos/Datos Covid/covid19_cantones_cr.csv",header=TRUE,sep=","))

#head(datosxcanton)

datosgenerales <- data.frame(read.csv("scripts_y_datos_teambryan/Datos/Datos Covid/covid19_general_cr.csv",header=TRUE,sep=","))

datosgenerales <- datosgenerales %>%
  select(Fecha,Confirmados,Recuperados,Hospitalizados,CI)%>%
  mutate(Fecha=as.Date(as.character(Fecha), format = "%d/%m/%Y"),
         Activos=Confirmados-Recuperados)

#head(datosgenerales)

datos <- datosxcanton %>% 
  pivot_longer(-c(provincia, canton),
               names_to = "fecha", values_to = "total") %>% 
  filter(canton != "DESCONOCIDO") %>% 
  filter(!is.na(total)) %>% 
  mutate(fecha = str_replace_all(fecha,"\\.", "-"),
         fecha = str_remove(fecha,"X"),
         fecha = as.Date(fecha, format = "%d-%m-%Y"))

datos <- datos %>% 
  group_by(provincia, fecha) %>% 
  summarize(total = sum(total))

datos_totales <- datos %>% 
  filter(fecha==as.Date("2020-06-08", format = "%Y-%m-%d")) %>% 
  ungroup(provincia) %>% 
  mutate(provincia = as.character(provincia)) %>% 
  arrange(desc(total))

grafico_casos <-  ggplot(datosgenerales, aes(x=Fecha))+
  geom_line(aes(y= Confirmados),color="red")+
  geom_line(aes(y=Recuperados),color="blue")+
  geom_point(aes(y= Confirmados),color="red")+
  geom_point(aes(y=Recuperados),color="blue") +
  geom_line(aes(y=Activos),color="yellow")+
  geom_point(aes(y= Activos),color="yellow")+
  labs(title="Casos de COVID-19 en Costa Rica")+
  theme_light()


saveRDS(grafico_casos, file = "scripts_y_datos_teambryan/Datos/Datos Covid/grafico_casos.RDS")


grafico_hospitalizados <- ggplot(datosgenerales, aes(x=Fecha, y=Hospitalizados))+
  geom_line(color="red")+
  geom_line(aes(y=CI),color="blue")+
  geom_point(color="red")+
  geom_point(aes(y=CI),color="blue") + 
  labs(title="Personas hospitalizadas por COVID-19 en Costa Rica")+
  theme_light()

saveRDS(grafico_hospitalizados, file = "scripts_y_datos_teambryan/Datos/Datos Covid/grafico_hospitalizados.RDS")

grafico_provincia <- ggplot(datos_totales, aes(x=total, y=provincia, label = total))+
  geom_col(aes(fill=provincia))+
  labs(title="Personas hospitalizadas por COVID-19 en Costa Rica")+
  theme_classic()+
  #theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  theme(legend.position = "none") +
  geom_text(size = 3, position = position_stack(vjust = 0.5))


saveRDS(grafico_provincia, file = "scripts_y_datos_teambryan/Datos/Datos Covid/grafico_provincia.RDS")


