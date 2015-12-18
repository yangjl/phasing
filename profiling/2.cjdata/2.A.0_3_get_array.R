### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

ped <- read.table("data/parentage_info.txt", header =TRUE)
geno <- fread("largedata/lcache/teo_recoded.txt")

snpinfo <- create_array(geno, ped, outdir="largedata/obs/", snpinfo=NULL)
write.table(snpinfo, "largedata/lcache/snpinfo.csv", sep=",", row.names=FALSE, quote=FALSE)


