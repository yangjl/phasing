### Jinliang Yang
### use impute_parent in CJ data

### updated geno matrix
imp68 <- read.csv("largedata/cjmasked/ip68_masked.csv")
names(imp68) <- gsub("\\.", ":", names(imp68))

source("lib/get_pp.R")
ppr1 <- get_pp(path="largedata/cjmasked/obs1", pattern="PC_.*.csv", chunk_inc=100, imp68)
save(file="largedata/cjmasked/R1_pp24.RData", list="ppr1")


source("lib/get_pp.R")
ppr2 <- get_pp(path="largedata/cjmasked/obs2", pattern="PC_.*.csv", chunk_inc=100, imp68)
#[1] 1130
save(file="largedata/cjmasked/R2_pp21.RData", list="ppr2")

source("lib/get_pp.R")
ppr3 <- get_pp(path="largedata/cjmasked/obs3", pattern="PC_.*.csv", chunk_inc=100, imp68)
#850


save(file="largedata/cjmasked/R3_pp23.RData", list="ppr3")


ob1 <- load("largedata/cjmasked/R1_pp24.RData")
ob2 <- load("largedata/cjmasked/R2_pp21.RData")
pp68 <- c(ppr1, ppr2, ppr3)
save(file="largedata/cjmasked/teo_masked_pp68.RData", list="pp68")







