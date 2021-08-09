#R_code_exam_project.r

#------------------------------------------------------------
#PROGETTO ESAME FINALE TELERILEVAMENTO GEOECOLOGICO: ANALISI IMMAGINI LANDSAT 8 - CASTIGLIONCELLO (LI)

# Summary
#1  Scaricamento + IMPORT immagini satellitari Toscana, dati Landsat 8 OLI-TIRS Collection2 Livello2
#2  Classificazione e confronto land cover supervised e unsupervised classification methods (package RStoolbox)
#3  Indice di vegetazione NDVI e analisi multi-temporale 2014 - 2021 della zona d'interesse
 


#----------------------------------------------------------------
 


setwd("C:/lab/esame")

library(raster)
library(RStoolbox)
library(ggplot2)
library(gridExtra)
library(viridis)
library(rasterVis)
library(rgdal)



#1 IMPORT IMMAGINI TOSCANA TELERILEVATE DA SISTEMA LANDSAT 8 OLI-TIRS COLLECTION 2 LEVEL 2


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

# 2 Unsupervised classification with unsuperClass function: non assegno un valore ai pixel per determinare le classi ma il software raggruppa gruppi di pixel con valori di riflettanza simili

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


# UnsuperClass classification based on k-means algorithm
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

#Dal confronto con l'immagine RGB si apprezza la differenza tra le 3 classi generate, 
#notando anche la presenza di 3 specchi d'acqua non individuabili altrimenti.
#Aumentando il numero di classi della funzione, è possibile osservare come l'algoritmo riesca 
#a individuare più elementi, tra cui una diversificazione maggiore della vegetazione
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
train.shp <- readOGR(dsn="C:/lab/esame",layer="train_data") #train data

Rosignano2014 <- brick("Rosignano_landsat8_2014.grd") #RasterBrick
#> crs(Rosignano2014)
#CRS arguments:
# +proj=utm +zone=32 +datum=WGS84 +units=m +no_defs

#rinomino il nome delle bande del raster
names(Rosignano2014) <- c("ca","blue","green","red","nir","swir1","swir2")

#train.shp ha un crs=longlat, devo convertire il sr in UTM
train_utm <- spTransform(train.shp,crs(Rosignano2014))


# plot Rosignano2014$nir con i punti del train_data della classificazione
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

#model : rf random forest, mlc maximum likelihood

#SuperClass performs the following steps:

#    Ensure non-overlap between training and validation data. This is neccesary to avoid biased performance estimates. A minimum distance (minDist) in pixels can be provided to enforce a given distance between training and validation data.

  #  Sample training coordinates. If trainData (and valData if present) are SpatialPolygonsDataFrames superClass will calculate the area per polygon and sample nSamples locations per class within these polygons. The number of samples per individual polygon scales with the polygon area, i.e. the bigger the polygon, the more samples.

  #  Split training/validation If valData was provided (reccomended) the samples from these polygons will be held-out and not used for model fitting but only for validation. If trainPartition is provided the trainingPolygons will be divided into training polygons and validation polygons.

   # Extract raster data The predictor values on the sample pixels are extracted from img

   # Fit the model. Using caret::train on the sampled training data the model will be fit, including parameter tuning (tuneLength) in kfold cross-validation. polygonBasedCV=TRUE will define cross-validation folds based on polygons (reccomended) otherwise it will be performed on a per-pixel basis.

  #  Predict the classes of all pixels in img based on the final model.

   # Validate the model with the independent validation data.


#plot(SC_Rosignano2014$map, legend = FALSE, axes = FALSE, box = FALSE)
#legend(1,1, legend = levels(SC_Rosignano2014$map) , title = "Classi", 
#horiz = TRUE,  bty = "n")


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


#DALL'ATTRIBUTO VALIDATION DELL'OGGETTO superClass si osserva che l'accuratezza del modello di classificazione adottato è di 0.8 su una scala da 0 a 1

