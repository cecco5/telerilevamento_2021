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
# plotRGB(s2021, 4,3,2, stretch="hist")

#plot 2014 and 2021 images


#------------------------------------------------------------------------------------#

# 2.1 unsupervised classification with unsuperClass function

# unsuperClass classification based on kmeans algorithm
# Per cogliere il massimo della variabilità dai nostri dati operiamo una PCA rispettivamente su set 2014 e 2021
pca_2014 <- rasterPCA(s2014)

#> summary(pca_2014$model)
#Importance of components:
#                             Comp.1       Comp.2       Comp.3       Comp.4 ....
#Standard deviation     7670.7027040 3520.1605260 1.898809e+03 4.330130e+02
#Proportion of Variance    0.7833149    0.1649647 4.799861e-02 2.496135e-03
#Cumulative Proportion     0.7833149    0.9482796 9.962782e-01 9.987744e-01


set.seed(30)
pca12_2014 <- pca_2014$map$PC1+pca_2014$map$PC2 # c1 + c2 = 94% of variability
class2014 <- unsuperClass(pca12, nClasses=7)
# plot(class2014$map)

e <- drawExtent(show=TRUE, col="red") #estensione area di Rosignano Marittimo (LI), oggetto Extent
#> e
#class      : Extent
#xmin       : 611550.9
#xmax       : 623497.3
#ymin       : 4804117
#ymax       : 4809851

class2014_crop <- crop(class2014$map,e)

