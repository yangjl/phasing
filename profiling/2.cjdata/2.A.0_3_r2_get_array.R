### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

### read genotype. snpinfo and pedigree data
ped <- read.table("data/parentage_info.txt", header =TRUE)
snpinfo <- read.csv("cache/snpinfo_self30.csv")
geno <- fread("largedata/lcache/teo_recoded.txt")
geno <- as.data.frame(geno)

#### update geno matrix
ip24 <- read.csv("largedata/ip/round1_ip24.csv")
names(ip24) <- gsub("\\.", ":", names(ip24))
geno <- subset(geno, snpid %in% row.names(ip24))
geno[, names(ip24)] <- ip24


#################################################
## 2nd round of imputation, with family > 40 selfed kids + outcrossed

new_pedinfo <- function(ped, ip=names(ip24), tot_cutoff=40){
    ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
    subped <- subset(ped, parent1 == parent2 | parent1 %in% ip | parent2 %in% ip)
    pinfo2 <- pedinfo(subped)
    pinfo2 <- subset(pinfo2, !(founder %in% ip))
    return(subset(pinfo2, tot > tot_cutoff))
}

pinfo2 <- new_pedinfo(ped, ip=names(ip24), tot_cutoff=40)
myped <- subset(ped, parent1 %in% pinfo2$founder | parent2 %in% pinfo2$founder)
myped[, 1:3] <- apply(myped[, 1:3], 2, as.character)


pargeno <- data.frame(parentid= as.character(unique(c(myped$parent1, myped$parent2))), true_p=0)
pargeno[pargeno$parentid %in% names(ip24), 2] <- 1

create_array(geno, ped=myped, pargeno, pinfo=pinfo2, outdir="largedata/obs2", bychr=TRUE, snpinfo=snpinfo, self_cutoff=NULL)


