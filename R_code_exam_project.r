#R_code_exam_project.r

#------------------------------------------------------------
#PROGETTO ESAME FINALE TELERILEVAMENTO GEOECOLOGICO

# Summary
#1  Scaricamento immagini satellitari, riferite a due periodi diversi nel tempo : Copernicus - Sentinel 2
#2  

#---------------------------------------
#1 DOWNLOAD

setwd("C:/lab/esame")
library(raster)

image <- brick("E000N60_PROBAV_LC100_global_v3.0.1_2015-base_Discrete-Classification-map_EPSG-4326.tif")
plot(image)
