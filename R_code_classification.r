# SOLAR ORBITER

setwd("C:/lab")

library(raster)
library(RStoolbox)

so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg") #oggetto rasterBrick : raster multibanda 3 immagini, RGB
so

#visualize RGB levels
plotRGB(so,1,2,3,stretch="Lin") #dall'immagine vedo che ci sono 3 fasce di energia in base alla luce emessa: una bassa, una intermedia e una alta.

#classifichiamo l'immagine nei 3 livelli
#IL TRAINING SET, OVVERO I PUNTI INIZIALI, LI TIRA FUORI IL SOFTWARE -> CLASSIFICAZIONE NON SUPERVISIONATA, nessun intervento dell'utente a monte per decidere le classi, lasciando il sw a creare il training set sulla base delle riflettanza

#se voglio mantenere lo stesso training set allora lo fisso così
#set.seed(42)
soc <- unsuperClass(so, nClasses=3) #sceglie un training set random iniziale. Potrebbe differire da altri output della stessa immagine
plot(soc$map)

#il sw è in grado di dividere anche per 20 classi un'immagine per la quale l'occhio umano non ne vedrebbe così tante
soc_2 <- unsuperClass(so,nClasses=20)
plot(soc_2$map)

#ci sono anche altre classificazioni rispetto a questa, che è basata solo sulla riflettanza

#scaricato da solar orbiter
#Gulf of Matarban
gulf <- brick("Gulf_of_Martaban_Myanmar.jpg")

gulf_cl <- unsuperClass(gulf,nClasses=20)

plot(gulf_cl$map)

### GRAND CANYON: John Wesley Powell expedition in 1869
#problema nuvole: strati mask -> maschere usate per rimuovere gli errori. mask è un raster aggiuntivo da sottrarre all'originale per eliminare rumore (tipo le nuvole), andandolo a dichiarare nella documentazione
#altrimenti si usano sensori diversi, non passivi

gc <- brick("dolansprings_oli_2013088_canyon_lrg.jpg") #E' un RGB con resolution=30m
par(mfrow=c(2,1))
plotRGB(gc,1,2,3,stretch="Lin")
plotRGB(gc,1,2,3,stretch="hist")


#classification
#2 classi
gcc_2 <- unsuperClass(gc,nClasses=2)
cls<-colorRampPalette(c("yellow","red")) (100)
plot(gc_class$map)























