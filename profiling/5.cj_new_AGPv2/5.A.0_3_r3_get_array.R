### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

### read genotype. snpinfo and pedigree data
ped <- read.csv("data/Parentage_for_imputeR.csv")
names(ped) <- c("proid", "parent1", "parent2")

snpinfo <- read.csv("cache/snpinfo_self30.csv")
geno <- fread("largedata/teo_updated/teo_raw_biallelic_recoded_20160303_AGPv2.txt")
geno <- as.data.frame(geno)


#### update geno matrix
ip1 <- read.csv("largedata/ip/round1_ip21.csv")
names(ip1) <- gsub("\\.", ":", names(ip1))
geno <- subset(geno, snpid %in% row.names(ip1))
geno[, names(ip1)] <- ip1

ip2 <- read.csv("largedata/ip/round2_ip23.csv")
names(ip2) <- gsub("\\.", ":", names(ip2))
geno <- subset(geno, snpid %in% row.names(ip2))
geno[, names(ip2)] <- ip2


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


pinfo3 <- new_pedinfo(ped, ip=c(names(ip1), names(ip2)), tot_cutoff=0, getinfo=TRUE)
subped <- new_pedinfo(ped, ip=c(names(ip1), names(ip2)), tot_cutoff=0, getinfo=FALSE)

ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
pargeno <- data.frame(parentid= as.character(unique(c(ped$parent1, ped$parent2))), true_p=0)
pargeno[pargeno$parentid %in% c(names(ip1), names(ip2)), 2] <- 1
sum(pargeno$true_p)
#pargeno <- subset(pargeno, pargeno[,2] >0)
create_array(geno, ped=subped, pargeno, pp=NULL, pinfo=pinfo3, 
             outdir="largedata/obs3", bychr=TRUE)
