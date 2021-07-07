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

#ORA CAMBIAMO DATI




