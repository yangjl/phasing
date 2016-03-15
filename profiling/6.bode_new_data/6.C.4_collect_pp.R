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
save(file="largedata/bode/bode_R2_ppr2.RData", list="ppr2")

source("lib/get_pp.R")
ppr3 <- get_pp(path="largedata/bode/obs3", pattern=".csv", chunk_inc=100, imp53)
#888
save(file="largedata/bode/bode_R3_ppr3.RData", list="ppr3")

source("lib/get_pp.R")
ppr4 <- get_pp(path="largedata/bode/obs4", pattern=".csv", chunk_inc=100, imp53)
#506
save(file="largedata/bode/bode_R4_ppr4.RData", list="ppr4")


ob1 <- load("largedata/bode/bode_R1_ppr1.RData")
ob2 <- load("largedata/bode/bode_R2_ppr2.RData")
ob3 <- load("largedata/bode/bode_R3_ppr3.RData")
ob4 <- load("largedata/bode/bode_R4_ppr4.RData")
pp53 <- c(ppr1, ppr2, ppr3, ppr4)
save(file="largedata/bode/landrace_pp53.RData", list="pp53")







