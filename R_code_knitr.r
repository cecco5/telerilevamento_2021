
### Knitr
#wd
setwd("C:/lab")
#lib
#install.packages("knitr")
library(knitr)
stitch("code.r", template=system.file("misc", "knitr-template.Rnw", package="knitr"))    #stitch: primo arg -> nome del file con lo script, secondo arg -> template per il report
