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

df <- read.csv("largedata/bode/ik_files.csv")
df$file <- as.character(df$file)

geno <- fread(df$file[JOBID])
geno <- as.data.frame(geno)

kerr <- read.csv("cache/land_kids_errmx.csv")
probs <- error_probs(mx=kerr, merr=1)

o <- load("largedata/bode/landrace_pp53.RData")

ped <- read.table("cache/landrace_parentage_info.txt", header =TRUE)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character )
#df <- read.csv("largedata/ik_files.csv")
res <- impute_kid(geno, pp=pp53, ped, verbose=TRUE)
write.table(res, paste0("largedata/bode/ik/kid_geno_", JOBID, ".csv"), 
            sep=",", row.names=FALSE, quote=FALSE)
###

