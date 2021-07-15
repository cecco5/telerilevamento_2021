
#R_code_variability.r

library(raster)
library(RStoolbox) #Remote Sensing toolbox
# install.packages("RStoolbox")
library(ggplot2) # for ggplot plotting
library(gridExtra) # for plotting ggplots together
# install.packages("viridis")
library(viridis) # for ggplot colouring

setwd("C:/lab/")

sent <- brick("sentinel.png")

# NIR 1, RED 2, GREEN 3
# r=1, g=2, b=3

#plotRGB(sent,stretch="lin") 
# plotRGB(sent, r=1, g=2, b=3, stretch="lin")

#associamo un oggetto a ciascuna banda per velocizzare
nir <- sent$sentinel.1
red <- sent$sentinel.2


#ora ho un singolo strato su cui voglio calcolare la std deviation
ndvi <- (nir-red)/(nir+red)
cl <- colorRampPalette(c('black','white','red','magenta','green'))(100) # 
#plot(ndvi,col=cl)
#bianco = non c'è vegetazione
#marroncino = roccia nuda senza vegetazione
#giallo-verde = bosco
#verde scuro = pascoli in alto

#deviazione standard = funzione FOCAL
#argomenti di focal: immagine su cui calcolarla, matrice w che è proprio la window che indichiamo con una isotropia/matrice quadrata, fun= sd deviazione standard
ndvisd3 <- focal(ndvi, w=matrix(1/9, nrow=3, ncol=3), fun=sd) #la moving window entro la quale calcolare le statistiche, nel nostro caso standard deviation 
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100) # 
#plot(ndvisd3, col=clsd)

#mean ndvi with focal, sempre con una moving window di 3x3
ndvi_mean3 <- focal(ndvi, w=matrix(1/9, nrow=3, ncol=3), fun=mean)
#plot(ndvi_mean3, col=clsd)

#proviamo a cambiare la moving window, rimanendo sempre con un numero dispari in modo da avere il pixel centrale. esempio 3x3,5x5,7x7,13x13...
ndvi_sd13 <- focal(ndvi, w=matrix(1/169, nrow=13, ncol=13), fun=sd)
#plot(ndvi_mean13, col=clsd)

#5x5 <- sembra essere la situazione ideale per studiare la deviazione standard.
ndvi_sd5 <- focal(ndvi, w=matrix(1/25, nrow=5, ncol=5), fun=sd)
#plot(ndvi_mean5, col=clsd)

#ESISTE UN'ALTRA TECNICA PER COMPATTARE I DATI OLTRE ALL'NDVI: L'ANALISI DELLE COMPONENTI PRINCIPALI PCA
#faccio un'analisi multivariata su tutto il set, e poi faccio il calcolo della deviazione standard usando il solo strato della PC1, sulla quale facciamo passare la moving window 

sentpca <- rasterPCA(sent) #sentmap = oggetto con $map, $model, $call ecc.
#plot(sentpca$map) #plot della map
summary(sentpca$model) #la PC1 conserva il 67.36% della variabilità

sentpc1 <- sentpca$map$PC1
pc1sd5 <- focal(sentpc1, w=matrix(1/25,nrow=5,ncol=5),fun = sd)
#plot(pc1sd3,col = clsd)


#ESEMPIO UTILIZZO FUNZIONE SOURCE PER RICHIAMARE PEZZI DI CODICE DA ALTRI FILE NELLA WORKING DIRECTORY SENZA DOVERLO SCRIVERE QUI
source("source.r") #richiama gli script esterni all'interno del codice

#GGPLOT vediamo un pò di graficare, colori viridis
p1 <- ggplot() + geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) + scale_fill_viridis()  + ggtitle("Standard deviation of PC1 by viridis colour scale")
#ggplot = finestra vuota
#geom_raster = crea dei raster dentro ggplot, le nostre mappe. args= img, mapping = aesthetics = ciò che plotto nel grafico, ciò che voglio mappare, ovvero la x, la y e il valore. fill= riempimento con il nostro layer

#altri colori , magma    #questo mi evita di dover sempre definire una color ramp palette, adottando le legende di viridis
p2 <- ggplot() + geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) + scale_fill_viridis(option = "magma")  + ggtitle("Standard deviation of PC1 by magma colour scale")

#altri ancora, turbo
p3 <- ggplot() + geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) + scale_fill_viridis(option = "turbo")  + ggtitle("Standard deviation of PC1 by turbo colour scale")

grid.arrange(p1,p2,p3,nrow=1)

#vediamo che la parte in alto a sinistra, che conserva molta diversità geografica e discontinuità del terreno (crepacci ecc.) e con la dev. standard la vedo molto bene. La nuvola che sorvola questa zona, essendo molto omogenea è tutta dello stesso colore, bassissima variabilità
