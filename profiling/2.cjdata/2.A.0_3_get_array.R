### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

ped <- read.table("data/parentage_info.txt", header =TRUE)
geno <- fread("largedata/lcache/teo_recoded.txt")
geno <- as.data.frame(geno)

snpinfo <- create_array(geno, ped, outdir="largedata/obs/")
write.table(snpinfo, "largedata/lcache/snpinfo.csv", sep=",", row.names=FALSE, quote=FALSE)

###>>> Input [ 598043 ] biallelic loci for [ 4875 ] plants
###>>> Filtering loci with MAF < [ 0.002 ], Locus Missing Rate > [ 0.8 ] and Individual Missing Rate > [ 0.8 ]
###>>> Remaining [ 340600 ] loci and [ 4842 ] plants
###>>> Detected [ 67 ] parents with [ 4772/9544 ] kids/haps
###>>> Set minimum family size as [ 0 ], [ 67 ] parents will be imputed.
###>>> Calculating pop allele frq with selfed progeny ... done.
###>>> Preparing GBS.array objects, it will take a while.
###>>> Preparing for the [ 1th ] focal parent: total kids [ 320 ],