#APPLICHIAMO LO STESSO MODELLO ALLE IMMAGINI DEL 2021
#e <- extent(612410.9,617274,4804437,4810342) #estensione area di Rosignano

#raster Rosignano 2021
Rosignano2021 <- crop(s2021,e)

#salviamo il raster su disco, nella directory di lavoro
writeRaster(Rosignano2021,"Rosignano_landsat8_2021") #estensione .grd e .gri


set.seed(50)
pca_2021 <- rasterPCA(Rosignano2021)

#-----------------------------------------------
#> summary(pca_2021$model)
#Importance of components:
#                             Comp.1       Comp.2       Comp.3       Comp.4
#Standard deviation     5812.0078009 2516.1305269 732.53029770 3.533915e+02
#Proportion of Variance    0.8267662    0.1549518   0.01313353 3.056627e-03
#Cumulative Proportion     0.8267662    0.9817180   0.99485151 9.979081e-01
#                             Comp.5       Comp.6       Comp.7
#Standard deviation     2.505874e+02 1.401603e+02 5.503710e+01
#Proportion of Variance 1.536912e-03 4.808177e-04 7.413809e-05
#Cumulative Proportion  9.994450e-01 9.999259e-01 1.000000e+00
#------------------------------------------------

#APPLICAZIONE MODELLO DI CLASSIFICAZIONE 2014 AL 2021: predict.unsuperClass (RStoolbox)

pca12_2021 <- pca_2021$map$PC1+pca_2021$map$PC2 # Comp.1 + Comp.2 = 98% of variability
#levelplot(pca12_2021)

#applico il modello di classificazione non supervisionata (K-means) applicato per le immagini del 2014 a quelle del 2021 (senza di fatto rilanciare la classificazione).
class2021_3 <- predict(class2014_3,pca12_2021) #3 classi
class2021_6 <- predict(class2014_6,pca12_2021) #6 classi

#confronto tra la classificazione del 2014 e la previsione applicando lo stesso modello al 2021
#3 classi
#par(mfrow=c(2,1))
#plot(class2014_3$map)
#plot(class2021_3)

#6 classi
#par(mfrow=c(2,1))
#plot(class2014_6$map)
#plot(class2021_6)

#ANDIAMO A CALCOLARE LE FREQUENZE PER LE 3 CLASSI NEGLI ANNI 2014 E 2021 OTTENUTE CON LA CLASSIFICAZIONE NON SUPERVISIONATA E CONFRONTIAMOLE 
f2014<-freq(class2014_3$map)

#> f2014
#     value count
#VEGETAZIONE        [1,]     1 15048
#ACQUA              [2,]     2 10561
#AREA ANTROPIZZATA  [3,]     3  6305

#> prop<-f2014/(ncell(class2014_3$map))
#> prop
#            value     count
#[1,] 3.133421e-05 0.4715172
#[2,] 6.266842e-05 0.3309206
#[3,] 9.400263e-05 0.1975622

f2021<-freq(class2021_3)
# STESSE CLASSI
#> f2021
#     value count
#[1,]     1 15588
#[2,]     2 10959
#[3,]     3  5367

#> prop2
#            value     count
#[1,] 3.133421e-05 0.4884377
#[2,] 6.266842e-05 0.3433916
#[3,] 9.400263e-05 0.1681707



#VETTORE che chiamo cover
cover <- c("VEGETAZIONE","ACQUA","AREA ANTROPIZZATA")
percent_2014 <- c(47.15,33.09,19.76)
percent_2021 <- c(48.84,34.34,16.82)

#così ho definito le 3 colonne
#creo il dataframe con la funzione data.frame( )

percentages <- data.frame(cover, percent_2014, percent_2021) 

