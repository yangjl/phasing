####### de-bugging



### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

ped <- read.table("data/parentage_info.txt", header =TRUE)
geno <- fread("largedata/lcache/teo_recoded.txt")
geno <- as.data.frame(geno)

#snpinfo <- create_array(geno, ped, outdir="largedata/obs/", snpinfo=NULL)
#write.table(snpinfo, "largedata/lcache/snpinfo.csv", sep=",", row.names=FALSE, quote=FALSE)

pinfo <- pedinfo(ped)

perr <- read.csv("cache/teo_parents_errmx.csv")
kerr <- read.csv("cache/teo_kids_errmx.csv")

o <- load("largedata/obs/p31_PC_M59_ID1_1:250276237_chr10.RData")
obj@pedigree$true_p <- 0
tem <- impute_parent(GBS.array=obj, perr, kerr)

res <- parentgeno(tem, oddratio=0.69, returnall=TRUE)
res$raw <- obj@gbs_parents[[1]]

nrow(subset(res, raw !=3 & res$raw==0 & gmax==0))
nrow(subset(res, raw !=3 & res$raw==2 & gmax==2))
nrow(subset(res, raw !=3 & res$raw==1 & gmax==1))


mygeno <- subset(geno, snpid %in% row.names(res))
myped <- subset(ped, parent1 == "PC_M59_ID1_1:250276237" | parent2 == "PC_M59_ID1_1:250276237")
out1 <- estimate_error(geno=mygeno, ped=myped, self_cutoff=30, depth_cutoff=10, check_kid_err=FALSE)

mygeno[, "PC_M59_ID1_1:250276237"] <- res$gmax
#sum(mygeno[, "PC_O51_ID2_mrg:250276282"] != res$raw)
out2 <- estimate_error(geno=mygeno, ped=myped, self_cutoff=30, depth_cutoff=10, check_kid_err=FALSE)



self <- subset(obj@pedigree, p1 == p2)
res$gbsp <- obj@gbs_parents[[1]]
for(i in 1:nrow(self)){
    res$kid <- obj@gbs_kids[[i]]
    names(res)[ncol(res)] <- paste0("kid", i)
}

bk <- res

res$c0 <- apply(res[, which(names(res)=="kid1"):which(names(res)=="kid30")], 1, function(x) sum(x==0))
res$c1 <- apply(res[, which(names(res)=="kid1"):which(names(res)=="kid30")], 1, function(x) sum(x==1))
res$c2 <- apply(res[, which(names(res)=="kid1"):which(names(res)=="kid30")], 1, function(x) sum(x==2))
res$c3 <- apply(res[, which(names(res)=="kid1"):which(names(res)=="kid30")], 1, function(x) sum(x==3))


table(subset(res, c1==0 & c2==0 & c3<10)$gmax)
table(subset(res, c1==0 & c0==0 & c3<10)$gmax)

head(subset(res, c1==0 & c0==0))

##### comparing snp info with python results
snp0 <- read.delim("largedata/lcache/teo_flt_maf01m8.txt", header=TRUE)
snp1 <- read.csv("largedata/lcache/snpinfo.csv", header=TRUE)


