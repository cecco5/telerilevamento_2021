#R_code_exam_project.r

#------------------------------------------------------------
#PROGETTO ESAME FINALE TELERILEVAMENTO GEOECOLOGICO

# Summary
#1  Scaricamento + IMPORT immagini satellitari Toscana, dati Landsat 8 OLI-TIRS Collection2 Livello2
#2  Classificazione land cover attraverso package RStoolbox supervised e unsupervised classification methods
#3  
#4  NDVI analisi multitemporale


#----------------------------------------------------------------
 


setwd("C:/lab/esame")

library(raster)
library(RStoolbox)
library(ggplot2)
library(gridExtra)
library(viridis)
library(rasterVis)
library(rgdal)



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

# 2.1 Unsupervised classification with unsuperClass function: non assegno un valore ai pixel per determinare le classi ma il software raggruppa gruppi di pixel con valori di riflettanza simili

#plotRGB(s2014,4,3,2,stretch="hist") 
#e <- drawExtent(show=TRUE, col="red") #estensione area di Rosignano Marittimo (LI), oggetto Extent
#> e
#class      : Extent
#xmin       : 612410.9
#xmax       : 617274
#ymin       : 4804437
#ymax       : 4810342

e <- extent(612410.9,617274,4804437,4810342) #estensione area di Rosignano

#raster Rosignano 2014
Rosignano2014 <- crop(s2014,e)
#plotRGB(Rosignano2014,4,3,2,stretch="hist")


#salviamo il raster su disco, nella directory di lavoro
writeRaster(Rosignano2014,"Rosignano_landsat8_2014") #estensione .grd e .gri


# UnsuperClass classification based on kmeans algorithm
# Per cogliere il massimo della variabilità dai nostri dati operiamo una PCA

set.seed(50)
pca_2014 <- rasterPCA(Rosignano2014)

#-----------------------------------------------
#summary(pca_2014$model)
#Importance of components:
#                            Comp.1       Comp.2       Comp.3       Comp.4
#Standard deviation     6521.9681174 2678.6703259 735.79621060 3.518617e+02
#Proportion of Variance    0.8428447    0.1421768   0.01072767 2.453208e-03
#Cumulative Proportion     0.8428447    0.9850214   0.99574911 9.982023e-01
#                             Comp.5       Comp.6       Comp.7
#Standard deviation     265.05464657 1.292386e+02 6.137826e+01
#Proportion of Variance   0.00139207 3.309594e-04 7.464819e-05
#Cumulative Proportion    0.99959439 9.999254e-01 1.000000e+00
#------------------------------------------------

#plot(pca_2014$map)
pca12_2014 <- pca_2014$map$PC1+pca_2014$map$PC2 # Comp.1 + Comp.2 = 98.5% of variability
#levelplot(pca12_2014)

#unsupervised classification
set.seed(50)
class2014_3 <- unsuperClass(pca12_2014, nClasses=3) #3 classi per distinguere preliminarmente mare, zone antropizzate e aree verdi.

#par(mfrow=c(1,2))
#plotRGB(Rosignano2014,4,3,2,stretch="hist")
#plot(class2014_3$map)

#Dal confronto con l'immagine RGB si apprezza la differenza tra le 3 classi generate, notando anche la presenza di 3 specchi d'acqua non individuabili altrimenti.
#Aumentando il numero di classi della funzione, è possibile osservare come l'algoritmo riesca a individuare più elementi, tra cui una diversificazione maggiore della vegetazione
set.seed(50)
class2014_6 <- unsuperClass(pca12_2014, nClasses=6) #6 classi
#par(mfrow=c(1,2))
#plotRGB(Rosignano2014,4,3,2,stretch="hist")
#plot(class2014_6$map)

#----------------------------------------------------------------------------
# 2.2 Supervised classification with superClass function and train data with Qgis


#import shapefile train_data, creato con Qgis 
#train.shp è un training set di 27 punti suddivisi nelle 5 classi
# area antropizzata
# coltivazioni
# acqua
# macchia mediterranea
# pino marittimo

#rgdal required
train.shp <- readOGR(dsn="C:/lab/esame",layer="train_data")

