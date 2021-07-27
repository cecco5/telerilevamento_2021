#R_code_exam_project.r

#------------------------------------------------------------
#PROGETTO ESAME FINALE TELERILEVAMENTO GEOECOLOGICO

# Summary
#1  Scaricamento + IMPORT immagini satellitari Toscana, dati Landsat 8 OLI-TIRS Collection2 Livello2
#2  Classificazione land cover attraverso package RStoolbox supervised e unsupervised classification methods
#3  Qualità classificazioni e confronto
#4  NDVI analisi multitemporale


#---------------------------------------
 

setwd("C:/lab/esame")

library(raster)
libraty(RStoolbox) #per la classificazione



#1 IMPORTAZIONE IMMAGINI TOSCANA TELERILEVATE DA SISTEMA LANDSAT 8 OLI-TIRS COLLECTION 2 LEVEL 2


# Bande Landsat
# B1: blu
# B2: verde
# B3: rosso
# B4: infrarosso vicino
# B5: infrarosso medio
# B6: infrarosso termico
# B7: infrarosso medio

#2014
list2014 <- list.files(pattern="20140806")
s2014 <- stack(list2014)                                        #raster multibanda 2014, oggetto RasterStack
#plotRGB(s2014,4,3,2,stretch="hist") funziona

#2015
list2015 <- list.files(pattern="20150910")
s2015 <- stack(list2015)

#2016
list2016 <- list.files(pattern="20161030")
s2016 <- stack(list2016)

#2017
list2017 <- list.files(pattern="20170814")
s2017 <- stack(list2017)

#2018
list2018 <- list.files(pattern="20180427")
s2018 <- stack(list2018)

#2019
list2019 <- list.files(pattern="20190820")
s2019 <- stack(list2019)

#2020
list2020 <- list.files(pattern="20200822")
s2020 <- stack(list2020)

#2021
list2021 <- list.files(pattern="20210302")
s2021 <- stack(list2021)

