### Jinliang Yang
### use impute_parent in CJ data

#library(imputeR)
#library(data.table, lib="~/bin/Rlib/")

### updated geno matrix
imp67 <- read.csv("largedata/ip/imp67.csv")

source("lib/get_pp.R")
ppr1 <- get_pp(path="largedata/obs1", pattern=".csv", imp=imp67)
save(file="largedata/pp/teo_R1_ppr1.RData", list="ppr1")

ppr2 <- get_pp(path="largedata/obs2", pattern=".csv", imp=imp67)
save(file="largedata/pp/teo_R2_ppr2.RData", list="ppr2")

source("lib/get_pp.R")
ppr3 <- get_pp(path="largedata/obs3", pattern="PC_.*.csv", imp=imp67)
save(file="largedata/pp/teo_R3_ppr3.RData", list="ppr3")

ob1 <- load("largedata/pp/teo_R1_ppr1.RData")
ob2 <- load("largedata/pp/teo_R2_ppr2.RData")
ob3 <- load("largedata/pp/teo_R3_ppr3.RData")
pp67 <- c(ppr1, ppr2, ppr3)
save(file="largedata/lcache/teo_pp67_AGPv2.RData", list="pp67")


#### to a tab delimited format 
newformat <- function(pp67){
    
    plantid <- names(pp67[[1]])[6]
    tab <- pp67[[1]][, c("snpid", "chr", "pos", "chunk", "hap1", "hap2" )]
    names(tab)[4:6] <- c(paste0(plantid, "_chunk"),paste0(plantid, "_hap1"),paste0(plantid, "_hap2") )
    
    for(i in 2:length(pp67)){
        plantid <- names(pp67[[i]])[6]
        res <- pp67[[i]][, c("snpid", "chunk", "hap1", "hap2" )]
        names(res)[2:4] <- c(paste0(plantid, "_chunk"),paste0(plantid, "_hap1"),paste0(plantid, "_hap2") )
        
        tab <- merge(tab, res, by="snpid", sort = FALSE)
    }
    return(tab)
}
####
hap <- newformat(pp67)
write.table(hap, "largedata/teo_parents_hap_AGPv2.txt", sep="\t", row.names=FALSE, quote=FALSE)    
    
    








