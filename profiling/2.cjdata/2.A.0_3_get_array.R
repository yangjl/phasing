### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

ped <- read.table("data/parentage_info.txt", header =TRUE)
geno <- fread("largedata/lcache/teo_recoded.txt")
geno <- as.data.frame(geno)



snpinfo <- get_snpinfo(geno, ped, self_cutoff=30)
write.table(snpinfo, "cache/snpinfo_self30.csv", sep=",", row.names=FALSE, quote=FALSE)


#################################################

myped <- subset(ped, parent1 == parent2)
tab <- table(myped$parent1)
id <- names(tab[tab>30])
myped <- subset(myped, parent1 %in% id)

#mygeno <- mendelian_check(geno, ped, self_cutoff=30, depth_cutoff=10)
pinfo <- pedinfo(ped)
pinfo <- pinfo[order(pinfo$nselfer, decreasing = TRUE),]

ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
myped <- subset(ped, parent1 == parent2 & parent1 == pinfo$founder[1])
pargeno <- data.frame(parentid= as.character(unique(c(ped$parent1, ped$parent2))), true_p=0)

create_array(geno, ped=myped, pargeno, outdir="largedata/obs", bychr=FALSE, snpinfo=snpinfo, self_cutoff=30)

