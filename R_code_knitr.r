
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
