### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

ped <- read.table("data/parentage_info.txt", header =TRUE)
geno <- fread("largedata/lcache/teo_recoded.txt")

mygeno <- mendelian_check(geno, ped, self_cutoff=30, depth_cutoff=10)


ped[, 1:3] <- apply(ped[,1:3], 2, as.character)
myped <- subset(ped, parent1 == parent2)
tab <- table(myped$parent1)
id <- names(tab[tab>30])
myped <- subset(myped, parent1 %in% id)


snpinfo <- create_array(geno=mygeno, ped=myped, outdir="largedata/obs/", snpinfo=NULL)
write.table(snpinfo, "largedata/lcache/snpinfo.csv", sep=",", row.names=FALSE, quote=FALSE)

###>>> Input [ 598043 ] biallelic loci for [ 4875 ] plants
###>>> Filtering loci with MAF < [ 0.002 ], Locus Missing Rate > [ 0.8 ] and Individual Missing Rate > [ 0.8 ]
###>>> Remaining [ 340600 ] loci and [ 4842 ] plants
###>>> Detected [ 67 ] parents with [ 4772/9544 ] kids/haps
###>>> Set minimum family size as [ 0 ], [ 67 ] parents will be imputed.
###>>> Calculating pop allele frq with selfed progeny ... done.
###>>> Preparing GBS.array objects, it will take a while.
###>>> Preparing for the [ 1th ] focal parent: total kids [ 320 ],

#############
library(imputeR)
library(data.table, lib="~/bin/Rlib/")

ped <- read.table("data/parentage_info.txt", header =TRUE)
geno <- fread("largedata/lcache/teo_recoded.txt")

imp35 <- read.csv("largedata/ip/imputed_parents_id35.csv")

nm2 <- gsub(".*_PC", "PC", names(imp35))
nm2 <- gsub("\\.", ":", nm2)
names(imp35) <- nm2

mygeno <- mendelian_check(geno, ped, self_cutoff=30, depth_cutoff=10)
mygeno[, nm2] <- imp35[, nm2]

snpinfo <- read.csv("largedata/lcache/snpinfo.csv")
snpinfo2 <- create_array(geno=mygeno, ped, outdir="largedata/obs2/", snpinfo=snpinfo)
