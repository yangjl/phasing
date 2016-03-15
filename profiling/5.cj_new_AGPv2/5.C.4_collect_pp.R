### Jinliang Yang
### use impute_parent in CJ data

#library(imputeR)
#library(data.table, lib="~/bin/Rlib/")

### updated geno matrix
imp67 <- read.csv("largedata/ip/imp67.csv")

source("lib/get_pp.R")
ppr1 <- get_pp(path="largedata/obs1", pattern=".csv", imp=imp67)
save(file="largedata/pp/teo_R1_ppr1.RData", list="ppr1")

ppr2 <- get_pp(path="largedata/obs2", pattern=".csv", imp=imp67)
save(file="largedata/pp/teo_R2_ppr2.RData", list="ppr2")

source("lib/get_pp.R")
ppr3 <- get_pp(path="largedata/obs3", pattern="PC_.*.csv", imp68)
save(file="largedata/lcache/R3_pp23.RData", list="ppr3")

ob1 <- load("largedata/lcache/R1_pp24.RData")
ob2 <- load("largedata/lcache/R2_pp21.RData")
pp68 <- c(pp24, ppr2, ppr3)
save(file="largedata/lcache/teo_pp68.RData", list="pp68")







