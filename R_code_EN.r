# R_code_EN.r 

#immagini da gennaio a fine marzo del 2020, già preprocessate
setwd("C:/lab/EN")

#siamo interessati solo alla prima banda, quindi importeremo solo quella con la funzione raster
#lib
library(raster)
library(RStoolbox) #for PCA
library(rasterVis) #for levelplot function

#first image: january
en_0001 <- raster("EN_0001.png") #prima banda
#levelplot(en_0001)

#last image: march
en_0013 <- raster("EN_0013.png")
#levelplot(en_0013)

#makes the difference
en_diff <- en_0001 - en_0013
#levelplot(en_diff)

cl<-colorRampPalette(c("red","white","black")) (100)
par(mfrow=c(3,1))
plot(en_0001,col=cl,main="prima")
plot(en_0013,col=cl,main="dopo")
plot(en_diff,col=cl,main="differenza")

#adesso importiamo l'intero set con stack
rlist <- list.files(pattern="EN") #creo la listaconcatenata delle bande (rasterLayer)
import <- lapply(rlist,raster) #importo nell'oggetto import tutte le bande. import è un vettore di oggetti rasterLayer
azoto <- stack(import) #unifico tutte le bande in un solo oggetto rasterStack

#plot di tutti i layer
levelplot(azoto)
par(mfrow=c(2,1))
p1<-azoto$EN_0001
p2<-azoto$EN_0013
plot(p1,col=cl,main="Gennaio")
plot(p2,col=cl,main="Marzo")

#ANALISI MULTIVARIATA -> PCA sul set di 13 bande
#prima riduciamo le dimensioni di azoto per poter applicare la PCA
azoto_res <- aggregate(azoto,fact=10) #ridotta di un fattore 10Pc
levelplot(azoto_res)

azoto_pca<-rasterPCA(azoto_res) #creo un oggetto rasterBrick con le varie componenti PC1,PC2...PC13
summary(azoto_pca$model) #per vedere quanta variabilità è contenuta nelle varie componenti

#la PC1 conserva l'85% di variabilità

#                            Comp.1     Comp.2      Comp.3      Comp.4 ...
#Standard deviation     142.8566809 30.6417008 25.01753201 23.96414627
#Proportion of Variance   0.8505061  0.0391293  0.02608346  0.02393317
#Cumulative Proportion    0.8505061  0.8896353  0.91571881  0.93965198

#levelplot(azoto_pca$map) #plotto la map per vedere la variabilità nelle varie componenti
plotRGB(azoto_pca$map,r=1,g=2,b=3,stretch="lin") #la zona rossa indica quella che ha mantenuto più o meno gli stessi valori

#CALCOLIAMO LA VARIABILITA' NELLA PRIMA E NELL'ULTIMA IMMAGINE E VEDO COME QUESTA VARIA TRA GENNAIO E MARZO
#la calcolo sulla prima componente PC1 che detiene la maggior variabilità
pc1 <- azoto_pca$map$PC1
pc1_std5 <- focal(pc1,w=matrix(1/25,nrow=5,ncol=5),fun=sd)
levelplot(pc1_std5)

#metodo di lavoro impostato

