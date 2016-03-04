### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

ped <- read.csv("data/Parentage_for_imputeR.csv")
names(ped) <- c("proid", "parent1", "parent2")
geno <- fread("largedata/teo_updated/teo_raw_biallelic_recoded_20160303_AGPv2.txt")
geno <- as.data.frame(geno)


ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
snpinfo <- get_snpinfo(geno, ped, self_cutoff=30)
###>>> Calculating allele frq and missing using all data ... done.
###>>> Detected [ 67 ] parents with [ 4741/9482 ] kids/haps
###>>> Calculating pop frq and missing using selfed family with [ > %s ] kids ... 30
write.table(snpinfo, "cache/snpinfo_self30.csv", sep=",", row.names=FALSE, quote=FALSE)

snpinfo <- read.csv("cache/snpinfo_self30.csv")
#################################################
## First round of imputation, with family > 40 selfed kids
#mygeno <- mendelian_check(geno, ped, self_cutoff=30, depth_cutoff=10)
pinfo <- pedinfo(ped)
pinfo <- subset(pinfo, nselfer > 40)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
myped <- subset(ped, parent1 == parent2 & parent1 %in% pinfo$founder)
pargeno <- data.frame(parentid= as.character(unique(c(ped$parent1, ped$parent2))), true_p=0)

create_array(geno, ped=myped, pargeno, pp=NULL, pinfo=pinfo,
             outdir="largedata/obs1", bychr=TRUE, bychunk=NULL)


#################################################
o <- load(files)
perr <- read.csv("cache/teo_parents_errmx.csv")
kerr <- read.csv("cache/teo_kids_errmx.csv")
tem <- impute_parent(GBS.array=obj, perr, kerr)
res <- parentgeno(tem, oddratio=0.69, returnall=TRUE)