#adesso usiamo ggplot per graficare
p2014 <- ggplot(percentages, aes(x=cover, y=percent_2014, color=cover)) + geom_bar(stat="identity", fill="blue") #color si riferisce a quale oggetto vogliamo discriminare nel grafico, nel nostro caso le 2 classi
p2021 <- ggplot(percentages, aes(x=cover, y=percent_2021, color=cover)) + geom_bar(stat="identity", fill="red")

#geom_bar -> perchè vogliamo delle barre nel grafico che indichino le percentuali, stat="identity" -> uso i dati proprio come li ho messi nella funzione

#per mettere entrambi in una pagina, uso grid.arrange
grid.arrange(p2014,p2021,nrow=1)



par(mfrow=c(2,1))
plot(class2014_3$map, main="2014 Unsupervised Classification")
plot(class2021_3, main="2021 Unsupervised Classification (2014 model)")



#------------------------------------------------------------------------------------------------------------------------------------------------------#
#ANALISI MULTITEMPORALE NDVI AGOSTO 2014 - 2020


setwd("C:/lab/esame")

library(raster)
library(RStoolbox)
library(ggplot2)
library(gridExtra)
library(viridis)
library(rasterVis)
library(rgdal)


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
s2014 <- stack(list2014)   


#2020
list2020 <- list.files(pattern="20200822")
s2020 <- stack(list2020)

#ritaglio l'area di Rosignano
e <- extent(612410.9,617274,4804437,4810342) #estensione area di Rosignano

#raster Rosignano 2014
s2014e <- crop(s2014,e)
s2020e <- crop(s2020,e)


#Rinomino i miei raster multibanda
Rosignano2014 <- s2014e
Rosignano2020 <- s2020e

#Rinomino le bande
names(Rosignano2014) <- c("ca","blue","green","red","nir","swir1","swir2")
names(Rosignano2020) <- c("ca","blue","green","red","nir","swir1","swir2")

# -1<=NDVI<=+1

#NDVI 2014
ndvi_2014 <- (Rosignano2014$nir-Rosignano2014$red)/(Rosignano2014$nir+Rosignano2014$red)
ndvi_2014 <- spectralIndices(Rosignano2014,blue="blue",green="green",red="red",nir="nir",swir2="swir2",index="NDVI")

#NDVI 2020
ndvi_2020 <- (Rosignano2020$nir-Rosignano2020$red)/(Rosignano2020$nir+Rosignano2020$red)
ndvi_2020 <- spectralIndices(Rosignano2020,blue="blue",green="green",red="red",nir="nir",swir2="swir2",index="NDVI")

cls <- colorRampPalette(c("blue","white","red")) (100)
#par(mfrow=c(1,2))
#plot(ndvi_2014,col=cls, main="NDVI 2014")
#plot(ndvi_2020,col=cls, main="NDVI 2020")


#CALCOLO LA DIFFERENZA PER EVIDENZIARE LE AREE CHE HANNO SUBITO UNA VARIAZIONE MAGGIORE

ndiv_diff <- ndvi_2014-ndvi_2020
#plot(ndiv_diff,col=cls,main="NDVI variation August 2014- August 2020")




#ISTOGRAMMA DI DISTRIBUZIONE DEI VALORI DI NDVI
# view distribution of NDVI values
par(mfrow=c(2,1))
hist(ndvi_2014,
  main = "NDVI distribution 2014",
  col = "springgreen",
  xlim=c(-1,1),
  ylim=c(0,8000),
  xlab = "NDVI Index Value")
  
hist(ndvi_2020,
  main = "NDVI distribution 2020",
  col = "blue",
  xlim=c(-1,1),
  ylim=c(0,8000),
  xlab = "NDVI Index Value")
  

#funzione spectralIndices (RStoolbox) per il calcolo del NDWI2 = normalized difference water index, utile per osservare il contenuto di acqua delle foglie.
#insieme al NDVI, questi due indici possono fornire indicazioni riguardo lo stato di salute della vegetazione e il livello di siccità nell'area
#NDWI2=(nir - swir2)/(nir + swir2)