Rosignano2014 <- brick("Rosignano_landsat8_2014.grd") #RasterBrick
#> crs(Rosignano2014)
#CRS arguments:
# +proj=utm +zone=32 +datum=WGS84 +units=m +no_defs

#rinomino il nome delle bande del raster
names(Rosignano2014) <- c("ca","blue","green","red","nir","swir1","swir2")

#train.shp ha un crs=longlat, devo convertire il sr in UTM
train_utm <- spTransform(train.shp,crs(Rosignano2014))


# plot Rosignano2014 con i punti del train_data della classificazione
plot(Rosignano2014$nir)
# add train_data to plot
points(train_utm,
     pch = 19,
     cex = 2,
     col = "red")

# il formato dei train data è shapefile (.shp), lo converto in dataframe
#require(rgdal)
#train.df <- as(train_utm, "data.frame")


## Fit classifier (splitting training into 70\% training data, 30\% validation data)
#model = random forest
set.seed(50)
SC_Rosignano2014 <- superClass(Rosignano2014, trainData = train_utm, responseCol = "classe", 
model = "rf", tuneLength = 1, trainPartition = 0.7)

plot(SC_Rosignano2014$map, legend = FALSE, axes = FALSE, box = FALSE)
legend(1,1, legend = levels(train_utm$class) , title = "Classi", 
horiz = TRUE,  bty = "n")


#************ Validation **************
#$validation
#Confusion Matrix and Statistics

#                      Reference
#Prediction             ACQUA AREA ANTROPIZZATA COLTIVAZIONI
#  ACQUA                    1                 0            0
#  AREA ANTROPIZZATA        0                 1            0
#   COLTIVAZIONI            0                 0            1
#   MACCHIA MEDITERRANEA    0                 0            0
#   PINO MARITTIMO          0                 0            0
#                       Reference
# Prediction             MACCHIA MEDITERRANEA PINO MARITTIMO
#   ACQUA                                    0              0
#   AREA ANTROPIZZATA                        0              0
#   COLTIVAZIONI                            0              0
#   MACCHIA MEDITERRANEA                     1              1
#   PINO MARITTIMO                         0              0 
# 
# Overall Statistics 

#                Accuracy : 0.8
#                  95% CI : (0.2836, 0.9949)
#     No Information Rate : 0.2
#     P-Value [Acc > NIR] : 0.00672

#                   Kappa : 0.75
# 
#  Mcnemar's Test P-Value : NA

# Statistics by Class:

#                      Class: ACQUA Class: AREA ANTROPIZZATA Class: COLTIVAZIONI
# Sensitivity                   1.0                      1.0                 1.0
# Specificity                   1.0                      1.0                 1.0
# Pos Pred Value                1.0                      1.0                 1.0
# Neg Pred Value                1.0                      1.0                 1.0
# Prevalence                    0.2                      0.2                 0.2
# Detection Rate                0.2                      0.2                 0.2
# Detection Prevalence          0.2                      0.2                 0.2
# Balanced Accuracy             1.0                      1.0                 1.0
#                      Class: MACCHIA MEDITERRANEA Class: PINO MARITTIMO
# Sensitivity                                1.000                   0.0
# Specificity                                0.750                   1.0
# Pos Pred Value                             0.500                   NaN
# Neg Pred Value                             1.000                   0.8
# Prevalence                                 0.200                   0.2
# Detection Rate                             0.200                   0.0
# Detection Prevalence                       0.400                   0.0
# Balanced Accuracy                          0.875                   0.5

# *************** Map ******************
# $map
# class      : RasterLayer
# dimensions : 197, 162, 31914  (nrow, ncol, ncell)
# resolution : 30, 30  (x, y)
# extent     : 612405, 617265, 4804425, 4810335  (xmin, xmax, ymin, ymax)
# crs        : +proj=utm +zone=32 +datum=WGS84 +units=m +no_defs
# source     : memory
# names      : classe
# values     : 1, 5  (min, max)
# attributes :
#  ID                value
#   1                ACQUA
#   2    AREA ANTROPIZZATA
#   3         COLTIVAZIONI
#   4 MACCHIA MEDITERRANEA
#   5       PINO MARITTIMO








