# acquisizione e analisi immagini Copernicus

#lib
#install.packages("ncdf4")

library(raster)
library(ncdf4)

#wd
setwd("C:/lab")

#import
lst <- raster("c_gls_LST_202107100000_GLOBE_GEO_V2.0.1.nc") #land surface temperature global
