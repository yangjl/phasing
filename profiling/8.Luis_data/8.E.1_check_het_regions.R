### Jinliang Yang
### June 9th, 2016


library(imputeR)
library(data.table, lib="~/bin/Rlib/")

ped <- read.csv("data/Parentage_for_imputeR.csv")
names(ped) <- c("proid", "parent1", "parent2")
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
pinfo <- pedinfo(ped)

geno <- fread("largedata/teo_updated/teo_raw_biallelic_recoded_20160303_AGPv2.txt")
geno <- as.data.frame(geno)


### check the first one
pid <- "PC_I05_ID1"
subset(pinfo, founder %in% pid)
#     founder nselfer nox tot
#1 PC_I05_ID1      22  86 108
lr1 <- c("S1_85832820", "S1_90228736", "S1_95111283", "S1_95111288", "S1_95111433")
ids <- subset(ped, parent1 == parent2 & parent1 %in% pid)

subset(geno, snpid %in% lr1)[, c(pid, ids$proid)]

lr2 <- c("S1_155927125", "S1_155927131", "S1_155927132", "S1_155927135", "S1_155927137")
subset(geno, snpid %in% lr2)[, c(pid, ids$proid)]

pid <- "PC_I58_ID2"
subset(pinfo, founder %in% pid)
ids <- subset(ped, parent1 == parent2 & parent1 %in% pid)
lr3 <- c("S7_74500426", "S7_77457641")
res <- subset(geno, snpid %in% lr3)[, c("snpid", pid, ids$proid)]




