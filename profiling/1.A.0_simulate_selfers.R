### Jinliang Yang

source("lib/simulate_selfer.R")
source("lib/plotpa.R")
### Params and probabilities

size.array=20 # size of progeny array
het.error=0.7 # het->hom error
hom.error=0.002 # hom->other error
numloci=1000 

set.seed(123456)
sim <- SimSelfer(size.array=10, het.error=0.7, hom.error=0.002, numloci=100, recombination=TRUE)

plotpa(sim, kids=10, cols=c("green", "blue"))






