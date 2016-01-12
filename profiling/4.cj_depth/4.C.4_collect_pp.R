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
df <- list.files(path="largedata/cjmasked/obs2", pattern="PC_.*.RData", full.names = TRUE)
files <- list.files(path="largedata/cjmasked/obs2", pattern="PC_.*.csv", full.names = TRUE)

df <- gsub("RData", "csv", df)

"largedata/cjmasked/obs2/PC_I05_ID1_1:250276198_chr4_chunk2.csv"
idx <- df[!df %in% files]


save(file="largedata/cjmasked/R2_pp21.RData", list="ppr1")

ob1 <- load("largedata/lcache/R1_pp24.RData")
ob2 <- load("largedata/lcache/R2_pp21.RData")
pp68 <- c(pp24, ppr2, ppr3)
save(file="largedata/lcache/teo_pp68.RData", list="pp68")







