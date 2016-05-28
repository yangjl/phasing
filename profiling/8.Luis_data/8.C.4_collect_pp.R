### Jinliang Yang
### use impute_parent in CJ data

#library(imputeR)
#library(data.table, lib="~/bin/Rlib/")

### updated geno matrix
imp4 <- read.csv("largedata/ip/imp4.csv")

source("lib/get_pp.R")
ppr1 <- get_pp(path="largedata/obs1", pattern=".csv", imp=imp4)
save(file="largedata/pp/teo_pp4.RData", list="ppr1")




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
    
    








