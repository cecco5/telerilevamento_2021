#R_code_vegetation_indices.r

library(raster)
setwd("C:/lab")

defor1 <- brick("defor1.png")
defor2 <- brick("defor2.png")

#sappiamo che per queste immagini
#B1 = NIR
#B2 = RED
#B3 = GREEN

#vediamo la multitemporalità delle due immagini
#par(mfrow=c(2,1))
#plotRGB(defor1,r=1,g=2,b=3,stretch="lin")
#plotRGB(defor2,r=1,g=2,b=3,stretch="lin")

#tutta la parte rossa è vegetazione, la parte chiara è suolo agricolo. Effetto devastante della deforestazione
#CALCOLIAMO L'INDICE DI VEGETAZIONE DVI PER APPLICARLO ALLE DUE IMMAGINI E VEDERNE LA DIFFERENZA

#dvi defor1 = NIR-RED , genero un raster differenza tra i due
dvi1<-defor1$defor1.1 - defor1$defor1.2
#dvi2
dvi2<-defor2$defor2.1 - defor2$defor2.2

cl1 <- colorRampPalette(c("dark blue","yellow","red","black")) (100)

#plotto i due dvi in epoche diverse
#par(mfrow=c(1,2))
#plot(dvi1,col=cl1, main= "DVI at time1")
#plot(dvi2,col=cl1, main="DVI at time2")

#ora mi chiedo quale è stata la differenza tra le due epoche
diff <- dvi1-dvi2
cl2 <- colorRampPalette(c("blue","white","red")) (100)
plot(diff,col=cl2,main="DVI difference")

#dove la mappa è rossa c'è stata una differenza maggiore (in corrispondenza delle aree agricole), in blu le aree meno cambiate, rimaste vegetazione
#in questo caso la differenza è ben visibile, deforestazione. In altri casi la differenza non è così marcata ed è più difficile da marcare

#SE DOBBIAMO USARE IMMAGINI CON UNA RISOLUZIONE DIVERSA, USIAMO L'NDVI CHE E' NORMALIZZATO
#ndvi = (NIR - RED) / (NIR + RED) 
ndvi1 <- (defor1$defor1.1 - defor1$defor1.2)/(defor1$defor1.1 + defor1$defor1.2)
plot(ndvi1, col = cl1, main = "NDVI at time1")

