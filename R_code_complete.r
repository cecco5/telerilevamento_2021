#R_code_complete_TELERILEVAMENTO_GEO-ECOLOGICO2021


#------------------------------------------#

#   Summary

# 1.  Remote sensing first code
# 2.  R code time series
# 3.  R code Copernicus 
# 4.  R code knitr
# 5.  R code multivariate analysis
# 6.  R code classification
# 7.  R code ggplot2
# 8.  R code vegetation indices
# 9.  R code land cover
# 10. R code variability temp
# 11. R code spectral signatures


#------------------------------------------#

# 1.  Remote sensing first code


######## DAY1
# My first code in R for remote sensing!

# install.packages("raster")    #installo il pacchetto raster
library(raster)   #carico il pacchetto raster con le sue funzioni 
setwd("C:/lab")   #setto la cartella di lavoro in R
image <- brick("p224r63_2011_masked.grd")   #importo i dati di lavoro in R che genera un oggetto RasterBrick dal file
plot(image)   #stampo l'immagine
######## DAY2
#cl <- colorRampPalette(c("black","grey","light grey")) (100)    #permette di cambiare i colori di un raster, in questo caso dal nero al grigio chiaro. cl è un array di 100 posizioni con colori che variano da nero a grigio chiaro
plot(image, col=cl)   #stampo il raster con i nuovi colori

#cl2 <- colorRampPalette(c("blue","green","magenta","yellow")) (100)
plot(image, col=cl2)    #col è uno dei tanti argomenti di plot per assegnare un array di colori

######## DAY3

# Bande Landsat
# B1: blu
# B2: verde
# B3: rosso
# B4: infrarosso vicino
# B5: infrarosso medio
# B6: infrarosso termico
# B7: infrarosso medio
# dev.off will clean the current graph
# dev.off()

#plottiamo solo nella banda del blu, si fa così
plot(image$B1_sre) # il simbolo $ lega una sola banda all'immagine del raster da visualizzare che è multibanda

#Se voglio visualizzare un'immagine con solo 2 bande, la 1 e la 2 vicine, utilizzo la funzione par() alla quale assegno come argomento un array che indica le righe e le colonne per visualizzare le bande. In questo caso 1 riga e 2 colonne

par(mfrow=c(1,2)) #c è un array, un vettore per visualizzare le due bande una accanto all'altra
plot(image$B1_sre)
plot(image$B2_sre)

# se volessi due righe e una colonna
par(mfrow=c(2,1))
plot(image$B1_sre)
plot(image$B2_sre)

# se volessi una 2x2
par(mfrow=c(2,2))
plot(image$B1_sre)
plot(image$B2_sre)
plot(image$B3_sre)
plot(image$B4_sre)

#creo una palette con i colori del blu per la banda B1 del blu, verde per B2, rosso B3 e anche un altro colore per B4
#scegliamo quindi noi come e dove plottare le immagini
par(mfrow=c(2,2))
clb <- colorRampPalette(c("dark blue","blue","light blue")) (100)
plot(image$B1_sre,col=clb)

clg <- colorRampPalette(c("dark green","green","light green")) (100)
plot(image$B2_sre,col=clg)

clr <- colorRampPalette(c("dark red","red","pink")) (100)
plot(image$B3_sre,col=clr)

clnir <- colorRampPalette(c("red","orange","yellow")) (100)
plot(image$B4_sre,col=clnir)

#### DAY4
# visualizing data by RGB plotting

# Bande Landsat
# B1: blu
# B2: verde
# B3: rosso
# B4: infrarosso vicino
# B5: infrarosso medio
# B6: infrarosso termico
# B7: infrarosso medio

#Funzione plot RGB per plottare un'immagine nelle 3 componenti rosso, verde e blu con un range ciascuno compreso tra 0 e max

#stretch = serve a tirare la riflettanza di una immagine sull'intervallo intero
plotRGB(image,r=3,g=2,b=1, stretch="Lin") #default posso scrivere anche 1,2,3 senza indicare r,g e b negli argomenti di plotRGB, le bande sono codificate in questo ordine nella funzione

