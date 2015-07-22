### Jinliang Yang

source("lib/simulate_selfer.R")
source("lib/plotpa.R")
### Params and probabilities

size.array=20 # size of progeny array
het.error=0.7 # het->hom error
hom.error=0.002 # hom->other error
numloci=1000 

set.seed(1234)
sim <- SimSelfer(size.array=10, het.error=0.7, hom.error=0.002, numloci=100, rec=1.5, imiss=0.3)

plotpa(sim, kids=10, cols=c("green", "blue"))

save(file="cache/sim123456.RData", list="sim")






