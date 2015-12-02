### Jinliang Yang
### Nov 1st, 2015

##get command line args
options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)

CHRID <- as.numeric(as.character(args[1]))
JOBID <- as.numeric(as.character(args[2]))
print(CHRID)
print(JOBID)

##############
library("imputeR")
files <- list.files(path="largedata/obs", pattern=paste0("_chr", CHRID, ".RData"), full.names=TRUE)

ipdat <- read.csv(paste0("largedata/ip/chr", CHRID, "_ip50.csv"))
nms <- gsub("p.*_PC", "PC", names(ipdat))
nms <- gsub("\\.", ":", nms)
names(ipdat) <- nms

o <- load(files[JOBID])

GBS.array <- update_gbs_parents(GBS.array=obj, ipdat)
# get probability matrices
probs <- error_mx(hom.error=0.02, het.error=0.8, imiss=0.5)
# phasing   
phase <- phase_parent(GBS.array, win_length=10, join_length=10, verbose=TRUE)

# compute error rate
outfile <- gsub("/obs/", "/pp/", files[JOBID])
outfile <- gsub("RData", "csv", outfile)
write.table(phase, outfile, sep=",", row.names=FALSE, quote=FALSE)

