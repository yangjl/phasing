### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

### read genotype. snpinfo and pedigree data

geno <- fread("largedata/lcache/land_recode.txt")
geno <- as.data.frame(geno)

#### update geno matrix
ip13 <- read.csv("largedata/bode/ip/round1_ip13.csv")
ip15 <- read.csv("largedata/bode/ip/round2_ip15.csv")
ip16 <- read.csv("largedata/bode/ip/round3_ip16.csv")
ip44 <- cbind(ip13, ip15, ip16)

names(ip44) <- gsub("\\.", ":", names(ip44))
names(ip44) <- gsub("^X", "", names(ip44))
if(sum(geno$snpid != row.names(ip44)) > 0) stop("!!! ERRROR !!!")
dim(geno[, names(ip44)])
geno[, names(ip44)] <- ip44

#################################################
## 4th round of imputation, with family > 40 selfed kids + outcrossed

new_pedinfo <- function(ped, ip=names(ip24), tot_cutoff=40, getinfo=TRUE){

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
######
ped <- read.table("cache/landrace_parentage_info.txt", header =TRUE)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
pinfo4 <- new_pedinfo(ped, ip=names(ip44), tot_cutoff=0, getinfo=TRUE)
subped <- new_pedinfo(ped, ip=names(ip44), tot_cutoff=0, getinfo=FALSE)
if(sum(pinfo4$tot) != nrow(subped) ) stop("!!!error!!!")

pargeno <- data.frame(parentid= as.character(unique(c(ped$parent1, ped$parent2))), true_p=0)
pargeno[pargeno$parentid %in% names(ip44), 2] <- 1

#pargeno <- subset(pargeno, pargeno[,2] >0)
create_array(geno, ped=subped, pargeno, pp=NULL, pinfo=pinfo4,
             outdir="largedata/bode/obs4", bychr=TRUE, bychunk=NULL)
