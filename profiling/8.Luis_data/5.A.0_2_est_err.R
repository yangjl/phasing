### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

ped <- read.csv("data/Parentage_for_imputeR.csv")
names(ped) <- c("proid", "parent1", "parent2")
geno <- fread("largedata/teo_updated/teo_raw_biallelic_recoded_20160303_AGPv2.txt")
geno <- as.data.frame(geno)



out <- estimate_error(geno, ped, self_cutoff=30, depth_cutoff=10)

write.table(out[[1]], "cache/err_mx_selfed.csv", sep=",", row.names=FALSE, quote=FALSE)
write.table(out[[2]], "cache/err_mx_oc.csv", sep=",", row.names=FALSE, quote=FALSE)


#####
per <- out[[1]]
ker <- out[[2]]

mx1 <- matrix(c(1-mean(per$er0), mean(per$er01), mean(per$er02),
                     mean(per$er10), 1-mean(per$er1), mean(per$er12),
                     mean(per$er20), mean(per$er21), 1-mean(per$er2)),
                   byrow=T,nrow=3,ncol=3)
rownames(mx1) <- c("g0", "g1", "g2")
colnames(mx1) <- c("ob0", "ob1", "ob2")
mx1 <- round(mx1,4)


mx2 <- matrix(c(1-mean(ker$kerr01, na.rm=T)-mean(ker$kerr02, na.rm=T), mean(ker$kerr01, na.rm=T), mean(ker$kerr02, na.rm=T),
                mean(ker$kerr10, na.rm=T), 1-mean(ker$kerr10, na.rm=T)-mean(ker$kerr12, na.rm=T), mean(ker$kerr12, na.rm=T),
                mean(ker$kerr20, na.rm=T), mean(ker$kerr21, na.rm=T), 1-mean(ker$kerr20, na.rm=T)-mean(ker$kerr21, na.rm=T)),
              byrow=T,nrow=3,ncol=3)
rownames(mx2) <- c("g0", "g1", "g2")
colnames(mx2) <- c("ob0", "ob1", "ob2")
mx2 <- round(mx2, 4)

write.table(mx1, "cache/teo_parents_errmx.csv", sep=",", row.names=TRUE, quote=FALSE)
write.table(mx2, "cache/teo_kids_errmx.csv", sep=",", row.names=TRUE, quote=FALSE)


pmx <- read.csv("cache/teo_parents_errmx.csv")
kmx <- read.csv("cache/teo_kids_errmx.csv")