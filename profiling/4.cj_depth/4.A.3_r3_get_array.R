### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

### read genotype. snpinfo and pedigree data
ped <- read.table("data/parentage_info.txt", header =TRUE)
snpinfo <- read.csv("cache/snpinfo_self30.csv")
geno <- fread("largedata/lcache/teo_masked.txt")
geno <- as.data.frame(geno)

#### update geno matrix
ip24 <- read.csv("largedata/cjmasked/ip24_round1.csv")
names(ip24) <- gsub("\\.", ":", names(ip24))
sum(geno$snpid != row.names(ip24))
geno[, names(ip24)] <- ip24

ip21 <- read.csv("largedata/cjmasked/ip21_round2.csv")
names(ip21) <- gsub("\\.", ":", names(ip21))
sum(geno$snpid != row.names(ip21))
geno[, names(ip21)] <- ip21


#################################################
## 3rd round of imputation, with family > 40 selfed kids + outcrossed
new_pedinfo <- function(ped, ip=names(ip24), tot_cutoff=40, getinfo=TRUE){
    ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
    
    subped <- subset(ped, !(parent1 == parent2 & parent1 %in% ip))
    subped <- subset(subped, parent1 == parent2 | parent1 %in% ip | parent2 %in% ip)
    
    pinfo2 <- pedinfo(subped)
    pinfo2$founder <- as.character(pinfo2$founder)
    pinfo2 <- subset(pinfo2, !(founder %in% ip))
    
    if(getinfo){
        return(subset(pinfo2, tot > tot_cutoff))
    }else{
        pinfo2 <- subset(pinfo2, tot > tot_cutoff)
        kid1 <- subset(ped, parent1 == parent2 & parent1 %in% pinfo2$founder)
        kid2 <- subset(ped, parent1 %in% pinfo2$founder & parent2 %in% ip)
        kid3 <- subset(ped, parent2 %in% pinfo2$founder & parent1 %in% ip)
        return(rbind(kid1, kid2, kid3))
    }
}

pinfo3 <- new_pedinfo(ped, ip=c(names(ip24), names(ip21)), tot_cutoff=0, getinfo=TRUE)
subped <- new_pedinfo(ped, ip=c(names(ip24), names(ip21)), tot_cutoff=0, getinfo=FALSE)

ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
pargeno <- data.frame(parentid= as.character(unique(c(ped$parent1, ped$parent2))), true_p=0)
pargeno[pargeno$parentid %in% c(names(ip24), names(ip21)), 2] <- 1

#pargeno <- subset(pargeno, pargeno[,2] >0)
create_array(geno, ped=subped, pargeno, pp=NULL, pinfo=pinfo3, snpinfo=snpinfo,
             outdir="largedata/cjmasked/obs3", bychr=TRUE)

