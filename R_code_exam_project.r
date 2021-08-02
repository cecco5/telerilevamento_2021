#R_code_exam_project.r

#------------------------------------------------------------
#PROGETTO ESAME FINALE TELERILEVAMENTO GEOECOLOGICO

# Summary
#1  Scaricamento + IMPORT immagini satellitari Toscana, dati Landsat 8 OLI-TIRS Collection2 Livello2
#2  Classificazione land cover attraverso package RStoolbox supervised e unsupervised classification methods
#3  Qualità classificazioni e confronto
#4  NDVI analisi multitemporale


#----------------------------------------------------------------
 


setwd("C:/lab/esame")

library(raster)
library(RStoolbox) #per la classificazione
library(ggplot2)
library(gridExtra)
library(viridis)
library(rasterVis)



#1 IMPORTAZIONE IMMAGINI TOSCANA TELERILEVATE DA SISTEMA LANDSAT 8 OLI-TIRS COLLECTION 2 LEVEL 2


# Bande Landsat
# B1: CA
# B2: BLU
# B3: VERDE
# B4: ROSSO
# B5: NIR
# B6: SWIR
# B7: SWIR

#2014
list2014 <- list.files(pattern="20140806")
s2014 <- stack(list2014)                                        #raster multibanda 2014, oggetto RasterStack



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
# plotRGB(s2021, 4,3,2, stretch="hist")

#plot 2014 and 2021 images


#------------------------------------------------------------------------------------#

# 2.1 unsupervised classification with unsuperClass function

#plotRGB(s2014,4,3,2,stretch="hist") 
#e <- drawExtent(show=TRUE, col="red") #estensione area di Rosignano Marittimo (LI), oggetto Extent
#> e
#class      : Extent
#xmin       : 612410.9
#xmax       : 617274
#ymin       : 4804437
#ymax       : 4810342

e <- extent(612410.9,617274,4804437,4810342) #estensione area di Rosignano

#raster Rosignano 
Rosignano2014 <- crop(s2014,e)
#plotRGB(Rosignano2014,4,3,2,stretch="hist")

# unsuperClass classification based on kmeans algorithm
# Per cogliere il massimo della variabilità dai nostri dati operiamo una PCA
set.seed(30)
pca_2014 <- rasterPCA(Rosignano2014)
#summary(pca_2014$model)
#plot(pca_2014$map)
pca12_2014 <- pca_2014$map$PC1+pca_2014$map$PC2 # pc1 + pc2 = 98.5% of variability
#levelplot(pca12_2014)

#UNSUPERVISED CLASSIFICATION: 3 CLASSI E 6 CLASSI 
class2014_3 <- unsuperClass(pca12_2014, nClasses=3) #3 classi per distinguere intanto mare, zone antropizzate e aree verdi
#par(mfrow=c(1,2))
#plotRGB(Rosignano2014,4,3,2,stretch="hist")
#plot(class2014$map)

#Dal confronto con l'immagine RGB si apprezza la differenziazione delle 3 classi, notando anche la presenza di 3 specchi d'acqua non individuabili altrimenti.
#Aumentando il numero di classi della funzione, è possibile osservare come l'algoritmo riesca a individuare più elementi, tra cui una diversificazione maggiore della vegetazione

class_2014_6 <- unsuperClass(pca12_2014,nClasses=6)
#par(mfrow=c(1,2))
#plotRGB(Rosignano2014,4,3,2,stretch="hist")
#plot(class_2014_6$map)









