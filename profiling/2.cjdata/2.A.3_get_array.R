### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)

load(file="~/Documents/Github/imputeR/largedata/teo.RData")
Geno4imputeR <- ob1
ped <- read.table("data/parentage_info.txt", header =TRUE)

ob2 <- create_array(Geno4imputeR, ped, outdir="largedata/obs/",
                    maf_cutoff=0.002, lmiss_cutoff=0.8, imiss_cutoff=0.8, size_cutoff=40)
