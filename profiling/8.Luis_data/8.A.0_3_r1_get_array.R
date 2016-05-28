### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

ped <- read.csv("data/Parentage_for_imputeR.csv")
names(ped) <- c("proid", "parent1", "parent2")
geno <- fread("largedata/teo_updated/teo_raw_biallelic_recoded_20160303_AGPv2.txt")
geno <- as.data.frame(geno)

p5 <- c("PC_M05_ID1", "PC_I58_ID2", "PC_N09_ID1", "PC_I58_ID2", "PC_L08_ID1")
goodloci <- read.table("data/good_loci.txt")


subgeno <- subset(geno, snpid %in% goodloci$V1)

pinfo <- pedinfo(ped)
pinfo <- subset(pinfo, founder %in% p5)


#################################################
## First round of imputation, with family > 30 selfed kids
#mygeno <- mendelian_check(geno, ped, self_cutoff=30, depth_cutoff=10)

ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
myped <- subset(ped, parent1 == parent2 & parent1 %in% p5)
pargeno <- data.frame(parentid= as.character(unique(c(myped$parent1, myped$parent2))), true_p=0)

create_array(geno=subgeno, ped=myped, pargeno, pp=NULL, pinfo=pinfo,
             outdir="largedata/obs1", bychr=TRUE)