#in questo modo vedo l'immagine a COLORI NATURALI, in questa immagine non riesco a individuare con chiarezza bosco e acque. 

#per visualizzare il plot con altre bande, possiamo farlo anzichè con 3,2,1 (rosso,verde,blu) con 4,3,2 -> scorriamo di 1 e togliamo la banda del blu, introducendo quella del Nir

plotRGB(image,4,3,2,stretch="Lin") #ricordando che la vegetazione ha riflettanza maggiore nel nir. Aldilà dei nostri occhi, che sono sensori visivi limitati al visibile, questa immagine dimostra l'altissima riflettanza del nir nella banda4

plotRGB(image,3,4,2,stretch="Lin") #inverto adesso la posizione del nir con quella del verde, inverto quindi 4 e 3.

#esercizio: montare un 2x2 con le 4 bande del NIR nella componente del B, poi del G, poi del B
par(mfrow=c(2,2))
plotRGB(image,4,2,3,stretch="Lin")
plotRGB(image,2,4,3,stretch="Lin")
plotRGB(image,3,2,4,stretch="Lin")
plotRGB(image,3,2,1,stretch="Lin")

#per salvare le immagini plottate come PDF utilizziamo la funzione pdf
pdf("il_mio_primo_pdf_con_R.pdf") #in questo modo avrò il mio pdf nella cartella lab
par(mfrow=c(2,2))
plotRGB(image,3,2,1,stretch="Lin")
plotRGB(image,4,2,3,stretch="Lin")
plotRGB(image,2,4,3,stretch="Lin")
plotRGB(image,3,2,4,stretch="Lin")


#posso stretchare oltre che linearmente, anche con il parametro 'hist'
plotRGB(image,3,4,2,stretch="Lin")
plotRGB(image,3,4,2,stretch="hist") # in questa, al centro della foresta vedo molta differenza tra vegetazione e acqua, cosa che non vedevo prima. le zone più violette sono quelle più umide. Stessa tecnica da adottare per il monitoraggio degli incendi, si richiama il concetto dei FRACTALS

par(mfrow=c(3,1)) #par natural colors and false colors with histogram stretching
plotRGB(image,3,4,2,stretch="Lin")
plotRGB(image,3,4,2,stretch="hist")
plotRGB(image,3,2,1,stretch="Lin")

#installo per la prossima lezione il pacchetto rstoolbox
#install.packages("RStoolbox)

#### DAY5
library(raster)   #carico il pacchetto raster con le sue funzioni 
setwd("C:/lab")   #setto la cartella di lavoro in R
image1988 <- brick("p224r63_1988_masked.grd")   #lavoriamo con la stessa immagine ma del 1988
image2011 <- brick("p224r63_2011_masked.grd")

# Bande Landsat
# B1: blu
# B2: verde
# B3: rosso
# B4: infrarosso vicino
# B5: infrarosso medio
# B6: infrarosso termico
# B7: infrarosso medio

#MULTITEMPORAL SET: facciamo un confronto tra le due immagini 2011-1988 dopo aver assegnato alla banda B1 il nir, alla B2 il rosso e alla B3 il verde
par(mfrow=c(2,1))
plotRGB(image1988, r=4,g=3,b=2,stretch="lin")
plotRGB(image2011, r=4,g=3,b=2,stretch="lin")

# si nota dal confronto come le aree destinate a contenere la foresta fossero più estese nel 1988, nelle aree colorate di verde

#RICORDANDO CHE A COLORI NATURALI L'ORDINE E' QUESTO
#plotRGB(image1988, r=3,g=2,b=1, stretch="lin")  # 3 - 2 - 1

#adesso vediamo un multiframe per apprezzare la differenza tra stretch="lin" e stretch = "hist"
pdf("multitemp.pdf")
par(mfrow=c(2,2))
plotRGB(image1988,4,3,2,stretch="lin")
plotRGB(image2011,4,3,2,stretch="lin")
plotRGB(image1988,4,3,2,stretch="hist")
plotRGB(image2011,4,3,2,stretch="hist")
dev.off()

#------------------------------------------#

# 2. R code time series
   

