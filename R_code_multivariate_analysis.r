#MULTIVARIATE ANALYSIS
#lib
library(raster)
library(RStoolbox)

#wd
setwd("C:/lab")

#immagine landsat, è un raster multibanda. RICORDA: raster -> funzione che importa un solo rastermonobanda, brick -> importa un raster multibanda
p224r63_2011 <- brick("p224r63_2011.grd")

#BANDE LANDSAT
#B1 -> BLUE
#B2 -> GREEN
#B3 -> RED
#B4 -> NIR
#B5 -> MEDIO IR
#B6 -> TIR
#B7 -> MEDIO IR

#plottiamo la banda del blu contro quella del verde 
plot(p224r63_2011$B1_sre,p224r63_2011$B2_sre,col="blue",pch="16",cex=2)

#NOTO TUTTI PUNTI MOLTO ADDENSATI LUNGO UNA DIREZIONE. 
#MULTICOLLINEARITA' NELLE MIE OSSERVAZIONI QUINDI

#invece di plottare una singola banda contro un altra, per vederle tutte e osservare la correlazione tra loro, uso la funzione PAIRS
pairs(p224r63_2011)

#osservando anche il coefficiente di Pearson di correlazione, noto che alcune di queste bande tra loro sono fortemente correlate (non tutte)

#la mia immagine ha 7 bande tutte correlate tra loro
#la PCA mi permette di ridurre il sistema da 2 a 1 variabile, giacchè la PC1 da sola raccoglie il 90% della variabilità totale
#siccome la PCA è molto impattante in termini di calcolo, è preferibile ridurre le dimensioni del file, e quindi dei pixel, per alleggerire l'analisi
p224r63_2011res <- aggregate(p224r63_2011, fact=10) #resampled

#adesso PCA. prendiamo i dati originali, tracciamo due assi, uno lungo la variablità maggiore e uno la minore (PC1 e PC2), riducendo il sistema di una dimensione
#funzione rasterPCA del pacchetto RStoolbox
p224r63_2011res_PCA <- rasterPCA(p224r63_2011res)

#per osservare il modello dell'oggetto generato, ne genero un sommario con la funzione summary
#in questo modo vedo quanta varianza c'è in ciascuna delle bande
summary(p224r63_2011res_PCA$model)
#vedo che la prima componente da sola spiega il 99,22% di variabilità

#a questo punto, plottando la map, vedrò che la prima componente, PC1 da sola già contiene "tutta" l'informazione, ovvero il massimo della variabilità. L'ultima, la PC7, quasi nulla
plot(p224r63_2011res_PCA$map)

#LA PCA QUINDI NON FA ALTRO CHE RIDURRE LA CORRELAZIONE FORTE CHE INTERCORRE INIZIALMENTE TRA LE BANDE. RIDUCE LA DIMENSIONALITA' DELL'INPUT E PERMETTE UNA INTERPRETABILITA' MAGGIORE DEI DATI, SENZA INTRODURRE ERRORE

plotRGB(p224r63_2011res_PCA$map, r=1,g=2,b=3, stretch="lin") #plotRGB dove assegno alla banda del rosso la PC1, del verde la PC2 e al blu la PC3, immagine risultante da analisi PCA
#la prima componente è quella che contiene più variabilità

#RIPRENDENDO LA CLASSIFICAZIONE, LA PCA E' UTILE PROPRIO PER INDIVIDUARE DIVERSI ELEMENTI NELL'IMMAGINE, RACCOGLIENDO LA MAGGIOR PARTE DELLA VARIABILITA'
#ad esempio la neve, i pascoli ad alta quota, la vegetazione più fitta a valle ecc...
#quindi la PCA divide le varie bande spettrali dell'immagine e altri algoritmi accorpano i pixel così differenziati definendo delle classi

#dunque se ho un DATA CUBE (immagine iperspettrale con centinaia di bande a disposizione), posso compattare tutte queste bande in un numero più contenuto per poter poi fare analisi



#plot una banda contro l'altra
plot(p224r63_2011res_PCA$map$PC1,p224r63_2011res_PCA$map$PC2)
#vedo che tra PC1 e PC2 non vi è alcuna correlazione

#FUNZIONE str(filename) -> info sulla struttura e l'intero file




























