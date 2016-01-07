### Jinliang Yang
### Jan 6th, 2016

##get command line args
options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)

JOBID <- as.numeric(as.character(args[1]))
print(JOBID)


###########
library(data.table, lib="~/bin/Rlib/")
library(imputeR)
ped <- read.table("data/parentage_info.txt", header =TRUE)
geno <- fread("largedata/lcache/teo_recoded.txt")
geno <- as.data.frame(geno)

load("largedata/lcache/teo_pp68.RData")
kerr <- read.csv("cache/teo_kids_errmx.csv")
probs <- error_probs(mx=kerr, merr=1)

df <- read.csv("largedata/ik_files.csv")
res <- impute_kid(geno, pp, ped, kid_idx= df$start[JOBID]:df$end[JOBID], verbose=TRUE)
write.table(res, paste0("largedata/ik/kid_geno_", JOBID, ".csv"), sep=",", row.names=FALSE, quote=FALSE)