#time series analysis
#Greenland increase of temperature
#data and code from Emanuela Cosma


#install.packages("raster")
library(raster)
library(rasterVis)
setwd("C:/lab/greenland")

#lst_2000 <- raster("lst_2000.tif") #dataset da importare
#lst_2005 <- raster("lst_2005.tif")
#lst_2010 <- raster("lst_2010.tif")
#lst_2015 <- raster("lst_2015.tif")

#invece di importare singolarmente, creiamo una lista di files e poi usiamo lapply per applicare a ogni elemento della lista la funzione raster
# lapply: input=lista/vettore - output=lista
rlist <- list.files(pattern="lst")
import <- lapply(rlist,raster) #importo tutti i raster della lista (oggetti RasterLayer), import è un oggetto composto dai vari raster importati, che sono ancora però separati

#adesso raggruppo i raster importati singolarmente con la funzione stack in un unico grande file che chiamiamo TGr, oggetto RasterStack.
TGr <- stack(import) #TGr = temperature Groenlandia

#adesso posso plottare il singolo file che contiene tutti i raster
plot(TGr)

#adesso posso fare plotRGB
plotRGB(TGr, 1,2,3, stretch="lin") #1,2,3 sono rispettivamente il primo, secondo e terzo file, ovvero quelli relativi al 2000, 2005, 2010.

#in questo caso noi non gestiamo i colori, che sono propri delle immagini. Non facciamo altro che sovrapporre tra loro le immagini dei diversi periodi.
#Quindi se vedo del rosso, significa che i valori più alti di temperatura sono relativi al 2000, se vedo verde 2005, se vedo blu 2010 (rispettando l'ordine R G B), siccome l'immagine è piuttosto blu, si evince che le temperature più alte siano quelle relative al 2010
#per vedere il paragone inserendo anche il 2015, farò così
#plotRGB(TGr, 2,3,4, stretch="lin")

#funzione levelplot = molto più efficace in output rispetto a plot 
levelplot(TGr) #lavoriamo su come è possibile renderlo bello
levelplot(TGr$lst_2000) #qui plotto anche le statistiche

#possiamo utilizzare le colorRampPalette
cl <- colorRampPalette(c("blue","light blue","pink","red")) (100)

#adesso riplottiamo con l'argomento colregions
levelplot(TGr,col.regions=cl,main = "Summer land surface temperature", names.attr=c("July 2000","July 2005","July 2010","July 2015")) #main = titolo output, names = titolo ciasun raster

#Melt
setwd("C:/lab/greenland melt")
meltlist <- list.files(pattern="melt")
import_melt <- lapply(meltlist,raster)
MGr <- stack(import_melt)
MGr


cl_melt <- colorRampPalette(c("blue","white","red")) (100)
levelplot(MGr, col.regions=cl_melt)

#melt time
melt_amount <- MGr$X2007annual_melt - MGr$X1979annual_melt 
levelplot(melt_amount, col.regions=cl_melt)

#-------------------------------------------------------------#

# 3.  R code Copernicus


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

#---------------------------------------------------------------#

# 4.  R code Knitr



### Knitr
#wd
setwd("C:/lab")
#lib
#install.packages("knitr")
library(knitr)
stitch("rcode_greenland.r", template=system.file("misc", "knitr-template.Rnw", package="knitr"))    #stitch: primo arg -> nome del file con lo script, secondo arg -> template per il report

#la funzione prende in input uno script salvato sulla wd e genera in output due file di report:
# file.tex
# file.pdf

#RICORDA: stitch inserisce le immagini del file all'interno di una cartella "figure" in lab, per cui su overleaf, per compilare il file TeX bisogna prima creare anche lì una cartella figure su cui caricare tali immagini dal pc


#---------------------------------------------------------------------#

# 5.  #MULTIVARIATE ANALYSIS

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


#----------------------------------------------------------#

# 6.  R code classification

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

#-------------------------------------------------------------#

# 7.  R code ggplot2

library(raster)
library(RStoolbox)
library(ggplot2)
library(gridExtra)

setwd("~/lab/")

p224r63 <- brick("p224r63_2011_masked.grd")

