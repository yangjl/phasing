### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

ped <- read.table("data/parentage_info.txt", header =TRUE)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)


geno <- fread("largedata/lcache/teo_recoded.txt")
geno <- as.data.frame(geno)


out <- estimate_error(geno, ped, self_cutoff=30, depth_cutoff=10)
out$k0 <- out$k01 + out$k02
out$k2 <- out$k20 + out$k21
write.table(out, "cache/err_mx.csv", sep=",", row.names=FALSE, quote=FALSE)

mean(out$k0)

mean(out$k2)

