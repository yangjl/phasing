### Jinliang Yang
### use impute_parent in CJ data

#library(imputeR)
library(data.table, lib="~/bin/Rlib/")

ped <- read.table("data/parentage_info.txt", header =TRUE)
geno <- fread("largedata/lcache/teo_recoded.txt")
geno <- as.data.frame(geno)

### updated geno matrix
imp68 <- read.csv("cache/imp68.csv")
names(imp68) <- gsub("\\.", ":", names(imp68))
geno <- subset(geno, snpid %in% row.names(imp68))
geno[, names(imp68)] <- imp68

source("lib/get_pp.R")
ppr3 <- get_pp(path="largedata/obs3", pattern="PC_.*.csv", imp68)
save(file="largedata/lcache/R3_pp23.RData", list="ppr3")

ob1 <- load("largedata/lcache/R1_pp24.RData")
ob2 <- load("largedata/lcache/R2_pp21.RData")
pp68 <- c(pp24, ppr2, ppr3)
save(file="largedata/lcache/teo_pp68.RData", list="pp68")




###########
library(data.table, lib="~/bin/Rlib/")
library(imputeR)
ped <- read.table("data/parentage_info.txt", header =TRUE)
geno <- fread("largedata/lcache/teo_recoded.txt")
geno <- as.data.frame(geno)

load("largedata/lcache/teo_pp68.RData")
kerr <- read.csv("cache/teo_kids_errmx.csv")
probs <- error_probs(mx=kerr, merr=1)

res <- impute_kid(geno, pp, ped, kid_idx=1:3, verbose=TRUE)