ggRGB(p224r63,3,2,1, stretch="lin")
ggRGB(p224r63,4,3,2, stretch="lin")

p1 <- ggRGB(p224r63,3,2,1, stretch="lin")
p2 <- ggRGB(p224r63,4,3,2, stretch="lin")

grid.arrange(p1, p2, nrow = 2) # this needs gridExtra

#---------------------------------------------------------------#

# 8.  R code vegetation indices

#R_code_vegetation_indices.r

library(raster)
library(rasterVis)
library(RStoolbox) #per il calcolo degli indici di vegetazione
#install.packages("rasterdiv")
library(rasterdiv) #per l'NDVI globale
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
#plot(diff,col=cl2,main="DVI difference")

#dove la mappa è rossa c'è stata una differenza maggiore (in corrispondenza delle aree agricole), in blu le aree meno cambiate, rimaste vegetazione
#in questo caso la differenza è ben visibile, deforestazione. In altri casi la differenza non è così marcata ed è più difficile da marcare

#SE DOBBIAMO USARE IMMAGINI CON UNA RISOLUZIONE DIVERSA, USIAMO L'NDVI CHE E' NORMALIZZATO
#ndvi = (NIR - RED) / (NIR + RED) che ha un valore -1<=NDVI<=+1
ndvi1 <- (defor1$defor1.1 - defor1$defor1.2)/(defor1$defor1.1 + defor1$defor1.2)
#plot(ndvi1, col = cl1, main = "NDVI at time1")

ndvi2 <- (defor2$defor2.1 - defor2$defor2.2)/(defor2$defor2.1 + defor2$defor2.2)

NDVI_diff <- ndvi1-ndvi2
#plot(NDVI_diff,col=cl2,main="NDVI difference")

# FUNZIONE SPECTRAL INDICES: l'output è un oggetto RasterBrick , quindi multibanda nelle 3 bande di prima
#l'output è composto da molti indici tra cui DVI e NDVI -> BELLA ROBA
vi1 <- spectralIndices(defor1, green=3, red=2, nir=1)
#plot(vi,col=cl1)

vi2 <- spectralIndices(defor2,green=3, red=2, nir=1)

#WORLDWIDE NDVI
plot(copNDVI)


#Pixels with values 253, 254 and 255 (water) will be set as NA’s.
#togliamo la parte dell'acqua usando la funzione reclassify
copNDVI <- reclassify(copNDVI, cbind(252:255, NA))
#plot(copNDVI)

#usiamo levelplot del pacchetto rasterVis
levelplot(copNDVI)

#VEDO CHE LA VARIABILITA' MAGGIORE SI HA IN CORRISPONDENZA DELLE LATITUDINI DEL NORD EUROPA, E NORD AMERICA SOPRATTUTTO E ALL'EQUATORE. ALL'EQUATORE L'ALTA VARIABILITA' SI SPIEGA PER IL MAGGIOR NUMERO DI ORE DI LUCE

#I DESERTI SONO TUTTI SULLA LATITUDINE DEL TROPICO DEL CANCRO, 23 GRADI NORD. QUESTO A CAUSA DEI MOTI DELLE MASSE D'ARIA: la vegetazione molto spinta all'equatore, c'è molta EVAPOTRASPIRAZIONE
# catturare acqua = evapotraspirazione -> la pianta crea una differenza di pressione: per tirare acqua velocemente, tirando acqua verso le foglie in alto.
#il vapore che va in aria, carica l'atmosfera. Il vapore condensa e ricade come pioggia sulle foreste. L'aria che resta, scaricata del vapore acqueo e secchissima, si stabilisce in queste zone che sono proprio desertiche.
#un immenso feedback planetario


#---------------------------------------------------------------#

# 9.  R code land cover

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



#--------------------------------------------------------------#

# 10. R code variability temp


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

#----------------------------------------------------------#

# 11. R spectral signatures

# R_code_spectral_signature.r

library(raster)
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

#UTILIZZIAMO QUESTA IMG PER CREARE LE FIRME SPETTRALI CON LA FUNZIONE CLICK() DEL PACCHETTO gdal
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





























































































































 

























