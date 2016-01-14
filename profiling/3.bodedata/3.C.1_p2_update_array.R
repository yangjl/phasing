### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

### read genotype. snpinfo and pedigree data
geno <- fread("largedata/lcache/land_recode.txt")
geno <- as.data.frame(geno)

### updated geno matrix
imp44 <- read.csv("cache/bode_imp44.csv")
names(imp44) <- gsub("\\.", ":", names(imp44))
names(imp44) <- gsub("^X", "", names(imp44))
#geno <- subset(geno, snpid %in% row.names(imp44))
geno[, names(imp44)] <- imp44


ped <- read.table("cache/landrace_parentage_info.txt", header =TRUE)

### updated geno matrix
source("lib/get_pp.R")
ppr1 <- get_pp(path="largedata/bode/obs1", pattern=".csv", imp44)
save(file="largedata/lcache/bode_R1_ppr1.RData", list="ppr1")

ob1 <- load("largedata/lcache/bode_R1_ppr1.RData")
#################################################
## 2nd round of imputation, with family > 40 selfed kids + outcrossed
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

pinfo2 <- new_pedinfo(ped, ip=names(ppr1), tot_cutoff=40, getinfo=TRUE)
subped <- new_pedinfo(ped, ip=names(ppr1), tot_cutoff=40, getinfo=FALSE)

ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
pargeno <- data.frame(parentid= as.character(unique(c(ped$parent1, ped$parent2))), true_p=0)
pargeno[pargeno$parentid %in% names(ppr1), 2] <- 1


snpinfo <- read.csv("largedata/land_snpinfo_self30.csv")
#pargeno <- subset(pargeno, pargeno[,2] >0)
create_array(geno, ped=subped, pargeno, pp=ppr1, pinfo=pinfo2, outdir="largedata/bode/obs2", 
             bychr=TRUE, snpinfo=snpinfo)



