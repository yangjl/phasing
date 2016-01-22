### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

### read genotype. snpinfo and pedigree data
geno <- fread("largedata/lcache/land_recode.txt")
geno <- as.data.frame(geno)

### updated geno matrix
imp53 <- read.csv("largedata/bode/ip53_imputed.csv")
names(imp53) <- gsub("\\.", ":", names(imp53))
names(imp53) <- gsub("^X", "", names(imp53))

if(sum(geno$snpid != row.names(imp53)) > 0) stop("!")
dim(geno[, names(imp53)])
geno[, names(imp53)] <- imp53


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

############
ob1 <- load("largedata/bode/bode_R1_ppr1.RData")
ob2 <- load("largedata/bode/bode_R2_ppr2.RData")
pp28 <- c(ppr1, ppr2)

ped <- read.table("cache/landrace_parentage_info.txt", header =TRUE)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)

pinfo3 <- new_pedinfo(ped, ip=names(pp28), tot_cutoff=0, getinfo=TRUE)
subped3 <- new_pedinfo(ped, ip=names(pp28), tot_cutoff=0, getinfo=FALSE)


pargeno <- data.frame(parentid= as.character(unique(c(ped$parent1, ped$parent2))), true_p=0)
pargeno[pargeno$parentid %in% names(pp28), 2] <- 1


#pargeno <- subset(pargeno, pargeno[,2] >0)
create_array(geno, ped=subped3, pargeno, pp=pp28, pinfo=pinfo3,
             outdir="largedata/bode/obs3", bychr=TRUE, bychunk=1000)



