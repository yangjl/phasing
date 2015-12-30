### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")
snpinfo <- get_snpinfo(geno, ped, self_cutoff=30)
write.table(snpinfo, "largedata/land_snpinfo_self30.csv", sep=",", row.names=FALSE, quote=FALSE)


ped <- read.table("cache/landrace_parentage_info.txt", header =TRUE)
geno <- fread("largedata/lcache/land_recode.txt")
geno <- as.data.frame(geno)
snpinfo <- read.csv("largedata/land_snpinfo_self30.csv")
#################################################
## First round of imputation, with family > 40 selfed kids
#mygeno <- mendelian_check(geno, ped, self_cutoff=30, depth_cutoff=10)
pinfo <- pedinfo(ped)
pinfo <- subset(pinfo, nselfer > 40)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
myped <- subset(ped, parent1 == parent2 & parent1 %in% pinfo$founder)
pargeno <- data.frame(parentid= as.character(unique(c(ped$parent1, ped$parent2))), true_p=0)

create_array(geno, ped=myped, pargeno, pinfo = NULL, snpinfo=snpinfo, 
             outdir="largedata/bode/obs1", bychr=TRUE)
