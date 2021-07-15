#R_code_land_cover

#lib
#install.packages("ggplot2")
library(ggplot2) #plot accattivante dei raster
#install.packages("gridExtra")
library(RStoolbox) #classification
library(raster)
library(gridExtra) #per usare la funzione grid.arrange


setwd("C:/lab")

#immagini con NIR=1, RED=2, GREEN=3

defor1<-brick("defor1.png")
#plotRGB(defor1, r=1,g=2,b=3, stretch="lin")
#usiamo ggRGB del pacchetto ggplot
ggRGB(defor1,1,2,3,stretch="lin") #plotto con questa anche le coordinate spaziali del nostro oggetto

defor2<-brick("defor2.png")
ggRGB(defor2,1,2,3,stretch="lin")

#multiframe with ggplot2 e gridExtra
p1=ggRGB(defor1,1,2,3,stretch="lin")
p2=ggRGB(defor2,1,2,3,stretch="lin")
#grid.arrange(p1,p2,nrow=2)

#UNSUPERVISED CLASSIFICATION
#ricapitolando: la parte rossa (su cui abbiamo montato il NIR) è vegetazione, la parte chiara è quella agricola

d1c<-unsuperClass(defor1, nClasses = 2)
d2c<-unsuperClass(defor2, nClasses = 2)
plot(d1c$map) #con 2 classi il sw ha associato la foresta a una classe (chiara) e la zona agricola+fiume all'altra (verde) -> questo è dipeso dalla riflettanza del fiume, che avendo molti sedimenti aveva una riflettanza molto simile alle zone agricole
#con la funzione set.seed io fisso il numero di training set per mantenere gli stessi parametri
#class1 = foresta
#class2 = aree agricole
plot(d2c$map)


#ANDIAMO A CALCOLARE QUANTA FORESTA ABBIAMO PERSO
#vogliamo calcolare la frequenza dei pixel di una certa classe. Quante volte ho i pixel della classe foresta? quanti nella agricola?
#funzione FREQUENZA: freq(image$map)

#frequencies
f1<-freq(d1c$map)
#        value  count
#[1,]     1  35557
#[2,]     2 305735

#pixel totali defor1, scritto anche nella map
s1 <- 35557+305735

#proporzione della defor1
prop1 = f1/s1
#prop1
#            value     count
#[1,] 2.930042e-06 0.1041835
#[2,] 5.860085e-06 0.8958165

#prop foresta classe2 = 89.5%
#prop agricola classe1 = 10.4%

#pixel totali defor2
s2<-342726
f2<-freq(d2c$map)
#proporzione della defor2
prop2 = f2/s2
#prop foresta classe2 = 51.8%
#prop agricola classe1 = 48.1%

# SI E' QUINDI PERSO CIRCA IL 40% DI FORESTA


#--------------------------CREIAMO UN DATASET------------------------------#

#VETTORE che chiamo cover
cover <- c("Forest","Agriculture")
percent_1992 <- c(89.5,10.4)
percent_2006 <- c(51.8,48.1)

#così ho definito le 3 colonne
#creo il dataframe con la funzione data.frame( )

percentages <- data.frame(cover, percent_1992, percent_2006) #CREATO!

#adesso usiamo ggplot per fare un bel grafico
p1992 <- ggplot(percentages, aes(x=cover, y=percent_1992, color=cover)) + geom_bar(stat="identity", fill="blue") #color si riferisce a quale oggetto vogliamo discriminare nel grafico, nel nostro caso le 2 classi
p2006 <- ggplot(percentages, aes(x=cover, y=percent_2006, color=cover)) + geom_bar(stat="identity", fill="red")

#geom_bar -> perchè vogliamo delle barre nel grafico che indichino le percentuali, stat="identity" -> uso i dati proprio come li ho messi nella funzione

#per mettere entrambi in una pagina, uso grid.arrange
grid.arrange(p1992,p2006,nrow=1)











































