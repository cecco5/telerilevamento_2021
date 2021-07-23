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

# LANDSTA IMAGES
# B2 BLUE
# B3 GREEN
# B4 RED
# B5 NIR
b2 <- brick("LC08_L2SP_192030_20130616_20200912_02_T1_SR_B2.TIF")
b3 <- brick("LC08_L2SP_192030_20130616_20200912_02_T1_SR_B3.TIF")
b4 <- brick("LC08_L2SP_192030_20130616_20200912_02_T1_SR_B4.TIF")
b5 <- brick("LC08_L2SP_192030_20130616_20200912_02_T1_SR_B5.TIF")

rlist <- list(b2,b3,b4,b5)
image <- stack(rlist)
plot(image$LC08_L2SP_192030_20130616_20200912_02_T1_SR_B5)