#osserviamo i due indici a confronto nell'area di interesse in agosto 2020 e osserviamo la correlazione che intercorre tra loro con la funzione pairs
indici_2020 <- spectralIndices(Rosignano2020,blue="blue",green="green",red="red",nir="nir",swir2="swir2",indices=c("NDVI","NDWI2"))
plot(indici_2020, col=cls)

#si puà già osservare un'alta correlazione tra i due valori in quanto entrambi rilevano comunque lo stato di salute della vegetazione, in rosso.
pairs(indici_2020) #Coefficiente di correlazione pari a 0.98, forte correlazione positiva.

#restringendo l'area di interesse alla zona boscosa a nord del paese (Poggio Pelato 378 m s.l.m.) possiamo osservare meglio lo stato della vegetazione e interpretare l'NDVI 
#della macchia

#e <- drawExtent(show=TRUE, col="red") #estensione area di Poggio Pelato
#> e
#class      : Extent
#xmin       : 615047.4
#xmax       : 616789.3
#ymin       : 4808530
#ymax       : 4809902

poggio_2014 <- crop(Rosignano2014,e)
writeRaster(poggio_2014,"poggio_pelato_landsat8_2014")
poggio_2020 <- crop(Rosignano2020,e)
writeRaster(poggio_2020,"poggio_pelato_landsat8_2020")

indici_poggio_2014 <- spectralIndices(poggio_2014,blue="blue",green="green",red="red",nir="nir",swir2="swir2",indices=c("NDVI","NDWI2"))
indici_poggio_2020 <- spectralIndices(poggio_2020,blue="blue",green="green",red="red",nir="nir",swir2="swir2",indices=c("NDVI","NDWI2"))

#alta correlazione tra NDVI e NDWI2
pairs(indici_poggio_2014) 
pairs(indici_poggio_2020)

#ISTOGRAMMA DI DISTRIBUZIONE DEI VALORI DI NDVI
# view distribution of NDVI values
par(mfrow=c(2,1))
hist(indici_poggio_2014$NDVI,
  main = "NDVI distribution 2014 Poggio Pelato",
  col = "springgreen",
  xlim=c(0,0.5),
  ylim=c(0,1000),
  xlab = "NDVI Index Value")
  
hist(indici_poggio_2020$NDVI,
  main = "NDVI distribution 2020 Poggio Pelato",
  col = "blue",
  xlim=c(0,0.5),
  ylim=c(0,1000),
  xlab = "NDVI Index Value")



#I VALORI DI NDVI SIA NEL 2014 CHE NEL 2020 SI ASSESTANO TRA 0 E 0.5, CIO' INDICA UNA VIGORIA VEGETALE PIUTTOSTO BASSA DELLA MACCHIA MEDITERRANEA IN QUESTA ZONA

#> indici_poggio_2014
#class      : RasterBrick
#dimensions : 46, 58, 2668, 2  (nrow, ncol, ncell, nlayers)
#resolution : 30, 30  (x, y)
#extent     : 615045, 616785, 4808535, 4809915  (xmin, xmax, ymin, ymax)
#crs        : +proj=utm +zone=32 +datum=WGS84 +units=m +no_defs
#source     : memory
#names      :        NDVI,       NDWI2
#min values :  0.14352991, -0.03370653
#max values :   0.4855575,   0.4243759


#> indici_poggio_2020
#class      : RasterBrick
#dimensions : 46, 58, 2668, 2  (nrow, ncol, ncell, nlayers)
#resolution : 30, 30  (x, y)
#extent     : 615045, 616785, 4808535, 4809915  (xmin, xmax, ymin, ymax)
#crs        : +proj=utm +zone=32 +datum=WGS84 +units=m +no_defs
#source     : memory
#names      :        NDVI,       NDWI2
#min values : 0.108313131, 0.009376493
#max values :   0.4655710,   0.4144954











































