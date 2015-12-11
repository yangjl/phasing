####### de-bugging


o <- load("largedata/obs/p49_PC_N48_ID1_1:250276249_chr10.RData")
tem <- impute_parent(GBS.array=obj, hom.error = 0.02, het.error = 0.8)
res <- parentgeno(tem, oddratio=0.69, returnall=TRUE)

res <- cbind(obj@snpinfo, res)

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


