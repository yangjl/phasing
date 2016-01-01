### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

### read genotype. snpinfo and pedigree data
ped <- read.table("cache/landrace_parentage_info.txt", header =TRUE)
geno <- fread("largedata/lcache/land_recode.txt")
geno <- as.data.frame(geno)
snpinfo <- read.csv("largedata/land_snpinfo_self30.csv")

#### update geno matrix
ip13 <- read.csv("largedata/bode/ip/round1_ip13.csv", sep=",", header=TRUE)
names(ip13) <- gsub("\\.", ":", names(ip13))
names(ip13) <- gsub("^X", "", names(ip13))
#geno <- subset(geno, snpid %in% row.names(ip13))
geno[, names(ip13)] <- ip13

ip15 <- read.csv("largedata/bode/ip/round2_ip15.csv")
names(ip15) <- gsub("\\.", ":", names(ip15))
names(ip15) <- gsub("^X", "", names(ip15))
#geno <- subset(geno, snpid %in% row.names(ip13))
geno[, names(ip15)] <- ip15

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


pinfo3 <- new_pedinfo(ped, ip=c(names(ip13), names(ip15)), tot_cutoff=0, getinfo=TRUE)
subped <- new_pedinfo(ped, ip=c(names(ip13), names(ip15)), tot_cutoff=0, getinfo=FALSE)

ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
pargeno <- data.frame(parentid= as.character(unique(c(ped$parent1, ped$parent2))), true_p=0)
pargeno[pargeno$parentid %in% c(names(ip13), names(ip15)), 2] <- 1

#pargeno <- subset(pargeno, pargeno[,2] >0)
create_array(geno, ped=subped, pargeno, pinfo=pinfo3, snpinfo=snpinfo, 
             outdir="largedata/bode/obs3", bychr=TRUE)
