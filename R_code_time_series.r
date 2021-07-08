#time series analysis
#Greenland increase of temperature
#data and code from Emanuela Cosma

#install.packages("raster")
library(raster)
setwd("C:/lab/greenland")

lst_2000 <- raster("lst_2000.tif") #dataset da importare
lst_2005 <- raster("lst_2005.tif")
lst_2010 <- raster("lst_2010.tif")
lst_2015 <- raster("lst_2015.tif")

#invece di importare singolarmente, creiamo una lista di files e poi usiamo lapply per applicare a ogni elemento della lista la funzione raster
rlist <- list.files(pattern="lst")
import <- lapply(rlist,raster) #importo tutti i raster della lista, import è un oggetto composto dai vari raster importati, che sono ancora però separati

#adesso raggruppo i raster importati singolarmente con la funzione stack in un unico grande file.
TGr <- stack(import) #TGr = temperature Groenlandia

#adesso posso plottare il singolo file che contiene tutti i raster
plot(TGr)

#adesso posso fare plotRGB
plotRGB(TGr, 1,2,3, stretch="lin") #1,2,3 sono rispettivamente il primo, secondo e terzo file, ovvero quelli relativi al 2000, 2005, 2010.

#in questo caso noi non gestiamo i colori, che sono propri delle immagini. Non facciamo altro che sovrapporre tra loro le immagini dei diversi periodi.
#Quindi se vedo del rosso, significa che i valori più alti di temperatura sono relativi al 2000, se vedo verde 2005, se vedo blu 2010 (rispettando l'ordine R G B), siccome l'immagine è piuttosto blu, si evince che le temperature più alte siano quelle relative al 2010
#per vedere il paragone inserendo anche il 2015, farò così
#plotRGB(TGr, 2,3,4, stretch="lin")
