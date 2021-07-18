# R_code_spectral_signature.r

library(raster)
library(rasterVis)
library(RStoolbox) #PER PLOT RGB
library(rgdal) #molto usato per i vettori in R
library(ggplot2)


setwd("C:/lab")


defor2 <- brick("defor2.png") #IMPORTO DEFOR2, raster multibanda

#sappiamo che per queste immagini
#B1 = NIR
#B2 = RED
#B3 = GREEN

plotRGB(defor2, r=1,g=2,b=3,stretch="hist") #plot

#UTILIZZIAMO QUESTA IMG PER CREARE LE FIRME SPETTRALI CON LA FUNZIONE CLICK()
#click -> query by clicking on a map: args= map, id (inserisce un identificativo) = true, xy=true (è una mappa), cell=T -> SIGNIFICA CHE ANDIAMO A CLICCARE SU UN PIXEL
#type=P (clicchiamo su un punto), pch(point character) = 16 (è il tipo di pallino, il 16 è un tondino), col=yellow.

click(defor2, id=T , xy=T , cell=T , type="p" , pch=16, col="yellow") #OVVIAMENTE CLICK VA LANCIATA SU R UNA VOLTA CHE HO GIA' LANCIATO IL PLOT DELL'IMMAGINE 

#CLICCO SU UN PIXEL DEL'IMMAGINE, IN CORRISPONDENZA DI VEGETAZIONE

#OUTPUT
#       x     y   cell defor2.1 defor2.2 defor2.3
# 1 149.5 252.5 161475      195       18       34

#su questa immagine, che è a 8 bit, il range di riflettanza è 0<x<255. Sull'infrarosso, avendo preso una parte vegetale, ho un alto livello di riflettanza
#nello spettro del visibile, la vegetazione mi appare verde e non rossa perchè il valore di riflettanza nel rosso è 18 ed è minore di quella del verde che è 34

#RIFACCIO UN CLICK SU UNA ZONA DI ACQUA

#       x     y   cell defor2.1 defor2.2 defor2.3
# 1 209.5 162.5 226065       27       35       81

#la riflettanza nel verde è la più alta. se avessi avuto anche il blu avrei avuto un valore molto alto. (molto bassa nel NIR)

#per chiudere la funzione, basta chiudere l'immagine



#------------------creiamo un dataset-------------------------#
#creiamo la tabella e poi con GGplot otterremo le nostre firme spettrali

#3 colonne: BANDA, FORESTA, ACQUA
bande <- c(1,2,3)
foresta <- c(195,18,34)
acqua <- c(27,35,81)

#creo la tabella
spectrals <- data.frame(bande,foresta,acqua)

#PLOT THE SPECTRAL SIGNATURES, ggplot prepara il grafico, geom_line() aggiunge le componenti del grafico
ggplot(spectrals, aes(x=bande)) + 
        geom_line(aes(y=foresta),color="green") + 
        geom_line(aes(y=acqua),color="blue") +
        labs(x="lunghezza d'onda",y="riflettanza")

#in questo modo: BLU = FIRMA SPETTRALE DELL'ACQUA
               # VERDE = FIRMA SPETTRALE FORESTA

#potremmo fare un'analisi multitemporale della firma

#-----------------------multitemporal con defor1 e defor2----------------------------------#
defor1 <- brick("defor1.png")
defor2 <- brick("defor2.png")
#plotRGB(defor1,1,2,3,stretch"lin")
#plotRGB(defor2,1,2,3,stretch="lin")

#spectral signatures defor1
plotRGB(defor1,1,2,3,stretch="lin")
click(defor1, id=T,xy=T,cell=T,type="p",pch=16,col="yellow")

#clicco su 5 punti in una zona che ha subito notevole variazione nel tempo, per esempio sopra l'ansa del fiume, sulla sx
#OUTPUT
#     x     y  cell defor1.1 defor1.2 defor1.3
#1 55.5 349.5 91448      171       65       75
#     x     y  cell defor1.1 defor1.2 defor1.3
#1 73.5 348.5 92180      178       70       68
#     x     y  cell defor1.1 defor1.2 defor1.3
#1 79.5 359.5 84332      169       61       76
#     x     y  cell defor1.1 defor1.2 defor1.3
#1 68.5 361.5 82893      176      110      112
#     x     y   cell defor1.1 defor1.2 defor1.3
#1 62.5 335.5 101451      218        0       26

#prendo ora 5 punti nella stessa zona su defor2
plotRGB(defor2,1,2,3,stretch="lin")
click(defor2, id=T,xy=T,cell=T,type="p",pch=16,col="yellow")

#     x     y  cell defor2.1 defor2.2 defor2.3
#1 49.5 352.5 89675      222      177      172
#     x     y  cell defor2.1 defor2.2 defor2.3
#1 44.5 359.5 84651      175      172      157
#     x     y  cell defor2.1 defor2.2 defor2.3
#1 75.5 358.5 85399      205      183      172
#     x     y  cell defor2.1 defor2.2 defor2.3
#1 59.5 364.5 81081      226      196      196
#     x     y  cell defor2.1 defor2.2 defor2.3
#1 67.5 345.5 94712      173      175      162

#CREO IL DATASET con primo pixel di entrambe le immagini per semplicità
bande_2 <- c(1,2,3)
time1 <- c(171,65,75)
time2 <- c(222,177,172)


spectrals_2 <- data.frame(bande_2,time1,time2)

#plottaggio firme

ggplot(spectrals_2, aes(x=bande_2)) + 
        geom_line(aes(y=time1),color="magenta") + 
        geom_line(aes(y=time2),color="black") +
        labs(x="lunghezza d'onda",y="riflettanza")

#a questa posso aggiungere i valori di altri pixel, già si vede la differente firma spettrale della stessa zona che, in time1 è rigogliosa (alta riflettanza nir), e in time2 questa è decisamente meno verde, per cui il nir ha riflettanza più bassa

#le firme spettrali sono utili perchè classificano e differenziano elementi, ciascuno dei quali ha una propria firma unica.


















