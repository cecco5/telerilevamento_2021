# acquisizione e analisi immagini Copernicus

#lib
#install.packages("ncdf4")

library(raster)
library(ncdf4)

#wd
setwd("C:/lab")

#import
lst <- raster("c_gls_LST_202107100000_GLOBE_GEO_V2.0.1.nc") #land surface temperature global

#abbiamo un singolo strato quindi il colore lo decidiamo noi con una colorRampPalette

cl <- colorRampPalette(c("light blue","green","red","yellow")) (100)
plot(lst,col=cl)

#funzione aggregate -> ricampionamento dell'immagine per alleggerirne il peso. args fact = 10 -> 10x10 = 100 pixels per fare la media
lst_agg <- aggregate(lst,fact=50) #immagine RESAMPLED = RICAMPIONATA
lst_agg
plot(lst_agg,col=cl)
