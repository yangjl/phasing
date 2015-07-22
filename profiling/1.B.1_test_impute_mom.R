### Jinliang Yang


source("lib/simulate_selfer.R")
source("lib/plotpa.R")
### Params and probabilities

set.seed(1234)
sim <- SimSelfer(size.array=10, het.error=0.7, hom.error=0.002, numloci=100, rec=1.5, imiss=0)

plotpa(sim, kids=10, cols=c("green", "blue"))

#save(file="cache/sim123456.RData", list="sim")

#########################################################

het.error=0.7 # het->hom error
hom.error=0.002 # hom->other error

###########
simp <- sim[[1]]
simk <- sim[[2]]
obs_mom <- simp$obs
numloci <- 100

progeny <- list()
for(i in 1:length(simk)){
    progeny[[i]] <- list(simk[[i]][[2]]$obs, simk[[i]][[2]]$obs)
}

frq <- function(progeny){
    res <- 0
    for(i in 1:length(progeny)){
        res <- res + progeny[[i]][[2]]
    }
    res <- res/(2*length(progeny))
    res <- replace(res, which(res==0), 0.5/length(progeny))
    return(res)
}

p <- frq(progeny)

source("lib/phasekids.R")
estimated_mom <- sapply(1:numloci, function(a) infer_mom(obs_mom,a,progeny,p) ) 
mom.gen.errors[mysim]=(numloci-sum(estimated_mom==true_mom[[1]]+true_mom[[2]]))/numloci









