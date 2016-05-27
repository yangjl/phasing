### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

geno <- fread("largedata/teo_updated/teo_raw_biallelic_recoded_20160303_AGPv2.txt")
geno <- as.data.frame(geno)

### updated geno matrix
imp67 <- read.csv("largedata/ip/imp67.csv")
if(sum(geno$snpid != row.names(imp67)) >0) stop("!!! ERROR")
ncol(geno[, names(imp67)])
geno[, names(imp67)] <- imp67

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
#####################
ob1 <- load("largedata/pp/teo_R1_ppr1.RData")
ob2 <- load("largedata/pp/teo_R2_ppr2.RData")
pp44 <- c(ppr1, ppr2)

ped <- read.csv("data/Parentage_for_imputeR.csv")
names(ped) <- c("proid", "parent1", "parent2")
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)

pinfo3 <- new_pedinfo(ped, ip=names(pp44), tot_cutoff=0, getinfo=TRUE)
subped3 <- new_pedinfo(ped, ip=names(pp44), tot_cutoff=0, getinfo=FALSE)
pargeno <- data.frame(parentid= as.character(unique(c(ped$parent1, ped$parent2))), true_p=0)
pargeno[pargeno$parentid %in% names(pp44), 2] <- 1

#pargeno <- subset(pargeno, pargeno[,2] >0)
create_array(geno, ped=subped3, pargeno, pp=pp44, pinfo=pinfo3,
             outdir="largedata/obs3", bychr=TRUE, bychunk=NULL)





