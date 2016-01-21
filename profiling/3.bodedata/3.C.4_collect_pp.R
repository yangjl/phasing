### Jinliang Yang
### use impute_parent in CJ data

### updated geno matrix
imp53 <- read.csv("largedata/bode/ip53_imputed.csv")
names(imp53) <- gsub("\\.", ":", names(imp53))
names(imp53) <- gsub("^X", "", names(imp53))

source("lib/get_pp.R")
ppr1 <- get_pp(path="largedata/bode/obs1", pattern=".csv", imp53)
save(file="largedata/bode/bode_R1_ppr1.RData", list="ppr1")


source("lib/get_pp.R")
ppr2 <- get_pp(path="largedata/bode/obs2", pattern=".csv", chunk_inc=100, imp53)
#[1] 1109
save(file="largedata/cjmasked/R2_pp21.RData", list="ppr2")

source("lib/get_pp.R")
ppr3 <- get_pp(path="largedata/cjmasked/obs3", pattern="PC_.*.csv", chunk_inc=100, imp68)
#850


save(file="largedata/cjmasked/R3_pp23.RData", list="ppr3")


ob1 <- load("largedata/cjmasked/R1_pp24.RData")
ob2 <- load("largedata/cjmasked/R2_pp21.RData")
pp68 <- c(ppr1, ppr2, ppr3)
save(file="largedata/cjmasked/teo_masked_pp68.RData", list="pp68")







