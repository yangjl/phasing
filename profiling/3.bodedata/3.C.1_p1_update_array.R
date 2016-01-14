### Jinliang Yang
### phase parents

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

#################################################
## First round of imputation, with family > 40 selfed kids
#mygeno <- mendelian_check(geno, ped, self_cutoff=30, depth_cutoff=10)
snpinfo <- read.csv("largedata/land_snpinfo_self30.csv")
pinfo <- pedinfo(ped)
pinfo <- subset(pinfo, nselfer > 40)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
myped <- subset(ped, parent1 == parent2 & parent1 %in% pinfo$founder)
pargeno <- data.frame(parentid= as.character(unique(c(ped$parent1, ped$parent2))), true_p=0)

create_array(geno, ped=myped, pargeno, 
             outdir="largedata/bode/obs1", bychr=TRUE, snpinfo=snpinfo)


